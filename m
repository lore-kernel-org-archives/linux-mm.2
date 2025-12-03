Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB757D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 08:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDBC96B0012; Wed,  3 Dec 2025 03:35:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB36C6B0023; Wed,  3 Dec 2025 03:35:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2986B0027; Wed,  3 Dec 2025 03:35:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9574D6B0012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:35:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D9B8F518C8
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:35:55 +0000 (UTC)
X-FDA: 84177501870.24.AFB1A8E
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02583120006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:35:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kQFcrWU1;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764750954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LA3Ic4i9iG/4Wuv4J3py+fbGaONiUwvROdkBn6i8vWM=;
	b=fzugLahs6mrD+2A+15K2R+QLKNPX9UOuCN+SqjAq7EIoO2NHKe/heLFy6N/pL7oFhWso2r
	0OVYjTrH/8jsTu4LZ14MOe7ItCeCb0kflar5zQYblzdOwgJTkvsOKT0Z8zZiRcRmQNGhCI
	6eIbQG6g78Hk8VjphW7P+v/RmhkCgaM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kQFcrWU1;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764750954; a=rsa-sha256;
	cv=none;
	b=MWtkxoSyNzIh2XWAjdYf+MQDs9Q9g+3Zh4Vi765Z3dqWehQN7aByGhoJEmBYCXe4AqNqv2
	8kRK+YJTz11n6bLpz/v0MpXml6TO4Gga6Qv45VEFm1LrjC80l2/oC5gF8OUj2WdozKy0wo
	85LaCgdqABMUpswxSGtgBSQf/FE0hUY=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee1fca7a16so52886181cf.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 00:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764750953; x=1765355753; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LA3Ic4i9iG/4Wuv4J3py+fbGaONiUwvROdkBn6i8vWM=;
        b=kQFcrWU1SJx3GZIvAG84BCphBo0KtB6Gp/+MrZ7pZsiRJccRww9/PhvWeeI6XW0247
         WD+jSQUwUBArjoyZAaAdfoLoZzvOnYXLRed/1r8utvtUb9+/KjpfQaL/RYPstpl49soi
         VpuGRnqjeSMyeGPOR9bFLtHLUgQGCT8vQcG1KWdG24Ok8/T74sMLj4CJ8iQMwyoV9Zbi
         Pw9MgX3MOcI1zwRMl0xViQvCn7I+0pblQO3/JMSFr6pzhPXWSErE7E4Pezsc3HZ56QUP
         8ekG/acI3UIVFjlGRC23Zf0riWRF8km3425HMPLwn7Vf5wrOitTThOsPdgrLJSniVUN9
         BdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764750953; x=1765355753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LA3Ic4i9iG/4Wuv4J3py+fbGaONiUwvROdkBn6i8vWM=;
        b=Ld2ryBf2rGggZ1WjkfqWpp6x3CTyl5gmLoxsHRckW2mKsAbVbMMJ669KIURyyUUxAC
         EWhyDtaULLdY7zSG5br+AZKZ4lYlMLc0ZQAuDfcWvlUvOKyYKwiYyKMtEHdCyaP6hatV
         gci47+cbg7sMKOCM4hjSXvij7jr8vT6Jlztziw1snZZyB0B+bq2I2Co0pKEKRV/Rg2qm
         F6hzXL1FnRtdpqnTr+N15AjXJFpOQJYZ5xLsgguYfiCsREVltlDO4y3LoWVhk3+LoeqL
         o1lp8c8RloNW6bXhCS/RSRFNH2crgKVsbAOQjgXmqfxOWRUclxeldoTLsqYXzJcPnRCo
         QMmA==
X-Forwarded-Encrypted: i=1; AJvYcCVWYbvr/sSQCOjDaKHqM6RubyLBFnP7WX2hfxaftxIykjtogBwDA8dT5G3oR/lMvmzsUMxm863ESw==@kvack.org
X-Gm-Message-State: AOJu0Yy4s7YFRo9JxJ1uMApfWg/YApfDNa580XjwZdo4JxxnaO7ledgm
	Wm3yddP+x+gjWcEw5DlTNjpHn6uIOSbuF8RCd3eaEDzLS6mGSF6kCLzllwV5TrDQK64=
X-Gm-Gg: ASbGncs9uRiBkZeP0Zxe6wP/QGKWHcxu3rHhAZEUlKJyoutwj0kZ9UqWblJc76kQbQO
	saInWbXHEj4J5sN7pz3npDCpfe23F/DMk2L6L2ITsyWOhzbqnnaF/ZGYdl9x3uTUEq2uT0c+6An
	t6lSEXdPD0DxssuI4SSU5br9TjcXx/jeqo+20U1Iw91GygnYs3mxcGGyUPhgbF9jYCDh1XiFLlE
	5hadiHm5E5se9w6tBDgxsVfiSdbXuAAyTQ8+OXq/ZRzLPqvQ2Ke0/z/40foc/nrxC91PtTyRfMN
	JHp3qEYaz98YDM5O9RvNrNsthmGMfRmd1kUFqM/8BLgzcx7JRd1QDYsENoFk+mqjgwnPoj/OOZB
	TA5c0grV+ONKi5Q4Y2d94Nvm70vPxVVQwTWCbqbIYwi8MecoXT4gddskEiPt+3hayI7gOLZaWji
	T+z+H4aj0MWBlaspv9xaxAQPJLigcIJXXRp3nLbjDO1GFjsojAfo5CRBWIreoNL/4CYE5B5w==
