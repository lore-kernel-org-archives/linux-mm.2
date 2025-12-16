Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F69DD5E38D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766706B008A; Tue, 16 Dec 2025 09:44:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7239F6B008C; Tue, 16 Dec 2025 09:44:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639A66B0092; Tue, 16 Dec 2025 09:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C86D6B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:44:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED6385A06B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:44:08 +0000 (UTC)
X-FDA: 84225604176.11.E53B8C6
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id E7C6D4000A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:44:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YsABfLFy;
	spf=pass (imf17.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765896247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KAmi/53GD4BVHhy6hIhjJyr/xMy23CdsxEuUrYlt9C4=;
	b=pTH5wa01wbyvUGlHznFxxxk2Wp7otcHcaqHuVWtqihlpahTW8z+bbi0XEG/Ir8fRcPSrKk
	KasKt72hj5yTcmsg19CjgA3+aP29hYhlsCxwbupRuWiLpydzewulhKvRK4eTFZIIiQFqFF
	HeXus4gcesgQ132m9j3q6L2Maj7QBsM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YsABfLFy;
	spf=pass (imf17.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765896247; a=rsa-sha256;
	cv=pass;
	b=aC03j10SeA3iuoH9HBUBuThRsDraoz/MoqFi5oQTVz5haAnv5dXwECcT7oBs6WSUh5tu2B
	g3BCs15qPS7Hw48b7v0BmU/rnh6RkzCqtvP4js6jsuiZmZFHroq4QQv2ZMHPefFCVFyy0z
	kvpxMVbL1NFB5fUwPErBQ4vapWM9xt8=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a1462573caso75905ad.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:44:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765896246; cv=none;
        d=google.com; s=arc-20240605;
        b=dP3/BPBvY4TAnhXyeWAVWcWXgoyvQZdJO1SSJkoTELqHTvRGbagalikQE790W1iEaY
         ++ooZYZm/aYQDspEIkYSVbY9efTmtoy94m0ud8HhnMsnDuAsXzvVidQ+mXY9RSjNoIJP
         MNet3kFHJnKUvjyk1BHtEAcTFA1JytasxP4GaVbD0J3Zi16gpDXV4qqb407xGwAes7G/
         0m6HMotWsEOMI8Uy8b3YvE1ZS6VYzSX1GV5yBhQ1tj0w9O6JE+8q0wf2kRABwk3q5VI2
         om/cMuDP4BhIittKiEEUaFSfg3rv5sShRcBgQNQ9o8ZHFHjiso7uxxHNF+4YBR+bOwDf
         cY2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KAmi/53GD4BVHhy6hIhjJyr/xMy23CdsxEuUrYlt9C4=;
        fh=jQxxm1+jcIEPITHRc0b7+fuGO07dfvXcTaoq9HBF46o=;
        b=KGpkcl3KGptcmvhm84NKsGILHkLMJNtxLXUfLEORuEsxB+lTjsaf72TTkVsfdXPsdD
         t8CyVcXbn38PB5J18zbyrlWW/gpZ6lA3hTtB4oFUzQRsBGeOxmFaaTJKxhc3IkvvYIIz
         cwZ04p6LDVZJrjcV7VhIItuL2ZrOv8HPAEvzuEliTXkH9O8ZihaKBzibMo1/KbeJ2Q4D
         INlcW9xrf2MC4rIoFTJL0Su7JB/P7m5cEVQo+1ZIWVVAaLgcfZ1zmC5LZV4dxjeXGQGf
         QQxgsrHPDMur9tD+ZeunZdkb0p8aJopOIBYfVQYTjO3eeOdsOQW/1WdIwtChoojGB36L
         vo5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765896246; x=1766501046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAmi/53GD4BVHhy6hIhjJyr/xMy23CdsxEuUrYlt9C4=;
        b=YsABfLFyichiAvWiEkGGhIhaj/A39ijiG79M/PGSzJRrAV5KtqtvwA3ADi48eOMp1e
         93QgBV7Lc1vQSWts4oOI3FCHLTaLimif8W35Ob/FUhAVjDIBhixzLyIXBtKzaDSqCqY2
         aHmP2b+IVzKjQ7qeSICN91GPCUQsJXXbGn1O6UZ3W7DkYXvpSrjRtvlvbAvBfOM/o5nR
         XsbgvTn7Rfnw7rjOshorogVIZtD5bmguuuL70p9DyBGaa+WsYtoTWU3js0L3wjunRqDd
         tUIMqlc0h6u+XBiWCfpkJgIJqrArcp06vz7X1DeYXZXr6gjnO5DbHAAmUbANsn0PSsgR
         aLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765896246; x=1766501046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KAmi/53GD4BVHhy6hIhjJyr/xMy23CdsxEuUrYlt9C4=;
        b=AB7P/YpMDru2Vm5CUIHSCYz1cfTKk9i6ahaV10OUK59mR2ppYCckMRiwlbwkunzhEm
         2bOgkfrojslPcsmzPlHM6brfouYesNjp/53Pa+QSUSr0KkO/sMtIno4ZBZ9EWSXdk8mJ
         dHW30P1NStZ2ygr3zytnjrQB2b7kz4w+472ivjqQ4/NRLxdOfwbicfsPN5nduepCbwhj
         pfzvPXHiyiwwfRwx8Z4lnwRr8m679BgOvhqEFJaEolGUiWzltrPagXlUerFAKinZyYtT
         5qFJvGqsix2z2dG8xzqmE0JwmyyW4fxPb2lzd+NxoJGIVR+LfuXbZjCMIDl8XFA43n5r
         SNGw==
X-Forwarded-Encrypted: i=1; AJvYcCXFCbNT6CwAQYyQt4ZSnnr5O2IIqxhUglHbB8AwCbdlz/E/FbZAlqoKeawZlZ62NMFPJ466QH5znA==@kvack.org
X-Gm-Message-State: AOJu0YzT7MkQJL3vz71SHfe/5U9f92SpN25zV3mNU2wGiPleTxSIE08N
	dmwWWjziK5z6HPNV7XL2Yalh+D6nTKn5lB01px1uZoUuQhZu06e9jqufDOGVygHh9bh4kfQnXGr
	FrPCO4lvdkGdT8VW0/TNkR5x/XHJA2g7wPf768y9R
X-Gm-Gg: AY/fxX7RyQQ8YL23D0IVQiwto0E9XGFi3vXzCi38vz6GQ0aGnIH5VLUk9zVYkJ4C4tr
	NDC8sf0/nA4amJxUZ4nSu4mcpBNtUPQMTEAmmr9qq91JyJwxxPkPnBwyoYiPAf8SvwxtnpHEfkG
	46hPeDcMpmn0ZIV2veGB17VQP3kwBNQk+e08LkGOhYEM7rZ/yEuAxn81M9EcsD1hd178V5hKShT
	iBFFlWmI8Ld/JcPy453RpzlZQbvCdHxMnSW43nPz9XveOzeHyWcpZrZieWpvciYb5tdFRmP6Av2
	2/RcJ5NO/xvuMEgylijZoBiB8jUWUADomnpsnhqWoG4nXOQ6mk9bGNg=
X-Google-Smtp-Source: AGHT+IEiK8lrjUxMAkdhPuZBDUC8WfG1CK6GP/FrJkLfqWEXiBqNJySSdrcdekRlORQEPtUvpXfHdKBF+4spMZWn6is=
X-Received: by 2002:a17:903:4b2f:b0:297:f0aa:d466 with SMTP id
 d9443c01a7336-2a13e0e3be4mr1282645ad.8.1765896245495; Tue, 16 Dec 2025
 06:44:05 -0800 (PST)
MIME-Version: 1.0
References: <20251216062223.647520-1-senozhatsky@chromium.org>
In-Reply-To: <20251216062223.647520-1-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 16 Dec 2025 09:43:29 -0500
X-Gm-Features: AQt7F2q7zRmUgCShM6gfRxNMMZTahWG7X3HrXL8-Yqad8hiy4OHSH28MaqpZh5Q
Message-ID: <CADyq12yidNfeoRtUONM9VkdXpzZVbKy2+VYSJJpGqZtd7BqD2Q@mail.gmail.com>
Subject: Re: [PATCH] zram: drop pp_in_progress
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7C6D4000A
X-Stat-Signature: na3gfc161x67sndwjtzb1wc6q5gtorrp
X-HE-Tag: 1765896246-830437
X-HE-Meta: U2FsdGVkX1+UzwFMBY0kS3HppIIefBG6I0pb9RYSVILE7cGTZ36lN0IODUf67FbxZ5S5wIMh0CFuXB95rXrXJG0E1nQACDsBsgSDD0uShhIHLHPAYEzDQ5DAOBeFLz8Pc7+Lqo3B/HtpEfyX7cF1gVtVM29M3yoAv8RmWZI+VynENp0ccMQseYrxo8G6Q4oUf0HCVro0/RMYpEecp/OX2nwBTX639ecQK1A35+R9B4ZVLH+s0TYnNp81DAwCchTn0wlDLKlVD3+sshUvX5t3+mJSn19SgaKQNV/Al9Eqg27A/vUN4c/vbohgMRzUcCLlFjxfSP0cWHaLtr+romoWIMpRJGTabdjU/i69fdlzI9OWlh6zbOnFN9zvAyeNf91EnRZ5Dk6+obAEraSpxCfSk0/3g/leOPjgpHWEea6O0FuNy7FvKe22NvpBTn5pe0WWjUkJFJNVPocOkYc0vYsoKc5nyH8Sxv6HTuXsvvEETdTf0eONGJr0S2Cgq2nphfUP1LCfVpRQM0bUYhK8SKEsAzieqt5v+09usjnpIsOHBL0s3Whny7cL7YC+cWL6oapjmgBMuPeiHmPlwE1ExoLJAfn9FxPvklx620ggblRVzGNEi8oOY2ZdjKu1/WNA/K/79pfAi3V999y5/0yLGP0Xv6waVR9Ip/vMtrXVxEggjyaJZWJB7yol4NuGsbPmDM0TjmIKiPMEldJvinx3CC4+SqlkV9WfF8qTyBADWBIeEQlfd+/G3Em7q9nMfwRlcCz4K0Li6AdtyePXiW+FgDLhSdPrg22IkU2KxKRgIzJysFxPxRPo/lAV3BtYuNjKee+F3Ln/5T7uXrBd5lKDvCkJdEfID07f+EgU/zvqi8PysXm1yNzIRnLHkJIb3sQCeTe0MWGh7eXx7cfv6fMszD3aT3cST/AqPew8SZCHzSA7rRmnmjhhOYXPuliu37Po1Lk2JiAgOQBUz28Epw7Qfzk
 /WhoM1VP
 B7gGdYdp1Xhzb2U86POnuBz3ddsonFNiny8uSLTkimOCwx11NQGnXuNJQ10z4gx6C2JMcybqD7g2qhQXNg+mzRx5Zsc2i8bC9tAMhAWtog0Ru5huUFToq315KEvCplNqe0WpqWhU2RQe50DQh3/YKXSEwv9ZWn3yv4BvNyCrgNro2wIB6mnH+idvlQQkmudUpc4YKjaV8j4OoVdimus5jsoir0ir051pepOrlYM2TeYEOeITuex6U8RT+dMUmt4B4YsD8Fw6eiKV2cFrst5KXv8uaTdmcd7JbhyF2ZL7BwRB2Z9JN4eCz1BKHrNxk6P+x99kZrZz8RpYt5RBl6ns+xI09PS0PAd+UvmiMn9SZmtIQ1S35i6vofEPplWJYczqPaLzE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 1:22=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> pp_in_progress makes sure that only one post-processing
> (writeback or recomrpession) is active at any given time.
> Functionality wise it, basically, shadows zram init_lock,
> when init_lock is acquired in writer mode.
>
> Switch recompress_store() and writeback_store() to take
> zram init_lock in writer mode, like all store() sysfs
> handlers should do, so that we can drop pp_in_progress.
> Recompression and writeback can be somewhat slow, so
> holding init_lock in writer mode can block zram attrs
> reads, but in reality the only zram attrs reads that
> take place are mm_stat reads, and usually it's the same
> process that reads mm_stat and does recompression or
> writeback.
>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 28 ++++++----------------------
>  drivers/block/zram/zram_drv.h |  1 -
>  2 files changed, 6 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 634848f45e9b..47826d8ed376 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1264,24 +1264,16 @@ static ssize_t writeback_store(struct device *dev=
,
>         ssize_t ret =3D len;
>         int err, mode =3D 0;
>
> -       guard(rwsem_read)(&zram->init_lock);
> +       guard(rwsem_write)(&zram->init_lock);
>         if (!init_done(zram))
>                 return -EINVAL;
>
> -       /* Do not permit concurrent post-processing actions. */
> -       if (atomic_xchg(&zram->pp_in_progress, 1))
> -               return -EAGAIN;
> -
> -       if (!zram->backing_dev) {
> -               ret =3D -ENODEV;
> -               goto out;
> -       }
> +       if (!zram->backing_dev)
> +               return -ENODEV;
>
>         pp_ctl =3D init_pp_ctl();
> -       if (!pp_ctl) {
> -               ret =3D -ENOMEM;
> -               goto out;
> -       }
> +       if (!pp_ctl)
> +               return -ENOMEM;
>
>         wb_ctl =3D init_wb_ctl(zram);
>         if (!wb_ctl) {
> @@ -1358,7 +1350,6 @@ static ssize_t writeback_store(struct device *dev,
>  out:
>         release_pp_ctl(zram, pp_ctl);
>         release_wb_ctl(wb_ctl);
> -       atomic_set(&zram->pp_in_progress, 0);
>
>         return ret;
>  }
> @@ -2622,14 +2613,10 @@ static ssize_t recompress_store(struct device *de=
v,
>         if (threshold >=3D huge_class_size)
>                 return -EINVAL;
>
> -       guard(rwsem_read)(&zram->init_lock);
> +       guard(rwsem_write)(&zram->init_lock);
>         if (!init_done(zram))
>                 return -EINVAL;
>
> -       /* Do not permit concurrent post-processing actions. */
> -       if (atomic_xchg(&zram->pp_in_progress, 1))
> -               return -EAGAIN;
> -
>         if (algo) {
>                 bool found =3D false;
>
> @@ -2700,7 +2687,6 @@ static ssize_t recompress_store(struct device *dev,
>         if (page)
>                 __free_page(page);
>         release_pp_ctl(zram, ctl);
> -       atomic_set(&zram->pp_in_progress, 0);
>         return ret;
>  }
>  #endif
> @@ -2891,7 +2877,6 @@ static void zram_reset_device(struct zram *zram)
>         zram->disksize =3D 0;
>         zram_destroy_comps(zram);
>         memset(&zram->stats, 0, sizeof(zram->stats));
> -       atomic_set(&zram->pp_in_progress, 0);
>         reset_bdev(zram);
>
>         comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
> @@ -3127,7 +3112,6 @@ static int zram_add(void)
>         zram->disk->fops =3D &zram_devops;
>         zram->disk->private_data =3D zram;
>         snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
> -       atomic_set(&zram->pp_in_progress, 0);
>         zram_comp_params_reset(zram);
>         comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
>
> diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.=
h
> index 48d6861c6647..469a3dab44ad 100644
> --- a/drivers/block/zram/zram_drv.h
> +++ b/drivers/block/zram/zram_drv.h
> @@ -143,6 +143,5 @@ struct zram {
>  #ifdef CONFIG_ZRAM_MEMORY_TRACKING
>         struct dentry *debugfs_dir;
>  #endif
> -       atomic_t pp_in_progress;
>  };
>  #endif
> --
> 2.52.0.239.gd5f0c6e74e-goog
>

