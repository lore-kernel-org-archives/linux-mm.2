Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764EA606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=MwetI8vy
Received: by kanga.kvack.org (Postfix)
	id 996306B05B5; Wed,  4 Nov 2026 04:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947C46B05B7; Wed,  4 Nov 2026 04:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882646B05B8; Wed,  4 Nov 2026 04:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66B5F6B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:53:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 025B3A067D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:53:28 +0000 (UTC)
X-FDA: 85396974138.12.9C4F055
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A2AB40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:53:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=MwetI8vy;
	spf=pass (imf04.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UBcVaAbLaeyK7MRE5ZU4PqnqGrSg6XSemL3qeOhiHzs=;
	b=ByaTvS6HHNdLTJiO47QFVrm+ia0zpthhkGElLbXdJlZKuo6WKpaI9ayt9TKPApXsfHaG85
	bw6MiWvAEz0u4jWKxl0lOjuxgmDknB6GJVDlGEeO4b6eBbqQSju/rSfcymCZTxgi83zZxP
	siHKcpaJnIR4UNVWTDr1+0e63MUUWBQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793786007;
	b=yxr1X5ynLjznLF7Oc0nHDt4fJagCB2ceV5k9R5PmtwpWweoNjPEzJbOLIrv9XmWLl+3HpF
	a4Sg2B6/2/zcjkHNq1GnG66O1xZNTBwcGZWSlMvU49XtYurK6W5d5ydMxFy9L2Xrjs9aH0
	+ZkDZSoJQE86DpcEz/GPaXxPbwJgxt8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=MwetI8vy;
	spf=pass (imf04.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=MwetI8vy9oPzQgv3cP54vIJQxWkTWz87x9obfeha0JO9FxMxt90SjcnoPXU6SvpqMblM/xyT3coof
	 7C6Ne1lYAzxtYDUciVJ+MfKG3LpiELgg1qFQMeZ/uj/IqqigdvbDPkPwTycHfIkt7DFSqd1u7fhMwP
	 QoA9o3BwsxdRZors=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96aeb008d540-a24b5;
	Wed, 04 Nov 2026 17:53:19 +0800 (CST)
X-RM-TRANSID:2ee96aeb008d540-a24b5
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from desktop-eb75daa8a6be458c-20260816004526035 (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36aeb008df34-1a091;
	Wed, 04 Nov 2026 17:53:19 +0800 (CST)
X-RM-TRANSID:2ee36aeb008df34-1a091
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] selftests/cgroup: test_zswap: check malloc() return value
Date: Wed,  4 Nov 2026 17:53:15 +0800
Message-ID: <20261104095315.2326-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7dw8kg35jh39ybj5jnuac37tratot8fj
X-Rspamd-Queue-Id: 4A2AB40003
X-Rspam-User: 
X-HE-Tag: 1793786003-548544
X-HE-Meta: U2FsdGVkX1/GXF1jd6enp1NJ6AmjHc2JPOjNI17+agX9XwzPwRLVAzm+ppr1f+lx38Es+j5ux90CrkJbIx5FGRTMqpEXCdty/9Y1uSG2PHkUfuMbHIG4o/p/+MbOdQaE+fmh2zXeyCSvHdny0LHgiaanxMvwa1GnN8VlY6yeBV2vI6+C2nv8jr8MLhrvpT1B20m4JipZmYJXl8MFHtmMMFr8AkGEWzyq7iuEdIanQrJ4z4AHn1IWakQaS6OCSnTuk6KnyWg86QaGCsbLMefRW73aJ7suQeJ4UGnalBMXEqWeTD2qv72xC8nOKCYmpX2yzeDp0U8DcVFoNTpFKGr6AX2k64w4k5s7+DMeSJ1ssjYv30fqgLQKM6LY2tqvRTecrIJthFVXnNBzS+rnDG4nEv42mFRGFOxneAqFhDldfHHwbcUeei3q6lPFbDXTJsaTUKSpGCQshwjFSUV4ZvcwDs4f3QoWlmoubk/pRqKIywTKlYDp+A85p3K4uLZCxXc2FeLXJ3elqsE+kc6uUDnwj3tb9exjePQ8Wvp5jo5bF8rljL1x1gqiKUfouzpLynj7T3fg8pAYSTHFMUVqQ6CB3Xy5CmvpyGuK6dqKb/kfezdBZBIWF0gROCmwGUnkbsig/Ktq757MltYFXgAQI9Rsm0RyDl+zHsPKyCJkTGSwLhx/V7Tave5Pg3sWUTJ8wtlse2W7g4Qk8aQz6iEpAnnXhGjKSt0ubqIQgyQOxQx4YOAilGXWg1lAoe4iz3RNVKvOStqRKEPHzzEfB06QZQFXx1YwvrOdOI3rmEzRs4imBvJKpMtE+AIhxNdKAOvI3TQ61ip/lljdS1mrn5W419t/Bh5inCx1xuaS6WOKFaWuPz1nHPpfDFG+6poyusvRLXxxwbOvTYDOwp1kJmnqNgzOnG6fzygZdL0mQxXBcJTrd2ju/3/Hp9Qn1nqaCdJ+fHi+JyaIPNns65/3rAWMxpy
 Cyy0Mz0k
 KxsHrX6p3ifNzruQ7hXbY4DHjdluttE6Wvb1G+bajHmS9Wk7YLxkH1PRfiF1ZtKmbMwWRZg7qWhrEbPH2q70jWYM66d6AlEI5HoY0Nof7Vtd6X/GUHWFTGX1WTCseztY8nZlEY7daCIdTOnGE28HSGQPEN0juWS19Cn5END+5+7r+Hc0hPfIb3StYLmd/o1EJ+hjEuF6tHIkLIdh4ocsGc8c5r21bX4MyRjmw9dKnMXxzQVaTYcbTKMcn+ORqKV2ngRIPSt36zR7wMhvbaAgK3nS8n5maZsVDU5NqpULJzZKbacEHc/5KYCxvkP5OVjyk3oY10i/VOhc+Xxyj7uSirH/0g4M/j7lLZ1Ew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

test_no_invasive_cgroup_shrink() uses zw_allocation immediately
after malloc() without checking for allocation failure.

Check for NULL before accessing the buffer and use the existing
cleanup path to report test failure, matching the handling of
wb_allocation later in the function.

Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index d50acc1b83ac..abe2e4954c71 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -503,6 +503,8 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_enter_current(zw_group))
 		goto out;
 	zw_allocation = malloc(allocation_size);
+	if (!zw_allocation)
+		goto out;
 	for (int i = 0; i < nr_pages; i++) {
 		off = (unsigned long)i * page_size;
 		memset(&zw_allocation[off], 0, page_size);
-- 
2.50.1.windows.1




