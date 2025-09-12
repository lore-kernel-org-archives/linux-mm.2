Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2991CCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 03:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E3A8E0008; Thu, 11 Sep 2025 23:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5828E0001; Thu, 11 Sep 2025 23:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C228E0008; Thu, 11 Sep 2025 23:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3F58E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:57:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04B1C1405E1
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:57:08 +0000 (UTC)
X-FDA: 83879237778.02.80A5B6A
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37F6640009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:57:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VWPJiEbB;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757649427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAJiXDF/fD3hc8sf7Mu6vNZd4wuxUuBCwcjlJtaQVfs=;
	b=iPbFhCdYgMrvqvfh0b/4GqDwcxRam+gmfGNjbmi96eUSfQ05pogx4RF6lRh/3m5ueESgI8
	w6offPOadHTnrI+fVLkZq+7v2ERp/AMlzZjk1/r+I4DBKQzGfZXnlv3gHgKvR+pAEJTWgO
	RaKq9VV0RF4nJxgnXi1wdPt1V399fU8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VWPJiEbB;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757649427; a=rsa-sha256;
	cv=none;
	b=P3Tq2RvomPF1kry0P5cOx3rR0scC6Y+omE0x9kZyhDMm+XoDrcT/twxNyRE/0DH0bWIh3n
	ATnbfrzCKTnURQRwFvoQd4Q9jk22bfN6m1e2vRM6llQLdaHcxkCeaRE2Ya4ALYPbtf1lSZ
	tSB+VxS3ha4djL/N9/PrD+x6hURNsHQ=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b5f6ad78e4so15193581cf.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757649426; x=1758254226; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAJiXDF/fD3hc8sf7Mu6vNZd4wuxUuBCwcjlJtaQVfs=;
        b=VWPJiEbBb1hKV6gy88jTteiOULHNzCu4d2gzC0UICCBvZ/80b38xoRjFA4ay2NOez+
         ORTIUAKzq35a4zyYPk8wuHiemWB05PF/WIr4k9jRuObroXSvAeVwglT0/0Bw4clvZnLk
         bH3NFABmTRRIlbhyW/4Bm3pv1yepYH1hk0dPI1jZgRaxhslm3F+ZMYpeLlwZRcX7Roje
         KnzwmYnwGQyk4gknaVtQzrw1DYnJ+w8Z05NhNyJbO+jbM40uu14VpGAgEKKbGjRpdaV8
         epwKYxdiTU6gY9A+yj2YKX+XZAeTwiNrtCLLeiZ+/hWUcUe2oviZeA5uHZeH/u226ENP
         3aaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757649426; x=1758254226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAJiXDF/fD3hc8sf7Mu6vNZd4wuxUuBCwcjlJtaQVfs=;
        b=MhUfVHrWE/wjsnU65YjCS9GMmVbjO58g2YeltKUBYquv22eSlEMQmaViCd62M6wNvl
         +C4K1qBeNS2pYLhTT2cKEtGqxJSr4B1+uN6uRwgu8gBQr+cbJhBp284qzlqdTEgiQRR0
         GvoCYWXrOTeUy6kmSXr4aSxaK0kWvVGqC4eMB+IhdYXpr9qaylS4V/VE1pBn2d1OlLHx
         qhlih57qA3yfkjx/umNDVRie74EsNK0d89Ldhjx9sGGmwmeeFR+fAByGmfKmGXo+g0Ty
         PZeXqiQT+/45Ks1S6Jihl5dDNxNGBHXmfNfZMZVPOOFuP7QkOSIDH/mPC7N+ol4pR2fM
         qMMw==
X-Forwarded-Encrypted: i=1; AJvYcCVkHoJ5FmkvRKNzexyewWePia6QHrTN6l06cHPp9helwxmPR3O4Zh9o32exaSL21jg1/OqkSwzokw==@kvack.org
X-Gm-Message-State: AOJu0Yz9/8UBSrp7lkl56pFdOStM7hOZIAPLIhUXavoJ/t/4uoqX6GSH
	0V6F18UGvk3GN3CxIcplcX323cACqMLenXIX/hj/BJ9GNPWdDTijxwI7+SGGERV60syTnVrksvg
	+Gna7EgrhI/lOW4YXcNtwhIlhkwiDn3c=
X-Gm-Gg: ASbGncuaRWjAHZpS7NlWhomhPhSVP9WfLMhBG0zohKuRyXuZ0OLeSzZejD6R80H9E5B
	uZ3Xp7W1+Pi5tsQZqakiyGztNW3Un5qvPQq8F3wVdViQG3IeoXZvOoUmSTDmDBJwl+IkWwCHxBQ
	7pnewfDZcU9aVNKMXV3U9Ss2KRakTCXE/9wvJYwN3EA+X8+uOxz6SHuMC+PGNKlM6PSyUXvZLt+
	d1NFoJa8jJrhp2xoTcduxpS3QE59cw6lwO63yrQ
X-Google-Smtp-Source: AGHT+IHjvfYmECVMZR5SzxU0Levi0VduXfCB5tWYUm/iHSaSOi3R3RcGti/TTz0eaSI1wFcV4Xxuj4aaOCrBqd77PEU=
X-Received: by 2002:ac8:7f07:0:b0:4b5:ee8d:e9df with SMTP id
 d75a77b69052e-4b77d0ae713mr18117271cf.36.1757649426113; Thu, 11 Sep 2025
 20:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-7-laoar.shao@gmail.com>
 <mi5gf7wvm3hjnfm3gkrye5mpzcxlmfkzy55oqhaqdbsnnwxjfc@teia7omm3ujl> <aabd3a2c-0527-490c-a562-95a293a849ae@lucifer.local>
In-Reply-To: <aabd3a2c-0527-490c-a562-95a293a849ae@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 12 Sep 2025 11:56:30 +0800
X-Gm-Features: AS18NWAHiiqURNXXotwEWaVOm5Wrj0edZ_0g8FxXtJ6rh8zmwA2Mzl9_JGR--30
Message-ID: <CALOAHbDuSEMKpg=xnk9n6WxvwU=qiQkBFTQw9hhu6B1O0KCt8w@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 06/10] bpf: mark vma->vm_mm as __safe_trusted_or_null
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, akpm@linux-foundation.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 37F6640009
X-Stat-Signature: ce8881q78ibk64kbnxhyr39q81b9naha
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757649427-296339
X-HE-Meta: U2FsdGVkX1+NfRIgUkE0VDQOqXxDQGNf72pRCUl2L8ZAA2QldL62Ri42WA7JfTLfvGbP6kmrCFixcCASBY54JK4exRQwl5BOVnUu5j7wLOzn4ooT+6cUKMgvGWij4efIVrZEtGieghCrhiYLoqC9R3uCUDxttJRAUtZjquJ12+C5uKArwjbiGAmVHPHvCnAnhr6ffZfc0G5mHHHut8aKsx3rKU43+Nd4F2aSoZCi+f9n28NygCsxodBPxf5kMZil9D6DnWMA5occQYNLNhBGqPCeWy3Whdrpf0ji3PqpDT5x2uhN2BuITCxMEWdjbvKbVbjsxDSI4UzFkyuL5MuobXC4hLRukpS4fX7VA1TddEKYgLZQkTwj9ykTLwtxL+U1ReZ+2vMd0e0M1yleCzaPMShujW5+JtllCg2PPTVE2MUTHIkIgCQtb1rt6EBNIrBIwSTqs4wgF4vzEarfaeVrXdUS9ciD9Sn7pS28KL9iNqNEfUsDSqreacHeqKMa7Ddr169wwSJDnyl8acuitfpVfy/ozhZuzBdKKvUnWnTgLGwwZpdHLzElQnR/vS5NfHtPmvO4IzyalOGmD1OkaVkznJJK63L46tx1Z1gL9nTi3fL82ToNvz9HPkws9idPMpCDf4V6oS0iJL5N419kTTQInyQzpB58oXccW40apubvm73Pajs/ZfcTSUMDm3ai/LJ1ngFDkRbtlKx9UmXXjHtYu5Iot0Vr4saZ51Yjb/VxKP/+EgtiCheerSCJSOpZAudB7kpzayHbLVFzYx+Ik3RUSxNghy2GovRYYwdis5YM2ZV8GRdf3d9ti3zWz+M0rZD30sqvxV/AHgtqyjKFlh//sGKg+/7xLy8tHVROPCW1X26MVPmPSPxoWsYI+N2saqBdPfpgn3b4pfjRz7afYUDhfNRr5O3CbcGwxioi6CKIi0+ePnBLyuoXfOSqVGsg4G4W8C5OEvJHRxQhBEN1+bf
 hAcL/kSf
 C6LT/FxiSy7J62kBFC4JIjFKWw5DMyXxAXd1++u5HGDk0uViIqwxL5bNwliNcxKPZY52Ta0AyUdl3gRrEP0Ph5i1D68SpHe32y24wWE3rRFOGYHl4vGTVypeGnEfFNrYwv2kpcy0SaGyFtI9W4IFwGvYJQEtdY9vSUsoSoraGee3TYbNDiPJNLitzQEm84F5COptYZ5YWHWkPbQ1jlJLIPa4touWJSlxF2Ik9mrB29nYpNMdmGTZMxGS2shLuYSkY5eCVoHQvgarw5kvF8Wm19kfaF4pRaOll36aGIegsXv1wImYDPDgFu5BDilyvr2zlT6bwjY5SsztgK0Kzv9rZB06ZnPlNeLQofUdSn6blcPsvHg6NQIKHVSUvfj4VYVPAJhgF/uBqzS+7d/YrMyDm3EDRCiCiftEjzU2umNdYpuoMp2KoRmNaydL/tMovx01IPghObn3cGq/DmrrJTKLH8aD873j4Yf/X4fRC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 1:44=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Sep 11, 2025 at 01:30:52PM -0400, Liam R. Howlett wrote:
