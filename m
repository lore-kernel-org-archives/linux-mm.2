Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C0AACDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415846B0005; Thu, 25 Jun 2026 01:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6B26B0088; Thu, 25 Jun 2026 01:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5B46B008A; Thu, 25 Jun 2026 01:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0683C6B0005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:27:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AE6B167626
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:27:31 +0000 (UTC)
X-FDA: 84917302302.21.4F03853
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A0B61C0003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:27:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMfGlucx;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782365249;
	b=sATo3Q5lVyRhyK4Qe32MC846sKUmDG7UnGFUmxTzgmZbjkhrRJ3MG4ynAuZoUKaZI2L4SD
	ojGbFLgV1l4XekuEz6hXcTUq+seh8YgX6g9KUvAeaY/hDZPxQz1BP8BFhxzbdP7NKhsdV4
	wv9+r+PxBaKyyQW4BfVdSCtO7s7b9Bg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782365249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16gLOvVg1+I9vrM7P9jWzIPMeQh/IJhgDY9+aNOXBAM=;
	b=yvprg8+eA1QD3pOJF6IzqY1KsvO3IXC6AWDrzhQoLfjzkwaKRmvj4MGs29jtv0DhsBoAyY
	crzu0IarYC9WE4SwdEnE8RetnyiSha4HAz/+OPgX4VFFscPyi85Ir9ajMakpEhaLCt7vaN
	4EF8g9WrZD7/uqRV53Px1M0UR7VZ7MA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMfGlucx;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1ECE43B7C;
	Thu, 25 Jun 2026 05:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7531F000E9;
	Thu, 25 Jun 2026 05:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782365248;
	bh=16gLOvVg1+I9vrM7P9jWzIPMeQh/IJhgDY9+aNOXBAM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UMfGlucxjCtnoosPgwHb0AUMixwX+WJ+i4FsrBedZL55zbcOs5lBJ1+R0wNt9bZpG
	 dw3r7UHuCmhwawC6FjPIAmf2C8GdgV33ptgxNQLw5nvQtfg1nO6WaMDDydxPYO1R9g
	 wKJyo4XyGTUfN53RX0t1pMTaIuXOphmH+RM8POA26SvE223MFAZlj80wyphGDYEThn
	 9p+HptNmFNo1hOvR7ECRYbnRBbHXb5JII4/BSBVdIB18aMom9YNoXfSd14Efu3oEO6
	 94rcJ8AQR0hcYlEI0Vt9urNhvqUYiW307twuZR1kIuS95TicAFKMKO/TBgOXKfJisy
	 glckMWm75eQog==
Message-ID: <529a9856-4a0d-4db0-9c97-43c0c462e396@kernel.org>
Date: Thu, 25 Jun 2026 14:27:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 7/9] mm/slab: introduce kfree_rcu_nolock()
To: XIAO WU <xiaowu.417@qq.com>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-7-70a54f3775bb@kernel.org>
 <tencent_45CAE878B5922990DB102BE05A1BAD50DA09@qq.com>
 <e54ce8be-9480-4583-9c6a-d0dbe1378f53@kernel.org>
 <tencent_12A1049445F2CE248F20CB235AC111353A0A@qq.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <tencent_12A1049445F2CE248F20CB235AC111353A0A@qq.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HHB5JammkAG9i5v0ifUbiioD"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A0B61C0003
