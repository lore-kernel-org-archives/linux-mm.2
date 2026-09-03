Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6926EC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6785C6B0095; Thu,  3 Sep 2026 09:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62C7F6B0096; Thu,  3 Sep 2026 09:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F7C6B0099; Thu,  3 Sep 2026 09:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26CDB6B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:00:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95A211A053F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:00:13 +0000 (UTC)
X-FDA: 85172459106.10.853EDA0
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id C304C1C0010
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:00:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pnE5lbav;
	spf=pass (imf21.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788440411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNUKKLqZvrANPeHHYmjPL7ok/64poHS/mGT0EIbK468=;
	b=peq5Puv6x8de//cKVVEhtFi8hnlnnxtsCfq6H48JD4KHM+Ja/hdbzyhQzFhoDM/UAHxsgm
	kvbp2wUkVbNFaA2uwJHejFZuprv0p+xM300YJIloyMTpyBA1IMQRV5X35eDOi9aUAv96+Y
	AcxqwmWLYnqNJUiGTz2ALyCi7715Mwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788440411;
	b=U/ulSPibfAabYEE48AY8RqQDl/JS/GPsuhYqmeZtHqY6rENa4kjHryv2TieP/UNtCnIl03
	HN53mp6JE6xvhGkGWr9BeuGSRegFEsw+k6U0t5sbKlIT4gAqBwba+YnQaGYzVdZdOTiDEd
	C7+1iXl9JWBKf3MbemaspUp3UaQV/yk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pnE5lbav;
	spf=pass (imf21.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84f38f3b36eso1980682b3a.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 06:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788440411; x=1789045211; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aNUKKLqZvrANPeHHYmjPL7ok/64poHS/mGT0EIbK468=;
        b=pnE5lbavEZ7VHJunmDTiysPkbuuLdCgUjEMGdZh8ql1Q7mgphD/TXV5y//AiwrQn8U
         SoPEB58wqVxU84Plju9nS0HqOWg0UjDeupysKBfPtO/GjXo7NpDxkR4cy/s7qhAU8F0/
         MPQmJ/r/JDrcY/tyWW7P3z9zRb6aBQd5QI4rr/1Sj4KWu09l28N9xOvyUMuZW0QccfrA
         GYf30XmE7LSufNAd7Yxw8fks3Zm1ARn/z8h5rmqdTTqJ0AgVlYZCOdyjygGdiwWy98Hs
         WRiWu6dVbM97ETplhP4PQqTtkaKJmI957LaRrw7nl+7BSDDlraAmlrWdJKlf8L5EuneE
         nNfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788440411; x=1789045211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aNUKKLqZvrANPeHHYmjPL7ok/64poHS/mGT0EIbK468=;
        b=r8rqnsyK7ydEb3+4Jhw2gjBZwURgvzY3UDNNUan3ylei5AZGw+rtQIosEyyx4gD+Kd
         a/XQVbFS9EY7oo5HYH0CHS82zaqSweHMIussv3nbpQps5ktlzfypq6EzMz76KGW8l+LX
         1PQSFxPEJnUlmEVM5sECfZf7pjJ1SlguVrMJQqsOZqrEFSPeADjvo6TL+xfG6+5BMuvD
         adzCIKBzW12HcTM2FgxyH3x0avR0TTEaWatgiXoYGSGhH5DIwRBCrE4IIo8Tb6BZrIqp
         6YACQ5CYAAldr6ASKHLOtCxe+uDvGvKmHmFWqymaOh7R1u0vL+32vRl3LrhiaYkLxlVh
         jpNA==
X-Forwarded-Encrypted: i=1; AKwUvBxG3Nm+cHLIJ/XQ6OqaOj03tL5EayHr8JYEVGSrwrZi5yCv7/0sVdU/ofzCc/XpcZllpkg5odrOwA==@kvack.org
X-Gm-Message-State: AFuF++knHZPc2v6u6XIDK4u+Pza/LLa465Yo5Rm8ZLJqZURv4EUXoOcR
	fZZPMjcW+07O0km0PNNQ8zn15apdtAp3xBQpbITfa1cZiexFGnysT4zI
X-Gm-Gg: AYBFou2mr+qMuCtbM5+t0SUNnN1ni4kFCHoZe7zyPHpCC+SQju55r0CyF50EEisinRx
	dUInnqzVbCsfIjboJhoYc0PS/imlR31fK1QL7aPdcqSmY4W2ODz+ODy7IcAUisUvOJ3VKjQ2R3e
	2BrcvcADQpKXqJGvPuut+ZKl7izFScjiUkDKDhaJzE1YCGbVwHlzoz8alyt2jrTS4xWYtpA/1Q/
	Q4q1jMt8tOU78o1CeLqF1SRZdTksrCeKZwCvKeerwKFUXx2pXf+A7Pjyx26w6TMZtpQUG9YTJ/G
	1SVsa2+wzklnPJF+mLwAYM6DM8n/XX4MA4CGeHGMIdDs+yRpo116sr4odzYmTNyOXeAwzXZjVQQ
	KUsPlezO4YBbeiU41l+1mrrCPu9ukq1E8YGXAZBSRIBReNFHmeJGEGx06/SocGujMGIhXShjikW
	2tP8p4xve1JXW92xjdKaFqmmMry9aCXP+wJ1YMNB9XJeWkH8EzT2HPQksjnc9UFTs9sDuqQDCP/
	8nfz2v5JE5uxPHKsx/C8Jza
X-Received: by 2002:a05:6a00:1408:b0:852:3726:dfde with SMTP id d2e1a72fcca58-85ed25e2492mr15794500b3a.9.1788440410410;
        Thu, 03 Sep 2026 06:00:10 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db23f7bccsm2980946b3a.10.2026.09.03.06.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 06:00:09 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
X-Google-Original-From: Wenjie Qi <qiwenjie@xiaomi.com>
To: jaegeuk@kernel.org,
	chao@kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	jack@suse.cz,
	axboe@kernel.dk,
	tz2294@columbia.edu,
	baohua@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v4 1/2] f2fs: complete dropbehind write bios in task context
Date: Thu,  3 Sep 2026 20:59:52 +0800
Message-ID: <c4e69fb1ffd6c6fd968683c690ba29f2b98c9fa8.1788438786.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788438786.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dufzqebbwf6uxfrummzfgf1yor67sd7k
X-Rspamd-Queue-Id: C304C1C0010
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788440411-48686
X-HE-Meta: U2FsdGVkX1+GOsjXtJrxyoklvsP0H5w++amvrIXJ94p7m2+6zNNab/9vKXyGdeuWrta3idBo9YJBYkCz97ndtkUgnY9nbQlEE4KXahBMeVMzbKDIUQlYQACUmYOjDhBish2cVcolT/u9h7CH39xaXBU5Wj/3xpx5tqHnAH+WKZk7DdeVduHjpImWR0Mjv5WgMoBV4YpzsJ86i3Qetvc34YMvrTUJ0lO6qMj7L3ZSFhzHBrxHHv5CX1IpcDBa/p67wj37jIPpYGDubCbruYwRrCna/IpvEuVjP9V/ijamzxuzZhLe4yhZYy5l+w5NKZZqmtEVliDbuFsOFyMLyiBZAUmgLP2JiDHNQTpkkrCw2u7QJ5Nd+My9XtrD1KsejFpvRyr2IHNDJ8HblProdoYN37qVG9aWgbKpIthZ2P/pEim5xEwEg5ufYQD0YHzCWOohDJkhydTZMa/AjROq4yai042r/GNoEBJKKSMYm1NMdREnMCUCMtEj/CiHtn6B752x6EKrPTtIOypTM37nhrp1sdOIXUorMr7u4CX/0jHLRswvG8yisLfwgrLliqcAMTUnNqn2pOGkRPfZiUuIKacHeHFXyh6wBvMPkI7hpqEznU0JFMYp+rLX+VjyqEOyY+TystCFDJiaWj9kwIyBIy+3FXQrHMbIQGyoyAXajIlvG6LbhUO4ClctbTXW/WzWko6jGO7PoyTnjLxWxToX8g2dzIO57hPMrGO1rr4RTPrh0X/DYH6o6ZQLbXLtgPq5fGsixZ1Dfvi8VWZuqebIyoN3W2S8f/EcV9dNgYJJBOPiRh+HbI71NXidfipBO97/uaFt2iKbsBtI5sOIMsw5/cvPT5nCaucRbMLMnpyoJ01fffPRQRMWILyaNn82FDkweqj1MmigRZS6rXB4Xuc2DVj+oxNMXZHGmkjAiBVsULmGfdyO7NptJlonSbdmNSNt2aup/9YGf4i8bkUf6lcD+E/
 R6Y/NMVT
 0otEoBhCHQ+YE7H8sk6iLeADoh0pXVrq3ukjZ/dYemuXNRXBuQgp53xWhIhOe5mUVVsBjbGaIsHqOSR9Fb9EIZ7xMS7WXH2CyuW/PBa8GJ9dGv6plKCctPVIJXTfDMz9DxySVI0kjHBbe7d/Cgp9iCvjJJKgTVFKS3kHH60vQZb3jN8D87Fb6MzyEZp2wwBK9tYLUPApOentxbf1KAE4T0AhojyBmH684IeSSWhVmzcoJkOts5wZVj1TUUHUmaCLOl5kmSwTLIRkl8JMfcpLT0vpIjDl373v/7TUQeyz423wncovV2/7cZzD/9cicX3V/kmxmaDRRk1FgX9OIfOFrMO54P2gmlrMqyZyvh3SbDlmvEFOHg48Nlfxodw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Buffered RWF_DONTCACHE writes invalidate dropbehind folios at writeback
completion. Mark these bios BIO_COMPLETE_IN_TASK so the block layer runs
F2FS completion in task context when needed.

Use the same flag to keep normal and dropbehind folios from merging in the
IPU and OPU paths. Classify the original page-cache folio rather than an
encrypted or compressed replacement folio.

Keep the existing large-ATC completion path unchanged.

Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
 fs/f2fs/data.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 21f396ebe22..b0fedacfd12 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -503,6 +503,8 @@ static struct bio *__bio_alloc(struct f2fs_io_info *fio, int npages)
 	bio = bio_alloc_bioset(bdev, npages,
 				fio->op | fio->op_flags | f2fs_io_flags(fio),
 				GFP_NOIO, &f2fs_bioset);
+	if (!is_read_io(fio->op) && folio_test_dropbehind(fio->folio))
+		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
 	bio->bi_iter.bi_sector = sector;
 	if (is_read_io(fio->op)) {
 		bio->bi_end_io = f2fs_read_end_io;
@@ -793,6 +795,13 @@ static bool page_is_mergeable(struct f2fs_sb_info *sbi, struct bio *bio,
 	return bio->bi_bdev == f2fs_target_device(sbi, cur_blkaddr, NULL);
 }
 
+static bool f2fs_bio_dropbehind_mergeable(struct bio *bio,
+					  struct f2fs_io_info *fio)
+{
+	return bio_flagged(bio, BIO_COMPLETE_IN_TASK) ==
+		folio_test_dropbehind(fio->folio);
+}
+
 static bool io_type_is_mergeable(struct f2fs_bio_info *io,
 						struct f2fs_io_info *fio)
 {
@@ -985,8 +994,10 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
 
 	trace_f2fs_submit_folio_bio(data_folio, fio);
 
-	if (bio && !page_is_mergeable(fio->sbi, bio, *fio->last_block,
-						fio->new_blkaddr))
+	if (bio &&
+	    (!page_is_mergeable(fio->sbi, bio, *fio->last_block,
+				fio->new_blkaddr) ||
+	     !f2fs_bio_dropbehind_mergeable(bio, fio)))
 		f2fs_submit_merged_ipu_write(fio->sbi, &bio, NULL);
 alloc_new:
 	if (!bio) {
@@ -1086,7 +1097,8 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 	    (!io_is_mergeable(sbi, io->bio, io, fio, io->last_block_in_bio,
 			      fio->new_blkaddr) ||
 	     !f2fs_crypt_mergeable_bio(io->bio, fio_inode(fio),
-				bio_folio->index, fio)))
+				bio_folio->index, fio) ||
+	     !f2fs_bio_dropbehind_mergeable(io->bio, fio)))
 		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
-- 
2.43.0


