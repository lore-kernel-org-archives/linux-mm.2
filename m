Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBF2CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FD76B0005; Tue, 19 May 2026 14:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357A86B0088; Tue, 19 May 2026 14:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246576B008A; Tue, 19 May 2026 14:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 126496B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:51:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97AB7120528
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:51:07 +0000 (UTC)
X-FDA: 84785061774.26.0EEB780
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6DB88140005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:51:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="h1bxjcu/";
	spf=pass (imf09.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779216665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auNMmPsKKmQDwMQx6p+X+IoKw+T0n0UlnhHmOoR8kKE=;
	b=xEufwyt7bBg+hR3D4/0PZvzF0AKr0fglc+7lo0OfpspL179b9XwzvPWgAv/mS7rTx540k0
	CyITv05Dl+spA9CxbI2jXaedUfXeqncvui702phCINAtO7qyaduYEo23ibw7YgNCq2CxZv
	fx2toHXgD606c50qZId//NntGfwUl7s=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="h1bxjcu/";
	spf=pass (imf09.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779216665; a=rsa-sha256;
	cv=pass;
	b=p+w6SSyVPQbm8W81Y1+5X7i2HHweNUoEYt9pUZjqqSmohxjyRLe3iKtzzzGnvB/Nrfrvj5
	zZ31fURoZMa+AYQolrC+/gj7ucoIABOcH5npuO7LNYxXyvjwYY/bUKdtTybl9iVG4lrtKi
	OKlsjlNKqSsbMOj3RJ/qa7zhOsVCae4=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bd56d108454so816825166b.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 11:51:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779216664; cv=none;
        d=google.com; s=arc-20240605;
        b=BLkTgwXYYDnbMDwM/DvuhaoXTBlmG1m59kFLZMr++iF1KnitT549+YUFse8EQtUbEi
         7OdssWJnjZvEB5kXyDTooYlHVMBv7X9Us7LKhiy25S/uOTg6u756I42zj9PVDDwHWj1o
         BGbDximXikFCLVInytyCp79zyBbl4xJD/o3fYfMlY5AfjOOHNXKAeBC/mcBKVZblG60f
         Wn4QqJyOuxLBZ6fg4viPeNxnnMNLD6lrFpKbzyQfcEP44Ogu/r3M3cMZCDUU/JeJw9Yp
         QuXvBiw5fL7mE6FX6eWxQVQKeR+NnpW3z+fcCfwFoaIgi+F9CtqNHjN3qHgBkS4EWfeW
         IFrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=auNMmPsKKmQDwMQx6p+X+IoKw+T0n0UlnhHmOoR8kKE=;
        fh=HMsqkT3iWswrPHsceEaEHSWdX7XBqwBWGyaegM6H454=;
        b=ef3UZ6Hoa8H2hIZ4ksFmVTMK3HagcqKJd3rXWrJJ7aA+OombPSaqC67HIoP4/pgYdQ
         Sgcg2ZcmUBM5PRZMVGlMJ/Xggvg/UNWT/EWxR74maZ/tIZAHZxG7XzfuXLhPAGP7jdm0
         b+owjD9XQDyEvkezdVsVHB8FLWRX/x9auIip8VW5xBfEULg+03znk6Ok+ErRZC3Awu7b
         YvNvBeSGcuJp9B757vMAC3gCKzY7b5cjLmFp5tYeolzDdTNEMk5LK93Z40H1puyLAvOi
         F+Afb5PndHCDbyiD4HVyn/f18L6394XuhJ3j4zt9Lryw0Y2m1xyn/CfvHrQUwTVQpmUb
         nHVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779216664; x=1779821464; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=auNMmPsKKmQDwMQx6p+X+IoKw+T0n0UlnhHmOoR8kKE=;
        b=h1bxjcu/DZ2HiBKU//0rauRIfT96pN3AaW6d0P0b22ouncXE3Qty7GcJPNErn/Vooq
         ABRN+rKKJ6ngV18qWb8ouVLZALKbUfMDv9d6KSARN7GCz46LxVSq7QuP+lI+ZKbfgW9m
         fIwpSP5yc6WVPF9ONd9c5NLA6/apK+jrj62eEHgKSIuZmLrKiMMoI+/In/u4WFpS0pIY
         A4J8EATY40Ab7hHeLv09cwRhwqIDh4H4xMpquSjwnfzR8UNjnBnkXtOVYYNIssq+NRSL
         hkBVeZG+8sE4/IhFa0tL3mbEWdTxyFqG8noOoDIWIXs6f1LYOhcrT3Q7G7D8k+B0qQWo
         Htqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779216664; x=1779821464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=auNMmPsKKmQDwMQx6p+X+IoKw+T0n0UlnhHmOoR8kKE=;
        b=IoWeFFcjINsiFoWX9lXcQCyJ45cq6jhgLyXQKfkuMuD95Ku/7c5JeLHbQqSROFkRbf
         FbW8nFAR8WYlu1AW6OyJ44SBsEXdfOw0i/w0H8D6ZbmHDA3ynyat2wO7AuOBwcINkG1W
         kS9U5e4tSlaQlHdp7vZqc8uvO37cMPerWmVrp2PLzerrT9ElJcL6WukGDKd0Xxx4WcKF
         4vIFmkHof4jW6957dssrk7DbDleiCzDuPHpcw2dqLeZYuH/mXoUMseFrEikbcxNq1KXA
         YN2JNsNLu/H+pVI/nK+d+GYp2jcv37LQ8I3TNmm0nP0XoN4yBBjhM+Fe0Qry4XI7+Lp+
         pw8w==
X-Forwarded-Encrypted: i=1; AFNElJ8bq0tI6j8I0yRRCgxY0kPTABcwEXqS2DAOLjnUfukwsrdvCnnIWly8m/709tzQ/OM91NkafLhycg==@kvack.org
X-Gm-Message-State: AOJu0YwfKv5EtUikGwwX86hjMdyAWaO7GaMIMX1oHLTkIRwsT73YgjpA
	CNmX/xfA65pgEPdxWolshUCr8mPDD/8alfha4byRijQbB1spVKFKhOEeXw4Pf8cmNmsO7vJB1Fv
	udl9b2Hdz/ipa2oml8dvDDlSdalfU4eo=
X-Gm-Gg: Acq92OECL6HDZBIzewyjNq6/zCOG3z2oJLm0C5sSzT1j3YqArvyKuR2WyhjxbB5+VlQ
	DJsYRBHWCaBA1FSeJgJMwKSOSyM5EQhUDk4dAMUahcNwtJPodLrR0r8jnFIBqe6IBYwJaaNNKld
	kGouqaCNQFUv+zn8Tkz8LuCrT73dawxl+nToAbmDT2YdARQlZbV7GkHQNviSjiBTIrKk5kJQAZh
	VnUh0RNSOHfHQVNjqMWRq+eBn67nc2CFiH4kUqzyaNtIkX2V7CufBWMpFigCJxNofEVsjEPynLW
	FNV9+MhxTg==
X-Received: by 2002:a17:907:a68b:b0:bda:2928:ff9a with SMTP id
 a640c23a62f3a-bda292920a3mr99249366b.39.1779216663733; Tue, 19 May 2026
 11:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <CAHbLzkrOSoh-jmR=uaNvx73n_wn+vExoKY0UzH5zGcfdAiDbNg@mail.gmail.com> <CAGsJ_4w_-Y8qNLDeLX9OWpLpK01YG2bF-N6_mGypgsauvfCvkA@mail.gmail.com>
In-Reply-To: <CAGsJ_4w_-Y8qNLDeLX9OWpLpK01YG2bF-N6_mGypgsauvfCvkA@mail.gmail.com>
From: Yang Shi <shy828301@gmail.com>
Date: Tue, 19 May 2026 11:50:51 -0700
X-Gm-Features: AVHnY4JjQJo4iM5wAoXXEGJ4OEpxos0PYW3wieiPnlRi6plEliJjiQongYt0ODQ
Message-ID: <CAHbLzkpbQ4Ca0xC74BJ6iJUVKdpH90qE+E=g7HkDXvcNH1+8+w@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, surenb@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, jack@suse.cz, 
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 66kjgb9bx7wfygut3m1pmq65sz8y88i9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6DB88140005
X-Rspam-User: 
X-HE-Tag: 1779216665-612559
X-HE-Meta: U2FsdGVkX19Pi1ZOVd7LuYZ+mNAouARyvUG8L4fgON+q1+zUyK+lq0xQ2Uk5nx0t0lqoUYSGU5ApqWg/h+ySRou1LvlDLixLkef51s/DyzQFDgUqB21oHEERYkSMAwBG3dE2WP/8as1rGmptP6X723wBtNY2IW/sX3glIWi+2GeJN/qG9HFpQMeRWs2a1PfBo9Z8sY0OmcBPrCgtGNTRoCYLRg7BA6I5KFHssKJfOp2OczzvL4xuNuAv8julhel3jiGgfRQqgS7kJciVzRUwymNOQ3ZxD35jk4i3hhI+5FT/33H/aGlPL+RfhUXFnSUy0e8fj1uOUqdwINiZA3pg3nebrwd8sQd3LUgRv/NNaU7JZPCp10J+o7hd14qQ68XX6BNg7bAbbqG1nxzrpmjQRkhhyt3UQRfoJbsrgokXzXe6g26eKukOaw1DmfG4zxckc71FD7VNzXZ8u+IqdfGCMLyibQSURmmV88fyjn4Olt+PBsDJlZ9w3gWnSNQy4syjJGSWMJhO9nAfS+gzgh1eBz8l2uS6DuGkReptjiTlUqcbfv0kp0j0Z0OaoyCNAG8uDbYGH6BagglbgDXsxBqXWDmI1eLhv/JjfpP+fcEwnIv1cLRLYjM2tW02qTiWw1t4TS5Rzkp+wbgr/uJn8ZYiuPgpSxUcmenekvkoHtps0/ErIF8hiTxQDYDuYbapCg64Sz/huREk7a48upl3Dlg3B/RUtXc7lrCVl1LVYzYBoyfC+Y5jF8QnQGDQ+v9WDxZsvQZ/rdpIDi39P6wFq5L//cUf/DJhinJ75Bm+UiLhuPFsKhYv+fllGIHfntFDdfla6SyaE+8xt60nx+VJEZh+sM1Pwg4uMEAriJblviWBtEnZmUj1SooKckPnlqthYmmzXahOtAjV5g6BinxYFz/Wm2JLBn1forypdGrWggw5p2D3+S9kof5718R2Mtbjf5f/cHxdinCHEGHZTaF+uaB
 0HLOPMjo
 huTcmxFlxZ3ipGoEuGUBOAeEzt5amP+JYXshcv9nEKP/b18EA42ko+FSxVHSLF93d6u8omjn6TcOA3J6gA1Ccw7N5X4fg+nJbqvOvz/50r1AjL5ZXvavNHAk/gOzkkWkRBze/BwMdWzJtmSWl1/W8gSG0oq0Ozbh8XCQCrG6XMbvTiykZbm362FjR5VR4PzEB4sOcEeDxoGGThSPbuogySTG0USQezrUe6WQCbZFXxlX+vFWoC8sIr73PAsHVd96OL9CaLehKqkAe8XREi4mZL1HdPSlscFLHN2kyyiXbqEszVMWxonwK5LNbg+WQu7juQudkqDawlAKcdzWg7T0eihcRS/YEeoXIZ47/neGPhb/DFiDe9drrdWoQrXB8DIMscqy4dzcfAu14aJZ3CW125SAw0S+G4/O2DnLhrI00O6HW3yWOQ8KArcHSPKdljHLXSelTauLm1MF3q8TWlL+jGJkg9VM/5ruKnJlN3Jn++N9o7hSamy+i16zh6s5d6EmFMsH7aFj2dS1tvwoinrzoOfNqDNt7EjsYG/AAA499U/2ThM042cRjmaSfMiSc44Hyi0mHMj8YHSXeuSHUOgr/td8H9Rf/e4DjAbZDCZ7A7PnNkRkTu8nXLD8pDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 4:07=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, May 19, 2026 at 5:21=E2=80=AFAM Yang Shi <shy828301@gmail.com> wr=
ote:
> >
> > On Sun, May 17, 2026 at 1:45=E2=80=AFAM Barry Song <baohua@kernel.org> =
wrote:
> > >
> > > On Sat, May 2, 2026 at 1:58=E2=80=AFAM Matthew Wilcox <willy@infradea=
d.org> wrote:
> > > >
> > > > On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > > > > On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@inf=
radead.org> wrote:
> > > > > >
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
> > > >
> > >
> > > Hi Matthew (and Lorenzo, Jan, and anyone else who may be
> > > waiting for answers),
> > >
> > > As promised during LSF/MM/BPF, we conducted thorough
> > > testing on Android phones to determine whether performing
> > > I/O in `filemap_fault()` can block `vma_start_write()`.
> > > I wanted to give a quick update on this question.
> > >
> > > Nanzhe at Xiaomi created tracing scripts and ran various
> > > applications on Android devices with I/O performed under
> > > the VMA lock in `filemap_fault()`. We found that:
> > >
> > > 1. There are very few cases where unmap() is blocked by
> > >    page faults. I assume this is due to buggy user code
> > >    or poor synchronization between reads and unmap().
> > > So I assume it is not a problem.
> > >
> > > 2. We observed many cases where `vma_start_write()`
> > >    is blocked by page-fault I/O in some applications.
> > >    The blocking occurs in the `dup_mmap()` path during
> > >    fork().
> > >
> > > With Suren's commit fb49c455323ff ("fork: lock VMAs of
> > > the parent process when forking"), we now always hold
> > > `vma_write_lock()` for each VMA. Note that the
> > > `mmap_lock` write lock is also held, which could lead to
> > > chained waiting if page-fault I/O is performed without
> > > releasing the VMA lock.
> > >
> > > My gut feeling is that Suren's commit may be overshooting,
> > > so my rough idea is that we might want to do something like
> > > the following (we haven't tested it yet and it might be
> > > wrong):
> > >
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 2311ae7c2ff4..5ddaf297f31a 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -1762,7 +1762,13 @@ __latent_entropy int dup_mmap(struct mm_struct
> > > *mm, struct mm_struct *oldmm)
> > >         for_each_vma(vmi, mpnt) {
> > >                 struct file *file;
> > >
> > > -               retval =3D vma_start_write_killable(mpnt);
> > > +               /*
> > > +                * For anonymous or writable private VMAs, prevent
> > > +                * concurrent CoW faults.
> > > +                */
> > > +               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED) =
&&
> > > +                                       (mpnt->vm_flags & VM_WRITE)))
> > > +                       retval =3D vma_start_write_killable(mpnt);
> > >                 if (retval < 0)
> > >                         goto loop_out;
> > >                 if (mpnt->vm_flags & VM_DONTCOPY) {
> >
> > Maybe a little bit off topic. This is an interesting idea. It seems
> > possible we don't have to take vma write lock unconditionally. IIUC
> > the write lock is mainly used to serialize against page fault and
> > madvise, right? I got a crazy idea off the top of my head. We may be
> > able to just take vma write lock iff vma->anon_vma is not NULL.
> >
> > First of all, write mmap_lock is held, so the vma can't go or be
> > changed under us.
> >
> > Secondly, if vma->anon_vma is NULL, it basically means either no page
> > fault happened or no cow happened, so there is no page table to copy,
> > this is also what copy_page_range() does currently. So we can shrink
> > the critical section to:
> >
> > if (vma->anon_vma) {
> >     vma_start_write_killable(src_vma);
> >     anon_vma_fork(dst_vma, src_vma);
> >     copy_page_range(dst_vma, src_vma);
> > }
> >
> > But page fault can happen before write mmap_lock is taken, when we
> > check vma->anon_vma, it is possible it has not been set up yet. But it
> > seems to be equivalent to page fault after fork and won't break the
> > semantic.
>
> Re-reading Suren's commit log for fb49c455323ff8
> ("fork: lock VMAs of the parent process when forking"),
> it seems that vm_start_write() is used to protect
> against a race where anon_vma changes from NULL to
> non-NULL during fork. In that scenario, we hold the
> mmap_lock write lock, but not vma_start_write(), so a
> concurrent anon_vma_prepare() could still install an
> anon_vma.
>
> "    A concurrent page fault on a page newly marked read-only by the page
>     copy might trigger wp_page_copy() and a anon_vma_prepare(vma) on the
>     source vma, defeating the anon_vma_clone() that wasn't done because t=
he
>     parent vma originally didn't have an anon_vma, but we now might end u=
p
>     copying a pte entry for a page that has one.
> "
>
> If that is the case, then your change does not work.
>
> Nowadays, nobody calls anon_vma_prepare(vma) directly.
> Instead, vmf_anon_prepare() is used, and we always
> require the mmap_lock read lock before calling
> __anon_vma_prepare(). As a result, anon_vma cannot
> transition from NULL to non-NULL during fork.
>
> So the original race condition has effectively
> disappeared.

anon_vma_prepare() has some usecases too, but it seems like it
requires taking read mmap_lock too if I read the code correctly.

>
> You also mentioned the madvise() case. If I understand
> correctly, madvise() should take mmap_lock before
> modifying anon_vma. Only some parts of madvise() can
> support per-VMA locking. Therefore, we probably do not
> need:
>
> if (vma->anon_vma) {
> vma_start_write_killable(src_vma);
> ...
> }

I think we still need write vma lock to serialize anon_vma fork
otherwise we may see:

        CPU 0                                                 CPU 1
fork                                                       page fault
   src vma has no anon_vma
       skip vma fork

allocate anon_vma for src vma
vma_needs_copy() sees anon_vma
copy page

Then we may end up being no anon_vma for dst vma, but with pages mapped in =
it.

Thanks,
Yang

>
> >
> > Anyway, just a crazy idea, I may miss some corner cases.
>
> To me, it seems that we could remove vma_start_write()
> entirely now. Or is that an even crazier idea?


>
> Thanks
> Barry

