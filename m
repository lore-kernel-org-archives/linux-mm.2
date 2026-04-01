Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B45F010FCAC0
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA4C6B0089; Wed,  1 Apr 2026 15:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D516B008A; Wed,  1 Apr 2026 15:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95686B008C; Wed,  1 Apr 2026 15:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE8A16B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:11:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5BA61601C8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:11:22 +0000 (UTC)
X-FDA: 84610930404.04.D9475CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CFADA1A0007
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:11:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MsFz6DVr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775070680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxwAbCC//tcSSNUWR/EHVwnrALlxFalCHJPWsw7xqmo=;
	b=r7DjG/1SFYCN7rntOmyKP+Fc+O7uWbf2yxmcXUaMGqqRsLVjoGGW7qABfKRL+MHpTJ9qgA
	eCSGUQbrjmI+QRFED+O9UPJDPnPjgsD/n7hbE32eWjVgd6QJ8I6V9p1Qx7Hc3Nfs9wXpYl
	d1CjCtnfySoIj2sn0euanlEMVKPnttA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775070680; a=rsa-sha256;
	cv=none;
	b=OPxOLpA/bfMijL1iY/BWB+xKcl+UFjqYsqOfc+b4i6MS+lhuJ2PTRDTyPNmD0dMsJHs2Qn
	qRr0byF6mfcKKtgQp7MKsb/pDbrsGRYHV6gqM58cl+OwKIS1Nhem0DSLLcT0WfRPmoml8N
	PNb6Gd0EFo5SIwDVLzt13J2qWDWHpuw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MsFz6DVr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4806061842;
	Wed,  1 Apr 2026 19:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18ED2C2BCB2;
	Wed,  1 Apr 2026 19:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775070680;
	bh=bOe16hkUqbqlZCJU8w30Z5j55Ar6Gej61o9MPI+OrvA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=MsFz6DVr/Ad+viBQxt7EKPRr3hWIB+yuzGZEntIDplLs3LBGri8Xl8j1CJU4brkSm
	 FiS3M3355DIrRglMNdt2+q33GkdPVfLqMY8afHJ9EhxSCLPa4JAKHcrQQeQJvv1SWr
	 e0VkGtKq61zGX/umvM1kOgzoPH+iCzFOSrafUnkSIoRcYCGAoEaL+IBSeA/OjD8ii7
	 8HJRTQbOc+nGQn2kxq/uuKBJVnR9n1R8t1dtx586spadqAHtsgZ2u7KrJnFoIarVin
	 323HmyWIQY93UihThmi3VXjSvCaadaNOe/80lj4qR7kj9os0ScD1e4UXSHHkLOTFnk
	 wRET25BGoJgMw==
From: Jeff Layton <jlayton@kernel.org>
Date: Wed, 01 Apr 2026 15:10:58 -0400
Subject: [PATCH 1/4] mm: fix IOCB_DONTCACHE write performance with
 rate-limited writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260401-dontcache-v1-1-1f5746fab47a@kernel.org>
References: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
In-Reply-To: <20260401-dontcache-v1-0-1f5746fab47a@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <msnitzer@kernel.org>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4439; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=bOe16hkUqbqlZCJU8w30Z5j55Ar6Gej61o9MPI+OrvA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpzW3TYYBGxB56wbiSNOObN6S4exPYnQ+w1A6S3
 USLKZ4d5smJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCac1t0wAKCRAADmhBGVaC
 FSj/EADCTOcmKwq7ER+CHpVYKKkKxZKs6LtlI+SGxgJR7bR2Ytq1OHRCgdxX/mFBolJ3jWmFGCo
 UN5zb8G7MsLL7+RA3wZch+lVZ+HtrT8VK33trWUwWiZ3/Y0pT8/szAL6kjkKF/YyEUxjn0ps2IM
 3bJd1f6fPRKwsnk0X7x/rhvRocAol7QnLsRgZBMeQ7+j+ZF9RpYhKf1J8bN4sdEkYdetphsVqaV
 5nNKaCKmGRfA7q7sl9RgeBLHr68nZpA0aFhZoKO10UvVqVp+TgBVcvLTHOiI9qx3pxU3ZH4lhtm
 QHAbpLt2FFphXNir6sLBoR5sJW1u/2ScCVxj5f+AJHxA0ha0jHhQMkeYgipgPITocCDghBr9N1g
 Xlilb2Vwf6YqvVKZiQE4+B2U7XDKGz6XcGTPntUzVCWKFBrzzrtr0gBXKsn7eCagRYhucoo4F1/
 UkjNW6of6HjuRG0XcSVvEpQBfD/d6rcV9zm7K7IUUaS/QNLrQWqR6yT+1EWoBTHj4NxfPorpvp0
 dH8Z/31MrgFT1mPQJxvuqmwQxDtZrHe6zz50HF8RVlC1SFd6eAQKnUHcUNW+RLq+kHlydHjEdIR
 WrvYJtr23sc2IK3WkYXB1lRgpoSya7nuyslzkCuySX1bpQstObmlZ6YrYycq0UkSvXazf0nJRz7
 UhUIwXTGWPBRjoA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: CFADA1A0007
