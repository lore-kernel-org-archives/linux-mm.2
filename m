Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08636606A330
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=QBJMvrfX
Received: by kanga.kvack.org (Postfix)
	id 12F456B05D2; Mon, 26 Oct 2026 22:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1074D6B05D3; Mon, 26 Oct 2026 22:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CA96B05D4; Mon, 26 Oct 2026 22:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA1546B05D2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:57:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61499C08A8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:58 +0000 (UTC)
X-FDA: 85366896636.13.CF83D49
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 707C21C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QBJMvrfX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=veWNjOyx0q2aoHvEbX2sAz0cuq6dhXLamwz9eTavWpQ=;
	b=nkot0vgym/mUOatWFIMbW69sSKxkekph5QNtntNgPk8f4PBTiIYkK7hFUgb/L0py0zCY4i
	84CpHtbjhwPWSKrijYWbsp99xr5Ef+iEtRbZ6xbD66qT79vDEbpJFhMaJQWR40ey714HnT
	sR2sn34+HwsmujmASeLxopKXewq/7wk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QBJMvrfX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793069876;
	b=ywn9ChcGcrDRaPkZnaf1B8RVJl7ZJRF4P10/PdMWaVxGSW3PUOrC+SlraevT1Pl/2QMt2J
	4PK/g8ZopeG0g0AbL5BILPnGYUAUwtGjZW4mb2MRt/n3MviwFnuh2IcB6xCPQSO+1wCCtq
	aNDZhLduY6flWaM8WbX6AFwluIXdOAs=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-535f598d126so86191cf.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793069875; cv=none;
        d=google.com; s=arc-20260327;
        b=Ava2MDHWRpIpNJi4CmWSsYTZf/fM2AxvCHQVWKxbqWRKBzSDaGACJu3HgeGQDrmTaj
         hv5JL6nyWtUuM5an7D6DBfFV3NXgPua/dgRPvK+QbPYgENtukXgSoEF7c/EAxHST/u7j
         qyRZ1Y6YHJzhF+AvWaeE/CzP5EQvuUOi5h7Pqk88vzQ4U1DsW42O6klEMFgksL4o/yfF
         1jPn72nm7aWnkbOaj9g6SbtEJA2yeF1yDWf4Sub7DOX4ZhrsG4bGl1GS5Lt1NXZQCEbS
         mljHGV5NUtJBZ+xlUJ+8BlbD8Z1rtIEoY4SA2wvY+5GPmCPqXR7g8O6FUtCU9Ll0VfVf
         a+SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=veWNjOyx0q2aoHvEbX2sAz0cuq6dhXLamwz9eTavWpQ=;
        fh=bALwfFwhvIt5hPCINTeo2WjesW5mpNVfBh7JryxdWXI=;
        b=RkpM0eZxt4TPz9eUMBkPDM4AYvUhhKRHcgqAOJo/QgewaEGcsnpwhg1g3gCGm4gSxV
         VELGHD3kANdcfsPK2//8UsULjMMmk6+q+xlW5x5pPLOMam3Dsjw6XXmjFn4w0gEU3VZy
         2/eqbCGF5tOm7gSpV0+/ZjLrjiPWKWhSSSMbEIinHopgHmkkicxC28wxK1XrsiI+IzI1
         xE66yKg5z4On0RSk4xqfc2xspHsjgfC9BOWnV91u5Nt8lCsKp1U/tRk9a6dezTbxPAXH
         sV0FC1WYlEQ6IE/pa7Sl4/RhhoHdQJgledFR3bYc9r8mJtmgiFc6kd3yDVDcQlPn2H+X
         ptqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069875; x=1793674675; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=veWNjOyx0q2aoHvEbX2sAz0cuq6dhXLamwz9eTavWpQ=;
        b=QBJMvrfXl6J7LDs9NzlypdhbPbfEWLYCJHbg5wnl/hGx7QIoZ8VAJrDugg8gPl+FZ7
         T9haLWUcgOMl5RIBvaTUlXLpB5ZvYwgh2EIMVbR3d6JAzUHD5pY2KJfMLSMMNCkVdOef
         TNnI04eEJKVdpM4Rqjko78XNATVInrLuDlUgu3iW4wer5b4C5lDFEb8C9FYCZ80ZBBzp
         zx/P3/IEYtfpePSkrI8ywjcYqLAUmanh3pBxTLwOC72RzTWgLpuJQLGOxMDXtO+lQtel
         tsK07c/Hx1d/MhEMP/5sU3s98Ae0t3CBKzv4e4N++BmexhGnfm9Xaqi+xHHhYLWLydj9
         8O1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069875; x=1793674675;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=veWNjOyx0q2aoHvEbX2sAz0cuq6dhXLamwz9eTavWpQ=;
        b=bH+I2DuC2GRv7630JZBCui1to3AVlO+7EUkWB4m7IZCnQ8fwixsHqZe8hlRBPo1xIl
         8LFja6p+LGxUk9AT2N3hUKmlRAe5z0YcDqEE0cvdYuVpqkpKQuZGoXFYkVdAdFuUgyV6
         Bs93jbVaVIbvpP6Yfq6rB0weVpowsb0jPueo6HWdtXigNJ3cxWNy8HR8yk1JkpK5rcFb
         TieYGcjD43dbuBazLEeV2WdQSqWx07mAV0GHKSP+FZLgeiR9uC/6lbEtR0tdPtYAkp/5
         xRxOcuz0KB/gEJSjSz+L1RnN3odc8m2/kYoZW0YMaSuhP6MkOQ3q2XnQi9jOcNlk0t/p
         3Hkg==
