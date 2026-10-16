Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33667CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 15:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DADD86B0092; Fri, 16 Oct 2026 11:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E346B0095; Fri, 16 Oct 2026 11:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D6A6B0096; Fri, 16 Oct 2026 11:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B80C6B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:43:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3DE1140486
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:43:55 +0000 (UTC)
X-FDA: 85328910030.05.41D07AE
Received: from mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5E9F8A000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:43:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sWGnctX/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.41 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792165433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OByEWtTXlkFP1tjkszIJA2zUK3dThCHFcVoioJufy9Q=;
	b=tRyUeJoISrQ/wESulLnZwlSKH0FK33s7gBoYc0PtBaWGUC2LFNatvf+D/o5Xa9OtYIOddm
	UWRB+5RHSoERWdKuDYaW+ah5uInnIrrZcTlA1DZUnbxJS8r8Kgv+cgUOqAOl3zphy4+b65
	3caND3H283qScTSqgcpoN8LFT0ct1CU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sWGnctX/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.41 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792165433;
	b=nKCfPMkCrvwl1fKM9Sa71rvhlMo6rEDA/ad3mdUF3YA6YNjVUJ5NZDd+CIxPOiSaXoCr3B
	E83ZHb4yF2TAUtNq/UrB9o8MOjWmv+iehBOUii0KdRoJk+PlWEDkTGmq9QXJ5EFMunWuHi
	trJbYx+m0u34r4hM9tDpAiG33CoVA9U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=74rKIlxgrRlJgR/t85SrsshrUgXIRHxay9Odnbdgk5Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792165431; v=1; x=1792770231;
 b=sWGnctX/ewhFMI43XVP3+ZkoOqJduUv4T67Mjax0GI7BJYFsA9vD8LAB/ielmU+Gkjnj20ay
 Fwrk4c8zjsTveeckagsFeuFKiVq9MR1goM92kRaBqh+s3KpSg3Wm4sxvQsRAonEjXyWp+CjxJ/c
 x7/1g8gPuQ2QuTPuJbrT63Gw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 988393ee6a1b987b;
	Fri, 16 Oct 2026 15:43:50 +0000
X-Mizu-Trace-ID: 988393ee6a1b987b
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com,
	pfalcato@suse.de
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	jack@suse.cz,
	djwong@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
	ngocthang2710.1999@gmail.com,
	willy@infradead.org,
	rppt@kernel.org,
	ljs@kernel.org
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in collapse_file()
Date: Fri, 16 Oct 2026 23:43:42 +0800
Message-ID: <20261016154342.31940-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
References: <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5E9F8A000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: jton98bt5qif874p3f4ibw8rmzxx7ead
X-HE-Tag: 1792165433-607639
X-HE-Meta: U2FsdGVkX19pngHgZjBMVsf2lrwTxjAHl34XBG1zuP7V3ixNlk5TLah4txrZgro3NQ4059wwx26TeRSDCQYZrERxv/Vfv4gKHk5SUZThblBrBYlZf/0TIpY9DtiuEzXqB+2MRrN18QflgwbHk83SEIE5UUojYcDEIBTpcrasYR1Sx+82pzpbBEV+iIS2zgVSaRzhbS1r4tUuYDSc1+Y/Dwutn8YTJpo4EUqH98SmlUovG7ivRKzXMee44C5SqTF2PzdMM5db5MoDmGAGrrkUWTJuFUVbVp4Akhrf1NCG9e9lsC7/pKLFfEdxilv44R7eX6oDMAT8gwjvF/CpDxVhp/qXeLEpZmTNFcZDnPd9+ZSlhNUv8Q6amTNdqM7OxSFgJHeoXePX7Vw4utNjfFkxSfW71iDTaK9/SpjxRz/3Dq5DkSDLrawxnGTDyLVVDqPjxD7I6HRefehe8IyImrC93JuZvcv62c6BZc2BpK4aEhcBHrUXP6hBpLVk90RU6CULOOT86CNi/YTLmnD/m+GlG2fhMDKtQDA5aoH+TRaG0TP4fyYGb04FvtjsZgOo89BAG6f9bY9mlFj8/4v1SBccy45bQlQsI+eiEUpk/fnC2595Et2S7eMnaU4/Rp5c/uNT5XYHEhS6lA6NbQuxuNG5G49lOP9r8wOHstZtxvtqs3hFrFB6avgxdFksrnhI9wYPATn5Fk5ZzAmmvU/qMppcyI1ImceeY7rnE+zHSKJajhRXzH4n0GU3bpeulWyRijw+SA4DT5iOzcVmPYWreP6n+Zej6+VCq15PhDOurNgR+uUvDAucsUUMDNpSi+PYL3BA/Czc/L6KmU4KUusLL5UK3ti1YYQcJwQREckt0+Sm22cgyOY5zQaJl5qT56ObWYIaiVyrvglxXM9YA811moIYtOtgL6mCdVzyMCeapMmudwyV/jKqdrY4p8oKQYyr6Qv8P5oelhWfzChlGQ0ZbbY
 uzGgubo+
 rSg1eBRqlnepzEhBQZh7/xLryxxf7u/2H4oM6E/pHSxeIni6mcdocxMDvSypM2KdzUJYX+WyArkzg/9IYegzN8YQJI+TUP94zxm7wBiggKA88619Sm69IdjrF9zFXX5WtxwieTuQSmLkbvxHdsLoWU1Mri1o8rWylBnoQniyzHo9IMsXPP9lyIl+ZjnUraCn+SCZNS4gLiJQSq7jPtb9H21rECgfVwzhNsO/5M+dIlowFavRm2sVx+8ITcCpTg1+SZM2t93FYE0A4Z5Lq0jCjkMHwYPOhNJlY1LVHkGfLwX+RL/6oQgEwOrTVIMbrKUBVeWcQ3+3JyaFQ8W8AY97eURqXLSyrgCLPkaNNLD0An3Q90qR00GfU3Yyg6QBNB++WTDastOWb/UE0rKF2/ONSdpGkW8Q2rIc3L9oTOAMIPvjtqzREGlILzzumaZFCjEcmQqbrH9JzxpESSH6YvaMtnkNVrQM/tJR8M8oCLnd6u0TLsG2E+sBysSp9Nq9li9kt5itK2OqjXEQx+kId/jcOKvrUlQN9Bw64B6K1Wig5o9wj9swxHUrFN1dF0hydZ0QRROESy4SB55QyAvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc: Pedro

