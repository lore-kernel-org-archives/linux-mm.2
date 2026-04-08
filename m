Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C12FFD5F88
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 08:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C886B0088; Wed,  8 Apr 2026 04:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDD96B0089; Wed,  8 Apr 2026 04:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3A16B008A; Wed,  8 Apr 2026 04:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC916B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:43:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF8941405F7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:43:46 +0000 (UTC)
X-FDA: 84634750452.19.1137FD7
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2451EA000C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:43:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AM4CtB6h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775637825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDUg5Y8vVTIzFl3YbIlPH9lZElpr4/5T9t8qsPiD1uM=;
	b=e7XRbjzhF/3pOgsXwtmm88AG4oKDHq01ySj/zfla8IFdKC9fpZyJ5dwFEPcXOk5Cb9eeBm
	2fIKNuWZu5YYTsX/LNlqElqY7f1n4wjtw089mBYbU/emmBXLUA/6yu50n6w1WCt6KZvqwL
	tkhJ+Fsx858TYXkwN8R22g0lHCOotro=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775637825; a=rsa-sha256;
	cv=none;
	b=j4L9MHDHyrq6MIe9D6kVGo0gpy2UysDYvB4Sr4YRKtzVCM/pZZBWkiIoTt0M0k9u6ehYHR
	eF51OSiu2kxsS+j6flQVrS5wycGXzL4ybOwDQTnEWKWY61/j5YFC/9wq0h5RGsmPhv3zRP
	UKi9Xv6ntBtN6Kwi0Wo+/2xf4SHwNBU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AM4CtB6h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so3944737a91.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 01:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775637824; x=1776242624; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lDUg5Y8vVTIzFl3YbIlPH9lZElpr4/5T9t8qsPiD1uM=;
        b=AM4CtB6h/o2CUqgNCkldscOfaEM+Jb3P9GEWvxra8l0scLWvTIhQO84m96kqkwSn3A
         TSiwp+5MWdO+82+pHkF2+4Ey0MVPPyKl8Fda6AKjhoSrVory/7yfQ+KOcaD+T9nJYsjK
         HORYyHM89npe51VY+dQ+BxcLdVyYLvlYNTNqkX5O8IyT8TBNDRUwADC8gdw8GIS3azcH
         5SqZFHjS8kRXlvc3Abvz6Cs9wAxEEf/KjQW/Loks/fpfBlK8TKOpApp8l9+VKbXD3bwB
         389RI/1EFJJdGDza6xENOAQ+layGPcFefeKcEJ5fuk9egLEdDtxCb4INVeCHONSImD7u
         8Rpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775637824; x=1776242624;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDUg5Y8vVTIzFl3YbIlPH9lZElpr4/5T9t8qsPiD1uM=;
        b=CR9HLGE6m4h/Pzlstce4wbnK5Lvzp+TE7Mi63FVnq7AOATMcdD04MEzzeHiZEVsny7
         eJ+AFeKUD+/ObqNfUnAEIfehR6tpT0HNg1iWxPwOBIxZKJ9dl+oNr6E4+NLAqMUriEmo
         F6fehgeKpt4fVMYbOoawfbxrRmU6t3qCdFc929HfnTyQFmSP2uXqxYMH27W7CTVfdKsW
         MfNW03lGn7bQcMgX88BNrTSVnTBEV66tUGSUt7wct8xR8cIfIXfv0XfJ7ywsV7UlfI0H
         /nfkWJMCa35NMqpaxx99MyJ9COlecXOxqZ5ankqImNGqHzsn1a11Yfv4iK36azPVM5Oh
         3qBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwDZTyDS8wgninHGYWRbrL3P1QCyrmslW5qW0rY3DHUs1S9pWAwLN0FtYPMRap8Dbi4Lkt1saTgA==@kvack.org
X-Gm-Message-State: AOJu0Yz4eHpPJpdRa7G5NH7I3mVni3Z1PJBb1xAGpwXloVH6/SBf0/C+
	pI+KATSpIs7cUzqoZWqPj1jkApfaTj+skI1G4zdh5VVwBbxHYFRKos7S
