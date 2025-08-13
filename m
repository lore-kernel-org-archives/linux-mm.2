Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CDACA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 02:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1518290002C; Tue, 12 Aug 2025 22:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102968E019E; Tue, 12 Aug 2025 22:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F2590002C; Tue, 12 Aug 2025 22:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E97D08E019E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 22:24:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96BA81A021F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:24:41 +0000 (UTC)
X-FDA: 83770140762.25.AC6BEBB
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id AAD48160011
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:24:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IM1paVWk;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755051879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VUdHryMevSnkSUQXfqfkpLgibxm8gD25NgpI/OeKaw=;
	b=yg25POdB0sDM10aO5+Pr8EFhYhifLsn14+fPQ02YJDszv6OBQxRFxktV5t+QmBbT7UqLHK
	XX9YFNcoXyI2NrKSIWZPtnOnLKuThrr72cH/9B4xWYGv4OJpjQrNgqoVoA67Jk2p2AS69u
	zlByxwQ7EArn9cY+D8TWkEp+SiForrs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IM1paVWk;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755051879; a=rsa-sha256;
	cv=none;
	b=x6JxFwALpwl+xvErZr0wCRyXSc35hoR+79YN5zWlB5PoXPywC1Zu5OE6UJi98WQFIZnfDj
	yYm6TnEVRZX/Rkini/qJiIIvfjWNLi/zOJZUEYKcXEPrWxmGcnpJCPyjmqXhqf7dqZnUzP
	vrB5ePsFaCOj817672GmmHlZr6sy1co=
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-30c27db3739so7098608fac.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 19:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755051878; x=1755656678; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+VUdHryMevSnkSUQXfqfkpLgibxm8gD25NgpI/OeKaw=;
        b=IM1paVWkYNRWtgxyP10QryyNk1bUtRWMDb4313Zz9yUmGEjPHXqIyewmSUDhBOhq5J
         jkVT04uiv4ubNJdOh8xsWqDL5L378QbrTEB/s6OKfiagbTGcXNEcFYBeAJiq+UoWBiLG
         wfWaF9H0CCxL4mEWAcUVqU8Mm73+0HB20pboM/QwbgxJMZgbbX5cVjGuINNNE9r8J8kK
         Cb92N+BksGY0mm+y5b3gZcYdJPYUiWjvTv3iUqvDIJ631smn+Au3v8xlZG9wSDfXFBQ8
         S9ELTnYr9pqxjHkqSxeK7teZ+sbY7cl3BadvllflmWCT19tecqAazY05aHZNPU2QTqL9
         sEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755051878; x=1755656678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+VUdHryMevSnkSUQXfqfkpLgibxm8gD25NgpI/OeKaw=;
        b=dbCjqv2TGl1j+/yzca56raa4qtEVBcoemazFpqnTZLFDHafNeZCX+sz6l/eMI65uyd
         BIjJT1kuL0xdwQ3G+8mKX0At9Ou4FgWvuyHPBCKseNq2X4kHzaygMPYOH91OAbszd9L6
         Y0UEU7bULEOjft3Cil4XO8L4pQMQVEiZVRwpxsj7V54QRfkQDsEY7TwkLkqdVZJaJMQV
         j+hS9MdK3vB4JyoqsoVjAptC9yjvlJE7/VObRQwAejHrzpttnngX0Wq/Tm5FuErrlv5C
         +KhTE+WGHmRPV+iLmOBkSp9GHizYmoq+2VvQWvd0N7SDd8EUuuIWFB9kmOc2vfTEniv0
         zPhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq9YfWgCCLsploI1DtNEPi7JBsZU1PtIyYiL8RXFQB2iDLtrs6jt1jGwZDNuWr+gijN5oF+BHvOg==@kvack.org
X-Gm-Message-State: AOJu0YydxmV752v+T1L1NP5LaqzY0owu2DLXY67JXyQJM5RWpTyUp/61
	fnq9RzcVrqdfWYsVykoSWpVvC7gocytr0ZfRmi5VeU9SWjO6hJ/pZPGEpy+lgwuuEQ5cgRl+9jQ
	ujxuWvHyXdcETmNnCevMb/7QGBqEsdGs=
X-Gm-Gg: ASbGncv/kJJuOzt112VyfWgw2BMWQ4o2f4n3r9JBuORFq9iSqjYy+ROdijrCYUmne0A
	VZFTKf/O/Na2QpJYFe4KSX9+h70nwqszxf+MVdsKyLKhJO9TBi3SPSLiiw/jjxfnuok6ELcDsZy
	APfZrd2k5Ejm5Zz5X1G3UXz3fCYwGxc/OrXxRjQwWhvc5yByqkdxr8BaQlDMuOss1gAp0vKOWed
	uH2
X-Google-Smtp-Source: AGHT+IGo0XTp+5w595RCq2CoK5dGZMCCP0MpxcQ8TZ4Nkp5UFiu/yt0+lGrUcMdti9MBUGKXosrQajwecyB8b8fBIsc=
X-Received: by 2002:a05:6870:f691:b0:30b:dc26:41c4 with SMTP id
 586e51a60fabf-30cb5d8294dmr771857fac.40.1755051878619; Tue, 12 Aug 2025
 19:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250812140046.660486-1-ekffu200098@gmail.com> <20250812175939.57506-1-sj@kernel.org>
