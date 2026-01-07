Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C7BD0D17C
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 23:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374F36B0092; Wed,  7 Jan 2026 18:40:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3221D6B0093; Wed,  7 Jan 2026 18:40:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E856B0095; Wed,  7 Jan 2026 18:40:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEC76B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 18:40:01 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B27BC1603B2
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:40:00 +0000 (UTC)
X-FDA: 84306788160.30.0B54C0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F421180008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 23:39:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QWc2qayR;
	spf=pass (imf16.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767829199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=OfTUMyeeUEOAjKZC4R5wKa9dyNi8tHQWmoqO7Afja6s=;
	b=2nsiWyDYuDKYeS6USJ14afm5NhT0eALiqMAlPxVYcg58LGklCiSxbCWdoYkkCt3qaucpYV
	o6HyceEWk19s/iZZsyIaB3ccc9oAZ4aigM6mGzd9q2r93LRGlWSTd1oUSmaL9ThcIBOuOi
	X2mAtkPrsxPoWJ5lj8fnrWB2DPjbyO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767829199; a=rsa-sha256;
	cv=none;
	b=lfrf644A3+V654WhXM8UUr9Ss5xOpv92Rw2vb4RyGgbnNIiF5oNkzePZ1dF6249qiA2ZVZ
	/T9bvPbHJEb+7Ip37wki13HxlPjAQhFNdz9CrjAhw20dHeIeCHROOOq5teQw+KKF61Qd81
	YpVmpn8GIJLEj4rPgNjVdb8lt7+qK1w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QWc2qayR;
	spf=pass (imf16.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 136A06000A;
	Wed,  7 Jan 2026 23:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B94C19421;
	Wed,  7 Jan 2026 23:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767829197;
	bh=TkPExvuLRdk+twI/ygMh7+/Ril+KIPyMUG6oDC8D2N0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=QWc2qayRWh0hWdOy89mtUEyGFJiHeys6+PiJCJTh8FCimQmcF4f3KQLBEmA88hw10
	 /bZvZR94ATDjonBzReJDFiH2CWArObd+a8i78tc4q18E6ySfp6xu9HbUNc002v+3Yq
	 RGKRTbINxcjSZwP2MCkG/EPm88+Wt+jCjRwufGQCj4FqHeIPPOqf1yag/eYPs1lfGY
	 0bomX+d4DHXHvJjAMgVdrHQ5b5Gkap3ilsfChy/O55qxjVWHBeLNB4E2bl8dBsU0At
	 VIu+/mFZCjqTLTppjOwLawF4UDXaj7ciEXXMrX3JN+4r082FGEWMC4M7mH52MCEL+J
	 Klea0ah1V/qsA==
Date: Wed, 7 Jan 2026 17:39:56 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
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
Message-ID: <20260107233956.GA453841@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aV7sheFKQWb23lsc@pavilion.home>
X-Stat-Signature: d9tbew4f76tbxi1tniqxn3csf4dfmhdo
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F421180008
X-Rspam-User: 
X-HE-Tag: 1767829198-444774
X-HE-Meta: U2FsdGVkX18UHMHMIbDOSfYYH6TTCyOI9o6cz3JQSg/GWEMN4oqHNkwgrZlHFium99ilpkKYMWQjbfHqKR/4tstpy/Zu2qxv7ZCHzbMjSgBg5ZhRCRcuDrdjy81gQD9849DeLyl3f9BGJmCMRzOVT5wXBeJDOPWukABYB0cjIycTYcC8LX9XalgOIWkZO2K0LiZBEqrOYw8D2FyFkFFlGt17xCM2rhrdStjlLJTIKlk3gcWt98NAhOObAs2U297wJ61+WIO9CQCi7ihuHAezmAgwiCVUd4/O2bNzZSgbHclmfhe2M3xGf4UXH9LjyhEGLQ4TuODRH0mLRm9L0ct7aC2mSpgp+tzQp+A7T7eMlZGql499zA0krBEYCDGY5welS+hw6oqL6gLfgb3/1IHdaovLRO4NTzaW5UD4SsJEKNuykFFoTA2Gr3TPQyOxSESHJwL5jRf83IYIlita2FQHlqgIEv4feI7WB8MEre9CUuaGq8QAgAq+/Etp9DcGTkbQ+bV6ZBwdpeqk6lt0hfaWG9SQQzTHwPFQJeTnyXCwwyQ/jcXmgMAP4WIkF1X2mN6qVvSItrci4CPA9MRLHyhfxXXgR6Mpg6s9oYDzKj7xKCRBlOtsXBi0qbePQhInNp+TaRD1i8PdQwf9oFHKYj0eWe+d5y5+lus6Q2MCe6x76UA+EA1aq401j4rUkC2X9c/xDo+ycN2A3QARHD3CnbVENqi4ekgrLzYGfmRipIPIlQsoAAxVzkegbzdbe0K3x3wwZjLliyxcNn4UBIaRD/F06QIB0uW/VJz/iWMCFU5GFR4wjJ+kk4VaU360n3etaor+8bXfvFZ3mwH9Z2IpmAMsZ9o0u9QJb4XJcV9ZCaXEkDOsWZnlvRtjwEACocNcYoJsD0hTqPbJq0F74nxiTfY5g2QaskRfcsxErnk0XTfhK5Kq9WYAloDVS7101qDgVHgpams8yddiNzAZVsKsIvd
 k90jDynE
 eChPXhvPlKcRwcJ8vxudVopmLhwuySsXmEDNu19NpLPSYn5RPfNmB3PQur7o+HU7kB5CVC/NSXcycH9+JmLpCF+kyNN7ZYEJg8l7ftfFMxqMlzOBeNYoOkwD35ECKyZCEftQOsevtO6SWp6J32KP27TBay0nciXGVY9Ufn6OCv210xrI853qhsEcTvojy0Fp0/nE7ByYlGIEtVvCmOrJivtjdH/+1iuG9ioGg/fvZCAIiCpHHGKD8CowXf5uhVxvk9rt57iaBaneTweAVYM8NwII+5siOj2CK0ZeMGrp1OMLgYI9EAeUOfNajyZM7xz9a5e7ZO3Gd+rVWjDY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 12:30:13AM +0100, Frederic Weisbecker wrote:
> Le Wed, Jan 07, 2026 at 01:05:34PM -0600, Bjorn Helgaas a écrit :
> > On Thu, Jan 01, 2026 at 11:13:26PM +0100, Frederic Weisbecker wrote:
> > > HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
> > > therefore be made modifiable at runtime. Synchronize against the cpumask
> > > update using RCU.
> > > 
> > > The RCU locked section includes both the housekeeping CPU target
> > > election for the PCI probe work and the work enqueue.
> > > 
> > > This way the housekeeping update side will simply need to flush the
> > > pending related works after updating the housekeeping mask in order to
> > > make sure that no PCI work ever executes on an isolated CPU. This part
> > > will be handled in a subsequent patch.
> > > 
> > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > 
> > Just FYI, Jinhui posted a series that touches this same code and might
> > need some coordination:
> > 
> >   https://lore.kernel.org/r/20260107175548.1792-1-guojinhui.liam@bytedance.com
> > 
> > IIUC, Jinhui's series adds some more NUMA smarts in the driver core
> > sync probing path and removes corresponding NUMA code from the PCI
> > core probe path.
> 
> I see. I can't drop my change, otherwise my series alone could crash
> dereferencing garbage. But Jinhui's series removes the need for my
> changes.
> 
> So an unpleasant conflict will happen in -next (and if everything
> goes well, further in next merge window) and it should be resolved
> with simply ignoring my changes and only apply those of Jinhui.

I don't want to derail your series, and I don't think you need to
change anything right now.  Jinhui's series is early and might not be
ready to merge until after yours, which should be fine.

Bjorn

