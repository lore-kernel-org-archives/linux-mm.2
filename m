Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9CEFEE642F
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 14:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97C66B0088; Wed, 31 Dec 2025 09:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62D76B0089; Wed, 31 Dec 2025 09:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99AF6B008A; Wed, 31 Dec 2025 09:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B879E6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:02:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 496F31AA10
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 14:02:40 +0000 (UTC)
X-FDA: 84279931680.24.B873D16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7FCCF8000B
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 14:02:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V/KYCPL7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767189758; a=rsa-sha256;
	cv=none;
	b=oJgLSILb9F0t4UlCeGAz+hWaoGXBhn9ZblMNYzEpSiS/RIjthehO12xSaUxvAu4Qj+wTFp
	O2Qog0O6QffRiHqGaihCBrLl6x6QPuJzUq2lgkZGIYwyiBGv6P1S8mOROXyWL/LMMyNibQ
	+cxamdw62dt6aADhuLTPwwlYnOjGVDE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V/KYCPL7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767189758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWHiYn4n+zWsJ54dXyXzY0GI3GkAZQGiV077bTpVEIE=;
	b=0RMZkXviFqMLJIgj67kNdgmhfFv6Cph6zFjxT+Pjg9CxFjNTO3uKTLoBXJMNKnN4ABB9gP
	IuGsaSoI+XK2rRRXo255Y1v3a/p/ucqcwwD5PagyaRG+ph7tAo1jImaoKJFro4IQsNTDQy
	lt6jtKVLBLPTdjubOU4KqEiH3g9l5GM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0D5660017;
	Wed, 31 Dec 2025 14:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA17C113D0;
	Wed, 31 Dec 2025 14:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767189757;
	bh=CBFfLku7dIdIU6H6oIpUvPWYyR6ucYYMUyo6GlFZdAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V/KYCPL7ZtkMijc6GCGy07DqTpJm2bcO1Hyk7oeLdmLDr4cryXHiAbYSa0rdHoTmz
	 xO1R86BMlXOvB7Bi6HCf0I6MrrXlvW4Tifmo/YaGV1r6/hXHdzochqy+Rx9CDugnW8
	 KL0pY73twndKcZdjNDfVh7l6tZDUjQW4VDWv/nAL9ad6qz6ZAUtNrHXDCfP2Cywtm6
	 ugYPs4h+jagAwy6hsofbysUt3OS9gH+6R84kJxL4x3DsSiKIXbQvIHr3qZRG6sMKpf
	 M6jkkbfhDqzpVpnYKxH0r6jDyw29DBX9RAwbViO1Y+CIGYDKBMqcVEFznqc1PXd0Hw
	 Qai/24OW/4z9w==
Date: Wed, 31 Dec 2025 15:02:34 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
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
	Johannes Weiner <hannes@cmpxchg.org>,
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
	netdev@vger.kernel.org
Subject: Re: [PATCH 09/33] block: Protect against concurrent isolated cpuset
 change
Message-ID: <aVUs-mFYCO2qGmqT@localhost.localdomain>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-10-frederic@kernel.org>
 <0f65c4fe-8b10-403d-b5b6-ed33fc4eb69c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f65c4fe-8b10-403d-b5b6-ed33fc4eb69c@kernel.dk>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FCCF8000B
