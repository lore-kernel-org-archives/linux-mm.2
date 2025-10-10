Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E893CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 07:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FAEF8E000A; Fri, 10 Oct 2025 03:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB0F8E0002; Fri, 10 Oct 2025 03:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873868E000A; Fri, 10 Oct 2025 03:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6D88E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 03:40:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A89A1401DA
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:40:38 +0000 (UTC)
X-FDA: 83981407356.08.5BE6A88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8CE0DC000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:40:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UEwVPkoV;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760082035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwJz/AqNSYJZ9V1C2xBbiX8Uw8ClPqDAnbOwKwUJ1Rc=;
	b=0Hl9NvHEHrIv60NzL5z2anjEpW0hdIlkKYXJyXwa1+c+AV3taIu/TftQ0+8ThOCCS2bOpM
	/b+cY7bYKFh/CMcqwfKT8TX9Q2IHF4l9jTpCyiwOICTCzWcsbcGDKxy6BuyqjhfrUAw1+b
	qEjOx5fH4szCabhSyPJ0DCWYrrMmqZM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UEwVPkoV;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760082035; a=rsa-sha256;
	cv=none;
	b=CThWNN9zQZZ+bnU0tJ3hcffBCthydAbhtCwJclDCGL2Jl4OLZStaYFZ4Xv9ZzpZ1Ao7M7U
	Kzz++9wylZNp43jorTK3yncfnYS9ChEkn1bHK2/vyGryYi4eB23NQv53tQ6NWjbHTyK+cL
	DHFhvIMhvnzIciBX0g3vB9si+byxP3I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760082034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fwJz/AqNSYJZ9V1C2xBbiX8Uw8ClPqDAnbOwKwUJ1Rc=;
	b=UEwVPkoVDIQRhLhaOGEPOFhl4bRMKv0TRHbFxWcsW5rbh979Z4k8MZU4I7J/UUYjHq4Wrf
	aS3zcSreplZfbcBYpZj8+1i06qOwtatYgzrxSC/bJvqgpSQh3BQdfoSsyWhqgcL/lapL0y
	KoJJIJs4fyhCQlseSVBTX+FwXS8H7GI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-UE3bWjIqNfeOzFTY01NNlg-1; Fri, 10 Oct 2025 03:40:33 -0400
X-MC-Unique: UE3bWjIqNfeOzFTY01NNlg-1
X-Mimecast-MFC-AGG-ID: UE3bWjIqNfeOzFTY01NNlg_1760082032
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e4cb3e4deso10202985e9.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 00:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760082032; x=1760686832;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fwJz/AqNSYJZ9V1C2xBbiX8Uw8ClPqDAnbOwKwUJ1Rc=;
        b=oB7PLvh3KN4MEpDITHMFWdYd6LrQaqO7LdxVMH/XzFF+Otzt3hxW3Pq1q+zbfMaOTu
         ys5OjuSr1cN1rWLkE0CdcYxIr7PlvYLuNc4eYW/KDMWq4uD8YYtXukd8DirlqCQrakjp
         +d3sVG5iNm33r5cjI0j6xtz5vHmvRDNreVutm3wLOiQZ39oJGLZDP4b30FdRKNY8+7bz
         3D5gXnDTfqDqlHbizfJUczB6wi0I+5Vt3qrHXFK888AYQ9EMomzeesAV5/ww86/3OnFo
         +3x0tIdRg71vGxWMLFgwj2UmlkDMh3SCIBBqgC7RHqlWoNpiWqoKOexjHOtvA3HaW822
         hFLA==
X-Forwarded-Encrypted: i=1; AJvYcCXPrQiWENHIKDtdpomh1UIwkJ21l1MMmNLzk53NnG4eMAXjFKXbxtPYHT9j7gckfJsaTYCTECT+RA==@kvack.org
X-Gm-Message-State: AOJu0YwXD6xW2FJSd33cgsxEe3gx1a3d2sEMGmONNPVv+P/wIRzb46g2
	XewQSMMwc628TekAujJGsTtgA6nJ+WypOntPEt7NzuCRK3ag7RoGIGY2NLTvAvZrBpjnb9Q8OcU
	PMUqaD1WisBIl3KQ+VBN/rRjcTq3BTbF30IMwvTrKOTwAaYXlfzkd
