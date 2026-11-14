Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70EB606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G8tM8tV3
Received: by kanga.kvack.org (Postfix)
	id C8F406B00EF; Sat, 14 Nov 2026 08:03:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19BF6B05B0; Sat, 14 Nov 2026 08:03:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9BC6B05B1; Sat, 14 Nov 2026 08:03:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83FBC6B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:03:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC0DCC03F7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:03:29 +0000 (UTC)
X-FDA: 85433740938.29.43DB515
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 559771C0010
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:03:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G8tM8tV3;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661408;
	b=JrpJgaceMMUcRwVStCv4IM5O1TwpCSE/ZVX+XAijiooeFNL80amq8wjTZBCzrDl6+faXGH
	vx6+PlcILbeQCGas7Mj8fbUARupSlsbnSCrfQql52GObSickU5srxrgGURq4x1nO3dZ5hM
	dcY2IfNw4se0Ou+g1pKBpqb03TNCpp4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G8tM8tV3;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661408;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhtDaBqfgfYPjb7TMNuqj+0oVMlkx3O+ARPkcmtesQY=;
	b=nI3ficFczWnu0GOF+ZXs3RtHCFw/G/kWXECZvEaBOflVUA//HczBQGaSO1tO09w9WytyFy
	Fd2bLZz8/QsB2u2OMauK1gxYL8fhfw8obEvzTtS3ZOYtbtomIPIFgNiGyj/pn8sjamiqo4
	HBkyE1o3rSEBrhHF+5rCSD4sAMGvXbU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82C4D60F01;
	Sat, 14 Nov 2026 13:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD181F000C4;
	Sat, 14 Nov 2026 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661407;
	bh=OhtDaBqfgfYPjb7TMNuqj+0oVMlkx3O+ARPkcmtesQY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G8tM8tV35jFTCNUq28dlp45KybfJnGh2jJqB0QMLIquRn0vDcbY21QtoFdt1O3ehi
	 Cg2cDeZ0cVugIZ600RpWcnEGx9Zu7oh9Mpt0IfsM4m+O3j9MAPzHnaQG06ae4aqQHD
	 RWiP7aWTmbUhiZPxv72gnxcBXRz1VVcmQIBK+8Itof18um6imsRq40HEJGGaRIoJdE
	 Ratyi8nW7b4yHC92n72x4GuPb5zaYWB/HLyUs22unOm+kA2jNm6m+BG2AK3hQjWegU
	 QiWAYuYDtrE44wrxIyIFThHQ+wyHyxQg866PVB/D1Z6TJ3Fso5N4n3gSCCYOVhnjnJ
	 BnfHSFljyUX6Q==
Message-ID: <sashiko-outbox-214521@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: kvmalloc: Bail if called with soft or hard IRQs
 disabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Herbert Xu" <herbert@gondor.apana.org.au>, "Uladzislau Rezki" <urezki@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, =?utf-8?b?TGlhbSBS?=
 =?utf-8?b?LiBIb3dsZXR0IChHb29nbGUp?= <liam@infradead.org>, "Davidlohr Bueso" <dave@stgolabs.net>, "Michal
 Hocko" <mhocko@suse.com>, "Baoquan He" <baoquan.he@linux.dev>, "Alexander
 Potapenko" <glider@google.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>, "Marco
 Elver" <elver@google.com>, "Michal Hocko" <mhocko@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Thomas Graf" <tgraf@suug.ch>, linux-mm@kvack.org, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Chris Mason" <mason@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Andrew
 Ballance" <andrewjballance@gmail.com>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>
In-Reply-To: <avcKfEvln8_2a7fJ@gondor.apana.org.au>
References: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au> <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
 <auy-7TvVzJ-VCrG4@milan> <avcKfEvln8_2a7fJ@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 13:03:25 +0000
