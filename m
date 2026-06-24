Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFEFCDE004
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2EE76B0088; Wed, 24 Jun 2026 09:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDFF96B0092; Wed, 24 Jun 2026 09:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACEDD6B0096; Wed, 24 Jun 2026 09:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEC66B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:15:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 331608D4CF
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:15:22 +0000 (UTC)
X-FDA: 84914852484.15.EE5C234
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id A7EBC80014
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:15:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kz4Q9rbh;
	spf=pass (imf30.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782306920;
	b=wmRUQyAzfFptGbI3o0hO4XYrfxtW3q1ApgCL0V/rSNNL2Ok0T2CMmhC7Q7KSTaM9G02uMh
	i3xtNfjrxGF/zpCQb4deQWuF7X4xWLbRQnd+jCR1rw7TdCUemfRWNn3KF4WWRDJgV3ECXH
	nmYKSmiG2XxIWy4gJt/RLRvQx5to9qA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782306920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jm5h4EGMu1/G65UxgDlhva2Uqze8a2QIkXsB3xVvPew=;
	b=NWcXry6v1Ozsyp6Or67p6gKp0dUpgggNv/NC0jnnLJdhmOVvT4/mG2/Znr5JauC/+SvQAR
	pXZEhugEJdg8IxCg1NbMhb7ygMOv4YCOUNJq39GQ/59kd9qwoiA/DBspxX0+7XaR8GeZFn
	t61DuJhqI2dqk2hWIgkIh63ridn3x70=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kz4Q9rbh;
	spf=pass (imf30.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782306914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jm5h4EGMu1/G65UxgDlhva2Uqze8a2QIkXsB3xVvPew=;
	b=Kz4Q9rbh7etgj8euhlBLWO3TzYATCTCfu6njur0dxfGVJdMqB9UP/InGWtI0bOGTstOlHl
	POIMRyO3mRJBT5/BeQDQV44BuugXQiS1AZGuvJ0EWei9+7fme1gtEeTZSwt1IwIDM7n5ZK
	H6199we71vGASxf1nAZQvllBRzYOKVU=
Date: Wed, 24 Jun 2026 21:14:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Howells <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>,
 Randy Dunlap <rdunlap@infradead.org>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
 <20260622094242.64531b9a@pumpkin>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260622094242.64531b9a@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A7EBC80014
X-Stat-Signature: pa9n5qjpxoh4hrh8wsbr3zdz9u8rsthd
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782306918-629974
X-HE-Meta: U2FsdGVkX18vK4nd3NsRuKEqYvoDodBebDgTs6YKqBMkts3C6f4WGBvQyQIa0epwfxpy17guimZcONcs0FNDHD6TSnCeLDQD3MAoL51b4km6mgN7Re/F+dM2hJwn8J3XrMLurWrDWKLqikaIsfAwkO1ukR60KO1SV3f8fmMHQf8w1T3Bj6FqjM7qeSUZinXH0rIBEV7cEBEG1zOkZsOnLGhIFOptDJWuZMMbLCRRdpAZDFSNjs5CB1iqyojfLPN2LJmYQqt7p5egvtFTrj0soaXfvp0b2m5cdYAWvABcoevUMWGof+0DTUOblUPk768EPZIdEdZb8pPIpR5tyDR8AlXAt5nAjvXGKypHaCj/KUZGis6UkXgA3uKorB2f4HLeZKDiNiSjYJ0JM5y6JHaI6niU1sizxWP0Im9RrT9l4RRUE2wA9OBKF77LsdDZRAZR0OKVlnGnK9PsNbpjKfNVBB83GnIHuI+Q/1pF99k5Gc4VjlB38dcsLO4sok68I1Eo/70NsD1Xm3bTv6hM0uPd1gZ4cr7QlC+MMyNFlnpmJQ2Le/jlMiNmZQr2QUd8+iIf3dh8op2Vz6SCbvYMjxOsXQOQLMvTMUH8yLlzDmhP4/pONkCoYDVkPt7IbfUHKagzGPllhCDz6sJ/SXfTQ9CfjuNYArF6Pq7n+x5n7wfTtT+VLynravUfDzi8bbJJazOo6ICFq2tYO6II6sgLpflEx+2FZu847yuZIHwFbrHMWV+eli9elCsQrkJh5S1qJQmOXFICqQozUj574zPWMgrrMllnknPdwwQ6fcsVYrGXnn74BhPyGNSXAjCkWXWyMR8lvEWyqtKPDPpRY0WEW0hY/9K6pEThSZxS0GvRvC08WiwKDNm/wXh2bpe0XVy4SE9UUvk91Hxv6bgTuE+tHgfFGaXgknKVlkaJFdHSfcRt07hMCqm7FaS5kfGtFtTw+6KGdF8wd0NOCg1r53TBq0l
 0EXWajPa
 gRgSd06ub5xdzJxD6YoiTYNPE07g2WRp7f+44OJhJqNF13Hfqitv4gJqVO0McQpMopY0AcgcSnR+Z5eBERrXgzzcZpIU7viy/C/znqO4yqdX/tqvB+JPzonQCKGnilJZpTsrSHChXe7KgWU6HJnhSl1kyQ9K22hK2bGFNIEGcQ8i3b7S27DoN/eN4JcSwnhBZSqKBERbTB+95Wo106X1xmsC2R3ygZeTvg/gwQFrR/0uPshsNlMynh/fXU4C/AAjwX29vZEEcJCD2mCPdDs/5Sz4yJSJk+Ci+uYNL3aURVyVDZgIblYfpbk4WlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/22 16:42, David Laight 写道:
> On Mon, 22 Jun 2026 12:05:31 +0800
> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> The list_for_each*_safe() helpers are used when the loop body may
>> remove the current entry.  Their API exposes the temporary cursor at
>> every call site, even though most users only need it for the iterator
>> implementation and never reference it in the loop body.
>>
>> Add *_mutable() variants for list and hlist iteration.  The new helpers
>> support both forms: callers may keep passing an explicit temporary cursor
>> when they need to inspect or reset it, or omit it and let the helper use
>> a unique internal cursor.
> 
> I'm not really sure 'mutable' means anything either.
> It is possible to make it valid for the loop body (or even other threads)
> to delete arbitrary list items - but that needs significant extra overheads.
> 
> It might be worth doing something that doesn't need the extra variable,
> but there is little point doing all the churn just to rename things.
> 
>>
>> This makes call sites that only mutate the list through the current entry
>> less noisy, while keeping the existing *_safe() helpers available for
>> compatibility.
>>
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>> ---
>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 231 insertions(+), 38 deletions(-)
>>
>> diff --git a/include/linux/list.h b/include/linux/list.h
>> index 09d979976b3b..1081def7cea9 100644
>> --- a/include/linux/list.h
>> +++ b/include/linux/list.h
>> @@ -7,6 +7,7 @@
>>  #include <linux/stddef.h>
>>  #include <linux/poison.h>
>>  #include <linux/const.h>
>> +#include <linux/args.h>
>>  
>>  #include <asm/barrier.h>
>>  
>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>>  #define list_for_each_prev(pos, head) \
>>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>>  
>> -/**
>> - * list_for_each_safe - iterate over a list safe against removal of list entry
>> - * @pos:	the &struct list_head to use as a loop cursor.
>> - * @n:		another &struct list_head to use as temporary storage
>> - * @head:	the head for your list.
>> +/*
>> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>>   */
>>  #define list_for_each_safe(pos, n, head) \
>>  	for (pos = (head)->next, n = pos->next; \
>>  	     !list_is_head(pos, (head)); \
>>  	     pos = n, n = pos->next)
>>  
>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
>> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\
> 
> Use auto
> 
>> +	     !list_is_head(pos, (head));				\
>> +	     pos = tmp, tmp = pos->next)
>> +
>> +#define __list_for_each_mutable1(pos, head)				\
>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
>> +
>> +#define __list_for_each_mutable2(pos, next, head)			\
>> +	list_for_each_safe(pos, next, head)
>> +
>>  /**
>> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
>> + * list_for_each_mutable - iterate over a list safe against entry removal
>>   * @pos:	the &struct list_head to use as a loop cursor.
>> - * @n:		another &struct list_head to use as temporary storage
>> - * @head:	the head for your list.
>> + * @...:	either (head) or (next, head)
>> + *
>> + * next:	another &struct list_head to use as optional temporary storage.
>> + *		The temporary cursor is internal unless explicitly supplied by
>> + *		the caller.
>> + * head:	the head for your list.
>> + */
>> +#define list_for_each_mutable(pos, ...)					\
>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
>> +		(pos, __VA_ARGS__)
> 
> The variable argument count logic really just slows down compilation.
> Maybe there aren't enough copies of this code to make that significant.
> But just because you can do it doesn't mean it is a gooD idea.
> I'm also not sure it really adds anything to the readability.
> 
> And, it you are going to make the middle argument optional there is
> no need to change the macro name.

Christian König and Jani Nikula also disagree with the variadic-argument
implementation approach. If we abandon that method, it means we will
inevitably need to add some new macros. If mutable is not a good name,
suggestions for better alternatives would be welcome; coming up with a
suitable name is indeed rather tricky.

-- 
Thanks
Kaitao Cheng


