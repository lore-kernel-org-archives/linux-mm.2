Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4A8CAC58E
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 13:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B7E8E0002; Sat, 13 Sep 2025 09:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC828E0001; Sat, 13 Sep 2025 09:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CA68E0002; Sat, 13 Sep 2025 09:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D55DD8E0001
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 09:55:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71A451D78F8
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 13:55:33 +0000 (UTC)
X-FDA: 83884374546.11.F7E58F0
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0581D180007
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 13:55:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=LGSlOP2H;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="F/zMMroe"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757771731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VqfvmRHEuxO9NpjvelkKGUF0GWJA3hdevKwZTAZOKIQ=;
	b=AP1jUg/5eoW9jhV2XAyfvdGjYM0ydtkKw44DFhwNhNs+zjm0Cms/JwwE0atHKJPg7OEN96
	Ft7ksjMisQncwBYn3kNPMzufyBXIqbX2xN3NUzf7OYWLNDY9kHzCG67Mpk/5p1CH5+5xbT
	Kf37jiO/USl8B5TyxV1QsOvXAIiJXGE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=LGSlOP2H;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b="F/zMMroe";
	spf=none (imf06.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757771731; a=rsa-sha256;
	cv=none;
	b=wHaCMW0NfcVYUTSfXGcfbhgsya53YJGUubzV7MRi1ajvBkErcum0ZFoTjsZ0Nq2Yjz8Os+
	1zV/Vi6fDLYGed71hu/tguzUQzBVanroufb1xVhoA9UfdULKQ97qHGJX5eAd8DdUWMo5yu
	+fHL/5xJaa6S2/TIParMgO/Zhbh1sFw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757771728; x=1758376528;
	d=konsulko.se; s=rsa2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=VqfvmRHEuxO9NpjvelkKGUF0GWJA3hdevKwZTAZOKIQ=;
	b=LGSlOP2HhEqZ35E6Yti2WK1A67orLvN2dkvyYCoJikgar0EgL0TAVg+P5z0paT1XG1/1stpUglgww
	 +8AxVcNNCtppvLvq9IlAb9pTFkAAxKwtIippuIO4EfYZs8qDteLSZ2S+f5s1s3I6oVjH/ZVLkhOr0l
	 9vbipnrbFfXYEsOE4AdwDKX5+6flhpHTXUcg/uxQyIQzRN07jtIcX/Mvw4AROx9x+tyNk3ExO+B2pT
	 gw7pFPIYa+6fotbHEQvLesNMkbVaOg1zKo3+/CY+WpFlqSKEeswqCCiue/pBsKdrFex8nMw1FHvyWR
	 AXqQaP4Ock4crGWzth99tTFlxBnxjWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1757771728; x=1758376528;
	d=konsulko.se; s=ed2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=VqfvmRHEuxO9NpjvelkKGUF0GWJA3hdevKwZTAZOKIQ=;
	b=F/zMMroea44rwTonlcUX/xsJv+9EB6im4MPMNcyat5f4tYo6VrKIWO6ufl4Jit3sShq2pgBDfHhqx
	 oVipukvBw==
X-HalOne-ID: 4cc0b88f-90a9-11f0-ae4b-e90f2b8e16ca
Received: from smtpclient.apple (host-90-233-222-218.mobileonline.telia.com [90.233.222.218])
	by mailrelay2.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 4cc0b88f-90a9-11f0-ae4b-e90f2b8e16ca;
	Sat, 13 Sep 2025 13:55:27 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH 0/3] mm: remove zpool
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <f3ufcsjvvxhi5gzw2wglkpedgyyi6tiaje7em3tbxkzhklphvh@sv3dbo4yba5p>
Date: Sat, 13 Sep 2025 15:55:16 +0200
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <98B3AFB0-EBD5-4779-A5DB-FFA6717E83C3@konsulko.se>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
 <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
 <dh74mr7bjtpzk7frviv6iqqno2u2b27p7jiagp2dtnsz2wrfhr@wlb5vqg4majs>
 <tbvushbdn7nzitey3uy6humdndd6247r4544ngqkds3cr447e6@prnla4edwxmk>
 <f3ufcsjvvxhi5gzw2wglkpedgyyi6tiaje7em3tbxkzhklphvh@sv3dbo4yba5p>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
