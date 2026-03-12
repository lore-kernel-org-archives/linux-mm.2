Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C3C0FED2D7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 06:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CCCD6B0088; Thu, 12 Mar 2026 02:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FC26B0089; Thu, 12 Mar 2026 02:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A3A6B008A; Thu, 12 Mar 2026 02:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3A1B6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:02:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EB431407F3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 06:02:59 +0000 (UTC)
X-FDA: 84536367678.04.46C5972
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 75B62140012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 06:02:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l8Dc+XAd;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773295377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nEMW0MEEkGqDxKVP1qJuKZOt3e71sLsvh2iiF9O/n4=;
	b=rCl2RvLxAhmIATWzs8Ociuv789sqL63qRq5VoYbOt/B0avdZNV47tQRm3Zf9Di+sU7GYfY
	2jypiK8PcZ6mCh+0ZX7kcP1fOqAlL1xLQ3x04NvLB0WqPQlezJOEYpiPberaqCdiM/Rq8M
	iItm8jbG5UTBz/gj5heosV0LkoqjAVw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l8Dc+XAd;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773295377; a=rsa-sha256;
	cv=pass;
	b=a4hH5zaYaeZcF5arpvX5n4BnTMuxTQJcBjFPnV4rF4VC3CLT+7bu3xOQfnqpawGbq/5eUB
	9OGkuMcVeQT60vDli0b21aflarIPmplFw2OA/t4YPSyy5p0HCpSOi/f4pDMOLtuUoNg1Xf
	F4NUhOpZ4C/oBydyPzZ/f3b0W75IJPQ=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-89a0ece9f14so7842846d6.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:02:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773295376; cv=none;
        d=google.com; s=arc-20240605;
        b=Tj5H19PjWMjZFJFq2rnRU5TFdQk8oUqjVuEcmNYnuqLKElwnPvE/i5V43pwKxSoxIK
         7Kg3grUcdtRDnUflC32O/dxRyCgoeu9bactiKHkvEx1/IKqKlxGEKe97HUklCmwGGFJr
         L9q4iueUeXrw9YKa2M9TKFSCaEutMylttxU7wylh0T0+tig5PcQuRmxJ5aJZvDVUMDEd
         uovpSWhsLmPRB69OPoU7nretozd2f79R/VP82JiSS3f/etaFXdI4v79eE8tAJq4wgNys
         RwQApPBCdLjdXSmhq1SJ1eO7HoduYXEvkyBU0KPHnTVnY6SfqAvUGFUk3YTDzodIrauC
         yJOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8nEMW0MEEkGqDxKVP1qJuKZOt3e71sLsvh2iiF9O/n4=;
        fh=3U0UPlylBbGgzcLZZP22+Ywad3bZoQam+V55yirLoIg=;
        b=gKIjXkiNemQu7/oC1X9wIJ3EuZ3Eo6EriNDIlzawBMMefD0u7T7rFyUh963H7Cinnw
         jb/I0kbe6EHy/SCS7cu0l5NuQwt3qgNh63Gctw/+PFhs1gLkFTVTDWZgajkobzqhT6fy
         jO148radKvuCMmGj/C1jL/Uwh0RDH6nJqv+V6iQT0hC/0vscJHpIoMssbMBcs73ykivC
         oifedcLkZOr0+A00wymAe9TcR1qL+pIiOxM9q1MxX2OmG05hr/iL4+0Bgf1cGkXcdCfO
         1Z5wNBcQmNxaspBudPuEuyMCG4RK87rOR1q1l9eXe6cf8Ct3FUZLl/Gw6WSUJ0YVPd62
         15UA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773295376; x=1773900176; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nEMW0MEEkGqDxKVP1qJuKZOt3e71sLsvh2iiF9O/n4=;
        b=l8Dc+XAdLhDikVBJoqrlZtEXcy3xD2Yt80Cxb40X4unoL30ql/WBK74nqdVDiDuKTm
         ZiCV3JKcpPs3oyze3vZl1Fz7DxZyxgGitffpWrAWHBvv6PgcyRexRJevzQ/uNCIWmNLT
         xrrSSeGGKejc5yqSfvO3UMc1kAi8ATqYrOOyGqQnqqheT7kHJ+P8/4ILt/ii8zZ67YoI
         tR2GgVKsUbtqT6oSNJJ3nTvyQhgdNdhgS3nDW9vqiNpvOUm9IkgU8xZ7R40WlifF61bE
         B9aie1LGhcX7y/H5+LrVxDYDJjvS8XRa9N+rXbEv2SeFH7vWvb9q7MtXPkBVLE/PY0Jl
         k+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773295376; x=1773900176;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8nEMW0MEEkGqDxKVP1qJuKZOt3e71sLsvh2iiF9O/n4=;
        b=gjwpQ7QLJiOh3SR73/ztA+tK6L/b6H/huyqxze2LXA67eCoAxaX6F4E9dHu0LTEh5v
         T93NTvFy1T8MgmeOghp3vUBdUOC5OyEfEF8cXhD3isVX8tv8hzd55ZyAGS43Pe1mH1Wb
         W5oHcISuRRMLsJLN+Wv8umCs0L7E/U7hX/L8zBMuhFnj6IgQS60Q04FcYGmkCgj97dQD
         SFNiMGzqUY+0QIM58Iz5ZCtnVxwcgln0HWbcuP7RwGydoWcQbXXzHNonOHmr59kAdrkp
         dkgviVxsIJGY/NrBoQzR+mnIKrXtAYj1mRdQE+CSgbhQvI5+0UZdxJn6MxbnM8Ustf2b
         rV+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVacyMOmWOGID+cj37PtM6lXVCkCsbLRCnLCqVRUIoP5sDgzZ5bsvW/OhH+jo5AlpAg5N9fJMBJkQ==@kvack.org
