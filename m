Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6309DCCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 06:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87ED18E0006; Wed,  5 Nov 2025 01:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F688E0002; Wed,  5 Nov 2025 01:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 744DC8E0006; Wed,  5 Nov 2025 01:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 629EB8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:03:35 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC13D1DD929
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:03:34 +0000 (UTC)
X-FDA: 84075511548.02.6624B2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 15D111C0007
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:03:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArhqDOPh;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762322613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JU43MY5/wGmNcu5jP2MZiX8YhVEcZwYRdtTDAgwvBnI=;
	b=vsEeqvo/AEK88CzB++kj/HqFd9RYYTkAIgmH8kuGiZCTf+hCEQ4OTVtWmH/aaeYVB3cCkf
	8IqRVzPel7RA47Lp85ZJ9YUts0aUGzvzBblGIkezmdzGFmA0dBWsdQm8rxCqjr9jKo9cjo
	ymbI5yT4gyegFyBJiHQNHCcn5Cu/maE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ArhqDOPh;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762322613; a=rsa-sha256;
	cv=none;
	b=8BUB1kW9Iv8f/RWNzj3G7pYKecmD4NYGPCeLuqWQBUJgsRh1GCaaGqFj2ClSTev/pZCXuv
	KBsi4Aenb/FKe00AOQDzO9R8ZPFubi9am2YuxVn/nDULNPbMo9O7fth+SZvQ5MYO1V4CcU
	nwQIsuAGsvQIOBX19eJxHW7wFxdKDjs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63CE660215
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15697C4AF09
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762322612;
	bh=g1xhnZvbdqBRVhT/a4y4VQrhY1PPwKPYJR8qRUw3TEw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ArhqDOPh1b81DmZcIB2f6Y6r4BG0yVdUcUjuYjFo5+IX0VLdjNjgECwT4bFre65xZ
	 IyeKskHA5kiHm/sGLeJezBhVdDd0CKWAcaeKp6/orMk+OSxmfx0E8bWP1ePKOj3EkR
	 ROHirXWSr6Qj/G6di8OeS0HpkjLZeSzYmMofXZEgFOhFDFjDmhWdXguvVQDz8v2Hqv
	 VRvMjkfdKCLeE+3/vjeWPIR89gKDy6oZkcgvrHSUsZi2ZWsoaBlm35vq1bbnBK8tzh
	 24B3R2l6m0UAgjxPwht8ApzbM6FopUViq7CTbNzWu/n3zrS5bncO43VlM9/PL6X8Ju
	 auTYBgKDaRScg==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-786a8eeb047so2073737b3.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 22:03:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWFuXoZAi4e1GuL8bcIyY7a4perzY/B2nCBTXZjYh/ZZZbhb+UcRo4XSnWe03ouwZuKSui2dFIwxg==@kvack.org
X-Gm-Message-State: AOJu0Yzx6CPldYE7FH5MJvMoClaqiVAiya+d/1gzbgBlLuEBxY1/x8KN
	xLJt1Xu8O2Vj4d+W2XjEbeK7JvzQLRVmsA+J5mEc5fel3UsuaBlv0oGqo/HH4yikluwAa55YsKP
	lzw/abfLqMGEj/K4vnzBUlQmBgX8jQr1K/gvjcFmH3Q==
X-Google-Smtp-Source: AGHT+IHOygTW/zgOkIpq7b2yGrPTq+yoDlQBXwxZAwD6fPnF/OJIRgdEpiTFVRJoFRHIAEMD25fvVc/YkNFprB0h0qo=
X-Received: by 2002:a05:690c:6c84:b0:778:2bf8:a084 with SMTP id
 00721157ae682-786a416b904mr18600107b3.43.1762322611332; Tue, 04 Nov 2025
 22:03:31 -0800 (PST)
