Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3893AC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C4F6B008A; Mon, 24 Aug 2026 11:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C536B0096; Mon, 24 Aug 2026 11:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D2B6B0099; Mon, 24 Aug 2026 11:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A75A56B008A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:49:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A90A5A02E3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:49:35 +0000 (UTC)
X-FDA: 85136597910.29.DBF4AD0
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8411B40008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:49:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZbzfsnVG;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787586573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bUpuIKeVP88lgTSCxGsoiU0GQ4MnqPzmUq2XXBctZw=;
	b=sxKXKHh9dt0Xnn6mtlDHxPmslkLz5DBok6tPbOPVrNoBsUhs8jISmGcLVbyMsfMJCivYFO
	KjDrJeb1ipkQPQhrNekLgA5iHFVuOhIzx/1dYlDWKgEU3L4texj0qHNz7WVcqWeTewr80i
	HZjpDTxvUidyzcGQMcnmcIukPav7Cuc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZbzfsnVG;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787586573;
	b=in/DcyvOjhpiHXhERHwsvnwy5EUJysFpQHMyNPt6dpDRNEVfaYr3DDHqYXrDEiuKxOSi7e
	RDEyNOeCGh+NHf4Uc++rmlAGTPsStwGaJO3pyXlRuyZniUAFxcYn5S0PX5M5l2pHH57D/d
	ldPqJGFKulOc9I+KYeVsvAK2Xp1W0Q0=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-90cabe38a61so7784346d6.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787586572; x=1788191372; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3bUpuIKeVP88lgTSCxGsoiU0GQ4MnqPzmUq2XXBctZw=;
        b=ZbzfsnVG31M25n1MM6vQxsPYDsa7bMPSUhWjwz0HgAeWGS1BYq2PHen2USFGpkm1uT
         Rb681uFw9UzWysn82nMzeaMo0uo2mFxy0FqoACv2CsezyDetQhKC37LYik1YpEIEikwQ
         ihpEMP+tkCa5CNPGmzb4sIi2r+gJwpOHBwUV29dtq7v7kcKbYC1Mw9rveHRgo6EH4Svv
         e2D/QiWcEPc79xNqExsZE+ld0WL66WJj7gHu9Lek7G6BuZVAwxYzoNZNhYJieLLwcAfx
         m5rgWlmbqum7oJMiTPBItLGOO+asi9oi4BWcx4/Hwd4+/rLAqiaCLpbKi9jY5CSKyltM
         +NHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787586572; x=1788191372;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3bUpuIKeVP88lgTSCxGsoiU0GQ4MnqPzmUq2XXBctZw=;
        b=pV0P29ys6aZzcJrKiTspMI1MIwPu0d2OEEmA2Fh7/fCIX1wo48fPRJp0GGHy2UdcGD
         d/rmeVpA1mQDcsBv5aJRc556KhwMweFqPDNA6qA2eXVCCnjcQCNMlvwUJete9WBX3c3L
         7G3h/rDIPgEY2PP3XavIgZnLtzt10Sk0ji6PZFVRCPQE2oygfH7TLRC0lakbCHdobCxr
         hUpLjsA+et60nK02m9uscyMtk1NExm91c2yql3nWUi41sBxJlnJU418ppx+j4OMZ+OvN
         79+IQS7Fj9hYztW8Of5xxhtXZledQAo9fDSGnLw/mujd2Sa33p7XT//LUeRfoIzNAmJN
         TuIw==
X-Forwarded-Encrypted: i=1; AHgh+Rpr1FD73ZfcJmvhIsD1s9cMefwEoxrtUZl5t5pydX/HLF/+pMmegV+l5Snwv5NVH6AV2OUtsRYc8A==@kvack.org
X-Gm-Message-State: AFuF++kjCFFSX2EDj4SNwVj5adcUwafOFG42qFfo3aK1OMegVOO130fk
	8RCIJQ61UY9IHpZ9XMJls9vK7ITX/r33TdTNSIYNXNYZNB8lnuE9TQrL+pn6p8nC/4Q=
X-Gm-Gg: AR+sD10fAENWce6FyRmD9E2/vPziwSQVQsSfArv1UnGLArQ3Z6fuE8+pTj4p+Dnycia
	QI4kFnF6WH/SNPxnd4xrL3ubBRBN7LY4dOwD3AdoXFOfNng5m0FmM0o0v28b2PHVY9pGst4nw5f
	hDN1F7tzULUwIbE55MAQ+NJi8n2c4m7rMzNL+jTvj/FWOg2sNZcowvmm7c1cLDssfbnbEPmk34B
	0a0dnvyOfNgb/mcDWA/oVmNWBhU1FFoDDruVSAoEyxzKtyFqmvmM12wxIcw3Ja6KMym1/IC77ie
	Dzs+2Sjl+z2tKsnaBNEq1WB8Iy4US4Gnngtg0lz7dKx151/2dimKFlQBXjb8+PJsFQepTpJTJJv
	PJkbcpchejl6D0awAf1BxaPhjGgVjtfuqtm3P+SenYRtFdcBBlmFRh8uncQsASG3wxZOEtQFKiH
	6uN7WzR6ZKHjqTUSmfaQFWogIWMJaPcsDhDeuO7FGISXR6bRZ60P9/+msf48Q=
