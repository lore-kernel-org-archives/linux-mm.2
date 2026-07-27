Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D23C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CB9D6B00A6; Mon, 27 Jul 2026 13:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3A06B00A9; Mon, 27 Jul 2026 13:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695866B00AA; Mon, 27 Jul 2026 13:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA306B00A6
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:07:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3E1680153
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:07:12 +0000 (UTC)
X-FDA: 85035187104.22.78A7F8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 889A018000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:07:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kPqouvmC;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785172030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M21l6ydiXR9oHZPaZFHJiifPedoek2tZ1h85xa47aWs=;
	b=FembNLHohSQH+g2lA7Qm/45k5KQmHr5DV33M4/wiMiups7R+mwv4neUrKMz7rgeiQ7MqQK
	5W3bQ8zdkLpPZAKY8nlWYEMCJ6GzwP9GPrlLhaiVy/3AX2Er9Ul2hmQoNnWW/7bQ6UGSmH
	ZY8ce8nZ7DFQwHipPIgVAE+i/r7XJfI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785172030;
	b=7MT2bnbAOASf9Q12EWaR0EcY4f8tExQnaBXaXyHQMI4ZbdDTaqERu0tmntO7+yYO6Ggh/Q
	04L7/WoIGNJrBB+qRbGd4NunxtX4zclENdhUDYQrzHw9OuNPXjFkjjtDiCh7jpayxDiC+B
	L3pvRgF7+sNEUkx+uKKo3R/M3jGETYE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kPqouvmC;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 002466013A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8A61F00A3A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785172029;
	bh=M21l6ydiXR9oHZPaZFHJiifPedoek2tZ1h85xa47aWs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kPqouvmCkQjMH2fw7pecxJcjj7kIB5wj+kkMEaADADFO9kukBhWVzBGKRC+btNT9W
	 mEzz9YKH9e41o7R0jLilTN89Fzz1w94i4mb3RqZDASd0Q+9DAcX3coAC/zIIsaA6zx
	 aYrro5UcIztNeu1TOEP3X2xA3uDn9OyPtvLG8u1oLdNl79QbmWAkndUvlRhVeMOYvM
	 pJRfYgzYMdFHbiuXAjC1huPItXzt6RMxCnEBCYmIkev4KyxnqhL3BMSLSPvcCcpJ3q
	 GHCwkdG/KsM35bPvJjt3ccyGFoX4e+leUMRsvl7w7w9SPXyocgFZPgZJrBGOt58YvF
	 /NJvB2y93/szw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so381124966b.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:07:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp3GNeufxB09SOHuHFj3ioD/T7XRXTDgUClcbyUG/4oQZ6zIcob3Spd7aFpywu9MivkJV8pEEzcPQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5VSF866JurqFXw+Bb2b0hg3+W7Ji0ZFzzjrwGNVw5IfkRYFcl
	DWQQQoJ1sM0rJ612QgUpglKbktkpUUBNk/JoNLD0hwKY5VCN0ZznuUB0qC85eAyEvI8CeY6CiLQ
	STahQXlAqq8m7PJv1jkv4EqDX2nDjKRU=
X-Received: by 2002:a17:907:2681:b0:c05:3c55:ee86 with SMTP id
 a640c23a62f3a-c1f1f158ba4mr412327066b.46.1785172028585; Mon, 27 Jul 2026
 10:07:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
 <CAKEwX=NLEmRKbgf7e4mQ8ynwGLhe8d3orc_2U8n-K_W6VjOAoA@mail.gmail.com>
 <CAO9r8zNbw4T4O-TtFsd9NMJh2RKRDuXTqfSKgMbe6o05MZxebg@mail.gmail.com> <CAKEwX=MwhU74Ak01kEa7VL_mKNY1gO_hX_aAPvMkXo-72MB52g@mail.gmail.com>
