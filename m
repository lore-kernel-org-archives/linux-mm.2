Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D70BCFC294
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43F96B002F; Fri, 21 Nov 2025 11:57:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1B196B0031; Fri, 21 Nov 2025 11:57:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30DC6B008C; Fri, 21 Nov 2025 11:57:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A2FA76B002F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:57:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E8181A0580
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:57:28 +0000 (UTC)
X-FDA: 84135220176.17.A9E706C
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 383B21A0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:57:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ru9SycvS;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763744246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njFup3cLjwHxIn3p8KU09yVQnaMwciw+MjQfHk5ugHE=;
	b=oJf00JVRYATyXYcWq06aPCbkN1S098nQJSytwBXFLqGR+x4AyZYLBbDURoABo3MtOiQMjp
	9z4djJZthxBPdLjECw1NakTvUg7M95h/woQaYLwQGcbwDsLdidDS9f2d7kKuRGlNp896Oq
	TD7PLvF7B/ADZg7ZFH9weYsAq7V1OUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763744246; a=rsa-sha256;
	cv=none;
	b=w7va7GoNNsJVDsc3PiogqO50sYZPITw78oHE31bDgYKc9fcpZDl52NPINE08/JvX5vBAuP
	mKXSBI3JCoIMQjAaHn4NBIACf0M6lvGyM9BX6MCvsKe5fKNpN4BcDO0cay4er3LI9gpaeo
	dLy4mNMYV9CEE8JK2noHWEOi7RazdhE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ru9SycvS;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b472842981fso285362466b.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 08:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763744244; x=1764349044; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njFup3cLjwHxIn3p8KU09yVQnaMwciw+MjQfHk5ugHE=;
        b=Ru9SycvSo296SgOwYHHeTQb1o1ZikXnZdX7SFhSgK2ZbfNzOV5fh+OZ9oWYYtOPPDs
         BvUvSnrbu2af5A7A046x6Tm07AZ+lV5P0MHF7Komcfr6Sxlk3mbEApaVpkPUuBbDxPxB
         tW97yS35+Rx3TO4TOIFhe4UVYqxt8BrOmli2eAUdS2mogTtrqGV+EiKEnFcjabX47Fzc
         tmilxhHWcewFKv6pRkmup6CRc2Wo6hEn2TPSpkIgMDXHQDaJTCVRJMKpTHsSBGjoTa5a
         iPIOZGwjsCJh/xCdRVu3MOootJ3Ryc7q+Is/C10JJVrm62lLdlxpKDB8u5nf8j3KSYM1
         t+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763744244; x=1764349044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=njFup3cLjwHxIn3p8KU09yVQnaMwciw+MjQfHk5ugHE=;
        b=am38wHE19yT2GO7PnadF9kKKCNjsHgP+DuW63Bd0RycSW1aIAQJzyqEbHQukMI9UiK
         YHgZczc11etrD5TXO5DRfFHBt6EE+iGzKc/n77cI8RonF5prYSN68uUIvT8JzmKixHgA
         3tcRry+g9GPIW+Mhyk/zsr6PMa/HkkjhM9MbfVb8fsHPgOMe3B/lMqQXgCVeNi5EVoZT
         3HHjlRmOnAN90aIXDFwhm4TM//E65Uvu9M8oIgg3FZkdaBc91cYvh2VfnmgNvnt1S/p0
         7CInH7mm9kQLl4gRrp3T6A83/4gzavoBwDnYQSNKuNlQ2MPZhpzJBmWyek1Bjj+SXM2p
         iOCg==
X-Forwarded-Encrypted: i=1; AJvYcCVG8+6eSV4bwunqIvvrblxdqG7NsYEigeMvWPCe4cKgfHjUOgYO+H/rl/BylZaCshsBZLqma2hBMg==@kvack.org
X-Gm-Message-State: AOJu0YziMzoJfAsNBv1AN/R2gmHUtM0P/5ztNuhnRs2RabxKJPaZYDYX
	CTcZ8DZ20f8h2/qKD1PrbGOWmuts+fS/G8mGK1JBessm3WG9XgDxgtyK1+O/43VdwPWFXB+82qg
	pZp6Rzpz5Wpx7fTqpJy84igs18KB1PPk=
