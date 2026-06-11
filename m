Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3962CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CDAE6B0005; Thu, 11 Jun 2026 05:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E5E6B0088; Thu, 11 Jun 2026 05:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8944E6B008C; Thu, 11 Jun 2026 05:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 788B86B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:30:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08A8F120575
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:30:51 +0000 (UTC)
X-FDA: 84867112302.16.04D43DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A41716000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:30:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KP06ksPc;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781170249;
	b=T9DHbL2oilwkxTSNc4bZKzjcB/0JukgakUAPFsZP9ls6Yy7z762OGIGQc7TAG+hsnClcLo
	Uesltv8le9FMzBgvayB+XiDCho4yCX7ZCbZOPQYcP9Y2bjoHeNhTLP/mJaQ4l2M0+CkahP
	C/0TS43niPw9NjvzbTGPhbIKDoQVxmY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KP06ksPc;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781170249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TiskwG1r+H2pShbZblB2rVkIIcz1z9RL0De25h/YHE=;
	b=kyLMiovJqLYd6QI7W9HRCqMB0H66e4ZhbAlxJkuFHqGXPAkJDMU4R5sPQpFD+5LDVii6YT
	7rUssfp7NM81C8JrzuKa77NldCIPDif6m1YSeIFgzxXCeU+FxYretK6OfU6+uqZ39DYdII
	/kGOEwVST6i3dt7V0ifw7qnLr1l1yrQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5BC5600AA;
	Thu, 11 Jun 2026 09:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7E51F00893;
	Thu, 11 Jun 2026 09:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781170248;
	bh=3TiskwG1r+H2pShbZblB2rVkIIcz1z9RL0De25h/YHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KP06ksPcr3JUeDqGcu53z++1ysqWhocUnip/fixKFfZn6UdOA6JJKVqdTUjm5v3lX
	 WbtL7hP8UOE6a4fVIYqfhIQLafFA+xIcDuUiIX0+ZiKLZPpQIbwCLi+dVIKZ7hIkUK
	 6EtS6meM4ch0mv12aRGk6OsBjWg2VWbrXE+Fy40FJ05jIHPpNQimtYEJh2IWlNg9ka
	 FwpJWWd7qxzRPlOfaIBBtZ+WvMX8G6pZGs+PZSXKpsBTvCH22FUGTyz2n7uKm7mUdV
	 GjcwmPB3l+7oDdjhbIhJMxXY25ENf47CMycbBEya3slDNUexh5cmiw/Ycq4mmfNCdp
	 1QJ+qfx2Y8PLQ==
