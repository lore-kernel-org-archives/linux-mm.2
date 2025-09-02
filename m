Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E798CCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E6788E0021; Tue,  2 Sep 2025 11:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497258E0002; Tue,  2 Sep 2025 11:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD4C8E0021; Tue,  2 Sep 2025 11:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5F98E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:16:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1FED1190B2
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:16:20 +0000 (UTC)
X-FDA: 83844661320.26.011E5DC
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4BC6B10000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:16:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=Jrv1bsXb;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=x1Ao2l9M
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756826179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hvb4wccZRjNtKraptVsMtyIUp9QMrQzrtgemNpw46AY=;
	b=JDr9kDdQUmkOSvUx0iV5+ZZi2iJLRpfBGwrMpK6+fkvcmvZskAk7v/Bl6H70cDR4NzCSgy
	mlBntZAbsQ+XpMSNyHeqZavewwoMqK1lSDPfdFoCHMNP8vvztu84MfWJryFrxGNhNj96CA
	EvBe24rZDzvDLvFxtBYH9WD7zOomV3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756826179; a=rsa-sha256;
	cv=none;
	b=uGQGK48ej+H9SsPkr9YMV5ScY3ROTg7SOj2orneNnMq1HYHXemt2Xfx8zntblKGyhAdz/L
	FXa+4bauGA0vV3Vo9xK9Sm0hwyDdxGoVT0h6ZvMYeu/W+lF9i88Q8lxZEQ5A7pdF/aHlG2
	hab25KP2LBE8Hg2grIyrKoXabLtwqGM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=Jrv1bsXb;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=x1Ao2l9M;
	spf=none (imf05.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756826176; x=1757430976;
	d=konsulko.se; s=rsa2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=Hvb4wccZRjNtKraptVsMtyIUp9QMrQzrtgemNpw46AY=;
	b=Jrv1bsXbUJ3THtZIWGG7MUC8qs9VZN1GXubux7akLZ7yM53era3Gm0J2xz0qd9OVfPa/ykNkS6Fuc
	 oPOQvpgirLiWArshd4UMzz9cn0gXx+UM3EGNXhk2aMt1xNwLyb0+KsshlZIrAIYAFwjpzZGgU6Jhi7
	 bU4FiLCQ0Xu1U8kMQe4fkSq0K/gcjWFdOQ1GVNf+/b6tM19XRT3vVqm9z17vMTAoD8IjKjVzVUbokR
	 nVtMswwp5YoDk0aAlIjMvYQgqtOQsmoD7KFnBefSCG//Za6lRRUptkuqDrtcsdYzZIIEoorykdsj1f
	 7aJQXsOEKzjO7vPVqWfKVXWZyfAex8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756826176; x=1757430976;
	d=konsulko.se; s=ed2;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=Hvb4wccZRjNtKraptVsMtyIUp9QMrQzrtgemNpw46AY=;
	b=x1Ao2l9Mpv6jH+md0cd2Tv3zs7yF71gVyD2DYoFgxhSRGM0NUPo8yudV9jEg3qQTwRBxz6n/F6lJ7
	 JdB3PTGCw==
X-HalOne-ID: c33fefa2-880f-11f0-81fc-f78b1f841584
Received: from smtpclient.apple (host-95-203-10-34.mobileonline.telia.com [95.203.10.34])
	by mailrelay1.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id c33fefa2-880f-11f0-81fc-f78b1f841584;
	Tue, 02 Sep 2025 15:16:15 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH v4 0/2] rust: zpool: add abstraction for zpool drivers
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <20250827130705.GA7480@cmpxchg.org>
Date: Tue, 2 Sep 2025 17:16:04 +0200
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
Message-Id: <47BCEE04-1759-4242-BF5F-727E2C2E0772@konsulko.se>
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250826124454.GA1502@cmpxchg.org>
 <CB3E7E9C-2192-4C60-B79A-932AD6CB005A@konsulko.se>
 <20250827130705.GA7480@cmpxchg.org>
