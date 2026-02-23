Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17521EC1109
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D966B008A; Mon, 23 Feb 2026 11:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DB76B008C; Mon, 23 Feb 2026 11:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640716B0092; Mon, 23 Feb 2026 11:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2C36B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:37:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 065DB1A0242
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:37:03 +0000 (UTC)
X-FDA: 84476275926.28.6E9B87C
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id E903D40003
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:37:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gWGWOcv3;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771864621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzArJKlU+ASYCguYb43+yRgFO3yBr9sECL/9qGjk+Qc=;
	b=OpiS8k0n37RMCCOs/mDEphjPV3OQPmxQWjjI7LpFx6XXU8OYVGZJ8DRJRp7XwQKIL1QKD5
	jxm1aZmedZl1j5ICTcwnhGrsBjYQoOoZEgZOLkQmJL+ZYQXBA6x4cGZ/skeuvqaTrHavdv
	y0X5ILNQg9JSM7xe9Q1WQiMTRTvvPKU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gWGWOcv3;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771864621; a=rsa-sha256;
	cv=none;
	b=Pw9UXy5ol5OV9HSAkNJPugFT/IBYL0LUweIvt1gF+jT3c5Uy3nmEqaPK7yv7te+EKAJ0Po
	6bRK7KJcBqf1pm51uRJockA37N4jqXkaQhxS9jKSMZTG9fbs90l0a5ZGRsEfR76Gi/gULN
	lfrxXGORVJ2wJrUYgy1CR97qljRJhVg=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8cb3e22435fso451167185a.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771864620; x=1772469420; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WzArJKlU+ASYCguYb43+yRgFO3yBr9sECL/9qGjk+Qc=;
        b=gWGWOcv3UhyMv8IYW3dD1Glcrq4a0486M/uDTGtZlwrZBR8b9QjNctxONssLgis0di
         Ad7S+HtmjeKjN4WhBy3goMtdEAY3kheXWNSlHjJeBfNldAseg8HHkcE/hlb2tfabqE+K
         Fq1SfepNvqrTT/nntbjZT9mJ1Vk61c4Pe1dtEZR/3xQFlvYPBENIju7zq3wzgASPsSM4
         Z7owVTsSu7gWrmBvZMOk1ZjxfEQ14UaZ2wLS0BrcaqxbZ0ZGvDu2edUQUG7OzJtJTeyn
         +mOBGoJ0D0tyfbneX2EaHMZ24+BjJtCGRm9SW0tiOHjGMiOX2bOb/xGFVSD9jhjTfI1P
         pb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771864620; x=1772469420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzArJKlU+ASYCguYb43+yRgFO3yBr9sECL/9qGjk+Qc=;
        b=u9UGT/oOwzIZecTWYrydZtfhBwtZVioAQOQW1nZhVTs1bU+qVfzcdMcZJr5hhos3k5
         4yH0lohZ7HmlWHwoONl91hz+jk0H1JtzMSRWyWo4GARJW8qxXTZTUjWWJpx+Xw4a1BK1
         EcS3w7z1ns3FbmfzqBoRNjuPukie1v5nZiEWnHHoq/GlGow1/QsJKd+qFeXrIeKEF41k
         UALFmVSpIxQhaFvVPsKCW1gyUkGBb8yPrtNtuhGaipIfkA1Hh/dmv9+NYOT/Q5AbJtbo
         UiDvD2dXeTZpC7ELPWoUvNDSlKA3+JXnxWTwm48TdVZHgdZYtKkkgtPSQdI2U3OrrSk8
         TdTg==
X-Gm-Message-State: AOJu0Yz5dF3QWZAjjfjsE8V+MtI1JTopVndIwrOItjHcgK8HBE4kDpkJ
	MrHvrYny0OOZGJ8DDInAefVEkXZKMSJktDM1f3wW5kUL3GMMIl3YSpag5HOF632zmeg=
X-Gm-Gg: AZuq6aIGXNvnfoZ3BVLlJGcZvY57Uiqfu3/+jm57ttjKwP5QFmZ9ZsKZN+6XyqkAfSR
	EldhFd4S/skZM9vwoQ/NtWRywe+ec8qD7UeBuyQfFbY9qLcxWtZqAZjji+XHNIMrhevEQgMduzy
	nIxLQRfo5s1D7t1ZzzlRyllDxHc6ahIaqKd644MlSkoOQ1/bQs6bmVcCrhFyVr6HG0kTvZb7Nx3
	64mdf866PQF1Bx2qdQTpXoVtapIJdoPVYsGakKfJi8DrNqxxV2XwHKR4GPqYIk8TjTUUzyDdV9D
	JrDg0VOUp8j6dSnn1/RMlKFgq0WWqV/edfFGClg9MW4iLbnnJCnfKZK9/n3wDQbDkvhIsPwybk0
	jm+ckzxtoK6UZpmKMhzfJdeib+g0IGwuyyRlwgGVkpn0+axwUgtWCNyM5E7QIvveCfHkaZyVQvc
	h/MYDn5jLsS4WlwbjrjhO5LQ==
X-Received: by 2002:a05:620a:472b:b0:8b2:e17a:17e3 with SMTP id af79cd13be357-8cb7be3b84fmr1746011685a.1.1771864619752;
        Mon, 23 Feb 2026 08:36:59 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8997e7747f0sm72340136d6.51.2026.02.23.08.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:36:58 -0800 (PST)