X-Forwarded-Encrypted: i=1; AKwUvByCy5ETTYGwaMRoY3cAXH/gPIoohHWgput0/ow/EKE8bIBk3T6cwm/vu+7Wf71RdLA4JZmHw6R3CQ==@kvack.org
X-Gm-Message-State: AFq9FYLDFe9FxMqrv1tupdv++leN8UNurV/jHtwjfQ7n5Bj8Q8Affzt4
	npzMO08ZFsZopqLZEMDTEsWJqZmD0/7+e4ZNmu2n3vXNkLqycyuJP+OIgfLCiYrOVO8YoTNFANV
	2IZMWouSB+zYNmv+OSDyLj8QK94odzowPPp2j2K9s
X-Gm-Gg: AYBFou046fJ534rnd94etrZLgsx2x4xaChR/YbmLZ0vEKIsD7pV8r0PX/ZVGTiIIWkm
	LCL+SjzYp9IglaCfvX3Jrn6tkEO7IhYVvQT439gKMPGoyG9TBYmSyEem/Qz34hNSVdY6boyyQEP
	5RPlWNyDDCH4uS+2CIBfNiMohRbnec9GBjBgfnRgfYamoZbDPCKq629HV5qLZ7HN/g/V+C95RXw
	ExD0pIYSaNOCAL6EGloLI21eNaEgZtKgY+1i5c9ul1OFBL5GXT98UKO4+cakTPHAubyxcEZZVWs
	dNR8Pgm4yshu32oXVmvyCdfM3Dr+PbCu91i+g2rncchwaRb1E/9ToMDSh3k4Gd+ovs1H5odj8JM
	XRNZasg2LH2u2dTstabAWfsaIgnEjnZszlTu2
X-Received: by 2002:ac8:5cd0:0:b0:534:b7b2:634f with SMTP id
 d75a77b69052e-53e74f18ea0mr8347351cf.8.1793069874720; Mon, 26 Oct 2026
 19:57:54 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin> <arF-E3Nsw9ZliH0t@casper.infradead.org>
 <arI_w2wTfA00Mgy9@gremlin> <armexcXDiG8ryZd6@casper.infradead.org>
 <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
 <ar7MsOb6IJLt4eLo@casper.infradead.org> <ar-o1TrOMGrrcxLX@gremlin>
 <ataDTEZIKOYtwhUF@casper.infradead.org> <CAJuCfpH88HGXyLzBr6YGxzTrOq18HaPcRvhN9RwEBxG_ptv7KQ@mail.gmail.com>
