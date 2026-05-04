Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44ED7CD343F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 19:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5816B0088; Mon,  4 May 2026 15:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D456B008A; Mon,  4 May 2026 15:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C9F6B008C; Mon,  4 May 2026 15:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 379A26B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 15:11:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA0868A51F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:11:38 +0000 (UTC)
X-FDA: 84730681476.29.184D674
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 968551C0007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:11:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DjjkGbFC;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777921896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7iuq6SXJgFnLW/61pYN02H93hMSvDAtoawLpfedIWM=;
	b=gQcwY9RoK9fJVj2/p7hTxGy94LEK/yTAYHLrBv+WHNpj5PF/A4/cgoRcYaBYVE7Akepo8u
	wvc1OhbRjLxbeYE9Pl/rk6N8Ww/fnEVIFpX2gkWLbHRxaLI427g2PkM2l+HBYPx48OsX5L
	Ej238JKVbFBhKSvM1PhqzBL8WxBvM/s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DjjkGbFC;
	spf=pass (imf18.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777921896; a=rsa-sha256;
	cv=none;
	b=NmTxLXdA3CdArYFamqGCTmovMAHkMQHZRtK3iskGE7RHRB8mm2q7Tn9wD/aUM3I4GqVowr
	/XaWnDpMsFxcyxN9+emH+nhEPHgwgXZqE4MyKJbGmLj7p1fOD64CDIWQOOoM7xPqqRamCi
	p/2t/3EWT3RdY6vRbZamDhsewa2dlNI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777921896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X7iuq6SXJgFnLW/61pYN02H93hMSvDAtoawLpfedIWM=;
	b=DjjkGbFCjV1RRWTFFCIXHsYpkmMB75NTjadkEJGtuecpijrEkkNvpv+lImHjYRt69LgAvO
	Loq3Zv7An17TxYfKHkk3tUbedkLw9+Ibffo2Evic21NYsipX5Olg7I27r+48Yv0ngMmbND
	qsjnBp6nBKHcxlPaB3WwK/JiUT+WCqw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-_guYlLCCNA2UuHFYiaRGHg-1; Mon, 04 May 2026 15:11:34 -0400
X-MC-Unique: _guYlLCCNA2UuHFYiaRGHg-1
X-Mimecast-MFC-AGG-ID: _guYlLCCNA2UuHFYiaRGHg_1777921894
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8eb55e55394so974742285a.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 12:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777921894; x=1778526694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7iuq6SXJgFnLW/61pYN02H93hMSvDAtoawLpfedIWM=;
        b=kpMC55aTnDDoztTzAsTjnvpg8bKCaZ/9uHuHOj2GtCZ9LweOgtecwZd0IP0rtggmjf
         qw+LH82WuHtNICqIKXPD0dtZczEeFF3VtoqjN7jo8ruOB1DrV9lzSPGnr2rhWq+zak6h
         9DzwfNRaTr1MVnjw/GrnYLJsyuhe6X2h4kAR+nV+bMoVujjAutRPbmJEC7ohqxRXScL1
         av4u9GQzMMmbCEhLIWjXxTExHqUy/rOlEKmwfhAGTALE2yhiMNG32onCsoDX73M0Tywr
         wVciJCYbSfXLVpYndk28i7P3jO0wQZUUWcMl4E/wmRA2UorTAn463KIRpVCjZxR86EPP
         5uvA==
X-Forwarded-Encrypted: i=1; AFNElJ/npKI9I7v17Ezvq7HCkl5dV/6xk61BO8tAu3l+cbAlC6HSelcsVVJK6kzTYMGUGaqbWUkpGki1pg==@kvack.org
X-Gm-Message-State: AOJu0YxdK3f23ejKCnn/P0R4FjWeMS3+5W4ElL0rTMKioeD92vQGUs4Z
	4q7TgKTaC/+QMgJZ6zzANXNaXDhUig5BeTi/Ac9UhfkhEzHlNGuJtn0+mJVcyd6W7t8TnpPfnNx
	PMNUXCAnhJ4k//sxzsKksoTAFvgS9SEV5R64SZT8XHqtwOO8olFAf
X-Gm-Gg: AeBDiev1/3RGGixzvtdLBP16PW8opqKQc+BXbv3k/Y5RG99qgIux8I8GfHMbOCaevj5
	1jim2WU56P9OIvn0ORJr4pWiepCuxjyyoYtADhRiSqUCeR48ffZSAeJx6GzhbsNPcvWi4iPXYvl
	pLeYntsjVrqQB1W5sg4bvxL4cUbV2Q348rSsgsfrxaxbpgh34LmdyrwP/WcIDU/GVUNpD3Ihj2D
	HXBIX5JSw4AoMBmcTSulQrmqiNXB+3kv1cFqi9KgyHwIHhsGVGkbi3mx2YCl/xgaXox/0whs0Zs
	f5LkrF4dyZtaNDN4KFzeQ6D4RCtWCmp3l9tOR+XBMEpAHaoiOM/avfLOP63W4OH/Pg+Ja6yGKN9
	QYv0R617NPqfZUHPuKU6U3Udp3twkeKVO6qS84tsFPtwvEczMRYWegi//DLBTbRYdfs+FFme9j4
	NChQWwqj9GFTWkl0cZ6mcNG+A=
X-Received: by 2002:a05:620a:4104:b0:8ef:3312:a155 with SMTP id af79cd13be357-8fd158e728amr1702261385a.11.1777921894196;
        Mon, 04 May 2026 12:11:34 -0700 (PDT)
X-Received: by 2002:a05:620a:4104:b0:8ef:3312:a155 with SMTP id af79cd13be357-8fd158e728amr1702254385a.11.1777921893646;
        Mon, 04 May 2026 12:11:33 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2cd04de9sm1152274485a.44.2026.05.04.12.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 12:11:33 -0700 (PDT)
Message-ID: <e97fced5-c544-4a9f-bf9e-a79272a41121@redhat.com>
Date: Mon, 4 May 2026 15:11:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/9] mm: thp: always enable mTHP support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <20260503080236.4ea7f3fec0e5788d50113599@linux-foundation.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260503080236.4ea7f3fec0e5788d50113599@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j00LSER1MNG_JB5QSf9N9JpfIyIg1lO7yPBBWdRyC_M_1777921894
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 96o3is3ca11ww37od54tic9o3nhyty8z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 968551C0007
X-Rspam-User: 
X-HE-Tag: 1777921896-334457
X-HE-Meta: U2FsdGVkX18+SRMZq//JIuhZ0IAe8JuVzZ7yL5IWVDalO9i4ojC8g5tXTgKkU5cp4YV3sn6unRuc7sOxOjgNbWqEkZk4uECWcHMPcyC9Pm1SWaDPXfxPxLGsbFk4aflHBtVZ7rfqW4fFYpFFQgfrVfa75sUJ7imR79GBKS5e43XtlBFplvYoCIIDeusi3e91e9qInvo6se29+8kOYmYYUSBYeT1STWBXRhAgtZK5TwCKA07mxoY42gDPkMfUeWIA1zZtYUqeVQKHzhzXiY4E/J3kS8hETg26a8nFAiKb+e4MylWhh//AD8L8oVa6vfJQt0g1tw7Kfz+hkZszyPG8DqUOxY58gmDJAIgf+b0hNNm2M/jD5wuLcI89h9YwD9YQGfp/IHTzCFoD921abnL6EFMuuuO8eLNVApunOVE+Lld0lQ8VHfBzEV3SONXT2iMffNq7Cn1KXN81PBFtFzkSL6U1nDNqQnP1fSPyTGyA6Da/0kPplMkX1opkzlz9dTcI53pk/neYLuDalc6wRtXiAXeh0mPdghIYACzGnGcyMYQRh074F7S6P29PC3Y1r9t/Wtpe8DFNQWUgXAjR3r6V1WuAdYaELOc5UUe9BbuErVJwdtIzV8IXve9vJ+Rv7INq4v8FeXRGM7tNENyiDtTkqmmow8+W/4hcJq9DilI1IntCmxmikW6Yqgu6LUhqQWG3zvhJSw4Vpp9XprsFYtYWh1GF7sNzexajkHy3ssX0jxdd6cxiam8JtvspWw+2PtX3V6gVX42i4Vh1A/yNgxQJxjPEgVu2yQJLTnEQniAznr5vewrxiy4cjVMdokuh85eauQv4jY49JI+WODYwxBA6qdRwGlk//vsaFeW2u/bmOir4z4UN8i/jU/7cNq2va03RNN/SLipc0ZrHNXF4h8U2dfAttEbD1fyv7/f94QtNTlZ+JzsamZYGxRG7Xns3g0znn212KsSMbfpnndU/6Z5
 ISz2RqAG
 iGi8XOXt1xu9zx+uWhG+wm1iwdWyPGnascQZlth0hk+sUfPrvZP5sD83xixUlD5WmakVqx2D2mHuzRF0PlyiZD4S3hwqPo5zks5f3NpfUpFoACkoOoloEjYsASioRoy1LZ6ps79A+QPKeBNXWmle7JUA5XsqZcN6/cEkG1t+iVfGJb3yGhTbk3/dKeTcgAYpQT2m/WLPLWgge0x9DnAlXzjyi9D16Z4pFlxRsvcMgzf9nv8ROr9eKj2D8217P6uX1GPCeNDX6fj4sxCZvd9eCEQxh2tLuiiueS78cTkLWlm06E5+iLQfqXksGctuVQ5UClT10ylraBlVqUIQ2E14sJRb5MGM6mypyJsjHpeBqODwLgpXMf0BSrRDJCRycWYFDTfnc1OU0+/McshqTez8ex0ABZhC+s9VuvF2ipNa3nlwjQq6HjEequddB2PyGt+k8Pbmqh/X+cEqshcrWykKI2E/ByOV5YTPKfwyfgbwsU20vTVDjDbnnyYKnNx/kem9HisN3fBgxyyZ/BJksXWx/zMNlAesc/FOsQXV9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-03 11:02, Andrew Morton wrote:
