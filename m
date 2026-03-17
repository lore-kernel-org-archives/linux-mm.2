Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B696BFEDA0D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07F8B6B008C; Tue, 17 Mar 2026 15:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FEA6B0092; Tue, 17 Mar 2026 15:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF6F6B0093; Tue, 17 Mar 2026 15:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54AA6B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:19:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25D9B1C4FF
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:19:57 +0000 (UTC)
X-FDA: 84556520034.04.76E9B87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 375854000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:19:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jJaw1geG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773775195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iou0t69FV1T83sB4BPefDDJC1y/7+r6bHz/p8PwGrA4=;
	b=u7pOtOc1cs4fcImNibMrPO2/lczwslxDCB18tQwo+uPTiVQBQWRumE2FiEufAitPnD77MR
	tciO0RBR2NvZQ4FCucAw0WtoUlymsKZBiC6SeguTJi3a8OF7CiokD+BuiRidR63w37J+iD
	OMh3qwV5CtzdDrVcNX7r0E3cTHAqFog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773775195; a=rsa-sha256;
	cv=none;
	b=622uP7Bj8UNCP0NpONSnRES2P4CPhLbtvJqwmpObK27BBwdzTWtDJ/3JT6u9Ay78FaZBhP
	aVC/inUJFWa+jXOQj03Up+qga37UA2kWGuOx74Hgvq5Diqe9kkUa6afCt+WrzIW4DKoBY0
	Ju+dRzWrbacpAJn/FcYpoZfiixA0KqM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jJaw1geG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46C5744230
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B84C2BCB5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773775194;
	bh=iou0t69FV1T83sB4BPefDDJC1y/7+r6bHz/p8PwGrA4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jJaw1geG+M8nxP5HXZJoIvnKvGekDgdgkNAc8agEXV0GXIvQ2nFAsxGgd7jydY6bS
	 4NMQcuXRbILKwL921E12jNKPY3Glmcg2lK+yt+Jwrrt/PXSORVZiGx/m60/O6bjdT/
	 ez89oUHMfeBwTEsjkRhPYcoeh3cH+pKK5Ax1WU7QOTWWEfZLJ65nB5Za0ffgcT9M82
	 EBUlxUk7zCAscD5e1r3tBvWcjXooWbGv1eso11TsueyFH9JHxL+jotOxjaAIzQC1qM
	 EhNPJDDaEperPX/3td/6QUSWo5Y6YSCYBij+pvFILAMxg7OnjWj6hafA40hSOUdcEy
	 tFj8C4OdL+lVA==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-667952a44dfso801795a12.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:19:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXBjPDN+/+dr/S+L4TGx7fffH6On2hYKd5HOyBPRz9zCFHpHxp8lHs8mNLlw8oo0lrYYoRLWnRToA==@kvack.org
X-Gm-Message-State: AOJu0YwJK8h8/vn1ULyDeDRZJOM/KRdlY51+MtJy36ATAQXxyTD7frHx
	GxSWgxTBqCXJfwXPQapvgPZ9tWdwepye4mK6CQaSBvvvP2gC6bDMYQcvsyXp6pUnrLcgICjxnTG
	0wQ8ZLg+ooiE+I2a+tMsyR+b5Lb+AM7I=
X-Received: by 2002:a17:906:a892:b0:b96:d877:3c9c with SMTP id
 a640c23a62f3a-b97f4ab458amr22347966b.38.1773775192818; Tue, 17 Mar 2026
 12:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260317014802.27591-1-kanchanapsridhar2026@gmail.com> <20260317014802.27591-2-kanchanapsridhar2026@gmail.com>
