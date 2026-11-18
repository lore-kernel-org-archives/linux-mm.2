Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B18C606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iKjr+C7C
Received: by kanga.kvack.org (Postfix)
	id 2453B6B00EF; Wed, 18 Nov 2026 00:57:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7296B05B0; Wed, 18 Nov 2026 00:57:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E626B05B1; Wed, 18 Nov 2026 00:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2F476B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:57:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F056806B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:57:46 +0000 (UTC)
X-FDA: 85447183332.11.F787A27
Received: from mta0.migadu.com (out-152.mta0.migadu.com [91.218.175.152])
	by imf08.hostedemail.com (Postfix) with ESMTP id 01F35160002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:57:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iKjr+C7C;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794981464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3yfKxLMhshtB+2F037xrAWVe+vfR0qbY5pPO7nGzJOw=;
	b=ZJ13LUCMpAjVZiPrNeHKpZJDYufeIxI2g2lIqevP6f/Sv98DVOFOeOYtrpUkoD89G6resx
	fSoTGZfv/Ak212urTwMDr+2RkC8vL1EhqADuVyhNBtmBHdnLM6sLGcxFKzAWwjHgU5PaBM
	y/ZGWirLhzmM/kFabnCB4JixPu2Gk1E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794981464;
	b=v3QWarkUX0JeMdcsK3qKj4R9Ba/L3MELmPRSnxmOIYqYeVFMczi+lYSOUSdL3TPqYbIFEk
	hEWkkDCeiciqM5FnUJfSWA0oVQSym165KkqBFvnSnjizkCVpszkrhqPiXsJUT+bG9u9PJ6
	SWKzKMEvm4NOMpeaKGIbu4wAwETzD6o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iKjr+C7C;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.152 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CngAOLNog5Y81sTkiyw8e14TFkRjTahcSus0NtRjDsw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794981462; v=1; x=1795586262;
 b=iKjr+C7C7MWxyvw7hph2+mQoCrtgkToPKm5PmEsUGzXaKVUTD3w+LKhaFJdVBXsqzv+Gsdiw
 /RVl2gpqY4Hh+X+VEADljcxXK4s2Rn1HvGW9tc14j92lD5zjxkEPNg+LMaSLj8D7+TOPjJv6tY9
 ReczpWTgCTA4av6UJ7R6Zx+w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9c6dfb37f04a2a11;
	Wed, 18 Nov 2026 05:57:42 +0000
X-Mizu-Trace-ID: 9c6dfb37f04a2a11
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261117215129.d7bcc7bfa060daf99828f0c0@linux-foundation.org>
Date: Wed, 18 Nov 2026 13:57:19 +0800
Cc: sashiko-reviews@lists.linux.dev,
 Sashiko <sashiko-bot@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 Chris Down <chris@chrisdown.name>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>,
 Joerg Roedel <joerg.roedel@amd.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Pranjal Shrivastava <praan@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Mostafa Saleh <smostafa@google.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 kasan-dev@googlegroups.com,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1DAA3861-ACC2-4D76-AADF-13F454E8E49A@linux.dev>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-3-songmuchun@bytedance.com>
 <sashiko-outbox-219498@kernel.org>
 <20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
 <F4EDF1D2-D02C-4339-AA30-422D576B735A@linux.dev>
 <20261117202136.9eb67013389f3bdefe9b3a15@linux-foundation.org>
 <11DE08A1-5F83-4BE2-B8C0-B426441A957A@linux.dev>
 <20261117215129.d7bcc7bfa060daf99828f0c0@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 01F35160002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: zxrj1ksjkmdegafaot1eho8u7fqjjwcj
