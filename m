Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3D4FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 09:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCBA6B0005; Tue,  5 May 2026 05:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45C56B008A; Tue,  5 May 2026 05:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E5A6B008C; Tue,  5 May 2026 05:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB9F86B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:23:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 59FB11A044E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 09:23:08 +0000 (UTC)
X-FDA: 84732827256.06.FF3258B
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf15.hostedemail.com (Postfix) with ESMTP id 590B7A0003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 09:23:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=TGahYX41;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g OE2h9w";
	spf=pass (imf15.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777972986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltI30Dtv2EeBl4uh1GQDYE0C2hnH+4+UiBm7Dg38Mzw=;
	b=6lGL4TNBKIR9DW49t5Jtk4Aj4JKYY+N50Y2MQTSiXaZF1tZWUlEBx1o9Exld9PdnN7/zc3
	jwzwWNLGV8TlArN0IouA2IgZF09ELOPwaiu6Nd5UeGfyqPc6JQR+fkxlA8BZtiBjPc3/rO
	tDOoTA6oirmcZl0WVVs0gFpIqTBKItQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777972986; a=rsa-sha256;
	cv=none;
	b=Bg0mtK+S/ZPKQPvy3EMKA5Ja5qlh9gUPLjQFChcU0fb96OKuHHhhTpYKp3KHJuy2HbyW7m
	9Pt2UBv0S9Pc2qjwlJroIZDpvnHrkyax/wbo7/he4BUj571y23CtoGkMeQkUY1UJIrAD3S
	2R1aoqaIe+qqLBmFhoMz4jPzaWXlTgA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=TGahYX41;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="g OE2h9w";
	spf=pass (imf15.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id DC8941D0007C;
	Tue,  5 May 2026 05:23:04 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 05 May 2026 05:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1777972984;
	 x=1778059384; bh=ltI30Dtv2EeBl4uh1GQDYE0C2hnH+4+UiBm7Dg38Mzw=; b=
	TGahYX415CxL5YI6WvDSnEqxlqLc3XQ7di40bpVvkxee7sbuC8kOgPCJmmmIiLDe
	SScVJQ4/gYBIm13s6mx1qjkFnBDnA9AKScfIAqQbHbCkxs7iUgO+0KwDzEwAt5c0
	YH8fF4Qf3ly4S6V1komZC6XDb3uxwEOHR0VRV6AjLMbX6FdKq7kQ5SW6lS+CQaLF
	PBB+dPNKpJS82slrQxfD6kPzBpOhoGZVBWJlsyokxTyhEzpOhPtvsmD6yyFYHgjS
	afRTgjXgzT7MKIT5AuQek6mry8OzBk+7uBmIrkBZX6Xf2vj0T5DggSYIODzFb5gA
	8eXEPVMypJvq1y5C5y9l7A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1777972984; x=
	1778059384; bh=ltI30Dtv2EeBl4uh1GQDYE0C2hnH+4+UiBm7Dg38Mzw=; b=g
	OE2h9weXMV3471p2mfh2QA24GdcBg/K1B/LbYMcd0bPDEVyS5RPfHpp9ygF/vUgG
	w21jOxXkZXDaD/neg3jgtsriIgjniPbPQN6qja8E0ECnwxILBT4h6kp8i4KVQZ7u
	6OLi7QW4LnfAczCfkQYwlZ6opSOxONvwYJkaRurVZLOFixk63zrUbv4aYJSTegAz
	W2y65psyiiA2jouedOkqrB7A1Q2fXUexe/2aMw/Q0k79KDBBIugjTzHt18YAzwof
	D9WPxagAskqn/cONrNU5sDoPIjwXM4CTJlOzwdYTOaMK5CLx5VDfau8BDVYTsSel
	mEARjFidTvchr393MhS9A==
X-ME-Sender: <xms:97b5aekrUe5TtO731HpJUO1T6O7V0OkgI1OmxpKqKr667lZMbchEsQ>
    <xme:97b5aQrcXcrulufEQ28qxA1yGgQQBH36ry-PxMLLiL285jupXL4JBuMjEB76Qd_qz
    BNYe0jHspEGIl7c3k10B_ofrr9pZdNikX3Djbyi4g4SruRX2A5Q1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddufeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepkedvuefhiedtueeijeevtdeiieejfeelvefffeelkeeiteejffdvkefgteeuhffg
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgt
    phhtthhopedujedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepnhhitghkrdguvg
    hsrghulhhnihgvrhhsodhlkhhmlhesghhmrghilhdrtghomhdprhgtphhtthhopehrohhs
    vghnphesghhmrghilhdrtghomhdprhgtphhtthhopehjuhhsthhinhhsthhithhtsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdrtghomhdprhgt
    phhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhirghmse
    hinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhgrth
    hhrghnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:97b5aXut2MOjsdhNR4grrUbo68oGM-N9PLM8XSx9Yi8Yqrwnz0TGfQ>
    <xmx:97b5aZbduuKJ1ji2iLax7SXnwkeV2R1km36VBZ-kfPNxR37S_Fof-A>
    <xmx:97b5abEimqUHs66Ze6SQTYoh9lY40aEqWwTROmE7M_4mhRcZFUv7kA>
    <xmx:97b5aUqVeSSRuFkgV_vG4DhcERLx8kQYOIDuoi8iDuQHsPx29x1F1Q>
    <xmx:-Lb5aeZ8G-Y5BKS6jU4qO-10PKjjgO6Ib5T2WK65pGWZyqPKHREEol4_>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C545B700065; Tue,  5 May 2026 05:23:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A79HWrF7w_-Z
Date: Tue, 05 May 2026 11:22:13 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Rosen Penev" <rosenp@gmail.com>
Cc: linux-mm@kvack.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>, "Justin Stitt" <justinstitt@google.com>,
 "open list" <linux-kernel@vger.kernel.org>,
 "open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Message-Id: <add152a5-09bb-4c6b-a17f-da3d817b93e9@app.fastmail.com>
In-Reply-To: 
 <CAKxU2N_moR8bs=NLUcW054a=oHB--4i+M5XKCBNF9LskYcjAhA@mail.gmail.com>
References: <20260505010112.645361-1-rosenp@gmail.com>
 <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
 <CAKxU2N92s06-L0+e=KZ7EbtU50tCpaCk2MYJD2xTFEHEsAhXUg@mail.gmail.com>
 <df3e889d-ac8c-4d11-a5fe-8ed2769953f0@app.fastmail.com>
 <CAKxU2N_moR8bs=NLUcW054a=oHB--4i+M5XKCBNF9LskYcjAhA@mail.gmail.com>
Subject: Re: [PATCH] mm: move phys_mem_access_prot_allowed to header
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 590B7A0003
X-Rspam-User: 
X-Stat-Signature: 8aruudnaz5tmrny418xzej4w1sf4o9qi
X-HE-Tag: 1777972986-310726
X-HE-Meta: U2FsdGVkX1/c7vdZ0T0tsOqlerPAMgmJEOzpSY8BDX3KcZP5W1xj/MjUdTJgvbND2DayLEyLCUragG215qGFeFpp7+xPvlVqAV/8nnSp3J/pLXVoOZVcx6Kzcutqm3CEgRvbEvz12NY1jOV+2ieI115vWqD0o76GKImyBgvEzpmsA779mCAxnV6h2b4y4LBkZrBZMFXDlDW478EA6F7vP9z+/SEE0yOcMDJzqA8ukK0x7qZQeQCfYIArfbDJIZrNEZfWeTcLO7ziom0fsIevx3Mq4H0pkDArE8LfQ8ZdhmU7Qxm01y6r2E9Z9tKwaayQE/L1CZLXI9qXpatlWsWvQ1Kl1+CsWqsDPZWq6soA+AJqz0kzDkb1ey2PDQg+L3aJc4WDuvu0nOBMuMHPP5rl7kYd4uZhmaoxsf5fHwZYlfgM19R8raLjKivv9MvmvRN/9sZYVY4cr00UKmMSUz/nJAy8RcE0DeNQWid4buo4kVUpt8jMQo5yfDo5s71ZKAhqxX2d92McYoxmu6I77U+J/qQ7N1upUEk6u4lr8Ay5PCDANLFHW6Y7F+brxINuoY+2/aI7jIBar6x00A3cqp6mRfRxZUyI61iF2dbL9dOvMRoy0iZXthDDs3mNdHj0PTrgq3oZHPhqVp2qKclNfOH/04jtTwzH45cC4qw9tC5+HX7jUaV6MorS5n7wE0fyu6Y+Ewrapg8p7gwkZd9hLk7sW5aOsSQELrPHQWjE4D5kEryeu4vVQrN9+sVsTboq5AYIzNVk1c5xEOIkwInbJRB1N/UallRgfPoSK6jObDdDT6iR4H8hMOdr2F1QHOjfCl8MyL5QZMq3o/l5HY51Ui17taMDFS3pcd77eWbyNaqwJfw16YtWC0HmSp1I2VUHZ7tPk8fTf4Bm5pOXf07CR306kxummeN3H04DT00NOx3qXNciHOahrcAmD5wzSrOVJETUgT0aMHIrdTFApgFFCpC
 5EOQvHGa
 LdWcTDtJMRJIhSsUFItiFw2mkSwFLRqbnt7vMF9ZfIukFEPa02KaCKDSl/tCO1slArmSdXWl4bjq85FJHrnsGjrWGEVhx2TeUxGPhnxsfm+Xc9+LIXy+mgBdOGITHcPh7UddqFhbmwXEaSzicCxgBxkrs/zDO40lwdfKj23xk3VVkYOHuPJAS3lrBQtZCSp8P7KTqfpQ4Q/VPGTSLm7b+/T4iv15LCqnczvWH+1mzsgcrZ12JgNE1IBiTG7V52L2LUHBxMoGMZL+JuErBiER5sU/M1Bw9tAKHLP1F2a+0DQuaulEKs6yhpwC6OCSWIY2LOFc/KW/D8XgHozjNfUXbLmaeN4FTRjA54F9/EDXoLnxmHp7MC+2lXWwIF//fXx85+mBnzIvSMb7mUJAXiOPOHTVj5t/0xqjV9m+ICmCQ/AMSVLB3F521BdPeDfMa7Ipbj37E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026, at 10:54, Rosen Penev wrote:
> On Tue, May 5, 2026 at 1:29=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> w=
rote:
>>
>> Does this happen with both ld.bfd and ld.lld? Which version of clang
>> and lld are you using?
> clang version 22.1.3
> Target: x86_64-pc-linux-gnu
> Thread model: posix
> InstalledDir: /usr/bin
>
> lld the same.

Ok. I've tried to reproduce this with Nathan's llvm-22.1.3 build
from https://mirrors.edge.kernel.org/pub/tools/llvm/, but don't
see this problem on mips defconfig. Are you using a particular
configuration, or do you see this on every build?

> I don't specify lld explicitly. I assume LLVM=3D1 does that.

Yes, by default it will use ld.lld. For cross-checking, you
can try passing LD=3Dmips-linux-ld.bfd (or whereever you have
installed your cross or multiarch binutils), which should
still work just fine.

       Arnd

