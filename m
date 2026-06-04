Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9568FCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 06:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B1D6B008A; Thu,  4 Jun 2026 02:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E534C6B008C; Thu,  4 Jun 2026 02:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90436B0092; Thu,  4 Jun 2026 02:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C91756B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:44:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71491A0626
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:44:58 +0000 (UTC)
X-FDA: 84841292676.10.67F1CFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A5A5E20002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:44:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSINESaE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780555496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eg1wO0x1ENq/IsXBJXt2gj46nNJYx81jKKCliiCgZLU=;
	b=hvOvcunamF9XUu6QHP9cevOmUVD0VDSSkDaky6Nf8karkxLGZVpZMBlxii8RBNbgL7YH+A
	/GpQ6spxj7jJ/E5yWhTcybElPbCvLehk8mphT6OAcZA5FDnMDHzDavZ7J4xAnXD/UyZbby
	9SuXh1dpevY8MSrTTAl9h3PiI4p9SpU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSINESaE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780555496;
	b=Ju+S406eMaJpfPH6njJYALSadstY8xxo5JKWH9ik5CMt4buWwBUXNUpMlyHUgHRsJxa2R9
	Si5sllLJwYSdCSoXGlMV0BKwU700Owi1ywkvpuD28+Ok2dD82hmAicaLyYBmlkvtafps4k
	2h+S5RaW07oQlUbcQ5WT43koXnBfX/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 99F6443E6E;
	Thu,  4 Jun 2026 06:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD531F00893;
	Thu,  4 Jun 2026 06:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780555495;
	bh=eg1wO0x1ENq/IsXBJXt2gj46nNJYx81jKKCliiCgZLU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=kSINESaEKV7JW5BpKKWTTJLN2/ROfMq1dt1OAHj8IfNMYKL2MLNJ66QCsHWkO0lXJ
	 YtTchJHjUYP7utCwVMrFTJBZVlq6ZbMUl1Ly4Nefp7TxoWRxpx6S6U/pzwIHhjuKuw
	 shrkgCZq3tVOokqWtM5bHelh8wbCpQJGuqcMDHt6AEg9xW2oveFYQfEI6aTsr6fXPg
	 BcBWRyKlRe9n7nlgztHjCUBViF3rUstPFCK439VKoMRRsnCegTIY9AVtuQsJbdtbe1
	 cjsnyWWxuLhZSjgBpgHpI59eO2mKuM6ykjZzApUhEpTILD+TPXQc/2du324kXUR92r
	 TM2Hdamrbccug==
Message-ID: <045f9e77-7264-48b9-81e3-c4995d84d026@kernel.org>
Date: Thu, 4 Jun 2026 15:44:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 bpf-next 3/4] bpf,slab: Add slub-backed allocator for
 bpf_arena
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, vbabka@suse.cz, harry.yoo@oracle.com, david@kernel.org,
 tj@kernel.org, roman.gushchin@linux.dev, peterz@infradead.org,
 linux-mm@kvack.org, Hao Li <hao.li@linux.dev>
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
 <20260530011345.99342-4-alexei.starovoitov@gmail.com>
 <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>
 <acc86e41-21d7-4b1b-b5de-fdc02064a959@kernel.org>
 <264ec41c-dd1f-4957-9032-943fe719dffe@kernel.org>
