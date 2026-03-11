Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E161125826
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F48F6B00A4; Wed, 11 Mar 2026 16:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA366B00A6; Wed, 11 Mar 2026 16:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C59F6B00A7; Wed, 11 Mar 2026 16:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3436B00A4
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:24:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DECC258BAC
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:24:43 +0000 (UTC)
X-FDA: 84534910446.01.355D0E9
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 198FD1A0017
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:24:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IlQwdx6f;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773260682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VjrInrO/cbuWkSTY+7vTnSbrX2Q7GpHHflnugtvKto=;
	b=hI0d8XU3lnvpS427x3QtFSIdr3zfpFjlIykCTjYM4YYT/+OcfH6E7Nbx1MZzzvAe7sSUtG
	L63tistUUQVE2KscIyKUGP7tF+LZ/mWzkugSDQWaUYXYXuviwg18CfpnULbYBI6cZa+Q7s
	1F+NcRaZadsvdDmClmV4dPwTNjDzmMw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IlQwdx6f;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773260682; a=rsa-sha256;
	cv=none;
	b=oIAMl05rN6vzT1Ks7oLoeQhoVZN2JEiD70mpQ+fjS2f3qbqArzcjsJf4GXb9/Wrbwjziku
	16hc6l10y5n/x5OjjDRyV68nfOdFlcLvDXlYrA5jsRae315xMIfB9i9mKp9YeIZiasQ68y
	ukdkEo9XeLJCl8sG/3tAUhIk/7uBMmc=
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-46702742c99so193595b6e.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773260681; x=1773865481; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0VjrInrO/cbuWkSTY+7vTnSbrX2Q7GpHHflnugtvKto=;
        b=IlQwdx6fnGM4rtBHZ6w95WzIRPpvarnrQRrxJKzfe0/VJhQ36S7g2MjWDWQqHHLlL8
         9kZiju4mXqx4JUPmKFoV58V5MlRRLVew+2EwAPTiYx/y2tPX+rvF6cJL+zL8u2fnMOZd
         oXaqi1Fg8VAOWu++lCzqkaVuE3ExIfs/G6Ju54/yAWRxzu8J/JsjT1vysRvPFSnRPmWF
         Xd1hIvGSaLgR7S9OkBvnx8gFY0sDyxrVrwkdmdkb81OI8OcaWn+Y61ho5i84tYqPHmqU
         Nd3b/AAVo349ipWtsyTTn7yahyiCJKpSRQEaGXDLxY0L+7ZhqIQf8Aqc2+Z2vhQi61sc
         Enqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773260681; x=1773865481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0VjrInrO/cbuWkSTY+7vTnSbrX2Q7GpHHflnugtvKto=;
        b=xKM4B42dh2KyhPmSHHy3qPklIFgdHSUKxqfxl1hAz1iB10W/8ur+rvK8fi92fXN/sW
         dwO4FX4XePCcqdCDP3XKG6mBMnyGlvc23Cs7qpPb5FG0tPxJlFGbz0oa+S8x5zjb17lP
         9WpfFgeMJRYlIF7mpzMgyxCmVlmSnGBG6BsGsaQNkln7dYGKwbS+KEt10c+EuZuC5bmF
         vm6l5S7zpmbdNa8VX9Eu5sT8Wq3CjWaMB7zVBL4RJPEX8xLW70/cehHjzuxAH08ICVbK
         56rHJiuZt/HEcNJUVc9iXPaaNtFIttQn/vX5UnoV+8VvAIBTsKbfwT/qEWNbyRxfRYDG
         O83w==
X-Forwarded-Encrypted: i=1; AJvYcCXt77xGyxUhEBJRHak38oJSD6X/P3RhDB5U+BTtg2Jy8U1p4zqazRzIUt4m9SSeocgOsr/onfEY1g==@kvack.org
X-Gm-Message-State: AOJu0Yz+BAcBDs229GxWu785DalHIvWS/O6p7BlSCyIdMYoc0wvHQx89
	DFCOhDySv+yBWhanxxabmgUFwsuDtMyUjsxa0iznWi92xsZ8/S2zetZz
X-Gm-Gg: ATEYQzwPJN7bcF6ZR7a2MvGvTxevldlduoeGb23fBUUbVhGcS/Yh+78qkedF78r+J+Q
	PTgGTS9MouqjRoW2wKfbXKS8l6RAqHiCMqMZcnJjFizrVPGznowJMhgZ7wgMyuwSoZwIY3LlJMe
	0n4UJEb2rUBb9nqOYe2ieIj5TU3i6QY7lq+8vWGcI6XDwE+3/urtgiIhOkdbLmdmRfABr3ElgBD
	IeZj2RvAIyE69jAD5e7OeAG13m7ExU21frEtnjwbS7ypsaDJbH6iMm5C6+MMEMYz4Y4cYxWMg+0
	lWLDWanBGyAh7tCu4azD3bG7VyhbszNUtaMhdmvmVsI165V5am+bMA/MX+R7wshbQttiZ/BeQyA
	sJ7LTb5ZjuxDZM3dlglNJRSbHa5cofq1eVaoCkc7QGaRpSLq0+VsAfY6bnTmus9Sq5v61Mvs8Tt
	Jz5qDS859ZNnLYA0reXSo4NA==
X-Received: by 2002:a05:6808:1927:b0:467:880:7441 with SMTP id 5614622812f47-4673346153cmr2131673b6e.18.1773260681119;
        Wed, 11 Mar 2026 13:24:41 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4177e5e9f53sm3382611fac.13.2026.03.11.13.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 13:24:40 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jens Axboe <axboe@kernel.dk>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 05/11] mm/zsmalloc: Store obj_cgroup pointer in zspage
