Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DDF5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164396B00AE; Wed,  8 Jul 2026 10:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C906B00B0; Wed,  8 Jul 2026 10:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0794F6B00B1; Wed,  8 Jul 2026 10:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D27A66B00AE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:12:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5B4DF1C0E4C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:12:19 +0000 (UTC)
X-FDA: 84965799198.13.D24DF9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B616E40011
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:12:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ia1IsIGC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwd351vZMeylo11Xt7QUAJDGgeyO/aHkIwHIv82aQeE=;
	b=Z2ScjW66EJKil6tYasjoHxjH6HRskODVbjMZdS3D9spu1EkLDqyoHXSdlxRCpSyNMRKnEs
	SkU8hyYDTTwv3vDh6+sLPIio3he34KHV9mHu62/ihWCT4UKVpiqccJXePMCeRiINmO7ueg
	iIMgQ5UNKsWp5rZtuym6cVpuuZq9cp8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ia1IsIGC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519937;
	b=B53mqBWUPISOPm/s6Pd2I8RwREaVarNxeDMojH+YNL58OJvdIMpsR2WLOel+h/Jkwf/OLu
	0IdzXvTp87Ukx2sp0jT5dyeIVtvGC2kgjYLQJvkvX+5xTlS64ayWM43fm5RXzRdtg+TFvz
	NMLgEYP7Bn2L8OdAOQFCwu1+egMUzyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50E3160008;
	Wed,  8 Jul 2026 14:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A671F00A3E;
	Wed,  8 Jul 2026 14:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519937;
	bh=fwd351vZMeylo11Xt7QUAJDGgeyO/aHkIwHIv82aQeE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ia1IsIGCAROHagJA8XwwjgWhiIfaUuC7J/9zrD3GRG8E6BcnaOGLwuncYlD8oQVsk
	 +EM+3WTRQpYEx01oCoCMobP5C2WKODaicATQyQ6Rf4uq0+0OavBC8GZnqmqvHOTIxF
	 cCBZOu4IGMudBC0VlX5FvTrPZpmkLDqId9OqDTKCiNY2LTM7A9LAn9zQD0+IAnbQe7
	 d3412Zn30tqetBcQvajn1+y4EVQxidTLUq46UfuKVpbcZ8I5I9ZNaf2y2O5SxJKkWH
	 +8z+E6pN6bz32RXtg43tJ77K0q7yVf+f1x2yciCv3NViPcVTt2If4TWKtyKs9uAoP6
	 06shHonGEWjAw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:11:04 +0200
Subject: [PATCH 09/10] mm/sparse: remove bootmem_info.h include
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-9-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
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
X-Stat-Signature: 64r5qbjofd3hbth5idrb1m6bx18f1ntx
X-Rspamd-Queue-Id: B616E40011
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783519937-713148
X-HE-Meta: U2FsdGVkX18XRS2xAi0Hwi3h0Wbrr9YMtj/QUfghx26FYTuatt2CqMebBEw4MkxckqTLTmm8cIVcT1sgrYL0FsY7x+MtQPr7+Z+OSXgtVgY+fERUECVFGHkGWtgwFmZTMWImDGBrbplsqlzxgP6G+JPccPn5MhTGnAznUqy3DQplTqYPwkRXezsHalAkupIBWeyFCjsnj0EwRCP/sOFxurjfif88gpYrpHbokDyWHYukhG06gGa+dYFwsN66AXPTIb12RLIYFvAZwSNTzOAzMJYe877JgJAOSAFgzLGBBgdipXaD/HdP616Q5rRACfGsQKcXvbwqCGWst2S5ZTcUxkFV0xZ3hXxZcnPB5fmSJY5VQPQzgad9MuowIboZIYyDRvDSV3/iMK+rw1j8cRX9Q9t7oRrm2mQrQoZDvpHTLQfDYtnS371olYVWn45Xdn7I5H5x0OuzANioZjyOTvT3/0lhN3YkyVKwaZobSAazU5cxSaeYzevGhivH1DIfuR0lgpWoxS8CDS5voIM4GY2Im1Peqv4X2vCvLHeuf/RblerC9dJh5ocjUhdFHrUUxNUbaJU1qN+kplkvolCuMQopOS9hxPOyURSsmlT33OS0G/asTggBpa6uEkf/uNJslAhsF5/dgnoYBqHL0oos7hklyUcP52AklifTEpSnAyx3qmFGi2ck019mXRRqJVf/XQj2+QiacY/MpJT0JgyY1LE04OdVX6sD1el9MW0qfKxJTS7lJ9vqXI5piguESWEo1H6vVks2ddxzKd2p925KosPR21Fwdh4VhjMXIInelpjWfC9y/y3tVGaUkzhpv97E2P0Q6Jzrhxw//gexMN3LxI66d9xZTH5wQxySVzo6dp4mwcv7ADIeM2Q/FfZg2B5pvR6cfJVv7sfk1D9l8sGtg+x+XZZdG9OIO2jPMneR4lO00fUldoIgsjuS9fOn7gvP8cijNbD9KGY1FAcfGTNhOqO
 5CBoKyJT
 kY+xgCPkTTDQm84Cxo6dxgbaaOCFyb1HSIW4FNaMy7ftkG7KKoYu9tQ7WOLXSSCSxqVjPGdOrQd9HUuG7/geniJwPjASbrB1FW1OxqFbudHiONv0+iPvrpGApCexiMX5WAlV5qU1HQJfVLVBb4iZ1aiXYnhh7Jgu5uV1OUWJ2SrWnh/P508TneuIddDWSQslzcyWvfTg0EeT66kARLH9421GYHTTOBMjayXjIMj7Yt9tG5HZ/XuzjF1Ir1e+2g71OOL0M+Kml6hzzHhb9nYAikalrwyEX859TQABvL5BKsz53cvmkn4cMP7asnKY/Pq8ibnN70/hbRGY9YWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No longer required, so let's remove it.

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


