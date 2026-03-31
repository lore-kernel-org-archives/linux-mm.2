Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C633E1061B39
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 11:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDE96B009B; Tue, 31 Mar 2026 07:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4E16B009D; Tue, 31 Mar 2026 07:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3D96B009E; Tue, 31 Mar 2026 07:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 196F76B009B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:44:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFBF9140134
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:44:29 +0000 (UTC)
X-FDA: 84606175458.24.95E5769
Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id A9E1F40002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:44:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="Jxap8/9S";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="k uLyiPM";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774957467; a=rsa-sha256;
	cv=none;
	b=Xty+UPnkCW8wYGK+5NW2yiTSSt1Km+34nz7elfcxAKdEfeIJ4AlulF12wDkT7J3H5crF+J
	65hDv8lLQpWsFleBJPeIajsl9cH+fIs9EtyzAV5KtpS0mHs8oz8jaalMe7FVKMavqLqxwM
	TAFXxqeJSPTlH756xY9dF8XtiWJDbUw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774957467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45JgVcq0EgVfNtDgS04MgTxf5U+SjaNRaHQGB6s03l8=;
	b=JQTjDrZBySQXycsXEnoQt3JZodW0WiS4p21GAcAMKgkdPfkqn7LasPVLgaZj9nayE8tgMT
	fKGAKcbEmcsTzxrr6JEAbnt4NhVIgLzIUfIbILQP+QhnivPKE0llbSVcLDLWfWE8iFy3CE
	ZJRw+zVFFBb+AUrPUSLI9pRB4m5rI7g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="Jxap8/9S";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="k uLyiPM";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.147 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 062CAEC0235;
	Tue, 31 Mar 2026 07:44:27 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 31 Mar 2026 07:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1774957467;
	 x=1775043867; bh=45JgVcq0EgVfNtDgS04MgTxf5U+SjaNRaHQGB6s03l8=; b=
	Jxap8/9S4qYqMwrKvG6LkL4qmDzEcuGMGDJ3Cz2bZ0vxUUfbPt7c1qTw+rKEDpy+
	H96GkWp6u3KcKGr2qct0JUN/2X9EmZCHETETy4o/MQnOwTCKCxywAKErWV01t/tS
	AoB2WNCyADBh/I9ydKmyNcfSk8ifT5ztBoh/vqUAviwELJGFfA0crVeDB4mK11WL
	ahkiAwGQbh1GkVlIRlDvp2kBiECEdrZZ9pCtAZL7MoOKBwYlnwTHGMo5EVr3xqyk
	bkBC7R4FFB5K20KVin1XLG6iOgUZ4X6ut43zPKpdCsTq4lcYKZLpTsWfI9o1mQ45
	GxMWe28tebPtm8H9rPSwPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1774957467; x=
	1775043867; bh=45JgVcq0EgVfNtDgS04MgTxf5U+SjaNRaHQGB6s03l8=; b=k
	uLyiPMoH1o8hur4JjSJuRWTEfIETsH7xtk6oTrvGkWtl/WpnqWZdsuVd4dFow7CJ
	t+EYzO1ktwqkE+meCgWhVgE0SUn45Sx6RnyYx7a5iqlTvHIrhneDetOw102WDFrn
	tHoOlJFw1F4AQROF04cLDYAraPS84KvCc3xdral9L9YKzdr540GQnAUdmYLN9qMU
	smmRyd0iv77Vr4+N8sj8wYfQMhws9jKeyqvdga6in+0k1BsP5d042X5ThI3t95oK
	2SeiZr3KvLiL1X8b8C/UbrsQoECRWzBT0Au56Ghgdk8zvRuOf+vArZ4A2c0rdx8k
	ITZ0Aq5KQmVCecXlXCtyw==
