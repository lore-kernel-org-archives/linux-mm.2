Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6908CCCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611B86B01B1; Mon, 19 Oct 2026 07:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9A06B01B3; Mon, 19 Oct 2026 07:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5001C6B01F0; Mon, 19 Oct 2026 07:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2283F6B01B1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:34:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2607A1A06ED
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:34:42 +0000 (UTC)
X-FDA: 85339168404.07.304624A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6F59B40009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:34:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lY7WfC2T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792409680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/PpZGZPJ3n/ymi2WTzoPbdnIq+2PhZxNpI8dtpF/DJA=;
	b=6GPG4/CXQfDs1LFYWuz4c/VfaoBxiJv/3wAavXQFSjxMY5ocOftdY+ku1Zefl0MuVb2HRz
	sJwGGoLD1aOPYmmUIIKdYthNRK4t+QtGXGe3c7LaoipjgZ7AYv3bWk3TO0+/nzKZQ7CQ24
	I2J6kUJT1aTKjLY637AB855qXrzOoOI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lY7WfC2T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792409680;
	b=0/FRAT4suFxHGEWtbxLlvkd88HcLe2FtpPZoHJUtsJzClMl42A3CFZnKwRdosQm++AEg5w
	6wLc3lKbd+ma0zbtd0HmuK+qV19fE+WPPoitspuPN/5mVyrFU4XqGssgcFbK84sIFjyVN6
	FSbOTIZ2VNEZ12z/a5POjvVMwyNhRag=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D4C64075A;
	Mon, 19 Oct 2026 11:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89AB1F000C4;
	Mon, 19 Oct 2026 11:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792409679;
	bh=/PpZGZPJ3n/ymi2WTzoPbdnIq+2PhZxNpI8dtpF/DJA=;
	h=From:Date:Subject:To:Cc;
	b=lY7WfC2TZNf2rLbukcix8p8xAR82SZ1Ejn3IkvHu7F0iBuVb1DZSA0Pg7Ea4MZG8+
	 FEx2gudzyUhweuf+RczZLwndkLq3DXDE0aW3+2MJ5fAKWHgBQgeR3o/aMQe7ZkYLwi
	 7l70juBpTgXGqZlsRBm/6hPtjG2bpcZG69GrsP8Ra5V1Z683Jka+4AgOwWJI5HCaDY
	 3kUQpQd+1q1vjXv7DRNnTnlS74DPb+4+CuC6NVImT9O8v1/5y/QGD4N35QUuhRhxVq
	 WH8+i4CfIq5eMCIEwTrdIY2n3HkQEipDRwHH5W/2rM4QPEHJi25tMDuMAY+zqhe+zZ
	 NSYDCFwcbCC0g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 19 Oct 2026 14:34:26 +0300
Subject: [PATCH] MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY
 MAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-memmap-maint-v1-1-80850871d0cc@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQ6CMBBFr0JmbSNtBKJXMSymdYAxaSEz1ZgQ7
 m6ry/fz39tBSZgUbs0OQm9WXlMBe2ogLJhmMvwoDK51vW3t1USKETcTkVM2g5sodBfqh85BUTa
 hiT+/3H38s778k0KujfrwqGS8YApLnVbhmdM5omYSOI4vOLsRVZAAAAA=