X-Gm-Message-State: AOJu0YzYXBbw4GVjkuZXyN3ppwzZtjJhrbDCVKrDksL4+To1Uu50W/lh
	NrRwoYhUCGITizMSk3jbyYkiPiKDMji0s1pzA9asUKHiG3KFUSa0wAZlWTIijs8a/rTbEhVaZAA
	GLgQiQ16z+qpPx4idvClAX5NUTEdMyve6Gb5A
X-Gm-Gg: ATEYQzxzei4GdSNXTyo+ju+wCHqOU65d9gI2RzMI846zMeJ7cxUQ7cgmWlC2OUDmeBt
	ywUOeaB+x2S6TQ2YdOLsIph7qiay5qStxSDlwPZjlYJ07OmQQcgEVaLyQif3jvWcN6wxuXOItVN
	42GmDw5c5sekQ3qoM2lqVEGjySnZO/8/39qkdM6icdnhZNi5k/ImD0/yh0nqAUaiECk4cFuWvoB
	2K4yxDSGKqXUFmlARjKrReFvTtfe+QGzCEaOzwH1oOGGBBGNmiuvbUMphHZBWrcESjWxg+TN6es
	+BRg1g==
X-Received: by 2002:ad4:596a:0:b0:89a:145f:47df with SMTP id
 6a1803df08f44-89a669c06c7mr71619886d6.3.1773295376244; Wed, 11 Mar 2026
 23:02:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260311-b4-switch-mglru-v2-v2-0-080cb9321463@gmail.com> <20260311-b4-switch-mglru-v2-v2-1-080cb9321463@gmail.com>
