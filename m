Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E35A606A326
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 01:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=n1ltugaL
Received: by kanga.kvack.org (Postfix)
	id 7209D6B05B2; Wed, 28 Oct 2026 21:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1586B05B3; Wed, 28 Oct 2026 21:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1516B05B4; Wed, 28 Oct 2026 21:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4C46B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:25:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB148A7B14
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:25:19 +0000 (UTC)
X-FDA: 85373920758.01.546B76F
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8B24A0003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:25:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n1ltugaL;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793237117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/AMFbjA9JAsBdCFWz1LANgAn0knNna+7jo0zCTOlPs=;
	b=x+1Zb/OjlTgHBv+0ljZ7QMaG4AMRUbvZWhWEEaII7eDDpXRuBVrdsnfW64adu2RuUJIZKH
	d/COx+e52SCojnTn7pek5fzdFh37g16urD87n9YiiotfUzp2eWzaodQCBwpSNfks5a4Y1M
	zMxa2vqA9OmwKH+ph1WK/L0P0uMHqZs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n1ltugaL;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.208.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793237117;
	b=VOiATgXhE8/Kc6z4yLjlkofQU0ZgwuDfvE3bcymqwT7HMdZxRkG6WCm1kjBeCP8xmpODfZ
	DLUggN78wNKnFXc5zedKxtAcys3igpz7LxVTrkz9h/LxJu7SOGkMxCnnFV/V2jnV5dnHQc
	oa6my+b2iVfkZSXjIYlnt4a4ieUePEQ=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b486e1d02eso2231123a12.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793237116; x=1793841916; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=M/AMFbjA9JAsBdCFWz1LANgAn0knNna+7jo0zCTOlPs=;
        b=n1ltugaLhCVtYQ/z6hDfLDA4oNtLuA7CpI1k3tjwDtvaYl5a5P13vLFGGb+gbJuBOC
         Ss1D/2chfu68Unh94dMOODmYutnsWPbNyQ8Gxxcoh/ghUZmy8DDcqJfWUdFvd8nwHNwR
         IgtksTarndWlHK83RgpqVxCKU6636+U4u0jufLsoKKnYcrdnIa1iIi9vtsftvP3xGbqw
         lYISbOFCf8UJp1g0WsPgW/z5Yj+6ufBSIgrWZQSTNUkZ2fKEMkcFGRabHS6Bu8VrJmyj
         vvzrWQJ15JqvrwSSaYuFKnbyiaa9J29eifqesSYaKOIELmS8URkW3wdybokUInaOVuOj
         4DUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793237116; x=1793841916;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M/AMFbjA9JAsBdCFWz1LANgAn0knNna+7jo0zCTOlPs=;
        b=rblzq1TYRC2eAkitGYJo6YyVmLn0m/M/ngKlCnKSJ8E3JNDvJrHMUspdnfYJ14O2LF
         omiVbi4qmKKtCm8iJXkehKXGpSR/L78RJN8+fKBijrN7seL82t7nD+G+/SBrzrM7nYph
         sjYwn5E5NjveVD+v6HFmPs3HnBPznpsHjQYlVvSsazt2FXTCAPLh9aCUTCgN/rXbZxf/
         VWRbqp9QxCEPLsOrIIZSPj2l6O8EjmveOVq9ank9jKljR5p4Vrk2GtcYg+gYacEKIbB7
         V+vM6TW9/sIvBY7WDtaJ7TezdvDz25OPoIb+xeO3M/Tg6PvWzheAhE9W7L5DsnQYrCxr
         dEdw==
X-Forwarded-Encrypted: i=1; AKwUvByQlwe/ILg42527IATFniCUKkYq+ZrKJOiV95zpBTp5suA80/RmmqWg1SS0CA2/5b/aoGWBctLnTA==@kvack.org
X-Gm-Message-State: AFq9FYLmN7giBKk3J5HGzfHVbVzlpiaTSnYDtxun58CVp4gWHKhLAvRR
	kF2Er+uMEnmp9doQzz0Lrod1JHal6tnSiVfF4BxlKw6Lhl0SLpZ/S/p5DdUYahPqxRY=
X-Gm-Gg: AYBFou2RzD21yj3lzif3axcyNbfB4EIuryF/5P+H38Oh8sYxJ5UzTNEvdlfWNcLW0mX
	Fd4tQ5HCnDK1V/hvu5GPt7WjztEGiUwQIzSgvAufp/eOZAK31RvXPXV/xdAKYx2Z1u/N0HwCcZ7
	om+w9kn1a3Chi619RY/HC/S6uiI7B9PRZAR+/6u44nRE+RN/Vx4FqpGN//DapcongmoiwyrpHWv
	xeDuUw6scNUBiu/+L1LNJgvDWcaVxgUim2Qi9FwjZM/xqDZWKZBZaPcdVV9ygXVIu8uwHuMPeTH
	MQ2f+Tozlgb2hWsxf8mAbfccSrlo9HKfwrMX4eRl2AI3+CQHxzwwEKgt/1PfaDXtxHBbDNGIs9N
	epea1pheqaBawkTi8m2xVS67FB1WYBbNrZ0PaF3IZTfUyaMm4c5KIW+cxct4+QfBYLSZ3ttiSzB
	VSMLtnNAQcxrk+82YEKF19wSG4W/FS8+/LRJOgd3/rr4Y+61ZrwnKw4oFhBicfTopESa1Awfq52
	cS5+mxg0E8xt19BFU8Mk5RoAwRIlu3dibgeYFjuvAHCCsMsHm5By3Yc321feGNyq5K80U0M8uej
	SKxmxWM/cxq8Lle5ECbufAD3Iw78Q9GL8pesOidAYg==
