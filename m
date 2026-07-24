Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0787CC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9811E6B00A6; Fri, 24 Jul 2026 18:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957A86B00A7; Fri, 24 Jul 2026 18:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848086B00A9; Fri, 24 Jul 2026 18:06:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 579736B00A6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:06:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3FEB1601BE
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:06:15 +0000 (UTC)
X-FDA: 85025054310.12.9DDE880
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id F1B4714000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:06:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fpmg/N6H";
	spf=pass (imf09.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZK/qXqHwCHYaftZ/w1GoLbX5tP80qRmxiIDWeISJO6Q=;
	b=GYMCBnv5QaAwXGDDvKvARGAO6OiBXkICn1ZOqjAkeR8aokjXdcKUrlDaDHDWQdCNIuki4U
	nnakE72NcbHOfqKEvlSXwXFnCjhgO2yZY8CJGi6sdwxJOhYipQ6NezddLZ/l+CPAFUiqKy
	7EjaMbKEaINSJZ8w5Jw9iVA/nKxuK/A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fpmg/N6H";
	spf=pass (imf09.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930774;
	b=mXFMtd6JlMpqL+bWobKEPLhExl1z7JemjAMXAWpKWkm9cGsmTZpZ1YMKrEfSTB8QDEE9Wo
	dU566zcvUFnSDSqyJvCeRG3qvxTVaAlhtTDLPhfqmKutXdIR53hmrtgbV1DKm0/UlQ0WKJ
	vjflSEkLFf8+Xoh8k5X2+YrbcIIFFeg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22E5E60A85
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75F91F0155B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930772;
	bh=ZK/qXqHwCHYaftZ/w1GoLbX5tP80qRmxiIDWeISJO6Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fpmg/N6H4iLzNaEYpIheWxuLoPYqARr98BQMPUPoDfLeUOQ3SUhup8BjYe5I/YSsw
	 +z1fmszvtnfUlJh21r6pA6BLwwcwoMiq+k045FawsKK6ElqCdl2gyWEWa+/jgStKFb
	 hMlgsNcJgaQYABY1AnauxjqU73T3oJOBXQUawm53ooM1oIYy8iBrK3CmFV6BiuTynp
	 VnmCeBu/ezj6bYMDeV2Wr+htc2ljCOleiwsU8PlmgyvXUUNCCtx3aBxoyZCSYco2JL
	 LQbvgbVKxE2pPDE9v0CFtvTHGhsp6WTr8NoLWdme/4FFbsb3MfvDxskhmOQTKU8axj
	 jju0Cy7bUINKw==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b0117d49dcso784230e87.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:06:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpu0yT5+5/wSYrKNUFLI4fp5GrwUpr/MXvPex9BOhoDHjtMU7mIF/JVXVD7AkBNT1r3ml930cD3eQ==@kvack.org
X-Gm-Message-State: AOJu0YwXkl2tiIdAXPJQiH3Rp2t/ZWg3D27cqQOwMFVHmntjpvU70HS7
	Iq3hy0TuR0YZba0UT0nwvhgH8vx6rxB1pQ3DaDMU2w7odYCs2QdI4UsATYXa1Vv8MpmLALHpXfe
	ceS6rENUef+DuGhyw940eNpNgWpyHDEM=
X-Received: by 2002:ac2:419a:0:b0:5b2:a339:b422 with SMTP id
 2adb3069b0e04-5b2b2e57025mr1270110e87.14.1784930771522; Fri, 24 Jul 2026
 15:06:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260716014022.2823-1-xieyuanbin1@huawei.com>
In-Reply-To: <20260716014022.2823-1-xieyuanbin1@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Sat, 25 Jul 2026 00:05:58 +0200
X-Gmail-Original-Message-ID: <CAD++jLn_DDvWAudHC2Qtz9kaaonuC0YGTXn9nvPtZfGLbtUsOA@mail.gmail.com>
X-Gm-Features: AUfX_mx2hFCYIaz4S_jxIhA6OwkPZhUBrv5ELnxYqV8yBlY24tuCz2ltyfNSBms
Message-ID: <CAD++jLn_DDvWAudHC2Qtz9kaaonuC0YGTXn9nvPtZfGLbtUsOA@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: mm: acquire mmap write lock around show_pte() for
 user faults
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: linux@armlinux.org.uk, ljs@kernel.org, akpm@linux-foundation.org, 
	xiqi2@huawei.com, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, liaohua4@huawei.com, lilinjie8@huawei.com, 
	sunnanyong@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F1B4714000C
X-Stat-Signature: dbwnuoiuqjq1o4aqdwixzd8zyee1nxbw
X-HE-Tag: 1784930773-696458
X-HE-Meta: U2FsdGVkX18ByJ+uQqJ7FCFLCG/6Lmr5pXd3cnykoAXpwXCbQcxXIfm0vHPuLOWj/cMOvozDfJz7UOr0eqJErpjLxbyU85cwulrLg5Aixysg5alJV0Yj3tzcKgc/2fROrCJjVsgR8hp+qjpjJ1ZuqH6JE09Aqw4PmzNfyZmLJ2Dyd66em3ZtujPg1brIycvPhrR/w8VsZn1T6cQltsVevUsOCxD7OXNpcx1dfXRpiaxmxF8Z5ilyex9dESQ6qMpMQ1eQyyaCTu47ckFYuQh+gDSzjxImY3UEvtY5kbZPqm/QxBQFhKQHiA3YNwkD1A6brqtcAPzzmYVhBt3YPBa0+ufu0kcJgeyJt7Pf00oIJ3XB8QPnZd2saHcYLfMbgVSwdzIcCl2o9myf1uO5wMd12ZCJ4x9EB4wr/bi7asjKoJrLHr6FNKW4KV0ylf0L2NoQs7LbySLi8pwrx9VAwUO19NHx5TmgGckanbUZk7Bjk+FkxwsWhPaimyfQJ8pI93GhBYHYiS5+obRjgLaBh4rsPaChDN/86V9FCJGWc1mG9fXQVPmuK6t6kM9Jbx5n5YpCv5NUrDZw+cgaBGyBvmwzL+dyUbqJalev1JaB/eYrgvF8DmX9+Kz390A1HlOKzgqxpnXPJpF99Yg+8QBfz6PgV37+kaSISPi1fFxj9Rv/UtC8tLW4vqXnId4Pa1h5e8/MZ3I7HeYcj3dX5Kz6/00I3WvtllhKL9dZL/AzDe69HRxdlhpnbbsP+6ph3rC71um9WvPh3xf/c3wUGlqfTPHj2Vs6CHcryt2FZV0Dcm9gOLyEPxnTsIP/yhA7LCTUGWFXHiOH3a5V5+s/LOtcc1SeS/abRwO3nXzgjTV0pnJzKmEO1oWI14xNSI2SN808TTjwKTje/ut3JC37CvNc9h93DmNoy9DfR1fh2rVdsnI+E7aaHGvy9KFwdGX72lUnZAUhwi0AJ1Iilhqnk11XUCo
 iaME67/Q
 9SJYMYY8rAhf/ndZ5mby+2FVqQMJQz1TAhnXTYnrFJ4yiiIrwX4vSudfMIKGApErXngJa0IwXoKs4/zsHsBlfXiHO2QOoeN8TayZLvyO6GBfVIN8Hv1g59c0Gt8wGXRvHWyB7IICHIxH/QCCwuUUpmk2+XxDygPqwjkiZykQp1j+n5USkdWlo4ZZ+ZydmwZYS3FFRIf/P4abW4y+bbsAlGuERM9d87XHIYQcMY9ppARTt674dbw1xWRW+WrWV0J+5iiOan6BuyIj9bGx8F0tTV7Yj0nksWt5bKvo52c4HSG2LqWVpRRRZPFkAXO0mpbFp1+lUqYjaQxQLTYn7sj4MLBVCfR6iEL89esWPx/IjIpKSkLu98CFM/RZ7sFjbfFGrqVEypZBdu7Dtf/wnkXRBJX4Wn4uTz+8XNCoTZfsj6MOPKai7mRzNxaAyAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 3:42=E2=80=AFAM Xie Yuanbin <xieyuanbin1@huawei.com=
> wrote:

> When CONFIG_DEBUG_USER=3Dy, and cmdline "user_debug=3D31" is set,
> a user fault may trigger show_pte() without any lock.
> If another thread in the same process concurrently calls munmap(),
> the page table pages may be freed while show_pte() is still traversing
> them, causing a use-after-free in show_pte().
>
> If CONFIG_ARM_LPAE=3Dy, this may cause a kernel panic if the pages table
> of PMD are freed when show_pte() is running.
>
> Acquire mmap_write_lock() around show_pte() for user faults to fix the
> contention.
>
> For user faults, additionally restrict that show_pte() is called only
> when the addr is a user-space address (addr < TASK_SIZE). This is because
> the lock of tsk->mm only protects the virtual memory of user address spac=
e,
> furthermore, dumping the page tables of a kernel-space address for user
> faults is unnecessary and may have security implications.
>
> Keep everything unchanged for kernel faults, because the kernel is
> already in the "oops" state, acquiring a lock may risk a deadlock.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 6d021b724481 ("ARM: dump pgd, pmd and pte states on unhandled data=
 abort faults")
> Depends-on: <20260629123349.134224-1-xieyuanbin1@huawei.com>
> Depends-on: 59e4f3b45b96 ("ARM: ensure interrupts are enabled in __do_use=
r_fault()")

This looks a bit odd. I don't get the first fix tag, drop it.
I think drop both Depends-on as well.

> Cc: Russell King <linux@armlinux.org.uk>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Co-developed-by: Qi Xi <xiqi2@huawei.com>
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>

Looks correct to me otherwise.

Reviewed-by: Linus Walleij <linusw@kernel.org>

Put it in Russell's patch tracker after dropping the weird
tags.

Yours,
Linus Walleij

