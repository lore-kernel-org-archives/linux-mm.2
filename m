Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FB6CA5FD4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 23:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170D96B0095; Thu,  1 Oct 2026 19:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121AD6B0096; Thu,  1 Oct 2026 19:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05A16B0098; Thu,  1 Oct 2026 19:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8C806B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:02:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DB5212059C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:31 +0000 (UTC)
X-FDA: 85275583302.13.3F48104
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id C75A44000B
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 23:02:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q0yWNIr1;
	spf=pass (imf17.hostedemail.com: domain of 3hOa-agUKCKkYaJJWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--praan.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3hOa-agUKCKkYaJJWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790895749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8F9ZHqeV4+Z5fO5QHVYcnZdLetqeRUwTS9gfMM8Hnc=;
	b=NMkTPYr9dHJcBmIjSCZMKohnceg1k1YhpgFpOgh9d/tl8ft2f4wtdmzivEcrE6EPKWHn3+
	ErCrmucDHTSVqjLbWl/vuqwo3fe2tuyQvUCF0yZsbFYFiX000lqSve/tIaUEZ1OuTwBHER
	c8ha0aex91a7tvpW7EvIVwYLLbru89A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q0yWNIr1;
	spf=pass (imf17.hostedemail.com: domain of 3hOa-agUKCKkYaJJWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--praan.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=3hOa-agUKCKkYaJJWPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790895749;
	b=taibpmHE/B4HbXgQJ3hMGA3/2lh3bUW7c5Q+6GQ2R2fpZIcqOm7ZXTZ+QsFIvLmamnQUV7
	zX4P6bq0bNxL0ON+LiBsl1+wx34ZdnvwndcCj2k+vjhBq+599WYG4VDTz8+W8Sle8OttwS
	4yIeW6eY+yGftNya1RqpYiJ93yJaoHs=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc72777faa2so4235460a12.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 16:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790895748; x=1791500548; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k8F9ZHqeV4+Z5fO5QHVYcnZdLetqeRUwTS9gfMM8Hnc=;
        b=Q0yWNIr1vix9eoaG//9Q+OyfvGqj2bue4Ht6jDal4mQIVpAFU+yhxsuBerwc9SIoTB
         jtfXSEgQHa6j6KLA7at5AFEvnRfYepUVOibjq6BeyyCMyfCf36xI8tZG8bPe9OTloGpX
         tyhsoyvv7nl3k9fqMQsloJJ3hNltpMStbE4S6t/7zN2wRLWK+Z1XZHdI0yDeJ8/JL3s7
         H6UE0iau57nxgCkg8lkcw7s7tFT/nqhu8VzbF+6gMT6mu0ivFLsN7/NETEQF4XUKOsy1
         ElT/qUjfmoF7V0+uqR9cxG0yok6aGbpJuYvxN/zRTxon2zQmoOs51ow31mEdyzVBt3Su
         8kWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790895748; x=1791500548;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k8F9ZHqeV4+Z5fO5QHVYcnZdLetqeRUwTS9gfMM8Hnc=;
        b=Aa9aH2KwYzX4BaO07HmX0jhCe/6js0Pvo+/0tfezW3/HdKQA9BU8iBhNkdkYCAoMc+
         LuiJwYqley284sU+/9VQcaT2oZsoF5yulu11tlmn3K0sHbyH56Ihu1cEtUcNSl8pBSBp
         swzOjfVKFYUi5XGzic350uINeRo4fIOEoxQ1LdOo18bC9RV2xqKGyhsa0E+bP6EVLJr4
         dOEiHLH7GMfyzIyQONj3iF+poQf6vWQr6jFB8vkl7/QeMC/8+MU7lHkfpMYSZhoZMssd
         tMMcPGqkT+pjmS3hKLjifZky7uS/UtbgGf6Q+kRVjezfEMb4AyoNw5IwRbMZZ88qahHN
         CDug==
X-Forwarded-Encrypted: i=1; AKwUvBzClHXy3hkKyRAoJq8MSrJrZmY2KG2eKJoC+dDeWgNfLKBfWlsmSDWAJAMhaoBWrfu3cg+yp3ojDg==@kvack.org
X-Gm-Message-State: AFuF++lmDdk5VNqMbQshtP9f6tbWoCc+YkvNim7Cb4le0kNFIHYOBN/F
	pqy/jJnpsnOAgFXp8+Ei1i3+L/41lUAtqq5jQvXvXEgthhq82mCXg/sV46638P3w/X3sro9hY16
	+6g==
X-Received: from pgdf25.prod.google.com ([2002:a05:6a02:5159:b0:cc7:cc85:4188])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734c:b0:3d3:adbf:777c
 with SMTP id adf61e73a8af0-3e0bcf0ac46mr763907637.24.1790895748097; Thu, 01
 Oct 2026 16:02:28 -0700 (PDT)
Date: Thu,  1 Oct 2026 23:02:16 +0000
In-Reply-To: <20261001230219.818128-1-praan@google.com>
Mime-Version: 1.0
References: <20261001230219.818128-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001230219.818128-3-praan@google.com>
Subject: [RFC PATCH 2/5] iommupt: Implement refcounting logic for Leaf entries
From: Pranjal Shrivastava <praan@google.com>
To: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>
Cc: Mostafa Saleh <smostafa@google.com>, Daniel Mentz <danielmentz@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Logan Odell <loganodell@google.com>, iommu@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C75A44000B
X-Stat-Signature: syc137h34yy4k9pfj8ehcqj1zu7ozcyq
X-HE-Tag: 1790895749-406871
X-HE-Meta: U2FsdGVkX1+vO7mwUlgkbLswEkfT1NitnSo7dcQ/ClRUEv1cefsk9+6BfxW/jP9/hbubqBPcbt2129zK6jmZu0DykM+MNbMi6hthydWBpiep23KrYb2+QdAfpGngCfyjOb2C/C+ykMES2AjSRNBJbJIYeMGxEkEokzbf0HdzTbsvZn6xesFIBityLGoa7LPPpZH+m8RXXJodEpB+Li4JnB0kawbRSlKSC/YM02gmxWKJ01lqDxdWWMJ+JopRvfredV8KcfRNbhp1R6MHz8Oi9CYliglr7ZcCkcRF/zDpLaF9Jk2INGqmwZWpVxqwBfiDG4PPz9WFwh6dk1J31u2yfg9BiOMOLS0nI5MOIefoah5r8YILU4qxo+is1Z+ch0E8yv2uZb8ec6WcGcExuWUgQqhipjwpIpqdl5LTGEPCKESnZ9LrKGrlOPTRyRVQA8uCxPPN2+z8gnPa6nM+lgrRUhE0Y4cJqAxdz+TqO5AoIn87yHv6w13GNK84GdcbvgeB+AL+IMrddWT1P2xYcNjE27rEv1K+aLZhU50mcA0XVpYplzOiIPVubLcc3jbe23BaOISdqJrjtUjrWFBmV/Cmb64NxMajVNYaIYPC63NE+V5zdDovdiqbGtOa7btgDqw6OS+6BDBz01X4JVpZcClc6ReH3lteSVqa2krzZU7jWVyMYM1VPM+gNt89NNBTenQCXa381jiyLlB2I8CkDAnlWsqlbQAmWVficpGR48godKmpDOdlL8pH0yGyMCwUGcBG7RsULzxZ6q1mdk8VUoV0Q2EL7X/yW6ynZzuSYQAi8d/H+bjRAQG4XRHaAE+sKlIFAEW9BDx3NhQco/u5Z2d0tU9xUXhiTo2YWaFVMWsU3BFf2sgdJrvKCGrT6us6qqYqJcVsGrH9q/yGEe/d+NdAMb4ds3ASLYqzQpcCkBZY0mtxxjZaBW0FbcKcUhU4DmhPajGD9T0h0ZGrcNoCuLE
 ZVENs2+q
 7HmATNkLSW5n4vbZh8XMAOy9rV1ZRPArb2hZWUqNEggk6NAGsVzCfRe867uDEANcmvzn/TGZ+Fcjw6ZLtTRWRZX9EmvOL8yHzMKYElwSF88ZpwrLaRXuD2UKi8TPDrP/WZK1d6FIUVMxEVladLNTUTL5ChHnPmxgG4I8+1tV4Ii49hxSTZR2ij2VnBzzv9xpWzRCj3tRjw7oa8O2ti9CRJHr85YsgLD9SxFgU+22rMoSNC7BOOuxERBupA2ZbC5S9FRtj5Jyn0LNLlfP1YCWUnmBwMpJDNxdmoD5fiWsCFvmC7iWAthiAiMMyEk1unM1uIaHBv9qjt8JdnQODoiGQKs0P+kmTISWVsd2BrnASQKfRjxljSEqE/qkq3Y2uUJhd2uC+oqWx/mJHvIpzjGCbBIaaZtHNVA5by9MAluXrNJmUg/mnTvC4j6SZSanCPbJR4L0RnuEPyw4x+54pfLzjH1uDqr7F90R3aNdVLPZBpdLtvs1O2c7tUy6wmxWQLhtcM2ZnwYiL4RSGNwEvvEqqh4ttav0+4gMOWEzrhaR/RQXwoOqokMe9+2DucXZZLb0tQw4l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a lockless state machine using the ioptdesc's __page_refcount
field. During an unmap, the driver executes atomic_sub_return() when
clearing a leaf PTE. If the refcount drops to the baseline state (1),
the directory is completely empty and its pointer is stored to the
domain's reclaim_list Xarray.

To protect against a concurrent background Shrinker pruning a directory
while a map thread is actively populating it, the map thread must acquire
a reference using atomic_inc_not_zero() before installing a new leaf.
If the acquisition fails, the page has been marked dead (0) by the
Shrinker. The map thread cleanly returns -EAGAIN, forcing the walker to
loop and re-allocate a fresh directory.

Only non-DMA domains are queued: DMA API unmaps can run in IRQ context
and the reclaim_list lock is not IRQ safe.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 07ec2b3ab986..c3d09b746eec 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -621,6 +621,13 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 			PT_WARN_ON(compute_best_pgsize(&pts, oa) !=
 				   leaf_pgsize_lg2);
 		}
+
+		/* If refcount = 0, shrinker killed the page, retry map */
+		if (!atomic_inc_not_zero(&virt_to_ioptdesc(pts.table)->__page_refcount)) {
+			ret = -EAGAIN;
+			break;
+		}
+
 		pt_install_leaf_entry(&pts, oa, leaf_pgsize_lg2, &map->attrs);
 
 		oa += log2_to_int(leaf_pgsize_lg2);
@@ -754,6 +761,11 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
 	if (pts.level == 0) {
 		if (pts.type != PT_ENTRY_EMPTY)
 			return -EADDRINUSE;
+
+		/* If refcount = 0, shrinker killed the page, retry map */
+		if (!atomic_inc_not_zero(&virt_to_ioptdesc(pts.table)->__page_refcount))
+			return -EAGAIN;
+
 		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,
 				      &map->attrs);
 		/* No flush, not used when incoherent */
@@ -1087,6 +1099,20 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 			 */
 			num_contig_lg2 = pt_entry_num_contig_lg2(&pts);
 			pt_clear_entries(&pts, num_contig_lg2);
+
+			/* Drop refcount and add to reclaim_list for the last ref */
+			/*
+			 * DMA API unmaps can run in IRQ context and the reclaim_list
+			 * lock is not IRQ safe, so only queue for non-DMA domains.
+			 */
+			if (atomic_dec_return(&virt_to_ioptdesc(pts.table)->__page_refcount) == 1 &&
+			    !iommu_is_dma_domain(&iommu_from_common(range->common)->domain)) {
+				struct pt_iommu *iommu = iommu_from_common(range->common);
+
+				xa_store(&iommu->domain.reclaim_list, range->va,
+					 virt_to_ioptdesc(pts.table), GFP_ATOMIC);
+			}
+
 			gather_add_leaf(&unmap->pending, &pts);
 			num_oas += log2_to_int(num_contig_lg2);
 			if (pts.index < flush_start_index)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


