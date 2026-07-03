Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C75C9C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 05:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716096B00C9; Fri,  3 Jul 2026 01:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E186B00CB; Fri,  3 Jul 2026 01:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CEE6B00CF; Fri,  3 Jul 2026 01:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 262EE6B00C9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:13:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F6FFC1FFA
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:13:07 +0000 (UTC)
X-FDA: 84946296414.17.978A446
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 095F94000C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:13:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqCnGi2z;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783055586;
	b=I6hjM7fGZipDf47m4dNARxjN2r7215dpQ4kk5jHOV8BspmmPkgxyEhASlU5p48yybK9dqA
	+K6MH/mf5zkONwrFRxlLHA9UegRcYhIrmLpxD3g6TQ6ewk9ww1wFjAPFyisnyO4UbSfP5b
	u48altKaXHgWl1oG3rxnouenAdVL0HA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783055586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2jmDN8EDDEi8qou1T3zevjnsQGMZ5IhSTwrPgKzFh4=;
	b=y2RgwjRbbZec5m69KIGFqnYLcOo6WCH+OhiHyL9RTAdpr8FGk0iBZrkjrXGqed5SQPXG9N
	oJlLMkHwyTA4mynBI5wCDOcM8fYVZo/HCf61xDuU7ChCFZ3Y9ad6VF6pjDz5sYFEFmFtJG
	MJe/gLBkW4ZM1tFpXk8fR9Zy85RVvZI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HqCnGi2z;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AA3F600B0;
	Fri,  3 Jul 2026 05:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30D91F000E9;
	Fri,  3 Jul 2026 05:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783055585;
	bh=d2jmDN8EDDEi8qou1T3zevjnsQGMZ5IhSTwrPgKzFh4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HqCnGi2zDjWTXnC3MspWlCf9hO0/ZN6ukeuSVhsLMfxoXT1NAObsxCFxHqAbwxAhq
	 GkXe2fpz7+2ch+jjP9jzz/+n1jNKaYIpPTm6uMzqZjLl4XTTcLbA88btfrcAGC64Xk
	 dgjq4bw8U/PPZV/f4PobkEObr81d8waV6vVQOo+o1Odp1XPKZWyM8XDEjD3TN5B5w0
	 hdEFS2+ICzF2WtkZHqm0ISVHal0f+AJpG/kf8goAtMPdHBmG03KOsdT5bzD1s/nd8u
	 MD6x+Z5V57PalXJOwjjAoXjdscFDQ625LKHgM2NrKMYqQDzdZ0pYKtHjY6nJ1g8fzz
	 4/VMxpFvVFrdw==
Message-ID: <77a03a9a-8461-40c3-a383-d9dc62efb801@kernel.org>
Date: Fri, 3 Jul 2026 14:12:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: ABI: sysfs-kernel-slab: mark cpu_partial attributes
 deprecated
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Seongjun Hong <hsj0512@snu.ac.kr>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christoph Lameter <cl@gentwo.org>
References: <20260701141755.85119-1-hsj0512@snu.ac.kr>
 <54e75619-3dbc-448c-81fa-122edcdad1f0@kernel.org>
 <f047ceae-4836-40c9-bb7c-a6074bbf1a1f@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <f047ceae-4836-40c9-bb7c-a6074bbf1a1f@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------NOh23wvTE30Hws23l0EoVgJZ"
X-Stat-Signature: uwboyo3tqx7h3dzs3ntwdrapa3186s74
X-Rspam-User: 
X-Rspamd-Queue-Id: 095F94000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1783055585-499661
X-HE-Meta: U2FsdGVkX1+Zv67wY1F7Dgti2S4Xyi0iPbvHt51ioLfDeAGlUCmA/+D4cW8w/RC/HX8FyVOj9w7dtTuPiUv8ksV2bmI9QC23/hXoap8mXBrWBds+5SAXMCU4wAWTKCYx0qAPX2dYEmaDhtwEAn4zA6+2lQqe8odztt1pxnOU4S5AhDGZLewD73EqbpakbBnTzU35/SwwcWyMfI62e+zbGLFamVwLEfd7Rqrvkck/3iPw1gHHSjKK22Cf4NYF9YRCTGmOB557GbshpPLFSwHvJIKW7oxEhvP4/FKtH7t5Fh4CXDiHHXrhy5gdZ4WAQ/NHzimnbgFJylujVGryqlw3k5YmjuZ7S22QNly9N8GMnwteeip4H2wiy+9s8g4gUIPJP+A6lOY7zPhvPSrOZowznhQkG6k47Y7m8iGs/w2lSeoXYUFThDo2sfwXR56golqeeGlg6JrgUYfI/X5c3RlnHfnYJjf3ugI6EppMje/rYV9P9ctjL33qiEFfjsTdhnSAwQPdBsco7RFNEsg+OKubCfDIFs1iIbzHtNHTWCtfo8E6mZhBG6BvwaIUSDmFltp+lKmqqb3ZOJa9qeTstiUssmm+XV1KtzU6o9iyIQytifmRI5wmXmUmPexU4piJsKdM2Va464ArqhDfAJxXdSfMbe5WBaOydZ+hP275Os+EoQxzz7selLhhgycv9wGCLd5ceTwfrLhcd5ParDUc4ZUCzvDSHgq/rcCXaMuPvaFfo6ecI+E9MW+U2gY5dQDabNNCfBwMiHbrz1Tfh6Fz7P+KtPATJIgVDCvcW8Al8lerRWVZKAmeomlFGvXODAeFZeOgsDViuLYIbvbf+/Gun6cBzO9Ko0YNuwIL/uLbMYx5Cdp/xP25M58TGAnDaX29yOTXL4f5ZgWfGWUAvlFJFFIgdKEzrbkcg/JjSSDzBo3qHPY1esbbrJDW+bBGUF+bF8uMyE3h0RpthSnF65UjjR+
 iNuAfVWh
 LIJVAH+vhivRmIVp78fiLOSlx2q6dTnf95itxM8r4FOfcmMOsbcybc0lls1SkRG+182W4PkEHQPnSUcM60nhaIqZxKDxEBXSjn1f5JZtm7IYBXHhqypCDDaLxLEJ6W121BtvbiekD/HF3znjQxEIYcd7FYx72WLtJCQox0qDNs/78O/7sLAVHSeTddjNvDyBbhlnVYytWDcA1xaoOe+GZ8+NfoGK05iEAT85sE5mx7hxLVacDal0DArUJrJviGKjqvnA8vCi/gE+VVkE+IIP2bihRFN8XBQhgtoEVJ6EwnlUhgn43KCGnTowpq0zitd5QPjn9tNC2qaH/TjDKZWxovcz0tpR+jmO7prddhuv6/XyR7ALZnPY2T8XJVF8N6annTeWFZHdhav9+2jHtkb6CCCx7/MA33yqdHSf6WTiUByHB6eCif6i8c483CzqlClSShA/7mVoIhvLBluPHV/2CxtdoW1CKi14r+WogbWfReZ2mrs+U8QnJ+xaGlGLg5m6I3RZuNggHzCtvvRNgTwr/bMC0Y8TFD7cawHJdnLSWoonGuSBwjkaiWXeSSH1A3FiQr5X3ktCzPNv6WKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------NOh23wvTE30Hws23l0EoVgJZ
