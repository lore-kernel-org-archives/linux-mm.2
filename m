Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28CE606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAg4GCbX
Received: by kanga.kvack.org (Postfix)
	id EECD86B05C3; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E771D6B05C4; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66766B05C5; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9B56B05C2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC12A1407F9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
X-FDA: 85438492776.02.2540BAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4C3D140005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAg4GCbX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpJsxUs5k/v5Q/BJmFbBidw7iSSRFrTJt5QonQhU+Vk=;
	b=58GEW61J5un/66eOzaWPatNgjMKPO2bAQueFZUhOTc5iGBL1TU1GM+sHVvhXvwIA5KLJHi
	sgZQXAx2UmSsES2uMxuWE7oYexnJ3GhNkIbvCq1Op8ZyjFuR7PscYgBQfR0aGWACGhtcdQ
	U6SdWo6FUI2cnfEdEs7TBgcLlLmU7J8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAg4GCbX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774547;
	b=hlkUJQYBjYUW7gwYBgQtDi/YCMOin09zJdSGFgms0b793dm4Szmk4rpjt8LmN0VtZvbUt2
	OUCx7xKXiQakXjjo+ztv/g23Dz/gCQHTzdEF285vDLbGnnAAbX1XL8SCJy3uWK/w7fsoEe
	S2tehBK71Za/45SNgW5pwHY7sGSXcaw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49F6245B1E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141B21F0092B;
	Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774546;
	bh=wpJsxUs5k/v5Q/BJmFbBidw7iSSRFrTJt5QonQhU+Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DAg4GCbXkR2wW9RLIVal7F0rVzKWUYpk5e8bIAkwv0wIk2bmYWXK5nQZQ3pLSjofO
	 QGurE227J1JXsGJ4jya6+feB+xYvDKqqFCkJyPhVhg0udHzSwWWGrtPQQxVhH+YHvH
	 3Rkc+g553eTVaPJmxSliRd11f7FniUllftDxI0zLrxyHuQvX9+rg4Te4hzYS7aoYQI
	 6R71KtxCQ/S+EZQ+LbMMXaMaUkjO767VawaUty1e70oC1EjD7fi8XGa8faCKK8X8Po
	 Jct8Fzo+DP9ThYBjTCfrEacIX43mJcvfnZJml7iQy+9DexClo2kUPfRHCcuys5elQ6
	 MSSdAAVT9thcw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/27] Docs/ABI/damon: update for report producer sysfs files
Date: Sun, 15 Nov 2026 12:28:29 -0800
Message-ID: <20261115202849.99134-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C3D140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4x3djkatymwkhzq8dbhzrcsx6w9kqgon
X-HE-Tag: 1794774547-391395
X-HE-Meta: U2FsdGVkX1+uAFXPblVoiiYs2qF1ymAzNRSMYqHz3Cd2IT3MTg8cS9y2gOI49adqe2tesD7sEUkVH3+pRd3281csLFrEIdpTx7OHJv/DRlNCxMCH9mA/M+rX18MOZ/+h/Op+fH4ytUf/0GPX6F+ZN/fvbTjlwaaOwY+6iuatysadYULyLCn8UBTXtxBDA5kecdU0pvwFg+SiMrW/FGHFMmwCmxfyQYz/Si+hqb/hgyx3vdL9EAPU7DK6Lv1AvEKLCwsE5uQ9fqD/r9yA0ZOzxymF3Hcd7v/F6CqQwhm2BtjdfwkA+RRZVwNhV30dc59g2qjMI7x71sTIaNgZumAw5mNf2fVaV4lioA8322jaceiSUUFM6nyc6coa+EuM87ctXBTZJ3KvtIqhMHp9b0QFYHT9pbApw1Zgyl8kST+3EB8WKt1K12tZz5S/1gYf7HV+UClVhhezMu+hC7IQxkbgueh2yHRMpMrarvZHamB0aDbhN1MAg5zujNnrf5WgPnoWomq9h5dW/VraADyuT5rbVxnVHViQWOf+3LO1DhthJgstsnz6X8+txKtbWfhHV21wED1YFgvyV8HY4zpQQ2W/RYxP3KRyTGnKuFGDVDaM/qPtykUOHY8jHPaECgvxugxIfGLRtVAaJrX+W7EIrvmncSZCnvPGfmc4qC0+bsVVCD/W7umcVQ1VZExt70fhNDetZOd+A2M2QPvZ2eMPVPLfyY3Ozl7CijrSm6DnX58TAVFdmCAmmZlZaAgKXshCLjT4Ag5cp+daTVOkOibXi3Q5IdOo4TE0hRX/cp3UT2gHAW6yPVnFJyIu2NcU8VXPz6MEUJFjimSfHnfH/nNQ83mEQHnGoIDBeMJjXW0IVvta+QlGPYuWmSZLZOWwvP7UINSkternjwAFLEE9yfu9NiIoWpDn2av0XV1FqMLUJO297+JtZNJRl/GV11W9QIIAO2AivbpmJgYN8TOGxXx11bb
 OjYGI+77
 fRJUQs7K/vDryf43vrfoyia8Bxwa/EqNK4w1N2XmjZT5T7BgRWTrw/o9P3B4vtFrl086N8bN4JPVLRc7GfQon1ZWqAs02dvloHVp2yg2uzl49DRjAYOI30+Z6uwpfCpSRDU43rMbjL14NcR5QuXnQZNaNz825Oexs5K+/np9iWf4NX0XpVHbL0Yho+uFSgEGzk0nl+bx24vts33gYxVRb60Knpuq+vk/7KUIMLnLhEO+c8GQ+gdqVmPyMuuuSUNnILa4Ssef3rHOwAgEQEcN7iIU5ZGDdpd0Wo1Sbh/FsdfbwBQwjkSYukRfpwNlMcgH6Q3/BAVPtGRJr8BI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added data attribute report
producer control sysfs files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4acb2015c2f4f..c9f718f126c70 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -695,3 +695,23 @@ Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the number of data-attribute
 		monitoring probe-hit positive samples of the region.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/nr_producers
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for controlling each DAMON report producers
+		named '0' to 'N-1' under the 'producers/' directory.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the type of
+		the reports the producer will generate and submit.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/producer_state
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	A file for requesting actions including enablement and
+		disablement of the producer.  Refer to
+		Documentation/admin-guide/mm/damon/usage.rst for more details.
-- 
2.47.3

