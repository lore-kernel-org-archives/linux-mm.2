Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A445DCD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 05:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E395D6B008C; Mon, 15 Jun 2026 01:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9F16B0092; Mon, 15 Jun 2026 01:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8A06B0093; Mon, 15 Jun 2026 01:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC4336B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:06:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66D791A08F0
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:06:33 +0000 (UTC)
X-FDA: 84880961466.10.EA3CA2B
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 71AD240002
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:06:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QxkkoeWG;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781499991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jk7xxbhVE56zG/uWPAGorH8GgI9c7exGNGP42BIvXVw=;
	b=eOBE2Q77ZjmS7VzKYREIEaxTM3u8XMj1RJUePdbivDavd26VtOn7GmpIPhdtk66z5n645v
	c4qcLSgVxWsxnmKpHwMNK/TljGyQD6OXxtHitStkUD/ceyr8BIqHSb0F0yedKTSfnLRONu
	wtXEkUUuVll/c/J5Oim1EA8pa+d4AuU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781499991;
	b=7nNIsSQ2Y0pyPe4i6OuN9sCCfiMCL8PAULqGgIT0a5nWRaLkyoHaV+xUO5SqfYwBR/Xm5i
	wJmTZpNLwm9VHSrCC5I1FQQsmNzQ9XIIM2IiGTLWvJfUjPXz3/Rkmp8Ab1aNdkgE6dhbNr
	jOqB/FAFUxYxWCj0lkvhXchUsNvsH8Q=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QxkkoeWG;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51765531803so862481cf.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:06:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781499990; cv=none;
        d=google.com; s=arc-20240605;
        b=dOMSTLQL9x6WMyzMKL2hx6A0CxuPNiynDot1W5WeN4zJd7PcLhrh11Y7HvIv4xZt+r
         1gF4F439iub1MsQdcvoSt1n2sfXlrNjIRLzVjI6Oh3goEVY/t4Hh03kiESijKs2z9bFO
         UWpiuP3VYOv343Si9Zg58Ty87RP1OcOLmp3+aBYKaa1jGLCOoc1Bug4sTwV0x/8AcWe9
         jBu4GFnRvQKf/k9igjTBg5bA97hz3u0y1gUawub5F0botNKjWy3aNYM0n8rDA5XYH1Db
         70VNHXni+L7uQ3qPp24/5TcHwBgUmzKuN9mSp9VFThuQtAd1aMTK3OtorQXjQ8WH+pa7
         0JmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jk7xxbhVE56zG/uWPAGorH8GgI9c7exGNGP42BIvXVw=;
        fh=/2dtVPrYxZQGI0A2NsKZ1RK9MBptRu9Td8P9Icrzze4=;
        b=LVYwlsIHZj1w3VdZicL+8w3QAjsUzVkb/lA1w6xQ39Q2Uw7Nw4GXiLvB0Xgd/bhZrQ
         BCnF48a8r7fZos27weTQR7EiQWFKi6hd63K32wfKYqQidU7qfcaMk2z1jG6EDvqKIjUj
         quBlBiDY8XJ5oj3gis/4+nocthKb6mJs8O1FMCEJf247Cf2UxZqRP2eO5zaI8XAwoJl7
         tyRlVcGjKRx3wgmRnjCMKIytIKrzWZazP7My7SU8stRr7Irrap/omGu3g2jlFZ/XQqSQ
         yVNn+8a9u8bVVFyQ1laFDytIBdS1mIx6Q5j45uGe8DkXUwx9AdBCBDEK+aIoTJH0LeW7
         rjdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781499990; x=1782104790; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jk7xxbhVE56zG/uWPAGorH8GgI9c7exGNGP42BIvXVw=;
        b=QxkkoeWGriqep0nPsXpGwgKnRuDQAVRPv4cCjQ/z+QvdlGgrUIE0cFF9EfMdoPr+wQ
         QytPFOxsuIH5XMARAF2N3VoNlL+bzzi3yJjXY/iULSY5i+RFxRjCOqhepxZJmep/mNSC
         5O4iZgPpFzHDkk59G3FZf7VOUyGuX8XPwH1Orp/bC0zsoV57msEfxDRNykttioqAiCMY
         cEkt9TnDaMDrCCPGTPYZoO/wZg2c+YSZ7lOYR5Oln1J2r1xli4IMCk0hiXv0/lTErm0c
         8+PFkh63fmYwZYrmO94VvPINwq9oxmOj1EoCGCF6++3TxCaUwvV2nFUanwec3m67ublg
         hC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781499990; x=1782104790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jk7xxbhVE56zG/uWPAGorH8GgI9c7exGNGP42BIvXVw=;
        b=aB/762HhafkVrjFiKNTsBsq6L+gwnUOJ4O8xi8FnVKDctsT8rmn15YwhZ3X+9yotZm
         h0QbrQz0jgE8q9x6Um4Dat8iPL8kz8VyfYBXX0uq8Hey2fqgWOxB3ook/73C9CQQEoMO
         ZPjeCnipgph7v5dnBlDwEEYH58hzTGjuX6OkIACA9neE8RRf8WsA5JsNp7smzmdFqJJW
         G4iDVo2La9E1GrH9N8fbl9vOpvuTQDxVqqjzFCw3IMvXeNJoO5fGopCM4Muu+FXEP3uq
         qHbGa6IiA+yDyTsd84LspcL8Lwk5AeTrrsWWMW5dLvpjCf+uLTPw921bxSedzdAVd1d1
         IWBw==
