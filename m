Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E592FF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 22:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79DED6B0088; Mon, 27 Apr 2026 18:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EB86B008A; Mon, 27 Apr 2026 18:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D456B008C; Mon, 27 Apr 2026 18:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 573026B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:58:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD1A31B8456
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:58:55 +0000 (UTC)
X-FDA: 84705852630.20.BEC9AC6
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id C008C160008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:58:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KuCpItxn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of fmayle@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=fmayle@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777330733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFDjDkHXVh2Z+wp+XcjLdnVYy1AJI7gNEwLbuf8ELlk=;
	b=xAbpNFHJKCL44yqstWGuLJomK8mXQudIe8apGiqMH4rTgfGTvIfvBxEmbVFBQbbhsPhlX0
	w6v7y7zrTtZSeBNVmMDpgLnF9I1tAwrdwH71vnj6DC3GcpVK/bpSvhlH1H1Zh8VkVg5zwx
	A4MAufvFFhnNO0L+8S9E9sTtI2jhg8Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777330733; a=rsa-sha256;
	cv=pass;
	b=ixB463wADv+2cr7xJdegtCVlHbzE2u7l7lCnMSRM0o2rNHimZuZ7hkuPOgU6hdldWFRUL2
	H8I6NZeAlUNkWOLYJUspoN0MQ37VDMNVUDm3YJb2k0Nb3KX+ZerHgiZ2udLuOJRRTFhys6
	LMkGoE7LQzWR/s7IsyqzQ31D2M23h3g=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KuCpItxn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of fmayle@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=fmayle@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-126ea4e9697so5404c88.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:58:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777330732; cv=none;
        d=google.com; s=arc-20240605;
        b=bMsrvuuz/KqQEeqC02rNg2H6L2H87RbVxwZYXtBxtIa03axjcs/eQGAWnkyrTOtAkF
         tqmTnTlhJIcxDXQTLwNtRCxOjknSKW0DDqSmAZ6Y1rOxoLXEsHPz8NGbOBoMZya8dPar
         QTcQu920KFAer9DnfhNHp58RecGkPbZMEIf4mM5B7c6TwMmRzY0eR8FOr9NaxU2+mvcf
         4res9Iy+LghkYKqFfPZ8QNa9703St3aaHnboBwJInXfRep0wfpDW+/VDhX/K9ApRceMs
         wgYkkn4y12ahVl4TinDyWBJEZBIHgYj1RRhxRWHtjr7TLmY7Xm3m8nHpSDwLE7puQQ1F
         II4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mFDjDkHXVh2Z+wp+XcjLdnVYy1AJI7gNEwLbuf8ELlk=;
        fh=ZKAjo09bXPhqRamaqVs1qR0oJ9SlfYMAnF/y0C4XpB4=;
        b=Y3kQxj9I2ufh9gSS15DKJWitk8RLBS2whUY9mldPdRLC3yqM9Qw3U6KsHshMkp75Wd
         52DczPGsRbpgpEy55vbZJA4PViMLTAue52sbpm+RNvWiqx8DrRhwEufj4iFW/Z+L3gsy
         nFglrNgkBBWVoT7MpkMdxtCHljtHNOwGKgmR26gAC0fIIn4lvtR3uTpVdhkjWUS9zZjd
         HM8hZ9iaIpxeU7oMM2UDpXP7gDbuI5KkB51D/XHWK4i8E7VIHBBdNSPzO4oHt0qclTWg
         2CvLicpQCAJV3yD9+fhfodbrCEiR00JIbp9iefnC3XkksVhrdRknrbqwow+cGbvkvUjR
         6q5Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777330732; x=1777935532; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mFDjDkHXVh2Z+wp+XcjLdnVYy1AJI7gNEwLbuf8ELlk=;
        b=KuCpItxnxqQtzMhDgcRQttKR0ViwiapgDFpGIiBTxqatvhbwlz3pFmnZldbohqSp95
         glTyXHYWF8tTfxv7cchfuXfCAqDCzirf/kJGF6ldK7CweYTbClEUPeHjwqF5NgrvaJ56
         8PA+xOFAAkt/nH08zQars+sh5m0qSI2iYIBK/L4+kQOiWJFQkD8X+ddBvLq9uzqdn25i
         +CEgkBeNxv5obJhCOi0pRZPR0BS1EIew9I0NSdAFwSgZThwgyC6eA2Fulq13a0vUm70n
         PC/yJkxLhGy3hglwls/E0us0xOlDLcupQzNRnm8VKKwmt7m+wM7wnXDRGe4WF3qqabVU
         ObOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777330732; x=1777935532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mFDjDkHXVh2Z+wp+XcjLdnVYy1AJI7gNEwLbuf8ELlk=;
        b=NpSRfGFTXTipHeFz/VdnoRo7q5Jq8jnocqFeJ02Otu7pAYJvgYzizxjfGEyypn3KhU
         wP/N9+BpzZxQT2Ef55w025eurnljE7nmohaYo+AgjGsYJz0GhtpkeHa6oQ8IxeilCpvg
         Egf4VY5BCBs3MvRJElTUqJqILUaUzlRXu1viqBs7o42z+QyA+HbMELDRn20o8b1HT2Y+
         3eKyA0vKsq267lTVsBlEtW+cLH04u9+4dfZEWjqXLmifKD8eBH1eFToEF/6UMn+1rYpa
         09FfwMi/jO2I6z7dBYvJ/OP+gMbQW+r9UGR5B6X2DMO3wnGZcSMkECDaDz5JykMkjdG3
         px6Q==
