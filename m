Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352AC10D14AA
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36F36B0099; Mon, 30 Mar 2026 08:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7846B009D; Mon, 30 Mar 2026 08:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF7A6B009E; Mon, 30 Mar 2026 08:14:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 794516B0099
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:14:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 268AD1A05E6
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:14:16 +0000 (UTC)
X-FDA: 84602621712.03.8D9E8F1
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D069100011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:14:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=P7DKvh6S;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="C Seh2nn";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.142 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=P7DKvh6S;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="C Seh2nn";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.142 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774872854; a=rsa-sha256;
	cv=none;
	b=CD5a1HeRZJfZgpUc38vHoKfkYUwQzQe8bhD3SvBDb0bw38Pi03JnRkkgzBxs5tIWleRhjR
	WPINNx92IwPPigpTUgyL4qCKoI+QZWQL350D8oiGkYuFgTSqFILV07Zz+qn5i50r2C/sBm
	DHUaFS8MePoT8NniOOYfkgsc72HK6ew=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774872854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdwlRbDywCj3yrAkJeO/0XtIpUCTfBtP5P3/vuBUn5I=;
	b=Fbx/iNAVejpw59z6/yRnVn8PxGk1V7BvFkn2A+uZrRwFEtjFfLLzqDuuHfPpmh9mJMsInh
	MmC4pPXEEfvIMRULMbVOb8XQgSULa9S4ulBIMRZFpPEi2XwFH064zZxBDr7JB2ly2aH95R
	RcX8qVeHmPpX4UutZbtYJT+j3tbWm4I=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 4980C138039D;
	Mon, 30 Mar 2026 08:14:13 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 30 Mar 2026 08:14:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1774872853;
	 x=1774880053; bh=vdwlRbDywCj3yrAkJeO/0XtIpUCTfBtP5P3/vuBUn5I=; b=
	P7DKvh6SIP+yQ8R66Ax+mey6RCWMDGbu4urWvNvvCMjfcDeHvP0YiffH8SShmDkd
	4SxSv1o1EbjRGHmRrlm0eWr328vgn2tjR6V+Gej8mrtW8KMitkpBhH7fKQTqMUBq
	UnpYAWvx4osHofaLhzhsIRepEi1nUvMMzNgVSk0sD/Ei6cDVlA11wm4Rub3AAKCc
	1tzDxf7l7ufNkT+LumZKXu6VRm+ToFvfRYajH65x7pzc7sWSWSPkMhv9ZK/Qy3rp
	/uzHTYvtAjIYYdhWcpAQxxPhQ3Jxz8kr3ZhX8NzwI5ZeG1VGwSKCgw3bOaza0kko
	dfZ0O+egx6t9Pv2p7yHV9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774872853; x=
	1774880053; bh=vdwlRbDywCj3yrAkJeO/0XtIpUCTfBtP5P3/vuBUn5I=; b=C
	Seh2nn2JXXwZUw8f8LJddm9InB6NsowQA5aApYI3XFBOHhdPH2YMshSxql9GNxcv
	epUWGITb/aiXA9dXvDZKu2tQmXvp6kzG+Q0VFvADjnjyi/jWmVSLl7fdsDwQbjNE
	EE0kp//9EBPsRdCUqZjPzUnE53xY2oLaQYKHskst0s3L6xM3xCOskJaFRsHNaMwv
	KyVn9G9r8jNTv8cPTbukA4AXrspuzyS5l3edvXr/ABm/zV/ViwiiLSWVR5cK0Eq0
	CXOUAhpyf2PRQfa3aZ/yMCiA7G0lFNvlYGXsegzIKFPBrqzJYWe78jbFsBA7FdP8
	yJ4OV4ahzrQ9XRxoNJgWA==
X-ME-Sender: <xms:E2nKabkroe3a5G2UbwtgU0aJJZxIjO_sahUT_vNLUVJ9HMVoObLKlw>
    <xme:E2nKaZqnApNKJMOR735waJCJFmHKcEfK-IOTp8HUkeqX5fTx-OKK24blL4I5izmpL
    FgMug7sKNW-PkGiFVgHuALXZp7bU-29m4LSvF4Kj_RPu7ptDDdUZEY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeekleehucetufdoteggodetrf
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
X-ME-Proxy: <xmx:E2nKaVfqgC86F1-tw7SQimSjM9h5w44kWMVWMmkp2XFwLlqMNtkq0w>
    <xmx:E2nKae4-pRskTOWQlcLYnnB_E1YHAl1UlHT3b33r4Du5WsAwbmYy1g>
    <xmx:E2nKaSI9iV1Bh8Plx_WxBMHuy6_XLKjaE6QEcH_uToa4wP009fZ3xQ>
    <xmx:E2nKafNhteTnhLOg4mEmIUirggGoqlz7QRKVQR0zQRFQ3aml_DeG7g>
    <xmx:FWnKaR42JfWJ4JAPzDCCKyua_hvgCsmYAbcAMoMF7LicLihX8k5J_tPx>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7D351700065; Mon, 30 Mar 2026 08:14:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AUJnWW6OA6Vc