In-Reply-To: <20260317014802.27591-2-kanchanapsridhar2026@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 17 Mar 2026 12:19:41 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOD4UxqCmtAS1UM9o_AzOoe_09F8+ApTC6S0kkfFPg8wQ@mail.gmail.com>
X-Gm-Features: AaiRm52ZqVEZ4I2eLDPJC24YQ4sCHyY0lb-up-D3dXZzzMjVZHWQiFXAreOyORM
Message-ID: <CAO9r8zOD4UxqCmtAS1UM9o_AzOoe_09F8+ApTC6S0kkfFPg8wQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 375854000C
X-Stat-Signature: 7udcbnqja5jq56bzpgjq86iio53nx9t7
X-Rspam-User: 
X-HE-Tag: 1773775195-687193
X-HE-Meta: U2FsdGVkX1/8siQLKnvkLlYk3Zw/xLv87eepp8/xd6I6dJ4Svwnpm4vzt+FxgPeFbLx0DwwfPYJ48WPsISRll1n0wb29pd2F1V6D2T5uIgUCW0LueawO8GepAX5YidHBjiJVtWbp/gdX+zIszyZAnHdSfgoP2TgE7TCz+IJ2KPkLAEKye4M/rzzVJcedDPNtp9SOnWyzS3HmwsBUVqP3gtqWBiqVWr55Dvsnsjb6w8zhceYthoapmmIR+dHxawTFeszzCnMjZbCAs94Pdrmc6KB59icUTan+isqID4kt2dJMr6Nj8gv3RUQz+32WJeOt3+QS8A6uL5XL/ikB+rDBkJK9nwY8h241d52BPU78rYtgq64uXckpDSL7czn5bQ7HSvjp5Kmrnt39hqMxe7wpub9qK6e0XWHzDn4K7/1KTUjmkRsPM4dlo1cB6O4c15u43ZNoeKvvGbW4SkJ4Cste4Vk1EVI/bwkOZnJcY9PI/CJib4EsvLhLPS1y8p1CnamxkvocD3GD0Fmye3QKwSZZUiNSjSujyt6/SUH24sxv6YaX0QHznP34zIeIBJ3j9FFAMQq272SGJz14hBJzohqRIu5Ba+xSNwXRoHcZCsIRuvEUluPy2lzYITtyjSIMdf45a6l5Jutd8qgu2luPGfiHrO6jCNJQ4O11gcOzenuBpULvU3bvTvy8A6Y75+7z36WV5hcuafSaIdmuw3bl0lUrHemfhH5/j8oM1j3Rc70TdzROsAPvR9ImeHPrzPVVboUmxsyZVzoN2/tl2rAXLdMz99RGXqAEsaktZOdIiL8cABf7+UrLvS9F29kNjg8N7T7RBEjW2YYgaFSCxcxM+n2CSw/TN1pflfZ32qdu0GFabmHHBCaYleSAzHivk2JPmFTSTzy8AxMb7eBt273CNRcZhsx54jzlNHez+EmZlZZzYPnEgd3AP6UG4mpvd5LRCR/Hd8AUh2tspBTYiqlZfm1
 BHMAU1MW
 VyqselxZhZyFH+LUgGHf3A9AfY3P2tN8KRc5k3x9txaNirDujLEl938CbejXnCH931cL4+yXn3GDKkQ2E+N8QReme/5R3E6jFZw60JWViiqZvClpvaOQbulx9xpmPsfKo2a1QCPQcVUe0c+plhCKtv6aHH9UJLFStqgKncmO3O7YR9d8eJQiKxWSOTbNcL/PvmouTjTuCojXNHqcPEVA9ZCkqYQxW+bgXmvVnCz42Xe2ZF4yqj6z0of7zEP9TtV03Kujh7xvkF+AT9OC4vkuZE4+akDDvqYIs2oDDlcAJZMMLCLUc3a6bFBLD1896Z9LHEKafddYCe50MIMXAdPosiGUozSNR4QSWiLWz62WfeYwkfN6QvbWydHA1RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 6:48=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> There are presently redundant checks on the per-CPU acomp_ctx and it's
> "req" member in zswap_cpu_comp_dead(): redundant because they are
> inconsistent with zswap_pool_create() handling of failure in allocating
> the acomp_ctx, and with the expected NULL return value from the
> acomp_request_alloc() API when it fails to allocate an acomp_req.
>
> Fix these by converting to them to be NULL checks.
>
> Add comments in zswap_cpu_comp_prepare() clarifying the expected return
> values of the crypto_alloc_acomp_node() and acomp_request_alloc() API.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

