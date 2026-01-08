Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADE4CF6A88
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 09:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042226B0005; Thu,  8 Jan 2026 04:00:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019266B0092; Thu,  8 Jan 2026 04:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84ED6B0093; Thu,  8 Jan 2026 04:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D57476B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 04:00:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89B1A13B5D0
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:00:08 +0000 (UTC)
X-FDA: 84308199696.12.F772EDF
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 37B7020008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:00:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=tuxon.dev header.s=google header.b=KhUXuvpI;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of claudiu.beznea@tuxon.dev designates 209.85.128.45 as permitted sender) smtp.mailfrom=claudiu.beznea@tuxon.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767862806; a=rsa-sha256;
	cv=none;
	b=lSCAwsX3xGiBhRfixqTYTrMRKCOoZglbDbd6XW+zdP7fd2DCOIAZhJQjSXK9rnsd6PGz3l
	8QvggWsQEnEzOlx4XCsWgESK4uf4pia5RGK3T6PD9sM4DpBykQufddUZy5Ejs6jJSYVLup
	gnp/cZkRjnmb51MTyx5iUbovDkJZrOI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=tuxon.dev header.s=google header.b=KhUXuvpI;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of claudiu.beznea@tuxon.dev designates 209.85.128.45 as permitted sender) smtp.mailfrom=claudiu.beznea@tuxon.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767862806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Dz0JIfcV4CO3P6c2DrwWtVjC6ptmYvB+eQS/ThtTXg=;
	b=DdrVJFi8am+Pgcc+EHJlWBfztAMoOW1f6iVydpeYGbc3g+G1mwSvkEuh3L9zq01WR1HI+Q
	CDvRfu9jNuSA4UCgaTKBffhcrtkdck0IkiwFuZ2Ap6S3ESYMIpyNoZNIx9HU2oMX9pWs/D
	MLcntcruZBOqBB3m/mQ/jR2NKtC5XrI=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso17819645e9.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 01:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tuxon.dev; s=google; t=1767862804; x=1768467604; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Dz0JIfcV4CO3P6c2DrwWtVjC6ptmYvB+eQS/ThtTXg=;
        b=KhUXuvpIrwhzPxsREo40SX2pwLAK2ZA7M37wGR/+oEcQKTLWC5a7+0yO6ydRaSZKuT
         xymQH9knzNI2GlV+i0yI9Zpp1JsFvIlNv0tDEMFNJfhR1IrJRz5p+dkc0ZtVO1/06UfB
         4h8Ui4RkgsxGJzRc0ULt9OsZegd4Y3YENNYRtP6zQPrfq1tRsAeucak/xggGc68u2uOV
         tuerQkGDKEbmb/QE+KBSr9xNZGeUFuFN3ksw5uUWFn6mvy5+5k/cSPmLM09wZofzRtsw
         NxQYJZtWf0F+Ki8p1vzaobZtOp9xxwUoJjpOKnjoR2oGA3VsPbEIVjJUyxoJbwMPoVWy
         7FMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767862804; x=1768467604;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Dz0JIfcV4CO3P6c2DrwWtVjC6ptmYvB+eQS/ThtTXg=;
        b=Gh8F7TBptZ+nSFYIiAZVWdpZfOWEufGNvZ49yKZVbNLhdfSRWKO8EgovTVc/05Qo+n
         O2tqp9gSFMoseisoTQA5jzlw7q1BgjT2+hF1YbqvPLhgNlv/Y03cFaO6I4+czNdLVptQ
         wFQPDFAzRhUu0VBJ7IAyfB1BfEt5qvoPL7CKEo++f5qJ3Dy5f0FHmH2SMMeHbg1Aj+1B
         2G5ufmPMrX+aia1NVTlpQhfzjt4SOQnYIDj8WeP2504UdwESiGibtInjq2TId1D5E4Wo
         uH87Ek4FD2fgd7AObE4Uftk7uKeCQi5Y39+aCh2oXxKmDy5uq9jSqZ3qnsjWreLlyM7j
         oNvw==
X-Forwarded-Encrypted: i=1; AJvYcCWoCSjs995ykbyDkqiUfaP5oFm2EQ8rkPIurItNL7WTLXmpclQUjtyOuDDRKlC7nzDMRjjRSrmx9g==@kvack.org
X-Gm-Message-State: AOJu0YyRyb5bJL9ux9bREivLjgnVd9nQz0Fag05p8L6rhjbGMEXPXwLC
	001LEeGX0t9fcckgdVsRzx9/m3QR651GPB3zcjPQx1Kdh76AIilOll+1wG+qCxvG3j0=
