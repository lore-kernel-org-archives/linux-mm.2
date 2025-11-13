Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89961CD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E623B8E001B; Thu, 13 Nov 2025 03:41:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E129C8E0016; Thu, 13 Nov 2025 03:41:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F848E001B; Thu, 13 Nov 2025 03:41:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C42A98E0016
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:41:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94D2B1A08BD
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:50 +0000 (UTC)
X-FDA: 84104940780.07.F2A688F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0AD98140004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=j0cUanCe;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf23.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023309; a=rsa-sha256;
	cv=none;
	b=K/3VEJo7f1comB5aLmav9tisbVr19XbcIT3iDEsZit8wE9+18E4a3MIXKUAZ/m/3QSCKWr
	NPGE1TIpZkSqvVIANxDNswv6HQdB+qIxM9RU/SJrHdhXSJFp1iOTU3ssEgVil8ZgmcROr2
	d2g/NSXKi6C8h2Fh7ns5eDAyqIN0s/w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=j0cUanCe;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf23.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GE4SHGJoo7oPuBaKS20Hyw8mw/XyaxKtPhUHOHJxaYs=;
	b=DxeJVCj2GEjFYxiRYhAcxqSDT1OvLtmS9h2t7QDomKtQEF+VA/LOJOOCWjiyMSdhT6rUq9
	jKaj8ogU8sEO8TSv0c25RWeyOPcv1m57YgKXU++8KBHY2mHQZMJmJh62wN6gkxby3faSzD
	eWObpMDVClLj7E0BLsSLTF1Qg59IC6w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GE4SHGJoo7oPuBaKS20Hyw8mw/XyaxKtPhUHOHJxaYs=; b=j0cUanCeDc6vTjUKxx7QGVe7rD
	FsT0QsM0+S4G5sLdmTLN6yTb9NYCMyDvxTP3AS24SLRH4jWBb5EGXemMHxIDMlQjOMz7+VOWQ8mGV
	E19XtWm8+2LudGGub7OZLCZ7m2I/Kz59B9phhRnA2x4cxF3Y6B0mvciNbQRDLO1lPL6cAgOrXL0wF
	pZmSP2pZkd3jC06u5izCKPKabTNuzf2Wh1X9BFTc0Yp/RTYcxQJNCgR7pj3qzf1IX3pGGSRM3tSx5
	UZJ3znUlno3+mvsI/qNvI5otqxGN4Pw2cPJxTSkDR/8eaKO//0KHj6eteQ0yZ679Fuj64vTe6yPXS
	FQFA33Cg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJStl-0000000A7WI-1Ti1;
	Thu, 13 Nov 2025 08:41:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] mempool: drop the file name in the top of file comment
Date: Thu, 13 Nov 2025 09:39:52 +0100
Message-ID: <20251113084022.1255121-12-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0AD98140004
X-Stat-Signature: xexktengh3cr1mjmbndyft4gn36s554e
X-HE-Tag: 1763023308-313556
X-HE-Meta: U2FsdGVkX19C/QS2N4BHZWf7/hrOV2K04YAYisCJzszG3QplYfsBKIyxuMNsTd+nZFXuXcOcP3l7oYtbCb8W7SRyGMT8h34J4j+vAjZpn4BVnbrMInPqeWOg7uh4at9d9fnYJ/RXgoKEqUOLeziD1Q7C4Cy7I4VnlG0deHHxtR4c0FYeMK+/VSND2U+MMOQVIz2jyrJw1c6hbZgfizI0Ht8sz9OpWHWz0DPvFS7rZH5WIqqhwBaKR3Fb+uCVHRZTwMOR37z/YhEmh4t9dNt7FX1wYygbE5OblTYTI/Ws/dvMoZu4eWTBadBUHidiZH7SWN9YZF6Iz99GdUSmlflIuNWG/rVGrAUnZQJHBo0DK6yGYCJ/IHu6TT/FoN2f+H9sae215xL7l6fqI81Oj6I9nw0/Gyqd/EuGj3t+Uu9VX5MbV+ApZ3hBsfJ4UCZ4t9PpFPxUyxr8BotfYtPVzRTJl4YOlnBZBBCCiU2aV1z7GWqlXPL7Pn0LRKcWr5p+9jyVsxdb/4yIPPmhtYQSF8+9CkKEwk75ukVcfPz0sQJ2kHyn9+rzdb1rI3ACUocPM8OUphT54JbEG0jI6sQVMzQc5TceR+t2kcfnttKHOAxML4rtlJTNj4Xn6t9LT5Enlm4pWI3AOpSLUX3f23nQSx1ESxhK7Z5JrxrfnPU7f1ty+PHai7Rlb0soCgMeSEykJVaurY9hCief1+9IBY5XPI5hRNRE0SfveJFyNCn4jgNaThM15PNoJsl4jlu0I095wk/vOez/EWdrewa4ceVieNTVp4GWNBzDbtM8UeeqeXw5BeUiv49eVDeDzCMNmHnw98302G3u4GaVt7Wpr2C7lrkgDj/8OCIyYIQ9ax8s6FzHxKvJX9qufIXCBotBFtEQWixT3l14GlIvuazOYGkaggLAHdMflF6tsXRmbrVWg4dx+HJ8F15eChN5xyUryws7xthGntcwym//b/7OgtX/sBQ
 50FraD7i
 Wyae57E7QDBJhAHqGFYgil2krYiBQkUtXUKxROSq4BEH08hhpzyJIrny458KfUozoIVIKKu0aSy31E4jAeHNCQPax/eCwbjyrlTBj15Ov6R224gF7kw4ROGx04fGoVWZCOU8gyBWXVcV7ZK+7qtjnpBHAuE7BbgP35c8qhd7tTH7Ndu/E5h+HTOX10PbHBUKB3iB3HMRdD+MlZXexgIkvrrsJkl2bMhItUMpI1U9+/lYAGl6+hjAjhJEO9/Dhu4jgBSk8hxdE1jOnC7Hc0YE3EjiegnkAIwzHqkq5ulggZJ+Wa6A2hYjqS+39sWdqgJO19Ey0AbGEnKcsJ6Da9vY7e44BpmiUApWfp8IkVdNIO2zCqF1fcPFhtKCEXVuBA6U0GkyGkF4Eu6eRjrWlva8QFrmsHfsUPUWOvJyuvERhM6bkaILnGEgbBgK7dANeCW4LUnmbcTjrYCpJ3Y7eYUCbaGBSv+cclJCw649UtyLZok+j/uDutJBtgd6Yd0ycZ7CuqknJkCSgpLBGhGDCe+3qAOb4JaEEBhPmqG2YtQ9hWvXErz0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mentioning the name of the file is redundant, so drop it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/mempool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 448ff2e578a0..e14d1cf46c72 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- *  linux/mm/mempool.c
- *
  *  memory buffer pool support. Such pools are mostly used
  *  for guaranteed, deadlock-free memory allocations during
  *  extreme VM load.
-- 
2.47.3


