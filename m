Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC63CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9667C6B0098; Thu, 15 Oct 2026 18:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DF26B0099; Thu, 15 Oct 2026 18:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804AE6B009B; Thu, 15 Oct 2026 18:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4923E6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:48:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DE32801F5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:48:41 +0000 (UTC)
X-FDA: 85326351642.14.BDA6143
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9972740005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:48:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmMI300v;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792104519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1V9CLpu10O1jPLEvgLakWRwageDrCx/acxcQ42UB1iQ=;
	b=if/bI9Cakn2kgwpfARKxI3WVlkAuUbtAvygcYvbaKuxrlIl1C+rzRKOrX10J6Hj4UHrSIz
	HCC/KIl4fUxteURrHfWJrjq7RxpBDdo2614+XqcSNM6nc3RQsR+uyh9NmMPH4SYB9fJb+W
	xpomVATu2tUQ5EH2IOsNKHC7LvyTAH4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hmMI300v;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792104519;
	b=dxUJ9kBRO158SgiIkJoFQ+lYVRlNMqr/jNcXSCuv6F2MzCgXCpARmmpcs7sZHPVqDJrFU7
	MSikC76PHAnIEufsNcCl6xAgEtFc6cFJmzZb8muy8FaDcEB+HU6vPY4m/h9fBlydtA1646
	naNIq3OoNbrC4v5maIQhDpIWLXPRk2E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C877944044
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2371F000CF
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792104518;
	bh=1V9CLpu10O1jPLEvgLakWRwageDrCx/acxcQ42UB1iQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hmMI300v0CSWEEGulFbyPPwZQ5gUAMCZF+mqGOjdl+L62Lj1t74wfSuept1fVqG0v
	 1b36Z0gw9b7VNlztUiioksU7+cIrBfMNSCj19qyZ5Vst+0lF3bvXxfrwr9e55vfJTJ
	 pXMXrNWhGxi8LPrXCAZwsFSd5XdH562s5kQnW7IBxpUr2FYNaCdLGZzlado+qmhrr5
	 Jwkklb6re1flkLKKBPUTX20GkDHzHzOwBVe+ZLk31K0RB5nCJigrhzqGTlP0xDOIUz
	 iGWJrsiKSjBqOCNL3F4GLGT7GCY8S9AoT+FsdzLgw4QrkQR/qDoYuOBGfir4oixOHf
	 eahrf2/taNYWg==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93a40a9a01aso63725985a.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:48:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwGOr2qsJZaxKtMCyaNwj3mEsNITl5byBwd3x/kwjRTieddiVrBtljpfzZZeJStiIRHj0xOD9vNuw==@kvack.org
X-Gm-Message-State: AFq9FYJD76utv12EhIPgPEiLKJcbYTHPeoxCHU1oHueh+XRArNomeMkV
	MxLavOIywPlYuzemkD3Fdf+TBQWSzI0wXK11aN7fmlHRO4SzpCDmGE3Ijmkgb71Xv3UbpQvEW0Z
	/lalzRiC/i2sd314sJWKkeaDzoiyK0gA=
X-Received: by 2002:a05:620a:1707:b0:93e:5508:24f8 with SMTP id
 af79cd13be357-93f17f65725mr271332285a.32.1792104518007; Thu, 15 Oct 2026
 15:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
 <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
 <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
 <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com> <CACpmpocCJWkA+zvZ9ivNCt8xSZWfViKQ2ZeYN+f1EmdVTewzRQ@mail.gmail.com>
