Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E0A5FEC0FC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 20:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4156B0005; Tue, 24 Mar 2026 16:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93EE6B0088; Tue, 24 Mar 2026 16:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83436B008A; Tue, 24 Mar 2026 16:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B71366B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:27:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 495128B5EF
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:27:49 +0000 (UTC)
X-FDA: 84582092658.01.BC0C51E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 88DCE4000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:27:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tkwmaolM;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774384067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIanc33mIDz4/YWXRQfeRy03fhrw31RfEP/FudNjYl0=;
	b=jPOc0Zf4RNQ3WKF/wQA4rJK8Qc6Df0nDub029zIOPFqle7A3dXfyaN3Yu5R9fQ1F0OtAto
	qIA3o4uJUC6MmXqhItzrh6z/dTTjfyTPF/Q2U+cd/wbd/J6DirHh8dpkCf8Fl9KWggi+05
	aepaE7GUB4uFvEjz3tMNSBmR5q10Pwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774384067; a=rsa-sha256;
	cv=none;
	b=WE6ooKHEI2A7YjtmRDj3MJHogPFWtQn9BA+S3MKNjTDQIxO4GeeZJOHXrxMnD4guY6oCDx
	DViF8jXf7FpQw/6x337m+eVvk95bHXbJywy0XHQtYL1yWDEazHjhySMzc/NPfKJjAK4We8
	b5tcvvrJU1M/Qi0QeFQ2aSsAXz8VT4c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tkwmaolM;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E702C600C4;
	Tue, 24 Mar 2026 20:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0609BC19424;
	Tue, 24 Mar 2026 20:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774384066;
	bh=QYur7Dv8WJxmAgSoBv4zjaYWDEVeNHgsWt11GCwm4lo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tkwmaolMO6Smi8QfPL2eV1DH5OXUIhh76k921z1DiLZrwKQg8IZ1OORGtzqILnGJs
	 2+jzV9estLVZwrA+TpdVsV2gJBeuddCd6tknHo1jDhAxIaIS2oZuZfH6iyuPsMMTGi
	 S9s5esTkROseLcwFOBhBhY7KQyj01j7rgScuMc4AFQKibjzslI6MkXDkC+3l1FS0D3
	 J4tlV5LNMeoa3PElCco3adr5IB/cVMNGz/kBntHS5lDoe67bYDh4w5skce/JOgtzVp
	 pPJ5HWr5fIlD4yOIxcOQDQnwTYOQM0ObkkS1GbWi8rDuNjav9Lba15xT8aRSw27ygl
	 x9Q/HaXx3k05A==
Message-ID: <c892e7ce-473d-41e5-aa99-b95e0366c3fd@kernel.org>
Date: Tue, 24 Mar 2026 21:27:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
To: Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, mingo@redhat.com,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20260313124756.52461-1-naup96721@gmail.com> <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx>
 <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 34yexrnjcexuup6q8f1aagseiqne8beh
X-Rspamd-Queue-Id: 88DCE4000D
X-Rspam-User: 
X-HE-Tag: 1774384067-39198
X-HE-Meta: U2FsdGVkX19ov8s9szW1KQ2+MONtU/34eKqHpfXzWIgyxTk5R4mJrJ5bW/KWUbMYwPFjjWICvu/xiG40iSkWG68sHC32zSEBBLP6NnGtkJoVLvQKI9VQ7i4T2Xw84l4nrcbDZ7aEOISimpVeJR81FIO6cClXWpvjTf6HwnN016MhO1W+sjqte0l3Rnylvj3r5dLpt59XdgHUTGlwfl10LR40yHasU8s2R+FtA+J81qhx3JBFmIBW/NLwvi2xyHdBDih/y/w7Eb3PVP5kr7xl4+FUPiRKxWPQykO8HKt/fxajVGMPwLugEglTdCSvPhvdT9QiFg7PxIftmpMBeOCOcJs189SIq09bbhyifg5INd8dj4L64jX/EK+SP418v2VOp3nH4XFycZZfYfz7/pkd4AvAhCqVrLnlVsVTeMr9x2vJbhp8afZJtR3BQzzKAO2+LRY+ziPyaUu7LKCopG4p6HcIUDkAQ6pjZuc12ZX6m9yIgJnACatTRO6rtAj6/WbnGtTso5RP1yiRyy0jysBZ/5a+OUznPHmcZKv/YiInRI5qGov4z3P+AaSeYZJnSkqqhLH2HYsCbf83Jtfs0MHds8bmO3tjk2YkWdjZI7rPFd9voe7vm9CS2+bdItkU9d2jeWfEnB1xIHAsl7/bEcRobnTH8iTEcfDa115nkFy+STV16NZD8JRrwZhFAAI0EY3ivPQdRBdoyMuzse6F4wWoMjC2ey1zO/ui0NS1aFeHQSfy0SM4N9QH3nY0VJW03L8GrZVO2Wwo5BtundhQ/WF37Pyuj186K573S1AOWO3jA59gfey/lz4GrFBTaojRQrSetMUlCqnSVeMu1UMWSC7qKR7YDLJfMQ5hTIYhSgQWlghSPlP/lqPaP6y4Aur5tcHGRuxg38BWj+21VFsXIa6NOAf+JDit8IG754qKjRHNInglO/ecQW01YEZanNG9VqEe6VIzSCzTG1ikNlX1CsN
 APFlwrgE
 /MydQdbys9K9nyguSahElosF2BLLkgQH0FK9//CqvAhXpohMpdnRvr134MpGzOyX85SNDvd7M9W6s6vvypOfCvjOSFlvnuuVRVTLK6abTY8mnZRVIJ6YUHdVmHWaoWFeSUcDFZx+hv1B5b1Rdu8JbAgP77sga9AqiMFAm9bdAPPXrUoP8sPpXxJ5KEUuTcuKVTfWmo1pRgGlkiL2aogKAriT5/RdAVTVUpjEWTkM9c8FbJZ8bflPMACR0WZp989Mr00B3wxEchvfkrruOkfWGsGXoM1/hMraVX8y9tyRx7uSKE2WeCvso6yPj3H3TfQtCvOyQ06WGIQG+jrpAwmb09hmow3IlCVolLN/TioH9FNxGwCbbPuggyHY9YihyDVh+IWsZu9AJVr6nKehc0FbT78iG9hlyT0sNfnBc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 18:44, Peter Zijlstra wrote:
