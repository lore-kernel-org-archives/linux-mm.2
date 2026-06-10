Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE38CD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F1B16B00CD; Tue,  9 Jun 2026 21:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B4D6B00CF; Tue,  9 Jun 2026 21:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A5E6B00D0; Tue,  9 Jun 2026 21:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 731EA6B00CD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:49:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FFBC1405A1
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:49:33 +0000 (UTC)
X-FDA: 84862321026.15.DA2AC89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8AD3E1A0009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:49:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwBiiMcs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781056171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JL+aiJchgdIg8nAkWjUrYb6XYpFsJdhaDCX84owCZxg=;
	b=R82DBAPW1mNQ4DFhoSkRmcIcv+jgtcVlnXqfxWoUTIXkdLORXz6SrqzLBKEwUe7SsLWG1l
	fgnwJxCkDVlwL4sYF8QjaXdR+qy34NYtsNtqGFUz2ZhkNZfklF7p1QZ3dVoy58mOKciTH0
	2amjcKdcdMH21QGrX+WZkoAXxuDrpos=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwBiiMcs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781056171;
	b=CBSEvR/R+YBMNZVJft7UcfFL1OnVv+DgYIb2eVXwHVsYKjrnfGzP2mnP8oS3zUrNPkEoN8
	Fo8JHU11VYWl6yro1dvGVQA/UBIDkGTiuIBUkZRsxkUfgkA4LmWNEP4Gu4lQe8Bt/9/TlJ
	Ow39AVNJs4nikY0it5GiT8+h5J1oF2c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DE9D602C4;
	Wed, 10 Jun 2026 01:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166121F00893;
	Wed, 10 Jun 2026 01:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781056170;
	bh=JL+aiJchgdIg8nAkWjUrYb6XYpFsJdhaDCX84owCZxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cwBiiMcshU0TTbLMsbROAOxC2Khr5/fu420cfU0g8MSD9mHzA3EACZiL0P2tkPa/t
	 tawwk3jPQnkJOttdMC6CsNYkYd2OfeKFTPhUCpd/gB+L6gVuHu/oywxhA675nZmMTy
	 C9DRy5N5LAe8NhAKUQbkuDoVfWw2+0e00YZimoDTOgmHR0i0/mVD13wE456tul9XSq
	 hcNybVn8CM0Szb0Oz3Atvq+BrBJZSAVtvtcOuIiVS9v0o/Wv+S0P04zlIQrp435WfD
	 mKm96qUO7q8rEqRdl8hn1e28qQzkV0Mxnk5jMBzpS/X+xelJCnheHuIDbbm5TSzahB
	 z+Tbw4TRJoKBQ==
Message-ID: <380dc696-7184-4ce8-8650-e5f49127390c@kernel.org>
Date: Wed, 10 Jun 2026 10:49:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260601095706.106551-1-hao.li@linux.dev>
 <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org> <ah-naIiz09TTBpXo@fedora>
 <5d8abe93-edd1-4b18-9ea4-7731dc831223@kernel.org>
 <aec090c0-137c-475d-9236-fc581bf1c97b@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <aec090c0-137c-475d-9236-fc581bf1c97b@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------FQgYqomLYg05asoeYG6ZVKTi"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8AD3E1A0009
X-Stat-Signature: mphc7sjrm4cpxafjoi8y18pztjc7phjj
X-HE-Tag: 1781056171-108794
X-HE-Meta: U2FsdGVkX19fWGmOuGrAw6phus7pYoHPSNsOvQ7u7eLQq5kJHwcnIiMv5nZARm49SNBhx3Q1jvymZhJY66PFZW8sHuW/VvN44y0qzxqWXw+H5m53iFgyIITaDCboikIukzhoyBzwM4bYVuMm9EgBLEUsfdcZXimamojB7AdZK8McbBS5xRdJE/jESxDJaKoIOkRNbh+VfZdyxFiq94DL9stZw59+BvGXwq6KJrdnRB21fPwqrKXBiKAaapsAqhK/E5lUc+pMANFzGUACMb+o1DOnw52jbu184HUf/EnvFswfRFQiPvdCGCiKhjmEj30u+p7jHRkGgbNAuy61BexvNGMVCNeNat83UUH5bttY0ujSnsNBGyPMP0fpuxekHhS1XwIL300QlaWqj7a6qR/RmRouk8NPZV0OPpqPM97KgTJOJ3IVv1olD6KFO7hHx94fPusL6q2lii3F8VfJ+i0FDgTtm6TLaxH8CthDQimS2saqPfRpaKqrhEJ5FvAjQEGD/x/dOuKx6aHODxZ5bAMTF2hf+49vefokIsAeqmdD3b7diJhVVcuqghbSBT9WtEEjcC61Mkwc+seHgs/gcaJbSi+j6yfCx5ilOg84qSfedbO9shhINGfTtFUnK390e4aMvLMkyCDdRki3UlCIaVk9lZS0ZWg7V3A71vEvxB+eIR1/meNhov7B9dDmuYbKTVQU6aWON0CHPuQXhLpPWs0Z1GkeIe1t8DvJjWeGAVbdgvdvIuCg/Oz3m5TQ7D2aKKSRRLD1Q05kvAQ0QQFYAsK/ftFE/tucmMA1y78jxW6D6+fUR6GpxEBIiHHez6qdMZolA4EjV4Neu64cZBsTLlkJSnFhiWC+4mwS11Us5QkKwbHDxfUNH0YsHdQpTQXtg5VvLzZmOxiMT1H50qxYAdxhtNLfe9H9OFwm46D6nEfg/JVpGH0hkl3H991fVagHKuPJg/ETyz55s/zA6jA37Ei
 22rZceA+
 NVl6noIHQ25iovxzv83YvQ6FlBGW7GhvueuufNjI1JTsZP0QKIRtvZGT9oibJJp4k30RoXbc2D6QDug+RxniFHCTLs5kukwruJWNj7bM77CrXxZNVUUNd0ZuVsHHX1wqwfCOJFu2Enkq7kFUc67InNf0HFpwNdefvDn5ICmyAkMefSOIGgPf/DZEzKVipsW9RNl3J42pwdgwOlL6GEGWJB4jKpsGVX504ca1OuquzpGhcFGHa1Fo5EW4ltKoPVjWyrWLiN0FSub5/rgySuPZWZiFsNWafviIlMWbgh4DC2rlL8zkDgQFXG+fkyb36I9AbCWJMH8hUhZ0MevJZ+DY+FeJOjGMSORglXAfSWt0nNeXbi39Dv6c4O2ow7KlJpoF/7x3pO05yeENEyt2k0QWKZujXvioBDATztOlxsfiMlrLbwYe15c/53Daggd22K1213isGEnsCOFE9wO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------FQgYqomLYg05asoeYG6ZVKTi