In-Reply-To: <20250812175939.57506-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Wed, 13 Aug 2025 11:24:27 +0900
X-Gm-Features: Ac12FXwjHQssL_GWAi9wQ4Imzh4-_JaTL63Mge2i3rUa0DLMiUFRVU7qx9boE0k
Message-ID: <CABFDxMF=-Fb56zSnGVvqXRrDXh-3vFzQmhuLNDYEzFv4z-bsuQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/damon: fix selftests by installing drgn related script
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ob765w3p9iaq39b9owrig93pkhd3key3
X-Rspam-User: 
X-Rspamd-Queue-Id: AAD48160011
X-Rspamd-Server: rspam01
X-HE-Tag: 1755051879-413434
X-HE-Meta: U2FsdGVkX18iLNDLJ0Q/74wT5IwbuBMSgfJFPWrTj6blfDoBW7RB7hDQD1HA+qWZlue1NDMgdOEiK0WHvyDowTBDwitT4LrsVvPv/vePNLm0CIEHt2xSoEfyRwMcziDrBMWeKZb9MlLVrJcMd/f6MzGMymn/onfpbB+L2oF91junM7jIz4IpFCX6dSeYO9vfuPohDwC93MeCcte2YQgSkU7WNqFmyGA8ca4jVNty6WK1glnzHhqr+tm1y0G6V9welGw+rYckwV7twf44COihMDz9eFMsaYc8Kkqwet0AJJ9TiLrQCZpvW/kgLWSRZZvUF27QCIifUDoUv37saGx7hI48Ah/yaRReLuPmsp6zw2d81Lb+xw/wr2v0aX/ZO9h4cefH013LeRStdBx4QgieiY+CF2ZRpO8Og2f8AJFhFt8Taiy+xaZ5JMTR/UpD2i3+NL2YGyTWQ0coLbYkp22J8jv9uJjWD7IQqzw41zqk0xcIOTLD3xAOLZ9btfS7PnjjkM1RljZCkMb8IPvYWdRbigpE30MbSU6cLwFQ7CujxpfgXY3VaOQP3+TUjM4AKxlZIKbw0MZ+tHy+Obk/9wc8i2pNhKOkVkqQWJU6A6z7s0AdFaDd629pBaqDUI/pVpaI/PKHvjK4v1RxDvnzDhha/KCiRWAlhiw5OSpRwievn4P9vC95BCwTG5ATCD5XGLihc9tOP4pT4r9fmSP9nMkM/fPJnBknJJ5YKpSNRbzlFW8eb6lWk5MlvUep4vVDWW0NfV3O6ktoibZMnpaAAItMozjSWCh1/OnGD58AB7Cbpbf4b5GkU3HqtGWOREhj3r5QM3XRDrpJl4Kz2vh9SOncpax1q6R8EXQ2xY+RFWISu2iF2/c9YYsewSuHM/IPOTYuQmtHhfudbHPq5sazeU8zE3vP4M5BDeHmBUQPPQm/6XJ62Nty2GiYW3Ullhp3uDb0F33sqnBTbvfn9iURBrj
 EjRjIW8X
 +qhKWOI1YlvxtaaBfIKM3dC0mDK1elL9/O+G3upwjBTd8GlSpoIGboA7vd48qts/Ig3VKrK63zLcDsxDL35jH40HGSNzOzzYrq6Shv1UgqFid7geF/bpM7QdKHydWr44Rc/bB+PIlCXAs6fvUCJKpOf6nUAjhdO4CUPhRmq1b/lxwMBfstWT1tg09PwZ5yupixWreib/ItKCQUIGJgo3O4goe1qrOx7pMy8bcooMu7afY3Ri5D9Z0vFEDBp8s2X4F4i2JiH149KpuS/sU4amexotw0iWLGJNh3T11r40n9J7Zpwa+iUMsmUE0JlGGs6iymmg3vbKrcn34fNGskYYb3Nn44G/38+wfpbINaqApp95QEF2JuUI2RcgFyuuy55N18LSM+ikuzOVphof4bOQzfkpLW9MAekVha5uQPK2KjbLenrFPRMG5EwyzvskMVnsoLtPopIIv4aZEtkPsDZpVHe6q7RR+xaEmV9ZmYKn5mmMrpPc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae

On Wed, Aug 13, 2025 at 2:59=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Tue, 12 Aug 2025 23:00:46 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > drgn_dump_damon_status is not installed while kselftest setup.
> > It can breaks other tests which depend on drgn_dump_damon_status.
> > Install drgn_dump_damon_status files to fix broken test.
>
> This patch conflicts with the similar one from Alexandre Ghiti.  Could yo=
u
> please rebase yours on top of Alexandre's one (and mention the dependency=
 on
> the comment section under '---' line), unless Andrew resolves the conflic=
t on
> his own?

Oh, I didn't know that I can use the baseline with an unmerged patch.
As your solution, I can avoid conflict (This time Andrew already did
it) Thanks for letting me know. I'll keep that in my mind as well.

> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
> > ---
> > While setup kselftest executable environment and test this patch [1],
> > I found similiar issue. Honestly, I don't know exact solution for this
> > situation. So I just make a new patch. Sorry if it is wrong direction,
> > then please let me know how to do next.
> >
> > [1] https://lore.kernel.org/damon/20250812-alex-fixes_manual-v1-1-c4e99=
b1f80e4@rivosinc.com/
>
> For patches that you are not really confident about and hence not insisti=
ng to
> merge as-is, but wanna ask other's opinions first, you can ask questions =
via
> plain text mails, or post patches with RFC tag on the subject.

My meaning of "don't know exact solution" was about conflict patch
(Now I read again, I think other people might be confused. That's you,
sob) I will use the method mentioned above from now on. Anyway, thanks
for reminding me about RFC.

> I think this is the right patch, though.
>
> You could refer to the TEST_FILES part of documentation[1] and "Install
> selftests" section on the document for more details.

Thank you for this comment too, and for your always kindness.

> [1] https://origin.kernel.org/doc/html/latest/dev-tools/kselftest.html#co=
ntributing-new-tests-details
>
>
> Thanks,
> SJ
>
> [...]

Best Regards.
Sang-Heon Jeon

