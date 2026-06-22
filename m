Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B0ACDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25DB36B0088; Mon, 22 Jun 2026 06:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235A96B008A; Mon, 22 Jun 2026 06:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14AFD6B008C; Mon, 22 Jun 2026 06:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D777F6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 312C0A060E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:45 +0000 (UTC)
X-FDA: 84907106970.20.04324FF
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id 50E9320002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Gx/fmo8E";
	spf=pass (imf31.hostedemail.com: domain of 3Awg5aggKCFA1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3Awg5aggKCFA1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122503;
	b=TaM853pnYyREdEFXsSsNd9KqLkCc6NXPTFg79HA7x0X/Y/vwXaUtdCZMViniNwTA0oN6UZ
	l2tZ5E7sIbGPm/rz077sRQD0miJWQFOR/sacOP0twi9GN+4SN9XDz4Tx/nuQuSYij1P5ji
	w3Ai4D7NDO2PIAPtmyMFMsZVUf9jYac=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Gx/fmo8E";
	spf=pass (imf31.hostedemail.com: domain of 3Awg5aggKCFA1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3Awg5aggKCFA1su24s5ty66y3w.u64305CF-442Dsu2.69y@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HyN6/V2JO4AYCUsSUM4Fyt9cHVBJWqwO25DnwWB+tqc=;
	b=gQqwkxi5PjEbJS6yCu9a8fnRWkYO3Wotd3GpcBjYItRmyq2vLvCvuRxJzigvH+S8Rjr3iD
	lAoqSgL6yBtbCYaxtwODAZ7lWopNoPItplybRKd5Y5wshuc0K+mZbwOxk/O/11uJ+5hNVl
	kPSO4aon6+WjMsGzaSe3NN+RpTszP+g=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c0db30ce19aso109303666b.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122501; x=1782727301; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HyN6/V2JO4AYCUsSUM4Fyt9cHVBJWqwO25DnwWB+tqc=;
        b=Gx/fmo8EEl02lI3krrLPnoybC1yos4nZ1LRdLvrRh4gXv70ysXkSAlSVPCtdRoNxto
         e+EJChhVrMrrH1O/X+IcJAY9DamTc304NLRcgjklWTggDapWd2RDnWAXG8Lb+y8A5MQX
         jIiaoPDMay/hDzBWZyRartqzvvfv28dYYOWHOZn+dnMbF/BETA7I8/uRTfrvoOuo6vpJ
         Vvv1EAQQ4cUzM1EMFJW6t6vgYTsh2sVaDJfJIvaLXwW53JNY8pQnB3ydrnTInoYI5Y1t
         KammmBcUsS1MtdTmWCYUbnBfIAD9O4tINZeeDfMS37xXLGDcZMnX10NB3QdKguLxamoZ
         HbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122501; x=1782727301;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HyN6/V2JO4AYCUsSUM4Fyt9cHVBJWqwO25DnwWB+tqc=;
        b=hgaQcd42IO3FIQnH9CGw6UPRvITHOXAHfUREwkQkx53ecX2fnwWbM3ZPZiTbVrYBPZ
         QQjzicHJdeDRI/NKK75jkLrVlVVmyZmQR+j7R2giU8aW+eKghnUk8gaguMIRxbSX7CiM
         QYZxT6nfPNaPIt167oMeoA0riLkG8K+NtP/abiK+rpN2WzGhQEt7Gj0M0DdWlS/fP2WL
         yU3ATsFh85PUvcHL6IeeDMKlN+aqM6S58Z/Bc2vswrc21SIgJ7vm+tOlNhOh1zxq5Uvs
         gXw2JXR8lHdYJKcEPYtM6550NfrJQgWIgk3VnIVorKXOPG0X/+Orj+WjBGWkn4Dc4ezb
         p2VA==
X-Forwarded-Encrypted: i=1; AFNElJ8B1Bnvt7poxA7sq2v5qytRTZVPCPOlTD4mUFcxUiBIOsbNVyu51vl6/LRf0qpZ13QZPzrbM6zs7Q==@kvack.org
X-Gm-Message-State: AOJu0YxNFizN64Tpq7uo8IknAsHIu02gg4rRmXAkb7tE4B0hkOMvv785
	q+Ba7vc6hSuQnOrLRPKfDxJHGO/RH0RZpIGcp9Vuza1A9mPqRmX/C4w7WFUBkflBAgRt+cctm99
	ATB0l4+dq+Qs/jA==
X-Received: from wrbcp34.prod.google.com ([2002:a05:6000:4022:b0:460:672f:ad65])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7210:b0:c0d:46ca:3ae9 with SMTP id a640c23a62f3a-c0d46ca3b73mr292642566b.3.1782122499355;
 Mon, 22 Jun 2026 03:01:39 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:27 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAPcHOWoC/3WNQQ7CIBREr9L8tZgCWogr72G6oPBL0VoMYGPT9
 O5CXbuavGTmzQoRg8MIl2qFgLOLzk8Z2KECPajJInEmM7CaNXVDBVHj6DVJYcnxIPSkDBdGdZw
 LyJtXwN59dt+t/XF8d3fUqUhKY3Ax+bDshzMtvX/umRJKJO+NkGcpOcOr9d6OeNT+Ce22bV9+s r3vvQAAAA==
X-Change-Id: 20260617-alloc-trylock-14ad37dab337
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Subject: [PATCH v2 00/13] mm: Some cleanups for page allocator APIs
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dimitris Michailidis <dmichail@fungible.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50E9320002
X-Stat-Signature: 4kk54suyj8rr6fdpugwm4peewc9kfxwr
X-HE-Tag: 1782122503-311988
X-HE-Meta: U2FsdGVkX1+UZre5RGsJEDhMVBNo4fosE9rmd6MO/go03yCATwmN84dA0YGi+yBoer9Lin7Aimu1gttgIKFVe1+cGEGyiq4Kxt8XDHotQL2bwrSZigKZWoJGffEeZbUIsXpWj48wbu/wcUft0y2dJ301El3xa29fPT8fnImc3MnoAntlK/JvUgUryPhnx2mmsU/slk0EMpeBi1Dj6MqGddGS2kKU7HTqTnX/hA1gFBVlhkijK7pjn6c/6I+rU1D4JYcvjsX4ZkPlfO0uhR+WzgrpadN2a3ZZgKb11sKMW+jhavk9ht+q6ATZDauhnJmXAPSV7A+Mi2eiA38AHVBh56XwFiDlChsZ61w9E5WyHvmM0XYV5tDylAMAmwYpzv2tmxKVwdHY7oZ+EXm9CaCwKgAGJspLPwJsZsqAp8IjijDpBn8PoY95zFFsJzP2MtnR3KbxRP2jOzqwqJsgj2bOmGzImPm97DTUGTngQdsPxQOdmBzj8//jFgnZT4Zitaug3LKmMCKxKWz/2yHiRgmCHixWRSnmBSCuSxUYSObY1y1vL+QdSmYfi//RzInolEdSYWXnAQfKSM1/R8YejgBY6SmdPH2QyrfLklxoJQLW0vWtXTYfzow4jeTlUkrPCgVkGXLtd3ypXKgcINgq3jeDfpc7rGyKRHvS9tmhQ2zPEmREMoNx/DN5bvpODeSoKZ5LAJvmWtiF1hPYpK5qAcgu+c7UYxwPXb/MiK7fdlubblXr3mrn05qVVAVCkF56bQDfyzoZZaImKLRQcXxsU9fBCvZRiHFYZghj3ueNSvgh4vFJBasJWiHdxk2NeDHX8elZE1GCHvq1n0ytNVA7+D7WsRPi+4SOGCe9e6GfPGeuAlzCnU0FWMVB6HplEwUfVoM+eSft6zJEZBkWtiGJr9Buct4/9/6RIhcAnAD8lW5x2WLDwy2ng9Pl8SMXNw+kxr7xhms2vkZQn4Bc3St8oE6
 okVc5Y0Y
 S01el2w4EZZFAsn5X75mYZGL5tLHmRqNFkX8no7gx6ploU0u1VJ5liEogtit877vaqgp5EDCDQxmZMrZX3ZblYk7zz2QkT1JxXgPhTNT/gZwRgJTdYISdXiqvqNLkpAlITWxcKmXAXtRj4YWRuQhzs//jJVPKZhkRgnEAtdSqpUo5awHS2kasSswB7nQQV7zUUWoWQqlBvBaTuGvYk6hlfgYkOEqoGYJExdZSrisCWyF3KFYZmJlqxp02fdRbhsmYLUx6BM9FYqHoRV/iDHpSQunfN6D4ptI9XQoe2CtkBrRwJkCYSjisV/42yRvsEjz6PXfRL2lQlhlMqQuabJR1XwbHLtRfKjAbaLgPbZ+LP7rIufIk9BySMJAc8HmfQcjNhTKWdT0uVhRpzvBBtfmaeamP+jdNM6o3b5QQobIQwG2d/DaE1c85Ej6QCsZSRW4UieJN1RhMgYLGJaQEYk7IqKOq9qW1k03YRmA6hORJ2249rYGOxN2x/asSk7N3Xsj4S9JgQxlsq+gxYP/QCItfAYReVDv3k/A6IOL/g4jhhBkcp+/suyMeGS2D1mEY8t4CelBbHY0nd11HTN7M6scslcen1xDjuEgz4NCFFrp7s5yiPZjTgySV8m7oyI6K2Uj9ZrBrQg55hWZv8YX45uomkQiurHZXiev+2MO/3gNStjDPBGHtCWhnwfr/6/1YhLX3xKp4zQnvYRsEtbbPZGhYPCzw1Ghrbd4fupOC8Mow9yTTQEP72NLkgoBidyb7VCni+6y3v5iRwAEE7eeRoVxq9bjNgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some tweaks and cleanups for page allocator entrypoint and flags. This
is motivated by preparation for __GFP_UNMAPPED [1] (which will probably
become ALLOC_UNMAPPED in its next iteration), but all this is supposed
to be an improvement to the codebase in its own right: unifying code
paths, reducing API surface, and removing GFP flags.

[1] https://lore.kernel.org/all/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/

This started with unifying  __alloc_frozen_pages[_nolock]_noprof() and
expanded from there.

Unifying the nolock allocator entrypoint with the normal allocator
entrypoint means adding an alloc_flags argument to the later (only
exposed within mm/). This presents an opportunity to take advantage of
that arg to remove some GFP flags, if we add that alloc_flags arg a bit
more broadly to allocator entrypoints.

To distinguish between mm-internal and "public" allocator entrypoints,
it makes sense to use the __ prefix. There are already some public APIs
with that prefix. For *alloc_pages*, just removing those variants seems
like a nice cleanup anyway, so do that. For get_free_pages, the "__"
variant is the _only_ variant and it's very widely used, so it doesn't
seem worthwhile to modify that. Therefore, scope this "__" change
specifically to the *alloc_pages* API, which means we leave the
*folio_alloc* API untouched too, even though that could probably be
cleaned up if so desired.

Tested:

- KVM, mm, and BPF selftests in a QEMU VM

- kunit.py on x86_64

- For the ALLOC_NO_CODETAG bits I just booted a VM and read
  /proc/allocinfo. I confirmed that if I remove ALLOC_NO_CODETAG, the
  kernel crashes in early boot, so I was at least booting code that
  depends on this logic.

I used Google's internal version of Antigravity (AI coding harness) to
do the repetitive bits, those commits are marked with Assisted-by, the
rest is manual.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Fixed up whitespace in nolock unification patch
- Introduced ALLOC_DEFAULT to replace literal 0 for alloc_flags
- All other patches are new
- Link to v1: https://patch.msgid.link/20260617-alloc-trylock-v1-1-83fd7858832e@google.com

---
Brendan Jackman (13):
      mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
      mm/page_alloc: some renames to clarify alloc_flags scopes
      mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
      mm/page_alloc: relax GFP WARN in nolock allocs
      perf/x86/intel: Use higher-level allocator
      KVM: VMX: Use higher-level allocator
      x86/virt: Use higher-level allocator
      sgi-xp: Use higher-level allocator
      net/funeth: Switch to higher-level allocator
      mm: Remove __alloc_pages_node()
      alloc_tag: Move to mm/
      mm: Move __alloc_pages() to mm/internal.h
      mm: remove __GFP_NO_CODETAG

 Documentation/admin-guide/cgroup-v1/cpusets.rst  |   2 +-
 Documentation/admin-guide/mm/transhuge.rst       |   2 +-
 MAINTAINERS                                      |   2 +-
 arch/x86/events/intel/ds.c                       |   6 +-
 arch/x86/kvm/vmx/vmx.c                           |   2 +-
 arch/x86/virt/hw.c                               |   2 +-
 drivers/misc/sgi-xp/xpc_uv.c                     |   2 +-
 drivers/net/ethernet/fungible/funeth/funeth_rx.c |   2 +-
 include/linux/gfp.h                              |  28 +--
 lib/Makefile                                     |   1 -
 mm/Makefile                                      |   1 +
 {lib => mm}/alloc_tag.c                          |  18 +-
 mm/compaction.c                                  |   4 +-
 mm/hugetlb.c                                     |   3 +-
 mm/internal.h                                    |  20 +-
 mm/mempolicy.c                                   |  10 +-
 mm/page_alloc.c                                  | 254 +++++++++++++----------
 mm/page_frag_cache.c                             |   4 +-
 mm/slub.c                                        |   6 +-
 19 files changed, 193 insertions(+), 176 deletions(-)
---
base-commit: cbe5256a15fc26f592efb037e528da54b2139ee5
change-id: 20260617-alloc-trylock-14ad37dab337

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


