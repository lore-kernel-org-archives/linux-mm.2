Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B98C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5E96B009B; Thu, 10 Sep 2026 06:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B292A6B009D; Thu, 10 Sep 2026 06:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F0A26B009E; Thu, 10 Sep 2026 06:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80A616B009B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:28:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 161ED12048D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:38 +0000 (UTC)
X-FDA: 85197478716.08.54CF89A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3DE4514000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QMGTjKFy;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789036116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5PNE4Oc8m/boMk7rVlesoKeh38WqES9ULRjRRxGrRY=;
	b=TJj3mzLAshIDG/jJhOkUoDT0UstRESWm5Gu9MxIKVDwtYZJ5KLBUlH4CX0e3rHWAPEEMBy
	BoP9Tlpp4/e7I54cxuTpxt+5S4HDbwlfz9cytpbRT4T9R4+SBI9vUhSm5sma4MUrkjhthf
	gaProkNP+1vvNsW6Kz+25nEoHEVWYMo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QMGTjKFy;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789036116;
	b=xMRj7eaOYvr+/ezngGh5y0G3LBbUaHG5ErWoZ1estvK+S/r9citzin0lFL5249p+ZsqSMg
	3u5cJl/fEdhzgY1Btz0ZaZG/Y+yWnjGpG6HLwrfOh9Reaj2L5KK2GH8Gt+CZFFMZdf+ijD
	yb0r810mNio1+GNcys8Lq6UpvGrVVKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 605E9413F5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448E11F000FF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789036115;
	bh=s5PNE4Oc8m/boMk7rVlesoKeh38WqES9ULRjRRxGrRY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QMGTjKFyu+yzuaXECM0D5cJA3xz2OgTTPUZC5ZcY6J1lTjGBckw11iPbj5SzkOeVV
	 s+R81M3GYCX0s4qNPmnPfXMcqHliDYyD9/nwOnjBvWnJuYGvf7mXqJCJDhZUliBGXN
	 mjSwQpEXbOeeP4BrrdvNe8HJ0vBKIJHv/nkiUh6f5GtZI3cRtWLfDDacAbxzRRieUz
	 p3T6fP6gd2WZu5gD2mVd+q6tew7ahTOXEWJRSqhL4wjZ3axEtMWKX1aNHM2wkPbD/X
	 89yE3XPbAgG6PYiwB/mPijf4QvWz0ZY6wJIv9TFwuLjH98cDkubja4Jex0DpEZQQxx
	 SxZAvNavWY6CA==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b1eso384067866b.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:28:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzVGJTrItcJPcccfTjtBq5XEKV2Jo0xo2xNlZ8bhyKcA7TqrHGV3MiEpSHEzh14gbGp1JFIduR0+A==@kvack.org
X-Gm-Message-State: AFuF++kgc/HsrVs4uSAhTjkLCzHyGg553DDFdq+5DpmR0TDpP70VRXtd
	js+B9QAmcOv55H9HAjsjs6BKVhja3T+iBVKHdBktQfI9sr0SZ0mXSJZ7ibAbk2JlxCf6rGoo9Rs
	RnwF46494QR7Ao2WvKFtPCyZkwSeQeIc=
X-Received: by 2002:a17:907:c50e:b0:c29:450f:bdbe with SMTP id
 a640c23a62f3a-c29450fc2d9mr470331066b.16.1789036114182; Thu, 10 Sep 2026
 03:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260910095449.715183-1-wangkefeng.wang@huawei.com> <20260910095449.715183-4-wangkefeng.wang@huawei.com>
