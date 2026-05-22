Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBA2CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 07:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C726E6B0093; Fri, 22 May 2026 03:50:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22026B0095; Fri, 22 May 2026 03:50:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA356B0096; Fri, 22 May 2026 03:50:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1BE6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:50:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5ECFC1A05C5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:50:03 +0000 (UTC)
X-FDA: 84794282286.24.8CEEA03
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf21.hostedemail.com (Postfix) with ESMTP id E2AC81C000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:50:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=K4og7kt6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779436201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxcBqSnTE8QGLvd7k0gAZTQfr15WCN3mLt1C6micdAg=;
	b=Z5MccicM+MVPbnNTBLshr6Q6FhQJmvxJm7s9drwrZ+zkuoNL3g2TJU+HU7326DCRLTE4TP
	MMe56kOuDs7McBc19qkEB3sjYq8atwp3bB3X5rZVtITt/OsWQro4bIa4HcjSpb5cPkBQc8
	G3M3zJHP6Xhy/IJfFGDDHI3b2Yp/WkI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779436201; a=rsa-sha256;
	cv=none;
	b=vJ+o08aD8qzwJyA0rekyKfTDKi5WWzEJu8lfsQ0aaLHsnDAEFhl/J05iBukDeAQr3BPkhz
	l4wCXaU4/snwaTs/qPNAUP5Vt0sADS+5VDG8I0ubD7VjOEAyIx8Ffdh7vFfC1bnnuS2VZL
	KENCr9L2eo6tDborpaPC9y45UdxAXs8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=K4og7kt6;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779436195; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jxcBqSnTE8QGLvd7k0gAZTQfr15WCN3mLt1C6micdAg=;
 b=K4og7kt6gqblM70j41+tGVQJtYFeVHKvs0SxYRG2ebey1g1B3UGZV5qIjonVsEn/Bwcy6J
 T9Bc2bqdSdBUo+IQH5wiSwiaj3Yt99ysGcdGqZ9arezu/8sTEBu06CJ1JP8MJ24Rw+GoqW
 Ju3mddrydUeKNbVneT0dKWJbJav3IYRHrkgpcwE5Ilwli5XsTZydpv57I+w3KeH/Hbc01K
 lpULAtHWxnJb6HeYEVi6JqGZZ4bjtODp6D08ATU4uS8Upyp4xJ//bL2qAG2Y65/3mroxbo
 rqBtD2zxNDTjLkdtBNNKkZmMVZiQTVhT6rppm3L6alIGh920CNdrL2OPlfEksg==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 0/7] mm: speed up ZONE_DEVICE memmap initialization
