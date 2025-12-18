Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F172BD68BEB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C116B0089; Thu, 18 Dec 2025 03:05:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF466B008A; Thu, 18 Dec 2025 03:05:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528E06B008C; Thu, 18 Dec 2025 03:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 452E26B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:05:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9D4CBDB3D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:05:33 +0000 (UTC)
X-FDA: 84231857346.28.A98E6B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4155810000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:05:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ly158k2o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766045132; a=rsa-sha256;
	cv=none;
	b=xL6MCzNI4a9o76+xL694kqPU99Q+vkIk9vS6sh4SDHaZQk87vQEQKfG5u171DcnaBebMhz
	vr51XeXJfUsfnMbA9JNSBN7EqGO9uNnwnCnsHt5m3P75YY1KmSqOdeG8acT/wHx7RhelbT
	Sp0VUERH3ZtcMmxdseVQ5NXiDEbJnKc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ly158k2o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766045132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hk0wWCFcnaKaxUFkd+CUDlXGtiMVpu7ZFmJ1g+BVjQ4=;
	b=QqmMudvqWTSPd+xaGx7bCXl2m2LuR9DHi3wEIWRdOKN8OirCbUh2ncYf/mgvhq8MoBIcLc
	qEVov1I+Z+Ev2xFuf435toK4ssWXwElAlmVn5X8AXNBroOPrYetwkFVkjUT6ca7qQKpbSz
	6kLoOHIKQ+rnE+AlfExqWCvBfi5lPNg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AA90600CB;
	Thu, 18 Dec 2025 08:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EA0C4CEFB;
	Thu, 18 Dec 2025 08:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766045131;
	bh=OzSTS8I7zeGFfn+9aQoFwN8O+cmLb6QBvAXAvMo9Ucs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ly158k2otsUXsxGvg+hMLHK6XdetqPckQe980NBs5BY+zeog2Ysm0rMLTxUR1xmmq
	 Lgyrf96RU2TY79qsWp9dH7QjNC+lyBGTOYaVFGbidHlB0ci74xRtDrO0u43ioFqhVG
	 umLnwu9NFs/nq84gi2yBVjR0ps7YmTwFcXykBRNR/aoFwFr3mdejAucpCJchzNAOOH
	 cpoLvN5RU4E7HrGGT1myxrSe4A++/WmufZPPel1aYw9e1PQAuhyhWfFli3n7hMNXMP
	 KMnhCPxrQsuW7BO1/19blQi8ghAKjBfISLuFefKKWc7R+OoAZGnot2H0pGULjyN9fy
	 IY/gLIGP8D3lg==
Message-ID: <6aa47cdb-d2e7-4977-929b-7019b6f991c1@kernel.org>
Date: Thu, 18 Dec 2025 09:05:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] selftests/mm: fix faulting-in code in pagemap_ioctl
 test
To: Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky
 <kevin.brodsky@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Usama Anjum <Usama.Anjum@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-4-kevin.brodsky@arm.com>
 <37210500-6f6e-46ac-ac2f-ac996308590d@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <37210500-6f6e-46ac-ac2f-ac996308590d@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4155810000E
