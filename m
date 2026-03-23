Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2700AF483F7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650E56B0005; Mon, 23 Mar 2026 16:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DABA6B0088; Mon, 23 Mar 2026 16:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9356B008A; Mon, 23 Mar 2026 16:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 358896B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:18:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4A7D1A0CD8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:18:26 +0000 (UTC)
X-FDA: 84578440212.19.E75C7E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E779D2000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:18:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UczAWmPb;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774297105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gu6b3LTmHAZiWmm/Wa2YeBmgt5ER9uj4cQupebbkBM=;
	b=XAkg61eRmZmrZOyr7JF6gjNTdn0VIwvvbuZb6K2fzRTfUeXat7AzS7PuBWoFkzTuuy1+Iu
	VZGMg++FS8M5CaZkieJHZNSsAtRODd3IkGvEqFhozUEJpLefcvVumeTBnuY8aerEFSh/LV
	hCuvZQVqKiB/bIl/CyG2GjXtkUvzNqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774297105; a=rsa-sha256;
	cv=none;
	b=ydVqQaz5lptZDvUeCnjfvLc46nVq53aQtR9fqwL8wt59rzGCPMPG9yWV5mlcWDn6ng2eH3
	ehbx5XtpkbKCcyN6Wq0ncbJz9xUte7n4siNyRri48ohQtAtFEYTMDgtbrh07M+Y3A9GJX7
	GLnG6ub0LxmwzwPm2k33HMUu86y5lgA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UczAWmPb;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E264444338;
	Mon, 23 Mar 2026 20:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEECC4CEF7;
	Mon, 23 Mar 2026 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774297103;
	bh=e5DL7+JTtijBA3D8gL8fx8L+pljVuSTB6hi6yJ0pRlQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UczAWmPbcKYGPFSHDjAt+hAUq4x3YO9+fNPL33w0RxnTuc0J0vOd8rt6CGfXXC6wt
	 B5ZGzBAYLq6k0hyN09Svizk7YPQeyr2iwwwFePMiLciOSGn5MpH0kZ/4YaRDIuPnSL
	 AO3AYRMewREbZS+KsfG9y8hzTN0TTz3/8XOOJ66c=
Date: Mon, 23 Mar 2026 13:18:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
 <oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
 <saravanak@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 0/7] Refactor reserved memory regions handling code
Message-Id: <20260323131822.abae01e95817011f24bb8237@linux-foundation.org>
In-Reply-To: <20260323100901.4079171-1-m.szyprowski@samsung.com>
References: <CGME20260323100908eucas1p2f471760fe1b26181c9b0cb90dd0739a6@eucas1p2.samsung.com>
	<20260323100901.4079171-1-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E779D2000E
X-Stat-Signature: yij8mwsrb9dok35scboe9anmnf9kmpt9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774297104-626996
X-HE-Meta: U2FsdGVkX1+dDJ6SasaswmS0NVNWZf3y2tr7XU/q0OptZI71B53PGz+oq7Rwu5SsklXwraDD2dRHkJjMsXQ87vyUy960V42lXArI2Qb1zCLlPKIlOZcNgJPMd5O/TmN3vc54u1uQSI9pIpmWwaVpPKa0S9ex93gtrCeCCfm4Zi3kv3SZ4q11dYaHQ2VucQ7dOAAvA2+bwc99SvXdd3jyxIDGWFEP9zT72vsrsVHHhg7ZIH7dDnQZBnwmqrlN8KlLPhoT62RLekWMxsD9LLmRfBr1em8EvoOUnT8B6SwT+QLviTH9jVTFn2cHP7U+2Owdt2q8obMoG1nv5zLE0/73u5iSgCYtkbIUhtdLfZIf1qab5NtaFi+FjYTOwCCDqeYHwwF/UxpjZyIJsNNEHSRXjps2wek6gjguDxC8XelhiL/6hOId8cUcomElAAx/A53+LlxiE6ikkCqLdL5t9p27sP8IKY8q5+zetRwTBLsp84zLDapgh8YLnOjwfjU5YFMx5D3kqZWLu1trDm7F+shP9LskPYogTIgpB9wnzVwpIUcejOJtRVSmbLgi0uvOt3ekzmR4sjWcuJcaghV38TUfMF6Q7tMe5ro9V5Yjc5DXaaVzxs7XZ8/njmFenxvm5uHK/txuFHnBkzaddecwVUQYT91pmb11NDLaRu7L9eN2tK9mdEeR5kGKYZGdTHsEjTdspXZQWoqHZnGu8zQfCVKTz5kdWUtlvaw9QMmY9uyJnX4k/NsEjHPf6qaLkCbLq68SSns+zqlhXRxg8/kOVErTFPVboWkKQ9TSGn/xPyfYAkQrmRRIqbFUxFMuLPs+/p52ITNakI6VyX4yAExDNmDHgRyif5RYKjglbjFsvTCD1DMbSBc9ic3veNzFtIXoO0xvP6djCcuNwFycRuWh3tJXP/JAkbr+VTk03Y3YkLFrlIUPRikvqrm4cOxJku+ffMMLRiEja18StmLU9/XoEjl
 ku9VHTnq
 0qC4ZJXRXBS6cTxfvzMTI15ajVbIxaYFALnQTXgoU1qC4hWTILE2k0IDSj8SOl4P8iAVSXXTAsZQbEQNEoW6d9T5nXYR8Oi4tljUt0LfGN0Q7XLg05x9nQH4d5+2JLYMLIUr68d5GAU5Xe48xRJ9+VF0j9YVYxIvMpfE7xu8LxKbAu75dUNEot8sROnAINrk4MPFjbxLt+FlDY/cLopjY/Bv5FnL5pVc9EhJFiJr8gvl/lRuXTTe304zbxqHuuo92PsZECts/817I7ypLI3BgVBQCr58dzQtUy4V1J5Kdid/mhrNBFWdi/PaOjZo6QPTitl9OAQ4ORdd2pYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 11:08:54 +0100 Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> The reserved memory regions handling code was reworked to handle
> unlimited so called "static" memory nodes in commit 00c9a452a235 ("of:
> reserved_mem: Add code to dynamically allocate reserved_mem array").
> 
> The side effect of this rework was a set of bugs fixed later by commits
> 0fd17e598333 ("of: reserved_mem: Allow reserved_mem framework detect
> "cma=" kernel param") and 2c223f7239f3 ("of: reserved_mem: Restructure
> call site for dma_contiguous_early_fixup()"). As a result, the code in
> drivers/of/of_reserved_mem.c became a mix of generic code and CMA
> specific fixups.
> 
> In this patchset I try to untangle this spaghetti and perform some code
> cleanup. I hope nothing breaks this time.

AI review wasn't able to get all the patches to apply, but it asked a
few questions:

	https://sashiko.dev/#/patchset/20260323100901.4079171-1-m.szyprowski@samsung.com

