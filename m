Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420E3606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RhloDf5h
Received: by kanga.kvack.org (Postfix)
	id 6DCE56B05B2; Thu, 26 Nov 2026 08:27:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B46D6B05B3; Thu, 26 Nov 2026 08:27:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3096B05B4; Thu, 26 Nov 2026 08:27:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39C4E6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:27:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C77F4140438
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:05 +0000 (UTC)
X-FDA: 85477346010.13.E62C012
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E36B6A0003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhloDf5h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795699624;
	b=YewKdbwV8Y2raiiE1RLbZ7xQcEix4n8Y1X0ZmmmzxXCPho34hT5gnwK7RO6oe+Z5wIvLJY
	y5lcF8ftSlgOGiXGDOspruvFsRp44Q2IyZf4kG4p2UjiiebY2RfWD1DM7mAqKQzwzw+82Z
	3AyT18O4useG8ngZYN2jdFGmnbY3jVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795699624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZokuwfU4kATqyfaTag6SaT3MT9q8pH3IyIO6M5PAlLQ=;
	b=XCifkRzTPXRQF8AR07YTNkEdHhp2BVoBGbbSQaJoJIMkOKZs6sGcnidcAT5pHI3kmCch9T
	cHMLb2UpGSpd/u8k2425d8s6fnJQgw5UyJvxd2foQ2DDMWrilez0LAVnwZhY/xEo06JzWT
	mFga6KMGKMvKnkpdP3mNmzm7C/NijVM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhloDf5h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28A9841606
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D061F000F0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795699622;
	bh=ZokuwfU4kATqyfaTag6SaT3MT9q8pH3IyIO6M5PAlLQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RhloDf5hjViDM1wa120MCgd7yIwpKXtodHert8PQGCu3nBm3Jhrb09TaNG4V8Vs5/
	 d1vXZiZry4y/sMZO+BHWZqI6I8kbwDjJ5tj7eo69vxWr3+mO790EUTeE93erN6DUug
	 /+Xrz1C+FBXYxu00wHMRsUx0TeB7gI6IBwCtH6p4ScNc3/1sNZ48q1pUb+ZpywnDgZ
	 XVRPR+txQwLdlqSwSwgjtDaLOXnffR1tbfJNLZDhTgUKD7e3Yw05AETznW/H3wSsTH
	 XVEdiem2CXwXSMkBzP2IING/Njo/LlWbqYyIccI4XEG2KwHon9RuKWhsn/TqVpF2si
	 RlvpUjUD9LcsQ==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3adf9b1f5aeso68182221fa.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:27:02 -0800 (PST)
X-Gm-Message-State: APuU4Z8PnIB4ZfBZMMLPFrMlsBzwZhJXXOMHiBQwHtbK/s/ALSZx7Xoc
	DhAL6DVnjREGGX0xuTUxAYk6J7YOxrQxMf2EJC/5IoP0brmGd1+3HINTT0ztBu0fPSvtubPmg9Y
	PqGJekuhzSM+2Wa25G4SKmqpTkcaja+I=
X-Received: by 2002:a05:6512:23a0:b0:5c1:5a42:37ad with SMTP id
 2adb3069b0e04-5c1b7beabfcmr5752337e87.16.1795699621444; Thu, 26 Nov 2026
 05:27:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116124832.662455-1-arnd@kernel.org> <20261116124832.662455-4-arnd@kernel.org>
In-Reply-To: <20261116124832.662455-4-arnd@kernel.org>
From: Linus Walleij <linusw@kernel.org>
Date: Thu, 26 Nov 2026 14:26:47 +0100
X-Gmail-Original-Message-ID: <CAD++jL=TmzH8tm46CvCd1=B_YMyiZM=f1vys_NhDZOM4MdxzFg@mail.gmail.com>
X-Gm-Features: Aa3M54oJhuqbanKDTHMwhtXUm4eQYbQ6svpItwvRIwSjJelTST1VrzQM13SDhkU
Message-ID: <CAD++jL=TmzH8tm46CvCd1=B_YMyiZM=f1vys_NhDZOM4MdxzFg@mail.gmail.com>
Subject: Re: [PATCH v3 03/10] ARM: pxa: support arbitrary PAGE_OFFSET
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	Andreas Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Lucas Stach <l.stach@pengutronix.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Malin Jonsson <malin.jonsson@est.tech>, 
	Matthew Wilcox <willy@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Michal Simek <monstr@monstr.eu>, Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Nishanth Menon <nm@ti.com>, Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org, 
	sashiko-bot@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E36B6A0003
