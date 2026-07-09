Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33BDFC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47AA46B008C; Thu,  9 Jul 2026 03:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4521F6B0092; Thu,  9 Jul 2026 03:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38EF06B0093; Thu,  9 Jul 2026 03:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0538C6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:56:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8765016910B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:56:34 +0000 (UTC)
X-FDA: 84968481108.30.BE0F60E
Received: from mail-pz2-f0.google.com (mail-pz2-f0.google.com [74.125.228.0])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7113C0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:56:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NBLhiEGU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of coregee2000@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=coregee2000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783583792;
	b=zBEt6/oySRUbI7v4RO1X9bFQXcQyorbMR0h4cyHVY7mbYrxGphzDGi8oFQDDVIazSiOf8O
	LdLm39UUHVSrLIbhNxgpKPxOOGL49uOCqTwhsIXsMjJ2sOKLAB/K7c9+UFdDWUwIkyLaXa
	MMWd9OyudGbQ6kYjwug2U85wyswDKuo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NBLhiEGU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of coregee2000@gmail.com designates 74.125.228.0 as permitted sender) smtp.mailfrom=coregee2000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783583792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q864uR6XEgmXa8OQsth34L+SyfDYyZ9cwD42T62AOO8=;
	b=HYkjFWi0Nc6dSu6YlByNX0YDFkGJM9Mt+FS5hWRQRUO4ZqqhzfP6gLx9SogSgqPkCobQXl
	8LcVh0xtKgTY7UwE023sxAfK8uZyPIEclIhPAA5Ky0AiNvSSvmQSzz3ri4gaL36d7RKEz2
	pOx74NDXVzUroQDx922V5lKsg+EqKy8=
Received: by mail-pz2-f0.google.com with SMTP id 41be03b00d2f7-c888c19b85dso492680a12.0
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 00:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783583792; x=1784188592; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q864uR6XEgmXa8OQsth34L+SyfDYyZ9cwD42T62AOO8=;
        b=NBLhiEGUS7acGEQ9MNZ+oMwdYic/1ht2bCqzm+IrAslwPBI7pJE7tfSldhSeniLHku
         pa2h2cGOOiZlDEyrlPR23Jf1Ash9mPlDHkVHSaNTUQis6LxDjUZfZW2ZPacnm925evPl
         mL9taHZa440AmO1PUiqExnKXeWCTBnH42sgtrbAW9hfm4HMuTooOVxO26CSJWLizejC3
         xIGkrlPWf/f9Z+GZjbOD8JYcdLQNb95q8SqMCH3KXZ6Ey1rK1bCv0CSSgxRhMKuDcQzr
         C+jbt153Ju81axx3UnWSSoQJwg3X8gUvUtNb+BfCTf0VaCdH+U+OBfWDL5h2C5YnXaPS
         3Pbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783583792; x=1784188592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q864uR6XEgmXa8OQsth34L+SyfDYyZ9cwD42T62AOO8=;
        b=klI92IcdAv/OTwesbfVJr/5gKuwG2/T9/NIkfRhFjrLCejSdIlwYWtN8SRwXGV8jCP
         P1DTNACg00/gJ0yLOr2ENjKsjSuBYBiNttV2QHuDsWZ9AkAxx1mVS9EZX2lxi/EC4nfd
         202Mp1QnzaDrBOO3iEycziWivvZi9XLTKgv9l2wow7Aw3+TAEH9ONk29lqzbV2xGzj65
         TpCERWnqlXdA/Y3Rn2E5o9j1eMhdZ1d2jDCnytMAap6C59fpiwUcEHAAhkiy541d+CdS
         QrCGCTpO0UfhmGInjjYzuePREny9xVIw3VHU7wPDZN0BZ2BmmEE1viSgwpE9IYuhLFPz
         2bnw==
X-Forwarded-Encrypted: i=1; AHgh+RqY5bqK+lQ/NfxmDIXEs1JnGWLmdf/4iyDl9zwxWMxK+QcsfGxYxnoqOUNc7UkUqjlA1czAymoKnQ==@kvack.org
X-Gm-Message-State: AOJu0YwpqNd9WM92XQeRa1zUziaC7tiVO0qUFooEDvHWGR0ypJmxv7wZ
	GQZzijfZKHdp2h8GCm70TrnfpSQ2VhlcTpCHgwt1gOWkvkr3Kps0Dku/TEr11acFtUee1H3s