X-Received: by 2002:a05:6402:234a:b0:6b4:7b28:8588 with SMTP id 4fb4d7f45d1cf-6b49cb5a33dmr2836967a12.2.1793237116591;
        Wed, 28 Oct 2026 18:25:16 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:7d::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b49644bcd7sm2122970a12.33.2026.10.28.18.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 18:25:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 16/46] mm/khugepaged: fix PMD table lock leak in
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
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261027-fixes_core-v1-16-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-16-6f74bec9a5bb@kernel.org>
Date: Wed, 28 Oct 2026 18:25:13 -0700
Message-Id: <179323711320.453251.11778195785979033843.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8B24A0003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: uk4g5etpmzsayfu1nnz4759gpdq1154x
X-HE-Tag: 1793237117-684782
X-HE-Meta: U2FsdGVkX1+JiPYv1ggQT1m77FnBCL+JOMObAQvAIXq8ORHMELojADU67zg65PgPycsra8/kv1Z0AolbWAeRgxwwbkdlhAjhcau1P9Q8dXsBsCf12TMHOlY/Op5FTcK5hjQEO0VBB5jAwulYp7UX27wwKy4YAxVnQM+Rniv5yEnSqEpw9IIpmfnb6GZ/tHBm3YX+BnyKx0oBqNfRzmDABEP4kU0b+1DTDpypxc5FgyHOnGg/xEdNYF3YB4u/x3HvpHh5VZkjdHykEbRnuLqm3Vka6AFHr8CgS3HTjMirH9eBtNay8LP7ZGroM7IBWH/LPBDBA8+PkyK3s5y4KJbHmU09FbfSJVe80tSG12tAaha5SLN5zn2oO9P3TpJ2wBAH2uHgcfeEpK/9n0diE9t6u8QBIArm3S0ZtjF9quQLA8X0aADG8KXi4WbHjlosiPCMcNcNJnWI38hyaXVOYUxsCOIYXftS9mjqwdaSXRWLeN8aXMiJaBApT1/46XPrEv63rLADUbKihik6P5fY0d6b9ol2IBvEJO6/GguoOGmJtKxDAm1NLH4fKr35rZRdecgrK4Ca4Zp/DsmgHXv44grG9jDvXreTdqn2hStDOZ+145QWQyDXAz56IRsxTLoPIAHtFqpEW/pPayEUG9t38keeMEXBAgifMGKuUzpjfwHIeYJuEVJwi/jy+KlWFeKUZ6RvDXs7n2t9RpjVZOYtcP7gVu0Ud81hj8OpkRDuWiYNmg7SGu7Z5iYMtUUrtA6zWQfrU57bahCtlRud2SgmqHSXOooAvMbshXkz+lTiArzJKC5Iw7qtg5rANxcHXZK83wTD6mG+/E0slA2VWCjJQN7zJzHl31muLGL8yMa4gRZAfWhyh6skIsD5nxqI51x76QA+Akj4ikWNVaG9dc+f/sO92RP7FArh+TGfa0MAI6g5D8hF40SBNMP22JFmPgbiyDFaQI+RLl+pxjJKPcixVfl
 CkEAetUP
 AAuorscgxN0X08dVDE7CMbQvN+3c64n5CAVuo1wv0p4EA+B1h24kMvDEjg0OHBJgODNKTWO9hORRZY6wMd6cvt+Vpxi403lvy9lYWycMMt2Kac7ApzrZi1FqewwlvnPjRifypQ1CngFrO1d21tGDUCTq0fpRv2ZIlO4lIVBWyUOYmnGuw9ufJAyOSCiFIHUFlF/jAPAZKy1sdaosFSnWg3OK6wJJkoIXKeIRhK1HYJGAdcLxHnB49A+3KKNGrP3i4wgX9u1bMPdgn0NgWkVdNUiCF7GFy9YV02cywDxNaUGyBUVro2JdttDJBZpfMd9Q2wL78kE62E4dQ2F6H22Nl4+lZfBlzLGfid8qBUpltBgLSbsDnevpYwogkRGH9QRf16XZfIMXemwpPvpjBtBKD+AvFSHZFY2i7Q5u9JcTne9vEMau0tf9pP7pJk4/1iVB1C05fLhd5NLeK3qiaXijFzc33esA/71xS5CiBfK6o/ejiIpPiG1Y3UeMNNyHBy5y0oqfkZyrDkYeGnDz0K037PG9ch78SQhE+9qFlI3e60SQGOZMG7L25b6wYx4CG05G4wlLy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> For a private mapping with userfaultfd, try_collapse_pte_mapped_thp()
> takes the PMD table lock before it maps the page table for the second time.
> If that (pte_offset_map_rw_nolock) fails, because the page table vanished
> in the meantime due to concurrent page table reclaim, it leaves through
> the abort label, where the PMD table lock is unlocked if it differs from
> PTE table lock.
> 
> In case the PMD table lock and the PTE table lock match, which is the
> case without CONFIG_SPLIT_PTE_PTLOCKS after pte_offset_map_rw_nolock()
> failed, we miss to unlock the PMD table.
> 
> To fix it, forget the PTE table lock when we unmap+unlock the PTE table.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: move the ptl = NULL handling; rewrite description, drop wrong comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
Gregory Price (Meta) <gourry@gourry.net>

