Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9D9C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 03:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449E66B0088; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F94F6B008A; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225816B0093; Fri, 31 Jul 2026 23:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB7A56B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:16:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D957C01E6
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:23 +0000 (UTC)
X-FDA: 85051237446.23.35B452B
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id CDA71180006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:16:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LTKS8w+M;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785554181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FGMAMYIv+aQ30Fi804H0kZD96vsuWwwShutLmJS318I=;
	b=t6pW8A6wxhXXaCayhBk0q9t9q5X09Mz28WnEM9ZkSERMSG51bAm8dH80guzJbRF7vW3rYv
	86myn//bJsMdPgxSxiUC5kWePGYYDQZC4nK63Q9AfxJukl9OHBUe5T6/2OeCa3EtPQedC0
	OneSa/AtYp3zbUpKPmtUGZC+bZ8Avos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785554181;
	b=tIkI5d632rRYxx2luHOZmqcr1/iTJI5xDk9PACk0DbyMcYZmSgfGGtQOcfIK6HClXN49km
	XFrjcp50hKYPcUDbyFC+lqsHAdBxBGRZru+onIwR+rSzjd6rN1LmcY1rZTuaRy1Qfs5HHA
	70sjWWBpxp7shqy/NkdGhA/r/iKC/LQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LTKS8w+M;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FGMAMYIv+aQ30Fi804H0kZD96vsuWwwShutLmJS318I=; b=LTKS8w+MQCT2aEvfy7YaJgFaQi
	quZvwa/RryQXj2gmrbJXTSjThva6OU+diwnQpJzz8L+zLVScwFvwxvo54jKK1kTsMTXwn8ooV0XlZ
	yO/NdW2FqkBSVQejev2UoYjcVoULp7FXaWc94dPdMUbbcmLYRD8s0nN1g2cXbzGCorGeDlDsi2cyr
	s+daHwB0Ueniea5W72iCX83D/F5u0hf4/0ZrJikUa9UCP7ZnM/8/Bs19vOZO/C+3f0M9AbftWOMCY
	N6RPMlzd/IAxzqurEoEqK+K+hzvHlcsvc/8GqbdRhiCoE5Wy+4p/CYEQL7u/miLlkSYBzwUtmRlEc
	B5OrlwNg==;
Received: from [96.67.55.146] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wq0CU-000000001Q5-3Wwz;
	Fri, 31 Jul 2026 23:15:50 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH 0/5] mm/gup: batch contiguous pages in follow_page_mask()
Date: Fri, 31 Jul 2026 23:15:35 -0400
Message-ID: <20260801031540.2742891-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDA71180006
X-Stat-Signature: wgipndnahy8zuo5kgc1sq78d9i78yh94
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785554180-967733
X-HE-Meta: U2FsdGVkX1+o+8mP5LNavsQrY7QdqSFAsy7FgZadVYIMrzSUczC1P/mivvtOIcVk9DL9cClkToikH994tQH9LPHDYa1dP3WnYaqCIV1GA8DvNdhTGM08KqqMMfVueiTfGUkWmnhhToDp7K1CLCDvP3gvP/EpQgvsdTo6BrvienCraaL+JmEFBYwIo8RpuznAMO5/CieM14QqDsM2J+p3sfCHOKWWq7pc1SbKoYuJSyYsc2EWu/iwyllys8GyGVdY8NuErVJBI3b9nzCKn/MGPAXB+VTPlDtBg71t7apmyMIcapL/R79tlwBiCFiNDOhrBCE1K8npJnm5qkKEzRG1oYkO3LY6nwdMmGWWuwwHHSOn48o6xWY6VwEiOQNpzbW3YQ6Uou8HT3L7kOHSwfbGwBwIfJDqtcUT0hh/0/38TowX9AWQZfHNO75MK3XIY8a3GmfY/Y71Ng7SYS3ApyTbVVeRe+KR/PwXJO+bY1IvpTWo6xzGGNZjZdNtRSIKzVJqeNXk2PEZbT3T7JWxVAZmAQWpQdq24W30VdJdq2fPIrU1hTAHiMIr2qTJkhCSzYtJ5srBPWSrzq7zJ8yRtHmIhGHu2wFu7G8QGB6I4lTrthX03sknY8dmU9V4ZQjpNMvnYOjoKj6JqVkRUShzSNeAhI/Dqxs+yVejEUef9PA679MaGAZ1Utt6qwVXpC4ugV+rXHxIyWvQIZJHCc4FfG21w/V5PysWQcokD99UcF0oFeg3FjHPtey2emRWeXzbB6NtmZuF9yz0G51MbygmTe0Fn8NfUwkM81JaiwWDcSvXPuYYUlhnpaAHb/m+j4lnDnaYRFwbwxviHsKcX14Jb67Qcm/PEvMcSUzV7U2FJDOxcUeDo33Tem+PNw4SNWdDOdosVOdkX0ejMOz5EoKqY4jNk61H3+JHzwi//YavCpZXRlgOQZM/xlVLrtyxhOgkWDAUZqozBIKKiYP+KGDOUZX
 PXoO1Pib
 b44I2rv6VO2zbN9NyuP8UVT1amQylRP67WVQu4hxRHSLIpMgZp7sZ9WC9GggFUFU6uNVUFG7/t1mBxmG44tg0p/WiSDprMtRkN5dpgXWFWpilUBAm1EV8NbNbZt9EOo1hxwsMqrWvWZpYEBJRORmFDn7lGYXCSFfzUMLG0ptjXATYuCpoq2ypLWHoK9tBGAjCURnqpsf2xMoBGGexTw1c7fRpY1uB2c+XMIk0Af3qcgbFfsHo1XTRMieIuhD02uaNMpp7cWr9a6b1Xp9sJ2KvZITJ4L89cgIWDM9s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() walks the page tables one page at a time, even when
