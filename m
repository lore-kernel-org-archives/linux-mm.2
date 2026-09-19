Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B629FC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99CE26B00A9; Fri, 18 Sep 2026 20:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94D866B00AA; Fri, 18 Sep 2026 20:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C2B6B00AB; Fri, 18 Sep 2026 20:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52E166B00A9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45FD41C0881
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:24:59 +0000 (UTC)
X-FDA: 85228616718.05.896F14B
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3844480003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:24:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="DrjDn/cu";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=oN4KoF0D;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hVgL82cT6ooPhZVDeAfxwPcUntMD6kD+phmR5TdkVoI=;
	b=7dBC4sDcKCutzMk+HvCfzevwkOgu6LoNUAzXZT0GgBopxv6RHAhQ42HfISm8ddc1hkb30Z
	2Ymi/m+5lxmuukhpOB0C3jVi8AqLeJ3X5T56NMV84x8LDGhjZ+MfL1ENOg+9ofcLIKYYsW
	oDCSu7jKJig0UKWB8v9h9+OnBvxMK9E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="DrjDn/cu";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=oN4KoF0D;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777497;
	b=t+3u1ZXSPo+r2KSgI1QFeSVYPQSiSnzSbwk69JIdzsz9YK5leiFZeQmdIg17MqjfPF/q14
	+c6tux2B1wKyYesRwIqBy+QKCh/thAZQx912cPXgM/Dwzg2l8RxwNPBMOWaJo7a3C5vTN1
	RlbAKUissUEfR///hJfJo4pfsguKPWA=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 82CF6EC0198;
	Fri, 18 Sep 2026 20:24:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 18 Sep 2026 20:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1789777496; x=1789863896; bh=hVgL82cT6o
	oPhZVDeAfxwPcUntMD6kD+phmR5TdkVoI=; b=DrjDn/cur1Eu+zXIEzQjeIEJDd
	w+MlcaIlcQ4ZKgb3lR4QhmJOL3+aQwHrBf3v401AUlc9hdLvngLJzKvVHL5FAQCg
	omyPWQ/Y5XJ60Dnpab/QdCpKh1thku8j6dUFYKrM6LO2cfsiObPXxgScqVDnwcvT
	dl8DlbHoFreJtySR95NU7abDVn+FQL1urmfAZKi6C0G9oDbVwuxNtCgSM26Q322K
	6qkavMC0BtSXheBC4v0s5xgSXL/6VWD7S1oHgBC/icrv9fPsYThM1l5ugU8LBmma
	w6CXO8BXluUXTwcXKtQSIy4BGkp00xHeIM967T74cdY4XeMD0okQOUM3sX1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789777496; x=1789863896; bh=hVgL82cT6ooPhZVDeAfxwPcUntMD6kD+phm
	R5TdkVoI=; b=oN4KoF0Djk3cNQQsitsJtY+wN59PEoci3oEQa8oWu6z84w1mvcu
	KVzOtP6TEtkyhxqqJhlagp8KfDW4DKSiWhiE6Z3jBSST02bNpLM4zEgtBaKzZCE6
	p855awyzo99VoFErOfHH5epsax40B63ykTb7CXrL+qJSj64rfyiKNp28iE1R+IPp
	Q+UQ60dn5zMbN+fiFS5YpEg9JPapslb/4Slt3hc2biYka+uOaFY/Jipf9Un0LiHd
	OvdhjjPi+JVG3JRzCrSTYd2+FbGIyN3cPgbtmEEtg88nqzSarh/e5S3BdWCDeJl/
	WQ2qVznNfUKWfxHQG9/uzMDFZ6igkKf4HRg==
X-ME-Sender: <xms:V9atauhdN64wGMh6XPheVcLt0GHmtdje0dfRZH8d0uDlYuNvUEMzOA>
    <xme:V9atanYEFhi5B-wQ5gRCsRihJ71IxYMPp3c4qdjuvfsfgUFnqCMLGmvV67AnGY_9Y
    xWibhm8K8wxBj5iH7q6VWvtUP_IGTiniSF54z0qRqMIE4YcqtjK>
