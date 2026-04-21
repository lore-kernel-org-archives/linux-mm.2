Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1573F94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 21:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF408D0002; Tue, 21 Apr 2026 17:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5F3A8D0001; Tue, 21 Apr 2026 17:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4E7C8D0002; Tue, 21 Apr 2026 17:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF2138D0001
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:42:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59237E6722
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:42:59 +0000 (UTC)
X-FDA: 84683888478.05.E06D3DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5059C2000A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:42:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxkpFWnz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776807777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMxodhiUIQJ4ZIMuAelzSaDlsTIfH42Gcrf1UZtpVpo=;
	b=nhj//+Cz9p+3/vSMkWAwIVlHuDXM0N4vmBVS1yaP3P7t3PazKzZPpHr2wiVi/EyzQGeJO6
	xag90LpNlLq3Gq1+yw21O5rH20k6EmNxUD3qxPvtOJpxk5mOCcRvb55zodehGZ5Nf8TfVc
	tDuauwIE6zEIG2ccjy5i9CA5wnkH4gI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxkpFWnz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776807777; a=rsa-sha256;
	cv=none;
	b=W6638gSqhTbjrlAHOrYIXEPII1vKrqFpUTjDKfTrynfgsiV3iyrL0i8lU2dvx+he91Os4G
	3M1659tQ1NuuTuFlW4kHemsiAPWNh0a5tSqju3Hui1t3P2FuEMNmSTtnsBD6DaoknWO8Rk
	awHXccG88YgDDdYcvEgG30lK8Vb5Ppc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E59A540C29
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A36C2BCB4
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776807775;
	bh=UMxodhiUIQJ4ZIMuAelzSaDlsTIfH42Gcrf1UZtpVpo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fxkpFWnzCtPcVL/IznmhSmlmcL5lCgtVvLz5I8JmGrUrClMcsXXio4a/d+g3yhndo
	 n+nnbJpMXwAxPe+UE0d6T9BbcA6TarhkclSNf6SULvvrhwehh2YaOmPrnxgJwrmCU3
	 y8CQ4H+JW5D0H7aUZaSIgPB7UzyjiltRa+ibIFe6FRHqrN8aYq8259gt1P/9m58kPr
	 tqB72Z/maA+Mpzjo0z9Zj7NZb3sCibR7CoCJSknmgJvNVkX1nfU5ZzISK6HWLcP2H0
	 kgYSG7pXXKmAHWA0Od+ygseYAh6HEO1d0C0bDBeCsASd2jIMshENmPni5Ji+BHdtSN
	 7qy66W41I7XBw==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8a154cc6a48so55254116d6.0
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:42:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8uW+upFinI5Kq3wKj6GHyxiSm5jfFoe43OpeUL/cLak38T3eWNj5YwjohU4prcTP440kMIJt+3DQ==@kvack.org
X-Gm-Message-State: AOJu0YzIHbfK99dyf6yPsInmVJ2s5njrJDcXulbGNOOlRq15qbYfIsJR
	uBO46dBDdHfrB2bASffvYgHf9fSFl7vqUuqQEWOKkHKwSLQALiG3+IomA2vf6tLs+9ZF4RVc3lX
	x0fVKK6LdvjVAxZ0+soSrKTclBwV3EKQ=
X-Received: by 2002:ad4:5c65:0:b0:8ac:800f:10da with SMTP id
 6a1803df08f44-8b027fd15e3mr339383376d6.4.1776807775110; Tue, 21 Apr 2026
 14:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <20260421121616.3298845-3-haowenchao@xiaomi.com> <CAKEwX=P8_5qyou0KgvwvoPpRsUN4ohwsC7ysxjTW=Fbwk2uSOQ@mail.gmail.com>
In-Reply-To: <CAKEwX=P8_5qyou0KgvwvoPpRsUN4ohwsC7ysxjTW=Fbwk2uSOQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 22 Apr 2026 05:42:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xosgszLBGXdXGchgYW6ks_XB1vO35scrO0UUiQ1ZvVvQ@mail.gmail.com>
X-Gm-Features: AQROBzA4xqeiePpx2T32feC6TdzhaVn9AvlVPFTLGgoA55MmSZ4iPfF7r_PrN14
Message-ID: <CAGsJ_4xosgszLBGXdXGchgYW6ks_XB1vO35scrO0UUiQ1ZvVvQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] mm/zsmalloc: introduce zs_free_deferred() for
 async handle freeing
