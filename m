Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81DEDCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 08:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840098E000C; Mon,  6 Oct 2025 04:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1038E0002; Mon,  6 Oct 2025 04:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF618E000C; Mon,  6 Oct 2025 04:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD618E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:18:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E54C159146
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:18:44 +0000 (UTC)
X-FDA: 83966988168.05.AE7A6FF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8BBE31C0004
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:18:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZDSMUmUV;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759738722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLjJZsonQ0E7qTfADopnUgjOKiUbl1Sdyseg+UWcuFM=;
	b=rAgBk7Yb9BSTUdM8ItEuhEl261bTN6QrYthyrPXZxkEvn6JflyEjcRntOLT7XPrYpPRIfM
	cGcB4t7/9o5NUUo4VWDRA7WEOkf7hZNIys4160CxsVBzlRFYanElWOM1L1srxxCTrjn7wh
	c/ON49y+17fLUcSMhWHuu+2C1LWvuz0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZDSMUmUV;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759738722; a=rsa-sha256;
	cv=none;
	b=Wtr1Gs7DZPQGt1lyN7j8wzw5tbVnH07aBcCyaKkub8RvDiRVb4SBcPoXN0TgmmP7DVnCsr
	Qig186nB936wll2Sx9dVO+hjJ8FAd1UwPyGla4CAykQ+YsE4O788XCkOlVFWBngeKFiq3z
	XmiWtrD71r0xlLYbsR2K7WBkmBx1eVI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759738721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PLjJZsonQ0E7qTfADopnUgjOKiUbl1Sdyseg+UWcuFM=;
	b=ZDSMUmUV+LGytmt1BP4TBJXQV2VkbmYZAgeut7b5zuEuoomDsarMfvBllG0A8nmQzq7U1w
	Fg2e8a9tfiRsF2jeFTfltVCIYXciLERMlmdr7hSUkBJtCoPQ8b1iDR4H9+ipfaztqwin64
	EokbpQkzT0bboAtsRvLeK0EAXS3GGbI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-Pqg6DvF6NEm7Ns_uU0OBbA-1; Mon, 06 Oct 2025 04:18:40 -0400
X-MC-Unique: Pqg6DvF6NEm7Ns_uU0OBbA-1
X-Mimecast-MFC-AGG-ID: Pqg6DvF6NEm7Ns_uU0OBbA_1759738719
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e31191379so29232215e9.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 01:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759738719; x=1760343519;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PLjJZsonQ0E7qTfADopnUgjOKiUbl1Sdyseg+UWcuFM=;
        b=ta0noZPTZLqfuBvVyiS7uYQrixTmb28Urxnq9bow3Hx1Qet86RVST5skE/1G5gmEA/
         I8r/ZsEkHqTK2Bbumeict5qX19tElceT8V3N0NekgjVOS6ZQNhwn85K2lwRM57jSpLee
         wTCaL0rOMpLslzJOC/7QJdqb52iWj3uVdqNy4dQZ3tuSNtZAMQkzy6lOlKIQtyXcbwTr
         j1OLei3Yn9iA0SABZ0prC3yuRZ+PIhH8lv8u1LRx18orShkmkrZ8tKP93TvIrafxiTIb
         dbqljH8zPrQpZJN/p3RKOn6hHge8jhrcPFp4/glqLBt5LwcmozUkkcmfwAdSwBIofjRr
         bP/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVsiV4pBklftDAbij7ieO4VFBiY36CfL7nZip63189snz0UdjiQ0QbeDo5T2qiMvxN4IpuDP1Ocw==@kvack.org
X-Gm-Message-State: AOJu0Yx3t+s19MSsXCR8mbQewjbC5T8PgV/VfF+bMDavhhKvsPbz8Gri
	UfTRFT+S28+Ry3dyi4/3hxEhQvGPQayvuYtoHDDLh1cR1XbKmeefvl4k5nHIjDrhNnYc3joRyXi
	89U+1p/Fn2YAi0hHl94VAyctOiyp6xjNiArjnrWe42Ac1acJ3FH8F
X-Gm-Gg: ASbGnctvBfv5J4sNrpboxqn8Zpij7JbaVFMWzoZJmoilJvAunwn9jxetql2WThcekH5
	kSanO6eCRmRxN66aYn7HFCpohdQo4mXnDoc8Bjuopa9Q9xEYVgtux1PawdcDRXR+hipZTRe31re
	MRS8nzaR16s++eLVOFOudBSpU6krjHUo6Ou5D8kQY6TTExi0PWEHnlwEcoYthgvifcZRz0X9tmt
	d/OSvnKwefcYlfbZbQsI63vh31LYJcVOPSBYxn8QFcQpuDOgMWqxY1SWsMTSiaQHXWaJVzSYAJf
	Me0FArjzCClAfZVHlSDch5wLnvXNwJS+1UWbowQevnqM22uczGTwSvnr05lroRVm7ZpcHtyhyrU
	RxTVw9B4k
