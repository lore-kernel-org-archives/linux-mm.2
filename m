Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412B0CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 16:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C6B8E000A; Wed, 20 Aug 2025 12:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C246E8E0003; Wed, 20 Aug 2025 12:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62598E000A; Wed, 20 Aug 2025 12:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3F038E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:22:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E82A1A057B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:22:03 +0000 (UTC)
X-FDA: 83797652526.14.1992E7E
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3901F140018
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:22:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fRssMe4x;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755706921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBLYyaohMUoNQ9X3he/qnSrc95mW/vnc+a+/vaGlBWU=;
	b=8DPruCQYahJsXLh1hwVP7xChW4BKh78yw4Y7J60LfYwFemsb4rF3QA2OGfU/OQvcSF9j/c
	2TcraHySUhsKPK1A4LV36/Ek2HH6m28unDjUSffZ6Uiow3ZUn3zenXa2cvRynvlEYQu7Ow
	35X8gd6OrohlNQFl0aJjvgDFBWOkPPQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fRssMe4x;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755706921; a=rsa-sha256;
	cv=none;
	b=GM/EQ5mdvPzjv/ydtVQu6Q2Brgz9uM8/apXrWH1sb4OEj/Pp4pofK4SmVLyG8yrc1Dh2Jv
	dsz84aoPErtmnG/KloXmJXhAcVR1WwG4YHbWGpvphr00wVLjk3pvF0zP+1eXahRCq3yiLv
	jtXPgXQHPw4VH2fOHdhIqgnZnUzi124=
Date: Wed, 20 Aug 2025 09:21:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755706918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vBLYyaohMUoNQ9X3he/qnSrc95mW/vnc+a+/vaGlBWU=;
	b=fRssMe4x4fjWLKNWxp9No6Dt3tT/XKMTSIz4exFpUGvwlVWtQ9hM1hkvC54a+RUloUG33v
	0F2yFukgQwfF1ekGUJ3up1lB8CT6ifF13pr6i/0mgLfGuYbsq0W66fsruIpbmgjtE4Ir6Z
	fnJoz9vzguWadvcdAyHnRc7Gwiz7Mp0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Boris Burkov <boris@bur.io>, akpm@linux-foundation.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@fb.com, wqu@suse.com, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 2/4] mm: add vmstat for cgroup uncharged pages
Message-ID: <6xccsmpdtvweriimshfvgz7yzxcdodbxhzfvxraigdqiomkgze@wb2i46neozwu>
References: <cover.1755562487.git.boris@bur.io>
 <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
 <aKPmiWAwDPNdNBUA@casper.infradead.org>
 <tw5qydmgv35v63lhqgl7zbjmgwxm2cujqdjq3deicdz2k26ymh@mnxhz43e6jwl>
 <aKUM49I-4D24MmwZ@casper.infradead.org>
 <i4hg4g75ywbera643uhtshkj6xrriqi4mi5dg3oga5os3tp6m5@u2dcv2snbiqs>
 <aKXLXJw7m-TSkZOI@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKXLXJw7m-TSkZOI@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3901F140018
