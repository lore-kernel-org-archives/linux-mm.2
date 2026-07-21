Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39464C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EC36B0098; Tue, 21 Jul 2026 11:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40316B0099; Tue, 21 Jul 2026 11:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F816B009B; Tue, 21 Jul 2026 11:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E92F6B0098
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:41:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16FF91601CF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:41:20 +0000 (UTC)
X-FDA: 85013197920.10.CA18CEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71A5C1C0006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:41:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NtrX8Fj7;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784648478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AI9xw2VxbQp7jX/B5YduqGMEsi6H2MQYTvtbRLDj+lQ=;
	b=CIGJkw/7AfZKtUbrypjgqhZty1u/qPiMqBSShu6wOy9A1+AIwPiGAwf8ub+zv0JX9+AuFf
	DyrxXzUUzh1uN7vSobiQ2ZwrLwf1CMzv99HGbTvOvBe6RXJnR0xFp2jb5XLQ4OYgYD7yVS
	l4wcySAPVKlHTxAbZAPHCStvRA+SUZk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784648478;
	b=zpar/pg4FPosL2sis+d5bRkEV+1IzbNbF0f2FY4S5rQ7LCZK/YTi1Se40akO7qYfkhMM07
	Q7qkWDcHAHQFYwyoQ9dtbJdNFemDWL5J6nc0LhZ9WXeqQPulK1L42GbiotPHgcXzhOeuyd
	izYU/yRPtzt5yCYEU/R8BB47mDabj28=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NtrX8Fj7;
	spf=pass (imf18.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D51CA60054;
	Tue, 21 Jul 2026 15:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1312E1F000E9;
	Tue, 21 Jul 2026 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784648477;
	bh=AI9xw2VxbQp7jX/B5YduqGMEsi6H2MQYTvtbRLDj+lQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NtrX8Fj7MU5zwfg83ZUMZfEGaN6yiGQFBNo9V9EorL498LCl6y+uUXPMaew6uQ814
	 xtTYLI8WOBNCHHVSqPhwBh2fXbW3bE/a5lkOiNrco9fge8qyNJ/VnnyS7pkKM1k2xe
	 onZdI0uZk+PMrMcuhJ3A4cf9UaWO+L0m+imJ06ogOSUYiyczDvWgioLzgTt56qzPVN
	 zKTOPa8GJTEhkGtqjT+gbZLyme5ItgNld/9LEJEFa6Q04EuUZcNGxFoxtTQOkVqg/p
	 eOtSLf+4IVFD3piDBW8rTs+31ExAcMsWX003NIwQ+J9+Wl20w+NVI5P46zlnBc7E8w
	 wC+1cblY0O4qQ==
Message-ID: <31e637da-1ef2-412f-9c4a-26b720d7c74a@kernel.org>
Date: Wed, 22 Jul 2026 00:41:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
 <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
 <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lihAPi6O8DUJyauCGzEd0pPf"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71A5C1C0006
X-Stat-Signature: osac6ihotufoy9mb6356iaati9ijfmg5
X-Rspam-User: 
X-HE-Tag: 1784648478-705363
X-HE-Meta: U2FsdGVkX1/SD/tYYAmFDspiJuZj0diefr8szXp82+jpEFmqVrpJY07I8xpxd0vi3HtQBpJqPauWEtfvSlDy/lrHtXoFRKb83EQ6A5e6y9q75Df9J8yjUMt+VZgTf8jFtyz27UZvW0YVAEqx8utQl6WomhRJq6NWAyx4ZGptgP0lZWyAAFyseC9LBWGf1LZ00WOS79I0nv7CzXRrcsohCEHG4e8trvx6weephOFhMk76TE05+ZuDaxoPmN/xjZ7MNAQ7G8MvG7x/HSbFHPqSPurqeUcvt6IJTtFz0jvqO9wxOAZiSB0IHPKdaF3L9xPnoW5j/hvvaEgvvVB4g2DTenY82Ze6gbEY4+KDnwxe/wtX1S+4m7VzNdUhEOc3P7gHEhdyLgRdr6CoYpYrTcwrSFzaWL1UBUAlj7XThSq1WxjEfw92FlhBdsE8GyEycARYkOhoFf+DuTLIrB/maCPCBO4jJR1K4mWJudECvWlUKzz4JUvwi8Ya0G0gVkwYtTDT8ZPNidAtAQWCfgiA7mdIWqiW6Uw0D+BsUDv/OEOZlEnKOZ+WprpQLOjAeizoBOn4EL0A4knWeOhwSvAs/p57UUk7hLmQfAwL1n3m76GLmFhrLcxMbhwPdTogwTqDbhPDKS2+fm7s+LwOLtSsGjt0eFKeszKXFstizoJD7X6BS4SmDtDip76wh9ZOBHJLCcjsVccw69w11TOydAn7INci3jL7Xg2ZWU6cRjtElRtgbd4VJHXvJ5keA/RyZhIKFhYt4uIaZ8RaoR1PM6IBnJGox9tnCCOQLOXDCUniJBglaY287PWxeqEbs/YDfrzu/cYCLuys1i7HFMF17RObc/OxnRExwh9psRDNBPoHi+84Jb/9tfn1l1KxKnRzyY97tIg7ujveQ4Bnheqa1clxHtfkfvPk5TtWwBOPhWPr0LJFhNrzFnicDRcqw/xXleHtoOU5WqcQCyVKbGHIEHIimwi
 u0HQOmeP
 3CK9qobN4Oa/Y+1ouMl9fNubTO3nBxuVTKZnIyzM6ufLj7jL/ns1elCMOt6Ma8KzfHZs48ZEDxEybzmyeSo3opqm3mUXUeECRh7AUfp9r+mMd4EYOvEHs1F1YSyBvJ9ys7ADy5E2Iwg9Cw/rLTDIYW/c75SR6yKNtdFs+zVOMS9YX1GFybs+Komwy5XbBbCwe0Sjws7P9oLmEznKRVsuMq+4797ZOzh++iyYB51ALEZKYbrm9iq5Fe57yRk/pa5Frs8s93KRChN04171HJDX6sADp90Q80XcM/WCAr5o6/wafC5kEIEcUGTr6GRf3KgVcQv+pxt10rCuyXMjlOsRuDYwlAV4xHd2Aom6yVt+PZpNuh4Dm/YqOIdnWxNxLvILpt6PrjvTcFn6QZ4FXx5/ZWzEw7azIuEUfJ6EkD5Rz6G46V2yUGA0z15C2hKPbYn1jxst8abxt3Gp8fQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lihAPi6O8DUJyauCGzEd0pPf
Content-Type: multipart/mixed; boundary="------------DI7QtXXAQSwUVNu604OE0Y40";
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
Message-ID: <31e637da-1ef2-412f-9c4a-26b720d7c74a@kernel.org>
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
 <da6ca31c-f97c-4cd1-9380-4fe50d797a7d@kernel.org>
 <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>
In-Reply-To: <96468090-6b31-4f78-a813-c5729b53aa3d@kernel.org>

--------------DI7QtXXAQSwUVNu604OE0Y40
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/21/26 6:20 PM, Vlastimil Babka (SUSE) wrote:
> On 7/21/26 07:43, Harry Yoo wrote:
>> On 7/20/26 11:16 PM, Vlastimil Babka (SUSE) wrote:
>>> struct kfence_metadata only contains struct slabobj_ext with
>>> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field=
=2E
>>> If CONFIG_MEMCG is enabled, the struct can also end up used for memor=
y
>>> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
>>> enabled, it will end up allocating its obj_exts via
>>> prepare_slab_obj_exts_hook() and assigning them to the fake struct sl=
ab.
>>> These will probably then never be freed.
>>>
>>> So things sorta work, but not always in the intended and optimal way.=

>>> The upcoming changes to slabobj_ext layout would additionally need a
>>> proper refactoring to keep working.
>>>
>>> However, there's little benefit in accounting KFENCE objects. KFENCE
>>> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
>>> (default to 255) outstanding ones at any time. For any callsite
>>> prominent enough in the memory allocation profiling stats, allocation=
s
>>> served from KFENCE will be lost in the noise.
>>
>> For a similar reason I wonder if we can drop obj_exts completely.

=2E..for kfence objects!

> To make it clear, you mean kfence objects wouldn't have objcg accountin=
g and
> would essentially behave as if obj_exts for them could not be allocated=
=2E

Haha, right. Thanks for clarifying.

>> The idea that kfence objects might have different slabobj_ext layout
>> isn't really worth the extra complexity if we have very limited amount=

>> of kfence objects. The amount of objects that escape memcg accounting
>> will be quite limited.
>=20
> Indeed. I think the main point wasn't to have everything accounted, but=
 to
> avoid specially cased kfence paths.

> But I think this would probably just require adding is_kfence checks to=

> objext allocation paths to fail them, so that's manageable.

Agreed.

> Should perhaps
> allow moving some of the checks added by this patch to more generic sha=
red
> places.

Which places did you mean by 'more generic shared places'?

--=20
Cheers,
Harry / Hyeonggon

--------------DI7QtXXAQSwUVNu604OE0Y40--

--------------lihAPi6O8DUJyauCGzEd0pPf
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCal+TFgAKCRCGXBN6rc5S
1p1pAP0XU9L5CZnX3R1WlPuTzkAElnqLx3SBYNykv6t/dWnyMAD9HX2ksCXwGe4N
oQmhmLj0qHcHsgUqb1WXUMWF6EyZBwE=
=EJeX
-----END PGP SIGNATURE-----

--------------lihAPi6O8DUJyauCGzEd0pPf--

