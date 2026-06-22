Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86356CDB470
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E14F6B00BB; Mon, 22 Jun 2026 10:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592A76B00BD; Mon, 22 Jun 2026 10:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8286B00BE; Mon, 22 Jun 2026 10:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD656B00BB
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DF41C088B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:15 +0000 (UTC)
X-FDA: 84907763430.29.B34A89E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 785CD10000F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfU+OCmD;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xNrJYEZHyN6uUA2mSDTyP7l+hkeko4b5LYoh0CGNL34=;
	b=3BgXmV6+HT4Bzgfidapd2u9Gp/B1sGFb+7VERgc+HQq9SO5oTRR7ly7btoT7y2mq6yIqTs
	30XS/DdXGZq1T7BhclS9/4LLgYRiaoPfu+IACP1cN0QXAnftuVOMC1e8cBf4qEAdwpwrol
	a7G1ePsDuFaEBtu8DD+yVUmlZK3BTT4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dfU+OCmD;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138133;
	b=k4Ld/EBiQRJ9908x4NAF92aL2vanZ9pPTJzPuY8c0efuhOGxQyzIGO3MpnGHqLTp3GcFkQ
	H1v4nSbm4hNRQoUeQw4HVWtNbmeVwFyD3hqRFhTeWevLFFSPE9O4T818wVOy9j+NjjlOZ9
	2r1twQw+0pI3pgjk3SO4ltXKiL1VhmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13F41601F3;
	Mon, 22 Jun 2026 14:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54891F00A3D;
	Mon, 22 Jun 2026 14:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138132;
	bh=xNrJYEZHyN6uUA2mSDTyP7l+hkeko4b5LYoh0CGNL34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfU+OCmDaxVZKRtX1orFdupKSlZbgcq8Pf0HOmShMK7Cj8CfbCuEtFJeEoH4xMIzU
	 ZTNzFI29KG3g/eBR3Kd/V484JrRBuhgFbx+h9aLfMFO2zq7pn7kSPpekmdSBEPbc1G
	 NGF9IxvyQxefnjL2sdPvbOKQUAxYTyIbNFRX21Mz9ewTMUMH2K1lRHrvbJtv4VHIsf
	 4Rmx8lO/W/x39DokyfrkyhWdvYPVHklVbiVlqa+jWqDbH7RxnQ1AkkrN80imlAieNZ
	 1a5GH3IQ96fnXJeGdHXFHm375pX0P13QLguYntWcc4vOiyNHjGUr0k6U/Yk5meGjft
	 tJA81EBxt+VIw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 18/18] mm/damon: remove damon_region->nr_accesses_bp
