Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAED6C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BB06B00E0; Wed, 12 Aug 2026 09:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802E26B00E6; Wed, 12 Aug 2026 09:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2056B00E9; Wed, 12 Aug 2026 09:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42AB86B00E0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC4DD403D0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:10 +0000 (UTC)
X-FDA: 85092683340.29.C6A0163
Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA97B14000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=tOf1Y34R;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=C+4oQZby;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786540989;
	b=LblORUOdUBByZnQSyxRSDLjY52bj6z9oYmJhjgubwEa+yRE9F3ZQquf2D+sqdCVbNgzYzt
	mn55sFC/21NujGfQipIsKrwE6bpuaBGVqKkz0kbcR2ynBwKuDg+0ZtQfgZyL6T8NbJbxEU
	fG1UM4pK3D7L5TxWwT8TL6jP/OhoBNo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=tOf1Y34R;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=C+4oQZby;
	spf=pass (imf09.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.150 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786540989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XrYEOujHJzUObdVV5e59kZmlODSCAV/JfjqAsdoYI1I=;
	b=YAXSZUaCx/hYCOAlgPOe5TuoHUrw66sLThl6bzvGBuoaBikl/A2GggQ4EjEIgB/48sV3ZC
	NbPC6Lhm95EMOwO/dNalJV4FfXaBLbvXjF861HbDyZ/eGceBMT8DI5IkkD1FiD67bFtjSP
	pcji0v1NtzxgwNtAZrYzM9mkAd9MALk=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 764FD1D00171;
	Wed, 12 Aug 2026 09:23:07 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Wed, 12 Aug 2026 09:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1786540987; x=1786627387; bh=XrYEOujHJz
	UObdVV5e59kZmlODSCAV/JfjqAsdoYI1I=; b=tOf1Y34Re3BxH/v6MRYyPsWK0u
	fX6e+hVUX/OrSpaAG25o/q0vGv5hlEz+Vfle4Nb99cfTBLMJ7tXeDlJ5CTtVl2qk
	NBxQvNmbFCWkXb7BunJlGeKx+46mqQDtxxEegjTar+kbYrLKjtBakV6Vdgiz9tq/
	YYMUrWy/Gq2vkBPze8EibCqzZjyMYQQfYu/pgBufUCt3wDMZqh91CIDbRKcn+ze+
	ZcWqYlolXg7TpSqjorFXVyHWhkh8yXPYFxClDwYW8KW/drm8DKjWxerdl8hszVxL
	qBH6iwKFEn78RP8S+bbhtNqmbQ08XVNw5g6je/ETld7Ot/QPAPUZvSXgXJyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1786540987; x=1786627387; bh=XrYEOujHJzUObdVV5e59kZmlODSCAV/Jfjq
	AsdoYI1I=; b=C+4oQZbyLVMe85cLif4uV75JP3nJ8XvRWwnAgBgZen9MmbcPVjW
	qLoi6v/cDVZ5jChQmROlI9I7XEwtIfIWgAkulHEEIIxe7i3rPhtncadLlGL6V69I
	oWacyusU5plPPHOXbtOHwrKb7PfU+YUvfz1pgW3J+RK9cB/NUZRgykp2h+zq9Bkn
	9WgD5xDIxneKz5sZ+Nq9zuOCbi6Q8VCNt5cv36g/nWQYZDfqCJy7zmf0CSFaU9eI
	5P+y614HzGsTaphOZbU/xm6s2btq4NEhZPfXt2UgHkSR082ocKy/vvIX6+GHOE9n
	wvDstYzohLDvy059kkEdAwZRuz+qt5G/puA==
X-ME-Sender: <xms:unN8agHeDebdDBBlX-Kw2fGPfWMCVKQB0wImGCzdVpW3aRdebqF2cg>
    <xme:unN8atSzcr7yVArgIUxAQLrxJ9yN3ieQlDBYKqUoZdwsKzCKMDylUp4am1MB7FA8h
    Jn0OFPhAeOwtPy5J6dIn2rlGWa774oHFgiOiLeg2g_SGumv2ieJHA>
X-ME-Received: <xmr:unN8aipJlAzCcoduGeDacpZwJ3Ep3KCfDmHxKvpA-9Zr0RWPBDDdzOjHs8o>
X-ME-Proxy-Cause: dmFkZTE0/6XLAdQFuqe44OQHQeQYRpS5iWOZ9DFlKOuRxnmuw+2GfVqaAiNkcXyOtuigLI
    6v82YTSdHIga4gx61944e7Qf87G47WYGz4xEEoCuS6EFC+GQXBFwAPVb9FgxxzH5Zq9rlP
    OLoJeE6ARflaPRwnHFvhyT46A/5zwH73Hgpdc46yI24U8XmHHx/gE4zJXMii7mICcPkvND
    +0bTxM4TQu295Z3nqrKFSbaaLsHAvGNagbUtaAjqWcR2fHZgJsTKHx91jwff9hR3kciuLq
    cjXd8aSfEHXK/WxOVzgWa7Y5MqC2ejh+khrzJoVTyV/dzHlUC/dBVbC3hKqHsqm/5KLxPi
    vviH1b44pwD1lfuaviRWM3HNi45cKC+NelKEwR8mIYftz12ccMr5B5Sge4MidsOXNYmaR7
    GZTB0Y6E1zgAJC3CO4VxEp61+Kb9/43O+B6cHds2U+zKlbjMMj5lmzI1Gs3HWR5SdyV3FO
    fGV61t8ydZighv31h9n2mKBGPtDXOpRqqnqlJvj9SQuAz5XV3ynrXRjINmGdCk5L3YFLUe
    w6NK7QC2/xQyNg0nhts0AHZy2UWM2aM4rLc3AniePdaV+YR+4ITpcGIGAd8AaUZ8CcD4cQ
    UjMx3/dNwN8YwmmpDBQfj4U0S1wu3rZ+F+lQwfkddrwc/K0VBXNghs6nh/UQ
X-ME-Proxy: <xmx:unN8arrzcuURkDdvxTDKWg_ssIVXwbay3dvDN82LBtojB7ogFk8eMg>
    <xmx:unN8at00K8NdUeVZj00Qr6byX6rxuUDJ14mpJ8sEHyE3MLJ_KuNDpg>
    <xmx:unN8avgh6Uto6WU3thZ2_gl28J6T_vT1dIwn3YSMFXVF_lUo11if1A>
    <xmx:unN8aslsWXdfCDDeUsnX2QRL8Qxo3TsmfLprOE9jeYgInOqlCwdwIA>
    <xmx:u3N8amnAYmt2ev33EjNgNLCzgTJm8mE91geigVe_VccGWrE14o-2AHlz>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:06 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v3 00/18] selftests/mm: improve khugepaged coverage
