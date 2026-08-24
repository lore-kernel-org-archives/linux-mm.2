Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC59C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08CF6B0096; Mon, 24 Aug 2026 10:14:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0456B00A0; Mon, 24 Aug 2026 10:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF66A6B00AE; Mon, 24 Aug 2026 10:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88B8E6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:14:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 221B3A0A2A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:14:14 +0000 (UTC)
X-FDA: 85136357628.07.C42C76A
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40ED2180002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:14:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TA+E6agt;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aw7ugmpQOmjY2/CNCHaKDY6XRRUcvMaJ3u0iOskkTBo=;
	b=osoNZkeUAZ0sFZjGnBrvBLumSvNbCRJOXVX+iDvvMJJuRSJ6WAVcAOHmXecaTur7725l9u
	+PkKV6Plta9SNbgRmvXkeJl1a4mIm2tcTbp437kokf85OGv4QLI/AgciaYyfB9+ZmJcfEi
	ytOC+EDr9FAGIyNnihmiBmA7OUIXKYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580852;
	b=XZOBhyYfdSJj607I+H7nfKiikhnn+ZdhyzJL4AjSSPnjTHGU5i3TOL4xvc65E3UZgXbwJT
	+G9eVmmm7MHOPzW3OHJ1SbNQRrCN3x0zfISWuZ+bkZRqkcmDJmK+H/EKRfIziWcQSenU/P
	wF2l+Wd1pT67DOWb6ySUc/KZucGID00=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TA+E6agt;
	spf=pass (imf16.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-836ccf53ef9so26954557b3.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787580851; x=1788185651; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Aw7ugmpQOmjY2/CNCHaKDY6XRRUcvMaJ3u0iOskkTBo=;
        b=TA+E6agtUVjmQVjULmNIqBYP7B1c9ApEA8tJkm58syekhJg69GBww6iDuyihO2+2a3
         1VLxW47cSv7SeivoWazQIEkrqJ7ayy3BU2KM/xV22ZXORiPIW+XGbYIZRSigsA6MjeKs
         g8vcGt4boNzMLMSasEQToS7ZSA+6QDmRSIeDzXRrdMSzoPeZ8MiINBePRQRMBcR5gPHg
         iyioaifWfwBI830Vl6HYN8x9JJaALY8AEIDQhbWzBB0YHN+MUUwgaPYfzVJ1uB2rCddY
         WSPuQW2dsCyNhZq8naXDLbJC0yVeVejVrqlV8Dc4te9d/YhJaYLf2gCyUSin6Xqw2fWe
         7lRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787580851; x=1788185651;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Aw7ugmpQOmjY2/CNCHaKDY6XRRUcvMaJ3u0iOskkTBo=;
        b=dWlZHrAnVNRkRCMKqyzmMfGSYOV8E/hJhXWRpygIqvbX6jzFSmZ8PBJ4qjcMTeY9wE
         IlXeu1tg3YMgsh5r5wMTZAugzp/53Y1vhRkYWZx0ZpOaOvqA7HA+YvDjXUdVh4D52aBt
         v1pFkKYIwNHv+evXhkv9iiQ8IT5LR5PSJAMO/WcDig0Vi8O1kG504rYNbn+0+5i/TB1C
         sMUXgJAbxI5XoStlIwP4ffk3nTQcMLpf826ibJE3N/Sm23Q2JFWw5LvdVXXmuaRtxZ0Q
         v3I21gQ8c5UsQ4OSVyXBo0Kb0Twk1s/8i649gqDKaWyc5KwI1/pDiJGvydNx5h3qpQWf
         oItw==
X-Forwarded-Encrypted: i=1; AHgh+RrDSuwQFJg0cmS1RtYZFwGU5AmkqL22IqyhSA9+d4ljkYfIA8kFjwcD7EVKC9DKqpQrS7aozcN/mw==@kvack.org
X-Gm-Message-State: AFuF++lu3IQwuis+Duu06jYqzzxJSRvC6p4jZ+jNyG51sn3T1XtVqCEI
	XPMK1K9Qr9Lvk+yneUjR8XyEfGAKirQGfdICN0S5xFsRYC94ctolZUAxwrB9ipsCxg==
X-Gm-Gg: AR+sD13U6NnPKf4N8avW5VxWU4hcwU/qFiI9yg0fz/0+ktZWT5QJpvNiPzEG/2Gh2Hk
	2UCgheuiJFNspvp1FX7UnlY/59t2iQPwMcJUlWddfeT552jfhebx8TIMHbCjvDn7lxD89iZnKyc
	GrlkbFA157dzUIjrSazNSqbvaEoNYAhobWWF86ujK/zpZsCV7NspKMsnKux8L+u1+wOnbciGmGB
	FV2hJiSXT6YqRWyUd4xkpJTCVfmjxU2XGhPw/N1HsUyZV3f4O1M8l4wvEVX5NOWPNHBO5+aJlbi
	GZomFkqzC/QOv4tmitOLaU/dRQ3wAtBFuCpHKaVgJxTpCCUm/YI3cgurQ3UjfLOgb5aoGfSUO7Y
	Fp9tKMca7MXHeqiiYwYqMdB3RxhttlpE3qbLvbdPF+chYSAUqYeheE5nKWGM4C7N3Sh9OoWM6Cm
	rDhxHaDvxeMy3W9do8p0LE2jHRxbpTen+2ztomcr1l6x1ZR/NwjVFEh8xn+2uP62yvk3U5RoILZ
	J6LkuOg54sA59Ptrk/ItfA8Pp2FvbIlTHZA6bJxa7Gl8Sv6
X-Received: by 2002:a05:690c:e001:20b0:81d:bc5:4624 with SMTP id 00721157ae682-849f5df6e6amr76092477b3.25.1787580850776;
        Mon, 24 Aug 2026 07:14:10 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cac4ef4edsm34110127b3.45.2026.08.24.07.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:14:10 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:14:06 -0700 (PDT)
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
Subject: [PATCH 09/25] mm/fbatch: restore mlock+munlock batching, without
 extra ref
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <32d663fb-f192-e0e5-114e-8a92240fb0ac@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: fatxar3bdnprj7qr68pdcfguaj163yhn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40ED2180002
X-HE-Tag: 1787580852-49864
X-HE-Meta: U2FsdGVkX19Gzt3KaLalsViEKkbH1Q6tS32jOzVWFBbt0ftu3pVrtsYkSBmq3IR75wWnD5SXx0AkvvOL3jIcGxbYQWdZzHTXryGNeHkhBzo4d7pDKuuZESghpFtiIgbyC5Lf8mLOXDZfCSmK/gmAIJ/rREE5DUS/huI24uq5xWwKtHCpbrD1FILbkn0/401QxqtDOMjCQ3aC+pl/U5zTL3AY5mFQ6YsPfjYQQo3xIonuqEJhIiUSVIO8ZFAm4kNA4Fi55Wfm/cgNJlEANXzIeO2FqV75kxAulCLPEVjY3EYiULJtAI0Fu6OE8MtsWEVZ23rv0qLXwaicoHerkpVHCSH1w1B+aAVzz3uf82buCeKdSQ6lzE0c8mpiymOhkFMRypnyb7YdlsToBcRJcFRCXKGokAJQ+uHdpAhLMpU9yexdcut0Hlc2SdAL4n2gIyFU5ec0xRlt3UDJrGvRS0/jOho4OXyGhWW1L4xIsVaiTMb4dmYiYOgBg3fQsoBoLwSbQ3VYBUgmZwKOPSf8UUQfwoYbIvlpUDGre09qVMmxLDifKrwpylfBh+7EOeEIjmhkWq9gEAF8D8KCIU4T2FJuOscZrkzPlK/c4avh1X+KWhbuHu7f7VKLG8oVOykSJPkrrZTjVMUFHVYsuSe4fWhZADTJZiAfT3gTr8uwkhU+A2btD2YET0llO9EBXlpIHylOlTnT0QarmthA8JdZOwfWwmJGcVVoOF4ayJoWz8gHERu8aZ75m78gWJ4tAtFPQe3xC9GmUA8eYnuOcfnZdSp1j1Dr2cGJ44DbzO9UZXDJ8lICqorYysPliyx2m47OQePiSJMXgDyW0rqKMPSHESzgzeLIjoLkh3U+1ODlMACQxnbLBsPnkVu9HkxGeYe3TzSMZmTUeqIOOJDpRJgAR+cSySyKkK9VUl6R0Yl379udl6/tzMyR9vf4tYU6aJXZzOBS9hGCFtdKW6KgMgiKfKp
 SWFU6Lg4
 4kDA8rK9Zb4F/Y3IOSfCTKJexO4yiV1BGDfmVKZKOoEQepxsV9n1ixzJIj95B+eS6mBl/BRTQvMTHOCQNrtbTEVGXcz+NWRHIejAr/8bXW8Ob6pR2IGqaWUmycCc50quNgvc/ilwqp+olw6+JhK31eucgxqDX+H2bHpzcsUBNxMiioPMoLQ+ECenTNMU4MjOFc+te3+/oonT0bmmuJPgRGyA8MSIDttuDe8ZVIOqX1BCp5SMosZZi9kAF4q3k6W3S6VrgVQLv7JPXG4CQLQBX1mm6LtwqsRHgjhfIhJM+TnHCR6JxSTtXQdv4i/DiRjzDnNtuFMBtyXGpmp1clD5QYT/umuIBxmjH717Gj7SYVUukgBrLNCDjSt4sSazymqZIeqFbIV6LIDYjtamy0niUlpotNci0vllz4BrTIT51Oqm/WVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update mlock_folio(), munlock_folio() and their fbatch callouts and
helpers, to do folio_try_get()s at batch processing time, instead of
holding a folio reference all the while in mlock_fbatch: as in folio.c.

But more interesting is the use of mod_mlock_count(), using try_cmpxchg()
to update folio->mlock_count safely when possible (now when on lru_add
fbatch as well as when unevictable). While __mlock_folio() is as hard to
think about as before, __munlock_folio() simpler because munlock_folio()
can adjust mlock_count itself without clear_lru() or lruvec lock, and so
do the folio_test_clear_mlocked() immediately for itself (without which
unevictable_pgs_cleared was likely to appear high, when it should be 0
or low to indicate good mlock health).

__munlock_folio() is safe for use even when the unreferenced folio has
been freed and reused. It appears that __mlock_folio() could affect a
folio which has been freed and reused, but only if it is reused as an
mlocked folio, in which case its mlock_count is spuriously incremented
(but usually a spurious munlock decrement will follow).  How grave is
this? If unevictable_pgs_cleared remains low, not so bad.

I've gone back and forth on whether to move mlock_fbatch and these
functions into mm/folio.c: for now they stay here in mm/mlock.c.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/mlock.c | 147 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 61 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 53d754e82ba2..1050010bbe0b 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -58,6 +58,20 @@ EXPORT_SYMBOL(can_do_mlock);
  * indicate the unevictable state.
  */
 
+static long mod_mlock_count(struct folio *folio, long incdec)
+{
+	long mlock_count = READ_ONCE(folio->mlock_count);
+
+	while (mlock_count & MLOCK_COUNT_0) {
+		if (mlock_count + incdec < MLOCK_COUNT_0)
+			return MLOCK_COUNT_0;
+		if (try_cmpxchg(&folio->mlock_count, &mlock_count,
+				mlock_count + incdec))
+			return mlock_count + incdec;
+	}
+	return 0;
+}
+
 static struct lruvec *__mlock_folio(struct folio *folio, struct lruvec *lruvec)
 {
 	/* There is nothing more we can do while it's off LRU */
@@ -65,6 +79,7 @@ static struct lruvec *__mlock_folio(struct folio *folio, struct lruvec *lruvec)
 		return lruvec;
 
 	lruvec = folio_lruvec_relock_irq(folio, lruvec);
+	lruvec_del_folio(lruvec, folio);
 
 	if (unlikely(folio_evictable(folio))) {
 		/*
@@ -73,92 +88,82 @@ static struct lruvec *__mlock_folio(struct folio *folio, struct lruvec *lruvec)
 		 * folio be unevictable?  I'm not sure, but move it now if so.
 		 */
 		if (folio_test_unevictable(folio)) {
-			lruvec_del_folio(lruvec, folio);
 			folio_clear_unevictable(folio);
-			lruvec_add_folio(lruvec, folio);
-
 			__count_vm_events(UNEVICTABLE_PGRESCUED,
 					  folio_nr_pages(folio));
 		}
 		goto out;
 	}
 
+	/*
+	 * Something to keep in mind when studying the arithmetic here:
+	 * we only come to __mlock_folio() when mlock_folio() could not
+	 * mod_mlock_count() itself; but by the time this is processed,
+	 * the folio may have already been munlocked, or another mlock
+	 * already marked it as unevictable and so mod_mlock_countable.
+	 * And don't forget that a folio may be unevictable for reasons
+	 * other than mlocked (hence the folio_evictable() check above).
+	 */
+
 	if (folio_test_unevictable(folio)) {
 		if (folio_test_mlocked(folio))
-			folio->mlock_count += MLOCK_COUNT_1;
+			mod_mlock_count(folio, MLOCK_COUNT_1);
 		goto out;
 	}
 
-	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
 	folio_set_unevictable(folio);
-	folio->mlock_count = MLOCK_COUNT_0;
-	if (folio_test_mlocked(folio))
-		folio->mlock_count += MLOCK_COUNT_1;
-	lruvec_add_folio(lruvec, folio);
 	__count_vm_events(UNEVICTABLE_PGCULLED, folio_nr_pages(folio));
+
+	if (!folio_test_mlocked(folio))
+		folio->mlock_count = MLOCK_COUNT_0;
+	else if (!mod_mlock_count(folio, MLOCK_COUNT_1))
+		folio->mlock_count = MLOCK_COUNT_0 + MLOCK_COUNT_1;
 out:
+	lruvec_add_folio(lruvec, folio);
 	folio_set_lru(folio);
 	return lruvec;
 }
 
 static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec)
 {
-	int nr_pages = folio_nr_pages(folio);
-	bool isolated = false;
+	long nr_pages = folio_nr_pages(folio);
 
-	if (!folio_test_clear_lru(folio))
-		goto munlock;
-
-	isolated = true;
-	lruvec = folio_lruvec_relock_irq(folio, lruvec);
-
-	if (folio_test_unevictable(folio)) {
-		/* Then mlock_count is maintained, but might undercount */
-		if (folio->mlock_count > MLOCK_COUNT_0)
-			folio->mlock_count -= MLOCK_COUNT_1;
-		if (folio->mlock_count > MLOCK_COUNT_0)
-			goto out;
-	}
-	/* else assume that was the last mlock: reclaim will fix it if not */
-
-munlock:
-	if (folio_test_clear_mlocked(folio)) {
-		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
-		if (isolated || !folio_test_unevictable(folio))
-			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
-		else
+	/* There is nothing more we can do while it's off LRU */
+	if (!folio_test_clear_lru(folio)) {
+		if (folio_test_unevictable(folio) && folio_evictable(folio))
 			__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
+		/* But whoever puts it back on LRU should rescue it */
+		return lruvec;
 	}
 
-	/* folio_evictable() has to be checked *after* clearing Mlocked */
-	if (isolated && folio_test_unevictable(folio) && folio_evictable(folio)) {
-		lruvec_del_folio(lruvec, folio);
+	lruvec = folio_lruvec_relock_irq(folio, lruvec);
+	lruvec_del_folio(lruvec, folio);
+
+	if (folio_test_unevictable(folio) && folio_evictable(folio)) {
 		folio_clear_unevictable(folio);
-		lruvec_add_folio(lruvec, folio);
 		__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	}
-out:
-	if (isolated)
-		folio_set_lru(folio);
+
+	lruvec_add_folio(lruvec, folio);
+	folio_set_lru(folio);
 	return lruvec;
 }
 
 /*
- * Flags held in the low bits of a struct folio pointer on the mlock_fbatch.
+ * Flag held in the low bits of a struct folio pointer on the mlock_fbatch.
  */
-#define LRU_FOLIO 0x1
-static inline struct folio *mlock_lru(struct folio *folio)
+#define MLOCK_FLAG 0x1
+static inline struct folio *mlock_flagged(struct folio *folio)
 {
-	return (struct folio *)((unsigned long)folio + LRU_FOLIO);
+	return (struct folio *)((unsigned long)folio + MLOCK_FLAG);
 }
 
 /*
  * mlock_folio_batch() is derived from folio_batch_move_lru(): perhaps that can
  * make use of such folio pointer flags in future, but for now just keep it for
- * mlock.  We could use three separate folio batches instead, but one feels
- * better (munlocking a full folio batch does not need to drain mlocking folio
- * batches first).
+ * mlock.  We could use separate folio batches instead, but one feels better
+ * (munlocking a full folio batch does not need to drain mlocking batch first).
  */
 static void mlock_folio_batch(struct folio_batch *fbatch)
 {
@@ -169,10 +174,15 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		folio = fbatch->folios[i];
-		mlock = (unsigned long)folio & LRU_FOLIO;
+		mlock = (unsigned long)folio & MLOCK_FLAG;
 		folio = (struct folio *)((unsigned long)folio - mlock);
 		fbatch->folios[i] = folio;
 
+		if (!folio_try_get(folio)) {
+			fbatch->folios[i] = NULL;
+			continue;
+		}
+
 		if (mlock)
 			lruvec = __mlock_folio(folio, lruvec);
 		else
@@ -218,19 +228,25 @@ void mlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
-	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
-
 	if (!folio_test_set_mlocked(folio)) {
-		int nr_pages = folio_nr_pages(folio);
+		long nr_pages = folio_nr_pages(folio);
 
 		zone_stat_mod_folio(folio, NR_MLOCK, nr_pages);
-		__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
+		count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 	}
 
-	folio_get(folio);
-	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
-	    true || /* XXX Temporarily disable mlock batching */
+	/*
+	 * No more to do if mlock_count is maintained: either the folio
+	 * is on an lru_add fbatch, and will be moved to unevictable in
+	 * due course, or it's already counted as unevictable: no need
+	 * for an mlock_fbatch entry below.
+	 */
+	if (mod_mlock_count(folio, MLOCK_COUNT_1))
+		return;
+
+	local_lock(&mlock_fbatch.lock);
+	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
+	if (!folio_batch_add(fbatch, mlock_flagged(folio)) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
@@ -244,15 +260,24 @@ void munlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 
+	/*
+	 * No more to do if mlock_count is maintained and still raised.
+	 * But if mlock_count is unmaintained, we might need to queue an
+	 * munlock fbatch entry, just to cancel an undequeued mlock entry?
+	 */
+	if (mod_mlock_count(folio, -MLOCK_COUNT_1) > MLOCK_COUNT_0)
+		return;
+
+	if (folio_test_clear_mlocked(folio)) {
+		long nr_pages = folio_nr_pages(folio);
+
+		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
+	}
+
 	local_lock(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
-	/*
-	 * folio_test_clear_mlocked(folio) must be left to __munlock_folio(),
-	 * which will check whether the folio is multiply mlocked.
-	 */
-	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
-	    true || /* XXX Temporarily disable munlock batching */
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
 	local_unlock(&mlock_fbatch.lock);
-- 
2.51.0


