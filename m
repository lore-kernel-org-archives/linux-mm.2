Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BF0606A324
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KvkuJEGq
Received: by kanga.kvack.org (Postfix)
	id 86DF66B05B2; Thu, 26 Nov 2026 21:00:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81E806B05B5; Thu, 26 Nov 2026 21:00:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D376B05B6; Thu, 26 Nov 2026 21:00:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52C976B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:00:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAF2740194
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:00:01 +0000 (UTC)
X-FDA: 85479243402.10.96137E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 16244100002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:59:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvkuJEGq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795744799;
	b=HSvHVAsRnLaGJFuPh3oI6KMZ9g3oFracpW5qA5pr1V3rjejY6UnW0pIymJGqGuuLlZGwEp
	gNnR0KJz/Fcq+/m1I0iS57c3wCBbx/B7I38zfRH10Nq5lGiQEfbCzZ7HD5e45Kw08SKAlF
	F70kUBdTXZ8W6C7c/788mDVL8yIXi9U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795744799;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTSK+tgD2GiI8fcDUJlIMB0E5uF1eYPzqK1H/mr9YyM=;
	b=R+bbe09IAzBVig+KALEfGaAFDiKsIY2EnJ6usDuEAvACF6xPRon4vRI9GL6vgXOuVrsNur
	zvOsrMrgLYvVrYiStjiWIIfkAOarRKtFWy6FYgu0kvWmthiZMCP8dPM40xQTN4zS2YrM5l
	x7Pt1F5YHc3J2YopmMzUl7k9SQYOS2c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvkuJEGq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28600417D2;
	Fri, 27 Nov 2026 01:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86C01F00897;
	Fri, 27 Nov 2026 01:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795744798;
	bh=xTSK+tgD2GiI8fcDUJlIMB0E5uF1eYPzqK1H/mr9YyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KvkuJEGq+tAaDsviupwRFEzVCekhS7FxT5LulSp9sMl5IXCmFEshJhWRpKq/+Yagd
	 BaTSylc4PHNPoboj+YrO8errck+Cb6SHOyKVjvxduFIQeHHp01wQC6kdPQzrqOYBRZ
	 KAPFcOIPJnNRl/YNJY7+w8MKqdkWYrMTE77JO8nZE9GERLAkq0Jrai6HT/L4A7+IxT
	 1IOBKPcXeMZtp2nSH7McrViXMAfZSezwP3Kx0oNK7j9sV5kw4eu5uJStjSgkY7PIJi
	 nDB0FhrRvoB4zncdTZC16bZoE452bjZwuHYTvfI7btEYUxqfsK0jFlC5/X/vw/Hwlf
	 KBAA3Y/lTEKnw==
Message-ID: <sashiko-outbox-236427@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] zram: do not modify cont sysfs store buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Minchan Kim" <minchan@kernel.org>, linux-mm@kvack.org, "Alejandro
 Colomar" <alx@kernel.org>
