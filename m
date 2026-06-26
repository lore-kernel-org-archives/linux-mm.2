Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D917C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 15:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE916B00BE; Fri, 26 Jun 2026 11:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 696646B00C0; Fri, 26 Jun 2026 11:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AF166B00C1; Fri, 26 Jun 2026 11:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9D96B00BE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:09:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93AB61204AC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:09:31 +0000 (UTC)
X-FDA: 84922397742.04.00E86C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id D20DA40003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:09:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WjfEBCkb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782486569;
	b=Lp3d1E59cyiNOpstt8Bu6msdMzqbk4Wy5qZewBaHSqIoMcvSiDOaV6m+Hvg1DV6Se6kPtj
	YNYVkN77mZPe4cEPoEXsdxOh2sKCfCuuO5DN57OHcaoPmMB7vvs5h3JqnG+Mzp72HBVeEt
	xJqykec+DADs7wkRw67dHNdhmlLhros=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782486569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MBy2BPUkeyOXyUL7Fz57L0BYcumMFApFKpBkO/8PzI=;
	b=H9DoFlKzUvrWnKFxr1C5r8hMaM4oF3SiRarC4mZYC1YBJNhkABTH++b0zdBQNMYvyVgJyN
	PtjyEc7Ev5Bsh5rqVxemkl/ocHUC3OYa1HeaBjVvUBEw//sjP7fi5FkacNfGUdn/fEyVn6
	GacO8aZXt9sdyUm/J7ST8VI6eoFy28Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WjfEBCkb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D967600C8;
	Fri, 26 Jun 2026 15:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8761F00A3A;
	Fri, 26 Jun 2026 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782486568;
	bh=6MBy2BPUkeyOXyUL7Fz57L0BYcumMFApFKpBkO/8PzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WjfEBCkbGzVRIUD2Rmtyu6PIgaqLFU89CsEhXqdgmnDmy8UPaex1BeWyAc+/T1U0G
	 +lhSPR3pV/ErHMPicQ7/CB6S3xjf1U/SCq/sXYVynnnLPwIkhc5k8C/nxAIPmmMDB/
	 K4BxeNO4M6SsgxJA4pjOZ8JwgiRkYETVHmQkyEiG6OfHagiRewDiDwgqEBhay3otGQ
	 n5feb/OLALrPJXumW0fOxMnhu6G54np5AJvfpkvZcFdqhQZc6LT64kT/tyF9vIr9hy
	 y7gKK9N7maJqGjrnMCKKIxAkR47SKaRBeVFQ3kYdpJ+7srmarYJtTjKrDMG6s07pOr
	 BYWELocHLM1xg==
Message-ID: <b40a096a-ae54-40e2-816b-86c853435803@kernel.org>
Date: Fri, 26 Jun 2026 17:09:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/4] memcg,slab: kmalloc_nolock() fixes
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <DJHF7S039QNX.KNVMFISSMLMU@gmail.com>
 <b71f08a7-c767-4551-8e74-bc37aa1b028b@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <b71f08a7-c767-4551-8e74-bc37aa1b028b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D20DA40003