X-ME-Sender: <xms:mbPLaafs0nlOk9Q4g9puvZHHMG2cSvGX_65TGc17KWG9rifVmyVbAg>
    <xme:mbPLafCg7zZEDtKSpnR3PPX8iUEmuKvzcvuZ-KilZn-zxuKNxNjbUVlrscqT1UKdy
    5ehLghXHQayIclsu-xXgnbc_PNokmr2xsbYb9aMGM3Phjf5uTlVm-4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegrihhl
    ohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpe
    foggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhhnugcuuegv
    rhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrhhnpe
    dvhfdvkeeuudevfffftefgvdevfedvleehvddvgeejvdefhedtgeegveehfeeljeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrg
    hrnhgusgdruggvpdhnsggprhgtphhtthhopeefledpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtohepjhgrmhhivgdrtghunhhlihhffhgvsegrrhhmrdgtohhmpdhrtghpthhtoh
    eptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehmrghr
    khdrrhhuthhlrghnugesrghrmhdrtghomhdprhgtphhtthhopehlihhnuhigsegrrhhmlh
    hinhhugidrohhrghdruhhkpdhrtghpthhtoheprghnthhonhdrihhvrghnohhvsegtrghm
    sghrihgughgvghhrvgihshdrtghomhdprhgtphhtthhopegurghvihgusegurghvihgugh
    hofidrnhgvthdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvthdprhgtphht
    thhopegsohhquhhnrdhfvghnghesghhmrghilhdrtghomhdprhgtphhtthhopegthhhrih
    hsihdrshgthhhrvghflhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:mbPLaXWL4_RbtfLfnHQs8C4tG0ngXTCPv9euc-VB1lto6tqFQyGNcw>
    <xmx:mbPLaU_cG1WcSE-QSkVD9ElI1dukFUPpc53IiCbdiAif50XEkb-z1Q>
    <xmx:mbPLaf3Jw7KAvwSkj2NhSKaJwucaNeK5yqjANIhVWRFTYuRZjmC46w>
    <xmx:mbPLaXfgUsSfpDNbiUxt6RT2rhVcYFtkTJ_DCYi6UKM2ewPiID8SDQ>
    <xmx:m7PLaYahyRZ4gPZWSFwm_OyhnRUM4xeu34i4uTLr4s-lisp1T7JlXocj>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 31988700065; Tue, 31 Mar 2026 07:44:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AUJnWW6OA6Vc
Date: Tue, 31 Mar 2026 13:44:04 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Christian Schrefl" <chrisi.schrefl@gmail.com>,
 "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>,
 "Russell King" <linux@armlinux.org.uk>, "Alice Ryhl" <aliceryhl@google.com>
Cc: "Ard Biesheuvel" <ardb@kernel.org>,
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
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Message-Id: <a2c18fec-8ca2-490b-bd9f-bac79672c2f4@app.fastmail.com>
In-Reply-To: <f159850d-5fe6-4329-9703-b355305fd106@gmail.com>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
 <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
 <CANiq72=b+cr7Stxph_hXQTmD5crCvwWTqdaGKOJ7W1-66v4i_w@mail.gmail.com>
 <f159850d-5fe6-4329-9703-b355305fd106@gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A9E1F40002
