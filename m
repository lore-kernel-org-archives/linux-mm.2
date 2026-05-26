Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A26F1CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A4D6B0005; Tue, 26 May 2026 07:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B8D6B0088; Tue, 26 May 2026 07:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B212E6B008A; Tue, 26 May 2026 07:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A17156B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:04:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40BD08DDF2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:04:12 +0000 (UTC)
X-FDA: 84809286744.11.D9BB25E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 75B0618000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:04:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BledWKOR;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779793450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9m0CLQDknfiAeneqt3PWBznhhNqswQZNkUNQRNSnDs=;
	b=mGHlv5ck+kegfp1XnisuzjK7i1ftv8DpfovnmQVrtYpCOpfCjhtjTU05WSQDBbwllOaQG0
	m710SLL2zuRQWbsUHeXYTT4SyOvUxlVaguREza3TkhqopLZEMjE/nIfEWRnEvBK90aCiAi
	fDD8xJhVmu//YqipWi69xliAMqA9HLg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BledWKOR;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779793450; a=rsa-sha256;
	cv=none;
	b=Ks/wPzSr/FQnx1SEn3ByVVIji5ajN+TbAg3SDkegxp1PeAYu4U7/7xUyF3TdLqn10F2wrb
	P3CVxwPSMzlM77pmfpU+QAM+9s0hjpvSXMudSGwPjMKwtEq6JDroX+hQvjHwZmY5LUmeK7
	SThSSOHYo4kgKNM4ozO0ecZ8lIep6tg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 79EA5404CE;
	Tue, 26 May 2026 11:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6F71F000E9;
	Tue, 26 May 2026 11:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779793449;
	bh=I9m0CLQDknfiAeneqt3PWBznhhNqswQZNkUNQRNSnDs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=BledWKORIsYZx8EQATerq2T2aQ/MISg1vd+EGuX8h30fyOjWgvrCRLDj5J97gJuoO
	 cnoR1BsHIiuJY5wjGaEnJ6gwcIdwB9U8gnG4u3Zp27KyKgjlkbaHN4PCr3EMlH8BQ/
	 +TyOuq6s0p0VXu35cN6h1cqlANcwKnqv/uWsPrlzDsGhwET7ajjDtJcW2dwNxycpXE
	 5oePNdUR7+BffCUcCUklRmzEcw+Ln/L9FEgH1t4ZSqT73lKUflFi/009nFng1qpdaG
	 owjLtt0sXK5rVvrbPNzkQhPG0VKjIPdthypS7xv3nydRK0Orm/dEO1a2IKq9Xh6s6B
	 vCucjzcqZrhsg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Alexander Graf <graf@amazon.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: always print scratch sizes
