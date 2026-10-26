Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB2D360A2615
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=HadoDkGA
Received: by kanga.kvack.org (Postfix)
	id BD9A76B05B6; Mon, 26 Oct 2026 09:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0FF6B05B8; Mon, 26 Oct 2026 09:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6F56B05BA; Mon, 26 Oct 2026 09:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9068E6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:19:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E654A0799
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:19:03 +0000 (UTC)
X-FDA: 85364832966.17.3D73EF0
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5032A0007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:18:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HadoDkGA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793020741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NBoEGBnT7tSwydHsRLRvuOQ+mNAaOzQ2uf7Uk5l8xaA=;
	b=7hAOhKYbBRw7ukto3yGVfX8nKMaeniLqlaDIY114gJtTj063oxT0KzFd+ys3L3RO3WbFkL
	C5xZYXhjrCzoj2g1rzYjFcElBdszrrMLpOcjxG494pBwGu83KX/bmE+pZNKTBmfdQtQyKo
	1MBqtVpwd0lpEvZUdqMBHzNiF5BnHgU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HadoDkGA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793020741;
	b=Z3C7x2JOtjMm0RKfl0a4RmoplaxGRrOi4dRPo12qt3niaHY/Z1P7EPpbYfl2EjW4hlp8Ct
	QlrRKDHKgyAjdNUgvGHGW/QgSMxnMLKycFoe1DlJroOzAIkO1ifHizJXfLZ2Uot1r/fNLw
	ZLJTWeTX8jSBliBk7vfxUq+c2eTpvjk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793020736; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=NBoEGBnT7tSwydHsRLRvuOQ+mNAaOzQ2uf7Uk5l8xaA=;
	b=HadoDkGAFmWAMLai2uUm3T7JlfLeQemCTwksRS6S+tn7tskHW63KrgjUOBt2EUk2dA5Au8PtX7yeKLqFKoGXTq8kmOcRzu+ET4iwyE5uuThC0Lyn8gJ5o+i5hG1lEbs/ghHY6Cie8dvC5tUSHo7W7Mu6vKBYY35SFF1YKVQ4ou0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XDYkXyw_1793020730;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XDYkXyw_1793020730 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 21:18:54 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: Skip zero-sized bootmem areas
Date: Mon, 26 Oct 2026 21:18:51 +0800
Message-ID: <20261026131851.9942-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5032A0007
X-Stat-Signature: r6he5hkjpqjhu8r3wox37udmcr7inbnw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793020739-383489
X-HE-Meta: U2FsdGVkX18w43o3Ua+TrSdVFEczVLrh2KxFfDfoqE503ppAGX/wDgL3VuG3LaP+/Xqz99xjfyulfxxFx5QE5Bezpjh1xoZ9I7+x/LhoqABRmywzpvygsPpbqHLaPscxqSrsh2gHUz9LqFTWnqwb+B5zIr5gLpCMt44J9KgF0F6x9XfDaGfGycMQxyLojjBK5WPqj0jqEIwTyLzdqIe/DpByCFN07hA0qs3kzvG/jSEnG8vxtMhR/sMT72Xk0I5y00lNI5o/aiPpAqe8AmoYKL9kkrUK0R+jDiBvFF485iBiYFUyIeD9ebiqqywS3oMMVFbYhC5XTB9aFwTrXDXngzuj/ngbStthX2nhywK+jIGt5tVMNLLRc4Diw3aZ3EASiRekWRYfuxg3NdxzKWeQGXpFMTQ6wJtw9ME2tFMOwjNNzvJPXg8wpMlzqNmoqZhmFOxmAcUWW+IgA8T9uLMUtnWgr8IxDYaYMcjfrC5Wz62sN1gQs5dbQCNRx1l3spZkG/qwa3UjJ4Yv1Lz1vxRycnlW3oAwbHEDEkbSsXXDCnOxJsqYmRDot1cJhTyr84MD5JQiGpLNdg2cYsi+Sxq0ahz79f3jI2l2oFHdwaXANvVvWYapapynPAqb+JK4/P6d8ljKEnIkqRZzaE6L71Q3B28TsbQbymj9vUWxIkIRjaxSRFcvTTUzCDdp32otAlG2XzDWO+fDsx/H+Q3Zp7CKFRCmwNkfrEaisIPV7+AibbeQ3D18/3/ZwQfd+KhZX+NCFOoD+g276IuUxs7AhUxx3SaOIaGw2il/BwTjX6g3vePDG8QTKmoESKgYRvUU9wqfwHno177pQwz0dE5vxblZGBvhF+pUA6KJr1+LPYP1jyFE4TM0NDeZXtdfOin93iSINNWB64jAbuCek7AJ5tOEOunU6XOmg5cOs+2fQUUFvhL+uxVSCTQxryvwsR28qS2AJmjVIhIf+ZTjNRDq5YQ
 V0u17cVh
 Uy1sLoUV0RDnNz7p5M06SM6v1j6urO+HO5LLSarTanjK41bPeI+5KaIAGgcFIn0yztpmDaxzi7Z0jWivvGvX8xR7wmJ4i3ce/oWCsLvAz/R3ocuTluAiQMLU8UeDTSULgoydKS14b4uRvWXsTpfMn9Jk9+zLXbDtsAdE0qKRNpcjkxCHlRQ3Mwiz+wqV4O9Z6JFo0OZ9Wz2mxWyVL3DIM6pS442pxCB7rLqbklTK3tTEoOX31Il5ODLcOsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The lowmem and the global bootmem area are reserved unconditionally,
