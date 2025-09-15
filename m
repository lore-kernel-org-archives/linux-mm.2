Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFCBCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDEFB8E0014; Mon, 15 Sep 2025 11:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E938E0001; Mon, 15 Sep 2025 11:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DDF8E0014; Mon, 15 Sep 2025 11:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 943ED8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:26:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 454D616050C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:26:03 +0000 (UTC)
X-FDA: 83891860206.24.59B6B85
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 550661A000E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:26:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HyZwD39G;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757949961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyXri27Pt/akefOQDUhzfEAoRim6JXs5fhh6q8B4I8Y=;
	b=u09g8IaQiSY+G2dZwbgsuvFy7rX6CRmWZre7Hmy/Co8pVbvWJVBqdYbxAPzlGRw5ESuzCU
	riSp2/I8zOdKmSKGevpIxxR5UxOTbgea2vNDD2oiUPGCxDS1GoYtfzFOZf/tSuMuk9o/+q
	cN/7Z94VaXb6lq534YDoPkR/4BIGVWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757949961; a=rsa-sha256;
	cv=none;
	b=PdkazHfi1g//mUyJA8CMeSuwyeRk6hlPsFc1pWb8Z57LSkfuo68zsnnoXUpkEBAI1Ol8YQ
	K83fH+vRfksat+Cr8L8l8gGKQuk16BHabmdKCYfGs4t23HKFfkTiyrKyiKcjOmeejipM9n
	KhYMI1weWdwZTh79exJQ6UrawJSgE2o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HyZwD39G;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b4bcb9638aso976061cf.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757949960; x=1758554760; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EyXri27Pt/akefOQDUhzfEAoRim6JXs5fhh6q8B4I8Y=;
        b=HyZwD39GFDaDC4HYijs30+XrElB8wywbtIf+h0FTQGrwpClqA2ZyFCyRaZ/HNqeaSm
         G6jPQ2/aTZUoWn0qSt2bssl7WJjIg5eOLmLXD79c4YQiwevX23RQ9glTUQPL018SFMhS
         2vKqoz2Bth5Kcogim91SgZtVOhw4jMTVSCmP/3fWX+VRJ2knsyc9ysmQhD5b81GsBYUQ
         SvAq8Q7dEYpZdqEoMdjELUwhKhMn/V5c0szZt5rHbjuHfOCvP8XMXuZembTm+iwtmC2f
         Ho8CN8sc4DJBbWu65snGwGYo6DACUAi0TbDRyjnct2FW+MmOgbPCrGKL5JhzX6UsAJKn
         qdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757949960; x=1758554760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EyXri27Pt/akefOQDUhzfEAoRim6JXs5fhh6q8B4I8Y=;
        b=oiF244uQDWE7r46FTvtOH336leJ1IXKb+LlVClEVaK0g07yO2/EeK9P46fXpNZzBBm
         JngddR+Mjhs24tgtZakxxQlpiyxpTLLRhVI8Fzf2w11p3zpn5N9FZ2riBKRpJ2YGyuvT
         5HEAWYQWBw4atXmoOHEmrAUJEbhxdUTiyLY/r6UJuz8veEBzR8Q6zhJ/ZcSdngoKgpMK
         P5x2Cw3aOLmX9umu6NDZo6TKSms22eXFRs4vy9OZN+z11lYPpaZpMm8d/Y9HjiYmMM06
         SdZlbeYPp7E50cz4iqF9BvZypUL10ImlPbxv/VGSCjRpeoIV9p1Ykw37/vVCJuh4v4v5
         uEBg==
X-Forwarded-Encrypted: i=1; AJvYcCXicD1e5HPZq5r9PV5Bs0HqNODPF8wSHybZvcuS/BaMk8MqgAbkfRztg/WlSABz0+8DHfUIdS6TOg==@kvack.org
X-Gm-Message-State: AOJu0Ywr9LvKToj9Pq5ZTVVfUE5dsrauU8mDSrj+8dDl2H1ZvswyL9HQ
	mn5OPA+sCLxRl80+aIpCai1Y9a+wF5lCgtZ2BwpQVL/FnT/wVH9hTr6aekMazjwVq2ZvzKf2vMi
	SohxGNdUjUBcmiVCvvSQzAEGkZqdOeAH88WgrKUN/hkB8UOCQU0sa2gMr
