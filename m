Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00C35CAC5B5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355C18E0002; Wed, 24 Sep 2025 06:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E2E8E0001; Wed, 24 Sep 2025 06:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243788E0002; Wed, 24 Sep 2025 06:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 143548E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:40:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E2375B27C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:40:57 +0000 (UTC)
X-FDA: 83923800954.16.DFFA927
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 39D834000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:40:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T2pZxXuB;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758710455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYvl7ezRqdgxCLchmpqGNEskUuk4TYHOhQ80u6nmeiY=;
	b=mDjaux1rEAs/7ojgwYcyHQ0XRlYn3Pgq3q8abEMGMRhSAW87Ksfw1tC3crDD+1BtiPRilE
	NpI21RFX1ZQFgywyH50Onzq+vcVdvFxjLw9XM5MVWSNR2zxAvmsWNlRA2Wqcsb4RtsUm1E
	eS+2T0WosDJH86yG5O8FcQO4R1merUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758710455; a=rsa-sha256;
	cv=none;
	b=IlL1iuv2HpQcc7mwtUHKR07Ke9UhlOOiyZmEAFZ2yyT1ylCYLo/zTkZ+oL0ia0JnJyhtc6
	2F0d3gFM8SDm6eGIiJktyZdtudGRMeX7muR8DwxYIuEk/66Vsc1RdfJY51r6LGWVpQOETT
	Pl0u4TwDN0y5bDnZbfqkikIOqGytlTI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T2pZxXuB;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758710454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eYvl7ezRqdgxCLchmpqGNEskUuk4TYHOhQ80u6nmeiY=;
	b=T2pZxXuBvVxSXECEu8KJZc2ZYVl9k//JP7Tt+tABSm4kd5XwVPNWcfGcToxr15fJnME5tU
	lysJkvQM2xyA8iuklXtJI68rzUi0PR78OiJBL5Q/i+qcQmulLe2VKuLhuAa7sexCfTIXv7
	s2yWjAe6pR9lWX9Rzi9jLSmxf04cVWA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-6J4l1tOaMMWmCARnhrAOeg-1; Wed, 24 Sep 2025 06:40:53 -0400
X-MC-Unique: 6J4l1tOaMMWmCARnhrAOeg-1
X-Mimecast-MFC-AGG-ID: 6J4l1tOaMMWmCARnhrAOeg_1758710452
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f2a1660fcso53175215e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:40:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758710452; x=1759315252;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eYvl7ezRqdgxCLchmpqGNEskUuk4TYHOhQ80u6nmeiY=;
        b=fOnJxlLHxsKPkQ3seRCB98SLSuPNHQ2ZA76q3dKc2sL4DQX2mBnKe1Lh281FttDqLr
         8irCHnkykUHlCYwLpx+nf47XpNwy2IjYvfNDJezRVbl3DlzDgTppg6enSqetCgxCFyr8
         uYnQ/q26nm1KDhwcMGt+4epHCGVMnJL02VB4KL91WeoGwj38gvJkZTKmQXAok6zvR0ny
         GI/0moj3TCxZoHq4P5dfY4nGORg372kDw+x36sHW7eQ7sY7bSuoZLK/l7eZqufYTKjQg
         SPnyhMmOBGiqnCMj2E3gFqvzPY0oeVjB7R5NOTecUVOkTdPWMTM3q5VESBK1ZrX+KmF+
         S8lw==
X-Forwarded-Encrypted: i=1; AJvYcCVPe18Lh3G26tLsxg5gx0vVrfixmb3uL0AwbzSnT9mjKXLoeHhOUtszgpKEzr3Y8yC60m15f8febg==@kvack.org
X-Gm-Message-State: AOJu0Ywno491XBXiT7Qpw6Kl7nIfsq0F4BcQs3FcnpqPxEYuuTarVySR
	akTyz4aymwDP278ph/vxCM9WjlNGvXfftlil+ylSRu8yv580LCHEQI0lVVnZ8PuVNtParl1w4Q2
	HNY65bNKWZkF/F9S+BPJwQa0rn0yTBci5Bnm8nOZjRXPiEYTgvg1B
