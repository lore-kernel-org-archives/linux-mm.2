Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CAB4C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54AD26B0255; Tue,  1 Sep 2026 10:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5239B6B0256; Tue,  1 Sep 2026 10:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438E76B0257; Tue,  1 Sep 2026 10:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 151FD6B0255
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:33:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F15C40433
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:33:41 +0000 (UTC)
X-FDA: 85165437042.09.2E705E9
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4C5B3180004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:33:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y3JF4QjP;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cBS1K3vH89cPPG1M+AQoc4jw9SKxnYkckGnojIfP1qw=;
	b=7OjslRctECgsd+FdV7QRH5ca/D0DhDiCQQKrKbW6urpv9EV2TZ+rcLg2eqVVkVJYCG87cD
	njqEwLxMSPVX5jusvcltSELgiuEGmcF47Qz+bFH7xf/fJC+e2rjaAzqyVDIOKwpeVFzoHo
	VNnuG49GSJOjGA+M+PGfS6/3jFl4+rI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788273219;
	b=Co4crslJ8NjcTiLfEr1G/B36ciZfQ2gXgC7pfo9HtWsj3mGHpOkAlx6j8gPOKVlEXVYThL
	fw8SbxUdPNDIPFiYEK32E9acOHUhcmPCjJorHWnnU8acqXBETPiUzMpDARqqnEyZrd2Yv3
	qkyasDpfXFPMz64EHG6v6v/tZF6HgFs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y3JF4QjP;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.161.54 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6b1b1d128a0so685854eaf.0
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 07:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788273218; cv=none;
        d=google.com; s=arc-20260327;
        b=SO05K3rtygni9qC5F1s2Z3quyhhrPGlU06S/uJTEx5V/24iCEnMquxwr3Rtr139kSt
         wKN/T+a5qCHs3WHmEdjpfvHZks+RYs1WFLliHl7qJX+SD6AvUxH5hytS2byd4M9oGgFU
         6j+7xtoM9LcWu79s5uI6BC0qS1cViLj9qpAdfZEondav1n6CTAZeHle7ljuEDiNh9R/+
         2e2kinDEjnuukUjBK9dv8e3X5NIHWRSrYv/2P2jyED94TsADR7CMxrTU9l0c+kdvH6xG
         sMrG1OHhzKAvW5TalT+ICxz+3XQf/AWkKmCCq7qRnYmhmp/+pSEFaC8/86+ppf4ivPk8
         gKHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cBS1K3vH89cPPG1M+AQoc4jw9SKxnYkckGnojIfP1qw=;
        fh=iHcdiLU8UPMEwoQULaeXyVDf+/awcONQY0Dv119UBKk=;
        b=DhSFqTDTEeQBmNTprlZVrQyy6HM0ntJsft5WA0ejy2ScbR2biM7UkKtxpBuydRk8IF
         UGjmfvuqCEwA3Mu1tAkwvrK6eF5/LpoLliF0/eTRk4Jn7Q+XjiOszVuTvxqLwHr48lvE
         EJ/eK655U9TVsHDC6SqyfF0qM4TmmqTtKYGX6/+TuGUTHvsL8lVnYWoSAVxMF6r06LQO
         YBbBy19xTGPuLhGm+NUsKDg6ma9rtkrIVImjb4zsYl425R8Lu4VtzmJnEdfwAiqy0KhM
         6uciZJKTMMGINZRjLd4xmiOePtmsTk+kPSQSfacXObEiAlhfflrR1Ea+/xuwyPlYbVf6
         nftg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788273218; x=1788878018; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cBS1K3vH89cPPG1M+AQoc4jw9SKxnYkckGnojIfP1qw=;
        b=Y3JF4QjPjT/1Fmrd5hn1haTa0BgTcoYQlPB3QQnBmXQouxp3SJOYPbBHZ9HaPs4xXg
         qoYtMNVJGB4xq8Jh1Uig24EJghn7UF/Bp1KGfDLB7LIepZ3raT9ttiIIZts5weg15rwh
         ecPwrq7Q/Lhg4rB/j9WXcSzfPEvJIjVGEp5oRIoaDPx2HoVFMOfYoGnuSwQSZeteGy3u
         Z9Udmp7UacHQqDQBsYOLUX35O1TufPMIk9GLtO3tcpzf3/FD/TZfa4nRR3NHTFcRaaWm
         MFc6auHH4PotT2VUeQ7VAIfHcMmX8Qge/VHQESxn+3dZEiKu9qsI1t9yTQOzVCJ4yYcE
         GwQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788273218; x=1788878018;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cBS1K3vH89cPPG1M+AQoc4jw9SKxnYkckGnojIfP1qw=;
        b=hbqQBbjFOf7SZo4GqA92yhbi9sfPwQRwIMB3f5hQmdtw5LOJeyXupnjO2C1dEP5PhE
         2StsLHU/LACCQaBf0IcdmvBIcrXmsOGIcCCvJbfROwH62K9OEXdL4aWb94eDarkcdiQS
         n+qnPeHJGVkx41OlPmiTB/6dEgAc0ntRCGc9JUokcrCi0KZC/h62iI6dO+CVA/AfO5q2
         UPqvNQMurTWrn4PRMBDCgYVtSCZp9Fwpar2Tqrxwkj9WUREAVL6+1Cv1RFHX4cSLTjkO
         j1lic9lyZFWnMl4QT7A/Od3ATxfezEIMeHEHG/P/9E83O36+vZ/BmuRrxxermrqxxV3J
         Ik8A==
