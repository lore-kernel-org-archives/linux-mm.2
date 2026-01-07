Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 452E7D0D17C
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 23:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A592D6B0005; Wed,  7 Jan 2026 18:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A305D6B0088; Wed,  7 Jan 2026 18:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967896B0092; Wed,  7 Jan 2026 18:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80F5C6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:30:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B192160475
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:30:19 +0000 (UTC)
X-FDA: 84306763758.11.F67CDA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F8A110000C
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:30:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FD9BLnDO;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767828617; a=rsa-sha256;
	cv=none;
	b=DVDX10EFsm1gdt5OiIGFcpBENYsi36Ax+sxFvzX7L0hyEQuekVBgHYWOKU+x+bg63WMsLx
	uX84h+KUVwCJ2T+AislF2o4L8MsGMui+xj0KOBhUIpFYkgTjjChNnaV1l3rOvyhIAoe+SG
	xIJ7yPnTYd2VURTWRKxJKkq7JwZ+TY4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FD9BLnDO;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767828617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYDDOptSKozzHAsa2V9R60bnAHolTMznW5UT887n1uM=;
	b=T0colYJ+qiTKdBid1x8CdKOGPq8xJx11NUFXfWFQDKJrdqbqd4LpoDM9HdqMcD9ypvJXvL
	EnhlNiG/MsLVPmjXNaUBmsNbkgJJKXkQUcmSWqhSEjlprymKNASoCmjFJahKOpWnB7f2LH
	67u0vSWs0h4Me6Ljk4X+o3l7W5N+DK0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36C0841A36;
	Wed,  7 Jan 2026 23:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E29CC4CEF1;
	Wed,  7 Jan 2026 23:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767828616;
	bh=JJUKBnRRM9z3Ei4dz7JLCEY8pd+eY/BXxSmSJZTydcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FD9BLnDOkE5gza7p0aI13xDJW1xjmBlp99SMKC13B/Vu4oiy+78aPYh+cbVuLnYGy
	 Fl7pXOjBsyLlmELBlm+4tVm4lT63RyIqyfDl24wlumHGuh2jgrHdHOEDbXU7Y+iG4J
	 /cHcKtewu+hEeQy6sIPWCWmwhQ3xTmh8+irt2gmFHTE1PNT3SnQzutRbgCHg4kMkqJ
	 1v0+eyQaw8MBLlsvVmyyPvKgWUeroyNXlpAAQskjsL5sHDX2UY4zCFhfUJoa3jI8OP
	 30a4z9OUHiAqzAQ4p/IXy7EOUGqDGWTd1vqf2YxHqqwsrhtrrNFsIBVPovzyz95bcV
	 p1KJ2zvhxZYtA==
Date: Thu, 8 Jan 2026 00:30:13 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
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
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org, Jinhui Guo <guojinhui.liam@bytedance.com>
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aV7sheFKQWb23lsc@pavilion.home>
References: <20260101221359.22298-2-frederic@kernel.org>
 <20260107190534.GA441483@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260107190534.GA441483@bhelgaas>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F8A110000C
