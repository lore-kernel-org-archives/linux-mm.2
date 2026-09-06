Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11629C79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 13:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6466B0088; Sun,  6 Sep 2026 09:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F276B008A; Sun,  6 Sep 2026 09:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170C66B008C; Sun,  6 Sep 2026 09:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7B396B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:43:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A8CD40520
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:43:29 +0000 (UTC)
X-FDA: 85183454538.29.81FF9C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 78B37120009
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:43:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQxHKE3i;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788702207;
	b=k8JalvKQPRj7q6J9xPOBNFvYTJQgce7BnVsILidHxSFCk3eJHU58aPJN+0O93M3/+ZgRtO
	GzEJjoI2sBgDXeoDPAERvmxdexWOZNmED5J7WNtHbckC0OhtC0zKmPrvFSPlYyB3fc2EXd
	pZKYjQrD8p5ZBrlqVy4RzF8hppztD1Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788702207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJrULltJVytx/1A1hejUzTPGkBOyVLht9YAT4kHHTx8=;
	b=Ha4ZTLaP2SXZ1eeCfZKX9Cj7kfToSMB3zQjejcHcR3Rm3kQuTrUWixdvmKP+oM8LiJB9WU
	PLIhMImcjgMH84iTuzKTEWCIgdSd6TNkQkmffIgi9Aywsbmn0k2iUd+sw7k9SWPZcgLAWp
	rUBmdAaKgeKPj7/BJVbM57WKoDgXhhg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TQxHKE3i;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 283BF600AA
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1781F00A3A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788702205;
	bh=MJrULltJVytx/1A1hejUzTPGkBOyVLht9YAT4kHHTx8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TQxHKE3i9E/GWqhHOPvxJQw220UgQ+1dY6wzMTZSt9SLqyAG3mm/t2zY2yS1WvwGd
	 4f9mPNFRwaLRkGxXK8QTvel35dVyhFegVy3wjuDlhejJUx2eoKBu3id4dRoxRoyvDd
	 893flws+xZh9VhudJmqsPRjVXWuv2c3kUzitQ6+WeRmqMriAFgTeKNFM+R4vUwXl1o
	 tLYSK0pEZJmv2UTleiJC56FeWWdhjvdFX7U9S3XSiKTJTxi+XE/271SsjmZo8hf2oZ
	 MNmEh29cdy0NlEkxONYSmNSosN2xCijajQK+ZYEAqwV0vn3MwlU+1wPHFBYoMxwz3e
	 +mbDWyMRjePLA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2533d83e3bso422672366b.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 06:43:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzMPevcK6JKISX4onftsns4lXjtqetXZi9NlreBtv7NwbORalM9NFQdRE3sIXZ3pq6INY+2/zPYmg==@kvack.org
X-Gm-Message-State: AFuF++klpGsAW8UWhN8Gz+99eqBa8NhSu08WIeGnnr1JT64RJrNxbsjJ
	PwcJvCXb6qayRGuQY/zBnlFYXFsgOZp9a98mue/Slvfw0ChjzzJllBn4wZvFLC9h3IMq+0vc11u
	obTvVju1qF+m9hDRSNOwKZCeFOLYiH9c=
X-Received: by 2002:a17:907:3f93:b0:c25:4f7c:8ec5 with SMTP id
 a640c23a62f3a-c260cd4dab0mr1142344866b.23.1788702204625; Sun, 06 Sep 2026
 06:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zPC4v_S80Gn5M7iiAujebP9QHdRur9fL1ECh8ZDxOov7Q@mail.gmail.com>
 <20260906133601.3563324-1-xialonglong2025@163.com>
In-Reply-To: <20260906133601.3563324-1-xialonglong2025@163.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Sun, 6 Sep 2026 06:43:13 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNPckJzpC2ecOew1B=MNbFSMsUpmHgVu=_D_+osFFVFSQ@mail.gmail.com>
X-Gm-Features: AcwNN1XXId-nItsS1kCZPEhUVKzt7OsFcHZczRETRWL-U_2270jVLl9hSByTuos
Message-ID: <CAO9r8zNPckJzpC2ecOew1B=MNbFSMsUpmHgVu=_D_+osFFVFSQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
To: Longlong Xia <xialonglong2025@163.com>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nphamcs@gmail.com, 
	stable@vger.kernel.org, xialonglong@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 78B37120009
X-Stat-Signature: cntdee3tbpnodmdeqow9a4w3qcpe3c5m
X-HE-Tag: 1788702207-362506
X-HE-Meta: U2FsdGVkX18bce/mDXMXh5yFWXAY16IW81zoD/X0jxSOV8miozyW0NJT/CjuVXcENlD/ZX2jyrWCq88OaXZNNRfa2OS4OLQwX9MJs9nV0isWWz2IZC7KRa23zKVmtTIzBVwXnaN19R6WkGbTxIF/80EV262Ao6nldXxAJv00QemuBhAB/yv7vCYtfbbfBc5Emh/HW8NFVBk7/keMhpgn/Bnat5QhGT/7C6Eqo0KmW+NebVmn2NoVXNTxjrz3Wpie51Tthc7mDVw3lntWSyJ+XBV8uiPnVYFWWyXysAXje7nGTSdD+QzpAdoeOenU7iYZyRu20ac+xWEMP9OLXA4jyd8dhtcWvpFgEV1HDAhKfkC9wiTRzyFGXxJFktFQF5L6fbdsXWauLlOqK5oYQuXCxY78Ok31qylxUdV6sd1bjePF3XNzUIskr2otnMYGJcerCgyvipTaLNJNw5blx9sBvqTBYepOy6PKzRHEQB7rKTTaNn20CsqTWzNvWXCvfay0kDwXhZvrdR2bOolmHGldWic0OXSPcJ4RNtH1gFOhaL9I/3BdXAY55UAEFp3Cs+e4Oj6kRt1o0qnMV3KHF16d2vKf/ITbPrNyWCWY+Ib3gKIxQiL4eHbK+EyN/R3hodOeoRkihkg0I3FQItLhqJocKNaANesA1x32TPLOXvQfpOG8fTDtIXKxNYUQdUQwHv9Emu0ONnwekw1J24Q6JMv4DUtatHO1Ucl86OtRFJBwHseDy5/khHo+o2m5m3yU6TdITsakz75KKGgn+1sSVvsU6+w5SGi1M1ToMlZ9XVDXnMB0M0G9d8NAhXzYYresc65KmtIxJF+EStkb5vP2vdm0t99mwsur6Ok8H/5ZNObmakdxJSTz5U57pG36uy7D0G+H6NpkI9QDPLWvhEmS5MrUwaYtcP3iwhk67aULHQDAzYo50AfXIe+ltUZQs4hvW1IhxrjgLcyOndBn0eiDJD2
 LZhRqwI1
 k6Iq8Dzu+T24fT4whd0rb0DrykehenU80KL/obwPUyAo628Vj8U2o6dV1TmrGiS/slysytcpz8jNVlBwBz2RLahXpQzDqxT+SEf0nMInevEC1lkpyZ6jQueF7qyDbREv4EvXcwvIOQk6nRJoxbhO9xxNdYFrhqzCq+bZ1MjzFltbhuj7eBl38H7A0B2AfWOp3KOSZCRVBinsUDCLDRJwm6EoIPUODtO15CJwjFNDH9LnypjHFIeSwIeYoM+Tk/elVBZArozKw8ql9OEtrdHr1w3+pkWlcxjkSrrG7o30CZTrH1PZkrnDJNnbQpFh4CyGFbEQ9rc48aP07qDJ/ofn+wpr3ReFIE+DoGTjgHbQxpjJ2Ca4ZOrdO1bFJKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 6, 2026 at 6:37=E2=80=AFAM Longlong Xia <xialonglong2025@163.co=
m> wrote:
>
> From: Longlong Xia <xialonglong@kylinos.cn>
>
> If zswap is enabled by default at boot and pool creation fails, then a
> pool is later created by updating the compressor, data written to
> zswap is corrupted on swapin.
>
> Enable the static key in zswap_pool_create(), covering boot-time and
> runtime pool creation with a single site.
>
> Verified with fault injection on a stock kernel (compressor builtin,
> CONFIG_ZSWAP_DEFAULT_ON=3Dn):
>
>   1. Boot with zswap.enabled=3D1; pool creation fails, init completes
>      pool-less (static key off).
>   2. Echo an available compressor name to zswap.compressor.
>   3. Enable zswap.
>   4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
>      fault it back in and verify.
>
> Step 4 reads back 131072/131072 zeroed pages (zswpin=3D0, zswpout=3D13107=
2)
> without this patch; all pages intact (zswpin=3D131072) with it.
>
> Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Cc: stable@vger.kernel.org
> Assisted-by: Zcode:GLM-5.3
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
> Changes in v2:
> - Enable the static key in zswap_pool_create() instead of adding a
>   second site next to the compressor parameter update, as suggested
>   by Yosry; boot-time and runtime pool creation are now covered by a
>   single site, and the zswap_setup() site is gone.
> - Use the high-level description from Yosry's reply to Andrew for the
>   corruption scenario, and rename the subject accordingly.
>
> Link: https://lore.kernel.org/r/20260905125101.2970456-1-xialonglong2025@=
163.com
>
>  mm/zswap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e3..6dfb6ae709e97 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -324,6 +324,9 @@ static struct zswap_pool *zswap_pool_create(char *com=
pressor)
>
>         zswap_pool_debug("created", pool);
>
> +       /* Enable the key here so every pool creation path is covered. */
> +       static_branch_enable(&zswap_ever_enabled);

I would drop the comment, otherwise LGTM:

Acked-by: Yosry Ahmed <yosry@kernel.org>

> +
>         return pool;
>
>  ref_fail:
> @@ -1805,7 +1808,6 @@ static int zswap_setup(void)
>                 pr_info("loaded using pool %s\n", pool->tfm_name);
>                 list_add(&pool->list, &zswap_pools);
>                 zswap_has_pool =3D true;
> -               static_branch_enable(&zswap_ever_enabled);
>         } else {
>                 pr_err("pool creation failed\n");
>                 zswap_enabled =3D false;
> --
> 2.43.0
>

