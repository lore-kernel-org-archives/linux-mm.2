Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9F1CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517EF6B0092; Fri,  9 Oct 2026 13:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF5A6B0096; Fri,  9 Oct 2026 13:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C526B0099; Fri,  9 Oct 2026 13:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 187E16B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:04:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9463B80497
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:04:31 +0000 (UTC)
X-FDA: 85303711542.11.EC83627
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id EEE1E80007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:04:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjXcxo5s;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791565470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRBwxZ/pTxp7drinmbnO6WjD0YWUO9pajIRsaCkGJRY=;
	b=ACW/g1pasLzU/kSDD8qj5ZsSFqUaqFpN4amrRCINutjrGbO3FUcbtl1QmpuLuUF7hQEDYi
	i8Yvt4AAfjpM17blrFXhflZ3P92jUa1mFi4hMOq204ycgthtxO1XPIlScGutZ2MKGQhGUz
	wDDVrI6zkU0q9fFMw4h1TbKDWNrTY+A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791565470;
	b=Ards586CyAVQODvKz04d/Cjrp26FDdYRr54+rapEMer9lEPQGY2R6YCIMcDd5q6d0c/mFo
	BbmPGmSYsnvsDUI3PiY3Yi/u/4LuWG8+jJ7ubltXLo6fWB3nimid5aykennIj+KzE3DI8L
	qdQ9U3ADD6s2MYdgb76FQzroYyxpzLA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IjXcxo5s;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2854A43B04;
	Fri,  9 Oct 2026 17:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439AD1F000FF;
	Fri,  9 Oct 2026 17:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565469;
	bh=pRBwxZ/pTxp7drinmbnO6WjD0YWUO9pajIRsaCkGJRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IjXcxo5sLrTtBSJR7EkoJWJY77e88/FBq0xaObIkJ8gytFU4tpsY9YddZpjtiCGsd
	 Yv8M15lrCBIrHMaI2fHrUx/MTCbn9RQSd+EyRFZBscjksdk+j08F1zjcIzxZwi8XEX
	 1u+bMyBVUYF8xZLnHLuBWOhtUQ6gcltcfnPFaBFZHrUMA29WW9OLeD7kA9nJ18LluF
	 LQpQpcea6IU0UlyakE/wazbfHT9e+xq4ueFy7q8OcrHkwJbD194frgQQN2+uHH1rhx
	 iPEuGPyeVBHFEVlu5Tz4J1GYor8Qb5ysDSQuQNPlAubMgFFo5EC8mMYSvX4v58SYnm
	 sWKyZYzFSEH0A==
Date: Fri, 9 Oct 2026 18:04:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v2] mm/vma: keep the unlinked VMA off the file across
 unmap on mmap hook failure
Message-ID: <askcyeoKgKb6771N@gremlin>
References: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
 <20261007194708.2009-1-okerixx@gmail.com>
 <e139339c-1e55-438b-86bf-0960ad4029f1@linux.dev>
 <asjQQF_Ok1TZPm1M@gremlin>
 <271f7ba8-df38-4c8f-b59d-68b52ee998e9@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <271f7ba8-df38-4c8f-b59d-68b52ee998e9@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEE1E80007
X-Rspam-User: 
X-Stat-Signature: qont3uds9m4st1rzmf1k8euswp74xtfg
X-HE-Tag: 1791565469-481106
X-HE-Meta: U2FsdGVkX19DhKdQfnx3W/VnVvfXoVYNDDd18ivVacPYw5TqrzENu1VZetIQPM0fxeWtIIDzJAoo4ixGBTF/HfZJxVM7/0I7SVOO8ZxBZpMCw+qW/Ol0bAFWR3JSFb6s7Vx5HKqW2A2MbFFabGhkTLftggVkrcBZzeBVpvLuU7ET0EpLASvVH4C+nlyIeh7wjwdv3S29VyxwyqPp8/0AL/yK7wu0Pk1Nzi+7sNhlzoqTQgMb7uA3sIkz8Y6GxXckccJapky2NAvvjRWLBPCeW7jQGZj1qsyc1MA2hgmOsc4mxywxL02wI26EmZqo9T8/4Z5krMT9UJN7x0i7fob28wmRehxtygpsyyfIpTAgGUENRyg+9iSXMVuY72l3/dQZ9tWVqc70oK0IUf+/mByOwxe3GqREmKZFbAD32vN9IuzE1I2N7JHT+9pFHTzl8Gk5Az59IUNE/CberECTFF4q/I0Fq3mAl0gJ4vHugUOMgytNFVCIQCcrYR+Lzz4SjSiX79CTOb6rAN0IwcHbpuf/Te/6jf0794pmiB+M4GYMg1r90cw1NY9tnEDxvclUfBhTE1N/ufGiD8xG5bg13XvT6Law6amVx4TuRkEo1yj0Pw0xmG1oRy5Wy6SZAgVOJwLbCzGv0PymtbxvTkizRclsHQJktM+t+1UV0p+J27FIKof7bClstGtevEdLptVwiu7jMhaeCNg1U80hH3ho0+BUpLiJYDIASY8jupDuqd/cc8W92B6N76XnW6iKVUzSal5dd9tFa0AZHxqEhv4P2XeCHt3uZk4wNL2xgELXtcC2zMSjBeBdi4qyzPW6cJTAz+g5Ta0pHETWdEG9C90NxYCTi2hGf08e+xGrjscWmepphh3TrdfEY5rKYkqDJ7Qjj9wnNIOlwEJMu2TIn7CiErXaMFSw+O01W2DFq9UK4oLmS3fIKq9ngWm0Sk+twyAPEUwl5rzNT9I/LYzr5IQaeKo
 pSX21U3i
 UOFE6q6RIxunlqS4UCsn9VoSEawr/pzmKHzvHVImHhGcPoG3Jdddxm8ExwYrlaVRgEtIlUqB+45cScxGMg43am7q/2lVW0sar08JGZTa2kB6d1r6aAEfOq/1mJQ2gqjFcEGEgRUH0zbiD20qRqF3fTJcjZyoJ7aboRaMuAttwnanLar0barqToq8SPJ2EPBxqzMM5Uo+7j5B8KR/vRE1S7lpqKIRJPUBXrvT+KfJbrgKfSpwC41rrIAIlp1K/VxYj5pmsSivR9g7BDfPGiq6hYr/CrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 09:38:56AM -0700, Ihor Solodrai wrote:
> On 2026-10-09 4:31 a.m., Lorenzo Stoakes (ARM) wrote:
> > -cc slopper
> >
> > On Thu, Oct 08, 2026 at 02:48:07PM -0700, Ihor Solodrai wrote:
> > > BPF CI caught this bug on linux-next as well:
> > > https://github.com/kernel-patches/bpf/actions/runs/37736351874
> >
> > Nice that it caught it!
> >
> > Is there a way to automatically notify patch author that when it happens? Does
> > it bisect, etc. or just green/red?
>
> For linux-next it's just green/red now.

That's still nice! We have something similar in mm. I think possibly
inspired by you guys :)

>
> We've added it to have an "upstream merge will break bpf" signal,
> because it happened regularly.
>
> For bpf list we run on every incoming patch, so regressions are detected
> quickly. Not feasible to do that for *every* upstream patch, we'd need
> much more compute.
>
> An auto-bisection is something I thought about, but never got to it.
> These days with LLMs this may be easier to set up though.

yeah that'd be awesome, but obviously a nice-to-have!

--
Cheers, Lorenzo