X-Gm-Gg: AeBDietZXLtrO5tm5R5Bv4yZPXFGjAcWC9p71yl4ZZh2BwKiE2qLWfeYf7DTfVjUyDK
	aUjyHuvDgU2zPadPzQXKF0rSYpYYZwHAL7uVM31Xqq9+rp5BP0Ut/+kop+e+tKnkZBTzMBNMhcB
	Hz4Wam7Y0NlLohJFxP6P890IwdAOBIMEv+xmBK/w4NMRT/2iXAiJd3rZDaWPXEjRlSMAN5ljWa4
	wqvNtGzA07w3SAYKEkxLZOZsqYbi0SBqi/jqXZnmq7IyaCxXnRBtzbkMD3lTaaSX6IqYZe0cAy5
	mFOXGjo2V8Qxe78J9HUkj0alekj7yi9+7mMtTMyLQFNkX35g+min7C+tdiVe+Y7DMzv4dDyhoYz
	/24vtEH1ZqFWulMeXdUS/0R0zOJoQxzUDU902zLra8poeqBc1yaDYdKwq7YjQ1PX56qodqs6zBF
	rA0VjundGaiXoB4o8f54eceqb84cBTSnXrp+EFbLkHLndCsp+BT96mkQ26RWK+GcJtUQvo
X-Received: by 2002:a17:90b:4b92:b0:35b:e4d8:e21d with SMTP id 98e67ed59e1d1-35de678f2c8mr19167142a91.2.1775637823840;
        Wed, 08 Apr 2026 01:43:43 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749ecbd1sm293654065ad.83.2026.04.08.01.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 01:43:42 -0700 (PDT)
Date: Wed, 8 Apr 2026 16:43:35 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, 
	Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: Re: [PATCH v4 04/14] mm/mglru: restructure the reclaim loop
Message-ID: <adYP81AhpNf0znp3@KASONG-MC4>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
 <20260407-mglru-reclaim-v4-4-98cf3dc69519@tencent.com>
 <997d5991-6935-49ac-8aa7-569767c4693b@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <997d5991-6935-49ac-8aa7-569767c4693b@huaweicloud.com>
X-Rspamd-Queue-Id: 2451EA000C
X-Stat-Signature: 6g6hsm9b55hos6axp5ifjzcgh73sy5fj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775637824-941396
X-HE-Meta: U2FsdGVkX19WlpvZkuFPYa8DHQ0UAfcNhvFZQvULfaCzDYNlmGMhZqce3Lli/2YhyG8L4zkJXiyMGpVbZzytLSNQEyyj6z3jlBU3hTwnhylrYHoCffyMlzG4iQLEAOV/ROhqx/PDWfit5aAVU0Nsi1PAcmmmTHV+3T1KJS8qyebkVlcO43UFdlkYEKxq8LPsirPXcIoLeBBtV04Yzc/pVcDCs+ROSSM1IE/YmdzsvD7StdLKx7tKV+qRe0iPkhKiIXPxxuWkK+CvCRpx/6zq6wBMpP8VGJgN83cUje6bNYn5mFYxjADKz0iOCCHK/kSpaNRZIHkem2f005rwfR0GpSnt4NiZ+Ciz+S4LzCmvnKnWilQPAJ1Rh305+9+Tml0r4zNeVq0lrneQFC95LoS+MmvQUG9JYAn6vl9+5Ql7y3hvAtP3lmb4nKirl4OlnKish+IPEJJ15Vc6vQY0CpZCCAqZHOPKAIhfB5jmWxGt8XnHkySaP5jzAAa2vzjZDTSA4ZIlzrcKD4d3BBQNsTPh9tz6Lzhhz98+cJTKtWM7Q+PM7lB3DDZZtm2+596lrgYDixk/f3pytzPOe61arxJfQIll6wh1T5GRXC/bMPz2TuRYz7oN/9IwGosbQ8RGWRyhH8V4cwiF9j424P+1Hmv1fgFsGf2z0XBvc20bVL5ubaQlBXWw7KDZv8QeM/PyqlXsGzwOPS5TCSi3oupZDJcZbFwMkt8ZbnFBXvD8PonRPeWNw2MPNUUunOEDHrLUJBD6T/v5Wqy/fawWkxkoOtFjB8Q3bX0eSaxcxbU0LTXj/+BiwoI29dAr1i4i/3vPmFn2lQgTXqQy0O1xoYJXy58katdkVGB8V8fKx7I1dUx6Td17G9g9kV0+JSyn8cJdrog0hB0gv2f6hxMzLitBNWJrkt9EtBYUpP3qTmeRMvzOkZCsACpGgN1sazQNHK4VC9Lq8SwTIYmq5C7WYSmvJJD
 sxVIVSYs
 Zob78yjn0cjgnPI+30IAaFoOaFJqG1IfWi3/0FPYrVjCCvnthy7b9dz+pvtHW4uzQaBKsKmsgIIJtrqEvpwB9NQvMxAP0GyaKV75fyOfrG2EHhpaRVj/kqiA4wDHjahBFq/+9nZXdwGmGglM1yJsGgcA1Cy3h0pDQ9R4Y5FT2Q05YQF0cDvzpsFcVMZkeNPXduX3vuo2t2yM+I1rDZJw54J3EKKZ3A4PK1rCzrzL0cCaSj8OFkrDXRUBIF3BN5N9dd9jUqeYazSC9dfhpnNS1OWG/+W01I8aBa4WjIMF1adn/u+X00j5ORaEwnHoAtJ/tLu1fPQVqt8hR1FnJ0PSwnjlT/uKb0Dw7rtZ/qnti0n6oOElI8hDOlVS2t0EujNwVG9WIUeXTRNPm2mL3O5mRzpUF9KqjxRSinTnVISa+eAq8z9TB1dvJ9sdnMmz5wPy/fsgeidbShL4haSaTQ+5BcgBbIhY+zdKfPlB1P7YHngdyNNC9pXvrg0H20E4g9HCRekeAuKcJ66lZO7sMyo7iMm7Cbf47RZ0wx4ddq/S5nuGVR9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 04:08:05PM +0800, Chen Ridong wrote:
