Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CA3C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9456B0093; Mon, 14 Sep 2026 05:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283C66B0095; Mon, 14 Sep 2026 05:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14BDD6B0096; Mon, 14 Sep 2026 05:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC0CD6B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:43:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCB6E1A01C0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:43:14 +0000 (UTC)
X-FDA: 85211879508.24.CF16FED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E771340004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:43:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbuxahmN;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789378992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv8rqtiGZqyi1hpD7UofsDSzonROv6KDIfnEAf5fFS4=;
	b=nbOXhc+DeYz0Tgtdz96xGo6Kywfg69RL88R3r6qS7GvIFwYVVtgmC0AB2pJ/EGRlx2LW7h
	xUNlaz+yVmwTeAh5ePxgutZhYRKhR2+ch+2ojDJ0vY03VsLuncfD+Lb8cZxOTuWZlljMOi
	e3TxsqGm3pwIVOFd95RL2bt1Va5m5n8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gbuxahmN;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789378992;
	b=RQp/QQRhHrW3VT/hueB/zY2q+jwf6NkTuxnB+TgRSQ/pjfLo943pCeAkt255Y2zGjF74xz
	mD2e0dnPMOs5qam9Tymv4Jm1gMLMpych3okkI/ZmYFNEKCAx9XN4VhGmyyLeGwP5h2MiG4
	17aMQ7vcaYwYy9PsaeUzZQMpqwn3Njs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3262D60142
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD841F00899
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789378991;
	bh=Kv8rqtiGZqyi1hpD7UofsDSzonROv6KDIfnEAf5fFS4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gbuxahmNQpuV4vHz7voacM4XHxXWQPfYvPaa0ii2ZYcsvBlbLgdDmkgXRQ1ErgAWw
	 unKidD8YVaNPzsHx3MTmTmPvLff4TBWZ8EEasP1Pw3p9rYhtzow8eS4nxNn1cJrXOq
	 ooGci8+SOFAKO+WU2wP38uUzUo4JOpIIJC+gcZ6U9jMnyqs0xWa6thLYzyymKWHNJv
	 OOoIz4k0FSyu8npreAl7bRe8EXfIaQ/AWv7nPCPmrV4Hd+kwqNv0ZV2LpkFO6amlAz
	 +Y8Lz/wp0IXTnjGrNFRCaERHC7soBD3GyXPKssrtB9QumOXZJ5Pnr/w0Wbd4Q3lJyU
	 IUqUagf43k6Ng==
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910cadeb4so268229285a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:43:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBycOYQAkLt9l7YfQPVnmRfrqv5WX3zasvWUkfgifTx1nnSxjD/HF55gur1GG9inTBx+X7KqhN3MEQ==@kvack.org
X-Gm-Message-State: AFuF++lVnE3x6Ll0GA0pLoQLB17CQXligQXKSkyPajPOEdBWrESrgtLF
	9qBYuKsrHGAWFReJ+j07PTJtVmUxZglVsmyQ1/ptov+SANJuTI8bHFyWJq1Zr0KTdTptNDHsH3u
	9kLm2czyyiTzXh4PUA4+l7HrOoKYwkL0=
X-Received: by 2002:a05:620a:4888:b0:939:d762:e2d8 with SMTP id
 af79cd13be357-93a299943efmr246987885a.31.1789378991186; Mon, 14 Sep 2026
 02:43:11 -0700 (PDT)
MIME-Version: 1.0
References: <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
 <4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com>
 <20260829111621.41ed2bc9a0e99e3367eb96c3@linux-foundation.org>
 <ef160933595c365f2c47597b260bc7ecd98ed7ce.1788029516.git.qiwenjie@xiaomi.com>
 <076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu> <CAGsJ_4xMK=rPXCH5OiCOYHKRQp-w+xDJQusJ_ykbuAuLZr+8bA@mail.gmail.com>
 <1e5118a5-6b61-49d0-85e1-825e22059241@columbia.edu> <CAGsJ_4wj6XvPB+QF+_X1BJ_8Y2sZEEFAw6RaJJz-cHaDWLkxaQ@mail.gmail.com>
 <65a2c7df-0d2e-46de-9580-01e9c35a7e32@columbia.edu> <CAGsJ_4zS+UehT4wuTuTVjK3s3mhzp+dku8M-Of9cF=CN82aRow@mail.gmail.com>
 <hbki3yc23dr5fkre5phwx2ev6yjfn3ooodan37uo3at53y3gs2@kjyxyb34s5bi>
In-Reply-To: <hbki3yc23dr5fkre5phwx2ev6yjfn3ooodan37uo3at53y3gs2@kjyxyb34s5bi>
From: Barry Song <baohua@kernel.org>
Date: Mon, 14 Sep 2026 17:42:59 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xNLEhrCZR-7ZAxBnYV8BDzuQT29yT419mObVRGH71AVg@mail.gmail.com>
X-Gm-Features: AcwNN1VW7ZXNpSPCOSVUlF1vVmj1aC20DEJiwVHJ6AoiSxuUJwZ0j8Znnu0_b2U
Message-ID: <CAGsJ_4xNLEhrCZR-7ZAxBnYV8BDzuQT29yT419mObVRGH71AVg@mail.gmail.com>
Subject: Re: [PATCH v4] mm: filemap: retain mapped dropbehind folios
To: Jan Kara <jack@suse.cz>
Cc: Tal Zussman <tz2294@columbia.edu>, Wenjie Qi <qwjhust@gmail.com>, willy@infradead.org, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, axboe@kernel.dk, 
	trond.myklebust@hammerspace.com, jaegeuk@kernel.org, chao@kernel.org, 
	qiwenjie@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E771340004
X-Stat-Signature: 8icihc8qinf3fko5wnx5d1muhrmn3n1f
X-Rspam-User: 
X-HE-Tag: 1789378992-328833
X-HE-Meta: U2FsdGVkX19e1okc9oowkQby4LjcRQrIScYcAuhlmduKKENxpMtDLHTWU4uD3F1yXtlAOd9BqecS8Kfap3QtFFsx2uZSqoDG2iMmFIqMt1rFYO1wm14tcI6ozXkKaJdy9iVIJEsxnkpWiN41F/YaHdST/c8bF/JL8qOsVMIKm+xtdanrTvUC7tjgrYHIiIzCIGkLZnAoq4BiRUg+FHVkTZRb9rL8igWz3nyLuxCdVyypvTi70C+2e5aCjJDfQ2bvpYsTbRz8/m17/3KbVh/LF+NfUKDmmmW8LMDULQhOiMsx0zFG+r76RowYuA2Af6i9gjyX5OUBxJ0vtTK5gNnT8Emn5ggVIdwd5Wfi2CYdNbL92jfogkqV/RpDGpZS8XM2ZRfR26aevdoargQEZSy6wAvyBkhLm51kFyrbbfyXbukN+PXzytDRYgU3xcMGFsicakcaAfYvG3EEJnAKA/MjPLiw2gKBkIqcNWBfiIs6n/qYCs83Ot2n1iRc2Iy6bcFMAbWO9BZeVPL1nHfPr3c4x3b3cXrQnVOoDDvbIT5K8VOlIksr3whCY+BVTfoYxYY0d0IP/w0+vHKctFRpbYlraS8SkMB8pBgwdkmqJyI3ezIsHbzdD2+lTQQqE2P2qbsga5Dg4D9jbhv+0xNbWgnd2UcjX2KDdoVMbelOhPVI6bZlvDJ5hYb645izwH19/CLtnd2Fns1e6fyvbqNpF3mD7bGjBfUp26SuCfUg9v20XprX89KiByoDedgT2vZ3B8Mul5J6n9xmMGh9D/YX1T19PTa08B/7vuKFc4cQ9wxxP5gaxd0Y0r63kvhcm0S2BZ4XELfUoMSccOt1SyELiGm0PWj7SYGUB2aBit6zRydRE0paKi6R+FjBdplZGDQM908OaL2EoEZXWiNxYujtUYlFrCR92JeyNDxfqpjnH4qXzyu3Cxte18WXQrlhGWgiQ3VS9Vv9HIZSNE9lxBEXNOj
 aGUmNvqV
 jI3Mf+z5rMUAZaqVdLAMgqQkoeU5uE7Cn/hQOwXVOzWMVRPIGA0YKqEPecWON8Aqk/o3mtpCX9ofGBTg+kELjv6fA1QgaXj0hTwZrRqusBExcfWL8/AirnX3tDk822+mH3S20WkV3lF7Hi5Ke6NifRTXdMEWBjE/NDka2ny3vo9FZVxsgJJRjRavwj60vZhPAi6xDW1djcDsOvxrzJa9YSW5tsqAA7H3c57oswaquU/ekSukoQMa7W3sGSvk5dfYAnBl3SM5HcF83FRlzQbaPy14xB1BbvRFbMvSTw5psOCDZ31r6BYi7c4+GlPHaJIRVlj0SlzIv+VyiyMGwJQed2O2YbuTHRxA4/Y724hDGUROwSB5SVwfKUBdJRYEMuontV1NHoMdBgeXa6u4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 5:33=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 14-09-26 09:09:32, Barry Song wrote:
> > On Mon, Sep 14, 2026 at 7:34=E2=80=AFAM Tal Zussman <tz2294@columbia.ed=
u> wrote:
> > >
> > > On 9/13/26 6:51 PM, Barry Song wrote:
> > > > On Fri, Sep 4, 2026 at 6:36=E2=80=AFAM Tal Zussman <tz2294@columbia=
.edu> wrote:
> > > >>
> > > >> On 9/4/26 12:28 AM, Barry Song wrote:
> > > >> > On Sun, Aug 30, 2026 at 7:59=E2=80=AFPM Tal Zussman <tz2294@colu=
mbia.edu> wrote:
> > > >> >>
> > > >> >> On 8/30/26 6:25 AM, Wenjie Qi wrote:
> > > >> >> > From: Wenjie Qi <qiwenjie@xiaomi.com>
> > > >> >> >
> > > >> >> > Fault-around can map ready dropbehind folios without going th=
rough the
> > > >> >> > normal page-cache lookup that clears dropbehind. A mapping re=
presents a
> > > >> >> > competing cached user, but writeback completion can currently=
 unmap that
> > > >> >> > folio. A later mmap access must then fault it back in.
> > > >> >> >
> > > >> >> > Retain mapped folios instead. For a mapped folio,
> > > >> >> > folio_unmap_invalidate() can call unmap_mapping_folio(), whic=
h takes
> > > >> >> > i_mmap_rwsem and may sleep. Retaining the folio also avoids t=
his path when
> > > >> >> > folio_end_dropbehind() runs in non-preemptible task context.
> > > >> >> >
> > > >> >> > Unmapped dropbehind folios continue through the existing inva=
lidation path.
> > > >> >> >
> > > >> >> > Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pag=
es when writeback completes")
> > > >> >> > Cc: stable@vger.kernel.org
> > > >> >> > Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
> > > >> >> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > > >> >> > Reviewed-by: Tal Zussman <tz2294@columbia.edu>
> > > >> >> > ---
> > > >> >> > The mapped-plus-dropbehind state was reproduced in QEMU. The =
patched
> > > >> >> > kernel retained the mapped folio and continued to evict the u=
nmapped
> > > >> >> > dontcache folio. I did not reproduce the sleeping-in-atomic w=
arning and
> > > >> >> > am not aware of an existing report.
> > > >> >> >
> > > >> >>
> > > >> >> I was able to trigger the sleeping-while-atomic BUG on current =
mainline with
> > > >> >> some help from Claude. The reproducer itself is straightforward=
 enough, but the
