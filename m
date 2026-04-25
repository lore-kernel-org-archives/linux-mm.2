Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C31FFFF8850
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 03:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76F26B0005; Fri, 24 Apr 2026 23:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4F156B008A; Fri, 24 Apr 2026 23:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B645B6B008C; Fri, 24 Apr 2026 23:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1EC86B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 23:36:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D279B1A0172
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 03:36:24 +0000 (UTC)
X-FDA: 84695665488.12.2298222
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 030E1A0004
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 03:36:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w07JOZy0;
	spf=pass (imf25.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777088183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXmM/hPKz9yiHnE92clfV8q4cx6V4udJ07l8RlViXO4=;
	b=t8E57HwS5LO+xUO0uPE15PmoIzP1c2D+2yoeiKV2w6gSjgLPmeDcsWPofpyk4ioWM9z+Y6
	+jtotkmcT1XOWwActHHHVNP+9erCJkB0pMdH+T9vntzFDWOe4QVBkgTXEFIbiQepDkKi/d
	VWkuSypbX0XSt2OVF6jpGhO8RR5VNEw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w07JOZy0;
	spf=pass (imf25.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777088183; a=rsa-sha256;
	cv=none;
	b=nNuYyr4OplWrFK/hcAEaAgIh4JbOzZRALbKj9D6I7jJQ+IGq27qYSuXPBynC6E0SOvNEZh
	KSwA9shT+knzRXen9CnKpRK/AbUyH8RbWlzPCa/VxXvlCUF9h6QYKNgp7E78xcj77aiBlG
	03hD0xn3kzmZANbbTEEnfcMLxQ9t51o=
Message-ID: <a322f827-ea39-4bfe-9c13-fa798b22e3ae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777088181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xXmM/hPKz9yiHnE92clfV8q4cx6V4udJ07l8RlViXO4=;
	b=w07JOZy0Rw8q7q18Twjp6yUHZ14Cvuxc/YOdioM3r+7rSO/94cDQa9jtB4xUDoT4kuvOem
	mB+YFj2dG2Pr843HKh177sSFBLMReoS4UKxadBLMy0c315wkwWzDf/DvnvPvtMRLz86vZ5
	0q52NMwqnxAV5/SlgdavUAOJyKTMmig=
Date: Sat, 25 Apr 2026 11:36:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/damon: introduce damon_rand_fast() for per-ctx
 PRNG
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260424151138.4692-1-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260424151138.4692-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 030E1A0004
X-Stat-Signature: ekdyfwgypetzrwyh86c46935dzma7new
X-HE-Tag: 1777088182-175873
X-HE-Meta: U2FsdGVkX19rBJ0Om9TzyzdMkRrC2NbOEKDHat9wEQ3z7j/1rLDQ2l5MtSKfNvZQ7kvgByTXouaB+kuGC4hx9PSuApgj82E6fvpyDGCRsPtu7OJFSSt3OD0dfKA/AdwHxcUTqEIRty9JPJC71q/ttGHbePAcVN7UfEvk05P4OBxxJePebCElwLZp42obnr5D/jHsDLpGEPJWRwdG8lM3JY3eKQnzkJi8Rn8dbKE4123gpY2DLG7md6riXXJkWbkzHGuxs8bEExn+5kuVY38duUqg35Nmp97LdRGLh2f+rR0GUOkTziBKq5VMQKuzXPTBEmnfGbrfflwIrYEfve6gxON0hu18G5y8preVMN+b/ipBFMt8DWp/fuHpvaipcVcrE1cm2LZNnjm5j6jgemeHnp+Fb2lAHETafdMdSnXYBtjGSppb9SiFHfm+yeGxFGYvHA0rM0xeLB388VN92zbQl9cop3b3JDxMs/0TD3kJgNIHj1euhIF06rJ3wcAKJPwMChfGWCC3lS8eIju3LHsRZ+u7tFEJ2UE7Tu1mNSuhaZVYfR9h1tzV2OkEl6cUgTel+XPWdBECuigK/Sy/1jovlkX6NDJxCElI6Q+q8SR1XCZlw/qY59TIAX6dP3vUERXU3IgjvPZix/KjCuIZ3fnsi9pS/I1ELyH6ZPz0/20J+xL/SsE3Rqq5RVeorG4FthxD0CbX4wMssQbzUAjvG8JF9SP3PfCTHqTsnjI1GIPxJ4RiFHkANwq96z67/Y9xAa+BEqaI1wVlAC/VkzagOe9w1nCCA8+FCoiSwZVOWVAYVMul0IuqtIsmP7SQBM/UyrLzMv/edB2fklgAPVf20M4uCjtK7cAYMOH+bHp2nS4AQe7588r8AdtwL+d5pTQoDAyI2OMvh/hBm9QvCLM9mJIMZBgvIl2RyYMgTmaXzTxSjH6hMkDoOrSzGOWRRm2Od0dQZ230dZZheigKetVvPhv
 VcDODXH0
 ZKcbeI5+oCthiT+MHArObOPmqKErce50UPIn64bwTNycfvDzHo5hxY0ApwDuR+DWqH8MTGf/9eWG01A/kn3IpU0u0kKMy94cPWlwyAz3UXIcRseBLo2TSJcRoIqoKu+JYr09su/K/iM1PbJjqfewD2xP5WV2o+0VeM7RD3RrCg7aOEACkUUt3VcX3u5WlFLmRNN9HlPYbkfqdzCbexklgpUKiXvRwXyNFDS+Y1IZTzlHnMmRamwAoVAZSFTosZRxmt0fdi+4WHNITW4qTKy1R46F57iJb+0DQoxnB6wvhkGLbAL7/tXFmF48YttlNve0owPjz64oRR3owSmhoH+9p/xB98NiPOu5v4OM6TVdYvqHYX3nK3O7ZXPqIWP4p333yaybLwt521uSCYMu4VSb51l6NrWmzCLJ9dy8KWBMEBxVQ5SM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/24/26 11:11 PM, SeongJae Park wrote:
> On Fri, 24 Apr 2026 10:29:58 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
>> Hello SJ,
>>
>> Thank you for the review.
>>
>> On 4/24/26 9:36 AM, SeongJae Park wrote:
>>> Hello Jiayuan,
>>>
>>>
>>> Thank you for sharing this patch with us!
>>>
>>> On Thu, 23 Apr 2026 20:23:36 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>>>
>>>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>>>>
>>>> damon_rand() on the sampling_addr hot path calls get_random_u32_below(),
>>>> which takes a local_lock_irqsave() around a per-CPU batched entropy pool
>>>> and periodically refills it with ChaCha20.  On workloads with large
>>>> nr_regions (20k+), this shows up as a large fraction of kdamond CPU
>>>> time: the lock_acquire / local_lock pair plus __get_random_u32_below()
>>>> dominate perf profiles.
>>> Could you please share more details about the use case?  I'm particularly
>>> curious how you ended up setting 'nr_regiions' that high, while the upper limit
>>> of nr_regions is set to 1,0000 by default.
>> We use DAMON paddr on a 2 TiB host for per-cgroup hot/cold page
>> classification.  Target cgroups can be as small as 1-2% of total
>> memory (tens of GiB).
> Thank you for sharing this detail!
>
> Could you further share me what do you do with the hot/cold information?  We
> found some people want to use DAMON for proactive cold pages reclamation but
> they watned to use it for only file-backed pages, and therefore developed page
> level DAMOS filter.  In a similar way, if we know your detailed use case, we
> might be able to serve you better by finding not well advertised features, or
> developing a new features.
>

Hello SJ,

Thanks.

Use case: mixed-workload Kubernetes host (latency-sensitive + batch
pods on the same machine).  We need continuous per-pod cold/hot
signal for two things -- k8s scheduling decisions (which pod can
give up memory under host pressure) and sizing the eventual
reclamation through memory.reclaim.  Both anon and file pages
matter (swap is configured); reclamation itself goes through
mainline.  What we add is the per-pod cold attribution feeding the
scheduler.

DAMON_RECLAIM alone doesn't fit -- it is reclaim-only with
aggregate stats, while we need continuous per-pod visibility even
when reclamation isn't firing.

Let me re-frame the region-size point, since I don't think I
explained it well last time.  We are NOT trying to make region
size match cgroup size; you're right that pages are scattered and
that mapping doesn't work.  The high nr_regions is so that DAMON's
adaptive split has enough resolution to identify cold sub-areas of
physical memory at all -- regardless of cgroup.  With ~2 GiB
default regions on a 2 TiB host, a small pod's pages are averaged
with thousands of non-pod pages in the same region, and the
region never reaches nr_accesses=0 even when the pod is genuinely
idle.  The cold signal is gone before any cgroup attribution
happens.  Cgroup attribution itself is done at sample granularity
(folio_memcg per sampled page), not at region granularity -- the
regions just need to be fine enough that there *is* a cold signal
to attribute.

>> With the default max_nr_regions=1000, each region covers ~2 GiB on
>> average, which is often larger than the entire target cgroup.
>> Adaptive split cannot carve out cgroup-homogeneous regions in that
>> regime: each region's nr_accesses averages the (small) cgroup
>> fraction with the surrounding non-cgroup pages, and the cgroup's
>> access signal gets washed out.
> But, pages of cgroups would be scattered around on the physical address space.
> So even if DAMON finds a hot or cold region on physical address space that
> having a size smaller than a cgroup's memory, it is hard to say if it is for a
> specific cgroup.  How do you know if the region is for which cgroup?  Do you
> have a way to make sure pages of same cgroup are gathered on the physical
> address space?  If not, I'm not sure how ensuring size of region to be equal or
> smaller than each cgroup size helps you.
>
> We are supporting page level monitoring [1] for such cgroup-aware use case.
> Are you using it?  But again, if you use it, I'm not sure why you need to
> ensure DAMON region size smaller than the cgroup size.
This is also why DAMOS memcg filters do not bypass the
nr_regions constraint -- the scheme's access-pattern matcher
operates on the already-averaged region, so by the time any
filter sees pages the signal is already lost.  Whatever
attribution mechanism we use afterwards (custom callback, memcg
filter, page-level reporting), the region count needs to be high
enough first.
> Fyi, I'm also working [2] on making the cgroup-aware monitoring much more
> lightweight.


Looking forward to it -- hopefully it'll cover our case. 😁


>> Raising max_nr_regions to 10k-20k gives the adaptive split enough
>> spatial resolution that cgroup-majority regions can form at cgroup
>> boundaries (allocations have enough physical locality in practice for
>> this to work -- THP, per-node allocation, etc.).  At that region
>> count, damon_rand() starts showing up at the top of kdamond profiles,
>> which is what motivated this patch.
> Thank you for sharing how this patch has developed.  I'm still curious if there
> is yet more ways to make DAMON better for your use case.  But this patch makes
> sense in general to me.
>
>>
>>> I know some people worry if the limit is too low and it could result in poor
>>> monitoring accuracy.  Therefore we developed [1] monitoring intervals
>>> auto-tuning.  From multiple tests on real environment it showed somewhat
>>> convincing results, and therefore I nowadays suggest DAMON users to try that if
>>> they didn't try.
>>>
>>> I'm bit concerned if this is over-engineering.  It would be helpful to know if
>>> it is, if you could share the more detailed use case.
>>
>> Thanks for pointing to intervals auto-tuning - we do use it.  But it
>>
>> trades sampling frequency against monitoring overhead; it cannot
>> change the spatial resolution.  With N=1000 regions on a 2 TiB host,
>> a 20 GiB cgroup cannot be resolved no matter how we tune sample_us /
>> aggr_us, because the region boundary itself averages cgroup and
>>
>> non-cgroup pages together.
>>
>> So raising max_nr_regions and making the per-region overhead cheap
>> are complementary to interval auto-tuning, not redundant with it.
> Makes sense.  I'm still not sure how it helps for cgroup.  But, if you do want
> it and if it helps you, you are of course ok to use it in your way, and I will
> help you. :)
>
[...]
>> Sashiko is correct that (u32)(r - l) truncates spans greater than 4 GiB.
>>
>> This is a pre-existing limitation of damon_rand() itself, which
>> passes r - l to get_random_u32_below() (a u32 parameter) and
>> truncates the same way.  My patch makes that truncation
>> explicit but does not introduce a new bug.
> You are 100% correct and I agree.  Thank you for making this clear.  I should
> also mentioned and underlined this in my previous reply, but I forgot it.
>
> So I think this patch is ok to be merged as is (after addressing my nit trivial
> comments about coding styles), but we may still want to fix it in future.  So I
damon_rand() is now only called by damon_split_regions_of() with
the constant range (1, 10).  may by we can rename it to
damon_rand_u32() to make the u32 constraint explicit in the API
name; that closes out the truncation concern at the legacy helper
without needing a separate series.
> was wondering if such future fix for this new, shiny and efficient function is
> easy.


Will do.

v2 is a single patch with the style fixes (drop 'likely', 'r' on the 
first line for paddr.c, ctx at the end for

vaddr.c) and 64-bit handling:

       static inline unsigned long damon_rand_fast(struct damon_ctx *ctx,
                       unsigned long l, unsigned long r)
       {
               unsigned long span = r - l;
               u64 rnd;

               if (span <= U32_MAX) {
                       rnd = prandom_u32_state(&ctx->rnd_state);
                       return l + (unsigned long)((rnd * span) >> 32);
               }
               rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
                     prandom_u32_state(&ctx->rnd_state);
               return l + mul_u64_u64_shr(rnd, span, 64);
       }

I will also drop Prefetch patch.

>> We can restrict the region size when config or just allow spans greater
>> than 4G.
>>
>> static inline unsigned long damon_rand_fast(struct damon_ctx *ctx,
>>                 unsigned long l, unsigned long r)
>> {
>>         unsigned long span = r - l;
>>         u64 rnd;
>>
>>         if (likely(span <= U32_MAX)) {
> I think we could drop 'likely' and hope compiler or hardware branch prediction
> to be smart enough.
>
>>                 rnd = prandom_u32_state(&ctx->rnd_state);
>>                 return l + (unsigned long)((rnd * span) >> 32);
>>         }
>>         rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
>>               prandom_u32_state(&ctx->rnd_state);
>>
>>         // same as 'l + (unsigned long)((rnd * span) >> 32);'
>>         return l + mul_u64_u64_shr(rnd, span, 64);
> Makes sense to me.
>
>> }
>>
>>
>>>> +
>>>>    static inline struct damon_region *damon_next_region(struct damon_region *r)
>>>>    {
>>>>    	return container_of(r->list.next, struct damon_region, list);
>>>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>>>> index 3dbbbfdeff71..c3779c674601 100644
>>>> --- a/mm/damon/core.c
>>>> +++ b/mm/damon/core.c
>>>> @@ -607,6 +607,8 @@ struct damon_ctx *damon_new_ctx(void)
>>>>    	INIT_LIST_HEAD(&ctx->adaptive_targets);
>>>>    	INIT_LIST_HEAD(&ctx->schemes);
>>>>    
>>>> +	prandom_seed_state(&ctx->rnd_state, get_random_u64());
>>>> +
>>>>    	return ctx;
>>>>    }
>>>>    
>>>> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
>>>> index 5cdcc5037cbc..b5e1197f2ba2 100644
>>>> --- a/mm/damon/paddr.c
>>>> +++ b/mm/damon/paddr.c
>>>> @@ -48,12 +48,12 @@ static void damon_pa_mkold(phys_addr_t paddr)
>>>>    	folio_put(folio);
>>>>    }
>>>>    
>>>> -static void __damon_pa_prepare_access_check(struct damon_region *r,
>>>> -		unsigned long addr_unit)
>>>> +static void __damon_pa_prepare_access_check(struct damon_ctx *ctx,
>>>> +					    struct damon_region *r)
>>> Let's keep 'r' on the first line, and update the second line without indent
>>> change.
>>>
>> Thanks
> You're welcome :)
>
> So I'm still unsure if this is the only single and best way for your use case.
> I'd like to further discuss your use case and find more way to help it if you
> are also interested.  So, I'd like to continue the conversation.
>
> Regardless of it, though, I think this patch is good enough to be merged for
> general use case, though it require above trivial style changes.  I wouldn't
> strongly request you to solve the >4GiB region issue together, but it would be
> nice to be added from the beginning.  It's up to your choice.
>
> I'm also waiting for your answer to the second patch of this series.  I'm still
> bit skeptical about it, though.  To my simple brain, it feels introducing too
> much complexity.  I feel like making this damon_rand() optimization patch
> merged first and keep discussing your use case and the second patch later might
> be a path forward.  If you agree, please feel free to post a new version of
> this patch.
>
>
> [1] https://github.com/damonitor/damo/blob/next/USAGE.md#damo-report-access-page-level-properties-based-access-monitoring
> [2] https://lore.kernel.org/linux-mm/20260307210250.204245-1-sj@kernel.org/
>
>
> Thanks,
> SJ
>
> [...]

