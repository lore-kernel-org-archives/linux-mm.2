Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6692BCCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 00:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80AF8E000C; Wed, 15 Oct 2025 20:36:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A311C8E0008; Wed, 15 Oct 2025 20:36:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2528E000C; Wed, 15 Oct 2025 20:36:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75CCD8E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:36:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BA881A0111
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:36:12 +0000 (UTC)
X-FDA: 84002110584.25.CB3ADEA
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18A2C10000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:36:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ESl5R15b;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760574970;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yxwXkcho2R7zxZKj/he209S7yXTurt+F1j0Pf0t67Y=;
	b=8Zi6aVMpN7IuWqoZp+wHW/KRxiOjjYYbTOjoP4AuPbSdSL7bDZ5hQSKEY3l50C5f+jMHWo
	K3pID6bHX8CizZtALw5JfCexA4jUy/dI2T0r5xYoXr/KOnQi4gBbKb+QsO8kZhgwnPHyp/
	KKDCdfqlyF0/QySO50wIQqFm0S4PI+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760574970; a=rsa-sha256;
	cv=none;
	b=mwR7TuUkn4nPLTpEn3KyZo0KCbRkSQ+XPSBLsYUmFoPJlniWkBEOJfgYnp+5r/G4JrJ6D7
	h3xlwm3ECLl02BL61YryNFrue47B3zYd/s3IB78jr+wBIKJGduz9rfUumovYW83VK6rIEE
	HGWWfuoRAzMpuIoBhYR8zxpT/Do58aY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ESl5R15b;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b3c2db014easo35883866b.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760574968; x=1761179768; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yxwXkcho2R7zxZKj/he209S7yXTurt+F1j0Pf0t67Y=;
        b=ESl5R15bcd+9lMwkyTiMCGbNAJgbiDL3z+Pc1zgf6z1WrfL8RaAZUFg1bewugeVo03
         S8xLT3ks0zfq8y0VttpI2X6iYNPAf6dl3uBt7LXCvqV+czvCR2SS/8lRL+7F9v3Mattr
         aQeXdhoDV9G/0FRhTL/bB5ndskKijwM2uwdKcezVMCaESKCAijYaOVVroFxU5jo1LTle
         GGyh/e4FN/3E7pyivPF9CglQelx8S6E6NesC8sj5H4gsEEKE+86mAkOz7GIWXWMEULkd
         dR70xdPXCXy+pjFnFPnmpOSssnkL+uzKdlklJS7YiObYA7VuOdeGrgQBtkuGLPDbHcKL
         TFFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760574968; x=1761179768;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0yxwXkcho2R7zxZKj/he209S7yXTurt+F1j0Pf0t67Y=;
        b=fi1QK7nm4lTt1eCiMD4rGCKMI0Q/4aswYIf5Utgp0oGURcSytGyvIuOt2mwE8MtC4u
         4b/bA/a+OZbj9aqodGq7H1LOmqNNJlDSjcjZ5Z8+cSyNF1TDPmvv2O/mxzfFe9YRVGdW
         HWeTvrhSf+7pm9BLml+nnrgKanZ7zriadVuAYs8ok5DfdiA1gEzF3d9wb+PYUVU/hqwa
         T+kARzk+AVT0Ipf9VvOa1GwoKcEtZwmbjUjcL1J6UNgiFRZrszFfd5eG1TlxGpKirWlZ
         0nG+aHEZufvdN0yC0HU5DwCeX/xokOz6Ff9p7Ry1XzHVY0LoDRl18/o1tQYzXmAZuYYq
         jBMA==
X-Forwarded-Encrypted: i=1; AJvYcCU8u65G7gHuDAvWWOdrzZ3TsSrzK6LRdDCaJRuhVz+HiDc6eTiYTs1Z7EqrcedeB7Pjx9cpsbKyFw==@kvack.org
X-Gm-Message-State: AOJu0Yz9zFW54sL1ezzNwhCpR7a2n+9R6izOEiPnWs8VMVCzAZQ06ikA
	9Y6TFrXFU8yzwzWV8kIhPYRMtGyWFSJYbUkdayMGu+v4EnfIdZrinR8d
