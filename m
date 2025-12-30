Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14166EE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5946D6B0088; Tue, 30 Dec 2025 16:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568E86B0089; Tue, 30 Dec 2025 16:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474686B008A; Tue, 30 Dec 2025 16:03:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38F676B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:03:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7ADC139F40
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:03:30 +0000 (UTC)
X-FDA: 84277363380.20.13C06CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 226D5A000B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:03:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+JawV1p;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767128609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENj7zWMVhsX7QNtMSEtUhiyLAQ1BD8Z9P82tvTPN6cA=;
	b=AGj7hu19UzIi7biigrM3ow/tELwvI+IIBKqEQV30DOHB4SUH30Ksu2eR9dzPugEN5ihf14
	OZDqzOBY2tUNWDIreaY9N4LoYfd8grCS+p3gk88GR6h+PxyeYv5EgQarMVDycUZkUi1fOr
	RzHyuIQ3ESRpWhZi2sKe6hGOyCtbDPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767128609; a=rsa-sha256;
	cv=none;
	b=WqnQiQG5kOdH8G1WvJkei7HTB1kn1pZwU6mcIFv0hy5h8bI6x/CKTQZ4IspqqaBFnDNI3I
	JnGq/JxiDl9h4g2iAM5BvKhXjLR22kaOZjPdufOOAKWGlPJMdw7NULP5OlBSPcQUx29Puh
	YkjT9PoUio5CldfB9OGwAblEtd3Zb3g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U+JawV1p;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3DC04429A;
	Tue, 30 Dec 2025 21:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329B0C4CEFB;
	Tue, 30 Dec 2025 21:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767128607;
	bh=bgT10EkK03Svs5fHkTLULngDPsGQUnaYXxpVT6Mb6PI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U+JawV1p69DJMmJH/Z1+xqQnMTK0Yrgs1k//1yynBy33zml61E9GcZcjClkq0F/92
	 zp93yXLLkoQ99qKtUrUpUaZU9jMM23DUk0ugJSFXKF8Pi9oBufClSK6GsM7xSGHHLA
	 uquCXqY0NYnJhlCwKXQPyE3QTf8qMs6N/eGVzItMvn3F4j4gQokEd3L3vTimz/lJGR
	 MIQL2vDQz6ETlcdfR4oe6DizESV81g1yg5Jv4GAEQfFmybryzSWORe20zADLLV6OWQ
	 gdFN/OgSvml37LQSQOuynk9LiF4/sJywgdXOlAFNVgT0xn7JjFHzHz+anBszo/Ar9U
	 fTH5g+UDfA7Jg==
Message-ID: <fc73a7a4-c66b-4437-b581-43bd7e5fae8d@kernel.org>
Date: Tue, 30 Dec 2025 22:03:20 +0100
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <eefae4cc-ec75-4378-a153-c190fdc230c1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z4rypzwz7t43ijmowicyu47hfa1w7165
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 226D5A000B
X-Rspam-User: 
X-HE-Tag: 1767128608-936866
X-HE-Meta: U2FsdGVkX19qezjyeXVwWlUci9RldYvb9Yusfm4LG2Z6YbVOrBgPNZTLQIhfswEJ/nd0Ci+/9Gw0hZUD7xERjX5UUjod5oNipprODIr0oXE0XOmegGPkMXjT3hGqZPH/4VZ+Ozsm7jxfGt+PvCVhMKJeEN5ah6P9gl3ROa/ornIwbKxRrUZBcjvRwv/o/8IBS/f4eAcYw1xxYMDubiwZXSTPHy/zYLD0mwrxXeM1b+o9l5xekFPcPS++W5cpL8FRNvY4/FcvgzHCffFgnuKG8dxfQ4e6cPU/zQTvpgSh0mlfQm6AFu8rhnS3uWTnV08j8Mg7Zmn5+1tH4uz7jJ0cRHRjskCu8aCs+i+7VfVaOwlBjvl07nBcjMX/c3vn0y4JgMqwD5+oekpbURWl4mB3LKgjkm6b1RY3J4u3rkDJHqpyL3wTh3Klc7heSEBHOMink68HBgFTGNN2/eaNdbMW9XPdnWXlgiG1YscE0d4QXuiiA/nGX4vS8o1+JwhClzbf2SGwgbNSyx1G4/3+pqGstaZ4Hdcg7igXJjIh2CBZndp8Ugj5XaBN+3G8qGCZK0PM27lZAX1AYjw3sTTK4Mkj2vkFeIujEvd1riMhuxucZC6rCjiKIYQ+M8UK1mNtWwdch4w6nCsm4RbOR1w4Szg5rHOBrf2MtNPDY9EnhRC7BrQX0WovRxUAOXy/W31145m6vdLmNGmnAQ779H6qrYa1bE/CSE09x/zj46K8A7SnY+rmt/9+fnCq+Veg6ia77AfyAF0vVySU6K0WT/EfI+VIRCXEnzMIdf8EpjqlWORzFlGMWE178rR7nzCMLFQ2xGaK0mViay8FZQIHfBvBkqDqu96Biw1x5CngGeKMcTX+JYsO1ZqG7Wk/vU8GaC54qM6KgfFfpB14sYiYE/3a8QQ/X5TvG5f19sgeWs21/N2wABHFl8g38Pcvv+jWGNx48+hSm5IWPag2ltwoQtq+e3+
 dOoD4J7z
 Yn5ICYFf1msnyNAJlNowixFJZ1ufTKNCNlkbCg2Y7TpX0nXWWZLgQ87QU6FF7+xwazlOSv/SoU4XjlbRwrEk9CC7TvMNGhSogzBu8RijJKDxfN5qJ6nJi84E/Hh6g66jF1RZmuVMhYK0uB3+nxCNcwZPz/IDZMGZhUKu+Lagq0eiCgGTFPcIT9+wozQlPAMZ9HCzrpnwv9NtZt4lV1vFe6tU/iMidoL0EhGvdsfT+abg+w0VCxcF8MBeqp8yfJvtJOcEuyDSe4j993DA8RVIJEqE4FSThemQtrBPK2TjojxpacxU0F9IXgJK4HHGGSHQcnMm8OQwQCqzEbrI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/27/25 02:24, Jinjiang Tu wrote:
> 
> 在 2025/12/25 12:15, Shardul Bankar 写道:
>> On Thu, 2025-12-18 at 21:11 +0800, Jinjiang Tu wrote:
>>> 在 2025/12/18 20:49, David Hildenbrand (Red Hat) 写道:
>>>    
>>>>    Thanks for checking. I thought that was also discussed as part of
>>>> the other fix.
>>>>    
>>>>    See [2] where we have
>>>>    
>>>>    "Note: This fixes the leak of pre-allocated nodes. A separate fix
>>>> will
>>>>    be needed to clean up empty nodes that were inserted into the tree
>>>> by
>>>>    xas_create_range() but never populated."
>>>>    
>>>>    Is that the issue you are describing? (sounds like it, but I only
>>>> skimmed over the details).
>>>>    
>>>>    CCing Shardul.
>>> Yes, the same issue. As I descirbed in the first email:
>>> "
>>> At first, I tried to destory the empty nodes when collapse_file()
>>> goes to rollback path. However,
>>> collapse_file() only holds xarray lock and may release the lock, so
>>> we couldn't prevent concurrent
>>> call of collapse_file(), so the deleted empty nodes may be needed by
>>> other collapse_file() calls.
>>> "
>> Hi David, Jinjiang,
>>
>> As Jinjiang mentioned, this appears to address what I had originally
>> referred to in the "Note:" in [1].
>>
>> Just to clarify the context of the "Note:", that was based on my
>> assumption at the time that such empty nodes would be considered leaks.
>> After Dev’s feedback in [2]:
>> "No "fix" is needed in this case, the empty nodes are there in the tree
>> and there is no leak."
>>
>> and looking at the older discussion in [3]:
>> "There's nothing to free; if a node is allocated, then it's stored in
>> the tree where it can later be found and reused. "
> 
> However, if the empty nodes aren't reused, When the file is deleted,
> shmem_evict_inode()->shmem_truncate_range() traverses all entries and
> calls xas_store(xas, NULL) to delete, if the leaf xa_node that stores
> deleted entry becomes empty, xas_store() will automatically delete the
> empty node and delete it's parent is empty too, until parent node isn't
> empty. shmem_evict_inode() won't traverse the empty nodes created by
> xas_create_range() due to these nodes doesn't store any entries.

So you're saying that nothing/nobody would clean up these xarray entries 
and we'd be leaking them?

"struct xarray" documents "If all of the entries in the array are NULL, 
@xa_head is a NULL pointer.". So we depend on all entries being set to 
NULL in order to properly cleanup/free the xarray automatically.

-- 
Cheers

David

