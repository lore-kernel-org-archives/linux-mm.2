Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A93A8CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6FC8E0014; Fri, 26 Sep 2025 11:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087A18E0001; Fri, 26 Sep 2025 11:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB85D8E0014; Fri, 26 Sep 2025 11:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D52C18E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:38:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7649213BA7B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:38:54 +0000 (UTC)
X-FDA: 83931809388.01.40C49C7
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98384C000E
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:38:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BOgSjGGS;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758901132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXzocX6ZDXcHxojnIagSNZA3qKAOhB8e13p864rbCw0=;
	b=GrFznYJFvZmc/7iBQDJpQbzOx7L5J6VxrkxsHjm37cws7cBTgQCURm52FlAUKQi8frEbRb
	QFOjrZSCpiibuMVTIUe3DnkBirZFA6ou11siHYEog0KWaUT7PRxGbvLfAIRyga4XVCINKy
	fO5PFnd9uVUaXTDiCj3Jmsu92AQMEmQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BOgSjGGS;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758901132; a=rsa-sha256;
	cv=none;
	b=hdIXTI77xsNSEaC+gonMB18ZSK8RF37rKWhNGW0zj0RROyY1lEpGi2nVusNVoXans63AvJ
	Sok4/pKBTpfWRb9PY5RAJToN3F3JpaYVgsnzYJKfkl2GymY39DO10S2anP1Z7i86Y740KH
	XgnsfxwosYZLCwSaYyrOP35NzxCL+i8=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4c73047a75cso193081cf.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758901132; x=1759505932; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXzocX6ZDXcHxojnIagSNZA3qKAOhB8e13p864rbCw0=;
        b=BOgSjGGSftfDfa1Wi6ALFIKJVlIKIBrpAGEGiaOaRBO8gYuM+vucStemB0SWSeW63S
         /TyDexVQrZwknC3b2fEv/UzI4xe9PYza4rG5RJiJf7zbXj23wrITyQ1Y8eeJP+/NeaJe
         vfbMeEFRb9uioppICxAsVj6aZietAXKii2VbYcxV3tJZ5k3eckFkeiWK4hBWV8/0lbXB
         mgKmmCUtuRVZ9L8UFihmrgmiiSInxsskmU5rnTTCJ+uPD9I9XJwd7/KbsxxiSVc9pM8/
         FS9oC10c0WKzlIsXf2Uk35H+f6QIkgYoGjgytGEn6Wx+Wtx7YbhhY0DCg7kPCLalxbhp
         dDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758901132; x=1759505932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lXzocX6ZDXcHxojnIagSNZA3qKAOhB8e13p864rbCw0=;
        b=a61eq8W8eG4eGhPwBD+vqmpQcEJ81L4CvAgWlkkcQ3MdEkMpqqOAavXkg4JTP0t1I7
         8ca6QhQ4OY7or7VW4Fhv7cWwo+JLdqg/m4Bhqp9dmiMLPWYfMpqS+kDp5D//RaPOMuuq
         7zZ/MzecmGv/qSi2XsS49yUTPT1W5HwNAykFflhAE51OgzMrJ+qqsx+zGYJ1+3p7e0Lo
         T/N8TDyfETvA54QrpjOTFcphwK+jNu44/XyUk13RmlWOI+Av9HUt1vSirjfKtiztRUC/
         WhQpurc7QR8WbJEZboJjQrv3yc48utkJ8Cmdkqrp0GinTyEHk/TYTxILKcigFL7lixtT
         vPzA==
X-Forwarded-Encrypted: i=1; AJvYcCVT/qS0yLzeG9LfZA59PYEQiSWde4bWBIZSJk25ESvgljqX+nGOpu0l+zXcMYjfB002gd+eleQo0w==@kvack.org
X-Gm-Message-State: AOJu0YygTHmVgAi0SJOFtDrWnim08uBwIh3gAvTAmZcwSE7pE9TVGEuJ
	bosCYbPs8+NjK8SS/cK0YsMCUNn0MctA7j03tEJI8rpcb9k64SlKHDQxr0H0ZYYv3ZF3HMCaxOg
	po1nSX/28rFjedWzfx2g4F3iJIQVFaqBsGVl0P/Yg
