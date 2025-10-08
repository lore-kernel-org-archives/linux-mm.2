Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D4DCCD183
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00AF8E0042; Wed,  8 Oct 2025 11:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD81E8E0002; Wed,  8 Oct 2025 11:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE2C8E0042; Wed,  8 Oct 2025 11:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBA4E8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:47:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 688BE1605EE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:47:05 +0000 (UTC)
X-FDA: 83975375610.18.72FCAC5
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F6F518000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:47:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FQPDfzeT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759938423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxsFL0/b1dBODDSo0KlYIamsU6YtxzH589hXt35lu3s=;
	b=3lIiCoJZDnusyB81QIcs+nddjsomcRS28x5gmnVz4jC9GMLJ1xtPv4nWCxeyCRZ2538xdq
	p1lpGsBSRY3ETR4jnmGTMAf93lp6Zp/spg8cWxJaFGvcUk8yhvx9wHWdz358s/gqzeS+Lh
	HLrUkRGwvb0vedOXwxTqJ/YP+pbZzpg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FQPDfzeT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759938423; a=rsa-sha256;
	cv=none;
	b=v702sJ1EznMBYBtXGhc2pZFO3ctdhkGGVWbMp/zcTTC9HK+tnpSF3EOABmgD2UDt+TcdlC
	6TFq5r5VNelXlYnVHZOcSbABrPLCaXX+4n+ExNX5FnvfxlN4bbBcni+Hw377/9ad8BkCJA
	twDUsNZDhN4aAGta9wGKQkuxIIEgSAo=
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-938bf212b72so265673439f.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 08:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759938422; x=1760543222; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxsFL0/b1dBODDSo0KlYIamsU6YtxzH589hXt35lu3s=;
        b=FQPDfzeT6DN4rEfx0v+R48ZHzF/elqZx67vhyqOONsPy/T7MOQVPVv8ontG/S+KAHt
         SMpvgE7iR1SC5J71Ch99CT3iSLAU3tOefBBZPkGdzq+Adh2R7Xx3pi9hZQrXFXgauVuX
         8uCv1MOdfFXcpHu84eunLvhicEWmnIW/ubslQm+zzR9y0H7SgfgeGRGMs/F0uLiEd8kh
         LTqAe0gXs7H6bQVEQXs3GT6B2FK3PGEG9rWZOHvP75ngVDlV+Vd4+vyrLNvrhcujtSdk
         Sm/2QJ/Adcu7zuXEn0pDPlcQFmkWxRgsjjR/S1k+foi8gjNIlYd0Xvp42YAwaT6GklBL
         c7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938422; x=1760543222;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lxsFL0/b1dBODDSo0KlYIamsU6YtxzH589hXt35lu3s=;
        b=FSf/erCga1KgbahUUjw7i6JcRRl34dEJKHLnyQjblYenqkLFT+KjCbr4Lb6EhYwbbi
         ls9xAK/3wMuCjo/AKfgdlE1X6i7KbTWArYuFrlwP28nzr3Eek18OPBU2npunEUpwyYLA
         9r2XU/RyC9TNrrfrwcvq/LUbyYmB6neCW6d9E6eK4UJJO04NZVK2CePCFnQsGg1LG+jw
         X/Krk9g6fNyb5u1RmvJ2rO19NOv4drFJJQi3d5K4p6o9SDoShi5c+l2qGhMyiVEY7eD+
         oTUN0358m+jnkMhxZ3bmLsCLTKdtiO8HIIHVwrOBWzbK07O0gtmtPO5TWPC/PN/1r7D8
         uGaA==
X-Forwarded-Encrypted: i=1; AJvYcCXg79shDGcIZ4fJgqZL45kYBM2oaDiBZml/24mh10gpS9tv9kDhFK2mWTuiTws4LH/FXFHBWZ9WXQ==@kvack.org
X-Gm-Message-State: AOJu0YyMml3kd1B9V1CVSJVXVnhXR112PxGbOC1BIURF+of6COnymhw9
	BfdQlYILzceVnQrHhDkE66EBa+7SIHeJ3WT/EsnjdmfK9ghDAti4U5K3TiGeDfPqX0V2v5pMAW9
	6iLcsc0ba3JzN5j3fuRdgWShLEaYZl1c=
X-Gm-Gg: ASbGncszv2k9K3aWnKiL+hRwk9U8HDBAO1vjqMwlaOF6h/S+bkWNjeSW136V+yFiEAl
	AN5me5iJ///RBQUKq9S0ZEYoedJdjvCCxuc3gq4Xh4RlA/EaBO34nbQjwSSfEMVAe2KkhqLXFl5
	ymiNt6qWFD32KiI8mwX1Mev4AhAvOEBdkVLNhcVlMXEYr2EA/zYRWPejZusoN+3hHeotPqlE/my
	lAS8/Sfr/1nr+n35y/JtNU3kjq3