Date: Wed, 12 Aug 2026 14:22:46 +0100
Message-ID: <20260812132304.199287-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA97B14000E
X-Stat-Signature: 4qzo4wuk8ncd8enck8nij6w3ppts166k
X-HE-Tag: 1786540988-329157
X-HE-Meta: U2FsdGVkX19hvutmB46XMaaZeRkldEoXLJA5IBjLKnjtav5sXLXIEkZP8pW9twMUqQqDkDul1sO7r5k1dR/sF/XnOPN2h8hdQPeuVnsgou1F64qT32MkKc9DJBVluHO36Nt0kymJ4nWhi3P/Fc1d+Au1J0o2z8p0w+Y5aKu1wwsnG8XiMVfPiZncniF6dHUbPtlQ2/fKKvQQ6M1s6uDHbnIx5YjhkyfWvTWfocFJTII2lUS8YJciEgBtvpbOIjx+mmvGUhrX85apU5Il4QBCA95ZLOUXGOur1pnQtgbSBEfutfotFPwZ6NkedEbEY/OtT5oEIVK0LTxWoOziy2k2YQ1GXLkCrRmeGcSJ32smo32CnbSDpO1zeeDw72TC0zi353hMeKcZ320+TcUVm6gAMsdrXLRPmlmIpFNHc9uPfJVBo68vC53gfL/T6WmpqeRe7n++CrNGP2lh0YB/RuY7Eho+TrVN6aePY4hfWfyBkbrY/W2M49OG+KGMmZ+Tw9mNgk30LtpAQnPWswiBUSq++UZ8mUJJdRBprelBsIyIGghUWf1ZWNMMNd6ydeqnLQjMKkAXVCc1gSyLQz2kZTE2PMTvOcFg0B8/n4kxyimfn3sUfwPE62ZtfDwQa2/8In+BHCy2qHX1tBbAOUG2vFj8LloRTRqtD2q6Nfy3k0CtEDtumbI5GmjaAs3GBmGNXxtfnYFQx0tOsMez5dfEP6NTxRoK16Gfo2r3Vv9pbTeuv+kajDwCmUg4a8EqUawOpfjhDB80kVtDPWsMvX0vCiBSjvOM/hlSdqlmbGarhBx2GMw70vFl20q8daq+h3I/qTHF7JHlT3e8gYm7F7BWe3QvFTiEj/jhhtmQNlVcD6su9rMV29e5Q7SQLInXlql6etFxyDggmIE1nBS+RdXtd0D6jA/xu/mhp5TrM96O61FbrMJPrlGwAgR+BgNzY2jLPdG6RcV8WVA0ivA3iXMR7ta
 jBvkFhvc
 uJ2jnS1QRjexWJvCJ6vrfDDk6kPtezNYp62OCXuHvy1YyJlZ0DKlEvvJo7qKsrjQMcuM8ofDRWhE/rBa3nrnX8F9gCXLZKRbNEK9XD6adlAMAgGiwj5+qQvuR3JXgRf5pXb9gCBAtvGaD2MANbznUcddGhrAI3+yFW16FwZc9hijOkMyNxYS7bz4RsMV9E8n/EDbllDsT+68hRDFkgdO1PGjpFAfsS4Tifu0pmUsrEW2BeZfa4TEm818peYMl+IoCjdAL3P7EOHvbPlcZGQQTNf6khST1QGdl+R6Hdb2vMEsEUnRFmcmXrE2AF5Ixx14RLYqHhlA00PmECmMIHmr6ej8qIKHY8jKOKQRuQRO303kFPa/hKY8g12q8JwEpywCXjNFvNZh7uJXy4SDJ/Id3+fVGkz7DxeqiGP0oWa37jmLxldK3M8ReIAM5GSrKyhi/BRd2mNzKFCn70Ak=
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
depends on the rework: everything passes on an unmodified kernel and
documents what khugepaged already does.

