Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67865C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 15:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056A78E0006; Tue,  5 Aug 2025 11:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0074D8E0001; Tue,  5 Aug 2025 11:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F868E0006; Tue,  5 Aug 2025 11:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D667C8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:09:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F58B14016A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:09:04 +0000 (UTC)
X-FDA: 83743036608.28.F5A4E31
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 79EEE20003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:09:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YHVAeZXE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754406542; a=rsa-sha256;
	cv=none;
	b=X2yTfWIKqlU7ivDRd2BOxSI3F2gD4DfgkGEOi83D37SooSAISmwDWkQ8EB1xF8BWoCRbZD
	uy2FHieUbAFSsUC5Pub/Zp8TZndmUHhZwmWcFeNvBz/WmQBCZnQBvKoP5BnpaiRxhUezpZ
	Z6Zv9qOAVimlYDtAUw2OCe0esnJET4Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YHVAeZXE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754406542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clkjTg5nzbZkcjPnCyY4ICyTnv2rK6xqFAiXWelGD9U=;
	b=FAdSuYuy6X7WuAR/DFMAAueKyp3n492uNqt4dPazBjjsBpT8zgSrKcO/C8g1YTcEbq1dEH
	yXAQSKxPmALkz5gF8iv2yovMZEPzhZxiLQOQQYls8UCsCgvAqS6FxZLzaX3RZSYJt/i/wu
	m4dJJcvrWbe4DqLBLXyIp03+bXGspm4=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so39625065e9.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 08:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754406541; x=1755011341; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=clkjTg5nzbZkcjPnCyY4ICyTnv2rK6xqFAiXWelGD9U=;
        b=YHVAeZXEc0ephbTJK4aeMipAgXbKmMW5nnTCBBnunJeim/iEMsiJM4mez9NUYwP9W5
         i9XgQybox2fVxPPHAYylr8Q55HpKx2/Nvaw//IKPjd+/N91VxhfaKFr21wEF+aWZBc1A
         YcOzYZQSVbrsovfc4IveEJA3FATCtZUmHpfqV973sdfQYz83x9DhxZlgT/WSvTs2p3cU
         85PtLCgFqJZ+neW7wHRdAiPL76KpyBWSzbUZw7lHnYn8Aq9x8FmWjQMqgM/YdnHgCMi3
         meDhIeNoWXX9k3x2ruovAI4FA8hO/IcfVzXK7mbrjDQg+oIV4DoDVyWG5N2reBDF+DjN
         1bsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754406541; x=1755011341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clkjTg5nzbZkcjPnCyY4ICyTnv2rK6xqFAiXWelGD9U=;
        b=xJboMXyidq3u0nBIPa0UDWryvR4IGYHpEEU5rv5OBUBQZU4MmkAI0AXL/0/OeBx/h7
         gaEzzN5miEf5AhVlpA02mCFokNP2yLOEf32y2liIwhoNUm3WWygH6VudDbXa6o5y++8U
         wlBQ7rgcPLQMAMXXg7Sd/CQaNGmRuT3NNF/p/BuHKir0cvOfvUvLe3LRIkdQSYxGH2AP
         jXu6A5p72V5JwRk2DHE+IgNaSsTe+C9lVJzL30P7T7qEpeshprZjPGdvxfXareMR9nkL
         7HI6RICRtoPfI7QxdD4r4RPsM9HXYnkmiYwr5PXTGvIKQGNIHfMJ00JBGI/ozt9wbhpY
         +XbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxP/Fa4pP5BCQoVwCnSscR+HMPsgfKUTDioDNFvvohH3aSD/yErtB53PkZg+982mYiHWpXPpUvfw==@kvack.org
X-Gm-Message-State: AOJu0Yyiju9Sxi8NSGTLyQM8CLacxpPZWr04PFnFGbisHuM9Umr2MMaB
	tsS1dvc7JeN5jZFPU7GiQ4o9DHl6sAjcjJF9kzev3jPK/DycSTCZZCzg
X-Gm-Gg: ASbGncu2F6rjxDePWXuoQRqsqcNO9LMXT7JykG/y/aa2qHSqiDCVqUgQUcwig/sj+er
	VKX7yQ5a2LsKce7CFaJhF7F47kk8orD+X/c+zR1urUf5CSVcjp+OB8DJRZfhp043hcVFHHHe45D
	NG1tEBYuN9ZyHRY/CX51hdPsGSwu9QdcwqMuIfeRQ1X1mWccfVVDKwDGeep2FeaF2y8U+zn6M06
	Xrewq6MJnB2izETBH5lVHAh7yuzs2w0GD/3mdwvHvku1jBZJwJK7tjWdYFk8ojKRioXa1evAHpy
	0QhwLND/EFcCc/Eo3TcUnbu2HEBj+eBfvLCuTf7jtUMhkrR/4Li1IMZSwsGAXQYf0C6U30se+to
	jL89AAvo6nPE6jhx7U996hp/h2YIeg60URBcM71YY0ZzJS/GBkKP7rxrDjHJzC6X3mToRigU=
X-Google-Smtp-Source: AGHT+IEJleTvyo7dw5ZGzLVioDY9Jwr93ljNYRwnTw/ri7vqTNIxJbrhwwu2JSLWJ5dOnaJY7nNELw==
X-Received: by 2002:a05:600c:3548:b0:459:db80:c2d0 with SMTP id 5b1f17b1804b1-459dbf8f654mr60706285e9.7.1754406540648;
        Tue, 05 Aug 2025 08:09:00 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::6:98ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e0a24bf1sm40017195e9.1.2025.08.05.08.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 08:08:59 -0700 (PDT)
