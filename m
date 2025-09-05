Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF55FCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 22:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FE08E0010; Fri,  5 Sep 2025 18:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101348E0001; Fri,  5 Sep 2025 18:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03DEA8E0010; Fri,  5 Sep 2025 18:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E87D98E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:44:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8530C1602FD
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:44:38 +0000 (UTC)
X-FDA: 83856677436.20.6DCB549
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A6821C000F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:44:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D11SbykN;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757112277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEvTf0gu2uvX4iNptGPGuSQc3Jmjp1dV6o5P5PehWGU=;
	b=UdNvyad6TNlOk7sPYetjx6wxYsdyKxqlaJKdHAE7wrHyQnoEl5O4Ipbf9jrkb6GW3fB5ao
	0Nu6RDwhsCL2ECZUlKF+DM8HKA/0ZuraauS18MMHN8QtQw7HU2Il30P3mKfkeOHiIcaqyN
	w6bldOibOzxVRyM5dcS9Da1f4rrwSBA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D11SbykN;
	spf=pass (imf20.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757112277; a=rsa-sha256;
	cv=none;
	b=CV9ZDF6XxjhundEP9vpfmpp8Pkbge54Oq5zNMpoTyPvHeCGlaodqamjM/gqq6xL/gh96iG
	QnHQPBer/q8Rl5L581RbCW1d168LKWOIf5EoqHHxwrPc961YW0QYdWdHBPgvrEYNYMLq34
	XIwha1ibBMFrwpziuJ68srk9NFn9ax4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757112274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IEvTf0gu2uvX4iNptGPGuSQc3Jmjp1dV6o5P5PehWGU=;
	b=D11SbykNSIElurYGwH8imcgAOpuoUqmYxP+VrnGYqNwwXfriFXq2dx3BkVqnX9Rvg0B+82
	hnSm4wVK2Zit7mfTkJ54avRQbmsT6cHrZRK6Z8tn1mLUC+8OndYp4Q2VLeJ/IqgrZCj3ze
	BjbZntUKHiduelcTWnahlGLb4HT2xAY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Tejun Heo <tj@kernel.org>,
  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,
  Muchun Song <muchun.song@linux.dev>,  Alexei Starovoitov
 <ast@kernel.org>,  Peilin Ye <yepeilin@google.com>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  bpf@vger.kernel.org,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  linux-kernel@vger.kernel.org,  Meta kernel team
 <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
In-Reply-To: <6bcjnhdsbyfmlua2x7olz6w3gheejfatnrtn5qu7ls5svegrok@zeatti7whrnq>
	(Shakeel Butt's message of "Fri, 5 Sep 2025 14:50:17 -0700")
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
	<87y0qsa95d.fsf@linux.dev>
	<mai3ndkvqrpkfpblkazbyejvpkizrp7dh22374tpkmepfji32o@3troawzsuvqe>
	<87ecska85y.fsf@linux.dev>
	<6bcjnhdsbyfmlua2x7olz6w3gheejfatnrtn5qu7ls5svegrok@zeatti7whrnq>
Date: Fri, 05 Sep 2025 15:44:28 -0700
Message-ID: <87cy848qpf.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 713gjpets4e1w8bgbghp8acgiowdymj5
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A6821C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1757112276-896606
X-HE-Meta: U2FsdGVkX1/xeTxmjovb+QMjrNstvCxSt7XCpSx/EURcTb33jThDgLaPEPEGlkoZjblc9RvY3FlBvn90ZcRyx8VyO3AmTPqbDJWH2ZQQSz4LdfOFjqkcye6aT0atC4Q/DyZAkmyy8wk2eMhsnbrdKqDEzwE1JT5UfUygpNSlHaszroCcy3eOw5bwYXV0ktqR6zc85CfPOcfRx8+AO4NlanABwWjKEBTZN75l2M4kcHIuyDtqZ25fvGCpKcuutbBq09shj8Ab83mvHcLpddLwlb3VTAlT61ShfG6dEd7q07j5qhI/q9rpmSF2AZ/foW64ntTALU7yXau4K8k9h9w1u5k1atezxIUbCTi07UmAEAYYbJKW8CkwzOkMm6IS8dA9eWde8iCR6VGBS9vRzQnv83bX1Ruvc4Jf0i1FSPTfUKX6Sy2T0o5IwdcGaKWVfenzdJ+Fq8jropjfQ757Lh6DLf0odFcgzKf5WZt3WRDQxgYlzL0A1+Zk6xqgL9RhJbfQIJqoFyNOKCeEKbUf7rLULGkOU2M2aACEuwGjAsiRd0X3oKiXquJbxSKy0vQiLbExBZQDB+YEvufeqK7I/Dfe5D4lsHnMiANX/yzoeS2z7ychH8T4bycCk6GgPHYTamdrPd+B6jDnB++srNxwQhEzhVRGQFWyhrPLcgizaTlKgUOzxH0nQ1I4RElXRn7XMMBNd0q3PC5l9CYHrtfzqgAd2mQMuYRgx3hDhUFbNb0RGcguxLi12+Dyo/P00Dkdddc1NkYtPl5mVhlHDOYtObryeaqhK0Gq0KXQiVkJCBVF3urMcoZsGUOu1h5VdOj/izv+AVhwlAcYcUjwRKI/kaL85LBgNX42VTgesV2QhEQPWc26/49tRq1IMh2+zrkulnLXqo3PhSYRit1nn6wsq7pj1QGJH05LMIzyc105bMtedZd7JrB+BjyQGei7TzPD7DjQkfgm0QNEtaUefGeCAG+
 AsK6vLaH
 Ym5oLykhMDovQu8s5s+w3XF+OIDKAhZ4s9zaI26UBddQlxf5mzM2dzebbZ274cfgfisFyrfatgrzV0mj+ua1W09hxG3dilQCOxA8Uq71/C9eemRXNIyuKyKgSorH0CP1XLVMQJt/vWvItdBprCIKRcwdJNubY7NlgtFhYTuIS7Z5HNNA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Fri, Sep 05, 2025 at 02:42:01PM -0700, Roman Gushchin wrote:
>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>> 
>> > On Fri, Sep 05, 2025 at 02:20:46PM -0700, Roman Gushchin wrote:
>> >> Shakeel Butt <shakeel.butt@linux.dev> writes:
>> >> 
>> >> > Generally memcg charging is allowed from all the contexts including NMI
>> >> > where even spinning on spinlock can cause locking issues. However one
>> >> > call chain was missed during the addition of memcg charging from any
>> >> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
>> >> > cgroup_file_notify().
>> >> >
>> >> > The possible function call tree under cgroup_file_notify() can acquire
>> >> > many different spin locks in spinning mode. Some of them are
>> >> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
>> >> > just skip cgroup_file_notify() from memcg charging if the context does
>> >> > not allow spinning.
>> >> 
>> >> Hmm, what about OOM events? Losing something like MEMCG_LOW doesn't look
>> >> like a bit deal, but OOM events can be way more important.
>> >> 
>> >> Should we instead preserve the event (e.g. as a pending_event_mask) and
>> >> raise it on the next occasion / from a different context?
>> >>
>> >
>> > Thanks for the review. For now only MAX can happen in non-spinning
>> > context. All others only happen in process context. Maybe with BPF OOM,
>> > OOM might be possible in a different context (is that what you are
>> > thinking?). I think we can add the complexity of preserving the event
>> > when the actual need arise.
>> 
>> No, I haven't thought about any particular use case, just a bit
>> worried about silently dropping some events. It might be not an issue
>> now, but might be easy to miss a moment when it becomes a problem.
>> 
>
> Only the notification can be dropped and not the event (i.e. we are
> still incrementing the counters). Also for MAX only but I got your
> point.
>
>> So in my opinion using some delayed delivery mechanism is better
>> than just dropping these events.
>
> Let me see how doing this irq_work looks like and will update here.

Thanks!

If it won't work out for some reason, maybe at least explicitly
narrow it down to the MEMCG_MAX events.

