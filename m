Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C594606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=drBum+B3
Received: by kanga.kvack.org (Postfix)
	id 40AE16B05D8; Tue, 17 Nov 2026 21:22:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB136B05DA; Tue, 17 Nov 2026 21:22:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20DE66B05D8; Tue, 17 Nov 2026 21:22:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB6066B05D7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89E821A061C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:43 +0000 (UTC)
X-FDA: 85446641406.29.D92192F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00072140007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drBum+B3;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlae4a7V9R97zMrEaNBWgX7mTwWMZswJckc2kKiXm6o=;
	b=HTRuUhGtxIsK2UYUBBxwfFKL87Ze7GjyZhpo7WqrmaLvgR73MdMDqbmkD4JbTDx6cJI1Nf
	KdmcKbuJv6a7Q+aGdRFy8Vi9Z87ko2rzeTNY/9FpDYFbYQE7BtgclOTPhoSa30u2hg7G8t
	8zfmHsRxkkc2WDHZ0yCz5wWVBQRG9kg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968562;
	b=YsNITrVVYBr4qjou9TPX/GW7OTxKoyEgKoWaCO6pkt/jY+DKvLDUyRkjAiIaIOaXdOFLRR
	gGbnty+B2EaalbBGxTMZuXXiHezxBDqGPHbxm2mTCTveaOSxuo9ZUHOAVmtIaBZNQg/4ck
	LLgtE9EwBONHJJAGGzdnhAQqjGNCKfs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drBum+B3;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D294C61B16
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7C71F000C7;
	Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968561;
	bh=qlae4a7V9R97zMrEaNBWgX7mTwWMZswJckc2kKiXm6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drBum+B3Y0XcHAYkyTKnN1X/Syvw9Gr739WSHwCzcqWKDtRr21TQv5pr4eQyOLkr5
	 SwpKmDVYFOYUD98T4KzMAyoyzWOsm0vETHeIAkpM9HcuzBld5/kJj+WUYWiVgEKenS
	 oJELJLWrQJNGJyv/9xmLN2bUlVD+KpwwNhsZjZEFv1MHsouNDFapjtwUGr6Bz5SAIt
	 eVqjdlzLl4fA16/EASL15TzqbptfEMCDaOXqBv7qXsUOm78q0C/c5F7E2VUonLMVuX
	 FjMhzUaIZ6nIT7PtnHg7bI5cJ0DBmM/R6qR3Yxna0djdBT2+jbR3OCiVOh74UG2uMQ
	 tYgcUvNVPUhGA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 27/27] Docs/ABI/damon: update for user_report report support
Date: Tue, 17 Nov 2026 18:22:22 -0800
Message-ID: <20261118022225.100659-28-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00072140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: w9qzcddfuipqs61673kd7mnt6exbtzi5
X-HE-Tag: 1794968561-405889
X-HE-Meta: U2FsdGVkX18yz5zYIibHYRfz+UE8v59levfHxTEKGK8Yw4foLOqKkhZyJ+v6nwaBTWOYR16rO29pXTohN6LNJgR33VI8AG+4//MJZ+/Q2OaI2iQbjsb38lgf4R9yAlN+3R52htCDkb7TKtNwIVxqLaRXVWi+cWLCbQEtVF8ZrdGPlJwnB/VL2pMXVEn8iGIaNoAmF6Q1cGZKgHOIuqbcZxYZctbg5xpTLmX5M2dmX8pfg4EIt4ct/FT4hqYfz54wtAd5Volv9CHONmnO07c6+id6Y4ZF8+WzFItBdSRnTwTPEtMA2mr3DUrmpODipABh1lIjaOmdvCy6pfADMC2AcCzmkw9+5WZ2wv9DQZO9ulneKPJ5uO/RsAIuOvKZI3EoVTOKPgrEur5sVXi6HAANwUEXsZZaNYlajS4uLX+cCWarsOdyM95loShdJnHXInPFmh/6K7kGTiqIKrY1UOplvGeIEICmrf/p2G+uLuWe/hVnXbf67VmhAXxlzy8oyVVpEHi4y4Im6+6J9G7ymujRguyB1ggqqb3g1Ed9hqj8LEbYYKPgzQ4OiyOLIma7J86dkpRt3jAfxbPxqaiQ8xEHNMb24M02CGqidw9T1HXAI5jAWYp9g9ab5GUuz2AK4KzHNZyIiKQWJKFIFYB1L+/hE1hZUIUSePxFlD+vTKWQn82+2Y93lkQptbbKvkR0lufnfEqlub3eK7KmVkp3mOc2a+o1bCGQNcAl4RZBQQd6rQi1kPi4OsfxUd/Lk7fbzNyTVThDUbqPYc3WdsVuJnilPruyUf6G/nuMzEyCr7P6L4S2fRxUQMzr41bIbdnLDJ0G7pq5vWkbTp5EpoO23n0WTXcW3XwUlW2ph9cvl+wim+YO9b+MmigcQ12XjUVUDGw+vdAYQDCQ3OgQyW8eLHBi2gz9gZiXOS0jpBKnmEIzZBzcEYsFZ6cVUAk9Q9m5aTzVj3VF8BWTCOlIU96hib6
 k4ktv5vh
 B0S4y+tq7SMlJz3zJWn5+5hsxm5JZWGNRFBHEGBTA1+lwqjmcrcguxT3EEs7MuzTK1p6tkbIJ4WTvo+mdPvErk+bXiqUEpJlb1m/UuDBccwu8lbsFzcxHuoIpOxQXeGFHscZNqLd22P5bAk5HQiE4EghSfXc+gih+zRbPs7sUks23dQrJSwO8+Qn6ClS0lCoeFnJiY34a2zfjJPwro/IPWVoq/CP2MFEzWwbTGwoGLQ40fan2H4htsX7uNaAMx5WVU0bIaEfkeSkoj5GTmQkuTie+Go4hQIM+PVdCki9K3iM1rxo8GA+Na8kr6i0rGvJ1lvQpOMRgjBiGqHCXcJUBwj940lQnXU+NO5Mm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added user_report type data
attribute report support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index e558dd4212f2c..41a4ce49fbd35 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -722,3 +722,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	A file for requesting actions including enablement and
 		disablement of the producer.  Refer to
 		Documentation/admin-guide/mm/damon/usage.rst for more details.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_start
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the start address of the report to manually generate and
+		submit, depending on the type of the report producer.  Note
+		that the start address is inclusive.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/addr_end
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing an integer to and reading from this file sets and gets
+		the end address of the report to manually generate and submit,
+		depending on the type of the report producer.  Note that the
+		end address is exclusive.
-- 
2.47.3