In-Reply-To: <CAKEwX=MwhU74Ak01kEa7VL_mKNY1gO_hX_aAPvMkXo-72MB52g@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 27 Jul 2026 10:06:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPsQ6rzhuRopvepxmrXg6q2r+ixRvL2vdG2FVmxBcUn=A@mail.gmail.com>
X-Gm-Features: AUfX_mwiMOknOJX1KeuWlbwkL5mG0Omn89uTVYiwltFR_G_nS8ZScISbFp5zSCY
Message-ID: <CAO9r8zPsQ6rzhuRopvepxmrXg6q2r+ixRvL2vdG2FVmxBcUn=A@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
To: Nhat Pham <nphamcs@gmail.com>
Cc: Jianyue Wu <wujianyue000@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 889A018000C
X-Stat-Signature: 6odq8jezaaxjzped7gs5mdfqj9rmeog8
X-Rspam-User: 
X-HE-Tag: 1785172030-483365
X-HE-Meta: U2FsdGVkX1++0I7D6gilSIvR7S7TPF/AHJ7kbBbDVSs41xYhYkBqSiUqLjpZ/9L04U36XNSxbkibR4mBve7a60H1Nu2yJ02oMQx7m9Cza/N3Yes4pd+JNGnIQzSGc53SlXE0/W52g/sWA8sJXNkishB5kJp21AqXLzuTtDw3iKX445BoXjf754uUhSao4NfrQG8STktV7jcEibSwbuEZ+JlXtVldOTFw3HcfUEwKEkqeOsdm2BTHb6lRfCuXOWVm9lky1z9tn/kRFa+3Nz6ZNFi51SDsCEXeocYv8W62riYADZ5vLKn4the4LCpEY9THKrc3G2GXMOt7ougzFp//ow/Xb5GFVQHJSq5jkErkSkQautD5BQVLCDYZ9ZtJ8E25CwSPaNlMobnj6fVonZa1OUg5S78ZlEIr0MaKGq0xdRjIXVkDEXbPSu/GB7aNEwA3Wq1i2SAXLo8nMF4rtHoxv4tt2qaoKaf1Hq14rXBg5KSSC6l+kTsvz9ZfcESCpjmcV7gBzc0zNUIwAKDvQMUBYzJKCFBqjL6VIziz+Q5Xdh/IecQX3oGP/UNGL9T+V8pue18/XmjNYIg2UqhWwR6xneZyIpn5cDE6AUt1VMApVGbrkVVhA0vXALFDZv91CBtYa1UXKMaD/oNWlVntU/2HOBPtDZos7x/0dqamai9Q4lCZHHZPGgxKQRDAMCMwnMx21MEUXlR4V8J0NLwSoavprEnAGbaiFffFE4JG32DbZN0x9Zp58xjZnMEEKsPr1tN8oM3k5fOmQuMA4fVw+6kO2gEyvtOA08ouTNkP3+H8+O5zoQTNO4Rvy4LDMDsSsfwZjRm+vW3W/IqQ7qPQ1I7lCVxusw2BC4upTQtIY5j0s8ukKwfmu7+r8fVxoFNHZEncHvYTBtjpJVcH3PfbiwvKfTJF6FKQYh5HydE3Y4NFFeNpgGwXeqpfWmBoptiWr+TJHPFYnVATS8Ty4FpLD4e
 WJArJ+E4
 r1eYdxAP4ajMERXgFhAdFaaMGNtUUOnjlilHOTssvhYXfDWmRGzKaZpnNJEqiIEr5OxNVd81ZcJ8CEqchRu9E38nrO8HtggwYfIODP7ghdetWAQj+85p58IWwGdFmPI10ScoczC5aNhnrNQoyrjmP6y8SIRFweP+ZAGN29G5nn8KekjM2CCIhqQZK3pX2X0ox04uTRxZV9XoNhCHZzr/yVc7abcOPQ1Xfj+1rtZqUO4eGSc4bYmcplvnDECBFWLlOnKilyAKfytZ25n4rR/FZutZuLV2F2Kb0WtkYSJtkOMK1e1Nnw/na8Bvp5biHxsSBpZhWntPFLupAex+tMF25BfjcPANfzSLakLlGNugL4SdI9S71Dw+8ETaD3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 9:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Jul 27, 2026 at 9:46=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Mon, Jul 27, 2026 at 9:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Sun, Jul 26, 2026 at 8:18=E2=80=AFAM Jianyue Wu <wujianyue000@gmai=
l.com> wrote:
> > > >
> > > > Every stored page has a struct zswap_entry, so its size is a per-pa=
ge cost
> > > > that scales with how many pages zswap holds.  It currently embeds a=
n
> > > > 8-byte pool pointer.
> > > >
> > > > Replace the pointer with a u16 index into an allocating xarray of p=
ools.
> > > > The index is allocated with the pool and remains valid while entrie=
s hold
> > > > references to that pool.
> > > >
> > > > On x86_64, the zswap_entry slab shrinks from 56 to 48 bytes per obj=
ect,
> > > > raising objs_per_slab from 73 to 85.  This saves about 2MiB of meta=
data
> > > > per 1GiB of data held in zswap.
> > >
> > > TBH, that doesn't seem that major... It's like one huge page man.
> > >
> > > But Yosry might disagree?
> >
> > Well, it's free memory :)
> >
> > >
> > > On the design aspect:
> > >
> > > 1. How many pools can there be? My understanding is it's bounded by
> > > the number of compression algos, and most of the time the system just
> > > use one, no? Maybe just add a fixed array and call it a day? :) Seems
> > > like we can probably get away with, say a fixed array 16 elements.
> > > That seems plenty. You can reduce the number of bits it takes to
> > > describe the index to 4 (saving the spare bits for future usage), and
> > > you can avoid the xarray overhead...? Just fail and warn when you hav=
e
> > > reached capacity, maybe? :)
> >
> > Hmm yeah good point, we do reuse the pools for the same compressors. I
> > don't know if crypto defines an upper limit on the number of
> > compression algorithms. If we want to be really conservative we can
> > use an array of 256 elements indexed by a u8. That's 1KB of memory,
> > probably mostly wasted. We can also just define an artificial limit on
> > the number of compressors based on what we currently have implemented
> > and increase it when needed?
> >
> > Not sure what's an easy way to determine all crypto compression
> > algorithms we have tho.
>
> Seems like we only create new pool when we set a new compression algo rig=
ht?
>
> In a sense, it's not really about how many compression algorithm we
> compile or support at runtime. It's the compression algo that we
> actually set (zswap_setup() and zswap_compressor_param_set()). And
> it's usually 1 (or 2 if we misconfigure the build config, lol).
>
> I think 16 is already plenty for this purpose, but who knows :)

Technically, you can switch compressors at runtime. Not sure if anyone
actually does this, but it is supported today, and ideally we wouldn't
break it without good reason.

