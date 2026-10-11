Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A4D5CA9EC9
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 11:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E006C6B0088; Sun, 11 Oct 2026 07:29:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1246B008A; Sun, 11 Oct 2026 07:29:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7426B008C; Sun, 11 Oct 2026 07:29:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A421C6B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 07:29:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48A1B140791
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 11:29:49 +0000 (UTC)
X-FDA: 85310125698.06.D9000C2
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 934CC40006
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 11:29:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kg04YWXg;
	spf=pass (imf12.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791718187;
	b=qRXl2Z5lE7uM0PpVI7TZq/U1ak5f5OymkTkJcmTM0tZuxPJrW/ubcdzKJvUKTESd7dA+o8
	ts26P3sueoMsrvLgXJzDjWTvLjPFPbu97BQxGj1YKgl3w3Rm+RrN2Za718g+5P7/WjJi8W
	1dqQbmJ8z5ymNFOlU95fWyZeGIXLJD4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kg04YWXg;
	spf=pass (imf12.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791718187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T8upKFc4zwF7GAlleDsmhpQF6jhE16xCYO/bJ2qmSMQ=;
	b=Bx8nnni2BA2ILsDrKBQMBXRiQyLiB29ctC9iZqhKejmHmll2NzYt9ZAossYZmcoD37+9av
	c+Y6NhxEjgMljTTD9xdpFQyPxh5TSqoxJ8FDqSizl4pDWMmM73GjqBbSEmaLtHmawhLyRp
	jzXxwudq8GFzTCBjvEEbOMruBHOfVqo=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso714997a91.3
        for <linux-mm@kvack.org>; Sun, 11 Oct 2026 04:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791718186; x=1792322986; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T8upKFc4zwF7GAlleDsmhpQF6jhE16xCYO/bJ2qmSMQ=;
        b=Kg04YWXgUq3vB0wUYhmtc08nBOHCaQcDw6DhLmbZBkYxqO8EL+9Q6kuknWOAdiWJXp
         5HuBg07Qyhqvhl9Nqg3naNE5EX8cXg9ucJugGZzTTRo/GZpkk2H2L+Eo19ztdHLCiSYS
         sgkC9YLsyDNYMCGUeUEMQP5vZgZb3/1iXW2ZEf+QPfTsfcT9H+01LLLgiSrLZCj7dUl8
         Tv2fPBP+3Nh6j9i8UirqmLWPFgTfoanLGdx7LRDrJWKknC8g4kOnb6bRuc2qeYDHXNDd
         D7y152lc77l8FXDPe6oJtDyd0s/86Lpyy+2cYuzT6zyE6K13HMhDGLHTVNd3aStb+8ZP
         uNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791718186; x=1792322986;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T8upKFc4zwF7GAlleDsmhpQF6jhE16xCYO/bJ2qmSMQ=;
        b=LZKLLp8HQacnR81e7LdL12Xrd2wnFvq//Ez1L6B6ltG+AUpKdykEDkxVnCjndm1NX0
         LsrnNyYGSC03vHL9C00ckawgXn5znSuWAlgOQpbEX6uE6dqmONZLe5mB1U669YurwzaU
         hMR36NBudEO6iZavMyXXp5P79XDxQTpuB8TXBS4M6LeAQMmiDLkoIVsV7Cf4Nrg87Y1o
         90BPK7W8ZUnIneOVCM36FlyYfgA0yVh5kqHPec71VC9Qfb0Q3sPp5G7NUSvp/B/SSf0W
         3YItDcVqlx8N17en+enG7h1qG8UbDHmfRmBD2tr4Sh62ImRQ+iF0KEQ3YzkpD2OV3Cjh
         RRkQ==
X-Forwarded-Encrypted: i=1; AKwUvBwIDQXI1n2JwiPEuuuJw/eX6DlMWKkbJc6VQfH0wABboFTSK5eTrQ9sDlXHWCISxamCQKEEQ4wwGw==@kvack.org
X-Gm-Message-State: AFq9FYLK7OutQv1jajSLdD1C+AUBaqkbT4WxT5CJh+uEtpd63aUCzrYc
	gObqDaQbtkgGtmdQH5Znab43UOaH3q1x7+rVHCwz84cmCmLyGcjPMeE1
X-Gm-Gg: AYBFou3A2AkbPEbV04cjqAnk9gmYgaG8nG2jRc6sEcZ7SyfCBez1Ws07R9rjuPsRoyU
	PVdZdfgka0xatIvPetrc5/OFwAHnDtDcRewt+UZJ+3FHl3eNxwvdf97ON2SYcZo+uZDG0+1V8IZ
	ChgJzMjVfcckqCKOQFRHgvhUowEf/iPdd0uhfpsCQdn/IF280oWG8pYZseMOG8Ux9h7p/7XD2Gz
	L9CUF2d8hV2FvxBtXXeqS/dIy48Ef+txY602kvZVcJwno2QpxTLKx6ZqtJQiNDqZ+YG+119zeXf
	CsmwUbQnGzMZzP/BAju+uF67ZVrlc+KGZzTxBJWss+TNBdmueSnJuqke5nxFkV5GiOfs1VSbrfL
	5QcIFs9yj0OZc7/k3ACyUToMmCgGqTuJLUNvARbSYEXzDsd85XLdBhLjMVPszi553F6BF8Pjwq3
	cUx5KJvAKuGcX7erkWfDac8w7d9MfxWLNBDtgaP1/9DMP1hjaQriZ4oI/eGJ2+2nkMXrLu2nMy
X-Received: by 2002:a17:90a:d2c7:b0:39d:f4a8:75ef with SMTP id 98e67ed59e1d1-3ab3a33da74mr5986183a91.1.1791718186275;
        Sun, 11 Oct 2026 04:29:46 -0700 (PDT)
Received: from thangnn-ASUS.. ([2a09:bac5:d45a:16c8::245:79])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab397920b4sm6957832a91.4.2026.10.11.04.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 04:29:45 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
Subject: [PATCH] mm/filemap: mark lockless accesses to mapping->nrpages
Date: Sun, 11 Oct 2026 18:29:40 +0700
Message-ID: <20261011112940.455497-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qjxb8ad6ot6qs4fowmo9mzwkhoz6x88k
X-Rspamd-Queue-Id: 934CC40006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791718187-77150
X-HE-Meta: U2FsdGVkX1/IS0Jj4dMxFIeaP/R7E8KEk+6vF2G+XMWDcciYXayqmSyua9H47TYGFsCGTssE9V2/RQnm9LWTQCQoiNEpN9TsGW9hygjD9D1wXRkpiuPZph3t2Sl2VhP722trNK28LFBSCAgEieNDAC2aHYnj5XZRDU4jb3EtKeNOxZoQpDgNwPcAAemvjdUUjRKQi67Vd7IUdIm8SqhdZ/oyRzc4j+e/bTjOYLZg4FRrDjDtC2PPTWqsCi/jdvfimTxvtooUgSnao0O0L9kDIhh0k1uquMRPBNvDItMsaNqMBPGDUyVkwE8o05E31JH+0rNkxUdVsAS6X3+BlNBmggnw4NqKuYZe2UhhHwQFtPn5A5ZkgrEc5fLP/5qj/yz+rJCdM9nfyPJf8mZlu5CJA0BhnhVztsh1hpY8zhRqEqTKVGyk1JK1SEOrPa4qpPK75k4kujTxpSe/tGizIxvkydyKMM0s6aQMohYH6FOJR5b3qeVIFvJWMgCFtcQJqnHr+CN6oy15e9f/UsCiCFVxXOXU1HuyqNgaez13KfRGDUWY54GegO8U8itQmiJlXRSZnyeJeuUFEKdf7YyTxkig0tm9ajVwAqSdbdgdXdIsOyCXSxbR1jUgpAhwvxH/cF3lJTWXPH0CV1ck5PF1DmCOtPzeg4hnP169rZqTFIPo1f60AEu8vKuSAQ8VYBUOXTHnRnXwY47hE04UAp6CMW8pb8ibUe9SGLZqqmRSOLyEu4EojIVtP+7c14jlUSaWnuOr6FH7zVMdkw7ThoTQ62Cn3VANYYYT8P5MyBE4qcBpvFjPNs5ly+J7z/wFaYhh/rmaJPFp7HMpiOv1ZUzrqIG76y6TmVnFFuZDF7BS9A8B3zzHQfhvOh1NFEo9U6+q5AsCcXgAvr2IAgAlQIUT3CI15pbFQfM2xJ4yvT3QmKtJ0i4026lwb0bST4ir0mKap6u37e1RL2tnZRhk1oi3joZ
 zzmmuZMS
 ftgp+S74r4yY3D6rrUQwOu1Cjw02+JSr2b4YKWJJ8ofCYI3i/nUPSm0J9wJOlLwT/+L4j2ZFbqbW1WEi0QT/82awSC9YLcAsU6PWGwKj13ykuWAGOjmXmCQy+aJU6ji/ggCV+7NsQJ8lgxHRAvE3yb9xgb3a94WF1fNHVjtjJZD8hpeFUphKMtmZpbvg/YAPPpxbAW65iWwZ22zFglY2ZvVb6wQpXCTgfojWN3cHatKfEI7MfCRRfK7VL1NarLp3p+CVsNwPUjFwp4EZeZMVK3Ob9uk3n1757sGrWdnO87WuIXq4NrbtwqqDpZg/+xpnVepbqJNBT29fEZaNAGPUXOGf2lc8PhStZTujvm9BiDSZMhwDBosIi1Iyg9kf4rsMbDUkA1RP+1w4iAb/trWpEgp+VYoL3IPXOojBmlbTrega26LMZX1nhypdY/K37Xvif9Fe+xIazIHqKzHZ5WYXyPLeaGjBwHOMr8ACalBSOqxLhtr+oWf8HxfI7ZHg6KviY9T75KehEXgsdRL0tdS+OJWco2Pk8IJnV5rxHIAaCtv0fJmLwxebpc/Q7fTjP6JJhHsl+g7b7cWkNqngkkQa3vGnnoHZafFDIowLZYtxdAubUBHiPkCyUH1XJNKpwqbJgnr4bC16cm++2tFMB1bUDqCeCy2sJgQ+fWD/MNYkXuS7yqvM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mapping->nrpages is updated under the i_pages lock but is read locklessly
as a cheap "anything cached?" hint, e.g. in invalidate_bdev() and
mapping_needs_writeback(). KCSAN reports the race:

  BUG: KCSAN: data-race in __filemap_add_folio / invalidate_bdev

  read-write to 0xffff8881004c4178 of 8 bytes by task 3600 on cpu 0:
   __filemap_add_folio+0x6b7/0x910 mm/filemap.c:919
   filemap_add_folio+0x1cd/0x380
   page_cache_ra_unbounded+0x1a4/0x3a0
   ...
   blkdev_read_iter+0x21e/0x2d0
  read to 0xffff8881004c4178 of 8 bytes by task 3601 on cpu 1:
   invalidate_bdev+0x25/0x70 block/bdev.c:98
   ext4_fill_super+0x2ccb/0x37b0

The same counter also races with filemap_write_and_wait_range() through
mapping_needs_writeback().

The race is benign: a stale value only makes the caller do or skip a
harmless invalidate/flush pass. Annotate the readers with READ_ONCE() and
the writers in filemap with WRITE_ONCE().

Reported-by: syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e0624b5bf72b99131402
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
 block/bdev.c | 2 +-
 mm/filemap.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..d97071160e86 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -95,7 +95,7 @@ void invalidate_bdev(struct block_device *bdev)
 {
 	struct address_space *mapping = bdev->bd_mapping;
 
-	if (mapping->nrpages) {
+	if (READ_ONCE(mapping->nrpages)) {
 		invalidate_bh_lrus();
 		lru_add_drain_all();	/* make sure all lru add caches are flushed */
 		invalidate_mapping_pages(mapping, 0, -1);
diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..007fe10b2e1d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -144,7 +144,7 @@ static void page_cache_delete(struct address_space *mapping,
 
 	folio->mapping = NULL;
 	/* Leave folio->index set: truncation lookup relies upon it */
-	mapping->nrpages -= nr;
+	WRITE_ONCE(mapping->nrpages, mapping->nrpages - nr);
 }
 
 static void filemap_unaccount_folio(struct address_space *mapping,
@@ -314,7 +314,7 @@ static void page_cache_delete_batch(struct address_space *mapping,
 		xas_store(&xas, NULL);
 		total_pages += folio_nr_pages(folio);
 	}
-	mapping->nrpages -= total_pages;
+	WRITE_ONCE(mapping->nrpages, mapping->nrpages - total_pages);
 }
 
 void delete_from_page_cache_batch(struct address_space *mapping,
@@ -631,7 +631,7 @@ EXPORT_SYMBOL(filemap_fdatawait_keep_errors);
 /* Returns true if writeback might be needed or already in progress. */
 static bool mapping_needs_writeback(struct address_space *mapping)
 {
-	return mapping->nrpages;
+	return READ_ONCE(mapping->nrpages);
 }
 
 bool filemap_range_has_writeback(struct address_space *mapping,
@@ -916,7 +916,7 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 		if (xas_error(&xas))
 			goto unlock;
 
-		mapping->nrpages += nr;
+		WRITE_ONCE(mapping->nrpages, mapping->nrpages + nr);
 
 		/* hugetlb pages do not participate in page cache accounting */
 		if (!huge) {
-- 
2.43.0