In-Reply-To: <20261126014518.1318583-1-senozhatsky@chromium.org>
References: <20261126014518.1318583-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 01:59:57 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 16244100002
X-Rspam-User:
X-Stat-Signature: kjpg634uuye3ieqxx5rxyecoh53zkymd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795744798-509295
X-HE-Meta: U2FsdGVkX1+anT8WCiXfzCFNcw0j7jwBGMk/m79piWO9HsQepluPHMO/Yx0I0lqNTdv88IKMCnIbQYYXD0fld/w16jNPmGBZu4x/s+nCfYRQpw9l8v7b5ZNOVKFphEA4iRRovz3zZsqIMOwWSRxdYCZf+D6hIC6M0txIdTMwJwWxQZMy5H7gq3RrzA7G2BAzNrRITbG6k41cpIBWQV7kF3q9eVRowWh296clFVJdjnbP22AoOhW4duwebxTsWVKBwFmfiQtcNdX1RQyJPBeTnC0r+sebA94oY06JQIHPlAG2bTiUcbkOF9hjF9A26M6tso95mBD5CDGaYiYboI64vZfJBrrJV38E5H/EOxbvje/Yg8N8OuTjU4cxq3SKOAEH66bK/BOTsu5JSXM7JU64/FJKKJ6mfq+1Eggu02dJKGLmKYRaXNxbWWxb9NnbwdRAxO/h1NiQJjp7l3T1K2Cb9mv9to2Buu4xkDvopS8J99ZJVRy90dl5jpsm8h14uOHBX9i8MjzomNlEgvpIioc50gGsEKkHRGt0+SS8O9BJsot3LUyX4cTnYyBEgLPaKv6sm0132d+A3865FRawxe4FzkHxCOA+QTYYfEnG4wF0LeKEKEqFORPjSgQN9f43k3QNoP6Arpvjyn0TP6yZM7yzeZCaz6t1hd7g6zFbFCHsOfvneoFRoG9aScYxStZ141ErMxZIQL7aAhndO0k9zmXZTdTUvOIsJk+mhSEpRI6xsP8UxeO9GGXvBUqjLGdbBz/uMPkltV7pIjOBs/kei0pgmk/kKF1Ka7gWPXc+OYs96Z9Ewwqd82LdjA/1YwA4KDF4HeF0zBWq9rlx/YsXb+ZXbTU3OcygRyTiMa9h/ejMBxm6OuRHojhZ9gzptRl07Yzp0LXivWDQ5jpsKdpf2PlfYidrApwciEb/cA1yZEEotyq3xkLmye7v796asPKnVMNrVcbBIq7PUuo1YIqYbc7
 7Jx/KTaG
 8ui/eRvFqn306i6E1+UejNEqxKQA4xkYUk2hZ0UzBP/t7zrJqxIhociRL5dfuB936javzuc1OowuMbUMDcDOddVfNj6IP6bHzIWyjGLoehSk1UfsDl2D3n+sObsuC9nuv+b44q2tba6mNqwFU54uQWNtLmgagagB/+fc4tHt0+rKwYqUwEf1bkjvEH7IpPZVzBHCBg0M9vdToTSAIq9q74LyYyB9AQqkZAI/liD4laytQLICJqD9ktkMrNqzAjhahDOT16UMg5nzdsH4Tzr9ft772fOPAvm5ZsCIRnGRrr+vpJJ+/F/mViMjD1UomjSlwnD8JrLpT5QXZ+wP9Raf5tLsZQAvw8RlvUZz3coPWHksCUN5G68V10WMrnBqPxHBGboKWjlmR39jEnWQh8Y/VZfsPD0Gc0EwJpuNjyiu/THGH063gpYJSJfqFYVb0pZuzWsKZfBQ5diShDg09sT1kYOIRXYYXT2fkVPYFiAjukZPYOTHUSKqhpXC7A8KOO0L2TDv7+y7xEzE2GLLnyg9mwH58DO5nNdCroSoHoS+TfnQrUsTB1/QRzOjn5MAnAga1CIYxsvDgtNNHNnAou60KA8wU71pSGmP/kng4VI8HloopFNsBaKxmBjae1VQS12o8URI6+cJOAjvT1p7fdYBUeSoMwelr64dIPiyDWAPSpflnXDhwl2HZQtLUzac9bYSdGfUnEez+N13Kf3td0Ny3DVn2YjJcLfxKWQb7Ji5rTXz3bjVqMd5gbMoVE/ra6oaOu9rqEPAfg/wdQVJXAo21TEy/4IV6gFX8sxGuBwWMTJhPU0RA/3K5XO+kLb5m6yYq4bhr+E9818c5lpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] zram: separate declaration and initialization of __free(kfree)
  kbuf
--

commit be297424ad592ae67e98644a43d786e259a7383b
Author: Sergey Senozhatsky <senozhatsky@chromium.org>

zram: do not modify cont sysfs store buffers

This commit duplicates the const input buffer with kstrndup() in zram sysfs
store handlers before tokenizing key=3Dvalue arguments in-place with
next_arg().

Link: https://lore.kernel.org/all/awcpkJD6K1xtx_Pe@devuan/

> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index d969f17b55afe..ff9e53f001bc2 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1285,10 +1285,15 @@ static ssize_t writeback_store(struct device *dev,
>  	unsigned long lo =3D 0, hi;
>  	struct zram_pp_ctl *pp_ctl =3D NULL;
>  	struct zram_wb_ctl *wb_ctl =3D NULL;
> +	char *kbuf __free(kfree) =3D NULL;
>  	char *args, *param, *val;
>  	ssize_t ret =3D len;
>  	int err, mode =3D 0;
> =20
> +	kbuf =3D kstrndup(buf, len, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;

[Severity: Low]
This isn't a bug, but include/linux/cleanup.h recommends defining and
initializing __free() variables in a single statement rather than declaring
them "=3D NULL" at the top of the function and assigning them later.  In
writeback_store(), algorithm_params_store(), recomp_algorithm_store() and
recompress_store(), kbuf can be defined directly at the kstrndup() call:

	char *kbuf __free(kfree) =3D kstrndup(buf, len, GFP_KERNEL);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126014518.1318=
583-1-senozhatsky@chromium.org?part=3D1

