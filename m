Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC3AC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 22:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B630B6B008C; Sun, 13 Sep 2026 18:51:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED916B0092; Sun, 13 Sep 2026 18:51:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5B56B0093; Sun, 13 Sep 2026 18:51:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AF2B6B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:51:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C4CA80C21
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:51:27 +0000 (UTC)
X-FDA: 85210237014.22.FE43B75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3159120003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:51:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SxVR5iOn;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789339885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZiTG8sjKFTT4w8nPMlVhXaGC0u1YhzWKKam1CGyYWQ=;
	b=My5ydeihSZ8eI8dqYzLaxyzfU9c2XYK/czGwXBIXpE50/Jb32YuX6acMS1pwv/rcHB57D5
	g110JFjdDU0pEolzpsu38nCCn7VFf8tBAHj6pBl4IAOFqE44uGcVpxMR0FEbNeDqQioxMz
	KygcTBHzyt5dS0E6qW1O7mH3xGGPZqk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SxVR5iOn;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789339885;
	b=EnRd2BfEgqqj6BC94ykHKaaq7nmrA4mRrjr7bhLGBFne1sPHVe9+DGX3pTlKu/iin+mjnP
	NJk1MU19YSwgWjUIlsUa5y1lYDaY27hyGIVEADNOYK7HRvuNzQkK0myygkAOMzx8MFX1jC
	Rr4UdKdLIq/7A3PI/JxPKajGb0RZYSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AF0544A8F
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6315C1F0089B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789339883;
	bh=9ZiTG8sjKFTT4w8nPMlVhXaGC0u1YhzWKKam1CGyYWQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SxVR5iOntlyY/xdBsyV1rMUdC68ospWyz0cg6COeUj8kKgoG8FLcWR4Dg2675UMdW
	 5B992E5VfQ9MMidiiJUqslikjwvNIh4pPWjq2EbzX2N23Mc2icAHyf9N6OBP7XQDIj
	 s7RQzQvBMSk/uHpwhGQ0WK/hIc3j9pdD8FJY95+f+HYws2J0KquXACTXGfp4SNZKPz
	 ItDmfm/Duu/YlpJYaC2n5pqkKzjqfNAlm+VXLXaQTO9pkCJOuDGnKGo9WfUxGWAQ8+
	 4BxBPregV5W/rRMGc/xZVmcWwhX+VgvH0HF3b/p9vWo6pG/i5wpo1A6b1nbAaxrZzR
	 gzGWNUWMfnWuw==
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-531034aa31bso4097491cf.2
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 15:51:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxfh6SRLIypp+/1zWapJ/feOTrQRVvJlV16Sl/BvFeOZDeEUx0WtlB1X6ISOLHnrhqpqtsbZYr6Rw==@kvack.org
X-Gm-Message-State: AFuF++mhRvMiLIaee85DVRsEYY0Zqb/Z0FiBiRGUEhKV62utI29BrWno
	6YHbXq4ARiRvZ2cgJbYBX9SX6qCyupUP18jzRYghGls0tf/Y/H3P7uUCFS8tIomVfvZ0cvHg2ZN
	ERcWVZuI4h/F6r1m7D5N2YKmqZKhWtjo=
X-Received: by 2002:a05:620a:2702:b0:92e:71bb:d1c0 with SMTP id
 af79cd13be357-93a297ee80cmr26633285a.15.1789339882564; Sun, 13 Sep 2026
 15:51:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com> <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
 <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu> <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
 <1e5118a5-6b61-49d0-85e1-825e22059241@columbia.edu>
In-Reply-To: <1e5118a5-6b61-49d0-85e1-825e22059241@columbia.edu>
From: Barry Song <baohua@kernel.org>
Date: Mon, 14 Sep 2026 06:51:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-cHaDWLkxaQ@mail.gmail.com>
X-Gm-Features: AcwNN1WjkmO8uX5Iavm2W9nWdvLG2cwH8oYEJn3mYskY-hmIRTHjLPMkj4xTYTQ
Message-ID: <CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-cHaDWLkxaQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Tal Zussman <tz2294@columbia.edu>
Cc: Wenjie Qi <qwjhust@gmail.com>, willy@infradead.org, jack@suse.cz, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, axboe@kernel.dk, 
	trond.myklebust@hammerspace.com, jaegeuk@kernel.org, chao@kernel.org, 
	qiwenjie@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3159120003
X-Stat-Signature: 6rysbqtj5sodxcta14yrk91ek6cjd8ne
X-Rspam-User: 
X-HE-Tag: 1789339885-144887
X-HE-Meta: U2FsdGVkX1/hQhvbD1hSjtoUGWPcMZwmFdI1KlTv2OBMA9HzuzhQ6k+mhxHEai1e6oGXynVLoEcEkJbTGwt4iN0MDQJo0O4L0WsjE7LnjQb40fT8nZB4/N271bGwIQN9vqa6VbcsJQOsQG6YTauZjbIX3nlSep2ONRLhgF6cX4QmSlYhLt/vYRWoAoO7xj7AgJa2ZrseKslLwVvEW5903ekKlb6UzYjc05SchKzBotYA/3otadIpGifKGdAkzqvGtsMrP48QYhljCCoxzuFmVQLoXRp15YcQHoi21GLVJIR6gTcpuH5wwI8dVh9cVIcjtnbBDEPK8dwvzjAyDmC+p0r++KGi7Ee3Md6QzkQhmuOWO81pP0HltIi1wgCGlT3VuwcTWAHHrGAgMHZf83BA3jyhy6a3/hJ7Af/du/J7Uhytje9cQxPcfDUqJ/uh94wttTFkq4WrZktpyn5A5bQQ45XNDljx5MWKaf0XnunmIPnBJ7r80W6yGZcEwmtSsMjBWFtyU9/GS6+6YaE0Wt4Zn1AEnYHy4eenaa9zeYkKF2DSbyMODe8mBSpy/qGuECCIAvHkfRab+o89NXy9Wk1r59FmUwsjtPcW7x8MoVHoiLoCkqKZrsBhf0K9D6aUKZnZf4AUjAm2W43SGvGFD15vcohzS2ggMWfNUmiod2Rn7DvvVwZCuBOrcm+RX0weAG2FLddXtFWaolDsLmSrfo7he2/dyWhoEtZM9ERWa852sBwxKChwzavohuDZuAjO8Vg9NHsyvbL+q606Pt68IzBwl4E3q+TMENyAaOj4XLrCkBy5pT32s7wwlYQYGPZvO5zIA8/jB0L1oBp/U5D/9UgMs/LgKop2tDnXy3BGtXTF8D8oQrcq9MD+b7UtHAoDp9zM8z08erEVp9vMVmdjQcIuzLPEpiUSGbZzoqxq2gKVauzbW59Z2iGPia50evsckzauGHr9Rh2RdsVGCbxYBc4
 BvK6UkaH
 DNwaw2r9l7h3nvIAHIaMX9E2PKJystxUULPBjBxJ6keQE0L2vz2roTL8CbSWVi5L1DzE0NpyDfE/1QdGcZS1yrLK16WrxidU96XUcqzLys01L6+a8V9n43admO6BR06na2vV0653dqHOOslBE8FUM18oyd4S22Zp/WNj3MQ+vOH2Zyox2q1mKjxAjIMch+xFhpxCvAvn5vZ+oScVXI1kTTG510x3FEq+koQca6YTTGDxY/RjF/a+VXaBCzbBV7IYj86LG62sWOChYJ4poyZB7w8SA5bhP/LIyc3jnCiOsP16mAqsc8tISNmov+F3c0oryqlnPQPK9+uvL6brK2JhBdwADIjnpmYrETNBTAjF5DU6uv43iucvdKVhlNQ8PErUMh7JL+2u2kZGi2qPMW1uIaEgWer5q4IKd6RYkHoh3eyfR6iNPjsg8tmgUEUz46kcfJcfp/IZASipVWp7NA1LZnSK+nklEtVaYIY6Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 4, 2026 at 6:36=E2=80=AFAM Tal Zussman <tz2294@columbia.edu> wr=
