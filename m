Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 558C3C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 17:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C5B6B0095; Wed, 30 Jul 2025 13:25:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD256B0096; Wed, 30 Jul 2025 13:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13296B0098; Wed, 30 Jul 2025 13:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C3FEC6B0095
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:25:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85A61114280
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:25:22 +0000 (UTC)
X-FDA: 83721607284.02.721D9C7
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2C532100002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 17:25:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=bphNS+XV;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=6Af2hm4y
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753896320; a=rsa-sha256;
	cv=none;
	b=YMN5oHUnNGQIsZm/ix3Rm8xTzo1V+DI1hTvPXpfQceDzHr8tjnSdVQWde2xU2m1O08Hh+q
	30FoLASUw8CXumh2c4KdHyswEmQKWmyUflv0KHX364DUYIZfdEUutJz5xVB96HpHaVumuJ
	NZW4BdZnxV0mk4dBEk7tt9pcw8kCNKo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=bphNS+XV;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=6Af2hm4y;
	dmarc=none;
	spf=none (imf14.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753896320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGi2Cbl4x5cWD0I2ITAY/N2F9HJW2syAJhuk1NYiQAY=;
	b=Qlberahqixgi0hfN4UcXCyh++n/w2LUWVG7CbpNgq4PgmfUn915EwwSQHEq2yDCfHUtjTP
	ndR4O84TSS/OXNG7/SNE+fY2EhwPP8xbJJRZHZbGx1t9+GfCHFdlQQrx/AlJizQ0d2W1mw
	rhGG9bTmSyjdAiTs8z3IGhtBq+AE5WU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753896317; x=1754501117;
	d=konsulko.se; s=rsa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=PGi2Cbl4x5cWD0I2ITAY/N2F9HJW2syAJhuk1NYiQAY=;
	b=bphNS+XVZXoX9g07m5+NodI8iBOu6iCZe9qsYu9hHOvQTKaIzlhzzUQUED7XQoyqJxC+tL7sgGcEa
	 kFrKiQLtjdEWpHN18pKT0HFWZgYq1bbGQLXO/J6P86Lv8MVWqW2GTLshgF3eGaaOt4Uvt7yC1jLF1p
	 r+813EgTmpNicMprW1wyH9yq5Ul2LpQZgZT2fva3wx0Pj1nj6xBbMz+KvJFCfEqMt+NKIWw1n49zQH
	 1QdAlPPrlaK+rPo/FtDeo4VzniYkixsNODYSAqLiGGhV+aVoSF13JWDOg5WB/4NPeSGGF1an7ApX9Z
	 vVF4cGW3eZTre/4hY5gWeDzCXg9XRvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753896317; x=1754501117;
	d=konsulko.se; s=ed1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=PGi2Cbl4x5cWD0I2ITAY/N2F9HJW2syAJhuk1NYiQAY=;
	b=6Af2hm4yEUeE/Oyl9MPj99Eu4MG7asvfvhfFyRnp28rv0ioRog4XZlBcGDfZGbuAOpPFeijWrfKWl
	 0lE/kdVAg==
X-HalOne-ID: 27e5fc15-6d6a-11f0-98dc-c9fa7b04d629
Received: from smtpclient.apple (unknown [2a01:cb1d:9264:6f00:8e8:6eed:ae4e:a087])
	by mailrelay1.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 27e5fc15-6d6a-11f0-98dc-c9fa7b04d629;
	Wed, 30 Jul 2025 17:25:16 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH v13 1/4] :mm/vmalloc: allow to set node and align in
 vrealloc
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <aHZnmevtRYt26LBE@casper.infradead.org>
Date: Wed, 30 Jul 2025 19:25:05 +0200
Cc: linux-mm@kvack.org,
 akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 Danilo Krummrich <dakr@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 rust-for-linux@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 bpf@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B851D9FB-3745-4923-B196-C4D0C618DBF5@konsulko.se>
References: <20250715135645.2230065-1-vitaly.wool@konsulko.se>
 <20250715135724.2230116-1-vitaly.wool@konsulko.se>
 <aHZnmevtRYt26LBE@casper.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
