Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A214FF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EBCF6B008C; Tue, 31 Mar 2026 05:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C096B0095; Tue, 31 Mar 2026 05:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C1A6B0096; Tue, 31 Mar 2026 05:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52CB86B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:01:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDFB28CDF6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:01:56 +0000 (UTC)
X-FDA: 84605765832.12.DE1607A
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 101D7C000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:01:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j76C41Ax;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774947715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkaMixAKXgiKFSF+p6/QZdNxjo7teueOK5Bj18mPxuY=;
	b=hjNmuitqmImyERjWDyInZha8hVLsSTpnl6TBQQo6Vt4w6EKoH2ecmKx69GkhtZwB1eVQ6B
	TjD+/t+LXSUpFcLqCk3jQWn4K1BgmJUFgrB0Wt+FzO7rx/tcOHRC8Yqnz8CnTYMX+qqHaR
	fAUB8YWxD05DPd+R07bNoAh2qGkuH6w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774947715; a=rsa-sha256;
	cv=none;
	b=7wOZy4uwN+E9Wgx0mvSBCSJy+8BRTFvVGlI6i6NYf+NqwmUbFsSMMw4Bn6Ehc773MtTTXH
	BE1ap3rzTb52p9gyHnP0ppZnwJ9U44KxjrC2HvwUItJWZFbUXlOpyDj6rEOqDQalW+DX9H
	F1sGQGCfpLP1VZCt8acXKbkPv8PEz2Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j76C41Ax;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82ae379000fso1894604b3a.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774947714; x=1775552514; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AkaMixAKXgiKFSF+p6/QZdNxjo7teueOK5Bj18mPxuY=;
        b=j76C41AxpfZ0LM0saffTudJSFlagVQ4YLaIUZAp3rtB+2JpF4cAsMCsLZz4kQBD+tE
         BkfMCxVPBRtzhYh2SUrqKzQjzzd8Wr9TDil1KXfYgQD4QmnSmQBQjWiZzJiD62eGsOWF
         iWQM/hHF+/IOdnV4LH7ZfQ76tUQaGIIaUTaN+5SxKkDYJAXkEuHuQsdXC6q7h2tmA2TG
         K07bPfJbH6oGcvMJggBJvvV4tbZXeGO8kfqsgOdPZhhz3bcyDLEEkFXBzVl0JamRJDv6
         LRVTg3x+3cY5zpRLavBezl5vMer7pd6teiteQQWau08x8F+3Enx8tTUDMZ3nHwnkLQZr
         PcXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774947714; x=1775552514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AkaMixAKXgiKFSF+p6/QZdNxjo7teueOK5Bj18mPxuY=;
        b=qD79XU0IR3Y/RJBtCP4kvXBxs2IeO3jK0aci4oj2iPtH1n8pkLs6fvtO9v1RwxUIPq
         X9KfqNltFff4iA6HMo6ggRRoJ6rlEgN6WqHaCR1LqkWtPeG2qCLVkqjDVBW49n9KbaUV
         Fu3KZS+Lrs1ZxuHPBunZYdlNGmErFD1l02L9tBX7/o796fzfCdnYH654r6g7nxrV4LQp
         srTdtNPd7gmz4B//Ipzh9AnfxUGrsFeyH8Z84dZzD2oQopKu3jS/CEkY7P/K7Ze4HPz3
         7ObqdcGpjfy8bYrFw77gA+WkV1ho9eNgVlNW90L6Rqr+T9l5U5edQtfrOgpAbnT6lYd8
         vqaw==
X-Forwarded-Encrypted: i=1; AJvYcCX9kd5coDo/tMz/vBJdxCfOuvtUvhM5DExDzDYl4LbC+sYJqXKUCH4zsiKylbvjMgNaNz7xpWTl6g==@kvack.org
X-Gm-Message-State: AOJu0YwslSI6YDYhYVtv8l/EpAYtuGit7eu5MNolt7gQUhv42cenniLh
	ajD2lrHZghofQ1B8dyOkM1E7dcqBkAaQt1z6hjjV7QMUlD6TikXIbdiL
X-Gm-Gg: ATEYQzwC34BoJj1qli8ACQv7CsMwzRBOSTZuBIDwEEa/yEO6uiurI5vAjhJ8gLl6+Wx
	xjMEQUi8QaPRKTTJQiDNOMtcT7oRMIfIWR6ClczwXg5nkBx48CMj89chTis3rpr8HLFpNZeimzo
	dDmxwxUMFBk5x6Lgi6aS3i8eKhjpzXIrhu51CK3TvzSV913VV3lp/ehIoIF67yneEq1H2sf7/q8
	bkOVXBNrC6RrwLQinM5kC4EKix11XrhpLDGr1opjihQGSoqbztFNm8pywZmGdnVoNBZKa1YpIeH
	OjFTA04ByuZL6N8yv1h41bjt78njYnxaQFB2UJmky7CJfAQmazrZTfNZlYMaRAubOzCC2IWgNRs
	CkYjReWneFIcO4/dXRtDf0psQZ/7BPmIQusgHoARGxruXHSMAqzyknxqFC7HHZJEyxr3dt18HAa
	5z9hoTnnFII0Z9Ej8GiIF+bIVGbYRMRBigzbP+sKwHDMQy3UcXRkirVYCfMlt8NJYVmgU7
