Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D634106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CAD6B00A4; Thu, 12 Mar 2026 16:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFFD6B00A6; Thu, 12 Mar 2026 16:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8436B00A7; Thu, 12 Mar 2026 16:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1346B00A4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:53:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B055B8B5B4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:32 +0000 (UTC)
X-FDA: 84538611864.29.55873EB
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9A7BE2000B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:53:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=L9VE7G8O;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QV2CFG026yzLrH1KSoyywnXP2sha9Q6L0bPhjH46BqY=;
	b=yYjlaUzTQnHqHn4xdFcM0VE/Fko1vB+VSHuIdHVTpZfcKlZllxZQ4Nco00ZunUKd1cchrb
	cQNx8o7uRWdXW3mbjIe0//9OjJLQT+eeqB8YrzDMfLldD97EtWNoWzaYeYWixELWC+qE+L
	HkFS+hJ/B/QbtjC2LvnajPYBckvh7I0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=L9VE7G8O;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348811; a=rsa-sha256;
	cv=none;
	b=qrSxuLiKP+wzv7twWTHFQrbHxfuUnkn8XYaG5q6PCVRoXHRY5NT7hwvRPKvlBOM0X+eCUZ
	adliGdEG2c+gp1g+yLrfs20OXRuaES/zXcs6IIxtlnceDwRGjTZOHLalShMsox2xLg7ZjY
	rCTONh3LQsbbNub1wQBCRjOJdnrX3ug=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cb20bcff5aso144240285a.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773348810; x=1773953610; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QV2CFG026yzLrH1KSoyywnXP2sha9Q6L0bPhjH46BqY=;
        b=L9VE7G8OrF02FdN/JVu4gorKvMIcsZKmJ5f+o9sl5IxFNjBKpSfJFvs35LS1lw6+qq
         pKlbXm5zCfg59mCd1kSfkcH2Lu7BkXt5slAT+hyvPTJvwg+1W/gPDkwlFgRylO7QQD38
         fx+BzZ60yEucewuqJv9XVQHM0sf1rOB/ANQhOCzjackmtVkD5OzZeNwj0fE+Vhbv7R45
         rQZ5OdMSWyuYk6XEmj9ANwSJ421F9f0mP/UAxhN42ms7vsnVy6glXPoiICPSrpZL9nOI
         Gd8CXfezr3yoJg5t4V1hVx5x1EK2MkSpXJmcDc/h4At9gQSdrlb48AY63NK4DYbRexV1
         QSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348810; x=1773953610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QV2CFG026yzLrH1KSoyywnXP2sha9Q6L0bPhjH46BqY=;
        b=N9/5p9bBPEh7B2lNYaLrWe3sGdA68YVkJS1qNu1NdXmv/fUTEv1970YNW/FaOh/CcN
         XDeij/rQg/gnHGccBgfVSD47qJb6kGBBCeCqbbSqkmawj4xSZLLBiqzLK3OpDEAsv6tg
         C8qnKdQ4EA8S8nK9RTZrUFPLPHkpVumZGftvBtMdZMteaZgWy85cyIzEKysjl6TNBdu7
         1oZQcb90B3MdPdRseD9XSBIVyZhz37os0BvXxmp/strQQmX4lP8imb7vkUa1Jtk/s8HF
         lEuxFhvtR4avA02/l29Ayldp7VZyseO2Ta6Q7uio7auWhyPs9rdS6rUjAJImECQxPUh1
         SLSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYpHsKZTdIxu+qJFOvUiWEHRYlV5gt1n+kEjutDNnPFupng3bKEGJc0k2Gn7fXyJGdlOUv4XVtPA==@kvack.org
X-Gm-Message-State: AOJu0YxRG+dAa7nY/x2vKIosmSa4IXYMnFtYyG9/lg+i6A3JFbQ2Jqi/
	lni3+i6VGN/ciLiOHn2COSGgc4GayBLm6/YkGgG4DnoyRIAbK7wA4CMMlfQHKN8Xdho=
X-Gm-Gg: ATEYQzz+t2E/pJn2Ned/xv7Acg3SB8K7FNB6hyNzbD1xNUS1HBkhyMyrGQPCzpwGiXY
	xoH4Y/QFniqiQ7IAYSZAYOx1F6OhuaOZfGb6GKhmDc+uMCKHLEurtbMMg6L8QySsJ2630u2G5a3
	YPIBoEejvr2GVeNkMOZRLNtGuS8Hy8Vmqdk7SYCaJwi5i0Tuv5qQ3HGn0L7lLcOF90tCgOUC5XG
	B7NpXZsty8mZlIGLgZRKpDB3AOHE57VfcW56xVAgNcuLS6D+oswD+zck0n32ErFW07Gt3PhBpu4
	m7eKo8NuhTjRnbkyMiMMLXi6eKsoUktjLzvNSZS/pohDfCYtnJEo1W7wx+hzyb0mH7KqSHfS1q6
	4fwn/fqyLsz9h6e1J3c4XfbChLHti2VF+Hr2gs2g+UOBCZLG3/e1pOJ/pKDW2KPJl3aVtEZdaQw
	kTWXSX7rICYVYPLVEsY/TmLw==
X-Received: by 2002:a05:620a:3709:b0:8cd:9599:b7c7 with SMTP id af79cd13be357-8cdb5a5c90bmr169145985a.23.1773348809607;
        Thu, 12 Mar 2026 13:53:29 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda1fbd120sm412847685a.7.2026.03.12.13.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 13:53:28 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] mm: switch THP shrinker to list_lru
