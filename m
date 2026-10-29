Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96335606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Cz5HSguP
Received: by kanga.kvack.org (Postfix)
	id A18DD6B00EF; Thu, 29 Oct 2026 09:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA026B05B1; Thu, 29 Oct 2026 09:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906746B05B2; Thu, 29 Oct 2026 09:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 709516B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:45:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1078803D2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:45:44 +0000 (UTC)
X-FDA: 85375786608.08.20493F3
Received: from mta0.migadu.com (out-153.mta0.migadu.com [91.218.175.153])
	by imf14.hostedemail.com (Postfix) with ESMTP id 57A95100003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:45:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cz5HSguP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793281543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wJT0qNivsFiEMNKsSij5ScAgPVWg2VVQlzOAywU4J9k=;
	b=Vp/fr5ulwRM9SqmjLLZ3bmkiYl5aBJ+Fp6aqrN9PLK1O9RMJpyR2OaP5AFMCqagNzRnXA3
	kT/O8Sbw0uDdia8HaU+auaTMbALIWr06+I8pG6TrV+rJwbm2xKwVH0hJ0IXxm57Uagxz9v
	093PplHIDUsALuD82/3etlV2Ugi7KZM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cz5HSguP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.153 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793281543;
	b=60s8yKgG9ZIKbbShRarILsgmnD1HR4poCQ9iU5p+OJZaAAhrdAT/yrcJI6SP16RdbH3EPs
	gg9nagiDh9w0NfG1LUvYGPw79kQijAHRr85G2932OcQCOE3dnGKYUvT0WeA9N1AJQUZVO7
	47h3cqri0NQKATjPVqVAKWytsi+qskA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6DYKw41ZmZGB0uwcA/t8yCtX3UGied1T2paRqqLwCDY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793281538; v=1; x=1793886338;
 b=Cz5HSguPR83KNma2vGPylNYYzanACosUzv6DCUd/SGnlh0nUQ1YEpmAV2GAFYhMsypRKUtWC
 r/AarEpJUNM5uMjxnJtfesPmAhA/J2cqH4VIPJFndj8ttSrTB5oX+w7s4GlAVlEsw+XhGSERakq
 NdDwWJSyLO8Pc/U8yGnrLDrA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 57fb9af743bccf99;
	Thu, 29 Oct 2026 13:45:32 +0000
X-Mizu-Trace-ID: 57fb9af743bccf99
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2] mm/sparse: simplify the vmemmap alignment check
Date: Thu, 29 Oct 2026 21:45:21 +0800
Message-ID: <20261029134521.62146-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57A95100003
X-Stat-Signature: tui13ih7nyi6z135jz3534swikztauq5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793281541-700024
X-HE-Meta: U2FsdGVkX19jGYXCaYgJZbYXIJBaextMClWwRWftF5+JnOBU2MyEb7pQWaKgMTWqN8f+GH8+ahhJzlNUZIsoHYdUawlzWRMiwcUTJ89A6tiP3gYjc7PtLza/4WkfrtzIr1s6+C0SrIT3+E8Sk5RA5sGoelIJoj0hO7o7fRbO6lzuu5pA3iocYDOuBDqxRAruLBGJqcJ2TX4II0M2N3sm8eKM4ZqIm+1SiMFUEdKdD2s4UZRTH1OadXF0uKHHkRh6qpMOTDMqGUduLEp7qnEEQuhbs4fNNRDTbxzoPxH9OqTbdJPCoEczyojZIWkFr+n/iz0GFadLdVTEDzPWoesIyTy+Y/DJbBF8+eHojeb1IK3oHmyC59ZQnNRVOGdfkvSDFq+Dtb3279ZDCPlQohLIMq5yHn4t4DbjCjRbYKDkpB+JLSyw6CP/dT4xtc+10QNK+WxNfKAu4lFMaEdFToGv97Wp4HRG5QjAgPNIdizUWhKUZY+5rNkjThcgJqysfehvG06DKWrhcepnLw5Z9r3gcVk9owKyxB9sx6u4kqgvmtCEtaHSqbStQplAsZAbxjBfKcdGhRA7h6gaiPoHxNxEmk5HJQLPqwZuV15tLOUwB12qkM6uPV1WqfpijZ/yXncJ6M88tb0tMcDjtQcd+ea0UQxyamko2jVD9DMtArKgUsJlMP0lI54uLKhROMUEj22noBc5rSgHsRlL1JX3VOFbh1Up758vPnQ7lXCWZklbru1Lw680ujqfvEWp1zUPgHPVTzb4Az3654cFnQ+Glc4Ao7ptHf0n9A+3Cm1ZqCpTpALgvipm8bT/YaHHGWG7tNXEOrd54IfpRo/Mxq3temnRCWZ2r+9+IJrT+qVsTgL7GXngHU/s5rSvoekRFezbLH59TIpQQCtfW+fXdfqw8/5/b84IWVmBe4KoL+WtBSQ24ST5/8GUE16eAq/5pVJ6Wr7Qk0E8TBCnXgqDY7x/Xnh
 1i0b8qz3
 OudNn1atDE7HrYbtkad6C4pAIbypwFWXURqzM29tUi7HZ7iWXd3hsEjHJkVSrIrUBLadicol2m9Mgrt6LkW7H2UbLSpJ3RhHsCdzjrwIoWEl9n1kOJq7zNrCDaP/RhMOGIPIjrZPwdivH8fRxut+S65imB8fRVCql9rrZvjKlLo3CeoOEcmdbcUp3q91Rl/oqq2HDWflsiLUHOzuR0CkfffBtf23EloQyiHAd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

sparse_init() is called only once during boot, and the vmemmap alignment
check is outside any loop, so VM_WARN_ON_ONCE() provides no benefit over
VM_WARN_ON() here.

Use VM_WARN_ON() and fold compound_info_has_mask() into its condition,
preserving short-circuit evaluation.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/sparse.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 6acb628c8a73..759b85172adb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -277,10 +277,8 @@ static void __init sparse_metadata_init(void)
  */
 void __init sparse_init(void)
 {
-	if (compound_info_has_mask()) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
-				    MAX_FOLIO_VMEMMAP_ALIGN));
-	}
+	VM_WARN_ON(compound_info_has_mask() &&
+		   !IS_ALIGNED((unsigned long)pfn_to_page(0), MAX_FOLIO_VMEMMAP_ALIGN));
 
 	sparse_metadata_init();
 	sparse_init_subsection_map();
-- 
2.53.0


