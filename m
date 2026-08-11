Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50F1AC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A55D6B0095; Tue, 11 Aug 2026 12:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0562A6B0096; Tue, 11 Aug 2026 12:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED55F6B0099; Tue, 11 Aug 2026 12:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C1F316B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:33:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F895C0123
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:33:48 +0000 (UTC)
X-FDA: 85089534936.30.A5EB201
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 796BC1C0009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:33:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Spwd+pOo;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466026;
	b=O0RD2dyVX82P/q0zfS1QGUduyrLUsU7ooxUb4ZFwbwB2RVtcvAgCTHAKlsSanPrsBQpyK0
	lC0UwNSDlh337mRtceWvPIrDFOjeorCuh4chXTtb8bkJ1U/62pQlxNj4YIBtCPRAdDVOlY
	7galhTOSJcu6exKu6G/6PndUjlbSSZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Spwd+pOo;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0Y6aHzokWQZHc48xGLynfruDhxYQJrtL3pW0hOBhew=;
	b=OTQBkVXXIDTajTCe4ldGa4mdGfkOFGlJZxax/m4y4iOBs7h/k6OIG2wSrT6oaJOk3cazYP
	jmQiOyR0h9PjngtewsJz0Rakp5IYWJz4NO77LbgGI4Twc7ReY6xU04sNsSzn3wxgEiHEUK
	JSHjld20Ik+SP4awS8afW4g+rF9gytk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A27A043C0E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D181F00A3E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786466025;
	bh=R0Y6aHzokWQZHc48xGLynfruDhxYQJrtL3pW0hOBhew=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Spwd+pOoebin3GnaAwYP5/pjxl2/xCYsBAMx+7242TJno2KjxTA9fmBRXtquGvJPf
	 2d/Zedl1C71IikfKr+ZSKncZC2fkQs3xYnJqj3TT25EvaxpKSKTUNkFktTl4ksZaTV
	 9bDI+TaZxwh+irKq1oEXpQ5WpMAmpsXNaREkVVYQuWJmCS4C7eY5EGYcBa9FVhQJsb
	 lj30/rJSRo68V0tPZhRtoAdZEQ1KTsykd4COJT9ZNCDqkWeK8NgnzJdqltsvP7kaU+
	 RCIWr1uz/ITKWMoJuopW7Ft/uQSUr/S64uhAKhaWCEE/cE2/GIA54amG8hlqdZW5Ql
	 hu84cPuFsZA1g==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2020421077so3919366b.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:33:45 -0700 (PDT)
X-Gm-Message-State: AOJu0YzSVOgM41zHkNG1EPpCirx3x4ojDAT55yVHsE2v2BNhfHLY1zVz
	JneHn5rKEOFCpg8dIhgf/nulaARLjQhwDy8zwVk84dIxRGUHYdVHXWQLNV/PLgaHa2MC68mzTU+
	6PqOuAEnTvXs71AOv1athPfO1yiM+tQU=
X-Received: by 2002:a17:907:1c25:b0:c16:1227:e3d8 with SMTP id
 a640c23a62f3a-c20e61b0b35mr201593866b.13.1786466024397; Tue, 11 Aug 2026
 09:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com> <20260731-shrink_zswap_entry_v2-0-0-v2-1-e72083aa8734@gmail.com>
In-Reply-To: <20260731-shrink_zswap_entry_v2-0-0-v2-1-e72083aa8734@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 11 Aug 2026 09:33:32 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOutUhcXSfeqUj5gbjWwAdBMQqvcsV0YXT6uF7zZ8pK_A@mail.gmail.com>
X-Gm-Features: AUfX_myE0EcSigEvmEKl8KooTrV9ybvkq_4qGk2RbR_ytWr4ZeERz7Y47PqDnRE
Message-ID: <CAO9r8zOutUhcXSfeqUj5gbjWwAdBMQqvcsV0YXT6uF7zZ8pK_A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/2] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 796BC1C0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dwx8uaius3hb17fsjc75u5k6m887ena5
X-HE-Tag: 1786466026-879008
X-HE-Meta: U2FsdGVkX1/FFrzKHjPshyIvia3vSqu059xBs+kzzL6g81Mmn4SfggbnpLhHQaI4iBtzdfLZkENsL2KboU+fWgZfWGVnKgoyTsH9k75RhVgcXiBlML06B5eiGuzjEmDbBkbW0Fml2Jje3PU2vRHDbbLpmZXZUb7DBhONYYHkPUPD1xNd2mZFGhmYaKyZFAKhKAxJsPKSfFG2h7wzEIY3NGwqayAtxUn8rD8T9sBfV4uvp6ECqkzZvnkkKWOCCHiRLejXy0OW1sRViBzVRnLsa5yPZDWil7cSE9ISyVC87DroHQ1kxUYWjeqFEWhYmyRTVBEWpNRTurjkTWra2vg03mRMnrYhTmq3farjT3noF+Qbh81+z0hSkyIpgIlmtxrBILMcrG0Sv9Yb45mRWyYzy79OLszXlReIj6C0a6Tezowoe8WtwyPwliuKFAyXnDZkIniO8Y2r6DXBSAFE9OBwWPWw0rpHoxssP5ys861oXgl20Sdz23j7tztgy6VHOZast2ERZQTvQ7fOWp4E2EBqOP4vSvouIS2nehLF53gvDoOCX5guiRlzppAVBVaotvRyb7jAW+sMA/lJVfPykL/G5yOEGFVaWBjmtpjHQF1T9Hfcyq821WoPutxU5JXY8XwBftjkKBac+HqstpSFfKVnoaCkjf0I7eK/fzU0VImvlJkrr99t45Ob62ChT+gaWkbXUPX8WqBrtx87lcShkLvumsnj9e8wYfb2hWRwQGeBJte+kyEA6TPEcr7q8HZe+PGOeFi2IGnKKm550W53eki+IEcGeVgLUnaAzgnA5M8b0ZPWIuQEhK2ZklEKAJrBjcqPxoCdAFU/7wDyBANDNBpgzOmDPogMVGk+eWT8wFNGbBidYLscY3ZrKTFo/MtEmHIaM66U6WM6TejNA21EXpspLyCEFiwzQiAVIUd8CZfeswP1zb/av9gV6AXusNAX0VY4NsTvpEu9AXK2QFhqUh1
 i+Cmk1qT
 jx0WiXzU/KA6Oj52vUHRBq/YJ6Whn7b109KxFY5eej52X4W0jDiK0EdpMNEtTmiwD8NppX2K5qR0Ov636j54O3HJ/c3e836VET4rpiRJTVM/0xWBY/T2FkiCElSBkEwsip1pppnh+7D7OeQwIPttcC9g9t8ReFjeCFxm0iJ9VhSiP747ckCY+pffBodD0uEtXPLuh+CtlH9UtiB4qsRmHnBgKi9z+u4vztetc0/P/Ot7W6gAvxo3oMQ+fFbqAnGMHvojxlYtBMKyswpcbTq/oaDvp9FCnXPDydi0qWioOv6/HEjqdUMHnO/kdwfIMZ1TahFW+aa5SOrJFCVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -270,6 +276,25 @@ static void acomp_ctx_free(struct crypto_acomp_ctx *acomp_ctx)
>         acomp_ctx->buffer = NULL;
>  }
>
> +static int zswap_pool_reserve_slot(struct zswap_pool *pool)
> +{
> +       int i, ret = -ENOSPC;
> +
> +       spin_lock_bh(&zswap_pools_lock);
> +       for (i = 0; i < ZSWAP_MAX_POOLS; i++) {
> +               if (!rcu_access_pointer(zswap_pools[i])) {
> +                       /* Set idx before publishing so readers never see it stale. */
> +                       pool->idx = i;
> +                       rcu_assign_pointer(zswap_pools[i], pool);
> +                       ret = i;
> +                       break;
> +               }
> +       }
> +       spin_unlock_bh(&zswap_pools_lock);

Can we use guard(spinlock_bh) here to avoid the intermediate 'ret'
variable and simplify the logic a bit?

> +
> +       return ret;
> +}
> +
>  static struct zswap_pool *zswap_pool_create(char *compressor)
>  {
>         struct zswap_pool *pool;
[..]
> @@ -1763,6 +1806,9 @@ static int zswap_setup(void)
>         struct zswap_pool *pool;
>         int ret;
>
> +       /* Slot indices are stored in a u8 (pool->idx). */
> +       BUILD_BUG_ON(ZSWAP_MAX_POOLS - 1 > U8_MAX);

Can this be a static_assert() placed right after zswap_pools (and
struct zswap_pool) are defined? It would be more obvious and we won't
need the comment.

I am also wondering whether we should keep slot 0 always unused
(NULL). I am usually a bit paranoid, but it worries me a bit that an
uninitialized (or incorrectly initialized) pool or entry will point at
slot 0 by default, potentially a different pool. What do you (and
others) think?

A nice side effect is that in patch 2, we can use entry->pool_idx for
the rcu_dereference_protected() check in zswap_entry_pool().

