Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 322E0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 05:57:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0225B6B00AC; Tue, 30 Jun 2026 01:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DF16B00AD; Tue, 30 Jun 2026 01:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2EA66B00AE; Tue, 30 Jun 2026 01:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B68096B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:57:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46D5DA03BD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:57:26 +0000 (UTC)
X-FDA: 84935521692.12.34B4B94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A827940003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:57:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aJ/kntS7";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782799044;
	b=c6LzPUA5u3F4Xvcst0CLBqQytUO6hShOeOmyvCqVcmj0ID4OHWaZJ1intd1C/0FL2xEfnk
	W+l4IT2svc8USwRuOOwEMLykvGZjuu/SAeo45h2FFvWnFtG+9eNG1z8sbqihjoJOx39vne
	NQBONTG7z7nQWY/+41gH3MkeeIKA0R4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782799044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyJYCsE6xTmRMMFlBTBzhXZGR3rpltmstKwqZS6lHeM=;
	b=w+a/q1cn0AgfbQKoIgW+Hi6UnyrFVN/0xU/iOwnRmqIK7BU5I5EqibqY6zw3okfYk0XX66
	1Glq7TFfkmi1pPrfraTro21EdDJUSzWQ3su51MjOl1VXPci2BsrUWZ4tGLs3GOIDVMojCo
	VPQ43XVtR94v+2kMUg89NwwM8MtIy6M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aJ/kntS7";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2EBA437DF;
	Tue, 30 Jun 2026 05:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D07A1F000E9;
	Tue, 30 Jun 2026 05:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782799043;
	bh=LyJYCsE6xTmRMMFlBTBzhXZGR3rpltmstKwqZS6lHeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aJ/kntS7PgCT1G8W5IO936nUF8aVjpmcFkkMsElMuw+flusPuWyYIWQarTbMgdreE
	 YkqozLGV6ncLJMBOG2CbejlYvtP0S68tiEJ4wNLXexNw4ab+rbBYCxvPNjVwXzwP6h
	 7aAeXdyC1TCDMRhyLIYpyvx0keOQy5pDNG60SFN4t9xxtFG4t3FRUla8HGrr++4UtX
	 dW2WNDiQlvQw40XG0vi8ILnGt+CpCVBkX6X0CEq4kxhRziRn9OiLpgPfqIyW+esgLA
	 OgDyJqTeOIaNB3zNThXp5tU/ae9yDUdbfGZHAhZKRPAPNuDzweYrQfsS/jU/Tenbop
	 Sy+GKDYneQHaA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	SJ Park <sj@kkernel.org>
Subject: Re: [PATCH 1/5] mm/damon/core: use kvmalloc for target regions array
Date: Mon, 29 Jun 2026 22:57:15 -0700
Message-ID: <20260630055716.87704-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629145538.134832-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A827940003
X-Rspam-User: 
X-Stat-Signature: n1d58k3fc9r5pgxui6tyy9kxy9ur7x5d
X-HE-Tag: 1782799044-606822
X-HE-Meta: U2FsdGVkX19CAl3/oB6oZnnf+Z8eoOhiVY8mqeuz/t8sNrLhn69vtA8y7nuMuSpULk6hFchuqLBJp5vMTal2vxeWD0Qzn8lmPr2r/eFQCxZXJQqCV8V/Qgm7Gq8kITwKgm4TeHCqU7CyWN8DZ03/L4jP8pZufppaTIoZ+UUX2Xei/em0c6N7uvOSJ75l1B3u5JSE9yaUACxXB5NM2L4uRgHQWnYJsqZQBX/Rj81dbo1Yfl9KJJlmpAbLry0nk1s9zrveSSUpltlZ6bq5SMA/FtVD7waZyXInQ2onT8gq5aY/Jvh2BTBsfgfHwtCnpRiynbnK2ZQDx8cpOPJYW4mrG5/cgkz5JZkAsAG/8Sv612bLHVfSp2Y3VqJIt450uAJl67ybSf7JOk6ixNA1Mg0L6kC6nCqC3qpZSYhKGa+3Bni+ZS+FkJv9vB5HjFNvJ3sgjCE568XAmwDul8zf5MmQWbK7qZE73rytCJHBMJnsOgLh2f3kTYD2CbUH6db+inRm/Ggzt6XcZhlgTh4mSzzWKmv0dEAFm3JUP2FVlC8ydoRIgVeCyjbixfdd5X8YjqsnVCiIkMyc1xYvm6d5Uhu7PSgXD9kb+tURzys6IJOoNT5zNfZTuS7t0PrKbpk+2PUutT6IL2vq4zaRxSL9awD5mj5UEB1y5S/dmzCIgPZtoSihWA5t7qg1Z2wRTbn2ZTNG8zIJ96M65Z81phy2/ixSvNFA0uRArSmcROF/GdSHuU6EYp7kymWlJqHYPg4DgI5AP7lTnDgRBIHf5k/G/UsKZVa3Tuj9wNb4rfYRAG4xyuo5XMhTdunyEvjHSKfqxAuKlD52T5eZPun9dnPA5iYaWDgfvO1i7lbq8Qs/At4XB6UFyj3Jg6ipnFFUNLZr4HFfrrq3lMbnHsEf4fdMqRMlBoD+IV3HHAS6td1OnUgNsub+1ArBpu+iJlOduo97T7QVpLICshK5J7juAOISQko
 hzuSvzxl
 TZ4V1cpS/THr3kNLdx2d3Ce8qWLJjD5pCIav9yn2oics/MzHEGLSN0G61DjE2d/4tQO61fiyA2s+2ZdE9Lv8lcvDsCbHv9XS+6k04G0pXfMzbM0yMUVPW6AYK9vG07Yvl+n4meq+4f8jNq+8nNXVJ2ycDf41fqRk0TGfG/m9KWjo0Loah2EbzBSj8yarkpYJh/VqqmwYAal4IbtjvQKzJGqh6B3XsHUef+M1mcXcNYP00DROvFONckm9aZ6FNTtuOOhKQerkLchpEma7ZcGMEiUvrd9yF7kI+gnO/sSP9RgMXnYJTfWOqa1ErwE+3fgJaqUa4m0yccABU88Kt+QD2MoXiHeT+ONphgjdGxeIYgzYtTq8xlN7rG38mqpgFAvSA6iTIulXTi7AkZVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 07:55:32 -0700 SJ Park <sj@kernel.org> wrote:

> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> damon_commit_target_regions() temporarily allocates a single contiguous
> memory region using kmalloc to store copies of all damon_regions of the
> damon_target.
> However, if the damon_target has a large number of damon_regions, the
> total size may exceed KMALLOC_MAX_SIZE.
> 
> This problem can be avoided by using kvmalloc instead of kmalloc.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Reviewed-by: SJ Park <sj@kkernel.org>

Oops, another typo...  Should do s/kkernel/kernel/

Andrew, I saw this is already picked up to mm-new.  Could you please fix this
up in place?  Let me know if you'd prefer sending a new revision with the fix.


Thanks,
SJ

[...]

