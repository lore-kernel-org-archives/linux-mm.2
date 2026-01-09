Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48FC0D232C9
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 06:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901E66B0088; Fri,  9 Jan 2026 01:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8F16B0089; Fri,  9 Jan 2026 01:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E67A6B008A; Fri,  9 Jan 2026 01:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E67B6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:46:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02A031603C4
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:46:06 +0000 (UTC)
X-FDA: 84311490774.16.436C83D
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf27.hostedemail.com (Postfix) with ESMTP id D1B0F40011
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:46:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=FL1EIOqN;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="e DIdxhQ";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.136 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767941165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcpLjbUUzr6hWX16ZbkqNNqxEJmALGeA88q7/vc3Tno=;
	b=PlGZrZw+8wX8Xxj3XmmEqXY7cFJ6POthjYvOK6FMgGwoalMaAxRqhlVDdIKTDh94FM1Fbq
	pi8g/YoocwkHgKeGh+jKp9deniDeGQmrr8RnkYP49Tz5QUYvC0qtLDzkGBadMKyQKluxF8
	w+Y9lCQG5s/93+nn9uTV5XKxHdteIV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767941165; a=rsa-sha256;
	cv=none;
	b=HZhex1SCub9LdeGDedV4W/7xxlWOfZGaPt0AhXj+yyrXmwVwDVdPb5wUiT3CDJA/uiT0vw
	G80nRCZsnclSMXl+dgkm2iodIkuxrvzOO5JLCyWFEmS3wJWVVeK521FBI4MqjzKrp4Gsn5
	q91bIf2v8vIVtvah4bbEuBO+Y21U/H8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=FL1EIOqN;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="e DIdxhQ";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.136 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 5E7C313006F9;
	Fri,  9 Jan 2026 01:46:03 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 09 Jan 2026 01:46:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1767941163;
	 x=1767948363; bh=YcpLjbUUzr6hWX16ZbkqNNqxEJmALGeA88q7/vc3Tno=; b=
	FL1EIOqNDjCoxZtxJZlPMTUcImjeFYxI5GvoXxr2aINNF5cJvBP6qwld1HmI5IW+
	lYFq1rbGYWIJHBHvvUxeF/W9V5IaSdAi4dE2aAdnXv8DIf66GasTGCgrcKsaCIxB
	dL+QZu8x8OdLBlsLjiKXov5DfDEgPsstqsyqyHNLBLukd1FKFGslaAX2QujTUHM0
	LhD8JDQzEzSlOwIQOBQt5HQMIoDfyDpzlucoVtFJ1ZGu/KW9Nlr4EbrzZflwP1QG
	Tezrn7FNxM8Sl3ZCDg+TYZHX6m8wDi4Os3C5ATiACOdj/9CR/GnhKtNoE60njC8f
	DD8m5pzOJkpB5kGcmCTGlg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1767941163; x=
	1767948363; bh=YcpLjbUUzr6hWX16ZbkqNNqxEJmALGeA88q7/vc3Tno=; b=e
	DIdxhQGenKWOA7r2WA6JIwuAZcouvq7tHPMOxI2Vl02A5XqcnwCkBW5iSwudYchf
	b/LfTjQjfv53enrbnv0PCeO+8766eO4Md6SjbFJzjhEmI5Vs2Aq+Ix6TK36WRej1
	NYxh08tROHtV7RXEWcyfEUU+qHbdFz25RSNCmCgcR6/A1/Pg8/i3wdJqdl6+aaHH
	r7P/Xw0zIVM234NG0Nois3RlPkQakllEUezxzFfV46CLJ/m3JkJTGQMqL0WS3zbp
	y90yfhE0muARRkXypS5d6NfiYLGplpId0XDjO39dlurftMjElCgisB1mSMRk+R4Y
	t7Qi6EU+ZtPlmE9XDKyCA==
X-ME-Sender: <xms:KaRgaa3Khu8_p__hPiKoYBztmrNDDM3V3caVmGHhybWbL4kHmdWlKA>
    <xme:KaRgaX6Nhs_HPUpYwdFnuUNIR8Qlz9S3P2s6MzYIbXJEf2OuBnSAzv8_gEALYQ7WO
    sdk_8RuaLyQpEOm_RkKaj93gWBHDZeNux0H48_5icdruZPSuzDwwI8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddutdekudefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepvdegpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehfvggrrhihnhgtvghsshesrghoshgtrdhiohdprhgtphhtthhope
    hjvghffhgsrghisegrohhstgdrihhopdhrtghpthhtohepkhgvgiihsghishgtuhhithes
    rghoshgtrdhiohdprhgtphhtthhopehprghlmhgvrhesuggrsggsvghlthdrtghomhdprh
    gtphhtthhopegrohhusegvvggtshdrsggvrhhkvghlvgihrdgvughupdhrtghpthhtohep
    jhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomhdprhgtphhtthhopegrlhgvgi
    esghhhihhtihdrfhhrpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdp
    rhgtphhtthhopegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:KaRgaa_yBMDXZQ4y1lytDTjAr6MjULMfC2vgxAbsR6lYDq6gYyrsDA>
    <xmx:KaRgaWKgwa5_pl8-4Xf_RzybCaHYtGE9IWzYYAKHh6SbxDJ0m0-4Qw>
    <xmx:KaRgaet70oQ_Z6JYxhhHOUCt4-WXFLuAehhs7adRoLSY9MIGOthfZA>
    <xmx:KaRgafkTOgh7fPXAV32jOzTZvLv7dGYA9ncAUIORK6M4rxxTc7lj3A>
    <xmx:K6Rgaagi4lhHKnxarQtcvcbjgm74mUyWlKC9ayZ0QvbAud9-HRnSgaSH>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 65A02700065; Fri,  9 Jan 2026 01:46:01 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AqT2GkHpMKdg
