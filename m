Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5A310ED655
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9138A6B0092; Fri, 27 Mar 2026 06:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB576B0095; Fri, 27 Mar 2026 06:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828336B0096; Fri, 27 Mar 2026 06:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD986B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:39:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C94A1A10A0
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:39:58 +0000 (UTC)
X-FDA: 84591497676.17.61635D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 93B554000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:39:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Opuy95OD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774607996; a=rsa-sha256;
	cv=none;
	b=iUqXz8p1Vm3dg5z7NbnCSh80/n48X65kDJLNnBY8gGxNjy0XUPGxnoGgUHSkdqgRUqJdl9
	k0VDb4PRUuB8xi8BFb2WATNNXxzszVOrMWJdJYBy4aLMrH+uy18TXehUspILUmcSgo4owz
	jsYfyx4zV2Etg4MFX0GtePHTpC/Z0dE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Opuy95OD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774607996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1ws8Xf0ahz9zA8EZB9gosXKAUZuYr3aRKarJP8zWGg=;
	b=nuABm+qW6YFCeOrF4/MG9N1mCltnZXcju65GTb8DwNxtBgYcV+gWrSWhEuo3aYIuIHlm26
	sau1XkafgEBke+ym/AoW125Dwu1oBb/09j2sDQ9MHkiAmh1wdIGjh3JcGNVS5Vlp6ergAd
	oIPRH0/m7QBwBNa2JMrL2EDAj8m8Tiw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00B3C61335;
	Fri, 27 Mar 2026 10:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69763C19423;
	Fri, 27 Mar 2026 10:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774607995;
	bh=AIVP9bcyyKqreECc+J/GC0UaewkHPBsWqu8hYlrdtTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Opuy95ODt7LQ+ufn6YZUfsHjQFOj5mQ0x7Dg2hxD8OIqYuFZrmzUF5EWQaf7v/MwT
	 r0hkmHYgFTjbEWIoWRtVwlQTdXf7LetjaUcHPdNJ3YJ8RtrQAPW8fDdGqSPXWIr7Jn
	 STHtG8NrjmJXT1UlNaUtQInSjyK7psKHvoTp63zEeD4TQKPomdRMOeX/TPoiZWo3+v
	 AwH5Koh8kd87dgHNUXAwLMp/xCVXpIpsIPMa3XURId6FPb+WxVbNWQKOwMwHALvBOG
	 /7bDnfhpO47SSWljBU7nlQB5bUEXxl6FPSjRgd2eC1/1L9g7Ldmz57hLRSHDTph39N
	 iWxN0JpCVGBMA==
Date: Fri, 27 Mar 2026 19:39:53 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
	linux@roeck-us.net, andy.shevchenko@gmail.com, hch@lst.de,
	Jeff.kirsher@gmail.com, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
Message-ID: <acZeeYA_UbaK7AVd@hyeyoo>
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
 <acYlxRBhSMcwBnja@hyeyoo>
 <CABXGCsMTk6kDuJxsTAUKP6npTvp4X6Ryng+P4xjMUsPbTA43+Q@mail.gmail.com>
 <acY5G-lKZQEsUbRw@hyeyoo>
 <CABXGCsPQo=Npum2aHet3QkZWkWEnEVMAw0KQ1AHPrNjMn=9bmA@mail.gmail.com>
 <acZDJ4Nfw4x7HCSr@hyeyoo>
 <CABXGCsO_C8++4+oPfZ+bQyrBnEGy5JFpXHkGNpfy+8=5BvVNfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABXGCsO_C8++4+oPfZ+bQyrBnEGy5JFpXHkGNpfy+8=5BvVNfg@mail.gmail.com>
