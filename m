Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BE92C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536BB6B008A; Mon,  7 Sep 2026 23:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BFE56B0096; Mon,  7 Sep 2026 23:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387D16B0099; Mon,  7 Sep 2026 23:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F39786B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:56:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8252E1A0361
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:56:08 +0000 (UTC)
X-FDA: 85189232016.25.7FC43E6
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf19.hostedemail.com (Postfix) with ESMTP id A60A61A0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:56:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PO65xj2g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788839766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHuXN+TozonanTrHY2nOVJpLzPnOvGV5cbx8xr3LhCY=;
	b=hFZOhqaXSWklkr992kqGHwQlyMNdpp82ku4YSvVV+8FuD02ETnmAGI2vrzAzgS/jR6drG7
	ptrkpvReKOSFy8t0E8TyA/+d/PeUhHSp9Yprk5v62epHwxC34ixuxsCkC9CZGNU1zAjoEI
	ppyMViY0ryXn11lpGHJqhOMgHDLcfo8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PO65xj2g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=qwjhust@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788839766;
	b=cDai6VBEe4nr4eM9CDPWE0bKp2Y6Q7jSjCqFCb7XY6XQLtTSas+5Mw2FDh0JbnLN1Gudqz
	rBLuWmnaZGgxHY2f8NeP0DeyXnNZPhwi6DEoIi31+hjSjdH8LAKE3E38riSUPqxo6wwM25
	n/cHOJqU3GmfraUAi7t7ZYSFPcoTGMU=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2db3305f94fso28966195ad.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788839765; x=1789444565; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wHuXN+TozonanTrHY2nOVJpLzPnOvGV5cbx8xr3LhCY=;
        b=PO65xj2gdD8WrxMXC6We/NTGTgo6QnYqeyZYNiOYGjucpkaTiErq6EsGDKEOcSZvcR
         FJ8/Dggg4TCrC9jZPXSJafKycmxY1gVO0f5qGtS899uB6x5se8hjoUox9GFrhLTfcQzM
         AgfMBkBDOwnBNgL2U36Afr39yvci1gZsVC0ms1IwDCF8I8OOjsFniqRCCPgcKOdV3GNF
         ypEQdgIe/4QxQRBtwRqJdMGJEbllf4W5lAlSVyx7KYejNltm575jKi8X3VPXWken228o
         fymGNDSsGdgF07p0PYyfhocC2TtmXTgThf5eIx9JO+WIUOdAb3BAKqnAI3V4wh4ulYfo
         sRWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788839765; x=1789444565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wHuXN+TozonanTrHY2nOVJpLzPnOvGV5cbx8xr3LhCY=;
        b=UD+FpaYjcmQskqXqazUt02e3FWJabBPuUc+ghJy4Oob5387HuxztIoACXVuCYkxWyn
         bpxSkydL1lVWL566r1i8Ajw4bDKDaA1WlDCiB3X8MzGBDEAehKrfBa1haF7O7RFrWRzn
         ityh59rW91pbfVTTafahNK7Apz7QnlaM/CCZhb5czADT4XoUfMqV9qwJ7uRdvze2ZyGK
         IgugJkVVnCCrWXo3U4U/CPr5R0dtUQseT/p5WXb6gvlXTaOsRuvpRzV1pBRUc73L4eIA
         Yr2XfhsIf105P6Wx704kX78dPC2+fUcMpqeqW9Pb9eYyFMViPvMR1M7ZgMlcvM7MdjLk
         YNOg==
X-Forwarded-Encrypted: i=1; AKwUvBzOTWGpQ0bxhpu0VKopg8xzQ3ragLRjb42sZM7JOr181RgTeIs5kTvCYPrq5IgK6OCN8d9+Zw2YgA==@kvack.org
X-Gm-Message-State: AFuF++mBekzCK9vhSu9MxXBYWN25KPLGXrn3HANEyg7ufZ3oculuGSRe
	Xw1xB7YdcXfN82F54UgnDnzgg5eJ2AiAjFCpYvb0WbuaGCHv19ib1wS2
