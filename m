Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B23ECA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 12:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2E08E0016; Tue, 19 Aug 2025 08:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA488E000B; Tue, 19 Aug 2025 08:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9198E0016; Tue, 19 Aug 2025 08:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69A858E000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:31:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EA53C064D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:31:13 +0000 (UTC)
X-FDA: 83793442026.01.EF9A6E5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id CD3F380019
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:31:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fHC67HYi;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755606670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yb5sv1zr5rxUlheY9XAjFIdy+xQxd/kDQBOVar/9xqE=;
	b=j8fTZsKlmHS90YZA5HGLlE1kCmYGJUGmlCbux71ulwZVQiYr+cx77uDTGy0PfFrbPShv7Z
	g6VMuH5mzsy1RpSJQCaN9KhBfzi93x7daaXg4O9yLFByQ8pNxpaFfTFYW3LCWCxuLIqbaT
	FgBCBRjTfl3grOtoqfeER74DhwBf9y4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fHC67HYi;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755606671; a=rsa-sha256;
	cv=none;
	b=mc5O/d9s+VVrSv8RqE5t8qrQ7EuQdnPHYZ/FZqqwvUehkfziAS9S4OGx2+3AEYtQihpIP0
	ZAliMf58C8eV7o/NZVj5y6lNmn1MI6n34eu1awVA7EkAoIG+hlAFDXg+2GE2QvXkxox0zk
	AUZo/uNWeBqEjq+eHHOU/uwT4Lodmtc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755606670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Yb5sv1zr5rxUlheY9XAjFIdy+xQxd/kDQBOVar/9xqE=;
	b=fHC67HYiIg5eL0VWMt63wUpXnkejqTclimyI93BRAhfuWjPqLoO/mHBB+uo8ZDBjAqbf7V
	mqIN/T9NyvEf8caqfqyPsr+tRx0DQURcDmYTL+uq17lyd/cqoH1m4JU6ERG2XDGasigy4H
	NruiDs0o9bzB0Go/aP/7gQvSMx6ny0U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-2ksyHydAO9auHY8U_b1p8Q-1; Tue, 19 Aug 2025 08:31:08 -0400
X-MC-Unique: 2ksyHydAO9auHY8U_b1p8Q-1
X-Mimecast-MFC-AGG-ID: 2ksyHydAO9auHY8U_b1p8Q_1755606668
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b04f817so18799145e9.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755606668; x=1756211468;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yb5sv1zr5rxUlheY9XAjFIdy+xQxd/kDQBOVar/9xqE=;
        b=AYcuB3VXUand+HW4BEDSXCEtoGbqESsCJ+yCWST0ihd00tQyEeb/2P5sqnzlZLMnD6
         8dOXXIIvSLnGZZ0SS9rDXehU4t24orp1lUFtAZEtPg4x+/aKRGPGsKOYUxVrYhwX2j3A
         /AFDjdIPR7pfV/waaO5ysObakXbyrjw18gNoa+lC3qkDnJohG0G5KHtYkmXsQ94ALgDi
         7DCbm11XxvptOseYr7IBf8j0RzQvJszEq8N2920xVc5hpf3Vfpy+0z9JKzcYsGr1jo8A
         komQqQFnbGWdyI2B639Jjc07M7SXdH+u33AnKuTF5DFtOTNqPRuKJ3weiH+dgq9gbK9d
         PmOw==
X-Gm-Message-State: AOJu0YziAYt35yzUnKaNXoLODAWjnfDntXeWzenR2GxmZ1fncFZXKQIV
	P5vd+Tn/qsGAb9+KIbz//yfXZLB/vMXwBA1QM4cfUcSUdt8uKD4uTKzxfO2suUww054zuoqJC6+
	GuHh40cTKvljZmhkS2pQoTzxMFjdYo0uq7fTgdrQF/R7Syd8fhfiN
X-Gm-Gg: ASbGncvlDJKJnHxRp/xr2SMJShaYO91mrmlNWvp2D46yVaCx9sAucsoutp+wUiQcKm1
	VzcBx1enC1WGKC54hcqye+GrufwqRMqtsu1o8KBxxGgl3rjvVkJYY3uSbvwboYu5BReBSKQ0wW5
	0FMzt06wGzfEAD0CLYQ9Jiw58s9H0qur3Lrlm9VTItnHZv2biI0ghtjZcO/x9Dcn/YVSRuJC0RA
	4drtvaWEFufk7KYL+V7xLpl9fOn1vy2tuXr6jCZaBi7DVGtjtAAE5gRNwxD3Y/7tlHEI4zbwa1v
	fHQfm4mLI/N4QCdNIVBoUcJt6Hk0wWRpGJ6cHN2NvVshqXXcKqa0lTBarY2fsjBp6xmZuLv167F
	4nCuxidFofQ8RhF6er49nC0kDHtufwVOvUjQf/SAQF0tlsN+Fax5jo9g5zr5Gq6BT/bY=
X-Received: by 2002:a05:600c:630c:b0:459:db80:c2d0 with SMTP id 5b1f17b1804b1-45b44d6f6d7mr13425515e9.7.1755606667555;
        Tue, 19 Aug 2025 05:31:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEF9DqbnW7eCUmfGTMJap/d439sOOVnQK43Z23DtcxrFTUNNRVcaiz2wCYQyuGLZpijDyqywA==
