Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE44D606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=MsR4MwTB
Received: by kanga.kvack.org (Postfix)
	id 045B86B0B47; Fri, 23 Oct 2026 07:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39376B0B48; Fri, 23 Oct 2026 07:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28846B0B49; Fri, 23 Oct 2026 07:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C00C16B0B47
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:41:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 488E980388
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:41:12 +0000 (UTC)
X-FDA: 85353699984.04.A79F34D
Received: from r3-25.sinamail.sina.com.cn (r3-25.sinamail.sina.com.cn [202.108.3.25])
	by imf21.hostedemail.com (Postfix) with ESMTP id E2BEB1C000E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:41:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=MsR4MwTB;
	spf=pass (imf21.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.25 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792755670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cygoKyDem6jl3IIN+AbxX+FnzVwflEWGyoiGRY80Yg=;
	b=ugQ1uKZW4kuEtGnRpWhfGDadAcTqFVQApKszr5K1xZYoYQlBEhvwWfmYSkxWtPab7ewOJ1
	F3g0q7PdH2nTO+Ntr7waFazlIbClNYqB1Rrok0QKb0sR1JcLf9gDnS1GewaN+kzXDlvCpO
	SwNyDbb3tCE9RicAUOAnekkygON6MI0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792755670;
	b=Mn5cKAkxq5WTCgO2QMkYI8wjb/zbsoBI9Qgf/G4mPWH0tqgZFSNgluTIXlCjD/rOkuAWLY
	Y78oz4lIjMRcoj6CG8vzc6yd4ZqF6aYeMM3/maUxKOa/6De94lvf9CWLyrMpoioh1Tg5+n
	ysjt2OhpnAxzUy0XOCax8qeMUC0LQEE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=MsR4MwTB;
	spf=pass (imf21.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.25 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792755669;
	bh=5cygoKyDem6jl3IIN+AbxX+FnzVwflEWGyoiGRY80Yg=;
	h=From:Subject:Date:Message-ID;
	b=MsR4MwTBrxCZL78IJj2RpIckRi97ITmw4YVnmopelvHAB4X7AS8Bnuun6inDVY9jF
	 Y49T4L0rr3BIrK8cHulXNWOBGLaWUv5ZtKl1yVK57Yberqwj3q6tCfSl5NA1tWadb7
	 2vpUAudzzbSgWFuvsKWmEYJGm79kmtK7Fp4toiZQ=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([221.216.116.244])
	by sina.com (10.54.253.31) with ESMTP
	id 6ADB47CC00006537; Fri, 23 Oct 2026 19:41:04 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 5283336815912
X-SMAIL-UIID: 834902246C7247D7A48A785F4A216E1C-20261023-194104-1
From: Hillf Danton <hdanton@sina.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <21cnbao@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Fri, 23 Oct 2026 19:40:49 +0800
Message-ID: <20261023114050.1011-1-hdanton@sina.com>
In-Reply-To: <atrnvuQkeldgPqH5@google.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2BEB1C000E
X-Stat-Signature: w96c9qcdkcmmbrx9rb9a9opyu5547m3c
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792755668-826086
X-HE-Meta: U2FsdGVkX19dczQPAL+Pdxc64aG16pGwoD7tHWFBwNY5GRyxFMY1sdu9M3CugYt1wEzRnCwROUt1pxEdYjIFrtLpfTDPJi5+jKR8/Ay9E0kGuFRkWlbZk/5zkSO7J/SJfzpVhpDKm0MpmeNsTDfQuiW8/wd2cDWk1aG7Uv6T3gg2PqCiv0C4tyb3++1F5/wqyy1WYC3U8MmwgFArh/0K46e6DQYkVV7hnEPgTclL7KWVt4nzqiMM3ml7ZuWcDNc/NECUiNulrBlQlZuYAhOXqRCf+iaBrnDLMfUJIAv63u0W38wmrg6/KP25A7OKeD+Bbuu2fK+Pb2y94rNriUNK70KBLMEBv441WXrRknygKVg5a0iNsndVj3VoEIy6XKDbo9HY8jGOYgtNliRrSpq1GKFdzJtje5rnvdTQHER1G2WnZ4N5EpFkefTQjMstyExihBiMWnSFvjDq4D+wX9FqCQbxknwZAL39hg4+ddYL2H+nSg6lfOn4GLCvhmBTujPF6+rmcChzvlI/ogX/4CmBkmyDKM2Wj7CkypeRzBc2aWlNy2AhHjAITVtIWUy5hIANhisF5azbs9fofC14JaoHhpeJdjM81xgAeBqK+qW7aVf9I991LC1V5xoZdZGA5UvsrxYYeCBgNTrlqPZdjXJIdKApJ+oHRhnf/UIo9OyvD+3K2ffAZb8FTDQ6OBlMkw3aQkcNGvGKITYbdV4lvFbxH0f9SI4xFJp24S/1YyhYQLwKA1tE/CzNLiFXt4n5PGfgSXOxyyTBpu1M0fhEDO+S0LgribeYt/HxbCPuwk1xVAYvGOAX/OnSUHhe4d+68/0+ta8faDEbHWmS6t6LreqqdzM65K3ccwBEZYVqrVGA9yF2KJqPfwW/XC5g4IoQhJAVpPKS06Pto/OM/HI2zxe57mqrpspiVfjp9K8FcAIHzSU3NK/tNcTbY8MsWeZn6F0Z2FrM519+BuE/VVvQqn4
 TN8QDn+C
 klM0xqwGNd48cOBTiTfhV50lK25+V5Yq1I8FbXN/IMLUcSygHXv0dcTXNkihyg1+rj18kYTNd+hl3QMnUilkT+6PIalORXmDalyUE0bW1DDmd7yCAyi9kaTrLMbldB4MVu7f9GNbs2T+vxvW1PzJHHqOiovhLH+WU9tB/aTTALNavwzR7fjGhcKhocJ8JIA5dtcLmn47VqPstsYHDNs+rCAagdhecMfoZcHtCMbYMjgcYrt26DOwu2b3yFKLdXmWIEuzCWz6A8QENK9pZK+GE+y3ry+jhawf1cyDZ8yZezyJlrSNnTEyOWQhJZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 14:01:32 +0900 Sergey Senozhatsky wrote:
> On (26/10/22 19:11), Hillf Danton wrote:
> [..]
> > What I am confused is -- why decompression needs to run faster without boosting
> > compression up. Where is the compressed material?
> 
> In a typical embedded device (e.g. android) zram write is swap-out
> (direct, indirect kswapd, or backgroud service swapping out idle apps),
> users don't see those.  zram read, on the contrary, is what users
> see - because that's swap-in, read bursts when user brings back idle
> app (camera app, etc.) which needs to get back to foregound quickly.
> So, the read path is more important.
> 
> I tested the series against PE.
> 
Thanks for sharing data.

> readers vs readers (no writers) 3 runs
> 
>     BASE+PE     IOPS 1,449k  avg 3.48us  sd 155.6us  p99.99 26.8us  max 280,820us
>                 IOPS 1,435k  avg 3.69us  sd 322.9us  p99.99 24.2us  max 540,512us
>                 IOPS 1,459k  avg 3.46us  sd  92.8us  p99.99 25.5us  max 172,186us
>     PATCHED+PE  IOPS 1,457k  avg 3.31us  sd  15.9us  p99.99 25.5us  max   7,580us
>                 IOPS 1,475k  avg 3.28us  sd  14.6us  p99.99 24.5us  max   7,327us
>                 IOPS 1,463k  avg 3.32us  sd  17.2us  p99.99 28.5us  max   6,816us
> 
     BASE+PE     IOPS 1,449k
                 IOPS 1,435k
                 IOPS 1,459k
		+)----------
		      4,343
	       /3)----------
		      1,447

     PATCHED+PE  IOPS 1,457k
                 IOPS 1,475k
                 IOPS 1,463k
		+)----------
		      4,395
	       /3)----------
		      1,465

		(1,465 - 1,447) / 1,447 = 18 / 1,447 = 1%


