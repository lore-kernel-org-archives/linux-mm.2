Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0672BFB44C6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B41D6B0005; Fri, 24 Apr 2026 03:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464EE6B008A; Fri, 24 Apr 2026 03:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 353296B008C; Fri, 24 Apr 2026 03:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 211FF6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:40:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD095160848
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:40:21 +0000 (UTC)
X-FDA: 84692651442.27.BDF13FB
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id B91BC140002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:40:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Rrqqq9wE;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777016419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m0VAcz4ATYMH/1d/fpzj1hGVPWyeDCA2hnjINcATRss=;
	b=Bpqd64qpObntym5dGw2vc4K8ugib2lHp2vaADouiePdt2TqOeJZrM9obXuywEhaVTS2wfT
	45y5VO9P2eay8bmDVHQUNar/zBT2G9ZrNG+i9F9FaLBCqt+dr/yRCixh10bp38uKuiB9nu
	pNZffOOeuoQ+L+SJRMleoFQ3r8Ro6VI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Rrqqq9wE;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777016419; a=rsa-sha256;
	cv=none;
	b=3cPdVMXFv2fCHYuAhV6ZIkcls0exnefGHIqymotA7wF0e6P+Ad2z4j+3peItBQifE7PLJj
	Ksplhvw+5smiGlmwkJYEyVwRNNW8LeKWDsRQsFE+9ywoSJTL9/1xXNjeDHP2+Zo9TrNyIN
	yBfTjBGewOlkVDsMQl2cS7FtcLEopGk=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-441209fb77eso2697902f8f.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777016418; x=1777621218; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m0VAcz4ATYMH/1d/fpzj1hGVPWyeDCA2hnjINcATRss=;
        b=Rrqqq9wEA7NgDDFW/9V3qCaYDM5ubrVw9znCWlxaflJ/7ujAt8UAb3R9hIM57IvwyE
         jYbB5ploQDaT146zh1g8nE8J3Cd1DlVSEtAbkyrXjoH/ksCxegaKXpcu27V5YNhupMBB
         +TNIhlGlJnNV2VBXROwmp1HDRIul3NQBm0rA1fjJquLCrc5j0IcvArFarS0FMPiP16yG
         hUJPXwaqu5EoUD7ngLpbyPhUwjzJshsXlk6DUIj5xHxBLWX795YtbZGLlv2nsZ1x2KLI
         M+V5mrqhcJ4ttMCAdgGC5qoIlGDWOPZZjkPBI4cOdH99QaluhlR8CJJBhcY9XLLNjH7b
         zmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777016418; x=1777621218;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m0VAcz4ATYMH/1d/fpzj1hGVPWyeDCA2hnjINcATRss=;
        b=czgqygT88pVmyzOdhFGxwm4Jq0XorPcqXO4v2HakfCOlvx1GPb6wFuQQVZuVoYXEDF
         sIo++y1ZCeSpr1ANC+GVaREagftfUtKIsxURiMfyXqRPaEp7g85zHRcBIs6O8zcPOMa6
         1DXpr9c+ZvGZhdviIruAK+OzTNqoqfmAK8vMUcgk+LyS42cYdIAIwE/YcZaCqgTsaN33
         Q5sWi93aLuDfQZzrlTAA5TCybsyCCWDUF+UW9MmtfAUQ7gQcgkWdQhEdHY+IgApBYggv
         lbN1+SF2SfcTVJuiFBOPs4yu70HEhsA9eqTbj3QnH5M6z8NAW7JpNfnOZS+0pFVcRfe9
         n3LQ==
X-Forwarded-Encrypted: i=1; AFNElJ8HOig9fDkdza+tKFELVrf86fy4C5i3+6faPf8qRyoTyEddKMnbynSSaiN3PC9y2X/A7jx/JMDb2g==@kvack.org
X-Gm-Message-State: AOJu0YxdHEPcTlkLGbkOUaYWgAeEG8E4PpwvxO2/fd+pZbzCq7rnIE77
	d8jyPI/sV6S6rG0xHUtpD/rMJEogaIkQebcjL1zV4Cidnx7BANEmHivmOOu2wEMUkFc=
