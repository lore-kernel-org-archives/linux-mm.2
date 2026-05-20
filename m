Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35DB3CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211386B008C; Wed, 20 May 2026 06:19:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9436B0095; Wed, 20 May 2026 06:19:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100276B0096; Wed, 20 May 2026 06:19:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAC116B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:19:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B24ED1401DB
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:14 +0000 (UTC)
X-FDA: 84787400628.05.D37408D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C5F7180010
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=TqmLjHTT;
	spf=pass (imf16.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779272353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cIUPCew6mQzUD6Ph4xpmn+i5FaQUMTux+sdvb39UKTw=;
	b=YgR0GMXPUrwGfgWJI1YBB8X/xneJodaYGzinTcNOChJ6QD+TsYwlfkbDbZM6IwMWqxQ5OB
	jd5F4BRj5EhIVbk8M1b0j0iw810++ea/G7LiYAIsAB7qA/Va71YrcO6jg3TCj8ahZhRsEu
	siGKhG5z57JnnOQMf6QYba5HTjL6e/I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=TqmLjHTT;
	spf=pass (imf16.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779272353; a=rsa-sha256;
	cv=none;
	b=G3UIXC90Z7zBapQm3c2fJqUGsNWqBKfgcOS8cWsBKOO/9ZDJuuuxIxMlz9Sq0q/BwM9Fwa
	iOVhhu2O6oHL8X73bTb7Kwas1SbB0s4bUS7As8zFXZ/Q4W57T231dka2lx0pxd7i0YAxn2
	V2RVwzAoOiMEqpVyms4h++CsYFfMgEU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=cI
	UPCew6mQzUD6Ph4xpmn+i5FaQUMTux+sdvb39UKTw=; b=TqmLjHTTAk1/HjRCvH
	33x3kviaHSPjmPKeON4XnoRA8HscZG65ZRpq0YtNHIJi49X3C0tMVvz/dxBWel/f
	KjsloJO1oBCL7KaomlKTe2I/N5uuPPCN6F4aLwy9QtKcS8nYTR5yAG1h4y8wh/f2
	pEFmQdHbYEvTImKBRt82QKVvI=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXbbprig1qQK31EQ--.641S2;
	Wed, 20 May 2026 18:18:22 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v1 0/5] mm/shmem: optimize read with reduced xarray lookups and folio batching
Date: Wed, 20 May 2026 18:15:33 +0800
Message-ID: <20260520101538.58745-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXbbprig1qQK31EQ--.641S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur1UtFWrCFW7CrWxJrWfAFb_yoW8Kr13pr
	nxGF93CrykJ3yfJr93Gw4jqFyrXr18JF1xJr1xKFy8Xr1Fyr4jyF1xXryrXrWUCr9rZr1U
	JrW7JwnFkw1UGrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j-nYrUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3BCcOmoNinBzpQAA3h
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C5F7180010
X-Stat-Signature: kocbxz7j8ebhonyqfgyhszyays9og1ny
X-HE-Tag: 1779272351-800604
X-HE-Meta: U2FsdGVkX18AnljZFQPbuJeB3PWCmp/+tOBqYb2J4v/j5PUjVEFJw77GuB5f6IU5YjzJa8/29ewOCx7j7wlJOddBTvdVJLoCkmin3tVDwRFyKnCA3UCSZdfDONASzbCIHEAaXtToSdi9t38VXIL1Pptgu6YCsDwu5PBpmtJRGrlt7iIR0vqNDKCFUqc2SeoC0/d16dKKnHsxZgbkq5f3Q2rcdeVPJpOgU17MSpwCGBzVC6pa3KWhsPX6ydHDrzcs9doHNLd0h7BmEtu8zLZJZn3h/gRTLtDozCufm+Jt6meAHG0f1Mke4Zmf/OX0WXMFkTUZIaWrzkU3Vi0A5AhWJuokEnp2sbv0pFDY4i3PfhcccgEqRziLGjrcsX1pswhxb+I7orJNqImEhWYQx70yEKOQtEcAwtdzOHiUcSJXnVWhVoQN48HgjB7w24p8vM1iTuQy1lhrM7JCrRyjUdMWhAJFoKX3VjR42lF1VhMImtnd5v0IvFI7tkiwLQ1LzZA3lR1FmX7Oh0/EUoG6IVX3vOeVx2fqu5WxZjFyNvUek/AYbLmJEPpRQVdLXXjJnUPDRw5cMZ6U+l2GhkapU2rEuDspZ4sQynrEs+rUkAinii1kX8fOpC2gm9SDPzzHmA0ZQIwohZJWkmMlPMEsZw52EK/FTH4XwfXvOHgek+tBWmXU7QDCiXohAYUfRMImw4y57rc8qJRmtFQc0oUnpyE72NnwPEBguDrIBqJ8kZD0LYW6pv7eL6/ptbGviZKSHeRE/0Wwkps75m5ckpEjl/TS1/raPgQR9SG1bkdasDXN6ptRMj8ocauvBOLwh03CCUvyqQBllYuKfWt8HyhYMJOZh5MXrUdl718wCqFNYhCYEyv17moWWF1P9AWCymSjdRUID5yJvibjQNPXvTYZnnaQ8Ffn9rRXSbWMbwx7x51bJ0X8r75gclVZehsBtporp6pr03zaw4wGuGw/wdMJZKK
 CG/T+u4f
 uTPP707Ome5R/UFeHUR1LCTgw61D4jkhBPr+5Bu0Nga+jBKAoqRBLZbVxI1a/WELsACZH2y6I9H17fF2SKw0UPJvp60PcGxcGs7lCWa29rRXmGfhcJfTni01H3R+kV4N3HJ5g2vzKXAHkYkTp441gH7N2/nsd7LuBRaNHd3sadB66cr5RJIp/c720nRRL4VyDqiitJpPSwd9NSzQEKko1FujA6A9UloILO78ELnlnJjDreqtt+DwPt1WFQG5nzwCveUlJaTqXM/asdNPqjaxEbciNrqVDAUVtsUSGb5gfDRxN3/+SmrFRSmKZeQU8xro+WLOGsz+oGPeiGeyFaaO+fn53x6Nl3aNYKRngdKwNDgP8mjFCqONnEwQ5hIySDxjFj9ME
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

This series improves shmem read performance by implementing folio
batching in the read path and reducing unnecessary xarray lookups.


Changes since RFC
=================

The RFC version used xas_for_each() in shmem_get_read_batch(), which
introduced about a 1% regression for 4K read workloads.

This v1 addresses the regression in patch 2 by switching to
filemap_get_folios_contig() and optimizing it to avoid the extra
xarray traversal overhead.


Performance Results
===================

Testing was performed with fio sequential read workloads:

  fio --ioengine=sync --rw=read --size=1G --runtime=180


### THP Disabled - Normal Files ###

| Block Size | Baseline  | v1        | Improvement |
| ---------- | --------- | --------- | ----------- |
| 1M         | 11.4GiB/s | 12.7GiB/s | +11.4%      |
| 64k        | 11.2GiB/s | 12.2GiB/s | +8.9%       |
| 4k         | 3809MiB/s | 3838MiB/s | +0.8%       |

### THP Disabled - Fallocated Files ###

| Block Size | Baseline  | v1        | Improvement |
| ---------- | --------- | --------- | ----------- |
| 1M         | 23.7GiB/s | 28.7GiB/s | +21.1%      |
| 64k        | 22.6GiB/s | 27.0GiB/s | +19.5%      |
| 4k         | 4668MiB/s | 4678MiB/s | +0.2%       |

### THP Enabled - Normal Files ###

| Block Size | Baseline  | v1        | Improvement |
| ---------- | --------- | --------- | ----------- |
| 1M         | 13.9GiB/s | 13.9GiB/s | 0%          |
| 64k        | 13.4GiB/s | 13.4GiB/s | 0%          |
| 4k         | 3818MiB/s | 3836MiB/s | +0.5%       |

### THP Enabled - Fallocated Files ###

| Block Size | Baseline  | v1        | Improvement |
| ---------- | --------- | --------- | ----------- |
| 1M         | 24.1GiB/s | 34.9GiB/s | +44.8%      |
| 64k        | 22.9GiB/s | 31.3GiB/s | +36.7%      |
| 4k         | 4721MiB/s | 4708MiB/s | -0.3%       |


rfc:
https://lore.kernel.org/linux-fsdevel/20260515094702.1092355-1-chizhiling@163.com/


Chi Zhiling (5):
  mm/filemap: reduce unnecessary xarray lookups when read cached pages
  mm/filemap: reduce xarray lookups in filemap_get_folios_contig()
  mm/shmem: make SGP_NOALLOC succeed on hole like SGP_READ
  mm/shmem: introduce copy_zero_to_iter() for large zeroing
  mm/shmem: optimize file read with folio batching

 include/linux/shmem_fs.h |  2 +-
 mm/filemap.c             | 34 ++++++++++++------
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               | 75 +++++++++++++++++++++++++++++-----------
 4 files changed, 79 insertions(+), 34 deletions(-)

-- 
2.43.0


