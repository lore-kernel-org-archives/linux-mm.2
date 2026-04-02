Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 744891112259
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35FF6B0088; Wed,  1 Apr 2026 23:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6C16B0089; Wed,  1 Apr 2026 23:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5746B008A; Wed,  1 Apr 2026 23:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 788676B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:08:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 172681A01FD
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:08:13 +0000 (UTC)
X-FDA: 84612132066.22.357ED66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 241EA100008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:08:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mNvGaRVU;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mNvGaRVU;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775099291; a=rsa-sha256;
	cv=none;
	b=kv5fGLoVTLr3tsbvNwx+ynsoao8F34AQnjjJRceDtxfufFyOVDvIHMNFRKFkGBMRN81TYt
	65H46kDfupnHSQ8n5vqH2mcnJNpTXkLd8kKvLZlwp+90plYdJrvnxMRYG2/MUNmsGOaR/Z
	fiLX/5de8IkRIGGoKaXQIP44nKRlCRo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775099291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLuGtaRPDG+FvwCXy95DpreG09wLtyRncgpr9wqNaPQ=;
	b=4p2IchvrmpdmdlnGlj6+1XTeUuU2ljxS1iXGPRlzv6ko+FnVS234LFDdFXTsGmBf69wLty
	x95r7bZHhf1+ZtoyJZQ++/ABQu8Ks4FvSQjMZuZz/EuDej0gsZJKmKdz7c9Re/LZgnAG6P
	DNYlf/5eoe7m7ktbdaGB9MDszSNPD8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1B7044469
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27EFC2BCAF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775099289;
	bh=jLuGtaRPDG+FvwCXy95DpreG09wLtyRncgpr9wqNaPQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mNvGaRVU0m+cLfoLXnf/bNCjgHIv7Y8l4HP2MxaLYxwq/XGWdRZnb+COaCEgGRrC0
	 7GdGMTu2k3Tf+DByfpT9IBuWJWiLLiIwF6zX+uRm/riNcQLhW23KAwQvyHUqhDMXVO
	 GqL8RVFQn5izhrQIMz6a6xPE2K3qIIJKdBqFmu8KVrOUpGE9Gavf+Z8CvLIfL1VbOt
	 JZwkcoHItUz82h+3f0LsUoFk0Qc2hhagXzRmlzNWOxB7WPZ59Wbv/vUYpaaEOiyMMH
	 u72F9XU/wdTkhwhJN/l+Awc3gcFwD2pSawUOqdM43NQjU/t6JU7MFHSCl2avNxzhbw
	 +yo4xp+Y0ScbA==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-65015facf32so440232d50.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 20:08:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVnYX5nK0XJX+NJu42lh60PKSvsdGYXLBNiy2OV24O8cYcfASqTyiZzL5jQEUckcxnLn3cQrldZsA==@kvack.org
X-Gm-Message-State: AOJu0YzU8Uivu0DR6Nmswr7jybQ07BRiXbxGGY9LoDwAsRB6DEqRrbh8
	aw3PBqktJFbyGOQPMAdxXe1rEqwpay7r/xmQVUL/Jk996gC6wmGzd9T57rBzpocm8uuMb5+cN/o
	vbpE4qcEqhlD5ClG0oKN1ALA8leKVcXJDsODKNDDtxw==
X-Received: by 2002:a05:690e:d41:b0:650:3431:24c7 with SMTP id
 956f58d0204a3-650343127b3mr4063281d50.34.1775099289200; Wed, 01 Apr 2026
 20:08:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260330071229.14614-1-devnexen@gmail.com> <20260401074753.238053-1-devnexen@gmail.com>
