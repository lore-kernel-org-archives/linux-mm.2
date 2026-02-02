Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46633E7DF13
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 17:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB1F6B0005; Mon,  2 Feb 2026 12:41:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA8D46B00C2; Mon,  2 Feb 2026 12:41:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5746B00CD; Mon,  2 Feb 2026 12:41:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 884EB6B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:41:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C4A3160230
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:41:37 +0000 (UTC)
X-FDA: 84400233834.03.7B5F2CC
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E69980006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 17:41:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k8eKm18h;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770054095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6OBDEWLEmHCzYPUVrTciErMQbNpqUwuoibpvHtq101E=;
	b=Aq7lNuzc3IMin9FZU/KFN56JeoayNWhP8LORIPwRiX0qwmXFyruTGqfG0XM2bNr3vSfD50
	0WiijLC1uP7KINNDYw7Arx4bmZcbNZ2olk0Ozuh7pQW4C1ZzLpPYpZnCwFpXCfSKT4kDP4
	K/FRxRHzyjbeB1EWuaGTgLhtItIhKAA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k8eKm18h;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770054095; a=rsa-sha256;
	cv=none;
	b=3zhYqDTwexj7uLQNXtmtgbswvfSXK83oOT/ucDcxL44YXekc58fqOKrl0iVLTco/w7YK/K
	SMWPwOdmsNvOsTRjA7OWXb9vlJUgC3SfpUs8RuQ9VGFoRwzfW2acgk8Y0MSPo9ibG80AyC
	21Hq49UYORDw/reaq7LwxS/TvvKZOo4=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88ffcb14e11so65546486d6.0
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 09:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770054094; x=1770658894; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6OBDEWLEmHCzYPUVrTciErMQbNpqUwuoibpvHtq101E=;
        b=k8eKm18hjiObsR2ZA5WEUTZ+72/3xNMlsgrrCw90E1dKWclTEIjf3dXgHcF9aQChxC
         pipd6Y//V2ZM18tnEmR8XT7JWEQh0x0n8soLg8OqlAlF3dm1fnMt1OOconMs/nzDDn0J
         88vnwv5bX6Q1RjYXdrtQ1kS2I5ztoT5fkVTMFX1T/816ZzAufTbbBScnaaD1C9j2ilqp
         l0jDzIZebrdgOVCx8Gjg2iAHRvkv0kDIwhdwpztosDMNdQl8PJsaqzQKKvx32+mkF0b4
         Lo1hfd1gYC8qf1wOTlvPTnNz2bBfJ7wLVa3XNIfSq+rgMOxUFr8TutrG4KodUmE6afgS
         b7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770054094; x=1770658894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6OBDEWLEmHCzYPUVrTciErMQbNpqUwuoibpvHtq101E=;
        b=pVl4xOs0UeKYMN7C6Roghr2BvuLRqaElZyzZS9GXdd/k3TIo+r7Gnorx13QEjk4wcl
         t3AgzxSKq5H/C9grdbmlkZDWD9UyILy9t+xHzGyHUliRp+KmfoGJ6ezSw2D3e1x64USE
         uE48gORhEkEhwc7MMznzG/5JQa3bnGoxE6BX1fJEcfo/RmD/cB8RvPZ6bR0g8jFlq2xn
         9kCjB6qgmW7k6vV/cbQ0vlrbzlgtXqePAq16q1TRb4Z6tEzomzZ5wW43pS6s7WZCxe40
         9p6+Pu95HTu6amQaP87iDDfzzmvOBrEa+9VfwZ62etTzDjrDtc5067KTIZ3bMRjMYe0G
         ayzw==
X-Gm-Message-State: AOJu0YzPor06hSzl0OZSIFHbtqEY607bLbAIyVITap9b6wibtFJ8yPur
	WTmS87uIIz0qDe0v+y1L1lnpd2HKYPv9sBI4KsoEuvfUiOaFnSwydPDjkrvQD2inD5Lx1mJQ1cw
	yiHQsZBk=
X-Gm-Gg: AZuq6aJw6jP0wdeqO8HGslKGkDYgWaEqCmIyGeVxoBB7mnoqGyWuqm+/2oBzCyM3pNg
	csIDUILY3EGuq/phy+KoeveNTDucxVsFROwTLiYtEQu4HtA+NQmamxHHx5E+3s3xLiR1kbNlRUH
	6BXJg7KMwGHVfJ9ETBM0lVW/txxgaBorswzU33+VOsLWdYinsXM9c7qlhGlRnSmXjhz3OUFOeyQ
	8KC2mIQ9UZSyTLB23Yvax2Vq6kBZAplERSbrCx8Z9Ycyd15RQn8qOGK6I5Myk7j10vB/2CoR8NE
	IFeitKS0BLNineD8p05h4DOlOMrEPAQhBPHPvmymIZV2/2nqikextCfxCrK0g17Fhj+s1K1Gpnu
	T8Y80SORBmiLjMKnACprQ+V1r/gfetz+orelhf58yBV6fgJ/xvnVIXkhRHykgsgxmypu6thx1Zj
	SV0YitAXXj7MrCCl5QgJI0q7wKfZfAvXKTsWuSCkaRaVC9M6lVBRhG1W9SkK2jjFGvu5WGadzrS
	uRyuKNL
X-Received: by 2002:a05:6214:20ae:b0:894:7fa3:7a32 with SMTP id 6a1803df08f44-894ea0f90c0mr191291886d6.68.1770054094267;
        Mon, 02 Feb 2026 09:41:34 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711b7c789sm1274632885a.7.2026.02.02.09.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 09:41:33 -0800 (PST)