References: <20260521152029.4299697d40ddc58c721bbafd@linux-foundation.org>
To: <akpm@linux-foundation.org>
X-Lms-Return-Path: <lba+26a100aa1+e083a7+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260521152029.4299697d40ddc58c721bbafd@linux-foundation.org>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Date: Fri, 22 May 2026 15:49:32 +0800
Message-Id: <20260522074932.62311-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2AC81C000A
X-Stat-Signature: fm3fo44gksrufp89aik8jt716b1mu7ui
X-Rspam-User: 
X-HE-Tag: 1779436200-594731
X-HE-Meta: U2FsdGVkX1/38EVZVvI0iX5NuHOZ90AY/i4r9FWxFhwXBIH+u/DkzWFITl77nQgo2cdRfrP18bn4BF9NHRfRqdP9LJaZbJmJFVFDRQXaVpYK+8d4r5CfBQ3RmtWCFbC7FLu9ie1w2rUPrjfBDP4O6CkpvEz8IkGKcovJ7mV4KPwNWlRS2CHQeivTUGx/To+Lbyioq/ZimlqC4yMoKHHVlClYNqVOX4rkYeWtKsKO/qpsru4QhaTreUbaFTq2+mN7KHTChJJCTXj6xakYWLhCi1VknXS4JfnE8VXCDzcmIa86VbI8w98njhx8ayj7XWMoMAJ0d8YrGEl8P9+9IoSKJrMmlNPdvXnZukm0EzQcz7ofkBtprCXObnYG5aKzD6MHxhcsPYm/8bQvZfWNzUwGWvhbxz+53od2xou1RsJ+BiYAbIjK2zNdLsbbKtWfpz9dKJMHziVf9UJqTwUa8wBnjTbAylVR9wYPu9yxxML1fArYdi1Nutc03dK6kWHIcC2ZOY92xQuo530Us8yf+Kj1Ljl711snstt/apuZFxrdhZZAfloMZXQNJlIlDskh0tvRqfbYuP4to+B1yyc0VjaXp44YuiW5Is25yFoXoVRRsGaZxW1cMWiaKYdav70KmAUx/OkOgHm2xMohtyrOjGOE2wXvh5/E7dFp1Egkg+wiubyzo1ToPrWJVTjXVfP9Sz4Ro+F06l/qPRlInL6NT/xt6E2TWCX6EDkOshP7MPlgcOl7/vdqKSpEjls7rPbI+ajmoqAK5Pq9+X00yueBhUSWPgI+3PcHfzPz7sbaRQBSlUyp1C2kIWzxWHAx9tQWtb6CyZhmVin7KeneO3+UVYCT6qEzDge29qDuO0YJnVwSAQy4ZRDWfkklsftj+igTZ7txSuFKgj9X5l+Zk5GUG+3Ft4l0XxdAc1irQZfnIv2sksxmC+LxuKkmOZe2MtGBaz6LBj0gdiVxXlmknLj36If
 zfG6Iyn0
 CtBLlVZ5P8GRzVIKdxHqNvKaWGgILSQSTHtHEHrg8E94EUZ3C4Nruofhjlnrwao29KKCw4Yu2G7gQ2KTYpD4jewPJgJI4pIPOUHOS2UI4Wg/BrvQ/GdtV2LDBchmFHF4ISvQxgNwCh35bgiXjmQumub1JEXUqsLSOtqcJrWt2RA2ekb4cDgyCoqlGuWRkPQlkNYPxV/FloW+teeIqiHcuLuHpC3YSI5WEOMp1bBYAgAOav1QpTVL1nGfZZ8RwiEK8BfCFeyi+HU0LyWwRz+InUkA5kAxKjT7srTQEvXuPsDL73/zhrpM2jBBMQEzaTrNB8KFjD4c6m1heTGxUJslpiP7cQ+TyARqUc7hjgwKWTg4RLKTBUtmSxhcgGlRh63Pis869c8VebDRKYg9PSR3aDcbYpRGnrQeRIXhm4odIkNxbbl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 15:20:29 -0700, akpm@linux-foundation.org wrote:

> On Thu, 21 May 2026 12:01:17 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:
> 
> > memmap_init_zone_device() can spend a substantial amount of time
> > initializing large ZONE_DEVICE ranges because it repeats nearly
> > identical struct page setup for every PFN.
> >
> > This series reduces that overhead in seven steps.
> 
> Cool, thanks, we all love speedups.
> 
> > The first patch factors the reusable pieces out of
> > __init_zone_device_page() so later patches can share the same logic
> > without changing the existing slow path.
> >
> > The second patch adds set_page_section_from_pfn(), so generic callers
> > can update section bits from a PFN without open-coding
> > SECTION_IN_PAGE_FLAGS checks.
> >
> > The third patch adds a template-based fast path for ZONE_DEVICE head
> > pages. Instead of rebuilding the same struct page state for every PFN,
> > it prepares a reusable page template once and copies it to each
> > destination page.
> >
> > The fourth patch extends the same template-based approach to compound
> > tails, so pfns_per_compound > 1 can also benefit from the fast path.
> >
> > The fifth patch introduces memcpy_streaming() and
> > memcpy_streaming_drain() as a generic interface for write-once
> > streaming copies, with a memcpy() fallback for architectures that do
> > not provide a specialized backend.
> >
> > The sixth patch extends x86 memcpy_flushcache() small fixed-size
> > fastpaths so struct-page-sized streaming copies can stay on the inline
> > path.
> >
> > The last patch switches the zone-device template-copy path over to
> > memcpy_streaming(). It refreshes PFN-dependent fields in the reusable
> > template before each copy, keeps pageblock-aligned PFNs on regular
> > memcpy(), and drains streaming stores before later normal stores update
> > overlapping or dependent metadata.
> >
> > The optimized path is disabled when the page_ref_set tracepoint is
> > enabled, sanitized builds remain on the slow path so their
> > instrumented stores are preserved, and the fast path falls back to the
> > existing slow path if sizeof(struct page) is not an integral number of
> > u64 words.
> >
> > Testing
> > =======
> >
> > Tests were run in a VM on an Intel Ice Lake server.
> >
> > Two PMEM configurations were used:
> >   - a 100 GB fsdax namespace configured with map=dev, which exercises
> >     the nd_pmem rebind path (pfns_per_compound == 1)
> >   - a 100 GB devdax namespace configured with align=2097152, which
> >     exercises the dax_pmem rebind path (pfns_per_compound > 1)
> >
> > For each configuration, the corresponding driver was unbound and
> > rebound 30 times. Memmap initialization latency was collected from the
> > pr_debug() output of memmap_init_zone_device().
> >
> > The first bind is reported separately, and the average of subsequent
> > rebinds is used as the steady-state result.
> 
> How closely does this workload resemble any real-world user workload?

