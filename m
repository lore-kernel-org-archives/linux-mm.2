Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7725F606FF99
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 16:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TBRFoX8I
Received: by kanga.kvack.org (Postfix)
	id 8BF786B0740; Wed, 21 Oct 2026 12:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896AF6B0741; Wed, 21 Oct 2026 12:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3946B0742; Wed, 21 Oct 2026 12:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3C16B0740
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:12:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECF731203F3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:12:50 +0000 (UTC)
X-FDA: 85347126900.01.118B242
Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	by imf17.hostedemail.com (Postfix) with ESMTP id B5D0B40002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:12:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TBRFoX8I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792599169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWCXC5NTHDGlDclEH2O75YYSkPzzTN8RMoYOZpRdROY=;
	b=Bvx3VIWID9kN0UnGmPDjlgyak9J5gOdGk7VTP8d5SWF0yucth9e0I2zrI/vVUGkCOwNHuG
	i65SIVJcWDWDzYv+/SNqIzHkEyhbk0spz8NcYJxj1WejPBHyK+Q08Ja/urld7oK4iFhOJO
	x73lJZSHi1+4IQIrwe3kDHUvQ+j8Zog=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TBRFoX8I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792599169;
	b=SNAoyadYkXdwXtjlhClZxCsqDCcBe/CEbScN54CZlwMejic13BT1m8X11NVfUCzAX36GKI
	9G+cyupxFR+ZFd0NFNOpCsEtR1d9vI40WMqGcMuT/0Bolsv50+JHd9fKgzqj0wbYAK58/n
	ng5Cg2afNurYmHJNSwjzPUhguh0YTx0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E7cWh+ZF7GRhp7QeoNOeMiC4IRFKXkLJvJ6m7Tdn1+M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792599167; v=1; x=1793203967;
 b=TBRFoX8IfarmXP3muakvbtwd0Fnn3QkkD4ckj09YU7HdTxPcPh89Uos/XU2JNQ/FoCS4cfxi
 jY9el39vZ3+nuLjJejOVLV8ZO2aZZ+v2Q7EtY8BM/ASk7vXopV+beNHyiGno7OoNKsaIm/rlV5T
 e0/6T1gBLeK5+yVvR090buvk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d1bddb8955e5cc6b;
	Wed, 21 Oct 2026 16:12:47 +0000
X-Mizu-Trace-ID: d1bddb8955e5cc6b
X-Migadu-Flow: FLOW_OUT
Message-ID: <167a14f0-6a6f-4db1-a34b-905a33d5290d@linux.dev>
Date: Thu, 22 Oct 2026 00:12:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a
 page
From: Lance Yang <lance.yang@linux.dev>
To: samarth.colleges@gmail.com
Cc: akpm@linux-foundation.org, xu.xin@linux.dev,
 Kiryl Shutsemau <kas@kernel.org>, chengming.zhou@linux.dev,
 peterx@redhat.com, rppt@kernel.org,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <efa6a28c-f0f9-4d1e-9cce-fec2c08e7d9f@kernel.org>
 <20261020055518.36087-1-lance.yang@linux.dev>
 <3da45e6d-2b46-4fff-9ff3-241f70d68296@kernel.org>
 <f6bdf823-be42-4184-87d2-fc7c128f4786@linux.dev>
 <68f17ee7-d272-4475-8a59-645442e2c210@kernel.org>
 <ath8JTlITYcXsyLg@thinkstation>
 <2329ee64-f9be-4826-a496-65344e9a9c18@linux.dev>