X-ME-Received: <xmr:V9ataoRC7qRiYrDh6lYtZCKRS7yNI1GHcrabWadmgKOWI45KHD45eahFhHo>
X-ME-Proxy-Cause: dmFkZTFBXxxa9mfQlFJJmOXUnFpfpcCYL+TF1M1gd9VL29pJbzMKVsFhe5TjhlPsrJdPXp
    Izu2iNtQ0f25NpEcmIW8Q0lciacKGUngRU2oln5gr99Cau5GzNh45L/ps4WXrKT+3LcCof
    onc6tS7bxQVWmnxki/U4GgpGBt/Uf/XMffQsRGbNmfEuwORt12ZNWY7zW1qFuP7VpWYdge
    sKBBkddISsUZf0VSYzwVngjTfAJhrTlPE7NbYeFLcaw6KfjLwRi22/JSUPcfj+6sSfXkz3
    2hSRT44SNPTaJZDcRkQzSRVQx7u15eQNLkSPYgkclga/ey1JLSmLY0wvFq7EAonuDYIasY
    nit6Op3onNIzCnPf+gSNaTuHTkMSmu+3AGMa59i/mholeequdCp7zR2USGhzHPAGour6NT
    8X4dq8r0S2VWV0ZiZtpk3w0Eh1T/ObJHUxQMblTCGanAtS4KtrUMOuADbOOEVex0xNj/B7
    aO+eYM6dy89XhmKYjY/3oa+0iFuxeXU8Arw36rrgbDXuVw4sn4LB8N+xN7D4rrgoCWWTap
    2Z5pTfQ5UkQZjXLJ/FyiOSdVVTl3uI8gqrU5ySPV0Mm5W5xEOOukxyqspXnB/4WEjNeuVI
    4elaRbOIPEWXM+9xKBFufzjWZU/m59V98gIyeNToblp9S/UtECJhcMUy9otg
X-ME-Proxy: <xmx:V9atavEbQwTnZH0ZZY-EsQ2AGBxliKrtsl8tUTPKnZTpHPVpDFhF1Q>
    <xmx:V9atat3UqiXjFxtraFU-qDEv59qTbYQO3jmuXEbQSccUWwtHiogvYg>
    <xmx:V9ataluPxqqLzDazazQBq_3CakD06uY9QTbqMY-s3O0iRXQNI143Uw>
    <xmx:V9atasl1LNEXgIVI8OQ5QCcqUvFTNzxZ8p5tqT6Y-k_iC7t2XLNpCA>
    <xmx:WNataqLjOOrohMhYluqXOxQtbT37d1R9vJq3EWMiyV0ugQaZkB7DtGIx>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:24:54 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 00/19] selftests/mm: improve khugepaged coverage
