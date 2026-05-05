Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7552CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FC06B00BA; Tue,  5 May 2026 12:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177B96B00BF; Tue,  5 May 2026 12:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EBD6B00C2; Tue,  5 May 2026 12:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFDD36B00BA
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:39:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D8FD8C0A8
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:39:11 +0000 (UTC)
X-FDA: 84733926102.05.1EC7297
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf20.hostedemail.com (Postfix) with ESMTP id 878F61C0016
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:39:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="D//5sGnt";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777999149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9c/IGueTjCHjwvEorexWJZjMn/GRqmNG90TxSRVBoGM=;
	b=cYtUmkSaCa4m/lGQNN9yh7mk3meQuQ7L8BjMLCTLkKQKzq0YdcfVJA9BrY4XEPqkWDRTNQ
	GvmD/RHmj1ZZkE+9TQif9CD6FG33rak20KNZlGHSvNEdQGBHL9HHswZjmoUg04Ui38GuhK
	oSnuuDz3KLJhot4V6mBtmnZAIl7YcjI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777999149; a=rsa-sha256;
	cv=none;
	b=LlL70WCHNXI1Jbvc8mtHRQUq7f1rHIJC2ZGMX2ZF1d5DuvljrLy7cS7dQvKEK8YWjLuZ8p
	eZ93u86RnXvcjlnHSbfVwr1xAooun/cZqlM5XmRl8mdAE1J+6XTq5odW+BULopsnMm1FMv
	BLLjZ5IGcUDiqnobSMR4XFtamXAEfNo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="D//5sGnt";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777999149; x=1809535149;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P6B5HiyOYxcnv0VrBRyjz8U5Qy44miPk0JKbh86JJyU=;
  b=D//5sGntNE4TcWyO58jP+zbKMo9oZnrROjdor8cGRnXEJ3NGZuQOV3k/
   mDQMjkv+rdtavOax5TUaDVZTUPlfoBnqn3zid1Su/AJt1SphsO3VFhSkM
   S+ZBL0i4WIiBylkjZDEVfKHmQLx+4qnEvY0oEVQDkHMiXpLBx9w7lKTqQ
   oswrYLsNzvmk2o0sL1bF45LeO/jG3H8XQKQldjvp838hgoyv4sWwhu830
   QzHzenzR3aL/11hT77XQxcLMpG04G/Rcu2Z0xW3HsLc0wm/e7hrW5nEsA
   gxi6j6VRsOz827Jm18P99t6IyvklMI3lAgEj+ltUSSgnuH1rnanmrIw0k
   A==;
X-CSE-ConnectionGUID: Nq2y3GPzTpCwTetMjA3l+w==
X-CSE-MsgGUID: fTKQ+a3IRDO1p5edAuxCGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="101544190"
X-IronPort-AV: E=Sophos;i="6.23,217,1770624000"; 
   d="scan'208";a="101544190"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 09:39:07 -0700
X-CSE-ConnectionGUID: zM7lKNCuSY2PAn++OaK1yw==
X-CSE-MsgGUID: EjEMenP6Ri62q/VYCWrCQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,217,1770624000"; 
   d="scan'208";a="237639686"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.95]) ([10.125.110.95])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 09:39:06 -0700
Message-ID: <7a82a652-f861-4d72-8bd7-4e082af482f2@intel.com>
Date: Tue, 5 May 2026 09:39:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast
 path
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "ljs@kernel.org"
 <ljs@kernel.org>, "surenb@google.com" <surenb@google.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182005.00BF70D8@davehans-spike.ostc.intel.com>
 <a46738ebd632ff046bc9b0d02a5382de5f2e9f2e.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <a46738ebd632ff046bc9b0d02a5382de5f2e9f2e.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 878F61C0016
