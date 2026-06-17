Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD22CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41256B0005; Wed, 17 Jun 2026 14:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D182E6B0088; Wed, 17 Jun 2026 14:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07DC6B008C; Wed, 17 Jun 2026 14:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56A116B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:40:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4AB2B4053B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:40:36 +0000 (UTC)
X-FDA: 84890270472.30.66175CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 41F4FC000F;
	Wed, 17 Jun 2026 18:40:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGEAs34F;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781721634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldThSSQTB2CI5zmNiVNRBJEFd14r4QvroLDBqhcTeek=;
	b=lHEYW3IL+SDFZysjQ/4bujnepc1BuNcuG5YMeu25PtTRrOlY42XlXYP1LI0hnp6GrUQBmP
	3CWi6oZdqOdIvdk4xZmxX7PjlbKG91jwn/KyU5RoyBBTm4W4tmcl7XqgKzaXFoR5tOqdBi
	pq65jx420CKLcvZ9M0J8ezWzpFwds1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781721634;
	b=JVcQxKgLxC+EfFfsmS2IWJ0HfUJXB2J71NtZr1/+6K6AgoU5fpiuvV8s3B4h2K/MrUQpd/
	bjpag6DMg6qEToKaRnagWVAe44Aic0fnMIihUD2Byj8kfc5FPR2f5+UDgAdOdJNf6onDH7
	kz27nlDTworHc3c//SbQtsMFHwiunYc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PGEAs34F;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6044A40BBD;
	Wed, 17 Jun 2026 18:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398011F000E9;
	Wed, 17 Jun 2026 18:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781721633;
	bh=ldThSSQTB2CI5zmNiVNRBJEFd14r4QvroLDBqhcTeek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PGEAs34F6BiEJMajWABVfRAt6apO6GdmemXHMH9ZaDCtfTlhEYqpEiVDB/HATlSB+
	 5c8IZjhNSJbfvIKg3U/WcQ8QMFrETr1FwWAEiMnEo3zeh1Eu0mWa/S9jPYpERLx66T
	 2BjXib8XHNbQc7T3GRgH4fqDla3faZEtb42/ywbV8Pbb6efs2PGh/vIfIJmL1bdHNM
	 CViMGplX75QLZCOIlfNt9NbEG9KrbTjrWe/WC5MAibT4lN+1YOTGS59HzxKPT3ENFH
	 pf7bxdmXswR3mZijG+ATccnjAev3cNuDR0uzCu0H9xumEJMiUdcPjwBYm8fm8JsOvm
	 cdF0DYB088P2w==
Date: Wed, 17 Jun 2026 21:40:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>, owner-linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Message-ID: <ajLqGZ7sfKsQaSf4@kernel.org>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
 <DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev>
 <aiuyoy8Kmr9yU4GM@kernel.org>
 <ajK6w3YTFpVaUl3v@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajK6w3YTFpVaUl3v@google.com>
