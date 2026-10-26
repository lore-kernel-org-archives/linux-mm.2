Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D768606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sc2ZjbzW
Received: by kanga.kvack.org (Postfix)
	id 976056B05BC; Mon, 26 Oct 2026 08:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927116B05BD; Mon, 26 Oct 2026 08:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864906B05BE; Mon, 26 Oct 2026 08:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67DAD6B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:23:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0432B1C2390
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:23:35 +0000 (UTC)
X-FDA: 85364693232.30.D37A843
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id D278C40007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:23:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sc2ZjbzW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793017414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzYW1DgJ4E/yeX7IrUcYKjM9itbq4nx6go1M1M0lFHE=;
	b=JTPteiEvj3MEiAbD1pmGabIRuwjoonJbzNzjF1z/MYa+/0RA0Yfbln6Ff4+aXxynXCSc+H
	OkQ521Mk+h9axrMnbxoMz2iNINSPm4f48pzT1y4U1uvbzbs+lHMxDIcb72K41+nG1Vjdq2
	PVxsAPlWPc94MjWgACfm6VsQeE/DLdo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sc2ZjbzW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=liu.yun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793017414;
	b=k/IB6uHO86oXWvG5A29uAFJ7PHloBUmKkeZdiWoAugv6xByxHi7utjRvXbjUvym9Jx/Gur
	kMesFe0B6IbN1PZdKj9SEIU29r0i87H6GEmRomFrflqeCv1r0Zdc/T8Vxzf04ucT+3TcMf
	UJmUkhysJ+QaAKtRstabHE+RI7C3HFg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VK+2jIdLGQdX/tQ6IpYW8SlmlBv+Tmuw767vR1hlDsY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793017412; v=1; x=1793622212;
 b=sc2ZjbzWUp+RQBM4LuOA+TLjGhTFc7lvq/MiC3wS1Ywaz5VmPQInFqOh+zUYRARG7qt707sB
 L4oKPjzUrPwujxLfoVk5evSsjWrwwi90zpUPmCKy1UOn3z2j/irCuGLtma6HFF4O3QP9+keHbe8
 i42yC7qfoT9Y5Cca2wfNcVKg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 450bc5343032882f;
	Mon, 26 Oct 2026 12:23:32 +0000
X-Mizu-Trace-ID: 450bc5343032882f
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: glider@google.com
Cc: dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	muchun.song@linux.dev,
	liu.yun@linux.dev
Subject: [PATCH 2/3] kfence: clear the pool pointer before freeing pages
Date: Mon, 26 Oct 2026 20:23:03 +0800
Message-ID: <16dd0366222031d0f5fe398926b16edd6e956e0f.1793017074.git.liuyun01@kylinos.cn>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793017073.git.liuyun01@kylinos.cn>
References: <cover.1793017073.git.liuyun01@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D278C40007
X-Stat-Signature: t61xw6cdpgtrdrehg5t78865ref97eg6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793017413-904140
X-HE-Meta: U2FsdGVkX18ACE3C5p7zig1W4VQBlSAxBiPOE3akPIupAOue7qWW8rpk6zSBctzxFkRsOuMoHZUHYVQ2Q4T0TSR2p+P6h3JCbgOwGpzfQYsvINTgKx1OzI7ws8sVpKz2HK7/MQT+Rzx9991DCuGw1xIuY7lSJx6epwHq5wh2WnTzWlBnx0NLXkOQrRMJ19cOpD8XVo6nF/1+6aihsfR3TQzBZYFbvzlg8IlYRdXEx7E1WfhyXTlfeyA0M13H86eK7I0z5ITyoQ+gT34EE3G3QuSHeBMZ+u2MR1f7NULp0jSodNbm9XcfWYPVV7vZawXlRwj0h9v8pLByjEwX//PpL78bLNgMr2c1D3UsSwwwweCVqzMCSiAW7J1aIVejjfPaZTeuMS0Y0kPjmN4kF3nXUIFpExXOXjSqVcvsZRkkFOmLql0wSFm+B5gsWQbWyNr5qK+8edo9z0OHrBUOGqeUt3p7WO/snC01D3ic93R/Rn54x0mJOfq1SrDmvZdHyX7jI59/0tP4755oYaUQqXQ/yyxl4+NRSDaySNNq67mnYtQN9BzvJJyGsiBt9Z3tbLHXkEFIJycIAD69Uz7pItW9aATqrvr5w23Aj/GdCLlmlKpycWeUVhSds5nraOU/3/BFiqKU1DKh+y3OOai8XLpc7gqN85iklL5xdLBYd+Hsr/xFuj3HTLo02bbQZ20rmUzO0ZHxJifSTTg/cXqXT1Ai+vyqxsmQhos5tX1I4jR1GXtA0U+nmFw1E6ph58AwRS1t7PGk/qeRUSiYnZTF1/r/m7VKpnimAq/y/rg7QrOzFXWEthdpsgvbTzkPd46UeudWH8g43aWZfkLQbHJicc8iDB0t8btLsepE7fOp2XO1G42FPB6F+MRSjLEs9l65odu/wsERagJPEXyXgN4SB00QQBe5xw0eV8Hml1TNw9RTjANJO/SLPab1Fzm6DW2+lLFYmYeMzgenR+tihG1i9pC
 j2WcU2UY
 jg+MMRIsPBl95dt2oNm39bcdaNAXamAMkUaHhcuScbvsl9aPAOjtkt7qTqr3AqSR8JMwFFnTwY3Hp1weBiK/K8Ss8HsWiC840acdRZHO+hWB7lBnQ8s7Ugr6K7wNr18Vb/fMKEzaTmtP3dZkE6ptwCUloeNqfhoLSw7dZn1h/AYxCcvdkE0DcwRfUNmjik4NAXQF3mv/UV8NNnr0U6VBU3g1YRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

Late initialization frees a failed pool before clearing __kfence_pool.
Slab allocations can reuse those pages in between and be mistaken for
KFENCE objects by is_kfence_address(), even though KFENCE is not enabled.

Clear __kfence_pool before freeing the pages, and use the saved address
for cleanup.

Fixes: b33f778bba5e ("kfence: alloc kfence_pool after system startup")
Cc: stable@vger.kernel.org
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 mm/kfence/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 6e3d01bccdf1..434df6cef7f2 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -1052,16 +1052,17 @@ static int kfence_init_late(void)
 	free_contig_range(page_to_pfn(virt_to_page((void *)kfence_metadata_init)),
 			  nr_pages_meta);
 free_pool:
+	WRITE_ONCE(__kfence_pool, NULL);
 	free_contig_range(page_to_pfn(virt_to_page((void *)addr)),
 			  free_size / PAGE_SIZE);
 #else
 	free_pages_exact((void *)kfence_metadata_init, KFENCE_METADATA_SIZE);
 free_pool:
+	WRITE_ONCE(__kfence_pool, NULL);
 	free_pages_exact((void *)addr, free_size);
 #endif
 
 	kfence_metadata_init = NULL;
-	__kfence_pool = NULL;
 	return err;
 }
 
-- 
2.56.0


