Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963F5CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE706B0088; Mon, 24 Nov 2025 10:50:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEB96B0089; Mon, 24 Nov 2025 10:50:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9DDA6B008A; Mon, 24 Nov 2025 10:50:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C403B6B0088
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:50:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 995CC1306AB
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:50:47 +0000 (UTC)
X-FDA: 84145938534.11.BB1A2A9
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB08CA0013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:50:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YCBBH8cN;
	spf=pass (imf25.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763999445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daIbgNggw5+RIWaqSAyn3PLOejh0silfLJm2gZrCAxI=;
	b=myC4vVROYLUtMb3pLK+u3goEDlMv2OWyFsPAxCbLwuhgV1Ly3+tKAM3YLfPYGuyKs329Cd
	nNPCBwuaBBj9EDlK0YKfSw4Ap/5P+0ur7hXsRNeGbIkQSCisAjEmwS4k1gWfit+6ZGyeJ+
	dnUDFtwNBS3vHpymoKonoXggBs11XXY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YCBBH8cN;
	spf=pass (imf25.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763999445; a=rsa-sha256;
	cv=none;
	b=S+4+NoOa92LHCgWEebxzbwesLRCTZsdhyqDkc2v2Fp3QQuQr+yerBPDHxRYFeCY6PbgElK
	F/bArF31GCQ3DrMZACUlBOSvp3HvfjNYiCysLSsth3s+b4/isBTNG0OaxPdWduOqB4wsI5
	MHaqAGRF2R6GUUqMVf2PK8ImI0BfXMA=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2980343d9d1so347355ad.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763999444; x=1764604244; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=daIbgNggw5+RIWaqSAyn3PLOejh0silfLJm2gZrCAxI=;
        b=YCBBH8cNnfsW3HxHM6RTxYy58LFcVFgPjIIq45GEaxuBnX5bj9HMYBS92J3/Qv7nqv
         DOIRzdE1d9zUs9iFeivF2GLAyRLKrh5r5GV+4x2u7c/EnXta7RTlKRXC++UbyRW/8hV9
         4osd9vAZKiFfkNZcS+yj0IJDFfoEW/P87vdS2bZD+gsTDdM06kej5Ls9NZY5/8LYppLI
         hXYh0/anbJB8zy6W9t9F9zJooSsWMaBGWWZFBW4MIuKwsCXnQluZkcQNQRYjgiBcfAvw
         PmNJL9q9tYfhJjO22W603AP+VcLvj8laRnMCs4AngXRyt3vQap0rOdpkP0NlgWfxx3RV
         Avaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763999444; x=1764604244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=daIbgNggw5+RIWaqSAyn3PLOejh0silfLJm2gZrCAxI=;
        b=Man4eI4eCgMywbuC7My6Ch6PFs+7yLIFgmtefzlKrB6xvHjxfTD8WQtTnT9WlnHPIC
         LLNSgIPyuEMAJqG5OwerkKnXz3dkQ1eTGWL2CgLnbT73kQe3bZCUXYzDrunf9IthrLm5
         Bt5wSKb4qZvDIfLDTBws364hRExtCN2oCTgbFhMEhh4zvHOZJ9BcosYp4yS7XlTkKiR1
         1xDW3y0HiZIuPN378KtmooUiE6HV1B/A6mFh+EQdF8kYGNNWozE0mMcvEnDg7Dzf0Jco
         D1AOog04Wx5aK6/sWt3x3e0NSNYhRxACjgAuZIP8HYGXYtNWwNKAs4m+v2htANqBGcOn
         aipg==
X-Forwarded-Encrypted: i=1; AJvYcCW7ejoBVmahqBfl5M82QiMlKlK2ZUCDngxa1ZSjJ7N0mnyrVQ3mlM9aAumVC4k8QO3g+hdbhJ4nbA==@kvack.org
X-Gm-Message-State: AOJu0Yzsjlfr5AGtqW7b+Pmt59eY9FvkAHcAVkP0WKSWVwegTmLzNkP2
	zabHXnXrBahA2uF/YlH+WwVGPy3zByGgVrjaBLqXS8+Clefw3yemvv1q1YFA5I6g7LnGlVHRHrC
	w5fTjCWG6kYhRdeDsJJEELbdSxbWVvPvk2PTyQMAx
X-Gm-Gg: ASbGncsIdqRI0scGcHAQ3mt5hNjx3Z6zkCQySNXUF+pwYSz2+hxgs+ZEDCH8Uv//pV3
	/aUhuWNRqXufR0SO2WV/LZY7w9BKKz/3Zz7PA6xa02TmcmHjK+YU7GjUcAf3qhCnQrNSNT/ggbp
	Cv9fYZQ7qZFMSxSix5yU8TS1kFE5UPKdL58Rzi3NX02ElXE3yKnSzPzqND+kYQwYnKajYt74LBN
	PeU6R5sbOV9ShLQVSM4DjX8mhSa2VhWMQFcSYvb2sBSLNGO7+NLW9caenboUmtED5WSlBqjVCUJ
	FbavADB6NgPenyRk51BQOPHQxMDdRXigPUU/nNSqMHGP9A3lpm/RINk=
X-Google-Smtp-Source: AGHT+IEy/LSMFk8iYVjgbAAJEenGWYAnGVnyxU/V1Cyq6eFwuiYf/UkhIX/FxJSWiRguk8dihSpeKWklTDThpq99c2g=
X-Received: by 2002:a17:903:2307:b0:274:1a09:9553 with SMTP id
 d9443c01a7336-29b7b0e360cmr4771155ad.6.1763999444236; Mon, 24 Nov 2025
 07:50:44 -0800 (PST)
MIME-Version: 1.0
References: <20251122074029.3948921-1-senozhatsky@chromium.org> <20251122074029.3948921-3-senozhatsky@chromium.org>
In-Reply-To: <20251122074029.3948921-3-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 24 Nov 2025 10:50:07 -0500
X-Gm-Features: AWmQ_bnhIJCH4WCGbQ-G4XcJu6360z_7NhMLl3znPaAnQ2dVfHn7kg9jFhMwxaQ
Message-ID: <CADyq12wLaGjbPqpXbWOsiAD3SUD1NKZvzZayFYx3TPECptXC8A@mail.gmail.com>
Subject: Re: [PATCHv6 2/6] zram: add writeback batch size device attr
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AB08CA0013
X-Stat-Signature: eghbiq1btmbifdy4zuoiicjmki6hg35a
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763999445-419779
X-HE-Meta: U2FsdGVkX19phLZkvz9PgcKNTTB+UMHn2GJDqJsz1mjTU0XuA7WVrm+L27BL8n9C29EDh2+y2x63fUJ96+jmXvDdxootru9E7SwvrwPvRiYDzKHGAAQuHRVHoPV4+J2fUQ5bfRTaNp6rfvz4rAG+/Fe30kmDOpvq2C3aJXTipGv6y9oj+/gYQ+PnfK/9nekJ46kq8CSXO6+y3bBi455LRtm4Jr+thyAXKBOH8iIr4BnQop3UW+Pe1TcUqem5UXVDeigfbOfyWinAL9i2GhNxfb57pa6ffDIUnhyhZwhJlePTtHagIxqVJ58wgRJIA6wYANN2twGf+NtWsGpLZphPyIq/mh4XY35+uFe65sI4/o7IQ+FnKQC7ToEDOZG97AuGppDGZuKsOQ/Z0b72oPeaNwA7nGrqXT1qyrvmjvbBiivV4A9VwCsxcUbZ6WU48Jgf1POMy7lfd8ePKcivtqRqhqjYM7Fv7J8Jg4klp6s3wm+YPtyzrHk8AHuovp5d2vz6hPipPwT1k2BuRUNzK6vFNRqwl2Xxa0X2V/rJ0Aw5p5naB4Hgy2btdzQ0DXhrVqv4Z2IjBQbWWWDIxG/8hVLgveSjScvh+qMMnBmqgN3ZQ0McmaEiK+LoSDw5439zGR+pqiUdEztjdVAwwsjkMZaUyMvOsPup8YUWMWWcXRGoeGmx2sj10gKcQOB0m0DsvgBJWUiXbgsjGXBLYUwpzHOr8SX3hYJrvrFOJ4hOweE/D4v9GirxQy8vlshtOxCNsVnt2r48PHb3Yu8yf4MRMEP4lJwnrc0m/+Mx1dV81FXs3lqsw7YMcpiMXwR3IH8S28NVmKX8Wig7FH2hrv4guWx3uVXO/x9VKdqPVafv9a3D/2vNxwCH77Vdp1ZkfQRG0OsnJvlLlHGg98qTojYG5cfgftv60stptLY/wOntRK300hTsS15XwsY4Bc9gOrPgRjHn1H9rs8zHrfIdonw07Ip
 GaAMFaAz
 uzIE3J40rgaAJAzxSBkvzaRxBpuZgOa8fJnuZgeRWOLNO0wdMurhVePX7YkBMhqQt/+rShXxc4taRbEontYZ6gskrGVKf43vjYhgdmaN0e4JMHGMgSR6fgxt9OqH15wGZNY9/TWxaSaMVr5ZtcV4fll+GYKzd/iFVpBdHYPb10DYhfAgtbNOsGNzOJ84ZxNOKXK3r305B9bxz0p9i6dsMukHk2d6a59+UYn2PTdq7thF7Jeg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 2:40=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Introduce writeback_batch_size device attribute so that
> the maximum number of in-flight writeback bio requests
> can be configured at run-time per-device.  This essentially
> enables batched bio writeback.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 46 ++++++++++++++++++++++++++++++-----
>  drivers/block/zram/zram_drv.h |  1 +
>  2 files changed, 41 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 06ea56f0a00f..5906ba061165 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -590,6 +590,40 @@ static ssize_t writeback_limit_show(struct device *d=
ev,
>         return sysfs_emit(buf, "%llu\n", val);
>  }
>
> +static ssize_t writeback_batch_size_store(struct device *dev,
> +                                         struct device_attribute *attr,
> +                                         const char *buf, size_t len)
> +{
> +       struct zram *zram =3D dev_to_zram(dev);
> +       u32 val;
> +
> +       if (kstrtouint(buf, 10, &val))
> +               return -EINVAL;
> +
> +       if (!val)
> +               return -EINVAL;
> +
> +       down_write(&zram->init_lock);
> +       zram->wb_batch_size =3D val;
> +       up_write(&zram->init_lock);
> +
> +       return len;
> +}
> +
> +static ssize_t writeback_batch_size_show(struct device *dev,
> +                                        struct device_attribute *attr,
> +                                        char *buf)
> +{
> +       u32 val;
> +       struct zram *zram =3D dev_to_zram(dev);
> +
> +       down_read(&zram->init_lock);
> +       val =3D zram->wb_batch_size;
> +       up_read(&zram->init_lock);
> +
> +       return sysfs_emit(buf, "%u\n", val);
> +}
> +
>  static void reset_bdev(struct zram *zram)
>  {
>         if (!zram->backing_dev)
> @@ -781,10 +815,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ct=
l)
>         kfree(wb_ctl);
>  }
>
> -/* XXX: should be a per-device sysfs attr */
> -#define ZRAM_WB_REQ_CNT 32
> -
> -static struct zram_wb_ctl *init_wb_ctl(void)
> +static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
>  {
>         struct zram_wb_ctl *wb_ctl;
>         int i;
> @@ -799,7 +830,7 @@ static struct zram_wb_ctl *init_wb_ctl(void)
>         init_waitqueue_head(&wb_ctl->done_wait);
>         spin_lock_init(&wb_ctl->done_lock);
>
> -       for (i =3D 0; i < ZRAM_WB_REQ_CNT; i++) {
> +       for (i =3D 0; i < zram->wb_batch_size; i++) {
>                 struct zram_wb_req *req;
>
>                 /*
> @@ -1200,7 +1231,7 @@ static ssize_t writeback_store(struct device *dev,
>                 goto release_init_lock;
>         }
>
> -       wb_ctl =3D init_wb_ctl();
> +       wb_ctl =3D init_wb_ctl(zram);
>         if (!wb_ctl) {
>                 ret =3D -ENOMEM;
>                 goto release_init_lock;
> @@ -2843,6 +2874,7 @@ static DEVICE_ATTR_RW(backing_dev);
>  static DEVICE_ATTR_WO(writeback);
>  static DEVICE_ATTR_RW(writeback_limit);
>  static DEVICE_ATTR_RW(writeback_limit_enable);
> +static DEVICE_ATTR_RW(writeback_batch_size);
>  #endif
>  #ifdef CONFIG_ZRAM_MULTI_COMP
>  static DEVICE_ATTR_RW(recomp_algorithm);
> @@ -2864,6 +2896,7 @@ static struct attribute *zram_disk_attrs[] =3D {
>         &dev_attr_writeback.attr,
>         &dev_attr_writeback_limit.attr,
>         &dev_attr_writeback_limit_enable.attr,
> +       &dev_attr_writeback_batch_size.attr,
>  #endif
>         &dev_attr_io_stat.attr,
>         &dev_attr_mm_stat.attr,
> @@ -2925,6 +2958,7 @@ static int zram_add(void)
>
>         init_rwsem(&zram->init_lock);
>  #ifdef CONFIG_ZRAM_WRITEBACK
> +       zram->wb_batch_size =3D 32;
>         spin_lock_init(&zram->wb_limit_lock);
>  #endif
>
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.=
h
> index 6cee93f9c0d0..1a647f42c1a4 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -129,6 +129,7 @@ struct zram {
>         struct file *backing_dev;
>         spinlock_t wb_limit_lock;
>         bool wb_limit_enable;
> +       u32 wb_batch_size;
>         u64 bd_wb_limit;
>         struct block_device *bdev;
>         unsigned long *bitmap;
> --
> 2.52.0.460.gd25c4c69ec-goog
>

