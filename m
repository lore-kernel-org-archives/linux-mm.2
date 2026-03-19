Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 842321075290
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B186A6B0459; Thu, 19 Mar 2026 06:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF00C6B045A; Thu, 19 Mar 2026 06:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D646B045B; Thu, 19 Mar 2026 06:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 922346B0459
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:05:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56DF01D5F1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:05:02 +0000 (UTC)
X-FDA: 84562379244.12.DA49448
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1852140013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:05:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iTpl3wEo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773914700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnQEP1H03DOCUJYlm2puK3bdzRVMG/DV3LcuYZKBApk=;
	b=BMtGH+MWK//kpyK9cQZ4AtcHlDxUArtJbz7VqC6QBFoRRyS4LgVcskPYNmNr0+jmShfVVz
	gzlHddYbpi+QhJVC5AVt7gZNoasm8JASO+aL5qfFhhVZ0dcXrLU4AOtgVLNwgNX5afKzfg
	ERSY6FpPWUTfIxC9LBUWxsnGi3okdoc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773914700; a=rsa-sha256;
	cv=none;
	b=hyAJ7hDyE1Q4hn92uUST6JO9ZyttRUfvyfM0GLNpq5MbZD4TTBAVbqnuAWx1CQ+GIcotWd
	rN6a/1bJ3m6qfd4aP1zzb08os0mfdrogl3xoEJ3Hn2ZiYwjopmyQ6ACeDRatB4YU9ZGoTA
	oTkqr5ho4MADQcRLoOEOIoMunMGMXVQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iTpl3wEo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8C4160133;
	Thu, 19 Mar 2026 10:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42125C19424;
	Thu, 19 Mar 2026 10:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773914699;
	bh=m/MxVQHapgMbvAQv6cOPOB/Tw5sSwHzzgaJtqpzFbzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iTpl3wEocZuihDCbHxMUik4K/fHABgCVgmACutLgO0yXqLL8L/QWFmmNNkBN4pVEF
	 20JnoHgu+tJoc0e0Yn6QtFH8vWimsMB8+2AIHKZ9rGs1ifGDd4u1ss32pkMc0uGv8Q
	 BIFNLEDlDBcElS2R2E1kafKjAan6SLQrd/lUYTaL7OKQYSQVMViQMWTfaf3umekabw
	 PGQ/qmbBYTP1wzFlvsrV3MfejFtjgDilBOebzhpxXNhCsJM0I37sRfeSigSyZ0TC6c
	 Cx4nTXHU0ceb2S8LvycTWlT/PlL8Ov0ZqwPkwFKB4lBbGXD8WZcefolb6WB9l0/s6h
	 aqJ35e0LpW4/Q==
Date: Thu, 19 Mar 2026 10:04:52 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot+de14f7701c22477db718@syzkaller.appspotmail.com>, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com, Mike Rapoport <rppt@kernel.org>, 
	Harry Yoo <harry.yoo@oracle.com>, syzkaller <syzkaller@googlegroups.com>
Subject: Re: [syzbot] [mm?] general protection fault in zap_huge_pmd
Message-ID: <44ad9ec7-7e1f-4f94-bac8-8b24a7805c7b@lucifer.local>
References: <69babeba.050a0220.1b2d94.0003.GAE@google.com>
 <6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local>
 <CANp29Y4f0sd6fbsR9MhB_bqazLe59rsC_uRU5CH4h5wS4HficA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y4f0sd6fbsR9MhB_bqazLe59rsC_uRU5CH4h5wS4HficA@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1852140013
