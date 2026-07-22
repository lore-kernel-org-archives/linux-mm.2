Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB163C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 06:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18006B007B; Wed, 22 Jul 2026 02:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9266B0088; Wed, 22 Jul 2026 02:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF786B008A; Wed, 22 Jul 2026 02:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59C496B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:30:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9501C0396
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:30:32 +0000 (UTC)
X-FDA: 85015438704.19.DB8A910
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 89D5A80002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:30:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mLFJjav/";
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784701831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwMf+4RK6SICi7wthzq1GiMbIn6GQQqznOWIrXFUXxE=;
	b=XIFK7HrzeCdYQqXQGN9Y6Wa6VN3Hnc9zZa5K0tvs9v7peAKIkH5xYJrEhDfoxASFoPPOKn
	8+rW4cgA8RFUxKv5SREGC+II0PMAN2fbR2fUmDE+87jNuKXyUMeqMqYstIUcSVu0g5o4Rz
	GZwDs+/twgoaihj/UdgJpoPJj2RNt74=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mLFJjav/";
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784701831;
	b=MGo+hypfcZpziJ6IV8ngnnOJNYAK+zPWXCDyUVPORo4BJkQX7Q16ie0FLTmOFIbqhBHi6/
	MqOfh0pIWz+4k9iEkzWzudElu/KYn9F/sQfHQUyoCE0kMfYv+XAF5fiV7WEjKOC16gHHBF
	QHkJVpRxoBRO9k5fYBKyVDhQKvoSUAA=
Message-ID: <cf2e7b98-5980-463c-82df-61524ddf253b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784701827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xwMf+4RK6SICi7wthzq1GiMbIn6GQQqznOWIrXFUXxE=;
	b=mLFJjav/girYppI6ZaTUZBUHyD9kE9qq4lF8E7sra9OcZOrcnVW/Kf3W3tl4eQuqN2adyj
	FiLfkrEcHZFiMyfwHTDVh2xjPEsA5khR+vUUdVV0kReBK1zE4cYJz9hkZH9X+lAij/LgGU
	X1d9Y4dF7IaZaHo8mu5+DB4fV9UNTDY=
Date: Wed, 22 Jul 2026 14:29:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 16/18] mm: remove the __GFP_NO_OBJ_EXT flag
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 derkling@google.com, reijiw@google.com, Yosry Ahmed <yosry@kernel.org>
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
 <20260703-alloc-trylock-v5-16-c87b714e19d3@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260703-alloc-trylock-v5-16-c87b714e19d3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 89D5A80002
X-Stat-Signature: ohjb7gcro6u3h1a7b1yd8gqixdsz9ure
X-HE-Tag: 1784701830-633078
X-HE-Meta: U2FsdGVkX1/RlWekelUprkPogrLgmZRN6T06zxwdWY9Lo9MUHEf3ojodYWwNYVQk7na23uZGEWfUS7ZxpMAt0bHx9ywi7vaBjvlajfXRmF0OF7JBOqKFI/dLAB/YuVuMxLZmkmvp0WZYna9BP23w8wjKvniIZV5hi28icNykSAjSpk6ON3tkOx6nCvfKlyeylHCUMBxC8n0Onn9zSmZW7fW28t+EBoLIcGkA+dOMwddamC4uJYGOzJfcwLXxkLO9bBDZOHAQ05yCjAzE1FaN9oes0ErBX3oNLbpUfa1XlTPje0zCSA7hHxI2MuosYAIKzBKBDDdTK0TdRUIEF0NLoGg6s5AI4NRtQqgAuAMECGZzKpTDWc6dfF47m+4ncEkn8+SAm+1zAMkzyanBDougHmnxlvs7KJnWUHDDkm6V3xcU0O9EiEWoSnJRGN3VoY7jBoDt/k5Ze+B4qNfaNfodFNrO4Pq5oVcJxeLv8TqwFO1u1OW57rMEN+o3HtCdCKawIH9EEC2MyZp2J5OScd5okjp1lZqoHLglksA6vMb72a/xwWM0q7/FUSR4odVFwDTglpP0ryc8NmmuDFRv/I1FcDz8YX2X20Mh/rOPCNyFITZn61cRQXcdsn+AwpIx7qTLDOXf3YroXYlsHu7SezcSvhQEm62bKuNGWhNSmQDWgYqnfpgz6B+wNPOLGeFL78yQD+ZorBKi/kEwipOWIUz69/cdcpP0pgDT9+1n2TOpC8jhWoZgqQDBweElpuH9FnuYp6euFZgYSw/xr/Ehao3tCsRv+0FCZqj2703oTDfkAKibwnee1by7ZHxUviN11x3lUNWACwf5lWifAL0wwTcegQNF+wtX1G24q+z1M5u1S/ybybyjAKM0J8Q5tT0yrNOUq/RRZyUxjmzZSSld16xcO3SHtE1XujFaoV8+eibnvg0PzOMRBpdmUt2F8sEOFZoM8hezgN+r32haUkX34Hq
 JkTOM08B
 Q2kqhFDFiUQvEpgMfM1MiLqpygMh7mUhAtCVH8QC039Y3iprmTNeoRNTgDTN5kqnDohirIWkkymPktf1drr0n7CS1AyQFrZXbQjpEN/RO035JR5ydVhFvFQU8+b9z3kR1ZikA9GG4/J1AdGSDiOZhqUOYme8spk5wjifAhsUzGrSc/nPC2zRcMpKZfgFtADBTBsC7gf/tCK7zun99uAQtQXrkKo/6+X1kZ20d+rK4Len6IuDIopPPmyawQsAS5gbPR+3Cc5PT7s7JOgQeX8yhuJ/ZZWfiamsmlSgV2FBAwMfkWnD4CrNDkVhA8erWNPoxUpxnxAAFNM5+OAVYKif6iSLQ14xf6Pw0kLqoLLy6MAvheIRIVUux89mtaCCIki/VW+Iu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/7/3 20:31, Brendan Jackman wrote:
> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
>
> All users of the flag are converted to SLAB_ALLOC_NO_RECURSE or
> ALLOC_NO_CODETAG (from __GFP_NO_CODETAG which reused the NO_OBJ_EXT bit).
> Free up the flag bit.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> [Rebased onto __GFP_NO_CODETAG removal]
> Signed-off-by: Brendan Jackman <jackmanb@google.com>


Acked-by: Hao Ge <hao.ge@linux.dev>


> ---
>   include/linux/gfp_types.h       |  7 -------
>   include/trace/events/mmflags.h  | 10 +---------
>   tools/include/linux/gfp_types.h |  7 -------
>   3 files changed, 1 insertion(+), 23 deletions(-)
>
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 463b551d12d99..190191411009f 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -55,7 +55,6 @@ enum {
>   #ifdef CONFIG_LOCKDEP
>   	___GFP_NOLOCKDEP_BIT,
>   #endif
> -	___GFP_NO_OBJ_EXT_BIT,
>   	___GFP_LAST_BIT
>   };
>   
> @@ -96,7 +95,6 @@ enum {
>   #else
>   #define ___GFP_NOLOCKDEP	0
>   #endif
> -#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
>   
>   /*
>    * Physical address zone modifiers (see linux/mmzone.h - low four bits)
> @@ -138,17 +136,12 @@ enum {
>    *
>    * %__GFP_ACCOUNT causes the allocation to be accounted to the active
>    * cgroup context.
> - *
> - * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
> - * mark_obj_codetag_empty() should be called upon freeing for objects allocated
> - * with this flag to indicate that their NULL tags are expected and normal.
>    */
>   #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
>   #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
>   #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
>   #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
>   #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
> -#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
>   
>   /**
>    * DOC: Watermark modifiers
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index a6e5a44c9b429..c1a05ff0feab0 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -54,18 +54,10 @@
>   # define TRACE_GFP_FLAGS_LOCKDEP
>   #endif
>   
> -#ifdef CONFIG_SLAB_OBJ_EXT
> -# define TRACE_GFP_FLAGS_SLAB			\
> -	TRACE_GFP_EM(NO_OBJ_EXT)
> -#else
> -# define TRACE_GFP_FLAGS_SLAB
> -#endif
> -
>   #define TRACE_GFP_FLAGS				\
>   	TRACE_GFP_FLAGS_GENERAL			\
>   	TRACE_GFP_FLAGS_KASAN			\
> -	TRACE_GFP_FLAGS_LOCKDEP			\
> -	TRACE_GFP_FLAGS_SLAB
> +	TRACE_GFP_FLAGS_LOCKDEP
>   
>   #undef TRACE_GFP_EM
>   #define TRACE_GFP_EM(a) TRACE_DEFINE_ENUM(___GFP_##a##_BIT);
> diff --git a/tools/include/linux/gfp_types.h b/tools/include/linux/gfp_types.h
> index 6c75df30a281d..a93b8bd200b76 100644
> --- a/tools/include/linux/gfp_types.h
> +++ b/tools/include/linux/gfp_types.h
> @@ -55,7 +55,6 @@ enum {
>   #ifdef CONFIG_LOCKDEP
>   	___GFP_NOLOCKDEP_BIT,
>   #endif
> -	___GFP_NO_OBJ_EXT_BIT,
>   	___GFP_LAST_BIT
>   };
>   
> @@ -96,7 +95,6 @@ enum {
>   #else
>   #define ___GFP_NOLOCKDEP	0
>   #endif
> -#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
>   
>   /*
>    * Physical address zone modifiers (see linux/mmzone.h - low four bits)
> @@ -137,17 +135,12 @@ enum {
>    * node with no fallbacks or placement policy enforcements.
>    *
>    * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
> - *
> - * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
> - * mark_obj_codetag_empty() should be called upon freeing for objects allocated
> - * with this flag to indicate that their NULL tags are expected and normal.
>    */
>   #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
>   #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
>   #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
>   #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
>   #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
> -#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
>   
>   /**
>    * DOC: Watermark modifiers
>

