Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94651099B2D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7C06B008C; Fri, 20 Mar 2026 14:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F316B0095; Fri, 20 Mar 2026 14:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC296B0096; Fri, 20 Mar 2026 14:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C99156B008C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:07:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 968CE1C4CA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:35 +0000 (UTC)
X-FDA: 84567224070.22.7A390CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2AE2A40007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:07:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b6dcDxkA;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JUxdoo4poRF4jK1QqjZctec0Mtz1WV0V+FrsQzJBpog=;
	b=RgwSxQc36xhv9Ndp8okHj6sHc8ZRQ/W2o6NlvYOMjBru+CR83CA1xNh43ljCaZMYY4nwzD
	6uslEA0DShUopqhlQMIw5ZUlHowp12YQQpkECmLlhQ2yKPFxAKuJf5kg4xl7N659IZpjIz
	T/FuvJBSF/nisbqEvUlXk1qA4O2Iig8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b6dcDxkA;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030054; a=rsa-sha256;
	cv=none;
	b=V67pDJhvoXJfZSw6owcI6WXff6AYoi1kRPY1ElycYb3BoW5g8Bzk4zNZL1ELMQhI3qAwRQ
	78jOfDZFC0AeSYpKE4SO9C6++caolrK/f7SRhLSx0mkR49g9Bp/3dT9DliG296NADhPbuY
	exn4T0RP0OIjcClfSyIBO7ulqWwKT+g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 979B360128;
	Fri, 20 Mar 2026 18:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8669C4CEF7;
	Fri, 20 Mar 2026 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030053;
	bh=2ud9VVAGIb5J70qS+Aq6s18YBJv2+0N0qOqGnKGdgDk=;
	h=From:To:Cc:Subject:Date:From;
	b=b6dcDxkA3aq73+vP5AXtjBPFTU94ovgtEUytvu1yRCcbeTFd3Iuu3j58A9xa48cXV
	 wnIsQ5c94I2pina6cm4lT43yzF5SQdrlxS0e0BaSIlWl3qFAOujOf94382c+BX7bHS
	 GEWT5bSSxfDBtnIvp7FVrhjGRKMlksxIh7qEpkPDoQ92K7E6vowb/OHoxiJxz7N+5A
	 z9aShAoWw5icQBdFFuVY6Bd4yIqpzR9Whq9wSvLBxHm8U4F3dCGf5Te9yuYVCTJpw2
	 j2p+JhxtWDHQ5us7eEZCGIzcsNWSCXw4XwVFyvNnocucY9RJXC7uhl02G02f67FncF
	 TRd9pDSBvsnSA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: rom f9db59ca90937e39913d50ecb4f662e2bad17bbb Mon Sep 17 00:00:00 2001
Date: Fri, 20 Mar 2026 18:07:17 +0000
Message-ID: <20260320180730.303568-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eppsgd58g59kz7daam7xz5kc4jaipzbr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AE2A40007
X-HE-Tag: 1774030054-873691
X-HE-Meta: U2FsdGVkX19dm2wAzJhq+tF2fGUO6cCeAyKWL6x0yCJccvHvQR10bUNIid/5hLyW1vKDYyjuUUT8sTDNgqTYCZpbRkA40cFleVL7+ACJI7+cm7loj5p/hRf5cAf+0KWPfwnCnR/u2T926XZY8QwHZwupPSgS7OUUu9JO14EZq92SOi8d8uyu/vdHB2aft4HFAJQJZ40G850QYhKuNSk8gxI+RVrH4ZfGrPKAnl5zBbUwpqqAptSpI/qyp6jiCMDR+scsGX+z1Q8M7kOGGgM6PB8BknwyxCmzjbjuGA/pUedLJxkm7q0wH04zHaQWIPvYFOP1fNc/avq5P2vaz8WmM6b+ZgCKs3I2gMDff8nRUVdiK5kibm0dfiu0v6D+wKbbDigXCASH5WIWBUGzqx85X3Z51SGr5HIAnHrFtR+y0ygqj+7QkW97xpSSVE1Gg1V4rRz7qUbtwsn91GUCZniLJBUkGxQ3WoL9mSBlHQ2UoB09FtvUrEXm0ZdOql6xgSTKK3EXsq5LAuY3BjHzESDA0eQbXVtLrDob70/wI6GWza4q8YdCrbh5MJDaelWLkcktHqh+Y2fFJc1hGAS6np1sYkHuneiC4eUZS/RvLSisjXsBddcD+KH9yrgWepMtAP1xQmxUpkN5HffttH9+tzh2wO0iwwmdcwonz1Sj1nEro3rhLA0JZlu5Kvb/l6UbpLtr/mrsAp3MJhhBEtNNV7pvrsKkZY2eEn5Gp4j1y6C6d629oqKg9y1Zs66oaLLZbTGKBwiBL8WdkNUylQFFmIUDh/RwrdvT1K5KPS7F/CinJTqMCO3uVQ/DibJIl4RXBzH4ThQxStkyg9bE2e/msfZudpt2rZDfWIROYCcvKBtTawHZYwyiv8RUb202/1OFTEGeOEH9LHns7B6psgrlb44w8yTu8EMGIQHnkHdMWJCUH6cRCnX4iJ1IO9JcvWeh15eAeNh39IIiHKi8JTenylQ
 ATo7QNrA
 tfDycLLqZ/1Izybd8ff2yFO2DUpK8robWJwio3tOe+F86ozw6AkRmZixcBU3NR/Dpa2rQPSLED5cFiJ/vNV/7sm4IHzJquv6Vu8dtpEpqsTBsGe4KGRgdFgkasn9nBfO6w5hO0gXVCy0itL7PuuHxrpSZ7qrZGI3iu3RAriRbS8qtsLawrzKdJEuKSCWTrtosNzQBwQZ4dlxehniQgL9OIrWSr738+hLH7DjHndknyeD3ono=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zap_huge_pmd() function is overly complicated, clean it up and also add