X-Forwarded-Encrypted: i=1; AFNElJ80HCYsg03ZczWoGlaIJGpixTTdTb3in7Rouvh3pXTVNYyTrMWJLkqynxd7FkzfOnXLzd5OWe+Z0w==@kvack.org
X-Gm-Message-State: AOJu0Yw9s5f6kEku31/hl4z6e0c4zmaA+ynbArVvoOafTaxKW8mdcz3j
	THJT9yoEvkyFTFNx89Ma3S2Z/3nAIYaB/zP1WOkXLOk8sC0VZfr13r3LDSx6leF/i6wF5Tf1mgd
	nPtQ656r1W+wd/ktfGCrcXijGi8uFaCmN9K3TvQSP
X-Gm-Gg: Acq92OEIfr3DbGm2ZmPLO1CWLlRjZK9lORz06IPjvvNvJlxKFDnhc//0VGw6rrzposE
	gbE/V5AFyHHBmoEDFZIO7Sxj8MG9jZ/jjir+iYZrkGapO9UAgNj+vnF5XumV5xv3QwBv8i2eW5r
	TI96vA73ykoKu2YY+vtUNbm1k6dO6URi6vu9kwiT1uSnjXTGtvgyLY429OxgfX5i0/zHnxMRc+O
	SbZ0QyvE7Hp/b3+zjK6ajj4FxPJUwdRBarEHOlSVG4R1p5oEcYnC4nRNiHJ+qOikkzpgDT4xCTX
	hfQNew==
X-Received: by 2002:a05:622a:258f:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-519548691ebmr14774511cf.0.1781499989938; Sun, 14 Jun 2026
 22:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-13-7190909db118@kernel.org> <aiuthBHdDb0CNs3n@fedora>