In-Reply-To: <20260401074753.238053-1-devnexen@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 1 Apr 2026 20:07:57 -0700
X-Gmail-Original-Message-ID: <CACePvbUt8iyG+fQ+tDUYNRqGHQgQ=S1AYWiPXZR4C83bBZXTMw@mail.gmail.com>
X-Gm-Features: AQROBzAPJ5y37-kBPCx9hY_98BAaKjxoB11JTONCA5Vdcqgh2tGqLaGAT5N5tb4
Message-ID: <CACePvbUt8iyG+fQ+tDUYNRqGHQgQ=S1AYWiPXZR4C83bBZXTMw@mail.gmail.com>
Subject: Re: [PATCH v3] mm/page_io: use sio->len for PSWPIN accounting in sio_read_complete()
To: David Carlier <devnexen@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 241EA100008
X-Stat-Signature: zgmpyj94m9kiz3wsn1kn6jnhmw8o796i
X-Rspam-User: 
X-HE-Tag: 1775099290-312781
X-HE-Meta: U2FsdGVkX19/9sRXSvcyInpxgnmyI1TTrKjUQAgs6UQCHG3L6cPzuUODlOdogHK7c7RhuH24LtX9Oz53oW7MF7WhFw7rrjMfa4nLq4iTtaDzxIr/wfVpbg2DTohRnhvvRwtDKf5nNyRJ3t34k7bPbd6o1R5GsdYcdCbesZfZ+BxPuR710HNSlDAFn0MdDxliHlHP+e3sKObNcLY8PQlaxnlG8M5HbS8GbYMynCjs2l68TwKY8soIaijwcbMp+s1J0W0JSwe7gPG3I92AAadcC4yBtTHlkPPaVu2W9JxOjU8DV4acPlZsu3HDutexo2mxKa7bH45OcQzdM+uclMNyTn/7+R84O8Y6gb1l3WqEcmj0GGuG8t4cDTuQ/HXEH/ZOJKjTfxlfx9iTx3dGWJB3gQuYRQSbFlDqwt0MftK+/Cvzdm5fFJBO+gKpVrFT3h8gZCpYylesZUkgLIWh6pmx4k9UFxChHWoJU/AJFpJY/HyxJH3Zlfoy72CimZdH9A3aezw33tPffDpV5DB89KZ8uTodNkwuGnUIvr8JZC18J1oKyCEjXZ7ITJmYIc4TUsX2yHsUMkgmJNRUYdunkSLSJoC6p7EVlMWPQ1gocWX9ATBvH9b7s4fxsLXM2c4VYbNutaNoV6BinwjxFDMyJt3qpvkz7bIz/BpWKCJXLA79dChgiud+DgYj9jVVRobN2uK8CIV3yG82vq7Asn6h+fgAKBDYq3+Nndd/xU9DhMqFEg+4N0Zj7YorgtSYN29ANmXdtEyYpbbGFQRbvx4eNaekTPKj+UlUlk4aYPzKSDkfxYmRYARvP9vPBGZE7vq/5CQ0dugaQd34w7/hOYBzu/+9sqlHPq2lS8Ik8TLUWwuT78fQmoUELbUjYRIirFmIbeizcCoH7EobX98BtdD+fxenRztYli7dAi+MpA294eL1IbPDsJwgUnG+ARGx5zDRrrQYFt1g0G9OH63oNACWHLm
 Rq97yv+l
 qeo75pHVbGECRcstsaIXPJh8uD8jDy2xL18qKWF/qVgIHBO9prGEUkIIz95HYfOCr3fMpaxqzj8OxTrKNr11nIzNFgbzLpWHUycB45OIz1kZC2lZ7u4Pill5Loc++QRRgZvZ/vEBr155fM2m0s+0DlXSW5bjwCynsR7HGQ7ZPYKYWcO6sjuaV7SoAwAlUtzFDEWmb5AewLoPQYJ7XK1hTScqqv15u70vGWVbm4b585vYoaBA1yMndTA/rslzidHYPl5R5aJE/M+Ry9r6jDTVnn/RenY1JJSzl7iypvCN+7Pe/cKg1Xcg12F58yANI+S2T70wi9BL6taA7goXbM9SfTCqPeld6GycjLJyhq9knZHlbM2RQycdke82ID2ZIRHJpaI/ILP7umjOp69LGYdHOPOCU1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 12:48=E2=80=AFAM David Carlier <devnexen@gmail.com> =
wrote:
>
> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> but sio->pages tracks the number of bvec entries (folios), not base
> pages.
>
> While large folios cannot currently reach this path (SWP_FS_OPS and
> SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation
> is gated on SWP_SYNCHRONOUS_IO), the accounting is semantically
> inconsistent with the per-memcg path which correctly uses
> folio_nr_pages().
>
> Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> count since sio->len is accumulated via folio_size(folio).
>
> Signed-off-by: David Carlier <devnexen@gmail.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