X-Gm-Gg: ASbGncteHMSTpnd/QXbDfVNdzZ8uvzhu+GYhSgzhp1gt55i+VwBQvLghgNNGgMPYHGG
	WW7DFQSDuxwRkfneYgNAaXsN1cRrk6yvJoylqMhlp2DfWCZBmVIhDp4gvX4O2BIrm8OQm0gO+vz
	iCuzNNgMW6liF4bRwHgGal5iINU2KUyN5CZXn/EYJ395vL/Tww5xa28rYC7DluvqTzoySVUofg4
	WE04juktfr1MnyWndRfB8WiLe3en3FZBgZdclhblppbXhg4WbIZIDrcjVBwwnKob0NDGnsgNDP0
	Rc9ZuBXoELpZv316ndAdie78t/VYyEAHUgCoWBEmZ+ov8LoYEGDYmnOnALW17AGy7/TqY4nBBnX
	AZrtGfEg0bDweZUxGTarK0/Foem/yfD1spmOZqIL8xoOOe+s355/SDGjjLQRs6e+vNA==
X-Received: by 2002:a05:600c:8b16:b0:45b:7d24:beac with SMTP id 5b1f17b1804b1-46e1d988acamr63832465e9.10.1758710451994;
        Wed, 24 Sep 2025 03:40:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGQUGWyhr6bvPS0QO0bjgArU7ygo/54DWi914RDCMaEcYUUvLnJDJjf0YevNsZ43xh89pWQVw==
X-Received: by 2002:a05:600c:8b16:b0:45b:7d24:beac with SMTP id 5b1f17b1804b1-46e1d988acamr63832145e9.10.1758710451594;
        Wed, 24 Sep 2025 03:40:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9af775sm26973055e9.7.2025.09.24.03.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:40:51 -0700 (PDT)
Message-ID: <bdb25331-4273-4bf8-b095-d052e5124003@redhat.com>
Date: Wed, 24 Sep 2025 12:40:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: abort collapse scan on non-swap
 entries
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com,
 ziy@nvidia.com, richard.weiyang@gmail.com
