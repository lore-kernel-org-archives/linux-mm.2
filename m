Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B06EDC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC75A6B0088; Tue,  1 Sep 2026 19:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EBB6B008A; Tue,  1 Sep 2026 19:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4896B008C; Tue,  1 Sep 2026 19:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8ED996B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:37:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A6AEC0589
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:37:19 +0000 (UTC)
X-FDA: 85166806998.21.C22A0D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31D14140006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:37:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0++MUSg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uycN0jge1thyUm7Z7rd9G0rkfYUWwSL3IX+xY1TgKHA=;
	b=FS2bs1VytLPjXA/J+jBaURCcXZ8JKD3xU0N7l8sNxbOaeIa6nFak7wEQHCbbJGs2pWVzAb
	Bm7FpdQak5+wARyGsOFTfj6c8Z1zlDJi9xbuR4pw25tdgHhwx+Vzijc2oCSm6zDWf59Gfu
	7Ir4C5ZPzgC8GHpX1te4/HuPsbnjeKY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305837;
	b=Hxcwu+aiP3YCDD/bH0c2FChTjbbwP54oVOi5u90x2HkWEIuh8Zkdhwbb4MNSJkXyP8xVU5
	jUvHOppZK9nygzESKg6zUSXIe7w6EnLuMwLmmF/gGo80hF3NuT3WU8HfTwscuoVI+1nTd2
	GTMaDSV6EIfGXGAr9XoZPYqSCStmZ50=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0++MUSg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1C23601EF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AE51F00ACA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305836;
	bh=uycN0jge1thyUm7Z7rd9G0rkfYUWwSL3IX+xY1TgKHA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=I0++MUSg5oGjf7KmLlyewaL7U8XCr298s7M8XVZH2qd5tZQJdeEcCjmD0R70nMVw1
	 XpnBOCgjNVSa/KXKgJDv4fV/n2DEDRRMhu28j/kXalJ4d7vjtp/eJB9ye3cGyUYtGL
	 /gp/pDro7lasJQ49tGvTZM2DzP1bdFGhGniNhNmDRRvHAB1cONgOrL19sbpveYgiR3
	 unf40UZTUkA+mIl52OfPl92Zacfm0f0tQlX1gvFJ+Q4CS61HDJQVOPav7G5u1fmonN
	 eQT9RELjt7gT+qrxrjsygadfYkBLuRXOBUaFRLebcKRuePBeBS1EeqMaCle5pIo5qT
	 UlRmcjlaGEmsw==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92edb12cdf2so46601485a.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 16:37:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq0cHi72M2XxruZlm7+lhAGDP9zt7Po3RWXAjbkoPHy0ja2hxoMd1rntVpyAEn909XY/NN81B8pCg==@kvack.org
X-Gm-Message-State: AFuF++kTPu5RNBKWoCMs4jEOEKMZLtPSQ/jfgmE11mlseHo8HGFVNW+E
	EZr1jgnXWYZB+UiPIwmrznmKuCpUdTrxvsUf95b6qMG98Xm4Oxy62Rj0tfz8gKb0YjeoBZzCE4W
	06wSTRbyepqG7wdzLxLGKTSYlkhG0dmo=
X-Received: by 2002:a05:620a:1a24:b0:939:b99:eec5 with SMTP id
 af79cd13be357-93960ca46admr97554285a.1.1788305835695; Tue, 01 Sep 2026
 16:37:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-2-hebaoquan@kylinos.cn> <CAGsJ_4x=sZcc0+wkAbS02YJUdpzxTTpozh7o7CSozWL=1K0rNw@mail.gmail.com>
 <apaKQvME_y3K2bQx@fedora>
