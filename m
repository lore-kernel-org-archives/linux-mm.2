Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AACE1CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE596B00BD; Fri, 22 May 2026 11:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88606B00BE; Fri, 22 May 2026 11:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D293A6B00BF; Fri, 22 May 2026 11:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC3D86B00BD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:07:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90BE31C12DF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:07:08 +0000 (UTC)
X-FDA: 84795383736.03.EC2D88B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3DF89180007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:07:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a/fsvzmJ";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8vDvm5iESvVgdUD7id3MqbrPnPABwU+5C7h6hrTleA=;
	b=I1vowlOoEEQkHySIwv3Sx2jh1xzJqdlZBAydmtE8a1Guqza4PV/C/EZ38Q/gBYf0BDXtMz
	X7htrZ6ItKF2dd7CgaDRmZs8BjUaqs5Vk6/z/r8nqdzRtpEqmAS0/P0KKLD/CBV1sEgtMd
	blrRwSg3bjYMXCTH9/e55ufHZDQlFUw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="a/fsvzmJ";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462426; a=rsa-sha256;
	cv=none;
	b=q5+0awOpGvJ/vEe5SIPEM9CASMTtcy8ZokilDjJ7S+HY+Oc7sf4kOTYwwV7cr/sqzKruBR
	Ya4vG+ZvnYcTljeATgZSfXn5+LPvMl1XcWA3eJNA0eYovyi+FGrk/TDUnhhKsW5J3d1O8r
	2iA1MJm+WYdZdfatM/hRwdJR5Zn6mtY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779462425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C8vDvm5iESvVgdUD7id3MqbrPnPABwU+5C7h6hrTleA=;
	b=a/fsvzmJOsas6n3uROA/M1tBCwn/mwMOL0UvK7WA6XyvOO58SJg8RvN716zlV80OYrakcX
	zrAzrUe0EeChc29kfzJahqC3kbdwCDoAIWLkxha5YEuCdc1Qsw1TJLSPqV+gdRb3IHT03Y
	HA2x106H1bl/Pn/zawvo88ijn++Dy9g=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-P_jf0F-XOlS1lf73NRBp3Q-1; Fri, 22 May 2026 11:07:04 -0400
X-MC-Unique: P_jf0F-XOlS1lf73NRBp3Q-1
X-Mimecast-MFC-AGG-ID: P_jf0F-XOlS1lf73NRBp3Q_1779462423
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65c7306e432so677073d50.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 08:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779462423; x=1780067223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C8vDvm5iESvVgdUD7id3MqbrPnPABwU+5C7h6hrTleA=;
        b=XPrXSoKbaUcH/kLr44z2TUnF2dl5hP7+jwskE7DrEoY0PikJya3w1HMAdbBZ9rHE6p
         wykKmU5/9cmW2adCi06dD/m3byRN7WV4MIBLWt59/WkWbS9XKISvysq3YDNy/ygAfSvT
         n0I8hPOrb5sgIDIKdMLSpNKRLJWVtZNe1/RzuUBXMoScG3ZpHS/C2gQatq0MASYF3ERx
         04ng4xAXpIYhYLo0pGlyKWIDrVimruJl0x5ap4kTuc1B3FxIN9gMcuweJbs2DGG17VBy
         sT3CtHVR/fo1aA+fZ2Vv2yXvF9orbyu/hj+dadiZnvAa7urvW8rSOZXWMGNMjcQ+wPel
         AfTw==
X-Forwarded-Encrypted: i=1; AFNElJ8KMyBVnewbX+24Lzev8RLixuA57YggobAnytIFVpXatMoQFAlo3sDQdshNMUJemxOX5KUjtZzsLQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5o0RDI4YPAlvndfJMiFMGYuPs62xpvDYZWtXi5Y7YjvAqKw9f
	I+Oaf4XOUq6CHYbJDihDRsLFfxmOdyS13aFvVOKc+8kDpQehNuXcRLtndDUoe4SWUe1OkUOfP7p
	ALd5CgnVO1M7JBC1y5D79l1XihE7BC5EUuFizISW/cbhEFA7zSD2fL3VYZ6Uutgi2KGXub//z4p
	QEHwYsXAvi/75k1JTgTJdAElFWb9o=
