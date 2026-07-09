Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90226C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705F16B008C; Thu,  9 Jul 2026 06:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DCDE6B0092; Thu,  9 Jul 2026 06:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6E66B0099; Thu,  9 Jul 2026 06:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34C966B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:26:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A08098E11B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:26:17 +0000 (UTC)
X-FDA: 84968858394.27.6021D94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 161CD180004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:26:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DTci9JOW;
	spf=pass (imf06.hostedemail.com: domain of sudeep.holla@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sudeep.holla@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783592776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPdVHdBqE78Tyd4PBWnjxJl0mWtpdEwQn28B3/SGb/w=;
	b=dBgIJPk+fSjjqbLv9Zezsk/KurPxaBmFLWdpGD2XlibVbjWQGoFa3/ydgzipd9Ce7tyeHw
	zgx6IPz4xBBHlYnhTK0vNn/Zt7bSxZ4dSAIXJwU3YuKJzstyG4K6aFr4wPrNx1Rofm4hYm
	BNJUYeMJC+X+NSbwqCbpu2C/8+ivfjE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DTci9JOW;
	spf=pass (imf06.hostedemail.com: domain of sudeep.holla@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sudeep.holla@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783592776;
	b=o9vT0KTpqANKK8ZnFcGNG7WWDAjRkktg4dPR1tBDBLcpDT+6v/9q6T/xl28G6i6e2qaLz2
	tFU2HZAFbDF1e+kKEqSqbg8ntlvPj9xkPnW6Fy01aoJmsPhTtg8BsWybV/bledoxcar1t1
	9vDWnsUFq7O5zIasVti8xtUiPW+y54g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 748246001A;
	Thu,  9 Jul 2026 10:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85ADD1F00A3A;
	Thu,  9 Jul 2026 10:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783592775;
	bh=TPdVHdBqE78Tyd4PBWnjxJl0mWtpdEwQn28B3/SGb/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DTci9JOWIGHKfBoQb3CBfSV1SkaFony1B9cQxR/582XmSaBE0WcAVXehCunpqUihN
	 FcSL9fchO9EriU8hNo2GAlseP1MoOnrrdV/AyxTRDEq1Ol5ptedub8IwkszrzuqoEY
	 swWIWr9i1t5L/RQDig18MQO15ZxE+C2JBWaEWTU4bG25OzyCJ51zbowDDHd3UFF5XE
	 f3PMBjDE+iF6kT+TtVb99M0QRkFKJaZDrOEDpLo7xKZuZMAIMY60GLDzL1TodfoyH4
	 Wv9HTOujAGR4LZKtOqXySgP/XHA8H65aLq/KqyUT0ASQ0/EqW7VhIL1rPzLeQcwxQS
	 uTq86OLThc6Rg==
Date: Thu, 9 Jul 2026 11:26:08 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Shyam Saini <shyamsaini@linux.microsoft.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, ardb@kernel.org, david@kernel.org,
	will@kernel.org, linux-arm-kernel@lists.infradead.org,
	akpm@linux-foundation.org, bboscaccy@linux.microsoft.com,
	bp@alien8.de, dapeng1.mi@linux.intel.com, ebiggers@kernel.org,
	elver@google.com, enelsonmoore@gmail.com,
	feng.tang@linux.alibaba.com, gpiccoli@igalia.com, kees@kernel.org,
	kuba@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lirongqing@baidu.com, peterz@infradead.org, rdunlap@infradead.org,
	tgopinath@linux.microsoft.com, tony.luck@intel.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Message-ID: <20260709-educational-nimble-seagull-5fc031@sudeepholla>
References: <20260630170911.43521-1-shyamsaini@linux.microsoft.com>
 <ak4fu1qINGyAQUEl@arm.com>
 <ak7tTVs6tWZPOln0@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak7tTVs6tWZPOln0@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 161CD180004
X-Stat-Signature: 4if1b76nqj68q9o7zafkhdjqwdw39oas
X-HE-Tag: 1783592775-983315
X-HE-Meta: U2FsdGVkX1+kTg8qGrFjp/fbfvJFlAnsM43Lt9x7c/gEB3KWfpmfluJRKb6XvzWEsdjsSEnDCudEx0XImmAH5X2B5DsQr+ZYvFRq1Ec7m7CFvdM1HyuAgtqojVOM6Ni+XFE7/0CFlKJhWDTxmRURve3KCfOI4XAh9GTFYxIuLeCWIiFXvDd8AjNwluQchYDI+MIzZMyC/LALTupgVn41L1mvzDlP5rIdSvC3x8GyWcBj+S0hjTPXzkdsH5RuKGivaJbSozhrym5kyWJ04GgcwFdzeqSBRNZsF/OMYOWBT8RPqYP3FQfNa3MAmYYPO/iY/knUU5EZOYT+3s6TZOu0Pt9ux0peRYZ1zLPLzsEx3inIXoowMSu5Rrs7tyqCXqyFJnqwkfbOCR4G5nQEiJbrzYJR3cVg/AsN/zh9g9VMKKw30DtJ0RR92TzfEOz+AgBicP9Ciystid/2HShqifTE9yIHrHpu5KKEhQ2MtOVWyn0/daBnIF3v0T6BxJucwwf9dxO6RdxNLhZhel5O4YUU8jX0x7bVMzmWSD0pwLsveBMQHv25CQ8beqT2UlGoUlky/0hy0hzRDIn6121SBxmgXZ5puUQix1C4+XfiSBgi6lqIQXUJBdm5VwDx6RYSjON+QsEN4Lw+YvySsudg5/aeCeaplDV+3nA4Bh9+KBB2aOiisz7uM6BW5Q2jC025h1AXHs/QPWppNub2+h0pYbiBt8vs2kATvppBwhq0h5puHZ7/KYn3u65DbUhcayWnpfA3MrpZEFWgCs7vr+wX97SNP2/qYfrP7bnOKAk4tnxog/UI4JPvybIGrVosMorz/eU6OcLwDWRxHLUP+SVhVNWpy9Cg+vKcFnkNTS8jKa0tfQkReiKhKkizkCsLHxJo7xoQXQHsgqGKCOnU0lKoXzOLFyb/Jg4ruxnXEbv3ZMsnHbGcVC6buSWDSEn3PkkTLs0JcirYlqkPcAbUsD8GpK8
 Gvz40wXx
 CSparxH2qE2JoCQ9e2i8eFUo9zeJ8QKvZD2ssZTCRdrNbDCTs27onBMjfncfvwXfVChWF6CCEdykXMeigIwN/8hTdSVXzYYx8A2dceR7/7fOb8oTrxV3g0lpQepi2XdVoffUHxGNfEKPLF/vxGv0hzxjNAm2ZIDbOn863iilKY5DPqVLNP/7PKvx1Lu26jlSe90IZPIFs4q4tjJySXAFdP9dFzKNBE5MExqj1MtlfHdHHYmMdgWBFcQU2+UGO7QxetrCFOrn8DK62IzIuUKASD4YScUtXKtRA0NE4x4DGIcSjtGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 05:37:33PM -0700, Shyam Saini wrote:
> Hi Catalin,
> 
> On 08 Jul 2026 11:00, Catalin Marinas wrote:
> > Hi Shyam,
> > 
> > Adding Lorenzo, Hanjun, Sudeep.
> > 
> > On Tue, Jun 30, 2026 at 10:09:11AM -0700, Shyam Saini wrote:
> > > Following up on this, As Mike pointed that reserve_mem is best effort
> > > reservation mechanism, so what is the recommended reliable Linux
> > > mechanism, if any, to reserve a predetermined memory range during
> > > early boot on ARM64/ACPI platforms for warm boot scenarios? KHO is
> > > one option, but I'm specifically looking for a solution that preserves
> > > the region across warm reboots.
> > 
> > If you need ramoops-like support, I think ACPI ERST is a better fit and
> > we don't need any memory reservation tricks. I'll let the arm ACPI
> > maintainers comment further.
> > 
> 
> while this patch mentions use case of ramoops, there are other uses cases that
> requires predetermined memory reservation at boot time, one of them is PMEM.
> Like Mike pointed out in this [1] thread, we don't seem to have an
> equivalent mechanism for reserving predetermined memory on ARM/ACPI
> platforms, as is available on ARM/DTS based platforms.
> 

Indeed, it was been discussed in several forums in the past but AFAIK there
is no conclusion or a direction towards solving this yet.

-- 
Regards,
Sudeep

