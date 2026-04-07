Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2EA6FEEF44
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0846A6B0088; Tue,  7 Apr 2026 10:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0355D6B0089; Tue,  7 Apr 2026 10:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67316B008A; Tue,  7 Apr 2026 10:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D47B56B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:26:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 797E18C4B1
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:26:10 +0000 (UTC)
X-FDA: 84631984500.18.C2A519D
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id A37BFC0008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:26:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dqVE8kuN;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775571968; a=rsa-sha256;
	cv=none;
	b=FW82LFoczmOSSSgAo0g4Ei3enTthUWLCNo/euoPGnIJuHmU4Z7fTqwWgC2P1638AUN9LKq
	OJU5Y9HcYbSXHdoKn+QbiQZBFzKFbW0eJjp69KL+6fz4rXyc7+HYE1ppJnJgNH03EE1Hxe
	TKcCCIHDrDBx1FNKyviej4WBp8VKkVo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775571968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGf/r/Eh13w4WKFfDtjUs5rckGZDNQIwgJJqFVJWp6g=;
	b=wXB/XE9gCU8zYOwSU8YJFvxhzsniApAlwCKf/BPhrusANUExCBmpaqW0BqUmpmwFGVsszl
	6hyx0aueksc/tWS8xqaOUJRQYYmbcxoT5lc6D7bUcwlmYoO0r+VwXCWFODlGlPqYRemRdz
	ISj2kJspTb9dvTKkq3J9PTEjbMQQESU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dqVE8kuN;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8d68bcf50fdso304182485a.2
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 07:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775571968; x=1776176768; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qGf/r/Eh13w4WKFfDtjUs5rckGZDNQIwgJJqFVJWp6g=;
        b=dqVE8kuNMA1aW6ni1a3ap0Qi66iQwF+ad7VqDPnlK24isuyGo6RqNhXfi15bNpPQtO
         lHWDoD12KWXP4pxmSJ/mWR8YUXVlXEFmyaykVfPh21/dau6UyyJ7sr+rtrEu5OQtolGC
         RgJgnvQTVuZllBZzh9eqS00icb1Q5rjbBgnYLz3Flhf/wYSKG9JXPI5TXSslyVIIjlrJ
         xokPoVlfn2vLO3mRxFSXx68w4NvmORiIjeywkuon42PLmJc9N34rL1raWhOyyHNed3RY
         lJVQH+yniDAWe8xEp5ttig79FzP1IhoAj5QJGGy200+jHzoaU8vsZt0LHEbRy/nqGLBe
         jIbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775571968; x=1776176768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGf/r/Eh13w4WKFfDtjUs5rckGZDNQIwgJJqFVJWp6g=;
        b=phv4wJBQT7W04pxpzuyWHJceMXgLChShyRx3/3lntSDY4s0IK5IC5ZFH90nAMFqZwY
         nYzybSl0CzSaqxhqfKYeEUSBv94kwm5dQV6f+1+iIQEnIkW3VBIGc2PPk+0nSZgoUW6y
         ghqax6tb8I9/tb4ajtXj8ql9xjroEJGbTPlu89mihYzBnjklHi+HD3CPQDW/x5P5B7bC
         THuyL+gh7hGt5h7eClT+j/THpJemF6zZvitbVSG4Kjb7xpbzipLwi+ISBsE4CQdERXLt
         Uan7r65s2sIjQtnnJwIDB56qG2XZ3Edl22eBtMyz/CDZqHC70og9F5KcvK5zc/FvHTeE
         vN7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZkhgSrO2Y2byMCWZx+YoNlz2MHe3xzNFReqOuW/zW80TZIKZKV9Opyq2fiPxEmewZkqmL0sjRwQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9jfYGbil0isDIHg43dZ6cW6zT9kHiP5kAX3B9oEXyMzdZbero
	fyflR/QG4dum92xIrTGRytR3JG42qgcQUJw2S+zF5MSQAs9Z0S9lIusG
X-Gm-Gg: AeBDiett0oHNJnbXcLYc2LorRIycccRy/AcTF+kN1iAxTnIGzqrV/c7vGoByjpaq6uC
	q54LE40+MlUlJi+gRWN2GrWB5sMWN28PS2NIX74K0HwCrDC+40TbGCHnF0E+jfBzFgng44KVuvU
	AMjvh97qXzQqW+jWnrvlcuICvkRV5/SHnddDPny3Af9Kdc+GebLiFLqTLQ0x3dyCERDEhbw8U/x
	iSkczD3jaAA+vAnZs0MbxL+mPnfboZlkHMEGqPdiwD2dsx5l8S2jsUVPoPL8QWmTWV55JQySdFj
	6pQ8nuOCwP5QLyR1fxopvUAcZFqp8eqeUjvPKRqiZY48h7XtmuNp3do5swxzl/Eyikg+T5Di1kk
	U8hwBGk8pNtxs6WTTlsX5JQHigeYvxDDiOxAxPb4RtMuNa2NgdEo3vBuNiJ+Kf5oBdmk2vaaFbt
	T6++IjBZ1BeMlDYcrzWehkjg2umQIdY1UAIyBRbc5HhOQDf6J3snVDJBFfe8w=
