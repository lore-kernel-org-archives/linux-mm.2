Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CDBFC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2546B00B9; Fri,  3 Jul 2026 08:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72EE6B00BA; Fri,  3 Jul 2026 08:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62066B00BB; Fri,  3 Jul 2026 08:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A40666B00B9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23B8040526
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:20 +0000 (UTC)
X-FDA: 84947403240.11.DDCF3B3
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4B991C0003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ofzMecE7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 30KtHaggKCJ8I9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30KtHaggKCJ8I9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081938;
	b=OXnLb1009B21SjMDfJkjpRiXJ1ehLIDEtNzb8sAUABxVXrShLyhZH1ce6ijCLoigSsYMD/
	YdXfyOZGdDlfvpO7lgBH0I9tWpOmWQoEloeHeyR1wIvHmZ5JoSQpUNBWwkiTnBlax5kSm+
	XphdFQuzaRAtedj3IoLfRZworUKHwlA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tnDWaO67kOtoHBKr0HS5m4PtTKwANjm9WdLJsztRd4w=;
	b=5B56B6II+Kn9Mr1PLFn07XrX5sh78Luunn2Hdrr1quYNa4nluPJQeJ9pO9RvYcx+JAvWPw
	fyiMXN5jZS5U6whQIrDBUBoRSs2d3PhPhKXK9U6On1jLhXCoC6X4Og5eLV+hXY/CwWXcaF
	M2DhwmulDs5eqd9YhhS5RNz/I4deiFM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ofzMecE7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 30KtHaggKCJ8I9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30KtHaggKCJ8I9BJL9MAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493bf840a69so4383875e9.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081937; x=1783686737; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tnDWaO67kOtoHBKr0HS5m4PtTKwANjm9WdLJsztRd4w=;
        b=ofzMecE79n/F+jbZWW3qg5L9bGH3nfWkMi6mzkyquvND7UrHyHVeG6Do1HnLeo+s3N
         XFq2HArwFiWz/9/IjgiFDv3Jyc1VxsXk1N8o8obvC3a7m8eIoTOmsQroA9nPXQm4EBri
         IoGhWfFqISREFQwzu0FEizeuzgFm+jyI3gqPfswwMWT503bppMJOnAL9gVpNVQZMSNM5
         JaaqKzdXBWaKgL3m+Lkw2vs9E1wANmV/PiZ6CUqa9guDEaB8Ag26orJNJVchPsn8frW6
         pg8ZnhuNHGYd7vCbv/yDfQTW+Xw2oE8lKmdbuyAJDFsQ4ZtriEbLtYHcrKol5uxB18d8
         iyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081937; x=1783686737;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tnDWaO67kOtoHBKr0HS5m4PtTKwANjm9WdLJsztRd4w=;
        b=Vg6mkJQMRY9fAxh5SQGxvlDZNDUaYZ1PzG91FmROnhMh9e5D3vAEnzmSGtGZRy03Q9
         7yntDymW8EucsuE29ntif054Iqb5U/xTb2EuA4D7CNIi+7P2gQ+V2qmCw5mqd4bqlPbl
         stOE9/5xhkxgAwVb6Dfkt/tjPzCckctV0lRq7xF0/pkXldwguR/UVmYqUkcjQmAoS/E1
         mQM9GZ3bLdDW1E7JdefamjPrJwMsTaPkNageR1Y2hnfsWDPnrFmgJDRiv18ad2dsZcKa
         8gXaxS/eKAW5XGYtKpG7TNTBZRBe0x14z3H83ACQqO3Wq2mpCXhvsCOQM8hjoBDfFsCx
         jcXA==
X-Forwarded-Encrypted: i=1; AFNElJ+qIxbx3+Pwv/q7ndEQggyDr/JvY3T+oe23f/39DDoUDX4J2CY9A5hbdM+/bhqlHsb30L7qDlm6NA==@kvack.org
X-Gm-Message-State: AOJu0YxF7QuCOuq33pF51X8M6xOG047559WWCx3f2k9Pql8axqNfdu90
	j3t6H9EWuOXHlgWGMcRTrZKafW2hLLhBVcyE+DO6RBjN4lI7/9TrRW85yCBvCFkPZfMktWwR95n
	7j/61ULS3hyugtA==
X-Received: from wmer11.prod.google.com ([2002:a05:600c:434b:b0:493:aecc:774a])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6692:b0:493:bb6b:5bda with SMTP id 5b1f17b1804b1-493c2b983b8mr139426775e9.29.1783081936166;
 Fri, 03 Jul 2026 05:32:16 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:40 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAKyrR2oC/3XNTW7CMBAF4Ksgr2tkzySx2xX3QF049ji4TTGyQ
 1SEcnccWPATsRo9ab73zixTCpTZ1+rMEo0hh7gvof5YMbsz+454cCUzENCIRipu+j5aPqRTOb9
 cVsahcqZFVKyYQyIf/q992+9bzsf2h+wwl8wfu5CHmE7XwVHOf++6R8kl1+id0rXWCLTpYux6W
 tv4x+byER44wCsHLjhKjxIb5SoQC46P/POVY+G1askLMq61sODVnSuxWK8KF8Zr71Er0s/r0zR dAFKCqT56AQAA
