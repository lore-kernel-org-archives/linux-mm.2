Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C536FCF8875
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26FBF6B00D3; Thu, 20 Nov 2025 10:58:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F4C6B00D5; Thu, 20 Nov 2025 10:58:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EAC6B00D8; Thu, 20 Nov 2025 10:58:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F3A376B00D3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:58:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B07341601D1
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:58:19 +0000 (UTC)
X-FDA: 84131442318.21.1ABEC73
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id BB2531C0010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:58:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QBOEnjjR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=bgeffon@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763654297; a=rsa-sha256;
	cv=none;
	b=dgkTve7H4NjFfo8nfclOV+ov6MSaoZk+BwhRBBYH9z5HhU8FXRSl9OehnIfAo4IIQY9pA5
	/a/EjIU8E8XGW694z7rZ/Id3MRoBNIFnT+uIMGq1D2C/H4zvQaYeyuhGYvH1lgCM2ILLrm
	5NXc8Zz40M6gIzd2NovPEoBteesDDys=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QBOEnjjR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=bgeffon@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763654297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FM+Mb2yZG4S4vNNa7mZRT19UBjXjaSiTW+UNdByxGbk=;
	b=U/7VBDGuPWc/P190/dv83vLm8D49K4yeFOjc64izUBjkHHosknnwOGxnm2nt4nNaB432IK
	JEnT7nqa/VclkpnRhjl/wImSMSv3G3DYQaCD4z9bDjhJjlhz/i1W/0qwdoJVT6M/Hrze5Y
	60X8fciQoaT07hrNFF2E1SEuEX0lUPc=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-295c64cb951so257065ad.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763654296; x=1764259096; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FM+Mb2yZG4S4vNNa7mZRT19UBjXjaSiTW+UNdByxGbk=;
        b=QBOEnjjRZ8nXDbYSRXHJ6rlDpoTdiu1qCyeVLmYuuESryj4EByvZYc68HEEOK5ooh9
         W91xUDUrn0WmGLmFs4xfDLZCbfebRbgySeJvLgGHQNfwyGlPRnT+lSi75NoUZOYXCZj4
         YhFK6tenjJUk/w5zUKVhN1gxX5Lv/EJmQMMk7NTOH3H8qnKU9UGSBhocjnvRjjAlUkwX
         K+lYtdXKFBW70GXL3LJxZGEnFH8bq1zgdLO+2JEQ1f6xs+dMy7zP0C/g4TTcuh0nqrPl
         XMZsTHqKfc4MEqlQExoWIG3io/w+2Sh/+JKW0n/2FjD1h6obQ99k8niSJBmv8MfI7DBq
         DbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763654296; x=1764259096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FM+Mb2yZG4S4vNNa7mZRT19UBjXjaSiTW+UNdByxGbk=;
        b=WeDAcnkAAi3LjHRS87v5oWJozW6rdjIDcFF5AKAlbX4AddPefPCjYr5Nl7TZrdYrR3
         cjDExY9JsQ6ZO77F4cZnXxXbjrXqy1yWS8gr0EuE5DFnSUi5GSSSvbhEExZ2E5QZsMCv
         XPTs1cDjANNbqS9lENgoCdjf++szcEMYdzjFpSN/FwsgTZkbC/7NKZNcr4hXSypEUvo6
         EuD7cG/xaqv770ghEhRY7UWrhcN2cjiuJ6g+QyuKFzSVVJWg+EPg7pZpebYxlfKnan2g
         fUoKb5qRnpL5FDByWf7H7sMgIAxMZG9UvQYWc4T6HRYOketwbp4QtUd42YVIGtdv264A
         mJVg==
X-Forwarded-Encrypted: i=1; AJvYcCX0q2h7vG4OweY9+jcqrmVIa1+tFhCtYddA9hH5GtCcQzf3rjSgXqkFqHqqnAcdZLFFQnwOAc3B/g==@kvack.org
X-Gm-Message-State: AOJu0YwYXcniqfOru6RTh+svIHJ64hfDny+hK5I+WUvis+Inq59zaR54
	rwA/8DuoUggutNou24oEzC4Fq9TM1a9ztmsLBc5o9F+gUqTMO9lhQfAfXWOXNsRNUn2W9+zdBJt
	Y5npzQ/5syMea/7/zlZZYXZZiOoJB4NmGI9urAkeP
