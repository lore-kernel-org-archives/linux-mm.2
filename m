Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C99BC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9626B009D; Thu, 30 Jul 2026 05:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080126B009E; Thu, 30 Jul 2026 05:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89516B00A1; Thu, 30 Jul 2026 05:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC5B16B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:46:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13A8F120916
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:20 +0000 (UTC)
X-FDA: 85044962520.11.4AC4255
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1702540009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=acdJATU9;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZnorYLlWMyM5UFID8mK/Zd0i6qF/MIMCjqAAjeELmUY=;
	b=5E0OSzQB7K6IWG6A7SmmCZjWS4c5GeH2fc0D3gKAGhhltnQ2Sn4UW7mi/jlKDWnvrkxXE0
	mT1VjXm/dVawQ9U7mnZUL9FQLNrcGbpbHlvKwdxNZ0oLgREXromrbwcJiVEqjgUK7Mn0kT
	mL2a+qQn7VufvH3Ci3nggxDuxTZrfDY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=acdJATU9;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404778;
	b=6BsKR41Q+K9iC7D7NqhPRdhRUPp1TvYqJZJaGplOJH1/PBhW1DAF4iQ0RM5bZR1hp7aYHt
	Y2sHsLs2N7XdkFk/H3ZBGoOjaXSAg4FUiwkti8qkOf77SJIhjNcfIAuf2YqD179AEmUT8F
	I+xTgaQ1SuiXnf+FuUkJgS4MKgWvTQU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A82071684;
	Thu, 30 Jul 2026 02:46:12 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 775233F763;
	Thu, 30 Jul 2026 02:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785404776; bh=mS7cuEvlNnDOfcNrpI4hgJf5yyKkfr7S7sj+PeCdL8E=;
	h=From:To:Cc:Subject:Date:From;
	b=acdJATU9k4ZO0FvIY+fx5KSgvSkq2wgbCdjbKzc9+a+WaU9uOpGE1wOQuChZU4v6d
	 LnxVbO0B5mjmPtKIekX2mi0Fr77TUZZZjEcDPhwJiqfiFF3NYUMJstf5XgaIp0r6fP
	 PsA5+O4SkNIIEiSYdVAR8QZ2yQGLUUtwbF7R8cpk=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 0/5] mm/rmap: Refactor try_to_unmap_one
