Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D031125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47EB6B00A5; Wed, 11 Mar 2026 16:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF52C6B00A6; Wed, 11 Mar 2026 16:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACDC36B00A7; Wed, 11 Mar 2026 16:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8E26B00A5
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:00:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5202D1B7D88
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:00:55 +0000 (UTC)
X-FDA: 84534850470.23.9D70479
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45C35180020
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:00:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VNLFyWxM;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773259253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6G7wFj/Ca7m4JQsji2ex8OuQv4hFi18bxWf8Xf8bqi4=;
	b=weXsVf3p4MWQyROnZtZF3eHK2QObGcw9kZnJ41stlzNFvug9bT+tiu3ALIbAXWtdAkt6TT
	wtAfbXUdVsj8hBznzdJhw+3E1hcdCVi3iUFbcpwUSjTcBp5TxBto07aoteaGaBNvHle11P
	y3VGo/cWE58CvJ4JeN3xqJHxVMYa1lI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VNLFyWxM;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773259253; a=rsa-sha256;
	cv=pass;
	b=nLztX8ioVcXKvmACHWSKm2akXzA2BmkfGZIFr+OuHx1QznoLGjbBmEuvpaynTb5hqttSac
	roiCVQNZy12o7eUYlHQiy/f3CekBDsMA5vvRm0p4Eak6K8lXdeDWmAd8aDeCVPdQpXiW4o
	blPtwPAeOLIFaThwequ7Se2J8s5hNl0=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso1994265e9.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:00:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773259251; cv=none;
        d=google.com; s=arc-20240605;
        b=RWCPqXGXYO3SKMyD1H/ANFZKHBPAuJU6INFPUuuBELaMnyHrql6RjkO4KH/TXOf5J6
         VLkgWxEY66fLyV+Q2PXA7F0WUPJuDvIOgUjvuNUjLbXz/jj1P6mxk/VX/+eU7aUAHBce
         pF/pGRq97cZvF3sH6hkWZMXjFBURHKCN17UPe+z+2C5yUgJfWXs4lDi9VY/U4DEWaHVR
         WS7t+c7KqPui1Y+aQ3V4ZO5abRAeaeuoUh/x7Lc2mftSuJDx3fz2ODPdq8V5IHp1CXk0
         M2XPDh4rxLspLZ+uEhNEGXR+zGxSc/QQF0wPUYF/cQ8KLWSW7J7vYD0zvl5oCb8PgAcN
         vCPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6G7wFj/Ca7m4JQsji2ex8OuQv4hFi18bxWf8Xf8bqi4=;
        fh=m2i1/v8TFTAphPwBTFRi67tpgL4uwZObipbHlFK157c=;
        b=LbUaQoKLzUV2MMzSSwqe3EvCxb+a2qaelym44m0WsJmeexYYDzt03k+dQCGU4+X9Fd
         /3ZbWXLk7qKY4HUwtZKwpaLVHS6jnEL+8ZmpsarH1UrimmX+SnlVprp91MEi1CQ3QBFN
         /4f4wvKxxxfUP8tcI+lPEIlVXFV0PYbtF1FZZVXSfrjncaLJg5BSzl+4efnPhKKmqwfN
         GUrssK4HXL6b+kQfhD9CPhhjEmmZwc5EyQTasS43wQwt9+uB3FWZtgC5p4e73M6S4uBQ
         fCSV2/t6g8ys/hZ3WxQkmiMDExGVLuTOB9wDZhv6C+7+Os8tax9hhSSli8vaSdaUN34p
         t6BQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773259251; x=1773864051; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6G7wFj/Ca7m4JQsji2ex8OuQv4hFi18bxWf8Xf8bqi4=;
        b=VNLFyWxMfk88F7/Fue1UZpUefltCyS7C3SpKXqvZ0puqOn5oppseU1X3djj7aEcJPN
         3vVxgeIdK+708hFW+VTwufPvmU7hHHnyrKgvt4EzSrfrq3fJ/TcCd3H6p6Bbijii/lpd
         a05KF6pEv+Q8+P0tT40Am56U4tVm2cjkqj3bp7FU1SyV5DOK8+3ywsxMhO84EellhNNK
         /AXFk25Wi2SWFihUuzsTNHnmTxfTqQQKnZskhGZrZ2WYcz8D0xUEFijIBaJMrS2sX/Lp
         uXIbAHrho8RiwjINQnxzYFB3LmhYCEqZU/R9v+tUgqNGvGH1MOHL9xdPMQrJkRtJWDXH
         R03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773259251; x=1773864051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6G7wFj/Ca7m4JQsji2ex8OuQv4hFi18bxWf8Xf8bqi4=;
        b=fc/JHSpoMFuAMfZvksqIEH0wh23bYruZfPQmhp5IRleZknTn+gfGNVtpPBq2tHvzD+
         rHToiTOheqkL7hV5G2edkTlbXNarI8PaNP/NwYLGx7DFGpXFBZaKudf3v1S7UlWCDmvg
         CskFS4uRuuHYy16rFe+0aaf0OlwqzAdpBZRa2avY2MWwpUmmiJJCkQeXgKbccX14XRvt
         oz1x/nua5TNj//I5kUTW8bLZY0g1z8nKSUaFyirwShoepg+PXGiglIyKtOedSTlhL50+
         nWdPZuOIAi15kqDz+T1XoWF8hHnmo+R7oKnu+6/Vxlw5XwAQwTEoXCHvZDccCTCL7pc+
         mxUg==