Content-Language: en-US
In-Reply-To: <264ec41c-dd1f-4957-9032-943fe719dffe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0VNFm27eFE0tres1yP8QrSXf"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mfgfxzm15amaxbg7d1nws1r7qh3zh9g3
X-Rspamd-Queue-Id: A5A5E20002
X-HE-Tag: 1780555496-252777
X-HE-Meta: U2FsdGVkX19Rx4iVoaWTq4xKRQnsBKZ2deHWy+Dqun5nP/OUdrfnGaOMepMGZ5VWE2kwejzjhuxLQJ9a/nCuzmFuDdPOK9cRTuIw+VnnRmg0FiU25wt704YbI/b+Ul56gQ1NmkDQ3+bEee6fMgTth6sDm97RsDeMxBA5OaiNyOB8UcMHYl7267bdSiw7PIDpqGKVP9k9yyhGJz+40o96sdxxxuT5IsmmvK50iICTYH2uX6vydAN5GT70wcQxYAFqsWWq8Sy/E10WAdMRzs4prychoC2OC4sA83oe5hS5e9qhu4VPrEXXMbS1Rp76aCq/1HAVHufGWDpAMmL93O7QJ8HXF0re9//yqJZFWKzuKBg7ynm84cYjZmHF0GYnQ3hFwBK/EyQdC89NW8bfru1TLFoXqZhIbLYK95ckM7cEc8eSMX05ff7/Yl5ipl0QhPXETV3v/FYrKUQCJo7Qj6QWMHhV6K2dFOj7eO2i5hBXOvz4BJWdlwSMmVgOOQDMjT4hjQ1YNaFZTALMvfrYXP2qU2Qd4H63sEs8ra571M7SdPEvStDD5NeuA8QV0scPI9piNixzZ9oubQTjyqDyr0ndEsnmUrq+Wi9H3xI2a3zgdywoUMD7WeLdpHQCiyKRXveHC2rM0JYOecmGGAIdZnnQFpmU3z21ABY7KK1eqc60lHZLG2Hjf+nNYfMdSz5hxVlTbxxHMIumlWe5E6OsaKZnSZZ4m0wM2UJhxG/qLd/5AsP7Ke8y5JotiRLQWvvvTfWCK5ucIw9j8v2cLv6PeRNgIcOXV3SF5gEwuhxxkQoyGrZlOU7VyvMHoZUlcdBH/mkBUx913Bo1i1RrwrOypfCkHikdOzxHH8HTuYw+yAyzZg/gzZAfVmh0e1uOhzA/4aeD+04wA5r23FARVZXhela99FWD2NApgR3DTB7YYRuLFcQFycdRZN5W3LDCBk8mfaRgu+g16hqpY7chhG1AGFc
 nUoRYPPA
 c6oyySIfisIUz4O35R3Peef7Ju1cKANgFG4KVz6/MRmft7YSzLkqWOM+RVGLBoGEl4e4toBmLeW4uwujiP7arKQpYV8Uf632K451Ek71EKU8J2+bl6d4oY+pFEe6btOazhp+3DkGptz2IZ1XMjM5PFKrH6Bj/4nj+7Gd0yATWoSGCUqdoLQrL2GQxBL3LNe5OryJfe9DHWcRcx/tNPoxx9LvF+rsrvheAr0iH5t7w3WdYsGdo7aan1a9wgXEO/IsRXblIIAG70CH2k7fi3loduLJTHMxXyvUdNyoIwgr3/UvpXue14Uqc8mL1aXZPm89qXYhXhTqwIjaa7pQ/clTylHTkU4CRUA77XyMdA510JyO4z07qII3BaUkO+3irFxihcWnNKsVgZn0+P0L7zl8WpZ9AK/tvu/Maa0P0IJesM1YE5bzKP1jGQiB3HDQursThUzGjNhpm0niecKFOC4TFLZTLrTBCoj/Pb9iMzZ0g2tq0tJL1brUjlmoOKXj+kLkTam40srl7jZmn1CclzYoUgfwsctxaXE38BZkRYtzic4uV7K4cZ/S50KuXnfxIq1DIhPMRr3kFErj1Y1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0VNFm27eFE0tres1yP8QrSXf
Content-Type: multipart/mixed; boundary="------------JelRG0POZLUZAiAcIUC1l3PH";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org
Cc: daniel@iogearbox.net, andrii@kernel.org, memxor@gmail.com,
 eddyz87@gmail.com, vbabka@suse.cz, harry.yoo@oracle.com, david@kernel.org,
 tj@kernel.org, roman.gushchin@linux.dev, peterz@infradead.org,
 linux-mm@kvack.org, Hao Li <hao.li@linux.dev>
Message-ID: <045f9e77-7264-48b9-81e3-c4995d84d026@kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf,slab: Add slub-backed allocator for
 bpf_arena
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
 <20260530011345.99342-4-alexei.starovoitov@gmail.com>
 <ca1bb6bf-f25e-44ba-87c5-e23e4939dbd5@kernel.org>
 <acc86e41-21d7-4b1b-b5de-fdc02064a959@kernel.org>
 <264ec41c-dd1f-4957-9032-943fe719dffe@kernel.org>
In-Reply-To: <264ec41c-dd1f-4957-9032-943fe719dffe@kernel.org>

--------------JelRG0POZLUZAiAcIUC1l3PH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/1/26 11:53 PM, Harry Yoo wrote:
> On 6/1/26 11:36 PM, Harry Yoo wrote:
>> On 6/1/26 11:06 PM, Vlastimil Babka (SUSE) wrote:
>>> On 5/30/26 03:13, Alexei Starovoitov wrote:
>>> I'm far from sure the masking is enough to contain all the bad things=
 that
>>> can happen as a result of a corrupted freelist. Even the hardened ver=
sion
>>> wouldn't help much I think, if a malicious program can both read and =
write,
>>> it doesn't have to know the secret seed to craft valid freepointers.
>>
>> I hope "a malicious program" doesn't have CAP_BPF, or am I being too
>> hopeful?
>=20
> AND (hopefully) distros that care about security don't allow
> unprivileged BPF programs these days?

I think we need some input from BPF folks about whether it's enough
to perform best-effort, cheap sanity checks to avoid letting the kernel
crash in most cases, or assume that a carefully written random,
malicious BPF program might try to crash the kernel and try harder to
prevent that.

--=20
Cheers,
Harry / Hyeonggon

--------------JelRG0POZLUZAiAcIUC1l3PH--

--------------0VNFm27eFE0tres1yP8QrSXf
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHQEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiEe0gAKCRCGXBN6rc5S
1oJNAQDFXIYveJocYCTW+3lbDX/I0UmTYyRpXNoIdkCynpoz+wD3agpdnu0bi3Dm
/Z8gZShtV431bsDrNIpS3P73bRvhAg==
=XtUT
-----END PGP SIGNATURE-----

--------------0VNFm27eFE0tres1yP8QrSXf--