> > > >> >> configuration was a little finicky. The atomic context comes fr=
om using
> > > >> >> threadirqs so that virtblk_done() completes requests from the i=
rq thread under
> > > >> >> local_bh_disable() and the vq spinlock with irqs off, so in_tas=
k() is true but
> > > >> >> the i_mmap_rwsem down_read() sleeps. It also needed 1 vCPU (so =
completion stays
> > > >> >> in the irq thread rather than softirq) and ext4 -o dioread_lock=
 (so end_io runs
> > > >> >> inline instead of on a workqueue). With v4 applied the bug is g=
one, so:
> > > >> >>
> > > >> >
> > > >> > Thanks, Tal. Then I'm getting quite confused. Since with Wenjie'=
s
> > > >> > patch, we are no longer going to sleep for dropbehind in `filema=
p.c`,
> > > >> > do we still need all the complex logic in the block device and f=
ile
> > > >> > system layers to move dropbehind to a workqueue task context?
> > > >> >
> > > >>
> > > >> Hi Barry,
> > > >>
> > > >> Let me clarify. Wenjie's patch prevents sleeping in a very specifi=
c case.
> > > >> The existing in_task() check covered most other cases, in that it =
just
> > > >> doesn't do dropbehind invalidation if we're not executing in task =
context
> > > >> (for example, block device writeback completing in interrupt conte=
xt).
> > > >>
> > > >> However, dropping the invalidation defeats the point of dropbehind=
, as it
> > > >> leaves the pages in the page cache. If we get rid of the task-cont=
ext
> > > >> deferral mechanism, we wouldn't sleep, but we also wouldn't invali=
date.
> > > >> Wenjie's change is largely unrelated to this.
> > > >
> > > > Hi Tal,
> > > >
> > > > Thanks for the clarification. However, I=E2=80=99m still not convin=
ced.
> > > >
> > > > If `unmap_mapping_folio()` is the only place where we might
> > > > sleep =E2=80=94 where we might take `mapping->i_mmap_rwsem` through
> > > > `i_mmap_lock_read()`, as Wenjian pointed out in [1] =E2=80=94 we ha=
ve now
> > > > prevented that from happening with `if (!folio_mapped(folio))`.
> > > >
> > > > So no mapped folio should call `folio_unmap_invalidate()`:
> > > >
> > > > static void filemap_end_dropbehind(struct folio *folio)
> > > > {
> > > >          struct address_space *mapping =3D folio->mapping;
> > > >
> > > >          VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> > > >
> > > >          if (folio_test_writeback(folio) || folio_test_dirty(folio)=
)
> > > >                  return;
> > > >          if (!folio_test_clear_dropbehind(folio))
> > > >                  return;
> > > >          if (mapping && !folio_mapped(folio))
> > > >                  folio_unmap_invalidate(mapping, folio, 0);
> > > > }
> > > >
> > > > Why do we still need the `in_task()` check in
> > > > `folio_end_dropbehind()`?
> > > >
> > > > void folio_end_dropbehind(struct folio *folio)
> > > > {
> > > >          if (!folio_test_dropbehind(folio))
> > > >                  return;
> > > >
> > > >          /*
> > > >           * Hitting !in_task() should not happen off RWF_DONTCACHE =
writeback,
> > > >           * but can happen if normal writeback just happens to find=
 dirty folios
> > > >           * that were created as part of uncached writeback, and th=
at writeback
> > > >           * would otherwise not need non-IRQ handling. Just skip th=
e
> > > >           * invalidation in that case.
> > > >           */
> > > >          if (in_task() && folio_trylock(folio)) {
> > > >                  filemap_end_dropbehind(folio);
> > > >                  folio_unlock(folio);
> > > >          }
> > > > }
> > > >
> > > > Could any other operation in `folio_unmap_invalidate()` sleep for
> > > > unmapped folios? Otherwise, it seems we don't need `in_task()` at
> > > > all?
>
> We do need it. folio_unmap_invalidate() calls filemap_release_folio() whi=
ch
> calls into ->release_folio() handler and generally filesystems are allowe=
d
> to sleep in this handler. Now usually they don't actually sleep there but
> they definitely grab a lot of irq unsafe locks there as Tal writes below.

Hi Jan,

Thanks very much for your explanation. That makes a lot of
sense to me.

Then, based on the above, I am getting into another confusion and
have another question. If `release_folio()` is actually allowed
to sleep, and some filesystem might sleep there in the future,
wouldn't Wenjie's patch [1] make sense in that case, as it
guarantees that `->release_folio()` is always called in a
sleepable context, while `in_task()` does not provide such a
guarantee?

https://lore.kernel.org/linux-mm/20260820142956.1414337-1-qiwenjie@xiaomi.c=
om/

Best Regards
Barry