X-Gm-Gg: ASbGncsQqY5SqRx9BWGZOB+KCEAYz6QAW/kb1uTni8YWrkUiz7C1w01EsEIc4ND0SSs
	JOH20vCeirxc3CHvTbbERc7SPgJCe3hkdnDeAHxhaanBE4g3ZWKW7F7aLazKAYFZToQwzkCStt9
	6X5+flwN2GffsTmqZTnCuj9EW4+L9u1o4bVXA7NI0UHwTATZVNPoYRRQ0F7al/S0pJTtrh5qBLP
	vpitNGwPbFGY8RqKNfIBLjmENICZvkXxToSDvFkniivUA0HwXjauHEBetEc7SBL1vdFBPPaCKQN
	WXgqo3amPuuS22yhNEftbLBKrOfoOFc=
X-Google-Smtp-Source: AGHT+IFXBB8xZb4zfndX5tepAjmYqV8xwIlOQambPbarzMMFklf23b1YKoD52jlwRhNpWm/We5d3CKrKzeQ92cJ6rlM=
X-Received: by 2002:a17:907:3f0a:b0:b73:780d:2bcf with SMTP id
 a640c23a62f3a-b76715ab995mr334164266b.16.1763744244328; Fri, 21 Nov 2025
 08:57:24 -0800 (PST)
MIME-Version: 1.0
References: <20251119114136.594108-1-youngjun.park@lge.com>
 <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com>
 <aR53i1G45XAqCzBd@yjaykim-PowerEdge-T330> <CAMgjq7C_ebrZv73VNBk-mhaSJwQXJur96R2OdW96YCM7vtJkzw@mail.gmail.com>
 <aSAMu04In6dLboPs@yjaykim-PowerEdge-T330>
In-Reply-To: <aSAMu04In6dLboPs@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 22 Nov 2025 00:56:47 +0800
X-Gm-Features: AWmQ_bnlyhcp0spM9YtYdXyo-Vtpzcpf2Tw2kWOGqX2zjm7s48e0HsaK2_gbBK8
Message-ID: <CAMgjq7A3vT027g0gJaBG8YBMeTZOLPP8e8KDkNX+foJ7cgJSZw@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qws9cqijzs39dmkgnna68fta65e76erk
X-Rspam-User: 
X-Rspamd-Queue-Id: 383B21A0008
X-Rspamd-Server: rspam01
X-HE-Tag: 1763744245-255158
X-HE-Meta: U2FsdGVkX18VrSMjwjo84YWLr5g4gJ8+PFrdUa85Ey1dKWOhkGCCUziUHWH0yJmUdKXowSviE/j36Y5gIC0IGPk+MPXhgr31hpAeeoCIBdw41Ce3R6NPU7rNgOX5f4n5Utar7LKDKUtuJRKVv5/OgEcvzFm7bwWNahOEOJ/wpRpe7JfZPTYqYLcwPM8/1Lz/Ar0vQb5eeVaC5kO+Q/Mhf+pnF3PcObFPSeQ7CyqPI8rean58+GlbMAX49cPQOauEb/lkQc9tPRcZLHBHmb9aDt8hKC6qW0WfYkHGMMkJiHkiWJN0MLr/x2SzVGCrh2POvvurJJpxo486bhO+YRO0U3M+Pn39IdoNMP6zciOB4iMkay6Pr7QBoXEmOZB8OA5rI5u5/VVP4i7SZTQ3bOspvC1LgipOoca9OcJWESUxRphuipS0fOPPaWyQBcgfAtaQFTkyPj7p3aKcPyQfYqErzmThxBKmxmvLDtK98OODMvWjUMb9WGM935cDg5Ys9e2FLvd0rp5Qw35d6iVSyV5gBW0RSzh+tH9Usn67N6rbkdI2hAkg3jdi+AzlEFz8BOPc0N6HF7CO+DxrFBIbTYf2QO0yyvjaoYRMxkGrYdCNKj5Jrz1n8YM7vp0cx+ij/76UqkEiLEIVSRtawGtFpbp4/92WDTh6EUGqw9d3CPwyqdvrTfMn8EBVRNFM9BN98NDIFHTmhAyUm4bQdRF+iw+V0zM0SIhFoHMydVh+X8FsvGqE0DOk+JtbsKobxz5xwPBnwOtD27h4r3cdDQi7CTFIo4paIx7loYpeNq8K01D88MqKoTUwcbflxmwj5OgfS75c9tuoE9Enzq9sIUR9zlc7FYEwYcuSI7ZqU3aWLbQb+7nWtjs+b+j4nmeOIDLvq5165G3JPduiMYwb/eyWwaB7Sl8KmPFKRaSWPdHHqrqt4/w6aJfmhzYPWeR9eiG0kZYbhKjyJ18xfhBfZFlUeIb
 OAvQf/nW
 9+wxT1v8yCmUwsPbbtVtMW7BF8u761wuS+bj5RFbFwCK+UfoDVxJnagG3h/sXNgvWfIEmoD0V+SvTIDPYXqaZhIqFKUha4I04lFisMifrBt9wqQ5wwWNNWWgPELYeGdZqMDdRIHMYq+oIJes6QzdxorGQ5BQBgvoOz/CYi7MkPt75ZIb4ny+/gHrHTjFdxEiJaCUIyFx958saWsppzuLFd45hWICOD0VQNpcN+SVJJ0W6owLYfluCaphkd8BVvQ6MOCJpscYey7pQ9wzrYAX62hBvReQeNPT0I4rl+WdOdjn+TAuHYy05JKHLDxNddZxCNOuu5cv6UOINQMuvgXPUie3/TrAVPlq9SzarmGFSk2f83vMJ7DAgk2birFDqxpoqEIA+DH8RjsIABGzjkzLy6ipPrzWFLIAwZoSxiyPQEduHRk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 2:54=E2=80=AFPM YoungJun Park <youngjun.park@lge.co=
