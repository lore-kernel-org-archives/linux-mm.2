Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E85AC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D736B0095; Tue, 21 Jul 2026 01:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3EC76B0096; Tue, 21 Jul 2026 01:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54EA6B0098; Tue, 21 Jul 2026 01:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD2A26B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:56:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A216A03FE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:56:05 +0000 (UTC)
X-FDA: 85011723090.01.5043CA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6E1C240009
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:56:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I16JXFNt;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784613363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ry9nwKcjc3En+95aLTmNvR9XfBv8Y48g5ZHbR8RfbM8=;
	b=wKcCYQoP7xcIZH+j813TlETN/LNfmUuL2FA4hFH4Ga6UgSvEkbFr6SmNiGrouPV1L9DAoF
	NWzIGGrwCfVgcXjDptIMS8dU/uvoJPm6o3V54ZhLUSZb3Ij9j82GffD2KxWDNuPRmDj6f5
	vxii8GalOlkfpr4ykHagMWtF8fnIDwI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784613363;
	b=PFy5l1sYK9MguRBpWNJRWjuOkCHHVR35MjnQEEsBzhqjSgPNFltnja9eyaiv0VdkbURmHR
	yh5nIm7qSNpL5E/FgdTyLP2T97ObIkGdSIR5Ro6cfhkDnlqWid9DrJ4oPLZLxoSomSUKvK
	44w1elM6GToHE4XFLv9kYjdQgh7NRAw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I16JXFNt;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9093740729;
	Tue, 21 Jul 2026 05:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD061F000E9;
	Tue, 21 Jul 2026 05:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784613362;
	bh=ry9nwKcjc3En+95aLTmNvR9XfBv8Y48g5ZHbR8RfbM8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I16JXFNtmsTyrr4HzilKeW3iZg11ZNKOg3eqllU7CcyIMceJfGOPOPCk7H9utG0cR
	 Sz9b6CB1IG504z5qQnsJ2IBQgMRQYxoNVl759xA8IE9RSDkzCb8YFU0bJ3xRaZ1m3F
	 x3Fv5aaotN7BFn/KP/89wM4H6s38hK7wASbmhGztas2Bfwcl0yAIIbIpIvoiLkcx2B
	 HreNYgWmb1OgjAmplrA02qCzKE4oWhAFBZq2aF+55eZov7o7wg/RLlGMtULhxVKV9i
	 cIGUM+cpN6aWyVQwXpXWjriA4U2lHE6Bn4+IfrYajlSKltXG9e3WANUMjBsu08ApGa
	 kMAhh32IvJoog==
