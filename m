Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A0A5CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDBEC8E000D; Mon,  8 Sep 2025 13:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C4F8E0001; Mon,  8 Sep 2025 13:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D540F8E000D; Mon,  8 Sep 2025 13:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF5568E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:11:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59BA4139CF9
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:44 +0000 (UTC)
X-FDA: 83866724928.22.E22B6C9
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D7244000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:11:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mg2T+5gE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757351502; a=rsa-sha256;
	cv=none;
	b=zsNLSaM/gWge127R7wEw0qgBhW72VJdnRQRSuvMP0AovsZOrwrsv5/jjDMA3fStKGjC0jD
	GL/zzn1H3KSOC9SHFNdcrxx2PqTNlKQ61Wt8lB7ojpTqHw74D5pPwIVE+b8fz78QKK+N+E
	YcWdNDjNfC3ZdRNcgWIDrgwuX+UjM+0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mg2T+5gE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757351502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1/Xo26IpLOmm9VGHwt34+har9g1uHoZGkWPqsB7phg=;
	b=mFOMKCd4nY/nFtYwoQTWB7MYyQe/5bLZlfKBFZd1aQhGn+rRvalbAeK08s7g6Ie7fucgd8
	oCDLxC5mDaHRETEobXxSDmzWVL45lZvhiOZr2Vy7yVgIUScbzEKXjqfmJlqMgCnD/EZ4wh
	GHnSmd4AH8NqtiXQ5jJyzWzM2RF7Y/I=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3d1bf79d7acso2802444f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 10:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757351501; x=1757956301; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I1/Xo26IpLOmm9VGHwt34+har9g1uHoZGkWPqsB7phg=;
        b=mg2T+5gEe2Si/WcX4oKPr9JFkb+yvsPvEgpjLXtbm9sADyW9VBl1ZwPAIfzda0/EYf
         Zu+RxfrdEAbxFDMkt9O9694ehJ6euvcbl745zwX1Jk/OhK6syRHDGI+y6piWDe6ov14Z
         4vvQTg7GTOrAo3puFKcbY9DmlMrSSKVsloL3wk8CXF227nET+FBpY+7WgCV2rS6lhdtD
         NMITVCVq00VbJdXdkilMiS4KkUUS5/2nxaAsbeOJCNewwcCEp293Gfvo1axuMI/TNaTf
         Ce/Kqb3or/hc0fA5MddR8+lFD1Fc9xB8uXkF2VNoCVyuXPGHo/hwGcd9bnWxxwTqdsB6
         gZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757351501; x=1757956301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I1/Xo26IpLOmm9VGHwt34+har9g1uHoZGkWPqsB7phg=;
        b=IYM05I9irqxDYbpIn0RSGtdAsncqmbfJZ2QpT0ft4qU66JB2HkjcH1/ijq0l2GQOEZ
         C3+9iQsChCKSGM6GuaCc+4h9h4yEFYIuyIsq431CQJSMa09Wh/vUznD9Mk0JgS345AYh
         d3JcHVmOLysituS/PKHBkDUB4ja2iJN/QCQ6YGr8vubfj+taJNOXOCEMIk5bpesHyW96
         Sv51vTiqhO08yMx8W15TLgoHj04+dRUxXgPPociWj2H4IOCRrTcXlQSmCEocf4LB6w+H
         kSdTNhfsEOPIUbFu6twj2xvpoDSCaRocpW6bF93a+7cKoFFhYOvLD8R9N/K2zuUrLlGM
         7r9g==
X-Forwarded-Encrypted: i=1; AJvYcCXqLJZ8usqv0qd8XgOItQ0ObyVLnVEMliWFql3SwmmS7Lla+W7giGD+JdxzzNK56JR9hbXkkX2BkA==@kvack.org
X-Gm-Message-State: AOJu0Yw1IOipg8HQpszAZ23fAiNnNCbSb/N+4ZNNzhSfd8q5AGZeDsut
	b9XjSfYmDy/vUIkAt83rOkZ7VGJEP5rsdePstF6LKHMmiVy1P/4m8+M7mrfnqa2L8bGZGY9Z1Ur
	8OHT1SPTLQHWdVxiL04VT/t19YCiazpg=
X-Gm-Gg: ASbGnctKDTigjWYywULqYLo03qUd3DXLD5FXrexrbX4iBG+5l5fTwM3zA5xzzGXXU6W
	0JfBaID6R6Aa+Y8QueMzJ0++53l90EZ3FmWh0EtUCfsZ4fXsfpDXCvIN6yyJr7idhRTeafgIEX9
	LdS+TzSct3dgRogNZnzBsfI1blrtP0cgzyvgAl5v2wW22ty0BXWpRPjcLBInsq86gbazYWDsPE7
	/WxbGPMdtxMo+Jt7VHNj1wWuYXlP5ev+LgS
X-Google-Smtp-Source: AGHT+IHLSc9z9t6zrJNIia9iqmvjLGG9Y3cJVAfc2BnuuchdOalrLs4aZRfsDiiM6JS6UgJelkC0rFMQMh3PO0dNIHE=
X-Received: by 2002:a05:6000:3113:b0:3dc:1a8c:e878 with SMTP id
 ffacd0b85a97d-3e642cad4b3mr6110427f8f.18.1757351500438; Mon, 08 Sep 2025
 10:11:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <aLtMrlSDP7M5GZ27@google.com> <aL6dBivokIeBApj8@tiehlicka>
