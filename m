Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13810C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5A56B008C; Tue, 28 Jul 2026 23:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4860A6B0092; Tue, 28 Jul 2026 23:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3755C6B0093; Tue, 28 Jul 2026 23:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E496E6B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:04:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3848CC054B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:04:24 +0000 (UTC)
X-FDA: 85040320848.10.B4035C6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id C25AE140005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:04:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Mt6wKT3u;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785294262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uAp8TPXhJPKqj3Jc2wCbwH1PXdxv3Tg+ZGuEgVhC6ZI=;
	b=dAqeFBwX2kw/FnsHUwgq0wQ8hOlETZackzH/Iu1egZfQmJqlvGCE0QvxhTF4hhLpbTX0Ex
	OANmwbCWfKBCatYY16bnvhCXlGOhdtsgDKTrfN0c3wxXeqri9dmxMeuu7pNog6h+mKJhBR
	2YZL0+nJhrgNNDe8ZuR1+k4ex+nJVGg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Mt6wKT3u;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785294262;
	b=efNqtz9D76kcxJlkc/YRf1oZ5s6XF9m76G/DU84BJS0eVuGAFVlBuB825KJZbB+a3hD0xy
	K+QZZkrkKDXd98Ksh/6VVXi5AQO8h2Q260ntbDZUYSuzJnlZ2AM4iUSWC9XepAJC7MQgHF
	fncyJ/u+AfE68yCUKJNnHj51usqXGWw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uAp8TPXhJPKqj3Jc2wCbwH1PXdxv3Tg+ZGuEgVhC6ZI=; b=Mt6wKT3uBOGbWaiKfaex8a8E6d
	vsRF8RqiFxnDs4fOoYTeQGJOPye5nr2FrImDER/mv9O2wXbYgqkcUSzq5+Nlp/9e3THhzGXofPWqj
	LxqfBLTMaOQ4LAtKJyu4uF6uABwjgV6fgYrdRIFg74rzmgxvBY9vZqs8g31N+os8q/qORqW6f+WO5
	lzNLq+64FPa+nivY4TtY0SHc39hBKlAxniNXO7lBZEtZokeyZPjKdqCpdFJx40URw9fZYZXKbP9/m
	vcjJscHKCWFYQdtdJzyaAXtrfSu9X1a+OVg3iQIum9XMx2gzu3G9HNvtfYUDTPsD5ho9Gw+Tg8zP0
	IZiKPXNg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wouZ2-000000004ml-0DCg;
	Tue, 28 Jul 2026 23:02:36 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com