Date: Thu, 12 Mar 2026 16:51:48 -0400
Message-ID: <20260312205321.638053-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A7BE2000B
X-Stat-Signature: 6br9edfd9ymfqhciwnnrcfxrqzaozezh
X-Rspam-User: 
X-HE-Tag: 1773348810-285261
X-HE-Meta: U2FsdGVkX1+YjGQzQ0ZgDhFE+rE2O9FZJ0nxBFx6ysLg3XG0GfiqeeNsaAjMxrF+j5Fhm/PpqYpvHLAQdvDLVEyFClihxA2kA9msOi7yP/jJNsiCXdtj8N1BPI3aBqlZPqBQ1MtI3iKPS3WZTNLrMDT1Gwt7PUawdjAe6Eai5WyudU838NwbtvtanlSb4ccji8w474QMtB7wT/B2qpnlc+KeaZncgaIXBap9cVfTRRIsi4iNhNDffQgoO73YPxReejqH0nPOAV7hXVll1tbXbQ4oGtavScqvUeWAm8dPc2goHod/YcVmnBc2GhGhaPb2PnbGx/HNifgfw33+v9sdLby4rRx0d9QTJF7FGWVnp9hZL7596R5Rp2Hcf0dPdIcM9ljX++ZeqhFW/I6EHl6R2U6lVORvm9CojqvRLHM9En5m71hgittXmohQhE82wyezwd9TBiM6yFRk883hNtEF1UOCOxsKhqNpuv6dyR3e/eYB2rcDMkyW+mzNbmtti1NMdvENgjFfZaatdOqVZMcskSZS0s5i2KVXO7ZlgGezQ0+uDWQMwPKGx2kDV3n0kHy0Xg/3+NR4ePfQBwcoltl+BpwXrxHOElb+P1I4bCuqg6hhnC1ila3Rr5uz6BETLUjHAj8ajm/yQuboiD7Maz3itn+6vXpCh9j+0daQgcrMItrZqnyMBQgqQFnNDzmgQ4UJp5vvBJhLRW9jkOGnQLRfaVQQVrkGWUrWYlvSEduBrQi72HHm/kZQj6N3lTpwOLjH4cluiNDor1XiVT/e5rVLMNxVIRZ+a6PjvpgroX4smAW1dbz/WVCEnXb5dZO/kreAbU4tyC3TKr534ttt5kR5/SoS+ADVdytKo65ouMx0zmufZtJGeSjvs7fUlsHsJqhJDXchmNIzCD3fGktIjH4fAK0D0+RBW+kzOIW6dc/cR0O86m4RssRDGd4HX8/5xrjCzygHYqQFJLty+iCtz+g
 BrRb3CUs
 h9zlQnvRowXvDuKVwtPqoduwKl7rJxKBw6HC2wS8eylz8HhKwDgj30Fpz6QCtKe4kohCzgoeU11+s+9NlYj/SEkeFVjc0YAKqSe0IXfmchF05lIySQSIdS7TN0hOA/WBzXhRSnWc1G7sLKq5AIlWXJLrgpStNgP73JetCNVdbDkZ+1YlBmdcf2xu5nQrvONxKJxtP4z0EoUrfbywS6tG4jGpEKg6Ss4MGOhKbV3Oy5Rjejz460WKrirT9TNuPeoe901SNhh6aDx0EVHINRXiPH96SxDYVSO2+lXAYPGnQQBB0GH9uiW9tZmRSdNgRiFf4kRTpwEyeydShg+fkM9jFyNK90VgG2S2c1P5CJqG/Jqx5jQhqcG33MStVrA+49ulGnLaAA5qoQYU4x8XoEuOr84dTxesnT91Du5WY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is version 2 of switching the THP shrinker to list_lru. I fixed
the lockdep splat Usama had called out - with explicit rcu_read_lock()
annotation based on list feedback (thanks!). I also split out the
list_lru prep bits, per Dave's request, to make review a bit easier.

I was initially looking at mm/shrinker.c and the scalability issues
resulting from shrinker_alloc -> for_each_nid -> for_each_memcg. In
the process of working on that, though, the open-coded THP shrinker
queue started getting in the way. Switching it to list_lru seemed like
a good bugfix and cleanup (9 files changed, 140 insertions(+), 300
deletions(-)) in its own right, so here goes.

Patches 1-4 are cleanups and small refactors in list_lru code. They're
basically independent, but make the THP shrinker conversion easier.

Patch 5 extends the list_lru API to allow the caller to control the
locking scope. The THP shrinker has private state it needs to keep
synchronized with the LRU state.

Patch 6 extends the list_lru API with a convenience helper to do
list_lru head allocation (memcg_list_lru_alloc) when coming from a
folio. Anon THPs are instantiated in several places, and with the
folio reparenting patches pending, folio_memcg() access is now a more
delicate dance. This avoids having to replicate that dance everywhere.

Patch 7 finally switches the deferred_split_queue to list_lru.

Based on mm-unstable.

 include/linux/huge_mm.h    |   6 +-
 include/linux/list_lru.h   |  46 ++++++
 include/linux/memcontrol.h |   4 -
 include/linux/mmzone.h     |  12 --
 mm/huge_memory.c           | 330 +++++++++++++------------------------------
 mm/internal.h              |   2 +-
 mm/khugepaged.c            |   7 +
 mm/list_lru.c              | 193 ++++++++++++++++---------
 mm/memcontrol.c            |  12 +-
 mm/memory.c                |  52 ++++---
 mm/mm_init.c               |  15 --
 11 files changed, 309 insertions(+), 370 deletions(-)


