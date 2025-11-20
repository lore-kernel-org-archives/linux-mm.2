Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C78CF887B
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 16:36:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2836B000A; Thu, 20 Nov 2025 11:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B737A6B002F; Thu, 20 Nov 2025 11:36:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0286B00A8; Thu, 20 Nov 2025 11:36:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5C26B000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:36:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5467D12F199
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:36:38 +0000 (UTC)
X-FDA: 84131538876.22.46B3F4C
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 78FD7C001C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:36:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YWUNow44;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=bgeffon@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763656596; a=rsa-sha256;
	cv=none;
	b=BxxXoOh+GNM8378Wj4Hl6JIFv9er4PoXykykZy9x5qnI2jmasL6Mf7EmUh5bvyXyKAia+A
	fLu3J523MvIqkpcbZ0f3dMgEKJIBXlV4LPE/r/0sMFVr2a4p0mK5ODNhdU/Jt/1qN8OeiZ
	c0mlFeExYObJ6plcgvgE6miVMmyA/Zo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YWUNow44;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=bgeffon@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763656596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MI69GlEKOdT6dKGc/fqL6NZfHR0DisLkriIWy/ff1KU=;
	b=HXfTgxF6GaJB9KJ0CtiV8nm6AuyOqGuK+G+7LNhIE/PxMYhnAe1UXJSB+qc2qAPPm7AVgl
	F9U8r+44XooNqvKCLbEdv8UPg6xLJOyXcGfxQQV7KWyGQd1ItDDQyIyussSi0ZccssFGqw
	HYFdNfT9YsFJ1OZAg0Sy2MY7DeJIt0c=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29852dafa7dso201705ad.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763656595; x=1764261395; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MI69GlEKOdT6dKGc/fqL6NZfHR0DisLkriIWy/ff1KU=;
        b=YWUNow445RECeUXJWahYvF3BwwezfrYCK+Rp6/mYUNw/dcnTEdGq3O/n5aRLvghTSG
         slzAEl7erzAFuRNmdlyNP/UfiZzSMCEu7lzJ7+m2oWa76nmYheiL9XOGm5ZqJjtOfiYY
         wRgOebvShdZ6R8AD7JdJGHwKg8XIAsgXQXLuGrnwPCVJFNFozgLIi4zjDfMYBAtIwG0N
         eSCOFd6JF4RsvTldUZTHhY1/Uld9LFMT9zyUGHvhfYqN87All7hvdOyxOXooUfZEzSrw
         YxMIPVoqtqboJQf5DTyqoSKgtl4rfpsqngvSUWeWj5qXXR+R+4UiIfaIwhiq3+PASdlY
         yrkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763656595; x=1764261395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MI69GlEKOdT6dKGc/fqL6NZfHR0DisLkriIWy/ff1KU=;
        b=glaqmUl5BIIOqnwxX1uH2QVIfohgsMUPtYu4xC6UCBq6mJn4suTRBNfV50w3SYQj/F
         BOneyls/o3N4HtRPMhuJy4jKKF9n8FGaZ1c+vQlGWGbAcYogigHLdI8j/sL27yTozgvR
         ycMjB3r7Jc4Mlv1CDi5xo8W7RQyVrYU9v8yf6r8H95GDeBwNo2oLL5DpI2AKj8ysHZoF
         r1w55IjSPOlpNFPKqhN75FcM5tIj55Ca4qPx/D6Sp8G1QwfbaxkTmwqRrz6jiWj6Z2o6
         TCSzQquGXGa1y+jRV1NuaEPWy6pEBXYVAidHCvfcENjzKRqsYg8yLRwOxwE4bNs5ZbEe
         qh+g==
X-Forwarded-Encrypted: i=1; AJvYcCVSZHNhROpDV272YVz5weeeKqIUS2WRO7OnOTUmqDf4/Cgluv/hXIHq97Q5p0gNcwgL8s36YfOYhA==@kvack.org
X-Gm-Message-State: AOJu0Yx6as927Jy025IZFhYpNj9nIZKmyN0SN9gtg8t4XNv6ug6M3REJ
	pVD/UNzhsx9BUicreCQXNzAdzmEX3eKKUpY43Oft7/avwdOCy1omFrTyWCmvK90FGYenhBvpgeO
	k4XzXdmHp9a8Bt0g5rTSKBeJf4YwPRXKh85bQgdMb
X-Gm-Gg: ASbGncsDhmfcDeEVVl6odN9FeDz0BT4hJUeCSp9dOCxHTa/IX4w2AgLlqMr7RJ0HPAE
	gKUxxJBdCadExK6FfEwTwv/ll/swIhRzZ50BwPfzVRhFgnFbFPwEmcGTnxna9VR2u7eqwn54XrC
	0P2KkqY7joICsq8Q+55ji8Tv6mIqgAPhIPc/lp3KaJXoK8o078IPLYzoZDMqyoveXC71L2wt4yt
	QtisrfqEQRDlSujiSvt6TDS0faXx2slxyeGUHc65BM/0S6hRPu8fvbLdQX/mme9mmkKJGcmFoH2
	ruPEHItxBFYK1wFB4fAaJ6finJiqu3YZGqrTw7OtLuLaKUSdtw7E6Tc=
