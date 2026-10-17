Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664A5CCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 07:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC6E6B0088; Sat, 17 Oct 2026 03:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E1A6B008A; Sat, 17 Oct 2026 03:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282E06B008C; Sat, 17 Oct 2026 03:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 037B86B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:42:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0B515160267
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 07:42:07 +0000 (UTC)
X-FDA: 85331324694.05.78911DC
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf08.hostedemail.com (Postfix) with ESMTP id C02DF160003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 07:42:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TsC+TMYs;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792222925;
	b=Uu5WtQ6sVUMxr0j3jF1v9E2NlRU3WUtw9Uo6dpeyPsjLKVp6FxouJ3ziACfxKp0exlB0Ti
	jKfLsX1C+5obu1Q+eDxPzIWaUY3lA25w0Y7hO+BWZONz9tKR6/ZdFLiylXzn0Nv8G5q7xr
	SXSFUAM5lVdHOp7r8nsF5yRydhnvM2k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TsC+TMYs;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792222925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyH/IxB4zQyxD81qVP2Y2wIsWvKd7K+H9f36oouGofg=;
	b=8R4dVN5IHHkq9sksEqTDTTmlI0vPVIwAA06PpsIiJCcvXhzVFMbghxbNxhXC84/w7wm/2b
	NyyPDKzQF9CiZkDUUA+6wBTPdjRer8kn5P3lncqa84//2mPuh5osG/eP2hsFaiMN03Vtlo
	hOQbrM4AB5Sotetu2qxHI+FSBdojLlI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cTmbWpIBmFSm4lFwnUIH2uqFavf981pVZQE+4xBkCvg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792222923; v=1; x=1792827723;
 b=TsC+TMYsEi+Hn8G9fawH3emMTlVT+1BkS3/mdmZqzQ2ZoXJk6Sa7Vz3BxX3GcLiKso3t8OBU
 9ILWDRU172KSQ2NRNBgMaLF6Hc/o+DWOHHt/JQzR/ZFuAyfc+Sl11abni2eFF1x68x8EH3myGlc
 MN+wnqBA226O+RHcJpww4rLQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 822507f423bfaa6f;
	Sat, 17 Oct 2026 07:42:01 +0000
X-Mizu-Trace-ID: 822507f423bfaa6f
X-Migadu-Flow: FLOW_OUT
Message-ID: <cd6637db-7b30-4cbc-b07f-c2a2b32480fa@linux.dev>
Date: Sat, 17 Oct 2026 15:41:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 jack@suse.cz, djwong@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hch@lst.de,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
 ngocthang2710.1999@gmail.com, willy@infradead.org, rppt@kernel.org,
 ljs@kernel.org
References: <20261016065920.4153-1-lance.yang@linux.dev>
 <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
 <atICp2NL8j2z7UFM@pedro-suse.tail5790ac.ts.net>
 <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
 <6a005d89-df5b-4524-a4b9-c637cb15f1ee@linux.alibaba.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <6a005d89-df5b-4524-a4b9-c637cb15f1ee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C02DF160003
