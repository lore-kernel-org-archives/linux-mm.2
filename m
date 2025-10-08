Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A5ECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 06:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2A18E000A; Wed,  8 Oct 2025 02:03:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272ED8E0002; Wed,  8 Oct 2025 02:03:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188BF8E000A; Wed,  8 Oct 2025 02:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F36E58E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:03:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77CB31603F2
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:03:13 +0000 (UTC)
X-FDA: 83973904266.04.5BAF6C8
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9EBC520010
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:03:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=USDLcuIT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759903391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBzereJRTdGWw5Bv4VX5a6USN6lK2ZJ/saFJPUjeViY=;
	b=cetKEtiwQriqyVgYc3Tms56+5dhbDObxQKyLefwTEUF5dJKhh3+IH+tZZ+gYpULZ6UK5NJ
	zy8yvNNLCuWytFu1SeCBwcgN2ShUOlaMHpbO0dQgEN21/UJyjOVKa8MaxKHHa3QEsgDB24
	MzQiWvUcoC02wZaRvMz8yqGgs+wwiJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759903391; a=rsa-sha256;
	cv=none;
	b=GlcxKLQR38U4+GkNlComn46MwXTCyukYj7HE5Jj1P6suk/CMzeoAQaBaflY3PB5J2eG3Lp
	GehZ8VMb2PaXPYnRaCFlAMLrxzpuGUl4LcbNRg5//c4PMaikNWQQ/Hgj5iN16W/GQHA9lj
	qysrkD42coFuQuldxxA/GsvPGth0JKg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=USDLcuIT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-856701dc22aso728768385a.3
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 23:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759903391; x=1760508191; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBzereJRTdGWw5Bv4VX5a6USN6lK2ZJ/saFJPUjeViY=;
        b=USDLcuIT7xZSea76RXpzKyunEvD5krpMwLgIVtsgKXYJDakravg8jmpbD+8+fJ7IyQ
         6V7MmszKnPSqjZ7+xAw43cKnRkKX00UsurMp5QwKG5mp7MJ7ElNGAXTGajIHdl2u0F+Z
         k9NXrjrwpkMWuCyRlBUCVh+RrUVb0/i9pw3piYQtdI+wGeGhUDgqOoLKdc1BAP6NbMNw
         XhzIm//+cX6OAkcHzYUpur5lN5bttEJr/0keMDy2xbXp3ttFgt9dtf9x9uZ5oHzGjh/S
         WevxhDPhIKEc43iX+8GHb9fJ/SO9l5k76zZKFMD0ZtN+vYhyl/xbc+c4LvdiZF1rBJXH
         nvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759903391; x=1760508191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBzereJRTdGWw5Bv4VX5a6USN6lK2ZJ/saFJPUjeViY=;
        b=etANrictx7NWzqxczxXs6Va/IxxAf+CeuqO8u+u+fsjXo6ZIKgWH/y3SIRelp/PX9/
         mHlqr0Jb5DCYCLXxNoKgAMgjGvJCZKOmibg+2+pcIIEOOwzBOpGDMVc9A97PjXTdc4gh
         UJfph4jxe7522YNu679AYhMoWutlQphPo0UhP4e/QadfDVBfCYph8uGLt20PjSa68PR2
         K6J+sivkS6miPxBb3ivJvMKzOQVM/kUHgm+biIQIamqAZBxGlzc2x/mge5uIIBsS8pb4
         HxYsx3b0+/PbaKtZhmYPYW/4v/CKK1lz4tsqGhHE/WUl1QyP+nHsm2nraJQKPhe06mSZ
         WFrw==
X-Forwarded-Encrypted: i=1; AJvYcCXgcJB8vR5DgsGoHF+sOgCv4ieQX7Qlx6NJEBkIRUxwCOnkE3/tiojN0m2z/2zn0rChH39IwbFS1Q==@kvack.org
X-Gm-Message-State: AOJu0Yx0LZUyziWvsRJYyQ3UI9pi5yiXLzBc+eg+8IFm7zeSP1LkuOIw
	ro1sd3oppU+e7qECb6zLgfC49/5Rc0bUCgzWKinKnd9/REv8AQtBONrcAl2pzHEPFbB1lSubTZx
	0QK9LcqLAH3MkWEQl9+lGhlkXapJszM8=
