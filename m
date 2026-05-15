Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C6C3CD37AC
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 01:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57E06B00A4; Thu, 14 May 2026 21:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08C86B00A5; Thu, 14 May 2026 21:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45A06B00A6; Thu, 14 May 2026 21:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5F746B00A4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:58:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EB5F1207BA
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:58:17 +0000 (UTC)
X-FDA: 84767994234.02.B10DF16
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6F6B5160008
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:58:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LntZuY8Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778810295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oIPP5FhKMUzrX3A0EHFrIdCr5xrbmrEmKzfzM6TrS4c=;
	b=U7eu/VWBoNh4Ps1Jnf1dUleRWhKQ6xJMCnOcoKQZWyg2PHZfze2qFG0ACVSdWR/SVu1QD2
	mMg87zAZ+dQQ05v+1KRnWv7dK4c1kTxQfAgIj+7njcdJtEsG4CFvttMlDIlYShAhf+BU3b
	Fs87I1ufe6D8WCDCfmxQBVGDrM0QvWk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778810295; a=rsa-sha256;
	cv=none;
	b=Bm+BByp6egNEDNSzzvxPB3Uu/3WvE9vucmcz7UhRDjRREiKc9gz4E3dNuF2iqcUCgqNEtq
	3lqDAeDlceu1iuVrN7lxT/ix40l19gOF/zdwA9zcf9izdhWkPd/Yu8eEPmKYZTc6bW7aNS
	LDA7IRU9D4a9xAuqsXlr2BcjpgaSTHU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LntZuY8Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778810294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIPP5FhKMUzrX3A0EHFrIdCr5xrbmrEmKzfzM6TrS4c=;
	b=LntZuY8QFuRihoIjhUQTi0DBnkEvRf1icssDkm1b4W/Vp3zQZia9jEe+VYIBH1vMUs91bC
	l5FCfgeJ3t/4Tc2CyZPVJjzJIM5Esi3xhDadY9ApwsQGpcWEgeCbv1hD/IvsdaAFeFqYUs
	ySG9l1eDWBYUbDcgch5zYFOkXEk/UeU=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v7 3/3] mm/swap: add unplug callback to swap_ops to fix leaky abstraction
Date: Fri, 15 May 2026 09:57:37 +0800
Message-ID: <20260515015737.890994-4-baoquan.he@linux.dev>
In-Reply-To: <20260515015737.890994-1-baoquan.he@linux.dev>
References: <20260515015737.890994-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6F6B5160008
X-Stat-Signature: 9k3qk4z9hndw6a3gihr8osrc3oh7dkju
X-Rspam-User: 
X-HE-Tag: 1778810295-366494
X-HE-Meta: U2FsdGVkX1/pjcO1poqch9o5H6ogrs9uWBJbQhb4HqVY77FrzZWO9mgXp1isT00hMcXuTSOrQokxy7OrbGNdnHqjf+iBxTXIQk5PROFOf96jGIcQO0+IdcnulAlyD0oF6CZDa/xaA+xiYXSZvJzaJryQupHsK4sp55mrD++Ox3zDaE/DqAv9mmtSvAa7gWwenWpX8cTGrQ1Clj2UWz+qThBeG9cVwBq5qDTTcFDgDGTwcKLbn1aJCyzEqeVk8H/r0J7I0pTfWBbUIQ5NoB5K2rqgSzB1JN3/vsw92zCn47QXpjIprJiBCN/i6OzxVxo6UXi2vaVq/xM5F19n6+HSk6lJRkh0kd2ODxtVec/IU9RHLGji5DEEXnnoYsl7UVNC2fBzsHVuz8UJm4SwIxO31g32vNqiS9VMk/4DA8RMTZ7FDRz0uhplxyIRvIsuj8/Jx3b/HgGCKH4xJZCGlJbhfSAdjRniOBPC1P7ispbQnGO0yYnskOE6S+C9cHFkBpZ8jkTJuRP8SxcVE5fBN6jM+CIE8SNh+J/+UoM8ZvPL6PBOWd/7MdpFFQTa13T/vX+UwWqAIAQaTuDrNz9Q+27+mVuPHCNzzH+RUw7EpQZ+f7zfoZcSTaLaSGhx1jgtsT6ySVKJfQDwXzBDmKuVZCy3qhJc38NBfikAhD446y/czcO18pPdTEnZa3GR9jTa1Qcj/bEgYAgonkC594oyDnvCBctbwYHwHrFoM13zkN1V6+74De7U7bp6Y+4mgCDJmEODc0MR+938uqxrZtgXhhoyKk6K0VkPD5oJw9yONYP/+hSmAtZhkuDiiK7MhTjAHBFuzM2fJonSYlDqkTlY4ftWGIiGtcge9chwFAD8OM/8TQ6Bhg8r+K9L/ALJsXVrbaP7+4vDUalLBF8azk9kdzLE9NI4j/eWeOwVz8JrUgqDQH8YcEiiMVRJqv9tZ3tF5kidK5dZUwdhGh7Q1VGC8KN
 Izkv57t1
 VwFrrzb+lQd5WViFEghLWNzZy8i7XeAeDbRDITEhLxeEmg8my/Gd07OmNNiWDeqRnAFy7ffTVx7rdlCf5Tr0RA4jMy1E2IuGw0iOMJekN4kPd/X6anUa5ZShMPxA6vCwwa44aKi1SX+SfRob6Q/pRcreA4EyyngljzqI3/GWCBJz5oFsg79J25OaL6bMmdM6lil0fD7N7TYrqj0l7l1/W2Aw21GwrI1zCxNZ8lvDiF6jR+W62tVhCZ+XktQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When swap_ops was introduced, the FS-swap batch submission remained
