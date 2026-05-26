Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74BDCD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2CF36B0093; Tue, 26 May 2026 02:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04CD6B0095; Tue, 26 May 2026 02:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E418D6B0096; Tue, 26 May 2026 02:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0A5B6B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:57:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79E2CC13F3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:57:19 +0000 (UTC)
X-FDA: 84808664598.23.7362AB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B4F9520003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:57:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFCsW9PO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779778637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GVxWCW3ZyuJ9BtOExNznTPVXBl4NhY/O7U8r/zcRlbE=;
	b=Yn3EF9waHs5YQNfcsxUDtojUkTvIjwRNOLGgWHBe+v9hmp3Y/NIQIO7Cx4MO0TLJBsIqEI
	DgmIemRx7Kl4zdfODuycn5/kz4BdqyfucAmrugjYWj8/qiqfu5vtBiVZrk3ulgOaDr4pAA
	RRus3cA4IkTwzHaAhGPlYHjafZOOgX0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFCsW9PO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779778637; a=rsa-sha256;
	cv=none;
	b=KIcTOrlzmiYZ3JUOXiTNGeHCkA5hC7tI+rYEXSH5IKVGuYNTg1/8kepoFX5FqlSTGwFVjH
	m2giODhozvN1isM9Thp/0qcrDYz8pQ5+NHGg9tnhdn6RBC2m+h47KMk9hUXxRjJ+LCQdAg
	rpKbF+JAoQGNR5rwA5f/dwjiDC9Oa+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9028444F7;
	Tue, 26 May 2026 06:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D07D1F00A3A;
	Tue, 26 May 2026 06:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779778636;
	bh=GVxWCW3ZyuJ9BtOExNznTPVXBl4NhY/O7U8r/zcRlbE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hFCsW9POp5V4A3fWdsH3LoNSnTTF7l5CzoiG2HVftX0F0geKO7WHWjEwhO/94Aoqk
	 1wPh/dgu1hrJ7HwQWbNaRJDVRLwM4+AC0PFosOxIW9+UmDur1CtBnyt6UvpKD9xE4V
	 6dC9VWOtqjEyCvh4MYfaIjGLRv9j2Wqair6wJtUvKlauUbF2tLfHRSz1jdzYDAUsB0
	 0HU3+cpixr24KkfdT/Lun1qYNniR/7Uyvpm0Wk3xbFCM0rDmKh98GLACjFntZfcTGf
	 iqJLuKMYs9UjQyDAgZC16WL0yD0/0f8PUbt8oGU+lDpxHzOYJH7iC6zodJQ81GddFt
	 dkzOINQRC2oow==
Message-ID: <15f22716-0065-4814-8be3-7730ff34cf34@kernel.org>
Date: Tue, 26 May 2026 15:56:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: allocate sheaves on local memory nodes
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260525082312.16012-1-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260525082312.16012-1-hao.li@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------V63LpeRIdGeFq4bDViFa6TNb"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4F9520003
X-Stat-Signature: t4eybqc47zh37hioofrch9yzn6wyceid
X-Rspam-User: 
X-HE-Tag: 1779778637-92246
X-HE-Meta: U2FsdGVkX19p0Not/elhvnPqTjzwG+yIAQecvz6BOO1wuGuibZPOBgAdsLQ5y0vsoVz0upLI7XzvOgOBaWf8732Fnm6YftAYa9TW0Sj4EY1i5YRDgzZ3tuJypT8VTel/3H6z3pNfVtn+Xt7g7k9jvD6G+hvIDDlOyCusMhLoECJqFJfTUvFuEd0aH8dSVGA0Rvh5XTxefRNoDE0jZws4KZMAVrPF3V1Y9QdJikp515XK5fiXdh9pxwwjVKga5/mcdsW+umSOd7KHCfnpknC/FHcFQfT432LM8Jn6XgrPfoRvBGotwzq+QMlqkmzpGk8RutBBr6znWJjx3XpwsQAEW6uD0ZXFVA4OXJ2RPrIaoB12+XQvHaWZP+fSWUxbpz6W9Hge3YY2zAW+h+ItMzbj/J5hhHhYAq95lcy108W3A4GSrboBYQ//Q+N1pJ5EKy9/1Jd+/CoNvJo/BHf8SL/v6dwP1RAkpGV4FmZHuXKvnBCYMYBaW+dy4tDYtV7CT+D+UuxU9iQawjvykyLNbyRALLOh6g3O1J2w6dwGyopE+Sp6dRN2N9D4qgBPgMJ6Xz5/OvF1Vgmi5KuqXHPL9n4sfs+egzFLO6mMlxFYsJezWuvYiBKa4OUPZRp3oFVV1jKbTLt9EjXq5EgPc3OLSzDdT+T0HFUPoKJd/D73GxBAt6PoJS7cXoUWs1EfaEqEVynyHM5kNU5f2Zww3VURHYsA4EyT6SEKMLQdhJzuJWfdjC/NCpJwz15qGYoPaittrKhNo/SZpus5hgv4rY49Wxenx95qkZ+Xfxo/6TWr+EXGe87N5vWZjhwi7uHzD0LDm0Q9qm5tv+l+p/OqMODjW8YsB4uusEdmsHHHqS/WA31V/Z7AAT+v3OUFbzKKjy3ASeN+JXHyV8MqQ/VA5CwlEmqrwa+E2JfX2Z7thX5qDjcuEzc/kovCXHFQT4QkLji6STT8EZ1fkRaDekV7LOecSat
 j3+IQDUQ
 2a/icFBlATXagOYjTGDqKhgzh8+kSsvrUjuakFyDkxg08RFEdjimpfpDQ76ZHwyp8w7L6aa/gfDn+LPT/18AgL7sZUmxefYOtLVT+aQMv+ncax71HcoqsjHoE2+3G/Y+//MkBLeJ9eicjwqoFQEFfPVTvfpNfUELfekau9Sfq2Z0KQSQ5V5f+IWXNBFiFm1b9ATHNq1Em6bV/azt0DFutb8SqH2w7ZFqZ/O/aKh8ZRo3nZoUnW/x5AibsnLU63sIlBdhEy9q4MR42xW89lQvKR4zX+DHliPmkooP2YeWE8ePlKD0T7+Qr6WYYbN5MDL+LvJfW8bpabZKsCV0Y2zjYTMiM/Cr/RIq32FLZ8S/GgrMK1sMAkMVZ87dY4PKPU25MSKjub2Di5qk6daA03e7VWK2UKqLtfVsESu7ykNGSN2njmOHrCwLAGcFIx2Q1M60e9UZOmMjecAVvXdCOLj3wOPmmd25koMcg0p8vGgN5qGKkHUX8bN/Vb0r38b0Fodf2VwueNRF/NVB1Uvkp7p0vcV4Z5rbk6NALNGKJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------V63LpeRIdGeFq4bDViFa6TNb