X-Rspamd-Queue-Id: 41F4FC000F
X-Rspam-User: 
X-Stat-Signature: 5afpyqzbjurgneysof4cahwrmszqzabd
X-Rspamd-Server: rspam08
X-HE-Tag: 1781721634-109819
X-HE-Meta: U2FsdGVkX1/D5DtKC9uc/dsI5zacEXIqLn7on8YoZoPP9Ry62BXkwpmmfzM17TBSOSfOq+gx/1EAL4yj4BYP5ib5SmsP8D2MnvGaK5Hk0y0/EwlWwHThssbPe+xo7UrZoMo6aRRERptAycSUaQKw0gjpfLMHcPK2szAgOGh3EJl2LwEO0HZy7bCXfweFbmVExa2nm8M05UX6c3ZLxhQxWksZ8fTk4lr8fCcTqZodENil/r8tlZxI3kipWNV1pcFKAPpQ7NzxCYbw9qg1tfW8f0pH6YjjHZyBO/EC1PDf9t5oe89kCup7Wyr9cr37TFbHBPL8hZ90OMAM/iOkGMltSv2O30GMwTvsLZteq1nB4YPuDmf/2LArg2tdbKDT2wy5LCaxXJ7RifndssGrEAe7p/yPPBMhnfLlpfvXdCh8akVDT7W2YhDi1z5HrhypavXb7e3qBNTg8iFqMXCu6KlapHIrckWLosfOT+++KUQuA20HhokL6eYZlqRa+Y1OrwIg6u1F+WC0Nwy1/MG1RvVixK3dL3xTzCdWzZfIv/GWut23ue2uZNmCxHNc6BL2AkoiDlguSIozWlBENW7GougtUchD+b3A/3HxXyPymXXveh64AnCGzY6CIE8DworAAfby/i8yrPpa9yZYr0pVRmcUSBPh6Qfj/DOEXYkgJXcyOnl+0QiGaeqg3L7uT8yoIqHhaQy2YmqRgcLBs1uDURNz4HvVXdglvT41Y0tCXsSRNLUBrBKffEVKlKA3ydvdEFeUnto3V0Gzem2bpdlYHRSKZsJfLZAN+sepfoPFpbPJ7z2TekeatJ8XhhTMYTm/AHtjIaj/u3A630RJMZc1O1nQ3M0PZYzABfKmize6GkofFo7Ldm7Ry+IAbHfdlwKSQkUUiR4VhV19yAiFNls0WXDt7eSbK7t2DNcKvs0GItJ9j2cz6EzYImhbV415L+BMZQkP123HnUOr2xCkO+k2qc6
 HUPboWuo
 kUZIzuPoWJfPggw7wZYlxDgZxL4W5t3e/GT2b+z8l+eARwscLaoaRr4/LuXv4r4TlpXPZaLg+kIL50z3pSuLSrRKuN9fBH1W8JfJb8zAs76RYI0EjvaZC0UZHGVwW4qBFPDf4IeZgxBZ3jzGKo0zPg4PlIXJSx/sHWoceiEcfRKuXcxAWhIFIwaj7nat5cI/u7QA4dYZomh4umBVfMKCok49BxuY6SdQ4lmFEnd/BFM/+hb7XWyy2puQcWq9a0HkyW/cMFBIroiyBMvLtmuqMGk0yQmHCCkpJ+1NhRg7LVoziEz3fOlB/9d7WbvtISr79+8VzLAP3bRAWJt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Adrian,

On Wed, Jun 17, 2026 at 03:18:27PM +0000, Adrian Barnaś wrote:
> On Fri, Jun 12, 2026 at 10:17:55AM +0300, Mike Rapoport wrote:
> > > 
> > > Hm, maybe desirable for execmem but that doesn't really mean the x86
> > > behaviour is correct. Maybe it makes more sense to change the x86
> > > to align with the arm64 behaviour here?
> > > 
> > > BTW we should probably document this API a little bit, I never thought
> > > abut what "valid" actually means until now. I had thought of it as "I
> > > can access this memory" but that's an unclear concept and now I realise
> > > "valid" is a technical concept in Arm that's confusing. And it's extra
> > > confusing if the kernel API uses "valid" to mean a _different_ thing.
> > 
> > I've got confused too and that's how set_direct_map_valid() got into x86
> > with a different semantics than on arm64.
> > 
> > What execmem really needs is set_direct_map_default() variant that gets
> > nr_pages.
> > 
> > AFAIR, set_direct_map_default() has a single 'page' parameter because it
> > was added to reset permissions for the direct map alias for vmalloc()'ed
> > pages before there was VMALLOC_HUGE and each page had to be reset
> > independently anyway.
> > 
> > Maybe it's time to add nr_pages to set_direct_map_valid().
> 
> I was also quite confused by this initially. I spent some time debugging
> until I realized why unloading all the modules was causing the kernel to
> crash.
> 
> The reason I took this approach was that I wanted to send out a working
> prototype for arm64 that wouldn't interfere with the existing, working
> implementation on x86.
> 
> Following your suggestion, I can put together a preparatory patch series to
> refactor the set_direct_map_* APIs to accept a nr_pages parameter. This

There was a patch Nikita sent a while ago that does something similar:

https://lore.kernel.org/all/20260410151746.61150-2-kalyazin@amazon.com

I believe you can start from there.

> refactoring would also allow us to drop the redundant set_area_direct_map

We can't drop set_area_direct_map() because vmalloc pages might be not
physically contiguous.

> helper. I could then rebase the rox_cache series on top of that.
> 
> Does this sound like a good path forward?
> 
> Thanks,
> Adrian

-- 
Sincerely yours,
Mike.

