Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF83BCA5FAD
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 22:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0066B0088; Tue, 29 Sep 2026 18:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B609E6B008A; Tue, 29 Sep 2026 18:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76B56B008C; Tue, 29 Sep 2026 18:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4E86B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 18:46:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09D5C1A0352
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:46:01 +0000 (UTC)
X-FDA: 85268284122.27.0DE8FDC
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4067E140004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:45:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nctD0v4y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790721959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJpn1LLVw4O01H0xs9gRR2we3Er9QCOaDBy2tAq0mzk=;
	b=kcxvt8BHFQBxmZJB6684+yuSbeaTmZzy8xxzYo1XS98O4KpIvEE6TjFulNU0ZcWQoK6X5y
	nA0xssjOIAzuIjvlE247PL5z8UkZjBDJbU7TIao4p9v8h32cQbQCA9VgBMoaORhIgvo0S6
	DzihthRxkPKwXh181SSfK3eADB4Ykss=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nctD0v4y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790721959;
	b=ZT+43M8Ix3+R2g4FtXTPwcTFUbrJYa7nNibb4uDLwsKZNynpz/5jiwT8TkeBWC+O3gsEv3
	h2KK62mm7upqaeLyWWxr6S6b1qiQvcyu1Bo73/Wrl9pcMka17dLVSTBhNAkUMTGdArtwoY
	sGz9G9FNFKgorTDWstcMgFVFmweh5c4=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f01363so27784375ad.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790721958; x=1791326758; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KJpn1LLVw4O01H0xs9gRR2we3Er9QCOaDBy2tAq0mzk=;
        b=nctD0v4ye5PGazmagLVRHBV+W3zBxT7TpEXJfZ0+l0bK58J4JoA3QMFR6bzLdRjMGt
         mXYjL0uW9utevJ0rqzsYOGg9LXCOGDaDRgudCNO4W+H145b2KLdB4ujGBIi6mPLp+rTb
         TfZPaVtjJ3i3u+sBo4Jq+bnUGy9oDlh0NggJF8v6aqZX3WrzFT+tWWqE+mAnhALse18B
         Tp30nNMR7ANLZSuZGpLvmBgOeoPlQ9AD8B6NOFc8mf1xVvyLIHcChosQS9ICltjjOE1Q
         eVsUslmh7IwjLqToS6MkeGC0QEezHWOgbqbUeB5Nv8VRKVwgAmcJPKTB2recITLhMtIR
         59cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790721958; x=1791326758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KJpn1LLVw4O01H0xs9gRR2we3Er9QCOaDBy2tAq0mzk=;
        b=GB0GSQN2l+RrsD86O7w/kwgLznpi9+bkuAMKDl/L7ZyhlZVn7IsaW4EiEPH52sMR3+
         Yx+n0e7qGk4G9mEruEVEAJPQM/ceu6xoCMUawu1e8LFKxIy6fW9IhMuAYSLtoUwDUSUv
         bna0AL6z+ZZvRmGbF9xNDxu5WAEyYEYcq9teUiDFEyvfs6+Xpw8R7HwJ0/e1W1RJB3js
         SUZzgDzvz4W75P63xuGIExLnhjtfYFLS9070m0YDtYWaRNDQ/Hr913ArsVQmq37fgb6+
         pRQc2sY/pYUppiJcnIfUgdl5WK+2G+4LJGtPUPbTkEwBI10EboKsD8Nu/M/HQr9Zl+z+
         EEZw==
X-Forwarded-Encrypted: i=1; AKwUvBxMVl3Nv7CDE0JAMZy/e3MRM6Ht/EAha+aW7XTftom+ps4fmOgW9UPyRHJaFsfEmizklBDsegdFIQ==@kvack.org
X-Gm-Message-State: AFq9FYKvl0VfXVoilm/L95rRju9AB3jp/IDa8Jhs/PSs/Fk4UUlpLVft
	LQ6v5ocCUwAxLeTlipd7vuQRWrPXHjO0UeHIcgxETZWZwe84mWn/Scqy
