Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74DCBC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E86F6B00B5; Fri,  7 Aug 2026 17:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3026B00B7; Fri,  7 Aug 2026 17:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386B06B00BC; Fri,  7 Aug 2026 17:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3F316B00B5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88DCD1601DC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:54 +0000 (UTC)
X-FDA: 85075823868.21.F79F464
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8C17DA000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8cgv8Mf;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139572;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAbzh7RkiKf8Olc3a8JN/LnVWsyArUUGltZv5H7F1no=;
	b=51fz5YOkRiV+Jb9vCLyQSUDDP+NNntHSfz9Xd1Bhx5bQuuPVbfEghdx+lSJjlXtJEcbymJ
	qnBDNDepvJ2F3vwSw78MDykZloK+5N70cx3ceuzVQFzq2aJ2trBRcTZhBHuzi28jB+GACs
	y8mg5AF5K++zKcuf+z/p2b7EXRHSHVA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8cgv8Mf;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139572;
	b=2MBzs7zJfXyyPPkO744mf5KsZKfbgsyWuUzaNo6Fl3FDoMeZPyxPmRbJrnZljy+WFU2v8/
	kTC6IkGAMS2P+8CwtOAdxqLqmhZUm2MwQD56ExosVs6Yn6QZIeF8Una0yiDI8ofickY1hw
	RV4wTfcehVqZMSGfNnMwmLyJAOCwEhU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E425644FF0;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88DFBC4DDE6;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=tfnbkDTsUgjV8ae+YfwtWqaHSKcI51uEln6Qb0OILDw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=F8cgv8MfzHRb/JwcnakLD17L0Bytvp0ggNKxjTZQmclTMZ/Svj2GqTenpYGeK3t5R
	 TQ3bm8Axy2jSvcTIrSZnWbPjPBUnwtaGplt5OIQOc7OCBhq4SHEtGQEijnbBpAlNtf
	 jBL0H2oyqAnN8GTloZXjc2c6c8DqJVwyqX3C+WwjpgGPMh2Dj43B3aTU2+9x5lU/tr
	 qUPDhBSAS8EEMf8axkHOeWMEmyHXqNeb02eVELtqBo0fWpEV5qKx2OVKc3qjx7HjG3
	 Qqjf0rVsbq2ZiaOL+Qjn+jl/z0MqNYVLHekpDUgCLA0nIsHznprQ4vK7lP3bwfEFHz
	 SuB3/1D6Hdd+A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73084C5ACD4;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:48 -0700
Subject: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and private
 when invalidating
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=3422;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1q8QLNSSzWUow4EJaKvrMqTfyteiIQK8uRHjtZo2+nk=;
 b=AQVmGM6AJ8KOerslpx3mVIgNVX/P+qago77Vsl429UlDPUt2QmWTsb/BsE4mhbCnGbxHgvHmy
 xOBW2RU7osOAlKfdi0+QBB0uwtE4wwZgeEuhdnNDBTlT835oA0tJgPL
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C17DA000A
X-Stat-Signature: g6dr5pycstrw8fagwmx71yt5i689anwo
X-HE-Tag: 1786139572-347553
X-HE-Meta: U2FsdGVkX1+Nf3MhQz8BAOIDsRI3LDZbenxQgahQyqvEyKKVpo9ij4ruG+wrLd8RSIbmwoVylt6s5ugSNULajJkzCwdPKdJy0+DrD/bZm/gJ4YmzOpPEYBCIB3Wh2zSa152PKWaQf3iqvQOy6wOd+HbT6CYqIhsIQk/Z4I7/iL5bvdzuwGH1bj4axE0WE9r5meml+4fOgwnjHOFflVIW8FHGkthrMsl0xoPRTcYfhh6JDgRrZDPzoLfmTkfHsS/oNp3HM+wb+POBoQ4N7BB3Itp3YPdemsngKWmS5LYA7hQRlLpFXsoiKDx5fAgO1RWMLK3Go/ecyUentU/WdSL8Xv5PPzSSVdi4leGnllSUUJXDkTMrzkEk7L9+6XKdSHRgGvGE/Tdx3xHb7lR9uQKo1iQWA9CqNdrWzDKbd4O6f2Uu3df+BAoji5Ph1JpozCRRE5YkOmtnN5053nYKxVUjOhDTq9Zd+RqqHStUnep5baRDrGbR5FwLM+dORse/6wLMROOyH4oelRtu4lCQFOqdmRsP0EXV57VkF4xRbYSU0S4QirML+vzx+YWWBZ5zuoJvVaK3jdQ4vj00GnuvFRG4CDwO2UqR/MQ00MjfAbiY47RxzhWQBCrjCfuIilrL/6oZFbLmqELagFhZ4rkmBXIA+FoFkveNolXHegAclSowFn1augrS9WcsleXQ3WKkVey1QZ3Ed6oYIyw3NJJMKa0kb78nvu0yPXfg+ZodNlRUTBXbs4RDIkhvowDg+P/ayGmIJ/hB5VtEJsbzmRKpxsagSLBKJ7e5xWgs5jczadN/E6LjfhkEcP0B7OryYAxTAfcQt1CJU5+P1QVZ5H+/ChHMvYDAyjH3bCHdfntaWQWYPL+DP0Rys5auLY+J/Cjvb1qXz+qPnzcMSYkD3ftoS5LxLKm18mIjI3jwC02diK8jguiKccozV8l67W5sABpLe23jf3QiSxzm9VNxB+4iUXD
 +oD/v1RQ
 UTEK3xsz6Lo5C8fEkHJjZQqzpqBNDWvkp4wmPMKHHo48UJYE294tWa/ngNQczmJfpXAFITa9Nh3sJalRuwBt9zXSKYcgAmzgqBciE62tMtyrvVb/YvWVsH7WKEVcHMtANxaakAs8QoriV+vhdbqE4bVSKraJAELIbNAyzACTqcy5g/+oDH7AsOVkM65s2NRPCsfkEN6oNLY70XegOCRPmI39/roCT8fXE14mkZsbY/yCDG+ezurMUQ73gSukSCK7ex+QZIbAaHmXFDoBsAdQVK6MahsdMLxafOvJ9AP4YPj3Mt8H/HKx8erz8aKaickPDVPapxNITNVGyHdmTUwib054d41xkLSme5jc3bpQ2G+eVRZ5swV+/uiwa2mmcJrMmk1mGz6sQUduvB7Wttwry4cynkao1vUM8iQsPA+EPy/uBDee23J2V7UEC1Ru6Yqtcer8dVIxFtaWsWbtFbqrVbRLtK1v2VDqCPvqh5DydhUy8Zd3t3n46qG7GOiKsNdJohCph2IC9HxHEVDD71z9aHQFMl+qWC5RZUSoKV3RTAvlH10hchzWUIGVU5RxjNFx0BdNu8jqw+lpuFcJJiW/l5/274w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Before conversion, a guest_memfd could be either all shared, or all
