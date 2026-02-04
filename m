Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85466E83EF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843236B0096; Wed,  4 Feb 2026 04:25:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804436B00A7; Wed,  4 Feb 2026 04:25:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF836B00A9; Wed,  4 Feb 2026 04:25:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 597BE6B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:25:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B594113B865
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:25:08 +0000 (UTC)
X-FDA: 84406240296.06.58791FE
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id AE5F44000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:25:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dyyzn0s3;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770197106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vRCdO0bXpcykxF+oz49o7od5GWLyt8pzJaSR709p2I=;
	b=xesCIZ5pDHLdoah4pQ45L1NARnQpp09Bx1Mi5i6IdcgIVtehESrPm2jfVlax+os9ePgIle
	xg1wuXjd+zwHA1HGiba9QCzrFfrcuuDa0WanwpqPuYQ5kRUfIbIb2PVR2/s9rOIx0p5o9M
	62NMx6ycQhZ0tr5lg++1c0TmQkAa4rU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dyyzn0s3;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770197106; a=rsa-sha256;
	cv=none;
	b=rHqT8NA2CUrxaR4KHrMv9z4E+AbaNYSpmjsVy5oGaJXRSYCNViyT60YAxJyf/IPzJ0a0o/
	zNIXwVCVHO/iW+JTXk/ub+lt9AW5cwRDHy99FDA2bF1IlY3A6+p4h4IrNy39ivxBknGeiq
	2TIn9h8VmdUAsxKM1vu8LlkeCo7CevQ=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4801bc32725so51061975e9.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 01:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770197105; x=1770801905; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5vRCdO0bXpcykxF+oz49o7od5GWLyt8pzJaSR709p2I=;
        b=dyyzn0s3wad4fSmOczCBmBCgDjkO0a+qkHvIc7lOfdGKG7cDVEXasWvBDHxXWSa8CD
         fJ5u/AyMP4xodorjPh4LC+KyTE6tgsYX9omtuBGAFf5sW2+qNA5xutXVXWpRF3XxvLJ+
         HoFP/Lk5KX62If0Ip2ixycvhhV5BF+/+c0EKulZMnp8qttUUdDjJLjwE4iRF5HPZZYzL
         Xy6DxLVyvfCAX7ptl4jT1H9uGy+VEZGXZ2cRESaopgpbld1rZZzOPLwMy7qd3/ia1km7
         T18zXvabGsSjHJspOw85+Yfg1X3stMg5xnw37xvrKpT8wDHpqZZRSeQOAWAWrLShBOIy
         rqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770197105; x=1770801905;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5vRCdO0bXpcykxF+oz49o7od5GWLyt8pzJaSR709p2I=;
        b=RTeTY0tWB08VXHZnhgZe0TirN40XqQuPmW6CCAQjNwwctGDKLUaORa0m+B67xuLZTv
         3GBmD/QUiBJq21s7JLmcC6+Kv09sObDG+P2obUFerkIJ+Hba/6wETxoKgVXylP+BJwAe
         qL7NfJb1FyyqXSXayXauRF1viG/pyUL7hwxrfuy7tXDkKR6rKQC9VVOCofQ3X9JYJtkE
         Nqg0TeR6mqxLG4RZ+/WKUrTbGM/69SHHM02clZDgJDt8ENFCod3ulP2mfm2+KwNSmUQJ
         CLqJztrXKwJYxgEDgIUbuoLVdPad/NHqwdgpw7nhSjJFnUoJvoChNgGRNAR5GyhR6OMu
         wduQ==
X-Forwarded-Encrypted: i=1; AJvYcCULdl71gY0jvpspElSuuFC75g3h7pg0GgKHTGstt75gzKhmQp5PSP8gvkzJwPQOS3Z1aVHJd9oV4A==@kvack.org
X-Gm-Message-State: AOJu0Yymj4sHHMH0xvNTzeO0avXSEmfnCGHGdfsEgEYrT3VWUgSsC4Vn
	rCeWuVNu4GMLAQcGXGnGx7roVmcvwyRsuZ8iYATX8+IGA4pJX5MqIT/7KjMtAcfneFU=
X-Gm-Gg: AZuq6aIYkr8uVXxrvCqdJlhntj4UUI/hsLkGCQ+i8f2MyQBzz+UDzlIXdXbFqaBQATH
	yGujyAeuqj+ugdJchyMavueJYu/o4IMesllxT/vdierSHNz5bfUb9J0r0NrDPSpxWgsxl0bcYEL
	PmEYxiVRxCufZFBhAA4lUuDUHvX30kLatpZqycsPJY9nETd4TOOmkQeLklDyPoXzDRfI1f3RXdu
	41vZwIVMqf7zBt/XojsJBODzr5aALIbKMrGlKedkyoaN3Qql36eixx6IYo0R7hAbNP48QQGv/WG
	QLnz+787BPb2Ogg+GGyCdZq7/c9bxPIy2AXNdBd70KbIDxPOxhoBfjVAQQQ1l2ODm9KJIlGayiU
	qNzAqX1c/dfiwPZWv/7hRUV/h4lfV2xZAm0OTgv48jljV4Ygilelkmcs7PsxTSd7Bf6nCp+rIgV
	WSkDGWKBwsfUU79N/KiFH/DSRc