> On Fri,  1 May 2026 15:18:42 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:
> 
>> Today, if an architecture implements has_transparent_hugepage() and the CPU
>> lacks support for PMD-sized pages, the THP code disables all THP, including
>> mTHP. In addition, the kernel lacks a well defined API to check for
>> PMD-sized page support. It currently relies on has_transparent_hugepage()
>> and thp_disabled_by_hw(), but they are not well defined and are tied to
>> THP support.
>>
>> This series addresses both issues by introducing a new well defined API
>> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
>> new helper, we ensure that mTHP remains enabled even when the
>> architecture or CPU doesn't support PMD-sized pages.
>>
>> Thanks to David Hildenbrand for suggesting this improvement and for
>> providing guidance (all bugs and misconceptions are mine).
>>
>> This applies to Linus tree 08d0d3466664 ("Merge tag 'net-7.1-rc2'
>> of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net")
>>
>> NOTE: I used Claude Code Opus 4.6 to *review* the series before
>> posting. It did find one issue where a pgtable_has_pmd_leaves()
>> check was missing when assining huge_shmem_orders_inherit in
>> shmem_init().
> 
> Thanks.
> 
> Sashiko found a few other things to ask about:
> 	https://sashiko.dev/#/patchset/cover.1777663129.git.luizcap@redhat.com

Thanks, I'll go over those soon.


