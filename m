Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4493ACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80EAB6B027A; Mon,  1 Jun 2026 02:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BEB56B027B; Mon,  1 Jun 2026 02:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4C26B027C; Mon,  1 Jun 2026 02:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2186B027A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:17:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 060E1C1F38
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:17:48 +0000 (UTC)
X-FDA: 84830337816.02.6D52A0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5621220002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:17:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZqucSbV8;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780294666; a=rsa-sha256;
	cv=none;
	b=RTkoh5mTR7SKgp+61P/9uB4n/K0sMWEPYbRcfKW+MrowHAKAwqJIyZ9nz4yaD2V5jZ5QIH
	MDfjyXEcIqoEnGFtQzyf9R9ioiV7BJWh2N3d2EkHO/i2vJ4QHJ4EEoJFxffqo9hwOKojtE
	BjLrlqwWXiWVxDAGZw9XvtGFKn6o5Pg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZqucSbV8;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780294666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOaCBJszeEJinofNr2lzj3UzRWu6io6VMPCUTe2YiMs=;
	b=nhWIAf1G1mIwsmww9m3qrJkZWBIpqDEYwzCoEUOtPs9g1wWbfiBBH1/5l8MXx0t7vkO4hg
	rH0NhqtgMt7tMhl2/3yroywpPHV3clBdAuEvbZuw4QnAcRPVXrGKaCV9ZA9k5PKEuY2vyK
	DSfg1BiQOd78BlnJ7SzbHDkUhKunyo0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 730C543046;
	Mon,  1 Jun 2026 06:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32B71F00893;
	Mon,  1 Jun 2026 06:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780294665;
	bh=DOaCBJszeEJinofNr2lzj3UzRWu6io6VMPCUTe2YiMs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZqucSbV8hFlVZ1MlIw7dKHjWn+WTilN3Xvl4/QRQAicoAXfqKiwJEaB0smexjQ5Na
	 3HCDHSfMgenQ2mhbn7F6O4N7ua35jZPeeISQtY2htw8RpVwzVtCnIqIHMoUVN4liUa
	 RkDR5eoW40yD1upA4fr3/UVYWAV7SkKbCYGiS9MYnI/QxVIUcRSfOIjWEHPZQFXdEA
	 XEjabGKAKWK+gRWlqxuMRwO/yVoWxD8qyHBhpn5MliqsJxuREAD8/Ntde/H9CKT4Pq
	 MrjUTxhmbCdTKMkr2447yZF22Yo9TF4Hy81fHgOnphG21+3oMIG0QyZ0tSPFwfZaty
	 +pyJJn3exK/HQ==
Message-ID: <0dd720f2-7732-4801-85d5-4593e90e8cde@kernel.org>
Date: Mon, 1 Jun 2026 15:17:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/slub: introduce helpers for node partial slab
 state
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260529035120.81304-1-hao.li@linux.dev>
 <20260529035120.81304-2-hao.li@linux.dev>
 <5ed81b4a-1d18-4535-a18c-1bb31969ae78@kernel.org> <ah0VlxGBk11LRg53@fedora>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ah0VlxGBk11LRg53@fedora>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------54aSwY6HzRt0JvxlxSoZOFQO"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5621220002