The table of cases is raised to 256 entries first. It holds 64, and a full
invocation -- every context crossed with every memory type, which needs a
directory for the file and shmem ones -- already registers 63, so the next
case added anywhere aborts the whole suite before a single test runs.

Four existing cases fail on the environment rather than on the kernel:

 - The collapse wait is a fixed three seconds, whatever a huge page costs
   to build. Scale it with the PMD size.

 - collapse_compound_extreme wants a 512M folio from the fault path. Skip
   it where the PMD is that large.

 - The page cache caps folio order below the PMD order where a PMD is 512M,
   so nothing can hold a PMD-sized page cache folio. Skip the shmem and
   file cases there.

 - The swap cases ask a best-effort MADV_PAGEOUT for an exact swap count,
   and khugepaged reads the pages back in while they ask. Retry, hold the
   range out of the daemon's reach while retrying, and skip if the pages
   still will not go.

This is why the suite now runs on arm64 with 64K pages.

Then the new coverage:

 - Folio-order helpers in vm_util, and folio_order_check to validate them
   against the kernel before any collapse test trusts them.

 - Four order-parameterized anon collapse cases, plus mixed sources by
   source order, at every supported order by default.

 - A shared-source write race: a co-sharer writing throughout a collapse
   and the collapsing side must not see each other's pages.

 - khugepaged_full_pass(), which steps the daemon one scan at a time
   through the sysfs wake path, and khugepaged_sync_check to hold it to
   exactly one attributed collapse per step.

 - khugepaged_race, racing faults, MADV_DONTNEED, pins, fork and mremap
   against collapse, checked by content and by KASAN and lockdep.

