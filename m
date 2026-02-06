Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E32EB28E2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 08:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159B96B0088; Fri,  6 Feb 2026 03:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106FA6B0089; Fri,  6 Feb 2026 03:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20DD6B0093; Fri,  6 Feb 2026 03:46:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF49D6B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:46:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8113A1A0641
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:46:46 +0000 (UTC)
X-FDA: 84413401212.25.79962BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE56010000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:46:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cd2IjknD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770367604; a=rsa-sha256;
	cv=none;
	b=LWOmHMQOjKtJgzEnkQ9zZsgrFJPpiDLFgLzUQr8O+rnVduW6eizlg5Zp12Xgo2Iya4GG7B
	W03dIknSW728b76jXk5qv50IpJSe+d3BUEcDG6ZTI8deIOQ3hZt6uTfKAfES9FPAN9+bvh
	gRChSW3d4ksA9wl6B8lM0Pp25ezaP7M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cd2IjknD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770367604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twlwJRQPlVuaEt+rsMn/HrxLLGGeCuGXe4Ucw2ywtS0=;
	b=DfedWPx8R1Xcrzcu+07amucPOA8aCxpyganCQoUD88nMF+GOnI5s2b7GSQumzQxYs+euDV
	Lh/W5UaoZ0AVr799T92zqnixxoX12nIPmzVtzd5g9A9dNOb6dB9qw/bjIsc5EkBASsgbG+
	1n9E3AGfeupDUZGtgBY0GJKeidpHZCw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2249160010;
	Fri,  6 Feb 2026 08:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B7DC116C6;
	Fri,  6 Feb 2026 08:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770367603;
	bh=vchmqJmb2mGDzQ5x5W+qQCMF+BxTNhOa/z4vEqJc8JY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Cd2IjknDbdngmTYRAHlMyH9MekbEjkFVmozUJp/COGZI19pcTJnY0rNhFUfqrqndS
	 UBJKaYmS2RiZNDQWvIZ4G7L42zymEiKNkxbyLiJ0hlPvCxtIwWvJcOkw4KMMCb2Kd8
	 +4VzoOWTRqe4RGKPudwWWwDj1SppAG2VMtab3T0f4bR9fOemtAPvczwUUiiMbCYuC/
	 ilC3bgaqb34EUYyN/lcVUqec/vp4tVz36nvAmgqBOEWnW85zTEXU1PBQkLDBvlnZ4C
	 eEfXdrx6qETuZz1hbBxD5p4CnHBtyg0snmRCpUQBTDISlHWVjhbrXNcISMm1ndFd6p
	 8DVOWEghBCFog==
Message-ID: <e1c00847-0f97-4ef2-9d7b-5ffaaff62c0c@kernel.org>
Date: Fri, 6 Feb 2026 09:46:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksm: initialize rmap values directly and make them const
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, hughd@google.com,
 wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260206163850402hEblYPDgLSG4M7CT1ju2G@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260206163850402hEblYPDgLSG4M7CT1ju2G@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CE56010000B
