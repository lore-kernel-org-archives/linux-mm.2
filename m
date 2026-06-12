Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A06CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEF16B0088; Fri, 12 Jun 2026 11:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396FE6B0092; Fri, 12 Jun 2026 11:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4166B0093; Fri, 12 Jun 2026 11:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 218486B0088
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:10:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C050EC04BC
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:10:32 +0000 (UTC)
X-FDA: 84871597104.20.E1FD0A2
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf17.hostedemail.com (Postfix) with ESMTP id A092340005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:10:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ewMEzuCT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781277030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51hgMgSJtrgvkUbKDUHJEqr1K8Hb4cZzs3NFg+YtaPY=;
	b=q3oIIMVzXUbzRpFgDnp6TLbgAQpCdTSBO6zN1PnP95LdCtkEJYKTq1EugTVnmiLWTCGc6U
	ia6agGZ3/Vb0uPJgJ42UWe6YzivR1k1ggTZ5Fto1klqx/KB/lLN+BtgZN3ELX+5E0c0TlU
	KGh5a+yuntQdOUw9VLUmBhJWosiyrdI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ewMEzuCT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781277030;
	b=iR0vX48BrdAox5gzGnLBm09QQMg18fcvFac74S/vJArerRk/kKZqScGr+EWNs76xnE25bU
	eapPw08E9Rs7Rlc7qv/IkSY3FvFSlvhpP7fDjPlSP+zq3BpqLeh+QgQcKhS3xy22dsEhga
	o7KJguNfLVJ+/FmdP9up8Jx9cODj8Y4=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781277029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=51hgMgSJtrgvkUbKDUHJEqr1K8Hb4cZzs3NFg+YtaPY=;
	b=ewMEzuCTQHXqNIJMFgxGOGXsRO4rKRytksObryGm8pu7kyyHR4jv4RY6gDThZnQ+gSsVua
	69LwC1DtkhUGRaQqjRL8Szgqv1b+RP3/PlH0NfMzVoiMz0za2xJd2TtrVDD/o2bEucXSK0
	TQNbmyEqOAGyawnDJWQ/XBLZey8Rr5M=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 15:10:18 +0000
Message-Id: <DJ7605JADQD4.26TWN86L7IJJD@linux.dev>
Cc: "Petr Tesarik" <ptesarik@suse.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 <linux-mm@kvack.org>, "Brendan Jackman" <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Zi Yan" <ziy@nvidia.com>, "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260612085052.59291-1-ptesarik@suse.com>
 <DJ6ZMH9VU0BE.6Q8EHJIL65DW@linux.dev> <20260612133155.71958e80@mordecai>
 <DJ7549TJF9I5.O3K9X2TP8VE1@linux.dev>
 <34223C0D-B52D-41D4-AACC-943A4BEB3472@nvidia.com>
