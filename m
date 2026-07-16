Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E1BC44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 02:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58936B008C; Wed, 15 Jul 2026 22:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09686B0092; Wed, 15 Jul 2026 22:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8836B0095; Wed, 15 Jul 2026 22:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5A16B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 22:20:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F5CC1C0295
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:20:32 +0000 (UTC)
X-FDA: 84993035904.22.60B2AE3
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7875B120002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 02:20:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XJFjXOtu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784168430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ac7HRN+Zrg0m4L5nhssnYzpnRv8tiOpkPSbq9tln0dA=;
	b=c+sB9zWnglehE8XD95cwJQuzdZZljY3LtZHdcZpQdT2rf7BL3Z32ZWXvnr9FI570yFUYsV
	uaPqFQ1F5Ek7O2JrAukaBfto6h6a5WmfG8Iefe7PseAMm67a7Q45rOL1GCGlBoHhD6wXo2
	Lg2tv5UQ3bKkhXoQC9T5BJ36VIx0n5I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XJFjXOtu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784168430;
	b=oY4+7VHbdng9H9ahaCxm4S6dj6Y+BkZg7riDy92j8wOwkVDGtoor0Vm/PMMA1ConQxXOVj
	bliQjU1BPygH+qFcr9puW17s/nf9rP6M9CSn2WW7v1aLxezzQXnhXTFqrF+/hAT0iuBwLW
	Mc65CdMLlnWKVXZdczFU2cHkD/KWJk4=
Message-ID: <64be6bbf-4e9f-4cd9-bfd5-24ac06286f1c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784168427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ac7HRN+Zrg0m4L5nhssnYzpnRv8tiOpkPSbq9tln0dA=;
	b=XJFjXOtunpSgHQCaCPaZj4YS9rC6Kdlsnl5braXNAMBzOQODTl14Y2xR0xHLmtmUNmloqX
	wYG8QeBIdDmTqWQ8I7CxuIrFTAM+PW16wiZQhH5Bs+esq19eVKtj51vjOVIBTa9jqyJuBN
	0nChjra0ZrRyNtp3Gc9yQSH6e2l9q3s=
Date: Thu, 16 Jul 2026 10:20:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: shmem: make unused huge shrinker memcg aware
To: Andrew Morton <akpm@linux-foundation.org>, brauner@kernel.org
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, Christian Brauner <brauner@kernel.org>
References: <20260714031918.308-1-qi.zheng@linux.dev>
 <20260714213223.9a03d78f4aba252c512e01b9@linux-foundation.org>
 <ba9911ee-f447-475c-bd4d-ddd6bf443bcc@linux.dev>
 <20260715124030.feb2d407e5e5ae28a39674a3@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260715124030.feb2d407e5e5ae28a39674a3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: niq9puogu1mpdrk11n3rp791a4m18pxh
X-Rspamd-Queue-Id: 7875B120002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784168429-657645
X-HE-Meta: U2FsdGVkX1+yF8xXrZ1o3fpiU6NX4cYZyM1b2b4ivPVfAsqLZ4XaSubTkWvmjcH3f7QLBzvzrAZXsmOSieP3fP9gDV8Q3haz4nGinRzIk5I3kuoLR9lVAjU1LiCv89Ja0F+wE+9KsBzXLVt2lxIQcZZWec/dJe8Mhq4EzegxKEFoRjpxw9hYFUMUqA247G6UZukgWcqoK2U9rcUq9ZPrhjsoB1MgucjfOnt7Z06llINAiNYWOt3L5g6jCsQhP7u5ExJNcoHtKhVvyffrkvcXIyQyoBBpIuv0sL3WCVgLchxDJWVQO9A/I4n+JhJ8HxosqtuqsT84hqoF7Tv17XXLwA6h0rfnAUrcH1A9bOziXKbKRt8c/lg/Xsix9nAfzp5B37gExzPw5LjMbEm3bNXg7nbL5GZUcS5OaxK2vzdfe6xl3v0rqEKQs37dH7Y66gwxQPa9dKO9GQs7/Wa13Wh2/0QfPTJqvk4I1HP6CcfswexRpHtl/rYpTQamx1bA27ozVs26AT3YhSkusj/ySNdcG5R881EzBnEyg+uDukQU2l9DbvmEW/R80kDTCgtrETcX4pOLCNbT2qsfdhkVmt7V11e+HUc/MgtoGDf1FDYwZOGwGevFrDZExizj5TbkW7jqPt7+Jq5u2kH4yHFV0RlebK5xbB8PPdnL6MQxE2ex5wh68Dkccwsqfn/uB95lTu8bHMQV2DLyMhv+TjG/gTDDupAhDi6vYUe0HSLv0bXM8TJQSNuKKtL92vrdwsb4GS96o1kHfimhqyfuHX6X/hD21cXcVcUOcFZatPlASBjxch0bylxKqF2a9OvZMHQFGPW6VMI10lvZKEd78LZnS0mP3vHlBlR/719huPJ0I/5i2j+A6AXRP2zghQjJKaxHZRhej6ZVoBSrZ5xh6D1FqDMMKQyyBXu/bHRTwJKwAgnuscKIpgtLgMl6sQy9ILRRWi1nSBRDDbULn/AuxENywta
 DhcO82YD
 lqtXUxEiB+J+kPd3Tt7lXa9T5wkqFzf7MYf40HW4J/k735xYG58vG275aYITXGya8e9pNlXHT1dD1FRD1/GPggxIMWUoDbNRXRYJotx9fziTqSgAIMAHw8wkE3gCcHv33ktVh/faR3IB1vPIs1kSDJ8U3XhB1Tns41rAC5ISSsYEpsFtJULhZkDgAvlrGsSblTVnuYaG2lUItpk5N+npMQX2CLZMfqKeXWLvUTB9ssxU4nhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/16/26 3:40 AM, Andrew Morton wrote:
> On Wed, 15 Jul 2026 14:49:28 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>>>
>>>> This patch is based on next-20260701 because it doesn't include this patch:
>>>>
>>>> https://lore.kernel.org/all/20260609123047.1948242-1-usama.arif@linux.dev/
>>>>
>>>> Later on, Usama will consider moving this restriction down into the fs callback.
>>>
>>> I'm not understanding.  Was Usama's above patch ever included in
>>> anything?
>>
>> It's included in linux-next, e.g. next-20260710.
> 
> Oh, OK, it came in via Christian's vfs.git tree.
> 
> 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink")
> 
> Should we be asking Christian to make some alteration here?

I saw Usama posted an alternative (now at v2) and got Reviewed-bys:

https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/

Hi Christian, do you have plans to merge this into the vfs.git tree
recently?

Thanks,
Qi


