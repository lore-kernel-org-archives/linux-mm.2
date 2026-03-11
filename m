Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A4BD1125826
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7236B00A3; Wed, 11 Mar 2026 16:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967896B00A6; Wed, 11 Mar 2026 16:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8944B6B00A7; Wed, 11 Mar 2026 16:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75B446B00A3
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:17:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4157C1C490
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:17:42 +0000 (UTC)
X-FDA: 84534892764.13.CFDE2A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 676A710000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:17:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XTtW+vwL;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773260260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPEcQpZvxVb6BIMGWiUlOg8TieCxcraT1WUPT9pfD/E=;
	b=OQIfFVMzT/XRa5jnG8LMmnEHUu/13cgz5iazYCgsmNIf5eO0hUb3bvLqgYIz1RXHfAamvW
	9bLJ940Zx0SD9+rAHBLgiM7qIfc1udym94VhZbM1mLpUJZqnhBrKi8gE13iP0K6ZLwT7g1
	3TgPMxLn+7diY3xSBvNazxXZSZ1/H5g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773260260; a=rsa-sha256;
	cv=none;
	b=hOepW35mvkIUZSxlJNG4/HP2ET53ogmJQoUz0JcY5T7FCMlHk9oLnTyo7nb9N3mB5J1szN
	NBtbVfZWLomF+8+nlxlFdUueJRSZ6V417MymiVO2m1+6N0TJYtiN9cPqeuFyV+hRmAq+/C
	JIoXkNp7vQoKmLhagqhSx1bCTG788iI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XTtW+vwL;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7BA361420
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9078DC2BCB0
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773260259;
	bh=WXYYVKaATB7EgYT0+fSTJV+LvLY1BPrM7tATQPPKDZE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XTtW+vwLjLXDtKmJRnCKTGKZ0DrF7rzPirrWtH4Um/ZsoulwP1C5w7mxvV3YOsJbS
	 6IHC38Pp+/OdF9KhkDgM/7Us4QYr/Ljdk49T73RDrBeMXciP8VtDsxVpuo30Wv85d7
	 s6DVDxCkwIrvn3Vw4/5gujfrdP7AJuHyxOr52z36DOQk11FA/FIbEyMQFG8AftYjfv
	 S58UBcz22n1PQ/zhsbwCyIIzWeSSTV8aVOWGXlgBos87n5LfFTAQAi3c3O824ikvQO
	 BZV5Aj9v9vTk/EUZIC67Bt7WaqkMhPrgDxCULYSgtv/MU/8mTv+tVES/9xBF/eNDQZ
	 PYVW3gw6cRGwQ==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-661d929219bso257274a12.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:17:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVt57ju4cYJZQDGwr5flybbzDAsXFn34rxAmGkRW4J4sD6syTg6IacB/KWSRcKC16SSpSvXZ2zRbg==@kvack.org
X-Gm-Message-State: AOJu0YxNagIqjXdNNtWyova6glLm3SE1bEMaMUXYtZD/DkPTiBrV14Vh
	qEw2uAaUFviSs+m9xmJRgqJwR6pMhvWIUc1FZz4q3koho+azGBb13G7ICUjAOci5g+OhcgykxVe
	fQO2uBl4EdR3NvoP1PEAMMp6q97QgB7M=
X-Received: by 2002:a17:907:7faa:b0:b8f:848b:4456 with SMTP id
 a640c23a62f3a-b972e1a15eemr223917566b.13.1773260258414; Wed, 11 Mar 2026
 13:17:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com> <20260311195153.4013476-6-joshua.hahnjy@gmail.com>
