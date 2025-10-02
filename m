Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65ED8CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 13:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEAC58E000A; Thu,  2 Oct 2025 09:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98998E0002; Thu,  2 Oct 2025 09:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98BF38E000A; Thu,  2 Oct 2025 09:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 819478E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:22:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E5ED140377
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:22:53 +0000 (UTC)
X-FDA: 83953239426.05.1BCC559
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 108C720002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:22:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759411371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ec+ndxQ3jnu1a8VNviNr06HkWUDsCBC6MfDIjOmWDIU=;
	b=VPjPxbdtDl4H0Q+61JTpsHQEoPOMHZIEQ8uwXD4yG4KsA/QyUEISIDxsny7YzAjrWy1VDk
	9Y3pJqQPa+br87tAEDgnnYnriQZ7259bbzrDPN9ER3e/DrY70e7uet8i2b2mAv6kJlLr3a
	TmLrfhVHAFJ34fBj5bB+Ru81/FMWj9A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759411371; a=rsa-sha256;
	cv=none;
	b=pSemdCto+141m+J95zS4l4nGQMXggLEDEobTKReUYlvTcwS/UTqlhcIdSQrZklTXlUMgo9
	Y8c/AqhEm70qdnSK6ImkT/jEyVxL3DzlZp00Z0036a9l+lKyi5eOiqOzfBbMlizCi/rNgZ
	TJevEfCDBvtijPfneOU/3ou9lGjAHsQ=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4e4a24228c4so8168381cf.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 06:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759411370; x=1760016170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ec+ndxQ3jnu1a8VNviNr06HkWUDsCBC6MfDIjOmWDIU=;
        b=SkrD+/AiAQhupiWj0S8YjkZX2pli0W+j7nSoMlawuziG5TO+ozOc2IQFWBFWZ27d+s
         qeZaFX+RByWdfZHafLTgRc+9SE/BXZikay0iKBbGsU88zotcdrrPUwiJrSPgKzg6tQFL
         zWw/e5Lcq2i/qbTFv55gPmsAueoZgjDzJI4533U9OEquehsiH4PTjQ6OwUyDEiya3whd
         KNpM3tOZ8b24JgNPZFdFJXXqj0Cu6oRwjub7bXNAZr/Jenb4l+9WvajBNkV5kwWYXp8z
         dljewQFKf0DY9kZrIbDHb7OYZ/DGNa8TDjhrimlsyh6KQlxzM1WXcIASB5WDA6dfwkGt
         Mnbw==
X-Forwarded-Encrypted: i=1; AJvYcCWHbTmaOpN3UrUAb6+JW/p7mp/+UCFN1yig2R9hHDB7ciExp9wovPsEg7ypnNjt1IqXvStRPu67eQ==@kvack.org
X-Gm-Message-State: AOJu0Yyl2UteFtr808f8lVRLYPvW28GAbET+d4t1pi+vV3AWTWRLDpe+
	Q13m8zfTgIR7gcehYnomxZBfzVY1pBa6ccgViK2o1itkJEjuGzliHfa5jqoHlGs6iPZzAA==
X-Gm-Gg: ASbGncvNFc7opMgGNbU6oDWKEd6LUnqYNA1rfz2Py04d+sZv6yzxey3pcja3+A66N8k
	WNR/Tk4t0YoNqmpc1auOJJHE1N8RLvflRlw9/7d824VaQaPuU/jTaQmyj4a8ucG11A+zWcCQce8
	yVSzTvvCA5MpwRukz4zVxcp7JuzZ9Ztd7arin94jX1k5oQRib28XO3rXti+MO6dfT+EhZEdZN82
	1RwpoFmvuPadCbNusFwR+KQVe55KYfM3NAYk8GoRdyhIJ1NMKWZOX4Zo9EIeZnzJHUmJVEqhs8B
	vKFfrkJsIcny5Cos7pNO/rxMy6+BFEO5K7Lvnq+6wagsuHCN2I0Qme1pM/7V2aKD0l+wrChSK11
	VD8zuQrsYDj8BMe+v8u0TcTuvV/50qRJy4ElZdb1ZQtVbNLivqHt57yR/n6WUAzUojOcL16WoEv
	qm8Drt
