Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49BD3CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 02:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFDA8E0027; Fri,  7 Nov 2025 21:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960BD8E0006; Fri,  7 Nov 2025 21:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F598E0027; Fri,  7 Nov 2025 21:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 668058E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:37:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C1E7140546
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:37:18 +0000 (UTC)
X-FDA: 84085878156.28.C26D7FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A93580008
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:37:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u1eDVBuy;
	spf=pass (imf30.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762569436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YRjchoTdpSkTKMmy5t717ZqTL/yduxeWqpzYlVARuY=;
	b=CVank5H8cwzOQOThyNrUKMSqEyvVnEEmk1BC+IGGM9CIAqs3zgROt1azSnhE1aVfg4vcFW
	ixqYk7f8wCvloEyCEw1dY4eW6f4kTAhiVe6rEvhTaftVDa0fN2mRw7QQKhf8K2hqS3/awS
	WGrpv7Mwco/jmTQFZCbcjre49pnYDGo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u1eDVBuy;
	spf=pass (imf30.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762569436; a=rsa-sha256;
	cv=none;
	b=KeK/2rBL0mwpLLUqziEXTQxHnKPdmDmj3oq44Yp2xpJwL+zCJlXT7tXcF7LBTVKV2Vb6Sb
	QOImFi3atT9oN3bL1Roo3/6eyohDpnfpB+xuvBsYaWffB2Bs33sOyuru9KNk0/rfJOzcfj
	iHeazJPDC/C8H/oJ0QmFP3R5mUrWcAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C79143500;
	Sat,  8 Nov 2025 02:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07224C19422;
	Sat,  8 Nov 2025 02:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762569435;
	bh=Ou3u7Vf6165AwGz1NI7XrAGwfnZWVMEdqoH1Q7dBYYk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=u1eDVBuyluzoT6wpUlZ1bNsISDdrnxrud/MWHNRrWneUQUSr0tLuPmnvHaGQ4xM4N
	 //QJVSvXi9HicgXpdx9lhmTzGfyQd1bxAmnkwgqJd4+HcNQjvlaqLETmjHzDwMocZG
	 8VBtwlLx06pOqPlDEr20kSSpYKH6ZdUF4BnNlcvHfDy2+SaerJT4o0RKUNtzkA3de2
	 RDvboLOVpWoce0ylhnS/eztY27WUcAML5hVi3DM2XGkcgXhW2UE1gkvicQXHNY4GoN
	 dXUHNw5MJNUrRv6j79+MScwp6ZAzr0iGyf4P1L4ym85uTBntzQGq+IZTRkJHrnBc40
	 AZ06qf8B8xzzA==
Date: Fri, 7 Nov 2025 18:37:12 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, horms@kernel.org,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 ilias.apalodimas@linaro.org, willy@infradead.org, brauner@kernel.org,
 kas@kernel.org, yuzhao@google.com, usamaarif642@gmail.com,
 baolin.wang@linux.alibaba.com, almasrymina@google.com, toke@redhat.com,
 asml.silence@gmail.com, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 sfr@canb.auug.org.au, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com
Subject: Re: [RFC mm v5 1/2] page_pool: check nmdesc->pp to see its usage as
 page pool for net_iov not page-backed
Message-ID: <20251107183712.36228f2a@kernel.org>
In-Reply-To: <20251108022458.GA65163@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
	<20251103075108.26437-2-byungchul@sk.com>
	<20251106173320.2f8e683a@kernel.org>
	<20251107015902.GA3021@system.software.com>
	<20251106180810.6b06f71a@kernel.org>
	<20251107044708.GA54407@system.software.com>
	<20251107174129.62a3f39c@kernel.org>
	<20251108022458.GA65163@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5A93580008
X-Stat-Signature: 9xzyxsckqnakmz6gi17caj6g8adwywt4
X-Rspam-User: 
X-HE-Tag: 1762569436-185122
X-HE-Meta: U2FsdGVkX1+b0W9/HlsOMGoMXOWeGH8Mic2sCL+ZiXFZcAYi1xigJqzOwaXR3ERxxXV3yWtAYAuTKwG6XzVUyERL9vWBtLtlZaDfBsacQ7/G4PRI6W7neWTGIJmP9kqkH9AZiTZ3WIoHlFbVzP88bYd6KWbaCTS23RF97Osbi+hC0nfnTwnuBQgZFor/Dbi0egNxXFowY8AklDlSqPKbqdtLQQ8EgrkTezPbCy0scN7Z7pXYKO3NrrFHhnbTu7kp+ewrKW/lMecB41vkloQWyEUpob5scxHmw291xVKn3dloc109xlfcRdl92iCGp21N9/YJUm7R8WlApkfgyeOrSxfH83pfFS1jf+GRMtpgR4p0rfByuCFleZ3AOrypZZPXIt0wNwMuTtpioVdYim6g7kVFQCKC1OvkfWk4S9E7luU76Ptp2ylN/jHS1ADpyuGGk4ITyPFBuq+kkaEnfAG7mAxulAkb2l0f7xn9gCRvu9mYmpwtPMW2fcWzJnH8JQAe8ekY3ftAs4bN7ULqqWQcfLvCY7b8G6IXq7dkIhe32bqaYCgRfGekOleI2rn8WSEdlEg6ZqGUF+h8pjaWaJsCYjyBnHABXT9uUY2TtKn6AQ9FHpB85mE4RWDIynPKn5TnfQhke55EbAEIDptTuQskbr0Ys9rbgHLyJkNfili9UwJ5XiyTW0Ke6TpseUUp6bq+uSbs1K60sQkVVx1I+80OeT7R0wTZ4b7rKPxsFvVBlxF8GDkeRKz9t7Wm8uRJg/S+GER/Tv+s6UgEdVNibq91rAoaH4pzkwhMyljyduwFYIq+sdhW8Rz/2JHnCSsush371xNl3KjPGywAZDmOsQynFbCY7bLnxJn5vniunHqeWj7QWMak9Bdon3KqvbUQKc8ieDj9o6dxIv2d1MOHUxfXVpzJUg8tFMWIcVkxByY+LLiuBa2JtP5GtTu3X4Q11GBxaYB1gs8+1yXDnvyk0WH
 nwmtI8nz
 WcS2NIFErY6SCFF8K7SA60I+85yyYS1Lx5EAtf+k2uafDWT4iPU17z/NJU33M9ADI6sJ93sCmJQ8sxHTUj4tJXZSngV/+FYqWagKxF7JE/xSuoYnZkZIRYBDOkkGdh0AMysLETvIPU2gCxk4eqVpP86mJbERiNU6mdaH9z6i50I2O0IhlPWaY/ZyLtNjIkO2+bK1rQxH9R29CnFt8dus6/u9+34qZdscy0XsW7/QZWOFWMSnTLY9EkpmezVfch3xWFZDQsryQDBRwZhIv5xUSPIbyZpKCZmPAiC+M/7nRP9BBeoB0qMAcAAqgATdvXRoNrpVASaTMx8xFaED3PxsIIOH/sbqCaC75YFgrnB+zDKq9oArYrMlTDtPDX4Z/vu7h5mAl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 8 Nov 2025 11:24:58 +0900 Byungchul Park wrote:
> On Fri, Nov 07, 2025 at 05:41:29PM -0800, Jakub Kicinski wrote:
> > On Fri, 7 Nov 2025 13:47:08 +0900 Byungchul Park wrote:  
> > > The offset of page_type in struct page cannot be used in struct net_iov
> > > for the same purpose, since the offset in struct net_iov is for storing
> > > (struct net_iov_area *)owner.  
> > 
> > owner does not have to be at a fixed offset. Can we not move owner
> > to _pp_mapping_pad ? Or reorder it with type, enum net_iov_type
> > only has 2 values we can smoosh it with page_type easily.  
> 
> I'm still confused.  I think you probably understand what this work is
> for.  (I've explained several times with related links.)  Or am I
> missing something from your questions?
> 
> I've answered your question directly since you asked, but the point is
> that, struct net_iov will no longer overlay on struct page.
> 
> Instead, struct netmem_desc will be responsible for keeping the pp
> fields while struct page will lay down the resonsibility, once the pp
> fields will be removed from struct page like:

I understand the end goal. I don't understand why patch 1 is a step 
in that direction, and you seem incapable of explaining it. So please
either follow my suggestion on how to proceed with patch 2 without
patch 1 in current form. Or come back when have the full conversion
ready.

