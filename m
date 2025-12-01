Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1FED116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 19:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E196B002D; Mon,  1 Dec 2025 14:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015A56B002F; Mon,  1 Dec 2025 14:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D0C6B0062; Mon,  1 Dec 2025 14:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D28136B002D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 14:33:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59CC412D14
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:33:34 +0000 (UTC)
X-FDA: 84171901548.03.3384430
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73A2E14000A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:33:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tFrI038g;
	spf=pass (imf09.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764617612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aF10akh46ESQJ+c7BaT1JvkVAunKKRxi6jS26KvxL2o=;
	b=6uw2ilMYphzDbRieuK6cjk5K70ao9Dk4Bd8Rw8EeALVLVoiO01PY5aVrwhQkYQcd+0DhbL
	biIMCoyugxTffMtM4pxw8bAZStdTlPctIcy4nuuricMi+sZMPUfrdrIa4gyVk4KTE1+trp
	4pHe19ZCWP/zhTC1Dh5/ykKnYOWSn2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764617612; a=rsa-sha256;
	cv=none;
	b=8ntMA/RNIuGDOu3dvavLXxeHrjVRDQVDL42gRlNMtRN7AjPrFbF+CsUGv9kMjGTjqvOuu8
	8wl2ylGt4DLNl4RC8/nYc/skEMSqiJiZsEQa0Ml9Pbkqc+cqJxqPIm4ieelVBaLYIHZPiT
	wzGIHudTUOPCRdwGLWj6avuxo/DTQdk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tFrI038g;
	spf=pass (imf09.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-297e13bf404so813665ad.0
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 11:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764617611; x=1765222411; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aF10akh46ESQJ+c7BaT1JvkVAunKKRxi6jS26KvxL2o=;
        b=tFrI038gbsFySz3O0sYwW/uFAHS2OGTMdd4vZ+N65eIjDH8ROb+iSlbNam6xl4DJfu
         qPLLJzAebkFC/Xkn2o/HGzLRvCa9SJxjaxof/iC6uxRqSm1LWhaLkgg5vz/qo0SVgHYa
         OgsHyAo7bqcyVhvyw4Lc/SV+8SlM4Nrf7vXIyWPjVL2tcXoP+09xFFQQJIkKkktVmpAt
         WOXrHh5gBzn5Eb/YrbTpYG5x7SK/JHN7cg8P1pGvrbrY12uiccsHS6VMfMr/MuRQA6WO
         wWnYMK76TvkZYbr3vP9jzZ2/JP3UxOU1WZpJ7aGtFbfrrgoozDVoWcn4TAXnF2X7u46P
         k28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764617611; x=1765222411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aF10akh46ESQJ+c7BaT1JvkVAunKKRxi6jS26KvxL2o=;
        b=pd8T5zWSq1Cfb2iDayTj6a5/SByfIWI6w4KlAjOnbQS4BXqZttCnE9obObJAdxav5y
         nWBxWsDxb6gZY1BjExhD/Jytm72HdI4tVvUBs0+N3vax1JpXw8/+6bvD3nfLATPX2M4u
         glBmU130jz8lsSPZQbfymXrLw+QMR9hbB23sa/8xuDtFlK1TqB84WqtxzciKtzkvzVxd
         mumu3ZOocFoLnN6V15505ZRObuJBzPVgqtFO0EO8Jk7ak+hIWvcPFEcpKGUl+ximFniG
         9Ncp9IR0lPmlEgTsvVyV7CGE8EFqzG0p+t8bCkGYlwU8CVjBeYvLn0GnbSSdAwwLZlQW
         z+dg==
X-Forwarded-Encrypted: i=1; AJvYcCU7v8lnLMrg35sS3PoM7YZD8UHxrWEPrvSxppRtvJhUTVHQF4y3L1/zSk8OXHZH7qYKN4tyuAFS3g==@kvack.org
X-Gm-Message-State: AOJu0YzuQKUxYguVaiVqqe8jIRdnYyCkneAIFDCOFBpNHi7NIA7Vc9UP
	V8RLyDswRjswkO7ORwX2/CjJ8wNTwBTjW7+T1QhXiOogzx5QykUoR5nY9vtULgun5SwBxLSBzEl
	aGBAkDVPOwXBXOZzu9pHOXExhW3HuFeDDEdWLNDWu
X-Gm-Gg: ASbGnctlCPK+3LWsy6I2jEIyr0Gm4X6VUcAf7pBzyKQM8v2K/DO7BDqGR+vnqeqWlHR
	C5HaG4EEuLRZQtAmKCIACMqc3m6pI+u2y+DjdAuOaPQ9bI3sf8byawnvsovWvwToUxG5q5Lau+Z
	Is2FnefQK9vfovCqxbWgeDP9BaIe8mWaitKGhNVV3leutLu/wi+EIcXLFiYpkrmvDEZCnyrjxNZ
	/xlXz3E2YgUwPFi2cdH6Zms9HFNilkLwqnjUNC3vH4tuEZGXgS86uCywTycaNrXcKGZiwkJPfDY
	jsBz8oHgf840bxDmuHcwbva4LA==
X-Google-Smtp-Source: AGHT+IFP/zhwci3vTqB9EDyMd0PIB3pGB3CtyKHh0svTCtOgB/uKqoCrsL9Qur1sceYt3JqL6MrYHvIDY5EEWYqMNpM=
X-Received: by 2002:a05:7022:f902:10b0:119:e55a:808c with SMTP id
 a92af1059eb24-11dc9c5d1f3mr327753c88.9.1764617610739; Mon, 01 Dec 2025
 11:33:30 -0800 (PST)
MIME-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com> <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com> <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
 <CAGtprH-ZhHO4C5gTqWgMNpf5MKvL0yz6QG2h01sz=0o=ZwOF0g@mail.gmail.com> <aS0ClozgeICZN/XX@yzhao56-desk.sh.intel.com>
In-Reply-To: <aS0ClozgeICZN/XX@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 1 Dec 2025 11:33:18 -0800
X-Gm-Features: AWmQ_bmRwRx__VVgKyn6dcD5fugj47Z9H8pbE9hwrVIaEriDYO1NkTox6hQ0kSQ
Message-ID: <CAGtprH8kVtyMiZeF+40hSpkY=O_HD0K+1Gy10rPdi8-mNLr8Yg@mail.gmail.com>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 73A2E14000A
X-Stat-Signature: stn8u8xxumdngttmf9ux9f963xedch8a
X-HE-Tag: 1764617612-278922
X-HE-Meta: U2FsdGVkX18VzNEUsZvLK97sPs1oVf4B7Uhc4DrNlY4nWkLZgAKH5f8y2DLmLqs89p6WWM9wn1MX0DYu+kiK59GLvbqgi8xwCvBt/uJ/2eyVty6GZ2IIyBQfbGA4q6yza+371HEJYJIUYeZ02c/0ZGDKFhFdcd1MccStB83CverIKQ+IdUdgDkSMb4eO8PNMVjXXD12T8RYWtPQBlL0ahNoIv6zwnKY98H96iBez2DzoM2Spm6E2YlRHybxegEso1gAarS0iAOZuZvVjxFLYUp5vwu4emZkfki9wYOBv18m+MGE1RDaDw9J6M/R6lSj1fjU2sj40eedcQySaGXuQrK7L7jI8m7jYAS6Q7QJocmQL5asBBoBwI/Igg1GBybLksLGNOeny6WCkSVMqSRikvXBx7QYB8iFrAkbCAZS8ofRor7itCztolRlAq8eaokcxrCWcdj9aKQczgCH31IVaWey3T4pL8PfMYqwPuRQ/Ua1QJFICb9kTVV7XpE9SlL/Lj6pRrTTRPkxus9JG3Yb0eB2QLHLC2qGSXnPZHst88Ja5Nf95iwpjcHgLudPFOvyj+NCJKhOnBuR5AL3IypiRBR+ombisKd43YE537UqMyS+k8fBLqWXpiMf2BVLUpocP1WI5yqyiVYeqLOmTRhPACa+aTUHLuFl5/XD42Fjb/xnd4NfmkklLcVOlYf7JgjFOq0NFpqAbq+SLcPNRgv94IVw/ARzWKWwo6wtUH1Lp0EYrqgP0OdkDoQbUtli2yu7S9IjKCf1EtZI5NFfAyEkrk2AahRHAlNT0Cdg0xWx69gZAp9SbPBy8fGf+FyraBUJBYEp45uQaJED1afrYm58fRpLHTw1eKqgkb1tGY6JI31P56eLIZURqtRi9kdredCIsa6KHcSU03nQCcJumq0IvbTXqvg+kP795evWhhYwu6j6Zf+8R1k4g2BO9hEDHXKD+no09vApIvJwITZ357gv
 uHwbiDwd
 XOjPgz/CEWDUbCqQ4f4kqqbKV4N6bugz90ot7TBlD0rAFcNWcV6VLZkP2Npli/ncw+1OVGp4hCjZtNzkzvY96+GDdOKtBRFfiRhfP2ARkk9quTXgu7CqctyAHy8RnI2/FRAISkOC1rkJVsgdoAoBaauB1YqOMCW4xW8xCqX9+IBl7xn5ibUNFuqrMOm2KnI1+eAzq3NePckK+GTCJY72gsM4U7Ai9qgLTn9WKaFtTyRlbhje1hisFrbGI4G2v6YKmosesbSLvd0sTj3IFbAhYlU+cPlMh06PQbmOw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 6:53=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Sun, Nov 30, 2025 at 05:35:41PM -0800, Vishal Annapurve wrote:
> > On Mon, Nov 24, 2025 at 7:15=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > > > > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn=
_t start_gfn, void __user *src, long
> > > > > >           p =3D src ? src + i * PAGE_SIZE : NULL;
> > > > > >           ret =3D post_populate(kvm, gfn, pfn, p, max_order, op=
aque);
> > > > > >           if (!ret)
> > > > > > -                 kvm_gmem_mark_prepared(folio);
> > > > > > +                 folio_mark_uptodate(folio);
> > > > > As also asked in [1], why is the entire folio marked as uptodate =
here? Why does
> > > > > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio=
 isn't marked
> > > > > uptodate?
> > > >
> > > > Quoting your example from[1] for more context:
> > > >
> > > > > I also have a question about this patch:
> > > > >
> > > > > Suppose there's a 2MB huge folio A, where
> > > > > A1 and A2 are 4KB pages belonging to folio A.
> > > > >
> > > > > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets fol=
io A.
> > > > >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> > > >
> > > > In SNP hugepage patchset you responded to, it would only mark A1 as
> > > You mean code in
> > > https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?
> > >
> > > > prepared/cleared. There was 4K-granularity tracking added to handle=
 this.
> > > I don't find the code that marks only A1 as "prepared/cleared".
> > > Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_po=
pulate()
> > > to mark the entire folio A as uptodate.
> > >
> > > However, according to your statement below that "uptodate flag only t=
racks
> > > whether a folio has been cleared", I don't follow why and where the e=
ntire folio
> > > A would be cleared if kvm_gmem_populate() only adds page A1.
> >
> > I think kvm_gmem_populate() is currently only used by SNP and TDX
> > logic, I don't see an issue with marking the complete folio as
> > uptodate even if its partially updated by kvm_gmem_populate() paths as
> > the private memory will eventually get initialized anyways.
> Still using the above example,
> If only page A1 is passed to sev_gmem_post_populate(), will SNP initializ=
e the
> entire folio A?
> - if yes, could you kindly point me to the code that does this? .
> - if sev_gmem_post_populate() only initializes page A1, after marking the
>   complete folio A as uptodate in kvm_gmem_populate(), later faulting in =
page A2
>   in kvm_gmem_get_pfn() will not clear page A2 by invoking clear_highpage=
(),
>   since the entire folio A is uptodate. I don't understand why this is OK=
.
>   Or what's the purpose of invoking clear_highpage() on other folios?

I think sev_gmem_post_populate() only initializes the ranges marked
for snp_launch_update(). Since the current code lacks a hugepage
provider, the kvm_gmem_populate() doesn't need to explicitly clear
anything for 4K backings during kvm_gmem_populate().

I see your point. Once a hugepage provider lands, kvm_gmem_populate()
can first invoke clear_highpage() or an equivalent API on a complete
huge folio before calling the architecture-specific post-populate hook
to keep the implementation consistent.

Subsequently, we need to figure out a way to avoid this clearing for
SNP/TDX/CCA private faults.

>
> Thanks
> Yan