Message-ID: <cd99f0f2-260d-4494-bbf6-99daec3e0683@gmail.com>
Date: Tue, 5 Aug 2025 16:08:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/huge_memory: respect MADV_COLLAPSE with
 PR_THP_DISABLE_EXCEPT_ADVISED
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, corbet@lwn.net,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-4-usamaarif642@gmail.com>
 <8bfed1e2-ec44-473b-b006-8cb2505220d4@lucifer.local>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <8bfed1e2-ec44-473b-b006-8cb2505220d4@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 79EEE20003
X-Stat-Signature: b7p19dgezitidis4qq89ic7bpero3hh3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754406542-685671
X-HE-Meta: U2FsdGVkX18+RvE6FvUffNrIxV8U6fE4WXpcYJ0OonyqRPxKO/SMov0dH+22nmWAt3OsIZKcqP6i8LjNxJXC9ekDox0JiRBGzjcPrwdtsyQKkTxHBVDs3DgOC2CPlX3hOWrOW9rywulBZzj7pAIb23eDMQQOt5rcuQdiT5IZOMq4mrLUPM+TZTv2qyX0/EiUcoOGsx3uUDpzVzZ4Wxj9TWS2XEfzLSYeFKqWMR0A1YtyxPOLd6bLgGalm2Girt4Z/4XeqAiIlAkiZh/rjafl1X4//NujPGO++EUSxBwnuI61SMmR2LtxiJ3e/9H9p9r6BYv4ESD16Uov/HppIfwPLAlhTAEDLyPomlK45hynNgeIKERTpjHy8TovES7o7AZa6EUoB/tcOwOI8jEfmNnGbpk2yK8d0zrdMmKBow4H1QXpkUKW23LPsRZakHRrhXfeSEbS2PC3RQ8fJ6m3SQJ+TCnHVq4pgKd9MBrpP4A1Xv1dekpW4ed6vPy2aqi5ciyT7/66tSleujRqSRAuxcr/dZbxS0ygKDaYhRiZoXTAoyIyw9EH8FNIJYi+LXjC0nnUQbAs3s0M1Z3JYNq9S7L9OoTEmXkvd3zLdBvAzIQ7upoZRfXlTVSOyKlWT5416b2wQb+4iKpip5rOL7wMOFII13lpXLMhoJghoRfHhan3AfoBZjYr13jshTs12tGJpPkJMxjd9emUufj+3dZzAsMVOdG/3ACg7ZlLUVg/FwjhAHsf8kveIVGN7oLAENG6IOzAkQbWPezl8JKbPJM36Id1AO5ftWvY1PI13UiGnhcxI8SZOPLxpHywK08Wt1/MImk/UXRPD08Ny9wXL37kdMGLnvuI3Icka90tOAccrFfkb3wnrJYr5yau5acobk/83lV9NvBeaO+jZbmq+ToIhzX+zBE2ERxsSKKtsBzBox06E9IH3u9bjPtGx3SHajI1ulZsC9DIv1VJNptPzXjVU2p
 BqVhQktG
 IffDBosHxdQsBI1O0MrIFBuyrk50O0n5bRylveuKTwVlqGanDOC5Ok++7NNtWPz6mnVNACE18TvSg3FVRip5y6ciGNxvpR/Jg5yQnIu2pjwo0biHNuA8Iszfls6yK9VcDAFnPxIhJjg2EK8vaQooNbEAR9VS8oE7YbM86hT4w4hAveh8jzv8jtC9t46H5W20dDuROIICgA2Vl23/ocKsx3Bl/8O/Uq/pIJw4k11EidM62dLu9nvqU+easQcwQgnxmNvzBVSwj2s4AcCZKzXA3s4B3N7MiEz0JHeZCn5l3Aeb/O8oNkme1TTEH6b8rWl0wFzM4xQEOXHDYtXKD1uFTdxiJDMDTi+5L94Ezd1iu5qlQzcl8DvtaK/iS9rppYpjFiWZqsHT6u+VukG+twW4mDoXmokZM1PI7One955wOtoP7e6f6hzCUbvGPbiDmZrh8Q4FbbVWlq9ca5VhGqYJkv3nINmNc/RltPxenG6nWUv7PxlEXnU/fP/jqQDS/It5BcfmbOqF69D92PCyDk9qOnM/vHo52+YC2KwKofpgcCL2wQYheC7imCj4zPOfL+vzxcWrJQDPcH6j0SMqkuSB+5ay+FUlSvTkEBVY0EwF0Q8uU3QwdMht6D3O5VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>> index 9c1d6e49b8a9..cdda963a039a 100644
>> --- a/include/uapi/linux/prctl.h
>> +++ b/include/uapi/linux/prctl.h
>> @@ -185,7 +185,7 @@ struct prctl_mm_map {
>>  #define PR_SET_THP_DISABLE	41
>>  /*
>>   * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
>> - * VM_HUGEPAGE).
>> + * VM_HUGEPAGE, MADV_COLLAPSE).
>>   */
>>  # define PR_THP_DISABLE_EXCEPT_ADVISED	(1 << 1)
>>  #define PR_GET_THP_DISABLE	42
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 85252b468f80..ef5ccb0ec5d5 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -104,7 +104,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>  {
>>  	const bool smaps = type == TVA_SMAPS;
>>  	const bool in_pf = type == TVA_PAGEFAULT;
>> -	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
>> +	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
>> +	const bool enforce_sysfs = !forced_collapse;
> 
> I guess as discussed we'll return to this.
> 

Thanks for the review!

Yes I have a follow up patch ready, will send that when things stabalize and this series
makes into mm-new.

