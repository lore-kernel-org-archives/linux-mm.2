Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97DCC9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 00:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 294EC6B0088; Wed, 23 Sep 2026 20:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21EBD6B008A; Wed, 23 Sep 2026 20:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF0D6B008C; Wed, 23 Sep 2026 20:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCA5F6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 20:27:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3943F120158
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:27:10 +0000 (UTC)
X-FDA: 85246766220.14.A8E08A8
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2732480003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:27:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VHHOWGFL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790209628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6WrRa8X4LwIKolmxRxI8EL2z5U2C2576pcH4SsNYg8=;
	b=3gBFWWCP++35LUCbYBNWlA1jUBuRcw5zfFXMGFh1Gg9qw1h94mYdQljFNnmg5euazoPAvM
	SLWQ1NlNHURCXVNPolAQ19NaQErq6M78wrTK7zVZcNyPlG63Q1cfHd001+NRjYMfk7DT4N
	rci8cTRVtZisVB/08KSmi6aU75uErso=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VHHOWGFL;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790209628;
	b=OpDKHLyUlDTy1pIF3zT2WKW0EJeOz132PR1B8TB7KzVCXmS+LAJKxNY+QVivvASEGEbtIc
	/zm1xxhHXb8uZ6mFTezmnn/kDOo6rpelTU1AnmxZAw660N6Eh8wem44cV3IXXpL6CylqGQ
	ZOg0VAHhMxrRvRz0YiF7LeKg7yQWYyg=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-9104649a5dcso15222056d6.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:27:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790209627; cv=none;
        d=google.com; s=arc-20260327;
        b=bUikmRIZ9YneKyCkUEw+y6rtLnfIZ+vJg5tmYVP2K2wSLZ2hlfO+KFrJ0FSries3pW
         OIpLcPGlHk8c+8BvaVYpgp37w+D8cDmzBTYEYyA7NpSksYU7tmBeVUb2tDaMzVVfNMIa
         3OhhJ6mTwfLUmCyEbefDFsU0B2/q4Z8621cXZ5hokvIECrfKGpYFIuae79uUmBM9UbpP
         C+V2y7U2hzQ7p6bmlJBO70k8eAiewBoGRNOUIt1jpbasyyXhWGkuoXsfM8uhghDailkx
         lFB17LCfHMixupzXXKt5AFUFrO+zgcDyhw4seuRaDI20K79lCqdyVfhQNBapFuRikn7Y
         hJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=r6WrRa8X4LwIKolmxRxI8EL2z5U2C2576pcH4SsNYg8=;
        fh=poLvlN/Dl3d+BQxUoilOFKB6CU4YHNSL7TiSQuMCx3Q=;
        b=JikCP6+qTLXzflobglr5D6ZbG4R3nyB2hHC7uT/rGj/KHOeeHV89qoA9JapCsqnW2Z
         Ao6bfzD6zR29c35z87drH2iCovC/IIqDS0XK8U0TFO+2OBlpdh6wiIES+mCwcj3PboOn
         RxO39t6dduU8l4515jKrO/h5ce03ffmw2yoyntQVrKGRna8g8G3tvn0DhWMmGceviN8E
         e87cfZNHrgdDEIlFPS1/0NJb5gEgxASpm+nAZc8ETXVibgubLw206uQcy5rqbte58Kyy
         ezcLAoU1jxcjE/zchTphR9bnLgfymeuR4Hyrk7zp0DofSBhL8Fwcj3luSgSrDZZM7d71
         cQXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790209627; x=1790814427; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r6WrRa8X4LwIKolmxRxI8EL2z5U2C2576pcH4SsNYg8=;
        b=VHHOWGFL8j3DseKm9JWvFZBiKk1OI4dJq4nibZu0H3j1BksU8XkHwYy96IJ5Fyb5Pb
         wkCXFeS9bAr0KrlvisJaMFRbc2vNE/uiPoH14lxL39yAULPyXyxPn5/497rFs+cQqTSB
         F4uNjHCpYH8YBGQkmcMADzVvkGCZOzyYLJqj/GnegoP5vjdMut2K2/zIoAbZXi+PPQDb
         81741l2GJiFg5oTMVp1XijmoICdKeLjvR8cbTcftpTnpFPY3UqYSEJrsFgO1363l8zeZ
         c2Hdr2tQ2Rbfp4AEMCuntW1r/ZwNNziiSewzGs7WK2UruUbpZAvn9m/0VYBzf+IJPehV
         tc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790209627; x=1790814427;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r6WrRa8X4LwIKolmxRxI8EL2z5U2C2576pcH4SsNYg8=;
        b=wNfA0y4h49C7gDyHxWD8pwk1N+oMFFDIsjJZ+vikvzI8r3ClTB02U4dB0z2dbyI6W3
         NeRGzaF7Dct1lw+1SfBUf3EoMiMwjRu2PZdaQ+BsGapA+s5vpQI09E3ENPEoKyWQh6kC
         tSVyNkowIJKHwJt2XGE5TWYk+ph+4bc4ApUPsTfwkleCSrzvFSoBCnpdz9nrGyDIvphV
         jsJ30LODN8EveVrYs1HIqKDuVL61u1P1Y35cL8Pm2YFINEGg4HpryMFiXg4V+uhPtfgy
         RQnfNHTdSTqDCVWPR7JZraSdJVfayHBpBLqukVbUzQDKingYhoIdcwFPar0jOBiiAwzw
         3JsA==