MIME-Version: 1.0
References: <20251031065011.40863-1-youngjun.park@lge.com> <20251031065011.40863-4-youngjun.park@lge.com>
In-Reply-To: <20251031065011.40863-4-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 4 Nov 2025 22:03:19 -0800
X-Gmail-Original-Message-ID: <CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
X-Gm-Features: AWmQ_bkzoR3eIP2Ft56wXZiT75v3YDYeErTNRtS5iCC2Yj-vygyGzMQ7nVsZ-Jk
Message-ID: <CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm, swap: Remove redundant comment for read_swap_cache_async
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 15D111C0007
X-Stat-Signature: ca4qr5bnefbbqr9948tq5eqpfp1urk41
X-Rspam-User: 
X-HE-Tag: 1762322612-597675
X-HE-Meta: U2FsdGVkX1/0aGZrvhDmIH4Fe4R0Cr2xigwbr69j2Bo8eo6tCPk3w2gyA3QIWNMo+4Abj31ONQpP3dBSj3g4gCxOoDrsYTcpc/d5GFS/X68zcbi92qNsMvt6+wlscmjdnIBM7CK7Z7na4llENu/0T8b+4DLDzYRxdhdaRXne4Eo5RaWiZQoYwb7lNRFDzeFB03yeC/EbaU0V2viu+RSW6p4cqlkZRFLYE/envilVetfJlSuSwJLk41PbSEtdaov5LAk9zofkjbZ9v+XkR2cVft7Lx3jW0fJh4BBwUzMTA5PKdsz5p741Q+0vrSkcSfGf9zZTkrV/BxRKzg0rp+RMJ3rs6ZrK/+Fetmd8jDEcnNKuAlerK8OhdUDerFo/m1ize44rvOPh2NIufXnnJ692eV54x27VmKq8coMNfYkOwuLaw1aAoKCuOCfBt6bt5U3FgKdj0++PxS49u9S8dSS8Xml+NsAVYCQNs2s2JnVZm58JfE4f3mQhJAJ1TgqJwCnMoBALCT0o7fd+fihlH8AcpP8f+3rDzklNubk9XY1Zx3j3Qdrh5mVv7fSqumyI+Ze1XcRSgIIs0AesC1Jd2i4Eiaz97MFsfy86HM56aI5Y3Y+lgWnBtcNEfNHnjD44l+JmLWeW2Zx4QVfbP0ZRz2ib2xBkAE8tOrYMqB234bzgeFqZdeGX0df5r6gmyykuWHBu5ZLoZGc/3ONfVb8wizyoPB1j7gu6RdaJpfiFlOJB89gymHxUdTjS05jYeZXY8jWrAHeTZq3rJxoB1bxuvNhNNJ3Bjw6qsMwvEHjWnSG9e2lEO8dFq7894jcBN4GK76buIqIaejXp0YQUOyQX6F20dhDdCfJxmHWAtKPhb8qwZLUFv/kj1CqiTP3Y6UOHuNgXDl/EIcA1zAZYjm+OHW+dH+x6IEgfAl5rYcvRqhtV7YDFpiy86Vmq7ZyZ9gr1/rdIMX7dQ/hTG2IeOLtXXPT
 3rolMQYM
 EANENjwWOIJ+ZKYyXfJg7YEaF6sbaj8sJCe0XPtylrL6ZtZrX5j2A2nZfS7cCwj3bkE2R4S3+8CmzXc1n72I5UU81zGI7mpIX32kHszjIrWZFQwvJBWgAix77P/uuGY6RboGDZj6VqdtsWm65CfJr42/d/xwx+x6qbMI9QdG7Guq7fiRHd9CpPsIWwQCZrjONNfnNBr5XP0IUorVMajwXkcqd7x0bl3FgEeU6WD+DnLCAOkv9Y51CjuY7EoeepSDVzXnaiWb3zso8kQFLs9WosySvEz3u5x9heclInFRzsmRsOTdumm1bkoF10AlTUeiHC+uzs0StQGTCxPe636kUHAO2cbsU7EOESNKs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 11:54=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> The function now manages get/put_swap_device() internally, making the
> comment explaining this behavior to callers unnecessary.

This commit message is not precise. The previous comment explaining
this behavior is not just unnecessary. The comment is plain wrong. It
does not match the code. __read_swap_cache_async() does not internally
call get/put_swap_device() any more. So this comment regarding
get/put_swap_device should move to __read_swap_cache_async(), the
caller of __read_swap_cache_async() needs to manage the
get/put_swap_device() or by other means not to race with swap off.

>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b13e9c4baa90..d20d238109f9 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -509,10 +509,6 @@ struct folio *__read_swap_cache_async(swp_entry_t en=
try, gfp_t gfp_mask,
>   * and reading the disk if it is not already cached.
>   * A failure return means that either the page allocation failed or that
>   * the swap entry is no longer in use.
> - *
> - * get/put_swap_device() aren't needed to call this function, because
> - * __read_swap_cache_async() call them and swap_read_folio() holds the
> - * swap cache folio lock.


I don't think we should simply delete this comment. We can delete from
this function but please add a comment to __read_swap_cache_async()
regarding the caller's responsibility.

Chris

