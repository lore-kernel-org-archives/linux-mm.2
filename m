Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE8BCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 05:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2159B8E000B; Wed, 17 Sep 2025 01:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C65C8E0001; Wed, 17 Sep 2025 01:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDA18E000B; Wed, 17 Sep 2025 01:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F0B6A8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:20:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1A87160252
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:20:00 +0000 (UTC)
X-FDA: 83897590560.27.D8CFB4A
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9B52640004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:19:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kDpJsjIt;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758086398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bmyd5hRjBwGBijd389YyKI2Nhh/nN0koD1xhovKWzlU=;
	b=PU3v81SPY/+yzxZ/nZyng5eg7Wu6OvPRHWfDicPlVJApImHo/vGE7Z8e9EpjD0Oq9jfiL8
	iqk5AbzEIOqS+otvspm0sKS0ajXD0k9l0b2jTqjnEusyqwX89DiHx66SqNt8vdq5KsCD3p
	lxEDC3qQU1ECuGhTJXhd1MFhd6WUmaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758086398; a=rsa-sha256;
	cv=none;
	b=jMK/3KNjAmmhSiadYpECevRjSz9nFrP9jXmGnk9GqKZUpFWikwE+lXqWsLLbAxF1lAhBOB
	QZsA5RLUXq2zJS6LojjdaxpC3AWd8iTotirbqRPMQCEPb9SKhtiyK2we+5gC4xBcLkzaU1
	RaaNbD0VH/8aW56sVwARzt56v8TUASM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kDpJsjIt;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-56afe77bc1eso6591336e87.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758086397; x=1758691197; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Bmyd5hRjBwGBijd389YyKI2Nhh/nN0koD1xhovKWzlU=;
        b=kDpJsjItfQAEa84bzWQj0xkCfv3ymwKX7tMClH8g42a2fvmZMTIdFHteGqbRi8u76Y
         EhktSAFRtxDVZaBbkEYrqEe+De5VUjOkIlalng1LmsNemOS8UMahniRHj6i1rmZKhxbN
         1/T+SgLRB8OiIpLal6/2888CnUZzinfRemTve2bHN3X66Z2qXydXdPHrLJo2g9Sme+gp
         X+mJ0FuUUmqA3z8O1Afa/QwaUPgG2/FdLKf2NSzaWBWN9An+9hQVelOfbBdlHupbP/Gu
         o1baZjmsEJxtruhMUoLx5hdrMPgdNsQBz79yxdpkAbXM/ilBdmYFpyXu1F4GofrTAsgb
         5tCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758086397; x=1758691197;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bmyd5hRjBwGBijd389YyKI2Nhh/nN0koD1xhovKWzlU=;
        b=PIwdvC6A4Ts44ddrN3xU4imvezjOsF24THytaqptMI/NJ1Ykn63UqxHl9IJAtG2W34
         CUe9xJhKYZJfvlL98tos3/OZ24v06r+yx8wriwS+anec58U1mmzsnJJzrUt8TmG/IlWK
         iwfW/TONImFPfJJMArskN+E8VIu7Ltr2CA+tpVwlK5UpSEeTp+bvO5pKuG1vVwjM9oFK
         ZIDbscs51rmQHgU+5yRKcWnDBxwujeW/ThQqeEJ0Cfo7aLKPPmy4ooTGq7E8597MJZlm
         hcZLnytcOiavFeEHO8S676qhMRMwHfAlAnYkbrx2TQhkUjTLpkzpoakk0rxrYLP9BC1B
         2PDw==
X-Forwarded-Encrypted: i=1; AJvYcCVwVhVVOMRGfPVLHySO4OjGugV91WHbqorQQW66wL990x+NGmjQIg8/D29tcelWhFvXOnB47Cxkvw==@kvack.org
X-Gm-Message-State: AOJu0YzBa3rq2LZ/Fe4iOr9NtjbUOp23p6PVUpJr9RTSovd4e6JFFUbZ
	+8JwM301LJAFwrfZYf9OKqIMe4HMFB1GyTDIfoND9fNyQX1NxqCUKsVT