X-Forwarded-Encrypted: i=1; AKwUvBzb6KGvIZMcMyvSOKlJF6GQumsQ0jT6z4n9rVBzqCe5Ne+8tbszIIOd80YFEt+pO/QlC/7zXWkkdQ==@kvack.org
X-Gm-Message-State: AFuF++lz/s7H29re+9qi2nS7LbTawLkKvpmF6xNu2dudf8kz5fZiHfCK
	uv7rHiVknM4o8a9wlrKZBnUR0JGaVAoXohj20JGNjjCZqjRHp/1ctCwJ6VpUJeZlvcnSoycDVhA
	dhba935pManqS3Ep/rzgi5JdeToZ2LFH8Rx6YLHuo
X-Gm-Gg: AYBFou0UdO7sF1CTXRXuHrh2VnqKVFYTw3vt8tXhEV8lTXIF5L9L3XS3xZUC8wLqEW8
	upBxMLxswY/fUD2S4Q9Cre10eA+gZXMVORzpIBB9xB9JSsrE9MlGJc9k63tSDxzTtKwfJomSz0J
	TysJ7f27kcqyEdVjPUpfyHqSJfi6NuR9EYHJcByN19E5y94/08M9z/G7cFvbRXKGbExwozRfod1
	cX03JOVnlnVYjBHoE+Ik7I8LNvU1+hdaVtH5DWw18vpMfbAoas0x2yvg6hNHzlAEL/QhaTNrku4
	qvWkuJJONvhLk5hi2HsSMqgJobKP19L17YeQlj61t/mAxLtHKQ63IqChN07mqgYVdjilPGNsvVU
	AdfLCm49aSMywBy/E7iNRgFoUdZGXalNDQKdUreZqgK3vXn6vAVfO
X-Received: by 2002:a05:6214:4908:b0:912:5a5c:780d with SMTP id
 6a1803df08f44-91421c7b50bmr1075226d6.5.1790209626640; Wed, 23 Sep 2026
 17:27:06 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 23 Sep 2026 17:27:05 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 23 Sep 2026 17:27:05 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260923220912.46905-1-kmehltretter@gmail.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
 <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org> <20260923220912.46905-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Date: Wed, 23 Sep 2026 17:27:05 -0700
X-Gm-Features: AclHuK9WI-ITD8-bQR_EogJlGkU1PbBu_FVIl6mxYc8DTRj175UHw6OErcti6u4
Message-ID: <CAEvNRgHZTYUuFBXS3sGyyjiveQOeLHuPxvud8o+R3NCCwM6Ukw@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Fix HugeTLB subpool used_hpages tracking
To: Karl Mehltretter <kmehltretter@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Zhao Li <enderaoelyther@gmail.com>, Jinmeng Zhou <zhoujinmeng@bytedance.com>, 
	Alex Shi <alexs@kernel.org>, David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
	jthoughton@google.com, rientjes@google.com, vannapurve@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2732480003