X-Rspam-User: 
X-Stat-Signature: 7orgt9nsnaxbf8rj1it1ooh8931ujte1
X-Rspamd-Server: rspam09
X-HE-Tag: 1755706920-626778
X-HE-Meta: U2FsdGVkX1+5yDq87iEqo1Ny9FVfUnXvJ0LcSyKn7wYyYNF0yws+EsgLrpQwr7fzPzVzfGvVTXyYx4s/TsGMdYIucuIV4nAQ6KhoTfU2KSVwcgNxND4Q5i6QdNtn6b427N7aelRFolQKLZMB1LVXrQ2xMz7AgqMtPar9VBg44X1cPM7SMiPGjmizVkzTlBZAfdihpbnr3csbvYFve8XRBEpESXUSs+ShfPiGyj6bdOs5gzTxB2pKbi0dO4Kl+Jzd8n7sfPh2+/j3sNlxwBbYy08i7ISxw2bfnBGpehwdGBZJFH5iDgabu5ePk2KofVyDN2qz4jwfHfocBzcycmpHGOz1RM4g7FK5N9Ed822YlFvIRxYbO+hLXyxWhQs1LNLtO9NQWACWqu5A5NlqNHN5XEjIj3JnslpOPVJ1k1TvvkfSvw2gkGQuGOu1aFAixfH70648zotlxo+Inn07Z5dGuNqOGwpIe84YkB4pnJogRgu8p8MLbeC1PPbfLD2aamX7RY6KWDr7D4TMLVAZHBsLKEokLUe3IlFnbWH1iae0udhqAkAK/7jucB9lDruS8Bb/80hpu+5PsRwyjsdP4gZH9SdAA+VdI1u7HswQL9KHewJ2qBmcOmmmurhFqGkO2NYvm/UwF6GqAdNeK0P70oyIb+c1+HqjPCMHMBru/EDbTLAwNhiv7YvAbBcKo4l417yHorsnZ7zkV7jrx0Ge0ts76qz7WKTB8rTY0JZpLELsepLPxND6rHEIQVrVC53UaKebg/KEVgCTGXKJrl0rDkhkoWzyBGiAXvP8MSCq2ZKib5J2cLEuyi8UOGq7gp3l56pGk96uZ3v/YXW1fjVZDykq0aOT2WsXa9/r5P/X94RJowe9GgF4r8tN+WV8GtYKWCTeP3HK+QN6v/U4/wQOXz+mjpHU1hO7uurvU2SUoU6dmw0OchO0CMOog+bD4xhvaQY9TQjx7+GX4LdiC6OvthC
 tS7ZNA8Q
 oeBHUVqT9+ZZDGhszlJMM/U8fBfzdBwoPKosxmiWbs2CltZFBr8X4jhoYEUCLBwDLNbHTWaI0sUhNoZsT2XOlZn4T5Fsx3Nozlc5I8tSIZjouXGr0g15gJD/V/KzjNHnWonZwPnHIDcHada2CQGlakLeWIlPdj9bHw+Yp1WQG8eu4Bx623l8glhsiBDuUqcbVB46LbCtof4JAyhcpFSoUL31reacW43OCOVcYPss54R4gPERUPA3qYQi1EWuX31btG3hNSOXYhjLPZH/lt873ZgJ7Mg/jJc3c2p+h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 02:19:24PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 19, 2025 at 06:25:36PM -0700, Shakeel Butt wrote:
> > On Wed, Aug 20, 2025 at 12:46:43AM +0100, Matthew Wilcox wrote:
> > > OK, but couldn't we make that argument for anything else?  Like slab,
> > > say.  Why's "file" memory different?
> > 
> > Good point and I think it does apply to other memory types too. I would
> > call "file" memory to be more important as it is one of the largest
> > consumer of DRAM on, at least, Meta infra. Slab needs a bit more thought.
> > At the system level (i.e. /proc/meminfo), we account at the page (or
> > slab) level while for memcg, we account per-object (plus obj_cgroup
> > pointer).
> 
> That was supposed to be a reductio ad absurdum, not an invitation to
> add more counters.
> 
> Look, if this is information you really need, I think you should come
> up with a better way of collecting it than by adding new counters and
> new complexity to everything involved in GFP_ACCOUNT activities.
> 

Please elaborate more on this complexity. To me, particularly for this
specific case, a dedicated counter seems more cleaner compared to error
prone and costly alternatives. I am not getting the complexity argument.

> The unaccounted address_spaces are a very tiny percentage of file
> memory, at least as far as this patch set goes.

From [1], Qu noted "On a real world system, the metadata itself can
easily go hundreds of GiBs...".

This does not seem tiny.

> I don't think this
> patch is justifiable on its face.

I think I have provided enough justifications. However I don't want to
force push this until I fully understand your concerns. This will become
part of API and I don't want a situation where we regret this later.

[1] https://lore.kernel.org/linux-mm/08ccb40d-6261-4757-957d-537d295d2cf5@suse.com/

