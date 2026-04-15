Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55F09ED7B97
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 02:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0C86B0089; Tue, 14 Apr 2026 22:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC86B6B0092; Tue, 14 Apr 2026 22:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04D16B0093; Tue, 14 Apr 2026 22:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A20626B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 22:29:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40C00E362C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:29:17 +0000 (UTC)
X-FDA: 84659208354.07.8BFAA60
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5EA7410000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:29:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XXubPpd5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776220155; a=rsa-sha256;
	cv=none;
	b=DuHOf9jBfniQQ8UjqxgupUT6iBp3t9mdDLZbsB5aR4/q9zhTbmZc5AimSrbYwQyC2sRUwV
	of18eyG+QDnOMgL0OkCvFkzs+8dus1BwZ0mdMKUzFFMXjj5YXiOPgkNwyXzTDcDSbf/W9s
	DRrtYOiqCcBKeBqdZ/AVUf29i/a8Nto=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XXubPpd5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776220155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XsHolYzCuCMig4brfjVoKd0+wlDIH68uItyQD+saKOM=;
	b=325KuNV0YJpI1dmzTcIcO4Tldmv2jEqKs/ECeDFCkWIUHdnCNLTVkp7xWrzMHMKOGiQd2c
	tZrcdv6D2sPT/At6CtBeLNoVfCzHA6+FiEOADu8yBX4js7TP2Lm6j8GyTNNrV/e1YRidcN
	wj0E/zjoVfuME/nxrDZGKXQjiJC31Ng=
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-471bf5157d7so2747529b6e.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776220154; x=1776824954; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XsHolYzCuCMig4brfjVoKd0+wlDIH68uItyQD+saKOM=;
        b=XXubPpd5CaSIuBI8yzCxBf5n0uEQ82rMiIv5pq9ghpSJTmiX6/9WQCga3Wxp0It3ei
         CofA3E8Mjy3lFpgaiWJwFbp18ULDkf00HNZ96X+twB/H/8GB6ikAhB8IYWMoecFZ4CYS
         DRZN6v1RAGlc55ShBwkLNIL2YMIBwSpOcA8xbz+0M5va3lYy2BtSi5ENuuppzgQ037Md
         5LEeE9VcZDRv5u2JW/dIPrIFH+GO+XraPkTZOv7hoKxi5LpnQ1oE6/uxfPvQQfdoz/o0
         e35sfziJmK/N4yYNkYDYsWjsQs+/MkghDi+iZgAipuaEJa2VWYe9bbKQT6WSRrtmmk7G
         90yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776220154; x=1776824954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XsHolYzCuCMig4brfjVoKd0+wlDIH68uItyQD+saKOM=;
        b=cablN5hsKQcikF6mO+psWbTmERgLI5kucAGHD2XFcplVdPYwRvIDK9TNkKMJnQJnAi
         GD4btxQWxug5pfLyPr8nA96AwaxSTc0xIneneMHx4725oOMJl4c0TS29rGCwF+P4eOZf
         z6mfBqbaBtPMvpcLVVw1HgFFzPhc2aOZj3r88fxs0fp+U1PbO8eCNp69rmAgkHXHRN9j
         7GiA/z5R2ywMLBPV2PWYvZhh6RWpBtYF9kpYSe6oQt6SVaxkYvBlZRxELC/Skp2Sj0DH
         21mvd7LgBY6xfztWT3mEvIEyFGWvDeDhJjAHBDJK57r1HfMdoDOD9DLCpRwKxAoIpPey
         Ot7A==
X-Forwarded-Encrypted: i=1; AFNElJ+uDzxJBd8/WBtfi6uJNojg9LkS7X2Hqt9ZWjuc5UIRm15BDMWutAF3drRaQpbxjVWJKM4qGK0IWA==@kvack.org
X-Gm-Message-State: AOJu0Yzb6AWL2IQyGyDdsmCr0VEZtvuCSYHnXgAEoMAGsRn+9b5NHBUi
	aihn8dyR3zpJRFja69bvjrvh/M1a5hjrehEsRrFvKbsYhiLL7UOFt1i2
