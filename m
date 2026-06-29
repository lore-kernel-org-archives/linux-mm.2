Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86941C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A46B6B00B0; Mon, 29 Jun 2026 09:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755726B00B3; Mon, 29 Jun 2026 09:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643C46B00B8; Mon, 29 Jun 2026 09:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 337746B00B0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A66BC4062B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:16 +0000 (UTC)
X-FDA: 84932988672.20.9BF0947
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id D3DA820011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T6a/K7Jm";
	spf=pass (imf13.hostedemail.com: domain of 3LG9CaggKCG0ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3LG9CaggKCG0ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738734;
	b=F2TMyltcPUd43GjUVyEj5ogC/Ncv2kxgnsJBYJ7lL5fYIia2CDMxjWV+RQJE9MI1YldCFL
	5sZhCaDTNPbmh/50LZC5cAa0K8T2YtDf6a44ra8juEiqCUW38wm7tPcJl+IwVh1CcC4YPL
	RHL4cQJpYjGW6vJfNQzxdVpOnRW9zsI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+OGVCu9PX8rESc8mve/w/hG+ePzfafqERhXCKmxfjYg=;
	b=R5rRnAtO22dUMZZP9st1IVk2yoyOSLP+3iDVykT8eC6FmjaapOZDIr8rm6RpR4a69aB07a
	80WywLkX8jmLLiX+57ZQPHYT9iAP1al1iUkDC6+RdQPffEDRiS2LfJHXowYP9dFPnDt6qO
	GHwPNe/ubou+6+S8zQGZiXeTd7E+LzY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T6a/K7Jm";
	spf=pass (imf13.hostedemail.com: domain of 3LG9CaggKCG0ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3LG9CaggKCG0ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49271013dcdso19947825e9.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738733; x=1783343533; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+OGVCu9PX8rESc8mve/w/hG+ePzfafqERhXCKmxfjYg=;
        b=T6a/K7JmxeAa5RuxvG/3Tg3H/l0mTxMgJ40SgOImZaWm81aAXKhtEEAKxnJcWtFTKD
         mTd/oNP2SIeW2Peahm/4Waj0BBNNd4Fw37LhD+8P7p5c9M6RsxC3IB4IMNvRQm1xhZlq
         9V1cOOII4+Zmi6rx6O5MiJSOYGtiq99MNhn1f/GLM1CdbBI6uQBVlL3N0h8w+8/IClDf
         AdUSsz1L2CO2sqKZ6BfKqPtcO33F9CivVqRlQignG2IXjhjBrEduBsT+8zgoynYOUDax
         insxYyqJldpqTZZp92BQyimzIEiHL7e5Bm8IXth1Tla+tIkqZyBVEbJIdJVyGqzpAvzY
         112w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738733; x=1783343533;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+OGVCu9PX8rESc8mve/w/hG+ePzfafqERhXCKmxfjYg=;
        b=GpkVLj2GH0BOR89Kn1n8CsayWCa9JsMR1IaVXV2wBovKKm1YoZHrBM2r/2h868KR+D
         tm6Zw4lFkj5ZlB0V8hhXLEoijohUEdwQJonhwHqcSD0K5ThzZmAWIc+5iotVjw5/Bg7I
         0qdREfhEIrZRPFikkYV+AoYgp8EDpjybhJCySNHcykuiwzIb7IhvgSkn8nkxPD2p+RKq
         NMkPKTze6i+EI+JmogSaJHKpWhAsqizx5+OaaREiJ5xltQs1FUcg9eB6ThSYC+trK9a2
         UtrfTBcjtAPHkl9O5fqZIGIpM7J0ediGBTmwVEUBcghiyRAyszSodW7bAJ/ECszFsdnK
         CMHA==
X-Forwarded-Encrypted: i=1; AFNElJ/15R0vJ6GTK9CTIn/xHYKnoIGjSzoHMpd9HktwcVvurLv5f7g5WoQ59UjWbTzzGSq+f+WKwk6GQw==@kvack.org
X-Gm-Message-State: AOJu0YwWlJ9OYGof3W2usBFsfcBV3vhDPAWTvxdXF4aDCQNXsWrAJn1F
	hT8SEaoyyhNHNV3Z4b8xV61zZekvZ/cFTjor391xn1iXxdJzn4583mG+XxOqGWm65TGN2Ly9CbI
	f0eEnuC0ryR8XZw==
X-Received: from wmbjx16.prod.google.com ([2002:a05:600c:5790:b0:492:2b56:8534])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6218:b0:492:700b:deea with SMTP id 5b1f17b1804b1-493b71a21c5mr11624665e9.13.1782738732542;
 Mon, 29 Jun 2026 06:12:12 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:49 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABZvQmoC/3WNQQ7CIBBFr2JYOwaYWhpX3sO4oEBbtBYDldg0v
 btQN2riavKS/97MJBhvTSCHzUy8iTZYNyTA7YaoTg6tAasTE055SUsmQPa9UzD6KZ0rsEJqFFr
 WiIIk5+5NY59r73R+c3jUF6PGHMmLzobR+Wl9GFne/WtHBgwqbLSo9lWF3Bxb59re7JS7kRyP/ EPn/FfnQAFZgwxLoQtOv/RlWV622qbA/AAAAA==
X-Change-Id: 20260617-alloc-trylock-14ad37dab337
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Subject: [PATCH v3 00/16] mm: Some cleanups for page allocator APIs
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
	Brendan Jackman <jackmanb@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
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
X-Rspamd-Queue-Id: D3DA820011
X-Stat-Signature: ens4w6jgzaxmxaeih475jx1k5oeebayb
X-HE-Tag: 1782738734-536093
X-HE-Meta: U2FsdGVkX19K7gFl9LaTQH1Bo94n+sxeITy8yXAEUHTX70+euiUtzlC7VhueE24dHNtJru4mQClNHFTgKSWDg9q9bT3pWuoB7GIzCRpUeCo1zXoDd1q/x6Kh8vQS3haNF18BPtxiVB/Lt/+mf5GzRFziYxxlegzPdxssXa2vrCrgLiiV09KlgP5C9UIhitVzU0XZ1t1zLSvCKVME6Q+Aio5uE/YHwkJ34lqPMLljSOj6zYjbZ2HuaLCekDf9A3V+beMYrGyWUqfPk1z61okPd4Z+kRst3VdJmhet3QL7BusT2povUo6YVCsNdW46B+H22xY2khYHya2pHWdoj1A7bb9vgcMbFfp9A2pQfFPEi7Lfo0+f8qBIOl9SN3LGrPNXGdJRgs6bD0aOE07rF1b4eDdJ6XP/1BxRRUId3KeXhRpL7I2SLHRjIwUhSk+LjStqBgMkWngByxc60KUiFrnLg72CyfNAxlkqhq3L0/l8ZLPIkE7wHlkDeKQn6Yj2DYVzewSnYWTLwwGaarexePHYOzvJXQMQOhpdbBoPJN1SY1vnY2qc7epF+87t1G16XE+i5CL5am7kmO9/wL8yeBdp4+V0wP3WTmJKXrPP8pksm0YvV8RQRksbOwOaTpoFEgF62kCnJth0foQNBVumk8sKo0TzBtiivM/raDbgwEWTwkouy7EkgiOEHuKihwTkejgR7TxECLXyrDK2PuFvGfwVAEr2WCULTm8EyrcccHHRGbZvb6dwq8xkHQkL+Wvfhv9cVf9+nH+3clkg9gH225xZPKmHltCS5cat/VxvF7lBFnIhGUDNNp+BoFe3CkY16wmWkCRaRoSeWx0Sq5ux5R3jgyHz05Hdvz4/w9GyIWAHcrR8ddsoMK8/X1LgSrFBaU3uzw8rQdsJRxmjxD0Je0ugDZzAEA4jwuly0asf+TKJzMVeRsmHd3Omrf4fdokPeCbsezHu5lpCLF7dNyCdsoD
 5w8bpqlQ
 nwU5pACRGwzz5lrVrfBkoTlgJwvuEU4bPyPv1MeKufnDjHJFJzmqvOktdtojSWcxz72DJ6j9MnBN+t++5cUZaT+dOibzwc0Vf+LxP6apOuI0ECx6b06NsLkhdCA0QYAtsk/VcfntphqV6bt1JQBwCemd2GHL+dUrFjMF2mrKmD6VaiBFc8PdMc9gdbbPpDi5ojNEyhvdv1mXl3E5qWnsvPT/NCTz7vLNbvORs8hrvU/M0CPKecAawnasbqLwYio1dH/uJofuCNfhI5LntXbY82ZVASlpswED/ziDYJYPFc2wWPpvJP7gC7fEl9JvmMfMAS7de0JEN5TcqQ7COIBBikWtYWPqyVDWpsCNdMKRD1QekAuGJKawVmWXSv473a+/Y8huHNKhp/2pR4Cul/qtN6+y9KfRZaVElFI4LQXQgpbA/jtTCLuY0VsX3voMtpWhG/Gddio5ajRUtxUD+VPKFLZL2KDMMrkfbnD96yGuv6gFBotX7FEtF6Cz0dQ1Rhpi22h8QQweUGjfNveTOAtQbtjOvZX5EOdDpabClknLI8EgnPV40xQQGYzAGsmQ1vLFaoAQaEKF0vriyj2QtnKhVPNVJtzhQkV2+8DMxcgH8BHAP2aigLY1lNvMbFTj/C30I+kXlY9qSyv7nmNOwZ8EXbZPuNJqAktTIFG5QlOW0EfuYVb3Nor6BnsiOAM6GxBhkm96JPI2yqyr55Ut9frLygnfK6jH+uVNsW9PBW3DLa8opqwll1R+ETn9hh4v1kRKvy11t6444qAcfiIL2kXbWUQFMQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is based on mm-new, it depends on moving alloc_tag to mm/ [0].

[0] https://lore.kernel.org/all/aj5QBtJcphPElczI@lucifer/

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
Brendan Jackman (16):
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
      mm: remove the __GFP_NO_OBJ_EXT flag

 Documentation/admin-guide/cgroup-v1/cpusets.rst  |   2 +-
 Documentation/admin-guide/mm/transhuge.rst       |   2 +-
 MAINTAINERS                                      |   1 +
 arch/x86/events/intel/ds.c                       |   6 +-
 arch/x86/kvm/vmx/vmx.c                           |   2 +-
 arch/x86/virt/hw.c                               |   2 +-
 drivers/misc/sgi-xp/xpc_uv.c                     |   2 +-
 drivers/net/ethernet/fungible/funeth/funeth_rx.c |   2 +-
 include/linux/gfp.h                              |  54 +---
 mm/alloc_tag.c                                   |  22 +-
 mm/compaction.c                                  |   5 +-
 mm/hugetlb.c                                     |   4 +-
 mm/internal.h                                    | 253 ------------------
 mm/khugepaged.c                                  |   1 +
 mm/memory-failure.c                              |   1 +
 mm/memory_hotplug.c                              |   1 +
 mm/mempolicy.c                                   |  11 +-
 mm/mm_init.c                                     |   1 +
 mm/page_alloc.c                                  | 259 ++++++++++---------
 mm/page_alloc.h                                  | 316 +++++++++++++++++++++++
 mm/page_frag_cache.c                             |   6 +-
 mm/page_isolation.c                              |   1 +
 mm/page_owner.c                                  |   2 +-
 mm/show_mem.c                                    |   1 +
 mm/slub.c                                        |   7 +-
 mm/swap.c                                        |   1 +
 mm/vmscan.c                                      |   1 +
 mm/vmstat.c                                      |   1 +
 tools/include/linux/gfp_types.h                  |   7 -
 29 files changed, 506 insertions(+), 468 deletions(-)
---
base-commit: ec005628e9dbcef26b761fa860f264fe6e5fd690
change-id: 20260617-alloc-trylock-14ad37dab337

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