X-Gm-Gg: ASbGncvw80UNl1Pnu6kNRs74f9Q0FYCl4Jdg2U3SmhveFnt55NDfXAHw/GZYp3rXX3i
	hARef6C7xt9ItjE4NQO1zD4CPlu0VHLFnpUDO7gkmsqJoX90PWPbLdvZik/stTOQXomSOCKKc5E
	LyatSSAH4VNqJqObxJfDJmMLU+lLuMjkqaDbUSf+bXHt1HHGjdAW9o4/VUr0Aw8irn3MPD9lWlM
	UeVi0BQmNwkM3ZO5uN1vqNoDcIciBUJ/1//HMU/Zh+UaizXbcb1/rr2EhSLmae/wpMOrDBHCU2o
	UjGXJ7hMnX1sv4ZFzyT95lfK/UxkJhSmBERL9NCrdKLxnj4oJNQA2/lJrF5nlFJc4j9zNODIJsa
	9x0U=
X-Received: by 2002:a05:600c:5486:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-46fa9e98810mr73730075e9.7.1760082032387;
        Fri, 10 Oct 2025 00:40:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3lq9nxHi+CEqnziqdMyoKoOLYsWDdxhE4EmiTf95ov9ATpNl2HHkuJv4MfSmlUI8Cd+bijg==
X-Received: by 2002:a05:600c:5486:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-46fa9e98810mr73729925e9.7.1760082031973;
        Fri, 10 Oct 2025 00:40:31 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3d2c1asm54109495e9.1.2025.10.10.00.40.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Oct 2025 00:40:31 -0700 (PDT)
Message-ID: <1d7476e6-5c6d-4175-b28d-3622222ea8e6@redhat.com>
Date: Fri, 10 Oct 2025 09:40:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
To: Gregory Price <gourry@gourry.net>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, corbet@lwn.net,
 muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 hannes@cmpxchg.org, laoar.shao@gmail.com, brauner@kernel.org,
 mclapinski@google.com, joel.granados@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 Mike Kravetz <mike.kravetz@oracle.com>, David Rientjes <rientjes@google.com>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
 <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
 <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F> <aOdSvriKRoCR5IUs@tiehlicka>
 <aOfU9YTKMPWzYOta@gourry-fedora-PF4VCD3F>
 <ac0393c7-9c0c-4b4d-8b35-5e6369e5431b@redhat.com>
 <aOgpz6no2Jx2-Y8Z@gourry-fedora-PF4VCD3F>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOgpz6no2Jx2-Y8Z@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DgHjAIyZ72d-efNytox9pqlUAfOYFEEKPxSJJwCR5Qc_1760082032
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8CE0DC000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mtgih3wa8erubtaymw53m65bgo3dt8ds
X-HE-Tag: 1760082035-844716
X-HE-Meta: U2FsdGVkX1/PyE+rAGYCce7UqXqaPESgGznZJQHvmyb+/h8UX5pGC8CKeGlOFJPWZ1Qkxme8FzfcPZsQptjikNtzHjjfCtD2iMscAjRBJIzpLVANSTlSuvIcdTfUgYRn1PMkfpFa8gX2nMkcep+gUucGxEhHWaw6zZU4c231w0DfmgkWmznH2uZRZ1vPf8M7GRD3+KARcfhKLSUxr8PclP+K7LmUVJn/1+1Xtsfilkwo8r+99E78mRc/B+HaS15CaClMCE0sLIYpOE56dxkSu3E3E6mdco7dk4uILdfJGZAHDjqMHb2WBTluxCLdOWd9OVAFHCSUFsiERudI3a+pQG0/0EEOrqZyVz0PqTdROE3jdCUIV61ETYN16t4ETaUw5rsn96Kh4k73QtZFqHWDo7Zs7NPfCQnjUCd35eDZTEb0GwlN/H7ZGsnBO/lwf9q83rkXKAOCjrtDKNz2haHQLSXdTuBfigx8Nnd9Ou13VgDNn+pEd2qdKKJeqd6/uiN6aK2KWNKMsYzAgherjsRyGcjrvcZnwdIhmqyzDDNjGUbumJfGnupsNhYI5YmW8StVUKC862erYy2cC8f/b3bExBx676ix22YZt0CXT3oWJ2Svo+jv/u3Xm402hUOdiE5vozQIEQc6dyv6rD6v22QjA9Avifc0KdbQmeSe/6hGdyfxrcknwmHgLuoDcKqZ8/EIiyAC9UiXXrf57+QlzLOokld3QiBArWDpZSSc8+C5/xvSnfbB3BMk9gprRZHpgjDnGLtW6lmybSVovNNRmopKgZoZgdnJcKiPltNgS6PbVX5ldux8e/wngN2nx9MxAS8jQawXq9D72dEjtNQuZzYvA8apEgLZPszKjfOmDaLf8mxGvjrbstjsCtuZOg2BVkECr1Ht21DZGKCqEE3mXbrOImF8hqXqylUT0PQiJxE9wJiwAzsF5lSgPbdRKO1A+Q6uQ82/JQ3Krbs69rKU8Y+
 sWSoXwAl
 XW3ZE3Bo2U9H3pRVlQeNqj0VHw2nPbWrUqoK4WSGXFImqeDbn5IW4jVBHNnbK1NLQvFGslGNZymyG6KK2fuWeiT5k/LKdZcfIgOmSCRwYzjXMqbVlE4wbR32fnrwe3Cfrs7psgKqrWzFUZpEcyC2/URs6zN/fgPiis2xV+PWPaZDY9sVnZayt9wugyKk+0/h1/L2DyQHRvRrEnTpyh9UjtD8lb1ev72R7+SjixrfpcJ+E94S1vfEWMkEaeI6KBXGOwFoit7Hx92WCILzzuy8egGeMXBQ86P9nARdRNFPUFNci5byITjnXHfFFKSj/usT9kklE9fHsW5jFiTBG03bV7xES+3Mhigvu6eCTyaFnW+TpFYvf0xhTDMBD5HoRlSweTFF2ddzMbsPH9iuRqdlC9qXqn9/Gga6ieK1LrI/3v/K0JmJEHuyOtVmpUDqKPxcAkWe9HFBIiEMA2SGZ8I4tTubun89vMLKMWWoWrNWWy9ZTAlX4hyQSvOwItH3D6vxBkkEIomzukxPoKfIeArDYgXjaUXFd4ZHHPYQPsppJxBiE96q1G8coBihbX7hjtj8cj+voSYeJ9ls4fP4zfVAp8a9VZFSt/PK7Q9YixGU1Rdg0a022QC331e5m6WZLI5DG8YeXt1lMxkqNnC/cy49orusn7irhvXdjMSQQaR82sZJXVwbU1zpKrG/tTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 23:31, Gregory Price wrote:
> On Thu, Oct 09, 2025 at 08:51:54PM +0200, David Hildenbrand wrote:
>> On 09.10.25 17:29, Gregory Price wrote:
>> Or would it be sufficient to selectively enable (explicit opt-in) some user
>> pages to end up on ZONE_MOVABLE? IOW, change the semantics of the zone by an
>> admin.
>>
>> Like, allowing longterm pinning on ZONE_MOVABLE.
>>
>> Sure, it would degrade memory hotunplug (until the relevant applications are
>> shut down) and probably some other things.
>>
>> Further, I am not so sure about the value of having ZONE_MOVABLE sprinkled
>> with small unmovable allocations (same concern regarding any such zone that
>> allows for unmovable things). Kind of against the whole concept.
>>
>> But I mean, if the admin decides to do that (opt in), so he is to blame.
>>
> 
> For what it's worth, this patch (or the new one i posted as an RFC), I
> was able to allocate gigantic pages and migrate them back and forth
> between nodes even after they were allocated for KVM instances.
> 
> I was surprised this did not cause pinning.

KVM does not end up longterm-pinning pages (what we care about regarding 
migration) when mapping stuff into the guest MMU, so KVM in general is 
not a problem.

The problem shows up once you would try to use something like vfio, 
liburing fixed buffers etc, where we will longterm-pin pages.

> 
> This was all while running the QEMU machine actively eating ~2GB of
> memory.  So this seems... acceptable?  My primary use case was VM
> hugepages, but it doesn't even seem like these have been pinned.
> 
> I think the confidential-compute / guest_memfd path would have an
> issue, because those are pinned and/or entirely unmapped from the
> host, but that just seems like a known quantity and a reason to leave
> this off by default (make them read the docs :]).

guest_memfd allocates folios without GFP_MOVABLE, because they are ... 
unmovable. So they would never end up on ZONE_MOVABLE.

There are prototypes / ideas to support migration of guest_memfd pages, 
so it would be solvable. At least for some scenarios.

> 
> Seems like this is pretty stable tbh.  Obviously if you hack off the
> node0 hugepages migration fails - but I feel like you're signing up for
> that when you turn the bit on.

Right, just needs to be documented thoroughly IMHO.

-- 
Cheers

David / dhildenb