as a standalone swap_write_unplug() that directly called
mapping->a_ops->swap_rw(). This meant callers still had implicit
knowledge of filesystem internals rather than going through the
swap_ops abstraction.

Fix this by adding an unplug callback to struct swap_ops.
Each ops table provides its own implementation:
 - bdev_fs_swap_ops uses the existing FS batch-submission logic
 - bdev_sync/bdev_async_swap_ops leave it NULL since block-layer
   plugging handles their I/O

The swap_iocb now carries a pointer to its ops table so that
swap_write_unplug() can dispatch through the callback without
the caller needing to know the swap device type.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/page_io.c | 11 ++++++++++-
 mm/swap.h    |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 38b94c560c37..2c36d261ad98 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -329,6 +329,7 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 
 struct swap_iocb {
 	struct kiocb		iocb;
+	const struct swap_ops   *ops;
 	struct bio_vec		bvec[SWAP_CLUSTER_MAX];
 	int			pages;
 	int			len;
@@ -401,6 +402,7 @@ static void swap_fs_write_folio(struct swap_info_struct *sis,
 		init_sync_kiocb(&sio->iocb, swap_file);
 		sio->iocb.ki_complete = sio_write_complete;
 		sio->iocb.ki_pos = pos;
+		sio->ops = sis->ops;
 		sio->pages = 0;
 		sio->len = 0;
 	}
@@ -454,7 +456,7 @@ static void swap_bdev_async_write_folio(struct swap_info_struct *sis,
 	submit_bio(bio);
 }
 
-void swap_write_unplug(struct swap_iocb *sio)
+static void swap_fs_write_folio_unplug(struct swap_iocb *sio)
 {
 	struct iov_iter from;
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
@@ -466,6 +468,12 @@ void swap_write_unplug(struct swap_iocb *sio)
 		sio_write_complete(&sio->iocb, ret);
 }
 
+void swap_write_unplug(struct swap_iocb *sio)
+{
+	if (sio->ops && sio->ops->unplug)
+		sio->ops->unplug(sio);
+}
+
 static void sio_read_complete(struct kiocb *iocb, long ret)
 {
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
@@ -599,6 +607,7 @@ static void swap_bdev_async_read_folio(struct swap_info_struct *sis,
 static const struct swap_ops bdev_fs_swap_ops = {
 	.read_folio = swap_fs_read_folio,
 	.write_folio = swap_fs_write_folio,
+	.unplug = swap_fs_write_folio_unplug,
 };
 
 static const struct swap_ops bdev_sync_swap_ops = {
diff --git a/mm/swap.h b/mm/swap.h
index 8d4375f91632..67e3b1617146 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -224,6 +224,7 @@ struct swap_ops {
 	void (*write_folio)(struct swap_info_struct *sis,
 			struct folio *folio,
 			struct swap_iocb **plug);
+	void (*unplug)(struct swap_iocb *sio);
 };
 int init_swap_ops(struct swap_info_struct *sis);
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
-- 
2.52.0


