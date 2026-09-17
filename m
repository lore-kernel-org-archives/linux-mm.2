Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99781C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DFC6B008C; Thu, 17 Sep 2026 05:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7661B6B009B; Thu, 17 Sep 2026 05:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3726B00AB; Thu, 17 Sep 2026 05:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4135E6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:21:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABBD6140271
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:21:08 +0000 (UTC)
X-FDA: 85222710216.16.9571D0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0880B40003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:21:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EsCczny+;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lZzDFlxX/qVCaVB45kg2QRgxtQ9oAG+1qTOWZYcMP4=;
	b=Id5ihEe171HOxUAuVVxdUEQ+5h3HtbtY8ygyUb9dbXC38VD4gl0BG7TzTl8eWmzgiAeEI5
	WIpSCKZMZwY2mOmefsbud6SBQ/uiBnPRI4nF1u3hXW0NMFMxzZchLEiNpJTUhjJERgh5Fy
	tSlho8CENa7pe3yLOoDPwq75xjKurrs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636867;
	b=4qgeJ1MZuN4BNxZWolNG7s6pgO1gtsa4X55dQ5QaKRkcNtzmSAS6qakYZllTwwF8Ry55er
	xI2LsDGpCEBfqq/nr+ZsgTWFXC4yuX4jGpqnN7p2cTXotkdw2qFg8EmoZYFd8s1Vry+6ws
	7sAsp63AlFtlLglGKeTshTJnLV6KjqQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EsCczny+;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C9774233A;
	Thu, 17 Sep 2026 09:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AFD1F000FF;
	Thu, 17 Sep 2026 09:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636866;
	bh=+lZzDFlxX/qVCaVB45kg2QRgxtQ9oAG+1qTOWZYcMP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EsCczny+7qIoZg9X25IIIf15Q3rgwyinkDrYQqFLxdXtNwzshlx8+eDvg4hMMM9SB
	 kSW/9JqA+ioqE/6mlTMtmcXBW5jlKLaZqr6oI+rm14s6hHAkc7uVh4LuklzM7n+jPf
	 JEkf5CZniH2PfZ+62wsnjLXOqjMVhmebMa4Ti0dOnS81++sRHEoz9X0Bf+91P6FrBj
	 +IyHsrKcibGCGPGlfQTZVfJvNSgDPQc6x/ZPikbW1+GTxWBVA2xWwtklh/orikypsT
	 YiXjGCtzipfUYooOG1JVKLaxtImrn/VLcxSvW6dS3txPY9bOEFzVllQug3fojFMhWC
	 wtHB1TAmfIFaA==
Date: Thu, 17 Sep 2026 12:21:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: 758910018 <758910018@qq.com>, Helge Deller <deller@gmx.de>
Cc: Zhenghui Hao <zhenghui.hao@qq.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-parisc <linux-parisc@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] init, hugetlb: fix early parameter ordering
Message-ID: <aquw_N_dSUDy2o1G@kernel.org>
References: <20260917062837.558251-1-zhenghui.hao@qq.com>
 <tencent_0490E1CAA4336214AB70F813325F3020A608@qq.com>
 <178963086483.2200502.14463144472620315064.b4-reply@b4>
 <tencent_B4700AD229B1E6D517FC751924185FD3BB07@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_B4700AD229B1E6D517FC751924185FD3BB07@qq.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0880B40003
