Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE21C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213406B018F; Tue, 18 Aug 2026 09:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB066B01AE; Tue, 18 Aug 2026 09:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101076B01B1; Tue, 18 Aug 2026 09:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D62A76B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:18:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64AE2C0150
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:18:20 +0000 (UTC)
X-FDA: 85114443960.28.7A0FFA1
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 629FC140008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:18:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rqk79PPz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of elver@google.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787059098;
	b=Zr398l5IwsJ9EHXC/+5aqkiJGF3z/GJLATVvxoTUUCwsjXPZObl4U1I+ZyzSUA5lEECvq9
	dRU2Yk6fvkRC0NGNjFw+slAIvbcKRQieHdclQOPfER4xs5SeRo/yQkRSlAwUXMOHloqefk
	xyf7p17shp0xUlC9E3oqMSTkdh9OZho=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rqk79PPz;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of elver@google.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787059098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YGdbrHZ2xHHc51OhWhdUV4Z16QPPs1BI9atgQRGBQI=;
	b=NHcTnqCEi6YSvo/Aiu5AygILK1a8N/SQY1Fc7d7AdtPQkqtL9idhdSK/xaPQoZfWBNXqxZ
	lhZwN7ZX5spI2pd6o1b56PGvLVm+yQFWVJVyde8IAftDVaBjPrDU6mzivtIeIbPTQEa06C
	xJVgcnC2IFlOFjEx34cxM4eqHQvzxuA=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so4763436a91.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:18:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787059097; cv=none;
        d=google.com; s=arc-20260327;
        b=LJVq05bMTtsU2416pnT3nzd/bFeR4wEW3GvHRNqJ66UFwe36yj4N7J1TGbZyRUNXhI
         GSPLBW/GrsPIn82yRTNrCpjkXBgsixv5qKBg79PeG4UC/oiAD5w/LYPEtMXjcQMmADvZ
         8aP3l1pkgRfFJVtY5EtbCi3hzpR3wUAF6/qYxXkNL53gv2h4MF9Ee4AlKotmrhiiJd5F
         +yQb4xMalD96XiP5a+v/+NHkScZxLoKVRB6E6UFl/nOWPVJfU3vymY7A86VecAnTwX+E
         cEiymxq8LKdtqD0v3X4YFNUALCbf6WaDfCby/EOUIIG5/PL8vhUzIVwc1fgZHroeLAEs
         B+LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9YGdbrHZ2xHHc51OhWhdUV4Z16QPPs1BI9atgQRGBQI=;
        fh=xTw6caK7wMEcPXl5ellghLlWbzcS7he4Cr2jm38+lsI=;
        b=ksuGSuBV+CRpTOSBcLfa/junGuSFV0RBuTvcH/LtvRvA7ahpBFxF2TKyCk35lDHaIq
         pXJGVgyUhnUsJUWbK/aHz0lJwhyCD7i4bgJL3MYD1Xq8zRPgq+38ejMNDroe9D7iln60
         l0xazD9JabCpg+XEvAZye45YJi39Q8/S2JMuW/H/CtMs2OzIiJIYeUBzrYdwA1I7AE26
         zEhfdbqzyVcdgx0uxsqh5GW8DIYJGsDf7oa5nBXT6sYF2X20+fl0O/NKMe6MiSg2kFC/
         BNJDVbSb1zH83zaYMYFfDbrLQ/ipiA3JLK2gRLGRCPOUkU3BjImHrVoFqx3MBSL8ys+x
         SV2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787059097; x=1787663897; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9YGdbrHZ2xHHc51OhWhdUV4Z16QPPs1BI9atgQRGBQI=;
        b=rqk79PPzH75SyuQBdx6IdKxH4GMKhZcc2YLMJQjjO0VzTR1+vIliX0M4RJx2BLPIVe
         ONA2O87+XSme0nCBdRPveGZTXWYfd5b3CYW4+EDzg3glUFH7bhXt9QSQGM2zcQ9CT1q/
         +x58zHxCkSNGJkPsRsFQD/wLXPy5TR9pP3kVuMTCFRdEEe/tNFElVsRt443whGstOe72
         6paC91wghvJZo4xPztXqV8Udz+5tbO8jM9T3SsueZscBnSDJyox39lxF5/hrhZXyTyC5
         sEHn4pYFdNNtQTyso/whz4HtT0fiQXs/iXXeuICa2Su1yP7wZQvdbDJ7bfhWbK41ICg0
         FM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787059097; x=1787663897;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9YGdbrHZ2xHHc51OhWhdUV4Z16QPPs1BI9atgQRGBQI=;
        b=lxpSEmXzNQcqLGqbuLV9XY5wqf9/HKHNWdf/bVynCRVKRdlAuMc15W+mNUZdu/sbHf
         O0DHpC4/bMQeVofnBNcDVh0IU+4v/Dku8zlFWf3xoHZ59DnnCdiN/gVvjHxZTTeM+Jzg
         Vd55ZtPytAiZkkmlzR81KluTV3xdXAKFqGvcpC0SlXVNr3gQ7G5/MIGGyuVpkd4D5jTi
         RVc5cloSMKvYygog3WalwSLuA+EHjmviU/D25nBZfZ0MlEcvSiRs/oAl8Vm2VzRd7366
         OYGhpctcAZVx1F5v+Owr1A5sIxO0tQAQkSeBqWycRzE9cWJsxs2XWsChQgHKrvy63Nal
         JQXw==