> On 2026/4/7 19:57, Kairui Song via B4 Relay wrote:
> > +/*
> > + * For future optimizations:
> > + * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memcg
> > + *    reclaim.
> > + */
> >  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >  {
> > +	bool need_rotate = false;
> >  	long nr_batch, nr_to_scan;
> > -	unsigned long scanned = 0;
> >  	int swappiness = get_swappiness(lruvec, sc);
> > +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> > +
> > +	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
> > +	if (!nr_to_scan)
> > +		need_rotate = true;
> >  
> 
> Will it be simpler if we return directly here?
> 
> 	if (!nr_to_scan)
> 		return ture;

Looks good to me, I used `need_rotate = true` here since it kind of explains
what is happening better.

> 
> I wonder if moving the aging check under `while (nr_to_scan > 0)` can change
> behavior when the scan budget gets shifted down to 0.
> 
> In the old code, once `should_run_aging()` became true, reclaim could still go
> through `try_to_inc_max_seq()` instead of being gated by the priority-shifted
> scan budget. With this change, a small lruvec can skip the loop entirely, so a
> lruvec that needs aging to make reclaim progress would neither scan nor age in
> that reclaim round.
> 
> Does this have any observable impact on reclaim progress or reclaim balance,
> e.g. by deferring aging until a later retry / higher priority and pushing more
> pressure onto other memcgs?

We also skip aging unconditionally at DEF_PRIORITY, both before and after
this patch. Scan budget can only be shifted to 0 when the memcg is smaller
than 8M. Seems trivial to me, maybe I can just restore below code in V3:

if (!nr_to_scan)
	nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);

https://lore.kernel.org/linux-mm/20260403-mglru-reclaim-v3-4-a285efd6ff91@tencent.com/

Was a bit worried that tiny cgroups could get over reclaimed, so maybe:

if (!nr_to_scan && sc->priority < DEF_PRIORITY)
	nr_to_scan = min(evictable, SWAP_CLUSTER_MAX);

I tested the reclaim balancing issue using selftests/cgroup/test_memcontrol,
all looks good with whichever design as the cgroups there are >16M hence not
effected.

I think we might be over thinking about this :)

