Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7BF7EFCE56
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 01:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25DFE6B0005; Wed,  4 Mar 2026 20:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B486B0088; Wed,  4 Mar 2026 20:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE906B0089; Wed,  4 Mar 2026 20:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F30236B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:50:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A7E51A078C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:50:12 +0000 (UTC)
X-FDA: 84510329064.22.6773262
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id ED77512000C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:50:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kqA9N+22;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772675411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=dD52BcDVoMQrtMpMvwdJ0XwlitnIFQsRkhRbjewdIjU=;
	b=l2As8rxjnhNBmfcSnMQMAzBNOAo0zTLcHd5k9DxeU7mARd4sefqewxwCtN548IDruMXit0
	jJwesK98mmqtzNMAZWyGHE1Frxq7+TMAZczirXpc5tgYtxTikcF1LFymdCClCvhQhR/ErZ
	dqP6XSjEDsyjvG6ltM0+LFziNYs95Fo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kqA9N+22;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772675411; a=rsa-sha256;
	cv=none;
	b=oN6eP2i+p4n7/t7rPiqdVYzNDXm8CpRM4jmD3uqIiET1AdkOm5do4Mo03bPMMH9Lj1+ofz
	7Cy/jUcAkHSNDBC/aMkMhhU/XXJvOwNQZKj8Y1C0EKCTpJxicDnXfRsZui4Qs+ckI37yPv
	ax+h5SEMQ93t7le52g8V9yKP+pFwxT4=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b93718302beso143173366b.3
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 17:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772675409; x=1773280209; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dD52BcDVoMQrtMpMvwdJ0XwlitnIFQsRkhRbjewdIjU=;
        b=kqA9N+22XHzw69vDtRogwbADH9Q0ee3XnUcjFArJJo66/PE/qytNhqrJ5pD+0ayiI8
         Y0fG9tZYKxjLXp/wd5hxbG6ehOlMvTyPwUwKESgPE1cXJ9E3bIL2ux/T3PePYtHQMEVY
         nZrppYyZWMyuRjxMTEMzxUyEyy93wHRs5WHE5b52irW63GX/Lm3Vd5kOvlORPdGqJ5sA
         It6EeUYd3bcVgC2ViaOkp8X/dR5M6Trr3wFT5RhhtaHBbPIoS5Bj7mjRi9LU83xPWShE
         Q/ILXeOnxIrQt2Vjv6G44ttfQD2m0YhbPh1ujGre+2DFim5FoAJg8EC2TrkBpOVvqvG5
         9pLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772675409; x=1773280209;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dD52BcDVoMQrtMpMvwdJ0XwlitnIFQsRkhRbjewdIjU=;
        b=gP5dPsZs5yl7VnTasnrX1EyeSa2L1Yy427qinggcV+VvvIN3H27H7EN5oYZ4cLgcFi
         GmDhWe5rtyO6r8+SFZM1Cy4LGNo8KajXq88USxDMDG/2acvFF+Z4f9cDN+36DY4f+lJT
         hR71JcA1zRfbh/tWVKvjjZuI7A3/PgUV0csDvcghDRaslaHiQuxldxocxwFSmvzKGskX
         Qp7hPwRuoMeJ3H7qXdnqnSk8/d1a2D8UZIPwFim+NHzyCKKmlTiRYm7/lVreV2DbAg87
         vc1B3XNbkH1Bm7x+dmRgJwL4jDz2IasJ0X52a036rLUj0YmREuAnwz2ayNor3Y7BPW/c
         Ccfg==
X-Gm-Message-State: AOJu0Yz1L1rqbz3QaDx49swnIXZYVgG7LfTsj6z5lBhmSlvvSipcSxL/
	BsNjbfFtRtKG6J4VXoEmA1aC6x/s/i32XcOdFUpraIaEoiIdnKgZmML2
X-Gm-Gg: ATEYQzxEO4yfZ9ox6f0v0HC7In3ajOoxe4ez2O52x+7LlInHfVq5TZPk0Ek3UIVtAsR
	vRY5n+YlgIf9b0rCpCYfyfcRyTJS9gqwLA/g1x8Snk8zFEuuJ9pWn/JdGy5VAmQhEyOv2Qt0ZGN
	xwVP8G/mKzM1LZ8BH24+yJ0kyJ97dZl+nNf95rHUsSmeEXRSaoSgJKkkw8bbVKx/Jk3HjcxLE0T
	hcGbrKJT3AP1MS95wP5stDvoKYfz/O0C+ana2SjsBFkMHcoKZAZ+PKiiezdYdXgCtfJZoRhfUiW
	ARZ0jjkOT7qf8kxO4xcXe8L0squkNU/pmxgqspsVjwRa9b+mPtouSueVxT953cEgJ4B5a2i4ZtN
	yOsm18NjtWmK5zJ8HshlLIG763SvdJL+l768vFr32utexNKvu7bNwTkGF/zHUdd3YLeMMg3wmpa
	tovTCptUlC6Dqd43A8tAoFYQ==