X-Stat-Signature: re4f8dwopf9ao864roytrbcpjdqmahbc
X-Rspam-User: 
X-HE-Tag: 1773914700-439327
X-HE-Meta: U2FsdGVkX19JgWZqvw6g86bBjDJxHs8C0+9XvEeNaRBYBgtLz9XKKA4qkSr4DoYTS9+bIkoXrKsql+F3GeNoRyXSMgPm/qXzV+gN7nb9HJI7zPfwbSkJT9B8qCdmNEGjdNJBm82mtz+rPV22U/6tkFOM2PHlOFe9AUMdwOrWIs2ncxTCegPR4J/c6Hkg/2MuXF2MdKu0o36FFC2TBIZT5ZObAjB0rtXKepMi0z9n5yiGtqTjoEGLU/gQzBtn4q7AGgwd1f91qxRdiov8h4H8xRwzddALJhWnESRnBxfwEQRDVw/vB2OdruxzvPMKmJt1+rlA9BxrqpQjj4Il2qzkTqkrD5ffg4ad8qdhir26dCWgesje84hn3X//IUCuZONyz7Vko70dszeJ5jkOM4WJ694QWp5N4w7s6KGxylfX78HruvEWpwrSVFAJWRt9wBfCZW33CH7IJjUQURwu0+beic2zQDsTc3M6ewcgnvHaGaJkeyTeuPZ69KarvXwp6EQd+QUEwo1q31QBz1hqLUgxz8Jl9fTFl9J6aH8p4ZdL6ap/Blv6RfAZEtbFdXOex3oGe28AtgrLL/vuLvKfUGtc+ImHbwLqksXSdmgs5a65Hek0nyHzyOSiSTl63eqAWZfjH5zUlFsxtjuAaehs6k8DS7VdHZWpDCo4iz4pQ6FdJsoCUqRLu7KU67VdpQ7nZRv4PTz1Y3dLLR/MwIjp8FpeWCiMVJn951Ed91cMZnOKSSxMfbmW2KI89S44rcuojsucSGoj07mDCg8IdyfeNEGYa+LFecGImE8YFS+gXd8Jb1JKvoApUte/uLlLQFk3Xud3pZhEj7bgkMIawslq0K/TAh5s2xIe11gSlZfv8Hp9NmaCAXBDo21v44dua0+UjfLeYm2jF7qyKw516j9EYSUBwdV2DBGMLptb2Cb4VRiyNLIVhX2ELs448fdUr9Ox2+ySCc2z3lfjVyQtiUyG5YI
 5rxJEtam
 forRQspriYGoZfw1h++JCM+02baFBU1qJRl6K0vLbKt9PJgqf/rrrzZPO6r7Qf7AWl1u4PYSrfhV5yfL4spQM9AyLYJjwXhBlDK39yujwgX3XHCOudpjp7PRdeloiWAMtxseGgV2NlQifkEXELSSa1sxKY3Mr/YKgG3kZcixp/MnwZUl9IBVnXTAx6EXuSEyB/q9RGz/2XRXP/wS1fl2PELIhpL1G1WhJIQHSMPyXPcQA5D1N6FEqy7GUeKqqANMiDKTT0XPbgRuIv1RkPxGlQgCZh6SNspER0qEabkRT8IGDJn7HneNPT43gDHhVL6eKeqQ4P/vLoVr/5vUPbsdAXKLkVA5xkUEqxiXVNtrkUBipLt86jdC3kYJWaPR8wcHrtIFiFzJb+BpQOey6qykm5poPbingMj4vKkqerpNTB2gG1NGwleQZBL+304n4qxhFQ+/5KPBl5riZGAIxpcZQZnl3bcyqNTJnQBDb8Mvcq5uFEo6dL54A6H69FqmLX8iw/I0w8j61GQjNHuj4Y/cRX9CbUkhP34RqFS0IHqfv9Q9J0TFkZEQHPJHiX/Bb4bTCg6DGpV4qoBRXrsc6uajf2V1Yau7HhG1seK7nKfJR5/BTjrHBD3BxA5pBOftxxJI7Uh7C8ZhfqLrvHo0ErZR0jDLrN8JSN4PyC4Rpkixr6CIqZaVuahfdbdck/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 10:54:16PM +0100, Aleksandr Nogikh wrote:
> On Wed, Mar 18, 2026 at 6:26 PM 'Lorenzo Stoakes (Oracle)' via
> syzkaller-bugs <syzkaller-bugs@googlegroups.com> wrote:
> >
> > +cc Mike for uffd, Harry for fix that also resolves this, see below
> >
> > On Wed, Mar 18, 2026 at 08:03:22AM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    b84a0ebe421c Add linux-next specific files for 20260313
> >
> > For some reason I have to git pull --tags to get this... commit hash locally?
> > Strange.
> >
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=119ddd52580000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=e7280ad1f68b2dce
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=de14f7701c22477db718
> > > compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=173b44da580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1537b8da580000
> >
> > @SYZKALLER guys:
> >
> > Note: the repro is incorrectly labelling;
> >
> >   //  ioctl$UFFDIO_CONTINUE arguments: [
> >   //    fd: fd_uffd (resource)
> >   //    cmd: const = 0xc020aa08 (4 bytes)
> >
> > as UFFDIO_CONTINUE (0x7), it's actually UFFDIO_POISION (0x8) as you can see
> > from least-significant byte.
>
> Hmmm, that shouldn't have happened. Syzkaller normally tries to avoid
> mutating one ioctl into another.
> I've filed https://github.com/google/syzkaller/issues/6950.
>
> >
> > It's also stating things like mmap flags wrong e.g.:
> >
> >       /*flags=MAP_UNINITIALIZED|MAP_POPULATE|MAP_NORESERVE|MAP_NONBLOCK|MAP_HUGETLB|0x8c4b815a506002b2*/
> >       0x8c4b815a5465c2b2ul,
> >
> > AT LEAST MAKE THE NUMBERS MATCH :) this doesn't help with debugging.
>
> MAP_UNINITIALIZED = 0x4000000
> MAP_POPULATE = 0x8000
> MAP_NORESERVE = 0x4000
> MAP_NONBLOCK = 0x10000
> MAP_HUGETLB = 0x40000
> rest = 0x8c4b815a506002b2
> print(hex(MAP_UNINITIALIZED + MAP_POPULATE + MAP_NORESERVE +
> MAP_HUGETLB + rest))
>
> gives me exactly 0x8c4b815a5465c2b2ul. What was the problem here? :)

ugh, yeah sorry I misread that:

/*flags=MAP_UNINITIALIZED|MAP_POPULATE|MAP_NORESERVE|MAP_NONBLOCK|MAP_HUGETLB|0x8c4b815a506002b2*/
                                                                              ^^^^^^^^^^^^^^^^^^

I read it that 0x8c4... value being the value that the preceding flags come
to but obviously |x|y|z|...|<some hex val> means it's additional garbage right?

But it's not really decoding properly here at all:

Writing a bit of code to decode, 0x8c4b815a5465c2b2 becomes:

MAP_HUGE_2MB|MAP_HUGETLB|MAP_NONBLOCK|MAP_POPULATE|MAP_NORESERVE|MAP_ANONYMOUS|MAP_FIXED|MAP_PRIVATE|unknown=0x8c4b815a00600280

So I do think that your algorithm could do with some tweaking here :)
especially MAP_FIXED, as it wasn't clear as to whether the addr passed was
a hint or not.

(MAP_UNINITIALIZED overlapping with hugetlb sizing flags is annoying, as is
how that's encoded too.)

(I put the code at https://github.com/ljskernel/mm/tree/main/tools - it may
or may not be buggy :))

>
> >
> > AI hallucinations?
> >
> > It also never returns with an error if a syscall doesn't work which means the
> > repro can run 'ok' but actually be failing on something, this really slows down repro'ing.
>
> That's an interesting point. There will be corner cases where a
> syscall is expected to fail or may start failing after N iterations
> and that's fine, but the idea is totally worth exploring further.

Yeah for sure, but at least outputting the information would be useful, so
you could have the same exact behaviour just with more stderr output?

>
> >
> > Maybe hard, but be good to figure out maintainers based on the stuff the repro
> > uses uffd -> uffd entry in MAINTAINERS :)
>
> It's easily doable, but there's a problem: uffd maintainers will be
> CC'd whenever uffd is used in a reproducer, which may not always mean
> that it truly caused the crash. We do minimize reproducers, but there
> always remain some weird cases where unrelated syscalls persist e.g.
> only to force some specific timings or to get specific file handle
> numbers.

I don't want to speak for Mike but will anyway ;) [speak up Mike if you
disagree :P] - I think it'd be fine to do that and just let it cc- some
people inappropriately sometimes.

Or you could narrow it down by first making sure it's an mm bug and THEN if
uffd in repro include uffd people?

>
> That's why we mostly rely on stack traces to identify subsystems.

Right yeah.

Cheers, Lorenzo

