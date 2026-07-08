Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA0EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801556B0005; Wed,  8 Jul 2026 10:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D94A6B0088; Wed,  8 Jul 2026 10:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEF36B009E; Wed,  8 Jul 2026 10:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5A16B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:01:11 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5AF8C05D7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:10 +0000 (UTC)
X-FDA: 84965771100.08.4439958
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 938604000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlMlCC2k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWBeYBKTsPxmSmrWR5dD6tT/sFVgb0W2FXc/WHMVd3o=;
	b=WVWzUgInzmaVnqW4d8cDz6BL5v6l7vBKO8scfa7Hkp+dRCd4hQ/Ox/O/yq21FXBJSv+4/1
	IK/JStaDidrCckPSEqnS+8PWhun1WD/kns9wooyt3kmYYUPATFSMf9QREWK/l75NcXtriA
	kvZvPXTguj4WLRqcCCMWI/OzZ+VGq+I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlMlCC2k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519268;
	b=WOswhElIYLsLbSZyJO3GiFF+L0qLuxQGG0chF4en8ZkSMdoBePV8fpt9NUeQ1cKFMoT0iV
	Bb4NPlhoaj0yhCmP4GosFwycjggDMcKbyWRafVpnJYkTEslL1sWF+xyIgGeu6zHYDN+xsh
	xknHJfoA3ZCs/djM2zViE9G3S+IyC7Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C9CA43332;
	Wed,  8 Jul 2026 14:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DC91F00A3A;
	Wed,  8 Jul 2026 14:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519267;
	bh=ZWBeYBKTsPxmSmrWR5dD6tT/sFVgb0W2FXc/WHMVd3o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hlMlCC2krrSFfA0KjxNyo3KbctkEX2rJPS6YVpogfSe15ml6rs6a3COh/0LmJryoX
	 YlGBO1jbfzs0dvAEOVNjMlSeiLzCt1JWQJ7jIJ6CGsNInl3uK17PLnbE5JI9PIJCyi
	 bYyYNXmMYMtOdEL3+t+A+uqHIwN+9YBsIq4jfSk2POFwscKdkCwH/X9KIuLSSfW8ld
	 RaD4bqqydV0UD6RsL6FoqJdoiVRqFmk1unXjPSR46mJqLUbTy9zRb65NmD6GdvRRGf
	 pGl6vjrMcQt4AyFoGxsZBXqxCRVywRWHDcafzcJ6OQolNE0zXwWWTz3g6s6T5RQME0
	 h1t4SvL7ErnOw==
Message-ID: <b7a50cac-5cab-4938-a16b-1b9091cbdf4b@kernel.org>
Date: Wed, 8 Jul 2026 23:00:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: fix lost local objects when bulk remote free
 batch fills
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, hu.shengming@zte.com.cn,
 akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <202607062139095043SOsLi6TIf403tcjPf8fm@zte.com.cn>
 <84c4c2bf-397e-461c-b898-482d1a49f40b@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <84c4c2bf-397e-461c-b898-482d1a49f40b@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------a7AZcdOAk08A059gQIFz2y9h"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 938604000E
X-Stat-Signature: 3o3fhw4ny87mu6sizj4y1zz6r8eguiy7
X-HE-Tag: 1783519268-79469
X-HE-Meta: U2FsdGVkX18L3k1Omxbc2LgiXV+hrKjS1W7vMKXOBUnz/X/RxnTBTqnjjGvO/bQoEHoxR4AjXwJWCt/w40X0HF/Z9CgmGSCQDpUz0+ZXOpHbdxMe0Oz5CbbXnNrGgc5pAiyX+i6qZmoxTuSR07bTOjc2ULN1CmqW0cUmj+jkKeTQZ/C3wY8n4N4xETnOy4HxZwttrhY9kK7SZI3xsoa/487+BYcVzHz5ZpqeVRU/S9x6aqf6Qw5QlW1T1Gw5lFnhjCPiA2wL3D2spFE1MlWGisIHb0F8Sq0Ho6kNFuvK06MPFzDZxZVZvrRapiCVyWcgE0cHfgXR5H29W7sV2L3wLLiiohTSgpPZgLVFyqToZn182DZ7sjo+fh8ywrvYFzUUi3YPMfDdTY6KtND0JgCMd1jtt6lO7B3bw91Y6nFr5cGeFb8jjy3crUY4olTn2h4JEzHGdyg5xdC4TygBONR6MZ4oF3QCzePALLgp/ajx/xHsyctn5NCPs0oXsGCZQqXzJe4CiP/xhDDtNnfaUdg4yVYyWk2l3mLT5cvbaxiQQ86zzSE7McH1oxBhrZJgbogbT8qSXVkwhD3t4Sh8ZORUyTX+SsFWvMC7lJTyyVsg1lZg9sN7IJYOMdWIkYZjYZdxeGcDl4cOi6JCf6mjbKq8rGl9oq/uaIAHoNXPFy+k4W+JUFnRG3jkyNOnE7ZXuovJNkB3cZT9PQEmjQ1NIp/NEXsG58qZMA+t+pNyxyEBYcl2JNwwfOrP0dOOUbZtbzd+F9Q0NYlgLwTVHe9IcZw8xnd+9v9volwWHll3ju2lnFCeE9cJyY4UCuQXkpZ0TPVak9lfUxLINGG1SXGCoyVW3J4pueh22tGAT6qgEv05A0fQdJUlYTW7fFLeGQi9+LUdXE3eH3HR9UJYGmFlDNu1ML1V5OEuif7koEPkBWWmKbgs5DYv4HIQz/fKGDE4tL6y+4c8kJFM+wCfLKd8M8+
 VFHhEtHw
 v1/z8cVO5awc1MARX1su8fU+tb87imqWADlKfxW6tiOOcoVfoTXZe+hyk8ZK00LVF8mc7csJdDHU12SYYfydlqf9UKIloq/3TgSkAeB0GCE2W5hSEK/NDA17mJr0odiNnIbd18ZSMQv2dBHWxO6bYTunbMheVe3veWrvSa14giQnwxUGFbKeEQqKP8yu7bTm0dnq7TL1eiUU6a3oXOn7Mf2MHR0913yMB79lzPcwJHKJ0QD5PFOXw6ygvGKWZrZ/z3kOBEkHOt3NeCZA6yAV03fZkajjorU3/jh4ScO3LOC0hRGkd4OiFtF04YNbgDd4oDI2/YjF3Za4kRwFcAqq5VkLvvO2+ATJSuKiFpfHh2RvYg1CWbAueH22vl4CoZG9AYY3oR1tLZ9XkSqBYBhNMsZmEPy/vq+gcktJVNElYlC/GJmzqHCxk7GZyYzE7NWQTeqkbB1ZnZ7XSAYGxE/ooS3rrxoG8NoF1yCKRc5eRXWN5BeoHRxhndOMYsw8hrrCmZemLeDsOeVOsaYpeF7/PkPOIaF7JGk+avhJg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------a7AZcdOAk08A059gQIFz2y9h