> On Tue, Mar 24, 2026 at 05:36:42PM +0100, Thomas Gleixner wrote:
>> On Tue, Mar 24 2026 at 15:00, Peter Zijlstra wrote:
>>> Not to mention we don't actually need any of that here, because:
>>>
>>>
>>> The vma->vm_policy thing is written under mmap_lock held for writing,
>>> and the futex consumer is a speculative read lock. Specifically the
>>> ordering is through the associated seqcount.
>>
>> Duh. Yes.
>>
>>> All that is really needed is to extend the lifetime of the mpol to the
>>> associated RCU period. Which is exactly what this patch does.
>>>
>>> Want me to go write up a better Changelog?
>>
>> And a comment in the code explaining the RCU magic perhaps?
> 
> Does this work for you?
> 

CCing Lorenzo and Liam.

> ---
> Subject: futex: Fix UaF between futex_key_to_node_opt() and vma_replace_policy()
> From: Hao-Yu Yang <naup96721@gmail.com>
> Date: Fri, 13 Mar 2026 20:47:56 +0800
> 
> From: Hao-Yu Yang <naup96721@gmail.com>
> 
> During futex_key_to_node_opt() execution, vma->vm_policy is read under
> speculative mmap lock and RCU. Concurrently, mbind() may call
> vma_replace_policy() which frees the old mempolicy immediately via
> kmem_cache_free().
> 
> This creates a race where __futex_key_to_node() dereferences a freed
> mempolicy pointer, causing a use-after-free read of mpol->mode.
> 
> [  151.412631] BUG: KASAN: slab-use-after-free in __futex_key_to_node (kernel/futex/core.c:349)
> [  151.414046] Read of size 2 at addr ffff888001c49634 by task e/87
> 
> [  151.415969] Call Trace:
> 
> [  151.416732]  __asan_load2 (mm/kasan/generic.c:271)
> [  151.416777]  __futex_key_to_node (kernel/futex/core.c:349)
> [  151.416822]  get_futex_key (kernel/futex/core.c:374 kernel/futex/core.c:386 kernel/futex/core.c:593)
> 
> Fix by adding rcu to __mpol_put().
> 
> Fixes: c042c505210d ("futex: Implement FUTEX2_MPOL")
> Reported-by: Hao-Yu Yang <naup96721@gmail.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  include/linux/mempolicy.h |    1 +
>  mm/mempolicy.c            |    8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> --- a/include/linux/mempolicy.h
> +++ b/include/linux/mempolicy.h
> @@ -55,6 +55,7 @@ struct mempolicy {
>  		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
>  		nodemask_t user_nodemask;	/* nodemask passed by user */
>  	} w;
> +	struct rcu_head rcu;
>  };
>  
>  /*
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -487,7 +487,13 @@ void __mpol_put(struct mempolicy *pol)
>  {
>  	if (!atomic_dec_and_test(&pol->refcnt))
>  		return;
> -	kmem_cache_free(policy_cache, pol);
> +	/*
> +	 * Required to allow mmap_lock_speculative*() access, see for example
> +	 * futex_key_to_node_opt(). All accesses are serialized by mmap_lock,
> +	 * however the speculative lock section unbound by the normal lock
> +	 * boundaries, requiring RCU freeing.
> +	 */
> +	kfree_rcu(pol, rcu);
>  }
>  EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
>  

So IIUC, futex_key_to_node_opt() looks up a VMA under RCU, without
holding the mmap lock. Concurrent mmap-write lock is detected by using
the mmap_lock_speculate_try_begin()/mmap_lock_speculate_retry() seqcount.

After looking up the VMA, we access the VMA policy.

vma_policy() does a straight vma->vm_policy.

What prevents the compiler here to do some load tearing while it is
getting modified by mbind()? Or what stops the writer side to to some
store tearing?

Shouldn't we be using at least READ_ONCE/WRITE_ONCE() etc?


-- 
Cheers,

David