X-Stat-Signature: bhhunu8m1og6wph4gjjqib5kke1qie3h
X-HE-Tag: 1770367604-821542
X-HE-Meta: U2FsdGVkX1+toBzSmLhYMk3H44DMVo+yMLafv1uHhSLi8yLKvBP07XfWEkYmZDLxEW9SZWQHLBb0M7Vfj39z8ZHwWTrwr2OZ3ukOkdS8ElpbzHNofgK57QNn00zqqeWzhfWmoioy2zk3GNWz/XlbXUbtssUKJEFG18vbSSxagH80xtkJzj26s+u4qXbSVl8JarftYmLfCgnMAeEd6ybdB+pDyH672w7VxWHrW2tL8FzvwYsXW7K3nQ3Bqondh3v2gcMEbfFeGDnvW+MlzJsOR4UoSXVmPlmvkWuSxDODE16PC6YdraM7ChKL9KoatjXzpsRPozA+FRdYHYF5wt5jbxuD+JK6B2NEPJ2M+srSI+VG74yoB9kjchSaLfI1Us3tK+tNELwct76RdcHJFukKKjBjA1XBCcjtdBMVOVSIJaK3QPjCpM1MHAZeqUrs0s5CX7t+EV6ycZh8Twa3rdaro5negzCvpW//8mXT55MIRr6S5r7+VFHtjmHLB0BslSo6YqiOLUegcpkIat64gcz/e5znRoK+OOSLjuPHla1uE9urWlqaY1+EQ9ljyfqUVPDAGxAmW8dxk8LG3wAuM+e4rnwMG88g5+hCN4i2NAMfFFqIxY+r4xZVeak53n+i4CW7xKbQ4x/lIAZwpmEAsWTDBEMHEwKtU2tVjNkSYfN+qnSKt5SL0g5uEmy2HuRd2SCQVK96JbQsRVIFMsD3w5LTkWLA+sL14ME1iag9OHaKuNl7xLa40466kXb64Wsx3nnqa33ONNOYVOz4/4mXt/SplB88T7H2IFnf1gXap9xcs/Mcv4DdeYgTkpAlsYqVmBtmASO6C2i5WQfer9kDnkO6CmS0MId9U9SUNxnGGNz7ZwJWTaozgzk7sg5L0kdRTSmxZmac/QPR3oQia5Z39Pkry3f2SuDasgcYBGeHHLCzBR/YI8D/pKVJFMEKPbscN4jY+b+VuJlFcVxGEvRC5KR
 pIgEF4Ex
 o3ZbqCKIoIG6piMjsrgeNhMFGthkvqV/i2RIyh7B9vyTuvSh7o121bgGqC8YLj41F6erox6ljy8tnTmun7MOvIuPJwnp2UH3nttKRKZnG9i6H/fmnCDdXzNnPHmmEyt26jKzZdJ/IR4h7lMLqsaMrNCcJ+radFlULFj9YrARrH8iKCOSMf0CHQkpZiZ5ebX+vVcBoUwQFccSzmnctBQx7eK9HsxUxxIbsuSFQnh3GkmHFY4mVW9Uyxz8Pb0lhbgS626KQEPKMdVTXL5XZ56ZNp8n0LWlGsaM+0pV05LBArTByAGzY6Yd6+7zhNRBmjpJ18ZkqQ2X1cNVIeO/9N0D1MfgpvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 09:38, xu.xin16@zte.com.cn wrote:
>>> Considering that commit 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing
>>> a suitable addressrange") seems to have already been merged, this new patch is
>>> proposed to address the issue raised by David at:
>>>
>>> https://lore.kernel.org/all/ba03780a-fd65-4a03-97de-bc0905106260@kernel.org/
>>>
>>> This initialize rmap values (addr, pgoff_start, pgoff_end) directly and
>>> make them const to make code more robust. Besides, since KSM folios are always
>>> order-0, so folio_nr_pages(KSM folio) is always 1, so the line:
>>>
>>> 	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"
>>>
>>> becomes directly:
>>>
>>> 	"pgoff_end = pgoff_start;"
>>>
>>> The test reproducer of rmap_walk_ksm can be found at:
>>> https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/
>>
>> Thanks!
>>
>>>
>>> Fixes: 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing a suitable addressrange")
>>> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
>>
>> The patch does not seem to be upstream / in mm-stable yet.
>>
>> Can you resend the original patch with these changes included and the
>> reproducer referenced in the updated patch description?
> 
> Sure, I thought the original patch was merged in linux-next.

linux-next is just an integration tree.

What you want to look out for is whether the patch ended up in mm-stable 
or mm-hotfixes-stable

	git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git

As long as it's not in there (1) the commit id is not stable; and (2) we 
can still modify it.

-- 
Cheers,

David