Date: Sat, 19 Sep 2026 01:24:30 +0100
Message-ID: <20260919002451.496763-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1arc3cw5swxt63khrhoy6mwj5fkh3b7e
X-Rspamd-Queue-Id: 3844480003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789777497-364635
X-HE-Meta: U2FsdGVkX19lYSoHfEtsJDXH7Xn41CS6ZBE+pVga1GNEfYzydKAYc9pSJulT469Mai6RdWvtz/I/XFm0uCtM1pd4fAszC9os3JiW8jaZs/kHkD48w5XlcTvLVHepIp1rGhq9i6cXeZEJscs4bLT6gMDgG81mtwvkmx+Y/eSO0JOLAM5s4T2bJAfi8T6nEihiBgKGlGexIPMXp1z3eZUbBksTSdz56O1i3V9qdmUD3X9+vNs9uBPyEQO/Pnq+wRSmQ/aQTt+S+xeq4X0TKjpzjLqKPJ9n20QkBhapDd9/cHDy3qA7kZvFawN2Vyte4J0x9VIuaIs92kZ4234rpmlf8KVGbRVa5pMWf51XE8e4ZXiQPXUEQ4lywx07EAxSjYHsw1DcSHxrcip6F38zYla0jU64VpdmYMhEBH8BIECFxmI93J86z3qZtZ0/4ZFPriyiJFyEQQXmP/3XSAbdyKsSVouxy2fsQcrtUxALBWgXLx5QnB28iz2wih8Idt5toOWVE0Byhau+8Mx0zOXuZj0cqt6pq2/d2de5k63iZIyhc/J5EHgBfFl6e0CH/y1iDM0JGMmm1lIFJIixy7sy0+SUTdVktYAWus8JZMh1TdjwqUlYik96kU9PYUIqzgYzhdghgZl71c14yHGYEUjMdzzX66Hgtoo8X8aAUC9STa07UQ8Wd2l8Gw/3Zqkqjmy2ec5KGWLirfOGrjcOP6fwBtf7rOrRlrOfrwkZ8hJwe3Req2C2LcFAmcWdvOZXBW22bkXLDhXS5EbSpmB9sZzWAn1uPdW5oE9tADSXmksyO0g3Ss3YzGN+KSfdlwMfKr/aFTssnKBZP1twojjUCkvm8h9icB3wKlZ6a02+YeHQSBYUfj8NSq/lscb7ayw0Kq1SAHDvjZVThingLoguqOZ7s2m8eevsSYgYeHwnvw2UnbuQIcLSTuDvZvUa4BdpdV2Bsta292vrxva0EAjIH5AUVrG
 Z3DsUHwQ
 ACoNjhdU+7P1xMLm9VwiTAgar3bWVX3lekMUK5kSiDAK9WwCUWvxNzkz2TjhfvwWzS6mc9UmBbKq5SgN7zhzz/Jsqy8mrNjB+it4DD3OIINPECY9eINBm1ozTDnu65toAeepUBgDzL0nZO7xQeySdgqIfWsPoIUe49rlhgQAY5TDPlwwrSqpPZFIlfaqLH+y4WSrcb9Xc6fFd8TDpncPR0qgthxjicFvzBSsOGt4kxKMZDM7osA/DEu0F8n+8tTP1ivGr38MMovcXUNKqqnww4acB0sRdoIC34AQndmzg44kjZbl1orQOFonZ7fBF/+fp/xY1JY//TtiKNqy0KHJvgpeAtwRShJcdcORZPCiGTRtdg1IuDvfM4XKuDECKQy/F8xW8ODepgNvMv2IDISdvHEqJjyySMAbhkkH/u9xbziY00wTD0GXVjyJCzNcoCKc1S1fx4rYQUdSeF8pA0W6sycjyZhUoUWMWat797ixA4OMmNPskQoRQczgqAZV5wXN5pdqgaOtjoaydSDXMmml+3mGcHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

khugepaged collapses to mTHP orders since 7.2, and 7.3 added three
selftest cases for it: the generic collapse cases run at one order named
by -c, with the result detected by counting folios of that order.

That leaves the collapse path largely untested.  The suite does not run
where a PMD is 512M.  A folio count cannot say where a collapse landed.
Fixed sleeps cannot tell "not collapsed" from "not scanned yet".  And
nothing exercises collapse under contention.

Close those gaps in order:

 - Make the suite run at a 512M PMD: scale the collapse wait with the PMD
   size, skip what such a PMD cannot serve, make the swapout the swap
   cases depend on deterministic, and keep khugepaged out of the
   MADV_COLLAPSE cases.

 - Detect results per window rather than by count, with folio-order
   helpers in vm_util that are checked against the kernel before any
   collapse test trusts them.

 - Drive khugepaged deterministically: a completion barrier that wakes the
   daemon and waits for a full pass, and a check that one pass yields one
   attributed collapse.

 - Cover collapse at every supported order by default: which window
   collapses, occupancy at both limits, sources that are already large
   folios, and a fork-shared source under concurrent writes.

 - Race collapse against everything that can touch its sources, at both
   occupancy limits and over whole-table zaps, checked by content and by
   the kernel's own assertions.

Everything passes on an unmodified kernel.

