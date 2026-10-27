Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E884F606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aBMxL8KF
Received: by kanga.kvack.org (Postfix)
	id 0190D6B05B1; Mon, 26 Oct 2026 22:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C086B05B2; Mon, 26 Oct 2026 22:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22746B05B3; Mon, 26 Oct 2026 22:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC2EF6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:55:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE136A85D9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:55:36 +0000 (UTC)
X-FDA: 85366890672.21.2634BAB
Received: from mta0.migadu.com (out-75.mta0.migadu.com [91.218.175.75])
	by imf03.hostedemail.com (Postfix) with ESMTP id E594F20005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:55:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aBMxL8KF;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069734;
	b=PUiVYUV9skUkhjWfLnpyDusdl5rJb3kFlnsYpnyaAqj0qVQbMSI6yByXImjKkd+LqVGer+
	dMe6R+XpQ7TVn8r3uwy68lnBOb8BydrC57/mXotuARhzMgBlBXEo6tI+FPis2RBrJqEZsw
	aUZqIJw0st0yWITkYYainqAhGbZiBuk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aBMxL8KF;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.75 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V9PFsHDtvXgwv6NYqyvGmgu7gAiiaLp/I8Vm0DnTkkk=;
	b=sC/pv9LInqRpQ8bfb0eaoO17KlVJGbE0KW7mnKZGo5mAgH7SOUoKPIdHOS0d3TBJIZv7ng
	NC/EB5pnXwN8FyGZhn9rG0G2PNJ0xXuhNu8Z7WtqTPE5BGQGKjAjh2Ovj9N28if3mHbImm
	rTgHmFCoOrt7TcKark2EEsqWNkAeaq4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aboeRYMBw2lMDN35kj+b7/S1t+rS41JAG+rBlUvVfhg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793069731; v=1; x=1793674531;
 b=aBMxL8KFpPbDzPXO2Idhj+x/0LL9hPc0iCPINsROyW4JAgRJKEJbI4Dne6RDhrotLAq/vasN
 VUh8maR/W/RnXrExj8qcQhRACKY3emUYvEyaH5rDtvXBYOdnvXLwtrGkZqXgowqsxRD5oCbyu0l
 97/+ERTxKtiScXm006KKWZ8s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8a802e798165f00b;
	Tue, 27 Oct 2026 02:55:13 +0000
X-Mizu-Trace-ID: 8a802e798165f00b
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: pfalcato@suse.de
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
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
	ngocthang2710.1999@gmail.com,
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in collapse_file()
Date: Tue, 27 Oct 2026 10:55:07 +0800
Message-ID: <20261027025507.59451-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <at9_1mf2kLqMX8-W@pedro-suse.tail5790ac.ts.net>
References: <at9_1mf2kLqMX8-W@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xn9q1dduwkqmzcchd183hfxq1pyixhop
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E594F20005
X-Rspam-User: 
X-HE-Tag: 1793069732-157394
X-HE-Meta: U2FsdGVkX184b6apzVTSFMBuR6kc+ofmWOcBXrKcEWsJ49WeDexxX+idbrNAIPMRKbR8kTDDq9NhVYC1q953UPrmxwb4KFefsVvUlvxnRpl5J+dU3GuKmyY2kRuqzLwjMGMeT3BXfim/rYZ+RmxWtituoPsBSMCTPCL9WP6rrTXq1kBuVcl4GphEbSreYCuiC1WIA/Cg7rkZei81bN0/dr/oce/TtjxpXSjNdM+RdIBS1/yagrXPMBb+gGl2ilwmsSsxMhu+8aiPkcIQbEjG04Ijrz29ag1pGHaQ4FBrHaYXjzuW8YDSu6Mt45HuQdPSZ9NohZ9tr9wrUoiQGk3leRZqzPWYbjB0rJvATV4eS0XXUPs+c74dsiqwnXvgS5B3R6S6bob0kAoRsBF17mdUj0rsgWSqpmPFazgdpNTRhtinKfXOK4otnhXF5BknilJh8rgiXp4snmPcyeyTGbB7Ggic9U54e/nb8pCTrPSpqFz4dXy2uuJG4HaR/GQFbzyxE/EVa4ly6WJFSTOi2awEkcGxesHml94PJ3GG+fiI/Wr5SLJA0v3bgdSkfQ+7GOfSv+MHV11TXpXKMs8rEsxaBPN0nlPf3rdJk3rApA2IOKQsU20wLETMde5lEBk4V7NnEJhhfOlOqc8WZOa7egQxu/eNeSnOvj38akWjvakwXka9xlqOqSl23gdq9Pq+lXNPXcQdTUEaKQCnMv0yOrpk4xGJWKePcPiuQVpMJks3bHt5KePA81INKIqkLJwJETvLdJ/VuZmKNAh/2ucxbadw3/r7v0uC/K0mLLkelACuZZEZCeiVkcLFxs3GPdgiTtxkl1tdc+TfGd7TUnzzNmM5u3WbVbYhpouQwHB63tvlfappFI24EdTodY6hI06KOL97uEw66lCSEgOzNBTmKt4pZ6DStQz47Xe7eZZxPMhJuadS43GL0XO5HtO/FLq5vFd4K/CNe6/F6HbaaVNAJuu
 rxSMwOAH
 2WdynJMT+wvMeyZ9FV5GdN5K8N04vX1/2RF90GbCMygdQCyUDgtPtmao4I0oIIQgedN5paX4SO77TI5B1YpXpP/St7Im+LYfS+G9+1umvJco1hs4tb28wJvjlkpVQUWrJSLuqAfOOZ9KCxOMyXYZUviPPxvPxxOQHKdvVPcckM4kZTTQrktA1sqKB2UCGn/lW0vLZfJUzdAVRkqydUTRnAIxExpC3xBAtgmv5HrNLukV1hbX640fV6EUQ48v+7C/Uhuvy48+ED5TLI7/c/UdeA+cUcAiDkUPkzv7IeSLBJYNXS0XEqMTAPfgBOE0CLz3dVQxzJWbUQVjkXxgYKIMmarYt/eqX+UTt14wt4KF+vxxJtGo9yOFNsvdkoBKFegWyxoz87seNa59fRsER8RmPmVBUbFX0Z7atbMyzPJJvGEMQbim86fJ9onJEsogsfSyf9NxCcjpvWgDpeWhqaKQMmDfNPSb8FR9F9//TaoAeIBnxIa+fWicE+YcClEWr31+8Z19iR1hXJOSyOcYKyG5hHt4iO95t2Ru5dlo6ueD3nwvjumLqdiofblMEsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Oct 26, 2026 at 04:33:08PM +0000, Pedro Falcato wrote:
>On Mon, Oct 26, 2026 at 11:20:13PM +0800, Lance Yang wrote:
>> collapse_file() can call page_cache_sync_readahead() while still holding
>> source folios locked. If truncate holds mapping->invalidate_lock
>> exclusively and waits for one of those folios, readahead waits for
>> invalidate_lock and neither side can make progress.
>> 
>> We need to release those folio locks before starting readahead. On a page
>> cache miss, roll back first, populate the collapse range, and retry once.
>> Doing readahead after rollback avoids an extra pass when all folios are
>> already present. If another miss occurs on retry, give up rather than keep
>> retrying while truncate or reclaim removes folios.
>> 
>> Keep page_cache_sync_readahead() and wait for read I/O with
>> filemap_lock_folio(), releasing each folio before moving to the next. The
>> existing uptodate check during collapse still handles read errors.
>> 
>> Shmem uses shmem_get_folio() for swapin and fallocated folios without
>> taking mapping->invalidate_lock, so it is unaffected.
>> 
>> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
>> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>
>Thanks for the patch! This looks almost perfect!

Thanks Pedro!

>
>> ---
>> v3 -> v4:
>>  - Move readahead after rollback and retry collapse once (per Pedro).
>>  - Drop the preparation pass and its redundant uptodate check (per
>>    Baolin and Pedro). Thanks!
>>  - https://lore.kernel.org/all/20261016065920.4153-1-lance.yang@linux.dev/
>> 
>>  mm/khugepaged.c | 44 +++++++++++++++++++++++++++++++++-----------
>>  1 file changed, 33 insertions(+), 11 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index da91762f6358..0d3bd9e23613 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2239,6 +2239,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>  	enum scan_result result = SCAN_SUCCEED;
>>  	int nr_none = 0;
>>  	bool is_shmem = shmem_file(file);
>> +	bool do_readahead = false;
>> +	bool readahead_done = false;
>>  
>>  	/*
>>  	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
>> @@ -2256,6 +2258,10 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>  
>>  	mapping_set_update(&xas, mapping);
>>  
>> +retry:
>> +	result = SCAN_SUCCEED;
>> +	do_readahead = false;
>> +	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
>>  	__folio_set_locked(new_folio);
>>  	if (is_shmem)
>>  		__folio_set_swapbacked(new_folio);
>> @@ -2320,17 +2326,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>  			}
>>  		} else {	/* !is_shmem */
>>  			if (!folio || xa_is_value(folio)) {
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
>> +				do_readahead = !readahead_done;
>> +				result = SCAN_FAIL;
>> +				goto xa_locked;
>>  			} else if (folio_test_dirty(folio)) {
>>  				/*
>>  				 * This page is dirty because it hasn't
>> @@ -2657,6 +2655,30 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>  	new_folio->mapping = NULL;
>>  
>>  	folio_unlock(new_folio);
>> +
>> +	/* Readahead may take invalidate_lock; source folios are unlocked. */
>> +	if (do_readahead) {
>> +		for (index = start; index < end;) {
>> +			folio = filemap_lock_folio(mapping, index);
>
>I'm not sure if there's a point in locking the folio. If we are retrying,
>then the logic above will lock it anyway and check uptodate. So I don't
>think there's much of a point doing it here. Right?
>
>So I think we could get away with a filemap_get_folio() here, and no
>filemap_lock_folio() after RA. Unless you're intent on waiting for RA
>right before failing, but I don't see a point in that.

Right, waiting for RA is what I intended here. Without that wait, the
retry can hit folio_trylock() while the read is still in flight and bail
out with SCAN_PAGE_LOCK, before it even gets to the uptodate check.

If the read completes successfully, we can continue with collapse.
That's why I kept the wait before retrying. Do you think waiting isn't
worth it here, and we'd be better off leaving collapse to a later
attempt?

>
>With that addressed:
>
>Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Really appreciated!

>> +			if (IS_ERR(folio)) {
>> +				page_cache_sync_readahead(mapping, &file->f_ra,
>> +							  file, index, end - index);
>> +				folio = filemap_lock_folio(mapping, index);
>> +				if (IS_ERR(folio)) {
>> +					result = SCAN_FAIL;
>> +					goto out_put;
>> +				}
>> +			}
>> +			index = folio_next_index(folio);
>> +			folio_unlock(folio);
>> +			folio_put(folio);
>> +		}
>> +		/* Drain the local LRU batch before retrying isolation. */
>> +		lru_add_drain();
>> +		readahead_done = true;
>> +		goto retry;
>> +	}
>> +out_put:
>>  	folio_put(new_folio);
>>  out:
>>  	VM_BUG_ON(!list_empty(&pagelist));
>> -- 
>> 2.49.0
>> 
>
>-- 
>Pedro
>

