Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 047B7C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4746B007B; Sun,  2 Aug 2026 15:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85856B0088; Sun,  2 Aug 2026 15:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74016B008A; Sun,  2 Aug 2026 15:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1736B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14147A1D06
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:02 +0000 (UTC)
X-FDA: 85057377804.09.5B59DD2
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2943D160003
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u hM6P4g";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AvKnug8B;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=juH0jvMGNMvH75SBITV8UFq5P61TdljuZYunxn70Lnc=;
	b=Zeq9EtWxqPhRo22lEjFzndWchKZR+HG4SgvZd9H2FMgGoIat7jrNbQQeEeabCfRkHeb2UR
	x/KbEOmWYmCIRqqM37VHIfxg6r44r5xr0A8IfltaJdx3sQKLVYQerB/G4Swv7F0xegAe/J
	CID4ue7GhkWVbHz5Wkdox4C/vuo0EFU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="u hM6P4g";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AvKnug8B;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700380;
	b=N737AKj/QDsqdv6E3Imq/VWhLgBX2rNJhdwOse50N5+nCnMoSaM2T/mrjRnKxbOQJLBlSW
	VjQPVZd2UroX6LjDYOXG7EIcDnREFk8zrtPjNBK6aNkH/ROQKn+6KDhJUMsI4s20XOWBNC
	kVy0+InEsa4L0Z89WSo7FzxezVfoU20=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 813A2EC009A;
	Sun,  2 Aug 2026 15:52:59 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Sun, 02 Aug 2026 15:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:message-id:mime-version
	:reply-to:subject:subject:to:to; s=fm1; t=1785700379; x=
	1785786779; bh=juH0jvMGNMvH75SBITV8UFq5P61TdljuZYunxn70Lnc=; b=u
	hM6P4gdhbepxbJzvroluvW2yWL/UULvZOlcPtfZmyz0bJo68GRqf3RIcfVTPmgx2
	FQiaE8QirQZ6ZHwaz1qqbjbbWJ2VhEXw3zBkvV3jVNLkSmSepioMuwP8Kzd3eFav
	PmQyQixk8M1P5RJsdLLEqmcB7uB3282SdJdwn6mHFHeBXWZQlJX4Xv7UxsReB/p7
	i9QPNPkRrZGxQkwTDCBLwNss4fc2NDXjgaVKL2n/hfKxLpLUzN1CfkGmrMsicDr+
	kfJTgWmh7qkfGAySpjnM7gxFNhRaA/fML2Y+B2ksupbs75YQMly20SVnElnXkQsg
	5lbqq1AmMmdRxVAM32FWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1785700379; x=1785786779; bh=juH0jvMGNMvH75SBITV8UFq5P61T
	dljuZYunxn70Lnc=; b=AvKnug8BwEHeOqz3eStexXRCiT46dQFuUVnLbINZTjhM
	IZq2I9yE5Co7Cfi6plPsfyZ5HSl7A5HO2A3oUcZcmiEeM0gwH9XkcbJTj7fnhRXA
	gEfwK9bNGt69m9B4VTxGU/vgqtzJvVfeiYcYiycmbp+HqOBF7La2pcZ6aPEzp1Ml
	4pSDfN0oL+AaLyhAxYLBSSDprtZ5/ECG0pnyhhCeLYyBQMnNPc+a1t1J8i86UidY
	pYhPPx51/5yO5zOnt2C6WgNILq7FNAx3+qYc2K/D3QJI+hoJwqhAupL+QDPnO9Bw
	Pji9jV1wUDsraya7P5x64gZjm2DcMN/IBJdgmiyOGA==
X-ME-Sender: <xms:GaBvalG4fbkKOFL8zac2rwsqsXKHXQz_f07mOjzmUi-E8wx9_mLdfQ>
    <xme:GaBvak3oh8E9YcxEvWz0Qprm531sLVUdQeI5ooDz_g1AlsyGUfeN5ZFF5uCOXw-Hz
    dzTMMoD8fEqaWMTF5Q4YwsCCneKRN6TkP2ER65oaqbDJbloI0ueVbo>
X-ME-Received: <xmr:GaBvakG0tLQEkIwLaqlrRnduxZ_kDc8vv9sX0uuJUik2HtDQa_0eYfzLlbg>
X-ME-Proxy-Cause: dmFkZTFTXVbsrdk8DREbD4eAIbzYwCFJVQVYe1wc0iuILac2QcFkZzhmKLqmHUUlY1+WS0
    JLauri+119lYDJyBUuNkM3ZF6tyQxpmoGpXbDRjA7Yn+fc4Yeyx/mJ2VCfHBem3VSOrNZx
    ZLxg4PzVIPwfldLbz+/H0iEw+ORGH35XW6PXBV7LcuESiIzG6PrevfT73f2IjyaRtaasuF
    gPSbcIUUpGIoWwqhsaOwJ6Ur3DfyrUTEv12C7z5cMDWrQrO/zzcHS1eRqEz3TuW4S5Cdoi
    NGn2u9TpdxTsiHv94c7rIr3iBqxgHKXzJSx6tt6/CdfWHGAWFLKgLnSS1/Srhf7jQ3ttV3
    CKkWB154qaEI+c6pwAWHOM03fg2pxaeBhYUpMLk45SnOXqrGdkjNLcJxOObdiSQDCrtpAH
    XL41agzQiu8KpDVxwv5SgeaJlcUGKUB9hoL96amrXZu9EfnOFGpvdzgTjMkjpW6Gp5NYvC
    bCOZu6rWJ3m799ft8cemhklyFNs/G3ysTwnE79IrX7BzWW8b8M+7XXrrr+gUekz8gH+RF2
    RLrex9przHQ0Od29ojl1Rg4Re+lZJx5kK+t4cL3DyKORGKyWrC5gCXZAYcmUgP2L8+F7jk
    US68WTNUovAdi/3LJYpgGBvo7gckU0onGiAouNRfLPzNVBhkiG8QUfU2fb2g
