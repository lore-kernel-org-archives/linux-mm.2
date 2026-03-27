Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4FA10F284A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3270F6B008C; Fri, 27 Mar 2026 12:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE5E6B0095; Fri, 27 Mar 2026 12:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B356B0096; Fri, 27 Mar 2026 12:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 147D86B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:23:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8C90BB341
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:23:03 +0000 (UTC)
X-FDA: 84592362246.06.B1C41B1
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8DD612000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:23:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDtTgSOv;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4B7YUokdw8xne1NnZQBERMZXI1tXPocYgm0kwuMFEtk=;
	b=BuSXOApVyHb9LZFlA6EJgfZs1UumSjJeztug62OhvxOeUeZh5+LVgX1F7nOlz1Oux3k98j
	SUBps40SkOVjpFuCp/Kt+7kT4OhrvjLTKXjTlrZwFvSKFDzrMfn1kwkgFE5qqExBh6nXUt
	2ZQki9RTN0eiw3BrH+k4XSIIWIBm3zY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDtTgSOv;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628582; a=rsa-sha256;
	cv=none;
	b=1sb5mqKk43gX/gsm77NRXjABWybqWg8bZn6M/wax8qEgr5AoDBJGhBfxCLiOaaEdBMOcGP
	s4gezMuSvXRDJUnZALIR3tfA43THiOfzr6vmEjC4dwidV1D0n8HvRklpo+tJp2ia84zWsn
	STf0pe9CI78vRcqszsGdVvom7Mmhizc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774628579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4B7YUokdw8xne1NnZQBERMZXI1tXPocYgm0kwuMFEtk=;
	b=WDtTgSOvNTtyt1O/PB+qA0i21KrkkzR7bfWwWVL2HuyD5A2xKeM+vgM9ULjnATJq50kNI2
	aNTNaWN3R3jtcMRKZUPhDdng9FCVouhCjt9QVQjmhsmgFeA3xJe6L1ZVrjBEleulqda4Ve
	MpEV3MZFkUCnqzadTMVjZHbYawJ6kLo=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: baolin.wang@linux.alibaba.com,
	ljs@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Sat, 28 Mar 2026 00:22:52 +0800
Message-Id: <20260327162252.57553-1-lance.yang@linux.dev>
In-Reply-To: <6FCC0430-C98D-4D7C-8C53-F7722F1BDC4A@nvidia.com>
References: <6FCC0430-C98D-4D7C-8C53-F7722F1BDC4A@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DD612000E
X-Stat-Signature: 9hi6w4fmgc8k9o8dybueyjzyh9d9zf8y
X-Rspamd-Server: rspam06
X-HE-Tag: 1774628581-900264
X-HE-Meta: U2FsdGVkX18tVwp5g3e66lq6jA6KdU7a500qVxznhyDGqXzGMH5iEm0kXSKRslJnzQ/dP34wGQHnVdsuNGbyI0NRBMXOQOKufLcPsKhVdkbWqvtf6PDgxfWKiHRCcg1rxoZB1cFgPgDDBhPrurLFtgAni7rGMLfRsgWCHd/PbobC/2faButM9K7jmAsEKTnw0gqjZiBMUiS49VdUX4sna6pJtOJxGdns5si2X/r3Kg9cgpTS1HFyJsXf3njcE2IwKXECZWcND+7q4YAyRtDdbGB7WT5u9OT4Woi9e7ukMQYsOLzxh4Mg7W+Tpbl2N+iB9KXFhp94hq2iaAHfVttnHK9sv5SY4sOHz5awioT9cTZyD09zhDGKzgcew6NBXfaoNCBs/iE3lIfbfNcwPHi1PWubayIAHXQ1XS63WMeWltte40Nh6kIykos4gQqPlLHu5p1Ts8L1L7J8bGLii/gYtefjViWZEBPN11r4hMLrOSYNuaMSP+TqlGvTtjJ5vTj2nIR2dcpkw7gnWxNvDsTWOEzKKuRaZYcBTRpX/AnHEkfbb6gXGoUfw02w1l2o8xSR4s1ERuRdU7LNRxuuqqH7Oyrpu7B11+7N2rZYvwCLg6cIyEaz0Ie1CS5FLHBTECOH7H1DBj+UScCSA7Ww6kXoEAqKB+z6/IblQEJuDJsBgJU/JotHGXNtKe6jXmp9w96++vwtcD7V04/QYFmP+GatjQgBNhPRNhl9XbbqWD47s6kj1A7ISFQqlqZviAUIt8Keq5BLF8/MFopr/1Hgz4n5+9G++rvaXtShfIrodEJsQkYF5av9pfp5Cx2VAKa22nPOBHAW1/ExXnguWJgeAxI/zCqDngazJw4Bi91qWF1WzSAfSs7GYCd0tyTAf8yFwl1ulEEKr4NkJJ3UZNJQyjj+8JEMJp5e7Kduv8owHPWXPfjObUdFqL3PqAYjNAZ2DjWrzoQFuN3HJ9pu3W82LYs
 kzIJh/48
 IkcjUPTJa0Fl+v8OrwmW/nNc0V7zpQXl4a8hkftKcLBuIumYGa/7EniqiIImDNJu2gIUPW0N68rgJvIsGiX+u2h2JSz+Yvkg8m0q9MlgtlROWI6kMUPC1wGsf0Mtavbk2JWU0Vy0McMKX4CsKjKoTUGAcKsP9OJCZ3Z3Xwxu8F/tfOCnYc9C0ZrLT6hB1mB6U3etiQvzKIV4/wx0+xxgCmQiN+4w0bkjEU5aUL1t4L6YHDocDdlbnRnyypnpofBS5VHeNXpXd7g5BwxgTWzJ9/45WnGqEioxksvvRNrhKUvHyHviZHmusTX3DoGf9bhISiC9P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Mar 27, 2026 at 11:00:26AM -0400, Zi Yan wrote:
>On 27 Mar 2026, at 10:31, Lorenzo Stoakes (Oracle) wrote:
>
>> On Fri, Mar 27, 2026 at 10:26:53PM +0800, Baolin Wang wrote:
>>>
>>>
>>> On 3/27/26 10:12 PM, Lorenzo Stoakes (Oracle) wrote:
>>>> On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
>>>>>> On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 3/27/26 9:42 AM, Zi Yan wrote:
>>>>>>>> collapse_file() requires FSes supporting large folio with at least
>>>>>>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>>>>>>>> huge option turned on also sets large folio order on mapping, so the check
>>>>>>>> also applies to shmem.
>>>>>>>>
>>>>>>>> While at it, replace VM_BUG_ON with returning failure values.
>>>>>>>>
>>>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>>> ---
>>>>>>>>     mm/khugepaged.c | 7 +++++--
>>>>>>>>     1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>>>> index d06d84219e1b..45b12ffb1550 100644
>>>>>>>> --- a/mm/khugepaged.c
>>>>>>>> +++ b/mm/khugepaged.c
>>>>>>>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>>>>>     	int nr_none = 0;
>>>>>>>>     	bool is_shmem = shmem_file(file);
>>>>>>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>>>>>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>>>>>>> +	/* "huge" shmem sets mapping folio order and passes the check below */
>>>>>>>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>>> +		return SCAN_FAIL;
>>>>>>>
>>>>>>> This is not true for anonymous shmem, since its large order allocation logic
>>>>>>> is similar to anonymous memory. That means it will not call
>>>>>>> mapping_set_large_folios() for anonymous shmem.
>>>>>>>
>>>>>>> So I think the check should be:
>>>>>>>
>>>>>>> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>>        return SCAN_FAIL;
>>>>>>
>>>>>> Hmm but in shmem_init() we have:
>>>>>>
>>>>>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>>> 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>>>>> 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>>>>>> 	else
>>>>>> 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
>>>>>>
>>>>>> 	/*
>>>>>> 	 * Default to setting PMD-sized THP to inherit the global setting and
>>>>>> 	 * disable all other multi-size THPs.
>>>>>> 	 */
>>>>>> 	if (!shmem_orders_configured)
>>>>>> 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>>>>>> #endif
>>>>>>
>>>>>> And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
>>>>>> shmem_enabled_store() updates that if necessary.
>>>>>>
>>>>>> So we're still fine right?
>>>>>>
>>>>>> __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
>>>>>> __shmem_get_inode() which has:
>>>>>>
>>>>>> 	if (sbinfo->huge)
>>>>>> 		mapping_set_large_folios(inode->i_mapping);
>>>>>>
>>>>>> Shared for both anon shmem and tmpfs-style shmem.
>>>>>>
>>>>>> So I think it's fine as-is.
>>>>>
>>>>> I'm afraid not. Sorry, I should have been clearer.
>>>>>
>>>>> First, anonymous shmem large order allocation is dynamically controlled via
>>>>> the global interface (/sys/kernel/mm/transparent_hugepage/shmem_enabled) and
>>>>> the mTHP interfaces
>>>>> (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).
>>>>>
>>>>> This means that during anonymous shmem initialization, these interfaces
>>>>> might be set to 'never'. so it will not call mapping_set_large_folios()
>>>>> because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
>>>>>
>>>>> Even if shmem large order allocation is subsequently enabled via the
>>>>> interfaces, __shmem_file_setup -> mapping_set_large_folios() is not called
>>>>> again.
>>>>
>>>> I see your point, oh this is all a bit of a mess...
>>>>
>>>> It feels like entirely the wrong abstraction anyway, since at best you're
>>>> getting a global 'is enabled'.
>>>>
>>>> I guess what happened before was we'd never call into this with ! r/o thp for fs
>>>> && ! is_shmem.
>>>
>>> Right.
>>>
>>>> But now we are allowing it, but should STILL be gating on !is_shmem so yeah your
>>>> suggestion is correct I think actualyl.
>>>>
>>>> I do hate:
>>>>
>>>> 	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>
>>>> As a bit of code though. It's horrible.
>>>
>>> Indeed.
>>>
>>>> Let's abstract that...
>>>>
>>>> It'd be nice if we could find a way to clean things up in the lead up to changes
>>>> in series like this instead of sticking with the mess, but I guess since it
>>>> mostly removes stuff that's ok for now.
>>>
>>> I think this check can be removed from this patch.
>>>
>>> During the khugepaged's scan, it will call thp_vma_allowable_order() to
>>> check if the VMA is allowed to collapse into a PMD.
>>>
>>> Specifically, within the call chain thp_vma_allowable_order() ->
>>> __thp_vma_allowable_orders(), shmem is checked via
>>> shmem_allowable_huge_orders(), while other FSes are checked via
>>> file_thp_enabled().
>
>But for madvise(MADV_COLLAPSE) case, IIRC, it ignores shmem huge config
>and can perform collapse anyway. This means without !is_shmem the check
>will break madvise(MADV_COLLAPSE). Let me know if I get it wrong, since

