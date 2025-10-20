Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56B1CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B228E0022; Mon, 20 Oct 2025 10:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2548E0002; Mon, 20 Oct 2025 10:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D17A8E0022; Mon, 20 Oct 2025 10:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F19C28E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:07:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A11BD1DCE00
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:07:33 +0000 (UTC)
X-FDA: 84018670386.11.246E66D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A9041C000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:07:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NuHliI/H";
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDRwF8i9GvZpeQJfAlGt77aYUSNIWfGo/XsoAzNEum0=;
	b=Lr3O/fWLUtKYxU79wPEqPvHC6n5KLDQfz2CgVOb+n8Z/S9/wWuAJ9hXaThvRlJLL2hYCE8
	Y0Ea5pnNPihj5HWa4EdwNriMO7ArFdnTvDyta3O/AJpkn0hHKEwKEk9RRfxxDLNERD1NBk
	ee9mnmRF8pgLPoeAnuu7z8RJq9i9xlo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="NuHliI/H";
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760969251; a=rsa-sha256;
	cv=none;
	b=52ynAV1wS/G9CEii6SbiM6r0eS7u8TXqFXUXNGPyr+rwCLbouxS/WvYHXK7T4/cVA3zM3K
	RCnfFTQzsOeamQDIGOr2SqFj87m30svXCA/OMu0nh/Ejam7CeL3GAjG8jZ7yKz5TBUpzah
	ERqZbU/5LcHR+cyNtJpCtaFBsm7IHw0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760969250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bDRwF8i9GvZpeQJfAlGt77aYUSNIWfGo/XsoAzNEum0=;
	b=NuHliI/H/SPVAXhlwt7/O7O7WdIFYqF4WcpOzac89RtHDcuA+nUxK8MG+ZPC7B+Hpo1KsS
	6f1P+nOIOsTdpVEZPdyEOp2wLhznRrRir40LeOmvyW2hPbIUtGwDVG1ZmVMSfrMGicCviB
	EymecXXmnV6kp0N+4N4ODgT2ixjMzt4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-ugbSIhrmNSee3p9sTUFLlA-1; Mon, 20 Oct 2025 10:07:29 -0400
X-MC-Unique: ugbSIhrmNSee3p9sTUFLlA-1
X-Mimecast-MFC-AGG-ID: ugbSIhrmNSee3p9sTUFLlA_1760969248
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso51909925e9.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760969248; x=1761574048;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bDRwF8i9GvZpeQJfAlGt77aYUSNIWfGo/XsoAzNEum0=;
        b=Z9mX8FxLw44yOZkxTgKkhfinlmwpQ3Es+IwojjbtYh3RHClGKlpQFLv2+aWDadBfnW
         yvGY76U5Pa5Cd2hKq16IUwxssmklChLTivRewuf093+B+rzxkkWrVV2dJZ5fh1GJPIps
         SmXNmw50zFFAIcmeIOWlaXLpFr+N20GFyeeDKJ9BaYIdN9JD1aJq4dSvDttoBh/m60Sj
         WOhEgoGhK+XqlxsbuIyo0DuJPzK6dIHOU8VNWnq8sTzdQkvCEDsl/Vfuseh12h8mT3U8
         r6QrAmqmR+dHb3nXRuxCcBIVoaLJWlcU8d1g5LUB31Fu8HsyizlPYxf18GXzAJgdWYYp
         YlKg==
X-Forwarded-Encrypted: i=1; AJvYcCVwVAj0lrGdJGGiZvccJsodu8XZg9ptiAHSOUSdwofzndu0jowcnpHWWCawMPjkZ4PKhdu8d1T61g==@kvack.org
X-Gm-Message-State: AOJu0YwbwYr44qKO1jtHchLlNVi8K9UykrMWRe4qsjyki04p42PpnzdA
	cJeP5Nww0X4yqRlmbB6iCiq+vjv4hHp09481U/4De2cKDxbEjGZGhYBXDS+tajnGC1F6W0d2kyO
	yRt1qPSuWFdPAET+hzI7T/2QzFj3kIbevn8BPL3iVTPro0Bq+y4tt
