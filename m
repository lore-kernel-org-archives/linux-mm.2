Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF471C5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 17:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8036B008C; Wed, 19 Aug 2026 13:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569216B0092; Wed, 19 Aug 2026 13:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432826B0095; Wed, 19 Aug 2026 13:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 124DC6B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 13:24:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B5881404EF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:24:43 +0000 (UTC)
X-FDA: 85118693646.30.C54180F
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8EF3BA0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:24:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dkrB4H+c;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787160281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/s3DFDu7mQUXNF0KqwtrJ+MXPopmdruNjqo6IWXh1qo=;
	b=6g5sNbS1wqVvoGEszT4kA9cN7qtvBK1ePVpMSG1nOPjdOu0vQnI2xkcy86tlb0sIMY2FCF
	grTam4yDdgGYZuATSXGXMEk6FP1XTaOXQKxPHE2sPYblz0ECi76Kt3AEVowbIbQxLBbm+r
	DFUIdLDJaIFpZogsIEEgQ2zx7cPT5aU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dkrB4H+c;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787160281;
	b=ZgbY9C4aedCDjpYNzdQhFnzwEZdkbTfCTvgjP+nfSY1WArtZ6yQNQfVh5pwvIpa/u81DTf
	yAOtbR7weofxdcCIjdn5TiGNR+TRLgQlPlcJnPici0rYEmOZdZy8QAm/wU1ta/XkOGpTQp
	/k3XuCDaLnxegDb1RZQETch4Tlf/r+E=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cf452def93so864895ad.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787160280; cv=none;
        d=google.com; s=arc-20260327;
        b=kS720/1PFDG4G/oC7eUPYNKxNdlxAPbCCM0IJDCwx7t0tr5HsQr/YtnrmqeYexbmOJ
         YU2YGKOEc0FqBkRYSTIWc38Ibef6hq0kGBC1SAoNa6twGRl/SbZeS15ZyUURZYMnB4Q6
         h+ELbqoAGdGiJQsOIz8asV1HpDkRr3MU7vtXm77HOo+MdabbO+qb5LyK4abZXAjKsjub
         idHCGUIirgIHLjtBC9mzy4dlohnwydp6jHZ3Af4rMwhT8TPAIzrni+Y6cgVMQ8Hkf5qZ
         HxohV51fL/85s+fKlIsGMpF6RcQOfYUe0Z4cR0bkACN+4nisY7CdmybG5QdVEn4z+SBm
         SzvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/s3DFDu7mQUXNF0KqwtrJ+MXPopmdruNjqo6IWXh1qo=;
        fh=8eNPzBTeVm18bZ10JvlGKcgCI/L2D5L38uaoRtN/y7A=;
        b=rT8QxPt7mtjOyN51BLZqzA9yJxk4prdoWgObbIaJe+kMrERCZpYpiryu1mbCxEnUu3
         x6El1NYndxcFlsA6IwY3Bq9WE7xz83GJKfZEEymCbBnRaSwbwik+lSdE/Onay39zNEOw
         u5a5iUurrgRkfnvkocPKvmAPMURQzS77eYmjImC8evoo0kdJngrgh2jmn9D9rr3ZQSva
         +QSFsgYaK/YRdgSvAbKpqeF7m4w/bu8IOnplo6okYM9ufE6qz8NBzvUngEDAmLsKWjOZ
         VnhNXuf/YNM+2T1ULcBic2fGh5SLtNTJMtOPUV19w1nIkwigOVp5Kfie2FyBCBWXa5Fw
         OTig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787160280; x=1787765080; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/s3DFDu7mQUXNF0KqwtrJ+MXPopmdruNjqo6IWXh1qo=;
        b=dkrB4H+csHgnghhVDYf75JdB5kCC88ert3jAjLeXm+Dsv7FARdNtbu5U7GirZwbloo
         Xk526qRwiPPPZ2uzfe/EtmruZVlkNqA8e7fU3D0sJuw3cq5Ckz9BpUEPY/wJVnH8dnoY
         ql49SU6l7MWOqIAN1gGUU1TCibnIeMhSACvHEZqZe/V0/EmsHYiKQC/aX46dk4LBkZYp
         ILrNXsLaUhGQjrBFbMUABm2ES3ara/ixDB4eQR65+rGBPIWz8JrbZY9+qBKXHV3EJ/S4
         2+zeacP7Zia3EcjpDwU9bu711hs7nsOk0baYDr4MtIJwJX6HO1H3FK15foL7ubGbK4WQ
         JWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787160280; x=1787765080;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/s3DFDu7mQUXNF0KqwtrJ+MXPopmdruNjqo6IWXh1qo=;
        b=sO6+OGOBSueKuyMhHG9nfMEEUdw1hURR7pa0M2tXM5y6+Qtxk5jlDSj9kHGReeDYzP
         mjGh5fzynwtzkNY+sDW6HBCaJl2fIVdPzrJwA3XepnKi517sTIm5Z2ZfDIpYnCNDiFWD
         r8wuryYcFHcS5bFqqCNgC/UqyW6AX+HGuOUACFtNqkTq57SzNLMOjhKFnJGj73+T1onI
         6u+pNtQKHE8gD+cZ/O4imE7TdDImYmJtLBXHXLKy2TfFiSeLye9tfcfk2GrkJJwhTcH8
         MR4hyyQfih4BIfKyDZ1NaAULYqcLqyHvig5gLbDczLCCTTCiXebr30zHzVXzCReMQ7Qb
         2kaA==
