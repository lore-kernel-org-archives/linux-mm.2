Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5A6CC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9617C6B0098; Mon, 14 Sep 2026 12:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9389B6B0099; Mon, 14 Sep 2026 12:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876456B009B; Mon, 14 Sep 2026 12:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 614B26B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:58:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAB78A229A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:58:23 +0000 (UTC)
X-FDA: 85212976086.30.52E7AD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 526FE1C000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:58:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxtnviw3;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789405102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPXFV7WbqhoyoHdqaE8UVyUuWxfYNUVV+jLy3zXJO3E=;
	b=5049zhSN8S8rAkriSI8MpKegr3pJqZWukYaExoanpC4bnAxexLaxNHP5n8yr6pc3SrHfW0
	u9UGGq0+/GpbZZdLhuYZjScED0OVa9IfXHhbu9y6bJfe51mrzyqciewL6Jc4qLUi59Ojg2
	4QMZA5juvnY9Y6oOObUjb1MaREvjRpU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jxtnviw3;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789405102;
	b=CWj9ox3YXW++y7EA9tXOm/Cr2/M6JoqjUWCKwLUUnURLNQx5uBXU6D/J5ND8P3r4lBcHAe
	1qEJ3cvu7EtQmFB6ebe/cgme2OCDHDg3JqtUs3w6biZy5h6JYT4+ZWvOR5eozFWtUl3YTp
	rTxUK05og/USPY/lYK/r4j0Pi3XL8J4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B721A60142;
	Mon, 14 Sep 2026 16:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5001F000FF;
	Mon, 14 Sep 2026 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789405101;
	bh=iPXFV7WbqhoyoHdqaE8UVyUuWxfYNUVV+jLy3zXJO3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jxtnviw3BedCag17+j/BHTNdDpqaSSUHebfqQZ4E/e2YNxB2LfTJqkmntAq61Fp6F
	 MATLHjhvfU541ShcF2rLtdRVu7xUdNDV9lngpptGvpZVPDVN0i6MtIgszoAGw6c92B
	 OYdhiRAeN5Mi9VTbWrmYOgh5BfR08BthO38AWzeMKkyWBYxQvHND3K8n4g+86rewd+
	 EDIg8HcsEuUsuPVKO4EO5zI8KLUvfY/EhZq/1OjwNx4XN7aXPlwJ3W8hi/26HE6eUw
	 8crQV+vraHGx9YZQ8TpRqohkngZDykU4DfWqVQkyKWPXv83nICAlszkUoVq2B36M7U
	 4stobkpu6OR3A==
Date: Mon, 14 Sep 2026 19:58:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
Message-ID: <aqgnpAqG_OS7gTeX@kernel.org>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
 <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
 <20260913111700.6de78b5834842f7dd3f12d07@linux-foundation.org>
 <aqbvFtlXd3Jdnfbm@gremlin>
 <00dcd8d2-67f3-4ecd-bd7f-06ba1f9c106a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00dcd8d2-67f3-4ecd-bd7f-06ba1f9c106a@kernel.org>
X-Rspam-User: 
X-Stat-Signature: z3souoob789g8ceucbwoagqjxa7hfezc
X-Rspamd-Queue-Id: 526FE1C000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789405102-377786
X-HE-Meta: U2FsdGVkX19yNBiM6rkEsrrAJWzUfo1ROCwvHXCXuBenLTSQlSQmnxq72IiJMe2f0lAPDt8PDSda5gI5/2hWIwRYa/l8PEGuERF389/PUGv5IbkdasdRO8eLZlu+s8ic7EvE5OCo070TEGWtZUqmEMzEaj5DPEokSCSNj73BuCpeuwqX6OJCbuliJA9wp/nyVs67VKQMSQOrP8uTvAvoXG6+ve8XZvrPQOyy2eT6Rv6bWO4c5JS+VFWxtEwA9Zicmjn5ldrAFgQErO9bZuUgpJL32rJVOhHbeP4/NkBT6WvcrNgl3B+ZGL9eoRkzWtDXP9rhgnPA+8ZeS70VQPgoGB4BL5jr5+ka3coZ59YFfVF4E+VkJMT5YuXIfbHLzwWbvRl467kMme9tPg/PcV7rGWMQJzPCkd5vskGTXqq49/VyMozS7LKyck2syibPP7apKCIpmTqf5k4qOr9vbFfRG4SN4rY+aVUatrjI7yEjlYRkGAldCF6xl8PON132YPG1GBHd1Aewa47cVRU7sTFMWtFAei/Ch2du8lL9UabMV/dr9ZXgzqqYEJBp4+AUpZ/4W9swDRVH5Xv4Dzp/dI9rHlzDvhVlGF4VN3l5JWAyZPWFY8TR1VjsRwMGPN6XA3UMoflezNh7xFy888AQBv/YpTWUss3XIPqTThOp3yRfnbwgBtpT/fnwSxYTgtj3S0G3JvbQ3qG4b4XnYf9lPlzrZC0v8Ne3FDLoSpiolO/gq6dUJzCyLpiIE4n2sHKuMKZWLWbkBuMt9yn+oAuLGIKwOTVBctelt0MgC1PbBC8IPdorgoQKzia9SUScIftOCryP/FKXeZ85Zzdh0Hr5Mi4JCOlbAzvwHXN2zAb5x6lKAFs3R24i3EsvW3x22tkjaasEsE/tTQCKpYHeZVxqRdr6aJx+nzHQkCkm9oltK2LK4YXYNDTUBbJs9xrIzNsh9o9GPtYW9GfQHmuoHocaGHq
 kMJRj8kU
 Og7k/Fwa/WiNVglLEnqP71keCFWTTHM+UYwPWxHUPg/CDCxI6+HL6FNOkzALVDwJcToSeJsyezIFpF4k8a0i5ifh4w7v8VgksfvrilFzy5ny3CGouf9t+mE19mDR9t2sd2DSPeWTTF0e5aV8D3ydvZcoRyADqViIOI6yaUAD9kNH8z2+ch/Rmi+PCtxTwF6Z0dntfGE6PZM1Uxqv4653sLGjJ0QmljJPkozEgMIU/Let1li3gBgiTN3zcW5Prxc88htxJkpYSoyYJyjQ8IJzjNAiWwlkNmCqAOvn1qmvxt7gbOjosSk571U0LaLjL5VJl07QvUynVTn5M/JLVAEbrChhZ74PCfKZpk4fyoKiWN1N2a+DpYbZ3n+iJKC52A8c1Bdq4Nj/N8lcFbCWuKq/y9Ai/eKLXN62U5Xdj1EN+w8Ood5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 04:19:11PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > See https://lore.kernel.org/linux-mm/aqbtfms0_2ULBIT7@gremlin/
> > 
> > I am not really entirely happy with somebody who has sent a flurry of patches
> > across disparate subsystems with no previous track record being in charge of a
> > potentially backported fix.
> > 
> > It's David's decision but I think this fix should be taken over by somebody
> > else.
> 
> IIUC, this patch might be responsible for random CI failures (Mike still
> investigating).

Checkout of this commit in mm-unstable [ 1be399d378b78 ("khugepaged: hold
invalidate_lock across collapse_file() readahead") as of a few hours back ]
'khugepaged all:file $XFS_DIR' fails once in 20 or so runs on my machine.

With this commit reverted, 400 iterations didn't fail.

> So I'd prefer if this is taken over by someone familiar with that code.
> 
> @Willy, @Zi, @Lance?
> 
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