X-Gm-Gg: ASbGncsmEGOKAloK1wUOhGJeqhVg4Tu+LQUz5kfxhCt9xqcSNxt1v61FxfstPov+/A6
	ilox8NWyMyvCvQbDDse6T5SndISk0rCEOYAtpCfnduoGudvOQZZSLre+ZdERV96C8iVbRvUs+F0
	6RmJpnyFy+bcOw4zAeFNaec3CyKgV3RnyUqwtfeGPjM9ddMNdHuvyKMzRjuprbfXj5bRT3SwuZQ
	8VCFIW+jpsNr+bNv1J1KeXJxT8FH740hNRuAciQxJj7gXxRsJCviRSTZWKmWp4IixFDuvkSWEAH
	/v2fssyhjmwSYOIbItZN4YwiLagN/xEm83nQUjyE2jayZxSQkX3rQ4IKtP8WQzqk7xdn8aSJ3jz
	M6hSAK8vX4QLsB+fO++rILC+a2uPFfmp2gvKmLV8fDZqLakwBjjq1+rq80SaUcW9GnQfbamqBy/
	dW2UCd8MRaiiYL3LVLj37NiPOaccM=
X-Received: by 2002:a05:600c:4fd4:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-4711791c5dfmr110039205e9.30.1760969247940;
        Mon, 20 Oct 2025 07:07:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+BFmRlh4Swqvguf+7z76JRsLA1ogRx9ZpcgLz6sWvvE9fPmA/6t7XAcJOAeAXmY20mtuNzw==
X-Received: by 2002:a05:600c:4fd4:b0:471:13dd:bae7 with SMTP id 5b1f17b1804b1-4711791c5dfmr110038835e9.30.1760969247508;
        Mon, 20 Oct 2025 07:07:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47152959b55sm151911025e9.6.2025.10.20.07.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 07:07:27 -0700 (PDT)
