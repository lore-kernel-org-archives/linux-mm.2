Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79269606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=igJrB6oc
Received: by kanga.kvack.org (Postfix)
	id 89C106B00EF; Fri, 30 Oct 2026 10:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874816B05B1; Fri, 30 Oct 2026 10:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A956B05B3; Fri, 30 Oct 2026 10:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3BC6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:54:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B918214056D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:54:26 +0000 (UTC)
X-FDA: 85379588532.28.242F029
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF04340004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:54:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=igJrB6oc;
	spf=pass (imf11.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.51 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793372064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMsUz0CmedXWqrdh2TheB4BjYFtAJcIsl6CPDLvVdyA=;
	b=oohplPNy3L7Q9iXmQJQw4OkSsscMIV5g4le6NZ9HqYgSgOwoSMj77viYuzc7WbVsVFMr+n
	ABQdbHVAPOOwM3kadPa923Wjy39s7jtky+HygEyrCouGWbzYnyLbnc2ke9t0KPLjCuAvVE
	wkdR2UsjIpcGkgxZfWSd4jCHDnmfG04=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793372064;
	b=ULKG7L4045cPRZldYO+WwpV7UlcHDf+L0O2IWUVuTOKwjDMhBD4aGfTlxw1caagV98SeoX
	iKD3T7M74ucEW3+8G/R5zlxMzFbfECFoXMF3S0w2b/c/gQV3pFW2yz1n4vqZO5DfJU0ptt
	/J4NVXwC4zvhhWNjw6+FLi4xqjJbSGs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=igJrB6oc;
	spf=pass (imf11.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.51 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5bfc2ae6e9dso643688e87.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:54:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793372063; cv=none;
        d=google.com; s=arc-20260327;
        b=YrHdfsUMv3KHWf43qiEmxvX4WIXNB3HJK1lXHj7Oo20lNitCemn7l5kpnqHtHmZQyk
         fz21pRcb7gs3ktlLJpxa5641dLZ/GVtlUxJEFzGq+nGbk6XJ8zetb/QGRf4vGouFbyiQ
         bU+4GZ4FmqU93jRBhuVvjRWQlhs/SPkBkofjq/44O3Q4UmXCtzctUSx98mbphqOBgCFd
         T2BkdTM3qZ5kYV3BNhs3gMIFV9cLOYvwYPtsrP/6Tf/NoKuP8H9e+nAsKgKPZsf4iAoo
         5yYZ9/X+jGulslb7vZAIzFHsZq7Xm1HZFjWEtPYD4XE1l31PzCgaF2dDnjzPYSEiR5/x
         WTww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jMsUz0CmedXWqrdh2TheB4BjYFtAJcIsl6CPDLvVdyA=;
        fh=1X8SA20Hjco3j7TGn0UowgGlp2KJV67QKdbqrsSTF5M=;
        b=aIRPamokn02b55xj7GsNbFNRZf/k5txqUfnaLyA9Grv1X/7ygMsIdFCdYHjTswfL6Y
         d7bPVZCRr1LKFd+y7ubqHYiiKOUGLvHe68S++0EMav+9fZGVCvf/H5UPitOBgiwRq6/P
         DJasbS7Hs1/lzh0lGA79Uf7YsBDxq1gM21x5O3vbJW1xsoyGNhHS+lG3JMs4l9vDH3zW
         tpUmKxwS0qEEsgdBqfjzFiLc2XEcjtt5M16BMjTmWiiAd7Bl5AnYV98YBWPRs3f/7Vvn
         5JXgEd02b0aOg4QCAAc7j0EAdG1S+Z0JVD5kSoR+Q5cHMIRlicy2zU9h/v8UJbmF7e38
         cztw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793372063; x=1793976863; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jMsUz0CmedXWqrdh2TheB4BjYFtAJcIsl6CPDLvVdyA=;
        b=igJrB6oci7OixOLHLH/nrHic0kcwMPifLuzs+TepmReG3NnfEbjXOwLDWBMIUSirGi
         bmnVq0fn+Lz8eq1w505AcaHExJFnQYGIX98kiqdGyb9qT7ARqkVyM5AsPLs4COCLAJ3d
         TAXMT9eU1cTm/2wR+t5hx3AkjLceH5MKdJFOTJ3mu+zGnjyH3+UtsNwBMuWF8xTRePY8
         /sR2onoLszVnTh09GdvbOTg3f9xjTvkFXTVBOkvwIDO0VOPmjJVGoNygeGFB5HLrLB2m
         qWQ++nWM2QmKoEu9JoK/TmjdHP+9FPgfs27EpJuHgWKq8DjYHQ6BuIvlYdc11ullwNOm
         HjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793372063; x=1793976863;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jMsUz0CmedXWqrdh2TheB4BjYFtAJcIsl6CPDLvVdyA=;
        b=yNdQqvLc4TOBdaXyf3QRTDN8Zrbo8wn4fpGp/8SDdMErN4Fe5+FPU0hphu1XCBVi4I
         nDAsSIbdoJR8SXXpdCACLDrakLW3csCv5Y7urIdNiL0emDBjt2FRTiD3T2Hb7+XXAvRY
         gswmbhcSaXJzsWbbIS5ybSaxt9N3C2h3VPkU18F1baLryhqxZaxH22XebqoKLcy5VXMa
         R5KUli0SLOO7r0c8zPJBcY6HUbYZl6TXOg57aDJq0CayHWVEiy2YdmYzNTulHOlUwSq5
         Vm6/pmV+M6XfQ3nsMfOPZ/IECUclowwla8R/ZwnxA041+YqO/aumhyphLOP4v+WaQ+2m
         a3Wg==
X-Forwarded-Encrypted: i=1; AKwUvBz6yE1tZ+Y1dZOIbfZQSDFUsdTpPvM9Ts/BBx/PwiJMsJjQAO2W2ydETDwh9saFZJwdVmtRvKY1ag==@kvack.org
X-Gm-Message-State: AFq9FYJU9NX3D4SSgAXxN5SD/SwiG0ol/DPyprZPgDjmCVmtJ9F1CW+d
	EZQV6CEIMNaHEUzt3+c/ZUPuc4BXfe2b59XOqCJGYHmmx7bcvkCFng7Jx3vJjVswNY/9msFxJQA
	R4zebJpsu30DUMrI3qWnNtTS/decTyj7JspBnfAdp
X-Gm-Gg: AYBFou2r0DXqwX0DpUiAhwjtli8MFxbwuHUrFf5ggjPU98EywO8qP2hEjbVA03tXXsh
	k3TnQR3XGjKUrcoOa/eHNel2rt9wQOItzSxkRuGlkHpPQpej/3XI/Ft22dLnY65ySfmLWz+GCmw
	u5tqErpqixfPF+G/i0zJvzmJyWD3BIiJWOwKrcOu3ZNx93MzCZN5WDX50r9CaRBrXmlVh4IfUsx
	Sz597kvMOQ0DbG3P/r5Sj5B09y6I7HL+sP/O0mcgsSYaPOqD0HZdmtrniVuTEgQmHq9bam/636+
	v7rpw1EdUkrVF0UOf8kuh946JP99qvCn8UrVj8JdQSwq9L8jfuxNzZNuKv9Cx/xD+026L9NrEmu
	ngKU4Ov9nryHgB2a+N1tL8UVjW9qyMFrvXA==
X-Received: by 2002:a05:6512:3402:b0:5bb:7b2a:5b2d with SMTP id
 2adb3069b0e04-5bfd9566d37mr824353e87.35.1793372062806; Fri, 30 Oct 2026
 07:54:22 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com> <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
 <auPKfqh_YjRU9Ui3@google.com> <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
 <CALCETrVpEP=HxVqdSP_AgA=U7ignwAgjz5Vi9+Z9dZsX5DXeLw@mail.gmail.com> <20261030121259.GC3889730@ziepe.ca>
In-Reply-To: <20261030121259.GC3889730@ziepe.ca>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 Oct 2026 07:54:08 -0700
X-Gm-Features: AclHuK8DrMlKsyKpQjiDV0_C05DMTWGTaa3ilPqU973TM9OhhHNjeL5jGLxSymM
Message-ID: <CALCETrW6RUgTGFuqx+cxV0c+Oq4d-P5C8AQ2ja0ESMP_8JGpxg@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF04340004
X-Stat-Signature: pgxtpebj65fx59e47qhn1djnnph89fog
X-Rspam-User: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793372064-786850
X-HE-Meta: U2FsdGVkX18jur//u7gO2/xr7gJ24TTtaxJ2jJnvtaqQsF0FUfqw8EQ8srPpXr3NBYegjPhsPVB8VD4oilhOrvfcCoQ3MRx0cr7alfWfyQdPHHwML6Usl5TzL06aReW7++3encOZGgWo9nD7O1hasOG7AcFA5sUcuA201eys7G9NJLwTIUJ1j+AGDXwzaQKw6v9AtI5BLNlRIKuOgXQP8fgWUY3VVDySNG6ew0kB7SZvSSz0yiaj/DRC2ObufjjIH8kTJ0KVtFi4MEhtOmoeobY2fyNBKGwVvtoqoT4t5HPMfNcen0/OJll31Jldf1/qzPvr6ESR0JYh6+oh65+5YModUqxglqdRughwZHvJJwdAr5wLdAl3/tLpVVwyesq6v3Z1wofMgKWoi/p58DVf7fGTV9Wvgs1fMKcfjwZ6XXFSdpPD/w4Ljqyc1J+DRnjwjlSQ3CvK54uPTQ+p6Mwbd5gWuAi6UmqFGi3YN/IGY5E48Sr1KWBBkaD07SVkB9xTQKnIkOlgV9wClt+HpCSCN4xeZFv1vVhxtDYW+6fm2YFxu4eZ5HQqMsiklDDLE0mI1IV64qG4XJXsLqwfP2RjbxdQQHyVkPmgbYvKKmuNfiNp1FHQONQ8nfJMgf+YsDJ8fDZkGh+r/pf9Nv1/91lDV1Md2xmQlsvOINpbT90jl6gB9+V+w03a/Brc2RiU5zVjjii4SicTGjYqYyCGad+5vuNsWVzb7pMjiocFHfjLTXMhJvlzQ3MBnfIse8T9yjuSb4JWSntb+z5k2OY0wUXtptniNWiB5g7m/C5IqklDpunmBTE+al4Lde59wD6S6Rje1jeOqoBv6BJV1SNPAC5wYpOAMvnZmUPmhxGE+vu1a/JIJmK96W6Gvtb8o5gTW2M+yK3RRI8dzVmpLcy4EhJ3Bmx+i6fK31b8/fJMrLlAHj6Dbk4vaFDspG/eiSfGkW9g1SS96SYZVrFqfUjP3aH
 6FtzVYBW
 lhpztovA4J7j/nWuyEDNvJYvwCR2F+eUbpmI1HRIttzVw/Ax8Kx8p3/sz+Zn71b55huhD3Bm8IwJg9lSqqxhydgP4j0SLnc8sxIoXAC7Xju4rI2R3yVZTz5V6q0AW3ebQB+qkacVyx1FMfWT7EwpaFTaCEjZ6tY5/03/HciXaiJdlSlEQRv7hEJLG+AN7T47ntAfiFEITQiux1WVqYbF/tjuqkC9SNMwh02ZNGKT7AmTwNE4WcNgR/eccd4jPQ1J3TpTDZPyCeg6VQOr9rkTlQL/h9WMlKQzMZsV3KbHF88rL8iqZ6mOm3LbusFnW01SRmQBAHmqNE0bvr/WBsOZDdwvdWqhrzrYrYrGCb/M+LKlU4FzWGK/rPUnCIEfj32YEfDQEqtXAnLR/EBrMt8O1b6DAR07qN/arHC4npKiGqp1lcJxpur/eaKpauXBFgjW01RtlqIMSvwPxJesnYfleQwNf1A+sT/tszD8Q1/C2pdLSZ8uHHUWOIxc0cUkbSnkc0FdU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 5:13=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Thu, Oct 29, 2026 at 07:11:25PM -0700, Andy Lutomirski wrote:
>
> > I can't shake the feeling that the problem here isn't so much that KHO
> > + iommofd doesn't like this but that the behavior in question is
> > nonsensical.
>
> It has been this way for ages, like David says if userspace shoot
> itself in the foot it should not be surprised by this illogical
> behavior..
>

I dunno, a couple weeks ago I tracked down a 20+-year-old bug, and now
it's fixed :)

> You can get the same nonsenscial thing with just mmap too, you don't
> even need a memfd.

I feel like there are multiple levels of footgun here.

mmap anonymous (or MAP_PRIVATE), pin the pages, munmap: okay, mmap
creates unnamed private memory, and munmapping is maybe like unlinking
a file -- if someone else is still accessing it, it's still there.  In
fact, you can mmap, fork, unmap, then mmap in the same location, and
your child process still sees the original memory.  It's not clear to
me that anything is wrong.

mmap anonymous, pin, MADV_DONTNEED: okay, this one is starting to be a
small footgun.  But at least it's pointed at *your own feet* (unless
you've forked, which in which case maybe it's pointed at a related
process' feet).  I would still argue that the kernel could notice that
it's false that I "DON'T NEED" the memory and fail or ignore the
request.  And the kernel's pages are still anonymous.

mmap a named file or memfd, pin, truncate or punch hole: who says the
footgun is even pointed at my own feet?  If I mmap a named file,
SCM_RIGHTS it to you, and you mmap it too, and then I punch a hole,
the rmap machinery had better invalidate your mapping along with mine
(and get the TLB flush right!), and it would be an unambiguous and
severe bug if this didn't happen correctly.  After all, what you have
done is to assign a *logical range* within the file an address in your
address space, and nothing I do should change that fact (except,
sadly, truncate, which can give you a SIGBUS, but your vma still
logically refers to the file).

So why is the kernel exempt from keeping its own mappings coherent the
way it keeps user mappings coherent?

What if that memfd (or tmpfs file or whatever) is shared between
multiple processes that don't trust each other?  One of them can cause
it to become incoherent from the perspective of the other one's use of
kernel APIs.



P.S. You can access the offending APIs from a VM guest using balloon
in typical implementations.  If the host userspace does not strictly
enforce that the guest doesn't balloon memory that is not ordinary
host memory *and that is absolutely not in use for any sort of
kernel-side pinned-folio IO*, then the guest may be able to cause the
host kernel's or hardware's view of its memory to become incoherent.
Heck, host userspace could literally use a memfd to share memory
between the guest and a separate host process that implements a
device.

P.P.S. It's possible for there to be a legitimate security boundary
between user or guest code and a future version of *the same*
userspace or guest, via DRTM.  Someone should build a guest that sets
up some form of host-kernel-pinned-folio IO (IOMMU or simply a
host-side emulated device that works this way), then
DONTNEED/REMOVE/hole-punch the memory, then do the DRTM dance and
attest to its state.

--Andy


--=20
Andy Lutomirski
AMA Capital Management, LLC

