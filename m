Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B8A6C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 01:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9346B0088; Sun, 13 Sep 2026 21:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C15F6B008C; Sun, 13 Sep 2026 21:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1076B0092; Sun, 13 Sep 2026 21:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE9416B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 21:09:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3943C0DFF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:09:47 +0000 (UTC)
X-FDA: 85210585614.23.3C83B7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C527B14000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:09:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bTuybQ7E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789348185;
	b=t7Z5rO+NNpJvxKu4OrGr7NfhfOBghByxohGyUqSdRIZ+ePtEXCF/O1HG/1l6MvPW53zY9y
	lCQdRXFqph4ALZkZorIhIuZEvQHdTtn+6GvNhqyaqd7/QZl1tKV/dQZuPaCF6f2ojN88++
	JYYCwn8o+JFE6EfnNckYWYwZ/VoflnY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bTuybQ7E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789348185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ndSNsr2rSjtlZsOTZb7f4dR7eAAlwrJ58BLG0WJdXg=;
	b=6ej8A6UfGXR7vz645Ttt79DrY8ceWsuvs4lIAoE9Lu1hyka0f5vhN1pG1SBJkvv2pCS5GV
	TQ8dCNZDi1UBiy4pE5Tp4fzeezaKU+Cx8ThecaDvVgTTKFr8tekFNRLb2ZIwQ0SQhaDhEI
	kMo2xLLE1VTwIvM+CEyWNxzSJ5pj45A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BCBF44ADB
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC0A1F008A0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789348184;
	bh=4ndSNsr2rSjtlZsOTZb7f4dR7eAAlwrJ58BLG0WJdXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bTuybQ7E+iX/pUYoWBlgygEgotFdfAUox8Ij5d0cWr2Q7XAQ6VX66cVl32BlQ/I8Y
	 zMWbxJM6djY+Uh+WhuF7VUqkfDzQLMUCD1OeIPz/fiaZWrklyzR4CvxE34aXGP78cW
	 gR7sNf9vwuphZzMvaxW61lIBCL4NVrfCcEjjsG5h1XvV+15kQIe+z9a+//QfGHYNLj
	 25IMJsavUfUwu8CO8UhF3NqAKHbuH1zvn7YK+w4cU2fXR5ERa9WRYTffN3vXcGmi6j
	 a7KWhFZSXR0KaXUzLaMKwzJXPKi4JtCo31oRvBPk9S/pyRbPWRDeb+S4fZ/qn91NT+
	 YDG+aD1DV8VTg==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-90e9e042ee1so31748676d6.1
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:09:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByd74z6yRqBycQ5FYUwSISbkiHBu80jGRiPLMrPZpHB4xE0mXdufW+ES/qce14e0fQi7Q793PhIhQ==@kvack.org
X-Gm-Message-State: AFuF++kct1OJYb4k+mJkB5O6fDspTdKNbT4moCfHrI71dFECAHqXaaQ1
	Wgd0k3vtxj6D8yMDfypnEmbTJ5BZILqGftV6y1WPaTxgRe/pa8IRYPB2/+vaohSDpCbiNsos7Uv
	m1BjWDnl/rXbll/xYlUBsKqq1oe1L9rY=
X-Received: by 2002:a05:620a:2707:b0:939:bd4e:b2fe with SMTP id
 af79cd13be357-93a29a12d15mr69398285a.40.1789348183191; Sun, 13 Sep 2026
 18:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
 <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu> <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
 <1e5118a5-6b61-49d0-85e1-825e22059241@columbia.edu> <CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-cHaDWLkxaQ@mail.gmail.com>
 <65a2c7df-0d2e-46de-9580-01e9c35a7e32@columbia.edu>
In-Reply-To: <65a2c7df-0d2e-46de-9580-01e9c35a7e32@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Mon, 14 Sep 2026 09:09:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zS+UehT4wuTuTVjK3s3mhzp+dku8M-Of9cF=CN82aRow@mail.gmail.com>
X-Gm-Features: AcwNN1UFRWFTcqC6hN8ctMIRvI1_rCC0AM5x7mAixBPPm5RLTzvAhNItNpawqdI
Message-ID: <CAGsJ_4zS+UehT4wuTuTVjK3s3mhzp+dku8M-Of9cF=CN82aRow@mail.gmail.com>
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Tal Zussman <tz2294@columbia.edu>
Cc: Wenjie Qi <qwjhust@gmail.com>, willy@infradead.org, jack@suse.cz, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, axboe@kernel.dk, 
	trond.myklebust@hammerspace.com, jaegeuk@kernel.org, chao@kernel.org, 
	qiwenjie@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C527B14000B
