Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00722C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:41:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096806B009B; Thu,  3 Sep 2026 23:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0478E6B009D; Thu,  3 Sep 2026 23:41:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78C16B009F; Thu,  3 Sep 2026 23:41:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C366B6B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:41:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5292AA0769
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:41:53 +0000 (UTC)
X-FDA: 85174680906.06.39BA8A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7FD84180003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:41:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZ9xVS1x;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788493311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjLj2v2JqPShJ+ZjLlUvr8Tq3MJRqY6cKsI0djgLyoc=;
	b=dIxBttyKjI+4o7yaID0OT8MtSF3ZTJeuKqWTQzUPTYI9oemKT45knZsZM09p3tm0DOr1Ab
	hb2POGfUijEaH/XjU/i/hd34A3YzkytxTbpI0bI6Gzu9L5AHEhRM1R3zJcZdfWaqj3G10Y
	dkYHjPLuSXuwMzDw+nwu//tZLzHg3Ac=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZZ9xVS1x;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788493311;
	b=5vOT+1Ulv/PnMbp0cD6KT5Z75CLardImg8OW6wAbUfqAVqmCHmHQ7yN77LyoP6J1FI3lhC
	XJSDCVdk+JvXSespQ6nZyCmBVU+2MTeLg8gMockKIAtXvYh5J/rbOBHw01PoPJfu5Yt4bU
	hqaslpWeRyAWtKt8yCqED5TpEcX7Des=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2C6D60A65
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5B71F00A3F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788493310;
	bh=PjLj2v2JqPShJ+ZjLlUvr8Tq3MJRqY6cKsI0djgLyoc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZZ9xVS1xKz+94BNHwrcuG3y6OdkK+ACBsZpAjVtnXH/iBA6eW/7sN6xbDP3NS+7xy
	 tW/mQojwgkXXwaOE1dWwJkaLjJLkUbZs6uZNCa3m08LcWHDQ2L7/au6KAcOOdyMaf0
	 u32hZiXKhYqBl22+VBHPokLeg26t5pfehx5+q95yME3iWQNBpYBJbViUtaSafVqbww
	 0/cuZNKXRC9APxb5S0mNmDovkSSDgYmugH/xcVOwnBr71AkEBTBvacIEDM1k/lkN1r
	 hsMpIOz/5iRZ8UM+dvdiwYlCPvCcnIuZ14dkwToa6YXQR5HuPNTm+NrEwRtoCFjJgu
	 OQG4b9YeCZ6oQ==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-936623c6dd3so203410485a.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 20:41:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx10nZdzb9RVr6TFH/8U4DkaGJYwqeMZG2cSFI/QW96fxJ3BuS3B201nG+vJlAnASAJ492x+RYQVg==@kvack.org
X-Gm-Message-State: AFuF++l9ftRLLOrSwBotXAntPLntfMiaTYHnbTNeZPav/JvJ1ieU2N1C
	KSnef9f8qKJzSnQSliTZjH8Ja8taJ4pHPQw5pH1nw1AXIS5XRsPfSsbAKAAzj8j2pjk8sNLM2+C
	qFrOK1ZnX6KJbiBlejDfRUINdN8hCcHA=
X-Received: by 2002:a05:620a:19a8:b0:934:a1e4:cfee with SMTP id
 af79cd13be357-939814eeeeamr166734585a.11.1788493309996; Thu, 03 Sep 2026
 20:41:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-4-hebaoquan@kylinos.cn> <CAGsJ_4zFoYNuuVsTR=T4Qtxc5iVBPCK8rgiKa75VqNWqqcO=3g@mail.gmail.com>
 <apeWczinE0zVkDAG@fedora>