X-Stat-Signature: i85u593iabup633wfih9jb91h1kafr9k
X-HE-Tag: 1780294666-430093
X-HE-Meta: U2FsdGVkX19Vdn0pgf+VqJU1HVR4jM13xdyj0bztO5TLBT+5937n2f+f2miDtFcK9sLo+Dr9t7p7a6Of/+s7KDpVHS+u8PpUvnQeUcK3IdJu8Z9QUOA55TdcjuZLxrGCnkBMwUOqH+xZX5JRGUoCJc+GpGjq+P2HILswxoyx2PxqTTVu8ExbH3Vw1u4s4begq6wVGU8sZP+KdtAt0lH7YcdAVUAr0d9rS/Hdy96VZTgMpxi6UB/7ruCwQGVnguZql3FMY4HOoAzVgsNJC5v9aSFc3jKK6nQLJvm7TrvMZ+D175Z9Y1OgwScMUYDIPLk6z6+5hbQzzDtMKYalbGA2DOTH2YW5ftbn1vESiF+DQbTTV48f7LUWkvEEb8lHrLna+bcKtv2UqylEr/8pEOaodjYig23whMbor5/buE7cqO270paqG3E3XFUTK/Hgf7n1b3F+P8zz+paYnYMMxRXJkCoBCUJAspKi0opurtDbNtDQub5deaNg4nI9WNlNNYWJMTbbGbDaZ9QyfipAqWBmFvhAtw7xGSqTgypUOV7B60B0TUr+qxZWOBFnEe3cGk0+Uw/ItvubNXBEtwawRsLBXb06bh7AEqiFqBt43Z7XGGQO5tEXlg5QF/bf9b8e3FAp2VU94ZWcKG1WBjOm614SNfE+kCz89lowLxrw+/laRx8yX+rLNlNjtmGX/7jKbImxfyAt388ZrnMh1b0JB6LNq9xbi5ggSl+7Kw7o/6Xpr6SsdDhct5YV+xVhlZZ6JkxXi7xGo3u4yswQSMGdgqvKtx4ZCdOJND7rjjmFUkCAwGnBltWu6Vm3X80qNHhxZJLSf/PWNSX+1mQ0t8TRJC5rhRxLAfkSFBz55XYGv2xBSanEl7KANZqPWMbn2vADQUmxD22c1trOlcqrBbSCvvAYLZVklMXN1QWpV2NLO9/aIIu1jIAQDjn8gg1eNtT2aHFjtedpvnkJtnCuO2wQFlr
 Ckkrw1iD
 yx4Rz27RzVeAgzHSeZhqwru/TbLj/jkMf44JrRHysYJwTCYlNsYokgPWY1JeFVf8OTDCsb31SzLL/6IPiRH263b/2t5YH7mXHUsQscGHsvArCcUG9XVHrft2oOBePqgnW9+Zt8TM5bo9/MlLMR/dVQE2QE3nfYY/oE176mx9qljc8/GsLnwXNU8wpXkD9k3qMsBF1c9Jws2LOPxZmtkyZNU41/otFCt5EhJfoZxsJYJGQJB310QYEBcvaZEH5EbLuSGdu+yWn4Pjvctf9iad8aky8EQA8uRVL73ztN+3y+fgTO2Th22amabZAJL93gcBy5CostAqtIooNCikiOX3epm5QOjjmS0qbSjvpNuzb3IAcJIRUG1K2QUNWuDeAluwHOV2l+R9V2WYoDfq6qJ5hiZda9aBWexpV6iQCq20uMVQzDJmYvLm0VATU2O8xg/qjzJBKZLsKCuhFStY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------54aSwY6HzRt0JvxlxSoZOFQO
Content-Type: multipart/mixed; boundary="------------10OOyuURfKZOfOnV30ucBNtn";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <0dd720f2-7732-4801-85d5-4593e90e8cde@kernel.org>
Subject: Re: [PATCH v3 1/2] mm/slub: introduce helpers for node partial slab
 state
References: <20260529035120.81304-1-hao.li@linux.dev>
 <20260529035120.81304-2-hao.li@linux.dev>
 <5ed81b4a-1d18-4535-a18c-1bb31969ae78@kernel.org> <ah0VlxGBk11LRg53@fedora>
In-Reply-To: <ah0VlxGBk11LRg53@fedora>

--------------10OOyuURfKZOfOnV30ucBNtn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/1/26 2:26 PM, Hao Li wrote:
> On Mon, Jun 01, 2026 at 12:38:48PM +0900, Harry Yoo wrote:
>>
>>
>> On 5/29/26 12:50 PM, Hao Li wrote:
>>> Wrap partial slab count inc/dec and flag set/clear into
>>> helper functions to reduce code duplication.
>>>
>>> Note that __add_partial() is called locklessly in
>>> early_kmem_cache_node_alloc(), but since there is no such use case fo=
r
>>> removal, __remove_partial() does not exist.
>>
>> nit: __remove_partial() -> clear_partial_node_state()
>=20
> Ah, in this sentence, I just wanted to clarify that __remove_partial do=
esn't
> exist. it's not a typo :)
>=20
>> oh wait, it does exist. Let's drop this paragraph?
>=20
> This paragraph is just a quick side note to explain why __remove_partia=
l()
> doesn't exist. I noticed that __add_partial lacks a symmetric counterpa=
rt,
> which felt a bit abrupt/inconsistent, so I wanted to share some context=
 on why
> that is.

Ah, I see. I was confused because it didn't touch those functions :)
Thanks!

--=20
Cheers,
Harry / Hyeonggon


--------------10OOyuURfKZOfOnV30ucBNtn--

--------------54aSwY6HzRt0JvxlxSoZOFQO
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah0j/gAKCRCGXBN6rc5S
1uFvAP0XfcrNFQCIz3fQt6P5mIFUpar5IMWnPdjiBh+wg9GzwQD/dJws5J1S+Hg3
wDmGHJplNfTtjLoHpnYcWG4YYBPJzAs=
=X0Y1
-----END PGP SIGNATURE-----

--------------54aSwY6HzRt0JvxlxSoZOFQO--