X-Forwarded-Encrypted: i=1; AHgh+Rq0S4TCE76lMAjov01PJKvIxuVmobMYW+E1pWCL583E18jZ4LPbqDhjLyAfLHebULz//7ir9sCUvQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2YXBEFGyLk8ThC2/TdwNjt87HVm6oSpQoG3halpkS6YX3DQSR
	m5cyztPqDQug0ZoXVHraJUsfuAV8/+jq6raMCorjLjWm8QMsQOxMmTj4I7vNKzb3HijNFjs9u9g
	1gAXb4vzX3HAwyeHesfrc4HdqzBLgNd7SQELTKEKfNPvUMaYcSWZoAHlY
X-Gm-Gg: AR+sD12FVLKkXZHAVj4JxDP5YXMA/kgAld14iOkMUPjJ5w07+Q+tKvMr6rYlXjOvo8i
	Y/iCgKRzeBwoULj01q3bverZKUPUiCUV/4ZaXb1Xr3ppvNHTD3zhaLN5Un6OZXim9B+xU9a6I4f
	btu9E2AmvfJs76TVJuKlNEJHBCjBCzRtsiHeGMugDfEKX17qCWHm6Jo8oCodRyOoCYpVr/FSArU
	KUFD1/DBbj43dkg+GgPasQTuWKvIVB9BEg/NAiiyWkuxe1Lo+wLNfI7m9WSxtBiPHwHw4aDukNy
	c1mbA+4cxpwxgNPV+lOQDsN+18aaIYiOe+WsQPDyPAglixrvx87V3ZZCzJSQqDY9swP4zxcHh6Y
	=
X-Received: by 2002:a17:90b:3b42:b0:393:19a3:4e5 with SMTP id
 98e67ed59e1d1-3933e638862mr32133189a91.16.1787059096444; Tue, 18 Aug 2026
 06:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
In-Reply-To: <20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com>
From: Marco Elver <elver@google.com>
Date: Tue, 18 Aug 2026 15:17:39 +0200
X-Gm-Features: AcwNN1UFzd_a1bKXbmGgsiIGwORA-4Taja35azlRkzS-LUGlT6KhEoaqhhQPntc
Message-ID: <CANpmjNP4T=bov8gHN8cd7WwvE3daRGuwK+CmC4aEueCi20xRyg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/9] Path-compressed trie storage for persistent stack
 depot records
