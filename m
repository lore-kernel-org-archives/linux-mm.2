Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52836C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262A66B00BE; Wed, 15 Jul 2026 09:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23A006B00C5; Wed, 15 Jul 2026 09:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177936B00C9; Wed, 15 Jul 2026 09:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E29A76B00BE
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:44:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3681516014C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:18:55 +0000 (UTC)
X-FDA: 84990763830.05.2723C2D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6B1C420002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:18:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kI0TpVIx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784114333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Yra5UbvfG0hPQ0cztGhKoogedbnxQ6x352q0DANw2/0=;
	b=W6FKkgExNiCd4Z2REFPnKxW/KqavSfKISh78AI0kRw4yFrRzwR/bmzjCTugZi1t8NLjlyh
	tue3W94540ITjUrY9LaUMF5Vn2Czm8Sx9PHRlHnV+DII3Dt2jNkuRXnNRkFCM1/Nj4fYBN
	A9M+072cEmvHMQ9xW0f8cYnEW4zRoEU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kI0TpVIx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784114333;
	b=pSrVImiu25OnIOJoRnc3N7Qa8nNfu3E7/KZyoqxjesxXPwcZMxL0fKKzU8uB9I/5kaCEEp
	ZbNU9p7Ssq/QEPBpILlZP+j8x0cN53Ergw1FLKfIJEA7T3BpGSQY1+MkzReaynErESP5gz
	7OPkqFpzhhFjzwdL7LIk+B4GJjvs1Bo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E511A2F;
	Wed, 15 Jul 2026 04:18:47 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E56B3F915;
	Wed, 15 Jul 2026 04:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784114332; bh=ls9OD/sb8teEHFiJl0ENCldUadK0ElFq3jDW5TvwNGE=;
	h=From:To:Cc:Subject:Date:From;
	b=kI0TpVIxGBEWAO43VFDHweoOYkZd41CfefGU2+Qtunhu/bRy6aDpG4lv0pCWayjBr
	 tFVXG/99mcN/bgrEqBR4QswnHnnOc0O8wu9Le4Hmdf3oSOYTNOqEJFvSZTsrTVuAOk
	 YILueEg1FbfnhnsvJnRPzabA7lk3QJamrlSC3wUY=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 0/3] Batch unmap of uffd-wp file folios
Date: Wed, 15 Jul 2026 11:18:33 +0000
Message-ID: <20260715111839.1667914-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6B1C420002
X-Stat-Signature: ax3u88ubaqu9b491sqjq31sfu6d55hh8
X-Rspam-User: 
X-HE-Tag: 1784114333-287395
X-HE-Meta: U2FsdGVkX1/SKVLYgy1gDB9GoKzAK7ZKFZrxbtT+CBuGIu38Wegevik/NfA/w0A/ABaLF8Pl++ZnQUBq3rU07q5BgjzN0RhkZmmDlO3TOwYrnww5LUHOrgCmUoL4Zx6JC7Qt53Kpmq1QwSVxHe22ftXrgpKeY2BRSG+DuB0LLJ9BPl4N3Yyw1PEW7uVLNs+Pt25oQHSdWRi/CQJLk3Z+ZmyIX7e2WLXhq2Ymo2RwS4hYNY/XGFqHOejoFRSe90AldU7+0aJIJTmXD53hshXoSYrgnMDfmctl853jhLf1LCgE/FbRNW6dQTV2kIZHMxoEKR6dtztz/Rfr4UWdwORj934P1pgN3vkSCI10S7ge+8GXSeENihhl6iMsxRGr/pRNTgpi2XXZmZXGUXjXuYhzlUJhFDeAo6FsynCPSStc+niehkNy4wC0xhMt+d3oepwcDdeNlVuhaSS3DxH5ryYE0EQ3rBe91Bd+sglrygxbv3HiJEqG1UVXKE76tiJcjCOYy5Yc+xb5OuFnz9VKyl75k0KBRvVNo56Zhvgc4XzWL3u5mYMpvu//9+NEjwLvXiFW0EAaynPrfOjnC0umYWLhU8l6nPnoQlUZBrWXDrGQFJ1Ja7csBgE7u+lvLBTnnvZ0GM9SUs/ckC+DQz4z36GfBovcMV3qzfO6EWNeJHP9O2hIbqM1Rog0+oB4SzfLsWsSdaEepwNs0hbeio6uHAD9a30fxjSSdg2Y603WiNMRmeRwcnDlTkZQ+kwmITuIaH1ikcjPrCVBwUWtAiO4RbV56IX5OwrODV5AU96bLxC/4XCqH4uLP+0OOGeLwWedeYW6L5ETK3C50xDgpNXQRBJPbUiulUhdYMTzICHYO092NcPw9DiMQt/0k1FJdrhnj4appeSEPoSs/u9HccvawyGF81SpcdcmokmbAkQhNTipAybJWoD8jHBWz0CKvrnrBnvYJaUDsrllvjtV5o+G6f/
 36ux3ELW
 1++FAnxHZqPGTiLQwrdd2sKBicGATOSByeTJKAydnGLtJ3HDdT2tQ0MhaXauAn5vMQOKO04YFTuXy3hdSnskvKc6jgLiJ3kKNowc7yWHUOM1c7EBJPTXOjfET3maknRHx6Jv2ZKSVhutPZYnXuAHs95rZJdeNuEMhbgEAaCy/+ci2UHR3ox11hdBbqpoVC1xcCrk49cLON2BrjbejLaABfdNPbwE1BHh2EctDHV/iiUGOL95ZHCyjWjq5IqgEyER1tL5QqaoCXdQX+EY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, batched unmapping is supported if:

1) folio is a file folio, not belonging to uffd-wp VMA
2) folio is anonymous and not swapbacked (lazyfree), not belonging to
   uffd-wp VMA

So the cases which are not supported are

1) folio belonging to uffd-wp VMA
2) folio is anonymous and swapbacked

It is easy to see that this adds a lot of cognitive load while reading
try_to_unmap_one - we need to remember throughout whether nr_pages == 1
or > 1.

The uffd-wp handling in try_to_unmap_one is regarding preserving the
uffd-wp state for file folios via pte_install_uffd_wp_if_needed (for anon
folio, we handle that while constructing the swap pte).

Stop special casing on uffd-wp VMAs by simply adding batching support
to pte_install_uffd_wp_if_needed.

---
This is a split from:
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

mm-selftests pass.

I have based this on mm-new since my try_to_unmap_one refactoring changes
weren't there in mm-unstable yet. But I suspect this series wouldn't
have conflicted there, or conflicted trivially.

mm-new currently has Kiryl's uffd-rwp series, which confuses me about
the terminology followed by my patchset (and the existing functions):
shall I call it uffd-wp bit or uffd bit?

Dev Jain (3):
  mm/memory: move pte_install_uffd_wp_if_needed() into memory.c
  mm/memory: batch set uffd-wp markers during zapping
  mm/rmap: batch unmap file folios belonging to uffd-wp VMAs

 include/linux/mm.h        |  4 ++
 include/linux/mm_inline.h | 53 ------------------------
 mm/memory.c               | 84 +++++++++++++++++++++++++++++----------
 mm/rmap.c                 |  6 +--
 4 files changed, 70 insertions(+), 77 deletions(-)

-- 
2.43.0