X-Received: by 2002:a05:600c:630c:b0:459:db80:c2d0 with SMTP id 5b1f17b1804b1-45b44d6f6d7mr13425125e9.7.1755606667146;
        Tue, 19 Aug 2025 05:31:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b42a8f972sm42502585e9.20.2025.08.19.05.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 05:31:06 -0700 (PDT)
Message-ID: <1df9b8da-6462-41ec-9dc5-df99dbd8ae8b@redhat.com>
Date: Tue, 19 Aug 2025 14:31:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/mm_init: drop deferred_init_maxorder()
To: Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Bill Wendling <morbo@google.com>, Daniel Jordan
 <daniel.m.jordan@oracle.com>, Justin Stitt <justinstitt@google.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-4-rppt@kernel.org>
 <408d7eaa-5aea-4490-9fd0-978c4eb94d32@redhat.com>
 <20250819092254.cddlg6npwl75fvbn@master> <aKRUUzq48xW5qPOp@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKRUUzq48xW5qPOp@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TKexq4JYBpP-jzCZEMZ94OJ1gbdUtixwsen1QmnWf2I_1755606668
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD3F380019
X-Stat-Signature: 9mp959ff5wfnarnkdwk943jywptp4hih
X-Rspam-User: 
X-HE-Tag: 1755606670-697698
X-HE-Meta: U2FsdGVkX190I+v1mzlPcpU3Od+AtQPJ5+fFT/3A0B/OQUHHT+wrUpB8MOUBRw6Ll+KZSqxHDHE9obmEe2Z3AHgco9CT0EHYXWCHQqdtFNhOK1mdr33aJH0E4hKKXV3Js0m3ufu273wYuujVWM6hiVnddC4X/IYXPeyvFxPNbZEmY7pxMbIGvy8GPREiXcztehUEXZ8WP1eIY+wzu0A1ijyYRt/X3oSCn9wGEqialtvc5rapwSGs7pbgKuNbAH49d2W6Vu9zkLj7goBhdP0k0pXzUhc0S3mYZuWK5NpA2cDdUed9O+8p83UiBBQn67L8hUxJTftKmCUXBCSnT7J9c6ODiJzadTlLr54piFVdfq8hemJ0PhxlMB6FCLLcPqvNDYw9IqTVsf21Ar80YD553yReH+bV7WZRKLAGbk9t210sxZx6XejrTEBvKZ+GVJP3pxETypO92WCFMd0Ulj/HNYeE1W/oTpJiZhuEehpWlVjA/k6kauf/R32AKkVY+TI/hAJKAHnuauYR+zpv27UjSwqCgfmPxbXEpXxNt8hU1Y80QtGkP+m62WpohlQM6G5d7sZnN7kScH/uBHykUsdXRyUICLg7AUus3Ck8BqKGhf8j3n58FAoxwHKuzac3ueR9T1ARF4Azs4dhMjVUEQLbpKmd28wa4wCxAk/nJ5gxJa1Ztz4wlKWwEJ7tenOaY/Fr+t0dZBXF8YKb9w/RfF155NINnNMEs5J6C5kKU19r7qmTvvHx7NZjYT6k6qJvQc2JSmuShC9rwJF+jf07oz5HHXRFRm86P8O5a4iebFYLJSHg/GcwGfOumnOnnLptuqsw4GnmSXcgRbRKWBKiNnKhRbLWyIhfu7IhK9r8/Nc2ex4IVyCnoNBreQW8cKj5cEHfrNniuM9jEWDlEnisrCskFg6nsb5kRJ4vQKLjGXTPGXY95Qur0hIgaTT/Kdb9hCdOgG3B6cIkHlIM9rpWJWK
 IrMQbCcQ
 027kVLrwGmEFj4eFR9nPI5u7IEqHrLojI68C/cLEqxZT3cr4cmCuLu/uUnfYQ8vZQQVvFXIXvYlMvBweo78AEcuLRJyjX+VpvpXdZkp1rBHWILS+vegVMkSVkOpiMJ2tJJZzDGRAr6Z69MQMJanwyKWhpus1FKjN2qtUU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.08.25 12:39, Mike Rapoport wrote:
> On Tue, Aug 19, 2025 at 09:22:54AM +0000, Wei Yang wrote:
>> On Tue, Aug 19, 2025 at 09:54:22AM +0200, David Hildenbrand wrote:
>>>> -static unsigned long __init
>>>> -deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
>>>> -			   struct zone *zone)
>>>> -{
>>>> -	unsigned long nr_pages = 0;
>>>> -	unsigned long spfn, epfn;
>>>> -	u64 i = 0;
>>>> +		while (spfn < epfn) {
>>>> +			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
>>>> +			unsigned long chunk_end = min(mo_pfn, epfn);
>>>> -	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
>>>> +			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
>>>> +			deferred_free_pages(spfn, chunk_end - spfn);
>>>
>>>
>>> I assume the expectation is that all PFNs in the start_pfn -> end_pfn range
>>> will go to this zone, correct?
>>
>> I think so.
>>
>> defer_init only apply to the highest zone in one node.
> 
> Right, we defer initialization of last zone in every node and there is a
> thread per node that does the initialization.

Thanks, my memory comes back :)

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


