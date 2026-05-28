Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4214CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 06:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433EC6B0005; Thu, 28 May 2026 02:15:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E52C6B008C; Thu, 28 May 2026 02:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3506B0096; Thu, 28 May 2026 02:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 184116B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:15:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6DDB1C1F71
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:15:15 +0000 (UTC)
X-FDA: 84815816190.12.FAD002A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CAE50100005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:15:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a1PiQ5PN;
	spf=pass (imf05.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779948913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRKrhgIJK76DvhKc8lDcKP3ib2MuR8el2Ira7SHuRmM=;
	b=P3fTPHsq5q6wuQUCqkgKGWKH65pB742KJT7UmiU1K+8YcFFbfhozueUJ4N50fFoyOmE5sE
	K8bORNpsR9K0K7EDdbGT7lhGvshCEM9RcdSS1epH1dCl/5ky5+XfRyd5rkIr6yEkXQIRGE
	mqSvVeFbqR1f9lmMcvjnCizX7eJrfEc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a1PiQ5PN;
	spf=pass (imf05.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779948913; a=rsa-sha256;
	cv=none;
	b=C2QlyhQIClB8ySofWKs5ypwvmcIyB3P+bU/AvqZ25Ou6hM2mt9u9Cioabf1U4cXVncrXQl
	wBIq4Kv1SEJ4phDrSfPH4/tcna7/Lo41EhpV8bXxnXy2C+0NiYf5vShTWfh7rOku8pcwf5
	REadpz4zUF7dvl1hjbyssvcd5U+9NSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05408401F5;
	Thu, 28 May 2026 06:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A541F000E9;
	Thu, 28 May 2026 06:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779948912;
	bh=sRKrhgIJK76DvhKc8lDcKP3ib2MuR8el2Ira7SHuRmM=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=a1PiQ5PNbkQnWnC30lpTKTrwQYadp2w2p0U8B2MzUZ5lWlCEg0QyM8AMQpzycZygv
	 FvaONnp6/lnAoptcCj+C4fhPqVxWAHoPwlT2PsIAhUY7XxdXfxfB7r0gxJ/EkklHqh
	 U5ndV9vAuvynZvJxFqWjKIjjunTWrj5iQNfFfCbCVeDwjPS+jZvG6up2mqiawURVp1
	 10h8wkyHeYvVGogUukL9e+Tvhycvo9j0HJvcM0FO4shNmUGfNCdJHV4IA//H0sJ6Ur
	 z6ppWdUCbsjcN346iIBfcyHHa989xSLwor4KttyXLXjlad1+MJkD93DFKd1s+u05h5
	 GEt+TdRSegiSA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 16194F40079;
	Thu, 28 May 2026 02:15:11 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Thu, 28 May 2026 02:15:11 -0400
X-ME-Sender: <xms:bt0XajrytHanjxs_yj4VHOwSDlHzRL5SxpDAUSIT9g1uf-cLrEA6lw>
    <xme:bt0XaocSspHV73k8Rh0IljsG_YTbMQa0gYuD9E_9_B8B1jrErRuGPwms96rNTuWq8
    _f0Da94NGpalCFrHr12MT4ht7GSnQ07fFTPsZ4uPU-sNIzBCSjiEK4>
X-ME-Proxy-Cause: dmFkZTFYpebslvMFokJoFBZEvhS0RRgsf2rUv7/D81FLAhtEAxXQxJWExaQNrYQvlunXOY
    BzXZlDOzIwICfsvp+wnolkeo3xWaLn/+d/N1LoUHlWUfIIXpugElRdYZZhTKKZLx2NpaJJ
    PyWtUJneOFaEFjJXOZDovXcM+hcpCMkINXksgmiCh7FrU123DTD0mHWjBUvKOYhD8/JeTN
    TgPCJc7dtiYEtEx5zWv39oFWvBCiqMAXb7+6RwUz8fhWr3X8lIaHUIuBBnsPFiQvXo+j77
    IGXF3FavQsXan91HQUIjAEhEyd81hdiEOEQ6SWdmeeaV3xzlrbmsV5pyW87rxFO1TjRYav
    e5AhKyOc6w3NP2RJAbo6/Tvbd2Rovf/EbsfYc68imA924zqCOVWKi2MaPL5udgbalieRsA
    M/2Nqck6HrqAjYKDfE8dPO+thC/pusJd1m1kFl1hUMvXnbBzG6J0BR34+LSR0y1Tvrl2+B
    uxLxG3/KyN+eD08+3YAizm1p6ZaI8JM/3kES/5hVqTZUNaQnVyEpq1aF8mkaWJh0yN0R+O
    gF5o6cRko4vpi2DVE4lbi6sZ7pZSVT/Uil+xYbx06cpSUDfB9YPcSHustlMlrkIsF06PpB
    /0BqrViHB5NhSI7arFBkuGzWRFGbbY6KrbjEkCFwH78CDaDP+qSFu/R6R54g
X-ME-Proxy: <xmx:b90Xajr8S2ObbLDSohOd1_NPqRrPN5O1PNGuPqEpeC6IyTrIIQBCew>
    <xmx:b90Xaih0v199Mz6FRRhghaPgNUlTmWrXGttHjyt7rYw7bBsx7Hd0sg>
    <xmx:b90Xatx17OOg_OzLbvS1_aiB5T4_yiHY60aHTVCuxr28PCooE6xK3g>
    <xmx:b90Xao-mBPm8n5JsUbMvYRNM9JTvpVNBmiqte0PcOEG4yaJ8VeEiJw>
    <xmx:b90XaiC-u174RWXUQ5rTVkL4hh4sjD_5HdRLN_Xj-bbWaR1FoLJbAAXi>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E26E4182007A; Thu, 28 May 2026 02:15:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Thu, 28 May 2026 08:14:50 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 "Will Deacon" <will@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Jann Horn" <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
 "Yoshinori Sato" <ysato@users.sourceforge.jp>,
 "Rich Felker" <dalias@libc.org>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>
Message-Id: <87fbe311-5657-4e36-8a33-7404980a9df6@app.fastmail.com>
In-Reply-To: <ahfWnLIwZXJvbvNg@kernel.org>
References: <20260526175846.2694125-17-ardb+git@google.com>
 <20260526175846.2694125-30-ardb+git@google.com> <ahfWnLIwZXJvbvNg@kernel.org>
Subject: Re: [PATCH v6 13/15] sh: cast away constness from the zero page when flushing
 it from the cache
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4ghosdnk64mpzth41oz3u9h1697t9uwa
X-Rspamd-Queue-Id: CAE50100005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779948913-847825
X-HE-Meta: U2FsdGVkX1+7f6jPPObbtcLakm0oSgVTvR8dWm/ItruHTFEjjJrY3lKiF+RYdMaSTsKGv4WjbiyrV4l6+MvpVcWzKmMUfP2a5aU1c13bJ+2TkHOd8N0hrNsdYmzU0QN7Myvyu6bsEKB2bc1KCV2O55w3/r8CATCJPUJw7Dpiqm8VQcfUlWnfFdpAhPRv/WetrjI/QAmoxiVvf0KO0KTRAuVHplzDp8GcZPfaW/ZqUDYz35yP3Io00+BxCjSg1EJIIRwGmWU+nVDrZRvkNzlFBS8GxWsaLTsWwkjYc7uXtNXJWHvcHTFuccjPaV/x1O+4hOQC1ecoc7OxxFOGSMI//WrjQr3sjcIKhyIKtJ3Pv593XDEFbu1zNyzdZw2ggRbhCrCR8fAjNZv4FkgBwk5A5JKt4NpEP/hlSLDxdCriapIlMlLVi1Stper9ZfSkrDUVMpW8qGvke4BSXkIFl4nhF7XB+psilz0U6P0hCxnj8ivSGFOgeDKSOsx4J4VYHlnJ58gFv9MxSx5D0B9UTGQOQeElHjA8BC6/K3M8JfyozdCqNzLCohEdngQRMCFxDF5lSioDZJoYWSiLGrU0n8tywjGRb+bLws+yLi0LV+Ip88EpyGBD9GNAPn+bFzexlU9e7FSBPhNx9sdgzBtut278fCAcGAWCXTxmqE1IvTXwGIN5rtm8G18Vjjtos3JKoMfJijrqqWmejSSN0T23kiRXFN+M3dhNI8cUcLKQSghFpCf2kaTF72R4DSkVA13oZAWUoW6gtry2XDYZjYGGAEJqtFJFMNWumVd6y2i+dOxSJE7LIUQDnxfz1F4FXY3AX7Jo6AF0/dF8J7B80iUWpxbdKMfPVSRlxZrf3lzezzyY7CbuDJ8yyhCGw4jLhYNCLdupoiGWlD6Uzx/o2vwK2zQXrEAdSiH+DY1Nb+xLppM8aFLL4MZZbrGb9vK3rmjnp93eHGpbdC0PrRAU6jDdFbA
 i4uYbKuw
 kowt8W1wi/I3aTgXdNZcML2ltil/M+vEZSQ5M5Xmz05tQzog8mv4O2PHdvk8u/qEa4HRte/1mFPi6KklQmE6RcKc8OaljRQccbu2PcdxDHcYfDqxrsBjZCsUvREy87NIrOYkqwy6dPMEb9Hc9sAz3Ilx6mKDetR1IrhCpieKzSr2WeWscBKzHX2xDAT+Fv+S29Q4qWeWDwmB9iqJ2JyyGi51M3FNubl9sZv6C4Hg02xCY66e7gNyB7HbOQDqOu4KGNqk7MSoY1TSPFL1apa1TWWkKUx90JqbTUHakaDhf/5ou+CQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Thu, 28 May 2026, at 07:46, Mike Rapoport wrote:
> On Tue, May 26, 2026 at 07:59:00PM +0200, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> SH performs cache maintenance on the zero page during boot, presumably
>> to ensure that any clearing of BSS that has occurred at startup is
>> visible to other CPUs and DMA devices.
>
> It flushes the cache there because before 6215d9f4470f ("arch, mm:
> consolidate empty_zero_page") empty_zero_page used was for boot parameters
> at the very early boot.
>
> I removed memset(empty_zero_page, 0, PAGE_SIZE) that was a line above but
> missed the cache flush. 
>
> This whole "clear zero-page" can be removed IMO.
> 

Good point.

