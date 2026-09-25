Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDB1C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D9B6B0088; Fri, 25 Sep 2026 05:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE266B008A; Fri, 25 Sep 2026 05:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3BC6B008C; Fri, 25 Sep 2026 05:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 707A96B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:02:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83A221205DD
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:02:47 +0000 (UTC)
X-FDA: 85251694374.13.2C6E7F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DC60B4000E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:02:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gLFh2pqy;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790326965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLM0ljOvvM4bUosC68Fkzvro/csdLPxLyGACZG0O20k=;
	b=EdEVxrnk9MrdJw43JX+y8uUTIlfVRyypjcO4oCEOgS7dETJqP5IoJ1H1PoiXWt+FDNxpyn
	lMzHdBpLRAwpj6XsgomtWo+B87tAfJ2HEZv3YI/cop3FI417fHPNlmP5p98qs4LkHPaK3R
	cfKZeJjI7Hsis1XxTnO0+iqMwYsaT9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790326965;
	b=ZkkMjZjbkdcSaLSWKkZiPiq6tN5EuFrJCZ8YEjre1x6EBqA6ssBTZzmjIx8tMkVQnOg4B0
	AK1CLI1T9uuwkkExTbKKMPcUL7BZje3m/lSYbDoiNB1bUVQ18/rAYvMRQk95KQviAZ1O7U
	zfQENpoz6Cr93aHixUqN71y1oOj0sv0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gLFh2pqy;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D2D343690;
	Fri, 25 Sep 2026 09:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990F51F000FF;
	Fri, 25 Sep 2026 09:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790326965;
	bh=rLM0ljOvvM4bUosC68Fkzvro/csdLPxLyGACZG0O20k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLFh2pqyt7vwBmDc2xfuwwE3HOJAa3U3cilehm7Iwjj0EbZo7+crWqLU1COEHF2le
	 MbySZw7N4oqbwgcye2XvZIQcqGk6S4TzH/+Y+1pJl7p1cCrYTIN2jyoaZbI2Zda6Dx
	 KY1fNZkirbh6tu0JFr+2hZasuSViYc71gJvGWlzzmk4RLeptOTd6SI4L81eC72gUEl
	 iKx6jLNKVG8GgncpGP39Luk19+tMaHwJxqCHxJ3R46+gO3XjKR7GyqXiOFSL7dpnJq
	 zeuzrpjYopnspq4L7+yITt2aZ3OhuWzbcs2Qth4NnBjVMjKmhZ8aeJ+/JQYat2tLgH
	 WXPwAp+hLYZrQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/tests/core-kunit: add test for unconditionally skipping the last region
Date: Fri, 25 Sep 2026 02:02:38 -0700
Message-ID: <20260925090239.47821-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260925045350.66595-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC60B4000E
X-Stat-Signature: mzec4uwbuptkfdi84cugcn7qckwbcoet
X-HE-Tag: 1790326965-274771
X-HE-Meta: U2FsdGVkX1/oOPWkp2oQ5pIYgaYRMZ0r1xhtBBcHl9lcjqImn/Ik+5DbVL+ltxag3Vpk3v5wAIZ67hadxKon9Yyr76/OwzbYaxapkcfniZXKr/1pyKk0uVkEdiow/XOXsjQqHe0Ja6/gX6uj0pAZsu9dFyxqrc5l6W/uBh3+echJtnHgMb9n3d2Xe2MJqpxBDmBNiZu+V74NOjHoHjJNwCp6mUF+wyTlofF/+s/gbKnMARtYPfkDJ+NvpcEdntuMJJlggWltM3dM/yt4/JeT08PztYP75GAIVhWWzjGXBS7oJj5sd5wpYAMF1Ub2OSXWFqhwNjX6/NFnE2bQfifUqqGlGnJhek8CDpRD3MHHWgLT4ZPInkV37DJhYifHOCKoSlazajQ2TAJzjFppNkbzQZP+pua/I2wshYz5P9YvrZ8TyHsAlNfOCqgtztmCVd2N78zyLOW+9GrmvhbjFwZD77TGYAuF0jEVQkZKKqAjGbYM0K/GirMvPlfC2yTZwvtLDlMEjH/Npidzjhc/DLZUDTH2hPxRzkbSiLAQPJMqkT7wyI8nOtqcE3zVcO/CjvePIXF8f3OxuB4SNndnO2BY6WyiNtbxqgAO2iGwjxkBiAblDuA8y0e1gfzkODh26ZKvKaFjf5gWnzXhS4NX3ZlVJKlwVkUPX78iD6JKXpzAU/ZMPX6e/1Aw3KFNkuwD1eZvQ5eajvfyyNtoaqmE4Ek1Png7AtLTbsid9qWmULkO+jt6eTsCIrocXkZTn9biyGPvcGuhW8OaCHBQYv8OyfdDoPHA/E06jUrXe5Pw90PhO+Mc39tL7k58etxVE5eUV5x9puCh+ki4aRhwjxx4xh5H4wpovjxp/LsBbJGYlMgilYplEiGrS3LUzyKYfolMZPFv5YuKrvaxNVY2YYDffLaxDPHXdxfW25Am8r5l+onZxUv5HKtEnClSI+DgqXkq24BeYRg7C6L2gwCifYuEB80
 gxRlj8Gl
 N6UwF7APhBjSG470OFPkmKlQqworPOfPKt23D962QI3/ouNmEHyXs0iPmudcPP0UBlew25BhWHKFO1FC8kFdizf7fECwf4nA9WfeAxU0Fq/wE5o7HpgN+htK1yBrArMrXtMAwkHY7ydOI+MafMtOz/sRuGIP82WyFuSbGciNIP3fPeKlDVuwxZhMzphcdb4ZO6COdoDyXQkCKp0O27LlzEuNd9qWiskYproTTLGSlmOihagw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026 12:53:35 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Commit 50585192bc2e ("mm/damon/schemes: skip already charged targets and
> regions") introduced a minor issue that causes the last region to be
> skipped before it is processed.
> 
> Example:
> 
>     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
>     2. Quota is configured to process only 100 bytes per window.
>     3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
>        addr}_from is saved at (Target, 100).
>     4. Window 2: The loop reaches R2.  Because R2 is
>        damon_last_region(t), the old code unconditionally returns true,
>        skipping R2 entirely and resetting the charge_{target,addr}_from.
> 
>     Result: R2 is permanently skipped even though it has never been
>     processed.
> 
> Add a test to prevent this regression in the future.

The bug is fixed by commit b3723b596b54 ("mm/damon/core: fix unconditionally
skip last region"), which is merged into the mainline for 7.3-rc5.  Could you
update the commit message to mention the fix, rather than the original bug?
The fix commit already has a quite good description of the bug, so I don't
think we need to duplicate it here.

Other than that, looks good to me.


Thanks,
SJ

[...]