X-Change-ID: 20261019-memmap-maint-72fec54e6752
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: 6F59B40009
X-Stat-Signature: suebsef88ffjnzagcmrgn397dy3as7w3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792409680-429558
X-HE-Meta: U2FsdGVkX18fMXbq475zI+fzVX/BOIu2jkZrjR6RePluMiZxNgzGmWEdMVLy69IUspgBxEiCS1g8ZthgVVwvCenGCDVnjuAwn0vLhlk7LE9ZgZyfSMY7X4dXrRNUJs5hoxctUDomuEPlRHQnV4ciIBYdNO+taC4Qj/SG/DP4GhzOCy4UeviNxvIs7PnXUdS2JQFoWgdnYlIB6rl09a32l79GGi4aEbDUeHgnH1Zw/0KrRnZ0R6UmAsT+AZgZMnFs9OzswlF1bCdm53L4E9nST7vl6dMqHw4bsYoRWfKm12bQsWWPGYxqur2qfMoichUn/pBnB4FX+yc7VOtQeKogE9YrlMy732cnh0OLfdIoTkm5NZgUrqOxw/UpA2YxrEHYY0txN4+CQ2wWo9fJpat7CLuWeHA6FNnGRB/b4XNSjBHEYb0JOk8QsmHXEz1RYZOm01fNdjtesulZA8+FMO2ch0Gdb8yegGCVJx17UBAiWJbDI1SxJr8GfceKijB3BUa3rSQLrr1aOGlT6pAnpZfX3NzIEcvIugSfN1Jqx1qDczGiL0SdDtCKWZgjcbz/1NfcBxomImCC5CHXkxooomeoQHc1EXQqlv5w5Fl/QilL3Ogwxpk15R7fQgX8qmaN51Z8pDbn413qTNxu1SPiXZErJemRqqCD3jBuSS1302WcCRQZapsyPssVq31J3Ij1M+hISapefiRQlKenNJwvq+64m5x3UfJ/lkLi+CwK1s6DsfyzQtr4FebIaKhvDNYv+8JxbjhPCcGcARMmTiCnsA8CdvcAruQSBc3Cf0AukvTbUDNlOPrzYQhQYo3qdLQ/PXIBpsixMzdLo/iPE5bxB2XqugjW/vmFgxLDgnqzJAPu0cGJhTaPichxI1uXOjbVRsgtIjoW7N2dU4itDq3kZ8lxFGdFPAgKXRiGJTCAGxEV5okKnPesbpATcr0lbW0x92IUz0ZBwz1+yLny1aixGKs
 eGjl1xQJ
 zQjKeBreM2A83mUEhBlmle6JbynHR+A4OYiNnMoy8r6lT70TUHroywS+kSjL3yPvkuHVhuQJI1ha0nrEVMckaxvVKwGHr6hbfBoZ6g+cEzcgGRydHt6NYRpc3CWbOn+WSYdpoSaeYa02e3CZHngf7RKmzIRMCUSkcB6cLAkFEk8L75LFfLbG0dMhURlrbbtw6r39UyHpAfwbAnq5O692UWRp+cBq4TIZRMWlOb3lLES+Ab5MNOrxc4xw1u21E2yy4VNjjCa2AfI7PHNxlYKVRi0qve8wj+15pin2McvDVk7snY88hFxYBmLpkqzXJVPg4x83l4V2QKZU1rqHeDC/oZA75+dP9b5dWzt2k1gcz1DbmTQbX428RXHkJNzzWCDbsPMFy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split out files related to SPARSE and SPARSE_VMEMMAP management from
MEMORY MANAGEMENT - CORE into a dedicated entry.

Also include architecture specific sparsemem.h headers, pfn_to_page() and
page_to_pfn() conversions and Documentation/mm/memory-model.rst.

Muchun, who did a lot of work cleaning up SPARSE_VMEMMAP and extending
vmemmap optimization, volunteered to help with the maintenance.

David and I will continue to look after that part of the mm subsystem.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f53047aa8d3c..b468ecdf8c65 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17161,9 +17161,6 @@ F:	mm/mmzone.c
 F:	mm/pagewalk.c
 F:	mm/pgtable-generic.c
 F:	mm/ptdump.c
-F:	mm/sparse-vmemmap.c
-F:	mm/sparse.c
-F:	mm/sparse.h
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
@@ -17210,6 +17207,21 @@ F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 F:	mm/mm_slot.h
 
+MEMORY MANAGEMENT - MEMORY MAP
+M:	Muchun Song <muchun.song@linux.dev>
+M:	Mike Rapoport <rppt@kernel.org>
+M:	David Hildenbrand <david@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git memmap
+F:	Documentation/mm/memory-model.rst
+F:	arch/*/include/asm/sparsemem.h
+F:	include/asm-generic/memory_model.h
+F:	mm/sparse-vmemmap.c
+F:	mm/sparse.c
+F:	mm/sparse.h
+K:	(?i:vmemmap)
+
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Kairui Song <kasong@tencent.com>

---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261019-memmap-maint-72fec54e6752

--
Sincerely yours,
Mike.


