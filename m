Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39015D216A3
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0326B00AB; Thu,  4 Dec 2025 10:56:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797E06B00C1; Thu,  4 Dec 2025 10:56:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE606B00D0; Thu,  4 Dec 2025 10:56:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 568A16B00AB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:56:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D025C02BB
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:56:08 +0000 (UTC)
X-FDA: 84182240016.07.101752F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D4D318000F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:56:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=JGa2TWiu;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764863766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mq0SWl9iyU3yIW6aBSVSxHhPulPqk2disOphQYpPRDg=;
	b=dVG7Bk38NJFhDfszZOXAdVNWPwlwHrfGn2sCXfpoXDlSSlf+VoXESVCqSlOrpGblpz+6iW
	8MDGXjmTOqMzyL0oCf3c5ro2k4KvIiLLVONzfSX3OKfxuV+fbIH49km36WDXKEBJEZIv7W
	2pJAHhZtLkOAWfHkla/bxJLDRBKVCuc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=JGa2TWiu;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764863766; a=rsa-sha256;
	cv=none;
	b=yhlsgs80CbDGrf4O0QjOLIecIOpFJQLAi+OcsMfppTRx7+6W826br1Nepj2R8+t21qnGIT
	97O+K2UCEmwx7lh0y3X24HWem8O3ISKGd9co6N6jzxa5IW+5Q5UzeCcPL4KW+bqYxOs66P
	cqznclJXB6sUOnLPPc2MqCW2eqrSLvY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 200E6440C5;
	Thu,  4 Dec 2025 15:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C05FC4CEFB;
	Thu,  4 Dec 2025 15:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764863765;
	bh=LpA5JefkR0lHR2JO+irqCZhLEXB0ZXT4LnndG7Qv5YI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JGa2TWiuqtx0qfMMAoyzyqOcsomqaHPrwe+cxr9K7pVsX9xsJOm472jN3O+eHBeDO
	 ghhbW0MwOtb1B71vgTaR1yoP3tS8+4xZCa5FzsdvAWjZUUZVYJNFS98DW8OEgUgUAl
	 k7S/KCqxaj6cI6nUM2JyX3oZsLFrsZ1XK62jQaHY=
Date: Thu, 4 Dec 2025 16:56:01 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marco Elver <elver@google.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Message-ID: <2025120431-squishier-cold-8cde@gregkh>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
 <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
 <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
 <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
 <CANpmjNNqCe5TxPriN-=OnS0nqGEYd-ChcZe6HQxwG4LZMuOwdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANpmjNNqCe5TxPriN-=OnS0nqGEYd-ChcZe6HQxwG4LZMuOwdA@mail.gmail.com>
X-Stat-Signature: 79ym7kirp6ubxka7q6qacecncc1zm664
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D4D318000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1764863766-921060
X-HE-Meta: U2FsdGVkX1+L0+ORmxq7jYbzLJWTohdnzTiX3XKpWYLMiVpbaE1SiGHLR6+TfvfctC5Q7s+aefpqgI140NblZyPrP/Dzr+4N5PAwpheq8RptLhOdj7yvwbEpps2vDPGGMHLaWLmXZ3ZlaHzoY5rkThxek88doKicX513ttLyZ9tPO2BFOPQJjLj1u5JzLG6NnC8YOE+eqq8fJD2LoG0XIorYpgwt9jDK96tft0VFSNoJ8i6OkcZ0yP+o+8yvrVVfDaZ6zKBU1q5S4QBnyhffj8R8Xxhg52zXA3NkOeOavoG1eSgtZp9BCxOnQAjUVc+4PRLRi6rp5GXys9xCytFHWgPNcS01tkO1MxEWzamhCsGYkLA373wFKkC/2fshqH6bagIe3/UiOpN90vPxCfJl3ksH+TrFjQMqd9bp4WGrWU0coaAsgdkYBnRLlfnkhmUmAAAsHP2ZtRlDrHNYJKo6Na2/uj2aAdllxvcQRUKMKIiZDezMcoQuOLASQAffBXPBXLpO00HwkuqkyhX6LRqMCji/ipsIMCOCB/iHLZK0mPGvtCL7DLdoeaUgqIVdzxfD5umkAg/urnyvjW8GCdlcc8tboHnx/zciCnv40KqMQCazS32NBT5nfiBdCfoUxAVipar5nlR6dH1zO6uqx9TL9ZxrodWtGhQIE2jOcgBAIoBSVEtTvOl0ix7blIrVaMWneQ2Y7JKYRtnYYZg/vT7eBzBD4ZT5Ske39r5m97syU2bclakqt5/r02c5ygXKM2ukbIiHzBtBRPCa8VwPhgzjcrJPqer6Ksz6NOI7KgSMVO7NS4X2iEuCa41Zij49crEsHuo5ZXnif/Tk8AKzDWzOvwEMEYFK9l1RAio8xWCTyafUMzfDkKuUTMxQ8QXw2dCnEtxe+z2wvOa9oRf18+P5yT0W5s7vUhJmVSMu6mXHbFqd6AsVNl2gHuBP1O0mE4cwIBahBuidfHNaPAc0ROr
 CJoBxdMM
 FGfsAh2oaEmsEPz81CWOfiH57foGx53IMQxl1jHoalSBoogRF6htHV5p5olA0QDTvrBwg5JdGICs51N70IIPoJlGktKL7+XbQ0/HkOcsgSDPBu5zRKC9ybkrRoLxRV4tHmV0vchzh1gv48vzyHfAwpDmPHTEnmdiY7z9QKeFBp+47SDXV9lQQOU/WD9Ws0YUp/NHMHgS3L3yKvMuS5vb+iDX3rpFt3YjeCJ8GR0yR68uJ3F2F9nBAG4v4g16hM+QdtAykebBOhGCKsThiE1fyOaS9GfILsFVWV+rLlUDPfMkWEX4EzetQyBTKoTKGltqFG1vukuP6RdsliO5yXmyml/aZTdi/U50Nknx1jhgbwY1f9KsZlm8HirPskeJq4bgA/habVKVNrjixWeHDIXC1TZfv4QXSIWeaVCVy+rcVggmjRqL/LOaJ3lV5waL5fgkGGOVW7hVw4b/UHbuZ+tli0eRZD/m0C8iNKV38Lbe977E+Kpl55kaNn/4MUJP9KOgFMkoCQnM+v6BRYnqys0MTju39IOZAEYoMEAIWNVzkV4KxHCVMlUWSprqoEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 04:42:37PM +0100, Marco Elver wrote:
> On Thu, 4 Dec 2025 at 16:35, Marco Elver <elver@google.com> wrote:
> > On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > >
> > > On Thu, Dec 4, 2025 at 5:33 PM Marco Elver <elver@google.com> wrote:
> > > > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > >
> > > [..]
> > >
> > > > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > > > >
> > > > > I believe one of two SoBs is enough.
> > > >
> > > > Per my interpretation of
> > > > https://docs.kernel.org/process/submitting-patches.html#developer-s-certificate-of-origin-1-1
> > > > it's required where the affiliation/identity of the author has
> > > > changed; it's as if another developer picked up the series and
> > > > continues improving it.
> > >
> > > Since the original address does not exist, the Originally-by: or free
> > > text in the commit message / cover letter should be enough.
> >
> > The original copyright still applies, and the SOB captures that.
> 
> +Cc Greg - who might be able to shed a light on tricky cases like this.
> 
> tldr; Ethan left Google, but continues to develop series in personal
> capacity. Question about double-SOB requirement above.

It's the same natural person, so only 1 is needed.

thanks,

greg k-h