X-Forwarded-Encrypted: i=1; AFNElJ8KZoLE5/RWEtkyW3Xs2yFhX6IflaNRWaAlb8CmIFegG2YPDbxBow7OUzJ6V7SABVd/70+TPHix9w==@kvack.org
X-Gm-Message-State: AOJu0Yx5OLasSkULenBv5MxFJQ64bYogsFwFRA0bJaNJ29l2g8MbgXGZ
	xqvWeVTOs6IytPoBlWdTpAlL9GVLBtwyYtSMY64F4PWcyIv0Ib3iw6IDiAhUQdKTXF8YY9m5e1k
	38Q+1KVX2KM8Kw0h6SInFAyb88BNC/akGMV58BqPu
X-Gm-Gg: AeBDieu0/Rl30cbs2IjRiXQEPa0c/6Trj78kDGW4nl6Np2pGd41VbsYusjRYE95sbU0
	NoKXGGkRbQ3/kOTRdgVxK6oiPtQGy2SaH/3BaoKZPe5lZ1rPeNg2EptBAg1S05SHSQGfSiRIHyp
	aaDEOvqZYXYKBJxf4s0zuJ9hWpkFA6AFHXPkHoM1iKGO/Px5bSA3VlWqPZl9XpPGVl3i1mgKrL2
	mIneQB7ovYaPbVu8gq9eBTWbcI00iUNTvrbpEW48BqdTG2NH42gph4rfZkfUWL2GTcUufs6jdgo
	Qst0FIsde/SGLvz8zGP8eA4wHiC8/tsHGiVJDKzl
X-Received: by 2002:a05:7022:e28:b0:11a:b4dc:7773 with SMTP id
 a92af1059eb24-12ddd6002b9mr109501c88.12.1777330731707; Mon, 27 Apr 2026
 15:58:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260427030148.653228-1-fmayle@google.com> <c7f94ce6-1dfb-420a-b073-d86abeff1f76@kernel.org>
 <CAC_TJvcM11got-LcMo24OTN8uXa01oVvUX6HmVvrWMJWVSgEzQ@mail.gmail.com>