X-Rspam-User: 
X-Stat-Signature: neyw5tnnwcms7nohjmf5r8na6zs9qfht
X-HE-Tag: 1782365249-933636
X-HE-Meta: U2FsdGVkX1+OgI2yCNIaYTzlXt/JrOVYrnWfRG6f0Mt2tgSZCtbiNLNxdA3/wjZ8U6o9YWp60OMiZpsn9awY4H+cEG7i8tPfwfIs4jTLAM4WtUSqHOC0UzP8wh7keLdyEG21axCX8tDVn5PfhIBfnNhNr4voJCt/H6x0rKtO/pJZIUVgCIypI9eY8KsF+2V2rT/Oa3nmw6/xC5RaFUo8bW70gOvPq0Oie1sGEN4gg2yiPUEtbwl9nXBpr+IFZpDdqQ7VusjTYLy0PZ5XtZl6hTKTtSiBY11IVjb1M2n/XK/V1F8FbjtUrXXd9ICfbmHfkg5zMmTJBf0NjBt6w6O4+T7itKVNBtLVkGEOn+3jLM8yTzo31GbJFqH+iGffzyAa+ZBhfsi7P5om6u4w1+KzDJGp+G+rj3M3kN2iZalivpuAeB6C55F9i5qFxDyPb9JPacumwhg1eOckTdscvRSV8c8AiWLFtxMIC5IoaveeahfiteoOaXCCgAkkKtA84f49KQV5jpCgjImcEbSXIyrDrdoDv3IhHRCgAmr4xQSyxzOGO/r5cwmPEicKvFjzUSXLNGTA/Z7fTEdcu2tziSrG5/5Y6XYgvSDTDwe7Q4wjyYYgb31sd9WiWY4/B7z4IqmpVEWaMN8fQl0m1QmNOcfd0/PBGhsWaMv6mHrxO10yrUz7W5pN3/MKKNjGVbd6nKkbwEAdgob+IZU23Wl8wa1Vsxcmrn8sbc3N1sUGQP5qWMF6TKIzW8EQEzsGrkxmojGcShI0wbaMpHwtddzF1HCimgTQkcLDLjfx17Qc+Ic4fwoXrWjMTbq+UtRCeeh5oWjWYjQ2pYaPJDVN5UidvSUowjCDsgHODki0DuZQ9fPEKi+igcCtatBZVAgQvsp29rWdfunR28HGMx3C7gtibyyklNdkqxQsX7sZHLhv5IeHGu5ybrCGxyrIoizuYrwaYy8IuHwRdevG4CdiGD47Sdx
 OCFFnloS
 FUkslCX558y74OZ/rdDax0aZqa7JHF54wmYUot0g0bzUWuSp8lxPNhPW3kgzUp3RnW6nIGY4Cap2AEVE92uJZ5LRU4FT1Y8rJYqBETfAxmsrYLIVHFoerqJR9Z/hwgxXcltoSK3JKFgER1esoTUGyP0VaIgnfjP8ahSmDgpqR8ft1cx9LJpCfopOqqMe4ogcYkKrYCHjipbmLm6JlH0TcB5cx60NjTIpHmmMQrWYrkrnsB0ktDGN6HLxLMuaj7WvDvw95kGwM0dKSRbLRgbk0FrzADfzyN+NylpJPX4Jt3URuQFjMt3xgC1Fw8H6xcRNhl+Ml0itd2TsqiUa0K3UGKellAc4bs8useYIAZk2It6o1kk07XfeRTlOHlneHJw9wvhzPRMQDDo6TfXvDFZf3UZSJpQmB6WQ/QMTektjTCLH+Ld6k4NB3uYWWB9C5+yZMqrSJscJA/wYDR5cWKe9AwJSp6PasvRFXgvNR2X4Xi/uPievvOP1vojBAQGXIE3AzxGRP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HHB5JammkAG9i5v0ifUbiioD
Content-Type: multipart/mixed; boundary="------------5yZ5NYuEVU4HrXYvVZYNisDF";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: XIAO WU <xiaowu.417@qq.com>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <529a9856-4a0d-4db0-9c97-43c0c462e396@kernel.org>
Subject: Re: [PATCH for-next v3 7/9] mm/slab: introduce kfree_rcu_nolock()
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-7-70a54f3775bb@kernel.org>
 <tencent_45CAE878B5922990DB102BE05A1BAD50DA09@qq.com>
 <e54ce8be-9480-4583-9c6a-d0dbe1378f53@kernel.org>
 <tencent_12A1049445F2CE248F20CB235AC111353A0A@qq.com>
In-Reply-To: <tencent_12A1049445F2CE248F20CB235AC111353A0A@qq.com>

--------------5yZ5NYuEVU4HrXYvVZYNisDF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/22/26 11:56 PM, XIAO WU wrote:
> Hi Harry,
>=20
> On Mon, Jun 22, 2026 at 02:28:44PM +0900, Harry Yoo wrote:
>> On 6/21/26 9:29 AM, XIAO WU wrote:
>> > I was able to reproduce this in QEMU with KASAN.=C2=A0 The trigger i=
s as
>> > simple as passing a large (>8KB) kmalloc buffer to the new function.=