X-Google-Smtp-Source: AGHT+IHb1Dg0MfF3pFxdY7ZFsglgfc5OrAL2Gv7g3bE+aIiwaH7AlIG2STXmJXcSiISZD0UeIXLQCvBdo4xXE1r+ltA=
X-Received: by 2002:a05:6e02:178d:b0:42d:7d2e:2bff with SMTP id
 e9e14a558f8ab-42f873fd943mr27365275ab.22.1759938422227; Wed, 08 Oct 2025
 08:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251003203851.43128-1-sj@kernel.org> <20251003203851.43128-4-sj@kernel.org>
In-Reply-To: <20251003203851.43128-4-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 8 Oct 2025 08:46:50 -0700
X-Gm-Features: AS18NWBrFZyoKbxvDzZP_ZSGE-EjtBx-9bGfWdZ19UYGb0iBECeC-6jkfKXTjpE
Message-ID: <CAKEwX=N=uvQkF8nL8XVSceE3Y0icF2FuzPuDAUtggfJRJhayLA@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm/zswap: s/red-black tree/xarray/
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F6F518000A
X-Rspamd-Server: rspam03
X-Stat-Signature: eba7trh3fdcoh8przuoh6pd3ezan86u4
X-HE-Tag: 1759938423-429129
X-HE-Meta: U2FsdGVkX19hm1B7EqKhjuUZUtyvUDtAPkvEXo9/TR/fePwDYJp91k8O3WkE4vwJgb2ZSaS3HxqIO2SdtHkJfFu4vNJPvEOG7RPROap4zavLxMx3p8VUp0X2I/KBobTYNbg4Fl/+7g+kEMplmWNVyiSwOovns+OGwTdoQrLVsMRphl62jis74zTrzNt5TtuHHLMpaYvfnOULO9twprVQOnFPzvLnDv/ouDOwiEH3fezAzMUvB4Nuh0F1nnhnGV3XJxjm2DSHZyF4ggZS8o0nBzuYQe+jUqK35HJqx+hVNAMrvrowlxZDKpDnse51A7f1+FpLzqLLp7rztQB44htD/z+80RsIYTvIqv4MN9eDuP78CZ8qHUD83xdE+Drz5xlD1si1ki1t3RM2GKJPP7qyfO+d8jRK4q3m7uR+XxQZEbbVU0sHSqKCTQfno6PrMIPjkWYs1vNAWuUi8lh4IKEYV4duBvpMPi4HiQsx4bCwrliaaK3D7i+Dhg5kZMSuQ89zCkFM2kufI4MbbeCn7bFEz++ljm2O4WHUCqpef+awPYarqYW5D2Mz+002Jf4Q7YWR6646pgESM/VTOzALVgosuXSdVQhbMZ49pSZPxYhxqVw5Mppjta/1ZPYDeXQuO1L3C/haDpR4oTMBySrOOARIER+oAQd2hEQi7Yam+99MuYDEmbijYHdr16KauSx4VwzvNm6ivCthA6f6PweERShZ5fL8hr+UZHQT+MmbQa31fjpmH2FHUWH7J4JUiKoNwzoawVs7LRHq4375RXFjPx3qUjCwh3rvBV02LgPI/Cf7LGoiuVRBT5dWHkXvAjhd3NGi4iAyYzgxNp6S7s0PObpZglrDK5rJZSpETOviGSWgrWvREaIEAuSTG4FQbSkQWbACVzOdQzD5OzQqI8cx8X2xTN+xhEh21j7eC8G7iM3N2/noUJb7CSBMmNSHTYTYqOQ3Gw9E3ICZ95stievb47H
 qU2j4sRj
 QUPqm1ENeOLOWdvh3ppweqEvFRP5LQG8sJ8+1Bkn/P27+Cl73Tom9uZlHmHPVURPbnoAlnSJ2/IPV/CYOA4/xkFwzuF8SMrvMkbtfB9RkSZqcs9p6s9bqkC/6UfigeeV5dZeGqqHUyRejWz7VYhEmP9+OnYAceFs4uusbgkZv1V/7wtUaF6zVsnBwPbHbfmCPi1pf9XpjdkNyEizGnyk4NyLvidLWKuN6PVwlu3IapLrm5IQF7BriT9jGuUQWBk4b5i4ozRCuD2ZfAOvwcw/1SIgbqZv7C2I13s2QcU0RI+R5CZDx1W3xcla94vjZeoscyVsnEMupHGc1qqsTJnmSvF1gVYQvjshdk3Z5IM0OyDSN/ciwf6QTh+BearCuzik9HaW06MCSnOzkPvM2jsDPicVrI6FS1kq3LDkDpsqsIQoj6yY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 1:38=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> Changes made by commit 796c2c23e14e ("zswap: replace RB tree with
> xarray") is not reflected on a comment.  Update the comment.
>
> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

