Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E828C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD646B007B; Wed, 22 Jul 2026 10:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5306B008A; Wed, 22 Jul 2026 10:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBFE6B0093; Wed, 22 Jul 2026 10:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5756E6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:04:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 772E3401B1
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:04:11 +0000 (UTC)
X-FDA: 85016581902.02.36835F7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D67D4A000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:04:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCVgnYM0;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784729049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kH0UiDy6iA8qhgAkS2XGaRTI2kmVSqdkfcswAJ2RR0=;
	b=NdjBO1rsT6ZNibLJFVe/v8x5XMdRloPBBgH8gQnBv++7RP9FTldcHlBUNkT1R6IPTft9QE
	Pk1h29N2K8IPaIBAdplZJkpZhfM1pvoTESfuYETHZzqIbhjiLntClaskn143hGvAHdlkJ4
	EN60aBwfsitWnT1R7pQzFWFgVtvbwtg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UCVgnYM0;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784729049;
	b=ZCfIuSFch7ETpwaw+Ecn1gRgZ1KdhvWxUXofkHTxmkmjcPnA2iuMF0a0l1WRgOfg/ps5ke
	Cqg8/+ChBBm66Hp0jh24dfuKaFgDn1cxjf7Zn45gvcxkfJnhSdmlLyQ38x/rzHP5prlzhw
	ct2jRn1jk1RcISkhvCm9ahK34O4hyYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 577D5600B0;
	Wed, 22 Jul 2026 14:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDD31F00AC4;
	Wed, 22 Jul 2026 14:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784729049;
	bh=5kH0UiDy6iA8qhgAkS2XGaRTI2kmVSqdkfcswAJ2RR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCVgnYM0nzaYUeSvhwaSiiwHHGClKZGjt3YMsoI8Pxfdi/Mw8dLNHzK9Khk6TamXC
	 WINroK/kJx7WiB0fZivv2oi7jBx0JknQp1XAmRnX9EJhSMJ7vxTFLpAKKWxVoabIyc
	 S0cJ4+pQRIt+yno851PG2NhXii970/xxRuUrYlrvmzNYf3IP2NGpY33sqcpk0zGx0j
	 tE7lzO5IjbwEM4lG1jJ1DWVCzZx2nbwFBoMdKgafeNhAeZKLRAn/9K8nsSFvbjsL7i
	 xNqcFIa1/ZliFf5IsWM+jNtfIZhkTlCGQ3sARQGQKz9l3OU4G7bm8j5C8U+kODF9t3
	 V/GLOOqYq6tvQ==
From: SJ Park <sj@kernel.org>
To: Cheng-Han Wu <hank20010209@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH 1/2] mm/damon/core: remove unused damon_targets_empty()
Date: Wed, 22 Jul 2026 07:04:01 -0700
Message-ID: <20260722140401.88772-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722113338.302603-2-hank20010209@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D67D4A000C
X-Rspamd-Server: rspam01
X-Stat-Signature: dr44azr91e9ufh4imqa9o3kk9wyn8j88
X-HE-Tag: 1784729049-485713
X-HE-Meta: U2FsdGVkX195tHQ5Yx1aUEP58wIQ0Azmoxn5CKCeM94L9NDkxVOgR63i6fbygUThg062cM+8M73VdMqOPj7jc3uTZEaG86hXzzMY/zF3TOMrNqT2W8CdzNzNJpN8AxNI3Z+XD3jDg6/t2s1nLrFF8D89mcNsnCpGfHrx8if9qh/Wtwm+blGB66A7NvgIjop1yIswFx4e+GLWf2FgKET3QeFfS3BmRdMosw8weEAvkT6CFjzzN7Dhck5tLAi1EyFokyay3zgYWEdL06A14QFojBKEJJ/8EDYfb+Vn16Wn1BO0Gel2u2heTtzVa8+dbiahK87imKpLuLhIO68vBOEbmDr2IkTeQjUx9WDnfJdoWSB+Fuy6t+/7pdlyJIjxryzqxL7XK8w75foRP6m2TbsKhvlm7oyNUijypgeG6iFnZ2c3ps38iCQa7sFh6sFmjVdQhQ3KgJlEKNM91DFMCgG4Y8oMoXxLd0RklV/SXi+RQXyJ7DbFvtP/FG7tIX9Q0lNKoL1II7gQlD3jN7EBVms3D2Vhah6K21J4b/3iuIbpy6q3HhFPCGt40q6fVq9VVvWqyquYyKrKoXDZXZjXkLAMyX9rNoVmDXO127D4aFs2aQs7VqhKOIUWYkU0A+tRZYxlqr6WiP0NdMIDJkMDgTbJYECTft9XxPCY5r36bFSo5dY9ajcngEDgaP53zOUiUQC2UFPJAcc+wqajzaCBSkyjTdNxda7V/cAeeliuHd1up0tW/nzGbfT7LZUw3xUCYTozCXHU7bDfsGmONoqgwi/K47zltC0qyxV8l9+FgPiSqrnw55y7oxbm3kBj5bW/fm4H+5Q0TX/RqZ0sQiO0bN7dX5sbn415Hvj2DLeeDjxdlOUXROB0n7kIdxi2WGz/oJpzZC1D9kixTomMtnCW6hC8BTQ8tnHMZlihhAUTfElMSO7n8PvY5/D/n0wOx0MkyBWVY5Twod6DXw3R2B+2i53
 9vlk9Hn2
 Q7bTy2YWbLXqkfCv709A9XRFz7BmlBelpnE45zcVMom0LYxAev802ilueU19o2b+sdQEdGcHtvWCLwrGhGUB3K9TvWdg1tAzEc4jbD2grTmTvNxxN+ZFYI6pVzMpFYBmkopCYKzkz/D8jX2U+dsn6pueyLSiQPSy18REPbxsRQYcnzfO5BPRnEIEa7nzNtLMfhY7BPEJxiBu0Z4sbquLokBe8RWx25Bw0K5imeprjWRXKLjy+yAZBAGaj6Lg+88SYn5OEV4ccp/XuelwSFItT/bPCk02GNyFXpLxaTmk5MGfQ/zg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 19:33:37 +0800 Cheng-Han Wu <hank20010209@gmail.com> wrote:

> damon_targets_empty() has had no in-tree users since commit
> 5ec4333b1967 ("mm/damon: remove DAMON debugfs interface") removed
> its last caller.
> 
> Remove the unused declaration and definition.

Nice catch and cleanup, thank you!

> 
> Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