X-Gm-Gg: ASbGncvaaAIfU2A0vQbUcuYK+Ozbk6nl3bg0Atg6PPNSXzYoT8HbDWbW789TITwRYn+
	evOuSBlwuDhXa+lEdZlENXFnLWF01YVwp9GDn7ONkufLFDaXH6snUjdh2/F11OHA9Kb6u/kxiX8
	qfdpQXY8llwt/6iYJ6dQmOpp/96BkDADUGi5CuPZa0NeJ+qewLk2qkcBYsR+nQYj1awcwFTWi46
	w8VeQ7VxDlQ
X-Google-Smtp-Source: AGHT+IGUxL+Ts8nZMxqg7rMa5w9X1kAO9wkdvMmX92FoJO/bv4bqeUj1oEI2kGl0p735VGIj1Vtf4Ntxfyo6WGTFanA=
X-Received: by 2002:a05:622a:14c:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4dd1675a20amr6251731cf.2.1758901130945; Fri, 26 Sep 2025
 08:38:50 -0700 (PDT)
MIME-Version: 1.0
References: <202509171214.912d5ac-lkp@intel.com> <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz> <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
 <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz> <CAJuCfpGLhJtO02V-Y+qmvzOqO2tH5+u7EzrCOA1K-57vPXhb+g@mail.gmail.com>
 <CAADnVQLPq=puz04wNCnUeSUeF2s1SwTUoQvzMWsHCVhjFcyBeg@mail.gmail.com>
 <CAJuCfpGA_YKuzHu0TM718LFHr92PyyKdD27yJVbtvfF=ZzNOfQ@mail.gmail.com>
 <CAADnVQKt5YVKiVHmoB7fZsuMuD=1+bMYvCNcO0+P3+5rq9JXVw@mail.gmail.com>
 <7a3406c6-93da-42ee-a215-96ac0213fd4a@suse.cz> <CAADnVQKrLbOxav0+H5LsESa_d_c8yBGfPdRDJzkz6yjeQf9WdA@mail.gmail.com>
In-Reply-To: <CAADnVQKrLbOxav0+H5LsESa_d_c8yBGfPdRDJzkz6yjeQf9WdA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 08:38:39 -0700
X-Gm-Features: AS18NWDgSteTnQAeHe58pnPN5CXO_C6LUnKFpTmB_8Hvkh2DQsaUFE0c0GhVrg0
Message-ID: <CAJuCfpG7Gf3_P6gKrUa+3iNZgq7SNd7nZa7Uq1P+v3FVHnL4QA@mail.gmail.com>
Subject: Re: [linux-next:master] [slab] db93cdd664: BUG:kernel_NULL_pointer_dereference,address
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
	Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, oe-lkp@lists.linux.dev, 
	kbuild test robot <lkp@intel.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 98384C000E