X-Stat-Signature: bfbbrpcioacc8jssm6xpo9pfq1odndfa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775070680-588726
X-HE-Meta: U2FsdGVkX193WYq4pCktTshsCuPQIPtntW336lu9LET1QigR3zY/em+ZJJJBxThQoM1vbDlhR9408tBPdA96oelclSLHt8BVZKxIHne8mu39ne1HUahUHHrzZoM4MGjyk7n/9Oe6Q1Uw4/eUxe9naFm4UEspyEWu33W3apJ04RG8Au61fZBbCsWExfpN5zsEGEIhWYEV2E0hAWHidCNVtzAvzRfpUZybk2zeQ1ogJmdZmynMdHeTgEbRvnGlPnOUKRaZKJfh/+Fg6yV4bWwn8wmV3bd0q+DUh8KgaWPdUX0Tml6tNeYpZ14z6ux7BvEF94s+24b6R0SP6nJJc1NqNl0rrAmISkn7CfI2M1XhPiy2zS+7ptswUjsTJWw43DVo0/k6W7cpsHPSt7TiIhKutLsIIfNwnGQNs0bd6BS1M4uqgvkJG3V9bib34rA74u9OSgw8NGAS4147dzVeHnQcO7GI0MAggbcVC5Y7OJXpHxoCmQjiBe/HujcBIN4qY60RGtbiZVBijTEPCzrgpc60zf2FZSD0tXbaVzERRBAGN8nkwy2iMnC56n0PPlzTSMkAiCKaj0yoFaTaiCZJUjZk7GDJBXDv7ChEBMlwmn6Kwe+j+JW+t3MgWnHt0AR0R+nNN5LtEHrMHAFZC8KV2ZtRAnaAbT3p32aVxnnbMFEEmuSbjssEUHNS/TL0EO2+BqWMiL9+1zl8yZrG60kXyQ7M8Vxb5Y1HuNY9ks8q1RcBAUN+IpD0Ytc+L+JDO/9QadNm48Loc66bdtJ/vbA66VlbUDgasoC11mFpTFS3L67/OIvqy0L+/WZ6W7h9KsMI4KALyLa29W4PGib0XYiuJW2lOaUrI1umOrxLctvJ5EwXZnHEndv8UdHVjC0IAmUuVE835ZgO5ZRo/hCv1CNqLcb9/Fi6IbOI2LckPnq5CVBC+qTwCZQNC1V7dL4e8/zQ8N07AJrF/g4DRb5zQVbv5yP
 kNcQ98Rn
 QgECVHEDDEcgnPYizldSe9nxp87K+orthk4kzAQK+7IcRSyrY0ET0nDmwdvcas9q2M4LeFyyk0IbJbLzt7OhF4MfGGtwuOEVh2afg03JJyzR938rrp8OZRGAUWjr3had7dl0Lm7A0ThhPwXnUY3zrESYuMPsUwctRmy024zKx6cQt/tRZ/WRvpbQHpOtHwzupHW4seRidCa76v2f1UKCXVcSPXGKmq58xX+eLbMREyo7Mn8GIw33Xq5JxLANI+8+qlOqCOQNUerXfMnZPsp1pbtwxzusOABUpYmr61ZaeBt5Bkd6ISGTa3bvJsRY2fqtsPRiZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