In-Reply-To: <apeWczinE0zVkDAG@fedora>
From: Barry Song <baohua@kernel.org>
Date: Fri, 4 Sep 2026 11:41:37 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z6SKTUeV2=OH67QPm4+JE_Lvw0rRsd3=H5F8EX=swBYg@mail.gmail.com>
X-Gm-Features: AcwNN1X7FGqQukvcmTZ70-TXPMIj5Ir_ocRGCx8qhtfecSgxhslsttTWjRLs-h8
Message-ID: <CAGsJ_4z6SKTUeV2=OH67QPm4+JE_Lvw0rRsd3=H5F8EX=swBYg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: u8dzit9uuirubbm1pw3dgi1hsrp48zj3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FD84180003
X-Rspam-User: 
X-HE-Tag: 1788493311-99619
X-HE-Meta: U2FsdGVkX182RN3PAdGRm5GsQCfksnw028je1OsOUdBSVu8/HvNHtmscdiaAgwGZAyDQyni5rkR9V10a3J/+CNO2Gmk6peyn9/m8FKlwmBJG38YFVX/id8oXIT6smAfjyQjhuUlnxEGzu4w1fMSWNkGLEij7atfYaQEwyTKYl+IOy/X/p9ycfptbDYL/SKa95pSeHcvJmzPFlEUnnxiihe3SThqaMIkb/KHT+lrvz/MvqPN7+qeO+pG4sjHd3HtDY8WAGCDpWhpbLik1+pY+QR4ryQyBq/TR2ty2ryNfsmAJMYAwE11v2YZXQEhXKuyNA4I2vK8S5gUxsmKSm3yYa2hJABj2RdwYjFOSArwX2hPvQSCRZ58Wj3QAPg5G3t3onlmpnYn+PvusrNg7RzTZBr9HpGSulvei3kiGDJOu8yLXv82TmrqHRA9XY8Gz91igc4OnIIUMBwevkufRCXHBwPjjjcKRMtQs1+8iN7xUqk6FJgsnV225qm75QZkxj1+v/7t9foY1WXQY424KqVE9oqJkvwGQ37sUiqV7/FFchUgxdU92E4WDEWUO8qhJQ0jtymKrEmUWfNVtx0411bBHrLxwsuup965hzPmXYe11to0SmBL7GKdICwaiS3cWnUxUDEVMNuoS+u4pKHzVPu5QAgrUdw2JWW1EsJaYL6kp4D4t99VGuzaufQBMTs4rjEn3LLZFwQgIWD7E0b0JcFs5jgiKyqjX1bA899UGqRaXfsUf2159CrsCUnDXzmslO10vu4NC6pycIwP0YsOyQDmsJOPE5XjvGZZlNWIZHgn4RYeb48AVUiUI+NMLkm6A/4qRTCvlupYXdTJBNACUXScPOwSKfwiMSRE4NYPXvKrnrzDK8+IhvGdTgHU5aUPpp2M9xvZ2hXY1PDrFdrGgPsUHQ3DlmBddHGUit3evhMV5QVFbkfYvs5kvJ72BzrFtudNJvsLaHo08WNQu3dYftMd
 /AmPlnQS
 Yqb1VTT38+40lxM07+RU1uxdy30qC4cGCGlVkGicPG6FsEiU7pwRShIoHKOc1cfaJe4eD2O6IHfOpkXKte6shvkfioziQo7/+IiCBmBJWkMszc7ZwfSGKMUY9nn+Gr+CVxULe1dW/i737DJtSlcOGWPr20CcSh46eqzenHJyph/0d4TpIvAdSgsB5B1STTB/SlRd7xL3Ra6oH/xBJCMx/uprUz230WaVDgm+jqvOugmUtBJ0gYCfkrd/TNWSRJjLM2p2K1nAO6lXigyJMixgDXnBVsqdM9hJTYqJw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 11:22=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 09/02/26 at 07:53am, Barry Song wrote:
> > On Tue, Sep 1, 2026 at 2:38=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn=
> wrote:
> > >
> > > The aging walks into every PUD and runs the PMD-level Bloom filter
> > > on each PMD. Add a coarser PUD-level filter (pud_filters) one level
> > > up:
> > >  - walk_pmd_range() now reports whether it found any young leaf entri=
es,
> > >  - walk_pud_range() records that in the PUD filter, and
> > >  - on subsequent generations, skips the whole 1GB subtree when the fi=
lter
> > >    says it had none last generation.
> > >
> > > The double-buffered filter flips with each new iteration, so newly ho=
t or
> > > migrated-in pages are re-checked promptly rather than suppressed
> > > indefinitely. force_scan walks bypass the PUD test, so manual aging a=
nd
> > > newly added mm's always rescan and re-populate the filter.
> > >
> > > To keep hot regions marked, also report the covering PUD from the rma=
p
> > > feedback path (lru_gen_look_around()), so regions whose hotness is on=
ly
> > > observed by eviction will be re-scanned.
> > >
> > > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > > ---
> > >  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++----=
-
> > >  1 file changed, 47 insertions(+), 5 deletions(-)
> > [...]
> > > @@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mappe=
d_walk *pvmw, unsigned int nr)
> > >         lazy_mmu_mode_disable();
> > >
> > >         /* feedback from rmap walkers to page table walkers */
> > > -       if (mm_state && suitable_to_scan(i, young))
> > > +       if (mm_state && suitable_to_scan(i, young)) {
> > > +               /* the PUD entry covering the young PTEs scanned abov=
e */
> > > +               pud_t *pud_p =3D pud_offset(p4d_offset(pgd_offset(vma=
->vm_mm, pvmw->address),
> > > +                                                    pvmw->address), =
pvmw->address);
> > > +
> > >                 update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd)=
;
> > > +               update_pud_bloom_filter(mm_state, max_seq, pud_p);
> > > +       }
> >
> >
> > Hi Baoquan,
> >
> > I am really not against this idea, and I believe it can benefit
> > NUMA cases.
> >
> > That said, I might be being overly cautious, but I'm a bit concerned
> > that this re-walk of the page tables could slightly hurt machines that
> > don't benefit from the PUD filter at all. For example, Android devices
> > typically have relatively small amounts of memory, so a PUD covers a
> > really large range of their address space, which is unlikely to be
> > useful on an 8 GB Android device. Also, `lru_gen_look_around()` is a
> > really hot path. On Android, we've observed that it can consume a
> > significant amount of CPU.
> >
> > Is there any possibility of implementing this in a low-cost way?
>
> I made a draft patch, could you help check and test if it's performing
> better on Andriod device?
>

Hi Baoquan,

Actually, it is quite difficult to run the latest kernel, or even a
patch against the latest kernel, on an Android device. However, I can
run it on my x86 PC, for example, by setting `mem=3D4096M` or `mem=3D8192M`
in the bootargs to simulate a low-end phone.

I may run kernel-build on it and collect the perf data. Once I have
the data, I'll get back to you.

On the other hand, you could also investigate this in parallel by
emulating a low-end device. :-)

Best Regards
Barry