X-Received: by 2002:a17:907:97c4:b0:b7d:1cbb:5deb with SMTP id a640c23a62f3a-b93f11d67e3mr303322066b.27.1772675408979;
        Wed, 04 Mar 2026 17:50:08 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935aee3ab4sm821988566b.61.2026.03.04.17.50.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Mar 2026 17:50:08 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	harry.yoo@oracle.com,
	jannh@google.com,
	gavinguo@igalia.com,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org
Subject: [Patch v4] mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared THP
Date: Thu,  5 Mar 2026 01:50:06 +0000
Message-Id: <20260305015006.27343-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ED77512000C
X-Stat-Signature: k3qwi6hnu5z5wnm8ni7tdapqupzcz8km
X-Rspam-User: 
X-HE-Tag: 1772675410-438613
X-HE-Meta: U2FsdGVkX1+EjMmIgjPLLI7+t9DlHzJtmeLaKU8btI7za/EbKK0Js/q7aHDFOYg1b45To7pnGGiPE9TfzhGvROnf+l3w92hA3pcN2gcJDIDccO67Gm2NlYNt44Q13uXDMzuKu4sU4jD1/EEHvt7K4/mPVHbmWVigsj8G6wIruO/1fCxq2cc5mlcbAy7IbpwOGj5o4OMHScq+MM417okpezrv7jZDER43BJx7tQGz2ptYRSZ5QbWsDnvjaxNmf8fxNDEHZBs8mvnCbvrNryMefTvNrJsoW884+DWA8uHIvEUsGRAERWKj2XglEEE8Iwg+bXqEox7MNhbCQs1EKt6A7wYGJQtbQNQ44xnJh2FP7BwiWcj0+lYOAnwtc/SGKlTJ7OtufULaZaVkSvwOoc/2uqA3krKoSw3WJKZZtvx0DE0tLgKS9o74TXboK35uQvzeOabP03J9mHrHJufjwYEdZE40Syk5UbJfv/18Mma5wn6aFHDnFtOJaF4QSTxIdRjoELhtJGp/PqKhYs4kNBjJ31bmSlONj0qMhZ5QvqMUrzragStssiWi11XiKHBTSI3yKWs0vX7TPd8wTsemVKzyJXB6Hu2iAuHr5aBpgyRN2OGwZXFIsni4j9iAXaRWorWR6i45V/lUCAm6iFh2v56nA9wAx1sO7BqcJuyC3/0enpdYVNreJ153bZEls3VrXM5K+24h1QqXSyaxgnqNHOucLqcup330Z3ba4uBbu4JG0f6Fa1VdneM/p85l+em93fgXTheoQkcvUTMW06M6tEBSlITmImGWD2wJ1fseE800e4hJ9AQpy6jMtbV6nBIILFKtpkrJN0n1luWMFMw0dMzMpmzDhmqnXHNo2gBCNuDepGGnTBP/1paD269YXuHUdDRDEzJtSopLNJwojHk1VG6QtRrEL5aVOx4ts+LcEHLg983ISpl8r10gb0uOpuvXzN4MhzIrLDWAQdNmhO6NVS3
 yRSZ/Wj4
 oq+6rPb1P64Gi8qZQ4CrRRzLmyQ1Pt9ziABH6CK73bwFRISbmQNK8KJD8ixsISfhYlnZO4cFW1htwUpW6E9cBmU/PnX9KpGLz3cwAWRYwABxAg1+lpyF+UNdb2ecttHpeoJFQUmhWOiqZyjz9R8zn/Xb7TtDt9MBH1HIaHaVZNkaCvt9KxJ8l9k25Z59ViBzS4avpA0FkbbZfTphrGLZi9Q9Ro+PAlOmpRcUj5HzzVdJBrKbmdljQbo8B+uuDjF3wnE2ZOq5JEGitgm1nOd8BsTSkqRQ1qEbbVJW8Hi9lL07zprFkSUgn/2We+lYZOkz/qIz9wOB/DXInRKoe9s8XAwhHzpTl+6m3sggObt/4feCP/B5uBQAChc1PDV4mn0d9XutDOEQJ9gJV/yQL84cUx3uggLjz0o1x4ULRMWCZZbjTFb86XGXWmUNEF6ixRZG7ylST56IjzAKGgeB3/ghn2J3v18giovWOYO8Iar/RNr4Sh1IfMn4zDMvQsattG7jGkMUlN/IMXAQzyE3MCtRit+0+tVOSTx9OkJVMT0rvBrC6AWeBOoAkMDIn/2edid/ZdfUrqZxeuunHkaP/w9vwHX8ag0Ymrl19EGwtnnSv8QJfwjiSMWpHJI3BCgPvNGcicaDcnTHWDJhsTnQmIlKpftDeQ1CXokfFhmXrnpuIEdJsD1N7DCYUIk6A2yiax9C0cBOP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