X-Gm-Gg: Acq92OHkZb4uMgLiCLyCO4EMHJzgXj0k8Nc7jayyj96ZqKSkGTlWlhxfQwcKgc9oVLa
	J0SR422rAFiPxV45EqK+ChhovvYNNZlPlPtg8EQaxW0uzOBDkCH7vPn4ImvMQkm4kvQ950ZPDL/
	NwUA6Dhe4GlyJ+8BTzRMeOBVkaOEMU11rUND2s8OjmKl+Xbk0tgnCmjXdhnWETXBzyLTlw7Te/j
	tdf6g==
X-Received: by 2002:a53:cc4f:0:b0:65d:6eed:4a48 with SMTP id 956f58d0204a3-65ec98043f0mr3360983d50.28.1779462421542;
        Fri, 22 May 2026 08:07:01 -0700 (PDT)
X-Received: by 2002:a53:cc4f:0:b0:65d:6eed:4a48 with SMTP id
 956f58d0204a3-65ec98043f0mr3360911d50.28.1779462420768; Fri, 22 May 2026
 08:07:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260522150009.121603-1-npache@redhat.com>
In-Reply-To: <20260522150009.121603-1-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Fri, 22 May 2026 09:07:29 -0600
X-Gm-Features: AVHnY4J5qmdjKp5TI3UGWiO02TMrdukroSBQHh9ZQnZ42zy9Br5VFR_OymGl7kk
Message-ID: <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
To: linux-doc@vger.kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _lnKhxCMxrOciG4iz8c277ZPj6yJWIC5cBGMe1UA6FI_1779462423
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3DF89180007
X-Stat-Signature: 31sqxciz5h3myirdybxu6737isiprrrk
X-Rspam-User: 
X-HE-Tag: 1779462426-119942
X-HE-Meta: U2FsdGVkX19E49xWpxJoSq20fkKisCtA62m739VC+rVbgvSWvuM+gxlUB1QG57z3PNZ4xzin/H3+HtSBQhMIin8VfY/odJ+AOZJAvy+ry+IMlwDc28aUOCI8Q+LksJ6QwdkOD0Lbpe8WaCPaq19oN60G0H6jdAI62SUe64W+2jGRgMY0oA/hKo9pupSp1f8nvBj6gE0+TrtryL8SFgdTvWkN9yuVWj3zw19gCnLV8IhQmksIsUjSYS5ZVKiKZxqlAA7q4aQdyIxBmU1bX1qPHPmbeW9UDfgPmIXrqjNUINombLndkxgDJ3BJQJ0L/jEYkKJ8UMo1uZUjvCbegH+IhFELRxQqxP5towWBy7LVTi3oXyQIZuh8FYEsYtVEB8eiR6j/D54ag3bh5PkQAV45GcjrXA/z5oh5ioVpPV5NCzwCtd235TLyZKr8gx59MErEIBRhyV1oSFu7DYSL/yfFsB1ygehnDyQgp+b0rH/O4R/4MeCPSLw64zx5O8KgaJoiOOc+3vvdc3HpqZSnduyOUfwZS7JANlYC13jqLka50qw5nspDsWX9ZUq6wXiu49MzU+tC4JjH2/OHz3v7vbu0/3QCyYsWxaKghsw/F2JQhZlHffS8v/ZoUmtPauLlxkspnTMEVMc1l9t6HAIMkb5B6Qx6TUo//QbGciqO55+ANcqHhQNb8SsbmOwT+OlXQH5kf6ZOKTQyJWnpOlw3mXldKrQOIp7F12zEKMxsxcK/pOTd1levOKzg4YeghbwEBsmaFsULAORqNvgBXqC1esRyDULX7UOsdXRLaUHbA3n7xXzULGaZyoQl2I5MHV10TDX3jbuIdMpV6E+40vWRuJPYmB7rC+LZ7h1ZAvhcmmSzkdnV45UFoaGHB6+ZNRllGk/nB9bjoK0CaVoShc2cmQEjTV835zqO32HFWM3gjtu1wvVhOgqkELPee25L3DfpjB4mD7W3BUH4GqkWj9Kker0
 9GknNJja
 G3p0EkmGf9BPxBYsC1IG2494ma4Q7p+xkX7lVgCXONWzDcVMmWvPfM4Kd7d7iWVt47UYFlDSv49rtdiVoh0AyZT3lU7D+ObGYnGGgiV9xN1/6MyOr8xNLCDI4aduPscymRQzxMzg5SKPEKBYRRT67j1J11qU7qGyIwSRgUg7ko6dESn/HEkMtKLu7ZiWlzFevZaYCCnRpDt8GmaL9oLVEOfzubDy/MdCOypZ5ba1HYHWqLaXsv8K1jqBGcMH+WoaHpBCEhI7WdpJNtKrJiwanI6hkOE5KxT1qkVhG8xD/xEWb+djBrnqLxFSBfWMvxTo63WiMuTcnvf4E2292Fahg7FAjUBVsVy6lSFxmQmoA+hsPPXODlo59djMSiWU5jAamrMlvkTgGMPFaJwUaiyMeW+1DiESx972Hb/PXrG1YhGj/FakcavnIbjOg7cbLE2KEM6Rs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 8:59=E2=80=AFAM Nico Pache <npache@redhat.com> wrot=
