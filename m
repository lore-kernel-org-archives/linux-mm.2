Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E01FCF856E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 16:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90126B00C0; Thu, 20 Nov 2025 11:04:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A679A6B00C2; Thu, 20 Nov 2025 11:04:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E0E6B00C4; Thu, 20 Nov 2025 11:04:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 865EA6B00C0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:04:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 414091601FA
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:04:25 +0000 (UTC)
X-FDA: 84131457690.29.52A9B80
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4ED7E10000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:04:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J4QrfcAY;
	spf=pass (imf14.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763654663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tTnphYAjSEIlq29e/RZNkDqM0RoIUblA3M5I8Z71iM=;
	b=wQlVwhBxbaIC+B7UMbW06ncoaeMLC90Sl7heMvrSVwXa6eyX5gPUkj7vDSroT5Xbr+UV9V
	XnZThk+1P6MP2XWaliDvrYaKVQXJPKxMVbp6QTohWxk8mJRKCcDwu0DJ9SQ1tALuvbHxwn
	nNvy/OfjMCiCFKhNj5ajmsjQ9kC1xlM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J4QrfcAY;
	spf=pass (imf14.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763654663; a=rsa-sha256;
	cv=none;
	b=2I6cIKzYbS5JemZmLHVCGi27DmWOMZxfvLuWjWkXpBC4TgX8E/G3PYRrApnXI/qIE0D3Mb
	JQLdURNvmvw35x8qgZH9OoGpiXjpEFG/wxsKKZyAOn217dRbkxqkA8jGMMBo2zeclbm5OD
	h5qwBvc+dbDyhOr04J005RUo6FOjW0c=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-297e13bf404so226525ad.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763654662; x=1764259462; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tTnphYAjSEIlq29e/RZNkDqM0RoIUblA3M5I8Z71iM=;
        b=J4QrfcAYR8PUsh/Ate+I+8cHcqWYRRTb/Pphb2++iyOPcss9ADiBy/SdW/PspZQPI8
         kOrqcAmoy63e+DJSRVoeE0J9oIUpw1lecyRH621oIAg2+rrHEDZ/tdT0N97krhhkSZHr
         0OAoNFDTCy9WwyiBlpcDHdCDaz9dwMJjfik5NpK/LdDQ7orw/PRZjaRDSLPBJuSCwbJa
         6+j4Mn6xa3Jf8oXAjKT0mkA8ErqLcdW6EiUNy04Uw5ZE9cR9exVwJ2R/zpV/aOVulK+j
         dOEKXr9nwOov9YHzZ+o6gcGDnV58zRRNBJ2ePp6US/awY5nmu5n3W3z+aPPd84HxRrKH
         0uHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763654662; x=1764259462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9tTnphYAjSEIlq29e/RZNkDqM0RoIUblA3M5I8Z71iM=;
        b=dhedW2rnVKdc9L9gDRVVeWLaPqdeT6343uVzi4+jeF/qJVa1tvXeSxZWPRI5iFXeZV
         RestKKA7i2SCHHBXZTQ13hYG05PTXxK7FW6SZWJaU1PD4qoZs5v99teGds1WwbnDqJA8
         ZJfztqwvHvzB7zbL5CYN3xrs7QiLFBs0wEVzGs+Vpey4ywYV4bF1RsqfNCaFCbknRZGE
         OuKYtXuxdIQkPSvXjUnPfcOBlrDmwRM8aR1o5Gmgza4Y3Uv9QYwdfabW5EjLhjk5f0fr
         dMuMLWIjTZVF1KN7eL8YPRDLvuuKKTpevepxqVLyT9SkLzkdaqlI5rInAc/+cu4ZcrWe
         qZgw==
X-Forwarded-Encrypted: i=1; AJvYcCWGwt/BbhmyrQR+UBhRLwjVULqCJ8fNTWvXY5GXqcwuM3uXlNMNFKjutM+x3wtxSw2R/uZuoBpjag==@kvack.org
X-Gm-Message-State: AOJu0YzrAJY5+QyAmC5VM7pnAPi29G1ndRNM6bR3PBHoh5z4M+xrNFxE
	twVRYax8zy2FTzrFUSuW8MVcpJSKRVO9AyZBk+oG9SURX91ZIhvqFdDmVdh3z9MyEy1lydN0k6G
	4ru5nBQ2/opwX6e/Dunts4VQsDiZpe+iLOZ5Kwq31
X-Gm-Gg: ASbGncu6CWufyl/Bh8/0be3WaP6nKGu7WqKohkN2920kRmDNMPcvottgEplZ2dLP6ss
	Ch/z7mn5GCKudZChTsY2Ge6fcepOdsAN2IZBK7Yn5g5gptihOyKvG1e0w56oJqjtzEGbPtTT7/8
	X1RjjY12/lKWw33uZP16SGy0s44QDl3XTvbwZDYCoupurxVMPbJokn1N0Ng99Yggd0IeqeRwBrF
	m84qXRwXSxd9V5IWqjaW/6Xd3wAvykwMSgajOzf9oKSeUX0+N2WKd39uzkgAwc713y2Zce6bHW+
	E0nWxblxEMB92+PiY89wScyK/4GuSu6uUEuJxg+MNIFqwbzK8t3A3rI2D1E+C97e1A==
X-Google-Smtp-Source: AGHT+IHynUK9sczZUoHA1q0ZmAGJEkBtS+4w0KysGJmGJqLQZwN0evaYPxUk6LKTwoHSjjG1XrM21cp8YOCaxEByK8w=
X-Received: by 2002:a17:902:ea0c:b0:29a:7af:b3e6 with SMTP id
 d9443c01a7336-29b5c57c4fbmr3798365ad.20.1763654661858; Thu, 20 Nov 2025
 08:04:21 -0800 (PST)
MIME-Version: 1.0
References: <20251120152126.3126298-1-senozhatsky@chromium.org> <20251120152126.3126298-5-senozhatsky@chromium.org>
In-Reply-To: <20251120152126.3126298-5-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Thu, 20 Nov 2025 11:03:45 -0500
X-Gm-Features: AWmQ_bk3tvcnm3lpvg41Hc69Iz4axfRrW4CpsfaVs1tHFtQsZ0HV9ebluIJicUU
Message-ID: <CADyq12zxgAAHWn61wECEo=StOm2DAEFU_qUL83tv0aT5S9mb0w@mail.gmail.com>
Subject: Re: [RFC PATCHv5 4/6] zram: drop wb_limit_lock
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4ED7E10000B
X-Stat-Signature: bn1z4mgij8sn8dmc9zrh6wfh4g6nei7r
X-Rspam-User: 
X-HE-Tag: 1763654663-121628
X-HE-Meta: U2FsdGVkX183j7wAFLeXJ0O3jjB5//TQQyu5KYjXzD0gjsR0UBf1pdw82rULee8648Xszhj0DKE7NycP94piQVUAcmGmftFSbbbP8YJBcGBeZMmsL6h1hlPceKdlRbrYq0usFIumOrAii+M7ZhKjAkuDLe5LRtm6e7R1N0eylnD9JAjSwNlLM7tylqE2M9qZ1hAxhqOU46adnq7SZD4Pd3Cvh2i1I0KI36HhEw7umv6aRlQoTZnH3wypaqhbtne1XZi6XVZcUmjS1gdyEr/XST6inoPMPbGqz1EvHY9uV/9pM3BhWypra8FludlD57YGX0XCfmmW4/jsssjTw37HDPkyQYigNK8Y0q0kR+HilKxl3nTVtj45oDUjIM/3HXFqM8evlKQDj2slJ0H9u+kFB60ice0Axb5pJ/BHNM6aUWiSNkwtFi7mpsdVNS5mhLUpXnQomUg6LGmZgnjNiyOL39Hrkc8MCD7hhZIivMH7NZUA9+AcWPVh+KqDtE4WzUICIERhruhI4kC9rYpGQqNj6UWr5iCZ0gl4YDhd37A0kemx0gFarL7UH+kLW26ONx88ze9kwzbg0Kt+tbBr6ZZD0mkwcUv5/IqLwcWSKUE3I5SEtppq7wt263KKlL3QuFrf6d3S/c3F6Jnvih4DETs0U6DIBzzsFE8omJzk8a+HfR54OehYS50lIv1PtV+MN8abo+oX87RtW78IKUMFwViHjIB8mTecgwBXBNDxBy9Ra/QOvpjkpcJV7WboT0x8VMFhdWn0ztbWpKTd+cQmEjnqAYO8an7B0HdTvSO1u0k1IQV15WBvnDm5NeBnUdjCT4A+WItURGHIyUGrFWfuIVXWx2L0KvbyckZpOZt3Ck7s8+W/ZKpad5kVZ0AC6C5ya1qw/oq0Xar+kruyRuyAoJLXolSo1WHCtMpBLedI66A2RVfSTQt8LLYCT1Fchee9c3clC0aCNvAqwt8tIlweQtL
 En4o39Eg
 RPezgWtim6qh4dfl5HLqLbXlqlDaDdfNIPChb9MASlr1HBXxqW6eRFvPLc21afyMD/8fAkl58v6tK9N8Amc4s18rjDiYBnUCRd1ElHbd7tqCv7SkOsGibqf1LYXLq5CjRG4kJEoNI40poDozwW5l8ZCDqBHcv36q1YA2IyXjAJBL+f6DBTUaPYh9SwiUkpXN6x9l2oOrdRhhjhxCFDIBbGHDv2UHsRkUBC5FP5KUuUyUECQZS39AJ9aJ7NH8vZvtvohjRcNZCZXjhRRA515ZaDS3AXzC0C4sWSrn6
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
> We don't need wb_limit_lock.  Writeback limit setters take an
> exclusive write zram init_lock, while wb_limit modifications
> happen only from a single task and under zram read init_lock.
> No concurrent wb_limit modifications are possible (we permit
> only one post-processing task at a time).  Add lockdep
> assertions to wb_limit mutators.
>
> While at it, fixup coding styles.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 22 +++++-----------------
>  drivers/block/zram/zram_drv.h |  1 -
>  2 files changed, 5 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 71f37b960812..671ef2ec9b11 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -530,9 +530,7 @@ static ssize_t writeback_limit_enable_store(struct de=
vice *dev,
>                 return ret;
>
>         down_write(&zram->init_lock);
> -       spin_lock(&zram->wb_limit_lock);
>         zram->wb_limit_enable =3D val;
> -       spin_unlock(&zram->wb_limit_lock);
>         up_write(&zram->init_lock);
>         ret =3D len;
>
> @@ -547,9 +545,7 @@ static ssize_t writeback_limit_enable_show(struct dev=
ice *dev,
>         struct zram *zram =3D dev_to_zram(dev);
>
>         down_read(&zram->init_lock);
> -       spin_lock(&zram->wb_limit_lock);
>         val =3D zram->wb_limit_enable;
> -       spin_unlock(&zram->wb_limit_lock);
>         up_read(&zram->init_lock);
>
>         return sysfs_emit(buf, "%d\n", val);
> @@ -567,9 +563,7 @@ static ssize_t writeback_limit_store(struct device *d=
ev,
>                 return ret;
>
>         down_write(&zram->init_lock);
> -       spin_lock(&zram->wb_limit_lock);
>         zram->bd_wb_limit =3D val;
> -       spin_unlock(&zram->wb_limit_lock);
>         up_write(&zram->init_lock);
>         ret =3D len;
>
> @@ -577,15 +571,13 @@ static ssize_t writeback_limit_store(struct device =
*dev,
>  }
>
>  static ssize_t writeback_limit_show(struct device *dev,
> -               struct device_attribute *attr, char *buf)
> +                                   struct device_attribute *attr, char *=
buf)
>  {
>         u64 val;
>         struct zram *zram =3D dev_to_zram(dev);
>
>         down_read(&zram->init_lock);
> -       spin_lock(&zram->wb_limit_lock);
>         val =3D zram->bd_wb_limit;
> -       spin_unlock(&zram->wb_limit_lock);
>         up_read(&zram->init_lock);
>
>         return sysfs_emit(buf, "%llu\n", val);
> @@ -869,18 +861,18 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram =
*zram)
>
>  static void zram_account_writeback_rollback(struct zram *zram)
>  {
> -       spin_lock(&zram->wb_limit_lock);
> +       lockdep_assert_held_read(&zram->init_lock);
> +
>         if (zram->wb_limit_enable)
>                 zram->bd_wb_limit +=3D  1UL << (PAGE_SHIFT - 12);
> -       spin_unlock(&zram->wb_limit_lock);
>  }
>
>  static void zram_account_writeback_submit(struct zram *zram)
>  {
> -       spin_lock(&zram->wb_limit_lock);
> +       lockdep_assert_held_read(&zram->init_lock);
> +
>         if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
>                 zram->bd_wb_limit -=3D  1UL << (PAGE_SHIFT - 12);
> -       spin_unlock(&zram->wb_limit_lock);
>  }
>
>  static int zram_writeback_complete(struct zram *zram, struct zram_wb_req=
 *req)
> @@ -1004,13 +996,10 @@ static int zram_writeback_slots(struct zram *zram,
>         u32 index =3D 0;
>
>         while ((pps =3D select_pp_slot(ctl))) {
> -               spin_lock(&zram->wb_limit_lock);
>                 if (zram->wb_limit_enable && !zram->bd_wb_limit) {
> -                       spin_unlock(&zram->wb_limit_lock);
>                         ret =3D -EIO;
>                         break;
>                 }
> -               spin_unlock(&zram->wb_limit_lock);
>
>                 while (!req) {
>                         req =3D zram_select_idle_req(wb_ctl);
> @@ -2961,7 +2950,6 @@ static int zram_add(void)
>         init_rwsem(&zram->init_lock);
>  #ifdef CONFIG_ZRAM_WRITEBACK
>         zram->wb_batch_size =3D 32;
> -       spin_lock_init(&zram->wb_limit_lock);
>  #endif
>
>         /* gendisk structure */
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.=
h
> index 1a647f42c1a4..c6d94501376c 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -127,7 +127,6 @@ struct zram {
>         bool claim; /* Protected by disk->open_mutex */
>  #ifdef CONFIG_ZRAM_WRITEBACK
>         struct file *backing_dev;
> -       spinlock_t wb_limit_lock;
>         bool wb_limit_enable;
>         u32 wb_batch_size;
>         u64 bd_wb_limit;
> --
> 2.52.0.rc1.455.g30608eb744-goog
>