> > * Yafang Shao <laoar.shao@gmail.com> [250909 22:46]:
> > > The vma->vm_mm might be NULL and it can be accessed outside of RCU. T=
hus,
> > > we can mark it as trusted_or_null. With this change, BPF helpers can =
safely
> > > access vma->vm_mm to retrieve the associated mm_struct from the VMA.
> > > Then we can make policy decision from the VMA.
> >
> > I don't agree with any of that statement.
> >
> > How are you getting a vma outside an rcu lock safely?
>
> I'm guessing he means that kernel code might access it outside of RCU?
>
> vma->vm_mm can be NULL for 'special' mappings, no not that special, not t=
he
> other special, the VDSO special, yeah that one.
>
> get_vma_name() in fs/proc/task_mmu.c does:
>
>         if (!vma->vm_mm) {
>                 *name =3D "[vdso]";
>                 return;
>         }
>
> Not sure you'd ever find a way to bump into that in THP code paths though=
 ofc.
>
> I was reassured in the last version of the series that the MM is definite=
ly safe
> to access safe to access
>
> E.g. https://lore.kernel.org/linux-mm/299e12dc-259b-45c2-8662-2f386347993=
9@lucifer.local/
> https://lore.kernel.org/linux-mm/5fb8bd8d-cdd9-42e0-b62d-eb5a517a35c2@luc=
ifer.local/
>
> And it _seems_ BPF can already access VMA's.
>
> I think everything's under RCU, and there's automatically an RCU lock app=
lied
> for anything BPF-ish.

This is true for non-sleepable BPF programs. However, for sleepable
BPF programs, only SRCU protection is held.

>
> So my A-b was all baed on this kind of hand waving...
>
> >
> > vmas are RCU type safe so I don't think you can make the statement of
> > null or trusted.  You can get a vma that has moved to another mm if you
> > are not careful.
> >
> > What am I missing?  Surely there is more context to add to this commit
> > message.
>
> Suspect it's the BPF-magic that's the confusing bit...

Absolutely. BPF has a lot of magic under the hood ;-)

--=20
Regards
Yafang

