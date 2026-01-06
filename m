Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E75CEFCF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79FB46B0088; Tue,  6 Jan 2026 13:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D316B008A; Tue,  6 Jan 2026 13:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64BA96B0092; Tue,  6 Jan 2026 13:55:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 545986B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:55:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA43B1407E9
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:55:39 +0000 (UTC)
X-FDA: 84302442798.03.22328DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1E929160008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:55:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=USbYp16l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767725738; a=rsa-sha256;
	cv=none;
	b=VN5rzvcUWlsCtINRLIfRDeZoB7uiB/ChMJObR6talgfIRUPfYfsVeSTuzRyu7KDI3ZahwB
	3rVRx4bRqDMZ+sQZ+0TAaBZ2ITJpMAX3FZiWQtarITCA/rFcaTalnUGzImTCeOFAJSr1gA
	rskFOn0qemozgfo5r8GT+FSCM62zOdY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=USbYp16l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cgc/MRC2Kt/tylO8oRaEYCBG9AfDbKFCC5xErnQMX6E=;
	b=P8y2gqA8yVyHpVBPibhmLYXZEFlXOi3FXIgxSS9AwMUmr5BxcFmHvweVbOTROfDiuQLC6v
	l9OmeQLLhju19IMY2hzd0ZUUH3hZH48g/gwmed8RtUTZW04acwx9PWCt83yLoPLeJ3hk4F
	/TXZH9n0c5416mxuG4Nx/w+CXGD+muA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CD2260007;
	Tue,  6 Jan 2026 18:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F119C116C6;
	Tue,  6 Jan 2026 18:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767725737;
	bh=l79MN7k7m7NEtZrL6dffvPEx0BF2/cRLOCmREMCGAsE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=USbYp16lLYrltyJvcP4H6/5miQe/JsVg+JK/ckh4Y7nMkM7bXWBJQCjg+7X6pCvjY
	 vZ+IbRdDhXsNpSGmIfbRDX2J7C30nMpLrZUOybTUBWwi66kE/F6iXWeAuwDCOTpf0w
	 wmyjJ72zd1l7CfrR8kd/nbmhHue9BdX/0BOZjyAilN8S9uvLGfbyDkxH1UDr/C/f7L
	 4ih5zK2fuLFlo2va1/TuPAjk6tc+dtPOcA5rnoE+VtfSlE7K/+5LFLymzcyZtB824P
	 RiMuSBBC0Qv4ZxRfOBF4FlbB/0ENUMV3QKJwDkqQkj/8j2ZkaRgJoLMZNcbD0KGwwn
	 BKVhf5gtS/1fw==
Message-ID: <ccd2cf6f-e2c5-4229-baa9-4cb3834b8f70@kernel.org>
Date: Tue, 6 Jan 2026 19:55:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
To: Jinjiang Tu <tujinjiang@huawei.com>,
 Shardul Bankar <shardul.b@mpiricsoftware.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, shardulsb08@gmail.com
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
 <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
 <4b129453-97d1-4da4-9472-21c1634032d0@huawei.com>
 <05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org>
 <a629d3bb-c7e2-41e0-87e0-7a7a6367c1b6@huawei.com>
 <308b7b3c4f6c74c46906e25d6069049c70222ed8.camel@mpiricsoftware.com>
 <eefae4cc-ec75-4378-a153-c190fdc230c1@huawei.com>
 <fc73a7a4-c66b-4437-b581-43bd7e5fae8d@kernel.org>
 <43024ae3-4131-4381-a766-5ca674d3f87d@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <43024ae3-4131-4381-a766-5ca674d3f87d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E929160008
X-Rspamd-Server: rspam10
X-Stat-Signature: xktdx6dtmgt6ia5q43qn4t89m1c1bccb
X-HE-Tag: 1767725737-804888
X-HE-Meta: U2FsdGVkX1/OzDRPyp8/t1RhbJk5wbYSTbM8wYEwE6xe2YTN8V9xbI+UDJ931rzfKp0FLpJHy6C3NSZ0kTWPPgwhzJkgv/0OGQ5Hp6GpDJ18H65n35EL5RPNncmxBS7EswtduG6ndYB/IMXfM8GT7kXzEz9m+NbWoOgGLy1MzzKGRx4e4J0Jca4NrrGp0CodSuVOPeLsoefzSH7mzu7kYoyVs0Yk6yshkNDNuWYih2yadXRYA2i2AHLzZOTbkPesIMwlSvo5v6/jQsz8olLXce3Vk4tHhjCDmkko3a5NfhZ+wiJ1+0XLKGNJ4fB5Rs3tOjWtedrx/lB3s+3UVvHmslbZST0C5F8jkHixRGpJ3z+PPLRzhPpPA4HceaumX55iQQsr43L3ym5JxtoYoMvQkAa8w4KNSsMY5I0f+31g0zneyFdQBZGHKNKf/yVNhRDQgNA6ucrfG/aq7A1PAOYOaoyZCvddidonKQ5KV8ip/3A5p3mNoeIKnXy/vPhbxzdPDQPDZvJthMj6gOEtL/fc0SYyM/QAFcFPRIaj7mVIuogvT/tzZgp27D0aK1GO6jySKU3v5NsJX2V97qgY1oigUnCobcKNY1rIVYnlQ+DC0i1k6caSvkOF3Yip8iCzgkuTIrAi4waZ4+CjrOGQsdCgWAlWJkgRkubiFXJsXLPkzg4zdxtq7SM4Vmjb3z7vDL08fhpKsgWIMkmhnpKQrcuqT3pZigEnVAydaQWaBlEd8PUFi8ktjOQy3S2S/M9SqMSwrXF+onsseQGNs/Bg+IPOzsWQg1LiAwUD+uZnsAhyN9WA4CHWApYcwsblj41I0DsWv5++nni+gK4+dAeXAru942EDBKeHx/H2zfRMd0oPDQ+0SuxEB+oTDw+fyHqrU6kCvX+sE5HhUHFa6BpG5kDlZd5503JMuh5a1PBv15pqmmtZcfEgzHY0gLuFMEYjdxzNZl/LVixD82NXexh97JK
 LlWvZ345
 2HHXLLCdlboitcp1LenvS1MvXQ19f6X4ZiPV2UiJbn7ZSEn7MQw7BxKjrcOacyZe3AEnhpvnUGOrP0y2noKuNuPFMYYrj6C1CSUfNvBd0m2xPuYSwjWyiIT9L9WxAaSya5Yy5hI9tUEW2iR0Mz3/WXMYkCxzgN+BMnCi9dd1rj4rnu7ajASYuaJIUs764eI97V2j7fPA7l1LJR3NpAhPCeWTY+szHq2KAxSrGFZloip5YnYyc98+oZPuLVYb4v2+OBwfwsrtRxLiFIkgdB0eDCBIb68dokf7um1QIPZM1WKNg8dRbNvJs0/sKiXHFXf8/vSteb2DgSAmn3nY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/31/25 07:29, Jinjiang Tu wrote:
> 
> 在 2025/12/31 5:03, David Hildenbrand (Red Hat) 写道:
>> On 12/27/25 02:24, Jinjiang Tu wrote:
>>>
>>> 在 2025/12/25 12:15, Shardul Bankar 写道:
>>>> On Thu, 2025-12-18 at 21:11 +0800, Jinjiang Tu wrote:
>>>>> 在 2025/12/18 20:49, David Hildenbrand (Red Hat) 写道:
>>>>>>     Thanks for checking. I thought that was also discussed as part of
>>>>>> the other fix.
>>>>>>        See [2] where we have
>>>>>>        "Note: This fixes the leak of pre-allocated nodes. A
>>>>>> separate fix
>>>>>> will
>>>>>>     be needed to clean up empty nodes that were inserted into the tree
>>>>>> by
>>>>>>     xas_create_range() but never populated."
>>>>>>        Is that the issue you are describing? (sounds like it, but I
>>>>>> only
>>>>>> skimmed over the details).
>>>>>>        CCing Shardul.
>>>>> Yes, the same issue. As I descirbed in the first email:
>>>>> "
>>>>> At first, I tried to destory the empty nodes when collapse_file()
>>>>> goes to rollback path. However,
>>>>> collapse_file() only holds xarray lock and may release the lock, so
>>>>> we couldn't prevent concurrent
>>>>> call of collapse_file(), so the deleted empty nodes may be needed by
>>>>> other collapse_file() calls.
>>>>> "
>>>> Hi David, Jinjiang,
>>>>
>>>> As Jinjiang mentioned, this appears to address what I had originally
>>>> referred to in the "Note:" in [1].
>>>>
>>>> Just to clarify the context of the "Note:", that was based on my
>>>> assumption at the time that such empty nodes would be considered leaks.
>>>> After Dev’s feedback in [2]:
>>>> "No "fix" is needed in this case, the empty nodes are there in the tree
>>>> and there is no leak."
>>>>
>>>> and looking at the older discussion in [3]:
>>>> "There's nothing to free; if a node is allocated, then it's stored in
>>>> the tree where it can later be found and reused. "
>>>
>>> However, if the empty nodes aren't reused, When the file is deleted,
>>> shmem_evict_inode()->shmem_truncate_range() traverses all entries and
>>> calls xas_store(xas, NULL) to delete, if the leaf xa_node that stores
>>> deleted entry becomes empty, xas_store() will automatically delete the
>>> empty node and delete it's parent is empty too, until parent node isn't
>>> empty. shmem_evict_inode() won't traverse the empty nodes created by
>>> xas_create_range() due to these nodes doesn't store any entries.
>>
>> So you're saying that nothing/nobody would clean up these xarray
>> entries and we'd be leaking them?
> Yes.
>>
>> "struct xarray" documents "If all of the entries in the array are
>> NULL, @xa_head is a NULL pointer.". So we depend on all entries being
>> set to NULL in order to properly cleanup/free the xarray automatically.
>>
> Yes

Okay, then we really have to tackle this. Any takers? :)

-- 
Cheers

David

