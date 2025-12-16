Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71817D609A2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68D36B0089; Tue, 16 Dec 2025 10:12:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D293F6B008A; Tue, 16 Dec 2025 10:12:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C154B6B008C; Tue, 16 Dec 2025 10:12:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ACE5A6B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:12:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 405EA5A188
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:12:06 +0000 (UTC)
X-FDA: 84225674652.08.A29887D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6286AA0015
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:12:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765897924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4JMuvjq3oWsSDGLBCsOVEvjC39ub4GdNSBSFq9TOevg=;
	b=iIYAc3E3Zd2lHBEIlWII15mfye5Ho6tyacf9ilP8OrOe/8zvPHE+k+VNbgrGzjKJ4/zcqV
	4CHJBy3twh1fVjqcMG/Bk0cBDY+RmH14CHIR80iObR/n8eLvXVgeDkpo82Fbwy08nSO87n
	k0XmB919MXe+ShLoEOfcgByxeGqNQo8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765897924; a=rsa-sha256;
	cv=none;
	b=cnONInKN5irIbFogZ1iWr9G9FGjp/ue7CEN8PTqJMMVd4KkM0wmGQ0EtllsLH8xys24rhE
	Mybxc0OkC20NTSMSmb2+LVhxGFC8YKrN5X7MWS8jxhft4QO4Zld5o5tEXKJQL6pCEfll0r
	/ILqJFZSqSjKQwoQfJMMSIZoZYtJuzM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F93D1516;
	Tue, 16 Dec 2025 07:11:56 -0800 (PST)
Received: from [10.44.160.64] (e126510-lin.lund.arm.com [10.44.160.64])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6DDC3F73B;
	Tue, 16 Dec 2025 07:12:01 -0800 (PST)
Message-ID: <fbf8e6ce-c058-4e87-b023-1544dac857be@arm.com>
Date: Tue, 16 Dec 2025 16:11:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] selftests/mm: fix faulting-in code in pagemap_ioctl
 test
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Usama Anjum <Usama.Anjum@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-4-kevin.brodsky@arm.com>
 <37210500-6f6e-46ac-ac2f-ac996308590d@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <37210500-6f6e-46ac-ac2f-ac996308590d@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6286AA0015
X-Stat-Signature: itdgjjwq9pse5zmsypwi7zzrmjwqewop
X-HE-Tag: 1765897924-508383
X-HE-Meta: U2FsdGVkX191Z5ejkyYJaXQB85DPat4WbvuJYUHTb2cU6m6apJjgiPbbQQd+edSAV8hGzflCSV206sUGKgC9PO3QVCEz1od0AeRbuI5X9gm9sb6qoFAtrFLZSbDow7GQkOqP9euSC04Cf9RakP1P3TUbrSPDBglMXVR6Rh3yR8nUq1VRQAb4WfFHxyxNGTVss/OE0k1Id/gKrrxUp1JvmT7J3Zufzooa6Z6fHqZtFkXKMz4w8Pmg//W9ZFoYQYCI8KsEjmIOPCPXu7L2Qre1OUVcI0CbdEm94vnjVSb9ddoIIyuZckFewdAMPcjVmC0Mjiz4sTDzA+DpIeV5n9L3Bkk0RJ//QTDgzN9SrAA1GI25oyrwr4fSWt9lqLYybfYoNidads4KvlCEd2vl/qS5Ju7cvZmuipEm5BaqNViqOdU8snbQJ6hgjcoWhgKgsQgVvoRfnPLVwqo5YbyMIwpGiXogSKDvoxDEjIV9ks8fv89f1mKeUVE1oXqCNuEMsVSyK7b30wdhHi6jXkUfBJdo2lC1XZRpd4hUxV9aIhnTrqcne5OmwWUfXCuQ+b40i3MOgmJ1DCE2dpsUWB2CHnuY332QY8E9Pprq/l7SxJB5VRWQnLed/aaqaMFLUwC/9oQzmfVuvQv4ZyFo0ervYJw15gJF39BfPVpcFFLtdyB7OFxv+KclbI0/63JCJrEssFh0M99NS9lQ38NErlR7B0+09Hs7Vp+SIRHbEswk/ql3QjqeM8wWI0af6Q/4pPiPHtfDzNLzH7LL3khJ1pJdbHb3vVO13CuvviUYJf899vijyoBP8tV54+LotLtruTxhxfq4bSrNLqxk1YTXXC7Y4KYgfGgbO7fA84FjHxCrPXSeFDln9a1Uy3XMTGhrkn30mA8Jy4CcDr37EtfWb1Fh9xdjRjgum+ivL71T5ahBwpmSBlB7rTVqh8FdHj5EBaqfgXx1jS+l2Duq+QXRxfnYFf+
 YxpEgsr8
 +4PhKIs7n22/a36ikt1tQl+2k1x0mXqBI1emMX/ophLstiNjsvmOJ2Dt3iBNFESN8m7dH0AGkyPrftFDGD8cNzQgBodOvSr2gIdUiFnAhiD6mF1RmSF05nbyvOsQf1HYu6ttntFAoWezuELWTumT0j0GYgI87j4qwAAw1ObK5WSYknGyxzJTugun0kWCDd+LnAwlnLqwrqztTG8/tffWjAW9KZKhJUyvP5EBxIG9N2q+BtqbchWWfA/CT/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/12/2025 15:56, Ryan Roberts wrote:
> On 16/12/2025 14:26, Kevin Brodsky wrote:
>> One of the pagemap_ioctl tests attempts to fault in pages by
>> memcpy()'ing them to an unused buffer. This probably worked
>> originally, but since commit 46036188ea1f ("selftests/mm: build with
>> -O2") the compiler is free to optimise away that unused buffer and
>> the memcpy() with it. As a result there might not be any resident
>> page in the mapping and the test may fail.
>>
>> We don't need to copy all that memory anyway. Just fault in every
>> page by forcing the compiler to read the first byte.
>>
>> Cc: Usama Anjum <Usama.Anjum@arm.com>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
>> index 2cb5441f29c7..67a7a3705604 100644
>> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
>> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
>> @@ -1056,7 +1056,6 @@ int sanity_tests(void)
>>  	struct page_region *vec;
>>  	char *mem, *fmem;
>>  	struct stat sbuf;
>> -	char *tmp_buf;
>>  
>>  	/* 1. wrong operation */
>>  	mem_size = 10 * page_size;
>> @@ -1167,8 +1166,9 @@ int sanity_tests(void)
>>  	if (fmem == MAP_FAILED)
>>  		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
>>  
>> -	tmp_buf = malloc(sbuf.st_size);
>> -	memcpy(tmp_buf, fmem, sbuf.st_size);
>> +	/* Fault in every page by reading the first byte */
>> +	for (i = 0; i < sbuf.st_size; i += page_size)
>> +		(void)*(volatile char *)(fmem + i);
> We have FORCE_READ() in vm_util.h for this. Perhaps that would be better?

It would, thanks! I wanted to use READ_ONCE() from
tools/include/linux/compiler.h but for some reason we don't add
tools/include to the include path in the mm kselftests Makefile and I
didn't want to dive into that rabbit hole.

- Kevin

