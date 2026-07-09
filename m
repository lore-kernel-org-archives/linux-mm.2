Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8784C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6CC6B0099; Thu,  9 Jul 2026 04:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A876A6B009B; Thu,  9 Jul 2026 04:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951246B009D; Thu,  9 Jul 2026 04:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3D06B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:59:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01CF3A021E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:59:13 +0000 (UTC)
X-FDA: 84968639028.12.08C3F2A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C570180004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:59:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SiVeZCvz;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783587552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LxHmuK++8SWVXu5o4+6vHDmaAff+1/0+H3A0ocnE64=;
	b=w3zKwwyxxaWF7fd55MMGGWYFkaTM19Qyznl3Kfiaz3hBEKER8HIUn9aU1OdFZVnOkt9FMA
	W/axaMB761Qya0xfUmeimNVFwym/QC+OwiQk8jMPKL+/diDItIPzeii7P5YmNwTck9K3j5
	Psj7htCldQSKqUnLFQUKRi75Xd9natw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SiVeZCvz;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783587552;
	b=AeJtaaLulp0V9YQlRbztxbMqteu07UTr9/D2I+++fl2MYLIH9ACm+l9uoKEBpgFvt01Tlo
	wmwQj7Haxje15aJokIG8x1L2Gcqi6Ycz/FeLKF7kFP1PJPKw1SP2SllLE2FLb6woUewqSn
	ltunJ8HtzdHBpgVXCZbu7fjuq9JSEak=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A09C8168F;
	Thu,  9 Jul 2026 01:59:06 -0700 (PDT)
Received: from [10.164.148.40] (MacBook-Pro.blr.arm.com [10.164.148.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B2CC3F7B4;
	Thu,  9 Jul 2026 01:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783587550; bh=1HPvKEYhiPcOexS+VD2WtszNK/saz1sbI5aq1xojhi4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SiVeZCvzxhf63YTJP3qt6tHKCKIeIEO4CGc6XP5KUMWFP21OiO+Hcunkkr2pKROeR
	 nt0RhpR+h1WZElVlprF0qaSiFfW07mX7GKEJQ4rsYY7n0tPBFJDVJgYFInFpbkfpDW
	 nlkiek5NtyP4gE7PqT0oEEIRF9OG7YoHbkilYpN4=
Message-ID: <d3f79924-6ad9-4b08-9669-c6acea584147@arm.com>
Date: Thu, 9 Jul 2026 14:28:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: "Garg, Shivank" <shivankg@amd.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-3-dev.jain@arm.com>
 <d7cac057-c270-4b3d-bc9b-c3503c5b6f50@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <d7cac057-c270-4b3d-bc9b-c3503c5b6f50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C570180004
X-Stat-Signature: ga8a98dc9n6zop3nt5wiu3paj3u9osow
X-HE-Tag: 1783587551-107767
X-HE-Meta: U2FsdGVkX1+KjE9WsM1HLFSwOM+p/VtctQ9wGvWF9eiPafsfRDBG6s2UlmFTQswdtEIxlSL29eoXqMU7289PaS2bB9CPbxDFp2xaaIu70K6YhRimJi65Y83/Uc6DbL58mXj5DpJ+5P4Gk0f3fkLDj/TR/KNYfobSRIJw2yypQ/XQ6AreNV++m8PRmnJ5Qdg9Gzw9nvQDAjq8Whs5IbhVpjm+VC1i9SzLzr6LXQPkrXJEHZhX+1RwvX8HUKWlmOJmm8Of6E2EjrUfKbU/rNxMT6OaEdiZTGlDSd/lMpkgvwYF3bfc/OOsI1OZsYisiZPI/1uebZJta4Mcr7E/A+OzGKll1hix9uKyKunJPutFd20vhoVPIV2E8xlIcG7J3A9J6/kfCZyjcPdEbY3ZQOOppblw+kILkfrokpGZvP/tcBKsVYsC3eOzmdKKI/0Yc8YtULUQX1UtIcneGQtuZIUsfvL4tSP00i6QH+dxOpzaQnQzUGsmhi9+5l1S+l1pS3H5OAZV3Xb866/YhTVOIU+X4jh0InbKLy5DJ9gg1AJLZw/48cbqbYwhhAlJLRvZ5pghFWOa9gAh6OAfL8prijz/8RjQu0cO05hwccT+yguCsw2yj+dn+DLmz0nem/JstBOoIz+NGqv7zm2hTEBtwEbF0dFq+2M+ZQCnB0rMa2doBgCrQzJxmlNDNbqiWAgAtjWDBCPDpnlcqOr7WE8ZpRG9gUGt6kWftVC4WsPTuuG/KEDhPLY0DaU19xaN/pYICd3WL3MYziw6Q2GFUHDd7iGH/o9+WulqpNAreiw+qaEAiINRFiXKcUlEEwe0rD04SvHMObeqs1oqX0OoiCTiWoo3ZlUlB8/wjc8cSpVOz1Hw2duyEdFLrS1r4dQPLn5keId/Xx9AqEVlVk2Tat47QOJWogec43H8l3tW4T/7FKEsNKOTAdQRuVgNjh3Pr6XWvUxRc0h/h2aggLuIdWR0YJv
 8TP7EzU8
 dwBlKYLBUaNYhINhHm9YbcTkFvIF7sZL1lnJH4UPemNUOhBOVmPGRUdMiiEZNwugaZ0kPQbMZcn/CBf5eT33PWlyX5wTAtpt0gC/A3kNt+Jg8L4n3dCYHVte8T2am7PsowbOMoTaYPGOlxlB+aYnI3kUhdOdtcG+jteP2BoqlhnfGq6Zpu8vOktk79f3Mxevj8wKx07vpuGCo4aK4iLkDqhE+stTInhAlFjV0c92mMr0eceqZnjBUJrPL3E4Pp5iPCdxOCcCZarfJoWmxsoD+D4halNQSibfQMBBt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/07/26 12:46 pm, Garg, Shivank wrote:
> 
> 
> On 5/26/2026 12:06 PM, Dev Jain wrote:
>> Simplify try_to_unmap_one by separating out the hugetlb parts into
>> try_to_unmap_hugetlb_one.
> 
> [snip]
> 
>> @@ -2393,7 +2431,8 @@ static int folio_not_mapped(struct folio *folio)
>>  void try_to_unmap(struct folio *folio, enum ttu_flags flags)
>>  {
>>  	struct rmap_walk_control rwc = {
>> -		.rmap_one = try_to_unmap_one,
>> +		.rmap_one = folio_test_hugetlb(folio) ?
>> +				try_to_unmap_hugetlb_one : try_to_unmap_one,
>>  		.arg = (void *)flags,
>>  		.done = folio_not_mapped,
>>  		.anon_lock = folio_lock_anon_vma_read,
> 
> Now that try_to_unmap_hugetlb_one() is split out, should we wrap it in
> #ifdef CONFIG_HUGETLB_PAGE and a stub function for !HUGETLB case?

I'd rather not, if everything builds correctly?


> 
> I'm working on similar change for try_to_migrate() and had this thought.

Wait, are you doing the batching work for try_to_migrate()? I had
that as an obvious follow up to this series so if you are already on it
then great!

One other function to batch is page_vma_mkclean_one, but we do not already
have the folio there, so have to be careful.


> I think either is fine, but wanted to check the preference.
> 
> Thanks,
> Shivank


