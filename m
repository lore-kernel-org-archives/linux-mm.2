Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0FDACD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 02:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32C86B00AD; Thu, 18 Jun 2026 22:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995866B00AE; Thu, 18 Jun 2026 22:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8859E6B00AF; Thu, 18 Jun 2026 22:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DEEA6B00AD
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:39:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7EE91402F8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:39:14 +0000 (UTC)
X-FDA: 84895105428.02.1B9BCBE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 62F5920006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:39:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bKreyJE3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781836752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuRRkjGz275Hq8qH3K7T2fHZ7i0zAjk57ruAUAt40+8=;
	b=p7A7A9XF92T8pmKnXetBMYQMt3PAyhzljPikww1SN3JYNbas75Bwk6qD/hVRIBCdxzUHFz
	NUEAgmng/+MAb09QXg+omm1Rn24KtI5rLXiXebI6nGg3VGafLJa1E7pOAR3pK1OUwq8m6j
	RufvZ+H+ZXfiUFyYCgVEEYerdaf7EFs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bKreyJE3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781836752;
	b=79EymoJMlfL2J7yx2i6kM+kKkmxFZ4eBeIVuhBvuDJW3Z8n8SSVm7v3IvS3GJiU7nyPika
	BwypHqKj6guWdtqjs6IRjn8VpIPKq/UhSPwlwSjHtkF9BnORep5FcIuPSWN6rrx/yyrxVb
	WZJfgxYtKW/9jZGUf5VoK6mBv4GpUvA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781836751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tuRRkjGz275Hq8qH3K7T2fHZ7i0zAjk57ruAUAt40+8=;
	b=bKreyJE3uZ6G3/GWLSR0rUMZSlobdlEoVtJj00N8bzFcwzaqPJkumkUDOipd+Fp40IYY6g
	u4BMjFKYrIuxPQC9777T56adDeVj9YPG++3Y5J0Sm6Vrno2Ti9bclPmne4wEmNnQFWj5Tm
	T4+bJS2aAIk2ebLZ2ewhlMW1JJCMLpM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-1ot4rAsGNM6aYQJvppyuiw-1; Thu, 18 Jun 2026 22:39:10 -0400
X-MC-Unique: 1ot4rAsGNM6aYQJvppyuiw-1
X-Mimecast-MFC-AGG-ID: 1ot4rAsGNM6aYQJvppyuiw_1781836750
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8dc3be1ebb4so44525826d6.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 19:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781836750; x=1782441550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tuRRkjGz275Hq8qH3K7T2fHZ7i0zAjk57ruAUAt40+8=;
        b=qmG1wbUd2RmZ9p3zh/rVyN6VK821J7KuN3pe3oc2ssK7MZOdFXMh/B+R5r2sGP01H0
         BLquroPw5CXp07XQTO17rdJEXvoha9TgHFO3+kOONP9TNZtm9iCXdVBIvB0To4RvfyY3
         pJzCSvX5xegalCw8kSC5dhZWm0t+cEqF1DyKWKqlohrbetUUiPxMyIwWrinOmQz2xIIg
         a5fm5/43zEOMS4g7FJLrmjs62TfKMxIUal8g7SsfBNnCIx41hvhm0y8X9yFnrSTbQpAR
         P14nzBG3UavtfWsvf7oKoaTge+g3T/C/rz7RFHL3OlwtCQyv20Rv4LTtv9On/iMnzWMa
         lK8g==
X-Forwarded-Encrypted: i=1; AFNElJ+k8MKF4HF+yfssQUwN80MIJNE5qCNfMvt0hwSvd2Q3UQV1jtUVUwmvTiYlcBUD4+rhEkHmeDsQMQ==@kvack.org
X-Gm-Message-State: AOJu0Ywfg4KTOwyLZq+pLE0u5ck3NPqwb554lXFvU5cv/aYBXYw/LcRi
	6pniD9V2Ju3+5eO8pvdhOgnapcK2N4E97DcXvVWyGDCz5zNPXqj+gf4Az2vapFYN2/w9uUWdmLw
	IRik65LcWkmcreqc0KKUNo7UKpDmiDQQC83TwdehrPAF7m2vzVLmt
