Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D0D9D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 01:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746426B000C; Sun, 30 Nov 2025 20:47:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E506B0010; Sun, 30 Nov 2025 20:47:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6345D6B0011; Sun, 30 Nov 2025 20:47:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 580D26B000C
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:47:54 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CDC5C0F70
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:47:54 +0000 (UTC)
X-FDA: 84169216068.05.3B70247
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 21A1340014
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:47:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Iq/Svk83";
	spf=pass (imf07.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764553672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RubrtJY1nBr7co+TN5Cf36o/x/R4Bh4y+nkU3tUAkHg=;
	b=7Hx1r/npCvMe0/Mdbgpb9zEx4cTvSuNKz97+JjjbyRpYQ487v7NyMLueG/6G6ve+QrRnq4
	WSz+nNH+/lDH9ykRMoSu65Mxe0YQM9N/MUAY4N/VjmnnolzNzXz3ipCwcpX2knHILxAnag
	HZRS0/g2Knh7dipC0zNj3fKTAJM/e/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764553672; a=rsa-sha256;
	cv=none;
	b=ToUIUuNN1mE4942ZYlaSppM+Pm6ST1mkE9w8EZNIm1YPiekcKBzfLhy+cd8oQpy/dO+mB1
	gxbpzjGoUNurOaQipajSbmEBon6RL0lyffjpKedr0h7qtW6viI8lQOYVs8bmcD2E1PgfFI
	b3xUp2rJNLqK54niQtz8dD2KvaVdgRU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Iq/Svk83";
	spf=pass (imf07.hostedemail.com: domain of vannapurve@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vannapurve@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-297e13bf404so618675ad.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 17:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764553671; x=1765158471; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RubrtJY1nBr7co+TN5Cf36o/x/R4Bh4y+nkU3tUAkHg=;
        b=Iq/Svk83tD4/KbHj81+KO6v0wiSTBEMKyiga8wR7nyejBf7MvYMuKsbr7z+QEcm8uy
         ZFoPfcccEKMr84dUnACyY1KtmMhsOop1NtTfkwi86mXMvFkHRInbpxyfvIt6+/UTDr58
         nHxBZ8fGFBC0EAHziCKc9x5CDQ9u3Wc2/3T9DMVAHlK1wJ83f51+kvZP6sa9VA0h2yjE
         IuEENeSwbAnvVHmGgeGbnRJSkO8mU8/079ZOCNdKRnwfuC/GmGQ7ECDUY/Lh83aQ4v7g
         7nfU1XbiMnHxeixq05RPo8Rm+gt0A6ArEjpfRv+ic2wSu1HgwcJ65tDlMv+SlrdMi0v4
         /Yrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764553671; x=1765158471;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RubrtJY1nBr7co+TN5Cf36o/x/R4Bh4y+nkU3tUAkHg=;
        b=eAXuraY1Ke/Pq5w1L8MhGi96kPCix6wbUKlJDQBwJO5DLYXN8LvPU+g/qIxzumgYsa
         gcZuGiIy5znTMNRXwEvtpYoVmnKUNa0YL1L5iD1t3hgxJtXrf0YzXVGsnNWKTuZsYg6O
         +j0LoL7GkxA8UpdpO0pryqCOLKT5TAY0YP1Jdh7tGHw8InjEI+g5Y6ORKY/Wovq4eH0i
         mVpu+mnbU47aHnb2OzIo8J/0QOCJZu6zUm0cC54AxwCGleFL2fP3/qVil6JomSrASp5y
         ua945E5jb4KwrhK87FDeZyOry8fAXecJjn5E2VIntbAAB09KgEEw5abi1ezzCnpP86VY
         r8fg==
X-Forwarded-Encrypted: i=1; AJvYcCV5sObJafuNNaaCgzQ6ffVUnx0ZqaN3wQCUlfQU7s/noadcDfZaAxxPCcDXaT8HD696cms90ykrKQ==@kvack.org
X-Gm-Message-State: AOJu0YzpxGCDhTGk82oJU1qXr7xtd6gf0lmqZmaTc+ZD3c8jxWURxxMy
	NJ/57SFFtSOkGyN/vz7riPs8WK9IRCamjqqIkNpxlRHd7v6I+Lwsf1rjbJZhJJzpUQnBOIWZF6/
	9+0FlYkA5NlFB9Ac+Yu0FaWODiJI55YbC4n4fDluT
X-Gm-Gg: ASbGnctFeFpwbWfQLcb5ZKhHX92FqC3/GbOB/URM3KzcXw+M5IhYsaJWpJtjwesdYO/
	9uz9Gj5StkI3XQvFSIPj+ZJRNpJiudO9AaYfF34KxnZ8TRN8jKjAhqYEOiz+MPJ3SPc0cRs8bCF
	79BD1E0REPXwNEvgf/F+NeMKcDmoMeOTW7/GeJlZlsLbu1FV0ztVrTe9U6RJ3tD8AqGoIot/Cqt
	dOGDXb62mA07NSQpwPpxZDCcz9j9AdPK5M76ZhQBwzheuHPceQRANaG1iUzixYcMypvbi6RMn08
	Pj2Q4lt+XJ+/p050UtXWXW6mEPD/
X-Google-Smtp-Source: AGHT+IGVKWbjRmm9tgU6uLDNVHu5xkhvGzmzSejdcqRBFvmWHeadfJ39slfnN2SFI/bj9haEVWPhElX75HTn7j06Rtw=
X-Received: by 2002:a05:7022:4a:b0:11a:fcc8:c311 with SMTP id
 a92af1059eb24-11dc9c5d1ffmr422435c88.5.1764553670544; Sun, 30 Nov 2025
 17:47:50 -0800 (PST)
MIME-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com> <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com> <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
In-Reply-To: <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sun, 30 Nov 2025 17:47:37 -0800
X-Gm-Features: AWmQ_bndv783uhaZZ_oV6Xm0iV6cY4XqsD5JvxFNZOjPYdlSyliY7wOlOHpUWNk
Message-ID: <CAGtprH9_yo4P+oTaGzhHkC3gSdFPTYkvwHkwN66gQhQXX9fhRQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
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
X-Rspamd-Queue-Id: 21A1340014
X-Stat-Signature: sind6ptzsuwmqotp81qorpo1xzj4iqzo
X-HE-Tag: 1764553671-635114
X-HE-Meta: U2FsdGVkX19QWLkOUCAesB7iDQujwm2MxrHqeBF7UraLdopy5Ol7kza9nVkyFZGtNmtfFRTuQb4BCm5PM23srO2l2p8/+M0DsEhOXLJ5gGRmpx9xXjJzXNlL3LRamxcS1g06/aU19SB2KvL0Q0cus3XiKcf6heI1uTbmRd8NsTV1Fk8hukaR42e+xkh3fjZmRDDq4xhR2mUaf/AOLZaE9Dd1G11lEFn1OmTaHdwl/St6E3D9eZUCjkFYnGFH9v19ZJYEMJJe0E/FDsA1fpYJYKxmwdTiV0TYGFdfY0OcNCBhuiClztvtvBD12TCjaWf6KYmHJkfrwNKafKdtU/ppTJi/hoJ+JK+11L03WQdnEGosrVVaOyWliq0xg4jeQ2INX2iUUDp09UmYXL3k+HY+XZ+KH1PAWJ2UXw0/x29WX6IX5ZzO8EW3uOHJ08e21ff/Rh1Vqp8omV1zJtcx3jFDjM+4KEGa/efdCc4P2E04vFNVzVMYwpOZpkgT+1dd1H98iE4BS1kqs8x7v2qKbKfECVDsphaCXexCgKX80QFl8dSCFsG5meo+qKGYuv/x7+w454DZGbjOdl2I/LimwiPPQUv04wNRnB9CoYID8EtnKWHG3TU7Sr8fslVIV3GfXb6kWh+MpAvfmEEPte6pL1NSoOPwogaEzTadhlZupttQDrkefOc4uz01ayVv1ydRm5+jWAr4l/z2wUlOcRL8K8T8tCW7h2djm83cYvalPb8Gm8zm1zBhIzBIWnytgv6VhPZmcgv7/ftudj1wKUm7l+hCz+/PaBIwJz5EvrtkkeVIkzn+MD5k0wCQre1xfv44LCdJ+E8hI3aEzSAl2RiIL3CunUd5SNbEGx1jvzNI+AUBPaM24PYo4/1nbyDBqF2dWtPQQrgDTaEn1aO1j3oCSd0SdrqDIJ3IqYM4OTfI1XAqvJpuhExHr3dHb0tiRiikrU5ERYYbtYw+I900m3V50Df
 yIwAbfHV
 aVdPIi2zNQwx8DtVKby6OUaOj+OdBHhjfbgicRmIueCgfVDM7g5XYB0bsuAeYw8ZKaAblX0pU5z64fa0EV/it79ygZVlfM8epbkExe/mpnGMEp4BUpKVuuqnF56caw4vfIfKZpd85iG6kWm5bVAYGFaTeDWNkIbfCXpkblvJ9Nj2qDocwnKqdHIaNp1d1+BMqp9iiBADVewOVFKWzTT2ylmsbnIlJWm/3Ug9+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 1:34=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> > > > +                 if (src_offset) {
> > > > +                         src_vaddr =3D kmap_local_pfn(page_to_pfn(=
src_pages[i + 1]));
> > > > +
> > > > +                         memcpy(dst_vaddr + PAGE_SIZE - src_offset=
, src_vaddr, src_offset);
> > > > +                         kunmap_local(src_vaddr);
> > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > src could be 0x7fea82684100, with src_offset=3D0x100, while npages co=
uld be 512.
> > >
> > > Then it looks like the two memcpy() calls here only work when npages =
=3D=3D 1 ?
> >
> > src_offset ends up being the offset into the pair of src pages that we
> > are using to fully populate a single dest page with each iteration. So
> > if we start at src_offset, read a page worth of data, then we are now a=
t
> > src_offset in the next src page and the loop continues that way even if
> > npages > 1.
> >
> > If src_offset is 0 we never have to bother with straddling 2 src pages =
so
> > the 2nd memcpy is skipped on every iteration.
> >
> > That's the intent at least. Is there a flaw in the code/reasoning that =
I
> > missed?
> Oh, I got you. SNP expects a single src_offset applies for each src page.
>
> So if npages =3D 2, there're 4 memcpy() calls.
>
> src:  |---------|---------|---------|  (VA contiguous)
>           ^         ^         ^
>           |         |         |
> dst:      |---------|---------|   (PA contiguous)
>
>
> I previously incorrectly thought kvm_gmem_populate() should pass in src_o=
ffset
> as 0 for the 2nd src page.
>
> Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> snp_launch_update() to simplify the design?
>

IIUC, this ship has sailed, as asserting this would break existing
userspace which can pass unaligned userspace buffers.