>>
>> Thanks for taking a look, but this was intentional.
>>
>> I should have documented that only kmalloc_nolock() ->
>> kfree_rcu_nolock() is allowed and kmalloc() -> kfree_rcu_nolock()
>> is not allowed (yet).
>>
>> Since kmalloc_nolock() does not support large kmalloc, the warning
>> is not supposed to trigger. That is why I added only debug warnings.
>=20
> Thank you very much for taking the time to explain =E2=80=94 I really
> appreciate it, especially since I'm still learning my way around the
> mm/ subsystem.=C2=A0 You are absolutely right that kmalloc_nolock() ret=
urns
> NULL for sizes above KMALLOC_MAX_CACHE_SIZE, so a proper caller using
> the kmalloc_nolock() =E2=86=92 kfree_rcu_nolock() pairing would never h=
it this.
>=20
> I did notice one small thing that I wanted to gently bring up, though.
> Please forgive me if I'm missing something obvious here.
>=20
> When I was reading through the surrounding code to understand the
> pattern better, I noticed that kfree_nolock() =E2=80=94 which has the s=
ame
> "only for kmalloc_nolock()" constraint (documented in the comment at
> mm/slub.c:6828-6835) =E2=80=94 actually does check for a NULL slab:
>=20
> =C2=A0 void kfree_nolock(const void *object)
> =C2=A0 {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 slab =3D virt_to_slab(object);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(!slab)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ONCE(1, "la=
rge_kmalloc is not supported by kfree_nolock()");
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 s =3D slab->slab_cache;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
>=20
> So kfree_nolock() gracefully returns with a warning even though it too
> expects only kmalloc_nolock() callers.=C2=A0 That pattern seemed really=

> sensible to me =E2=80=94 it costs almost nothing and prevents a panic i=
f
> someone ever passes the wrong pointer (which they shouldn't, but as you=

> mentioned, the constraint isn't documented on kfree_call_rcu_nolock()
> yet).
>
> I also wondered about the difference between WARN_ONCE (used in
> kfree_nolock) and VM_WARN_ON_ONCE (used in kfree_call_rcu_nolock).=C2=A0=
If
> I understand correctly, VM_WARN_ON_ONCE compiles away entirely on
> production kernels without CONFIG_DEBUG_VM, which would make the
> subsequent NULL dereference completely silent =E2=80=94 no warning, jus=
t a
> panic.

It would crash without debug option anyway, but warnings are there to
make it easier to point what's gone wrong.

And not testing the code path at least once with debug option is a big
problem :)

> And since you mentioned that kmalloc() =E2=86=92 kfree_rcu_nolock() sup=
port is
> planned for the future (the "yet") =E2=80=94 wouldn't this code path ne=
ed the
> NULL check at that point anyway?
>=20
> I was thinking something like this would make the function consistent
> with kfree_nolock() and also make it forward-compatible with the
> planned kmalloc() support:
>=20
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1266,10 +1266,16 @@ void kfree_call_rcu_nolock(struct rcu_head
> *head, void *ptr)
> =C2=A0{
> =C2=A0=C2=A0=C2=A0=C2=A0 struct slab *slab;
> =C2=A0=C2=A0=C2=A0=C2=A0 struct kmem_cache *s;
>=20
> -=C2=A0=C2=A0=C2=A0 VM_WARN_ON_ONCE(is_vmalloc_addr(ptr) || !virt_to_sl=
ab(ptr));
> -
> =C2=A0=C2=A0=C2=A0=C2=A0 slab =3D virt_to_slab(ptr);
> +=C2=A0=C2=A0=C2=A0 /*
> +=C2=A0=C2=A0=C2=A0=C2=A0 * kmalloc_nolock() never produces large-kmall=
oc or vmalloc
> +=C2=A0=C2=A0=C2=A0=C2=A0 * addresses, but be defensive: fall back to d=
efer_kfree_rcu()
> +=C2=A0=C2=A0=C2=A0=C2=A0 * for unsupported pointer types, consistent w=
ith kfree_nolock().
> +=C2=A0=C2=A0=C2=A0=C2=A0 */
> +=C2=A0=C2=A0=C2=A0 if (unlikely(!slab))
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto fallback;

Just FYI, virt_to_slab() and virt_to_page()
don't work correctly for vmalloc addresses.

And I don't think silently making it work is good.

> +
> =C2=A0=C2=A0=C2=A0=C2=A0 s =3D slab->slab_cache;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0 if (__kfree_rcu_sheaf(s, ptr, /* allow_spin =3D=
 */ false))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>=20
> +fallback:
> =C2=A0=C2=A0=C2=A0=C2=A0 defer_kfree_rcu(head);
> =C2=A0}
>=20
> Of course, this is just a suggestion =E2=80=94 you know this code far b=
etter
> than I do.=C2=A0 If you feel the current code is fine as-is with proper=

> documentation, I completely understand and won't press the point
> further.
>=20
> Either way, thank you again for the explanation, and for working on
> this series =E2=80=94 having kfree_rcu_nolock() available for BPF and o=
ther
> contexts will be really valuable.
>=20
> Thanks,
> XIAO

--------------5yZ5NYuEVU4HrXYvVZYNisDF--

--------------HHB5JammkAG9i5v0ifUbiioD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajy8NQAKCRCGXBN6rc5S
1oG6AQDcpJmCoSOVmh6QBfAn7SSLAj/dCrCVdlDGkux+9WPEAAEAwzyj8gI9j//s
tpMbnooH3cAwdhFTBanFE9AL924TWgk=
=XwYR
-----END PGP SIGNATURE-----

--------------HHB5JammkAG9i5v0ifUbiioD--

