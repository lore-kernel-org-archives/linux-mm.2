Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA2C10ED661
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10336B0092; Fri, 27 Mar 2026 09:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7CE6B0096; Fri, 27 Mar 2026 09:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD326B0098; Fri, 27 Mar 2026 09:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9108F6B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:42:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4223F8DA6E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:42:29 +0000 (UTC)
X-FDA: 84591957618.12.7696EC0
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf05.hostedemail.com (Postfix) with ESMTP id 14CC7100010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:42:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=WXmgYcfo;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="I HVVfny";
	spf=pass (imf05.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.138 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774618947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8kqb/PmSoN6Ni50HiBp9vabWKni4KIgQFght4+Tts0=;
	b=105hhwiUPCu3MyduPyxT7+h5eRsEBxmEhB5TOPaAI2SLG70p8poQ1s5kMr5G9OAnjdv78g
	m7MAkxUkxwaMB4rEORrXpSvNbVoJJMQknoYGTksUTZJl07vhAlU4L8jm2chrZS4aVeBMYM
	mQP8SA+xDka++BKqetGsZJnAzB9yFWQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=WXmgYcfo;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="I HVVfny";
	spf=pass (imf05.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.138 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774618947; a=rsa-sha256;
	cv=none;
	b=IqaDV0Oxvq+QQNrAtFdnTGrhOONSR/u6KPBjsFb6Ox6/qW2RzvaQr2YVBIDzU5fBbM8Z2a
	y0adsGs6PSKDvwyWVyzqbXTsgyHVA32xzcIjRXmH/d2kSRJU44H2gwO5cBpsIK6sp3J0Xu
	Jskt8aLrSQiLVqJ2Ro6vr6a7SlgUJ1U=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id EE82B130002C;
	Fri, 27 Mar 2026 09:42:23 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 27 Mar 2026 09:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1774618943;
	 x=1774626143; bh=r8kqb/PmSoN6Ni50HiBp9vabWKni4KIgQFght4+Tts0=; b=
	WXmgYcfoU7DXqp4nVD4iHGiZnjmZ/oBiySyxKd7rz8vp9kcZDKnYLEMGgCJQIjL7
	V2ImP+GLWMVeAo9BapSvgkg6sZA8FAlX89F/EJgDZjHchNHND2dlQNt4pc3epoh3
	OJ9ax8G8Ti4nTeaIYae/vg9E4znqy0UmoGNsm5mT/JIT7wWxREblo3ydqTVYtkHP
	UlmWf1KNBzT+e6MgE7LIPG67LgydS+QGPzIPPt6kxSxTjBes6xazxKTqstswJBaF
	FpIaPM3zI7B8Hpd+MXNo6jjXH4XrRQbGwe29451a2OxlVNv+QJ8HI+vwtzjFwRfv
	pS+0qtzZIeVwB5SBu2Lzrw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774618943; x=
	1774626143; bh=r8kqb/PmSoN6Ni50HiBp9vabWKni4KIgQFght4+Tts0=; b=I
	HVVfnyLZcN35pRyg32jICZM0qVLXsONawFPdb+heGxPgSM+izITH8vBPCEA/bJ9E
	UN6H6aMcYUgpH7jg7wSGLvSMIlKgI7lRJLiAnw1ZuUsNQGzkiUxHOU3GYu5q66XA
	Jtq76kjAyjkWoLV5eiPhBRC7IduTmfV52rSHitiA33ESsKYRWwKnZbkkIzoB5A80
	UuVbB2VtJaN78K11CULHWhyiLFlTrPunOhraGsziiJpg80dksixydziqGGZRWk+1
	rmY6b5kCR5m6oncjYZkweCTkFj8Kmi58gdgjDLPH5eRzHI0CFMQYY1btUypTC9F3
	EVQl22V83017juQKIQ6Eg==
X-ME-Sender: <xms:PYnGaTFjNv-2kjwzDO96mcm0J53r3iq9GAQxohg1QK5UaJwCiRIPvA>
    <xme:PYnGabIVAVLiZp2iZ7XOB_zppj6xtVcQUdS2evGHJbBxfLdaZ5WI6ibLO15radjvz
    L2ZUekfulSqpSJwxkEQ-5xkmAa_hhYZUOHObcnX-PTAuMVzrh-xqU8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffedtgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepgedupdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehjrghmihgvrdgtuhhnlhhifhhfvgesrghrmhdrtghomhdprhgtph
    htthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohep
    mhgrrhhkrdhruhhtlhgrnhgusegrrhhmrdgtohhmpdhrtghpthhtoheplhhinhhugiesrg
    hrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegrnhhtohhnrdhivhgrnhhovhes
    tggrmhgsrhhiughgvghgrhgvhihsrdgtohhmpdhrtghpthhtohepuggrvhhiugesuggrvh
    hiughgohifrdhnvghtpdhrtghpthhtohepghgrrhihsehgrghrhihguhhordhnvghtpdhr
    tghpthhtohepsghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheptg
    hhrhhishhirdhstghhrhgvfhhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:PonGac941VeA2oTCcTkWfzRB1nZw0mSSQHJ5Pqk3p0ZS0l9NehXMHQ>
    <xmx:PonGaQa4Rabao1kTTsgiRbWyc3rxCyCd3mcww27MNaGYm9rsSBoKMA>
    <xmx:PonGaVpcyAK2snd2rS9lHbXXYlQwTHW_7ACWd1UNjoDP3Fnvn14ONw>
    <xmx:PonGacv8QU40CC2nyaF90d74nBjZSBShHRTwrc0LnYslN6WX6eF_Ng>
    <xmx:P4nGabYMQKNNUJ-KtgTpLrS-vE-2hZR7lr1g9qxy0N1Vgj0xHOpyYnfa>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D382B700065; Fri, 27 Mar 2026 09:42:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AUJnWW6OA6Vc
Date: Fri, 27 Mar 2026 14:41:41 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: "Russell King" <linux@armlinux.org.uk>,
 "Christian Schrefl" <chrisi.schrefl@gmail.com>,
 "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>,
 "Alice Ryhl" <aliceryhl@google.com>, "Ard Biesheuvel" <ardb@kernel.org>,
 "Jamie Cunliffe" <Jamie.Cunliffe@arm.com>,
 "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Miguel Ojeda" <ojeda@kernel.org>,
 "Andreas Hindborg" <a.hindborg@kernel.org>, acourbot@nvidia.com,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>,
 "Danilo Krummrich" <dakr@kernel.org>, "David Gow" <david@davidgow.net>,
 "Gary Guo" <gary@garyguo.net>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Justin Stitt" <justinstitt@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-um@lists.infradead.org, llvm@lists.linux.dev,
 "Benno Lossin" <lossin@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, mmaurer@google.com,
 "Bill Wendling" <morbo@google.com>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Nicolas Schier" <nicolas.schier@linux.dev>,
 "Nicolas Schier" <nsc@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Richard Weinberger" <richard@nod.at>, rust-for-linux@vger.kernel.org,
 "Trevor Gross" <tmgross@umich.edu>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>
Message-Id: <1990bf45-050a-445d-bcea-16d225207531@app.fastmail.com>
In-Reply-To: <93439e91-cf81-477b-b880-a813bb01ad7c@app.fastmail.com>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
 <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
 <641592e3-2354-4238-9eb8-a1f5c2a13126@app.fastmail.com>
 <CAMuHMdUUfVCBZFi2WoOYibJLVnyPY-joRDJDowgHwjN_DGeEzw@mail.gmail.com>
 <93439e91-cf81-477b-b880-a813bb01ad7c@app.fastmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 14CC7100010
X-Stat-Signature: 7zoj9bnwj3areknnmp3ojffa7zfbptty
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774618946-710085
X-HE-Meta: U2FsdGVkX18b/UPeAIa09DBxeOSk69j3bbXQqs0Ll+dOGfTImKoEZ+0CHmOldMzzd0EoWhUXoLDRWThOKVi78XbQfkaL+cNejF6E0e248Ihmay1/kW6PUYrgsTMSTgr0IYqAV7vWCU6zMFIzaRf5BzrdXmZbvIjVlhljUio5PfTQICP+ful4HF2/btCiIBeRz+WP9hPsAhObxUEZugxLe5mp1Sh6JbNqRJd361l96FjX1vaYVFtv89mebhpIHom1AaMK5Bwu8ACJQ7OrTTebFy59s5XH8Aa9Dq4Sp6gnOZQIcEwHFxjemaYv5zOc6u+7ppQtmZn+n90w7b6D91nW2kb9Fz5lrCoAwdWeuQvxdlysTZyhx8+kA0MWymE/w5V169UQG6IhavSpbo6zLp9xtY8s7WzDTXtJ8/nnajPieUEXdqmXL6q5BoNxMjL6E+INmkLiMS+HK2PdIaklKB+t5RrQAVTyNKMCgLUbeLAsognswzast51RNgQ+vhMCrOr3VcwLI/CkbrAiTNItbzuBiprbokSBtrOmpWETioPFklpx78D46EM7uCN4BWiMRhtwV4zaEFTeWpiDQFeNghEwATZ5EazYrfVIKwkMkD1tavinTaUsasXXlCTFRniyOlQvR6oHEsvDZ/NLuQeQVQ4C+HwJu2ocETu/6mAaDYFwvGQ7MFVO2GebxtAsetTMkwSP9rDdPjaIk1VKdrxda9+dt9lwX9BLUZJXPie+BlyxQwXnjKGT7IpCsef+LUC3P/cbNwQ2cVJr2fLFC7CpASSyH06xuS06Evynzh70eEYos0nDc6oPxkN5lAWhZMMDwrmMeP+Y2mF8pN0xmC4AatUTMk+E3yLySOLK3+xCvNlqPArs+F3Neoyeg4ya/Rv8DTHll6Uqc6RNJdL/SEvLE4ymUmhAR3Irw4LcotuRmZHgy773KDfMf9DF57ysQroIYrIME9GfmURY0jFpsZvurt/
 z4H+86YN
 WQLUiaYpuCUGsJjWgyWLqbGkBYMUdn1Ys/z1cHe7Gid04qtz1of9k0e8W27+OwZOA/f2gBkG98mcgEpbTdii1PKlrt38r8dDDiOOVKjStNbwc3mFrb8vkSLJECbUvcBWwHL6pBUpHr0n1NZBROIwUSForylyLe+CZUmkYHgET5wPw0H/B5i2rTMdkKty4D2Wnj07P2mrYwFzAbw25PxRrVawKVvcCMMifUWFkgMb72a4PjJXHNI3Px9BylZRQ6znUnrWKiO76bjbfrkK5ehM2tjiMIxLqNzErmIGNuB2OKIDxVjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026, at 10:02, Arnd Bergmann wrote:
> On Fri, Mar 27, 2026, at 08:56, Geert Uytterhoeven wrote:
> but that only allowed bitfields to be marked as __attribute__((packed))
> in order to get tightly packed fields and return '4' on all architectures,
> while m68k-linux-gcc apparently has all bitfields implicitly packed unless they
> are explicitly marked __attribute__((aligned(x))). This behavior is
> independent of the -malign-int flag.

I had another look and found that this has been in gcc since ELF
support was originally added for m68k:

gcc/config/m68k/linux.h:#undef PCC_BITFIELD_TYPE_MATTERS

All other current Linux/ELF targets get the default from gcc/config/elfos.h

      Arnd

