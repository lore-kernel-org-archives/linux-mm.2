Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FDE3CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 752CF8E0013; Tue, 11 Nov 2025 14:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703778E000E; Tue, 11 Nov 2025 14:34:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619AD8E0013; Tue, 11 Nov 2025 14:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 50F5F8E000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:34:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 002181DFD83
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:34:22 +0000 (UTC)
X-FDA: 84099327564.04.C2F04F0
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C71B1C0007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:34:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HSM8/b04";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762889661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+/QIYglm3+7rhOS6L7Kr9NAKmdN6FeBGXByzeklErs=;
	b=1SJwFjJ6ZGGBlrALIPX1Wj6rSBfwX05Fn1CCOdhFjL4I8M6PX6GJAiwr5VxUTmumfA1qiV
	zDh1D6Wk4Y9HTG764wZXliiNEtWsnGqpnM52GFN8RgAcYVgXHE7o1eBKbrH8GKXVWSMFTZ
	2Th0dmE4qAcyDZh7peIidOugTWA65yE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HSM8/b04";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762889661; a=rsa-sha256;
	cv=none;
	b=54zSQBtGTwpnLezn5Vz190KsVxwaXMfeZA47UI0m7uE2acEpCynrRgt1ya7sZkj4XMwzpc
	Fvfz+aPmz/sWrqRW+0swN7XCDnzU2HCKoLir+WaO5XC2ElTjL5oEoZz265TA/cANh0bIEf
	Eyp0LY9vGLLuQ49LAOYX6CfenuRqgW0=
Date: Tue, 11 Nov 2025 11:34:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762889657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u+/QIYglm3+7rhOS6L7Kr9NAKmdN6FeBGXByzeklErs=;
	b=HSM8/b04crKD15cHPSnLQx4Hhg2/3Us8iUQB645UpiF+QFOEmAw+UOT0+SyUrYVCQWmUDz
	tZsE/VL6fS1cWO+eXr2Ms/1rLGv/BLb659T1jvAiYYrHlcmDOEWF/nQvfPODuNJBS9ALRE
	0a1L69FWHj4U6P9pxJywFzDkIgZrQug=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Message-ID: <djh4sirs2cgmdhso5fwcx7s6yrkocxbqshcosgrqetfykte2bz@opfihf4wun4v>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <87pl9oqtpg.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pl9oqtpg.fsf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9C71B1C0007
X-Stat-Signature: 7d5454yx3izgm75udgdfq8phfdb8wk48
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762889659-283086
X-HE-Meta: U2FsdGVkX183aWZQHigrPj39yAv9tfEwH29TWqfcaah6PdV083dSdqJQdPSlpuhRPSO4cTvSapeN54Co8Whk5tDNFcj/mKBAhE8S3Ln6Igw17CoI5mCkcBGSpIp9TrGPPuUlBLcBowvtLeBm95u2QEZCqGPXh2dhzlr/BlD6sTr6HD1g9S+k/h0fvqk8jSQslTLB+oiUYqmarllf/6PHZPZivVTV+EbAvSmluFxGCTJ5NZZK/J/xdfpB7NCeEZf50rmUjK+V/f/GVnLNnwtGxhkSbgtXFxdM8O44K9/EBg80O69zrLCz7KJBfZsimJje8b7r9MiV6mbMCWm1BpoHILa9HaBGDEnO5vlNsj4IfcL1qMqbQhBNeYVgTdJV6RsAEyd8vqoNNnibUsPOnU+fkmoQgOM4WvcSPyKYWw3j7zC485pbSfTiLVAlrocjtvPBi+VHlWG4a2mxJ70Juk4calo3qSYpK20OMIX3Lq0HWHRoWUu3QR3PkJCXXeTyQJd+p7ErkODStm3s97BhU+iO61qyMdqu25LAzVCKJ+5IeDBSFug8AzPUZB8DkCrJUEJ3f+l/5LUV2i3JpxemVf6EyAYCi7x4nHMLL/jpcF7iTaAdfVXM5UN2QMlWaXFGB5/prNFST0ZrEL1F+1jiYBbja8gnL1beXPjYfMHYpcFzKnMJ8moFWQQNtmcWtaji3nyAB9yAW9fnNhqz3+bdWVvjDw9xsVoQtfixKG9/wI5/tVEo5YwOchjoEq8S5tn4tKeEPsdv2BOdGfhldgjEDf2kmXuFniBDts/1GyYt6HnwAtwrVe9mZy4RjCJ+ALSUSmRzkbyNeihE4I8F6CyspfXhmuhKsu3SXySZs/ZOUcDbGhuciKoBIQn0xNIJugj6Pabg7WPtsCbGS4zPI2+DLINRNshbXK6PHvYE02y8ulwmC+LbnmlaggWrVzW8wm6ScbynGCW4UhLZLcobvrvb95G
 GLKvePvd
 3f2VAIt6+/75Fy29VWY4OiMCkR0zB4+IdZCXnZm9hT0Y/r1MHpWw/zTG8vHgy4/f01ErBojJ/CzdzzdaIw3yUe9UBMnXKFcPN7CVggdDsxm+oWI/tpfVSEK7KenG1CMJ3+BU4WdOGMBUvDyKsbsIWD0AR2nk2kGQJzm8eRNgurtj9GwEJEVgVqQbhXHvSvdPc2BbfQCBAPoPR82OpGEDmGrIK0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 11:01:47AM -0800, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
> > The memcg stats are safe against irq (and nmi) context and thus does not
> > require disabling irqs. However for some stats which are also maintained
> > at node level, it is using irq unsafe interface and thus requiring the
> > users to still disables irqs or use interfaces which explicitly disables
> > irqs. Let's move memcg code to use irq safe node level stats function
> > which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
> > (all major ones), so there will not be any performance penalty for its
> > usage.
> 
> Do you have any production data for this or it's theory-based?

At the moment it is theory-based or more specifically based on the
comments on HAVE_CMPXCHG_LOCAL variants of stats update functions.

> 
> In general I feel we need a benchmark focused on memcg stats:
> there was a number of performance improvements and regressions in this
> code over last years, so a dedicated benchmark can help with measuring
> them.

Yeah it makes sense to have a benchmark. Let me see which benchmark
trigger this code paths a lot. At the high level, these interfaces are
used in reclaim and migration which are not really that performance
critical. I will try benchmarks with a lot of allocs/frees.

> 
> Nice cleanup btw, thanks!

Thanks.

