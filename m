Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D5BCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEFF6B0095; Wed, 13 May 2026 08:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480616B0096; Wed, 13 May 2026 08:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E096B0098; Wed, 13 May 2026 08:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25A806B0095
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:03:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9255C2F41
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:03:12 +0000 (UTC)
X-FDA: 84762261024.15.C941E2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id BA82710001E
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:03:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLNGWdLs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778673790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kyx9vuXGUWut1m0SEWV01pO9vMFYVJw0CAY4Q9nz6no=;
	b=GOxb9kANCE8iZAVujtvZiRtL/ZJtT9t64pAxxOj7vLDI8hOgGBS+gnYDW2QzcEkxdkaJEw
	4rcFxtA0xG35H5wIm6IYoArl+egjwmk3KbM8sPt770b8ylLj0eIOXal4OmSpErno258KVu
	iu4CL840NcA+bycpGRUksR7ROlg0KAM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778673790; a=rsa-sha256;
	cv=none;
	b=TgCIfS1APvIT3yf5mncs/I6T4xxNRNAd0OEp4W71o6XkGcw3+xiGwToJr2pZDCF6GD4TDs
	bAnlz8f0zSx8Yd0/8cbUN8Whg8VUy3mgSAihFqIR+W00JS2JCT9FQbnfmDcU4IpsauBfB5
	OXugNLnfl6oxhQgpIyIyxfGTkEUVQmw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OLNGWdLs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9A7543EF3;
	Wed, 13 May 2026 12:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D846C2BCB7;
	Wed, 13 May 2026 12:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778673789;
	bh=n/O1raLQ6SngGUgPEvI+NmfMMgn57+Y/s9CZdXppV1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OLNGWdLsl+8daqIqj/gVogNFsR5uV4P2oTh5FBsynOaeJp6gNSbShZEhIKEfhN2Ze
	 6IBCLP0kw3w7gENyk0qskkXt7KBQ8hmYejH0mOekxT6sUyO6BKPu4FQrgIpC4qSOqi
	 ZOgUKErd5dEtsLOl1PkUtwU6IJncB8QimNGCIZ8Zc5tuEWYiUJ3UQiguykf7eonyI8
	 B7szlH+WVgLUCqdYXNfL5sZCGDC6gQOvSDkoft4kx6DODMvnHWyqrIReYo/R8o8ak5
	 BFnG9rl2Mqmzx4u+liykh052aEcJy3WeDHjRwqUrEIfH25wjww49cnbR69pUfH9kkt
	 2Youvf6gOLRMA==