X-Gm-Gg: AYBFou1HYf0/cXtd8BprnhaM3JYfhwueqP9GPSQJzuh5ip73qlnkIxHL+oYjy29VbS9
	CAP0ZJhvtx454Zhx2rjdd3n3fFUjYpjuojw/J0rzYEESFi0ZZLh9GdnD3kMg+uUvhP0Qb3CpDNO
	iMNPehQu87Bvc6BhYkd/YTeCvi+CW1TpSE+LaX8Zkf25GBMVkLsAcC+7SPGbwKwc1WVre5YkBGH
	2KBKCTPnmvBYVsGpgm4y8/P7n/tw7PbcZ9e/X36HNQjLD8KzFIqekNRCfRFbdqnMZ4qLdwOx5h7
	ZogLyI+g+fatbjr2xy37QqlnvvVnyurmXbt6ns0meXFF6x5NQCm1qTa4UeJOFk5r9U1uXyoqoo0
	IDCqcHPqjFyfCRGQ3FnSOSF4Up+PhmGNYFksWE6SEXrwTxJ8iQnUWDE4LaLQspdIWrgdDR7O42L
	TWCuP5oaYwgBQMkzHij3R7l3dz3hLdpG3AU4h7mnytJGJLqSTQvKW/tuTwlk/k/r1Q8erNF901x
	C7LNhBZm1uoE6uSIvdGw55qWqUPyzGMyWPvzGW61ZYDSHekgUgzgPzVARBluqVzmTrHWue9PgOf
	GmQ1UUh/jNgMD7aM1m5b
