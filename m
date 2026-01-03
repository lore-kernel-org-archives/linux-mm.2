Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1554FC6171
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 05:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D2C6B0095; Sat,  3 Jan 2026 00:23:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FDE6B0096; Sat,  3 Jan 2026 00:23:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC526B0098; Sat,  3 Jan 2026 00:23:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4046B0095
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 00:23:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D41DCC0146
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 05:23:44 +0000 (UTC)
X-FDA: 84289510368.27.1777DA6
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id CE92A100006
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 05:23:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CLrN36QR;
	spf=pass (imf14.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767417822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZgtRUf8QSMBPWBbIO9SBlR1yZTUnPXvstMpo+N3AXk=;
	b=BIFuaP2Pa0t8ZveQPcQ8vMiCr2L7dPRfyVxSvJxphhUs5lKEujF7VamHtBaPmNBpHpvABN
	xHxoFvEEzA3PLUpMuU2jOo49ALKw/nC0Z/lS2lhzc1sWfWFfnV4i2iOxGLjRcJ3H8WRsNV
	MGmXJrJyH1tRIknJPSnAg7S0QAzCpkU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CLrN36QR;
	spf=pass (imf14.hostedemail.com: domain of jasonmiu@google.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=jasonmiu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767417823; a=rsa-sha256;
	cv=none;
	b=LL8irWKMwxz08ztreAlQGkD/8MdJNBngs/V35o7IXRwVHGIkou84rbZTczasQMSuJ8sMwg
	3PLtRX262pvlIBkBa4rs0I4NSFY+R2keyw4Z4o2qDMnxtmipRT3QUM3PcBMCS02rP6G7a/
	QCr/XWVkkanItgm7tctFYQvE87xZ7gg=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4308d81fdf6so5968092f8f.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 21:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767417821; x=1768022621; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZgtRUf8QSMBPWBbIO9SBlR1yZTUnPXvstMpo+N3AXk=;
        b=CLrN36QREBFlEEc0f4Jaw3Ha8C9oEmfE/RueEsQ/3TYCKidTcyN9Du3NUnJRBCMckG
         thIGz/uOB/QJsnp1v/lwKHQ9UZjHKNOeAQDUgOLJG4Q0aKrtbkcC1wrDX5epGBvjNDXg
         ipWdYlxRuQA55vY0SCt1weJHpkD5r2Xlin0Y74GN6XLLSLrVRllZwup7AEYfRyLjoxPQ
         bqMVNQatrrUbckn9wwmd5tBAKKEFu1zgvE6DPCIukne4p03UXXYgv2gy9Wox9GF1JEQn
         t950mhsi7RjwAh/GXYtnasp2jmHlGupa/2toMmV3M7pAzqdMIM63P4zBEJ9URNk35GBO
         MLIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767417821; x=1768022621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lZgtRUf8QSMBPWBbIO9SBlR1yZTUnPXvstMpo+N3AXk=;
        b=jlDTvh5FIFj4Ccch2osvl1KDE8vnJk8ijjDmz91DDWvDxOmGPgMUD+eG3OqksBP2WU
         4f8MIsBVXXydVlGnsX8YcALldkh1W4tQZ8RuhWObB/YDv0pKmUtS51JKy9pxicDCpQ86
         Rk9WgkBFzV8SiKTT6W6wQ7chu0sT/GZNsvZs3ApnF/8YnZQqyZk5KmB28Y7y7cGfqs+O
         IJW7cG3JGCJCoy3EOKKih8XYoDPb3XgIrhpZo5IpeitMvucs2u2y+VLRVLRV2wjU2FOn
         oXlGoCJM5lVKXQMaWxSE7PqRth/DL9+mm9RF3ggRiLoZg+AVudNbpi3vffmXmeAo13jB
         ooxg==
X-Forwarded-Encrypted: i=1; AJvYcCUjZWVS748rH2R/Zw07Hmo3zBuFT1yyFA46ndsruYOH+H+mIKmASg/EgUVrdqaA4RrC66jczP6ApQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4LhbbHsNd+u0ec8RBMEUMtsMwpc3KcsvH52NPuECIntFD4qBn
	yp6Kxw2DgtciM3xOu5KeKnnfM4ZZLUsKhoTNMPRQOghFzNqS18zrj8jtQSrXG6C7yYEvsmR9eXp
	3bwONB13agpPeHtMNaY6Pb8uFGhIHqiHxOBGfTi04
X-Gm-Gg: AY/fxX7+WAChRTPLMZshbfCIzRHuWzg4PvGeVzFNGWwbhfUvI/T+mYmCWg2RuO+A3hr
	qslLWoZzb2YYQ8D2nvH9gxSLgQ+mistRWcL4LEX/n3YieFoIDhlBXCni2049701Piida2bnjNV2
	4uphDlzRvVTsk6Grqjqpv4/ru0BVASyq6zcUEjEw1qWbl9c/g4EWR+Am9sTGtYjfQnytwd+iE6h
	N/Lrjwd3lof2dO2eVyu8piygnUMxziYbCwNx8TYn1aQ4y10tgaxVlM+HDlA5PDnzmq+69E1i7Qq
	/GRxwccJqu5CPHLXOm9e
X-Google-Smtp-Source: AGHT+IE4mQWmRBvH97nv4gWQOk5C2ZKjea27wZ9QrkyWmMJAiSuXXrY0G4eg4AtkqH+3miTS2o2rpDJDFiIBbXk/GGM=
X-Received: by 2002:a05:6000:2c0e:b0:42b:3afa:5e1d with SMTP id
 ffacd0b85a97d-4324e4c9d89mr61654880f8f.20.1767417820911; Fri, 02 Jan 2026
 21:23:40 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com>
 <aUF4fsWwD9BswkFh@kernel.org> <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
 <aUUYprAotKYMiEs0@kernel.org> <CA+CK2bD101cSC_7+OWkMei2QvUVjSaRLy+LboLe8Sz7KS3by4g@mail.gmail.com>
 <861pkpkffh.fsf@kernel.org> <CA+CK2bA1kYCf0BwhX3Sg9Ur82nK-7HPzs0sg6xbVWFAJaZLhpw@mail.gmail.com>
 <86jyyecyzh.fsf@kernel.org> <CA+CK2bDxnTEe9Ohq5zLuyF-jqgD0DPhfdq6z=yztUsXU5p5fSQ@mail.gmail.com>
 <863452cwns.fsf@kernel.org> <CA+CK2bCjJWZG_rPoPsHWSxirmUCTOuFQzTCss2AKf9UqpThrdw@mail.gmail.com>
 <864ip99f1a.fsf@kernel.org>
In-Reply-To: <864ip99f1a.fsf@kernel.org>
From: Jason Miu <jasonmiu@google.com>
Date: Fri, 2 Jan 2026 21:23:28 -0800
X-Gm-Features: AQt7F2pBVwG4Pai_GRfwCF2pWs-iKdBHBTiPITQe_l8Bzkpho3IogZSBp0YD7ds
Message-ID: <CAHN2nPKH5BGrYFZihTWY4+HYXtnko+EVdq5VpT5R4Sk_VnPt-w@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE92A100006
X-Stat-Signature: hjykgomprueq8f9qwx1byjw8uyodg367
X-Rspam-User: 
X-HE-Tag: 1767417822-613124
X-HE-Meta: U2FsdGVkX18M3QRHtPEtxESG9fmNUK71PiReB6zdPjuy0GMwYgxM0s7wUhUX1FYSRa8zdYu8mR5xMBosy0I6Z3yLLJkxh3JSXKYeLhwH92er11RP5IMbs6Hq+Eiluvyl9inYUMtFfqMbNrBjGxM3fcJ9Vwu6BThQ99nDdJV59UmwwD0c/V5R1zEJ9VsYAnYLWCJwazyvqLyReGq+8KRCcf9YoOZlHx6H/2X4wQ+cAla/WboQZuNNz2xwd61ybq7gOkXVwYjr+UfVFIoF7+mODTkKKN8CJk0vvHEoBawLi5XVdVCbJ+3HOqiR0+4nWuCnENuPPjKJxyuzTNMG+R+OMorc7yYsRwy7tWMVp8r6iAr5pxpMdl9GBtXEG0UW+kXCknB6j2hbRNwumEP01tyc7FhM72phI4VJ+83ncea+wxqahdVp4jUeFUkYQ0n8zAdSt8RCx3hqgmOr5FI5T1HVJsimupHmlQRX8qI3sditpV/k/m4tD0ad8hERcfIiFdP7KhkK+zN76mxOcJu+VAPA3TJcPlz99JsYjl8AtI9QZngK5oZVU8irUU5z2QLAiMDzvhCt5LOlnIRttejleL+ch306JazPqzkzBwwHpGtIojRb2Et4nbYW3qI5llqA8/zg9V2ynPJJt66gjcXch1xkcJsSNs/2Ii8yBnELNF24g6vu9+vqNh1fZ3l/A80f+lAjzXdcpdNKLatDhHAPM2OKo5HdYGMtBreIRope+obUMak5Et3veX8aYbUngoac4Gyc71sWcz7Ol9tm1wHF1/WCrdZJUjcXV5bwYJltnVjW+3rCvrjNO+mFnyvmBfYgKWQeYsUrMQ/ourmG0I5lIIgdKnRqxh8/he9wohGTZyyBF4NQeDL5lWg1sH/LmRZqtpYKL+QapnvvXTGSvKjIHwUQUOuwk4NIyMHPZsYCRVlLnjblqP9YIdGw8vi38/lNl4ZWbj8M6jobfwrsMNqR3us
 /bxlEa8q
 8c9RY198fpLRuQguUfY/xaBVEa2EPuyQ27bNZXCJVy2VGhsT8gjqHRWqAOh5//CVKXak1DHraGHRn4bWPY209dfi15neeYGKxhU/3nwKvx1N8ZZgYxBFL9QJQLOlZfnafC3xuMRRpHyG2doWC0H5mMdBmfb4p4p7hMqARhAJZev+ZbtfNpoExEwhI25nIPiGealNnuylXuQ4BDCBt4mmaKkm6g0Uacb7Rjc/K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 1:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Tue, Dec 23 2025, Pasha Tatashin wrote:
>
> >> > if (WARN_ON_ONCE(info.magic !=3D KHO_PAGE_MAGIC || info.order > MAX_=
PAGE_ORDER))
> >> > return NULL;
> >>
> >> See my patch that drops this restriction:
> >> https://lore.kernel.org/linux-mm/20251206230222.853493-2-pratyush@kern=
el.org/
> >>
> >> I think it was wrong to add it in the first place.
> >
> > Agree, the restriction can be removed. Indeed, it is wrong as it is
> > not enforced during preservation.
> >
> > However, I think we are going to be in a world of pain if we allow
> > preserving memory from different topologies within the same order. In
> > kho_preserve_pages(), we have to check if the first and last page are
> > from the same nid; if not, reduce the order by 1 and repeat until they
> > are. It is just wrong to intermix different memory into the same
> > order, so in addition to removing that restriction, I think we should
> > implement this enforcement.
>
> Sure, makes sense.
>

Yes I think this makes the life easier and simplifies NID retrieval,
as I mentioned below.

> >
> > Also, perhaps we should pass the NID in the Jason's radix tree
> > together with the order. We could have a single tree that encodes both
> > order and NID information in the top level, or we can have one tree
> > per NID. It does not really matter to me, but that should help us with
> > faster struct page initialization.
>
> Can we use NIDs in ABI? Do they stay stable across reboots? I never
> looked at how NIDs actually get assigned.
>

To encode the NID in to a single radix tree I think we can use the
prefix bits before the order bit. For a preserved order-0 page the
order bit is at 52 so we can use the bits 63-53 to encode the NID for
each order. But I tend to have one tree for NID, which makes the
process easier and more scalable. The cost will be 1 extra page
because of the array pointing to each radix tree.

When traversing the radix tree during early boot we must initialize
the head pages. We can have the page.private containing the order and
NID info, like:

```
union kho_page_info {
  unsigned long page_private;
  struct {
    u16_t nid;
    u16_t order;
    unsigned int magic;
  };
};
```

early_pfn_to_nid() should work here. If we ensure that pages in the
same order do not cross the zone boundary as Pasha mentioned above, we
can set the tail pages with the same NID later, when calling
kho_restore_page() after deferred struct page init.

With the `union kho_page_info`, this will be part of the ABI.

> Not sure if we should target it for the initial merge of the radix tree,
> but I think this is something we can try to figure out later down the
> line.
>

I suggest keeping the initial merge of the radix tree simpler,
ensuring it has the same feature set as the current implementation. We
can add the new deferred struct page support as a separate feature
later. =3D)

> >
> >> >> To get the nid, you would need to call early_pfn_to_nid(). This tak=
es a
> >> >> spinlock and searches through all memblock memory regions. I don't =
think
> >> >> it is too expensive, but it isn't free either. And all this would b=
e
> >> >> done serially. With the zone search, you at least have some room fo=
r
> >> >> concurrency.
> >> >>
> >> >> I think either approach only makes a difference when we have a larg=
e
> >> >> number of low-order preservations. If we have a handful of high-ord=
er
> >> >> preservations, I suppose the overhead of nid search would be neglig=
ible.
> >> >
> >> > We should be targeting a situation where the vast majority of the
> >> > preserved memory is HugeTLB, but I am still worried about lower orde=
r
> >> > preservation efficiency for IOMMU page tables, etc.
> >>
> >> Yep. Plus we might get VMMs stashing some of their state in a memfd to=
o.
> >
> > Yes, that is true, but hopefully those are tiny compared to everything =
else.
> >
> >> >> Long term, I think we should hook this into page_alloc_init_late() =
so
> >> >> that all the KHO pages also get initalized along with all the other
> >> >> pages. This will result in better integration of KHO with rest of M=
M
> >> >> init, and also have more consistent page restore performance.
> >> >
> >> > But we keep KHO as reserved memory, and hooking it up into
> >> > page_alloc_init_late() would make it very different, since that memo=
ry
> >> > is part of the buddy allocator memory...
> >>
> >> The idea I have is to have a separate call in page_alloc_init_late()
> >> that initalizes KHO pages. It would traverse the radix tree (probably =
in
> >> parallel by distributing the address space across multiple threads?) a=
nd
> >> initialize all the pages. Then kho_restore_page() would only have to
> >> double-check the magic and it can directly return the page.
> >
> > I kind of do not like relying on magic to decide whether to initialize
> > the struct page. I would prefer to avoid this magic marker altogether:
> > i.e. struct page is either initialized or not, not halfway
> > initialized, etc.
>
> The magic is purely sanity checking. It is not used to decide anything
> other than to make sure this is actually a KHO page. I don't intend to
> change that. My point is, if we make sure the KHO pages are properly
> initialized during MM init, then restoring can actually be a very cheap
> operation, where you only do the sanity checking. You can even put the
> magic check behind CONFIG_KEXEC_HANDOVER_DEBUG if you want, but I think
> it is useful enough to keep in production systems too.
>

I think we should traverse the radix tree once during the early
boot-up to reserve pages in memblock. But if we can hook the radix
tree walking in page_alloc_init_late(), we can further defer the page
structs (including head and tail) here. Having one radix tree per NID
seems handy here if page_alloc_init_late() allocates one thread per
NID for parallelization.

> >
> > Magic is not reliable. During machine reset in many firmware
> > implementations, and in every kexec reboot, memory is not zeroed. The
> > kernel usually allocates vmemmap using exactly the same pages, so
> > there is just too high a chance of getting magic values accidentally
> > inherited from the previous boot.
>
> I don't think that can happen. All the pages are zeroed when
> initialized, which will clear the magic. We should only be setting the
> magic on an initialized struct page.
>
> >
> >> Radix tree makes parallelism easier than the linked lists we have now.
> >
> > Agree, radix tree can absolutely help with parallelism.
> >
> >> >> Jason's radix tree patches will make that a bit easier to do I thin=
k.
> >> >> The zone search will scale better I reckon.
> >> >
> >> > It could, perhaps early in boot we should reserve the radix tree, an=
d
> >> > use it as a source of truth look-ups later in boot?
> >>
> >> Yep. I think the radix tree should mark its own pages as preserved too
> >> so they stick around later in boot.
> >
> > Unfortunately, this can only be done in the new kernel, not in the old
> > kernel; otherwise we can end up with a recursive dependency that may
> > never be satisfied.
>
> Right. It shouldn't be too hard to do in the new kernel though. We will
> walk the whole tree anyway.

Yes, we can preserve the pages used for radix tree nodes in the new
kernel. I think we should un-preserve them once LUO is done? Since KHO
can be used by other clients we can add APIs to preserve/unpreserve
the radix tree nodes.

--
Jason Miu

