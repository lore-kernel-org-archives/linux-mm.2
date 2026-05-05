Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B24FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 00:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0386B0088; Mon,  4 May 2026 20:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477BE6B008A; Mon,  4 May 2026 20:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38D8F6B008C; Mon,  4 May 2026 20:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 265596B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:23:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C955C1C01C1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:23:24 +0000 (UTC)
X-FDA: 84731467128.24.51B4D62
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2F320120010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:23:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=klGHshxS;
	spf=pass (imf29.hostedemail.com: domain of 3eTj5aQgKCCYUMJCYCLCIQQING.EQONKPWZ-OOMXCEM.QTI@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3eTj5aQgKCCYUMJCYCLCIQQING.EQONKPWZ-OOMXCEM.QTI@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777940603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P7hLyOAFb/XotDLSfzs07sOc8bnqFDsHZkne19sPDsE=;
	b=DVhz5DRVCWjPHjX/j1gIfrOHYtV9WsQBwy5+cYmF7yjCXTDiYdVO8zXZTj/sKAeVaUVgsK
	O0A67qk8RPoVW2uLW0ItQeONu4vrBMywiNmGXyWTWZsbtN5uMiIdcI5CTymXSIGbXyrBmp
	PA+sUDO8FeGPS+8IQpeBqsraujMGMcQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=klGHshxS;
	spf=pass (imf29.hostedemail.com: domain of 3eTj5aQgKCCYUMJCYCLCIQQING.EQONKPWZ-OOMXCEM.QTI@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3eTj5aQgKCCYUMJCYCLCIQQING.EQONKPWZ-OOMXCEM.QTI@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777940603; a=rsa-sha256;
	cv=none;
	b=noDEMv8mUOhIkuQpmBMKhegk8rkzD93ljLrxJQZ4U8GW+Hly9QPLZazM1oK5kkColJX/pn
	ZblzHD3yptZYi+T8ONtcAGvL1V3d/V+w1weEY/QcL455srXrxc8ZWyfvl1k1LZMJuGTLr3
	OV5ClSm43rseVxJoDm7ZQcoOCwOIW4g=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c802545ae0eso799498a12.2
        for <linux-mm@kvack.org>; Mon, 04 May 2026 17:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777940602; x=1778545402; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P7hLyOAFb/XotDLSfzs07sOc8bnqFDsHZkne19sPDsE=;
        b=klGHshxS63/ueXOLBhIzd+6egX4IST+Qb3Q7BdHXx0sOEMV3Z8vFlBRoU/dd2PZd+r
         IqYNMVi5o/zznH2er0hQrUczKcvkuJq2/bhj6JBvsiDqEl+OXIOp/ZtS3zGw+CxS/h/d
         mlOWNwMjfwPPG4iOxkrlI0zRBK2wRQAi9CDGobsoX5bThlvyyCoLnAwB1Icb261AM2ya
         ls/+oXCf3+KCDKsUysJesQJJWIAKrzypyE0ufnc/ZQPIjWjND0MZRhMug+KhrqDcV2pz
         /oZ/URWmCX+ga9IjQerSBzfWkLQt9IR5p+Y159HKNi2c+0KnVHCZ0wAYQrUtWHsoMn4t
         xUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777940602; x=1778545402;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P7hLyOAFb/XotDLSfzs07sOc8bnqFDsHZkne19sPDsE=;
        b=skddvwqiIpW7v35jWsuZ8uoYHagKQCKapwAYWFc+yInJmaXB+OHw8jXxCTDoPy+UaE
         IfZKakXS8Jc4c3ZhfnN0dWWTW3OcNhjfqsLfuXOW+EsTX9HCle4D93vcB6TfoxNVtGkc
         zvJ/sKy5FEYAE2QsbYiccSY5Dckod1iQCi13XRwfohiqhLsCRaH68qyX/zv+BJSpDu9E
         YlOb0B/LjKSfpEHcBjPFADsgzWxUWYCNSsClO+VpNW7+IpH0+hXkoX/h298C0Hu/WgwN
         2EZMnWeG/6ZU8SkrtFpL5/3cjSzmvFMyfVoaGIlkBB1yCN/tmPX2ufaBYBxc3dTxDF+e
         GtvQ==
X-Forwarded-Encrypted: i=1; AFNElJ+U6yD6o0p6N1nvY3NE+hRqBOsI2EAIFTSJv7mqqtnJUUVa/T9F1Sl5bb5NSjvPwtIdtAXkSWqPUw==@kvack.org
X-Gm-Message-State: AOJu0Ywy+YevrZiJXrcDgk16zHPJOfeTweiNPakKud4i+KHBA4yOAobA
	wjcmnhigp7L+eS+I+uhwPJ7MHApFcZJXsz6yi/NCZICi3bEZQdMi4dmeMRWEvZE16lTWQgxjUUM
	+64RubntIljS2Zg==
X-Received: from pfr4.prod.google.com ([2002:a05:6a00:94c4:b0:836:55e:c2f])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a15:b0:3a2:cf6d:a9f7 with SMTP id adf61e73a8af0-3aa3b75b178mr909398637.36.1777940601569;
 Mon, 04 May 2026 17:23:21 -0700 (PDT)
Date: Tue,  5 May 2026 00:23:16 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260505002320.2210067-1-skhawaja@google.com>
Subject: [RFC PATCH 0/4] dma-mapping: Add preservation of direct allocations
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2F320120010
X-Rspam-User: 
X-Stat-Signature: n85ysqgh1846p44k6ayzzeuw73uqszee
X-HE-Tag: 1777940602-592620
X-HE-Meta: U2FsdGVkX18jpyoh2S7T+f/+3wvF6G2e49eqUmUl7t3b6xBvPDAgIoSEIWwMzpOBR9S3/Pl1tD0qvRTFhv6F1C8sbQKDwbTJ5t8XhAnoLymm0RyMfpLiqc3zCVUoXzSAMg4TMoRltSRYnb4m2uhGwQAfDpr6dAmYnXjBbMQJgQVQO9XnGQ8fPO/bjRl/7pAVlbiObVAX6U5TN++NikM1fvp0I0qswKBY9gw0qm676jld7Q4T6SSweoJPzL4MV9Y709VdMyQ5jZJwGD3HwKAOoLcEkEcVn4YlUi4P84j/GGMT0tLuBZ4gR+mw1MWpmOtTpKuBu9cXckSVFrzDB4Om2wqI5OhKRLdDhP96vrADF5cPtevFiKYk7ZxtjSy3S+Gat6JY5XUoPNl5d5e8IRdlXi1GCuMMrT2CpGz16sTy9RlWn9VYm58iEU8cX+ZvfmW452fIJWQPbCsVtsRs/tpx6O1PwfwPkShNByDJbpwivUIxhQRDRo3cTUxL4In2Wk9O6fOV063zkqk62gX6iAXHqA1sG+dxz8TWqHwu4zqRK5gJwYsWAjlUqipXEKVFLlx5xzLqdTReWqSXCmJL9Cod2K0hT3WjCRSKsFxdMIZkQ3ptn78k+Dxe7fEB/iqEPX65h39UrmMDwGjT4fS9zaaRp+9Dx+9WwFMRMKowsZVXP5qn61YXJIvZQYoRfrBRpfomjN6TZAbze8vrC1jdtT0iHCBAyDLpQEjidi24CTxojCoSvqCN1Zt0rX0ZEaFujciGGbWg85FDwlye58kZtxZH3VbqXjg72HNl6YG7JbIuYgPIEZOs0TF21J7uZvh2xpw+orCASqCg/1aIuN4JyZMHuyKkxzpmjibaiOWnFDjwYFVxMild/O9MX6z818pnVKFhocNXbfV6tfZdvn8enj4tHmFSWQeAP/xGo5lp/OjkHTBfSa1izcJKAYcXjK02ArkmOkQEz7F484Sdu2JQHqe
 e+JySAqj
 mhjHNUVoqEumbdbOlffYIsHHVnHM1HLCjV/3f/c3rIUeQ+/tW26ILzj9XJqI1hE3msNyyfVBLq40mg0lbIjUj7rkVmoNP2lO5T3HcE2rXHmkyU//a2xEmANbBdIMZgrFFX+uMyAPZILkyePrSdyriaKkV7K5gt9Y0Q/vt8JWlfWOTOX+cPjPzk9VSFZsl4qI4dt/tTqGowgGetxIV/MNH6iAN68/WigMKOHfLGxPAxTP2NScrq1dA/B59mP/vHXvJe8AO2m+tbttdeTFgRn0AHeL7x46YkkkoPygFPihuzJnlfirQtq4sxSEPDBTV9YE5cKZAu65JHFykmFNhnznpRvXPP/DVFPw0jP4wOOL8zyqfsMfsK/Du+MAOcyY8C/c3sMUIQQ+CwGsRIkohmORLKehF/5lP/2aVJS+8qx+1H7dOYvtIQsJpiYkYLpxCyRF9UJ8u8kXY45fVPsjUeEI6NcidoWeGoNO2dg/tji+U1AMW1dBiKh/5t0HBJQbMhiQvlulRwKe9xcr79y9SkctoR0PPy9uWid5gXlmxeAdClPbJ0WNc1qivdQENd8EqoNGyFlnof0AYwxX2Q2u9YOhkSASpZT4Kf4ar5J9ZETfSUCuhzm3ZiSdxh4Sr8WQCJ/aT9R00R/+mBaBxijIdncQRLgRoIUE0KUgvvJLsWRAl0HgWKpmUny6YqGmWFBNcbkFy1seW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC to discuss the preservation of DMA allocations for
devices that are using direct allocation mode. Note preservation here
means preservation of physical memory only using KHO. IOVAs and IOMMU
mappings are out of scope.

The complexity and need of this was discussed in the thread mentioned
below. It was proposed to allow preservation of only a subset of
allocations with minimum support.

https://lore.kernel.org/all/aepfYzkI7NsVGCF0@google.com/
https://lore.kernel.org/all/aepRy7Gp7Ng85Zr7@willie-the-truck/

Note DMA allocation allows allocation from various allocators in various
configurations. This RFC supports preservation with,

- Direct Allocation Only.
- Pages allocated through alloc_page (Buddy allocator).
- No CMA support.
- No DMA allocators.

The changes are also pushed here:
https://github.com/samikhawaja/linux/tree/dma-alloc-preserve-direct

Looking forward to your feedback on this.

Thanks

Samiullah Khawaja (4):
  dma: Add DMA allocation preservation KHO ABI
  dma/pool: Add an API to check if DMA allocation is from pool
  dma-direct: Add API to preserve/restore allocations
  dma-mapping: Add API to preserve/restore DMA allocation

 include/linux/dma-direct.h        |  29 ++++++
 include/linux/dma-map-ops.h       |   1 +
 include/linux/dma-mapping.h       |  50 +++++++++
 include/linux/kho/abi/dma_alloc.h |  30 ++++++
 kernel/dma/Kconfig                |   3 +
 kernel/dma/direct.c               | 163 ++++++++++++++++++++++++++++++
 kernel/dma/mapping.c              |  52 ++++++++++
 kernel/dma/pool.c                 |  13 +++
 8 files changed, 341 insertions(+)
 create mode 100644 include/linux/kho/abi/dma_alloc.h


base-commit: 9974969c14031a097d6b45bcb7a06bb4aa525c40
prerequisite-patch-id: 41f13f37cb3b439f17dfa4e3f2d5c767aaef0346
-- 
2.54.0.545.g6539524ca2-goog


