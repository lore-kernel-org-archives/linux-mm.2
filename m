Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F23FD875E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2BB86B0005; Tue, 17 Mar 2026 08:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E036C6B0088; Tue, 17 Mar 2026 08:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18C26B0089; Tue, 17 Mar 2026 08:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF7856B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:59:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FAAE1BD0E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:59:41 +0000 (UTC)
X-FDA: 84555561762.13.165978E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D6B2E20002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:59:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kblk4t7b;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773752379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E11J2IlbpIIzPWA+vs2j//e0OAYJEehNOYzPhmQ6Soo=;
	b=MpVVDF4Mm+TaTvK0nk7gFRvMsccvABcTAD/sRdIO1vlRu3QjkzE+jmrO6PFi9xLZsvWiOQ
	TqbCr2ZaA/tpY+I8QUwmISu9v0mQr55OF9mOlxVry4YzfBx3n6sRInHiYdSj86fT/ERRIF
	LUBbnqFVgT86sixEzW2IMr4sYH7zbQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773752379; a=rsa-sha256;
	cv=none;
	b=4zAxRDO/xQnTVLcgACVSp8yI8zv+Slxts62Ts2WiDGy+QLmwA0ecM5eUpG6TZdXQOGN5M7
	AFqxGyIzOFnzT21ZIf49RB/3LLNYQuVuMuTdsraKatX/OkCftN7DDUgNV5I4vsDrKyMXtq
	wsi8Av6ath35uNVcAOzONyMVscs6Cxo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kblk4t7b;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A492141679;
	Tue, 17 Mar 2026 12:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BD8C2BC86;
	Tue, 17 Mar 2026 12:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773752377;
	bh=q6EJXCXJtuF8E4RQdQBVl5lEuUK5e61KxXJSkpmgyq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kblk4t7bZ60o17/rBn6VoB5c+fR8+jssR+EcCG9NYztXItjne+3wBrtS+KE734n3H
	 hxlrBReZU8jMHyBOKunDhYPOfmC+GZZaVtRy6R/LkpwOqacZryqJ2UKmFTmfQdXc/O
	 JJcQt+v0YHWCKPeV3rEQ4WMXPlAYA5nnMKMkAICSMY13I2iQ0VGjDf4f1N/Eeg+hc8
	 ygSNw6knz7GM2LHFsaI6UpiDuvfyxxm95rD53S6RFKOEDrnoByp1aTIGIdymCcPdRI
	 Us1BdtMdRC3IVDeDnZ4MEjHzfRtuHKIVAXmUcyTABdfg7xNB25XA10hUnE8Na28DTq
	 HzkSCrWsp+63w==
Date: Tue, 17 Mar 2026 12:59:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Message-ID: <13e09a99-181f-45ac-a18d-057faf94bccb@lucifer.local>
References: <20260316140122.339697-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316140122.339697-1-ljs@kernel.org>
X-Rspam-User: 
X-Stat-Signature: krjk1mipechozohkw1hy7d8g7sfbutm6
X-Rspamd-Queue-Id: D6B2E20002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773752378-448048
X-HE-Meta: U2FsdGVkX1936E8I4SFYnrlP4D0qCAI9l+IxI/uQG3bf3ijl1pz/gwckAUSACGA29BgVRkDuRj/hV35tVmpFRchai4uK6tKvfAO6PzfJ0MpBk2j/+8XqQ8KqwGxhvUb1B+GNgF/uSINapc3ibyHblCXPXD3sHJPXMp6404jzPZPpuh5UuW3zozzUCbRlT3ZvYTRC1L4qlm8VjcYgFoeOV7i6ECvAzyPTwIAH3YrRd4A7HWJ2NJ0H/wk1VUiQEddLtk1MV63ur81dA1fKyD1zszYGozGBcOBxSpq5vwGPNC+YzWgT01xNlPRW4PHnc1od+GJL2dj/BnHvfgib5Lsvb6TXdKsoSb3Y8MguzYSPkgaYn6Q6oBxdYxPKyLX7An8S/sbkdsIOMln70p/vxE9PE/MOg2tWehQRyEjIFbWk1CeUJM7cu79RbIwplM2r3U5X1+v8NShDdozZwiybizJakkTRWlKf2/lx9e/1IOjX3+y+IhKy8HUOULX2X4Tjskoxyki9nQTh7J7RHGTPYyV/X8C5oheX5nT+LF2Pen7NuHQedQlMc+0VhbbaIRVL6HhDwyIdJ7dvhEWBGJCkbqKk9zGXhNlOiDEk0JSYKlrNpzSF/6xlg1xgnuqZripFiduP0X2V740D184YYX/tNOlIiKJv/IhtBHxRzwjeiAf/sEz8ADQA1j99EOLlygXRulZweo2by7mcPz+FwnBu0SU95l8qw4/oD5PwbW6llio06ONJWPh3oQCgeYZNv1s6Da9zlZkuDWqUu748L7EglWQwxAuAgiYpp21HwnYF0qOJqK1zmtosTNaQ8SjPSpgUSMoTyL4E7qbK6Xns6/dbmX3WwCH99yXrHiSwJMMwOPjvHnN+dwHYqMyuTYJAhn6HBM45pKzFTfk5v7Kxjpk7kKdAKP0x1b3mq4YWTw5KYjotpQfEVSNH+Iyc9SZvAuH/mosbIkNR7gpd5y5/o2n5rTe
 IXTAo+4C
 y8QeSRe22y1sF5NfT7h/02h0vtc53XdWRmlsW4QCpi4gRYPShpMa2nVY4Xy+xwvavvpWDZiRjTFdMAVW4ksfZIZ7/U1NQ1v8GsxLwxS3XPxSACfW0RhGSrGST7KmqgzPsjnFrj6QQVh3YeZI3WUUKaT0j6sf7Qb7iE6bD+HtuBYzyjFprYtPiKeyeWg8XNjiMhYHf+yvg2jE0zTRVn5iCo6dSZZ6M5MxoSba0PU42KD2822/D5tIrjv5R17orXm+q8TRGKwhTQ26FlsDXFJzcRjJFKMVxAEHTnZXbgCyR+h0+QC/wfLxARy89ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Please apply the fix-patch enclosed to add a dcache flush which was also
