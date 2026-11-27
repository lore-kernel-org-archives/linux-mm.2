Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49593606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 10:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XUw8iuar
Received: by kanga.kvack.org (Postfix)
	id 21ADF6B05EF; Fri, 27 Nov 2026 05:36:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CAD46B05F0; Fri, 27 Nov 2026 05:36:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA476B05F1; Fri, 27 Nov 2026 05:36:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD7C76B05EF
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 05:36:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F37B1A0285
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:36:01 +0000 (UTC)
X-FDA: 85480543722.03.8796956
Received: from mta1.migadu.com (out-134.mta1.migadu.com [95.215.58.134])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2A8554000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:35:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XUw8iuar;
	spf=pass (imf07.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795775759;
	b=kuMHqoornJYpwcwKfkXHJun7aj/WQ76ryaa9w5qe4JmKWplCqr34HzGEMLrDxxKSOKaqn2
	C5ac0fF/uazYUMlg2jiIG0sxOynhC7+JS7ycrpd5iPmjj+OiwvSowdqK0KRnMqhcdroLuc
	tR/aYVaLqqfPaicW3KhfIqyAMMxOl0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795775759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y2KOKeiIfyxSJIesK/u1WwYHI71LQsR2gS1mkwGJI5s=;
	b=2wF27bcw7472ibRQupaZxJJ5tGhSLflqU0F++up+89an300SVdIeKrAumwHFH3c6GnHlkz
	CZRm0Hqpiq0NX+Ns7BBxbl3et/ldCUPhTMJJ148lSzmpiCsKqiNkH9R6u/l2pw7W6GUZnE
	3vx3t/atHuJod8N3lKGeiJzj4FiyGh0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XUw8iuar;
	spf=pass (imf07.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.134 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WK3R+kjAyjrrANwbj0BbfDQtP3nmbz0NgTuwnQur+EY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795775757; v=1; x=1796380557;
 b=XUw8iuarBbeWtf2+qSZ4m9+RRMB7K0y8fxEIA55gEa0kwAalf50U8U6KSeZxbE4bYkPFLGie
 56U2MwhHxlizMHdkW9h3Mka3GCt0lDQAZQhzZJ0RxML7IGl3pWxM3RCxt66U+JMDqf9O6WULKgt
 abu4YkI6sdgd4H7NrcOMAPbg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 48ff943b066fbc60;
	Fri, 27 Nov 2026 10:35:57 +0000
X-Mizu-Trace-ID: 48ff943b066fbc60
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Fri, 27 Nov 2026 18:35:46 +0800
Subject: [PATCH] mm/mempolicy: remove unused mm argument in lookup_node()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-for-mempolicy-arg-v1-1-525295a1b31a@kylinos.cn>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrDvQBLXgVaQLMxntlGpkoqKId
 zfa5Vv8v0NkFY5QZTsoLxIlDAnmkQF9mqFjFJ8M9mlLY+wL26DYcz+Gn9CGjXZoCl9S4fKcvIf
 UjcqtrPezfv8dZ/dlmq4RHMcJ6KfuqXUAAAA=
X-Change-ID: 20261127-for-mempolicy-arg-15d6c5b44cdd
To: David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, 
 Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795775754; l=1337;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=5MSzC0hzOvchbSbYp/VAWteLEBIQBRuO4WG2akPJ1Ak=;
 b=nEx8o2aDFTTR88BrXTSk4CBBgeQEo8SwHlv1bR6tLxr7H6PqNocaeU0oHxnEmbLUL7NIMM6LO
 u6dmQIcS65LDS5wxPcg/PiIwYtVEudgB5KnIRuBiQiK+NJ54wpgDnci
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A8554000A
X-Rspam-User:
X-Stat-Signature: uuzizhpzi7rgpf68br4fw4a4o8aye7q8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795775758-537528
X-HE-Meta: U2FsdGVkX19Ww5flX8aj4wGx1hpTXRsL96EZOc6XuxuPGkHduKD3FDVDGLwCSi0gtijwblFRN+CquC2ok2ODMSAJXRm3Kz2H/xxZoitL4YQBFVGUpZ5lBP3OGsyZYPz1DmzETRU2AgLTgnfje88uYXkvP6odfbR6luNfiLoSds7r/JEyGwN2QwIjACygukn4PBCasWrQAveLbgLSe7PegSe5bt0GvZgutbZ00LKp8ZaxaQcKQs4kC0p9fEP8PlnHYVsrk1wInoGtIG6okdHNhdC7BuAab8O7A9v7OGlTIpAPIizuV8iE9FhiKARVMlOc4kfYAwrl8xHneqU9RCv/OIPHIc9IWZ6/AWx47mThBj+svAji31XUvq0z89Uyw7ZoyZq5BLLkq2LKzerxFeWiOrTFkFD9nPAKp+NcsVx7yuF6iZYLuKCHnGf97TXGGgw7aYwHMRaswyt6wOHEW4bRYth+RBo/c9j/0tmaXC64w8G9/zs/ocu15m3cq156VP9/kwTjcgIPfEmRAQ+RZdbIUNGwc2AwzRH5Xkd8vLyi78uIWlXwlmXzCvtaf0gDW0z27FxtTGxU9h0IWUsM3Fn9Fj2/xYSgvFWYvUCsKnrLmzZXDHl1Rn1OP+ADe54hNmbN5JVUdvBPOjHfRGoXUyoUCLmd6+xuRzoXKsq2aIgy0Ixf8ehrpe+s8FB+BPAPGdBntzWv87cQnC5ImUG6ICZqJhE57VF76i/etYBv/EQdm6+eCVR1+vjE9hwzSzvnk7nQ800CfeDmJSkuzQyNKYMrau4uTIq4x6K2IoPm0obIiJG9nx9eFxhodfhznnLB1lHEVX1P2TIcNBEW3xYp5zI4MzTb+qDYpQffzce3/Hx5yxsKTel8yy5rmPOQ41DsouwUrlI7zP9xTkNj5xODhA0tasp8VP8Rd8/+nOWKlCjaPpQt6NcU7I0u/lfbis7yfIbyv8jWCCSRK3+X6msd66e
 tQdZjUV7
 lDzQfhU4Q+JaeUkAOATXr5q4k+nIXIdENJIDfbBLFFfsssiqQBrmN7Y5L9JWTGjuHmtGj1etvntqgEutzZxcsoasrrf+6DcOQDQ1TRRdEc2VsMyxDqTYgsLzpaf3dDNXjlH2vFFxyyuLBRayV9meUwIk9O3kbO90ZaciJ6xRYJvQ/rL7xrKkUkpk9r7PnYAaVzxOi/V4454+KRXzoYEFZ56PrLdqpg9i34oEcd//umwBewK4ibemkWfVVKJ4BmAGqJB57XwWOAukorvn2z5F4jfY7emR2eNHwrmxcRmYzStYUzSGzR6Bzt+piJUed27Rq2C12KJ9DnVvWp7kF+Rd+fBOdwGzCYswx+TGTYP+qIpN7f2fJiBhw8M6OLThDabQLcRgFzFgiFpv8yIR3OOAkNW5YgafgqSIjZhnH2/cYgAlOuTNjsPLRja87madFKmfm4CChYonIQN/T8/4qas9w8os9lvbZcDdYg4JmHDYk+BNXUP+2wy0qASPurbxfjnwnwp0UoHSu1deB2J4slhVRozG1Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

The mm argument of lookup_node() has been unused since commit
f728b9c48d56 ("mm: change lookup_node() to use get_user_pages_fast()"),
which replaced get_user_pages_locked() with get_user_pages_fast() and
dropped the mmap_read_unlock(mm) that was the only user of the argument.

Drop the parameter and update the call site in do_get_mempolicy().
No functional change.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/mempolicy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6528c86042bb..502621e82af7 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1156,7 +1156,7 @@ static void get_policy_nodemask(struct mempolicy *pol, nodemask_t *nodes)
 	}
 }
 
-static int lookup_node(struct mm_struct *mm, unsigned long addr)
+static int lookup_node(unsigned long addr)
 {
 	struct page *p = NULL;
 	int ret;
@@ -1223,7 +1223,7 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
 			vma = NULL;
 			mpol_get(pol);
 			mmap_read_unlock(mm);
-			err = lookup_node(mm, addr);
+			err = lookup_node(addr);
 			if (err < 0)
 				goto out;
 			*policy = err;

---
base-commit: 3d27e49eb905a5119e78fbe3d3890f376d15c728
change-id: 20261127-for-mempolicy-arg-15d6c5b44cdd

Best regards,
--  
Hongfu Li <lihongfu@kylinos.cn>


