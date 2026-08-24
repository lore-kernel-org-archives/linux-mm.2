Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F52C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 783096B009B; Mon, 24 Aug 2026 10:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734086B009D; Mon, 24 Aug 2026 10:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649306B009F; Mon, 24 Aug 2026 10:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 439C16B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:20:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D61F1C0231
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:20:57 +0000 (UTC)
X-FDA: 85136374554.07.858321F
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 86EAA40008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:20:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UmVltek0;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787581255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRoTlYAeNn0iQ+Akcq71dtDJ5mRi19RmdUI1yCGlg3o=;
	b=r78WDP5xGFL7JQ4iRKJDUtR54GOGGHznhCQlAWooAtVtkbLIfR6Y/RnqML/zKVMNwsbNtu
	iP4hM6E1N4Ia1/Fi56jpCHCojPcAdfvfos/TaFPLFjo1F3Tht0bv1K7uX8r+iCuU0rJkoA
	4P51nqHgCzbMveN4pbcxpT3ULsE0qbk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UmVltek0;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787581255;
	b=INMAkIOGunlw559syGp74HZxTwf4sNn7VFKk2DA5oZJt40YKxjniWBhEHFomnGP/IjwGP7
	VHtgDCz7lyJCYnuKYI+k1EblsrK7hB915QzU3MtGcs50OnWPccFa29eFPhswJk6eXdNoSP
	FqUWWRne++qz6/od2C/PoK8s5lylYtE=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-81ea0b7d137so30381137b3.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787581254; x=1788186054; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YRoTlYAeNn0iQ+Akcq71dtDJ5mRi19RmdUI1yCGlg3o=;
        b=UmVltek0ns9DH53LH7MuQ9/UJLWLGZ4EYI0d5oM9bpiV9VfhJqYDeyw1MPMsm8Yixj
         HGg6f/jm4SJttZ7siQh/D5jNFYO/BV1PNbYFLbBJFg8o1tDzBHdeupF2JZLCRg3ikhlv
         oGgqcCP3XtwA9UiWkre6ri4UrIPBhi2e11S3Pyw4zB7bJSuqgygTbS+uBotyoP26TVPx
         RswZ3qRnKU34XMFR1jBLOEMz6lD+ROSss/cmR8LFzhPoZfVr4DQsOpziLtIYaF87dFlU
         FKu3YffRbS2ePSrlFKJqpn2ILe6pfywxyzAfkD2H3TLEBPYKRXmmvvX88H9UvcC04dOV
         d0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581254; x=1788186054;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YRoTlYAeNn0iQ+Akcq71dtDJ5mRi19RmdUI1yCGlg3o=;
        b=e1cySFCAkPjVc9xEEj39AKhzdAJQYMx71A2X1eVwGWeGTVozPklOyA86EpAKqlClLN
         YOjTRAiwcIjzKV9N5CFFc3lppmz/SaWJeJWiZiC8hfvtwsuuSgSXGZ8YBRSXCHtf9eO3
         QUm/AQWQGkC7w2W3ckguGnxPRkgPt1cwbQQKokfoYY61Db0XO7QAkOIm93NpM8xpJ4nc
         XYTlFpsTE3HdtfcHfzHoHUr911G8hSQkkLc3uFV4zr1tlbtIteq6OS0PCiDGmwOxfWuZ
         y9lT9uQvTEunSgB9nZjiM4Nq/tUc3zF2xDeiaMLoxiwmq+EseUZUB1r9mH51sGpgSjZ7
         toGQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpmfl8qZttfrraP8IHJX63n1y7ewklBLsRM0FUtbKxyuSRvVX/ZO6j4+4mCF5JilyC+vYxAieEzxQ==@kvack.org
X-Gm-Message-State: AFuF++m6uKQ6VOUDZdV3jxnytfsWFBI282j5kfknIORmb8ATu7/qflrU
	KFQmkbU0c8H94ktpjq3F1yW0a7b5kWv3oRu556wXdT2Hmvdc0EJuEe91tNsJaiwwHA==
