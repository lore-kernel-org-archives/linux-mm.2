Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E27E674B5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574366B008A; Mon, 22 Dec 2025 10:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E2E6B008C; Mon, 22 Dec 2025 10:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472706B0092; Mon, 22 Dec 2025 10:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37D356B008A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:00:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0154616016A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:00:46 +0000 (UTC)
X-FDA: 84247418934.18.7771281
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2B0F040026
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:00:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lv/By5z7";
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766415645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYNJ1FFphn1hDAp4esv/mZeqnPPMjHrPEnd9wXzNPj8=;
	b=6SyLU8TlAmFa/HrIxqcAFG1fE68KGMEXH2Wi0O1pKX5EEYnQSb3VK+DHwL2MDpMvaf9kWm
	ngjNmLwcbiOi9M/sf6IMkrM6QK6o19yM+gc0FB0LGWk5vr7e9YafbZWK3WiGXMWwoFgt4m
	ERNHgsVpK76ZpVbeSKbN3dd0B3uNE5c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lv/By5z7";
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766415645; a=rsa-sha256;
	cv=none;
	b=ZfDDrNVvhTcdXJp+KDGa73To6ZfAprrJFzXDEoej1AcbB3j5SFr9u3lvXAb4EYgYfXhtEf
	g6XpwYnYLqinp1e8dZOKJplpUouMyl5zNuF/7NaepljyScJgf1/aHPASh/2JXFBUmMciiA
	k6t022e08YE3CA+zqWaoUoGfpLSKvgI=
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766415643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PYNJ1FFphn1hDAp4esv/mZeqnPPMjHrPEnd9wXzNPj8=;
	b=lv/By5z7LAZ/ISpNYmcTJUIVpvU/9WOi8gm4yqOFv7IYK3WfprOjE6oQ4irrQsWN/T+rFF
	ntvfvoRlmOh6ej5FNvLjCCRFWrHW+u0+SJnjhjunYAoey2X8qbZ0A6rHItUOd7EDDCXE7c
	dF/26og/bzo0V6su3Qipk5/FuG+61Ug=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
Date: Mon, 22 Dec 2025 22:59:54 +0800
Message-Id: <B6BBCEAD-82A9-4FDD-BF19-0D54BB6D6A8C@linux.dev>
References: <mqvgofzudkucibhyr7gsjgtb47rjibqkqce3wdd62p6kqzosxb@tv4fkzewgkt2>
Cc: David Hildenbrand <david@kernel.org>, Wilcox <willy@infradead.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
In-Reply-To: <mqvgofzudkucibhyr7gsjgtb47rjibqkqce3wdd62p6kqzosxb@tv4fkzewgkt2>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B0F040026
X-Stat-Signature: gsi8zgnykkcjmssheeohk74fp31eyiik
X-HE-Tag: 1766415644-404603
X-HE-Meta: U2FsdGVkX1+HKdWTG2MRnScRUCDZQ9nDaBKc7WhGjh0G6ULT0m4c4+tvK7toKzqkb2G1pZW9STvlDvyf38b0pwNf3FtnzppjhF/OoYhJudSApnEZK+N3KvKeh4bI6FfnTs1zT5bSPQO3gSW3lwLIqRAmxsbt1LovQifeUVenLPuVCHfaUdq1w4Avjmh8z/niitPygU4HAvqZoxPBOKPxpNbSsRUBxxsiBg/eDOOzVpacNBFIM2i/gcOCd00r+cLjZCfDlILqcJayXpt4lGgND4CcfZ5wvP/0voxL1gFQbDmIzrBaJh8Elr/Ea8fD0u3y24s9YBAlGKcYkPO8C1Ic6PdRQ3vJipT9w1LxZgJjc5Q3YD4ItH2BCYGaUaArvY305tnCGy8o+NVspO5tE0DTP8LDVxgnSI7hFjQ4mPSEmeUsUx9LTv6FUiY8LGH2WBwadDLIrxamATg/6ILMwjFmLRDq2K6WVXJUkMzFS0h3xBW1JNjMBJsnoaWFb3Bfg6iOeaqggLOLp+2CFwjWY1hpbpfDLoj88RCARnOn+NfZfzdPQuUqkrJ7L8ppKQCSwpDIzQc/WEB5Du2L/HpfuzExjw/QaL32V+FdZFDMxRnkcoWZWVA84k3EWf9VD7cFEUreljOCoV4LFAdI6meU7ngikMO/PdQ4sAX0yzp1lxICXdi6gWMweE1C3/s/MtfFE9/LwQr4wUGQH1+UXAKVfxRQwM5u+KCE+84snOwKJXuSh7x42MVQM0kpjhDUqosTf4+DrMt3ARLmAYpx1KEi6nw5cWUlRUsJ3VWS5RLRtotv+YBpx+FyNztkkTc4Eyo+n7gtCSXxq61D08WDwUp/G+3Zi2gswMKIrYanKya6yNYSIcI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 22, 2025, at 22:52, Kiryl Shutsemau <kas@kernel.org> wrote:
>=20
> =EF=BB=BFOn Mon, Dec 22, 2025 at 03:18:29PM +0100, David Hildenbrand (Red H=
at) wrote:
>>> On 12/22/25 15:02, Kiryl Shutsemau wrote:
>>> On Mon, Dec 22, 2025 at 04:34:40PM +0800, Muchun Song wrote:
>>>>=20
>>>>=20
>>>> On 2025/12/18 23:09, Kiryl Shutsemau wrote:
>>>>> The upcoming changes in compound_head() require memmap to be naturally=

>>>>> aligned to the maximum folio size.
>>>>>=20
>>>>> Add a warning if it is not.
>>>>>=20
>>>>> A warning is sufficient as MAX_FOLIO_ORDER is very rarely used, so the=

>>>>> kernel is still likely to be functional if this strict check fails.
>>>>=20
>>>> Different architectures default to 2 MB alignment (mainly to
>>>> enable huge mappings), which only accommodates folios up to
>>>> 128 MB. Yet 1 GB huge pages are still fairly common, so
>>>> validating 16 GB (MAX_FOLIO_SIZE) alignment seems likely to
>>>> miss the most frequent case.
>>>=20
>>> I don't follow. 16 GB check is more strict that anything smaller.
>>> How can it miss the most frequent case?
>>>=20
>>>> I=E2=80=99m concerned that this might plant a hidden time bomb: it
>>>> could detonate at any moment in later code, silently triggering
>>>> memory corruption or similar failures. Therefore, I don=E2=80=99t
>>>> think a WARNING is a good choice.
>>>=20
>>> We can upgrade it BUG_ON(), but I want to understand your logic here
>>> first.
>>=20
>> Definitely no BUG_ON(). I would assume this is something we would find ea=
rly
>> during testing, so even a VM_WARN_ON_ONCE() should be good enough?
>>=20
>> This smells like a possible problem, though, as soon as some architecture=

>> wants to increase the folio size. What would be the expected step to ensu=
re
>> the alignment is done properly?
>=20
> It depends on memory model and whether the arch has KASLR for memmap.

Yes. Theoretically, the most correct approach is
to ensure that the randomly chosen offset at the
KASLR relocation site meets alignment
requirements, and it likely needs to be adapted
for each architecture=E2=80=94sounds rather tedious.

>=20
>> But OTOH, as I raised Willy's work will make all of that here obsolete
>> either way, so maybe not worth worrying about that case too much,
>=20
> Willy, what is timeline here?
>=20
> --
>  Kiryl Shutsemau / Kirill A. Shutemov

