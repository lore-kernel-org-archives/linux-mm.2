Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA80BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7D96B008C; Tue,  8 Sep 2026 11:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A83E6B0092; Tue,  8 Sep 2026 11:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897C26B0093; Tue,  8 Sep 2026 11:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 564826B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:47:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D40EC140726
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:47:39 +0000 (UTC)
X-FDA: 85191025038.28.C86ECF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 060361C0009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:47:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0jGeSCb;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788882458;
	b=AfNU1pThGwY4ph0QtwzbUDX8UfyZCjTGubpmHqaqmRhJ44ZQoKsHZsD75IylgHo1dg/R/z
	rTgjuE61bxQPxpcVPaG4qciupXO7/KDZ//BMI/NEaHSa8HLamezZBQ353Xt71DysrsH7M/
	arG5KpoK6Gu5e1EdPxNC8oBUvy5WkPM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c0jGeSCb;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788882458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lwtouv1vIsPs6zrihx9rtxLSNo9w1Vw5QEheH4pUII4=;
	b=0LtNYVfF4SIWZZu+mm7m82bAJEbC+4D4TntJLrTDkGEuenQUH73tnKdY8jaDKjWp/dMKo/
	BaO9wvoFkCXDLtBJDUUMEDxic7mV9gfTKUZEMoVnEKSGMfriK0o6zesCBjYD2Bss/p2SFb
	6Xkuj8r4xRHZj5hp+xG0ohCgFTxIVmA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84DA3601F7;
	Tue,  8 Sep 2026 15:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C244E1F00A3A;
	Tue,  8 Sep 2026 15:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788882457;
	bh=Lwtouv1vIsPs6zrihx9rtxLSNo9w1Vw5QEheH4pUII4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c0jGeSCbxBKFMslsHx1VKdqJ+PlArCxziNPylyn0RCAGmq7Vayan+VGB5OFs366Pu
	 +CLrPtenujgEZU26iBMkO0/LOQXTEjap0BrmsGGa3iwe/5wL/9PGZ9XqKY/8gIYsit
	 OqIZDJpJAP19/bzdtpv5wpruX7LITG2ZX3QKrRc9tBtedlw9RCokpzB3TCos7KQq4V
	 iaYQD/M5SfWtptQ5d/XJGD1/rv4XhrQ6ptOaHC7Mha30+7u8uqter7/flcHiPv18o6
	 cIwi8KNLy0SBxfE1mGwxuEiVGBsnYaAUwCntUbZJy/gjdQUelDwLFsCcmENrf5L7P5
	 7z6f9usqbYvvA==
Message-ID: <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
Date: Tue, 8 Sep 2026 17:47:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 060361C0009
X-Rspam-User: 
X-Stat-Signature: b5rjmg6bmshwzrqw5f9pk7ewkdyrmphu
X-HE-Tag: 1788882457-339371
X-HE-Meta: U2FsdGVkX19yO03xwK5cYWrDtspe3ZcwRXczYhUe0BaX2soZTJrMcCjZ64e0LojUswl4uH/KcMt/dYoOkQ5AHNSKZ4rgqj1Cbb7gNo8mvu7f6RA0N7czzBVRt3ngZo7EKDixFJk0fgTSz5369AcEKeDGuSUwsdCNN4kNje29CGRioi89w5ZJomkK+NfuuOOX4UV4ru14BxaWWHqISdWM1Tn5yzPwf9oyTdOMg/+c/pTzFn2qvDzM7XUwCvSNX7LSTCrmXlFTHH118OJ3SHWrbuR0j6xYGF1L1xsd1DBRzVNohIS9c6wGDDVjmIwMHBDuwAlrISwhOE7zvNB1P+0XQMgqp3N3M7vi5ar62OsrNca3TCPAdC6K4A/k4iom4D/Kz1IQca1ry2gh6QBbKkZFtFxPOo6TNCH5/z8lEhds9IRP0eBwHrtG7l4KyasZ5U5k0qp2flZNUCiO4ZsIQbZkMulDZyr1TZbM9ukgM551aR5aXSFCQRBlgkEcfvqeyo9Rn+vcMkXrGEEbn87ulgxPJxma6iTLFBj8hqVaJqkj4nLW35suA2HgNTkOuW+y1Q23FlD2VpJ+j8uSwcWR1x7JPEwOG4bfzpKMGznnlcUSYWPpF0uiQwiYVw730RyTL98JxV0yirW7XkCeU2pUjxA46e3cVaon6osw87g0LOrJciYRiWqKTh06cvn4z25vyf7NEOqDlZBbCr5f7ELyyFPICRw9YWNbuzKQjDjcBUGitM0k/QhK4iz3Mv3rD8CCXMt+2vVHT2ozFd/R+83WcTi/b/cmWDxZKnjLrPM2A5v4BOafFNh43Rb0zKI/gX5HDSavMY4xmVjwmdk81yeomZnAYBvZmlNffbg8+YHFehZYwNYtXvLoN/8MpHK1OaKp9O4QYs6J3bf+4KRkqKiGr+M8bSDSiaCWKW2pDWu2U/Lo4pV8WwgtkF9DzXoD0oHbQ+I6ZForq9q9/hY+q0/W6+y
 BmjpToOc
 OH9tQtN8ezOzfZ03qoI1ZLZx4HNhjRP4jkvpOwmctp1Pxm44R3GITi0Yhhpm6aLzSaA7HJqEXyGyZERcL8qwTVlo5XM52oR3vZzxZ9dLtfObFasxY6GkR5WVBFetJas4xoLQ/xXEAXxRolKol2G0iVHUd42QyWBqpexBbkVNKxW34DEgtdovXLPFVKmjRwz6RHlRs1/0VJj80+KrbSiTm3xEz5u8wLrdjqJQ4Ux29VDDQQ0Qzj1QxNuCJZVUhc+aIkXUeuC3JDiL+N865/IJl/RD6aiPhzDWkuBMXx6JruoxkHnqazL2mNR+c2WurOMqopIoMYDupd5uqIwMCEUMlwgTn3MXAuENfvq7QLdFxbaeA2wLKDSIysXQB1xL6NjcZARpk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