In-Reply-To: <20260311-b4-switch-mglru-v2-v2-1-080cb9321463@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 12 Mar 2026 14:02:45 +0800
X-Gm-Features: AaiRm51Gei6I081LWYlYGubQUxig-dIzZGdburvibtQgqgiwmLzwujSQaJsEwQ0
Message-ID: <CAGsJ_4xxXD68pHfsEf2=AygDDbp8+hEJm3KQL9WCPr6xfjtMng@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/mglru: fix cgroup OOM during MGLRU state switching
To: lenohou@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jialing Wang <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 75B62140012
X-Rspamd-Server: rspam08
X-Stat-Signature: tcoe8ka3qakmtm54oxnj55xmey19erpq
X-HE-Tag: 1773295377-820793
X-HE-Meta: U2FsdGVkX18FxWwC/B/HOGDJLOPt6Lnh0idjgi/kQQoOb3Qaw4xiXstWvIMBlEkxu2Jk//2PWwvkfEl49jqovsiUvDJmF9lzRnVqVl5XmCf1Peqvw3e73A6hcboUy8VpVY40N5jITk9LWc6d3Ib7nxJ+qb61kIzeuZibEXakA8jmCFeJCnCt3prfRT5Wa17L/H+mRc//nCv2fYwKO4aSQ2wzpaMNmMgGu55Z7E8uau5sQ/ndo/hQJBB3JpFxV+Y7fXogSdn5pmml3ISGmSe5b6NyEUuT3bOwSfj0bhxvAugzdF/SrE2+mdzk5jmZo+VrB4+DXAtRbB5l4UGqxLmgdYmBR54pfweEiNle/3ruW2A+R+Rf3n8aKAONvnssArNS6e2ixnrz1uzFoU/9bJyu+OI0sLtgHFiL3qlgTijD/Ev3NFuBHbKaJftwx1CSsXflwJzola1a4sk9N5sTj4ullnwxscGbXF5ZQrRNAeIHlS7vY294p7suHKP64UDGRuSF/ZgehbyQKZnQ/hDzVuRaIjDCXzGl8gAbqPezR90+VsiFeFbVrZIJKC06A4n48l/wwX6Zo6N3FauG8y54i/6kTxBFLOh6NGEwmo0HRH9IGc2NCu65k0ymc4Dt/CD6FLVfGDR1mDCJGc1mi+e6LeGZeprzaRdo5bLGjYbDMriQBGy2hJVru9Be4vXBtgwthARvHJSNZ2ndQrkrcpB/hK05Ebf8dmaD/gTtggg20A+hdSmnq+ROSn/mT4lhEJKbnIapTbdC/xVQhbbf3ehOMvHjZmTWdEwEWXMu8xmkRHllXz3T4tqocQOvUo7K2POB283hGT0FVYtU0idtR6z/7FXIHdhqlBtgaIUjILiThfQFBHVI8uOfwqTjMCljOQbsNj5TOpWobKanddfCd5T7W0RboD5l6G1EWysAl2CYMHBZKv5vkqRj2OquKZkrd833/+mVsC6FD5GAyymg4yiZVPy
 Pi6wDTZq
 fUQg8P+IgyY4+9J+gdBp0WimZXdT2OtbgFg2jBu7wldZk2Aok6A1MuglS7gQCmnp6r9sOFPNhWmvFWSBGrZCwd/32Nnz1tnKPGqmIy17AZIxvEZaNPc/tpAxA1RoZjqPjZkFXcfB5WTc7hDmCcMR3AVP8Ccmm0vsCVCFbDvSg9FDVcKe4R/p9uAJDNsPjRyZ1RYEWqMhHsGkM5P1863MSUN1wCJgloszpcPg/NjWxmHLBwqLPD1wWTLitfAs5qTjKZoE21aCdQhUxkeNqxjIPjPxoEBMV3ss5fyjOEeqPQZmvyXWEIhcVz6AmzgRL4faCr5YMHYWELaYOqZdyYi40eW3DrK9L/ZO7iKzMMeQATafQQeWUGZdp+TY/7v1FZc1L1WPLgt2eh9wX75x4ov0bwCqku6dDtMpH44Vxb7bidgyUQEMaOmws+kGvnxkhh1QrzxnAISsXB7z89PHTvCnD6SzBYEg6ze3iTN4TEVBHL3ffdR9Dt/GjvA767K32y3eHrVfNM2r53ecq6PWbwBdcyxvPllAssBkO2FfUIIlHWo2A3A251Go5yVx/4Z+UL3tI1z5Y5oBQkoJYZAMVDzB/g/aKJ6YKBSMfI0rSK4tBTNyQ1icOxjoex4vpQMaAUMU84fWpMkX3c1QnLLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 8:11=E2=80=AFPM Leno Hou via B4 Relay
