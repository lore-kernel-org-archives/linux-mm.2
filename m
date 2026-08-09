Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B98C5AC80
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 11:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71E876B0114; Sun,  9 Aug 2026 07:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5F76B0115; Sun,  9 Aug 2026 07:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BA56B0116; Sun,  9 Aug 2026 07:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32B746B0114
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 07:55:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9852A26ED
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 11:55:45 +0000 (UTC)
X-FDA: 85081576650.11.8A38343
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8A83920002
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 11:55:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XA02xsgb;
	spf=pass (imf03.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786276544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7JzxgtsTDUoR0wIQZpzPj4WqrX4aVTLG8zDY2f63lEw=;
	b=U890vH+8D1tbyDTwmcUADlPZ2Ppm3Tar+SUl45r3zVpY3ajOhvrMp62lz09PqgZ7oCet2E
	Zzn4nWqqhdDwXkNf2Hs8ZUUgTE2pfr3pwKnR2TWtzZCSH6SFPSQnC/J+FuT/+uUVp6Fuv9
	uckgy/Cl4sRHZIv2DzmUYMIO2LaCvWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786276544;
	b=Ylxu+hcl2LnvSUW89JEcfQCAXLP3YSa3B0oBimDcIIrSWp1WIvs+8a534BlnCkXmtax26w
	3VSbbh0aW3+RhMjqsmId2p1Bj2RSiLfXt6MtqEc9NEWLiYLHQUjIKv3f3gz6WseoTFWOp5
	VrHBHilqhZNgxVcZA8r3/S02hbRbvvQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XA02xsgb;
	spf=pass (imf03.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7J
	zxgtsTDUoR0wIQZpzPj4WqrX4aVTLG8zDY2f63lEw=; b=XA02xsgbMqUxmSXwx/
	7DpIUMxNgzPQJVnA2iAcq/2pbWte18lwpEAQMFnWyaHiurbPUNGrqQyC6HQqZDYl
	lsWZvmyjthlz1HMWHeRRINrmP327Sfdlu4C2eN/CR10LurDH0GVYz3Dr+RMjqAmS
	SGV0ohOHAtgjYZYQZMnx7yMsA=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wCnD5ShanhqmevnOg--.50263S2;
	Sun, 09 Aug 2026 19:55:14 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: minchan@kernel.org,
	senozhatsky@chromium.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH 1/1] zsmalloc: account for handle size in class lookup
Date: Sun,  9 Aug 2026 19:55:18 +0800
Message-ID: <20260809115518.3791787-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnD5ShanhqmevnOg--.50263S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFyxKFykKFyUKw43Ar1UZFb_yoW5JFW5pF
	47Ga48KrW5XF409ws7Gw4qkayfCw1xGF47JrW7tw1S9ryrXr1xtry2gr9093yUCr4DJa45
	WFZFyw15Aw4DCaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jrL05UUUUU=
X-Originating-IP: [240e:46c:1000:421:146d:94c1:77b6:b055]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2wJ7dGp4aqKvPAAA3f
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A83920002
X-Stat-Signature: yuiuywqwpm4xgfyjme1k51nao86dcy4w
X-HE-Tag: 1786276542-558599
X-HE-Meta: U2FsdGVkX1/NhJIIIyvp5GCcjOuKrrFSRYvTY9dGuhVmzKhBrlAfbIsh0+qSMTcK7nbkRoObFgtG83RdBOuv28TXfUaL4PxSNeYn+lV7xZbiPegfeFV7w8KAqwFN5sHGb288D5kjGtf+Hz2KdqqmG/Ng3ga9Nf8V1/2iKgB0Ej0njwRO+2zmgPKqegXWlRJN/XLWV0y17ywssf/QGthg/TdVPpi+p9ZUCRuVaPy8Y816vvO3iY986Sj4aCbU/pV5QOGlVDdlJ/JHgMXNzZDE1ej9Gb49vltJIhz51TpjgYiMY3AfUm6+aFlpQV7Xjo5LrZ07f18t9++YgQO0Wsu2WJqTtlPp2Ef3eXSUAeXfhOBOwmYy3KQFunGah/WTflK95DwMp6VAsH+PwS3KO6ODCoyWFOT6W4Jgez9FVVIvjVFSdYTk2hbTpSbeYeciHJm+uUjMAupJBw1p6oXCSLED7fJWTXpoNLyJ2PgfTGzn0sb0d4S8wa1G8MFqEOpTMQwOhcdTY7iYiTIdBTRVi+cLhi2QacO1XO1j2o3Q7QHZ6pSfjSb3XWkHRzGWYmsKRYM/7gMc9pIcHFc3p+aExD26Cd0M/QPp9ZuaPlazmGZW/WrkW+GDVW8lXfp7HJHWN/q/Ey4HOqHNaT8wfOcYbKYcTsiPALb5h0aTzh+g096Goq6aVgLslZKxZR4rMbeS5mN0RFFv1YkmE6Eka/L/HZAVo8MexHh++94eZy0yIuY4iA75ySGv/Qqi3BEUD7pCz2HgpC3mgb9bmiF0vWwDpvveSmPkxuqX6BH25UB/Tzolu9NtAyAFaphjlzNvD6WKTVyJXikjnaPZIw/VF5UrLUTXomXT+HbaUzri6NAH3nRlGPHo5kgiLjVzCled6qfJifC7jfyufIdOFCxHg75XGglVdlxwHRqEy7gV4UC4E4jpd4thcG7nxRgqaR4DtHnuqvDNXB5ZU4S2i7+SFKVAOK3
 /6PzmdY9
 kIjNmB/19tLrmINeqBYmHbqCuSEIU9ExJR+7Rdo89NLbaRMOqmrkiPvqxhV2S2mbLt5zf42URX19ae+2aiqWJNoYe1qaSWlfdN0PWge+eJXf1knS47LBj9nyIw0qanrGH0yMhXjRt7wJwN/ifBFhJMuRVWFUJj07wHdQs/KX1tWcivEKRQNV4VejALEFtJwHfvTdvart5twQiVPRvpAw+TBxZ48dKsyzo8aXR6X4EcrBgo8wqbqMaXMF2umuvtjwp8BZrRMCFMq5oejMyy6nCrDubbxroyLbvWrxtSemRQ/CAfKLQL8F3zn7uqtqKpEvPswHkbzH3ZvSmJIr5K8dXRGJrhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

zs_lookup_class_index() lets zram recompression decide whether a newly
compressed object would use a smaller size class. It currently classifies
the payload size directly, while zs_malloc() adds ZS_HANDLE_SIZE before
selecting the class.

This makes lookup disagree with allocation near size-class boundaries.
With 4 KiB pages, CONFIG_ZSMALLOC_CHAIN_SIZE=8, and 64-bit handles, a
1025-to-1024-byte recompression appears to move from class 64 to class 62
although both allocations use class 64. Conversely, a 1049-to-1025-byte
recompression appears to stay in class 64 although the allocations move
from class 65 to class 64.

As a result, zram can accept replacements with no allocation benefit or
reject ones that would save memory, potentially marking the object
incompressible.

Factor size-class selection into lookup_size_class(), account for the
handle there, and use the helper for both lookup and allocation.

Fixes: 7c2af309abd2 ("zram: add size class equals check into recompression")
Assisted-by: Codex:gpt-5.6-sol
Cc: stable@vger.kernel.org
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/zsmalloc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 83f5820c45f9..41b03a9ecec2 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -478,6 +478,11 @@ static int get_size_class_index(int size)
 	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
+static struct size_class *lookup_size_class(struct zs_pool *pool, size_t size)
+{
+	return pool->size_class[get_size_class_index(size + ZS_HANDLE_SIZE)];
+}
+
 static inline void class_stat_add(struct size_class *class, int type,
 				  unsigned long cnt)
 {
@@ -1021,7 +1026,7 @@ unsigned int zs_lookup_class_index(struct zs_pool *pool, unsigned int size)
 {
 	struct size_class *class;
 
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	return class->index;
 }
@@ -1311,9 +1316,7 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t gfp,
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
-	/* extra space in chunk to keep the handle */
-	size += ZS_HANDLE_SIZE;
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	/* class->lock effectively protects the zpage migration */
 	spin_lock(&class->lock);
-- 
2.43.0


