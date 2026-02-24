Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE1DF4BB6C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7254A6B0089; Tue, 24 Feb 2026 12:58:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF5C6B008A; Tue, 24 Feb 2026 12:58:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D1F86B008C; Tue, 24 Feb 2026 12:58:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD726B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 186EFC14DB
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:12 +0000 (UTC)
X-FDA: 84480109224.02.DF97EA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 94BE140006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771955890; a=rsa-sha256;
	cv=none;
	b=Zv+lzYaOIlZ5u4riN7i7JSQtQhQ804U4Dm3cLLE/Osryl0u++L6Fduo2LEslWoGL/37304
	dzsfKqgSoT+Jx9DpiKRUgyxpq5CxfaDEiwDL/hR00E+jd4FZ1PsegzlZPqC+E+I6+E3CfX
	V5Lzqyd7WoouVubpSieqV3l09KGuWlo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771955890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OKnrDzCUwa89CjqkQK+aELBLtJlIYA6cfH4PLt2AKb8=;
	b=fBYOX/Bpo6VUMVxvhfYQjwvUpaH1CQx77LdmR1WvsvdKAdyPdW91q9MLJeSUqdUvVOFZbx
	wWjIlG/2DPDNngrF83IZ7A3swwcX/xMYjkfakPSrqdZF0S3Z3zIH9ehzeOPXhXN8cOZgI1
	zdOm7UuSF0YlKiSNCSl1ctF/Dq5h4YA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2439A60130;
	Tue, 24 Feb 2026 17:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCD0C116D0;
	Tue, 24 Feb 2026 17:58:06 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 1/5] mm: Introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK mappings
Date: Tue, 24 Feb 2026 17:57:53 +0000
Message-ID: <20260224175800.2500729-2-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224175800.2500729-1-catalin.marinas@arm.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94BE140006
X-Stat-Signature: fzatwet374x31mjkkcoddmy9g6bduy5g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771955890-168484
X-HE-Meta: U2FsdGVkX19DSGbFTFPiVCRMEJuIOD9//JfDcPj5GZaZJQtXQBth3sNpSQ4Gvxow0I2N+ZOw3uTb0hIwNWWRzFYOB/TMa/JcvsBpJFbPtSHIdcuPk0GBSW47N/DYJD5xDbYP6mCMSPHtGyus/WogVg/JXuEIsZHwpNduGH/KwYemn5wHfauxZJimh0gnhwRXYVROwpIa5kazCfqA7Q9gyZ9+eeLmbYVKDde9fyPJoKKHlGKj/LmrtifdtGMOBdi346upDtr/k/mEC9+Xxj+agS4vAfkbOtR3iVFXrZ9Eu21kSmKMTiQ/2k4Qq2rVcsnJdnXfwQYTmBcKYDaq28kzQz8RAgJ+CcEIhsU/9IKRO6O2whul2ZPLKfKtE2glIKCnySX0fAZNJnb+MCo0waphdjFcD2+9FEOJSWp/65x74zjM68aHwfkk999H5cE2ZI1DSbJOGMtCg16GfxdKX2cCKD0mPkadYdHXvLQgRNVcyMxq0tI6ZbcBg1iYoT935vVa0WzNesTGSAYS53Hq+2azGlq9npxJdPXwx/ue1k3Ju4bZ/Q8hm+6WhH2SCEaDF8z7EqklmJsHj8WkOn6oWP+B0GM9qRL7RXYd/399j7Woq6Nj9HYGQda2wo+70+bmOHFAzMFj9JCvkaJOTemTj28E48OgsuCjRu7tWM0WKEQAPGpqUTZRhVpldpGQJanspcKxsuSsF3UMkIJM7WI7RudxooZ1m1w5PDxwz7h6JNc4x9DRlVD5VJw70XLYQmZPNpOj6ZB0KlmZVxns4jWtMJ2MvJLVYIOC2tzKOmkaOg3e+/YN/pgHETkxpNYNvGDFxLlX5A4yub/GBNT+8aoXMpmGRVIl5kzpwmmLfyMQLlVmfz1REJXarP9H7ldjMmjLXHZf6NSCLhymHPS/4xlPPKqYsmRS3530SSNVVDCBoXOZjJ+fPaQhnzt9DUFG5aap6p9hMc872ZnIkmjmsov16R+
 g+dNv6ES
 LnTHxnnnnJQGukxOtYkn9wP3csQADU2BsO1KIyiS0Io+2BYjr060GuJOjyyu2ovfvRIm7u9W84fhZqcnT4+0kzA6vcqXECBFUc9VXszd5yXF/ka8t71FNSuLSK3O+RCaQpduG+GLdHu7j1ySk27WejAV2KNHbBmmlosMaSFDdl4Qkz4E4KsPcL/fwJQElxaJeUx1mt8J6W+1WObQbastO350r2/XulwnzdPQoSZkoFGPs+DyaGDFekEsLI3RXJnin5ru3WCP+aVjyZ1JSPKy3sb+5RNAd1C1psueftO1+8rrVjCslVNQWr0NO/3ViZzQizZALyQKXV4cjn9ISZ5vfGrlcR5sG3mVGl6P+7IgXyByWePP4dGMtvWC1g9HKEDuKmc38OV/W9BEFd6BCa8dglan/6DaaLxwJNTtG3J1ahS2bdNEssb3Bt+4SBmjp6U1PCnFdRndbIFOkUdxxGc8SU3pL7Hb1YOy+Tgf11Gq9dY773EwMH9c2Bd/1NIMygBfu9pd83PHpnUvMzk/MrB+xEfGOpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arm64, riscv and x86 use a similar pattern for mapping the user shadow
stack (cloned from x86). Extract this into a helper to facilitate code
reuse.

The call to do_mmap() from the new helper uses PROT_READ|PROT_WRITE prot
bits instead of the PROT_READ with an explicit VM_WRITE vm_flag. The
x86 intent was to avoid PROT_WRITE implying normal write since the
shadow stack is not writable by normal stores. However, from a kernel
perspective, the vma is writeable. Functionally there is no difference.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
---
 include/linux/mm.h |  4 ++++
 mm/util.c          | 25 +++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..1f28be975f86 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3908,6 +3908,10 @@ extern int vm_munmap(unsigned long, size_t);
 extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
+#ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
+extern unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
+	unsigned long len, unsigned long flags);
+#endif
 
 struct vm_unmapped_area_info {
 #define VM_UNMAPPED_AREA_TOPDOWN 1
diff --git a/mm/util.c b/mm/util.c
index b05ab6f97e11..2592291948f0 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -618,6 +618,31 @@ unsigned long vm_mmap(struct file *file, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_mmap);
 
+#ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
+/*
+ * Perform a userland memory mapping for a shadow stack into the current
+ * process address space. This is intended to be used by architectures that
+ * support user shadow stacks.
+ */
+unsigned long vm_mmap_shadow_stack(unsigned long addr, unsigned long len,
+				   unsigned long flags)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long ret, unused;
+
+	flags |= MAP_ANONYMOUS | MAP_PRIVATE;
+	if (addr)
+		flags |= MAP_FIXED_NOREPLACE;
+
+	mmap_write_lock(mm);
+	ret = do_mmap(NULL, addr, len, PROT_READ | PROT_WRITE, flags,
+		      VM_SHADOW_STACK, 0, &unused, NULL);
+	mmap_write_unlock(mm);
+
+	return ret;
+}
+#endif /* CONFIG_ARCH_HAS_USER_SHADOW_STACK */
+
 /**
  * __vmalloc_array - allocate memory for a virtually contiguous array.
  * @n: number of elements.