Changes since v5:

 - Rebased onto mm-new: hugepage_settings lives in tools/lib/mm now, so
   the new helpers and the three new binaries follow it there.
 - The MADV_COLLAPSE cases set the per-order controls to "never" rather
   than "inherit", which "mm: shmem: ignore sysfs configs for shmem
   forced collapse" (in mm-new) made safe for shmem, and the Fixes tag
   names the khugepaged commit that started the interference (Baolin
   Wang).
 - The "-c at or below -s" check moves from patch 14 to patch 12, where
   -s first gains that meaning (Baolin Wang).
 - Patch 08's changelog no longer claims check_huge_anon() reads smaps
   (Baolin Wang).
 - The two Sashiko fixups posted against v5 are folded in: the fork race
   closes its pipe and checks waitpid(), and the race harness keeps its
   mremap scratch address reserved.
 - Baolin Wang's Reviewed-by on 01-05, 07, 10 and 14, Tested-by on 14.

Merging is_range_backed_by_order() with the check_huge_*() family stays a
follow-up, once Yeoreum's rewrite of those on top of pagemap and
kpageflags has landed.

Tested on mm-new 498ee28e5ec4 with KASAN, lockdep, DEBUG_VM and
page_table_check, in 16G guests:

  x86-64/4K   khugepaged all:all  104 pass, 11 skip, 0 fail
  arm64/64K   khugepaged all:all  102 pass,  3 skip, 0 fail

folio_order_check, khugepaged_sync_check and khugepaged_race pass on both.

The skips are structural: tmpfs cannot host some file cases, and mixed
sources has no order below the smallest.  arm64 never registers the file
and shmem contexts, having no PMD-order page cache folio.