X-Received: by 2002:a05:600c:548a:b0:46e:50ce:a353 with SMTP id 5b1f17b1804b1-46e71105742mr72047905e9.14.1759738719320;
        Mon, 06 Oct 2025 01:18:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8zoKhYDuUUM3MlzgeoGcX0mPnau2Zyg0r2nobx5bwpDuiO+xfbxrg9oMLqmjXzkWrrp6XKg==
X-Received: by 2002:a05:600c:548a:b0:46e:50ce:a353 with SMTP id 5b1f17b1804b1-46e71105742mr72047575e9.14.1759738718844;
        Mon, 06 Oct 2025 01:18:38 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e723614c9sm145456425e9.14.2025.10.06.01.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 01:18:38 -0700 (PDT)
Message-ID: <9f3e4031-9e13-4f8b-a7fb-8db4166c47f0@redhat.com>
Date: Mon, 6 Oct 2025 10:18:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] Fixing bad pmd due to a race condition between
 change_prot_numa() and THP migration in pre-6.5 kernels.
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, stable@vger.kernel.org
References: <20250921232709.1608699-1-harry.yoo@oracle.com>
 <b41ea29e-6b48-4f64-859c-73be095453ae@redhat.com> <aNKIVVPLlxdX2Slj@hyeyoo>
 <6e4f6a37-2449-4089-8b3d-234ba86878e2@redhat.com> <aNPb3qVCZTf2xMkN@hyeyoo>
 <9b05b974-7478-4c99-9c4f-6593e0fd4f93@redhat.com> <aN6HMzXM4cL6Yf4A@hyeyoo>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aN6HMzXM4cL6Yf4A@hyeyoo>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8qPC2PmL9pcyFXr8Nycn3YqPCpexqUCkvU4-Yw_g31o_1759738719
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8BBE31C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ad9baype468zo7zyzc4ou9je49woqpcu
X-HE-Tag: 1759738722-226143
X-HE-Meta: U2FsdGVkX1/qW06SyuAI2r+Nf4WfSgQ0LwrsDqpvZTaeLnMIfEqCi8jV0kFWnf3Oh9x/gCCzZIOd2ln1r0uzBLsu+q4l+ns00G69MlSIQwwRfNkobv7SSwQms5imaGpFBpzGLO5A5rw3QZKIKQ/BWd5Tfx6uRTFSd53MroESlygxHY2D9usS7SIjmT2DgMTlHO913tPju8ZHEnbHB86RrJquA0rccLMdVoS98svH4Hlft+/FUgxYD5Bl5/kJ43AvWh/fBLgjQ0PsLXWMyAHr7t7h53oUXQmeQZKVoWpdESxoq2yn4LISBZ456GEt33Daj7pUzZEuBFgXp4opHnIK7lfAYTX3VMW3ZdfrU5MDwcnjmKaSkS+5PBB3nKTihQsukCJZg0yQvq3J9Bj4/T0+ya8YnlzEciWp0XiHBBXz+UtkbRAAqQ8l16xzFqW+QtHkuYqIT80cfCUbfg+NCf08KZ56hJetujxzoPqo2nUhEN3nkt7501nLG64483nSEb2foAghvkIZKL1DflRjD1ctP5Jy9Lu5Tb8yfMbyx3Ywnc3GIYkAvtTJR/JOqfPIPFjbJDuRoGakZvH7qpZzUMBFNtg9ZlVZy7WfirTptucwug5nMXBvjXr5hsHgJKj2kzjU5XDkKlUnLSeXK35RhGFxw37+RJucfi03tFA7OhtFr80SAWMp8C6G8zSHuHcUM5EnSu5JjVlMbqIyzVc4xFgiXMXoe3XFMy8dyDd4auKEWygJJO/QIuJZjBmfU6gowsYOR2QgeQAIe/DDDOXZDZgLIQpo52Sn/929H9rE+zPoMa3vIZe4N2Rynfzf6IaPJyc7niG90TxtGpsnXh4r8q3dxjnG7Fp+xQHKCy52lZhkgzrc0/EOqYKFJJ3/TwoeF83Ktme85GYamLObMqHydJbspC3sQAUiblWyWQ36TbrNPQ1eepDtQVpz7qrqsfVIoPqn+wcNKB4efnGG5OVeriz
 gkjTrBDy
 cqPZ5DxoyNRJLVDKi80d+vY8Qk3iNsqKOeGMNm1i6tjk+B1hDqUW34sfcHCJ+1dP+jq1u00Ik7U0bB/vWwuLxTf6ntwEz9e5OlJRckMz/c7XTlbygWezqu9DJd2oeC06GRzAT8gMvoWkpDq1UNlQf/vibMx3/HXgKOIeyIMvJyKKSW6uA2vtl2iJvSsN6FA1sHiUmvztTVuWPXllpYQIhSwETn40oyeBnfouTlNM8O/oJvilptG+G3gbNQbQLpNFPhPzVzRghxp2WSG02+sgd/BcmqwM67n6G8/ubzY5cnhscHMLW3Zg+s5GPtycoaK7AReONsaOEzlXDeZ/CJJIAxtNldYpAu3KGjEva7KOfOY83Pb/KGKsaPiIUpaOPKgpsU89bKxlYlJRZYF66+79ZBlSYMIcoPRfPXEzfFlxF7xTpx7aBjR2zdKnxhn5iLzASjjVmBhstwUjhsEQcm/Yj7aQKqSpheMyrfIpF3YOn+m5im3+f6vU5aVKxpDO5fLM9qCn2LsnZAhhgtpuIgbFZI6OGpuh4pJhp5Llvack5hlky0WE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 16:07, Harry Yoo wrote:
> On Wed, Sep 24, 2025 at 05:52:14PM +0200, David Hildenbrand wrote:
>> On 24.09.25 13:54, Harry Yoo wrote:
>>> On Tue, Sep 23, 2025 at 04:09:06PM +0200, David Hildenbrand wrote:
>>>> On 23.09.25 13:46, Harry Yoo wrote:
>>>>> On Tue, Sep 23, 2025 at 11:00:57AM +0200, David Hildenbrand wrote:
>>>>>> On 22.09.25 01:27, Harry Yoo wrote:
>>> In case is_swap_pmd() or pmd_trans_huge() returned true, but another
>>> kernel thread splits THP after we checked it, __split_huge_pmd() or
>>> change_huge_pmd() will just return without actually splitting or changing
>>> pmd entry, if it turns out that evaluating
>>> (is_swap_pmd() || pmd_trans_huge() || pmd_devmap()) as true
>>> was false positive due to race condition, because they both double check
>>> after acquiring pmd lock:
>>>
>>> 1) __split_huge_pmd() checks if it's either pmd_trans_huge(), pmd_devmap()
>>> or is_pmd_migration_entry() under pmd lock.
>>>
>>> 2) change_huge_pmd() checks if it's either is_swap_pmd(),
>>> pmd_trans_huge(), or pmd_devmap() under pmd lock.
>>>
>>> And if either function simply returns because it was not a THP,
>>> pmd migration entry, or pmd devmap, khugepaged cannot colleapse
>>> huge page because we're holding mmap_lock in read mode.
>>>
>>> And then we call change_pte_range() and that's safe.
>>>
>>>> After that, I'm not sure ... maybe we'll just retry
>>>
>>> Or as you mentioned, if we are misled into thinking it is not a THP,
>>> PMD devmap, or swap PMD due to race condition, we'd end up going into
>>> change_pte_range().
>>>
>>>> or we'll accidentally try treating it as a PTE table.
>>>
>>> But then pmd_trans_unstable() check should prevent us from treating
>>> it as PTE table (and we're still holding mmap_lock here).
>>> In such case we don't retry but skip it instead.
>>>
>>>> Looks like
>>>> pmd_trans_unstable()->pud_none_or_trans_huge_or_dev_or_clear_bad() would
>>>
>>> I think you mean
>>> pmd_trans_unstable()->pmd_none_or_trans_huge_or_clear_bad()?
>>
>> Yes!
>>
>>>
>>>> return "0"
>>>> in case we hit migration entry? :/
>>>
>>> pmd_none_or_trans_huge_or_clear_bad() open-coded is_swap_pmd(), as it
>>> eventually checks !pmd_none() && !pmd_present() case.
>   
> 
> Apologies for the late reply.
> 
>> Ah, right, I missed the pmd_present() while skimming over this extremely
>> horrible function.
>>
>> So pmd_trans_unstable()->pmd_none_or_trans_huge_or_clear_bad() would return
>> "1" and make us retry.
> 
> We don't retry in pre-6.5 kernels because retrying is a new behavior
> after commit 670ddd8cdcbd1.

:/

>>>>> It'd be more robust to do something like:
>>>>
>>>> That's also what I had in mind. But all this lockless stuff makes me a bit
>>>> nervous :)
>>>
>>> Yeah the code is not very straightforward... :/
>>>
>>> But technically the diff that I pasted here should be enough to fix
>>> this... or do you have any alternative approach in mind?
>>
>> Hopefully, I'm not convinced this code is not buggy, but at least regarding
>> concurrent migration it should be fine with that.
> 
> I've been thinking about this...
> 
> Actually, it'll make more sense to open-code what pte_map_offset_lock()
> does in the mainline:
> 
> 1. do not remove the "bad pte" checks, because pte_offset_map() in pre-6.5
>     kernels doesn't do the check for us unlike the mainline.
> 2. check is_swap_pmd(), pmd_trans_huge(), pmd_devmap() without ptl, but
>     atomically.
> 3. after acquiring ptl in change_pte_range(), check if pmd has changed
>     since step 1 and 2. if yes, retry (like mainline). if no, we're all good.
> 
> What do you think?

Only for -stable, right? Does not sound too wrong for me, but I would 
have to take a closer look at the end result!

-- 
Cheers

David / dhildenb


