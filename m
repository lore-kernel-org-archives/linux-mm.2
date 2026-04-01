Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09638107639C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 18:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315716B0005; Wed,  1 Apr 2026 14:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C63E6B0088; Wed,  1 Apr 2026 14:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2038F6B0089; Wed,  1 Apr 2026 14:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3286B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:09:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC6BD8720F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:09:04 +0000 (UTC)
X-FDA: 84610773408.01.F3A2574
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id D1A8A160004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:09:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fXtHi3bM;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775066942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOudpFoWx8XSk/HnG+DRMg8OAxAthLf7Y5r1o4OCHrM=;
	b=2RtWIUV5V4HidD70TNSMIF6KXvF0bVqWNeHqy000O6iU98W/WFVGRBrEwCoTzuX8JgY0Cr
	Szicos2beM+IY94C/DES2kTqACg5fvg63jO9LNnL/vTTD8MzMvw87TGE2RZ2xjaQZU+irO
	HIuGjSThFeyyah+TUDC+CQllYcZTvks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775066942; a=rsa-sha256;
	cv=none;
	b=WG/GmTdk4JINkEeB/NiXWSaP65nB5Fgtyj5ed5L6oF3vZZwcgv8JGJtnKvTs41XWNYz2O2
	5Mpm2RLKVGtEIcw9sBCNXSI8AyaDevxDg1wCxTq7jZNtphyS0llndSXRTGnVglAP6S1iir
	9zeEHmBjLLnsV+KrZ06QQIpyKdj19Y0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fXtHi3bM;
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2ba895adfeaso136283eec.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 11:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775066941; x=1775671741; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lOudpFoWx8XSk/HnG+DRMg8OAxAthLf7Y5r1o4OCHrM=;
        b=fXtHi3bM4RFHgM7NO+n2KFp+UWoW9v1B08q8KawgrzdKo0/k5hx16fjLJr4p0Z4iTp
         jz6cuNrF2KPjvvrhqvqCK8mMuN8Izyk0pP0KX9PCr5STKPBK04/Jg0XjEZXbs0Gr5+FL
         P2gHS/G1w+Bob8cWCG+wCOfEldBEtAuYrIbqtXQjrer/n3O5mDlYSH+88GgSj+/KFdYQ
         943HL8eV0A/PAPJ3SpEFJwmbyOAPuZ4LrOjX+7CpWxH3faL6sP1hBsIASfAwNxai+pMC
         MaLcTNFWSUOomiLtGTS8r18+a5k2kLKJ8tiBkp7BQvv3BbsfkAA7PSGm6FVrNUDtgZHe
         Mo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775066941; x=1775671741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lOudpFoWx8XSk/HnG+DRMg8OAxAthLf7Y5r1o4OCHrM=;
        b=oDjHoVHdNiq0VhTWM0oZfmUrOndww3tqaovEnhzmRYkWAtn7FKAbp26HIIVVnSTYMD
         Xiuxv3ppcTI9yOi/UztdCgY7FntJA2EP7GqTPrE9/GTkblT17Rf9qJ3ciHrWbdp1SM5X
         fr1iZFfxKWw/9mwb88ub4p78YbrJxojXaDi5Dw6CRvywizi9RGjhWX3VNsD7jrVKIdeH
         +BDM0uUgg4hAikaQnr8Xg3Bb9PD/NyynH4ADsHVJcy6NGNl0JC6bQuhSbNWRZ5HpyVzA
         dotI3oMLdypWXFzynSXtvEdMSRd42dlob8megdFekwifEaUXK7UoT+XmjsUYutV/mNWF
         V3CQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMYrfkhM6YQ9fVXu2+T/xE5iVKD0VlB1RS9i+0M4uTZcCen+Z0660chv2VAu9LoCOJxjmETL5alg==@kvack.org
X-Gm-Message-State: AOJu0Yw3o5IzDQ7dVdiNyLJO9HYH4cM1QxpiNWhalNWcWR0LhvVoHcwN
	wH3CKN14JzLgSZFUNBORZbCxXn/otBPrqxPWoqpSrJRJ0RcJMU9wiD9NG/qXWg==
X-Gm-Gg: ATEYQzxxjihPBC0IE5hXr5DFfRcrXNuPVSuWmfIkfSRKNflTibyv3m6IzQNDlvNvh++
	crHaUMOpPI3sh3ZJL8KSZzvA+pJRJ/1uGgG71QUerGg8Qe/zIfir0MpISIPI0lKqFHLx5v17b4S
	Zi+LrQnQDCIxwcqdBrgzPB5N2kqELaU/gqXocpCSiR0HFo065eRxDlnGI4RNpgzUYQx1O/rk0tO
	NmHmNhDDek24KtRpSl2pvxrkQTwTmZKO9IHPu9bJBNMahJ71YlC6u1lwcpOXTdGAvm4m5681+fk
	bIsy8Iesz7xnphuFVCqMwAmJP44EsDYZiKjYxrsIilmrC8DuaoK+cew35QuDF2qs6gkH2pZDEAx
	j0lKaViSWfyoZuDTFISwTC5CDQbdcrZSl771NkE+XEBzcPuBwF0lNAxEghn394kmVBjDxBa4PaZ
	En3rofQTkTgHnf0cozFS7LwZf9s+P8vO3UXfcH
X-Received: by 2002:a05:7300:a287:b0:2c5:3b87:2ffc with SMTP id 5a478bee46e88-2c930b800a4mr2410628eec.7.1775066941427;
        Wed, 01 Apr 2026 11:09:01 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90::c63a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca7d3111d1sm355429eec.30.2026.04.01.11.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 11:09:00 -0700 (PDT)
