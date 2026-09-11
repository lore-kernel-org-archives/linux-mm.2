Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09952C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E1A6B0092; Fri, 11 Sep 2026 12:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7F06B0093; Fri, 11 Sep 2026 12:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B8A6B0095; Fri, 11 Sep 2026 12:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD3926B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:20:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0733614028E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:20:59 +0000 (UTC)
X-FDA: 85201995438.26.653A05A
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1B8D11C0002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:20:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="If/4bouT";
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789143657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+30lDlcgxH+NCGTyCWjhWPMaOa6aoqrueHB2CoYy+g=;
	b=ZSHAlhxWzZvouv29wELdFER2bIVSChtdNNAbCM3ychbepvpW0axahs9bNFDDL+YZ85QQWH
	g71VZ10nqlQ1lupoi/kHuI/+GZqGo8kUTra3z9X4lr+0aiBoyL4Dw7Ic9tv+MfekHUTLGW
	YxtBjo2sroyjU6pp33EKD4Brfonwsl4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="If/4bouT";
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789143657;
	b=6wYaVZuvDxAFk443j1rJew+5P3oOqd6Yl3t0DU+xQRsGni0hhPSb1Abtk1+VSgLATz2IUM
	O/7ia7sKzNuxUzKrMVftEFvI5Wnd8GCBNRg2qrZohQmG+QgQEXQCkcQV9F/4s2kyk6xX+o
	cUc7E6xCNz5Fne3f6+Sq8Yp8BXwhjuM=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c255c58156bso261355366b.3
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:20:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789143656; cv=none;
        d=google.com; s=arc-20260327;
        b=Sk2le7FKqHYgVDGMSQtRV2JFx7lvsLk170tiCZ6myb6/AI8QaFtbiuJ9UYlvBCyhBC
         VnuKmdM0qxUwVW5SR3tJ08lnqWY1PiBCTER8mHTVpXzuw8N2i+xuGBj5qLZsHOdP84F1
         G5+RGZsO5l/6Uh/izqocIAooUPH8sGQSFGMi6am7X4mEFhJpjvVQaVPA+v+lbE5rF0Sd
         zie4qcn0GyeqldFhClpnoREXMlSb+AYu0ItsD9nwjXsOgIy3Ny+W+MZaEUnaO6VJBXUR
         xZlNvDMKxwiQBz1cnYiP+A+xn3JEy06zDhq46Tm7vrhIh5bcyYkP1lBZTg0WjxL5zSki
         i1dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D+30lDlcgxH+NCGTyCWjhWPMaOa6aoqrueHB2CoYy+g=;
        fh=LoTIyWfK6u5+SXYJA8z8tQFPT+X2YYi8i6NIWnclbFQ=;
        b=BUh4upREYVSFMk9eHxxS/MtwZdmg+MvJfjvzDAtnjzHz7RPfjlD0mOj9AjaU5xYlp4
         DAGTd/KvX/EsQpdLm3tJfNUhucRVtOzSeujM6pF6NWF8/BkVo1RoyUrnW6pucGfc8azO
         HeWr3UJgof/I9i5I7wD8PSUMBGQgXCNvD6AoRFOiEHIxzgSoC7VzwjI280tI4TU94kYc
         LxKPX8m9UJo3Ac/9mfudW9Y+LcyaQ6cRb95yxUUsAVwDM8+xgCmazRldEQMU1m3nH5zz
         F+tLc/w4ECeYQvAcVxKJubkj5DJy5cy+lh4RuIvuvVZvsY6YFW687ptzUjfr8Cc/Q0LS
         jZwg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789143656; x=1789748456; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D+30lDlcgxH+NCGTyCWjhWPMaOa6aoqrueHB2CoYy+g=;
        b=If/4bouTUTxArdGpDk9iood+mk+GtmGjHTMAupbZuwhD6lfIxUIpMUXNv/Q6CjGDFH
         HR9gnY7QLAWrUMCU16EarZtzPWfCv7THO+BYiD2a2zlXZiFTTjbaD8foI+76IHhi6ze+
         MfSL/VWL7wr7HgYDCG+5POpKGIYnTJFcAa+/aCD2H+oO8974xpWy9CRKk+VI0V9h/pJU
         ehOyaYRCeVTwdUw0UwA/ecNt0jj45pDc5AlHEjetumkeD4n6X1ZNB+3NDwAEsIN3yVI1
         fSfE8wTv+DZT2mK3mGHb3nqEzPKd33feVbsv4WqzXFaGKmTOGCGIjMtuDZWurp8f2ey2
         tGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789143656; x=1789748456;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D+30lDlcgxH+NCGTyCWjhWPMaOa6aoqrueHB2CoYy+g=;
        b=QjQBnwkNXkJmernr2lRYpMOGj8vjOp39cGPNfcyRY7jK4KSJY2YRxz5BBF+wo/QxKy
         x03UYKbU3nWKmfv2nM4uejMsa2wjTLuoAG3+BLzq0xB01NFXnYHQstr52ARnmDy6eett
         dG7Y09qwcHD43WFDjew7N7nSPDbucAlCkl/WdJwlCFjXatLejvbheARC0l57trmvdZBa
         RUHWrlb2LuHoLNMWfdNYrcLsIx2est4oER8biQx1KOIcRHYbXa3rGck2Rur55mTZrrw3
         aY190oive9QZ3P5Hwth9rV0Ne8XTgcxeJZohd2SRvj3YS9a3ksCIesp8lkEIMBo+BKeu
         P79Q==