X-Gm-Gg: ASbGncsT8uBuIfy/dwEe7RbDIdVWF9f/4tUlXj/xoQ8XCQKyFzzFjBs8wMhjhKPI+Ju
	FSrsURvRbcbyT5TOfyequeIAA1aI8dY3zQQ7A35ufM9MMVPb3qdrvAm1ge3iny9PQZZeT4nFk0H
	0mNXHkHKQ0acA2i4jYCnWbqTowBCKsOU1+UefR38D/ate4X8iDQJIbnAO6y3u3LhP48JznsCE29
	xSSZtFGQSxhRgmM3qoA8kemrfv9QvvcPIP2AyN0wHP1iKb1/OcwfZgB1LKh7RY23D+WV9i++I0=
X-Google-Smtp-Source: AGHT+IGN1fUle74mm+Dey9XN+9R2Hgx9711f1pzgYvQjJUJA/sik2SzgKknv0h0WalhCBF/jq/ow+URmBR5p54sJHtw=
X-Received: by 2002:a05:6214:2a8a:b0:785:c20b:f602 with SMTP id
 6a1803df08f44-87b2ef94a07mr29281856d6.61.1759903390435; Tue, 07 Oct 2025
 23:03:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <CALOAHbATDURsi265PGQ7022vC9QsKUxxyiDUL9wLKGgVpaxJUw@mail.gmail.com>
 <CAADnVQ+S590wKn0rdaDAHk=txQenXn6KyfhSZ3ks6vJA3nKrNg@mail.gmail.com>
 <CALOAHbBcU1m=2siwZn10MWYyNt15Y=3HwSGi7+t-YPWf0n=VRg@mail.gmail.com>
 <CAADnVQKzW0wuN3NfgCSqQKVqAVRdKVEYMyJg+SpH0ENKH6fnMA@mail.gmail.com>
 <CALOAHbBzS2RunZzEk8-rkU60M8jKEJ8FwiPgZqNeoXDy++L5hA@mail.gmail.com> <CAADnVQKLbc4iZDGWbbhqwr8hKhAZhyLjiZuuz_RBd2f9LH45rQ@mail.gmail.com>
In-Reply-To: <CAADnVQKLbc4iZDGWbbhqwr8hKhAZhyLjiZuuz_RBd2f9LH45rQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 Oct 2025 14:02:34 +0800
X-Gm-Features: AS18NWB7YAjB1_r1_mFRyGxWlvWmvmCic0bUl2k22vQ5MpJjGUViYxml_XAQVh4
Message-ID: <CALOAHbCOQ_S-b+8pMxwGsjoc9QnAdij=gjkPEm0--cR7iCRQ3w@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EBC520010
X-Rspamd-Server: rspam02
X-Stat-Signature: 96cy41cptqsbopjye1din51s93tzqb73
X-HE-Tag: 1759903391-205607
X-HE-Meta: U2FsdGVkX196SClejNd0nT2FCVU7efVQU1iyNiz3haBF8+ObqnUkk4eU8RZXW71vWgAkz2al61Gm4OInnkCUkuIgM/lH5sPdBKJhA7kDZtS9m3xXsCDKJ+v8fHRIKfyvjCuAA+q04L1uYR4msNZkaVjSipG2K3ZsmLgApHWKFq5leK+dm6KETr1J+bXpnr8AMnJY3dYtGPPuNvEuwKm0Aqow3KTZyh/6jTrJgF0iN6ku6G4TGx08KnUiFOV3vVeMiDU1IdFO1CabKuqoxkklopcN7Bw28I3vN6trwKxnSnUJouwL70mQXBo4vIA0lqtT8GqnGmBeSZgVhI+ZCQe/vbwe/i/iWgSnULkCVzajp77/R3i24uuSt1cysGQQndX8yfTaBC2e3Xv5iRdtm9j01mRttIF3HTAflhboq5R88wPIk/eUv/o1scsC+wHq/e2BjnyubHPjkX75XM8ik9wYZULQpANA+HtzYDuUE+NvpQnbHZzgcXSN1vIATvYb1MHwM92jo41kJelRlC3KJUIf3P+lv7jpWwB1XWkT5ao8CC5dFUSVj50YnRTCKE848pdEczQ3Z/D/53kyBOwwg7lCF4Cq1xAmztkNDim51+peiuVvH5w5Dg+E0lvnZFJkkjtpHjH9vCMKM+p6TBg6I7813dHlc7Od3t8zi2RBn2IeO6Ph8ncqXa3+1j3rB2BnzfUG/5GsHaMGm5hGmTDe6UOiJCbGuj0C8m9sCJWwuT2Cvc5+2LkH6lM0L1OljWRriih9OkhPKg3oNrESXLs0/xZZuzsGDzQF+aATKe65VbZbdi65iE9i5wMQRHXEbd//ltxHs+RyNTxkjVwliIKqgI6GfsBWFBgzaWJ4taxin/HznyVwGf3a0wd+Ucj+1mI1VUmLrclsW2+Bk6mViMbXtlxpVCWyU5DJAKyJykxU2VX0Ye/ztR9Yycd8VEfxShidK+YoLN+rQIDWFIF7AGtfIWx
 v4LffiPe
 Iha29eG9aL9toIYe8ztSgKidqfUPRSQENKXc4XfW9nBarvHilEhMetvBjFHqytzBgQ+vtFjSpCyi/bFincgZGZZQE65iNOSwPkArnFNJaQ8FWSribHyLuXJECj8U6iOxy5PLxO7Iksq2Akt8fV+IhsTbL0C1ToZ2ONRaD0x8pu6lLz0onD1ilyOe7uHB3N6Qc0dnqhHWUBtl6+l7n7yDB5ZLXb9hOCKha2P8Cmr0Bp3DkWvo8uGpylXY6AhKFuXs5Ccdz7cAEGuMrID9oo0d6WXk8vyciwfDMWjj0yDp5WIn5LCvrRWCaTPigMbNxKQS2ig5ew1RmfIa8Vc82WCxctU6Nc1UcLDTDQXaGHB8i6f9J3HTHfnPzJowgOLRj036Tlvheck9VL/TU9zb3LgBc5ntsyf10cIeQ9CNbsYIB2FekyvPGZKv8lwWtbHF2v0QYJt4a9ikS+UmjXygOkGLXr69TjrmDcJMjy2U6DYUmh//F7oKM00dnziuW2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 12:39=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 7, 2025 at 9:25=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Wed, Oct 8, 2025 at 12:10=E2=80=AFPM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Oct 7, 2025 at 8:51=E2=80=AFPM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > >
> > > > On Wed, Oct 8, 2025 at 11:25=E2=80=AFAM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Tue, Oct 7, 2025 at 1:47=E2=80=AFAM Yafang Shao <laoar.shao@gm=
ail.com> wrote:
> > > > > > has shown that multiple attachments often introduce conflicts. =
This is
> > > > > > precisely why system administrators prefer to manage BPF progra=
ms with
> > > > > > a single manager=E2=80=94to avoid undefined behaviors from comp=
eting programs.
> > > > >
> > > > > I don't believe this a single bit.
> > > >
> > > > You should spend some time seeing how users are actually applying B=
PF
> > > > in practice. Some information for you :
> > > >
> > > > https://github.com/bpfman/bpfman
> > > > https://github.com/DataDog/ebpf-manager
> > > > https://github.com/ccfos/huatuo
> > >
> > > By seeing the above you learned the wrong lesson.
> > > These orchestrators and many others were created because
> > > we made mistakes in the kernel by not scoping the progs enough.
> > > XDP is a prime example. It allows one program per netdev.
> > > This was a massive mistake which we're still trying to fix.
> >
> > Since we don't use XDP in production, I can't comment on it. However,
> > for our multi-attachable cgroup BPF programs, a key issue arises: if a
> > program has permission to attach to one cgroup, it can attach to any
> > cgroup. While scoping enables attachment to individual cgroups, it
> > does not enforce isolation. This means we must still check for
> > conflicts between programs, which begs the question: what is the
> > functional purpose of this scoping mechanism?
>
> cgroup mprog was added to remove the need for an orchestrator.

However, this approach would still require a userspace manager to
coordinate the mprog attachments and prevent conflicts between
different programs, no ?

>
> > My position is that the only valid scope for bpf-thp is at the level
> > of specific THP modes like madvise and always. This patch correctly
> > implements that precise design.
>
> I'm done with this thread.
>
> Nacked-by: Alexei Starovoitov <ast@kernel.org>

Given its experimental status, I believe any scoping mechanism would
be premature and over-engineered. Even integrating it into the
mm_struct introduces unnecessary complexity at this stage.

--=20
Regards
Yafang