In-Reply-To: <34223C0D-B52D-41D4-AACC-943A4BEB3472@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A092340005
X-Stat-Signature: zptxb7pohb9refkc8ngu8efcact8o4y6
X-HE-Tag: 1781277030-410368
X-HE-Meta: U2FsdGVkX18omKtZLCM6hGTPhBxWc8o1D6iHqbsR1tbJw0AavU5Rqixsqs7C8a599EBg9mb0GumedcKZY1Pj6GLfbYCHtFuSCVu1K6Xv63RALBvLTVtFVfBWgM/ZzRBR1MSRn6/v3c+9PPyT6e10geuBYZ99vwXFtBc/19D1djSSZIxIV1krqQr6VYx8NNnd9eagmMUqUNfgK34Ee9bWcuOFc+t5Z4Lxz5upuKBFmvY4fn6sUdpl/+sCWjOw5cJqx125EyiZUWewpkcdXJqQk2NKKNZvgTbe4UPRgb5nFJNPZL8ntKaqtOVBS8WGHg0kQ+PxTQ307JeMUzVMMgW4xQmiOG3BYHrrTHSO2INBS4zhGsFTlYrRsdQYadHbvqRTN3dLw//gWSzlWm3g/hQmkIP/gtILu0Oca9OfpRa0RCmK2FiSsI6tRhLGEBL8GiRXHmkrj9DiJ/K98tgOd1j8WZIRp47dbSOptymhAqnXXBM2zZSWh9+aVuZ6wZ5kNG6o3e8kVnUsVW49L0tUHuYJV8XS0iGlPV/VdLtA2cONXQN2RmoXL3P/ayoZOn/ZbfvBSPiBuZQ57kA+iEDuviO8Mc1qKpiVg5dAHL+WlC+3HFrYiWoJ5xPiv94YWM0DO1nfeaCh35H6G9DIr9d/adRaUh7lhfKf9dTdprV8qseDHQQo+7wDHFlM9g6a11yjWcQXD1btMIr3YZ8Aj7xAADIX18NlUlAIhJ6R/adgmMMu2+IFwKX3p+PpEKJGqR/CVIp5PmQ9hatIm53yiXomtmdJ8RNqhKxCuEr3GuAK4cZMjBRdIsSABM75URbK4lTvuqyAZVlSqrus60xJGtiTtHpFacAp6BJ7DOqfT7vSpMJL/OYRRLa8jLH5kg+QkrIWfkowxbGGFBrmZenH0pTSjycCnSQ+CmmBC4oCqmb3/2KbXv7VjSXMYZ61HFHqWtGSWnTMroe19mGlT5keducCYyX
 Ammxk4sm
 pKKpfr0whsrZ3+vRy0n+qkC/k57F/ymCcY9/vYNRD7FmuMouFIOL4YIfKnDJ7+uPYllwqO8uZo9f6hGpX8Kr//r5n+9j1fDwS7HYhg/VamdsvRFcLupExNE0JuWrZvguCqOl7CWHx8C/0Cjef8s5N/yLn3vAWgONFyxFYFIicKordTaoLNXvDNbHkHV7fmKBQWn9ahLtakyJ3VG3HcsZ5QAvQz/+fC2TiQ/swy6v1k1Sh+w5Cue9m2d4dta7I5gmTBMO8cTKrU8hBSX9EU8faY+IcDBRcBHHyMoL2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 12, 2026 at 3:01 PM UTC, Zi Yan wrote:
> On 12 Jun 2026, at 10:28, Brendan Jackman wrote:
>
>> On Fri Jun 12, 2026 at 11:31 AM UTC, Petr Tesarik wrote:
>>>>>
>>>>> - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
>>>>> - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
>>>>> - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
>>>>> - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS
>>
>>>>> --- a/mm/internal.h
>>>>> +++ b/mm/internal.h
>>>>> @@ -1373,23 +1373,24 @@ static inline void mminit_verify_zonelist(voi=
d)
>>>>>  }
>>>>>  #endif /* CONFIG_DEBUG_MEMORY_INIT */
>>>>>
>>>>> -#define NODE_RECLAIM_NOSCAN	-2
>>>>> -#define NODE_RECLAIM_FULL	-1
>>>>> -#define NODE_RECLAIM_SOME	0
>>>>> -#define NODE_RECLAIM_SUCCESS	1
>>>>> +enum node_reclaim {
>>>>> +	NODE_RECLAIM_NONE,
>>>>> +	NODE_RECLAIM_SUCCESS,
>>>>> +};
>>
>>>>> -	ret =3D __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >=3D nr_page=
s;
>>>>> +	nr_reclaimed =3D __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
>>>>>  	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
>>>>>
>>>>> -	if (ret)
>>>>> +	if (nr_reclaimed >=3D nr_pages)
>>>>>  		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
>>>>>  	else
>>>>>  		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
>>>>>
>>>>> -	return ret;
>>>>> +	return NODE_RECLAIM_SUCCESS;
>>>>
>>>> Should that be returning NODE_RECLAIM_NONE when !ret?
>>>
>>> No. That's the thing. Before my patch, the return value here was either
>>> NODE_RECLAIM_SUCCESS (when at least nr_pages were reclaimed), or
>>> NODE_RECLAIM_SOME (if less than nr_pages were reclaimed), but the calle=
r
>>> makes no distinction, handling both cases in the default label of a
>>> switch statement.
>>
>> Agh! Sorry. It's good that you are cleaning this up :D
>>
>> So in that case my question is: is it intended that we call
>> zone_watermark_ok() in the case that we reclaimed 0 pages?
>
> It seems to me that zone_watermark_ok() here is trying to
> confirm the number of reclaimed pages is enough for the
> allocation, although the return value of __node_reclaim()
> might be able to tell the same thing like you suggested.
> But nr_reclaimed >=3D nr_pages might not be equivalent
> to zone_watermark_ok().

Yeah but in the more specific case of nr_reclaimed =3D=3D 0, would it make
sense to assume !zone_watermark_ok()? It doesn't seem that important in
terms of behaviour but I think it would be a clarity win.

