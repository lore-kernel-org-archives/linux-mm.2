Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E450CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 10:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30BAE6B0088; Sat, 10 Oct 2026 06:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB8A6B008A; Sat, 10 Oct 2026 06:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB226B008C; Sat, 10 Oct 2026 06:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D70286B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 06:14:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5BF6116084B
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:14:58 +0000 (UTC)
X-FDA: 85306308276.03.F9F3CE0
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 662FEC0003
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 10:14:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e4i7GkoI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791627296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZCwz3KK4ioGo2sblpjh0J8bdLeG8IsOrV/Z4ACQP54=;
	b=OIVbgXWcbiWGClNdX/cDjo7WBHah95FLAIdChuSvu+nZBWl/wIU+YX9Bduk4N/sGZISQO8
	Af1kEUNVLGsogUs8Wv1RpeH4QGJ6WVxTmnefrP/OIUVf3V4XtKi6ims13zZSiI8nhAWhjN
	w+lTpm2TunQF7Ff2vuhBolkl+mWzvOE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e4i7GkoI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791627296;
	b=jLGqy6r8jbDvYDrD9tZzIQj3WRRtgxXGIOpkP0mtt2wvktkXORR7Z/w1Ee2umTIv18AGKv
	KJUn4L0Hdu0c+QFAsGMawkdr+/13gOFcomD+5iayTRU1SIpiMWa/l7irnIbrmw/gb7hZiJ
	9VnEurC1S6tjd7gW04PAJ7ivjj1RSjU=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso444801f8f.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:14:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791627295; cv=none;
        d=google.com; s=arc-20260327;
        b=qRg83WK2gdOquYGpryX9wfmozzJNz2ZAnoFwDgBzoOC0M7H2uYxc7rjl28dAjJbO/e
         nYGuaTWgb2AeWD6tfij/bmee8HpmNY+uFuGph1Bg53vGboW8qjoJyUh4PEYmRVSKwGE/
         t1deRfE4ZnaNZ+v+XqFzfZ0cIUlneLerbGm2+vr9eTIYThd8pOREgqXqxqNcHy6NTxs1
         6ecqm8LGm8aW7aPDcWCsxyN0RKf0BmLf1446vHYHecldvg0c5Xz7AB9mgDXwkAEM1N59
         SAedUC0PQuQceYgt9g4lrU7Gb8pxzc5j5pcNNsjLt4XU12NIkGbsHhMgxFus1FkJoSAb
         ea8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4ZCwz3KK4ioGo2sblpjh0J8bdLeG8IsOrV/Z4ACQP54=;
        fh=QION21sHmRYdriDPunFAWhtR8Bnv1GVv4LG8ZWJIEeU=;
        b=eczfEK90+0vF+XrImsHblw3eGRUHQEU8bkSz5SJpGHbTID4mNtEJyWdgVIClm9suPa
         3e9Sg0CyN9EB1OEH9tp1EcOcmyJA0etQYQHQ0MBXK0rCPEo+u+pAegsFIUBcCPVqvR9g
         kRB5qPeMjjThsE9j4mAHuQ19bIrEUTez4V4kqfBGI/U9L73h06xRl7FdxDYJxdci3Nji
         xwuPKM/vRkCL1qByGnLVcyGexgUCkMKP1U8vC0EMIH1CRW7g/waVAI8GH9LXIf4s/Rpx
         Gz1G8sQBFRHR04Jn25WwD2rnMq481alOM7fDnzvcNc+ALgq5SoaqSjzZQDh++7hBYSxm
         ngow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791627295; x=1792232095; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4ZCwz3KK4ioGo2sblpjh0J8bdLeG8IsOrV/Z4ACQP54=;
        b=e4i7GkoI1NTx9dkxDrrYDMc1CULZzZq+8dMXXrzi/oQtZim9TBwuLvSbbvg/uiEzKb
         CP7IE7irU4vokkRLvDGYHz0g6vDQGsrSkqcRtb68pUM+WZWFSextR508yFVbhUiYmt/0
         tC066ogL4RIUPG74acpdy1CaR+tiFEB5R12oLnUJ9ernVvc3cwzLPjUdMARZG8JkEPVu
         IkeSuBqc0oIwvrdy+chxSkQhkNLREfeFvBEF2qMUrCS88Yoh/CvrFbKjnMgjb7fQ0DJ6
         CUNxvNcx6ohDFlidygbzCt2bSZ+34rLlcEI4noVoCaB6IK0K4JvBjOlyh0G5fSD1a7jG
         871A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791627295; x=1792232095;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4ZCwz3KK4ioGo2sblpjh0J8bdLeG8IsOrV/Z4ACQP54=;
        b=DyMZdHxc4ZK7lAoyBceUFVlap7lF5k+Wm/9QtAWZ0Dfy5IpK+1TsCAkAdkimTpHdyK
         HpdKStpu17H7mB9NtPezHnSIja3ikr1bwTbVyu3zjZbT9exLNRc7Q6SeacFH2mheQiaG
         4uet4yD8ukA9u3hMpqrudNLze4mBxmjzK3bUnSeRHSVkrUphOlozIc1OozqlLJVl4UHc
         Xini3J2aIxk1BjoHXv9bONvABD6Wp4c+bg7Ua8e8w0dxmlZsBybiBvVsUTtko0jCXW04
         OdqrgI9hxvn9SIeQ1vZYNzoQQW32DRV3rbWvaXAM4MR0zh7fys5jDTsJ/hAagc4ooqqn
         36uw==
