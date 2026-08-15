Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24071C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 11:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C656B0373; Sat, 15 Aug 2026 07:53:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD976B0375; Sat, 15 Aug 2026 07:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4726B0376; Sat, 15 Aug 2026 07:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A44C6B0373
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 07:53:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07C33120352
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 11:53:50 +0000 (UTC)
X-FDA: 85103344620.04.CAD9313
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 07ABE40004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 11:53:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786794828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRnUikHtPRLrUkl1kAqi7AEtp2f5rRbtemimaKve3k0=;
	b=KGy4p0sCc0IgHruwn4ZRDIoCO6Z90N4oij5DMImR2mCt0IhBxEje/vOUmnqq1K0wtoz3R6
	N5N72ZmQ51iEFC42tSYsvaTGHZhi3s5A+VSkCxXW9W5HGri5YDYIFRTA24EuqAVTziNItc
	To/FnfwjZMhBjbYH2+fRkuN24rh4P/k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786794828;
	b=CCQ4pmEISAAIxAys4YwgQvdECFhIBUDVQHcQMaLy67iZLsEF9ghr5uXplyMfSozeIFMtPq
	QUA7gZ7gGW332sNK5f08pqoiTvbrbj0TtxC7tNosSqv+4WSTP0ZE9YgtUy1tRJPs3MhisZ
	M7molvVQ0NH0SmQOgedSb3DOuBxks70=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5bf9506704fso556291e0c.2
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786794827; x=1787399627;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RRnUikHtPRLrUkl1kAqi7AEtp2f5rRbtemimaKve3k0=;
        b=Y+FKnxF0uaSJdjCLuzlLCKbx8YfeS08kvnrnjMylw2cgqY0jqQuaMcCZei5U2Qr/kn
         /wdFPDATZ3r+PLc305jfcX6PDsW7oUGSCndHeUrlDy+P3SeX1zAiruXdkR8q2W3Cjgua
         2ndo1auDroZlk1PQ4OhzO01Tw7dIINJ7tF2nmglh/Bic/ow3yrCC2z83YxI/Csjsbe8I
         EsyXuKmr9vAb/3PLUaUnsM7jEGhMat71dRyhITwb0lkrOJj3Oco8vh2paPcaaKe06dEu
         cmR4b7NLQdki5CnbjDfRV+FYPpRArnv3+YanDZFQYn1S2xRokTUijtZuQ3BqEY+WIxvU
         +43Q==
X-Forwarded-Encrypted: i=1; AHgh+RqDYVRK4j7nmHVkUIIuT9p5Z4zPHVX8xaz76nSM3pKON0ffnvdWA2tEsRd6ZRAai1T70FguUQBN9w==@kvack.org
X-Gm-Message-State: AOJu0Yzv/01A7xuceP5e+zHSRGHbcrtl/F3VR+9OXC8UzK7rxmuQvi/v
	1EN4ts33RtvLDiyUrFKxo3MXblsv7ky6O9hMAs5nAEzU1pH1h5yEjluyhUSmGE2J5mM=
X-Gm-Gg: AR+sD10zFXeYoD6g9FaSWreEb4yMuLIg7w8/+xuStA+n3g6z7wShZ84cKMZHXFKahGY
	L7ZP6OdndFWFn4zYmVYGM3yVmloma+gpipWJkBUIqNon+C10QYM7ZpH1brjUUFpznWtFHvx2n/p
	yv1oo7ItM3A3IMwdRVZmV9aRwhesKPf4JkotUTvE4FGvsg5NClIE7K2Tcq+/8XyFw/6Ig+zsa8M
	COpGTGimrCEpMC4W/fLdQiTm59I0Tu/t3fe5/fwFs4uW7UEyuCGopIFzmieIKWBKGBGTSIVChHY
	Ufg5KorSkxRMuN+AAY7e8wuI/EySPiAojHwUI7+R4mps7PqimQKR1CqgsRMwIlTE+EHtaSkd8Je
	jOzikTSX8oLWgo9sbAV5xf2J5LvmYZfsnPFGkBfzjteqZr5IQy25hRAtryZkj/Z3LISl6XB9kGb
	SqGs7nec2TJqXioJnSG+F/ojN7keVe09TRvFKWybaKcxIAVRry585UlPFNH+zqWx9CQV6F6yKmL
	xb2c0xRM1MxfMbcMScHhWFVM1V5E+FaoxKo
X-Received: by 2002:a05:6122:1d10:b0:5a2:5c65:850f with SMTP id 71dfb90a1353d-5c591ef0bb7mr2427084e0c.10.1786794827058;
        Sat, 15 Aug 2026 04:53:47 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c597c095a1sm1737225e0c.17.2026.08.15.04.53.46
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 04:53:46 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-758caf52714so502488137.0
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:53:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqRKWNcsGyhATSLoUI7pzOczTisum1hszIIVi0NvTMqBxC0qXM43IJU0LsNHcRHOfYXOFEKkHKmqA==@kvack.org
X-Received: by 2002:a05:6102:3308:b0:76b:12e9:a442 with SMTP id
 ada2fe7eead31-76f2a6dcdc8mr2044117137.1.1786794826214; Sat, 15 Aug 2026
 04:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260813063401.1786548-1-thehajime@gmail.com> <an74JAGcEuHXxr5G@lucifer>
 <m233wgqqvr.wl-thehajime@gmail.com>
