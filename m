Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D5E606A321
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Lt1XIhpQ
Received: by kanga.kvack.org (Postfix)
	id EE22D6B04E6; Tue, 20 Oct 2026 10:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8F96B04E8; Tue, 20 Oct 2026 10:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEA56B04E9; Tue, 20 Oct 2026 10:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A79CE6B04E6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:53:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6A00C023F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:53:34 +0000 (UTC)
X-FDA: 85343298348.10.5DFABC9
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 18AE440002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:53:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lt1XIhpQ;
	spf=pass (imf11.hostedemail.com: domain of elver@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792508013;
	b=EkMKGBtw9XfF8xlOk6dxGd4//W0mivxoBsQW3C/oRDV36Yq1xWzfpW3AuZM+n9D0FFV7rq
	NSQa3FFAXqL5VlU5wi+MGDTxPYp2SqnTdtUZy+18OsJ8PPbg/sDzi8078B+3tlizljI7sL
	VHCq2Qa1HfrIRqFeIGT7cLE9F3ZPbEM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lt1XIhpQ;
	spf=pass (imf11.hostedemail.com: domain of elver@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792508013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcThqUHv81EySKNyOUFRZgMbmffug3lqbPzwxJtZ+tI=;
	b=RzdjUU/8nS2WVDXyyEZdQ97CMy7VwFSTdd/LjsPPm8B+80xDtm//C6ktg6kD2umxhUil3M
	2beTE0zOsURAW4vvFveQ4l73HGX0DmmVyxjOVYZiu8+lBKVz+gvql/FdpIrmhQ5Q1wY60P
	QLvyqS8NwjKY9zPbPPAhzkYN5crvDPE=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2dc63f8d8aso557010966b.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792508011; x=1793112811; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PcThqUHv81EySKNyOUFRZgMbmffug3lqbPzwxJtZ+tI=;
        b=Lt1XIhpQTaGQ1u3ZqBZfOhwCwgUKqyPDlaJQiTnEUYcJpjbVhUS3Z4r3qD6AG2DuA8
         zxNLi8sp8cRbC2fFSkOXegJstpzbPqfMgDzN5oyaCaid46SmyL04F5YZH8KVT0AZakLh
         KLTl/tPf7q47ujIP6wb/H/XItCx02G+3Ty0g/Z2127fE6Ww+1vVQlqgeyOTJPt/gJBFf
         BinSAQGS9Uk8RlNNCbct4gZ9vS2GKygdrfEYtsmhlo279dzeWVp1bkKDsadjy9OmTZ01
         w50jKdb2H6f+ZoTc4dBFk9nh6Hb7rMPCBmifymF+IuLfwgDSl/ZBqTXvXnQ2hY0iv5Vz
         vkfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792508011; x=1793112811;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PcThqUHv81EySKNyOUFRZgMbmffug3lqbPzwxJtZ+tI=;
        b=1oxqK06gCUzQ+h1QDKd0SpxXAmRwbRsjDn08BuenqY7s4mm2WzeNFJZ3zaqGGhqtcl
         Rq2a9saUh3/gQlWbhVSyl8X/CTSZKkNl4KIOJSy4YD3EjY3Gkyazl397epWP19HUbNCZ
         W3PGCZGVsczhfxzTbJj94LLmA1rlUGMO/dxm9Idph4qevBajwv/7QYNOkcquI+jWxSKA
         jdakrDaooCSCe3W2ZJjHlU5X6YykoGRtKeczRNwe7WA0CjJgrrhc2D1qdEhDdZ/GQxfw
         5eZ6qk+NfcsbzgbA+mOAIjBOCVKEv9KevSd3rVCITC/DI1mPFBwbwj7wNxJ2G3h1XrE9
         x1KQ==
X-Forwarded-Encrypted: i=1; AKwUvBxMm0DgH1Y9Idynjmf5QZYvYyKA2n+Vi3syJvgmiJwGXmoBOffbPAUP9srwaORzEg7rs4W5HupVlg==@kvack.org
X-Gm-Message-State: AFq9FYLrseESZO0WVYojBPDiSyHQ1rUBEztJxwGIrnGM5nIVD3WOJsOR
	sD+WDx3YSxD8MH/FT5ufb30NHVfvMA6Ztnr9q70LEvDmDGFmagRoooegopzU+MPAVw==
X-Gm-Gg: AYBFou1oxZrtbPv+w5mbCV6VGnlE0JsuM4vcYiGf0m0fARufl2RRWVa/5hf/UWGjCl/
	g7y/CSEfHmL7XEYrZahUnM7mYDEYlMljkb6pYKvMKL/A9EDKa+M6VG3vsVqEA4d9g3BF2JxcAw3
	5OT2ptVR0GJ+PESGkB4xWZ5qgJ/OgEnkq73x5l6RbIQHihDlWMbdnxgRNETTEjkYsJKLxksQ8vx
	BOdgIPWjDbPJ1Vv5Phvq0zbFw20RIf+apS/3UdvajoOsLWiYb/+LjT8hNbKOH8fi0QVQs/KjY+G
	ZVbUbaHSJlV85F9tNcMMwMitVeuyc2l/MR16+VVWEsrc6tQtyUNTEErMkYM+QV5ESXaTRkljD2t
	OmxjkxFxfuq8NKAjgTei6iQanT9qquZVFSgWV3TuTyK2CXkSYQKzUYrpQKISezpzQL/6zlRUhPe
	/N16opR/YwK7NdwGLZhravfc4qLeAVsmYLmck39rbB0fkjC5jDgWaX2+YlDM0E63up5j5m7XIuv
	05/UIfQ2kocEeVT0rmdTQjRSKNoCbuk+Ne6F/u+gwN6
X-Received: by 2002:a17:906:7953:b0:c2e:2252:6ddb with SMTP id a640c23a62f3a-c419d540411mr840520166b.10.1792508009154;
        Tue, 20 Oct 2026 07:53:29 -0700 (PDT)
Received: from elver.google.com (124.100.205.35.bc.googleusercontent.com. [35.205.100.124])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1b140fsm5516530a12.9.2026.10.20.07.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:53:28 -0700 (PDT)
Date: Tue, 20 Oct 2026 14:53:24 +0000
From: Marco Elver <elver@google.com>
To: Caleb Kan <calebkan1106@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 05/11] kmsan: report trie-backed stack depot traces
Message-ID: <ateAZGtPTpdBDSbn@elver.google.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <20260908-stackdepot-trie-v2-5-1996d5cef732@cloudflare.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-stackdepot-trie-v2-5-1996d5cef732@cloudflare.com>
User-Agent: Mutt/2.3.2 (2026-04-26)
X-Rspam-User: 
X-Rspamd-Queue-Id: 18AE440002
X-Stat-Signature: z85j8ojkfqumd9yexihes9y17ku8w13x
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792508012-863553
X-HE-Meta: U2FsdGVkX1/BBEaW0WR4gJ+jAV1bv+Pb+Htpa3HwUUaVdzJ2egE2LyqY5SsPnNLIm1t0lRaEhun2WfUE2eGXUzR+M+65JjWQ0YDPW1MvA0W7SZdaGFO5zACQo3RpHeA/+Y65yErVasTDqorGeTbEoGKiqjE0N5SHpygrHhGhYEL8M8WhfYB0gARzNBtNMNVdKBrjiwVj1d1/jfcpMUWBHaPhMhPRYQTVR9UiX/VZ6pU06YpUS6M96QKcyery+jCE7Yy7eadPLbL6Kxb/xzYjOrryUhfPUMVCBUvXUeHwjgD4Wl8tFSwvfFgS2v49s9W6RiGrK/2Tpyrxps3Y1Ay0ENOsoZAIaerRtgCtEbL/wGz4vmDEV2ARqN7xTL/hJBjeKCizn7HEmjAiKH/ou0B+FS8sOFWhwtRep2bG91P2fIc8RyJR0bn7E2kCq0tL9tlmPFrQdXBsu8GFSkQUuZlYJV2p0AmHrkzRlFFliLJC48uz9ZUZF/utF5zOATs7t5kD9PDrqr+bCiZeSJDY2DTpIysKZd3gzDbcO0wOBYO0Bu10mD1AEfrWlRw8cq9Mj0ULAHuyLEkJoma8zflPaBBqNsOXlm8H/Y62Vyr3b4gr2vMIb8iGvWqbH856WADR87WWawnmEeRbRl/S7PC51hUUPrI1V9/5HvdouSAjutEIw6dBFW/RalmzdD2s7+ESVmbN8noG0bE3s55rb/sEmug3eShIxCATMzNBWTgwbZDcbJVJtr4sdO9/ehJ3bciAfNVREdu/pst0cja5pQY1jQ/NUdansaE8qLotN848mRC9Bb1rKcSRqpB3H1N4dOoGnzcMrxEikoQIva9rUtUDOiDfqGKto2feBArOTGCj68aU39CD4YvzCkquxJZ5smT2IOl8PA/4hDJrJD0hWVK5JXee0yaQq7leNew5uFNKINkAn9Ab9ml7ODuY9GFDpoInfozt9tkwESNjLDp1acFza4c
 BinL6b+c
 xJFB6inO+mgPhqUuU+X5Ve2nFWVmeAtvd6CwyCIs/wm01hx0EsC4Kj266RV5iWwudIuwM2qyHgv8CnDfrJ6Vz5L3syeVQyTk3F2Upm6FCakmTg0GjLX0kRIyJNj7sP6a5tw+3dggrU5BDh0bmWU0YDuPCzp3nNUCbVgPVLe269vRf4dVIctYT1Piqoz8v5EKKQr6EW6/h1dNhPbL6sMKUdZCwEX7iRsVguG82Zw1iMmtBiMGqGXDY7W92yDx/Zbeg0/alHiYUfoe1HeX5RwSzjoZ9zUE/3a0VjpHnrrg3Hcdxlxur7xrIBAer1Mbo4mWyxtlG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> From: Caleb Kan <ckan@cloudflare.com>
> 
> KMSAN stores ordinary origin stacks and synthetic alloca and chain origins
> in stack depot and retains the resulting persistent handles. Once trie
> storage is enabled, these handles can refer to trie-backed entries, while
> kmsan_print_origin() still relies on the hash-only stack_depot_fetch() API.
> 
> Use one KMSAN_STACK_DEPTH array to materialize each origin and chained
> stack in turn. Preserve the chain's head and next-origin handles before
> reusing the array for the chained stack. The array covers both the regular
> save limit and the smaller synthetic records.
> 
> Pass the scratch array into a common origin-printing helper. Keep local
> storage for standalone kmsan_print_origin() calls, but let kmsan_report()
> reuse its existing stack_entries array after printing the report stack.
> With x86-64 Clang 19, the regular nested report path uses 752 bytes, below
> its 768-byte size before this conversion.
> 
> lib/stackdepot.c is uninstrumented, so stack_depot_fetch_into() unpoisons
> the successfully copied range before returning it to KMSAN. Remove the
> now-redundant explicit unpoisoning of chained entries. Origin depth and
> use-after-free metadata remain in the handle's extra bits and are
> unchanged.
> 
> Update test_stackdepot_roundtrip() to use caller-owned storage while
> retaining its frame-count and kmsan_check_memory() checks. This verifies
> that the copy-out API returns initialized entries to instrumented callers.
> 
> Signed-off-by: Caleb Kan <ckan@cloudflare.com>
> ---
>  mm/kmsan/kmsan_test.c |  4 ++--
>  mm/kmsan/report.c     | 28 ++++++++++++++++------------
>  2 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
> index 31f47cc4dab4..7c04e4b21873 100644
> --- a/mm/kmsan/kmsan_test.c
> +++ b/mm/kmsan/kmsan_test.c
> @@ -669,7 +669,7 @@ static void test_long_origin_chain(struct kunit *test)
>   */
>  static void test_stackdepot_roundtrip(struct kunit *test)
>  {
> -	unsigned long src_entries[16], *dst_entries;
> +	unsigned long src_entries[16], dst_entries[16];
>  	unsigned int src_nentries, dst_nentries;
>  	EXPECTATION_NO_REPORT(expect);
>  	depot_stack_handle_t handle;
> @@ -680,7 +680,7 @@ static void test_stackdepot_roundtrip(struct kunit *test)
>  		stack_trace_save(src_entries, ARRAY_SIZE(src_entries), 1);
>  	handle = stack_depot_save(src_entries, src_nentries, GFP_KERNEL);
>  	stack_depot_print(handle);
> -	dst_nentries = stack_depot_fetch(handle, &dst_entries);
> +	dst_nentries = stack_depot_fetch_into(handle, dst_entries, ARRAY_SIZE(dst_entries));
>  	KUNIT_EXPECT_TRUE(test, src_nentries == dst_nentries);
>  
>  	kmsan_check_memory((void *)dst_entries,
> diff --git a/mm/kmsan/report.c b/mm/kmsan/report.c
> index d6853ce08954..0770658ba932 100644
> --- a/mm/kmsan/report.c
> +++ b/mm/kmsan/report.c
> @@ -83,9 +83,9 @@ static char *pretty_descr(char *descr)
>  	return report_local_descr;
>  }
>  
> -void kmsan_print_origin(depot_stack_handle_t origin)
> +static void kmsan_print_origin_with_buf(depot_stack_handle_t origin,
> +					unsigned long *entries)
>  {
> -	unsigned long *entries = NULL, *chained_entries = NULL;
>  	unsigned int nr_entries, chained_nr_entries, skipnr;
>  	void *pc1 = NULL, *pc2 = NULL;
>  	depot_stack_handle_t head;
> @@ -97,7 +97,8 @@ void kmsan_print_origin(depot_stack_handle_t origin)
>  		return;
>  
>  	while (true) {
> -		nr_entries = stack_depot_fetch(origin, &entries);
> +		nr_entries =
> +			stack_depot_fetch_into(origin, entries, KMSAN_STACK_DEPTH);
>  		depth = kmsan_depth_from_eb(stack_depot_get_extra_bits(origin));
>  		magic = nr_entries ? entries[0] : 0;
>  		if ((nr_entries == 4) && (magic == KMSAN_ALLOCA_MAGIC_ORIGIN)) {

Routing KMSAN's synthetic alloca and chain origins into the trie (patch 10)
breaks KMSAN after 1024 origins:

	__msan_poison_alloca():
	    entries[0] = KMSAN_ALLOCA_MAGIC_ORIGIN
	    entries[1] = (u64)descr   /* unique per instrumented local variable */

	kmsan_internal_chain_origin():
	    entries[0] = KMSAN_CHAIN_MAGIC_ORIGIN
	    entries[1] = extra | ((u64)id << 32)

Because the trie in patch 10 is keyed starting at entries[0], *every*
alloca origin in the kernel is a direct child of the single depth-1
[KMSAN_ALLOCA_MAGIC_ORIGIN] node, and every distinct stack handle is a
direct child of [KMSAN_CHAIN_MAGIC_ORIGIN].

In patch 10, a node's child array cannot exceed 1024 children
(roundup_pow_of_two(1025) = 2048 -> 16424 bytes >
STACK_DEPOT_TRIE_POOL_USABLE_SIZE = 16208 bytes). Once 1024 local
variables are poisoned during boot, every subsequent new
__msan_poison_alloca() and kmsan_internal_chain_origin() permanently
returns 0.

Even below that limit, a 3-entry chain origin takes ~120 bytes in the
trie (node + child slot + side-table slot) vs 48 bytes in the hash table.

