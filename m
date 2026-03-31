Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3E5A10F92FA
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43BB96B0092; Tue, 31 Mar 2026 16:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412D56B0095; Tue, 31 Mar 2026 16:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3284D6B0096; Tue, 31 Mar 2026 16:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2250E6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:15:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5B31B8E02
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:15:06 +0000 (UTC)
X-FDA: 84607462212.08.CA4608D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3A9D180014
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:15:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f3h6lpts;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774988104; a=rsa-sha256;
	cv=pass;
	b=jCAsdN+yGIA+6cmV3xKuiAwg5RpkL1s8OmF+Uq6mnTnXUL6Qv45paSB9cDVnvDRq/SpFxB
	r/yFiNaHmufg7ZalNUn0v7UZkx8jnfDd4DlG8+EQJZ9IAR9nHfd+8rEzjRN+M9ZlsV1hLh
	l8r8KrDS1JQm4jhPbDFaF64tI6ax9ic=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f3h6lpts;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774988104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwVpGG9S8p/uX+u7seQVpxC4moFh4X8htIhQDky5uWk=;
	b=mya3aIDJkAgR83Zy3VEsD7wUkmWzVRR6k28Hrc7+nBia5hmxWkzeiipO4xApZUg5r0naoU
	ZP6CVFPxcPPMrnDscAjXAe/8so7iXEEVJcKAeMQvUVPnjLdtT63c0LEM0kYjD+ux/5NGNr
	Vhjt6xnKvPvI1DsvFO0BIv18hX5KLvs=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509069a7a7fso831971cf.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:15:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774988104; cv=none;
        d=google.com; s=arc-20240605;
        b=i1iethJSL1gbxfCSNaMs5wRxMZb1cTNj7NxPW8hbnXsVP53ptrMJnBTpXyBAw5hdmL
         u0v/Lq1QVm+k5TWbjBP3rw8L+1Z1qQ+wYnMl2jyIrkt3jx2cAeqXXBDQJc7hrI2bIrBG
         pxeP/Y3bP8wm94cHpWLfdcR5oXK9ZAnbh5LgjaKcD1wwB7jACj3x50aJZnPJR42zG8mk
         o+GGBceBeHxakv5oDTRuFopO+/uMonFZYJuOBPFuTH0vrENcGs5liaYOkqmUCVvfLR8Y
         XtAXqRz3vG+PonF86x7qT0kTwRunMCz7jqOifRjcAk71/HyMMvo9pP5Hzf76AcWK/NSG
         k/Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RwVpGG9S8p/uX+u7seQVpxC4moFh4X8htIhQDky5uWk=;
        fh=vyaZ3A8pZ8zUZCS1r/R+pWRYAWJ7OCPP/6VDNoYdFIY=;
        b=Lh3vUjQuL0HyVwWPR7kVISDEID/HNzscLNgGfQBADvgByipQ2GI/L/mKTLG8DkbF2W
         HXI1TjMWE6H9EzJqE17f3UAjbdHj8tu61U6gdiu/9DUAEnbO0623MDKMYU3lYV/y+YZL
         d1KB5YjCazCe3jbWA0+ka3nhJv86rDBhJ6/Q3ZZLpcBM0QUjRDy9+9IvmlE3YZP5pTiO
         BZfY4lrxRsZwjkjEeRs9LexE236PrNyg0fr53k/+z7czfld6ZL/gigh4z+qOVVhpTJ8k
         FdsbDlJxfFnz835DzPP3TPpnq+OnkYcDpvPd9clTz9F/0AQRdlzHH5T1p3+Fr8x47Iy4
         dvng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774988104; x=1775592904; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwVpGG9S8p/uX+u7seQVpxC4moFh4X8htIhQDky5uWk=;
        b=f3h6lptsaHd8xcFIM68Gwzh3aglpalpey2O1ajoFtVeX6tLqKOMRHocH6l84qdc8dC
         AlM/GRTv0VaydiZ9asvEJTSHeMmIjy5lY0Xp1XDNLXy5c9WMy+VSJHbfTFouWfdqS4BT
         AuQHy1QnNaWlL2gjdDk2tOvPUWOzQVWgsOQP0v8mfND7Mo6B0u3EnA2T6MziGljaJuk3
         e81/dsanIh99OizSFCme4hEvy8GIEC3G+8UcPF3wqzd7q5OJhaqk2yq+jRxyVLvZ4kdi
         xv7VqueYpl9wiB7nK3+bX5M4y0LF9wJNOsH9sNbtRZaOhIMfuMNHqzGTq8mrmoTotKnH
         YNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988104; x=1775592904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RwVpGG9S8p/uX+u7seQVpxC4moFh4X8htIhQDky5uWk=;
        b=CgvtoASvKmaCsRikGPQfCgsRkNXYxxswhh5zcA+sihNOM044DV8ZyHjrgGPIR8POXn
         Arxf0hjuiaZqF4aSdVwMTedIzjYesZkAJh3g4GGN3KaU7V+MEZxhvrf4yeXr3YS/5eEF
         XOEtikI7wwf+73/LBsKfQTX6zw29cbJQLPjJGOBZ7FClfOTN9U2ZOwsFzyFUz0RPIw76
         rI9V8j91sOw5NXDKIe7aJPnu1X7Z2C1GuHG3+l23J9ilzvBOMhAiBHlDgEbZnSdHiUE9
         Nr5xiYJi6ODTF/EZy+hbYhi+fCqU0YUmdj6VFeTsZounurcNQtgt1KOvBYsSX5kp5M/i
         AeJw==
