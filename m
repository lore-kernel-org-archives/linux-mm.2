Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F77EA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F3E16B0092; Thu,  9 Apr 2026 08:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB166B0093; Thu,  9 Apr 2026 08:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 408AF6B0095; Thu,  9 Apr 2026 08:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 310B66B0092
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:27:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3DD41B7826
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:27:28 +0000 (UTC)
X-FDA: 84638942976.29.26BC7BB
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf27.hostedemail.com (Postfix) with ESMTP id D2E7940004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:27:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="RwRP/kx1";
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775737647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZPTbiLq53ot9iWPM7HtJltAZddmRwOh2+RL/t3MN08=;
	b=uWdty+asH7Zbw1TROcRPK5K4YrvTF3BcOvEc1je09W/1MufpfLjqX2fd6QsivYE6RjROX0
	BD+blCYOON6lJRJRCGsNYfFCHSj/auKJDGsgfvglPfBgSdMrFv43Zzm890NBU35KW5YQle
	xgIrUYsJedof7vJS7yFGlUHRflPfXS8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="RwRP/kx1";
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775737647; a=rsa-sha256;
	cv=none;
	b=zS049NJZuLNN9ZBqeYxfNrA+tYWa3hRI+2WchCPsXA34pOROENNOD+uNld7OlNWY/pIohx
	j7yC91HOf+5uYktBu22jGGUaHzLS8MDF5YfLuROvoHm1fgbKhvX0NgRKwT1CPcE9nseCG1
	V+e98YMggNKp6ugGeflv/aSwa170OcY=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 1217DBE7B5;
	Thu, 09 Apr 2026 12:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775737645;
	bh=uZPTbiLq53ot9iWPM7HtJltAZddmRwOh2+RL/t3MN08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RwRP/kx1/fnQuR6igiUGPuZojD7cXA7EjCwFkUqUkh6S4q3UaVWxC8VDyW9owGu6n
	 ve6oiIzDxXFd/8QXcZnJQDSiemlUcYZQG2OnEMy5vYBKtJX9RsFaoo/BAA+xq6F8XJ
	 xctfxwGP4CklzotslG0wHr7L1oZtFzNrTXw/FdOY=
Date: Thu, 9 Apr 2026 12:27:21 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Breno Leitao <leitao@debian.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <adebKQaiAP4G3liv@shell.ilvokhin.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
 <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
 <ac5urCFeEB9oyUiD@gmail.com>
 <adUhtrhU7c1TJQww@gmail.com>
 <a9129d39-f9dc-4f09-b951-203c8e28b600@kernel.org>
 <adZopu5wjXIR5HOR@gmail.com>
 <adaGcf2hKNGHwVPd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adaGcf2hKNGHwVPd@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 81djdcirceaqywmmn5ioonrsx9u4x58m