X-Gm-Gg: AeBDievZ+Dej324bQEcWFNHqSai83vSPj8c9qWcmqUnO0fALrxMok9KYsgmmURL9T/H
	WzLSblBbAVD4kDh62ENArHt6NEfbB2YLKg+c7NtkM3o6Ohxb6KfgM4qdMAyKlZDnxe9VYXiG418
	2k+p07l2wt5Q3w0PeXWXKlTOaxlyGJ40beusGWPIflDYBsjrkBJyGFE5dtU/2Bj6jIVQCacc0au
	XS0HoIgfmKG2CvYLtrniYfdLe3HXMOgdGBff6O07wnf3zPYkvQ7/ZFDPbgwKvgMGTtlX/8SvxIq
	m0P6cSJY+yXl88IaSVKV86H+uMWrEk1UCciSXQ05qJe049YptFc4Ub4G3ZfE/DUeLJvEY5tLFrY
	p6QRtFY5lWkoGlKICrOJGR9gEKZlTqxuitJpqc3ktJKNnLxb7gaKSO/LcMiM6ogSiczDxiyJS8B
	yW2Oi0bxFPH+TCl4cJX5IEGf6tRpZtKM2TpnRUjk1IxciSog0=
X-Received: by 2002:a05:6000:1866:b0:43c:f257:c706 with SMTP id ffacd0b85a97d-43fe4088c1cmr47698438f8f.23.1777016418081;
        Fri, 24 Apr 2026 00:40:18 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4411c9f4f03sm28444007f8f.1.2026.04.24.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 00:40:17 -0700 (PDT)
Date: Fri, 24 Apr 2026 09:40:16 +0200
From: Michal Hocko <mhocko@suse.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org,
	brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/3] mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aeseYDCBN8MVZe8S@tiehlicka>
References: <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka>
 <aeHRLv834FCAQlQ8@google.com>
 <aeHdGf7XDjvOES1V@tiehlicka>
 <aeagUxlju40rvkYQ@google.com>
 <aenPV9ewKAzRF2Vg@tiehlicka>
 <28c3ae9f-c974-454c-b8ed-ba0ba0a5706d@kernel.org>
 <CAJuCfpEGCvuaQ43W4_bPjpoiYgmEspxV78-U4dkA2bcjfxCyFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEGCvuaQ43W4_bPjpoiYgmEspxV78-U4dkA2bcjfxCyFA@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B91BC140002
X-Stat-Signature: yrdjtmo34rfnz4eoysc1o9axenp4kr1h
X-Rspam-User: 
X-HE-Tag: 1777016419-774752
X-HE-Meta: U2FsdGVkX19p0lrJqG6Pcu/4Bb9FohRFOSrbSB5uXN/D5Jq7AP/ppm0Wag55S+i62OUH0C/vvyV/BZSaDaHi4fbH1bT8pDWNua+uUTlBQlCys51PMqNd5+kRKsPLrPghaeaPdWWwJmsC062wgf6EP16uXmaaG+xG1az2I88x60qR2Pvg8S/F6fI0p43h9ka+xDOmOuO/NgjA8hnNbM6hu2s+pMnIGFqcP7G6TQX97La3iM4Lkx32+5wWOhkOCMfMF90Y0TMS/FQGpdz2ZmwoI9nOawG24C6T0Ywtv7VS5t8ykCS19qEW8nY6N3CXUqIMMjFGC7Gmj8iRNZN0kSoOvQLBGW93zliOTDdcn2c/apw3f2rovh8BxxBCh3/fYZlRyCEarnAxtNzd4q8mJdJ9keR1qoOljBN1f5iJIRYJcCrQBhsAk1IWrKuFZw/mE9Uro25uRSZMpoEJiXKHhcHYQ4ayFZ1buabMO+Duc9heJudadqiUDesKorz9zbMWfhkMtIQAhKLwZ1LAuaVmZN58wNx5IULhm/br9ckr9zR9QYKN32Fkk3P6yT+sgU397HIcPfc7LBuppIlLsKSTBwjV8ny+d7ah5VSCTtaD84cxRW2xxC9h3cdm+e1vWGfUpXYr6dCuB4xMWcYbJOilIvkryEdfCCU8+Ifd87OfDnN6xvG7tWUw1iccEa1o+N5PtahqqCAwsfBvKcltbPrqVbxzybkSkKFezUATg1z1fHBCItgFWhvGHvtDTXrw+XXya5rJv8VzFzpRVGA9/dVfg7tCvX7M4JNcEqrhsZtCqUzFRvBaY09GMWk+KVWqOjRlmEckx9FFvdheT9B+9T/QahaIuIqhF4l7xmfbxx1yWPrLB+/spfOJ73Tdii5xG7mMn8gPaLf7EILdh28HVC+ZKdJRVDOnLMpY6k68t1rne9y4Q38UoK1EKKSLOcqGEbYYe8AmYMFB13iwbb/O3VMImFM
 cL3wczE8
 2T4WQ84hKFMkF+nnQsblm8w0rjlQWgCSKI4/4XwCpHTu9S0ZqTv+wvKFcz4cWlZSqceFuC/91nLX1Su6LSxKcrtRlUe628GLWLxF4wkZyqyX+3uG/ceZQO+rNpOhFDPYePsZm1VquPADFJ5W4wXAlrEKvlcGsUU5TXJbrzRk3fPh4m4y0XBpikAhzHue6kCN8x4Rjg2UnI3J00MTVuhivL3c+8axTI55uEnlY8QnLloBcEgAFhpXsogmSJyptvk9SiSPHFl106kcTgCZcMAQ6t/7zPEhuNn0h55FtOTeur2aRQ0QXLWmPYywvQIZSslktZV4kR5nrbyK3mXrh7QAlBkhYrY/pp529SEVxOIW/9i0L7XW4W/QPeMbCoALlW1SxBB2ad4wP9xvEEUWpBWwQRqs2WMXSgGuZADmKy4lUZ0Zdr9jI0t1e14TGgWe+XDu3X6W8FqNfQSMDqEZIXCN49aGS74Zs384/BBhfJz8tpLKc5Y4CeoCB/aqybvXI7inyiQ5byWpkoMR78pv5PyLbaOnMAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 23-04-26 15:36:57, Suren Baghdasaryan wrote:
