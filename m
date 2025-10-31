Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D786CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 10:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 827658E00D2; Fri, 31 Oct 2025 06:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 804838E0042; Fri, 31 Oct 2025 06:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B7F8E00D2; Fri, 31 Oct 2025 06:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61CD18E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:34:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BC111603DD
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:34:18 +0000 (UTC)
X-FDA: 84058049796.28.9014AFA
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0AC9240005
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:34:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nce8sMlE;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761906856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=No4nG0fxP+YGa8mecuIh966uI+UlF5o7DLaj/1/zRLQ=;
	b=eiMgfT5cIvOQ07r4koDAg2qfV0oD3zfFrNZIMfLnJ2R9NVPFVeEyIbGxTHFmOaitswuH5l
	d0oqQ5Y/nF4l7+vuYGMnFhOcVT5JMAmlsDl0iW9ztVWigfjvI+rT1yvprcPrbllkEd+pP9
	eNsA7EG8BGcoiJi7I1HSyEaNkcxyREs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761906856; a=rsa-sha256;
	cv=none;
	b=nh6ZiGqcUNKwtxsjTEifv7RISA/naWkH8cqAjqYzBpVTlDNUnuEzJEBoXinKce8aXNtt4F
	nRosFT2GE4etBTl+70pQj+FuGPBK3TrDKKpHaQhe/4dZA6w3vroeKvruEAYuDIgPUjilAD
	3Ikdkmatva+4+PC6Djmo3m8xnfLK6YU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nce8sMlE;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <11c80527-5dc7-440f-b09e-a9e4a8093ee2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761906850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=No4nG0fxP+YGa8mecuIh966uI+UlF5o7DLaj/1/zRLQ=;
	b=Nce8sMlEtSshax3q44vCtydt5Q6Om6F3fG6V8IsPoi85c7l1X3hQpGwgjBtYRssoRogXiu
	s+3HlcOvHRTJKrKoZZIuo3lkykRBBW4X4ovuqyYo/Q17KmbE72Mt65pGhiRQEkew35cDsW
	+lY2qDo1vQSvh+PsnUGQSWVZvW3qM4Y=
Date: Fri, 31 Oct 2025 18:34:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/secretmem: fix use-after-free race in fault
 handler
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, big-sleep-vuln-reports@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, david@redhat.com,
 stable@vger.kernel.org
