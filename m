Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1091CC88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 08:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9056B0095; Sat, 12 Sep 2026 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289E86B0096; Sat, 12 Sep 2026 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6E36B0098; Sat, 12 Sep 2026 04:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0126C6B0095
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:25:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DF3E160450
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:25:53 +0000 (UTC)
X-FDA: 85204426986.04.6400E09
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf22.hostedemail.com (Postfix) with ESMTP id B6B0FC0004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:25:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Sz9hZ3gn;
	spf=pass (imf22.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789201551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCKQzHy11n4rZ/Ir7KunChoHPt2wwZSgc8x8OP6qy24=;
	b=3R/PenKZE3KiiD59LfN+frEYQRh4ExNFiNTUo45pPyAOGDeaRYY2RkMMcdc3uZVB0/AdwG
	DjWApZAgrAwbDdzZrSwd8wGBKVlJY0UgUS+NqVc67RHmAXJAcE5VjJ4VpHPV65HdUmi+QM
	DfxnkpTv/FOvdIBOHf2MSolfYCdQyAI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789201551;
	b=dtVlogJr0KTxgbGvnTq4aCGJHjTnOjHsYORc/g9DPp2SfyuTbt+qtIGwTnAaARUFxYmgSk
	2jBt/fzTTaJ2y/m2ej3feoaZQYKD2YBO1lW8kSFX7K7ECBD14GVViZwnXPcF9wlrGguCZN
	51Cr8pI40ruOPkjP8+JJqSIYK/vI34Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Sz9hZ3gn;
	spf=pass (imf22.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=PC
	KQzHy11n4rZ/Ir7KunChoHPt2wwZSgc8x8OP6qy24=; b=Sz9hZ3gnsXEBvhqNjp
	R8n7fEYA200Widg1VJ/UBlhyyCvoyOv40BdwS2jWy3mulgauNMnBQLuv0sI2D7sX
	FI+WS8MObchPuONVR1x7UwXu9VeNqDc7kt4lIkCW9J+Vwo+qLD7Mgoqfo3b7a6du
	MzlJ1EevqwI3uTw76Nx5hwciM=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnr7FODKVqmfMoSQ--.44660S2;
	Sat, 12 Sep 2026 16:24:47 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	borntraeger@linux.ibm.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	harry@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nico.pache@linux.dev,
	peterz@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH RFC 0/3] mm/ksm: scan with per-VMA locks
Date: Sat, 12 Sep 2026 16:24:04 +0800
Message-ID: <20260912082407.75875-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnr7FODKVqmfMoSQ--.44660S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF1UWw43tw4UtFy5Ww17ZFb_yoW8AF1xpa
	9Ig345Kr48Zr12vwnavanrCrWrGw1kGFW8tr43G340yr45K3WqvFW0yw1jy3WUW34UG3yr
	Zr40yF1v93W5Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j7CztUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2w8aE2qlDE+hbQAA3d
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6B0FC0004
X-Stat-Signature: 1rc9nhedeqmnyju6bnxaneuw648w5hd5
X-Rspam-User: 
X-HE-Tag: 1789201548-716371
X-HE-Meta: U2FsdGVkX1/OIUahMmZB0IxN+qoIeYSNhQ1/lzjFTcrTk9rWywl4f5+efwdgMDRwf9DwW0JT+wP0rYMoSlno9pDCDn/hxAGecugtboNtv7ttYbVGhuTp0iTi5e4o05wMGN4dSTax6Qp2Az+xW1H6UVZw3UY/bEavyl5Q5oYSwF7dxSp20wxueKRATggLizylKlB6FTeXlg6RC16r3XMrCC+9Mk0DRNkg2JXkgVfzMByPU2dzb3R0lxY8gaK+9z4WdocTQ9LBNycV173yXQdvF5jr9iPHyU4owEa27pP0mtART2YmBle5BdHOuP/Ge6vFiKUbOefOMengdMFsUl09ZQdyeGD+QFoVYdlCiVjd+SCaflVVqdbWIA3CqD/HDt67gzuCVhK0D0scZNTZvxOZbzkhXEiUDXjo1psp9fbsGFKCIcO01tLcJ8u9p5ryXzB0Bgfa9H1E72u/CcIouoOYyJycdOvOPEQTIkXIzjHX9T8vkufGY0YqcC+WysgO81nL8pJwAR/6Aef2xtuRiKktdY+Js2FFRgRlRj69fxV1yR21HWgnFDCT/JiVExjFi2PqWzon6aJYz1os2x86Bg4ArF1FJhJI9koR0xcsqvC8TmA/yUWyiYZ6M55Bkiwum/axf2jg8y62pgPA69kxmmZV4absitKnKOp5bBIH+rlvy54hDhO1G3/r92Io5TOnxsm9vwWUvAnp4xN12IVwoK4ubCnK0txf7RvGJOCToX9Hk5u5QJnz4Z12jD4K5dcAlMh8pH7fb6MRNXVZjfn4RV+FN4YhZqzZwLL+hzUYdB3X6ORpeP9st68MDR6dytorHhQD1AKeT8PpI59v2A7R0IZfGTrOlfkl16LzFzwwmUyhsPXt0TynzSbPXMEI7NUZ2IeJ7llKdB3xORudFV3jqWfj3BT0ziETen11JbzDPkzkJ8ODWBa7pWYm5lAirACmKfhxL8BxBtSsrMGY19lq6nJ
 I+xKRDiE
 GRm4wrUZD+h6lkp5VJE0ZeA9xP0aPa9p+DIGY8GFSNy2gyGxR+/t+cGdYJG1q+D5esvt+dnU9bApQHwcwdmIpuQg+t3tR0GdjiQKvciWz7d1OBMR6/dOWBx3zfUQIIZK7lhxVSnh1pTi8/D1FKr7vu32QdVPpZIbhhyITYYBuMJiEw9HbjQ++fmKGDkIvp4io4q9glwjHrczf5SIOCzvWhD16FDEzwsH0CltjrhpPf0/2/jaghThXUjSEjFNz2tlsD2tyMRrZ/jd78c0t46ARvQurMk5xvJVIkEw8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

This work was developed independently before I saw the above series.
After comparing the two implementations, I found that the approaches
overlap, so I am posting this draft version as an alternative 
implementation and would be happy to combine the useful parts.

  The main differences are:

  - use per-VMA locking in the ksmd VMA scanner;
  - revalidate the mmap-lock sequence before skipping the fallback walk;
  - avoid repeating a completed VMA traversal when no candidate page is
    found.

Benchmark (QEMU q35, TCG multi-thread, 4 vCPUs, 8 GiB, x86_64 guest on
Ubuntu 24.04, 7.3-rc2 base, CONFIG_KSM=y + CONFIG_PER_VMA_LOCK=y;
victim: 32 MiB anon, 2048 unique pages x4 duplicates,
pages_to_scan=100000, sleep_millisecs=0, 3 runs each; churners: 4
threads mmap/munmaping 256 MiB in the same mm. Microbenchmark as
posted in [3]; relative numbers only, TCG is not native hardware):

                       0 churners      4 churners (mean)   
  7.3-rc2              1.21-1.41 s     90.9 s             
  + patch 2/3          1.41 s          48.7 s   (-46%)   
  + patch 2/3 + 3/3    1.21-1.41 s     30.1 s   (-67%)  


 1. mm/pagewalk: allow folio_walk_start() under a vma read lock

 2. mm/ksm: use the VMA lock when looking up mergeable pages

 3. mm/ksm: scan VMAs with per-VMA locks

Link:https://lore.kernel.org/all/5cd47bc3-bc3d-473c-80d0-8be8b7b79881@163.com/

Longlong Xia (3):
  mm/pagewalk: allow folio_walk_start() under a vma read lock
  mm/ksm: use the VMA lock when looking up mergeable pages
  mm/ksm: scan VMAs with per-VMA locks

 include/linux/pagewalk.h |   3 +
 mm/ksm.c                 | 166 ++++++++++++++++++++++++++++++++++++---
 mm/pagewalk.c            |  11 ++-
 3 files changed, 166 insertions(+), 14 deletions(-)

base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.43.0


