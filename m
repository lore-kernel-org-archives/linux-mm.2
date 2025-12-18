Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48EE3D6D230
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338E56B0099; Thu, 18 Dec 2025 10:10:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B156B009B; Thu, 18 Dec 2025 10:10:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226C66B009D; Thu, 18 Dec 2025 10:10:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8C76B0099
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4B63B6855
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:11 +0000 (UTC)
X-FDA: 84232927422.10.BE42504
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B7A014000D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bb4n0ptR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070609; a=rsa-sha256;
	cv=none;
	b=pHBVDVpCRkXNxCpTRRBhgCBlraEOiLHtJjnohTtJD6p2E9XXMu1c6FsEItmuxjPUEl32Mz
	chqns2S6IFwYwpTK8z1V5IlN1dMTq/Eq57hCk5Cz+RPJLa8tuo5a0e7UlwNRYtwF/RvOqS
	z6K+sxmcvRf+4BUV+0xRCViIbvW+IsI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bb4n0ptR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2Mc/skEFUoRGpY2DzZkAsLZS5Rp4eBKGUU5YPV21LY=;
	b=we6ZOJJClHQhurQIvgFnB5Z+oIt4ie8qPjdzhuw+gLgWayMtyl4TYH7r1aTvwZ1WtN/JBo
	2LhkBkODVFxE9qNyxHjrDWrGKUGBS3lGVaH0BrPe+i/LFZlQLN7C4PJFzis7NbX9PSXI8i
	YIbHtW3+pv6GPsg82rSqjTs4O0b3dG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD15D40B80;
	Thu, 18 Dec 2025 15:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1A4C4CEFB;
	Thu, 18 Dec 2025 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070608;
	bh=Kq8kgjoW35TGaaX30yH963wFdY5bwi75+JeGAznZYJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bb4n0ptRDJm6VjhnYzuel9TvhDmDm8afHnxfN299Vv0IUMOIywzNAPgis0QWIrhQQ
	 xLLAokV3eSgWrkiZ+G3KhmC59xc/T4UfdBH1UnJGmbsTutp0bFn+Fa7eXngHKXKTsi
	 ipQkIaVb2Ewx34QoHUZetmqR+SpIh7V68Ctwwn7PChUWpQXfyNx2Ag3dwnhuqr6FiB
	 edOKlBNjXUmWk6/jAI6c+ESBqObRDFBdh6u9FSlH1JeLDqpHhgswxyKQTdx32Mvbzr
	 bkXUq1IMNs6Yhs59j5oqTOhCKo9JYTfLD8DdHnweaBLTFwzupYmsMOmW8q3HcvXMeV
	 pBoXMOVwPQPLg==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7AAF9F40075;
	Thu, 18 Dec 2025 10:10:07 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 18 Dec 2025 10:10:07 -0500
X-ME-Sender: <xms:TxlEabIWyVJEPc1vvT7pYxwo5pRjJPOVz21HT1hiQz0VsLKP74BVZw>
    <xme:TxlEaebN0Fa-Eavj28VKh9aZHUHiiDG2qeEcsM6adMvADBPUOfUIL-kxi9zPqgKCz
    cwvoAA68gnOaCRd3zwL8LegHWY9_VsvncEe8DfufBZquJTFsAsnn28>
X-ME-Received: <xmr:TxlEaWhDS-7njyLKCjRFcDI-PWd-adO1lpwP5_M1Z3HX6yGY1ZF4yBIjC9t4OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:TxlEab76TOXWwZ--_9_2hmYohUFMppOsReYQYIu_3SK9xprLmwxYyg>
    <xmx:TxlEaWq_gekXMPhYC4eM2XIgt3eUMbXrLwiZeTU5ZWUv17eDW7W5pw>
    <xmx:TxlEaQgL8zu1avJMidJlLQodS-2HziR1i8g9ExD0aaXrdmkh_InVLw>
    <xmx:TxlEaWvJ2Aa6MRihbSn7XOppGBJD9YbJwBlAXUJhSVXszhA6NPdXOQ>
    <xmx:TxlEaZ3OWnv-da7CSJyndqebjV9mCslo1SQtMyMdy1eg8R-REOHK96st>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:06 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 07/14] mm: Make page_zonenum() use head page