On Fri, Oct 16, 2026 at 05:57:48PM +0800, Baolin Wang wrote:
>
>
>On 10/16/26 2:59 PM, Lance Yang wrote:
>> collapse_file() can end up calling page_cache_sync_readahead() with
>> source folios from earlier in the range still locked. If truncate already
>> holds mapping->invalidate_lock exclusively and is waiting for one of
>> those folios, readahead blocks on the same invalidate_lock and neither
>> side can make progress.
>> 
>> Do readahead in a separate pass before we start holding source folios
>> locked for collapse. Keep page_cache_sync_readahead() and its existing
>> policy, and drop each folio's lock and reference after checking that it
>> is uptodate. If truncate or reclaim removes a folio between the two
>> passes, roll back instead of doing readahead again with source folios
>> locked.
>> 
>> Shmem handles swapin and fallocated folios through shmem_get_folio()
>> without taking mapping->invalidate_lock, so it isn't affected by this
>> lock inversion.
>> 
>> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
>> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>
>Thanks for the fix.

Cheers!

>> Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
>> happy to take this over.
>> 
>> Some older stable trees lack the folio infrastructure used here, and the
>> code will differ for each stable tree, so each backport will need quite a
>> bit of rework and its own review. I'm not sure whether to Cc stable here.
>> Once we agree on the fix, I'll send a separate backport for each maintained
>> stable tree except 5.10, which isn't affected.
>> 
>> v2 -> v3:
>>   - Replace the scan-wide invalidate_lock and page_cache_ra_unbounded() with
>>     a preparation pass using page_cache_sync_readahead().
>>   - Roll back on a new page cache miss during collapse.
>>   - https://lore.kernel.org/all/20260913163644.122133-1-ngocthang2710.1999@gmail.com/
>> 
>>   mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
>>   1 file changed, 31 insertions(+), 11 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index ef5cd6fda34f..b3f67617caf0 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>   	new_folio->index = start;
>>   	new_folio->mapping = mapping;
>>   
>> +	if (!is_shmem) {
>> +		/*
>> +		 * Populate the range before accumulating locked source folios:
>> +		 * readahead may block on invalidate_lock.
>> +		 */
>> +		for (index = start; index < end;) {
>
>why drop xas_unlock_irq()?

Hmm ... we haven't taken the lock here yet, so there's just nothing to
unlock, no?

>> +			folio = filemap_lock_folio(mapping, index);
>> +			if (IS_ERR(folio)) {
>> +				page_cache_sync_readahead(mapping, &file->f_ra,
>> +							  file, index, end - index);
>> +				folio = filemap_lock_folio(mapping, index);
>> +				if (IS_ERR(folio)) {
>> +					result = SCAN_FAIL;
>> +					goto rollback;
>> +				}
>> +			}
>> +			if (!folio_test_uptodate(folio))
>> +				result = SCAN_FAIL;
>
>Do we need to check PG_uptodate after locking the folio? If we 
>successfully lock the folio, doesn't that mean the read I/O has 
>completed? The following code also checks the writeback flag, so the 
>uptodate check seems unnecessary to me.

IIRC, the folio gets unlocked even if the read fails. I just wanted to
catch read errors early. And yeah, we already check uptodate later,
so this one can go, thanks!

>> +			index = folio_next_index(folio);
>> +			folio_unlock(folio);
>> +			folio_put(folio);
>> +			if (result != SCAN_SUCCEED)
>> +				goto rollback;
>> +		}
>> +		/* drain lru cache to help folio_isolate_lru() */
>> +		lru_add_drain();
>> +	}
>
>Could we factor this code out into a small helper?

Okay, let me play with it a bit :) Might pull it out if it reads cleaner.

Thanks, Lance

>> +
>>   	/*
>>   	 * Ensure we have slots for all the pages in the range.  This is
>>   	 * almost certainly a no-op because most of the pages must be present
>> @@ -2320,17 +2348,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>   			}
>>   		} else {	/* !is_shmem */
>>   			if (!folio || xa_is_value(folio)) {
>> -				xas_unlock_irq(&xas);
>> -				page_cache_sync_readahead(mapping, &file->f_ra,
>> -							  file, index,
>> -							  end - index);
>> -				/* drain lru cache to help folio_isolate_lru() */
>> -				lru_add_drain();
>> -				folio = filemap_lock_folio(mapping, index);
>> -				if (IS_ERR(folio)) {
>> -					result = SCAN_FAIL;
>> -					goto xa_unlocked;
>> -				}
>> +				/* The range changed after the preparation pass. */
>> +				result = SCAN_PAGE_LOCK;
>> +				goto xa_locked;
>>   			} else if (folio_test_dirty(folio)) {
>>   				/*
>>   				 * This page is dirty because it hasn't
>
>

