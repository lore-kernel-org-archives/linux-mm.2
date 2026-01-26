Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51794D1950F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 19:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB2B6B0005; Mon, 26 Jan 2026 14:09:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A888D6B0089; Mon, 26 Jan 2026 14:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995016B008A; Mon, 26 Jan 2026 14:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 848176B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:09:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E2728C653
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:09:40 +0000 (UTC)
X-FDA: 84375054120.06.6000C13
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 87DB74000C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:09:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vlvTX/uu";
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769454578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QKUXWY8s2H68X09JCO3IXuOYYvV4y4UJBW60F3i8Ntw=;
	b=4/7ghmxIMn9ZeYxzUDPkhiwZ5lQYXqlCOjVnEHQMJuzTV+RFLHlZzYTdMFySu6NgDu2HKW
	ba6VmdgG6WzBdbtO8DMOkjXNqmKJDmG/26mwFJ17Fkp0INkHEjBbEDzOdUD2b9L+8hfhFC
	QoK1fZ9zH9i/S4rh1o6pQOykzDJWBxc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769454578; a=rsa-sha256;
	cv=none;
	b=03Rb+6YXLGKWnL2U2PRbWH/VGYXoCL+wd5P3ODYUKycBuCPOqvgKXawy49cEVjDJDDK8bL
	vXkUpU23n9S3HAbCGdXZiMX8EWTzJ9S+UYoHAEO5wISbqsgKHPEy59XUHNTQPaDmA1bBWf
	3sg135n+/B0DKiJf3LGsk3zzUd6IKO4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="vlvTX/uu";
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B46160121;
	Mon, 26 Jan 2026 19:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC125C116C6;
	Mon, 26 Jan 2026 19:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769454577;
	bh=cLFcy6Z9Pdtecg2U9FAo2ddua3xRPw/vDkzI2/8JyD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vlvTX/uunId+50ZKm4OCK+Dh/JaILoGTR/N8IWJY+mw+dQCFvc9MxpH2VBs635lbi
	 bWhlQ2uouXYSN4xshSrHocqOt6eRIr3E8Ijqq0P+gO8YP6Ezb0xUcqVjsyOzGJmll0
	 RndRO61fpRG1JTW2KfQfYCFKrFktfXO+lJGklub8=
Date: Mon, 26 Jan 2026 11:09:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: chengkaitao <pilgrimtao@gmail.com>, davem@davemloft.net,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kevin.brodsky@arm.com, dave.hansen@linux.intel.com, ziy@nvidia.com,
 chengkaitao@kylinos.cn, willy@infradead.org, zhengqi.arch@bytedance.com,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v5 1/2] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
Message-Id: <20260126110936.4e47e1b0820198e342339038@linux-foundation.org>
In-Reply-To: <aaf30e1e-be55-4212-b096-69f71bafd406@gaisler.com>
References: <20260111074453.66728-1-pilgrimtao@gmail.com>
	<20260111074453.66728-2-pilgrimtao@gmail.com>
	<aaf30e1e-be55-4212-b096-69f71bafd406@gaisler.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 87DB74000C
X-Stat-Signature: w9ibm7ta4dzdw3in4sxdtk5bwd44ts5g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769454578-35283
X-HE-Meta: U2FsdGVkX19JihEbl6WuYw0PRQTeAy7EdjPdqeBNIIOi/XM7Sk8EnZjZF1M0Sp8pEFQL7ErySD/TvNdBbMcxV/yWlHaKf9pxGYGxq08B87ugEhN8g2nyx0Ht1JjQjBBCS4kJZlm7sXKWTPqNCCRw9t5v51fq6dn3hHkZhxHep1sS2uA63d1pJVYFHGso1BVa59g/Vfke3jZrqolPVvUbWWaYqNnCCoin8mI0OvdjxM51dAtXj/mNhs+3H0fNhK5U2qqN/KyeMeEe7HPfpfYxUEXOsLg7vavIAlyrKJYucnu+XnD6WJ9VG2EtwdI7GS40V1PLyFRIN8Hy4S2KOPo/P8oOEYE86/d8b2+5j38FIlW51Dkkr0aeI5oRE1PxwvlUzyZgNqu5RYKTQeI4dVfcwH7anJRDv84rQ3arPtYzvznWio0K9siOHLxwMGzdoo0hgcqyIrBQyUpi43zrWdDhXFeHJ/bKSP6Dd56g7dspu1e4KlX/WwmcDOqgGhPdp/mA6us34tZAI0M/Rej2g4gl/xoMdzO+OZCAHfROckLQyxa/2m8g47Sw8zgayEUzcUExKY6HheCCej3jwg2Sz4iTawRO/9EmH8Si0vrROOAqOtkKZbRkxLIlwXBykvhke5H+wtS7IAX7lW0q3SPnaL1CHYhaUaH/fEm3dNN+KdX3qH91X9CWKPLxegNRWa6e6Zhfn7vmOmw2iy2B2SERPMq6r7/Bfij/42u/OXTE1ex5JQMMffDH1F0ubux5XGHR5ic2x3seEYN9qLbywqRc+y8A5Nflr8p4g8mGbtE7oyegJ+yUms+qPpkFeRjC1hwH3upPA06M0qXmkoylLesa7EokBCxYQIkGeW4iLgsWdxa+MK+H6Ib3mSzXjX7nSzz7b3vNhOFRdxZerTj/IUGVepgntIf4rssLxO5ZsRMBpCYvKr+d25hCuBq3Fj00pxi2PnzP5JrhBRmUu9kmvL5hKsL
 ulMq0Sxg
 1aboOTr6V8Tja37BzZDIY3szZlTfjr1+RxqEXnqO9tK3qWDLc012O/0yjhCuXW3Mt3KVDaFn0kXevilXryeKdnVJfD2ZT1ActGYjVDJkOdJqkbL2Z9xomjWrDc7bAnpvl24P871+zE5u/5vZsVrjaMnwLEcqfmPtQQ6MEo1B+eqF5BNSSQGi2n45vPc3IYB9PQXBYWCJyIEpuOaXtzpwlUwgojW7v9nLR+kCwTt2ydGLgmlK8rzxjxb0HCrovNE7ojo9sUSc32/JSZnxuVKKRGiES9UUVAN0kfwc5TSCqjq6BleO/dTDzTJwGEmaOAPwSZ0SoOarHK7XOLLW8OyrxDoIASHYLPn2vyqAJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 15:50:34 +0100 Andreas Larsson <andreas@gaisler.com> wrote:

> On 2026-01-11 08:44, chengkaitao wrote:
> > From: Chengkaitao <chengkaitao@kylinos.cn>
> > 
> > 1. In the SPARC architecture, reimplemented vmemmap_populate using
> > vmemmap_populate_hugepages.
> > 2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
> > when vmemmap_alloc_block returns NULL.
> 
> This patch seems to potentially make more functional changes than what
> the descriptions gives impression of.
> 
> Given the amount of changes this seems to introduce, more on that below,
> I'd like to see more description on the changes and why they can be done
> than this.
> 
> Nit: use active language, "reimplement", not "reimplemented".

Thanks, I'll drop the v5 version of this patchset.

