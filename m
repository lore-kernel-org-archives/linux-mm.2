Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7234D7308A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 03:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7CA6B0005; Thu,  2 Apr 2026 23:17:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458EC6B0089; Thu,  2 Apr 2026 23:17:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36EC56B008A; Thu,  2 Apr 2026 23:17:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2731B6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:17:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF6EE160341
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:17:08 +0000 (UTC)
X-FDA: 84615783336.04.B74325F
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15627140004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 03:17:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IGdeedKl;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775186227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFnDoZvmaKZS9xl10TAAVVbDQeroSu+kZDSt0MQ8jME=;
	b=LvB/gJRDjAtLBrZhSsHeiOM+O5cvfK++t/1UgT3TCW1ald6LmUD7ULhwzO2eCOeG5UhoB7
	+2hl/JY5yYa7S6J56I3uorEm7yu3O0mTPRe3waL0Ga9FqFOzlslacCtAcmjSNAGny6HhEn
	l7gM++hvuFSaneAAg/0wgq6s5a0TalQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IGdeedKl;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775186227; a=rsa-sha256;
	cv=none;
	b=e25YxpqBvm9bcqnWGAbuLjv+bWb7ZBWlSJ1WMNsRnR1uZtlW93e77N28cJ4VVvSlcOrHVP
	z7yOxyko3wgoIe4k119j20iPzff0R/whBCsTmBuY2J9DkYc9CH1Fldxg/4eTFuwwsslJsT
	MoIJliJsjeWrAWIXiaDaW9c/KJf7ZBs=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c7358a7a8d1so974640a12.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 20:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775186225; x=1775791025; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dFnDoZvmaKZS9xl10TAAVVbDQeroSu+kZDSt0MQ8jME=;
        b=IGdeedKlIKVA9v7SarVYaAyhrWwSPyXogMGG3V3mCpO4G4xlUOMvzCzaNUATpjELlE
         AlvWrfHYTVOA5F5/ZBoNSaQ93aAt2K/PNGU+XJ3pUm6a6nHTBF3QvBpEbwOfcZEAZLQT
         jRy60OUhetyoW+57UJ+WYI5x+W22pA/HatcxB2LmrrFIGr9hhe0RFINWEl1qGK+jDIgs
         u555MQhnE7hNRqjRzsq9FoKAh8HMWt6q3mzF1W6z9pVSYUzCYdyk0Dv16adhzoWWfPR1
         SODtUJJ6XPTb1ccMaBbv+da7e/7Avy2DSP+nu0dNbNS4AuI6B97qEbeAIhfbeky79YCp
         seFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775186225; x=1775791025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dFnDoZvmaKZS9xl10TAAVVbDQeroSu+kZDSt0MQ8jME=;
        b=mVWNDbMPuC4t3Os1K/gomtO1QQavOj6S0KeI49pz5q3bjLMzuQPzb0hBP/73x7KunG
         pV33aAvKpMQpbQq4MYItxLfm5r+RhOstY5/aUHram7mSTZf/XrPx6ZSA88vFEakZNMGo
         gNyPpLEcIZkg8LJC9B73WAVJKgFo7SpgLzO0hBu86MOaEUkZ8PflvHmKIAOl5IHCt/gw
         7GYAIaC64AR2NqWUeVnDwd+IqzqTUGPDMxcUwXp22A7TXFaJATmlvYtF+Z7pVh91exfE
         IDIzjupklWgmQ5F2tfyZFMlcE0Z8TMTpTawKvmzMpzQC8mV3pVloKCFJ4vFDq01qZ102
         TAbA==
X-Gm-Message-State: AOJu0Yynaa8ITISq1Yx4AEy0dqC7oJz3rUpfVOb8Zs1pEr95WQiZo+sh
	f3+y6Sije8GwYioO4nYzcunoqv6O1oe5kKmEMOyYct0hew3jPWfXaVuTsU9EdrABpp4=
