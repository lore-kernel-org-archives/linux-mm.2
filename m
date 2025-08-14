Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F529CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0E6E9001AB; Thu, 14 Aug 2025 13:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF9E900172; Thu, 14 Aug 2025 13:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D179001AB; Thu, 14 Aug 2025 13:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFAD0900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:00:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FDDF1406FE
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:00:18 +0000 (UTC)
X-FDA: 83775976116.20.580237F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id D40681C001F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:00:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of cmarinas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755190817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fMrdQaBmngKojIjdQp4PaCQb8kAU9R3rtEUG0HQfneA=;
	b=nyco4A0/M/qRiGCEWqAqhOaQA4anaGmBwZDzzNn0FvMFKf1YLOxePVJKCRoT2A9xSMFAIO
	bvNkh5Q4kXGi+5Dy5Vch2t2UFVty+i3hkf+f5oyI2S+p/rU/G2GYzkQJqGIX9c26op8psE
	DMowu8KBq3NacmiNyglRgfF40qBPMQM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755190817; a=rsa-sha256;
	cv=none;
	b=nCr8tNJTqK4lcTBtTumolVHRXKf+VWKK2ewefICyywnFh4Q6Pj8F3zHaZ/80qf75jxp5Sr
	1lAOSkSDNCUJPdpArDFe9uexPpzbHbsK2MPeHCEFpH5gvxAc406RSL5J4DzKWojZiQNsI4
	ZQr6GU+xW8YJwgtmHb2mbFIIgclUPDU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of cmarinas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 9A89E5C7170;
	Thu, 14 Aug 2025 17:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8539AC4CEED;
	Thu, 14 Aug 2025 17:00:13 +0000 (UTC)
Date: Thu, 14 Aug 2025 18:00:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gu Bowen <gubowen5@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, Waiman Long <llong@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <aJ4WG0wZks-cdCm8@arm.com>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
 <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
 <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com>
 <aJ3f05Dqzx0OouJa@arm.com>
 <2025081450-tibia-angelfish-3aa2@gregkh>
 <aJ303-YBCCLFeIoy@arm.com>
 <2025081435-esophagus-crumpet-2622@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025081435-esophagus-crumpet-2622@gregkh>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D40681C001F
X-Stat-Signature: uqwob4x4aoah3iqcnor9uf6ueayi9g7s
X-Rspam-User: 
X-HE-Tag: 1755190816-882761
X-HE-Meta: U2FsdGVkX18iRWmjkYvvEcuCCCSg/fvnBi+2Ht2JqDW7KYYh0WE6VoKCZkCcS1bxzlUQ2Uuieim5i2KY8RpyExiJqAuk/7hXO3x0eZhY2BlTC/8+z0Gvcem5vEyQEjla+vMcF/ny9XUS2cBLtByuV3+5AC5iUrffTMsUr9MTTmehbkFLtF8+vgpa8TIZ37gps15dFHs3yoWg+bzdIqrbrDMNTylFa7ItvZvUZW/WePBYKCZD05W/ltj/CN6qWU+fl426X5My5UaH4JkOFh+Qg1lhZHInKhMw8AzrwFbpQfY6iqB1p01q/q75OhZmqCWDlvNwYotEdYFJfkAXfc6y9BgRsG0K2Aat82ppcdkAGaz75nIYkPvN++1dheXWSZtZcr4+e8nbkrH45jZgzSWVkh/XaSMFZWjFBZb3YonBh0hbGVpJjk53HYpk/8p4Gwyv6yUQlqpW/ectj29fQbI6hD3082pwI5oT/HhiquAnTACB0aVOUuvIXTw7NH+73uypif7CA+D7NZHtZc4l5GjtVr+YYY+iav2/lS5XpwQOkurgtjwyKzdW4SY+f3le+HCd9WqpVzjOZqCNQpiG10hTBaIwR+f0WalzRi6au4UYKLiHh5ReJyC9TnWGeBuX74RX47unxbW6RJGNwcyVJ8Ipv2B4sQErltYQDp1o0uy4/wWFg2UMpoPI2bI4KhirUSP3xSYAbtkBtbZ2N3wuRC/fNpTQp6fPtked9jL4l+8tMDfNsj2lW9tBZJelwKMjDyDBJgPpGcB46Mliy/a4z7RQ8PhC3z8PGOysSKRp5rOUqFqztXZR7T/xjEdmJ6vBhN2XoQJjGhpoKtqr339oxpjCZpwnwt1rc5M9k2IWvzMMzkyEdRVHKdD3DiLhCUCCx+v80xzmYkF4+L1SmzY9iRFEBeXS+eRt/GhCUZE5GTxaTFifE2PVTh1qk86cLiS7mmLjIm6Bs5B13UTXNQrRo8+
 BiI2OZHK
 414zTd8sFad8aUJXfoKRUBgHvCiMAegCiXyu0Qj8WpEu4vb95EFU/oWAwxCd2cdJ+qlRC+fYr6w1Gm4DjOtYJ4E4Tz58Kb+Q3RpH1ut7Yz8OHcWhnSD7G1D6iQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 04:54:33PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Aug 14, 2025 at 03:38:23PM +0100, Catalin Marinas wrote:
> > On Thu, Aug 14, 2025 at 03:56:58PM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Aug 14, 2025 at 02:08:35PM +0100, Catalin Marinas wrote:
> > > > On Thu, Aug 14, 2025 at 10:33:56AM +0800, Gu Bowen wrote:
> > > > > On 8/14/2025 6:56 AM, Andrew Morton wrote:
> > > > > > I'm not sure which kernel version this was against, but kmemleak.c has
> > > > > > changed quite a lot.
> > > > > > 
> > > > > > Could we please see a patch against a latest kernel version?  Linus
> > > > > > mainline will suit.
> > > > > > 
> > > > > > Thanks.
> > > > > 
> > > > > I discovered this issue in kernel version 5.10. Afterwards, I reviewed the
> > > > > code of the mainline version and found that this deadlock path no longer
> > > > > exists due to the refactoring of console_lock in v6.2-rc1. For details on
> > > > > the refactoring, you can refer to this link :
> > > > > https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/.
> > > > > Therefore, theoretically, this issue existed before the refactoring of
> > > > > console_lock.
> > > > 
> > > > Oh, so you can no longer hit this issue with mainline. This wasn't
> > > > mentioned (or I missed it) in the commit log.
> > > > 
> > > > So this would be a stable-only fix that does not have a correspondent
> > > > upstream. Adding Greg for his opinion.
> > > 
> > > Why not take the upstream changes instead?
> > 
> > Gu reckons there are 40 patches -
> > https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/
> 
> 40 really isn't that much overall, we've taken way more for much smaller
> issues :)

TBH, I'm not sure it's worth it. That's a potential deadlock on a rare
error condition (a kmemleak bug or something wrong with the sites
calling the kmemleak API).

> > I haven't checked what ended in mainline and whether we could do with
> > fewer backports.
> 
> I'll leave that all up to the people who are still wanting these older
> kernels.

Good point. Thanks for the advice ;).

-- 
Catalin