Range-diff against v5:

 1:  759b73a5f738 !  1:  14a0a1d44862 selftests/mm: raise the khugepaged test-case cap
    @@ Commit message
         Acked-by: Usama Arif <usama.arif@linux.dev>
         Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
         Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## tools/testing/selftests/mm/khugepaged.c ##
 2:  8160b5446e94 !  2:  2265f32a677c selftests/mm: skip collapse_compound_extreme() where the PMD is too large
    @@ Commit message
         Assisted-by: LLM
         Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
         Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
 3:  c6a21ef8d798 !  3:  f14ae037a749 selftests/mm: scale khugepaged's collapse wait with the PMD size
    @@ Commit message
         Assisted-by: LLM
         Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
         Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
 4:  b039045f38b3 !  4:  cbe5dac4febc selftests/mm: skip khugepaged page cache cases without a PMD folio
    @@ Commit message
     
         Assisted-by: LLM
         Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
    - ## tools/testing/selftests/mm/hugepage_settings.h ##
    -@@ tools/testing/selftests/mm/hugepage_settings.h: void thp_set_read_ahead_path(char *path);
    + ## tools/lib/mm/hugepage_settings.h ##
    +@@ tools/lib/mm/hugepage_settings.h: void thp_set_read_ahead_path(char *path);
      unsigned long thp_supported_orders(void);
      unsigned long thp_shmem_supported_orders(void);
      
 5:  0ee82084bd2b !  5:  021a1fcf711a selftests/mm: make the swap cases' swapout reliable
    @@ Commit message
     
         Assisted-by: LLM
         Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
 6:  4e48b431671e !  6:  e80ef0e8acc0 selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
    @@ Commit message
         collapses the very range the case is working on, and the case fails on a
         collapse that was interfered with rather than refused.
     
    -    Clear the per-order controls too, setting them to "inherit" rather than
    -    "never": khugepaged honours the global never and stays out, while
    -    MADV_COLLAPSE on shmem still finds an order to build.
    +    Clear the per-order controls too.  MADV_COLLAPSE does not consult them:
    +    anon never did, and shmem stopped with "mm: shmem: ignore sysfs configs
    +    for shmem forced collapse".
     
    -    Fixes: 9f0704eae8a4 ("selftests/mm/khugepaged: enlighten for multi-size THP")
    +    Fixes: b7f16963efe7 ("mm/khugepaged: run khugepaged for all orders")
         Assisted-by: LLM
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
    @@ tools/testing/selftests/mm/khugepaged.c: static bool is_anon(struct mem_ops *ops
      	ksft_print_msg("%s...", msg);
      
     @@ tools/testing/selftests/mm/khugepaged.c: static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
    - 	/*
    - 	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
    - 	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
    -+	 *
    -+	 * "inherit" rather than "never" so that MADV_COLLAPSE on shmem still
    -+	 * finds an order to build.
      	 */
      	settings.thp_enabled = THP_NEVER;
      	settings.shmem_enabled = SHMEM_NEVER;
     +	for (i = 0; i < NR_ORDERS; i++) {
    -+		settings.hugepages[i].enabled = THP_INHERIT;
    -+		settings.shmem_hugepages[i].enabled = SHMEM_INHERIT;
    ++		settings.hugepages[i].enabled = THP_NEVER;
    ++		settings.shmem_hugepages[i].enabled = SHMEM_NEVER;
     +	}
      	thp_push_settings(&settings);
      
 7:  154a014dc5ad !  7:  e61798d22782 selftests/mm: move is_backed_by_folio() into vm_util
    @@ Commit message
         Assisted-by: LLM
         Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
         Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
    @@ tools/testing/selftests/mm/split_huge_page_test.c: const char *kpageflags_proc =
     -	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
     -fail:
     -	ksft_exit_fail_msg("Failed to get folio info\n");
    --	return false;
     -}
     -
      static int check_after_split_folio_orders(char *vaddr_start, size_t len,
    @@ tools/testing/selftests/mm/vm_util.c: int pageflags_get(unsigned long pfn, int k
     +	return (pfn_flags & folio_tail_flags) != folio_tail_flags;
     +fail:
     +	ksft_exit_fail_msg("Failed to get folio info\n");
    -+	return false;
     +}
     +
      /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 8:  a23eab162641 !  8:  be5fb9342657 selftests/mm: add folio-order check for address ranges
    @@ Commit message
     
         An mTHP collapse test needs to know that a range is backed by folios of the
         target order, and that they sit where a collapse would put them.  Nothing
    -    answers that today: is_backed_by_folio() classifies the folio behind a
    -    single page, and check_huge_anon() reads smaps AnonHugePages, which only
    -    accounts PMD mappings.
    +    answers both: is_backed_by_folio() classifies the folio behind a single
    +    page, and check_huge_anon() counts the folios of an order in a range
    +    without saying where they start.
     
         Add is_range_backed_by_order().  It requires every folio-sized, folio-
         aligned part of the range to map one folio of that order, head to tail,
    @@ Commit message
     
      ## tools/testing/selftests/mm/vm_util.c ##
     @@ tools/testing/selftests/mm/vm_util.c: bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
    - 	return false;
    + 	ksft_exit_fail_msg("Failed to get folio info\n");
      }
      
     +/**
 9:  cd741198f81e !  9:  af0191f5548c selftests/mm: add folio-order detection self-check
    @@ tools/testing/selftests/mm/Makefile: TEST_GEN_FILES += guard-regions
      TEST_GEN_FILES += rmap
      TEST_GEN_FILES += folio_split_race_test
     +TEST_GEN_FILES += folio_order_check
    - 
    - ifneq ($(ARCH),arm64)
      TEST_GEN_FILES += soft-dirty
    + 
    + ifeq ($(ARCH),x86_64)
     
      ## tools/testing/selftests/mm/folio_order_check.c (new) ##
     @@
    @@ tools/testing/selftests/mm/folio_order_check.c (new)
     +
     +#include "kselftest.h"
     +#include "vm_util.h"
    -+#include "hugepage_settings.h"
    ++#include <mm/hugepage_settings.h>
     +
     +static int pagemap_fd;
     +static int kpageflags_fd;
    @@ tools/testing/selftests/mm/run_vmtests.sh: CATEGORY="pfnmap" run_test ./pfnmap
     
      ## tools/testing/selftests/mm/vm_util.h ##
     @@
    - #include <linux/fs.h>
    + #include <mm/hugepage_settings.h>
      
      #define BIT_ULL(nr)                   (1ULL << (nr))
     +#define ALIGN(x, a)                   (((x) + (a) - 1) & ~((a) - 1))
10:  2099301ff2c1 ! 10:  a105628f6e9b selftests/mm: add khugepaged completion barrier helper
    @@ Commit message
         khugepaged knob only when its value changes.
     
         Assisted-by: LLM
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
    - ## tools/testing/selftests/mm/hugepage_settings.c ##
    -@@ tools/testing/selftests/mm/hugepage_settings.c: void thp_read_settings(struct thp_settings *settings)
    + ## tools/lib/mm/hugepage_settings.c ##
    +@@ tools/lib/mm/hugepage_settings.c: void thp_read_settings(struct thp_settings *settings)
      	}
      }
      
    @@ tools/testing/selftests/mm/hugepage_settings.c: void thp_read_settings(struct th
      void thp_write_settings(struct thp_settings *settings)
      {
      	struct khugepaged_settings *khugepaged = &settings->khugepaged;
    -@@ tools/testing/selftests/mm/hugepage_settings.c: void thp_write_settings(struct thp_settings *settings)
    +@@ tools/lib/mm/hugepage_settings.c: void thp_write_settings(struct thp_settings *settings)
      			shmem_enabled_strings[settings->shmem_enabled]);
      	thp_write_num("use_zero_page", settings->use_zero_page);
      
    @@ tools/testing/selftests/mm/hugepage_settings.c: void thp_write_settings(struct t
     +	thp_update_num("khugepaged/max_ptes_shared", khugepaged->max_ptes_shared);
     +	thp_update_num("khugepaged/pages_to_scan", khugepaged->pages_to_scan);
      
    - 	if (dev_queue_read_ahead_path[0])
    - 		write_num(dev_queue_read_ahead_path, settings->read_ahead_kb);
    -@@ tools/testing/selftests/mm/hugepage_settings.c: void thp_write_settings(struct thp_settings *settings)
    + 	if (dev_queue_read_ahead_path[0]) {
    + 		int ret = write_num(dev_queue_read_ahead_path,
    +@@ tools/lib/mm/hugepage_settings.c: void thp_write_settings(struct thp_settings *settings)
      	}
      }
      
    @@ tools/testing/selftests/mm/hugepage_settings.c: void thp_write_settings(struct t
      {
      	if (!settings_index) {
     
    - ## tools/testing/selftests/mm/hugepage_settings.h ##
    -@@ tools/testing/selftests/mm/hugepage_settings.h: static inline void thp_save_settings(void)
    + ## tools/lib/mm/hugepage_settings.h ##
    +@@ tools/lib/mm/hugepage_settings.h: static inline void thp_save_settings(void)
      	hugepage_save_settings(/* thp = */ true, /* hugetlb = */ false);
      }
      