Date: Thu, 30 Jul 2026 09:45:51 +0000
Message-ID: <20260730094559.418003-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1702540009
X-Rspamd-Server: rspam01
X-Stat-Signature: pn1sjnbr413andgkjohqwtwnjxcizzto
X-HE-Tag: 1785404777-786778
X-HE-Meta: U2FsdGVkX1/sWHZN91BWQP5B97lKhW1EdSTSncMG+SYKGDd9znee2CSU43x5+CwAqsc+iPDa/SKNOuWP18Epe75eFbHz/jWfB3KUnQQ1CI1tzpo1YYQL3nsaepPFvKjmYoesSBXrtbKcU1gyizYci35nfg2xMklIN1S1FSQxZTWHnhMn0r6lA6CY9WWZH3DkQNw2kAAdhspWfUl9KXdykg7Gd/H415aIEWO/cOgTZ4W5p/9kNwUvoof6JFr5X7uRnoR6M5GmZ1YVNQHPR8k5jG9EPI359A88uJQZpeJxdqDfW4y2Tp/Xr6b/PPXceatHwl3/9doyxoLu5O+peCPXRmW5xnQ4neKjcVbaNLz5AyoiHGO6TX8MCHrlZX0rh2lm3L8Ou+99aRHFu15AGYWV98OxIRGCpcxYE/ZvqqqQ9ouliaS/kr6+q4TQbs/5E19sipbYYEDR128Wo0jpYeGjShW/24r5U/aVkp8/7ZxMNfMacvJ8+6Y578cHA6KtR0ciw1EeAXQAz22qQAYzcEm6lAYSopAgWlQ9AuVgemmlhEOSnqpAqvY7gBK7c+IWa/FBVp7Xh60tizQyv6aZhBSYu17zB6cjZuDNFIk5TZ7ihfeSMXoLael4/4qGt22F58RQN5mwJlFCyGT/Ixaiahj8q768fkhhvW1mkNTaWd0ZxWCIAN2Zv7fLDeNbCNyEUO4U7c3+IPCy3Vd26VQivkewymDISRkkjcFrkhdyNsTOMP48OFr5xh0ryLvsPIUn7EVlHKhTqAFUKsh0SmLW4ApNqBZS2NQjoB+tDAy2Rx4bJ0K/wdZsoARHqH+2IzlNSpHpP7rqJ6RKJRZxZ1zpyLexLbxi0LVSV+51ybQ2wL/EasoGU80cYjaVHl47GkRnX+HQ7ELnaZT92TfjhB/3beoJCwYbrHtMLqiT6WXPSK9y7xoGHjJ/KvY2b7dBFHCilOKOx0z/9wVpZX4MyHsDWwd
 1NGIHjFV
 n7l/pXkh65Nz/wUMEFsif22C3lBvpMxPgM2TQ5PAuPAWJfkqu3meuklaDPYAs5RE05dR4qmo9qJEGWSTw7vWsUFSrzA3kEBSY3X0g20I64/UOOX97NFQJkG/cB0iyhHFhnieciut8jTv6Axf7KtSwmYhZbPgDjVPgEza5BDqJhJzvTbAGjSD+GvrLkKqcXpp+b/YLu3e0NvNIzIyxkO1W1eqfKxjJDnUWGS+4PaTYKpsFUEOoIokLYlk8ZnnnyHdqaHZhgXYhc4SXqN4ZPv9LLUEsq89FNrss9AFJIGIZKtvxx+njbzcBUoWQ+GcBWM+vcBeR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for batching anonymous large folio unmapping to optimize it,
refactor try_to_unmap_one. This series refactors hugetlb, anon-lazyfree
and anon-swapbacked logic into their own functions, significantly
reducing the length of the huge try_to_unmap_one.

---
Based on mm-unstable (d8c677ce1220b0db119ada6c6f9762c07c4d8aca).

Split out from
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

mm-selftests pass on arm64, built on arm64 and x86.

v3->v4:
 - Tighten comment around TTU_HWPOISON
 - try_to_unmap_hugetlb_one -> try_to_unmap_poisoned_hugetlb_one
 - VM_WARN_ON -> VM_WARN_ON_ONCE

v2->v3:
 - Patch 2: fix comment to say that TTU_HWPOISON can be true for small
   folios only in try_to_unmap_one, since hugetlb bits are now refactored
   away
 - Patch 5: Directly do if (WARN_ON_ONCE())
 - Rebase on latest mm-unstable to resolve conflicts with 30c83145c5b3
   ("mm: rename uffd-wp PTE accessors to uffd")

v1->v2:
 - constify ttu flags in try_to_unmap_hugetlb_one, move const variables up
 - Assert address passed to try_to_unmap_hugetlb_one equals pvmw.address
 - Patch 3: code and comment polishing, do the stat update in the function
 - Remove unnecessary inline hints, remove set_swp_pte_at, instead have
   swp_pte_prepare + set_ptes. Rename subpage -> page. constify
   anon_exclusive.
 - Do pte restoration in caller

Dev Jain (5):
  mm/rmap: convert page -> folio for hwpoison checks
  mm/rmap: Add try_to_unmap_poisoned_hugetlb_one
  mm/rmap: refactor some code around lazyfree folio unmapping
  mm/rmap: refactor anon folio unmap in try_to_unmap_one
  mm/rmap: add anon folio unmap dispatcher

 include/linux/hugetlb.h |   1 +
 mm/rmap.c               | 415 ++++++++++++++++++++++------------------
 2 files changed, 232 insertions(+), 184 deletions(-)

-- 
2.43.0