X-Gm-Gg: AR+sD11xKZPmpzqMiOLyat/7GCEiWD1X4poE3Evv/UFbEBqBR2cYsPlVMMmniFZlfY6
	dj02qbk8P1/9xMOcFdB5fHe4+kU5Ts8jPgTXy0r/3QHxfnwmn37oqGHy2KjyZOrdZTocjGSW5iZ
	Nc9ddo5CcjBhD6CVso9Hd/Dwb4EBl1kzmTJZFvem4/dbFx8saaw1voyLMwGsollVspCwJuM0ZRY
	4TM+zU59awSgiTJqViBA/1IcZFBCECSkNfZKKu1yyC3rcF5xggCXvdr9qbgGIld6+dPKF96+q7I
	wz0SQcf6PIP6Hkb+bna4qzPwVLlztS5D/fYp42jQZt4Y4YsmbMY0oujqKPRlw3C/XKbLMRXau5H
	QGk1g+T1EioXgcnHfBbeoSq8HsrJvis6osCZCCgxumYCx15PBdRWCCA1a5DIQTWQ0gm64aunlbR
	b17VOYMuc2QCsVGGEiOwwwLNbcCVv80UAaSvOLCSIiX5bZBva+IYR+VEWzjtwHxIoz2Af3kE6qH
	JSmcLKXhb8WSJcTFxIhSEJZNggfmE0uoE/fAHphUatACuK2
X-Received: by 2002:a05:690c:e217:10b0:81e:a471:e8b2 with SMTP id 00721157ae682-84c95f4df1amr53178007b3.2.1787581253476;
        Mon, 24 Aug 2026 07:20:53 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cac3f525fsm33909927b3.44.2026.08.24.07.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:20:49 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:20:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 12/25] mm/fbatch: remove percpu_pvec_drained and
 folios_put()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <3599e5ac-b74f-87ad-ab65-78d24c148fd1@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 86EAA40008
X-Stat-Signature: syxuksy4ye3jezt614m5xrfn4mxmujwj
X-Rspam-User: 
X-HE-Tag: 1787581255-174793
X-HE-Meta: U2FsdGVkX1/ApQ2XjKR+ZEqGYGdMhrhOXOFAyTzZDzdbfRNVN+kqjDE5avV3mG7EvUjpRUFc1b/098hDhbLQvzqbCmScp5AC+curOE0Kn0MIs1LVLn4ybiwRRcdPljV4vl6zzqjLrV+VH9YF2zKDVVZ4aNmolyVnH1hUpu/4F8lsPc7n8fzEdXT0eBOGDhwyiHoOICGCeu72c17tFD7D4uOZTRpCX67deM6us2H10Fm2/hECNqHfQVqHClR1uwIPFnvWI29tPaH5BsLZ8aJ0l2IbcZII7D2vYSxWPYRZlros7uLBwDljc7GOFvrWkya19zj3HFKLQCJk3rKpBa9edsUXldmK1H/H44aW9/UamMrQhvJ8rW7aocW9xpQwsq9TvSN2XlUWonK/vpmV6KdXSPSJIJE22Yst426RaH2gI1/+dqMfM5QALvtdWV1u7XDqQBgaenpwb6R7XIBuZvBN3V83LA0tzCyqPeLe4chfBmqgRX7cMGlu7dCoRwhJURfa7KNf4cGgf32ksTTBUsCrGhE3r0ry5GpYyVLIJF0V7HqmUktWaAyXYuLIGfplaVUKFb0iXWckGJqd3zBewlsuUng5Csp9RYhEfH7WI6htLdXieNLd84VxRDhxhX2NeyfDtughFr6tMmsJeYEfM5mDF8HjbP86c1JH4Nx59VPiVBuX6FVQox316hkB94vrBfy4wZNLeI00UzNekvJOnY66FO7G/nY2xU63xvWS9sTRUXhbf0Hfeyl2/AhqDmD9O4E7AW1J1ewtHv49cZzPMk/GkT0cBCwRiiZWQXFwXxB2AGur9E5K2eR+6cFyN46ntREVeQd41zW9oNNja73CMiXJfZPw+bHQ8fbgpWcIEWJRNQaRjoE/uUYf8bfIskiaKTM8Dl+dPbpZIEMZMJom2dAZX4bk3BjOlT4KbNiReiby+LE9HPzgbyTjscnU57XsgizC6D/p15VeaQAvz2e42zy
 kIm5gtib
 Hzn/QW81kBkw7Sf2+B9wuRkyNoUEFsW+/RJyWfZWkB58LEJd1yuQFDlKGGGTnS4Wixim+IpJLCVglNcQ7+qghJZ30St7C7R7WZD56XuFB4fwVElHKyjcILxxXF3ZgiTMzI4hsJOiUqXb8twPSchJNp9b9w4eE1GdyIoOXibAzT7NBRQ9lAvhNyKubFkazmsDypsyb81uI9YIUFS3plAzgJuGXj65g0cHfOxsffrSvlPZzRZ12hb5WVQRXR9abd21v6z0d7dDsmTFghWmm9fcL8KInIOEpNyESLTQ0eX7++KxaRn0SpYpOOtZri90gce7xeH3jkgE0mKjI1J/rIDZYU3JxKn48gQwniTqmx8OxrCqEimWl8wuWpOEoa+cwUzdSDT5QhnCVvbzOne8oyiUz42gCsZ3KKeuPHZ4YM2FJPNwTzrhgLn8x74nEPuAS7XdgzxVkM0Rpxtai2KDYC96LDJ07r1sCtQzt/Dha
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the percpu_pvec_drained field from folio_batch, and its only use
in __folio_batch_release(): remove that now pointless lru_add_drain().

Which leaves __folio_batch_release() as an exported name for folios_put()
which is itself just a wrapper for folios_put_refs(): mm/mlock.c and
mm/folio.c don't need such a wrapper, just say folios_put_refs(,NULL).

Or should folios_put() be the export? But __folio_batch_release() is what
drivers/gpu and net/sunrpc are using: don't change them in this series.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/folio_batch.h |  2 --
 include/linux/mm.h          | 18 ------------------
 mm/folio.c                  | 17 +++--------------
 mm/mlock.c                  |  2 +-
 4 files changed, 4 insertions(+), 35 deletions(-)

diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
index e1cc8ae023f1..a3337f70e109 100644
--- a/include/linux/folio_batch.h
+++ b/include/linux/folio_batch.h
@@ -27,7 +27,6 @@ struct folio;
 struct folio_batch {
 	unsigned char nr;
 	unsigned char i;
-	bool percpu_pvec_drained;
 	struct folio *folios[FOLIO_BATCH_SIZE];
 };
 
@@ -41,7 +40,6 @@ static inline void folio_batch_init(struct folio_batch *fbatch)
 {
 	fbatch->nr = 0;
 	fbatch->i = 0;
-	fbatch->percpu_pvec_drained = false;
 }
 
 static inline void folio_batch_reinit(struct folio_batch *fbatch)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 87feaa5a2b78..a426f7351787 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2201,24 +2201,6 @@ typedef union {
 
 void release_pages(release_pages_arg, int nr);
 
-/**
- * folios_put - Decrement the reference count on an array of folios.
- * @folios: The folios.
- *
- * Like folio_put(), but for a batch of folios.  This is more efficient
- * than writing the loop yourself as it will optimise the locks which need
- * to be taken if the folios are freed.  The folios batch is returned
- * empty and ready to be reused for another batch; there is no need to
- * reinitialise it.
- *
- * Context: May be called in process or interrupt context, but not in NMI
- * context.  May be called while holding a spinlock.
- */
-static inline void folios_put(struct folio_batch *folios)
-{
-	folios_put_refs(folios, NULL);
-}
-
 static inline void put_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
diff --git a/mm/folio.c b/mm/folio.c
index fa4cf9d7d51b..782b8245d213 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -159,7 +159,7 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
-	folios_put(fbatch);
+	folios_put_refs(fbatch, NULL);
 }
 
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
@@ -1062,22 +1062,11 @@ void release_pages(release_pages_arg arg, int nr)
 EXPORT_SYMBOL(release_pages);
 
 /*
- * The folios which we're about to release may be in the deferred lru-addition
- * queues.  That would prevent them from really being freed right now.  That's
- * OK from a correctness point of view but is inefficient - those folios may be
- * cache-warm and we want to give them back to the page allocator ASAP.
- *
- * So __folio_batch_release() will drain those queues here.
- * folio_batch_move_lru() calls folios_put() directly to avoid
- * mutual recursion.
+ * This used to optimize with a drain before putting: no longer helpful.
  */
 void __folio_batch_release(struct folio_batch *fbatch)
 {
-	if (!fbatch->percpu_pvec_drained) {
-		lru_add_drain();
-		fbatch->percpu_pvec_drained = true;
-	}
-	folios_put(fbatch);
+	folios_put_refs(fbatch, NULL);
 }
 EXPORT_SYMBOL(__folio_batch_release);
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 1050010bbe0b..97134eff6b56 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -191,7 +191,7 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 
 	if (lruvec)
 		lruvec_unlock_irq(lruvec);
-	folios_put(fbatch);
+	folios_put_refs(fbatch, NULL);
 }
 
 void mlock_drain_local(void)
-- 
2.51.0


