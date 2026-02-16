Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A59A4E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 06:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBE16B0005; Mon, 16 Feb 2026 01:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99826B0088; Mon, 16 Feb 2026 01:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF536B0089; Mon, 16 Feb 2026 01:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 872366B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 01:51:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FFF38CFB7
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:51:18 +0000 (UTC)
X-FDA: 84449398236.05.01E5A06
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf11.hostedemail.com (Postfix) with ESMTP id 89B4A40011
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:51:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771224676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aIs8pJL4x6XAqd44msezyFMEPN6O6znft+SKKIMC6TA=;
	b=xZiMfU0786uchyg+zBsP9tqdrW+6QnnUMvoGNjTWjE4PBpeevK1nrkZ8CL4irOiyp/Ntav
	NTuKiRwP1MDIJF2EcKNlmb0bExbn3fwtyAAc41SSbhZ7Oi6zZv89ZU23xv/jfwxW4n4Taf
	k8hZHGTPEmzsMnIeBIN/r3gS9KRWEgo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771224676; a=rsa-sha256;
	cv=none;
	b=NfX2qb7qBB/uT3ELwE72NjHHe1EdW5nVWKK+P0ZSf2Xiyqwg1G/0pVHMjkwfj1/SHTZTyg
	55i6crRnPLA7oHLt9QWePpB1IqXsOVwo34EwH98bm6HmIHLWuQveI/646agSWUTcwfH1CA
	LFg36/iboT6oiqMzpnhAM/4tfd80uZo=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61G6p8tN341965;
	Mon, 16 Feb 2026 00:51:09 -0600
Message-ID: <78df00a4967f48a41659a5225a09b99c4b1cebb3.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
        Marco Elver
	 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 16 Feb 2026 17:51:08 +1100
In-Reply-To: <9a46df616e371e1680637a41ba2757b7cecf55f6.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
	 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
	 <aYXDeN0WGQG8-cxe@kernel.org>
	 <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
	 <e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org>
	 <5a44609fe992624573a3ca0a293888bd623e2a06.camel@kernel.crashing.org>
	 <0344bfbeb017cafc0f7bd4433eeacd9bc802d9c9.camel@kernel.crashing.org>
	 <aYtBctm4TlHGnzXV@kernel.org>
	 <684d84272e7dcd2ead0770843a7e0afc625c87c9.camel@kernel.crashing.org>
	 <9a46df616e371e1680637a41ba2757b7cecf55f6.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 89B4A40011
X-Rspamd-Server: rspam07
X-Stat-Signature: 3hywfrgs6hg83mufbj5nneesqn7ymk3r
X-HE-Tag: 1771224676-244955
X-HE-Meta: U2FsdGVkX1+j6tXG14bEvRJlzmj/JPJj+1NHvsSlK3c7u5v8+jQUblgRK6/o/GKpElFaYeZZNUphWIlNMgp4uRAG0PF2v38d8OD2NVfW3mnl7f2fduotvhqfJnlrG2npanGx7E05NAUTmYMzWaefHa/nmLHEkl+UPCD0uZWjcgVnyMblgoMv+pHgLSmrHrkFph1MZJixJb7di9YrlUrckn6ZFLoXfXk+zzelqf2Z+O+zKCitOKvaahwc4HtJLiPh6xz6l1/6hNQxkDu1RAqhO5cuEw1Cdmq0bpoR3ubVlWQaOePuxuImFAn1aosp1c5S2nppdRfmmUm2JbX0rosRZnOLva3dv4BAUsh5h/ERb1FEgZAPDJ280eEt5tQa3AR1xGTUbKHqV0i5GFubjh9YNgY64TdN/WHe2K51V/n2bRLFkFJbmYOS0jpTwR3oo/9LFIlUazUjnjvWjpZA2uhF+b/d/1L6ld393hHJGjnIb0iqORNKNn8nvMMxrpKMRdMxpfrJmNg4N3yRzhA3/xR8IbOCoX/hyAYLUUgUjzt6dtec6T5c3l0+f69G1qR/A6dXyMssTIMf2qh79439Ml+xLLMYtlw4JIs/6MxtqJWSIWWVi7B+8v9icTQrlPAVvO6yJyhQE909oCJojC7yVva8ohabmliNY/5rhAbcCEOZf55GQVSaCVBS0NiNsKEPO5oXdEiCO3w0NWJI64VDEw9CjwbIWE68D38bbehimp4pIyX8iwfOU/HjIV9Rh8gey/sMGgf0eINTwazKpi7F5J7hcGLqI0FfcOgWitqgzXxjbPQWhC0OGXdqEsJ4fmlXt4nZ360gQLIpwBx7VND23wcvlE9OmWhRCwaK+QIUhHfYcxBdgrmjTsmUFJy5YtKA8MZlxir4+U3o9zN6m5ZRxs9RzxR65SY1hWA7wXOHFaRIx+OwecEwORStGNw/zPLANEQuatwHXWL93NyetsqjMiN
 PSBWGm0V
 /7r0cXQ4/dwQWuQfieCbspx9OD5yT7xLgdZQANe7xLQ7nIPDGUMd2mLHlBTY4DcDU65yCRLRRzIgy0LomrvYXH30FUyo9YR7Wpvm3HaUwh8vuoIqPMmPZIyWrjc6OIqBv2sCGnKBT7tQaaUQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-02-16 at 16:34 +1100, Benjamin Herrenschmidt wrote:
>=20
> Here's a log on a t3 instance with you patch plus some printk's of
> mine showing the EFI memory reserves and with memblock debug.

Happens also on a qemu VM with 1GB of RAM, so .. :-) There's about 25MB
of RAM lost to UEFI on this with whatever version of qemu I was playing
with that the patch recovers.

It doesn't matter which "method" of freeing the page, the original one
or your free_reserved_page().

I'll switch to upstream to avoid confusion and test it all again.

Cheers,
Ben.

