Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C9BACCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 10:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97DD78E0023; Tue, 21 Oct 2025 06:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9555A8E001F; Tue, 21 Oct 2025 06:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892A78E0023; Tue, 21 Oct 2025 06:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78E0B8E001F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 06:20:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2054F14040E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:20:52 +0000 (UTC)
X-FDA: 84021727944.07.B1128CE
Received: from mail-m604.netease.com (mail-m604.netease.com [210.79.60.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id D6A95100003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:20:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761042050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f2eWsKieRHpG4WleED/5BTqvQ+9d30VLUyzBQkpB+AA=;
	b=EdhxYTBPpPTINKXumFBaggWguv3SuHfXnHPSMJrY0TeblrgCeDtcC/AJk/cDIkpwGkUVOz
	1ikWIBTVwzIOCIV2JURUVIca48SwuZwV2utTewYIBZ/Z5cGdAOkrWjobIZcch6UYQAGIk9
	lLVaxMVArN7J188Kogvm7vlx0IbQHWE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761042050; a=rsa-sha256;
	cv=none;
	b=MaFPNo0FAvSUhQBMOHpbqBa17CfN1kibfu5vEjqrYYs1hxd/6ypW1v4z3wRdOoa63rAP0J
	zcVao9rosCemTT3fLZ19GKMrfRc9Mvo4HQfuaxA2Uj60HcymzkDf0Vixoag00SYZaOyUXJ
	JS/6LpgL+4Nk0RDZ9k5belUBAN0aQCI=
Received: from [192.168.0.18] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 11e0b3b51;
	Tue, 21 Oct 2025 18:20:43 +0800 (GMT+08:00)
Message-ID: <e370f185-de84-41ab-87b5-99f849b6e047@easystack.cn>
Date: Tue, 21 Oct 2025 18:20:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Refactor vm_mixed_ok() for more maintainable
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org
References: <20251021085328.1900589-1-zhen.ni@easystack.cn>
 <abd79c61-8782-442e-b2e5-d3019a633ad3@lucifer.local>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <abd79c61-8782-442e-b2e5-d3019a633ad3@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9a064913d30229kunm86c356e9b31f87
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTxoeVkNKHR4aGkhDTEJLSVYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+
X-Stat-Signature: mnw9de3xx65y9doozs5783igs3wce1jh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D6A95100003
X-HE-Tag: 1761042048-29972
X-HE-Meta: U2FsdGVkX1+JHuYGi6tzNVQr/k1g3m8isxGP3b8qjpM8rB6SXmc6haM41OJQC5w08ekBUMsJLn1mk44FJXGgBfwPkuyp0/XGp79OfkYmMFnHZoZGSQSiANZT8HiiUzdkiLH8WO2Zw5JJdlGPWDBwEqiW7bSY/SXH6cU8lAw1elr5q0EyLEd5ZJv3G7FwPgegzzNltacbIOAQaF+AFntr6Dl/FgmPtlTYKgWIIQZjBGJzP8MCCTAP32UpIEkIhuVTdTsTeQWmHS0xeUR/6VW7iUyNtQPqIpfop2OEVZZ22pvAnR3gmbNPT4sTNsqH2LatGOX5MiwTz3ElsmHLC/KGI1FhOSTHAYdhmanavzo7vE1h7u9hwSjhk9hIBBUDIN377XekL5tyRcgT9ihkF6MYQ8aWUaK/1fbYtu9BF8gKy1HRbM7oRg72JrX4MUMdCQxzlBTcGkE7oeBM6DnBkxp/SHeujgLWS8SijjZgCzbCiYmxHtdgD72FqRmfe80anW/j2pDafp/GngcWCpjNZ0n1queNkcfAjBKozmFdMahZ1h/3piOX1QZCyT7T/leeU4LzeGv9XrG3cyQUL0o9D73vhNzmzS8rnwVy1lkiVeT9HF75OwaDdDXzZRfxqmo2S6JAgJZ/Es5llhP4fyHHmClmThLFoIjgrD8uCpx4YQKOyLNEYtq3Rym2rnHDQ2Gt22V+povffHgoEGb6SWb5EaU+5J2bgrmn2wCOxTSjvP2UGr2ApnOvapClSUCGk16qd3Kz6RWE35hXN4F0DpGC8zSJ00tZ8qeWlKeDYOdLg7Lg2p0XNUC8I0flp1iWvMDcizEnge2cigTBjR7/PFCR6gHHcYtvhRm+Nn+iLk9Zy8PW4JIupntDF5M4YPiAMTiOlfEsKElVfN1p9MX6BBYQ+sZ1wy2Jet4E9ok6FPqUNDpCYJDBI256Ztg1/vlzBKj5gCctO+pX22AqZH4VvjAZt+i
 jTxGEGIe
 7buLVH6FmLGTAqVxS+4vHUvlc4LiiH+2m78PiPn4xibcCnZp9iUqVLXXywJPaL8bHt9/rzgZaG0GH32CV/GaD36lerhHzO3NRW/Bq+RhCdh3sLN5i6c8zFSeO4ciCnVRAXJsZ1WxzAcfl3wllyWuriMcToJApNnCMhG1TH+VWMlXGyg/UZYGnDvo2rzKzTqdFMtwAz2fq4IKeHwesRPAD5+HPMVJFe71TMNHkWfx/6gXwLDwTT61YX0iozmnBUKF4jBgLY9PHXbIGmsUeS+bLiZXcegdqbMhCHEfPIC4PkcxujkH91mCVylZ+2j2RVJG8i9hlLmJmVuAVORE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000012, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/21 17:14, Lorenzo Stoakes 写道:
> On Tue, Oct 21, 2025 at 04:53:28PM +0800, Zhen Ni wrote:
>> Restructure the function without altering its logic:
>> - Check the VM_MIXEDMAP flag first as a fast path.
>> - Consolidate the zero page handling logic into a single, dedicated
>> block.
>>
>> These changes improve code organization and maintainability.
>>
>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> 
> The below is just incorrect and you're making the function _harder_ to read
> not easier.
> 
>> ---
>>   mm/memory.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
>>
> 
> You're changing the logic now? This is incorrect? If the conditions you removed
> are true but also vma->vm_flags & VM_MIXEDMAP is true you now return true rather
> than false?
> 
>> -	if (is_zero_pfn(pfn))
>> +	if (unlikely(is_zero_pfn(pfn))) {
>> +		/* Zero pages can only be mapped read-only and if VMA
>> +		 * allows them.
>> +		 */
> 
> We don't start comments with /* xxxx, we do:
> 
> /*
>   * Zero pages ...
>   */
> 
>> +		if (mkwrite || !vm_mixed_zeropage_allowed(vma))
>> +			return false;
> 
> Yeah this is just wrong. Plus you're now inserting an additional level of
> indentation?
> 
>>   		return true;
>> +	}
>>   	return false;
>>   }
>>
>> --
>> 2.20.1
>>
>>
> 
Hi,

Thank you for the thorough review and for pointing out the critical 
logicerror I introduced.

You are absolutely right - my refactoring incorrectly changed the 
function behavior when both VM_MIXEDMAP is set and we have a zero page 
with mkwrite or mixed mapping restrictions. I apologize for this oversight.

I will drop this patch since:
1. The refactoring introduced a functional regression
2. As you noted, the original code is actually more readable
3. The change doesn't provide meaningful maintainability improvement

Best regards,
Zhen

