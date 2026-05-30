Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FACCD6E51
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 02:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885666B0005; Fri, 29 May 2026 22:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D6B6B0088; Fri, 29 May 2026 22:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A9D6B008A; Fri, 29 May 2026 22:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1336B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:38:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBF491402F0
	for <linux-mm@kvack.org>; Sat, 30 May 2026 02:38:08 +0000 (UTC)
X-FDA: 84822526656.19.F1D65C9
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id E0E8FC000D
	for <linux-mm@kvack.org>; Sat, 30 May 2026 02:38:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SlPSbHli;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780108687;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xka95KubKnbbs2owwDRl8KytmLnYPZfdx9pjSujQuJo=;
	b=WBV8IWf6t9Ze3gf6vv5bcH66IYAGk/Jd1a34jz5nZQPubhv5QEZ777KNIQeAgS/0C+6rVR
	1Ab21ZH9rNSAGnGmJNdA7Cuj9Cus7jOi2q9B9CpFJALo+tu+x/dXL6khd4cEZzjwqAImF9
	sOgjBey9jmJGRlT0ipXLDjGpNd/6DZo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SlPSbHli;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780108687; a=rsa-sha256;
	cv=none;
	b=lNNUHwf/z7KDKtlgsgLikJIrFuZ+PVt+vwX3zKBVbdsuJEPgemAm3PcVPR1iSr+nUBI+9C
	zqGm+mDL01vuoqTZv6Vt1Jf9LzLkxDSve1GHw/cWM55ShCaJD2GmENXhRpkK56aNnIZ+4e
	FrNJX/1b06qI6ayT5tmmrAKrvzyYVCA=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bd6460b0d11so2526053266b.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 19:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780108685; x=1780713485; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xka95KubKnbbs2owwDRl8KytmLnYPZfdx9pjSujQuJo=;
        b=SlPSbHlin+QfTK6Mtmp5Rj2VmVkvQjYLaucYig2zPIhgyRvbJVUbM8XKXl5JHIbQBI
         9T1gRQ8bYa/jji1B54WNI8+ig9gJNoqrl37rwQYYZvqICKkhr/zPJaIbaPPFGZcB9JQY
         W+zqOWRjOlUwvt+PlM7AiQ6kGh20gYC+TlV8OhlhVQaeLodEQtWHC4tX1FnPdlddMhLL
         OKiFWlyc6ByQjKRHzXPVyxt69R6LZ5bg+FuPOTpluQ505vdB5PcAgj6AOlMk9NCYODD9
         Ll2xYeEnFjHKysYnuVCZA4aagY/UY72yeIEMyQ6J4A8PV8DPfncH9xxVKB1KY5SYc2oA
         74Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780108685; x=1780713485;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xka95KubKnbbs2owwDRl8KytmLnYPZfdx9pjSujQuJo=;
        b=A+/T8pd6DM0giK58+rEOSDWDJ8FPjhYB8clvSNI9oKel9UdeOVR5LAKSFrs4qXTQv2
         HOPuoeqkGSyt+Z+tSjoAnyM0QhRIYR9vch1Iy0SLY3l0yUWGxPFBtVeoZHZmytBR6VPQ
         VJZS6WWn5Hpt93VrwNGK0THkqru4o85MGWT2vdGv8yfAPJrfwg3lBYer2sCBHtcFL+Cf
         SEnfuXERqLxMgN2TBV7FNKl4WBc/3UVQA6xeNtoA4vY39Tk5NpRK8romfJGzn4bHYbSX
         Fyg4ySH4WeGY4sSfaaZThXTCYWpwV8x/PpniHKU7LLVrF8y0uF2T+fSnDBae1gXa6y2y
         HiQg==
X-Forwarded-Encrypted: i=1; AFNElJ+GmD0PCyMlJ2b28ihGspBB3o986Qd89pz+NtnOR/g/oNkf2rWmLEaWamvsBQIi5PvrLymb+3Wolw==@kvack.org
X-Gm-Message-State: AOJu0YwGmSjcYVMZh3xg5Jt50gGy4Z+Y8Pp0LtxR81bNgJWv5/p51Mx8
	E+4qW4lalipzJkWLFI2jWRJsoaiNvz4dUXoVjO/QvOCMMwcroxDRM2VN
X-Gm-Gg: Acq92OFp3uc5+t9vA5ZD6noio3l9B9b/mZXoyKrinQp1gF2FONP0+9IqPTJN3fsdPPN
	T6Uenxtm2alHeMtu2UTaA0zOhdToHgv6xviWXSC1iSFGqWmbId7GxrSvTA29sO1/o9zqkFAyJKR
	1zaoj2LVilITd/Nijmi1UZT8iqPV/ALKdFmhzVwwN/8CSBqhxuzlVIxMi8yxzi2M4T8dDjAxkDC
	WKBY7acZi45u+8qeeW2EJw6aL9GnwukLTj6u32e2Za/2hEr+QyGiA4FeSn1mOUZWWdtwBeohPqw
	20jOOHRYQ4nE82Pr0CkwY8QOrLJTueTP5+xUj4qd/7sEKzbcLNGoX0+E2K3XR65RHeGACotsnNI
	k7a5HAl3FhZW9I98bNNhssAsCKBEiwai8zlImm5Wyod2JNxEUQwUXKzrfZR2j5j+pmK4z0QcXdn
	OAy5W8q1FIb6zAWO0A0rt1Il2JUcOVy+ZQ
X-Received: by 2002:a17:907:d9e:b0:bd8:1c88:cfef with SMTP id a640c23a62f3a-beab394bc61mr117829566b.5.1780108684896;
        Fri, 29 May 2026 19:38:04 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-be9d5cd7b15sm118510566b.39.2026.05.29.19.38.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2026 19:38:03 -0700 (PDT)