In-Reply-To: <aiuthBHdDb0CNs3n@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 22:06:19 -0700
X-Gm-Features: AVVi8CdcidaJaOvFORpuIYafyUSQzk1GYFvijlb7jrAGXeA35XFZPKAIkQsB0og
Message-ID: <CAJuCfpFQU=n16wZLVrJw-VG6hZzHo=bOtmPtCGGZrNxnwTj3rA@mail.gmail.com>
Subject: Re: [PATCH v2 13/16] mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN
 for kmalloc_nolock()
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 71AD240002
X-Rspam-User: 
X-Stat-Signature: 6hwqd6f1dfcxbq4g8s6csj9pm4cxoxgx
X-Rspamd-Server: rspam08
X-HE-Tag: 1781499991-352134
X-HE-Meta: U2FsdGVkX19f9rEextgZN4aCl8oF6yyos5LO/TFpewZ3vmgOh6sj2z8CamEOGy+2ExAU49+EGzHizhJOKEOiZPRAH+/tJfNXSspHPKjaxgMyvhiCHnBGWqPMLshfmcVbWAfpAw1d7jTXW8JVqYYwW0N7fecYMgs2FUJOaiK3/0X47MhRKEOOorJobe7v7Swy9quMdRZtEbWLjs5kXk9exHcG6pIQixBBSjZqus2fQEYlRWdSxLIg8GUnSsYFfifIsd6EHQqDbzV9Y5JpM0eohFhWMpauBtcqzGFUPkIf9i15naWgPhcDU01cFf6ftGfdY5JwdHh1aWrtHr2j2pMLJ0SuZPKiIAZSAdDtwA0Kek81V+dSIwX8++47+3m4XlaQn7zF7zwrs18PhHfUtXNiu8UwwYFNCl8EF1r8oo9iMZ15QmaCe2VKdMlaQ5UidZVJEufYVErcndwFdObBDxaWmMJ7KXlRHnAh0Emho69Qvm/9F43xbY6OyFuj1dddqxp8/FMV/S9Cq454bEiauoIqWMnwYj4DvXpl/svArBmjzbhNEkPJiMN2kiUqVhyQ7/Lyks0Zu4goePl1Hp6JKlGJWSZyxDb7qyFEPlcuY3PiS/TygEEAalaWiNkAhXxzlUt/rrvaZO+HUDnavaQL1ygHKIgMj9h+e5HpN95c2aedKiOUoTwDCt2JGPhuB/OLGS9Luag5sCD/R/xGeI2pZYRne5Gb8TqCnYRfNWMolq9dYoP22KgqI/ZrpuQFt/L8XZv1dE+/F6DF7CG6GEmh9RfKqITorsIefMZkIjS/WSvYIlA0bAor4teXDnv4pCZRCeYwDLN8qupN1GCzfUktBoLnkZCtjOKz4G5tDnzTloVH/ZtRP57WBNdkPaNa4esT494FhdHsrJEd228agICScY8YyWOdUQgXI9A0pjpLme2vglRW74r74weEq+wE2Dl2GQ5sFj6F1qGb9W3EYD6hY3T
 16fhqsp0
 k9Yc4cDwTPetaUs4Xhsg5Zg14ahiT6GAXccw/tvl7Kn/j+tUMHj0X774ffJ6GUeeIbHT09PBW/2TmHqqev/hOaV7gP9ECFg9I6gUY5baN++NeLiaiWNPboI5PPYuAI1ThFE1xuBPJegn2FvaZKelyHb1PGsjqRIYkD2rYI4VpSHSRU+K8Vz+4lQlGjN0I+q22MMmv9ZJuMwYf95PWGmzg3d2ew5jCDaneeAs3745Vb2ElNIiFcHXQoi7HQEqOo/iQD0u1ffPLYv6xgDIVkU95YALcz0SOBjUNmfWiQnSskaP1LS9akjQ6gHg8q97xfRTtYkvP2lqnKrNxOPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 11:57=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
>
> On Wed, Jun 10, 2026 at 05:40:15PM +0200, Vlastimil Babka (SUSE) wrote:
> > The two flags are added internally so there's no point for warning if
> > they are passed by the caller as well, so allow them. This will allow
> > simplifying obj_ext allocation under kmalloc_nolock().
> >
> > Also it's not necessary to have the extra alloc_gfp variable for adding
> > the two flags. The original gfp_flags parameter is not used anywhere
> > except for the warning. So remove alloc_gfp and directly modify and use
> > gfp_flags everywhere.
> >
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> LGTM
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao

