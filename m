Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA3F4606A339
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 14:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=luMnxL52
Received: by kanga.kvack.org (Postfix)
	id F24346B05B8; Wed,  4 Nov 2026 09:56:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED58F6B05B9; Wed,  4 Nov 2026 09:56:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E133D6B05BA; Wed,  4 Nov 2026 09:56:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF0DA6B05B8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:56:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50AA280746
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:56:14 +0000 (UTC)
X-FDA: 85397737068.19.867504A
Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F05020003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:56:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=luMnxL52;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.30 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793804172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rNNVTnTy0cTlwSmGHiRKlZ2iEy2+6bJGyVdMK3sWxNI=;
	b=fFp1Sa7NoN7W4zPCe8hAQRWGjmgLmRTLodKcxVgeQkJJq4HP0M3ciMhdvyD1a9DUJjm1ZH
	cmYSS051cON5Femf/vtcya4STyNMlU8r3H2gCA3y7NqYis5TNNS8V46PzrWRu1F6r+FWlJ
	6U7/Xgjnqx7r04N2Q2yPEFAER9O8b2g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793804172;
	b=AnncEQDvNx27wnZG7buOg4bxJdqZy9q19ZryTZRbBCcXGi7nRu6svwAPW+ZYNqz6ODmrHL
	DAbpA7OoZFUKP2HZ460xBFN7NwnJVRgoxMRvRePbruHMlRNr/Ss4eMtHygwr3AH/ZNjHj4
	luG623TYlxG3w/ttfYyXhsgFLDobpoY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=luMnxL52;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.30 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WiQsxdd6QhzAPp2ldpcECaeiN+cck/9lOboIQqVqld8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793804168; v=1; x=1794408968;
 b=luMnxL5285DUzIM2AnuE7vWel01YwA/GscQp5xVB+8cHNDMDiOZSJ1K2BKeLcoMm3HYtfixX
 PC2yI/o6bOXb/2ZmmM/rU7qTaqvh6WDG6BELEtTyoO1wlDlh+yhQfa0VhyGoHUarl54v1XDvkGY
 4P/osjJMqUFZVmeWRk762eWU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f8a97d86c29cc177;
	Wed, 04 Nov 2026 14:56:07 +0000
X-Mizu-Trace-ID: f8a97d86c29cc177
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	jbohac@suse.cz,
	david@kernel.org,
	hbathini@linux.ibm.com,
	leitao@debian.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] crash: keep crashkernel CMA pages reserved if activation fails
Date: Wed,  4 Nov 2026 06:56:00 -0800
Message-ID: <20261104145600.3708886-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: mtutgubeqb5jdgnfwew7k7dgpuz7gpo7
X-Rspamd-Queue-Id: 6F05020003
X-Rspam-User: 
X-HE-Tag: 1793804169-420090
X-HE-Meta: U2FsdGVkX1/DOaSKGMTYtDPFJnY/EVFiNwdENyYRJmZ6mHbjnq5uX4Y33KyNBIOTnRDgAfXXaKII6c6w2xR18SJE1HvqQOUGo9N69RAY2NkhDVfXwLM8IDgS1Q9y/uVoYAFTVtx6yDF0ZK/27llDqPK/IH3RLRkDUEX4+dsmQar9W7799twlDs6gJjkGl9YwMpMqLOy4tOSmXiva0p2A8D5r8PCPgXNtxmpOcKGVPgGcQBHGAAX33gbobt2Qrm0njS8MhGi6kykcP6HnDAtoJYIYrakIUEECGLD0M3cT0Uf2cRE5RXP/3bZWuDtzrkbU7wWQcYBW1ER4GD0yX4IrPM0oi9HHuZTp/kXrPn0us2hVyoqQx2j5IKcLEjln1gveffWlIjBNoCo/OWvDvEODkS6LdYheRfdIguV1HO3qJy8k+epnw55pN9bUdrzcOm2bF/CfmZcv2/bfv409xHVlhNQdlAf0c/kE/A2MPou8n4XhszG6T0YqsD+Qyc0UWsIFlamkceIq799tJIeAaovRfOqK+HlxmRsPAgUZvN8QOXSEhbz4/pcdL0wk3s5Xb5kSogeFj+1ujuKClOjN5pTcUzpbrQFKJb+5CM4Ra9kKpMywI242CJnjFRRWJ2OhYX1/DSY949SBHPIRTq8XAnJqD1loF3QWn4zZigN6wvHJ8aqZeFel4mqMJPWbtU3isFqXN4g6X34jF+AUI/A+nPKNWg9La/MoFztWvv9dMoRjMR2OdNXAL/jraSWv4vfzLZuDu6DEeVELXOS4yAGlAk5huq12Pwmmzn18mf19PKPxV65LA8iSEsJhohl5YeP9vpBnhpxVZbQaiyJQn5ymu72t2h5s3nyQ1Qo7F8B0HlaKzHzY/DV2pNnwgOmWjctMqmYe4CZqFifjHonXptvDw0a5vwNKikiyPMKR8BZoaNwhT1nh+QnxenQ7gt8+3kc77ARLj1L5MeHZQLFbJ8SbqSv
 IeyFy6zm
 606ADNNmzX77TM6VOPB6TskkdLiXXuFICxOIKmW4vh/HF2w+I+uJCf39Ibn6Rk5OmC6t2LUMLMK5E5PSwORvw4kl/uLq9Zknq7jjoULor5AudSIzmCq6+uz+BnwZ4YnWYZA0fxveZtA9meIzdTvo+ZQo/xqFPe8XH+R29lAo4U+2P7TmoA2RREU/buprrwICFSN6F4oE48ud3uim25dwXhXlgHePv/F5l8x1V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

reserve_crashkernel_cma() adds each crashkernel CMA area to
crashk_cma_ranges[] as soon as it is declared. If the area later fails
activation, e.g. because movablecore= put the ZONE_MOVABLE boundary
inside it, cma_activate_area() releases the pages to the buddy allocator
as ordinary memory. The range is still handed to the crash kernel and
excluded from the vmcore, so kernel data that lands there is overwritten
by the crash kernel and missing from the dump.

Mark the areas with cma_reserve_pages_on_error(), so that a failed
activation leaves the pages reserved: lost to the first kernel, but safe
for the crash kernel to use.

Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 kernel/crash_reserve.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/crash_reserve.c b/kernel/crash_reserve.c
index a03f0a4305a4e..a4b616ed49482 100644
--- a/kernel/crash_reserve.c
+++ b/kernel/crash_reserve.c
@@ -498,6 +498,7 @@ void __init reserve_crashkernel_cma(unsigned long long cma_size)
 			continue;
 		}
 
+		cma_reserve_pages_on_error(res);
 		crashk_cma_ranges[crashk_cma_cnt].start = cma_get_base(res);
 		crashk_cma_ranges[crashk_cma_cnt].end =
 			crashk_cma_ranges[crashk_cma_cnt].start +
-- 
2.53.0-Meta