To: Caleb Kan <calebkan1106@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 629FC140008
X-Rspam-User: 
X-Stat-Signature: dwcpe3c1nkth98hi96kmnndu8zzw4kxe
X-Rspamd-Server: rspam06
X-HE-Tag: 1787059098-246064
X-HE-Meta: U2FsdGVkX19drCQzY3fDaWbIkgSbo0iD7wW35KyDF1pejgFi3jb3SLGDt/FhYPoJ9odVlQN5CYm7jNqCp2Z9Hjipecuq2jnsHOzrjXUUVBmiyTvUB66+OA4sRq2/MgNzw1pKDlhz6MXzCXnVyXjDywVRFsHPMQzRhG4YbI6HIKqgce6vj8vzHbh0QWv4At06EtmQ5GPXp6V4+Ea0q8mfTLbT4BcnwrJfApbWr00ulMX1d829FXMESSWQ762FFae/VDF9lrJuARJL7i18RZeiT0BOpdw39AtSPHPPNoDXoqdldFRMq59/TMKI7Ps25WqeduQH5hAznjlAWLXsI24SjFSnGne4OEbQxbZQHDSyPwwMfoySbLc4NQIxKXDjvE+jh196HwVzfhDAA8z2xqGzAKnDX9RCJlpxAoEbud01HukLAgxJiDYY2ZAVEqy0zX6hB4LvdmtHoO5tbF/lkihPMZMpHvaMLtc7PZrjtwSbs2rgGIjBdP2WUsA/ZORHLIHeqxcBM+dro+N9GjFo6RL9VzIcEBSpbPN0fhtW+bgVXeCfVxutKzXqb69W40JLpO6LvdlLd/getjYl5ANkuXdpm6ZNIUlhHbbE9yR9CbfzIiYCWG5kwL8lZVXJjJcroPyE5xVDBX3wZCQOL6KkaF6w03re1RuduSzLpiXzhuZzMvrKtOnyHNNE54CK5SzWbTeVZtvNC+sMBxn01IO0zj5C4P+5zbQjFJJ1SFbXk8WBw+Jnyng6CuhX+VNA19sBs5kSLW9JJ+0h7qvt4R/7jLjhgYzLXtGdZ8mpoqP3drOoZcKaZHZO1/37xkc/ID2k8byaJIF2V6H0MBU1zQCfBeAV65Lq50bMm0vDzEC6ANZYEEGCltQEKVXz39fjFGSTrqFvpymLuvqFbo2C7yPL/VPDDWma98RmB/tvdk9nCqhcgFOlZszIV4TpjdfIjFv7dutSx7LKeksT4gIo0Lhyboj
 6Iughrb8
 c+3UqUWNI4atyh3vsoTm+jbbylPa6oI09i37NCXYURWVObX7/lInLKFrDRxLKxnIFeTlgZvy09/DMxagcmXVWH6j8ZqdziKRvT24m4/e9cJGSzJQmZiCzR3+XBGI9JhDShow0H6OCLl2xTdvGSNfpSki1YSTXU2OGYlC2ptqQ9H0s+lkfk3WKpES5NWwMpr4jwFYouOlrloaLxh1SC/I70b/yfPwctDsGBWX5pfR9w6evpn4oUaNEm3NB9JGF1q3KJ5pIvh01P/U0NdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 at 14:43, Caleb Kan <calebkan1106@gmail.com> wrote:
>
> Hi,
>
> Stack depot stores kernel stack traces and returns compact handles that
> diagnostic subsystems can retain. Some subsystems keep those records for
> the lifetime of the system.
>
> The hash backend deduplicates identical traces, but stores every distinct
> trace in full. Allocator and sanitizer traces often differ at only one or
> two call sites while sharing most frames, so the same frame sequences are
> stored repeatedly. This can exhaust stack depot's fixed pool budget; once
> that happens, new traces cannot be recorded and diagnostics lose stack
> information.

