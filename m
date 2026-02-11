Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8EDECD6F4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 22:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3846B0005; Wed, 11 Feb 2026 17:13:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7910A6B0089; Wed, 11 Feb 2026 17:13:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668AE6B008A; Wed, 11 Feb 2026 17:13:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 548706B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:13:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8EF0E1A048C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:13:28 +0000 (UTC)
X-FDA: 84433578096.24.24052F7
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8212D140007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:13:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=16fpF054;
	spf=pass (imf09.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770848006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzY7TU/FGzvvQLfgVE3KqJN4JKT9kFfaraiSnLaG6BQ=;
	b=6NvWjYM3Yd2Hfdkwfmc6YBmwUjG+y6F10UwHtpWzxXWZ+OL5v3CeUo3hhnrJPBPYFMcCUq
	IOy0sjKK43x14IyWEqaHVd2LUVz4qS9Tql1ArO239NZmDGIVhSMCAsm23tVBW68TlzjaWX
	cdPR89+m+vxqc8o1NZn/mtudlXzwm6I=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=16fpF054;
	spf=pass (imf09.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770848006; a=rsa-sha256;
	cv=pass;
	b=BDxRYV4OF37eBxRYR15QD+D9QnGWXWk/LnfJ7IBAsZIFZ7n5JRyMB2oDrEcAEVWVVvegz9
	naMrIx+7gYs7F0HrTQZtek6McblCC9K6SMx+rN0xq3zKx6tjO7dMVe9cV8Hr/qmCvsDnKk
	ehR5xbRzsueUuDdNpPVNRkMJtVHiQXE=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4806b0963a9so10455e9.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:13:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770848005; cv=none;
        d=google.com; s=arc-20240605;
        b=MA0mN4QMJBfkBcEIDKJFZtZZlgcWMuTbEtIkRWl37vQtQYGKGcEhCR0MHAV/ib595e
         T50PCzGb1qy3YkPGrb7Ms4ZlWZ1QXGR0rka8V4eoaxRwk1Np5wbBQpqylIXw1n4sf87w
         Up/iaGHt0ZHWJNo3KXHTyBLE5V9JyR00YeVF93rsT0Zs8IXG9mXIEiqmMIV7QpvO0Dul
         aV/DtkzjpOQ89Zly1dZiBS5cumCtHfsNnSIP4YA0yQPvAhaeoABdsIJevisZ56W7atbc
         GYQ/lFr4ovnqsk8ur48T63wX+jNvdgxofHx0JnmAH3Ccs+RjHHnfOMeYLgtQABGZ+g1i
         DYAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xzY7TU/FGzvvQLfgVE3KqJN4JKT9kFfaraiSnLaG6BQ=;
        fh=/LMzejJHqtMtm2bG8Ut5RY7ZVNFR9rkFtZ0HPACVYIA=;
        b=fLFiOwvcbYYpxArIDSGUlPTagmenP3V645tWHvDnMxoBvOqC72lDvArjh3LmdAFt81
         InNGwQNFLOq1DYOqdhIxGhz96h6X7RvGxFdriM58UG2TfRZVv04wABqNvoIkiusXv13J
         O2ND+ScJdl8nOMbhl2sUv62rEm86sHvdwAVLazzJ37HRtUAAoRGOYMgqAZTg+bywUF61
         vbWaSS5JoUCkjUDk4+mM8d624Pc+QNIrLtPG7BSAWBjvL6eAz5e5He7bINbYrs6EsGna
         AkmkXcERxV0tZpgnEr0u8pN9VpT9fYPgVEkWeYI9gunJgxPHxoyl1eGJMGPfJE0Rsdod
         5K8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770848005; x=1771452805; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xzY7TU/FGzvvQLfgVE3KqJN4JKT9kFfaraiSnLaG6BQ=;
        b=16fpF054KhmUrJVriYRXvuv3W4mEyr818o5F1kwLF3HUhmWcUU/65EGMWdYxD4BM+I
         YNXbfgcqFBuj1iz5QlDQv2iVeVMpyJmsUsjSwr9i2gJI+DMO6IC2cTHvbbsaUaKHm+XE
         1vtjKD/TZKyW7mvoV7nZ4VjciLZjCurlUsVaYNBFFQnlNj8qIAHWqmC4TUcjTMjCY5T7
         iiENTrt2vOBAEHNRUTZAY7ppo1sMedzGkDmhy6f33sWppTYxJfzekLM3OwhaccqqGUu7
         uAugBzWY9APeqdL6Kgz6YaMSbmPpbkZrQpdLAQd6ZbacFpTmGUck9E0z5kw1YRaudINZ
         ykSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770848005; x=1771452805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xzY7TU/FGzvvQLfgVE3KqJN4JKT9kFfaraiSnLaG6BQ=;
        b=UeUWN3HoHXewMaid+8IW/nWZ5YET3KJQNm/3xpYq1dkBi5VtI3VapJ7BkDyhfYufD6
         BQRcOTX/ia/YvitVrS2A3vGvPLI/hQmHmB0z07tLF3o+t6ly7uFRkpkdSDHt2zgpR8iP
         QUkIuv9y01wvPlJmxVFDwqvh6KM46RltgI+wItv+QbWOidVgKwyS+Qu9/45PHJYWSvdR
         4zVukF+TZI89At3wkZFPciGTMOt70kosQs26Pao9O5D2vT+PaG6obp2YfdTh/i2D9yhy
         oHVkLNOy6O5LfcvLcAzBBwMTwpfEjy7UOAYbJZHwkKMnDGnxt+FVS7GnRN1x8BIgDCNM
         XuEw==
X-Forwarded-Encrypted: i=1; AJvYcCWQzd+xaYUTdNXaOttAu3VLJdsPG6APlQ1WpRW+0xDdPDMQCKFwMb0XsdysyL/gHmXwTUtJSg9Lnw==@kvack.org
X-Gm-Message-State: AOJu0Yz8jCA1etxEbwKIQ9XH8ubjEjA+/ICixxCkxDRDsoc++bMivB4v
	qKOM/2uSrfXuxfW8cw2Qo75r4keuNH3rT8jN6th3suZp+wutYgglAHMyod48fNo2i2Bc+YvbJ7V
	FQKpvnZkKY/z780UUpv4nOpl7pMb/WaftVnrspBKX
X-Gm-Gg: AZuq6aIaRrTPRu03DA1WfEcFTHwN8ICDMn0mhPvy64kxuCpptB6QL6jfZkKnAAq2FjW
	YX/0wyebX/RlFlTELJQIeHvP8M7r5kWgc11GmBZOGL5Tultuwqgk1TFZpubhRCT1NV5NcTNeDs7
	EgKAbfeWJuKu2+SlN7TI9+4yCcUyukZp6bd/EEEu8VrWbbhEhUw9xpTShLWyDxAt5MASOwbTJ7c
	qdwxNbRsD3vAgPueTRtdiIDP1d8qB8/WohMwxx4fIYWO4aE3aoxZiQAjbVB5Fm2bHGa2kR430Ku
	1WxrYbE9VcLfuwZxcTccoZhR5bnDs4ccJwfclbP1Hb4RkufRwLugHZXcOXeiHjp0nvyu
X-Received: by 2002:a05:600c:1f95:b0:47e:de3a:a929 with SMTP id
 5b1f17b1804b1-4836593aa13mr288975e9.12.1770848004791; Wed, 11 Feb 2026
 14:13:24 -0800 (PST)
MIME-Version: 1.0
References: <20260210054312.303129-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260210054312.303129-1-zhaoyang.huang@unisoc.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 11 Feb 2026 14:13:13 -0800
X-Gm-Features: AZwV_QjqVVYGT8M6YAgIey6AhsPAthcjRE6Z-ZAt_af8BUqaz_X5P0TcvME4d58
Message-ID: <CABdmKX1NZJ5jOQH_9cxuxTVmn=CiCkXHK7rNrpvGBTT_+405Rw@mail.gmail.com>
Subject: Re: [RESEND PATCH] mm: bail out from partial cgroup_reclaim inside shrink_lruvec
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>, 
	Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8212D140007
X-Stat-Signature: j8z73jndho343pet1wo8tayhzaj1ttuy
X-Rspam-User: 
X-HE-Tag: 1770848006-59339
X-HE-Meta: U2FsdGVkX1/A8oUeVknnVJvJPz3wE974cIEY08ESk146T8ukHvpL5fAvXHP6va0ztCUeYjDrRVZ+S1cC+293JA1xBHqbug+WG5pvXXbCN0j6v3J2Z30Gc00T8KX2/qxj/zrCecZs4i3Bs417dfDYYSduR+roV4aXjYnOUZBwDEo2JcrkPa06lBnUQILoiET+qWsaQVOh2u3/RqJlzKeQMJ5zauscokmIBK/I7Aj22BAIGVq6XtMMwa/WkxilC3Bx/wBkCPdfwJwfqd+2i8vpNEgUNJhOQA572erUWKvlo61AJbq4kzH9ma/oqVQ9G1W7M6hFVnd/O+lvwykQCkM4pev2ww30zKb2jGplmfUXV7IgGoBTiKwteWqkNT4ygOBhDvSMD0xDsjAloAxHNmPWj1F7tVn4HjbwUDmuoA5CMCL/eRmN5S/MQPNgTo2U/dfp9guH0JW8ScKQ2RTjSLH87A8QaP7ToZJZrRPQxWaBOXTqfHK2BTtR2+LBTxUK2HpzfwZGP0/tu+IkcbTUPC89Tb1Hb3eRbag0dbqU0UTTBRxFbPHbeWyUqXFzLkVP2L9mi8/y7mUQxkaK30NUZUyrOd9+UZksBgqGflccHiWu+UeFgRMiscIEiDxGwSgfqWFettFu+bLwgOBaDwoqW+nkC5qOHaoNG63cd5IVFY5esORqEcaWRcRvPmcttD5w1Jjs3UNUNqL6uBBku7ueDGDNla43t9QOcS2p908X3V0QCIrM65hKDU4T6SjRQsljFaf3xEPul2ounakseHrdD83351KLL97UxzkgTKaIxl3fX4H3RztX7RlI1mqZfCVI1EiGTJdv/vc5uvB3zM0svpj09+8ouxUGwRwsLO+N4NnTBoH+wzqKVvGTLM71fz1NjhzQ9q3izeMv2V6eS7NQx0x57X1bGgJSXI9fpceyxg5zrLeTOwC8aY82b93G3vVY8fMsGoV2mSnNZDEVsmiPQfi
 5tPTv/4g
 D2f+8DEVchX6QJ6xM6lkBgj9tZ8+x2W9O+KneljfZv5IrQtIm0ITXIOJzbK3Ms7oPcDFMxP1KTo9UvOzoGriD5gMk43ouJBwe2n9pKfy/k+qITowOPYkubcv0gvDhYMY6rO/Wix22CtE0w8VsgXYbYAbEegf1sBptF9kVnIruRZ2RMHR9QFZDal6r5bs3OhhnsBHZgtOxQsrY7bd1hD87YBDKEyj5RINAE2AI5wR5relxyOqWU/uC9mgTlDCCF+ncygtaOjcq1kP4ygTLMZriO3//A/pkb1+hflpGpXyp7yV+QONuFHBhJqn9LR0AdE48+BhaZ5Bs6T1Ho2SUTIujb8ojslkOOF5l93TH3Bccwc/LkbZ9reHZ/eUkkW9rU7l+sYKv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 9:44=E2=80=AFPM zhaoyang.huang <zhaoyang.huang@uniso=
c.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Hi Zhaoyang,

> Nowadays, ANDROID system replaces madivse with memory.reclaim to implemen=
t
> user space memory management which desires to reclaim a certain amount of
> memcg's memory. However, oversized reclaiming and high latency are observ=
ed
> as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> when MGLRU enabled. Besides, this could also affect all none root_reclaim
> such as reclaim_high etc.
> The commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
> iteration") introduces sc->memcg_full_walk to limit the walk range of
> mem_cgroup_iter. This commit would like to make single memcg's scanning
> more precised by judging if nr_reclaimed reached when sc->memcg_full_walk
> not set.
>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  mm/vmscan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..03bda1094621 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4832,8 +4832,8 @@ static bool should_abort_scan(struct lruvec *lruvec=
, struct scan_control *sc)
>         int i;
>         enum zone_watermarks mark;
>
> -       /* don't abort memcg reclaim to ensure fairness */
> -       if (!root_reclaim(sc))
> +       /* don't abort full walk memcg reclaim to ensure fairness */
> +       if (!root_reclaim(sc) && sc->memcg_full_walk)
>                 return false;

Can't we just get rid of this if (!root_reclaim(sc)) check entirely
now that commit 'b82b530740b9' ("mm: vmscan: restore incremental
cgroup
iteration") provides eventual fairness for the proactive reclaim case?
That wasn't true when this check was added initially.

Thanks,
T.J.

