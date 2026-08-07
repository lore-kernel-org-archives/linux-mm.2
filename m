Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0556C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F23C6B00BE; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897116B00C0; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5F06B00C1; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 470346B00BE
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC192C01ED
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:55 +0000 (UTC)
X-FDA: 85075823910.02.11CE928
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D672C20005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HqpCL/He";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139574;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjrLE85nDg/sk6Kz0xFcmtsBLnNtrFZq+kptPBPzQug=;
	b=vDkToXW0d5Qon+WLnhAu5+LtrppRtkwpiqDQj45ih8lRSfYU4HfNLoVx6mWXjg19vNRxCq
	bEma6NbDBTcg8B17ngPiAFcthIv8j8/SbxvXc/nYZzlZK5K6sqVnlTk18QvLAeFoDsOVvQ
	0bYCiTXnJ3uPrSld6ZaELCPduH6mejc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HqpCL/He";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139574;
	b=C5wXtnrQ9AJpcY3dWyKre3rUVcvXzAyeZUQaa220dp4tQSJz2JYukZ6Pz4PL2GMdaoNMgR
	Khye5qnTT4H60QiiG/66/oHMc1RD8f8BMWZv8agnr/6oj7x9UaiveG1SFUuE6tm0P5+S99
	4AcBHTDq5Y4oDuI9mYzHjXqlCcDmzIY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B98045123;
	Fri,  7 Aug 2026 21:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAE8DC4DDEC;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=FyyHqquoBUWbUbzAMIdDVNoyKDJs/lRLdjMK8fj8r7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HqpCL/HerE/aatYQsc1HxAOrFNefqitw3BKBkpwzfGODBbaoPmuLx4+07IAyXkCzJ
	 M4mwfLjP2Txx5nIQlh0WacrTJ273mP65TrGWVKyQLo2qyjjiJYS/58R+teYnzjT1Su
	 1yW1KkeK0wM0R1+E0KYEvcf1u7hGs28wsVikQSokmT/Kg2D9xrNTjARloIeF7ggLIk
	 RKYIKNQLAlYnT6hVfpdwcOa+8VWNFUxolg9aKLpj1sSs2ErZwyTh+b1fpJ2uiFFEhr
	 SrLDe7VrZdmDYWsIg9l2GOP075BujEQHdPtvxcHp0/aDuWjtPGZVeQQlRBJ6EptJl1
	 jj1CnLu3IUgyw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC52C5ACDC;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:50 -0700
Subject: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=7232;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=LSONRx5cSknfD6LHxPz2U0/HXl5OqdyA76E4Ke5pn3g=;
 b=1uXwWm8T1P/DxIAqovl0eKJx3Y27+cP3JbSq7z1OKEBtMf6VoyKrfcLcLXNF0HF71N2nCEcok
 3ctvCEsAYlZBLlVrzbw3sGEX5zp6Fmvtnb+QCpQgGOfjp5Q7f0tt7pT
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D672C20005
X-Stat-Signature: u5bp8ecquyb7ma4ocfa9spab8j5ureau
X-Rspam-User: 
X-HE-Tag: 1786139573-471762
X-HE-Meta: U2FsdGVkX18q0ybMCSlsm0ZHPRBba3fYyEDzzKJ4oL2OFK/cTHsEmsSHVckzF+P0B5C/GXiDks7YXwlPvh4OkVOzz0/a+AalR62l/bpyP+X4SSQXXxKcXVu3VW00ni5+pdqZ28mTVw0ycUj0Gt7DThojiAZE9hCXLuKZJIQz0H2P9S9YZ6b6FKtJXDWF5q0AY7dmxIKIKhtS7LYxPV2n3oUNmqwltFBdicU4DFeesMAftcRV3GoK4YaPXRKfS0r+mneo8IBj9LcVxxl7e4PAo1AFS4nsD+V+t04eFG/EWOxtm5UT+d/Z91IPhzMQXyQoDvIFRqu6geZ3eXq8sDOk585DIu9Z4EiDG9oPclGnb0gn5siG4IxpYu1rtcAfLyozqeA9m/wkBUodyLRjh0PIUTgDMiwpiZORqsybhCQoWHjqceYktnInkp5m5JcHBI9LrT9WaOQesuOLg9Ed6XAAekXosIfyKRaQPIDUxyTc8Li5+pX4R0cJj1lwsKTWRAiz8j9dfPpudjpuKr+djD6m3bezzS74q1Pa90vaCJeIGHzeCJVOgZ1xS3XAb1wd8b1ZcZuEi8JpbcKO5fxbmXbRBW5G1igYq9ciNcDUNt+TtsUYDWE8Q1bxoTqZmlBZpQtCmM31ePIC2x6LuiCa6TtYDggLw59vh+pqtty1AFjdfHsRcRV58Y4pg/KOIaT/bmf2vGyHXBICNlaHWW76n9gf0gTLvcAYw2VIK+Y0uv5n7b8sK/xA006b2+hakMlbtnI/75Z32cLXcSaixneFy97Lto7PCo5b2ZHqtNqEbVhsYdLBstPvhra1A2yXZ+vFb2Jd3dvzyFntP5abmBfjewMeUe+pjWp6T99VHLUYNg508+cYzoGTwXn5tpHPpBZMtp1SZSvHabEK1uapixY+APnLnHDcQjU2Y9/OgJv50GuwwMnmbZs8M/PfJBfeXI0tC+1HfWhsSlRClaWTEe/DaE1
 c/9w+X3n
 LPuxzoVNXq3vNZKQHSGm4PYZNq1Q0tmKJFQ5mYiV6K0a269bXKr1WxP7YLx2mKo8pHO7SEYx5K+S1MRB4/3vCtwbK1ZJeB/igXHaS6E+7Gg3LIYuaEQWm8dLpmj0wEQdgZCs0jLiBrL7DwrTnv+4lsZSTbMswQ0QllQqUOaGu2GmbaPvPWImDMB+Kw/gCl0oExL3p96CGqiWiH3UluV+LJQ71a3H6zlQFrr3Mb4K5XmiKxFQDnJe1T+PgPwaaSpu8YNfGhG48vQpaY/UjMvARUMTvRLZal7UAxSz8NI2Kfr+4hudpT9KDWaaODWOkEVVf2ibzng0kZjiZdAK44DLBO4oyFJ0X0zCAztkOMJGDYa4Pf073gfqxwMtqdZJKagijaWNZK3ZZTvrYfRoVSK0F5njGjzHkZUl0Bshh3/JYvxlyW9uge0k6gTEPzagQ7gtqnEYSU5PVG1FxlBbLDgMSONWUlxFj37PCRhsoOhT80vHaLZnPJD/hQDo5O4BoxxHT2XhJhk/1faVtCMyil+W9go6d/QlSerXr43xZii3jopkt5ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When converting memory to private in guest_memfd, it is necessary to ensure