In-Reply-To: <CAC_TJvcM11got-LcMo24OTN8uXa01oVvUX6HmVvrWMJWVSgEzQ@mail.gmail.com>
From: Frederick Mayle <fmayle@google.com>
Date: Mon, 27 Apr 2026 15:58:40 -0700
X-Gm-Features: AVHnY4IRZsDNSD2m-H5xb40HcijzEyG9TEJRAtLxMG16_OmGeOcdmUtyIgLLGcY
Message-ID: <CAHCxdc7JxwCNjsyyuPxuaVd7njgXyOEHvknCvjSKLvvU7nRAsg@mail.gmail.com>
Subject: Re: [PATCH v2] mm: limit filemap_fault readahead to VMA boundaries
To: Kalesh Singh <kaleshsingh@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, 
	kernel-team@android.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C008C160008
X-Rspamd-Server: rspam04
X-Stat-Signature: md6ea97sk1mxd4udwxion38d9rgj7u4m
X-HE-Tag: 1777330733-859153
X-HE-Meta: U2FsdGVkX1+Qa/jArvAtW538AEl/OWTQImn4eRIF0cWAGGAGXC5SxvH1Weph/4dJm4CoA4THSx3fGtm0q+gTLg3sNxu9n6aBfrZqyKiOJjrPBaTp8PcN4c77k0Yd/aAXEnvDbFhZzA1NdErqE6euIRLPW5C0g60vBlmh4ZGkeleV9nepA6WxJav9WQV44WSk2Wm8y2tUqxVqC5OKbGGU62d9HkFwOpru3ik1M2oxX/a9H5fFbeao+s99vYfWy0WjYdwDnf0nskMKheFVFM09CZIL5g5DiCkCeDV2L3sGTdR7NkluXLGfkUSouMSQZ21Eu2pX9OjWjHwkccsjeJMzMQZpE6ALawe1tXQzcMELrjVKnbiMKdlVE2KNz4Vj1VX9/IJ0bRju75TauCnn+2Egl8c6Bim978Nw766k/+0Ehvksn853G0EuZLcH9kR/lQVCEks2Ymlpc/qxtrcu+Rhan1fPVh3OnMD5Un/JT6/MSVd3Lcks/AwAtAljwoddj1jQ+xhyXZKhOQ5gFZUKoeh+mtFOY9a0NdEowdTHfNpE/W/5mEAwXGILFEmVXJSpTWLcID5hN1H+mNoBEF59//hHgMbihouCAKobU04VH4XMNOVb30x7Ybmj6NcJtRi05aAVuiVfsnhWLOMQdvYlJebbSNCjltBdzNb2KVpUNzAzdxLD5jISMc6ZCZAwL5BJZrt0p9ki+9bXQyrIUs7uxkBQJkohYrw8dnyXb/9TWUnbuW4RRIKohSMNVzcMLpXbkpzgD+q+Ph3L+63UPbLNE/JVlXQaSSGj5Vee/PV0q3z+3P+d85oXHb+YfhAzXqhAWBABNRq7uEP16etbUOUtcBKEwg3WLltbKvb0XZhUXLORfGJydKPJqRdp16dA7tHdPneaRB8Xz+yEfc1Dc5pX+3c1zYC1ngNvoVe3txgogk22ilfR8DjJ/sKJIhbbFdvxmTuHDiZ+5q3ISE5uKEBqGUF
 1hfFhJep
 758r521QeFO2oDja3PI3HwBTl+N3jL8P7VtqT+YSNGOJ0rpcPOdUBWw33tIjxHS3F32tE6VhbfJNdy8KnkowLxjkX6ikrouFq6bPf86WqpcTXxqehY4arrPa0AVLCVa5FgBDiGKPIeBIQTGmyUAmaQs+OgWYkycCSCxrQ+xEP9Pkf/pPoqEQfL8UaZT0fSWYikh4Kjv67OHifGWskZk6HxlDFXDN9Hdlw5A7cAxKAt94OxR0Tx2nlw3KTReFYk9hVB/dHR2Sy6YuMQhOqHnqB71nwhGfU1jFc2TMXEUaGWphwgFdqKJ5XG7IO7vlUdX/jPiRq5N61Zqf+RQ1k1GEs/vA2u7gi4pIpx6xQ2exxULXeZ9VJCKUouKxnjK+QSsGAis7XTtn4WGPKpjUro8RPRxETX8+DhuXVrsA+jzwaxijIcKBXR90MAFpAWeYwJvz7Ic5FwM4Gzfe/FCQVTy2TUPwICQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 9:23=E2=80=AFAM Kalesh Singh <kaleshsingh@google.co=