X-Gm-Gg: AfdE7cn3K0velnfWe0p3BGflS8W07rfAPtbfmyIOAUAEb1Q2GuuJgxY1Bho9GnYcC8r
	2ONTZB2dbeTgeX+RuNlfyiTE78UboVA1JifRMWR0oiyYuAyHSKEnychtiq5/lJaSj3eac85zBuN
	fkCgbUQUjQZ0Wq+J0W+/mP/hnEIAgAm6Ath7z/GmYmDCZQqrbgnFgCoHlmGwOCnch8wP0uSysrH
	+Bmmpbw3WbK77Ly75GTZCLrI5qw4UHOiRi5/2t7Kf3zqeMjRdfQJLjS3qiQeXUl51k2GuQyrec4
	O/UpVubhKzVIvCyEBvWlcFVyldsXnbGaJ0D0aH06Cq68B0br8Ip7PSabJL35dH7jrEKcAHHF2tx
	z6xCf+jRIC8vB1Q==
X-Received: by 2002:ad4:5d41:0:b0:89c:867b:a9bb with SMTP id 6a1803df08f44-8de4c46d3abmr22002136d6.18.1781836749865;
        Thu, 18 Jun 2026 19:39:09 -0700 (PDT)
X-Received: by 2002:ad4:5d41:0:b0:89c:867b:a9bb with SMTP id 6a1803df08f44-8de4c46d3abmr22001816d6.18.1781836749382;
        Thu, 18 Jun 2026 19:39:09 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.200.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8de632c5de0sm9206176d6.49.2026.06.18.19.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 19:39:09 -0700 (PDT)
Message-ID: <698e5cdc-8f1d-4984-bb54-a4b7979b4dc8@redhat.com>
Date: Thu, 18 Jun 2026 22:38:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_ext: validate section in for_each_page_ext
 iterator
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: kernel@oss.qualcomm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260617-page_ext-v1-1-37ad802b1a38@oss.qualcomm.com>
 <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <1dbebf73-6c46-44e1-ac6a-f5ffa9849b37@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LRiditDqU_gImIDNK4z7s2v0QUVmzISdpxrNEnSgd7c_1781836750
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62F5920006
X-Stat-Signature: a1o8bmhofm9wuoidjpq8791ukgfh7dgk
X-Rspam-User: 
X-HE-Tag: 1781836752-60048
X-HE-Meta: U2FsdGVkX1/uZh2JZFtQDjqAkoCevbOm3VT3pGtpA4IGFulTeBidD5AvLHxuceV1J6oTXdP72W96cEaHLXYrjengH5c34UcsEIoDwaJSz0hXlXNIj5j1xCs1xbcCc8SbYLVEerePukeeGMpFJmwgCDH0XekgeEzWhg4PBGjePfNu7vfbWZi9BQcQ8FCtB/852bPWmNQiUxFvi5sFyfaEWsiKfkghiMsAloIvpeqxe/F6e5iuXf6BJ11JwIwu3kwOpOUa7VZzbq54lxT0XJyhcnBfSJu9sNEvGSH9JcxIX5cDxtCchyTDkbckV24XVnlWEUEtkl20DuVKSxed4eZevdZfPUdOLYRGdUoun3a/2ErDBoQ4+1I5eJ1DPQCvsK+J6Gp5KnwSuPL64YvfrSbEl+3aUL/+aklldGn7WXSdbxUqtGIFaV+b7aHx9TqvaMf4JUddMBZS4/ZDrZJETEM55zrLNhIIM1yDB3TchIpx9rNjOdIr9Pp1tfaNadsBOOws+UmIQbYxH9cReKp0Y2Ewc7/zcpAd22PpGJNPNHOSFvVYMWPWwoFZTa7FdMRlqLxpgc9sZfBr3Z5O3gJb6u3sxzV/CsEgXd3SsUKkbZQaIKxaqEnhOCl1hLEPQBE4WUhBuaXowEF4nNRtF36nbFlv/tboaMzcT4pE8gVBX2l2kJovivo2T55sUAoJL3cJoJO6+nPdv1d1p15UUup5pK5XRqmdgToE1Q1PFf90FZtvC7+GNkVQWF1FQW+OuA8FUdjWpr+4h3S9s0NnCzpT9iP+zWR/lo+pD+nAKPYZdgMkLUkbPO3xMq4VFDvOeOyMmFHuRHKYyRRUPZferTYUt4i3NWud8EQxPTDpVKrY/DHguO+/+Tx/cB99kQnh6hE9UqURwGwE9GEy4gtek+G/HPdWI81C7Mfi8+zRNb4wj8MWfFg7a8q2FGqRg6YNtlx5HwZr56Xj+Nkdh4o5Ps9KL7Q
 t9MVmYrQ
 pLeUTc8WLFjTPJ4+rJ+qL+XWZRzAhbAqkFmLyDURupuOR8E8c2V5vpMTVM7vk06d0EreuR/U56HDUKV24X9TfHi48dY/Wp6/qozSOhlDwVkVs5I1qwc2P7kP/sSZTnlDwlgeenvcP/YY+cANjzyKAdUvU+T8znFwp3lpPzWs3pwvSIUPixhMhQRfALxu79v9yhqgfMhXdWMatwqbAcQi/M0M2W0oOYLnnLgEKOxniwc2m4OwcyNIVS6rFdzl4nw4Z7ip4edivuTnVTIi2pqLcnP1Ro2UjKImquNU1DfhPfy/vsh8lOqlFE1BabSjJxGMxNqYJS61wUEqjVXtzpmBgZCjc0NThXtwON1QsSOIinvNoKuk+sxAPqqflFOnWRHb/Rztp0upkwMCSUmHcKdZf6zNTiruv1HDls14E4frLIRbqr0zIWSGY1UNaeUcXohaHxA5dZ2tZfI2UlF/WSu/MrP2QWxTBE4p9Q4AOieWcy4Vq2THiwGkHM5o/tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-18 05:04, David Hildenbrand (Arm) wrote:
> On 6/17/26 17:09, Ketan wrote:
>> The page_ext iteration API do not validate if the PFN still
>> belongs to a valid section while advancing the iterator.
>>
>> When dynamically adding memory in hotplug path, it can lead
>> to a NULL pointer dereference during page_ext_lookup at the
>> boundary of the last valid section.
>>
>> [   14.555124][  T846] Call trace:
>> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
>> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
>> [   14.555129][  T846]   +0x11c/0x260
>> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
>> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
>> [   14.571206][  T846]  generic_online_page+0x14/0x24
>> [   14.597782][  T846]  online_pages+0x178/0x30c
>> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
>> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
>> [   14.597789][  T846]  device_online+0x88/0xb0
>> [   14.597791][  T846]  online_memory_block+0x30/0x40
>> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
>> [   14.597794][  T846]  add_memory_resource+0x280/0x298
>> [   14.656161][  T846]  add_memory+0x60/0x98
> 
> So, we do allocate the page_ext in memory_notify(MEM_GOING_ONLINE) -> ...
> page_ext_callback() -> online_page_ext().
> 
> Which makes sure that all page_ext is actually allocated (for the full section).
> 
> So when we later end up in generic_online_page(), the page_ext should be there
> and the memory section should be valid.
> 
> 
> How can online_pages(), which onlines memory part of present memory sections,
> online (free) memory that suddenly does not belong to a present memory section?
> 
> Something doesn't make sense here.

Ketan, would you please share the full OOPs message and maybe tell us
how you reproduce this issue?

> 
>>
>> Add a valid-section check before looking up the next page_ext
>> so the iterator stops cleanly at section boundaries.
>>
>> Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
> 
> If the problem is real, we'd want to CC stable.
> 
>> Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
>> ---
>>   mm/page_ext.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/mm/page_ext.c b/mm/page_ext.c
>> index e2e92bd27ebd..74067ea740fe 100644
>> --- a/mm/page_ext.c
>> +++ b/mm/page_ext.c
>> @@ -253,6 +253,18 @@ static struct page_ext *lookup_page_ext(const struct page *page)
>>   {
>>   	unsigned long pfn = page_to_pfn(page);
>>   	struct mem_section *section = __pfn_to_section(pfn);
>> +
>> +	/*
>> +	 * section can be NULL when the page_ext iterator's for-loop increment
>> +	 * computes a PFN one step beyond the last registered section. This
>> +	 * occurs because pfn_to_page() uses __nr_to_section() which succeeds
>> +	 * for unregistered sections that share a root array with registered
>> +	 * sections,while __pfn_to_section() returns NULL for them.
>> +	 *
>> +	 */
>> +	if (!section)
>> +		return NULL;
>> +
>>   	struct page_ext *page_ext = READ_ONCE(section->page_ext);
> 
> In addition to what Zi says, which will end up as:
> 
> 	if (!section)
> 		return NULL;
> 	page_ext = READ_ONCE(section->page_ext);
> 
> 
> drop that comment, not required. And likely best to just add a unlikely(),
> because this doesn't usually happen.
> 


