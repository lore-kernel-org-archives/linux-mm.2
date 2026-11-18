Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B06C606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EB6b8GsU
Received: by kanga.kvack.org (Postfix)
	id 03B256B05D1; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D296B05D3; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E424C6B05D4; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C229E6B05D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4AEB312063F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
X-FDA: 85446641322.11.4343C6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B3DE120003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EB6b8GsU;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V09JiwnLcA05u7t6X0137O/5Kf7LeJuHza0xA4+7tn0=;
	b=Kbgunwyc6ANbQpI6C9TUbdrlhNVLOLeOfH6jsPO/oqa7mMgpugUDzaeJWjL6tPMIuWXI28
	OD8sWx7Tn8nbJfUXJxMcleUJYYyBYLYZP0zIN4SO7NMLty4tKFkxY21hH1khfZK+gM4cH4
	Rhoj2HgQO/fO/4VHAaF0ddNpsCcmWeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968559;
	b=xfLpMl07BEWvqRYmb/KRIeRq63UYxC9zfTL+MXeu6e9TeQAEoUB3XGC45+pGZmyWP4PYzn
	t3Kmvtcq+0UJFtShcYdBS1ykRw3BIfDWJyU0xSsztpe2mMjZVFO13SHqjLuGc/zElZEfgJ
	4mgeYDp1pmQ8i+8L20qC0eau4waydVw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EB6b8GsU;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CAA945E78
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA6F1F0181D;
	Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968559;
	bh=V09JiwnLcA05u7t6X0137O/5Kf7LeJuHza0xA4+7tn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EB6b8GsUXK5cZZ94s4pofJMidxzAQUeutkw/2nrKOve46B5dvbhSAlznFBMLRtLKo
	 AEI7XC/uZijdkVidgEUAJIJY2aOgadBLPL8/t7QEcvsMTZda9J/tzKaOJRHpIXN6XE
	 5V/FEP0qDdu6xWkdlo2Gq3OD5tsvqWnF49Ry9/bSbh1jkEL8UVCK2ViciLr8eQKpO1
	 nX0sQXPiwfh7S2WyDEbl1m1n9rEovRcdA6JBOPN/vlhogPwrHVnSC9Gh7NBWERrXIA
	 kRQNFbgRC0306KzZwjuAm9dnZHsl5uK0YUG9zHGLx7tBcoqpD5vsNGI7q1AllPudaI
	 N7pAEF+SxbiCg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 20/27] mm/damon/api: introduce user_report report type
Date: Tue, 17 Nov 2026 18:22:15 -0800
Message-ID: <20261118022225.100659-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3DE120003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: oi3pohtz9sxajy4zrm5d9jc5p4hp68iy
X-HE-Tag: 1794968559-996010
X-HE-Meta: U2FsdGVkX1/96jgMnHxKOmEGNmZZyo2KEgsh4byultpuB+FcUrS6pC4rC4ojVKzciwgPHuwRGGsS6vATvsMGx4tvQjWfmuO59ok5I0GUlJDHq7A7mAuhnbyiWwoNjzmx9zR0MNoImHqG01o8A5S+TCrs43MkNHsnGa/YMCemidcgvl+qUvTRg/1AXMAM8Cgbdz44KVRDeu3o0bgGbfr490lLQZlnVi3YYhc3//hqFGMpqxBn1T6akmCnOSDRnypvpWhkZSDYlkPSI/gMvHepRfEiioFE1hO2eNZCtEiicgPpsuLgG6EmeVMkdsbTjls1SMsQvCMFQwyXHAFaYzNpKsO6CiMGOlPGDdVcG8JUd3JeZmgcv6GvJzq4nGnEbcE6O3vx+kfCLotiRh4UU29vKHAgsMDXcFmKIISwLRh0sCBlb850uKY0C2BBN3zXv1xK1h4ZCOcUiE/i6A53r9oWJ4Qa7qzLEVllGf+qfwMHn8F9iKorD8xcU+P0/yYertAzoeDr9XrRme6gEuNNg9HI1PJbVFlaubNXwzlFfXX+HK9o5hrvmck9hZOn+S3RexrkySSfcNS6ngQDg5oLB3kSbP84bUvnsL0Wv416mCQXuo8vfTmr8WiVzj5wgmkDll6q2JDt9VtHkf9emXUjcWtO2/HvLPni7dShI3/DdsJwj2RTep2JFa/C9Fg8I3GRWyNT7qKwIHzp5xFPxO/NS3vruH9Lf4f/3L+I+vYH03oFmRmxGiAP/Y1TbUpyQScplHs84ue+10Mqd3da6nAh4eMwJ5cBcs8bBO83hl0LXa3ara48dSmIdDt6OmsClcys7AQ5zLc/VycgmCE7G6db3bgy4amK9M0bCBAiUEj78ukkX7iC+KoOUmTgafdnbXm/r4OFs0csMfCpwxVtVkBN0as4LZdgFoCg+bRPd8ohWG/xIwKzzB3FBhRv+AH0YUYK9MFWEHsHYJHLzg9i52ZaW+k
 MUYZbC1e
 MS48K29teCf/E2VYYrCzYQXYxdiAv/AitQFf5B00YQAuPXjhHMjBxTElsyVfixqUPSYshvTM/yAx2hsOqPfqmd61eeXc1z4V/tlEfuperWMBnVbkF6OHiyBauu2AEnoA/Dh7Yzy2M1ji7y6xE1NhlLNBcrt1kiMvNNhRq6vnTNrV5flKMjJjzzuxT8Tua9gUib8xkvnQOVEPDXiF6xhvVOtpcKNSSaXH8boGZ9pTJrYnYd2/MsqcXjKxEtd1557FYdbnQexmDs5nr++JfQNy089aa49m5jjt4+fQGN3xmzjVCT8TFKpiEq26DMM15sN/BAB2kl1IJoOP2MhhcbskwpTlIfVsA5IGp4abN
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