private, configured at creation time using the INIT_SHARED flag. Hence,
when zapping pages from stage 2 page tables, guest_memfd can filter which
to zap based on the initial shared/private state.

With conversion, guest_memfd tracks shared/private state on a per-page
level, so a range can contain both private and shared pages. Zap both
private and shared pages for simplicity.

An alternative would be to iterate guest_memfd attributes and only zap both
if shared and private pages exist within the range. Setting both the shared
and private filters lets the zapping logic do that iteration instead.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 75979c885e030..b1537226e5adf 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -136,14 +136,6 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	return folio;
 }
 
-static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
-{
-	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
-		return KVM_FILTER_SHARED;
-
-	return KVM_FILTER_PRIVATE;
-}
-
 static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 					pgoff_t end,
 					enum kvm_gfn_range_filter attr_filter)
@@ -186,15 +178,13 @@ static void __kvm_gmem_invalidate_start(struct gmem_file *f, pgoff_t start,
 }
 
 static void kvm_gmem_invalidate_start(struct inode *inode, pgoff_t start,
-				      pgoff_t end)
+				      pgoff_t end,
+				      enum kvm_gfn_range_filter filter)
 {
-	enum kvm_gfn_range_filter attr_filter;
 	struct gmem_file *f;
 
-	attr_filter = kvm_gmem_get_invalidate_filter(inode);
-
 	kvm_gmem_for_each_file(f, inode)
-		__kvm_gmem_invalidate_start(f, start, end, attr_filter);
+		__kvm_gmem_invalidate_start(f, start, end, filter);
 }
 
 static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
@@ -229,7 +219,8 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(inode->i_mapping);
 
-	kvm_gmem_invalidate_start(inode, start, end);
+	kvm_gmem_invalidate_start(inode, start, end,
+				  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
 
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
@@ -344,7 +335,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	__kvm_gmem_invalidate_start(f, 0, -1ul,
-				    kvm_gmem_get_invalidate_filter(inode));
+				    KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
 	__kvm_gmem_invalidate_end(f, 0, -1ul);
 
 	list_del(&f->entry);
@@ -525,7 +516,8 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	start = folio->index;
 	end = start + folio_nr_pages(folio);
 
-	kvm_gmem_invalidate_start(mapping->host, start, end);
+	kvm_gmem_invalidate_start(mapping->host, start, end,
+				  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE);
 
 	/*
 	 * Do not truncate the range, what action is taken in response to the

-- 
2.55.0.654.g21b8a5bc05-goog



