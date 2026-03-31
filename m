Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF42C109B46D
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43D2A6B0095; Tue, 31 Mar 2026 10:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415376B0096; Tue, 31 Mar 2026 10:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351E16B0098; Tue, 31 Mar 2026 10:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 295F06B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:11:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB841E0261
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:11:55 +0000 (UTC)
X-FDA: 84606546990.13.B00B7A3
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id CAB7520009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:11:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jeSL2mHH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774966314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdPxN9QaNf36x/V2Ie3LXQAiv3fTO3U7y0mPTWEOTDE=;
	b=UxoYLfiAQ3KLCRl9EvcPHKj09AeZB87+PReshx55eYOB0xqphRgeuzBWrjTKF6hkoSeobL
	TOGPpAxoEv+6wT8N8+CiJYwxCwtKy6KXuIPwvAWPNndR3Y0NXwIYo18TWJfSP7iDc+LPJo
	XVobItMPrNHn4shmKpKVnmOcJjVi0Bc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774966314; a=rsa-sha256;
	cv=none;
	b=u/wN2uYNFaOD/XbYBpMSOs25a3TOChXPxza/W0xYTlG2bMKHg/QdSGQktwn+P0O1jat0iF
	EJvmqa9ZtS4nFg8DPtRjrs2tuz2RJhDD63vCVtCt0jC5GSXtnx0RJXXuVBRptEe2M1qOjS
	AMWrg0JS3E0T7HtVGsaba85eCYMIaPU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jeSL2mHH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
Message-ID: <157dc048-4b2f-4170-b9ed-a72f5599e460@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774966309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TdPxN9QaNf36x/V2Ie3LXQAiv3fTO3U7y0mPTWEOTDE=;
	b=jeSL2mHHnGMx63cxD4zvGwxlACLsVsl7hBb6An0yUyWU4Keh1E51CS0u318GzzMGMiEsRG
	uYkNEF5p9F59Ki2EdLT+y7fWRrnDmJjgI3VFCB+QP786AS6D1cxHmuDUvO9KE9wZof7vPe
	8vNKYD8P0hSJBsNkzW8Q2/LDRkXOY6E=
Date: Tue, 31 Mar 2026 15:11:15 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 3/5] locking: Add contended_release tracepoint to
 sleepable locks
Content-Language: en-GB
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Waiman Long <longman@redhat.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Thomas Gleixner <tglx@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
 virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
References: <d2e5763278812499335b22a013aafb4979e3324b.1774536681.git.d@ilvokhin.com>
 <20260331103451.1070175-1-usama.arif@linux.dev>
 <acu7LdegiZ5_-dEW@shell.ilvokhin.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <acu7LdegiZ5_-dEW@shell.ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CAB7520009
X-Stat-Signature: 1pijy8pmtngejz3acjx67ag5srzzbn1t
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774966313-699199
X-HE-Meta: U2FsdGVkX18EEZkLGODuG1ekMP+jzAsuEnoLYMG/TU9ZMmx44lZ1Y2Zh++UWxjWPANHjpGNBDvQrNGabYqN5oCPlERs4TU9hYSMeeecWX5OZDguliRFoWUJnQroLNExoYvpHQ1tXsphwDcOi7kf4aWCGgwl7TUrjMBCAkBwf5PR3Mq90Z63wQKoufW7mCh1FmzNxPyE0Wuv9peGNSfJmaWHfV9M0PYXJdlHQSSAQAbtu/pSanfvMhjN4Ve68yaxRiq0YrIqbngPPWQDNpHnKWvqc3cLnB+fcZtXr85keb2507mWvvrDLoEhGSFnMcdJf3IAnH8LsMV0Q/ehH9zbRdMYVrbKKm6hqYGzBiGROT6Cy6ZBjtlit8yPFfyJfFHLzbPh/EW96RPz0eO2ev4NVqrsGk8TfU2Bf0BeWTq7p3YYTp5J76TcTfSEDJoxG4Le6PUpK1OSAPsMkDk2tds/KWv+IjHZh655QWjWv7N6ui7mkS7NEXQqoLAZxqBb8G8uQTDVIsX5RAKq7TlEvpnZ70L2C7ud9+F3MDFt7yU9pS8Cp8pL/ZPbPMFAg0NCz1E5c31Kfy8OojN0a/AG5U28/tGSGdMJ6suqPtrsu0Kp4m7iMYTQt3BzHS14bWNqlYTfYfGMlIcqODjkVfTaxo6zCs4i3sosooVXNQ1aUKjKOfRwUrV8M7z0CTQW35HbyWEamAqw4S1Cow7wncTRdmYplTAPiFYd4yy/f7I69c3f7+z4yuDkXxeXX4JCcilKFNiyIfsbtCIVLn8qbWvnuBOv9DKpyXptPDdiQzoJ7S+DfTDkUuNkyuQBC38w9FqzHfR1VdXc6dj6REdAhfKJxfp9tndvukO15bfPsKt9gbCfSADdGxSpFb5YhytpSvZL1U2r73vw04t2/EUgyU8y+94UFG7DeUkH/cm/st11DSw0PM4w3l78azCeuuTYfcU7e0V7ErqZL7ybrSoi7SczuBOQ
 g8VDZSRu
 ZVZ6CY0PMzetWE7Uk1vYlmDZgfQ3X48698RjcR6Fgc0+Rngimi0m9Vq09lWJ9KqlFUZCPp9jzHIKUktfQlCMYUV3hsZUnrvaYb0OpgEN89pgWk2mCNTm9KHkrXkPv56A5zcUzx2t6HQtQoecW45mlUsCypRuUIZsZ8W5iQ5UHWcZazp+HX514vrYFZJerlDiefoSpLuA9N+7UIjCuNzbOj+Oe7umyPFzOJHytMEOQ7VJEyxzc2bXVAOwkGwhDjpPiebAM0FpG1QAhSASiZWRd4vNI4GLLoKdZqP6muRUEdlCVsAK2WvbMxKKVrMXQDCrVQw8x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 31/03/2026 15:16, Dmitry Ilvokhin wrote:
> On Tue, Mar 31, 2026 at 03:34:50AM -0700, Usama Arif wrote:
>> On Thu, 26 Mar 2026 15:10:02 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
>>
>>> Add the contended_release trace event. This tracepoint fires on the
>>> holder side when a contended lock is released, complementing the
>>> existing contention_begin/contention_end tracepoints which fire on the
>>> waiter side.
>>>
>>> This enables correlating lock hold time under contention with waiter
>>> events by lock address.
>>>
>>> Add trace_contended_release() calls to the slowpath unlock paths of
>>> sleepable locks: mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and
>>> RT-specific rwbase locks.
>>>
>>> Where possible, trace_contended_release() fires before the lock is
>>> released and before the waiter is woken. For some lock types, the
>>> tracepoint fires after the release but before the wake. Making the
>>> placement consistent across all lock types is not worth the added
>>> complexity.
>>>
>>> For reader/writer locks, the tracepoint fires for every reader releasing
>>> while a writer is waiting, not only for the last reader.
>>>
>>> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
>>> ---
>>>  include/trace/events/lock.h   | 17 +++++++++++++++++
>>>  kernel/locking/mutex.c        |  4 ++++
>>>  kernel/locking/percpu-rwsem.c | 11 +++++++++++
>>>  kernel/locking/rtmutex.c      |  1 +
>>>  kernel/locking/rwbase_rt.c    |  6 ++++++
>>>  kernel/locking/rwsem.c        | 10 ++++++++--
>>>  kernel/locking/semaphore.c    |  4 ++++
>>>  7 files changed, 51 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
>>> index da978f2afb45..1ded869cd619 100644
>>> --- a/include/trace/events/lock.h
>>> +++ b/include/trace/events/lock.h
>>> @@ -137,6 +137,23 @@ TRACE_EVENT(contention_end,
>>>  	TP_printk("%p (ret=%d)", __entry->lock_addr, __entry->ret)
>>>  );
>>>  
>>> +TRACE_EVENT(contended_release,
>>> +
>>> +	TP_PROTO(void *lock),
>>> +
>>> +	TP_ARGS(lock),
>>> +
>>> +	TP_STRUCT__entry(
>>> +		__field(void *, lock_addr)
>>> +	),
>>> +
>>> +	TP_fast_assign(
>>> +		__entry->lock_addr = lock;
>>> +	),
>>> +
>>> +	TP_printk("%p", __entry->lock_addr)
>>> +);
>>> +
>>>  #endif /* _TRACE_LOCK_H */
>>>  
>>>  /* This part must be outside protection */
>>> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
>>> index 427187ff02db..6c2c9312eb8f 100644
>>> --- a/kernel/locking/mutex.c
>>> +++ b/kernel/locking/mutex.c
>>> @@ -997,6 +997,9 @@ static noinline void __sched __mutex_unlock_slowpath(struct mutex *lock, unsigne
>>>  		wake_q_add(&wake_q, next);
>>>  	}
>>>  
>>> +	if (trace_contended_release_enabled() && waiter)
>>> +		trace_contended_release(lock);
>>> +
>>
>> This won't compile? waiter is declared in the if block, so you are using
>> it outside scope here.
>>
> 
> Thanks for the feedback, Usama.
> 
> waiter is declared at function scope, right on top. It's also assigned
> before the if block, so it's still in scope at the tracepoint.

Ah ok, I was reviewing on top of mm-new branch from today where waiter
is declared in the if block. Probably something changed related to
locking/tracing and its not in mm-new yet.

