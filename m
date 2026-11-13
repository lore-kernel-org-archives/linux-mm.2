Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D08E606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Lyxm9tmi
Received: by kanga.kvack.org (Postfix)
	id AF6966B0617; Thu, 12 Nov 2026 22:58:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD586B0628; Thu, 12 Nov 2026 22:58:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BE86B0682; Thu, 12 Nov 2026 22:58:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9936B0617
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:58:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D48194016C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:58:44 +0000 (UTC)
X-FDA: 85428739368.07.A63D0EE
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf03.hostedemail.com (Postfix) with ESMTP id 51DC920002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:58:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Lyxm9tmi;
	spf=pass (imf03.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=evers_chen@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794542323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JUOfsFOfJEmlaAFTpTaKsBmsfTT4SLC4fGYq4jy5VE=;
	b=yXJF2el7oMcwyGY058jYkpZ0m0n00GtgR4r4MexgnrNG/jwYhY62zuE7qeL5dNuQxL5xbV
	c9cSM19RsE/c6KnUnt4qg308bFREnfDblHuqJcj95o2WZ+e52+YHFN22mimul2AFB4zvPP
	KIsP+Wi3KSdokgBKw5VkOytjCd+nOww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794542323;
	b=GDCvy89dNXG2CxJpw8xaKrNuiN9SrXYP0ZHgdR5GrCRuJ6zX6YUaKyQ/4ruVOlEnb8KKo9
	lXnafs5UlWK4PJ1B5R8ikywS6wiulUVfAcsSNWNPwWGz+YW5KCZZL/riEtVtpTSyy+s+HA
	wjejHfWDOKV97tmpuFD/6jhtUhWJv9s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Lyxm9tmi;
	spf=pass (imf03.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=evers_chen@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=2JUOfsFOfJEmlaAFTpTaKsBmsfTT4SLC4fGYq4jy5VE=;
	b=Lyxm9tmihZjGz8crX5pRuB65/Xtrx2bBsgaelAvvffoJzTvD7w8G18j7HLR94S
	bSAwEt6dzdt8Nf/YUB0U2imtO+rft0IVW8zhSCtLvI/Mfq5D/bQpesoMHU7JSnuQ
	DSRrIYM6ib3ovh2hArvCiOOAK8XUCT2AxdxcXvGyAYrnM=
Message-ID: <b2ddd82c-7f07-4845-be0d-dce2c4ffb679@163.com>
Date: Fri, 13 Nov 2026 11:58:20 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Handle implicit read permissions in
 madv_populate
To: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 chenxionggui@lanxincomputing.com
References: <20261112031811.56500-1-evers_chen@163.com>
 <sashiko-outbox-212131@kernel.org>
Content-Language: en-US
From: cxg <evers_chen@163.com>
In-Reply-To: <sashiko-outbox-212131@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3_0XcivZqFta+Hg--.3699S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGF18XF1DZF43KFWUWr1kGrg_yoWrJr48pa
	yxJ3WYyr47Gw12yw4vyw4xXr1xKFs3GFW8X348tryFv3sIkFn7WrW8Ka45Kas5AFZYqw1Y
	vas8Casxuw1qyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Um9aPUUUUU=
X-CM-SenderInfo: xhyh22pbfkv0i6rwjhhfrp/xtbC7B0yPGr2it3HVQAA3m
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51DC920002
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wwgksj1rb6o8ws9opp9xg7c9985bbmxt
X-Rspam-User: 
X-HE-Tag: 1794542320-992517
X-HE-Meta: U2FsdGVkX1+S6OHrapyMGoqHaij7mARrYEnxci14RDkGl+Es/zfOwvySL2DLcl4H2d6N8O07c411H7MkLkqlh61PIKnWU6qLnr2gQS4fGMlB3VbTj/dSc4eSs1uOi7dlhjFZ+vVpovNOkBqzRPYrVAXwB5+JEy+r929t7C+q05OKc7F2vO3HSmG9gLav8634bjfglJwtHz4W6xP2N76H1eafempGOT9yZeUkyIEL1qrvqC2XTbLAT8KwRUZtjDex3VgREabN4tgTA6J6a7jfBt4rWT7kbWS+qv0SE35kNCj4dtykuP1C5NNH8mRGjHyMAMCXHAm9AjU3TdHWB3pqcgGjQkkBL7z6c+ycFmnd8hThBXGJjzDOuDpR6Y9X9BtQbcq3eYQzWDaTTWtgHRWoaX3Ctk7fkyhmUob1D+TS9pZUc64CO5m3U8HJA7O+9Reo0L42HbXfdbyYrsi0lYtrthDaFxqK+AeUbbxJ9FRvBhcfWf/iwFLfRKAxTHKBwJz1Fy/y5zut2aMk0+QnrXQdiXT9OWuK4GOAJEEjKYTwC0qlsiPbrgwvKVedO7yxDkulZ/5PLVYAe0jgu1F8OcPc4saxNrFDfvzCcijI9CXIWH9p7IO6poLOefiILQyWTpL5ywAZv2dzdexenFwF+iXj1VxYvuusoOOd2Wl4gjNervYgJMqhTO3qQgKc/i8Us/3SXYaXWRajXWtmT6YlsbNzBuD0/LbljdVu47F4KiEeDrhdmdXM5zZOrqc6fpmgB469njFKajS/spwSnlyEd+PfyRr+XWSaEwd2oZcYxzcw5jbi/H9e93fU//k5hg3FAiFId23aWAf7oYTxwO/qMIueRr/boKa65a8RszWnL0HMgtoNqhLzpnt/6sSeMFjL4p1k5FA7BhOAriVZ6TeWXziQedJf2H5Z88uqs4bAgivb0CgDaZUGKsfko7P47GhCXtGKghLCTv6Qo1JilgeOwWO
 ehYOUaZF
 tJBMzZ7xV/jfuMcDgRBj4GjZNLUhM5h84w488Xd+LjQVUA+nMw/Yng6r0dd8qO1Rms7FAH9f7ZV1YV2tXuE6rQth7L371+4Leo9jz3Ai9kjuQVE7jQdLshSuyG1nRhr+54Dqz9MHDOHw/jctB9sbOM3DUVSd47CbA6MDyg5ByOkA7S/42IkMm0kaQjAaOgE99otABm1bC38jJyIQWqP2xMA1Bzaom1UV1YcozBjYfd0bIU05ubvukKiWLSfEmPGteXIllMbjzAk++ms7JYeGlYxGeLdf67BTeC9nCfYxFiRmSPyi2QYtuk3+rlk9hWAIEAdD/KrRAxyoTZ0uol+6Ysq0jjkxay4HKowu4Jz/86jx59m51ycWnVQLFMpqxKZ7GoVZrww/V2kqO0syvF0oco52rq8kB2qtwcY4wlFPEe6ixCrnnC9vr33sqiSkiqsrU5Tdu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

Thanks for improving the changelog and picking up the patch.

I noticed that the original madv_populate test was introduced by commit 
e5bfac53e310. Would it make sense to add the following Fixes tag?

Fixes: e5bfac53e310 ("selftests/vm: add test for 
MADV_POPULATE_(READ|WRITE)")

I also tested an alternative implementation using the existing procmap 
helpers, as suggested by Sashiko. It passes all 17 tests on RISC-V with 
Linux 7.2.0.

However, since PROCMAP_QUERY requires a relatively recent kernel, 
keeping the current /proc/self/maps implementation may be preferable for 
compatibility with older kernels.

Thanks,
Xionggui


On 11/13/26 11:19, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Low] selftests/mm: custom /proc/self/maps parser in
>    mapping_is_readable()
> - [Low] selftests/mm: missing Fixes trailer for test_prot_write()
>    failure
> --
>
> commit 3592bfa7e9663819c643afaf7d6c337f6b102d15
> Author: Xionggui Chen <chenxionggui@lanxincomputing.com>
>
>> selftests/mm: Handle implicit read permissions in madv_populate
>>
>> The madv_populate selftest assumes that a mapping created with
>> PROT_WRITE cannot be read, and expects MADV_POPULATE_READ to fail
>> with EINVAL.
>>
>> However, some architectures, including RISC-V, may implicitly grant
>> read permission to PROT_WRITE mappings. On such architectures,
>> MADV_POPULATE_READ succeeds, causing the test to fail incorrectly.
>>
>> Check the actual VMA permissions through /proc/self/maps and adjust
>> the expected result accordingly.
>>
>> Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails
>> with EINVAL for mappings without read permission.
>>
>> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16
>> tests, while the updated test passes all 17 tests.
>>
>> Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
> [Severity: Low]
> Should this commit include a Fixes: tag for the test it fixes?
>
>    Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
>
>> diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
>> index 7fce5d0b622be..818f99ee20041 100644
>> --- a/tools/testing/selftests/mm/madv_populate.c
>> +++ b/tools/testing/selftests/mm/madv_populate.c
>> @@ -69,10 +69,38 @@ static void test_prot_read(void)
>>   	munmap(addr, SIZE);
>>   }
>>   
>> +static int mapping_is_readable(void *addr)
>> +{
>> +	FILE *maps;
>> +	char line[256];
>> +	unsigned long start, end;
>> +	char perms[5];
>> +	int readable = -1;
>> +
>> +	maps = fopen("/proc/self/maps", "r");
>> +	if (!maps)
>> +		return -1;
>> +
>> +	while (fgets(line, sizeof(line), maps)) {
>> +		if (sscanf(line, "%lx-%lx %4s",
>> +			   &start, &end, perms) != 3)
>> +			continue;
>> +
>> +		if (start <= (unsigned long)addr &&
>> +		    (unsigned long)addr < end) {
>> +			readable = perms[0] == 'r';
>> +			break;
>> +		}
>> +	}
>> +
>> +	fclose(maps);
>> +	return readable;
>> +}
> [Severity: Low]
> Could mapping_is_readable() reuse the shared VMA helpers in vm_util.h
> instead of open-coding a /proc/self/maps parser?
>
> madv_populate.c already includes vm_util.h and links against vm_util.c,
> which provide open_self_procmap(), find_vma_procmap(), and close_procmap()
> (exposing PROCMAP_QUERY_VMA_READABLE in procmap.query.vma_flags) as well as
> check_vmflag(addr, "rd").  Reusing those avoids duplicating VMA lookup logic
> and avoids line truncation on mappings with paths longer than 256 bytes.
>