X-Gm-Gg: ASbGncusQQCa6ee8+hUiqOnf78F+opdhy8BHWrJ55Cn1US9efv6PZ0A8Y+nutDQ2hiD
	crx5sK9fH25id0QtH3aHaKBfI/v/ID3j2anLB5DDfFrhKe0B9uyxaSLNeWcNCnt8dXM0Gs1Qi4P
	9yBu6WelE2zXxrcKy/oYsrdTCvG3ztlW9lDlhOhA0zRduMrBT+vAscVOVssdFPzA42f9l+yIWAK
	kUFCo10acBsuYz7hgf8uRTlJEwEmpgm5bgJ8amlf49vtW8/E0fYpUs3roMQPlYO5c/DaFSXvwX5
	vgRct1VbRB+dAu7h/7VWG/ux0DfoTDl6t33T7Fll4aMsIM13WgQexlXWkaav60hV5n3hIAEBYfU
	sJ49/9+rPG3skSPgZ0jT+M/L4ZZjiahZupG1guD3ePICH8JjvRj0W8eNS4+Txv10MAc3g0d4tdv
	A1TokoAmZMKA==
X-Google-Smtp-Source: AGHT+IEMwY5oV5fPMf8agqxLOoZCtErLmHXKCDhFHyqaLSIca96fhp4FnyJvfP2izgTzzRkCgXWt/g==
X-Received: by 2002:a17:906:c109:b0:b41:abc9:6135 with SMTP id a640c23a62f3a-b50abaa46ebmr3194746466b.41.1760574968260;
        Wed, 15 Oct 2025 17:36:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5cba06b7f6sm379598566b.30.2025.10.15.17.36.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Oct 2025 17:36:07 -0700 (PDT)
Date: Thu, 16 Oct 2025 00:36:07 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm/huge_memory: cleanup __split_unmapped_folio()
Message-ID: <20251016003607.bhy6mtu2b2vh4r6i@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
 <B19F20C2-7B99-40AD-BC1F-944FF92ADECA@nvidia.com>
 <20251015081535.qesjcj2mhb7flq6f@master>
 <DFC8430E-9225-47F8-A477-B032FD9E7959@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DFC8430E-9225-47F8-A477-B032FD9E7959@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam05