ote:
>
> On 9/4/26 12:28 AM, Barry Song wrote:
> > On Sun, Aug 30, 2026 at 7:59=E2=80=AFPM Tal Zussman <tz2294@columbia.ed=
u> wrote:
> >>
> >> On 8/30/26 6:25 AM, Wenjie Qi wrote:
> >> > From: Wenjie Qi <qiwenjie@xiaomi.com>
> >> >
> >> > Fault-around can map ready dropbehind folios without going through t=
he
> >> > normal page-cache lookup that clears dropbehind. A mapping represent=
s a
> >> > competing cached user, but writeback completion can currently unmap =
that
> >> > folio. A later mmap access must then fault it back in.
> >> >
> >> > Retain mapped folios instead. For a mapped folio,
> >> > folio_unmap_invalidate() can call unmap_mapping_folio(), which takes
> >> > i_mmap_rwsem and may sleep. Retaining the folio also avoids this pat=
h when
> >> > folio_end_dropbehind() runs in non-preemptible task context.
> >> >
> >> > Unmapped dropbehind folios continue through the existing invalidatio=
n path.
> >> >
> >> > Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when=
 writeback completes")
> >> > Cc: stable@vger.kernel.org
> >> > Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> >> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >> > Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> >> > ---
> >> > The mapped-plus-dropbehind state was reproduced in QEMU. The patched
> >> > kernel retained the mapped folio and continued to evict the unmapped
> >> > dontcache folio. I did not reproduce the sleeping-in-atomic warning =
and
> >> > am not aware of an existing report.
> >> >
> >>
> >> I was able to trigger the sleeping-while-atomic BUG on current mainlin=
e with
> >> some help from Claude. The reproducer itself is straightforward enough=
, but the
> >> configuration was a little finicky. The atomic context comes from usin=
g
> >> threadirqs so that virtblk_done() completes requests from the irq thre=
ad under
> >> local_bh_disable() and the vq spinlock with irqs off, so in_task() is =
true but
> >> the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so complet=
ion stays
> >> in the irq thread rather than softirq) and ext4 -o dioread_lock (so en=
d_io runs
> >> inline instead of on a workqueue). With v4 applied the bug is gone, so=
:
> >>
> >
> > Thanks, Tal. Then I'm getting quite confused. Since with Wenjie's
> > patch, we are no longer going to sleep for dropbehind in `filemap.c`,
> > do we still need all the complex logic in the block device and file
> > system layers to move dropbehind to a workqueue task context?
> >
>
> Hi Barry,
>
> Let me clarify. Wenjie's patch prevents sleeping in a very specific case.
> The existing in_task() check covered most other cases, in that it just
> doesn't do dropbehind invalidation if we're not executing in task context
> (for example, block device writeback completing in interrupt context).
>
> However, dropping the invalidation defeats the point of dropbehind, as it
> leaves the pages in the page cache. If we get rid of the task-context
> deferral mechanism, we wouldn't sleep, but we also wouldn't invalidate.
> Wenjie's change is largely unrelated to this.

Hi Tal,

Thanks for the clarification. However, I=E2=80=99m still not convinced.

If `unmap_mapping_folio()` is the only place where we might
sleep =E2=80=94 where we might take `mapping->i_mmap_rwsem` through
`i_mmap_lock_read()`, as Wenjian pointed out in [1] =E2=80=94 we have now
prevented that from happening with `if (!folio_mapped(folio))`.

So no mapped folio should call `folio_unmap_invalidate()`:

static void filemap_end_dropbehind(struct folio *folio)
{
        struct address_space *mapping =3D folio->mapping;

        VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);

        if (folio_test_writeback(folio) || folio_test_dirty(folio))
                return;
        if (!folio_test_clear_dropbehind(folio))
                return;
        if (mapping && !folio_mapped(folio))
                folio_unmap_invalidate(mapping, folio, 0);
}

Why do we still need the `in_task()` check in
`folio_end_dropbehind()`?

void folio_end_dropbehind(struct folio *folio)
{
        if (!folio_test_dropbehind(folio))
                return;

        /*
         * Hitting !in_task() should not happen off RWF_DONTCACHE writeback=
,
         * but can happen if normal writeback just happens to find dirty fo=
lios
         * that were created as part of uncached writeback, and that writeb=
ack
         * would otherwise not need non-IRQ handling. Just skip the
         * invalidation in that case.
         */
        if (in_task() && folio_trylock(folio)) {
                filemap_end_dropbehind(folio);
                folio_unlock(folio);
        }
}

Could any other operation in `folio_unmap_invalidate()` sleep for
unmapped folios? Otherwise, it seems we don't need `in_task()` at
all?

[1] https://sashiko.dev/#/message/CAGFpFsRarmDScAQxHpCtSZxK5H4WCg4Y%3Dy0hXQ=
LjGT804ZoWkw%40mail.gmail.com

Best Regards
Barry

