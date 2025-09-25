Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A12CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 17:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F00B8E000A; Thu, 25 Sep 2025 13:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0C08E0001; Thu, 25 Sep 2025 13:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F1A8E000A; Thu, 25 Sep 2025 13:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63EFC8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:43:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0957C1A0450
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:43:15 +0000 (UTC)
X-FDA: 83928493950.20.2DDAE96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 71F1F14000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:43:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Unxgyn6m;
	spf=pass (imf23.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758822193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEajfTB1TGVaGyQKqPDxYXxgaXILGis08QBJBeset3M=;
	b=GsOWGIB4/QpcFHa8VUEeNmYgX93gX0EBiv49lE4eAifylsdKF2iUdnKnf1EgHD8Vxs6P+H
	Jz2hDK+uaKTyqgzhNd5ttdObh+6JPYVNjuG5mI4WetnN3AtScWQyd9GztPwZq9D3K8+e7v
	nvYcf/6Lzsp3UFvpJiygKY25vGDgW1U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Unxgyn6m;
	spf=pass (imf23.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758822193; a=rsa-sha256;
	cv=none;
	b=EsdG06dOprP9+PWKbl21XI+NjLkLyrgRNUhzG9euObGr9mDYHr9QtIWEzJ6w79TJGTHd4n
	yd5vZQ9Nd6fZM8VvQ60J2DY60FerjzQfNRh6PNyLDlqi0HzNikZpDb870ssOo/Hg+x5HL0
	u4GNKZk+ww4anP/Efr6oPOpLNEknx5U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59952611CD;
	Thu, 25 Sep 2025 17:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B12C4CEF0;
	Thu, 25 Sep 2025 17:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758822192;
	bh=6dZOpQBW/lA06q/6Y0/CJJMMvmBCufgtJLcVYXd+Yfg=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=Unxgyn6m7xG/mtrp/KMSCQcwsdWhvmbLsFz1bfLIqPGVJCUcZWeuF+KwUFW26waeR
	 8MQML/BxvpUuHYelcSdzftz1B00QmRjVh7LCS/lLBL9vxo+4VTdtiQbxIjlL74Vhp5
	 0tJl1HChfVNE2/tfseyYLcAMEmYBJtdz5xIqcD6QUWoWtjOjMv20GxQiV+9BZ29xxz
	 J3rohqJvaoADCqb2zpCatsovUTTVK6zeeqsLmciSTN0zjAWWMu5nwUCS2hcCyhluXL
	 NZ3E/mUUDvBTzhSSDq1JncC8kE3n63LY7wnUeVGgIcpkD3pXbdjGPHK+vdN2QAYHlm
	 Nmx3+nvqDOnow==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Sep 2025 19:43:06 +0200
Message-Id: <DD22FI7F2ZHT.32SL8PXFZZHV3@kernel.org>
Cc: "Elijah Wright" <git@elijahs.space>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 <linux-mm@kvack.org>
To: "Elijah" <me@elijahs.space>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
In-Reply-To: <73d7d53f-439b-44a9-98ca-0b1c8fbc1661@elijahs.space>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 71F1F14000B
X-Stat-Signature: rfrg6ymfco3ke8557wpuubgszs75iqbf
X-HE-Tag: 1758822193-62817
X-HE-Meta: U2FsdGVkX1+NBYI130TYPwXuoDaD8SmpZx3cvJF7+QIE3RwULDDCDJYZdk3AngX2NON/VcCov05fkB4onfzvsKPpr531lHRpqhemvPFmmy03u6pbDHpUPW+P85bWKN3BAU/X34eY8uAzl/MPMiCsGxO1cAy8JRvfop3P7qKcIhfNbUtnikcwUOdYQkHAL0fayse6QhgrXcALFKG83hl8VADDDM3yBd1umtli57esC7h4OTbkZEIAafgLrt4ixcoggSgRrHL6LUzZoKi7M5RpFtAK/ui+covDND0NH26FmcvwEvsKDuUyahGYVP9Xbmu7hf0HlGDhjwCfcnnruqH3c//2CZeX6e7+Jl/ROA+kfyNjq7bS6VKQIijzmbim3GKIiV3WyumHqTSrzDzcRS2VZhXPPV+soUXIVciKECGieYBIU8i+V0EYHEe/D5gUAsG69d1lkl3DFlJC8lZZcpq7v79MHg/4iCr9Ra8ZhPEU27rUT8eJgMxuV0XPiTkQYmi9fSza0ZZ2E0d5W1DZW8RHEdkZNSneJIeV5CeS3jt6ErETuInKfORgzWvaRxg63UAVvMQThDFaoGvQ5kd0vcbzscHJ98emk1S9HNHWTXvYlMLmzUmHBE4jNIwOH6onsC4Bo52B7TS1dAafoazZ5IwMorPYQalI3/CEpxjAQ98iQbtiLzElexvDD6zwy5/FHCDMrqIXpFx8TBv0tFMW8fo1DDGG78Fz6eNFnrrOC4mNW9piAkpRFZdjuqPRhnHnmjn4tLZNwtGX/a5+36pnEL0teGKclM2Ri0yRoT631CAGmgzx5N7T2g16VcqkI+n4NDCYQwvH9OERlL1slt57wxxH/OI7D+W1bvXCFRYIriQqpVYUVWc0bnanrZSlxzi/Z7OD2Cy+Mj2oR68PclJBYnohKoUAaUFUmwnMth+gj/lWUOriEG10H+7nvYe5BQhyAPFfwT8o0bgA2Ivc6RxgInx
 km3bGqLc
 s1ef2eAChMuyJcpnGKhNdbWfcDf1joEXROJkPcQDu9dBiTX5xWGnahlo+bwKYz04AR/Z78pxoqbDpD1PqHVrxr5b2q13dt26GjxVHhR0HWnt/JxprfHAQX8Hv2vhPdgzTVMNG3dybuSGSHp6ce43ZMopRBZPO6/AKv387Ys4XKnE2UOXPULIp+b9zBtvmk1nvAUKRg5vIK84o98rqShrXbPv+AYSBNu0q5Cmq5eoul8rSV2odHDsR3zfUqf5o9TxVdc8lCoAsWy3/opD8+YR9d9Tdetg6k11mpRWsi6z1X6nfWcf7ROByod1vtwFNVyehIZ7GLTNotyA2zwml2P909WMUrTNYX4SHj4cYEfkYkPvQ+BWB8bUKqUF9qqNAEtW5xsWwfT16dfMOrmoe+/tOH1R+SQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 25, 2025 at 7:20 PM CEST, Elijah wrote:

Please don't top post [1]; use interleaved style instead.

[1] https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replyin=
g

> I was thinking of maybe creating something like KBox for kmem_cache but=
=20
> I didn't want to touch allocator code yet, I figured I would just create=
=20
> the groundwork for that to exist. rbtree.rs uses KBox now but I'm not=20
> sure it should, at least if it's going to scale to many nodes

Ok, so you want to support kmemcache for rbtree nodes. Ideally, you should =
also
have a use-case for that, but given that we'll also need kmemcache in other
drivers (such as Nova) anyways, I think that's fine.

However, in any case this should be integrated into the rust/kernel/alloc/
infrastructure in one of the ways described below.

As mentioned, I would like to see (3) or (4). (2) may be viable as well, bu=
t I
really hate the resulting code duplication (not having dynamic dispatch for=
 a
kmemcache backed Box is probably not that big of a deal though).

Anyways, I'd also like to hear some more opinions, especially regarding (4)=
, as
mentioned.

> On 9/25/2025 2:54 AM, Danilo Krummrich wrote:
>> What's the motivation?
>>=20
>> I mean, we will need kmem_cache soon. But the users will all be drivers,=
 e.g.
>> the GPU drivers that people work on currently.
>>=20
>> Drivers shouldn't use "raw" allocators (such as Kmalloc [1] or Vmalloc [=
2]), but
>> the corresponding "managed" allocation primitives, such as KBox [3], VBo=
x [4],
>> KVec, etc.
>>=20
>> Therefore, the code below shouldn't be used by drivers directly, hence t=
he
>> question for motivation.
>>=20
>> In any case, kmem_cache is a special allocator (special as in it can hav=
e a
>> non-static lifetime in contrast to other kernel allocators) and should b=
e
>> integrated with the existing infrastructure in rust/kernel/alloc/.
>>=20
>> I think there are multiple options for that; (1) isn't really an option,=
 but I
>> think it's good to mention anyways:
>>=20
>>    (1) Allow for non-zero sized implementations of the Allocator trait [=
3], such
>>        that we can store a reference count to the KmemCache. This is nec=
essary to
>>        ensure that a Box<T, KmemCache> can't out-live the KmemCache itse=
lf.
>>=20
>>        The reason why I said it's not really an option is because it dis=
cards the
>>        option for dynamic dispatch of the generic Box type.
>>=20
>>    (2) Same as (1), but with a custom Box type. This keeps dynamic dispa=
tch for
>>        the generic Box type (i.e. KBox, VBox, KVBox), but duplicates qui=
te some
>>        code and still doesn't allow for dynamic dispatch for the KmemCac=
heBox.
>>=20
>>    (3) Implement a macro to generate a custom KmemCache Allocator trait
>>        implementation for every KmemCache instance with a static lifetim=
e.
>>=20
>>        This makes KmemCache technically equivalent to the other allocato=
rs, such
>>        as Kmalloc, etc. but obviously has the downside that the KmemCach=
e might
>>        live much longer than required.
>>=20
>>        Technically, most KmemCache instances live for the whole module l=
ifetime,
>>        so it might be fine though.
>>=20
>>        (This is what I think Alice proposed.)
>>=20
>>    (4) Solve the problem on the C side and let kmem_cache_alloc() take c=
are of
>>        acquiring a reference count to the backing kmem_cache. The main q=
uestion
>>        here would be where to store the pointer for decreasing the refer=
ence
>>        count on kmem_cache_free().
>>=20
>>        Theoretically, it could be stored within the allocation itself, b=
ut it's a
>>        bit of a yikes.
>>=20
>>        However, it would resolve all the mentioned problems above.
>>=20
>> I'd like to see (3) or (4), also depending on what the MM folks think.