X-Received: by 2002:a05:6a00:35c3:b0:82a:15a1:14d with SMTP id d2e1a72fcca58-82cd65952eemr2218627b3a.14.1774947713775;
        Tue, 31 Mar 2026 02:01:53 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85fc756sm8858476b3a.47.2026.03.31.02.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 02:01:53 -0700 (PDT)
Date: Tue, 31 Mar 2026 17:01:45 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v2 05/12] mm/mglru: scan and count the exact number of
 folios
Message-ID: <acuBldipHM5fj_pw@KASONG-MC4>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-5-b53a3678513c@tencent.com>
 <3ef1cb78-5110-4326-bde1-d929f638b8f6@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ef1cb78-5110-4326-bde1-d929f638b8f6@linux.alibaba.com>
X-Rspamd-Queue-Id: 101D7C000F
X-Stat-Signature: 34hzjbdstkf9x966516hrdz3hyohkjmh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774947714-528203
X-HE-Meta: U2FsdGVkX18fP4+g/LnrNsXRWQh15n39eP0Q2Qg7vol9BBisB8veCj7f+CR+bh5dzcLK3N7RgudW00XCUcXtoTsZWUlnKPmaEE4NZWkTW70ut077q38VHb6OkLMxQ8503y76TeIw7g8cpc9C4eQyBxyMkLLVILI2hETorShbS6VatxSVnlEUduA+uhAPNnmwzyLQ10b5ghwbokdoMAMwihzk0/i7KC9Xwv8M06h5zBl/ncngLb+0TIP8Bwlgi070ATXhM6FHgkXKsnK/nJsVTSHkBEbVElrlB5zMvC2De/7Jjlr1BwvRLX+cnf5VlQ7OOSelN53Zu8jW7Z0bzrAcIHA/0nJHzFRjn/Ic7jy0axxTe5SKayLUbsEIrP6sNuhUb0LtYGyHmZYIdT8pR7SavS2Q+X0UNrnfGdG9O3Baz+dRMLP3cBA+7/curVMZGO+hdwDY/WlkEACJqbgCvj1MelXGfKOZqcgWFC1JmfogStFtXetfJ436YGIfx2uYggp+SdT0GEYe88qi5J/x/jiqTrFZS3qtQ4mX42pxXqkQeeCtIgrAT3x+kuGY8cu3V+7LQ4cSJBF1pgPi28j85IwsOwJkO2/RKeueruWS5RkCe58TR0+iZAoq4qJzTmRdBJK8+/hc5nfBV7CK8n/WNx1tht2J6F6H/unViNvHw1SeQnOe4Le6CPSfOhy13vRJF1TM1kX5dNqmYdu98LDAmOJGeHTvIrPTdffhPKUb9W12eT+nGVnOELaAaatrpCGtH/QYPGxEgTpRddeidKQQKeCO0mIXGzyPpqSf2yY0VJiS7sfNEcpyCp+Q/dOX2m2TibxBr64MAENJwRuplEhoCwYIHHPMlTyf6dt62jbgJRYQKr7noQjh3AGDh1ALkEW9lsbuC6Y1kT9vOrh2DbLxyGAFLZBOnEggyVc1nhaF10WkRS20zr7PBWo5enU2viMrb1o86FrcXhGVMv42WSZcQ2Q
 2EY7gs+p
 WrmBJfl2jJm4CJCghVidaalMuoJ+IJcp5ebVtdDa5Unyk9w1kyL5abTgweZma/RkovtnXf7dzyJ/dxBg12S5BGCCzrq27s5TB29o5mfoWe/R8G08XSeUfufmXO4yrVXA+s4+3hkaFpF68uvdaJnw+Cbh16VFGDvupF2eVnkBuqPeyqzaAIVXMZG54L8V2pFPDOGGjuH0H0sFeZalhpByTZu4Wf90nL0zr5oXecTG1rbDjnANvEJwjAJlQsPwjVI6UEKLxEctOJHsCfvlu10O06ACYfuw0eLwNsJMXYyGFrQzhT52gPo+gDWErpZw+eNP27h4JymeAiPltfQ69O+/O3m9Szr4yTX4ZW7LbNb/mlQEcZR2ACmdSXwoGlz8nUvgxF5+V7OzPGvietFMQ7Vp6c0CfuO0Rb+DeArgWMJFolPbrv6819I0PhYdesYufZANI6hA5kRZ1fe1MVmDDLetZM3Pae75pivVndkbMi+1dWWrn5w7IMhSU7AODqVoAEiBC9W6NBSdosfWz4YTr5DaD3fLvBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 04:04:30PM +0800, Baolin Wang wrote:
