Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99976CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF13E8E0005; Tue, 11 Nov 2025 08:53:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1898E0002; Tue, 11 Nov 2025 08:53:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEA88E0005; Tue, 11 Nov 2025 08:53:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCF488E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:53:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 678211A0504
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:14 +0000 (UTC)
X-FDA: 84098467908.15.8E2743A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id D31C580010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=WDMPmvxl;
	spf=none (imf30.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762869192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WlDnf+yXkm4HV4Dx0L3C5l/5M/ErgqC9PYLFtVfUOzU=;
	b=VsfPuFxukKn9tUeHpkrtbd8Y431Ndq1vBvg8blVP8075SdiRCUHpJeqjLbU4vpwlx59M7F
	+UF0tw0WikBTAqNmL8GlhYtb+SZuaBfJc3h48476/Z7eEZfCWzHivobQVqkp+3JJBusAaF
	55G/Ln8i06Zrqu8yygCCrgs+qV3irK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762869192; a=rsa-sha256;
	cv=none;
	b=d7gtkX7QHO8tt10hUiFGU4bk1gu5pp/eVzUyLHhU8ObO6ng96awNCsWTUEXerk1A2AjOgd
	S2+JCUO6AmIhrEftf0SdHEWb081/Qb2wD023HAc43jN4/odoKvFsazm45+hAe/hTU9IXZ2
	N/L2z2lFajPUUqEHrvYA/Pwr27UWJ6M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=WDMPmvxl;
	spf=none (imf30.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WlDnf+yXkm4HV4Dx0L3C5l/5M/ErgqC9PYLFtVfUOzU=; b=WDMPmvxloX1cwff6FsaJyKMeiH
	ME3Tg9ixCE5HoHOOWXC30J9R/5MTVjc4XA7D7TGQiQR1hto/IfY/kTVenGIP4ucX1ikfUUce7gK85
	ksrWLkGbmLvdG8el9I3dQHjkrlLthAFsRs0xwK7zRQowd1ZhWh21fjmcycGuk9iyhbIlMDn68fw7W
	uabiMzmtvJDHzhSaR5TAj8lZHMM5St7qlmNOP5GBhGa2x6pcOsQO/oMV1GTcILr6lKX/MdVKsxtu+
	iW/5agHfD2JzRJ7ekEuymoLpEgUgbAUSofdJOSJSf84936oHhqsscJhckM6QLNW6v1pkbDgLZp7PM
	t4oXgEpA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIony-00000007GX5-0ysl;
	Tue, 11 Nov 2025 13:53:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: mempool_alloc_bulk and various mempool improvements
Date: Tue, 11 Nov 2025 14:52:28 +0100
Message-ID: <20251111135300.752962-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D31C580010
X-Stat-Signature: r3h5otz683bzyowo8ogqpsznq8f6uhbq
X-Rspam-User: 
X-HE-Tag: 1762869191-694571
X-HE-Meta: U2FsdGVkX1/XMMTcrupOTRvBNYy+EEPEjn9bEwacv8q28pmutBIAlLLuyJXh+GYMkd4DSXgLlDijcMy1LBW4xWSWzrpI/ENN9GYL8AP6IiFRPOAaToZSvsvaGCNv7umI39RxPaah9jPgCAzlsFdxVPfyuS0cXLrRs7PppsKpDxO4WHzl/QpWB9M5kVv3x770b23etVvWJ1LVZZpxB1wzxA6VgoC35O4omkNncD1lyv8Kk3uGe5QJy+cDQdusQvk0+YobpVQOoOsCnmJBi1nk96FjCt7Z2aaVpz2MpI2dZ1h7C4WxsGgTkTTfDge5eodAjRiisOYbVCQf7+/qCXNcrXLPfniGBnlm1no0AaFq6XlwjCBOJ+MRk8YWS+9VCsZhqMnJQcIl7KX6YuLF+Ni7qUVbeUFBIlF/PAw6HOAKx79iopizMrGQCcJxwmL2zJEVLnnZ/bzEpJeEEoV+suauHnX35Tl4l37PNRvP3UcQtT1EBgoi5tK/EnDl1F7sycTcvQc6f4jMSSVdimWEjO03DdsQUk3pDCyy9kUAC0Ubt+oyDKJFmvLRg6m5nSb4y/kDRRWWdB7vsrw6B4618KfQjHSzHLfRAFSFQKUAb9UPpc8nObcU1Tbkor8FXzScdZ2g//Qz5eEGDIo+PXOi/OdWaOCLL/kj2+VWA71yNnjUMdJLO6YXQwGossYSlhkig14TswtkqwoRuA2EKtBaRjfML2yIyK8j4IKM6+SaHEutq9sI8Jy3Ltfrqqv5xCTxwZEbqp6MqWJiYw1Ez/KQ5nt6bFL6WgkcefZ4YiyCd7GwP4z+a1rTqU9M39R1mCmRj8ZL8VYEaOjTfgnjjOY0GdwQAs3adGQpaRRe5WUCMMCKTHJ5dlCvUkYyvrMFjMoHQ79OaY6RzLNxnxjopwFCWoSncyL3l0NdIdNRQdULso0X0mmieiiMzW52ayQr6OX7wpvEZDDWurT9kce/qQx/DG4
 iUMuTUlZ
 vQGoviTqJpttx0Q94ZR8xCkTGYcnEEDR6fbI3413WCXJeI12ZjpJkvIsojXRs5aTdeURFGo8FzRobdvGE7pxFmwQgJstGjAxlA8A6FnvZKOM5Jq6rmqnFnpS7Yu1bF3ICZDTPWsFIe34Oy0YC/gytdNgPE8yCZ/R5YUBX+S0bEJMRdQC4Ffj84Zk3t+l+sHYLywl6gU9PqvJdwgZP02VDQ2tXeZ8SBY8AtMTj2WbsPcRBT+s1Xjif6vXf+LlJI4s024lxtj0q0FF+e3MvdpWgmIXTiYPT1tub6REjrKIBfZciUBjqSbXBxf477fcgi9ZatvNyaVFhCtNDLXiZ18GYiAOwnW+WiKeA65WgHdg/3qlI/pXZXHvPCQyVAUwSH9b1bhEJ/0ahbcEG4THhSs3ioSVK+hbRECKDm2QuiVVbQbTCOQhIpK40x+QoEFNmOxdBP1wbPsHUWGeBW0Ut4kgP/o63C7tFdLdVOORttnihcai7/X+vsT40UhCjZ//AcdMVjgy/MM9qKex/c0fbKDI2nLf6hZnfdQ4prHO869J7Y7COj2/fMn0+bcPS2/aHCKDwfTw6cJ72pbYDQdvCI11JKilePBmQTK/O226LeBmE9RRwLQrbsOz7OGbZWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this series adds a bulk version of mempool_alloc that makes allocating
multiple objects deadlock safe.

The initial users is the blk-crypto-fallback code:

  https://lore.kernel.org/linux-block/20251031093517.1603379-1-hch@lst.de/

with which v1 was posted, but I also have a few other users in mind.

Changes since v1:
 - fix build for !CONFIG_FAULT_INJECTION
 - improve the kerneldoc comments further
 - refactor the code so that the mempool_alloc fastpath does not
   have to deal with arrays
 - don't support !__GFP_DIRECT_RECLAIM for bulk allocations
 - do poll allocations even if not all elements are available
 - s/elem/elems/
 - use a separate failure injection know for the bulk allocator

diffstat:
 include/linux/fault-inject.h |    8 -
 include/linux/mempool.h      |    7 
 mm/mempool.c                 |  341 ++++++++++++++++++++++++++++---------------
 3 files changed, 240 insertions(+), 116 deletions(-)

