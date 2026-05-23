Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58933CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0B36B00A9; Fri, 22 May 2026 20:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369016B00AB; Fri, 22 May 2026 20:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B416B00AC; Fri, 22 May 2026 20:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB676B00AB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4704140887
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:10 +0000 (UTC)
X-FDA: 84796772340.09.F2581B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id ACA7714000C
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLvqSEj0;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495488; a=rsa-sha256;
	cv=none;
	b=ctJL56TvI1iQh4i90KSKgO9V/Ra+nekfqu7ANl0Rw4T1eFcGTf5qv6H44xBLJNcnV5i3U/
	4aGpRC7OZZaRkcMY9tDaTW+flMLOC+i9bdWyUuednkjUzXMiwwf9M9unByRTZk3Gq16ZHY
	5KSz5rgxAV+RyaLneuzJDw/sUByfoX4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kLvqSEj0;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPLjnpJshLw5qkN+0kr/bpzub4uFPC2t1YE76aipSRA=;
	b=KYbZJE205bwRkAuDoTH/Urwm458Mn5rpXMRrhXm4Qny3N7i3mUybAASpi5ayMkfDT+T1Uw
	z6uqWm+uMDcZmQlPpwxmGefaHcQ98rurD2fvpdQCi2euCwxpGAcyyHMrzaUk/otzrekSmw
	RdXYJA9JL9OkmZbmNCYt5TAY0td0e5w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79F1B445F2;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0FF3EC4AF67;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=0ECVEVBkOWP4qU1yQu82KydlPY9WQUdkOibk73+w7KI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=kLvqSEj0CRM4A5mvC1WSttgzNkrXIUnXqZCnL8LrC/MmIExIToPjl03n+gOiA3N6z
	 IOFqudd0YQYH85F5UAGiCU2EB+S0q5s4mxiIU1nxd+tRYXM/oGbpj+m/IhaeKUxrDu
	 OhLRc96JAag6nclmIrcJklWiP+4xHBo3wWksqpef9bOYNtvD0L4VGVJUjjstOOYdQN
	 JlaHqm39Fkzw2AzGxfKJqcvv236JG6cZwQKYl5IKy7jvgrzGia2Di8a24x/Ryn0qf+
	 noL5rCPT0lm85Pl9OQnl10bsFQDJmJgxYR5qLv2qHd7qONzEx+4l//ApcEOrkuFg9H
	 HDmJCNejWVB9Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB54CD5BB0;
	Sat, 23 May 2026 00:18:03 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:52 -0700
Subject: [PATCH v7 10/42] KVM: guest_memfd: Ensure pages are not in use
 before conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-10-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=4831;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=cnZFLwTLg0Lwy0rZo0cUvbWemQ2hZvl4OTIbiNEhnVs=;
 b=64di4loWw6cUcML/ICcXk1/lgktF4DU2Ztv1qt14+J+T9DcX3g7s7ngiKohYx9NXdvr32D4nH
 0J9OaMGGWnwCo1LTY1D2moCiBYi+bixvOx3z/RAehg1/SB22aMaEbRn
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: ACA7714000C
X-Rspamd-Server: rspam03
X-Stat-Signature: yngxcr6jb5bhxizeg4dypeoqb837eqdw
X-HE-Tag: 1779495488-818480
X-HE-Meta: U2FsdGVkX19n4aQLE3aZkF0Kdkk/J8oAlAWX8SHr6GM7A/971tZ+jdGXbuP5okAQ6gJBXPD+6O9OdszuDwhwB3VqXYvOdzJ/dhJJuJJ9jV2gTVlDDq5plizUJPoJu4K7NDyolU8JlZkKQHH4Qvs707oSDNNU+6OdFAH4RuFy6OYM95ga+38WyaSlP787ABcPqESJYDDLl/t0jidRavqgpZuV3yw5friQfouplm29LnodRi+XLvMO7QitFEU9dV8LgUPqvBpFbCvzTkHfSea+hKueC3XIgz6sojLmXa7b8JSXEYydmxcOHhsq3rdG9007ZIkqpsOFLeVIeQlJylTkRlLvZ4NgwlJFcFjilyOd8l88F/nktzSb5ccr4OmYvhxSAM+VzTfDmX6o9QBaSZ2HX6XEY8DQfGjy3c8aOSt8DntSkkDZWbZ4MWk8R6/ZxIRx9s01qK1UC4KD4/xAaDVuk8u5er/u5pobESbm2XVHCfvUqGuA1iiu6hl49KEGlCdb5OrfVINO7BmbLqMidpv/tPx8JcSJ3LA1YkzgHjQFG4i01/6zteocIRQDczNQ6nqzbUEMlvauoSe/QoZ/ch/KNiOP5VOkRLeQhUHd4q4H3VYTV5NYXrw8RhBH7OrnTxPAZok7shJHRLi9MBBv8cdQvmzkdIUrzU9dLJ1618DNGcxTDUeLr1jAXn5brd3NElkCi2LLPe/usL/aOBst2Crt3i8KBG8+VZjcvEPI1q9yuQfu34FWdSdFglN5Lf2OCdLQuUe6R0ZolU1Tx1hT8yVJo/e6z+BD32SoHRGELT8gAroNcVotGh8/aUxU7FCH/HFBXAG5X6hZr7uMBNxWa2NXbXqWIPu+fC5dz2exFNsZHH7VxaMFA9u9sprlh/jAIUr8WfDoQwdDfqAyFCIxoCF/m5z6mukjr+82TNhF0mCjFhIz5eWPl+P1f0Ms/A5eUTof2d3nM/GJqK8lMDVTSAr
 iRGE0M95
 c93Cr8rh9lKZrq+HeVNSbYuP+GYrgVvptsegMQRS517cDhxIPNR9qHOODr/QY890QayhRs9HEtGFxO1LzqnjhaKn6VPDBksHI8cv5/0tWz/1fhgZGKz63YEknhLYsJ9gf6S7jSpPfJmGaLABrhROcrsY+Gb5mmYlsMPfSLtyM5I+uPL8FjgH1hQ03tLmfm1VKSIqISqTgeQgw1ADAJvHCikWUOdnhjtmKeIZTZoiUl3vz/FJUwb3toWVtiEH2LI85d6BkiWmpmSbPNSq5/jMW+FgkTllaLorRlRGJ9Mln5XGgWwEH6hzd7ISfpMxT4y3zh8wQtDujPI2rN+sAGGln2SmQxxFnS48z13te3yiG+0BxNjZvEKmKC/liYwXwCUQUeWvEkW8iniGirpJDIP7F8mhkMDvDMAyp5PtdSeDyv0NJQbtkPjqYM/quoSFwZpEUyQAI
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

Suggested-by: David Hildenbrand <david@kernel.org>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/uapi/linux/kvm.h |  3 ++-
 virt/kvm/guest_memfd.c   | 68 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e6bbf68a83813..0b55258573d3d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1658,7 +1658,8 @@ struct kvm_memory_attributes2 {
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	__u64 error_offset;
+	__u64 reserved[11];
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 426917d22a2b6..2767992955752 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -572,9 +572,45 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
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
+
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
+	bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
 	struct address_space *mapping = inode->i_mapping;
 	struct gmem_inode *gi = GMEM_I(inode);
 	pgoff_t end = start + nr_pages;
@@ -588,8 +624,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 
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
@@ -609,9 +658,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
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
@@ -635,8 +685,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
 
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
2.54.0.794.g4f17f83d09-goog