X-Gm-Gg: ATEYQzxzP9dYMPkoZ7/zLiBXd4aLvbJ/kmdJETMOpEwSVEgTfSIYXafPvRkshGsLvmX
	o12++6NDrTWr+8KyTO/ZSibuH2TuhGyTWwwVRL70p1RnwTybsqSTf+N2SRx2IZ6nuYtkX2ZmCD8
	XykjmNZoImuFDX2iaHR596+bDDaSIZ3qtL0NtidKEkerRlfSrOz56qTu5bqxbsk7TOuuUmEfy6q
	fU95PMScVaKD/abI9Gsy5oaC0SB5C9qRCJdCmme2K57sV4/UiPThW55w70SoiEE+nBYeES/LRpp
	+S9Pq8MUHz9RNyA4FUuYENWc/NnhJE5J+TRYIymwMWhIsvvNm4WMS31IylCJgghkfPXHnDV/Nok
	HZ5L3572iifyYq7MDDlSXYuZfbCbG7P2c6lrYj5qoLLQ8UTmztoXyBD3Xn25XKwyEVr+mbNw3Oj
	Zn3TrKjz5B1Viy8Th7tWlCQIKcBFfIwkaU3s8MdPis1swG9kwWsZMd629Y4y8UCJYMBH6I9pTAW
	9GRiOU=
X-Received: by 2002:a05:6a20:7d8a:b0:398:8f2a:5dd4 with SMTP id adf61e73a8af0-39f2ed97df6mr1324370637.8.1775186225496;
        Thu, 02 Apr 2026 20:17:05 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c3d67dsm5237029b3a.33.2026.04.02.20.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 20:17:04 -0700 (PDT)
Date: Fri, 3 Apr 2026 11:16:57 +0800
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <kasong@tencent.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v3 01/14] mm/mglru: consolidate common code for
 retrieving evictable size
Message-ID: <ac8jTW_WABzGxNnF@KASONG-MC4>
References: <20260403-mglru-reclaim-v3-0-a285efd6ff91@tencent.com>
 <20260403-mglru-reclaim-v3-1-a285efd6ff91@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403-mglru-reclaim-v3-1-a285efd6ff91@tencent.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 15627140004
X-Stat-Signature: egeno6z4dr7ejjrg6gosdtw8qu4o38j1
X-Rspamd-Server: rspam06
X-HE-Tag: 1775186226-10862
X-HE-Meta: U2FsdGVkX1+nIVdVoqMAhKdD7PbnzAFXOdgAO1Ij2YmJr1AWdnpCHiwqHrLDsD4BzbST4C/r86y9iMOzjTGxf/VAuQlAbi6GgYjCGJULXC6fhPyeb1i4gbeOl098zmJn+vkuObr5kfvMqyqjzaqjw2w+0ChB6ASubJVAE14xufPvE+3yyKRpBeU5KONMVC33XH07qNbzcDRGfwWgp80eKwfDYwhqPaNngYeU7qu6Xy9yJ9cFvJ9D3VhYnOAt2yAzKkFdOQXLqYQ3uqkyu58208ziMBFxlyKzgE4q4oFeYCfSgTL6BJGYpwHVaTtBvkV7yxa4MfrOUoAC2cjfHcZgqzzVoq0oxmbJLUiWagtfdgdH6EuBlR7sg50RhxMSg0OtU8byzj1I0hREAAALw2hoMcLDd0aPiqb8ivqgi7nb6LVDwCiZ6DunvwQHc0cS1lKAguMWSnW2hF9pXFt54AOQiSDoT8HbE/gLJFdZll3CFo/lzFfiQ8editDMTQPtx+E3tmu5tGUnGX69XW6ttRIPBPbvV1diL2KuINA7c51EJlBEYJdSigTY9OEYa1+Bwyh4JO2hcxz6DBEbAFX9NYvzfdIRl3Z4ENUUFlfha1XtSPXOp8GFpClTWs9U6dgj+SqyPMvkh65sz+Bk9S9CK2WyWQV/Lmx28HuaRAFoqkXNvnK/290zeEImjxNLXDWKXqYlEW42BVfOup2VOEDVTEV1rxQk59KHez1oKo3aZpZgRYYlTFc82GZ4Th+QExyCsA9JSoNmCNQhonocRIsbCONVbc02KUrNYCv1o/nRfdbUU5bZY26y+rl6dSZYRi8i0FUz9PczqSXUfQ9cbXjV0nCxW9WuTKtFq7eoqD9Y+gsJXHTa8Im2gWD4WEkalJxXvnKLUVOzAddEf+3UXq4/8mWMqT/TqsVfAKWPT6jdxRi4RWSHe8NopwP7N6fsIQbcKH5nC1mYITHw/us8d8zH0N0
 EloF1S6c
 +dUSCmwz8K4VcOsMbD07GjC66kFcX2W82EL/yYU7v13cosOddCeQpF+sYokTNwUACuwT1S1ENA3gjHLSglFx6F6E1mCgAOww5/QeD8j5HRnCBNDFlfcTt6e5wtIg+0ddaZDqQmqAJjf95pnAmOyDJF5LGmSoTYiKYtNzkLGeE8TcbuDXDscVmVQliqqg+eGTJLU7VZO0bXHVJwPbzRyV0Ucf3wVO9mgLwbT2UyNLPykeRhFJHYG8kd6eaBYGrWBbHjUmI/oJXRey0sOsAcmwaS2BFQZ5K3/lBoFap5tDSt9ILY4pYpIqtgUHjLtaxN+CR64hEFn3rpCRvu4z9cjBf0QUWSO88bTQXINYNSSmVwlNCFUhjeEVoNMRuKhAn2Y9gXXz5YMAXIHYDqgh+NnZGMfh9g6wZhcDLlPKSR+kNTgh60BHylL51dyPe7ziU5JsOzixYYR0mv88nPISw9TA6LZtvhymm4MqeK1EhOW1RLxfKnfTXOJ55Pa4tZvFOScCKHmIV0MZR0KjLxrfwy4UuuRrBLwJNIPbZkT/DlyprUKa2Nfh0hpj4lgMgrTYbo3v13E1xj6mN3zHKAXcKTf7Q1wmWAMGZNNS9JdXmTOh52q/vg1YIbvOZQXdqkqA0l47Q9MmYtNf3Er7MJ84JFnsxeoXB98pDeE1eu3esg3l0a4ANrNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review in case anyone has concern about it:

https://sashiko.dev/#/patchset/20260403-mglru-reclaim-v3-0-a285efd6ff91%40tencent.com?part=1

> commit e0119c3e147f68096f59fb96e1e69e83ecdfce40
> Author: Kairui Song <kasong@tencent.com>
> mm/mglru: consolidate common code for retrieving evictable size
> This commit merges commonly used code for counting evictable folios in a
> lruvec into a new helper function lruvec_evictable_size.
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 5a8c8fcccbfc9..adc07501a1375 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> [ ... ]
> > @@ -4909,9 +4915,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
> >  			     int swappiness, unsigned long *nr_to_scan)
> >  {
> > -	int gen, type, zone;
> > -	unsigned long size = 0;
> > -	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> >  	DEFINE_MIN_SEQ(lruvec);
> >  
> >  	*nr_to_scan = 0;
> > @@ -4919,18 +4922,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
> >  	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
> >  		return true;
> >  
> > -	for_each_evictable_type(type, swappiness) {
> > -		unsigned long seq;
> > -
> > -		for (seq = min_seq[type]; seq <= max_seq; seq++) {
> > -			gen = lru_gen_from_seq(seq);
> > -
> > -			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> > -				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> > -		}
> > -	}
> > -
> > -	*nr_to_scan = size;
> > +	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
> The commit message notes there is no behavior change, but does delegating
> to lruvec_evictable_size() introduce a subtle state inconsistency?
> Previously, should_run_aging() evaluated the aging conditions and iterated
> the generations to calculate the evictable size using a single snapshot of
> max_seq (passed as an argument) and min_seq (read locally via
> DEFINE_MIN_SEQ).
> The new lruvec_evictable_size() helper re-reads both sequence numbers
> internally via its own DEFINE_MAX_SEQ and DEFINE_MIN_SEQ macros. If the
> sequence numbers advance concurrently, the calculated size might be based
> on a different snapshot than the one used just lines above to determine if
> aging should run.
> Could this lead to unintended behavioral changes during concurrent
> execution?

This is totally fine.

Right lruvec_evictable_size re-reads max_seq - and that's really trivial,
I don't think anyone will observe any different in any way. The time
windows is so tiny and even if a different value is read, the updated
value is more accurate for getting the LRU size.

