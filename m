Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F71CD8CA8
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 11:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0A66B0005; Sat, 13 Jun 2026 07:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BE16B008A; Sat, 13 Jun 2026 07:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32E56B008C; Sat, 13 Jun 2026 07:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF866B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 07:42:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B765A03A9
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 11:42:57 +0000 (UTC)
X-FDA: 84874702794.17.25624CA
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id E4E1DC0008
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 11:42:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KBNfIV+v;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781350975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTqTZlrXJGkzf6DKatFJDe6iI2I80SbiVoeN8MMMcZs=;
	b=6zNzWFH2BfIrBgXgzKzxNb7mtVM3oDXIWRwozm5cs5VSRM/I7LoyMC12unl62wya1cR4Y4
	1fJbNA+PTXh4QA7t8kFtkmRKYu57DlkJRfNlEquJ5MpgnZ0WdLUyPZ+/VuLZvkxrUGaRCR
	NSbd/MJedELYIlw0v2gPTqA7ry9kWfY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781350975;
	b=vgLP90QinZyYLnNsRGTtWXu5LWB3EP7M6m+i9a5xarZ842WbnDKtQ+AQe33gwcYbWAokzs
	iJEnuSofDnmQ+dk4KEtXQutiw+GgKmTIja6LmRcZ+x6gqE3ETa8/8aFZHuXaYtOiNeqaJa
	DDK3s+2rM/AySUCJ+WjnhoTiXoN6UBA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KBNfIV+v;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781350972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QTqTZlrXJGkzf6DKatFJDe6iI2I80SbiVoeN8MMMcZs=;
	b=KBNfIV+ven/Hd5kC64cB1Q5mvlExwdROUuOqN0XZYN+fs9JzDcYq3NL4cJB3IoVKF5dur+
	myZfGDawrF97O+d9K6sS1hTrqdaluLRn59/0+b1I6iJsRaCXPL1g0pjAE1PVbiaJgUlyl+
	gA9m126aYTcFhQZyW1U6Oc9Y30LQbsI=
From: Lance Yang <lance.yang@linux.dev>
To: oleg@redhat.com
Cc: leitao@debian.org,
	catalin.marinas@arm.com,
	akpm@linux-foundation.org,
	lance.yang@linux.dev,
	dave@stgolabs.net,
	cai@lca.pw,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/kmemleak: avoid soft lockup when scanning task stacks
Date: Sat, 13 Jun 2026 19:42:37 +0800
Message-Id: <20260613114237.6463-1-lance.yang@linux.dev>
In-Reply-To: <ai00wD4ICs1nk4zf@redhat.com>
References: <ai00wD4ICs1nk4zf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4E1DC0008
X-Stat-Signature: u4yjegoojm4foih8pf8qqh5oq1bisgjx
X-HE-Tag: 1781350974-977439
X-HE-Meta: U2FsdGVkX18li9r1hCkihR1XiQk4ofumOFAhSOP4it2bBO/TWX+oJ6wXkvdd2DG+xbfF4G8P5NQo2HSnLPqe+DMC6dPtaTdl6kD5y1JWmLNmspy29arf9eCNCHPyVcsHQslrbTJ//CNC23zh78d8cpcd2qFdBL3Gf5o/6NRNAcKHAMGiYx4swwEsa+iFYKKf1cJVllOc+KjwDmY097Ss/Qaqr4L2wsjt+U/VPtpG/DpHH308axAsz3CL/yPOTQc/k2Sb8sd4UHJTbeP3SOlGFtajB7ZptB7i/EakrgQA7SdvcQhWxChh6XcN628pnao61HLyr2bEF04UB49+m9feWlmnmWKiEO+gLwOVBm3tEa+s2E7CaW9sCJuZKgujgZwQoBx4+XmceLi7PRCwBIE9rgS34NDbcIqxGp/Im0NJ3qqOmqZvPEaukSiZlMyFrnl+m0lmGpJ0RNT0KK50jemUk0T4tdvQ7tz1rCzHcUh6+Uqopk7dx/EmyDklhU2g8n7cnYs1j38guze9O/HTx/6rNf1H8/biW5o0qEauigAT0hYarbqxXD2J0ki+TFI27szXDYB+5wLq5Ju5VU+ZP8nXV7XANr21ip/F7EpycKtGAUeVjYOqlkbkQmrNdaa+tZgW1rPcdO79TsCyLeAKlLJbIoKLqj7dFZagie/yBv39KRVwUVp16W6GinqVP7NRm+bMAaT9HzSTBUQ66IE4JfSZ4TMDq67sTvU6IcnHDHVR6DE1GR5bLeR0UXViJn2iYCgmAR4NgrlwVedLJvodMxEGj/Up0+Le6C3j+tvnO3j5zgH/QckjdwOToBx5ygfFvt5pI3/KPEo3+oxGJy5eBN5SBL/3K7EsU1teyhvLJdhvwbJjO9tw8yD0nFC404E8TxoXrwrKnD9DoWesRaLRkZD4WrSvEE+v4YQwgPWKTEdR/wusy9ww7AMC1r+7ihVa0l1SbNW6yTe0CduKyMVb0Bl
 rspx/68X
 1mxCd5vohcKtbZhxJZ97BYnGHwyGuCQpk92x/7iy70P5E/MiYT80KkJYQyAjio1eYkS1bhlYoj1zArZva9ZdJyuQNZ4EMMDzTMYuh9SQaW6T+pURPmRDAzOFWzaSrzKD2oT0ViWUi4iU2xr9XJs+K2/lzrzLHYQw1NBn6shkcJyd3UWZMcyOtyqQfZAVmzY7HyGGp/vCXvOB7qDCJM8krrvqEfGJHqE5FvIq/3NuD2vCqu2lTwHCySWTUQdT3p7e8fBLL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Jun 13, 2026 at 12:45:20PM +0200, Oleg Nesterov wrote:
