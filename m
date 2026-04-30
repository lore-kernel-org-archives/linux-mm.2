Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F072CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D0F6B0088; Thu, 30 Apr 2026 16:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EE526B008A; Thu, 30 Apr 2026 16:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503EF6B008C; Thu, 30 Apr 2026 16:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF8C6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:22:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BAAE8A010F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:54 +0000 (UTC)
X-FDA: 84716345868.28.84BB092
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 45001180007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:22:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ma0iimHf;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Sl9lzMSKdW0jTiCedxntaXGSN6tXw6CmB2XM2iHmpfQ=;
	b=MVZOsRiIaoU3dx1Fzadp3cDfWIyljRibpBog0YEPEiNw930NWTIS2OjW0MSHaUJMm2pK1l
	yeBFT2v/Tu6PN8nOMg6jZvBJhB7SudZ7oshLpNAn30cYCkDDHPP96oUtGduSTuzszwvOp0
	nwfwMavwELEHXR2k44yxbJK6wIkhcJ4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Ma0iimHf;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580573; a=rsa-sha256;
	cv=none;
	b=wh5jsKTZWDwnVx8h0V0A8otgGELuwT1NBD0+P1pKlWCtGUq7mgj7wFhT07Kb7oCXs3wfe3
	VxBOSWLDpGCU1lHCLKnBOj6SHEIdlGO8g30VwEeJdXGa/bQHNKIXsEUZ1UVAb8kfZ9Sv6O
	R+Qj1JbQoEOrJKYsI23SyxBlGA/4cyc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Sl9lzMSKdW0jTiCedxntaXGSN6tXw6CmB2XM2iHmpfQ=; b=Ma0iimHfP+quUiNRvQZHVPO/oL
	4kOxlODNo4yc+E8ooEbNWZVyB3VOHLoeLWD+eFUFdWE1rIwluA1Qfprwxa9s76E6P3pKDUBQmD09H
	YSFwuF4N0MhBamBMXmV0im3BQOl86PUFQ+Kjr2JQoVCYwkG1mesl5LaKuWk8vQxnRBI8NMF2qvKUP
	IzOTedDsUeWdH9Jwdh81jDDDRKLNjsnIi67QzzX978M4ePv0CkxRxheO+qVuX/2MlEj6MpSN9ANit
	8IAoc303Ah0RlfU7mrTdBkGSrK/SWYiqBOCchuyvk8JYHpVwWECqsFf5TtEGv2kgcFEHQt8Qvju0O
	0FkNDroQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-1gnr;
	Thu, 30 Apr 2026 16:22:40 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev
Subject: [00/45 RFC PATCH] 1GB superpageblock memory allocation
Date: Thu, 30 Apr 2026 16:20:29 -0400
Message-ID: <20260430202233.111010-1-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eg5bcd9z48caitjdh3xcia3gny79uj1s
X-Rspamd-Queue-Id: 45001180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777580573-117223
X-HE-Meta: U2FsdGVkX1/K8m+ktyZcESph2Al8oLlIfKMY0gMLdF6pLLM67U3iJ8p5HKbSDf7QHMyZe/SyDmmgRkGX7TlDWBIEFBYihYYZj6ru9NtYuzMLlLmSQyxqpzwDLCrF8l2u1LKDIJvHcLNApYGuJ9cajwMZTQ6C5PFjUT0Wr8EljKPZO0XRsI3gcGLyqb3L61zI2XoCpqI7hoh286cdsAmuFcFhAymP6yVt4SGRv5LtsYbCAif0tXsAs31PbzM8Mx+Q99FVlt5N6z2F12RbxfOIauxvscO3GLTcpjLL3EqAvLW//RPaTsZd45GXvNMVFDZCI+pUfOf9WuWeOGR9oHIViJlIAUAXzGeWej2EmTuN6FMsHHSVG0V61w2kb1CZblDErBiMBzUKGrtGa7DyRPHI2GRKiTwjlOuJ5lwZpjPFhD6EJjWGZm1cGYyeD0CsPZBP2MPdFgzUUG3pO41Me+WgkuinfX1/B2gt6my09J9E6DHiKbnGuyMQlDKS6TH5wiiP8avysWIg2U5Drwoq6nEG4xruacfLbBDp4+OshC+zSS1jU4UdRhhhTy89OnftDY5stFCxLsSw2svG1t0o/anmvgJ2kGAmwKvHyU0jC2ZgTRSDkOg9rJdHGIh2532Cw1lvMVZhu38ubuB61eaJK4oFIUsDNnyfMUS22tx3kcq/CasG9F/of9Vr37O2w4dT8CJExKX996ztUKxJmkYZJO6r2YN90Xt/64W8s+Y1YY1JBVpP7XxOB0pZDd4T1YW+qBMtskPo9za66B/B9dbDn6VFYepkY+/lbaw0vzh3oYhyTliVMYIhgihlUHpNB6bjiJFecN3g2YHexOUJ5vOR7b89zcf+rcSMX+aW26kh+gWnya6I/V50aeG43IgpWXddHZW5W/FahFrZPLvvivH9+yDe/JqdWqEusp+mL3TjDYj8jv+khhIMzUeFOf8I+1SVU1w1UC5KJ+qltEOmp+GFHXJ
 +2PSXw7b
 S0/jr83G0XNszbCXLbDGC28bGbMikpcU/PTXnC46BvDPZ81aTeFQyYVrAv9tP5pfMXiiMCqDivmRwwrbIigA6TzT1XORRtUDQKG0DeVJffVEd1aWRibqH/yYdcwxLjuVpBUr5tA2t1sXdfwhtkBklg4GP4DXaLV+whLfz8yKAy86RGG3Yuv3MdPGhOGcKap+nTZGz92UjQNw77Q+IVUl/nNpilA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Neither of those are great solutions, given that modern servers
tend to be large, often run multiple workloads simultaneously,
and each workload wants something else.

To address that issue, this patch series divides memory not just
into 2MB page blocks, but into PUD sized superpageblocks, and
aggressively tries to steer unmovable, reclaimable, and highatomic
allocations into those superpageblocks that have already been
"tainted" by such allocations.

The goal is to leave as many 1GB superpageblocks as possible
used by only movable allocations, so they can be easily
defragmented for either regular PMD sized huge pages, or
for PUD sized huge pages.

This series is still very much a work in progress, with lots of
work left to do, but I am posting it now (ahead of LSF/MM) in
the hopes of getting some feedback on whether this looks like
the right direction to go in.

This code has been largely written by AI, then nitpicked over
by me (with some early feedback from Johannes and Usama),
and gone through the cycle of nitpicks several times. I am
sure there are places left where the code could, and should
be better.

However, it does seem to work. On my 256GB system, I can
run syzkaller with AI automatically analyzing crashes, examining
git history for potential causes and fixes, etc, using up all
of memory. Out of the 238 superpageblocks in the normal zone,
normally less than 20 get used for unmovable and reclaimable
allocations.

I can allocate 50 1GB huge pages without driving the workload
out of memory. Presumably I could allocate a lot more if I
shut down the workload.

A number of the patches, especially later in the series,
are fixes that should be folded into earlier patches.
I hope to do that soon-ish.

In the mean time, these are probably the patches to focus
on when reviewing the ideas behind this series:
- mm: page_alloc: track actual page contents in pageblock flags
- mm: page_alloc: add per-superpageblock free lists
- mm: page_alloc: add background superpageblock defragmentation worker
- mm: page_alloc: add within-superpageblock compaction for clean superpageblocks
- mm: page_alloc: superpageblock-aware contiguous and higher order allocation

Based on 1c9982b49613