In-Reply-To: <20260910095449.715183-4-wangkefeng.wang@huawei.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 03:28:22 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO4JJdyjuenzCkNyN=YibvcAVBnDN9BVts6TecWtpN7XA@mail.gmail.com>
X-Gm-Features: AcwNN1VqXDtkRkPL5YdAGkCGXvy3z3BcrYUoxPk6bXZNX-U2YT3RfyUsL-oRdS8
Message-ID: <CAO9r8zO4JJdyjuenzCkNyN=YibvcAVBnDN9BVts6TecWtpN7XA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm: zswap: avoid unnecessary xarray lookup in zswap_store()
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3DE4514000D
X-Stat-Signature: qqgf8ynn5nx54azckjjekdg7n4899xjw
X-Rspam-User: 
X-HE-Tag: 1789036116-413947
X-HE-Meta: U2FsdGVkX1/mJpM23Z9aGlwI6d1JfT93nJ4b8zZysufwQdLqxsfYQx5bRmK+eSA6+meMyKAYFtN2iBczrc3EkwWlv7RQm4cWxmVlAwgjdiIoixP6HC+m/CKYMGClOqzWZI6hYXNtBCbbq5aoo+CWw2NUNUWlA1arQ6QQJxK5JWSnYeB4CALFLgsaG6Od/fb0GZKvn8xxtU/CM2iaUzDbXqK5McV/Svvi1jWEkb+mKJE2iOwyqeO4bY6jf19ujWZ21kMmWtWlChHKvcB9sByiJndYhDXnOmLQZrwo7oXLGed5JlT1Boksw2fZmCmBLgXYDZ6ZRcKmgI+EFKk09YeiNe//J5DtdfuMNWedF8bgzls5docTfO061hqDQkDtt9BMUk9Q09XEhbKi++u25fUtqDOL+OgX81Ry17qhGbwJ8SmbgCW49yojBZGaIVhWqtD7HA1/bo1/l955wC8UhZVLSy3aP2JvNQxz2lw6b8dh0r7VBNHSKFBDFeLyK5omIszzLvEzsAv9g0llljoG+mKPVNZjpI8Yyi6RCZ2kcskcDabmv3y0x/+tBmEwGt4jA9QWOaMAFKS+f32QpqrmrirrBhbFNPAsOvo6WLLmaVflQYj2Mbse/RpyxehXBNIhP4C62V+Xum5QAHn9Ln5YbJvI9mbiviLVURGWOqs2DNZ8SRMnY+NcA9xQm6z3Ctu3giE/rG8i/330MCuOuy12YlYJBbG3TOTaJ6IbsXYbYA7IMAVt0Qcis95sc1cb9BULfSJx+GW1cCgGofJGEZX6GWUoi3pmvmZPaVPXCxo+yKVkO+QW77raffmCkQxSTX/WKMdGsFAlWHxRJBA+ghTD/DCf2FYOPYUVnkxMRJtPJ+LYeQBKg9hBcbXkQDzFQIaMoXUPsY+qJrJ6S1UI/Sx6JDAu8xkNO02EY37fYi5WIKtGruPfmahw29m2Pq6RNBZEkAWFS4wDgFmsair+6jxf3C7
 BtXa2MTl
 eb7SQc9a2/0eyQ2AWXplsNsIECJAkEnWzoNtGRbPGaYGGQTLpfGKAjsMqrXFvJCmDnkHfDJfQ4xTSSQPNdPig7iJQ4Z8mWsP7Y2iOH4oTSRtf+QMZ/8OMV+8j9Ji73Mr+wapAvMN8CxIZ6NeTUxZLLlJEKk7S4i1ooBIcpTb825ohcMKWTPNKwcsDzWHR0WTQYl6fMNuMTPDHp4C+Q4JGCbMsJM0NgVBe8JcoTp8xT9lSl2v0xWaFG7Q4QFW8UhglJ4GfbPHWnfkpwByzn/RAvwNWKOpWud1dOiPJGG7KXSRqZjMe/Xt4OTrkHo5/ciVfECFZc5uggKVFQyWoHxfM5SVE95ofBWfS7DZtuKTLusOdlwHDAl/lr/NYIQI5fXJf5ukclPsqd2E2WIEG0XMgpluQB82WHm+acsHJe0B+vuEcIPbbrJN50kiAG19m3oNbCPFknZbekpPfuxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 2:55=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> zswap_store() falls through to check_old and walks the swap xarray
> even when zswap is disabled. Add a zswap_never_enabled() early return
> matching zswap_load() to avoid unnecessary xarray lookup.
>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 2c06e4e0e130..6197aa71e33c 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1492,6 +1492,9 @@ bool zswap_store(struct folio *folio)
>         VM_WARN_ON_ONCE(!folio_test_locked(folio));
>         VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>
> +       if (zswap_never_enabled())
> +               return false;
> +
>         if (!zswap_enabled)
>                 goto check_old;
>
> --
> 2.55.0
>
>

