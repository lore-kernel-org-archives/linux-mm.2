Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 222EEC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 20:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81646B0005; Thu,  9 Jul 2026 16:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33146B0088; Thu,  9 Jul 2026 16:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24326B008A; Thu,  9 Jul 2026 16:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70BED6B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:42:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4920401D2
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:42:14 +0000 (UTC)
X-FDA: 84970410588.09.A819D9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 269194000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:42:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0kaGcRC;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783629733;
	b=vYLcvu6qpIKqkd5lQlQ3EzSHv8x6tu1cVOZ+om9t9EK1lzX3pv5yK4cI0ZTyjW9gIpDCoi
	FWfYOcH1VqxmWGVYaWa3iaa3R5hunjBx1cephHXJrdZpvmwWafqyfYb93JgXbTmLpUQ0xI
	/wc1GKASX0DHrH3wel3JSkOj277aE3Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q0kaGcRC;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783629733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTaYGVr58Q84AkC+6dR6pRWmXzMoGmXAfHwB6T7z4YY=;
	b=ShA+tGCMB89GXOzcNOigqJrOojEtdNgeTwbCYGRTwNsr9eIWdbolHxxhMs5U/nehTOmSc0
	PgMADXN5lsNmwTuc65+zPBhmQ3ifzDa+fnrrTlZdkLpM1Mh/ScctA09y69OqzobBP73F/t
	1UeFP/lQwFdy8QDzjo9UcPEB67dlKbk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82D5E600C3;
	Thu,  9 Jul 2026 20:42:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C6B1F000E9;
	Thu,  9 Jul 2026 20:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783629732;
	bh=eTaYGVr58Q84AkC+6dR6pRWmXzMoGmXAfHwB6T7z4YY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q0kaGcRCjiqw2ou9rucxm9EOKU24drX4BWO0TDHjpAYNUO6uaB0L/E7HZw+/uzmn3
	 Po3F0xL3fw7Awa0DKL4IgX06GH399MjNm9n3zAQyLeEpE1i8kFSnEiUD3lpEnsAAxX
	 NxHCrnJdDRkbxpZvmJTKTtwwJMsYdcYHrES8agVlS81g076Gl01R5Rtmzz+Oj5tiwe
	 JzULGIwLoA9qLSNrYNfAgg8KNUZ+vI2KMGP53CSt53ZmaABc4Ho06wAd8MhQSRi/9i
	 7xoHZvqYZvb1//LN5KM5KKljl0V/0JyIQnoa4OA+IGylQiDqy0pA/qTbWfisrxE97c
	 fQS42DwQLmY0A==
Message-ID: <a40cf086-e37e-4f2a-8de2-39d7009fbdb5@kernel.org>
Date: Thu, 9 Jul 2026 22:42:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: compaction: support non-movable compaction for
 pageblock requests
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-3-hannes@cmpxchg.org>
 <e36dad58-d259-4533-be08-50d667d5144e@kernel.org>
 <akUyEgKMryy6TntY@cmpxchg.org>
 <c00f2d42-83f7-4417-aaf8-aed0bf1e28db@kernel.org>
 <akWCZLAMgJrmnZGN@cmpxchg.org>
 <61bc1ad0-f9e3-405a-ae32-b89bcdd2e1d1@kernel.org>
 <ak_c1HH72sJDmaSZ@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ak_c1HH72sJDmaSZ@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 269194000A