Message-ID: <10634acc-f45b-475e-a2df-2d7efc880b68@kernel.org>
Date: Tue, 21 Jul 2026 14:55:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/13] mm: move struct slabobj_ext to mm/slab.h
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------erUdOoVxhVjluo2iVkSPasJs"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E1C240009
X-Stat-Signature: wkou6j9cmbfep4amcfhnyoicn74194s1
X-Rspam-User: 
X-HE-Tag: 1784613363-850632
X-HE-Meta: U2FsdGVkX1+x3pf6ISNzwFp5/RQPjvyxXVYu0zRdiv4NwvmSBum8ltp2Eljttd3RXBMLgwZgGX1monZseNlOJoETv8Ggaw0Kf3EsInnUsUmqAXBtrb3RjbGyR4IpQvPPfFDz/t2p/HApfsTh3UMHSpqjvaBeTJlzkX6beISfBsF0++HEOKeTgukRNNidsu8iSuPtJPxjWBedm9caLEyfSqes1XMOg2b4g1KEOhLy0aKmKP7pjAnxdO4FEiUKl8RN23b90xk1GM7G0A8UgoMd/h6daweWLaJ9XTrxAfP2eiZzx3uN1w3G2A4pNzWm25T8OsDzG1zJyektd0SC0Sj8nWreKI0rmvLZ7xTL8AqCWtysAoe4jfRPg8hz2NAnTubH0TL0JwctopFYyF30+Wy7QZy0LWq40B/afhURPin1HYHeUkyNfnOiFPEfoKEOJfePnIBgl3IWmyh4u2xnSYsF0uXdt0w3scWBR2WS89G4aRWfZHVMif6guBWNWb6r0SFTvXbQekOPYS7yKcN2UvsYSAa9MUiJUMMt0d2c8qEbwI47BHnZZuNSaEqv7hRn4g2scF0OV4+opEwOW0b5Q8UivsEYEKecW/Z8eHD9AJ3xp0ZlvFZkpsReD2YO153guj2QjoKYw4BDjtgzS7gvrTu9Ph2MkPfN8In3A6T2njFUY35TTWgEsQt8S8SCFrU27dSM5J9lCzLjInO3+cWjDLL6eis9bB8F4d7xMyRw8QJsEuF1xUPZvDU1hLWexkg3RG+X89W9SBslRwn8A5eZCsP7IGhxeoKcGXnX4IVCGQDRt4msjgloYW1ICaHM4MGk2z1AqFmV4jF+GgfG54TZuP6u3YQzFvx1hDwmML5ew+Zds1uGDoDp56iGqj0yaVDwr6kX30X14qQEnuiMttJlo9dDLNMYhwtJLaIQlOlqk9Ycdh9f4Y+YWRj6jFQ1tIPQ6hxvS7hroHkDthHfR0NzgKI
 gA2lw+fD
 tgesxckS43OuMpNA9/z3vzq+/G6n948FGbO3KZRpqPJmEGg+VYUXFC9aq+LFvELtvKqFKvjZjkXJDk/IrjqOnK7TJYb00AsEZytkNMnygAUP5yf3vJ8fm8Jiet5iVtx/u3Ku0Jm4/SQiBTrCj0Uz3GFeAsEqpc2IxNFusmHD/hQ2fmNr96yzvSzAbVDbIvsY7OkVw9OS+yahxw1EC2nEg3vw22isbgLXpyV/4AKOHgrpTpqEFBoxaHAyTvcApXcFkBrVK623DmAVkCBfcvadIL03oHLm06PWTtpq7iBY8IlATUMBXSc1fb8INvLUU9aUOcj+UQDbihu4dQvkzMftqetkqaLSGKtjQaogdQAjRZsks/uWiLZdTHuAzQULm8XCJJOY5TjLdqW/irRd9z1l3Q2tkSH12La0mxw1s+wczyp8rcNiHq8ep09z2ukR4O6dUYh2AqSnEkVNDNptUpPGwMBKymFYQtMxrB4ynBfs954HdSFoiILVYs8RRNAkGiZrsCd3spe5XsEYZ4QXK4MUmifsYybF2SmjunuvC8xbcwgoWOHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------erUdOoVxhVjluo2iVkSPasJs
Content-Type: multipart/mixed; boundary="------------GcZskzVFCTVPbbHA49fLBI3E";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <10634acc-f45b-475e-a2df-2d7efc880b68@kernel.org>
Subject: Re: [PATCH v2 04/13] mm: move struct slabobj_ext to mm/slab.h
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>

--------------GcZskzVFCTVPbbHA49fLBI3E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
> Users of include/linux/memcontrol.h don't need to see this internal
> structure. Further changes to the struct will reduce recompiling.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------GcZskzVFCTVPbbHA49fLBI3E--

--------------erUdOoVxhVjluo2iVkSPasJs
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal8J7AAKCRCGXBN6rc5S
1lgLAP4su2fsXdwSFi7bi0OfSRrrqacuZyGdHgCgzBgFKtrMlwD/Tuz/xDlfjgkk
JIJBgYri4MiQpJ48eeEMBBVzDmcBlAE=
=mB45
-----END PGP SIGNATURE-----

--------------erUdOoVxhVjluo2iVkSPasJs--