<devnull+lenohou.gmail.com@kernel.org> wrote:
>
> From: Leno Hou <lenohou@gmail.com>
>
> When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> condition exists between the state switching and the memory reclaim
> path. This can lead to unexpected cgroup OOM kills, even when plenty of
> reclaimable memory is available.
>
> Problem Description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The issue arises from a "reclaim vacuum" during the transition.
>
> 1. When disabling MGLRU, lru_gen_change_state() sets lrugen->enabled to
>    false before the pages are drained from MGLRU lists back to
>    traditional LRU lists.
> 2. Concurrent reclaimers in shrink_lruvec() see lrugen->enabled as false
>    and skip the MGLRU path.
> 3. However, these pages might not have reached the traditional LRU lists
>    yet, or the changes are not yet visible to all CPUs due to a lack of
>    synchronization.
> 4. get_scan_count() subsequently finds traditional LRU lists empty,
>    concludes there is no reclaimable memory, and triggers an OOM kill.
>
> A similar race can occur during enablement, where the reclaimer sees
> the new state but the MGLRU lists haven't been populated via
> fill_evictable() yet.
>
>
> Solution
> =3D=3D=3D=3D=3D=3D=3D
>
> Introduce a 'draining' state (`lru_drain_core`) to bridge the
> transition. When transitioning, the system enters this intermediate state
> where the reclaimer is forced to attempt both MGLRU and traditional recla=
im
> paths sequentially. This ensures that folios remain visible to at least
> one reclaim mechanism until the transition is fully materialized across a=
ll
> CPUs.
>
> Changes
> =3D=3D=3D=3D=3D=3D=3D
>
> - Adds a static branch `lru_drain_core` to track the transition state.
> - Updates shrink_lruvec(), shrink_node(), and kswapd_age_node() to allow
>   a "joint reclaim" period during the transition.
> - Ensures all LRU helpers correctly identify page state by checking
>   folio_lru_gen(folio) !=3D -1 instead of relying solely on global flags.
>
> This effectively eliminates the race window that previously triggered OOM=
s
> under high memory pressure.

I don't think this eliminates the race window, but it does reduce it.
There is nothing preventing the draining state from changing while
you are shrinking.

for example:
t1:                                    t2:
   lru_gen_draining() =3D false;

                                    Drain mglru


   Drain mglru only....

>
> The issue was consistently reproduced on v6.1.157 and v6.18.3 using
> a high-pressure memory cgroup (v1) environment.
>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Axel Rasmussen <axelrasmussen@google.com>
> To: Yuanchu Xie <yuanchu@google.com>
> To: Wei Xu <weixugc@google.com>
> To: Barry Song <21cnbao@gmail.com>
> To: Jialing Wang <wjl.linux@gmail.com>
> To: Yafang Shao <laoar.shao@gmail.com>
> To: Yu Zhao <yuzhao@google.com>
> To: Kairui Song <ryncsn@gmail.com>
> To: Bingfang Guo <bfguo@icloud.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Leno Hou <lenohou@gmail.com>
> ---
>  include/linux/mm_inline.h |  5 +++++
>  mm/rmap.c                 |  2 +-
>  mm/swap.c                 | 14 ++++++++------
>  mm/vmscan.c               | 49 ++++++++++++++++++++++++++++++++++++++---=
------
>  4 files changed, 54 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index fa2d6ba811b5..e6443e22bf67 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -321,6 +321,11 @@ static inline bool lru_gen_in_fault(void)
>         return false;
>  }
>
> +static inline int folio_lru_gen(const struct folio *folio)
> +{
> +       return -1;
> +}
> +
>  static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
>  {
>         return false;
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 0f00570d1b9e..488bcdca65ed 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -958,7 +958,7 @@ static bool folio_referenced_one(struct folio *folio,
>                         return false;
>                 }
>
> -               if (lru_gen_enabled() && pvmw.pte) {
> +               if ((folio_lru_gen(folio) !=3D -1) && pvmw.pte) {

I am not quite sure if a folio's gen is set to -1 when it is isolated
from MGLRU for reclamation. If so, I don't think this would work.

Thanks
Barry