X-Stat-Signature: 56q8pssznpia8pcyh8jbzusf7xegqbh3
X-HE-Tag: 1783629732-384150
X-HE-Meta: U2FsdGVkX19J72PRPiwHQpt7vNcm+pyrAUC1bwAcSebtz56zgcK75FxgT+FyElLPMjaLSmGdwfnmu6WWL+s28MATcPzi+Co2SKvybq2rjPpQHeKMoFkxSu/tKdXlHvkG7f7h0qdthmsFCZ/1HGoS6QAZCyTXb0GuoC6348F0ZYnhf0aJgVJOYZxuNZX3tRNKUcV90aO24xlJMWVr0olCPdBRe+tF0sKfLfMTk1HT0QSDmJ+lPopKbyVoe0SunPeBjrtXnX+BAFDa0cHTTXkMXKA1PNf2YXrrYrgBZ7xC6ZyHqbXF6IdYcNbZ41weGqc3LV28DLhiYrEc9My2iqCVXV7lr4Y8yLJa10h2xxJiXVFeAaLSuu99uI8xLJISBrJYX2oMTW4DN7GndOWUsmjKRi/Ky1xPUP6kBi2Hh0AF+ACII+uzj4ETtGVu4fwRFkw2sYh8inIpY8+2iHEgNthnyO4JufnnyVVwFE9NcP09BurAnZcsHokdJNM9ZGMdqhvldvsbeMR3fN3v5rKkvxE6d0VZGxatz8XK5yce233Xz7nBc7cTkdr3yKXc3CwIPUq1Pa60J8X7GulaBrgB5i6m/wlbnIddAh/RZgVZWzbNVHwfr9JFs170rwHrCXVNB9Mk4bVfVoSWLgaZv/bEuWqCdfvUz6d+M9VMpZSidRvLRvWO9gyu+ayR/K5LGV6e+Y3tbB3K8czVac+yEx3kr13PPq4VSAY10vePSWe5uo85ZoC3jVi0Vhj2xxNSYA1qAUAIisV9LsWo1M8wz4L7GQ8Z+8UsL4k35MnWwyr1h//MlSGVfbmu5VcDtrmtNP8yD8wZ0J3+XSYbeNacgMAOgoXQEhNiWIrh1RGeGO7k4Bv8udeWqgbKCtOkLr2d0Yh/YveEOiFFWz+/Kfq7w5rFVac0nz7fKaOCM4cktcQQFxulLdlEMSAWfDqrbqNxSLB388tstTRCskCHW/RvozWRg4E
 +dTX01Q+
 R9tnJzCxqwI8Rkj1Pxt3eGm/fdxWjcNPeIm71WkafnVVpNQyTOIJmEmFj2+c6h8CZvcBBvllcEhAY3/sX+oKemtO/8opZ7ZEvRZyQiAI49w6Fefgvun+JXBXeJysLcJ/4xLZqG/F+5GCVcc3WXyB3j09c8GppiOb8H9jS34WOPLcmduk/AGjkE3WKshupLUF8/OBgPyKB11Iz4uFdpfjhrwFVmdzjoOAGkw3N+EepKi/1A+00keJhma+bABgMVj/WUHe2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 19:39, Johannes Weiner wrote:
> On Thu, Jul 02, 2026 at 11:28:47AM +0200, Vlastimil Babka (SUSE) wrote:
>> On 7/1/26 23:11, Johannes Weiner wrote:
>> > On Wed, Jul 01, 2026 at 08:14:05PM +0200, Vlastimil Babka (SUSE) wrote:
>> >> 
>> >> > This made the migratetype filtering about preventing block
>> >> > pollution. The patch quotes reduced extfrag numbers.
>> >> > 
>> >> > So now we have a block pollution guard that we apply only if... the
>> >> > scanner is latency sensitive? :) Is this actually desired behavior?
>> >> 
>> >> Yeah indeed I was wondering in this direction.
>> >> 
>> >> > Another way of looking at it would be this:
>> >> > 
>> >> > 	/*
>> >> > 	 * Allocation fallbacks can spread migratable pages
>> >> > 	 * into non-movable blocks.
>> >> 
>> >> But also vice versa, non-movable pages into movable blocks? (without
>> >> defrag_mode?).
>> > 
>> > Uhm but those aren't compactable anymore then, right?
>> 
>> Yeah.
>> 
>> > There is a flipside, but it isn't quite symmetrical. Movable requests
>> > are allowed to look for movables in unmovable blocks once they become
>> > sync (high-effort, low-result). Non-movable requests are finally
>> > allowed to empty movable blocks once they become sync; they *start*
>> > with the high-effort, low-result mode to avoid block contamination but
>> > are allowed to escalate when that doesn't produce results.
>> 
>> Hm, true!
>> 
>> I was also thinking, if defrag mode doesn't allow that escalation ever
>> (IIRC?), should it be reflected here as well even with sync compaction?
> 
> Ok I made a clarification regarding defrag_mode in the other comment.
> 
> How about this?

Looks good.

> diff --git a/mm/compaction.c b/mm/compaction.c
> index 7df3a85d43af..a12a49eefe85 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1399,13 +1399,24 @@ static bool suitable_migration_source(struct compact_control *cc,
>  	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
>  		return false;
>  
> +	/*
> +	 * Per default, scans are restricted to blocks compatible with
> +	 * the request, to prevent cross-contamination. Once
> +	 * compaction priority escalates to synchronous scans, though,
> +	 * scan all blocks to try to make forward progress. For
> +	 * movable request, this likely helps little: there shouldn't
> +	 * be many migratable pages inside non-movable blocks besides
> +	 * allocator fallbacks. For non-movable requests, this helps a
> +	 * lot, as they can finally scan movable blocks.
> +	 */
>  	if (cc->mode != MIGRATE_ASYNC)
>  		return true;
>  
>  	/*
>  	 * Prevent small unmovable/reclaimable requests from polluting
> -	 * movable blocks through fallbacks. Whole-block production is
> -	 * exempt as the allocator claims and converts these.
> +	 * movable blocks through fallbacks. Whole-block production
> +	 * (directly requested, or defrag_mode) is exempt as the
> +	 * allocator claims and converts these.
>  	 */
>  	if (cc->migratetype == MIGRATE_MOVABLE || cc->order >= pageblock_order)
>  		return is_migrate_movable(block_mt);