Date: Wed, 1 Apr 2026 11:08:58 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add sashiko as the first DAMON reviewer
Message-ID: <ac1fOrrURjCfQyJY@fedora>
References: <20260401162637.68506-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401162637.68506-1-sj@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: q1r7tp1jmwia6i6c43aye85oxnepj9u1
X-Rspamd-Queue-Id: D1A8A160004
X-Rspam-User: 
X-HE-Tag: 1775066942-233409
X-HE-Meta: U2FsdGVkX1/GXzkIHPHBGsBuaFPMsBzbKRSCRb433zU1/juI1pkFA4godo0r3PtpD8lqqtMgP1gvmZ3Yq8shH+LNCogbRsC+0FSTpWzLWUDQeKd8MtIHyGQvdn/PHwC2Lsz/SE/qAR4O1zdfH5xmiHUAVSH6H583iw8ZPRR5OpSpK2dsyPA2dKfK88zG3xz10/qlvpSS/b/SFBh7s3kKHWrodSw7ZswHHyGKuVQwZiARzLDCxV/j7dtmsUlB2vwcNukvWgBPOMbGm/FPzrvS+VPKAHHJ2vMoIhkW874G/11q055b5HbICcP2aJL5+HFWNXlg7hMkLhEesxE9cIZhP8ZsqX8mhoixqRuO8QJ5yPQ3tW7ulBc86ydxt2rQwoXJ49ipJpntHqanPVondjA+d8LnrNCadfp2pIEG1/CRxXryOih4MG5d6772f2agfStuKtd0NVtNzcLH5tYwxlcTFaNQCqk5/RoNNZLc8For+xzsFenRxRe3L/3Gp5wvBeWLbLzPtRuV0WtoejJy5sLJFqnR+D8rbkhV2vmVNw/4m0eLslbYZx3MNY17DrrRoRir+F1dTEIQRe/iRq9w94IXijcHfjjVx9h8tc9qhBkoimYc8WDLf0GEU1eAvD+bDjHne5Ff6Qq7dK9m3ZxDHgOzUauDH8Yh75eBmX23Ecq7srxEFWQkikR2Rh6laKgr0qwLOkvLsH0YkDJiTsatGy1kFfbLKot7xaBF8+RDuoSccRrYW62gl580Aq1zbBixo8uhtew/kC6EEBtf+dnbQNIK90lFNh7FV2CwNi1ZRsvqKQmTCFAXWsWXnNNZNYzoZxzEse1aOo2TCa0By5qVA0vbFiyw1Ub3uT1dIEeanTZix0JRWIF4ciMlHDuxXTeFwDwDissPeGD7ghx8+9cRJ/Cm7+qrlAVKwVWB5LwZYkMQBHVVaroCfOiQZuiUb/XAo0cPnKZdrxiNNwUKj9w2izn
 cbX3HQY+
 uMBRWr/tEB/D7nLRTwxLG+8mT34rHKZVXON/2xy05QLf564/5D7Be66ftKIQjchE97j6pKF64w9jpCvDBcwQV3PtJL5RfjEd0BW2nkpMZJ7sCsVj1gcOTaqHXZUE/U4O/BW8abZPcnDGYQDt+rMw2U5fuBn59CA5urvKcJKWJmQPrf7sQf/sT4LTS9vMxpzhzeYHZMeNWVjyDSMZYUPUD5oVPpL0I5Uren7qwGNs7hogWWia7o3+8jWWhPfuY8Cknrag82f0tzkXRLDlC8JYPG80T6viMQ3ie7pBnRRhfxXwLJEb6/Ow2Ys/LzcVgbJDtNvBDBRuAjxE2MnLeQH2e/ZaRCBce013/bzkqbVj9Ji/2Rs50vChBXj02T4ncvuoXxjyx9wAEc5yUkJ/eL/lJVLC3ubHS2mjfeBzwu340fSI6LRUmH9xJnI3A4IfjfRrkmXEzveJuB2Hu/ZGT5H494tYdlI/1wifCGHfMjfycjL104DXBBcybEUDF/EYTg2UOzZVP70mqZHNEgq4f6j2ojcnjfyUCDDSLx9hAoT35Y/4Hk7UEAUA7beFNWKV76RBBlMAPnWvxeJef8NwyTHcYhXSjLYLiCQAtHvM7DUKgVPFlteTU5V+jBkY6VlhbUY0RKI9RnKrZNWwm9szX2lrBYW2Xv/i3cChiy6Cbf4zD7kkZhuOlnHK2qdYjIrwOQVKZ3aFn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 09:26:36AM -0700, SeongJae Park wrote:
> sashiko did arguably good jobs at reviewing DAMON patches, for multiple
> cases.  "Today" is the greatest day to give sashiko a credit and the
> responsibility.  Add sashiko to MAINTAINERS file as a DAMON reviewer.

This is a great idea! Andrew should add it to the MM one too :P

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 16874c32e288..42aeaa858531 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7041,6 +7041,7 @@ F:	drivers/platform/x86/dasharo-acpi.c
>  
>  DAMON
>  M:	SeongJae Park <sj@kernel.org>
> +R:	sashiko.dev

Maybe we should give it a kernel.org address while we're at it. It would
look more in place.

>  L:	damon@lists.linux.dev
>  L:	linux-mm@kvack.org
>  S:	Maintained
> 
> base-commit: 36cdacaadf95f0245cfcb76c0b0cb7e6706b05ea
> -- 
> 2.47.3

