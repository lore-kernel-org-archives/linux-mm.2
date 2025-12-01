Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A51D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 01:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF476B0006; Sun, 30 Nov 2025 20:36:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFEC6B000A; Sun, 30 Nov 2025 20:36:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C57A6B000C; Sun, 30 Nov 2025 20:36:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69E9B6B0006
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:36:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0F7E1A0D7E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:35:58 +0000 (UTC)
X-FDA: 84169185996.05.0D24DBD
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC6F7A0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:35:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DINE0q4S;
	spf=pass (imf25.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764552956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqMTDdZDQx07C1ZaPMQnb45Si66LI4igGTkIU2isIPo=;
	b=l4Dg+RcK+K5JDwUDvp/lzVBKDWxDnm5Qr0IlDrik+Cey14jmZKqnPmdGmxJjP8tHztc/FJ
	pUXjneXtRFvi+0w0zdoEZww+B20tBVjszg/+3uM41tVFgLwF/8TcG6tZRkDQWbgdFwpswe
	tYrZFe8fsUb9jCrc2EyPcKMUd16Kw2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764552956; a=rsa-sha256;
	cv=none;
	b=Eho+mm1KakL3ogonpHINuWcPDBAHJGyh0Zg+KI3zjH91nVZF/a5qMzZLQ2SqqaKTRIS7Am
	nJqZrSNrN4kNMMPlToRFojzqQ3fMFtefVMvmI65Tk0nGY60l6grNG1aQsasqAtcyce33hl
	neoDzlOQDVt3dCDG5JsuWL0KvmMcjK4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DINE0q4S;
	spf=pass (imf25.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2980343d9d1so603255ad.1
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 17:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764552955; x=1765157755; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqMTDdZDQx07C1ZaPMQnb45Si66LI4igGTkIU2isIPo=;
        b=DINE0q4SzwrllBIfQyB2ODHCZ/fls1U0GKM5AHHuek+1Ct6KPSb0CXkNrLANh50YWE
         BRjbtb2si27tk5tOMC/tnvXThwzwRO99wEp4vUnPaflJk0c0DIox8ORmYz+siWIFIoBR
         zGO7aN5AxonoI0nIduVxIF2QtIRmzwxTckw+9Fj+t4MeUMO4Ku69OOzJQ45j8UOinAlx
         18odXQKcY1EDtf9IW4ulbrkO2/N7Pm7DSbi0EgmTuQDUImBd/29oR2IwwM+JBr8OD0py
         q8kcXvJ1zFLBw9dbK/WzlFHugPWHICUYd74NOUM8PDcKUvGpMqZ/o4nfO2CbQhpFuLO1
         I9AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764552955; x=1765157755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NqMTDdZDQx07C1ZaPMQnb45Si66LI4igGTkIU2isIPo=;
        b=Zfc6G/GVGJwjpYmvfWUMQcvbjVU5FRO+AIEBiVsCS2GjBJBLdixK5D9JqoScWelyEu
         FvUvIEQuZl1QztkX8tnZaMVXb5FaRMzCtRzKk1N6lRDo7DJ0SL0NLEwCBjaSGaCzYd/6
         yJXg/3oFB1Ld7YXutSc1eXwngrRJgo9e/qejCxHFO25BlPfeLsKN7DJuzMbwz18ei6IQ
         ZvSx7Fi6d2oGDNI9dQPIxSfbSYOFj7Oyn9o/8zTK2FG44DHzcHqvlavOOJOSCWQu1yYB
         AfjQL9VLy2cH4x5ZTCeO4EzWcSoEDo1oPoFQqWXe41mAlZtZXeN93PVHmVMp7IsfcZf9
         a1aQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjJfN4yt8cIirGbOFy0OSBCxIsBCc13fLxwsySQ1HYCUzUUusDMo100yZEeC+bgotHoMUw8YcJCg==@kvack.org
X-Gm-Message-State: AOJu0Yw7hg2W6/8YwK3vb3AnaN40uQg3DqlVAJAFbKA9e7ckjQ2FPqrT
	5HVa1c8sYWQfbkGb85i8v4jSj9e1WSu02e27QKbdDUTAtGnMmdg4vEutiysRRm4D9Qq0YtD/sxn
	hETOrVqANdbwuv94J0mwby8sGG1U0qzI7LUschnOs
X-Gm-Gg: ASbGnctXUdg96n2EhelBJnm5PvkBtBJ94Azih19QpXGi1A9IDmotLQrY3GBmeLGQb0d
	mCRKmBsKf04pLaun9eS3V1PqzJTDSEeaEYqxJJq6A6DywcdloMlqRTJXIrqiluscOiTDwvRdlZD
	C4JNz1nkoiS1WATyt4ugX7DBDajm8GaoGgmV2xB5r3mNo/HOzmf19Q2QLod2jiwZ6q+BXTyqCM3
	0BobowF6Jru5/6FupkmYWP0W/Vq3oCqWn9kFa1FhrVcO0AMjdBESZqk+3biYMZa3E7qYl9ex22O
	ehlJr0VqUxka9yFvxm9JR1AguFiD
X-Google-Smtp-Source: AGHT+IHEIEDZv76b8TRa1Qq061l1oB83PxjhPadbC3bezpK0erCqAD68jFap6vD+r6SRmAZ5XU1p/iYTpAphAiRdI4I=
X-Received: by 2002:a05:7022:e1d:b0:119:e56b:c1e1 with SMTP id
 a92af1059eb24-11dc93b618emr441412c88.12.1764552954586; Sun, 30 Nov 2025
 17:35:54 -0800 (PST)
MIME-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com> <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com> <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
In-Reply-To: <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sun, 30 Nov 2025 17:35:41 -0800
X-Gm-Features: AWmQ_bnH7rPpu--Cc2pGsK-pw880zjcxq8IZgsPMdV1b8UL-1xfVljIN1Z8nNyQ
Message-ID: <CAGtprH-ZhHO4C5gTqWgMNpf5MKvL0yz6QG2h01sz=0o=ZwOF0g@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ozz37cgbd1n7b4m4qctw7an75wdzg8xi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CC6F7A0010
X-HE-Tag: 1764552956-377062
X-HE-Meta: U2FsdGVkX18TyeNZVSGfTVOcsNT1m3A6cxAz3uyxQ757cNZbLSlJK3kQiLqDOg/7Cie+/nbqvzSlOuyTlzskb5o44WHSNpx/H80MCPnCOi7nQd1CNQJq8T0VbW7yQ8OtuintkjQQjCkVWW7XVm+otqZQaXmQRjY5frBfhi56tExDLx1yFRVraX5uk72ppB9tJ+zAzUYmKN6NT4Dtvei7T31+z5uWBQbWpAlwBoDcCi/RgYHdA59hanXCYoCDdrh7+NyOi/1qFuf2US5apV79qSqCAddvAjkVpZFilj7B32U3tpTU4UxENJfosQ+h6OHv7s4ZYvmYXlVaDirjlxJiqy3LPyqXT3p7fyrjBUADxjLzzXNKHYmIjxrZhyFpC88An9FW/v5vZK08iHpWkI2bHhATPYswyYVOImyL/ne34/yvptPjfr6fIGSoQ6xK9Uqe86/nlWgLV89zZaZzvYsi3H0byatRgZNPuTN/6YOy9bblimK4wFu6iYpbHxQ7iE1sAKqBrhmh9hvSeidtaZe0aWiWF7eLkl3TM2kMflcuvGUwdwhNKg2cCk77mvhVYxje4x8yvZrdW33J4C7Fg3U1xsJVYhY5k4uLWS1ptN2XJ8KoNA/+ys5gkFUPCYBYL/acmaz+hi8KJmmHLHH+goj/otZ+LqZXKeQwDEaA5BD9nMYf/UMWW2HGazi//P0sAffB/apQZx9CXbyMMY/A1HYcr/cZLHgDgpxtZgdqQggmJsGa3R7aIGt/SiYULc3H795GTgaoGNEnURLNtP6ncuGYbmAks/SM/TEZQIBD9uKpPESBROQhEGwizECwIpPjDDl3LFsqeMNHgrBVG38xOyNRdmKf+184qi0zvmD6yw79mTY2TmFyjWJHzxPda+z89S8sp3AD+PKLxowdSWKS2UfReJf4GB+MhD4LPtjjovt3KOlOyCWXpVYkXABVB39/NC5ZHJCb9dOUdzKCOzL938J
 U8s8PLPP
 bTlYeXlRIFd+bGLFYcXJvZm6F7czqTci/XIsQfNP+AfmqH6yt2obHUArrsQh/QH7oM9blysCz+TXw/x9TEPLGOTKhf6SwTrvH6IbVGTLE9LDW+ru3d1zeTCB2/Bdy3ehPJuCzTxM/jjYhE3ii9015ob5JkMNB9A49ExT8BoooViP+z7wgPlwgqV6rfb07j2rG7BaZCSdRb5RL2xONKin3q92xNbCBde8b2syJa5uR+2JbLSjF9BvVK/41yXNnN5QmDjpuDAJ9Ehky2TdiN6KVebg1pL6ORqPoaF16
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 7:15=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Fri, Nov 21, 2025 at 06:43:14AM -0600, Michael Roth wrote:
> > On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> > > On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > > > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct =
kvm_memory_slot *slot,
> > > >  {
> > > >   pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
> > > >   struct folio *folio;
> > > > - bool is_prepared =3D false;
> > > >   int r =3D 0;
> > > >
> > > >   CLASS(gmem_get_file, file)(slot);
> > > >   if (!file)
> > > >           return -EFAULT;
> > > >
> > > > - folio =3D __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared=
, max_order);
> > > > + folio =3D __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> > > >   if (IS_ERR(folio))
> > > >           return PTR_ERR(folio);
> > > >
> > > > - if (!is_prepared)
> > > > -         r =3D kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > > + if (!folio_test_uptodate(folio)) {
> > > > +         unsigned long i, nr_pages =3D folio_nr_pages(folio);
> > > > +
> > > > +         for (i =3D 0; i < nr_pages; i++)
> > > > +                 clear_highpage(folio_page(folio, i));
> > > > +         folio_mark_uptodate(folio);
> > > Here, the entire folio is cleared only when the folio is not marked u=
ptodate.
> > > Then, please check my questions at the bottom
> >
> > Yes, in this patch at least where I tried to mirror the current logic. =
I
> > would not be surprised if we need to rework things for inplace/hugepage
> > support though, but decoupling 'preparation' from the uptodate flag is
> > the main goal here.
> Could you elaborate a little why the decoupling is needed if it's not for
> hugepage?

IMO, decoupling is useful in general and we don't necessarily need to
wait till hugepage support lands to clean up this logic. Current
preparation logic has created some confusion regarding multiple
features for guest_memfd under discussion such as generic write, uffd
support, and direct map removal. It would be useful to simplify the
guest_memfd logic in this regard.

>
>
> > > > + }
> > > > +
> > > > + r =3D kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > >
> > > >   folio_unlock(folio);
> > > >
> > > > @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t s=
tart_gfn, void __user *src, long
> > > >           struct folio *folio;
> > > >           gfn_t gfn =3D start_gfn + i;
> > > >           pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
> > > > -         bool is_prepared =3D false;
> > > >           kvm_pfn_t pfn;
> > > >
> > > >           if (signal_pending(current)) {
> > > > @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t=
 start_gfn, void __user *src, long
> > > >                   break;
> > > >           }
> > > >
> > > > -         folio =3D __kvm_gmem_get_pfn(file, slot, index, &pfn, &is=
_prepared, &max_order);
> > > > +         folio =3D __kvm_gmem_get_pfn(file, slot, index, &pfn, &ma=
x_order);
> > > >           if (IS_ERR(folio)) {
> > > >                   ret =3D PTR_ERR(folio);
> > > >                   break;
> > > >           }
> > > >
> > > > -         if (is_prepared) {
> > > > -                 folio_unlock(folio);
> > > > -                 folio_put(folio);
> > > > -                 ret =3D -EEXIST;
> > > > -                 break;
> > > > -         }
> > > > -
> > > >           folio_unlock(folio);
> > > >           WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > > >                   (npages - i) < (1 << max_order));
> > > TDX could hit this warning easily when npages =3D=3D 1, max_order =3D=
=3D 9.
> >
> > Yes, this will need to change to handle that. I don't think I had to
> > change this for previous iterations of SNP hugepage support, but
> > there are definitely cases where a sub-2M range might get populated
> > even though it's backed by a 2M folio, so I'm not sure why I didn't
> > hit it there.
> >
> > But I'm taking Sean's cue on touching as little of the existing
> > hugepage logic as possible in this particular series so we can revisit
> > the remaining changes with some better context.
> Frankly, I don't understand why this patch 1 is required if we only want =
"moving
> GUP out of post_populate()" to work for 4KB folios.
>
> > >
> > > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t s=
tart_gfn, void __user *src, long
> > > >           p =3D src ? src + i * PAGE_SIZE : NULL;
> > > >           ret =3D post_populate(kvm, gfn, pfn, p, max_order, opaque=
);
> > > >           if (!ret)
> > > > -                 kvm_gmem_mark_prepared(folio);
> > > > +                 folio_mark_uptodate(folio);
> > > As also asked in [1], why is the entire folio marked as uptodate here=
? Why does
> > > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn=
't marked
> > > uptodate?
> >
> > Quoting your example from[1] for more context:
> >
> > > I also have a question about this patch:
> > >
> > > Suppose there's a 2MB huge folio A, where
> > > A1 and A2 are 4KB pages belonging to folio A.
> > >
> > > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A=
.
> > >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> >
> > In SNP hugepage patchset you responded to, it would only mark A1 as
> You mean code in
> https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?
>
> > prepared/cleared. There was 4K-granularity tracking added to handle thi=
s.
> I don't find the code that marks only A1 as "prepared/cleared".
> Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_popula=
te()
> to mark the entire folio A as uptodate.
>
> However, according to your statement below that "uptodate flag only track=
s
> whether a folio has been cleared", I don't follow why and where the entir=
e folio
> A would be cleared if kvm_gmem_populate() only adds page A1.

I think kvm_gmem_populate() is currently only used by SNP and TDX
logic, I don't see an issue with marking the complete folio as
uptodate even if its partially updated by kvm_gmem_populate() paths as
the private memory will eventually get initialized anyways.

>
> > There was an odd subtlety in that series though: it was defaulting to t=
he
> > folio_order() for the prep-tracking/post-populate, but it would then cl=
amp
> > it down based on the max order possible according whether that particul=
ar
> > order was a homogenous range of KVM_MEMORY_ATTRIBUTE_PRIVATE. Which is =
not
> > a great way to handle things, and I don't remember if I'd actually inte=
nded
> > to implement it that way or not... that's probably why I never tripped =
over
> > the WARN_ON() above, now that I think of it.
> >
> > But neither of these these apply to any current plans for hugepage supp=
ort
> > that I'm aware of, so probably not worth working through what that seri=
es
> > did and look at this from a fresh perspective.
> >
> > >
> > > (2) kvm_gmem_get_pfn() later faults in page A2.
> > >     As folio A is uptodate, clear_highpage() is not invoked on page A=
2.
> > >     kvm_gmem_prepare_folio() is invoked on the whole folio A.
> > >
> > > (2) could occur at least in TDX when only a part the 2MB page is adde=
d as guest
> > > initial memory.
> > >
> > > My questions:
> > > - Would (2) occur on SEV?
> > > - If it does, is the lack of clear_highpage() on A2 a problem ?
> > > - Is invoking gmem_prepare on page A1 a problem?
> >
> > Assuming this patch goes upstream in some form, we will now have the
> > following major differences versus previous code:
> >
> >   1) uptodate flag only tracks whether a folio has been cleared
> >   2) gmem always calls kvm_arch_gmem_prepare() via kvm_gmem_get_pfn() a=
nd
> >      the architecture can handle it's own tracking at whatever granular=
ity
> >      it likes.
> 2) looks good to me.
>
> > My hope is that 1) can similarly be done in such a way that gmem does n=
ot
> > need to track things at sub-hugepage granularity and necessitate the ne=
ed
> > for some new data structure/state/flag to track sub-page status.
> I actually don't understand what uptodate flag helps gmem to track.
> Why can't clear_highpage() be done inside arch specific code? TDX doesn't=
 need
> this clearing after all.

Target audience for guest_memfd includes non-confidential VMs as well.
Inline with shmem and other filesystems, guest_memfd should clear
pages on fault before handing them out to the users. There should be a
way to opt-out of this behavior for certain private faults like for
SNP/TDX and possibly for CCA as well.

>
> > My understanding based on prior discussion in guest_memfd calls was tha=
t
> > it would be okay to go ahead and clear the entire folio at initial allo=
cation
> > time, and basically never mess with it again. It was also my understand=
ing
> That's where I don't follow in this patch.
> I don't see where the entire folio A is cleared if it's only partially ma=
pped by
> kvm_gmem_populate(). kvm_gmem_get_pfn() won't clear folio A either due to
> kvm_gmem_populate() has set the uptodate flag.

Since kvm_gmem_populate() is specific to SNP and TDX VMs, I don't
think this behavior is concerning.