X-Forwarded-Encrypted: i=1; AJvYcCVdrszbegrEI9u8iWDAvyCGfLfp2tvh62IE9HzFyuitnviLj2TwpujEeEIWXRm8FCx3uDcGQDrPhg==@kvack.org
X-Gm-Message-State: AOJu0YwpDqomV9IugK2vgqA+1vPAxiSGFTVYUYVrgZVChKy4avqmyXrp
	judsHgpmzU2oOGsV8T8f2MzNQcdNjPc3ist7Z4MAKEa1U1tgVx0bLQu8rLhd6uSWJMAaQ0lLagW
	surx4yDpPgdxMhkflE6WmFnbQ1X+qJBEcpHplPNuc
X-Gm-Gg: ATEYQzzO4n7wuDL/9BXsesB4FFGcfJzUS9pdRfxwyPIyXaGmTn5jjofvbMOGrOFkhE3
	f/kormmq46TdhadVnTpr8tMcn/ace1+H7wGkOI6EMdTbPor9WnTS2HwIqpIQ6a4bUfnZXr5Ly1M
	OcEPguq36XA7wibx5oAL1uufuq4Ak5bboAYzPtO7CO5m2MIEjEJfHZn52KVNu8v0po0NKhc3v1z
	/GxLiJ9MJGb/FopOSINq00Fok3UIgRVHlXKK2583KIGaGgZ+aQfpubcWknSuQjrCvB6EP98Gbev
	yE7pBdaEQRkSmjprkTVRH/yquPm4eJpYm1bwJA==
X-Received: by 2002:a05:622a:a987:10b0:507:35b2:6b9 with SMTP id
 d75a77b69052e-50d3b7cb8ecmr5105641cf.7.1774988103375; Tue, 31 Mar 2026
 13:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com> <20260327205457.604224-3-surenb@google.com>
 <5d90d998-9b8d-435c-b684-260600311797@lucifer.local> <CAJuCfpE5w8r_6Ss=5ZPrEb1RQOTG6HyY8Pivac=iiyqFRZvD4g@mail.gmail.com>
 <20260331112921.854d4f6cc793dba0972ee9f1@linux-foundation.org> <cf6975a6-336a-401b-b122-b9597b5710b7@lucifer.local>