X-Gm-Gg: ASbGncswO82OSV664Pcg+fj9MqUv4+76FYs3379p1AEgwUuXz5nn6DHLVBPCiGJb4UK
	+02YOFz95Aa0fP5r3bBfMYQKgOEMBr0tXvnA6vQivU7SxqxWcc5Dl0rXW18nYIldZp1mcN/rEKb
	+sCsEwa42oJyytwYdMP9tyIGOoPuNrGTMUJkclLFFKqkHZECgSmIUa8/Wb47CdKJCPN9yhzhnL+
	SSKJUoPk3ttJ9xn755xg0IxnZO3CJxU8b73kIwm5IkN7loIEwRoIJGm0a83Uc/1kwuQ8pLWf5Uf
	wvPdopMi2KdRTjkIsFyxavrD69YEHZtmNMGubx8ONRFsyCaf1k//2gjSMTVVtUp3
X-Google-Smtp-Source: AGHT+IGB2IAmQmaimZaar4vlRXTB5elF9KD3WHugEVd5zhXssue2GqCwq5b5W8l5x9hC6+gNaxnbEQ==
X-Received: by 2002:a05:6512:15aa:b0:55f:33e0:9602 with SMTP id 2adb3069b0e04-57798947d80mr238319e87.9.1758086396325;
        Tue, 16 Sep 2025 22:19:56 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-57327ed142bsm2809676e87.136.2025.09.16.22.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 22:19:55 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 17 Sep 2025 07:19:54 +0200
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, paulmck@kernel.org,
	Jan Engelhardt <ej@inai.de>,
	Sudarsan Mahendran <sudarsanm@google.com>, Liam.Howlett@oracle.com,
	cl@gentwo.org, harry.yoo@oracle.com, howlett@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	maple-tree@lists.infradead.org, rcu@vger.kernel.org,
	rientjes@google.com, roman.gushchin@linux.dev, urezki@gmail.com
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
Message-ID: <aMpE-oSjtlDU4TSl@pc636>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250913000935.1021068-1-sudarsanm@google.com>
 <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
 <f5792407-d2b9-42b3-bc85-ed14eac945ec@paulmck-laptop>
 <d1ef1cbb-c18d-4da6-b56b-342e86dca525@suse.cz>
 <CAJuCfpEQ=RUgcAvRzE5jRrhhFpkm8E2PpBK9e9GhK26ZaJQt=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEQ=RUgcAvRzE5jRrhhFpkm8E2PpBK9e9GhK26ZaJQt=Q@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B52640004
