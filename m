Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686D910AB827
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 21:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514896B0005; Thu, 26 Mar 2026 17:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC616B0089; Thu, 26 Mar 2026 17:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4026F6B008A; Thu, 26 Mar 2026 17:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E41D6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:33:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8A011B93C2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:33:56 +0000 (UTC)
X-FDA: 84589516872.06.A769E7B
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9E0212000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:33:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=IqMDVtdy;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="L Lg61lW";
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774560835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RfNIxQKYIUQw14uhGh95D145k5nMWsOXW6Q5/pdSXY=;
	b=R2FtmyuoXVO2gnWQI+QWy3rdMmzlyRmO+ZkU+1oLn4VO7nMla93/u9VvJrOfYKM2dgijA1
	PCP2Zxbkck9+lmHbH+9HC1Q09nHgPn7o3VDe4YjjlydMKXFgA/JQE00veh6gvswp5ZAIUX
	XPLYIYugvXQQN2OMIuQmaCodo8GTVeA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=IqMDVtdy;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="L Lg61lW";
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774560835; a=rsa-sha256;
	cv=none;
	b=a+iPocAjEKOUbb2Uni9D6ouR3nPlwtkFcXsceOJFyWVTGnvNKA0jfSfzFx7HGD74PAKMMu
	UEMeWoo1nBuq8HiCjGQlgPaY3nMIdWBrMELSM9eXq4uLh2mNhJdUimcdwGIypSAuT8qjmq
	Ry8nnXnWDVC9tY2+Ja0fGTyqU/hjgW0=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 539C31D00217;
	Thu, 26 Mar 2026 17:33:52 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Thu, 26 Mar 2026 17:33:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1774560832;
	 x=1774647232; bh=/RfNIxQKYIUQw14uhGh95D145k5nMWsOXW6Q5/pdSXY=; b=
	IqMDVtdy9g3dNXgBMcJk+Fp8v+OY7nMFAksZR5I3dKQs/pgnaPLGfcCyGhi4aVyc
	s89Zcud45a2CiZ9yyMK4PuF1EOB8yUb3WVnIvT4GofP2S47gqvcYCpFmJOfaK5Y+
	KOc+agOMOn6DJ2PfKjMqOMaLTktYz8TexeDDdslrrZ3Y5yiTURS/f35oGGD+09Y6
	sXrfaZKwKn7C5lupvsFmk0x81toqerRu418G0pUGq6hC1uP/9jYxwWbyZf+bazou
	6XnYpjG6S0tQVQAdhhBFbX8WBzAqxLBnZAjvxsLffwRfy/BTApMN9h5uREDwD0zQ
	m1wi5i+tYDinsj7+okztaQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774560832; x=
	1774647232; bh=/RfNIxQKYIUQw14uhGh95D145k5nMWsOXW6Q5/pdSXY=; b=L
	Lg61lWUQRpa5QRAliKcb5POX6yAcwUI0CN1HB0waBRaDhO0KKDghAxEPcbdyiiY9
	fXZn41nDBH8tNiGNBBJ5Mxk2Wl4Zgozj9uQK/7Si3ail04diJxgnNwqD1f16bx1N
	KA4N7tNulPLr1ULFKid2JB+H3cj5O9FBHHin6MNDLmC6AuDl9ZMFuZPbqt+J5mAS
	xc5d44SI0INI9Q4j+2/a27p/4WC8ylhPqB2qiVdtXSqzyVNHQt46QjNRHTLM3wDw
	gZtHREbrzp1lm4wQ9ROzSksT8ZUVo1lNiKxBBMO98KVE1JjBSkCG8SQSvO8h0Vje
	vY3hn/uAhrdrVmoZMWaTQ==
X-ME-Sender: <xms:P6bFaZLAEEBV3bwCDeAZPmOSFJwnzpkHCftpSnS8W1WdOa0CTq6GQw>
    <xme:P6bFaf_9S1JQLWU0MdN0d9J9bDLLmp1dF-WUzWA4LusG4x5Pn1IejQHX74hxqxXZY
    bTc6bEPtn7nGWANqBVfLEHUSFUZyNR5skKizikSigPJc2R8Qfd_bW4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdekgeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepvdfhvdekueduveffffetgfdvveefvdelhedvvdegjedvfeehtdeggeevheefleej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepfeelpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehjrghmihgvrdgtuhhnlhhifhhfvgesrghrmhdrtghomhdprhgtph
    htthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohep
    mhgrrhhkrdhruhhtlhgrnhgusegrrhhmrdgtohhmpdhrtghpthhtoheplhhinhhugiesrg
    hrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegrnhhtohhnrdhivhgrnhhovhes
    tggrmhgsrhhiughgvghgrhgvhihsrdgtohhmpdhrtghpthhtohepuggrvhhiugesuggrvh
    hiughgohifrdhnvghtpdhrtghpthhtohepghgrrhihsehgrghrhihguhhordhnvghtpdhr
    tghpthhtohepsghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtoheptg
    hhrhhishhirdhstghhrhgvfhhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:P6bFabzGQvj2wxAZfO7oFq_v1ja8RKR7HYucMtfA26YKLazWNFrATQ>
    <xmx:P6bFaYrjXYtdlUeYWsmgjMA4oDcGRCKW-jMdtK9pnhtU3nqkJuf8Wg>
    <xmx:P6bFaRzgw_OcbHg_6LazXrPsPveaVBX5aOIxtPlylfA7b7UQRUcdjw>
    <xmx:P6bFaaol0MvBm8Edvwg7LeY9Kw5WWM57FN7B_4SvuL6j84f9MqF_Ug>
    <xmx:QKbFaY2XZ5RWYMQAUukqG2sMMwP8B1UHXdInUhfkcbGuv_wfeoAAs7Wj>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6AE92700065; Thu, 26 Mar 2026 17:33:51 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AUJnWW6OA6Vc