In-Reply-To: <cf6975a6-336a-401b-b122-b9597b5710b7@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 31 Mar 2026 13:14:51 -0700
X-Gm-Features: AQROBzB2U3UmDFrQdi2wX1twdn7twB7j7RYY85tO9ykEBOm_M_3vRiUWXjbFQEo
Message-ID: <CAJuCfpH2eomYbZ0DzKpkae5DKVF69aRsfXx3HzMfPc6cTT5fTg@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] mm: use vma_start_write_killable() in mm syscalls
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9c4cbfeqziee4dnx4ssfus811h5g4m5b
X-Rspamd-Queue-Id: C3A9D180014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774988104-877132
X-HE-Meta: U2FsdGVkX19UfNWjQQmQ9XMZi8vEjabWhwQUsX6CR0R2DipL37OHpbjLbQATPCw3lYo/HeqPw/OYS0MXaqX1DGkJ0fvl3ltzUJdeX3D8qGC4t1oiwNElA0EC1vr9wTSUSTWYlnwIsdUVjoDm3Zv+ewpkdSRuqnvMzPQW+g9C180+9G5LnJwJoK43CQKx9pc/HxEvjqFKCRZsCucR7S7y0uhKhY4/Zol0oaq7X3yZFXRLerF5N6FBOz6UkKf+6pkkjbz4I+Jaw2TqtV5ptbnTPJfFgBQbJFI0Ug9kihXYt2QwxMgfLKho6y9fmQeGDahsjBKiJhPkFQbAX8QA06x6tl8iQqk49wzy0LAd3tUgpQsVUm3rpKEhJxgcFr90OvbnbFD5Jv1IW7XoJ/vGW+OrZSpSzvV6USwewlqvw4w9QVO5d3EL8X11EmNRvWih2SoS2WzUJ9mhO7HWKGUAQI5+MuY5CShLBOOmnFXf1PJ/k30v/neqDqElxgw+1FNT7LvYreHcD9O3NWBH40QHu1aOvTEZ+BflbJW+rHrCvT0FBFDGg+ERCy9aTpXM0yNLGCbRv8U8Sgoa4BJttmfUMmlffAcVzE9IbNHXfyyerMp5RVpBUjn53H7sX8Vg4l79ykLK2QvPe0FNqfEBnEbWFSlbtXYV7MvzaDVMc3w0KI12RJB8Ag1RtEKnHbByXtz1cCLwZJyt8Q/yduywirc7dBESCH2d08tV46m7vHzJe6+Q7XeEfwwdetsBbIYJ7tJ+LYYG3us0wOW1jSNes55ZYigTkl/tMU9CU62/JERdkktTLqycg4ZW7e0iUV57qmx89w5Ik2hyjcfF+a+bsVYKDxo1Rv2OdovSwpODlSx1D6zZHdN6JHh4+cdCK0ISsEunXeoR82zNgzx8kK0WRldvsmsNJEiR2ekkVuAdO2nMClwpMDDUdS2Pyx9IVy4lFr20mesxBK1GzOnAWHI4XB5+H2q
 Kc7dpOQq
 WM4SF8W33TlYaL0eOczFdyUtSUn4g+qftR09L1tgquRblv309v5/YhLwG5IECIb0633m8nkHQyAPPlBExzB0icSoEuhzSzL6NjTcJgv8VYUuka1ofLfMj+2FJBBIy01jsaoY4/zWJMgH0u99gt8KUk6LZQAM8UirJCbpoaj5dqvnWuTL8DdVLBxOn3/m4+TWXCkS7XcsFr2rX7HbBzU/tmEuy2VDnN4pSVfhL8YzB+DHKk67cqBYrh1Cai9HbooJpIqpPRplFrjcqlR0tJstGnviu0eEdldsGMCQsgUb7SwF9g3d5luTmH0sSgLS4mXaZWdWCcUmnSw28cAq79twwydmzYNP02M4LdVK6HY+wbC+agZFa4vulbqrsy/1Os1jG9lHwWb80z4GqRt3ouHCnQAOg7KO6C0n3d1xRsc/KtxyaHVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 11:47=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Tue, Mar 31, 2026 at 11:29:21AM -0700, Andrew Morton wrote:
> > On Tue, 31 Mar 2026 08:01:11 -0700 Suren Baghdasaryan <surenb@google.co=
m> wrote:
> >
> > > > Instead? That is, assuming we really need to care about this at all=
.
> > > >
> > > > But I think I don't like this change at all?
> > >
> > > Yeah, this was the part I wasn't sure if it's worth adding. With your
> > > vote confirming my scepticism I'll go ahead and remove the parts I
> > > added to avoid extra vma_start_write_killable() call (3 instances in
> > > all) and will post v7.
> >
> > Thanks.  I'll remove v6 from mm.git and shall await Lorenzo's advice on
> > v7.
> >
>
> Ack, if we just drop the problematic bits we might still be fine for 7.1 =
:)

Let's get your cleanup first and then see where we are. I also hate
the way I have to report a fake error code, so with that cleanup the
patchset should be much nicer.

>
> Cheers, Lorenzo

