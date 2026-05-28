Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B38C4CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957DE6B0005; Thu, 28 May 2026 05:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9089D6B0088; Thu, 28 May 2026 05:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81EC06B008A; Thu, 28 May 2026 05:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 713976B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:34:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 021C6140760
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:34:48 +0000 (UTC)
X-FDA: 84816319098.09.FCBC305
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id E4F2F40002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:34:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oyDjwN+b;
	spf=none (imf07.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779960887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pANoFNUJ5rscT7uP3oM15kc+SWL0V877H/uU38vShj8=;
	b=SZEoCL86QKOvlyGR0S5KeP07yrvdmT1I9uYxkiJeHLjNZIgr1rCv2nlHrfjyTi2XfjUSQJ
	yD6Co1y7OoudylSB0bEqLUH60g69Dj9CmOTbbBtBSDHz08WVDiOODrltkYlvjkwaPfMMxl
	WL5MFJ32u1ED+pKlKKhBhxEkz2mSTlg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=oyDjwN+b;
	spf=none (imf07.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779960887; a=rsa-sha256;
	cv=none;
	b=GotvEDFSmfMQTmTnJrOToxSHMxUhcJ50DJ+U6zTyB62ByLDRI8/ya+hoeYnS/k81VmfCMZ
	m1kxzoMDMi6umBh5fKmVAVaQD7hwX1Xaqw5EW72JaACr8HVMWsV0tw6tw9YWZjeTp2GnNN
	D/lVUOsah8StCnV23wkVLV+L7rlrUZo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=pANoFNUJ5rscT7uP3oM15kc+SWL0V877H/uU38vShj8=; b=oyDjwN+bRgj0+TJOVnay73cV9D
	EdCnPBP+0/iqe+9u31JmicYPVunHjl+Rju0ohWrtjx6+rD7pZ5Ucia9QYCO4Hj8PYmBHq0e9eo79s
	0XAdIBoH7hgdIq/vnPP/a5EsKpJFIGrwQ5ssGRAUeCSN4Fj7GICvux7IzZQpQi2QyR6OCaJh6LspY
	TWU+f3+5NE0DuoH2oK6AbH89l4bXiyZWK2cKyPWuREQvEyPk7kXIsQA6Nnkvf0+HVudWa6KpfD48F
	PNxPUFVNUUisTA2Ox6ywtXDv+N9L20lhFWLSJLAIAdtgG1/JH2PFeeO9nIMdGAsi6wwssmCNomaSx
	0UdY/vtg==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSX8U-00000005WDo-3pQ8;
	Thu, 28 May 2026 09:34:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org
Subject: improve the kmem_cache_alloc_bulk API v2
Date: Thu, 28 May 2026 11:34:31 +0200
Message-ID: <20260528093437.2519248-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4F2F40002
X-Stat-Signature: gzn3jniszr7c4nupnkfw14kcctkb6gda
X-HE-Tag: 1779960886-869198
X-HE-Meta: U2FsdGVkX1+x13w91Y9sZr9UvXzKYdf1dTwFtQIhlGX7jZQMeFTDCAff6F8v85qMJ9K7U6QQP/slfz/WAga0Bzj3TPJK0gRgQsVfjZ26A7RlI8T9GaAC4m+ZtYGQCN6V61u7gwTX0SmakAjEvy6XI6sHVfMOKQkqCEvVBqs3u+sCwhNwisUauCU/tfjfJ1OEA9WEH/lWi9QiC1BrReNNy1Sg9wuOPah8dEU/8yToIW4TKugs+FzJ7NSczdgk122NVPk0DjBjj/PWRuD/nVVJUckUAIERWjlUDGwSpDyPCaoTJ7EQTD/P+3W9lBRRK6ed0K5OCqOitZedkHSN/9WKwYngNX4Waj4iq6DcJ8+MlYmVhwMxYclYHunqAlcS59sNi9AO3JZWmh5RLKo3/gxJ6fiTU4wIvqmIYPWUwUGT967M7nPWV1iZVo3qkLxbLcjqGYNaq9gJ6ryoZORcOUo1A5CeEQXMlzC08NJKdcadSfIAiXCjh2Tp4mlV4pEZoiVVzfIfvQNI8bJ5h2FhPiv6RC7FtTiOZ3nYSn1lr93dYM1VKhNdJBLQVUuEvCwrHIQUrQVRvulpkK5bhU0OYqC0Byp+7eKTEz2E0MvtAR2s1U4KNJUqSHT1bYZn7ge+3ljP+uVsFi96hdW8ZxaOWHXppx47CSmvkeG/fxJ0vgRVp4MAsv7z2Sv3NAnun0Tuf9EtsPTBpHxPDsWvdu8PQflNqrZckca/acvTgQ0JwQiXSi0xz1Pcs//CPa4w4zQ3/lmZvn3GNnlrvsass/wrXzbrDLqfXGS5pzXQUuSaP8bJAFGciKkaRgDKWeGYPJllx9eVaaWk9sMpGHbkvuB5MJlfSnF0+AQRj2CMILClyDMb+hzflbViwfL4Ra3QObxyCADO/PbbWN0uAzCBcRmmWjQ6Ptag68kO+inFm2JKdustuFZb855adjOLzPbmmCoS2If7yzM3IzgB02/A6dndEYt
 4amPcUH9
 CfAe8Ao9q0XlO9CyA6m7nHyFr+ebYCpe6hQN5fpKziWyotFS1zvXFbtKyRe/mgBtl5dAmWSI0HwsFE8SbBgkY1Qf/Wh0X5ZWWkAzdYWc7Ek+ZvynK89DsQeoAYKyFTBGiwfQb6S99M6n2Dc+u2+tMS3TWmKHjDYqH5vifiopU7ZA8LUlZ9DBOlHIxUegv0aLXJDhEn0BqkAZ40ww5BDL6DhIx/NIA9ykZPKkiI3NNaVuLMHdIe52TwjnOSrKRpA8GRpF1lG8JyWZUX5x79G60+7YQQLcvMximkSF1BBju5iAbzx/dUBUC3519MkQ3Swg7cdaR6JaqsN0tOiV5K5MWiMyFcneuFGVhSsAJaE84/8hC3bZQQt52SJZmuREaJYaF75BghAzpYoK/2nqSovwNyOWqr2J4aUPk/lArO03JDI8ok6r/W6K1rdMPvr3rYeLDCcvNeBPQHK7kzdJKdwwXhynei9lm3L0atHycpSTiGLQC+Dfvs2DtATKCnDVaezmim+d/ExXuWcJD3GhsrV9JxxUP52m66lBhnLUu+8jnRRcBB++TG5WIzclEiroN0lEW8PdtbxghXjC/vZZTCPHBUMj+HtGmSL3zewhF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

kmem_cache_alloc_bulk has a very unintuitive and undocumented return
value convention.  Fix that and add documentation.

Changes since v1:
 - fix compile in drm and test_meminit
 - document that 0-sized allocations fail

Diffstat:
 drivers/gpu/drm/msm/msm_iommu.c       |    6 +--
 drivers/gpu/drm/panthor/panthor_mmu.c |   13 +++----
 include/linux/slab.h                  |    6 ++-
 io_uring/io_uring.c                   |   23 +++++--------
 lib/test_meminit.c                    |   23 ++++++-------
 mm/kasan/kasan_test_c.c               |    5 +-
 mm/kfence/kfence_test.c               |    9 ++---
 mm/slub.c                             |   59 +++++++++++++++++++---------------
 net/bpf/test_run.c                    |    7 +---
 net/core/skbuff.c                     |   24 +++++++------
 tools/include/linux/slab.h            |    2 -
 tools/testing/shared/linux.c          |   19 ++++------
 12 files changed, 97 insertions(+), 99 deletions(-)

