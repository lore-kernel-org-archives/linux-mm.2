Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48038CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0B66B0293; Tue, 26 Aug 2025 10:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679026B0294; Tue, 26 Aug 2025 10:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5E26B0295; Tue, 26 Aug 2025 10:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47E986B0293
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:56:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D80CA56677
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:56:57 +0000 (UTC)
X-FDA: 83819210874.14.4FEE2D2
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35D351C0006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:56:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=eGzcwv8F;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=QM5zKPtG
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756220216; a=rsa-sha256;
	cv=none;
	b=aOerKZvulJwf7SlrL3i9xi+2rB/wUkPXxWtpMrYLwYNKk5d862bj2ePTONGH1BMLsqSiAM
	2/7iNzZtEyHrvsdh8Ge7/i1NCHp8sL8baJDKiK38hxkBhIN1SYuuyZ+jzYodvp6aQL+fRn
	lRjmWe8gXI6q4ukFAWpHxuN2DjmIekU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=eGzcwv8F;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=QM5zKPtG;
	dmarc=none;
	spf=none (imf20.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756220216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QauaDj0jCrgvgctb9q1Ow+lVmL4ZP34xzKj7rrO7Uk8=;
	b=bA5llbTapmWdAyr+Vf+PMt4gsKx/1PdKSXor39HUPEAtkfDSXxmUjEnEVdg8A3ENgByVdA
	4RHD0ig86aUHpaqKAPgcHFRxZlTGRUnaFGAoAhwYjoO88gOfUIGQj2X8nIwSPXvhyb5Ueo
	EXaB2NiuqDI0tGD3UMkGjgjlFnIFJMI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756220213; x=1756825013;
	d=konsulko.se; s=rsa2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=QauaDj0jCrgvgctb9q1Ow+lVmL4ZP34xzKj7rrO7Uk8=;
	b=eGzcwv8Fu8Bjldc3VG5ugIT20ar78EMccNQF820p2u+pKzVdhMqP6kmp7uvDz8P+X23EFKvbMCjwx
	 th9wfzycYtQcB4V2Iup8Nitds9zLRN6j6hBKmdPUA7unIKadP0lLVk+Wr5lTqLubRwMpnVwDLnIv9q
	 5sDTvzc2iA2+HSM6glAOZcHteSaIYN8eHuutH+U2bpVkGPpZNbR6EG9bmZsKlR5HXInoC3FjDuZIIR
	 XUnhGdsNn6NFKufvFe6Ry41NQJZUx+OuwFzHFitjfFKMH4yoNmx7zxf+m9oozSzQPVvZv+BBnk/W8V
	 eRKcwMYDZBixt4242xU/3HzTdtVINFA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756220213; x=1756825013;
	d=konsulko.se; s=ed2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=QauaDj0jCrgvgctb9q1Ow+lVmL4ZP34xzKj7rrO7Uk8=;
	b=QM5zKPtGz1LsmXfWiCV4vIplJh/aFZ3MfOhmPm/fpzEd02l+vkvHnXH+NFd5WmFimc7D91ALZGU4o
	 79rWK1HBQ==
X-HalOne-ID: e4e2ffef-828c-11f0-b5cb-d510462faafc
Received: from smtpclient.apple (unknown [195.250.75.242])
	by mailrelay4.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id e4e2ffef-828c-11f0-b5cb-d510462faafc;
	Tue, 26 Aug 2025 14:56:52 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <20250826124454.GA1502@cmpxchg.org>
Date: Tue, 26 Aug 2025 16:56:46 +0200
Cc: rust-for-linux <rust-for-linux@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Danilo Krummrich <dakr@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Yosry Ahmed <yosry.ahmed@linux.dev>,
 Nhat Pham <nphamcs@gmail.com>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CB3E7E9C-2192-4C60-B79A-932AD6CB005A@konsulko.se>
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250826124454.GA1502@cmpxchg.org>
To: Johannes Weiner <hannes@cmpxchg.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Rspamd-Queue-Id: 35D351C0006
X-Stat-Signature: 3krarhzjwm43exi3g9osuc1cg5dunpg4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756220214-256483
X-HE-Meta: U2FsdGVkX19zMpkzZYp5wJRH4XNtkRgBu2xCuI++vP5aqHyzBnsSkcC4fQcKw3WR1RXm5w1ZixSFAa4tONrttEI0TTjvTOoBrS/sQzDDrbM5OZLBH0SXPEkRnsCrDRy14iF6PL2TmgYf8hikxEIAdtrAsqHHS4IuoApJJymY/+cQV4Dtm2toUgdcWqLKElMag/vBRKCIXkBahZD/MPORrvu63rOwa/9eDwM46QUjFMBuIzb2pCej9ggoICzQ9vWpYaA4CZD0rym6UqP8eHGOZp7VKATRL+VyoOrPhW6B7o3iWHAAmAtKX307IWRCI9YncjfCYElQG+OhvcVgs8LbTO2kXGvl33heVomTIxZmVV+nm1pJKy4L/pQ0GbTmFBEjhCSu856NviK28rCqUxiS37VPUSoYTPiPBkPhJoX3LKgwKW/d5iKWdyx1t9GyM+xvvzdEFVFKvY+leJz2X2oW8Zr0PbDUQ+jXh1vAax4x4HLFdYIkgRqRWpORJ1Ahp/mD0QMX7fbFoG/vRXSK89uQ91oAMiBJaETdz9L4yPO8BxZJ+/m1hm/n+XlmlqQThjvOYL2+CvIHgdihDKSD0fu6LWjoV2tswG8eV6zMl1VB7YnemqENjTo9Syf9NHROjcUGU13LwN+SVdv+p3gpyPuyeObbhZJkwWdfqGcUm14foqZ8+czH6kWdMktct+URBlscO5l++tpbnET6bwFq/Xz/U863FETtRcPG5JAPOQHOxFrtp0rwb7yL4AyhPUfQK2S9g8BodNDRK3TTzXstNVOoA+SmKbFyJdMzUZGJeDT1E6UdHYZs0+eSgJvVeavVXetfZGt8+KO7M8UTVIB1fb2IX5lvR/Hxc9dQLEh1G+wLIaGf5XGwOSkz5/in/Qr7O0RGjVZA8fZNBTZaaEkDuXB7G1/aO9v9JouiXyPUd8nxvlr55xwyVuzYXpgM8+1aukwDyIKtPi22kDreMOci6Ha
 5a8l/pIV
 uQvQVLBKbZnW0sZCs/GlZryutwpxYFyyGxFCsOiihrHLtOyEiRhdTNiQ2d4YFtrDXIyhTx1XvzT1pjmF1ZX9ikp5NoOInmGS4cghOewJbJKXPJA4EmibVfQXZwZh+qDmOxbTa/lmhOvv4tEkMgWS4g4iicbzKKh/psWgVx1kBPFKc4gQReHztnoAZf6HFG8Azbs+7AVOvJBOuOpOf7401BHOj/AlKAJ8esJu1keauSu/TEpzBadL2gk14srK+0eWl+XJpNigGtWip/nYY3H1bRxrTGnc4evC3lLtRup5F/YlCpwarjFeAfCsqeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 26, 2025, at 2:44 PM, Johannes Weiner <hannes@cmpxchg.org> =
wrote:
>=20
> On Sat, Aug 23, 2025 at 03:04:19PM +0200, Vitaly Wool wrote:
>> Zpool is a common frontend for memory storage pool implementations.
>> These pools are typically used to store compressed memory objects,
>> e. g. for Zswap, the lightweight compressed cache for swap pages.
>>=20
>> This patch provides the interface to use Zpool in Rust kernel code,
>> thus enabling Rust implementations of Zpool allocators for Zswap.
>=20
> The zpool indirection is on its way out.
>=20
> When you submitted an alternate allocator backend recently, the
> resounding feedback from the zswap maintainers was that improvements
> should happen to zsmalloc incrementally. It is a lot of code and has a
> lot of features that go beyond allocation strategy. We do not want to
> fork it and fragment this space again with niche, incomplete backends.
>=20
> It's frustrating that you not only ignored this, but then went ahead
> and made other people invest their time and effort into this as well.
>=20

I don=E2=80=99t think we have a consensus on that.

And zblock is, after some additional improvements, just better than =
zsmalloc in all meaningful aspects, let alone the simplicity. It is fas =
easier to implement in Rust than zsmalloc, too. Besides, zram is a good =
candidate to be rewritten in Rust as well and after that is done, zblock =
will be even safer and faster. So while not being =E2=80=9Cincomplete", =
it=E2=80=99s zsmalloc that is becoming a niche backend moving forward, =
and I would argue that it could make more sense to eventually obsolete =
*it* rather than the zpool API.

~Vitaly=

