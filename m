Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A286C4453E
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 06:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0316B00CE; Thu, 23 Jul 2026 02:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60F66B00D0; Thu, 23 Jul 2026 02:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979756B00D1; Thu, 23 Jul 2026 02:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68AA86B00CE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:28:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BDD5C03D3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:28:04 +0000 (UTC)
X-FDA: 85019061288.02.2813686
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5CFBE140007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:28:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPjzG0HK;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784788082;
	b=T27fnDS3mzlxf77VZTzdIg17UyCFuwJ6wTcfILLbvTWSMY7uJfov1lv8zOb3sinOomEnBg
	aRN9sl4u3mn7pXf99tipAlv3CIJp95/QcIdDiTlXGnguIRFCZ3Xf2oUuxrAYB1nfrbZhcY
	uDLMEv6UaD+XHeTaSBdlVU/SJH5O9N8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPjzG0HK;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784788082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPGIxjg2fvOObq3ApTehOQxmp9hWxXn/JtuKKDwREDg=;
	b=5S2zGKVhc/oUSr7xEawkhu6i1mVzO4DRiszhgkD7ApYAERGVJEP2En/nef4Psp1pq6i7zn
	DzWbb5NG0OUog5+1CJYIwaRHj1zKQZPWczh19l4fYAV3talVn1ZbNkUptZbN+A+kj5Lks3
	oAl11etpwAVzKw+RgVo4yNOCPUqJJt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79753451A8;
	Thu, 23 Jul 2026 06:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EFF1F000E9;
	Thu, 23 Jul 2026 06:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784788078;
	bh=BPGIxjg2fvOObq3ApTehOQxmp9hWxXn/JtuKKDwREDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YPjzG0HKWyOi7d9iOKzBWEMsrwb+6qVAvKGm3yO1k+hH8+8o3eYmS9GJiEkj5h2+A
	 M3BlaNMoNz/bul/F/Pjc+6IFZq+yw2Lg+/Y+v8kpBB4Z7Gt0jxQ/9keLZ9e3535Xlr
	 0TdsgFsM1DxgePRpFkjm1ycO3YNOti6AW9xayvlEJbhsR6Z2zaVn4jhu2N1L7nOsih
	 as0FD4UqccGC0eQ4gzTouCYN9lAb8mYmSpQ0T9W9J+DtL1yIUAONyZJldae6z+OS0P
	 rogcL4PDnA2aky0jiiV0m+nH60U0kONX743S23Gd4+aLFc5Co8M+mPbI79DF5kztY8
	 H3L9TLPIn3SBg==
Message-ID: <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
Date: Thu, 23 Jul 2026 15:27:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
To: Hao Li <hao.li@linux.dev>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <amGEY5w-cBm4_uhx@fedora>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------S1stg09klGnjKz70otvyV0jo"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5CFBE140007
X-Stat-Signature: kjcs4kpi64fo6s4axn6yx5exn8o1mqp8
X-Rspam-User: 
X-HE-Tag: 1784788082-534052
X-HE-Meta: U2FsdGVkX1/Cc+a7RfY3BimAhbKktoHhvo9xIvRL8MkARkXWyX7/egDFC4wvgt2UVwhZoJHHjktjn2YEdS7YAmmNwDbXehMQbsnHC4nx+FnP+wzDzDH4zcVCm+dqyf5nuX+o2iWDkVRwSjAtb97+WyDf5d3WTl6gEASN5ZhKxdUHWccBbxnl0c2WUqI+KlxFTfapZQXFjIV0ghvLoLjVf/HPly+zDYoHXvcKlSgEDMwZITmTKbaf3TBkjW8hh8JEzZZ83QAHcu12ZcmiJURn3buo4GXV6R/mEf/nF0iVIP/64FS8dE4V84kMjVKa+c4pPJSCUeLvZ106q2EBarOMhY1F/b9LuBp97cANNB7ipuIGwL1jLrL3YhjkKzClRBFz1gCZNhhwhQJ+gAMNh5KapIKfUCUB/Zf0157vZEqdHzAAKWi1tCqzCC54MATcNkX53b+qmikMOFz0uYSwuwtXyKdg6cUDMyJ+2sJgMYdrpjDQ/S/O1LEnvjsej1D6GfYJ8oYKFZ+kuozLBT/FBIdQhW6AD/ukK2+GGmx97/Dbw3jEtr7weaG7HOOLzsCT7235e6ZSmumXlPz/fRoA7zPLH+fV1G4CDHQkO9cIqcvhnRoBG3NUjHl6ryzBUH/c7TBDf4GRHYqY8cOZvhDGFP9gL8ZyvczWNuwO57KGzg+ox5GbIVkELZreRLq5o6H8L2pJN9DKjGSu3BtXmUvSJgN7U6ZZbvYQjt3g7JAgQUKzk5oVchAyIcXOrHW9+lu25yNDc9a6W69Ppd7i4CAusWh2AZphsYb+H9jLfzFjNxl7J9FInP/5OZZDKXLFMoMlNRz+jk6utTqttVpqeS0O2IjQpccbg2yZ9i+R6SV6wCcf6pQlUEr3P9a9XgY7NH+hCjXA7IMw4LBc7RzEMu8OINIBk6hOoeKE5ctp6/tzXmxMrPF9bGjDr/rKsddRgeZafWa2cIVL/xtC8yEHAZulvXj
 WOYho8qp
 JbO8yW4f1ITTklU50QsGPNNzULQcw4wh94r64g0E1FWTLoY3TDVysAKSypLrOZ2u082abfhY0tXN/R9JnuRE9EYu++dsFfbdGptacXcD3I/CSnMycFmyb8fM6XY8FF+EBvZec79rkY5+UoRfJ3NeNaPAIMtKErlm5XDXHW8U5+WHgp5eYvhucieygm4WpFmDpnAPeVTmankXC/8cW05nmm/+37plVJ8zJK2i3CFNrCG9DYPirEXqzUVrmsQ12OpV6BROy813uvlinBxcR0S5uN+D0UwOhkd1/kOSf30Ev8n2jYdNPPupOmDEefgbZykV7bov5s9kODMG3r+8wc4Bi/9/1+ksho1JA0/Taj4JbKrBciPAJUEst5/9z+LqWMH5qtyZj37IRgL2RjjHRL5m0qFm9EL4dPoyMsw2pWrHGwgaxyabEkATacXMfoeD/F1boQ9bE3iZsIUd87K/C/2OsmjabzqDWLCluxLvXasmMP4PrGCL6FHJHtmEO1pWIO6mGzy9vP1X0BLD4R7E7VC4NFHYfCFSKjN/pvPMtWvlmLb3tE00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------S1stg09klGnjKz70otvyV0jo
