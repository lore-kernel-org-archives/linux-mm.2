Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E2FCFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 00:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C994E6B0008; Mon, 24 Nov 2025 19:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70A46B002C; Mon, 24 Nov 2025 19:57:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD626B002D; Mon, 24 Nov 2025 19:57:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A76CB6B0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:57:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A58614064C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:57:08 +0000 (UTC)
X-FDA: 84147315336.21.F9DCAB3
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6EF8112000B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 00:57:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cyQ4amxC;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764032226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eQOzOdTt+5ga5DERa19IdsHmZ9YtEuF1FLhAp11XwR8=;
	b=OwXQwOeGAs3L34DifZIMIAqKh4SXNzcPUa29s3xXu66t+gnNJWMWQ0Xlqar5PSTibB/v5F
	TFvUorABJ0MJLH1gvgH4fwAMwqLLiOM4dxFUj0NTMhcIL6Tx1t82N/Qd1So2m998Tqmmri
	yfnf5/baQbX+I/Cntd1zbWjvRsyLtNU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764032226; a=rsa-sha256;
	cv=none;
	b=72T8u1LqiPpS+7j0Xj/VAEEq0uFwdLKWJfy25xohTqWMz145+5AdKkGMIfa0yNMANjqWoT
	S1YK2+8oUV0an0kBE46kIcXMy4t5VjBFjoggJ9nZVlamHpKlrv5JnMOuCq/Ar9RUptq7Wp
	zUxDHv6Qa+KKB5OYPfJp6f0i8g/lMCk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cyQ4amxC;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764032219; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=eQOzOdTt+5ga5DERa19IdsHmZ9YtEuF1FLhAp11XwR8=;
	b=cyQ4amxCgKuWo1VSMPU31DlSDqi/su95o+WYEJ9tWlIBCZnDFvDR8CD4OPdEUydS0Pp6WxnJc163ULAdPBh4rXYCu7Ni7qCm8cCk5pVaYrVuU8F/XS4VTy4ed3/Y0gXajBp5IHOasyIBWdlVBqj9DIiLyzzp5WVnTjFpTd5jh3c=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WtL7S5r_1764032217 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Nov 2025 08:56:58 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] support batched checks of the references for large folios
Date: Tue, 25 Nov 2025 08:56:49 +0800
Message-ID: <cover.1763976541.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ajscgo683wsn45cexicaray8qx5zjzry
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EF8112000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1764032224-656304
X-HE-Meta: U2FsdGVkX1/ExbTJ7TESLxy9OBznM+d/yNtisMkp8jaBGQmQ3hqhq6w9Qgd4x4CTQXMPo+VEnwzYSJ4xHtYPMrnUR/uhhICu2P2OGNx4GQf/nYI8SJwjQCji3ysyrDtoOGzy5olY0lVgkL734p+sPTqmbpO/wDSlwzkpyHUkqSu9qIGNqNbOg+7bCKTN1DfxHnLvWXGO8WpuW18a4TFZqZR0m1YZBHguplYSGZarFSI5aJEEJubq1dPkTlGrktRpg9B1FWlpQnJcTseT+lBgX05lSSRI1PO3F8+20TETEpB/2rqPPBXsQiHvevuiXxy5D/vm7FGUxBRP1cBpYI23kUxFdq/eNvak8+UyM+aEJrHgtVzeW7CgoPYA6q0niM1GyOhz14K5fvR+DhgFVjXLTlLuIDxWdxUjLkRo+UE8TK88vi9NuG4135zqhpOqSwkc9YAvnb3P4PdGc4VBmcgv+//n+a2RPX+lJeMaOhZ3SfHHYtl/dNslybugp2aZ3XbG1qx286+EiFIM7uoJSMBUwWx2WYsC+YoTMNHoFQ0hxSfqTlRpC48+UNCUltNFf5e9REPx+29ARAqvldw6Mu37lz451R1IKZ4f2vxG8PVXJ0kflCFEQKBK+vapqMsTXI0lFea+grrbwwqCbSmCSTz3Ce7NXX4ivLDKKvDBemz0YPqhFnjeg7n4JId4iv3FwJ3H1Bd9oNm9SyI0dmymZILoK6CesavF8hGnDOBYDLZ5VVGtrdr4PvQSgpeQ8Xp8Dw/yuywKyAwFrE6uBdP8IiCoyeC64Bjmpv3lHKKVgycT/NUntnSH6hrmAz5SsLkCzb/m/w3SlTXBzjVHV3KldmF5hO0cIlVqXSHYkDcBzBGB5xE+O2jRlT9hwPKN0LjXbXy9041F4ogZU2DwwPnpGPywy+iLmqEfkQgmI5xrmdLZ6q/tMhPFeR48m54mGShOdMUzVwt6KPW4O7UR8uj7HsW
 oO1mXvEX
 uZ9rvxKN5YK7ABn94Sy/a9JIZ028N92WXNkDZ01B0vUU9IdSsSS8aGsDKSvXb2fM3CW1wjtTchA/z0xvyb4n2AdxAYBdky/I208Orjs9cnIxXYDPY6PR2fKubkUFBKcpHRXDDBdq0dyH0JbaU5/0a/ZaCDPMQMhBMRA1QK7acJQCahj+XBZT8/ccBV3AdbrINrPVcgZxx3/uu0Ntg5SGSCjG5u3mugTQTI0w8d8WMF7+Gb+aFdCgNuFGjLsCXz3scA2VIFaKIq2N2CypBZyNDuboQP8FRSYK7XW0+LqHyW45yb7m6YMrhlDMK9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_referenced_one() always checks the young flag for each PTE
sequentially, which is inefficient for large folios. This inefficiency is
especially noticeable when reclaiming clean file-backed large folios, where
folio_referenced() is observed as a significant performance hotspot.

Moreover, on Arm architecture, which supports contiguous PTEs, there is already
an optimization to clear the young flags for PTEs within a contiguous range.
However, this is not sufficient. We can extend this to perform batched operations
for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).

By supporting batched checking of the young flags and flushing TLB entries,
I observed a 33% performance improvement in my file-backed folios reclaim tests.

BTW, I still noticed a hotspot in try_to_unmap() in my test. Hope Barry can
resend the optimization patch for try_to_unmap() [1].

[1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/

Baolin Wang (2):
  arm64: mm: support batch clearing of the young flag for large folios
  mm: rmap: support batched checks of the references for large folios

 arch/arm64/include/asm/pgtable.h | 23 ++++++++++++-----
 arch/arm64/mm/contpte.c          | 44 ++++++++++++++++++++++----------
 include/linux/mmu_notifier.h     |  9 ++++---
 include/linux/pgtable.h          | 19 ++++++++++++++
 mm/rmap.c                        | 22 ++++++++++++++--
 5 files changed, 92 insertions(+), 25 deletions(-)

-- 
2.47.3