X-Google-Smtp-Source: AGHT+IE+xTKCihlHnzhY+EDeazvLtTzGsfm3e95I2Isk/JbAyqkqXC51wwHlCSOST50MpY+yA0iIyw==
X-Received: by 2002:ac8:580c:0:b0:4ed:6e15:d2c9 with SMTP id d75a77b69052e-4f0176c2d84mr18524351cf.71.1764750953001;
        Wed, 03 Dec 2025 00:35:53 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524aff3csm126348616d6.5.2025.12.03.00.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 00:35:52 -0800 (PST)
Date: Wed, 3 Dec 2025 03:35:51 -0500
From: Gregory Price <gourry@gourry.net>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <OSalvador@suse.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS_0bgCs2qE0y1bJ@tiehlicka>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 02583120006
X-Stat-Signature: iz8dsg1ocj1zhsu7m93h7ufu9dneuiqi
X-Rspam-User: 
X-HE-Tag: 1764750953-803751
X-HE-Meta: U2FsdGVkX18xQ4TRNdc2T89UpU+WsoIfzgN3t4HO+GhNQ7LjJ++sVDt4rg5Uqxu9WGOW3ZMOe/aH9PcU5wEN3tolEwd5OsmOhXK5F/2M5t0RNcM42TYz9XoquvwI+649i8CURgw+bU+51qdu4SBgNcUMMTVZI9d2H3ERCozoKX5TjW9ega+5gO7AYs4LMwOVeR4NMUp0uWMb747BKADhf07LDjC/oViKBiahY69BROreWVvxFii8DTq4iMhejDM55Q9lBl22D8Hd4RzKsJQ2A6ieHTxgUrLbOP621eai3CkUMiCTmngCUz0a/WBozWnI1zmX7Il2EWwdH2mjQZdpRlfgly8hNXuAhZFIbZY6/pHBj2t4VFIVt3u4Jkhp/IUqO9K0jRqGVzElK/9XDAFXSCDY+S5q2AYZr88Mqs4nTw/jd5pTUAN7oOuov2JGQMc0GWWGlCMJSIn9XKF7C0jirw5oBoQXb0bfG+GECr9ibXO9KDiubpzI+VneZx6zjY1giuy8zBL2pZlszz0uZvexV+ajE2etwuXyqbsRwEPKz3459eKxbs1isQ4Ux93NOYTrgSsm+CraZVzUzxcuICBOy9IWbbjGFz3dIulnG7iA2JtGqHyoaNTy2EoO/JkXH5LZk1la91LNegXBJJP/EkSS3jmIanLle+1xhsvXkmj51hk7vz+/ItepyfhO3qzqftXM64Qcdo9uHrt1MGRsVDAOpGHiB6N9zsPI/j+InIruVBAKXWyUf/gOQspDzu0bk9zx4lUH5OQ7Me2k2J2QBxwgJ+HRMiBb6HSKE0San6cNtboTdQcWY1WhftRkTGYdjI/VUB/sWUgokfPv7NCkNyi7lgzWVRPLhARjn7PYk9vGVh1+W7CVdalII5ccztA8/I78v5ZJX8JAvbZvLA4claG0c3CoyiwW+hU+HuIHHTdqCyuieSLxVxRn6VvxVyNt7TIk1y8uED96mVIFiEKX/Nv
 mRFf7bst
 VpEeaBuONpM4muK6SgSFJqS/b3QGktI0iBY+YtNWUVCUCQhFQ+MrIbDOleBOZWXbJLfeW+O5/f6CgqsFJHxyPYvTZpO8Kg2gQBqeJ8rj+5B+gECkbESN3YZHyU2yOi36lDqBtjc4S7eazWFocLM73afO5N+xNgjWdYA0kWIzwbharBKu21uGKuFr/QWVXSqF68sDf5894bRDgpsrMPGYEF+bpW3waBN1zdcOwcMYEVcwtKMHGAcIt0gzYYqjIdvnVnq1M4BIvvaNR7j8XnI9Pjiq/XCZMGmwO0/WfPYXSwox+QDcF0UhpOP3ufq9Q7NshIVAi+ZtWq4Cu29REJSnPin0R/ZoXk/9kjLEIzjCpHap+/5mvzyLq2pD3cs9LrvxO7zr27GWGa7DucwvzmTY8u43Jfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 09:27:26AM +0100, Michal Hocko wrote:
> Let me add Oscar and David.
> 
> On Mon 01-12-25 09:41:12, Andrew Morton wrote:
> > On Mon,  1 Dec 2025 11:30:09 +0530 Aboorva Devarajan <aboorvad@linux.ibm.com> wrote:
> > 
> > > When page isolation loops indefinitely during memory offline, reading
> > > /proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
> > > causing hung task warnings.
> > 
> > That's pretty bad behavior.
> > 
> > I wonder if there are other problems which can be caused by this
> > lengthy hold time.
> 
> pcp_batch_high_lock is not taken in any performance critical path. It is
> true that memory offlining can take long when memory is not free but I
> am not sure we can do much better. I guess we could check contention on
> the lock and drop it to make cpu hotplug events and
> sysctl_min_unmapped_ratio_sysctl_handler smoother. The question is
> whether this is a practical problem hit in real life.
> 

I just today hit a scenario where offlining was blocked on migration
failures that took an exceedingly long time to offline (many minutes)
even on a relatively small block (256MB).

Now that I'm looking at the double-do-while loop in memory_hotplug.c

zone_pcp_disable(zone);  /* (pcp_batch_high_lock) */
...
do {
	do {
...
		cond_resched();
		ret = scan_movable_pages(pfn, end_pfn, &pfn);
		if (!ret) {
			/*
			 * TODO: fatal migration failures should bail
			 * out
			 */
			do_migrate_range(pfn, end_pfn);
		}
	} while (!ret);
} while (ret);
...
zone_pcp_enable(zone);  /* (pcp_batch_high_lock) */


Maybe it's time to implement the bail out?

~Gregory