11:  060448cb8a03 = 11:  27295f7decd1 selftests/mm: add order-parameterized khugepaged collapse cases
12:  674fbf72a481 ! 12:  60e86026c227 selftests/mm: parameterize the mixed-source collapse case by source order
    @@ Commit message
         supported mTHP order below the target.  The other mTHP cases are
         unaffected: mthp_push_target_order() enables only the target order.
     
    +    A -c at or below -s is refused before any case runs: the sources would
    +    already be the size being asked for.  Without the check the generic cases
    +    fail on that one by one instead of saying why.
    +
         "-s 5 -c 7" on arm64/64K then collapses contpte-mapped sources into a
         larger mTHP.
     
    @@ tools/testing/selftests/mm/khugepaged.c: static void usage(void)
      	exit(1);
      }
      
    +@@ tools/testing/selftests/mm/khugepaged.c: int main(int argc, char **argv)
    + 	    !(thp_supported_orders() & (1UL << collapse_order)))
    + 		ksft_exit_skip("Order %d is not a supported anon THP order\n",
    + 			       collapse_order);
    ++	if (mthp_khugepaged_context && collapse_order <= anon_order)
    ++		ksft_exit_skip("-c %d needs a source order below it, -s says %d\n",
    ++			       collapse_order, anon_order);
    + 
    + 	if (mthp_khugepaged_context) {
    + 		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
13:  d2251908b73f ! 13:  39a895e66cf1 selftests/mm: cover a shared-source collapse write race
    @@ tools/testing/selftests/mm/khugepaged.c: static void collapse_max_ptes_shared(st
     +	close(sync[1]);
     +	if (read(sync[0], &go, 1) != 1)
     +		ksft_exit_fail_msg("child never reached the collapse\n");
    ++	close(sync[0]);
     +
     +	/*
     +	 * Unshare one page at a time: a burst would break CoW on the whole
    @@ tools/testing/selftests/mm/khugepaged.c: static void collapse_max_ptes_shared(st
     +	 */
     +	i = 0;
     +	for (;;) {
    ++		pid_t ret;
    ++
     +		if (i < n)
     +			ip[i * stride] = i + 0xbeef0000;
     +		i++;
     +		usleep(10 * 1000);
    -+		if (waitpid(child, &wstatus, WNOHANG))
    ++		ret = waitpid(child, &wstatus, WNOHANG);
    ++		if (ret == child)
     +			break;
    ++		if (ret < 0)
    ++			ksft_exit_fail_perror("waitpid()");
     +	}
     +
     +	/* Finish whatever the paced sweep did not reach */
14:  30e316efbd9f ! 14:  8e214f9ef2ea selftests/mm: run every supported collapse order by default
    @@ Commit message
         and "all".  Also:
     
           - -c still pins one order, and now says what is wrong instead of
    -        printing the usage text.  An order at or below the -s source order is
    -        skipped: the sources would already be the size being asked for.
    +        printing the usage text.
     
           - Both orders end up as array indices and shift counts, so -s and -c
             are range-checked before they get there.
    @@ Commit message
         pinned order-4 line.
     
         Assisted-by: LLM
    +    Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
    +    Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
         Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
     
      ## tools/testing/selftests/mm/khugepaged.c ##
    @@ tools/testing/selftests/mm/khugepaged.c: int main(int argc, char **argv)
     -	    !(thp_supported_orders() & (1UL << collapse_order)))
     -		ksft_exit_skip("Order %d is not a supported anon THP order\n",
     -			       collapse_order);
    +-	if (mthp_khugepaged_context && collapse_order <= anon_order)
    +-		ksft_exit_skip("-c %d needs a source order below it, -s says %d\n",
    +-			       collapse_order, anon_order);
     +	if (mthp_khugepaged_context) {
     +		unsigned long orders = thp_supported_orders();
     +
15:  e891ab107e3a ! 15:  95ae01ec50dd selftests/mm: check that one khugepaged pass collapses one window
    @@ tools/testing/selftests/mm/Makefile: TEST_GEN_FILES += merge
      TEST_GEN_FILES += folio_split_race_test
      TEST_GEN_FILES += folio_order_check
     +TEST_GEN_FILES += khugepaged_sync_check
    - 
    - ifneq ($(ARCH),arm64)
      TEST_GEN_FILES += soft-dirty
    + 
    + ifeq ($(ARCH),x86_64)
     
      ## tools/testing/selftests/mm/khugepaged_sync_check.c (new) ##
     @@
    @@ tools/testing/selftests/mm/khugepaged_sync_check.c (new)
     +
     +#include "kselftest.h"
     +#include "vm_util.h"
    -+#include "hugepage_settings.h"
    ++#include <mm/hugepage_settings.h>
     +
     +#define BASE_ADDR ((void *)(1UL << 30))
     +/* Smallest order khugepaged considers */
16:  d7f8e59c19f1 ! 16:  343b8684a8bd selftests/mm: add khugepaged race harness
    @@ tools/testing/selftests/mm/Makefile: TEST_GEN_FILES += rmap
      TEST_GEN_FILES += folio_order_check
      TEST_GEN_FILES += khugepaged_sync_check
     +TEST_GEN_FILES += khugepaged_race
    - 
    - ifneq ($(ARCH),arm64)
      TEST_GEN_FILES += soft-dirty
    + 
    + ifeq ($(ARCH),x86_64)
     
      ## tools/testing/selftests/mm/khugepaged_race.c (new) ##
     @@
    @@ tools/testing/selftests/mm/khugepaged_race.c (new)
     +
     +#include "kselftest.h"
     +#include "vm_util.h"
    -+#include "hugepage_settings.h"
    ++#include <mm/hugepage_settings.h>
     +#include "../../../../mm/gup_test.h"
     +
     +#ifndef FOLL_WRITE
    @@ tools/testing/selftests/mm/khugepaged_race.c (new)
     +			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_area);
     +		if (p == MAP_FAILED)
     +			ksft_exit_fail_perror("mremap() back");
    ++		/* The move back unmapped the scratch address: claim it again */
    ++		if (mmap(mremap_scratch, hpage_pmd_size, PROT_NONE,
    ++			 MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE,
    ++			 -1, 0) != (void *)mremap_scratch)
    ++			ksft_exit_fail_perror("mmap() mremap scratch");
     +		usleep(rand_r(&seed) % 2000);
     +	}
     +	return NULL;