X-Gm-Gg: AY/fxX4yr0+wynCyODKvoDrebNnxEBvICf9LSQPuw5n1FB40Fz7Pw+PH1HjsOK25HGf
	AtloiVlbmmNbjqpcJmoRXiIpB7XEGitoljPgn6Lx4AhQaaSilwWjbjTHw3B0xsSdGCBX+rhnBvN
	DNsZLz2B5e77zk/tAeE2j9FV4Ko3ILnbXYLhzTrvjeZRsMDreQCrNHovYfcFhZobwibSoK2YoRg
	BITU+RaIto8KW7THPyOpRxr9uP+EDtOy2tPvBIabd5oSEalSowFim1IAGPAMXaEJKb0tIq+Ruxi
	bRWbj38W2vfDC80kBZ0CIC15VvrzdIyK/i/sa/9ERegeL5omxB4cQHfxct/KRE4pYQup3mprtt+
	thMMrx44WyrpBJdcdNqKiNTMts2AqWFyBL7Z7sUsepN/TAnmWDmJmJTZoSag66ngJ9TdU+F27Pa
	jcDn8tSV+E7xp/0yBi5f4LGIV86XeA
X-Google-Smtp-Source: AGHT+IGBOgyBR0s3hrgTB2dne/lsAdJ0j0U2pAmaqchigKhpd3qvZ3sMNIFV7xxk2p9B6KBtQ+1Hxw==
X-Received: by 2002:a05:600c:4ed3:b0:477:afc5:fb02 with SMTP id 5b1f17b1804b1-47d84b34785mr74815905e9.21.1767862804412;
        Thu, 08 Jan 2026 01:00:04 -0800 (PST)
