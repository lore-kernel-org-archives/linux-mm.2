Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDE71EA4E24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306BC6B0089; Mon,  2 Mar 2026 10:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4786B008A; Mon,  2 Mar 2026 10:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7A06B0092; Mon,  2 Mar 2026 10:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0919B6B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:51:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9C43B6AFF
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:51:12 +0000 (UTC)
X-FDA: 84501561984.01.FBEA312
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8EED4C0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:51:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=UcP8pAu9;
	spf=pass (imf28.hostedemail.com: domain of greearb@candelatech.com designates 67.231.154.184 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PrZSOcC8NP1oMTlU139M/8g9ZNzpyyGjonNgscrN3Oc=;
	b=r/cNASpIiCoDQtSymqTJjpP31TjoA432/oBq2rKQmJUv9XDA5mAzIzMYyk1kNiaQXkQG+4
	U+SC5d38CrP2PrSzL7Uh0dT7aoxB7d4yqSkFsOXU+lYHyYTMDhmuwy7IytN2w06kvad3U+
	139RCvGJTklaWNGmFOithKjoLbipmvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466670; a=rsa-sha256;
	cv=none;
	b=w8PRf5lb0dKGwvk8VESZfvaHLw+KhJ62EM6au6jeFMf4V9MvI94XnIirw0Ijwo/TYYIAOA
	bWviRePdlGBG+gwDno+fj/35HLHgz6rt7E21XkVxOd1lo9tAYzNbWV7FSjCg9PIBFvzmGR
	TTIgwY5SkMQ7S8j9/eDC+Kl84zv1sY4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=candelatech.com header.s=default header.b=UcP8pAu9;
	spf=pass (imf28.hostedemail.com: domain of greearb@candelatech.com designates 67.231.154.184 as permitted sender) smtp.mailfrom=greearb@candelatech.com;
	dmarc=pass (policy=none) header.from=candelatech.com
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 82C064400BA;
	Mon,  2 Mar 2026 15:51:07 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.35.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id 8BE5313C2B1;
	Mon,  2 Mar 2026 07:50:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 8BE5313C2B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1772466664;
	bh=4yf8YFL7jyHSnGLpl3oF2CsMir9We4DXATnMYeZZZBo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UcP8pAu9WPTja7HnxC7Y4KHGOdjNHxThfs+inCHchvGGM4vrPvZjlAfsVwSAnDUZ7
	 nbFQCAkeTfQ406GHMNnsen2H4SukP8oj/ELgUIAXXZ44/ieZcVtIcKTlDAd8+yhuuy
	 5Nw+nP9yHBkbKqk4cFSFbjddjiNTyzw0P7p6bU4Y=
Message-ID: <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
Date: Mon, 2 Mar 2026 07:50:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
To: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
 linux-mm@kvack.org, Tejun Heo <tj@kernel.org>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
 <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
 <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com>
 <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1772466668-vkB9hMjGlWtI
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1772466668;vkB9hMjGlWtI;<greearb@candelatech.com>;4238417753472804730e2a8cda7a2ac7
X-PPE-TRUSTED: V=1;DIR=OUT;
X-Rspam-User: 
X-Stat-Signature: wixqftyyzpdysm6e9gyam6ui97yzqbmw
X-Rspamd-Queue-Id: 8EED4C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1772466670-38648
X-HE-Meta: U2FsdGVkX18RjP3bjcfcjPc9SfuFz0ZJEFPC5qtaxhrjldGfKcWhckolm8WvjdrBHJKSgBoCKiiBoDJ/94OUMZjawSELyeFRVTbksM9tAKd9PzWkR+I7vQ3t4P0F7zqhcdRK/6s0XISpQkJXa1PCqJBd+PvktWR27onjt9cUrFVil02DINH8pf63ehpFRn/Q+KRNJIE1JXyp4+sw3kWXefR/C8/8Xf1yELlwW2h5E1X8DnQ461Co/prKv+PWA/rjzW8TkdGPmwsFEoRNMnbLBq8OT/Zyg+WovsGhyltTb4S+StdQ0Bht3YU5SwcO1Cxn6ZY7skMgv/UO5uxwmWlVjl+TGJ7xyfM41Gl3jz6h7bXL5H22ieZ4yy3MSeLH10D4y5zOVaWC1bbQ9uss4GurIOeSRnE/R+EqrhMHVt9JiCo9hifB9tpC05VcyxsjbdW5qEPUwzDZpPTHWdO5cvU6bxMC5V8Q60Y3G61Cxh99laXtZmSJ5an7/W3beK4B519+p9D/wm0syfGUshiGW4JgT/y/DdhaeGB//3Qq6yeT38jOvl4aUT1kSE/dz2M8JszvrbhHurehbf0J712cz+T5G8LZoaa4riUkSOwGAPU4sbCJvq2vBU5YOfK+6wuiNoopNTLDFf3xor7DHtHHtNqJMRx14j8xxEMvR7gRZZe7gWOF0GOOG9MpE8mCEy+OgMOBtIc1gSElig61zuD2M+7NZgsqlPzuT0PYeNgwcc4fUIIOITs1Fx5p0dc5BuLSP/ymNNOr9+8SvYrDSQYLbJrzFIzQPVwSk1iGmXPaFb6OJ7CLwDbkDVOIc/bAY4zKikPgaU2Dh5HyLAjI6NSSNu9D6PGRXRKEShA6rLOeddlaAbdXLE+dYzC2wtX7syMO89TTvl4LSiJnhO7GTLaQuw9We4gcd32ebHzfixuuh60J+P9DZnIpBBjoD4RcMwtGglbgmS9uplb+cXhZuzdJNM7
 b/9Ae/GN
 BikDtwTZ9tVsgiEx7rB3nhi1McRXOxZYF5xPQZTNbokuQw282YnAy/k0awwyvmoy4ndX9zxlodKHR9oEF2j0xeA/QHlu7bepZewoyf8yFkDZKanBfwJb3pG0n0hGwP4VUNm5HVtmrCM4ChYR9OfDr3aSSHQWSPwiR7giLdS5u5iRDnOz/6ixxfzCvBg8s0FRuHfwrftIV+GnXHhTnbLxe8JAkBjUmoype5mJf0Nq9VHIB9mjzMo0mHjbnRWGe+q3p1V37rfAdPSAnKsydjA8aSjA1trzGHSg4Q8xnx6WTKQJz6uE3O7Ij2LYdISpXa3JF4TcibaXMGPex/LV3p7aC+rEUakuKyBcMfxEpaS/APJhsh6MwR545cb5DQefC1/4BpHgVobj+Wjk1ddIXu3cCQqXQSJ/jyzDNFvUG5jiVnHePJ7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 07:38, Johannes Berg wrote:
> On Mon, 2026-03-02 at 07:26 -0800, Ben Greear wrote:
>>
>>>
>>> Was this with lockdep? If so, it complain about anything?
>>>
>>> I'm having a hard time seeing why it would deadlock at all when wifi
>>> uses  schedule_work() and therefore the system_percpu_wq, and
>>> __lru_add_drain_all() flushes lru_add_drain_work on mm_percpu_wq, and
>>> lru_add_and_bh_lrus_drain() doesn't really _seem_ to do anything related
>>> to RTNL etc.?
>>>
>>> I think we need a real explanation here rather than "if I randomly
>>> change this, it no longer appears".
>>
>> The path where iwlwifi acquires CMA holds rtnl and/or wiphy locks before
>> allocating CMA memory, as expected.
>>
>> And the CMA allocation path attempts to flush the work queues in
>> at least some cases.
>>
>> If there is a work item queued that is trying to grab rtnl and/or wiphy lock
>> when CMA attempts to flush, then the flush work cannot complete, so it deadlocks.
>>
>> Lockdep doesn't warn about this.
> 
> It really should, in cases where it can actually happen, I wrote the
> code myself for that... Though things have changed since, and the checks
> were lost at least once (and re-added), so I suppose it's possible that
> they were lost _again_, but the flushing system is far more flexible now
> and it's not flushing the same workqueue anyway, so it shouldn't happen.
> 
> I stand by what I said before, need to show more precisely what depends
> on what, and I'm not going to accept a random kthread into this.

My first email on the topic has process stack traces as well as lockdep
locks-held printout that points to the deadlock.  I'm not sure what else to offer...please let me know
what you'd like to see.

Thanks,
Ben


> 
> johannes
> 

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


