Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE2C8E74902
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA276B008A; Wed, 24 Dec 2025 00:30:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8476B008C; Wed, 24 Dec 2025 00:30:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9C76B0092; Wed, 24 Dec 2025 00:30:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07B686B008A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:30:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95CA413885F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:30:09 +0000 (UTC)
X-FDA: 84253238538.25.9B2A731
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1498A180006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:30:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGuUVSeK;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766554208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYq3X/4qB42/qRW2Uhtw/xDZwVcfyaccM2qzUYvMCMs=;
	b=6AUtSkxfp8/hkHiFmRugmNUZNXQR/dyk9ne2c4LvBiXRPzJRjpRmfjoltvRkho08YPj0sd
	QvmeaplVDJGsSJQUosIlcNtNWQUypivGyfWcQtlQmQBDBrLLLZ+IR650OzntZUJWFiOwXp
	KfyTa/sTaeDeyXUGYVN/0i64mCxLLOE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGuUVSeK;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766554208; a=rsa-sha256;
	cv=none;
	b=5LxrPA1qNT4HlEPY6u4mvmbims3EI9K+xaT1oHw3Sug2InYN+ahFapfbTXvBMacqxE2FkB
	3ubZqmWj12fKc6PVhp4fgJ4DrMl0UPkini6Lxvz5GenYsrggiZe+cEdYbmAHOx9J28zH3i
	Mk5Pw+LHisFTXed2SoyDgBIexq3xnJ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D0B460123;
	Wed, 24 Dec 2025 05:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BF7C4CEFB;
	Wed, 24 Dec 2025 05:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766554207;
	bh=aCu6Dpw4kIA0zMNsdM1hGIRft3R9eKCH/KpDIOa7sOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGuUVSeK7YEmAoMCUaLFUR/+7m9BnjJIjh+UXBDtYnpiR+GSouFnxVSyoKuS9uGo6
	 pCc8NY+HkDe2KK/MbkQC4FLdq5xw5PS36xyGYm1vsr2G6LDa4U6IevzltV31w2AB0z
	 36oBMy9ZihSO+VXerH6FW8K/gUYZMx3tXZFwEfPM3770/xNCk7cjsAAXQC0v1Z755r
	 TmeV4+ij1KIfTMJh578oikRD8DfoasIpWghxXg/0kczput+bo8ZD9FJD96tWh+5B+6
	 92ua6uuk/FC+KtHvjQn6w9W+ZBGPt3crScwrfw9jxX4JYWnEBE9zuTXIYeNgfQndxx
	 5v2W+9U2NMUBg==
From: SeongJae Park <sj@kernel.org>
To: Shu Anzai <shu17az@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] mm/damon/tests/core-kunit: add a test case for region merge size limit in damon_test_merge_regions_of()
Date: Tue, 23 Dec 2025 21:29:57 -0800
Message-ID: <20251224052958.81796-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224042200.2061847-4-shu17az@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ny9udfyb7jypct4cs64qyi48amwwzpks
X-Rspam-User: 
X-Rspamd-Queue-Id: 1498A180006
X-HE-Tag: 1766554207-829301
X-HE-Meta: U2FsdGVkX19zqyq2KOtgk5fdDY2WUm/yfTZf0YMTYii+bpQC/zU6CYJaM29JLprGk5kKmCAKSLfwphqn3ra1FBs3Vt0AzLllF7cLXmToHGtQGOAJUB8pRsB/aq2YJ4sZdzLprvFZYJEVIv3K58L8zfp3AgZW3wHMPV4nlf4JLjMnOh+Z9V/RD1QNPmB6DZh2io5VUflHzFHg1SKPzuNXd81u7p48N1MyMn+XuMgq79X523gSdh8qxG+xz2jom3WvRkK+P0qJmyuymYOFugWuH9O2U0ebtmeCnMAQ1ipLGr26Wz2wL11E553wWRQOPxCVR850pnvqCvGVJj1i+o0IWRPJ2TDo7wGwpJeTrGY766qUL59j8rBqU4MdG+8GHvmbirSQxpu+5KkQTu+/XCfOQii19mLtGdkHlOMKi1UlH4WB692mHbxwMugyqn+gCUgCWH6XQbmlWM4XVZE/nQRjhG1l5m0Of3nAIcYSNP6XUhmCe0I7GsogD3+RPGkYOMA2Jw1LiQ0P5ADtwHiK9eFB8lNjS9GbfLyjsh0GQI0jzI9jGJ6F7V7Fi7C7gRJRoloiCBqVtFxGHy1+rA/npoaW7ojX2jY1ZoVfJItf1dTFdp6B9Gx7enC5yk9h41YtGBfovCqEpRFFht4ZSNQUJK+5I4rhpIRh0cZ+mi4nVZ6FjUA8fdtuGA/KWrV3pu20SXJNZJ7M8S+eFmil9rTMu/t5GVj8b6t0LaWoic8gDecmxYGeMPTFno245lEBd8W05wNDvCVzOsm+Gdz9RboK5ysFIiELVnZqslK4rFdTafSh8Q0HMxWzZ1yIorkm2/pXkVUbYh9GpNFvZINDXx4a6OMo2FxFrkc5g7xMu/Fu6bggC4NY4zwvHMXCIDaHyBIQ3z4fWxPYBu8uYxeYxF05exHpFfGTjYFuA8RkCXn8+u7xgZ1J371DRAtXiWnzD8YqGdCu+df/dLUsG7y04uRj112
 67M1EQr7
 lExggFjo+i+A0ZOIDd2fTXmNsNkaNxNf0NTwhgdrMwgIo/EugN9erBjjxJ9z4/1mln/fIFDnxuu9oco5EvTS0vxDIslBNhvzX8ZOyd3cnwtx0fvvUWnMuI+YHQYSAQGoAa73SFfTgKLwqcnDJ7AvRGnf7bZ2P3hgFj2kAfKZzg9LaIkIYVXtpeyFhqiRYyOS4D/NpM1pY0E34BB3kphY4xuNToKjE4qPcTgSZYB57pZPUStcr+8sGdIeVkctKqpQkJniiVqL5COcpA4U1gjgJ/JCTemXaGBUxcJ6rpWwi9lG3tZW8b7LYS2G+hLGCjJGnjdmy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 04:21:58 +0000 Shu Anzai <shu17az@gmail.com> wrote:

> Add a test case in damon_test_merge_regions_of() to verify that 
> two adjacent regions are not merged if the resulting region would 
> exceed the specified size limit.
> 
> Signed-off-by: Shu Anzai <shu17az@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

