Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF20606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IUa3hUbx
Received: by kanga.kvack.org (Postfix)
	id EB1966B00EF; Tue, 17 Nov 2026 02:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62BE6B05B0; Tue, 17 Nov 2026 02:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F346B05B1; Tue, 17 Nov 2026 02:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B33016B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:28:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43AD71401BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:28:09 +0000 (UTC)
X-FDA: 85443782298.01.D9C7D23
Received: from mta1.migadu.com (out-148.mta1.migadu.com [95.215.58.148])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24B96C0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:28:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IUa3hUbx;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794900487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiloeVj7f5SkmVduZu6GrGYjRe7VINboO/OLOU2KIoM=;
	b=E++Ux09PHM/bMaBnI1+KYz9UEL26ZCwutNVdGEjAyIpTKbu8++5tyZSdevuLq3qSpBNbih
	VihYg6N+CqdZnx31RbrHxv2k1sMPacl2rwfT4jUXKF0atmQauTvTgmzWMAbNA6lGwYccqo
	xGBFtiSTm5cQUQV6ZUU0ai+wdAYB6K8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794900487;
	b=WK19Appgz5Eh+D/XzSe4MxJT/0M5NwdzlRtZTfcMyIbaZSdoEiRPtedwdlWl44vS2al9mM
	U76N6Sdh2BTqj5rJNL53pQMzogsYivOs6iVw8fuQyAvpYIapeOi58SiraDi84571fiaSwz
	lo7HrEK1nE6+71vC3c55xyY8IHzfb2o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IUa3hUbx;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.148 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OOZLqF1KqEWXsHkQIJQdmwZs3bWqAcc5EVrCFP1k6Ko=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794900485; v=1; x=1795505285;
 b=IUa3hUbxMteF48XpluyzUk+/5jUbACgr8hkX/L4YThrvV0cr+nwKKln3Up3fpA7yFI2y2kGa
 3s6YvYYIV/9lgM8LGKfDXd91wAe0EUzxy8SznktHU0wQ+kBthmEUygZhhAwjXgz0vqImxD7Cjxq
 Hwnf8dw6PKqww+065SW4zioU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cca165b129b6f823;
	Tue, 17 Nov 2026 07:28:05 +0000
X-Mizu-Trace-ID: cca165b129b6f823
X-Migadu-Flow: FLOW_OUT
Message-ID: <b61ece54-4df8-4d4d-a64a-be7f56f380dc@linux.dev>
Date: Tue, 17 Nov 2026 15:27:53 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/11] mm/vmalloc: undo what
 __vmap_pages_range_noflush() mapped on failure
To: sashiko-reviews@lists.linux.dev
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Marco Elver <elver@google.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-8-hao.ge@linux.dev> <sashiko-outbox-218305@kernel.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <sashiko-outbox-218305@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xwe34qnuqfyors8gy1dmnwnhcsrywb4j
X-Rspam-User: 
X-Rspamd-Queue-Id: 24B96C0003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794900486-240195
X-HE-Meta: U2FsdGVkX1+wIwxvo89vG3q9rYCG0KL1bkiEyXcQgitZjnSOIhCiq6i5sZbN2Qmc0PqZGJYZXUe78gaE61N99l0swm8rxxKR0c0JnkPO1FtwdwGe0Bcc9udjmyxeLxpiMfjv+0GEzqxxUIMdTP6iV8YAacGCPiE0m//BxumW0FY824mZZrAes+sVtrjZaOquYlSz6l44QPpbJ3mDy/hlYDlVgK0EXSvOYnU0fOjmIrrrZ4TfrK9I7SnrtXceOaB/K/FNcEiR/gRqTGhTIgVn39JxVFbt6YSRHgSaxXCTfVHhtntfqUYH/6RJQoKG7RxpYn368oO/VmThCW87r6JS9XkL7+OB8yonfEnEKDbKALPUr5SSmgKl8Ks7Qouj+PGlFUXKQbGgiCzhAa0NHpoWrp8vRbcFmD6WN78q+nZ1zpljNuDDOTf3beiwNqvP19SkPbv35lc+FApAWb1eFQxTGnCuHPNxB4J4JgXqOVeeY7NmQIOQvRT07OWRt51sKn6vwVJzFs2ufqLQeUaOHsVMBC7CzEmdwe7SmTpFYG5sa6YazBBc9zXxj2FsYToI0fTBmOn22l7OhA1RITUivfnsQdubfCNB2HLoxGsBA511PGdmGhr7XGkwJ/FFBcXv7Tc5bLrOrOvTLwfRLlH2UoAKO4sMBnKVh8L0boMG54nilghVQ8hy6H82k/0Mic6HlfpoKIEd7Y0fiiWms/G1fawQzXqydxTP+N1GXemNTfcUQQunWG4v+HcZnHDaj0B3HBm+HWCSS0Cf7KiLnu4D9Le/wdbS8SRQTFnNXIPSZdK7ObCmVm4I4CBh3R1vFGsyOqmPQE4Qult31jWVLB7E/Q2qe+LGJWk52LNclHRyJyw6qwdHMpCESlX4sH/dXC6EYwUm/13jRIYv0o5hZDyl4hwb5AZQzobJG4+qHwfXFbTxDpIO307LmUWdTjLXPDJXQI5AcZyZDjAHhex91XfiDwY
 CPZwh9Nk
 Bc3iJMBeyaLdpJbPyZYt2xc/Ar40gtyOGO8Vu0XhnS1v3a4hw2ZaXP1WQKv3Dpc86t5WG8pGQ5V3NjIPMQtPcXOd4bMs2wb4tPHx3d8NbTTDRrns/BqKo2CHyj5K65cHQpik/wb4V085OwLwJACdvobfwCuxLElfI0K1YT0lQmOvLgNcTZGTk9EGPvqw1t5oz1M8u+7pXmi13uzBYQX2eDJtlgllhFnR+Si/59rrNR+sx7qLFd5ltrAR8qrdFu+PoIFwqoLPW0AXIhxiITWbgHzKua9G2h41xE3bcg4VOcYpdnKk2/Czc5pjmlYaDXy2C46YnsdxRiUUz2K1EepFjNwTkbPZF56JdEq6hzSqRqypEknB6Fs7Dd7kPyh9Zb86P5xhjR31G05BAR8CMZp5nK94WnyB3cEjLlV7ipNhEdngWmkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/17 15:15, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/vmalloc: vmap_pages_range_noflush_walk() truncates nr into
