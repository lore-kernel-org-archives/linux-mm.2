Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9261ECDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CEC6B008A; Mon, 22 Jun 2026 06:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD496B0093; Mon, 22 Jun 2026 06:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6858F6B00B2; Mon, 22 Jun 2026 06:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3839F6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:06:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C09151A05A6
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:06:01 +0000 (UTC)
X-FDA: 84907117722.25.184E41C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E422C140007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:05:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gwAaLIA2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lm3VHa+ibnCEVTeN7wPr7u/M30hvjlxo8BfYfr4ERzI=;
	b=M4Jsc6hzY3k6PH+yyoocKTdLUSLaID3HfLFfhDTqAWOWNofw9dUsk8wF2ndvloZ98bpm/5
	GymZR1uEqHASixYPJ8mMZGw2yE3VzoDc/7xo4IfQz1bc2iL1iYLkRohgszqTGEECnrWBSD
	2ESExPt/Fcfb67Q0kpLiYfvmboyZnnQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gwAaLIA2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122760;
	b=X8OoCYPyPj3pIgKtYiUhxV6svf5MTP7Csvs3NQKd8CZcuD1Z384jpjGs7Gwka+FBAnejzf
	LMlsV+YcXrg9Bf2+4Oi/K80+WpAiJGiiBiTvKiQNmpO9McJAaB5z/ntuGuxwEDbTWYJl8R
	KCRao9d400XAmCmMsAr8fUQhPh5T90E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 08A9F40DDA;
	Mon, 22 Jun 2026 10:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2801F000E9;
	Mon, 22 Jun 2026 10:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782122758;
	bh=Lm3VHa+ibnCEVTeN7wPr7u/M30hvjlxo8BfYfr4ERzI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gwAaLIA2n0XNgC4oeoUPyfPVSbCaXwYUdSEZ9JcTUBqvQRSsu5MdVDuFghV3YKAJ7
	 e8X/CJtFSPnVVJyvV5cYb15rVIxLHJk68dcIgn0PzLTvFSm55yZ4IVr/HgLK6YOstV
	 5s5eVJ/2qt1gpKUF0Z2rAI05gHIb2ohAd0gp5tvuReSF6RsMaL9VmDx9v22eYPRY0I
	 6N5vyAARs9uVtZapx/D8I+AieSidW7z5wHqBAHvHkLqa7GT8YNB6WiBaeQZj7FRhvc
	 hJWo1NW6ksElIsjkIMD5wvL7NmBc15gY0bq2IhBrKjolsVSj+tm8Xe+UCUI2HcG4a5
	 Q9SQ6i1S3AnKA==
Message-ID: <6ca5edd6-80ce-44f9-98c1-d84b708d5df6@kernel.org>
Date: Mon, 22 Jun 2026 12:05:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] mm: Some cleanups for page allocator APIs
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Hao Ge <hao.ge@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Robin Holt <robinmholt@gmail.com>,
 Steve Wahl <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dimitris Michailidis <dmichail@fungible.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7jg5qxhou3zkbkf9rjsatyqb9ox86m6q
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E422C140007
X-Rspam-User: 
X-HE-Tag: 1782122759-408164
X-HE-Meta: U2FsdGVkX1/qWuBnljMUQsFkdi0mASv1D8D5+9QmVRcBMeIsRY/50Hby9f2CaJY65ykadMM2/4n/u1+jkenInhu8RRjnaonH1wRFKgMiq1tS4FHet21fz5gXVd+7z9H9QEaabaatX1yZnXY2J33hlNf3OyIHCw8QRPzlABwSFJyfwSCqSR2fquWzUQaO17FQ83O33/O1M0xc5Dd+RMJZ1RUmvB4LYukGXKEBSAZm0VZ87069R225sZn70OwCaQ13QzQ3/eSlI06/njrLeJt574Gg7H0qSTY6uflFbeyecgR3hKWHvgK+pdu10CvgNCxZMbSRTQKxg8a6twVugFv6kBB6CKK1xVO5PraJsHAMB3qc0/JOD5w8ikpBG3wNTcSAomGw0/nXHDHO5KmQo8kGwfQ9tLX97ASYOMJNmrvUWH0PYZgqp6VmrTT4M3nyxGWgxhO2qeYyXXDQFYkroTSixLklxWetKGxXcc+HAncCnKLWubbhNPfQnhtJU9amHWNlNBjSoYCSz1q18z6kjC1Q6BDK6l8TjyeIvmKRdrYRlPu5ZKHOd+Fr/Km0haLw5SOoi2NEEbqaqFQVZeck7OuD3MyrespMcS0smQeiExHD+V4pyJB8e9fxL5LPAaYAxwNywrQ/Un7DwzakfSX0etQheIZrP7GqFYvrxsEAVaAMFQNUpnZPHXf2Dx2HGjMHefyRvN+SO57o1xsMmxXEAZPx3NWkphyVw/7frB6Ax17cOkR4UToClhETcxusCUO6ZVfeofLSMBwdM+t4IRnVMUBNojb+I7fjZb21pMfixlw3jjB+XqU2N4pcGUn3WqsLjFPwAgcFOAroXwPGnCRC1kavdMDxOGKjllmh+uZvEqCBK8xg/w8eUEl2MvijdiLLjNMGuiIqh2oBrq+XLoZtKPKPEcFXN58Sy75rXy5ASsuK2AlGE3nIzM27olZDGbcckA6YhEdmByZbhjeoMeMUQPG
 Y07jVqYR
 Gac5eL8VMcwmvqkxHXPWvGOmHtRkjzMIiTTCWWnWzumc6Now8bMnHcVZPnNydbyy+8Ne1VzpXvrK3dIgDPv46dhdlEBF/JTz+dyriQLaUchHpBiGwVuV0A3w7DC4JgdTp+PwLvfGKAbd3nyzArDR1kInP56kVvQD7oRd8ivj33nVeL+d1N7GwKUv3QoP0eM+QgsQOE+G9ZWfQOz1XTUCYLVsUF7ycOybPq5s9m04sl71JSUwvowmPs/BbfCURMo4GM1DmI7pR9+fJrw8iyJJW8WXqvCS5HmSWa6UJw/k3nsLZiD0hmApV6YI1ZEBpSbEmjK0+AL7YB2g59ETT2i3E/X2sWZD22nGk1OIRT/3mTwTJtnX5B/1Ejy8DBBYnhPPKoclcDziNoAv4MEANkoM6ySm5TVKQU9NSZeDsQ+cesaeImgHeyObGYFl6fN7olaxGE7TMbIrPtTIbjOqp7W6gHxOwxfH2Hb/AltR53cqpoGx2c/HYS1R97vK+lMBZP/R7QJ5/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Hao Ge for the "remove __GFP_NO_CODETAG" part

