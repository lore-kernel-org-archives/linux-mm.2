Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26416C79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 14:02:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F70B6B008C; Sun,  6 Sep 2026 10:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9016B0092; Sun,  6 Sep 2026 10:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDA76B0095; Sun,  6 Sep 2026 10:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455EA6B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 10:02:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1DEF8055E
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:02:08 +0000 (UTC)
X-FDA: 85183501536.21.8AEB856
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4BEC940006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:02:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="SHutc/6z";
	spf=pass (imf12.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788703326;
	b=R0BzwUKxeaXffSjG5QZfVhFQUL3SI1rvkyDOdO9fi5zlxK1OGuIDydtJkn2ohGxWLu0O1T
	7P3uNnDhwgTTTj/qH6D6pKxq860Tmef/pOH9G793rnyzNEe2iKFp5QhzfY/04tVrlxiTRb
	2O4wpj7vIRQ6xJ8YBIq4p9COVqb+cFw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="SHutc/6z";
	spf=pass (imf12.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788703326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suuN1kWSuEppLRDqgEECSEVpoIC/3+Amdt3xt38Doxk=;
	b=KlVYvmhhRKx4vUIjNqIO/yqHptHIXdXm3bb18Ptqx2TiZnOgZPuMvvsD2iYK5OCDWRlqWs
	+jZXfgpG3rQDjI/+SRgiLFB5FELcXVITcpOXXa8Oc1a8c9rGmFjHHdHFLA63NhTyjFcBkA
	gFOj5NzFHOHD/VtjA5zGNB1VRneBgVM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=su
	uN1kWSuEppLRDqgEECSEVpoIC/3+Amdt3xt38Doxk=; b=SHutc/6zXLc1cVD5Vl
	CLdT7CGEoOSXrsMCrvo70k2VDA9aBZw5Wf3pvzZR+ObbzwrR9AnYAthncIym5Pql
	Eji+jAGCVSTTN70bNLrpsqjThiEPqbBEEfUurHPSg6E47DOQoNGufjJquqEht6NX
	A/XNNELwwi60pqnZIUecw3lQM=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wA3DJJAcp1qKIkSBA--.45087S2;
	Sun, 06 Sep 2026 22:01:38 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: yosry@kernel.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	stable@vger.kernel.org,
	xialonglong2025@163.com,
	xialonglong@kylinos.cn
Subject: [PATCH v3 1/1] mm/zswap: enable zswap_ever_enabled in zswap_pool_create()
Date: Sun,  6 Sep 2026 21:59:38 +0800
Message-ID: <20260906135938.3568108-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAO9r8zNPckJzpC2ecOew1B=MNbFSMsUpmHgVu=_D_+osFFVFSQ@mail.gmail.com>
References: <CAO9r8zNPckJzpC2ecOew1B=MNbFSMsUpmHgVu=_D_+osFFVFSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3DJJAcp1qKIkSBA--.45087S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr4rXFy5uF47JrWkuryUKFg_yoW8KFWkpF
	W8WF93Kr18Xr1xG3y8AF4IkFy5K39rJr47KryUGw48Z3Z8Cr1FvF1xKr98ta1qvayvk390
	vFs7ArnrJr15K3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pREoGPUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3AOup2qdckP3RAAA3j
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4BEC940006
X-Stat-Signature: 4i63pfooc9dwnqm919twshaxdpegscuu
X-Rspam-User: 
X-HE-Tag: 1788703322-599874
X-HE-Meta: U2FsdGVkX18Gd1hBCvNhVumkO0ibTVHdaieqi4NZ6q6djCQZrYK7VcrtcJCC0O8mbqSwRczl4fxM9Ieij8q8uRv1TiBcyD+EFLAWX49EfFD7hhxD5u87O6dM3vnVuuqMCN9N7fom1x7apx4ITjdYbT8fU4T6xiviF7VXUyw1zJxDj5cS7htrQ+vOLq/W6baUlAN0pZW8YyLH7MbM/0nwsoC9nbMC0dH+XCOJNExnsjFJANed7ySGZdDpymTQnimCXGlyZAHkbs/x94MRt6jm407m0Gd0BJw1+798qj7PGePI8jyoBSg0uEgywtoWg86TmqOaz6Pse19LLGWhJSEDjYHamnFdY6R0zVE7/ZpUn3RlUqHWJwl5Xl2sWzOt4BxdzWRyIMWMwwgaXHNa1MvIcJp5odiDubyVTiT7V01gre5SW5sFDrVI4y8rkq2nl0Y1OMTyyA1xzjsYw/ksZWqb9OEa/aAcydqRoIG9X3x3p0oDJINLkcuK7nk1phi1v8n+qgd23CLiupFkOlOP8C/d1mHPNdWuXZh4I3thoN4yRw6iqMvm7WPRm3IejPNUASEXDUP7q9n9RvrkNwxKLLGB4hRgBbCrAxNgFN9I77dyYyXEUN0vHPieCCPUp568cCxG3mhAFgH/+t3bBPzIQ7mP2g3HnI2PLV5F3CIHheCIxNWj2760kXNS6TBcFI1fXJLVDP8CovLI4rznhJFPstdl1CsnnwWsgHS7qR0vM+GpWFsajs5NHIv2YhOp098h7FD3hqgewAyX/DEfqr3TViCf5yXVQElCNvJEAsl4RDBGQUNr6H9a95X/XcfFE7CooeJb1rj7PkfURCuOKiRu5QO4uZcwhQLRNy6V9kcjmrhoutfoxeUhlSR6vmL5rXvZzmgxQ2/dGw66Q3vApPrPWHWsYf4UQhVjks1FZsVhs5KC9E541fZACjN8eHZX4D+Tm2MgyeUJgkjy9vlQL1HikTc
 YzEs2VOy
 Y035+aeY2Tt9oO+Vz4n2+mnBcHWjcCkRet1Cvt9cvbi5FZe9Alq5R4wnT1LYvC/JzXyr2C1rLi6K211DbD5qSVqloywB1paa+V0vaK2WPHP5i1XNrU5bTF3gZGjsT348v0/LD1E+v6EhQUsksGx6JCEUj1Cug+5Z9idEAbkE5sOveMMLNjTw0nMUA+1w6GtMyiZcDwKh5qhRuED2ST607qjFthJqBvXnifNaJ8H1pwV8JWKzC3FZjwbHIuLfe+m30Uw/IJpb30t2skQxnQZ4FcI9gtjxm1Ot/SgnpxLzK4ljbVBzzQlB36HBHc1fdv568tAKPPw/+HjPrMGRiUw5R5dC34g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

If zswap is enabled by default at boot and pool creation fails, then a
pool is later created by updating the compressor, data written to
zswap is corrupted on swapin.

Enable the static key in zswap_pool_create(), covering boot-time and
runtime pool creation with a single site.

Verified with fault injection on a stock kernel (compressor builtin,
CONFIG_ZSWAP_DEFAULT_ON=n):

  1. Boot with zswap.enabled=1; pool creation fails, init completes
     pool-less (static key off).
  2. Echo an available compressor name to zswap.compressor.
  3. Enable zswap.
  4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
     fault it back in and verify.

Step 4 reads back 131072/131072 zeroed pages (zswpin=0, zswpout=131072)
without this patch; all pages intact (zswpin=131072) with it.

Fixes: 2d4d2b1cfb85 ("mm: zswap: add zswap_never_enabled()")
Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Cc: stable@vger.kernel.org
Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
Changes in v3:
- Drop the code comment per Yosry, and add his Acked-by.

Changes in v2:
- Enable the static key in zswap_pool_create() instead of adding a
  second site next to the compressor parameter update, as suggested
  by Yosry; boot-time and runtime pool creation are now covered by a
  single site, and the zswap_setup() site is gone.
- Use the high-level description from Yosry's reply to Andrew for the
  corruption scenario, and rename the subject accordingly.

Link: https://lore.kernel.org/r/20260905125101.2970456-1-xialonglong2025@163.com

 mm/zswap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e3..3abcd8433425b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -324,6 +324,8 @@ static struct zswap_pool *zswap_pool_create(char *compressor)
 
 	zswap_pool_debug("created", pool);
 
+	static_branch_enable(&zswap_ever_enabled);
+
 	return pool;
 
 ref_fail:
@@ -1805,7 +1807,6 @@ static int zswap_setup(void)
 		pr_info("loaded using pool %s\n", pool->tfm_name);
 		list_add(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
-		static_branch_enable(&zswap_ever_enabled);
 	} else {
 		pr_err("pool creation failed\n");
 		zswap_enabled = false;
-- 
2.43.0