Message-ID: <fcb056b2-9910-43eb-8009-430f88230b35@kernel.org>
Date: Wed, 13 May 2026 14:03:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm/rmap: add tracepoint for rmap_walk
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, ljs@kernel.org
Cc: hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 michel@lespinasse.org
References: <20260503203911259NKHEr5gDy3PbvnSc077a7@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260503203911259NKHEr5gDy3PbvnSc077a7@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA82710001E
X-Stat-Signature: ejtfbkjixafmzdfzwapp79838z3hdoj1
X-Rspam-User: 
X-HE-Tag: 1778673790-522613
X-HE-Meta: U2FsdGVkX1/YJqqTiN5q82yPEVZYffVpd2TOGww6yb0jjAgY6eGlJvSZeEHem/uIr2bmRh8WA6m9TA6jjTv8JyDMtU7tyRZaOU+IW+CSXPvgxSR/BDEs+orUFmwoj86eR4oQKihmSy1aiOrPFqBZfh5p4YhAYeVM0Mr8LtsrYfidpL7OAjRZ11sg08QV+8icUuM/QZRhZUhGpfh2Cceut1gUwzGowIzEVjbtP9m7AZespKhwXHHd1NgyLRnmwPtKjd9VCg2J9FPrqNeVA8KZbzK6XWqMxY4EproWg8I9XA5rWtVZsL97fc15wJj0/5C/FEpp0l5xwtHSMGX2PoJsDq4/0xDAGDozD+z/isYHpbAuUZP4z7lu4oLLOD7iv2qfxr4OBNiPTieQr4mLfqL3zDOR1sXWhKCRxeGohTOL6p+i6V4vrgEBUSbzq3I9hRIx4g1cvbpJ3zZYW2W2D6oJpnS/t5ae2hs3zlRRzp7kiVFIvlUS6PchbS0jfBtwuXzL6iMmwmNFypdBo/iwHaCt+KVFe79dYPy2JkGpgnYOn+RaOEb7wEDJLb60hu0HtqMa16Mez/oYRo9ibGsHgnnLzaslTPUJvqz/BI3xAHWV5hw3+l/N26+8H1/uDqOmoLNKS29W2Pi+iRvM+JjF2nzrBuUCzyMPpfEwJCGHW4nEt+J0Oh1soj51XvCeeWwS36FVYXMmFXnNQrPtsQ8hmuQpP7iggod6C3Pp+ixbhuMWIbLrhzTzRPCFNWur0XB7b3ydHTN2Fb6MmdsxZ37Nba8rV+jojyZ6pOLQnBzYSx6G4Y48+KeAgG1kfavAsCIX9ue1ogCVFKlAGSy3xW6q1uLzQ2ixjV/sIu1F8TDalMiZDqFXYNY11RNsWdNDkNIXJQMp/xwefDI/ktDC4d2Q7Sl0399Bih3pmOz0XbcYS1X0RQTbCrvasZ2tV7EjdpxGsaLOftMEddoIdhhOeIB46Vz
 yynD8omw
 MvprRkzTHXBNXbH7hGOeD27ur96EaY1XILUAG7z+5i6E8pgJAd3rU6P9He6gTVzNP/7CKBWyDmhNtR0Tzsc8kXF8vWiPjDCHb0C50820cKpbB0Y+cJwz+pWAJ8B0p80X+jFYusV9crNCSyeMCPNhuysUbb0BgKzQ7TeBja0g63daGvZb+IFIqKzzyqSIDMZEUhUNQ5Tk8WM4aoYJfMCiHNSDVbvOzTYm1VVzYpaiUi8LWtykMWK5F5aHThksQIkZ0FqNlowHJAhVue0xFJHFDiOhhuOURqJu3eJN44SpFlL3QsamLLqUjGcCnvdf2htFm36g+b4yn3FakRewHVd4pigr0APsMIwPqF5UvZfT7VSQjCX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/3/26 14:39, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Add a new tracepoint rmap_walk in mm/rmap.c to monitor reverse mapping