X-Forwarded-Encrypted: i=1; AKwUvBzsn5G8CvP9BmsalzrIYQsY7qp9saLoOO0q9/loXdYGtdkgLw8Gk3jiBt8SlGNgqc4c5FAzi36LJw==@kvack.org
X-Gm-Message-State: AFuF++mULrsgwBebTwKhvJfOzlRDmzhp1Y3ShvZ9CXRWEJFHFy12kKaO
	6fDxxCIjNrKidJSH8tnVB3UPqfcKY14SPRhbE0fsymDQkROJd8CUBa0Zrvuozhtp7rcKLW/4fsl
	Yd1fIa/vjkby9hIgVmkbAPL24/eBI8Do=
X-Gm-Gg: AYBFou1Ri/qMTPlIoIlfoeWH9EZjBwvEsxzgF+XxG9UVuZgo/i4m3Iqg4HomwTUK/Fi
	r48HFIZDyItSVTgblMk7xjqdwgQsvS+xdhbNRsIbhDuwH7LlyDw7Xyvv6XosUbylXTrLFvUd8P+
	NfoNDUbDBCCFA2GfWfd0yzPt3qusy6B843AImUOzcSSFbAg8hVLFBeCtiDYxx5Ds/8rVpTc3uEF
	chn4dmSaKRvO0F/LYu1B7TQbLlmyowixXOvAra7XBsfoe1lJjrbEb6wK/iYckNOZBGgI9N/naUJ
	guYwS1sgrKWaPHa8QVkp4pHzedNxmqguDH8UBWQ44GxcZS/bY7jAwf1JkjJGP9Y64+KXvY/GKlE
	eG8P2zV9QwpGl
X-Received: by 2002:a17:906:c141:b0:c29:5151:16b8 with SMTP id
 a640c23a62f3a-c2966534d19mr204979866b.2.1789143655518; Fri, 11 Sep 2026
 09:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
