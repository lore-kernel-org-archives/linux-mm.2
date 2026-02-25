Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68AFFD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165616B00AA; Wed, 25 Feb 2026 11:14:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F996B00AB; Wed, 25 Feb 2026 11:14:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CB26B00AC; Wed, 25 Feb 2026 11:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E29F06B00AA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:14:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C1131B717C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:19 +0000 (UTC)
X-FDA: 84483476238.01.A5C31E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 71FD840006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9OjAZugVPCx8r/+dS+ND9M3tTcf9QCbsN8AjDXYD3Wo=;
	b=wazzz4BQKiV83DbQtHwtC008o5Za38h8fGNy3marED/dJisQuy45nb84ECzV+ymE6BaRge
	oSKlVxq5Ysab+ZcS5hFlvZvU4FsIxoNYFnVqBV3K7kMYo9RB4l2awCrIbln+GcOTwfC64W
	QM0OnTXJxRK1zuB/viuzFEfhqND7SZA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036058; a=rsa-sha256;
	cv=none;
	b=byItPzC1wGVNhKz88fivHgKq8KVFdV5DL6IgxM7vmDnavCHuWN6VG3+qCM4xtomGNOl/P4
	RCd9OjBMiTl0X9Mej6oqfqu6BXMTOxOxJ8ez2um/kDliMypHJhz9BvCkZ3DwAcM1LxEOaC
	MuEiCbs5ezQEblee3n43X2hp63LtTVU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 605B644274;
	Wed, 25 Feb 2026 16:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9970C2BC87;
	Wed, 25 Feb 2026 16:14:10 +0000 (UTC)
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
Subject: [PATCH v2 1/5] mm: Introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK mappings
Date: Wed, 25 Feb 2026 16:13:58 +0000
Message-ID: <20260225161404.3157851-2-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225161404.3157851-1-catalin.marinas@arm.com>
References: <20260225161404.3157851-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71FD840006
X-Stat-Signature: ksmg9cktsypy6m9b86im7cefef9mmzz8
X-Rspam-User: 
X-HE-Tag: 1772036055-301917
X-HE-Meta: U2FsdGVkX188NmGDkpCSOMdNIdMg6zLfhpyiao1BMDAOGkxU8eDeAWAsG6LtZXm9+boIeGFMJwEtzS1St8AYTvGQhD/d8BYD1a1zS0HY3oM4DnWdBEe7+YTrPjA4YxQkoyRIcw8W6kAkdKr75NyidTeUPB1K+KZdJibLL1lbvpxN90cop9uMOdbEvAZTxx+Q6Uafu+ogkrqWqyPpVZv6qdI5g84t5Vv6gY6nBOKDtzsuYrYO7G/F9ItNX1KFpr0EIHpOogFewdP1sbN+EVBZ9nsQ4c8jCnJwOmZQzEUUe+u8c3UrLKrDeaAzgGPyEO6P+nclb7mKJ5m40kqJTje0SYIG/3TwyWACXpkJQG4koJu0wdkYJrRNfs+KbKskEH37T57/CP19xFo6PjQpiUduYE+BVoJ+suRrZNMDi09FF6eITaVsXEl/OnjCTpaUorSR0nG7og4Mi3hSGupD42HrmXOjr6uEjS1QxOkVGMkG6Ghn9L+QByWPRR3xhBG//VfBTStICTwCPGD9LP+/mtR4hEq7Tf3DoBU4LXDoTMIpgAQ8NG2YkMK8klAc2j5YZBqqBcmMIMrZR0lv7F1PdiLf4lh6t/I2ufnHRj99xiTbu4OywxhZSBwRKS9Kbi2dtFJClG4dkKC2CpLB+j5KVqKyAPaYskPrc5d1kUEeSfEsASguaig7qwfWD7Cds6Ew77oCrFxWAm+iq45Qv7s1hK2QqSgm99fff0lkxMerxX8aizSC+KbcIeFuDNSNOm9nRelE2Sc6a96INp2BtONoA9cyfWPVXtSvPh4vb6374JZKCNBs1TYHFkP69Ar6jMrAY881BfVju5IRLGNGj9AMSjhQUuS7pW8D9c9At3rNCFBfLOljgR+JlKj86qt4aaOHCvD2sFYFiu51qel1ircSbYptQ78PYw5bivZxGJr2mscDTVVZ6j4gjy18SxtbGg+pvEKDRcfQn9DaENh21OuuMpg
 ogaLGfdd
 hDsfKuOORFY6+o0tbLcT42dS1LU7bLTRGzb9rZSrkcRThOiI4qCV5m4GAuGZmLbZxuAwKPqsZP0rJOfranjR2SpE9BHJdMGqIZht8Nuffz3BhRRaAfORAmFEC3W0tKF5LWgLgoKwctPVTY2JC0ab4VfioXwk0WsswYO2lKKtF5lT0Dx1sZ9ZyF/xw0CMD3nTcvUmq4LeXmacaq+HXQYsw/jnIznKDtKF5mHt/WIRlo2OJC5vbogNX5j2RzdxBFBhUsBhByPtoMT526Uku7dUdZXFE8hqTOj7usZClq7rx/djIkxF0YYGWkOAdg/4ZAfCWPGBJ+lWKnQNhCRRb2oGwdnq0vupL09TEPmKwa3izZymnXATncYVzhLQEPjBqYgWHcsqXcc01AyIdjy2E+TBTQQ2IwJ/+rDkXP5M5JPZV70q/INeqkoYXa9rDrnLDQRVH+8BWQTlfzUsE0RfJvjsX68BdUDTXrLJbu+hwygeZWus1ANVI9qQJyZPHf08XrtpwKLQepz46Q0z1MUAUqYHTUw8jgz4Nr3Y0anJMZPI644iH/AHSE8OnUs4DFkYc/p/+r67G7lj8XidVYGs=
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
Tested-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/mm.h |  2 ++
 mm/util.c          | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..61071dd72eb6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3908,6 +3908,8 @@ extern int vm_munmap(unsigned long, size_t);
 extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
+extern unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
+		unsigned long len, unsigned long flags);
 
 struct vm_unmapped_area_info {
 #define VM_UNMAPPED_AREA_TOPDOWN 1
diff --git a/mm/util.c b/mm/util.c
index b05ab6f97e11..51f7f417e91f 100644
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
+		unsigned long flags)
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

