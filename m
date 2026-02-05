Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B8BEA7950
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 02:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB586B0005; Wed,  4 Feb 2026 21:21:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1591D6B0088; Wed,  4 Feb 2026 21:21:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065416B0089; Wed,  4 Feb 2026 21:21:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E87556B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:21:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7DD1E1C24F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:21:06 +0000 (UTC)
X-FDA: 84408800532.02.68FF7E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EF7CC1A000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:21:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/e42ZGN";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770258064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+86YAsyA6bU1wm76V9m/Ln82AVueA/iQz6cYgVERVY=;
	b=OojVAuFDg4nTe5/VDY0yslDRWx6p05J0jOKhgVKuEOITbquHjIaa2qe44Vam51hsEY2UPB
	C9rhywzodsPj77vE8veWnH3/xpexRyiXhdmgofJ58w6XbIhDpu54Mk/yeDmSvwqr7H1Zgr
	ObhV5ElZuwOLc/rs7U0lb4mjMkOBIpA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770258065; a=rsa-sha256;
	cv=none;
	b=egxQi2AyHnHuIWYpXRxnMHUG30cWaIVL3dTthtSswXEVT3MhgGgUKa9aURQrDuGth0yKYn
	j977vqKn275Wr96pDdIrIa/Ql/VOvez4yagdwC/lMfElVZAn+FZtl848mab+hTFDwFOedY
	ub3ecigU1RT9uR/vvM/TYZaoJNrNYxo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="p/e42ZGN";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B8CE60010;
	Thu,  5 Feb 2026 02:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B999C4CEF7;
	Thu,  5 Feb 2026 02:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770258063;
	bh=1p0q+XL1NkDEIGz0jM/jqZKOiumpLaYIkMgzoq+3IDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/e42ZGNlSTUkphkNgB026mUr99Q0qJU57Zb+bRhlmIJjYTMAXkQbjQl9DvfNhxJq
	 XP3L9tVmkDVFlt3/wKPPKhYePp+x+MokrVqmzZzC+AQzM6dMUeHjoHuTYv8AS0DRap
	 HpnpMw2HAonYxYNN2nDpDX6JihICKlUmT226oKgRMct5vUZ+0MGpJUkeeHwG7b3aj+
	 L9VImKdCjBqwTogikjGsJpJ4DGU1xLtp+yBNwB0aEQlGYrbQbl1gv7LLELWTTXjguT
	 XPEU4evKDFLVbxMQIyonNP5VwBnIWxKLQfmjdFZ3xUCcCIKccsVGQHtkhYiDlQLIEl
	 q9bBaXizD/NoA==
From: SeongJae Park <sj@kernel.org>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Yushan Wang <wangyushan12@huawei.com>,
	alexandre.belloni@bootlin.com,
	arnd@arndb.de,
	fustini@kernel.org,
	krzk@kernel.org,
	linus.walleij@linaro.org,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	fanghao11@huawei.com,
	linuxarm@huawei.com,
	liuyonglong@huawei.com,
	prime.zeng@hisilicon.com,
	wangzhou1@hisilicon.com,
	xuwei5@hisilicon.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] soc cache: L3 cache driver for HiSilicon SoC
Date: Wed,  4 Feb 2026 18:20:58 -0800
Message-ID: <20260205022100.68997-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260204134447.00000afd@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF7CC1A000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ryc1pqau9uk1audokide7kqbsqutn6c3
X-HE-Tag: 1770258064-498088
X-HE-Meta: U2FsdGVkX19s+q3cYKD1AvpzzoZLcm+xqsDX396XLswFsDEHs2PhhYnfz9h0SzNSmXb84tzhqFvP26fNaPNf1ZpVheY6FFfMu7GHsGWb6L5eyWzinSq1h0b6+pMFP9CXgFjfxiuQ/neUjnLrZP8rJMHvD2hqsyXI4yI8e1nVhWTJIJ2vCP7SAZhd8/st/iNQxDNr3I7Md3arpSRAz9mdRLx+IjQU+6Z27oDVfZNi/YegnqPP7R7cOO12dvtuIOnDeLrNT2kIPNqthpA+7DknwBvcYVO9r+V5LLqPAVxQfwYVwY4v61ejmr+FS+iSD66UIi++1noi6b5QN9bfjVlgDnhPkoKRl5zOJDeu6rASVAmXVx999ZuxwAyaTSfAFHxhPMHztWrGUV66lC9SRAEbKZgXjMtcfWCtqBCYjCuz6ak+czajuWBIG1T200npJnipQrdtP+oEOIA3uuoUVDALhD7X9Ay6BF1uqaHCt1t45kBk4GRIWuQ0Krqwj+gU1QDn3zcx1lIBz7c1DoyZl4ULQ/I4IC2sNd7Aq9ict/2QX8fy/nx9pD8p6Ydb1VDthQ9rG/bC+ACFrRumWButYDw/gvfIjJJXWpjB9XCTql6WSWiuueotLKIQ0iHBX6ga/t5dvsxpK/lTuOTU2n5AaUo9ATb23bWuh7N1tJ2Ok7MbU3z0HBowag4EO8bgYbXyX6/b+0QLnnI0ZRVfkwThjM3inV8vIcq5iHp5ex67hkcjwGPBodEiMDyoAC/krND8FC3NKZJo71R9WpEsWfVASV+x8W1c2pMo/beIP/tHznDhIY3UHn42DKqUElTzA0bWKMe9ptWT9DKTbT9qbO/N0G9wPYUfhxkTuDYiVpu6ojDxnNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026 13:44:47 +0000 Jonathan Cameron <jonathan.cameron@huawei.com> wrote:

> 
> Fixed linux-mm address that got added a few emails back.
> 
> On Wed, 4 Feb 2026 13:40:20 +0000
> Jonathan Cameron <jonathan.cameron@huawei.com> wrote:
> 
> > On Wed, 4 Feb 2026 01:10:01 +0100
> > Linus Walleij <linusw@kernel.org> wrote:
> > 
> > > Hi Yushan,
> > > 
> > > thanks for your patch!
> > > 
> > > On Tue, Feb 3, 2026 at 5:18 PM Yushan Wang <wangyushan12@huawei.com> wrote:  
> > > >
> > > > The driver will create a file of `/dev/hisi_l3c` on init, mmap
> > > > operations to it will allocate a memory region that is guaranteed to be
> > > > placed in L3 cache.
> > > >
> > > > The driver also provides unmap() to deallocated the locked memory.
> > > >
> > > > The driver also provides an ioctl interface for user to get cache lock
> > > > information, such as lock restrictions and locked sizes.
> > > >
> > > > Signed-off-by: Yushan Wang <wangyushan12@huawei.com>    
> > > 
> > > The commit message does not say *why* you are doing this?
> > >   
> > > > +config HISI_SOC_L3C
> > > > +       bool "HiSilicon L3 Cache device driver"
> > > > +       depends on ACPI
> > > > +       depends on ARM64 || COMPILE_TEST
> > > > +       help
> > > > +         This driver provides the functions to lock L3 cache entries from
> > > > +         being evicted for better performance.    
> > > 
> > > Here is the reason though.
> > > 
> > > Things like this need to be CC to linux-mm@vger.kernel.org.
> > > 
> > > I don't see why userspace would be so well informed as to make decisions
> > > about what should be locked in the L3 cache and not?
> > > 
> > > I see the memory hierarchy as any other hardware: a resource that is
> > > allocated and arbitrated by the kernel.
> > > 
> > > The MM subsytem knows which memory is most cache hot.
> > > Especially when you use DAMON DAMOS, which has the sole
> > > purpose of executing actions like that. Here is a good YouTube.
> > > https://www.youtube.com/watch?v=xKJO4kLTHOI  

Thank you for Cc-ing me, Linus.

> > Hi Linus,
> > 
> > This typically isn't about cache hot.  It it were, the data would
> > be in the cache without this. It's about ensuring something that would
> > otherwise unlikely to be there is in the cache.
> > 
> > Normally that's a latency critical region.  In general the kernel
> > has no chance of figuring out what those are ahead of time, only
> > userspace can know (based on profiling etc) that is per workload.
> > The first hit matters in these use cases and it's not something
> > the prefetchers can help with.
> > 
> > The only thing we could do if this was in kernel would be to
> > have userspace pass some hints and then let the kernel actually
> > kick off the process. That just boils down to using a different
> > interface to do what this driver is doing (and that's the conversaion
> > this series is trying to get going)  It's a finite resource
> > and you absolutely need userspace to be able to tell if it
> > got what it asked for or not.

And thank you for clarifying, Jonathan.

> > 
> > Damon might be useful for that preanalysis though but it can't do
> > anything for the infrequent extremely latency sensitive accesses.

I also find no good idea to let DAMON help in this scenario.

If I have to make a brain storming idea off the top of my humble head, though.
Maybe we can ask DAMON to monitor address ranges that assumed to have the
latency sensitive data.  And further ask DAMOS to find sub regions of the area
that getting colder than desired, and make an access to cache lines of the sub
regions so that they can be in the cache for "most cases".

It is just a brain storming idea off the top of my head and probably not work
for your case, since...  It ain't work if there is no good way to know or
guarantee the address ranges for the latency sensitive data.  It ain't work for
extremely latency sensitive case, as DAMON is just a best effort.  It ain't
work with DAMON of today because DAMOS doesn't support such kind of
cache-granularity access generation action.  So, it sounds like not a good
idea.

Nonetheless, if you get any question for DAMON in future, please feel free to
reach out :)


Thanks,
SJ

[...]