the caller asked for a whole run of contiguous pages. Every page of a
large folio re-enters the pmd/pud/pte walk and re-takes the page table
lock.

This series changes follow_page_mask() to return a page count and a
new @end argument bounding how many pages remain, instead of a single
struct page, so a walker can hand back more than one page per call.

Patch 1 converts the follow_page_mask()/follow_p4d_mask()/
follow_pud_mask()/follow_pmd_mask()/follow_page_pte() call chain to
return a long instead of a struct page pointer or ERR_PTR(), with no
functional change: every path still handles exactly one page.

Patch 2 is pure code motion, splitting the "commit to a resolved page"
tail of follow_page_pte() into its own follow_page_pte_commit(), no
functional change.

Patch 3 adds gup_fill_pages(), a small helper that fills pages[] and
flushes caches for a run of subpages, and converts the three existing
per-page call sites to use it with nr == 1, no functional change.

Patch 4 has follow_huge_pud()/follow_huge_pmd() report the huge page's
real subpage count instead of a separate *page_mask output, and
retires *page_mask and __get_user_pages()'s dead second
try_grab_folio() call and subpage loop.

It also defers gup_fill_pages() past the pud/pmd unlock, so a 1 GB
PUD-mapped folio doesn't hold that lock for a full array fill and
cache flush.

Patch 5 adds follow_pte_batch() and has follow_page_pte() call it once
per contiguous same-folio run instead of once per page, so a
PTE-mapped mTHP no longer restarts the walk and re-takes the PTE lock
per subpage.

This is the only patch that changes the number of page table walks or
lock acquisitions.

Benchmarked with mm/gup_test.c (PIN_LONGTERM_BENCHMARK, pin_user_pages
+ FOLL_LONGTERM, 256 MB region, median of 16 runs, folio formation
verified via the per-size anon_fault_alloc counter):

                       before      after
  4 kB base pages      2721 us     1198 us   (2.3x)
  64 kB mTHP           2929 us      201 us  (14.6x)
  2 MB THP               73 us       69 us   (flat)

The 4 kB result comes entirely from patch 5 merging two separate
try_grab_folio() calls and lock acquisitions into one; folio size and
PTE batching play no part in it.

64 kB mTHP adds the walk-restart avoidance on top. 2 MB THP is
unaffected, since follow_huge_pmd() already handled it in one call.

Patch 4's lock-hold-time change is a scalability argument, not a
measured one -- it is not visible in this single-threaded benchmark.

Suggested-by: David Hildenbrand <david@kernel.org>

Rik van Riel (5):
  mm/gup: convert follow_page_mask() to return a long
  mm/gup: split follow_page_pte_commit() out of follow_page_pte()
  mm/gup: add gup_fill_pages() and use it
  mm/gup: return a huge page's full count from follow_page_mask()
  mm/gup: walk multiple PTEs per follow_page_pte() call

 mm/gup.c | 532 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 322 insertions(+), 210 deletions(-)

base-commit: fc02acf6ac0c
-- 
2.53.0-Meta

