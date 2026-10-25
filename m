Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3891606A31B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 10:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QMXrqqMs
Received: by kanga.kvack.org (Postfix)
	id 12FDB6B05B3; Sun, 25 Oct 2026 06:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1326B05B4; Sun, 25 Oct 2026 06:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11306B05B5; Sun, 25 Oct 2026 06:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5DCB6B05B3
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:56:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D37116043C
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:56:08 +0000 (UTC)
X-FDA: 85360844016.14.3D70AB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 84DA91C0006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:56:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QMXrqqMs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792925766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68QJafW62HgkjotUsbneO0EWoKRkIg6fDkzU/Qf+g1s=;
	b=cjWQNu738cu+uATH6QpcJrqUa/KL2YmQW59ola3wF2U23wcf6uKBp6+O0gogz9Fy9RA3kF
	3CsIUCrN/MYXz7HtpIlttZGjqVth0im8SecbrA1KxXWhXNrGx6EQ/WLj0Y9tv+rEls3HKa
	6xpAAFb0mIbXGPs4Sx7GlPvViQI2tig=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QMXrqqMs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792925766;
	b=0JM+ErFvYdkyXUyGNIzFA5SIgHnocjghVFERNa+e9MIu8HRC2D83scObE91+8sUSgJ/HvX
	oLryHs758QovwPbk/tW+eSO+16ywnw2J8bBbplTDsdA8HM3nrdT8nmx9Ul3QYG0kv0S8Ap
	0hqeyzVg56urBXA4+ojlnD/fh9m2kXg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA1C5429E9;
	Sun, 25 Oct 2026 10:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA25A1F01825;
	Sun, 25 Oct 2026 10:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792925765;
	bh=68QJafW62HgkjotUsbneO0EWoKRkIg6fDkzU/Qf+g1s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QMXrqqMso456ITXiNZr90kPAO74wrbYx+z54a3x+l9eEMuCfAezKeCbqq2Y+wX32C
	 0qz/HU8V/DjMllMVNsZ7dxS2kR7tjv05cgXujnvcOFDLsJgM6noFufS+AkA9cfsGBg
	 0C85Lpvl1/EXlcjibTd/iJTpsmVptJ+cf7juyho5braCwFt0YC5MlKZfE4ASGGgeSx
	 JjecmP1+6N+QaI9Kppdd/CDp5h3GuqJBbtBE4rrInZxLZpDvcd3p/7+Xcl7UGbkQot
	 QXQZQwBFz+bxBlFkiGuMQ5BrHn3TDOa7ZpsXKfvZyeHiTnvEKf1Uu/Ty6n4qEBXv+y
	 8Z1Dbxv9k8c7Q==
Message-ID: <9aa49812-1132-458e-9bf5-6dba8b476b26@kernel.org>
Date: Sun, 25 Oct 2026 11:55:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: pin mm_users in do_pagemap_scan()
To: Andrew Morton <akpm@linux-foundation.org>,
 Ngoc Quy <ngocquy0700@gmail.com>
Cc: liam@infradead.org, ljs@kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261014095540.3261469-1-ngocquy0700@gmail.com>
 <20261019174659.42c3529d5e35563cc6e5244c@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261019174659.42c3529d5e35563cc6e5244c@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 84DA91C0006