17:  f85220ed8bb4 = 17:  09cfcb6afbc4 selftests/mm: race the collapse of windows with holes
18:  b3738ea322b7 = 18:  b12f1f2d500c selftests/mm: add memory-pressure threads to the khugepaged race harness
19:  66f5a400e015 = 19:  ad0be4f7ec43 selftests/mm: zap whole PTE tables in the khugepaged race harness

Kiryl Shutsemau (Meta) (19):
  selftests/mm: raise the khugepaged test-case cap
  selftests/mm: skip collapse_compound_extreme() where the PMD is too
    large
  selftests/mm: scale khugepaged's collapse wait with the PMD size
  selftests/mm: skip khugepaged page cache cases without a PMD folio
  selftests/mm: make the swap cases' swapout reliable
  selftests/mm: stop khugepaged during the MADV_COLLAPSE cases
  selftests/mm: move is_backed_by_folio() into vm_util
  selftests/mm: add folio-order check for address ranges
  selftests/mm: add folio-order detection self-check
  selftests/mm: add khugepaged completion barrier helper
  selftests/mm: add order-parameterized khugepaged collapse cases
  selftests/mm: parameterize the mixed-source collapse case by source
    order
  selftests/mm: cover a shared-source collapse write race
  selftests/mm: run every supported collapse order by default
  selftests/mm: check that one khugepaged pass collapses one window
  selftests/mm: add khugepaged race harness
  selftests/mm: race the collapse of windows with holes
  selftests/mm: add memory-pressure threads to the khugepaged race
    harness
  selftests/mm: zap whole PTE tables in the khugepaged race harness

 tools/lib/mm/hugepage_settings.c              |  60 +-
 tools/lib/mm/hugepage_settings.h              |  11 +
 tools/testing/selftests/mm/Makefile           |   3 +
 .../testing/selftests/mm/folio_order_check.c  | 122 ++++
 tools/testing/selftests/mm/hmm-tests.c        |   1 -
 tools/testing/selftests/mm/khugepaged.c       | 488 +++++++++++++++-
 tools/testing/selftests/mm/khugepaged_race.c  | 538 ++++++++++++++++++
 .../selftests/mm/khugepaged_sync_check.c      | 179 ++++++
 tools/testing/selftests/mm/migration.c        |   1 -
 tools/testing/selftests/mm/run_vmtests.sh     |   8 +-
 .../selftests/mm/split_huge_page_test.c       |  61 --
 tools/testing/selftests/mm/vm_util.c          | 146 +++++
 tools/testing/selftests/mm/vm_util.h          |  10 +
 13 files changed, 1526 insertions(+), 102 deletions(-)
 create mode 100644 tools/testing/selftests/mm/folio_order_check.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c


base-commit: 498ee28e5ec4727f829507c4a1bde3ab1b7704cd
-- 
2.54.0


