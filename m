Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49EEC606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=VHqdi4sa
Received: by kanga.kvack.org (Postfix)
	id C2E126B05B4; Wed, 28 Oct 2026 21:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05646B05B5; Wed, 28 Oct 2026 21:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A3B6B05B6; Wed, 28 Oct 2026 21:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF006B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:48:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD9501201C4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:48:58 +0000 (UTC)
X-FDA: 85373980356.15.55B5F72
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id DABFF100004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:48:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VHqdi4sa;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793238536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WpPpjm9qqTzsBHBWliVMSUioS6+fsJ4niawtYuOMrWQ=;
	b=ulWKcvwFPImCenDZ8zsUZcSAN6yByMor/c8P1VBe4VSoYyGV19/XJF69GGdn4CxAPdTPkW
	0OZ6/Hf45vp+itPJmHgVW1FZ62nDYElC1/10GZ9bMtSLNm1T3z185yWd/2gIHQWCy5HAow
	FCV2BnTZlBMiZYDZE/bJ6c/CccAzRko=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VHqdi4sa;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793238536;
	b=u9iS8e/z75cjofVJ39o9kCrehBbBhOln+OZFKu/QUGceT/NqIrekmB7wt6/YSfdWUvpPUd
	tJRSxotKb+cKC9mpYMHQ6Lxflig1oW/Api+S7IWhHnGpl4LFrHL/ANJtv5w7kFPPvqpVP1
	q3uiqhDIb1k/GReG5quQe8qc7e0d9+g=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b408f2d936so2438728a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793238535; x=1793843335; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WpPpjm9qqTzsBHBWliVMSUioS6+fsJ4niawtYuOMrWQ=;
        b=VHqdi4sabtzVzM1ozHitWhwqblJdK4kXCdwJNulCeAOIa4xQmj8xZ0MkdtsP9QFR2J
         S+wCfENRRzQi1dw1jiKsT/GKafQ1mrpGLprkfoB1RvMt0BYNq2jZWB8lHASBK2eX6g83
         nxKJmUcE+Pd3aG7LiNRSOwgz3IDmVlzEhzOJjhjTBGLlF56rUGfhMgvrNwdqbSBbLJFU
         HL4M2+pY8MryIPmeT1gO4L8DcFHpGkIKUCwtygY4uiGPPcWSmaTiDFRcveyGvLh8i5mo
         4u54luzkTjfX5YoCG98DtSNbe/XRcGukwS75Pe+21C8ZHqZe5IxNSSXu+UMJhsaUzyK3
         op2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793238535; x=1793843335;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WpPpjm9qqTzsBHBWliVMSUioS6+fsJ4niawtYuOMrWQ=;
        b=Z2KWnDuXo6FlkVjDSVJdcMrohBv5Xata+5PbaKLFr2ggkZwtVKsGo5gWET/nEg/xsQ
         qdqPpRhlWRG4aIwI/ZOcYP3wabtOd+wzP5WRQLcSPEILdw1TQin6+hsjFt/LVFvmPnky
         Tp1h55DU+UGopHDBsH7VrnywIzd9x7sZpuXxCwUbsURhxgsemoWXfCfoIPVYZCa37AKA
         LY5UolBk1kCb8eaRhM3pgCZv2EjLdBjgImMVNX1BUftNQDinju7srW5zWnA5vZZGLPgm
         XNjU3E9dQpOOFH1x+mV7XR9CqYaZCg9BmfwU5PB2kZbAc34JEKhkGnu33JquL1x3LadJ
         Nb2g==
X-Forwarded-Encrypted: i=1; AKwUvBy9/LDseH3tkP7a7LTsfbbkUWNZEscZvfffkm1YLJ5jA2PmMUfkIurA+dA56IY8lVAu9MvnAIlhWQ==@kvack.org
X-Gm-Message-State: AFq9FYLaebGcStxISGONtjGCjtQoBWl6rrtEuGDrnzMsKftViwCDkBy+
	Rr0gYeFLIrLrZU25O/KrvpR723UlnOBI706Bi24mg21it6XpQLCgKNY2tAT031cTD/s=
X-Gm-Gg: AYBFou2F7V3xvcnjUP6chfx4lvR2zyEGljz2ZUyLmE9SzxXDcjkOa1cdczsnRgpAjJS
	VcPbewCZje9O9eX+rzp8dvwN4hPP6PDqINoYIUrjiSTT1JE9x/rfLMVbQtKsv6MX9DS7kbdRBrX
	whj7yjmV5MuH/AHYZbJZ6ElgvderL9Q4tEfrU5LqknxF1DExbdq6so8AWSgPSiDC7d1PtNc8oaF
	JZKz00EVWiBxrDENI9rEP4uZUDV4JtQUIQ5ndx8SHKHjGeEsibaHkH8dO8VVA3PLf7Npns5V410
	XWqUJfnv0V/KH9Q8Ty7Zr9Whw3Zteqs3JIoeqaKAVGD0RJ15p7m9zZnhRc2v6Rxg5dez4j1QHOH
	x2Pgl26q0zaiIt2DKMJ+Y7kQvgrspOBVKgVJwxyIm5diE4GCXDO+phel0gm1vImsrOENPXsfo92
	BU5VRHRiOKwhKaYJ1C3P5dRpqBg3UoBbCB/hJ1ZQ6QKSO4kW2PyBoSL+giN795IisAkdxmr5L6X
	liL4bVV3xkZ0gvzMptwNq1XZMduRprmR33KFA049Pj3RIo7oESnz+Yo3ZxlHZPjOkan2E2bPOtP
	zzIYbYCZilWfeSNznjir