X-Stat-Signature: 9njcprwn659bc6eysup8bnw4c6idxyia
X-HE-Tag: 1789348185-336649
X-HE-Meta: U2FsdGVkX19JwzZOQQUuuWkV/5nqDmbZ5Tz+VUw3X2fhiVYIpP3T/uOR4CYAh1/PqHPboh3EgmxWiAOSoMzIlch5/cb1AC/KkjmBzZz6r8sXhNbRMCbxuMRprQfEZN0w+9eRkB9GbEm9KfwKw/im1zxBpk2Fzu8dHk59guU3lqJjOByzXq0zaYmwX3tlxvpJbDMCXhw05krh5XPQXvprnczM8kSsRRJ+pAS0tv8KzMvuwCEcCERPD3kvITvLgrygKeAPi/BgEchz4+w/lnwKYs9GzBvTD+8/oCOGil8pErEkhi7WwtEZJQHzAGNG8j0HkX5Hpy5ZIXCoXPrtP62s5zCfzVRabjLaj5kbofLwSFDWRXLiIc7c0wt7U8VT2duiN2av8gmYWTQj91zoMqIkhbigO/y7r67o93xm73dH3YOtCc9YUYl11upLXrdC7fcKwPfGUjsQQcgWxHaKofMxqCNdpNvf8xBg1h+wnEWEuoB0P93ZeeIh9CBrQOOXebvvBjcIkxF784r+R6SIdhMgkU+cWzfAPjkL1zlCWcSn/3qxK9hF0vzi4kSFuE/VihukpmUU29DP9ZckQ6RJBHFVPrtqESkKbdtXINEfKSi89EUPEHD4F9MSXqBdifLaFTd/Cx5JJM22wbgRawAP0nPiXwHu2wZveYXW4GM3N0GyIoVfUGJrFhteLpNI2j7J983b65o1dehBJLDQGrKzb2FByq4N5NV8srYxU1SgqT640ejvhFQZd0M3KHYPxxXPeeqrZrRBo0jWNANJ+vA22xXc/KBLE63NkyWBv3jdzlL9Y41yMQSrQieGGNMblaUabQFhmjZ5fzNv3BuIOUmwZtO/6dtogRR1Z6EmUK05vgfDJAgdG+Cd1K3SzKxOiOTQirQddWQAT+/XZuByRJ8XiQ7RBJL0q8dd+2MNG1FADJ9rOeU7TcI0Rjtn7JJ1YoAlHdYikNL0g8MavjMZ4h+Czo7
 usqzSqhf
 3BIlKdpK8NdengmresWNFhmNJPD8YVSE24ek5Gcl6mrqQ+Cek5P3PfMTU2wHaUzBfQW4x2sjPF849aNBfV1a8rT3bLsJxXzpRtYTrxzDk9JtE7NZ39MKIT+TsvdLH7CFyAAW16eTJpWgJUqPMDCc6iK/7+m1Gnx0h96B8Z3n+smnVDW6yr25b0+23AMIgHb3mP3IyD1vxjO569dZ5Hw/JMUKr+8cRzo+aC8u50Q5yuqac2LQ+79HnQWNN662qe9ZfkhtvLMzKMDHYXQicUyUZezRrj7SMxRau0w+PEIUUCE6SgQUb5ey/I7pAk/q/sz4yUG9CwtiQuYP1KCHYY9GDBtUAPbFHa3CU0lmLhINJ///2BskqusQ6tHCIcPXNhlev7AgnsJGCkLQazyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 7:34=E2=80=AFAM Tal Zussman <tz2294@columbia.edu> w=
rote:
>
> On 9/13/26 6:51 PM, Barry Song wrote:
> > On Fri, Sep 4, 2026 at 6:36=E2=80=AFAM Tal Zussman <tz2294@columbia.edu=
> wrote:
> >>
> >> On 9/4/26 12:28 AM, Barry Song wrote:
> >> > On Sun, Aug 30, 2026 at 7:59=E2=80=AFPM Tal Zussman <tz2294@columbia=
.edu> wrote:
> >> >>
> >> >> On 8/30/26 6:25 AM, Wenjie Qi wrote:
> >> >> > From: Wenjie Qi <qiwenjie@xiaomi.com>
> >> >> >
> >> >> > Fault-around can map ready dropbehind folios without going throug=
h the
> >> >> > normal page-cache lookup that clears dropbehind. A mapping repres=
ents a
> >> >> > competing cached user, but writeback completion can currently unm=
ap that
> >> >> > folio. A later mmap access must then fault it back in.
> >> >> >
> >> >> > Retain mapped folios instead. For a mapped folio,
> >> >> > folio_unmap_invalidate() can call unmap_mapping_folio(), which ta=
kes
> >> >> > i_mmap_rwsem and may sleep. Retaining the folio also avoids this =
path when
> >> >> > folio_end_dropbehind() runs in non-preemptible task context.
> >> >> >
> >> >> > Unmapped dropbehind folios continue through the existing invalida=
tion path.
> >> >> >
> >> >> > Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages w=
hen writeback completes")
> >> >> > Cc: stable@vger.kernel.org
> >> >> > Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> >> >> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >> >> > Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> >> >> > ---
> >> >> > The mapped-plus-dropbehind state was reproduced in QEMU. The patc=
hed
> >> >> > kernel retained the mapped folio and continued to evict the unmap=
ped
> >> >> > dontcache folio. I did not reproduce the sleeping-in-atomic warni=
ng and
> >> >> > am not aware of an existing report.
> >> >> >
> >> >>
> >> >> I was able to trigger the sleeping-while-atomic BUG on current main=
line with
> >> >> some help from Claude. The reproducer itself is straightforward eno=
ugh, but the
> >> >> configuration was a little finicky. The atomic context comes from u=
sing
> >> >> threadirqs so that virtblk_done() completes requests from the irq t=
hread under
> >> >> local_bh_disable() and the vq spinlock with irqs off, so in_task() =
is true but
> >> >> the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so comp=
letion stays
> >> >> in the irq thread rather than softirq) and ext4 -o dioread_lock (so=
 end_io runs
> >> >> inline instead of on a workqueue). With v4 applied the bug is gone,=
 so:
> >> >>
> >> >
> >> > Thanks, Tal. Then I'm getting quite confused. Since with Wenjie's
> >> > patch, we are no longer going to sleep for dropbehind in `filemap.c`=
,
> >> > do we still need all the complex logic in the block device and file
> >> > system layers to move dropbehind to a workqueue task context?
> >> >
> >>
> >> Hi Barry,
> >>
> >> Let me clarify. Wenjie's patch prevents sleeping in a very specific ca=
se.
> >> The existing in_task() check covered most other cases, in that it just
> >> doesn't do dropbehind invalidation if we're not executing in task cont=
ext
> >> (for example, block device writeback completing in interrupt context).
> >>
> >> However, dropping the invalidation defeats the point of dropbehind, as=
 it
> >> leaves the pages in the page cache. If we get rid of the task-context
> >> deferral mechanism, we wouldn't sleep, but we also wouldn't invalidate=
.
> >> Wenjie's change is largely unrelated to this.
> >
> > Hi Tal,
> >
> > Thanks for the clarification. However, I=E2=80=99m still not convinced.
> >
> > If `unmap_mapping_folio()` is the only place where we might
> > sleep =E2=80=94 where we might take `mapping->i_mmap_rwsem` through
> > `i_mmap_lock_read()`, as Wenjian pointed out in [1] =E2=80=94 we have n=
ow
> > prevented that from happening with `if (!folio_mapped(folio))`.
> >
> > So no mapped folio should call `folio_unmap_invalidate()`:
> >
> > static void filemap_end_dropbehind(struct folio *folio)
> > {
> >          struct address_space *mapping =3D folio->mapping;
> >
> >          VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> >
> >          if (folio_test_writeback(folio) || folio_test_dirty(folio))
> >                  return;
> >          if (!folio_test_clear_dropbehind(folio))
> >                  return;
> >          if (mapping && !folio_mapped(folio))
> >                  folio_unmap_invalidate(mapping, folio, 0);
> > }
> >
> > Why do we still need the `in_task()` check in
> > `folio_end_dropbehind()`?
> >
> > void folio_end_dropbehind(struct folio *folio)
> > {
> >          if (!folio_test_dropbehind(folio))
> >                  return;
> >
> >          /*
> >           * Hitting !in_task() should not happen off RWF_DONTCACHE writ=
eback,
> >           * but can happen if normal writeback just happens to find dir=
ty folios
> >           * that were created as part of uncached writeback, and that w=
riteback
> >           * would otherwise not need non-IRQ handling. Just skip the
> >           * invalidation in that case.
> >           */
> >          if (in_task() && folio_trylock(folio)) {
> >                  filemap_end_dropbehind(folio);
> >                  folio_unlock(folio);
> >          }
> > }
> >
> > Could any other operation in `folio_unmap_invalidate()` sleep for
> > unmapped folios? Otherwise, it seems we don't need `in_task()` at
> > all?
> >
>
> So I think you're right about the sleeping aspect, but the problem is
> that this still gets called from interrupt context. folio_unmap_invalidat=
e()
> grabs a number of locks in a non-IRQ safe way. Just at a glance, the
> spin_lock(&mapping->host->i_lock) call could lead to a deadlock, since ot=
her
> paths don't call it with interrupts disabled. And xa_unlock_irq() enables
> interrupts unconditionally, which would be incorrect from hardirq I belie=
ve.

That makes sense to me. If that's the case, it seems the
comment above

`if (in_task() && folio_trylock(folio))`

is no longer relevant at all.

BTW, if we use `spin_lock_irqsave(&mapping->host->i_lock)` in
other places and also restore IRQs when unlocking the xarray, then
we shouldn't need the `in_task()` check anymore, should we?

Best Regards
Barry