X-Received: by 2002:a05:620a:7016:b0:8da:cfe6:c67c with SMTP id af79cd13be357-8dacfe6ced5mr4740085a.28.1775571967485;
        Tue, 07 Apr 2026 07:26:07 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a8067d16sm1240636785a.31.2026.04.07.07.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 07:26:06 -0700 (PDT)
Date: Tue, 7 Apr 2026 22:25:58 +0800
From: Kairui Song <ryncsn@gmail.com>
To: wangzhen <wangzhen5@honor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"baohua@kernel.org" <baohua@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness
 = 0 or 201
Message-ID: <adUM54W3WYwEFj3J@KASONG-MC4>
References: <7829b070df1b405dbc97dd6a028d8c8a@honor.com>
 <4451bdc432864aebb54f401eee51ea53@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4451bdc432864aebb54f401eee51ea53@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A37BFC0008
X-Stat-Signature: iwbtmmrntyx6zzremczaufqhd6ny51et
X-HE-Tag: 1775571968-979861
X-HE-Meta: U2FsdGVkX184yhQ5DjiipASLfqa3GziXVSIdkWt/aFSCmOisi9WJiq/TQUqkU9dUES244puKLMCPZcEmxBQARkn2xupTAKEXjjvLA46+qXq4/4PFstH9S/YWLAgMkYDLznmfS57DAlQ2bzaGgPe3uvT8SrpHdxPoEF+Xc+2PPImKIWnSnad4Qp+R4HNOme4d4fseNktjEztwKDrbzvrHgbTCoVs561xzDaLIs6EVk6xHW6LJ/1xBilSm9dI6BO/qaokITDEjEKp/Pmh87dXRUVPOcFnYt8pBWdTHkdVzjxMumr1z+ma/TMJuR3bfnFkDmWZfALbZG/FcvyiTOEj5zX9CMFIsG+nvYlHdFuzg3hPbGftaE1Np+YJkISQCdOz9B1Aed7ppLW3UPm4iHF5ngE1zD+U/o8lcg4XYPmmVUh/JLOaC7mZbxIrPuzm2zF1Uhvg6vUCWc8pjH9RiQdsXSjqgB+S5xHMBdirvOlHrag37FEPGGNCclsQ60NLW6+HCoVd/0kgO8x6Kq4gcAqtFkWF4jj48HxNrUspgxYlImv+YizfSZjdid684WvYNjNycldDiZCq11NFn7U/l600OMWcs5crbewjv+P6QbBEzqqaL0OAomkyOxYjJ51yA7OQyE0K6IALJImEc3xO/geSKnmk9yOxT32ZXHnv6wLAxpVOTJbqHwXUQhFA+mlg2IRYk/MuQqCdlRyaC7ENPCPoJHSEVYbhpFClJJGAbGcoc0xvmnQ77rV/SjigbwaVNdrIqLD/5TaxHyc+jQQ0ifPn8lQtrDoLy0DUhVjir9ZYIoe8fdav6D7yt7NgeMZf5226XAYWNCOQ5BnsGqP/KmbLlyaX287EQ6gM4rrtyhBsMnauFWUo+G0HlFAECuZ3RK4HrruzJhDwxAMBdi83zxC3+Y26tDmQHE83vHwMyepZsQPlxBkl8dO+sgkZfSNQpFcvvcCwKpJmvIHEroAZxQkb
 Al7x5KAF
 wDPLvho3hXOfyBtwZbkIm380pk/ME+fbfw1jAZOf+y5rlao7P5Fh16Gy2o1ZKoLD+fwh6JX/lQiWFVHs3cetl9qU7DNCSkH6iJJk4wDWzudhDRbC0Ef7E+bNpFomaJfe9JzE7Zvj0gCAcFTjWT6u5uxU6d02P5IrHRupzvnNaort687vEMXCSV3xOlozyTy1q0qUtR7UW/9amyczbVDcVhiVkngkir/znuz8ooSu6ETO++5CI3x2M2LuPMlkn7mMHrzjfihj0IASP3vWYZYKr4Q248vyxU05RKllR5AmC5V8xvaSI0BWXVve1hOiPknvMcb/QKsQPMcg054QLUHUaCalDEPkQwqhm/apZIVsMfFgrpQlpsY3wCJs8ej1FHhSX5dw7gCDO0rcpMUet7+mK6Zlzu+wrD+NMtNNqredfpVkosDboHA1Tk7r6OWJWRtu8MwhyvIHJbvXNH6nUpJ//JmRo1Wz+tNnu68Ke9QI/tNjwun1FGQT++NFt/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 01:37:08PM +0800, wangzhen wrote:
> >From ac731b061f152cba05b9aa351652a04f933986e0 Mon Sep 17 00:00:00 2001
> From: w00021541 <wangzhen5@hihonor.com>
> Date: Tue, 7 Apr 2026 16:17:53 +0800
> Subject: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness = 0  or 201
> 
> In some cases, when swappiness is set to 0 or 201, the oldest generation pages will be changed to the newest generation incorrectly.
> 
> Consider the following aging scenario:
> MAX_NR_GENS=4, MIN_NR_GENS=2, swappiness=201, 3 anon gens, 4 file gens.
> 1. When swappiness = 201, should_run_aging will only check anon type.
> should_run_aging return true.
> 2. In inc_max_seq, if the anon and file type have MAX_NR_GENS, inc_min_seq will move the oldest generation pages to the second oldest to prepare for increasing max_seq.
> Here, the file type will enter inc_min_seq.
> 3. In inc_min_seq, first goto is true, the pages migration was skipped, resulting in the inversion of cold/hot pages.
> 
> In fact, when MAX_NR_GENS=4 and MIN_NR_GENS=2, the for loop after the goto is unreachable.
> 
> Consider the code in inc_max_seq:
> if (get_nr_gens(lruvec, type) ! = MAX_NR_GENS)
>     continue;
> This means that only get_nr_gens==4 can enter the inc_min_seq.
> 
> Discuss the swappiness in three different scenarios:
> 1<=swappiness<=200:
> If should_run_aging returns true, both anon and file types must satisfy get_nr_gens<=3, indicating that no type satisfies get_nr_gens==MAX_NR_GENS.
> Therefore, both cannot enter inc_min_seq.
> 
> swappiness=201:
> If should_run_aging returns true, the anon type must satisfy get_nr_gens<=3. Only file type can satisfy get_nr_gens==MAX_NR_GENS.
> After entering inc_min_seq, type && (swappiness == SWAPPINESS_ANON_ONLY) is true, the for loop will be skipped.
> 
> swappiness=0:
> Same as swappiness=201
> 
> so the two goto statements should be removed. This ensures that when swappiness=0 or 201, the oldest generation pages are correctly promoted to the second oldest generation.
> (When 1<= swappiness<=200, only both anon and file types get_nr_gens<=3 will age, preventing the inversion of hot/cold pages).
> 
> Signed-off-by: w00021541 <wangzhen5@hihonor.com>
> ---
>  mm/vmscan.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..54c835b07d3e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3843,7 +3843,7 @@ static void clear_mm_walk(void)
>  		kfree(walk);
>  }
>  
> -static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
> +static bool inc_min_seq(struct lruvec *lruvec, int type)
>  {
>  	int zone;
>  	int remaining = MAX_LRU_BATCH;
> @@ -3851,14 +3851,6 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
>  	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>  
> -	/* For file type, skip the check if swappiness is anon only */
> -	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
> -		goto done;
> -
> -	/* For anon type, skip the check if swappiness is zero (file only) */
> -	if (!type && !swappiness)
> -		goto done;
> -

Hi, thanks for the patch.

We have a very similar patch internally, and the result is kind of bad.

Currently MGLRU forbid the gen distance between file and anon go larger
than 2, which mean with this patch, when under great pressure, you may
have to keep rotating a long list of the opposite type of folios to
reclaim another type.

For example, when you have only 2 gens of file folios, swap disabled,
and there are 3 gens of anon folios. Anon folios are unevictable because
there is no SWAP. And file is also unevcitable due to force protection
of gen. Consider anon folios are mostly cold (at least a portion of them
are), now the oldest gen of anon folios will be very long (e.g. 12G,
3145728 folios).

Now, to reclaim any file folios, you have to age first. Before this
patch that is usually fast. But after this, it will have to rotate
all 3145728 folios to second oldest anon gen, will could take a
very long time.

During that period any concurrent reclaimer will get rejected
due to force protection, result in very ugly long tailing or
unexpected OOM.

So I agree this is a good idea in general, I agree we should do
this. But better defer this until we patch up MGLRU to remove
the force protection first.

But I think it might be reasonable to remove the SWAPPINESS_ANON_ONLY
limit now, that can only be triggered by proactive reclaim
which would tolerate long tailing and won't cause OOM.

