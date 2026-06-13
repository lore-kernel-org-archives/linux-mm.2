Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E1EBCD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 04:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE896B0005; Sat, 13 Jun 2026 00:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF1C6B008A; Sat, 13 Jun 2026 00:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4046B008C; Sat, 13 Jun 2026 00:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6156B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:55:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDC49A02DF
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 04:55:26 +0000 (UTC)
X-FDA: 84873675852.29.5D281E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30DF120004
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 04:55:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpGWOA5O;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781326525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abm5AXw1uLIy2ex2jA1De6T0yo+csEjm+fB1Q1Ub6dM=;
	b=GNytl7rLyAMKFiwSMoPCIU7MywBt6jCIOeUwmnwj5QlufVF306qrNvuY28V/PhC3f7lGNd
	ek6hJe89WcQ2tD+F7bXW9sJ1rBOoSmiBO1fHfS1A21kjIeLTBSzyOFRZ6IvND5f/8S5f9B
	bOArD/MpVVqZ8pJ9tCsXFT+6sGBFtnM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781326525;
	b=ApWBQOibFg/BDKa5XEL1jCi18/xfDYuM225t47di53xDdxI2hZ4x+ryw+sxS5poQ1xWBIx
	5YA4y/37F0QyOlyvvHz763P0GP1WBJEhp87knJfhXJGZs0EA2iSHkT4cjCyUr8s8OAhPME
	sA6MIROUesAMFuAqJsUeftMnrC7LSwc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpGWOA5O;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B20840D8A;
	Sat, 13 Jun 2026 04:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724EB1F000E9;
	Sat, 13 Jun 2026 04:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781326523;
	bh=abm5AXw1uLIy2ex2jA1De6T0yo+csEjm+fB1Q1Ub6dM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VpGWOA5OmxKHHi1Nfiw4PrXtyO5qxnDqrcaKAmQBdzjsxd/qepovq00ZGAo0e6ai0
	 rUx7DEJFj2Hh5+DJ/OxOn+v/9HYT3bmaAi6KD4SzKh9BAnUDNbBDDbmyaFB07PfjaO
	 FMcFo2o5xqlmKAQDjczRccdrEoDoN9nTB4TkbGEZwxhxiZwbO0eHTTKJId4vc9Rc5d
	 1r812sh5yBW5MRYlzmDixkS8dMNy9pI2gxZWxIYB11QHfbeHHbQOjYikzk2H63LnKU
	 76d5+0o0gUz4PsaoyJFNoSFJdJr+LA9D4XlEziibL6DpGyB7k65pEs9DJl9A0iU0BS
	 4lsc+M4c66a8Q==
Message-ID: <25a57a12-0405-4469-8fe8-42554b98e523@kernel.org>
Date: Sat, 13 Jun 2026 13:55:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse and
 switch to static key