Content-Type: multipart/mixed; boundary="------------7Aat19BJ00A9a69ufvP0WjqI";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Message-ID: <9b2dadb7-8e3d-4b9b-a870-969be9a7a432@kernel.org>
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
 <amGEY5w-cBm4_uhx@fedora>
In-Reply-To: <amGEY5w-cBm4_uhx@fedora>

--------------7Aat19BJ00A9a69ufvP0WjqI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/23/26 12:05 PM, Hao Li wrote:
> On Mon, Jul 20, 2026 at 04:16:23PM +0200, Vlastimil Babka (SUSE) wrote:=

>> Currently, struct slabobj_ext can hold both objcg pointer and
>> codetag_ref (when both are compile-enabled) and there is an array of a=
s
>> many slabobj_ext instances as there are objects in a slab.
>>
>> This makes the layout fixed so even if codetag_ref is unused (because
>> memory allocation profiling is disabled), the space for them is
>> allocated and wasted. Similarly, some caches (currently kmalloc_normal=
)
>> do not ever need objcg pointers, leading to wasted memory with memory
>> allocation profiling enabled.
>>
>> To make this more flexible, change the layout so that struct slabobj_e=
xt
>> becomes a union of objcg pointer and codetag_ref (to ensure uniform
>> size; in practice both are the same size anyway). The slabobj_ext arra=
y
>> then can have twice as many elements as before. For cache locality
>> purposes, the effective memory layout is unchanged, so objcg and codet=
ag
>> ref for a given object are still adjacent.
>>
>> cache_obj_ext_size() returns the effective size of (0-2) struct
>> slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
>> both return a constant value derived from the config options, but will=

>> be made dynamic later. Replace all sizeof(slabobj_ext) usage with thes=
e.
>>
>> No functional change intended, the layout is still effectively static.=

>>
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  mm/slab.h | 49 +++++++++++++++++++++++++++++++++++++++----------
>>  mm/slub.c | 19 +++++++++++--------
>>  2 files changed, 50 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/slab.h b/mm/slab.h
>> index e586798e4f16..f8446167e175 100644
>> --- a/mm/slab.h
>> +++ b/mm/slab.h
>> @@ -550,18 +550,42 @@ static inline bool need_kmalloc_no_objext(void)
>>  }
>> =20
>>  /*
>> - * Extended information for slab objects stored as an array in page->=
memcg_data
>> - * if MEMCG_DATA_OBJEXTS is set.
>> + * Extended information for slab objects stored as a pointer to an ar=
ray in
>> + * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS i=
s set.
>>   */
>>  struct slabobj_ext {
>> +	/*
>> +	 * All elements of the union should be pointer-sized to avoid memory=

>> +	 * waste
>> +	 */
>> +	union {
>>  #ifdef CONFIG_MEMCG
>> -	struct obj_cgroup *_objcg;
>> +		struct obj_cgroup *_objcg;
>>  #endif
>>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>> -	union codetag_ref _ctref;
>> +		union codetag_ref _ctref;
>>  #endif
>> +	};
>>  } __aligned(8);
>=20
> slabobj_ext is now acting as a generic struct, serving as either _objcg=
 or
> _ctref. However, because it's set to __aligned(8), I'm wondering if thi=
s might
> waste half the memory on 32-bit?

We could loosen the alignment to
max(__NR_OBJEXTS_FLAGS, alignof(void *))

and drop OBJEXT_FLAG_UNUSED.

=2E..not sure how much we care about this on 32bit though.

--=20
Cheers,
Harry / Hyeonggon

--------------7Aat19BJ00A9a69ufvP0WjqI--

--------------S1stg09klGnjKz70otvyV0jo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCamG0ZwAKCRCGXBN6rc5S
1qvSAQD8ldDgjvd06RRWLX1ZE+QZB780OCmBJqOM3n4si+4IMgEAnr9xvjuton1b
+1ODJQBFyP54dvPyJNUOAoq7Bs43tQY=
=Z9VW
-----END PGP SIGNATURE-----

--------------S1stg09klGnjKz70otvyV0jo--

