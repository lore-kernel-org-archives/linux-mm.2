Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45992F531E3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 03:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2EE56B0088; Mon, 13 Apr 2026 23:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B062A6B008A; Mon, 13 Apr 2026 23:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A43406B0092; Mon, 13 Apr 2026 23:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98C116B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 23:04:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29AE0889DF
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:04:54 +0000 (UTC)
X-FDA: 84655669308.14.F99CD52
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 60C6014000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:04:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BWCLoDKy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776135892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FYu2CGFYAk0qz0gN9Zhq63kXcX9UNvQTBocmoERSRo=;
	b=TRpAQcW9FrxpZjfBibr0MH1EGg2xC0qaCJgWkgW13yEYgE7kmbR6f2MhhaIj3qF5kThWdD
	Ga2xrAQHR2Gg+J0MBf1ASomaHrREXz3ayt2bB/9VkZRZnkb60l/Y4YtCku/PcNulQ/KPza
	xbRFknIoa8ozub+UCrTmf5YmT4t5m8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776135892; a=rsa-sha256;
	cv=none;
	b=v/Jkqr4Uk6elXlzQ6PzQ8J2fM4wiqMR+xYNx6GPB/vNHAtOOLlc+11JIvUO5tZY75X3a+W
	bDuqb2oU4deV2ZtpKG4171yN2CniaaE0J63UTXwmJCEuTalfdU3v6iOxuQmxq6f2kkX/rT
	htrlAA+JU8ZILi/zcVN5dykveWtus1g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BWCLoDKy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776135890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3FYu2CGFYAk0qz0gN9Zhq63kXcX9UNvQTBocmoERSRo=;
	b=BWCLoDKyxBJFi3Ak8GVKAz3mczB5fhYPqbcTIn1JLJPdaRGKuULfEgReV+W36aXs54UIbv
	N6iKcqxl/Jq+Aytf+mV9Vw3DB8IDAjq24brNkTJwfYetGa4OJz2ESJjTkIKKipP/I2cSLQ
	nvwBpt3fEMn40XHMClXyUhbDujjNcsk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 06/49] mm/mm_init: fix uninitialized pageblock migratetype
 for ZONE_DEVICE compound pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <42ba7f13-846f-4150-8195-32a775bb6812@kernel.org>
Date: Tue, 14 Apr 2026 11:04:13 +0800
Cc: Mike Rapoport <rppt@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Liam R Howlett <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ADD34ADF-76A9-4073-A15C-024DDEABB35E@linux.dev>
References: <adzvdRPrK55TutT6@kernel.org>
 <ADC5EFE8-454D-4B9D-8BB0-39FF671290F0@linux.dev>
 <42ba7f13-846f-4150-8195-32a775bb6812@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 60C6014000E