Date: Thu, 26 Mar 2026 22:33:14 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Russell King" <linux@armlinux.org.uk>,
 "Christian Schrefl" <chrisi.schrefl@gmail.com>
Cc: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>,
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
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Message-Id: <641592e3-2354-4238-9eb8-a1f5c2a13126@app.fastmail.com>
In-Reply-To: <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
 <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D9E0212000F
X-Stat-Signature: t8ocanbyffm7mwmdktu98ebsyyf8zkif
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774560834-43627
X-HE-Meta: U2FsdGVkX18HMfuuNmW7QqDltuXIdPpm8lHq9xYqSjHIMvEgJcM4jdoJVTFxdIGxn2A6HOgDas2AWY9jQ9gQRnRipIAtdth1RADu8d7Dsq2IwMcZ7xRPJwuP1jKXhe2Vfg1Acg2oqFoeagFK15WTxWv3vJP61sm0g4OKZAnqRqcjppBrzYKBnI5basNiE9/uiqUYi7m6YZb/1v712xmsn41f8fxGVLvfTdZI5x+eD8nZPdjMrb/YxytjJno0Uvqdb5valZVwQ4Q+xOPkTawM4ACHiPIzW5IvOjm/8hM/Jg8L85k3SkntgzyZHXwbHoynYXHJd2IClazf+tIfrQf2aEXp4Zlu3YZ8Fu8egEMPJ/k2EcoIRtf++YS5cBPj/tsUCl2L9gXTnx+TXbZHS1yqG4vn7EEzrhwvQxrqn7NLbHqCqQssjMAmKUqc19U/izlbQtEkhfLz1isxbog2/xHE/geHjv500UuZeA3QY09iPAj0wYJPYm52anXLIzbekhhf9jtZ8Savm7+ujOVJL+SmJ2kVFRyRCwDZOTRw1W7NQoBKe3IUasAakmnpkCle8erSzWMtJ3Lq0Fp3qZ8HfFW2xPxZOILFuGPC6FNspWezV3ReK7aVbzpnRXdQQNZVq/Uf42vSubLdHU+wZt6B3Lq3v0FJtvLuGfpPHLAFiKE3DfQoz1AIAOcV7YPbmHOyidNLaxfo90RSmVlut6js0o8+SPgjuUCKz7ch310v/N4iROB+u27jUGGfWkLKkKd4H+iibjs8AN3dB6Dp8yuQLsHrXMecrZ/G0gLJEXC03A7MC8/Ah9xgbjFZuTmTHhBFi/SBpTUiZCm3J3YiDSATVgcgovGoWQW0+/Fq+1cTnuSrN/qzTYQlgkFSdRkeg6sz3F3iVmsrj6j8DxDiXLGNOjJ0cCDZ52AkUGgAQiMT4RD34Yy8HPlwuv2IgVtoaQn0b22455jv1C9a9metivwSrSw
 QAg856YR
 t8J/1Bq8uDWWBV2e0QoUTSsqDBYkw3yRZHT+5d3Sq7yeHqiOQlNpckqtar0p+aCYx1ycvUXCZLsI/kHleuSslvaS31+WXQxcc+cjRLrQI9o91Nd+lRv8I+6Q6sUMylYJSxcDUleDMFgKfI3yKIV52VYRqAGwlv4RgAqPareZ78SMIxw/GXa99f2ppoGqFNekGCQcF2yVPoAsPz9wTfx3Ma3nzQamOG9jRBsym3VKZ33O0IDF+AnS3/hewAa2Lvm7A2awJfTVTPxmkg21y/9yk1ZpJYke2RGamDqfmHZzbobgDdTcWbpU5rmBfbzSbBSRc32SKN64pzWPdxs6XkcQzbegQsYxBts04zctgrCybKV+oLRML3O6Azkm6dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026, at 16:18, Russell King (Oracle) wrote:
> On Thu, Mar 26, 2026 at 03:31:26PM +0100, Christian Schrefl wrote:
>> On 3/26/26 2:47 PM, Miguel Ojeda wrote:
>> > On Thu, Mar 26, 2026 at 11:10=E2=80=AFAM Alice Ryhl <aliceryhl@goog=
le.com> wrote:
>
> I'm not sure if this is still true, but I believe it used to be the ca=
se
> that the -linux-gnueabi target has one behaviour for enums (fixed size)
> whereas -none-eabi, the size of the type depends on the range of values
> included in the enum.

I checked Debian's arm-none-eabi-gcc, which indeed still has this behavi=
or:

$ echo 'enum { A, B } x =3D sizeof(x);' | arm-none-eabi-gcc -xc - -O2 -o=
- -S | grep -A1 x:
x:
	.byte	1

and I see the same thing for the hexagon target in clang, but none
of the other targets that Linux runs on. In particular, clang always
behaves like linux-gnueabi even when targeting plain eabi.

$ echo 'enum { A, B } x =3D sizeof(x);' | clang --target=3Darm-none-eabi=
 -xc - -O2 -o- -S | grep -A1 x:
x:
	.long	4

I noticed a similar issue with m68k-linux, which has a bitfield
alignment different from anything else on gcc, but uses the normal
behavior on clang.

        Arnd

