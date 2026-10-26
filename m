Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3449606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UQ28VxWH
Received: by kanga.kvack.org (Postfix)
	id B5C916B05B7; Mon, 26 Oct 2026 04:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D1F6B05B8; Mon, 26 Oct 2026 04:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A806B05B9; Mon, 26 Oct 2026 04:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D48F6B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:03:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 041DB140667
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:04 +0000 (UTC)
X-FDA: 85364036730.20.62EF255
Received: from mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	by imf23.hostedemail.com (Postfix) with ESMTP id 961BB140009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UQ28VxWH;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001782;
	b=en1fmmdwyy11EhlJDEerKIEs1H6CtEAo75Il74OEUxrnohwYG3w5rm6xtSOTYme34A/ENQ
	PKo2dF4agvyTh9lmDT1UYlaROsXR3pdlX6CAvHI4G6zmiFv2WNmYBbNi5JjwDO+UHO/3s5
	8dwgg89C3TnEbLKQ9onuYOINZhh5260=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UQ28VxWH;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F50Qplwui3CICEAhuivMriFrkJSXdydW0DAGmo57Xtw=;
	b=XBMLyFu8Bz646YFPKHkG8GZ4Qwb8WBdEJ+SVGy/oWWlx6TK6xDRQT+XjOLkzyeeArJr2jV
	8GXyRRmN+OORbYSSd80PeUGbTXN8hC+XVxHbAFgjDfON17PF+d3BbPMprrYefeyU5HOJIG
	jmC3vWnnuri+euDmdYT4VIsBgFDxQ2g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pTZFl8UM3ETvokuzfL6iKKBHKQY2m3Ez9MTwzEqi/1A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001781; v=1; x=1793606581;
 b=UQ28VxWHre72gDnSeRWu3nb1iQZNIm5O3U2D7Zzy8KTK+mN1s0L8AOB27+kZM9fI0+f8G8dY
 NoxqcWBr+OpgCT72GqbU0zwZrZTbaAqWT/S/mizRTjwhFdd6OAQy9+xEfruf1UMlQGS1V5zpE9g
 LukQmeLeovX/4+EjnXt24Xqc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e2e51c17888acd15;
	Mon, 26 Oct 2026 08:03:01 +0000
X-Mizu-Trace-ID: e2e51c17888acd15
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 05/10] mm/vmalloc: reject an unaligned range in vmap_pages_pte_range()
Date: Mon, 26 Oct 2026 16:03:24 +0800
Message-Id: <20261026080329.140244-6-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gdnwrthh3reymt44h4e8xq8s8guodwjc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 961BB140009
X-Rspam-User: 
X-HE-Tag: 1793001782-969001
X-HE-Meta: U2FsdGVkX18Vgkm5i9b5xoB0zaLKIVQ9ARAQk8HGQ1Ew1p8iognt78ITdvR0vpm6AITb333ce88PrEm3WcxGVpTPXdlAVRQWBYgNxpR1d9ErdOIW9JeZsVMaGrrVA1Bo6xDBK6Ljtm/gMAEuJt4b95rnQ0rGR+STXtW6Tp3d/7C9fY5lovZVGsE6fO1Dvd5P+ct0HwvPCuZCV+il/HV6tiiqRFXOpNcJm6D9UrKF2PVwfC14Y0gqYyGmshfEUL3FmKEbDvDwhytN3MZZ2KSLLba3xSEzMVGz92ZDNXMxqKK5bC/NdnH7Cn753kc0R0MHoDqi/l8gHe+evRuquvO3UFbxtTygYuVEFRNKE6oks+hqx6zWichPDDYAB7PAk/sYUJ94gVYgUlDWlCuFTZrTYXq0KnKPJBBlrHgLqDjDz+9iZ7sVJ0SGb7WmCQEkWtphFF/yXIkdksef9CU85/3SpzGYQqZSNSLSxMSlCVbzdaPCqtuZ33Ka/l9hz2qx463AhK61mUoaIi1n3Klv2eLg1tNTvg6/6I9RI8ogBaOEs+kDkv2Z3XMltqaQLVO/DRF3fbIs1RQRYj/DT3YAX4OlykWhuht8yxmNuc0UTGt8ANXXlHpexN8/LjtuG718vtxkovUZWiLj9hs9nPW/SSFYLNg8v+0etUAERrG47LU8PpPuz5Mx1wj5sVIztaPykrsDfQ4kI7w1unSKUEYmoDp7IjZfSOseJECSERWzWUmF8Zz9ZBMW/Aq76H1JA42bMPbZ8wrwUeEbNWPBY63qoo/waJPiQQIepC9G/qH4P0SE4ddY+2F29b0OwSFBMvVHN0vf9giQ6iqiQjMQCOITrhbdn2L4+2J8ZXXob9YIuw0/R0idGT+xuE0b/uIUS0sy47bKwJnxlT+XDOEqKbcpGeq/bt26SDJCa4JJoYyY55/GW4jRtxM8LWPlSCqKbLDhw8IJF90Om0QGgWFHyhQMk00
 pkaVDHDZ
 KEwJnoAqiWz1pLf6/lWSxasbKx9YrrbEbh5FVQalQjIwYHkkOEW1IZgUBd9wT39qeoPhUk21P8LJcRqkd7FG/4/mG4aaudYOl5K+3319yNF1HmX65OGQsxn1jTEHGZX5fvThhQdqdB1OBdwpbwgrlPFv1xlMfuNd4ZNPYnd9QKBj9c1hiCLDKSdKMFA5JoMWTX9Wz7mYvEw2cLUvFCoynZWqwNIDgXgYsLFDZ9Amg55GQ0U+6gOGiUvlymoRvmTTTyRnXjtNNCOPG23uelmIKyZitRD3sv3D4WvmiKiKkDVNFbgY001U7IRovtJ2bP0kvo+/rrnilrFddl6qtOelz/8ePPev7N+LhaCabSl86o3ITKxsozl9SCBzwlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
PAGE_SIZE aligned") made vmap_pte_range() warn and bail out when the
size is not a multiple of PAGE_SIZE. Its loop only stops at
addr == end and otherwise steps over it and maps over whatever
follows the page table. vmap_pages_pte_range() has the same kind of
loop but was never given the check.

Add it there as a backstop.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d60b99b81ec9..c0f33392c6ad 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -557,6 +557,9 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 	int err = 0;
 	pte_t *pte;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
+		return -EINVAL;
+
 	/*
 	 * nr is a running index into the array which helps higher level
 	 * callers keep track of where we're up to.
-- 
2.25.1