Message-ID: <fe3cc258-6039-4061-8509-8e972127c211@redhat.com>
Date: Mon, 20 Oct 2025 16:07:25 +0200
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
 <9f3e4031-9e13-4f8b-a7fb-8db4166c47f0@redhat.com> <aPY4STwIIRxvk3oH@hyeyoo>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aPY4STwIIRxvk3oH@hyeyoo>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0V1TCwD_5w5jDc6KI0132GAjq-2IBxSojpDE2vIrX8c_1760969248
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nkmbz3p1r1uig4mpicz1iji1kkdq4653
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1A9041C000D
X-HE-Tag: 1760969250-491122
X-HE-Meta: U2FsdGVkX19D/o3Yb8tePyGswx45q21k42KhV9I0mcfvS7VySgLgMcdSylu6z9kmiYO4pIJN1o1RZApgpGsaoe+1WDauA3aFAbr9ced1HU5mOFUe13UXbqXjwveIGX+VAlh7in9w+RJqGpZbda8iQJZkS51Zgp5FTMS6Hp94j9OLZF7wXKJnpvqQdV+gKRpcRxEpl4HEX+pSACJnlLHImUb7D7XVhEi+qukP0nSqms9mluDhqefO9bKXavy2KR1V6QI1av+KD8sZHAUvoy3pCP2Lsz7bSYwK2QMW7GcZel8zifsjdyKUix0Sx2RwqNP/ev0uwU1cSqdaoJhrO1+Wtck0AA7G6OaYT1oWSUlxpV2xrH42B/XcQtscU65Ve3OmcCqCZjbH+zf4xY1CKhl/8G61TE6i9bOLntyi5oJg+RoFhfqPCzz+Wc1xkImFQ2uG9ZOphmZ7ZhkEeLHfdPZdfUNGcfrvJiGtrIz/PxiCKkRywFoAH90tyVNTTQnLaiViV/SndhQBPUuwudZjOj804GUsRUoOHM23cPQduGKdyla0+uRZsKjubis2XuPM1J7DsRMr6xzzChRm1qRI2CPy6AAnQRGFNaGIEvY0uqthGj916QcMVDWV6etSXv2OQ9UrLROafoQXxUDfuA1Uh4+cZZxuDQMjQKsVTLargh1QtlQl6ofSzGCuQ16e78g6RzHmqbZoIPIMJdX+HoR8DncpFmgQ96vIC9+r4HcQa5XHaFnlVf8cdt9aImORv4o+BZzG5Qekhm7XJAa2av36Byckmf1Cm9W/WjleoNv0Zi7KVnHRDRGZ55NpWMTVSqHrUzMWwp9s/DQPsHwpL65aG9KVmlYeBDUlyLirX0f8B8z5zUBUypp4S6DKK8yOXXWQDfLJckOPfkQMxf8aval00R14ohdH14JUBWD0+e0qw2zzfeh2nyUKzcw8bRLt1hfjmYY7PvCJ07xvuQtZc4Y2wi2
 hR8T1EN6
 zGPLrxSscJ/NSpgmSKl5UUvs8aq2ivaSccFY5JoIdr6BhJd7Td3/fI83jNzLPSqD6d4LkO9al9OTNrqw403FO+hGNnSAJ/KJ2GOxTvA6cAjup8SwM0L5e0Ibwhj0BS4NgSguh2mnxYVfSbM9EuvQsr34sTho0qYjF6gdxIiBqbV9Wv6UrAqUyQJbUBzbOfKfNZHIKOBSnXXxe1/VC0YxBu5Du9pupdWjCPsZG26bTU6WNE9uCi57A5jjSIxn3BujZ/ZRHId/ChnxeThf1R+dKDB3LTmCZy61MU2em36hmAppeedN3Jsul55tNWyrRZcSCykNt5EBJme+6Ece8bkvo+QqxbrswTIEFazHbloCteZRxCqLa+0atzjoM6udj++wzeEFJkjV21G+axwdu8ufEvkK//LQaEM0QAYqoqKFXheG375Fa5BXLVCgKfyjQ3PG2qSiu3xAEK4D4Yx9bSGHMFFcrCDbkB/kW5x2W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>>>>>> It'd be more robust to do something like:
>>>>>>
>>>>>> That's also what I had in mind. But all this lockless stuff makes me a bit
>>>>>> nervous :)
>>>>>
>>>>> Yeah the code is not very straightforward... :/
>>>>>
>>>>> But technically the diff that I pasted here should be enough to fix
>>>>> this... or do you have any alternative approach in mind?
>>>>
>>>> Hopefully, I'm not convinced this code is not buggy, but at least regarding
>>>> concurrent migration it should be fine with that.
>>>
>>> I've been thinking about this...
>>>
>>> Actually, it'll make more sense to open-code what pte_map_offset_lock()
>>> does in the mainline:
>>>
>>> 1. do not remove the "bad pte" checks, because pte_offset_map() in pre-6.5
>>>      kernels doesn't do the check for us unlike the mainline.
>>> 2. check is_swap_pmd(), pmd_trans_huge(), pmd_devmap() without ptl, but
>>>      atomically.
>>> 3. after acquiring ptl in change_pte_range(), check if pmd has changed
>>>      since step 1 and 2. if yes, retry (like mainline). if no, we're all good.
>>>
>>> What do you think?
> 
> Apologies for late reply...
> 
>> Only for -stable, right?
> 
> Right!
> 
>> Does not sound too wrong for me, but I would have
>> to take a closer look at the end result!
> 
> FYI I'll test these two patches and see if they survive for a week,
> and then submit them to -stable. Thanks.
> 
> The first patch is also going to be backported since change_pte_range()
> cannot return negative values without it.

That sound reasonable to me!

-- 
Cheers

David / dhildenb