X-Forwarded-Encrypted: i=1; AHgh+RrSBrdMMcI3BnG/NGjjfAMj1hYlrd6KqNcAsWnc9oGtdwe7mYwLUJtRASdP28kspVcRU+gX0klbaA==@kvack.org
X-Gm-Message-State: AFuF++kLkfg2JPm57v/u/9Dx6AVIIr7jqIsKySol+RLRmT938uwsb9+k
	PZzMd7nLgCEE363H/pA5igTSM+Nux3cE5DoWZwPq1Iy6vs6Ca2ki2qJ/z0gTgmko+/Fkm1kKIW/
	TupAmvOOTCXqs6z7ywaqcg1FU6wpVwOpuOnaQw4E=
X-Gm-Gg: AR+sD12a6gjw+pqmnIPBSnJO5O/MRoIhXOxnbiVQITXrgpP9TgL6oU2f8xCR8dK3mSc
	4Ei+GjpgfcH4Fr1f0Z7hRsNlhcDcimSLH1bXNjMpFyed9CJX82ieHO4h2ARjGhyX60nNLY37y2m
	T7VgH+H4FbSpSXizcDjbSxllHSC17DQlOhrT6Wni6qGDeh5C9yhayW3bHhavKfSzQNrMXyCyO5i
	yVChpcu7KGZbJS9WsWIdOG9ksA+bTFSqUdkIjSgn74JZ9sz4w+f/YsEcRpy9B3hWCaV062W9K4t
	M3U2YcK1lTV5lZIx6kI8XZaCb8cgeFxCes+9CaktnynL5t4IfpQbKpZIXRHUnnDB/jJ1Yn4gkQ=
	=
X-Received: by 2002:a05:6820:628:b0:6b1:9b72:213c with SMTP id
 006d021491bc7-6b378158e73mr3825454eaf.3.1788273218048; Tue, 01 Sep 2026
 07:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <20260830114731.8322-2-wujianyue000@gmail.com>
 <CAO9r8zPYZqZ9UsSU9xVcB6=m-uTkucSoPvA5xCB=mMrb9yVD_w@mail.gmail.com>