X-Gm-Gg: AeBDiesMtTxfR4rAsHZ/tlAri5GVH68hzzhKh2ZtuJvOZj+y6aAZU6LqEFWrsa0E/5z
	00YO1YbEgfeC/oMXakXDkM9ALwUfu4n80uA5HxeoIPZXkKVeCoECFCJFB+xKhQZL3GDS2ekfg6z
	/zkfuIkkXNwm/1sFyS0e5ovOItEvKjthNz4yNt0KrXMXnLZ0VbRIz++NHx5VadLLNr+8R+rxWka
	tBseQa40d3r4e2OCJag7Ie5NZgRnb8uGHrQ/Aifzdk21hnkSpAiUnhCsNoMRC/MWJRZl+G4UIt3
	yD3iBr5jg8EBB2F5Ayobohbzhv5DI7GB9TJS5T66iP+BU6Hug+dGI59KcTFm/lYd7KxZ3NNXVUk
	7n3EZSZaGd/8q+vuAp/XH09L0royrPTKgTe7dYFD5je6tKnK7aU3m2AbHHT9xnYLvnCZoJW0gk9
	6EK/UyrLWsSmesmc9dTzSV
X-Received: by 2002:a05:6808:c1a6:b0:46a:cf7e:4b5e with SMTP id 5614622812f47-4789f50b740mr10154449b6e.43.1776220154167;
        Tue, 14 Apr 2026 19:29:14 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42689699dc8sm348039fac.14.2026.04.14.19.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 19:29:12 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/vmstat: remove unused __node_stat_* wrappers
Date: Tue, 14 Apr 2026 19:29:09 -0700
Message-ID: <20260415022910.1890050-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <9a852e74-1499-4a5a-8e98-56a33c67d639@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5EA7410000B
X-Stat-Signature: j3re3a4dk8cc937xxhnkp9qbqbewuanr
X-HE-Tag: 1776220155-975724
X-HE-Meta: U2FsdGVkX19ilEttKmCFVfh8hIcF5TPYSvzPAf5Jf3HiYDml7uKvOLeViKCTUpvgU9t3TcWFN3UKSVcHrT1nSF9suc6A3quA5SDiKfMKPIq3R8QFyW/k3/CjBdTPQ4zUlepgABFMTWFJah79E5lJZjkOxeFuNpRlHdKyAF+Gew6Dl3uc2MXjxRqdxtWtYd9mJT+B1kkyw/B09Kr1eSrGfR6TldMfexl5C8gJnxLfgmOfvzTJH9eDceLwbBDxw8CvTuE3tU1qmOhqlaQpLRtDUUMKv5PvacHfK6Nkq0PLvOqlD8UyqtRRhhrLmsd7N8iclcxPa2SXz5dpQ7ufzPxewQMh49WzH+6fDsTCNopW2OtDJ1sUZJfKzUoI9/Oag/yytmW3rnLLoiSuX5QaAyweUretF0AVfCiwFlGOCkH+5yaYy9adze1ElH9z9OlljTL9p3Imlau0OXt8yTlb7FUnk63amW518vAZSlFzKZsgM1ZoQRQdftcym8N0mPO3TTju5ftYXpTFgAF792n54HOBxzyarhEkceUOV2juySGXno6RdZhZUtxKfboErmhXPeTyGgA9+yGlNz25qgYsC7m3y6i1h08pk3zk89bG5gAc+s8ivYhAABey1D6VitgldGq/0kJkH5lfcALv5ss5CNRQGFQK+GIhDmx74oaMa7a2ikoiOmJ3KIf8aFZumfqIKt9OLNFbS0RpoKpb95IZBRc0sploCE5xvv6mOonroEf0Z0p70x86x7nfIUrSaTcvf5+2zv4pRw1vyhbBxFiuncMeEIh75MlH/K3xf8x8jXjBimpT/1Guf0CUXpg+EhJFs/snFRuQSBx0QrTZW+2PmdnXFNDI2QFhH7V+W46QXXX5f3mu0trsVGCEfizrALsrNHAXfJyrqY49s3kUOQX1qMV4xka+km1+IC7Rp/dqKNvbD8y1MKMG3RJc5MfxxHqZzMS7KFQ5MfGZLgp/1apCJiJ
 eMx2p6vb
 dIh6qhvtCnpheN8W0L3rOUu63vz3ALSzScjlavx/a+OSuLtgMfLZM1A1u9mZXNBag1S3ubtlG+H/lSF3G+ogH5DqMBIMd4lL41xf/3BxNL537cBgQeL983qLQuuk+RfllsGEFJYYslC9OpcRkFQew5drgKA2jEAyh1P0L2zntDWGH6t3VHjJbqwh7aiAEfGGRKsn/WOTBIZhfFxdZTaC7YQFLO8L+cqR14VWNRt7s9pZj042fPIkHlv2KBJmxK8GYKJ4a4oSH5AjZfiy3Yhs/ixz4jFqHpVTw5f2ffaY34PvwKcCCrvs237FrRZfMNU+CBtdYhkSMq9VCXa1kiS+pHIuikRLauTjcWQgfjDoSlVHVepHdHNvKUDpcxORvryqbPKAaNrrsvYT4vm+6twOYEeMdLaHSO9Yw5fjwkPRhveGKhO9oNDCRtmLPFdvm5zKc8YmYmwdD5tvOb92DJQH0e2HGrge6F+JSNMjDd7D5odZw1CuGhVy9zUfQsnchcqF/ixhswC4UOZsZ2YaKEHFHj53vrTa3NPhEOp/1MeAtmodZalJ25COF9qFpod/z0y9i73nzGj26NlAQDGBRQJ90yhd+DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 08:50:54 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> 