Content-Type: multipart/mixed; boundary="------------YgT6oA9Qcxr9YGnpqYJ0rzq5";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Seongjun Hong <hsj0512@snu.ac.kr>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Christoph Lameter <cl@gentwo.org>
Message-ID: <77a03a9a-8461-40c3-a383-d9dc62efb801@kernel.org>
Subject: Re: [PATCH] docs: ABI: sysfs-kernel-slab: mark cpu_partial attributes
 deprecated
References: <20260701141755.85119-1-hsj0512@snu.ac.kr>
 <54e75619-3dbc-448c-81fa-122edcdad1f0@kernel.org>
 <f047ceae-4836-40c9-bb7c-a6074bbf1a1f@kernel.org>
In-Reply-To: <f047ceae-4836-40c9-bb7c-a6074bbf1a1f@kernel.org>

--------------YgT6oA9Qcxr9YGnpqYJ0rzq5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/2/26 5:28 PM, Vlastimil Babka (SUSE) wrote:
> On 7/2/26 07:18, Harry Yoo wrote:
>>
>>
>> On 7/1/26 11:17 PM, Seongjun Hong wrote:
>>> The per-cpu slab and per-cpu partial slab mechanisms were removed whe=
n
>>> SLUB was converted to per-cpu sheaves in Linux 7.0. The cpu_slabs,
>>
>> small nit: sheaves were introduced in v6.18,
>> but the cpu (partial) slabs layer were removed later in v7.0.
>=20
> Fixed up when applying by saying "fully converted" :)

Looks good, thanks!

>>> slabs_cpu_partial and cpu_partial sysfs attributes were kept as stubs=

>>> that always return 0 for backwards compatibility, but their
>>> documentation still described them as if they were functional.
>>
>> Right, for backward compatibility, because, unlike files that
>> might not exist w/o SLUB_STATS, userspace tools might assume that
>> they always exist.
>>
>>> Update the three descriptions to state that the attributes are
>>> deprecated and always read 0, and note that they are retained only fo=
r
>>> compatibility. While here, fix a "partialli" typo in the
>>> slabs_cpu_partial description.
>>>
>>> Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
>>> ---
>>
>> Overall looks good to me, so:
>> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>=20
> Added to slab/for-next, thanks!

Thanks!

>> By the way.
>>
>> There's still some gap between the documentation
>> and the implementation :)
>>
>> We've dropped a bunch of files that exist only on
>> SLUB_STATS and new files introduced with by
>> sheaves were not documented.
>=20
> While we are touching these files, the question is what contact to use
> there. Some have Christoph, some Pekka, some both.
> Seems inflexible to me and should ideally point to the slab MAINTAINERS=

> entry.

Agreed.

> But not sure if it's possible. Documentation/ABI/README says:
>=20
> Contact:        Primary contact for this interface (may be a mailing li=
st)

Looking at other mm-related sysfs files:

Contact:	Linux memory management mailing list <linux-mm@kvack.org>

> Maybe we can propose that it can also say
>=20
> See the SLAB ALLOCATOR subsystem in MAINTAINERS.

Replacing the contact with linux-mm mailing list and mentioning
SLAB ALLOCATOR subsystem in MAINTAINERS sounds good to me.

--=20
Cheers,
Harry / Hyeonggon

--------------YgT6oA9Qcxr9YGnpqYJ0rzq5--

--------------NOh23wvTE30Hws23l0EoVgJZ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakdE2wAKCRCGXBN6rc5S
1vfxAP9SCpQIkFDU/oly+VDOPNVw6h+A8ebDHoXAfgGj8xhZlAD/Y8bvDkASXQW4
1jTb04fo5dlGTxe9a/HeHtm79YGbKgU=
=pxDA
-----END PGP SIGNATURE-----

--------------NOh23wvTE30Hws23l0EoVgJZ--