X-Received: by 2002:a05:600c:c48f:b0:477:214f:bd95 with SMTP id 5b1f17b1804b1-4830e987c1dmr26960685e9.23.1770197104984;
        Wed, 04 Feb 2026 01:25:04 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4831088d318sm51779665e9.10.2026.02.04.01.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 01:25:04 -0800 (PST)
Date: Wed, 4 Feb 2026 10:25:03 +0100
From: Michal Hocko <mhocko@suse.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aYMQb9JTPXTutgvH@tiehlicka>
References: <CAC5umygEq6xvpDFnVnDLYLyqJV7qChEsJ_+W-KCBJ+EXj1948g@mail.gmail.com>
 <20260127220003.3993576-1-joshua.hahnjy@gmail.com>
 <CAC5umyhqbW_qXaApO8OGg1wo706GfVPuak5JwdBfBgS751Ka5Q@mail.gmail.com>
 <aYCiboGiXO2lQC0W@tiehlicka>
 <CAC5umygW8PXnS5tix-DfujhPjrRjBaEKe8ojW=y5FmqhqBfurg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umygW8PXnS5tix-DfujhPjrRjBaEKe8ojW=y5FmqhqBfurg@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: a1w6n8or8ifpsp9dr4m5tx9cnpnmpuu1
X-Rspam-User: 
X-Rspamd-Queue-Id: AE5F44000C
X-HE-Tag: 1770197106-868525
X-HE-Meta: U2FsdGVkX1+9Y6Amo6BP1nUhAeVGqrJtrMtmIya77yiC/lGNyEZORAMoCimWqp9xf+6VVEyrHZ4umdR3Cg618bGKgyO4UGPgAynUzJQvDR/tIi1myMmcMguTFtve6ylxGsGayAui3xuA3Kb23ib2vzhCVDQSxhC1zL3klvC/0xqp/si0G6jCct9kt4mdfkNFFzZ+k0h7xB+p/Owj9owH2jZjTdAU/g0r1c8Y/XxvpwbQqWdqPTvsTAueLgDn/OUJod7oVPiGcGG+TpzgZf/nEZt+TpOEQV5GRmJQwzxhzy2Ele6CfQNR36DpqJkHgj9hSi1PqDUfJGaJT+ba4ZY8Qf/K9P7m2L4R2g0E0oCGKplYXrQyF8UUaeoNjsjnLnjPUpZj0+7RbkGohXHABW+Xju8KeHjCscU88Ro1FAifLMAYfCCPzzrbBmHj6YGccW+xG0RehKD8+j5+mvfY754jBXWE4ebIFM9Fq8gJupTKVLp1YTHy4OT7lXqhW84lKbIq4wiXmknQ513pVPflceXTaHk+kE+JNiudDi5AIat4sJNs8wSRN4z0a9dieo2np2CqXPpFRGEpHOjDKNI8YRtwRd4xqRXWs+KBiNoU42Z9U3H89iRK3APSbc2GhwQuFikDSGteOrRriLmoxdtZVRcUKrxPy9SU3rEsSW5o6yEEVsGFKPiH85wDbZmsNOv/Z7GT4345fl4z4GhejYDNjvA2+ghBAx9sFxGCn9VptPfmtFW6Bmsb0maPL8J8EyKR/M3YDhoWQJVIFs09RqM9oMqPuGmzDX2wtAXzg9OFpKAmRD2y9lKor58TVqI34KPfHIPW0N05VjGrT0OHssw79R7A7QJId6jTrQBT8sDDIlUntZkPTC80L3wu1oO8pELOr6/tCZD87JymlLFh6kVj7dmN4HNWeha6PiY0D3ZRPFMMO9/MmrAhdoSSZMOt24HbHIrz2fiJpT6KG196kwKBpF4
 No7WnvHU
 lmjc5h63gcqHIGjxZHNUXnvhlTaFVkexhFD3DznO8QG1EGHVOjLzjRhx63tWeTlxjDixv0EGupWB6uUVocH3kfNClw7aBq/KyZXBpv9oSFWVqZjQkqklEhcsHzumbViVlKNtZSD7/QXMe3Vq9Af33QDPuQbcRQ3oRkn5h85ViGwCqNsKRl37scjyfV3pW8vfT9nb5vA6xRxL41s0cvLBnWfEeLrjeXKuJ3p7aaGYjgri8DW2QkQIjGPUuyzNPR4H5aMFutUOgHTS0VfHZECQH+8vkB5/oABiJtknZcZs3mezTsNy4Ns4OW7xl2PYEF1WpSoJFcpQzGuY4YqtryQ/ZapMEiJRXezZh3qIfJ0ThzB8kOl7LroIazIte3mWPBSDsRioUOCRk/Hrr9usbKnKlK1iiMJIfo2hMZqUUiTg1yraigcUvjggwGJQmGbOuQbqRCpdP3aHvAUTAche0FCLpP7a6CdD4XFxkaChhPhzifjlAnsEP6BcZQ4HL9tTkbWcziadSAqysjZ7EEb4DjTPZ1iL8VydCvJ1mjsdx2apyDD+DgS9CC9K7/RkGUhHlI6Dj20Qqmrq97OgvhLnlVZIWez+hkgA/HV7zfqJMqtMzgWxBRdIP/FMcFeqTFOwO7JyvPkVQ2H5oRZax3Ec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 04-02-26 11:07:03, Akinobu Mita wrote:
> 2026年2月2日(月) 22:11 Michal Hocko <mhocko@suse.com>:
> >
> > On Thu 29-01-26 09:40:17, Akinobu Mita wrote:
> > > 2026年1月28日(水) 7:00 Joshua Hahn <joshua.hahnjy@gmail.com>:
> > > >
> > > > > > > Therefore, it appears that the behavior of get_swappiness() is important
> > > > > > > in this issue.
> > > > > >
> > > > > > This is quite mysterious.
> > > > > >
> > > > > > Especially because get_swappiness() is an MGLRU exclusive function, I find
> > > > > > it quite strange that the issue you mention above occurs regardless of whether
> > > > > > MGLRU is enabled or disabled. With MGLRU disabled, did you see the same hangs
> > > > > > as before? Were these hangs similarly fixed by modifying the callsite in
> > > > > > get_swappiness?
> > > > >
> > > > > Good point.
> > > > > When MGLRU is disabled, changing only the behavior of can_demote()
> > > > > called by get_swappiness() did not solve the problem.
> > > > >
> > > > > Instead, the problem was avoided by changing only the behavior of
> > > > > can_demote() called by can_reclaim_anon_page(), without changing the
> > > > > behavior of can_demote() called from other places.
> > > > >
> > > > > > On a separate note, I feel a bit uncomfortable for making this the default
> > > > > > setting, regardless of whether there is swap space or not. Just as it is
> > > > > > easy to create a degenerate scenario where all memory is unreclaimable
> > > > > > and the system starts going into (wasteful) reclaim on the lower tiers,
> > > > > > it is equally easy to create a scenario where all memory is very easily
> > > > > > reclaimable (say, clean pagecache) and we OOM without making any attempt to
> > > > > > free up memory on the lower tiers.
> > > > > >
> > > > > > Reality is likely somewhere in between. And from my perspective, as long as
> > > > > > we have some amount of easily reclaimable memory, I don't think immediately
> > > > > > OOMing will be helpful for the system (and even if none of the memory is
> > > > > > easily reclaimable, we should still try doing something before killing).
> > > > > >
> > > > > > > > > The reason for this issue is that memory allocations do not directly
> > > > > > > > > trigger the oom-killer, assuming that if the target node has an underlying
> > > > > > > > > memory tier, it can always be reclaimed by demotion.
> > > > > >
> > > > > > This patch enforces that the opposite of this assumption is true; that even
> > > > > > if a target node has an underlying memory tier, it can never be reclaimed by
> > > > > > demotion.
> > > > > >
> > > > > > Certainly for systems with swap and some compression methods (z{ram, swap}),
> > > > > > this new enforcement could be harmful to the system. What do you think?
> > > > >
> > > > > Thank you for the detailed explanation.
> > > > >
> > > > > I understand the concern regarding the current patch, which only
> > > > > checks the free memory of the demotion target node.
> > > > > I will explore a solution.
> > > >
> > > > Hello Akinobu, I hope you had a great weekend!
> > > >
> > > > I noticed something that I thought was worth flagging. It seems like the
> > > > primary addition of this patch, which is to check for zone_watermark_ok
> > > > across the zones, is already a part of should_reclaim_retry():
> > > >
> > > >     /*
> > > >      * Keep reclaiming pages while there is a chance this will lead
> > > >      * somewhere.  If none of the target zones can satisfy our allocation
> > > >      * request even if all reclaimable pages are considered then we are
> > > >      * screwed and have to go OOM.
> > > >      */
> > > >     for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
> > > >                 ac->highest_zoneidx, ac->nodemask) {
> > > >
> > > >         [...snip...]
> > > >
> > > >         /*
> > > >          * Would the allocation succeed if we reclaimed all
> > > >          * reclaimable pages?
> > > >          */
> > > >         wmark = __zone_watermark_ok(zone, order, min_wmark,
> > > >                 ac->highest_zoneidx, alloc_flags, available);
> > > >
> > > >         if (wmark) {
> > > >             ret = true;
> > > >             break;
> > > >         }
> > > >     }
> > > >
> > > > ... which is called in __alloc_pages_slowpath. I wonder why we don't already
> > > > hit this. It seems to do the same thing your patch is doing?
> > >
> > > I checked the number of calls and the time spent for several functions
> > > called by __alloc_pages_slowpath(), and found that time is spent in
> > > __alloc_pages_direct_reclaim() before reaching the first should_reclaim_retry().
> > >
> > > After a few minutes have passed and the debug code that automatically
> > > resets numa_demotion_enabled to false is executed, it appears that
> > > __alloc_pages_direct_reclaim() immediately exits.
> >
> > First of all is this MGLRU or traditional reclaim? Or both?
> 
> The behavior is almost the same whether MGLRU is enabled or not.
> However, one difference is that __alloc_pages_direct_reclaim() may be
> called multiple times when __alloc_pages_slowpath() is called, and
> should_reclaim_retry() also returns true several times.
> 
> This is probably because the watermark check in should_reclaim_retry()
> considers not only NR_FREE_PAGES but also NR_ZONE_INACTIVE_ANON and
> NR_ZONE_ACTIVE_ANON as potential free memory. (zone_reclaimable_pages())

