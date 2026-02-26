Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68651FC5914
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C10406B0088; Thu, 26 Feb 2026 04:24:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B932C6B0089; Thu, 26 Feb 2026 04:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95436B008A; Thu, 26 Feb 2026 04:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 934DD6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:24:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30F081CF0F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:24:04 +0000 (UTC)
X-FDA: 84486071208.27.B04558C
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1E397100002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:24:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qvywMMVp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772097842; a=rsa-sha256;
	cv=none;
	b=fXYh07jPuFPIyH6N7TusPRE4ujNf7Wx+JqbkUTcO1LHqZXYs750Zz6c3Of/cn35ukWXFw0
	yW6f+047fAmHWBE93nJd/PLj1AnMOI3rrP5PD18qZQsQlPBJWhEW09kzloJ8aR4NYzVpIj
	yG+Bxo65iemBjU4PvZMVCeY7Jy7mskM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qvywMMVp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772097842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMIGcQmXL6bNGpLRZlwetHCCNpKRzFWWcdjC2dOpFyk=;
	b=Wzs1qfKzzmkfOnH/Y4fweOLzXG6qUvgn9iNLUfcaR2ZEpyptrrlaHhEr38oHhau/2FvRpw
	J+F3vKp9797Fd6h4yYlcZ00+rCZdEqyBxtB1ywUKmB4uWkOTEVQAO0/hk5UoyEL4kpCcSO
	iynBr23HjX4/zwrCkwJzjsR3Caq9Z08=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772097832; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NMIGcQmXL6bNGpLRZlwetHCCNpKRzFWWcdjC2dOpFyk=;
	b=qvywMMVpC4SHksnMSWVf9rIP6EZzyn0U4GekTolsw7Odp6XQAIfTHspEcfP6447IspUfEh6HHf2bpiPQCeNKduJPvh+R0M6GtOf7ZfyzJTAZ6HOHVpEtPY/KD90o5ZFDDiuZJ5I1yCZZz9b8jWs7+h1vqdXE7DOpKEQGT/0QGos=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wzqqw9q_1772097828 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Feb 2026 17:23:50 +0800
Message-ID: <60e44957-b816-4f7e-b004-4e957a67fe12@linux.alibaba.com>
Date: Thu, 26 Feb 2026 17:23:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v2 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226012929.169479-1-npache@redhat.com>
 <20260226012929.169479-6-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260226012929.169479-6-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zf3jk4mswj3duh6ce8z7ej8gd73rsai9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E397100002
X-HE-Tag: 1772097840-996335
X-HE-Meta: U2FsdGVkX1+4Tsze3dEO8Uv1Aa1d2qA8r1GJAYhfA7r0ISueTTckPVsaoOT1+9rztz8ydmDWnsciS7QoR+WuSKvjtoiYLYJYWZtfvssgNpJpvA9k5XeXf8K3WExw3wr8F3+KvJdgQhdWii4ZRssX7XNUYUS+xqGifSHWUe5vBKnZ/5ft7g2y2P736GL+LQzvXsW2SMZdFkSRuy0a7RMf83LDrLbMfuYvlXcLFh1EaV8bCsaMSGjMqBFcgQXTnJzVMvvJnNdpnfpPgJ71q3hwzs7rH1PpzDU/TrU4saT2Ix5INa/tvue7rTRGLAz1rzBE3qpT9VoPolwNV90qqeCdD7+F1Lv7vHicWWw8HWxv4hvTo47alV2yuN71d5ZVv4FpEhVMjR9eOU1FdmbZ5cleur3Z4/ZjQkMystqYc23j5aGqwIuZ6jQe3ujfmWsylkIdbpiKHfaZhHD9rlrQPE3LUEzstJgU1EDQwMS816R2H8quuh0citfAWeVWCyv/L8f8cmCYMUf1uO/ieyU67JMvO4SbBh+AMy7aa0hsE1npYCf3yKZjasLPLtgwdT0sZSghjt1aMNvYN6SB5n7nSqD1fxkOtTSUmPdyVMrTw+w0bRypOShBI0BbrjzWC1MCgd8hmsybPpSFaX1uiJjVU4eUgbzM2b5VpDbnTlWcbf3Iymc5NSF89efRTmJSa+cL1YVbgwJnj1jxHl3hferQxqZNu80eYDjdQ25tC3l+I9D/rjHb8KtLviSpJwYdxBtzHpJmgDp1arlpyHFVq3cudqsQK1SWBfd3T3MLy2ycGgVLv06EMDpA6Cd83vGiHrEI1ud4ankd6MJFJp1KykjoEBurqfq6KryGziTCkfIdN/OQqaD3Q5OxiVvWy19NdobyQyY5h4yAnltKoOtXtu4oiptHpP7ywlsnmgBotbq7CV7KcEIFQgPaKI7Ewe3pLNShT1R9zq8L9153rWW6Zv3f2pb
 OAL6x5qP
 zD4cfQ90VFms2xs9cQgr2B3Ff7WMHFJTDXOWz0o3wipy02BI7pJb9NL1BsArID57StQaurxZDbNi3tmWHj5iEQZbGLBXy2zV10LEhASNxC9nrSM1fGTy66SmF3O0F3s8AqqyUYTMZSDuc1CH8IZCC+uTB34Rl1wIt3MXDHorx7GitALoA2ZZmRHbIv4Y1pNkmbQ9JkdxeMGtrEk/zFbCkFzLxffzrT/YZiphyXfXGP3CZ+vrG6IRqAFl5GqCFakULirR734ytbr2KIS2K6U/wa3mRN88pSXQEHNUajYx1pKIthqwoa5Jtt/FoNACZwhj335Z9UFt/LoyddVTVedhTy8DKRgWDsZPngMop9KJScoZFEgUcTErSwJqVbDU1XQQFD+Atw4zwYtUGX/61L2oqQpJyvpKEuc+Wy5dDYA48q51fuqe+EvF3bXhpRvDki0pmy4ASXcIrt2cjllmosEdDVHOlWyPyA/3vtxK5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/26/26 9:29 AM, Nico Pache wrote:
> The khugepaged daemon and madvise_collapse have two different
> implementations that do almost the same thing.
> 
> Create collapse_single_pmd to increase code reuse and create an entry
> point to these two users.
> 
> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> collapse_single_pmd function. This introduces a minor behavioral change
> that is most likely an undiscovered bug. The current implementation of
> khugepaged tests collapse_test_exit_or_disable before calling
> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
> case. By unifying these two callers madvise_collapse now also performs
> this check. We also modify the return value to be SCAN_ANY_PROCESS which
> properly indicates that this process is no longer valid to operate on.
> 
> We also guard the khugepaged_pages_collapsed variable to ensure its only
> incremented for khugepaged.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

[snip]

>   	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>   		enum scan_result result = SCAN_FAIL;
> -		bool triggered_wb = false;
>   
> -retry:
>   		if (!mmap_locked) {
>   			cond_resched();
>   			mmap_read_lock(mm);
>   			mmap_locked = true;
> +			*lock_dropped = true;
IIUC, this should be '*lock_dropped = false', right?

>   			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>   							 cc);
>   			if (result  != SCAN_SUCCEED) {
> @@ -2836,46 +2872,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>   		}
>   		mmap_assert_locked(mm);
> -		if (!vma_is_anonymous(vma)) {
> -			struct file *file = get_file(vma->vm_file);
> -			pgoff_t pgoff = linear_page_index(vma, addr);
> -
> -			mmap_read_unlock(mm);
> -			mmap_locked = false;
> -			*lock_dropped = true;
> -			result = collapse_scan_file(mm, addr, file, pgoff, NULL, cc);
>   
> -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
> -			    mapping_can_writeback(file->f_mapping)) {
> -				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
> -				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
> +		result = collapse_single_pmd(addr, vma, &mmap_locked, NULL, cc);
>   
> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> -				triggered_wb = true;
> -				fput(file);
> -				goto retry;
> -			}
> -			fput(file);
> -		} else {
> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, NULL, cc);
> -		}
>   		if (!mmap_locked)
>   			*lock_dropped = true;
>   
> -handle_result:
>   		switch (result) {
>   		case SCAN_SUCCEED:
>   		case SCAN_PMD_MAPPED:
>   			++thps;
>   			break;
> -		case SCAN_PTE_MAPPED_HUGEPAGE:
> -			BUG_ON(mmap_locked);
> -			mmap_read_lock(mm);
> -			result = try_collapse_pte_mapped_thp(mm, addr, true);
> -			mmap_read_unlock(mm);
> -			goto handle_result;
>   		/* Whitelisted set of results where continuing OK */
>   		case SCAN_NO_PTE_TABLE:
> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>   		case SCAN_PTE_NON_PRESENT:
>   		case SCAN_PTE_UFFD_WP:
>   		case SCAN_LACK_REFERENCED_PAGE:


