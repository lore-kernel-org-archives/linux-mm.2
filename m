Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E25A5CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248CF6B0005; Tue, 19 May 2026 17:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2376B0088; Tue, 19 May 2026 17:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072FD6B008A; Tue, 19 May 2026 17:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E748F6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:02:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61623120A7B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:02:25 +0000 (UTC)
X-FDA: 84785392650.21.0643E45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3C5494000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:02:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZEBWKWGW;
	spf=pass (imf01.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779224543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bg1sJVq29IP0l0ZfRic8XdzhSk92ovWlIbkT7xGYhvE=;
	b=aLWwIeXNJVfdMpEq5AkzHWdxgcnURaTyE5fiFJFcORK9VKe7edJquy8PcyCurzFucOXFqa
	ZXbJEzqVyWWOlNjnbbh7rKdhZKPJKbgQ89urNiaVtWW6pMqIgaBokTKIuvunmDzCA3AVsE
	QZ36UyHHf39LioKDM25NktqpGfFpCao=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZEBWKWGW;
	spf=pass (imf01.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779224543; a=rsa-sha256;
	cv=pass;
	b=uEt5wiEAX+gCEXXaeWoOT1LyYZGgHLGD6iOs862qnvgwxctzwrpjwc3RvZAqOMswzZXUCY
	SiShLWY7d5peJbpFxmB8eNt0hxDOGCyUq8phhqLXaH4szFsmG7snFBW1jBOdxT29AxkG7t
	kKML41p6dcapkL5GT89JLyA4Wthm/B4=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-67e43a8996fso5147361a12.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 14:02:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779224542; cv=none;
        d=google.com; s=arc-20240605;
        b=Jcj5YOYbtiQzilveYfQ48/166C9Uc33I9p4LsDPLu3502p+2UfeqkUUhKxQDE2rpyo
         f8ohKG1uLHe25DTpu3Mb/1HNQBoT8NA8Zf1l6pRNoFOIWSRgBeIJy9bQNMXXMyH3Gejq
         R1MilfrF6nmBNCsBoleY/N0LGIwN4Ps6rXm5Hncmg9uqNND79sGwoEuVJoPupWLJo5JC
         tSCwhk2ePJIlmOqyCYTPWiHsmlXuUUe1ZA7rBUWxGRS+egf5O6WvvaWZ9VMwZSOoQ+hb
         SYsaQwHTjokOxp62SoTADVIG1KH+FKY1LeNyF+c/5XceWFtYsHGzopD7iLE+2wEjnHMx
         wLbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Bg1sJVq29IP0l0ZfRic8XdzhSk92ovWlIbkT7xGYhvE=;
        fh=KLWjMOmgeMA2uWb31lAu4T8HehP+YzNDFO4L++yuIpk=;
        b=PuNWOcV9nbrububgjp+QZSW+ArYfs+R0LWFn/bgO8gdQqon+UCGOJH4Z9p9n6qpejY
         QyrA5tSy63FTcKDoh14RExBQhT5yfPUZKcF8qk8LpblbiyB62J9/wbeaXX3g63O2ndS/
         dfvade0fycSMJdWtQbMSGqT3QBFr5YDbVdcH9u20l5Z+XFXUdLI1uXrDzxk7pOymwApe
         vu7l8jjRHvr4zyzra4K4gQ3qmQ79xacdiAM1YzbatUoujb7R4tReWu9ciw4dCkcNPJWS
         nCZmr4EC31Yz2afk97dHxMJHb+UPy4zyQI5pVoJKETAqclK/nhkfr8SgU9o7tGcRe4QV
         ZWXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779224542; x=1779829342; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bg1sJVq29IP0l0ZfRic8XdzhSk92ovWlIbkT7xGYhvE=;
        b=ZEBWKWGWqLb8Cpxt7oL6HAvAzB7hzvgh5a4Uzl4YBfsWasnmaBA4h/7IwWja4vDeyV
         lNRAo3IP1DAvhKmgA5BTp+BZ1bChINjRzeCWo3EKLS0uPV0ziwvwaLBo0/tsrxjWBH7K
         E9zJGcpQ+a5Vlp72cnKwOUrP5s3VcC4MrpBxjGgX4bBcO0wzV8Gl3iLSH5Vkoh5gh3hl
         Z4v+vwQnaqTtXrEh49JhLDrlqam8RNe0KMkLYoLa5KFuynGmV++ZKkTLCJV8MN0b31yr
         je2lvVzMA7+iNcqEs2jvT5qyXSjDXZZ+2kfmljmTZD1hqa8mzP+an1Ewq2czL7VEaY5q
         Fxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779224542; x=1779829342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Bg1sJVq29IP0l0ZfRic8XdzhSk92ovWlIbkT7xGYhvE=;
        b=IteCxOkxPEa86sqwRZ5x9C6byigBQpgpJUYSSkyNaiVlQV+L19BPWVkp8TlPe5E65r
         JuAUNxUyJ3EPr2aTfMmyV0nQeadAXzNkK0ujzLbuxY+iHtfE2o9VCBcge51fa0ZH16eD
         hIz590WRD2le1g1F6R8ieh9hN6IO4OE6BbYg8CpsgY6MSBob5xL4R3Kr5esDhyeXtr8O
         Hz/f65sVg4We1TS8259hPzCjHccoxPDshYLP5nCC+poSC0tZuKNOJYaU8Xj1atpfmmPT
         P3xou6XNPtJLA8KgDBpRDkaDomEApoVJWSO5Gbsxw72HxPC2aqrrL0Q1EHp5SXLe/iDP
         c93w==
X-Forwarded-Encrypted: i=1; AFNElJ8NzUG3F1vG1UFk9ru6+D3i2TdB/pxyt9j09OP2tj0kattVwFIi4fr15d8gIvOlL8ejpYKQdCOXlg==@kvack.org
X-Gm-Message-State: AOJu0Yy7i92JaIOtI0CxakRTt0gYvGX2DMSynjYXM5NwXGWwEhnerY0l
	8CVpZnvJsaX+vgV1myMDhvu3NlpQQH7fb+W59YjWZAdnBvtIU8LnltSRIwKmg+k79DLUwSwySdT
	OBvz4cuFcT+haduN54aUScRVzfAFJ4/7IFBb2cN4=
X-Gm-Gg: Acq92OFLOru0QtrSzo7NDDrqdUE+2huGTHhWbOziw0jh/J8PpOvlkIeNGq1rxyJuUfA
	hn9mDtOzb58LWAK92xORKpaJPZHDZabIpzpES/iRFOou3X6BQePDryXde9jvgsuQLDxzN5O4U2Y
	2oKsH89cJqzX+O/SsGeMqet3gOdX8uEUU0XHRgCo/HW7DV/ovXoHZ+/Ept6alNQ/YenEgPHrdsK
	FKCULTyDZv6PdohQ5oJZQhgmfWRnqZsVesfq+vs05eVW2StVRbJgy+1Dp5jPFSuYkq4Cbe649EQ
	RYs9Www8kb6RJr64gQ==
X-Received: by 2002:a17:907:1b1c:b0:bd2:387:6bd with SMTP id
 a640c23a62f3a-bd5177afa91mr920483166b.4.1779224541529; Tue, 19 May 2026
 14:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <CAHbLzkrOSoh-jmR=uaNvx73n_wn+vExoKY0UzH5zGcfdAiDbNg@mail.gmail.com>
 <agxfLNuLCAT3F4cW@lucifer> <agxnJ8R-G3CRjeTR@lucifer> <CAHbLzkpjOLrdRSUF3-G4d9uz6tn6QYwgB66UU9bud5WHr5FWEw@mail.gmail.com>
In-Reply-To: <CAHbLzkpjOLrdRSUF3-G4d9uz6tn6QYwgB66UU9bud5WHr5FWEw@mail.gmail.com>
From: Yang Shi <shy828301@gmail.com>
Date: Tue, 19 May 2026 14:02:09 -0700
X-Gm-Features: AVHnY4IdUrtf0zjmci6G1wPksPxXO0JC_jVTm-UIYV_TFA36gqIEv83n9ohB0es
Message-ID: <CAHbLzkrTF7w+T5mGsQuDRuhnTk6evTKBNRcH4oS=nRcUg2zpsg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, surenb@google.com, 
	akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dsx8y4f8cuwatx1f8p6bxzj5rnsfhwyx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C5494000D
X-Rspam-User: 
X-HE-Tag: 1779224543-794684
X-HE-Meta: U2FsdGVkX1+I/ukwX5U3rBx3n1pqIKcSz4N2igsOAz1maxoG9iGvHIICWxTvFV/kBndecugb9+PF400t1splu0bJHT/Twn8MF+UKNma538u2o74ab4nBvpwsn4qplR2RB5dk8o3ZYmUtxgjXSBXbm4wp62THrgqgHM13wzPepYlkvP0rnB3QK8YoiBftmFJj8LICUxOtpS0tvvwnPSOZ5xblbsUqZc9A0MEoRyFx2BntFVdnxexYme7X/Wf1MWhyxPVe2l6U01KeR8I1yWD0qlvM2yZgqVVe8Ut4ycjK/GHL3NpM6wL6dZeghaByx8gagNYwcgtvncAnIfwn4wZO4wS7WUnWxwaur9LurtlH+NtBfBvp/Ktr8YOQHofjrljXALNu3A1IkaWJ9NeFph8tgAg1uICzAZykdH5RauJDHGv6aWMt1US0EdrS45uHZgK9dykgT86TSTsL/b1I2OPr/5eRBYq9t+haGeAefBfJqkEuP6bEHq3XMGY/gxNQA6ZGLTi/AWfP1bXD+POPLFXzBAVl+YyZzrGUvqxtRj7L2/B+K3KCprN/GnQZF2NwevJNrd0lJ5jkBzAL0mnz1wxUcoBsKR0uA+r0EKdPrQdSk8AQ+sdrYXH/ZTWrhO+QsSGwyCSrqN9z/cblFw+pB4B+GRvanulvBWjZd/jy907D/RJREH7gZ8WkULtqe6aIv0YWdLXwzHi9OxNd91QjymHd1a/YAQyw2ClbrXjlzINKZPrp75ZFcJ6U2282sEONZqMZtTBQj+bav0GlMoxnunEaFMgZPCGu4KTLEVwwvqPZOk0BqzMZeyOtgQWDgdv1DQN8FOcM2erY+0nMqEIviNmFodeGwYqLWtfLLEHRxRtQLVAbtQgWg5qlM+R5/vTnjU5iRsKZZxOxPeIlDX6rVuTzF4riNArXig966zLHNt2brYbm14o0rnGVf2t/r12OOkCEQmHpZqIMvtWw/Iq6G+H
 WyqpUp9G
 wkDH7p6QqBXZaSxlI3HiyofRXQOGf3GlE6gfJ2zFj+vahOXFP7nv8wcX8gvEzUOVxFEBN6HdRJVtCpMe91C4EAPjpV8XJlH4FzBKITF9d32TNjqQv2yuofYrgVV3I8/hBvkaOIBS59aN0+bY4ZI8o24mODpcr1fEgME1vqigFiwyZ/dDc5pm+bT4qpM6nZDI3PQT8RB2Psgx/FFQjOenpl2VZnFYLxop+ulLt4qlYgdS7DRs8EFxHxB8v6bGiewX5lCLLcPF/g985gj2n4ru5OHzg6PLgDrbcVYpA6hVvEXTyy0mVHEgJry8380kWNYH4DeBeCtzYc7UUvI2ZT4X2uUBh/ZGMesmgQRBmGGl5dtgZGAE7N7Epr48jJWa0HX8VcB7uB0Pk6q7AmeXuF7aJVp1cCCtWNpIO0eRTJxttXIcnW9vZlG28H0IiDtMrd3cQyTB1/RLvOaXCyEXPC0ONFELatKxe5MapABbnOBr0ImEx3FMIgpKyFrK4sJuAO20gZRWxENylDMG/whvGisSzmsS8aWoBPeDyOA/LalMMdmiIYQLR0yBvdR6a2uJsDkFY5xmC/C7tP926TENvAeGM4XXOrwxzcns9inqHWGHNsKQfIwpEwV4mxEUdDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 11:41=E2=80=AFAM Yang Shi <shy828301@gmail.com> wro=
te:
>
> On Tue, May 19, 2026 at 6:39=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> =
wrote:
> >
> > On Tue, May 19, 2026 at 02:12:10PM +0100, Lorenzo Stoakes wrote:
> > > On Mon, May 18, 2026 at 02:21:14PM -0700, Yang Shi wrote:
> > > > Maybe a little bit off topic. This is an interesting idea. It seems
> > > > possible we don't have to take vma write lock unconditionally. IIUC
> > > > the write lock is mainly used to serialize against page fault and
> > > > madvise, right? I got a crazy idea off the top of my head. We may b=
e
> > >
> > > Err no, it serialises against literally any modification or read of a=
ny
> > > characteristic of VMAs.
>
> If I remember correctly, you are not supposed to change VMA
> flags/size/mm pointer/vm_file/pgoff/prot, etc, under read vma lock or
> read mmap_lock.
>
> > >
> > > > able to just take vma write lock iff vma->anon_vma is not NULL.
> > >
> > > Except if we don't take it and vma->anon_vma is NULL, then somebody c=
an
> > > anon_vma_prepare() and change vma->anon_vma midway through a fork and=
 completely
> > > screw up the anon_vma fork hierarchy.
> >
> > correction: this won't happen as per Barry (see - I managed to confuse =
myself
> > here :), since for vma->anon_vma install we take the mmap read lock.
> >
> > BUT we also have to consider other cases.
> >
> > >
> > > So no.
> > >
> > > >
> > > > First of all, write mmap_lock is held, so the vma can't go or be
> > > > changed under us.
> > >
> > > vma->anon_vma can be changed.
> >
> > Correction: no it can't :)
>
> Yes, vma->anon_vma change should require taking read mmap_lock.
>
> >
> > >
> > > >
> > > > Secondly, if vma->anon_vma is NULL, it basically means either no pa=
ge
> > > > fault happened or no cow happened, so there is no page table to cop=
y,
> > > > this is also what copy_page_range() does currently. So we can shrin=
k
> > > > the critical section to:
> > >
> > > Firstly, with no VMA write lock, !vma->anon_vma means a fault can rac=
e and
> > > secondly copy_page_range() checks vma_needs_copy(), there are other c=
ases - PFN
> > > maps, mixed maps, UFFD W/P (ugh), guard regions.
> > >
> > > So yeah this isn't sufficient.
> >
> > However this is true...
>
> Yes, fault can race with fork. Basically this is actually the purpose
> of this idea. We can have improved page fault scalability. In my
> proposal (take write vma lock if vma->anon_vma is not NULL), the race
> just happens on the VMAs which page fault has not happened on before.

Sorry, this is incorrect. Page fault can't happen on those VMAs
because page fault needs to create anon_vma, but it requires taking
mmap_lock.
If anon_vma is not NULL, vma write lock will serialize against page
fault. So there should be no race with page fault. Removing vma write
lock suggested by Barry may increase race.

Thanks,
Yang

> vma_needs_copy() also skips the VMAs which don't have vma->anon_vma.
> So there is basically no difference in semantics other than more page
> fault races IIUC. It should be safe as long as we can guarantee there
> is no writable PTE point to a shared page after fork.
>
> For guard regions, it can be serialized by vma write lock if
> vma->anon_vma exists. If vma->anon_vma is NULL, it will prepare
> anon_vma, which will take read mmap_lock if I read the code correctly.
>
> I have not investigated UFFD yet.
>
> >
> > >
> > > >
> > > > if (vma->anon_vma) {
> > > >     vma_start_write_killable(src_vma);
> > > >     anon_vma_fork(dst_vma, src_vma);
> > > >     copy_page_range(dst_vma, src_vma);
> > > > }
> > >
> > > Yeah that's totally broken fo reasons above as I said :)
> > >
> > > >
> > > > But page fault can happen before write mmap_lock is taken, when we
> > > > check vma->anon_vma, it is possible it has not been set up yet. But=
 it
> > > > seems to be equivalent to page fault after fork and won't break the
> > > > semantic.
> > >
> > > It will totally break how the anon_vma hierarchy works :) See the lin=
ks at the
> > > top of https://ljs.io/talks for a link to various slides on anon_vma =
behaviour
> > > (it's really a pain to think about because it's a super broken abstra=
ction).
> > >
> > > You could end up with a CoW mapping that's unreachable from rmap and =
you could
> > > get some nasty issues with page table entries pointing at freed folio=
s :)
> >
> > Correction: actually we should be safe given mmap read lock on anon_vma=
 install.
