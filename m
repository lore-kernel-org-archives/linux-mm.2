Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB475FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 16:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BDD6B0088; Tue, 28 Apr 2026 12:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73786B008A; Tue, 28 Apr 2026 12:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88F56B008C; Tue, 28 Apr 2026 12:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9EFC6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:24:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DFA7120403
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:24:15 +0000 (UTC)
X-FDA: 84708486870.30.E2B273D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3AF67140010
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:24:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDGDCMSc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777393453; a=rsa-sha256;
	cv=none;
	b=W4kgbO5TAB7GQXJWSPDIwVAOJ/cbhZ3xf0ynltQXP9V99NSd+WRN6Z6bBFhq+dMRfoMJtY
	3AJBMsgUXJw1JU5WFK9hQ5hpvSzkyoCj8IyZ73KcHG/LgAstiU4q++7dkRObLgCHfCWiQ9
	LQsSpU1JkL8a/4IfL2NV6lFNDAelt/g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tDGDCMSc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777393453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1bsBBNqxiKFL3r8pzOvOev7yw0CjKM3t1BUQ0CdvGx0=;
	b=Z/BYP9b4Pu/qR5bEA5kEYRzy5jJuv2/ffSbEbiB3jF6+Ql+4+CYtpk1BmDmbgFerTySG/t
	w3UckYww7yMeP4GhyphIU84neASRWrj/KgOpYFK4Uy49uA0/WMA3q8O942O78OF4cVPihj
	pJumak1iHyiCOnJW2mbqAnEnNWdyEUQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A26042A67;
	Tue, 28 Apr 2026 16:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470BDC2BCB7;
	Tue, 28 Apr 2026 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777393452;
	bh=1bsBBNqxiKFL3r8pzOvOev7yw0CjKM3t1BUQ0CdvGx0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=tDGDCMSc5frNPLYZ1u32bsd5FETEqhuxXGC8wu2FRMjopEjqhnJwfxDb3g94QfMwz
	 U4hzQPRUQ/um2cRzZ2URy3UVX/krs4hTUW/B3K6NuJcznEgiEHCCgCul3VQ/3s25Eq
	 oUwTfuAleMiZOmRmW5sYBEoNWc47t0BRVwpjohlPR6zHnpa2sH/3t6I7mYV53/IOiP
	 smCgkL7ziANseRsmthrorHxqOMwmfpAYStLZDDNVUtjUKsSVSZX+MACppps/JxfANS
	 WjqR/HuTo312R67GOueHyTwBQRQaTHhYq4wssY8K+S0ctiz+gNwwpmQ1KRkNfe6Bu7
	 0eydU9nWThUaw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 420E4F4006B;
	Tue, 28 Apr 2026 12:24:10 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 28 Apr 2026 12:24:10 -0400
X-ME-Sender: <xms:Kd_waTM-YpeIRzy6D8hDAAt6tG8XpwJacDqOgicev-Z2qTgRv44aGA>
    <xme:Kd_waYwhSSVNBP78OasJTegpNlbyZaVG9bMbGJfUfL-mwJqvhkcePIwgGLvB3IgtX
    uWdXMW7Nn4z9cEV3njTHAWlN0IpeO2AKTZ9LhSGUtAuoElV8mPr_DM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekvddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepueetieduieegkeejvdehudeiheettefgtdeugffhjefghfeftdelhedvheff
    hfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepudejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrnhhshhhumhgrnhdrkhhhrghnughurghlsegrrhhmrdgtohhmpdhrtghpthhtoh
    eptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehkvghv
    ihhnrdgsrhhoughskhihsegrrhhmrdgtohhmpdhrtghpthhtohepmhgrrhhkrdhruhhtlh
    grnhgusegrrhhmrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhm
    rdgtohhmpdhrtghpthhtoheprghruggsodhgihhtsehgohhoghhlvgdrtghomhdprhgtph
    htthhopehlihiiphhruhgtkhgrsehgohhoghhlvgdrtghomhdprhgtphhtthhopehsvght
    hhhjvghnkhhinhhssehgohhoghhlvgdrtghomhdprhgtphhtthhopegurghvihgusehkvg
    hrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:Kt_waetmYIlefUPzV8DLJtcXoLyndaR0qgHSXePM5t-l1I6k7WeH_Q>
    <xmx:Kt_wafy9qHJBlVvot4VmPvKrB1oLabolvskFZjhEuHfBCd8ye4MdnQ>
    <xmx:Kt_wabbuztJ0Wj6nXCkW5OdQ5qtgvzpA30rGIbmCNeR4Z5FwwmerCw>
    <xmx:Kt_waWXmn9nmIyXPgk4Tmqxgiwfc-GzV_MBAadTlVGA9CktWULE_Vw>
    <xmx:Kt_waUFzERDSXIWNL7VNTwX1AjlL5laOfDG61W-HqteEpSf5IwAdRQtM>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E4EF9700065; Tue, 28 Apr 2026 12:24:09 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Tue, 28 Apr 2026 18:23:48 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kevin Brodsky" <kevin.brodsky@arm.com>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Liz Prucka" <lizprucka@google.com>, "Seth Jenkins" <sethjenkins@google.com>,
 "Kees Cook" <kees@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "David Hildenbrand" <david@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org