Not directly. The unbind/rebind loop is mainly a controlled and
repeatable way to measure the memmap_init_zone_device() path with minimal
unrelated noise.

> > Performance
> > ===========
> >
> > nd_pmem rebind, 100 GB fsdax namespace, map=dev
> >   Base(v7.1-rc3):
> >     First binding: 1486 ms
> >     Average of subsequent rebinds: 273.52 ms
> >   With patches 1-3 applied:
> >     First binding: 1422 ms
> >     Average of subsequent rebinds: 245.73 ms
> >   Full series:
> >     First binding: 1389 ms
> >     Average of subsequent rebinds: 111.08 ms
> >
> > dax_pmem rebind, 100 GB devdax namespace, align=2097152
> >   Base(v7.1-rc3):
> >     First binding: 1515 ms
> >     Average of subsequent rebinds: 313.45 ms
> >   With patches 1-4 applied:
> >     First binding: 1422 ms
> >     Average of subsequent rebinds: 256.56 ms
> >   Full series:
> >     First binding: 1294 ms
> >     Average of subsequent rebinds: 110.24 ms
> 
> The improvements appear to range between "modest" and "large", but what
> I'd like to understand is how frequently real-world users are using
> these operations in real-world workloads.
> 
> IOW, (and this is always the bottom line), how valuable is this
> patchset to our users?

This is not a steady-state data-path optimization. Its value is in pmem
bring-up paths, and in our deployment we do have scenarios where
multiple pmem devices are hotplugged , so reducing this latency is useful
in practice for us.

> >   mm: factor zone-device page init helpers out of
> >     __init_zone_device_page
> >   mm: add a set_page_section_from_pfn() helper
> >   mm: add a template-based fast path for zone-device page init
> >   mm: extend the template fast path to zone-device compound tails
> >   string: introduce memcpy_streaming() helpers
> >   x86/string: extend memcpy_flushcache() fixed-size fastpaths
> >   mm: use memcpy_streaming() in zone-device template copies
> >
> >  arch/x86/include/asm/string_64.h | 100 +++++++++++++---
> >  include/linux/mm.h               |  19 ++-
> >  include/linux/string.h           |  18 +++
> >  mm/mm_init.c                     | 198 +++++++++++++++++++++++++++----
> >  4 files changed, 294 insertions(+), 41 deletions(-)
> 
> I won't take any action at this stage - let's await reviewer input.  If
> none is forthcoming then please remind me and I'll figure out what to
> do.
> 
> The ever-present reviewer called "Sashiko" has thoughts to offer:
> 
> 	https://sashiko.dev/#/patchset/20260521040124.10608-1-lizhe.67@bytedance.com
> 
> Please take a look, decide if there's useful material in there.

There is useful material there, mainly around patches 5 and 6.

The memcpy_streaming() x86 backend should be narrower, and the expanded
memcpy_flushcache() small-copy fastpath should keep naturally aligned
cases only and preserve forward movnti store order.

I'll address those points in the next revision and rerun the benchmarks.

Thanks,
Zhe

