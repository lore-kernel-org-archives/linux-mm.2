Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3170E10BA456
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7386B00A3; Fri, 27 Mar 2026 05:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CEFE6B00A4; Fri, 27 Mar 2026 05:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5156B00A5; Fri, 27 Mar 2026 05:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2466B00A3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:02:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CB12E16FC
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:02:42 +0000 (UTC)
X-FDA: 84591252564.21.77896C5
Received: from flow-a1-smtp.messagingengine.com (flow-a1-smtp.messagingengine.com [103.168.172.136])
	by imf27.hostedemail.com (Postfix) with ESMTP id 173754000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:02:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=GVzqQY5n;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="i Exk1Qn";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.136 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774602160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlE8K29BcOci/GJeK99hdrRjgIObqUNFNRdsO2zBvLY=;
	b=wpOlWSS4D6xHgz2CQaPOlLkd8vHHNARfDwhg+EGCEusBZ0uyXSrq2xo0OS7GOoPhcS4EAS
	7yqFwwBHsWVzTfXz/jDeheqNd/2VytT6cHH4YMNxM4Zjy7OSj7xe1AYr2LVwOpXl+CjWgE
	TfDMmpSbWYdIOv5WAkVG0IQ8HRQDjUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774602160; a=rsa-sha256;
	cv=none;
	b=FHDCgzJZwNEAb9oF/+7rc9BQ08eRF42IEpL5kPiUlks5N3TzHZPECAgRTzLjBgLDpidQ0e
	43q8PTHFV4JuOKUJvHDF0acVt3ln/vAfPKKvDSUzUWRmG9wvrwGSIBIreivLYlXxPBTQrX
	xwaAyy4IynliH6gCz+6+zmoB0cdBzNs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=GVzqQY5n;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="i Exk1Qn";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.136 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 4A6471380181;
	Fri, 27 Mar 2026 05:02:39 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 27 Mar 2026 05:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1774602159;
	 x=1774609359; bh=XlE8K29BcOci/GJeK99hdrRjgIObqUNFNRdsO2zBvLY=; b=
	GVzqQY5nceojm37M1XZpOPq3WUecXUQj9WVf3CfutP3dTobqmGMQjzRLgNhoVby6
	46aeZZINaK1f7YVuydM5TqNUI4j8vyRQzPpJA34i7ACZR1RSV4TO+hIb/Y1wlQAV
	e4naVPRom36f6nfcFXr2OjE1mhktO/8tDetlgDKx/ERP6X26MCzVLKwpghPIlA9u
	FgAZLJCBgZpz0FbarT4w54TicAqCn2qTr0Z2ZfdL6DznrwvGSdcVVRrirxDEue/H
	5fVwFvlMX5ysAAT1/mtv1Dd/8FtVIaDqWDOOvUgWKJ3vwJ4vCQKKNs+/aj1E6yt+
	+mz/Xbi/v8lcnLVbeJxZpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774602159; x=
	1774609359; bh=XlE8K29BcOci/GJeK99hdrRjgIObqUNFNRdsO2zBvLY=; b=i
	Exk1Qnjsvq2JnZ1+yT0ebsDIbgY2gqeRl0z1YUchEz9YmFAT5XKQHCu5+ZzfUzMA
	KUBEKUA267I42sL6kTGiC0o6muCrmy6qX1nLFaMFkw6x8TBMIldQ20mR85lgu/Dz
	dB2EG1eKMb571eSkAhGeN6NfTkTpx4Lu0/tgLzlYoDT4OZDwCv6fEL37252eYC4+
	1qR+fAEfE/kjUNCAyy4Q+SMie5NYypjDP+zkoB40j+zYPYlVZgSiYG+KFdyvrW7G
	OWPfc7ZhuIizFLxUKMgVQKKjnJY5rCQ68EF4nMVgcJw97GM4yWWv2nTfrHXCbuKd
	K8t0sfV8n6x5lC5qiobPQ==
X-ME-Sender: <xms:rUfGaePC1BrMnmTf9_OY6lvLvc1mUKp6M_A0RyuXLyRS-NOn6VKFDg>
    <xme:rUfGaXzAgfItBbTl9XynqmOmljqUaNK22QfAcW8j65Y-hka2CDyCF6HlPX-DBmYss
    eoR8l0vie_-ZAfZlP2omID4VIFPPLAESbv9Vf23rJ3uQmLsZXfiKPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepuefhhedvjedtudeiiefgvdeuuefhueehfefffeeutdeiudegleevleeivdefgfei
    necuffhomhgrihhnpehgihhthhhusgdrtghomhdpghhnuhdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdr
    uggvpdhnsggprhgtphhtthhopeeguddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoh
    epjhgrmhhivgdrtghunhhlihhffhgvsegrrhhmrdgtohhmpdhrtghpthhtoheptggrthgr
    lhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhopehmrghrkhdrrhhuth
    hlrghnugesrghrmhdrtghomhdprhgtphhtthhopehlihhnuhigsegrrhhmlhhinhhugidr
    ohhrghdruhhkpdhrtghpthhtoheprghnthhonhdrihhvrghnohhvsegtrghmsghrihgugh
    gvghhrvgihshdrtghomhdprhgtphhtthhopegurghvihgusegurghvihgughhofidrnhgv
    thdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvthdprhgtphhtthhopegsoh
    hquhhnrdhfvghnghesghhmrghilhdrtghomhdprhgtphhtthhopegthhhrihhsihdrshgt
    hhhrvghflhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:rUfGaRCaBcqc7KdntZl0FsBnvOqvRVfnzmfBbmotVoydnvBrFXOcMg>
    <xmx:rUfGaZyWyK0ItY1fAukXgGQMxYnCWlJ_ttZ9LwB67jfvcP3jcgDiJg>
    <xmx:rUfGaeUWikKeRd3kQ5HcVz8AqFZRkLvV9rX5NscA0USMCL-N4mVGIQ>
    <xmx:rUfGaQXDnwGyrD4fd56NTxM2Fq_dVcdlQpFE1HUUfNw_jSb36M81IQ>
    <xmx:r0fGaasdsr7hoeyfiet3dxQz1PzdqR0Oy-FDo6Fl_eW5_GQ_HIxB6CTf>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 95B2C700069; Fri, 27 Mar 2026 05:02:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AUJnWW6OA6Vc