X-ME-Proxy: <xmx:GaBvatzsO_BQnL75b0rQp1H-jqkwW8Lm1NoECke8iA2-1MzQdp9Z1w>
    <xmx:GaBvajnF3xfI8N3Y4CibDubPgk9w9G9TvJtFUIf5CmiAv6_485Oodg>
    <xmx:GaBvakCGPIoglm_xRNaCmoUK-jESAImzTVj1LJuUDMcbVyonSGcWWQ>
    <xmx:GaBvauIhGneIZZ7CtBASj2mSLaBmBMYxJ63nWf7RyYHU3xusiMINiA>
    <xmx:G6BvaogtS0YGBOuNgyuc2fe8xBBMzUVp9roE1jKGpkui6t3jletB3BK->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:52:56 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 00/16] selftests/mm: improve khugepaged coverage
Date: Sun,  2 Aug 2026 20:52:32 +0100
Message-ID: <20260802195254.1937477-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2943D160003
X-Rspam-User: 
X-Stat-Signature: bn8ufg5g77z7px9f4xx7s6a3kgdskgyf
X-HE-Tag: 1785700380-643890
X-HE-Meta: U2FsdGVkX192DbNnMn9YREaIgQVgjev2Ys8VunTJDvCdYInTLAW/qoinnb8p/lNOaCKqNoByP2hML2pPjsSjMSWGaziWWKVvSNUcnKCRlMUnO/AAf9fgrRdMqFVq6pINVcglaoeSifebHbsf4GIi8Je4H1oJOB3E7EUBN3kTbShuww4Jgw8n7YJMXqTG8StR0bhzKRvAFfTRTf89ihY8vXYjoUjowwyStP4WpNOB10gaGfqJcgG9apc4WzeGajloxW0jppH4QKhOoEO0YyCtbumfFdv6ZHS1pJNYBblJKNTebJrwlVxmIwxM3Eaiph+dCCVQXd203uBn96nPhSy3YhqPgI8iqQYkMrrC7maMryQtRJObuGi0mWTz98myvnN5EialSsWrlIi8M+yxPMqr9LjRoNuWg9CjhV0e18VS03q+YEpLIQKtJJc8ciFzfRTJnCFPS80HyUnlFAci6MtwHcGqvjUyun1BVioJNfmcow81iH8aNZZ8EqowYdo9Y3VcoDrMoRUzjEMg2wKMvNXn/1yutWeVSh37WanZ/Yu4PTm3ntNpX4pHcIjrIXa+VAqny3nsnP4mPX2iFx739RJskE1n2qIWW1ALvh0v8N1yomxspE5syUDSAWmlC1flMxGlgQVEWD+NrlzdC7AkWSJpaJO3emYzydpxKsHixWXm+uxmZxNQpIhG4HVGXn3hP0U6QlZy47zgdZhcS7u8mxz10/gknPlKfvcJVN7qhipjjg9R+Enmk/E7nQb9QuxEl97KQYpXojTfIE6DWbUH8QP2qV9ACKUYTILfS2QkpcQe86z6V5YCqcSX/61MR4oFVgn4J6lCtDS7AmZexzrIaB1fFsnH8Bk23Gnaz/9IgxlesF6Z/lyK6Pxj0AevlDC4BfRvkH4PSOFnGik0Y4o1tpOoQJuYLSqD3SxqVC6/t/oQEBVTJk0VYP7YRYPBCRx9zp9+lya4a0JVDlUzNSOlF4O
 u4g0yQ6Y
 RUNeDxrafpqBGfbWk0PczlMFm3Cs4v3BSesqTL5H++mmeSkAyUo2oBD2P8dqIVc90AHkTgG9mgAPRScd4/QhSF2iAqy8/rdTHKdDRTaspHt3e//Ju0R2Ax0J/hR75K4zmMRNiyuf/iVAHiQtT2xBBZzLO3IAq7zdBeBW9VVFhvsldtS6RNAzJvYugWL4njCCkeMl8O4Z9Qg930Ikqm8vdgcvfJcQ4xX9wyEzgbWsjyowergeKy6mkc9QbI9/aC9eBdgNd+2s7C1UtjthTshWB1cEuRvFyP/raw0fy00YuRTHNrsYTtOquPBMn2QVa3+yaGEOo7ccGhzqdJ34Hl/A9wFVfazzQPw3wA682Ll+seiPyF3/h/GQ0LY3Lh0fjDhir26jYVdWsij3NA9HSD7PDbht5h3eotH4pySZkhF2m375H82q6SguILEvFC8kwgxJXDrSA7ISZrVBk9/aGE/HKQJ/AqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

