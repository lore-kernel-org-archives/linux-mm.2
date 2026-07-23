Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2F8C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45606B00EA; Thu, 23 Jul 2026 05:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5DA6B00EB; Thu, 23 Jul 2026 05:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E54B6B00EC; Thu, 23 Jul 2026 05:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49C646B00EA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:00:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B82F016040D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:00:34 +0000 (UTC)
X-FDA: 85019445588.04.6C8CBB0
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	by imf12.hostedemail.com (Postfix) with ESMTP id 91EDC40002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:00:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=MhC9IYmc;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="c 0/woa7";
	spf=pass (imf12.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784797232;
	b=WivA7UylJdWA9kE64DYQ/iyTphPu39SVCxD43HWIgARYVrBrBL8tC9Ukwf3VwvIS5+Bjby
	4WwZagvjlhwRlw5Os4f79xejzuFo69os2AaS5HMuABn2F+LXCdex6dkaYAfNjiScsAn+pK
	dF6b8JDW/M6h0d/YyPQeC8JBTbI6aag=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=MhC9IYmc;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="c 0/woa7";
	spf=pass (imf12.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784797232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2QBxZKriJFHuZN6Z35es1VQXh4AQXzZ22zo0Cq/T5UE=;
	b=u8/+XdW3hpbMf7hk8Qnq3S4td2/CGmp0+Ln/XphtLOEwcM1R34sw5EGjbiYND0+ImKsFty
	YEpKeWtPVLFz/AOhQWN3L4RNIvjZbOU/g04jGeDB1B6aCKCIkf8HcbYx0I8EsO+3O4mLqV
	cRAbdTWoKVfEDCf+twqmAaoghniuHVM=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 022B6140012F;
	Thu, 23 Jul 2026 05:00:32 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Thu, 23 Jul 2026 05:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1784797231;
	 x=1784883631; bh=2QBxZKriJFHuZN6Z35es1VQXh4AQXzZ22zo0Cq/T5UE=; b=
	MhC9IYmchfODkVkzWv8TSLDTgMlTNmynreQBV8QNQGHtG81gc2UURP1gaiVbyWBG
	DsBfNtH93/dUjs7AT+32xRnfmG9EqK2VJ6g8OBpNHXJv4tovg2FF3ApvRpVcEA6x
	Olo/dJFMSecs7tGFGUE8C9TdMwwc7LqWv5HOIAIjcwgSQuq5gdL9baimKf6y13Dq
	DOxFPht5ZSdXXZKfLzovn47yiZT+BMoll4yQust2YIIx1Sykx+jdL6h6d09mKdl3
	v9E9eljykaIl1Hy2Wgo1qTmrvV3Ywm4D65V4ROKKNPZUB9cmGZV6NFvmVqTr5JJa
	+bSQgRYUJkVBj6LsfRwAgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1784797231; x=
	1784883631; bh=2QBxZKriJFHuZN6Z35es1VQXh4AQXzZ22zo0Cq/T5UE=; b=c
	0/woa7vZxWgu7P0bJVWGYDjSSpRhyBc/uAccseFg9NckclCDzDhn7lmjuHEwhYOg
	7/lGn/8QNE8Uc0mn2wEVogcqMFf4C6XJJs6EhzvbM1XZ5IRbBl9slfiNQP9eOEZm
	cyeVQaoh3C1gLrvVewY3kdQGKbwC8pgjWSldL329YRlCb3HlWTSALtSnnoXbEikN
	pBqQYzw47UdZUSLlnpHKubOxBBTqHGb1GExGUe9jU/qOr6/qGgRBS389+TNxrPWL
	0E59Lt53rmjn2xMEz6rWvyNY1HCgJuXHe1xHYQvPxgHo0Wv2Ev3rZ6LjJpaAONWS
	B4fygZiHh/bHafbkVUcaA==
X-ME-Sender: <xms:L9hhao9SzhjZNO3_OeHML98PxSMs_RGt1ZHAxLohetKJep1-8vu3lA>
    <xme:L9hharh0aOdU0Il-TBXDcDBrpNrzVp-GKjLHs_OsGvYvoJePDrBzQNuBX-Ep2toMW
    vtGSH7X_IttVdBR-xFgmSCFguV9d56_Kq8i3UO24OLIbGpGHZyc>
X-ME-Proxy-Cause: dmFkZTF28N2zVOgB4i+IDbUFo5lPnmWt5yN72Qeqda4VDxpbYcuatT80WlC7DQczBt9xnI
    2xyeFNkCTHEcFqw0KQ9/zCYJ5y8+d4jKS9CHMWN7oOFafIiELdAqE5OGF8G9NEoV1A0EV7
    wzvB0QsnDCkSzhQyoSvbS+LQq9sjAsaxCIPhdKC9nbTskJwGuiRO1HPeCbV98lVTWajI7D
    SixnyBVXkgQ/l/c2sBx6r6otcCfcENPmBvfcOizP+GeOC0B2DRmTxI0DR7X4k5+2TR4zst
    GwFAaeXC192JI7Lnh32mbEbdvSzAh0WrJgTXBZnLr7XNj7PDPT7Rrkm55fYu3FT0iGLhOI
    nTqD8t5p02jISOCbYJTQMeLMSBcYL318xz7hGJiP3jr8+3+5L8LM0BNII/9sf6ftWgAFCR
    EGLu5OB7KAUuDSpszH/wdJJVTZUEZHpVeuIVniqBhfDSWh1qXdwq6EY564QanpQkUqQCLq
    u9rJZyAd7WHIQL5k9a7PmblfiLdUe6XKLtyZQSko6iBlpYpIQDoOQgopIIkbwHSCELsvxS
    3VQ0EDnT2b8A5sIFIKc0xrDaKQ/FKRNZKBitnfwh+JFlpIo+u3trgDu1+hhz6RSe116+e4
    1EaWt/Wkq0Hn3/4sOlGbif+UeFkhgDUHd86qY/q9xqinnhM8qSzJtgOYfDKQ
X-ME-Proxy: <xmx:L9hhagXEZnS7X-gPEh44QiP4wk4eac-zQP2p6gGdjmqvVUGSxXmf8w>
    <xmx:L9hhalRiKX2UdYtxbfg2d7jEMYkyr5EMsntLOXqPJ0ZBJMJQlv4qMQ>
    <xmx:L9hhaikqGz6HxMAubkupwgf7vEaDP4GlYY52mRValI4idVYhR3E72A>
    <xmx:L9hhaj4pi5cdkNzwpX5SYWJQdSoB2hmpBweQeKvAYDqDwsGDO56XtQ>
    <xmx:L9hhalXVAo1NU2bsM9-jylyuKTu1EoNW6epetCb5tAYVhYD3tUTiksm6>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7B07E182007E; Thu, 23 Jul 2026 05:00:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: Ay96WTovVnnN
Date: Thu, 23 Jul 2026 11:00:01 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Laight" <david.laight.linux@gmail.com>,
 "Mahad Ibrahim" <mahad.ibrahim.dev@gmail.com>
Cc: "Kees Cook" <kees@kernel.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Mike Rapoport" <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <e9bb1f61-03ce-4f37-b3c0-cb87f11b8f72@app.fastmail.com>
In-Reply-To: <20260723094522.535b284c@pumpkin>
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
 <20260723094522.535b284c@pumpkin>
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rsd6kb6n5fyp5pn8nyf5qse5k9h6gnns
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91EDC40002
X-Rspam-User: 
X-HE-Tag: 1784797232-896789
X-HE-Meta: U2FsdGVkX18BdMa5s1p/eO3QMj0xESbfl55z8gTXxPPUvDtjKx5ufMtZYCayJmOx1GKdwx2YPjjZjNFvOiUCXd93Q3aIk/KATMf4zYAfGqbxXk5ckpW2zJsTVB9zFUphQV/sjQuL4SBZDnkIGVLjcl7lizcfPocakps8eqzbCJ/Q0SrLU5gSPNtP0jAt0cVMUtHs8zIMryiKr8GKamlLBmPc9HfyfYoZPDHt4DSliUqDuBG/G3wqgjCGh9AaL7sEbBwy1nqoAyP+2ZPWg2pYiHqtyr1iOx+E4SrogLna791aoJ3gumuhd1fb2c6QXeTokQEbTmowXmh2GEhgneOkSrdcN7uE1gzk6DNhic9WCBQ/MjOniGhgNVBwiGbMGHe1jMT2/fe0CPkuBqUm5nTR9HUgf4s8xHVI7VVwh26MgByYiGcVRMoM3F7el4XeeD/+6FrdmUY1SvG8k6VkYfHm3xH9D5bmUSqXiA1iIav4JhHF3dmyJ/KHGM7gubUBjPXr1OvG6yGBPAy43WV+rsad+IIUc/+/3i7+aWPwybTjQullbJDpBbTjywqT+H9kgtoxc5CDfG/AKOijU69lOWwHaq6nWMavne+IaSBlgE5IBtYJBvzvBy1HiqXn3anvvSdQEpMUjTiYNkiOwdq1SMtW6T3+xWu0Fk/29d81w0T4C1L14dtkK5Qg7+QaiifHmZ2kSi0FHp3ZxN17E4ovf5i/RzBcXD9iFuX7VjSH5ZpuhvUASSBh/TNU1XZYTwhKj/aFmxXiT0ctHqCZzxeW03sGM780mFi3O5VgXYe+fOqfx05i1eZ2KYIqfTz8MsoaK0MqESusqXz2GafVmd3rhNGFRAkOMCnq36C1yu4z9nvRFYTvKeNdtF4QrOP+Hd3R5OwR/lbpmRlZxclXsvs6uetTBt4HYwhKNdYxdPy32TDfsYO5I7FNSiK7Chk5I1dWOPZpzfT38T0BWqMAvzrDvRS
 /kiyti27
 TTZTHbrRjnGvxIoRQSU5YJsWZ5nuIZXwEGrf2JCkb/bta6Exv3QOnhB3uTfOFHzufXrwkkzck5PPdKEXikZjrfPfJSxW4H4qmEriTbDMu0KNHKSTuQoFi2YpglvKfYlcLK8mdb0KFtuiUEjJJlWOWp9wZm0FXDntI5fz1XOszJpTKceI5FktHwxjywwdLOWVA9APvWBGl+89ZldpyDehGmahEIkU0ZZdu9FA2h2dZDFIXvDiigBrSrwTiP5tPeet9olquDADwpcvb+kQ//703JtSKY0pJL9sjo2J1epH1Heiw4ozzoMCuks2DK73d6F6fm1PWwwFLVriCC+8jQ3A3goWGahVg3xfqIRtKnoKBbyVPFwiEFSUtMd3FlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026, at 10:45, David Laight wrote:
> On Wed, 22 Jul 2026 23:02:46 +0000
> Mahad Ibrahim <mahad.ibrahim.dev@gmail.com> wrote:
>
>> lkdtm_debugfs_entry and direct_entry use __get_free_page to allocate a
>> temporary buffer, perform copy_from_user to get the crashtype name,
>> strim() to strip whitespace and find_crashtype to find the corresponding
>> crashtype that is being requested.
>> 
>> The lkdtm_debugfs_read uses __get_free_page to allocate a temporary
>> buffer to store all the available crashtypes, and then copy it to
>> userspace.
>> 
>> The buffers that are allocated can be allocated with kmalloc as there is
>> nothing special that requires a struct page, or the page allocator.
>> 
>> kmalloc() additionally provides a better API that doesn't require ugly
>> casts which obfuscate the code and kfree does not need to know the size
>> of the freed object.
>> 
>> Replace use of __get_free_page() with kmalloc().
>
> None of those buffers need to be PAGE_SIZE.
> Even the sanity limit for overlong requests could be 4k.
> The longest 'crashtype->name' is probably about 32 characters, so could
> probably go on stack.

It is a straightforward change with a very low risk of regression,
so I see nothing wrong with this version.

If we wanted to improve readability here, I would suggest
using strndup_user() to fold ten lines into one.

    Arnd