X-Stat-Signature: o11apnh75r9b61ay7jdm87d6m36bsa1q
X-Rspam-User: 
X-HE-Tag: 1777999148-765946
X-HE-Meta: U2FsdGVkX18wl5FA22vHoJG5N11I+T6O/Ul8JOF7aO/78b1yrakI806T02bYRZz3jIQeu5c7Y2veT1Rkk9yWruT2dR4oWVBqFgJdk5z06pLTB3qSL+26gBHixIEwviEMBRYbWBAjaKjmr5bLQPi1YJMos/eaBtM4VxVyVROYs/NsADLEOuZAZj239KhxYn6VQ3e+lop4QrfEKa7uJlhvCVlEKdh+1I998T2MQUF24xehE8O/tmf7Qu1fJ76rxIIqALvFEvOLWNf5+sOu06QQJvpOczQ7OFeO3pN7VAqRXOXrIpJwe9sMMAtHHingc9cFF+FUXO0rl/iZ/U1Ut4+GeWzBQX01SESiZvxPRbtbL4j7hS3PHkcNAhxNStglKM/wi+yu7UQXcIbgZDFxXg7MbHBE57SuLB4geRvgYM5j4iguLj4bQBYWO1uW896ba2ozVMB8CGcD5667lyKpFRDnBEMtZIkGZcHmGmuYjTCZzy4M8DG1lDzvtCrz50G4l0x8n73Jw5Gi5tSMqTh8NeReUWiR4Rf+m1WUmnJwEIcZPumY2zDK4uAlcUDrtbqdq3tV4wGfrug9Xy2NG/7/XpLZZK9ovfBlnfW7WYph99coxqLfYc2jJvXdDjs6nklgVxwqjYZTmnoaKiQzochCabExFufZUFYhFYUgP9kM93UkBw6gPhSw8UgyGP1kuC8k1vt1BOTOeYPXoUpUdjgRrwVVghJr7b5ZZigg6VMvDPxHcTaIXjW1xDuBHH3PcfkRSurqAtTW4y4EkswzXatJaDa7WcLgk2fIXq7GF1wzEQ26RzyVcx4T3sqew1Rv5LVq1spgIcR0wj21EuxogwMZbkTw5OuwT2G9NwXFs+yRdCCDjudqnCxdj2Z8/eupysY5T6QUwOZzZCxDir/Is6FWWgrgBKtWQU05brihOGA6TUfbgCREGf19jwFuEoDOEMKABJJBQCWF+XiZWJ6UJ8i/i7k
 RxwkGdVv
 csqQV1e09U8PPDTGDQJy8i7dI94uBJy3Yq5LjdKlEiz5zCJQWba7uc0fixzY8SwzPKeV5ULjUTHhl08LkufBob/XInawm4rWhRLOuRcI0u1mkcs59zuJAb55a4xvGzytKce8skXr/o9q9pksPaYrZgdEfv50DTrieZT/H/gAgiPP5kByElpJE5nwQWsjVbiTc97wRsxyNrXtGTQPskdn6dHDcYoiZp0XlzMcVgeYIpz11HgvC3URY/Hvq6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/4/26 16:15, Edgecombe, Rick P wrote:
> 
> I guess the problem is the lock ordering. Not sure if there is any slow path
> avoidance details that could make this splat a false positive. But how about
> this simpler munmap() case:
> 
> Shadow stack signal                          munmap()
> -------------------                          --------
> vma_start_read() (VM_SHADOW_STACK check)
>                                              mmap_write_lock()
> mmap_read_lock() (user fault) <- deadlock
>                                              vma_start_write() <-deadlock

It's a little more complicated than that in practice, but I think you're
right.

I'm not sure when this would happen in practice because the fault is
actually on the VMA that's being held for read. So I think another
writer would have had to sneak in there and zap the VMA.

The funny thing is that the fault handler is really just trying to find
the VMA. The thing causing the fault *has* the VMA. So it's as simple as
just passing the VMA down into the fault handler, right? How hard could
it be? ;)

There are still games to play, but they all involve dropping locks and
retrying, like:

retry:
	vma = lock_vma_under_rcu()
	// muck with VMA
	pagefault_disable() // avoid deadlock
	ret = copy_from_user()
	pagefault_enable()
	vma_end_read();

	if (!ret)
		return SUCCESS;

	mmap_read_lock()
	vma = vma_lookup()
	mmap_read_unlock() // avoid deadlock before touching userspace
	// check for valid VMA to avoid looping when there is no VMA
	if (!vma)
		return -ERRNO;

	// uh oh, slow path, something faulted
	get_user_pages()??
	//or
	copy_from_user() without the VMA??

	goto retry;


This also needs some very careful thought, but something like this
should work, where we avoid fault handling (and lock taking) in the
actual #PF and do it in a context where the VMA lock is held:

	vma = lock_vma_under_rcu();
	pagefault_disable() // avoid deadlock

	while (1) {
		ret = copy_from_user()
		if (!ret)
			break;
		handle_mm_fault(vma, address, FAULT_FLAG_VMA_LOCK...);
	};

	pagefault_enable()
	vma_end_read();

That's effectively just short-circuiting the #PF code which does the:

        vma = lock_vma_under_rcu(mm, address);
	...
        fault = handle_mm_fault(vma, address, ... FAULT_FLAG_VMA_LOCK)

sequence _itself_.