X-Google-Smtp-Source: AGHT+IFROTw5j7Wrc+DgvWmRBn38yP917qBY5bu8yFJDyxYsX4F5RmiimQtmCXU8GqSb+BjCt+qnew==
X-Received: by 2002:a05:622a:1811:b0:4dd:1f12:94d7 with SMTP id d75a77b69052e-4e41e541231mr94293651cf.55.1759411368149;
        Thu, 02 Oct 2025 06:22:48 -0700 (PDT)
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com. [209.85.219.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e55a9468fbsm19892961cf.16.2025.10.02.06.22.47
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 06:22:47 -0700 (PDT)
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-78e4056623fso9582126d6.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 06:22:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX28/BFQCnmdbQwP9neTMw7VeYoQBhh9j+7+TQ8UzDibmfPiYo71vSAIofwJQhygK4yIljXp52qaQ==@kvack.org
X-Received: by 2002:a67:f74a:0:b0:5d3:fecb:e4e8 with SMTP id
 ada2fe7eead31-5d3fecbe643mr2057033137.5.1759409779799; Thu, 02 Oct 2025
 05:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <20251002081247.51255-1-byungchul@sk.com> <20251002081247.51255-3-byungchul@sk.com>
 <2025100255-tapestry-elite-31b0@gregkh>
In-Reply-To: <2025100255-tapestry-elite-31b0@gregkh>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 2 Oct 2025 14:56:08 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWXuXh4SVu-ORghAqsZa7U6_mcW44++id9ioUm5Y4KTLw@mail.gmail.com>
X-Gm-Features: AS18NWCmqHU8DKNueQjpF6Ifrv2W5fzYfUTjQ8XBBt-1KrFWqeUHHsvmYo_0fpY
Message-ID: <CAMuHMdWXuXh4SVu-ORghAqsZa7U6_mcW44++id9ioUm5Y4KTLw@mail.gmail.com>
Subject: Re: [PATCH v17 02/47] dept: implement DEPT(DEPendency Tracker)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Byungchul Park <byungchul@sk.com>, linux-kernel@vger.kernel.org, kernel_team@skhynix.com, 
	torvalds@linux-foundation.org, damien.lemoal@opensource.wdc.com, 
	linux-ide@vger.kernel.org, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, 
	will@kernel.org, tglx@linutronix.de, rostedt@goodmis.org, 
	joel@joelfernandes.org, sashal@kernel.org, daniel.vetter@ffwll.ch, 
	duyuyang@gmail.com, johannes.berg@intel.com, tj@kernel.org, tytso@mit.edu, 
	willy@infradead.org, david@fromorbit.com, amir73il@gmail.com, 
	kernel-team@lge.com, linux-mm@kvack.org, akpm@linux-foundation.org, 
	mhocko@kernel.org, minchan@kernel.org, hannes@cmpxchg.org, 
	vdavydov.dev@gmail.com, sj@kernel.org, jglisse@redhat.com, dennis@kernel.org, 
	cl@linux.com, penberg@kernel.org, rientjes@google.com, vbabka@suse.cz, 
	ngupta@vflare.org, linux-block@vger.kernel.org, josef@toxicpanda.com, 
	linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org, 
	dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org, 
	dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com, 
	melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com, 
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com, 
	max.byungchul.park@gmail.com, boqun.feng@gmail.com, longman@redhat.com, 
	yunseong.kim@ericsson.com, ysk@kzalloc.com, yeoreum.yun@arm.com, 
	netdev@vger.kernel.org, matthew.brost@intel.com, her0gyugyu@gmail.com, 
	corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	sumit.semwal@linaro.org, gustavo@padovan.org, christian.koenig@amd.com, 
	andi.shyti@kernel.org, arnd@arndb.de, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, 
	mcgrof@kernel.org, petr.pavlu@suse.com, da.gomez@kernel.org, 
	samitolvanen@google.com, paulmck@kernel.org, frederic@kernel.org, 
	neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, josh@joshtriplett.org, 
	urezki@gmail.com, mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, 
	qiang.zhang@linux.dev, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, chuck.lever@oracle.com, neil@brown.name, 
	okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org, 
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kristina.martsenko@arm.com, 
	wangkefeng.wang@huawei.com, broonie@kernel.org, kevin.brodsky@arm.com, 
	dwmw@amazon.co.uk, shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com, 
	yuzhao@google.com, baolin.wang@linux.alibaba.com, usamaarif642@gmail.com, 
	joel.granados@kernel.org, richard.weiyang@gmail.com, geert+renesas@glider.be, 
	tim.c.chen@linux.intel.com, linux@treblig.org, 
	alexander.shishkin@linux.intel.com, lillian@star-ark.net, 
	chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com, 
	link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org, brauner@kernel.org, 
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com, 
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org, 
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 108C720002
X-Stat-Signature: tsfrjnizidftkijkq4xfc5njk88xoae1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759411370-989160
X-HE-Meta: U2FsdGVkX1/OoLjuC0/KZtlwUZdp7TgAr4ZMMQFG9bEilJUUJ9sfNwG4PqMbANxcswzfUEBMh0BC9EcrjgV9pu8XeUoQAhJKVo/KXb62UWTsnm2q1AhaCjg6sq2OcFZucD7pj2bP0dN+7Izlp0k7cdSDqTQzEfwSdlkU+H6cxq3PWJC/zmXCpu0mg98YBX4cci6hh49xvImVRVJ/fqHksATfHs2RoXwguTUWH563cUavf4G69rM1jgv1BZN2XygxBOI5Z+YA7Gvw8OqXGSrmhzoBB30x8+siTupqKpZ0pQ6jS9nV1gYXex6FFVAzBkh1t28G7dQlrV5jNAiVx4nZu7ZGRH6jnF2HdegGK0Pp/oGkb3HUfElQPgXEp9D0eFe1592pLjYm8+hw1sOYu+3MHxztWquiYXp99aYFiViMBLfE5fMhu90jQNd+FeKoxjVDgKu0SQDMbWzaQG5RRbZjT6OQFeAaD5cd/OBtZvM6I7l8xT2jhPU0S6ATPoF1pNTH1gA2dYUawC4IdJJu9qiFf2YHS57OI7cun/+Ou6IJ96+3MnbTyBgd0Mx57ZJpyX2vtGKOH9yGNhLxGHjcGDqtN0v30SdhmN1yTzBYo17SrwPOfWOPvK6vaKJfX2FAeuuSBPQtjIfqQoQ/paO+vwDj4i1pOKlkUkQpQ1ourngVXbT7WqLQ/Ryn1cNZKGL/BuaoIS98xWJ9zKZoeyW3tLpbaa7R+bCJxfcDzaY70LFVXyfjzQZyNCUR/6nHKiQ09UZiBE5Dby8agoE95hNHqBxk05Xlcp2Mc/oQZKDSe+uisZlgN91d0hZveMaeJoThZXz7mI6cbiGXVxy7ks6Uxn/9qc9YWo7JedvovxgsnFuTbMfgwXQT6qNyWOhRAaCwSzk7H1DxrAN9BzyWE3D1DUsbfFRRBgnhtrOYmoH0n3EXmS5rHm2gFSDyQAIu2eCqWFFQbTc1CLxcKHcY+TiUj/5
 ICDIS4wg
 ZDvzPar1FezQwYs5Oo2dp/B+LpGHwECrkiehQt2zXfj0d6jTc57FLywbqcDE6vySMejf39pR1zD+Wo8DccbxCcNXSb1qztyrjZnCC7xcUDBHovy3o0cdcVZSBK2a+LXb7o+dem9GwXowhwUVOCdGdijfgnY2G5ZlF9UYW+EcyxPM+032uff1uePn3RNx3JT9ciLAKV79L6Pre2AjKnECEUJhqPryd0VTLaJ28c+Hv0cgrbCeT85H4lLN5mFJLb/AK3h+hAOba0nFTD4XZm099ReTBhumo+2VzLOTpTKGPl712aLNWYTH6NzI8qEOwW9l7xTXhecvSyCHu2lphdsOr8S0nLqulwDh0MZ6m0FromadNkTjNRs2HRYdizy1yqwSbfU/0rka2uDI7qWq/iJyK8iqiImxSe1Pa3hnk7J9ovZfQcqu+ZzMVsSXU8q78ilD2Os+aneMorFjx62QQcOrc8aDNbkk6GaCZ6KInbob9LMriGQAFL9JycDA9Ld5XSqwLZ0vSlwXuAyfaD4ZwoebEFaYvXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg,

On Thu, 2 Oct 2025 at 10:25, Greg KH <gregkh@linuxfoundation.org> wrote:
> > @@ -0,0 +1,446 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * DEPT(DEPendency Tracker) - runtime dependency tracker
> > + *
> > + * Started by Byungchul Park <max.byungchul.park@gmail.com>:
> > + *
> > + *  Copyright (c) 2020 LG Electronics, Inc., Byungchul Park
> > + *  Copyright (c) 2024 SK hynix, Inc., Byungchul Park
>
> Nit, it's now 2025 :)

The last non-trivial change to this file was between the last version
posted in 2024 (v14) and the first version posted in 2025 (v15),
so 2024 doesn't sound that off to me.
You are not supposed to bump the copyright year when republishing
without any actual changes.  It is meant to be the work=E2=80=99s first yea=
r
of publication.

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