Date: Thu, 11 Jun 2026 10:30:45 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Message-ID: <aip_e0RIrSnhdxuF@lucifer>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3A41716000F
X-Rspam-User: 
X-Stat-Signature: uhjx8zmps5bezwfqzxk3axjj7bnd8dt8
X-HE-Tag: 1781170249-912651
X-HE-Meta: U2FsdGVkX1/FoZ9vnS0oRiHsFFttnQf4bht7yQ/6XpXzhLVcNjDJWYQrCvYQgfgyufqzonXI6DPZ4mEumLdwHuuxbKxP3hpdfE/mRZw6dbO5oDk1++/7Enbiy66KhYViTxN4cmr7CmDqQ/4AiRYe+ppFb61PJ490lVX99lBbdTmY6hCgZh+WaZhSOpAeqkqCAVGmVJmpTxkll1IsxUGUw75kcguSKep8Acq3BAkgtZtjW0q7W0V8JhTPY2VWBL0QkQL9UYXR1o1GifSJWkNhSgyYa6FdxheQ5gNehhREPXNiuhCa7jvYHEIJI0Qn3oMNFa0eCQxzlpJkI3/KTzBaeX0xTSmOO3FdOR2L1BApkSrMpgmvgKdzEU/pIk1cue3PKo+kJUq0Wv/sA++HT0A6kFieSpD8fteqMkFqF/QEJuBGYVjzVJyrylTCFcSa4PkF+1t5FmEMLvi/9iBAZb6WfAJ3lNJ4LRal5U71MIbhucWDs7MczyzyOgl+ccOo2/14Pa4Dr/pJ1B/9V0Jh6xKMahI/MS6cGYoDr72fMP7l5CR2H/oWwWutKr9qChdooN0i8TEYjm871ibvmh+eQZvlRYU4BVlF2BYRVlucDCWy1rrTaOgBi3VBQfe/7Q3vq2RwCq+prIrTLwbuvaGFKBVuNDnHoqhEI9fvUyNCC72Ia4qm2ohWtsNx8wAOvp57NKM+b/zrPO/sZ7s6vui7+XSdi+IPxAOmrC7FDedz8klcrcogCzsjNzHSP0L5Rko5cQ5pwuL97GfuJFQA3T0HOuJ7ORuCrIgGiK8OQ3JROvy1oVxd4z5rQG03HLqFitO9EnvkqTn7XOEprzfVPIrdNWCFdC3TQH6skyjbv/TqKh0gLRFYR9FsUtj8AuR8+pNKoVpaDmKmBmwRqGQmzXDzudejfRVqYdPzZzy7b1DNOZ0A4yjK2QuG8tDT+VJ41Tr1+uz2+20cN3VBlSoObD/OAhW
 nLvCfEQW
 X1Uc8wZRnrQPqY6nbL9KunrzDUc5osgdwgGqn0QRowEVSPMyKM6CAexEbxhJrZKfkRGWIXI8YkT139nZE7YquehH6o/JPPU0nOycSK8Xh1ogV/CIHnntowZqE+0RBiRxux/L2tgVPEZ6+5TTmsBSxd3pxthHpszb2Bce7qSuSoeYrlim2sPQ3hYEBFgzlnndZ1kdfNyopCVCAVQJ6WCjXdH/ThkJYx5t9YQIq2GnmwsDawIPTJ3FT7Ibe4A+U1YiKh5K5Kg5ywFF5ZQt23sEzEH4pOK3AnfRcqOzWB9K/mHmKHvq+SjqCWCK7t2MFCRb0N1ZcFHnvRsE1rqZwrygixxCELkN9En5ayCUAA3HWXJrPaiV6CR0Q/3s7IdwoDNjV8uvuiGf0JSth40OFG2jKfqfgPDw69XsB2tWrMp0NLGcRM7TdTVYBtBrzvmd1ZX4piCo0Mk2q8PacYDFMbQS6oTadC8Wq8ZI4+G2Kzdb1SlbUR03M5weWJLPcfADRNegeeAPB9u6Cw8t/wq+P3IrIBEb02tBH/3dg2ZNe69VqK4vgUNTKaxr5nb+wmHxOXa3j4SafvJagwqm1XoTlXnHEeuY784iwphBjpwyrJsWHkJnBY/W73k0nFwfn+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc incorrect email addresses
+cc correct ones

$ scripts/get_maintainer.pl --no-git mm/huge_memory.c
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
David Hildenbrand <david@kernel.org> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Lorenzo Stoakes <ljs@kernel.org> (maintainer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
                 ^
                 |----- Please use the correct email address.

Zi Yan <ziy@nvidia.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Baolin Wang <baolin.wang@linux.alibaba.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
"Liam R. Howlett" <liam@infradead.org> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
                   ^
                   |--- Please use the correct email address.

Nico Pache <npache@redhat.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Ryan Roberts <ryan.roberts@arm.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Dev Jain <dev.jain@arm.com> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Barry Song <baohua@kernel.org> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
Lance Yang <lance.yang@linux.dev> (reviewer:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
linux-mm@kvack.org (open list:MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE))
linux-kernel@vger.kernel.org (open list)

Thanks, Lorenzo