m> wrote:
>
> On Thu, Nov 20, 2025 at 10:18:34AM +0800, Kairui Song wrote:
> > On Thu, Nov 20, 2025 at 10:06=E2=80=AFAM YoungJun Park <youngjun.park@l=
ge.com> wrote:
> > >
> > > I've investigated this further and noticed something about swap_sync_=
discard.
> > > During iteration, it doesn't perform an empty check on swap devices. =
As a
> > > result, if the iteration exits because the next device is full
> > > (deleted by plist at this time), the
> > > operation(swap I/O) fails even when other available swap devices rema=
in.
> > >
> > > Should this be addressed?
> > >
> > > Best Regards,
> > > Youngjun Park
> >
> > Actually after thinking about it again, swap_sync_discard should be
> > looking at swap_active_head, not swap_avail_head. Changing to
> > swap_active_head and also checking SWP_WRITEOK is a right fix I think,
> > and should be good enough.
> >
>
> Hi Kairui,
>
> Let me confirm if I understand your intention correctly.
>
> It seems the following changes would be made:
> - Change from swap_avail_lock to swap_lock
> - After sync_discard, reacquire the lock and check if the list was
>   broken using SWP_WRITEOK instead. If broken, since we can't know
>   the next si, restart the list traversal from the beginning.
>
> The advantage would be that it's only affected by swapoff changes,
> so exceptional condition checks in this logic would occur less
> frequently. Also, using swap_lock would be better in terms of
> contention compared to swap I/O contention.

Yes, swap_lock is better here, I should use that but somehow forgot
about it while working on something else, thanks for helping out!

And maybe you don't need the `SWP_WRITEOK` change, I was thinking that
swapoff sets ~SWP_WRITEOK and then takes the device off
swap_active_head, so to follow that convention you better check the
flag. But actually no, that's not related, the existing
get_swap_device_info is good enough.

Checking `plist_node_empty(&next->list)` just like what you are doing
here is the right way I think.

Thanks!