References: <20250924100207.28332-1-lance.yang@linux.dev>
 <1282de5a-3dce-443d-91d1-111103140973@redhat.com>
 <2i5t62obfweid2zrt33vo3boviw4okha4d3gglw76eqv43ofky@pdv3evw5yjmh>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <2i5t62obfweid2zrt33vo3boviw4okha4d3gglw76eqv43ofky@pdv3evw5yjmh>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: azyXJ3oJ5qvnX09t21EKk4ZAzLjDkPsfRZrkIhJpeG8_1758710452
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8qqjsj8xzxybiuzufho4yc73o3zm55jn
X-Rspam-User: 
X-Rspamd-Queue-Id: 39D834000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758710455-475293
X-HE-Meta: U2FsdGVkX1+bJ0nfV+WkHk0IeKDIjeVMheg7/C9WzWqDZEtLgotOPBr051wlJj3Y3cnLOXgfh4r6xjfIpb2EIj+wg6IEOpXbn7eMWxoqw53eLFlKbpKEsCDAgRqQt77okSgY7dfQQzwkOeRaCTW+N0flR7YilMgGLn+PjiKqxInJ/G9+ujbTF73tFRzo2lNli8L25u3FBs+Sm1L8CDzz+aGwHW4aG9+uwZLo8BGZr8jmV7RHsS4EuSh/MuN4F2a4QsDZmeAsJ27gcpKaKB2QEt91FgKM8+xgdHpFof2bhz3DxoNkctZgy+tZjDAgG61JgzSMq4xS769eUUv1PI5qWagJgOHd9bWVv/eT2tDt4uj20BGnqam64QfdXskD5XAxjO1p407wY4DuJOmh3UJLPuhkp0oXemBy57ZQwMyna7qGFLzkUQwN2polz6RgxE9LuwXm76FMYFdKDxKmJw1g6osf2JGmSqB/L7ozKijEpXgyi2/3UkkUS6xN2kTTWfj0qZiW06B4wyIqEDWm1bixRerm1n/GJyvAk4zrYBQnGGIntEc4eqKaAR4oj80BmoYx+0iDNltrdl9HZ4X4+IE76s7VQB9KQOb5DVnWi2FoVJ9ZoMJA+b0UvjJJqPWtZilBWxjpzbTGdgKEp0iVGloBeK0h7LRL22XgaqPSdd+m10R6p368ksPx6Jc2QPLOpFd7gda0rYdDpixs0AElDF3G0lQGyYHe5U+yDZWOB7TST7HI7GvxTfbyM+hA4FjPVxdGAnG18pexW/tkGiERIXMRrXV4hs3BXpS9X4qIiScv8+RPxxg2u/qkJVN75K+foo6SMm4NFooVFPBwQVCaRJNnJ9cgj/0HZLHJMvhSY1tgQk7djjI0a4MqAO/OxwV+A/UokRi0nofbKnT50ZWtH91aarP004u04CkmWXm9fPhfoVV39CtZc2pLbu9Fh090Gp5H0wfaeI0kSYnBVLPzNIK
 FxUHW9TC
 AsunQmm8HnoFtbL3G+CpZQgjL+rwfuyMQGmeOGPsC8NrWbczmJ4/SoMaskevW2TnLdWo5ikCuBBwFwQ0YIYOTpmeZkTR7tsUD7BnLsxbfCwiOfvqItE7Qe2r+vkfLXRtHHUqUjU/JyFT8Jb3/kRTNYlGKOVgYpJ3/NqLaXUSAVVnhaESLmWWoM6/dfh8UPjQGe9LP3SgYXIBT9RRT7/MZfw2BCPYjsbo1MxmOQdB1azv9IJu3fGTeCtjsQTet+P8iuAhtK1BCVzekTyt6En7iJoKOBwZnOJTxIJoz52WpHPzDIL0e5nVkyBbxFEmbZGVRlvUqHom9TgiMLOkktb44CeGOsft07RKaB8uV1M33v4mg2AHVZcILlluD0jJB+O7XD+Zvi15S49bfiYrBfStjihQZkwM+qelgjkYxmU/wLffv7Ih4e1Ljh3sVKVzRDXUdMJcOWC455R7FBZbj8rlguYEwxiHaxTTTOdFR8i5BJz2eGURjYuIbE/wx3dyKfwWcHgP0wkOqBfqXrrEBwwskbnjjA9PU97UYEbZ2XTeS9+WmEdEusf8leBFLmKawv5Cv/5B/4kgsYB+n64Vuub0wWFWIhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 12:17, Kiryl Shutsemau wrote:
> On Wed, Sep 24, 2025 at 12:10:47PM +0200, David Hildenbrand wrote:
>> On 24.09.25 12:02, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
>>> markers. Other special markers (e.g., GUARD, POISONED) would not be caught
>>> early, leading to failures deeper in the swap-in logic.
>>>
>>> hpage_collapse_scan_pmd()
>>>    `- collapse_huge_page()
>>>        `- __collapse_huge_page_swapin() -> fails!
>>>
>>> As David suggested[1], this patch skips any such non-swap entries early.
>>> If a special marker is found, the scan is aborted immediately with the
>>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>>> work.
>>
>> Note that I suggested to skip all non-present entries except swap entries,
>> which includes migration entries, hwpoisoned entries etc.
> 
> Hm. So swap in is fine, but wait for migration to complete is not?

If so we'd have to add the logic to actually wait for migration entries, 
and not count them towards max swap entries.

But that's a different discussion and could be added on top of cleanly 
handling all non-swap entries.

-- 
Cheers

David / dhildenb