X-Forwarded-Encrypted: i=1; AJvYcCXNQ/E6UdvsqV3L7K4UhG+RDoCr8axjDyNykpueZg/KNDZQGPqiQ3f2sEHmKqpyYir1BW/tVmIEIw==@kvack.org
X-Gm-Message-State: AOJu0YxtJdubX4yXmM6mtHfWpyrqsBCbibYauXZLjjEoQh+c04Ik6S7e
	6kgPNNKfcEkyNAGwPCmkt9IlwO7oQ0Jqq20bIbTyOXW6aIJMeXFYzQoDermYvHNw5C1WXWTKlK/
	I3MEh6bjYBPlonBNC709gAlO3fJxXnEM=
X-Gm-Gg: ATEYQzzv8fIpcvnfqgDAKESpm0mlyJaukrwUNCVEmG8F/KiaqPNmEtw3WeESv3QxeKo
	6h0GxK4NPiBoIFpHXTjvlK1pQlTfoHo0DE/3RWJw17B/uvQ6epnXBEGBvlHskzLpWcGNyCehsOg
	w682VNBg0OOw1JDFCjUtMX2iqIFaBPaDKIgfA4pAQTXHkep8Zr9p09jw36DSixIMabMxpGDr5Ow
	80EOOKT8827I0affhMKl8kOgJ3QOSgpZF78kfoRbykeqHxft6D/ZyDKxvufwMBLyr4x7P9v3Rsp
	pTn5qzOtHLIUf3mE5Rn1TBYEkE+yIEJhGc+eJlo=
X-Received: by 2002:a05:600c:6297:b0:485:3ec6:e634 with SMTP id
 5b1f17b1804b1-4854b0ca67amr64346175e9.15.1773259251246; Wed, 11 Mar 2026
 13:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com> <20260311195153.4013476-2-joshua.hahnjy@gmail.com>