Date: Mon, 22 Jun 2026 07:21:38 -0700
Message-ID: <20260622142139.30269-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 785CD10000F
X-Rspam-User: 
X-Stat-Signature: qbyfz77qysw11pchmybz7zpsso3r5k6q
X-HE-Tag: 1782138133-289932
X-HE-Meta: U2FsdGVkX180TslqIAhitDAt92Fgnk8oRPcwhMr3A9mqiqn+SXd0Xz7CIzdiiTVlvWX166HB4d+5epLuecA6P/bNV0G9Rrdm2gJ4pR83VviNE+xFKOHzq2V/9jtju/Hzz+spkTVBsIIj5SUW6ec7nGEyjdB8zW7L805K6T3ebn+WKBoeyng9ZXh5Nu0Bnya8wU06YPD2QJHM/lkuq5j+7eMXlrrvFfvvBhbiFsf+RsWObj32DUTpcQq6DYB0i8GG564+/T4QohppVAhY2a1KrZCWoiovF4uR2c32HD8By+fQX2HXM/RSQzo792DlcMIo4LqZIVWRaMAClYTU7d6Ti6VlWc3oQAr3CJhtBxg7kGBebOoSoS2TZ02xGgMtbR/RK64i+uEdYp459g87yVZTAokOGPVBbu6ovxadWOa5Nq33+X2g2SXEQxFxNICaHTqKc5PcS6nDEGXJ2Xbsrr0xWSazHBzum7ZZ+LfkAVmm4DIlbbI0aIAD3j/wSm3/p/Kesg/Ff1YWEPyrBq+9LYIz7sKhIXpg44DYz2B3bisFv2ZKqHTC4hIaNM0UevIuEFxJIzk49PFFqZ9w/RGLRrb0L8cEPJgIQomMODnWwlD4y8F4/Qf2B7e9Tk43zWZBN6jisMxXe96zGb7c0yjH2O8SrfeI9rS3BUIoWY6nBlCxD+e+c+rOXQNa4NDObCdc5p4mS34Kts3OgVyooGb8GknqPF1Js+b7kXkwLyDSD+3r7pxXV1ifHtrG2WMrFUqy6HIf8xPGIYmvqjyuBwBhJjZusXIRjhFMUoEg76LpZH6gtUIRs/5xp0oMuHnnJvqAOJhe2qF43Lnkg1QYqNc+Kl1RPNd8tT9TCMBZExBZBQbdnRCFdjfRyiOzZkjwoXbBi6KVix9mz7mAwAbI9s5CG2MYTeSxdXi5NiOBsIEOU89Yffdvqvlynvq2ZUcCivT3iXzE7yy57pWK9mvitw7uKb0
 ypIwqVTe
 cvRV0/spXxp4N6caNGp6MtAclkfEetMtF+4AijXQ6arJbefQx2pjc1OKpfAoyVjbwWi8FEEbeFR1DSD22goEXW38fZSDGrTpY7JNuGS7YI2R/R7KXmw292IxsI0Wm9mhj+DkdCMpLONnw5/PXwTy/s3Cu+Ho5ODclWIqliqvoMJXEYT0zuq4lp/+IBksBRsufn08imD34RzaxzYzRqhrZVkvy9lMFy55LKFa+5HoG//YKtSaC3FVemf+7oTsWL7eJPEPQbsPpPNjbK8N7dDi/a+e17g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No code touches damon_region->nr_accesses_bp field.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ----------
 mm/damon/core.c       |  3 +--
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a09ee8a09b5af..fc3d467dc2e34 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -47,8 +47,6 @@ struct damon_size_range {
  * @ar:			The address range of the region.
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
- * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
- *			each sampling interval.
  * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
@@ -61,13 +59,6 @@ struct damon_size_range {
  * not be done with direct access but with the helper function,
  * damon_update_region_access_rate().
  *
- * @nr_accesses_bp is another representation of @nr_accesses in basis point
- * (1 in 10,000) that updated for every &damon_attrs->sample_interval in a
- * manner similar to moving sum.  By the algorithm, this value becomes
- * @nr_accesses * 10000 for every &struct damon_attrs->aggr_interval.  This can
- * be used when the aggregation interval is too huge and therefore cannot wait
- * for it before getting the access monitoring results.
- *
  * @age is initially zero, increased for each aggregation interval, and reset
  * to zero again if the access frequency is significantly changed.  If two
  * regions are merged into a new region, both @nr_accesses and @age of the new
@@ -77,7 +68,6 @@ struct damon_region {
 	struct damon_addr_range ar;
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
-	unsigned int nr_accesses_bp;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5b5375b035149..4f7954b383d18 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3587,8 +3587,7 @@ static int kdamond_fn(void *data)
 				 * aggregation, and make aggregation
 				 * information reset for all regions.  Then,
 				 * following kdamond_reset_aggregated() call
-				 * will make the region information invalid,
-				 * particularly for ->nr_accesses_bp.
+				 * will make the region information invalid.
 				 *
 				 * Reset ->next_aggregation_sis to avoid that.
 				 * It will anyway correctly updated after this
-- 
2.47.3

