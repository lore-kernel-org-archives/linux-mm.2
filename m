Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F50CE9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77396B008A; Tue, 24 Feb 2026 06:04:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24EE6B008C; Tue, 24 Feb 2026 06:04:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06B16B0092; Tue, 24 Feb 2026 06:04:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A89B6B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:04:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BCCBB9C89
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:04:12 +0000 (UTC)
X-FDA: 84479065944.28.9C47EDC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 93CB61A000D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:04:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxXNFSZE;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abpLeq4V9OaC2L2qeYwJh9QgAf2pf0RA34R4WKGnfOM=;
	b=ZQqs9Uh+CYFh+75Dvs7EVAqncpygJJsFBFYND8nco2oJeWIgWklk2mrfq/x07cPBjk6FEp
	x0ZlxRWb9Kbh8/eure7KF6UFptEMXiQbZqzt7aFBYZqJTHHqknW5Afasis3OkYmqlS9SK+
	J81Ux8lklK/fSvpe8SlVXcp1V898e14=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxXNFSZE;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771931049; a=rsa-sha256;
	cv=none;
	b=dNL1FqQhoStbGK2Nl0wALseU+9XujhX8qOBg/L2PEREbesJusxi5Am+nlcJfB8G396Y+TW
	/a7LKuZ8KtIBtelAqTLbCxx8MqIWSCc1kSyAjLNZXB3i8nlFAOSQWXocrNWrmcClPFL1Xd
	6/LWv81zrt7Wo3fYaUJfW3372IgKG50=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 91DAE6132E;
	Tue, 24 Feb 2026 11:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439E0C19424;
	Tue, 24 Feb 2026 11:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771931048;
	bh=93TFsFhUI4si2PRVVTQOu/OozcSIrJzAXBGMvSoUCVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mxXNFSZEgof4oWvDh69w8cl9UASs5pzSlvh6ePsgKJIA+Z4aZCoL8o/NzkhyaACAq
	 jVb4bMPUBDBV4zV6B26G80K1qFX4PaqMs1eJmaEuv8v4fp3OJNczMtMN5h7OHpf9K6
	 Ial2n412Zt46Wl2/lTWfypPx6ZgyKD5BpLTPyghJ4foYVp6adWPm5ojdyV528uVulg
	 wpoDa8jWI3nScevOBgmucmnWsFCqqLq7z8Dt4SrhuQgL37L45+sgWCvaUXLQ7K/j1s
	 vS5ZTkyFevwbM74GQeKMZPo5VcFiwzGgbDhSCm9NaUzvI7jtZLuCc+m0xgYygbCVkh
	 XQV9aGj7Kb4pQ==
Message-ID: <d5c90e6b-9dc9-4524-bcd7-534e311beec2@kernel.org>
Date: Tue, 24 Feb 2026 12:04:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 peterz@infradead.org
Cc: dave.hansen@intel.com, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260224030700.35857-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224030700.35857-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 93CB61A000D
X-Stat-Signature: soeejc4krd6thenqk9xbnh5jn9fwc3ae
X-HE-Tag: 1771931049-337954
X-HE-Meta: U2FsdGVkX18z7ApdiIJUZV3COKrbDzTy+x0b9lytaM4sqkgu6rqNqg1JvQB0WYmFjEUZ8Amj3Tz8X+xs6ZURTViN9rARVE/4sYA0wD5t0rFabEqR9R7bTdU62VTXP6ycaL3Dj2I3VHIiMvZZodGuKftXwJC4WFjoAwTPp75myjwBZ/vDB/0bpoZdfd7dPr6MGa5XDYMLzewLgVjRsx4QDl12PWZK4YpH1pwZLcFtl3XIcPPaUWumD2ADg86tVZNIGWLQz10zf/vuYYHIdqwNU122IAsmBfzT4wDsW2fvUoqBMRgvVuScNYciYwVlBnadzy3B6B/mLlW06xdB68QwOFYmk3N4iCf+aLvGkPcG+9EO7hMn6ueI+IPYEvMmkf80H+NKzAuMY1jAlBoAwC0sribvxdBK0wdd3WunKafWORwRh87v63ZbzkRTLwqYFIsM3XxIUFWS34OYwMopWYD/AdKFNWwkUFf8mflOC8UNeOh2BDBsx4NrsPSjzhuZvUh8E1LgG+pcD42GqXYID4j7FiowmTim5BGL1lVmU/HA4uHzVG2G5GDZo5lo/a+gTgrr3OO99f+TV55/bfdlFjuLYKR5H/ELAbsKYZ2lzgPvF4FpSY3IdoOrQ5pz22RBFPFRVpW1XfRcJPHwA+IpPy154MLQThmloGvWuU0Jwp4mERRynjrCdwlsrn6043CbCCYj9Lq7hQXzE5yCqXnvIHOrPq56Vg20aUjdsbtaAmmmER0rbX0nvW3GpwMMgQxCOmnX16yv4MJkRNDmOjRWMWdp8zOfzMyaP7F8vqOF5Psh/4EOk+yiZrYR5VIXP+osQUUYq3vJ+/YOGeLUIQcC+OZyvgsftQTRkCa+/UKTpQXVHrbl/4eeNqAX0gAjJUGkzzXKpH0mdfHcIvdtoXfjfl6UOhvxn4wW/u5JA8cd9c6ui7jymWRz00d3/+3QUPpfTbtC3wg8T4S9be0cS5tKWiZ
 mxQ5bzd2
 4zossxVbQFY1lJ3WVsA1PP9y5dxns54s63kZuYsBwEVB0BpBIKoW7gMkv7whvNvcNO8Wu+Fz1s2Yuch3fCgzBAfGX/+xxNMTlf/FJICxBmpda6kBPH8OK6uyQ4sUhzdmibCQU1OmZvc8Hl6Tk+le8oeGtSG4yhKG58RgowHqa+fg6c2vGEmZMEUKzTQlCJqey6Hxo3g+ePZ8mEf9HZXMoNHwGTUaMG5136/0jK1fO3FnC1Qz7bs4fraZzYfZWCt+OPq2m9XUgC1/bbHPQM2KmiczvbFvCkyjmSEh5/fqNLMmkbQ2IWCSZjqSmeHr/LrNv69m7LEC45DXhqHcIPOnd/EDqSxJjjLIxsXNYAASLbvxWHFUq1iCcgeKr/WBvLreJGUsVIwHAYfQ1AOiGd7b9CNyfG4RJljY1oUxOIZo6QwH2H+idSoh0rpInQfaD9V4MlP99xcci6o1uansoHVCcbwCkFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 04:07, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When freeing page tables, we try to batch them. If batch allocation fails
