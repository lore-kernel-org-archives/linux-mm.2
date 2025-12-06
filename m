Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0339AD3B7D8
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 17:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1FD6B0005; Sat,  6 Dec 2025 12:36:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3A66B0006; Sat,  6 Dec 2025 12:36:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9106B0008; Sat,  6 Dec 2025 12:36:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF4CF6B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:36:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D91D8A998
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:36:11 +0000 (UTC)
X-FDA: 84189749742.19.8DF48EC
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55762A0012
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:36:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CEQSPRIk;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765042569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/U8Y9phErjUz8U7ddzGo+Qu6i3pvwgAePj2NAkmM20=;
	b=RUtq+K3hdTWYTdXX1Jg2XQ2uU7Jawn84ifNJloSbX8u0MhjPDxmxee8W/akB+BCBQP6tGs
	qOED3p6H7YQ8ITSeDnioELd+Q1W6h3plHRLjNgSdfpcexiSBvwFo8fu9k2FOVEbwLASdEj
	sghExC+kKpxVaM9jo93bW7q/jz/6UPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765042569; a=rsa-sha256;
	cv=none;
	b=rFC3JVjLiwypIRNoYT7TWaY5ipk/6bZ9gh51ISEjUxEe8zjbCq0ivakfcpLiatOlNyuq7L
	0T9mk9CCl2uL0hoxWrNAIs+pICsuApM8GF+YQ0LjkMs+AnYIAGJ+0MX17CU0E67e4e0iCC
	WzvpT55H17LglVoIwbUkQxf42YrB8ck=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CEQSPRIk;
	spf=pass (imf15.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42e2b80ab25so1371619f8f.1
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 09:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765042568; x=1765647368; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2/U8Y9phErjUz8U7ddzGo+Qu6i3pvwgAePj2NAkmM20=;
        b=CEQSPRIkCtuRn3c9P3INSFfSXIQLN0PysFEblmYKAwWA+Xbr2GT2bv4PvtSX+p8uoJ
         Idkm4EIxAcQEOU5uTgps4b5wFq2B7HzLkKuyQq64cLwJMmzx3pBGfVAriJ1ZW7Lmbza2
         So2hRYLMGE3oBP7CetUPIH/3/HwvnjiPATGZTbxQ1Qqs5QLCiky5v5tnd/b8c0ppmiMF
         Hw7UHvV4Zq0zP6wnEv42WIevx0XCPOnuFGUJEITo4BGqf/HjEu5VO0tS7jmie0ipmGRZ
         ZDXi/tcFev3U4uu3W9zecXqvyyurB/8ZYl1FUVGdVGWqM7VJTYxKFVAGfY4nPouwL4Rd
         UAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765042568; x=1765647368;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2/U8Y9phErjUz8U7ddzGo+Qu6i3pvwgAePj2NAkmM20=;
        b=vxgOVkJ3pwCyWb1hoTpnxyzIAQ3GkWvd0daukkn3JiaEQvJHMC3l9kZbh+5L8tfyyT
         IUIbFc0anxneHmbDQuwdroKzDl/lBZbZSnI5fJrPLl/GAXe09bGVFoGMa5RZh8ImJghW
         p8qwuB55fixA/ZbAJRizh4GiTWILPip9pFJ9xYCp5smQgoNG1+pQKS5lOmA7hhmdccap
         iHFZ/9ymREcNz7SFEze6YRj54ZQWJ2W91gvVBjd5g2pEXLilj7ivSsWOiumek0rNNnJh
         szbQ/7ryMpHkBVp9PtlMB472Wnxr0XWuq3VHRMIT3PMnBTGT2J1qyvDKWCRg7zsXzn9/
         hW9g==
X-Forwarded-Encrypted: i=1; AJvYcCUoZKPEtGhzihPsaE+kImFHc8Kl+xE4cn4MPfhHeHbY6w1b9OSf4idcqJVpQiIH3sODgL7S0ggq1w==@kvack.org
X-Gm-Message-State: AOJu0Ywvl8loi5Y4GUNLT1AH0cCfVi8BN0cDwLW20mUcYL7j2lL4sYVi
	/eT7iBtFVxnSoFWq/HF2SC6ySJSXkP7ee2sweL2cbI0/wVuf1hxrYsJ1
X-Gm-Gg: ASbGncuEHezbC1oNCDfF+yAlSTV16O1Wv3JM3gP8MfaG16hiEWEmhWBztp4PS+US2dx
	7Gr5XbCHIIppY0Bc64ArbytNsyn11cOtywdEF8T/0RY/5NoZcJCRfsbEs82oYi8Y62yQZPQXj7O
	NyIt2iF/tgTiJDY0OCfWpp1rXTw9m1jG34x4jXicZCyRMsO5m0oNuX0Td40llehm2kfW/fEw7Mc
	Q+q/lyZGXDMl7xLr7oMqbGWr5X6URRFhixqFO6Cnav4+wzMLeflxkjYQC46LvJg12Zqn1q+ntnJ
	u022k9ZQ1s3uNDo2anGcVSEKIDHHvYj3U4PGa1K/AjY+tjGJC2rw1UoNMbAhz9KOEUb0EdTQNnt
	3oXqvO5qi5oZK0nMjEWK3vgzx48uwTfSkWe6lwwMOZTeKTCfoKZI9vkaN90KtJUgV+EvNAsplQ0
	4a9Lf/lqes+cnjPK/69ez76MDa0xZOSj8Fzrb5dl7be6fAwprZqNow2fNwQkzhFmrhe7TV5mJeJ
	D1D0veg9XFS
X-Google-Smtp-Source: AGHT+IHW3WHErMLLfXSoVJIYGy2e1YQjfbipOXf9Or0j6jft2XgmGzZiak+evTlontTlfAzYxJ0Zqg==
X-Received: by 2002:a05:6000:1889:b0:427:167:c2ce with SMTP id ffacd0b85a97d-42f89f57076mr3112854f8f.42.1765042567565;
        Sat, 06 Dec 2025 09:36:07 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe9065sm15517384f8f.8.2025.12.06.09.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 09:36:06 -0800 (PST)
Message-ID: <996d8153-a69a-4075-aa1a-945ffe3630e9@gmail.com>
Date: Sat, 6 Dec 2025 17:36:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-5-kas@kernel.org>
 <22609798-e84b-46ca-9cb5-649ffba4a2a4@gmail.com>
 <t3z3msqpbtnkgwqs5fxvnd4zsymclxzzr6vcaubv7z5jtqd46i@g5vtuktue54s>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <t3z3msqpbtnkgwqs5fxvnd4zsymclxzzr6vcaubv7z5jtqd46i@g5vtuktue54s>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 55762A0012
X-Stat-Signature: ucfhscua9fbuzotmdxqdm4jndh3uhkjh
X-Rspam-User: 
X-HE-Tag: 1765042569-341095
X-HE-Meta: U2FsdGVkX1+naYAIiY5uw3Ltc+QZflasVpSiJYBUdGPS1gn4vYefmUxhvVQFXJKnEHNiSiaXCTLNNHvZNCD+ViXvqov8rERcXbdBkouQnqwUEMzbw57eB7avlKeeF1F65oowGH4QDChLlnPYSPytgL02CIZS34Fg31Woexh/QfEqJjfLkJ/C9pDPmms0P5uIY2mh1N8MyjeNRMXyqd2MrZsGWDSleWCSeqzXUXIorWf+QKq0Cd2AYq6A03N+du8U9f1khflQQGhcgMXvyM99lPC24lTPQVgq5dE9d0I2/I5XcgL7CNIIPOOhbNlQ7E4Uy4GJT+48FblQ2+2icVrWXyOjH24LBAUWbQ+uf2Semg6qiZAaYebFAZchg1UNVwPP7ouk83ZfBkDRgcGqwyxv7UQAz663Lu3ANDLsqb+S4PsiWdI9GqoyWpvlt44iFGKM9XushOdVL6qe4vblQ/B0J2/yYmPJb1iTYTSY5WiVq+uj1VC/o8oBOMDh/9I7wwqCGlk+7HqmJ1Wy+M7BdbUMau9FaAvJ7Xgj05Qvv1QvD6b9KPNzkk8spMEHNY3Vs5vBFv0BtiZQ0gEtsapokvLp7hO8FSZqSF3TRgDzJ7weX/SC9nziNfAGjrNGrOW1aM5xYZlf17Yg2tMlmv10kIQIpzdqNTLnKyhZJZVbnY3F3qy9W5GqhH1hnB/DhhbdFY7UNN3fLrAuuOqOGbsWguuLoK9/Xk3KzKlVsvshgyP1t++rpA1PZgEC/I8lR6SPf3rKMXci7chUqVGKmq0ODOsg6HQcLM8xGPRDdZ5VcAEhcB27xzb71WmsZ4Wno1l/7N+NIsCDHw7cJktdsLRRzo3pcfNQ/nVhUY4sCAaWRuTrNG7PLMS4NIb4I+0MXv1aNl8FJIhbJecJcW5sVtcYybxuAVIXB/S6fg5Vv1zWSjDRhR0Rg+iKYGChtun0l/AuYdaDyXKBkhXjECIxhoPhhVW
 cE7V72GJ
 tQwrNcsPoLvqNsX+lMiiCoeV5F9ZELkC06+vyKzR+cCW8BdkZnQocU+MVR9+CsBhNYY+qgf6Cl0J/B6n85W6LgDSmdoT04Ov0MG45qqmXV0izuilpLRjbkQmLnDJC2/6DOTeH5dG5Te1xUlUpsAE8M0IWjh6hptplilgRpL8PHZjI3zVBlOO5UDWWff4fToVRoGAEUF8Tuj3/NZafcox4bLBiQfMLx9LfORC5568Hj0cI0d9kume+wbEt2IuRTpaeKSDBgpoXMUks2EQ3M96q/huUueOg+wgxluigFvLguLrXm4jN7K9l6nAAcKlgBaqd2JjD+xNtVrF5QBwWDmaOq2s7CAldDhhZwSpWUT59OPG92pld0ljCh3an7KkFVaiXONxZ+RIsLbDteY5894QPPSt9PYlu/u8Bt9PGGVXCE8xg+Rk0lU6/Ank8YKDtiLO3n2ojqZxdKJV12jEYe3a02fwmFc2sLONOqlKfBkN3H/XkXDMPEbfEdDrF8PN63c6PZLkz56yA97oe3p/x3HB+VcBVoogd+8iLH2ek7uVSZpQMnPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> hmm my understanding reviewing up until this patch of the series is that everything works
>> the same as old code when struct page is not a power of 2. Returning page here means you dont
>> fix page head when sizeof(struct page) is not a power of 2?
> 
> There's no change for non-power-of-2 sizeof(struct page) as there's no
> fake heads because there's no HVO for such cases.


Yeah, I forgot that while reviewing :). I see its mentioned in vmemmap_dedup.rst as well.
I think might be good to add a reminder in the commit message that HVO doesn't apply to
non-power-of-2 sizeof(struct page), but no strong preference :)

> 
> See hugetlb_vmemmap_optimizable_size() as I mentioned in the comment.
> 
>>
>>>  	/*
>>>  	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
>>>  	 * struct page. The alignment check aims to avoid access the fields (
>>> @@ -223,10 +230,13 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
>>>  		 * because the @page is a compound page composed with at least
>>>  		 * two contiguous pages.
>>>  		 */
>>> -		unsigned long head = READ_ONCE(page[1].compound_info);
>>> +		unsigned long info = READ_ONCE(page[1].compound_info);
>>>  
>>> -		if (likely(head & 1))
>>> -			return (const struct page *)(head - 1);
>>> +		if (likely(info & 1)) {
>>> +			unsigned long p = (unsigned long)page;
>>> +
>>> +			return (const struct page *)(p & info);
>>
>> Would it be worth writing a comment over here similar to what you have in set_compound_head
>> to explain why this works? i.e. compound_info contains the mask derived from folio order that
>> can be applied to the virtual address to get the head page.
> 
> But this code is about to be deleted. Is it really worth it?

Ack, hadn't gotten to that commit.


