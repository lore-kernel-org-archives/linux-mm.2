Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4975F8A14A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB496B0089; Thu, 16 Apr 2026 04:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CBA6B008C; Thu, 16 Apr 2026 04:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAD326B0092; Thu, 16 Apr 2026 04:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DB8FA6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:52:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8ED0CBB01B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:52:15 +0000 (UTC)
X-FDA: 84663802230.11.26AD245
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B1A1BC000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:52:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SG1FGUNE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776329533; a=rsa-sha256;
	cv=none;
	b=1rg9jrK9W+PSiua3LdgCUfZNTsp9kxE6UFj5zPgifwjZvFQ7rQF1IqoiodzdOmncbS6PTp
	+d7f0J18eK2Qys/heJgC9Z22cIr4SLqGxhdbi47Zh5IcrftpYO64Mbdru1dkW24Ui9Y0kh
	lFyv6JmRqa7CdTer+HhUM35QGInaEHY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SG1FGUNE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776329533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLQNB5c5SIaXcAEXHceWox8W9jqfNcCe7ojst1q+QWc=;
	b=IZcjgEKmg4xulCxGTLS2ovAtcXXdFqDtftwDpf2uqdwAX0ZBRdO0Bz/dYi1OoT0JU99Cqu
	I1aKhnreO9MC+3AZFe1g2FnjFvZm7j4/0s7s87m4YiBgMJqjdBsXIPzIxU9ILPwFMtzCX1
	gh3H5KmgeG9nPWA3YgotmG3HE1Z1k/M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA88A442F4;
	Thu, 16 Apr 2026 08:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07BAC2BCAF;
	Thu, 16 Apr 2026 08:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776329532;
	bh=g1Hw4WC9BuiiYPxLoJGIqMt62pc+nYnQvs95d3Tl6IE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SG1FGUNEpefy2PFt5pAPpydPb/RP3GVGwvaunJ/FzQfLwUhy55cvvCAZHOPqvXKpc
	 I02KO1WCvxmiAZJBMYl5Cxmqx5wdgVKUN0SUb2yg8cK9h5NYsMKC/yH9NdjBJbzMbN
	 fINLRueFjs6cPypk/vRCriX33RnKA6LsjX2g/pEtnbY6dpBQ62DbthA1HIrKSEob/A
	 tg14TjjV4niiGvv+33alXBnmf9oSoRH+oMn+sG3cWlVLW6Cn25BPAfIaOwM09AWdzk
	 7cLESpUb2sdyMVI4S0oPe6QVEwB1AlVfnyisb0IEHEsj9j4MB47qI+eBntuo4hiSkR
	 SOkkpg8Zohgmg==
Message-ID: <7c5cffc5-f4db-490f-b8aa-6604c32b34f2@kernel.org>
Date: Thu, 16 Apr 2026 10:52:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zone_device: Do not touch device folio after calling
 ->folio_free()
To: Alistair Popple <apopple@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260410230346.4009855-1-matthew.brost@intel.com>
 <adxnwZMn-BHD5bAA@nvdebian.thelocal>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <adxnwZMn-BHD5bAA@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: j4qcy6isdqjhwbqrfkeeodjwq7ja9qbd
X-Rspam-User: 
X-Rspamd-Queue-Id: B1A1BC000D
X-HE-Tag: 1776329533-870342
X-HE-Meta: U2FsdGVkX18suOMlgXU0dL2qiuyQWaN5ny0y7P8xoiiVkyAA4ZJrTX68TNn43HAUM1HiIzIP1n8gmq8cgOlxR4JebxslJLKQJXems6hx+BmSbk+LlpwRIQI9+oONNMlb3HiwzWsp1wnhK7DWGvJtdbKbvPYn82847IRAFuOjiyB25iqrJdq/6Zte2CCcGDtk/5Lu7OXrU3X9zQYKfqTCQazv9YZh71nfCdNlyCoN8+WXUD8TO04QCAzZbt3KBLln9jcXbcAg7DjYSuRqbBrD0QHl/2x/kZgIm6ySzvRhQhPzzKiVE9TaX2SDlo7G5mTLk+TlY4AsYVW5+WAerOGie0w0qkjVBo6qz0M+Czk8RTnzsiSAawVv7o+T9rLeVlXnLx23vAogWRUDST1TPVRhLxIAtXqhdaW7GjUK/pGJLyKHQJrcBZxfRsOo4r2xFICjKV6INOAKxIgRkdrgheXMw4NRKEdMbUEA60ErWFL2hC4d10AB///KbQhAR4ptin/aH0qLKSs40LpU8ZUpIi7d01GYRXUEUoSgwYUoASnqJPGXoIciXAiUTw8yGvT9ErpOHED6VIwcTsp9GRS2Zh2RmPNNkos9k07GEO2Ljz3bDV6vZMCWwjaDdtAj1sifwLiw+hZLEwzizYTusj4weGBas64FzM61a4TnsNHa1EfJR+eauuhfBwDEUwhC6MJbGjjvn5cfHZuAa9Q25bYxlHbTcAEYRtcqkab+IC1kPke0XHiOKib+m6V4GkuxWVTtbiB6XbFnW/fcNNmS02VLD2kx4wHNOXQQV4cbjiI/t/TdsBKieC7eXkJvwhbpgXpjItO2wszDvWXovRlQ1zUNP+bzXSdrUXGzMyJe52JFE8K84wCbb2RZkloHuQ0qbDe+20WMWSDxvPi/cYcee3mwaj+phhgZ3wBEf7NvrVIF1H3z6/sb45+FUz9rn1v37bRFaGLHl7OgnjLTh6K4z2jJ5Ap
 JgiFH7q1
 Oi7+PS5aA/KQ1byWFZmktz5SXGWkZlwIJGev3Ef+jRUSfyw0W0GprJ6wBVc6MKn85V4TY9HecglWGdtx5PSPSJ99HhrJAAfQKdNIg6o7/vtDT12KzFcfIATwBkB5NpqMcXYYLRyv1Qnx+5ggIwfr0HWN6UMUTBMxvHnr5FY2lY9NctZrVw+nA2PIraQyjn8hcS/0jl5KHfZFXjhFEk5CPuh2xk1DOFeKtUBQ1sMn/FzUTQF61LYjH1qBE72au8QVmdHbojhVfuTepmI7sGupPCBONdfm9gEMoQu5KE9kc/SVY3nYHe6eTOiozX2rWnlEHz7CThbEqD4a3uRsKRAljo0nxtt2T4YI4wn0kvpFQtsNP6mSglOHjT8yRKrGpXYO7oy5pBVKaBzVrFypKsQvASqvlUTVr/iOSFZ9IdKL5I4ohDazM5HMqKouV495IDoINNWkaaDE1LullRNIDfzBu9SiVTy0vcaw4yM19yZiOg0z0iIhiOOFcivYeiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 06:06, Alistair Popple wrote:
> On 2026-04-11 at 09:03 +1000, Matthew Brost <matthew.brost@intel.com> wrote...
>> The contents of a device folio can immediately change after calling
>> ->folio_free(), as the folio may be reallocated by a driver with a
>> different order. Instead of touching the folio again to extract the
>> pgmap, use the local stack variable when calling percpu_ref_put_many().
>>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-cxl@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>
>> ---
>> Stack trace:
>>
>> [  631.875165] [IGT] xe_exec_system_allocator: starting subtest threads-many-new-prefetch
>> [  632.282992] Oops: general protection fault, probably for non-canonical address 0x900000000000000: 0000 [#1] SMP NOPTI
>> [  632.293469] CPU: 8 UID: 0 PID: 59267 Comm: xe_exec_system_ Not tainted 7.0.0-rc7-xe+ #281 PREEMPT(full)
>> [  632.316023] RIP: 0010:free_zone_device_folio+0x149/0x240
>> [  632.339782] RSP: 0000:ffffc90023d1fd00 EFLAGS: 00010206
>> [  632.344947] RAX: 0900000000000000 RBX: 0000000000000001 RCX: 0000000094472d4d
>> [  632.351991] RDX: ffffffff8155c76f RSI: 000000006f2213bf RDI: 000000008e84943a
>> [  632.359042] RBP: ffffea0ff4030001 R08: 0000000000000000 R09: 0000000000000001
>> [  632.366094] R10: 0000000000000028 R11: 0000000000000000 R12: ffff88811828e400
>> [  632.373145] R13: 0000000000000000 R14: 000fffffc0000000 R15: 0000000000100073
>> [  632.380194] FS:  00007f2f0fdfe6c0(0000) GS:ffff88890a7e7000(0000) knlGS:0000000000000000
>> [  632.388186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  632.393870] CR2: 00007f2f002e90f8 CR3: 0000000106708002 CR4: 0000000000f70ef0
>> [  632.400919] PKRU: 55555554
>> [  632.403605] Call Trace:
>> [  632.406039]  <TASK>
>> [  632.408131]  do_swap_page+0x146d/0x18c0
>> [  632.411938]  ? __pte_offset_map+0x3e/0x190
>> [  632.415994]  __handle_mm_fault+0x6e8/0x8d0
>> [  632.420053]  handle_mm_fault+0xbf/0x250
>> [  632.423855]  ? lock_mm_and_find_vma+0x41/0x6f0
>> [  632.428256]  do_user_addr_fault+0x168/0x690
>> [  632.432399]  exc_page_fault+0x74/0x200
>> [  632.436117]  asm_exc_page_fault+0x26/0x30
>> [  632.440092] RIP: 0033:0x5587554ff70d
>> [  632.462142] RSP: 002b:00007f2f0fdfc970 EFLAGS: 00010246
>> [  632.467308] RAX: 0000000000003fc0 RBX: 00007f2f082e1fc0 RCX: 00007f2f12b3287d
>> [  632.474355] RDX: 0000000000000000 RSI: 00000000c048644a RDI: 0000000000000003
>> [  632.481404] RBP: 00007f2f082e1fc0 R08: 00007f2f0fdfc958 R09: 0000000000000066
>> [  632.488450] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
>> [  632.495495] R13: 00007f2f082de000 R14: 0000000000c00002 R15: 00007f2f1319e000
>> [  632.502547]  </TASK>
> 
> I'm not sure, but I think Andrew likes the stack traces included in the actual
> commit messages. I've certainly found it helpful when debugging traces reported
> from the field so would prefer it there.

Agreed.

> 
>> ---
>>  mm/memremap.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/memremap.c b/mm/memremap.c
>> index ac7be07e3361..053842d45cb1 100644
>> --- a/mm/memremap.c
>> +++ b/mm/memremap.c
>> @@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio *folio)
>>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
>>  			break;
>>  		pgmap->ops->folio_free(folio);
>> -		percpu_ref_put_many(&folio->pgmap->ref, nr);
>> +		percpu_ref_put_many(&pgmap->ref, nr);
> 

I assume the ref keeps pgmap alive, such that that cannot go away after
the folio_free().

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

