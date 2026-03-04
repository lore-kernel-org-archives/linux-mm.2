Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB628EDEC02
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 03:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D066B0088; Tue,  3 Mar 2026 22:08:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3C876B0089; Tue,  3 Mar 2026 22:08:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B5C6B008A; Tue,  3 Mar 2026 22:08:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFD5A6B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 22:08:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 581FAC1A92
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:08:54 +0000 (UTC)
X-FDA: 84506898588.01.06F656F
Received: from r3-18.sinamail.sina.com.cn (r3-18.sinamail.sina.com.cn [202.108.3.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4D3B540004
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 03:08:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=OgKhkdxr;
	spf=pass (imf27.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772593732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqTvxPWzCZleF/cQGDr+4cElbXvFJHr3M2AYce9c8sU=;
	b=3qNLh1gPUNbRMf61U2b+tZE0RvDyeq/xFe7H4q5NL5I7llPgZ5MoA8yAx/Q2eHCkzsSVp5
	K29HLHkUU96u/W43eD6Rn0PWNXePkF3xnw7heUxzjZ9L5DKJCkmhq3GhZ1dUO0Do0hJois
	lMwwkRW8a4oXx2Gzs752cZ1/Tc472nk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=OgKhkdxr;
	spf=pass (imf27.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772593732; a=rsa-sha256;
	cv=none;
	b=gAWjM2KSLGzM5Pv7uiX4OJmVQ5KCu6wmzfilquqnZQoFRHiy9OEozzZ14rVCHI9Q8M+oi1
	cAosCFuXG4su4Dv7cQWfAJGzFNYkYjapQKOM8tmDHXwABpBlOsjut7zY8c88EIgyaOZ1my
	WagmybbPCC/H9v9hTSRJLzMdPEszqik=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1772593731;
	bh=VqTvxPWzCZleF/cQGDr+4cElbXvFJHr3M2AYce9c8sU=;
	h=From:Subject:Date:Message-ID;
	b=OgKhkdxrUb1gWH8CgqNpR8XFTiDHVPEDxt6QF1+MREO6+Eauhf8tUBGuobH0SgrXz
	 tsFAO45bkxbzi6g/1qqnALJ617/I8um9LJHR0EHBKBBpdHyjUM2sf9i9uM8IIW1pmq
	 ww0seaMeUQAOs5jQstXaOzLQEF9PiRxhaRJjnczI=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 69A7A23B000068A2; Wed, 4 Mar 2026 11:08:46 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 7553394456883
X-SMAIL-UIID: 9ACF65E9A8934540A480B37432775D4D-20260304-110846-1
From: Hillf Danton <hdanton@sina.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
	linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is active.
Date: Wed,  4 Mar 2026 11:08:34 +0800
Message-ID: <20260304030835.610-1-hdanton@sina.com>
In-Reply-To: <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com> <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com> <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com> <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net> <0de6c8d1-d2fa-44ac-8025-cfcfecd87b02@candelatech.com> <bed9cc03d3c214b2601093f91e4b00f3715762b2.camel@sipsolutions.net> <c616fc41-3bc7-4ddc-b65c-a622111d8548@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D3B540004
X-Stat-Signature: ppo64rmk1hynxipfpxpjsio3ix6mpq9t
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772593730-385538
X-HE-Meta: U2FsdGVkX1+8U6c0iFrrtDcCUSzoCLALq3QGg0lKLZRVncAb6apghFMFrIrpRbH/4cyK4VOAzPlpwWLwbTzGdyI42HAbvkHuuDLUB1p/tG80e5eswyXjO98+zLgzK0TrPswsh8EFcqkBJazgOyNMIqPEnGzCgCgs9MV5TqtBMMHHUh8aOM9RioaT3Ly0i9N6KxSWvBp8ABCXl7kIccv7MmmWs6WnYbRsxRaNyEe0zvRbn84omCA79pEOBz5HXFSy9xziHbIKxDJg5CPCEHEfImfOwy+HeYHpw7tGOKddXci98VEDTnnACaXLpZfy1oJWVcsk4arUYBFAZiD0AVCOMDhKgnXYzyJPtzfzVlueEEVXnGzOuAYV6OaxNULEg4AtJp+FGJ2BBO8NTbcg+TQcjYf7BbVZIY5w/UEVRgsCDakQoN3UdbfaCajeofTAqh9o6rmYeptKkS3ac9kQf1HEdI3XSLzhAWSmvxQiRsEArYe3ORNA9o8/UQ+6lpY9dXDXPbqBo7ECmB42vHariG/kqdwmAG8TrQ+RhXRHXU4XV1Pl6k0zZy91rzoFl63pWd8eNUHJk5Fl5G/qjDUnXzbEm0GYi/g5lpXUNVBHe5ZQ1n3h6HSJy/r7BaVPCQeK7zsyEnGKGiXSg9xZT/RDDGR+ehhm8b41RHKbfqZHTUNLcjYUlekDJxS0cWiGE5owy72Pmo/TZGvz+ipZR7j/GJE6S9EyltApqKtSIPgBFSFtYYAgo5VxQ60+7rEd2peBZ13kKZagBQj5kCozHc495k9JWwO1BtWxMU4HPVpr8R4qatTNbwSh0iCvssJHOig+JgXmuMDAyqj79JFg8Ryo+Gfo0ReI9XctE8Rm4O2Ieg+7tubnfzBQwMflYEqfDKsUz1cNV2Wv8KPISe/baI88ChmHObVwAEszPYXe0fWknKz0SlsyKKth/qJwiS285GKbwlJctB8jlNm6QmpxWI4ZHRS
 OPjRBIn3
 OC9ojz7bgenm+xwiiWT3HIYDdPMR6R9ObIncZB7e3i6cs55RLvaHaeBq2/82boxFmZJ2j16eA6kvolUIKukISGpSrzMajs9M104K7J2ACGEQOeHPGGfIGM40bBXkexhaj55pBty40UesPwAifTDPFHBLBaOAe0r0dCS9ng7Q/yAA6zTjVy6NOcKO5ZJI+7sWTTyqsp+5r22Mu2h23SmYaMqucAN0O9lmDGDVDrv0dH6gNheoVbmf2Aa07UqDgAgcTN9SMN0V+YKj5wa8JCc7vFokSqJtM82DHM8CfVWdQRwauC6gfv7dRFHHjxkCw6Lo4sEKMLlP/rpINByCKaXOrnT7Nzhzr0MT4lge7JfG2pUs8/t0nP3tGmn3sdYXG0Au3Q4Isrtnm9M1DoLhWk481yUljeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 03 Mar 2026 12:49:24 +0100 Johannes Berg wrote:
>On Mon, 2026-03-02 at 07:50 -0800, Ben Greear wrote:
>> On 3/2/26 07:38, Johannes Berg wrote:
>> > On Mon, 2026-03-02 at 07:26 -0800, Ben Greear wrote:
>> > > > 
>> > > > Was this with lockdep? If so, it complain about anything?
>> > > > 
>> > > > I'm having a hard time seeing why it would deadlock at all when wifi
>> > > > uses  schedule_work() and therefore the system_percpu_wq, and
>> > > > __lru_add_drain_all() flushes lru_add_drain_work on mm_percpu_wq, and
>> > > > lru_add_and_bh_lrus_drain() doesn't really _seem_ to do anything related
>> > > > to RTNL etc.?
>> > > > 
>> > > > I think we need a real explanation here rather than "if I randomly
>> > > > change this, it no longer appears".
>> > > 
>> > > The path where iwlwifi acquires CMA holds rtnl and/or wiphy locks before
>> > > allocating CMA memory, as expected.
>> > > 
>> > > And the CMA allocation path attempts to flush the work queues in
>> > > at least some cases.
>> > > 
>> > > If there is a work item queued that is trying to grab rtnl and/or wiphy lock
>> > > when CMA attempts to flush, then the flush work cannot complete, so it deadlocks.
>> > > 
>> > > Lockdep doesn't warn about this.
>> > 
>> > It really should, in cases where it can actually happen, I wrote the
>> > code myself for that... Though things have changed since, and the checks
>> > were lost at least once (and re-added), so I suppose it's possible that
>> > they were lost _again_, but the flushing system is far more flexible now
>> > and it's not flushing the same workqueue anyway, so it shouldn't happen.
>> > 
>> > I stand by what I said before, need to show more precisely what depends
>> > on what, and I'm not going to accept a random kthread into this.
>> 
>> My first email on the topic has process stack traces as well as lockdep
>> locks-held printout that points to the deadlock.  I'm not sure what else to offer...please let me know
>> what you'd like to see.
>
> Fair. I don't know, I don't think there's anything that even shows that
> there's a dependency between the two workqueues and the
> "((wq_completion)events_unbound)" and "((wq_completion)events)", and
> there would have to be for it to deadlock this way because of that?
>
Given the locks held [1],

	kworker/1:0/39480	kworker/u32:11/34989
	rtnl_mutex
				&rdev->wiphy.mtx
				__lru_add_drain_all
				  flush_work(&per_cpu(lru_add_drain_work, cpu))
	&rdev->wiphy.mtx

__if__ there is one work item queued __before__ one of the flush targets on
workqueue and it acquires the rtnl mutex, then no deadlock can rise,
because worker-xyz gets off CPU due to failing to take the rtnl lock then
worker-xyz+1 dequeus the flush target and completes it due to nothing
with rtnl. Same applies to the wiphy lock.

BTW any chance for queuing work that acquires rtnl lock on mm_percpu_wq?

[1] Subject: 6.18.13 iwlwifi deadlock allocating cma while work-item is active.
https://lore.kernel.org/linux-wireless/fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com/