To: Johannes Weiner <hannes@cmpxchg.org>
X-Mailer: Apple Mail (2.3826.200.121)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4BC6B10000F
X-Stat-Signature: x3ib5aht4gnn14rgn6y1hmmhqboyq7xz
X-HE-Tag: 1756826178-729592
X-HE-Meta: U2FsdGVkX1+6HFYr0p21drA55iBnU+M21P+VKREtWK/EcQKFlbbcdrQl5pIKaI1ObN3Ng/Qdclgb+PIpDvxElHrAzRiM8+ENJ9yQvObcDVGCdNtRrLIAeL0MyKaeZLX2t56n8p5vAH7hy8BSif9I1F6EJwoY8Z9ED94b3MWDkrQKkixpfcm1izbpqGiTKTDaoaqjopAyBp1na012IJs6DSofeRylvlWLhvHIs3Jwfed0+DZew+Ohxbqtxake64VhkpxX4sq2I0IgALS3ZnK/vPZ3atrl9PJAUZ9TYoh/SQJ0n9ltBcb5vrunrVifqSTLk9kWDK9je6s06a4RI5cs5nI+y8zrIykif/RQFelc3HrGUc/05uEdEHgu59GnMaJP4SUXd7HviGpedT7rF0VtjCyISPZojdxoH0fAtovguoHDb3wmYPf36LJfaVhCg32txvGKWKmFohe3hTMCsC1lPXt8vWhvK89Tkev31+OTjq3TJ0Gf5IuTUhT70agY4u+RkMnpJLPFOGwd0ahdSjgZ7+WQkVQIV9GIkT5Q7rUnfclCOqpWgR57DmIu4U9Q+gXr0PR9vxOOetak1ryyh4Mtkqs40garyU/9ghm6BuMNEn2CNm1N+O2v2eqJlkdsaTIHyVDwRMEapnvlHaZkXJdtHeeJ+ASvspxEH+SoaAHWbBxi1RNzVv7zl1ShZ6UFlXD+5yXpQOs04zxh2g9QSUR1b9Dob97q1ax7W9HWWoFN1rIopZ3LtaAdK0gSKsrB6+NaXAn5ZUxZtzl5b4am/esLPvSICPNmuGgxn3Uhvn37BRHbH3bfpjU9+SjZ4W5YMt+tiEnN+4bPkSbIZj9Vb6mWUF6nGRHXhZAKqSDJDpzgpu4A66Ip2xUlghQ+LD8XQKUq13DT/l0gS5Ru+iv2Ss0CsQSpF0ckriXegR4rFuF129HvXlkWe4ko/BcBNQAoNsH69wwnCLSQV/bx6uVcYF9
 iQCb5Zne
 zHvrHtgKnxlWM0cVBFwwftWtlw/jWOzWP/YnOIgSxeofplfVUa756eE6ZtH3xPNFZ01Aug+Edykw/Ew2DxLxAMHtOj/o5XdfRORqRc9c3gMrEbZvXax3DthbTCVGGKGPW9fejotQ9KpCPHBn7YhU2XPpuEILsePK1kjhu4gG83lobTK8BFHTDkDXCbhgt1ExvuM2eTB1zCsXDvAd5MYotL8cVCtejjRhGfj+qkoYMHZfbFZf3Q7ulr8YH8WD6vEZfmpEBjYFkSUg09/lE4Co/83RirOHodsIqQi1yUmOUkimxa6zRvppwcTa5vW8f2AoP5wCc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 27, 2025, at 3:07=E2=80=AFPM, Johannes Weiner =
<hannes@cmpxchg.org> wrote:
>=20
> On Tue, Aug 26, 2025 at 04:56:46PM +0200, Vitaly Wool wrote:
>>=20
>>=20
>>> On Aug 26, 2025, at 2:44 PM, Johannes Weiner <hannes@cmpxchg.org> =
wrote:
>>>=20
>>> On Sat, Aug 23, 2025 at 03:04:19PM +0200, Vitaly Wool wrote:
>>>> Zpool is a common frontend for memory storage pool implementations.
>>>> These pools are typically used to store compressed memory objects,
>>>> e. g. for Zswap, the lightweight compressed cache for swap pages.
>>>>=20
>>>> This patch provides the interface to use Zpool in Rust kernel code,
>>>> thus enabling Rust implementations of Zpool allocators for Zswap.
>>>=20
>>> The zpool indirection is on its way out.
>>>=20
>>> When you submitted an alternate allocator backend recently, the
>>> resounding feedback from the zswap maintainers was that improvements
>>> should happen to zsmalloc incrementally. It is a lot of code and has =
a
>>> lot of features that go beyond allocation strategy. We do not want =
to
>>> fork it and fragment this space again with niche, incomplete =
backends.
>>>=20
>>> It's frustrating that you not only ignored this, but then went ahead
>>> and made other people invest their time and effort into this as =
well.
>>>=20
>>=20
>> I don=E2=80=99t think we have a consensus on that.
>>=20
>> And zblock is, after some additional improvements, just better than
>> zsmalloc in all meaningful aspects, let alone the simplicity. It is
>> fas easier to implement in Rust than zsmalloc, too. Besides, zram is
>> a good candidate to be rewritten in Rust as well and after that is
>> done, zblock will be even safer and faster. So while not being
>> =E2=80=9Cincomplete", it=E2=80=99s zsmalloc that is becoming a niche =
backend moving
>> forward, and I would argue that it could make more sense to
>> eventually obsolete *it* rather than the zpool API.
>=20
> That's your opinion, and I disagree with all of these claims. I would
> also be surprised if you found much alignment on this with the other
> folks who develop and use these features on a daily basis.

By features you mean zsmalloc? I certainly respect the effort put in it =
but if not for it being rather sluggish and error prone in non-4K page =
environments, we=E2=80=99d not come up with zblock.

> That being said, by all means, you can propose alternate
> allocators. But you don't need the zpool API for that. Just provide
> alternate implementations of the "zs_*" API and make it compile-time
> selectable.
>=20
zpool API is neutral and well-defined, I don=E2=80=99t see *any* good =
reason for it to be phased out.

> As it stands, it's hard to justify the almost 700 lines of code to
> support *runtime-switching* of zswap backends when there is only one
> backend in-tree (and even you suggest there should only be one, albeit
> a different one).

No, I don=E2=80=99t. What I said was that zsmalloc was arguably becoming =
a niche allocator. And the point here is, the toy allocator written in =
Rust (just as an example of how zpool API could be used) shows in some =
tests similar results to zsmalloc both performance and compression =
density wise.=20


