Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E41ABE9A04A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 21:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2916B0088; Tue, 17 Feb 2026 16:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290376B0089; Tue, 17 Feb 2026 16:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172396B008A; Tue, 17 Feb 2026 16:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F41116B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:22:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FFCC1A033F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:22:41 +0000 (UTC)
X-FDA: 84455222922.19.2379030
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9F3498000B
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 21:22:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aO0owJAe;
	spf=pass (imf02.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771363359; a=rsa-sha256;
	cv=pass;
	b=dUEPXF1bMnlRL4EY9CrhOkpapAXRYdbTuz7/ntngfJxdeyPqgEv760mFUcwC5v3/tBxuHv
	PbuFNxnxckOZbPZ0PXhTSBg+qcD56suBEJbxx97+NBG9fgi70IklPNPV9UaC+ArbAbo8PN
	AwQCk5FJoOViCLxdN8vYx5V7R48M8hE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aO0owJAe;
	spf=pass (imf02.hostedemail.com: domain of axelrasmussen@google.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771363359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+ndZ08Wfr2FJ+clwcBgcqojc0iDJKXmMWJl1yev2X4=;
	b=gsyv+1Bypg6XuLk73fH3DpeeQi7UA4ILHCHcpWOPLEgcJXhDVhMqS8wBUoOQ4VsBmLgIHA
	LW6KWFOYjIZoq1Khcec6Y/rtNQmFG9kDajrMdGykPG303VSpIda7rsr5nF/c32D/oR1UIk
	gih4UiSxuR5h4lUWmRYKgqlZRAn2C/I=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-126ea4e9697so1140c88.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:22:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771363358; cv=none;
        d=google.com; s=arc-20240605;
        b=JltHaI4cJc0qsFEAIrD4RFXTgFD9DD2kDHq/0MgIBDaINQ2764wez5+xIsx1gdlaPY
         EmU+hops5jlHe9YIhlCyxIHgM40s2Cy1ANm8qcNJdPeJ2fB2EaDb+a1jiCtD1WTZHh6A
         BaEdNp0QsneahZkMwGDpOMmbqA19g6AZ5XLrko0SOfJZNm32LAmLh9L/+VjlpWAOb+sS
         uM66Tv3rLwgMWG5RhyoRdZq22vI5mDzKryNJB1a68WqriAWqyHFSTwuMWxzy+klIGVvl
         he5olGDU7uDMAoJEap9PiAyKgXQLScGAqxcArdHCR1A7ovbBUjEz+pKXtbE18VCm+10s
         V/BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k+ndZ08Wfr2FJ+clwcBgcqojc0iDJKXmMWJl1yev2X4=;
        fh=TvZqRi+X2QVMKuQS6Z5/yDJ2eP/Fc31sih+kYjoymzE=;
        b=CY5l3+diKVheu/q2V731XD1k0erNW+JonQTNREMqBQUucMyJu6zvQ6Dg4HSmyG/0pU
         0JwivAP1eWmo26gYL4KGA69vd4hr0Q4rYx0zYhLkJdH3aKSVQnR+4t6Gs6Okj3KpAiJu
         KwjcaJg3ZOKxUf24eCzqKHwD1KDIyXJX0+/A25wqYHPStWUJE3r3fount+FoTkiA+NID
         pPOY/+STFsHZ43VPWP4WPobC+ZZ19FZ8QfZHOQkDiGajGKmvx6sigBrdoUKUovBjv8Di
         kglCyTrpJCUxYyIMExRNDIbvztoed1nKDygTFVEJ//OaRALrQAOLI88Ovsj4m2asWqP6
         Jikg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771363358; x=1771968158; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+ndZ08Wfr2FJ+clwcBgcqojc0iDJKXmMWJl1yev2X4=;
        b=aO0owJAe/iT5ZeYkKAPHU13DZT60TSCZGqW3JkQhKmTTWRE1URgzkkBwqN2otJ8w/9
         c9lN2DRhH8HcTgdH2iTmmUvQE9dq+cbCNpQrsafoWmuk3s8Km6zfyDb2FbKiJ5GC39OH
         DIgEI2DBVPxt0/h3MAJgJT9q/zvfTHxlsIl6ZFdZb80ou79fIrqOco1DSMJakXYj5nMN
         Mj+/MD20pGzNRteaMmaKnbPx/9knGEPRIH9PCJeslvc/X4rqc3A6y/rBlDNqDTq9Gjdj
         bAVq1nhw1m9z8tnrF2J42JW5cobM7X5p7OMIkAhxU4c02gD76IxWTLTWCj1DNw6euDLE
         D9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771363358; x=1771968158;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k+ndZ08Wfr2FJ+clwcBgcqojc0iDJKXmMWJl1yev2X4=;
        b=wz91VUj8t2aXk0jlToaG0wv/KxRUCUrqOo9YUCcNvVCXbiiAFRcz7CmNlgDG4JX3S2
         zgxvihXMzYr0njrZeDQsmFWwhi4t26nicgda8AVfhrTTkhwBV8+u5e374/NPmjev1yjZ
         x0ke4G+VrBnwQ5vIJQRN5WbOYWBqrTKSVsYvQ2Gq8FRPCSheaTu2vckJmavNfxzV4uzE
         /v4Daqz//XQ4X0BRnFS/UvKmIKnnXsbWpPoEtB4i+3Ld5AyihryHLtuy50a0oSA+Eett
         0zZVq9pYGvvxLBY/m7E+/llV3UVmvhcA1XvQW+afzbh6rAOY+cXKznZEUXd5axFBZ/c3
         GswQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaYCOLM/IsJChElvKR17qfZ6I+ySn+4bIKBBMpbOyE8YzMrAEfxyb7Y0rr7xa1aWhse5baBGyJzg==@kvack.org
X-Gm-Message-State: AOJu0Ywz3yKCiJ1ko8jQpONUvcKz9Fp3DpI/+9X+rWucDJxl9ndndzYl
	RzUzDYR80V1h2HgopCEh79+oE2tZNoOxDfLKMcQgVOXWRCv+cBHoUd+KA3oEvT1Tmr1FSljyr2C
	mZMAenNM7Ytp7LlLMQKaXKMd4LGgxlCzmFElgm8cQ
X-Gm-Gg: AZuq6aIx1+MjOBXWxNtyOeUbMjd64pWet4wyxVtt+STi+IUGzt0PWUcv6sf1g+f8NOS
	fHtONnOvemMF75ONGq5WfesazyJ7WT+hMqlvomwcqL+I0jcVKSGyeNYgY18IjLDioyXzYICrn5h
	Zq7hGG4V4jj7hSjWqWSCX7iJmyDRiGdnrSozOos52sQQes8IgmCa5Bc0fpMNOLHDez5hVxlTs3y
	AtYqI1el6zIr0W3zQYSMaTUTuzxuA6f7Olqg3nnh9kDF2PSjnLYsdN96M1GZcjFHw+dEyipM+l1
	asOhCM3E9IN7zEYU2GD0Wi9Iqhfz3FtnbQ==
X-Received: by 2002:a05:7022:3f0c:b0:122:2e4:11db with SMTP id
 a92af1059eb24-1274caa54b9mr281046c88.6.1771363357865; Tue, 17 Feb 2026
 13:22:37 -0800 (PST)
MIME-Version: 1.0
References: <20260213123902.3466040-1-arnd@kernel.org> <20260213085842.0654f70a73ec05d88908ec25@linux-foundation.org>
 <b8f5244e-4ad8-4499-9cc4-c875121cdc2f@app.fastmail.com> <20260213092336.c2b0f2d1be17f1e2e9856f11@linux-foundation.org>
 <CAJj2-QFbx0iRMWQThPDfDJ04hNuZL0Xu-bGGRqGO4b3KgumGSA@mail.gmail.com>
In-Reply-To: <CAJj2-QFbx0iRMWQThPDfDJ04hNuZL0Xu-bGGRqGO4b3KgumGSA@mail.gmail.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Tue, 17 Feb 2026 13:22:01 -0800
X-Gm-Features: AaiRm53jGHGlihc9EP71VWUyZmyeH6xw45cRbipAYaUZYoNsokuMw5tTjVunGt0
Message-ID: <CAJHvVcjtFW86o5FoQC8MMEXCHAC0FviggaQsd5EmiCHP+1fBpg@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning
To: Yuanchu Xie <yuanchu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
	Arnd Bergmann <arnd@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Wei Xu <weixugc@google.com>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kairui Song <kasong@tencent.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Koichiro Den <koichiro.den@canonical.com>, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Bertrand Wlodarczyk <bertrand.wlodarczyk@intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9F3498000B
X-Stat-Signature: fzw35kzgqt1ejtpbkdk5fpoe6u7qin53
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771363359-919738
X-HE-Meta: U2FsdGVkX19UNecyqhvppPt4ujG9Pg6ObUDkt9E6un1N0szv8/Vm3EbygnLF4TNIqWu8el9PxEv4WDA3fPYMz7GkmEXCtf1kAj7156n7oO+s0qAJx0qFiW3ToUAAdh9P23A++9NYETlwXRG9pvrVyBm1O4dCqL0H6nfo3EZACXxs5P7utMwtxnmMF8OIzgJ793F5cvjxA6g/jK7RqRPXXrYbZXb5zn3IMqEnFklNWsqPaGVv3uCdL9Xs9086yWxmAgGoWl8/zIm5TqLoRZpmE/k5fPk2RGN3rcgOKXt6UJmZ7np28qRMFA8q/879H+Kb6UlCnnWOEc2gaM2LFsIIFvUuubpMO9QDC1dUsIW+T9VUXSBXUkZ0lpYIDR6dFPviz0bWnvXLyietDUqpbpIoQxwJWX3ypxVLcSfVi1vGXooLzZ+epQFsx13UmKY5lK4yaNR2Vm7vyXyPQOyPFuq1bNvCti+Ls4KmHZnhYgmhB8fLGTaYhN6i9ygedwjF1ToQKN66t/Zru2KUEGlAy8tKr+AOASXgd0IjwgvUA1kmq1XEAfh9ap9y4JHVe9SYV6l9pSmd3XmpVXpMv15sU5d3V+CCnP/yIKGguPOwbIkrahdllq5l+N6FPRIU9DBhrf6aqvRgnM0RIsBb+GXGS3Xjp3sb/IeuHIx+7NLO4dYTZo5utIW8w4Nmc+mKJ4gV/VBcO2/YYYvX8/n5xxwae1nNSGERuNyihex7qNvakxk3it6KCNno6vbAXO+0PnJIEGBeT4crHuPPIBGdTCJCgx/ll+QRVNh7L/S7pq587jtFbh3jNvWMU0fiaJzt9ctG0HLj4/MCNS6gCnr1wU2y7fUX+dWPe3NjBu1KeE3JNwQFaUDZtTOrCDN70fMhdZG/LuVd2ZgxIgIAVUi3QBf8kWzPfWZPaeqaGO6+OntzsLXTyXeWFNtBX14HMPYgAOXA3aUBh7pyOp7Mwl/68VvycWj
 8Y53LGNc
 nRHgkHUPmXUBsbDTf0svIGl5P1JHWPEpG1ThlE4qoje6PRSn4T5zcwC5rqP6yFe8+j53n/0F+cmBtji8Q/0sT40yTReMzrkghQY2DQh7bYAzChkGhnNRv+yorWrgHoEZAuOEGOhhtkq3Tk4++Zl+lY7gprBx9yWoZdvlpUJXMs1D79NeuFf1BvRouZjW3G38ZeFdsSCeYebYJC5a+emYyVqj6YEHyDgVLqOkuA5sSskhN4+2xxoHyy6pd7ZB4xecDDUCcmZLTVshT9QLO6VhSTNQImtZNUApxEYbGQQSh7axVtffFTO/UG+/MgRp3Xf0cplhePIUao2gkr+FUkpcUk43v5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:55=E2=80=AFPM Yuanchu Xie <yuanchu@google.com> w=
rote:
>
> Hi Andrew and Arnd,
>
> On Fri, Feb 13, 2026 at 11:23=E2=80=AFAM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > On Fri, 13 Feb 2026 18:07:04 +0100 "Arnd Bergmann" <arnd@arndb.de> wrot=
e:
> >
> > > On Fri, Feb 13, 2026, at 17:58, Andrew Morton wrote:
> > > > On Fri, 13 Feb 2026 13:38:56 +0100 Arnd Bergmann <arnd@kernel.org> =
wrote:
> > > >
> > > >> From: Arnd Bergmann <arnd@arndb.de>
> > > >>
> > > >> When the -fsanitize=3Dbounds sanitizer is enabled,
> > > >
> > > > Is this an option in current kernels?
> > >
> > > Yes, this is CONFIG_UBSAN_ARRAY_BOUNDS. The actual warning
> > > only shows up in some configurations with that, so either there
> > > is some other dependency, or an element of chance based on gcc
> > > optimizations.
> >
> > OK, I'll put a cc:stable on this, as people will want to compile older
> > kernels with gcc-16.
> >
> > Aiming for upstreaming into 7.1-rc1 unless it's more urgent than I
> > think.
> >
> > > > Seems a large change just to squish a compiler warning.  People mig=
ht
> > > > prefer a simple
> > > >
> > > > -   struct ctrl_pos sp, pv;
> > > > +   struct ctrl_pos sp, pv =3D {};
> > >
> > > Right, that would clearly also shut up the warning.
> > >
> > > To me this seems less intuitive without an extra comment,
> > > since read_ctrl_pos() is meant to initialize the entire
> > > struct, but please pick whichever you find most readable
> > > here.
> >
> > Let's see what the MGLRU maintainers have to say.
>
> I went over the various cases of read_ctrl_pos and couldn't find
> anything wrong (let me know if I'm mistaken), so this seems like a
> mild compiler bug we're trying to work around. Given it's one single
> version of gcc, I'm a fan of the simple `struct ctrl_pos sp, pv =3D {};`
> with a comment.

Agreed, that simpler change with a comment seems better to me.

I don't necessarily hate the refactor to split up the single /
aggregate cases, but if we were going to do that I'd probably have
aggregate_ctrl_pos call read_ctrl_pos to avoid duplicating the code,
and I'd want to consider marking read_ctrl_pos inline.

But, it does seem like a large delta just to work around a false
positive warning. The simpler change would be easier to backport to
stable too for example. So on balance I'd prefer that.

>
> Thanks,
> Yuanchu

