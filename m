Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A99C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856726B00A9; Wed, 26 Aug 2026 05:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE816B00AA; Wed, 26 Aug 2026 05:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705256B00AB; Wed, 26 Aug 2026 05:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 517CC6B00A9
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8424A02E6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:34 +0000 (UTC)
X-FDA: 85142870148.28.010718A
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf31.hostedemail.com (Postfix) with ESMTP id F20FC20004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qR9lu6jI;
	spf=pass (imf31.hostedemail.com: domain of 3Z6-OagsKCFw46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Z6-OagsKCFw46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735913;
	b=AxxZSyiIBzk0Q16r0PDBBx5z/RHyOSx/9SuYOd6xKDOOCGeDYkF65lwdiS7p26FMXByDfz
	akeqffJxvtibF8AsceqUbf1n99mPNuSqhkJCQA4/rOzlPQPzM5JXZu0gF5sGrf5kTUKoL+
	KIYqZ2BfiX4WqgAVRwHVAb9+MU8AyKw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJVghZcwIpdjw9VQGaPwDVy8Initc7amwnDZFFILhVg=;
	b=EBaoz5JwUUQh9hWdUVdryW2cxVBrkOYlw6Qq/scakE6zs7fBGqluxdCwSbSR6iYMjsdpG5
	nIDRPNa8ZjIPguPnIsyubPkxwKSmvq1UdzQVLCoek8djVpnPBvEAU1I60VtnyBWabluhzq
	Yy16B/ELnSZib/zC7PVKGgOIKRoSnNw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qR9lu6jI;
	spf=pass (imf31.hostedemail.com: domain of 3Z6-OagsKCFw46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Z6-OagsKCFw46E8LF8SNHAAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d02df2bf09so8164705ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735912; x=1788340712; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qJVghZcwIpdjw9VQGaPwDVy8Initc7amwnDZFFILhVg=;
        b=qR9lu6jIV4VvyC92H/0bH4W4tay2ecgjshyLcB5va0mOX+bacjoT6QkeHxTc/q4W9I
         R/yA3xNxpwZhkvOSGwyzarClVSgfNEv6dSCfkCYa7Z5FwcP796SmtcXtvxIoaac00ctC
         tCxvLU2q2WGWQIlKP2Kc0TNmp/WvA+cW7MX362I1MnBuIXNC1MQ+SQoPKOIIplNyZgRV
         y8cW0vvICSYZB3FSYn2XBNQT3/JundKBEWYifSe8iW68g/bg2146LsPKwTlJw6VUhu+g
         89xeV1BvbUxx4Z6oJiBeJwDfEeepQPI39jEm5JxZJanpIW8q+SMAQaV/IWY6714Inqlv
         oOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735912; x=1788340712;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qJVghZcwIpdjw9VQGaPwDVy8Initc7amwnDZFFILhVg=;
        b=B91ffSjwZP4OX+iTLEhwcNxzIKBHIbK2maH60kPh2HN2sSPG+Iz+n2muOVrcSw+TeV
         5vjhej6ZIFl/1mppz19zcjqZ+B4ASpvURH/xrd4ZmVCajAV11F3N/byLyRoONkTjclms
         SFVLJmPskGpbB0BToKbL6aVeRsljYoXTjQQH1UCqsKadthLZCtmJ+q7eW+IeDJBJyQZZ
         kwjelVYjVmG7hSPK/iuIYknScyRsXShQyWG4sfiwSYrsQHDm9kvkbH73rAc0sdQdXdJI
         W96IF7bYXgssJEbkGik7jZJq12FOVLATg2nKtzR3f7Zf+AQ2RbWkoBgws6KwK+jXjg91
         U1RA==
X-Forwarded-Encrypted: i=1; AHgh+Rq6fFj4+Qt2+/C9TRGfHmM3qjxk/5QkfDGK+QkuNgX5pAO6KA/Mdqm0qlLYFhVa2U438PCIAh6VWA==@kvack.org
X-Gm-Message-State: AFuF++lIjRjw9dqlnpds0gFuF/q2xnDG8eB5DJeZDTwRcYL/W5c9SoOX
	nw7aiApXsS6O08RABVk0hrf++ZRqrQ0bFmxM1YnrVjfiBUVGaQgMmPK/Ltrj1jtUFHQ8NEdTpGa
	zW7468j+VbGBHtw7N+FjReu4hbQ==
X-Received: from plbkt4.prod.google.com ([2002:a17:903:884:b0:2d5:e7d8:3c3b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce89:b0:2c9:e9db:8167 with SMTP id d9443c01a7336-2d707a5389bmr84223195ad.7.1787735911419;
 Wed, 26 Aug 2026 02:18:31 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:12 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=7723;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+ysynpwUlV0mE4GyFNOI2YE86y5cHwtUdkUTLphgh10=; b=iXQ98hLva2UqjB/f4knyONW86m4iuJ3Abi6gsqTTafU6aPgfFIfHAOwoBTVMp4Ow6urwELNC9
 5xa4bXhDH4bDKYAAom2V/fChZaiI/Jpko29q7zx1pnUbJXrCUv9ZgO5
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-14-0a15d8a799aa@google.com>
Subject: [PATCH v11 14/46] KVM: guest_memfd: Ensure pages are not in use
 before conversion
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F20FC20004
X-Stat-Signature: yn3q4kxjyf47or1bkesxgnzcpssr7bwy
X-HE-Tag: 1787735912-22253
X-HE-Meta: U2FsdGVkX1/D1s1OC31WMZtmZ/uouYbsNBLts2xxXxnoDiBilguFVzP2LOT99mEOCoZr4luQ7RGSh222kKm68P8CLydChadMw9fNgIbiKTMQppegTUMQSD+5tL2KG8h4VCTE0pYOkMy7RxLP7lys1j/Bim9oaENroEt36dI+CwtZCC1Gumyo9ki2uD4Eg/Z4Q3c78AkI9VwMkzMAHKdN1oJ8Hga6PYRoeX7nX8TL2QIhP4QPVDi+/ABNgjXIi0ONvJikZrOSqTycbCfxoaiesBXZBVLk7BIheKf1rdnu8q4307NZt80lSWTLD/0W7k+wTNfjL2vOXc09h3UqyRzvIaUGyNgViRh8bnQTcBFyhmp9WriGRLCNDhsdH0u1fIVMbokinYVBzYvgrv7Ndf6eDmcy8zfTGiosQFmvaUWubBigQ6JNx5cyQOVo8IeeYWu7IQsGBbXgYPgrXX8Bwbhm9ymxx1qakeSsLRhsKM7NX8qpjRVPgQxQJa1X6aQrjVDoBPjvAzkMShcoSB1+AkYu8VtFwAcqPOVCqIVlwjvU8vQgf6XKwu90YhndmvLnrMhyXK+NDgAOu8KjNEVP54DUyXp8hAiOVW/RPaC4HDDVCXhhwvb47ws4Z39pkUVIAYUCBOBY63jhWcLqVGbR2+jpAx0C27RKVi4tN7YM9cjNVBsDNUFpQz6X/OTIRs+JohltgAetX6BzRDm1ACAmYpRiAFjVLAxBB5GQP9p0Lfpk/S3AW3AbaFVaj0Rl3YkIPt2fCNhyTJr25AdKFMnLn56CxXq4nJhX1mEkTAzJigBTHtXYg4dK0c9C53R9GC1dnPKhDjJWEU6frWlGbmVN6fG0vArZMBwwVzdqhzIXH5J8HftTf0LpfXSMC+7AVXEMojprGPSJA9XtFau2PUH/qmYieNTc1kq/5weRVQCZdm2DweF6Py5meX3lhvok8OoikyEakQxPODH3DmsXOLIVJ8F
 x86abcrk
 yQTPWIV/s/gw+v2icfBub17hLE5qjjYF451J39LcT3kfFQzKcixcm+3u91siiBH4rMVPXKcXTVZpOCuGvdph7GxhUkvGjVoCHlu1zgd9mNCkzviVD34S8DFS07KHkRJP2wbVx9fQyKAw73lWs3ThX+kdHL/mccCCGG/K5sNZBFc3h2Uel+VVSZQVFT68wjoxqveAUa1yKifnWW2/U0Q0Q1z0a26KXIUIA10gFhQyn4xpbBBXHgixZRP1L7qzZYLVHgRUFORH9dpfso5HV80tG/CXdCb2RwshqVKrZyJW2PBla29Bzyd2F/zW2L9GdhWTh4jasHOyPxsUxpQe6Go2kkwwaxSel/bH1SKwf1A8numcvb2xm4jOI9H7de9iZU/FLhQ/7xybybudxghUlZlCkRLVvHUlYzRtOqNa9KaTkVywoeA1A1f/VWVZiYYBWa6GoCA+BIhTlJLLyoS2ADd4Nfs4ksQz3xjIqp3+yv/W0UVT3qnXr5doCtO5UFQ6yOpIKspID4U4MwKKZLXr7TgQ0Zue+rLeG5pQEtm6nhfTO+heERJrIVkZKuERSVDUWpwX3wyO8FpMYMNt0VoRdcF697U1JAmLnb9Tea6fW2rhhRiKBvJ4xjJjul2RjAiJXGSFDutj6msPZocXHk81SCMux9siUrBrsGrwI25jfHn9iOQCjtQ/GUxsWdq3joWbz6zrG2ooblWrEF07UHZamDz5Lf8YCAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When converting memory to private in guest_memfd, it is necessary to ensure
that the pages are not currently being accessed by any other part of the
kernel or userspace to avoid any current user writing to guest private
memory.

guest_memfd checks for any outstanding references to determine whether a
page is still in use. The only expected references after unmapping the
range requested for conversion are those that are held by guest_memfd
itself.

Update the kvm_memory_attributes2 structure to include an error_offset
field. This allows KVM to report the exact offset where a conversion
failed. If the safety check fails, return -EAGAIN and copy the error_offset
back to userspace so that it can potentially retry the operation or handle
the failure gracefully.

Update documentation to document the error_offset field and the possible
-EAGAIN error.

Suggested-by: David Hildenbrand <david@kernel.org>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 19 +++++++++--
 include/uapi/linux/kvm.h       |  3 +-
 virt/kvm/guest_memfd.c         | 77 +++++++++++++++++++++++++++++++++++++++---
 3 files changed, 91 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7aad097ffd392..f88d65b78c504 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6594,7 +6594,7 @@ KVM_S390_KEYOP_SSKE
 :Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
 :Architectures: all
 :Type: guest_memfd ioctl
-:Parameters: struct kvm_memory_attributes2 (in)
+:Parameters: struct kvm_memory_attributes2 (in/out)
 :Returns: 0 on success, <0 on error
 
 Errors:
@@ -6603,6 +6603,8 @@ Errors:
   EINVAL     The specified `offset` or `size` was invalid (e.g. not
              page aligned, causes an overflow, or size is zero).
   EFAULT     The parameter address was invalid.
+  EAGAIN     Some page within requested range had unexpected refcounts. The
+             offset of the page will be returned in `error_offset`.
   ENOMEM     Ran out of memory trying to track private/shared state
   ========== ===============================================================
 
@@ -6616,6 +6618,7 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
 ::
 
   struct kvm_memory_attributes2 {
+	/* in */
 	union {
 		__u64 address;
 		__u64 offset;
@@ -6623,7 +6626,9 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	/* out */
+	__u64 error_offset;
+	__u64 reserved[11];
   };
 
   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
@@ -6645,6 +6650,16 @@ which includes operations such as unmapping pages from the host or
 stage-2 page tables, may result in side effects on memory contents
 that vary across different trusted firmware implementations.
 
+If this ioctl returns -EAGAIN, the offset of the page with unexpected
+refcounts will be returned in `error_offset`. This can occur if there
+are transient refcounts on the pages, taken by other parts of the
+kernel.
+
+Userspace is expected to figure out how to remove all known refcounts
+on the shared pages, such as refcounts taken by get_user_pages(), and
+try the ioctl again. A possible source of these long term refcounts is
+if the guest_memfd memory was pinned in IOMMU page tables.
+
 See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
 
 .. _kvm_run:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ccbf7c475ec29..0ac9e6a790111 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1662,7 +1662,8 @@ struct kvm_memory_attributes2 {
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	__u64 error_offset;
+	__u64 reserved[11];
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2987611587b18..e4722eb6405b6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -538,8 +538,46 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
 	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
 }
 
+static bool kvm_gmem_has_outstanding_references(struct inode *inode,
+						pgoff_t start, size_t nr_pages,
+						pgoff_t *err_index)
+{
+	struct address_space *mapping = inode->i_mapping;
+	pgoff_t last = start + nr_pages - 1;
+	bool has_outstanding = false;
+	struct folio_batch fbatch;
+	pgoff_t next;
+	int i;
+
+	folio_batch_init(&fbatch);
+
+	next = start;
+	while (has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			/*
+			 * Outstanding references are anything other than those
+			 * from the page cache, plus 1 temporary reference held
+			 * by filemap_get_folios() in the folio batch.
+			 */
+			if (folio_ref_count(folio) != folio_nr_pages(folio) + 1) {
+				has_outstanding = true;
+				*err_index = max(start, folio->index);
+				break;
+			}
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return has_outstanding;
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
-				     size_t nr_pages, uint64_t attrs)
+				     size_t nr_pages, uint64_t attrs,
+				     pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
@@ -556,8 +594,28 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
-	if (r)
+	if (r) {
+		*err_index = start;
 		goto out;
+	}
+
+	if (to_private) {
+		/*
+		 * Forcefully unmap the pages from all userspace page tables,
+		 * and then verify there are no outstanding references, e.g.
+		 * acquired via GUP or similar.  Tell userspace to try again if
+		 * there are outstanding references and hope that whatever has
+		 * pinned the page will put its reference "soon".
+		 */
+		unmap_mapping_pages(mapping, start, nr_pages, false);
+
+		if (kvm_gmem_has_outstanding_references(inode, start, nr_pages,
+							err_index)) {
+			mas_destroy(&mas);
+			r = -EAGAIN;
+			goto out;
+		}
+	}
 
 	/*
 	 * From this point on guest_memfd has performed necessary
@@ -578,9 +636,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 	struct gmem_file *f = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct kvm_memory_attributes2 attrs;
+	pgoff_t err_index;
 	size_t nr_pages;
 	pgoff_t index;
-	int i;
+	int i, r;
 
 	if (copy_from_user(&attrs, argp, sizeof(attrs)))
 		return -EFAULT;
@@ -606,8 +665,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 
 	nr_pages = attrs.size >> PAGE_SHIFT;
 	index = attrs.offset >> PAGE_SHIFT;
-	return __kvm_gmem_set_attributes(inode, index, nr_pages,
-					 attrs.attributes);
+	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
+				      &err_index);
+	if (r) {
+		attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
+
+		if (copy_to_user(argp, &attrs, sizeof(attrs)))
+			return -EFAULT;
+	}
+
+	return r;
 }
 
 static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,

-- 
2.55.0.887.g758fc8c411-goog


