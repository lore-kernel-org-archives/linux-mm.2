Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC156FEEF2A
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D486B0088; Tue,  7 Apr 2026 08:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65916B0089; Tue,  7 Apr 2026 08:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC93C6B008A; Tue,  7 Apr 2026 08:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF1316B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:00:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AD4D5AD55
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:00:59 +0000 (UTC)
X-FDA: 84631618638.11.181C253
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3912E40006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:00:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mqob4GRw;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b9UfGcLfPBkl5LZ6M7qHhMwuKYJ679JiDoSUGxGAA3s=;
	b=QltqE8ARO7slxxG6qYerE3IfXQ3VPxDMCkIXzw827tkE3Tp7rBFLixdm3/JEasbNfAXxfe
	8YCQIFMcxywhRhcNdxf5posO4kmysAR9rw8XNLHYPHz2AREPwsHkxeY8b1wpN0xGlG8RY+
	TLHNxRqnXe8LXeDftS/NOfF9X7GACsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563257; a=rsa-sha256;
	cv=none;
	b=rTe8To2rfhKiGR1NrEx2cjuQXQNcFBgsWxKhjL3satyEmK9IWyfeGV8L0ht/EYlnRTuche
	5Jiny9DrS0kD3p7X+8epymE1A92pj2reT6bXC6taka/D6M3W9PEGstBbo10X0bJXj2C3B+
	A+7P0lNGUI+8b2li/OgvYjvwb04Cato=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mqob4GRw;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775563254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b9UfGcLfPBkl5LZ6M7qHhMwuKYJ679JiDoSUGxGAA3s=;
	b=mqob4GRwftjlJYHxVKdz8LgCuBNjsj1eFTHvmEi5ZYhuIJdD8qaFzbOB3/nZDIVB/O0NBu
	4pNT0qDVrpEkwMyglQ18m0FIgiRdb/JjdCFuUt5P9onFaPuEPeWrxd3dRNx0s/jDiBtHDn
	dn0qT1RZ1TqpnZuXgm6wSJstxJpz09w=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v3] slub: clarify kmem_cache_refill_sheaf() comments
Date: Tue,  7 Apr 2026 19:59:33 +0800
Message-ID: <20260407120018.42692-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: qhfjgnknx4ir6ehrcfupkwf9nukajrjn
X-Rspamd-Queue-Id: 3912E40006
X-Rspam-User: 
X-HE-Tag: 1775563256-205648
X-HE-Meta: U2FsdGVkX19nCwqw4IiF+4XtsRYT9bba014fy1hUr3626dHKd+9F2tOCr4wxS3gp5bP2NGbGDHAzmgCgmgnZE5DoagkNkxx5R7oGwZ59K/7zfn5g3RtLEVvBHzWfjNL2QWef+g1GRWw/0WVPjX2tyvanslnFlzw/Ry/WIn78+Aw8fGDTTl+hkED3zpiFiFFoJLJm3IQgBIPpgR0ZAjI2OXzDAp82iFhwTXWNSWMf3XnniodrtJVClOGy73ZumH6hsm3XfF7jsV0UihZQCdUsY+J3NU5QxB//SUqe+oXqh+C4OJts6ypW0uaEVwP//CkGXDYoRCxgrvGI1L7xQ98WfUxRfaxyPJrCldoo+yHNZU+hlqCZTKViz4YGMNa06XiExnzGRLYvKGcBUUGPMhGgdPuq7JcisumGG/JenZ/Z68OcSp48x0JtEVJpY+9mBjccaTelQ0VyTiiw3YqU6KXRCMADqsu4Q9pKotw0HfSx4m6QmEuFe7Sm2qYPKMpXOs643sgxHunU7ammnhymUBN8L8zuwlzx0p+xy9XqQSQHWo0vcxmSuaMOH+7U3SB7mUyqvOfQkgSg3t5wH/4oZKk2JHM4RezHNH+oTqRvPdsnEawvbN54Ac+N+kwtRZTTkZSmyPqur5Idd0c5Fo0lxygPanggNF7dToyrtsKfH7PIJDwbexgmMVTuTZ9URxgHpYQHCJkL4yojmarxwmut99HzkGXsLNN4C871AnYYXPkT6+xvcGmh74rKqrYnGTdrGStAs6mNWX4h2GaweGx9BS0g4W25us95C3pZD/HTYWaOsRyHPQipQZhxxXPtP9b8eNDtarSYGg8tsBg43qRaNQGydP+fQMfdCMjTzPAvyO8RgqflMm2tq6NBsFWsoxD4m3aQ/xrFM8fb+O6/6posWkuIfDZW0BQ1xOjRmj45XXYbHtn0d/EL6Pc48xLMtIBnLGZFIx7XNQlOO2h0ao6gVjl
 ZRABCpKo
 nLdAcCr0uohcjJZF+8Zwd+U0gQl9t/Kj8YccXT7W+2T6Ofoo65Yd1dfn/xzlN2OJnpiEuRLn2Ri30LklM4bf3/B8ZuYLUqQqlxCAJo0fn/1MInE9F/Vf3ucgS33GiedeI4SxBL5wr44C1VyeHO6Mnw81Ccv8rilRhy7nFvOnTRAyZMXTjppW3CzCmwV/dJcNIVVRoXfOl0U4SEb7AIKMM64NEuAZBMIREb9Mz65Z4ek2UJMsL4T42YuEHMjIjSZz53nmmC3FxqadJA6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the in-place refill case, some objects may already have been added
before the function returns -ENOMEM.
Clarify this behavior and polish the rest of the comment for readability.

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Hao Li <hao.li@linux.dev>
---
Thanks Harry for good suggestion!
---
 mm/slub.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4927407c9699..92362eeb13e5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5120,12 +5120,15 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 }
 
 /*
- * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
- * the given size
+ * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
+ * the given size.
  *
- * the sheaf might be replaced by a new one when requesting more than
- * s->sheaf_capacity objects if such replacement is necessary, but the refill
- * fails (returning -ENOMEM), the existing sheaf is left intact
+ * Return: 0 on success. The sheaf will contain at least @size objects.
+ * The sheaf might have been replaced with a new one if more than
+ * sheaf->capacity objects are requested.
+ *
+ * Return: -ENOMEM on failure. Some objects might have been added to the sheaf
+ * but the sheaf will not be replaced.
  *
  * In practice we always refill to full sheaf's capacity.
  */
-- 
2.50.1


