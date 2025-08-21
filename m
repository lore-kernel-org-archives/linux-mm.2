Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A60CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FBF18E005B; Thu, 21 Aug 2025 16:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D40B8E0056; Thu, 21 Aug 2025 16:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511278E005B; Thu, 21 Aug 2025 16:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEB28E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:58:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07378138B87
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:58:13 +0000 (UTC)
X-FDA: 83801977266.06.BA30AA0
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5603B40008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:58:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=umNePAT7;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755809891; a=rsa-sha256;
	cv=none;
	b=yRVQClB11PiPEjheElM2Ie6VM4h33aug7+3k0njUbYrCOrmUMgmm5MoLTzDsanOTQfBIyY
	ca4wDg5NwMNoHqO4TJCzl6qtzlSB8JiU+HRNiHwhanAFCa8f2vv5Q9Ylk6qgsOwpQZd9M2
	I9xkz0CFh9v5v5uPC9ZmZSKpnuXsBrg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=umNePAT7;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755809891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LivtmMeCeZWwwQJpwzuEIu6S0LvxpimnjmIL4YU/XCo=;
	b=BOZHP2uShs9hNef5EwskNaop6lxpt312L3muVJYZJjK0dZvJ7bgeSwO70R+ARr+GW8HbgF
	awUEnpus+aD17/vljnqXjGC2Xt/1k8rnXw41NKCo3hNXjFyoYxfFJ5+plhBSWzoO+WNMcn
	+FTIA2eruQHopg3Oc5z963naVwTxPxA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id BC507A581E1;
	Thu, 21 Aug 2025 20:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EC3C4CEEB;
	Thu, 21 Aug 2025 20:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755809890;
	bh=AFBLWJOwJ4b7vAnIXPiDRB7zDnfWhOvar1ez+tAVaCk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=umNePAT7FP/nR5oaHv1H9T/yjVUYXR+nZuOVPtkysLQ9NhRZuyTdMBoFbF/ziX8K2
	 eV5xKGtgX5CjNLxozP7au3YTYdCUCJ3PXw/HZnwGKHApRpXMIwg+OmbWf3g+D8B0Tb
	 B4ACvmCB5X6wuzLlzZyLIBvwg69IU3jtKrzwqnqE=
Date: Thu, 21 Aug 2025 13:58:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
 Baoquan He <bhe@redhat.com>, <kexec@lists.infradead.org>,
 <linux-mm@kvack.org>, <linux-efi@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: Re: [PATCH v3 0/2] efi: Fix EFI boot with kexec handover (KHO)
Message-Id: <20250821135809.c12105ca2a246a9fcb905af1@linux-foundation.org>
In-Reply-To: <cover.1755721529.git.epetron@amazon.de>
References: <cover.1755721529.git.epetron@amazon.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5603B40008
X-Stat-Signature: 16rzo6h94f6ygp334838bm6hrah36ku8
X-HE-Tag: 1755809891-957499
X-HE-Meta: U2FsdGVkX19WqCKCZ4Kk4B8i67bpltfxd5PukPIcZmvro8Dd85TVt+w/TTv+yW5TFhLnhM8WVeohk9RzN2X7GXTILoo5fg0EmA6xuT1tCzwPKLdO3PZH03gNFlzUYc/Z9v0Smh+ZnTbRhegR307jt7Ymnht1JVTu1B020A3JufpPMbtDFLgdhJxPu0uWY2W0gKbaiwXSqkZTtfyb6XSQKMpOPi/mKzDx6OBdXFF0UANc/mmcfD2aAqglCYmdh/0zw2wluj4X9+1H/Oc/90T2gO77HKQ2OuwNWdzYi3kC9TOQ2Mlx5EJtVV8TqGLmAn+XeY8MkrEYOFNZvA3aWhRh6tfB0+u/ScAVCE3DTfcH5Wc05LXJtY2HJibathbDhGTSBSqJT5s/WN3gHv7m+OBcwKJBy+FLyzO49bbme/vJfu6vZKXERMe8BCQoKOn6OMR2fc3uRnltYZjjhOh3YhaXl6LZnxEuReha5wN7/IgzFwAWqEi1yrFMizfod/qx6vJbvolbMS7s1PsBk4iHgSwh8MZDLYRuOp2on9neJ8wM9IG9OMUvJDYMxNJ3zTr8TCC+yH07OukD2VHHdB/URRayLWmsIPNwCn33sjYZPrlwiYInXfxI9zc1+Li8gTvSPCDyWZvqlYMAlCEsYW2PHerQcXpySDKKeqJtBNiJwpu1cl9o54CnxB5hcupsx8zLJno5WjYPqX1f3k25ciOMQXkDZg59Z3V6H4qOcS5v3CuhRoPysJA12i5viOPYUAx9k3+lCx9++D2EpiIneIU0e1QusI0+00wPwAj6eczwzwTlcfE0+r3dE9humYyJS6b0gpVF43jdXS/kciLv9IZMzIZsRmQYbymTvPB0tgJRBgMwn18FZpckNaq3D5tri5uzhfwaCDKwX525BVZuuv94ylzNQMepGDOT2ouq+Drcn49KS3+/VYFzbrTmDCIVrC7Hps1Qmk3ucqyv5WyQV0GaNmR
 XaQr+LYn
 hAXwHVjdiUsaAiX1q0JN/DiiwAqn6rdt92wE24RcZIBGGoI0O7Doqdd+dVOShxO5X0vk7tA9Pd84Ls9CEA+zSKVvvUgPlqAzK5ZvQggXoL+V/4har90+eLsVfPniuc5iJu9eA6+QLkrk8VD3Jskks7c6gfn2jtXsYSO+twy962IE2qmoRfCnROUJuW8zx0wkn67gxfzqjYuHXPDjJSCIPTCO+oJ1FAN/usx6P6umC4kny5ybunPlsbS9PXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 17:58:58 +0000 Evangelos Petrongonas <epetron@amazon.de> wrote:

> This patch series fixes a kernel panic that occurs when booting with
> both EFI and KHO (Kexec HandOver) enabled.
> 
> The issue arises because EFI's `reserve_regions()` clears all memory
> regions with `memblock_remove(0, PHYS_ADDR_MAX)` before rebuilding them
> from EFI data. This destroys KHO scratch regions that were set up early
> during device tree scanning, causing a panic as the kernel has no valid
> memory regions for early allocations.

Do you think we should backport this into 6.16.x kernels?  If so, is
there a suitable Fixes: target we can include?