In-Reply-To: <20260311195153.4013476-6-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 11 Mar 2026 13:17:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMRwFTbv4jWWNf2sEc+SkUawxPtnvOc7LKsJr5R3vkZjQ@mail.gmail.com>
X-Gm-Features: AaiRm51t-DxCOty0kWu7756NpX-7MJWzFYoqmoDH49tZNQ6_AS6ejACehZM_JVY
Message-ID: <CAO9r8zMRwFTbv4jWWNf2sEc+SkUawxPtnvOc7LKsJr5R3vkZjQ@mail.gmail.com>
Subject: Re: [PATCH 05/11] mm/zsmalloc: Store obj_cgroup pointer in zspage
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <hoangnhat.pham@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: h9h1947kb3hboz35xot8q648q4n8gn5k
X-Rspam-User: 
X-Rspamd-Queue-Id: 676A710000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773260260-220716
X-HE-Meta: U2FsdGVkX1+G/uAATR68ffVNXYyX6sZB2Nogt5mjXsMt+qPnas5gZuWuqn3QNDsuDvLPZD4mzOuDCyxPsvcKlNqoneqnOXr/ygLS1G25HXzLCZu1PfV6eVzH5fnllUuo8KC0SoK36jvn/GCXIxJmgSkSgE3+VND+bqwpaoysfo8qZ3YbcBG1nt4K0+82Idf9zlx/MKHAydPIH0QaIvlfYD4qN2hQw+NpHyff4UapxWnL5NoGnlwDQFLJ5xIMnSnapwovh4yPTo7I7pi7z90iy23SNxp5uWOLYOsOsix8jrmGHZrr/WOjfgpQdmEun/F2ANsMMXA9znTS8cdtG2PVOkAbOC6DueQLcR5PHHxXx+KXUuFZF0/sOX/X9EqynkHStVeh8Wu8S05Z7w2GZJxx1Q4rRgv4t3kAHGmGp/bqgS7AHk7e7SiQhDYQa35D0S9/rdxVhH/bl4El1SWTj6P3iJhLrgZLwu0l6Yj6OacP9AlBubu/Db0mIwr+89YLKSyzHCs5SVnvxrg1x95xw9+koxy56SAyF42hW6omrv4GvQLbo/4fzBNZoJIZr9GXu4kmfBPDH5uyL9SC4FkgTF9bFmm4iIn+TtbshVdjms8nJIx8yc2cxWvxAvsO/nYLKhKtpiCbVQel8mS3k+8iyuANQn/2UEQzDZpKj8F2mHwcCCIaYZ1YOokXmD5GHC0VobN+NuMmqEz3vd2iPvX0JHKFXXeOXZinKG9CdkFtSM9kFtYLQHE3bcHNkNe2noP8CSw+6j/HZVaK2cQ8m5u8WyTTkCPcw+WmJze8n4SL6YIvoV+Tvr106FHt7BXsJvGfsZmL1v5sMI5/PB07t6RZYJCH/kV91FVONrbDFGGPYhcrR2qMf53sowJA6mD1T37XuFuWfrZ+UDxOb85Vlcy0XgmKMahVzrYE5XhPIEf30ctxnG1GwW1u+64tKAASZ/GJ1Igdpl5jND1FUGWlStONXuY
 cr9lRFWT
 PpLO9DkoxFBmynElt+RZ2ZrMBwlWUE7XYkyjqaWI7ty9o+PKQYHEj7RFKzTL9KxUiGbfRM0cdbC67iqKWFmxOLD4n3miyvl8Nw68WCwFXrjyCHxsUXRjWKiCbpiqbp1AUp3KKKtfssMDNvbUyUvZNd+D2gwVljv3zkglgL5TAGJHg15sI4rPoE+02z8qxAcVbxkV1JAxOiipUyA5pGL9gicsUalTb29f7e+RJe7Yh9bIK66BUy86MhqZ5vycMv5fgsZb3SLasf98PEWk81MIcprPNh2CWXliVRAgcJDIAZqpebc6g5gziYv8zMCDb3GQWUrI5+atHFuC97X9pJYYROy1v+MPPHVeQG+BPFiYw/l2r8pA4OxOYxDaX40AMDlcILqMWKLzcM7huoob0goRLgFlhD6RPVKez/LSbOdoLwLjy5QA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..]
> @@ -1216,6 +1216,11 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>         class = zspage_class(pool, zspage);
>         off = offset_in_page(class->size * obj_idx);
>
> +       if (objcg) {
> +               WARN_ON_ONCE(!pool->memcg_aware);
> +               zspage->objcgs[obj_idx] = objcg;
> +       }

If pool->memcg_aware is not set the warning will fire, but the
following line will write to uninitialized memory and probably crash.
We should avoid the write if the warning fires.

Maybe:

if (objcg && !WARN_ON_ONCE(!pool->memcg_aware))
       zspage->objcgs[obj_idx] = objcg;

Not pretty, but the same pattern is followed in many places in the kernel.

> +
>         if (!ZsHugePage(zspage))
>                 off += ZS_HANDLE_SIZE;
>