X-Rspam-User: 
X-Stat-Signature: x35cj71sdmyjgcz955pdu6naq44ygz1e
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792925766-684227
X-HE-Meta: U2FsdGVkX1+AiDwifIBIZFBmM93fkGQ8ofSrf9Af3f35J4DKJ8vJWIwqaetSy2wfXj4yIF9/4T8r+1QA32AIJpQF9gTJi/ELoBpDyRE1r/430VJJnI8wThF4hT8uSv7aP0xo/D/hAUfaRYI0k4IeuRdwt6kX7vV4yh7HdgjZgkSdhWTAMmCKwKJfBjmfLpxrFP+/LekX5kASD0kpwUkb6z1zPIg+Q9zgtY6/qCUqj6zulZyA6qYIo6OEahLXYdG7BzdL09XURhB1iFVTgjdsqaWnT/QEZsoApG5LSW4UtGdGXrCb6cU4Xucl4ilOviKRorSu0I5wCBXOEpRPMwI14VyUOdssTzU7p3WR+lhGY1Kp9JMeLgV8pTcNUxc2fXsgbWQjoouz1aQhy3/02et/BOk2r00UFqPPKlDOIaqer0zwYl5YPCqhge+yn1QM+Z0JKHFpW7PoyqngnqZaTK1FkxVtU7ESgH1B/cpNXy2m94eeq0z1EL68xMQAvcHMdh22VuruPblPe+i7U2N2vne6XADnNoou4KdKtjQXBMHlMvAZsztNq30XwaEzHS9/AlnMLu81LbEPkjoa0ms98RBwSMdVlRTbYD59oe2f6VtLSLcL4EgfzBejB6ezFvHtBxfpSVKeMbLFe8Dp1AIvaV5PGRAW1JqB3dMUN4VAn9tNR+2lDAVH0yBmvnuMRHttEImKZsLVuhgI4ACtRg0t9jXce2fwV4QAhvXhhgvIUeZ95vq5JskukxuQ6ds5TbzAwnmF7fcfDIT+3B8gZ2C16JdLDnL4vqu4KrVxZkVqZ8yoCJSa2WP6GR99qyyVnrs7pbzsFl7euoIpqU+5tO4IgHb9csgXOGbfj1ovAEVUOFZ9ZgTJB/u8CgUvCftEj7HF274djIYGuAZ8EwQ81626mqm+tn7b8bYusnQoXxXmyp8Hogw+bZJ6YKQvYfHJUOc+B+2WQ1+G4LoMDnokk1r90Kf
 sfX/kMbE
 g8SadmV86rXngYqMKAv7mePox3cnYA7AcEyPdDvLbZxNjfwUlVwDrA9sD/2uNHZlouiNIW3muJWF3Wor2qAxJJlyWoO8E4sskomjxxmU+LQSkICt80DHCIFuLRUySHRxnHngpoAluNBEil1YO77CX+Rip35XYRVvVY1BpBRUIODnNmcLOrdJImkQmDDJyz3JqYudSSmb5W0i2/B3Vxh01TO/1gEk9MLZtOY7dkCKaEnok/hSpKDzwQ8K160fLi7m1xRX8pVyTRrpOf3XL3qvcLlmUyXrzBHiMa9UDKpZwiQlNGsgkvEzI5yO+YLX2qePvqCPMRRL1nYUAp8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 02:46, Andrew Morton wrote:
> On Wed, 14 Oct 2026 16:55:40 +0700 Ngoc Quy <ngocquy0700@gmail.com> wrote:
> 
>> The PAGEMAP_SCAN ioctl takes mmap_read_lock() on an mm obtained from
>> /proc/<pid>/pagemap without holding a reference to mm_users.
>>
>> proc_mem_open() deliberately grabs only mm_count, so a consumer that
>> touches the address space has to call mmget_not_zero() first. Every
>> other consumer in this file does -- m_start(), do_procmap_query(),
>> show_smaps_rollup() and pagemap_read() -- but do_pagemap_scan() does
>> not.
>>
>> Without that reference the target can reach exit_mmap() concurrently,
>> and exit_mmap() calls unmap_vmas() while holding mmap_lock only for
>> reading, which does not exclude the scanner. For ordinary VMAs this is
>> harmless, as free_pgtables() and remove_vma() run afterwards under
>> mmap_write_lock. A shared hugetlb VMA is different: __hugetlb_zap_end()
>> frees the VMA's hugetlb_vma_lock inside the read-locked phase.
>>
>> walk_hugetlb_range() can therefore load vma->vm_private_data, have the
>> lock freed underneath it, and then down_read() a freed rw_semaphore.
>> The load happens before the freeing side clears the pointer, so this is
>> a use-after-free and not a NULL dereference. Any unprivileged user can
>> reach it with no huge pages configured, as hugetlb_reserve_pages()
>> allocates the lock before the VM_NORESERVE early return.
>>
>> Pin mm_users across the scan, the way the other consumers do. mmput()
>> from the exiting task can then no longer reach exit_mmap() while a walk
>> is in progress.
> 
> All looks good and checks out for me, thanks.
> 
> Except...
> 
>> --- a/fs/proc/task_mmu.c
>> +++ b/fs/proc/task_mmu.c
>> @@ -3231,15 +3231,18 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
>>  	size_t n_ranges_out = 0;
>>  	int ret;
>>  
>> +	if (!mm || !mmget_not_zero(mm))
>> +		return -ESRCH;
> 
> Why the new test for !mm?  The current call chain guarantees this is a
> cant-happen and the current do_pagemap_scan will cheerfully oops if
> mm==NULL.

I'd just keep it for consistency with all the other checks in this file?

-- 
Cheers,

David

