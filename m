Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1759E606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mzAOdHIZ
Received: by kanga.kvack.org (Postfix)
	id B720F6B05B1; Mon, 16 Nov 2026 16:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22C46B05B3; Mon, 16 Nov 2026 16:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A116F6B05B4; Mon, 16 Nov 2026 16:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7276B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:18:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ADA0F160252
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:18:01 +0000 (UTC)
X-FDA: 85442244762.10.A5331CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E02541C000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:17:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzAOdHIZ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794863880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smExq86HgUdYerFlr69Kqxdhv63A232dwxsLREEw3p4=;
	b=W/f48JDA3StYFFSraBUhg+NFKwSZabWDJl6C+QBlnlD0ZozzbthGXpUXvMYGS/z6URgNAG
	gl3rEI7TD8VeGaKfvJYGGbHNfyvXr+zp0vGW5VJtWA0+ATzQEkxANpNyguvGkoqpcXkWSl
	ZKR/a9nxrJCab6QojDFTXpSW0CrieQM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794863880;
	b=klJvdFl6HAir534RcZg8HHitCgFNI3tbPojcFYCaWJ+0EYCclptK7z/VGSGnNm4jk3LktM
	TteUc7/KAx/6fFRjzZV1zuym7ZjgYgnYooExg9OVe0DcPKianqK91LMZHA/uwT/8MVehCf
	yuQUxFK62C3w+nz45n7yj5Mlewhlavc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mzAOdHIZ;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7746A6250C;
	Mon, 16 Nov 2026 21:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DACC1F000C4;
	Mon, 16 Nov 2026 21:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794863879;
	bh=smExq86HgUdYerFlr69Kqxdhv63A232dwxsLREEw3p4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mzAOdHIZJD9xDsH/i0vcf/x6K39M37dnepbGkiEmMg39e+ZDXX4HjFA5iXNz2sNCY
	 CH6bsVpxmXGbv81yT5tCw4y3FTxSMaNFOir/1405KuWynGOPXGMCpK1pjelzlWsD3s
	 usnkslfnSXb3teuadWRJBN+Ay5VSlVd6qqiaHSAQxJY7fWL+k2H3hRUnLbdiXopNdW
	 yhHTEyopj94psJh6fvAWVVwmt5cxKADmff/u5QgBMMWUWzwJiBTElW2V+RQzoKNwwQ
	 PgF925QP23y49L3Jwnm38GOajTfETX2Qdg3mBhN7LWPT6IkM/FiZHTaAPb6cDCQsI8
	 healx4GxwQjCA==
Message-ID: <156fd3a1-9422-4264-9e3c-8818ecd4a58f@kernel.org>
Date: Mon, 16 Nov 2026 22:17:53 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
 <0b794f803517c27ea818a2e894761095300b4da4.camel@linux.intel.com>
 <6af3d5d2-4fab-4a3f-85d9-34564fca8ffe@kernel.org>
 <58755e3cb51d534b749d70847a5478a40c1c10fa.camel@linux.intel.com>
 <f81bd37a-9637-44be-83fd-be7e717fa182@kernel.org>
 <0a8c14b4ee7e332c3c59d23fb71aaa953e12df5a.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0a8c14b4ee7e332c3c59d23fb71aaa953e12df5a.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E02541C000C
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: gy86jpx4m8z3ra8ru37k7n9khswsmyze
X-HE-Tag: 1794863879-463736
X-HE-Meta: U2FsdGVkX1+JelICDrOXPKuXIaE72jcF0CK+X0ffBd87qXiBjmMBiBJgzqodpdDh6znjol8LbZm6K91K4cPQsYZTkWolAr0sp7UomcteukXYIHTMiEAccVsQclre1Q9Kfd2RBZrYwYyfUB437Lu5E3MgewFAEcNLPEorKsKYsGabWqK8nInmuWs/oqgGw3/C4DU/NihCV5XgZtugnbYWZiVsQsmg1KLrHkMw9hsj065yv8qJoLw1UEYqcsGfNasrGNSaVdKH7RauuR3dchU+CQ2OZQORD3sK8NRTbwHYajqf3yxN6Pcgk7hbZqLA9td8yiNeR8D0R3CUPXa3DwLdORLUXIzRs3TyCXM0eusC2IKSGBeVTEN+fWJkZlWqhIT3qlBIqAUtQTV0QS0u+z9W4PYtJZ00/uWgi/+qW8ZnLC4YmGskjj1E6fHPMiBPj/ecgntUz/+TjIyplJ7lnW3QPu9MqEg9VRTYfq5TnKpSFqLHznFv67DWZLBcgJT5Z+HpjFCMvRd2oWa0RXyP2vMoOrnCMQ6UtNxnkpDzlaQlocgQATB9fJ/ROEVJG/14+xkmtfM/Xtf9GIpLfFqwT/Ah1swKo07yznp6AbhGjb/XsXf90vLqwfwGN5aSRNazFWoaCPbyYhN5Mt8CZhHEa73fDR7pg6eCZG3uIuosTiR9/ben54CjLDYiRsNBzb42Yiseta7bQsBoJZR+xmDd2hE8awHK6n4jXbbSb+UwYH9HTeLyYxpDyhKeLKCEkOCuNnXRgFtrkKy7daYqabn/LEMJ4hYVAy5c1bVnRf2EQ9EAH7aOlX1d+/twLfncG30c6n6nU4i2+Y93OEJQELyKJozGlpcQ//MfimNuasHOaQZZonumceOUuvX0Do1RZISmbkPhFWsQQOsJf49+TnF0zonKbrCRQ/vo3UdeoWHvY6Q7kzG4sRn/0/dnncts3fidShq4gk9SBVNqzI605fjj0mY
 nRRWIxpJ
 n5aX+bgtnoZk3ih/gFr+NKiWcIvAqNI863JMF3orasd5o7Ab8ZjJBTcWb/DqpDOVmxzZ/T1KunSPSa4KowXCsaZe0apZ/ykzsVmHiGLby9s22EWYLLQtXa9I6pOPgW1b4t5Ve1FlaLaO8N5q3k8Mj9lxp7fFF3exoIVXS96ODxRIH4R9As3+zcPPQy0pPN11rogvedxJiiJU6PqDRy4UCrPdIMsEG2N/YHCP2rUc/ohegQSe9vOUurRnD3YQ4frEG0UZxax4GE61Yzja/awCUHgmKBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 22:11, Thomas Hellström wrote:
> On Mon, 2026-11-16 at 21:12 +0100, David Hildenbrand (Arm) wrote:
>> On 11/16/26 15:53, Thomas Hellström wrote:
>>>
>>> Yes, I got that part, but that's is only for a single scan, right?
>>
>> Well, one NUMA-hinting protects again, you would get an MMU notifier,
>> and fault
>> again here?
>>
>> It all gets pretty unpredictable for these PTEs, no?
> 
> True, it does. But again, my point is that exact same thing happens if
> hmm_range_fault() is allowed to take the fault and migrate? Which
> happens here.

Yes, and the right fix is then to either disable NUMA hinting or to allow
consumption of prot_none entries -- like KVM does with GUP. The writable side is
the tricky one.

>>> We can't do that globally, really, for these type of apps. But one
>>> remedy might be recommending the app to mbind() with a no-
>>> migration-on-
>>> fault policy.
>>
>> Yeah, something like this. I mean, it's hard to see how NUMA
>> balancing makes any
>> sense here. You're just trying to fight the mechanism because it ends
>> up causing
>> more harm then good.
>>
>>>
>>> Also the hmm O(n²) complexity in this situation isn't really ideal.
>>> We
>>> might need to look at that as well.
>> I didn't quite get that, can you elaborate?
> 
> My understanding is that due to the migration invalidations
> hmm_range_fault() is restarted from the beginning roughly on each PMD,
> leading to O(n_pages²) complexity, although with a small constant.

Ah, got it.
-- 
Cheers,

David

