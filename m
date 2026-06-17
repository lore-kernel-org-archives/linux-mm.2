Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 811AFCD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4913D6B0005; Wed, 17 Jun 2026 01:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468FA6B008A; Wed, 17 Jun 2026 01:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6396B008C; Wed, 17 Jun 2026 01:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0C26B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:16:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A2EBA02F2
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:16:33 +0000 (UTC)
X-FDA: 84888244266.24.6E45BD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D9EFC180004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:16:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJPz6v23;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781673391;
	b=LEwiiHuoMWK+plRSbYRjMlca9zvtrmXxT4Vw7GRsSi4+1a6DwEEsioC81tHiTUnWE/nyVv
	QSOdVMXOTvasPGGmvX8cphDJ9tCrjncrKDRD3jEB6vCejUkOXNeq12FReSDFndmFRYSxl3
	YCnmSKT3gYLLdkUbV6jd3vfAyF6jMWU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJPz6v23;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781673391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=optTuxDRVX4Xxh/GiuxV8bViN9w6npI10kFhBkpLDZI=;
	b=cZlNuVSKsCVFb/8M2qQW2m5KzggY9BCQaNILkafqcyPcMGfy5eZaaLrWzY7s4PeamjlMT/
	FKm/jmPotHYpkovv+eTZat55OhcWViFL+zqlevzVGrhd0WCrTxOIqhJpxEguabZLSXQrSq
	J3BHKZgeD+Nb9fpMVnjjx0lNm06ZB50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C4C7600AA;
	Wed, 17 Jun 2026 05:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A032C1F000E9;
	Wed, 17 Jun 2026 05:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781673391;
	bh=optTuxDRVX4Xxh/GiuxV8bViN9w6npI10kFhBkpLDZI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jJPz6v231XAaES5dnkAcxqwBCRaMnEAbtpwWk0x28tofsgfttjRWn4csRhQBz9X+W
	 bczer+7z2xxBhKCCIZf5jUeOsruXrhrFCdlf0skBgdY3VAP03C23nRxRe6RJiLKQju
	 2/6Bo/bDbAypqU+0DWZXpVIy86ZWcYtfmPVH9EhlZq6CihD7tLJSvBdAtDREbcyNKT
	 t+xqUOcjvZjP2aKqlEnaXR1BtWsyYd+gmNKQpnGMQaMYNGIG4bx/gmDaL8B6McuOtK
	 NAxnXbsDdquftgOfUEIN+PkGXdAVo3ACGoD7LNDRvgMPJYWL4/rFRraQmhM45b5hNS
	 NXVMHmr1v1LgA==
Message-ID: <7ab220a8-2bec-4b00-8bf5-e76dff93fe13@kernel.org>
Date: Wed, 17 Jun 2026 14:16:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: recognize @GFP parameter as optional in kernel-doc
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 stable@vger.kernel.org, "kees@kernel.org" <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20260616193929.2394119-1-rdunlap@infradead.org>
 <48840fb6-8c33-4e4a-9951-aa603576357e@kernel.org>
 <79c90e12-c157-4d91-a7a4-54225d876d56@infradead.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <79c90e12-c157-4d91-a7a4-54225d876d56@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------bKJ2JvUyLmi0aUgh8ALxlOvy"