while the per-node loop below already skips nodes whose size works out
to 0. Either can legitimately be 0: the global size is the scaled total
minus the lowmem one, so it is 0 whenever all measured reservations fit
below ARCH_LOW_ADDRESS_LIMIT.

Reserving 0 bytes still succeeds, so an area covering nothing gets
recorded with a valid address. That is not neutral:
kho_bootmem_overlap() reports an overlap for any request straddling
that address, and memblock_alloc_hugetlb() aligns a request to its page
size, so a 1G hugetlb allocation retries a free candidate on account of
an area that holds nothing.

A machine whose memory all starts at or above ARCH_LOW_ADDRESS_LIMIT
hits the other side of the same code: the lowmem size is 0, the range
below the limit is empty, the allocation fails and KHO is disabled
although no lowmem area was needed.

Skip a zero-sized area instead, as the per-node loop does. The
descriptor count stays consistent, as kho_populate() derives it from
the segment length that kho_fill_kimage() serialises.

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 kernel/liveupdate/kexec_handover.c | 38 +++++++++++++++++-------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6f1f55fe3..c9c9fdfac 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -853,28 +853,32 @@ static void __init kho_reserve_bootmem(void)
 	 * next kernel
 	 */
 	size = bootmem_size_lowmem;
-	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
-					 ARCH_LOW_ADDRESS_LIMIT);
-	if (!addr) {
-		pr_err("Failed to reserve lowmem bootmem\n");
-		goto err_free_bootmem_desc;
-	}
+	if (size) {
+		addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES,
+						 0, ARCH_LOW_ADDRESS_LIMIT);
+		if (!addr) {
+			pr_err("Failed to reserve lowmem bootmem\n");
+			goto err_free_bootmem_desc;
+		}
 
-	kho_bootmem[i].addr = addr;
-	kho_bootmem[i].size = size;
-	i++;
+		kho_bootmem[i].addr = addr;
+		kho_bootmem[i].size = size;
+		i++;
+	}
 
 	/* reserve large contiguous area for allocations without nid */
 	size = bootmem_size_global;
-	addr = memblock_phys_alloc(size, BOOTMEM_ALIGNMENT_BYTES);
-	if (!addr) {
-		pr_err("Failed to reserve global bootmem\n");
-		goto err_free_bootmem_areas;
-	}
+	if (size) {
+		addr = memblock_phys_alloc(size, BOOTMEM_ALIGNMENT_BYTES);
+		if (!addr) {
+			pr_err("Failed to reserve global bootmem\n");
+			goto err_free_bootmem_areas;
+		}
 
-	kho_bootmem[i].addr = addr;
-	kho_bootmem[i].size = size;
-	i++;
+		kho_bootmem[i].addr = addr;
+		kho_bootmem[i].size = size;
+		i++;
+	}
 
 	/*
 	 * Loop over nodes that have both memory and are online. Skip
-- 
2.50.1


