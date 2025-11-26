Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5927CD10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 15:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59566B002A; Wed, 26 Nov 2025 10:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09E46B0032; Wed, 26 Nov 2025 10:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F89C6B002E; Wed, 26 Nov 2025 10:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7056B0028
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:20:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43C9B12A23
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:20:50 +0000 (UTC)
X-FDA: 84153120660.25.0E9FB7E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6CF4C8001A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:20:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=f4biDeBJ;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764170448; a=rsa-sha256;
	cv=none;
	b=Fh+EgkqW6wvQ/ejfD6Fkxoz8O1D5JGHK1XyXyABhvui3hHyc4tYbCF3/SN3aKvuL1nbJny
	mlCu6JbzpMdP/qhSptal2FcPPyT5ofAOwxp90XOE+V1XlJ33ZWcjlK+wIPzQeofF6dn7TV
	lhc8l1ReSB9UR8mqePCzRcf9hGfglzw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=f4biDeBJ;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764170448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GRcIa/YaBI4AyoMCBcFhjhi8kYcF6nz5JNvHTsbns0=;
	b=zp3TlwhRH74kb63JP14A5ntZJbtJ4F6pj6D0mUeWplJ9GuyspIn+LO7mkXCI+sfUNtLb56
	0KVpaMMECisKMwgPXibJjH3Iua+U8TS8PN1pmFv3KptIc3AkU41kybIqHM+KLmT0LVg1sc
	lFAyElkDq6NnvFEQ/INYJcYr+AJe61Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5GRcIa/YaBI4AyoMCBcFhjhi8kYcF6nz5JNvHTsbns0=; b=f4biDeBJ6tcql1AACsjQmcSyt2
	d83oKifGra+ytLN2uZfmePX0tbVE6dnKn1WfJ3OvlN9URdjn9F1hJOrwg4FIu8Uwm52dJliu/zpQ9
	h96QZ4hXbuvGHfI2Fv60NbBkIpm6lgfFqEqCOSPxp7QvANPdUBrt4P0JYQw2Q42hHtIWuEtgGqbPo
	0+gUcp3OGJMz2AbREPzjIOVaiIFq6ni7gsazZOuPivrdYAz7fLawDuFGA6KyncJ1L+0x9/sTFe/iM
	B2FMi50IIQnWC0ciz9Htfa0cG0ugjRQYV2/PKFRgxjXmVZ7zFYdIVS9XKJyN0Mm/DjYn4NIg12POx
	f9lWqbww==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vOHCb-000000000s9-23S9;
	Wed, 26 Nov 2025 10:13:06 -0500
Message-ID: <177c8e4d0567456baecc962bf5c1038f05358cc0.camel@surriel.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global
 mode
From: Rik van Riel <riel@surriel.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Yafang Shao
	 <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov	
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko	
 <andrii@kernel.org>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes	
 <lorenzo.stoakes@oracle.com>, Martin KaFai Lau <martin.lau@linux.dev>,
 Eduard	 <eddyz87@gmail.com>, Song Liu <song@kernel.org>, Yonghong Song	
 <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, KP
 Singh	 <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo	
 <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>,
  Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, Johannes Weiner
 <hannes@cmpxchg.org>, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com,  Matthew Wilcox <willy@infradead.org>,
 Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
 Jonathan Corbet	 <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, Shakeel
 Butt	 <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>,
 lance.yang@linux.dev,  Randy Dunlap <rdunlap@infradead.org>, Chris Mason
 <clm@meta.com>, bpf <bpf@vger.kernel.org>, linux-mm	 <linux-mm@kvack.org>
Date: Wed, 26 Nov 2025 10:13:06 -0500
In-Reply-To: <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
	 <20251026100159.6103-7-laoar.shao@gmail.com>
	 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6CF4C8001A