Right. That will break MADV_COLLAPSE, IIUC.

For MADV_COLLAPSE on anonymous shmem, eligibility is determined by the
TVA_FORCED_COLLAPSE path via shmem_allowable_huge_orders(), not by
whether the inode mapping got mapping_set_large_folios() at creation
time.

Using mmap(MAP_SHARED | MAP_ANONYMOUS):
- create time: shmem_enabled=never, hugepages-2048kB/shmem_enabled=never
- collapse time: shmem_enabled=never, hugepages-2048kB/shmem_enabled=always

With the !is_shmem guard, collapse succeeds. Without it, the same setup
fails with -EINVAL.

Thanks,
Lance

>I was in that TVA_FORCED_COLLAPSE email thread but does not remember
>everything there.
>
>
>>
>> It sucks not to have an assert. Maybe in that case make it a
>> VM_WARN_ON_ONCE().
>
>Will do that as I replied to David already.
>
>>
>> I hate that you're left tracing things back like that...
>>
>>>
>>> For those other filesystems, Patch 5 has already added the following check,
>>> which I think is sufficient to filter out those FSes that do not support
>>> large folios:
>>>
>>> if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>>> 	return false;
>>
>> 2 < 5, we won't tolerate bisection hazards.
>>
>>>
>>>
>>>>> Anonymous shmem behaves similarly to anonymous pages: it is controlled by
>>>>> the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() to
>>>>> check for allowed large orders, rather than relying on
>>>>> mapping_max_folio_order().
>>>>>
>>>>> The mapping_max_folio_order() is intended to control large page allocation
>>>>> only for tmpfs mounts. Therefore, I find the current code confusing and
>>>>> think it needs to be fixed:
>>>>>
>>>>> /* Don't consider 'deny' for emergencies and 'force' for testing */
>>>>> if (sb != shm_mnt->mnt_sb && sbinfo->huge)
>>>>>         mapping_set_large_folios(inode->i_mapping);
>>>>
>
>Hi Baolin,
>
>Do you want to send a fix for this?
>
>Also I wonder how I can distinguish between anonymous shmem code and tmpfs code.
>I thought they are the same thing except that they have different user interface,
>but it seems that I was wrong.
>
>
>Best Regards,
>Yan, Zi
>
>