X-Gm-Gg: ASbGnctGXxUwkK/SfNQlKG491NOGjDNtDeLYoM0gNYeje6YUPydtgfFrOVVN/tGK6Yq
	MBCEy7YMD6kPXB9+Dk0LZBn0g9W3A6qjFsjKAQMudO3XZH9TZi9rK341UDQx4UMVGnyvFk/WSlR
	aRSaBWRhzKCblt/lGFmBbYwLuRb+eX9+RRd7+KnxIS+J5gsC7qjlfD8sFeNM5iHVYyYduyxPzJl
	D6qBQJD3C4RgZ414oRKrKU=
X-Google-Smtp-Source: AGHT+IHShM3r6feBapT4gTDKOG5vd5vABusk6ZNc0QTT1nxg+Z0uMrihoDo/4U4rKPGDrTNbMSlHFgTxa0Fo2vgQkOU=
X-Received: by 2002:ac8:7e91:0:b0:4b7:a274:d54b with SMTP id
 d75a77b69052e-4b7a53bfae4mr5366191cf.12.1757949959762; Mon, 15 Sep 2025
 08:25:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
 <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
 <CAADnVQLX_mi9WLygRxwp5PtBFG7L_sqm9sL93ejENWqVO3ar7g@mail.gmail.com>
 <e7nh3cxyhmlxds4b2ko36gnxbdfclcxu3eae5irvrd2m6qzqoj@gor7vopfe47z>
 <CAADnVQJuAo5K417ZZ77AA1LM5uZr5O2v1dRrEEue-v39zGVyVw@mail.gmail.com>
 <rfwbbfu4364xwgrjs7ygucm6ch5g7xvdsdhxi52mfeuew3stgi@tfzlxg3kek3x>
 <CAJuCfpHJEUypV2HWRHqE598kr-1Nz_DokMz_UgrUnq8YkFcb9w@mail.gmail.com>
 <CAADnVQJQo6+AwJ_LxARVu37J-5T-7tyn1kA5hMVDGDfEyjF6mQ@mail.gmail.com>
 <e166705a-e838-4c8f-a8cf-64913e120caa@suse.cz> <CAJuCfpGR2tHhUu=p4X2YKPNot4TJbhuFPRiT8BgOHvtcw=j-Ug@mail.gmail.com>
 <75bc0c27-3d08-484d-9d22-59bc70f7ee1d@suse.cz>