X-Stat-Signature: woz4iee1qrbj59o8fsbkftj3cy1qrcpe
X-Rspam-User: 
X-HE-Tag: 1789636866-594561
X-HE-Meta: U2FsdGVkX19BMmmISJ0h+xmSu5BV2H6M3idFTVH7nu+g8SFsCwtuwtndu0Fbv5Qi2CtkWAoJ1lryFr0d6+6Gl2lX91UE38N78hJdTYGE2Wx61AkRPN4fC/3OoxtAF25sjhtLK5veLk+7/TVMy/l8ygyMJ+l2/wJJCJsbLbERwXXlJdy5G5IoJrU/K6/ONNnlsqxrSfjnok/4/oyRVIuHZmpuQBOcYSL6pNhr4OzyW/x3y1wNy4jHjokT/5EZxHtiwR9zC197y0mp0Aw+AbFDBZZK+m6CgAyE09i3M/qB5ajNOvNn7mqlvyNB8tmYEFzONfexyR128CONXS/hExzxFCaMrPXMy5b5kYBdmmFVnOqDkOAvOifIY09vNc8iWMtTD1xsgPb7eb4hJgJ9hzB+LcMlXeKIH2I6wuk0bmOZxR7PdyISgggygiO6SErXE668D0qA1nwaMwPbZJi1QS0GPeN7/7dag1jV0iq63ivqLU0Az/7w7x4nKqihjbUIQfyNI3skeIxzcmoXKWbUgvf2z6XRa1q4bJ7T3ZuWOQfbEdkop6NmITDELoDuD+a3mDLtUIuQgfhLE4gvRZ1g8pvDqu3CM+wRx/NRvHVyBrZd8JY2CSanBNBZaYSPPAWOYMktRPqv6879VmwJKx9RTpBl9Qb/5USloSFEef3eehqIzholveVlX23ylAz7H5yK4U+bO55XAXgc9lB/Pe96oFYpL1GBrBSgx7Bts9XQa7pwFkqEjAJAPYQuahUfVLwJ6REzhJ3It/aOBFNB+aaRlYjDfumUkY0z6v7Opmj1Zn4FmSpGIc/lv+QKUATNh6qwC1frLjNTAf0snu8mQMp7zZJ2pgJavbcG5vDCN4qw62APxi5tabvBP24Myz3iaapnV6hM9X26Yyoj1D1/WaiTXlgBA6bKfy+HGeogXcZ6D+FxMY11tiUMpXZMogTEZetOpY9m3zzL9jcwRMm1vWLoMvj
 JQwrOkU8
 pZ//GXFKC6r3l5Wf2FVdM7aydfLTkrwSnt8TOYShj7vJrE+MX43cx1NLjXxTbY2PZg4k2hhSZ+7LvyKNiIzMtSM8IPvwdac0QvTdmNcNu6HUkdR00omMH7ssSAUNZq5GKAY7xyAWUDs/bdDeF9vmvhYoN5qYW/6jlUi0/seRxjj0JwETAOSeSSIL+JMbNgdo4ut9/i95JhuV8XRNONw6bzoF7N5S3CcKyzzWdCJVkIhiuUmaqx5HnDooC67dTsBx/Z0iFTnap0OhT6YJkLIKGbqQg/Rww7JDNEu+URoxtbenuEweif+1Xi/1nJdu9nHTRUrJzFyHeudLg8PuqinK1wPTDzymHyf4syt/XQVvgt9KrgSa+fyIogDcG/8JNJBLHayFmBrkMM1mGM7UxvdOkArNfrZRetmWImVwr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(cc Helge)

And please don't post on the Linux kernel mailing lists!

On Thu, Sep 17, 2026 at 04:53:49PM +0800, 758910018 wrote:
> Hi,
> 
> > Since parisc is one of very few architectures that does not call
> > parse_early_param() from setup_arch(), I think an easier fix would be
> > local to parisc.
> 
> Agreed, that is simpler.
> 
> Whether a fix is needed at all depends on the answer to your second
> question.  If hugetlb is not needed on parisc anymore, there is nothing
> left to fix and I will drop this series.  If it stays, I will send v2
> with the change inside parisc's setup_arch(), keeping 2/2 so that the
> same kind of ordering problem would at least show up in the log.
> 
> So I will wait for the parisc maintainers on that one.
> 
> Thanks,
> Zhenghui
> 
> 
> ---Original---
> From: "Mike Rapoport"<rppt@kernel.org>
> Date: Thu, Sep 17, 2026 15:41 PM
> To: "Zhenghui Hao"<zhenghui.hao@qq.com>;
> Cc: "Andrew Morton"<akpm@linux-foundation.org>;"linux-mm"<linux-mm@kvack.org>;
> "linux-parisc"<linux-parisc@vger.kernel.org>;"linux-kernel"
> <linux-kernel@vger.kernel.org>;
> Subject: [PATCH 0/2] init, hugetlb: fix early parameter ordering
> 
> Hi,
> 
> On 2026-09-17 14:55 +0800, Zhenghui Hao wrote:
> > hugetlb records its command line parameters from early_param()
> > handlers and consumes them later from hugetlb_bootmem_alloc().
> > 
> > Commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
> > zones and memory map") moved that consumer into mm_core_init_early(),
> > which runs before the generic parse_early_param() call in
> > start_kernel().  Architectures that call parse_early_param() from
> > setup_arch() are not affected, but on parisc the parameters are then
> > recorded after they have already been consumed and are silently
> > dropped.
> 
> Since parisc is one of very few architectures that does not call
> parse_early_param() from setup_arch(), I think an easier fix would be
> local to parisc.
> 
> And there is another related question more to parisc maintainers: do we
> really need hugetlb on parisc these days?
> 
> > Patch 1/2 moves parse_early_param() before mm_core_init_early(),
> > together with jump_label_init() and static_call_init() so that the
> > "parameters may set static keys" guarantee still holds.
> > 
> > Patch 2/2 makes this class of ordering problem non-silent.  It cannot
> > fire once 1/2 is applied; if you would rather take only the fix,
> > please drop 2/2.
> > 
> > Not tested on parisc hardware.
> > 
> > Zhenghui Hao (2):
> >   init: parse early parameters before memory initialization
> >   hugetlb: report cmdline parameters recorded too late
> > 
> >  init/main.c  |  8 ++++----
> >  mm/hugetlb.c | 14 ++++++++++++++
> >  2 files changed, 18 insertions(+), 4 deletions(-)
> > 
> > 
> > base-commit: 9b87fdc9af2fbfcdb5c24a64139685ef80f6573f
> > -- 
> > 2.53.0
> > 
> > 
> 

-- 
Sincerely yours,
Mike.

