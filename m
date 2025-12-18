Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C5D6D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED8F6B0088; Thu, 18 Dec 2025 07:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B8B6B0089; Thu, 18 Dec 2025 07:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599F86B008A; Thu, 18 Dec 2025 07:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 48E0D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:49:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E83D285784
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:49:51 +0000 (UTC)
X-FDA: 84232573782.14.7BE5F97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 57339A0003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:49:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ob9xJa4c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766062190; a=rsa-sha256;
	cv=none;
	b=oVAE/gqLbe7ppWJ2kQUcoNSMKAbc19kDCfeW7LMZVQH+DM+obqJHwzyyViJuxisz3qJdUi
	K9Ux4l4eETxEoBUkbHeo/AzjSvFJ0vbJf7OZ8DY1fJZC0xSTl8fKlaJJUUGcD6YUb3n0Dh
	fIXVn0a6zFqaZvK0+f+IkEZKX/NyDx0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ob9xJa4c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766062190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BM58LBgAeenrXQPaxgEDcwaGysxKQLCjtyLTjVNNPP4=;
	b=O0ypffAxXOjPT0l838Q9Wtuskj7fncULnCvu5SsGDm+VXDUzhz+YtSyzS6MrFEqaMLabja
	7GwKN0ux8PNXyd8+WMG5hqD0xQJEP17XyK7KOzX65O4o4qKUSbzcakzZG/DlDoo6CZnaXz
	oVfJ5/JnMxZB6pH0ANnDCSRBEt3O5l8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9ADE260123;
	Thu, 18 Dec 2025 12:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B37C116C6;
	Thu, 18 Dec 2025 12:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766062189;
	bh=HlSDHO4a+WU2i+f2Bhk05iN0w7JfevP2vf0ALQnLCGo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ob9xJa4cl7ez4892sUMyEG1ICEn2apZEEPkkbV5ZtnAXtrEXexNJO2CFjkXovdwW+
	 b0hz+SE5H3DPKeY6dEYuI2/lU/D7mAbEclRoIb+hCqDok8K6Z3AZynyMRvI7j6NwBf
	 A/7RVTIDtI+JreIIM9bbRYt59UP1KLSdpcWe9JwdtpaGpiWDo6phf37yoHLjyec/RI
	 VL3Y44LKNA8SMWTJNWE2znCh022a1J+8GKN9K3ZiMaJGYI36aOURV1kD2v+0P+aN38
	 sjs0AZudKD2cEZJ2YPysEnkznlj4niphm5VrCgerqq2PbaYfL6d9HBYqmKY35ZGeZB
	 nR+BZPPaTc0XQ==
Message-ID: <05bbe26e-e71a-4a49-95d2-47373b828145@kernel.org>
Date: Thu, 18 Dec 2025 13:49:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
To: Jinjiang Tu <tujinjiang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Shardul Bankar <shardul.b@mpiricsoftware.com>
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
 <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
 <4b129453-97d1-4da4-9472-21c1634032d0@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <4b129453-97d1-4da4-9472-21c1634032d0@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 57339A0003
X-Stat-Signature: tpohj7a9i9hzyybusfyeej5rri9nenki
X-HE-Tag: 1766062190-240840
X-HE-Meta: U2FsdGVkX18FSxigX0asM4V2O8Ab69FL1N4uON2FJF85g/i69LcK48OR/15y4BV0uqIBn3Y/ZJvK83M6waVGCGumW9jmJOfU6WoGc3zPcY6drRiLXTctz0Df/mDN0F0JKl01l7jt485Q0hCmZyCUbx0WQNfxoMzTkRFBkwdHI7bXo1elXIybmCBU2N3a3/dAA6H0YQLSlHoxnOnebasaG2g6dB845wUD8hWVt6WGdyn7ZWzFTk+KEDfuUb/2eN4BKH/C6XxjlvWucYYlgaufse4iTxzPD5Hwt8kALPLb7HzHW+2O3ZR8eltGBud5D7TUpXW23w8Lg2H23baMLg53I3vhEIFRnoesRPxvg9UF/q9TnVl6GaODtuhPkcGDRqN5v20gAMZzHKXpR/cE1ZPWnwQy7tXjD2yw5LKhT+zuljXPOna5o4zdR8+Z7UGFib3TKfavh74r0PRFRLe5KgQSw7/sZ5vkiBPMZnsvdRhRcrL/kwQeOvmikeIGV2JSLtrgtRMf9TFvwxo+On/ZaEXZim69QDiu0Ei7QJg83hDJ1aXSYBnR7d3pmqRYCztPNvacZsmCmCL/uO/k5uB3bmy5JIFUengPWAi5jf14dtitv371E0uZ7PKdhoM2okX4D6KzUBepKCKFraHhXRv6sMnKmddN0bJmnVd5lmvsPPVTOY7AkX9jdjuasCIDOK4cFcgR6Fj8y3Kq9QXA5fCRBMCCh7CJzkAxNRe0sIvkfakfyz2mjN0OZIWPiR9FoFwxBKhpdU1YbGAXiWOIQO6/iL1HftGFNIYYooK0EGxZ6YJJif63vS9236uMj9gmIXiAq+ugsmClYOyUta9AWNBTiPxDLSAAvC5H3V9XSkXehnaJYhhJ27MW04wMTQIpUFoDdQSRDK5myLj4rVHzZoA8p2vcCy9N+SOxEJn3ANxMU8OUyQnaIPhyPtsURNObet1lNc/kghM/h+cbf+A9fW4PePX
 l6w49+Wa
 UI9Y0ZhtNf1hQVSC5fPmgSCy0gk1Gf0AaLMBlHJITIwGT3TCsfGY4zDdaWPIovMSnrHkxERShL5Qyl6RalDojaTAKKbJ2GcWgxV23m6SsL/GuF64tOxxgYJeuSV4lPE/S3m40iG34V5TAgaTaHASSJkMXIQXgT2VE4eN5gCX9EePNZN8K32BXhKBzLOKfXFSFEHsegiboymjDNlvjOZG/3SdexfU7GjfWsEmuhp0QMO18Odi833fEMONTK8BUoTVXVXR4T9fSPgISSCa8x4gxe/SCQk/mmpwCBECWwhDEeBaeUlJP73qyqt3fxoLWd8eZKmLkKB4f3r1eWhlTuNTPe7RUWj3IbuPf+ryjpT0k1+JXH37c+TERrH9a2uX8l/XtaS0nnbPX3PznWVe0BU2o/toW9B9T/eoHoq+X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 13:18, Jinjiang Tu wrote:
> 
> 在 2025/12/18 19:51, David Hildenbrand (Red Hat) 写道:
>> On 12/18/25 12:45, Jinjiang Tu wrote:
>>> I encountered a memory leak issue caused by xas_create_range().
>>>
>>> collapse_file() calls xas_create_range() to pre-create all slots needed.
>>> If collapse_file() finally fails, these pre-created slots are empty 
>>> nodes
>>> and aren't destroyed.
>>>
>>> I can reproduce it with following steps.
>>> 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, 
>>> and then mmap the file
>>> 2) memset for the first 2MB
>>> 3) madvise(MADV_COLLAPSE) for the second 2MB
>>> 4) unlink the file
>>>
>>> in 3), collapse_file() calls xas_create_range() to expand xarray 
>>> depth, and fails to collapse
>>> due to the whole 2M region is empty, the code is as following:
>>>
>>> collapse_file()
>>>     for (index = start; index < end;) {
>>>         xas_set(&xas, index);
>>>         folio = xas_load(&xas);
>>>
>>>         VM_BUG_ON(index != xas.xa_index);
>>>         if (is_shmem) {
>>>             if (!folio) {
>>>                 /*
>>>                  * Stop if extent has been truncated or
>>>                  * hole-punched, and is now completely
>>>                  * empty.
>>>                  */
>>>                 if (index == start) {
>>>                     if (!xas_next_entry(&xas, end - 1)) {
>>>                         result = SCAN_TRUNCATED;
>>>                         goto xa_locked;
>>>                     }
>>>                 }
>>>                 ...
>>>             }
>>>
>>>
>>> collapse_file() rollback path doesn't destroy the pre-created empty 
>>> nodes.
>>>
>>> When the file is deleted, shmem_evict_inode()->shmem_truncate_range() 
>>> traverses
>>> all entries and calls xas_store(xas, NULL) to delete, if the leaf 
>>> xa_node that
>>> stores deleted entry becomes emtry, xas_store() will automatically 
>>> delete the empty
>>> node and delete it's  parent is empty too, until parent node isn't 
>>> empty. shmem_evict_inode()
>>> won't traverse the empty nodes created by xas_create_range() due to 
>>> these nodes doesn't store
>>> any entries. As a result, these empty nodes are leaked.
>>>
>>> At first, I tried to destory the empty nodes when collapse_file() 
>>> goes to rollback path. However,
>>> collapse_file() only holds xarray lock and may release the lock, so 
>>> we couldn't prevent concurrent
>>> call of collapse_file(), so the deleted empty nodes may be needed by 
>>> other collapse_file() calls.
>>>
>>> IIUC, xas_create_range() is used to guarantee the xas_store(&xas, 
>>> new_folio); succeeds. Could we
>>> remove xas_create_range() call and just rollback when we fail to 
>>> xas_store?
>>
>> Hi,
>>
>> thanks for the report.
>>
>> Is that what [1] is fixing?
>>
>> [1] https://lore.kernel.org/linux-mm/20251204142625.1763372-1- 
>> shardul.b@mpiricsoftware.com/
>>
> No, this patch fixes memory leak caused by xas->xa_alloc allocated by xas_nomem() and the xa_node
> isn't installed into xarray.
> 
> In my case, the leaked xa_nodes have been installed into xarray by xas_create_range().

Thanks for checking. I thought that was also discussed as part of the 
other fix.

See [2] where we have

"Note: This fixes the leak of pre-allocated nodes. A separate fix will
be needed to clean up empty nodes that were inserted into the tree by
xas_create_range() but never populated."

Is that the issue you are describing? (sounds like it, but I only 
skimmed over the details).

CCing Shardul.


[2] 
https://lore.kernel.org/linux-mm/20251123132727.3262731-1-shardul.b@mpiricsoftware.com/

-- 
Cheers

David