Date: Mon, 2 Feb 2026 12:41:31 -0500
From: Gregory Price <gourry@gourry.net>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <aYDhyxjzKtbqFWdM@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>
 <aX0s4i5OqFhHkEUp@gourry-fedora-PF4VCD3F>
 <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>
X-Stat-Signature: a3wzt4z7dnsus1u8z8dpcpzt4kw6ioad
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4E69980006
X-HE-Tag: 1770054095-940464
X-HE-Meta: U2FsdGVkX19PWQTcAfRx5ptLSm3J6Slyzu0D8lN82m7Bde/jXeBKNAM0qSJMGTGwq/HIRbtdTKRkakCvekMlejAcSqldNntxmPRrdbvuFFVCRuSb5qyz/R7unm0zsC8Dcp+mVbDCDIIwnnDL8/5p+RlM8WjC3uLhZz0H1d3yf4MFonfIAFhdIpVKM6EKqdHkKw1X/mASWbl+2ovx/HNsaj+UiVmGK72gi/Ke1c+7G+qq8PlSkxeYlEwcuQPSY5KBxFebX9cfjue6J75h0eapQjzL3hqLUuI+Qf9Z8VL3Fan8iSLS5PI3vgedJQuNwBy5B+hm3J5jX8p1bjllWleBi67Isvkv7AZnz0JlJ9pQCnOD2/JmM0ybruzB9gjXZJGeKiakgE+mEGztLcycpMGR7uOkT6+RDUXQwF6YssOzzpxIptQ/wg7frSK8k03NGGHr9dWuRXrgBz0lL7Bi5peGl2dvx2DZoWfyLE1Rnx0jTeOS6DU5jSI3sxwW33fZ8FXxKOmqPyzvKLcEZ12KH+XfPAkKGb21nL42Z0kfUDtN86pwXW4LPwcys7z0s96Z1axVuGuOlWBWBV2RhZnorV68GPMwBKF1GWBqYjXXqmQ9Fk4ypiNQDbGvMSeJ07Ib4At3JLXrhrlkQaDa4pMELxQiW1IHRevrxjhDvrhbTQWsL0F6fjNB5QWJwmJXGvlS9Xb7tS3zVg6Nej3eXgFy3BbfKc5+6sRlht/i+JiK8qt/urvd06Vdeiy5ifWIePHAlZxpOaVe13FikVvxOCTmS3UrLBmG/JmZHwUvynDlqYVrdED2TJZkgZAbk/lHGbRkHY5jqPYsTL7h1/zOTRHkMOeqGG/SDUrSWfe9/ZmQVdE7DWpTwui//HFbqoYTQ4+wp7IUmvxt5c4Ktr7zD2DMWr5dKnO/Oii6tmBsZj5BqRcRnVU4FBoFMOrfJDkhTMhxd+mneeEUCABcjQRluI3kkDr
 yOxz+Tnc
 vf4OZksL6k0QVinQWjeJnyJM8SWfQCZqBdMyzc4vMCmy6tRFgHgFazqYJieR1cDlvDp+I7UXhNT20ZskvA0CBV1aDQ3GE3CueAp0LS45ItBSWIRau+QB8b250Sniq+PrVwVS/cmJ0GfYdEmrxa82QcM6+bfLJfosk+hUKQ+fLjymuiQhPbV8KtV8E5keUH9r0COexmZB9ZAf8x56vF93O0z80yFNUqsGRqUvtrkNG/W8PVvpP577+tnvw0xfoUnJUUpLdRSbmiljzFNx779pPzL0tANu1H0hQQKri+xdifR8OkLLXMvpSBRUNiq5Ssazcce9nRjYFw7nNzF1W99tru036FPyJAHUpIutiOfPN6LebUNSVBek4GInTeUCKCDLjKxn3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 11:02:37AM -0600, Cheatham, Benjamin wrote:
> > 
> > For auto-regions:
> >    region_probe() eats it and you get the default behavior.
> > 
> > For non-auto regions:
> >    create_x_region generates an un-configured region and fails to probe
> >    until the user commits it and probes it.
> 
> I think this was the source of my misunderstanding. I was trying to understand how it
> works for auto regions when it's never meant to apply to them.
> 
> Sorry if this is a stupid question, but what stops auto regions from binding to the
> sysram/dax region drivers? They all bind to region devices, so I assume there's something
> keeping them from binding before the core region driver gets a chance.
> 

Auto regions explicitly use the dax_kmem path (all existing code,
unchanged)- which auto-plugs into dax/hotplug.

I do get what you're saying that everything binds on a region type,
I will look a little closer at this and see if there's something more
reasonable we can do.

I think i can update `region/bind` to use the sysram driver with
   online_type=mhp_default_online_type

so you'd end up with effective the auto-region logic:

cxlcli create-region -m ram ... existing argument set
------
    echo region0 > create_ram_region
    /* program decoders */
    echo region0 > region/bind
    /* 
     * region_bind():
     *    1) alloc sysram_region object
     *    2) sysram_regionN->online_type=mhp_default_online_type()
     *    3) add device to bus
     *    4) device auto-probes all the way down to dax
     *    5) dax auto-onlines with system default setting
     */
------

and Non-auto-region logic (approximation)

cxlcli creation-region -m ram --type sysram --online-type=movable
-----
   echo region0 > create_ram_region
   /* program decoders */
   echo region0 > sysram/bind
   echo online_movable > sysram_region0/online_type
   echo sysram_region0 > dax_kmem/bind
-----


I want to retain the dax_kmem driver because there may be multiple users
other than sysram.   For example, a compressed memory region wants to
utilize dax_kmem, but has its own complex policy (via N_MEMORY_PRIVATE)
so it doesn't want to abstract through sysram_region, but it does want
to abstract through dax_kmem.

weeeee "software defined memory" weeeee

~Gregory