In-Reply-To: <apaKQvME_y3K2bQx@fedora>
From: Barry Song <baohua@kernel.org>
Date: Wed, 2 Sep 2026 07:37:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xZuHAD0NX5Ren2hAJP_Vz=CGc+pbQ4Z3Y1dvOFS8RDwA@mail.gmail.com>
X-Gm-Features: AcwNN1XdmCBLhU1TUhp5c7JLrJYKh5QqQqgDy86wSbx3fMzDrLUaBjjGzwETQDo
Message-ID: <CAGsJ_4xZuHAD0NX5Ren2hAJP_Vz=CGc+pbQ4Z3Y1dvOFS8RDwA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 31D14140006
X-Stat-Signature: zpboup574roieupb3fsojr88tbo7smte
X-Rspam-User: 
X-HE-Tag: 1788305837-115361
X-HE-Meta: U2FsdGVkX19OBtk2mL/G2VM0Q9cV4iVvYhGyYJkDd5TWEFdR0w38wE3j5SV/mspjbBA9L+uoPkLDoPGjrR2NI09AnV2KXWOAf2U9/OOOVBF6AUpTnJBPnzlpVM1onM9ELQyVm0zZ6vuOy27qFrt5INirzQdHqRPII+ucRKqUxk+6+K6JRQaqbqmG5jYGeRC1ntR/RD+zV4xJp4AxIz8LJL4SWBMfR6+arJF2wkW4/9vilFkVmTBrLyFk5Kn6s743Ab4En4S4uEtIyO9ihfO/IclCJGZFC8fHHJaKV5KwY00Bysgk+YcyCxcFGpexuI8oIgA9e+89Av/nv32up6kWZbrlActOhnw0MEmkRQgzSfsmyRCMQe0+bUpt1APjirGLb+t7ilpMHZyKfEDo3LhFR2OMIBT4muH4M4a1O2MXsAzE8Ec5lYtOefLsgZvmRZpewsqSiEsEwCySWMkJwChcjzLZPaI4GeiflKPKaUQX2MjhVT8nP59CYiP5vOLKcaPKQnGzWC39gqTRShG0k6lXcQ8M5/7sgEle6x9EkhtioHbU6aU0O5ljYDmvSsd2ugX2c0V/B12tsyRO6WcBMQX4MteKBzDJGqdTI1fj7loe4x+MbmOYfh1+SwO4vt85ZX7gt8Zu8WFe1fnu4iKFjhWN48ClgPu9/KjA4yloDh1HCMr39FegHsAagkBgMcpAEeuhF5FUxThm7XaxZbb6q+RxgpGLU8+EUQjDjBaEAQxgk26oCBmCOFy3Fc7kXOGkKL/1K2RbogTpAsiNecvHtdf/IckXLrrq6v10hY/Fea9df7GCdtj7/CJjwMZP9DUP1mk+xq6qes+8yaabkR7tIa4I5VAI0rxVGlfnofqgmBPQeN2fku6d5i5pxAXCSCQTcPRZk5krCJsn3kGZV1LbpbEFUkitcQ9p6s7Hj8Q3rYDXvrgvy05g5+q3Zv4GHOTr5P/1xHqi2fYJ5l3zHrfnHzS
 FINNAxts
 eNMcZIWUxDd4RoRPGMxFzUaCJ2pCF7/uWCafmhhNiSeO1DsKvVxsI1fbzrcJF53PBnQRcazotMuoNzGiqcdsHRLWjQYFhg41ijiZ8+kcnDn1XKEMSYajvbFyUeV2q8DPxHhvbk9tiIV8M91YdPuBIB3qJbWfLQs5w0LjxXH9A487WvfaFrdyacexLQZRMThXBGeoducGN8t1pLT3Am2Gaj5/gY3FPwVZHWGgkKQMzenX/ahs8plOUTbQ4DQS2nJQX5OmSioWOcPbh9sYJUjZQBNApfeOBwNyy+f7fs9mwEqioCfxDdIzgzBu1La5Ko2CgQOYGdZepA+Dw0ubni7mjr95DcmaY2hG/zSZ2UYhwtSKLLdvJstd6SOubHVwM0jvCbFpZns3A8jUZPII=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 4:18=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> On 09/01/26 at 03:11pm, Barry Song wrote:
> > On Tue, Sep 1, 2026 at 2:38=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn=
> wrote:
> > >
> > > Add per-walk counters to measure empty aging walks which traverse
> > > an mm's page tables but find no folio for the current lruvec (node+me=
mcg).
> > > These are common on multi-NUMA node systems because lru_gen_use_mm() =
marks
> > > an mm for all nodes at every context switch.
> > >
> > > New counters (accumulated in mm_state->stats[]):
> > >
> > >   MM_LEAF_ASSOCIATED   - leaf entries whose folio is in this lruvec
> > >   MM_WALK_TOTAL        - page-table walks completed
> > >   MM_WALK_EMPTY        - walks that found no folio in this lruvec
> > >   MM_LEAF_EMPTY_WALKS  - leaf entries scanned during empty walks
> > >
> > > A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, an=
d the
> > > debugfs lru_gen output ("TYFALWEE") exposes the new counters.
> > >
> > > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > > ---
> > [...]
> > >
> > > @@ -4109,8 +4113,28 @@ static bool try_to_inc_max_seq(struct lruvec *=
lruvec, unsigned long seq,
> > >
> > >         do {
> > >                 success =3D iterate_mm_list(walk, &mm);
> > > -               if (mm)
> > > +               if (mm) {
> > > +                       bool empty =3D false;
> > > +
> > >                         walk_mm(mm, walk);
> > > +                       /*
> > > +                        * A walk that traversed page tables but foun=
d no folio
> > > +                        * belonging to this lruvec (node+memcg) is p=
ure waste.
> > > +                        */
> > > +                       if (walk->mm_stats[MM_LEAF_TOTAL]) {
> > > +                               walk->mm_stats[MM_WALK_TOTAL]++;
> > > +                               if (walk->mm_stats[MM_LEAF_ASSOCIATED=
] =3D=3D 0) {
> > > +                                       walk->mm_stats[MM_WALK_EMPTY]=
++;
> > > +                                       walk->mm_stats[MM_LEAF_EMPTY_=
WALKS] +=3D
> > > +                                               walk->mm_stats[MM_LEA=
F_TOTAL];
> > > +                                       empty =3D true;
> > > +                               }
> > > +                       }
> >
> > Hi Baoquan,
> >
> > Where are we clearing these counters between different
> > mms?
> >
> > It seems the previous mm_stats will affect the next mm
> > if they aren't cleared.
>
> No, they won't. The counters are cleared between mms. iterate_mm_list()
> calls reset_mm_stats() from its "done:" path for every mm. reset_mm_stats=
()
> accumulates walk->mm_stats into the per-hist mm_state->stats[hist] and
> then zeroes walk->mm_stats[i].

You=E2=80=99re right. Sorry for the noise=E2=80=94I missed that part.

Reviewed-by: Barry Song <baohua@kernel.org>

