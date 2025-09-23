Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B38CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 14:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC978E000A; Tue, 23 Sep 2025 10:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55CDC8E0001; Tue, 23 Sep 2025 10:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49AAC8E000A; Tue, 23 Sep 2025 10:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33CD18E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 10:16:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFE041DEBB5
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:16:52 +0000 (UTC)
X-FDA: 83920716264.14.0DE216B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id B14F310000A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:16:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758637011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=27zm8TzsAZZYp9q8kGldCxE+mn9f/p85gJFAjZDXZAM=;
	b=F3iH505/9D59KZf7iFMBaKCutAQLCK3ZwePwyK1NVtXYMM42LjbhvRGgPgnPnwqzMFTZJn
	UraWxU0/BuDTr1VwFtk6O2L/dYcVCMMmuADcJuz3nXiKXAn3DOhRyef1TeCFj3iRdvd6ZC
	GtvNvEXZTh582drmKFlv+ZaSamMlmgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758637011; a=rsa-sha256;
	cv=none;
	b=ge4RlckLdG5HOdsUeBnOYV5B7FFtrWADqrFU2cHCqOpkgWvmS+tIeJgrbU93LqkPABnTaS
	PFGiDW5gLIQZUiCRhNzt5uyaVL0zI+pwyQ3Lre57ILt3hVcrekQkTGZQj6h7Z0LYNALMWn
	pkbh1ybBUPrfj2dC3wQQcfqhjrfOStA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65227497;
	Tue, 23 Sep 2025 07:16:41 -0700 (PDT)
Received: from [10.163.43.74] (unknown [10.163.43.74])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED5293F694;
	Tue, 23 Sep 2025 07:16:44 -0700 (PDT)
Message-ID: <ecd6cdc5-7503-4fb4-96f2-1264d46e8fae@arm.com>
Date: Tue, 23 Sep 2025 19:46:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: not select MEMORY_ISOLATION
To: Xie Yuanbin <xieyuanbin1@huawei.com>, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: will@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250922143618.48640-1-xieyuanbin1@huawei.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250922143618.48640-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w5acdok6cza56ezk6y7snaqfdurnh93h
X-Rspamd-Queue-Id: B14F310000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758637010-40806
X-HE-Meta: U2FsdGVkX1875VMN8zEPOku9OTJBmdLAOc0OaRh3NykXLUUrbsJP+UPC8Pv2vLvVL/F/A973MpjEnNRWBDXe2Xkd12rjTTNyqk9KmqGyrk14sSe/TZji+ZMyU6oHlo/KOBNmZs/orzi+4xbj7BIC8MJEQnEedkqGe2LVZZQYrFUdyYk86j2pnD7nme43fwHD1vQ1ACTgE6m7AgFbK6KAjjf+RlIqycZHmlXqSYiLJdefQqHvnGofRidSbrr3pQKuyQbhZ27eJ7ffVdLA00k213PxROfR+lJnQCc30ZxleK2K5nY9OqjAu3QGPUvTReZSr6UobX0ICXQL7AxZPdGAl/HC91BjZQAxdmn0wucabpOq/MRyG22kRKvnAZBjUNZI6GjVOLVhcodxF+dbHhHc0zdjomdXb2mvA9DxyYYJARb//jAAJsxunc8btWhHZjwtHFvYVgHKq4gVZM0PLhl0Jij4rAzjA8kBUR280kSoZ0IfuoTOmfP/e6h94+Mr2UkQGA2S5SL1yWlpaHKcgMYsN54W0SdpSlasvUesxycmhxLsfjXcDzJkWiPFXJCPrwFlt9rPG77VYQwi3opTEBF+sa0O5Z10JBmieqs+bB380AN02SdwL2w7RprRXnKQWw09MLpbnXftWxmMB6lpDyUBxjpwYSmvmtNM8XCEq/iFktx9KNAlaTOGdxWmi2+qp5NFMZAsQaacn2X98oPYvdFoHR+tYa/tn48ypbWkHcF3fdFml4f1cV1Ll1ANvQ3HFeVV4Hp5Mh93JnjrrjqDPMrTcQ1yAqXxXh7xngILty69oagSET3siGXRaBDPU2i0Sq/FjfucRYH0/EhN6xrHXBIDlIZ0D5FJxjGaE+yaGUMat1Do6iAEg+ki75C0V+O0GGPujAuZPX6c0NOV7vWYoMWGzYpbBN9Kw6HA9EKumSNCJpyRrEPm8vnwpPdysIPchCIlguXlq95ptA5ctr7W2Un
 tf2Ynf61
 nmD9ZFxg7jbSKtNm5rEq6WjGYkFB15wV87W5eHlmUXTnVj/jxr1d7BXRnuRZhinuvbgiRRSNC3Au+/4OBpB8pI9t/FqAGOKv+bP6ZoZrxR1wS79bLdQn2X97AWVqvi+Bk0ohDxh8l+9zfvbmoz1/E0JL+e78pjepTt+OAYvSyqp6/ixaZ1lt17+nB4nKduKn1+bSm3nVJDz0kJt2mzvLHG3DdjlO4iidGHOuauL2KRXttjmhf6a4b7JcTEtqEULYvPHpkKLcLSKs4QuCiFTp5A9jqTHBfqPRDbw/3SxbeIVJqEW4iT8p+cd+3qYWQi90YbeB4Cqk05s0uzZXLf5dmWLySYhWAEEHu6E0oRLZcXPz1u1k7kLJxtN9i5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/09/25 8:06 PM, Xie Yuanbin wrote:
> We added that "select MEMORY_ISOLATION" in commit ee6f509c3274 ("mm:
> factor out memory isolate functions").
> However, in commit add05cecef80 ("mm: soft-offline: don't free target
> page in successful page migration") we remove the need for it,
> where we removed the calls to set_migratetype_isolate() etc.
> 
> What CONFIG_MEMORY_FAILURE soft-offline support wants is migrate_pages()
> support. But that comes with CONFIG_MIGRATION.
> And isolate_folio_to_list() has nothing to do with CONFIG_MEMORY_ISOLATION.
> 
> Therefore, we can remove "select MEMORY_ISOLATION" of MEMORY_FAILURE.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
>  mm/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 034a1662d8c1..0e26f4fc8717 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -742,21 +742,20 @@ config DEFAULT_MMAP_MIN_ADDR
>  	  This value can be changed after boot using the
>  	  /proc/sys/vm/mmap_min_addr tunable.
>  
>  config ARCH_SUPPORTS_MEMORY_FAILURE
>  	bool
>  
>  config MEMORY_FAILURE
>  	depends on MMU
>  	depends on ARCH_SUPPORTS_MEMORY_FAILURE
>  	bool "Enable recovery from hardware memory errors"
> -	select MEMORY_ISOLATION
>  	select RAS
>  	help
>  	  Enables code to recover from some memory failures on systems
>  	  with MCA recovery. This allows a system to continue running
>  	  even when some of its memory has uncorrected errors. This requires
>  	  special hardware support and typically ECC memory.
>  
>  config HWPOISON_INJECT
>  	tristate "HWPoison pages injector"
>  	depends on MEMORY_FAILURE && DEBUG_KERNEL && PROC_FS

MEMORY_FAILURE does not need MEMORY_ISOLATION to be selected
(and built) in order to be built independently.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>


