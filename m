Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A99A10AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17F06B00A1; Thu, 26 Mar 2026 18:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA27B6B00A2; Thu, 26 Mar 2026 18:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A908F6B00A3; Thu, 26 Mar 2026 18:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94D376B00A1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A53C1A0E44
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:54 +0000 (UTC)
X-FDA: 84589645308.30.BA4BEBF
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 81AFB1A0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q4RfIpjJ;
	spf=pass (imf19.hostedemail.com: domain of 3MrLFaQsKCAMdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3MrLFaQsKCAMdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q4RfIpjJ;
	spf=pass (imf19.hostedemail.com: domain of 3MrLFaQsKCAMdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3MrLFaQsKCAMdfnhuoh1wqjjrrjoh.frpolqx0-ppnydfn.ruj@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563892; a=rsa-sha256;
	cv=none;
	b=UYeGT2n3Z5KGQ9IwGI52A9NOl26VpoxRyD7gMQxplI8vKBSp1jczG3XCBqHvAy4NZuhlqN
	slqs8h8vM9H+tMx0reHsQdO4+b+1E+ZhGV05uOH4x8C8D09iBY3BjOVSHW5R7dG3Le9aAc
	vEPnWzErD79miSknaskMRXaFszH8KOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRjeBkkI/dZyZ5QjbTq8w6K/fHOt1rR7cB2loz7QmY4=;
	b=oDru9+wshUbfDqOMRbtjBAEL2MtBiVDLFBf4m4ZMIFQjYk8bQA0HfNmNF1tA/0k+LdW2Vi
	RoxiuXF+paPSxDZK2JhBnRXF7MhOjYj15zBbt/vZag1wm5cVPr8BIfWvMoZZWu2UMlEi6a
	KSTyx1dPmx2Miq3x4CpcIva5bjRpef0=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c7414516609so1053004a12.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563891; x=1775168691; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SRjeBkkI/dZyZ5QjbTq8w6K/fHOt1rR7cB2loz7QmY4=;
        b=q4RfIpjJRtwR5hNwcC9vqL3mrYgIy13rpZQ0W/h59e66vKDfr7Kt97iznM4b7OA1Uc
         BWPSNbNmD3+Jgp3QyUI6mNlbiY02v5FIB/EGwNv4GsIVC5AluzySe+4b3NR+4zDk12tc
         cjRdO3L4Dlt/Ie/VegC0A6CxYFAzJa+l2KG3MOEzuvUJMJ+NATvpvdHM419PxbuBy9dr
         T+Li9IalZmdLfAxc2oN0SN8ML9xlCGanf4P/xQ8gi0SCHwTvN0liWgcqtjyyEnEOrUWJ
         PyN29HYVc5TPu2wjzfjml+XymQukdHs72CIUrzI3ICfq43UAm67gyMH90zyGTXxxXvbc
         aNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563891; x=1775168691;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SRjeBkkI/dZyZ5QjbTq8w6K/fHOt1rR7cB2loz7QmY4=;
        b=GJY6NVpiAMsR0hTLy4rx/DG3yp7lUP7NIQ2LaLFdC4NFPt3co2Yq1+o8tTzuu7vC8W
         8NpbubRKwFuYq6yVi0dYl2rZ54XXVKb1MOUMnbkX6I9vA0cqVjgSrltfLC5/l1zU3zcj
         BGnnR2mWeGodw8ilzC7d4nVNIyvYKc/ph4fAyUBwcLKde3l6ySQcJYKnovUU1Yw/uxGM
         WzpPxlToeQqVpRd3iqlP3LWMsIzCst2cE3Spqf8S6ZFdxWdkMAhvpfN29GzotFa6Ntik
         FktBhhzdaQxB/3mLHt77ARx2N8ZsAmuHgPr/ZTfDGFECiDp8UleDeRqohzEFNyFCdPMi
         714Q==
X-Forwarded-Encrypted: i=1; AJvYcCXP4VzI41qs8nHbgZWerUTNLeV40goIwiI2wJjPmYJcOuSkcy1d5AitJg+QNqK+83PDq/igob8I1g==@kvack.org
X-Gm-Message-State: AOJu0Yw8k0UUSxqK8UHa9nCwcPY4v9EnmdoIFIEGxchTR+8oWU8jDyJE
	bh5hZ4JIlSlFsQs/9dcGlPWYzEHUiaDkVSYs5IHL6y+7nsRUkmSZOVHPrWGEzFtDB2qzGBZnc6u
	9mg516rEiXZWMBsEhHmaPagUroQ==
X-Received: from pfbif3.prod.google.com ([2002:a05:6a00:8b03:b0:82c:2477:2e24])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:c82:b0:827:2ed6:888f with SMTP id d2e1a72fcca58-82c96035be6mr118926b3a.54.1774563890837;
 Thu, 26 Mar 2026 15:24:50 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:22 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=8571;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=eaxuIPrrRTVlEIpTTwJih/3FgUZ9QiOBP/yNtBEER/o=; b=K13+dJQF86Un8WqHDlu2mJRGc8cKb+wpv2mI96f+F2KmJrbn1NkIqQIwXR4TQX2NsGMI5IGiJ
 7CZ1Zrr9V8EDdHQVj3N94MUmpF4t1bK7IW1kpMbQXoeLH/p6zBbG6ha
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-13-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 13/44] KVM: guest_memfd: Apply content modes while
 setting memory attributes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81AFB1A0008
X-Stat-Signature: g89ye633owapndo1op5jikiyc6heotrw
X-Rspam-User: 
X-HE-Tag: 1774563892-408509
X-HE-Meta: U2FsdGVkX1/wPAhrApJGwPU2yVbepzUdqdALtzvYxOqutU83QS5CrrnXOx21uigyAzsnRZVnwWOcAArXJdVWaHqoG0MxLOLzsmHDtlpK+NAA9zwYazMOHA5uM4Je/IS2ixFvV5tdpfzm+sQTeX/59574mlj+qWf7iOtULTRii+WfMZgzERjpwVs2eQ01Ayk4HEhu0aW9IJ3S/O+s4rx/CueW37NQMF9SSdjhADQQykAr9+cSwGELJ5DoUihz+i0mLAkIhB/QlJJsMFtSD4y9K1F3Pkotrn8z8h9FPejT9jCf/858Js9Z+6+6a8vBxHadf/1l3+24X5aDKcnEzQjZMzvJyYCyQqARcr8kwKytJsnpgIuPeE9YfT0mYRIU0qLN3ITjn3BJEzP+fEeMATSxDUPpVJi352MQicRmNQptuAhmKdq/0ptsYG42YT4IiY/enBooDF4q1z65Z99/KWiTGQUUHBfz/QmcFr0MF7RDm4V9NlRJmnYhtml9asrKGp8xp86Kz/ZrTsHsXdoXbEN/YTFSqt/60KZlZis3cwBQz3sJqfbtEVH3orAp2ASOz+Nv9NHWsjYIgGdB/RJFgqjfecheKDREu/8JhcKAVd8cSen4r3gp+yDiSyzr2W/KY+MzJq8LtDptF37nml1cZ37a+Bx+7JX+M4TQbixBGyk4T1dfgvDS8UW0iFib7oAcg/waO4tSEyzsoCjwFdu1OuszbLKtZUhQsI56q2Cz9sH8Fpc0p9J8dqvvO76FEdrS8L9t44WW0n90MGQJEuI/eRZo97UOkNM0SNfw/9mJw1C+NrLSuII4gDarHc6yOiopUJwxQ6NlKi7E0AQMGBpSPrPhK2pnrU4zevlWdtKlJK0BRH63mQgwSo8OvVBrBf2e6DWCDn/DL8TwjcdPwlyqSIxbK0ytkZUp+Cl0DzvAW7lDOI7zFPMm5DxUPCiT8SR1/HwjXETUto5FD9ym95p4bkm
 WQBH/mf4
 fMRRpLqLIx4kX1A050pHme4GRmbw8jlb6sxq59Zh9AcTbDhhjsgUdckdpwoDHo8ioxccaMHR6ZFn29oy0Ffjzf35GqX1zZhv8EE31Zo9JfM7aEmikdzFYEcQ6aB5+vcdl5VCMtZbHMwK0DzK6kk7xNnI0idxjy2fTSiM2HQQUbwUM9/imEz4E88FgVHjBf/6m24QftN1a6wMs/s04mt/BrAia3MLEDcLewxPi7TZoeuoaphLIktolEh6tbbz/CI7PY2YA5czo2PCmqjxOumZCZM/OimA1jqTny7g4N2tRHOoYl2LnDWQ4iP58SCy0rzmZg2tMZsO5lFkRiNSrt8AiAj3HYXXMQmw4O1jD74hCZOzxs+BL/TJFnLJB/0NVCS3Ahs722gjKLCWMReZazUJmPCOCxXugOptJU2yw8LALylV48ArZYnrnW9+qpKNeLCpb3Dn5rdQGhRVfnLEEe5MP9I2WVT9h8Pg1jv8ceGnzorAsvxK+CVIdKF72ImdXkvqeIOHPpvP+RKxJ7BTS+B84hcCZC3nETZzMl3qAMnFYFqqtiTRFZMedveBjKhJIjbc+FnZ2eL8EMlDg0YYbGZk86mu2GmAKgG/rGtQzRbfyP2jwM1rLCfK24lc/+JOqE6COu0js5nyCjeSeLmWgCkWyESwgwPzrSRC2zA6plXO/yxW1yVZ7Vak4MfGqELUuuvRdrHVjkKDhYF+9lDYo5i50dmnLPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide defined memory content modes so that KVM can make guarantees about
memory content after setting memory attributes, according to userspace
requests.

Suggested-by: Sean Christoperson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 61 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  4 +++
 virt/kvm/guest_memfd.c         | 56 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 15148c80cfdb6..90587a9c09d3f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6571,6 +6571,8 @@ Errors:
   EAGAIN     Some page within requested range had unexpected refcounts. The
              offset of the page will be returned in `error_offset`.
   ENOMEM     Ran out of memory trying to track private/shared state
+  EOPNOTSUPP There is no way for KVM to guarantee in-memory contents as
+             requested.
   ========== ===============================================================
 
 KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
@@ -6619,6 +6621,65 @@ on the shared pages, such as refcounts taken by get_user_pages(), and
 try the ioctl again. A possible source of these long term refcounts is
 if the guest_memfd memory was pinned in IOMMU page tables.
 
+By default, KVM makes no guarantees about the in-memory values after
+memory is convert to/from shared/private.  Optionally, userspace may
+instruct KVM to ensure the contents of memory are zeroed or preserved,
+e.g. to enable in-place sharing of data, or as an optimization to
+avoid having to re-zero memory when userspace could have relied on the
+trusted entity to guarantee the memory will be zeroed as part of the
+entire conversion process.
+
+The content modes available are as follows:
+
+``KVM_SET_MEMORY_ATTRIBUTES2_ZERO``
+
+  On conversion, KVM guarantees all entities that have "allowed"
+  access to the memory will read zeros.  E.g. on private to shared
+  conversion, both trusted and untrusted code will read zeros.
+
+  Zeroing is currently only supported for private-to-shared
+  conversions, as KVM in general is untrusted and thus cannot
+  guarantee the guest (or any trusted entity) will read zeros after
+  conversion.  Note, some CoCo implementations do zero memory contents
+  such that the guest reads zeros after conversion, and the guest may
+  choose to rely on that behavior.  However, that's a contract between
+  the trusted CoCo entity and the guest, not between KVM and the
+  guest.
+
+``KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE``
+
+  On conversion, KVM guarantees memory contents will be preserved with
+  respect to the last written unencrypted value.  As a concrete
+  example, if the host writes ``0xbeef`` to shared memory and converts
+  the memory to private, the guest will also read ``0xbeef``, even if
+  the in-memory data is encrypted as part of the conversion.  And vice
+  versa, if the guest writes ``0xbeef`` to private memory and then
+  converts the memory to shared, the host (and guest) will read
+  ``0xbeef`` (if the memory is accessible).
+
+Note: These content modes apply to the entire requested range, not
+just the parts of the range that underwent conversion. For example, if
+this was the initial state:
+
+  * [0x0000, 0x1000): shared
+  * [0x1000, 0x2000): private
+  * [0x2000, 0x3000): shared
+
+and range [0x0000, 0x3000) was set to shared, the content mode would
+apply to all memory in [0x0000, 0x3000), not just the range that
+underwent conversion [0x1000, 0x2000).
+
+Note: These content modes apply only to allocated memory. No
+guarantees are made on offset ranges that do not have memory allocated
+(yet). For example, if this was the initial state:
+
+  * [0x0000, 0x1000): shared
+  * [0x1000, 0x2000): not allocated
+  * [0x2000, 0x3000): shared
+
+and range [0x0000, 0x3000) was set to shared, the content mode would
+apply to only to offset ranges [0x0000, 0x1000) and [0x2000, 0x3000).
+
 See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
 
 .. _kvm_run:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 29baaa60de35a..0fc9ad4ea0d93 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1642,6 +1642,10 @@ struct kvm_memory_attributes {
 /* Available with KVM_CAP_MEMORY_ATTRIBUTES2 */
 #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
 
+#define KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED	0
+#define KVM_SET_MEMORY_ATTRIBUTES2_ZERO		(1ULL << 0)
+#define KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE	(1ULL << 1)
+
 struct kvm_memory_attributes2 {
 	union {
 		__u64 address;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e270e54e030f0..eeac7678fcf4e 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -677,6 +677,19 @@ u64 __weak kvm_arch_gmem_supported_content_modes(struct kvm *kvm)
 	return 0;
 }
 
+static bool kvm_gmem_content_mode_is_supported(struct kvm *kvm,
+					       u64 content_mode,
+					       bool to_private)
+{
+	if (content_mode == KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED)
+		return true;
+
+	if (content_mode == KVM_SET_MEMORY_ATTRIBUTES2_ZERO && to_private)
+		return false;
+
+	return kvm_arch_gmem_supported_content_modes(kvm) & content_mode;
+}
+
 int kvm_gmem_apply_content_mode_zero(struct inode *inode, pgoff_t start,
 				     pgoff_t end)
 {
@@ -736,8 +749,26 @@ int __weak kvm_arch_gmem_apply_content_mode_preserve(struct kvm *kvm,
 	return -EOPNOTSUPP;
 }
 
+static int kvm_gmem_apply_content_mode(struct kvm *kvm, uint64_t content_mode,
+				       struct inode *inode, pgoff_t start,
+				       pgoff_t end)
+{
+	switch (content_mode) {
+	case KVM_SET_MEMORY_ATTRIBUTES2_MODE_UNSPECIFIED:
+		return kvm_arch_gmem_apply_content_mode_unspecified(kvm, inode, start, end);
+	case KVM_SET_MEMORY_ATTRIBUTES2_ZERO:
+		return kvm_arch_gmem_apply_content_mode_zero(kvm, inode, start, end);
+	case KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE:
+		return kvm_arch_gmem_apply_content_mode_preserve(kvm, inode, start, end);
+	default:
+		WARN_ONCE(1, "Unexpected policy requested.");
+		return -EOPNOTSUPP;
+	}
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
+				     struct kvm *kvm, uint64_t content_mode,
 				     pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
@@ -752,9 +783,23 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	filemap_invalidate_lock(mapping);
 
+	if (!kvm_gmem_content_mode_is_supported(kvm, content_mode,
+						to_private)) {
+		r = -EOPNOTSUPP;
+		*err_index = start;
+		goto out;
+	}
+
 	mas_init(&mas, mt, start);
 
 	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs)) {
+		/*
+		 * Even if no update is required to attributes, the
+		 * requested content mode is applied.
+		 */
+		WARN_ON(kvm_gmem_apply_content_mode(kvm, content_mode,
+						    inode, start, end));
+
 		r = 0;
 		goto out;
 	}
@@ -786,6 +831,9 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	if (!to_private)
 		kvm_gmem_invalidate(inode, start, end);
 
+	WARN_ON(kvm_gmem_apply_content_mode(kvm, content_mode, inode,
+					    start, end));
+
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
 
 	kvm_gmem_invalidate_end(inode, start, end);
@@ -807,7 +855,11 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 	if (copy_from_user(&attrs, argp, sizeof(attrs)))
 		return -EFAULT;
 
-	if (attrs.flags)
+	if (attrs.flags & ~(KVM_SET_MEMORY_ATTRIBUTES2_ZERO |
+			    KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE))
+		return -EINVAL;
+	if ((attrs.flags & KVM_SET_MEMORY_ATTRIBUTES2_ZERO) &&
+	    (attrs.flags & KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE))
 		return -EINVAL;
 	if (attrs.error_offset)
 		return -EINVAL;
@@ -829,7 +881,7 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 	nr_pages = attrs.size >> PAGE_SHIFT;
 	index = attrs.offset >> PAGE_SHIFT;
 	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
-				      &err_index);
+				      f->kvm, attrs.flags, &err_index);
 	if (r) {
 		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
 

-- 
2.53.0.1018.g2bb0e51243-goog