m> wrote:
>
> On Mon, Apr 27, 2026 at 5:41=E2=80=AFAM 'David Hildenbrand (Arm)' via
> android-mm <android-mm@google.com> wrote:
> >
> > On 4/27/26 05:01, Frederick Mayle wrote:
> > > When a file mapping covers a strict subset of a file, an access to th=
e
> > > mapping can trigger readahead of file pages outside the mapped region=
.
> > > Readahead is meant to prefetch pages likely to be accessed soon, but
> > > these pages aren't accessible via the same means, so it fair to say w=
e
> > > don't have a good indicator they'll be accessed soon. Take an ELF fil=
e
> > > for example: An access to the end of a program's read-only segment is=
n't
> > > a sign that nearby file contents will be accessed next (they are like=
ly
> > > to be mapped discontiguously, or not at all). The pressure from loadi=
ng
> > > these pages into the cache can evict more useful pages.
> > >
> > > To improve the behavior, make three changes:
> > >
> > > * Introduce a new readahead_control field, max_index, as a hard limit=
 on
> > >   the readahead. The existing file_ra_state->size can't be used as a
> > >   limit, it is more of a hint and can be increased by various
> > >   heuristics.
> > > * Set readahead_control->max_index to the end of the VMA in all of th=
e
> > >   readahead paths that can be triggered from a fault on a file mappin=
g
> > >   (both "sync" and "async" readahead).
> > > * Limit the read-around range start to the VMA's start.
> > >
> > > Note that these changes only affect readahead triggered in the contex=
t
> > > of a fault, they do not affect readahead triggered by read syscalls. =
If
> > > a user mixes the two types of accesses, the behavior is expected to b=
e
> > > the following: if a fault causes readahead and places a PG_readahead
> > > marker and then a read(2) syscall hits the PG_readahead marker, the
> > > resulting async readahead *will not* be limited to the VMA end.
> > > Conversely, if a read(2) syscall places a PG_readahead marker and the=
n a
> > > fault hits the marker, the async readahead *will* be limited to the V=
MA
> > > end.
> > >
> > > There is an edge case that the above motivation glosses over: A singl=
e
> > > file mapping might be backed by multiple VMAs. For example, a whole f=
ile
> > > could be mapped RW, then part of the mapping made RO using mprotect.
> > > This patch would hurt performance of a sequential faulted read of suc=
h a
> > > mapping, the degree depending on how fragmented the VMAs are. A usage
> > > pattern like that is likely rare and already suffering from sub-optim=
al
> > > performance because, e.g., the fragmented VMAs limit the fault-around=
,
> > > so each VMA boundary in a sequential faulted read would cause a minor
> > > fault. Still, this patch would make it worse. See a previous discussi=
on
> > > of this topic at [1].
> >
> > I agree that workloads that do a lot of mprotect() magic likely do not =
depend on
> > readahead optimizations.
> >
> > But I'm sure we'll learn quickly if that is not the case :)
>
> Hi David,
>
> There is already this limit for the exec VMAs, so perhaps these use
> cases are in fact rare enough; but we'll need to see ...
>
> https://lore.kernel.org/all/20250609092729.274960-6-ryan.roberts@arm.com/
>
> Frederick, could we also now remove that logic (EXEC mappings)? Maybe
> in a follow up patch.

The VM_EXEC branch is still meaningfully different from the read-around bra=
nch,
it sets `ra->order =3D exec_folio_order()` and `ra->async_size =3D 0`, but =
I think
most of the details could be unified. I can try that in a follow up.

