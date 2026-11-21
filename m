Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F819606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbVDxgF1
Received: by kanga.kvack.org (Postfix)
	id 72B626B05C9; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7756B05CA; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CC4E6B05CC; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27C626B05C9
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEE3114036B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:31 +0000 (UTC)
X-FDA: 85460344662.25.14551D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1EE1EC0009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LbVDxgF1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294830;
	b=YWz19EJnIz+Zl6bzBqwpmptcs5YO7de+PKNQGk5F1rR/0iVPphtxBiPS+gpEf/EdanO1bT
	W7lgwi5PqG1pyzE3iy22adi15waoef3YbmYCQbdBvnNZ5lKD4SZOUmQPNS6NvIwOmMijJ1
	+RK9JDBW10hnJ7BC5uBo4VaDJBQo1pA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRVXEo9+L3IOL49loDwH1nSlcsh8gFIjIUafHWHgJ4s=;
	b=qcsVBsBsIp2SDolFzZLo5hcxKHDVNHqH0cUsRb7zLR5PGp1EI5VZgmxrFDkIaAyLwmdfV0
	utxOxIptTa+cJkpUoQDP+v+VVGo2YP8Mr3WP8cu2dlAmqxzpNGLBUbouma6/5DbKsJK64Q
	GDslhJjUKYLQJ5jB/ddJmAz36BWH41o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LbVDxgF1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26C444411A;
	Sat, 21 Nov 2026 21:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF901F000C0;
	Sat, 21 Nov 2026 21:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294829;
	bh=sRVXEo9+L3IOL49loDwH1nSlcsh8gFIjIUafHWHgJ4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LbVDxgF1VHNnR2QH0PKb0mYWKKTDoyVxo1RbnrklL6wOn1nBypBVgzqUQe6X9w7Co
	 vOa+NQRb5THyEOhvADELH+WsuabpaqLCrLmU8W5P8LZaUhsRpWX9AlR6drz+yI4SrQ
	 8DcB1JB77sbeKo9cmFxz1XigHvIzpaQdXeRqWWKRQVbWyrUF9RHvZvvABCC8JEAtWd
	 vgNhGwAPvtyp9INuRBvqdrlGD1+hdOH8lvYIUhybttoycv/T75pTW/vHY4qB+h/6/J
	 u+nfIH5n1uMKzzJ/+agVcia2iozIUXGKZsjXramEC6aEtawbYJV/Jj0djTIeLwyrvi
	 ZcJqhQqrWmPVA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 23/27] mm/damon/sysfs: implement submit command for report producer
Date: Sat, 21 Nov 2026 13:00:07 -0800
Message-ID: <20261121210013.130397-24-sj@kernel.org>
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
X-Rspamd-Queue-Id: 1EE1EC0009
X-Stat-Signature: w9yjzgya7di31kse65m46q4wkiissk7x
X-HE-Tag: 1795294829-724653
X-HE-Meta: U2FsdGVkX1/OOhaIA5MVeeJ2qiqWNpFhui2cMmOF7CVwz5EONDpkZgpt9xMScWA7D2oUKLyVlwpxFAQX4XqrNxZ8x6A/HgtaF+1QTYq3Ruqh7+IkKMF5L1K68NM9CIzwLRLBrHzV8DpLgHS3QiCeobgxY/75+Z7NAZioGv1T+Xat2I2AjoKkKM/JwiNcRCSe5YV0z4kpOVo6gLDotSEa2FJGjhVwcxs4QcgPvxfzVhXocSRi1QNeY8MEL28Xx64MuzuFqZD862JZhU+rbNYCHkpev9nnqoOpjuodXs7Ud8Dsg4CRWtgwDNL8TtCqEmodJZGMKGaLDtn2N0CtfgBUly5JwjIySn+y9a81AZS9LM0atjF9izJEBxSfIgRxcWgtZLlvu3BF/hqMoOuVuY2WIvSHZZ7PjRtSIxwjLgr7S2K6U7K/ZM55PrA6m/jkrCFyg25DRuZ8/P6oaKvpTjDcJ2Fu0I7tGCuZTmUL1V7/jFdmG09S4tjBhRrpw87LOQRLEY7XRz/UWrpjXxRN1xHs9mgWN1+CcOLRAkYxvtScz0r4ig9Hyyfm3NEarNyfdFF43RZVxBaOpuKVFXL6vD4kODeoBF1oZROk9KuB2OzMFxptrjDq9584QeH2qvvXY3svmlXOWPtqDc+Wk1cgVMZslS+Sxhks/sc7nx3gJjEPkBI0gaPqfAuwz9fEHi5blsqkI1rPVP2mMbC1WEH7gmnHVbvHxvoUor2HL1x6V54JKbTFVX1BGIRCmAV+0ONy1VM8qgX6bTPSH0ySCTIIL1+BkDvwjiao4KBR0LVBRPewUeeCkjlVPdBSmWGQ9mbFOUlliJUidnX/oa+zaPMsEQG4J09itNM8TuoM61j3DJnXW7xbqm9QqaABeMW+OG89cATfGX11yHFnct11C921bKtPOi3Ui3nkK7fau8cEFIgb+MQMtoYMM69xH0LOzYNYXPOhWgDCR/K14ZunB6dR3NI
 bxGZANJF
 W8ktp5BRzJKT/W9cmtM5NtbRtQGoP/K+nF65FrM5XzF5zGMeoc52EU0z1Ua/Halc4dwckoVWZQREw9SPZJx2nLN8QgNxtg6ABFLGFcFOfwXVZSCW3Dyf/movp50yHUYXwusAeHXd/3jExNXGkpAvN+LIwHxK6GlLhdzzVy23nUxfpA6CEAzeCl9+hU7xCJBJWaQBbqVulwsVw92dxrC2c2IHykA73fmy55V8mMdqXRGLYenGb5jzXgRDbmbKR9vB++UEFkfz0dvsyG+0DWiVVePOFbyDUQEJeFd4fRlcD1lpdTWXFIkkV9a7u04WKjjMgZwWt8k7xwUDCOXYnP0+7dxGKU7j/RrzvVcuik3nmO4LfsLHst/2wyDOP1UVG3M8lkiFD/JEX2klAqhqtSOSqQRXAIxQ4I7JhgKXqGwtmgy/Mq/X5ug9rHEuQXob+gWcCclo9c4ZPPi/LdT6eMigCOnSMyQ==
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