X-Gm-Gg: AfdE7ck9GG6WEPWqqd7gD1bpLRDNtaVhX9OFHkcHAdVU0U9oOWVYLpoirHeRz5SBgmo
	Y26QeMr/7qIGCLz2x0ollcEjT5dcS/23r+jvtbBbF7u0YMYFVaVgfAFDpjMFpOemQ6N1VvAHoio
	ibD1AIzvuWmfdwV7z43RZg/u6QJAPm1jCkERFW/NbPnk7AOCBHAhFD0eBDI7cE+XxdaU/HQhAkg
	3Dswr1TKHAjLqM9WcZsHdLb2e15zbnE2cy5T9dlfFW3E44WObHOz2NfvNzPPUTZ2uV5hhrQh+hG
	XJkpCdBhA1+d3AY9mVTEdwLxxCJZLv6+UCk54or+lZv5hByjE50Dg+KxnqRP/QbWCkwatzV0Mx+
	I1bNBZb9LDOER/THDCV5n7J1iVj7HhN+iFCzQ0SP8kJkQHstRdFlO2ggThiSGtAKnmausj18I3h
	lBc/El/VmmPpZJZxucuNxJfC6qrKvLlXk4FWghsS16+3N1YN7DhIgV9JRmBJUqKrfc
X-Received: by 2002:a05:6a00:410d:b0:845:f107:38c8 with SMTP id d2e1a72fcca58-84842f9f270mr5532806b3a.47.1783583791643;
        Thu, 09 Jul 2026 00:56:31 -0700 (PDT)
Received: from localhost.localdomain ([159.226.94.129])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84856d5d619sm799176b3a.39.2026.07.09.00.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 00:56:31 -0700 (PDT)
From: Longxing Li <coregee2000@gmail.com>
To: akpm@linux-foundation.org,
	willy@infradead.org,
	linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Longxing Li <coregee2000@gmail.com>
