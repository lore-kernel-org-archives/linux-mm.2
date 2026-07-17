Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C86C44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 04:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206EF6B00A4; Fri, 17 Jul 2026 00:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DDD86B00A6; Fri, 17 Jul 2026 00:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F67A6B00A7; Fri, 17 Jul 2026 00:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D324D6B00A4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:10:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4841280402
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 04:10:29 +0000 (UTC)
X-FDA: 84996941778.03.50CE219
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABAD120006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 04:10:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwm843R8;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784261427;
	b=Y4fqeOXV1LVJKE1AsDPG5fGul+hWEnHDmAQEnLs2Oer2lpfATcckA4QgAvBHR2zJNM5LK1
	G5MYPCX+ERI+DKRRtIqCUAlCal5iObKRgt0BRzyolcs4ElIgpUOZDaQ2zk078dNF0EqyFF
	v045VKP2YulaV/oTUy3nhVUOz1TwEdA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwm843R8;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784261427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBPsEFnIuINeb0d59jQ1pc/qimL3dI1SLr0HV/mChCo=;
	b=F+6f152fUY+QTkRewW19T4e9beFO4fPQkLaInQfLcPfkxUG03slayR7Nkpebu/cSRS0Qct
	REtwc+ZEeisLDTqgkQkdsKOzXrJ1aFdqnUHC6Ea1lcSTUenRDjjUR+8ecSDD9Dyuy1X67W
	DVwyWrTI/u1hsyu8OX6mFq5YP6X59r8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4260060204;
	Fri, 17 Jul 2026 04:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890781F000E9;
	Fri, 17 Jul 2026 04:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784261427;
	bh=oBPsEFnIuINeb0d59jQ1pc/qimL3dI1SLr0HV/mChCo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fwm843R8EAtmzMgCpNAb3HbQdaDm9xpvY1IofxPb/8JC0UPXydHIHZetqSltF96qB
	 kleWY1HtyfQmwglzof3U/7KmjqZunJreeG3WcXqDb0yrQiYZ67pQ6095B5NuVXdLWg
	 57En1oGbgPZplni+H83IHT1WVT7KuQW2Rmu8YOzCOYsrN5w7o0U+x2iAAU9bD3vAjr
	 zLjTEbr2tEtIhQGCcQHX8TPVI6Pp8YNEZ9tTvtqZICyy/3siJv5dfAJ9yjRBYgnH3/
	 Cu+OtiwKnXcnhBy8kuvQnm2mrNpFbI6XFM2OTbzyBX89rSaUmPp1wDVZl1DiOb8/7W
	 Ia4X2yCmFauZg==
Message-ID: <2bbebbfc-fd00-4744-9775-5ba35788b535@kernel.org>
Date: Fri, 17 Jul 2026 13:10:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <alkypcRUZa_r6uGV@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <alkypcRUZa_r6uGV@linux.dev>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------97ang00oLjr0Br0NqNg0s6nx"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABAD120006
X-Stat-Signature: e387qch7iwxzu5u8u1o9wo3jeczk1es1
X-HE-Tag: 1784261427-2304
X-HE-Meta: U2FsdGVkX18CM5KVhMky+2IAzas30KGESQJreQUZV4GImUAF1I4hSVv/BmRPWb7xYN0E0U12TqomaDMsQYD3oAuVm3UqH+I+SzeDFYIKMvMcjDj55fMPfGgDecUHf0bfqZJLJnVXtSUk09WNHzRsp7bIdBmb0Cr9i4nEnQ+ooKXG86x4MNZi61Wowig53Bxy0ewKOY4XD3GMHROrSBPRCKWW9zy+986fQTG3zgZ/au0VVkzkVWThmtMnwF2OJnMjg9NWJoor78/hAVU/XvfnGM2OjTT8nHoq9xr6A+rx5OgDtSpfO/X3cB3JIG/ZKTeM4bSuwstXtoSCdFd5l8Xp/M0s+yZlBh/CmrMCq2j7nDTL5AbCSyklkPKxNGu2cOYAJMIPYtN3CocNi35//xASfEIeMQ64bFIlaJdChhZImXz7uUy9Xorxu3+hooXzokxrXSSWEskJUwul2KnnMwQ/31vFI8Xai3QklKsKYzntPDwvYzbPLiFae41trUF6hgQfaD9gcdbK9jbio5U3mcqsJfrZg8ihV24M6Mth66maCfvzekQrznFG1R/GzEdN75Z1SEkyujEyU1IGBKJvbmAwMLcKLx4hhqC0OEFauWqNx0hzFFF5V6jwmVV96prcHjBuKRM1QBkOmdheAq9wc+AK4/lJQbSPMgj5rq+wUfEdQhwT+it2MKd97r9RHsn5PVb+G9Sobo8FEJ++8Ak9MzHFtHpOjLzg36e8gO7gD00jxXL73alln6q6Mjuxp+JW8MqIjrubeasI5DmVf7USAMoShNpLKhM/1Ed1TSftynWJJWHT83LQG6wdkKFoT8UDPl0WW3rvS6TbEemxRXnUCDHKIH1WbW0UPSVdWmZ6gXGR0r/6GYSopOC+F8dgp04F3DtkDhvZlbA056ngt3sXCiwxDHD3aNXu1aFrBdQOicFMDfUfuLJrV0OFgZkQKpnqbneut2fQz0eUTZbsAHTzDLV
 S5S8GOvh
 O9gKLBIUw8oTqnmmZrJ+F9eZ2Z1WqHDOTT2yLMNb/RSk6NKl0oWkT25mBNj3oaR1gvT5cJFrGX+04WsIdocrDmp0YK3HNa6HyBTWc/4U07cD7mO65VkDJwvD3euKqEZ9Va7X3hq4cBFseqXML8m3blWoL5iZZB7ICv05Hiw8/l5GD98yob0Qp89TergvmMpKpvejGOOwDLwUUU80bnIvuG94WXtXMM6ZjdLDWN4PYX167BhYfTYxgfkVyidxikh3TbqAC/JfI/LFNsu2mvq9R57vece+gNI7+cV6X2Ol0Q+V9QnfNL4rNrloTli4xOIzURtgWMgtTFDXO1WH95aq5joNhni/ps2+6Rf55xQGt+Whp+Al/p2Ew2W7A2ROrgV250rcO1evSW4N63vktDHGvYaXK2crFPrUn4RTkp3PVszhxytq6qHZf6qowV1LaKOzKIJiCcGnuZONucYIg/0fHJkJ8ncTwPlSBDvBoU+cr0BaY9YGTWKx/ZC5V2t4uLkGSDZDU3eazXrJ5elyB5FgMovyykpEmzWa4BKu0bx57xhp94QM7tjzAezc13xA9JFAZnfA76SKVUnKmw5CcCfmG9YoTw6N1i/v1WtWwHm1Fc8gRzpYqzFjgHGg1P8hW7hWNPSgTKv0JSQWh6VTeUz3LXWTfXYaC9fQb/ARPur8yy4IL1vzGmbrCYpY/suQqB6TvjtVeXoRVkcv6h/t1Agyt1gmfq9WjUDxmm6uY+vHriO+b7g1KNx/VuF5DEzDzY/jHc/vt/SsIUgZsgFtkC+93nxhs0Q6e/7IjFzwz2y5xDtaizqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------97ang00oLjr0Br0NqNg0s6nx
