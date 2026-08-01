Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971E6C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 15:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A216B007B; Sat,  1 Aug 2026 11:13:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F41A6B0088; Sat,  1 Aug 2026 11:13:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC796B008A; Sat,  1 Aug 2026 11:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02CAF6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:13:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EE1AA1555
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 15:13:31 +0000 (UTC)
X-FDA: 85053044622.14.13ED73E
Received: from out203-205-221-236.mail.qq.com (out203-205-221-236.mail.qq.com [203.205.221.236])
	by imf15.hostedemail.com (Postfix) with ESMTP id 663C6A0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 15:13:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=tePQoFKs;
	spf=pass (imf15.hostedemail.com: domain of shijianlin11@foxmail.com designates 203.205.221.236 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785597209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8KJpPgs1pFmPJSB2oTg3KxAlZCQDx3NADdq1AQIhHg=;
	b=LEA+68qKBmOXISK6h8V7V8pfDThdbRleYck6BhTmeG/97JzKGCXpXTfPH1j5Gs4fOat2jn
	vhkEr1EjbJ5F884j97ytM9WqylrOUumCULWoDZOrK/MGVLMs5dTWC3p7q4uYPjp8Svao0o
	nwRJ0xb7MIridjwHBJ/mc8tA7/bbuZA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=tePQoFKs;
	spf=pass (imf15.hostedemail.com: domain of shijianlin11@foxmail.com designates 203.205.221.236 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785597209;
	b=NUMYnGQKl3b9eI+Zwfsjjz2brEVeo0EwoVaqBbxW4Rgpbfw5OdnJKGQLHI98MWXNchDfiK
	UVIlbkoEzwhh0X/BAMa3fvuHkgVR+TdUEmJ4JGmmPfpJZ+mUnzJVF8O7V6zutZwJB+bmuh
	XjXbLX8XCzuoZpSOZlkh7VnRGiA8TS0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1785597203;
	bh=L8KJpPgs1pFmPJSB2oTg3KxAlZCQDx3NADdq1AQIhHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tePQoFKsYJfzp8kh5ZTRYrmdQVRSKyfj54FmTCCdbWc+kZKWiaacMIZeHhRjZO8Nk
	 z2bM5z/Kykn3XGdLVQVMH/XqwweIXb3MbrydBKHbhvFPYLfRh3KRQRmSxqog3FSPz3
	 AGJ4I//AHZpaTwCexVaWSnMFgIpHu9qLWnQipMNY=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 35496495; Sat, 01 Aug 2026 23:13:20 +0800
X-QQ-mid: xmsmtpt1785597200tvxm2mojy
Message-ID: <tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com>
X-QQ-XMAILINFO: NT7uTz3cNku29fmGKhNOjgMH5Yv9qyArDKhTzIxjqvuMZVUnIug0IEOmnI6HLL
	 Xc3DwecFRJeT8HT5mjdrGnB8B/orChHopaUErTbdrv4OxETuSe3usR4MPnYWumrTeD26/VfhqUGj
	 3k6ZYT/zt/rL/VaUvYLrUjNtbIQTmYfMEmpzgoVLZ/VSxnNVv9SG4ZJhP3Fn1a7xhB+rSrMHZUVT
	 YL/OaNroemiUA9gx7MCt6NvGlpJMDC7f9NUMSuYrVDenIuy5HKSLbGMshLznrXfAlfTCpgqWYiSZ
	 T2WZA+w1A9MznBUImMcv0HhmRDzArE8Px0Lp6zZCtVpFsNZAhrtrl/8HmDB6pPXg4N15sUpyqA/0
	 K1NeYv3LBwAefjS+GuwO4NygfFMo6EDg2t8McAXMb3ILFsBMjZI2D2jnsBmLX2nrvRZtK7mCTr3V
	 tPyDFk2GuMty8sEXxXlxPgmGz6rVcusLtWpo4cFL9W+YpfYXDCCW9SGE8tNp2qEgWj6/DTXLHFk9
	 ykUb8Zv26xXjvnp1lB/wvFfL4nvBeML3qmPaBkFFGT9TmfqOyMo0vJgDA4pI5/n2h990Z6hvr83U
	 fGkZnmN9FMwlhpLLD+EFSC8OHG/nS6tplp4wh3mIbcu+vw/fwli7PD2/CV6JgS6MciUABr5ogD/9
	 Oaz3/RjDNVTyNvdbsryxSCNExsF34H+KRp2dcIqEsHjwb3Ol5jeLbEYzEqy+k9faOdtAX6fFbA2G
	 ps/665GQdFRYLhJ+nwW7780qlTNoaqTdmHyzmTX5yS28pTKK5CoUzBZ3+qO+Y9zdLDEwVrvWmoxU
	 Plxbl/Alq/GbhUeE32/yVjT3vQDsvXqPIY7kmOIkgL6FE2bE5d5PNvdF2t7fQFgxH+TrisAcFhcu
	 iW/67jL4v46t6bBzNtBaTk1COfKBlNacScZ5Wvh3ylt7EAeS+LrBrRlcRXUjevl5t2LM12/nJ3AI
	 0M/sFeTelICiUww8wrt8d1uD86mjtI+hy7+blVUIzPxbcoYTsqBTHipjLvt7QYjWhAKVGlHz5fgZ
	 mhMaRi4TDdGVoHjwILe56AyG05fOJzCzDr1z2sIOlYWrIcqieY
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	hannes@cmpxchg.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Sat,  1 Aug 2026 23:11:25 +0800
X-OQ-MSGID: <20260801151125.50603-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 663C6A0003
X-Stat-Signature: uryox3yzog83q31wa6ahjicn5fhbf46u
X-HE-Tag: 1785597207-14620
X-HE-Meta: U2FsdGVkX1/jGiVCRY4coRQdxazXg/JhqcSufgpEQNKMtqsZOiyfNxqGp1Cz/WzSmjVV1icBoP4TM/T1L6Jp35SxTKVfNlNJvpbVjTZBqj6vMkY4RbwCU7AG+8ChXw70gUkPk67S/cr99Hmu5NyhBJ6IGRArJLVy5Na+njURMhiOD/NBl2pBtKOKxRVnntpov6h0r8FGO/DnArAZI4GsdrMa49VENOt+y6lM1VAEJ38dq6P1MqGbcZJTJA3uNHvcwYlzXs6nU82k0vGtZJNiKbUIV0nVVfETWNsKeUFm6/zoIOqtnSey7Wu4UcH9AftXNHuR7P5SLpZh+FBa4xYH7l5pjyH9jtYnRD/cAKBT2R/fLWMsQK3MfqIkKjD4TvdSnt9UasKcdUKEBICZjtRLi4Iu3gNZibsnrHUzDF+fgYrWXi9/woa9W0wIcdXB5kxTHCFmd/HTT02C7kQYEZu/20I4keoYM7xqDREkmnLZjgWDSNaRNnBxlX8dmKNaGKVPfDxVILY6dOva6mFKXlI9TNTKBNDMi5SI8eKpzjh3EBFsBhsR7cmA6PmxzqtGo8joZh5lybcguggkqifow9zO++lpF3r4uydEVBPvWeiyONVkKPLRObVI0Bu5U1EKemyvOcrDV7FJLENjsCGQjmO8XOieVZ+IJBV0LWhGBeFqJbgUT1GpcarJ6uq0AMh2idiSSJ8MAcECN2vfV2Tj/n/mY06HF85F2+3DAiQCcZ08u295Y47ns964WtjVYLgU2OUWh5bV90VSfFOCVdXwHXF85cC09nAOZdpAcSDNTOlnMkt0fRe7y1j66tz39ZIYd0vzT9J6AWuEDYgSDUxFaoLglSVUVQ8VVijF1kVtX7Ppb76rktgdsv8pf+Jj5tTgg267BVcpv3NBQvgJxGZmUoI0/LZlCTPY4q99rhNS2ILs0WfFBz5tiwU789bf6kxU5DmIFU1ROv3mWT/6oarf6xc
 s5Agk/jh
 oBwIiUe8YQYXqyrapJZepQhwG3QbtQuANtSlzfo/OmLrEqKJu7OIhfdgtTHK/+cP1dr3BUd1qcwOGAfdoGngBRvj082o92pR/XxNaHam0h+SAtIT7nD/rEXAfAC4yFpBZ33yB3C1w+dO7dl8FW+Xrud44kBnXSx6IoqdW518/jWqH29IUwFAJL9LWjStpTDa8QId1HWdj+qwm5BE9xxP9bVsnn3OyA7/Vo3ur+Mxd+ITpMdSTP/18SVwn73+IE3HkMKNvligXJpbYVO0PjupNCOTKAP9JWtnrIOQA09qDDZHsJDEstVRiYUg/fe5r69GYC7vvtA/iZHCcToLoEPZVIeS4U1siCVXd5SiFc6oMakLA5A3EA2Np8oL/AtfUQGL8OIHLY7UpcIzKPXYxaWKGuCv6UeDJf3gzg0/aRzWa6BGUXA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lowmem_reserve_ratio_sysctl_handler() ignores the return value of
proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
even for read operations.

Fix two issues:

1. Propagate errors from proc_dointvec_minmax() instead of always
   returning success.  For example, writing non-integer garbage to the
   sysctl now returns an error instead of silently succeeding with
   unchanged values.

2. Only call setup_per_zone_lowmem_reserve() when the sysctl is
   actually written.  Reading /proc/sys/vm/lowmem_reserve_ratio should
   not recompute derived lowmem_reserve[] and totalreserve_pages when
   the inputs did not change, matching min_free_kbytes and
   watermark_scale_factor handlers.

Drop the manual "< 1 -> 0" sanitization loop and set .extra1 =
SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax() enforces
the minimum on write; negative values now return -EINVAL instead of
being silently coerced to 0 (suggested by Vlastimil Babka).

Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
---
Changes in v3:
- Rewrite commit log to focus on the two tangible fixes as suggested by
  Johannes Weiner.
- Code remains unchanged versus v2; retain previously obtained tags.

Changes in v2:
- Add .extra1 = SYSCTL_ZERO to ctl_table entry
- Remove manual sanitization loop; negative writes now return -EINVAL

v1: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/

 mm/page_alloc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0387d2afd..a7381327d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6683,16 +6683,15 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
 static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
 		int write, void *buffer, size_t *length, loff_t *ppos)
 {
-	int i;
+	int rc;
 
-	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (rc)
+		return rc;
 
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		if (sysctl_lowmem_reserve_ratio[i] < 1)
-			sysctl_lowmem_reserve_ratio[i] = 0;
-	}
+	if (write)
+		setup_per_zone_lowmem_reserve();
 
-	setup_per_zone_lowmem_reserve();
 	return 0;
 }
 
@@ -6791,6 +6790,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
 		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
 		.mode		= 0644,
 		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
+		.extra1		= SYSCTL_ZERO,
 	},
 #ifdef CONFIG_NUMA
 	{
-- 
2.43.0


