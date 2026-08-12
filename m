Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77E7C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FFA6B00C5; Wed, 12 Aug 2026 06:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF08D6B00C7; Wed, 12 Aug 2026 06:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09B76B00C8; Wed, 12 Aug 2026 06:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78C5C6B00C5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:11:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F121314023C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:11:51 +0000 (UTC)
X-FDA: 85092201222.20.57058AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 25AF140002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:11:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpDBRWmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786529510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfiNVLASDPWGps0IGQrXX1id980cU77uk3nFkKyJv+4=;
	b=szSo3j2QuM8O20Nf3MzpliCDKpSRAMZr120RoM/xqGg3eYWytC7YbPzZfJTtWXwp0p5w06
	Tf+hPf23BUkPaIGSI7Q2OpuurhC2DRS6bwWQnXffKZyikzVqTFNGfktafF5FyI0Qoq2H/t
	5IEimcELH/5gMdMn7w4ve51f2tp1zqw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpDBRWmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786529510;
	b=lXDyMlVLSXdh5MA3fmalnmq5reIspAaHoNNlX94DQQvD36D3Cp5DLNxDKYwfEUzSZWe/Hj
	I614zhJWxZ2fi4ViAIpneIH6+4xTMHzEK8GDDGG+LW0q+rez1MNbKKp1Pclf8gG/KX8gQI
	qzsMno1L9NO6etI0TTehorOV3rYmvKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A3B2434BF;
	Wed, 12 Aug 2026 10:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE691F000E9;
	Wed, 12 Aug 2026 10:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786529509;
	bh=ZfiNVLASDPWGps0IGQrXX1id980cU77uk3nFkKyJv+4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BpDBRWmJG3c0g/DZXp16rkvkaW9dawtxRgwq2k2Sq3WDJ4bNN5qyuajlKSdjkVRIh
	 /2fbVI8CIlrykXcg7GLM2kcZJq6KWr5s6Wmgn6aJwzWlZWIavul2iAdflgUY5AFQTf
	 pdz7UKQyTd0+Dx0cwSW8F1SVzsd/dRncVdGOJmPy5nml3ku1Wn3X6pQLFZ6Juta+WI
	 Trcl//YPJxAT/nFNY5VF5zZDEL1LkGbgifBCcS5Cw79TeCwNUj1rKOasM+zfwQi9Xv
	 hEr69JMZ31siM9nYeji2HD/VrpP9VHvC6YT5IzZCSTmRwET1WF6+1vj1xg5WE5Q5vd
	 gh/PUFfBKgDlg==
Message-ID: <a09b5362-80c3-41fa-9d6b-c423d401d5ce@kernel.org>
Date: Wed, 12 Aug 2026 12:11:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
 <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
 <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
 <f0593f56-870e-4e79-8552-1760fad255bc@kernel.org>
 <01795519-54e8-4ed8-a94e-2b77780abc3a@kernel.org>
 <MW4PR11MB6936466F8C60509BDF73F9D1A3DC2@MW4PR11MB6936.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <MW4PR11MB6936466F8C60509BDF73F9D1A3DC2@MW4PR11MB6936.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 25AF140002
X-Stat-Signature: j71su9gaq77cduj3hurg44nypr3n69si
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786529510-727903
X-HE-Meta: U2FsdGVkX1/zS8nayKTvIVV2paQ1np+84I7nLRox5ANTh0d0MAztE9LHMQNkGwdSt0xNsSl7dXraoQlPmKoAkUJhtACLrcREPKgE7uhNMl/UCNKL1OSQt5+wdmg0fVruzQS9KUS2xi890xTPM7sa/4LLDXf8KUzotZ6ciSiNgDE54eUZWrv7BTDoBYIVZjQ5xHOWfX4ssJhr0jkr1X3C5OCpmEnaT6+JNVqJiETLMEIJKJ68FnObwgWeXhuUqnWSFimAEC50g4+tSR7TiEFHkqQnQmu6h2THtqZZp1pfM5h1tT9YSfm53eynjAC8KEU6qD6zU4AOfWUpqWOAnO2jvv68gmKnInaDu44V3+FR6hXd0Y+rhxXKm8QZYWBj4OJCKM+We0mMGgwupuUUWvW5FNNWKwlVcbUOWsr+0erev1d9XlsTu9PrBmZYnZ49krvo0ymO+yu8mbnyL+ci7Wvjsus2AotN40M+YuLBEsyssRKVcorsmsRSOuYiemljo5WHcFU9UnmlwjElRLZrJNrx0vBJAEs6B4SOytLQ2xdoVEwrHdaPHw8Wq2x1gtuG9tqPOKZqW9u98jDI6/In64fSJ0YxeaX895vwA5/UYmkakr+LGyq0JiUPeI6gQfCtQaNg/CvMlMG2Av92tfS65p+OJAwtswnF93Mz/5mUtqzXoA5hF+rfmW9yKyiItxFi26mTiefelyFm5YWPUoJpTssc6xJxkonbAEt6NbhSolJX9YW/a+Zqss3CXWk0peZrS/AKGJhx+DXrW4NX9NcWjKHGx4zeXEqoPDd4EY0Wz087zzIJexMxVEBNVs3ecNeCglMt1/1fAC87b2c8tkvL3kfIOQDyCQs6pu7MXIzcPHC3Z7mUCAIoEgKjc1HXWHEtPXXN3icX5jlNr5dfqnXEKghd54UjVn53ec4vuKbZtFdsrwqtkL9A3jnfeAJYNCv/1LJakX7E9uH51LL9kBjV8f3
 UYZxStvt
 4xHYHtqpyxtjS0HIo5wbIXL6APZ7X4Kyn6qFqCDaZRusHFHkDTfJQlvfubhWiGTdikCA9dX7KYWtvy6oOUfXwOmZJr8qOkKpdam84Dm3PWZpYNBhlVg16ESrxGQ2yKA/AjPcVDFFknM5CCP43ra3Aan0OBD7/og6ci4+qaFrmio9M+ipZDXSAatWh/LsFf2pdCNyZBysxuGLibM/NMYBIAd3FVJMkJdpFXrOovoHaVGBRyai/ty2y8F54cjch8Lj9cUg7Lp0gOTBplMqnmaUB9+LA5C9uQ4jSPtuN0x3kElhuKnqo8sMyKEIGDDKpoM3XsTeSXBxOzJ9Nzf/0tkHlngi/B4f8BYa3MkmU40fm3drW6ulETj1cO3ZKd+eBOUWDje1Prl9Rqvkvqgdj2GoJprB5Gn8x1jXIBpq/gMYeovzNBwuwh8LWJTpiEJvjMDkIetUOl2eexMVWeeE4vfGfFwiE2oBSyWSPRVmRM2l6CXpm9RBATJvrWvj0Aeii6Q85aYdwxu4YMWf4+47iHcajNz32kdamfp9j/LROSVxFf240a5Bs1BeQGkmdG6ipULlxLW8d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/26 11:17, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: David Hildenbrand (Arm) <david@kernel.org>
