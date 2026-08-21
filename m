Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D05C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B0C6B0095; Fri, 21 Aug 2026 06:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BB6E6B009D; Fri, 21 Aug 2026 06:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA3F6B00A2; Fri, 21 Aug 2026 06:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08D836B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:29:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CCE2A2FD5
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:29:46 +0000 (UTC)
X-FDA: 85124905572.29.49185FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7CB4E1C0002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:29:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixUI3kRs;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787308184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APGED5YlpOpMPxOSsAuKA6X7ShEtj4fbflQDOHFgkgs=;
	b=1FHFlxWMfDWLsnIzjeHyx6It/Oi5icmMp8FvuV5W6lfam41h6yR3mZ8V5E3zGX0fmMazil
	csXIWlnzlTenLLwXVnpWlRb2X8fUBO19mPH29HnITRP7Eb3vbZiQVT4zwT0IqCfvbt5B2e
	WPgxvDLD1iKWrTAfSfxAEawjSSP+/1A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixUI3kRs;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787308184;
	b=4NeWJQ9Bs100RGmJWlnB+CIBtOeaV20xQdhiaJdrFs704NgS/xd46a6g0ePVpDFu2D3b9/
	Ab3jVCpow5gLwrvhdwqxA7xU2h4uXeJ3Hzk9WYVoVcrsHtKsKyMeCE1Uv2xP5nG0yvufcn
	jLRnaPLavPJkRkhq0uua0rg4dS07doM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AF0043C9E;
	Fri, 21 Aug 2026 10:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929BD1F00A3E;
	Fri, 21 Aug 2026 10:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787308183;
	bh=APGED5YlpOpMPxOSsAuKA6X7ShEtj4fbflQDOHFgkgs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ixUI3kRsD8NoUTtmkjyJfa4wlDS1R4IthffH+JxKoU6cmU1lGAaG4clXL287xuHh1
	 FzXDa/qYuq72kJG0jgYnXPTUntW8HTxORTjZ9zMtzU2H76m9/ZwKxWBR8g7VqYAuva
	 kgQFavADAJwi0NRufxA8l8j/zT3OVVcMAxgx1gl2+e85rIVJR64+x6g9/HBkUVYvVx
	 kCH7LrYn2BlvwyddOASSf0J2KMGbkAaRPTHlkFbYif7VFRWytKOhy+T2rQDtkoB01E
	 Od3baF8witTx31YqfSZSFnCFr4BovvmI0G+CDmqrfhlwEDpZqh6I3Ig2QOF85lHa94
	 BNRaFCMkdKWqg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 2926B1980052;
	Fri, 21 Aug 2026 06:29:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 21 Aug 2026 06:29:41 -0400
X-ME-Sender: <xms:kiiIarVzSmx1y-aArkHdOBg6_uN2EF6kmHm7eYV3kLj8d1ZetYmTnQ>
    <xme:kiiIarad1L4afhIQcR9TpUON9bZV2_aFZEy-RJGSw_E5CZfR8pB7srH9uie3fSiuB
    dePAuvZWbvXhhgkEl6OfcEL-YeY89S6pgIr0B7jnImbXdTXQ6RL2xCu>
X-ME-Received: <xmr:kiiIaixDRegUN-DZiVZpoNH_w4V-cSHrk9NAzrk7u6EdWuZo3aVYGcDscRg>
X-ME-Proxy-Cause: dmFkZTGP4bL3rkkhiaU+LYYEJklVw3I4bCV0bLo9Xe/rEgNWD79Kg2qnSiGX6a0LzPvrT3
    wfkn1QSVsDXoCCou0Ai4CQZtSMXEfYR7TcfJrEs2qA5nuREzR/25/SXv5FHUVnpahHF5rZ
    sKtXsan+W3eHdPeJRne/qiXwfCfCb10WRvmLB30Ci3uaIEVL5D3olIiiOSnObxq8C6IPWE
    CaoBiOtHyQu+B9nz7YFtvwuilTaX0/jGLK4wKrha13aK2nLIfCvV4FGU476zMpcM2zcLB4
    bT9trOvY0ulRdAD+iw9eIBoGr0FK47s7WRgK6yQyBMu7G61oTI+YvMopiv4VSl18lOJ5Z3
    PFVi+866/3m3g5aFzO7xOv7m6vuXzMUw4Lv+jO9gfxTn5uM0B+j96kCvw/jt8I+huXrLkU
    wKkJaFlospdKLrCQDk16EZ8+PTysacY1zlTDsV2ACyFg8I0wjizXHCfA4iRjksBttHwcTY
    wvEmk9ehfcuSKoQI7pMdYMnnya1y9zVIko1YRNEGK1ERHWn8XNmEmOW7aegRM9a2hLgBF2
    fUrsAB+TJNQlwN/Ob1VoLupB9GoBMoq4ahvuVHXxmmOnPY+KATnU/KnrCbrHVXlRRWx6En
    75CalTn5X3AfHuDh0QqtF9FFmIT9W6QxvSkRgXvqsKl4lNvEtZYrfgg/K2hA
