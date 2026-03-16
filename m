Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A121F30296
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 02:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7376B00A9; Sun, 15 Mar 2026 22:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564D46B00F4; Sun, 15 Mar 2026 22:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446E96B00F5; Sun, 15 Mar 2026 22:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 315126B00A9
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:23:37 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E19261D5CE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:23:36 +0000 (UTC)
X-FDA: 84550330032.07.B5AF911
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 24C3640007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:23:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lxxAD5K0;
	spf=pass (imf01.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773627815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sL9D+UNbJ7e4W6K6buLxChN3rfm9QdJVzjRxuDMxvi8=;
	b=mds9i/kPAOO/+ju0z1XxeB678IiTk2SgdC+4/jYhirZJ0XNUK1WX8Jvc9ud/zPB2g1z7CU
	kXlozI+tmmgxeK3B8shC1Z1F1NRnzl7CFl+6P3fiFyeE3X8VKTQMhn05fQw9E2dP4FoHvI
	jSyyglgkCL+1DDdhh3NgKduWqMtYzhU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lxxAD5K0;
	spf=pass (imf01.hostedemail.com: domain of bgeffon@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=bgeffon@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773627815; a=rsa-sha256;
	cv=pass;
	b=uN7urb3bcWwLmI8QVqxsW7YskFjPEsydN0xygD39CrO6x/LB20HOmy/xieiXwpLAGjLOGe
	J9Q0SX0K7jMVO1F0Q/ol94WnGNWCpO4MbqK645qeO4CVyWvO3YefU5ysuCqGQETi49DYu1
	V5Ml/b3hNjW0bjwyGtKVP78EcyXwC8s=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-509069a7a7fso802941cf.0
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:23:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773627814; cv=none;
        d=google.com; s=arc-20240605;
        b=MsVwiewyWjZ2pCBlD3uE2o2NcYR+IGIwTFrbN8WbJUT2xGLR/rexoTboSCqtdW9A3L
         q5Ob7q8JWg5hL0o4y31c3SVQH1q9nU0xfh71Ebmuu3my4iVJ6sbnRN6JQlEIBz6a/32G
         R9MKhB3GH8EC6CNjuVhArYtrHJhTz16fbMKwFVZNy2hkwqyJPXP+lCp2HOWe8xo9k0Oj
         +GLd2Z2yJSB6/1RDm7ZeBD81pPKGVHNyy97T9Y/+2GeRgz8vWuWn4RZ6ylmKy6iOnTby
         /R+bGa/cmilROPtk192MLg4OWSpQ9LESYPwTt2d7+c3AUm6+fBh3HdS8SaX0KH6xpDmM
         Q7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sL9D+UNbJ7e4W6K6buLxChN3rfm9QdJVzjRxuDMxvi8=;
        fh=Jb5EEgp6bH2Ok2gyMtSTomYfYeFqAEq122JPVKV/yEU=;
        b=Exvl1iitcIh1jwme6EGlxXyTvjVVGdPdA70h1iexkp+S1DRL9VypusKip0KRnsAuPP
         oSjAOLnFud29J4qoslyEWO+zTJVZsILw+L3PSpeUnRDyNUff1GiawKuclw480W9zUl/N
         CezBrhT0R0yJT3fx8mDAUhKIKqiVLnZw4+5q16nwmm3DsN2ChZ/aem2Q45Q8TqO5rb/W
         ZxvnvGcA2r1m3YPomS8KSxkV6Zuydby/BQ5y3PsJBnreVtiBRBv1L778JLwcLdprQgVG
         pfu0sp8sKpoznqlVdFn82SBC9n6PW5VTxWsm6nnDjtgcZA1W+Q9gLfGL4/sRDUHABpP/
         YAew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773627814; x=1774232614; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sL9D+UNbJ7e4W6K6buLxChN3rfm9QdJVzjRxuDMxvi8=;
        b=lxxAD5K0UC0K0GOpSoAo0Tb1JNvIpT9PO2OTcADS1SZx8s+rMSGmMIIBL1+h7Gc5sX
         enP8Wl51vr0bN6JXouTbDTQF7vrhEy3yMPUbDFyPS6J24Tt3tjOinD8T2OXXd7WGtFVo
         1nsRwapZMnpaVsnE88GpsU0jLYZpDS+8Upt1Q98bvnP2NeBiiWyY4DFsyYs5UydWG3td
         etMkbBPmU8aTldq7lMJdFtSC8DW8y1EO//Ewx/jSVxCWrXUBiLfOFLeqVEt5SjkANalS
         3nlCJkSraOWMlUj7Z+kHWAp993XxCzDGsS/cVPQfYFuITs9dVd4oBiYFLQAcnhOM5xHX
         3qsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773627814; x=1774232614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sL9D+UNbJ7e4W6K6buLxChN3rfm9QdJVzjRxuDMxvi8=;
        b=G5HccFueKSXWyHrfuluhj5fHf2K6zFB8hiuj4fOJb2FvzhXeqD4D+hzzlM+dQZ+MKn
         hp5fZdbKWHWISVlVcsWEHhjnh+sGqIf/wdqipHg9SwV4G6H7g2b3VAw1GNcuM+CxD5al
         LlcCY2aUM0bu7sIntyv+vGYMx/lZc0oPkowvPN1tjCQ0cuOAGAhi+8mQgEp/rSoBud6y
         sFbOxxFVN88E/Rs23Ym7WN7UKcbTAbIOdTXLOvKl+khosp/wT5/INIJq8EX0TKfYUnkh
         RxZ128TlvgKiLP+KVRuWPlCRDd55wiFJ9qjjTEvV5PWj9XReDY1TqRKBCWhlz+06+QDR
         mXvA==
X-Forwarded-Encrypted: i=1; AJvYcCWqOaOP6wVQ7kJerb3mI6TyHePwsjkBcZj5nNfew8cfQIWTSH+ODdrwUr1zWNkMSwJ8/d/VkbyWpQ==@kvack.org
X-Gm-Message-State: AOJu0YxABo1JDVcNAz6N6lLKwNiJtZTez55OiBmPjclT4mezaumbHCJW
	TgMaKrcgHw5Fq5DxIGuZRqHgU23Sii9urIb6FRLVQVHPYZ9OMeeECKNrKLkq0d4pbHkFMv80uEL
	gNSoCovbGgNBTGg5PyCsYS5MyHdpZf7l93vm1xLPk
X-Gm-Gg: ATEYQzwGFsSqzxT71Ze+bpM4+EiWNyHRX6oEBXX3wLSdHD9pQr/btMcLSu9P0/GgZkS
	O/eAAjudgUZlazO06UyKIPyKGCJhELGQYs4U6Ipqhc6wjyls9xuU0Nb8w7fWEGCZ1EcQ1IGln7R
	OamHyyg9aZLvK9ue6JwFpRS0tM1fHt0oo/YXK6Nadw87wokgn99FzDJXXpZhhc9N6KZnG+6wqVc
	r23GmcV+ZddaeRC/1XKZ86rmkMgOEsabkyjnkfZTAZc2LSOfMQkGR9NgJtw+3z8KSn6GC8JJlqb
	cLRVt1Qwpt8RhTtlkNwNjuFIbHi1pVrZ03hTPj+6d5PRT/YX850K51FeU8KJ0/Zvp+XAfA+Un2x
	wE/FtHCpkzdWRlcvR+MsSadvfPu/kkeTzv9Dq7ZxjzXlQe9FFG74qdkg=
X-Received: by 2002:ac8:5a10:0:b0:509:cd7:aa18 with SMTP id
 d75a77b69052e-5096946ba5cmr24153891cf.10.1773627813807; Sun, 15 Mar 2026
 19:23:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260316015354.114465-1-senozhatsky@chromium.org>
In-Reply-To: <20260316015354.114465-1-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 16 Mar 2026 11:22:57 +0900
X-Gm-Features: AaiRm515kesiSneWsCz573dJ5nQbUd_phGn-T1G1RXtcvgFvDRcUXQGGWqhv_8E
Message-ID: <CADyq12xB7zpZq9xTe1sJa2O+dv1e3pbdJjWrTcpagRbGC1MfWQ@mail.gmail.com>
Subject: Re: [PATCH] zram: propagate read_from_bdev_async() errors
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 24C3640007
X-Stat-Signature: 3bn1hcp8m5r7odqcza1s6mah5wf5swpw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773627814-139181
X-HE-Meta: U2FsdGVkX1//sgQ7vRSWHQeYPoBmD0pQZU+hU9B7rm+I5kanehehVjkgLJWklcwXtOyZd5u04+sJKooj8m9tpuAIWlCy6UOJjql4xkTApxWJSRU6y4O9kDGnX+s2jLA3WfJ8LF+3oxNbZBx1PK8oBjkqatdRiNZCjnjm5y34CPED5C5tGFeLVzLayH0mW2WdAxrwK7u4DhU6o7ImKxro3rc5be5Ba1pNkWtCIQmEidIXVR7oNhC/bmzbGMaoNtZY8/SWIY9UwyRRhoc7QyP69tHVgS+BrNQerBttHlOqEpqXXSCY8hfqeUa0LtlK2ISXlQR2ZlUsz4OP45SvxzZtsPa76xZksOlDZl/VVQXwjauvRaHJR79obxODFT4LEciArlPG7YZ1G/AysemcZaD0WwLhuGEbsAGCYui4RDhtdBtof9M+nmKwusff1N03cRJ2HBdg/tUhDjuasX7jN6a4O3xQS6SwnzikZL8Z7OQBNu4W9pcW+IcWEivnx0criLUkuR6BvjnTTnagOPaJw34wykQAUXfICwJmuMoS+uoTA8BW/lP94gMmM4dCzt7iDBytTvUSWbt3VNwPE4/va75MBa3kXqJiqKQOD3voM4cEO7z6rq7zKTOZpUh5WdHMA2DXUbrFgZrdvirEPqOis11m/JoRdyNGPKxBlGjigqtP+I2dnKWBVPHunas2ale/SJXWD9oAB21z4P5thfyo+3wE2I0Ug18cyGJ4KS/s8jMS31iZGQJ6xuSkY+dDkDFB4/gVuKZk6qly4fW7QeERj2o5praKNOfPmOEeOqcmb6oUMEA2u61qqjmuWByNWJrU5scRasi10jUsDSzfWlGQVY5cWyKQxXJM3+6nsdyhlFp40pScurHCxfSj6Ehbd/zGX1FpUv4R0Oq7uwoIspwfj4XC35TPcLf630a3r0E5abHnfW/5RHK7WUIZg4A4c7jGZLMf8Vu8E12ae4DlVPIU7yq
 IrvMWzkt
 KyPB60pCupVEavE2PmuND+xdSww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 10:54=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> When read_from_bdev_async() fails to chain bio, for instance
> fails to allocate request or bio, we need to propagate the
> error condition so that upper layer is aware of it.  zram
> already does that by setting BLK_STS_IOERR ->bi_status,
> but only for sync reads.  Change async read path to return
> its error status so that async errors are also handled.
>
> Suggested-by: Brian Geffon <bgeffon@google.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index 63f71371a7e9..b47cb1d99144 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1445,21 +1445,21 @@ static void zram_async_read_endio(struct bio *bio=
)
>         queue_work(system_highpri_wq, &req->work);
>  }
>
> -static void read_from_bdev_async(struct zram *zram, struct page *page,
> -                                u32 index, unsigned long blk_idx,
> -                                struct bio *parent)
> +static int read_from_bdev_async(struct zram *zram, struct page *page,
> +                               u32 index, unsigned long blk_idx,
> +                               struct bio *parent)
>  {
>         struct zram_rb_req *req;
>         struct bio *bio;
>
>         req =3D kmalloc_obj(*req, GFP_NOIO);
>         if (!req)
> -               return;
> +               return -ENOMEM;
>
>         bio =3D bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
>         if (!bio) {
>                 kfree(req);
> -               return;
> +               return -ENOMEM;
>         }
>
>         req->zram =3D zram;
> @@ -1475,6 +1475,8 @@ static void read_from_bdev_async(struct zram *zram,=
 struct page *page,
>         __bio_add_page(bio, page, PAGE_SIZE, 0);
>         bio_inc_remaining(parent);
>         submit_bio(bio);
> +
> +       return 0;
>  }
>
>  static void zram_sync_read(struct work_struct *w)
> @@ -1523,8 +1525,7 @@ static int read_from_bdev(struct zram *zram, struct=
 page *page, u32 index,
>                         return -EIO;
>                 return read_from_bdev_sync(zram, page, index, blk_idx);
>         }
> -       read_from_bdev_async(zram, page, index, blk_idx, parent);
> -       return 0;
> +       return read_from_bdev_async(zram, page, index, blk_idx, parent);
>  }
>  #else
>  static inline void reset_bdev(struct zram *zram) {};
> --
> 2.53.0.851.ga537e3e6e9-goog
>