Date: Sat, 30 May 2026 02:38:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/9] mm: list_lru: fix set_shrinker_bit() call during
 race with cgroup deletion
Message-ID: <20260530023802.l5f6ywulxl2bpafg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260527204757.2544958-1-hannes@cmpxchg.org>
 <20260527204757.2544958-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527204757.2544958-2-hannes@cmpxchg.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: eee86ik9ksqcnwfih5zkzpnw8trs8ga4
X-Rspamd-Queue-Id: E0E8FC000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780108686-67663
X-HE-Meta: U2FsdGVkX19kMYE8Eds3COijWUtM1H/MGweStBFzyCS1hIHOtDLvqt2AbCEcMb9RJGym/57Ae8YxYJJPDnMH6PxEBVXgQ3FSzF3djea5AsQYU1OonF4TXJ/iTDwP1WBKSnDjqmhYKANq2S9y6UDZ6k3xVJdkZ68cGv4voe1zC75SBYdHZOJC4Byw20C/3M4ad0g3oWGObmGiuvIHtVGJPeixJ4q32fAOZk9dKdEH8QdbgkPef82Fhu8LQsOTZ9XxmhMVsSAvD000glxF4KptrbNMkF7DsLiZTCJOMHwJln6Je5j0myQUWvB8MoLbn8pWkdOpJWyyk545tdkyG3vimTfByLb/l/EaVfh2RlGAjQyItfRELAc8VR48AkY6n/yxztPJEaWUO9tVmu6DrlMzuTxOZQSl3y60u6w9GIARij0WoZNpCJg5GGBxNcpBiNb4r+L9j2B5h4FhzQOJLodMpYg5AoJURENdrmv4NZ0sG1gSpNAWmw56B5HRnRINlvLisanSvRfCShTDJTq1Wx3wmbgkRfg4koUCUceOeIREL5MVj/ydyZo7RsB6/Bm5IzYgcKwbcw0lpwbJsgWS/S/s1NWgw+COT/0w2wiEILvj73K0r8Z5eGg5QKBDJzemYhVy1oG9kWbUkEub8Rzu2xp/qtDSPP8IwwivF/4v+ehFyHj9XkIl+504OR2qf8Inp5ApfXXQcRVTzUjmMPBHXy15NKS4F/UCea0beo7NTYVOYJ1NNJhdp1arY7TTMKDFX2iILsc36YVuuiApRISzpn9EZL/TkHYnVuyu7p0RK1oNImk0tUvPy47QT+1z4zTM+n2IulW6CjUKUk2zi7+/jW/dvYqP7jCH8XIq9PYhScqldITG/g7tsBYigOVi8znZ6czpVCM1RKITplZyX2FDt4d31pkrLR1I5BBj6kK6TN5ymP0hicMtcj7TDfAAVm1fpD+T6i0vztmJdHuAusdH2li
 Ng9BI+1l
 F9BpJIrnPDxHchJBFODaymxErrFLcyGsDMt6A+sPglQDqB4Keo9+t/LaL4qS17ChFnqtMAbLNk2W8C6zYpObZbd62pzl1O0dHjmLHM+EGcCwPVJh4lLt27mjGhsDQcMmZ3Srl3AZAbQD7Z860srsDYaa+eAB4KHTS7+WjrDtoDc4qhETWFdFQDfxoeEsgxaIL8Ag8l9PnOiVw7dUpe2xspcCUuRxuseE6kecLcF9zyYMJMPsd5QVShGGogphZNBSHV3ywJ2jxW54ETxg7sMXG2ho+9EB+NUFAbCdrVO5GGnbopKZsWKyn8B7a69S9R3G7THiDxErgxsAZva+Lc1kOJ/CrEcveOBkd4LihXEP8bry5ktsMjPlcvs2BKnwpNT8vCIZh6fqgoQ8LNujab0sGuXGRLpyHGQF0h13qfSA5d7jgtPJEmltIxy2fHM/JOZuC26IajUm5VYx+OE+YVL0r2g70YOeKPhAtkC5TQyrMjDOrw8qASedAIo/BjErjlU78WEDUv1OahRlEEjfzbItaQHkFl2K7CIJ/miw6kNNsnCNHK+m3AGS26nh5FxOo3+XGLavu3sBgio7TIFLklpw54kF5q8Qu1yfn3XQV2x0GJOBx/thR9iW02oxJwZ5C+iFeenD17UyhppNUPzrwLzlStYKHXfbDBV8ncaUwuBKRGNtTq4ZywZRd7XdcGrN7vgBGE0OTY4PVxqv9U618JyEdLvulKspE+nsIt66MdqjJ28eW7Ywg2MBTYslSc/YV7uYj2lzhmvX88PNWDbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 04:45:08PM -0400, Johannes Weiner wrote:
>When list_lru_add() races with cgroup deletion, the shrinker bit is set
>on the wrong group and lost. This can cause a shrinker run to miss the
>cgroup that actually has the object.
>
>When the passed in memcg is dead, the function finds the first non-dead
>parent from the passed in memcg and adds the object there; but the
>shrinker bit is set on the memcg that was passed in.
>

This means we just miss to reclaim some obj, but won't crash the kernel.

>This bug is as old as the shrinker bitmap itself.
>
>Fix it by returning the "effective" memcg from the locking function, and
>have the caller use that.
>
>Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
>Reported-by: Usama Arif <usama.arif@linux.dev>
>Reported-by: Sashiko
>Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

So we don't want to cc stable, right?

The fix looks right, so

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

