Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D1CCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646FC8E000C; Wed, 10 Sep 2025 10:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E898E0003; Wed, 10 Sep 2025 10:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5342A8E000C; Wed, 10 Sep 2025 10:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0AC8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:19:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E89BA8716C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:19:09 +0000 (UTC)
X-FDA: 83873547618.25.E990B78
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id D49DC1C0009
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:19:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W8kObpR/";
	spf=pass (imf18.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757513947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rh8nAV3aFTnZMHtYWJctZ9QfqEPL93lGAPL0Bx/B3rY=;
	b=bvrA6ll04c9E69PYV8ptW0/j1rLoDuxa8R698OOo73X7VQ9/tpChmE5p2C0/6io0l2C8Dn
	ALK9YQxE4r7bWkUeur0ugQMk3PHGAgClUBIwd8V+NNrGqTPQXTEMpSgxZLPHtY+uYeXcqM
	VkprJu43y7UVcCYj+sK9DVd0BXz455o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="W8kObpR/";
	spf=pass (imf18.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757513948; a=rsa-sha256;
	cv=none;
	b=X7UYWzZrWj603gdTRhL36eOrT7NXab7L4Dsw+SOSFDEUuNEqdB6UyU4QcfWQjcPuKTtikJ
	w7e/o+K24OWjz69D4NNMgEBoJIy3obFUaC20WVy8OsSwbC/F34USIizqK9aC95g6IiQ8wJ
	camiFuOf+3LuTW9xOE5w1LGRp9bFUu4=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-32326e2f0b3so5759900a91.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757513946; x=1758118746; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rh8nAV3aFTnZMHtYWJctZ9QfqEPL93lGAPL0Bx/B3rY=;
        b=W8kObpR/YAfhuAFabR/e/zKYC0AaOTrOYAw7Q+t+65hts4Q+/jF6axUmKIIAMuwJTk
         AmYEp+6UeKWp062g1R9WzikMkHD+InZYNpuwyNb1symxNo06IKXQP6jfm902kkMABy8l
         93XZGVvq0RG7WcB1k/pVdzr4KM5Ho+aVi83QbDzri8LgYj0SeT6I1xjqUdxgaxReT69n
         0XSnYFeRULy1Mn01uELY+HU0nimhMhmXoZjl8C60TWlsi6Gs62tBBbgYNL6UQBezZ/rp
         CSJ39fu2sH2uPJr74xXa9P+PkM2xE70dkgGg64jG79em/7akdogxardcKJL3GDRB3gB3
         vDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757513946; x=1758118746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rh8nAV3aFTnZMHtYWJctZ9QfqEPL93lGAPL0Bx/B3rY=;
        b=vBT8DDve3pe1Qh76Lq6In5bcsSty04Mhe4rbp2WeNrKfy0R6CMBDlabtelJfLivJmr
         +7Kr3VncE6abCZb+1xfKOdJNlqtMPnYboAh5k1ksCzpq0MxYq4DvqyvI8gfLcQcUu77P
         cyhRPXdQ0qPPQnKSZ7/ueeuMLMCyqyiH9J6hwc+m8QkSrco3OietGCzaN8qAG+M7ZK7x
         7/9R6/1kaxUgjOya3BEk5/vHVpW+YjEt5p8BJYHIBGgIyYXww4zhqM25N66ttNNwa62b
         gA7zg6TMpdcntA1D2TgSE2h2/283m1RwJmktNqnMXLLlKo3avTHiusoBu+Ix3hx4Bowh
         HZcQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8ASKC/SH98HssiW0Zgi2/WyexzKQjewRTETQSgyF4jmDH+cS3jQi4HJovpIEJFCr7z2mE8B2P6w==@kvack.org
X-Gm-Message-State: AOJu0Yy+PclkCldnfncxVDJqBhY3LhE+hoQtZZjh4x5BOZEyf5drUrTT
	pIiyYMSmEbBVvf1sh3PZkIvmW+ZWyA7BX5wwEi9iZsiscBUwbvuYXUi5ekDnXaOF/tPRBLHPEpM
	zW+aiq5nrfU+dlvADoSXNyI6BxuUk/LE=
X-Gm-Gg: ASbGncvmmrA9wF6li03Lv5u0phAZ2WCtqC/AVEgko872ZjrNWDHKPJEZ+/kMIdyGjSV
	Z1Hb6NGkf3ILDKuwKHrS3UfdKkpFGFW4ulKKvFjmlDySaYCB25Qyb74Xr4K1WI8bLmGaZnC6+V/
	HeACBqD+1QauyRlms50ZpSgRLgZNW04UcpLNvXVWJ4KT3CMNBu1IQ3RdWPHYt/vIGXQ+m6HCBDn
	c56uuPD6s42I6HNLpuHGtG2W1duHq2lVA==
X-Google-Smtp-Source: AGHT+IHCmvPLMq7lOIbxpl3oO0snKwGDgaF1MlhGdVQmfuq1SXhNOE0Fgj6CiOiB3RloShJcunriA+1+yzs0aEfswLI=
X-Received: by 2002:a17:90b:530b:b0:329:e1d0:3bf6 with SMTP id
 98e67ed59e1d1-32d43ee2f03mr20691025a91.6.1757513946359; Wed, 10 Sep 2025
 07:19:06 -0700 (PDT)
MIME-Version: 1.0
References: <20240724225210.545423-1-andrii@kernel.org> <20240724225210.545423-11-andrii@kernel.org>
 <ZqJBK4loBv030jj_@krava> <CAEf4BzZkGur_zPrPCEo6=asFGO1uBShvf1wwEoBhaKk-46ctAQ@mail.gmail.com>
 <ZqOWGvrrubXbVDlY@krava> <CAEf4BzbF+Q14fW-z2Fg02AEcFaF+dU53FVpDO_K_Tz-xQP_k5g@mail.gmail.com>
 <ZqaeOl8c_Jwl3ieR@krava> <CAEf4BzZtu_LWu82z9RFDf00a77uJuEpqYtuJWqz2zvm8jG3UWA@mail.gmail.com>
 <aMEWKR2QPQtRMxp7@linux.ibm.com>
In-Reply-To: <aMEWKR2QPQtRMxp7@linux.ibm.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 10 Sep 2025 10:18:53 -0400
X-Gm-Features: Ac12FXyWJ3nz5W3iVItOC7SDdjR2FskkSKR8cVcSR4_iebdyRkF50CchuGmDBHM
Message-ID: <CAEf4BzYWVtfZh07iQm5Fo=kMm+8hgAu+rXRx1uLRHz07wc59+Q@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/10] selftests/bpf: add build ID tests
To: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Cc: Jiri Olsa <olsajiri@gmail.com>, Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, adobriyan@gmail.com, 
	shakeel.butt@linux.dev, hannes@cmpxchg.org, ak@linux.intel.com, 
	osandov@osandov.com, song@kernel.org, hbathini@linux.ibm.com, 
	donettom@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D49DC1C0009
X-Stat-Signature: dm8wfq88xsfw6drh41totnttamre58w7
X-HE-Tag: 1757513947-872007
X-HE-Meta: U2FsdGVkX19xjciyzY/FlARTJ5Ze+rZJXUrV59qYuhAwf8uRe/esUmCX1mDRjHaxGwN7A/fCtO+LDR+37+j7qRmJ7WkPqCGyd3BQhMos6k6CdCXcZKj994RdmK94BGsS6YU9uVIYcHnUfCRdiEyhfzRvZoIIiSFT3cTmQ7efFnS1bK4Z6b24SyEztHupgg1nkZN1Y8XfY83XQlf96GIcn+jux3a9yCHlpNY1oOMJsqrANj1+QffzQ8s0DX0bn4czIKVcO1Esf0IZNuaqCaLFCuW7KToj7/1mbReLHMM9IPEfVjWMrc4w3v2BhLizItkgl2H6N3/z3CHry07XbQdRsKU444FsQN+lxvJePnOj1i9CMaLNntUMC2Y25Il+Pe4ufnb8kZAVo047ZI/dSFPWpwsHXcQOeze9jL7rDdmOCPI7m6Kcc/VPYjGE6geoPFfPMKBRZ/rJ+ywTLOSzZE6TkbYB3+lOH5iXxu/gHGqFB9XSl9n8AWCTy2tTYvhQ7tc7hxqCPoPRBCRC+Ps+hG2sgfLKhiTvVnTgGopYiRC/1kuO+1jx5Hy7Q8HfizRmGktslCSremzNK6VawQM1Pe7dnPETvFo14WCzecv0hxCGdwzLiqPQqfcCl7L6XIuINpRxaltWNzEpNjc9w3zGG0PzHgjSjfioW6hgbbih+O5cMk+Mm4GDLeng3GxiTEgZGCNW3OiKzr8wluIbKE3U0aCVG5AxQd/rcnAx9JCfWWwm8QiNmGQVKTa/fDM4ZmFmXrB0K2Wjx0grQsFQ+4RmPVuFbWwWlQ6SuVBwd2CgTg8+VZeh4KO1jlxJw899QW5J+AwY+56769y8ISHo7eQqOVS3XfPXQfUOFEi12sKEUdp16RivHVofJ/ShmmyXkUNA6tSG2hCrAfRx8Sy87GSWZrd/blP1uHYfl/a83q50+JQ0qApFehfRFscibz9YMC//smusenhjZDgsKjielmNfydP
 t0JpI7wX
 xPW1pQVAN0UOIMRA8lnEee/ZGd+kH1PvUz7ZjBP53OgcZzxRKFc/mPh+LQH/Lk1nUOTmdUuhkWLnsrLKOhFXIAApPDFyO4E+VRi+RPmy/LhIyXO4qbn3ZQ5ubYqtlPsQrIA3++bUm+I9pHyWBkK1UY4Vu0NSas4YZU1/sO3I/VFm+rQ2Bnp8ANNcYPr0INzQH5BvpgxRAT4/RW8S+vMrAiv7GFQYOKe0mnjEe34Kvq1tHLiBtgzKLoOOKbDdH8wwYTHCXgJxi+f1Wv733qXfP4klrzmmt60lgv0XvCEwDk5DN8HMMgZfS2JK3vAEzL7dUV9We1bH+iZ8fUOfvSW15Rms8oPCcU6psdkUajCJJkxR/5yXmF8EELNQctsfaQ3p5wY8wJeir196nTyTevJowjtmRNiRc9fY8jlO7OEcGLfVCD3vF+Ie9tnc/ecl6u4/G7NQIsIPzhC0V7ew=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 2:10=E2=80=AFAM Saket Kumar Bhaskar <skb99@linux.ib=
m.com> wrote:
>
> On Tue, Jul 30, 2024 at 01:03:17PM -0700, Andrii Nakryiko wrote:
> > On Sun, Jul 28, 2024 at 12:38=E2=80=AFPM Jiri Olsa <olsajiri@gmail.com>=
 wrote:
> > >
> > > On Fri, Jul 26, 2024 at 05:37:55PM -0700, Andrii Nakryiko wrote:
> > > > On Fri, Jul 26, 2024 at 5:27=E2=80=AFAM Jiri Olsa <olsajiri@gmail.c=
om> wrote:
> > > > >
> > > > > On Thu, Jul 25, 2024 at 01:03:55PM -0700, Andrii Nakryiko wrote:
> > > > > > On Thu, Jul 25, 2024 at 5:12=E2=80=AFAM Jiri Olsa <olsajiri@gma=
il.com> wrote:
> > > > > > >
> > > > > > > On Wed, Jul 24, 2024 at 03:52:10PM -0700, Andrii Nakryiko wro=
te:
> > > > > > > > Add a new set of tests validating behavior of capturing sta=
ck traces
> > > > > > > > with build ID. We extend uprobe_multi target binary with ab=
ility to
> > > > > > > > trigger uprobe (so that we can capture stack traces from it=
), but also
> > > > > > > > we allow to force build ID data to be either resident or no=
n-resident in
> > > > > > > > memory (see also a comment about quirks of MADV_PAGEOUT).
> > > > > > > >
> > > > > > > > That way we can validate that in non-sleepable context we w=
on't get
> > > > > > > > build ID (as expected), but with sleepable uprobes we will =
get that
> > > > > > > > build ID regardless of it being physically present in memor=
y.
> > > > > > > >
> > > > > > > > Also, we add a small add-on linker script which reorders
> > > > > > > > .note.gnu.build-id section and puts it after (big) .text se=
ction,
> > > > > > > > putting build ID data outside of the very first page of ELF=
 file. This
> > > > > > > > will test all the relaxations we did in build ID parsing lo=
gic in kernel
> > > > > > > > thanks to freader abstraction.
> > > > > > > >
> > > > > > > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > > > > >
> > > > > > > one of my bpf selftests runs showed:
> > > > > > >
> > > > > > > test_build_id:PASS:parse_build_id 0 nsec
> > > > > > > subtest_nofault:PASS:skel_open 0 nsec
> > > > > > > subtest_nofault:PASS:link 0 nsec
> > > > > > > subtest_nofault:PASS:trigger_uprobe 0 nsec
> > > > > > > subtest_nofault:PASS:res 0 nsec
> > > > > > > subtest_nofault:FAIL:build_id_status unexpected build_id_stat=
us: actual 1 !=3D expected 2
> > > > > > > #42/1    build_id/nofault-paged-out:FAIL
> > > > > > > #42/2    build_id/nofault-paged-in:OK
> > > > > > > #42/3    build_id/sleepable:OK
> > > > > > > #42      build_id:FAIL
> > > > > > >
> > > > > > > I could never reproduce again.. but I wonder the the page cou=
ld sneak
> > > > > > > in before the bpf program is hit and the buildid will get par=
sed?
> > > > > > >
> > > > > >
> > > > > > Yes, and I just realized that I forgot to mark this test as ser=
ial. If
> > > > > > there is parallel test that also runs uprobe_multi and that cau=
ses
> > > > > > build_id page to be paged in into page cache, then this might s=
ucceed.
> > > > > > So I need to mark the test itself serial.
> > > > > >
> > > > > > Another issue which I was debugging (and fixed) yesterday was t=
hat if
> > > > > > the memory passed for MADV_PAGEOUT is not yet memory mapped int=
o the
> > > > > > current process, then it won't be really removed from the page =
cache.
> > > > > > I avoid that by first paging it in, and then MADV_PAGEOUT.
> > > > >
> > > > > ok, I triggered that in serial run, so I probably hit this one
> > > > >
> > > >
> > > > you did it with v2 of the patch set? I had this bug in v1, but v2
> > > > should be fine, as far as I understand (due to unconditional
> > > > madvise(addr, page_sz, MADV_POPULATE_READ); before madvise(addr,
> > > > page_sz, MADV_PAGEOUT)). At least I haven't been able to reproduce
> > > > that anymore and BPF CI is now happy as well.
> > >
> > > yes, it's with v2 and I can still see that.. but only for the first r=
un of
> > > the test after reboot.. so far I have no clue.. I can see the success=
ful
> > > page-out madvise (still not sure how much is that telling about the p=
age
> > > being paged out), and then the build id code sees the page just fine
> > >
> > > attaching my .config in case
> > >
> >
> > I wasn't able to repro this, sorry. It works very reliably for me with
> > your or my config. Given it also seems to work reliably in BPF CI, I'm
> > still inclined to add this tests, I think it's good to have that
> > coverage.
> >
> > I'll monitor, and if it becomes flaky, we'll need to reassess this, of =
course.
> >
> Hi Andrii and Jirka,
>
> I encountered this error on powerpc, which is happening quiet consistentl=
y:
>
> # ./test_progs -t build_id/nofault-paged-out
> serial_test_build_id:PASS:parse_build_id 0 nsec
> subtest_nofault:PASS:skel_open 0 nsec
> subtest_nofault:PASS:link 0 nsec
> subtest_nofault:PASS:trigger_uprobe 0 nsec
> subtest_nofault:PASS:res 0 nsec
> subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1=
 !=3D expected 2
> #46/1    build_id/nofault-paged-out:FAIL
> #46      build_id:FAIL
> #397     stacktrace_build_id:OK
> #398     stacktrace_build_id_nmi:OK
>
> I dumped vma mapping using pmap in trigger_uprobe function
> before/after MADV_POPULATE_READ and b/w MADV_POPULATE_READ
> and MADV_PAGEOUT, page residency using mincore() (as shown
> "Before uprobe: Page residency =3D ") and addr (as shown
> "Entered trigger_uprobe addr ->").
>
> Here I am putting out 3 scenarios:
>
> 1. #./test_progs -t build_id/nofault-paged-out
> Entered trigger_uprobe addr -> 0x105a0000
> 144992:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7744     704      64 r-x-- uprobe_multi
> 0000000010790000      64      64      64 r---- uprobe_multi
> 00000000107a0000      64      64      64 rw--- uprobe_multi
> 000001002bf90000     192      64      64 rw---   [ anon ]
> 00007fffb55d0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffb56a0000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffb56b0000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffb56c0000    2304    1280       0 r-x-- libc.so.6
> 00007fffb5900000      64      64      64 r---- libc.so.6
> 00007fffb5910000      64      64      64 rw--- libc.so.6
> 00007fffb5920000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffb5950000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffb5960000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffb5970000     192      64       0 r-x-- libelf-0.192.so
> 00007fffb59a0000      64      64      64 r---- libelf-0.192.so
> 00007fffb59b0000      64       0       0 rw---   [ anon ]
> 00007fffb59d0000     256       0       0 r----   [ anon ]
> 00007fffb5a10000      64      64       0 r-x--   [ anon ]
> 00007fffb5a20000     320     320       0 r-x-- ld64.so.2
> 00007fffb5a70000      64      64      64 r---- ld64.so.2
> 00007fffb5a80000      64      64      64 rw--- ld64.so.2
> 00007fffee7a0000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13056    3392     896
> 144992:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7744     704      64 r-x-- uprobe_multi
> 0000000010790000      64      64      64 r---- uprobe_multi
> 00000000107a0000      64      64      64 rw--- uprobe_multi
> 000001002bf90000     192      64      64 rw---   [ anon ]
> 00007fffb55d0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffb56a0000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffb56b0000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffb56c0000    2304    1344       0 r-x-- libc.so.6
> 00007fffb5900000      64      64      64 r---- libc.so.6
> 00007fffb5910000      64      64      64 rw--- libc.so.6
> 00007fffb5920000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffb5950000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffb5960000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffb5970000     192      64       0 r-x-- libelf-0.192.so
> 00007fffb59a0000      64      64      64 r---- libelf-0.192.so
> 00007fffb59b0000      64       0       0 rw---   [ anon ]
> 00007fffb59d0000     256       0       0 r----   [ anon ]
> 00007fffb5a10000      64      64       0 r-x--   [ anon ]
> 00007fffb5a20000     320     320       0 r-x-- ld64.so.2
> 00007fffb5a70000      64      64      64 r---- ld64.so.2
> 00007fffb5a80000      64      64      64 rw--- ld64.so.2
> 00007fffee7a0000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13056    3456     896
> 144992:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7744     704      64 r-x-- uprobe_multi
> 0000000010790000      64      64      64 r---- uprobe_multi
> 00000000107a0000      64      64      64 rw--- uprobe_multi
> 000001002bf90000     192      64      64 rw---   [ anon ]
> 00007fffb55d0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffb56a0000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffb56b0000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffb56c0000    2304    1344       0 r-x-- libc.so.6
> 00007fffb5900000      64      64      64 r---- libc.so.6
> 00007fffb5910000      64      64      64 rw--- libc.so.6
> 00007fffb5920000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffb5950000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffb5960000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffb5970000     192      64       0 r-x-- libelf-0.192.so
> 00007fffb59a0000      64      64      64 r---- libelf-0.192.so
> 00007fffb59b0000      64       0       0 rw---   [ anon ]
> 00007fffb59d0000     256       0       0 r----   [ anon ]
> 00007fffb5a10000      64      64       0 r-x--   [ anon ]
> 00007fffb5a20000     320     320       0 r-x-- ld64.so.2
> 00007fffb5a70000      64      64      64 r---- ld64.so.2
> 00007fffb5a80000      64      64      64 rw--- ld64.so.2
> 00007fffee7a0000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13056    3456     896
> Before uprobe: Page residency =3D resident
> After uprobe: Page residency =3D resident
> serial_test_build_id:PASS:parse_build_id 0 nsec
> subtest_nofault:PASS:skel_open 0 nsec
> subtest_nofault:PASS:link 0 nsec
> subtest_nofault:PASS:trigger_uprobe 0 nsec
> subtest_nofault:PASS:res 0 nsec
> subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1=
 !=3D expected 2
> #46/1    build_id/nofault-paged-out:FAIL
> #46      build_id:FAIL
> #397     stacktrace_build_id:OK
> #398     stacktrace_build_id_nmi:OK
>
> All error logs:
> serial_test_build_id:PASS:parse_build_id 0 nsec
> subtest_nofault:PASS:skel_open 0 nsec
> subtest_nofault:PASS:link 0 nsec
> subtest_nofault:PASS:trigger_uprobe 0 nsec
> subtest_nofault:PASS:res 0 nsec
> subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1=
 !=3D expected 2
> #46/1    build_id/nofault-paged-out:FAIL
> #46      build_id:FAIL
> Summary: 2/0 PASSED, 0 SKIPPED, 1 FAILED
>
> Here it can be seen that RSS for vma containing addr (0x105a0000)
> is not changing (remains 704) and the selftest fails.
>
> 2. When alignment in linker script is changed to 65536 (default
>    page size in powerpc is 64k):
>
> git diff uprobe_multi.ld
> diff --git a/tools/testing/selftests/bpf/uprobe_multi.ld b/tools/testing/=
selftests/bpf/uprobe_multi.ld
> index a2e94828b..2063714b2 100644
> --- a/tools/testing/selftests/bpf/uprobe_multi.ld
> +++ b/tools/testing/selftests/bpf/uprobe_multi.ld
> @@ -1,8 +1,8 @@
>  SECTIONS
>  {
> -       . =3D ALIGN(4096);
> +       . =3D ALIGN(65536);
>         .note.gnu.build-id : { *(.note.gnu.build-id) }
> -       . =3D ALIGN(4096);
> +       . =3D ALIGN(65536);
>  }
>  INSERT AFTER .text;
>
> #./test_progs -t build_id/nofault-paged-out -v
> bpf_testmod.ko is already unloaded.
> Loading bpf_testmod.ko...
> Successfully loaded bpf_testmod.ko.
> serial_test_build_id:PASS:parse_build_id 0 nsec
> subtest_nofault:PASS:skel_open 0 nsec
> subtest_nofault:PASS:link 0 nsec
> Entered trigger_uprobe addr -> 0x105b0000
> 145238:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7872     768     768 r-x-- uprobe_multi
> 00000000107b0000      64      64      64 r---- uprobe_multi
> 00000000107c0000      64      64      64 rw--- uprobe_multi
> 000001003a6b0000     192      64      64 rw---   [ anon ]
> 00007fffa3eb0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffa3f80000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffa3f90000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffa3fa0000    2304    1280       0 r-x-- libc.so.6
> 00007fffa41e0000      64      64      64 r---- libc.so.6
> 00007fffa41f0000      64      64      64 rw--- libc.so.6
> 00007fffa4200000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffa4230000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffa4240000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffa4250000     192      64       0 r-x-- libelf-0.192.so
> 00007fffa4280000      64      64      64 r---- libelf-0.192.so
> 00007fffa4290000      64       0       0 rw---   [ anon ]
> 00007fffa42b0000     256       0       0 r----   [ anon ]
> 00007fffa42f0000      64      64       0 r-x--   [ anon ]
> 00007fffa4300000     320     320       0 r-x-- ld64.so.2
> 00007fffa4350000      64      64      64 r---- ld64.so.2
> 00007fffa4360000      64      64      64 rw--- ld64.so.2
> 00007fffc6880000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13184    3456    1600
> 145238:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7872     832     832 r-x-- uprobe_multi
> 00000000107b0000      64      64      64 r---- uprobe_multi
> 00000000107c0000      64      64      64 rw--- uprobe_multi
> 000001003a6b0000     192      64      64 rw---   [ anon ]
> 00007fffa3eb0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffa3f80000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffa3f90000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffa3fa0000    2304    1344       0 r-x-- libc.so.6
> 00007fffa41e0000      64      64      64 r---- libc.so.6
> 00007fffa41f0000      64      64      64 rw--- libc.so.6
> 00007fffa4200000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffa4230000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffa4240000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffa4250000     192      64       0 r-x-- libelf-0.192.so
> 00007fffa4280000      64      64      64 r---- libelf-0.192.so
> 00007fffa4290000      64       0       0 rw---   [ anon ]
> 00007fffa42b0000     256       0       0 r----   [ anon ]
> 00007fffa42f0000      64      64       0 r-x--   [ anon ]
> 00007fffa4300000     320     320       0 r-x-- ld64.so.2
> 00007fffa4350000      64      64      64 r---- ld64.so.2
> 00007fffa4360000      64      64      64 rw--- ld64.so.2
> 00007fffc6880000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13184    3584    1664
> 145238:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7872     768     768 r-x-- uprobe_multi
> 00000000107b0000      64      64      64 r---- uprobe_multi
> 00000000107c0000      64      64      64 rw--- uprobe_multi
> 000001003a6b0000     192      64      64 rw---   [ anon ]
> 00007fffa3eb0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffa3f80000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffa3f90000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffa3fa0000    2304    1344       0 r-x-- libc.so.6
> 00007fffa41e0000      64      64      64 r---- libc.so.6
> 00007fffa41f0000      64      64      64 rw--- libc.so.6
> 00007fffa4200000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffa4230000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffa4240000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffa4250000     192      64       0 r-x-- libelf-0.192.so
> 00007fffa4280000      64      64      64 r---- libelf-0.192.so
> 00007fffa4290000      64       0       0 rw---   [ anon ]
> 00007fffa42b0000     256       0       0 r----   [ anon ]
> 00007fffa42f0000      64      64       0 r-x--   [ anon ]
> 00007fffa4300000     320     320       0 r-x-- ld64.so.2
> 00007fffa4350000      64      64      64 r---- ld64.so.2
> 00007fffa4360000      64      64      64 rw--- ld64.so.2
> 00007fffc6880000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13184    3520    1600
> Before uprobe: Page residency =3D resident
> After uprobe: Page residency =3D resident
> subtest_nofault:PASS:trigger_uprobe 0 nsec
> subtest_nofault:PASS:res 0 nsec
> FRAME #00: BUILD ID =3D 4f635d1d48e4f2b67b62a9a07285668cdc85fb18 OFFSET =
=3D 2c3f1c
> FRAME #01: BUILD ID =3D 4f635d1d48e4f2b67b62a9a07285668cdc85fb18 OFFSET =
=3D 5a0824
> FRAME #02: BUILD ID =3D 4f635d1d48e4f2b67b62a9a07285668cdc85fb18 OFFSET =
=3D 5a0994
> FRAME #03: BUILD ID =3D 09139ae1e5cbaf5c598222698e5b8e2e250260b1 OFFSET =
=3D 2aba4
> FRAME #04: BUILD ID =3D 09139ae1e5cbaf5c598222698e5b8e2e250260b1 OFFSET =
=3D 2adec
> FRAME #05: BUILD ID =3D 4f635d1d48e4f2b67b62a9a07285668cdc85fb18 OFFSET =
=3D fffffffff0000000
> subtest_nofault:FAIL:build_id_status unexpected build_id_status: actual 1=
 !=3D expected 2
> #46/1    build_id/nofault-paged-out:FAIL
> #46      build_id:FAIL
>
> Here RSS changes(768 -> 832 -> 768) but looks like page is still
> not getting evicted (as shown "Before uprobe: Page residency =3D resident=
")
> after MADV_PAGEOUT and the selftest fails.
>
> 3. But in the very next run page is evicted and selftest passes:
>
> #./test_progs -t build_id/nofault-paged-out
> Entered trigger_uprobe addr -> 0x105b0000
> 145256:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7872     768      64 r-x-- uprobe_multi
> 00000000107b0000      64      64      64 r---- uprobe_multi
> 00000000107c0000      64      64      64 rw--- uprobe_multi
> 00000100317b0000     192      64      64 rw---   [ anon ]
> 00007fffa5cd0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffa5da0000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffa5db0000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffa5dc0000    2304    1280       0 r-x-- libc.so.6
> 00007fffa6000000      64      64      64 r---- libc.so.6
> 00007fffa6010000      64      64      64 rw--- libc.so.6
> 00007fffa6020000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffa6050000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffa6060000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffa6070000     192      64       0 r-x-- libelf-0.192.so
> 00007fffa60a0000      64      64      64 r---- libelf-0.192.so
> 00007fffa60b0000      64       0       0 rw---   [ anon ]
> 00007fffa60d0000     256       0       0 r----   [ anon ]
> 00007fffa6110000      64      64       0 r-x--   [ anon ]
> 00007fffa6120000     320     320       0 r-x-- ld64.so.2
> 00007fffa6170000      64      64      64 r---- ld64.so.2
> 00007fffa6180000      64      64      64 rw--- ld64.so.2
> 00007ffff1890000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13184    3456     896
> 145256:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7872     832      64 r-x-- uprobe_multi
> 00000000107b0000      64      64      64 r---- uprobe_multi
> 00000000107c0000      64      64      64 rw--- uprobe_multi
> 00000100317b0000     192      64      64 rw---   [ anon ]
> 00007fffa5cd0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffa5da0000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffa5db0000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffa5dc0000    2304    1344       0 r-x-- libc.so.6
> 00007fffa6000000      64      64      64 r---- libc.so.6
> 00007fffa6010000      64      64      64 rw--- libc.so.6
> 00007fffa6020000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffa6050000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffa6060000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffa6070000     192      64       0 r-x-- libelf-0.192.so
> 00007fffa60a0000      64      64      64 r---- libelf-0.192.so
> 00007fffa60b0000      64       0       0 rw---   [ anon ]
> 00007fffa60d0000     256       0       0 r----   [ anon ]
> 00007fffa6110000      64      64       0 r-x--   [ anon ]
> 00007fffa6120000     320     320       0 r-x-- ld64.so.2
> 00007fffa6170000      64      64      64 r---- ld64.so.2
> 00007fffa6180000      64      64      64 rw--- ld64.so.2
> 00007ffff1890000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13184    3584     896
> 145256:   ./uprobe_multi uprobe-paged-out
> Address           Kbytes     RSS   Dirty Mode  Mapping
> 0000000010000000    7872     768      64 r-x-- uprobe_multi
> 00000000107b0000      64      64      64 r---- uprobe_multi
> 00000000107c0000      64      64      64 rw--- uprobe_multi
> 00000100317b0000     192      64      64 rw---   [ anon ]
> 00007fffa5cd0000     832      64       0 r-x-- libzstd.so.1.5.5
> 00007fffa5da0000      64      64      64 r---- libzstd.so.1.5.5
> 00007fffa5db0000      64      64      64 rw--- libzstd.so.1.5.5
> 00007fffa5dc0000    2304    1344       0 r-x-- libc.so.6
> 00007fffa6000000      64      64      64 r---- libc.so.6
> 00007fffa6010000      64      64      64 rw--- libc.so.6
> 00007fffa6020000     192      64       0 r-x-- libz.so.1.3.1.zlib-ng
> 00007fffa6050000      64      64      64 r---- libz.so.1.3.1.zlib-ng
> 00007fffa6060000      64      64      64 rw--- libz.so.1.3.1.zlib-ng
> 00007fffa6070000     192      64       0 r-x-- libelf-0.192.so
> 00007fffa60a0000      64      64      64 r---- libelf-0.192.so
> 00007fffa60b0000      64       0       0 rw---   [ anon ]
> 00007fffa60d0000     256       0       0 r----   [ anon ]
> 00007fffa6110000      64      64       0 r-x--   [ anon ]
> 00007fffa6120000     320     320       0 r-x-- ld64.so.2
> 00007fffa6170000      64      64      64 r---- ld64.so.2
> 00007fffa6180000      64      64      64 rw--- ld64.so.2
> 00007ffff1890000     192      64      64 rw---   [ stack ]
> ---------------- ------- ------- -------
> total kB           13184    3520     896
> Before uprobe: Page residency =3D paged out
> After uprobe: Page residency =3D paged out
> #46/1    build_id/nofault-paged-out:OK
> #46      build_id:OK
> #397     stacktrace_build_id:OK
> #398     stacktrace_build_id_nmi:OK
> Summary: 3/1 PASSED, 0 SKIPPED, 0 FAILED
>
> Here it can be seen that page is evicted (as shown
> "Before uprobe: Page residency =3D paged out").
>
> Although the selftest occasionally passes, its behavior
> remains flaky and unreliable across runs. But introducing
> a sleep before/after both MADV_POPULATE_READ and MADV_PAGEOUT
> tends to improve the consistency with which the selftest passes.
>
> Your valuable suggestions or thoughts on how best to address/debug
> this further would be helpful.
>

How do you check page residency? Instead of just sleeping, I'd add the
code that just waits for the page to be non-resident (with some
reasonable time out in case of bugs), and wait until that condition
happens. (And of course let's increase alignment to 64KB, it has to be
page-aligned across supported architectures).

> Regards,
> Saket
> > > jirka
> > >
> > >
> > > ----
> > > #
> > > # Automatically generated file; DO NOT EDIT.
> > > # Linux/x86 6.10.0 Kernel Configuration
> > > #
> >
> > [...]
> >