an assert in the case that we encounter a buggy PMD entry that doesn't
match expectations.

This is motivated by a bug discovered [0] where the PMD entry was none of:

* A non-DAX, PFN or mixed map.
* The huge zero folio
* A present PMD entry
* A softleaf entry

In zap_huge_pmd(), but due to the bug we manged to reach this code.

It is useful to explicitly call this out rather than have an arbitrary NULL
pointer dereference happen, which also improves understanding of what's
going on.

The series goes further to make use of vm_normal_folio_pmd() rather than
implementing custom logic for retrieving the folio, and extends softleaf
functionality to provide and use an equivalent softleaf function.

[0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/


v3:
* Propagated tags, thanks everybody!
* Fixed const vma parameter in vma_is_special_huge() in 1/13 as per
  Sashiko.
* Renamed needs_deposit -> has_deposit as per Kiryl, better describing the
  situation as we're zapping deposited tables, not depositing them.
* Initialised has_deposit to arch_needs_pgtable_deposit(), and updated huge
  zero page case to account for that as per Kiryl.
* Dropped separated logic approach as per Baolin.
* Added 'No functional change intended.' caveats.
* Removed seemingly superfluous, inconsistent pot-folio_remove_rmap_pmd()
  mapcount sanity checks.
* De-duplicated tlb->mm's.
* Separated folio-specific logic into another function.
* Added softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio() functions.
* Add and use normal_or_softleaf_folio_pmd() to make use of
  vm_normal_folio_pmd() and pmd_to_softleaf_folio() for obtaining the
  folio.
* Add and use has_deposited_pgtable() to figure out deposits.
* Added a bunch of explanatory comments as per Baolin.

v2:
* Added tags thanks everybody!
* Fixed issue with returning false on bug case potentially looping forever as
  per Baolin.
* Fixed further issue in bug path in 5/8 with double pte unlock.
* Add patch to use vm_normal_folio_pmd() as per David.
https://lore.kernel.org/all/cover.1773924928.git.ljs@kernel.org/
v1:
https://lore.kernel.org/all/cover.1773865827.git.ljs@kernel.org/

Lorenzo Stoakes (Oracle) (13):
  mm/huge_memory: simplify vma_is_specal_huge()
  mm/huge: avoid big else branch in zap_huge_pmd()
  mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
  mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
  mm/huge_memory: add a common exit path to zap_huge_pmd()
  mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
  mm/huge_memory: deduplicate zap deposited table call
  mm/huge_memory: remove unnecessary sanity checks
  mm/huge_memory: use mm instead of tlb->mm
  mm/huge_memory: separate out the folio part of zap_huge_pmd()
  mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio()
  mm/huge_memory: add and use normal_or_softleaf_folio_pmd()
  mm/huge_memory: add and use has_deposited_pgtable()

 include/linux/huge_mm.h |   8 +-
 include/linux/leafops.h |  39 +++++++++-
 include/linux/mm.h      |  16 ----
 mm/huge_memory.c        | 168 +++++++++++++++++++++++++---------------
 4 files changed, 143 insertions(+), 88 deletions(-)

--
2.53.0

