Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5821FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 03:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5146B009D; Mon,  6 Jul 2026 23:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56836B009E; Mon,  6 Jul 2026 23:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DB26B009F; Mon,  6 Jul 2026 23:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 968346B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:18:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 115C41C7DCF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:18:32 +0000 (UTC)
X-FDA: 84960522864.29.4D1326C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf27.hostedemail.com (Postfix) with ESMTP id E9A1440002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:18:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783394310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOhO7aT8VR0S34kApFkK5Dx28QfKAVGWUIsbEXXWuIw=;
	b=NealvoYEf0JbLLX7sLYB1jr43km1lc6DY18UNLyB+3kTjxNdCKHDy7EgXdEl2tJtvMjRqp
	fBdgLMtR2s7M6mfLJ6a6i2urjE41x0OmEb4XCNVFnJbP04OYBLLFu3s16iQVpao+g4dpZA
	Y+hJ4AmuDVZWureGakn6h3ARvj00vcY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yanlonglong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=yanlonglong@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783394310;
	b=xZh8cO6s47LpIThTdRWhoDiVE9MUChvsAj+ZJbD5CcR8cop5/cfNmResYfDCwXvu0IQRJq
	WXg3PXMNwpq/ZSQ00IdbYNJjZjBMbnVW787qXvkEbqmDGMggksH3bFc/KnNm4g18lTrDBq
	PhMG/C2N98AGtac0iQAA9OqCY8UfSSo=
X-UUID: 808ee67279b211f1aa26b74ffac11d73-20260707
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:51ea2373-ddc2-4a0d-8919-dfb60ae5136e,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:8e792fd55241433fa81c38229c2845db,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 808ee67279b211f1aa26b74ffac11d73-20260707
X-User: yanlonglong@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yanlonglong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1096364418; Tue, 07 Jul 2026 11:18:19 +0800
From: longlong yan <yanlonglong@kylinos.cn>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	yanlonglong@kylinos.cn
Subject: [PATCH v2] selftests/mm/mseal_test: Fix mmap return value check in test_seal_zero_address
Date: Tue,  7 Jul 2026 11:17:45 +0800
Message-ID: <20260707031745.1039-1-yanlonglong@kylinos.cn>
X-Mailer: git-send-email 2.47.1.windows.2
In-Reply-To: <akuQbvgVR8vrEFvo@kernel.org>
References: <akuQbvgVR8vrEFvo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9A1440002
X-Stat-Signature: z19gun1ytwxu91wbd6ysjas5bug6qgsw
X-HE-Tag: 1783394308-241348
X-HE-Meta: U2FsdGVkX1/Ge0Ltquw1H3eEOgw6XZiBCbeV1265/DjZHDkJPyPJMZZWsGQwjB44o+bNJDhcG7ozEZ+vyQcTXpIH/aFr2ovR1YJ6nP0mFX6DRlpk3wHLvxZDyHjB9gg4cu01flCE8ad48O3DT6hscLhxJmG5VgflVZGVtdDFhJEQxB8pBRD4YINGHfK0E3x17fAWXV+PvuvGcXmRm8FFFFQB5uc0J1pBMog5TqlV6xAKouh2H8/+JIE4ZjOm5bW5zjBOxpgIB9CqXpHsQesuagyh0F4pbUImpkwAsKI0CAElN1BT/4awpm4LPteylssyZCa3JYXJP1haivW7KscFNBaBwx1CwBPw097myrU+Wfdk6nVBaMygG2Furm3Jb3gx8vE/Yu5seIXNi1Gmnp/J94VmE1gzzRpyHDGp5k6xo0Ghz2GfDZNNgVVY/GArUxfkKAAB0lxPn1rFvh5d75xtfiBaIqJD9weDh6K+gwl+dIQpxiMwwJ69kb8uFVLsrj88DFoQyCLPixg4nZ3SRpIpnT0webSLrtRrF+ymVqeGWNjDsMi6fkr5AHbHmfZVl3XlYo3x97tVoWNZbR7aQVRiJ8AAWO95A91A6+VV4tjLuSRSovGUZl8mMjZQDhWCkBWhp4t3QX3gQ5DnoEjElQqfJd4VdPbv9z0jdWfphbFffyDqdzfUmqTZ0+Cl8pga8VVJzRULO/wt+2fEwTPXJjwNPzVjoRUzS95Sx9IFOxUJziRHRBIuSSG/0y6Qjg6U3qgtPWf63GPDS99RcJ5Bpo1+IilLeAmfd85snZxcR2/c7oJxx71YYRomj6epu+fBodF1SPccGXaoPVvkXRr3EH1Z6ByOmqs1TSL9SceEQFJFrHxpCUZyUoAwCX3Nf4tH+y/ydzUf+H4Vy+uUK40Ak0/jyhRkE4rKP6LVPsvhGYTV8oy/yqobhtW42yWoQfenwA1weaH7aY+DuV3waNUwZV1
 AkYR3vN/
 u+pwpelkGNw69AOlbap6Ebw2HKJG5k4Ex+JL7IpQikaL3v7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The return value for a failed mmap function is MAP_FAILED.
According to the definition of FAIL_TEST_IF FALSE,ptr must be
determined to be distinct from MAP_FAILED

Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
Signed-off-by: longlong yan <yanlonglong@kylinos.cn>
---
 tools/testing/selftests/mm/mseal_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
index faad4833366a..277c8fda3f5e 100644
--- a/tools/testing/selftests/mm/mseal_test.c
+++ b/tools/testing/selftests/mm/mseal_test.c
@@ -482,7 +482,7 @@ static void test_seal_zero_address(void)
 	/* use mmap to change protection. */
 	ptr = mmap(0, size, PROT_NONE,
 		   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
-	FAIL_TEST_IF_FALSE(ptr == 0);
+	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
 
 	size = get_vma_size(ptr, &prot);
 	FAIL_TEST_IF_FALSE(size == 4 * page_size);
-- 
2.43.0