X-HE-Tag: 1794981463-561398
X-HE-Meta: U2FsdGVkX18ionUBB41CM/iKl7gjmpZjVDk4Ym2VByeT4K8i3Dt/pdhRnpGkEsem3ovotn2GxQnhhRoo9TpPMaNjeO8/xSDFKOc7V5daK6K+od4jUc94FLrN8vTZ67MMGVfg2mirvrqY2/Cb7Vlv+1qVJ73bChESCPfsh1T9E23qtNdcXgHjJfpqTkGEErvW9oXUpW31gL6nghEMsDgwug2smCJmPl0y9uoLN7/8jJM17kD87FlN9v1BBVfpT3LLYcwVXWXCpjy2t7r7Aij/8uW/l+fTNEYetH98S5m862nc1OvZDBKVxS5pm3UvELN6zVLOzLJ182n/MFYmifqv4L36v2HolXMvLXc4fCnSgN9EBJJHHV3YZwvHUR+UfFUGk2guDnEo2XLnQ+ZfPwuZhpvhOFaeBS7lpFzGFtmNf3amuhlcaFR6jV9/0G0z6//2Mtg6MH1vQhqaiELwm//oE3pH9tVRSv5vmIwGoEZZJIYP8GkzPUJr3nd3O8psBCWDnxiG8s6bBkeHuD/df7cwl1BIDoGLVE1d0LA+cZcyEakimGRcFoygBV+YrtNhTK5aN7z+O/l4thkNbgrGl9Eqib9bCh9+p4/WhcuCvsVxn1QTXW/TCrsL54fHWomXeRW+CLMNeqeJ+K2Yi5N64ivm4bBRLTBaCCSX+QTEkf2nKhhQTzux/Fu62mZvJBcQJPQAtnF4lvpeqtcPEpPYzWflZvAWwLzyCY/CsavNP5Y3uKMw9S0aM0d27QbUFQFdHfMhP059zZgwrR/XBBWNu3OUWQaYOUNqI4ZNPMPkb1qVjFxdTRwKCfJGqkBdLQJbFrsJMmmGffaOYEe5fj6qFcdmEJv7YeRtkzRm5DzawKSXzwGeT/mdwHFfoIIH78x6oTAriCA2HEUbQ6x/Tzq0OOhReJ2Pw6DugdsLSxCuuQkwBP1gJfVmybvIaiBW/94PpodfLzNOWOdHXLJmhQYFVZJ
 f6v6pi5k
 hvwF9eqvC/UatYY60nwUmpaOFlgYGbUf0g6arsuKXYE8zMaOEFTEl0haCCwqrI7JAHSukYD536cnIom5XjSjmEa4HqkbbBuVcHcWFlVFREMG8+Uwe24CKbVt2ldyYmKerLqvlSsXsazIzeuNGvd12P+UlqQGYGLNRGglmHpiUJIrQHaqfJdJzvWxzC60lrqJ2p99C/sfubshOguuEsDioOAX3uKkGOjOVZ1OcbTNMYMYRpmyHqOJANQbSz3wb7xb3HiLB0ZfJN8pcp28VOJet6d0a3y+169/ho9V5Gq+05YIE0pdzVeclutWThD+hb/XbWUA0QmfHZFVa5yi8a+ueVPkElClObg6xzm0s+YNrzVq+TrdKbjg00zsgkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 18, 2026, at 13:51, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Wed, 18 Nov 2026 13:39:04 +0800 Muchun Song <muchun.song@linux.dev> =
wrote:
>=20
>>=20
>>>>=20
>>>> Something like?
>>>>=20
>>>> static inline size_t page_ext_data_alignment(size_t size)
>>>> {
>>>>       /* No client data means no alignment requirement. */
>>>>       if (!size)
>>>>               return 1;
>>>>=20
>>>>       /* u64 has the strictest alignment required by page_ext =
clients. */
>>>>       if (IS_ALIGNED(size, __alignof__(u64)))
>>>>               return __alignof__(u64);
>>>>=20
>>>>       /*
>>>>        * A type's size is a multiple of its natural alignment, so =
its
>>>>        * lowest set bit is at least that alignment.
>>>>        */
>>>>       return 1UL << __ffs(size);
>>>> }
>>>=20
>>> Well I prefer it!
>>>=20
>>> The final bit-twiddle could be (size & ~size) but I'm not sure =
that's
>>> any clearer.
>=20
> err, (size & -size).
>=20
>>> We should have a handy helper for this operation but I can't find =
one.=20
>>> max_pow_of_two_factor() is close, but only works on uint.
>>=20
>> How about changing the helper to
>>=20
>> #define max_pow_of_two_factor(n) ({ 					=
\
>> 	typeof(n) __n =3D (n); 						=
\
>> 	static_assert(__same_type(__n, 0U) || __same_type(__n, 0UL)); 	=
\
>> 	__n & -__n; 							=
\
>> })
>>=20
>=20
> Switching max_pow_of_two_factor() to take a ulong should be OK - the
> thing only has two callers.  But oh, that name!
>=20
> But do we really want to go there?  The drama with min/max/min_t/max_t
> and especially clamp has been endless.
>=20
> Your open-coded bit-twiddle looks great ;)

OK. I'll use size & -size directly. I think the adding comment could =
make it clear.