>To avoid the confusion, I see nothing wrong in this patch, but see
>the question at the end.
>
>On 06/12, Breno Leitao wrote:
>>
>> +/*
>> + * Briefly drop the RCU read lock to reschedule during the task stack scan.
>> + * Both cursors are pinned across the gap; return false if either one was
>> + * unhashed meanwhile, so the caller stops this round instead of walking a
>> + * stale list.
>> + */
>> +static bool kmemleak_stack_scan_break(struct task_struct *g,
>> +				      struct task_struct *p)
>> +{
>> +	bool can_cont;
>> +
>> +	get_task_struct(g);
>> +	get_task_struct(p);
>> +
>> +	rcu_read_unlock();
>> +	cond_resched();
>> +	rcu_read_lock();
>> +
>> +	can_cont = pid_alive(g) && pid_alive(p);
>> +
>> +	put_task_struct(p);
>> +	put_task_struct(g);
>> +
>> +	return can_cont;
>> +}
>
>Perhaps we can rename and export rcu_lock_break() to avoid the duplication...
>
>And, this is slightly off-topic, please ignore, but this reminds me about
>[PATCH 1/2] introduce for_each_process_thread_break() and for_each_process_thread_continue()
>https://lore.kernel.org/all/20180912163335.GA18748@redhat.com/
>
>> @@ -1890,11 +1917,21 @@ static void kmemleak_scan(void)
>>  		rcu_read_lock();
>>  		for_each_process_thread(g, p) {
>>  			void *stack = try_get_task_stack(p);
>> +
>>  			if (stack) {
>>  				scan_block(stack, stack + THREAD_SIZE, NULL);
>>  				put_task_stack(p);
>>  			}
>> +			/*
>> +			 * This is an expensive loop, we must to call the
>> +			 * scheduler to avoid lockups
>> +			 */
>> +			if (need_resched() && !kmemleak_stack_scan_break(g, p)) {
>> +				aborted = true;
>> +				goto unlock;
>
>Can this need_resched() check actually help if CONFIG_PREEMPTION &&
>CONFIG_PREEMPT_RCU ?

Well spotted.

>In this case (lets ignore PREEMPT_DYNAMIC to simplify) rcu_read_lock()
>doesn't disable preemption and cond_resched() is nop, need_resched() is
>(almost) never true. Right?
>
>I guess even in this case it makes sense to not abuse rcu_read_lock()
>"too much", but perhaps we need something more clever than need_resched() ?
>
>Note that check_hung_uninterruptible_tasks() uses time_after()...

Ouch, right, I missed that ...

Would be better trigger the break from time_after(), not need_resched().
need_resched() may not buy much on PREEMPT_RCU ...

So yeah, a time-based check should address your concern, right?

Cheers, Lance