X-Stat-Signature: dn3ch95nbbxxixpf9kdxcok9whnr7hqt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 559771C0010
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661408-436359
X-HE-Meta: U2FsdGVkX1/e9UdsUrirNEQwO/9bn5RjQrapxEKJ2bal467SLU51RJ6AtFF39Zaf88oSATmAQGGA/MvchrkYu0IcfS8TPIVPOn1ZPIrNFCVJXHGVJHqpD0Q2XmB+gOxCr+vriXVCg5RhiZOXF2A3pHDBgrjagSNPqn3cBMSITSje0fjThNOYgVQp7ZbaIzZNX300s6rNK+rWK7roZHow1LTGxk/OsrEjEW/8aTqxgT+Hmi9ZmlhFPoqHYFOsP73MAMPyIXWuxl+vbKZ1lQHJsVvmeA481cehzhMiUrRwUVHaLAXLs4OpJkawinC8p45sIpiq4aaY7yfvb6Z/0mHV7OF0JgG2zug15oKb0PsQtuq8y9kmbxMNf/Mc6EwlXi3tyjdp0XmBCnD9Soovr/kWuzn05E5PQj6h4vI2EZcJcMhTuCh4AQvBNjgn2oKpXthLJm5nwHJy9CUs15U06BYoeVQvBIcAWAzi2UldFRbqSzTk40FqpPJohhgA9hshbhdfDJlyNK9lCj/7l/KDewzBNMFzd6tS/C+6tYNelsMCW8U11+jo6qGtFrn1sLqhogMnOhdjQqhL6f6ff84Y7DFGhAR1ePK9n6acm4xG//D3bEDK8fAptVh1tnH/MCyqGX5L4quILQ7mzNf+2tkGS2IWILRlvKKc0UjRIOOFvH3Ec3tTvWYDZGlTq9PJsvj332yWs+pZkv36yuyj0dK+9R/W+f4DMQAqxxRsbKgLL3aYYwL4ov/Kt8K3igrXUqSrtZc7Y5zCXw5Zwyw2YnVaaq905xKGkkBcg3mRz5Rpz6XGzuLuyMEtx7ddscDudO591TNgBq6OpiyC3WBIscumP+208I4jKn/dC68jnqc7yq4x7PNTGh8YcB+nY4hvYMZuVKmMsgf8RbIuYs3kgtkdzLkGNz6UepAJv7Drbmjd50LLpUv2onLDGDE9gbkk++5iDZsrDdjlZn8Cdkmzgka6J7x
 G6zbNoqT
 uF7DuM8au5ewEPRxgXOBLGyKpOCqs/nPcOdiUgRvIrG6EaOrBk37x6xrpgVU0gPhmqJsf6QjnRrJW8g1EieEg+h9ADBaoiAkpgbiwIIv5GID05f56QimSdoDjqc375+2GQMn0qZ3yeGp2p7JMDRRZnL8OQVeh0b0eX1HW4M03tLdQSJTibd32yn5Cp+NcFI2x1IE3alvBnps2zMSCj69a/BkFEkPzhkQxy9iNh8dJIusC67zGBgCe4lxtFjP2NFImRG6P2f92Z5L2LARgcCxfoUqAsPEMw9UjjBerrtSlrRfhaTo1ehdJHW3j1ql0TxIyFobBR/CeJwMBEpUtxDPJqaRkuUp+4wmNjdwQxLk0j1zgFpcKRq3U5650JfZ43w5jPanbzrDHH8YlgXuas7EO96CzUuCBwI6wSp9IP9r65gOmCPQFZrD2iBFMvz5p5Sx5YFDCo/FlofevlGYhtlq/5Q4c2Aztvex3CU+A6H36aNQa5ZAAKxgPJPHxwkvu85yCG8+EtxuImKJDfibtXUXtx1YrtjqMD9Ntmssnuzk9MYeXEQO3HRMKkR7riTDQsGjm3toEJ1xFeNza78R1JFLj+BvTteA5SBveMsiy2POwsRiZjo1H2Ad111OmiSaHdvwrBX0HANCoq4+REInrJjryQsy2TLco2s3KAXro67eSMSw2SdZQMDxTbjsUQpDhufFu3HIJgSIQjJwiMp9LrcrelhxYfchWUxz0B0nkRrP4qiVmfbXL3iiS7bTSQaOqzC+uW/cvmVRVAe9b6hQEhrOk8JbVrRw/miy682Ev9VGriEEpMoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm: kvmalloc: commit message mismatch and deprecated
  in_interrupt() use
--

commit bac4fc34f0010889bd9f7724714bf23ec9386ed9
Author: Herbert Xu <herbert@gondor.apana.org.au>

> mm: kvmalloc: Bail if called with soft or hard IRQs disabled
>
> On Thu, Nov 05, 2026 at 06:37:49PM +0100, Uladzislau Rezki wrote:
> >
> > Probably the simplest option is to return NULL for non-blocking vmalloc=
()
> > allocations when BH are disabled. That would address the reported
> > rhashtable deadlock.
>
> OK let's try this patch:
>
> ---8<---
> The function kvmalloc may call vmalloc under the hood even when
> used with GFP_ATOMIC.  However, vmalloc uses naked spin locks so
> it must not be called if the caller already holds spin locks that
> can be used in hard or soft IRQ context.
>
> Use the heuristic irqs_disabled() || in_softirq() to detect such
> callers and prevent them from using vmalloc.
>
> Reported-by: Liam R. Howlett (Google) <liam@infradead.org>
> Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/mm/slub.c b/mm/slub.c
> index a151268b97263..5965d69926154 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7148,6 +7148,14 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(s=
ize, b, token), unsigned long
>  	if (ret || size <=3D PAGE_SIZE)
>  		return ret;
> =20
> +	/*
> +	 * vmalloc uses naked spin locks, so it must not be used if
> +	 * the caller already holds a spin lock that can be used in
> +	 * a soft or hard IRQ.  Use heuristics to detect this.
> +	 */
> +	if (irqs_disabled() || in_interrupt())
> +		return NULL;

[Severity: Low]
The commit message says this uses irqs_disabled() || in_softirq(), whereas
__kvmalloc_node_noprof() calls in_interrupt().  Note that both in_softirq()
and in_interrupt() are marked deprecated in include/linux/preempt.h and
documented as not to be used in new code.  Also, the commit message still
contains the unstripped email reply preamble and "---8<---" scissors line.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/avcKfEvln8_2a7fJ@go=
ndor.apana.org.au?part=3D1