X-Rspam-User: 
X-Stat-Signature: nujnkz3oxohh71dzonasmr77nra169qt
X-HE-Tag: 1782486569-382316
X-HE-Meta: U2FsdGVkX19n7B8id7m405ZApMyiG/ENXizUZ6Ch9qktlDMKaFSC9gBj01EZO5Zy1WiHGB69m9FwcnMSluwBdb1YAAgDpi0I7b5tRDn1aZsNqRCYcRRv53gIrRZe1DLmUJN8KP/KyFSG0P2LerqrqwGutTdUdRuhiC00hqhBvS4cLNVdHYOy/P468QTANTHCCkgQdCnKOQQoM6u5+9qC4UslLGDlW9vwLtCepy/qGSDC2lCsaxZ3pUiRdAgTbpJEsOGP5B3XyYevXFlilHdppvk3KadxrJVx8fElKLqFMPsOioQB8vNWycb3DdRA8hhLJwJX2ONRwuAkXQYvfCXqlnZBa9Oa9mumGLG2W5UtDpIdfFnpS5WXRO3Th3aUpfdsBuYT0RqqqzgfUybApvR0G92PDpqequFGGqINnBlphLaL0ws5BKmDRBJUp1hzpOZRjtjAdIFJcaVSemaHR32bCxElyw4Ds73CiRJZ2BjJEux1gElA8ocuHuGwLNHjhDVS8bosYe2/qnubkWXm1eCc8bcZ8PVNLjcb+cg9fSu/UVVCM+57rKBptLkbSUiuhfr3y79CWGhrHpgj31dbVJihWz8qWV+omBMVNdVnitiMkEEDnWu/xikmwcNoUav5ep7sHbLk/JsnhsZ1jcjfum0gmcWVctY8g+IqtwjK7FRj6lIlTXWTNAQervSHzrmgBoOniqDYgzqwM/PXEYRHFJBu8Y2uQyx/0p1FDYYtbB05CBE4joTJNLvKh6aVEKtNzGn9aSI6stUXJ3gh4b51Uf3UAVbBiVRx7BuPwzusdL3C98Rc5P7LEnvN6krpqwDpMcYbk2YkAHIXvsu2LQ7N+rg93frAaAKPGz+R+VgIf5s42y3e6jWgQkAV2ljt7s8eJgi7xMIHitzWvbHj6U4juU7veLyNSoMKD0wBOeSraeIz/+Oaxr1wK1iHIiVpkFi2MQUeJZNyUBkCUfehwnKlBpY
 pRKSaoRO
 n3sZNQ2kK9D6RSOkbbW1n3vzY5Y7Q/x3syWsqPglFTo4obVxLfsKbyNhcDLQc/fsVUfoHcfrsjdbNi8UqtdQl9ihBlsyFyolHwjLY4JXcDyX7RO5AmHMi38ipdsDjBUBJuLLsQaK6BJiz9FXHKcviGtvUa3mniKhJ9SsJt5LLABADFYsrQBsEsh717TXbQkbNvLrirvESiD7FtzYvkHsRqieovZoi7+cXFO4I+i7S1zrY72bXvicbjbkxKQ1JEEgW+gBqo380bhTPr+vYZVV9wHR7zXF9TnFTy8PCJXh3mfobn6h32OiCCFDyeLGn1hOasV5HXb6gTXuya8BciJW/+D6T6f0pyd0TA8UK6yu6seGIwjxS2xbfLIbRWvF0RMVVGbsJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/24/26 22:19, Harry Yoo wrote:
> 
> 
> On 6/25/26 1:30 AM, Alexei Starovoitov wrote:
>> On Wed Jun 24, 2026 at 6:11 AM PDT, Harry Yoo (Oracle) wrote:
>>>
>>> Bug 1 was reported by lockdep, and bugs 2 [2] and 3 [3] were
>>> reported by Sashiko.
>> 
>> ... and in fixes for sashiko complains sashiko finds more issues.
>> I don't think it will ever end. I suggest to fix realistic scenarios
>> instead of one out of billion cases that sashiko think is plausible
>> but will never be hit in reality.
> 
> But we can trigger debug warnings for the first two bugs fairly
> easily with slub_kunit. Doesn't that count as realistic scenarios?
> 
> (Ok, I admit that the last bug was purely theoretical, and would not
>  have bothered if the fix was not straightforward)
> 
> You might argue that it's not as urgent as we might assume
> (e.g., it's okay to not fix them asap or backport), but I don't think
> we can just ignore them.

Agreed, should be fixed, even if rare.

> It might be bit harder to cause an actual deadlock than to
> trigger a debug warning, though. We can discuss that [1] [2].
> 
>> The chance of server crashing
>> due to cosmic rays are higher than such bugs.
> 
> I'm not convinced that it's the case.

Yeah, especially with large fleets this will manifest for some machines, and
as the usage of the API intensifies.

> Well, I don't know what are the chances of calling kmalloc_nolock()
> in NMI, or within slab or memcg (via tracing), and that is an important
> factor here.
> 
>>> To BPF folks: do we need to backport kmalloc_nolock() support
>>> for architectures without __CMPXCHG_DOUBLE to v6.18?
>> 
>> nope.
> 
> Thanks, that was what I was hoping :)
> 
> # The discussion
> 
> [1] Bug 1: freeing a slab object via kfree_nolock() or draining
> the stock in kmalloc_nolock() happens very frequently. The objcg should
> have been reparented (which happens upon cgroup removal, which is not
> too rare) at some point if the objcg stock or a slab object is holding
> the last reference.
> 
> Can this cause an actual deadlock? That depends on the chances of
> calling kmalloc/kfree_nolock() in the middle of reparenting (see
> reparent_[un]locks()) or objcg list manipulation under objcg_lock.
> 
> [2] Bug 2: You should exceed memcg limit to invoke
> memcg_alloc_abort_single(), but you don't even have to be under
> memory pressure to exceed that. (yeah, I had to modify the
> kernel to implement a fault-injection-like-feature to trigger this).
> Unfortunately, you cannot reclaim memory in unknown context when you
> hit the limit. This should be fairly easy to trigger.
> 
> Can this cause an actual deadlock? That depends on the chances
> of calling kmalloc/kfree_nolock() within the slab allocator.
> 