To: lirongqing <lirongqing@baidu.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Usama Arif <usama.arif@linux.dev>
References: <20260604110318.2089-1-lirongqing@baidu.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260604110318.2089-1-lirongqing@baidu.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------kBl0Fyz5hJPGyvSUKszm2dfA"
X-Rspamd-Queue-Id: 30DF120004
X-Rspam-User: 
X-Stat-Signature: h1pbacow7ote74qa7sq1uutffoowpefi
X-Rspamd-Server: rspam08
X-HE-Tag: 1781326525-606485
X-HE-Meta: U2FsdGVkX1/3mXee6CiW4kt/7Tai0Mtty2/E/7z4f+CUUFYJyu0Tv3gybVttPTx1cLEvpQLScSVBnGvRLdvwOkPT/Ocwyd1PqGpIHpw7CBNPVimtz2n4jc2xpOOIYFdI3ZXCta5n3+J1TCnk1jbRXVmZOISNuwjKCj2T5z0zqkqYVvltnXDRWy2xBYqtPuERHiO7RD74Sy3qOzf/V3SA0dAlSIn2IeRzTCI219rVKN957/fHBRzylyv8vpamdw7atnraVwGCBEXYugtb0GxXFPh1Mg1kC8HpbKtoJ9emM+54qCCAAlAQIdLgvRmP2U1/yAB6whUrk51dybeIU8DSXNXYHForSGgb7E1S0deDt0dm/cogkIikClesML3SwcPUJfRifjqg8EseMOh0upUNgMk2HSRYG+xXJEL36+HlsezIKV3SuGYQ1egv/Gtu1LkmOReCdfE82FU0JGdSuUoBxp4tnqkxjdf/zmLRGfWx7TCfUiidhQNY4GB3gDOXiKEtJfn7vPXzo7EOl0JwBOCKviLQsCEmJ733yJCedoCkX7/T7u54H5eRvbO0IfxAuhqk3H35xfdLQQVy3qNHKMwtKN2de0VFrG6jz5eNVBj6u/GWsoqR1b1Y9/9XrDHyAPQJeAfMbRGzmZVf/rBvCF08u2XmzQYg+wcJGs8KMfGQQf1UKykDn5f3NkeWkCAinQ+dX4la3p8XqUC4EngKlQ5LUxmSnjulkMENuV2T3JMm41os8vrZprHUf8kVmFe9fwrLA/9Cux9EjxCm5kBLzGBHE+4JwKx40OnbNl7pOM8mb+7e/CMYf5LSbuR08PoQdDJGwSI65cN7+D1GwZxhQ8qEQh8UWOPtbdpdRHWLUJs5aiab152TpSQqxI7tmNxpnsSZgNiVLdPRIib/9o+uWnUEwFspb2846NdqAkXs+sjhPg9fRX/frkDglhE5G3jAmCpaLbz4YKpAL7yOHIA/6Jc
 AF9tNQqt
 tZmuNKxp3MRtTC+FZvBRFdftBHickBZTvwn+lRyPwiZ+tG+NBc4hX0bc2EbIuyC5XExDIKDy0qdKd1RW3+c8NlQAUw8pZYZWQwrFwZ7NBv+11F1NVl1ST81A/0McA/OdVetnHqlgoKAUf8FV4cDjWf2IOu4jxGT8bsZCviYQBKojWXfnRzL3zDaLtrFzWF3si5MkTM8CgTYHnTLRV3zooXO9p3n8UBOjA/KngL8hevoPt6knJwBeFyPH/7DRlcjO6gLlO1HUngnfYbtyzehifV8TXSo2RBHbtOzNA/FXABE8Vv0+1p41KPZlB7Y5KKLwAPs5ZCOltuNyRhELj8LnioOQE95WuFHcOgF7l60PgeiTfhMeoI+JBvFsQl5RmQWPylaoMHrVGYQiMV8Siv3BBfEq9an0pu5W46UcUmXo+TzmSWPMwIGwGrh8MviuoZNTt699KuF4Nun+E2RjxjQdmAcDi1K/58uV450FDs3zgX3PJkACKtNjhm6TN8RFCTTFt8eINQM/nWjN2K7alJS0ABpFNy3wnSKLd+rO46r3cO2cxS/3u/YRJOhxZWlcMXC56SJ5mGlmHWPDSJaHZkEukp9+ZVUicaWgl1suN6hoYeDgHcLt5Db4+w3M4dTnjYjacIwi9mxwsDDN5rmZMdETzU54nLKhDqYPkSCKFSbutiDZbQu20nXskpDOM9/8dXBtEmBbCEkaK2wdlaUDtaaTz5YjXoN/MjekarjtKnFp4UnjAbu+A+1cjmEqS0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------kBl0Fyz5hJPGyvSUKszm2dfA
Content-Type: multipart/mixed; boundary="------------Y3YSJpLruN4AtA10Yc7JjJuh";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: lirongqing <lirongqing@baidu.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Usama Arif <usama.arif@linux.dev>
Message-ID: <25a57a12-0405-4469-8fe8-42554b98e523@kernel.org>
Subject: Re: [PATCH v3] mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse and
 switch to static key
References: <20260604110318.2089-1-lirongqing@baidu.com>
In-Reply-To: <20260604110318.2089-1-lirongqing@baidu.com>

--------------Y3YSJpLruN4AtA10Yc7JjJuh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/4/26 8:03 PM, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
>=20
> The mempool subsystem historically wrapped its debugging logic inside a=
n
> merely defines compile-time defaults for SLUB and caused two flaws:
>=20
> 1. On production kernels where CONFIG_SLUB_DEBUG=3Dy but
>    CONFIG_SLUB_DEBUG_ON=3Dn, mempool debugging was completely compiled =
out
>    at compile time.
> 2. On kernels with CONFIG_SLUB_DEBUG_ON=3Dy, mempool debugging stayed a=
ctive
>    even if a user explicitly disabled slub debugging at boot time.
>=20
> Clean up this mess by removing the #ifdef and switching to a runtime st=
atic
> key (mempool_debug_enabled), allowing mempool debugging to be toggled
> cleanly via its own boot parameter.
>=20
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hao Li <hao.li@linux.dev>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Usama Arif <usama.arif@linux.dev>
> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

--=20
Cheers,
Harry / Hyeonggon

--------------Y3YSJpLruN4AtA10Yc7JjJuh--

--------------kBl0Fyz5hJPGyvSUKszm2dfA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaizitAAKCRCGXBN6rc5S
1ocAAP9Od01upxVUp6/B5+mytUB+pFRAu4iQyQVIsZWljSeLYwEA/xvWpFb8PAZk
XY0hCl0hv/IQf7MZaAWjUV7fMEcNyAU=
=yMi6
-----END PGP SIGNATURE-----

--------------kBl0Fyz5hJPGyvSUKszm2dfA--