X-Rspamd-Queue-Id: 93B554000B
X-Stat-Signature: ne6awax1bh5n5od43b1r47i1pm48hzb4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774607996-956939
X-HE-Meta: U2FsdGVkX1+b3h2MFfs8Dg8204uNADADMq+1Qn9BiwJmA30nSGRcarhG5vjr1b+j2R31WIb7aXHwpMS2JWXYfcJLZOJTbSbo+1V6RbnjPcMMqBkQMEEgq5MtlwwNKWe/0kImieApQWF8VxPY2cnRLLe4Ut1vzQoZtJ+W7JNyhLxn6WBfu/StpqdXQIFRsZbGsRlNmHcSCUHtfn4oqtCb2P0hIxT/vTnDcLgqO0/hv+K/3Lw8g9IvwzvzLtk8Q7klMOlex41sgxR4IKNEmZCX+WAbez3lOU+xaf2cyX/WKzoREvDsgaVJRZNJOpZ5EvU1TdVRMo9HPLDc7rZKE5SgYaPaRZspO6V6emaZr2bI1z8HNierlG6s2Z72NJ9sLEaE0M9CdOynxUvgVECunEYjZeCUTp5jt7fsRgFXO3mDD50GytleA+auP7/HvkWFqIJbjZk63xikRkLfae/zjQ4yTnuvoxbOAU/NosW8Q9QCEJAwAR0riYBoJcqt1I0+NnYLK2NYfIaJmxxFsgmfZnRK1dCFvoQgjYlYjo6ySKGAfg9rOwDcNVrkI1nVrOUXTCCp9lm8OEYNrzJIYTffPRhy6N5ty7JO95lr62JH5wMKlonJeE890WiZesoxYdVCDPA+8ioQo5rR6LmXqI3vobQYJGjU0anVviUe7db9h7tL7uLOOq6jgrPE0RWGn2gBSmRW8BxQJnWTWmgzc+YWnYD+uC87ohH6uIlwwNR4xddqsBt9442mu5cII8qI3X5pIF6JKW+Tfg1LeAh/CgpZBzR7ADDnjoxJy6I3j8gay2clEs9yatt2dqf1FuM4+GddhC6p6UatahHRGwF8q8NRuGUiOOaB4u7LD2hDlp94XjT7Vs79urbjSLxsv+Tv7RT5o7I6wwDcGED7zfhv/tj9or5asUUVcBZxqom8RpbqSwVu7eAVaf5ssawfi9bLkwsFtuhfkJBO1OgT7+/lfYsYh4L
 PJGTKr7Z
 ZDaZOYwUqf/mVv+bhMxzJ9Fwr0HzMMpwVPLqHOu5MZpLhyYkrFnmvHgkP2NYOIVEnRvW4KS/pBjaFTWB5oGy2nvF5l8kzzf39MZtw7FEJ9GMqAAi05NN/BG6celF4nbxyxootRg5yFNsSFCW0mtAAX5sJ+snGix1cwCVS+WmBJif5jDgnwbGtqKsqDAyXnIv0/+b3mPQTh4qKIMVi0aV/Js4nca0frC99A480VGoWRWqEt7ol/WxJNaE/v86+Nl3U3/f3Od2BRwvzj7GoMzO70EyNJfKRZzmlcunLovCUaikQ8Wto8LuGKjNPJgV0svnNOgkMwDLp5MkOwIKoujdjG7dkqwrVPRUI86OS1to+2DpXUphPX4B/4JenoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 03:25:00PM +0500, Mikhail Gavrilov wrote:
> On Fri, Mar 27, 2026 at 1:43 PM Harry Yoo (Oracle) <harry@kernel.org> wrote:
> >
> > Probably what I said was misleading...
> >
> > I didn't mean "the architecture is fine with overlapping cacheline".
> >
> > I meant "not defining ARCH_DMA_MINALIGN or defining it as smaller than
> > L1_CACHE_BYTES is how architectures tell kmalloc subsystem that
> > kmalloc objects don't have to be aligned with cacheline size."
> 
> Hi Harry,

Hi Mikhail,

> You're right, I was wrong about dma_get_cache_alignment() -- on
> x86_64 without ARCH_HAS_DMA_MINALIGN it returns 1, not
> L1_CACHE_BYTES.  Sorry for the confusion.

Don't worry!

> So your suggestion to suppress the warning in dma-debug when
> dma_get_cache_alignment() < L1_CACHE_BYTES would indeed work
> on x86_64 and other coherent platforms.

Thanks for confirming.

> I don't have a strong preference either way.  Both approaches
> solve the problem:
> 
>   - slab side: prevents the overlap from happening
>   - dma-debug side: tolerates the overlap when the arch says
>     cacheline alignment isn't required for DMA
> 
> Would you prefer I send a v2 with the dma-debug approach instead?

Yes please. I think keeping the same behavior regardless of the debug
option will be better in the long term.

> Happy to go whichever direction the maintainers prefer.

Thanks a lot for working on this!

-- 
Cheers,
Harry / Hyeonggon