X-Gm-Gg: ASbGncvHaADoeDjBdWbQtfOEdtLmY71WCROwh7e5pDS9WCOQZSe+ldr5001HxFOvjxl
	N4gV1DaiuWa30/es+NKhyBdbaXfQi8tLL0z6eqRSkZQ+8NQjaxxNYQcRF5bcM0PMyqwZzE/WmvZ
	kua+ZVKIfycvQmopvCmT4apiq5/bWUkgCw/bjaSQOyLDHAgn8hM2vbOf+Ai11bAjnl/PsiKAt2h
	S/Og4+WAbzwICcB+zuEh32LThVSTy9H42myD8w4jmkF50ZyIOh+WTZ/oTDKet7AUqgRno/DrTHK
	uRwe5H80crCjjiadIxZJcw2FB6dUeq6uus/6uJXZmKByPh8T0XFrgdY=
X-Google-Smtp-Source: AGHT+IEN0NULaP+VnPL1/fDLZYNjF8Hd/VUeot/flqRIzbz+bFM8hMgL+i6VUxvXySk8BrtVEFw6k33qRAE2TH0TEa4=
X-Received: by 2002:a17:903:2f81:b0:29a:7af:b3c9 with SMTP id
 d9443c01a7336-29b5c5951d8mr2842585ad.16.1763654296382; Thu, 20 Nov 2025
 07:58:16 -0800 (PST)
MIME-Version: 1.0
References: <20251120152126.3126298-1-senozhatsky@chromium.org> <20251120152126.3126298-3-senozhatsky@chromium.org>
In-Reply-To: <20251120152126.3126298-3-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Thu, 20 Nov 2025 10:57:39 -0500
X-Gm-Features: AWmQ_bnVrwcH8-BKVi3_n9EW4M0i9C_Im6NDofM4Llka_8QMk4wUrZfCfTLCF0M
Message-ID: <CADyq12ypYai3Q2QntCjvp26U_J3xWpO4J_DSV+UwCqLFinkcGg@mail.gmail.com>
Subject: Re: [RFC PATCHv5 2/6] zram: add writeback batch size device attr
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB2531C0010
X-Stat-Signature: k371nor1y5hrkgdkymm8ehijdzohbtup
X-HE-Tag: 1763654297-436979
X-HE-Meta: U2FsdGVkX18v8u/cR7h5WDcMJHAbo8wRfiQatbsBsvTDi4t6TJPjXTEkfC9/IaUQ64PXFzH0QBMQAWVM0vXILPQc0TARw3tWp3hhA/XkkGqe64NR0l1ld/kDDzSaPE49aAkPTQ/ZqlHTpxX7bKvZpH4VniWBVbaL9m9mjxzs/6xjYvaIpCnWzo5G25BgguN6kuy9KYWWGkqDATOn4KCLxNKusc+otc69pWq/DLafFisAPTNxWWPvERyZ88LiArQN3/KJgKrkeIMZOjihKCJhq48NlJRM8wcGM53GeKajTlDKLzPJiMQH+u2AQigw45mygXQXR9EtKWjrlF/h4U98qSnPIEHHTkz67tLLFqTpzl1yqsotV+6CdPTQODbaix4m1toe7JZdR8h2sq74TnPOokiVi01wpzxbxJbxRFTeO7pCZJOm23py7cJwkRzPqQYxp03DUcsO05AiitA0eD9NNJqaf7IoetYjLJ77PInAan29R9T35fB6lnorpoQxFQr2kwNCXCSteHrsA51xnmOO3+4HzXLNEkv8tUVJoJLY8GcztpgF1TZoWVblWi0WoZTnIdw5GjeP196pAvyNQjygzP9bhmTty24cdjh1ZH7uGZfRp9OF3I/86plECuvhqdOJLrTq+R65Fb1On7KjM0aaY483jIyT9WQckxUqTGnCFngMFyf7MKxdg7kHKZYr57S2WG1p2XgQCBS+UJqPu8fNqgmcu37cIMe8BIW78xJiCYL9ZgNbG7lLtzx5aCFWqGyS1Ie/Z6TW4+yBShvgpfPCE53Ts/OkDX3IRDE2+U4sC9p5AVvwNMyLDQm0SIo2P6rnYw4fMs2yYnnQNxHIaRiYnKxpLeKBAC7Hf8tr8hD1NJmc3psx5EToKqC0nLblHDAVDUVPsjBvdcLBEv/m0gKlJfMPd+YFNFUUB3gaNjXe2WJ72ZzMOkDADMIcMTVD35rRujoGmisBgw4xN19Fmnm
 l3g4dGmN
 qpiP61uTA2kyP3Kdha97n5aU0Jdmu21yP9vQ7BMnONX7JyFxfE5U0L2CaSEOsX5blhw5jF/i9vlU/OGOnK1E5EUb0tyaTUiH8XlxA5grvcXogNYwJd7gEUs424Cbrv4wWp1Q3xy5eHfRYOpQtFJ0Sv9DQDax1XWW2XEMa7vVjf/rbKfRjskPAaY3F8ifBLZN4nEVoW5TM7J44LqXhazbkjbpQzrQE4jM3gqMKBofgqOKYuceL8FzfW7ptf6JXXUsrjlCm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:22=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Introduce writeback_batch_size device attribute so that