X-Forwarded-Encrypted: i=1; AKwUvBxnN7NHH58pVYRMkOHNROLRj6a3NFkF0FlWo5cQ3fgJTE6EEqKUwTOyHCVVcbdHmSkM2ejWBzSYhg==@kvack.org
X-Gm-Message-State: AFq9FYIWK9g1HBx6bcCylHNb4TpLxxLPhS+wy/nDqh8KU3/pDG1W5b16
	DP70bfN4gwt6/eZr5Jx7OtvK4umws6ETsanZR/nbtHL3ntt83+o8TT6TiBEeZ8Zu2pXC2c1MNKU
	1rS+LDOPLxSKclqqjlETM2on/BYrt1rg=
X-Gm-Gg: AYBFou2j2y9D6Gzp9iNfNSQWcYms7wDlA1Q8NS6wacnv0Bk0zIlfIbd3b8MRxklA/QT
	tdA7+c7czdFMf6R3HJi+HtF6j6b/K5qy6FmE5iaoyJLSVBX8D5Xcf2PxUzXT9JnC52eB1SD/3Vi
	RbPMEIef1EwXUD/+DMtRzheTVsViHJ9KYXCNHn/jpArpErr8M5zIwkjKATJNCW2dz3s7wW4zQEd
	4yGzDyeVI9ecuCkBPXKcPhQ1TgmwDjJ2cR7HjCkGsOHjHqnfzHEcAquxdbJ118PbDhFsuBZTPRJ
	rRZ6l+HOL5L+wm9PbkpVsVTPrN1K4iiV02w4PbPVYUioJ0uVWbMOvW9fz3W4HhNJeXYQGD7Ns/R
	7AkhIfq+HoFA=
X-Received: by 2002:a05:6000:4917:b0:48c:7302:96ea with SMTP id
 ffacd0b85a97d-48dbace4edemr8358190f8f.51.1791627294664; Sat, 10 Oct 2026
 03:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <20261009163146.83112-1-usama.arif@linux.dev> <20261009163146.83112-2-usama.arif@linux.dev>
In-Reply-To: <20261009163146.83112-2-usama.arif@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sat, 10 Oct 2026 12:14:42 +0200
X-Gm-Features: AclHuK8eHrKrxCU2Kz0-csCBZga-KHX89XLvw82csYCAbhZVbUsSPi6LOzolr2M
Message-ID: <CAKEwX=NFGr9hwavYof=zGtZ-nXGcWWsxnt6xQE_F5D1ZO1MnBA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and
 decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	terrelln@fb.com, yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 662FEC0003
X-Stat-Signature: o59zo3g9r75t6sjtxnoy3rd8e7jhydxq
X-HE-Tag: 1791627296-788363
X-HE-Meta: U2FsdGVkX181cBugkl9xj6MAG9LsmmU/uJuq2NoSSJ3bBFnvYYVy2FkOACOcpR83TtoNUIoDBL0XFZZy+31BvdntEs3gbpAnvY8hF2DO5OrAf2mqfN7UlsWA6jXsx22545XSdgUEQBV8wOvgilxK4gKGEjyQBqqfL7qWe+0Hl4s/eN1Z+QaW2cQoODvSfsIsm44MC+d4K1nk3ALBoxsvsGn2SH4Pp0aRaj0mi738F8v2lNzAPdtyw3hce3Ral6nYfZgutGUiwPVWgtutKyW6mEp6lXLjo+OF3Eb9PNOWkZH8cCuIAn1aP8nNh0YjoRY9jZNBAG9rNQrQDE0kRag48N3C4R41eR8t3INJUoTZJfcFcRlV6gueeqCOFRH414BK7hdSrUF4ebhnZOGWUwHKThVj49/O64RgOXOmmSEZn1b0nTYVI+uhuS7NDwbhe6jFWITVgG/mfIZLUruf8kcz4b+A3zwGwTSpfhqVHnzJPXy1KZw+Zn7bsrS2aQu/oSs1i3fHzk2qSVe1lFNgY3fbKHGqa1cNXUJtxjSzq0Fz3IW1oZ1JECq2UXGS8nIPH5+pPxGj9IqlNIH9Zx3oGBf15+Ux7ZAZg68qlqWVcl91UUYlkzr0aNLMriJaJkFJYe/+VJNTyL93lfFBTAITLcHkqt4Jw5VSSmMo1F5SVl5rB9NR2uzf/s7x9ANOXdtDIWNAZ8hPM/go1BVEloKaP+hrzjlSp5O+AnNYcOjN9TMY/cRgyXivvZhXCz6hEzegBMnViiUyBfk1BTVoWAWi4gTgpWKLEmW0235T1O9A2aZI0S118AqpMr5hZ9Yz7ixLh0ACFplRT/fg+5yU7SNP6wAevMRm9bPwsp8P8ZQkQ62ksKe2PT/z9NYB5YUI3DxSDBYPn5+fnZ7J9IrDa51U1qhjEmNj3TOezr8F+Ln6oSfHKFKrFggbyfrx5DeXbNVVxPU/VyuajQOmcFePgY/S26D
 yygDVugQ
 IZzFtdKQVrkFipnZ43H4tZBiJsoD1y8aSloGHq478qQlWAtgX0rSmp6aR7X+dLmt5LaG5tXHLd8u+c86J8Bo0R1rILD88k/NzB82KoFZVg94YdGkhps55JkpUrfj0Rpddexf4mlvMdffEeR7TyV5HJPjn37+zouUA5klle1EL6D+ix+xSjPseUMrKrZj6Skj2k6W1SpkFZCN3V6iT9xLCKzSDqXpBYki6U6UaThmSLIytsvXrl61jeMuxbUJ9R8llQ8tx1JNW73YALL5hT/ipwnnNCBuuC67PD10CiHhELlDHqhgWPc18w4HUsAimSITtPPlmzTo6i9Vjz+BzzkYXLVidfYrMrfQpaJlz5CgfUoCLgw8U0+yuMK8kLXE9VjNw98Rnt2RVN62gs+hhJatbI3qA3stgqlpBX2WHUVIa0OGMzLrECNv+qlQj0ui5pYmChoEcDO5ZN5MiYXqPXgl0we3Y6YdtprGkm24Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 6:31=E2=80=AFPM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
>
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression, so group it with the compression request. Independent
> requests can share the per-CPU transform; the codecs and drivers
> synchronize their shared state internally. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
>
> acomp_request_free() ignores NULL requests, so drop the check in
> acomp_ctx_free().
>
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
>
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chro=
mium.org/
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Nhat Pham <nphamcs@gmail.com>

Herbert, does this also look good to you?

> ---
>  mm/zswap.c | 108 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 64 insertions(+), 44 deletions(-)
> +       if (zswap_acomp_req_init(&acomp_ctx->comp.areq, acomp_ctx->acomp)=
 ||
> +           zswap_acomp_req_init(&acomp_ctx->decomp, acomp_ctx->acomp)) {

This really breaks my brain...