On 6/22/26 12:01, Brendan Jackman wrote:
> Some tweaks and cleanups for page allocator entrypoint and flags. This
> is motivated by preparation for __GFP_UNMAPPED [1] (which will probably
> become ALLOC_UNMAPPED in its next iteration), but all this is supposed
> to be an improvement to the codebase in its own right: unifying code
> paths, reducing API surface, and removing GFP flags.
> 
> [1] https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/
> 
> This started with unifying  __alloc_frozen_pages[_nolock]_noprof() and
> expanded from there.
> 
> Unifying the nolock allocator entrypoint with the normal allocator
> entrypoint means adding an alloc_flags argument to the later (only
> exposed within mm/). This presents an opportunity to take advantage of
> that arg to remove some GFP flags, if we add that alloc_flags arg a bit
> more broadly to allocator entrypoints.
> 
> To distinguish between mm-internal and "public" allocator entrypoints,
> it makes sense to use the __ prefix. There are already some public APIs
> with that prefix. For *alloc_pages*, just removing those variants seems
> like a nice cleanup anyway, so do that. For get_free_pages, the "__"
> variant is the _only_ variant and it's very widely used, so it doesn't
> seem worthwhile to modify that. Therefore, scope this "__" change
> specifically to the *alloc_pages* API, which means we leave the
> *folio_alloc* API untouched too, even though that could probably be
> cleaned up if so desired.
> 
> Tested:
> 
> - KVM, mm, and BPF selftests in a QEMU VM
> 
> - kunit.py on x86_64
> 
> - For the ALLOC_NO_CODETAG bits I just booted a VM and read
>   /proc/allocinfo. I confirmed that if I remove ALLOC_NO_CODETAG, the
>   kernel crashes in early boot, so I was at least booting code that
>   depends on this logic.
> 
> I used Google's internal version of Antigravity (AI coding harness) to
> do the repetitive bits, those commits are marked with Assisted-by, the
> rest is manual.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
> Changes in v2:
> - Fixed up whitespace in nolock unification patch
> - Introduced ALLOC_DEFAULT to replace literal 0 for alloc_flags
> - All other patches are new
> - Link to v1: https://patch.msgid.link/20260617-alloc-trylock-v1-1-83fd7858832e@google.com
> 
> ---
> Brendan Jackman (13):
>       mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
>       mm/page_alloc: some renames to clarify alloc_flags scopes
>       mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
>       mm/page_alloc: relax GFP WARN in nolock allocs
>       perf/x86/intel: Use higher-level allocator
>       KVM: VMX: Use higher-level allocator
>       x86/virt: Use higher-level allocator
>       sgi-xp: Use higher-level allocator
>       net/funeth: Switch to higher-level allocator
>       mm: Remove __alloc_pages_node()
>       alloc_tag: Move to mm/
>       mm: Move __alloc_pages() to mm/internal.h
>       mm: remove __GFP_NO_CODETAG
> 
>  Documentation/admin-guide/cgroup-v1/cpusets.rst  |   2 +-
>  Documentation/admin-guide/mm/transhuge.rst       |   2 +-
>  MAINTAINERS                                      |   2 +-
>  arch/x86/events/intel/ds.c                       |   6 +-
>  arch/x86/kvm/vmx/vmx.c                           |   2 +-
>  arch/x86/virt/hw.c                               |   2 +-
>  drivers/misc/sgi-xp/xpc_uv.c                     |   2 +-
>  drivers/net/ethernet/fungible/funeth/funeth_rx.c |   2 +-
>  include/linux/gfp.h                              |  28 +--
>  lib/Makefile                                     |   1 -
>  mm/Makefile                                      |   1 +
>  {lib => mm}/alloc_tag.c                          |  18 +-
>  mm/compaction.c                                  |   4 +-
>  mm/hugetlb.c                                     |   3 +-
>  mm/internal.h                                    |  20 +-
>  mm/mempolicy.c                                   |  10 +-
>  mm/page_alloc.c                                  | 254 +++++++++++++----------
>  mm/page_frag_cache.c                             |   4 +-
>  mm/slub.c                                        |   6 +-
>  19 files changed, 193 insertions(+), 176 deletions(-)
> ---
> base-commit: cbe5256a15fc26f592efb037e528da54b2139ee5
> change-id: 20260617-alloc-trylock-14ad37dab337
> 
> Best regards,
> --  
> Brendan Jackman <jackmanb@google.com>
> 