Subject: [PATCH 0/2] mm/gup: batch PTE-mapped large folios in follow_page_mask()
Date: Tue, 28 Jul 2026 23:02:32 -0400
Message-ID: <20260729030234.2063885-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C25AE140005
X-Stat-Signature: m93z4ehkxk43b6577g4r7mezfgdr7nqn
X-HE-Tag: 1785294262-461374
X-HE-Meta: U2FsdGVkX18ZShruRPSU0NFNo7Zd5ObG62kp6C17pc7q41UZpCRTBfTNnuuCyUF70LLnAt7N72mt3Ej0UOgW6lknz+APR7LJC241aaFwBEEoBD6KoSTpnkVgboehGLR2QWhn8/rfU4o5+gyW5jM74KOucGEnjYBUogk7RkceWVR03lHTtrRPxpOZs4RtYbMKPy9qvvjwOfjAa7D1DF9M2QZaRnHuDQGCcD7VAl69K7f0vnJvjHTTkTxeFKvy/Z/LbLmmq0jh/Dzorc0kVIfUYwn222KgV69fLlF24vSiUgmBVQkZyl5TOlPlWzIwxUkqjaRDg3KTT3QXHk2FHjE0InJXeLjVajwdVGfM/FXS/H7lqNapnoVLtEd2+2h1mDdJ7WSYPwSq0hZPFx5qnfx1yQFvFfvTEWW8Q2PFo/p8flLGB7uyqEqirFLIa1q6JVj4HBJDns5bxzhjjPDULp32n47V0863agu2N/dIGOWYbF2zQcz7TT28t+1u0N/z6aVqlTxuYDT0nUWCM39pJWPcnJEHNWhr7PJKZBTfSQHB4TPrmovQ0ssiSFa/6j7eA9xeThpAltutbjCVIPEwc/gsevzbeWQgwjbkw7wO/jvJBJVbnac3zz9c5rLT/o/n9hQClRKbFjlSyYlYv2TC1LQl8YYXsPh4/VV/nFNk3Yqya6LPGL3oYHDs6WCek040CwjfrBatLAfMQST3oUpUec+AC7MIEoaFuoumxgSiyWGzJOk92JZE7DQEnJzP49YfiXavK1F0tMQRaXn1doscgkP+JjhZGnFo5Yk47YHBN1wqq0UHgkqEEPkSpYHGY+wB6EvQe1EJwMoR7uMPjb1HN8Ia5sulj0K3tWWuVxysspwYmX54a/vVT1sza1SSLTLTq6dX2O81LaAz+olNBw5j5Cnz1JcV7GHegjD+T57wu5hpWucbBj/I4p3WRsCirtdc097Lo0KGPK3OxK2l92xNC9g
 aP6D/1JF
 w0IeCfqi1gXSo78YgBE6LVJqujoAVTh2psFPoR+TvaPViewawLxhAL2j0VkpJSHvVY7QR/YsTpcciquFlgYjBTRaAeCHzuIjtzqXolgP/X+JK2bEc3TN0+SXfcsKtb5hOmID6eubMlk1Fs7aQ//+yTAXTuCDPyMBG65jf6AnpIswgdXjYuzjawvWl40EGKulm7zcM1lNIowSVePObPZCkdKy+Jx9ogbrNxucbi99U1Kzgz0nyUFB4R4YGlOdPmxzLq+ruYFO9onKNjsvXCjNHQr3T1LO/d1/ZUwr2oNtETL/r1/5knNgL2h6K6haxkMVEgFUSDhOaZDrq52giZuXnTlw+Z3nBXYTlKwhu/dg8or7HfJfTtL766rr2JqwG98/ZXrjSp0K6hR2JzF3wzg20FxDnRPlyqrD0DGu0BVV4HpoTbw2ZK8WWpCHXwacugY9i+mjz9uRatJQRGhPzvX/rPZ6VU8yTXQ+yByUsvTlyoajwd+DZTGayw/PKEJ9zI6zUPwFV2Y58W9MNQQhwRab90PPVcNy1/6HFju/ArOjETNxjnkSYpCS9+ONrMFQATgZuD6Xb193j+sdohc7QhETAf4G6hfDFCXwZt6CSEheB/iEkl0NnooTYTMuAPKr+GcxdA85wLE/BIIpUuScELHNMpobgeRl4viZRMNCfq6cPMEUsZzP0BKc0EoWkc7olAQjwmYBK8KVgK3aRppQeXDdL7f4QXd6Xb2790FBD1+3dkg9nr/OXx02onUrcH1sVpnfakKWJsxl1mp9tRhlbqVs+eaOhna62+ljEWkNmbVxFrmb+scZLUSXlpVoSFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() reports the size of the page it found with a page_mask:
a bitmask of the enclosing naturally-aligned huge page. That form can only
describe a power-of-two block aligned to its own size, so a PTE-mapped
large folio (mTHP) is walked one page at a time even though it maps a
contiguous run, while the PMD/PUD-mapped cases already return their whole
mapping in one step.

Patch 1 replaces the page_mask output with nr_pages (a plain count) and
adds an @end argument bounding the walk, with no functional change: the
huge PMD/PUD paths report the same stride as before, just as a count.

Patch 2 uses the new interface to batch the PTE case: follow_pte_batch()
counts consecutive present PTEs that map consecutive pages of the same
folio with a uniform write bit, bounded by the page table, @end, the VMA,
and the folio itself, then follow_page_pte() hands the whole run back in
one call.

Measured with mm/gup_test.c (PIN_LONGTERM_BENCHMARK, the slow
pin_user_pages() path) on a 256 MB MADV_HUGEPAGE anonymous region in a
4 CPU VM, median get time over 16 iterations. Each folio size was confirmed
through the per-size anon_fault_alloc counters (4096 folios for 64 kB, 128
for 2 MB):

  gup_test -L -m 256 -n 65536 -r 16 -t
                        before      after
  64 kB mTHP            3140 us      412 us   (7.6x)
  2 MB THP (control)      78 us       76 us
  4 kB base (control)   3010 us     3042 us

The PMD-mapped 2 MB THP already returns the whole mapping in one step, so
it stays fast and unchanged. The 4 kB baseline shows the per-page walk cost
that the 64 kB case paid before this change; only the PTE-mapped large
folio case improves.

Both patches apply standalone against mm-unstable; no other series is
required.

Rik van Riel (2):
  mm/gup: pass an end address to follow_page_mask() and return a page
    count
  mm/gup: batch contiguous PTE-mapped large folios in follow_page_mask()

 mm/gup.c | 139 ++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 97 insertions(+), 42 deletions(-)

base-commit: 7368ccdeff50c27809d3a8276c85bae7e402c96c
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: kernel-team@meta.com
-- 
2.53.0-Meta