> 
> 在 2026/4/14 22:59, Joshua Hahn 写道:
> > On Tue, 14 Apr 2026 17:15:20 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> > 
> >> From: Ye Liu <liuye@kylinos.cn>
> >>
> >> Replace the single call to __node_stat_mod_folio()
> >> with node_stat_mod_folio(), and remove the dead inline __node_stat_*
> >> wrapper definitions from include/linux/vmstat.h.
> >>
> >> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> >> ---
> >>  include/linux/vmstat.h | 18 ------------------
> >>  mm/page-writeback.c    |  2 +-
> >>  2 files changed, 1 insertion(+), 19 deletions(-)
> >>
> >> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> >> index 3c9c266cf782..54da7d820f78 100644
> >> --- a/include/linux/vmstat.h
> >> +++ b/include/linux/vmstat.h
> >> @@ -440,24 +440,6 @@ static inline void zone_stat_sub_folio(struct folio *folio,
> >>  	mod_zone_page_state(folio_zone(folio), item, -folio_nr_pages(folio));
> >>  }
> >>  
> >> -static inline void __node_stat_mod_folio(struct folio *folio,
> >> -		enum node_stat_item item, long nr)
> >> -{
> >> -	__mod_node_page_state(folio_pgdat(folio), item, nr);
> >> -}
> >> -
> >> -static inline void __node_stat_add_folio(struct folio *folio,
> >> -		enum node_stat_item item)
> >> -{
> >> -	__mod_node_page_state(folio_pgdat(folio), item, folio_nr_pages(folio));
> >> -}
> >> -
> >> -static inline void __node_stat_sub_folio(struct folio *folio,
> >> -		enum node_stat_item item)
> >> -{
> >> -	__mod_node_page_state(folio_pgdat(folio), item, -folio_nr_pages(folio));
> >> -}
> >> -
> >>  static inline void node_stat_mod_folio(struct folio *folio,
> >>  		enum node_stat_item item, long nr)
> >>  {
> >> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> >> index 6f9b7b081ab7..ed3301753e89 100644
> >> --- a/mm/page-writeback.c
> >> +++ b/mm/page-writeback.c
> >> @@ -2627,7 +2627,7 @@ static void folio_account_dirtied(struct folio *folio,
> >>  
> >>  		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
> >>  		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
> >> -		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
> >> +		node_stat_mod_folio(folio, NR_DIRTIED, nr);
> > 
> > Hi Ye, thank you for the patch,
> > 
> > In addition to what Matthew has pointed out, I also wanted to note that this
> > substitution isn't trivial; there are differences between the __ prefixed
> > version of node_stat_mod_folio and the one without. Even though the correctness
> > of the two versions might be the same, I think that a change like this should
> > be supplemented by a description of what side effects this change has
> > (i.e. introducing additional overhead from the cmpxchg loop).
> > 
> > Thank you, I hope you have a great day!
> > Joshua
> 
> Thank you for your review, Joshua. Regarding the difference between
> __node_stat_mod_folio and node_stat_mod_folio: in the current implementation,
> both functions ultimately use __mod_node_page_state, as mod_node_page_state
> is defined as __mod_node_page_state. There is no functional difference
> between them in terms of atomicity or overhead. The __ prefixed versions
> were wrappers that are now unused, which is why we're removing them.

Hello Ye,

Thanks for the quick response. However, I'm not sure that's true.
For #ifdef CONFIG_HAVE_CMPXCHG_LOCAL in mm/vmstat.c, I can see that
mod_node_page_state calls mod_node_state, which includes the cmpxchg loop.
I think many users enalbe this config, including x86. IMHO, we should document
this effect of the changes.

Thank you, I hope you have a great day!
Joshua