X-Mailer: Apple Mail (2.3826.200.121)
X-Stat-Signature: y6jo7d1ddkbybxc7g6tkckju6k1jiaaz
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C532100002
X-Rspamd-Server: rspam02
X-HE-Tag: 1753896319-70232
X-HE-Meta: U2FsdGVkX1+wykfDrLBJoHyjUmBIocNspxkuvl2uIP0BkAUYILBjV2JkBm7zzp935yuh893LPsxnuqBw73UAb9HM+OKQ5x9CMoCvi0J8dDYYbyIW+B7R+z0nPgHqPnBXWooX6RnI7mSdV4TdakifM/n86uN7vCwORCqoElk8Gpv49aiZrSlxr1Q5jMF7I0oPR4Q33ELdNYn4ZDk2DU9+2zqeZodYpSxgce45ohiEYl0vwccmLhRwPToEaWqlQ9tHTO/NST0COv2vdVnfUSTFw5E/i8h/upHwMmEF5wZUKK8Sfb6JSQOGYwKqyaQDQBUzOJcak+SgiJTGWC186Ae8z3Wje5XJK1BftArc9+bLtPFxGVOjKXwpizccR1pT148i2FO3U8FuqcYXfRQ6OETeXpGuoygdaywKBPaQvNOauvkdm9vhHlQvxy/cDl67pdJXJHgpIC8EtgVaGfNRCK/9iwUS9Vx2z8HDB+UHoYVSAkQ9+wMnT/i8HEtDxyfFD/ElKAsiyAsxCdAvAdbASf4kdIXVgsyLvjDRVg+vuyVPR7zXolNVbJw1CwgYdhl1w1otM3BESHr/EKAVjRoI76KBgFTu8N5VCIrSB2Pd53UgnBTZ9W0uNk8N8kY22dZAlS3LlbNax0j64ThU4UkJx1wSOv/p0hcO8DZ1lHxbCCtdUcqr2KrvD3gC25xRIAHNFZBSXi+kHKkDtlrTOa5GsgPKpkcJYkW4jTGusiuHAnw7nSnXvC6mLZE2u2DHCLbj/gzHdKk29JMLYOsJwURVfZyAtgAtlJjmLnYYwpnoHvJD4B8415BHWeFEgAUjBHUe4tue1FbeljwbLbfxRCV3HULZDRQ50rdAcrZ82nnTq8Eoc8iiufbc1chR2GLjyHyMIqp/uH6v1B37ed1d//VL2CRdQZ24B8XGUqaAF9//7OBEfmFcT2JaTiPznxcq7DDxBAFXoNdA8NiNhPkIG2xWLd0
 i2avXwn4
 AXnuSeJ+VhnNmZ0+bJXy2GQa7JEKMZ08OyD8/Og7qdyLcwTkDTum+zjKx3dpFRzxIeJXCmxJhl2lnk8kDxgkAuT3IP0BkKwW/g1e0EX1N8M7wQoLt93+fWTcTEB5vA9ybHav4xcuI4eCWsRkvvy1xn2dgHNRMKW02Sf5pZ8Y6cVH5x5Py4V/gpWcD2fdhPrHc0BhH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 15, 2025, at 4:37=E2=80=AFPM, Matthew Wilcox =
<willy@infradead.org> wrote:
>=20
> On Tue, Jul 15, 2025 at 03:57:24PM +0200, Vitaly Wool wrote:
>> +void *__must_check vrealloc_node_align_noprof(const void *p, size_t =
size,
>> + unsigned long align, gfp_t flags, int nid) __realloc_size(2);
>> +#define vrealloc_node_noprof(_p, _s, _f, _nid) \
>> + vrealloc_node_align_noprof(_p, _s, 1, _f, _nid)
>> +#define vrealloc_noprof(_p, _s, _f) \
>> + vrealloc_node_align_noprof(_p, _s, 1, _f, NUMA_NO_NODE)
>> +#define vrealloc_node_align(...) =
alloc_hooks(vrealloc_node_align_noprof(__VA_ARGS__))
>> +#define vrealloc_node(...) =
alloc_hooks(vrealloc_node_noprof(__VA_ARGS__))
>> +#define vrealloc(...) alloc_hooks(vrealloc_noprof(__VA_ARGS__))
>=20
> I think we can simplify all of this.
>=20
> void *__must_check vrealloc_noprof(const void *p, size_t size,
> unsigned long align, gfp_t flags, int nid) __realloc_size(2);
> #define vrealloc_node_align(...) \
> alloc_hooks(vrealloc_noprof(__VA_ARGS__))
> #define vrealloc_node(p, s, f, nid) \
> alloc_hooks(vrealloc_noprof(p, s, 1, f, nid))
> #define vrealloc(p, s, f) \
> alloc_hooks(vrealloc_noprof(p, s, 1, f, NUMA_NO_NODE))
>=20
>=20

In this case, to keep things buildable an each step we will need to =
modify slub.c in this patch. Since we change slub.c in the next patch in =
the series I would suggest that we keep things simple (=3D=3D as they =
are now, even if it means some redundant macros have to stay). I can =
come up with a macro simplification like yours when this series is =
accepted.

Thanks,
Vitaly


