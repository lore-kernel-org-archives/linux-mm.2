Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94CBFCA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F246B0088; Tue,  6 Oct 2026 02:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF2B6B008C; Tue,  6 Oct 2026 02:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE986B0092; Tue,  6 Oct 2026 02:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E38556B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:12:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2B8E4053E
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:12:02 +0000 (UTC)
X-FDA: 85291180884.13.D99F15C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0726C1A0003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:12:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q3rPZtLL;
	spf=pass (imf19.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791267121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gj6RHy/jbDQ7XvW3Qfyv/IMf5W2R8V0RhoVCA/GC8SQ=;
	b=RixvkS2daW31hdiAcabzhulwsysQrFo3ZiHL35XFbKUCTe0/Njnc5IgvIi4Ptq/9p9+pLp
	HwpOhBS6i0ajDp96+Z2Sv8Wk/7/5N5Ur8xTPZe1K9As+a5DIOvIUhsvBgKcslTEfc1Fp9w
	u09O4kTkTBbHkZM2SjshkdtYQfRtLXc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791267121;
	b=3kTUmFrCtNDFDBvUWR5uyJC8wvXVn661dEI+eZ6wVKqrqEgQsAk5LZKD3nCOzpY2Crnfx8
	jHQu006k9lgybP3BH4IkasZYsknCDXQOyaewrQlIRTIdQOkttWKvANofmXAPQMxbR6nFlX
	TbCYZh3KNPpbZpKELuQS6ta7VtcvWwQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q3rPZtLL;
	spf=pass (imf19.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5337fa12431so129871cf.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 23:12:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791267120; cv=none;
        d=google.com; s=arc-20260327;
        b=OPrFSZuCHZDtIdWdi7e4rUwexQmlcy1EPCZtF63CtfaLbIRmijQKPyZaDb22lsLcdL
         Jqv9zf6eOV2z9Nm3xtygQ6lN9vL0eALOOzZYes3v/eKbaSZWCyKTgd6sTDnVwXk+sSgV
         B17GRA8yvIGjH3lYY+A5g1cEJ8FGUQ+3y3oBdelghstWdwbEGRTy95EuHQ2HTgNFXj/V
         wgEzfTt807cn/U+Y2UkBKB5mcPO6lA+dcWonx361hIa2oRJ7JRfnBsqTXl/+bKN2KOuY
         hsO1OZEuyV4TbcKJoLyf3ohKI3eh0ZugocvzrDFIVjjp7yt/zEclvaY5cEmA8rKzQ1sJ
         S3Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gj6RHy/jbDQ7XvW3Qfyv/IMf5W2R8V0RhoVCA/GC8SQ=;
        fh=sgTbzJkRnJsVH6Q0YD6OVrjGhQeVub51pdp7Di9VSXY=;
        b=ZYJXzq4l2bO5RIQ5FMw64Om7Yj+2JPk6hLl7DWAgX3oe+uVNyTNgKD6kMf24BwYSCp
         3w+IOASdjxBUYNF8E3v7M6N3whHfOyLIc9SumeHgPV46BCKjUPgX9Uz4h1kRsUKz/5Nm
         3CjpO/QTvvq6IuLlo+EP+FvJ/Up4hJKCgb77ksX0o0HNn2VhwHnj0HBlBdMMB7BZQlm2
         aMjM4Zh2uUG7r8LOSLUGIqd9tHCMdmr/6yc6Dt7xyPdEQ3+HUoz3KP8tsApAFcN3Uc3e
         pXWlubV+QOD6TEWK+A5X4zJVycJ1ZK+hcDVp2jCAMR96lXM4uPr66WGv//Ludi+FeT7n
         KDYA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791267120; x=1791871920; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gj6RHy/jbDQ7XvW3Qfyv/IMf5W2R8V0RhoVCA/GC8SQ=;
        b=Q3rPZtLLt7B2CmFkcwpikesyCZckEfhm9dNSrSXDoE9N0FfHRjuXg5mocT3DcfaRzw
         dcCBcsxtp9UVo4lNq0uNSzGezZBI3uxO4iD8HEZFVgXF+jleJGoQv4GvyZ0dHboWjKc2
         g8PcUz3scn8EDpE/vFUHQwfht18TKUyZFFHs8lEmqkZe9rDxkR6mccuwAnRiNDjrF0CS
         zPmFREHh6fSmGyNY/gbTUN/GKHkwxd6ZqObGozQkaN9ZNmRRkJLgTo6NHuKiHEDHg4n5
         QsdbssFFCYhXZiwiF+cIP4NH9K/R5DSF8303hzMf2vQeO5B5EN/WRwZBMOZ+vNDLqmI2
         2cEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791267120; x=1791871920;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gj6RHy/jbDQ7XvW3Qfyv/IMf5W2R8V0RhoVCA/GC8SQ=;
        b=vHAwldX2al4rbLlpUN3brIARwJ2NV24pmhBYSu8YHMf8g0HvudNfp7sfdCYVPjNzh5
         TBmCyQL/uEQ7zmZwLQ+mSPfKkuV5OJHUNhBVehfGkQSv/8LO1id4rRITt+Eq42I3F1Bn
         M0kB2T10NazYg6QRiSOURF7Qsw6h1J1Q1YvK3qjeHLyCWQXb/IKhAi1fSCBjAEHKDzXQ
         wVg2lDKxo270EO44cMeB9rDHNbiM9XTBQCO2/VUuRrpP6aY75MO90clGoyRsRf3nevI4
         XkX+mBb+2/3HyqsfYfj0gXREJgX5R1vJewi8f4LzRTMmhIcc5b/LUAdzL0GtT9pgyCh7
         VqDg==
X-Forwarded-Encrypted: i=1; AKwUvBzo7982zP2RIh090E649XxUi00VdFM53Uhm66d8pGBwxzsrwFtrV20ghf7iTUTHgk69DcKptHnF8g==@kvack.org
X-Gm-Message-State: AFuF++lqv32npIcWf9KgzCsJ1Qs0tUblioRhxhcPdszNUm3vL71TGAc/
	JaYKaNJD2nGYHrRk0KlqyVp35PXDuS66kHJRDZNFh+w3Oe2OCNaaW4/Rk1Zf//WZDad4DBS/S4K
	rGdqreFdZcTY8xZIFzyCrsEW8wQ1OcFZO09PQ1gCv
X-Gm-Gg: AYBFou0P6B7eCCHmpkgUOaD0xoE4FtMy5tiJwCwHsPwYulN0ltsj7hsLdARg+5NpQV+
	7e7jmTQ5YAcMLrLTfzUejKwbC1EvRVvK0DVEuE+uamhGDfJZX/ihUZREfmhKzXMd3gN0YzqXqxD
	T0Ei1FxKQrdDiuupc/iD5Fjxv6FcuIppRXzRSYfRI8sZld29DcNp92d1YjeOyRtCQ6S94uaLM5M
	gls48jICKAUrqeg2z9mECkRcNxb0yImnWJqqEGsOZRiUlTE6IRHBBbSO7YEEGzzdHVl7Kpxux8d
	ocCkiPsyLH+sdvcfkt6z/3uiVc8rA4O6Icq9uX0IO3wb2x0EGsGrEHeZG+8vxeSjx11aGRagQYq
	bYK92NneB23gl4bMiO69LWXCKGO5Omvj/1mly7Y5c2ohocS2hQwIoSsrw62aquye3/+FbyTplrn
	Pi1wXOCg2CQDZvulDNd2Sb5Gw/aTzE
X-Received: by 2002:a05:622a:5a13:b0:532:d36c:7094 with SMTP id
 d75a77b69052e-535406c5437mr11354271cf.4.1791267119345; Mon, 05 Oct 2026
 23:11:59 -0700 (PDT)
MIME-Version: 1.0
References: <20261005122036.718976-1-senozhatsky@chromium.org> <20261005122036.718976-9-senozhatsky@chromium.org>
In-Reply-To: <20261005122036.718976-9-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Tue, 6 Oct 2026 15:11:22 +0900
X-Gm-Features: AclHuK-hA3u42-jLX2PTceoOBTEETCWnRCw_Pvipfp3U7_-ms2srhkS8B0C_EQE
Message-ID: <CADyq12yNeSK-JW9QvrceqBRhrhRWRRA=byPSRC7482JgpodGHQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] zram: reset writeback state in zram_reset_device()
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0726C1A0003
X-Stat-Signature: jog8gnderxatozz6w313y98qzizyr8tq
X-HE-Tag: 1791267120-429261
X-HE-Meta: U2FsdGVkX1+OjgNvzkWK4PUWsMdGxfCpj3JNm3EH9OFNbzre/x5aDljjP80gkx/fn7frpB4L/SVJ80MGmq11raUvjf1dzJzo6ZG5pIoDnXgueqALBFtPRuzgXfHvlNE8fx+bvYnUOauyRKorsrkZlObmAdUI42YlsB4HcsWS8b5yUI4jIjrmyPWc8V5M7GTrRLWFp4r29h4BZjAVKR18nwWHeXuocsHSo9iZVN6ufevdGyXQasDvoNAAXqQYILWy/yYQ0mg6uvxD72KdlHgMx5FvW8+r/gYTUnAE+XE506jrWAGmPEeFQKz8wLjztuG9+BQYwbi8zB+9K2ipIfmPNjlTHUU/twHBGDvZBBxdwWNGuTo1zST4WGfK8xKDYgQ0o/7KVZ1yd7Q2/N8FlBSi2bnvmCzJRq+lfR0qJMRgTQd6tAL0WTpk/T+bTX4Fpb9/MT2kArYXO/b6/DY2E2DB+WK7Vmb3HPhI31hqIQ25B9tgxxul/zUq78tceyp40F0tKtzp5WZrMidDhG4mKBa2EabSxG5d44Z/7/IorrKNQDdPa5Mxkr4P5DMOCrUlxKC3YLFIHZv4DCWoaBGV+dfRzozpZbIWEdbNQr8wGuu70jjAjCSMBa0NSZU895FKCup1YxB2ZWNwpM//TziJkLsixF8zkIAfWPmL6IyZmFgtchIZ9FAYb02BSxmhetG16sugkjfH3GZLhnidxme/cQcM1d4UNRF7mttiTUWniOyo6b77jmAiOtc3hUTdtYbfiwP9IPNHn6QznjrjSI1SGYsggoVBpYVxOL06m+2RTBPwSBYGVdY+RxT5RJ5iuqQcsLL3/SVjC7zzGn4c3mSmmEUXKvZGamBmvm500jiIiGjM3ISIgEaxkxIfNRJDnNw1DYtZJkD7vithKuDgENLj0AEHG/4yaByCH90DiITQ/l0n9p7BiZpaWtCPX0syDLG1XE1m6s+jnRgRUT3faVFp0UJ
 VVx80twM
 mlkcjpS4zfVNL87mBf6oqhjAbOsZj7FUCDcfnm+0R3XCAb8r8lantCLdik5vLY773QOXidLCffRJel1Fgc/vxKfvvJEfvV5yWMbu1s/7ZhMHm3mAZ1Cv2TOlrJYF3fhpwf1GFb8xYoyX4Vrt8jBPkU8La+WDltoNPsygHhlWgJPPr/uW00YAylrcCH/lILcup80B0p7EHbJch401V7POiJE6BCGYZPsmTCVmrZh0U6KkBEULR0MkaJTBUwY3fHFjutcHpP9Y6ZdWQzzbp3kiYlN/At0DeqQYQwz+LnCgiAAQqicqUoyNUlvQ2zwnqLUWG2Owxzz7VREbnn1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 9:21=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Reset all writeback state to its initial defaults on device reset.
> We used to keep writeback related data in zram->stats, which
> zram_reset_device() clears, but commit 1d69a3f8ae77 ("zram: idle
> writeback fixes and cleanup") moved it (along with the newly added
> wb_limit_enable) to struct zram, after which neither of them was
> reset anymore.  wb_batch_size and compressed_wb, which were added
> later, are not reset either.
>
> Fixes: 1d69a3f8ae77 ("zram: idle writeback fixes and cleanup")
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 593fa4ae47c4..0e1aa0da11aa 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -694,6 +694,7 @@ static void reset_bdev(struct zram *zram)
>         zram->disk->fops =3D &zram_devops;
>         kvfree(zram->bitmap);
>         zram->bitmap =3D NULL;
> +       zram->nr_pages =3D 0;
>  }
>
>  static ssize_t backing_dev_show(struct device *dev,
> @@ -2881,6 +2882,12 @@ static void zram_reset_device(struct zram *zram)
>         zram_destroy_comps(zram);
>         memset(&zram->stats, 0, sizeof(zram->stats));
>         reset_bdev(zram);
> +#ifdef CONFIG_ZRAM_WRITEBACK
> +       zram->wb_limit_enable =3D false;
> +       zram->bd_wb_limit =3D 0;
> +       zram->wb_batch_size =3D 32;
> +       zram->compressed_wb =3D false;
> +#endif
>  }
>
>  static ssize_t disksize_store(struct device *dev, struct device_attribut=
e *attr,
> --
> 2.56.0.rc1.315.gc6ed9934b7-goog
>