X-Gm-Gg: AYBFou0ZYXnvZsvQBwFlZtZX9rFhhyq6sOonMVSafJxYXpUSx/qFLIY9YEAYbsLl/D3
	dAZQc2u0KEE1rD5HI9LPw8uHE25JPirfccwOkhtbl1/Adw1jU8p0S9IMqTnNFG3JRr2fnb5EzFQ
	oQgI6cj578AQCmtO1xaKgbZxeJyhMr7jw0HFbT4Sm/Etsksw/esvharjzkZ6VlhIBdWDi5qcu+8
	tDtfktILYYLyj76ULHllLKNUCJxwEwcp3rmTJ0TBbBsf93blkE8UTNHixQIqnA8V/LH0qctS9Zy
	V8ke0sMtsC6YsaQ5G5UFrgsnznISJLJwi3tBhlDoHwfG+1ItNC1Pcp9I+QYCClmcMBn4j1FeyHx
	bYZcCJPAqtVBkfB4bnV9RrUZekwh655D32JLOO0kXbCXinD2ggosn0XTK5/iA/mPoTk6RdhaEVP
	BtnlyWV1iKLnw6q4icKgL1s79dMXU+dStabpj93CU5nLID6JXeMdPO0sUWUVNrBfwbhx8jgCO79
	OMm+igCxcx3XcjMloSUcuQm
X-Received: by 2002:a17:902:f70f:b0:2bf:dd0:c8b1 with SMTP id d9443c01a7336-2db1225b297mr394667095ad.0.1788839765501;
        Mon, 07 Sep 2026 20:56:05 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db14aeaf74sm51899295ad.81.2026.09.07.20.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 20:56:05 -0700 (PDT)
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
	qwjhust@gmail.com,
	syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
Subject: [PATCH v5 2/2] f2fs: enable buffered RWF_DONTCACHE
Date: Tue,  8 Sep 2026 11:55:43 +0800
Message-ID: <1cd46ad6e0e566c283dd70be7864248f504b1997.1788795700.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788795700.git.qiwenjie@xiaomi.com>
References: <cover.1788438786.git.qiwenjie@xiaomi.com> <cover.1788795700.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: t4jhxrwku9h34f4krseqdsb4d8mbk5nq
X-Rspamd-Queue-Id: A60A61A0003
X-HE-Tag: 1788839766-653524
X-HE-Meta: U2FsdGVkX18H1n8vNjbadW4mnIOIPUZ6cCJWws/mQuMwirdF/YcOa/g0hl+ttp/pV6rJKLH3ioCXnM8uj8BaPHH2aAElM1N+QZCQmFPqBqhCRED8Oa74/y6R/YvnOnKXup/S5Slua/jXwIh0DzjzOLbUwpX0oAoLhME8ePR7eAK8RRynq82w7gx+3ssSF/OWgetzvwB1i8tkMbsuKuPViCOlWT4rtA/NFJqm5AsRWVGv6HL7z9T8ZTazv+88vmosI6urXK4bgUlRSdiqxcHHayR3XOHyh0E0BhBU4tJi7NgnY1E1HA0ooEEJe7DzlQS6Yo1JezbctphIMM/s/aBI9xdNR6ywFR6a9DHW4kXqwyrWM8i9NY55iFNkORdbPkWN3MzPrMMHQ+TMG9WX5YNaK9dK0bbWc4/aAPR9azSfRbK6GvICUjlUnPXyzpuJta+6ctUQetoRODnK2rkoMIisr9FodtN+AkUpFTKFx5yW3BbZEsG3wABJxcU+ndET7XzyUxEPIXXavd+TGidz0ib3LJzQwnxNLvv2wh04p5Q9wo2edrh5HpFQXlP6vgnRiIVPxiOatQ4l29DVKe1hmCvNqIBZ5FC69V8KQr/8K8NdHdiJ2c0wCoEbYOIqpqDyd9kbeJ/+12agrz4vlIr7KAH8BC4b9piY8uS1aGSQtZHonpEr40s68DgI0V6KHKs57I5DgcH2Eg+qpI4SxY3qRm75+fqB9vEl1gYqMpHrHdzh/JSwNVDSGWq2a/tzZlgbcZZTrARSPZd+eFlEu4fUpQbALyJ/lu+ygppOvlWZZAhOrWr0tMof8s9SDkL01O7Zn0GQ2UsQfJM1xtyLLRoDWJrI1gX+W5RdTIz6yoHFGFD1Ut6M/qqwrEKUhuGsVqJA+/9LYqvL74h/vFKjlBhFu9AXOLMUh8Espcgh4j7pzT/S/z38iiCBdE41ucwhupSkycppYsfdAyAnYSz2RyHwRCy
 MlOpZVQ8
 xyzQjWkN9PnfaV8RDFoIhbrm0vROBjk4Di/S7QlDCUV4IlyToIvNQzF9IgxvyuEQOmtXGWXWYfpDIkNPLr244cFOyxWv1D8TKHBikD6O2k5j/IJgPgr0SagdAZ3clubHbc+PvW8apSn6M2he4ADVt/EEpoF/ldEFt61Ev9W99UvjUdFj0jd/7lx7NiSbckLRzzmQqnLIiFHI9hdpW5b0Oi4EqqgKZbhS5sJLrJE+Ijq8YgW6E1lkfjqUb09mPxv7K+saabC/EEf7Q/Avu4GH5cXpoH+2qT5hOw4+rb7sU77dGE+mVmxkQ8XKgBQfgwS3JDXDfEuT7+u4ZZtj1sY2DwycXHG6vxa1u64g/NI2mwteDOS77DrBu7+1O/HGsg4OZ6lOynyGAWmPqmtmgyDvd5cKaYbRyXwmNBCIKGKKls/vzTKbUsup+1ULAfn3P8utIGJQ7oY2USLBNQZ7qhbeGUI1vOFPTV2vFgSvU0tfhlMP9TTLu1Zug7vuf8+cvv0ysPf4dIQpKq5hq5MYeBZqUJ+CENWw3OTjbS05E/XNa2MpNgtg0V5W6mBit0yVe8694fXhc1bV3GxxAwqFlewXZForEvziCsj4LPZhE8WmH42ZbuNyzCpM6/IIA189gJRLJLI6bT0nvNk2BtW8WST912gaYNlkkom+JEExN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass FGP_DONTCACHE to f2fs_filemap_get_folio() for
