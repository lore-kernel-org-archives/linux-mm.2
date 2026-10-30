Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077A5606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mnvbB9lk
Received: by kanga.kvack.org (Postfix)
	id 103BF6B05B3; Thu, 29 Oct 2026 22:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5446B05B4; Thu, 29 Oct 2026 22:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C196B05B5; Thu, 29 Oct 2026 22:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8A8F6B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:05:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D768C05C1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:05:17 +0000 (UTC)
X-FDA: 85377650274.13.623D8A5
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 47AFF180003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:05:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mnvbB9lk;
	spf=pass (imf16.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793325915;
	b=GjYsc/ZzTNrzxJUXVNBwJgLPu287zJRxMU/OmrDEsdu7e5nwzcCW0puSE4mXjeo2GI9P6A
	fRhcykOG+1UtxrugdY/kGsg+XwZjzutcDZH8cHTpvTtESPxWjRD0H2q91XVFewVKtNT69A
	xbcwtbBIwrnECEKybT1TbbKEJlrXvrg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mnvbB9lk;
	spf=pass (imf16.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793325915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKjrHAAk7nXIeoSQFsXsh4G7m4UuVgqfRgVzxBn+0Rc=;
	b=7qKGoPmB3zkW8IKHGlSP7vkrbgs/RYQ8G45f30mNZVlJFAB9GuENix+WYupHsDGZE/FMkb
	6YWwJrsfDknj+Xrp4i1xhdJH9yp3HDQ7vHZzuhHBULg8mIcZlo5qYB/X5HV2fuj4idCNys
	VP6qcGcT8snrlLNVzNlPl2/uwMwNBJ8=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36a1c464349so40877eec.3
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793325914; x=1793930714; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CKjrHAAk7nXIeoSQFsXsh4G7m4UuVgqfRgVzxBn+0Rc=;
        b=mnvbB9lk2mrfS9HFgGyIvE2bt3M4mH7VsEaIgPuSb/J1FGko2+DS3xG43AQZiYYfn/
         NB9cxl1D5l5MoFIpN5D3o6hU5q0ykHEmqr1JFKekaGRKSWWvQjlGkeB9x91WU57K5ROV
         eNnqbIzXGS7mJtoNK3rZfuJrcP6ZzyetcGKXuU1MhNqYP7laiYacWqoD8xoDLxAhZ6Vs
         ns+1qcOwev/DE4lBMYX2OBgpL7DDypMdMkyvKNv6iZKsU6SgGJMlp5rHuEcWkobXxY9r
         jL5KiE7SkLvAyhhlsJmzugCQ3hLot9dSpE8/2o3Yt59d7uSXvk4Y0ywkyp8dVTae1ozy
         2Nxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793325914; x=1793930714;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CKjrHAAk7nXIeoSQFsXsh4G7m4UuVgqfRgVzxBn+0Rc=;
        b=PyHQfr96qQkH1/VuZMmMBb9Lv/b/FbVfDHf3JP6QeJ3eU1JxlaPgYKyPb+AXZOjojl
         yP0bAro8flGyDwHGZr3vwaqrr6mv1pZ7Dd/HFFcUmLywBQIlIQ7bizS3EKzBIgWAndg4
         XRW8YwZNKJfaHN28Mf/31bKJ0bkKub14UIYhdCuHW01yO7VElHPIuzOJkB75AFh4K3FM
         p2nlCLAjtyqIvOVt93yOfYcD07Y1UMZOoMG5Ybnl0E3ksNp+i4Jo22qkwFpRoYS0bYZR
         t4ZEMzvEmklUx7qDH9e0j/z5b5nMtBEKwbxWnEF3Z4rnEUt1Ywyvt5NpldmDW+GvuesM
         o81w==
X-Forwarded-Encrypted: i=1; AKwUvBx3zvIh0ljvvnXqeAZvzRouxucshJUp0zmEs95sdGGErs7kOgOtcMNtfeSxqzm4C9MQE92qvnuwkw==@kvack.org
X-Gm-Message-State: AFq9FYL7JM/0gack4vc4Hjt7UA3vbqOKdeSwIbvDoEwkbV7/krwNS/q1
	7mN4SGJ9ugGdSOcV6tbcmBxd96kunYU8uq/pwcP+jNCF02VUBqwNyyHG
X-Gm-Gg: AYBFou24J5flXa76zlk9xAffLIc2g5AbB4CysSzSSfCeDDpMcSvaQMbX2IzBeiTlZO1
	26VSkxudSCNq6s2Phi1U6K5s2yBnG9twSVKMbkr6UfbGS/9fklKPcHzklF7SGkID90TrzwnBxdb
	CCn7mEvH9MThDZtTEAmqM1yo19zf/g0Mn+Xj6YcMtWY7J8hEfG4VXHCa6Vlo8ia2uRCoxX/gp0F
	9Q5XI4D136dXODF8VdIvlzYYZre25PAL56q+DVcPo8SzWFFJQYK9M3R+82en6M420gZORJAfEeU
	XWFXvPO76LOGtRXpRVx0LMITvLPxCfGuWfGAvOvd6L6DqrHh7/wkA7n2TNGdvtmEr/I+YwLxOm2
	WdPMqVzb9BHt5WpkazlIZJLCJ8LOBbCcmXS7YfY6WoErCP1LcRFoaC2TxqTYhSdwy05qcRA8Kd5
	5fiCu/YMO6jz4X8WcLsJZj5PE1movxdeDWDfnaJJcnGcVKfVcliQ/VgyuuoGQ6A+gWXf6cXJnFU
	oQOzZ4gqfJ5HOwVHGNz6c/6aVD57CU8Taw9rO7mTFvGPvw4OraKiHaTX+Fnp6pKZu5w1H1us+yU
	bbCFQmlG9/rfy1ZHnNwWpuIY5xA7wZsG4DncS14djPB5jSS4+bgMhB+CPot4eXJ1Lxcu
X-Received: by 2002:a05:701b:2515:b0:17f:641e:7f6b with SMTP id a92af1059eb24-1ac5904ae73mr1613426c88.1.1793325913562;
        Thu, 29 Oct 2026 19:05:13 -0700 (PDT)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac19c6b969sm2417987c88.14.2026.10.29.19.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 19:05:13 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
 Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
 Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
In-Reply-To: <auKjuiRxQwtsZF_0@google.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKjuiRxQwtsZF_0@google.com>
Date: Fri, 30 Oct 2026 10:05:07 +0800
Message-Id: <179332590773.3867294.3750177162706544686.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 47AFF180003
X-Stat-Signature: zee31g3fn3puof56kdhjwsgyi9m3e3jz
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793325915-570344
X-HE-Meta: U2FsdGVkX19dBCljpWkQ/mid0rR79uYBnVLYoqPyEuyONT0fIk2xXjk+CbDh2Ab9GBdcEiJx2aXncyr11LcYoeD3lfC+a4R4N55782AqI4EsvSM4/zPLTCqEcXUaNrkFE6sI15XNQkQAbtJ9lFOpoj7yR9NRro4krlk8vGAgPFXVAWlY3B8t9F3Xya6mP/1C+sWeGYLSnWmUC3YhlzniY0wXYzaucmSNZay9Ki77j5Zquf/frU8FNCvJDRc9HxLOjriWlu8awRXFq4r5WWS4JcSbkc/ITmvGzmRW/Xv0q+NsdF0Qy94VXfDW8xUHxfWIgNR+zFbXvJEig6RSCOMEmeMf1ymiZqxwdqgRq5l354/5TIZqyaOZ7JCAJlzc01xsN9T+2V7fULYDsYXdk+Z9bIBGXLPNctIYIcxtgUwPFHrHtl3uLbUBM4r9UYuKYOwh2kwWlUeL58X4YlRxKRN1hmnQ3ltpQPmfIyH1xF4VLj/2eiCsluEfrcnfLlZ+syutWDOEhNmaMPk08HG7bo5wBh3Ymtd130zolAuvGWGjQiSCJQVwmwWwM6P7ku95RQUl7PD4VgLosBLW+Vh4j+qy5Qob5tI5BChAuNx6xYWC2nfomFvXJ9cGGacaChmKKGiNZJeCg+VNYNLgzS3FmCzgf5KRACKvxhXXjCzKagLtVlaXDVyoV6X+r+ofEv3F/NeszUEtMYqOVnIcG1k+qkeXEuM9um/9XNilzsnMLO5nXYK3keFbuaXOG1ayhkvVwvSS+jgZAGMqr9F5E59vVHZW4cWRNEj8yQ6piQ35QjQonvA8hquvLgGZ2zoxE2eV1Ie60LSXn25W9BuMeuae7+EuLun8HniYtSHGIZV9lZstggcsvf7E8Ez5yeuqjeD6kwr6/sfVwp+VcMhbMFhI5hxMZBnhNZYq2ewVmZfOJW0Babo+OWtXAq0kwGOK9g4GKj/aBDYdiWc/U9M6/nrSLoG
 9UI8LWe8
 UTqsBlCy73QEUmnAHvirxydQA44mrW9fwWfwTVsMGFAPqEgpUwaOVEtzORaRv/idx4CimazsCOTmF4prriE458WO4QbSpP2ZhyBWuI5vvgvSLIB1QX+GlGnooWPO0grxedFjybCUgNV3Z+KQ5qyBXAIm2hDv8Qq4TbsVxaerwMrVqem9Y2ILo2cV5T0cAfSXCDYd4zOKeFjaaQVp41JBr/JC87utDB2hIou1lRneM79HkA0PIFKC+WXM/nKMyksPELRfQ0cX/RzuUA50TJO9v4az4IFDJm2Vme8TZw9iY/0SXpUkPfo9U+RR40INdrdA1AdkqnxN7JzdF9Fosz3jUO69xYHLqkG0IR6E+gbOR9VPYv5NXu3cWiRi7+T9nrEpxMJE3ws3zgYNSug8Aoa/CiyRshndaWppCxf+bc3m4cOQEXLZbk9u+024Y/ox3a04w2NOToyG3UF1HN9U4KJKbvjUpVDJIbrZhQ3oKUmTA9d5zh68/0+AeABSqgVmWQqy5RWOJcQ6tsibcwHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-29 10:43 +0900, Sergey Senozhatsky wrote:
> On (26/08/07 09:25), Nhat Pham wrote:
> > > On (26/08/07 18:57), Xueyuan Chen wrote:
> > > > Hi Sergey,
> > > >
> > > > Here is some additional data:
> > > >
> > > > I used the following definitions:
> > > >   compactable ratio = freeable_pages / total_pages
> > > >   memory reclaimed  = pages_freed * PAGE_SIZE
> > > >
> > > > freeable_pages is the estimate before compaction, based on the same
> > > > calculation as zs_shrinker_count(), while pages_freed is the actual
> > > > number of backing pages released.
> > > >
> > > > There were 264 callbacks in the trace:
> > > >   callback elapsed time:
> > > >     median:    5.77 ms
> > > >     p95:      55.82 ms
> > > >     maximum: 271.36 ms
> > > >
> > > >   compactable ratio before compaction:
> > > >     median:   0.32%
> > > >     p95:      2.86%
> > > >     maximum:  8.33%
> > > >
> > > >   memory reclaimed per callback:
> > > >     median:    3.80 MiB
> > > >     p95:      30.45 MiB
> > > >     maximum:  92.73 MiB
> > > >
> > > > The longest callback took 271.36 ms. Its compactable ratio was 3.25%,
> > > > and it released 7,650 pages, or about 29.88 MiB.
> > > >
> > > > There was also a 241.91 ms callback (with 30 schedule-outs) with a
> > > > compactable ratio of 0.44%. It released 1,019 pages, or about
> > > > 3.98 MiB.
> > > >
> > > > Based on this data, it seems better to remove the shrinker.
> > > >
> > > > Would you prefer that I change v2 to remove the zsmalloc shrinker
> > > > callbacks directly?
> > >
> > > Let's bring in heavy artillery to this discussion, in addition to Andrew
> > > and Minchan, adding Nhat, Yosry, Barry, Johannes, Brian (random order).
> > >
> > > Folks, I'm bullish on removal of zsmalloc shrinker callbacks.
> > > I don't think those buy us much apart from memcpy-s and lock
> > > contention.  Systems that want to compact zsmalloc have a sysfs
> > > knob (and API) to do so (based on zram mm_stat numbers).
> > 
> > Hmm we'd need to collect more data in our workloads to determine, but
> > if we can compute compactable ratio (freeable_pages / total_pages) on
> > a per size class basis, can we just skip the size class whose ratio is
> > too bad? Would that at least cut down on the vast majority of
> > fruitless memcpys and lock acquisitions etc?
> > 
> > I'm always a bit hesitant to over-rely on userspace, especially when
> > kernel has information to do something smart about it. It might not
> > react in time, and many proactive reclaiming schemes back off under
> > heavy memory pressure.
> 
> Apologies for the delay.
> 
> The thing about shrinker compaction is that it's sort of on the
> wrong end.  It doesn't trigger compaction when memory is plentiful,
> no matter the internal fragmentation rate, and start firing compaction

Makes sense to me. The fragmentation ratio alone doesn't determine the latency
impact, that also depends on how muchdata compaction needs to move and whether
it overlaps with foreground zram activity.

-- 
Thanks,
Xueyuan