Date: Fri, 09 Jan 2026 07:45:41 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lain Fearyncess Yang" <fearyncess@aosc.io>,
 "Huacai Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>
Cc: "Kexy Biscuit" <kexybiscuit@aosc.io>, "Mingcong Bai" <jeffbai@aosc.io>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 shuah <shuah@kernel.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Jiaxun Yang" <jiaxun.yang@flygoat.com>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org
Message-Id: <08f257db-5fff-4707-b89e-d62b7d592143@app.fastmail.com>
In-Reply-To: <20260109051054.188030-1-fearyncess@aosc.io>
References: <20260109051054.188030-1-fearyncess@aosc.io>
Subject: Re: [PATCH] loongarch: wire up memfd_secret system call
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D1B0F40011
X-Rspam-User: 
X-Stat-Signature: jeyy45ceumtp7qfsn7yu3mppafwfg4qk
X-HE-Tag: 1767941164-875781
X-HE-Meta: U2FsdGVkX1/QK3E3qM1lks7wGfFmVXboR5JYdqd1WXlhDlvojY9cEma/kQregrpZn13TUqwlS7R8JN0DSx7Jl4FTOWMKkRCjwQg+l6QMmdcF8ea7VIymLIpv0xAxZwy8Gtkw6WTTbNL2OdwPZt7w+xrnVM1MxsKy07jOlUg7815BHESoF6FfLqtdlDbEOoTp2Ch2j/ErGEDXz340CB4OJmbayjxwBI7xlr+Yt+SdDYCGHgkpvQ8q42HXBvcG+mrgJ2lcwqlMWgosRUT9koiZCNcYTSIItLRlbNpu24ypNMikUD+KtnHFGR+ieWGmxthZMgzK4wKBnkci48EPLtU3uTZAb6Ue9ThuXHcZvRzNmhomo5yoZWHrzfY8bi3XIlTeiYHvP0l8tiFv7hSsbcucOThUK1hRB7AZy+TR9xdjgkcAxxl95YeucfOqZyO2InHrHeY+O9GyUlLGvO0VGFULGFWYZUmw1Cjx/5TRje+C9sMDVdU/hF/VC86Lr5xg2towwmywYqoAVwBMeeayXEU4vvPddbJGjBQKNseUHy96FIrNvx+396BKRi8BtRVT3XerCXtEvbeSKX9IP/MKD0eYJl/3wLP5Z93R+n51+jHy2Iu0VLjBnHhOtLNqEjntwzapihGsApRKBmSI6HiyspjEIz/3lymlxWZu1NWK8OAEcw4HqbklbsLFN/1PD9ttRvlIZlPCasablGMV0vyhFEAsIA95gXngYlfTU6rqKMdllPMWPev0NmOyGKS3lojAfL/pPVEoM5U+4WSJ2k92DTpq1RjYzvykJ2OMjGSLdCN/swo87x0IPP5DZSlp9juOPlxk744xNhrVY0gnHH7O20e91H0L0vPmt8twvsaphpXrNjquImSlsW0sXkx9HcFftSlSxX7HeT5Za3udLmIKD1ZhAF02k7VGJ6Zdiy2O2Tiw9dsBxKdnZaARmPYIe6H/sMo4AJzx7jha0FnFSd0RxdG
 uNf+2JB2
 qBMMFar1cBypd95txrtD5Ff7Ss9kpBOuqfKPfjQcyShn5U+UZpp7ExwmU3hNbBOIzWO0XFUpNKP4bUIHbKh6VCGpp+ig998WpNp9qhl9FB2JzjcF8kfVx5eP4UIrygTpjgSMcuB3A3sB4eBvWGG/JrRzG5Zj57cTpb69ila5S9n/o7gahuUHQLqTINQbtIKbXiraFo6l0XFiawlsUIcUEXmdESAtK2fatDexq0zrQktUbatuFJubDD9l+gOM9DaV8YEAXVJ3dxAx1hfk5BeQS5xEMpx/wjNLr+jxzzdwT3oTtCmwu2LqNbTCZxV9GXQWb1ZizbhnmWzVHg4HzSTpOEI7mQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026, at 06:10, Lain Fearyncess Yang wrote:
> From: "Lain \"Fearyncess\" Yang" <fearyncess@aosc.io>
>
> LoongArch supports ARCH_HAS_SET_DIRECT_MAP, therefore wire up the
> memfd_secret system call, which depends on it.
>
> Signed-off-by: Lain "Fearyncess" Yang <fearyncess@aosc.io>
> ---

Acked-by: Arnd Bergmann <arnd@arndb.de>