Date: Wed, 11 Mar 2026 13:24:38 -0700
Message-ID: <20260311202439.324081-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CAO9r8zMRwFTbv4jWWNf2sEc+SkUawxPtnvOc7LKsJr5R3vkZjQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 198FD1A0017
X-Rspamd-Server: rspam07
X-Stat-Signature: 61m7ugkbejuk5y5op5zpbijuda63gh3i
X-Rspam-User: 
X-HE-Tag: 1773260681-477934
X-HE-Meta: U2FsdGVkX19dj5mY7tmCSQ5X2t9O7EwQH97WBa3kbxj5dK/K3n13tJ39mouXqjjRY5XiMhmRadNAQvPi7LjoJT7X0snTNBddHyonkGntdyHgLVllaxNBWsWucNWwBUTCjI6YDskgQ3vvJdvJurBk+trE7t6gRU5c/aeas2MwBgd430DaUdvdqE3rhwOp4FXMRbCV5nC8LdXoT+eJxDy4XFHAGUdnL9b+xsorQSUkkoW1TCeMp4PBmmxMqrLySEoseP3tVYWwhNsT+fjfR4erztg/kV1CSgiua9aYfSW/87WXYqnePrhOdedJjQd4X320WSEPRa33qAV2CiFlVeBM2trDrbMPsaXSch+XDDj3CFwJPatXj64qo8jEuBEp3fHfSXbKXGe9DkIUgk+FuVHs3HL/0AF+mqGPQFBpNI3L6mK3ZnnN6Vik9216FQJAU128u/9n/yOFuKwe7YaDqMS4yt2qmOoKi7H+jy4dcX5SVjYwnStVZtUlOzjOmAwtrm/h//Z+ETcgeNjEqE0om9yqe7DT6jzCa0864FHjnlqCdJHOlj4D29A+svj5GFQDmJZbhyTSTXEpulFxZwk/i0oUjfXwDfyDscMzK5DwtTe6QSkPca48/AHZXn8pO8X9Z1r29mVm96FVT9OQ+d2dwO0zI5c8x/gEdl0ul7+ZH4UG2FnKokhb6cOC4q2x4D4CCnG+alZsThdJVBQ5kFEgbHz5HMT/D/MThTaJkC9Id8IUgDwOqzmlWpGSMiTSDvkNsIB/IonSWrae6yLYDO8GkCwJMu0PG+smpNZk+VWIVDKEi+T4VcF2KKgH4JCFMAfcWUK4PmATjQYuRSVhlUpfU6mSrX+CPdRbGZF7f5aQky/hpVyE4fyi59sx1SveNna5v59aWauFUUM2yQd0nM5EbOW22p5k1w2mT6SkRdGfvlIA10y3cXYrUP8BJUtjDGfJXuL9efbyMfBQIeixDQYf5Pa
 sp7+cYhb
 2dooEQ2ColYbLt0hx+RNNLIN2cOvZqvH3IKa/piPjw6bLAMTcM4vmNUl6ro3LIP6DIl1GgdBc17+HrNuCM2EyCSEo+DWZ+4sNrsGOryxzcQB0GKfS0Hhu4KS5DmuDJOyOIbAI1ohZV4CF5fkJz5w6dE/HViYG4gwvCOf+No7gY5AktEhtTlpcI2ygINSgb0hn/sr2wi1xd2V+2FWJ7z6tb1/SUlgP8710dAIYlVnXKxJqeNwv9Nkin0zyb95KXS/qp8maLLwnU2Mtz2KbyJ/1pWdHDtNLPcJgBX04hJ/+vC7db6NW0/ICDjV5glvFhN3r6BCpqPadB+zYCNZEoXepJuLYGDrrZlkSFNH5HeB30vPHxozISlV+FubRslmPQJ5J9E6+e207X+4zFksXH7LwvXNxPL0xwz2YgBWGROvD47K8iwTuW91/oILxixz3oqQbBh8pVzdTNdT9lrjNCkMrbvoBFR4a8nFCaD0gAWJTMHf/o63C5V0C9dPus5PlZO5WfR87kQRcfjs1QcBBy1SyLsELkyl5l/AaFdgFrapJ4A8ehplM6amC0SyRc70Oelmjhipv6EhmVCUYg+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 13:17:26 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> [..]
> > @@ -1216,6 +1216,11 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
> >         class = zspage_class(pool, zspage);
> >         off = offset_in_page(class->size * obj_idx);
> >
> > +       if (objcg) {
> > +               WARN_ON_ONCE(!pool->memcg_aware);
> > +               zspage->objcgs[obj_idx] = objcg;
> > +       }

Hello Yosry,

I hope you are doing well. Thank you for reviewing this series! : -)

> If pool->memcg_aware is not set the warning will fire, but the
> following line will write to uninitialized memory and probably crash.
> We should avoid the write if the warning fires.
> 
> Maybe:
> 
> if (objcg && !WARN_ON_ONCE(!pool->memcg_aware))
>        zspage->objcgs[obj_idx] = objcg;

Ack. 

> Not pretty, but the same pattern is followed in many places in the kernel.
> 
> > +
> >         if (!ZsHugePage(zspage))
> >                 off += ZS_HANDLE_SIZE;
> >

Definitely better than writing garbage and crashing : -)
I'll make this change in the next version, I think I should also sprinkle
these WARN_ON_ONCEs in a few other places as well. I'll be more
mindful of this for those cases as well.

Thank you again Yosry, I hope you have a great day!
Joshua

