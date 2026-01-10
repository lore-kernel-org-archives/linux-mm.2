Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D65ED277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 05:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B786B0088; Sat, 10 Jan 2026 00:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9286B0089; Sat, 10 Jan 2026 00:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5696B008A; Sat, 10 Jan 2026 00:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8C36B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 00:40:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B499140132
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:40:41 +0000 (UTC)
X-FDA: 84314954682.25.25CA381
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id A05DC80009
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 05:40:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZdOWEL1J;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768023639; a=rsa-sha256;
	cv=none;
	b=EHWqAa9xYVOwgSeaTctryhtaYvQUe/VHmmcv/3Z+v7usIQ2UdNgSilqK070NBWbklDBm+W
	UhWH5iGj2FSb2XkeBor8i6CLPqhKAyUyjCQjGvaUOj1ko+bbpgPwEVXs/7tNPcQYE7lxTf
	YmX5lJxQQUQ99K4oH12UoD0h1EcODrM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZdOWEL1J;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768023639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dq5WnUbsxkXZ2XZj0ZTWTXM2WHawM29bk17AjRKeCjE=;
	b=aeZK3GU9bDPkCZceaTKPlaaawiwVQ0jqsH7kVk2zoIKj8aSvW6qyaV03ZEqBhypxBUF2jb
	EvlONiqOAWrl2B090vrEuyqgCM3TzrC2bQWu7mWklKTerunz17VRmPZ2xG1ClDKQjs7AE8
	lcAMrxuF2/eVSqIwrtw/cWvhG+kFJVw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dq5WnUbsxkXZ2XZj0ZTWTXM2WHawM29bk17AjRKeCjE=; b=ZdOWEL1JrzdvWUCpsHwz2fifLz
	EhLnr5Mg2zR5nF8xinZpR1T9ePsoyo1uA4QtdJxsfvSnfDPVH92MFi8UGUwuhHZi64DDUhrH9w9sY
	7/0F5M+CQ83dgVK2CEa71i5uPu9wQaojdES5biXy147dNeXpLFtwdLes2Ea1Yva/rtQxfgvbUNG9S
	EIO9Zg+7YVmSoE05XrqpgI7kB8IGLb2ajRV1PSmTCvv6WKegqil/AgGsjP7EpkFVH65Is+7/gC+2k
	iqed1FP2Z/mKTX7ENFm+36J7rmjhabwnxSq5HMHf+iRdBGwhBO/z4NT9Y8CdOGsBjEioraIcI2xbS
	WBPlP0UQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1veRiE-00000000GTV-3XrO;
	Sat, 10 Jan 2026 05:40:34 +0000
Date: Sat, 10 Jan 2026 05:40:34 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>, linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/15] static kmem_cache instances for core caches
Message-ID: <aWHmUsxQDGHOdflq@casper.infradead.org>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
 <20260110040217.1927971-2-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110040217.1927971-2-viro@zeniv.linux.org.uk>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A05DC80009
X-Stat-Signature: 55rg9dw1wwxc8d758a9f11u1wbwic51j
X-Rspam-User: 
X-HE-Tag: 1768023638-206029
X-HE-Meta: U2FsdGVkX1/iSEIORobTPSOgygIvh/4TBxcBfHosBjLardwU7HckWzFnd5NyjRjZxmaeZwRgoPDWUt/6jqGTKpZpsJfZqt3WqcyoVwHovVGdSIlsGoiKp8wMvQRZax+BrDpfNcvcqECNgeyLGFYSDN9HJXsIsdi8EUmovUvPV2S4Q55AR12/Rvhz8F5eBooSQWhP5Z2sJ4LcaYF+ivjrSCTwCrFVcxACRUPTuk7aJT1m7ohg9gukQoUMDzA3VGJubkGFgXSMUlAM7lzLsjZfZMjQeN6PzPgXoBBwKgltluX772XVkiDG9oiVVeWxzegW7z3d9C+Ti6mPj1iEY+ZYpJNJWSHI0hMV8QuLwcpcDphmSXAGWqUCQykvv7SAm08TwS2ET6xsOPMa5dpxY6Y8ka3BHJ1hVkQ/PpzHS6suxZUsQDt8AZ15v8t5JXCh9XcL2BoXy2HhZxX9/LNy9jJl3Gewavg9qDDwUilZ9sBI4HrW7yY6anedW7LOODkXbjD2G7CMn0ZI8c63DxfiKywX6QzA4IzyqC0dRGD6EbxhluDMc5FmBeq01w7Q9ERcIRbuArZkqJwhv1uZscMSGyVbvk2YzefIExN4pflGF1R1OyzC6ovpkazb7KlvZ+KqQt9vq3kgwSX3/be04PcKruGOuCiK8ta6TlGiJFuhg3hdhRBqvvqLfwZsefKgwh2E6XcZnGH/5rbszjMGW9QZO7sW11Gel4knKKZl+uwDzHVUNN21252+FvWk+HhCVMQeU0HVQFe0etzmniZoPps4xHSBX4OUu1/LIelFVIcysw/Hv0D4NQt9M9vspJXLL/zKDKVSlHvNwWXQflEsW7Ln7gdWpTh2hUCcam86DJHGsoe8IJesdKHslRGvTfwI/TkBiykc6cI31uFQlbYyVUs+B+OET+w1Sxj6do1sC+zWUnOJu496T4AwjkmFqwideNNeyJH347xLe+Mkm3tymKCR7gS
 XnTj3rVv
 wVj553v7YJO4lcxeHp7A9pDTYQn5fOjhkJXNrnGc+Ng0y/dtOKaLy9Bak9Sf2tiqDiYkoanv8dBLTHz8/DFTOf1plvxxQoUdzNi5IXw5XsQvejkQGBYFZ10VGhuliKfY+BL03oxIBKsbhDlzbObyc71UWpw+eR4I9PeGo8Rmp3lac74bAsm+8M4aqB1Ul4wpdn6PLwhM8xPx7iF1PmHa9e00l1exhZJeG8UDea3J/oeg0NjkSSDnlyHCBFTUPTkeOqqClZk6ruzEzA4qevCUopmCLtrVmVWJkz1HUyLnFztk6tts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 04:02:03AM +0000, Al Viro wrote:
> +++ b/Kbuild
> @@ -45,13 +45,24 @@ kernel/sched/rq-offsets.s: $(offsets-file)
>  $(rq-offsets-file): kernel/sched/rq-offsets.s FORCE
>  	$(call filechk,offsets,__RQ_OFFSETS_H__)
>  
> +# generate kmem_cache_size.h
> +
> +kmem_cache_size-file := include/generated/kmem_cache_size.h
> +
> +targets += mm/kmem_cache_size.s
> +
> +mm/kmem_cache_size.s: $(rq-offsets-file)
> +
> +$(kmem_cache_size-file): mm/kmem_cache_size.s FORCE
> +	$(call filechk,offsets,__KMEM_CACHE_SIZE_H__)
> +
>  # Check for missing system calls
>  
>  quiet_cmd_syscalls = CALL    $<
>        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags) $(missing_syscalls_flags)
>  
>  PHONY += missing-syscalls
> -missing-syscalls: scripts/checksyscalls.sh $(rq-offsets-file)
> +missing-syscalls: scripts/checksyscalls.sh $(kmem_cache_size-file)
>  	$(call cmd,syscalls)

Did you mean to _replace_  rq-offsets-file rather than add
kmem_cache_size-file ?

(I also wonder if we want to just do slab or if we want to make this
mm-offsets.h and maybe put other things in it later, but I'm having
trouble thinking of other things we might want to generate)