X-Forwarded-Encrypted: i=1; AHgh+RpjKnbWKi3NHqV9LpNsBUPAgQnEEeHivddiD9ltwIrLQp8V0U+qZxKqVcCuyT+JLoJ/QkKHhEBBGQ==@kvack.org
X-Gm-Message-State: AFuF++msCiwaaobAWbk7pHpMxA5bYYnHBPQAGZYeLWAFI4cRahf8/nXX
	yjqGSx97DS68P9XyUs0hTYWcOEZvP/tyWandQILsAL5ZRYE86ktXZJKgDbbCUiJo2fFVPkbc6cB
	zqk3UIiDWKVbbJuvDkIbo5sBRGgAtNUg=
X-Gm-Gg: AR+sD13QhLrn8Peq/bfOY1HdWgA03LvpMHJTsUBgEGM7zicfW32tKGvJf2MzQH3u5Xc
	MvqlBbvtpvHsWHWP4LzrybY1+xcHAuVLB+z1Hn3a2KltEy567iONw+Xcv7YthX8XeaeazsOikEW
	5c3oiDTIVlpB/5ZrbC2FTiPt5eAQt9vo5woOVi1aCyZK9VPTc8CUDin5DgCYOfcl5Mbl5tSyODV
	gHzR6LcdVRaQCxtJ9uK+DGdjzonoNqHHKyICFdL/N8HV1wBGt815Y2BEava/jufRAbQWkZQZBQt
	qOFEQZ4T8ykVtraIHObvqdEBnU0EeSP0o2Y7DAB1wceHECZ2SppfiA5ZAlotpy6oPSBVKZe3eGj
	+7qhwMXoWdOiulO9W/CWJbSzUvw==
X-Received: by 2002:a17:90b:5104:b0:38e:c232:9d2c with SMTP id
 98e67ed59e1d1-395a04e3ff5mr731754a91.2.1787160280176; Wed, 19 Aug 2026
 10:24:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260815091819.3651099-1-gaoxiang17@xiaomi.com>
 <04f3ce2f-67f5-4829-9551-a69b9df29854@kernel.org> <CAEf4BzbwZkoacX-iP1j4+p8YNbWsq0pc3eTermh2uT5ir66zbw@mail.gmail.com>
 <8d2e20842c24460296e4c83e6dc0dde3@xiaomi.com>