X-Stat-Signature: fmoi7nz9k3rdpp5xi9on18z7jwkduest
X-Rspam-User: 
X-HE-Tag: 1790209628-246584
X-HE-Meta: U2FsdGVkX1+wIMV1oDT98cCHLbnHIypPMez1cQNFKata/uiSvDbIkWl7S7NZ+z4U4Gbss+P0itBsHlRDzLKjkU87SyabF/N32HEaLmUac1hhAS+EXTOXoGkoXe2CYZnoNVwTaWNljsAhtIktc3TEbToqk3tS7BCDMRWQJABlvWPvAV4Qipxb/9PiWTHMf4/AmvtmiCXL/FxbV+gf+w4qHBJ7OE/2q14emTal1lp0YFZGr9dwBAY59RQ54dTXkxBBGKqfkX0Sgq7mDPnG3icO2oXk69fj3vyKsOMxcG6VBcmyai36YwQujw7fYp7xlFlmKdLCsr8T5vgMos79baZBN3Hmc6fQJiNJxOBDtJvX50g3b64tcdULjqTK8O0hf/1/duLlC4Is87L4vmdu+hyfL5/fnrGb35l+gtcrfd6vA35joQQukMblqki3nCXE2wOTEmT+YqDDr7dPfUV8Pg9u4qsZUoo0usKivwd/iWNLphPPpWrD63UXjvt9un9BkqAtKRS8fEzXDCwc9fk3fGsW9p56s1pD6V0SNurzEx7euByPIL84+h720LeiwoEeHOcUjl3kneKcDX8xZsKAWqL4mFWisrJqyAvPnG+H1LNE0TEZtrCH1sgFH1cIuvksYS2P+oTIDDt6t9fOOyqISuzMgbWT9aPkEt2ZaTuE0rudb9TPdnWmlx+++JnrmHv7VQREgODLD3r29JStVRd9+lbzocdDbis1aR2rjPRIUtOabSVrDi8wW2IEeweiouB2IqqGhwXfpFSUdv4YIxPrHK7bBj4FoBzut6eWkaKcHZEZdUGz4bOLhoQ4fwpBYx6CCa2JWAF88GvntJqoMr64Dzpf8stLs0bd4Q/qh+x194edcijrl9hFCh2YmxdaMsFQkko2i3edULH9Y9+reAm1jp4JhNKSHvsc+hdRny7cvAXPLWFaKfkV6CXt1/f9qsY5WeVChM/eNMS1JXKWkJxZaM/
 cdmZHUPM
 IXWANMJA6/HtGqNTQ0nknnGWed601hicjSLorEceNZ4u1CW2ND3hq23AOP4GDJCtJhh5ZF4Y9j7Kseprg+QEyRNIUm1K1vufHVCnz0L9BDbV1vONsivwM4/7sWAwgmJViyI8w4XqIbI7J4NgSYvWJr5Yd7PWCrkbq+H2w+XxwZ78PeCTgDMCqYkt3kR5gG6n3jXf/LMB0oVXcvPMCkTWQAQsJR5oRpeYBz7QpVFah2VX5ellTh5ZDdOJGIUz5X7H64qT5GwzSe251Z5iOXr1z8MA4mYkDqlvtSq3bJIXTWp4NL2nEmUnFeIcRja/BxR4kxGPdtHCw/M/Qkik4gkDqfFwBbpQx34L1FbrxObKXbgcWWkq0Kgpb02r3JcEf2IFa+2rn0aXZgl3d3vQ7YHXkQnsTrM4ycmrmE9OFNHEwCxEz3osIxIL0PxhQtwVkg0TWKJBPsKtwDzw1ylkY1sAWblUejeWeDh6A9AKY67TPo69/Mk4XgOBn1pVEL/DKjs3pv9P6XpzcDXAehgGkhaTo5nnTk/6U2eixl8k4kKad7fHCVj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Karl Mehltretter <kmehltretter@gmail.com> writes:

> On Wed, 16 Sep 2026 20:13:07 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>> So if downstream people (-stable maintainers, others) follow our
>> recommendations, some kernels will get two of these patches, other
>> kernel versions will get three and some lucky kernels might get all
>> four.  Are you confident that the patches can be split apart in this
>> fashion and still produce a good result?
>
> Two things I noticed while testing this series on v7.3-rc3 (x86_64
> QEMU, one CPU):
>

Thank you so much for testing!

> 1. It overlaps with two fixes already queued in mm.git, so I've added
>    their authors to Cc:
>
>    - 3/4 rewrites the same out_subpool_put: block as Zhao Li's
>      "mm/hugetlb: fix max-only subpool accounting on
>      alloc_hugetlb_folio failure" (mm-hotfixes-unstable), and has the
>      same Fixes: tag.

Andrew also brought this up on v2 of this series [3].

>    - 2/4 rewrites the same out_put_pages: block as Jinmeng Zhou's
>      "mm/hugetlb: fix subpool minimum reservation rollback"
>      (mm-unstable).
>

Just took a quick look, this fix doesn't address the case where there
might be another CPU that updates subpool state. In that race, the
global state will be messed up.

>    3/4 doesn't apply to mm-hotfixes-unstable, and 2/4-4/4 don't apply
>    to mm-unstable. If I read them right, the queued fixes only handle
>    mounts with size=, while 2/4 and 3/4 also cover min_size mounts, so
>    they would probably replace them.
>

Yes, this set of fixes should be a superset of what's fixed in the other
patches. My vote is to switch over to this set. Would it be okay to drop
the other fixes from mm-*unstable?

> 2. On splitting: 1/4 applies cleanly on top of both queued fixes, but
>    in my tests it made min_size-only mounts worse on its own. As far
>    as I can tell, that's because it starts tracking used_hpages on
>    those mounts, while the two error paths only release it after 2/4
>    and 3/4.
>
>    HugePages_Rsvd, expected value in parentheses. Q = the two queued
>    fixes, wrap = 18446744073709551615:
>
>                                    rc3   +Q  +1/4  +Q+1/4  +1/4..4/4
>    min_size=4M only:
>      SIGBUS faults [1], no files (2)  2    2     0      0      2
>    min_size=8M only:
>      failed mmap [2], umounted (0)    0    0     3      3      0
>    size=8M,min_size=4M:
>      SIGBUS faults [1], no files (2)  0    0     0      0      2
>    size=10M,min_size=8M:
>      failed mmap [2], umounted (0)  wrap   0  wrap      0      0
>
>    With 1/4 alone, the min_size-only mount loses its reservation, and
>    in the failed-mmap case three huge pages stay reserved after umount,
>    presumably because the subpool is never freed.
>
> So it looks to me like 1/4 shouldn't go anywhere without 2/4 and 3/4.

Thanks for testing this! IIUC from your table, 1/4 introduces
regressions.

How do we handle this, should I squash patches 1/2/3 together, or is
there some way to use the Fixes: tags to require those 3 to go together?

> I haven't tested older stable trees. With all four patches applied,
> all the cases above give the expected values, and so does the
> partial-truncate case from the 1/4 changelog (Rsvd drops to 0 after
> the truncate instead of staying at 1).
>
> I'm happy to rerun these tests on a rebased v4.
>
> [1] https://lore.kernel.org/r/20260923065714.20781-1-kmehltretter@gmail.com/
> [2] the scenario from Jinmeng's changelog:
>     https://lore.kernel.org/20260907132055.26696-1-zhoujinmeng@bytedance.com
>
> Thanks,
> Karl

[3] https://lore.kernel.org/all/CAEvNRgHbzY30n1hz2vv7BiBMMhci+NEv_ubP1LjQNmBuu6Kjgw@mail.gmail.com/