Received: from [192.168.50.4] ([82.78.167.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f41eb3bsm144539825e9.7.2026.01.08.01.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 01:00:03 -0800 (PST)
Message-ID: <42201ed1-cdc4-43b4-bd7e-957a2db520e6@tuxon.dev>
Date: Thu, 8 Jan 2026 11:00:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
To: Zi Yan <ziy@nvidia.com>, Mark Brown <broonie@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
 <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
 <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
Content-Language: en-US
From: Claudiu Beznea <claudiu.beznea@tuxon.dev>
In-Reply-To: <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 37B7020008
X-Stat-Signature: 6gr3qt5s9ihwcxea1jr7hhszuibfptbi
X-Rspam-User: 
X-HE-Tag: 1767862805-628326
X-HE-Meta: U2FsdGVkX19wBTl0s/Y2YEaXhYM3Pg0D5kbcMcJEV2EGz/XmPA5ywQv4n/Sxa1DEFNk9thaNqEB30ffY3F3CNahkikJOk2LK+C/+45g3H2+Q2Gf0dumB0vv3oJioEmFExdeNZ86L+qngTVk8z+HSWSuD1MpiUUfDjKq8lbKmF3QX1hozsY7xo77SjXcmNYL2qTJMsiVe4B4oFMbx7nwfVN4TTP+pmibC3amcbVmsTeJHqKsQeuTIyK25qzH7oa47jA5eL/Yi/GdmVZ6YV0xeRv9U4P7UfoiN63nQ1lqGE+82XRQqTb92xNIuxIrDzi/pAqYsNouicMYd19CAkQGBXIDmDxu8n9boakFJK3kFafjt2T9yHEeYi10JUGliw76q4O2mpxA8AJ+TW6xPn5/o8xftJY4DLv3kZmy43BTmISE7Z8Tzurcf3xiyY466T3lplmM6rdFmJDqPonimr6alwBUJbYUadXg0vxZ7Chp4azTS3AG/Rk7zHnAHBdsNRT8U73B1CYig/CUI7S7iOqa178kTLFrXlBGfcOVCvkznXVKBhInDfmXNZ8Vokuh8qlcDEEGnE5lzeXakeF4btUXZ+ma1A2G9/g+ga/V3VDg2kTFvnwGtFmBP+qnk2rfF7IPu/Fa6lj+cRgEelwcM305eJXhgllWRM7M8n71IaxCpNpU3Kju2xJdGfc7QbIXkwFFEBH769JsAThlUmxDUdtlhqkkHgDq/qkfMACcJ7BbZ6yXbCNmFkLhfIBwmg1nTgndz1eIyv63ZH4MQIlW5pEStY6/dF2E8ObU0P6RnKU4WpmJcUAChrnVgCBrG+7sql5w3Nbhv32ineCR+BUnSNGd6F4tumej/V4SnIJ0TzOeEfOoGuXjBvHV7WgfYxR4RKE9/HvPRdKLQDo9frc9CTTR7Uevh5dehYC4gDT3IuMS601LS/rT8Q+s+m4k/EwWedFZoFXHR3jshxBEHEviz18L
 kTMjj2P7
 8YXgPQH3WWxGEoNoXSfQSOM0lvVj0sfN7EMGm57Nf71+uyrHYUIouuVsa0GNuwzSt1awcRoLj8Fx/DYrCZGUD3Wg/mKTtWddH0IquyB7lb+Y47qVLZx87Jxeexducu9EG3J3Cj6jhmqW7yWRKVVJaFttRt4fke3Z/LG9J1nbpL1Rs2V8EkFMxpwzZDPrIMykFIKXiUnBgjwkmropsk0lJXacxbVqWkdAGzErPJX3Z+ICXDcWzqhku5h2rBDXDSHsJhfeMlgpjha6Akp1HB+wC7ySG5Ui5rcDzvbuy4aYPUMfyg51MxsV+E9/abqe9WJwG4j57OwPDAvSs5hJrJusotuIuvpYwWLruRMoyyI/vgTLubxi7/bLiRFFsou4BpbzFyL0vyvHm43qVfYKFL17Fdzr4LdMmGCdSlNJ6L3yr7aS9WMoG9aUyWlJ35XgBr8TBtTFGMIrG9N0u0OTj6xFbsRgvdD6hqdjt2dLV7lYROxzb8O8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 1/7/26 21:38, Zi Yan wrote:
> On 7 Jan 2026, at 13:39, Mark Brown wrote:
> 
>> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
>>> On 12/30/25 09:24, Kefeng Wang wrote:
>>
>>>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
>>>> which avoid atomic operation about page refcount, and then convert to
>>>> allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
>>>> the alloc_gigantic_folio().
>>>
>>> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing suspend
>>> to idle:
>>>
>>> [  129.636729] Unable to handle kernel paging request at virtual address
>>> dead000000000108
>>> [  129.644674] Mem abort info:
>>> [  129.647456]   ESR = 0x0000000096000044
>>
>> This is also introducing OOMs when doing at least audio tests (I don't
>> think these are super relevant) on Raspberry Pi 3B+ running NFS root
>> (probably more relevant):
>>
>> [   64.064256] Unable to handle kernel paging request at virtual address fffffdffc1000000
>>
>> ...
>>
>> [   64.087583] Call trace:
>> [   64.087586]  kmem_cache_free+0x88/0x434 (P)
>> [   64.087598]  skb_free_head+0x9c/0xb8
>> [   64.087608]  skb_release_data+0x120/0x174
>> [   64.087615]  __kfree_skb+0x2c/0x44
>> [   64.087622]  tcp_data_queue+0x948/0xe50
>>
>> Full log:
>>
>>    https://lava.sirena.org.uk/scheduler/job/2341856#L1721
>>
>> Bisection identifies:
>>
>> [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_frozen{_compound}()
>>
>> as being the comit that introduces the issue.  Bisect log with links to
>> further test runs:
> 
> Hi Mark and Claudiu,
> 
> Can you try the patch below to see if it fixes the issue? Basically,
> in cma_release(), count was used to drop page ref and decreased to 0,
> but after the loop, count becomes -1 and __cma_release_frozen()
> is releasing unnecessary pages.
> 
> Thanks.
> 
> 
>  From ece23da65ea7210e1fcb51ee9c27aec19b84811c Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Wed, 7 Jan 2026 14:23:15 -0500
> Subject: [PATCH] mm/cma: fix cma_release by not decreasing count to 0.
> Content-Type: text/plain; charset="utf-8"
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/cma.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 5713becc602b..408b07f6fddd 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,13 +1013,14 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   {
>   	struct cma_memrange *cmr;
>   	unsigned long pfn;
> +	unsigned long i;
> 
>   	cmr = find_cma_memrange(cma, pages, count);
>   	if (!cmr)
>   		return false;
> 
>   	pfn = page_to_pfn(pages);
> -	for (; count--; pfn++)
> +	for (i = 0; i < count; i++, pfn++)
>   		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> 
>   	__cma_release_frozen(cma, cmr, pages, count);

This solves my use case as well. If any, you can add:

Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

Thank you,
Claudiu

