Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C6CC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741AF6B0088; Sun, 13 Sep 2026 13:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB796B0093; Sun, 13 Sep 2026 13:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58C976B0095; Sun, 13 Sep 2026 13:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 686506B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:11:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BEC41608C7
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:45 +0000 (UTC)
X-FDA: 85209380970.18.3FF21BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CB425180002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:11:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFquwlYb;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1THrGcC3ePDhKbhiSZYXQDRdyryWEO/KzCpY2oKcSSQ=;
	b=1Bc7VcB8o0HWaUcivkacrCdPhPKDDWD7LXNBvgzvjJWmoRgw8e0/qK0isoshXIs85GUaZH
	nY2tuyGR1VwOTvOEqF8LvfVpo5BcmFRKDtJbig3FI3sLAqqYwdsAV+9UxGdhp1nINxghyp
	9QrN0DycMlT3MtpTKr3tGS/jup+Y6mI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFquwlYb;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319503;
	b=k9NODYYSaxvfLqXY865nLb/PbCDdghVfwc7a5PYY389Min0UuSDAdzxdLW7/jlXis2wnA9
	56MHcs+ZHgEgjHS0MhDAcPO3OFxBxnf/BVuPXvKvyivuoAihIz/GZkjGnLEMVmcQJ26x2I
	/kYOTmuwH4dZNBl5kKgse31GvsNvkGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0A2E444F2;
	Sun, 13 Sep 2026 17:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922871F00893;
	Sun, 13 Sep 2026 17:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319502;
	bh=1THrGcC3ePDhKbhiSZYXQDRdyryWEO/KzCpY2oKcSSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFquwlYbr3QhoekrU4ZORdHQzsMivjK9VhJLQOFwTV2/tyoqge9b20QuSi2SrIkmf
	 tankTfYXLBtNg9ykTMR4C3w9d3IDZ6yVZaWKz1P52cqx4HyNaSYSF8zMs065FPxrLf
	 5bvWM/0fYlwAxXfuyFwwN5Q/82r+L/V1kZY28e3OPEe3XPdFeOXqtxHsABIXe1mTGu
	 uJdp6pt7JRapCttdg8fO0xHrLCpM7WSO37fLpXHwUz0Ueq9aCNlXgcjhat/JF7YWMO
	 beBSSkAg+BJgs17kxpT5JlH3MQgdOM5xueePt+o614YbJIjb2UkR7m29DH3ro/p/0C
	 y4oQ1Z0NEqXXg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/8] mm/damon/core: commit hugepage_size type damon filter
Date: Sun, 13 Sep 2026 10:11:24 -0700
Message-ID: <20260913171133.102366-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171133.102366-1-sj@kernel.org>
References: <20260913171133.102366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB425180002
X-Stat-Signature: md98uu44wepgbd1trrmrhr6xdx1ssdgd
X-Rspam-User: 
X-HE-Tag: 1789319503-104388
X-HE-Meta: U2FsdGVkX1+bLqtT9co2lyyaBeJksscd/a/3WcZBi9akStfS33gbRFSzHvSvDrBSEDdK643AIucE1M1n9gVvxvnXqflqfx3gHnpGgXX8oiMW+dNkSeDkt6WCdBRx9T4Dd/N0j0EOaFjF2rZQ1niCvgobyEdb8+QpvDaXqRof+J76JcbMbjtnKu71a7NK9IE3vDNGU7vS+1jxPWYPmoPma1X8n/si94YZy74g9MEjoticjD3P6eqBESAjXpyA6uLDCNMSApHC7s9V0eJr9guyqe2gZAzUcfK+VoyFHuPeY3GHuH+CxUAQ1/qKIW0v2uP+FQDlQ2VTqXLChfRDpnYbyKpksLNyBdeEVOD1UWUvoOAj5Ec5I5glENk0uOC/oFjQ29uzGu/x2ibUmPU4J8FAIVom4bJQ9m5O+sA+4c3v3gbQ24kC2B2N26nhq+TEGjlEICwqxpfaDFboV02pIt9N2qUj3BWufM3NPPq2oxpSWXsXxkSKmZkMqcU4tuTp7BhDHi0j+ACMANsZ8dpbhnJQsVrxRgdk7+Mofm/CAJQnis0drXx2Q6IePR38/uBY3MxPDr38EDbMcoWeZ/S5awzxOX5X03piAFB14YsYeGJRrPD+sooiV2Iu84kARqWIv1rfjEfuaWs+HuVf0Rqy3Ikr23q4BL9K7yXkW9MfkPK7zeF2EURD3xeMIK4NYt48TvtFWmVQQd3CIM7UGm84Y2U5lOralDwrGybuD2R1kf2GMMaZX7WNEPkXIum7cU5GUqH5IGkclF13W4Ry5ipub4o1sCuJZFh2+gsZLyDWiCbSMW6hTMvj3oxywaBnJa0Pz2Jwi4wrQ0EgxguMY0xG6kbKeRU0BGzovX+9LZ/4oXLVLvp0+G99uQpCGeN4mZ37Ke+hA+m2IU1GSdKyN1U5ZytpPrnAYSDyKIspqJrVQLJNMWBD1XLFELbOkbw2vdfpfd8NRSCJZ8S0fqti1CAUamY
 bghiVdYY
 K7bM5WW8nWLqVs0uD/qujEhhv7aqqVOfYy5sUUFk2sOU1yOPOlGaKZRI+do116mRMuJiW7cKEj2LHtFiFb3t9buK/QDNNaKMYIL5iey0sWwf0U4wK66n/gqnxRyzt+9LVtKiQH5ogsXt7Av5Y04v3z/IXB/EsH4VInuMOtiSZRPyASkQThgZ1PQuJCaSGvT+EG+SkEa1Ss2gPKvYwmvgxJd0xYUtugxWquNZgc6xjPd6YVULnW5MHuMWK8r46x9NeMwYVQeo1t9oSV8LXvV45/6JsXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend data attribute probe filters commit logic for the new
hugepage_size filter type.  Since it needs to carry the size range of
the hugepage, update the logic to update the size range fields of the
commit destination filter struct.  While doing that, validate the given
range and propagate an error if it is invalid.  Add the error handling
in the callers, too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5212bfb8f85f2..e2b41a434cd2b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1818,7 +1818,7 @@ static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
 	return 0;
 }
 
-static void damon_commit_filter(struct damon_filter *dst,
+static int damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
 	dst->type = src->type;
@@ -1828,23 +1828,33 @@ static void damon_commit_filter(struct damon_filter *dst,
 	case DAMON_FILTER_TYPE_MEMCG:
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
+	return 0;
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
 		struct damon_probe *src)
 {
 	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damon_for_each_filter_safe(dst_filter, next, dst) {
 		src_filter = damon_nth_filter(i++, src);
-		if (src_filter)
-			damon_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damon_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damon_destroy_filter(dst_filter);
+		}
 	}
 
 	damon_for_each_filter_safe(src_filter, next, src) {
-- 
2.47.3

