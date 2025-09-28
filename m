Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E084CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 13:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331F88E0003; Sun, 28 Sep 2025 09:53:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2FF8E0001; Sun, 28 Sep 2025 09:53:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8648E0003; Sun, 28 Sep 2025 09:53:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5398E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 09:53:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 734BA82E7B
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:53:55 +0000 (UTC)
X-FDA: 83938802430.06.C0BD665
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6ADC0C0008
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:53:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759067633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q4BAbC+YrY4QIrrWFrLnzxWXP3+n6iKlcqstcDYpuuA=;
	b=AmgJy+aRXzOk1QbWxxGfLAFObGxP9g7GtaNb1glrUiS/PN+PwWyTX0Kl8q0Ny/EDnFS38I
	dspxapUJDfdaHni2NyQia9BhzrCeoDgC5hj2ZLTok8Blkuu7+sQWUO3IRSRSny2yqG33FL
	WkelU/Nf0im9JZ6JGPcbSH0CinCCI78=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759067633; a=rsa-sha256;
	cv=none;
	b=NxWPscaRB4IZ/jZIByge3jsbWlsYpC1Pvq/Qa1Duol3M1ZOTXgsOAw1thOfy6II+Qpj+2S
	4isL+l1hhSclqN6A6YMeqnMBJh6pwSJYzsaLennMWHtpzQF2JGtVfWUBHiQ9CxQPpCtFhy
	sHkjRgAsY+VQeBzUBkL/m29LjP95qY8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45808150C;
	Sun, 28 Sep 2025 06:53:44 -0700 (PDT)
Received: from [10.163.64.48] (unknown [10.163.64.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E28B73F66E;
	Sun, 28 Sep 2025 06:53:45 -0700 (PDT)
Message-ID: <c3817e55-4f86-4677-9275-9e08d68a0ed3@arm.com>
Date: Sun, 28 Sep 2025 19:23:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 1/2] mm/ksm: don't call mm_slot_entry() when the slot
 is NULL
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-2-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250927004539.19308-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6ADC0C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nni4kkj516y1noyhu1ymu5zcgxftfkcc
X-HE-Tag: 1759067633-558631
X-HE-Meta: U2FsdGVkX1/Vp5wYaAMEr7U7tV/KOvCDkaMKftYacqJaXZWlBzpMGGqiKKEo97GUBVrw6RguCnZjwZ48+MwucRVV5zCnPcE4nmB5VesZBlxOMtHZC96y9TLgINI3TLU7q+dfxW2Mo911PYGLUNijejvlIcyHyNM/pPUxRc5wAeoLWbghG0S+gNoXMa0C91vyKnGbXs1KIyi2pj1DI/AeT77Dd55mdgzTGHsCg/JDT8yaIRuhM+/DzuDlB978EAsubE9MJCtvS1gon/luIwgXkpB6FMo3FHdWlNENBwYV7aNAeZG9FANyib+IVbu5v66uKteTzY1Lf1auOUSVBhqKcpuubezY+wXuPy0SuvBguwHs/5e6Qhb6VZxwrZmdk//7H822qvqQLdXgbiumJdHjMeaCGnGlzVpnxiFYaznqI2cJJxyYWEd8zFHNdQqHi4slX/az2oxT8AzsGk6VNiZ9kpHCfNhsCcg71mEOCfOB0pAr8OpZppQoJVnNQZeup6gG/K6YTRt9i3J/RRTks2Gbho4xIEhl9sT3HXpJAjO8B8jqgDsG+uCgqqzN7Fy4kqhwqg1m3UcPtCJuJ8mxj91F+jmi3zQNYdJ4Twk0xyP0rzRC1fSJatM51T9/cHz0vUiD3gIQJLtbrTxl6SCTf2JhsWbAqEsuPqsQj6vxgypCzHgIWWlUBnIozwMZQn8lVN7t1p+/20D8ru00TuriV+5f69/4Vw/sR4DmzATFabqxe9f9U/EJlgzdMteGlx+QVLjtZnZa4clEFifVs7vpVItoKSYR71R6szaG1jzoUrGG9hEtA9A5NG11KEYUrzi3tZraSTFvszaVvFyZj8CvWArA9RevAWZlKLMWhEM6DXB2RLVq5vB6OkqoGD+At3B+lB8P5WF1tf/TpQbF/VIMApYi+eSqZmEUysO7k7BjXlIUZoZocwmD5w0Y3JI/yqiuqA+oFqkpzCjBscerz6R3Ov4
 EiM7tlDi
 QEYKDvXfxawwlNBl8qdDNKoP+xEWim9irG7NxAeGT2dm+/tlJclMAaiIggecOtZT2+wav9GbRUCI6B2NKQbAE8gEm0gMYYNi100Bxo3FnmXtmNWJG6PYQRPrnQex4gvuixkwQMc9o/olnMEQSsYBlx1kzij20ZRUhmy0aA57PGcidJe1kgjJ9qlUUf1lPksM8o5Lb9EGaREXHpVrDFUGgCv/ShARS1wB455JggFtbqug1+V0jNSBIN+KjtX3Azmd8t4/AW32a7mSjjYujOF759uhrh84z4/ugfLWkrlCMqqmYhze047SVqHreKBxI4hU5kqBAtu31SJBevVPLLM/Dg21tKRLsJyzzvSYr18o+aLPJKuSGUsZ4SzB0jfxV08pRgDxvY4kH1qwYW9312iqXUsQ5QfPsQwPk5Wg+StCn8lblGMr3wdwCaamoZbabEiLznECQeZdS4VP3X36OVDtc6bVkcbXb25k3KIy67pt9xHHMuDw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 27/09/25 6:15 am, Wei Yang wrote:
> When using mm_slot in ksm, there is code like:
>
>       slot = mm_slot_lookup(mm_slots_hash, mm);
>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>       if (mm_slot && ..) {
>       }
>
> The mm_slot_entry() won't return a valid value if slot is NULL generally.
> But currently it works since slot is the first element of struct
> ksm_mm_slot.
>
> To reduce the ambiguity and make it robust, only call mm_slot_entry()
> when we have a valid slot.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: Dan Carpenter <dan.carpenter@linaro.org>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
>
> ---
> v3:
>    * adjust subject and changelog based on David's comment
>    * use invert style for coding suggested by Kiryl
>    * drop RB and Ack-by
> v2:
>    * fix uninitialized mm_slot
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


