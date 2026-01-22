Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242A0D6CFAA
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3876B0373; Thu, 22 Jan 2026 17:35:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCA926B0374; Thu, 22 Jan 2026 17:35:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6CE6B0375; Thu, 22 Jan 2026 17:35:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB17D6B0373
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:35:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5A22577C3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:35:12 +0000 (UTC)
X-FDA: 84361056864.02.8406E31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 084468000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:35:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMuITffC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769121311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N69P9gk87f3f5JsOD1wLC/vcEOrQqvcgL14LAZUiJJo=;
	b=FeF0iIsbkIL6xq9ZOzXyUzcAqHCRhwoJlOZkZzl7Jy3ke9chTV1WrnPrT+sBCKzkDt2P5D
	wCNkqFXIq1nD5Nd5/QJ+UVjCB5DVUyHfvK3GlXUjZutN0RpwUd2opyg3j/reOUU7ES9UC4
	WXVq6Tc03deUMTlJtdEzD6hBxZrM7Go=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMuITffC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769121311; a=rsa-sha256;
	cv=none;
	b=x3sn6kGO2uT2fsqlvZgkyUUXi+G4WBA0zCQSyxA8fAgnFSriKgloccgcWSIHK5h00sCuGI
	KufZS2n3F6K1md8qazsjKcb09cqH4/pZNHAeisOPFZvVacuTPZ0FA3/j7obucSMD1gtCtj
	dvfljFDhHuFyWB3tddu15vuUxhEFRtg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DF9B340B09;
	Thu, 22 Jan 2026 22:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8287C116C6;
	Thu, 22 Jan 2026 22:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769121309;
	bh=cel+85lgP008k2TuZNt+HCFnz2aRhDRJY2Ab7DEOzEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gMuITffCjqizZ6qdmb0Rx4n1xO3es9euuSRc+oEYJyy9llTs3jtl8Ug0qXoQNCNEV
	 iRTY17A9NU3zNCZRIbVAJ7SQKe6HOVW1D0DaknGltAs5id0FYibzX9CBuhlmQy0T6X
	 dLLou0mJ1DToeshTVPcBhyM4XnOeDJgW/SLRAg0vuvUyZRTENr/XnKshJmR1QZbUEP
	 gQ9o1n94fFs+ZU73EcvuFB86gs2TrWrKFfwuneULrGy6iJxUoW85Ey3IZxpxyLhTQT
	 /tVObpHKWi/jX94lkakYsNc8uO5+U10tikJt9NhchbWUlJDubzHooW8XAcvZUhzvva
	 BIM18QlsSa+gg==
Message-ID: <f5c60f22-7bc7-494b-8dd3-5d0566c103e4@kernel.org>
Date: Thu, 22 Jan 2026 23:34:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 2/2] mm/khugepaged: retry with sync writeback for
 MADV_COLLAPSE
To: Dev Jain <dev.jain@arm.com>, Shivank Garg <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, linux-trace-kernel@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
 Branden Moore <Branden.Moore@amd.com>
References: <20260118190939.8986-2-shivankg@amd.com>
 <20260118190939.8986-7-shivankg@amd.com>
 <3aaa3e5d-7f66-40fc-a5b0-ea6a384a88a8@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <3aaa3e5d-7f66-40fc-a5b0-ea6a384a88a8@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: owmc39i9pk8tyxbgac7foqg4ne1g7ozp
