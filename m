Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68212C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E337E90004D; Wed, 13 Aug 2025 04:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE457900044; Wed, 13 Aug 2025 04:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF99E90004D; Wed, 13 Aug 2025 04:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7922900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:54:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50D0D116DF4
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:54:32 +0000 (UTC)
X-FDA: 83771123184.14.9B6CFEB
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf20.hostedemail.com (Postfix) with ESMTP id 87C461C0005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:54:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=herhqNMS;
	spf=pass (imf20.hostedemail.com: domain of matttbe@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=matttbe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755075270; a=rsa-sha256;
	cv=none;
	b=JR9CIUW2QQNFvIwLqRegNGD4sODDLhOTgsafM5hKat+7RjuX7S/qrz95o2+4j8xFUoVQ/4
	G9aDzoiVn+693eAGVSCXppfxJych2r3iOdWfjzfyI2MSwzR2e50Gr/z/Qya1KOhUeQDlJ9
	PwR62JEQbJfj2DAv9YSweKMy+x34BbE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=herhqNMS;
	spf=pass (imf20.hostedemail.com: domain of matttbe@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=matttbe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755075270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bYa9mUb5uxj6WPrcxCuv1pDwScipXB1/jOiT/1i4T44=;
	b=amtB3PBnYDYtnhXZzxKtIOhdUNrCDHHEa2nN/EdCukASaO1WhVOCwPGNW/JZ1bv7SZN++h
	VuH4RyLV2MFaSVY7Ze7AjITvGAJOOZYhls5DaUBYGoSzJtlC1KP2G8AoyTDTwcZ3VSon7V
	KDVAwNjTs71/V3+vwdQQ29uHKiM9bxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 970A7A57B59;
	Wed, 13 Aug 2025 08:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244F6C4CEEB;
	Wed, 13 Aug 2025 08:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755075269;
	bh=SPEB5tXelaltjOYbgqCSrRrEOItBWpxIPqLytrMKnXI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=herhqNMSZD2u105m3vJP0R5NGzYg8f4wgoRgW1wtPscJKKIJ8iB4LCJ7YZVRkLPll
	 aCCq99Y1WcMsFRfF/bEfd1fSFHveJwvnInSPrmYXF2cRC2hyInkxWN8eQxpBsmUJ5V
	 YYqJztfk0ZrC5Nj6PYyK0wR/z1CMA+zjyQ2L+rgakOM+7mxQpupCHI862M8uAUf95o
	 1nJMo9GRs6ivwlUcrBQSLXyiTO5gay4Ee2JPzyWsMsJY8m4R/U9q84az1GLtzRIh0K
	 dVVBFh4NXq5IGdfu4xeKewoyKhGtZBzp+MrA515ppiDaVha4AKPsNTEq2kPm4+UDir
	 r3hGyQdMGXGhw==
Message-ID: <603e3360-1f8f-41bd-94fd-a4a94e4a2c34@kernel.org>
Date: Wed, 13 Aug 2025 10:54:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v3 net-next 01/12] mptcp: Fix up subflow's memcg when
 CONFIG_SOCK_CGROUP_DATA=n.
Content-Language: en-GB, fr-BE
To: Kuniyuki Iwashima <kuniyu@google.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>
Cc: Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>,
 Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
 mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-2-kuniyu@google.com>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <20250812175848.512446-2-kuniyu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87C461C0005
X-Stat-Signature: 1c5xtqwfkyb4kezhjftd4mo3djptho6s
X-Rspam-User: 
X-HE-Tag: 1755075270-969237
X-HE-Meta: U2FsdGVkX1+lVgCtIg4YfhnkbTzjwz1byYYqja/BkNs+0xLSwV1aVCXabLLaZTDlKYMe/aqri/TCHUy6pfvH667KVF6RmOc7AFh0RY/vh1gfZvYdoMxV+PLq2Zr2CkpYYPy6WnnYQ4iGIk52fPzuCQba/RZUD4ZrP7Uc4upEUGE5STPyeb0zDhDUZX7IWL0bDSLEKquwJasa2KiKtY6d9VYYLPKG3kZ3Q4lmuoj1P8vZUJnCFNQcY/S+mQlYUFQMYuJOlWptmPEH/ETvmqNf8+d47x/kMOQK7ockHo9gMkOwJ2Kd15SMudOPGzK86KxonFYXgrbX/56ihGX4lm2TCZmdQxCuGAuOZwjG25NmUB0Xg/evchbk6guuBdcHMdOusiN8IKYhGDycNDjaMDmAn2uUWSTzcLGxcl3HDRsOobXFnUV4nlnMMM4k0Nomc8IYmmJnP/3ennrpbDNbUCF94kxYQFPm7L8EJwTxOv18Zs9bJU72uxUKUJ8z5+voS22oxOiVW5QDMc2aF8+A0439hVFLw/CmPbpbw0DIHIIyN/67MSYuKday/TWfd2ZL0WvENhmeDgQU+r/J2mJFE8GdxKFDuMj0JvJNucNP9EroIsIfDgyjhtSfC8deJx/Jj1f8y7fB39Fpa3l95J81ATRtMGwZ2frktZSRr1+JBJ042kJOf6aTcMbmS4wZg5xWLhc+erEIJfd7QOXgmbLOfHCUOpVf/U4Zwb7SFr2yXxuq2jgV43WtmLhSVvMKZdyupZXFD+wPMj0KdqzNhhFj5izchynnQHy8ot9Ns9lMPuVmUOy51/5GREEXSP0AmV2wPw9nY1aUhuXWo4YW0WyI8yvh8bqesXiaRAFmy0QmPA9Mnxm+pvKFSKRVLaQbh+C3PKu/YRG/SyqxQlOJUJRWL8+x/iBlbFSJXV/g6G0unETaM9sn9RS1JdgVT+J0uFhFaxbQYqNHOo2Tn8bfrjNAdrf
 pR+R2W/b
 2blhcoNGA7rq/mAPrvS2RotSjy5cBX3kAMvIX8eJkp44hed5baWZK+jE3G9TbwpQl9Zbxj/VTUjy/lz5VzpIXEho4SxPQmgcBHdx9SveriHXLab2G5FGc1OHDH07+cJA++xblN/e6HiQlk+Y50oF9eYvofNCkn17p5qHN9TyxvEHFr+E35b9Zr+3OvdQWfOSI7pUVl5BziHgZTl9B6Z/F6gx5Z0atCiOMZUv0XO7Bsf8tIrtLJYSGmPahNJXUglFadUXX6qZMy0YTWvHZbNbF0uCrTnwijlok04QBcsBbLccYOHdygHXEgKaL7PeQPjfT45VjUXWi/gk/3CXrI7m7ijFDpcXvDDmnjL+xZsTu3458GrY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kuniyuki,

On 12/08/2025 19:58, Kuniyuki Iwashima wrote:
> When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> sk->sk_memcg based on the current task.
> 
> MPTCP subflow socket creation is triggered from userspace or
> an in-kernel worker.
> 
> In the latter case, sk->sk_memcg is not what we want.  So, we fix
> it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup().
> 
> Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
> under #ifdef CONFIG_SOCK_CGROUP_DATA.
> 
> The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
> CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
> correctly.
> 
> Let's move the code out of the wrong ifdef guard.
> 
> Note that sk->sk_memcg is freed in sk_prot_free() and the parent
> sk holds the refcnt of memcg->css here, so we don't need to use
> css_tryget().

Thank you for the patch!

Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.


