Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16284F53D8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C33A6B036D; Mon, 16 Mar 2026 15:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770316B036E; Mon, 16 Mar 2026 15:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7866B036F; Mon, 16 Mar 2026 15:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CA076B036D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:32:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBDD61C70C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:32:45 +0000 (UTC)
X-FDA: 84552923490.21.56C60FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 12C4A40012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:32:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZGwW5gmw;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773689564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQ2PBpZLjOnG+36hcR45Lu/bd3nxakqhjdS5/SnOMWo=;
	b=MMk1CdQUWzxGd84dlphEpfwWM1GBZ//tiCMv8wSTPw2aOYqlBMq5UNGXtWUPdQ6k44ZFig
	Vlxf9OP8NJ/07jSmYewd/8XwsHLuVDLM1VVzS8JoITxmbmU1acG+WHe43iUz4He/44fh0e
	4mLrAShTWW0rghkDmK+qCa/Yl+E3ltc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZGwW5gmw;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773689564; a=rsa-sha256;
	cv=none;
	b=wvKkSEOTR9Mg4EEZYLf3ZGBaPpatUKNkBYtU4Pv7AVW93iZZNX092fPcfolaZ0SXu9ULVX
	5VCZLqIJi/Sum4QwRVi8cbV09yYH6b0KzKlcePzBlb9xFbGzknUAiG9Ed0uDdBluDptCN2
	NQP2B4nofwx47ZqJzXMvEowJqgi0npY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1739543FF9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE1AC2BCAF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773689563;
	bh=AQ2PBpZLjOnG+36hcR45Lu/bd3nxakqhjdS5/SnOMWo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZGwW5gmwLxWevflSFCiYt5yOMfrZtSSHh9iTOErVT78YLvHi0NvU8A0Ww+xAhj+rE
	 KBlLJGbndyS5IGeTvYcxDfksobWSw4+DYNjSgPrnvrV59S4uaG2k5JQmEp1rP89qtw
	 wyHVf5bhFdwUH/TkHKum2px+9yPIYRhOlPHwH2l/CG7QiZbl8StvLOdgULRsY05pNQ
	 AvETLayV6x9ICVWqO/m/k1wTEW7DSLhNcMqYVGn+FTZizjO1AAHpus6IXGqpov0A+W
	 5+FksieVQsd0EiyoPdgQrjhpClJCMXuHajOtwo1846FpoCLeG/Z8LMlJV4dKRWGmDi
	 gkLipQbL/fvOg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b955351e0a6so790525966b.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:32:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW2BQrcBr26D0aHsiWaCZaT+kLectKPMg5ZzPaRYv1rL/Q0wk5n7aX4u0sV2V3v7QwUL+kLUQys4w==@kvack.org
X-Gm-Message-State: AOJu0YwYkY+fEzLOFkpxooPyD8JfwXPnywQC9bXqACWLtPibtoi1Cn0y
	ZSTj9S2rTAUBTGw2Vvg95DqPRpAuYufSfcZPBQpo3B1jq9Xct42R+oXFMmSchCFZFSbtmaapF1P
	ARUtU6+gh+85h+eTjJjXM4+YkfcbYO7Q=
X-Received: by 2002:a17:907:7253:b0:b94:19ca:ebbe with SMTP id
 a640c23a62f3a-b97650fa5acmr968564066b.29.1773689561806; Mon, 16 Mar 2026
 12:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
 <abgbx0YXbxu2mAHU@google.com> <CACpmpoeo0LhxkoA5Wx6q+9=2scn_az0u=3bar-JgBvTA-ZBkZg@mail.gmail.com>
 <CAO9r8zPR+Sbo9erKEn_qFG4GXBbSd4EJCmtBYRfV8Qvuh5262Q@mail.gmail.com>
 <CACpmpodvy8wrSNQcSPn_koA=O+MM30U=T4p6Yr6Dkr8R8WsnQw@mail.gmail.com>
 <CAO9r8zNGKR4R+Y2gZrevtyan5G-9Dc96aYTUHrgv8b=3V_RKMA@mail.gmail.com> <CACpmpodX-EqcS6e83W82YtSnRmFhbF6Evgaot3deqAVGFeV24w@mail.gmail.com>