X-Rspamd-Queue-Id: 084468000D
X-Rspam-User: 
X-HE-Tag: 1769121310-544350
X-HE-Meta: U2FsdGVkX1/1R4++DYzYgc+TqRwKL/aSHrX02xY+CXt6CIhWz7LIMFsnsUZeRHjAapk+cyaWUlFNDf1Tc2MKEPs7ZzdaUxzA7Azfc8E5BIXjTm0AWI8TyCif+A1HyN1TDEDVENTNTB3btuJjWZaiyMu9tdo6jtC3HYdiMK2wjXZSxSztc20QXU3yRfDW0fJOlKMcHKwism8VaPJ3rkS+tmvYdTbUrAUxhA/Wobg9f/asZJvTxOK5dhTRMAA4FQl+hF4doSkmcx5UXgdo1HWEG/eDtr0xaxsmT2WPcjoZfPHe7plZm/hU4691zQQD+NhyoKrY6mwbyOivQrbjSMREZdReVqvKae+xtp9OqdBV7kNB5tudt8lqxO/KX9DdIR5NdhURqLd2W6H+mVSd6v3EhmcwIA1XFanv+gK/75wc8jGL6VqaZZ1iG3g8POPOucM4HQh6ZIIaa86bhp5xBUP083qY8uOBfeeSdxa5dLJmvcSL+nQjF5bSYly42LoBKARzHhAU+yVzbOblNAXMsG/X4wVPcJOoSs3lHopCT9PMcjUPclrfmValcH3Bc9OFRJEb47iCLXJRSMU2z8D81HFp8yHEHVha/Rz7nldvNdWDhCTou5OousTytfWrgyCBGbMBzW5ypj+9643R7XXO9NY+/aAVvewFszZJYEz2myEsVZlX9J45KzBNhbdnmD4s7jIi2rlKBAdrMshT8WcHUB4s2HSoiRMFFsmG/tjhqhcJdjRYKchlMQYLEcfCS6eSI3zEqsDfVpCf4K6BXfcGst0WeSuIl78UENnMHGQzf6RA/R4zkxM4RmiK85ynNBHPKdW8QCC2+COhqgm7F2NAnqbVakpd077DWpKyKKnSAAxiU9bk/52shApcbBIirve1hf5jjG3f2PHMN/suRBG1S/QZusCmG5JV0ufNtsGe24bHZdN58jrdyWtNwx16hCwTQEtOtfW4WaGrg8/6rad6wOX
 NR0xGvQl
 auxVs7t9Hs6KY1jPGNs0lK9fHD1T9gkS+WKTxq8o0DY+Exj4abNyqGBCsbWgWyvclb2DWeoZO5GuwdO107ff9NquHKhh4ksYLrYAv0w/XjLcdykwYtwF2N/69oiX56u4HfXQpkY2JmCwgsJxgiICV4e3QLOurrDJ6onrhP67QQqdcYcqxVFxFWPAa/OAszYfegPPf5uLhu7KaZGy2F0OLf0RMIJvcFllpi9TMwki1Uk86YXXZmmztXiU3f+Xt61WKtI1MEiL239GjjOSUwNWks2lwu8RDbUJE6rgve32xdZ7HfOWDbfz+dvQCmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 12:07, Dev Jain wrote:
> 
> On 19/01/26 12:39 am, Shivank Garg wrote:
>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
>> text sections), the pages may still be dirty from recent writes.
>> collapse_file() will trigger async writeback and fail with
>> SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).
>>
>> MADV_COLLAPSE is a synchronous operation where userspace expects
>> immediate results. If the collapse fails due to dirty pages, perform
>> synchronous writeback on the specific range and retry once.
>>
>> This avoids spurious failures for freshly written executables while
>> avoiding unnecessary synchronous I/O for mappings that are already clean.
>>
>> Reported-by: Branden Moore <Branden.Moore@amd.com>
>> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
>> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Tested-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>   mm/khugepaged.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 219dfa2e523c..16582bdcb6ff 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -22,6 +22,7 @@
>>   #include <linux/dax.h>
>>   #include <linux/ksm.h>
>>   #include <linux/pgalloc.h>
>> +#include <linux/backing-dev.h>
>>   
>>   #include <asm/tlb.h>
>>   #include "internal.h"
>> @@ -2788,7 +2789,9 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   
>>   	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>   		int result = SCAN_FAIL;
>> +		bool triggered_wb = false;
>>   
>> +retry:
>>   		if (!mmap_locked) {
>>   			cond_resched();
>>   			mmap_read_lock(mm);
>> @@ -2809,8 +2812,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   
>>   			mmap_read_unlock(mm);
>>   			mmap_locked = false;
>> +			*lock_dropped = true;
>>   			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
>>   							  cc);
>> +
>> +			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>> +			    mapping_can_writeback(file->f_mapping)) {
>> +				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>> +				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>> +
>> +				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
> 
> So we don't care about the return value here because this is best-effort.
> I really wish we had in our coding-style.rst to typecast such things to (void),
> so we know explicitly that we are ignoring the return value, and not that the
> function itself returns void.

That makes functions like bitmap_and() hard (and ugly) to use that just 
return some value for the caller's convenience.

For functions where we really want callers to think about this, we can 
enforce such checks through __must_check.

Here, it's rather obvious that we don't care about the result as we only 
retry once to then give up.

-- 
Cheers

David