> the maximum number of in-flight writeback bio requests
> can be configured at run-time per-device.  This essentially
> enables batched bio writeback.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  drivers/block/zram/zram_drv.c | 48 ++++++++++++++++++++++++++++++-----
>  drivers/block/zram/zram_drv.h |  1 +
>  2 files changed, 43 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 37c1416ac902..7904159e9226 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -588,6 +588,42 @@ static ssize_t writeback_limit_show(struct device *d=
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
> +       ssize_t ret =3D -EINVAL;
> +
> +       if (kstrtouint(buf, 10, &val))
> +               return ret;
> +
> +       if (!val)
> +               val =3D 1;

IMO a value of 0 for the batch size doesn't make sense, -EINVAL?

> +
> +       down_read(&zram->init_lock);
> +       zram->wb_batch_size =3D val;
> +       up_read(&zram->init_lock);
> +       ret =3D len;
> +
> +       return ret;
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
> @@ -779,10 +815,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ct=
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
> @@ -797,7 +830,7 @@ static struct zram_wb_ctl *init_wb_ctl(void)
>         init_waitqueue_head(&wb_ctl->done_wait);
>         spin_lock_init(&wb_ctl->done_lock);
>
> -       for (i =3D 0; i < ZRAM_WB_REQ_CNT; i++) {
> +       for (i =3D 0; i < zram->wb_batch_size; i++) {
>                 struct zram_wb_req *req;
>
>                 /*
> @@ -1197,7 +1230,7 @@ static ssize_t writeback_store(struct device *dev,
>                 goto release_init_lock;
>         }
>
> -       wb_ctl =3D init_wb_ctl();
> +       wb_ctl =3D init_wb_ctl(zram);
>         if (!wb_ctl) {
>                 ret =3D -ENOMEM;
>                 goto release_init_lock;
> @@ -2840,6 +2873,7 @@ static DEVICE_ATTR_RW(backing_dev);
>  static DEVICE_ATTR_WO(writeback);
>  static DEVICE_ATTR_RW(writeback_limit);
>  static DEVICE_ATTR_RW(writeback_limit_enable);
> +static DEVICE_ATTR_RW(writeback_batch_size);
>  #endif
>  #ifdef CONFIG_ZRAM_MULTI_COMP
>  static DEVICE_ATTR_RW(recomp_algorithm);
> @@ -2861,6 +2895,7 @@ static struct attribute *zram_disk_attrs[] =3D {
>         &dev_attr_writeback.attr,
>         &dev_attr_writeback_limit.attr,
>         &dev_attr_writeback_limit_enable.attr,
> +       &dev_attr_writeback_batch_size.attr,
>  #endif
>         &dev_attr_io_stat.attr,
>         &dev_attr_mm_stat.attr,
> @@ -2922,6 +2957,7 @@ static int zram_add(void)
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
> 2.52.0.rc1.455.g30608eb744-goog
>