In-Reply-To: <CAJuCfpH88HGXyLzBr6YGxzTrOq18HaPcRvhN9RwEBxG_ptv7KQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 26 Oct 2026 19:57:43 -0700
X-Gm-Features: AclHuK_KCyZzsUIRPigLpRqw3YeQAHnl6JHTenlWoPcunSyUcxCZShOICs2gDrI
Message-ID: <CAJuCfpH6o1NAN_4W6VY6o3unxr9V+YCNFiLS8oCg7giWRLz8_g@mail.gmail.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
To: Matthew Wilcox <willy@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	zhaonanzhe@xiaomi.com, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, 
	chenhuacai@kernel.org, kernel@xen0n.name, loongarch@lists.linux.dev, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org, 
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org, 
	hpa@zytor.com, Hongru Zhang <zhanghongru@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 707C21C0005
X-Stat-Signature: 17x9m7tnrdr61d1crzd5ursrdapucayb
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069876-84639
X-HE-Meta: U2FsdGVkX18b4Ijkm9PU/GlOHZdo4fV7ALjpvagIdRKTyPOXJa/WD85ExZOWzeNb6C1mTPMNhhFc/TxXyCZVdC1F5hnmhxtzSxZRwvHOHqbwYiBGnHt3dtxB18A3W1e8F3XOWJtjL3kNHqMxYOD6hPAgejGe3YBiatwmC07Ci1TbnhgsXWWVNws76n3XjM8nPsGixVhxk3jTjDUaYCy5P3EM4XnGKqzPRysFTFCq0+u94/OO4Vk/bsWPQ++SpU3v0HAW3JxlwQTzg8CKCejQvxD8wmV+3mRx/BnIOTBnwF4Xk6kpkirF/OhKC0/GhYFy00U+npnrKbn07OHC1wm7nAAOg6upcBe70ix+9MWBNrGhhQxh2fH/JtJvZUm+m0wxjs++GOPy6N+BrG/QQSM1/PsSjz9Ob30B9oze/Ol6mqY8KgNXbvKjfSXThlXIcLrkwX5N9OmT7LH5OtSAkETLlS8IfUBtSFl/rNtQ6nAHSWS2dieCdXq2gSFWQ5I49bNE61T+h+LQ/fIzDdtwDPDxaecDRu/hLSpmMcO92QNjLas8GZRzZMWRxgzjWEnPtDUMQWrGsPXSOjBcq8UiA03UZr3khePl1hm0MudFWYX3W2VYYlfwPeRnRCgqgUl2TDcMlned1InZwwB3G7355ZvTSCGAHzONxgP4TJImmi/sMfVzKinsIqQ64cSIV2tb/x+54xjakqAs09IfHg5afcYU4DGHZpf6D1V0BN7LBXC1GWixvAxUHJDipJVL/6M9eYrnPBg58Jrj8vshMIhzPSztO+kbX0dVe88x9F5IVs1YeqJTyI29KJqxKkbFkzzYWiF2gA8chDeuuLJKGYEmYtVTFUt+uvbMiJoSuHKNXx9gDGP0uTnEIwkIiIhKJrzjNvMd3G7wvDSdvNAR9jj2pHu0MrqCbn3XRNlJl6bKvdCoXw78nS1bvmORbJZZdf2pD7D5OYR5XzxPvEGEfIfHzTI
 a6R7M5kA
 iuP5wwzB4JnESj7UVQcklWeVbVyG1d/6P0nYtFryRZg4Cy0l3rj+STa555ZcE6Atw6GVHhfeYpy6JDYwMAM9GWNGYhe6Janet5H+17nxn5iOnrqmZJMwem+zEENatPLWYC1t7t6+xSErVHldIvy5g5HwvI9m4xjcDZx7JteOzF4lVLvRJRLdJ8qWnNtIgM9SUwxp6gC3i4nDNWnMqRi2uxFEuKTsDhOULAFycPZqWGQzIs2Zw2chTgANxnvgsx5PskBWWoBiM9XvaOQtm1QVBHSqB19OOvf0hbPWm7oAL+Oxvma0R3MCXdxYdV8nsZVInJkAqjpApfD+asXd7WyGastksFXj7jfxp77yqoCfTBEATC0UBrlhVHzRgoMGXofMBECjBOKYsVCvbZ9u3r1d92O94Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 7:39=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Oct 19, 2026 at 1:53=E2=80=AFPM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > On Fri, Oct 02, 2026 at 02:12:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Oct 01, 2026 at 10:12:16PM +0100, Matthew Wilcox wrote:
