Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B67606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P+GUhHOC
Received: by kanga.kvack.org (Postfix)
	id D01AB6B05B0; Thu, 26 Nov 2026 07:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2016B05B3; Thu, 26 Nov 2026 07:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F976B05B4; Thu, 26 Nov 2026 07:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F33A6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:38:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 820A5A8D8E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:38:47 +0000 (UTC)
X-FDA: 85477224294.08.681792F
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id B1F2B20002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:38:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P+GUhHOC;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795696725;
	b=VPkMbUNOWxkvQGr1jpQDlHqeQyNk4f+rq28U6tUH1dWMFKljK+BoPbVqS22yXUTQfT8j0V
	IygsDXYYjUz8/nGaa2ihUOG55hLC+aWTzc+5ebQcga3GpKgTVfouc9bsQ7w4soGl95jKeI
	Sm3fu9X3opsbtoUwvRvCTH3ap8041fc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795696725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/AbZhSvVAtAuxRzfiAolPI8iaF2YFQe3pPvY/yniKU=;
	b=wGwT8elCVYaVDAA9rGHDkrZD47/WDKBE/uaFbITtxIh/55XF24qdfDM2hlBGfvv6K5w4Sk
	hQXWhcJu/gM/9kvjpxa3Pg32ZSsxDJabWXfLrNgi/F3fUnxvAz+lK5mU/IQkzbCfZ7OfHe
	GmxsIPDlGHUMl6aj2v+4Joj0QjseCYc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=P+GUhHOC;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd62c570b5dso4716642a12.2
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795696724; x=1796301524; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C/AbZhSvVAtAuxRzfiAolPI8iaF2YFQe3pPvY/yniKU=;
        b=P+GUhHOCV+j3JCd5eUoeWNkc9gQgHq18U6MOcUUEr0ymrT8Zc85hcMgIwuOSQAeN0S
         lH6zLQoqwDz2RPNA1sQvszRDVnUcEQikWusyIem5Fe2QowleHg1t0oq+0asR3kH84nAo
         7+J+4t1bgfgTSiGaSse59DW1W56Etc88mmE42euXNEQkPH+ANCn1+ZgiSIZp/R4myEga
         hyU9c1BVCcEUbEEE/5eYr+LFSukSmqR4cI5ralPVLUwsK/sQRwwRwdvvmuupJ6VUBEG0
         Sxze3pRZ6sIRzHSae8PozX99nPWkrz1yxJPD9N/Z0rWJpwqynza/6JFaumJXw+IgJ13a
         io4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795696724; x=1796301524;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C/AbZhSvVAtAuxRzfiAolPI8iaF2YFQe3pPvY/yniKU=;
        b=mweWrLb4SUb8fF1aK0egEjG8btqd3PHzCIxq5PsPlO8knMbMlYIiZBd5HXd9/BtCOi
         04eLxxZ776ZOqUsvelQiURxLx3nl4Je0Jw+UYFJifSLuhDoARKATWoXL8IaomS6p7bxb
         kxN11Y2rCCprPxhh8CYmurVI/f5ZR7K0E+7qSCvVG10R4DPd5awNUlCv1c8sDKFXbBRC
         iKuo7GjjQ3G5sTkNZIGjuNqjxzVgWZ3LduE+TzgfO0kkWHPs1m9qfF2syz0AiMn2n7c2
         CggHQfmBbprc2WEeqzETf3HhtIIABmu8G70hCLyJXVnw2p59JTvGshl4sqEwho5uDz3u
         Nc9Q==
X-Forwarded-Encrypted: i=1; AL+hErF9DTElo8hmSN753tzCS1PNvqif9SbjXzRmTGYDDUfn9HBBXrGpyBRWFRykEV1075mekzyRq0ASrg==@kvack.org
X-Gm-Message-State: APuU4Z/8cQ3TuZf6JSUekOptXdrtali5CdFgBGH78wiHRpyMnGGn+1WI
	CArQVXSRcvl/aHz6TBePqsb8QyhdBagXv5v1ww2zmYbXPnNDSMatEV7z
