Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED25606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JsucGbY5
Received: by kanga.kvack.org (Postfix)
	id 8902E6B05CF; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CCB6B05D3; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660F26B05D1; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 379A26B05CF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 090FA407A0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:12 +0000 (UTC)
X-FDA: 85438492944.03.A929DAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6A2B220002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsucGbY5;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRVXEo9+L3IOL49loDwH1nSlcsh8gFIjIUafHWHgJ4s=;
	b=JpbFVxjx3ZzLJI7A+vF2khsJa1bwl/ebKd04JTCYBAMcAo0Catepf77OieagqL/L/rXhMr
	Ndx1jNW0A3EultVMd49o44RpCzlSa6JcBIlths5OLNxAZzxP5+Qzm8F/UEGB7fbX0uTpvx
	N4dCqSBYJLb+HDE587pt5L2KR93eI4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774550;
	b=RGfqXnRNLUNk/gG3FeVnA8pu3gf9g5UB7FpT2BxtC9IVn6UukWHkG95zhHp1pN4BuFBcRu
	ed3bdek+NG3FnOj+KIifoHqDnUIm4piZdd82SmVhyuqMDtUYVnTHnO5wfCE9aRn1lGgBfW
	I53BiPRTtVzZgvtmpZ3Gi4eVjXLsYf4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsucGbY5;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B41F44895;
	Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC311F000C7;
	Sun, 15 Nov 2026 20:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774550;
	bh=sRVXEo9+L3IOL49loDwH1nSlcsh8gFIjIUafHWHgJ4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsucGbY5PO0b0X2gdfNJLj7lr72dlBZusO/zeQGYSlouPpwvHXUVB9qA60l/jsLO6
	 V2t1XdUQGqKZd0robpScWriS+bKO7CIhthDVrxO5Ul4jJz5HTdRjRhdnLH/F2US+Mx
	 hSHIfg8lGPM1dNjKMk4KAPx9PWV+b2OfpUbAo98kP3oIu53fgKLcd7uMa2ZCXGEXjQ
	 JA8c4Q5wCnwAfbXHTRO9KMlpE/GsyKI+R3xKhs2G7idJCz900lwi71USWiOYh6Cm2V
	 TsTj+pDTstRodDHYUElmdoG+fbZKnYW+kritct46+02IJrDAiEZb9p2hVyf0tnSAvq
	 xQV4xdjFXTsVA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 23/27] mm/damon/sysfs: implement submit command for report producer
Date: Sun, 15 Nov 2026 12:28:41 -0800
Message-ID: <20261115202849.99134-24-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7d583zip7i1u3ozjw5ccp5ibtdbpay4u
X-Rspamd-Queue-Id: 6A2B220002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774550-695522
X-HE-Meta: U2FsdGVkX1+E1FSU4At66N3DEukEnIhoC4wFmU3Ynb3wF1SbAde3bXLSauvFRTyL+XNjgwwKHfUjh+wlZ9JBed7IQmQhEB4ECBbYWkuDHVqWX54mQkXUYGI6QCRbJFDIOGPwajjJfhtMaZOZiFMz34U5jlmc55tFAoCxO3yP2QvZvIkVRRBqyAJWGZbZqio4Ud126Pm1GeQlkwDvCDs4StaAgcxfhSDlXPCiCTJ1LtGzxwFNcdu3sF1mR1P5Xbn6KDKIpK8MfYoPA0xXAryW5psAeNjN+hxbWK5obizzmPxUVMOyPINL2KsxcuDR41xt9JTLvNf9EYK1EdaG3dK10lZLLUvCUA4z04FzgcfP2rwnd/vz/wRsiyEfgymLYVyjzzyoCpD/DM62oZ59p4RFWU5PgjaDiCy5cD31plOL1BELsRtym8ddkPlOAFxWzq3P//MxI/bi7dBCMWd2kpfsswCTie568Os0rU6HQeRqE5DY5NgJ8Pb+RZO8I5Qh2YhJREy9vgkW4S91XzQYKrwxs4GoOYAGBTnGNS7DIqracLVewpxgC2Gvfa9x3On7wsE95lk9VuZ1MzcQ3xlzvlhpi2M54iEDo4VWVaYkrPN/LU+c5CB6J/IH2K6xZxueOHBg7JxyYasYiyhuxqoCglkkoxwGeH2S/Zv9GDWSod6CVnxEcmKME7ipq3nC5I0mbIlFmN98IPJBBOmGoyPpo9QM9kaxnOKF94u51+veBIc3uIpiqsL8XOZP7nPqKtEdrAVdFzF2FojLpXPrbXha4aZkEyChTyAlEYpekNuqcmGQhvhlbAvsm00TutnP6rnir+4DJuIeic9GIKUaT4eKp75/+xOz2AHPOIydmkA2cucf8lXHIh8WKulwSZah3r34tOlA9NNuN4A3GqjorOTbkAh5axHNML7NrSDGq/21sd9Wt3TSy3bRSHU9QCSIVcyaS2BJN4q9WWqEb7DDUVelHTy
 uKZ14Paw
 AI/dcp2ZDlohDpNLjoxO8M5G/L5h0rUV+FHDtiTPVG69aYH0DeuwcvBS5uOBLTxcEN4bwo+sCD2GQmhlNiIC9fzIrLAXd0ZpJYiezGBWURz6ZoKZY2WKRDlDm+LewNyejQgJpll7Wvkp/v8O34pcG9VD0kEvRzNjmmn1pWmia6FW/OcebzDpmLQQyus5OmoHQP/f+vg7sp6+yhuAZa7NhJiYZ4Tn5g9fbpLALwf9g2ikY4Uo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Let users manually submit a report of a data attribute for a given
address range of memory.  Let producer_state receive "submit" input for
that.  For the input, generate the report based on user inputs that are
written to the appropriate sysfs files and submit to DAMON using the
core API, damon_submit_report().

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5f9bb1955dfd5..0049aac6ab974 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -3107,13 +3107,26 @@ static ssize_t producer_state_store(struct kobject *kobj,
 {
 	struct damon_sysfs_producer *producer = container_of(kobj,
 			struct damon_sysfs_producer, kobj);
+	struct damon_report report;
+	int err;
 
-	if (sysfs_streq(buf, "on"))
+	if (sysfs_streq(buf, "on")) {
 		producer->enabled = true;
-	else if (sysfs_streq(buf, "off"))
+	} else if (sysfs_streq(buf, "off")) {
 		producer->enabled = false;
-	else
+	} else if (sysfs_streq(buf, "submit")) {
+		if (!producer->enabled)
+			return -EINVAL;
+		if (producer->report_type != DAMON_REPORT_TYPE_USER_REPORT)
+			return -EINVAL;
+		report.type = DAMON_REPORT_TYPE_USER_REPORT;
+		report.addr_range = producer->addr_range;
+		err = damon_submit_report(&report);
+		if (err)
+			return err;
+	} else {
 		return -EINVAL;
+	}
 	return count;
 }
 
-- 
2.47.3