In-Reply-To: <75bc0c27-3d08-484d-9d22-59bc70f7ee1d@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 15 Sep 2025 08:25:47 -0700
X-Gm-Features: AS18NWDzXwa6PsADklKbxWJVhOSyinFRXX6id3GB73JJ-8IdNGmacbKtj7E3p8E
Message-ID: <CAJuCfpHJyGrH91yErLBMPbFBu9dS3Nr_ij2FJdQ5cUnYxAu9Tw@mail.gmail.com>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4nhen6ysd6e7i931dzf54edehci97rdf
X-Rspamd-Queue-Id: 550661A000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757949961-986044
X-HE-Meta: U2FsdGVkX1/dQZtHUYzwqLtZlQHnrcL1TN15Xc2mUUkB7LUzTyfLWlBGWqGhxt1/A2V8QrH2haqfvznv9AGZhz7BWsBbXhjb0M4VSkameunow7QxW6VfSBBvp0iU7Fx/aO7Dv44X0Sm7t7gK6Cm2xwTUqmNeRsrmVG+oHBRxKQrlzZ3f3+afJMdbCuIPPoqKckrG6F5KjaG+ODRLq9lfPtJHBJPP/lCDSeTFxYkul3wrECNXoich6+Z5AIF7X4m3Nj5GagrBkk7NUsFsLDPN5XUaVZ3n0OAyV62sZ9GgaDSCgOhVbnBrQ/V8dDA1ouk0c49sFQT/7ImUGB5QQhAnMdMOMPLIngdxdDtFNv2iCc9W1tJ/rIXL90zMwcA2xCq76SvgBPgXyP3YqTlQpu9kOlEeFTRWszwXW4ip4s5jx/Suq1BDA7TTNnJFYPkIS091FGMdus1SHBy7sh54kve0S+9mFv6KlruoSpfueJv049tVUOSMfu0IUWnrCD+R6Hru+y0U+mOXJ4cV95Ku9bJFrcinVvkJixaGdiBffyKYPHC5I29GZ9CCWbSzJDkZ/UQfH/9nO8p76nHPQo9Mt28h7l7uPwxIzhOGqbYWX89UucAVK747dOCX+f2LZ/eC9BJtqMxhp00Lw/MRbhKOtCXMrtQz1jNkkyI6tgqfA7XzryLSze3SsGg693jU49Tf8WUjC+WopTxhkADfLH+CaZATmpmdAfiOhKN3gNH2bc/mrIzKjHZyxxU9x3bl9AXzrnnWVL9ni5T9MmrIGMNII5bLUasSCYZbLg6iWNAT0vEht3Sl2SFQqV0t+SZM+TjO49NNIF63bjQYzugcJ4z/yBY/ykrs78n2zOmIBCRetXYz5ZSYIu6emPo/9G9CAsluq/7J3hj3ww2bR3Lyt9wgG+YvATaJVBXj2yfFldaWr0KzkF+jWYCR7Th2H7thvHKD4jFuKycT6UXyTs2JvNGKi/e
 EGkTS2WZ
 KE/tQVpX0BnWRBygYn2XytTmAjlb3DX89vi7f3FQkDA7zgVbBfBS/ElO+4b8uUeIoyhsij0Htl7XmO4UplKFO+Nx0um8iTGrUozo0T705JBVQZLVqyxPeFdt+MxI8Pk9l9ppU0n9lSkqajZcy6zsEH9Q3zUtWInthw5Mp0bNTcSWl4TASFUfOd8KywFFXSkxdP9be5TclNoqbTsIkvY9x+aMHqURfIsvNOhytDja/i23Y8aTbIj5DyO0Q5LESZl018P+Dcuv2zgHayhcOUyRLJrOFAU1fkhVgjXYMnLbvn4PLiFPxuhEV9jaNtuQSru4P3/Z6vakS+dSDOBLbJVXZQsH+ns+uqxD+Gj0crU9ROpwtVZu4fQB3qlJ0Trpjj1tsjKzS6QOIjPtX6oKHuKbIRhMvvQC2Bt3BnGc5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 8:11=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 9/15/25 17:06, Suren Baghdasaryan wrote:
> > On Mon, Sep 15, 2025 at 12:51=E2=80=AFAM Vlastimil Babka <vbabka@suse.c=
z> wrote:
> >>
> >>
> >> Shakeel or Suren, will you sent the fix, including Fixes: ? I can put =
in
> >> ahead of this series with cc stable in slab/for-next and it shouldn't =
affect
> >> the series.
> >
> > I will post it today. I was planning to include it as a resping of the
> > fixup patchset [1] but if you prefer it separately I can do that too.
> > Please let me know your preference.
>
> I think it will be better for patches touching slab (only) to be separate=
,
> to avoid conflict potential. [1] seems mm tree material
>
> > Another fixup patch I'll be adding is the removal of the `if
> > (new_slab)` condition for doing mark_failed_objexts_alloc() inside
> > alloc_slab_obj_exts() [2].
>
> Ack, then it's 2 patches for slab :)

Ack. Will post after our meeting today.

>
> Thanks,
> Vlastimil
>
> > [1] https://lore.kernel.org/all/20250909233409.1013367-1-surenb@google.=
com/
> > [2] https://elixir.bootlin.com/linux/v6.16.5/source/mm/slub.c#L1996
>