X-Gm-Gg: AZFdTZe7O+oAem5G1rAjl7dV+7jtK2QYIT+mPqZdEUgfMRcp0WosTCvgvKZl0MN8M2Y
	GJfgYtuHFGPbbTQPSPoihxbu+bfHrRfMT+HeePlPzLviE0sWJO2f8QjHdCGnYp8StTaCOr8RXDq
	uVJR/nZsDcZy3fTx94cYtXYfiMO+dCZuNcKahEA982FxfO4zoxUvQVYlgZ6JHOP1MGvGBZFt/Zn
	Yp2yKRjQCv7QO3x+e9KkLaFQxbElBvJcoTmBPtObcp0MRIkv882V17vckFaLC7e0MMvyEUwv7xB
	P4Nrj9hAfxYtIVABMNa69VdHZIDrU89eJmAz2z1SdnA/8dKhwYGqe1pfxbj99KS+aS7qSEqXBf4
	gN91rBP4F1L5r0IRwqCYb3Nmi1JzUy2cm9kqse2Nrd7MluLM4Qv+zuSsVmvaKTVbraKuECu4KyL
	gumeoV3ocwKEhsUqYCsDCIke9uHr6y0dlFJPMLotuWH66bW2tDbYYXGFuQfJWSM/pZ58Mu10OVJ
	GKF3Ymvb+242tjcqjopHoQjiaE/ukHY4yB6XguS+J05Tagn6+IwdtBl+XPY2Ftd7Boc0ilvJL9/
	2VwacjI91oBeGrSzPe838yX6CxJ7xgJ5sCUrZig6iJOhZ7leM4241CpGCaU7sDX/XVtLBdY=
X-Received: by 2002:a17:90a:d2cf:b0:3ab:2737:3395 with SMTP id 98e67ed59e1d1-3b41cafd604mr18006258a91.42.1795696724285;
        Thu, 26 Nov 2026 04:38:44 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm33352174a91.6.2026.11.26.04.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 04:38:43 -0800 (PST)
Date: Thu, 26 Nov 2026 20:38:16 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>
Subject: Re: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
Message-ID: <awgnMVr6GHt0XKD0@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
 <387237c3-c2f8-4782-9ba6-481f459cf7f2@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <387237c3-c2f8-4782-9ba6-481f459cf7f2@linux.dev>
X-Rspam-User:
X-Rspamd-Queue-Id: B1F2B20002
X-Stat-Signature: bi7ogkn4kf5hwa1xfuke9oeojw55nhoz
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795696725-669973
X-HE-Meta: U2FsdGVkX1/jB+D1mb2p3fFVVnU0pvgvfBLEqAr08jP3DiN989vHKDkF/iwE7WCHmsHQgrwbY2SPyIG9UeW7GKl6uZV261j1ulraLTY7GXcNXv3bQd/3hQqimDFoO2lxgV+5dB78E3Sy1Jw+H4bJouN6ft0TLbXNA/Wmfb8uN1lHKArbtavvlGbiaLTR8+XW5AOGKKVuily8hve6RMgBxymAsFRKmrlBY0UmsoBq0VxQYbneqyY8z0zw5vmQuXrrgX82udj6pmdNvIligX/y67MVLpWnkqCtcQUglm+CwGfJMluli35B5b7XpPQPzqLhTKepbz3QTCV6ySGLjSDsuGxhHveEb//DonAoGfUWGeN1j3XQReTEyxDZPSNcmGeKoueXkNTo/vtxLbPMj9RKQjGEjit7JJ97CeWiovbLVNB98YtZImv920ctHvDuK6qItVZytGYpkdA/CKxcfpa8wIboghhcjsSmNQMYYpglJxE2jWNw4sHyg9d3wMBJ7TrTrBQ9lAWVuu4c8tbv8FrgHywUB1SuzdWt4Px2U09o/hmsKj5XWZXKXP3kYfY3EKsikgIx50MUtaTUOdblGbt2e7YuMlubfyRQaI3nV5JRVbkVBtnByiJymCVpgCN6nQ515ZvWP6hGGjfZvTsaXW9x0rPwZ3feZPjeHKaxjOakjkCqZB5RzXPGHF49UVy0vVlz7gMO1HSdFA+6UbNSPvRTayJijvHU40dat5u4pSYF3t+9VT8+ugmstE1Cg0AUPCUgmD0sSaTSmoh5HRSTaAogyq5cEzjx8ddP490XDiVecWlcMWcvwht1JxgTrBPK+LRgrMaXikfImBWREXmAP8MZ9LzeKn720zlFYXflLlM6ebuLOsmdG823zDvbd6kLLZ3J1vBhvyh62qNhuLJfe7w5hVv1Oq3r4MmyNWcWSbvUM8zCLyBFtjAaYDWRaxYfuf/J6s2KhgWS9mcs4RbeG2d
 O47cPj7j
 P0fTv9XYkX8H6dkLyXtjPBRlim14sqsXBpOYHtJ0O6mWVOCrPNoe9+P+IJDn9GB/NEcsGAtj4cdjyKNfwununvnrKOJNZq9J7L1x4ajNS1B1LPkrbQbdzcHQ6bHnvAdJgmquDveTMWScWkBwVe1LbLJ8HMB00qaPTIj4PvhXkQowAY7KD5vhhrZYIZnZDu+ngZy+FSSBrRagZ9ZOmFmtIiZ1O8bB1+UZlesXGHPkAji2Qf0paRJbgumOxtOIaHekfs3jszfUsti3fVOdIZvRIBNJ0RBk/wUk8uQZTLBNKGGgMgNgQmLTCGT76QwlnReIOGIapOrDDV0t9YVH/ahP9ZTzwKam7pCzOkAgSjSASUowLCxFKkdJjwzA7uck/Q1x9pTtUvyHfyVHLeNKzNNqeOLGTw0lxbpYaeo0KEQcntUqc4cHpVShW7c3oIE0PDtbL7MaKZ1K+dZlCr4KmznlEu+W8KsuXTE664aKh/EFtXormzjlMIUVF15T4JGQEo3+vXidkKo5JOQBFyLtt2YHYV3aGBYU6kvorraQkFww9QoaDK/DHrFFf8FTsbGkDpIQA0stTVwfQ20i1WEvLmlPPXjVM85248IzX2UShWIe+9yIqI0qVNPYU6G+u2NsvlyS9fsBG10YntdOg4015rwI8cXRaym9BeIj8EgvENid9TDvr5VSndWD50LMLkj4BBo+Cv7vzxLFg/Vs0ZVopAi5uLtqVx3fhjFn+bRkjRpKPRiocBljbZ5wqStdLkDqghatSFb/rgq6TDwaHZaE+dBjgiuHK/rz4rUniv0sMi91pEG10IU+pYYGRI5i6HD/zmICIDteylPDJ1h360uTIVpZLBZurZ0kL+kUQqjZr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 05:43:14PM +0800, Ridong Chen wrote:
> 
> 
> On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > To enable moving file pages in folio_mark_accessed directly and lazily
> > for MGLRU, allow updating the LRU statistic atomically without holding a
> > lock. It may cause temporary counter underflow, which should be fine as
> > the counter is eventually consistent and only serves as an estimate.
> > 
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> > Tested-by: Andrew Morton <akpm@linux-foundation.org>
> > Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> > Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   include/linux/mm_inline.h | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 2395ca8ee305..2edb9beef6d3 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
> >   {
> >   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> > -	lockdep_assert_held(&lruvec->lru_lock);
> >   	WARN_ON_ONCE(nr_pages != (int)nr_pages);
> >   	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> > -	__mod_zone_page_state(&pgdat->node_zones[zid],
> > -				NR_ZONE_LRU_BASE + lru, nr_pages);
> > +	mod_zone_page_state(&pgdat->node_zones[zid],
> > +			    NR_ZONE_LRU_BASE + lru, nr_pages);
> >   }
> >   static __always_inline void update_lru_size(struct lruvec *lruvec,
> > 
> 
> Hi Kairui,
> 
> Just a heads-up: this may conflict with Joanne's "mm: move LRU size stat
> updates out of lru_lock in folio batches" [1], which is in linux-next now.
> 
> That patch makes __update_lru_size() add to a batch attached to the
> lruvec by the lru_lock holder, and relies on lockdep_assert_held() there.
> Once this patch lets folio_inc_lru_refs()/folio_reset_lru_refs() call it
> without the lock, they could write into another CPU's on-stack batch.
> So the lockless paths probably need to bypass the batch.
> 
> [1] https://lore.kernel.org/20261029204157.117879-1-joannelkoong@gmail.com

Yes I'm aware of that, the fix is easy too, something like:

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 4ca8011bd288..fb5e3990402c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -64,6 +64,30 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 
+static __always_inline void __update_lru_size_lockless(struct lruvec *lruvec,
+				enum lru_list lru, enum zone_type zid,
+				long nr_pages)
+{
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
+	VM_WARN_ON_ONCE(nr_pages != (int)nr_pages);
+	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
+	mod_zone_page_state(&pgdat->node_zones[zid],
+				NR_ZONE_LRU_BASE + lru, nr_pages);
+}
+
 static __always_inline void update_lru_size(struct lruvec *lruvec,
 				enum lru_list lru, enum zone_type zid,
 				long nr_pages)

---

And I think that batch design could be somehow improved too,
holding a stack variable in a global struct looks a bit odd, could
be simplified if we audit and update all users for update_lru_size
later.