In-Reply-To: <CACpmpodX-EqcS6e83W82YtSnRmFhbF6Evgaot3deqAVGFeV24w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 16 Mar 2026 12:32:28 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPkzru3NeO6fcGqecFVH5N2gwVhkYL7Qw=0dvOrpU3AEQ@mail.gmail.com>
X-Gm-Features: AaiRm50wcsXOKc76NErMnoVbxT8gIwGx2Y6bZwEiYTVzRle9MBUmykUUTnGNdWU
Message-ID: <CAO9r8zPkzru3NeO6fcGqecFVH5N2gwVhkYL7Qw=0dvOrpU3AEQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rrhx67kn7hduxzw5ej38dgka7ixi67wp
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 12C4A40012
X-HE-Tag: 1773689563-194236
X-HE-Meta: U2FsdGVkX1+2PE22Z/9jpM15+bsnpNmHFuHN2uHvDBuSpy+VIc79T6e8b3NyFHyC1I+4c1eYgKMq4rL8+h5HZYQuVFTnigdacHVGP4HGNyFOi3ur3wtg6jO/jPHeGa/dFTrV9hZ3uElWn7+2R6AtyK/Lsf4QPP0rf9YA+bIarCnfmxIZR6C6ZAsE2n8Yb7xhMgvb/OjNAPAU2m0am7dclXvpxkpOFSmGZfFCvNVXExxfC/jpP2QXGAiFgsCNw4X/8FYPcfjonoENx19a8qrUhDmwMEuTd9N2/rYhe0Ser1cRuwXNnbBK1QoPYumVRscFLDObp9T0SKD1x35afJGtdB2oz04sDPQVWJI9FDGj4/FwHohxxieFK1qCWgN8V0sRQ0jF22182pTwaqw2Ef9EvXlqzBsHlYVssSnMOT0vFPKownAfusoyE/pM8+tCMMPekSq/YB8HHqGJbzvgDq7MSLRH159giMzuMPuSIqhvl2z7FlvZmi/aHYrFO+eYLnTZxS1qgHpXaMjSgORKsSuI0bCM2rKMaoSfX0ApdM/f0RUgdSW9aBx0HAey7xQJSs1peXmwIsjHVSvfpXNhfVhqY/kJKmZjk3Gc7ryUf7eLCO89D+Ly3m5Ngq9aoISMZ0xlqz8PBI89XXAdrlnc4Ghbm4D1C/MjxYclMFr09XOIlBnzbej86TiSq7mX3ItHde8L3fDdbSwSHTFwlnxFCpldCMbbEpzOwOqu9q5FvWHTlq8NtLltU1k5W+pZFhM3r/59vnVRIBCiq26RAMyLqxbf15tD4CkGIuuZi3nPfeQhK1yB6EGwkAJxiMYchyLi2QjNBu49YevSbK15JPcuCndkvtSNCrMBp6Ajqt/LL83GXUsXkCOPZJflE/05eWY6btni7AJfLr7LgHgO8ChM/4x4zndFRzh6uqEyw7KVIaosDsITXIkkdn+RVBsriSxzdmqWFwgIwJWEPDZUbqv6J/I
 60rDhbeS
 g9e1TR88KYBEtOBm7Et4lptOMczlAg4e7PtHblO/1yHuZdZIRPlpsjRKwJhYADUe49ymnMW23EYWqDpWAK4f0qW8gplOQWMFFarXwuBX3vrC2kM4JPOzVK1E3IeGMaJTG1ZWRDsohur02uaHSS+Dk1pRRAPuxQpIYeI6r2hEpGK7gqfCUBoxU+XF+S5SUiiwFvU950RsM1VFSd3rDUo/YAkeMqpGvVX46kqBUMDwy/L4LRjgIvVS5zXTHUgs0c7/Pkxk8ImVUdScKWZCKtyr3BLudD3slvHiXBICtNZ7MgXv3h/w+kWYUJePaS2cWqvI9B3H1QDBVDB1QrjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > Actually looking at zswap_cpu_comp_dead(), is the IS_ERR_OR_NULL()
> > > > check on acomp_ctx also misleading? Should that also just be a NULL
> > > > check?
> > >
> > > Even a NULL check would be redundant in this case, per my
> > > understanding, because if the alloc_percpu() call in
> > > zswap_pool_create() had failed, pool creation would have failed.
> > >
> > > I think a NULL check on the acomp_ctx would still be a good idea, just
> > > in case, since this is all part of CPU hotplug. I agree, we don't need
> > > an IS_ERR() check on acomp_ctx.
> >
> > So I think we do one patch to convert both IS_ERR_OR_NULL() to NULL
> > checks, and then the current patch 1, right?
>
> Yes.

Sounds good, thanks for bearing with me :)

