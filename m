Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363DBC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F656B00B8; Thu, 16 Jul 2026 20:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2778F6B00B9; Thu, 16 Jul 2026 20:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E9D6B00BA; Thu, 16 Jul 2026 20:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA1956B00B8
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:39:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69310A0340
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:39:53 +0000 (UTC)
X-FDA: 84996411066.05.F7339D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C4CF5100003
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:39:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XfhikE3g;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784248791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bSW5HxEFq+ITIVQonZ02kyA5U7MyDuFVOxWZi2QyV6k=;
	b=I2g5Tdtrr1s2rAaP6Br8PCWTeU41o5rlWTqgHJz6nQEGWAcb5EcOlJvsxfi0urP2OEBFYO
	0vik0oFnQsO5l3u978+Ni6U6GsLx+5+dj9qwtHd5Y7WgltKRbAPwmDSYpTpi6ICVnf4oSC
	zVKasLcZuN7iuSkmaSN84Ke6qE5Im2Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XfhikE3g;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784248791;
	b=acVof9mT3RcWC5qjzLehFmeimb9uV2Z4lzIDCtOB2GhKG8MXeTB6I/EL2orD/ykxLybKPm
	trntXYawbUSqV4pFNc9M5cZQy8AycAhvfBPipccHXnBsh/mliC2nHBv+Vu2vtMciL0xsCy
	Sjje8q6TRLKAZtap+wBcnvAjlmSlslU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB54260204;
	Fri, 17 Jul 2026 00:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340471F000E9;
	Fri, 17 Jul 2026 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784248790;
	bh=bSW5HxEFq+ITIVQonZ02kyA5U7MyDuFVOxWZi2QyV6k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XfhikE3guLBwj8Z869Wij09nEwSan5JaooHiPLP4Leq6MO2SJc831atjD+F4Q0D1s
	 41WE4V2Pl3izSM02t9EfoEDrHbrKeZ+TWGGtTCqViezWxjdxI208UscWhFL1jtvKr8
	 aRMzuCx5ZLfmFhzFUnLCD6z3enncwoeprrTN1qGk=
Date: Thu, 16 Jul 2026 17:39:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Michal Hocko
 <mhocko@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org,
 Joshua Hahn <joshua.hahnjy@gmail.com>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v2] mm: memcg: initialize *locked in
 memcg1_oom_prepare() stub
Message-Id: <20260716173949.0f87d0ab30c5eecb01067fce@linux-foundation.org>
In-Reply-To: <20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org>
References: <20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C4CF5100003
X-Stat-Signature: fieuxau4cachgoz1ie7ibrcff684174m
X-Rspam-User: 
X-HE-Tag: 1784248791-515985
X-HE-Meta: U2FsdGVkX1/VZoa6ji+7ethRNQcn5kCI2hVu/IEVRsowfXZte+2MgVODiUBKYgJF4uRI5us3yMd2dVi1EyKtzDyPl6gdGi5FoDzLK+wOW3drGgqMGgskaKwSot8loyWn5zPNHZ5SAMP5m+njXSbLGNixTIlcXYAr8gDdBJ/IkG252lBbnXW5rt8iEorPC9PYo60O8kOyXi/ISyEUSSpKxTdnAyFEqYC+1kSJf/37tU02VeDWODyHPMZbU9Ew8EJlJ3AESqHgO+YXhIuUQanzDlpiotiFP+fudjNR6RGPo40FTcchpgj/fG4FhzjHqcRPg4AwgzFzflEDZug1PTxaWAIC4+f0QavLPcM5iLWxJ9J643mv3D1oaO0wDI55mfHxkCt6hz3Qja0ttUFavpSIKn5oTtcXuZ3ShgXBfv+oMzFWxvmCi6wWMxtrCWXPeQZqkQRs0Hq/0Z6IHIZYO9hr7TJKcJYp1sQDCFewA4kycr3aOrHmGG60EefZ/X/Dz4jMKgMAEd30s9p8J0Rm2NAfxsY3kVC6eWFfsleXAXAgyNLxJHayR/5aInxOEq5F5CiIN9zO0o7euBZurvNCzzNTfKbyD4Y2nAYHoKfn3twbw9rx+dN3SEWDSQmMLYfNXE4cCar+uTc+ck4GUGY55Kck+6Iw9bzsHAr0WxbHpZ56BhcT1gqUtCXpgFT0bAWgAXNXCMxl2etWOLi7Rraq52JukWOrM9Ws4A0+gOYYkd+UG/On/Asm4OEfQHUn0w+SiFRjStKUk4HHZ2IemyDyOV0/lSvZe1thbtQjBqvzOMyoD+09rARB8qEgst3P5BBXRiNZSyOjr41XJ0WmWQ90lNrhiFxHkRzbIJpivWoWCFrz00XtA3UZT0W1xDMJ1eVLV9tD4TCHdBgXY9A8H7RB2VYXw1GcygWdPBW3bEbzaPLb2KDISGWFo0IrW1WSVoiCli0ws2a4GvV3FflXmkaiWa2
 lpbWJWaS
 gmag+iJjXDoIVcJe6izKf4JYKj6rGMcMfoOY2EMJL/07u3LRIR8XlXuv1Wz5vUoNNdWokEyP2jQNXlhiUkQuVbD6sYckG/V/pjFmdBKNEvHptudpC635b+Sb/y0kk7rMHUJ6tSE/1ZJYTRhygZcsG6HQn3E0/JXNKuUyQQvXbt2195qtNjZXrQaZ/SFWhwlZxWAU1fAnYNoE++OUSP05ALHCYJiEMwxPbwxL3SsEoNb8rwqlhqIfNmJ46pTjZ0vdFg8XJz3uuyh8Lfyl0FpaZyWw6QBFFTFsRhOdy1O3ZdgKaf3YTGKgOsLaWEyRGc7Tu4GN2EXbzVdEzmXZqMTp/f7lcJFVy+pHzIhUtHneMzCjB7l2wzHlAl0DtvDugPEH2A4UN1sSBhkXZYfb981x3NuhYe8nKN2Q7kpgFRZXbLDRaW78dZSBHUANB/5IpViRgXevUzvRxvRyEThg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 06:42:18 -0700 Breno Leitao <leitao@debian.org> wrote:

> mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
> and reads it back in memcg1_oom_finish():
> 
> 	bool locked, ret;
> 	...
> 	if (!memcg1_oom_prepare(memcg, &locked))
> 		return false;
> 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
> 	memcg1_oom_finish(memcg, locked);
> 
> This relies on memcg1_oom_prepare() setting *locked whenever it returns
> true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
> CONFIG_MEMCG_V1=n returns true without touching *locked, so
> memcg1_oom_finish() consumes an uninitialized value.  On a memcg OOM this
> is reported by UBSAN:
> 
>   UBSAN: invalid-load in mm/memcontrol.c:1932:27
>   load of value 0 is not a valid value for type 'bool' (aka '_Bool')
> 
> Initialize *locked to false in the stub; with cgroup v1 compiled out
> there is no OOM lock to take.

Thanks.

Sashiko, as is its wont, reminds us that we all suck:
	https://sashiko.dev/#/patchset/20260716-memcg-oom-uninit-locked-v2-1-63631d878eb4@debian.org

Does this potential memcg issue look legit?