In-Reply-To: <CACpmpocCJWkA+zvZ9ivNCt8xSZWfViKQ2ZeYN+f1EmdVTewzRQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:48:25 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOtedHfJ5A7JiXJYtWO-MjoGfE9PLPyyrQoHrr-R3FivA@mail.gmail.com>
X-Gm-Features: AclHuK-xrj8xMXtzgLT0L3fOnR7Oshgch5485U5XCqQHI3AqfSa_Wb3B6E8EGrI
Message-ID: <CAO9r8zOtedHfJ5A7JiXJYtWO-MjoGfE9PLPyyrQoHrr-R3FivA@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9972740005
X-Stat-Signature: gmb1gtbjjgbmtptdcjqtoryfpfs3ou8p
X-HE-Tag: 1792104519-600080
X-HE-Meta: U2FsdGVkX1/TvZwUf1RQCwaZvCgav48AJhcObzznc9tnhKwzjlpuGm5ZH6hrLI3SxOrvh0tDyOjMirfBYZ1matqvM7+x8E7lK2hODIvLWGFUpFvDJkHf60oZggtGl7T0jho7ldSmfdi7GcNd0iIqY1c4OO0TeAq9A2fjHIKkgdUfG2M1aMM685ejnwkjqkiXYuGbtz6CcQOoxLzKpMVY0JTBDX6zLBdfQLUju2qjb/vWLE9ZlfT7ujky2oZdvH066McWmBGb1P5a7Jxsz4l6CePtAQBe1xGGa22+K8PzYjN/jBt3qkLrjgxGr65dPBAmCsQ8xZZhtEIp/fAJLseHW6zy8Kl1ZhmKpKJtjtDOCBSGXpSD+Fn5AQJnxZlQZpMWDiNsnhI4Ntd/oONOyrNFu6LQmuvXHSStMYkkw7UEeH0MUWAzSwRIBy7TKtQVVUNLJ/E2k8MBLvchfvN2FO40VEMXYZvn6Qdnz0D5CAoBhK8M4xdF62X/7FEuZhJZsnqIZZ7ulMrYbLO2K6il+YkrmA70Jv7fZfVOm5L+/Ltf/GsufCWPVb28Quzmgego2dOfc5XRXXaYpdD0snraHba/XejQNcV1Ne59x194ac2Y9IlRvZU++m0y//uX7576LyRa835SHKKPAuGdROqSJXpRUTs1OHtstCX0sJlT3wFYvtBSnxQP0GVU6O8MrxS8MWLl2Tjcgvs3xdFmrbmHfoRQG7eC6NbLuHrJCvhjMItnrkroLaNG0EQJ0FA6tjg1WyATWdcxVkq/9vJmNTB9O38+H0Km1BAEeQZh4tZE0YhMCUYknMQvSSoT5gCAzh9LBbM8kRyI4NOErtiAN4X3g0Ev8V+OqGBEof0qKw8XHPlQjZGqgtY34paIqSv7B3Uw5qB1Ie03ReNYufuhP6+IObNlSGl+Pr3sLAlCQwPHreYcBkOZZVqg6/J6zKLYc5wK1+vi/yNlZu09XZi8JSXPw0G
 nD4YM14F
 6EEeEgSGmUkCns8qlis6jO5tys8vGxPMso5awHkWscYavplgvS9QA+dXMG4p7/wnRLAr+JQ7OZO9s9yc6dKGBJ7xfD9sDiQTXusGrO8rwhDVXlssT7ReQCl2Dfri9UIg/QHcj7Vlk5IA3qNRxC8qtpD0WVnfwcw2Od9cLZlv0ibvcljtchQNIZ/H0NONlqHSwVLi7JdFckbXTA1isLJTi914H8aWoAhWoFpv26oTnXgbQgEmWUrxIcSFO6u49skksLUlbTYYO/w9JMeSjdwMEN0G+0AzkRRUkZjKfSlCWm+TlsR0bNOnaofhNKXesPA/dMVgUv1lWPsx4BlmNRSnZtri4T3FiEQK2Q3lzuJx7ReQO7rP9TwsJsAUYoE4dW+K4KaRG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 3:45=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Thu, Oct 15, 2026 at 2:39=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > > > > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct fo=
lio *folio, long index,
> > > > > > >  {
> > > > > > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, i=
ndex);
> > > > > > >       struct zswap_entry *entry, *old;
> > > > > > > +     int nid =3D folio_nid(folio);
> > > > > > >
> > > > > > >       /* allocate entry */
> > > > > > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid=
(folio));
> > > > > > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > > > > >
> > > > > > We don't need to allocate the entry on the same node anymore, s=
hould we
> > > > > > drop this and let the slab allocator handle it as it sees fit?
> > > > >
> > > > > Was this a recent change? I see the folio_nid(folio) on my versio=
n of
> > > > > mm-unstable as of 10-3-2026. Let me check, and yes, allowing the =
slab
> > > > > allocated handle this is probably a good idea.
> > > >
> > > > We allocate the entry on the same node to avoid having to store nid=
 in
