Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5736BCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 19:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5376B0005; Thu, 11 Sep 2025 15:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CD36B0008; Thu, 11 Sep 2025 15:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793508E0001; Thu, 11 Sep 2025 15:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66AA56B0005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:04:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09EF71DE6FA
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:04:27 +0000 (UTC)
X-FDA: 83877895374.09.C112E85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2BCACA0016
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:04:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgJmdhFv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757617465; a=rsa-sha256;
	cv=none;
	b=CM/U7zHKd0eSFMh3TYd+u0gsWn5hs2pVvcBRcguGSnme5oOfk4E3tyyEw7ESxapAI3GCQx
	Lo0Sjf65y3UAlJiaXSC3mcjvIXyUSqNWMrFBmA4gc19gQvyQbloJG69R8OiZwHJJ6fp9En
	Sj5ns6dstFTQbDDUIZPTh+jb5epZxOs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgJmdhFv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757617465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KS/GQZvKohxF2dXOoetjc+Srv9VGnubroIDx6lMqSUI=;
	b=O9NZmDILF1KKEyVgxgcHVxQM6VuIdBo1QnIuCEGjdmwhRsM+FFGWo41l8PDhbrpztWXMqu
	NPDLP62s/p3kXxpxfyt/9W0Uf9NhIJ7AIWKmS8MYs8xHnAQnZNlt1OW4spxrpSewjLz/aM
	ArgZW4kaWEorCVQEyfR0F2zOqHBzIMk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B91394177A;
	Thu, 11 Sep 2025 19:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C146C4CEF0;
	Thu, 11 Sep 2025 19:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757617463;
	bh=rAkxJv/3foIdEfVT/80z5+2GaTUuEqXXoELt3KTULG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NgJmdhFvffaNkMSKeLoRpu+BnvJeOxJacaNKJSvtWNB1ifuG1HbrVSUULpPk+HQTF
	 okO7XR2T2wbnFk5b984nMc3a+aawQ7vgfYEdNW9JXoRJsq1CSz9U4Nu5zaLWmLy1RA
	 YwQldVWYU9cZZpA9+abgE4xT0KNL/Tuvr4RMb/CQoN8XNEl3mBRPj6/z3lNeH+lJqR
	 GO5W3DaTKfRg0oXV4gSl8J4aZN/GKze3RboCNWE+38ZCoQE16qhsbxhCVYZqfBuub5
	 GlVDqhyoovt7YtbvdcWqnkTAFI9ruXz7XSXrymPM0p/SIwPWNBRdcPJjKqUuGvJzt8
	 OxbFMrs3ZEXwA==
Date: Thu, 11 Sep 2025 12:03:02 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com,
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Message-ID: <20250911190302.GF1376@sol>
References: <20250829164500.324329-1-ebiggers@kernel.org>
 <20250910194921.GA3153735@google.com>
 <CAG_fn=W_7o6ANs94GwoYjyjvY5kSFYHB6DwfE+oXM7TP1eP5dw@mail.gmail.com>
 <20250911175145.GA1376@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250911175145.GA1376@sol>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2BCACA0016