Stackdepot's design involves several trade-offs. Changing that needs a
clearer motivation, in particular, which problem did you run into?
Which problem were you unable to solve due to stackdepot's current
design?

The fact we potentially exhaust the pool is known, and the easiest fix
is to increase the max number of pools. Compressing the records
introduces a lot of complexity, whereas the simplest fix is to just
double the pool size. Which environment are you targeting where
doubling pools wouldn't work?

> This series adds an opt-in path-compressed trie for persistent,
> non-refcounted traces. Related traces can share common frame runs, while
> records that need refcounting or direct count access remain hash-backed.
>
> Backend policy
> ===
>
> Backend selection follows record lifetime and API needs.
> STACK_DEPOT_FLAG_GET records remain hash-backed because refcounted eviction
> requires record and handle reuse. This series adds
> STACK_DEPOT_FLAG_COUNTABLE for page_owner, which needs direct access to a
> record count. COUNTABLE records also remain hash-backed, and identical
> countable and non-countable traces occupy separate records. With trie
> storage enabled, traces saved without either flag use the trie and remain
> persistent.
>
> A trie-eligible save that is not allowed to allocate, referred to below as
> a constrained save, performs one lockless lookup. It does not wait, take
> the writer lock, or insert a missing trace. A hit succeeds; a miss returns
> 0 until an allocating save inserts the same trace. A trace seen only from
> constrained contexts is therefore never recorded. By contrast, the hash
> backend can insert into available pool storage and uses a trylock when the
> context cannot spin.
>
> Trie insertion failure returns 0 instead of falling back to hash storage.
> This keeps eligible persistent records in one backend and avoids hiding
> trie exhaustion by consuming hash capacity.
>
> The hash and trie backends draw from the same physical pool array and
> stack_depot_max_pools limit. A pool assigned to trie slots cannot hold hash
> records, so trie growth can reduce capacity available to GET and COUNTABLE
> records.
>
> Design
> ===
>
> Each trie node stores a run of frames, and branching occurs only where
> traces diverge. Children are sorted by their first frame and found by
> binary search. A node at which a saved trace ends receives a sequential
> stack ID encoded in the handle. Such a node may also have children when one
> saved trace is a prefix of another. A sparse side table maps IDs to nodes,
> and fetch reconstructs a trace by following parent links.
>
> An architecture hook encodes a frame in 32 bits only when decoding exactly
> reproduces the original address. arm64 stores a signed offset from _text,
> and x86-64 stores the low 32 bits when the upper 32 bits are all set. Other
> frames remain full-width; the generic implementation always uses
> full-width frames.
>
> Trie nodes and child arrays occupy contiguous runs of 16-byte slots in the
> existing order-2 pools. A writer lock serializes insertion, while RCU
> protects lockless lookup and fetch. Each insertion reserves all storage
> that can fail before publishing a stack. Unpublished reservations are
> released immediately. Replaced nodes and child arrays carry an RCU
> grace-period cookie, and later insertions may reuse their slots only after
> the grace period completes. Pools, stored stacks, and stack IDs are never
> recycled.
>
> API and consumer changes
> ===
>
> Trie records are not contiguous, so stack_depot_fetch(), which returns a
> pointer into depot-owned storage, remains hash-only. Add
> stack_depot_fetch_into() to copy either backend into caller-owned storage
> and return the number of frames copied. An undersized buffer receives no
> partial trace and returns 0. stack_depot_print() and stack_depot_snprint()
> also support both backends.
>
> Kmemleak, KMSAN, SLUB, and DRM move to backend-independent accessors.
> page_owner remains hash-backed because it keeps stable struct stack_record
> pointers and uses the record count for base-page accounting. The GDB helper
> rejects trie handles instead of interpreting them as hash pool offsets.
>
> Activation and limits
> ===
>
> Hash handles reserve pool-index values through stack_depot_max_pools; trie
> handles use the remaining values to encode stack IDs. Increasing
> stack_depot_max_pools therefore shrinks the trie ID namespace. With 64 KiB
> pages, the default maximum reserves every pool-index value, so trie
> activation requires lowering stack_depot_max_pools. If optional trie
> initialization fails, the hash backend retains its configured capacity.
>
> Patch 9 adds the default-off stackdepot.trie_enabled boot parameter.
> Keeping activation in the final patch leaves the trie unreachable while
> consumers are converted, so every intermediate commit remains safe and
> bisectable.
>
> Testing
> ===
>
> Stackdepot KUnit passed with trie storage enabled on arm64 with 4 KiB,
> 16 KiB, and 64 KiB pages and on x86-64 with 256-frame stacks.
> PROVE_LOCKING, KCSAN, Generic KASAN, and hash-backed KMSAN configurations
> also passed.
> Trie-enabled KMSAN reproduced the documented constrained-only misses.
> Arm64 boots passed with trie storage disabled and enabled, including a
> Generic KASAN plus PROVE_LOCKING configuration. drgn stack
> materialization and integrity checks passed in both backend modes.
>
> Results
> ===
>
> Kernels built from the same revision, with 4 KiB pages and KASAN enabled,
> ran for 61 to 67 hours on one trie-disabled and one trie-enabled machine
> per architecture. The workloads and stored stack populations were neither
> replayed nor matched. Record counts and per-record values cover only
> successfully stored persistent records.
>
> The x86-64 trie-disabled machine reached the configured limit of 8,192
> pools. The corresponding trie-enabled collection observed approximately
> 1,943 pools, or 23.7% of the pool budget, but that collection raced. The
> full observations were:
>
>                                        arm64                    x86-64
>                            trie disabled   enabled  trie disabled   enabled
> Uptime (hours)                      60.9      63.9           64.5      66.9
> Stored records                  ~161,819    87,088        497,600  ~217,163
> Registered pools                  ~2,632       925          8,192    ~1,943
> Pool budget used                  ~32.1%     11.3%         100.0%    ~23.7%
> Backend bytes/record             ~266.49    182.44         269.73   ~154.76
>
> Values prefixed with '~' came from collections whose start and end markers
> differed. Those collections raced with concurrent updates and are unusable
> as coherent snapshots or integrity-validation results. They are retained
> only as approximate observations.
>
> Backend bytes per record include pool storage and backend-specific
> metadata but exclude fixed allocations shared by both configurations.
> Using the approximate values in the table gives 31.5% lower backend bytes
> per successful persistent record on arm64 and 42.6% lower on x86-64 with
> trie enabled. Given the limitations above, these ratios provide directional
> context only, not matched estimates of memory reduction. They also do not
> establish equivalent diagnostic coverage because constrained-only trie
> misses are unobservable.
>
> Both trie-enabled machines remained up throughout the observation. This
> uncontrolled soak does not support estimates of CPU overhead, system-level
> memory pressure, or overall performance.

It sounds nice in theory, but you omitted the most imporant question
most reviewers would have: what's the performance overhead?

> Feedback requested
> ===
>
> Feedback would be especially useful on:
>
> 1. Whether lookup-only constrained saves, including the loss of traces seen
>    only in constrained contexts, are acceptable for an initial version;

Not great; I'd expect changes to stackdepot internals to retain
feature parity and no changes in observable behaviour.

> 2. Whether stack_depot_fetch_into() is the right migration API while the
>    pointer-returning stack_depot_fetch() remains hash-only;

I don't see a better option. One issue is that we're increasing stack
usage where stack_depot_fetch_into() is used, which in some contexts
is already very constrained.

> 3. Whether trie and hash records should share the physical pool budget;

The upper bound on memory budget should not change, and we shouldn't
silently double the budget because there are 2 pools.

> 4. Whether the 64 KiB handle-space limitation requires a different trie
>    handle encoding; and
> 5. Whether retired slots should be reused only when a later insertion
>    observes completion of their RCU grace period.

I'd assume so, otherwise you risk some lifecycle violation?


Thanks,
-- Marco

