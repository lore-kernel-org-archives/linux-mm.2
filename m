Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C36CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 08:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B8C6B0005; Sun, 17 May 2026 04:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC9D6B0088; Sun, 17 May 2026 04:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001E66B008C; Sun, 17 May 2026 04:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E383E6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 04:45:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BECF404E3
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:45:30 +0000 (UTC)
X-FDA: 84776278020.11.4952F40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 675C0100003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:45:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IcZT9tUo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779007528; a=rsa-sha256;
	cv=none;
	b=TO8A1yw55b8PAXaHDtE+5H2T17J9o1vJO2C88KGKIJOOSXHdrGSxWWmQUNC5SwC1QkKb6P
	/756CVAhbM/Q4GoFB5dhWdFiXx3F8/SNFzvRnqhyyLekClsePFi43hEZoqKSBJUjzj+xpu
	XePU0DuIXMt7p1n/DUCV1LZN7tcPfg0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IcZT9tUo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779007528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwqWSnt1f+GtnaOqHAf4nnsKSW4Dkee99uCObNaViNs=;
	b=mO0e0IxvkWidueFtnMSwVegg6p9K3fJ01ikAkj4meEJYTyQvoYus1d7mDCze5dr2w9PMuo
	nG8Pdj6UHK3/qcNMg2/Bu+HXNGaRpV8BdruY1FJY1mvE8EfgcnXo+mvZI1UoTyV/2QBZJV
	19YE7p/FSxSir55eh9Er9UDXrSzu+CM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A29D443A3
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58409C2BCB3
	for <linux-mm@kvack.org>; Sun, 17 May 2026 08:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779007527;
	bh=p/9AJiwpH9htKz1qH1Sl1BuAo/sVquMqqj2hIHE2j60=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IcZT9tUolcrkwWW0g0RY9HTDkbfvMUWKMC+4fxz9cOlxN5nLUbfxb37rlEv77K6Yz
	 91/W8a+pD9VIXpnwYL9jbGNNe64gmPI7/gmARH/LrsqxjAESIXXbB0hoqlAI/eOVyA
	 71yxBQAqlF7qQVourMYDTKkIlJOEhH+OOJG8NyQvxKt+Jkv+ZeuvJZZuT8Uv72hHKe
	 5Uy2D1EisdI1IXy6U24mBXVmBUDot+lzpFzHE4Dt6atMPLsp/jew4RZqdckHNc2wLr
	 FmqGPcBeg679dY+2flLU2OkyQdSmrf0RqKFym7/EfEyCQaoVLB61fYxtlxJ1BqzoTE
	 TcjhzGKbClSVA==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8c9166b26b4so18535246d6.0
        for <linux-mm@kvack.org>; Sun, 17 May 2026 01:45:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8Ok35ilLrt/ZtCBCIFqDdEky7GIb4o+Vn3GUCcer6Gwk4yV/Vlxs/2kMv1dwEN11me2eHUlURk3Q==@kvack.org
X-Gm-Message-State: AOJu0YzOGG3UhikEA/SrstCLWHIFEgsraolgXJxX5jhcLJQN22onDjw0
	MnF3VswUMg878nUoe+0IufMODN5cHFfYBfSnqyj3o9RL5e6RpJGyfUtDwFGCBdB85cuQFBK6o1o
	emSaWV0t8dsP6gKdHbjRnauiDI7QYipI=
X-Received: by 2002:a05:6214:1c82:b0:8be:7ed5:477b with SMTP id
 6a1803df08f44-8ca0f6b95a0mr188510036d6.22.1779007526681; Sun, 17 May 2026
 01:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
In-Reply-To: <afTpoL3FklpQZNMM@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Sun, 17 May 2026 16:45:15 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
X-Gm-Features: AVHnY4ICHad0vRrEOEwJ7DjNSE1jL9epFkBx0OBK2sLJbi9Nv2hHU65J8Z0HpVM
Message-ID: <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>, surenb@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, 
	chentao@kylinos.cn, lianux.mm@gmail.com, kunwu.chan@gmail.com, 
	liyangouwen1@oppo.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zrsc98wrrkj564amj9su8hr357hu988n