X-Rspamd-Queue-Id: D2E7940004
X-Rspamd-Server: rspam09
X-HE-Tag: 1775737646-558806
X-HE-Meta: U2FsdGVkX18BqW0VGZ3I0nhGe0n2YIupqfVBhkud4xdswBSOsAAE1m8gMHepNe2Cx/1t2RAoqzGr8AoUORVOx36l+feiKDWJn5ZJhd/aLdYCxbcOJGuQCXhdRImquPxyLzygLkMZUjh6SDV4C1y+TLhSIVcEbxrsxFx7gWttCFzWFpDQUdTu4WDTi0j92xG9XECZa6wq118uQDBuUf8ih0gJ7whh1kXZ0ojA+liBOhL7+8SHj1AnKUSCTQKUIbMSqfKm98zDNCA0+fSZI/kUoQ5RWmoLfugFLA1xaMuwX5jJ+1wRmx9TbnyHwt4+tHvXaSmJe0Ok/VpW0aRY1W4pqvisoF5Xo63dBAEQcVsja5+xLrgEK8UV8d7cse0kRt5+SRfP2eZnPOKCDNcZF68qTiugR2ksnWX6a2LewJgjK9sWMdbEYmKGDmvyc+i/6+SLeGQzr+FJv3SM/droy47Ai6pQsan7bT/2MeHaTsFIi2bnfJxqNy1nUYtz897iR+qK6mbbiumHrsDS1YLJuWO18FPBMIyKyASHMRTYjPzbNZy1P//ciqHiFl45VcD9zvLx6MuSz81ofeAeQtDX7jb+e4SJKPgMUOl24DBFAJt9rwzHPFClKwpKPbhnyiVJkTRXYvZwm79tFqeLeOJJcD/zfAvUyymrG/s1eN3cVhB4kmbLsS30lmebTFsw0dJKDQyLIKRPMucjKtHYqFOYetmeaB1OX3mZ/sIzzVux3JjUnLv1vwjr0pv0epgfUmrFuvfOd+Bv0pWq6ys3hWni6mbMgQfUdQWDtOVeo6zEzOuMKtk5uk0FZ5ku/Uc90B8/+EQ5lH7EP0PnW/J5FuZP8wrxp1lyR6HbdLNthcB8hQhU1+CpNlb6kdUd19ocYK8H8RkqrQj6/ewGMzxa+vMNLrSYG8Vq23eadB5jcOBrT6t7y5+P4/Buzt9KeiUgv5Ao5jc33dRuxKiwTkGkt74enyX
 BG1Rm66z
 YwbI4SJPCvbPY6tKdXBj2ydXWRHLrPtUxn9Ww60SOSjyZIUgW4kUNwh2w88+hY+4q6Kb7qlLKSp0BAGz+1eEjg2FccqDY58bzMYb4ucTODC2+3XwIvnJ9nKCxmKUGPp0SZv4S6OJeWelwPGC50gvrQjrN0/fu9iGVbLjE/smz0V1v7HmYXssrJZ47J7QYU4Q3UwYDX8yolulYSMjyaxi/3oJxRc42dnskAyveWIY9Cy4mRPCpeMrYHJ5kJnZEeHUxCJsXmnLenZB1VlGsbwRoiCReFB3z8ELuMqy3TlXljYoLsMvBZSOVyKiSgVhMvjjgS2tFZ2/UPik1DupUVgMfNT7QRaDvea1dq7At
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> 
> commit d725f0664b70aa5c677215b0fc1abc0117aaf114
> Author: Breno Leitao <leitao@debian.org>
> Date:   Wed Apr 8 09:01:02 2026 -0700
> 
>     mm/vmstat: fix vmstat_shepherd double-scheduling vmstat_update
>     
>     vmstat_shepherd uses delayed_work_pending() to check whether
>     vmstat_update is already scheduled for a given CPU before queuing it.
>     However, delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT,
>     which is cleared the moment a worker thread picks up the work to
>     execute it.
>     
>     This means that while vmstat_update is actively running on a CPU,
>     delayed_work_pending() returns false. If need_update() also returns
>     true at that point (per-cpu counters not yet zeroed mid-flush), the
>     shepherd queues a second invocation with delay=0, causing vmstat_update
>     to run again immediately after finishing.
>     
>     On a 72-CPU system this race is readily observable: before the fix,
>     many CPUs show invocation gaps well below 500 jiffies (the minimum
>     round_jiffies_relative() can produce), with the most extreme cases
>     reaching 0 jiffies—vmstat_update called twice within the same jiffy.
>     
>     Fix this by replacing delayed_work_pending() with work_busy(), which
>     returns non-zero for both WORK_BUSY_PENDING (timer armed or work
>     queued) and WORK_BUSY_RUNNING (work currently executing). The shepherd
>     now correctly skips a CPU in all busy states.

Great find. Thanks for taking the time to track this down.

> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index d59eff1582547..5489549241b51 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2156,7 +2156,7 @@ static void vmstat_shepherd(struct work_struct *w)
>  			if (cpu_is_isolated(cpu))
>  				continue;
>  
> -			if (!delayed_work_pending(dw) && need_update(cpu))
> +			if (!work_busy(&dw->work) && need_update(cpu))
>  				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
>  		}
>  

Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>

