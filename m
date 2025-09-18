Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48816CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 09:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FA5280030; Thu, 18 Sep 2025 05:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 867D88E0093; Thu, 18 Sep 2025 05:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB43280030; Thu, 18 Sep 2025 05:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6AD8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:36:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E2181407C8
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:36:27 +0000 (UTC)
X-FDA: 83901865614.29.4ED085C
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf30.hostedemail.com (Postfix) with ESMTP id A7BBF80009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:36:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bkXoodev;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758188185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2eKu4d+bqGlhpwBm/TMfdF3CJWkzepb71FsO4wW6V+8=;
	b=yx3y4h8sH1qTVJOrhkTfCJaHeW47dj+RDm64cdqCfbfbqu7CCfkZJAQ5tFlYE6QA62cjkp
	rZ1mv1faOn/IdxoTkExscuIxMLEI5ieXkdSzLI3jdHPs8pGPmqcQE7Ye7cTOs08/imkxpo
	m/86mY3juEVG3BxR0fiPxDB0F8MyocI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bkXoodev;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758188185; a=rsa-sha256;
	cv=none;
	b=4eEzu/VFEoYbWTfjiwgSCzQ9d6/Mz+Xaknwd4fZ7LRRQtr8bL3RKPJ0i8vdQ7c71h5+X0W
	5jHbOgpMBBa1of794j3XD3tGUojvofIwIA/H+TnW7HTkD5Os3MGkoxNm2opUShk7H6H+kR
	Ed4NXrzOtzwZe2nMwIG85V92IjM9APg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758188180; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=2eKu4d+bqGlhpwBm/TMfdF3CJWkzepb71FsO4wW6V+8=;
	b=bkXoodev9mJNmwjJnn9a8ss56YCEbkZWRxv4ZpYD6Z9JXm22rgu+8+6EMoZLl10vikJyYcqIdBy+KHpdJ3fOJKSLeuZJfUI5DAU/Yp88p2JnAYuJ0t1D/4Ut40yD/2PJxM0DsF0eIZo93Rck5RnDQvTgFonPLzSY5vHiGxFVVYc=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoFZMIK_1758188178 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 17:36:18 +0800
Message-ID: <4e938fa1-c6ea-43fb-abbd-de514842a005@linux.alibaba.com>
Date: Thu, 18 Sep 2025 17:36:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
 <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com>
 <17d1b293-e393-4989-a357-7eea74b3c805@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <17d1b293-e393-4989-a357-7eea74b3c805@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A7BBF80009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bmg3rq4xd8ane1xod49nzgeis5trnxg4
X-HE-Tag: 1758188183-552421
X-HE-Meta: U2FsdGVkX19F9B7DV9WxqV5ERxrqgy7kvnDJPtRQZzyOwxYk+nZb8t8eTwy+E6TdD+Ov/HwqnzVmJJfM0IKBhLm4rtQnMlkHUxFe48ZMZEtcZvqOOC+cmLF3xSxgTxrWeztgcWDJ681/MyU28wUQaTwE3P4BpLallSgA3/UXukdliTUNXcdnbndRiN5OnF9RiRnluPZYBolYDZu0OXDTQn2oxgKkZVMLOiFt0GWgdA1rZIm9eL4cDSFbKZkoY3BBgPWAiWh9OBRLiiTAef00tLTJA/zSuTuLZNDORaEs9wQRhVagXE1KK2wVUy/97wQfTQvj3nl11SAL1B9WUnVo39tobiF3wOzqnmOrCfdyISsOf0YTn41q3oBRBEBqRuyvqFytcOTGldwfG/m7NQyJ2TjP/sYOV2zu09tTZHjav+79VE1qw3gojaBuNhSNPjTkuKMIkMnHdiVh+AHlw4zwxoTgtiKn7zqWPbIk+ypwYlokwggj8871k4Ywd5IMM49QBp0CvgMvKE2HhWagBTLr9G73CgsEzNWKaN+JNs+44+GPC/bI4YrWuXmfnihDsjSmg/NemZmUHL3EiNWzNGPLvfHE/it9fRK1oKdd2gvxtNsWlhMkKMvYkgg0BOTrEe7qotdE4WhlX4aEPotNjvWQiVA2QimuI7xtZOzL3q0kNn0fS2+plPMehO6b4T+SbI/OCB+6xhK5CtAnrlloaqwtX/PFFPXoxFDtUS71+I7J2bPnQ3lKva3Gp2P7bgefhBIJdTHHzKJ8oPxUmxrMFoDBjJ9UCihG924qf9m2o5/yaCPs4UrMOQ6oghZcbel6/+vq5wwg08mTgS48nFaZJM+ZUTOOg1HF5yk4X4okRgg8XKF4s+Pa2GxcAcmgvEqTp+KDlunZ1GA/XCT9c0MAelcbIJqTvCzKs+wHhrOHICkladaq1xaRCVu4s1P5LuSrwNdmmo386FDsJ5ZzM6jf9IF
 k4VZbKSh
 DC+fKLi9uN9gC670MUHBl2eroWPQ25Ux14Z/qofqC0UIThuIM9MQeUnY4et791dEBIh4wjjsWr2Qo3ArUwgSi5bGHlpEpbnd7i2aG+0heZehq4TrQuBrUdP1ZZ4ZPDRhPwevnkQGaWYjk0YOnNWs1qN6nK9ZFBLvWNZk7WOb/TP4bAju1MQ/BoVg8Ix6Se8VE2QJIo06VWgp77h3C85Z4PKXqtD9kCIUceypAgdFZ+VO8GIN+UAncjlOraq5pYVjLOROqeRWNvQGuz5/sDEQtPxQSCG0/+gKNrJ9winoO08GpBlvXYlPxliG+FH891LTgUGuM9LAD+OXGuQaMX7R85/93BFZBx1LSDkwjxjbA2KbfHV5NciiKTZSI9rXg2Ep7GLcNpADPfTD59meyiTdMI+PLLXLbJ0TE0YqX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/18 14:00, David Hildenbrand wrote:
> On 18.09.25 05:46, Baolin Wang wrote:
>> The folio_test_private() check in pageout() was introduced by commit
>> ce91b575332b ("orphaned pagecache memleak fix") in 2005 (checked from
>> a history tree[1]). As the commit message mentioned, it was to address
>> the issue where reiserfs pagecache may be truncated while still pinned.
>> To further explain, the truncation removes the page->mapping, but the
>> page is still listed in the VM queues because it still has buffers.
>>
>> In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3
>> data=journal") seems to be dealing with a similar issue, where the page
>> becomes dirty after truncation, and it provides a very useful call stack:
>> truncate_complete_page()
>>        cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
>>        do_invalidatepage()
>>          ext3_invalidatepage()
>>            journal_invalidatepage()
>>              journal_unmap_buffer()
>>                __dispose_buffer()
>>                  __journal_unfile_buffer()
>>                    __journal_temp_unlink_buffer()
>>                      mark_buffer_dirty(); // PG_dirty set, incr. dirty 
>> pages
>>
>> In this commit a2b345642f530, we forcefully clear the page's dirty flag
>> during truncation (in truncate_complete_page()).
>>
>> Now it seems this was just a peculiar usage specific to reiserfs. Maybe
>> reiserfs had some extra refcount on these pages, which caused them to 
>> pass
>> the is_page_cache_freeable() check. With the fix provided by commit 
>> a2b345642f530
>> and reiserfs being removed in 2024 by commit fb6f20ecb121 ("reiserfs: The
>> last commit"), such a case is unlikely to occur again. So let's remove 
>> the
>> redundant folio_test_private() checks and related buffer_head release 
>> logic,
>> and just leave a warning here to catch such a bug.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/vmscan.c | 12 +++---------
>>   1 file changed, 3 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index f1fc36729ddd..930add6d90ab 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -701,16 +701,10 @@ static pageout_t pageout(struct folio *folio, 
>> struct address_space *mapping,
>>           return PAGE_KEEP;
>>       if (!mapping) {
>>           /*
>> -         * Some data journaling orphaned folios can have
>> -         * folio->mapping == NULL while being dirty with clean buffers.
>> +         * Is it still possible to have a dirty folio with
>> +         * a NULL mapping? I think not.
>>            */
> 
> I would rephrase slightly (removing the "I think not"):
> 
> /*
>   * We should no longer have dirty folios with clean buffers and a NULL
>   * mapping. However, let's be careful for now.
>   */

LGTM.

Andrew, could you help squash these comments into this patch? Thanks.

>> -        if (folio_test_private(folio)) {
>> -            if (try_to_free_buffers(folio)) {
>> -                folio_clear_dirty(folio);
>> -                pr_info("%s: orphaned folio\n", __func__);
>> -                return PAGE_CLEAN;
>> -            }
>> -        }
>> +        VM_WARN_ON_FOLIO(true, folio);
>>           return PAGE_KEEP;
>>       }
> 
> 


