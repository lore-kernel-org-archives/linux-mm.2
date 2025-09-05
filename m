Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BDA4CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B5D8E0014; Fri,  5 Sep 2025 11:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72EC8E0005; Fri,  5 Sep 2025 11:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61CA8E0014; Fri,  5 Sep 2025 11:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94DFA8E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:01:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A38411943A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:01:32 +0000 (UTC)
X-FDA: 83855510424.06.E58A2C2
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1993A1A0019
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:01:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k+tqbAGD;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757084490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cqm8/MpfOR7y7rPAbRaZnCO/4JEe1n2rO7vX6ndNO4I=;
	b=bd3cjyYXY1Q9IGRHBUstmsSVwAO33+NStorOcPjFHqEZmnWxoMlyc7ncQ8k6gfReF8iP+N
	uU4W/lkqRAiqzeVOm3DdEMgSnOoD2Dc05GmJgEt9dHiYtALRFYSzV+jFfUu1qLCpWILAiC
	bU05he8Tjty3AMJVkTVRgbUDmEtO4JQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k+tqbAGD;
	spf=pass (imf19.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757084490; a=rsa-sha256;
	cv=none;
	b=58n1wQ0OGXEQf9aJyOX9AAn9lTO6PtOs+3FzvqR2HWJ98H60t6NAmzEKj8cDCOKTwqnA8G
	lzzDwqwKd0Di9T91jIKGmdVnPV9PODR8a46lNCSyXWme8f6lSc4hix7gJr12GdvsPBrouP
	jTotfBbpkJwxxiEwzN1kWuZ10mqFfZQ=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b89147cfbso24005215e9.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 08:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757084489; x=1757689289; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cqm8/MpfOR7y7rPAbRaZnCO/4JEe1n2rO7vX6ndNO4I=;
        b=k+tqbAGDWetrZm/3MGgN8BUnUI1yqEMfKmJqwp5nHz8/xIzCpj8+Ho68dJqGy15atw
         Iwr16naGZlfhdQx3deTQhRgJ+UbmVnZqbSTwHtpdm+JMil6SUQ6ydogLI1mvcTz8P9qY
         tXIMmsO5hbzYcdMWfQF2L0H6ddSFpHOh+1KAeou6AYwhBA7Jwnra5hRWYrkWJa0XC4BH
         znFUIijbimz2+9Jel9nQl28qiRJcMFIUjjD31wz6WA1LtmcfPettHgX6vrQTXU94YROY
         3R1EdzBizpxGAvjiUwPDjnt4Q5B1I0v2r/5pZFIv0p1ImKNOYQV7/YeyfS06MePso0/H
         GjrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757084489; x=1757689289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cqm8/MpfOR7y7rPAbRaZnCO/4JEe1n2rO7vX6ndNO4I=;
        b=AScDDb49AmnFZTw+sOcNXClGwgHLY+5nksfTbl2LzOm2Xf2k4dgOOmhuhZiVCeT+8/
         wdVs2SXzNq+5vNmQ9ZqjJoWBKpD24fy8Ga+9KJLVf/pLWk4QiLe7Xy5hW2iCC5RQ8VxR
         iIh0Svyk5QolrnNd6GsTgazsYoP7hnexbZmneo2e1nOXpHTUuBZWsHqEdXJeH3eeFiN8
         vmmMncgX5E1oU8WN6IqJ3yOUumMF30MhvQLFeySmmt9Imq6WrVQwABPseZ/SES3s8BU1
         GL9/EU5fd0EyzJEm67kWoWb0hWB0fzkjE6TZZ/Xmk7kqx1ec/G85Sdk5IWxPz+DbboIO
         /feg==
X-Gm-Message-State: AOJu0YxwBQ/ocCW1TGjcADCjkD9hcnvdTRM04z54n0Klu623roGdEnIC
	jMM4ald4N1erani4INg16VtEweLe7hykBY3J4wAJyMMbMKlYsd2GOmuW
X-Gm-Gg: ASbGncs9FTYkuYQGVsjb5+9z9BntikLW3mI7uuMabFEpEJ7jMFajMOU05BJFL5I8zqX
	8QciHRDzhYwXR0txe3YX98pWLaQAiqet1Yiqr14J4P41rOVolGj3GR0t7Ixh94BoPGljCWAOuGX
	7xUV/7d/2zqz2UJZ6dUAK+/AftIe4QgF52vWC5s+YQJoc78KtjHXPuHdsOiNDrTK3+x1C04IWm+
	AsEgHcBPzgCUXoMidALdVto69g1+fvOtk+hnUlreHFUjq2FHQVdRF6Wy+w+6uEJUzTgwbX2/Y5W
	WyDUeNmc7DkllyaG6/O1ZGqP3FqB83QpGuTQ+aBvMbcqVmNMZnVGMZj5lRJ0e3gOB/e4fzagYzf
	UZ9RWmyHYHQHgxJWdSvX65pwEVgOCaupsjj82Ruv9EzcrRMxs6je7TzZbLM1WG7Paq+LynFfuv4
	qPqru/HLPopIrBh/+N
X-Google-Smtp-Source: AGHT+IGe+fILrap8cGg9dZVGpK+9sA4k4FV6nVfCljYfVknfZyIkZg/8sGEneiKua6ClriufuvNqiA==
X-Received: by 2002:a05:600c:1914:b0:45b:88d6:8db5 with SMTP id 5b1f17b1804b1-45b88d694d3mr186079445e9.12.1757084488540;
        Fri, 05 Sep 2025 08:01:28 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd4affb6bsm51876115e9.1.2025.09.05.08.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 08:01:27 -0700 (PDT)
Message-ID: <8461f6df-a958-4c34-9429-d6696848a145@gmail.com>
Date: Fri, 5 Sep 2025 16:01:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
References: <20250905141137.3529867-1-david@redhat.com>
 <06874db5-80f2-41a0-98f1-35177f758670@gmail.com>
 <1aa5818f-eb75-4aee-a866-9d2f81111056@redhat.com>
 <8b9ee2fe-91ef-4475-905c-cf0943ada720@gmail.com>
 <b56b43c1-d49d-4302-a171-9b00bf9cfa54@redhat.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <b56b43c1-d49d-4302-a171-9b00bf9cfa54@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1993A1A0019
X-Rspam-User: 
X-Stat-Signature: 6u6j8q3eq3xi1iz7uiqt8kje6yzqrjuz
X-Rspamd-Server: rspam09
X-HE-Tag: 1757084489-907837
X-HE-Meta: U2FsdGVkX1/OrWdM8XYi6Om6KfWfPPyk4LV4xHasqF28heE5Zae6BJuiW+vsnHsoaT2Rp21EG3zHMU8FYZU0CKiP0cX8qosk1GA/sAgpewpFg0COw2cFYGnqe3UOO/k04qY9HMdm4hdOkZ218kVFts1Mx9o/p8wOh4QWyu7L+zAZiXo1IG0p8xaYD4tm8vKKHstM1anlYcu4nOC+foFWENobR7CXf2Ho8LrYdYNnmGWLxNN+FQ2E3oszV3q5xM+WCcZ3ofDCDOv7TsnbZTAzmVv+6Y5uJfL0xxdOmYpFuJ51Q7lz7N9xfAXsxJtQvimbNZSiYUfx+7HrDpivaPzF9sEANKyWHWPE0veSHGPfzYbviPgU8sBldicS7C1kTK1Jai7kCQVeiAuoibLy4RhCa/fTz6j0c2GhDaXEP4LQEf4qs4E05Oq9iYwhMis5V6R2pQYXlalozX85MiqRkGWQF06cQDXRYbMVWsEvQl9FId7ZV1kLomNEFMIauTYnzuR3A6gyCf6oQ0SfKDNnggJlheX0qwPsTC2vQ6dh7fpP9WYLjZKZ6RyO3/pdgabZxVZyCu+jO5080jRWR4x52x0/BpGQ/fdewIwu8YulOX5fsSC8Iffjqj+dlvj2WKiBA12gWiUL/vUXAM4xisCbA4haWx5ruRzyZ31oZ4+zk5tMRAjYhJ8th7rcTBOznw91TWnkeCFWjl2K/s9uQaujRTlQt9+GcM3WP6xs5+0uqKgL33hwNsh/6Ab8s/3qawKLMZak4UjLl3ihA9NEBcDfXhguo5IQ7DFRAgSG/Xd1ZxETThwBZhvUPYkHzlaiByzTWX4bUsKpxj6+JAF/QqrgWBtZ2SqSVKz1fyxtw7BoMwvK9PkU/ZVzJlxdhVeFHXbZB4K2mxfRDzM1Fqg9sNx+T8CrQuPJcIaNsJc/ISpMZ/J4OTUrVRpNUCT5ltm8TgazZzU84TirWe6vnKpYvEuJpzD
 YyJL0jqw
 DShsFOBCB31UQx56aE7ZJv1qeA4tbuPbKbzeUfBxLtYjRN0mfGZ5kjhbM3Y6yRLbLJwej81rpQSocllcgWIDxTOv0EZ4fONt6cMPV+jAPtH1Wc9oZXV6qC57v9l0MtpTNn4oQJLVJ1sDQ8z9nO/YDeoriIvf+P5aT3qbwLyD1NtZa9T6y+qvsWxLALHjCrqw3ddK1IeZ7N6jYRB2doXry8KTbaqvo/UwFt/LdFayPF0HouMw3516QEfy68HuaVDAGoT58dWpzcaghhoxUfrEhEY1qEV4xoQQV+Uf5GW1Mi8cTfEgzDPP7qAnkCfmA3HeQImLKBavr0qGkkDhvJlg6tuCBpYe1kJSxH7jrptgVdoT4t2W3mCLSvsKB0RFiuJKi5HKh8+fNcMqmRXGpxndSVWz+EfgM9QIN1Mc5nDQjrB2Q/TgpvYQYXWN4JvQu4yQF7097WhhukliUyA+6+hSQMEP0gR7v20b5ddO+2Yb6bNx6gdZKfXy1Vu/g+Bpr7IFs/XXXGGJgr8rCeIHzNx2Y0omLgIHwtN3MyUgg4X8WpDhpuWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/09/2025 15:58, David Hildenbrand wrote:
> On 05.09.25 16:53, Usama Arif wrote:
>>
>>
>> On 05/09/2025 15:46, David Hildenbrand wrote:
>>> [...]
>>>
>>>>
>>>> The reason I did this is for the case if you change max_ptes_none after the THP is added
>>>> to deferred split list but *before* memory pressure, i.e. before the shrinker runs,
>>>> so that its considered for splitting.
>>>
>>> Yeah, I was assuming that was the reason why the shrinker is enabled as default.
>>>
>>> But in any sane system, the admin would enable the shrinker early. If not, we can look into handling it differently.
>>
>> Yes, I do this as well, i.e. have a low value from the start.
>>
>> Does it make sense to disable shrinker if max_ptes_none is 511? It wont shrink
>> the usecase you are describing below, but we wont encounter the increased CPU usage.>
> 
> I don't really see why we should do that.
> 
> If the shrinker is a problem than the shrinker should be disabled. But if it is enabled, we should be shrinking as documented.
> 
> Without more magic around our THP toggles (we want less) :)
> 
> Shrinking happens when we are under memory pressure, so I am not really sure how relevant the scanning bit is, and if it is relevant enought to change the shrinker default.
> 

yes agreed, I also dont have numbers to back up my worry, its all theoretical :)