X-Stat-Signature: mqzh51kb9jroxhfrkxa7ntue57nekeow
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795699623-181435
X-HE-Meta: U2FsdGVkX1/N9iN672XzUTGkCZlmQt1inwXo+PiSMFJxmTmhwX5yBrY7iwoCG+DRdPxPL8UxZ5Dgn6CdAyuNR90DvzH8W2MEdoESi2DULq5zpMDi8TJdpEgZnFyIP4wii5Ksat1bwssKn33vf/P7RPkrZWIoSoFSUuoi2wDwuH5nLaW1gxzb28Mqbry/Wxv3BTBQTRsvxwVNTRpC8a9KKVZDxxbxUQ/uDSEsxSnaFnFIafikXKw3Qk3j/wfxphO6y/l2y1sM33wVWagsM/zpM1rZnu5jwpHxYOlmfNF9GrfEq8+vNB/nohD5HMvaMMf2wybzBVhWpbf1fq8tOGM9eFybufwbX9PPeBeNuz/7PCOoAuOqrQzYlQhsKYs9XiRLSdaEdZrpCUWp3gwFJ99YhjcX3gUn11CkCqqn3FTsJOxI23Mz1M3J5ByaEFi38UFpZ3lC6LqSd/hEzRYf5PfM/z+WbCoT3/X2VJnoORgKCxqTyoIRcke7wbdURRxsrPHrmq95mV6EdqAb+DYFf3qOmND5AlghdxoPn6PAPXLuAS6hG/QLv+pTsfkI5bM+HvfyruqMsxmnNjpagH7y/SpxBTAtMFaegk4DqDYjBwX/njw7S8DZz3K3+2ENrOIPYwvAy0dwBizieD2voKVY9c3GrJO1MGKYqYizbt188K/rHp/qVJTCmMZ2/IZpGYhYy56sx4GvyX7SfPs1RoPkASbqY6tKnUUPgMnOcCGr4Ujch+LMC9SqN7juBSD+JGttHzh528TkFPZKoH98R+CT1I2aWieptLYcYcAQIjnN1D3QK5lqyTxXuvQXtLAEUJA7kCInRXgrc5AJQmeXoUIekXYtuB2/ZwrRV9AIEzoo3+kzAUqS68kwYx1xUjltTA3X+mqyI6m1GY+rX+Tvb7oqJw47npqPUgYC/2T3F0pqxXZ1fnDfwwaHkkU0MFdIng5ufrWkQOFlTZG84w0lWaDtWyO
 YIzIMTtf
 +h/+ocKw9Uwln93Sz6PxnIwGkU4GZrRpkLZxTWEGjIDJTGav/Yhc0sWMx62KAATfRkSNfrfV007pWKF6b4nwauB9JMO4kadFMy9L8TdEj8VU1BXe3P34+AK8g0TjB3mnoBKzThN3F5haBN0yonQXsgwpMnXx4KYDoFOsBifjWcXy5I8wfv67aiAtpqEhwSa97NETo34nKGuHOly5yiofaQuCwM/zYDTrKkTVlcrdJ9CbN1W9pdZy2eCaE0ebCy5q6x+EKkVrgfsG7ipgBkeCcr2tsMgXsOAktZaLa8Ys8YFRelqpgPo/w5ls+19jOXj4roPHSZvNgPVPrilA9bAF2Oo6hgjJKvHqm3jq8Z9Ij1mo8JlOcxTLEI1ma2j15YVn34TbMTPY2k3r06QjD5NWhLF3u8Yx8r3tG0dgu9stCWFC4VZlZgdO9b7ROqhfJ+PtQ8gtjufFAC41PbTo/VG+0AWdFIBss3H90JWbgNG+0+2pFTcciAYDPW3CzGrgE9kac5Sbys2dZzd5Wzcw9mfGSEqjKD4WZcjFsH7tOuQ2lbGuQTaUfKV3oG2AMuWnVa1D3zPbINw3xQs/7FgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 1:49=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:

> From: Arnd Bergmann <arnd@arndb.de>
>
> The pxa3xx_cpu_pm_suspend() implementation hardcodes the default
> PAGE_OFFSET value for CONFIG_VMSPLIT_3G. This has always been broken
> for other configurations but becomes much worse now that the default
> is changing.
>
> Fix this to use the correct compile-time constant instead.
>
> Reported-by: sashiko-bot@kernel.org
> Fixes: c4d1fb627ff3 ("[ARM] pxa: add preliminary suspend/resume code for =
pxa3xx")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/sashiko-outbox-212719@kernel.org/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