> (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
> batching.
> 
> On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
> tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
> process is unmapping memory. IPI broadcast was reported to hurt RT
> workloads[1].
> 
> tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
> (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
> local_irq_disable(), which is also an RCU read-side critical section.
> 
> This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
> period (synchronize_rcu()) instead of IPI broadcast. This provides the
> same guarantee as IPI but without disrupting all CPUs. Since batch
> allocation already failed, we are in a way slow path where sleeping is
> acceptable - we are in process context (unmap_region, exit_mmap) with only
> mmap_lock held. might_sleep() will catch any invalid context.
> 
> [1] https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/
> 
> Link: https://lore.kernel.org/linux-mm/20260202150957.GD1282955@noisy.programming.kicks-ass.net/
> Link: https://lore.kernel.org/linux-mm/dfdfeac9-5cd5-46fc-a5c1-9ccf9bd3502a@intel.com/
> Link: https://lore.kernel.org/linux-mm/bc489455-bb18-44dc-8518-ae75abda6bec@kernel.org/
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v1 -> v2:
> - Wrap synchronize_rcu() in tlb_remove_table_sync_rcu() with proper
>   kerneldoc (per David)
> - Add might_sleep() to make sleeping constraint explicit (per Dave)
> - Clarify this is for synchronization, not memory freeing (per Dave)
> - https://lore.kernel.org/linux-mm/20260223033604.10198-1-lance.yang@linux.dev/
> 
>  include/asm-generic/tlb.h |  4 ++++
>  mm/mmu_gather.c           | 22 +++++++++++++++++++++-
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
> index 4aeac0c3d3f0..bdcc2778ac64 100644
> --- a/include/asm-generic/tlb.h
> +++ b/include/asm-generic/tlb.h
> @@ -251,6 +251,8 @@ static inline void tlb_remove_table(struct mmu_gather *tlb, void *table)
>  
>  void tlb_remove_table_sync_one(void);
>  
> +void tlb_remove_table_sync_rcu(void);
> +
>  #else
>  
>  #ifdef tlb_needs_table_invalidate
> @@ -259,6 +261,8 @@ void tlb_remove_table_sync_one(void);
>  
>  static inline void tlb_remove_table_sync_one(void) { }
>  
> +static inline void tlb_remove_table_sync_rcu(void) { }
> +
>  #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
>  
>  
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index fe5b6a031717..2c6fa8db55df 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -296,6 +296,26 @@ static void tlb_remove_table_free(struct mmu_table_batch *batch)
>  	call_rcu(&batch->rcu, tlb_remove_table_rcu);
>  }
>  
> +/**
> + * tlb_remove_table_sync_rcu() - synchronize with software page-table walkers

Nit: no need for the "()"

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