missing here.

I had assumed that a new folio here combined with the flush that is done at
the point of setting the PTE would suffice, but it doesn't seem that's
actually the case, as update_mmu_cache() will in many archtectures only
actually flush entries where a dcache flush was done on a range previously.

I had also wondered whether kunmap_local() might suffice, but it doesn't
seem to be the case.

Some arches do seem to actually dcache flush on unmap, parisc does it if
CONFIG_HIGHMEM is not set by setting ARCH_HAS_FLUSH_ON_KUNMAP and calling
kunmap_flush_on_unmap() from __kunmap_local(), otherwise non-CONFIG_HIGHMEM
callers do nothing here.

Otherwise arch_kmap_local_pre_unmap() is called which does:

* sparc - flush_cache_all()
* arm - if VIVT, __cpuc_flush_dcache_area()
* otherwise - nothing

Also arch_kmap_local_post_unmap() is called which does:

* arm - local_flush_tlb_kernel_page()
* csky - kmap_flush_tlb()
* microblaze, ppc - local_flush_tlb_page()
* mips - local_flush_tlb_one()
* sparc - flush_tlb_all() (again)
* x86 - arch_flush_lazy_mmu_mode()
* otherwise - nothing

But this is only if it's high memory, and doesn't cover all architectures,
so is presumably intended to handle other cache consistency concerns.

In any case, VIPT is problematic here whether low or high memory (in spite
of what the documentation claims, see [0] - 'the kernel did write to a page
that is in the page cache page and / or in high memory'), because dirty
cache lines may exist at the set indexed by the kernel direct mapping,
which won't exist in the set indexed by any subsequent userland mapping,
meaning userland might read stale data from L2 cache.

Even if the documentation is correct and low memory is fine not to be
flushed here, we can't be sure as to whether the memory is low or high
(kmap_local_folio() will be a no-op if low), and this call should be
harmless if it is low.

VIVT would require more work if the memory were shared and already mapped,
but this isn't the case here, and would anyway be handled by the dcache
flush call.

In any case, we definitely need this flush as far as I can tell.

And we should probably consider updating the documentation unless it turns
out there's somehow dcache synchronisation that happens for low
memory/64-bit kernels elsewhere?

Thanks, Lorenzo

[0]:https://docs.kernel.org/core-api/cachetlb.html

----8<----
From 94989ab3d97f0cde0dcf59eba6466fee932ec4ba Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Tue, 17 Mar 2026 12:29:55 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/zswap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 499520f65ff0..16b2ef7223e1 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -950,6 +950,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
 		dlen = PAGE_SIZE;
 		kunmap_local(dst);
+		flush_dcache_folio(folio);
 	} else {
 		sg_init_table(&output, 1);
 		sg_set_folio(&output, folio, PAGE_SIZE, 0);
--
2.53.0

