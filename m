Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC17CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 02:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58488E009A; Wed, 17 Sep 2025 22:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FB38E006B; Wed, 17 Sep 2025 22:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C718E009A; Wed, 17 Sep 2025 22:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B167C8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 22:22:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D2EA1A076F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:22:32 +0000 (UTC)
X-FDA: 83900772144.14.9AC684D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf09.hostedemail.com (Postfix) with ESMTP id 401DD140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:22:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FXmRR6vb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758162150; a=rsa-sha256;
	cv=none;
	b=kLsFa1/xZ6UluPH6y5Rhhdz4ynEkZp52KYZ7gkU54mWZgrxSkGdELz/LzIkxP0a22ugQ8Z
	xFZdMjrfzmMt7PPelXcGRFv4Us2VbB6WgAlSJf+jQElDkxaOH1f35FMXcc4jmEx/ww3zqt
	u01ISm0FHAGyYs7UOAkLkOs9JX9Zgls=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FXmRR6vb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758162150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUgmNLpciY51XRiDAlwpEoWyC0Ozy4WSZRgjpXt9VkE=;
	b=BIIeIquzgruVBmwEzN8o8m2nsNbjf84Fo1Hffiu8cPkj0kPscHZdjf4nfHNuARDDzeCR88
	8xN2FaoYgGgnZg+k78GN1ixghyCPbdUP9gkNrAFAE2MctIBdqAIyayuTBnCr3KDTpqw0mf
	JM4rkP4q4wc3P6Mt7GhkvxbRnXAvjMU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758162146; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=AUgmNLpciY51XRiDAlwpEoWyC0Ozy4WSZRgjpXt9VkE=;
	b=FXmRR6vbzlUkOllk6lCB2RUWTDZGFKS2kzhNEx4GrBM+0Uqm2uvKXZ8pDqOJph2rZfdf+ayAYaX5osT8OtTu9Eu6nmXmzAEFuh+D5DVp+I8noRwPtZmcxD1LrObagSg8soX4JKGhuPaWmYCo3yGGBDgNNgHTKAZbnAtnmODutIw=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoEIrkb_1758162143 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 10:22:24 +0800
Message-ID: <122ec2b9-8f0f-4184-a15b-8f3ccbd336ea@linux.alibaba.com>
Date: Thu, 18 Sep 2025 10:22:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: Hugh Dickins <hughd@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, david@redhat.com, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <qe56xt2natnxnkht7wgknsb5nqjhinaaajomvvvgnfpwry2jih@hsj2w5zqj6wv>
 <02798d6c-1ad3-4109-be3a-e09feb5e4eda@linux.alibaba.com>
 <9b01a2cc-7cdb-e008-f5bc-ff9aa313621a@google.com>
 <6ebb5cd0-0897-4de7-9303-422d0caa18cb@linux.alibaba.com>
 <7eace9f6-e257-498d-ac10-ae86b5713e3a@linux.alibaba.com>
 <1111883c-974f-e4da-a38f-bb3d337185ad@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <1111883c-974f-e4da-a38f-bb3d337185ad@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 401DD140007
X-Stat-Signature: wr8d7jjzanqfw784wbzhn7xqfcoqgfek
X-Rspam-User: 
X-HE-Tag: 1758162149-143628
X-HE-Meta: U2FsdGVkX189/LIxoawdip6NxOnPMgT3zkrWrVyupPvB+g/LCOsz17LiNbYHkSNuPrw7ALJGPOJtlQ3y5WQv7z19jCPjcTzs7Gz++62nhNG+Bu9+aBHBDs5U0MHXaLQSmLeHTN8IjpBXHgqaro0QrEavUufLhV5gSqsq6Y3qUe/FS4iN6DH398t/9rhE6ITf7IDkjxgmuwB6VkCcOIji/LXxxQ4GWlfARx3JDnFfg4UIQrNeEaEFZ/JOmRgIhzfpj8cw8KLPBhoNGFOzGevAYNlyY8CMPlpXV0t2qSR1Ff681Fae3+hRwm6HtedLUsXKXInPBCT7J34+7MGviFDGQR/6LcvnFgjdFFm/FQXmegO2L1RjSwikhCmNmBLF3S/fH6bZSmLP9MynHPW3h3r3YxU+yoB5y5qtH5qOrFjD5jMQyAli3Nd8Z9PqYAOTBZKimpRCQntEbIq/arI0gLFBLyVq4AmPhqzlgBBsEEum7gA5TavupOVDmJWTy3/aOomZi7icFU032sy2uUdLVG/YKVMeQnKDa7O1FuebwzKMPSugn1PEiozZxpVqihPHwHZC9lKUDc2wEAL3urAVMgwiqnsE/oR3Z9o6Libbta4iPRvINBX6TyB+7v3wY6d1YZfI1LF3ncEoeBk9vTfu2oeFji6LBKcqU/LUOwVXJr31jEz/LHgC29T5s/ODPzqtsGqDnFgGJ75WwV18f1xogzk/mmPFxBUv5PmwmeNBgIohByAZ0NtlDF4mtzGw4hz2cf2zNZA6Az0UqtNapcUmV5fTuYm4PQ2MpQKK/FXm+htEbPUJTr4ctgzqwc0p7f/GqkqdNTjq0wS5lpSu3z65uRzPkpT4ZzHHImJ4nGykhUVroR2M4ptigv9WZmvZj40iuRlx2Ze9RhMY7PUWGiVPS0J/K2m7TUiWFzc1rYx352yIxUNp1su2pJyEFamfgQlCIrEmRCYh+z0KL9cTW1uTVnm
 Q1PhAcpE
 6ElQtQu6vTxxuYjLihaeZp8e8uBcbQqroxQXLrJVvkHoh3mdsR+HpvfjKr6WJE+h8wYgRk7b5L5bTZfJf9FV18Z2BED8N+o4ukMuALCv0ITLBcYdvLa160fzYlMMlgld8kKQhM7eVvkchl9kFCH2zrttB2SZqCeM+bOQYZow4Tu+Xrnre2dsgHCo1JvsOXLfrNaWN1ikPqNX4RjFviXN/vLkaNx+tEqlRfjV/vcrdl1VRUFFlWIP+4Cn5hHd447Gt6MQ5hv3WrHqbeKwRjkBPM++3pLN0FJW4LROm0dK1mGPD4Vrq7+uV6G4fo6aaYUA8u1DaI+gEoTc6niCQyx8/a8G8MWHKF/J6/dWCLkuoA+ClADDWO2w4OvDAOozWXOF6BRaxo7VuckmEhXaICvxsskuT69dyD8d/k+CKxf4oxNKE1gOJQ7sDWA6Knc0Jft77vq5WREKroX62UPE6AnJDzAOIWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/17 15:49, Hugh Dickins wrote:
> On Wed, 17 Sep 2025, Baolin Wang wrote:
>> On 2025/9/16 15:18, Baolin Wang wrote:
> ...
>>>
>>> Additionally, I'm still struggling to understand this case where a folio is
>>> dirty but has a NULL mapping, but I might understand that ext3 journaling
>>> might do this from the comments in truncate_cleanup_folio().
>>>
>>> But I still doubt whether this case exists because the refcount check in
>>> is_page_cache_freeable() considers the pagecache. This means if this dirty
>>> folio's mapping is NULL, the following check would return false. If it
>>> returns true, it means that even if we release the private data here, the
>>> orphaned folio's refcount still doesn't meet the requirements for being
>>> reclaimed. Please correct me if I missed anything.
>>>
>>> static inline int is_page_cache_freeable(struct folio *folio)
>>> {
>>>           /*
>>>            * A freeable page cache folio is referenced only by the caller
>>>            * that isolated the folio, the page cache and optional filesystem
>>>            * private data at folio->private.
>>>            */
>>>           return folio_ref_count(folio) - folio_test_private(folio) ==
>>>                   1 + folio_nr_pages(folio);
>>> }
>>>
> 
> Good point, yes, it's surprising that that such a folio could pass
> that check and reach the code you're proposing to delete.
> 
> (Though a racing scanner of physical memory could raise the refcount
> momentarily, causing the folio to look like a page cache freeable.)
> 
>>
>> I continued to dig into the historical commits, where the private check was
>> introduced in 2005 by commit ce91b575332b ("orphaned pagecache memleak fix"),
>> as the commit message mentioned, it was to address the issue where reiserfs
>> pagecache may be truncated while still pinned:
> 
> Yes, I had been doing the same research, coming to that same 2.6.12 commit,
> one of the last to go in before the birth of git.
> 
>>
>> "
>> Chris found that with data journaling a reiserfs pagecache may be truncate
>> while still pinned.  The truncation removes the page->mapping, but the page is
>> still listed in the VM queues because it still has buffers.  Then during the
>> journaling process, a buffer is marked dirty and that sets the PG_dirty
>> bitflag as well (in mark_buffer_dirty). After that the page is leaked because
>> it's both dirty and without a mapping.
>>
>> So we must allow pages without mapping and dirty to reach the PagePrivate
>> check.  The page->mapping will be checked again right after the PagePrivate
>> check.
>> "
>>
>> In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3
>> data=journal") seems to be dealing with a similar issue, where the page
>> becomes dirty after truncation, and provides a very useful call stack:
>> truncate_complete_page()
>>        cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
>>        do_invalidatepage()
>>          ext3_invalidatepage()
>>            journal_invalidatepage()
>>              journal_unmap_buffer()
>>                __dispose_buffer()
>>                  __journal_unfile_buffer()
>>                    __journal_temp_unlink_buffer()
>>                      mark_buffer_dirty(); // PG_dirty set, incr. dirty pages
>>
>> In this fix, we forcefully clear the page's dirty flag during truncation (in
>> truncate_complete_page()).
> 
> But missed that one.
> 
>>
>> However, I am still unsure how the reiserfs case is checked through
>> is_page_cache_freeable() (if the pagecache is truncated, then the pagecache
>> refcount would be decreased). Fortunately, reiserfs was removed in 2024 by
>> commit fb6f20ecb121 ("reiserfs: The last commit").
> 
> I did find a single report of the "pageout: orphaned page" message
> (where Andrew claims the message as his forgotten temporary debugging):
> 
> https://lore.kernel.org/all/20061002170353.GA26816@king.bitgnome.net/
> 
>  From 2006 on 2.6.18: and indeed it was on reiserfs - maybe reiserfs
> had some extra refcounting on these pages, which caused them to pass
> the is_page_cache_freeable() check (but would they actually be freeable,
> or leaked? TBH I haven't tried to work that out, nor care very much).
> 
> Where does this leave us?  I think it says that your deletion of that
> block from pageout() is acceptable now, with reiserfs gone to history.
> 
> Though somehow I would prefer, like that ext3 fix, that we would just
> clear dirty on such a folio (to avoid "Bad page state" later if it is
> freeable), not go to pageout(), but proceed to the folio_needs_release()
> block like for clean folios.
> 
> But whatever: you've persuaded me! I withdraw my objection to your patch.

Thanks for confirming. I will update the commit message based on our 
discussion.