Changes since v2:

 - Raise MAX_TEST_CASES before adding cases (new patch 1): a full
   invocation aborted and ran nothing, at seven points in v2 (Sashiko).

 - The swap cases hold MADV_NOHUGEPAGE while paging out, and skip when the
   count still does not arrive, whatever the reason (Alexander Gordeev,
   David Hildenbrand).

 - Bound -s and -c: an out-of-range order indexed past a struct and shifted
   by 65 (Sashiko).

 - The mixed-source case skips, rather than ending the run, when the
   allocator leaves nothing of the source order (Sashiko).

 - khugepaged_race: clamp the zap and the pin to the shared areas, and keep
   stdio out of the forked child (Sashiko).

 - Name runs skipped after corruption the way finished ones are named
   (Sashiko).

 - Drop migration.c's ALIGN, which clashes with vm_util.h's (Sashiko).

 - Rebased onto current mm-new.

Muhammad's Tested-by is carried onto every patch whose code is unchanged or
only mechanically changed since v2. It is not on patch 1, which is new, or
on the swap patch, which behaves differently from what he ran.

Tested on an unmodified mm-new (480a31230b42), with KASAN, lockdep,
DEBUG_VM and page_table_check, in 16G guests:

  x86-64 4K     104 pass, 11 skip, 0 fail
  arm64 64K     102 pass,  3 skip, 0 fail

The skips are structural: mixed sources declines at the smallest order, and
at 64K collapse_compound_extreme skips as above. arm64 runs fewer cases
than x86-64 rather than skipping them: with no PMD-order page cache folio
the file and shmem contexts are never registered there.

Kiryl Shutsemau (Meta) (18):
  selftests/mm: raise the khugepaged test-case cap
  selftests/mm: skip collapse_compound_extreme where the PMD is too
    large
  selftests/mm: scale khugepaged's collapse wait with the PMD size
  selftests/mm: skip khugepaged page cache cases without a PMD folio
  selftests/mm: keep khugepaged out of the swapout the swap cases set up
  selftests/mm: move is_backed_by_folio() into vm_util
  selftests/mm: add folio-order check for address ranges
  selftests/mm: add folio-order detection self-check
  selftests/mm: add khugepaged completion barrier helper
  selftests/mm: add order-parameterized khugepaged collapse cases
  selftests/mm: parameterize the mixed-source collapse case by source
    order
  selftests/mm: cover a shared-source collapse write race
  selftests/mm: run every supported collapse order by default
  selftests/mm: verify synchronous khugepaged driving is attributable
  selftests/mm: add khugepaged race harness
  selftests/mm: race collapse of windows with holes
  selftests/mm: add memory-pressure threads to the khugepaged race
    harness
  selftests/mm: zap whole PTE tables in the khugepaged race harness

 tools/testing/selftests/mm/Makefile           |   3 +
 .../testing/selftests/mm/folio_order_check.c  | 137 ++++
 tools/testing/selftests/mm/hmm-tests.c        |   1 -
 .../testing/selftests/mm/hugepage_settings.c  |  72 ++-
 .../testing/selftests/mm/hugepage_settings.h  |   3 +
 tools/testing/selftests/mm/khugepaged.c       | 499 +++++++++++++-
 tools/testing/selftests/mm/khugepaged_race.c  | 610 ++++++++++++++++++
 .../selftests/mm/khugepaged_sync_check.c      | 217 +++++++
 tools/testing/selftests/mm/migration.c        |   1 -
 tools/testing/selftests/mm/run_vmtests.sh     |   8 +-
 .../selftests/mm/split_huge_page_test.c       |  62 --
 tools/testing/selftests/mm/vm_util.c          | 145 +++++
 tools/testing/selftests/mm/vm_util.h          |  10 +
 13 files changed, 1668 insertions(+), 100 deletions(-)
 create mode 100644 tools/testing/selftests/mm/folio_order_check.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c


base-commit: 480a31230b426efb005b6e71a14ef80f405f18b6
-- 
2.54.0


