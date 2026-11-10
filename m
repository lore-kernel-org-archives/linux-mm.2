Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D5060A3836
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mVkWfYh/
Received: by kanga.kvack.org (Postfix)
	id D28CA6B05BE; Tue, 10 Nov 2026 06:25:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8C06B05BF; Tue, 10 Nov 2026 06:25:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B735F6B05C0; Tue, 10 Nov 2026 06:25:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9787D6B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:25:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 960E84059A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:16 +0000 (UTC)
X-FDA: 85418978232.25.15C5E47
Received: from mta1.migadu.com (out-158.mta1.migadu.com [95.215.58.158])
	by imf19.hostedemail.com (Postfix) with ESMTP id BFCC21A0008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mVkWfYh/";
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.158 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309915;
	b=3my3Q51uPqiyLBLQTw8ayHeyCzndTX77exxr453diGO3QJ8kaxLlbWaJQCjZLlPPtlnRht
	fckz1qmHbUGAxWnH1EtI+d4dhQ+QnWmw8t2KofJp4Fy3JzOWOZ44qXaYCedqWYTuP601d9
	FECuFuUQa1y92FJZucXMeK2B09rrBgI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="mVkWfYh/";
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.158 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njIoOXK5zMREOncg8mUAQGqPEShsE5xs29xDkWFtyUU=;
	b=GErcT2UBuAgXa2BZMhtbvhiU26I6iMcS95R616kofUneFEmWyXtZ5DLAKRf+JCIJ0hiFHQ
	SPHc3slsHbB8yaKWat0DdBI2/E2QXilK5s47hGQD0hbWH6zBbPxRInbXx2zuso23XtCvy1
	+NBRMQ7Ye6pNlhB0d0i9cuJwO+BYDOU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BPShZdqjxGXzG9YjR46DA5wDrW3cgTzpgUAq+Dua6mc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794309913; v=1; x=1794914713;
 b=mVkWfYh/OU5ocR0W3SIgvgFGay1eXuZ9K2ZVcborArx5MMPEOCDYFyeFOxuvPOfLou+64Lbj
 NxviIlOtEWv4pnOnogTcpp3NFs6KhEcTsaL6ycgwbASbu3WK9k8ORbYH9DHGuAFwa6g6CJimA+3
 WU9vvPNnJDjYBbYQqi7Xo5Z8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aaa1849df80259f7;
	Tue, 10 Nov 2026 11:25:10 +0000
X-Mizu-Trace-ID: aaa1849df80259f7
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v4 6/9] mm/vmalloc: only flush the cache after the vmap succeeded
Date: Tue, 10 Nov 2026 19:25:43 +0800
Message-Id: <20261110112546.261415-7-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261110112546.261415-1-hao.ge@linux.dev>
References: <20261110112546.261415-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1k9nqccweukq7kzust8b8pnruo85sffd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFCC21A0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794309914-98967
X-HE-Meta: U2FsdGVkX1/TxiE+ZTGz3pQ8yMtSrviNGrIpjiNa6TwTBSn6v3NJrPi1e99bNENcOsoue11P5+MEK8Ce447UNlqyaN8aP5AsdWMphzQRCKjA++kzlYkp/SX7gy3BLq3MOZ3Q1hh+seKfraMDLygMbZKNOfzH9wmReksZvLy3XG4BuRCBAd6vPvjI4jFFaP2sQ2HeND+Nu6YHaoenF3F01LnPX52z83FnPMfT6YtI+49b7et3XU6in07k8Hv8tHv6jVOO15HZVMx4xMu0g55hGLYykPxt8jQc1uD85dXFc3Kg5mlgRLog6+QPOsy2WTlQ1p5D3gc1y2OfA5w7BDf3yPZjiWomyBkJss4Z8y/bNphWMluyH4pmRzEZMmKAIHgFJkmPaJ3P0OgpvpGBoLNU2idGxja3CUmnphpU3INVa7MVPBhLM8/krMviXqXiT6CC9D3QFKpxpxle4Cgdm6pFr74JVTZOYMcpL8ivsiTJ0VnVIbWOFoE2v0T7rucTeOy23iBts0swgZUXGKosOF1pWP2Y/Ju4ls09pQsBCAXRNgXaT0UqWruWoE1e6FyBlZqiCXQ76+q8bjkSDNdMJfyyzOli/cVDDe6IlrVx/uywxG3Cf2RXl0HU4tOtJrRPqCiuMHBCdRwd/2fqg3EeqnThQ9PThDgX5LZXMnbSvKtcIi73WYOiwutpIRXzIhzszGhvxbQabWAH5SRXtlNOtYJ1B9wclUCSfFvOvgV8axzCCq33TW3IG6H1x3XVMIC+xazybvIjtBYUOxOG8DtTGfJx8IqqHTx9I76dCnFTenjrHMytXD6EWUUgBognnmQCdpZ0wJ6h92odKNSGwMnZVn6j1xRyiJvfLxY5OLJCGJV3fCwJSlRrtzjVnvGbiNQUFUZ7oDNFfhGoemnCZsDzmU5WBShMeex5PFBFVlYIoyc19QwVWIcTmM7+U2siYE08OcVUcnb/k8GiRSVpsNLV8gr
 pOWJzcT7
 72Mfbr8nS/h8833KmLBuQCHhozuPETEAFy+gdGugZ5GVD3ORqPwpb1bURc+VBB80+RNebRFqoyVoJKJ2tKAl5u6rPtrBIrKauXxEil3F4MkqNdnAtUMsFRXwu1k5d/QsbfNaVStJaGTZ9Kn7cG6yJr5zSdmENzfdkdygxkrhN+UCrC40aTvSIGjpsDX4YF8b5/y9lQHO+gA2/RWV7u1ceuN6RrAu6Lvkdm0F17s1oIr4+t99eBpemXw1hDN77ZBzZpvW0VQQ1/IzKEe5Am1rE5LC4bW+4eYQ21bUoteuPtN3gJQAW5FGnkf0vYukLDUX4ZHE3ltcPdq5lg+0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmap_page_range() and __vmap_pages_range() call flush_cache_vmap()
before they even look at the error code. A failed mapping is never
used, so the flush is pointless at best.

According to the Sashiko review it is worse than pointless on UML:
flush_cache_vmap() there is flush_tlb_kernel_range(), which syncs the
PTEs into the host OS. Flushing a half-installed mapping therefore
leaves host mappings behind for a range that was just freed again.

Only flush when the mapping, and for vmap_page_range() also the KMSAN
metadata, is fully set up.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0565cbfe325c..3f98056f8c7e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -369,10 +369,12 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 
 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
 				 ioremap_max_page_shift);
-	flush_cache_vmap(addr, end);
 	if (!err)
 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					       ioremap_max_page_shift);
+	if (!err)
+		flush_cache_vmap(addr, end);
+
 	return err;
 }
 
@@ -758,7 +760,9 @@ static int __vmap_pages_range(unsigned long addr, unsigned long end,
 	int err;
 
 	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
-	flush_cache_vmap(addr, end);
+	if (!err)
+		flush_cache_vmap(addr, end);
+
 	return err;
 }
 
-- 
2.25.1