In-Reply-To: <m233wgqqvr.wl-thehajime@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 15 Aug 2026 13:53:35 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW8VFF7MuK6Mf0=np0AO_GLzPKCoPDw=aNS0P4waMXKOA@mail.gmail.com>
X-Gm-Features: AcwNN1W6JiZ3yazXDq3pLbylpIa1-sv7QD-y07vhhRYErQ27D6A2i5Nfc74pNsQ
Message-ID: <CAMuHMdW8VFF7MuK6Mf0=np0AO_GLzPKCoPDw=aNS0P4waMXKOA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] fix nommu mmap and add nommu kselftests
To: Hajime Tazaki <thehajime@gmail.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, daniel@thingy.jp
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: mq3pn8oykqyhyisk4sjd3axedbmb1nsg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07ABE40004
X-HE-Tag: 1786794827-422004
X-HE-Meta: U2FsdGVkX18QChcFMFZ3kaiN/O9fOFZ0HlNAA4Ndgsgcz+cqDexDGXb3C5bo+hyux5UxT5V3UFgYesVJENdnVmjLOt3sIa+BKTePzg2u94SU6IkyjgYGubbcO2dW5T0tLVfdn5cGq5c7NZQwrSV1TiVFiMgXDYmUwZkZYXtcSLZfuNhw2wg38qEhZC8xMLh52fb53zTnfkDRqSjy11ZNdyiH7hx4T1OuXp6fExKUKPBKQ1ACB5xZmsTzULPCjAVc1wBWP91M4JWGiNnnRrXsVzOCX9AtoXNO4o0aN+bx3XmsZuu/t3zEpvr4B9mukADhDUwTRrG88F0fYWcR3cLM2k4dStGkm5t1SZlCN+V4wBZxsbVqJiFposlnDXx8pvQo8WnZCvAP4KY7hUeSvXdjOx5rnC0Y1ztKaL+B1yyYrEQ7WGyWm6mAlYIreOQpdX2AMEV0yj/YZJoBhur195c4MYh0o1DHLnXlUDXyDVYzJSwH4I7mlZ+FE4NCeFWsNivoQQkYqtsaQWJqJrZe/CHWZ1ReKi+NhCX9N9Zek66473ZackkJuK0jMLVxhGe6JwCBzI/m0tpCJJeR9/2NtuclQrn98l5IE4pftBlhvPLqMsPir2nRBU78FO7MhLtcQE3LjLpXUzMCDUiXuXmRgV5hOMj+f128pSdIz4OyiQJAa/JK6WxvBbvWUPWprxMCiVhFQmTqbC/+QWbjlNUnsSF9FT8+op+0uBWRNcGQoQX7eUc9q4GuyBsktU8lAxzksiEFAwMi90D2RA6lvxuau3zMY4DG+7MV2DTVYHI4FxHqWSwoQUSoIF2eY4v9U06BEUx5EbMs42gppHCUPOPvQ2f8Ne+5b+Hh3ewz/UJPnm02qRa3Bq8xXsbBy43iGU8RPuP4/9d+/gosuqjNx4/mE6SMEvMJaBjFIwJn1ygGC+K+AUpfgKykWzXtYtCkTnaKixauGQq94SHxpt6dhXNzBpp
 xUdsoXFH
 zyITFdbNX6BQecXkE7kDh6t2mOky8LhZn7nWwV2pTlEJg/EoyPhMJGYJRF+sZ8XHsEK7YPQZDTfGCPE5mISu8LIjCcI+wtlVaX9upGku6m2Er6pB4HmxeCn8lt4yt+h2CV5BReepCVQuIvt+xPTR3vTIoBIGOawGuXFHa/gLjX714rWemuxvIk/ij6Cin5kFgR63qK8LG4zT8QaTtFCBvkkjWUR1knTKNAkD+T7nGWnXR7Yz/FBqeVFY8MnsKaDw7pwj7omrgGBrAwpHj65IpmNw525DZdMA3Nn29kcfd4Db/nHb0DnAZ9p6GDdm8t6R2Fg3U1u8qKt4C0HLb4zhnsloqNpQZZbfkgtrCU1qtL9aGHjxo8LfXLFP43U4XZ/zILfdcAJqoOh/WMuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hajime,

On Sat, 15 Aug 2026 at 00:28, Hajime Tazaki <thehajime@gmail.com> wrote:
> On Fri, 14 Aug 2026 20:24:57 +0900,
> Lorenzo Stoakes (ARM) wrote:
> > vfork() has entirely different semantics than fork() and we need to assert
> > fork() behaviour, not vfork() behaviour.
> >
> > (Honestly it's completely bizarre that we support a version of linux that
> > can't fork() in 2026)
>
> I understand your concern on fork-less kernel.
>
> I am aware of some of experimental work which try to introduce fork(2)
> (or alike) features into nommu (or alike) kernels (links below).  some
> of them require a CPU features, some of them gave up CoW, etc.  I
> haven't really look into details but if these effort contain a
> meaningful insight to implement in Linux mainline, I would spend more
> time to study these in order to fill the current gaps between current
> MMU and !MMU.

You could implement fork(), if you teach the userspace compiler to do
all addressing relative to a few base registers (PC-relative for text,
other bases for data, bss, stack, and heap).  Then fork() becomes an
(expensive) copy of all but read-only text, and adjusting the base
registers.

Of course there would still be no memory protection, so user space
can still do whatever it wants...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

