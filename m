Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9A0C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6BC6B008C; Tue, 21 Jul 2026 10:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCF16B0093; Tue, 21 Jul 2026 10:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20AB16B0099; Tue, 21 Jul 2026 10:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F35B46B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:00:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8045E12019F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:00:21 +0000 (UTC)
X-FDA: 85012943442.30.E3C9DBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D515814001E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:00:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmnZeN6C;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5kvsTALewnJop1SQtBJM/PtaPw7n/wsahc/oz32/CFo=;
	b=b9qUQiXTJQi7B8oNPEV2uFyIIEN5Mbr8zg9vTDiijXYXLzIg6EN9555r5lLaJ/zcomceoj
	1wWyphrAl4kIivWBNs5T2/lBk7EbIjF+RhgtbuRr8zOTFthR9rf1j+K4VrGPU+HByiJ6IH
	8BzD56SOu0xdM9PjWMPBfT0tY5aGqMo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cmnZeN6C;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784642419;
	b=1ZL6UhooCzxjb55jCf2fK3apVByw7HBgGcGGkVF3yX+9TtGtOEnqNkYlVLq1d/3bNDt42j
	y90AB6GrNKTGdXp86jRGBrh2nfRaeP2nK1zxGTDUckWCUh0liJt8FGFynTDY3MfDy/x1mn
	W2Son/yUmeIUtr68ELlSyE1Tzye+FHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 032D0435A0;
	Tue, 21 Jul 2026 14:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC94C1F000E9;
	Tue, 21 Jul 2026 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784642418;
	bh=5kvsTALewnJop1SQtBJM/PtaPw7n/wsahc/oz32/CFo=;
	h=From:To:Cc:Subject:Date;
	b=cmnZeN6CSbqRir7FX072q6EIxo4sdd8KK04/wt2lC1r8iIc5SyY5U418lfkkn9Rne
	 m9nPJbyv/l64Zb/B1W2Dt8st6QX/AnuROpyeyQZC1YLdHeV0flX5hz7JTTrCBTGsgj
	 5HZfTq6KChBQfOXcTg/6JwuoxX4BS3vjRYbX3pgh1o+PamGyPssK3BeYTbFCjT9W9P
	 /WK25fmnEXFeZCMp94af628rY4Y2El7Kij0yJRS05U2oNHSAC51sMS8BmIPpU8IZdV
	 F/DB/DC+FMVkoAClJgstTIfcb1F14XQC6EV8y0NMcIFrBZ1usbam0EPZ2hAPydowwj
	 ohceOVmK8KVRg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Hu <husong@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/damon: update outdated comment about DAMOS filter handling
Date: Tue, 21 Jul 2026 07:00:08 -0700
Message-ID: <20260721140011.269802-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D515814001E
X-Stat-Signature: o7wu7aonr6hzcznx677f77a8a1qwupb6
X-HE-Tag: 1784642419-506849
X-HE-Meta: U2FsdGVkX18UpNGFLjX85qKuh7+F5GXvnxRPQHKY4S4Tee0nYngksM05rBtpgm7PQwdguGTUygzajiiprPi46niD+biDnOoLvQaZxqAbANsx04dS9C7eEprqgNFE/aZ7uMWDiG4cjbl7/oRFG4dv4u5iPjfpQVxUTtM4MN91wQEroN1prQr8t9Wwx7gC5C5O5bNCZCXSM/B1N0R/wFnYb7uHrWGbAZh84upUeIN9LwlRTMmkryHfd5PffltsXSlPz8i2lD7YHLLUl2sPg1gLGN9kRcay2s2m53M5aJgVH/X3P5qIEzV8D/b1nB3eeYaVDLwxlGbo+0E8ILygblDlbFWZVYmsDNdrvcvRKCX4uBqtmjEvEgDJEJCP8yPXIX2bne3nJtzxJdaFAkLUwrr0/XyVwfIdW0DOsoKZwiES7sauzPfq2xQ3ubxGgKOZObdSpfPcGg8Y2Efs4EW97hyncztcRkA9FBe3ZKr+RsnGiTSk5FPkQm/Wzze54ZPUKRV+kaUfq7ZylxeevwNQMVhvzzB6ow1tNxjZlzSROk65B89OWm0q9K5JMMiaWhmhAWUg+P3DMZ4CQZqjOGVa+3Uhzd+zotKV1QlhbwhgK1YA61OhwLkfd5xVCOZRkwjWMgmf551vGeGOP7jnPIcyj5hxWOElYyIAP860ZyVx/VawI66Qmf66e3UzUimACpCGgtx/D37+n9DhNGAQkshM+CUPLXRL8BFkqT+9+4x8hnBB8PCQ487VUoQJjE+Gak5AzIouYqHYkdmwmSxcVBgICauOt/d0X/+M04jKkOh3nEz9DIsajVEwcKupop2LmhPxouFXmK38bx5CgSgwk8OBKMzc/EO57kxEAfymvNuDwoPLGh4kvPgILKr8cH5HHKhh/P7w6BwRf65PAFMk1lkORG0DOGNtyi69FIxSEBX/pacFwOImguJuAgwD2n/jpJeXmU4mDPL0o90z8FKyfaPUvo7
 SAKZMpCj
 BvObkcAU1oXkRsnoM0Ok3/1servsvWszFB0SJmthpQf1gbhyjlReacGEIYNxgaVZoCHLj53c8wximgqixc6uFckUGqEOumbPpbSLzJBj/KwIgxnuMk43ASCLm8FOjLaZZP/v1xahsn/kseN0ClRWzG6oPVgqk8nmd0jQjbmObLJ0yVqX8spwe6OLRMlhS8sZci30EGeahLrBBqsJBZ5tmYHVcQ9W4FbLtvlt0NNt0GL/uzyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Song Hu <husong@kylinos.cn>

The kernel-doc comment above enum damos_filter_type states that only the
anon and memcg type filters are handled by damon_operations (and therefore
accounted as 'tried'), and that DAMON_OPS_VADDR and DAMON_OPS_FVADDR do
not support those two filter types.

Neither is accurate anymore.  damos_filter_for_ops() routes every filter
type except ADDR and TARGET to the operations layer, and the VADDR and
FVADDR operations (the latter being a copy of the former) handle all of
those types through damos_folio_filter_match() / damos_va_filter_out().
Update the comment to match the code.

Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260715092634.1450702-1-husong@kylinos.cn
- Collect R-b: from SJ.
- Rebase to the latest mm-new.
- Update subject prefix.

 include/linux/damon.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 327f534696aa8..0c8b7ddef9abb 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -398,16 +398,15 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
- * The anon pages type and memcg type filters are handled by underlying
- * &struct damon_operations as a part of scheme action trying, and therefore
- * accounted as 'tried'.  In contrast, other types are handled by core layer
- * before trying of the action and therefore not accounted as 'tried'.
+ * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
+ * are handled by the underlying &struct damon_operations as a part of scheme
+ * action trying, and therefore accounted as 'tried'.  In contrast,
+ * &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET filters are handled
+ * by the core layer before trying of the action, and therefore not accounted
+ * as 'tried'.
  *
- * The support of the filters that handled by &struct damon_operations depend
- * on the running &struct damon_operations.
- * &enum DAMON_OPS_PADDR supports both anon pages type and memcg type filters,
- * while &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR don't support any of
- * the two types.
+ * Support for the operations-handled filters depends on the running
+ * &struct damon_operations.
  */
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,

base-commit: 74f0a09e6f09bba55182c3a64bace164ecc0cc6b
-- 
2.47.3