In-Reply-To: <ag9VrVW3E28UOsAt@plex> (Pasha Tatashin's message of "Thu, 21 May
	2026 19:07:47 +0000")
References: <20260519155324.2692594-1-pratyush@kernel.org>
	<ag9VrVW3E28UOsAt@plex>
Date: Tue, 26 May 2026 13:04:06 +0200
Message-ID: <2vxzqzmy4el5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nqtboucsytwnwogf3nse17xmqcuro1ho
X-Rspamd-Queue-Id: 75B0618000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779793450-356478
X-HE-Meta: U2FsdGVkX1/bV+eYBIbPDQYbwZmf5AC3zTcKmBIrqh2lWR8cyoU5veEJX4VkdrylKiyw/kQfPvU8tRLKhwDFoxksuKL9B1D9lehkE1RULJP+SYGx4KchhBhh8YG/mnpWo+yeftDG5rYiyLssIMe9Slc3ysoNmQsaFV2k4FIs6AqI8bKqn8+p7eEvjAt8LxpdeJ7KO976GtEUGAKrUSSJKQRlcP9HI7CsvGMWCOC6DqOEkiCgq1Mlt5M4xPR0p5AWLFe/AfwGmQuvimthTJl40Phyfj5RQ0aTKbfR3gJUSXBhUhux+zdCwyrNynhJ2zpljo65HdacyCzWuTJjfkEuivj8IImNGZyDHo7F11sitqQPH8f9oT4CXCq7CN5mMbxG+FJTNC6GSqGz1t7Hkn5PLmti8aLSmBe1yltjyh1r7LNEo4rzRJGLoQYVFTo+leAY635HDSV+Ek5UEJ5K6o8a2hKd3BqTtI8WJ2zdf8LNJMy2fROmY3Q8LRZ3fkoiLu6YV3gVwvRqC/6SF/2qIqLZ8ruIml6WT3bGe+nNwUAgAnnK4jBGdPe6U4OcRLvU4LXKohcaDu2+Z8yqO2Zyin4btSCgF0+NpHR+tKQsM/mK+wGg6Lydqq0TYVjb7AQKsrAXM7tQtgHqE43svMu4dwzUx3Nn/fm6/Fxxes/CqGkEZBBFfpInubxwqOlVKKC3rXUrWhbe4JcpnK+SBkdLhqvizPNqfMpcDfevy+vL2ldsZFQnuZDarIZ/7oOPoMqJH0l8pPggujDc3Sw+PrBeT+P5zA7SSFNpStFvlSKs0lgXOMe82dQe9SyoUH5K2GNcbcl38V/g8658KE+EHYo5vBIRXjuJI4modCC7EK9GoWA7SKBP/HoPD1P9UG3XuRyCT95mIynjHjsxCt93y36KLTTe64jUCqocPR0drn9TST6Aisa4qWQ8YJ6GoUNeTvvrsJa0hW0TdHwlkySB9wbieVY
 Sey4rGtj
 oRvx9QWavcRNRIC+v/zZoqbaKae1K2tFnJoF59gL0ARMb7BWUgzlLUiCPN7d16Xzx44qVCz9KxsLAwW7JW/2+dY27fMePkn3AP8LGKZenF8rJ2d0/KqC0G1YRLNne3V7PeA638Q+HKCBPobELUTxk4abe5NjCChYtSpH/IMUE0ZFEVOgN4ns9X2Tk75BJYOX9vOVY2zcM0ma6HpIcbCnDHrttDQHkTo/Gab9za14LGPH9vOQWMYDybPVq9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21 2026, Pasha Tatashin wrote:

> On 05-19 17:53, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>=20
>> Currently, KHO only prints scratch sizes when the size is specified
>> by the command line. It prints nothing when the size is calculated
>> at runtime by counting RSRV_KERN.
>>=20
>> These prints are completely useless. When the user specified the size on
>> the command line, they already know how large the scratch areas are. And
>> that information is readily available by looking at the command line. It
>> is a lot more useful to know the sizes that are calculated at runtime
>> since they can vary by kernel version. Plus, if KHO fails to allocate
>> the scratch areas, the calculated scratch sizes are not available via
>> debugfs.
>>=20
>> Print the scratch sizes in kho_reserve_scratch(). Do it before making
>> the allocations. The size can provide hints for the failure reason.
>>=20
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexe=
c_handover.c
>> index 33fcf848ef95..b030f53f2235 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -621,11 +621,6 @@ static int __init kho_parse_scratch_size(char *p)
>>  	scratch_size_pernode =3D sizes[2];
>>  	scratch_scale =3D 0;
>>=20=20
>> -	pr_notice("scratch areas: lowmem: %lluMiB global: %lluMiB pernode: %ll=
dMiB\n",
>> -		  (u64)(scratch_size_lowmem >> 20),
>> -		  (u64)(scratch_size_global >> 20),
>> -		  (u64)(scratch_size_pernode >> 20));
>> -
>>  	return 0;
>>  }
>>  early_param("kho_scratch", kho_parse_scratch_size);
>> @@ -691,6 +686,10 @@ static void __init kho_reserve_scratch(void)
>>  		goto err_disable_kho;
>>  	}
>>=20=20
>> +	pr_notice("scratch areas: lowmem: %lluMiB global: %lluMiB\n",
>> +		  (u64)(scratch_size_lowmem >> 20),
>> +		  (u64)(scratch_size_global >> 20));
>> +
>>  	/*
>>  	 * reserve scratch area in low memory for lowmem allocations in the
>>  	 * next kernel
>> @@ -725,6 +724,9 @@ static void __init kho_reserve_scratch(void)
>>  	 */
>>  	for_each_node_state(nid, N_MEMORY) {
>>  		size =3D scratch_size_node(nid);
>> +
>> +		pr_notice("scratch_areas: nid %d: %lluMiB\n", nid, size >> 20);
>
> Please use a space instead of an underscore to match the other string:=20
> "scratch areas". Keeping the prefix identical makes log parsing and=20
> filtering much cleaner.

Sure, will do.

>
> Unrelated to this patch=E2=80=94this is something I brought up to Pratyus=
h off-list,=20
> but I really dislike the 'KHO scratch' terminology.
>
> First, it isn't actually 'scratch' space, as the kernel relies on it to=20
> allocate crucial early boot memory, which it then uses permanently.=20
> Second, we cannot preserve anything within this specific region.=20
>
> Down the line, I'd like to rename this to something more descriptive that=
 clearly=20
> conveys both its importance to early boot and its non-preservable nature.=
 For=20
> now, the print adjustments themselves look good.
>
> I do not know it should be, but something like kho_bootstrap area sounds=
=20
> better than kho_sratch area.

Sure. I think we can land this patch now, and then update the string
when we agree on a better name. But I won't mind waiting either if you
want to reduce churn.

>
>> +
>>  		addr =3D memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
>>  						0, MEMBLOCK_ALLOC_ACCESSIBLE,
>>  						nid, true);
>>=20
>> base-commit: 34e8f02817e31826e76bb2ded48bf28fe921f20b
>> --=20
>> 2.54.0.563.g4f69b47b94-goog
>>=20

--=20
Regards,
Pratyush Yadav

