Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23EDCC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 01:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16D966B0092; Mon,  6 Jul 2026 21:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144FD6B0093; Mon,  6 Jul 2026 21:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B4C6B009F; Mon,  6 Jul 2026 21:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2DF36B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 21:53:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56E741C2899
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:53:03 +0000 (UTC)
X-FDA: 84960307446.24.60A8FBA
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0818F80007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:52:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eZDWZpD5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783389181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hw5q4igm2fogQzAtaGDe/H5R57ywxMLb1WkudZyAasU=;
	b=KXCBszhonocTKPnIkvufMQAvETvbbwc+uZ6tKe0+/Hbrto2AqhyJv47nFvoEBlfwAwtTZo
	MMc1uNjI6RqSJuLUhWxU5emkBRC3pvDKHsPRc8tYjn3B7TGk3PpZ9Rj9yqK8haoTpcETG7
	RtSLH/Aj4Pl6Evivvn+XWkhqkaARtDE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eZDWZpD5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783389181;
	b=yvWKGW7ApFI8YrFtCaCXdDj3zSgVicXwv+Xc/0iTK5jQ4BIhvi3KEWAqteRsPG1xoqo74A
	u7K9ldKmmgN3uCoevgBQjc35RZUOslOJw5Ss3HE7PmZQ+sys1Q6XIkIPrIFL5t4s3nxtfG
	Zb9+dGxq7vlOQO1gBF5a9Gl2Ospf5ig=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783389176; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Hw5q4igm2fogQzAtaGDe/H5R57ywxMLb1WkudZyAasU=;
	b=eZDWZpD5wATmy/rFJKJ1Bkv4uHBGv1//hCAHxhzqWXGbSBwLcof+lBbcqGZlfYtqAn7qrKQzxIMAB8NcWWvj0/hjSlKfqCUBxuRCzHF1/3hXXbU3G2PPmPrkk5utWTNEbjglCX4lPiDVWznkqHnqwFFxk/x0tjRt1vancwl3Zx8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X6atYrA_1783389174;
Received: from 30.246.177.139(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6atYrA_1783389174 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jul 2026 09:52:55 +0800
Message-ID: <d01bae40-f94d-4e8a-baac-ad6fffa18b64@linux.alibaba.com>
Date: Tue, 7 Jul 2026 09:52:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18.y] mm: shmem: fix potential livelock issue for shmem
 direct swapin
To: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org,
 hughd@google.com, stable@vger.kernel.org, machao26@xiaomi.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <173f3fd983d735155d47e9e39d27f0c2d62a7c31.1783307463.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7AQcyypJ-VhJ_CxY6fdEph64fxjOzzYU-=EkMrHemkpzA@mail.gmail.com>
 <8ef0b72e-a0e8-4913-8d30-519335305260@linux.alibaba.com>
 <CAGsJ_4z5N6FSfWt5WUZ5YmqhCzLcd3Cj1sc9B79WYX9ZbDH8Gw@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4z5N6FSfWt5WUZ5YmqhCzLcd3Cj1sc9B79WYX9ZbDH8Gw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0818F80007
