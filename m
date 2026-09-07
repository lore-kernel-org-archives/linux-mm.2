Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3449C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D366B009B; Mon,  7 Sep 2026 03:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0153F6B00A0; Mon,  7 Sep 2026 03:33:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48F66B00A4; Mon,  7 Sep 2026 03:33:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9F226B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:33:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 456A61202E3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:33:30 +0000 (UTC)
X-FDA: 85186150980.26.4A5E94A
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf12.hostedemail.com (Postfix) with ESMTP id 585C540002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:33:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=x3+RDOpg;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788766406;
	b=aFBwH3FB4Wc7Dx6S5EQr/Le/Y+3YhodkcBCmoLjg3D3pvvDyzW7WN658gKsX40WEFY3ot+
	Lh8pu3sVKyGeCTjMSoh/G8Wtv7oyTayrVEqvNlF6RNVADPygjV+LBzhUbEQDp4VmxDIPMm
	IzKxcynJLhq/AkYjA3xvK/mHHPFLby0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=x3+RDOpg;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788766406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LSq4ZQqaWk+5Q9B9WXTtDjEPfaekNXw7DoUsIzmzTV4=;
	b=MyPEbipOyi2q8U1F556r9RHzoXGwWMVDEIOmptaGp29Qocet53EVASGyQytVM7AVjeUcaJ
	h7CqKTRJCe19NjLVNjl11OpokEjs7T1yUGkxTddeU8r/SSjnXOUxrt0QQj2WeconAZGrZ0
	m6gbRuO3bNq2gAha7hLNnWmUydv4eng=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788766402; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LSq4ZQqaWk+5Q9B9WXTtDjEPfaekNXw7DoUsIzmzTV4=;
	b=x3+RDOpgVFdsc5nzsGV8pRT9pZJKJ2o47kxFCecOKSWdux1IXx0si1NLkuoxZdCoMGV73XJtwjscwzpPBH5Div2ujXWfBKteKmpzkU3DZviROs8nFtaVT2oR11GZjFF7/RDogP2BAUuV1+GX7s0Z3Jcxkat6pX5ywfA0c+avZz0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0XAQkH3p_1788766399;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAQkH3p_1788766399 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 07 Sep 2026 15:33:20 +0800
Message-ID: <30ab6d94-2053-4c32-88a1-36def010cb45@linux.alibaba.com>
Date: Mon, 7 Sep 2026 15:33:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] mm/khugepaged: drop redundant mm_struct pin in
 madvise_collapse()
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Zi Yan <ziy@nvidia.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
 <1ff754df1d57154e01356f35d72b1cb06c0f8664.1788533997.git.kas@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1ff754df1d57154e01356f35d72b1cb06c0f8664.1788533997.git.kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 585C540002
X-Stat-Signature: gof5ca6d9anpy9snphukohm3eustzqz6
X-HE-Tag: 1788766404-896115
X-HE-Meta: U2FsdGVkX19DS+ye4NTgB73QJKab7cMGgLWcro+mrm+E1pPZfmdQRK6Yso2uFl2/ErTovGMFj0rfm3G5j1/KtWxKl+Qm+PinSUtHkjd5G+vEKJ3T/280fsg/FX5mCxpSOfqICq65Gb5DKSbr27jaSvaG78aL525UbSiwdIDJZXInnuipjggEJ9CR1P5xLtL8Bo4tBfC45akBvYjTmHDqv47/YTsGYwuvQIBF13mqjoiCTBjgJyGFc+qwxrPbOtC4263G9NcNXidcC/YI52lUL+CnqYMsSBU47LpPwuweNVRyYVlvyJsjRpdoHb0L+2m6XAmqL9Yippr6Im7i6wQ5RKD8ALNDDOaxkKGn4XsL3HFyAPVfyN9gPxyMxzuzpvqvwQNYKZQdq4EZoI7DZxVvu85qwuho/QhDKGylSbCY3iR91AN6grMFtMUZo9s228qRqpwX1rfa9ktLju71C00RtiyRtyshd8RN4p61TJaf+ufNwcwQQlywvEajR3wljWSTovuqsbmyARIPQusg80MeMZNO/8W9mGRePGuGZ1t2tNhF0ObQw9YYpOHz/pUEDB2Qveqq3tOK9nLNukUXCtnoi7WrRZ/CoCBxRnT0k31ALxBI78OkuTtEkde4xVUct+QjFWVIlu3oP505ydiGPYZkXz6mSsGjIKIlgxDq4It64RHMJ2tvIu48j0rx7TgsnW2+xXteWxC0HZ/B+O+Xr4LmGe/ouZ7XBZQUw2aZbYv2akIUsLWmbhEImZY267ATkOVElnC+oQt8g5s7e26rmHAiXCAgRUEWgNOQ6fhUWXR9pK1GX1FjC9jH0QdzwHv0TgXfGv0G8S8cJlxDMVrZehEhg4n+qjgRCLWxncSRkqXOtbSXOkGM6TDDPXuHr5EIwRMGU/KlAhJL6I4uNMnH2w+23XtlWGz6vF5hhJUBPT2Uv0Vr9YFR3l0zXMFdxFc0dF87UoO4Yt7sB+duqAQWsK1
 s4sFwNu8
 xWiU/n0uvwPP4Lo83dEFapDje30FwNDX0OWC47i9JhXgSbrhQX65sglZcdbuTrLNLD/RMXEiP78NONp3+EKN3nYxTgyp+2OkwuWnQ+Lg4d/zm/xafqJsKXkx8LcpwFZL7Gql3MNCWKlJM4rQu0RTbbknDoVFMtTBuwEqRUKNzxYWWJtI7c737vUOU/oFp+aM5iegoGELbiUw2SAqXlCW5AiAy9UWFel34H4kz39wzYFh6adO2+2SBN3pfrAnRCMFQz3p41FuFMwJlQfKA4inuJlimTEfkg2rM3cPJTYsXqzEICqrS5T3Qc8cE54he8rM0umokFHEbllig+L0CONzsimo5PI2We8CpRx2ov0Y70W8T1ktip3K7sGwBYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/4/26 11:10 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> madvise_collapse() holds an mmgrab() reference across its work. It is
> redundant. Every caller already holds mm_users:
> 
>   - madvise(2) works on current->mm, which lives as long as the task is in
>     the syscall;
>   - process_madvise(2) reaches a remote mm through mm_access(), which takes
>     an mm_users reference and holds it until the syscall returns;
>   - io_uring passes current->mm;
>   - DAMON takes one with get_task_mm() and drops it after the call.
> 
> Drop the mmgrab()/mmdrop() pair.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