In-Reply-To: <20260311195153.4013476-2-joshua.hahnjy@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 11 Mar 2026 13:00:40 -0700
X-Gm-Features: AaiRm52vUxF__8OzC2Gxf7Ts9cyHYrm3EDe8sIiEgzReT0JhqL7CJGLwVzy-_O4
Message-ID: <CAKEwX=MmnnTcxQxSJB86ZMfQ0cCndx3sBDo_xKJWwBuzVJkOgw@mail.gmail.com>
Subject: Re: [PATCH 01/11] mm/zsmalloc: Rename zs_object_copy to zs_obj_copy
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 45C35180020
X-Rspamd-Server: rspam07
X-Stat-Signature: qeq7q4jn4das17g7fx49fazm3urrgwzk
X-Rspam-User: 
X-HE-Tag: 1773259253-944491
X-HE-Meta: U2FsdGVkX19Ttwy2VusoBkLHK/oTIk+ZPot3IBsYSKpc5K/MoHh11HLalwb7NYg/oFafPLPoa0Kb1lmxT5WWoNo2S4rQxBEWUSFuwI6DIeIS7yOv2aoN+mHQwDHvlcqE+rb7yMnqJW2eBtXg00lhDwyAwo8WFVTP16tDrB3zQugfLU4HuzEMECJ5wk5kFqtYyAk/CvHE/b3NHrzPtc3S/5Xva4jZ3/IMrF2a/V0dVqSQmPsfdNPNYdAiPyoTA33ZMSOt7BfWWYcZwThpLtWJRCCYP+QKJbRp17W7/Sy1pqUueUmRGraW0jKK4/7U6Nw88mABkRpUGzsA+Z8jKN/WasVj9zaBqTCrAPXX5AKcdfVGJylRmBd3sgtHyjjU03kHaxk/lwiVJaA/eOfMprTMRb8oJ03CpbMTdDeAqfOuqJw0tvgI4Sl4CeeqMQ9r+KCChu8wNxbmKVRI2OjzpZb8cxFM/dBjijpf9hGPtU3Z03OKjHPhU2dVdm9HWRjOHZZU2G3BYOvDE27x7Fmy7534zjEkjsEDrrRhn9J81kzl9uwyfnK9eS1Yq7JikvtqHXMHzTzRBQagg7gwrCGPFuhvJlMHRlpRHQrxP+qKoi+Z3jBAfvtFPChCCl/DsfmLKeSidcADqyI877LGyLdrRsWSJsU0PloyEoIaCeFPzXz73FxkjfeixX6prASPUmglIznQ5t2PIr0uhe8yRyszmO3CNxiZBLYxbfJ8pe1KM2LHs+Sl+D1x2wuARWxkRJRolfaBeJmHa6yjJuWsIT9CCkwHzvadl0sfd07OH5ZFY+AywCzJJ3UGU81riQ8om0Mzk8nHFt3/6Qfg+ZDZfTR49UzZ8NVjuErEjemdPHZxBB9g6lHeTdkKvQmZZBEM9ejU4ogdWAaYaEiIvvzoxr+oALnO7FIbhL/w3ElNAdf9YAFMyyzYohz5mAlfGzLmwSsaFsGmDhavbtv+AivYKCNhjG2
 6p4jSXzb
 rNCRs/U0eX19pVXGAr3sfAfpVUi65m5YbeX7dHgfPoiDybNn7hzyBalHLtGNRqCmT24QY6Z5iN/ZrGrs5dz0jy9JmBJcDNo7rkW/bdTtBqW2jXa1YghnDQSuGs3OVSBIxJ/6VtO2jeI0g7BL3eORorLCUrGmaDeHPWbBHEw3u3hnYFr8VUsRhPxGCcpLiWL/yZ814knu23DbovLfTrFd4k+HGccje41oQ1OH7hHGjxU5jihYHImH46qgmgscgmlTw9n5jt9J3ZpR1wcAv7hIrF3k8+BkU4VfFop+CPfdWY2ZxWXE9TxSU90FRfndXEedgdmts+upKgq6EBOl3oAFCiFwne7dF21+NyYHuNFgykXPR3mV6DnNQK6YVk9mM9WoTpBkwXFsD3QXxZCKNCWOrnKdpHZNFbxx/WeoBa/AWuTmPfDa/jy7iZPzzR+n53fPjpVEJyRTBhkF3avX4WmhbMQEZT3F0t5CaWWqT9bJdwyKHwVNv/gxb5AVmCuBL90J6xSoCExEe6OqoCjYuOePxeabnyppWdE7kOzDj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:51=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> All the zsmalloc functions that operate on a zsmalloc object (encoded
> location values) are named "zs_obj_xxx", except for zs_object_copy.
>
> Rename zs_object_copy to zs_obj_copy to conform to the pattern.
> No functional changes intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/zsmalloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 2c1430bf8d57..7a9b8f55d529 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1416,7 +1416,7 @@ void zs_free(struct zs_pool *pool, unsigned long ha=
ndle)
>  }
>  EXPORT_SYMBOL_GPL(zs_free);
>
> -static void zs_object_copy(struct size_class *class, unsigned long dst,
> +static void zs_obj_copy(struct size_class *class, unsigned long dst,
>                                 unsigned long src)
>  {
>         struct zpdesc *s_zpdesc, *d_zpdesc;
> @@ -1537,7 +1537,7 @@ static void migrate_zspage(struct zs_pool *pool, st=
ruct zspage *src_zspage,
>
>                 used_obj =3D handle_to_obj(handle);
>                 free_obj =3D obj_malloc(pool, dst_zspage, handle);
> -               zs_object_copy(class, free_obj, used_obj);
> +               zs_obj_copy(class, free_obj, used_obj);
>                 obj_idx++;

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

