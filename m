Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11B1C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08B896B01A0; Tue,  1 Sep 2026 09:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060666B01A4; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE256B01A2; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5B3A6B01A0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EC891A0405
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:22 +0000 (UTC)
X-FDA: 85165264884.03.2456E41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B70A7C0013
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bGFNrxpm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	b=6Qh7E+/dG7tv10DKaVzx/XDFajBPKEFQ/yssWit440AXVmGiGxpHV9PNtQPqpO/pYuv0ip
	4eVFYmT+PJMnktwuMGVBEsXmvgGvO1AmWmLDTIQXc8EtVbro325Yr5EXY9Qxqm1UAgn9e9
	Vkm+Re2N8GrS55dYIh3NMQT/2LlXrR0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bGFNrxpm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269120;
	b=pNhtzRXfW1qOiVWchm1aTDEppCXVgoADcE0jQ08WGSTTTiw0KjROlAHDgm1Fno34CrfimA
	Wj3fUBAdaqRkNj0VGB2/Zow9M8cjgpVgjHdUIwZSCJ1xBX2vmHf9ZDjlltD1xlQaLc2Ej2
	RRNpK/JyoIyMM1cuj+A+1pFCBo1I8aU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4BFB41A4A;
	Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6395A1F000E9;
	Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269119;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGFNrxpmY2vl87nkgJ+iyG/FQAuLseRmz4SqqzqS3r6ZEXj5vsMmRWjaWHZIvTsQG
	 Yd/YVWDr6Uxiz7+F3/KFqpn0ut2agNQJUEj5BygiPsuqEpkJVXzY+Egt2tcqWKAFc3
	 lZVUUGxqYPDlHxv7B7F+rVn7aSASQoLG9nd1CsQUeTsRguHPWWimE1IPtJwpqyujnI
	 LsGynk8HiVPHLeZnIS1iWe+ku2ZoZURBcZXJ7g2NmzCBeA/tTuJJOQSqIgCYY3013N
	 /hfDeOGkYcxoYM5/Qd+BBidhnSE2SxLMRdOaSjsIi5frS3/xKjnytPApPU8tJPt/9G
	 PcZdytCk8W4pQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 14/17] selftests/damon/sysfs.sh: test probe prep sysfs files
Date: Tue,  1 Sep 2026 06:25:01 -0700
Message-ID: <20260901132506.99243-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B70A7C0013
X-Stat-Signature: 1uib56mi6decr3xpkoxssfk6oe1bnye9
X-Rspam-User: 
X-HE-Tag: 1788269120-108564
X-HE-Meta: U2FsdGVkX1/PLsLGt0MAx7M1i0k6Ow//NxgZmpRxW/qGeQh47RsdAIqB8npXIxn+E4jqin2K33bvPfME9uVOFA7OmbHxH+7SI4Hko4XtEv2mZvU6lYhq3zrtSrvSJR5hi4Er1qrsf2a42VisNAKBvRz4049dgr7iq/pg6VCc8TYlMPY9LflmjJGiuPxT7YsNQ4qsaonZXqBz1jII8R1vHY+OG64pIq1JwSgtFQcHTRmiRYap6umCgn9FqjR51yuvbZRE/K4hDDakO97YcKStwZcEvcmKdvgpXjep8fv9CfP/gbgY2JTmKm5fmrcUz12IyUBHCYvm5aBJ77+GjFeCngOx0ik1P+UjY6HbThvfVdRqhOa5XrCcnntNcdxP7iMzWVQka85pgEcRZbBIsLF6/O1Ot/ruDsa9NJ+J8BgOULSaCy7XM6c1YR3j6OFdvO7Hyue82qAj6/mAD1Qk3wRvmNRTDjFdXr6i57Gk5n49YGcJzOZMca2uEE7BIlBUHtkRhs2c5KmffbAmhqwtNHNNFExG7k1RxwbRD1vF8oywOsTXCmjhwqQ0zV0lDgfmwZcnG97CUfiJykPLP5rgSjjAV7JJ5/ZXPe6r/gHQ7oEdNnOQDaCXtYKAxwzlVJ8Gtxv7kOjpdvBQojGlSf/8dJx+1MpXtwcT07Uw9RtZDkiUtFhjCfUcCTo7+v8AUDPDRtVJtOGkxtDWm4SQKag6bzJ3UBNF8hna5aTQ4KFtidh+iPNovxh7KUHGk5y/Qi4wxE1sBfLiJsyDuwsHg9+xd8xbsfn9/pLUenEfkBHvuo/ffh2Gjro3S3acPPK4CsoLtXYdvvhsbxtJfiGUlG4R6v0wP6dzKtwOq948cGp82bABEIRfrjTMMFzsYsfriPlQw/N0ZqyxynSvGfvP60uNJck2lT8y8we55Wg6uVRZMBiclLKaDSduXG1ONfjQMxlJOfcsr+KSsYD3FbhajTrTyK3
 /48rjIu5
 LjbecKTo/XAqfp2lUgdNFc0XSGHj9Lg0BGeU1JG16nY/5Af+9n3JGpoG8pKjaRKXDIMMRM7d2GD772d1KWZMI6XNvg/0/DN4p+M4rv/nO4+ERP7sZAYOHFhUhsnfbhLrpT6Eh0+fpLasVFcO+ZJxnPPOxMhCxP3hPX5Ayc8f6vJu8f1fIdO1aPkpgns1GQcDfZsDy3Wy3/6McQlQauDmzlg2zIs3eJV12phJJhGGsETKF+wQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add basic file operations test for newly introduced DAMON probe prep
sysfs directories and files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index f7fb94b84e716..ddebde6edabe4 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -361,6 +361,32 @@ test_intervals()
 	test_intervals_goal "$intervals_dir/intervals_goal"
 }
 
+test_damon_prep()
+{
+	damon_prep_dir=$1
+	ensure_file "$damon_prep_dir/prep_action" "exist" "600"
+	ensure_write_succ "$damon_prep_dir/prep_action" "set_pgidle" \
+		"valid input"
+	ensure_write_fail "$damon_prep_dir/prep_action" "foo" "invalid input"
+}
+
+test_damon_preps()
+{
+	preps_dir=$1
+	ensure_dir "$preps_dir" "exist"
+	ensure_file "$preps_dir/nr_preps" "exist" "600"
+	ensure_write_succ "$preps_dir/nr_preps" "1" "valid input"
+	test_damon_prep "$preps_dir/0"
+
+	ensure_write_succ  "$preps_dir/nr_preps" "2" "valid input"
+	test_damon_prep "$preps_dir/0"
+	test_damon_prep "$preps_dir/1"
+
+	ensure_write_succ "$preps_dir/nr_preps" "0" "valid input"
+	ensure_dir "$preps_dir/0" "not_exist"
+	ensure_dir "$preps_dir/1" "not_exist"
+}
+
 test_damon_filter()
 {
 	damon_filter_dir=$1
@@ -392,6 +418,7 @@ test_probe()
 {
 	probe_dir=$1
 	ensure_dir "$probe_dir" "exist"
+	test_damon_preps "$probe_dir/preps"
 	test_damon_filters "$probe_dir/filters"
 }
 
-- 
2.47.3

