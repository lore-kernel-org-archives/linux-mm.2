Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB99606A333
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oui3YcWg
Received: by kanga.kvack.org (Postfix)
	id CD5206B05B4; Sat,  7 Nov 2026 17:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86976B05B7; Sat,  7 Nov 2026 17:00:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C9B6B05B8; Sat,  7 Nov 2026 17:00:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95EEA6B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:00:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E73180280
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:00:35 +0000 (UTC)
X-FDA: 85409692830.13.3AD2653
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C9F9280005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:00:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oui3YcWg;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794088833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJGz7I7p/AgQ7qim32bWeDztlYgVQCLK2LaoTD7wEVw=;
	b=p14lRgRXgtPWLvvHOI8cJY9uRmE2NOFC8q1qZ0iMV+41ABIeoZ2jc1uFLKYWc2Bn5cpwkF
	kJ85lHjzXNgNJi7hCbn2zoIvz7r5rqkUeXxeh9fu6XSwWeDQw0uLcIaEaC0HIKCm2ZoIB4
	MeEJxuhQ8tm38nHuAynzpr3RigRU/n4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oui3YcWg;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794088833;
	b=qgOMncGapapNaWs1S7P7B4BhUiH5XF1576HOTuYaDbC1ZqqEgHHP3KtPyZfiykAbjkorKZ
	ihc/ndBQ3GzZZbmz5NDfjnLc49k4L/VO9+QIKzOlRh2tnDEIfDpgp46z6w8Y7S5VtHJiix
	TSTDFcdDAWivFGwwaIM8y7YrpvR4hbM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C83161223;
	Sat,  7 Nov 2026 22:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8911F008A5;
	Sat,  7 Nov 2026 22:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088832;
	bh=YJGz7I7p/AgQ7qim32bWeDztlYgVQCLK2LaoTD7wEVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oui3YcWgTyHT/b1HeHr7nKHqzAN+cTjrI839oHsP4imLid3duglI+zzqrfXWPG1g4
	 nT9CGhvde8GTdv2lnnU/2PJmbieoexL9pbaytkgUX8BESUuWZLdYCAUhWSAwP0pTOD
	 hZQ6IZq1+hlqoj4ptMAMAigbhhA+G8qtkV/qc9K2mI8tRgsRH3N9d+gsQLdNg2jNJL
	 T5PFMZzZQ8KOLtc7U6p+0B3gPsYSSdGbypAl/KGVya8JcktErSwVIa13ijS5AvxQaE
	 B6aAydbkVFh1dzgvahkPN8uMogbkVwiH1JI+D7S9g7k9EMggjHvIEV+XI5DD8XMA+R
	 yhqOFmzIzg/1w==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6.12.y 1/5] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  7 Nov 2026 14:00:24 -0800