X-Rspamd-Server: rspam04
X-Stat-Signature: qqgqtb6h6i4kj1tqx9orit36etkxxr5k
X-HE-Tag: 1767828617-56198
X-HE-Meta: U2FsdGVkX1/kIuw/nBufCetjn8J745RxHfYHdhKF/7KwGy/1vr1R4a5R+2uo/1leuyoCGGvPAo3oTwD9r4Bun1FtkpedoAGJMt87ipgIVqUj9r1yBdzc9xbft9KSX7Mc9JP8URVhLkK85hs4pU7NZWdzAJfyEZGDp/1aPZeIFBNXQGuWWFMcO+60ICHDuRKQJU6ARRLhgvKqMl17JF876YiAvmz6E2BjWcH2U1UR9mgqT48qWaLSV0vnHnNu6Lf7aCHgleKOhYy41EVd88cdKbuiu1u9p5yk/vfXwyl3aELzHVIoC4N67U2FN/HALTQoNDHh+h4HxlfXrI2uRu1U/29EzncMPy0+PBqtzjL3IopqWWd0+75PsuNcWAJn1qYisWOr8OEx0hitsQVRlyDJ+tN5h8CaG9N3zKcLlGUZvZx4PnxzcvYaDeNt9QsKRuW+LQJoSRO3tgJwviSnbpM/Z88KrEvZEp7dZcNUWuWOzpHNFqbcvJeNBgVDlHRW4H3YSRzwKFN+2ndfSvq94pxE8KyJOfpIxOu1zenveKapLkvonjdRnpzHlKhUwUt+R1fiWKWUxyuiFfvtdgOcFs5SFtItJC5zosHlFX5uv2m04PNN/I0DRiO6o1zzbiKfqsOOHYfJRrGnQFnezrKpkWnrDWGrAD3cVoJ5WWqNgL6mRAm0iy2xvUMuhCXHfrJ2cVV9aRb3E3hqZMkjiw86Ol1wlidjecWR1xzpBfWB8mbvFUEnXsAHKhj69uqiet1vKOciDZokbQ6gjnzAUzRt734mkn+ACPGdD93NwZ4YMLq++6I85yuwNy9Zoagn2sJt+ocy5Li7Dq2bYAN69bRXXr54jWk3ttWKlqodVa2h3qPzB5DjZwanhnAzFOqJezAPPhC/+zidW8mUacv/do2LOU1cGWMaRlA/crQeoEF/srGm9K5Vzpp8xxddpsMlriV2vjldCnM2mmpgf3saixvTT5E
 J0AYCGai
 6TrMTDkmo01Fu+XM5uzaL6rktYWOTSnlDxfZ2DVILzIMtcO6+1aFkfci/6EddA89l9J70h8b5gDoQJ2NtFopGQb83mEg/JTlx4HQUeoVFJSiwbwSu1mNxQ/pT1OgYawmmms4DKn5IMgK4zJwpVWywM+c9dlthHwIr+qk7gnREC7hP1vOYoJMYKkB0oW/gPRSUhwYWG34n2fxGtZmTshVlBFzXLBtrt7WGmVwgFyQ2jtZm6wsjg5xl/XsD9rjTQtKbd6rA+8M/17fccRxHq1ZnmVzqyoSqoQR6W+ou
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Jan 07, 2026 at 01:05:34PM -0600, Bjorn Helgaas a écrit :
> [+cc Jinhui]
> 
> On Thu, Jan 01, 2026 at 11:13:26PM +0100, Frederic Weisbecker wrote:
> > HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
> > therefore be made modifiable at runtime. Synchronize against the cpumask
> > update using RCU.
> > 
> > The RCU locked section includes both the housekeeping CPU target
> > election for the PCI probe work and the work enqueue.
> > 
> > This way the housekeeping update side will simply need to flush the
> > pending related works after updating the housekeeping mask in order to
> > make sure that no PCI work ever executes on an isolated CPU. This part
> > will be handled in a subsequent patch.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> 
> Just FYI, Jinhui posted a series that touches this same code and might
> need some coordination:
> 
>   https://lore.kernel.org/r/20260107175548.1792-1-guojinhui.liam@bytedance.com
> 
> IIUC, Jinhui's series adds some more NUMA smarts in the driver core
> sync probing path and removes corresponding NUMA code from the PCI
> core probe path.

I see. I can't drop my change, otherwise my series alone could crash
dereferencing garbage. But Jinhui's series removes the need for my changes.

So an unpleasant conflict will happen in -next (and if everything goes well,
further in next merge window) and it should be resolved with simply ignoring
my changes and only apply those of Jinhui.

Should we inform Linux Next people ahead?

Thanks for making me notice!

-- 
Frederic Weisbecker
SUSE Labs