Content-Type: multipart/mixed; boundary="------------MjhyjoL4GC6C5Y7MLIZrfc0B";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <380dc696-7184-4ce8-8650-e5f49127390c@kernel.org>
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
References: <20260601095706.106551-1-hao.li@linux.dev>
 <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org> <ah-naIiz09TTBpXo@fedora>
 <5d8abe93-edd1-4b18-9ea4-7731dc831223@kernel.org>
 <aec090c0-137c-475d-9236-fc581bf1c97b@kernel.org>
In-Reply-To: <aec090c0-137c-475d-9236-fc581bf1c97b@kernel.org>

--------------MjhyjoL4GC6C5Y7MLIZrfc0B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/9/26 7:14 PM, Vlastimil Babka (SUSE) wrote:
> On 6/9/26 05:41, Harry Yoo wrote:
>> On 6/3/26 1:26 PM, Hao Li wrote:
>>> On Mon, Jun 01, 2026 at 08:28:16PM +0900, Harry Yoo wrote:
>>>> On 6/1/26 6:56 PM, Hao Li wrote:
>>>>> Sheaf structs are exchanged through node-local barns. Since barn st=
ructs
>>>>> are already allocated from their local NUMA node, this patch aims t=
o
>>>>> allocate sheaf structs from their local memory nodes as well.
>>>>>
>>>>> To achieve this, the obvious choice would be using cpu_to_mem().
>>>>> However, init_percpu_sheaves() and bootstrap_cache_sheaves() iterat=
e
>>>>> through possible CPUs, whereas cpu_to_mem() is only initialized for=

>>>>> online CPUs. Therefore, we cannot use cpu_to_mem() and instead need=
 to
>>>>> use local_memory_node(cpu_to_node(cpu)), similar to what
>>>>> __build_all_zonelists() does.
>>>>>
>>>>> The primary goal of this patch is to improve NUMA node locality.
>>>>> Although the actual performance impact is minor, it still yields a =
~1%
>>>>> improvement on a 192-core, 8-NUMA-node system when testing with the=

>>>>> will-it-scale mmap test case.
>>>>
>>>> Oh, nice :)
>>>>
>>>> I have a question though...
>>>>
>>>> I wonder if would be better to handle this by e.g.) not returning em=
pty
>>>> sheaves back to barn and freeing them if the node id doesn't match a=
nd
>>>> it's not a memoryless node.
>>>>
>>>> init_percpu_sheaves() and bootstrap_cache_sheaves() are not the only=

>>>> places that can allocate sheaves from remote nodes; sheaves allocati=
on
>>>> could fall back to other nodes and then SLUB could keep reusing thos=
e
>>>> sheaves from remote nodes even after memory is reclaimed.
>>>
>>> This is a good catch. In addition to the fallback mechanism, task mig=
ration
>>> between CPUs in __pcs_replace_empty_main() and __pcs_replace_full_mai=
n() can
>>> also mix up sheaf structs across different barns. So yeah, changing a=
llocation
>>> locality is not a silver bullet.
>>>
>>>> If this works well, we probably don't need to handle it in
>>>> init_percpu_sheaves() and bootstrap_cache_sheaves() at all as they w=
ill
>>>> eventually be freed, while covering the other case too?
>>>
>>> freeing the empty sheaf if the NUMA node mismatches instead of puttin=
g it back
>>> into the barn is indeed a good idea. I like it. But unfortunately, my=
 testing
>>> didn't show a clear performance improvement, though there was no noti=
ceable
>>> degradation either. :-(
>>
>> Hmm... the idea still makes sense to me, but yeah, it's not late to fi=
x
>> it when we have data to back up.
>=20
> I think if that approach doesn't complicate things unreasonably, it mak=
es
> sense to do it even if there are no clear wins (as long as there are no=

> regressions).

I'm fine with that unless it introduces regressions or the
implementation complicates things too much :)

What do you say, Hao?

--=20
Cheers,
Harry / Hyeonggon

--------------MjhyjoL4GC6C5Y7MLIZrfc0B--

--------------FQgYqomLYg05asoeYG6ZVKTi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaijCpwAKCRCGXBN6rc5S
1lrnAQC8qFy0nKaORHaxlLr7JrCzlxrVpOzix7cLrqXv9E6cbQD9F3os0Qz+ZcRS
tVlJywFJr22v9fMUzykAvlhm3vJJFQg=
=SSeE
-----END PGP SIGNATURE-----

--------------FQgYqomLYg05asoeYG6ZVKTi--