X-Stat-Signature: 9gyjn1mtzyo4a3ek48ag4o3k6gcjz7uf
X-Rspam-User: 
X-HE-Tag: 1757617464-427487
X-HE-Meta: U2FsdGVkX1/y/Z8DsccVUPyYypXejFyxi+MEfpyCARx88FD5IRlEw0N1Lk/reKU8EK8IvjX1gwxzmlyr7htWs2opYQedZi5B3R8QKJ9QVV4TZ9kW975Ei1jNQIqI+Zrcm6CylvZfjRKhyJc6l6PZY3U1e8+yjHDDiMZQ4Wf5lxJHFbpq2rCrM8rPGqgvj45kHv2GaqdBMrefxszUseWMcnShtD75/eKUQeSTMj2YiX1w9rBi0E0pW7VsnRqeiuZH/wCk3zx8FWkL4ImIMEQdUcQmLjItECZFp6bIGnoeBzPQ8dqpC4fMyB59wXMiRcHhVC2+fvCleXH53p394QO9U/EVEXWDUCHn3nVL9R1svNyvaVRipeVaSjOZ+5XbfWvEJ1g9L5dGJuDUE2z2bAqceHkZMUrOJ3vpsVbR0B/u+0z1uVBv5zfojYUyN7NtCC6wwfWdqk2ft1o05hZW7va80egGT5jTpiveR2+XI25WygusUv0Y57a1xrhD6kIXUdtq87w/j2YWqmoZAeLix8pNA7pIpVrkTIgBss/Y5N6GGyqX6qwg9/HgMSUlyutN0GNLA9uoZ3W6GfCPUonepjuzpJwuxACQMNxt5qWKE4zk7ffaV9HqM8fqUKVExfK+c4tije8JVDTy6kwPg53n0uk2DB+5W0QbpZI2B7TyhAJfpL5YUlRBd/BXipav0aBTB4UhjHETlNfVT7lvrGdp6mC1wTma4FxE3HEcpA8yhBDuLQHFGjXfAWC+GAYER0X3bYr5mh0DGO/4Ud+4QT+7sBb1ZSGHjjYjyXjHiPLSozyYem1nE8OcRH4ifYzJVGGFJSo6KI14pZsj0RLC4w612nh8k+8K6JxXJaNdq4GEzxwo7MCRO4ezTQUQ7AxMtueQKZ45IaqED7HFJbe5kLuNm8vCHcGkalwXfNJFoEf5B5Bfa12vMpRjNSDLD16hKyrbzjj3yZMklQBHXbio12GgMJ0
 ianjpm4x
 GB7zM6seYGJE2IuxBmXb33fcxGVQgKRBaPicyeHWxvxDiwSyl3jfAJ/Nq/B9pu8Vlw1WRUAQvs+x7QstX+vui70Vc3RYMpCvqptebb6WHIJVgmWPpyP4yAzPoly6P0PnosJhqwXI0ua8018P1Su2RIthiWGtZdvbumJw3VYicpt68DnDDYZRahRyMwS1IIjnhHOeBcXcDS+L5YWHRZC5hF16QgTpfIunEHkzysuWaFv0t9unAgD14iyrdhxFfv5V+o718nkqhg+XC2VPmglMwAcBoHnCA0/kwF/qBUJ7uCukyL7SwAZaCY3L/PDcZIoyVXZr4YowLirQNlBJULBkdzEpfGd/gIno6Ep+N8Qd50Z74gPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:51:45AM -0700, Eric Biggers wrote:
> On Thu, Sep 11, 2025 at 11:09:17AM +0200, Alexander Potapenko wrote:
> > On Wed, Sep 10, 2025 at 9:49 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> > > > Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> > > > kmsan_internal_set_shadow_origin():
> > > >
> > > >     BUG: unable to handle page fault for address: ffffbc3840291000
> > > >     #PF: supervisor read access in kernel mode
> > > >     #PF: error_code(0x0000) - not-present page
> > > >     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
> > > >     Oops: 0000 [#1] SMP NOPTI
> > > >     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
> > > >     Tainted: [N]=TEST
> > > >     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> > > >     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
> > > >     [...]
> > > >     Call Trace:
> > > >     <TASK>
> > > >     __msan_memset+0xee/0x1a0
> > > >     sha224_final+0x9e/0x350
> > > >     test_hash_buffer_overruns+0x46f/0x5f0
> > > >     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
> > > >     ? __pfx_test_hash_buffer_overruns+0x10/0x10
> > > >     kunit_try_run_case+0x198/0xa00
> > >
> > > Any thoughts on this patch from the KMSAN folks?  I'd love to add
> > > CONFIG_KMSAN=y to my crypto subsystem testing, but unfortunately the
> > > kernel crashes due to this bug :-(
> > >
> > > - Eric
> > 
> > Sorry, I was out in August and missed this email when digging through my inbox.
> > 
> > Curiously, I couldn't find any relevant crashes on the KMSAN syzbot
> > instance, but the issue is legit.
> > Thank you so much for fixing this!
> > 
> > Any chance you can add a test case for it to mm/kmsan/kmsan_test.c?
> 
> Unfortunately most of the KMSAN test cases already fail on upstream,
> which makes it difficult to develop new ones:

The KMSAN test failures bisect to the following commit:

    commit f90b474a35744b5d43009e4fab232e74a3024cae
    Author: Vlastimil Babka <vbabka@suse.cz>
    Date:   Mon Mar 10 13:40:17 2025 +0100

        mm: Fix the flipped condition in gfpflags_allow_spinning()

I'm not sure why.  Apparently something related to lib/stackdepot.c.

Reverting that commit on top of upstream fixes the KMSAN tests.

- Eric