X-Received: by 2002:a05:6214:f2f:b0:908:a916:4727 with SMTP id 6a1803df08f44-90c8fa2cb39mr194848236d6.25.1787586572331;
        Mon, 24 Aug 2026 08:49:32 -0700 (PDT)
Received: from localhost ([2600:382:8b2b:357c:c834:fad7:4274:2299])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c93a7af21sm64308866d6.41.2026.08.24.08.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 08:49:30 -0700 (PDT)
Date: Mon, 24 Aug 2026 11:49:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, nico.pache@linux.dev,
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
	hughd@google.com, liam@infradead.org, mhocko@suse.com,
	rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org,
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org,
	ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, jannh@google.com, willy@infradead.org,
	pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 16/57] mm/collapse: freeze the sources behind
 migration entries
Message-ID: <20260824154921.GA863036@cmpxchg.org>
References: <20260816224609.308019-17-kirill@shutemov.name>
 <20260824131224.73344-1-lance.yang@linux.dev>
 <aoxQnuEacGpzp2I7@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxQnuEacGpzp2I7@thinkstation>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8411B40008
X-Rspamd-Server: rspam07
X-Stat-Signature: 9w9yiitb4kyi9cz3raty48b1ddghszbg
X-HE-Tag: 1787586573-585681
X-HE-Meta: U2FsdGVkX1+LeAS1MvYDr+0BUIV6utbd4CcweEIcrtw35ynpQfJItHAfgAsk5orr+QdypWqavoB9tVgm7wRewP75k75p63aHw8M/a6Y8q8oZpEwWLZqar1tMqgDJmugi5Unfc8drRYqhu7/cfNVRWOBJwhpFnavcFYqn0KTyaFKVR/SDUvazESUGq4n1zi8vHa/7rxLbMYkcz8YKYuJpty5NbIi1t2J6iwje71kkzP9QR8GjnSeo9piIMIjHWEmQ4K0Slhpe9KkYyN6sH5IvHnK721CB6oHSfwcGaO0fnNve9EIsFooO/rknJYO+6NF7ZCM2+JfpSP/JpyDJeiJ4J8Pk5EH6tZeFz7bgO4rHOj2RzyVOAUIj/5t3hLCSxgkDQAk9qjmMWt3bxWrk95mAw+B5FIZkSErWusuZ1IoNP7i5mAn7bit27E57cPIHLmszqWCN1Pxz2UioXY2v35v1219H05p/S+DR7qYysMhjFCS3HJMrufhWaNTimOKdoSdbtEzmggNOMTucYI2QEOHJMYVfVmz/b4ePaXB5XtVmwsO73thW2RGLJgS0wPi05GNhHsbZHZTNvRN949QbJvrFYEhwgbt8iQ8xjxk6dvL4c7za2aCWwyQBtvOwFy/A4zqet4w92FYp1kZv7i2JEnRdoAmLM+69T5U456PwNyTOKS19QVQnk/igmzuMzrrdLMTblijJoxepEqknHgmhc5WBGGe9jaAYwgVbGWnKRGbUwPUVr50KL8Qcpfz0FDduqPKsQZ6CJzHpUguEDmK8eZCloIYQAX/O++Lfq4aPSN7461I2N4cTiXWjduXyO3PPy1E4IU1+t5rvhWuWlr/yARJc7Ry7Td3MWK+LwEPmuhk9DAdApqGYLqJy9p/L2PyG3jd136v+EmJFUPFtCscjbSECbLc1rAggx2501o4qFVnxPY6lV2W9cOZR1GIivog/ft0998Kae05VPoVsRMifNNw
 bOdIxbcj
 rWa8NUNZnSKWYmlDI1cYzyx77+SbbRsjsHU8Cc0hrcarcbg8i9sYfBKEwhJ05TELiuktkMMsn5j244P57d+kIrJwR/ZU/Toa11Mcl2inOqY/+vhjaWOBgEAc/2CfhBr87veXPDov5HvksWekkOoZfDhjK5JncQOKYX7YtFbqUft678V2AlPin1hd+4By1+2ROf2LDCsq51zQZ/LvVGxsv1xYoYD8T1rwSsKJVl1ttval5t3lvSgRnDG28gFk1OOu+zkmYTvaPzr3hbSwW0MCjjn/gFKSvBQkz5L3/IF8blLpVckPjOCRiurq1bVxtwp82hEU1vkA4Zp6PvVJPUXUca2DQxs1Yo52edsWQP8cxgfDhLBUs6ZhuYPsi7M9iLZdZHQ2CDaoaq7gVqVdfplx0/qOuLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 03:13:10PM +0100, Kiryl Shutsemau wrote:
> On Mon, Aug 24, 2026 at 09:12:24PM +0800, Lance Yang wrote:
> > 
> > On Sun, Aug 16, 2026 at 11:45:28PM +0100, Kiryl Shutsemau wrote:
> > >+		if (!folio_ref_freeze(folio,
> > >+				      folio_expected_ref_count(folio) + 1)) {
> > >+			result = SCAN_PAGE_COUNT;
> > >+			goto unfreeze;
> > >+		}
> > >+		nr_frozen = nr_saved;
> > 
> > Just one thing I was wondering about ... can deferred_split_isolate()
> > remove a source folio from deferred_split_lru while its refcount is
> > frozen by collapse_freeze_candidate()?
> > 
> > Assume an earlier span belongs to an anonymous large folio on the
> > deferred split queue, then a later span fails folio_trylock().
> > collapse_freeze_candidate() continues after freezing each source folio
> > and calls collapse_unfreeze_candidate() on a later failure:
> > 
> > static noinline enum scan_result collapse_freeze_candidate(struct mm_struct *mm,
> > 		struct collapse_candidate *cand, pte_t *pte)
> > {
> > ...
> > 	for (i = 0, addr = cand->addr; i < nr_pages;) {
> > ...
> > 		if (!folio_trylock(folio)) {
> > 			folio_put(folio);
> > 			result = SCAN_PAGE_LOCK;
> > 			goto unfreeze;
> > 		}
> > ...
> > 		nr_saved = i + nr;
> > 
> > 		if (!folio_ref_freeze(folio,
> > 				      folio_expected_ref_count(folio) + 1)) {
> > 			result = SCAN_PAGE_COUNT;
> > 			goto unfreeze;
> > 		}
> > 		nr_frozen = nr_saved;
> > 
> > 		i += nr;
> > 		addr += nr * PAGE_SIZE;
> > 	}
> > 
> > ...
> > unfreeze:
> > 	collapse_unfreeze_candidate(mm, cand, pte, nr_saved, nr_frozen);
> > 	return result;
> > }
> > 
> > folio_ref_freeze() takes the source folio's refcount to zero:
> > 
> > static inline int folio_ref_freeze(struct folio *folio, int count)
> > {
> > 	return page_ref_freeze(&folio->page, count);
> > }
> > 
> > static inline int page_ref_freeze(struct page *page, int count)
> > {
> > 	int ret = likely(atomic_cmpxchg(&page->_refcount, count, 0) == count);
> > 
> > ...
> > 	return ret;
> > }
> > 
> > While collapse_freeze_candidate() still holds the source folio lock,
> > deferred_split_scan() can call deferred_split_isolate():
> > 
> > static unsigned long deferred_split_scan(struct shrinker *shrink,
> > 		struct shrink_control *sc)
> > {
> > 	LIST_HEAD(dispose);
> > 	struct folio *folio, *next;
> > 	int split = 0;
> > 	unsigned long isolated;
> > 
> > 	isolated = list_lru_shrink_walk_irq(&deferred_split_lru, sc,
> > 					    deferred_split_isolate, &dispose);
> > }
> > 
> > static enum lru_status deferred_split_isolate(struct list_head *item,
> > 					      struct list_lru_one *lru,
> > 					      void *cb_arg)
> > {
> > 	struct folio *folio = container_of(item, struct folio, _deferred_list);
> > 	struct list_head *freeable = cb_arg;
> > 
> > 	if (folio_try_get(folio)) {
> > 		list_lru_isolate_move(lru, item, freeable);
> > 		return LRU_REMOVED;
> > 	}
> > 
> > 	/*
> > 	 * We lost race with folio_put(). Read folio state before the
> > 	 * isolate: folio_unqueue_deferred_split() checks list_empty()
> > 	 * locklessly, so once removed the folio can be freed any time.
> > 	 */
> > 	if (folio_test_partially_mapped(folio)) {
> > 		folio_clear_partially_mapped(folio);
> > 		mod_mthp_stat(folio_order(folio),
> > 			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> > 	}
> > 	list_lru_isolate(lru, item);
> > 	return LRU_REMOVED;
> > }
> > 
> > And folio_try_get() fails because the source folio has a frozen refcount.
> > deferred_split_isolate() treats the failure as a race with folio_put(),
> > clears PG_partially_mapped and its MTHP_STAT_NR_ANON_PARTIALLY_MAPPED
> > accounting when set, then removes the folio from deferred_split_lru ...
> 
> Hm. So, the premise in deferred_split_isolate() is false:
> !folio_try_get() doesn't mean lost race with folio_put().

I suppose you mean, not exclusively. But it can also mean that. And
then the question is, who cleans up the partially_mapped state.

> I think deferred_split_isolate() should do something like:
> 
>       if (!folio_try_get(folio))
>               return LRU_SKIP;
> 
>       list_lru_isolate_move(lru, item, freeable);
>       return LRU_REMOVED;
> 
> Johannes, do I miss something?

Ah. The idea being: leave the item on the LRU when there is a race
with the refcount going zero; and then it's up to that other side to
deal with/clean up the partially_mapped state as appropriate. Thus:

folio_put()
  __folio_put()
    folio_unqueue_deferred_split()
      if __list_lru_del():
        // clear partially_mapped state & stats

will always succeed, even if it races with the shrinker. And you are
also guaranteed on the collapse side that the state won't vanish from
underneath you.

I think that should work. Usama?