IOCB_DONTCACHE calls filemap_flush_range() with nr_to_write=LONG_MAX
on every write, which flushes all dirty pages in the written range.
Under concurrent writers this creates severe serialization on the
writeback submission path, causing throughput to collapse to ~47% of
buffered I/O with multi-second tail latency.  Even single-client
sequential writes suffer: on a 512GB file with 256GB RAM, the
aggressive flushing triggers dirty throttling that limits throughput
to 575 MB/s vs 1442 MB/s with rate-limited writeback.

Replace the filemap_flush_range() call in generic_write_sync() with a
new filemap_dontcache_writeback_range() that uses two rate-limiting
mechanisms:

  1. Skip-if-busy: check mapping_tagged(PAGECACHE_TAG_WRITEBACK)
     before flushing.  If writeback is already in progress on the
     mapping, skip the flush entirely.  This eliminates writeback
     submission contention between concurrent writers.

  2. Proportional cap: when flushing does occur, cap nr_to_write to
     the number of pages just written.  This prevents any single
     write from triggering a large flush that would starve concurrent
     readers.

Both mechanisms are necessary: skip-if-busy alone causes I/O bursts
when the tag clears (reader p99.9 spikes 83x); proportional cap alone
still serializes on xarray locks regardless of submission size.

Pages touched under IOCB_DONTCACHE continue to be marked for eviction
(dropbehind), so page cache usage remains bounded.  Ranges skipped by
the busy check are eventually flushed by background writeback or by
the next writer to find the tag clear.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/fs.h |  7 +++++--
 mm/filemap.c       | 29 +++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b3dd145b25ec12b00ac1df17a952d9116b88047..53e9cca1b50a946a1276c49902294c3ae0ab3500 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2610,6 +2610,8 @@ extern int __must_check file_write_and_wait_range(struct file *file,
 						loff_t start, loff_t end);
 int filemap_flush_range(struct address_space *mapping, loff_t start,
 		loff_t end);
+int filemap_dontcache_writeback_range(struct address_space *mapping,
+		loff_t start, loff_t end, ssize_t nr_written);
 
 static inline int file_write_and_wait(struct file *file)
 {
@@ -2645,8 +2647,9 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
 	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
 		struct address_space *mapping = iocb->ki_filp->f_mapping;
 
-		filemap_flush_range(mapping, iocb->ki_pos - count,
-				iocb->ki_pos - 1);
+		filemap_dontcache_writeback_range(mapping,
+				iocb->ki_pos - count,
+				iocb->ki_pos - 1, count);
 	}
 
 	return count;
diff --git a/mm/filemap.c b/mm/filemap.c
index 406cef06b684a84a1e0c27d8267e95f32282ffdc..af2024b736bef74571cc22ab7e3cde2c8e872efe 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -437,6 +437,35 @@ int filemap_flush_range(struct address_space *mapping, loff_t start,
 }
 EXPORT_SYMBOL_GPL(filemap_flush_range);
 
+/**
+ * filemap_dontcache_writeback_range - rate-limited writeback for dontcache I/O
+ * @mapping:	target address_space
+ * @start:	byte offset to start writeback
+ * @end:	last byte offset (inclusive) for writeback
+ * @nr_written:	number of bytes just written by the caller
+ *
+ * Rate-limited writeback for IOCB_DONTCACHE writes.  Skips the flush
+ * entirely if writeback is already in progress on the mapping (skip-if-busy),
+ * and when flushing, caps nr_to_write to the number of pages just written
+ * (proportional cap).  Together these avoid writeback contention between
+ * concurrent writers and prevent I/O bursts that starve readers.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+int filemap_dontcache_writeback_range(struct address_space *mapping,
+		loff_t start, loff_t end, ssize_t nr_written)
+{
+	long nr;
+
+	if (mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
+		return 0;
+
+	nr = (nr_written + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	return filemap_writeback(mapping, start, end, WB_SYNC_NONE, &nr,
+			WB_REASON_BACKGROUND);
+}
+EXPORT_SYMBOL_GPL(filemap_dontcache_writeback_range);
+
 /**
  * filemap_flush - mostly a non-blocking flush
  * @mapping:	target address_space

-- 
2.53.0