X-Stat-Signature: hydfxr3otsqwxigort6wpwb41y8ytf4s
X-Rspam-User: 
X-HE-Tag: 1764170448-351338
X-HE-Meta: U2FsdGVkX19kteSfDr0K/h/cYhWbD+L35ofrdn3Sz5re1uKW0dNqdpG12La8W+U+pp+QWxkqLp78VDOrnGdEmllwWr0zH6vcFhR1mCidLrVcti8MLjeCeS/5w6tYDbU/9Tbt+erg2h1zxlZQsCaNcf6TRp7zdPm3/WfTD6GhdToYxoJVoRuCmB2iXWE4GfIa+r+hbfRkB2DYFn1Iffp0iyHuHHFwE8RPy3EZEnqF99++L7drujqvDGjSnHvF32uvvXWIJuZnD8veCMDNCiXZOcRDHS+VyvARhA7iZYGJlBEt/ws3OuGF8J0LclAn27KiRUZqKec3kf47whSnhUq+pVJT+5sVE/ehsxyB/LmkU5QAkGLkpOVn2esaB5bX+VpFvUL3wMZR3DN+HuK2wBH2p99tBqXbdlDhy/GFwlwkdsQ39q9u7ng05EF0F6or048LlxuZSFS8/Wi4bidl2zIMYKDHuMc6sa5X4kTSuCgVr3/BO0DAi24nuhWyat1JJzarUJZxoR62vVdPrPYrLkZiRDli2ByQ4/iDyRQhDgyQtPJQNne6XUNnz1U694QJR6+X8MbxyJdbcT17SFJXDLWNYtcnNw0p+9XZEHfcoA+c/+RDgG7IfFkArZ6ActttxY89G5D3gVozLaLFiEAUVRXF3xhz6gwCjSyeEITZUSqdehmXa5SgWEkQh1t9drizgbAUwTTROAULEhc82GpPY7aWn2PWoLI5mxjUkNa/NuedZMRPWm0kMlba4I6Da9108SR1+uQuDDIJ1mLTA0z+tD1on56hkMJqVM8t3QJVASRiYt+3FZFnUqNfU4jsONkG8ZPkYz9VMlCVkcVg6I80k2RX58uoBxQR7/JHfJnCUiK1doQwDdLbRLx0pgstr+ErIWvfJ5PXnCfjeo16f8suNUg/GAMK6qKawgMolikhe6NeC340IsNWHKhnFF7OtewLpWNJGVVNEow//Hax7ifXr1y
 yXt6jmmI
 JHyiz1hvrl7UHPotZlCQaQJ+GTu8awzOcVWAILBzBthQYmIXnu9eln8DYotoqRY/2xlhzCDF5y3JXOcaeMuFL06BGPth+HdSO55Gb09UIxHlY3tFS2wJm/HfmXn7ZDxH0hvqWS1f3RyZQn2qhx+AysX/ehr/RKxBePfFKORNQ6ZNhWtN7d5gpRGJSFKWY2zGhjfhgH1kZT4yBpxhNpIW/KpJuxmWmqMD2aqFUYURhJVVhoUp5ze5k5qsPs/42mzdRjnEgAoaD61e/McRA4rwWERz4EbfCaxNLOJrx3NmlQ1lQsNhi10v8Qe0z3bySULW/0mIN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-10-28 at 18:32 -0700, Alexei Starovoitov wrote:
> On Sun, Oct 26, 2025 at 3:03=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com=
>
> wrote:
> >=20
> > The per-process BPF-THP mode is unsuitable for managing shared
> > resources
> > such as shmem THP and file-backed THP. This aligns with known
> > cgroup
> > limitations for similar scenarios [0].
> >=20
> > Introduce a global BPF-THP mode to address this gap. When
> > registered:
> > - All existing per-process instances are disabled
> > - New per-process registrations are blocked
> > - Existing per-process instances remain registered (no forced
> > unregistration)
> >=20
> > The global mode takes precedence over per-process instances.
> > Updates are
> > type-isolated: global instances can only be updated by new global
> > instances, and per-process instances by new per-process instances.
>=20
> ...
>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&thp_ops_lock);
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Each process is exclusively ma=
naged by a single BPF-THP.
> > */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rcu_access_pointer(mm->bpf_mm=
.bpf_thp)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Each process is exclusively ma=
naged by a single BPF-THP.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Global mode disables per-=
process instances.
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rcu_access_pointer(mm->bpf_mm=
.bpf_thp) ||
> > rcu_access_pointer(bpf_thp_global)) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 err =3D -EBUSY;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto out;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> You didn't address the issue and instead doubled down
> on this broken global approach.
>=20
> This bait-and-switch patchset is frankly disingenuous.
> 'lets code up some per-mm hack, since people will hate it anyway,
> and I'm not going to use it either, and add this global mode
> as a fake "fallback"...'

Should things be the other way around, where
per-process BPF THP policy overrides global
policy?

I can definitely see a use for global policy,
but also a reason to override it for some
programs or containers.

--=20
All Rights Reversed.