In-Reply-To: <8d2e20842c24460296e4c83e6dc0dde3@xiaomi.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Wed, 19 Aug 2026 10:24:28 -0700
X-Gm-Features: AcwNN1V5XFvKw71PEM0biAs1oBlMlI9-0UtGl8hho5Gay8JpXC3-FqvpvbkLZuc
Message-ID: <CAEf4BzYQvhSVN=Hggg5FHzFdkRr4UNBD6yXaBsOaAwbsRpXpsw@mail.gmail.com>
Subject: Re: [External Mail]Re: [RFC] bpf: account ring buffer backing pages
 separately from Lost RAM
To: =?UTF-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Xiang Gao <gxxa03070307@gmail.com>, 
	Andrii Nakryiko <andrii@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrew Morton <akpm@linux-foundation.org>, 
	=?UTF-8?B?5Y2w6Zev?= <yinchuang1@xiaomi.com>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8EF3BA0008
X-Stat-Signature: 1ua98c69dhg9i66psu4xdiaqfdnqzsmc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787160281-361611
X-HE-Meta: U2FsdGVkX18wyCGDr+fELceUYfJcBHQyKVzEs3smuo+lngDlD6nx9sZqvrM9MRjmYRkiFVCmXRAaOU1YHb0ZW5bKGlWM9LvKWwOcvWe1lrPnKKR3oN1Dk4/JOZnl3gzRhGlKl/zsH+fxPslUMIfp7prR7YywOYJghNI5jugiboFUeaNNsXT8OrVpX8XKjarS1hVMqZIVevaClTdVeIVs5VOtwRMfFRUPW4WM4ZU5s0uYuoyb9pCpUBnhycLfRA8iaswWEdeU1vZcqM9MFAKC4DWmLMq5x5y+zDTBmvzZD/2xo47m7YLfYV1iCKJRfPxqjj/mlj0ato004wHLLJjqFYhALo58Rf48Setgpb6YwX9Bk3yXDQiFK/HXMX71BVUPjXSbsjqox2SVb5xVlM+oyPr7pmfBfQObJWHEbm9j4vzV77O3IgLpPYO0gs9xTgtGmjmlVF/a6JdZ1ydaktV6lxG1GZXIDuwI9+UX2pUNFcez4nQjgSD091FMAyJCE1Wi0OI+IS3wXGNHYsaeZN/cxuqRcs/jSzqJ9ph6I9tn5qXl0gnIguOdXzfawIX/JXWe0iUWozsJpawpCIiM3vjhFOmb8+WwM/y4YO31k5kojv6yp+rJSIXGqDSqmeI5bTR67BcdSGH0tmS794eotfG4AomC3us1NzezsyoW22u+Jnfs4sx5KVZPTekMuI+9V145Kj7+2tz5Q3LwqHwVESvdzwMuMA8aB19MINwFD0A6+D75SMeR4t/9WqSaxAIG4SMO6DHkPjx/T8+JDc1wvfoxd6qRxGTqCCd91fV7SShBKs21iTfLL8tBs+lblA5vNiSuw7Y4fDB0LoPTgZjg3wLCqUma8l+BzuJSmlL4DcpGaf1LXJ55ZU58wLyZirkmdnZsmU8g6Jg0cNsmSM6/4+gfqQTU/D/Bk6q7NDa1ePQwYBXb5Ul654WvpVjNv9U5ClyEvJ6EhiYjFqi2I3aBHOw
 jBOFog1k
 fZ1XXgqSnVZM6iACST9TGQ5Kh5wSyW5bK/EHIDSDcbkV5Rg2Xr2spN6umCE/tmEbiJWOEH2XnhYGHxpA9+4Pi/G4EkNc7G9c8tcjMG0pnTy5uu5OyFysj0AgOQ3hNyo60uSB0WItezmugiDLxwW6BVV/BnxS4nZ5yWWSmsJ/sn+fFAtKJYQwSe2Y43L+CiZHWUmEmW2VXr8JnWPh3IG5tDApqrbqPPNIbC+ccS0IW+TEMuSn697mowzxFCrk6FkMJ6DB1+uX0MeeToRvwxCtcdNyKVfpuOOUwl8L0wciJ3LNdUuW+8IiFqeP1jC+hmMzD/JWmfWwcsozi8he2BFkV18qqEiKpB6gKoDp3KjCIcESStMXotJdAmZs720kvj+9lMHvvEN104J9LRPeWsHEgiPvxd5GoG+UBEJgJlYt7rx9jy1uJP4wQexNLpLVvbj8K4YCEYo/BRgFgbjULe4ZtKe2ImgQqbAmXxkV2CGKo9Dh/jld8b9mYAEhx39hvj8XKL0tJQtePFmvRhtL9U7DMYL2MPkMpqJ8wlhzTHJF6y8VRHnuF5wZejmgDuHUOMQd+E2Nu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 6:46=E2=80=AFAM =E9=AB=98=E7=BF=94 <gaoxiang17@xiao=