IOCB_DONTCACHE writes and advertise FOP_DONTCACHE.

The address-space write_begin callback is also used by internal
callers that pass a NULL kiocb, including page_symlink(). Check iocb before
inspecting its flags.

Keep the F2FS-specific lookup because write_begin_get_folio() adds
FGP_STABLE, which can deadlock here.

Reported-by: syzbot+cid5582b8164122eda@syzkaller.appspotmail.com
Closes: https://ci.syzbot.org/series/cbb9ded8-1388-4a7b-bfa7-44082b04025b
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
Changes since v4:

- handle internal write_begin callers that pass a NULL kiocb;
- add syzbot report attribution.

 fs/f2fs/data.c | 9 ++++++---
 fs/f2fs/file.c | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index fc48a752fe9..c9b29882f07 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3883,11 +3883,15 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 	struct inode *inode = mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct folio *folio;
+	fgf_t fgp_flags = FGP_LOCK | FGP_WRITE | FGP_CREAT;
 	pgoff_t index = pos >> PAGE_SHIFT;
 	bool need_balance = false;
 	block_t blkaddr = NULL_ADDR;
 	int err = 0;
 
+	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
+		fgp_flags |= FGP_DONTCACHE;
+
 	trace_f2fs_write_begin(inode, pos, len);
 
 	if (!f2fs_is_checkpoint_ready(sbi)) {
@@ -3933,9 +3937,8 @@ static int f2fs_write_begin(const struct kiocb *iocb,
 	 * Do not use FGP_STABLE to avoid deadlock.
 	 * Will wait that below with our IO control.
 	 */
-	folio = f2fs_filemap_get_folio(mapping, index,
-				FGP_LOCK | FGP_WRITE | FGP_CREAT,
-				mapping_gfp_mask(mapping));
+	folio = f2fs_filemap_get_folio(mapping, index, fgp_flags,
+				       mapping_gfp_mask(mapping));
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
 		goto fail;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c763fb972e8..92f916ca8b9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -5920,6 +5920,6 @@ const struct file_operations f2fs_file_operations = {
 	.splice_read	= f2fs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fadvise	= f2fs_file_fadvise,
-	.fop_flags	= FOP_BUFFER_RASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
 	.setlease	= generic_setlease,
 };
-- 
2.43.0

