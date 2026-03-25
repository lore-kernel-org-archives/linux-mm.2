Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB58106B539
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:36:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2986B0005; Wed, 25 Mar 2026 09:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63636B0089; Wed, 25 Mar 2026 09:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58726B008A; Wed, 25 Mar 2026 09:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 952376B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:36:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48AEEBB8DD
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:36:03 +0000 (UTC)
X-FDA: 84584683806.22.DBCAEB3
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 48C5940005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:36:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j8jHlBfL;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774445761; a=rsa-sha256;
	cv=none;
	b=irF+rSSJYimjnpW4QLuOXfDA4xeE2fkxeXXS413STh7Fc3thjiRq/BNGPPD4iWMvaMjVyD
	H2ldfmf1yusSXSzczT8dd+E96cwrj4Iis1i20gd25YgnOZywOVMYH/ZahvAaJHUXSzgZRT
	l3cUgRFcAomBamU4lgGWNrRjvO//yoM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774445761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eThIFmdDZ6GA/TY9CLE+OYHs4lQLBCugx54z8nziAIY=;
	b=Kf3VcFoZvNoVKptwwh/gLiVolSZGaHir+dVKKd5oqcIj/w38iM+bVGxTBd+wlGB9JuWquu
	nwwVacXXg3rNJSVYtts1kQ0/5zeJmRNVg+DynleRNXu2/jkdLXcSln6lCPHhMX6n0ds2/7
	Qbmdkbk/PJ3XD21t3r/5OXJeCZ4mBqk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j8jHlBfL;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35b98def50bso4651432a91.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774445760; x=1775050560; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eThIFmdDZ6GA/TY9CLE+OYHs4lQLBCugx54z8nziAIY=;
        b=j8jHlBfLbrG/BcxjEDM1cStA81OEix1xdfj9XmHD22KcHWamhgc1jlVCGpL/J5AWgj
         IMu17ff/Yy2YtuRuIFZhMhchzLcENAv+hj8KdxTnXQwR37ru7Gg8/y9eydscj5x1qIpw
         K0f/5VkAR3Stm2gnw6fJOiKjT85YHA4pwRAZq9IoJ8YTGuC2WnlWnopeS2ttWsqR6t4q
         Hn+e5v0f9bcy7+koN9VaVSTzVPtUt0ibDEdiYKiAV/6CvhaA9nI9R3/1ikkjD196KVca
         OigjbFVbU4IsMicRugmZNZ0Tw08Su6vaBbwUEUvuFMkZ6uJ9ci8RZHu8M++svGJyFYdQ
         Q4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774445760; x=1775050560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eThIFmdDZ6GA/TY9CLE+OYHs4lQLBCugx54z8nziAIY=;
        b=Nfh/ry74e3kp4EvOcz+LkOy+9qCgpP7Jp9d4e8aQxzDdHPkueFNsl9a7iEgXSgPgxU
         na0vlfpjSc/wKxkINiHfaiyL+P0jHKU9pugk6TMCbjzd9ZxZkjKNO3JvVzxKbGodEcnC
         V+VKLATYLUSUB+xmk4dUHJ8s52y65zHv5gZdixuOeHQa0m0Lg7AnZAKROaJrqZks/B4o
         6YBmvg+Epaae6cxa4ZgGxR5V7elWEmrgoCKRldVo3MdENgwhhy2vNxZqik/tQDbwV3tS
         A6ZI8fBoBxd4L1IvbbRJH7kCeOjpWp9VL5XuKlOu4hAcxFhJ778+mWoUy5IzsqAU10Np
         gzUA==
X-Forwarded-Encrypted: i=1; AJvYcCXoGeuTuiIBrf5x4wNHtPH3N8NCShSBCg5K45uktE4JJ3E9/WzMny6A/BW7HlyFUWIeY+5BoIfPkw==@kvack.org
X-Gm-Message-State: AOJu0Ywd1rdJvadPgcKTsTHa2Uvl3eRH8NpwopkcbUEWf9hnY700FU5b
	HYZbD+tdDl1lPJkYwCSQTrTYH4Op6W1FpbK5eemvQWOo8eWFooSSYoGrE1941orAq1B7gg==