split_huge_pmd_locked()") return false unconditionally after
split_huge_pmd_locked(). This may fail try_to_migrate() early when
TTU_SPLIT_HUGE_PMD is specified.

The reason is the above commit adjusted try_to_migrate_one() to, when a
PMD-mapped THP entry is found, and TTU_SPLIT_HUGE_PMD is specified (for
example, via unmap_folio()), return false unconditionally. This breaks the
rmap walk and fail try_to_migrate() early, if this PMD-mapped THP is mapped
in multiple processes.

The user sensible impact of this bug could be:

  * On memory pressure, shrink_folio_list() may split partially mapped
    folio with split_folio_to_list(). Then free unmapped pages without IO.
    If failed, it may not be reclaimed.
  * On memory failure, memory_failure() would call try_to_split_thp_page()
    to split folio contains the bad page. If succeed, the PG_has_hwpoisoned
    bit is only set in the after-split folio contains @split_at. By doing
    so, we limit bad memory. If failed to split, the whole folios is not
    usable.

One way to reproduce:

    Create an anonymous THP range and fork 512 children, so we have a
    THP shared mapped in 513 processes. Then trigger folio split with
    /sys/kernel/debug/split_huge_pages debugfs to split the THP folio to
    order 0.

Without the above commit, we can successfully split to order 0.
With the above commit, the folio is still a large folio.

And currently there are two core users of TTU_SPLIT_HUGE_PMD:

  * try_to_unmap_one()
  * try_to_migrate_one()

try_to_unmap_one() would restart the rmap walk, so only
try_to_migrate_one() is affected.

We can't simply revert commit 60fbb14396d5 ("mm/huge_memory: adjust
try_to_migrate_one() and split_huge_pmd_locked()"), since it removed some
duplicated check covered by page_vma_mapped_walk().

This patch fixes this by restart page_vma_mapped_walk() after
split_huge_pmd_locked(). Since we cannot simply return "true" to fix the
problem, as that would affect another case:

    When invoking folio_try_share_anon_rmap_pmd() from
    split_huge_pmd_locked(), the latter can fail and leave a large folio
    mapped through PTEs, in which case we ought to return true from
    try_to_migrate_one(). This might result in unnecessary walking of the
    rmap but is relatively harmless.

Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Gavin Guo <gavinguo@igalia.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>

---
v4:
  * only commit msg adjustment
    - rephrase the reason analysis
    - move reproduce method afterward
    - more explanation on user sensible effect of the bug, especially expand
      what "Limit bad page" means
    - remove the explanation on whey it need to fork 512 child for reproduce
    - explain why simply revert commit 60fbb14396d5 is not taken
    - mention TTU_SPLIT_HUGE_PMD users and confirm not affect others
    - rephrase the reason why can't simply return true
v3:
  * gather RB
  * adjust the commit log and comment per David
  * add userspace-visible runtime effect in change log
v2:
  * restart page_vma_mapped_walk() after split_huge_pmd_locked()
---
 mm/rmap.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index beb423f3e8ec..e609dd5b382f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2444,11 +2444,17 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			__maybe_unused pmd_t pmdval;
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * split_huge_pmd_locked() might leave the
+				 * folio mapped through PTEs. Retry the walk
+				 * so we can detect this scenario and properly
+				 * abort the walk.
+				 */
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				page_vma_mapped_walk_restart(&pvmw);
+				continue;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 			pmdval = pmdp_get(pvmw.pmd);
-- 
2.34.1


