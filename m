Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DEEFCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57CA6B008A; Wed, 10 Jun 2026 08:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F206B008C; Wed, 10 Jun 2026 08:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45976B0093; Wed, 10 Jun 2026 08:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C25836B008A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:07:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E0661C3434
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:07:01 +0000 (UTC)
X-FDA: 84863877042.19.0E9E7C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E24D61C000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:06:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GeGBmsT3;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781093219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lvjM4grmcimakDhjqCbNRnKzubZHkQeH7hKgRM5Kes=;
	b=juRk5pV8EIgpbldbqDwGy597XebJFlVx4VSc4ex2k3OoMYQiw41mKbvEC9cpJg/hjMuMKV
	S89Sd+LaLZBCUYCof136r4CKdnrV7/Q3FFi54LJ4FUVBnwvCX0CX7ZuYhtgeBQHMZFCGz9
	2VoUzxOQSgWfGqg4dEpKJDYL2qM1P/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781093219;
	b=TLcUrZPIrhuHtzNgnbdtMachsy8H1i9aBShDta7pqP2rPCAj9YRumYmvDtqyuF9tBroRX/
	F3SNpVD5i9bD/oexPgYkwuZ1wLHPC9Vhl+bsQ5Xlb86d3FtbI11YjU7+ER1CALeIpf6yjC
	+thEykklL7Esa6BQz9vQx0Rrj/qD43c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GeGBmsT3;
	spf=pass (imf20.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 523A56020A;
	Wed, 10 Jun 2026 12:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8BC1F00893;
	Wed, 10 Jun 2026 12:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781093219;
	bh=/lvjM4grmcimakDhjqCbNRnKzubZHkQeH7hKgRM5Kes=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GeGBmsT3+kIwRsklxR1TYcu4DqZ9f5X0qV3yfdqTVZ1RHxYeoHPp7nVT50F9xmJp8
	 SvgyxqCDtgoLHpHMIfy3qi7zMg0I+/ZvihPE4l+DBGZ0+bIPpwYJYWemhdkmgAyfcv
	 KyZeSUMfW120ZPiEt1g26W8BArl6YBtkPQ9kUG8XxhLDcyA+GYY3JtoypalZeDpRnz
	 NpdO7Ms+LsRnii1ytDuw950lQSfwuXs4Jyi0Jr/peEg4/5v8hO6vpaXZ/6ehel5KlP
	 jNNF5uM/RAE99niIFsmrqwHphAZ4npUzWBo8HM3hlS/KQK0G6c7MC/WRTy+gCiL2B+
	 HW2Gm8XlYS23Q==
Message-ID: <d0d7e853-12e2-4db1-8e20-ee66c3006dd0@kernel.org>
Date: Wed, 10 Jun 2026 21:06:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 02/15] mm/slab: stop inlining __slab_alloc_node()
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
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
 <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------o7p8tJJhETiZ7lV3nDNGI84L"
