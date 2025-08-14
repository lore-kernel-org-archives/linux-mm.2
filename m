Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D76DCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 14:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B01900183; Thu, 14 Aug 2025 10:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32DF0900172; Thu, 14 Aug 2025 10:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C56900183; Thu, 14 Aug 2025 10:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1B0900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:54:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C7735A230
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:54:44 +0000 (UTC)
X-FDA: 83775659688.25.03C80F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E3625180002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:54:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="v4E/sjJI";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755183282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuTnT9sI5m67UUg/65bNdefloEPJtyvZW0BRXNDbJC4=;
	b=F8eC8g8CWpMN6xlgvzFw6F4t7SNXaIndrvbLsZwTnHc7yWtDnffWBMn9K9ngY7EEZDT+xH
	yjSb1aJA3S06qI9NQgkFGOJ7wkX5qgspy1hY07+0BtdEGvj3IvJpmD6wG50LIMhN4CI6pO
	9YFJGtFoDKFgVVwVkCwrQlrB2ZmELZ0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="v4E/sjJI";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf24.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755183282; a=rsa-sha256;
	cv=none;
	b=jXkBsp+qW99ZUKsWDbSOKhaO73aQMMdeJtyjzlMe4Tx+VU/zAQ+rq3yPN6WxRjPl3brCrP
	iBIdRBHR1wew43ntJKtmBP9QOcFZuMbiUlWwGd7v35Zw68kiHl0Hs6cQAZr9XoJwO8kpmJ
	QCw+DfCzO7skcWoBYvsJ5Bm9/2ZbGSs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF88E6020A;
	Thu, 14 Aug 2025 14:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32678C4CEF5;
	Thu, 14 Aug 2025 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755183281;
	bh=VXkYGsxYFHCSO35/Shtflutn5Ek/u9q4swyCEQzEGgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v4E/sjJI5GqCrsgNND57dpaOxCFClOYgpwiqgsemLHOjM2JakyvN7vHGozKCRfBi4
	 TAIHjCTUtJ8zHFTcMzP5tjd2YhbOfd3SRFCl9DdsvRwLolVzGUy5iZ3fdBOLR/VVHa
	 ar3oEvzczntO8aVpYlCprgPRtiJoOrPy9f5Oi3kM=
Date: Thu, 14 Aug 2025 16:54:33 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Gu Bowen <gubowen5@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, Waiman Long <llong@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v3] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <2025081435-esophagus-crumpet-2622@gregkh>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
 <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
 <f3e631dc-245a-4efe-98e5-cbe94464daec@huawei.com>
 <aJ3f05Dqzx0OouJa@arm.com>
 <2025081450-tibia-angelfish-3aa2@gregkh>
 <aJ303-YBCCLFeIoy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJ303-YBCCLFeIoy@arm.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E3625180002