In-Reply-To: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 00:20:18 +0800
X-Gm-Features: AcwNN1Wybf6FDfg7sUWRjBvgNHNibYe2e1PczxS_TZMQQ3Wr5_VcCDK8f6zS35M
Message-ID: <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B8D11C0002
X-Stat-Signature: 9op37zrnm69bcr4iuasqfyrwhbpswidh
X-Rspam-User: 
X-HE-Tag: 1789143656-11737
X-HE-Meta: U2FsdGVkX19QCyfIbTFRoObx0t/9jYgy5IgAUJcI4Bz3mXznO5j+N9rac2iwpBr58d+N3h76uvIOXJkE5durMt8ovzLcWGRdvdBo0mqD1efaeNLEBwZJ095ku++ebwDDDBjZHixrAccUeeQePjD2FHpiXjbLZcLFd0kL3d26hyLwIL6sVIvxPtx9WlXTnmwCNYQja4T3K2A+9X7NGEXYvBGVyokG9RlMm6zA3vuLMhucPiD/dqETkuSlRL2OgxpDxa6pcxx3EKWbO5iwjH0+wRYduM5AXHuYr6YdPrzbGOMwwzxsRt3+22fPcV+FYyAcsBrl+D7nS2Vh43gB3IY06xuyv4p/U86gTKLVSdk+KzJglLyGGgvdYoLSJsiJEuKucWdNt+F8rWFHEghmE07OoZYZ/Jwx4qgqeICrW9Vuf7mbb43m1OXg1OfcXmaE3E2TGtoYZ3/RYU+ZKmNcpUzqguU7CEvwtBdkjTyYf2z44arCadqyTcK9rF0LM8rNIYo/KZxpxmMKvYlfgrRrrIh3acUnLytvnbU4E6DqYBbeVtEVW6bmxTNPuDGGQoso+zUQu5m/jEH3/BCE2qN5VQrEsnJOYUT/52bTF2d9PjfT5QG08faqzzSevNAbN8m39MG+5MAXORbvrITDTSINCiGAN50Fb3AZrXuIxgqTtHvWFiErL+F7Hvro8qKhvj0mFotIAEon7LX1wX07XpNv2aJcVlfAt4gOOYCMYofdIn3X8ZMQ1aAZI1wocyIUXIuEktYLs8Wq5M9RdpCIW7v2/M2+Opyqchx+EimTw56t+bQqq7JRBMIlXVeWbAXVHZAQT607so3l8uwYVHxOjfuO6vMRhA5aaB83Lhc4WFJPaXuKI8YYXyVcRXQ0khZ+KaLxIlN0X3tRtHGQfNSDsEcTmUBE+6EbbDjJrhN+dzQUgbYcX2p8IRLWpKesTW8TCSTNcFDvRhuZ1B7ayxBnlmdrQ+d
 5/DkXaLP
 Z63/770DDketVlDXvOT1Xi/dCSYUuKgnYgvchRMxiUYGEGGweyORsUkGW3TLcGMlPDK+nFQzJZWjB3V7BsOVHluAP908oelqYdW5Gr4nDtl5jBRukJycL8gSsmbfYKVWs+jfxJVUk2DPXJeg2tcEJHEd6xU2LC4r4ugsoAwEeaO7Bo7bimsan4Uj3QtWutJT+vKN7WkAH9ll+qs0tqzxZ7MvUOukc39Xqi1w1kx/OP6pAnUWl8CVO3jdjhrFOLi0uXy5Et/FwdDE8TdHqb8+Z8RBqHe5YdKy4abDdhV9qOOoYO+2jjlUxzYAGvgg+6TbSNKIqAV+7d6MgCd3CcFcj2bbzbHTYqSwth/ic9a8Zf35O6HxRXoESQf09PHS40E5FkskTSbYf21Vxp67EahuwgZAai+OwdmN06GgAc9dNPSinBzbiMJOOWhiuYT7Fj4P8QhnN7Jqt2Y7v8eaXTYNECBT70fzMbjsJuhPspFFcFxvyMJAlNR1P//Akz00Hkla9GwhGAYUFEUdTbQZxUSLHeEglE7UcTUgoxfNI5OYHyVZhYjHJIVqXiOQaIaDfDTHEOGpO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 12:23=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Thu, Sep 10, 2026 at 3:57=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 9/8/26 18:45, Nhat Pham wrote:
> > > On Mon, Sep 7, 2026 at 4:30=E2=80=AFAM David Hildenbrand (Arm) <david=
@kernel.org> wrote:
> > >>
> > >> On 9/4/26 23:14, Nhat Pham wrote:
> > >>
> > >> Hi,
> > >>
> > >>> To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap=
 folks -
> > >>> I need some help here.
> > >>
> > >> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we =
have quite
> > >> some swap experts around :)
> > >>
> > >> Reading below, I do wonder if the swap subsystem needs some more coo=
rdination
> > >> and collaboration?
> > >>
> > >> For example, maybe having bi-weekly/monthly meetings to get everybod=
y aligned
> > >> and uptodate could be something reasonable?
> > >>
> > >> This approach has proven fairly helpful in areas where (1) multiple =
companies
> > >> are involved (2) many concurrent development is happening, and (3) p=
eople have
> > >> different priorities and requirements.
> > >>
> > >> Is there already something like that to organize development? Should=
 we get
> > >> started with that?
> > >
> > > Hi David!
> >
> > Hi!
> >
> > >
> > > Thank you for your suggestions :) More collaboration and communicatio=
n
> > > is definitely needed here. Conference is a good place for this, but
> > > it's not something we can do very frequently, and many folks could no=
t
> > > attend (visa issues, etc.).
> >
> > Right, and conferences usually don't have the capacity to squeeze too m=
any
> > swap-related topics in, so it would have to be side discussions or BOFs=
.
> >
> > >
> > > A bi-weekly/monthly series of meetings sound very appealing. Swap
> > > contributors are very spread out (China, NorAm, Europe, etc.), so
> > > coordination will be tricky, but let us figure out something.
> >
> > Yes, that's an issue. I'd suggest swap maintainers take care of that if=
 they
> > agree. I could try as well, but it's rather tricky right now on my end =
...
> >
> > As an alternative, we could also use on/two/ ... slots in the bi-weekly=
 MM
> > alignment session to talk about swap. (I'd be happy to learn more about=
 all this
> > as well)
>
> That's awesome! Thanks for the offer David - I think MM alignment is at 9=
AM
> PDT Wednesday, usually right? That works for me of course, but Baoquan
> and Kairui (and other swap folks) - would this time be convenient for
> you?
>

Thanks for setting this up!

Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
UTC+8 folks.

The time is still fine for me, though, I tend to stay up quite late
anyway ;) so that time works fine on my end if the slot is fixed.

Is there a calendar invite or something, please send me one, I'm happy
to do a swap sync discussion there.