To: Nhat Pham <nphamcs@gmail.com>
Cc: Wenchao Hao <haowenchao22@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5059C2000A
X-Stat-Signature: fwx3grmodnhutxtnrypz6ifpunjrutrd
X-Rspam-User: 
X-HE-Tag: 1776807777-18184
X-HE-Meta: U2FsdGVkX1+41CF6Eq2k+d01kUAoXm+B6HbzsPaSkPl0+PC/STUbeUEtzF1uf7w8Hmb3YXKBtzmTSb112rGLIZaJ7Hl89WonBxnTPTwMjR9I7jkzaFQE/v+a1nxnIsD7sRY1BJQi/mdDlKbhR/BSoKPJ8X8nLPiuJIgYzoWg+N/30gA7inqQKlXkZGW3+rghRt6Amg5H4WMTTCxBr/NFdK7oJ8/KCtjYbct1tQODH/4D1Oe4MlvX6IY8PMNXpVwKGEnaOJ9F5bDv9sEitg1gpVE776Lp72UIP354/KSdM5Iq3/xDCOdwQEuVGI251RYjQfrvkIRtaYfjybthU4tWH/xHBtasOzGD0qEHpuJZFEpKvwM5wwolclt4L/VCG0+IokcAMDYUE65rPwM9JVvP7FFa/SVDHql5GzjH3OSlMZTkUNsC2PiOq383Y/7XpuTadf3DWErcyk/AJhxbL6LNyhgfuk0tYxoWe3bkAgRKe8nPeBU9APpsLfjWRtZNAsYZmkeR/7P4RsHXSeFlJI/7l8PjJdaHJRvp4dKgaLHRiivqTuF9GG/aQ0lwvflmQneopb0TLAy81CsXyIW+tjhp6aZbwRXHjtgXJyCtntzYHoqKa6JUy0kL9QC56U+W0a5XwmFVws3s/fYvRFOCdIjQHVPdX0YiJD0NgTuCOy3ilrEx9N6j/cNMhLhp3pMPPPLVdP5JYCFQKEL5/Mdmxf+ludMO+4i4xrO9JX9Pn7NVI0+ZnENSaRjFTBD3GP6OdgNc/zU27pf79H/o6IHkRnzfT0dmkUYvuSCTkOCvREipT5AxXZQ4X/M5XcUadDIlCCoz31mwhrlXE6sRfYnTQ77nRL4649YIlThVgHlKKgnWhLdbi3Y5vbnClBHK91jm3rdQFKjVorcTidUlJtgRoJVimughN0tWxtSP8BcE2dYebRbZ9WtisO+h4QDw9uUzyoi8d7JxnpYNdHgzy4a9jiH
 QPBMkAXY
 1EUBkNm36oa2+i/s7lwLcTTQq2E+vB0cptXsV2amZFCnFjLgCh6uT5gpTql8DPTpqTyKbe9gSa8d2317POPvDiUgM8PY8MFGzlRbUXAma3j4MSsT7bE/Eo/pW0fV8rBr3pR/J+SBtXAURFOgAziubhfMJzRaZfAdJNhNZK5W+JTrUkdWuXzSF0tupU/0hQbiZPCeCupQbruMet2zFEzrHPY3Z68aURz4oMbi2jf+9T+hNCyIbM0FvYowl3W42UXU/HQk3Tjcl0Ic2hphA3QYP97+EdJOynp1UWw6eb/Is4cVYBI3VSGKLsLpKzWanS7D5Ng5vmAzY1zoYVyWQZrYh5wlJSA1hZrCD6ebinhsCnDKKBn7sf13GYbK/S9DIRl3HsaMoYgYAzE9ZsS14YzT7XUTOSxL6WtKnocth6X6EUjNdwhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 3:47=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Apr 21, 2026 at 5:16=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> >
> > zs_free() is expensive due to internal locking (pool->lock, class->lock=
)
> > and potential zspage freeing. On the process exit path, the slow
> > zs_free() blocks memory reclamation, delaying overall memory release.
> > This has been reported to significantly impact Android low-memory
> > killing where slot_free() accounts for over 80% of the total swap
> > entry freeing cost.
> >
> > Introduce zs_free_deferred() which queues handles into a fixed-size
> > per-pool array for later processing by a workqueue. This allows callers
> > to defer the expensive zs_free() and return quickly, so the process
> > exit path can release memory faster. The array capacity is derived from
> > a 128MB uncompressed data budget (128MB >> PAGE_SHIFT entries), which
> > scales naturally with PAGE_SIZE. When the array reaches half capacity,
> > the workqueue is scheduled to drain pending handles.
> >
> > zs_free_deferred() uses spin_trylock() to access the deferred queue.
> > If the lock is contended (e.g. drain in progress) or the queue is full,
> > it falls back to synchronous zs_free() to guarantee correctness.
> >
> > Also introduce zs_free_deferred_flush() for use during pool teardown to
> > ensure all pending handles are freed.
>
> Hmmm per-pool workqueue.
>
> Does that mean that if you only have one zs pool (in the case of
> zswap, or if you only have one zram device), you'll have less
> concurrency in freeing up zsmalloc memory for process teardown? Would
> this be problematic?

I believe so, as reported in the original email from Lei and Zhiguo,
which proposed introducing a swap entries list for async free.

>
> I think Kairui was also suggesting per-cpu-fying these batches/queues.

I guess a per=E2=80=93size-class workqueue might strike a balance
between scalability and reducing lock contention across
multiple classes, where the locks actually reside.

Thanks
Barry