> > > > So what I didn't realise is that fork() waits for page faults to fi=
nish.
> > > > I don't think that's necessary, so we can just stop doing that (whi=
tespace
> > > > damaged):
> > > > I think this is safe.  I've booted a kernel with this change, and
> > >
> > > I'm afraid it's not safe :)
> > >
> > > We already actually did this (by mistake I think?) before. See commit
> > > fb49c455323f ("fork: lock VMAs of the parent process when forking") -=
 we shipped
> > > that in 6.4.0 -> 6.4.2 and it corrupted memory all over the place.
> > >
> > > Reports + a consistent reproducer:
> > >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D217624
> > > https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kern=
el.org/
> > > https://lore.kernel.org/all/b198d649-f4bf-b971-31d0-e8433ec2a34c@appl=
ied-asynchrony.com/
> >
> > I wonder if we still need this.  The commit message says:
> >
> >     A concurrent page fault on a page newly marked read-only by the pag=
e
> >     copy might trigger wp_page_copy() and a anon_vma_prepare(vma) on th=
e
> >     source vma, defeating the anon_vma_clone() that wasn't done because=
 the
> >     parent vma originally didn't have an anon_vma, but we now might end=
 up
> >     copying a pte entry for a page that has one.
> >
> > But we're holding the mmap_lock for write here, and we need to hold the
> > mmap_lock for read in order to change a vma->anon_vma (asserted in
> > __anon_vma_prepare() with mmap_assert_locked()).
> >
> > At the time of this commit, lock_vma_under_rcu() contained:
> >
> >         /* find_mergeable_anon_vma uses adjacent vmas which are not loc=
ked */
> >         if (!vma->anon_vma && !vma_is_tcp(vma))
> >                 goto inval;
> >
> > so we really did have to wait for read holders to finish the fault.
> > But commit a373baed5a9d deferred the check for a NULL anon VMA until we
> > actually needed it, so I think commit fb49c455323f's logic was invalida=
ted
> > by a373baed5a9d.
> >
> > Maybe I'm wrong.  This is all a bit out of my normal area.
> >
> > > Also we have asserts for this lock in copy_page_range() and
> > > copy_hugetlb_page_range() which will now fail (and possibly more furt=
her down
> > > the stack?)
> >
> > Possibly we have to adjust some assertions to check that either we have
> > the VMA locked or we have the MM write locked.  That doesn't seem
> > unreasonable.
> >
> > > > My argument for why it's safe is that a thread which takes a page
> > > > fault during fork() might have taken the page fault either before o=
r
> > > > after fork().  The faults will definitely happen in the parent proc=
ess.
> > > > They may or may not have happened in the child process, which can't
> > > > possibly care whether or not they've happened.
> > >
> > > The problem isn't the child it's the parent - copy_page_range() _modi=
fies_ the
> > > _parent_'s page tables in-place, on assumption that nothing else can =
access
> > > them (for CoW).
> >
> > I was perhaps unclear.  What I mean is that the child may or may not
> > observe them as having happened.
> >
> > > And actually nowadays things are _even_ worse, you could also have co=
ncurrent
> > > page faults, MADV_DONTNEED, MADV_FREE, MADV_GUARD_INSTALL/REMOVE, UFF=
DIO_COPY +
> > > UFFDIO_MOVE (yikes) all of which might introduce new issues + would h=
ave to be
> > > audited too.
> >
> > Yup.
> >
> > > So - it turns out a lot of stuff implicitly assumes VMA write lock no=
w:
> > >
> > > 1. CoW - deferred TLB flush race
> > >
> > > (The issue above)
> > >
> > > https://lore.kernel.org/all/20230705171213.2843068-2-surenb@google.co=
m/
> > >
> > > This happens because __copy_present_ptes() does wrprotect_ptes() on t=
he parent
> > > without a TLB flush (that's deferred until the end of the fork).
> > >
> > > But unfortunately without a VMA write lock something can then replace=
 the page
> > > table entry in the meantime and you can end up with data loss as a re=
sult.
> >
> > Is it that fb49c455323f commit message is insufficient and we need to
> > prevent simultaneous fork/page fault for other reasons, then?
>
> Yes, I think so. It refers to one of the reasons VMA lock is needed
> during fork, but as Lorenzo points out, there are a number of other
> reasons that require fork to protect VMAs. Note that some of those
> reasons, like MADV_GUARD_INSTALL and UFFDIO_MOVE did not exist at the
> time fb49c455323f was written.

I also have to agree with Lorenzo that allowing fork to run
concurrently with page faults might only shift the mmap_lock
contention from fork to some other operation (mmap/mprotect/etc.), so
even if we fix all these cases we might end up with contention
somewhere else.

>
> Below is the list that AI pointed out, and I think Lorenzo covered
> most if not all of them:
>
> Without vma_start_write_killable(mpnt):
>       1. In-flight VMA readers that locked mpnt before
> mmap_write_lock_killable(oldmm) continue running concurrently with
> dup_mmap().
>       2. New VMA readers (page faults via lock_vma_under_rcu(),
> madvise under MADVISE_VMA_READ_LOCK, userfaultfd via uffd_lock_vma() /
> uffd_move_lock(), vma_start_read_unlocked(), etc.) continue to succeed
> on mpnt while dup_mmap() duplicates its VMA metadata and page tables.
>
>   (Note: When this lock was originally added in fb49c455323f, one
> prominent trigger was a concurrent fault calling anon_vma_prepare() on
> a VMA with mpnt->anon_vma =3D=3D NULL while anon_vma_fork() /
> vma_needs_copy() ran. Although __vmf_anon_prepare() now requires
> mmap_read_trylock()
>   when !vma->anon_vma, removing vma_start_write_killable(mpnt) today
> still breaks several critical invariants.)
>   =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
>   ### What would happen if we removed it
>
>   1. **Destruction of live 2MB THP mappings ("bad pmd" -> pmd_clear())
> in copy_pmd_range()**
>   As noted in the comment in copy_pte_range(), copy_pmd_range()
> assumes no concurrent THP transitions on src_pmd:
>     if (pmd_is_huge(*src_pmd)) { ... }
>     if (pmd_none_or_clear_bad(src_pmd))
>         continue;
>   On an anonymous VMA that already has mpnt->anon_vma !=3D NULL, a
> concurrent per-VMA-locked THP fault (do_huge_pmd_anonymous_page()) or
> UFFDIO_MOVE can install a transparent huge PMD into *src_pmd right
> after pmd_is_huge(*src_pmd) observed pmd_none.
> pmd_none_or_clear_bad(src_pmd)
>   then sees pmd_bad(*src_pmd) =3D=3D true (a THP leaf PMD satisfies
> pmd_bad()), prints "bad pmd ...", and calls pmd_clear_bad(src_pmd) =E2=80=
=94
> wiping out the parent's live 2MB PMD without PTL, TLB flush, or
> rmap/refcount/deposited-pgtable/RSS cleanup (corrupting parent memory
> and
>   triggering Bad rss-counter / nr_ptes bugs on exit).
>       =E2=80=A2 The same race exists for huge PUDs in copy_pud_range()
> (pud_none_or_clear_bad(src_pud)).
>       =E2=80=A2 Similarly, copy_huge_pmd() reads special huge PMDs
> (VM_PFNMAP/VM_MIXEDMAP) locklessly and skips rechecking *src_pmd under
> src_ptl assuming it cannot change, so a concurrent MADV_DONTNEED under
> MADVISE_VMA_READ_LOCK could leave the child mapping a stale/zapped PFN
> PMD.
>   2. **Silent CoW data corruption / lost parent writes due to deferred
> flush_tlb_mm(oldmm)**
>   __copy_present_ptes(), copy_huge_pmd(), and
> copy_hugetlb_page_range() write-protect parent PTEs/PMDs without
> flushing TLBs; dup_mmap() defers the flush to flush_tlb_mm(oldmm)
> after all VMAs are copied. Normally, because each copied VMA remains
> VMA-write-locked until
>   mmap_write_unlock(oldmm), no parent thread can handle a CoW write
> fault before flush_tlb_mm(oldmm) finishes.
>   Without the VMA write lock, while CPU 0 is still in dup_mmap()
> copying later VMAs:
>       =E2=80=A2 CPU 1 (parent thread A) still holds a stale writable TLB =
entry
> to old_folio (now CoW-shared with the child).
>       =E2=80=A2 CPU 2 (parent thread B, no cached TLB entry) writes to th=
e
> same page, faults on the R/O PTE under per-VMA read lock, enters
> wp_page_copy(), and copies old_folio into new_folio
> (__wp_page_copy_user()) before taking PTL and calling
> ptep_clear_flush().
>       =E2=80=A2 Any store by CPU 1 through its stale writable TLB entry a=
fter
> __wp_page_copy_user() and before ptep_clear_flush() lands directly in
> old_folio while pte_same() still succeeds =E2=80=94 losing thread A's wri=
te in
> the parent (new_folio) and leaking it into the child (old_folio).
>   3. Broken guard-page (MADV_GUARD_INSTALL) state and KCSAN race on vm_fl=
ags
>   madvise(MADV_GUARD_INSTALL) runs under MADVISE_VMA_READ_LOCK and
> atomically sets VMA_MAYBE_GUARD_BIT on mpnt via vma_set_atomic_flag()
> before installing PTE_MARKER_GUARD entries:
>       =E2=80=A2 vm_area_dup(mpnt) asserts
> ASSERT_EXCLUSIVE_WRITER(orig->vm_flags), which would trip under KCSAN.
>       =E2=80=A2 If vm_area_dup(mpnt) copies mpnt->vm_flags just before
> MADV_GUARD_INSTALL sets VMA_MAYBE_GUARD_BIT and installs
> PTE_MARKER_GUARD PTEs:
>           =E2=80=A2 On a file-backed VMA without anon_vma, tmp misses
> VM_MAYBE_GUARD (part of VM_COPY_ON_FORK), so vma_needs_copy() returns
> false and drops the guard regions in the child.
>           =E2=80=A2 On a VMA with anon_vma !=3D NULL, copy_page_range() c=
opies
> the PTE_MARKER_GUARD entries into tmp, leaving the child VMA with
> guard PTE markers without VM_MAYBE_GUARD set (breaking collapse checks
> such as file_backed_vma_is_retractable() and future merges/forks).
>
>   4. Inconsistent address-space snapshots against UFFDIO_MOVE and
> tcp_zerocopy_receive()
>       =E2=80=A2 When UFFD_FEATURE_EVENT_FORK is not enabled, dup_userfaul=
tfd()
> never increments octx->mmap_changing. Because move_pages()
> (UFFDIO_MOVE) only takes per-VMA read locks (uffd_move_lock()), it
> could move an exclusive folio from a not-yet-copied src address/VMA
> into an
>       already-copied dst address/VMA (losing the page at both
> addresses in the child), or move a zero page from an already-copied
> src to a not-yet-copied dst (duplicating it at both). Even with
> UFFD_FEATURE_EVENT_FORK, octx->mmap_changing is only incremented once
> dup_mmap()
>       reaches the first VMA using octx, so earlier non-uffd VMAs rely
> on VMA write-locking to prevent cross-VMA moves.
>       =E2=80=A2 tcp_mmap() sets VM_MIXEDMAP (in VM_COPY_ON_FORK, without
> VM_DONTCOPY), so copy_page_range() would race with
> tcp_zerocopy_receive() zapping and inserting pages under
> vma_start_read_unlocked().
>   5. Immediate debug assertions (CONFIG_DEBUG_VM)
>   Both copy_page_range() and copy_hugetlb_page_range() call
> vma_assert_write_locked(src_vma) on every CoW VMA, which immediately
> fires VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma) because
> oldmm->mm_lock_seq was bumped by mmap_write_lock_killable(oldmm) while
> mpnt-
>   =EF=BF=BA>vm_lock_seq was never updated.
>
> >
> > > Same issue exists with hugetlb wp too. And god only knows with uffd w=
p :)
> > >
> > > 2. THP - can destroy parent THP mappings
> > >
> > > copy_pmd_range() does:
> > >
> > >       if (pmd_is_huge(*src_pmd)) { copy_huge_pmd(); ... }
> > >       if (pmd_none_or_clear_bad(src_pmd))
> > >               continue;
> > >
> > > Without the write lock, a concurrent fault can install a huge PMD via
> > > do_huge_pmd_anonymous_page() or filemap_map_pmd()/do_set_pmd().
> > >
> > > The issue is that pmd_bad() fires for leaf PMD (ugh) on at least x86 =
and arm64,
> > > meaning that'll clear the page table entry.
> > >
> > > I think Hugh left a comment alluding to this before:
> > >
> > >        * copy_pmd_range()'s prior pmd_none_or_clear_bad(src_pmd), and=
 the