Subject: [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion
Date: Thu,  9 Jul 2026 15:56:13 +0800
Message-ID: <20260709075613.854-1-coregee2000@gmail.com>
X-Mailer: git-send-email 2.47.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D7113C0003
X-Rspam-User: 
X-Stat-Signature: dro1q3s433wqqjgkwfpt54m14ty564pe
X-Rspamd-Server: rspam03
X-HE-Tag: 1783583792-520463
X-HE-Meta: U2FsdGVkX18vLM3ZcBygeTqyGHHes5PxmZLmjs1bMOSOUKFl+OPYymwddXXxbqSbXx5CB6XP+k19Iqip/WR87k1dEgWRnqvD8M47fnsHOWP5VM11d6WZ8rn3fsHZ/nvXgMRlhf5TYBv//7NJXf99+UvkGqjTnM1cyu0t4iK/KLpdAAL1fGQgxpIjFvwipt61sV30sVDOvPCClAjMol05pWupRbOu9MVUI3wioQ8Sa8QBGFQjkCYJI6K22p3Y4pKqgmr1pXDP+haJ4LhXGqBQFfS1h4QDsMBxhcJn3rxsi+e+uMnpVZ6IbrvZCm95x3s2mFozdMgndVaAcG+XKYoY7oMcH1Nnu+zg+4M6qn59dJ+wuROREov20Y+gqLXO5xQPwqmgjnlZEG5i4ARqFDb0uvxKpzrwJPXbBDrW81Gs/EwGZapNEf1ZdDRA5twnpayAeR6V3MWBB2p523QiViH4JGoNENxfKiEJneWsRQcbK1t9aA7lx7a63uarp+AJG7JQEmwCsH2TAquz9oFtgkeRkTmNx21Hablg+Pi4DPb7/rG99LupRkNw75kvm7mwiTf0FMT4d/M2yBJURvoSpIX7X6VrJXxfaeZ2O4HdKFkHDsvBnq62tum8Unx/B1zb1UDjHMmlsmbIFwlhVMzORO+zzynIw0t5+f7r4VWTFgY7Llp6wfU0/D31LPPfH7ky0d4omtKhoxRWHAag2W4ApP4vSvtbwdTXo7MMeejYy0KzG/4wT7Q5RU+vg5fmyMo6pjw2loAQKeGxxvoPsxKq+pcUkJj4+SkVjrBAEIJmH39FhslaO7/kA3bLZJg/FlwjnPXAlbbpCvHCqhFkwQIxOQkT2F3tdkC2L56vZMfNkyiFqWpybOg9BwSCPnympfxfAaucwlJBX/7N99DH76O+jjAabvnYv2rwlBqopuoVy0aGqhR54gyvYp2HcvPSYHh1RXugETvKypUIaQCfMV4fpc/
 sfiShAGR
 zSNwWOtNWDLgoRtXTGZsJX76OHEnPUk5T31t3Nfv0qvPsPx/V9XVbE+0fTS4FUfFS7WlS/tVffTN7jPFvkZYR15aTwWFW5oxFDsOUokxnukqvIHxfFIjZhDgIlrm61tYtlYygj5UXHmBLl41z/q4BsLk79kDUrzbJYQl//qse1dmFlwDTqvwLXcr9r9Jf2+uqomRW/ONcr9Z/u9qj5UDn+KEtwNoZAE/mrhIuu/iEiiO8oK2TuRtTG9mUQLpxYektxBCyI79qSkIemiUDTILWiRnrYbF+AnccMEy1o71zDWNsPIuJ+M5tj6LL9QXSSeM85GeZReGBWJ2G0AjGwUjXMIPjpkLF+fy82A+n5zvVilNNeceZeGycc6F9vxJ6aV313btpXMJplxqz4tLY08v9JocJBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ext4_add_complete_io() queues the inode's i_rsv_conversion_work without
holding an extra reference to the inode. If the inode is unlinked and
evicted before the delayed work runs, the inode slab object gets freed.
When ext4_do_flush_completed_IO() later accesses io_end->inode, it is
accessing a freed/reallocated object -- a use-after-free detected by KASAN.

Take igrab(inode) when first queueing the work (only when list is empty to
avoid duplicate references), and drop the reference in
ext4_do_flush_completed_IO() after processing all io_ends.
A per-inode bit (i_rsv_need_iput) tracks whether the extra reference
was taken.

This is a defense-in-depth fix complementary to the upstream fix
c678bdc99875 ("ext4: fix inode use after free in ext4_end_io_rsv_work()")
which adds consistency checks in ext4_io_end_defer_completion(). Both fixes
address the same root race but from different angles.

Fixes: ce51afb8cc5e ("ext4: abort journal on data writeback failure if in data_err=abort mode")
Reported-by: Longxing Li <coregee2000@gmail.com>
Signed-off-by: Longxing Li <coregee2000@gmail.com>
---
 fs/ext4/ext4.h    |  2 ++
 fs/ext4/page-io.c | 15 +++++++++++++--
 fs/ext4/super.c   |  1 +
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 56112f201cac..239e6c0a3d3c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1179,6 +1179,8 @@ struct ext4_inode_info {
 
 	/* Lock protecting lists below */
 	spinlock_t i_completed_io_lock;
+	/* Track if ext4_add_complete_io() took an extra inode reference. */
+	unsigned short i_rsv_need_iput:1;
 	/*
 	 * Completed IOs that need unwritten extents handling and have
 	 * transaction reserved
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 39abfeec5f36..294c0bcbbb7f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -262,8 +262,12 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	wq = sbi->rsv_conversion_wq;
-	if (list_empty(&ei->i_rsv_conversion_list))
-		queue_work(wq, &ei->i_rsv_conversion_work);
+	if (list_empty(&ei->i_rsv_conversion_list)) {
+		if (igrab(io_end->inode)) {
+			ei->i_rsv_need_iput = 1;
+			queue_work(wq, &ei->i_rsv_conversion_work);
+		}
+	}
 	list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 }
@@ -291,6 +295,13 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 		if (unlikely(!ret && err))
 			ret = err;
 	}
+
+	/* Release inode reference from ext4_add_complete_io. */
+	if (ei->i_rsv_need_iput) {
+		ei->i_rsv_need_iput = 0;
+		iput(&ei->vfs_inode);
+	}
+
 	return ret;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 87205660c5d0..10a5d863d9b9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1418,6 +1418,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
 	spin_lock_init(&ei->i_completed_io_lock);
+	ei->i_rsv_need_iput = 0;
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
-- 
2.34.1