>   unsigned int
> --
> 
> commit f06c1baff5ffda8b5f9a1dce600b9d716bd0c648
> Author: Hao Ge <hao.ge@linux.dev>
> 
> mm/vmalloc: undo what __vmap_pages_range_noflush() mapped on failure
> 
> This commit tracks the number of pages installed by
> vmap_pages_range_noflush_walk() and tears down those PTEs in
> __vmap_pages_range_noflush() when a mapping fails midway.
> 
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 5c1eacc2a0ac3..4f3c320a48499 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -725,7 +725,8 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>>   * may have contiguous chunks, as hinted by @shift.
>>   */
>>  static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>> -		pgprot_t prot, struct page **pages, unsigned int shift)
>> +		pgprot_t prot, struct page **pages, unsigned int shift,
>> +		unsigned int *mapped_pages)
>>  {
>>  	unsigned long start = addr;
>>  	pgd_t *pgd;
>> @@ -748,6 +749,7 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>  		arch_sync_kernel_mappings(start, end);
>>  
>> +	*mapped_pages = nr;
>>  	return err;
>>  }
>>  
>> @@ -758,18 +760,36 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>>   * The caller is responsible for calling flush_cache_vmap() after this
>>   * function returns successfully and before the addresses are accessed.
>>   *
>> + * On failure the PTEs installed by this call are torn down before
>> + * returning, so a retry sees a clean range; PTEs that were already
>> + * there when the walk failed are left alone. When @gfp_mask cannot
>> + * block, the teardown skips cond_resched(), it may run in atomic
>> + * context.
>> + *
>>   * This is an internal function only. Do not use outside mm/.
>>   */
>>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> -		pgprot_t prot, struct page **pages, unsigned int page_shift)
>> +		pgprot_t prot, struct page **pages, unsigned int page_shift,
>> +		gfp_t gfp_mask)
>>  {
>> +	int err;
>> +	unsigned int mapped_pages = 0;
>> +
>>  	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>>  		return -EINVAL;
>>  
>>  	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>>  		page_shift = PAGE_SHIFT;
>>  
>> -	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
>> +	err = vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift,
>> +					    &mapped_pages);
>> +
>> +	/* Undo the PTEs installed before the failure. */
>> +	if (err && mapped_pages)
>> +		__vunmap_range_noflush(addr, addr + (mapped_pages * PAGE_SIZE),
>> +				       gfpflags_allow_blocking(gfp_mask));
>> +
>> +	return err;
>>  }
> 
> [Severity: Low]
> Should mapped_pages (and nr_mapped in vmap_pages_range_batched()) be
> unsigned long instead of unsigned int?
> 
> vmap_pages_range_noflush_walk() tracks nr as an unsigned long across the
> page-table walk, so storing it into an unsigned int truncates the count to
> 32 bits and would leave the unmap range incomplete if a walk ever failed
> past UINT_MAX pages.
> 

Sure, keeping them consistent does make sense.
I will hold this change and wait for more review comments on the rest of the patches.