X-Stat-Signature: ibignwjxwftt39dquf8b7dzr6nymfm56
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776135892-972507
X-HE-Meta: U2FsdGVkX18zHVqw0Wdbbzy2ZF6nW9oRkFfctXbqNxpJ5OIBxBgDDnWWt9zOYxaWh+qQe1HpA9UHnTgydyz3rVPVo6mnDD8Dat/5hh8txdKbgTC3VWAU/QtdP5lnTGolx1SO0LARDiP8DfvPReYXf5tvWSLcBmiVqF2JVQvm/liM4VwEKVshxRbwCMcO7kTTMjLFe1CeKuRJPq4l9eHvuZALgKG5C4sxBur5wl/sQNkMIIawd+0U2RFVuhLKWauSJ/482osUCBYw61Eq0wf9fd9GHEye4jw81EumBjUVTjQLxR/0+fAfNNB1KC+N6UtXdWVdrnhfraZ9iyQCwN16PumQGc73UUUEhRhLvmeD6YiBQUKTdqub4dHyfrz6yKqZPScu9hR3n1suGvHw5b1C5OU1WCYs2FuZoX6qKgQKJSmhX6tPj2OTLGugycauJbqYl2iiCC3xHpK+R3sMa+sx7G31LShSwdYxtNs3m4rpQYNEYU7aDespxR0Tlf0jrWoTaBmQH5NDxjoUUKnyNTuhbgqLYgJdtRQyviuZ1bogNN29E9imaaGL+VocdBic3DU3g+EQ2SlBOl+8+XmGWMgRgG0lm8ZjMSpwsvrDb7PtfZdSbkVEm0yljXfNKeQ7+XoLeLd7EHj88Cgbpcz0juptp7KWwUslkhkjS1R0TE+3U5M6qmEKp7gA++ntUWR93/g7sgzciU44B9BKHJldw/rNNLQrsCO7YNgQzU/MQqyOtj4xncYqSGM3XfS1cFOnaJOjN+yJFCx2dO3HGHbpYt5qSmoBQxxjqa55RjZucF5U4er3x0xoWDAlosK5wBfo9WAlfAswH1YBKep088fFY3FnOH4RI9jgCXni4ounioJc9KF3pVzhPrGwJU+FxM5Nt8XuZju3T5B2k/9u2h8Q90fQ7xfV5EqLvHLSy4vSJD9rOraKXozV/HTlPwFirfqCQUVsHrusnCBX05A7sV8K87j
 BY6dvmlS
 QaeBuHI6UQRm2ldpmOoE/qrKGfuzqjhB35QOouS2XCBgGNs6Z7Nh8H6DMRuvUeQNDOCg/n1YWC6It0ABhNuWc46yKIpyYrPtr3y0F7rfa8TA8NZjEal8zW577SSnth6HMZstu+Du23neGmLNivNE2EDYuagWywrrW6iMI403GUm2sXeYvKeiFA6FUBM0YfUqjPAvGBqyYKb3Lc7vt+I+I02iffbjahoNbasvRjPdWE+7GisigYxMAdepID/qa5rut8M12vqPeDlvck+sWXrAkZb5ovxZ/vc+f0MubiQcrmE3KAdupMu9daWxyQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 14, 2026, at 02:50, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/13/26 15:57, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 13, 2026, at 21:28, Mike Rapoport <rppt@kernel.org> wrote:
>>>=20
>>> =EF=BB=BFOn Mon, Apr 13, 2026 at 06:07:44PM +0800, Muchun Song =
wrote:
>>>>=20
>>>>=20
>>>>=20
>>>> Of course not.
>>>>=20
>>>>=20
>>>> There are indeed many more cond_resched() than before, but I =
don=E2=80=99t have a
>>>> concise way to write it, so I took the easy way out.
>>>>=20
>>>> How about:
>>>>=20
>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>> index 2d680636b67a..d13a2577c4c3 100644
>>>> --- a/mm/mm_init.c
>>>> +++ b/mm/mm_init.c
>>>> @@ -683,7 +683,8 @@ static __meminit void =
pageblock_migratetype_init_range(unsigned long pfn,
>>>>=20
>>>>       for (pfn =3D pageblock_align(pfn); pfn < end; pfn +=3D =
pageblock_nr_pages) {
>>>>               init_pageblock_migratetype(pfn_to_page(pfn), =
migratetype, isolate);
>>>> -               cond_resched();
>>>> +               if ((pfn & (pageblock_nr_pages * 512 - 1)) =3D=3D =
0)
>>>> +                       cond_resched();
>>>=20
>>> TBH, I don't know if 512 is the right number :)
>>=20
>> I picked this number out of thin air. I=E2=80=99m not sure as well.
>>=20
>>>=20
>>> pageblock boundary was a convenient point to have cond_resched() =
along with
>>> setting the migrate type.
>>>=20
>>> Here we might be able to squeeze more iterations between subsequent
>>> cond_resched() calls.
>>=20
>> Choosing an appropriate number is indeed difficult. We need to =
consider
>> both unnecessary cond_resched() calls and scheduling latency, and the
>> specific value also depends on the current CPU performance. At the =
very least,
>> I find it hard to choose a correct value. Since we all agree it =
should be larger
>> than 512, why not just pick 1024? I can't think of a good evaluation =
criterion
>> or selection method either.
>=20
> I think in some other code we just use section boundaries.

It is a good suggestion. I'll do that.

Thanks.

>=20
> --=20
> Cheers,
>=20
> David


