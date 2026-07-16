Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2166C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00CF06B00D6; Thu, 16 Jul 2026 10:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26EC6B00D7; Thu, 16 Jul 2026 10:52:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D376B00D8; Thu, 16 Jul 2026 10:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A91B6B00D6
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F324E1201D2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:52:04 +0000 (UTC)
X-FDA: 84994929810.04.BE89AE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D09F18000D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:52:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AiA1vCgV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SUuxKwpil1PsNN3ad6xF3FsvL/1fKwwClYjSl4zS5k=;
	b=LyO01DNz+M/O0f0nEFH7tYDzgHla++LOQf/A7BKuGpIxpNiCvWV1zbB3ifOkRXrm810gGi
	yp0dgA6/WS6IVZI8ceWvCv7zmBN2OPGa+oQ4QgwqP0tdGnsXqBHzPHW7hZK80d3lb18DYH
	8gFAEopbjDn6sRqlg8cZDTaNachBQAQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AiA1vCgV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213523;
	b=TWllapyjcA4LQAXUGl23JxbnkDmOQ3sDdqIVzZ5IGwqY24VEcInnAhdP22fttxbjY7tRgZ
	YPsAZ/ag6VwHL+ACuavbfMJswOEfh/esaDTN+4nHzEb5npHxtaMUXUaHvWFa6MtXEt/o2r
	lWrR2DqQ0pdLP/LEGXbCgolvvpmmK5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB0E7600B1;
	Thu, 16 Jul 2026 14:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBCE1F00A3D;
	Thu, 16 Jul 2026 14:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213522;
	bh=0SUuxKwpil1PsNN3ad6xF3FsvL/1fKwwClYjSl4zS5k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AiA1vCgVvUnhSNKfBex/54MWcWvKze0Y7zHZRqaJLsYUh4uUcd4OQ5SV+DDxA7ytS
	 4uHdc3b6gUTTjJxDjbQQm4oWAury0jD7tdDTp9Esz083Ya7ujdcsccHOCoFZidSLop
	 i3LXTK44uEQZ4MO/spj4F16sa5/lQD1eSk5zaHkkX9FDBYpp3q7DRELn4nnhPVX8qn
	 bIZ1Uyl6YNWX7S9yASY5uretie2wFjZfcjne7EDEWSopA8ncJVwktlaUnctzfrpBOt
	 k7DPpZtZndfE7kk54mDXZYV3WUAXUfF1QC9PPWuUan6VO1zgd7bK3N9BOonH2ncKjp
	 t+SyFvXlHJkOQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:08 +0200
Subject: [PATCH v2 09/10] mm/sparse: remove bootmem_info.h include
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-9-4afc76c73d61@kernel.org>
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D09F18000D
X-Stat-Signature: u4i7nntcowqzc6c6ew7o39a37ki8kmr8
X-HE-Tag: 1784213523-247668
X-HE-Meta: U2FsdGVkX1/7is9lcfNkFThFu/HOj08pMvQEYBpYjQRRhYLzI7Dg3ppiw4ol/sNXPT9CjGZY/vRL5tWFn9tPssVn5cfIAiwJQRTI+Nw1pR3m1T2qp+mcSJX9sHMceA7zxYz6m/NuuYDIVu3YMjftg/Ax3+vDdEUCWqGnKijZUfMEIAuSD779d3HNT7xJOitGnzgZkRc0LcklPzbxcubJfA/nUolcihn3e9+vTtrcd6/CGDsXdX1ktpM+dGlW8mhzW3G5WHy6QvVICYpLX/7V1tTobIHDqyOCiYvPdtkfGqmkBnwq7y8JvxDg6eudDn9aAxmKClSkQpRemU4WZaHtzb7+lAkzk9+hXNXWLgPWyDtd0/7nq1lq6uoMkuFKnqjwoN6oiYmuRcLO7Vn+ZAwQ2OV3qiqWo8GCNwpRn4r8DpeM5REeHWktUCIp45DkVZMHspue4gyuy/ssBZm/nz51SLXbkH6aIh1nIBgIa7HzRhDzD82ZsA84lYGqBIOa8HQ6Go4TzT9DgZ69+OYCdTw54PqdZpULm0hE9dHLmlY4+ScSZGVSslzq1g5XH8UV2cPnu/uzza4B4sMEtlGXEUXt4PzAhdxZ27i2moYcc42v22shSfyPhH73a2SXorcCp7UNdR0A3YhiO+eWKCqgzjljtXBPZTj2UIuRIe3LWpGCtXFgbHS2UrbkwTkB9/Rl9bN60+rSJGVe/6iYkH4NZh7loxLGaL0nrjY0W5pljH/ed6EsVUhJwTqqzUpq4cXRkKpaOKuEgR5kKL1O7TxaKhbCiyY7UdKzg4/zWdpCCvJKEOl2yMy+mFNUZYWF5n8gEjag9PQnmrZyyqggDGuZdEcETa8JpFYDBWI/hhN2oxQAqlaMieypno9uwdFISl76eeMmLk6EVlyaVwtoAQcQcGDw0gf5m9cLfcSLfY9IXP4sOk8e9GL6E4WwA5naaV8oPs/+jHW0qDTx3qycxAoy2Cd
 wdWVKSTY
 jq76Qpi4ZCHDkPicJaSdD/30qG8XwFZ/6oYpDCuL0MIbn/JMV/LmNo7gh1rg8ZIZx/b9Lqz1n3nYRasSXD+93rP0s0Kg0PhnOOqoLtsmEXDUunRs7riHLegP3nfFJxHzVjRJHDMLGfsVrexoHJpLsDvtqGlQ+fmYGaTAFv4lbx7dpOeyHItfY2iFwdoEffZHq1z6IcyK8RtkKBaij5lFZpXAo8ERdY5qBcBZ2RAqckGiNa6h+cnsSh5ji4Hhx/k/xAl3THQXYUPWNBqvCMJOZSi0EuZdioGEw2od301E6Ma5B/HrMe8EbaKnxL9E/X+c8lmyzUDnlJPyc3WE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No longer required, so let's remove it.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 058ef93003672..b5c74aab3379a 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -13,7 +13,6 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
-#include <linux/bootmem_info.h>
 #include <linux/vmstat.h>
 #include "internal.h"
 #include <asm/dma.h>

-- 
2.43.0