e:
>
> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.
>
> To achieve this we generalize the khugepaged functions to no longer depen=
d
> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individu=
al
> pages that are occupied (!none/zero). After the PMD scan is done, we use
> the bitmap to find the optimal mTHP sizes for the PMD range. The
> restriction on max_ptes_none is removed during the scan, to make sure we
> account for the whole PMD range in the bitmap. When no mTHP size is
> enabled, the legacy behavior of khugepaged is maintained.
>
> We currently only support max_ptes_none values of 0 or HPAGE_PMD_NR - 1
> (ie 511). If any other value is specified, the kernel will emit a warning
> and mTHP collapse will default to max_ptes_none=3D0. If a mTHP collapse i=
s
> attempted, but contains swapped out, or shared pages, we don't perform
> the collapse.
> It is now also possible to collapse to mTHPs without requiring the PMD TH=
P
> size to be enabled. These limitations are to prevent collapse "creep"
> behavior. This prevents constantly promoting mTHPs to the next available
> size, which would occur because a collapse introduces more non-zero pages
> that would satisfy the promotion condition on subsequent scans.
>
> Patch 1-2:   Generalize hugepage_vma_revalidate and alloc_charge_folio
>              for arbitrary orders.
> Patch 3:     Rework max_ptes_* handling into helper functions
> Patch 4:     Generalize __collapse_huge_page_* for mTHP support
> Patch 5:     Require collapse_huge_page to enter/exit with the lock dropp=
ed
> Patch 6:     Generalize collapse_huge_page for mTHP collapse
> Patch 7:     Skip collapsing mTHP to smaller orders
> Patch 8-9:   Add per-order mTHP statistics and tracepoints
> Patch 10:    Introduce collapse_allowable_orders helper function
> Patch 11-13: Introduce bitmap and mTHP collapse support, fully enabled
> Patch 14:    Documentation
>
> Testing:
> - Built for x86_64, aarch64, ppc64le, and s390x
> - ran all arches on test suites provided by the kernel-tests project
> - internal testing suites: functional testing and performance testing
> - selftests mm
> - I created a test script that I used to push khugepaged to its limits
>    while monitoring a number of stats and tracepoints. The code is
>    available here[1] (Run in legacy mode for these changes and set mthp
>    sizes to inherit)
>    The summary from my testings was that there was no significant
>    regression noticed through this test. In some cases my changes had
>    better collapse latencies, and was able to scan more pages in the same
>    amount of time/work, but for the most part the results were consistent=
.
> - redis testing. I did some testing with these changes along with my defe=
r
>   changes (see followup [2] post for more details). We've decided to get
>   the mTHP changes merged first before attempting the defer series.
> - some basic testing on 64k page size.
> - lots of general use.
>
> [1] - https://gitlab.com/npache/khugepaged_mthp_test
> [2] - https://lore.kernel.org/lkml/20250515033857.132535-1-npache@redhat.=
com/
>
> V18 Changes:
> - Added RBs/Acks
> - [patch 02] Guard count_memcg_folio_events with is_pmd_order() to keep
>   THP_COLLAPSE_ALLOC PMD-only (Usama, Lance)
> - [patch 03] Convert C++ comments to C-style; fix "none-page" terminology
>   to "empty PTEs or PTEs mapping the shared zeropage"; drop unnecessary
>   userfaultfd comment; add const to local max_ptes_* variables; fix
>   "repect" typo (Lance, David)
> - [patch 04] collapse_max_ptes_none() now returns 0 instead of -EINVAL fo=
r
>   unsupported values; remove SCAN_INVALID_PTES_NONE; change return type
>   from int to unsigned int and propagate to all callers; add comment abov=
e
>   __collapse_huge_page_swapin explaining mTHP swap bail-out (David,
>   Lorenzo, Lance, Wei Yang, Usama)
> - [patch 05] Rewrite collapse_huge_page lock comment to David's suggested
>   wording (David)
> - [patch 11] Propagate unsigned int return type for max_ptes_none; remove
>   the now-unnecessary negative return check (consequence of patch 04);
>   Add optimization to the next_order goto that will prevent unnecessary
>   iterations if there are no lower orders enabled (Vernon); update lockin=
g
>   comment; pass VMA to mthp_collapse to improve uffd-armed detection, and
>   prevent unnecessary work. (Wei)
> - [patch 14] Update documentation to reflect fallback-to-0 behavior
>
> V17: https://lore.kernel.org/all/20260511185817.686831-1-npache@redhat.co=
m
> V16: https://lore.kernel.org/all/20260419185750.260784-1-npache@redhat.co=
m
> V15: https://lore.kernel.org/all/20260226031741.230674-1-npache@redhat.co=
m
> V14: https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.co=
m
> V13: https://lore.kernel.org/all/20251201174627.23295-1-npache@redhat.com
> V12: https://lore.kernel.org/all/20251022183717.70829-1-npache@redhat.com
> V11: https://lore.kernel.org/all/20250912032810.197475-1-npache@redhat.co=
m
> V10: https://lore.kernel.org/all/20250819134205.622806-1-npache@redhat.co=
m
> V9 : https://lore.kernel.org/all/20250714003207.113275-1-npache@redhat.co=
m
> V8 : https://lore.kernel.org/all/20250702055742.102808-1-npache@redhat.co=
m
> V7 : https://lore.kernel.org/all/20250515032226.128900-1-npache@redhat.co=
m
> V6 : https://lore.kernel.org/all/20250515030312.125567-1-npache@redhat.co=
m
> V5 : https://lore.kernel.org/all/20250428181218.85925-1-npache@redhat.com
> V4 : https://lore.kernel.org/all/20250417000238.74567-1-npache@redhat.com
> V3 : https://lore.kernel.org/all/20250414220557.35388-1-npache@redhat.com
> V2 : https://lore.kernel.org/all/20250211003028.213461-1-npache@redhat.co=
m
> V1 : https://lore.kernel.org/all/20250108233128.14484-1-npache@redhat.com
>
> Baolin Wang (1):
>   mm/khugepaged: run khugepaged for all orders
>
> Dev Jain (1):
>   mm/khugepaged: generalize alloc_charge_folio()
>
> Nico Pache (12):
>   mm/khugepaged: generalize hugepage_vma_revalidate for mTHP support
>   mm/khugepaged: rework max_ptes_* handling with helper functions
>   mm/khugepaged: generalize __collapse_huge_page_* for mTHP support
>   mm/khugepaged: require collapse_huge_page to enter/exit with the lock
>     dropped
>   mm/khugepaged: generalize collapse_huge_page for mTHP collapse
>   mm/khugepaged: skip collapsing mTHP to smaller orders
>   mm/khugepaged: add per-order mTHP collapse failure statistics
>   mm/khugepaged: improve tracepoints for mTHP orders
>   mm/khugepaged: introduce collapse_allowable_orders helper function
>   mm/khugepaged: Introduce mTHP collapse support
>   mm/khugepaged: avoid unnecessary mTHP collapse attempts
>   Documentation: mm: update the admin guide for mTHP collapse
>
>  Documentation/admin-guide/mm/transhuge.rst |  72 ++-
>  include/linux/huge_mm.h                    |   5 +
>  include/trace/events/huge_memory.h         |  34 +-
>  mm/huge_memory.c                           |  11 +
>  mm/khugepaged.c                            | 634 ++++++++++++++++-----
>  5 files changed, 584 insertions(+), 172 deletions(-)
>
>
> base-commit: 6c8cb505a5634594b3ea159fd1c71bce2acf3346

Whoops I manually changed the coverletter subject to reflect that this
in on mm-hotfixes-unstable but never updated the others...

Hopefully that is ok. Just a small mistake. Base commit is referenced here.

-- Nico


> --
> 2.54.0
>