> >
> > >
> > > >
> > > > Anyway, just a crazy idea, I may miss some corner cases.
> > >
> > > Yeah sorry to push back here but this is just not a viable approach.
>
> No worries. Thanks for all the feedback. Just tried to explore whether
> such an idea is feasible or not.
>
> > >
> > > And this is forgetting that we have relied on page faults being block=
ed by fork
> > > _forever_, who knows what else has baked in assumptions about that
> > > serialisation.
> > >
> > > Forking is one of the nastiest parts of mm and has had multiple, subt=
le, corner
> > > case breakages that have been a nightmare to deal with.
>
> Yes, this might be the biggest concern. The page fault can race with
> fork. If some applications rely on such subtle behavior, it may break,
> but such applications are fragile too.
>
> > >
> > > So I'm very much against changing this behaviour to try to fix someth=
ing in the
> > > fault path.
> > >
> > > We should address the fault path issues in the fault path :)
>
> Yeah, this idea was inspired by Barry's "not take vma read lock
> unconditionally" idea. Maybe irrelevant to Barry's priority inversion
> problem, just an idea for further optimization on page fault
> scalability. This probably should be a separate topic.
>
> Thanks,
> Yang
>
> >
> > Above still all true though.
> >
> > >
> > > >
> > > > Thanks,
> > > > Yang
> > > >
> > > > }
> > > >
> > > > >
> > > > > Based on the above, we may want to re-check whether fork()
> > > > > can be blocked by page faults. At the same time, if Suren,
> > > > > you, or anyone else has any comments, please feel free to
> > > > > share them.
> > > > >
> > > > > Best Regards
> > > > > Barry
> > > > >
> > >
> > > Cheers, Lorenzo
> >
> > So still a nope :)
> >
> > Cheers, Lorenzo

