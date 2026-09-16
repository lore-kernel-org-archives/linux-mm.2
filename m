Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F6DC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 04:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466A56B0088; Wed, 16 Sep 2026 00:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4179D6B008C; Wed, 16 Sep 2026 00:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332756B0092; Wed, 16 Sep 2026 00:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B29D6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:49:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 659101C2AD6
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:49:41 +0000 (UTC)
X-FDA: 85218397362.15.846E6D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5EC5580004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:49:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N7Tenfye;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789534179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F/a4aK+gN/7WQgr9WGLAxW26AQdjhDeu9mCp96kKnlY=;
	b=pT/9ide8SB9EUo/TaDEOJorqUKdGzT7tM6olnsA1rqxdk/hlb2n8XQfJhAJL2OG8Mh/vd9
	gSQ5IFx2AQ5fSibE5gHAOgBBO2x7TsrzP8sIA5HFFlWUW/axUzdgFDLjf3i1J8UAtmcxFW
	T1Q8dIhvCt2fJObq9YqlBN6OCdU3hHY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N7Tenfye;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789534179;
	b=zb/AkjjnSkA0Y1coSyUWJf2XO08pBYTS25PtEr5Z6oiWbiPo48oeuJYUjeCN9V5HaFIvGN
	wtEzrbmbrZ8F/gQGsOp9E+xCDKq1j47f3H+GIwZCNY+ssmb/m2rkkl5PTJ0uMrqIxFo8pi
	s5FfCxVROJwtY27sEeHgRDJhz3KK7uY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83D271516;
	Tue, 15 Sep 2026 21:49:34 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60B6F3F86F;
	Tue, 15 Sep 2026 21:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789534178; bh=jycAePJzGoWD7iuHXNX/pHzEJqNW9LDecK84UF0GsGc=;
	h=From:To:Cc:Subject:Date:From;
	b=N7Tenfyeb/B92byMKzxo1+YO/EFOWyugBUnMdXx1oEjuQ9cSSD5iIVZ474nePzmoX
	 CwMZwNXxrUMYvcukYA/lHLlG7CkOn+z+ffmh+TMx9ZYdbPhPCxyzmm5AWUl9od8SiA
	 sKMCxSgd0qLhr75AsY9BQ8BLyfVOHmbWuLoxwixk=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 0/2] arm64/mm: Standardize printing for pgtable entries
Date: Wed, 16 Sep 2026 10:19:31 +0530
Message-ID: <20260916044933.2689426-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5EC5580004
X-Stat-Signature: a7zbythmyphca4o3ugsz96iaxgdqs38w
X-Rspam-User: 
X-HE-Tag: 1789534179-238216
X-HE-Meta: U2FsdGVkX19Y9mjkk+PCi7SrVuHYQMuANBoABUG0aEdcoln1GVWuqDAUx+iwnztf8x5gN/X/JdIaNsJrgeNLd6ajJjXvFECw3iGkXn+N/DhGgAfbyhG1RcJfleMfaEdTP3CbYU9Xc21Za7t4hdI9dHzBvp08FdbQW94dpzIE7EyflOYGJZOuh0q6ZDcj4Wt3LrBF9PDPV+lFnaFfSE/uSxaWvn6OerZzFBvoTbE23EsPZqGB4uo6wlwJUmYoE4MwCW+h3WK1IRQaw4plM8gnZm6cxlZFuRvC2LCgr8UBG9oF4E+uo2EwsEmQttZna0gjGutlVKGt+8iS0/VPVv+fXiQ3OyiZ9e2UnHCHsgX9PH2TvjHOLubVYC0OAtR++WC1Kq46JvZBVjBmQJsx1ikEAy3Vdqfcehm0EDEdc+VWqmfTyld69B/Zys+mrl3QzsUtkdwK78b8ZwXuLa6P09b6+rZEVpDv0ceYtX+pWkQlm8ZJlng+utvD69SHR1zPhg9zPb/7Fl3J9i3PG+smVkhz6np1ZYF3lgs3OFcdAIFXJk8iGCnDAc+XRId9Na8eChUsioIrkrSOEM9NH98upff62xhH8LTlvJ8hVpBD9W8kj5ZGo5ZP6NNH/MzeMNSeyrl+Kc+h3r777vHN5Znt58wxSfT6tRLE9ulI6NOiEfS6LYg2k96GG1UFthXJKDr6OTt51SJA/QQ1tghqpwQs8TruwMPgp5NKJHhj/192evmSztOI60byZzSHDsU5KrJ23G/g9DNLPvQyC2yyu2bANiflMF+9q8qqUewLMVpwczO2waVmilDHWghB4KH/tpx9cUNo73QNJaRFRcBtL0UIiOyWGC4yOX025dEppYY6GKrO7Vzh7nGIlpUtVjuOPmLMLi4TzTyMVkb1svPWKVJinLIekT5c8G5BPPkxCGsn2MCSmRoIiPtg9O/wFueJL6MXIWrflmVqZ6aqsqR/d50qbf0
 0/I3+YcI
 TPtva5QGLUTN6I+2ZQ8li2q+GuTKTJrrGskJrd1vd8yDy6HxNnCTqzKtSTRpFCltPNF2euKYaKdVXA9VX10Ik4N/mPGuBFjmMhpUcwjKwPdLZx9OLCiJvX1ENdHMCn/8XUaK8GueAxphoIHHuKFVJPWhkP8QBlJ4Ik6d8CuenFOKsG8fMutDVcQ50o+uIsb5B2wL5OcjPVfelwLVvAtJ0vtsDQglFN+kYErXccynTFGPsMvcZ5odsO3HlHyJ77UAiaejFfostINklnmpcuv1ujxxl1SI+4cAUWl68y7R5gSYkyj6C+D/rS1kN+Z/VeP4xebGWY7aqSFVKXK5A5ZZsuDxWzoNdzO0S/1k7IAoUXSVTsamX8uE0D21jhf3mL53vXl8D0aC4X0+zrkNjpY0a2j9AYWsOieYxD7/w872Udse89IiNYn2gqAc+fO1qmiRUqNP8Crhvr/6y4bYSLhbK+sOQRpdigaPKugDeOfcflLdlzQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Standardize printing for pgtable entries using recently introduced generic
helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
bits entries when added later.

But first move __check_safe_pte_update() outside <asm/pgtable.h> to avoid
a cyclic dependency while accessing these afore mentioned core MM helpers
defined in <linux/pgtable.h>. This replaces the original page table entry
print standardisation proposal which was part of the D128 series.

https://lore.kernel.org/linux-mm/20260729122452.3797443-11-anshuman.khandual@arm.com/

This series applies on v7.3-rc3 but after the following.

https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

Changes in V3:

- Added tags from David
- Added comments in section closure for CONFIG_DEBUG_VM block

Changes in V2:

https://lore.kernel.org/all/20260909040005.4148136-1-anshuman.khandual@arm.com/

- Moved __check_safe_pte_update() inside #ifdef CONFIG_DEBUG_VM
- Added empty stub for __check_safe_pte_update() when !CONFIG_DEBUG_VM
- Dropped IS_ENABLED(CONFIG_DEBUG_VM) from __check_safe_pte_update()
- Replaced pgtable level specific strings with pxd_str[] in show_pte()

Changes in V1:

https://lore.kernel.org/all/20260901065454.1906343-1-anshuman.khandual@arm.com/

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Anshuman Khandual (2):
  arm64/mm: Move __check_safe_pte_update()
  arm64/mm: Standardize printing for pgtable entries

 arch/arm64/include/asm/pgtable.h | 49 ++++----------------------------
 arch/arm64/mm/fault.c            | 16 +++++++----
 arch/arm64/mm/mmu.c              | 48 +++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 49 deletions(-)

-- 
2.43.0