X-Received: by 2002:a17:903:3847:b0:2d9:2149:57c0 with SMTP id d9443c01a7336-2e2de5278dcmr4178115ad.22.1790721957951;
        Tue, 29 Sep 2026 15:45:57 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-241-4.dynamic-ip.hinet.net. [36.232.241.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e2dd859988sm1759625ad.61.2026.09.29.15.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 15:45:57 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/memory: reuse 16 PTEs of an exclusive large folio on a write fault
Date: Wed, 30 Sep 2026 06:45:52 +0800
Message-ID: <20260929224552.467-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <82738d2b-9c2c-474e-b90a-60a1140b5bd6@kernel.org>
References: <82738d2b-9c2c-474e-b90a-60a1140b5bd6@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4067E140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: hu3yjqdnjngtfmj7uots8qumkf4hecm1
X-HE-Tag: 1790721959-838757
X-HE-Meta: U2FsdGVkX1/a0Q1+dDehFeUaX6o2Pl6C3yOZCJFUiYUu/DA2vAG5z0ZFInUGsidono/PEEqnXN2Vk73td56WQHNAOETSbu+CE7GzPGo/5kVMdYZOuLNWk2zRldmcdJ0RtQ4q8gp6Zu7btshJr6z5nByJPjtftFt30CFRmlpD1p46qzX+zDn4EEklfXePoLHIwmUGj9kcBWsOFGX2xhqVb157La5DYoN5GEcirmrAG1ZP9TLNuWwfaewm68LouFvQw6ni5mzL3+2NoEw1g1JyDL+5/Yn/FdhF9YVQNm51pn+i+PQQlsqzhP49aGwkk4P/iUC9yCBXPa7Ps0mCu28p4FUpTUQ15H3cNvKH0pe5mlW8km7sL6hBLfEJrN3EK4NAb/hHHOPMuWs65X7cd7/h6Kbod2XeuHfIoYJUDwZocYyeW2o82QO4K4IZkoCRBwaMkHSf0GVIYVdrWMbVoXM2iSIhpsKTggBhWxDXQbwldr70EAgIsuOR7y6cEjbPPdYsldODSlixZsserGIC2agrtJ5tIhPpLdpl3ylKhmEhSEqx8ADm8pbDet45cOQaS6PHkEGpFNtKh/dpt4mxnVq86VvJuMpSKfRnWQdIWc1xO28s84p8VFWb92FWMAybgbdrM5hNHnABcg8N8t8uW0llq2SGQKULLdKUaBPIKbwdmjWG/DGg+mEnrg6h+8UmJkzUP5PA8XhiTJ2Sch3Ah1DPNAdO6TTk/QAATPPccxF+Jpm1RCuH+M9aXIupoCKYE9WocthMRr8ucRHQiGkw7tACV7CjQ48FCVQkhrgLpCg8DTDxl1xs7F4oB0AIA0S6tLVv1uT6PgXdLup5KAeiO8zn+aAvSoyGG1z5PFPc6EFGFX8hHamLRmh+0lUTxceuW43UjrPEgorPsMDvRlhRdo5d42Yrj5t4YJzEvs+AaB6773fh7Z2755gnRhf4Hb4RoHrTv5uU9wdy1O3XBRn0eHf
 iaJyLFD2
 vOKdFQ9tpKVZdqJuQk3l9HDoo+H9UtGz6FN+tflF6gb/H4z1ttYaQFf/NS3WT3hDLUZHKFol3Od5chJhcpJGwFGXSxmoe6ywApbZLOphde0hSehICo6v/rh1RXB7ILTaZQHZIRvW3pg4NshN8Bj4F1VIx0MpY1OvmHl3HxcOrQvXL0IfgTTo6ELfW50T2KA+gyLcu5KGkroPz4CxYjAEXMztg9U5Wk2B+DQNF3/L/ozW43bKsX3qaUvD0G+ZMPBME2D3CwVgZQCcNPHTBI7xwq9y0h9JEpOD4TvyAUSvL36GzTNzLo9k3rrCTkQ5JkHVIB/XY+hS4zuQmoI+fbb5UnPfOi4OiQt9Jknm/0PuPS4/AzVAcfYLzxbZqAWXhu2tnptLW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 24 Sep 2026 20:46:06 +0200, David Hildenbrand (Arm) wrote:
> The patch needs work. I disagree with various decisions
> either you or the LLM came up with like
[...]
> I tried to see how to implement it cleaner. I think we should definitely
> start with:
[...]
> Entirely untested:

Thanks for writing it out.  I took your two patches as they are, on
238650ef6c7c, and ran them through what I had for v1/v2.  Nothing
broke:

- builds on x86-64, arm64 4K/16K/64K, i386 (+PAE), x86 without THP,
  arm, arm nommu, riscv64, powerpc64le, s390x; sparse and W=1 clean
- DEBUG_VM + DEBUG_VM_PGTABLE + PROVE_LOCKING + PAGE_TABLE_CHECK_ENFORCED,
  with the mm selftests, my 12 COW scenarios (vmsplice, PROT_READ VMA
  inside the folio, soft-dirty/uffd-wp counts, mremap, holes, pageout,
  FOLL_FORCE) and a fork/pageout/mprotect/vmsplice stress: no warnings
- arm64 under QEMU: 64K folios go from 8,200 to 520 faults per pass,
  contpte_convert() from 512 to 0, and contpte_ptep_set_access_flags()
  from 512 to 0
- x86-64 (i7-12700KF): same fault counts and pass times as my 16-PTE
  version; the fault that handles the block takes 720-730 ns instead
  of 740-750
- Redis on 64K mTHP (BGSAVE, then 1M SETs): faults 262,100 -> 18,900,
  CPU 1.53 -> 1.38 s, 640k -> 715k req/s; THP-off control unchanged

> * Hardcoding WP_REUSE_MAX_NR_PTES, likely should be determine differently.

Same patch, only the constant changed; 256 MiB of PTE-mapped 2M
folios after fork() + child exit:

  WP_REUSE_MAX_NR_PTES          16     32     64    128    512
  one byte per page (seq)
    faults                   4,161  2,113  1,089    577    193
    ms                         5.6    4.7    4.2    4.1    3.9
  one byte per page, random    7.0    6.0    5.4    5.2    5.0
  one store per 64K            3.2    2.3    1.9    1.7    1.6
  one store per 2M: the fault
    that walks the block (us)  0.84   1.13   1.71   3.01  10.32

So roughly 0.35 us per block plus 20 ns per PTE, and the gain is flat
from 64 on.  For where the number could come from: arm64's CONT_PTES
is 16/128/32 for 4K/16K/64K pages, and fault_around_pages defaults to
64K worth, which is 16 on 4K pages but 4 and 1 on the larger ones.  An
arch-overridable default of 16, with arm64 using CONT_PTES, would fit
the numbers.  Your call.

> * Marking all 16 PTEs young+dirty. It's somewhat the same thing as we do in
>   map_anon_folio_pte_pf(). On arm64 it's already fuzzy with cont-pte. With
>   transparent coalescing we'd actually allow it directly. So it does feel like the right thing.

I think it's right, and for a simpler reason: nothing looks at young
or dirty per PTE within a folio.  try_to_unmap_one() marks the folio
dirty from the merged pteval of the batch, ttu_anon_lazyfree_folio()
checks folio_test_dirty(), folio_referenced_one() adds the young bits
up.  The faulting PTE is young+dirty anyway, so the other 15 can't
change any decision.  I tried the most sensitive case I could think
of, a MADV_FREE'd folio with one store per folio after fork(): two
MADV_PAGEOUT passes keep and swap the whole 64K/2M folio on today's
kernel exactly as with your patch.

> I also wonder whether some part of the function could be factored out as helpers for
> other code to use in the future. I also suspect that there are more cleanups to be had.

One candidate: numa_rebuild_large_mapping() does the same
folio/VMA/page-table bounded walk by hand, so a "batch around this
PTE within the folio" helper could serve both.

Thanks,
Yuan-Hao