X-Rspamd-Queue-Id: D9EFC180004
X-Stat-Signature: eq4m8fqxmzuyn6oq55u5kcw77yykcnqm
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781673391-64512
X-HE-Meta: U2FsdGVkX1/aHZVMlV6n4D18tQwOHMdeHxlzfUu9BfW2/y8cafjHJYfjyE7udhB+0i/PBpGvNXpHMzlprlssZeALkdUMuuveSRAMMEOiA/h+F7wiH48kkp0QpTpJnaHDPT4aTEaKuBS7SMcQhPMa7hKvVm9L3DPEhlRRQ54CAZgGJV5lFIszqw36lo2rvRh4dzfT/a1vg/mrCw8GczIfjQo6S5V0FJAR681bE/DRH0He0neXp/1utuP7f1giv+p8Nx8uTU9j/XveyoWlqvK1StrTfAUbKsAjIs/zyiY28cDAua1PEtErCvcRLsVFww+4BmT2UueU8oKt4myO1gXxqzA+ETCFi5oeyTE3kSB9RfTrHk+H1UcYV2+pzfVilswOU+edC0it0KmI58lV+FCsVdGveIR0Yt69PTQL7+MpyGAvaigQ5Jq6iNrV/Z3sJq3ZKA3U9dEj0IWkaGYuVOFnax/9poWz+DpRiLNmyds1lRf1VTD5QpKs9RjfJZASiM/ZQONPKXRo2xo21ubQP3fnlQmWiCajxrWfwrIAVDagKgyig2skrt74erdM1VpRfhf5XH0SWm7xVqBElP3Qnl1LVKaixWslX+cvcLnPf1xILf9ESO1DOglXBK0W/1LXJ0VCl8b8GxXq44b8n7t9Johm1QUGRt/BcQcKAxT3HSdjRvQxIVfIVFrGpkDB1Q4ezXpaTaRE1zIK3QQpBfCVpAQTfkVPRRZcdpXSKsaKnu+bcWlj7DSZj2T4z+Gw5BmCenUxp3095+CXRmfOTXeBp6tDh1m4z0cyUXvAE1OCZmIKZfqpy36H7khRVZLFcUY/7XcUzY3C6kaGLOFFLo5Z9C41G+od7WiBpiE/1w3dUIUHmhW/o9cDfvVhMHRey/AD9TPZJtp/J3hN/GDfXL91TxvA+gDFIaTnjSqXp3qyrsGQPbtw2ukTDRaFokJSkrKhKSzwS+QJqPusxuV35BUbDyE
 tgKvMSct
 PeJdTbNR/qs7GOuPbohWSyMvi81gGTWfa+Mkmldwy7RXAuzCf62rV+/JsPNaqTkRSelSgLIUY2AaeGiGxOwakvDQTpWLrLb1PWvvr5Wk+0N/Ej/shKboTHKsAT9NW6yjdW2Pu5P6V1wVE/drUoz6tTclRf8MmLnOcVP7hEWg0JZppSlanH8AXnuIp5E3Bxt0O7gGlk0lTCFc0tA/74RPelNBKIQRwHzrT0k0h8cdeVhtVHdip5bUKKpZsW/73+bR8s15NEc4eZahN2xLilZtYAI6e3RqMhmLTqE8adGQTz1pAy0S632qSyp8deAUWwEWeZYe0oMf9fUYVYaMTyB/oPzo9GiDfQ2SNjANbjpcZqPiNxv4Uwx3AasiCkRhkd1fgaEIy7j/WJD/idMp8LzkZxjap1C5KixTT4ZEpZjIqfViM8KWHekwRCn6+Bnc87JOF9h4v0KqSJu8LQLD15irD4wQD2x/48QTZOqYFqA9YumeectRprrwfUmQgu+e0v8t3rZcZXS8JvI7HvYEVXn0BqMqK3Qt7cUHKOk6bUgDFHBtlE3tsUGozke+C8wQ3Klpa0ve3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------bKJ2JvUyLmi0aUgh8ALxlOvy
Content-Type: multipart/mixed; boundary="------------bC0iEyxP5mx28kx8B10PvWrQ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 stable@vger.kernel.org, "kees@kernel.org" <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
Message-ID: <7ab220a8-2bec-4b00-8bf5-e76dff93fe13@kernel.org>
Subject: Re: [PATCH] slab: recognize @GFP parameter as optional in kernel-doc
References: <20260616193929.2394119-1-rdunlap@infradead.org>
 <48840fb6-8c33-4e4a-9951-aa603576357e@kernel.org>
 <79c90e12-c157-4d91-a7a4-54225d876d56@infradead.org>
In-Reply-To: <79c90e12-c157-4d91-a7a4-54225d876d56@infradead.org>

--------------bC0iEyxP5mx28kx8B10PvWrQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/17/26 1:38 PM, Randy Dunlap wrote:
> On 6/16/26 8:25 PM, Harry Yoo wrote:
>> [+Cc Kees and Jonathan]
>>
>> On 6/17/26 4:39 AM, Randy Dunlap wrote:
>>> Since the @GFP parameter in kmalloc_obj() etc. is now optional, chang=
e
>>> the kernel-doc to indicate that it is optional. This avoids kernel-do=
c
>>> warnings:
>>>
>>> WARNING: include/linux/slab.h:1101 Excess function parameter 'GFP' de=
scription in 'kmalloc_obj'
>>> WARNING: include/linux/slab.h:1113 Excess function parameter 'GFP' de=
scription in 'kmalloc_objs'
>>> WARNING: include/linux/slab.h:1128 Excess function parameter 'GFP' de=
scription in 'kmalloc_flex'
>>>
>>> Fixes: e19e1b480ac7 ("add default_gfp() helper macro and use it in th=
e new *alloc_obj() helpers")
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> ---
>>
>> I think there is no better way to specify an optional parameter, so:
>> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>>
>> By the way, the doc should probably say that it is GFP_KERNEL when it =
is
>> not specified?
>=20
> How about (in general):
>=20
>  * @...: optional GFP flags for the allocation (GFP_KERNEL when not spe=
cified)
>=20
> ?

Looks good to me!

--=20
Cheers,
Harry / Hyeonggon

--------------bC0iEyxP5mx28kx8B10PvWrQ--

--------------bKJ2JvUyLmi0aUgh8ALxlOvy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajItrAAKCRCGXBN6rc5S
1o+vAP95308qeS2ZXYZ01jII/8FeugApGaKtmElPaVAE0mdMGwD/UrVY7d+FhpVZ
oIbAqvpYj+xMZ97HA2ZObgrk2Eg1JA4=
=JwhS
-----END PGP SIGNATURE-----

--------------bKJ2JvUyLmi0aUgh8ALxlOvy--

