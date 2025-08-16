Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1FBCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 01:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BA48E0009; Fri, 15 Aug 2025 21:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5635C8E0008; Fri, 15 Aug 2025 21:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478A68E0009; Fri, 15 Aug 2025 21:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 358B18E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:30:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B51D1C032E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:30:55 +0000 (UTC)
X-FDA: 83780891670.16.E6F9E9A
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id D7BBD1C000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:30:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dkqvPrz7;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755307853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/CwBn+YcCO6JV4jisWik5fIvA0H3kWFj1sB20Yoeko=;
	b=v/+5cu8oVbaBRbbkBLGmi6Jp4RHAbwMbLCuDqjgwdbxw5fBBqgjpCRQLJZHEt69YvESJXg
	eyE9thvheVrX8a8Rcfl+X3XVwjNQI+q4qXfRyA8adyE7CPUzYBlR+mewVg6Zf3nacpSWIv
	mjMX0HNPK//7qXvHWrGy3e4gA0qvRHg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755307853; a=rsa-sha256;
	cv=none;
	b=sh0mofdZEaOspzSB3VQGJZiul8KkCPGTiMcTrqACckOauFqCQjH3lkTwEZWxE9ofNtTb0s
	Ll0TfSEDH+MjTr2rJsz87A+8HVftbe7fDXSApMAulC5dI9UWKnRz5wjzNg3ROGT0TTwq4K
	gHoy4UuWRwWEbBW4o2jgLItbCOuJwMU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dkqvPrz7;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-30cce5c7f1eso2224578fac.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755307853; x=1755912653; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t/CwBn+YcCO6JV4jisWik5fIvA0H3kWFj1sB20Yoeko=;
        b=dkqvPrz7xiJfSDnxtTFnrHiiqNWiApIvaSVtEsdllsuSfnh+3RZiKBYrDjggUoWMpe
         ZcYK1T+2vcxP2M+9Z0BdQ5rlj5zy8I4MKy5qGJhDHh7TBBjXgZrEcR5W4tcU3LWk/nWr
         jtYj9sOxiDe1A42uZlPR6g8vqtQzjOKG5T4BPYU3vzR/DwbNpZGOWwQAHjgwmA1yk1Md
         IYkLnnu8je4B9WQBVtEMRevg6VJ5RQ/bMSof0+PevsXSzkX6rtL4OfxuKysr8tsNz8t1
         O9qDOK+y4OZeAZUPKtz2gCdyEz3wPKcJBKGgsouGCN5rGasTCgnoxs0nXsQ9HsviMXJB
         pjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755307853; x=1755912653;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t/CwBn+YcCO6JV4jisWik5fIvA0H3kWFj1sB20Yoeko=;
        b=Zk6yEPRFZFtxdw3pT4OPLzquFcAItEXHcpXr1CmXboe6lxgDNN4klH5OBwNezHgHHq
         NsOT9shTFMamNh4MgbkD5FcadZPjp+WnyOo6BA4qbIefDVSeXS4VI9xW13bbpEp3Q4+E
         klnQRLMBPxSPWU+xjOWxLa2ZTiTjQsIyxbTXx6/GVp5BpgTfUHZ+FYLo+umJ5WxjGpd0
         QgMYaPELS5mPxn38+haWpwH/FuPo0zVp2N2Z6hhDfVE7Udoa1KfdmB2/EARmoWhVKE49
         mMA3vbGhki0XYKaERUr3CzC1BAWLxEaICU9cbN0Cv+3AuHBMgS2okXkz7Qp6rWmV9+QG
         FKdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrLkP4oky3DRSjK0l29RdHdIFA1JonScx7HTQYYoXv0iJyXE2aLtobRSTrg6NIZ/tKkTwNbxmhYQ==@kvack.org
X-Gm-Message-State: AOJu0YwdqvxfH3V0nONXzAbbsJEiW5g97mMUGHiK2vs4mFVX58RNa/RJ
	NT8BFjpUvJZaiygbCvseO2jAEQwx5x9nHgPOFmhTw1HiYzgN3gUMd3x48KZ6gd4yI7Wb1CBtS19
	O1eQlR4srLi/LynIm3wre4S2FbLz/oURObEw4sfA=
X-Gm-Gg: ASbGncuPsdPaGoayeiUipL7ZS8sYWcvjJeDJ3Cay3lG7+F7LK5J/JTKJkbnTiwwzjP0
	p1b7IK2SdPjxhoAO5uSX7LcJq6Uh4L20PRYwo32CTEQHMO7DiYvcpbvzBcF2m0xtzQ52HN9Gvzi
	tw0q7Vw+f+JD7xsrAUqLBWlApCf9gLiqFp8rNcmCINDP2UJw9qjqPRpb9qZC3B9FkmE/fcMuVB0
	oVM
X-Google-Smtp-Source: AGHT+IFTL4O6BM7sru0nNSKWfEL5peva6qbLK5rXN51+T2LoeUfhLq7TftPFhhVyDrpMjVJ/Rgpuz3PQzRnrnzVW6EM=
X-Received: by 2002:a05:6870:4207:b0:30b:9a9c:72 with SMTP id
 586e51a60fabf-310a8fdfde0mr2870218fac.0.1755307852845; Fri, 15 Aug 2025
 18:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250815094029.133063-1-ekffu200098@gmail.com> <20250815170948.16297-1-sj@kernel.org>