X-Rspamd-Server: rspam10
X-Stat-Signature: h5z5k6sfxybici1k7f8zpjfezk5pagtm
X-HE-Tag: 1767189758-105186
X-HE-Meta: U2FsdGVkX1+y9GHW/LJT31UPmSXM4mx29jxnnVuN/5UoPxNXELWLGdW/9Dcj1Gy02f0mPF+EYPFZUDwQoo+ASSFZrz5Qrud0SFfMhRp1pArOLsSo0TDIabuODARNThVzVnCn1kNGbiiGmp4M0AA8g6Ph830eoyUA3oGRun6K62EJTmaTZhY2bqZdrxwr/chIQ5ag/ORjmt3dtzhGCJAhFWmFav/ZOUFT5LF+24M7eLL3HQYSZywJyA0+GhpCiMmbJv1b1SCyOI2s1oFyj0e4Y5qd4bP5xN0Z0Ftwc9xX//qYcLdZKIsG4mDtGdMPb0WXmPeB2YORC5SvdeynOnIj1yag/CPmUzsJeVXRRknk3plkPhfzrGUkNWlabwMu+5emt9P7/Qm1q6U5cOv+3loqD7j7IRP2b2jfCdKncd+CFgrGVl4jgii5e0jFJlTbALK8NKBwdDU3gas6AyzXMe8sjsRhn4uFomYVVFIOMlFTAW98XtxgPm5XDVZUHaT+xWBRkMD5l6nCcby4L0grIFN95zRZGqdSJG92lpNjN8twvLg1XvkjGXCVRBrGHiWBG4S4v1XM4fDlfEFmP9BLSaVDveBEET/Exsp24DKokz9clcBD9QrMDnAvUzDb2kof0T88zvGqEGtp2woyy6poOkNLPiIHtQEJwqwEtoi4ffq3PmnOh3vqef15GcwxHHrzJFMS+VoPAanKPLV+Dl0ogKJ2Km3TMyAMa91aoa+QzAAo8ba8rK7STAdrSiyJMGz0OZiNdBf164YAz4cu2iCGpNxGtgchf5JEfL48mGZ644L9er7GUM3vYuspgZ48vNHenlruoWl2GlcSIZYCLlkRsQz3K/79l9IYBAvWBH3qQDZ6FEA2UOu6sz7KfJXB9P6GgT1GPSIXTFHjzm1Xbj3c5PrtpdYJKwXXmWU6YSXLha6DNZGiugepcw6p2d/NrZzEQBLu2HKYMvirf8CwCrBLvZR
 qIXfx3Cu
 FIH93CmN9mOpGf5cz0/BvLkMrC6nKHqQmJV9sU5AknFhl2u4rxyXMWtxU58J0V1iyIrM6wIBRFjEcEHcS8y2YWi/X/vCioDw9BQfGimHVhS3FBNjWwPCpJz7kEaj1q0C0grBuSF2/+X4wuXc/+lUjeJC/HUGDr+AFsMI2c16u1ofYSg+Q5LFFJMpZSTap2dLEIqOuM9q2DakDSss6bYsBTV87eKIcfMM/O2M/PjWoGOO5RUkGo8zOfVEDdqHeMWSuUYg9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Dec 29, 2025 at 05:37:29PM -0700, Jens Axboe a écrit :
> On 12/24/25 6:44 AM, Frederic Weisbecker wrote:
> > The block subsystem prevents running the workqueue to isolated CPUs,
> > including those defined by cpuset isolated partitions. Since
> > HK_TYPE_DOMAIN will soon contain both and be subject to runtime
> > modifications, synchronize against housekeeping using the relevant lock.
> > 
> > For full support of cpuset changes, the block subsystem may need to
> > propagate changes to isolated cpumask through the workqueue in the
> > future.
> > 
> > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > ---
> >  block/blk-mq.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 1978eef95dca..0037af1216f3 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -4257,12 +4257,16 @@ static void blk_mq_map_swqueue(struct request_queue *q)
> >  
> >  		/*
> >  		 * Rule out isolated CPUs from hctx->cpumask to avoid
> > -		 * running block kworker on isolated CPUs
> > +		 * running block kworker on isolated CPUs.
> > +		 * FIXME: cpuset should propagate further changes to isolated CPUs
> > +		 * here.
> >  		 */
> > +		rcu_read_lock();
> >  		for_each_cpu(cpu, hctx->cpumask) {
> >  			if (cpu_is_isolated(cpu))
> >  				cpumask_clear_cpu(cpu, hctx->cpumask);
> >  		}
> > +		rcu_read_unlock();
> 
> Want me to just take this one separately and get it out of your hair?
> Doesn't seem to have any dependencies.

The patch could be applied alone but the rest of the patchset needs it,
otherwise it may dereference freed memory. So I fear it needs to stay
within the lot.

I appreciate the offer though. But an ack would help, even if I must admit
this single patch (which doesn't change current behaviour) leaves a
bitter taste because complete handling of cpuset isolated partition change
will require more work.

Speaking of, is there a way that I missed to define/overwrite the above
hctx->cpumask on runtime?

Thanks.
-- 
Frederic Weisbecker
SUSE Labs