Date: Mon, 30 Mar 2026 14:13:49 +0200
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
Message-Id: <26d690ab-d68f-401f-ae2d-7aa4de081bce@app.fastmail.com>
In-Reply-To: 
 <CAMuHMdU-+dm83TVttfarT7QxE5ySpQ2LJ_k6oFKMWRcbaWcCdA@mail.gmail.com>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
 <acEP7tl8pqFA3tK8@shell.armlinux.org.uk> <acUGAsjYvNvTEO92@google.com>
 <CANiq72mzPpkELXis1CiSbKUmBXNQYMiMmjj-7-sYiLh4T_JSOQ@mail.gmail.com>
 <9cf5a94c-0f37-446c-b63d-ddac5674d220@gmail.com>
 <acVOL5Psz6kHlhq2@shell.armlinux.org.uk>
 <641592e3-2354-4238-9eb8-a1f5c2a13126@app.fastmail.com>
 <CAMuHMdUUfVCBZFi2WoOYibJLVnyPY-joRDJDowgHwjN_DGeEzw@mail.gmail.com>
 <93439e91-cf81-477b-b880-a813bb01ad7c@app.fastmail.com>
 <CAMuHMdU-+dm83TVttfarT7QxE5ySpQ2LJ_k6oFKMWRcbaWcCdA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0D069100011
X-Stat-Signature: 8rsnye1gwrhs7pimo61jhw1nuf9ok5bp
X-Rspam-User: 
X-HE-Tag: 1774872853-258950
X-HE-Meta: U2FsdGVkX1+o6bbKNf5PMrEnlKR8LP3nHex57cC252VRukeyqLMMe+6llyH1FvcfMCM062srxMu7rUe3R+Hr0bVDNRnLTFZFu3JQkV/fFqsxax0nyElgbvCc8o3RwF0dPMPHtIEO9t+E8tmZDB/sa1KecNG+OHCshCjngpNtZbD2syZB5JG56Y2TOrPAbEWh7XIYCZ3geZh0LUigAvwiUtb3xqC5jEcQGcUM/r7FvX/Ciw32npTELdILUTY+iwP3sM/mcGskPHYcALQcg1EyjKUCrRWCIKcr+HJ5xC3Fa+Lo/izJIv7q/q8leKoo1zmNnXec6NIqnBkrU7bkyoCOpRrk0uJxNrghEZ2bRAjZdMktgKsqXVdUZfWLhB3QsCB4pEe6fkjrIrDZjhZJzfeakT7H9VJNECedLJcI5x3rLdaUedMivbQc/mvtShlDHilnAqL6oOAZeBOAx8wE9u5Z0kguSMOMyebLnc3ofBvoz3iYBVVIFwaRyGxSZNRk8CgaaBMZ2xV3gaCkM+WCyMdOcjMM/NctbL0zAy2h8S5Z5lt7j1OoO6Ece5klW78tv1JGEbI7DuIyRt4Ly30zlZYf2L4quJvCfhmz74vbdpRTuXQZNnyHQw9TcbnwF5EXBb3J8UyxGtabjkaP+H3zulBUR8J9FDCK/UeCkcmBRsAHQH2mHtUTFPbwJISssYgfp/e1W0MeUf5iQSRBPbgRXfi9srIPV8zbmHhojwMSgDSOtpvu1sosawSXlPB32QAIA4SOWtCl7xyiNbRxxP2L5JWTnmM1DyO3jHqv1U+7CJpNJMC2RBQRo4lZ0S0tg6HguGyloRpow9KSZhHjQ0A7Q7q5SKMFgOUb4Xtpd0dVxdosnrjyfj7hDfJ4dUrL+4KMAAQ2w6+PRoCI5wzPDhNC70TpB5XSsYuYa6ieNEaPeN7cZakVeGJ0NXiRrgDSFjO5VE/LyXi/hcbtTAy6HmyPrex
 M1XlNidA
 36ycKNYiZIPm5bpP7KEvoV2Deo2rpifUDgDnNNGEeBQepQ6EwgAYM+5IuNxu3IGCRtJQkEXY8wGC/IAuOW6JG5mHBv/fWT0pDdr5VuB/koz+4UHRFjb4iBH2OsoClfPyjOIsK6p4bEuzNt2dLMkSLa5AUQ7OsBUDVdEUvACalmvpaOp7eJPl7qhmUd+GwhtCgQdrtT6dFv9r+A/GJo3kVFU+IwSgAlnpDVKxjOdJtDPZKGoG6WE8W8TUE4sl63HkCk/57qiijt5CeZmOt2zNB3b0MlP5WzCUztIYI+o1nVq/t6zQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026, at 14:03, Geert Uytterhoeven wrote:
> On Fri, 27 Mar 2026 at 10:02, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> echo 'struct { short a : 3; short b :15; short c :14; } x; int y = sizeof(x);' | m68k-linux-gcc -xc - -S -o-
>>
>> this produces '4' on m68k-linux-gcc, but '6' everywhere else. I originally
>> thought this was related to this 2009 change in both compilers
>
> Oh, now I remember.  AFAIK (holding wood and a rabbit leg) we don't
> have any bitfield members spanning multiple base type instances in
> the kernel.

There are certainly very few of those, but two example I found in
UAPI are

struct dvd_layer {
        __u8 book_version       : 4;
        __u8 book_type          : 4;

        __u8 min_rate           : 4;
        __u8 disc_size          : 4;

        __u8 layer_type         : 4;
        __u8 track_path         : 1;
        __u8 nlayers            : 2;

        __u8 track_density      : 4; // crosses u8 boundary
        __u8 linear_density     : 4;
        __u8 bca                : 1;
        __u32 start_sector;
        __u32 end_sector;
        __u32 end_sector_l0;
};

struct usb_raw_ep_caps {
        __u32   type_control    : 1;
        __u32   type_iso        : 1;
        __u32   type_bulk       : 1;
        __u32   type_int        : 1;
        __u32   dir_in          : 1;
        __u32   dir_out         : 1;
       // 2 bit padding on m68k, 26 bits elsewhere
};

    Arnd