X-ME-Proxy: <xmx:kiiIagJ6K1_IhTU6mwLPUNctDqMy9YCXitJsDYeigc3ethIccfkWKg>
    <xmx:kiiIapfwVryqGlX_G8FBQ-G81dMyuek2WOwFvDgVQNTkC2pFWFIxZw>
    <xmx:kiiIaouDMVQjpMMhVDXhzsvSFoiQl94RJjkg-M1USLW9qB4i-AysmA>
    <xmx:kiiIanFDd2c0gVRX9E4XBv2diwz95NhoIw-LxCwp5NSInmTPRSGErw>
    <xmx:kiiIaifnfAIs5050IA3B1i7QlIb-FxA2CFT7Ar6PadIGJ8yF-mjmyIVy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 06:29:38 -0400 (EDT)
Date: Fri, 21 Aug 2026 11:29:36 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 0/6] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Message-ID: <aognoSPb8vbkR3U8@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
X-Stat-Signature: dzrrcyy4ksdpnwfgkeahhqyrng6h6rpk
X-Rspamd-Queue-Id: 7CB4E1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787308184-390525
X-HE-Meta: U2FsdGVkX19J9SaJxtOZMDK3BiQowMtTbfJgmCFhcXHvCIMGM9urpopL/haTZ9uBRzR5mLrDvnROL/HI/jOOBSYuHrhHzi00sq1A9Ux9pikqVAkhZxUV28bnRj0YOLbQeo7L7FkBIxOHJdCjg9n/jE4lNPyfxJFzOxXB0dhFCtqd/Q2ImLjYDo0JUaeNgjPYQObdMamk4H8Vsk/UUYT/QGcoqBK2NTDQ9dSu4NVvL8Yp73miZ/jB2m9PCvyRvW0c0tqovjkeu3lg2ts7dmgYZmrAUl8/hyMAUnWDa63Uo/HKICyaKG/zXaNk2bIexkg+C0BUKma73r+EBkImjBBtF2E8zfD5t8V0ChxxVEZz6+TAkpcpUhHnRaqc3pTlG7BqkHc3Hwg/31xtAJ7WSWe8m9tJy1CGYunINqFc2mYmt7Kzx5uoIeKduwFLoAX6mRxOP+kNLJS0wD00wohbllfjE01keQsul04gAPIi30bz7uGLbxz6DrmsmTOaVrg9IopJQ0C1oQH3UdTFvzddzSpauIRhZrpnuwL1J+Si4c9Kwiq02A5fYWKgoj2Sir4LZVN+XcUzwpnqCBt+JSYRax4jZVTizDiSdassMZ+AOa5uRecjk8Q2uyRiRM7Agm6OI3Z1pUOW/jcMlAQFRUHbbKiRwcqElRzrH0hK0IN7NsCU4z0WqQPGH5vrM+zpk5Cifa8g0/x4ruRtY/cqbR54iZt56GyvMVK7plG56ZxEszHwqQBT1m2UKXes4ybR/XR0+v02E5as/47y9hNCbryVvb0pCB1xq3RsZihdnFYTk4uTJ/Y9R0Wv5qT+bTJk8kZc37hMrh7YSnB0ec9HrxxX5HAPMtRPEUi+adNpOrfjJEpNAZSLD8IC671fO+zqFmWTXiRFBKauk/4mfaxPViMsN1KUJkGHxJxtscDfnaRAeZ5QIkFvggb+3geamZC1ECtu5YEkyfk1PGOE1e0gTcPXCYf
 OvpeMoN7
 Ngtbr0n/n4Od5s2pebIXA/HpbXah4FgEZ0bd1n+8QxVZvnLB0ILjzOai5EBh0iob5gqX5g8U5AYgrJKbZINY44X8h/sms9zOz9d5VPuVLl9BbpTrYmX1JBqNAztoK9AbDQgXhLG+Iqhhizlz5uu1ABcKAHkdYBE27EtWeASVjXGPUBmeTwsH5g81eKTb5J7U4bGAQ+7jRkIuolnzOwLACnn2JFx+/7eBIGhv0hM2bU7UGVvc6lfWbj1t06Hquam1NdCk+riJ6cQdfWyOh3+bPddXW5d4DhyVnqfrSSe9StUmBFPxdPpTFilF9HQvPWICoZw9vngyhPU3W8N6I0yg3H1SAMT2mUO1UBcRp5pkFa+b+jNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 03:06:00AM -0700, Breno Leitao wrote:
> The allocation is capped at 1MB, which covers 16TB at 2MB per bit. Past
> that the stub doubles the unit rather than growing the table, so the
> table stays bounded on any machine.

For unaccepted memory I didn't capped it. On x86, architectural maximum
is 4PB which would cost 256MB in the bitmap. It should be okay for the
scale.

> Memory hot-added after boot is not covered either: the bitmap spans the
> RAM the EFI memory map describes, and a frame outside it is silently not
> recorded.

We might update it if/when it gets solved for unaccepted memory.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

