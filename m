Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C66CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8756B008A; Thu, 15 Oct 2026 04:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379186B0098; Thu, 15 Oct 2026 04:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DF16B0099; Thu, 15 Oct 2026 04:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09AC06B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:32:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DC471C3DA7
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:23:39 +0000 (UTC)
X-FDA: 85324171758.20.DAFC2DB
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf08.hostedemail.com (Postfix) with ESMTP id D345E160008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:23:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Xs0fRh8o;
	spf=pass (imf08.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792052617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=i7XrOjcha/5xGl7C2l+gDmA8wR0AYq+P8njfjXb/pj0=;
	b=j9+SXUVDxkPSeP8Hpso7EkkA0Ij82HOPVxawzT9deo7NRL08B9p7iBTOJxtolK2qNuvY4D
	7RfE2m0CBWTXZLwrA2bXcdl4txOUv72lvCHfpJ16hb/szozeGBZprq7/WE7x4de3nOcXnR
	uSVgaExhNAW/x9qoajXLZB+0sLAfRpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792052617;
	b=T1P6fGG+mdSuKmnYpfx+/CdV1m0ZNiA1MshuoS4CGlHVn9Ulm0tg9IGjjDniWr0mq2i7E5
	/EvAnvB8jgfsf+BUtT3G3XN6EgRKYnCA4r2af0hkWNcZTeCIBOeH0og4HBYql3xN8+YHdK
	Ln8nx6F0Z90en/H4V7DPu+mP2Vz4b5o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Xs0fRh8o;
	spf=pass (imf08.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261015082333euoutp019d110f6e2c69639536b05ef0eb5bf99f~eplt6h0If2925529255euoutp01E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:23:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261015082333euoutp019d110f6e2c69639536b05ef0eb5bf99f~eplt6h0If2925529255euoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792052613;
	bh=i7XrOjcha/5xGl7C2l+gDmA8wR0AYq+P8njfjXb/pj0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Xs0fRh8ovl+UvSY/kYQHuP9sGejM+nlyFnV/P/sHVRtIR/r4KgvEr9rcH5WnhCjvK
	 WhaFUoHsU+cIPZWd0tPPxr8wVWAT4QIme6U4Tj5r2+4hNL8u8JJ3IsXX8R3eqPqB8I
	 w/veRnNMMwNjYQHqa0HR9apml5rCCAt3omM+gamE=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c~epltplZC03171831718eucas1p2w;
	Thu, 15 Oct 2026 08:23:33 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015082332eusmtip19b8acb6c51f5307cd82a4aa88e58c945~epltKpG1b0605706057eusmtip1P;
	Thu, 15 Oct 2026 08:23:32 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Mike Rapoport
	<rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana Kannan
	<saravanak@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 0/2] of: reserved_mem: use dynamically allocated
 reserved_mem array
Date: Thu, 15 Oct 2026 10:23:10 +0200
Message-ID: <20261015082315.56876-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c
X-EPHeader: CA
X-CMS-RootMailID: 20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c
References: <CGME20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c@eucas1p2.samsung.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D345E160008
X-Rspam-User: 
X-Stat-Signature: sxcpzh7gb48nhurwdda7sm1btegdh73r
X-HE-Tag: 1792052616-414022
X-HE-Meta: U2FsdGVkX1+EGz4FYFTa2oFFVQlYNemgbVbOydVcOqDUrNn8laUKjnKXWK+zO+I8umP2XD15O9zeJLYWfGvBz/4C69d0u/gJn826yBBm1VryhA1udjdWQlVUBXXl6GBmmO/HTdnPW+wzfs2Oo5D1I+9mCGTfdUGkk23BcZnOyX+kX+sZhhbebLlZs+ngVxVhNwADAbaB/hmUR5QCpbzE5q09rOtL08wowiA9zLOgF3VvYFkvltK+m36B/Ov5nF1BnwkSWYf+shzy0WWqh7yNY/5WmEnxcVL1CJkM+ewNzUORU3uxe0B3/rtgl0uLl9q20oJ84a2s4vSiatyI//Qkv/r4uwOXNdm5bTWD7cULeKK1ne5c2kexdLjex6/lZ/fw5XaW/xgja16sAqco6VgUf6frE3GfFF1oyHLK1RvDz5WxKk3SzQVhSlSu/XdbiIerAAqAYimVnzDdTMQ9RgGgPg4SM4TbabfK711s5csnr0qsx88m9qo5H+5pyw0nmNaS826AOFhkzogIM41RLxIbZgD4/Pq2lJLw2u1WT2/uvEGiDN7uQW5Qc/lVjU1+IFuqUIW4H3ah0yyE7WeyGwfcMkb8YAs7P4n64b8TmvVcNiMTU4cJ1G8OpvvF4IMYeOrwJhOr1dcvpmhBzMmx9JaaNdKFeQ8pykc+TvWvTy4AzqxXSyZ24Hc7AAdNAVf2+YtGtTDrwtIW70YAfO9bTBxbbl40tEY73PobBRfTH+BlWPpGfAErHY1vUTuFtQ3+UbRPjQhRtylIxn085EVPYTdl3qjL1uWo8Wn8I7wBcZM7uRIjZGlWvcfueapEhZPHpwLe2pcwNo8yWxF9VJ7hNexMOkZzPe9ef/v/UHr/7lq7Swi1Ae0ATr20dXXqkqHxpy/kbCQF0KQJSZ58nrStty+3Tf8ejGrEJ0aC0dMP0rd3FY2K37uCatUckytt75nsub0mib/AhkE0homHqVXuv8d
 k1FeBdSW
 8pi1Jhz7s5GVfp+Iq6490mYCpodxs1w4FHv+li1sIsuMCVC8bN0jGlhIryIuO08nntkWBUXgG1v0dDb4iB2QMeIbzV+PEUx9fsZ8IZhHaY84u4ilC0HOg/Zwhm0mWA7et42jrZrTQwYIi6Ug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport suggested [1] how to properly use dynamically allocated
arrays during early boot.

Use this approach for reserved_mem array during early scan of the
reserved regions. Having all the reserved regions in a single array
removes the need of the two pass initialization introduced by commit
8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
regions are processed"), so implement it to make the code simpler,
easier to understand and ready for adding proper error checking.

Tested on ARM32, ARM64 and RiscV64 based boards. Arch specific issues
with early mappings were discovered by LLM.

[1] https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/


Best regards
Marek Szyprowski, PhD
Samsung R&D Institute Poland


Changelog:

v3:
- allocate the reserved_mem array only after all static regions are
  reserved or marked as no-map, so it cannot be placed inside any of
  them
- record failures of the early static reservations and print a single
  message asking to fix the device-tree
- restore conditional compilation of the early mapping code, because
  some architectures lack support for it (C-SKY & Sparc64 as reported
  by kbuild robot)
- allocate the array bottom-up, to avoid allocating from highmem, what
  might be an issue on Xtensa, C-SKY and MIPS32
- don't use the early mapping on PPC64, where the scan is done before
  early_ioremap_setup()

v2: https://lore.kernel.org/all/20261008152403.766439-1-m.szyprowski@samsung.com/
- removed superfluous ifdefs

v1: https://lore.kernel.org/all/20261008094125.3197971-1-m.szyprowski@samsung.com/
- initial version


Patch summary:

Marek Szyprowski (2):
  of: reserved_mem: group allocation helpers together
  of: reserved_mem: allocate and map the reserved_mem array early

 drivers/of/fdt.c             |   3 -
 drivers/of/of_private.h      |   2 -
 drivers/of/of_reserved_mem.c | 475 ++++++++++++++++-------------------
 3 files changed, 221 insertions(+), 259 deletions(-)

--
2.43.0