X-Stat-Signature: jok97tpn89665xwk91njfmugr3fy8hep
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758901132-750341
X-HE-Meta: U2FsdGVkX19Zms8VVTUlrXSkgzXQDGv9yS4fhgxm9fdB2sEgYj1kkCDlOrMn6W7sf73+MSYQMwnQNRQn8rDh7c0rw20+zYyKEDPmaCFDo5AL+dtO5ulH95+00COIBE6Mt0I2uu1C4FUqRr3DC+yV9aUDGtxKQDT6uUoZYlGiyOflUSVet7o/VraXYHMSZHs4v/onKgI3nhDBprK38Gg79DWWew+ApHzKN6TWN9+h4lgSRLglo+79CEFxvIEeZmPuJO2aYfRRsS/A4rpqje+wZGOfldkVbFSjbleuEDXS9xTeNrq7S0ZaZBdMXIEnVJELunoRrzkkWOm3WBqu7kW3MKn3oVy9FppNWNxsOF2RNgCpXzOH1j2W5VB0KpVccag3lIMTbyaThBfGUVUinKb+EOet/LKMQ6p9xpB73grjbiEukMqyS35XAArrvLfYT5a4qaoFbhsOf8f+uSjJg1IBz3mZqltPYvAsLqbzbaK/M3wAsSC5YmQvdqY2h/sfCZuL2swkWX70jj0K8F0GIDCefrQMtAZ+UDcxB4TmRFXTsrCEW/NtZ63qDml6CleIpGX5Vb2jmZL8OWn4W+BqCZ1L1oT9qHjw/xmTesJs/aNKQnU2sbi55HjgGwcOdYMmc2EpLD2Lmu7HFHsqlBGRsytCcIEWNdgyAjDVDU3St7Ikux7+wzpLPDyI0H6K4acKG5+4WlmVOzPlS21H2bZGR6RZS+uwvpgvWyL1247SNzeEviP/i2QclvyxGQ8Rxva9i7Q3BFCrnH9+QQ9Z+eB9On9dQO0969G/ymug8jMeYIbl9ExmBCAd/JaoK4Ej3ivcUn/g48Wb/vwsnzVQUKV6/YJTeHqTINLUh83SOnW1ErJ3Y4Bc2vLN5pVTLTZUfu/2NOI/SJDx6l3vGl1Z3paJaASu0P3arzxQw/Sfgh+859iVpFzq9hdopakxHU3aYK/zw1cJH5jrTVsSYBKYVref5CR
 maSTfx0b
 lPFw/B0Bsj77qhyReUtp48jKHHHpW9LGPiK8JcVEDuztfjrjPblotWtOet0ctPA/I3Zt1HDj1VpzorX+FhvKYgszjnBfkOR3dWRDSltySk6zz7PUTqE/inubARWQkrR3mXdks20/aAkWSuNOlOaPszhQMc15fROXsokjTXBVm6vf6DjPk8N2++QyHUD/bAvTN9JZLZ9oTrswShvk7FBT1pgO4e4M8nEVv5U6VxI3vl5k8109EnqIvq3BYLKHsDi4TQhDS7QqSrJoeZBkeFMMyXtDYv9KEqsJ39G2XBKfKfEno2ZtnAJYcGoW7f9+obOnyfEiZMgvLC9yKzwSvCAwNUIcK3i3LeS7DDd5Lqq2QeRlX7pM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 8:30=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Sep 26, 2025 at 1:25=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> =
wrote:
> >
> > On 9/19/25 20:31, Alexei Starovoitov wrote:
> > > On Fri, Sep 19, 2025 at 8:01=E2=80=AFAM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> > >>
> > >> >
> > >> > I would not. I think adding 'boot or not' logic to these two
> > >> > will muddy the waters and will make the whole slab/page_alloc/memc=
g
> > >> > logic and dependencies between them much harder to follow.
> > >> > I'd either add a comment to alloc_slab_obj_exts() explaining
> > >> > what may happen or add 'boot or not' check only there.
> > >> > imo this is a niche, rare and special.
> > >>
> > >> Ok, comment it is then.
> > >> Will you be sending a new version or Vlastimil will be including tha=
t
> > >> in his fixup?
> > >
> > > Whichever way. I can, but so far Vlastimil phrasing of comments
> > > were much better than mine :) So I think he can fold what he prefers.
> >
> > I'm adding this. Hopefully we'll be able to make sheaves the only percp=
u
> > caching layer in SLUB in the (near) future, and then requirement for
> > cmpxchg16b for allocations will be gone.
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 9f1054f0b9ca..f9f7f3942074 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2089,6 +2089,13 @@ int alloc_slab_obj_exts(struct slab *slab, struc=
t kmem_cache *s,
> >         gfp &=3D ~OBJCGS_CLEAR_MASK;
> >         /* Prevent recursive extension vector allocation */
> >         gfp |=3D __GFP_NO_OBJ_EXT;
> > +
> > +       /*
> > +        * Note that allow_spin may be false during early boot and its
> > +        * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only suppo=
rting
> > +        * architectures with cmpxchg16b, early obj_exts will be missin=
g for
> > +        * very early allocations on those.
> > +        */
>
> lgtm. Maybe add a sentence about future sheaves plan, so it's clear
> that there is a path forward and above won't stay forever.

LGTM as well. Thanks!