X-Rspamd-Queue-Id: E24D61C000B
X-Rspam-User: 
X-Stat-Signature: 8umkutdfzeb37bxawt6fbjf34nueeeqb
X-Rspamd-Server: rspam08
X-HE-Tag: 1781093219-6429
X-HE-Meta: U2FsdGVkX18C8qNx6RE6kL12uynYUSgehKX1yKbkUgcxF+lc4vqT1GGM54WiZwu/FgsELetWxK6Or8ca8hknzyDMcQy3ntJGr4TuWfArqpGnCe7Ay8Rjib2/F98nk56MGrtZfo5bQvoIeuoVd1AOV/oHAKfZv5LxstacWB+T/abQ8MPwxkVNwVrB654NlhkvAjTeIdUmtl/Ky+QAZZWKvRO7MNMAElAjlAJBa+PebuAKyUUSxoFt7bQToQUU6YGNomEHUcUMBfd3//zwI/cbH05SnXDGVx1e/qs/d01wZOp9S1QvGOqRCdE7G9gu6+QRSAby49BZgJQOEiSkoXM+IroaJzg2AWtFUX3iwzi2np72JCh+VQr421mX5t0wvkFIXExEgtFmmdiSlGTXJN4sT/A4365sVaY/UaBz+xyKUm6yaytn0jwnRuyYu9IjpGOQhxQm4vu8z73eqBTZdaWvt6uC1zvTHLf2Qad50cQWD98P6LCDZEnCJkT0apLkhKa0hkoH6NBrshkmPqd/s/biQrRgX0xoSEsttNWus/e2XCgkERq5+zO2+ncsp5Rg5+L0I+Sf/IGbaS2g+J7pVKPwHieH7NHq4W97ClKOCVz743jWGtiODiEtHoFQq0MM9XORbyrRh4m5IPbx0tG+prapO6APbPmrgs+aii7R6nEc4H09tzKhNOKoSLyobc29BMWMTq8Xb/YcerOQEG6ZyEaDsDJqWVtaq+tHeCq8F4mplc7Y6PDdYesyAHRXYSh/rVR0pAwRRhIjQMgpkG0h5Z3ssFzaSFfVW8pFis8O1aO+sdHzxfd5LCOeyLU3vL31xhHTmJU/nvSC5zfxEglilviQGH4MNITHmYBwkcbKOspyo+Cmldt90YK4832Fv4o4IMRUb/TL31u2jSkdtfF4G/mWiR63iGlqTDTnzz4t3gvjdvLYSy7lu3ICTyLmyl51HkOCybXrKNCInD7ywalMoeJ
 U3Mv8QmY
 buflNWPuO/xR4Is2odWKua1AdqcF+VlWUFSjsomALuVQq4fMdsU0WixDUUWyLaS1YMdBF5KtyppPnlMDptU0RQkIDgG84xeBHMs9/j4gyMjxM6NhLh3DppddnB8/TPViWm5TcS8pc1i/5tjlcO3zUqwkcMdND/BBQNScYYRYSWKpEVFAa+od7jhvEDLxSo10hjgkAyJM7sYAbbCw3FCmOF1v8q4Za4vOKV6o7+k2UBi6hikFVjiD1+oSJCXad2XeyRnyfugDxrjid15XA6IPCZ9BBylZm/mApvDmrdZ2KUDDNlFCWgbaO2l6X43RELjT9TTLUoOllPYMPlTizPpDenr6qKITX8P73al7x96hMWwud8Mo7vumQxiWbJbT7Bmcpw55FjkDpEgtmeKjKlySBvgSU6K/HK4xCa/KNXlAkm8bzxm2DqJ+sbN7sRHkfbQkoNyHxreLB68TWJiXZcE9bpC1g8YfZnJGNss/aBnicwZeHmHlQ6/fGTzQUhRFrV7LBJNgvur+S64tpVNsqIDyCQ4qJvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------o7p8tJJhETiZ7lV3nDNGI84L
Content-Type: multipart/mixed; boundary="------------8e0X05FoqZgOTYBzGdnEpcJ3";
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
Message-ID: <d0d7e853-12e2-4db1-8e20-ee66c3006dd0@kernel.org>
Subject: Re: [PATCH RFC 02/15] mm/slab: stop inlining __slab_alloc_node()
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
 <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>

--------------8e0X05FoqZgOTYBzGdnEpcJ3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/9/26 6:17 PM, Vlastimil Babka (SUSE) wrote:
> With sheaves, this is no longer part of the allocation fastpath.  For
> the same reason, also mark the call to it from slab_alloc_node() as
> unlikely().
>=20
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------8e0X05FoqZgOTYBzGdnEpcJ3--

--------------o7p8tJJhETiZ7lV3nDNGI84L
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCailTWgAKCRCGXBN6rc5S
1pPLAQCl0frg9IhgBHxe7oh9laNSSKIorQjoahz5YjcSR7zvLQD8Dn39qHQ/vH8o
K3q/ObZo2YOj/eCIlLKJ0EcvC1VDfAo=
=+15X
-----END PGP SIGNATURE-----

--------------o7p8tJJhETiZ7lV3nDNGI84L--