that the pages are not currently being accessed by any other part of the
kernel or userspace to avoid any current user writing to guest private
memory.

guest_memfd checks for unexpected refcounts to determine whether a page is
still in use. The only expected refcounts after unmapping the range
requested for conversion are those that are held by guest_memfd itself.

Update the kvm_memory_attributes2 structure to include an error_offset
field. This allows KVM to report the exact offset where a conversion
failed to userspace. If the safety check fails, return -EAGAIN and copy
the error_offset back to userspace so that it can potentially retry the
operation or handle the failure gracefully.

Update documentation to document the error_offset field and the possible
-EAGAIN error.

Suggested-by: David Hildenbrand <david@kernel.org>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 Documentation/virt/kvm/api.rst | 19 ++++++++++--
 include/uapi/linux/kvm.h       |  3 +-
 virt/kvm/guest_memfd.c         | 66 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1a3f664dbb197..1e64026d7c1e9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6583,7 +6583,7 @@ KVM_S390_KEYOP_SSKE
 :Capability: KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES
 :Architectures: all
 :Type: guest_memfd ioctl
-:Parameters: struct kvm_memory_attributes2 (in)
+:Parameters: struct kvm_memory_attributes2 (in/out)
 :Returns: 0 on success, <0 on error
 
 Errors:
@@ -6592,6 +6592,8 @@ Errors:
   EINVAL     The specified `offset` or `size` was invalid (e.g. not
              page aligned, causes an overflow, or size is zero).
   EFAULT     The parameter address was invalid.
+  EAGAIN     Some page within requested range had unexpected refcounts. The
+             offset of the page will be returned in `error_offset`.
   ENOMEM     Ran out of memory trying to track private/shared state
   ========== ===============================================================
 
@@ -6605,6 +6607,7 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
 ::
 
   struct kvm_memory_attributes2 {
+	/* in */
 	union {
 		__u64 address;
 		__u64 offset;
@@ -6612,7 +6615,9 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	/* out */
+	__u64 error_offset;
+	__u64 reserved[11];
   };
 
   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
@@ -6634,6 +6639,16 @@ which includes operations such as unmapping pages from the host or
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
index 80985e28e3b21..129d6f6303251 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1661,7 +1661,8 @@ struct kvm_memory_attributes2 {
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	__u64 error_offset;
+	__u64 reserved[11];
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3783e63476569..13c3989136f67 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -524,8 +524,42 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
 	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
 }
 
+static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
+					    size_t nr_pages, pgoff_t *err_index)
+{
+	struct address_space *mapping = inode->i_mapping;
+	const int filemap_get_folios_refcount = 1;
+	pgoff_t last = start + nr_pages - 1;
+	struct folio_batch fbatch;
+	bool safe = true;
+	pgoff_t next;
+	int i;
+
+	folio_batch_init(&fbatch);
+
+	next = start;
+	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			if (folio_ref_count(folio) !=
+			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
+				safe = false;
+				*err_index = max(start, folio->index);
+				break;
+			}
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return safe;
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
-				     size_t nr_pages, uint64_t attrs)
+				     size_t nr_pages, uint64_t attrs,
+				     pgoff_t *err_index)
 {
 	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
@@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
 	mas_init(&mas, mt, start);
 	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
-	if (r)
+	if (r) {
+		*err_index = start;
 		goto out;
+	}
+
+	if (to_private) {
+		unmap_mapping_pages(mapping, start, nr_pages, false);
+
+		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
+						     err_index)) {
+			mas_destroy(&mas);
+			r = -EAGAIN;
+			goto out;
+		}
+	}
 
 	/*
 	 * From this point on guest_memfd has performed necessary
@@ -564,9 +611,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
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
@@ -592,8 +640,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 
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
2.55.0.654.g21b8a5bc05-goog