Date: Fri, 27 Mar 2026 10:02:17 +0100
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
Message-Id: <93439e91-cf81-477b-b880-a813bb01ad7c@app.fastmail.com>
In-Reply-To: 
 <CAMuHMdUUfVCBZFi2WoOYibJLVnyPY-joRDJDowgHwjN_DGeEzw@mail.gmail.com>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
 <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
 <641592e3-2354-4238-9eb8-a1f5c2a13126@app.fastmail.com>
 <CAMuHMdUUfVCBZFi2WoOYibJLVnyPY-joRDJDowgHwjN_DGeEzw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 1q8z6jaoqmobdth6kzsktj16rputg7u5
X-Rspamd-Queue-Id: 173754000A
X-Rspam-User: 
X-HE-Tag: 1774602159-853786
X-HE-Meta: U2FsdGVkX187Elh2f05sNPKdaKswyIEMecphDL1YJLJ0omHrDkTuOItS1/zWJSdhskDcSCBLzBqM6QWz7edM2iGKv+wFxVzW0Xbp+uqiz1CSX7LcMZm8J4raKkfVnY+YKOrBG7JYIFUSCPUctya8vObpyxdxgL75LDF6jOTBEYifrZ6vHZLySkWceUI91+rAJn0yAIupcZI3gSWF2vP2qCSk3EO2W9M7MB4SZ2BfFYiv6+9Oywz2AmU/PzL0hTc2VbQQNErawgxae+4hqO+Z+bEXp2BvK67OXeis+VZIxE45QuocJ0afgPH9aIY+JnDLLg6IQ3RPN2Ov/8Ue96zgXU7fDf4eQUs0/UhwHORN0YzSAhDCJySbyNf6qOuLFkG+X/lhSH/HiEMxqZtkfvkPZtqsqKYqA4z+JIvL3cV38+rmjYHPbmNOWULzdITskLF8sJxAmm86NTlN9XhhaYagnRP5uGp59OOT9rTziEXurPCgrVuto+rdlmvtQtf0v5zZBJ5JwfJB97heLBpoP1Ot9RG4GdVKA3NoUpKA4YsoFc+zb1oOc4EWc1dfR/HJXHYsOgdRayLespByhFMnXFZ5jgdrKNMKPLvmpDYxkcBkL6Qvp/JLVRghkAFBtfpawoKaDXQffgr1326n3Ceq0FtU+cAxx0jJ9ZWEAQ7dNqmmz6gqwHG5gydykYErSJZRWVXA/4oEORhw3qmq/CHX0KQwi4mvam4XmqNUSfv9X4e9OP9tNBphLNzoICxKoX1ZIBS6/bdv/1XtdTflklG7IoMGKettQKiW9IlWonQAvI09xMafRbHtkigiPtBBX0lUpiVwHYp3Ur4oL4KCI4y6iBovSg6R9RVGb91L7bf+EGxeltjWco1os2HnZdUd4Lzqapb++x1ogHfiUeeAK4Z3fYnX1+mz/rSkcxRzkULE+Qrntxnv0aZdsGOgAkNc15rkKE3oOIN1n3MkRVfwqHak8Qx
 B3bPgy7F
 Nm2y8vIy+r8IVnLD5l1x98dvQAe3DIyjjOT3RsAub+M19/NnWjpHg4mUFLbdbm9sgMnwgN7ETIEUP16NCqwFhfkM7uOm1uPt2CEmT/LLTPij+79i4zbUc52X884CI05OY3BqiH5nta7lZHMSJvU+vdqETgQoOrdPAZCgH+oeaoNNqdub+/rOq+XcYcrcgXwyRFgvnd5Z4yO8DTXWS2+0/k1swJqMHx4nEOhTA5j69Cg/P2m036Lry4Aft83iacyZ+Ou2Psxazx/XbZHCQgRQ49OzT0eKFKR+Nt18/Y2COAnw1RL187Bx41Y57qx76lI3wZM4R4VVhLzMcHB4ouq0sMDLPLaHOvUAsTgGx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026, at 08:56, Geert Uytterhoeven wrote:
>>
>> I noticed a similar issue with m68k-linux, which has a bitfield
>> alignment different from anything else on gcc, but uses the normal
>> behavior on clang.
>
> Ugh, I wasn't aware of that. Adrian, did you know?

To clarify, this illustrates what I mean here:

echo 'struct { short a : 3; short b :15; short c :14; } x; int y = sizeof(x);' | m68k-linux-gcc -xc - -S -o-

this produces '4' on m68k-linux-gcc, but '6' everywhere else. I originally
thought this was related to this 2009 change in both compilers

https://github.com/llvm/llvm-project/commit/830dfccfb2c06a1749938ce8cb78a1d6a295b942
https://gcc.gnu.org/cgit/gcc/commit/?id=2cd36c22d3d16e24f342829a989ac35f2f442656

but that only allowed bitfields to be marked as __attribute__((packed))
in order to get tightly packed fields and return '4' on all architectures,
while m68k-linux-gcc apparently has all bitfields implicitly packed unless they
are explicitly marked __attribute__((aligned(x))). This behavior is
independent of the -malign-int flag.

     Arnd