> 
> 
> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Make the scan helpers return the exact number of folios being scanned
> > or isolated. Since the reclaim loop now has a natural scan budget that
> > controls the scan progress, returning the scan number directly should
> > make the scan more accurate and easier to follow.
> > 
> > The number of scanned folios for each iteration is always positive and
> > larger than 0, unless the reclaim must stop for a forced aging, so
> > there is no more need for any special handling when there is no
> > progress made:
> > 
> > - `return isolated || !remaining ? scanned : 0` in scan_folios: both
> >    the function and the call now just return the exact scan count,
> >    combined with the scan budget introduced in the previous commit to
> >    avoid livelock or under scan.
> 
> Make sense to me.
> 
> > 
> > - `scanned += try_to_inc_min_seq` in evict_folios: adding a bool as a
> >    scan count was kind of confusing and no longer needed too, as scan
> >    number will never be zero even if none of the folio in oldest
> >    generation is isolated.
> 
> Yes, agree.
> 
> > 
> > - `evictable_min_seq + MIN_NR_GENS > max_seq` guard in evict_folios:
> >    the per-type get_nr_gens == MIN_NR_GENS check in scan_folios
> >    naturally returns 0 when only two gens remain and breaks the loop.
> > 
> > Also move try_to_inc_min_seq before isolate_folios, so that any empty
> > gens created by external folio freeing are also skipped.
> 
> This part is somewhat confusing. You probably mean the case where the list
> of that gen becomes empty via isolate_folio(), right?
> 
> If that's the case, the original logic would remove the empty gens produced
> by isolate_folio() after calling try_to_inc_min_seq().
> 
> However, with your changes, this removal won't happen until the next
> eviction. Does this provide any additional benefits? Or could you describe
> how this change impacts your testing?

Hi Baolin, thanks for the review.

Yeah, I also notices this issue after sending this while doing more
self review.

So I did some test with the patch below:

static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness)
@@ -4818,11 +4814,15 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
        lruvec_lock_irq(lruvec);
 
+       /* In case folio deletion created empty gen, flush them */
        try_to_inc_min_seq(lruvec, swappiness);
 
        scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
                                 &list, &isolated, &type, &type_scanned);
 
+       /* Isolation might created empty gen, flush them */
+       try_to_inc_min_seq(lruvec, swappiness);
+
        lruvec_unlock_irq(lruvec);
 
        if (list_empty(&list))

The return value of try_to_inc_min_seq can also be dropped
since it's no longer used, and the function call should be cheap.

After system time of build kernel using 3G memory and make -j96
with ZRAM as swap, system time in seconds average of 12 test run each:

mm-new:
9136.055833

After V2:
8819.932222

After V2, with above patch:
8783.944444

After V2, without above patch but move try_to_inc_min_seq
back to after isolate_folios:
8807.874444

This series is looking good, this inc_min change seems trivial
but in theory it does have have real effect.

- Moving the try_to_inc_min_seq after isolate_folios may result in a
wasted isolate_folios call and early abort of reclaim loop if there
is a stalled oldest gen created by folio deletion.

- Moving the try_to_inc_min_seq before isolate_folios may leave a
empty gen after isolation. Usually it's fine because next eviction
will still reclaim them. But before next eviction, during that period,
new file folios could be added the oldest gen and get reclaim too
early. That looks a real problem.

This maybe trivial since MGLRU itself also may suffer the same
problem when the oldest gen is just too short, that's a much more
common case (For this short oldest gen issue we can solve later).

- Having try_to_inc_min_seq both before and after isolate_folios
seems the best choice here and somehow matches the benchmark
result above, very close to the noise level though.

Well I only tested one cases, the cover letter described a
larger matrix, still all good with this series and I'm not
100% sure how this particular change effects them, I guess
it's still trivial.

The try_to_inc_min_seq call should be cheap enough since it's
called only for one batch of 64 folios, and it's only reading
a few lists for the non inc path.

How do you think that we just call it twice here?

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index ab81ffdb241a..c5361efa6776 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4686,7 +4686,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
> >   static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >   		       struct scan_control *sc, int type, int tier,
> > -		       struct list_head *list)
> > +		       struct list_head *list, int *isolatedp)
> >   {
> >   	int i;
> >   	int gen;
> > @@ -4756,11 +4756,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> >   	if (type == LRU_GEN_FILE)
> >   		sc->nr.file_taken += isolated;
> > -	/*
> > -	 * There might not be eligible folios due to reclaim_idx. Check the
> > -	 * remaining to prevent livelock if it's not making progress.
> > -	 */
> > -	return isolated || !remaining ? scanned : 0;
> > +
> > +	*isolatedp = isolated;
> > +	return scanned;
> >   }
> >   static int get_tier_idx(struct lruvec *lruvec, int type)
> > @@ -4804,33 +4802,36 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
> >   static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> >   			  struct scan_control *sc, int swappiness,
> > -			  int *type_scanned, struct list_head *list)
> > +			  struct list_head *list, int *isolated,
> > +			  int *isolate_type, int *isolate_scanned)
> >   {
> 
> 8 parameters:), can we reduce some of them?

I'm not too concerned about this yet since it's a static function
with only one caller so in most cases it's inlined.

It's a bit long indeed :), haven't find out a good way since the
tracepoint below needs the isolate type and number. Maybe can be
simplify by unfolding the function here later or some other
refactor.

