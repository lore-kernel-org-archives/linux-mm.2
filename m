Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF8A606A336
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvQdNFRf
Received: by kanga.kvack.org (Postfix)
	id C5D4E6B05C5; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEAD6B05C6; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A629C6B05C8; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FAF96B05C2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21810405AA
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:30 +0000 (UTC)
X-FDA: 85460344620.25.603C998
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D25C14000B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvQdNFRf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294828;
	b=tUmPePRAE2mNluSc1xnPRmG0P+VBX5qazgGih8KXWDpNqKbR15G7LpPECHGCjxylAXBX4K
	s6OxBioEl6I1xI7gB0I6wMRw4rdDnIzhGVCqfzcqNL1Gwi0Jr2afJ4HHWh/7ItXjUAYe/5
	8Mt5su79xUGkgp6W6zWMs7+cONv+C2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V09JiwnLcA05u7t6X0137O/5Kf7LeJuHza0xA4+7tn0=;
	b=RYzSHPaX1tBfQQdYsSq5ZlZKWx8Tg8DizzjKhqbcHZYH8KPbJHb5CLg1THTRS/wW4n6gnl
	Ym9HDPFM/IhDahEH+IaPgZ6kRu44D/g9PMPag39VpJfauwDNI3e2/B+QwH8Jg8Y83l/nqw
	QX2zVcxFeApCvfzVdbvlkpuIWCB3ZUk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvQdNFRf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 638446185C;
	Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCD21F000CA;
	Sat, 21 Nov 2026 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294828;
	bh=V09JiwnLcA05u7t6X0137O/5Kf7LeJuHza0xA4+7tn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvQdNFRfiefDNqOk1+77DdyHwWvuNo7gY94vJUAYvYK6RQ8nIsEO/qpdUSSzVovJE
	 bUeFlw+sQ5zBfKjjm2DnQwP2jNMEYRXCHm19QgnW8eylCyHO8UZiQJjgnY+u8CQsTt
	 3MYGAqgaxV5cM/Eh+pDklbv+2qTdsf+H1OFZk3bcdsJuZ+3+AkVh3LFiQInZJ0nXIu
	 UEOFVKt06qbHeJ5WwNBSI7WvCa9zQyIkULS0Vs1bWLTpACUcdap2cXzyqK5mcE6rYP
	 wJXujwtydLCfzCtQm62PehDh8fhSwLhBwEp/RGqkTQP93N09iwNDjhyciB3i/SS4WA
	 H6Y45buHmdGKQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 20/27] mm/damon/api: introduce user_report report type
Date: Sat, 21 Nov 2026 13:00:04 -0800
Message-ID: <20261121210013.130397-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8D25C14000B
X-Stat-Signature: 4k7w3pq6kbt398z63p1e83kspua78wth
X-HE-Tag: 1795294828-918374
X-HE-Meta: U2FsdGVkX19Mqj4xXGJ3ctmjOxVhUQNj5Wz892qrt5+/7ijYcI94+682AteCEEH0rEvSfAn+FvWFPjnwGYr39DsuDmf95Ss/bkKaLg0uzFYH/xRK0Ip0t+lCwcyLKib6pFU1rHpqz89LBPsCTeJpowbX3utmjGrU2axtBOBWe0jW4s+Ejgc082EechVBv0bfy9tLtnCoKZ2IZfl1OvrhogLaXA72XlIDWeVHEPX8AHnMRbpO6Qfd68GVUkC8zNx71bIWmFoOMutxrr7ET6Ia6iUXtxaIA1mlBxydAfRwq47Pkw6/FGw79wJ3CYUZHHtYPBLlggGka2xmQbJX1txKziTFXNVSf40RlRpsym5pDHPf6aVShtq9eBkwsdFR6nOgYPJrOsE9gQmduQUIjajsp95/B9K9WONMvT8pYnU4bQ7Elrt1k0SSYdo1/5cpP6ad9P6rD/QhYXuAENsgAW3CQfJkflzkRFSCMvhZjOdLBPecPt9wCDwRekds5uMKlVWRFCCDPSVYAzV1q8mGj9DisyeURuXxeKe30fHlvNNqpwpzMMPGUOKJWGdMUZaZbVsIHj1Zd/3Ne5KzQAkGMfynbv3DzGUGxsgwsfs0xjpCByo1bLL0gqgHkd8DeBLxqEk/LD1hcHZjDUQwVLXARDwZjA4WwOCgnRnjmWSA7mOAt1xCsjB4yq1JJncM/vHHizhfgGFJuLmomp8CyXuSLad9Malw+m++03iE2VF/D7zsqqx2W3qRxCXNBZm1m2ND5Cp4Bd+nxPXiNxlgaw7yHUUbwIsH77YgYAxUYYPleNpB/q++kZ47Ax3bEFh22dkOGGUDTW5FpRRfqh1Az1KIA06kEz4KVP71wWgdEQu0WDsYTee90yABHHX0dIn5zUNFbME+PByWghQPNnSH5Mzzbve6kAQeIUZaZ3ZAfQV/7uv3E7Ur05RQtTCLGqbTaoN3hHlUGdXR8JFKQeM+tH3rOd2
 Bz0kgU5d
 JXy4CHOR5N1l8fIyfBlxne+VIofDto/KODi3aE6w54Q5X7gje5k5LT0AD3mg8dH7NfhwVk6H0DelJmHsIVer4j8ikYRAmiC+5IY3xYiZYn+y8RNjiYdiCmQusOOi5e5hYYYN+Z/5wvPLJpF1TFlsQEDPJXD1dCjmsDGQMH3+s4iT9+OZgys637restKuk5tLXiHwsqtgqKtddwB27W506LDMTfSU6Y+W/oxYmEmQJHqsagido9xf6x5Ybk2C6THdEFUsd0fcv7J091WUMzkacwibHPxuUyxc7ytrps+IMDmE31XUrG35oVINAFxeuBBb1s3ylvX44EuYdrlaMdQ+ZFCz/BpkfqFMmnUXVDkK5J+sYt9ioJ/tQ3D5uzTMAyOTRxDSqjqkBr1uJhyvROZduPOXXupdCDOy0wfDXcvAnIh9u7wC8zzoIVU3JAIcaFRgAjoGObwwtMhQ29xgujb9CObDUenX3hlg/wOq+XCW5LB//WFdmg8sw0nPTKuOzoiR03Cej
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Users could know some data attribute information and willing to provide
that to DAMON.  Introduce a new damon_report_type,
DAMON_REPORT_TYPE_USER_REPORT, for such user-provided reports.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index fc84cb9cf5bd9..ab7c362ec64e9 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -753,9 +753,11 @@ struct damon_intervals_goal {
 
 /**
  * enum damon_report_type - Type of &struct damon_report.
+ *
+ * @DAMON_REPORT_TYPE_USER_REPORT:	User-generated report.
  */
 enum damon_report_type {
-	NR_DAMON_REPORT_TYPES,
+	DAMON_REPORT_TYPE_USER_REPORT,
 };
 
 /**
-- 
2.47.3