Date: Mon, 23 Feb 2026 11:36:55 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH RFC 08/15] mm, swap: store and check memcg info in the
 swap table
Message-ID: <aZyCJ6pH4hey-ZoU@cmpxchg.org>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-8-104795d19815@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220-swap-table-p4-v1-8-104795d19815@tencent.com>
X-Stat-Signature: zwgk78antgetiuw99symgt14qhpqj8ea
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E903D40003
X-HE-Tag: 1771864620-325484
X-HE-Meta: U2FsdGVkX1+otcK4Lk0qPuOZIP3WDE+bXCBGO/9cvWhd7Rb0cPqMdG9yFb5Qx6trTqVO0Q1zmR5OHZxgdtBum4mo2FWlJTLErTbvmOA/16ZfFfMUWgjW+h81sF88ESTCipYPkB44PJbcwMKxtoP+N2rbU+t2TL44W3LLGnmywNC/WwrPHfYZILqGxJWZg6l4tj4oCXybeERotk6w9t2bdliqFHdcB8b59pkG//5P5RNdgRhRO62JQSt9fSGgPGMQkIyXM99FY91cwBIUYWFcOwuUNq9faEQkpk40DunW8JZ+n0F88uArceDAWvqMYdW6VNCp0vuAnAgTVHqn5M0fgX2+VyFbnqlFg9fBBQsBFNLUyLXJA/BScndURg23Ow7TNLnAYS2g8DfGEE76KZHD3Ao1900d6yuArBTBcq20BhiV2vv+YHxSXEA/qT2/B4rIE+hGkWlBuWoOYm3Z11Z9p2kf86amSH907bF7mLfLR/cWZANI8qb73HEnXdBbKu+qM7RtIXLotAO7HPe05wJGiLMZUMXdKK90Ji34Kz8eYi9Ix19CDY+GRlEbGcV2LtmQpEITq7lnMUICFjBNZKabr9BWrwuCSsEqHpywaba51ejS8l72fMNiZ7PEnqZKJzJSSzVlZugyBjVBvQj2NM0+yCuyA8kC0xhZtdTLv9mpOP/4TEgDHOMVBC8AZLCsTG6E8NrztMwXOiwly6Ddl5fihP+AFSA07OnWrZfKTrDwnskaVlPAd5ZAZ7e9GNR4srho14TA/wJsgCvgjqZqt4/GORXM0zypkHwojSEr6wrHAdU3368Qg//wIyzN9jJiRlA1lfTxWGgMeK+h0yrgnIMv/kUrGtKthmOy6DZUD2LwyXyXiQvr18l/rKfPF9iFMogxZHGAW+wzHDMisJMXQjmBbxkDdQHR4CR0ITroRmZoRDdIQzfxGno+AOThzlLPIfqvzMwE8oB9eVj+qsvykxV
 qLTtHawN
 Sn48d4PfW+sr3EHHjZM22FR0FBXqRvoI7QmbRb3MJxPHz0mTWpVkiH4maaBqlAXz9cGTuk3g0sd1NDXnJRCY9nGVPNox18zHMq9v0kGBPwaa4jF57bt/83nHpzXlsjbhrOfJxWS///nfDc9Ya5NVqDLvO8k5lhml3YGEBm1PMxjGiSMtOcT2Yc3LuQCi90YYFfDsw4Ak2ksNrXBW16JQagnnpde5v3p5U3SubLQWSdj8z7HIghlHfTJ6wiZNr5bgENikDNLSgw07f+bnkU/qK9/9Zon3m8f1IyitN75xzJ7O2hzgosMk58xnnXEEHAWgzuGrZNWC5o3qUgSguT2YZcLCXMvsfO1vHF3NAjyoGsR7wojFNeXRyS1Lu9Li79cuUOSxz5zug8e2YSsCEwdx2G6C3PQKgqlt8mAZeAIDkueorlI1ZXqU8GH18j7LhmSyyE8XvBMjgMakgrpHqsbtAnk8UPjtlWTxskMOCAuxVd2SwqkX/y6YrwmXQImfEC/uvrVKjS6WA7hcToA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 07:42:09AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To prepare for merging the swap_cgroup_ctrl into the swap table, store
> the memcg info in the swap table on swapout.
> 
> This is done by using the existing shadow format.
> 
> Note this also changes the refault counting at the nearest online memcg
> level:
> 
> Unlike file folios, anon folios are mostly exclusive to one mem cgroup,
> and each cgroup is likely to have different characteristics.

This is not correct.

As much as I like the idea of storing the swap_cgroup association
inside the shadow entry, the refault evaluation needs to happen at the
level that drove eviction.

Consider a workload that is split into cgroups purely for accounting,
not for setting different limits:

workload (limit domain)
`- component A
`- component B

This means the two components must compete freely, and it must behave
as if there is only one LRU. When pages get reclaimed in a round-robin
fashion, both A and B get aged at the same pace. Likewise, when pages
in A refault, they must challenge the *combined* workingset of both A
and B, not just the local pages.

Otherwise, you risk retaining stale workingset in one subgroup while
the other one is thrashing. This breaks userspace expectations.