In-Reply-To: <CAO9r8zPYZqZ9UsSU9xVcB6=m-uTkucSoPvA5xCB=mMrb9yVD_w@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 1 Sep 2026 22:33:25 +0800
X-Gm-Features: AcwNN1XmqDuQ2Lon7txlynZyRZzsoaJEbZa1ROihp9wk8nxKntpYq9IK_bmAxm8
Message-ID: <CAJxJ_jgiNTBxjojc0XVbd5Bx=veDJQSA8YaeVH=QMBzWzrO8vg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/3] mm/zswap: release retired pools via
 queue_rcu_work() instead of synchronize_rcu()
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C5B3180004
X-Stat-Signature: qrggzaycdhue3etb4m3yjdgf76yc7ifx
X-HE-Tag: 1788273219-701654
X-HE-Meta: U2FsdGVkX1/NNXsAC3Au8s1uo1z0YItYNjPerRseJCGMkA1tlt2765uJFH+v/U3SF3LZEsGvYpYxFt5wwUAdl5Ct0ROarllRaDKI20kcjHFJopb1BmUdPqarWZsz4uMT3Zuegc3J2NQez2LV/y9CXlppD6QvnUsk6abrlv5YprC1iXucP6Dq62ro7AEWekL93ngm6w5trYE0i9m3mQhqRBNU2/vu7a5gWsf4Yz+YEat5nLNUOdyh8H+ccjeoy+fQZ7yBmytxl5hxM5KYlTLJi/H8i9OEGaLu/XL08SzkADENeZu9Hb3wCJU11xcBlXDMnolqT3Wk9wPFWLQqMdbgLZaVn2YHJTPVFIMolNqY4m9025BCJm5d7BDAfSGTTSg/2KtUu70zNfKmUMM3GdyRGiQy5gRo0YxfRViNJhoj1AQ/HY86Qjb0lP9gQdzXp5KgV8pz5wBqH0EgxCHdtB7sRxCMnPIZTsjPwLR/7AQXvDdxGf5pKYE3XlhQInfiLfasBDP0JLovua8OkXYeuGAfKuSG1ael7Lqov34Y3FLfZWJt1GldymRNmGC6RGNMyKyN/r5mHws+TqelCi4BdYshpwnPdEQA9yGjNXilCSAL1uXkqCRZX21YszQM7ufEIT6DeQ2H17bhGmUZ1moN3LWLZP8znSACZD51SqTfY4T7XdUcPXLQLxgFjvfm2S46U95Fk22YEz9GH4rMcSxR1XmNxX5yj0b4aGlPVxDolUKErZbz3JRkFF9eAjOA19pD/bP1AoztguhOJj3fT4qHwFf4nV0VknL9E44CvRiPxbARmSl4S3K4ptQBLcnqyXY6whxPIqC0X5dooGM2E10nw3hWtVGvSYSuDvgScdHhlpAKrH8FJ30yCVqxvN7NgiQSq1iOV3Tpm59xXkkKbynXBe2IhAQZ7EQfmk9sy/N3DwHmXGrcvacLVY8zrH0kHkaDLTwririLvLsGt+wcv6aOtk2
 XPZepKGh
 nxwvPmsuUleKkJ7C7XoP1lfQ6mYc3XyKU6IHG64LQLAhScdN98FfwpZFemQKqgegQD5GPvSHwIBG1aPm8YEp0NyGr3JOY2xsRlfPh2w9yipba/Ky6OLhcWu8Vh7h6tHVTNJiPdkkRDTddNlrRWLM/KAEA/tsDgPWQGTDdTUlS78BOBB/8DXRcnpXJfRkyjW+lO43MC9uXhLcXOFc8PO9h95ADheBXPXiivnwcFIdWd8mDvhHzoLl9my+qOAdRWkARowMNnNzG/fMmsy5OMeFddFZcTxNoCgvHBST21NjXWnqweIuvlWzbwOzs6A+/01wU+oKKhoRgRCC3CNPP+DUdVvhvEuEMpzxUJy3OgI4bRetFIK2smeD/SQYcvH3KJdXUodomi7sxmTqeU5BH7yaDVmMbSvJ5PkQONrGk2vdFVjn6MsM3RmdakrMVanRGfayNzYbqp4loUb3eCMSVscoZX0UED8K6P1r3wngEytC/NPk1a49E6iMJQRx/EliBYsigiKmIkZ9wh5tPsWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 11:20=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Sun, Aug 30, 2026 at 4:47=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.co=
m> wrote:
> >
> > When a pool's last reference is dropped, __zswap_pool_empty() removes i=
t
> > from the pool list and schedules __zswap_pool_release(), which calls
> > synchronize_rcu() to wait for readers before tearing the pool down.
> >
> > synchronize_rcu() is a synchronous, potentially long wait.  Replace it
> > with queue_rcu_work(): __zswap_pool_empty() hands the pool to
> > queue_rcu_work(), which waits for a grace period asynchronously and the=
n
> > runs __zswap_pool_release() from a worker for the sleepable teardown
> > (__zswap_pool_empty() can run in atomic context and must not block).
> > The grace-period guarantee is unchanged; the retirement path just no
> > longer blocks on it.
> >
> > Suggested-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
>
> Why are the patches still tagged RFC?
Exactly, should be removed, I dropped the RFC tag in the new version.

> Anyway, with one nit below:
>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
>
> > ---
> >  mm/zswap.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 37f34e406c8e..0bb30e58950a 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -155,7 +155,7 @@ struct zswap_pool {
> >         struct crypto_acomp_ctx __percpu *acomp_ctx;
> >         struct percpu_ref ref;
> >         struct list_head list;
> > -       struct work_struct release_work;
> > +       struct rcu_work release_work;
>
> Seems like the convention is to use rwork in the name instead of work.
Good point, I renamed it to release_rwork in the new version.

Best regards,
Jianyue

