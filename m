Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E96EEA84E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 17:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28D76B0005; Fri, 13 Feb 2026 12:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD6396B0088; Fri, 13 Feb 2026 12:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE596B008A; Fri, 13 Feb 2026 12:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 877DD6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:07:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EC93B9FC9
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:07:31 +0000 (UTC)
X-FDA: 84440064702.09.2A4077F
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11A0216000F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:07:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=A1hu4c4B;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h 2jXgdO";
	spf=pass (imf08.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771002449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YT/v47LlRWqKPqDMFHr3v4dZamhJQajCeRj/cKvJDjY=;
	b=wA2Lol12kgGNqL3bpNxJbC2qG+4SofFgbAOOi8kN0h38XwmiD9AZYoUIA+PB09LKGbvu4d
	fPz4MUmmdxWGg8AD7pj6wQJYz7r976QLy+4hgUAk4QXdL0ho9gvCuT1L7dlt7xMGCiMj4e
	+Oljx0cPuGahkmAmfSwN8uyk8e5SmX4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=A1hu4c4B;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="h 2jXgdO";
	spf=pass (imf08.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771002449; a=rsa-sha256;
	cv=none;
	b=FXZ6IGRvSjm+7DCImwIHENUzoxrOjv7Ftk4BQfhtF6F7vYHBeo8dHd4PhDj2gvys1MJzLL
	Eb2C/3Lp7win2+QC/y8lM1Jk1iK6l+1gEPxQXi6KzX50g7x1/JCsEn0xXaAZqrulOVfbfO
	FTOME1yeQHz6TlUpL2Pefzp+7D7Tsvs=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 51E2F1D000A4;
	Fri, 13 Feb 2026 12:07:27 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 13 Feb 2026 12:07:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1771002447;
	 x=1771088847; bh=YT/v47LlRWqKPqDMFHr3v4dZamhJQajCeRj/cKvJDjY=; b=
	A1hu4c4BROmE8pJtCEyEdAF/O5fejVYiu3WaI1EKix1m+FmYD+y1y3VPb+4bM9mA
	SIx6UYIUKCdP1BuHMAm+Py9v/wzqWShZQT7tZyEsGX04OfmnBpPCfH8NQI07aYKp
	XgekcOpEX0YubXuS2PTOoA4owUuID+DqJZ3MzGbC1z1odUnAkkjH3apnTiUUhv2r
	bYKGtV3tfzvmz9606a31Fu/PKkg+9etbDxVtPlpR3JzqmUpB0SpWnFpnqYg3b+QO
	gKzgDElnalps7BsAun1NC+yFf5Gnr3B3+x3N5bwXMBafMhLMvUmy+JaoMeuZlJeg
	GkCEIUII5aEO7WhRjP1dgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1771002447; x=
	1771088847; bh=YT/v47LlRWqKPqDMFHr3v4dZamhJQajCeRj/cKvJDjY=; b=h
	2jXgdOGVxzzxiMOTpMWsBrqO76E63iEUltJr1h945IuYN1U5pnDjHDPOkulqP7Qk
	X8eI4ItVX3BnQxxYPhxip7UxaJjkAIkXgq/5j5HNHEUFTC18fQr3jrHjdZ7q5RWV
	S9cnGfC8GlxrZqVDJo75WInQBeBmS2oiBjLCXRyOhb6snQsfftIKHW0e76sY3Iis
	DeVz+TLtzkUaStAlFH5eb0Hnxk+qPwvs+X0Ql+DqaA4rNnnH/WrDH6L+6YuT2QH1
	3iyAjXyyVtTErld7zTm+bnK0l8P6bAn0EFKeccJGPXo1S+ksn4oX/bH0XXkIXk0f
	Lc22zN/f84guRESYEEifQ==
X-ME-Sender: <xms:TVqPaaX_lXPQVYpYORL8KBAltimICmiEd2o-yX_64kq4sE5M5EUmFA>
    <xme:TVqPaRbrNpi_jVXZthMlltbhMMfAYf-b5dIlq3e1M8CuyEcPYUL2lgKQSdrmVl_tV
    HSuamkbbwwwSIg60PIPSj-E45MNMnw9b0O9JU4roOFlPrkgGRB0drJ->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekkeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopeiihhgvnhhgqhhirdgrrhgthhessgihthgvuggrnhgtvgdrtghomh
    dprhgtphhtthhopehkohhitghhihhrohdruggvnhestggrnhhonhhitggrlhdrtghomhdp
    rhgtphhtthhopehhrghnnhgvshestghmphigtghhghdrohhrghdprhgtphhtthhopegrgi
    gvlhhrrghsmhhushhsvghnsehgohhoghhlvgdrtghomhdprhgtphhtthhopeifvghigihu
    ghgtsehgohhoghhlvgdrtghomhdprhgtphhtthhopeihuhgrnhgthhhusehgohhoghhlvg
    drtghomhdprhgtphhtthhopegsvghrthhrrghnugdrfihlohgurghrtgiihihksehinhht
    vghlrdgtohhmpdhrtghpthhtoheprghrnhgusehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegurghvihgusehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:TVqPac-6HIyzOFUWrj9IkFCALyZDX6g6KBrgAMhSsy1C2r6c7dVCJQ>
    <xmx:TVqPaco63DTcFqw0jy1WW6rsHqt4TihtMCw8hspuYTaM9OkuG_R7tg>
    <xmx:TVqPaZONdNJJg0LTZNFyt6m7rYjA19-ahoCtRUj0t_ViEVp1Od8oYA>
    <xmx:TVqPaS63OWXjEfmnDFb0oU2GnJiCcUTPsqis66cfkT1Iesmt_MJ8bw>
    <xmx:T1qPaeaDyGoTtoTn9tpcIgKFLAmZBnabiSV2nQ5-D0yPUrC7IAxtmdOS>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 31CF7700065; Fri, 13 Feb 2026 12:07:25 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A7zn6QNgbkpw
Date: Fri, 13 Feb 2026 18:07:04 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andrew Morton" <akpm@linux-foundation.org>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>,
 "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng" <zhengqi.arch@bytedance.com>,
 "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Kairui Song" <kasong@tencent.com>, "Davidlohr Bueso" <dave@stgolabs.net>,
 "Koichiro Den" <koichiro.den@canonical.com>,
 "Jiayuan Chen" <jiayuan.chen@shopee.com>,
 "Bertrand Wlodarczyk" <bertrand.wlodarczyk@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <b8f5244e-4ad8-4499-9cc4-c875121cdc2f@app.fastmail.com>
In-Reply-To: <20260213085842.0654f70a73ec05d88908ec25@linux-foundation.org>
References: <20260213123902.3466040-1-arnd@kernel.org>
 <20260213085842.0654f70a73ec05d88908ec25@linux-foundation.org>
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11A0216000F
X-Stat-Signature: f3zdocfyidn8uureewomybptxp8j3yxj
X-Rspam-User: 
X-HE-Tag: 1771002448-608889
X-HE-Meta: U2FsdGVkX1/O15iO+axn/7Zl6ShLBSwHasSrpfs1Uwp4hIQAPeZy7xcYumxhf8J919ncnbxgD0oFftiU8oqF1J0zfGOWusatIfb8JThXUBq6nwKmhelymCIU+pmSsPibWtrAtk/zkSTblaXVz5/SGvwB9Qjcb8en3vCX40O54ewHqz1G0v453geJulQVWXxxlIw40cBTBjyltWx8IaIqybP//iddcETqzcDrgvnbs0REOKKyjOKfPBVuHNrxvqPRvWnDe3lL7D6OzF+k/086IDVDYLCKwrm3RSqvSUY5uKk+Po48/Has5ihEhrnp8Eno2/0+A3obaK90d/GeNHjaNuJO1Gu5GX99UTzIFC8cQmLbtBabfT9LRBkeMPJoDPEGTH1DoDIZGWLyWeRf3myZ+I8C4oWpFlqRaL+Ume1jm9kNxptewo4lPG7p85KRWNhvR7BoYrixvvoda32RwQ18gJLU3zXF1iRg/93ilrpHgS6t26gvFZKFLCKG2v0pd06Yc3t54UXmTLXvzsrY+WyQJBQ4AX7X+dKEtEGGdaFRROR7j5zqWSQmo5iRUi3JJBZNTUa7qn12X5ceQET3R9dDylHkZ7fX66bCkwDylj8Q14h9XW2WPUl/N/A6vuFsib9LYfQyx+f+ySdQWoJeMs1ev/jchNxHnNGIgRWN8WrWaskyBAs5CjNSnydGdsSNzM1QHvIKckMvo1TfnDg+TLwmhTYEWZuQwyhWNXMPOiCqT2pzGhpFGnK1/7nMdE6FCF5kSzde4EovxVN0/KV8bUrmhvRCMTfFtHI9YQOMy+PLeo5tVdW/BubJTL8GOPNcy2PKnk5EHNcD78xuawDv2kdek+T6QIVCJ+DApB6a3hjYk/DGvFrTV1GbpunYAhQ3FLaxrCsMEkvCCt8KoF3+NFtNBUrEL0MiMYrdr31FZ026fPaioJZBTFtasA9KEpjCmgcCRYPck+zVlFtQam5XOM8
 DBZX8MiN
 SgyDul/KH7WaaaM286WQ2dzGoaTShSBUqiV0Smgq9svYtATwtjNVBifl2CnT2NUgtkbtUhNnbB9CvtqpQS+PTqfavrwX2ziQwP4qthKiGTZGQhztmnlCPj5BeayDhGCJM+4xv9yiJHlxEbPQfczXtRbkx+NyLzy8HYXTAIFsEY+a09J8Ccpe3jBAxrEKZo7l2/AiF5ll7E6hSVAgBZ45XSu16un47O08DgazLSq/2Sf5jSyro7HnazDegag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026, at 17:58, Andrew Morton wrote:
> On Fri, 13 Feb 2026 13:38:56 +0100 Arnd Bergmann <arnd@kernel.org> wrote:
>
>> From: Arnd Bergmann <arnd@arndb.de>
>> 
>> When the -fsanitize=bounds sanitizer is enabled,
>
> Is this an option in current kernels?

Yes, this is CONFIG_UBSAN_ARRAY_BOUNDS. The actual warning
only shows up in some configurations with that, so either there
is some other dependency, or an element of chance based on gcc
optimizations.

> Seems a large change just to squish a compiler warning.  People might
> prefer a simple 
>
> -	struct ctrl_pos sp, pv;
> +	struct ctrl_pos sp, pv = {};

Right, that would clearly also shut up the warning.

To me this seems less intuitive without an extra comment,
since read_ctrl_pos() is meant to initialize the entire
struct, but please pick whichever you find most readable
here.

      Arnd