X-Stat-Signature: jh8whgyfwpj59s9a37wuude3c349gjgg
X-Rspam-User: 
X-HE-Tag: 1758086398-735589
X-HE-Meta: U2FsdGVkX19uhXcjU6kez22Qly2AHwIXG+BV/Ko4OCwe9y1CTX2ev32Z9XXdaSs/2eB7FKVZAVuSDTZYWjZ8ecphocgkvLxz2ZiDNgCu+kIfbXXPmWT0pt4xfEIHTas9WA2R5QRxju7Whhl8eFxgPm5wegqpZKIQkAqp1pi+5GZTK1bLhY5sRBalYZ1+QLJdQwezTIPPztgSR97BdEqRdPblmf0NM/k1M2S37Uoov7q/v/l5VLULLrLQCWsB8hSroNTx9o7corO0NsfTTS8cxeQ5nVqC3PN8JQrRypYaj6yV7SgSmkC+ZtRwBY20HzLmOzs5zmQEywPR+7MBCbdaW+tdKN3j8AijFe0pISsg+hkWP5vaiMv1YslY6T7NC+JFbHvB798JFtHeZzIYhqWBz43JZ5GXIY73MW1VALUiNyXjk6bDUb8IFCNsjIrO/NBwd9OksQLZ03mkw9bJIN8/HXB1RFBqyIDGqaUZSg+IYSto6C/gDHsJ/pJNCXzrrEU319mdCGfS6Ti42TqRYTmwPUgsOctDml3SWALOd5wV6WUb1NW90CK3u1nsFXcSzjISTOHwvucZZN3vAwMjl3Kr0uuS14Ua+6FWoa+AaFImber+wUqQr/8au2FkdsIRCxzUndIT/Cg2nLntF0P/EgvZkPNvQWMIEqT6JDyg5ieq0nUHNw1TpKdHSjm7e3dTMQ1tg6CgFzl/T8JcVP6ueIES2sroS12frk457igAUZjhfQlcxJE0NvTD3SH5mlmXED3jywG0w4Kn8OPCci32aiwDCpB1kHFFEC70EEbs5y+nouuSm89/RBtpAmvUzTwqHqUqWuJfLXOb5vwhLbMOzzu4LHl6lL7NErPmjntXex2epbhCAYlchEuQYRXwZIJO8osZCU/gu6j4URDV+lG8aJC/Os+avdVLz02sHIXfe8ZI4eMMK8NLjqD7CS5gp5D6eHMx6XURnX2HfRbwa8j1T21
 K0Qfy3hT
 tI8XMl68gfNVg6SCvWi62HG4aepUZMhMq3U9+KMHtfOwg9CSwSEjrSskgRdkZ+1G/rDNhCmROewJi+xERKIUDzkuKeT92ZpHZ/qxMbm56+Ep/2picQwHNwMP4WxamOOHHY1u/5pLII9ZFqPzKIYYM7POoh79dUQf3apPlTsdLG/SCCaUIspxrog12ADENYcRChqowJrrw509Dmkuj9LyGLnIUnjwY2kRYCy80TmU4/MKlHnVFigx/sxZmDZA0jQ4BVFGBvu5GE5JXVqaZtq7B1u9R73GrtGwTlc4ZRlilKyyVCbohV+jKIwaZcq2lwAqS1Q9GOAsqTLSG46iUqPeUfVAMMm2w71Y1gwQV4DpDeRtw2CRhmO+oJYBPzkFkEzuMALi4u8+plcw8XFyoUoTnbwgu42BTR1hIJRlQkglEF80W9/JCuadVM2AhAKLHrMEbf2XzPZOAGyQIRKXyDJ8hACUe1JEXpVGvSEpjcJyHSKGXkL5dJAz4pvH5Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:09:18AM -0700, Suren Baghdasaryan wrote:
> On Mon, Sep 15, 2025 at 8:22 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > On 9/15/25 14:13, Paul E. McKenney wrote:
> > > On Mon, Sep 15, 2025 at 09:51:25AM +0200, Jan Engelhardt wrote:
> > >>
> > >> On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
> > >> >
> > >> >Summary of the results:
> >
> > In any case, thanks a lot for the results!
> >
> > >> >- Significant change (meaning >10% difference
> > >> >  between base and experiment) on will-it-scale
> > >> >  tests in AMD.
> > >> >
> > >> >Summary of AMD will-it-scale test changes:
> > >> >
> > >> >Number of runs : 15
> > >> >Direction      : + is good
> > >>
> > >> If STDDEV grows more than mean, there is more jitter,
> > >> which is not "good".
> > >
> > > This is true.  On the other hand, the mean grew way more in absolute
> > > terms than did STDDEV.  So might this be a reasonable tradeoff?
> >
> > Also I'd point out that MIN of TEST is better than MAX of BASE, which means
> > there's always an improvement for this config. So jitter here means it's
> > changing between better and more better :) and not between worse and (more)
> > better.
> >
> > The annoying part of course is that for other configs it's consistently the
> > opposite.
> 
> Hi Vlastimil,
> I ran my mmap stress test that runs 20000 cycles of mmapping 50 VMAs,
> faulting them in then unmapping and timing only mmap and munmap calls.
> This is not a realistic scenario but works well for A/B comparison.
> 
> The numbers are below with sheaves showing a clear improvement:
> 
> Baseline
>             avg             stdev
> mmap        2.621073        0.2525161631
> munmap      2.292965        0.008831973052
> total       4.914038        0.2572620923
> 
> Sheaves
>             avg            stdev           avg_diff        stdev_diff
> mmap        1.561220667    0.07748897037   -40.44%        -69.31%
> munmap      2.042071       0.03603083448   -10.94%        307.96%
> total       3.603291667    0.113209047     -26.67%        -55.99%
> 
Could you run your test with dropping below patch?

[PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu() operations

mmap()/munmap(), i assume it is a duration time in average, is the time
in microseconds?

Thank you. 

--
Uladzislau Rezki