X-Change-Id: 20260617-alloc-trylock-14ad37dab337
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Subject: [PATCH v5 00/18] mm: Some cleanups for page allocator APIs
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
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
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
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: j4bd4qmtzmeu49n5b4yud8quurts9kdw
X-Rspamd-Queue-Id: 4B991C0003
X-HE-Tag: 1783081938-967275
X-HE-Meta: U2FsdGVkX1+5WPkFtdl+x0PcDIbCxNaNtFU/OPQTw0rWxfdvNXIqQdpZ7EkPDerr9JdYBvpuYUC7X3LuIGfGGXKuMTkRraM7ldcX1O+FGTZbAq2FGXFHBnu/iWvOTC8+ZvcPnjkjHVaosIM6Nqwf2fqT+jBioO56LYffPulsT3YBKchIUvaqfefmT13V6sLxLhWxcJkhkKMCUg3vAJK6a+aM201e4z4qnyoO/kvyGi6NpgPp+Tm9URlUrNxQxXbDlH0Mna6UnVGwSzfU3N5HP7lio7z7NXd0xax+/NrXLGQSqtkuSK6g7+E8VMqoOZ4OyKUgQxcPs+ypKrJBCChFuxGuc7antH4k4ViVOWIviuxhwnSDLJtPMwGO4RZ044W5O/NyNP99OR3uygVaqaxZ+ptHoen9GZB3TU3j2hv/jlIHIutygCgm01zdpf5217VSnjEu22bfKT3W+VTlrRdz4XLfYmoMqxE47v/D83LwWF5RtTkS9gLT2/PCYWJQbWcFue66byJdfD1WjXm5H4ijVayVryHSRKFWY/f17Yz2P6YFfBH7IK37iwWbIWJdJvGNJ7k5CrS8Z6uzySMQGibJKrqDB6tkKn+XlWEadnBgppI5U2HITPulJkrgkUhcCWIHCckHzzoODp/wvhOvRV7IRoITLh51FBZHBcEETjLGW3F9oV0CmXE2bj0eaOmPPtRFJIztwAIpPK8/LrMidfC/Jof27kxyKHNBUo4s1WoBkSlqZPNN5dEhZHHjrG/cHmNP5QIY4Bf8NzAK8XNGD6RB+Z8vpab9TbrioGfP6vCJB0tz0mkTqKQ2GLk9JDJChng0XE9uY6OVZIT2Wb4EBgXMOQ7TSnYFe0O9Nh2PIabCutHLQmj3MOzEv0ta98uzQ+OsB4NAs0XFJIdawPAvFahOxEZaa/dZrnbh82U5qw0w5bx35ivtvpOTBKleZQcxmf86Q1CY8OAamR/Bf+3XI00
 WbmBK8ni
 GCZ0LZwI7MNp05QrEaN/JCZIkJlZqaUk5QzYfq5NpEt3A1I/lFb5EW5aUWqNqJC2TdYwaOATeTil7NZ0tFrAs9s7XOdeS+3+O5+HFnnxjpytJNtUg3pA6OGZduGWE3Dl7RC7I6NO7FMZjmzWzBMUv4vuK/ZvQoD1x/StZnMRCc+k/Uq3TYBDECOv23xNT/aztAvvIdCM26DFa8nBApXDrGmRrZfy9l5j4ZYrE5esXBH4CpFYIQrhLqUPTYy1vgmdeoKmg02OFZRkCLRrL4i8ozwYBwjJHmDetlMyOPkzCAxupHdQY0frlKjON2BLmycn+qTERB0T6pD2ocvAHxq4j+AoEb9+Z5BgkdKaMdXVu45iKyLHkFCNwoSKQD0dcXUdu59f9PiACzNPkVPdf7kL3kib9Uk4/RJRCqoTxHbDkIdIasdIC4L1Md6IE1ZZjdbZGoulwLKAXvwU+X3WsuMt9M9nToKiGCk4gHe6w+n+If03LGFaAHBYzgabz4SjRub1pdoEIGcObvOC3YoJ6jZl2VMA8woIjLbOVf2kvwqK55e4JKcFknpLBQRX9rYuiQc6jnaaQ1VvpyyrrdPiV+aS5LXQ+o177+FBm7Oei/6zWOyNnrMV5rpQ8k9L+NLgazGQFp6utabODFr131z5b4c3aczhS3MEinDpXn0lMPxMibyLyQ9uEumAJ7Mvu4wqRZrEkwggEOwJPvw3vwOi9G8OJIZ+q4iLhoxx5oa4039kY4AyO5whMiw1HtuKD6/0fKYyM2rjmLcP2831SR9E/NH0qjzQ0JhDOcsRrvJT+RWaS9zt9YHeUNZsWF1sIvXDzoe0cw3n2gNYCNYXYkUuXEobh8DXDDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Based on mm-new.

This depends on moving alloc_tag to mm/:
https://lore.kernel.org/all/aj5QBtJcphPElczI@lucifer/

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
Changes in v5:
- Just trivial non-functional fixes.
- Link to v4: https://patch.msgid.link/20260702-alloc-trylock-v4-0-0af8ff387e80@google.com

