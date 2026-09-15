Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFC27C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1497A6B008C; Tue, 15 Sep 2026 08:02:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121B36B00A7; Tue, 15 Sep 2026 08:02:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CB86B00A9; Tue, 15 Sep 2026 08:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB7C56B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:02:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65C8B1C2411
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:40 +0000 (UTC)
X-FDA: 85215859680.03.43A85D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7783CA0019
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:02:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLK5OWmH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789473758;
	b=Iy+dqOT6OVx/80MTlgj9ZWmFIryriypEnUTsojXdtm9hX+Sf6z4EMlpFKq9jVokC0qmJRR
	Pb5oCKNONf75pAbfZ1EJgjgr5+1+K2+Lpk3ugFbKIw8/rQyJ5SLQhmcbpc46tqjPoHoxL2
	qbJUDadxmmRUwORF+mX6A660cAEW5uk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLK5OWmH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789473758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYasB2n7OsZrAGTIxhx0vfL6Hr1V6lv0SGK3yUmQUqw=;
	b=O7Vi1v7TIXXUPBpUBLzeoxj/kIZTuDwsFqHSI+mBGGc5YOsP2rqySWpCwslrG4z4cBq17y
	Bt9r3OqvZEy70xDV98Bodo7VOWypkV41eB/SW2Elc9p8kVZBl/cw7cqiZROvJNDIr0dbro
	M1bG1MdpvfE2N/oQlP7AKTUl5CyZaWk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C96344141E;
	Tue, 15 Sep 2026 12:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387C61F000FF;
	Tue, 15 Sep 2026 12:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473757;
	bh=BYasB2n7OsZrAGTIxhx0vfL6Hr1V6lv0SGK3yUmQUqw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kLK5OWmH5FeRp2yt2e4myKCi9y3+mY53BiK6L9vNHQ5uTM6fj3DO0pwiEqHUMvsM0
	 ESaDLlNooJaZWZzXn+fwt8sx8JYjo+kme8y6simxJbzOdml/7d7qzBvclr8ss8ybop
	 6UATgRKamRM/oJ7u2yL66NRnyvug6qhu/2dONTa5uVosSvM7FVkJ6ldmN7iiyFe0cf
	 vM+1VhChDAB7MMFUh/P7ImUwICvdJ59Zd1YtKfAMsDwPcQLf0IrNzaT/gIv0qXIxYD
	 wQAY0ojWQ/qj8v9AbBn4WGO39CTsvBMsG4tlr8iNS54yNb1hR1I1ImUeriu3Ma1+Ne
	 TFmZtf2+q/2CA==
Message-ID: <1a859476-36de-49a9-872f-a62f6eacb7f4@kernel.org>
Date: Tue, 15 Sep 2026 14:02:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: do not boost watermarks in kdump capture
 kernels
Content-Language: en-US
To: Yuanhe Shu <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org,
 mgorman@techsingularity.net, linux-mm@kvack.org
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Henry Willard <henry.willard@oracle.com>,
 David Hildenbrand <david@kernel.org>
References: <20260914131142.2984623-1-xiangzao@linux.alibaba.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260914131142.2984623-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7783CA0019
X-Stat-Signature: uc46muh9y8gffeik4t4cbam7b7qujrpj
X-HE-Tag: 1789473758-215306
X-HE-Meta: U2FsdGVkX19jXqZ3Mpv2Ig2xnB711T469+HkiMtLPw3WcS4/voeGy3GOf6t5m+h2tuyiWc/SSxIloOCHPDjlbRe6gn5UknBEYc5+voJeK+CoCV7X8ENmTxIjdvigkwn+sQzwFS8agQo1/hFz3ZuWot1l2dO5Er5zVJU2m7Sy+1ncp34/FM+smn5LMvn1lSSdSPlFhEBiMm29UZtrgWJRcpkS09ge+5NE7aP+m7sOLtIt3J/KZlnvmEh57c/FCbcvWOG5TUhsLlEmnn02YbOaeuQwqMhNfLk7LFNtapHVpxsu/TCWEe5zTPfnxt7VogVJFUwtlOcLbpIPlSJW0G/lUdKqD/OS0ShsU82NYMHleE+kM8But2kR/bO2AZjcczn028UQs1xhxTZCWAphE1qcLFSCwv/Mge5DWliZ7S5gbpZR77I8IIOOoQT8q5XwXm7LdMOo0QgxVfBGyX52bdASFXVsYhQDqM/o23XIKLJA4UsKbEP4g8dHkTtstDhw80HXmdVX+YP7/paBXbnv2BuNgO9fRX3Tw6fDKL35IP8jQvsnYl4T5qMGNk1fmTJO33rJtmfwcq4Alecmbse1bmf7ebYZ+C2o46chLCMetYxQVWS4t30ZfxP9S3q884GdIL28nn1iAbVopDeODjLuk5D1NfMZMc/hHMJFFE4aXilcr4EMmiQHYS1Sgyo6OZcCFpebYWDDK+I4t7UwC0UvyWcKLUUq/R7iT/WI821oM+Oj3/IVNXI4FhDdQujZI/cz8xjbS5yzEIc4GHG8iohfw8AVk2AbeyrH4u8PkcJ+j5eHhXIJA1IJHQifVOTNviaHWJZ4uf+ajMWoRmcjdhOxsi2ZLTJsQ6jrDzzG2KTeyCzsvQwKzO7e/25zUeiDKt9U28mf6/1jgZyoQsc2Ts4C5q+mRzkfgTeNzbatcAfwdZMLoWoj3LgyhW9lrR0mAbl4C0B66YLkq2lAVwBv5nda0DW
 bINK4Inr
 GlXKasrwEZMjFh9GPXuX2Z5Eu3n44+kM1L9tVYjb6TBIi+aoJU+of6glzbHNVNuEDYKtqzEpEDL6OBvbCN0BHEjakXaansNR1mNRDmfmtTsuCa3YSMQmNvsfDJzT8kkg9d+tVN74srJSYABQul7ZHmWKd3Q4NnvtCNSk0rsuDFTB+sqRcpxC/XNNdahykcXnC1uhuCWUHrWk89e7Yx5xup/TWB1N1IKNQJbg2cl70iFswprMb4mcPmIG2Pa8XzJvqfJHvLSJ1fDA2K9G69s8TAH3lsIiH2w/cyV6LwX7NrXdHZT2ytuh5mXpz4y3sSK0YgsIeiVgfpc7ONd5kttof+4Y9KUzzW8zExmXI1vT49vtgOpR2TaBFk3RY2Yu8ykXF50zM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 15:11, Yuanhe Shu wrote:
> A watermark boost is not confined to one watermark: wmark_pages() adds
> it to min, low and high alike, so every watermark check sees it,
> including should_reclaim_retry() and the last ditch ALLOC_WMARK_HIGH
> attempt in __alloc_pages_may_oom().  Once the boost exceeds the memory
> still free the allocator gives up and invokes the OOM killer, and a
> capture kernel that is still booting has nothing to kill: the boot
> panics and the vmcore is lost.

Sounds like an oversight and we should deboost watermarks first before going
for an oom kill? But I guess at the same time not boosting in the first
place in kdump capture kernels makes sense and it's simpler to do.

> Seen on an arm64 machine with 64K pages, CONFIG_PAGE_BLOCK_MAX_ORDER=10
> (pageblock = 64M) and crashkernel=512M, running a distribution kernel
> based on 7.0.14.  A high order UNMOVABLE allocation fell back to a
> MOVABLE pageblock while the capture kernel was still in do_initcalls():
> 
>   Node 0 DMA free:68096kB boost:65536kB min:68160kB
>   low:68800kB high:69440kB managed:479168kB
>   Out of memory and no killable processes...
>   Kernel panic - not syncing: System is deadlocked on memory
> 
> The zone was not short of memory.  Subtracting the boost gives
> min:2624kB low:3264kB high:3904kB, so the 68096kB still free sat 17
> times above the high watermark and the allocator would not even have
> entered its slow path.  The boost supplied 65536kB of the 68160kB min
> and by itself put the zone 64kB under water.  It is that large because
> boost_watermark() clamps it with max(pageblock_nr_pages, max_boost);
> watermark_boost_factor alone would have allowed 5824kB.
> 
> Commit 14f69140ff9c ("mm: limit boost_watermark on small zones") already
> tried to protect capture kernels, but it infers them from the zone size
> and skips the boost only below four pageblocks.  arm64 64K pageblocks
> were 512M then, so the guard reached zones up to 2G;
> CONFIG_PAGE_BLOCK_MAX_ORDER can cap them at 64M, which shrinks the guard
> to zones under 256M and lets this 468M zone through.

Hm while the large pageblocks on 64kb kernels are source of various
surprises, this at least seems consistent to me. The check together with the
clamp means we limit the boost to 1/4 of the zone regardless of pageblock
size, right?

> kdump is a property of the kernel, not of the zone, so test for it
> directly.  A capture kernel exits within seconds and never uses the
> fragmentation avoidance the boost buys.  Normal kernels are unaffected:
> the size based check still covers their genuinely tiny zones.
> 
> Passing sysctl.vm.watermark_boost_factor=0 to the capture kernel does
> not cover this window: sysctl.* parameters are written through procfs
> by do_sysctl_args(), which runs after do_initcalls() where the panic
> above happened, and watermark_boost_factor has no early_param of its
> own.
> 
> Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external fragmentation event occurs")
> Cc: stable@vger.kernel.org # v5.0
> Cc: Henry Willard <henry.willard@oracle.com>
> Cc: David Hildenbrand <david@kernel.org>
> Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
> ---
> Build tested with CONFIG_CRASH_DUMP=y and =n.
> 
> Tested on the affected machine with the original crashkernel=512M and
> capture kernel command line.  Without this patch both capture boots
> panicked at 7.9s inside do_initcalls() with a 64M boost in place.  With
> it, and with boost_watermark() instrumented, every call was suppressed -
> including those inside do_initcalls(), where the panics happened - free
> memory came down to within 64kB of the min watermark, where a single
> boost would have put it 65472kB under, and the dump completed.
> ---
>  mm/page_alloc.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..276fa7169b99 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -37,6 +37,7 @@
>  #include <linux/vmstat.h>
>  #include <linux/fault-inject.h>
>  #include <linux/compaction.h>
> +#include <linux/crash_dump.h>
>  #include <trace/events/kmem.h>
>  #include <trace/events/oom.h>
>  #include <linux/prefetch.h>
> @@ -2178,6 +2179,14 @@ static inline bool boost_watermark(struct zone *zone)
>  
>  	if (!watermark_boost_factor)
>  		return false;
> +
> +	/*
> +	 * A kdump capture kernel exits before a boost can pay off, while
> +	 * the raised watermark can exceed the memory left for the dump.
> +	 */
> +	if (is_kdump_kernel())
> +		return false;

I was going to argue for making watermark_boost_factor zero with
is_kdump_kernel() but it would be more code to handle and this is not a
fastpath so I guess it's fine.

> +
>  	/*
>  	 * Don't bother in zones that are unlikely to produce results.
>  	 * On small machines, including kdump capture kernels running

We should stop mentioning kdump capture kernels here then? They can't reach
here anymore.

> 
> base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf


