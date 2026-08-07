Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3166BC5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18236B0093; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76036B00A1; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6E26B009D; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89F196B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:17:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19A6F801BF
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:53 +0000 (UTC)
X-FDA: 85075735626.07.71C384D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 391AFC0007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:17:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyUWjTp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137471;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KPv/BMEY0kw9y4p1gHkOS/YBIZKPXd7wvXWB2zoOoZw=;
	b=uKYm5jCxKLIXXQrZoxnhWiHXcvBu4jepHxJ1MCBJraWT98gyExOobXYQ19SG3X4kxoi7sA
	vDiuHJVxyXixZvEbPxiLTC8qvtVAApC9D1NSzJkqFW+MvEtRwTQAy7k09jD6TpV0XVEp3J
	JJq+ldnryLRD15MvAInavbgb+EGtguQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyUWjTp6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137471;
	b=1Nm7xk0S0RTOH21o983MN0YBHQQYj1JgjZpCCFLWmI/CtuugwKxkTvIUNBRB0ufSFe+CNn
	j3LqPLrZ4pUZWeUESHstNkYTHwJqvWP40VKayQ/PR0B/WDc7jSqRTBF6A/KVgg+RmeSy4j
	vIF1TBu9flZ9Fn86Hk37kDbEEHZ1rzw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E94416001A;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9425DC2BCB8;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786137469;
	bh=F8O7FJxU7En109k29YAv2EDzjAiMtmbEJ18LeIdn92w=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=nyUWjTp6PvX36W3Dws4Xw0LBrHQ2fABmhl4A+Ln02TEDxpzOFMaE3IRCq4IFGrHxg
	 nyBH0sdbeXhMKS7qq6l5HdFHtq5IjtH2SPriRU9SJEQHQlvoOdx2LHfRLPiw7WQsk0
	 cROtlLUcubfWbzDHnk3MuiS47S7S9kUpxHvhTiaKt5IaSl5CRHcVw5jcO3AAMbfsQy
	 8Kh+iQ20HsjlfV/JMhCzka8SLQIYMA8wrmZZDAemPYgsoYDMX0tE53zW4NPkDLszMu
	 goGP4D4zlYan+dQ32H63IuCVImsm8KIswxwQnjpudgMFp/jhcXbTm4Qg7V1PpLwiVu
	 Qec2hZSLOOsKg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69968C5AC9F;
	Fri,  7 Aug 2026 21:17:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH RFC 00/13] mm/huge_memory: clean up folio split and lift
 swapcache split limits
Date: Sat, 08 Aug 2026 05:17:01 +0800
Message-Id: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDCwMT3eLyxALdkowC3eSc1MS80gJds+RUo6RUs+Q04yQLJaC2gqLUtMw
 KsJHRSkFuzkqxEMHi0qSs1OQSkGFKtbUAQ+JxZnkAAAA=
X-Change-ID: 20260804-swap-thp-cleanup-6ce2be6cf3b8
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786137467; l=3669;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=F8O7FJxU7En109k29YAv2EDzjAiMtmbEJ18LeIdn92w=;
 b=btCVYHLU/t5mhFNxoCekjdi/BqIz2CIrr6pQDR9wm79cOi62ee2UlltZjtwgXVusUkiQDZqdh
 3cYT3kwGYadDLh7yr1Ooo4RfWM5qIvGLKH/Pd/luc7RTMJvLMke/q7/
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 391AFC0007
X-Stat-Signature: xeper9t3pqfenwkmmxpcs7iy5aedsw6d
X-Rspam-User: 
X-HE-Tag: 1786137471-493285
X-HE-Meta: U2FsdGVkX1/bRHPJg0WH1KG43ZUwD3oq0PwgZiuMkxv+lcqTaR6Q8dDIDONOm83AQVgnsrWIyDZxocq4T09vpgC8qrhIkW8ftCKQt+k/q3V1k9QppXgJiYc2tmnfi5N/rDwOJpJMTrAJ2Gjqh7iDSngkV88dEhQQWStNuu+4JvisN6rPffGFiDy4YaBkIjXufp3lIngAaHtaDkxu0TxAcBYytfxxr2Kxk5aTTZdce33GbbhIhqDVU3tlCCXQVM9VnxRwjQhpFLNiGJ9oTxYyjKm81tBe8JnkYPU7+4kV2d2gIskHOkQELY47535v/pN0cDRH9hrmK6QLl+4jPDybNdJSmdAhGAPpLJWifULhlWnuatFwG9u0g1x5oJ7s4BEdZZrfzzmhUu9g3uHq+ghye3Jlb66cfgZnVbqs9KtHo8sH4hH/8ZI+fJ/03H2DdZGjWnnyzjif33RCf0WXjNQliU5eEtVJQbtEvtgZgsSlxAB0XzPj08SRWszJosPc70emu42Ni3vNMChp++qbtwB2imGH86azZBQQ2rtdf2KFIL4lVtke8qNV3ZXNf2UlvBCNlqRVq+uCyq1vAvxdLYP7oC04yBLadaoHiRRIOT6cvX7mKSSb2R82A/MrkKvPIiqTvtbrHRGVwfOLBQxz2I4yTXSB4+PX2l+iA0CgIWT7WwIjc/ArKT2N06dqqVyVaMfu6EgHWZhsircjtEkitb/B00ix+VXMiEZNtwvSFAc1tBzGzXq75L01GmkquLC46aeC5TjMabrYgK2FbmVAZT0ZvhEhfKYIjKqpFSgvL3CMDeilrRs77emZEPu1+mLCwT4RskKGf9yuhjbGlWv7reKiht0A9g9Ms/iXVudkxZKhaPqai3NzIrx+Hfhl2tSw0kUc0wX7PH1K4iOfyMCiqOcFiV/mraQPmMSn1gZ9z09FM5vdtekiLlOfx9lb0KtpnxV5h2g53K01gIrAkoM7Tf+
 blBH7Wkb
 q7/DcEMpbdd2HSPwNVkU9iAMOSC9fEWnNmcc2vBkK6ZljuLYSUpT562Mh7yGVm0+V1x2OCHoUmJly18BwgmYXKhH9pb0++M72MHPvTCWfrJWoPQDlHmwYZcNRDbTin6fezQ7IkpLWcvXcmgRrwzG2YugZUQFtY2FKjqQiMcA8cJdGfL9leVY6UsrGAMg+cfhK2D0B5wxnb93MO1lBYn2oKj4NRuS5V5Llum8BDXI5hHEs9FeY0ylt1ec5dfK6HA0bR3ih2rqB4q1/xUgWOmFdkxTp5+N5GrMCa9QSOMQpf9mCfsXICJm5IwOAvUjIRQYNCHC4Pwp5B+TEcWzcW4ubsYM3aV5B+xhGucF41BqjiqseEPRatKRzN425nxZ+R27JzGC34HZQT9KNWqD/Dm1jepRykJZvfRg7zW6FQiJ6yBTvuFtbDQqPdQ/4o7DIHFp1vRpwY/mZjHs2mmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series clean up the split code, add better swap cache split support
for mappingless, large order, uniform and non-uniform split.  Generic
performance is on par or slightly better, and stack usage is reduced.

The swap cache infrastructure can handle non-uniform or high order folio
replace, so there is no reason for either restriction from the THP side.
What stands in the way is the mixed anon/file folio split routine,
which makes lifting the restrictions hard to follow, and it already
carries some buggy or redundant checks.

So this series cleans up the split path and separates anon and file
splitting into two helpers.  The file split path never sees a swap
cache folio, and that is now enforced up front: a folio that is both
in the page cache and the swap cache can only be a shmem folio, which
remains unsupported and is rejected early.  That helps to rule out swap
cache handling in that part completely.  Only the anon split path
handles swap cache folios, with an anon mapping or mappingless:
either way the splitting is similar, and non-uniform split is
supported as well.

Order-1 is still forbidden for swap cache splitting.  In theory it is
doable for shmem swap cache folios, but a mappingless swap cache
folio cannot currently be told apart from a shmem one, so forbid it
for all swap cache folios for now.

Testing:

The in-tree split_huge_page_test selftest (uniform, non-uniform and
in-folio-offset splits of anon and pagecache folios) passes 62/62 on
the patched kernel.

ftrace function_graph tracing filtered on __folio_split() was used to
compare per-call durations between the base and the patched kernel on
the same x86-64 box (interleaved runs across alternating reboots;
mean +- stddev of the per-run averages, 135 split calls per run):

  base:    24 runs, 69.6 +- 0.7 us per __folio_split()
  patched: 26 runs, 68.8 +- 1.3 us per __folio_split()

The patched kernel is consistently ~1% faster; with this sample
count the difference is outside run-to-run noise.

On x86-64 with gcc 12 (-fstack-usage), the stack frame of
__folio_split() shrinks from 240 to 96 bytes, and the worst-case
split call chain from ~544 to ~384 (anon) or ~464 (file) bytes.

Bloat-o-meter shows a tiny growth of huge_memory.o:
before=58419 after=58446, chg +0.05% (+27 bytes).

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (13):
      mm/swap: fix off-by-one in swap cache replace sanity check
      mm/huge_memory: fix rejection of swap cache folios with a mapping
      mm/huge_memory: invert folio_ref_freeze() check to reduce indentation
      mm/huge_memory: split the routine for splitting anon and file folio
      mm/huge_memory: consolidate irq and locking for folio split
      mm/huge_memory: move EOF trimming into the file split helper
      mm/huge_memory: move unmap and remap into the split helpers
      mm/huge_memory: move anon_vma and filemap management into split helpers
      mm/huge_memory: move memcg switch into the file split helper
      mm/huge_memory: allow splitting mappingless swap cache folios
      mm/huge_memory: clean up after-split folio freeing in __folio_split
      mm/huge_memory: lift order-0 restriction for swapcache split
      mm/huge_memory: count only swap cache refs in anon folio split

 mm/huge_memory.c | 583 ++++++++++++++++++++++++++++---------------------------
 mm/swap_state.c  |   3 +-
 2 files changed, 298 insertions(+), 288 deletions(-)
---
base-commit: 7e4ead2558f28da16d82a8f5845eee44555ff6ba
change-id: 20260804-swap-thp-cleanup-6ce2be6cf3b8

Best regards,
--  
Kairui Song <kasong@tencent.com>