X-Stat-Signature: qu6yk1fs3tocyfqeh339uk1xszjswdyd
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783389179-598059
X-HE-Meta: U2FsdGVkX19hZlEN0ulvC6XUF3wET18Y7UF+I0rQOzE3jYHb7S4lD1DjRvWhJMo294WyCmCVl/oyXHXNwj5AT7/5Ia1JXXJ1+YE1XKeolU0nMCN85F/zXbs1uPx5ll4BHwM7ePk1nSK2rAoeMkA7/QSRgJpaQoXnFr6sopAlcEfxfIGnVW+SOqtCldRLVIW68RMDxla0zipNjnFM3cQN5fWZCeO2j2H5Nw36VHWl6RXj/LA75iXSd0L2uAiD8XaxGLdJ0PSLRk9oA1rjjRmt4wq+sZXHraWz4h8KzaI+tbUUu+XhNsi3DcX/rXc/zrNhtKFssjd6W4sk98oIpIHuBrP2QGV1Uu912Hmma/WiAoTF3uDukgeYW9ZUf2Kxii4RlPN4BNYc/anNpRrweO75LVWpiYESzWo0+RdWN8vBzuZx2U6Hh+k5AJ1L24VLMirnZtLfWTxQVyS3aaZ5dx9iwaym6GizeZX/YB+HLtHBTd92CvUlIrot11BRmgezqo29ikRo2dTT4xMEwiXF5JWgC0tkAbBy3rj8yum8Dw9iAyCAvLyWJwbAi6UtKrS+BPBFLR2O00PWo3NjfG9dlYcU+pjUomy1y096fkHtMCRVBYcRxPUCnBmijTZMX0dRXTrCsvUGt4zf1pmWStqs8DOt30j5QHRu1KwvCgf/80RO78YogLEcaHE5fHXUnMrX9HIG9VUMaUWTARjIkvO/PXrP8SgE7VzW1z6UwInnMWBFZ2+NWOdPAmJSbMLBUHbZlmphxmStUy3lzpzyQ+PwIC8xJBedbC2rTyspE+d52LvHBL7qG397SL4t4bALDMYvWmB1+ytuSuSGbwMvSfsuRf7rthVsAFSzxno0AKKGNXCXZth6fb5Em7jj1sMFbL3WVtJH4tbOhn4kygR5lAmEKI0EXJJTA6awCs7mLbsnsRQcY3+pkgVrrHS9dGGk/qiBOJ73ly+DpAMTByZ6l0GpLoH
 bNSjcZqu
 6I191iUUVsrNf4VFrCfBtJl40Luin1swS719POLD1NIRDefKahk7wkBOhrPjbAOV4/+Bc0LKbx45PbS8T7wiGpRZgRyUms7SDf7c1w7BmlNdHMjWqBl30b80WpMi9Gw0TDux59XINXTNXebsUaiegygpNibAnv7eG8kolG7ovjsH5ZsGFc0R0lqQQCU7zcz5puRPHcAXXmG5N2K5gERW04e9/cP9zWA57qcc6lKHm0UrKusPHmSgbPTmZf0mljU/3CL4nvMB9OJCAzkZf67uU87cHs2AOkbRviYxAtLKIOM+C8/sUnlDVi1pmyycbT+fv44usXx3ck4hXozmeV66MM1DPpT1okABYQwo9ZfA8z9jmo1vrQSZDQ/kJ7rYRlv6DF/hRW9PtNJn0LPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/6/26 9:04 PM, Barry Song wrote:
> On Mon, Jul 6, 2026 at 8:08 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 7/6/26 1:59 PM, Kairui Song wrote:
>>> On Mon, Jul 6, 2026 at 11:25 AM Baolin Wang
>>> <baolin.wang@linux.alibaba.com> wrote:
>>>>
>>>> When skipping swapcache for synchronous IO swap devices, swapcache_prepare()
>>>> is used to prevent parallel swapin from proceeding with the swap cache flag.
>>>> However, on PREEMPT kernels this can lead to a livelock, as reported by Chao[1]:
>>>>
>>>> Thread A starts direct swapin of a shmem folio and calls swapcache_prepare()
>>>> to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault().
>>>> Meanwhile, a higher priority thread B also attempts direct swapin of the same
>>>> shmem swap entry. Since swapcache_prepare() already marks the entry, thread B
>>>> repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. But as
>>>> thread B runs at higher priority, thread A cannot preempt it, resulting in
>>>> starvation and a livelock.
>>>>
>>>> Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
>>>> swapcache_prepare() fails, following the same approach used in commits
>>>> 029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
>>>> 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").
>>>>
>>>> Note that mainline does not have this potential issue, which has already been
>>>> resolved by Kairui's swap refactoring work[2].
>>>>
>>>> [1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
>>>> [2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
>>>> Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous swap device")
>>>> Reported-by: Ma Chao <machao26@xiaomi.com>
>>>> Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>> Hi Chao, could you try this patch to check if it fixes your issue? Thanks.
>>>> ---
>>>>    mm/shmem.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index 94c5b0d78ac3..d4cb57b3b0ef 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -2066,6 +2066,8 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>>>           if (swapcache_prepare(entry, nr_pages)) {
>>>>                   folio_put(new);
>>>>                   new = ERR_PTR(-EEXIST);
>>>> +               /* Relax a bit to prevent rapid repeated page faults */
>>>> +               schedule_timeout_uninterruptible(1);
>>>>                   /* Try smaller folio to avoid cache conflict */
>>>>                   goto fallback;
>>>>           }
>>>> --
>>>> 2.47.3
>>>>
>>>
>>> Thanks! That's much more simpler than I expected. Do we need a wakeup
>>> queue like the one in commit 01626a1823024? Perhaps the reporter can
>>> help confirm and test? I personally prefer to keep it simple if shmem
>>> users aren't as sensitive as anon users.
>>
>> I agree. I'd like to keep the bugfix as simple as possible, if the
>> reporter's scenario isn't latency-sensitive.
> 
> On Android, we don't see much shmem; it's much less common
> than anon. So the chance of this concurrency happening should
> be lower than for anon. However, shmem can be shared by
> multiple processes, so could this still happen if process A is
> blocked by process B?

Could you be more specific about how that happens? I think we should fix 
this starvation/livelock issue if you think it could still happen.

