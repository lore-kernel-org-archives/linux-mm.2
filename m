Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B9CFCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62508E0005; Wed,  5 Nov 2025 12:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13FA8E0002; Wed,  5 Nov 2025 12:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902608E0005; Wed,  5 Nov 2025 12:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C54A8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:26:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16D201A0168
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:26:43 +0000 (UTC)
X-FDA: 84077233086.04.26BF75E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A1CF140015
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:26:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OParZvII;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762363601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7lghsdtJqQPkyeqPZcgsEqUxzm/bu72iLJp6V770hM8=;
	b=pRXwtmrhHE12WLg6OGppoE1w3E0EI1l5cP03h1HVjVU/aFvB9t1VWekzHg7OfTtfYWKBCL
	emCI9PeyFK1uxALrHsQd1qEO53Q1n2Sz56/y+tjPzSTj0Yww9NINvGn1+zOcYlJdjmHXor
	MDcoA2DcU675Bjpe06CChVzBCAI7l+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762363601; a=rsa-sha256;
	cv=none;
	b=DjaPzkF0HKjQHk8+jUtNb/4yBnN5pJcz5akkx/bwFfzPmByTtbeX77w+tZxEjZbXel+qIt
	sv4eRzYuwpoYZCLwhxTAuIj5aJR4h1rbwQre65eR8kmv2cUPfEhTenk3Fp0AH0InhPoM/N
	TtRZvZe3nYOmhC2tenmlIEPGaAMlbsQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OParZvII;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31D7A41A7D;
	Wed,  5 Nov 2025 17:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92223C4CEF8;
	Wed,  5 Nov 2025 17:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762363600;
	bh=YFkDJLxlVgB8fCGfrzLzPiyZl67TcHqa4QAD1eCk1n4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OParZvIIPyLR/7+d2Nc6dNNHFfgvciQYcDXNfvWRUfLM3ALdZr2Qma8M0FObiSEDX
	 4yAZaB4HMBbFQrVX9l1Nc5Mz9Akx6GYVPeFSxJauPuNjV+cvXZHiYCJny752RKPXaZ
	 nb6HFbh2rTIqP1/GSHtyqu5D4fAirasFidCHLVTYcLZQRPj1LLeRYNMtTIBUkecGZD
	 NUQfI4i1crcBXLrqQ3YrkVWcmSf4kYDrq048l6zq2V/zPjyDvLarmgFinhmBNoPsqB
	 5DP9Yf37WOYWdxdZegji5DJs83/ZGNy27MtOeueRr7A8jum6leEhur43LN6wcOt6ld
	 1Fax28SwoFeww==
Date: Wed, 5 Nov 2025 18:26:37 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
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
Message-ID: <aQuIzQo3tDbwoytv@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-31-frederic@kernel.org>
 <aO5Dn2AwQWn0SQKQ@horms.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aO5Dn2AwQWn0SQKQ@horms.kernel.org>
X-Stat-Signature: d8kn5wuuqa4ojo3fice6hmkbqpm75ysu
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A1CF140015
X-Rspamd-Server: rspam10
X-HE-Tag: 1762363601-471934
X-HE-Meta: U2FsdGVkX18FFKq2fYL2aZUnICcwmfL2ebze9nrgtgVOTj/EPTCcMmjumvazJiY8YCvoCujGYzW6kPQmenjq5bHsG1/ummb551UXOrTPQwasudhJBuo4tjLF1JW531k8cRS+KhRlphWlNxt5RnXu6EH8NkStBeLe/CdYxsFi3VDAx7xLnu32S5UmrTYeXGLQ9Xzc9lR6nVLXAlGYRxslmyleY/D6XOo5Gp7cbK8Od6Jtm3P5cdCsYOKcs29+afgmSLYBxz7J3Z58F4gJ6pM9l19UfV2oYxh9C1ASuaVuIotMOYIT6rrj8Qa2sqCHiYaGrK5ljg5tIWHabfr/HaH9Lo6Qi19l4Ejitf6/LH5JxdE/THac1uR0XIDpCXYm9JxzTw/oUMquPa+bvmBZeo3AQB5XF9x/k++yzI3DHj5XdJjoJ/BVKbpZrVt6H29AagJTjdFNlQ5MbvB+bkR6xdGPO9sADgYRFlOPl5DBqjH/X/6sV9gzUeF5pLtfAwIssJ6IC+Uhy2b5HgBiJSIsTeCd0gFQESkeds3ZN48/eTqiLknEqrh4izJbT/kFUU21uBRgPXoiDdpOTk61BYuE94XRaB0/HL+gxbESNzOhCsNtRvqiK33zGAZ4ex7c+Uai0OJ0IphdGU+rlXD+slh/SUJXZIj+pwPQkFW2pfN59V3fzLRmT0/5395wIZCEyVGMGFQL0RgEMATqT9+75UikmsrqBlAmiUcZz5oi9mCZA3LZwjygo7feiXnGvaieaLxf2QdGnPHv4OukQ2ToPLvCcZXnZq0WLnLOZSCDUXE8FEHIJ4dijH0aOpgDpBImgOb0rv9DqVm9ZBvYyBglyO/iYTJcSeK/EnfntKo35Q2uh3MEdSTjcYXamLEraoF6AFT2vS9g7xFtpzUhTUOhdGc+j/DU1uFj9lwbdPjw31UAq46QeUji9v85FXx33IcCK4LJjwIib/qfH/YX+dZFsLGSUwM
 zdge/Ztx
 omEwtJNJ0jizk+gKPxjcc9LpPcPWt3yr1AtUil8NDyRpyJ0ZtNSpBk4gXfvLygFD3/GSdMO4Ie2cTvQUtI9owAIfuTGvBw7fxZY8GHPZzTLrmvhYtBnrWolSzufYhfAXvKZqNC2P75J1vxzmRDyTufx19z1rB5mWWHSnKRt5l/GoKSusRCyvPXz7nCLcnZUIHf/7EIkNkcdDm/hV26JhgjqASlFucALMwnSyizAwPN49lj+A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 14, 2025 at 01:35:43PM +0100, Simon Horman a écrit :
> On Mon, Oct 13, 2025 at 10:31:43PM +0200, Frederic Weisbecker wrote:
> 
> ...
> 
> > @@ -900,6 +899,46 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
> >  }
> >  EXPORT_SYMBOL_GPL(kthread_affine_preferred);
> >  
> > +/**
> > + * kthread_affine_preferred_update - update a kthread's preferred affinity
> > + * @p: thread created by kthread_create().
> > + * @cpumask: new mask of CPUs (might not be online, must be possible) for @k
> > + *           to run on.
> 
> nit: @mask: ...

Thanks! I'm dropping the current patch anyway but...

> 
> Likewise for the documentation of kthread_affine_preferred()
> in a subsequent patch in this series.

...fixing it to that patch.

-- 
Frederic Weisbecker
SUSE Labs

