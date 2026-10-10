Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F4ACA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94E056B009D; Fri,  9 Oct 2026 23:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924826B009E; Fri,  9 Oct 2026 23:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8625A6B009F; Fri,  9 Oct 2026 23:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7DF6B009D
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:00:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E85B8A06F5
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:00:02 +0000 (UTC)
X-FDA: 85305212244.06.E375494
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C4161C0005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:59:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf18.hostedemail.com: domain of liyifan21@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=liyifan21@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791601201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=OQNG/phTTm96ATF0tafvn2UEonxEcGDzvpU6HVn7jkc=;
	b=21U8pwBej4braRaFzR727k89lHOK8x7tABkjbP/nPTLqQmNmotsPnoLDOKrHC+AD7eSjRq
	a4QGq4osfE2E7Vqe9LduLIEKKvYCK/brp8OU7MT6XYcaVKP/CnR5anxKqvNxjcAnSaVXWC
	TbL6mD1/lG831wrX16uVUucpLSQRO+4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf18.hostedemail.com: domain of liyifan21@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=liyifan21@xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791601201;
	b=sgd1dPqUrR+/2ytNJJg4QnTWSRp0tx3IasOhIZojWqFBn9WGs9fpWrEh6AqN2lRPS8e5GM
	cemNPt3/eS5Vf8Tv+Mr1Wx/adJCeiRl697TEzBmugJKKWdMWuzL5qLY9bh8tcZFuC7wt9g
	iriCh/6VEjMq5/mIymRDZFYytz82BM8=
X-CSE-ConnectionGUID: OJS8ygc0S+aTURbj4RhksA==
X-CSE-MsgGUID: aixXHEIASciLg0f986Qj+A==
X-IronPort-AV: E=Sophos;i="6.27,149,1786982400"; 
   d="scan'208";a="191389071"
From: Yifan Li <liyifan21@xiaomi.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yifan Li <liyifan21@xiaomi.com>
Subject: [RFC PATCH 0/1] mm: page_frag: account page_frag pages in vmstat and meminfo
Date: Sat, 10 Oct 2026 10:59:39 +0800
Message-ID: <20261010025941.1253-1-liyifan21@xiaomi.com>
X-Mailer: git-send-email 2.46.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.237.8.164]
X-ClientProxiedBy: BJ-MBX02.mioffice.cn (10.237.8.122) To YZ-MBX01.mioffice.cn
 (10.237.88.121)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C4161C0005
X-Rspam-User: 
X-Stat-Signature: 5ds5upa1p5mpjr48me5i7fjyhs6z568r
X-HE-Tag: 1791601198-944374
X-HE-Meta: U2FsdGVkX18a43PFRfw4tRlEWex2U5ctLwkn4APNXLTQN1pPnwPnmzVWkNBa0PA1mIAr8x/PiFWc3ksVMhHtfgCKEjYK4NOvioFpwng3mP3zvCK9+4mLfjxMmTNajieAuQ7sSl5VIf00B1sAPWCfCBPCrI5RMfHMgsJxLp/fiymV7FqhJNZ8kV8LTiVyWY+4Ev6DNLAQQnQgqDsdWoEaD9aRFguPFYoqaXigGnkhVne2x3GeMvBpA4umeWF39UNdzuaLhH/Ecn8jukv4UMCIDo8uFHr8S5H2LlvhCu3RXJp5XjWynQrrfKOzKLNo/iL1TF0Pm8vPkqs5JzLU+YXVKjjXk0TIb8PibPmae0NFPL1EUquRGGes1NAXvhYSjtWs24Rc6fmdMb+6WVviPKvR42KJ4RsHDqoHxY4bZ/zt4xpcZEBof3y52PLLaGba0eha2lB34Fm4pWQJ/i5sz/FSguilUhObMYeogouh2yXI1Db2WMmIsPspRy3grLlEl9b3grgPRS2LCzoU/gypB8EP1yvSIuHXD0K2LoMIXI2Kq/KIsJEIRuP+bifzyWYBBdL8AuW4ZjClpRgE9im2DF1Noo6i7UET4Kxcz2E6V5F4WgCvV7HB6TjwGFBT2A2lVlLzZZ8mQJzhipGJiWpYmICVStwfqkDOLORA5rBrFjQosImGBvDNKzCoDkHv8SADqG3kRbzkLFfmDMjeON0IDYfmHoYSE/Fu+914+w+mZDfyWJyR1mwV35zdnvMg7ofWTy9Rcn123gJIx0rr4LBbNrVbmzYE8eXTuy1rCc3qnZPPbknJLEzJ6DguENxb2ofgMPOFCdTHEzxoyXkgEso/y8K+PoPviRYvp4T3enJiQmQAZOgvPM2U9Xnmq+cLIKQ4xpzceK2jOFr+ZZdQEO+KUB02W0EO/I0yOiZ4Nhk5NmaOfWeevmJhrvEpfv011zWhTtEUMh9/KMsDBwCizdAjKp/
 AJBhlvx7
 d5Agk1qrHy7HWkXe0SnqDY4xSRwtfjzk2WJtnOkx26ZSj/qd7YyC5uskSvNYpDICfdSdifFQVMPr4boWAwcXcej6e3YTTk29pQMCVGJ/WOv4STp1VH2pyPIHDIEN2ZSfAK8pahyGLrkZpBhQ1OgeDvkiltQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC.

