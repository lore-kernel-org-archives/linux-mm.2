Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF30CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6E376B00AD; Wed, 20 Aug 2025 05:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A464B6B00AE; Wed, 20 Aug 2025 05:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983066B00AF; Wed, 20 Aug 2025 05:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 888756B00AD
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:22:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 179CAB986A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:22:39 +0000 (UTC)
X-FDA: 83796595638.19.3B687B3
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id E520B2000A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:22:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wWQEg3wl;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755681756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGgNtPnkWs24Cm5tQaMk9u0G5NYAGMzfPYAnpUK7BCE=;
	b=dtQf3fzVJTACC0leB/s6GMj8czxaD8L4lvSuugXlDv8s6lg+m8hAJ+wIfbAAxaS+n7lYIq
	G72PvcNYr0PGd8T7J8mQd3ydipSiPCfpM4uT7b357qMS6ki1QZgWjJBOL11TjaeZmvzZno
	uVKx0weZAssGuiq3gk3WrCWhy3nUKAM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wWQEg3wl;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755681756; a=rsa-sha256;
	cv=none;
	b=OFqtobHDfH+yv1b31JFYdU/stKMvMCMDqhbirk2iIGPxKpk8+Tet0jNNUQj8nnVPb3IwAP
	uXVDMYYfPpv2HDdcTnmV1iLj0ZM1Fg+q5FO3kHkPO2QP2jhokUivyzkGsBGqUU72wHrtQ/
	YJRk9pOfmIS146t9eHlHogtUNfgbwoU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755681752; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YGgNtPnkWs24Cm5tQaMk9u0G5NYAGMzfPYAnpUK7BCE=;
	b=wWQEg3wloIqZTrwHs9AiDyJDgfZMRZwCQWfoqog4n9wmILaOV7P81hzBt13zpLmReLk7sTDfNLX81fTvaxXkVRaSG7q1AGzL6NpPESEkktqugyS/8BhxAeBIUyHLobmK2cVw0sc74glvGTwrTzR8YZjpj5KWRo0kTpMBPQbcgQQ=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBG0pZ_1755681750 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:22:30 +0800
Message-ID: <a81b7fd3-c466-45c9-9374-361b780ce09b@linux.alibaba.com>
Date: Wed, 20 Aug 2025 17:22:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] selftests/mm: add check_after_split_folio_orders()
 helper.
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 wang lian <lianux.mm@gmail.com>, David Hildenbrand <david@redhat.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250818184622.1521620-1-ziy@nvidia.com>
 <20250818184622.1521620-5-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250818184622.1521620-5-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E520B2000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ppj9d1o6kcrcyxzpmx73w7fxi46k9rpg
X-HE-Tag: 1755681755-787181
X-HE-Meta: U2FsdGVkX18VXmdh7KogNGlmvc9t7Zc3UQVaSpAbEhrrEONgALvsT5DzVJ/qMFSnHOZ3nnHGp5p/oBNovFeWOAputkdKSJgi6rU935cc/mscYEpi9B+/LNigP9cf6KPCAFwCd3AnRPGe5g/LhL+EYn+reiy9S10uPccoeijm7HnVNk1ccOBJSdheSbnfFz0KGw0Ory15vIxdxmOXZCf+lpLmAceljDrlYuZdkCrC0Iq283/gguFxswfgbetnmTievxuT91p1RI/j7fi+t4itIjvKUwzut0f3e8a8xM4ao3hzONQNb5LTs4bK9qWXV5n0xn60oz5TJRcZz0OjgiUF/IqFf62vjFBz2/KHQkYOowNz9PK+MpzntI6gW1/zFX39VxsdbDcdaAM3huEDobQvQ1Xhbz+bdNk93uj5ztg0MVyQDHBoYUJWivBbxv3suNVI75xyd3xcYYc1JEgTiZQ3K1+y8KuhZvFRmslvEkrDUvzxW1D7hOHY7TEAk4BXmMgm8WcGzZFsckaB1xV0pp/S8qoGNSmlh3ACsu/CizzoJB3EUX70wNYNMfS8TmkBBEVmIogqORmt2Q4NW2H/8ozVXnsTxRaAmUV9eMGP3tX1StZGSdoqgoBZXjH/7nZ7CHzLIrwMGL8crxPLfQ7hA1H71tPbHNXzsOrqEbqkc5osFdOY0QBoZ5zcFT4gLDTCpp1Vz2NrEFHbtC6aKYz4WrW+NiwSRSh61VY8Q8lXpXTvZE4nosugezN1cVdRJWb6Fh6HVb/TVhDd4Kz1nJ42TFPkqR2RqQs/Cu5CviByaPrfEfULlI+eHshuyDfQpq6QUOh6etG0t+5NJ9c8R+2ZbaYJEXjRN2YcZ1aNUFQlCxO2iAixGo8JW0fGxeWGsl3dvfRGteiCX8c5tq5L9W03nrgVNvUArPigjGz+MiB2YRjXn9gUB5Geuh/7A0NfJcukwAbmw+tXiBt135S7T8Gljdi
 G9mpVlG2
 p39xaDGj1rGjUEDpSWpR7JjKzA/ztqrAQp899oSrmWNzZB00v7J2gYuWXtNcvp810jmPzVv8zjk1durMSuD0y3BbAi/bX2m1BgjV+Mc9/jC/tVrmWemMcVnSZKvqK8kATVnyrJSnFUG+LJTvDmm5GGz7DNHowtXlysGAmQU3noSlCgkPPbr3DOVwbM853bh7jEuEwyiHP0C2wNW+j7w1JUDuoDHFyLoKTOy8FVzzZ7OtWPfGjnoinUcqQd3DxlsKaIgSnwY1m/kPFoJLZVn1JzI3YmjCFI2RtD8PpqD6QZ/I4ZiWK6dznpVFqPMYBe2Ee08PfXu6szzH62EFQaYHNAwmyLcEL4uzf2CF+ciIw3kY67XOUtpo0AMdeitTFPRoAqRTL0CpTIDFfrKPRVkScTKDTrfyO53h2bnEfNQVUud2VuhnYc+qZO7wK6FPrAQXFUYgKEOKVeYY1MYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/19 02:46, Zi Yan wrote:
> The helper gathers a folio order statistics of folios within a virtual
> address range and checks it against a given order list. It aims to provide
> a more precise folio order check instead of just checking the existence of
> PMD folios.
> 
> The helper will be used the upcoming commit.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

I tested this patch, and it works for me.
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

By the way, I moved gather_after_split_folio_orders() to the vm_util.c 
file as a helper for mTHP collapse checks in my patchset[1]. I'm not 
sure whether you need to move gather_after_split_folio_orders() to 
vm_util.c in this patch, or if I should move it in my patchset.

[1] 
https://lore.kernel.org/all/955e0b9682b1746c528a043f0ca530b54ee22536.1755677674.git.baolin.wang@linux.alibaba.com/