Yes, seems like the same problem as with get_scan_count.

> The following is the increment of stats in /proc/vmstat from the start
> of the reproduction test until the problem occurred and
> numa_demotion_enabled was automatically reset by the debug code and
> OOM occurred a few minutes later:
> 
> workingset_nodes 578
> workingset_refault_anon 5054381
> workingset_refault_file 41502
> workingset_activate_anon 3003283
> workingset_activate_file 33232
> workingset_restore_anon 2556549
> workingset_restore_file 27139
> workingset_nodereclaim 3472
> pgdemote_kswapd 121684
> pgdemote_direct 23977
> pgdemote_khugepaged 0
> pgdemote_proactive 0
> pgsteal_kswapd 3480404
> pgsteal_direct 2602011
> pgsteal_khugepaged 74
> pgsteal_proactive 0
> pgscan_kswapd 93334262
> pgscan_direct 227649302
> pgscan_khugepaged 1232161
> pgscan_proactive 0
> pgscan_direct_throttle 18
> pgscan_anon 320480379
> pgscan_file 1735346
> pgsteal_anon 5828270
> pgsteal_file 254219

You can clearly see that the order of magnitute of pages scanned is
completely disproportional to pages actually reclaimed. So there is a
lot of scanning without any progress at all.

> > Then another thing I've noticed only now. There seems to be a layering
> > discrepancy (for traditional LRU reclaim) when get_scan_count which
> > controls the to-be-reclaimed lrus always relies on can_reclaim_anon_pages
> > while down the reclaim path shrink_folio_list tries to be more clever
> > and avoid demotion if it turns out to be inefficient.
> >
> > I wouldn't be surprised if get_scan_count predominantly (or even
> > exclusively) scanned anon LRUs only while increasing the reclaim
> > priority  (so essentially just checked all anon pages on the LRU list)
> > before concluding that it makes no sense. This can take quite some time
> > and in the worst case you could be recycling couple of page cache pages
> > remaining on the list to make small but sufficient progress to loop
> > around.
> >
> > So I think the first step is to make the demotion behavior consistent.
> > If demotion fails then it would probably makes sense to set sc->no_demotion
> > so that get_scan_count can learn from the reclaim feedback that
> > anonymous pages are not a good reclaim target in this situation. But the
> > whole reclaim path needs a careful review I am afraid.
> 
> If migrate_pages() in demote_folio_list() detects that it cannot
> migrate any folios and all calls to alloc_demote_folio() also fail
> (this is made possible by adding a few fields to migration_target_control),
> it sets sc->no_demotion to true, which also resolves the issue.
> 
>         migrate_pages(demote_folios, alloc_demote_folio, NULL,
>                       (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
>                       &nr_succeeded);
>         if (!nr_succeeded && mtc.nr_alloc_tried > 0 &&
>                         (mtc.nr_alloc_tried == mtc.nr_alloc_failed)) {
>                 sc->no_demotion = 1;
>         }

This seems to low level place to make such a decision. Keep in mind that
shrink_list operates on SWAP_CLUSTER_MAX batches so the backoff could be
pre-mature. shrink_lruvec seems like a better place to make such a
decision but this really requires a deeper evaluation.

Anyway, it is good that we have a better understanding what is going on.
Thanks for confirming the theory.
-- 
Michal Hocko
SUSE Labs