X-Mailer: Apple Mail (2.3826.200.121)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0581D180007
X-Stat-Signature: fpi9bgfft7jrwp9j3yrypuzsgrpxa5qe
X-HE-Tag: 1757771730-250501
X-HE-Meta: U2FsdGVkX1/rr/+huVcOwUkqFNTDjhyH1tuiMITTj/bxiSX+YS+Jy8XzrXB6U+jwIfI8hcpPt4G2N4jeM2Wn/eQ6eC/z6dG1gcVrKdqwCdJ+fTfNWuNHQCFWKwwTtfcYqKtc5kRE5DLbFXtdnz3psbTwdyvhImLyJTz95JyrcEatj3+ukysSDgvoOSVRC509wXebhnMI6DF5jC55T0vIY96eWAhz9HMiPrMHKuXeaWvTyDrllO3HrdKf0606/DtLUE25nRodD1iE7nor8S6N8EhTLElCthR8niJKWiDZKL7W2U5MJlQhWkHo0nWz5xGHewXqiKQ2cLvbO9XVrb038Jm4nVXIvRGRnbEXpDDeMJXzkIQGTwqm10smIwKSRRVdUJXGmu8GlvmxZGRjChm/p1KCwytD8xa5EbLqvA7usUFBAgriF/FlfI0HFR/4PfrTYa2OYup/G9sOysrWeNYokZUZ5lexvop462ztWcnp1TDVszB178KzXcUlDsyRzncXJrYlqQATuxEjOajBH6bEyhH6fUegPIBCzN4rZ8kp6P9+zpsm8TnF8x+RtHmeVWtVnte2qp1efpfAcXv71sYpBdUIsyNqdEolV8DgBciPyn2DN44fgje+0urfwSPpqbASAoiBGBj9yGdxTifwOANj6Bv7TXRgTprhxviebXMhB1K7BlK3nMSfUWqsWm5OEuxm+CVqusAR/N8ZhTl1tdKsexCwPg8bVe5h+7pUdDAUlbW5aP8psmt9wGyBSAGRGqmhICNfhrLGvyhnC1wRPElZY38TI+0EakbF49K9HXKDCtZjuyeiEnasRv2OAtVtwMwKiLKQHrJu1fUNH5zEFEg+GXADcryhxR/03nM51pLwJpgRn8ZC2G6Pg79JS8ayQGp5o+rOnmWccbDoxSMnvyDRpfHdNeO2dXehA2shUkyDjq5SmSNiQCk1u+Wb2vnpI71XbJYwiKhkNFHY+4iUItK
 Qr8d4wU1
 HxPl47H2cWYjPSPCiuOKa8Mzvp4dHWYEmtvFCAqHNdIZ/CPrBxr+L5xmjswXxazdFaxdS/g3SbFm3MV6UE7f9UGLY/q5K0Mj7GW35dvZaAcNAuxfon8ms/pjYA9/99+Q81hA8klYoqZTsFFsF0l6kexsKeMWYOye7yj8eyTDWHOo+2B8qS27QU2mmTnxRBf9HxxnU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2025, at 10:12=E2=80=AFPM, Yosry Ahmed =
<yosry.ahmed@linux.dev> wrote:
>=20
> On Mon, Sep 08, 2025 at 09:18:01PM +0900, Sergey Senozhatsky wrote:
>> On (25/09/06 14:25), Sergey Senozhatsky wrote:
>>> On (25/09/05 19:57), Yosry Ahmed wrote:
>>>> I think Android uses zram+zsmalloc with 16K pages. Perhaps Sergey =
could
>>>> confirm.
>>>=20
>>> I'm not working on android directly,
>>>=20
>>> I can confirm that android uses zram+zsmalloc.  As of 16K pages, =
there
>>> was a way to toggle 16k pages on android (via system settings), I =
don't
>>> know if this is the default now.
>>=20
>> While I don't know what zsmalloc struggles Vitaly is referring to in
>> particular, off the top of my head, zsmalloc does memcpy()'s for =
objects
>> that span multiple pages, when zsmalloc kmap()'s both physical pages =
and
>> memcpy()'s chunks of the object into a provided buffer. With 16K =
pages
>> we can have rather larger compressed objects, so those memcpy() are =
likely
>> more visible.  Attacking this would be a good idea, I guess.
>=20
> Yeah I personally think attacking whatever problems zsmalloc has with
> 16K pages is the way to go.

Well, there is a way out for 16+K pages, that being:
* restricting zsmalloc to not have objects spanning across 2 pages
* reworking size_classes based allocation to have uneven steps
* as a result of the above, organising binary search for the right size =
object

This will effectively turn zsmalloc into zblock, with some extra cruft =
that makes it far less comprehensible.

Another option would be to leave zsmalloc do its job on 4K pages and use =
zblock for bigger pages. But it is not possible at the moment because =
zpool api has been removed. Thats=E2=80=99s why I NACK=E2=80=99ed the =
zpool removal, at least until we have a replacement for it ready.

~Vitaly=

