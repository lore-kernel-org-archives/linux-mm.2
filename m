Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 453E5C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3214F6B00AC; Sat, 19 Sep 2026 03:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8926B00AE; Sat, 19 Sep 2026 03:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212A26B00AF; Sat, 19 Sep 2026 03:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F21896B00AC
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:24:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38513120197
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:24:55 +0000 (UTC)
X-FDA: 85229674950.26.49FF6B4
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6DA5F140003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:24:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8LUeIpp;
	spf=pass (imf09.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789802693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiPpyhYUHVGgWlDeIMWaxS+8sb4pPZWGuCdQapYVZwk=;
	b=fmzexBny+BzMOWqXUljeJgCLnySraVysxha3ldNSN0UAVuNmu8hy0JQJGrumbkdtnENTfH
	91OuJFS9jsAs/fiSLS0Aq5Fyj/QEx49mMjY9WU5/Tt1Bw/pSFZQm5BmhjIj1MKe/oLJ4We
	MAHbppwRQ3b5y0wNN+5tfx11cgAlolk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8LUeIpp;
	spf=pass (imf09.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789802693;
	b=D0yPrRQ1nLBjA/SGkNcKak/9dmKvk95K39eE4mV4RQnF46ugP5a6HAWhJEtarWVSrnOGAu
	JlN7Ik9VBsJr+4rtO1+I0145P8O5orA6a9bfiywI1VPHs3djVoiKTWX21vrPG1Yb157nbV
	xeuSxtMRcE1RK8jZ72/psYmdiqNez8U=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-398a147688bso1532824a91.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789802692; x=1790407492; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MiPpyhYUHVGgWlDeIMWaxS+8sb4pPZWGuCdQapYVZwk=;
        b=Y8LUeIppvMv2fFINiVl0Y7cZxu1kBpUVH+AElL74AnbUCZGkerSKsqcPzdwlowt3Jz
         bIK3uOwtS3Sh82jK5S4Usj/j+GfIHH7LcIXcHKM5ZcY0KRj1qDbKnn6u5N1JEQKGmbbX
         133pSmz+wrFflne29jf0B9cP4lch3rh6KlGJuHwJcot9HDaGPMSPynO/pn9m28HcdpSf
         qbvf4kaxPMmJMxPu2ZulyCjggStKbsRh+NjjnevuwOOb1D31rrGMNdD24nDIxYBvA1t2
         IwoChTA4YAi6gtMpRKOrDbk1Z9nyFzrtTC/QZ8MIlt2ASAcWXe4ETeWkrrJfjHLU34Y8
         /B7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789802692; x=1790407492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MiPpyhYUHVGgWlDeIMWaxS+8sb4pPZWGuCdQapYVZwk=;
        b=1Pyo8yxmr5ABRmYrxIRSzXrbKPwYs30i+ZxiSaozhGXJhvXqmIPGvD37ntJqCvJ55G
         /IMz6CgHURIKGbEyLhgOhaicpCdGusbRpr3xM9yF4V5RiiupNtbP39rS7d4M/svpSWFE
         gGklrdBtdFhugdrEAvn3dTkkT6zikcvOn2/vUtBGhCCebLay1FrVz3G0nOK9PdlaTkNK
         rWPGPGbouboD0SOXXELoLKbiw1M8vCuDaC3W+VVx42fHK9Ps511IBqRaRNvUX0G0Lgqi
         FaRaJPpRBDIT8qR01VrHjx2lZQ8WpohimP0W0s+I4JFQGU9d2nr/bQdcxz5zYsYAemsZ
         MVsQ==
X-Forwarded-Encrypted: i=1; AKwUvBy6oEdLKsRVFYQFI9wTxq1Jr3o/RfWwWi5GucDGzlwkXCnH5XvMFcNYQINBMrYSLntExDFjBIFAUg==@kvack.org
X-Gm-Message-State: AFuF++k6qfuGCk95/2d0R6O/s+gMvuueIhDJbWz5XBTFgAtF+mmHjfMD
	TiZFDS9NFxRrOd64UzOceE9JpBfXXSRKfu/3qdyDPL2AQ097UUKcDz46
X-Gm-Gg: AYBFou1ZiHzUCA8tJ49a4HYM/A68lRrPrx110CeefcAAP2OlY8ivbXVFwfnOUSC8fUr
	jta/2EcY+jVWDgFnnIl0ymGerl2XdlqDm3rmH/Shsr7qZEXt400s55YGHMQeG0W/GIiFqgCCjnP
	QtsBWyZIh2uOkaYZb9/ZBNOieNSHcuGr5R+x2L8sPDIEOlUJjZRYR1WOv1897Fxrash3YzAHGcX
	kxreiY0e39lR7RJPVgL9MvwsWu9QYqYHnkSu5bLZ2r66x/2chXTp77w+9tKkjhthtJ6zYjb9Xv6
	AbuGekx9hSb3KCrzmzZgVPhWd2OtzkCP429JbyuRg+0X6Ae80EOgO+rlOK+S++SEPb8Wo9GEx20
	pGWBIgNI8qSxZGNel3WjBM/niZrhw3IoQiIMuEfMIzJycfRR28uGAxouIvVMOwfMyqE8TL9OePS
	nItF2vrupwoa42ZamVrUxEG4O9CKs7p6rTaBJxMJ1nQ8ELntKi4t3L++rRJs35ZBUc+muAE1+HL
	C+dgPWaCjeJ7Cbvy7AX9kFFykW9mMEzwRU8mG6dk+ebOAary+nG17CJr0ECDcziDNnpPnirGT5x
	XvsoJ2lWRz4nf9rhlsHzCTkz2A==
X-Received: by 2002:a17:90b:5705:b0:39e:2faa:2e83 with SMTP id 98e67ed59e1d1-39e54d1e044mr9225583a91.10.1789802691950;
        Sat, 19 Sep 2026 00:24:51 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-198-121.dynamic-ip.hinet.net. [36.232.198.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6cae997csm3150642a91.11.2026.09.19.00.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:24:51 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory: reuse the whole exclusive large folio on a write fault
Date: Sat, 19 Sep 2026 15:24:45 +0800
Message-ID: <20260919072445.542-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAGsJ_4wTYLds56=iyra5FKmgnNACN9QKJH-XJ=q62G7fMvd9iA@mail.gmail.com>
References: <CAGsJ_4wTYLds56=iyra5FKmgnNACN9QKJH-XJ=q62G7fMvd9iA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DA5F140003
X-Stat-Signature: ii5obybfimt1pq31qexwca1qw9yuaag8
X-Rspam-User: 
X-HE-Tag: 1789802693-191981
X-HE-Meta: U2FsdGVkX19itt3PKiZZ6kTt9QCbTiO4N6x1P9Xnrj8ZW1w14jSO0Afpxb8MEg8dXtAnDePwsjyyNH63e/jrd9zTjoqWRHpNOFPwh0Xnnt/l1WcCWTcZz6/cx/x3YNjejjlRnELildm3E8+0pWNcL37sJwMvaGTJisFq7taU4W5NwefSoRqcCsjy4ipEkjrLEl0u+i+Aa5qmepbU1J3ZAFI415dDZsSKdXZuJE7/BzxCVg1I3dOEygqUSz0vMIE4gv533yNJ8GGFAFATodwZYdePxSy2+jx0FoKv11SeENd61mY3f+5EImb0pj0HJeUzVVVHVk/1JR+Irzb7vK+8NvYuA0/NV7gUiLudZU8FA/iPGkMNkbugnUQjl7uTaHOyCkZc6CUsSaPaa5cbtv+W1VKTLID2NHW/vRmKFvVcWIQkr4QR6d+u4VrDgPwxm2Z61AIzBU4m12KU8wvdVR4Mt+zcX5zWDmsooHkmQBk0x0P2j71BQ6J9iiqp7GeJ8NzaMhVvHvChHKnp4E8f6DOmx1r7j370DGgPND+bmap3EoqJ6SwgZIYfL06A7PA4X2riixsYNvb5OVm21WYvb1BUssePR78iHYBfxkKxj/Q0ECF+RSxAx5xJ15mJ9MWqzm3kp1mODvZS7ubz9x9UKI4wkqj4a419yZODJoWSnXVsJpK8jKcBV1nJ4aJkjmcdvEzVZGi/ilwWnbQSpgxsZoK61iMUj6/EvwF7qB6dzjVm5hpzIZ55EGsbz4DBeeCEZ4FpCuKuK4fH7Tcib9dQWMBbd53XcCXB9afFlRnAbbecGsnvAoRJ4xjHzwC1WKMqrOyPE6wpXsCVinJ4eydRf3u9YSUpsCdc/M6NJ3IaSsNO92zV1s9CuCfRbhiKIihnjBW1v/lB9R63YcLWkiIxRYpHhGOmINuSHJ8ZeM3LYhQuBd9r6mR/roWcQ27PtosvQmSMMHHmnLvQ0Zaq8SBT+e9
 n4i/zLtk
 Azc6HCYrowdVVmgbwcY5rviI5ejJRBkxq4XuA5TkI7axS3s1UTaoFWTiQt5uQgf6UTTlAZRVovYn5oCU61y6tf9ZXeIjBc01jIH93Zxiq8O7Oq5IcSf9ccINWUDQFI1Jeor+zWHmZV87cLLy1SMZ/hLhZ6pQ1rX+Z1pPp2SIlY7y1Vfjc5ReojrS0BoPDl0ysbKMpFOs54dU0tvgxCKTSUyuq9z3t83cru4jl7rGJi99J/OcPYiETQIV5bnXTPaM+LVZGPUzZF2DzRoB77vusJtb/GDE1CDalbrPV1KKSTkwqYecQDVsO6lo8GI+ucIuj3Wr64cYlKI25c4WSZ4adVoVVoWRSgnzdhj4FTpBilufNk/VqXM5PeNh3dmvwlqaaDI2a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 07:48:00 +0800, Barry Song wrote:
> I'm fine with your follow-up work, but I'd appreciate it if you could
> mention the previous work and include the link in your changelog, along
> with an explanation of how you address David's concerns.

Will do in v2.

> I think a major concern is that we may spend too much time scanning
> PTEs to determine whether we can batch them. If we don't support
> CONT-PTE, we may simply scan fewer PTEs; if we do support CONT-PTE, we
> may end up scanning more PTEs. So we need to show that the scanning
> cost is controlled and explain how it is bounded.

The walk stays within the folio, the VMA and the page table, so it
touches at most the PTEs that map this folio in this page table: 16
for a 64K folio, PTRS_PER_PTE (512 with 4K pages) at the most.  Each
PTE is read once by folio_pte_batch_flags(), the same scan fork() and
mprotect() already run over these PTEs.

Measured, that is 14-20 ns per PTE.  For 512 PTEs the fault takes
10 us, 1 us of it the scan, the rest marking the pages exclusive and
writing the PTEs.  Those are PTEs that would otherwise each take a
420 ns fault.  The pattern where the work is wasted, one store per
folio, is the one the description gives the numbers for.

> I also personally feel that both the changelog and the code are too
> long to read. Could we somehow split the changes into smaller pieces
> and describe how each of those concerns is addressed at a finer
> granularity?

Yes, and sorry for the wall of text.  v2 is two patches: 1/2 handles
an aligned block of 16 PTEs, the contpte-sized version David was fine
with in 2024; 2/2 lifts that to the folio.  Each has its own numbers,
the earlier discussion is linked, and the changelogs are cut to what
is needed to judge the change.

