Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A78DECCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB798E0097; Tue, 14 Oct 2025 08:35:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA36A8E000D; Tue, 14 Oct 2025 08:35:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDFC38E0097; Tue, 14 Oct 2025 08:35:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC2F08E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:35:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A25811B08C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:35:54 +0000 (UTC)
X-FDA: 83996666628.18.D4C080D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C0B79A0015
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:35:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ex+R3y//";
	spf=pass (imf25.hostedemail.com: domain of horms@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=horms@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760445352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2q8nzYEKT3mVq5Szt+TfQESP0vSaFCiLorqisHY7WPk=;
	b=Hk0BnlUkOb5HWP8eZ1oXTbnw1FH3E+1pN8UuCc7Xhfumf2lhQ9nrEJpl2eDhjxbUTaHGXe
	gXc/PU4QPuIvPZLM6Ie7+zZS/mCMonRAPtRCDBG6jerYBU3/lBEPuuxa9Icm7nTgdYPfzT
	Y/MBcDZ+QotDYTshpA+R9QMYeYrCmdQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ex+R3y//";
	spf=pass (imf25.hostedemail.com: domain of horms@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=horms@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760445352; a=rsa-sha256;
	cv=none;
	b=Xj94vztyTJ3T+CswrBwYpaHI2UJSnFCSn8cq0b/c5eE3Utskf31Ukr8C99OAOWahwRpYJd
	37hw0Vv0dGPpLxNKv/grwU5Ojfawpdp7pmhUG7/7thIT6tyzSsGm/OSpd9+5gB+jh7uwQS
	EMDhC9mTCArNV9BM1b/ixkLDnKwJ8/s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EEB82622BF;
	Tue, 14 Oct 2025 12:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613B6C4CEE7;
	Tue, 14 Oct 2025 12:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760445351;
	bh=veFrev4WHDqJr8PvwptdqQ0qevY7NBnf6uVDF8KwJvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ex+R3y//T9kDG4MIndwspLzW9Vx5zWHgE/EaFVi2WPfvoDb9Wm53ZgK3WweiF8OFR
	 UUpPSvNXvWaVMMSpa2NFfFoaYru8wVeUVp9LWCfqdK4O6GNUzIU3ucGrpMQufywb47
	 kOIrAwSVguW0XyImU4o61QWE8OzcAoMP5nF5hHqTTSVn/s4CFrSlHrUfEukcVzsd7q
	 KdYC4RfDc08pweMnxmXVaFZYxFRHfmp2XAIaBzqAfakhF25hwmpiq40lUfIiv+6zWC
	 FcLWsoZRYCArglDakt8a2zEa8ZDsd246egHvmkRQV9YE36MTf7aguEqQQhhipNbJvY
	 GuHfp8lhzzwuQ==
Date: Tue, 14 Oct 2025 13:35:43 +0100
From: Simon Horman <horms@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 30/33] kthread: Add API to update preferred affinity on
 kthread runtime
Message-ID: <aO5Dn2AwQWn0SQKQ@horms.kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-31-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013203146.10162-31-frederic@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0B79A0015
X-Stat-Signature: bx7gmsofya1phkmszmgnbmx3mfh3cgag
X-Rspam-User: 
X-HE-Tag: 1760445352-668990
X-HE-Meta: U2FsdGVkX1+0XGn2kfB1b79J7UnmGYGhMP4Jqj6ZAg+lCqL/V8+ctbcAKZRiPWHfK9obL7KyReZlvBEUAJI/vJ/8zxFb1set3DxtPHuFEY679YSjIaUKUgc+GJa7nXQyoQQtal2OjR0BZzb/EdHlpSqXp55QGBTTQh5UlyVVAYPqw9Se5hMnUgNgvZWEnYdTaAHwg/lmYpxt5M/VICQtwi6R8rX+MkOQgNUBiqtCLNbn7HJR5nwha7nyWN7hdX6fnw4u5GX6vV9I0pT0mEGnfHMaBxDgaoLbv8VvDBeX/LE3vCHVjeVwUWdbtcZEdZAfgILXzksfCYp7UnDdJgW2cLJGKKaJQ8ZjimC1hkadVKVaZAX5xhOl1KI2eEjACrSvXiCt7lIuP/3uhpkU57ERkHnsa3AVKlbVpR4L0JeRoYm0OqV9khp1btccqTKR+yoeXx71BvPq9Yfux/kEYflni05FA/E7srt4PFcVTyxujPv5EqE29tcX5DIhFLNq9raDihSIZr19ie3B125mf+0GW+VE4BVHn4G19zfNy9vuu5/3iv9sIebk/KvPlQLA0JNkq9S40ABGQHBj6gWSRvbaajNzq+nsqVfU8w0Kml+vigkZMzSg97Z69Do704kZIACyk11xbO3br/bGflL8zxuXlJgUP3AcHUr7RPajJQ1lNkVb0iijF6ftK39bI9L6sijl1xxxtFlTh/zhAOMu7v41vRFgp6MpIpQ9EysXY8BGuR4A4SDyXp/VL3gDCoR34H8kgxqfxC0J6u0UL5VmioK/I4o9KpM2JGmqdxCLvtJTSD2UfXapcc+paRVZaBVj3uCA4OTH8iGFNx/w2Eci6/FulSES44yMV0TvwDNyGG9++oCcDFslAI0fyAiowzQL22ftIAwZumrlwLnJbSYjTcsux9ag8+S+2WRXQJ+bGQgQSr77VBw7N9xERkCFWKsgnQKDqQHSp5fuF/F5puN0FGh
 GgVP1vMV
 czMHam7TvqKddQS/5t+8KvWuaVHd48Tu5a6m5+QoUFsj8EJzGDnF+300fSOU27LtjWrKDxXk89dApIK1zx/N+YWiA6Iep04vBjVWnBTr3VtfLeEys8JD7EMkh9FZXBOtE+Q/X3S7+xrjQchbx2KXmD7aRz2kPxeg6Q2/hUC+duENJXfluNh+huSvOgzMK4D0cDiDU9wW+vxWaVXCDnKwcC754cNwvaxwXtT6J8S91dVedKU6UuvFDeEwOojJpoJVUnXxh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 10:31:43PM +0200, Frederic Weisbecker wrote:

...

> @@ -900,6 +899,46 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
>  }
>  EXPORT_SYMBOL_GPL(kthread_affine_preferred);
>  
> +/**
> + * kthread_affine_preferred_update - update a kthread's preferred affinity
> + * @p: thread created by kthread_create().
> + * @cpumask: new mask of CPUs (might not be online, must be possible) for @k
> + *           to run on.

nit: @mask: ...

Likewise for the documentation of kthread_affine_preferred()
in a subsequent patch in this series.

> + *
> + * Update the cpumask of the desired kthread's affinity that was passed by
> + * a previous call to kthread_affine_preferred(). This can be called either
> + * before or after the first wakeup of the kthread.
> + *
> + * Returns 0 if the affinity has been applied.
> + */
> +int kthread_affine_preferred_update(struct task_struct *p,
> +				    const struct cpumask *mask)

...