> > >        * error handling here, assume that exclusive mmap_lock on dst =
and src
> > >        * protects anon from unexpected THP transitions; ...
> > >
> > > It's like the mess around pmd_trans_unstable() :(
> >
> > ... could we fix this by taking the ptlock during the copy operation?
> >
> > > 3. copy_pte_range() skips the required pmd_same() recheck assuming wr=
ite lock
> > >
> > > It uses pte_offset_map_rw_nolock() with a dummy pmdval and:
> > >
> > >        * We already hold the exclusive mmap_lock, the copy_pte_range(=
) and
> > >        * retract_page_tables() are using vma->anon_vma to be exclusiv=
e, so
> > >        * the PTE page is stable, and there is no need to get pmdval a=
nd do
> > >        * pmd_same() check.
> > >
> > > (Probably needs updating for VMA write lock...)
> > >
> > > 4. The asserts
> > >
> > > Mentioned above!
> > >
> > > I suspect there's more as well.
> > >
> > > Some of it could be changed, but it'd all be at the cost of behaving =
very
> > > strangely (no VMA lock but mmap write lock) while manipulating things=
.
> > >
> > > And I am not really happy with changing page table entries in the par=
ent VMA
> > > (for CoW) without a VMA write lock held.
> > >
> > > I also wonder whether it would achieve all that much really - the iss=
ue is with
> > > holding the VMA lock across I/O, anything else that tries to grab a w=
rite lock
> > > is going to end up being the new thing that's blocked (mprotect, munm=
ap, mremap,
> > > mlock etc.)
> > >
> > > I think doing something like this would need a very significant redes=
ign and I'm
> > > not convinced it's one that really achieves what we want given all th=
e other
> > > cases that'd get blocked by the VMA lock being held still.
> > >
> > > --
> > > Cheers, Lorenzo