X-Gm-Gg: ATEYQzxim2p+zBET9H4U3WpIc0rkIBZ3Wrhp6QpjCSYZ4qtE7hTwCf9+bXlLXGhs+Sq
	jCPfiVVzf0jelbwOf3tQS9OR58+qDqFb9JY7zexqUSFSr7fDNYm9uitVOreyN6QcVOkLdnUnwI2
	lrrsWGkHsfIU8Lpm6RUBy/w3NeTShHqPyQ31MW9o30nyxB2pdNoysck6IsYCwrH9A3W/qib3tB2
	k9huDQi7haZ2ps2Kvn4y4Z35kk41QBuyKwQPIdfUmN/axvSGfuoWHbNUBMxiEdbF01iidT8YIVA
	1VFv6Pg6xPtCv7JSrZ1GnxTO94JF74Yh/FOXUTmcGYEc/sWBP1Jaq0zvFiqvqOEPTlZkSvW1mCw
	6VF26AMg6axB0C0cZCBGbm/RviRF0n0rZnBSw859bLb1JeqLobbkNgOnRWU7ZcunvM4/WjMc+nU
	6CWhW6XmBlwoybCuyt1neAlRKJNYPnrx6jEiLJW2r7Ow5Wit5bTVHbCVU0wUkrJ4Fvuz1vaw==
X-Received: by 2002:a17:90b:3890:b0:359:8c89:96d3 with SMTP id 98e67ed59e1d1-35c0dcea990mr3617911a91.15.1774445760047;
        Wed, 25 Mar 2026 06:36:00 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c03044d04sm7798070a91.0.2026.03.25.06.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:35:59 -0700 (PDT)
Date: Wed, 25 Mar 2026 21:35:52 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baohua@kernel.org, 
	kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
Message-ID: <acPkASQIcn4VHHjs@KASONG-MC4>
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
 <acPOn07xah2eh0WU@KASONG-MC4>
 <f3d680da-7480-4d05-ac44-e669e0914a32@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3d680da-7480-4d05-ac44-e669e0914a32@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 48C5940005
X-Stat-Signature: wug3nuksoo3hs65pcysohe3xjz1ouwdi
X-HE-Tag: 1774445761-852075
X-HE-Meta: U2FsdGVkX19ro63R7kWmbbSzk2DC88BOvlFrEKUJQyWbpHGR1zWupQ/sHoY4fMo8iMn6Ya+ftC8I10r1l9d2NaQFLQzxwiXUWUwtdpDKAnrvkRsMc2yp57LO+fcXKv7SUm3iIY+LBzeHnScVs6sea3Psp6WLICJmbiFQaREyw2YLw8PvMVuiELjpjokFJyNnFd4oqScmZIzvtK/ZmxStKLfhGZtx/1JbcN37TU9hfAQ3uFLoB7XJSM8u47Z6c2d1v8tnAppcvVFwN7XLWUrblL2D9vutGnnwgQ74BDOLoc7r2rzPwaN/gFyi6qjy5lTNjgkJDuNYx6/2A8Uf7kSQtEJqIxAdhjzLBFTOL45pJoZNOgudxbLyzMZRTxwMHpIQAQA2gn2X8rN12brBfZMCJcLvkxzBWqgSigu0T6E54A+hdPStDZinrJ7T0CG+7cZ9dpAPp5C7Y/jgTWL/uiPoZFQeFQyC421Ls+eSou+XMhyLJpglR6v0FNfy3/7j2b0wfxlhc/L9JiicdGmc9lOLX5Cl8zPoSwMwqC+cBP+kuwEQqCH1B3oSKThd9n7RgvgMrEy4rYW6R5g9RAsHau/eJN9f70NOnckLG+BIOJ+KvKI/bPTCXfwhMlxowmI7+RSGMUmlIZeuWzN1LhRim2jdvCa66ebJu5YVObu+Qk7eJpm9EFhvsFJWuCF99PmRhlMPfhV2MyMcwMnVqaSG6tfT4Z5O3VEwAFZ1zzRL7NPxsT/aQdjgAVUu/tVs/9g4zN+WWZGkJ3hgPHhrltEkgvk5x2y0Dd8u71vtrK/m0hZ6pPJtshThPRnYfcHIwu3sVQ6qNNtq0cPf3un3YxW+uVo7N1CttplGlok+Ju9heAX/Hne7pNbiSLQGPNLeZAzNHQZAsphVHmeDRMzlXHOaCsQHPB+7zY8lFy9hDx+Z/FfXgD0AI1WJRdvkUjB7Txnup1UIE3Zuk6v6VMbnTGz+LSF
 2DZbtJNF
 uRvdxN6mT+HFL8GYtiq9DOLB5Te/Hm/DIJLd/Q7wrK56P91p5tNUbOuBwV5qUuBmNppqZDhBLwNkqSeWjJvwBdWA7QUgztGqeBGyl9vPP/hDcnX2Io5HwpyWVpvXMuEtmze00qLEtOJZXeK2zZj4q/6GSoXwGkxNN5Ulaew7qfhyrxmNF9oPb/jaH+AliCxqFg5V9RXomycF1uUaV30Y7vPeJroO0c2doWpbWLFF7GGJBI9vUMXoeDkoXQjRhuVtGVX5If/Brgpw9fI16625UBpktk6UEKkP/wpoRX7beNVi/C4Mb9IYg0tK+RDxw/mkiWIjQfMxRZHxQqbmhhFBo35DrNY/WYXRrVPZkkMqi4yX9jEGNlJVp3HxlRZrpRLzxaUtebhV7U1oMjZJAD6bWqR/vH0fBH0Pq5m4DjTLMgLCMhJBPBxJSMI9PxKTsrnWunTfwUvkqEk10AUQEHbWDb5FYflt3SlB7B2eqBsxtoKIjq5MPGMPRVDf0iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 09:20:55PM +0800, Baolin Wang wrote:
> Hi Kairui,
> 
> On 3/25/26 8:07 PM, Kairui Song wrote:
> > On Wed, Mar 25, 2026 at 07:50:40PM +0800, Baolin Wang wrote:
> > > The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
> > > See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
> > > on traditional hierarchies").
> > > 
> > > Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> > > longer attempt to write back filesystem folios through reclaim.
> > > 
> > > On large memory systems, the flusher may not be able to write back quickly
> > > enough. Consequently, MGLRU will encounter many folios that are already
> > > under writeback. Since we cannot reclaim these dirty folios, the system
> > > may run out of memory and trigger the OOM killer.
> > > 
> > > Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> > > which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> > > pages throttling on cgroup v1"), to avoid unnecessary OOM.
> > > 
> > > The following test program can easily reproduce the OOM issue. With this patch
> > > applied, the test passes successfully.
> > > 
> > > $mkdir /sys/fs/cgroup/memory/test
> > > $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> > > $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
> > > $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
> > > 
> > > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > ---
> > >   mm/vmscan.c | 13 ++++++++++++-
> > >   1 file changed, 12 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 33287ba4a500..a9648269fae8 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -5036,9 +5036,20 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> > >   	 * If too many file cache in the coldest generation can't be evicted
> > >   	 * due to being dirty, wake up the flusher.
> > >   	 */
> > > -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
> > > +	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
> > > +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> > > +
> > >   		wakeup_flusher_threads(WB_REASON_VMSCAN);
> > > +		/*
> > > +		 * For cgroupv1 dirty throttling is achieved by waking up
> > > +		 * the kernel flusher here and later waiting on folios
> > > +		 * which are in writeback to finish (see shrink_folio_list()).
> > > +		 */
> > > +		if (!writeback_throttling_sane(sc))
> > > +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> > > +	}
> > > +
> > >   	/* whether this lruvec should be rotated */
> > >   	return nr_to_scan < 0;
> > >   }
> > 
> > Hi Baolin
> > 
> > Interesting I want to fix this too, after or with:
> > https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/
> 
> Thanks for taking a look.
> 
> > 
> > With current fix you posted, MGLRU's dirty throttling is still
> > a bit different from active / inactive LRU. In fact MGLRU
> > treat dirty folios quite differently causing many other issues too,
> > e.g. it's much more likely for dirty folios to stuck at the tail
> > for MGLRU so simply apply the throttling could cause too
> > aggressive throttling. Or batch is too large to trigger the
> > throttling.
> 
> Thanks for sharing this.

Hi Baolin,

> 
> > So I'm planning to add below patch to V2 of that series (also this
> > is suggested by Ridong), how do you think? There are several
> > other throttling things to be fixed too, more than just the
> > V1 support. I can have your suggested-by too.
> 
> But I still think this fix deserves its own commit, because this is indeed
> fixing a real issue that I ran into. Even if the throttling isn't perfect
> for cgroup v1, it aligns with the legacy-LRU behavior and is essential to
> avoid premature OOMs firstly. MGLRU dirty folio handling improvement can be
> done as a separate optimization in your series.
> 
> Anyway, let's also wait for more feedback from others.
> 

Sure, fixing this first is fine to me, just saying that you may
still see unexpected throttling or ineffective throttling with this.

This is no conflict between these two approach. I can rebase that
series on top of yours, and that series would help to solve the
rest of issues.