X-Rspam-User: 
X-Rspamd-Queue-Id: 675C0100003
X-Rspamd-Server: rspam07
X-HE-Tag: 1779007528-169214
X-HE-Meta: U2FsdGVkX1/oX1k33hqmwjenF8zAJ9r7FbN2SFDAeDy60fKSzk/DKnVWJntlVUiwLnXP6AtP5OIMhvNGNji0qIEJz3fxN6gRhrsXTxAWWyVvoqrrqSLINpP8yvQ3UzlKyBZXp7y9bsEMGeOWaqOu0Ll++uTvcmbhy/l/EjNW+XjKfGKZrv88hV3DiFLgstJAyfBVKfw/GbuD5qrVRrDxYVTJSD2rhifQjurmBDQRy/5vDgUfZY5h+07sUB8iNdfPQHpXKnK0kxjru0+xo9TN9XEu3Vv6Y0sPGfc7OmXc2h+sMVb+1ne4m2ppRpp4+kKkuKnFf3Iv77A0JVC56h2qYOAvR7AB2maE7jfq+dafYZhvXbMR5QyhvZSno/6d1UjSUi8bmV+fJWKmp7G3/B1KdKPIMxW0PKT++4EDSG4RXSxPKhsACUNqmHDzov7sqi7TiHFBAlNZ7yF2YSnkiqt2/IW7VWw6GDNoYUBuZPadi/fGiOj/6F7QXZ09WF9HgsK77Pjs6vQRRyQ7xoDBvzLQpImr/dIQQXOpMc3dyTlbKNPtfkGe1ukDn3zqqWKVjE1XLcQWGN+edwpK/4RAQeVVjKvJjFuYg1WpOfVkDCAWQG/AqZpkS9ZAAaM7u8J7+mJSp6q1aZujKyP+iNaZzgdX3stxXUU+HoojEjR6YpHb86dX38Md3DXdqGLbPbkrLjJzJX6Ytjao16nDMCgpt4n7R/+JRtqRE+TA4wOwjs3EnIgluJ2qOGZ23HNEfhhNqdUlrpC0NJkmop4iN4HM1zEeqBuVfwsR6TOnT8uZfqbllQX4N0GdtVOwLaIUkGV7IfpCjD+9tLswJvGXqBmbDWfDxGTVsuOJWcVL7SdLOBGrh7Dx5t4Ud6D0erWXNHdUJ40z1cRimSkGnl4vu2fKJk2nPET4g+ybmBhkJl0AQMqktMpc/UtH81k+sf2zXg5MyCgZ0j061SSFsuYzFNU7k3S
 SNWNpUBW
 /OdIPfvv3vZBb6ZRI1tvnA1ZR1AObh+38fQGH1kl0UGadMiJeHNfn2c9apwHvJ2QlqEMfeze13zZrNSThShy9gBueR5AsJEJ48Wy1DUGlt8pp8fgh3Rrx5bNUpU2NC2WemN42qyqjLVz6BJ2+3dYHRkWIc0lO5gYwVn418/BbUUcDnxQ/ImL+boEVVwtmdGaU92sQqbcwYyr/EHih+v7vDNCMwBSWT1uV8Flbh2m3hmr8r4DXsMn5XH8S6EApPxK4QB1jc1GhHtklzMjQrUYX1kdBJliJhdgRbudmWyzPOHG5MA0USpVfAwQlyAwVgKY8rh5Y/7mFjY3h1OE/c1qC5/xKGojkeUVNbK7jClbwycTrCECWcM8Xylii4DsVcsCReWsxEpVQFFG6Ht404YKrnMEX+WR1K2HWPtpMwss+tvP6Ykk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 2, 2026 at 1:58=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > 1. There is no deterministic latency for I/O completion. It depends=
 on
> > > > both the hardware and the software stack (bio/request queues and th=
e
> > > > block scheduler). Sometimes the latency is short; at other times it=
 can
> > > > be quite long. In such cases, a high-priority thread performing ope=
rations
> > > > such as mprotect, unmap, prctl_set_vma, or madvise may be forced to=
 wait
> > > > for an unpredictable amount of time.
> > >
> > > But does that actually happen?  I find it hard to believe that thread=
 A
> > > unmaps a VMA while thread B is in the middle of taking a page fault i=
n
> > > that same VMA.  mprotect() and madvise() are more likely to happen, b=
ut
> > > it still seems really unlikely to me.
> >
> > It doesn=E2=80=99t have to involve unmapping or applying mprotect to
> > the entire VMA=E2=80=94just a portion of it is sufficient.
>
> Yes, but that still fails to answer "does this actually happen".  How muc=
h
> performance is all this complexity in the page fault handler buying us?
> If you don't answer this question, I'm just going to go in and rip it
> all out.
>

Hi Matthew (and Lorenzo, Jan, and anyone else who may be
waiting for answers),

As promised during LSF/MM/BPF, we conducted thorough
testing on Android phones to determine whether performing
I/O in `filemap_fault()` can block `vma_start_write()`.
I wanted to give a quick update on this question.

Nanzhe at Xiaomi created tracing scripts and ran various
applications on Android devices with I/O performed under
the VMA lock in `filemap_fault()`. We found that:

1. There are very few cases where unmap() is blocked by
   page faults. I assume this is due to buggy user code
   or poor synchronization between reads and unmap().
So I assume it is not a problem.

2. We observed many cases where `vma_start_write()`
   is blocked by page-fault I/O in some applications.
   The blocking occurs in the `dup_mmap()` path during
   fork().

With Suren's commit fb49c455323ff ("fork: lock VMAs of
the parent process when forking"), we now always hold
`vma_write_lock()` for each VMA. Note that the
`mmap_lock` write lock is also held, which could lead to
chained waiting if page-fault I/O is performed without
releasing the VMA lock.

My gut feeling is that Suren's commit may be overshooting,
so my rough idea is that we might want to do something like
the following (we haven't tested it yet and it might be
wrong):

diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff4..5ddaf297f31a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1762,7 +1762,13 @@ __latent_entropy int dup_mmap(struct mm_struct
*mm, struct mm_struct *oldmm)
        for_each_vma(vmi, mpnt) {
                struct file *file;

-               retval =3D vma_start_write_killable(mpnt);
+               /*
+                * For anonymous or writable private VMAs, prevent
+                * concurrent CoW faults.
+                */
+               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED) &&
+                                       (mpnt->vm_flags & VM_WRITE)))
+                       retval =3D vma_start_write_killable(mpnt);
                if (retval < 0)
                        goto loop_out;
                if (mpnt->vm_flags & VM_DONTCOPY) {

Based on the above, we may want to re-check whether fork()
can be blocked by page faults. At the same time, if Suren,
you, or anyone else has any comments, please feel free to
share them.

Best Regards
Barry