X-Stat-Signature: uh3hruaafq9riuj7prs3p5c74nxi487e
X-HE-Tag: 1792222924-403058
X-HE-Meta: U2FsdGVkX1+xpzrHqdgk6RPghAyqoOeexgXmCPOHyk6T+6hcg2QWG1zw8Ro3WlGjQeEl/QMYZVoLXYXTbPkCqoq6MuxrmzPvtG+BdTnE9tT92PEM5F8KehDN4OQQmy90wo8lk+B0j7VEOJtnBdjC5WEu9f89EizVvPOHkOuBBTgv79++3sU2tGSDJe707Q3uJ9gdegzUODll+orMOJqc6uoOuG6vYkVJZvplYY5PRtSOdK+4p6Aq4r/IR+d2SAx1GqsXiWsf+8WAJemMUr39wfJ8930AK33robaxF9sbtrUonLhcfkvP3XxRpg3Dz9CYj6Klyl/AU3CZ6KskHoczAyU+4DjMGSc6sJ9hipgXhGHVyjAjkKnX546OAUlyqqI3sJH0apzkNSIGYgMOz5hhS8SFYL758N2aEAlXDacsODEQNYacYxUkU3q6VL42xe4bBPSKmnrbjAxr06YJ80A+cBiBJF2DB3MwmaaHljQmvCARnsYnfZMunKQR7unvGu+9lR2Z+1m73fST8nhpqLcrnMlwOTNNomEwXt9GKCVoAXYTknDrrH3WA10+Wpqx/b7uwwZ6FNoL/TxtpB++aUkSPufJ04L8RI4n/8jiLqmrAHBTrtthgXR7yqnjhZbwlVFu6ZV11l3qM7dClgHXYlCmqupqrhRv96gPw5tildTAahEPgPdhtJOzViy5BmhpT104ixO3S82ZuFP2hlOSkAaCHjpjGXyhgOF90x9NcDtXcHhOBYaETIyO3OMz4t9wBcV4/R61l+QuE0PL7faoOMOtIvNn54WiIWBF2PpRh89K3NDQyOtV75700EhQ8XZ7sWbUsfrIPhhowhNs/tRRTdm50jANrMwn9kKhIOcS3m9iXa4WXlL80XQwShsNk5gDmGbgqQwbshgCeFDKvMB/2Xf69SwPZsHGdqhIP1Od5+KkaVb/6TwmsqNRDZoM4WYuR9ikqXP9EWd/fecoN3g+cW2
 VDa6WW7I
 Qg9BNdk7p6eFef9TxwNn+T1Rr3RZPXLO1I+sj46ykK6sVyStpJah9wN//jnrpksI/7X5v5Yp+ZHiumVjA2nyfdzvmac3cpttV6DyxM+mI0/useFTGt/YEGo0KEqw5KRsNMD+jc5CCZcnLvaGbz9dNVNL0woBwejgB7ByP+uUUSKtgdTHyO0oEiR98Vi2dqW4+7JMbUZ/bXXtU6YAB9cgYkkp0Iusog9D0KIb+UPT0OYJijigdeBObpwcNAQbam1ESfGYnHL4EYTpjpEYK7iowhRt27fmnv2+oQGcHhLtg+wWplzlBJWTK2UX87E/BY+iNl8+8QXkx0VDa3/bZw3+Goc+50ONAD4mpufQgcKBFa/bYfszGqHRe2XrNc1ug1eVU+pbNKbDay7CdysBLBi+CPzoD16/bqYra/7U0zi2+0ILsaL5cJema5FF8v5pogQCPMXNqxe8QFXHBCnu66Fl558mEIBvojRMQol6VHWTRP2qjjRyHs/2kDXFqDuz9nWtNinfot66HguVHDYIAlbRVjDmhMyw50YxO93ZljJPyVCrb/T2Xq1cd0WMjDkVYU1hikOEeQFxXEwsQSmlS3MWXOuMa2SjHTYVVQlvEg6cbngfavcI/ghaj2LM0KWdRpMJ0gQJ+Jl3n+74qZVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/17 13:43, Baolin Wang wrote:
> 
> 
> On 10/16/26 9:18 PM, Pedro Falcato wrote:
>> On Fri, Oct 16, 2026 at 12:00:24PM +0100, Pedro Falcato wrote:
>>> On Fri, Oct 16, 2026 at 05:57:48PM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 10/16/26 2:59 PM, Lance Yang wrote:
>>>>> collapse_file() can end up calling page_cache_sync_readahead() with
>>>>> source folios from earlier in the range still locked. If truncate 
>>>>> already
>>>>> holds mapping->invalidate_lock exclusively and is waiting for one of
>>>>> those folios, readahead blocks on the same invalidate_lock and neither
>>>>> side can make progress.
>>>>>
>>>>> Do readahead in a separate pass before we start holding source folios
>>>>> locked for collapse. Keep page_cache_sync_readahead() and its existing
>>>>> policy, and drop each folio's lock and reference after checking 
>>>>> that it
>>>>> is uptodate. If truncate or reclaim removes a folio between the two
>>>>> passes, roll back instead of doing readahead again with source folios
>>>>> locked.
>>>>>
>>>>> Shmem handles swapin and fallocated folios through shmem_get_folio()
>>>>> without taking mapping->invalidate_lock, so it isn't affected by this
>>>>> lock inversion.
>>>>>
>>>>> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>>>>> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
>>>>> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page 
>>>>> cache with invalidate_lock")
>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>> ---
>>>>
>>>> Thanks for the fix.
>>>>
>>>>> Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
>>>>> happy to take this over.
>>>>>
>>>>> Some older stable trees lack the folio infrastructure used here, 
>>>>> and the
>>>>> code will differ for each stable tree, so each backport will need 
>>>>> quite a
>>>>> bit of rework and its own review. I'm not sure whether to Cc stable 
>>>>> here.
>>>>> Once we agree on the fix, I'll send a separate backport for each 
>>>>> maintained
>>>>> stable tree except 5.10, which isn't affected.
>>>>>
>>>>> v2 -> v3:
>>>>>    - Replace the scan-wide invalidate_lock and 
>>>>> page_cache_ra_unbounded() with
>>>>>      a preparation pass using page_cache_sync_readahead().
>>>>>    - Roll back on a new page cache miss during collapse.
>>>>>    - https://lore.kernel.org/all/20260913163644.122133-1- 
>>>>> ngocthang2710.1999@gmail.com/
>>>>>
>>>>>    mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
>>>>>    1 file changed, 31 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index ef5cd6fda34f..b3f67617caf0 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct 
>>>>> mm_struct *mm, unsigned long addr,
>>>>>        new_folio->index = start;
>>>>>        new_folio->mapping = mapping;
>>>>> +    if (!is_shmem) {
>>>>> +        /*
>>>>> +         * Populate the range before accumulating locked source 
>>>>> folios:
>>>>> +         * readahead may block on invalidate_lock.
>>>>> +         */
>>>>> +        for (index = start; index < end;) {
>>>>
>>>> why drop xas_unlock_irq()?
>>>>
>>>>> +            folio = filemap_lock_folio(mapping, index);
>>>>> +            if (IS_ERR(folio)) {
>>>>> +                page_cache_sync_readahead(mapping, &file->f_ra,
>>>>> +                              file, index, end - index);
>>>>> +                folio = filemap_lock_folio(mapping, index);
>>>>> +                if (IS_ERR(folio)) {
>>>>> +                    result = SCAN_FAIL;
>>>>> +                    goto rollback;
>>>>> +                }
>>>>> +            }
>>>>> +            if (!folio_test_uptodate(folio))
>>>>> +                result = SCAN_FAIL;
>>>>
>>>> Do we need to check PG_uptodate after locking the folio? If we 
>>>> successfully
>>>> lock the folio, doesn't that mean the read I/O has completed? The 
>>>> following
>>>
>>> Yes, you do; a read can "complete" without the IO having completed 
>>> successfully,
>>> and in those cases PG_uptodate is not set, but the folio is unlocked.
> 
> OK.
> 
>>> Either way, why are we checking for uptodate here? We only care for 
>>> starting readahead.
>>> Anyway, I would possibly recommend we do this as post-processing, not 
>>> pre-processing.
>>> The current loop is a little overhead-happy.
>>
>> To clarify: I would do this kind of RA as an error path if isolation 
>> failed.
> 
> Sounds good.
> 
>> Namely, at the end of rollback, after unlocking folios. It doesn't 
>> make sense
>> to me to do this kind of checking upfront. I don't think it's 
>> particularly
>> realistic that, starting RA upfront, you'd see uptodate completed 
>> folio reads
>> when doing the actual isolation.
> 
> But why not add RA logic in collapse_pmd(), as we do for 
> SCAN_PAGE_DIRTY_OR_WRITEBACK? There's already retry logic there, and 
> this would also simplify the long collapse_file().

That would be cleaner, yeah. Some older stable trees don't have that
outer retry loop, though ... I'd prefer to get the fix backported first,
then move the RA/retry logic out in a follow-up, wdyt?

Cheers, Lance