Content-Type: multipart/mixed; boundary="------------g0b90MwtWS09GVit4BpsCzPP";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-ID: <2bbebbfc-fd00-4744-9775-5ba35788b535@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <alkypcRUZa_r6uGV@linux.dev>
In-Reply-To: <alkypcRUZa_r6uGV@linux.dev>

--------------g0b90MwtWS09GVit4BpsCzPP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 7/17/26 4:37 AM, Shakeel Butt wrote:
> On Mon, Jul 13, 2026 at 11:28:48PM +0900, Harry Yoo (Oracle) wrote:
>> This is a follow-up fix after the recent discussion [1].
>> See patch 4 for the detailed description on the bug.
>>
>> Based on slab/for-next-fixes (af9ea231c0b45) and is available at
>> git.kernel.org [2].
>>
>> Instead preventing cycles by bumping up the allocation size of obj_ext=
s
>> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and=

>> disallow formation of cycles between kmalloc types when allocating
>> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
>> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all oth=
er
>> obj_exts arrays are served from normal kmalloc caches.
>>
>> I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
>> KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
>> sheaves for those caches. So I introduced a new slab alloc flag
>> SLAB_ALLOC_NO_OBJ_EXT.
>>
>> To avoid huge confusion, I had to decouple "disallowing sheaves"
>> semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
>>
>> While this cannot be directly backported to v6.18 and v6.12 due to lac=
k
>> of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
>> particularily challenging to backport it. Instead of a new slab alloc
>> flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
>> kmalloc caches don't have sheaves in v6.18 anyway.
>>
>> [1] https://lore.kernel.org/linux-mm/9a139365-28e6-4f1e-b35b-7f6091e9a=
a14@kernel.org
>>
>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/lo=
g/?h=3Dkmalloc-no-objext-v3r1
>>
>> To: Vlastimil Babka <vbabka@kernel.org>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> To: Hao Li <hao.li@linux.dev>
>> To: Christoph Lameter <cl@gentwo.org>
>> To: David Rientjes <rientjes@google.com>
>> To: Roman Gushchin <roman.gushchin@linux.dev>
>> To: Suren Baghdasaryan <surenb@google.com>
>> To: Hao Ge <hao.ge@linux.dev>
>> To: Kees Cook <kees@kernel.org>
>> To: Pedro Falcato <pfalcato@suse.de>
>> To: Shakeel Butt <shakeel.butt@linux.dev>
>> To: Danielle Constantino <dcostantino@meta.com>
>> To: Liam R. Howlett <liam@infradead.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>=20
> I tested next-20260716 which has this series against next-20260707 whic=
h does
> not have the fix. The reproducer were able to trigger the leak/recursio=
n on
> next-20260707 but not on next-20260716. So, you can add:
>=20
> Tested-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks a lot for testing, Shakeel!

--=20
Cheers,
Harry / Hyeonggon


--------------g0b90MwtWS09GVit4BpsCzPP--

--------------97ang00oLjr0Br0NqNg0s6nx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalmrLQAKCRCGXBN6rc5S
1kPKAP9TFo+AR+6tDlg03GS/N+FoSzBpaviqFJvipbg4oFlZxAEAtZLu/EoVUR9r
MAnYJRYMCx8C8PuV8b1HVe2BQM9DEgY=
=OwA8
-----END PGP SIGNATURE-----

--------------97ang00oLjr0Br0NqNg0s6nx--