References: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
 <20251031091818.66843-1-lance.yang@linux.dev> <aQSIdCpf-2pJLwAF@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aQSIdCpf-2pJLwAF@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 7j86rbegk59nqkhd6rsnm5kjb5d5ifba
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AC9240005
X-HE-Tag: 1761906853-871613
X-HE-Meta: U2FsdGVkX1+oTDYf/ywhv13r3lpaKhvb24Q3AbAj+BTTsJtoHzNRE5Yw8+cE3nfrIUFpkHrUBtZoxbBqHg/lc1cKUbxEJuynaS7bUmFR2LQENtZwPHIMFVyeRN+VbidEyc+9xz0sSjNKkXkBM4l5ucZDp8TQVhqu7Z55NZUM7RpNr93J5g9+j1QKCcbQSFdU6v5M1D0qJVNX+GmvHh+M0pqIiDyIp9ZRlh6hWQ3k5NZfZxMNdXSqeXWrSQp6D1OhxcBPZXuVUB2W0hWkLYVWVvf0bnQta4Ygm2Y+vjDeCRcAvnarS3T1ZlmxSjt/EV+MhhYcwRLeSQLz6VZkgw0aA24cI9QC/iqbV9+IYDx2osPW1hYfp+o/k4A8OzDBZje7r5bEQCJOuYUNwFectIsFWYYKJqoDVDALHYvLODDdmFUwz3YngODinCa1r2uehK57pwhI5xy88UdsZ0dCgLSQKdWjiw8z+K4MCZLtzBF5FV7ZjreDeyOMbYf7nT9atnACftS4u0cgHOG0YQ/CNEmb7SgYW232J5cidSPnk3f9oZ4QB6hsVBAeTP5mZSdOQJt2eX9S8jLUEnn0gYXhhNFofeyV+cFYJV3KNxhM7IgWLkfWx2pVd4xyMNGSO2KgF7vyfEQ4UM7EaICX7i1kEQeMAzLcAbGH8BWiogItO+2j9PTZp+lqQiFixLNkyX7m97ZX3GesxIpTn2kMnTOoGBY7LjpQxWFaMNESQhMBaIn7o4sFYFuG1Vn7oHRg0lCVY3dRQ7EiukteFbG9kAstPUf58iMwcMg/eXoi+eduZQda0DX9uLEf07Wr8qFyEgguKlSu76+1s9/inxv8+O+wjqML/FG/gzoxGO9GE4dgCYTalPpoDYdHgtQ6L/Ra7DcPHEaHkBbni0++P/+BT6C97q8owVdLlmk+G2PrtrybPBDW20H/E6M1vsRlNSLt9g4NCtNT0QWNkvraXL2sJfqdwSk
 Te8bal34
 Lz3aOyQCdIBKOV4/4SoRvrf17jfGIhj4G0lPdJbFw5PCM1y3Roy4f6/Va6MnN0H6FyOlwMxNXjUVEmNrx6icsTh3MnjZpL7m2n2SEF1T+NzWFnshSw4QJxZ7LCSeVMlZbvKi+hoY6hiy9Z0cVEVyth8OLtfADlMQcqxldiy6nyb9IvuWCkeEnCVSxUdNRdLTsSLJEcFuJCXq1M5zog3qZBTZsBNsHtAtc9KkdayOzrbMYcjFd9puAcxe0Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/31 17:59, Mike Rapoport wrote:
> On Fri, Oct 31, 2025 at 05:18:18PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> The error path in secretmem_fault() frees a folio before restoring its
>> direct map status, which is a race leading to a panic.
> 
> Let's use the issue description from the report:

Will do. I'll also add the missing Fixes: tag.

> 
> When a page fault occurs in a secret memory file created with
> `memfd_secret(2)`, the kernel will allocate a new folio for it, mark
> the underlying page as not-present in the direct map, and add it to
> the file mapping.
> 
> If two tasks cause a fault in the same page concurrently, both could
> end up allocating a folio and removing the page from the direct map,
> but only one would succeed in adding the folio to the file
> mapping. The task that failed undoes the effects of its attempt by (a)
> freeing the folio again and (b) putting the page back into the direct
> map. However, by doing these two operations in this order, the page
> becomes available to the allocator again before it is placed back in
> the direct mapping.
> 
> If another task attempts to allocate the page between (a) and (b), and
> the kernel tries to access it via the direct map, it would result in a
> supervisor not-present page fault.
>   
>> Fix the ordering to restore the map before the folio is freed.
> 
> ... restore the direct map
> 
> With these changes
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!
Lance

> 
>>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Google Big Sleep <big-sleep-vuln-reports@google.com>
>> Closes: https://lore.kernel.org/linux-mm/CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com/
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   mm/secretmem.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/secretmem.c b/mm/secretmem.c
>> index c1bd9a4b663d..37f6d1097853 100644
>> --- a/mm/secretmem.c
>> +++ b/mm/secretmem.c
>> @@ -82,13 +82,13 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>>   		__folio_mark_uptodate(folio);
>>   		err = filemap_add_folio(mapping, folio, offset, gfp);
>>   		if (unlikely(err)) {
>> -			folio_put(folio);
>>   			/*
>>   			 * If a split of large page was required, it
>>   			 * already happened when we marked the page invalid
>>   			 * which guarantees that this call won't fail
>>   			 */
>>   			set_direct_map_default_noflush(folio_page(folio, 0));
>> +			folio_put(folio);
>>   			if (err == -EEXIST)
>>   				goto retry;
>>   
>> -- 
>> 2.49.0
>>
> 