X-Rspamd-Server: rspam03
X-Stat-Signature: bz6zda9rypztppsz93siasjxkd3nagfq
X-Rspam-User: 
X-HE-Tag: 1766045132-811575
X-HE-Meta: U2FsdGVkX1+2q6zkB9jWCp1kuqaUT3kHALzDlileyJeRSLFhYOC0z5wGON+07jqx6CujE40Cd+HOjEW1DTvX5D6OuiwdvXWFcMAN6W7kGPNf42be+u5SXDylSxajbNknF5ldVRjkPiFZcWnmMd/EZZ9Ak/b+vS+uQ9tQ+65CSUPxf8ijZbz5hbfgZvlmn4upRI6T4kgSDgyO0mwIl0mMfCgRNuhl53tbG6dAjwD8egcVETOK8CtBGAhLWoaQ8o1spSTnAznLSJ6czXiz6vSK6w+ld10cAXlvkljHOKc7qcmnFeewdEFn+h6bbj+vhHr0Zu/pq5JCyjXwz+B05uLBW1CxIawjFN3TXtSECpgXzB2z+kpMmcwZ4PGWyDEoIvOMtxLYTeyTJt7sRCPuYJnvuJH7efriGDCYyAGzC+CGEAng6YyvE+xZxdamURVmtKRD9bw7wAYAKHXnXWSpt5OzWyB1JBxhMYjguv8CveCtR5HE/xwfHMSMApCBKK0zlSi21w9u+Xl7jL6Px1n0U4aVGRBygv+QQp0lwG9RVJxAk9ll4TqGZk31wlQ+XrBNGMka7Nm2y6GY+GU33ajJ7B3kMgHN7tq8mUDZh0ac9KdiJiUeA8EuvnqHmodJQPMdpkMDhrrYfegzAeCAuD1nguiE1eIfGqlwY2JlFuX7kfKjAJcdc10QLfsk2h3xlu3+wYKnvUOfYbCTpkafJjBGVkDuZ1Xk3AP6TfngUYxov/EvVCGmQM34vxGcXHqgv+0OMCmjMKutScxXBlRr9TymEQNjBNNR7hrhPmtojS2FLJgSXIW+H0Vt2nFbOo0Oe18pe1tr2XGoIdJpNb+2qJW2YokgK4H+d9sH1Wii+Gg1ux4D9ZJYu1WGEKVY4jO3T9oGDSa4+H/QEC8Rl6Z4V9iANouFoxole+p7F7uKxLn32VVYLKDy1NvImwjk4t9sm7ZOMjjdtddD7cFz1KXDPcNGex7
 ZcDDzKmc
 oM0iVrypKBnxyfZKehlGrdmWxiNlWwbtWPn8ddxkwcRnbaIX2qlLsIcuJ9DR8qurkr8bdxUCTCUttAXYQokRGg41dxr36A6ljYTDuVpn4UG8arCHsZUuvMLqrJWAVVQPWTA6wEBNT/6zTz7v9e3L0cACzdZNJZ6hPTcTwJIExlvTX77RR9o+ynawwJpkDdBI03B+hhkb/s1caSbxjqbPmNPKJpGN65EJqxrIs7ZlDAtL7XlGRHSHLBdW/v1J9h09I8PkrxxTLS6mvPalVVj9MMBYbQMrtdAMRf2W0B3/Yg1yEryzJ3OqSKc0BeZ/lYAKhKjdyL3zm4gtiaOupq0+oQt07J+iyGacpTF8e8TsjrVBNMYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 15:56, Ryan Roberts wrote:
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
>>   tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
>> index 2cb5441f29c7..67a7a3705604 100644
>> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
>> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
>> @@ -1056,7 +1056,6 @@ int sanity_tests(void)
>>   	struct page_region *vec;
>>   	char *mem, *fmem;
>>   	struct stat sbuf;
>> -	char *tmp_buf;
>>   
>>   	/* 1. wrong operation */
>>   	mem_size = 10 * page_size;
>> @@ -1167,8 +1166,9 @@ int sanity_tests(void)
>>   	if (fmem == MAP_FAILED)
>>   		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
>>   
>> -	tmp_buf = malloc(sbuf.st_size);
>> -	memcpy(tmp_buf, fmem, sbuf.st_size);
>> +	/* Fault in every page by reading the first byte */
>> +	for (i = 0; i < sbuf.st_size; i += page_size)
>> +		(void)*(volatile char *)(fmem + i);
> 
> We have FORCE_READ() in vm_util.h for this. Perhaps that would be better?

Agreed, and if we have multiple patterns where we want to force_read a 
bigger area, maybe we should provide a helper for that?

-- 
Cheers

David