In-Reply-To: <aL6dBivokIeBApj8@tiehlicka>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 8 Sep 2025 10:11:29 -0700
X-Gm-Features: AS18NWCPGMAuKGdXbwS4CiI7NiTNAFh-3hy8_bYRFu2qhn-yMLQ9ZTr5pJnwwvw
Message-ID: <CAADnVQLtc+OOQ67AS_1+u-sRmO+bDLWJrrihASXMrDNnvrmNSw@mail.gmail.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
To: Michal Hocko <mhocko@suse.com>
Cc: Peilin Ye <yepeilin@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Meta kernel team <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D7244000F
X-Stat-Signature: yy5pj1tzpjoc9bf33ysbnyh5zfzqj5qd
X-Rspam-User: 
X-HE-Tag: 1757351502-348109
X-HE-Meta: U2FsdGVkX1+6YfwOqP93Iu9l1i/HgKP1XXeSzHJXBoKULrKr8IT2IJw+H4p3dRuBNpaGHfGx7e8MirMSrhUeyK61WCRwW+BV2lPFo+vtl9zeT7p4PfRzLU5VKb5ANdFnLv27aYLFhmcRgIyzw75RpU/zAQXE+6oW2LNcYBt8+icQUPTYkG5bNBGOXxIw/07Nq1CNf1lCfMQl5X/SKOhRuX/49EPbBekQtE6epwgIpFJPMOttHd4DaooiQaTLV4eMyEN65/9RfxIlfsVFZn7A+0CMpj5sGEtoC61lNFG5tSX1bM4Oweibcnnroaw0azIrhuQzQlo006HAbX3IRFyECGlMdX69BdKEm1Y+f6i6SZz4wsv7zaPRyP0mZ47J2q/g2PgyJdrIwdRKtIasI5/pOX+dBQfXt1oje77eBjnDAynOKX6lQAnt1sosar/mdyTelhaeg1n313BYTB2+0qATENam3LmhALoa/rDsT9JWp1cHXqlFOdThmyKrlpHutwdcy96edj5/fa366eetOqysK1WlY3PbrTMJON/oYyNIhffIwUkpZX+2Rvla59ZwuLY8tSmAKzakZ7zFwv7aQFJH765iXcSuIaHUqDEVB838KhINLgSp/QaZouyKWy1z92eUD+TwTJnX80lPwIoY6W2zhMgICU1djISEBHbcLvHcnvrxs19+cLAPr+N8v27ybQeQFFjne11DyvuZTM5+t4aYNQIa6wxu5chxPWaUgN/sIAHgMHbJ+pgNxRHwUEz6Cj/ZIXZaI3Cw7EGiUGAiCuJ9QT6c+9uCnnYRHzXbm3WY46K0xW7isXFgvUu4UBFdBFVArc7hv3CCsNdUZlPXJPTYXlmPhHYa/UTTXgojS4gKfTt85P3NKdfvCnZSd6tOAe09J9spxFaJXY2i2FbCPsZJwrbHAstMp+LZjBZlFv/yCJAkufgXmaKFAaqf7LnmmBVp4Nli0qRP0cFU84lE04O
 fLPRzqoo
 i3Vor4uof4ZvIyGAR2dZnQHdA4ZzUw72Dsi9QsME9FQmPbDM81Jux2/4WBGQRuOkxd469vCCnlHLSASEIJMbmVUFXPPU72ZldEqt9tJo4qnaG8CtZXrC/r91oLlzGCzCy1rSkv4k3+wIJ0Qh2DXdAByME46hlJz3JyfJR5i5s+cVA3vCo9M/RoIhLaiJm8ngm/uC8/AehK7z44md+hgHzDyhbAACmd2cGJmMqKpuMDrhK80vOrPpkviYjZFyohMlI8C2fAVsGhdO0D9DU2zMyyDpaKk8Z6sQ8ZIfEs705vsokNhl2OJXbk8rV+fd5hm8k7NFe8LfIG2B+qC1gQB5RYeySNCL/+XvOKU4O2QEz46UxNvJNW5+0q4XwAnkve+OiBiQeg23uaG5fgzIhwEIaKrrnKsuZb6Z272SmDfaTIeKhTXIax4Vzg8lQw6M2qmQo18xqidTG1zC+I42O27ZNxsIeQvcUFoCW/hltVhB5zibHinm9PFWTBiRro77tO7j++RWXCbYKaoIyprQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 2:08=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Fri 05-09-25 20:48:46, Peilin Ye wrote:
> > On Fri, Sep 05, 2025 at 01:16:06PM -0700, Shakeel Butt wrote:
> > > Generally memcg charging is allowed from all the contexts including N=
MI
> > > where even spinning on spinlock can cause locking issues. However one
> > > call chain was missed during the addition of memcg charging from any
> > > context support. That is try_charge_memcg() -> memcg_memory_event() -=
>
> > > cgroup_file_notify().
> > >
> > > The possible function call tree under cgroup_file_notify() can acquir=
e
> > > many different spin locks in spinning mode. Some of them are
> > > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, le=
t's
> > > just skip cgroup_file_notify() from memcg charging if the context doe=
s
> > > not allow spinning.
> > >
> > > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> >
> > Tested-by: Peilin Ye <yepeilin@google.com>
> >
> > The repro described in [1] no longer triggers locking issues after
> > applying this patch and making __bpf_async_init() use __GFP_HIGH
> > instead of GFP_ATOMIC:
> >
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -1275,7 +1275,7 @@ static int __bpf_async_init(struct bpf_async_kern=
 *async, struct bpf_map *map, u
> >         }
> >
> >         /* allocate hrtimer via map_kmalloc to use memcg accounting */
> > -       cb =3D bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_no=
de);
> > +       cb =3D bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_no=
de);
>
> Why do you need to consume memory reserves? Shouldn't kmalloc_nolock be
> used instead here?

Yes. That's a plan. We'll convert most of bpf allocations to kmalloc_nolock=
()
when it lands.