>> Sent: Tuesday, August 11, 2026 8:23 PM
>> To: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
>> Mike Rapoport <rppt@kernel.org>; Wei Yang <richard.weiyang@gmail.com>
>> Cc: linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Deng, Pan
>> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
>> <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous
>> check when changing pfn range
>>
>> On 8/10/26 16:04, David Hildenbrand (Arm) wrote:
>>>
>>> Thanks for reminding me. I think the right direction is to finally clean
>> up the
>>> pfn_valid() handling.
>>>
>> invalid
>> subsection
>> follows
>> going
>> wrong.
>> which
>> through
>> the hole,
>> zero-filled
>>> Let me take a stab at just having pfn_valid() / for_each_valid_pfn()
>> respecting
>>> the subsection map.
>>
>> ... and that turns complicated very quickly. The problem is that we have
>> some users,
>> in particular the buddy, that just assumes that MAX_PAGE_ORDER regions are
>> fully
>> accessible.
>>
>> The fun begins once we have MAX_PAGE_ORDER span multiple subsections. So
>> we'd actually
>> want to initialize the memmap.
>>
>> The pfn_valid() vs. pfn_to_online_page() inconsistency is really nasty :(
>>
>> I mean, in init_unavailable_range() we could actually figure out fairly
>> easily
>> whether we are dealing with holes where pfn_to_online_page() would
>> succeed.
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index e9c4204b73adb..54e71e17f2c3c 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -843,11 +843,13 @@ static void __init init_unavailable_range(unsigned
>> long spfn,
>>                                           int zone, int node)
>>  {
>>         unsigned long pfn;
>> -       u64 pgcnt = 0;
>> +       u64 pgcnt = 0, online_pgcnt = 0;
>>
>>         for_each_valid_pfn(pfn, spfn, epfn) {
>>                 __init_single_page(pfn_to_page(pfn), pfn, zone, node);
>>                 __SetPageReserved(pfn_to_page(pfn));
>> +               if (pfn_to_online_page(pfn))
>> +                       online_pgcnt++;
>>                 pgcnt++;
>>         }
>>
>> If it's a problem performance-wise, we can always try optimizing by
>> skipping
>> checks within the same (sub)section.
>  
> Hi David
> 
> What about the following approach to skipping the check within the same
> (sub)section?
> 
> @@ -827,11 +827,21 @@ static void __init init_unavailable_range(unsigned long spfn,
>                                           int zone, int node)
> {
>         unsigned long pfn;
> -       u64 pgcnt = 0;
> +       u64 pgcnt = 0, online_pgcnt = 0;
> +       unsigned long last_subsection = -1;
> +       bool is_online = false;
> 
>         for_each_valid_pfn(pfn, spfn, epfn) {
> +               unsigned long subsection = pfn & PAGE_SUBSECTION_MASK;
> +
>                 __init_single_page(pfn_to_page(pfn), pfn, zone, node);
>                 __SetPageReserved(pfn_to_page(pfn));
> +               if (subsection != last_subsection) {
> +                       is_online = !!pfn_to_online_page(pfn);
> +                       last_subsection = subsection;
> +               }
> +               if (is_online)
> +                       online_pgcnt++;
>                 pgcnt++;
> 
> If this looks good, let me prepare and send out the next version series.

Yeah, something like that should do.

-- 
Cheers,

David

