Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73848CD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 14:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702196B0005; Mon,  4 May 2026 10:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2866B008A; Mon,  4 May 2026 10:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C82B6B008C; Mon,  4 May 2026 10:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6826B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:16:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB34E160122
	for <linux-mm@kvack.org>; Mon,  4 May 2026 14:16:38 +0000 (UTC)
X-FDA: 84729938076.25.004934C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BF1C118000F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 14:16:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EEZJoSA2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777904196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNZRK1xzyieW295ShspfGtTk8+AaEYUV8qNPdWcyUvs=;
	b=tCcWd/PQaZ+2YbhhsoS97mL7k3LvJwWb8UN3qUi+3V60cR5fxGYBLznLFUScRo+jpCxTJ+
	C4oQtKGolxVG7NuugeGF8+jnMEDVjdiB0v5CzfP5q/AorHTLeTFx2k4u2PSxEcMXC0eQls
	eCUJexxt4vG3Af29V+nxPkZm+x6YQL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777904196; a=rsa-sha256;
	cv=none;
	b=PNhAAqWZtjJoa0nnbRj/u69VDmqmUSF4bsrs1RFhZSR0wQfUGPzN8gxG5xgfpw3B82jli6
	xwvD6MMS37WGFNLZAfycuIV4vRY1luO1Ti5Xi6hvcQrXOOje94/mWV+Cd2J2ofNxHeDVEa
	IN95b6GiOobpsIWYq4edFHYZ5jwRTC0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EEZJoSA2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FA5760142
	for <linux-mm@kvack.org>; Mon,  4 May 2026 14:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE67AC2BCFD
	for <linux-mm@kvack.org>; Mon,  4 May 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777904195;
	bh=dnulhm1JTuoUEhQzuO1u5rEt0FwJiLQjQxWn1rCEVQ4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EEZJoSA2+V1bS9N6/kBUrA73Kbqtv4rr5pK0ImtIEOP8hp3g/Pxpx3OB5nfBWsQkk
	 JTEXv4tAWXlTHtQj1YfWReoHeA2fuK78sq+jKA9LGBnAV9zfafUmGPkGTDF2a+XBKT
	 +Uj7+VoYbC8HwONiur8ukdewMwXCdtwSsCNlaLtM2b4MGnkCWPqRP3SJjZikftuCaL
	 Zml9OhkupD9qECWzXBsF54LDbks60MTExeOShwnCEz7JpZgbYDjwAIhw4paXPT+PST
	 uFaAxYZBh+fDrl8m4NnNjoZ/ehcrAwyzSNeHoJPSGdvmnM+nA216iRM7s/dgE18WlP
	 U21yQQlu9E1CA==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-899a5db525cso27283156d6.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 07:16:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ95P1TNsedQBuClBuaIAZAQSLrps247vQ7tL0XdqcLlXXB7L8NyianHIumQ1RwDZRqzTqAffovLaQ==@kvack.org
X-Gm-Message-State: AOJu0Ywlz8R0ZaFZmTyMjF11pJ1Iyfpu41INoimt126LW/kVeu7CGG59
	M7UQjc62kh7v0ITJvDp4SDi7VcZqpUJRu1+0akOXsrd/252i/JGQk6dUVIVwL5g7CaiQgyjGAAH
	Biwzr7GCADUKavfx+xCDImMobI/z7LVM=
X-Received: by 2002:a05:6214:27c3:b0:8a4:db54:b3a4 with SMTP id
 6a1803df08f44-8b665d1127bmr158681076d6.7.1777904164104; Mon, 04 May 2026
 07:16:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <yezmezj26xntushmylductlmytfgvwsnbnzlhffkfwugfxkt6m@gleq22spziyk>
 <CAGsJ_4y8JtCxEy9hVxVd8eaf8D9WC8BcRQp9afUVu=FJA1-awA@mail.gmail.com> <n5vsmp6ingbhfztl6wzcwmrz56gkkfbpzardk43scr7rcgqsw5@evtnov34c5bt>
