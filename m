Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A31CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 05:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F1F6B008C; Thu, 11 Jun 2026 01:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF816B0092; Thu, 11 Jun 2026 01:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFBF76B0093; Thu, 11 Jun 2026 01:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEC626B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:07:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51697404A4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:07:06 +0000 (UTC)
X-FDA: 84866447652.26.7DEDF0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A7D61C0004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:07:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xh15kYyR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781154424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRwcg4EyJZpJwbVd0kBy+DE0ocP3539N0zcggV7Obec=;
	b=eAlxk4GCbSN10rvdJ7D8u+8hyDsslLB3ojPAZ7bLCcR0aP/tgNzQNmh22nRNZ+14NTf9xG
	cUoFekjKzQ2ImLTjnAujGw7QWhk8+BMzza1pVrwfvcX9iXoyJQZg/AUiRzEciWggXVEwry
	Rz9aiilKhxLDBwtoecTPjX8aOwRub10=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xh15kYyR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781154424;
	b=QsGckVn6AyCPJrehNaNVLwMF4UkS/heaJvSt4H34h2lJdUB5kYSMHFn8Ti5HFmKQaBnxM+
	fDKGR+bpJpqqup6YvJFueEsBN88Vi9mxkccyuUbrHVk0I5XyZMdZxGd8gya8n2sZyarLap
	sciuiUTr/03prMG6sNNAYi5QzfxqF0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31AB660208;
	Thu, 11 Jun 2026 05:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD43B1F00893;
	Thu, 11 Jun 2026 05:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781154423;
	bh=vRwcg4EyJZpJwbVd0kBy+DE0ocP3539N0zcggV7Obec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Xh15kYyRcoKUbtk//iaHVwclsSBPXWUStJlO5F51fOJvxKt88liTK0Xtqi8ZrzIvP
	 KDVnc3COPg8snsonRgh+a+hQJeDiN/hcwlSGoRQxxWEnUzM7tIAq4HFJ9QCt8/a9/Q
	 TLJh59BzVpmV/JokQNTNLpRtQJdcSHC5N5Pg9PgjqYoVOhA3AB/aG2AxwSrS/lfZ4G
	 Lqp35I7nAd4QuPpjzOYPpCPeAvsf/Q9vEr1S3ltuOBhRZ7h0yjvyI3VAZ+8/aBwSS3
	 AZCF9O/AFTyzSeC/+FUTKVmr5SE6Tv2tqItOQLCqu1DK2QED+wAmrD+lEebmFfSsyF
	 F9vRyHberjwyA==
Message-ID: <6a2d63df-bc0e-4adc-98a0-2873b4249e77@kernel.org>
Date: Thu, 11 Jun 2026 14:06:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/16] mm/slab: add alloc_flags to slab_alloc_context
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HNfaZktokc0PY3nz0b0yHnGR"
X-Rspamd-Queue-Id: A7D61C0004
X-Rspam-User: 
X-Stat-Signature: hewr1nsjqbx6e6xbmyodnqs6uttcuy59
X-Rspamd-Server: rspam09
X-HE-Tag: 1781154424-219873
X-HE-Meta: U2FsdGVkX1/RlnN0FsPDmIUrLn3XSP++A6G3gcyWHTdC4WXYHzvwB19YB+5xcrcHNlguahmND+QEu3N8k6TdcwZzfzTDDvegC30qrycE5E5CD6jDCLXAiYdKZUMwj+brnk2mcA51zMQT8vGhU1TYjPvJkGClz/alhoxQJWQOYa0GlAoHRUrEwHj73Ezg3LkF+GKee+GNNAwYgGg3id7jQ1B5qaGR7ZmYsnKBtpt16KIgJNFNUf5YdWQ6FKOBfUPQcRfLIgi7IMcPtzPVegtOdOo/DBYMNQMVo58ZcBa2fVLhSBK2HrOTdqhYGIjnySO15fRchNGOA4Ke4ClNxUP89WAlpefyKJD4bmNtrZuY3ZktoIdXYrpkWdtxsnudNSTUUVl+csnAyLLgfp86liluBFYUUTE8zo0j6E/PGkxJs9XshE8YPMINdYrgVmt/YCKUZWjLlvdnscbHdsF1ltWnqjM+ZXgeCQMcJ5ktzgQPetsb1FwbG1LiTBMn5Q3+I8qcIMU09netWsh4ESNo2WubI/J2ilOVZbqDW5RqsESesbkxuUUnocOZM0gPC2I1gzCBfRcIWSF3vwRoyyBrM1ftKgFzkO+f5lKHqbTGAVCM3AnkiLjO2ooINfZLqpOnhN5mOEAuH5T233XD29ejpO6YGNN9+5wyyjnM33Ns3mye0llJwhoZm3C8K7c6htwpDprrUQ/pnOr/28VBGs+QPDQZYaWxg7zJ2T5eqsebeQnf/yaEgNnYVr4kq2jVzcrjeQBp5IRfobBbjDM8f/QFblP+Vygjo305afx2ZO6rLWCCKEEN14yiF5DrsG9DW2zO/alDjnkNJm/qfAilFPQ01JC88PcLCzSykAG9dv+O9gRUjmJFdPm7pGo26mWG2ZJCVGsIlpyFMrneuauyxLwBTrYBKXgFJi9nVy1T6Hb7KW/1ZeC7RrgaI9hQG8zOQHid3Fb5NUbcfvfk/f+h65m8c0c
 5mIwMhmZ
 yaBghDZHrMzCbz+axHtpxPMwbZ7o2/+pQ/k6bBtQDKfqIHXQGI8A65DOTqbtjS72+qvuMibvYpr1RA3I4AZzRgmKsNBYLEe8Je/C7OlX2IETAOaP1tjX5yBt4LfpvpyuiT9BIdZ271ZlVrdjpdWTEPyh6Jp9ju0WBNRrp0QZhNhQbdwOfzp2uAXjzZ3q9TTFjPi0kXVIf4GlOvgKfvSjGLk1YLuccu6kqUpNB6+lt3RE3RN0h4jra/jUUm7JxTC3gFXFMpxol99qLPYzaBxwhdlscNptTFKsC62HZdBPPIctfXY610eilsyKViOaULd60lZlBRTfyQI6PvRNzhhWhcZRLZOzTub/Uw1eIVF1dIUzNXIvhBcoBQ0Vhx0pvOLZQxjNLEsSfwUW/EbxT58twPl1MXf3XZHfcnfud0QJIUw3tRyPl5dJluGQLuhCxzvwFKidqVfDXLigAlRasnQi64I2G0+ErKr4SvmSkpTvazXjh057rsPNwK1Amvf9ww8HcDlK0DCDbfyfvIFvZXEJriQzdRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HNfaZktokc0PY3nz0b0yHnGR
Content-Type: multipart/mixed; boundary="------------JeXH4IXAE038L45RFEnMfyKB";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <6a2d63df-bc0e-4adc-98a0-2873b4249e77@kernel.org>
Subject: Re: [PATCH v2 06/16] mm/slab: add alloc_flags to slab_alloc_context
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org>

--------------JeXH4IXAE038L45RFEnMfyKB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/11/26 12:40 AM, Vlastimil Babka (SUSE) wrote:
> Add alloc_flags as a new field to the slab_alloc_context helper struct,=

> so we can pass it to more functions in the slab implementation without
> adding another function parameter.
>=20
> Start checking them via alloc_flags_allow_spinning() in
> alloc_single_from_new_slab() (where we can drop the allow_spin
> parameter) and ___slab_alloc(). This further reduces false-positive
> spinning-not-allowed from allocations that are not kmalloc_nolock() but=

> lack __GFP_RECLAIM flags.
>=20
> _kmalloc_nolock_noprof() initializes ac.alloc_flags using its flags tha=
t
> are SLAB_ALLOC_TRYLOCK. slab_alloc_node() and __kmem_cache_alloc_bulk()=

> are not reachable from kmalloc_nolock() and all their callers expect
> spinning to be allowed, so they can use SLAB_ALLOC_DEFAULT. This is
> temporary as the scope of slab_alloc_context will further move to the
> callers, making the alloc_flags usage more obvious.
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------JeXH4IXAE038L45RFEnMfyKB--

--------------HNfaZktokc0PY3nz0b0yHnGR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaipCcgAKCRCGXBN6rc5S
1rwHAP4lRaCG706Uz/V2rojPwBLVAPzHiybwiXmWuTC64r/8QQEAiBwpKNWBH0vV
Vhq36kkGoH1BnWFD8fJdic59Ar/RDAw=
=dyft
-----END PGP SIGNATURE-----

--------------HNfaZktokc0PY3nz0b0yHnGR--

