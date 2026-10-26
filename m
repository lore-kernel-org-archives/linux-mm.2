Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2BD606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AQj7bhNX
Received: by kanga.kvack.org (Postfix)
	id 67A8F6B05BA; Mon, 26 Oct 2026 04:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652DD6B05BB; Mon, 26 Oct 2026 04:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58FE26B05BC; Mon, 26 Oct 2026 04:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39B6B6B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:03:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA2A0A0486
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:15 +0000 (UTC)
X-FDA: 85364037150.27.B88977A
Received: from mta0.migadu.com (out-116.mta0.migadu.com [91.218.175.116])
	by imf30.hostedemail.com (Postfix) with ESMTP id E92B280005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:03:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AQj7bhNX;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.116 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001794;
	b=c8VKRweNp4VpePjo2OvtXQX78PZcxqaHAGZxhQIbneNieHXO4ZTQClnwgmgancGGY+Fr1Q
	qVnI/Ww96t688Pk57TgBtRzMY8/Xx7Uwygm/X/M1OL881pnVWQx0vJleMLBSHpLuetAkWK
	rOI3BcB4BrNAbKOh8A1bqKej561yisM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AQj7bhNX;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.116 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQRfqxKZWPdgYi3rSnDhlWYdHqbhXbBOf3zmvKiqynk=;
	b=N2xI2KmE5VrDsw27nZXwUXGsyZ8KDg1/Ja7b1dFjiYMh7i9gc2DlbFOTtOy29AzKF5p6a1
	9lnDBww0XQzdKMB3z07K5d8S3/O3gRobf+RM54VnW5anJa9bn0bPA+ujs0TuP281E6edeo
	jCOK/gqXRBV+gVb6TF0dAQGbLlB6W2U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=a517G3/D9CvqFMgtLJh4XZJvZjho3byqSfkgyTokHGQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001791; v=1; x=1793606591;
 b=AQj7bhNXAHMCiF8Q3PW/JjBLKEVJ9ZBNHWhP2/o9/aXfivUREuCa565zQP75zTcCqlyf1Qnn
 EQj/8dEZcXq9t21QITldHdN5V7PEVb2GPp/kWHTPYxr0zHywlec5JH8RdAfBbss54nyIg1stBQo
 XGcKHvpH7CfX8d+jVB5Y/Yig=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8477b878ce637510;
	Mon, 26 Oct 2026 08:03:10 +0000
X-Mizu-Trace-ID: 8477b878ce637510
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
Subject: [PATCH v3 07/10] mm/vmalloc: only flush the cache after the vmap succeeded
Date: Mon, 26 Oct 2026 16:03:26 +0800
Message-Id: <20261026080329.140244-8-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E92B280005
X-Stat-Signature: brmam19a18mwx4nxnicttok3xhuohfhs
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793001793-995255
X-HE-Meta: U2FsdGVkX1+RiuBvxip6SJ8IaAKK0D2SbKVcgQ1c1R/bgqv3TvwpOakCGuSBje4LgleSjXvQP+VH5QeNlDeea4ZPhwUvuzZpGciv5B/z3gR+S2nSAz6uwFzqkFXB35/Xpoh6NKSv7HwNO+mOKN1exuYVqG2VR3rNEHQqavEaNloHCA14BpklY8AMId+TNS8eaMuZVX5tTQSvkRyTak8wJ/HpS943VRv6QFN23qdLa7BjqMYJ+FqaPy8okxuUz8eUVwKf3WbA4Ns0y+2GtGd4FC4ru/kpCSOoxtj5wq+IEaGfTu+BbNVceg0QSTISo5j0XfxugCPXyLdic+sRlQZuR5x6tsdoKGUL4GfE9K17VFnS1rrlXhVZhsHOvNf7n5DYzN27nFH3Zj7/X9TlVwLiAfx1Jg6pbv8WAB2TzZzCeQNBJ/xia8z+Awk4ZvBWN0iGFPTWsJGSi9knV0YJIT71TmrXCr2zB+ix3Vyp0Dcpr4ZLa4+3fyw5Zw/CMnmxlR7QjTVt7zGdWi7+XgC4eksQ0ZxvrWBljVRX0cuc9mMyiDR5Ejh42793T7EsHsFdGe3vRLCELHcdjJs9FL37s1kp8WZuVfIEqvgKEiAzLMV+d7caCy9ykcM07Xo9gbsIJAMPG2rk54g07spMHgtkOEYzBP+rPxE3Xx35q5Uk1eXvyT7x+Xj11bPacVCzCmNydHTFpD/9Z788XX34JXkA+pd5Xm+xXJvSWxar7nYwMDF0Yh5vDrJvixA95aj1VYPYV4sRe285pU/l/nM/y97znqxbExamg1+8LsKCwIao4b0g+T1mIX98x9EXrLIv0aX8XwTBuonYl/P3jzoiMcR443VRqKT1/YpkkkZkVb/HwWt2ZxJYvEYaNkGBF/BmrykWfCLKunvaKoEeiN7zGmJ3bZ/xCAyIRulEt8WB2ZmPE7VljpveqMsupQgrkmaT5rrwGiwOx1ODeUQJlmd0ka8cTo9
 VsrglOat
 b/C2u3LsXfD80XoLFpGI2xZ4yfouz/BGwzKz8T8RX5fZOGBOotOi2R6vwiOxUsMnuZZia7UsleJprHkK0ceS3ZxKJKbgarR9/sN1aEvRFkhTS/sVBPTFCbzDgac9CNu5noESoV1AqfkVQNilZX3fNVmvQDyXiPiErSquC31Ep1Yxsc50b6mzoMzmlCSjAM+y6dDxfssQIVnR2DnbtcZFffcwREupb95IhOlhkYMdSEcpqWQKRsTyuRCXYWr5pHvD2Ih2tJnfpzepcBvOpez0gu2QgJ2gLpTEBggLOahOZ6cVDNM/RqrEqSrVzTbsqwAkkelVse+BJ0CwgM54=
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
 mm/vmalloc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 4d74144dfaff..96e15d6cfc6d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -359,11 +359,14 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 
 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
 				 ioremap_max_page_shift);
-	flush_cache_vmap(addr, end);
 	if (!err)
 		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
 					       ioremap_max_page_shift);
-	return err;
+	if (err)
+		return err;
+
+	flush_cache_vmap(addr, end);
+	return 0;
 }
 
 int ioremap_page_range(unsigned long addr, unsigned long end,
@@ -745,8 +748,11 @@ static int __vmap_pages_range(unsigned long addr, unsigned long end,
 	int err;
 
 	err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
+	if (err)
+		return err;
+
 	flush_cache_vmap(addr, end);
-	return err;
+	return 0;
 }
 
 /**
-- 
2.25.1


