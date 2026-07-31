Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB639C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0786B0092; Fri, 31 Jul 2026 17:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A710B6B0093; Fri, 31 Jul 2026 17:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939516B0098; Fri, 31 Jul 2026 17:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2036B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:10:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8CD71C00EF
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:10:58 +0000 (UTC)
X-FDA: 85050316596.18.C8541A7
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8D9E840008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:10:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DJaL7r13;
	spf=pass (imf11.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785532256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXBkpWwLqOOcuPQeTS/EgOF0J3OWCX3ewAfZ1D9Jd8s=;
	b=7CB8g5SFgfBZHqD80yImHKp3uiO6r0KnBjEGG5XRxysZjsPki4V7VzZAyFSfcmXu2+xn1J
	D0QLFlKWZSu7OTXuuOa7qzuVEeANC7zqwORhOjj2KMXlsKMJEmAJh/Q4WmJDAfxIySEFBD
	LBud4xbTI0sFlusGXXX9Wmrck06DyFc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785532256;
	b=sQBHJ7r5+u78D16hl0coBngJfmNXzx3QFy9meMRYTWvDqoZDNHXjT7Rzhj4EuSTu8RNg4m
	BiSjdt2yFnEu6w4y3M0Hrbejf6mnFjf7w+Rfkh8zqbT70I3DAsqePt1R9BRkT9RQ0Ipj+9
	cRh3DSNIerHVBJnlfQNw0+pn1HuxhHE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DJaL7r13;
	spf=pass (imf11.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cacef7d299so7295ad.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:10:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785532255; cv=none;
        d=google.com; s=arc-20260327;
        b=FFkbSHmaLL+MLS3kcDntuBY/8R7dNajUc5tNzb++jhaAlxXEyTly92S1I1Py5iNuxh
         mhl5V7NK6qYjYsDiK6KouAQlsbxb9hHlwj/7SzVCdRfqWopxaFrpaOLxKno+9rRS58rm
         JMGMhnCxoCYt/X744wviPx6LnXk2qLfZ61hgM299b1Z27xADk98VKzlCvD+0M5Vw76v1
         SkrfZwY3C74BeiQjOCtvsOidgeWOqx2snYgOR0uETy/FPW/sg4z/+VlJOTxlnCAtkXB7
         dwQmuRU/7z4tKNf3nkAJ4QGiyDclGTtcDLq+r8iutV/8Ygi7LnIlN9cdV12WVxLR1Kap
         Kgvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qXBkpWwLqOOcuPQeTS/EgOF0J3OWCX3ewAfZ1D9Jd8s=;
        fh=0TcALlZv9jiPRfcihQrFMLHAsSfe3pXD5aSVJ5Th9Qk=;
        b=C1tZ5HuFXPwroD2U2DuW/Jq4h8BXIa2tFnGPRMNlO1fvXfXdh4NEAfKh3eOHd1dthf
         lOiviQcja/zcUECMwi2CesLdmd6OHccfKkSt4z7D0s8aYUyBCgYety56Exn98W/0pj6m
         BvMrv00/b8COMLhJY+aKcuwSPLZymOrOhBY1HMLuGJxVtoYByxBd9m0udamXD4LlhjE8
         d054pSLLWvGsGRB7dIKmnwtMxJe/4yF+K6B1HGDOWn7uplXSVWW8E1GKk+7BWztVg04N
         dQoleiEDCn17uGetnqbtKXxZ5rYuVANmtUcnFPM+zy5OvSCndPYPDjVCxCeRJVdSoPtf
         oTNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785532255; x=1786137055; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qXBkpWwLqOOcuPQeTS/EgOF0J3OWCX3ewAfZ1D9Jd8s=;
        b=DJaL7r130KDAJA1eNNAeWnH79tFThOZiSMkvakqscMS/BrK7LaN9+SESRIt5n77oyk
         K7Jqr7GKKFzcJWpjzMDga+lmTALz4vAP0nQNQd1D/5PuhO9Ebk5i/7DPRsgNGQmFTxiW
         cFTmto65t8t/X+cq1xX8iSVhs5D9elmRZN6kiApWf6EWKrXTNcaj7v/8pcdAf0a3Kf2B
         7fnwXRopevcyGSNuOe9qlmSyoRiBXoUpZHifCGI70aKpVTspXFLq3KiTX6iSBIo6Ae57
         PrfZODrItUI4XO4Y+usOE7YSvTOC+byP1SZpGFzqhBsvPtMDZVdsoEv1wLQ+QEeiQDiP
         +KUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785532255; x=1786137055;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qXBkpWwLqOOcuPQeTS/EgOF0J3OWCX3ewAfZ1D9Jd8s=;
        b=c54eXve5xobgLgmfKugrkog4IAxA4MKW6HRQ8rSWm3jodwX75Am8bCycqAwM3ZLzp0
         1M4AQBmVNuFhmA7xCfwdvGXgYG+Fc6pRSDDRx7A+5vSmqlDUXWO/lVxTk5V0ONU4R0IX
         DjmyZ/vzik1y7nH1ib4UJZXQmdZChm2Zg5jD5OrQy9HAEg7ATVqMQBt/UnmTAh2zq5E9
         V/24zCwx0gXkhlqcgkXsP+w1hp+pXNpTN88ZLiK3ZKLZ2gt70J85bE1FCF6PQKiHOHeC
         dL4fYK9YW/M2MTsjLzMx8Gb0xMaeWZ9OSXGvNCLGp/YKTE8zU2syWxP6SWQtskZm0zKz
         ayHQ==
X-Forwarded-Encrypted: i=1; AHgh+RqRNzYDnlEzhz6/+5Qte52CaCv+XMuuncTHiNOHQuzZuPKmH6ps/Nv9U4cIav/pDuUEfEJIzD36aA==@kvack.org
X-Gm-Message-State: AOJu0YwefmvDbwl1RiqDZiCVSmu8psHMnZw3GBY0hUHkmxM0Z3PMcOWa
	bcxkJjdujWErrEVxmOjU+X9LxxTbnMcLAk3844zyZfBHq1XIYVgFAnpae/c6A9gv+5OEjEaJveJ
	qC98NIOkJIYg80E0IeTHgf4PFJICgrfvA0cpxLYFt
X-Gm-Gg: AR+sD11WErcvAqu6oQApfGTsaj4Q1uPewXyIuLYlmySZr1cVn8Pk3Hk7Z2oDK/Ysic2
	RfLaDXkXgCq/ejBgxKriOfJROk1nHd4eD1cDJzo09YO1yhseAJQMdbfZgZispwiMA9dOa2vXlVD
	AqQdRhfPhTnsya/vKwN6IR6AMO+Cs1LrqHYLtV9kajZd4fCXxcI8X6lWhgHACj2VkEcfg2meC5u
	yjshgCSZCpurSRNji3Gd8ybFtqZDovJaV7bvQJeJJhrHmWpun0UaTrQsyVPC7rd4pIcLYR9xq3a
	ZMu/lPF/k8WG/dU38vGBB1ezawxL1cAXHdJ7+C5gTYUDjV+ugFNbhAkz1nb28KQJh8eiMvr7JkL
	yUmkw4Ev7J9CaMTrNR9nQZA==
X-Received: by 2002:a17:902:f549:b0:2ca:e0ff:eaa0 with SMTP id
 d9443c01a7336-2d0546956a9mr1992745ad.2.1785532254523; Fri, 31 Jul 2026
 14:10:54 -0700 (PDT)
MIME-Version: 1.0
References: <0d84763f140ea735d790e0b30a8e954536beb875.1785455267.git.abhishekbapat@google.com>
 <0dcd8c2c-d841-47c2-997a-640d1937a77a@linux.dev> <CAL41Mv49qeLm-MmHtQGFnyzjEsE+8kvOgtMTKpjNAzDWozum2w@mail.gmail.com>
 <CAL41Mv46p9bFhX-UYpZ-jk9g+yQcwtMbcQHGnfwp8rQJzw_FEQ@mail.gmail.com> <CAJuCfpFCs_t4DZA=rdA_a4rL+kJ_tckjQM+9kHUZuLTK6w0WTA@mail.gmail.com>
In-Reply-To: <CAJuCfpFCs_t4DZA=rdA_a4rL+kJ_tckjQM+9kHUZuLTK6w0WTA@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Fri, 31 Jul 2026 14:10:43 -0700
X-Gm-Features: AUfX_myyFogaZa00ZfuqDUr4N5XOVpVs4S_lsW4G9fqofkd3Edo-rrlFhzzzW3g
Message-ID: <CAL41Mv4Bf1WG-yeiZ_DiDm7_eMO_5M0Ta1eivm2HthJUDuUL2Q@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D9E840008
X-Stat-Signature: aqz19try9nhizua374maqcpp3sxa1jsr
X-HE-Tag: 1785532256-916497
X-HE-Meta: U2FsdGVkX1/JgujSYl0KzfC3nv44eD2V6uA/14VKHe04PzZr3yaz80JFfYbiXBgVwbBFSQLqNzeaZlTOJwqg+fkCUA3JHBY1kIGwa3AzcxuTE+T2jHHI9Q1/hGqASdfp+RZ+muQsluE4j4KIFzN3vozfGWCfXcnA/redmIpf6OxHMa/8vjLUk9ZDTRjNUsh0qYOrfFFsUStvbENjQIjnIv2UvsAUkTGyRlYASF04kXUwJujTskFo2Zzix7TN6w2qGAENqgIGBmlxbU22hGHEERxEowdYNKfwn2DFJ027ivXyRpZBurZtsWFulql4nZv/KfuRdhuJc2WbVmOg2jwxWtZksjQTHuZKro7iKkg1AgdBJXm0J+Wx8a3fcdNTjf+RsPkc0C4AZEG4vQNcW12yoNTh6nSk7aOGfqlVSbgSzBAVvEkCaotVA2sHyesNakJWvMKwcbFNT8s1K3RWVNZTtKYJ9FO4O4yMHtTXXeJuQUzEs9nAku9ib+pvLP+9xhejhLTwGuHRMkuRvzl5Ga4DfsuIoa99zRlIntG5bqi1mtCGeCCygUxm6/3oZOZVPKSmTmAtjw2q8Q6y10ypov05pzO8RQDe9yov0k2spiKxwMJRbQN6fgNxGs9K9kkslB40LyOED+gegKZ4p0mZSQdB4GDMdfcMmlWUNTP+KrHHqZ16GbFw3a3QGNargDaexahaVrxQyMkt+zOu+Me6gI7GhYgMxrMubqWT+Ck7WsDzLAoC2KLYol0cdOsiqjXvtCtVd2S6qTzKpwWzsOqXpIRhTZI2wwUA16hoyONpc+DrHUOmTrHr5UFWdfaE8rValEr3zyFk4Btd+PY6LVHoGFBxrUKb4bwY8ZJYJIprJX6mp2Q6YBGdcn9xqrw7Mc8BOGV3jqy/2sDpV1fL1efhWU3omck9XfyAfB+I8RovSGj6AoPe+BmsI1EwclJ+uRgCPhUnNnoSqS1bXLxQkpCxivE
 K+vqQ2K8
 OKqwg2eo4MeOGKng/xhpB3j0Tt3emDcZMtJPEoOwY4pvEj+Ahjea+HtwUGrRB+Zh/OlW5sGbLEW4oahv7zojqb/WEWtVg0Uw/64S0lxGq8fgUA8O/176yLBPqBcgqSfwMU8AVHcVLarxfBNt0+3q9isasKQgDy0ADr6WcT595prOzlv070xX6oXveWqVkpI7jFJ1d76F+5XGM0pOgBrCWrK+wYgScSFXvM5r4ZTdAwqlm5r2sTGBR2qnipJwAr98fERmDACnAF9r2g1SQLYDeY+/zncoxbPxIUPJqRxNwd6SLGqfwwMYUD9BGO4B6atNjORcZSy8qqv98/33zD26/PMnlCtSmd9Pig9ciRuu2BqZPB4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 2:04=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Fri, Jul 31, 2026 at 6:37=E2=80=AFPM Abhishek Bapat <abhishekbapat@goo=
gle.com> wrote:
> >
> > On Fri, Jul 31, 2026 at 10:25=E2=80=AFAM Abhishek Bapat
> > <abhishekbapat@google.com> wrote:
> > >
> > > Hi Hao,
> > >
> > > Thanks for reviewing the v2 patch.
> > >
> > > >
> > > > Hi Abhishek
> > > >
> > > >
> > > > Thanks for the v2 patch.
> > > >
> > > >
> > > > On 2026/7/31 07:48, Abhishek Bapat wrote:
> > > > > Currently, userspace has limited visibility into the exact active
> > > > > runtime state of memory allocation profiling and its page extensi=
on
> > > > > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]'=
).
> > > > >
> > > > > While reading the sysctl provides basic on/off status, it is curr=
ently
> > > > > impossible for userspace to natively determine whether page-tag
> > > > > compression was successfully enabled without scraping dmesg boot =
logs.
> > > > >
> > > > > Resolve this ambiguity by exposing the active compression state b=
y
> > > > > adding a new read-only sysctl `vm.memprofiling_compressed` to out=
put the
> > > > > state.
> > > >
> > > >
> > > > I think this should be vm.mem_profiling_compressed.
> > > >
> > > > Otherwise, you will need to adjust the procname for this new sysctl
> > > > accordingly.
> > > >
> > > > Also, kindly add docs at the linked path.
> > > >
> > > > https://elixir.bootlin.com/linux/v7.2-rc4/source/Documentation/mm/a=
llocation-profiling.rst#L33
> > > >
> > > >
> > > Thanks for bringing this up, I didn't realize that I forgot the
> > > underscore in the commit msg. I'll fix this in v3 and also add some
> > > documentation about this.
> > >
> > > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > > ---
> > > > >   mm/alloc_tag.c | 6 ++++++
> > > > >   1 file changed, 6 insertions(+)
> > > > >
> > > > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > > > index 52aece27b00e..877068241f06 100644
> > > > > --- a/mm/alloc_tag.c
> > > > > +++ b/mm/alloc_tag.c
> > > > > @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_alloc=
ation_profiling_sysctls[] =3D {
> > > > >               .mode           =3D 0644,
> > > > >               .proc_handler   =3D proc_mem_profiling_handler,
> > > > >       },
> > > > > +     {
> > > > > +             .procname       =3D "mem_profiling_compressed",
> > > > > +             .data           =3D &mem_profiling_compressed,
> > > > > +             .mode           =3D 0444,
> > > > > +             .proc_handler   =3D proc_do_static_key,
> > > > > +     },
> > > > >   };
> > > > >
> > > >
> > > >
> > > > I think adding this sysctl alone won't be enough.
> > > >
> > > > If we set boot arg sysctl.vm.mem_profiling=3D1,compressed but profi=
ling
> > > > gets disabled due to insufficient page flags,
> > > >
> > > > this sysctl will still report 1 (compression enabled) even though
> > > > profiling was shut down.
> > > >
> > > > To verify this behavior, I have set up a test environment locally a=
s
> > > > shown below:
> > > >
> > > >
> > > > [    0.265503] 4046 allocation tags cannot be references using 5
> > > > available page flag bits. Memory allocation profiling is disabled!
> > > >
> > > > [root@localhost ~]# cat /proc/sys/vm/mem_profiling_compressed
> > > > 1
> > > > [root@localhost ~]#
> > > >
> > > >
> > > > I'm unsure whether we should initialize this sysctl when profiling =
gets
> > > > disabled at boot.
> > > > If we do, we should set mem_profiling_compressed to false in
> > > > shutdown_mem_profiling.
> > >
> > > I think the way it currently works is, compression can only be toggle=
d
> > > at boot time. The new sysctl my patch introduces is read-only. Based
> > > on the current behaviour, if compression is enabled, and profiling is
> > > toggled off and then on again, it will be toggled on with compression
> > > enabled as long as we're in the same boot session. I don't want to
> > > include changing this behaviour in the scope of this patch. I want to
> > > limit the scope of this patch only to expose the current state to the
> > > userspace, hope that makes sense.
> > >
> >
> > I reread what you'd mentioned and believe I originally misunderstood
> > your point. You rightly pointed out the subtle bug where the
> > compression state is left desynchronized if compression was unable to
> > be turned on due to lack of page_flag bits. I acknowledge your comment
> > and will change this behaviour in the v3 patch to toggle the
> > compression state to "false" if this happens. Thanks for bringing this
> > up and I apologize for my previous misunderstanding.
>
> Well, if profiling got disabled then it doesn't matter whether
> compression was requested or not. The profiling is not active anyway,
> right?
> IMO if would be less confusing if we let mem_profiling_compressed
> reflect what the system was configured to do. If that configuration
> was impossible and profiling got disabled, the userspace can detect
> that by reading mem_profiling sysctrl. As Hao mentioned, this should
> be clearly documented in the docs.
>
So, IIUC, you're suggesting that I not change the kernel behaviour for
the edge case Hao brought up and simply expose the boolean value
through the read-only sysctl. Right?

> >
> > > >
> > > >
> > > > Thanks
> > > >
> > > > Best Regards
> > > >
> > > > Hao
> > > >
> > > >
> > > > >   static void __init sysctl_init(void)
> > > > >
> > > > > base-commit: 2ed26e8a624f41887d64e2e37a2f6ab36a118d1f
> > >
> > > I'll also wait for Suren's comments before sending out a v3 patch.
> > >
> > > Thanks,
> > > Abhishek.

