Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4EBBCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 07:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0108E0010; Thu,  4 Sep 2025 03:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060E88E0002; Thu,  4 Sep 2025 03:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFB58E0010; Thu,  4 Sep 2025 03:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB8688E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:19:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 849CF11A927
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:19:38 +0000 (UTC)
X-FDA: 83850717636.28.E657FAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A9AF980004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:19:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RkpRQhtW;
	spf=pass (imf30.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756970376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tb40G1BP2UOmzBv4K9eP2Zzmqp+7E3i2B0tVuKcnrc0=;
	b=PL82SppBCdOCuwyoJVYCT/oDyfZ0FH1fgwvZ9aGCYqlpb5G/ihbC6TlkxprXmag6Hh/Zpk
	C4YxxV4PG4GEO/a4iaM8xv7eK1QE6YFFohYyKz948o4Vcwxl/5TrHOrDCcjKZBYzq9JUwH
	IaA3Z9WOavCJlyUrJX83qdtUS0CcXMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756970376; a=rsa-sha256;
	cv=none;
	b=MCCjHpUtNgGGcxOl/iqjQVWpRGTDICIojnvxuRgjckqRcokRPAyiTD+6MWSmRjb6Yy7kz5
	WU2uNA0pTcktilXhWeEetCiAJtfD/XVTnFafhgMIwDNA1PxootVCRUQ8STmXdDQ7u+ecL4
	rRQMgYaNDbbUcZaVqKIhlfAgo94NiVs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RkpRQhtW;
	spf=pass (imf30.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AECCC6026D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656D8C4CEF9
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756970375;
	bh=72oYlNKXXmAjA5Q5e13+DWrwi/CpM80zljJXvzw63aw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RkpRQhtW+a9Y5lrqRKRhT35FXEw1JPCeIWAQrYQnCH0PzIhHfBAOhG2Y5tMpknarz
	 Pl6vzMh5wTJkjfijbtkfNLawzbNfsDaIq0XFhQ03u1qXSHpsWOyAsewXLQkmGGDpF4
	 g5AZtKvc/NMoBuOSrEYboremIyftnqUZnccdN63+lyYaqC2zXAg1ev7wfVJH2lBPPs
	 JVWLymM+QXBvbXwT51vLAHuB98LJ3hPXoXOI0XidDfDFuhAkXtfKW2uJbzeDUKLK45
	 gu3YhlMYSQbv5cDMx39swAF/M58+EsE1FTxDMYZouqSbCtxD0PLFI34ZU+9r65T2RB
	 b7Av9NcRTOQvQ==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55f69cf4b77so787856e87.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 00:19:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXm3a99DPRUwyKD8eSkd0z6FIpolNhhDAOUl59RPCBS/hqP3ghMOZeBMWTZrPh035EjezRvibhesQ==@kvack.org
X-Gm-Message-State: AOJu0YyC6ujmcAyonH0IyNfhOeJ+Y60LUXvH9Whk44+BhJsEgpJUCPmk
	2DowX+do6stt+heDIrDoZ594K5niJGfVEaseAVItyKizaBxTuBWdQtuUucANyAtbs+vfjOG5f2Z
	bIG97o05jUJ1AEpSB3mF5ozHF+K6Ejok=
X-Google-Smtp-Source: AGHT+IEFvmAnCvfgO7PlnrG1BYUxZTjjsz6BPZ180OOcQw+OkZ+byNbMMbmHC7LJX6qhewccjpN/hH5j8/8g6mEFmZQ=
X-Received: by 2002:a05:6512:239a:b0:560:8d97:8bb8 with SMTP id
 2adb3069b0e04-5608d978cd1mr1413481e87.32.1756970373660; Thu, 04 Sep 2025
 00:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755721529.git.epetron@amazon.de> <b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de>
 <CAMj1kXFQwOHyQg2LtabMA3qxiBn_AVV_JNfki2WPSg8u_XbBcg@mail.gmail.com>
In-Reply-To: <CAMj1kXFQwOHyQg2LtabMA3qxiBn_AVV_JNfki2WPSg8u_XbBcg@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 4 Sep 2025 09:19:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFzKzpoqczq7Rk-u+kKLFO057XEXMD+KM=iRMMsoUZbJA@mail.gmail.com>
X-Gm-Features: Ac12FXzg-Gwf5w9Dkz74akKGMbsagt1QMuLWSxeot3bSIi-D7R24FEVq60rM11k
Message-ID: <CAMj1kXFzKzpoqczq7Rk-u+kKLFO057XEXMD+KM=iRMMsoUZbJA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] efi: Support booting with kexec handover (KHO)
To: Evangelos Petrongonas <epetron@amazon.de>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Changyuan Lyu <changyuanl@google.com>, Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9AF980004
X-Stat-Signature: gs4tnct3qnu8mayoxpayz7pz3wjc4oud
X-Rspam-User: 
X-HE-Tag: 1756970376-332574
X-HE-Meta: U2FsdGVkX19I19kT0OCh7/wAeu+gCBeJqcs4BKpjVBBbO+/cNP5duYN6he8q5NnLTJJLC+z8TTPl0hI5aXWJSoKusXXnDjVklLHoI1xQ1y+ve8XiDwX3Y+2lCcD66M0nnWuXW7H8vMESp5ejFFzXFbIiQMjf+/osM5k9CKnk9dlWr2yrxNVzqUi1Hc6+e2NhIxZgGSpSbn1HaKy9Hn7xiPwhEmb8hRaCZnZTgbADLu2zopCQ5IEV1h27ccKuUiOoeYvAky0LFNudcbyu/rx9O3cXieT1hH6wEMCVTZ4WGgqqFglrHPUjAOzt+W9sM16/MWH6xWqjMOGdsSR/SYFiMsYFG43PNo4mi6TfhSpEZ1UGVyrW8vbXAOuYx9W9SFHUGOuCflfX3kQvt7BKghRf+Amrq2UDe1VJIy6uq7RhZrZuCiJ46/Y555oKhKM3Lc0hymPScvfrrAifyjXbZu4JFbtQx4Sue3h+ZmQ10yqSuW1wy1laOTC48CwfzZ7708XZDYcWW8FeWeZeHbAa41HzM4Swn0aWMiEMJ2WN4HmXCTPlV+7zK7xDrQ/wv/kEBwCr7qsaN+2Tfm3blXnWzNNQqQkxlV9JLou5Cztxfa7d4jBO1p9zgV155GgRVPaKBc0PUxfmCjfdJ8cw265VqMG5e0YwceSKlQSrkWdvabrnRyM3n/vMUOdw7qnb9zpDQwCDnHM0RcsBbVg3W14n8fwsGw/VTPcZ+X5FZHzQto63spaS/d5KzI54TvVCp1q5sboYj4+N4HOGK5bk5a/6Fjx/8xjaDNu8U3omxTqhMz2HV69bdWXBYMzi2GhljcTIGbH3aRkf4BYnqlrW4RC8WLOtucJNNWHkLLyMkz5fo45aa+PevRUKAsF0UyggUfsYKZrs2cRoFVw0jk2CYJlVlqTBWHxczYinR/3i/tN0XaHTl7lgljtyIg2NinFamRVqRV5oMZls0v16uG10aKwV18x
 iUfeq/Ka
 osvA/lNXKbFLYvC6KYHE/BiB2aHi9RYO4c4qRk06XkEngZgKpZfA0Fmc6+AkuwFx/8KROI67x9/bai+4cm+dkiu1U/70kLqXmLCrjvE+J4yELzEc0R1urI3alLlmVQjqFQFlxQOiuk0MUTs3e+s5qvn7uVatU2oBZc2z6GdoSDWoE8//ILn8yBe9S18e9kW6Vg7SbiD/jtuT6q8aIl/PkmM7Guq17wbMT7mJh15OoIdBdwMOJ5fM109naXg3Zf9y4jdMarsxOiEkMLg3jq6mOSqzfHGDKwt4SssJszDxLu9d7KLUNd97lFo4owQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 Aug 2025 at 23:47, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> (cc Ilias)
>
> Note to akpm: please drop this series for now.
>
> On Fri, 22 Aug 2025 at 04:00, Evangelos Petrongonas <epetron@amazon.de> wrote:
> >
> > When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
> > early during device tree scanning. After kexec, the new kernel
> > exclusively uses this region for memory allocations during boot up to
> > the initialization of the page allocator
> >
> > However, when booting with EFI, EFI's reserve_regions() uses
> > memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
> > rebuilding them from EFI data. This destroys KHO scratch regions and
> > their flags, thus causing a kernel panic, as there are no scratch
> > memory regions.
> >
> > Instead of wholesale removal, iterate through memory regions and only
> > remove non-KHO ones. This preserves KHO scratch regions, which are
> > good known memory, while still allowing EFI to rebuild its memory map.
> >
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> > ---
> > Changes in v3:
> >         - Improve the code comments, by stating that the scratch regions are
> >         good known memory
> >
> > Changes in v2:
> >         - Replace the for loop with for_each_mem_region
> >         - Fix comment indentation
> >         - Amend commit message to specify that scratch regions
> >         are known good regions
> >
> >  drivers/firmware/efi/efi-init.c | 29 +++++++++++++++++++++++++----
> >  1 file changed, 25 insertions(+), 4 deletions(-)
> >
>
> I'd rather drop the memblock_remove() entirely if possible. Could we
> get some insight into whether memblocks are generally already
> populated at this point during the boot?
>
>

Ping?