X-Stat-Signature: h9uz18zjgu89swx5g5mzfum93swo9z3o
X-Rspam-User: 
X-Rspamd-Queue-Id: 18A2C10000A
X-HE-Tag: 1760574969-132469
X-HE-Meta: U2FsdGVkX19/JYg4/HGxZJ6M1aLj3sNTFRX9rsg8drBjNe52HGtGOeTtSX4M4UcSF2mY19IOUYd10UEZwd0Tt0Zxf2kRI94+JnKV08PawTJkDIc5HSVf4mZ5Il0XmwjJbBi+Zg18Vtuv4AJK7McEOM+Nw81IMY4ijGLWdl5KnQO6tt9HjXOGAZlE0STZekTIihV2/bZF2kofKvsqQ4/FlCVvW1cimF1tZEhmtFHOKI6CwWbh2i2yjEYmJXqU7dFgZTB8euSEMW8dmbY3Gbu/XWLzMFQ3yKkl3+Wyyst0o8vJ2TFnX8LSDoEfZONG7YvzOdDcPV7EiMiNkJzU71uHLDksnwjbjRxd5VNT2qKVk9qXP4kCN97LjLlMro6FKJyye5+VudJQBHfIWUfaWoBfF3ol3AQMmEzvCly0RO3Z1JzvctevJqEhJBBtHyfbDbTa95WGwL/PkZcyy2zzN700hKHjtBuNR3DatRrtVyERNaNUHyK0VBerT+Ii1SxTTMTvxqT1MBhqMIDwHqvDCC+6RyP8pw5OADJIHawPo9Lo2RHcMAuxqDKsVEokry7gVORKbExtgSZ/6V7o7RVRpvDpGxi+yXKniN4X8ng8Fr64G1xqhuaD26JOEkghlVaDaXeGKBQk92QizrDKk5apxZ8D2Dyr27IC1ri0SD2DUR4PznZkYkHWCsvsx/VvVUrxACilSzcSZXprHOefrOCkIsJqQ9lbyAOqThtZy3j9V+rYTtneXoi1hWx3Fpr54l8hwhI2Ntv/pqhBUXIyJpX0T5d2ianubNVgzTfP1HUerODg4iCR11Y9PUqtNNKlxCQRPwPfKGi+FN7gI0vPc5gdUPxQ3BvaeAJ7KWJ4jyhAsgG8UCaJmFoJjhlBIZn27B7YPDxTB8NMLnwGQwHTeOVQfF80k5mZy9bupAiaa4N8c1mlGgfmc7xeBIhVtD2eBPito+aSTF6LmAt4DaO8Dq99RSv
 FPEehgKH
 A7+1J1IRcIpLCZvgTIM0OZg9Hf96rYJkuDVfl34IYPjOV8AZmRE9KLsQK8VOT4rnP99hPxIpNbJVuvsHaY6RnBARxnFPi1dlXNCg/tvLJNrqoNF02JFc32jJnapD7cHzbtppzErKZW3deIdKtiXognB0dwXrn4rOruNUGDKh8HSj+zYoe8+dW6c2MFkEjw2vMmLRL5PCMY1BL/8lMUG/2G/gf5se6kox7GJIBJC2DJUrUGFn6PN9kQ+Wiked08j6TfiC4TENtxk7Tanr4AZDbU/Azo/LE+dUwvyPMvg6eCNM3wGUHNxApyKQ64hG53/G2xSi2uBsN1nmXcgowCDoTQTV0zlkrmOPRThkIB6aEpYP/wxhoMGREgw73B+Eu1aX8GNwvvlqMW3T8aTEwBBCCcC4brxMmR8J4yOcawIGE4csy3KGNPAEPP4+uXITzhdrG03rSYeO5PyjD/5m98WvsPGGKrBKuXrs14u0hb1FYbeelSN78ujIlgU6LA3PEt0yiaQ6abst1cH9B+bzdE4/wFsEokKzCsE9Xqu3ZipRH3xkTcCToRBaXPS+YoGNSObym+W/a3+y/FLDV3QS9mC+Hmq2u+U5tLcZ8JsZS82jnDBac6JM5nSNFb83d3sJZm0Z9LJcWbibzSoKu3pDC5DLOVhyPPcvcNs5f8u0p2zmZjdwTXKxxMMcNOPzY7gRf2mgAjMTQMfZMB7LMwEDoP+v6hVOp+PhrYAFr/yorhhsfYotzz/z9sfzQATokMzes7WEbGLheuJSAiKfhQyp0jESZdPrvtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 09:34:39AM -0400, Zi Yan wrote:
>On 15 Oct 2025, at 4:15, Wei Yang wrote:
>
>> On Tue, Oct 14, 2025 at 08:45:43PM -0400, Zi Yan wrote:
>>> On 14 Oct 2025, at 9:46, Wei Yang wrote:
>>>
>>>> This short patch series cleans up and optimizes the internal logic of folio
>>>> splitting, particularly focusing on the __split_unmapped_folio() function.
>>>>
>>>> The goal is to improve clarity and efficiency by eliminating redundant
>>>> checks, caching stable attribute values, and simplifying the iteration
>>>> logic used for updating folio statistics.
>>>>
>>>> These changes make the code easier to follow and maintain.
>>>>
>>>> Wei Yang (5):
>>>>   mm/huge_memory: cache folio attribute in __split_unmapped_folio()
>>>>   mm/huge_memory: update folio stat after successful split
>>>>   mm/huge_memory: Optimize and simplify folio stat update after split
>>>>   mm/huge_memory: Optimize old_order derivation during folio splitting
>>>>   mm/huge_memory: Remove redundant split_order != new_order check in
>>>>     uniform_split
>>>>
>>>>  mm/huge_memory.c | 70 +++++++++++++-----------------------------------
>>>>  1 file changed, 18 insertions(+), 52 deletions(-)
>>>>
>>> The final code looks good to me, but patch 2-5 could be merged into one.
>>> The diff below is the patch 2-5 and is not that big. My comments are
>>> added below inline:
>>>
>>
>> Sure, let me try to merge them. The challenge for me is how to merge the
>> change log :-(
>
>I do not think you need to explain how complicated the code looks like now.
>You can focus on how your __split_unmapped_folio() works.
>
>>
>> Below commit log looks good to you?
>>
>>
>>     mm/huge_memory: Optimize and simplify __split_unmapped_folio() logic
>
>Existing __split_unmapped_folio() code splits the given folio and update stats,
>but it is complicated to understand.
>
>After simplification, __split_unmapped_folio() directly calculate and update
>the folio statistics upon a successful split:
>
>* All resulting folios are @split_order.
>
>* The number of new folios are calculated directly from @old_order
>  and @split_order.
>
>* The folio for the next split is identified as the one containing @split_at.
>
>* An xas_try_split() error is returned directly without worrying about stats updates.
>
>The above commit log would be sufficient. Your code is quite easy to understand.

Thanks

>
><snip>
>
>>>
>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index b2a48e8e4e08..46ed647f85c1 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3528,9 +3528,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>  		struct address_space *mapping, bool uniform_split)
>>>>  {
>>>>  	bool is_anon = folio_test_anon(folio);
>>>> -	int order = folio_order(folio);
>>>> -	int start_order = uniform_split ? new_order : order - 1;
>>>
>>> I would like to retain this, no need to inflate the initialization part
>>> of for loop.
>>
>> Sure
>>
>>>
>>>> -	struct folio *next;
>>>> +	int old_order = folio_order(folio);
>>>>  	int split_order;
>>>>  	folio_clear_has_hwpoisoned(folio);
>>>> @@ -3539,18 +3537,14 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>  	 * split to new_order one order at a time. For uniform split,
>>>>  	 * folio is split to new_order directly.
>>>>  	 */
>>>> -	for (split_order = start_order;
>>>> +	for (split_order = uniform_split ? new_order : old_order - 1;
>>>>  	     split_order >= new_order;
>>>>  	     split_order--) {
>>>> -		struct folio *end_folio = folio_next(folio);
>>>> -		int old_order = folio_order(folio);
>>>> -		struct folio *new_folio;
>>>> +		int new_folios = 1UL << (old_order - split_order);
>>>
>>> nr_new_folios is better.
>>>
>>
>> Sounds good.
>>
>>>>  		/* order-1 anonymous folio is not supported */
>>>>  		if (is_anon && split_order == 1)
>>>>  			continue;
>>>> -		if (uniform_split && split_order != new_order)
>>>> -			continue;
>>>
>>> This is probably dead code in my initial implementation.
>>>>  		if (mapping) {
>>>>  			/*
>>>> @@ -3573,19 +3567,12 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>>  		pgalloc_tag_split(folio, old_order, split_order);
>>>>  		__split_folio_to_order(folio, old_order, split_order);
>>>> -		if (is_anon)
>>>> +		if (is_anon) {
>>>>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>>>> -		/*
>>>> -		 * Iterate through after-split folios and update folio stats.
>>>> -		 */
>>>> -		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
>>>> -			next = folio_next(new_folio);
>>>> -			if (new_folio == page_folio(split_at))
>>>> -				folio = new_folio;
>>>> -			if (is_anon)
>>>> -				mod_mthp_stat(folio_order(new_folio),
>>>> -					      MTHP_STAT_NR_ANON, 1);
>>>> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, new_folios);
>>>>  		}
>>>> +		folio = page_folio(split_at);
>>>
>>> This is where non-uniform split moves to next to-be-split folio.
>>> For uniform split, the for loop only iterates once, so this one
>>> and the one below do not affect anything.
>>>
>>> A comment above this assignment would help reader understand the difference
>>> between uniform split and non-uniform split.
>>>
>>
>> How about this?
>>
>> 		/*
>> 		 * For uniform split, we have finished the job.
>> 		 * For non-uniform split, we assign folio to the one the one
>> 		 * containing @split_at and assign @old_order to @split_order.
>> 		 */
>
>Looks good to me.
>>
>>>> +		old_order = split_order;
>>>>  	}
>>>>  	return 0;
>>>>
>>>
>>> Otherwise, looks good to me. Thanks for the cleanup.
>>>
>
>BTW, does split_huge_page selftest pass? If so, please write it on the cover letter.
>

Yes. Will add it.

>With all these, feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com>
>
>Thanks.
>
>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