X-Stat-Signature: a8ez5r5nmtk8icsqgty5deddredp6b6c
X-HE-Tag: 1774957467-180926
X-HE-Meta: U2FsdGVkX1+6Y/W23oAOHxcA/0RQNcxio9NFPZx//3zmLEXjZUGhOQlsZgfEUCCev5z/FFNaCbLyzZ6iwvtV6QSKfPVPlQD0p5TwrInRQFMGzrUTzAecnIn39YIy7N2MdiBeMuQKT2C1IN0J3xKPmbPiMjFxXkIMcYpP8qIf9JfuM/hAqY47H0qBewgxr/rRqbVFKzJaKKAOhNkRjuHU3gGz0svEXf/vwKIhkzQHQu/cH11dTwTJCA4VMCsk84f0T2Ka/nd3Yh88P2LEC6C7i0kXEhwq8/Wy7nYNSfB55oMNKA+O/8SqSPRULAxSn6Z1jgmz2D6PFVrfap967r9hEgdYXas+SB63kfVdb89DH2rWhLAaJUEiYWvLcNw9S9UZPJDGGJg5P+Pv+oZ65vMSwqH6kQ3eU48K0Xs7+8GrZPx24fPdUoW+xuiEbJqa0a+4sGwCTXHX66ULLFXJHRrsRXLdsY347W9+tS7JPCQop8ozVSztRmU4zO+rZ3SsMJJSf9jVUJbPxgJKKuJwoSIlm8iW905JNrwqY52luk7jtV123/4UGocE/LChKGn9l7tbfXG4NHRR721jSsA5Ivp5rcGQdjQzooBxWcBKT2pbcuhjsBkvlPN1AU/H7+pl/rpvcaSgrZUEukK/V44r1sDaNMBH6V8eAZeBta7kuKz7KDa4nIjLTilatgiH6r4Hm3duO8DJ6rsbwddm4a18pf90VwUL0LUab8X9ebG8of1dq8+ToLsU65LSMIP4MlrANGg2jxLleg+OBywxk7TT3RmkjWGQevu8e3GEadv5YEEh9X6UcbizWp1fQPnwelubi+PeKk3OIMRw0S6D4h+sF9U0YUZ1sldynDzn4Cz9rcUwGs8y6qhJbX+WMs+yTaXr2P0kcCy5vOX6PtTAV1HPQIZ+IzmHWp521zHKhEqYor5KDXcKaocfNkTLVCJLTlIdxbxFewCAt6Tnha4w+Weco62
 7xS+wzXO
 D8mdYMkn55nlzplPv8yW8FSJZBdoAieytjq9ceu43ff3mZehWhZ7dCkbdWUPr4vh5t9u1mC5ba+r8S+WPa1DMtUGd3Z6FxaB0tvNk+Pe6oh0J0IBMGjtywbGwQLDjmS8HMTO4t9QAL1METzDtmUItStZT+Y/Nm08DpWWq6y44PCBqYPrqztinKDIWPwIjz78O66NyB2FPLVMzIRBB9fWog+tMoaAvRy7Smbx/IP8HjZqYQG7x+ZgEYyDTYEUWDb/SxtgsTT2XDuCKFKM/owoOA/L/cUvqolDobrjUlOLOEk86/aEFRbOmjtde0DgfFOWMlkpckHuCB+XemnnWuMenr9ONyodx4KMQ9imcqzeF1CCmqLb/FCWBi1/iM/cQ9iCGj0k+lHlOSQx3KDdr4GFF3/Sbzm68yECit1IS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026, at 23:09, Christian Schrefl wrote:
> On 3/26/26 6:30 PM, Miguel Ojeda wrote:
>> On Thu, Mar 26, 2026 at 4:18=E2=80=AFPM Russell King (Oracle)
>> <linux@armlinux.org.uk> wrote:
>>>
>>> I'm not sure if this is still true, but I believe it used to be the =
case
>>> that the -linux-gnueabi target has one behaviour for enums (fixed si=
ze)
>>> whereas -none-eabi, the size of the type depends on the range of val=
ues
>>> included in the enum.
>>>
>>> Certianly, when Arm Ltd were proposing EABI, EABI had the latter
>>> behaviour, and I think there were cases where Linux used "enum" in
>>> its UAPI.
>>=20
>> Short enums? I see `c-enum-min-bits` in the armv7a-none-eabi built-in
>> `rustc` target, and indeed:
>>=20
>>     #![no_std]
>>=20
>>     #[repr(C)]
>>     enum T {
>>         A,
>>         B,
>>     }
>>=20
>>     pub static S: usize =3D core::mem::size_of::<T>();
>>=20
>> is 1 for that one, and 4 for the other.
>
> I guess we could use a custom target spec, but I'm not
> sure if that is worth the hassle of adding another one.

The kernel Makefile forces the Linux enum behavior using

arch/arm/Makefile:CFLAGS_ABI    :=3D-mabi=3Daapcs-linux -mfpu=3Dvfp
ifeq ($(CONFIG_CC_IS_CLANG),y)
CFLAGS_ABI      +=3D -meabi gnu
endif
KBUILD_RUSTFLAGS +=3D --target=3Darm-unknown-linux-gnueabi

regardless of the compiler. I think this should be safe
for any combination of C and rust compilers.

     Arnd