X-Stat-Signature: cbciqj8s5ectodh9nheqzaojrbx6aknh
X-Rspam-User: 
X-HE-Tag: 1755183282-885235
X-HE-Meta: U2FsdGVkX19Zp8/q2quyANKc8kbm10yO5ehwcgC+2/niQ/SgHor5NmwR0CFpdxIDzdN8IBmaA4dhLpoCRu8JhBrZosYdJJbWvygmLQKsiBq2VBj8NrU+POG+22qN+uYGNF/4m6sobIEC95xref3GlGJWfKfrMmUMBl5DWbSEb99BbUMIcqX9uUH9gAN1XOWU8wejyAtsyWad0fkh40uioGZxXP1lJD4SC92yuIew4j1pcU2Mzb757nptEaBGlvjV+Tp4vxJGebUWA3GIzZDXhX/ow+KQ5AF5548Jq/efElodq+uJ+aFLsLK5Ul15DV8em3h/2bDTrCJbUquNKT3KfWEbyyZQzpK2NCF1ZwV8V0uZvwgqbkSPyqJ7qX3a8YBRVirDJPIVI5/Ha0VIi6AUqSikDjnOHv3EJr4uqxct4ucsmyxe1T9lPwqzhgvQRZQvaPUmkLnLGgjh5988syMAmBwFGACBm6DgGx4bygVd0hkLxYXEkMCFAy9iTB591CfMY16/Eful5nKZdxEl7P9QHTTgQ5pBmZpdRCOJXuXVkmcr+eGqN9bM0h2r5a5acThnNmAFwpLBcPMHXxbx0fNmX1K0rqHyoS4ImqiNQQy+fs4IYFevQ3v6lUs2EIOJ+lGOsoxWdpA4kUd35gCq1FKmQP6bq1RHAWvWeKx9YVjWme2b00WiMjpE2Eef/BY8dx8h+Pw6mZ01I3ho1vlgJbi/iqCXbMeP7uoKyl/iKFyyayWnfCn6VYjgiM49kBTy1fJXIPS6JcHot+NtMjr21OhyZ60AJ3b+Hccz2BlK0YSbSfxQNTl+S1N1WEKkRY5a3Ynsuc38VkTcRI4QEBhT9X626BUyYHTOrQj22pX0heGqEiRtUFjBA7JAs+KtnxR+tgI8n3xwsriuaAFQkCdqmuRiEh8G+ynSZKzItrMMkPQtiT5sIebSr7tU0UqTlIby3qLgkHaDhMge0HQeL5rmhMG
 x7yDTnAU
 US0jR51gbqgbtJvQafJAVJhV/VHxPw60w5aZ/cViRYQIL7T/49QiSdfHPe+njhLUwfPz2AWzYpdOJHPwrSZ3WzXbBjmyosbNiiGr+AfhSyNlBwlrH0FebbJbzRkLmHNINWGPA/vrxiWgldb9F2TNY2DZxk+92u2j0LtPZmmeJaWr0oVDoMI51/hE35KrTqjsq7S422qCBP2IoVe9rK3MERlHphLSDmqf+9XnciKCnbp8JawZyyu62z4ZKBJT9ZtenlU0jWmKkanbpzM2SptWhzFz7x/ZURD16Hb+QjGgqEshAwS81eis5SpHC/2C4nrgn7X/UYq1afBi+633KsRD62oZI6dLz2ZaUNRpq8f7CKERdX0xUmou9P8EYh8/KM9/PiUcbMWz5HYVFNOk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 03:38:23PM +0100, Catalin Marinas wrote:
> On Thu, Aug 14, 2025 at 03:56:58PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Aug 14, 2025 at 02:08:35PM +0100, Catalin Marinas wrote:
> > > On Thu, Aug 14, 2025 at 10:33:56AM +0800, Gu Bowen wrote:
> > > > On 8/14/2025 6:56 AM, Andrew Morton wrote:
> > > > > I'm not sure which kernel version this was against, but kmemleak.c has
> > > > > changed quite a lot.
> > > > > 
> > > > > Could we please see a patch against a latest kernel version?  Linus
> > > > > mainline will suit.
> > > > > 
> > > > > Thanks.
> > > > 
> > > > I discovered this issue in kernel version 5.10. Afterwards, I reviewed the
> > > > code of the mainline version and found that this deadlock path no longer
> > > > exists due to the refactoring of console_lock in v6.2-rc1. For details on
> > > > the refactoring, you can refer to this link :
> > > > https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/.
> > > > Therefore, theoretically, this issue existed before the refactoring of
> > > > console_lock.
> > > 
> > > Oh, so you can no longer hit this issue with mainline. This wasn't
> > > mentioned (or I missed it) in the commit log.
> > > 
> > > So this would be a stable-only fix that does not have a correspondent
> > > upstream. Adding Greg for his opinion.
> > 
> > Why not take the upstream changes instead?
> 
> Gu reckons there are 40 patches -
> https://lore.kernel.org/all/20221116162152.193147-1-john.ogness@linutronix.de/

40 really isn't that much overall, we've taken way more for much smaller
issues :)

> I haven't checked what ended in mainline and whether we could do with
> fewer backports.

I'll leave that all up to the people who are still wanting these older
kernels.

thanks,

greg k-h