Content-Language: en-US
In-Reply-To: <2329ee64-f9be-4826-a496-65344e9a9c18@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B5D0B40002
X-Stat-Signature: yhktbnhrhjwafyh7k74jjasd7cp37ifj
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792599168-106690
X-HE-Meta: U2FsdGVkX18eMg4zTpaZT1davoHmk9ygiwd7Nb71nMlcxP9AASgtsMyxxTgsMLEQSXGMBklZwjdvMQA9CV5cUEWX2590Qgl5c5CdZ78kz1Xj8fZUmcPwvyvZ5JstNPaDzGPxsRBeCuxgmcW3J8ExxDbaP3vLZMU2nrrsiwbQRq1FZRECCyg+1UBLE9UTvqs1cDGca5FKJ8awTtpqOwv8zbqTZEIlOrdjsWV3KzKIUNFO9jk+g3QHOmsclWIdJBfyFy1+kCgDgrT0gmGUwWZPUKjikjintDN+bq/Acds72IxsLmQXDoJWtPLvmJgGL0ltG0j2c3QSd+OG0VDuSiTBH/TjdzdMoNfzwyQ9kvkkt82FjzzrKLTqZmkksXqjLIC8GA+5QEWNxiAr2xfuiab2VFZu2nQjHIHAV+D97+wfYXiGX5ISA7i6u310dlsuT89MQuqAIEqLysZajycsmZGl+nKvgHLas9YCe4txsOWYDrfThl4OGnQGUUsODb4MoerJhmrscl84uM1FvFXob/U2EwhloZ1eJ0jKCtvZXIIxFIfvpYwtawHyj2YFSvXUUb7kr43yGDKJ+U92lW5SigP9eAcDUzEJyIYahwS7EvLhWJr/AL4SmtC3VTvpZqkaHc9IA1GhAoSoaHGhhrEy5DXzL1Nbkgrm778o5+G7h9XwkCC4V89w4HfjMd7t4WFBC8lN+DyNNWWmivIHcgmpKNMYAWnauP4zyv3MpwhcUylwb9Fu6UADYFdiROQIIzQE/pXsffvYewnJPUkFcrvqWHRljv7cSPxT6NS8lWT2dV8LLuEXwKuyvZkMdsn3IlqGKVb3rrU6oAQKZ3sntulYG+DyR1MLIb+xCcWZ3HpSC5VXk5zZBS0gHoaitiRbSkNxOP+yopZXfrOgww/POBPPUx4V0kWjrBdBU62EhEqcwceLFdQsWLgZrVuj2neRJCIplXmDO3Hg64ZPIFPzYPMP9Pr
 5OMGjRlb
 lM45B1va3zZhvCe0hhCP2ASAEUjL5xrGTrdn7+9H4hQRmM2Ov/dtOJbTSE8kNluG+MqcD8J6SIZW+7vznQflmksPCLOYiCT1iCBSFzpas2OjZCSlbzDphepCCx/BAsqObmwb21jiHCgFph7q3emQYCXhhB0ih1Xm/g4aRZPDpg8AFcHHe6a+YloV2c6JIyEMfq0FBNbH5+//v/SI5H0ncpQo0AWBmPpYghp+f+s0IzExKPte0F4ggf7lJRRN7vw19Cum2OEGJvOWEyDpGdbQIHhl2PE4cGfWd8QpPGpVisUj6ol4uaI6t5Yz2qeY8btbhET5XHvg5rBXscNQ8HpYYcJIcCfUkvn3pXggl8XJqNxzI5HyRwKWQ6SQGX3yX7ESlWZSx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Samarth,

Could you send a v3 with just the soft-dirty fix, as David
suggested? Leave the uffd-wp/RWP bits to me (I'll take
a closer look).

On 2026/10/21 17:49, Lance Yang wrote:
> 
> 
> On 2026/10/21 16:55, Kiryl Shutsemau wrote:
>> On Wed, Oct 21, 2026 at 10:21:53AM +0200, David Hildenbrand (Arm) wrote:
>>>> +1. Did it ever actually work there :) Why not just skip them and
>>>> call it a day :D
>>>
>>> I think QEMU just always sets MADV_MERGABLE and later activates uffd. 
>>> So that
>>> needs some care to not disable them. So let's rather try to get it 
>>> fixed properly.
>>>
>>> Can you send out proper patches? Thanks!
> 
> Thanks David! Will take it over next week and get proper patches out :)
> 
>>
>> +1.
>>
>> Lance's direction is right. Unsharing is not an access: do_wp_page()
>> already skips the uffd-wp fault on FAULT_FLAG_UNSHARE, and RWP should do
>> the same.
> 
> Thanks Kiryl! Will take a close look at that :)
> 
> Cheers, Lance
> 