> traversal. The tracepoint records the duration (in nanoseconds), the
> type of the folio (KSM, anonymous, or file-backed), and the addresses
> of the folio and rmap_walk_control structures. The type determination
> is performed inside the tracepoint to keep the function itself
> lightweight.
> 
> '# cat /sys/kernel/tracing/trace
> '# tracer: nop
> '#
> '# entries-in-buffer/entries-written: 408/408   #P:4
> '#
> '#                     _-----=> irqs-off/BH-disabled
> '#                    / _----=> need-resched
> '#                   | / _---=> hardirq/softirq
> '#                   || / _--=> preempt-depth
> '#                   ||| / _-=> migrate-disable
> '#                   |||| /     delay
> '#TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
> '#   | |         |   |||||     |         |
> rmap-215     [001] .....   692.237079: rmap_walk: folio=000000000029ddcb rwc=00000000dac4cda0 duration_ns=828682 page_type=ksm locked=false
> rmap-215     [001] .....   692.239480: rmap_walk: folio=0000000092a21fd3 rwc=00000000986376ff duration_ns=905966 page_type=ksm locked=false
> rmap-230     [003] .....   692.583619: rmap_walk: folio=0000000037a237b6 rwc=0000000080fbbb0a duration_ns=107892 page_type=ksm locked=false
> rmap-230     [003] .....   692.584104: rmap_walk: folio=0000000031bdbf8b rwc=00000000b39c973a duration_ns=330886 page_type=ksm locked=false
> rmap-244     [003] .....   692.708706: rmap_walk: folio=000000009105fa6b rwc=0000000037d46cd7 duration_ns=987826 page_type=file locked=false
> rmap-244     [003] .....   692.709198: rmap_walk: folio=000000009105fa6b rwc=0000000093942e2c duration_ns=161733 page_type=file locked=false
> rmap-244     [003] .....   692.709606: rmap_walk: folio=000000009105fa6b rwc=0000000037d46cd7 duration_ns=54428 page_type=file locked=false
> rmap-244     [003] .....   692.709658: rmap_walk: folio=000000009105fa6b rwc=0000000093942e2c duration_ns=27192 page_type=file locked=false
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  include/trace/events/rmap.h | 49 +++++++++++++++++++++++++++++++++++++
>  mm/rmap.c                   | 14 +++++++++++
>  2 files changed, 63 insertions(+)
>  create mode 100644 include/trace/events/rmap.h
> 
> diff --git a/include/trace/events/rmap.h b/include/trace/events/rmap.h
> new file mode 100644
> index 000000000000..987fa204d65d
> --- /dev/null
> +++ b/include/trace/events/rmap.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM rmap
> +
> +#if !defined(_TRACE_RMAP_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_RMAP_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/rmap.h>
> +
> +#define GET_RMAP_PAGE_TYPE(folio) (folio_test_ksm(folio) ? "ksm" : \
> +		(folio_test_anon(folio) ? "anon" : "file"))
> +
> +TRACE_EVENT(rmap_walk,
> +
> +	TP_PROTO(struct folio *folio, struct rmap_walk_control *rwc, u64 duration_ns, bool locked),
> +
> +	TP_ARGS(folio, rwc, duration_ns, locked),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, folio_addr)
> +		__field(unsigned long, rwc_addr)
> +		__field(u64, duration_ns)
> +		__string(page_type, GET_RMAP_PAGE_TYPE(folio))
> +		__field(bool, locked)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->folio_addr = (unsigned long)folio;
> +		__entry->rwc_addr = (unsigned long)rwc;
> +		__entry->duration_ns = duration_ns;
> +		__assign_str(page_type);
> +		__entry->locked = locked;
> +	),
> +
> +	TP_printk("folio=%p rwc=%p duration_ns=%llu page_type=%s locked=%s",
> +		(void *)(unsigned long)__entry->folio_addr,
> +		(void *)(unsigned long)__entry->rwc_addr,
> +		__entry->duration_ns,
> +		__get_str(page_type),
> +		__entry->locked ? "true" : "false")
> +);
> +
> +
> +
> +#endif /* _TRACE_RMAP_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 78b7fb5f367c..14bf8483f38b 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -75,11 +75,13 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/mm_inline.h>
>  #include <linux/oom.h>
> +#include <linux/sched/clock.h>
> 
>  #include <asm/tlb.h>
> 
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/migrate.h>
> +#include <trace/events/rmap.h>
> 
>  #include "internal.h"
>  #include "swap.h"
> @@ -3098,23 +3100,35 @@ static void rmap_walk_file(struct folio *folio,
> 
>  void rmap_walk(struct folio *folio, struct rmap_walk_control *rwc)
>  {
> +	u64 ts_start, delta_ns;
> +	ts_start = local_clock();
> +
>  	if (unlikely(folio_test_ksm(folio)))
>  		rmap_walk_ksm(folio, rwc);
>  	else if (folio_test_anon(folio))
>  		rmap_walk_anon(folio, rwc, false);
>  	else
>  		rmap_walk_file(folio, rwc, false);
> +
> +	delta_ns = local_clock() - ts_start;
> +	trace_rmap_walk(folio, rwc, delta_ns, false);
>  }
> 
>  /* Like rmap_walk, but caller holds relevant rmap lock */
>  void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc)
>  {
> +	u64 ts_start, delta_ns;
> +	ts_start = local_clock();
> +
>  	/* no ksm support for now */
>  	VM_BUG_ON_FOLIO(folio_test_ksm(folio), folio);
>  	if (folio_test_anon(folio))
>  		rmap_walk_anon(folio, rwc, true);
>  	else
>  		rmap_walk_file(folio, rwc, true);
> +
> +	delta_ns = local_clock() - ts_start;
> +	trace_rmap_walk(folio, rwc, delta_ns, true);
>  }
> 
>  #ifdef CONFIG_HUGETLB_PAGE

Doing the clock stuff manually is nasty.

We could have a trace_rmap_walk_start() + trace_rmap_walk_stop().

But I wonder right now, whether we really need that information in the tree?

For local debugging (what you did) having this OOT patch is probably fine.

-- 
Cheers,

David