> R/W stream split makes sense for reasons that we already mentioned.
> Readers don't need to be blocked on Writers - they don't compete for
> the same data.  And, moreover, readers don't need to be serialized at
> all for stateful decompression.
> 
> writers vs readers 3 runs
> 
>     BASE+PE     IOPS 1,271k  avg 5.57us  sd 1,393us  p99.99 27.5us  max 1,581,800us
>                 IOPS 1,461k  avg 3.43us  sd    78us  p99.99 23.9us  max   227,015us
>                 IOPS 1,444k  avg 3.48us  sd   222us  p99.99 23.9us  max   592,628us
>     PATCHED+PE  IOPS 1,457k  avg 3.32us  sd    18us  p99.99 27.5us  max     5,620us
>                 IOPS 1,464k  avg 3.31us  sd    17us  p99.99 24.2us  max     5,621us
>                 IOPS 1,475k  avg 3.29us  sd    16us  p99.99 26.5us  max     5,620us
> 
     BASE+PE     IOPS 1,271k
                 IOPS 1,461k
                 IOPS 1,444k
		+)----------
		      4,176
	       /3)----------
		      1,392

     PATCHED+PE  IOPS 1,457k
                 IOPS 1,464k
                 IOPS 1,475k
		+)----------
		      4,396
	       /3)----------
		      1,465

		(1,465 - 1,392) / 1,392 = 73 / 1,392 = 5%


	improvment	within 5%	more than 10%	more than 20%
	(mIngo's) rule	safely ignored	good		standing ovation

More than two miles away from standing ovation.