mi.com> wrote:
>
> Thanks for the pointer. Understood =E2=80=94 no new NR_* counter or
> /proc/meminfo entry.
>
>
> The remaining question is on the consumer side: Android's Lost RAM
> accounting would need to enumerate all live BPF ringbuf maps
> (BPF_MAP_GET_NEXT_ID) and read each map's fdinfo memlock to sum them.
>

For BPF ringbufs specifically, you should be fine just iterating all
map with BPF_MAP_GET_NEXT_ID, getting its FD with
BPF_BTF_GET_FD_BY_ID, and then passing that fd to
BPF_OBJ_GET_INFO_BY_FD to get map's size.

>
> Is per-map fdinfo enumeration the intended way for userspace to get the
> aggregate, or is there a more efficient BPF-specific aggregate interface
> that I'm missing?
>



>
> ________________________________
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2026=E5=B9=B48=E6=9C=8818=E6=97=A5 =
2:22:07
> =E6=94=B6=E4=BB=B6=E4=BA=BA: David Hildenbrand (Arm)
> =E6=8A=84=E9=80=81: Xiang Gao; Andrii Nakryiko; Alexei Starovoitov; Danie=
l Borkmann; Andrew Morton; =E5=8D=B0=E9=97=AF; bpf@vger.kernel.org; linux-m=
m@kvack.org; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; =
=E9=AB=98=E7=BF=94; Lorenzo Stoakes (Arm); Steven Rostedt
> =E4=B8=BB=E9=A2=98: [External Mail]Re: [RFC] bpf: account ring buffer bac=
king pages separately from Lost RAM
>
> [=E5=A4=96=E9=83=A8=E9=82=AE=E4=BB=B6] =E6=AD=A4=E9=82=AE=E4=BB=B6=E6=9D=
=A5=E6=BA=90=E4=BA=8E=E5=B0=8F=E7=B1=B3=E5=85=AC=E5=8F=B8=E5=A4=96=E9=83=A8=
=EF=BC=8C=E8=AF=B7=E8=B0=A8=E6=85=8E=E5=A4=84=E7=90=86=E3=80=82=E8=8B=A5=E5=
=AF=B9=E9=82=AE=E4=BB=B6=E5=AE=89=E5=85=A8=E6=80=A7=E5=AD=98=E7=96=91=EF=BC=
=8C=E8=AF=B7=E5=B0=86=E9=82=AE=E4=BB=B6=E8=BD=AC=E5=8F=91=E7=BB=99misec@xia=
omi.com=E8=BF=9B=E8=A1=8C=E5=8F=8D=E9=A6=88
>
> On Mon, Aug 17, 2026 at 11:10=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 8/15/26 11:18, Xiang Gao wrote:
> > > Hi,
> >
> > Hi,
> >
> > >
> > > I would like to discuss accounting BPF ring buffer backing pages in
> > > system-wide memory reports.
> > >
> > > BPF ring buffers allocate their data and metadata as order-0 pages di=
rectly
> > > from the buddy allocator, and then map those pages with vmap().
> >
> > I assume there is a reason the slab isn't used, right? Are these pages =
mapped
> > into user space such that page->mapcount would get used?
> >
> > Can you point me at relevant code?
>
> See code in [0]. And yes, these pages are meant to be mapped into user sp=
ace.
>
>   [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tr=
ee/kernel/bpf/ringbuf.c#n93
>
> >
> > >
> > > Because vmap() maps caller-owned pages, these backing pages are not c=
ounted
> > > by VmallocUsed. They are also not slab pages. As a result, most BPF r=
ing
> > > buffer memory is not represented by an existing named /proc/meminfo c=
ategory
> > > and appears as Lost RAM in Android memory reports.
> > >
> > > We measured this on an Android 6.18 kernel.
> > >
> > > Test case:
> > >
> > >   32 BPF ring buffer maps
> > >   16 MiB data area per map
> > >   512 MiB total data area
> > >
> > > Observed changes:
> > >
> > >   Lost RAM:       approximately +529 MiB
> > >   VmallocUsed:      approximately +2 MiB
> > >   Slab:        approximately unchanged
> > >
> > > After destroying all maps, the values returned close to baseline.
> > >
> > > The question is whether the kernel should expose the unique physical =
backing
> > > pages of live BPF ring buffers through a dedicated global counter and=
 a
> > > /proc/meminfo entry, for example:
> > >
> > >   BpfRingbuf: <value in kB>
> >
> > This looks a bit too specific for my taste. And I think we should try t=
o no
> > inflate these statistics here too much.
> >
>
> +1, way too specific
>
> > >
> > > The proposed counter would include:
> > >
> > >   * ring buffer data pages;
> > >   * metadata pages;
> > >   * consumer and producer position pages.
> > >
> > > It would exclude:
> > >
> > >   * the second virtual mapping of data pages;
> > >   * the pages[] pointer array;
> > >   * map metadata allocations;
> > >   * vmap page tables.
> > >
> > > The goal is to account for the currently unclassified direct backing =
pages.
> > > Slab- and vmalloc-backed auxiliary allocations are already represente=
d by
> > > existing memory categories and should not be counted again.
> > >
> > > A possible implementation is an NR_BPF_RINGBUF vmstat counter maintai=
ned by
> > > the ring buffer allocation and free paths, with the aggregate exposed=
 through
> > > /proc/meminfo.
> > >
> > > Questions:
> > >
> > > 1. Is a dedicated BPF ring buffer counter appropriate?
> >
> > I don't think so.
> >
> > See [1] where we just had the same discussion for tracing buffers. For =
them,
> > Steve [2] had an idea on how to expose them more fine-grained and traci=
ng specific.
> >
> > [1] https://lore.kernel.org/r/20260810094025.136705-1-gaoxiang17@xiaomi=
.com
> > [2] https://lore.kernel.org/r/20260810105710.6ee5e493@gandalf.local.hom=
e
> >
>
> We already report per-BPF ringbuf memory usage either through bpf()
> syscall or map's fdinfo. E.g., with `sudo bpftool map show` you'll
> see"
>
> 1455733: ringbuf  name event_ringbuf  flags 0x0
>         key 0B  value 0B  max_entries 262144  memlock 275776B
>         btf_id 2193434
>         pids tcpeventd(2549812)
>
> where memlock is how much memory is allocated for the ringbuf data area.
>
> > > 2. Should this be represented as an NR_* vmstat counter?
> >
> > I don't think so.
> >
> > > 3. Is /proc/meminfo an acceptable interface for this information?
> >
> > Again, I don't think so. "Lost RAM" really is just "excessive memory al=
located
> > by some other subsystem".
> >
> > I agree that some users might want to figure out what is consuming that=
 much
> > memory, but I don't think growing /proc/meminfo in that way is really w=
hat we want.
> >
> > > 4. Is counting only unique physical backing pages the correct account=
ing unit?
> >
> > I'd assume the "It would exclude" part above should not be accounted th=
ere, if
> > that's what you mean.
> >
> > --
> > Cheers,
> >
> > David

