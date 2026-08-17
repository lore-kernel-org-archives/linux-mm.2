Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1316AC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DAAB6B00DA; Mon, 17 Aug 2026 07:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08AA06B070A; Mon, 17 Aug 2026 07:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E973A6B088F; Mon, 17 Aug 2026 07:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF0C36B00DA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:54:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CEF740771
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:54:51 +0000 (UTC)
X-FDA: 85110604782.17.931E97A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id F398840005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:54:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V4ZYkkyQ;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786967689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0Ri55kciEVOMJnEtVQ2fUaxELixYrHWONiEbqixWmg=;
	b=KABOIzqAFxkQWz+waXFFP+dh+A27fVc8Ca9r643sYNNRmhTD29bPpZ1v2ZgF+KA+qdWKo9
	j14TSfr0JjuiDncNMUhzCW7Vpe92JqLorEutIEot6x4ZHdS4xnIQO8wH/wTV1kequqyk6s
	qx9NNZSOtIFhNQnKUvXjNgyCKrXmfyk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786967689;
	b=LXWrOxDfCZbJJolOFTmdNXpG/CWwZVIPAgTnk5//7olZj7A6sERIfeu7muLhOHK+jXDr44
	6G6BrqKtiAX9GrDd5cFvi2PFhyri2LfML+GWA4EfSay9DMN/tiZRwgbZEhnuG525q4veMz
	bgOZy8ssVRGv2GLR8peEOuijUdx1yT4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V4ZYkkyQ;
	spf=pass (imf17.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFDD61688;
	Mon, 17 Aug 2026 04:54:43 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B80F83F85F;
	Mon, 17 Aug 2026 04:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786967687; bh=661eddBtEHg+73xuJUgBQumGRYXf11IA7RbS7mODuQ8=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=V4ZYkkyQMswep8Nd0trfC74IkYcP6lCBZDcqGYVwopQ8+KrhE/WSHg6SAbUSVYprJ
	 eJSQDahVKNeMWQuRBSwlEoE7+OwPiB4dx/U/R4Cu/s1NfhYENOT6qXZP5/42wRC/sV
	 hjpmzCOU0F+aMhoCTC4vWqkurmsWSqU6dxWj5Fo8=
Message-ID: <461b03f4-4bce-463b-abe6-ea3e56f8aa22@arm.com>
Date: Mon, 17 Aug 2026 12:54:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, akpm@linux-foundation.org, david@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: Drop redundant open() in mprotect_tests()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Hongfu Li <hongfu.li@linux.dev>
References: <20260817080616.52946-1-hongfu.li@linux.dev>
 <aoLvynyoJ9RKRIMk@lucifer>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <aoLvynyoJ9RKRIMk@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: a7eyq8771pw71u6z9afz4mcq81rek7io
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F398840005
X-HE-Tag: 1786967688-508824
X-HE-Meta: U2FsdGVkX18SJMqu6UeV/jWNH5/Lzb7glfcx2hHKc24YlxLcL+8HCFUHWyNLCEjtEI0Q/SSxOc2L1tHD8zv34huvHghEMOskVNbw2MqRLnfgWciNBKZvrgKKYVr0Easj0N2tBXwsCKbQu6P8Jowp4ukq6/23rgUTklWX0n75gXfgWzCSceF02U0ah7+eeNohBJkwfzEa5hbQW7to+Sj3V93z++t1Qm4ctIAFNSn6HUNPapIJVsvTFJWrUKm37itNhpzsmF6M7EVxV8qlTUDGn3ZS9hlnvxmb4fPLWwhg1RguGa1Po5zsEA0a9U05/ao3LmJpWE4TGafhTd6PmgVD4GI5CPRyi6Ye48fkcIamDBY0IPJN53mNFZaxtlJYd/PzgxOHCeAUScxoAqe8NA7XolSsqtUCUnkBu97Dz4leM4IpHzxSPvKNl/NJUvAfD4SC6AOd3k2JCKBs+7dvmoAshM9fYojj+kez1oRMLr9H/bYRINT8sQ1d9zXTiTnZ/PwmpdkjEyAesSnJnmlvik5SBNgtZ8Q0QLGYlKkTnem4G5Z+WzcJRQ3rLQQJg1u1s7m7Q/kDmxp82J6FI5nFPWX51Ov0yx1ADZANyoKR2VpibrUfMe+hRe+wsLP2YJgSKcT8WytzglWQIJuFCLL8kKii6cpyF2x3dpGgTGApo6nX55cJQ1UJl51Ao8UZO7LxJSug9BaoSbCIYB3GWq/eSOiDdKXWOhN8AwvpP82yPLn9saVNIfIJm50jScQN6omkX5zwBRQ9MULnbpi25UzliljIvwcfXtSiaX8z9kwgRaE+lNMgZHi/bDBKIXyzJ2T4cmSnpp5htR+4yoKY7JIDDxEyt8E7RIiIyU0eshEzNyvoqff5MBG/eNBilDfiy/dRD9Q6FE28q780Gzxf3FgXmUae+1Uyxk/zzol7rGVSKEAx4M29dJkYuP6ekRPIyBdG432FJAx5naAmAwXPL7LrvzY
 vJMYS6l7
 6XByUHUOnJGv14dZce1vmDoD1HoKyimNtMfXywHKXhfK6AuvayDVkIU9Xd/SJNTiO1mFUzGbNaJt0OICeV6NAvn73Y+OemubpF5ZqZrKYkvOiZvdwrIGWAxOITL77JsRo4ghUIs29l0sb3IfB4zUGcNBn4DnO5CGtIzJxSOrtVqPHiObebcMWdZsgZngH7qyyyzKgcZO8y/KANQO85cFTgd1ZoScOfDxsvKA4YyeQKCQabeSMODa9XR9RQmWe9miDCEJm2fb54/OByO9ZMsOnh39ZdqsjXVrOnesSv+rstUXM4MMy5Vgab+iKUTROiS1d+b9wcwF/wL1zj50TLn/fpieTYt1fJTyUix1oPqvDeuKdt/5KzyTKExiorw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/08/2026 12:29 pm, Lorenzo Stoakes (ARM) wrote:
> +cc Muhammad
> 
> On Mon, Aug 17, 2026 at 04:06:16PM +0800, Hongfu Li wrote:
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> Remove duplicate open() for local pagemap_fd in mprotect_tests() that
>> shadows the global pagemap_fd already opened in main(). The local fd
>> is never used in the function.
>>
>> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> 
> Hmm yeah it's not even closed either...
> 
> I'm assuming this was an error in the origianl tests, Muhammad - I'm
> guessing some artifact of a previous approach or similar?
Its definitively the dead code.

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>

> 
> Anyway, LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
>> ---
>>  tools/testing/selftests/mm/pagemap_ioctl.c | 6 ------
>>  1 file changed, 6 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
>> index cfd1987339c1..eadc7159ca5b 100644
>> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
>> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
>> @@ -1332,12 +1332,6 @@ int mprotect_tests(void)
>>  	int ret;
>>  	char *mem, *mem2;
>>  	struct page_region vec;
>> -	int pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
>> -
>> -	if (pagemap_fd < 0) {
>> -		fprintf(stderr, "open() failed\n");
>> -		exit(1);
>> -	}
>>
>>  	/* 1. Map two pages */
>>  	mem = mmap(0, 2 * page_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
>> --
>> 2.54.0
>>
> 
> --
> Cheers, Lorenzo
> 