> page->private != NULL is equivalent to checking PG_private. Change
> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
> but it can cause confusion when PG_private is removed and
> page->private != NULL is used instead. Change it to initialize
> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
> semantics.
> 
> It prepares for a future commit that removes PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Chao Yu <chao@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  fs/f2fs/f2fs.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 9940a6cecf1a2..2f7ab5888b078 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
>  }									\
>  static inline bool page_private_##name(struct page *page) \
>  { \
> -	return PagePrivate(page) && \
> +	return page_private(page) && \
>  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
>  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>  }
> @@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>  }									\
>  static inline void set_page_private_##name(struct page *page) \
>  { \
> -	if (!PagePrivate(page)) \
> -		attach_page_private(page, (void *)0); \
> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
> +	if (!page_private(page)) \
> +		attach_page_private(page, \
> +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
>  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>  }

Very weird interface. Why do we even need the page-based interface still?

$ git grep -E "(set|clear)_page_private"
compress.c:             clear_page_private_gcing(cc->rpages[i]);
compress.c:                     set_page_private_gcing(cc->rpages[i]);
compress.c:             clear_page_private_gcing(cic->rpages[i]);
f2fs.h:static inline void set_page_private_##name(struct page *page) \
f2fs.h:static inline void clear_page_private_##name(struct page *page) \

Seeing code like:

clear_page_private_gcing(cc->rpages[i]);
if (folio_test_writeback(page_folio(cc->rpages[i])))
	end_page_writeback(cc->rpages[i]);

Makes me wonder whether we can just use the folio helper instead?

In f2fs_iget(), we enable large folios only when !f2fs_compressed_file(inode).

So naive me would assume that we can just get rid of the
set_page_private_/clear_page_private_ stuff entirely.

IOW something like:


From efcde918178604de11d16c6dc5485542ab4dcdaf Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 8 Sep 2026 17:46:06 +0200
Subject: [PATCH] tmp

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/f2fs/compress.c | 29 ++++++++++++++++++-----------
 fs/f2fs/f2fs.h     | 13 -------------
 2 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index ce88092d9ce26..0e9cc0fa297a4 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1064,13 +1064,15 @@ static void cancel_cluster_writeback(struct compress_ctx *cc,
 
 	/* Cancel writeback and stay locked. */
 	for (i = 0; i < cc->cluster_size; i++) {
+		struct folio *folio = page_folio(cc->rpages[i]);
+
 		if (i < submitted) {
 			inode_inc_dirty_pages(cc->inode);
-			lock_page(cc->rpages[i]);
+			folio_lock(folio);
 		}
-		clear_page_private_gcing(cc->rpages[i]);
-		if (folio_test_writeback(page_folio(cc->rpages[i])))
-			end_page_writeback(cc->rpages[i]);
+		folio_clear_f2fs_gcing(folio);
+		if (folio_test_writeback(folio))
+			folio_end_writeback(folio);
 	}
 }
 
@@ -1078,11 +1080,15 @@ static void set_cluster_dirty(struct compress_ctx *cc)
 {
 	int i;
 
-	for (i = 0; i < cc->cluster_size; i++)
-		if (cc->rpages[i]) {
-			set_page_dirty(cc->rpages[i]);
-			set_page_private_gcing(cc->rpages[i]);
-		}
+	for (i = 0; i < cc->cluster_size; i++) {
+		struct folio *folio;
+
+		if (!cc->rpages[i])
+			continue;
+		folio = page_folio(cc->rpages[i]);
+		folio_mark_dirty(folio);
+		folio_set_f2fs_gcing(folio);
+	}
 }
 
 static int prepare_compress_overwrite(struct compress_ctx *cc,
@@ -1477,8 +1483,9 @@ void f2fs_compress_write_end_io(struct bio *bio, struct folio *folio)
 
 	for (i = 0; i < cic->nr_rpages; i++) {
 		WARN_ON(!cic->rpages[i]);
-		clear_page_private_gcing(cic->rpages[i]);
-		end_page_writeback(cic->rpages[i]);
+		folio = page_folio(cic->rpages[i]);
+		folio_clear_f2fs_gcing(folio);
+		folio_end_writeback(folio);
 	}
 
 	page_array_free(sbi, cic->rpages, cic->nr_rpages);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9940a6cecf1a2..0cfba8742d4b4 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2707,13 +2707,6 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
 		v |= (unsigned long)folio->private;			\
 		folio->private = (void *)v;				\
 	}								\
-}									\
-static inline void set_page_private_##name(struct page *page) \
-{ \
-	if (!PagePrivate(page)) \
-		attach_page_private(page, (void *)0); \
-	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
-	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 
 #define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
@@ -2726,12 +2719,6 @@ static inline void folio_clear_f2fs_##name(struct folio *folio)		\
 		folio_detach_private(folio);				\
 	else								\
 		folio->private = (void *)v;				\
-}									\
-static inline void clear_page_private_##name(struct page *page) \
-{ \
-	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
-	if (page_private(page) == BIT(PAGE_PRIVATE_NOT_POINTER)) \
-		detach_page_private(page); \
 }
 
 PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
-- 
2.43.0


-- 
Cheers,

David