X-Google-Smtp-Source: AGHT+IHwbZhiTefJHOcoxsF0WPPJxsxN9tQq29Zp/xNBgglgSM1gNp7NoJsF7O880AqiUsYvqO+T4BOUMSNMohb/Nbs=
X-Received: by 2002:a17:902:e54b:b0:299:c367:9e04 with SMTP id
 d9443c01a7336-29b5dc5dcf8mr3271095ad.19.1763656594872; Thu, 20 Nov 2025
 08:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20251120152126.3126298-1-senozhatsky@chromium.org> <20251120152126.3126298-6-senozhatsky@chromium.org>
In-Reply-To: <20251120152126.3126298-6-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Thu, 20 Nov 2025 11:35:58 -0500
X-Gm-Features: AWmQ_bm7DruXduZIQpRB_jSdesTnBG2UEkernRi3vrpgktZOUbhhguQOJZM17i8
Message-ID: <CADyq12xHEQ4aFRdVDMkmuA1-r+FU7N4O7-8UUTpD9ACFo3tuZA@mail.gmail.com>
Subject: Re: [RFC PATCHv5 5/6] zram: rework bdev block allocation
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 78FD7C001C
X-Rspamd-Server: rspam07
X-Stat-Signature: 3i153ht7fe9she7atnw84i87mzoe9d8j
X-Rspam-User: 
X-HE-Tag: 1763656596-705816
X-HE-Meta: U2FsdGVkX19WvdHkiGjxrMHXflWkP1FG6hRuUrn3B7pRbTLC8AO8qF2GC2923PolIcAWbHRqyJha8Y6LPim2DgtjZkbvC9A4kYJ2twxCHfhTk0bVtl8AkWwGGsOhRYTfQLHaLNciVfnsbOicyryekqjau81YfcEC9yNlAsXA3DelZBFTKjwt+J1HrfbwsdbYQ7UfuWmRz7T2Vv04Ff2maXJ9ZWOltaDPK+rDjQKrrhjfyxfnmKAXW+v6nQElUiBknZVX1riJB8aQTu6MfdeUfhCMtZguRxu9WBHsOaoYfHzLRojNEw7nBTrOwl+XTfZ/xLUSuBU+m3W/MWF4wyxc3XxrJfI2ZhBN1pGUiA50z5x7S/8ctma2q/Jr6TdcRw8xYcIjohUihCWFeE5I+AUCSYfIiLU+vKvXUq5OeguV+whG9cIzzkLJqkWBsZJV9CKWDkpTlHN5nkqhw6D/ZVL63yaffZzhkhKToqmJMeoq40Zj4JogBaYkXh9h/FF42vejBgPvdDu8laT8FFjWO75oaJNb42bc942CwoOFgGcoe3ADOVJVer46/EyOAN7nyWZVNymNGG1oxLkVzyU6YnrDOh3XXK/OP25zfuphv0OAECp00OxDdhDm555ZDoBphg8VC/wZQLhW9xvntF3BqO7TlOY81bVsEb0do4fg2/f6fbg8PpNTa8UiONXeMxD6uUYCtuaayc4GbDrrwQF92hagqE3UDkZcWaY0Id5/5GDYgYoJEK2Ov+ALoKwQVykikMS7xSVz0pBmaRBcCNd0lRQeqOZwhgucCHNgof1EiVCzk7RGuJWzAARl+ZJe4FTP7AIZo1qgxiTGseb5FXWja/5XVpjtiFyTvIP5LjAx5+jrJWfDq644Lhtwd+89i3MO95oYqIpsp13sUxxdn8uv1YiHJ5bEceaAGmDzY6tjHwOd85ZmFrc8UuKWgybhgFJTRJvspEJosFKwZNTzAUp4GPH
 RIob5VH+
 l8PMAwxEj+NDZncXtK7rsPltiGveWQtDDJopkgPuMWLB3nQFLQrxkvcFHx7Co8WLbUzFhh0Dpzmrt3csoISLhlryvN3kt5KbN6+x1GdiOY7u9bq2b6rAs4dSMq2h0RUm4lVxcTRPkJX3pC3DNQjpy/R8NxtgOLEGbrAUipjvTvSjNLwl1xsn+CX9e1dhmHNfKr4bTVl/e+YgzWuC4FuMYXcZEWIkXG/IyipFYb6OHIFtitmg=
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
> First, writeback bdev ->bitmap bits are set only from one
> context, as we can have only one single task performing
> writeback, so we cannot race with anything else.  Remove
> retry path.
>
> Second, we always check ZRAM_WB flag to distinguish writtenback
> slots, so we should not confuse 0 bdev block index and 0 handle.
> We can use first bdev block (0 bit) for writeback as well.
>
> While at it, give functions slightly more accurate names, as
> we don't alloc/free anything there, we reserve a block for
> async writeback or release the block.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 37 +++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 671ef2ec9b11..ecbd9b25dfed 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -500,6 +500,8 @@ static ssize_t idle_store(struct device *dev,
>  }
>
>  #ifdef CONFIG_ZRAM_WRITEBACK
> +#define INVALID_BDEV_BLOCK             (~0UL)
> +
>  struct zram_wb_ctl {
>         struct list_head idle_reqs;
>         struct list_head done_reqs;
> @@ -746,23 +748,20 @@ static ssize_t backing_dev_store(struct device *dev=
,
>         return err;
>  }
>
> -static unsigned long alloc_block_bdev(struct zram *zram)
> +static unsigned long zram_reserve_bdev_block(struct zram *zram)
>  {
> -       unsigned long blk_idx =3D 1;
> -retry:
> -       /* skip 0 bit to confuse zram.handle =3D 0 */
> -       blk_idx =3D find_next_zero_bit(zram->bitmap, zram->nr_pages, blk_=
idx);
> -       if (blk_idx =3D=3D zram->nr_pages)
> -               return 0;
> +       unsigned long blk_idx;
>
> -       if (test_and_set_bit(blk_idx, zram->bitmap))
> -               goto retry;
> +       blk_idx =3D find_next_zero_bit(zram->bitmap, zram->nr_pages, 0);
> +       if (blk_idx =3D=3D zram->nr_pages)
> +               return INVALID_BDEV_BLOCK;
>
> +       set_bit(blk_idx, zram->bitmap);
>         atomic64_inc(&zram->stats.bd_count);
>         return blk_idx;
>  }
>
> -static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
> +static void zram_release_bdev_block(struct zram *zram, unsigned long blk=
_idx)
>  {
>         int was_set;
>
> @@ -887,7 +886,7 @@ static int zram_writeback_complete(struct zram *zram,=
 struct zram_wb_req *req)
>                  * (if enabled).
>                  */
>                 zram_account_writeback_rollback(zram);
> -               free_block_bdev(zram, req->blk_idx);
> +               zram_release_bdev_block(zram, req->blk_idx);
>                 return err;
>         }
>
> @@ -901,7 +900,7 @@ static int zram_writeback_complete(struct zram *zram,=
 struct zram_wb_req *req)
>          * finishes.
>          */
>         if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
> -               free_block_bdev(zram, req->blk_idx);
> +               zram_release_bdev_block(zram, req->blk_idx);
>                 goto out;
>         }
>
> @@ -989,8 +988,8 @@ static int zram_writeback_slots(struct zram *zram,
>                                 struct zram_pp_ctl *ctl,
>                                 struct zram_wb_ctl *wb_ctl)
>  {
> +       unsigned long blk_idx =3D INVALID_BDEV_BLOCK;
>         struct zram_wb_req *req =3D NULL;
> -       unsigned long blk_idx =3D 0;
>         struct zram_pp_slot *pps;
>         int ret =3D 0, err =3D 0;
>         u32 index =3D 0;
> @@ -1022,9 +1021,9 @@ static int zram_writeback_slots(struct zram *zram,
>                                 ret =3D err;
>                 }
>
> -               if (!blk_idx) {
> -                       blk_idx =3D alloc_block_bdev(zram);
> -                       if (!blk_idx) {
> +               if (blk_idx =3D=3D INVALID_BDEV_BLOCK) {
> +                       blk_idx =3D zram_reserve_bdev_block(zram);
> +                       if (blk_idx =3D=3D INVALID_BDEV_BLOCK) {
>                                 ret =3D -ENOSPC;
>                                 break;
>                         }
> @@ -1058,7 +1057,7 @@ static int zram_writeback_slots(struct zram *zram,
>                 __bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
>
>                 zram_submit_wb_request(zram, wb_ctl, req);
> -               blk_idx =3D 0;
> +               blk_idx =3D INVALID_BDEV_BLOCK;
>                 req =3D NULL;
>                 cond_resched();
>                 continue;
> @@ -1365,7 +1364,7 @@ static int read_from_bdev(struct zram *zram, struct=
 page *page,
>         return -EIO;
>  }
>
> -static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
> +static void zram_release_bdev_block(struct zram *zram, unsigned long blk=
_idx)
>  {
>  }
>  #endif
> @@ -1889,7 +1888,7 @@ static void zram_free_page(struct zram *zram, size_=
t index)
>
>         if (zram_test_flag(zram, index, ZRAM_WB)) {
>                 zram_clear_flag(zram, index, ZRAM_WB);
> -               free_block_bdev(zram, zram_get_handle(zram, index));
> +               zram_release_bdev_block(zram, zram_get_handle(zram, index=
));
>                 goto out;
>         }
>
> --
> 2.52.0.rc1.455.g30608eb744-goog
>