Changes in v4:
- Fixed some (harmless) missing applications of ac->alloc_flags (local
  Sashiko)
- Fixed various build issues.
   - Note that Sashiko pointed out a KMSAN build issue [0], I have
     fixed it but KMSAN builds are currently broken by objtool [1]. At least
     mm/kmsan/init.c compiles.
     [2] https://lore.kernel.org/all/20260629141642.628271F00A3D@smtp.kernel.org/
     [3] https://lore.kernel.org/all/20260630104434.GC751831@noisy.programming.kicks-ass.net/t/#u
- Avoided setting ALLOC_NOFRAGMENT under ALLOC_NOLOCK (Sashiko, Harry)
- Added patch to tweak alloc_flags_cma() interface (Vlastimil)
- More commit messages fixups (various)
- Added patch to create can_spin_trylock() (Harry)
- Link to v3: https://patch.msgid.link/20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com

Changes in v3:
- Created mm/page_alloc.h
- Fixed EXPORT_SYMBOL() issues
- Reworded commit messages per Sashiko's pointers
- Dropped rename of alloc_flags arg in prepare_alloc_pages() (Suren)
- Renamed gfp_to_alloc_flags_nonblocking() too after rebasing onto:
  https://lore.kernel.org/all/20260623004600.113347-1-jp.kobryn@linux.dev/
- Link to v2: https://patch.msgid.link/20260622-alloc-trylock-v2-0-31f31367d420@google.com

Changes in v2:
- Fixed up whitespace in nolock unification patch
- Introduced ALLOC_DEFAULT to replace literal 0 for alloc_flags
- All other patches are new
- Link to v1: https://patch.msgid.link/20260617-alloc-trylock-v1-1-83fd7858832e@google.com

---
Brendan Jackman (17):
      mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
      mm/page_alloc: some renames to clarify alloc_flags scopes
      mm: name some args in a function declaration
      mm: Split out internal page_alloc.h
      mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
      mm/page_alloc: relax GFP WARN in nolock allocs
      mm: move some stuff to mm/page_alloc.h
      perf/x86/intel: Use higher-level allocator API
      KVM: VMX: Use higher-level allocator API
      x86/virt: Use higher-level allocator API
      sgi-xp: Use higher-level allocator API
      net/funeth: Switch to higher-level allocator API
      mm: Remove __alloc_pages_node()
      mm: Move __alloc_pages() to mm/page_alloc.h
      mm: replace __GFP_NO_CODETAG with ALLOC_NO_CODETAG
      mm/page_alloc: drop alloc_flags arg from alloc_flags_cma()
      mm: factor out can_spin_trylock()

Vlastimil Babka (SUSE) (1):
      mm: remove the __GFP_NO_OBJ_EXT flag

 Documentation/admin-guide/cgroup-v1/cpusets.rst  |   2 +-
 Documentation/admin-guide/mm/transhuge.rst       |   2 +-
 MAINTAINERS                                      |   1 +
 arch/x86/events/intel/ds.c                       |   6 +-
 arch/x86/kvm/vmx/vmx.c                           |   2 +-
 arch/x86/virt/hw.c                               |   2 +-
 drivers/misc/sgi-xp/xpc_uv.c                     |   5 +-
 drivers/net/ethernet/fungible/funeth/funeth_rx.c |   2 +-
 include/linux/alloc_tag.h                        |   4 +-
 include/linux/gfp.h                              |  54 +---
 include/linux/gfp_types.h                        |   7 -
 include/linux/skbuff.h                           |   2 +-
 include/trace/events/mmflags.h                   |  10 +-
 mm/alloc_tag.c                                   |  23 +-
 mm/compaction.c                                  |   5 +-
 mm/hugetlb.c                                     |   4 +-
 mm/internal.h                                    | 275 ++------------------
 mm/khugepaged.c                                  |   1 +
 mm/kmsan/init.c                                  |   2 +-
 mm/memory-failure.c                              |   1 +
 mm/memory_hotplug.c                              |   1 +
 mm/mempolicy.c                                   |  11 +-
 mm/migrate.c                                     |   1 +
 mm/mm_init.c                                     |   1 +
 mm/page_alloc.c                                  | 269 ++++++++++---------
 mm/page_alloc.h                                  | 312 +++++++++++++++++++++++
 mm/page_frag_cache.c                             |   6 +-
 mm/page_isolation.c                              |   1 +
 mm/page_owner.c                                  |   2 +-
 mm/page_reporting.c                              |   1 +
 mm/show_mem.c                                    |   1 +
 mm/shuffle.c                                     |   1 +
 mm/slub.c                                        |  17 +-
 mm/swap.c                                        |   1 +
 mm/vmscan.c                                      |   1 +
 mm/vmstat.c                                      |   1 +
 tools/include/linux/gfp_types.h                  |   7 -
 37 files changed, 536 insertions(+), 508 deletions(-)
---
base-commit: 32af3ff0925368eff29b2fed62f154150eb5dc10
change-id: 20260617-alloc-trylock-14ad37dab337

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