mTHP collapse went in for 7.2 with no functional selftest coverage. Every
khugepaged collapse case is PMD-shaped, down to the detection: it reads
smaps AnonHugePages, which cannot see anything below the PMD order.

I am also reworking khugepaged's collapse mechanism, and that wants a suite
worth trusting before the mechanism changes underneath it. Nothing here
depends on the rework -- everything passes on an unmodified kernel and
documents what khugepaged already does.

 - vm_util grows folio-order helpers: is_backed_by_folio() moves out of
   split_huge_page_test.c, and a range-level form asks whether every
   order-aligned window of a range is backed by one folio of exactly that
   order, mapped head to tail.

 - folio_order_check validates those helpers against the kernel for every
   anon THP order it supports, before any collapse test trusts them.

 - khugepaged_full_pass() drives exactly one scan pass through the sysfs
   wake path, so a barrier completes on the daemon's own cadence instead of
   needing a short scan_sleep_millisecs.

 - khugepaged -o <order> runs order-parameterized anon collapse cases: a
   full table, only the populated window, default max_ptes_none and
   max_ptes_none=0, and collapse upward from smaller large folios. Any
   order up to the PMD order, where the same cases baseline the PMD path.

 - khugepaged_race races two faulters, MADV_DONTNEED, transient FOLL_PIN,
   fork and mremap against one of three collapse drivers: khugepaged a pass
   at a time, khugepaged free-running, or a MADV_COLLAPSE loop. Every
   racing page must read as its pattern or as zero. -z collapses
   hole-bearing windows; -p adds pageout and compaction, the only threads
   that elevate a source folio's refcount from the reclaim side. DEBUG_VM,
   page_table_check, KASAN and lockdep are the other half of the oracle.

 - A shared-source write race pins the CoW isolation contract: a co-sharer
   writing throughout a collapse must not see the collapsing side's pages.

 - Four tests fail on the environment rather than on the kernel: the
   collapse wait is a fixed three seconds whatever a huge page costs to
   build, collapse_compound_extreme wants a 512M page from the fault path,
   the shmem cases want a PMD-order page cache folio the page cache caps
   below, and the swap cases fail instead of skipping without swap. Scale
   the wait (a 2M PMD is unchanged) and skip the other three. This is why
   the suite now runs on arm64 with 64K pages.

Tested on mm-new (1dbd7c34bb92):

  x86-64 4K    105 pass, 3 skip, 0 fail
  arm64 64K     87 pass, 7 skip, 0 fail

The skips are structural: sub-PMD cases decline at the PMD order and the
mixed-source case at the smallest order, and on 64K pages
collapse_compound_extreme and the shmem cases skip for the reasons above.

Kiryl Shutsemau (Meta) (16):
  selftests/mm: move is_backed_by_folio() into vm_util
  selftests/mm: add folio-order check for VA ranges
  selftests/mm: add folio-order detection self-check
  selftests/mm: add order-parameterized khugepaged collapse cases
  selftests/mm: add khugepaged completion barrier helper
  selftests/mm: add khugepaged race harness
  selftests/mm: cover a shared-source collapse write race
  selftests/mm: skip collapse_compound_extreme where the PMD is too
    large
  selftests/mm: skip khugepaged swap tests when no swap is configured
  selftests/mm: verify synchronous khugepaged driving is attributable
  selftests/mm: race-harness variant for permissive hole occupancy
  selftests/mm: add memory-pressure threads to the khugepaged race
    harness
  selftests/mm: parameterize the mixed-source collapse case by source
    order
  selftests/mm: zap whole PTE tables in the khugepaged race harness
  selftests/mm: scale khugepaged's collapse wait with the PMD size
  selftests/mm: skip khugepaged shmem cases without a PMD page cache
    folio

 tools/testing/selftests/mm/.gitignore         |   3 +
 tools/testing/selftests/mm/Makefile           |   3 +
 .../testing/selftests/mm/folio_order_check.c  | 138 +++++
 .../testing/selftests/mm/hugepage_settings.c  |  66 ++-
 .../testing/selftests/mm/hugepage_settings.h  |   2 +
 tools/testing/selftests/mm/khugepaged.c       | 430 +++++++++++++++-
 tools/testing/selftests/mm/khugepaged_race.c  | 483 ++++++++++++++++++
 .../selftests/mm/khugepaged_sync_check.c      | 198 +++++++
 tools/testing/selftests/mm/run_vmtests.sh     |  17 +
 .../selftests/mm/split_huge_page_test.c       |  62 ---
 tools/testing/selftests/mm/vm_util.c          | 157 ++++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 12 files changed, 1490 insertions(+), 76 deletions(-)
 create mode 100644 tools/testing/selftests/mm/folio_order_check.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c

-- 
2.54.0