In-Reply-To: <n5vsmp6ingbhfztl6wzcwmrz56gkkfbpzardk43scr7rcgqsw5@evtnov34c5bt>
From: Barry Song <baohua@kernel.org>
Date: Mon, 4 May 2026 22:15:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xM8W5NHB4J2c1dVyXhu9SHAK_iiVZPAtH0fMvJoz77ww@mail.gmail.com>
X-Gm-Features: AVHnY4LS13GrbYqayhsefNP68ODiwhwvddGMrFC2vbCyG8eLOAO_PeI0iks995A
Message-ID: <CAGsJ_4xM8W5NHB4J2c1dVyXhu9SHAK_iiVZPAtH0fMvJoz77ww@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF1C118000F
X-Stat-Signature: 1itihoiu6a7gpbpm8php73drmfhhbx75
X-Rspam-User: 
X-HE-Tag: 1777904196-761818
X-HE-Meta: U2FsdGVkX1+rf8QmCrAN3/n2T1QbI5FdpPYPtPG76gJvVOQNmP20JEUEo9foP/jWwim0QjOAuYn+1Z+3LP+SPPbm8Q67QiTwoUPFpdxtd05+V9WvukuRAj4uO4NkG5tonC9soiWyKUPPbWADVvdF+JY131mMtDNRYUh4GpH0IgTglxH0GxPpAE6iDxI5b4+qOvhFxy/IZxIub4cSAoqNuZTWH8ctqMehS/kZlkMFH9ys7dDOf85+gUiDLgwHqwXyHndecznbitgp8JPrF9oHpFj8LHuv3KRBHb0reNgm7NDW7xjeRhpDoPiAhTAng3QcZvgOYHOppvRJ+Fs5MNN0lB5t4HmRyKglGnYyK/7LUMHDDFs5qrlLz/lXDZ6Ax9mUYjXgqalFuKVg54wNSyRJpcv3XWhi5a+NoCz8o91KfwQF3eweTKPtqB4i9JtOKbgFNxVEIBT4/p7SJCwLgpS0l1YaBbyzEgUR/bKS7e8YTb4AigOBhsV0hxzFuUzNfgRrzf2UdiOpjSyufH6clNO0qB7yZa/QJtiPPCzXMbNdGiEK+Eb//fZCGnpt+o0JZ3OetQvryhkekuaKzGrrKS6SqLAMy8q5+yVzguLSkiqf2xKWixXkJsSVqnslW5NO1ylWoc6MdUkiJ2TOz2XNpq96/+9AVmGkWOZHHv+xSGtVbahqBMmS/RJz2+YvdKqIED6V0g9wocTPa7j4/HSBvci3A6APYVsB1Q+JnVK5bYQ8ApQTna0H6h+XX7TNroX/m9omsN4KrEwjtCVR13YnsT/2RpIyijiLYset4qd/Y6bNXcKrQaFkdYdLGUapnzoDk0C5Jg2v413fkJUHYa4msuYe2KDu+6vnGwc/xcQI7ewy8CQ6PA+hH8If0SquzRtjeuet3+XYFzvfs/yaXECIy6eQwyWNSZArhnLF9cENlj+80yrVaY8uaVV/7OrtJg8yTNK4/MBOUwO6nUsAaLvJnjq
 e8YCVDJc
 OplTiitMrAo8wwMerXJviSS6xeWFb5ciAZtw+0c21Fc9K7gUen5b+ZemeKmvmztwtEmTVJ6+DycvVm+EvVvZUSpyFVGZb6G1L+TgMkhsUQL0hNGob0GRX61IFzZPzx6eS8xDqWT9FcgLoZCvUpqbI7AH4XEzJ1kxIt0H/KkC8muYJE69bOopd189msCH4NK/wt49d9gO9LWvUofGLXPoVGX35QkX3l57r83D0a7oD+XVQkxYshv/fCckrNoeYtYKLHe/3ynTG5PkBjuQCk/tp05fnExN3ZllTDin3gDsqPkBMBxZgfQOIlA03JflwU6lmB7m4qiqiYY3xPK1JLEmTX438QpbXZ22XjRxj9QeuAD0bDUmvjKB74K7yboMv95/v8BcWUGqdJn7jeP5p/ciZCxszSzWQoOybxrtO6/qpYdKdUw7DO7MjKfYawTiWVklZBQdb1lyEnpkDRoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 9:04=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 04-05-26 03:55:43, Barry Song wrote:
> > On Mon, May 4, 2026 at 2:17=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> > > On Fri 01-05-26 18:57:52, Matthew Wilcox wrote:
> > > > On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > > > > On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@inf=
radead.org> wrote:
> > > > > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > > > > 1. There is no deterministic latency for I/O completion. It d=
epends on
> > > > > > > both the hardware and the software stack (bio/request queues =
and the
> > > > > > > block scheduler). Sometimes the latency is short; at other ti=
mes it can
> > > > > > > be quite long. In such cases, a high-priority thread performi=
ng operations
> > > > > > > such as mprotect, unmap, prctl_set_vma, or madvise may be for=
ced to wait
> > > > > > > for an unpredictable amount of time.
> > > > > >
> > > > > > But does that actually happen?  I find it hard to believe that =
thread A
> > > > > > unmaps a VMA while thread B is in the middle of taking a page f=
ault in
> > > > > > that same VMA.  mprotect() and madvise() are more likely to hap=
pen, but
> > > > > > it still seems really unlikely to me.
> > > > >
> > > > > It doesn=E2=80=99t have to involve unmapping or applying mprotect=
 to
> > > > > the entire VMA=E2=80=94just a portion of it is sufficient.
> > > >
> > > > Yes, but that still fails to answer "does this actually happen".  H=
ow much
> > > > performance is all this complexity in the page fault handler buying=
 us?
> > > > If you don't answer this question, I'm just going to go in and rip =
it
> > > > all out.
> > >
> > > I fully agree with you we should verify whether the retry code still =
brings
> > > in real-world advantage today with VMA locks. After all the retry log=
ic has
> > > been introduced in 2010. That being said if there are realistic loads=
 where
> > > one thread needs VMA write lock while another thread is faulting the =
VMA,
> > > then the latencies can be indeed extreme. For example things like cgr=
oup IO
> > > throttling happen on the IO path and thus can throttle IO of a low-pr=
iority
> > > thread for a long time.
> >
> > I=E2=80=99m quite sure that swap-in and VMA writes can occur
> > concurrently, and this is fairly common. For example,
> > Java GC may use mprotect or userfaultfd on a small
> > portion of a large Java heap while other portions are
> > still under do_swap_page().
>
> OK, makes sense.
>
> > If we start exploring different approaches for anon and
> > file, I agree I can revisit this on an Android phone if
> > there is a real, serious case where a file VMA can be
> > written and a page fault occurs at the same time.
> >
> > Please note that, as an Android developer, I am particularly
> > cautious about priority inversion. A recent issue causing
> > severe priority inversion is zram attempting to support
> > preemption[1]. When a task performing compression or
> > decompression is migrated to another CPU and then preempted
> > by other tasks, high-priority tasks waiting on the mutex may
> > be significantly delayed, impacting user experience.
>
> Well, container people are concerned about priority inversion as well. Bu=
t
> usually this is with coarse lock (such as global filesystem locks) but VM=
A
> lock is specific to a task (and a VMA) so there the opportunity for
> priority inversion looks more limited.  But the example with Java where G=
C
> thread can presumably have higher priority than ordinary Java threads is =
an
> interesting one.

A major difference in Android apps is that each thread can
affect user experience differently. And it is not simply a matter
of whether a VMA writer has higher or lower priority than a
page-fault (PF) thread performing I/O.

For example, thread A handles a PF; thread B attempts to
modify the VMA where the PF occurs; thread C tries to modify
another VMA (requiring mmap_lock in write mode) or iterate
VMAs (requiring mmap_lock in read mode). Regardless of
thread B=E2=80=99s priority, it holds mmap_lock in write mode while
waiting for the VMA lock. The usual pattern for a VMA writer
is:

mmap_write_lock()
vma_start_write()

As a result, thread C can be blocked even if it has higher
priority but operates on a different VMA.

In essence, when a PF and a VMA write occur concurrently,
high-priority threads may be blocked even if they operate on
different VMAs, not necessarily the same one.

Thanks
Barry