X-Received: by 2002:a17:906:ef0b:b0:c41:b94c:4539 with SMTP id a640c23a62f3a-c49bddac7b0mr353178966b.6.1793238535200;
        Wed, 28 Oct 2026 18:48:55 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:4e::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b495ac454fsm2147232a12.1.2026.10.28.18.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:48:53 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 18/46] mm/khugepaged: check if PTE table is empty in
 try_collapse_pte_mapped_thp()
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org
In-Reply-To: <20261027-fixes_core-v1-18-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-18-6f74bec9a5bb@kernel.org>
Date: Wed, 28 Oct 2026 18:48:51 -0700
Message-Id: <179323853182.453251.8510731747954180380.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: DABFF100004
X-Stat-Signature: e1bggqqc9udbigojscry9rw3u69f9iqk
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793238536-799652
X-HE-Meta: U2FsdGVkX1/LwqXARLMW1tqYs9aqNpeWonobneiQEs69jkSlJx0wftrUMdeBHwLHs0IKZQU3V20Go5GIrti4wCREMoJ7Xdy/yvSp4gWvvyifirw2KJMWCCDJU4GD+UXvzgSMoB2fPzNyo0oyY03HAi8Q47hJhHjzfyttyAyg9JZcWwJ36UPlyKRSUxBordSkQ7dsHzVir/Tb9OYuKYNUiCLI+kB+098MgfrJMSSDju6sKPadSYpVqApO5cuS+fk/s7ZaDzEUgWOTetSlhvoIWk6lj1vnPq98QplCoHyu5rj/ZYs/fT/Yb/j1EJ9iXkbvn/0BTH3TjmQMhpvYc+uduGlS4ANGpwEk8KwN1zO9jwBuAn0gAzOWH5D8P4FpP8i68NZW7cyfY2v23BmeSQhR/hT6z0lHMWnh+B2GvlafG78iv7roEpMyNzXYdlOZTwzePWMG3PzG4VwFzoD0vm/ohEw4ltj2eBsrzZJpH1k8yYvRYprsCGE7X4xkviI0hh+8b1SMly6IkFepbwfj6eLwJBPp7a+kz5SHMSHqDdS3XJDWln6v4rJ2oQZ8rFhzQm20h7r4TyuGXBjXEVoPqVBgssM74QOpiH7jbkyDVNhnnHAYM7BMl9lMLweyQhHgdxrGICzgJutbZAwab/trAmu9ii4LoADFMmI4LtXyfi6/3+2opvk8r641PawK3ak61mSWtfYlNBXIXAAMUiZf23cMqO2yMbjnpimVDmMeiiHyWD0FHiNxM6mP77uezlkAy/4uvVrgyGK8zDY/dB5F19sVNnwwgNoCbPTYaLvC7tQOy0VHbij59oFGfdpm90FMSCrDOxR87JpbX8ZsIF4DE6b05vyrjhIaPOGti0UAmPuMF1VOh90AahRc4WcBIdW/HgvmrDSKaO5R8Y4evm2u95YWeQw+kTJDnnqUJhtXPDS+rhH40feASQ4EzIlSljjX972yXYbtTELsTSi/CXQtukK
 MZdgezrB
 Di4/aA+yZRyUzplHq1f/Lr0ckCLjnCa5JZVsFg2Dg0ck0uL788bqqobHwZmcBj42gAstklubg2+EVleLu0BtYLjDo+gzD7980hjrVF9JWn20MR1EXd3wZDPX5WS2JrkPSuVaXlFOc2D1JYpxoz8czaoyuDRDfjJXqFKoBDSCcjAxCDqABEwJ+6f2R0t9WzTraEwdA/d+CRoWPdJlPd+0NFEcdaDdMvajTAFy+ij5OdBAE4ZYXsnm8N/V7lTX6M8Qz/jLGWcmTpWXvYWPL+qMPHaeMGy+928kI992pkKQpAQY7JALPQ72wO8J1fAXp9/y4Vb0qezp2iwiwtt2aQdKZd0x3VqCdYy2FC93Yl6kyDItYqa3Id7aEz82qG84grjUnjShAuHRuWDzwrJmUaqsOhBV3e2eL3SMs/QAhPk3HZl17MaXmfX6RBurU/k7ERyJ0MKSCo693le9DIai/8lf8a2nzi312zEapHDC1nZQrsd5DoWCtBGlaKIWfeQKz5aactlRIXPur17Np1Fs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> The existing code is rather horrible and already resulted in bugs in the
> past: we special-case UFFD inserting anonymous folios by grabbing the PMD
> lock early, but ignore any other markers (guard, poison through uffd) that
> could have been inserted into the page table in the meantime, effectively
> dropping them.
> 
> Let's just unify and simplify the locking: try to grab the PMD table
> lock and if that fails, flush the TLB, drop the PTE lock, take PT locks in
> the right order and check if the page table is still empty.
> 
> We still perform the heavy lifting (zapping the folio ptes) under PTE table
> lock only.
> 
> Include <linux/hugetlb.h> for now, as x86's flush_tlb_range() macro
> depends on hugetlb helpers. This dependency needs a separate cleanup.
> 
> Both issues this fixes are rather corner cases. Let's not CC stable for
> now.
> 
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

This patch is painful. It's taking me a bit to wrap my head around.

I get that you want to avoid taking both locks while zapping, but
wouldn't it be simpler?  I suppose we don't know what kind of
regressions might pop up with that though, bah.

I can say that I've reproduced and tested the before/after state,
and it looks stable.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

