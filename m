Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9689CCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 05:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C908A8E0002; Wed, 24 Sep 2025 01:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41788E0001; Wed, 24 Sep 2025 01:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B570E8E0002; Wed, 24 Sep 2025 01:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A19578E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:19:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43A241A0702
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:19:35 +0000 (UTC)
X-FDA: 83922991110.03.9C173B8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 318711C000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:19:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758691173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjWTcjY5KQPz6JXuFDCIrOY2jisD0pzahtiNRUOMTWw=;
	b=WhVXhqDFXrd/hj4YvhF6nQxEDdK6nwi14/rVZ4uYXlbR7kyrdctFUSuuOA870KYBjp8F99
	rIH+WK/lf7k0UQydGxWUS2Wo05mzf6fZf5WBi9TkO4H/UkGMj+Gu+89tDFfvcbN78b00Ar
	GKAScBCOAOquLYSDjAzS73AnUWqo+28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758691173; a=rsa-sha256;
	cv=none;
	b=c140Yr40BQOljAogb3ONjjL7JVm6dDvyNB/6jX+uxdP6fGRjSJC3QNgIvRWlxeSKG6LYLN
	r3SlKa+bgsQBM3YalucbjcuwJLbwKt0g1fSkB1ho1hi+eBDmnNtHORFCUKPevj46wEVxQV
	KcDykW8C6oyapEpGumwDMZGdF/8syaY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3968106F;
	Tue, 23 Sep 2025 22:19:23 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B54F3F694;
	Tue, 23 Sep 2025 22:19:27 -0700 (PDT)
Message-ID: <9a4f1846-06fd-414e-ae5f-43d3d5270380@arm.com>
Date: Wed, 24 Sep 2025 10:49:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm: clean up is_guard_pte_marker()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: richard.weiyang@gmail.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, david@redhat.com, hughd@google.com,
 ioworker0@gmail.com, kasong@tencent.com, kirill@shutemov.name,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com
References: <20250924045830.3817-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250924045830.3817-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 318711C000A
X-Stat-Signature: r1dry5yxygadexmganh8zk6tb3mfxa11
X-Rspam-User: 
X-HE-Tag: 1758691173-94288
X-HE-Meta: U2FsdGVkX19SBunWUon4Yi1Z8oQPa+uOE9MfI3epNUKGR9LgaPrrmzGhJ366R23vw7RTk+S72UKtIWTxsDRsTGiE0on3SfFonMt7jFyA/MZVKMG0Lr6/U1jych+cxgeelQivY0yr5Uj8w8snUOJ4+Gj/pg+eJdvS3v4u9jZzzjslWKwy9L73vjVxGCZm29Ct1bi4MrcBzEaSG7AS40kYmplEHt5plpX3eQ8a3QACgq93/hPwKzJ3MCeAsbLvR0mtjLzXk0cQImykDDtS+QDyg5dvzeH724BeXag7+CJdhaJCES/c1HUwknU8JLt3TpzS3PMs7rGCmB6cUQn9noBfQMoEgBdVzWytx+0mlL9r9xQLjgjxtqominmxb8shpA75Tqbu0Rr/q4Mw7fpS3mgvPBtksWqAstE3eGBWDXRmzBccLsm/Bz//ZIAldzPCMsrs3xR8ddzzDmxppY0LwiDuBqJD1AoHHBt0TVDc/p5lTf4IQdzMC6EXCrxLtCBtgewWqIirzGowF7+I7PR7WP88+07U7uaXtiqFaGq3GDuEewdUHy/L8gJdbyj7BrQMyVCBtKDkcIwft9+yBjkkuvXANdcp5smPdXIrzKMSvd+qHiU+y0V01NLbaU6MlIKBxSvykB3TNn9MkeRcsxv83mrBzREN+oI5/kZrgZbjfWY6CgMyfKtMFQJOkJkwGtDayYJIihhktD9+D35oz6J5BEsCquE8FJgH7SK5K47gqhjw/Qw6Y6A868IQkpGdI57D5pe6H9YOUpEmsmw34MG5mI/MZIzCyiomyR0wvgbWg7QnPsJOUJ7lGFdqWeOuLW60Q1f68Jt4BajBq3a5b7umHJflo8B7LNhRipb3c12B8pao5B0dBT0E+UAGAVojxwr49cnFIFVGIlwsar4sO2c42N/SD8/Btc+V+hnU2E/PixotAFN9BTUgPzAdfWgR5OBS3gWW9aPLUK7HV5R/gvq023N
 TgXHt/XM
 svyA2Gtq3qK+0LsohhrYa4TXgBoZRpmLpytLSR+FQg5Vy/sAoZ4/bRX5+p0Y1ODxTutycS1osCbJULphH5L+zD2JYFyPsvwmRij68YGtUh6FDfEVbHxSv2MEN82B8ENhEc7JOX9oWq/QCWzpVv9HoaKxUme9dmpnV1N7r3Cg6jw1dNl5UjPtRvtF8j+YNK2o3VqxfL3goPhdGG4EJmLgJt4WJ4HyZBHk5WQK2vDzFckKYaeLWTJ9PyM83ZVkw71HincI3UEGCLT5dmhAEt0wKMDcd0+4q9dL6qiVoKqFGa1Pz9UL/uBi/4LJ3d2s6ll68+rQv6fO95Ec3kRncNEXB937U5k1yCpEDze8l2EZfGVUQDxDzPJENoIIKdTLvgV4MlCESmDV145B+OcF/2t+2GF3qnURYX0dKjyJY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 24/09/25 10:28 am, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Let's simplify the implementation. The current code is redundant as it
> effectively expands to:
>
>    is_swap_pte(pte) &&
>    is_pte_marker_entry(...) && // from is_pte_marker()
>    is_pte_marker_entry(...)    // from is_guard_swp_entry()
>
> While a modern compiler could likely optimize this away, let's have clean
> code and not rely on it.
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