In-Reply-To: <20250815170948.16297-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sat, 16 Aug 2025 10:30:40 +0900
X-Gm-Features: Ac12FXyE1zepZtOUbqgmIaJ_8ZeEVtEiL0AQlMufTTlh0_lT6WJNYTC5ksCGeLI
Message-ID: <CABFDxMG+3trM45T_1L0_dv0ibQC2j_XXCeGEwY5RR8a8HZmoYQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/damon: change wrong json.dump usage to json.dumps
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7BBD1C000A
X-Stat-Signature: e7uzusofi9dwppbb1fa4ob957e5hay98
X-HE-Tag: 1755307853-381651
X-HE-Meta: U2FsdGVkX19X0ACj0gphPj/LcWmmx4MpqR3obcCOfYkkywSJ94WF6vbpxc/gGQrJQVJjEhIZ3pIwfPxjcCTsd8GSWFXm9hWDzA5rqSKRMiQ1Oyv5+2F6vmJyXHnRgXvNVn+RlIYlWeIfOii5hY9JN6bmIexlZKgwIRifCbr/uZpTPgL/rzJL9cWyMUAfR4Z01c4MFWLF95HQONSJtl4cndwV2eQkkrtNCZ4Oex3BbepypoCOWyMlt9j4A14Dw0Hda7eqEJ9xUMpXgJ5xuFl59Wo9mHh3/a+yyHofvyTaIOHI7Zql69ALWsaY2uWKieo+7e3QtaFwTY8WBhqW+0VUVCmhnMTxRwISGRGWiPEjMh0ylqzEvvapp+ck7DyLBmtTNrYaTz6mBxSkgRY3T0QBKixbkppcDOdZr2wqCruRWDya2Q8wBLMZG04Z68agiIGLB6E0Dmz25eOGfd36bP+WToNSU9GzJzBUE0cblp554aQeWme5ZtANmGuHYR35qSjkU6Z7MhFCjPZu+vrcG0C2xJWIyoxh5qQ90V6sC/wYhXTZ7zMpeHTWfP4lssUW54oIWhlBU5XrxTL/ZXTD+MEpbwNNzJeOASXjwGcXBLcwUcVaHdqwdK1/9MHkO7Zq+U7WLdh+IJOaKAJFGgkyGufwh9ElZVBngGMz+6QMEfe4fE+fuOfn2TkRr3ux7eQ96ZVq2PwnRGnb/m1FjazyEinwF1BRB/jQL5ZTDRNnC4L+QjX+RyP/6NzInwRLGYe6JaPlwsMWuQlfWOhbUMfgwvlQEH1rXIui2X6M+Ve5lf3z03eSitIgA9Nw8owYYSSM00KI+8uS/BKMLxqsyYZtwsMnXQ9JnM443zskZ7eULUEtUxfAoYIGnyMATDdL2oIWkyGnOoWjbTG0ixKV8RYOCDwv+/GX0CHQki7EA3bDqA5ohruvYl3gQ8z15cDCQfcYCxOEMO4vImqZsj3mRNemMCS
 R579jJlv
 thOy3q0pH9pc8Z19PWF0S5h3HvREbLhZkfkBh8F4OVNd5KI+PAIvIGYrcb6+rdeQibhlcLla8USCM8igcUhlHuTklv6sf2v+0C7aPzukYcW8SgcGqAA31tIhMt3ZmUh7wFY9oKJnE/36l/gcNAkX/JnlEM6BSaZmt2hTBS0+RNq0sI37V+HzdrrF21lGhwkF3kVjOBUKGIvnfuyizfoZeiyttHpHAsHErTCzcyLCXlD0KmmweoFcz2bG7f74W1RfnCrs5ceazxe9nqVG5OR66QA3XJQdk/pCKu3/nWHFQB1W65KGJRa/QA7Fxy4XHwje1jliBp1p8O54TpzzR2ddXvL80QBNkkWIh1z+VRjSnZrWbsL5hUfRDD7WU3uKE0phVgk6TrZwmf5/dU+exFaUCQrVzSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 2:09=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Fri, 15 Aug 2025 18:40:29 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > To print drgn status to stdout json.dumps should be used without
> > json.dump. Change incorrect function call by typo.
> >
> > Fixes: 441f487d6ebf ("selftests/damon: test no-op commit broke DAMON st=
atus")
>
> Seems the fixee commit is on mm-unstable now.  Since this commit ids on t=
he
> tree is unreliable, I usually add a comment, like below.
>
>     Fixes: 441f487d6ebf ("selftests/damon: test no-op commit broke DAMON =
status") # mm-unstable

I'll keep it my mind.

> Also, add the destination branch on patch subject prefix, like,
>
>     [PATCH mm-unstable] selftests/damon: change wrong json.dump usage to =
json.dumps
>
> These are only my personal and undocumented conventions.  I'm not sure if=
 this
> helps others, but it would help me.  Please consider using these conventi=
ons
> for DAMON patches in future.  I'll document this on DAMON maintainer-prof=
ile
> document.

Sure, I'll follow your convention. Maybe If I don't follow, it just
means that I couldn't understand your comment and future document
well, haha.

> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
> > ---
> > First I'm sorry that make you guys work twice. This is fix of my last
> > patch [1]. I'll be more careful next time.
> >
> > [1] https://lore.kernel.org/damon/20250810124354.16456-1-ekffu200098@gm=
ail.com/
>
> Thank you for clarifying the context.
>

The pleasure is mine.

> Thanks,
> SJ
>
> [...]

Best Regards.
Sang-Heon Jeon