Date: Thu, 18 Dec 2025 15:09:38 +0000
Message-ID: <20251218150949.721480-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B7A014000D
X-Rspamd-Server: rspam10
X-Stat-Signature: grh7m3mj7xhfkjdck391qaadi9gn3zah
X-HE-Tag: 1766070609-538400
X-HE-Meta: U2FsdGVkX1/AYCfccx3S5BndBVm/8O0c7ks8aHa6fvkvftJi9iHi7E2DZ7ImgCK+GI6P7wN58PmGAg64NdDVHeflE8gGdB1h0Edc1YderqZ/krbbwcPRAXopA9W9NVun+smtDqRxAbCmiwqlwt9Dlj7EUzQfH4zcZf83mLZpVbK35pAh0dtYTOGMyzSO8oxtjvwtowN2nC2XaxRecuYlKD1Q9RmctdbJwyTIrHwmh6pOvABnZyFv5ZZYL5JnMinP9X0F1o9g20RpQN/x1u0eRhon+qqg9DXxjBHzQoXsJN6fNWML2FhbgyNeC2a9tw+oD0hEc/ryR74CrSKPmGI4gw5K1an+b0NnWkc1gt9X7KPjlW8w626Eu0tn81/a3WLoqd2IcJtfN4pfaIuujVHWBcJQ3vjMfp+wS2Vj3NJtlAoCwZxU9Eskr/Kw1To+vfWlvDKORg2Rjldlzrje/Q3a9XUZ4gHB2sTbWtLTtYFi/9NedjDPEWIPEOmjmuJ40ZJKjA7Zj6tgx4Ud0cMIGgSRO6tl12IyyW+hRUpfCXNWsAc8XW3xoNH42GjQKoaMc16EioOtam+96fn7Sl6XAWPQ21OefZW5mN9Fw26T+8tIiYBp4dMUNhO+I0SkR+4iu3h4tcLtbACWkvXwEol1w0shcQnZ9NX/GC0F+8Fa1TSJPn6lqOgAdz3FIJ+Qukpc55te4j7hIe4WLXjOlQY2JgxC+t0pVnkIe8YaLPMYC2YBXhBWt1em17drSP4n1WtGY6eBxcWbpYGOqAGOy68j4OEtXqsihX+HgTM1dqf8Zn4amSu0IqHHLYmjE09o39Z6+tEj0ZZklFsrYEYX/WJam+ZBeRI37sfGF3c4CARu143DSEKbk8T8CGIAySzCOVNQ7wO5MBheqAKCurxGmYQm+aOjH671Gw+88Gn19fQqTi8EPfnW2TZF704D7exBzUSJaeUJo28bgHIob9qb9kQMNlf
 yfrfyyfD
 ImzeGgVcc7PIj3PqGrsSq2YB8YHUo98uUTbMAH49uPC2pruPNCH26pKigG8TMKIt8IFR81kmRilmrI+gAbw6/D6hL6Avk9+MrBCJEtIMMEgpvKwjGlPZ1ZYLb2l5jHia9ourRNpYep18L5Ome/oSyaoRGQU5ekPOgryTSDwkw4xeqoxwy6b1sx/D6twsLt4JV3UMB97nZTHB+jBQMLZ+YKEiV7RswY3Lr49rk80uwqLqH2ED6jhH5NtN0EMhAsYprC7fdEyTzuanJk1PMIL2wCFnG4kIUV+KLEt+jc9VyRYa9Wms7IfYx86O2xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the upcoming changes to HVO, a single page of tail struct pages
will be shared across all huge pages of the same order on a node. Since
huge pages on the same node may belong to different zones, the zone
information stored in shared tail page flags would be incorrect.

Always fetch zone information from the head page, which has unique and
correct zone flags for each compound page.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mmzone.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9f44dc760cdc..7e4f69b9d760 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1224,6 +1224,7 @@ static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
 
 static inline enum zone_type page_zonenum(const struct page *page)
 {
+	page = compound_head(page);
 	return memdesc_zonenum(page->flags);
 }
 
-- 
2.51.2