> On Thu, Apr 23, 2026 at 2:50 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 4/23/26 09:50, Michal Hocko wrote:
> > > On Mon 20-04-26 14:53:23, Minchan Kim wrote:
> > >> On Fri, Apr 17, 2026 at 09:11:21AM +0200, Michal Hocko wrote:
> > > [...]
> > >>> Yes. All which make sense, really. I am still not convinced about the
> > >>> clean page cache because that just seems like a hack to workaround wrong
> > >>> userspace oom heuristics.
> > >>
> > >> I see it a bit differently. When paltform decides to kill a process
> > >> to free up memory, they want that memory back right away.
> > >>
> > >> So it doesn't make much sense for the kernel to ignore that and leave the clean
> > >> file pages to be picked up slowly by kswapd later.
> > >>
> > >> In some aspects, you can think of LMKD as a more specialized, userspace version
> > >> of kswapd. It has high-level knowledge of process priorities and knows exactly
> > >> which process is safe to kill to get memory instantly. The kernel's kswapd,
> > >> however, operates globally without this specific process-level awareness, which
> > >> makes it less suited for this kind of targeted reclamation.
> > >>
> > >> If we force LMKD to rely on the slower global kswapd to actually free the clean
> > >> pages, it defeats the whole purpose of targeting a specific process.
> > >>
> > >> So letting process_mrelease speed this up isn't a hack at all. It's just helping
> > >> the kernel do what the admin wanted in the first place: fast, targeted memory.
> > >
> > > This is a very creative/disruptive way to do a memory reclaim. From a
> > > user POV I would much rather see clean page cache reclaimed before my
> > > apps start to disappear. But this is obviously your call and your users
> > > that will care.
> > >
> > > Anyway, I still maintain my position. I do not think it is a good
> > > idea to drop clean page cache as you do not know whether there are other
> > > users.
> 
> I'm very much familiar with these issues in Android and really want to
> find a good solution for them. IIUC, this RFC tries to address 2
> things at once:
> 1. handling clean private page cache when reaping memory of a kill victim;
> 2. addressing a race between kill() and process_release() when
> process_release() can't happen before the kill() but if it happens too
> late after the victim passed its exit_mm() then process_release()
> fails to find the mm to reap. This defeats the purpose of
> process_release() call because the actual memory (released by
> exit_mmap()) might not yet be free and a successful process_release()
> would be very beneficial.
> 
> I see these two as separate issues and I'm not sure combining them
> into a single discussion is a good idea.

Fully agreed!

-- 
Michal Hocko
SUSE Labs