Pages held by the page_frag cache are not accounted by any memory
statistics counter, so on systems that derive "LostRAM" as MemTotal
minus the sum of accounted memory they inflate LostRAM and lead to
misleading "leak" conclusions, even though the memory is legitimately
used by the network path.

The page_frag allocator (page_frag_alloc / napi_alloc_frag /
netdev_alloc_frag) backs sk_buff->head and the frags portion of
skb_shared_info.  Unlike slab (NR_SLAB_*) or page_pool, page_frag
pages have no counter.  A preliminary measurement on a 4K-page
arm64 Android device shows 14432 kB (3608 pages) of page_frag
pages already in use at boot, and the memory footprint grows
larger under heavy load (e.g. sustained traffic through the
virtio_net / tun receive paths).

Patch 1/1 adds an NR_PAGE_FRAG node counter and exposes it as
nr_page_frag in /proc/vmstat and PageFrag in /proc/meminfo.  Pages
enter the cache through a single entry point
__page_frag_cache_refill(), so the increment side is complete; the
decrements sit on the paths that free the cache page.

The remaining gap is on the release side, which is open: a cache page
handed to an skb frags array (skb_add_rx_frag() /
skb_fill_page_desc(), without an extra get_page) is freed via
put_page() (kfree_skb -> __skb_frag_unref -> put_netmem -> put_page),
bypassing page_frag_free(), so the counter can over-count under
network load.

Closing that needs the page to carry a marker checked at the common
free path, e.g. either

  1. a page flag: PAGEFLAG(PageFrag, page_frag, PF_HEAD), accounted
     and cleared in __free_pages_prepare(); or

  2. a page type: PGTY_page_frag reusing _mapcount, accounted in
     free_frozen_pages() (requires that page_frag pages are never
     mapped into userspace; true for the current RX paths).

With either variant, the per-path decrements of patch 1/1 would go
away and only the increment would remain.  Which variant fits
mainline better?

Yifan Li (1):
  mm: page_frag: account page_frag pages in vmstat and meminfo

 fs/proc/meminfo.c      |  1 +
 include/linux/mmzone.h |  1 +
 mm/page_frag_cache.c   | 14 ++++++++++++--
 mm/vmstat.c            |  1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

--
2.46.0.windows.1

#/******=B1=BE=D3=CA=BC=FE=BC=B0=C6=E4=B8=BD=BC=FE=BA=AC=D3=D0=D0=A1=C3=D7=
=B9=AB=CB=BE=B5=C4=B1=A3=C3=DC=D0=C5=CF=A2=A3=AC=BD=F6=CF=DE=D3=DA=B7=A2=CB=
=CD=B8=F8=C9=CF=C3=E6=B5=D8=D6=B7=D6=D0=C1=D0=B3=F6=B5=C4=B8=F6=C8=CB=BB=F2=
=C8=BA=D7=E9=A1=A3=BD=FB=D6=B9=C8=CE=BA=CE=C6=E4=CB=FB=C8=CB=D2=D4=C8=CE=BA=
=CE=D0=CE=CA=BD=CA=B9=D3=C3=A3=A8=B0=FC=C0=A8=B5=AB=B2=BB=CF=DE=D3=DA=C8=AB=
=B2=BF=BB=F2=B2=BF=B7=D6=B5=D8=D0=B9=C2=B6=A1=A2=B8=B4=D6=C6=A1=A2=BB=F2=C9=
=A2=B7=A2=A3=A9=B1=BE=D3=CA=BC=FE=D6=D0=B5=C4=D0=C5=CF=A2=A1=A3=C8=E7=B9=FB=
=C4=FA=B4=ED=CA=D5=C1=CB=B1=BE=D3=CA=BC=FE=A3=AC=C7=EB=C4=FA=C1=A2=BC=B4=B5=
=E7=BB=B0=BB=F2=D3=CA=BC=FE=CD=A8=D6=AA=B7=A2=BC=FE=C8=CB=B2=A2=C9=BE=B3=FD=
=B1=BE=D3=CA=BC=FE=A3=A1 This e-mail and its attachments contain confidenti=
al information from XIAOMI, which is intended only for the person or entity=
 whose address is listed above. Any use of the information contained herein=
 in any way (including, but not limited to, total or partial disclosure, re=
production, or dissemination) by persons other than the intended recipient(=
s) is prohibited. If you receive this e-mail in error, please notify the se=
nder by phone or email immediately and delete it!******/#

