Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37C2C54EFC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9DC76B008A; Mon, 27 Jul 2026 13:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EA26B008C; Mon, 27 Jul 2026 13:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C81B6B0096; Mon, 27 Jul 2026 13:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 594D46B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:39:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4E7940114
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:39:03 +0000 (UTC)
X-FDA: 85035267366.03.312D465
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id F416F1C0007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:39:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZiepJmKM;
	spf=pass (imf21.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785173942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0hJVHazYazGztb5eblHaG0/pLqUutsXS2rY6ebQ7Q0=;
	b=liCA+Z9xWFL8E4bPDgMvv1fz8wPScq5OVfY4Acl8iGnKgTi3Yp54GM2vbdk588LEUeD6QA
	buunCcUymi8oQMJeIxIZ+vaZoW+7E2qfqZKqb8K9fhQ/nUpVwKNlNOpnZxILxxh55qQnx0
	JY9MwMZqX3vLjL8bVXtCLHhTWFCxBEM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785173942;
	b=8Y8SMdRjgVw+79Fl4XyoRLiYUuR/VH2zq36dQK/X2f+Qdm0A5YIrUq4o1l5xI1I3W/FwH1
	/anMLOGJBaHXmmYTGLLtCHvIglDEx2r4pSc2jaBlqfA8MoXZbv0Ig3u09ZQ6VzMer5Lb+i
	aynXf3kWKYZB+SNK0yHosZL3eRQF0vk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZiepJmKM;
	spf=pass (imf21.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ce98cb8165so1974455ad.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785173941; x=1785778741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R0hJVHazYazGztb5eblHaG0/pLqUutsXS2rY6ebQ7Q0=;
        b=ZiepJmKMerEYyBjuFbtNYVLCB6ZC1NOedjkwmklIjzCdCes0t59DNcUD49wV67hzYS
         +RQFFyXmTXhKPsXQBFH6z6/G9jjuKuWYz1yBUkrsCr8P2t7VP3jFQJ+vuMoiGRtEaa9A
         ji8jZ4DXRgOS6CdWR6ey9tjGv3Wneuv1NS5QHId6pCK/m1+dlgKnD3/zYZ5Vvsr8AbuJ
         KHWIoqfBr5T/w3/M55v/ZTdiBXktwVlhIXBib/LUC22QFjgz5AVYJA73D7zhxXE7Blt+
         Sz2y6o0EqrcBqBzClbsJDD25pM2PHLgXeXFJMimBQzImVKEQeubgVLln7w0t/5xGlK5+
         2ewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785173941; x=1785778741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=R0hJVHazYazGztb5eblHaG0/pLqUutsXS2rY6ebQ7Q0=;
        b=JkaFpJn+Q3AUhpBL7b12kA1bhb1ShbheIQ6zBVmL4IpuWAwghuGGt33oKNNKlHF6gc
         2wQx6m+utcPB6CJKVXVJyDi/8Ag9xbeY3m8mXYqPGGr8Kg5d2PYxV2m1iME24u4yo3ze
         Y1jGU6HOmOrt6tCgIW9zFW9MEi7N4bmEi9duY9V6EbqdzKOJYfNpjgXlkhT1kQyMRS3k
         2VtQcxg/hKliafFqu5lIFt6keqoTZ7BshepeC4FyrjSotnCZ2rG4a2P/Aab9OOSsQ9lO
         JT6Aymfx4IHU7OG11PCSWZ0aKdUhAJlHKqcaUOQODobUiWK5XqgTub3p1SghrcwFq/CE
         fAcA==
X-Gm-Message-State: AOJu0YwXadT4Vv+nh1disC87P3Q8Sxk8o3ryIA9djKzYDicfD95LTSDl
	KOjg48bMYjhLGKJWgvCpV9zXPOMGqqB8biviZ0/kA+6U8XmV1/4e0y/p2ufLmQA0DJk=
X-Gm-Gg: AR+sD10T3UcA6eqAQq8j6cdBcd5TnQAu5eCO3rdcYrSg7w9am2lf4nQlfPBW2/lnXX0
	hJBHOT1dZiQXM43FhL1lQSnAXzHHxblouzUtCKihLGRVkui3oTECks09trz3Vv37+pnyTCHim7y
	fLM+26u1C1j+n2I0cYN06a1/w51C6Ts2WLpRRAiuLDH21zqNFCODpsS64Ni+QouFhHi9wbUd5Cg
	JOe7DQhVQez5R+7gQrQHBaYhLdEQG1UcW7izQSBsuhkKrtDsnvuWLiQP5IeviRwXIn5RIL2Mec8
	dVTCVv7kMlGB3kGMVFnrXEvBcff4JRYkLJP0pwhxX0Ay78vZMn05+2BVNzOo9DnhZ70yy1rUxvF
	O3iSxO0EJQXIIaqbRdiUwN0Hg1iCAZNmh50F7/eAlFZ2+sHRRjxkcuAS1/rxDQYBZqLiwKsaHSt
	yekZWWVOl1tVsQCfMunC6w
X-Received: by 2002:a17:903:3884:b0:2c7:f5c6:c4a6 with SMTP id d9443c01a7336-2d00e6658b6mr4287505ad.7.1785173940935;
        Mon, 27 Jul 2026 10:39:00 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59bb13sm39402515ad.1.2026.07.27.10.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 10:39:00 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	zhilinz@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH 1/1] mm: shmem: reject impossible fallocate ranges
Date: Tue, 28 Jul 2026 01:38:51 +0800
Message-ID: <adcf644e780706c220809b7a41e6e496d2181806.1784947149.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1784947149.git.zhilinz@nebusec.ai>
References: <cover.1784947149.git.zhilinz@nebusec.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F416F1C0007
X-Stat-Signature: eccetez3rj69frhpm46sxtkto6op77nr
X-Rspam-User: 
X-HE-Tag: 1785173941-111863
X-HE-Meta: U2FsdGVkX181mptz8CzCbfWwDN7kWAmNRGcnp4Zvrk50IKuZs+W96n4TSOGK6JK9Hqsw0QO23maUr6R3yBlwb3vHwmjukjOAMMdyzwiqWOdN3fpbwWjaAAsvuBgkiQWjaN0CgI+o1E09vyzrGtzse4+OHNFZtn9eiPXDNTi7zSdlf9MeBf0cqldx5N2yH3H7aCuze+3Yhz2dB2AvQ+mYy964+sA4S/TphJu/pb1hrO51XGRp7Oe+CPLyWyyb4F/vru0upk1J4Ju6kgtKPv10VRKLbkpIdGI8jztXMstTmEXpxDyh67kpQ4s0t43/5ErQtYbMV31npOR23dExyQCmeuUYyDQCGHV5j4O3Al7MMa06npLsVr49KLSJ8ax0frACTNZKTmigtVNmq5QgK96IzmKP/ts6p7kstUlCa4UVD2+j++ltLa8oqOfex5Hq1HoKkXP3ttDTaDeJII4IOABmIBmWp+JY9ucbwHEb0LBXYo7mUo22uPn7oG40J/czEMnNJzwPdl7WT890OlP52Vy5Eu9kEHMVUd52uw6mgodxCJfagvapmKLJlV/htETS1/qoCe8PhEhsEjkhWMxp98jMcm7pZE0hEyiLSmgf8A34luLEg24cfxzPSTD57bYL0tWNi8KalAejS5EfnjlFpoee+KPvZbkdeHXAtiadP+zV/gD0WUW2shpAAqidX8a3W2MKWmBHcHMfAryo4mexQPti7miR/iErf95KfIDiL8g0MH52Oejh6R9f7PQDMXYBCWNLvKZy006RP7hPYzfyWPczYGw0ObnWUEInMjDqshzwdIfdjdPdXKwLEj102ez61aZxXcwaDAv6l8jpG3pqYpKv2IhK7fw4ax4z22vqfXatRgCwsjNXyBy4DTxMAFlnK83GahSM2V7orhNGyfAkcf2uD0ZbihU4Cj3hgnROnMXeTTiNKNPI2i4SI63gVAIW3T0U6cx/01EY6fmUGPQcQg0
 ch72doxh
 ln0FKKKSRIhKxqL6ao3+VC6pu9WXu/OFrC/WrhaQwj94gnmRutM81CKmc0UcWy8SK3+H9cXqjoOVI3+MDSJObXTSHSGZytrKhm2cBk9RmH0VWYfAMVJ0YMlo0wxS3x2s545a8SEpKJaLsYRjmbkcrMw84H3XX8OeDgy+iudRsZ4z/CctLqLQXT/T6Aev4kdAqA0sE3HpqkEJh5HqH1nShhxTEKu8npry9JZ/f3blmWm9OFIVVRcoGnCJeXNvVf/5TM0BcvQ1N7hGyoJAseg2oQ/Gxzbs+hHSHkMQkaXjIemgZiz0kfb8NxCUgkgxhegtKAh9yANl8UIUKMQ5T2/2aYGvNZhn7hCwhQLXJcs8xmkfs+bo+IxTVbnF6r+zsuYN3Jp5R4TdOla8Xwy8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhiling Zou <zhilinz@nebusec.ai>

shmem_fallocate() validates offset + len with inode_newsize_ok(), but
then rounds the end offset up to a page boundary by adding PAGE_SIZE - 1.
For a valid request ending at MAX_LFS_FILESIZE, the extra addition can
overflow loff_t before the value is shifted into a page index.

On the internal tmpfs mount used by memfd_create(), sbinfo->max_blocks is
zero, so the later max_blocks guard is skipped. An unprivileged memfd
user can therefore pass a length near MAX_LFS_FILESIZE and make
shmem_fallocate() iterate over a huge wrapped page range, consuming CPU
and memory until OOM.

Cache the validated end position and cast it to u64 before rounding it
up to a page index. Then reject ranges that are larger than the tmpfs
instance limit, LONG_MAX, or the system's RAM plus swap before the
allocation loop.

This preserves the existing file size and seal checks while preventing
the memfd path from entering the allocation loop for impossible ranges.

Fixes: e2d12e22c59c ("tmpfs: support fallocate preallocation")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
---
 mm/shmem.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb3..d626561d46db7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3601,7 +3601,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_falloc shmem_falloc;
-	pgoff_t start, index, end, undo_fallocend;
+	pgoff_t start, index, end, nr_pages, undo_fallocend;
+	loff_t end_pos;
 	int error;
 
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -3649,23 +3650,29 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
-	error = inode_newsize_ok(inode, offset + len);
+	end_pos = offset + len;
+	error = inode_newsize_ok(inode, end_pos);
 	if (error)
 		goto out;
 
-	if ((info->seals & F_SEAL_GROW) && offset + len > inode->i_size) {
+	if ((info->seals & F_SEAL_GROW) && end_pos > inode->i_size) {
 		error = -EPERM;
 		goto out;
 	}
 
 	start = offset >> PAGE_SHIFT;
-	end = (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	end = ((u64)end_pos + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	nr_pages = end - start;
 	/* Try to avoid a swapstorm if len is impossible to satisfy */
-	if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
+	if (sbinfo->max_blocks && nr_pages > sbinfo->max_blocks) {
+		error = -ENOSPC;
+		goto out;
+	}
+	if (nr_pages > LONG_MAX ||
+	    nr_pages > totalram_pages() + total_swap_pages) {
 		error = -ENOSPC;
 		goto out;
 	}
-
 	shmem_falloc.waitq = NULL;
 	shmem_falloc.start = start;
 	shmem_falloc.next  = start;
@@ -3699,7 +3706,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
 			error = -ENOMEM;
 		else
-			error = shmem_get_folio(inode, index, offset + len,
+			error = shmem_get_folio(inode, index, end_pos,
 						&folio, SGP_FALLOC);
 		if (error) {
 			info->fallocend = undo_fallocend;
@@ -3743,8 +3750,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		cond_resched();
 	}
 
-	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
-		i_size_write(inode, offset + len);
+	if (!(mode & FALLOC_FL_KEEP_SIZE) && end_pos > inode->i_size)
+		i_size_write(inode, end_pos);
 undone:
 	spin_lock(&inode->i_lock);
 	inode->i_private = NULL;
-- 
2.43.0