Content-Type: multipart/mixed; boundary="------------0pyQRp0tdhi5apzn07P0glTF";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, hu.shengming@zte.com.cn,
 akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <b7a50cac-5cab-4938-a16b-1b9091cbdf4b@kernel.org>
Subject: Re: [PATCH v2] mm/slub: fix lost local objects when bulk remote free
 batch fills
References: <202607062139095043SOsLi6TIf403tcjPf8fm@zte.com.cn>
 <84c4c2bf-397e-461c-b898-482d1a49f40b@kernel.org>
In-Reply-To: <84c4c2bf-397e-461c-b898-482d1a49f40b@kernel.org>

--------------0pyQRp0tdhi5apzn07P0glTF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/7/26 6:27 PM, Vlastimil Babka (SUSE) wrote:
> On 7/6/26 15:39, hu.shengming@zte.com.cn wrote:
>> From: Shengming Hu <hu.shengming@zte.com.cn>
>>
>> In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
>> the code jumps to flush_remote to free the batch. If all remote entrie=
s
>> have already been compacted out of p[] via tail swaps while local obje=
cts
>> remain, the flush_remote path returns early since `i < size` no longer=

>> holds. The leftover local objects are then neither cached in the sheaf=
=20
>> nor returned to the slab freelist, causing a memory leak.
>>
>> For illustration:
>>  size =3D 64, local objects at p[0..31], remote objects at p[32..63]
>>  After scanning all remotes: i =3D 32, size =3D 32
>>  p[0..31] local objects are dropped.
>>
>> Harry pointed out that, although the logic contains a real leak, it do=
es
>> not appear to be triggerable with the current in-tree users. To hit th=
is
>> path, at least PCS_BATCH_MAX objects, currently hardcoded to 32, need =
to
>> be collected in remote_objects[]. Looking at current kmem_cache_free_b=
ulk()
>> users:
>>
>> * maple_node has sheaf_capacity =3D 32
>> * skbuff_head_cache has sheaf_capacity =3D 28
>> * panthor and msm drivers have sheaf_capacity =3D 4
>>
>> The sheaf capacity is, at least for now, derived purely from the objec=
t
>> size, with the user-requested capacity used as a minimum. Therefore, a=
mong
>> the current users, only maple_node has a sheaf_capacity large enough t=
o
>> reach PCS_BATCH_MAX.
>>
>> However, for the bug to trigger in maple_node, all objects in the shea=
f
>> would have to be from remote nodes. In that case, there would be no lo=
cal
>> objects left to leak. So this issue was found by code review rather th=
an
>> from a runtime report, and it does not seem to be triggerable by curre=
nt
>> users.
>>
>> Still, the bug could become reachable with future users, a different s=
heaf
>> capacity, or a change to PCS_BATCH_MAX. Fix the logic by freeing a ful=
l
>> remote batch in place during the scan and then continuing to process t=
he
>> compacted array. This keeps all local objects on the normal fast path,=

>> while the tail path only handles any leftover partial remote batch. Th=
e
>> redundant next_remote_batch jump label is removed as well.
>>
>> Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object fre=
eing")
>=20
> Removed the < >
>=20
>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
>=20
> Thanks! I added cc: stable anyway so we avoid unexpected surprises in c=
ase
> something else is backported there that exposes the bug. And the fix is=

> small enough.

Ack.

> Merged to slab/for-next-fixes
>=20
>> ---

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------0pyQRp0tdhi5apzn07P0glTF--

--------------a7AZcdOAk08A059gQIFz2y9h
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCak5YHAAKCRCGXBN6rc5S
1sWKAQC+KhWT6wvchRiroFUB/oFj9EbbMA/6FCabhMvsQqNKBgEAqFTLaSdGYUyy
k0Z2DDN460S7c7J762T9o7WNYzHL/AQ=
=vh99
-----END PGP SIGNATURE-----

--------------a7AZcdOAk08A059gQIFz2y9h--