Message-ID: <20261107220026.304899-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203347@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x46iw5abns1h5mbgzfuwebyyi88kgrxj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C9F9280005
X-HE-Tag: 1794088833-137794
X-HE-Meta: U2FsdGVkX1++X2MgA7cEJNYXgvAR35WmA13cXL+OiFonSovHGCgIhgHtAuf2Henusc7Mh8ZxAzzQrw8qyJQCX0/q1hA0jW5bsbxQ6DQ8+iZiY6W/Qx2HoS9LzVXK2Cafqy2eayi6GITYk3ds9ksY8qsCQXLFBCvtDPGTvVYxYjyEM1AONCgkZ/aeQG+RbjSWbhDoMWrJI+TA+5BiH2il8lQQv3bA27g9GzQsVwUoU5wTl3tsTg9yk4kuivtyn9jfxTQzzzTb3CzIbevC54MLR/0tL4ON70EdWnD79qg3iuFZZdNVzE6AEQAeIXTdU183+szaGolZ1au0ze4EaH9Xg/uA+Ul/w45Q9Uq0jcTm4vDZzEZ0jXT59PJPTeNrIXSAuNq7EKkpoEKp5r6McJcUR/z+Iva+vv8X/FLXb1WvLg15shIc0efsLpTLefj7MHHXUH+Kr52g9kp+0a9SLK2vpa93g3na/1Pn77n2fCvYF9iG1RyM0JizKQQPoCwojzfrUXtcuqGnUJ80OR5YGWaUai8Nx6UlInZZt6fRerVdIaAIKQtVckt557uDkxb1Kc5Vkgc8q+SmJoA7eTgUvtGzoQ6UHqx+WbnZpaho0qp46bSEnTnWAVLCDv5YDl2MNNbRjg0OuapkMEbpU+Fpg8eUROmOi3U+g8OHMiXxKgx+eLubvFmqxtWM4qqV8gjOxDH5OFSd2lwGT6GdDxGqlgcQ4BcNPNrh/xU1ulbqf626FsUqBBkKzsLVlerxEcAlp3UPSlBIDVCcsjYm7uWjdkYFCxQhf1daFJGQXOyIkXz6YxlztRKcYH6KUVsVPQ1Ilax+bLkh+IxUdBwoPmp8a6pkKCQuhpoB6o9FxAc5BNzUtrRr6N5hZ1HAAN1IFXKDTLSZ7IS+ngqU2ZyPg64omlFX3da25hHgT44qCRb2L+H3//N0SOM92frsac/XkLg0OzvNb2wH6TTKI1IMtmWGe3Y
 73k967Af
 F7pRDWlCC2s8n5px03G1zKxtgQJMv5feNBalJ6Ddz2073pG52mItMvXSLsQhggwloUhImSxH2BCY8OZS1yoRI+9MHjZa/zBh4Vritr6bYLW+YZAD7oBdzDrcpu1hXaysXYovF/3fsn3hExB9zDKOhx3H7lDyjBvzlU9sqCZKVmxeeEKkBPgh98PLRzlUnXnRhWMn9slQXyVbnQJzym4jYcLMXRKBsijHWHqVQ3s4RYinCjkAJVcyPG+ULoN4B0DLspf9Fu6Zq/N2DIpjn373OBCWuu/IKgG4wkeaC/DqzI0W+oveGJlhrg7MKG4pdS6DbBhhr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 21:52:35 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/damon/core: inaccurate tried stats on split failure in
>   damos_apply_scheme()
> --
> 
> commit fe019f891ca813eff979dfc83e95ba297bc45135
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: skip applying scheme if region split for quota fails
> 
> This commit changes damon_split_region_at() to return an error code on
> allocation failure and skips applying the DAMOS scheme in
> damos_apply_scheme() when splitting a region to fit the remaining size
> quota fails.
> 
> Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
> Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
> Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 81d44e41de210..6ef77741b783b 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -1470,7 +1470,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  					DAMON_MIN_REGION);
> >  			if (!sz)
> >  				goto update_stat;
> > -			damon_split_region_at(t, r, sz);
> > +			if (damon_split_region_at(t, r, sz))
> > +				goto update_stat;
> >  		}
> >  		if (damos_filter_out(c, t, r, s))
> >  			return;
> 
> [Severity: Low]
> Should this return instead of jumping to update_stat when
> damon_split_region_at() fails?
> 
> At this point sz holds the non-zero aligned remaining quota, and
> update_stat calls damos_update_stat(s, sz, sz_applied), which increments
> s->stat.nr_tried and adds sz to s->stat.sz_tried even though scheme
> application and filter evaluation were skipped.  Because quota->charged_sz
> is not updated on this error path, persistent allocation failures across
> subsequent regions larger than the remaining quota will repeatedly add the
> remaining quota sz to s->stat.sz_tried and increment s->stat.nr_tried.

No blocker.  The user impact is minor and  constrained.  Also same issue exists
in the mainline.  If we want to fix this, we should work on the mainline first.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107214525.304638-1-sj@kernel.org?part=1
> 


Thanks,
SJ