> > > > the zswap entry (see entry_to_nid()). If we store it, then there's =
no
> > > > need to allocate on the node.
> > >
> > > With patch 0006, we try to bulk allocate all entries for the batch.
> > > Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
> > > patch 0006 addresses this already, and the nid is used on in the
> > > fallback case.
> >
> > If we are storing the nid in the zswap entry, there is no need for
> > zswap_entry_cache_alloc() to use the nid anymore.
>
> As of now, zswap_entry_cache_alloc() uses the nid for
> kmem_cache_alloc_node(). Is the suggestion to change this to be
> kmem_cache_alloc()?

Yes. I don't think we need to use kmem_cache_alloc_node() if we store
nid in zswap_entry.

>
> >
> > >
> > > >
> > > > >
> > > > > Along the same lines, I have been working on replacing zsmalloc w=
ith
> > > > > direct SLAB allocations for the zswap compressed data storage and=
 see
> > > > > very promising results: memory savings and latency improvements. =
I
> > > > > will submit an RFC shortly.
> > > >
> > > > Keep in mind that zsmalloc is movable memory, while slab memory isn=
't.
> > > > Zsmalloc may also be less likely to make a new allocation in the st=
ore
> > > > path. There are other considerations beyond memory overhead and
> > > > latency here.
> > >
> > > I realize this means we trade off page migration for writeback for th=
e
> > > pages representing zswap compressed data. This might not necessarily
> > > be a bad thing for 2 main reasons, the way I see it in this specific
> > > context:
> > >
> > > 1) Page migration would only be transferring a memory pressure proble=
m
> > > elsewhere. Not sure how well this would work with memcgs or
> > > containers. At some point someone would need to do writeback.
> > > 2) I don't believe there is a zswap specific page migration flow in
> > > the kernel other than zsmalloc compaction. IOW, memory tiering
> > > components like CXL are handled directly in the reclaim path. From
> > > what I understand, things wouldn't break with slab memory for zswap
> > > compressed storage, but I could be wrong. I hope to include the
> > > architecture level considerations/trade-offs in the RFC.
> >
> > Zsmalloc memory is currently movable, so compaction can move it around
> > to free contiguous blocks (e.g. for THP allocations). Slab memory is
> > not movable. It can be reclaimable, but writing back memory from zswap
> > when we are not under memory pressure is also bad.
>
> All good points, thanks. I agree, writing back memory from zswap when
> not under memory pressure is bad, however I have not seen any
> writebacks in my experiments with usemem at 60% over-commit and with
> 64kB mTHP.

We can discuss further when you make your posting :)

>
> I am running these experiments in a memory constrained environment:
>
> QEMU VM: 7G RAM
> Swap: 3G
> cgroup memory.high: 3G
> 4 usemem processes want to allocate 1200M each. To make the experiment
> even more stringent and representative of actual compression datasets,
> each usemem process reads the Silesia dataset from a
> pre-fork-allocated buffer into the 1200M. This causes realistic
> compression payloads in usemem.
>
> >
> > Note that compressed memory can be very large compared to slab
> > allocations (or kernel allocations in general), so it can increase
> > unmovable (or reclaimable but not movable) memory significantly,
> > causing fragmentation.
>
> It took me a while to experiment with compressed size bins, until I
> settled on a compromise between memory wasted per slab and zswap
> latency in finding the correct size bin to minimize fragmentation. I
> have been gathering extensive SLUB stats which indicate:
>
> 1) Even under peak zswap compressed quota ("pool") utilization across
> 10 consecutive iterations, SLUB comes out ahead in less overall memory
> overhead.
>
> 2) At steady state (when 10 iterations of the workload are done), most
> of the slabs have been returned to the Buddy allocator, except for 3M
> worth of slab setup per compressed size bin (0 objects in use): this
> is as compared to 32K of zsmalloc slub metadata that remains at steady
> state.
>
> I learned some really interesting things from these experiments, which
> pose questions about the memory penalty due to latency that zsmalloc
> adds to zswap compress/decompress paths vs. "internal fragmentation".
> I expect to quantify this with data from my experimental setup.

