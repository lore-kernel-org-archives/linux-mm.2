Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3ACE606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MO0yzEhJ
Received: by kanga.kvack.org (Postfix)
	id B7F5A6B05B1; Tue, 17 Nov 2026 05:53:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30D96B05B2; Tue, 17 Nov 2026 05:53:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46B46B05B3; Tue, 17 Nov 2026 05:53:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 835016B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:53:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 537B71C3B06
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:53:27 +0000 (UTC)
X-FDA: 85444299654.10.A71B6AA
Received: from mta0.migadu.com (out-77.mta0.migadu.com [91.218.175.77])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0FD00180009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:53:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MO0yzEhJ;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794912805;
	b=r6TSU5YGC/2ekipkrqUOothshygX7xEv01B8GkBTfID/wHDnlIg/l585lDvCbHqoFW8CPQ
	Z1l5h8CFwPaciBNvYZuFgskFKlDyg21xJZWcWZGpmfy7jFfg4EYLzS6FKEunkl77OBJ1M3
	hsnGqXwoor7iloM/miB+Vi3JKH43v7E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MO0yzEhJ;
	spf=pass (imf24.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794912805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HAGt6qzxx+w+fhbni5wKqfd6ztTkFtnAu2zDI7HIbt0=;
	b=g5wGmlnKIvHsHyUpTuRlhidKSq5cOfe4llmcMB9MvlSn1RcA/U4MngyznUFSX8qLYctc40
	FLNUU9TJ4Cir3A3FMAGElFG8H1PM83oRTnz0YOQE+L8XHfSAzyqvHngBGiKkn2rqi1Ff9a
	Kw/gKGeKNgRR1437D5kgUbLsM8AvnH4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T7WRqNFtG9jzZZ1hVnlsHUAqoqC/MPMVJHymMdDaapM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794912803; v=1; x=1795517603;
 b=MO0yzEhJ7/LWnxZ/7Ww87e7kVdgPkwAV9gDuFa77F/Rpq0SJnhsozzN7jEsMQKDs8KgkiqSl
 InQDxbk2sQIvKRMVOuO14iaDDS/cnK060dCpoxSvwa+PNLpQbyAt25nw8IKHOtcwbGbAcIIxxw+
 iPiq62PRL/nnhC3fcgkXeirM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 121bdd006f390358;
	Tue, 17 Nov 2026 10:53:23 +0000
X-Mizu-Trace-ID: 121bdd006f390358
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Subject: [PATCH 0/2] mm/memfd: drop stale hugetlb allocation mask handling
Date: Tue, 17 Nov 2026 18:53:10 +0800
Message-Id: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM2wpAQBRG4VfRvjZlK6O8ilww8w9bOTSDlLy7w
 eVXq3VRgBcEqpKLPA4JsswRnCZkhnbuocRGU57lmplL5RavJkzOKjDrsoB10AXFfvVwcn6vuvk
 d9m6E2d4B3fcDm4pbRG0AAAA=
X-Change-ID: 20261117-for-memfd-e11675edfe65
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794912797; l=1020;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=T7WRqNFtG9jzZZ1hVnlsHUAqoqC/MPMVJHymMdDaapM=;
 b=SdohuePMWv/Fij6EOUmEMZdDwQm3KeZxjCEuyeJepEbiEekLkdPRPqAhplP1BCkZLJz7FN2gw
 Aq7B479uToQDnLz556nkhs9zxJxDHu4sHUJjnFWBVciFCef7B7qU/c/
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0FD00180009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ysjz47boawqezzsq9q764mwyw6kp4uut
X-Rspam-User: 
X-HE-Tag: 1794912804-36021
X-HE-Meta: U2FsdGVkX1813g1LpIoVHPMFRVuPbveaAd8zKGvdm60LJjFSKyJdzUJGPoVtRgJkIju4EqDK1KKSQyoX2U4a7PYPiRpZP+tcMLCvTFVitUPsD9BF3y1S2Iu1mr0t3o8vJTA0GKYVJF/8tel+FTSiFahq6nN3m9algHdxopvat9YTyfMXCAMm0hHuqeiMH2o0g4rAmijAWde3sESH5JHn6tFg+mG+q8+pI+khss7GInQpPW1W5Ye74Gnyhb5BigLaAV1EgZIjKNOtsB7iACNoZmPOo6/CSADFq4JFmLhLFUyVBDeRPekUCzXHr7FR90EKMKt1uylsvUiHLIEbsff/qCYWjGvqaWeZ5DfAGD/VulZDkVFJcsLHbBKR0MNIRGcbWiXPhzWKMpisTwubqpWy1FioqhVTuuaTj2tnMjlccVW61LfGvecNiKevq/INtpq21CQ+EDROQePmhS+mlzAnseef2zf3+ajkXWULDi8U+YLEcBzUSj+J+HNkVNuwLJnlWrMGuSgjLNZTZEtBa/IPXmY6pzU5KUE2YdSwJ7FuVEDd3ldwZtEVzP516bmJeL4lxUUGd5TKtZ/yOo/4ko2EJ4ariaEt7kjDAbmYFychFMQXCmww0U4+Z0YrP5Fu+WRyN4B6EvkVDT1u4iKNlhisC0xcvc+XlYbzVKq0Quo3e/zNGZYuW2nd3DtqUqH35BF/s+yHvT/wATInFmkuF5/7Yyde5rVAJ8v9L4TtXJDlzdou8tSc2UD1SMB2vs/qXrXi7BCEZ+sN6fTq2uzLYiTNEiQ2pn+HK8jADiXT9Kz+IteIT1R4+B3/DaAz2oufLooMAqnHgm5R8sobjr+PZ573dHP1vxpAWvZIp7cicyeS3h4zZTcVb7dPsNSDFo0+BsYRgBG/lom+7A4IaWjx1HxmkOJW6U4NxShJZ/Q/o0UupSGABn1BKajvOB5WPf7jwlU49RNsBY10YwicOPuRSq0
 jPY6tvPV
 9CmUxngQ49c6b+9pT18/mxSwKR5SsMYs+EclVNzZUC1TqLFL7S/1s5jRBcTZwqMRTmyP547dg36/7MRiw0PJO0TCf3VMeqguQFbsx5gd/fkgLzov4hh2+/doTkjMRz9BO9JBy88HWJ1GBXbO37R0mV4bntE/pWhEZYBXtj6DWQq622aFKLanj/08atuaNw4Fzfy9L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The hugetlb allocation mask computed in memfd_alloc_folio() no longer has
an effect. The call site only dequeues folios from the hugetlb pool, so
the mask selects neither a zone nor a migratetype any more. Remove it,
along with the gfp_mask argument it feeds into
alloc_hugetlb_folio_reserve().

Patch 1 drops the redundant narrowing. Patch 2 drops the gfp_mask
argument of alloc_hugetlb_folio_reserve(), whose only caller passes
exactly htlb_alloc_mask(h), and derives that mask inside the helper
instead.

---
Hongfu Li (2):
      mm/memfd: drop redundant hugetlb allocation mask narrowing
      mm/hugetlb: remove the gfp_mask argument from alloc_hugetlb_folio_reserve()

 include/linux/hugetlb.h |  4 ++--
 mm/hugetlb.c            |  3 ++-
 mm/memfd.c              | 14 +-------------
 3 files changed, 5 insertions(+), 16 deletions(-)
---
base-commit: 0bce4c3c7589a80b09a4f21fcb41811cca5153a1
change-id: 20261117-for-memfd-e11675edfe65

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