Message-Id: <6f514d91-c8ce-473f-8383-f3b9a4cc2f7a@app.fastmail.com>
In-Reply-To: <82091dd4-9d11-4054-89ec-99aadaeec7b2@arm.com>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-18-ardb+git@google.com>
 <82091dd4-9d11-4054-89ec-99aadaeec7b2@arm.com>
Subject: Re: [PATCH v4 01/15] arm64: mm: Map the linear alias of text/rodata as tagged
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8qrku4i64wy9r4o5ibygfyfyy6zgpj5b
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AF67140010
X-Rspamd-Server: rspam07
X-HE-Tag: 1777393453-556509
X-HE-Meta: U2FsdGVkX19/sWvFfNnkfYYoPNPd2cCEt1ps0vEqX3yf8foIqTjOeuH3H5XWYB4Ft8orsKvUmy4rXUjD8nrkpMDHFKajRPqdN07ONbuoUlb9ugGnwRPwAjgYK84ZY8U+5T6y7hCjqryaF0Viix44YhZuXceeKMoP9MS8CN0OpI+EYMOVgC86fz0b4Xld5jMAVG1C9gmE5cv7kLoiJxi/SWa70JdJ8nREmeerF3FWOXCAjMZMNdz57KSMabVtp7unMrxEzZkgL+NxNsNISBjV4okUdHjNSh2A5d7MJqr8iFTcrAXUIuyFLXoTa9UrQiXdu0kML3HiWH9OwAkS94edBwY76Xk3jA/JWl1wWDio6AEIpuru5KZNy21sCChsOKY/ZE/0L/PnRlUQZvDX83bzsx4S3SPEdjtR9KJTpQqYvvfi03BFKnzbn75Hji0t2Oi6M7HvAgg/Xwpf7XTDMUuWDr8FLGCCZ9rITnA1eM6AY1lKg5YDXeSQwB2cS4dAC96OY4IToJhaIjNSZ0VKHc0J06Un8kuzIkr5Jkutfu2Sr2lD/oRHZPeQTat1N6+7lSec1vQvjl/k5DnTWrrUCP1OoZQQ+dLBLKwGcGPVuxD5vaZofFOhfKMaSSKO0EePwO4DAJnx8JfqIeJurMsBpG1+G4vNWRA5X/sg77SFg+urTznyp8FhxtW9pQJ8lXNztrBJkCVqBlmFaURUcwwRGIZ0TPYf09baPgrRvpu91PtSSIu2WkMjPs9ydYsndy+xIlEE0u60K6L/hbJZrG4gFJ/6fgpXsDQUJ05TJYVR4aP6BGQBHD2UWefInJyTZfV1n866nON1obI546WDw+ZrUGRSI2/Ddq8ajKAi2dJ0LxzjUvAywjfThH81utcF8yRgzwkJejD3rm/kgiAPbcCcuJsp5/gFsKVSGdc4TFK92YRTtwqrGcMHpJOrRUH8PIxptrMUOVMod2Mih5aOA3Brn9i
 cYICQ+dj
 3fVrM9Tmns7aKNeyIJprtpNuLJ7fV6vQK7lP9sB6d46JlDURF3tusJVpsLHUW9k3bSfOKl8s3Lbsv7oFbfBmVB56BU8Pwm2NYR3JhDLdc9sZuqAeqomzLRY1/RhYm/iyooHZjR5hWWxu4UfUmKdOL9UrGNxXCgsd2KP9tOv9eauRxmL9iEQYBOjVatv4HcKUbf7I5iDpjUFB9/hNsy9jXq7e1D4uYrdo5WX6SiBtSCejPaW11pZnbjSBH0q1KWvDtAfYdKewNMWxl2LJyfX6zJ/IpRXKzRt62CSQN/pLyoyHpC0PDHTS7Zm1x1KryA3EUflgFk8gStN13guOrDFaUDwsA0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

On Tue, 28 Apr 2026, at 16:16, Kevin Brodsky wrote:
> On 27/04/2026 17:34, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> Before moving the empty_zero_page into the __ro_after_init section, m=
ake
>> sure it has the memory-tagged type. This is needed to ensure that
>> cpu_enable_mte() will be able to initialize the tags correctly.
>
> mark_linear_text_alias_ro() is called after all features have been
> detected and enabled, so do we actually need this?
>
> AFAICT the lines that matter for cpu_enable_mte() are those, in map_me=
m():
>
> =C2=A0 =C2=A0 __map_memblock(pgdp, kernel_start, kernel_end,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PAGE_KERNEL, NO=
_CONT_MAPPINGS);
>
> It is probably this call that needs to be changed to use
> pgprot_tagged(PAGE_KERNEL).
>

I see. I guess we should probably update both, no?