Content-Type: multipart/mixed; boundary="------------zxZjIKs0lbybyp7dMSBGe2uU";
 protected-headers="v1"; hp="clear"
Message-ID: <15f22716-0065-4814-8be3-7730ff34cf34@kernel.org>
Date: Tue, 26 May 2026 15:56:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: allocate sheaves on local memory nodes
To: Hao Li <hao.li@linux.dev>, vbabka@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260525082312.16012-1-hao.li@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260525082312.16012-1-hao.li@linux.dev>

--------------zxZjIKs0lbybyp7dMSBGe2uU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQoNCk9uIDUvMjUvMjYgNToxMyBQTSwgSGFvIExpIHdyb3RlOg0KPiBTaGVhdmVzIGFyZSBw
ZXItQ1BVIGFsbG9jYXRvciBtZXRhZGF0YSBhbmQgdGhlaXIgb2JqZWN0IGFycmF5cyBhcmUg
YWNjZXNzZWQNCj4gZnJvbSB0aGUgbG9jYWwgZmFzdCBwYXRocy4gQWxsb2NhdGUgdGhlbSB3
aXRoIGEgTlVNQSBub2RlIGhpbnQgaW5zdGVhZCBvZg0KPiB1c2luZyBwbGFpbiBremFsbG9j
KCkuIFdoaWxlIG5vIG1lYXN1cmFibGUgcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgd2FzDQo+
IG9ic2VydmVkLCB0aGlzIGFwcHJvYWNoIGlzIHRoZW9yZXRpY2FsbHkgY29ycmVjdC4NCj4N
Cj4gRHVyaW5nIGJvb3RzdHJhcCB3ZSBhbGxvY2F0ZSBzaGVhdmVzIGZvciBhbGwgcG9zc2li
bGUgQ1BVcyBiZWZvcmUgZXZlcnkNCj4gcG9zc2libGUgQ1BVIGhhcyBhbiBpbml0aWFsaXpl
ZCBjcHVfdG9fbWVtKCkgdmFsdWUsIHNvIGNvbXB1dGUgdGhlDQo+IG1lbW9yeSBub2RlIGZy
b20gbG9jYWxfbWVtb3J5X25vZGUoY3B1X3RvX25vZGUoY3B1KSkganVzdCBsaWtlDQo+IHdo
YXQgX19idWlsZF9hbGxfem9uZWxpc3RzIGRvZXMuDQoNCg0KV2hhdCBhYm91dCBzaGVhdmVz
IGZvciBub24ta21hbGxvYy1ub3JtYWwgY2FjaGVzIHRoYXQgYXJlIGFsbG9jYXRlZCAmIA0K
aW5pdGlhbGl6ZWQgYnkgaW5pdF9wZXJjcHVfc2hlYXZlcygpPw0KDQpXb3VsZCBhZGRyZXNz
aW5nIGFib3ZlIGNoYW5nZSAibm8gbWVhc3VyYWJsZSBwZXJmb3JtYW5jZSBpbXBhY3Qgd2Fz
IA0Kb2JzZXJ2ZWQiPw0KDQotLSANCkNoZWVycywNCkhhcnJ5IC8gSHllb25nZ29uDQoNCg==


--------------zxZjIKs0lbybyp7dMSBGe2uU--

--------------V63LpeRIdGeFq4bDViFa6TNb
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEARYKADkWIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCahVEOhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwwLDMACgkQhlwTeq3OUtbP7QD7BBJdgcQQMKLW63NzSX6a
n47OZTMWXA3kjAW+FWtgcpEA/iPX3qcPMulpJr9JIYNBAXRfxje1CQ/abg7JZYd/
3r8J
=reHN
-----END PGP SIGNATURE-----

--------------V63LpeRIdGeFq4bDViFa6TNb--

