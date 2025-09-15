Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63AC2CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC7A8E000E; Mon, 15 Sep 2025 14:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5CAF8E0001; Mon, 15 Sep 2025 14:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BD88E000E; Mon, 15 Sep 2025 14:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2478E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:31:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2805813B9E1
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:31:23 +0000 (UTC)
X-FDA: 83892327246.08.E4A108D
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 37A03180011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:31:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MEymHaPT;
	spf=pass (imf24.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757961081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p71UH1Nz4vAWpVd3QQTKqUa33PkUmJwyPvAlZiO7WkQ=;
	b=hG3xz1DvGvA7Bfis39ubin/3TsoQZCq+7k1Yz+4FfOWoz1TPkSIKvH0npdgsxPBaHk9rWd
	xttSxw5H4NwAqcM9fD5XDRpe2/mmijHXK5loW8thKYCLfM5Hcfpf6iPf54qf1ejWkTOsrF
	bKet2BFSnUd8Ght8NsQRjyL4EE5/1sY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757961081; a=rsa-sha256;
	cv=none;
	b=mskIzRw0zkvasu7BY6BEjI03WqHYQa8tEwz2txKCnj0QeMT2dKh8bXImsKVxevgZer1rlS
	SSZFEZCkjvYAl06gBB1Ognrb3E9+tnFktHt7+tM2Q3TuqRqFU/Rf6N8TqDUxIjQlB532oq
	rTi0nwNFMHQkBr2c6Fy8n9CFjfIjeSM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MEymHaPT;
	spf=pass (imf24.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45e03730f83so21378765e9.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757961079; x=1758565879; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p71UH1Nz4vAWpVd3QQTKqUa33PkUmJwyPvAlZiO7WkQ=;
        b=MEymHaPTWz6IGYxtEwuohogWIE1CDkbHdeTKaEA8z1sfctDLsuDBBtdZshIq+c5x3c
         buu0lPgJPF69oIP+ebV5098xheSj+p7k5v8GSBuEsrQPgiAvTEgMnGJp/4ylaqC6WrlC
         gJ34lftFYo6+SiKteXPCFbpuEuJFaOFoJELsROMwkDUMJNZPn024d67imGkibzPdWlzQ
         oDDi0Aq2qyy76zYFS64MEYx2lBg4ffyguxChKu10nB6nx+43S+4/4X2Wiiq/pDnC+ydp
         +MwsYV9r/eSYWXQfkNh/Y8JsMLw2FVbwNdCk/r5hlzhVJrG/OdlF06a7Il7qU1S/dYN/
         VPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757961079; x=1758565879;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p71UH1Nz4vAWpVd3QQTKqUa33PkUmJwyPvAlZiO7WkQ=;
        b=Uz+nAAvckVpOqgsmbKQhlIoEmKevDg3ML7zrhtPwRqtSHybuS8cW+2HkA5V0W2xh4R
         JBq/GrXAqdxWe73nQD0fsa68bg7uVZvNsHehHEyvUyaA5GtM9paCmFGMhK9iQm8SpJlc
         fF9zNk1SDRQGl373KxO8/0F4uj5CgfXDp8rplRZvJpR0kA0Kib2MolxDUD8uSzqwMjPM
         2jktdj4wprgtar9O0pVi/kobVWqvw06dBr2ZQpjgzSF9e0+LNPCi/E0kNnUcwNBg19yi
         PWZo+YNHtKg7isi4MS/pnSKvaQinN+T29gVQBabZ0m+58dH9j2IYHS3aCZDFkICXse+Q
         wIoA==
X-Forwarded-Encrypted: i=1; AJvYcCVcJcnzTTqLxTPPcTJkeCF3kw/bxwEocUHN8XwIECg+okNCxY9mUTqfKYUBbryGBzwstIq3K03t6A==@kvack.org
X-Gm-Message-State: AOJu0YyJF0ptMtqhM/NCd0jBox3xh1yCrv+Mwyq1xnVxsOvVXTvtI8mb
	+4P//zjks/2iWEmZL8MLMe++vkqbDfwmSpJqV2q9B09WsEa/YIXCanuG
X-Gm-Gg: ASbGncteM9jYHyRF5ARFaPcvOSXw42uHILkVOIaTTMZiVAtWrDboWsf4ZqK/44Kql/Q
	eqhIGhpQM9PA9tLqIe6xqbMDH9r26sMYKbSdAktwapbOM8yDtByZTASATF1W/bLg5kyngGOMZtr
	uotg5dYI0q8iNZ4susUBbXe1z/QRovKTADM4b3n2bHWm/NXBeybGn+YKyeLldiJsM0PeLLnx8QT
	YvOQfvr4qWh4UBj/25TqcBMe2xpfrKuKiHC33jpW/z21GKwIJuNsQBTrILIC8wxS6SRv30dmKwU
	XnjzD6xSZO/dJk6WCVNf1GKIux9dwRleRRDvZR88QM5eS6gOo672wWE3KuZBYxzqzxRuNHdZqjJ
	VO6KkidEHr17PPV1f1kSwtn1rWasOtdcZdo2AQVESq5vf+bKA2t/mYiEsfMA=
X-Google-Smtp-Source: AGHT+IFpiqSwtwVakQgiIGNOpIio8KWCT1PA9Z3Xvc9kv/KXoN45p2qT5yH0IIvazHro5uQKAPWE5w==
X-Received: by 2002:a05:6000:2891:b0:3d1:8d1e:8e9 with SMTP id ffacd0b85a97d-3e765a130a2mr8789630f8f.32.1757961079282;
        Mon, 15 Sep 2025 11:31:19 -0700 (PDT)
Received: from Yueyangs-MacBook-Pro.local ([2001:620:618:5c0:2:80b3:0:8d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e95b111b68sm8881241f8f.32.2025.09.15.11.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 11:31:18 -0700 (PDT)
Date: Mon, 15 Sep 2025 20:31:16 +0200
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>, David Wang <00107082@163.com>,
	kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org,
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com,
	souravpanda@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Message-ID: <aMhbdAA-o7UE6bYw@Yueyangs-MacBook-Pro.local>
References: <20250909234942.1104356-1-surenb@google.com>
 <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
 <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
 <CAJuCfpEoWtgv8k4vApkGsNNUYFBnvS-N2DPQu2JrreCUPbT5dA@mail.gmail.com>
 <aMP7g7ts8n2Gubql@devbig569.cln6.facebook.com>
 <CAJuCfpEy7kQdDzU9GR6T=nz7HB6EnSkfx3vXmTBEuvJPqhxyfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEy7kQdDzU9GR6T=nz7HB6EnSkfx3vXmTBEuvJPqhxyfQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 37A03180011
X-Stat-Signature: uub4oc3t8rx8eu8p1p1mmntrc5sgd5a5
X-Rspam-User: 
X-HE-Tag: 1757961080-663199
X-HE-Meta: U2FsdGVkX19rYejvR5MKhlA7G9odTr8QViFAFKdX4spheB2UI+Uwbly6DBcdqnGcsa90YJHelLCAZIHsK2rkow3xm6MeWNfzUJ7U17kQP9sNJU8RKSiQ2chsgED7/LaMBe3pLzFQYp/rykcYFnU6RGDQkn7h8dgKOO30qW713hmXeOQlQb6BHM6D1P/AEGw/JhPM4tLcnv6rxAozZlCB8opp+tDKy0x9LzQ95kpIZccO193v7OwlzDMeekXQCADvsXeKMdBwklvO6/11iwgXf+Gq9ISmvuTQ9cCfvwppp0a9wciKKgqva3UE0tctnr5boykK2zgvAyrXw6+esvAZrL3BXMibHerSCk0csP0vcc24dJcl6lj+etmK9xBTNpHPx8AGEiFks9pdJdnNPKt9ihuVkDXr7y9whe9IH2RgW+F3Cwsku6xwVldH+pMMkbZgbXwBZ/RKkQDBHdsz2gSd44bOTIq4iMBVQUEENlkxYBhIIxK4CGljxS5iBONxOZ3f7lCP8PBliQlO8ZHGfmH6MfhZqLflqAldhUtLJJkBB/dVlIZ3imfxLkxByJQxkKbjXDedtjMf0MV/xlvUfRBJA8t9kbPXskPIhX7NitzDv/h0Owdzzxg8K1CbAh9a6ULio/igdyTD1/rTsPFJBNohod5AbM/GprwFI1wIbPU2gjBnwH+bU+JBfQEk1Y+ylUXk8r4ucmVJ4CQGr/w7B4/D6mHHHEMwDOgyc+JrBa88yeuonoCjPY57srEQVK0RSf2z6M0Jj4b4D5u2scrMfhiMvqRXKLpykVKcBUvPuOh0OCd7Y5LN//tDJZBY2pcnkgee99AqahUCGpEjVXwjyFQax3oIA/zxSHRiO/EJTav9U1Wr4dQsH+Mqode1mYssZFxbYVdqZQFke2+kvBR1suNRcqn0fQCE9U6gIJOR7HgdyUGy6U3Ib9k13wVKT/tkQgXN7ophtLgTYSL8MhLFGht
 gEOzmZN+
 mTHTKAG8dJgHwq5dljuk8FelM+kXY4loe7jH1FItRpQpolzyFZpEt2CgTaVvxS/U81g5DyZbLo5iKUIPbSlx9I82u+2M9Pdu5t794ii42ugltkmijd6cqeuYlCPTrKe1UZeKHrYADg5hwWMdV2RVnhTQpnqzAaWGlgPZk8xppf6XCGHMy9f4pRx5mjcXv3YrQexuPt3syKtz4b6IKep6ePD0V2Du4jtQrNTvRV4ZhbYT/mi4vaKvp3TnMElpsSN3rPICOAGb1zHYtIaIo7hhZXk2UmzbA/JPz7j2Z9K0MOKRKpPv8YLGpQvRt+cszcnc9RjK4Ed95HgNH+YKv1uRDUIglEDdYVQuOOcjpG0coy2WSgIZCnyhzuCMAl9foVTPmZB3aiOgUpNrc2v7n9/j0erFLZoqF0bv99nLRyD4Xngz+nCbCJtgie+gXv55IehQ86+e6hiut6KL6stLTsftVhZmPzCtWy/Jxkl0+CDu0i2OlE063m1lKscol6KL7QPNJGg80JWB9EUqHequE7rbLiZhNTf1AjzyghxNj+vOm44YDqbxOKzRegE2WL+SB1nw7tpdHPZCZ9KeX5x2Jow8Va4oq0oz9OVoz68nS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 12:38:01PM -0700, Suren Baghdasaryan wrote:
> On Fri, Sep 12, 2025 at 3:52 AM Yueyang Pan <pyyjason@gmail.com> wrote:
> >
> > On Thu, Sep 11, 2025 at 05:25:12PM -0700, Suren Baghdasaryan wrote:
> > > On Thu, Sep 11, 2025 at 2:31 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> > > >
> > > > On Thu, 11 Sep 2025 12:00:23 -0400 Usama Arif <usamaarif642@gmail.com> wrote:
> > > >
> > > > > > I think simply adding * to the end of function name or filename is sufficient
> > > > > > as they are already str.
> > > > > >
> > > > >
> > > > > Instead of:
> > > > >
> > > > > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> > > > >
> > > > > Could we do something like:
> > > > >
> > > > > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create(inaccurate)
> > > >
> > > > Can we add another row, saying "the previous row was inaccurate"?  I
> > > > guess that would break parsers also.
> > > >
> > > >
> > > >
> > > > I don't know if this was by design, but the present format does provide
> > > > extensibility.  It is basically
> > > >
> > > >         NNNN NNN name:value name:value
> > > >
> > > > one could arguably append a third name:value and hope that authors of
> > > > existing parsers figured this out.
> > >
> > > Actually that sounds like the best idea so far. Currently the format is:
> > >
> > > <bytes> <count> <file>:<line> [<module>] func:<function>
> > >
> > > We can adopt a rule that after this, the line can contain additional
> > > key:value pairs. In that case for inaccurate lines we can add:
> > >
> > > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709
> > > func:mce_device_create accurate:no
> > >
> > > In the future we can append more key:value pairs if we need them.
> > > Parsers which don't know how to parse a new key can simply ignore
> > > them.
> > >
> > > Does that sound good to everyone?
> >
> > Yeah I agree on this proposal. We can keep this convention.
> 
> Ok, if no further objections I'll post the next version and will
> document that v2 allows additional key:value pairs in each line.
> Thanks,
> Suren.
> 

Agree on this.

> >
> > >
> > > >
> > > >
> > > > Whatev.  I'll drop this version from mm.git.

Thanks
Pan

