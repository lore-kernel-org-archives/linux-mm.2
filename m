Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6559C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6316B00AC; Wed,  2 Sep 2026 21:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E681A6B00AE; Wed,  2 Sep 2026 21:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7DEE6B00C3; Wed,  2 Sep 2026 21:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A62556B00AC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:27:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 148FB160392
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:27:14 +0000 (UTC)
X-FDA: 85170712788.25.15B9C80
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE5F61A0006
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:27:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m4MnXA3T;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788398832;
	b=f9KkBqFwYk3nBHaQVwvyKYNw8BzBScmlLUmXpn2Jut+4vpltvn2eZchzjyPI6hl+f2nuQH
	sNwnCg/nf/oSynqnKZQgLDus4PaavLQYHHW4buHKMb7HGgsD0Wh0JbwoTs390Jus+bvz3r
	NE12O/Ilozo1VONpwVJndLwfatlLfUE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m4MnXA3T;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788398832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBqflOEmN2pnYhxdwMiWHq+ge92k5b/GWnxbg4g9oik=;
	b=wruCl9YSvOZfFueo1U7LcM5sxnyN4/6w/HL7HKRa1npk2Ut00pty8JKPhUw5oDLAyFYjCz
	SM8EZ9n3gKvT9X5t8XWVzVDtfxphPH3pXikJr90SBKGlY5kj7VbBiakTHFYpMtthKNG4CN
	IedqMdpK+YqTUoMhmMWmDd6I+/LbQyo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dk9sKkN5uRP0GrbLFA2P9o5pKt0fKi/knsyrlgEkpNI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788398830; v=1; x=1789003630;
 b=m4MnXA3TFXWps3U6ggs2VFDVa7T2i+IUrEnwDJphWNgfvumKu6CIH0TrbpXSqEYqCwwHkQ0n
 ZlM/bxkUU9knBTZnpdm5vvASJ7Kc6sjd9BKiQpbpGGTuq5ckfVwfVXEv6ykxSo1gIhHbZST1+2m
 pZGb+d/nIbE3RP/9m9PSvwxs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 4a836954cf0dfae8;
	Thu, 03 Sep 2026 01:27:10 +0000
X-Mizu-Trace-ID: 4a836954cf0dfae8
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 09:27:01 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com
Subject: Re: [PATCH v2 2/2] mm/mglru: make retry logic explicit in
 isolate_folios()
Message-ID: <apjM5ZBOJrdGQM_g@fedora>
References: <20260829074204.45304-1-baohua@kernel.org>
 <20260829074204.45304-3-baohua@kernel.org>
 <apfZQE1X6zGAsBb_@fedora>
 <CAGsJ_4z=A3EGajzL8F5H+0fwyzh3qqMNACEzo20J83m+T8bbZw@mail.gmail.com>
 <apf3ivSCu9kQfM9F@fedora>
 <CAGsJ_4zfDJ2+qG-NHQoSi=KOPdsfi3YHL63gZytDGUhW1HOpvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zfDJ2+qG-NHQoSi=KOPdsfi3YHL63gZytDGUhW1HOpvQ@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE5F61A0006
X-Stat-Signature: 1xjtq8auqaa77n7g7hyqr7it7np39j4o
X-Rspam-User: 
X-HE-Tag: 1788398831-335987
X-HE-Meta: U2FsdGVkX1/5j137rzYQtXb7qx3QNPBrkLTZVVM1l75PmhY1hHqv2bLYqHMDOtfz8WHM1aW6r2QqXgb5kpGI5/hsgTCnM+kSjmsmpIz1mtCiYKxN5s1urZcyzZFwKXzwEpdvJCEr2aFhnJeMNejrIe5ejyZM5Lo/tCIH6o73eMhKDgOaU8PZX7/hi2Zp3kTqn4HwzHSydDi/3TqJH9sVSLvAFOODJ/SK6uJllcPv1JK+2OSKwu5HKVmLqF/B+RrDPk01WXZM4jCbnW4SKn0VZscG7+oueNfAfYA7xouYgAkmJQloVReA9Cctg3IJpYnpbw0+Yb/xX29B5oyNgpqLuqrspgQmJbNHI4iGl8/TLhLk2vChgqsehjSwP0fNK7g5Ff8oOq+2spX81aPPLKmTjoKVHZ5ioIgodvDWX6wOIFUDE6xsF8BhwZC9B+LIgRAyddPSmNfh10yU4sg/2/4eTr7T+5NPA2tJ85s43DbmRp+Thy9aRMX/1h/2y2NAj6qFJOeUb82R6HBd6Mhm9m/gb2GO9wwWSsRsoYWTNqJBTkOpuoTU/kDbDMCLlamIQc4iI4vhmQ3F72+TO8QmEa/Xnc4wt8AiukBPkMeIz5zY1f5HEdlD5eDX7mmcQeEk8JUPGI9wRtxP723jNnGd4Qdr9O5TOmxC5f+96Q/dvirkmAUOVVCHqkSMMzBNSb/70q8gJvfb+HP3ORTwqqYnOmUzDbQ035TAgjfstoOaVGZT1WM0rLKSTI3Q9Ot0dccl9f2OA3K08bdjUjXzv86Rj1zTJPP7OZprFwcLODWtJKQBFpWvm1A0BmXgQw2fIuFQLuhBqtBjN5+/ms7TNyfsEjBmAqsGZ/ocy+kNyKeQfNgpH1VsLtICL23BkkkhNWeXd006swLL6oUXFbtPuFiYdVbJs+SN8ZWApEFNtmjc+TEu6T0BVS38teOlTyAZQTDd3OBRuTu/UboOmaSWaFCJXzQ
 mXEebKUs
 KxQTVuwlWuidfT6uQ4MNmg5OZwzsCFBRbccAwH8DtdE6bWCAvg5LLJ/e/5CAvW2yPgEUOLTNB/8588j1VC0UNfHj26KX9l0w7QO9o1lxNLttjBvs6fMRy0wRgBJVRUcwk3EsNer5dVCU2zIPG/kCElXseALm69gyORU26l1bOCpRBHk7w2+fc+NnOcX3UzOse44BdUF21i8C3NRxOpVsAvOtu9GcD03lIJ9vs+ir1maJMv9jSeGnJ1Xj1o2sGF5n6dd4ItheAd4ufbdx5ibfeGfGoTVe3EdRMEyJOkqKcYsvZ+YcQn+BGKqOYIdBGBM9ChLjJbZYddpwdwLTq7oR/TBWWg+dJv/esO+0lzj3GoibMKBuqyvwTu+e0sTJqFA93AZF6jzkXFyRHbmWcjORMHlwKYcN41A9MhXVvJqKMugUobMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/03/26 at 06:08am, Barry Song wrote:
> On Wed, Sep 2, 2026 at 6:17 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 09/02/26 at 05:20pm, Barry Song wrote:
> > > On Wed, Sep 2, 2026 at 4:07 PM Baoquan He <baoquan.he@linux.dev> wrote:
> > > >
> [...]
> >
> > Hi Barry,
> >
> > Agreed on the one-line change for the (1, 200) case - I traced it and it
> > now matches mainline exactly (no extra third scan). I personally prefer
> > the for (attempt = 0... ) style because I feel that makes logic clearer,
> > while everybody truly has different code taste, LOL, just a weak opinion.
> >
> > For 0/201: my concern is that on no-swap systems (swappiness 0 is
> > file-only), the same-type retry when the first scan is busy may be a
> > no-gain run if the file generation is dominated by protected/ineligible
> > folios - the retry re-scans the same sort results. But if you see a case
> > where the retry does isolate folios on the second pass for single-type
> > reclaim, keeping it for consistency is defensible. Do you have such a
> > case, or should we drop the retry for 0/201?
> >
> 
> 201 only applies to proactive reclamation. I believe the retry helps
> avoid having an outer loop. For 0, I ran a kernel build test on x86
> with swap disabled:
> 
> # free
>                total        used        free      shared  buff/cache   available
> Mem:        23991248     1315020    20554564      331312     2121664    22099256
> Swap:              0           0           0
> 
> #  time systemd-run --scope --unit=kernel-build -p MemoryMax=1500M
> make ARCH=arm64 \
>         CROSS_COMPILE=aarch64-linux-gnu- vmlinux -j20 1>/dev/null 2>/dev/null
> 
> With the following patch for counting:
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bf2786c7247d..e8d5603cd56e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4913,6 +4913,28 @@ static inline bool is_single_type_reclaim(int swappiness)
>                swappiness == SWAPPINESS_ANON_ONLY;
>  }
> 
> +#include <linux/proc_fs.h>
> +
> +static atomic64_t tried_isolated;
> +static atomic64_t tried_not_isolated;
> +static int reclaim_stats_show(struct seq_file *m, void *v)
> +{
> +       seq_printf(m, "tried_isolated: %lld\n",
> +                  atomic64_read(&tried_isolated));
> +       seq_printf(m, "tried_not_isolated: %lld\n",
> +                  atomic64_read(&tried_not_isolated));
> +
> +       return 0;
> +}
> +       return 0;
> +}
> +static int __init reclaim_stats_init(void)
> +{
> +       proc_create_single("reclaim_stats", 0444, NULL,
> +                          reclaim_stats_show);
> +
> +       return 0;
> +}
> +fs_initcall(reclaim_stats_init);
> +
>  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>                           struct scan_control *sc, int swappiness,
>                           struct list_head *list, int *isolated,
> @@ -4928,6 +4950,13 @@ static int isolate_folios(unsigned long
> nr_to_scan, struct lruvec *lruvec,
>         scanned = scan_folios(nr_to_scan, lruvec, sc,
>                               type, tier, list, isolated);
> 
> +       if (tried) {
> +               if (*isolated)
> +                       atomic64_inc(&tried_isolated);
> +               else
> +                       atomic64_inc(&tried_not_isolated);
> +       }
> +
>         total_scanned += scanned;
>         if (*isolated) {
>                 *isolate_type = type;
> 
> I got:
> 
> # cat /proc/reclaim_stats
> tried_isolated: 12096
> tried_not_isolated: 23061
> 
> So we see some cases where the retry gets isolated folios, while in
> others we still encounter promoted or protected folios. But my gut
> feeling is that even if we don't retry and instead go back to the outer
> loop for another iteration, we'll still encounter those folios, since
> they are still on the LRU. We would just reach those folios in a more
> costly way.

Thanks, Barry. These number is very convincing. The retry for swappiness
0 is worthy. Then the patchset feels like doing two things: refactoring
the for() loop; improving the eviction for swappiness 0/201 by adding a
retry and this also makes them be consistent with (1, 200). While the
cover letter subject, patch 1 and patch 2 feels like it's not easy to
match them to the corresponding part. Maybe merging them to one patch,
or rearranging them? Just personal opinion.


