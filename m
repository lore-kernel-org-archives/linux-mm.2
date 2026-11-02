Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB462606B1D7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZ3jzzXe
Received: by kanga.kvack.org (Postfix)
	id EE41F6B05DF; Mon,  2 Nov 2026 10:08:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB98A6B05E3; Mon,  2 Nov 2026 10:08:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFDA6B05E2; Mon,  2 Nov 2026 10:08:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B36146B05DF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 453541A0155
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:11 +0000 (UTC)
X-FDA: 85390509582.15.0D9D6BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B39814000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hZ3jzzXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOIOo2WRViZfcB5LyNG3dNe7ZyXvt9pNDQFYal3R+A8=;
	b=L8jaWYFY1hv0imp08lDmQp3KYc8x8kDafgnyTflPywwkuvB4tyx/KHmyAogNMPU6qh43kH
	fHSgqqSBagg3AOU4EtBPjjyj22Tk3+G+IYvt+TSG7olTxQnVNVRbVuLEeWlqKyeyOCgUty
	aM4WZxZF07TJZW1mxShLnOYaQ7udc+g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hZ3jzzXe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632089;
	b=i1JjhSlSJDb2aqwmo9Cz6wJ8AGAWE4yDhvXqL9xrJxUDudAJbY9Ypzw1OiqcET25V9ECv4
	SyNy/Q14G3QLWOwZICYsL2qyRJpLG344smw9793zjccOt6YMys+5awswnWRSUWV/Zx01kN
	CFEro+kMdVt5Mn572Oh0U8lnF73PW8g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54159605D6;
	Mon,  2 Nov 2026 15:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10721F00A20;
	Mon,  2 Nov 2026 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632089;
	bh=EOIOo2WRViZfcB5LyNG3dNe7ZyXvt9pNDQFYal3R+A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZ3jzzXe4gx8n7MBZeCRakfm9HOlLvf9jFjlwFESg5Jm4sD/MhZAQt8kb5DlUnOK5
	 DNbU47GQk7H9ZMFiNYeXo9J/oYvXNRctFi6Rpt8O14AS5hvsgGF+mRRfcWT1TumK9q
	 cHUdHZfgyt1jRhTXCc6xTE0ZebWXnQsYzVTUfNWdcbuPKU3CoDrowWsFP4yG5Jj2iZ
	 Vy6SgRoqAo1Hhj+CQXjfKfluEIBUOedbelAexoQjrqaDyCs8eBBdMDrsSN/49zhbd9
	 wTo/4o+CT6VNTeqiaDES5LNSgGaJQKD2BmpAt6ItswXDb1fp5oHS1Ui3exVch7ZPlX
	 OqkAAEfW8FnSw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 9/9] Docs/admin-guide/mm/damon/reclaim: document how to disable watermarks
Date: Mon,  2 Nov 2026 07:07:56 -0800
Message-ID: <20261102150757.93058-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B39814000D
X-Stat-Signature: 1a5uoepsb939mwfgjio98cgoyas6d6mp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793632089-724755
X-HE-Meta: U2FsdGVkX18XCnTyZJK9T2GmA3d1fhDMOu+Xh5a9IcOjf/I/3tpgi5D/uEAqYcdmaawz/SvEuQE7otijY4pDGFP14xZJDHX1p+ebP0HqHzwtiBxRws2pQP0VUuRCj8NmFWREzIpfPjgLkhY9lxVpLq4dC/IiC1r9Pnb2kTzmI5iKHLmaLmTLQP2SzuUw9w5s9WHRvTf85qu0dIFM9vbbA1iI3OcC6Ww4HcKRxO49KIsU2tdNo2fnFXKB+QfEw7eJPfZ9BNXhHibgUx2qzcdcEZawOCyyBfcuSkmy7O0P5sIg7H3GdEDLOvAH2B//rr2HfA1AIJkeIb1/mTdJVdR8xV6jNY8Y1KqDywpby97R1Ylqe70PcxLf7poiErgHG7lqazYluIc9T2ckE++aHgH75Hms9JSXBOHB+401WKg6PkqubR+ABp2dduxyit+KU9x8TyjH9Co4QVVgEpwcaoxr4yibcdPHPXsDKJomX7DrOfs9Sh2SsoNtNqyY/6V5IODbVBcZFBCbl9fuswNBEnBxzufiWF2ChQAJEzWXuJ8/5HcfvIDDUntDrdu12gr4YTwQokY4XT7PQX/iwgcO4igNVHfQDmyuhr3CtC5etpW74Kt3rMvIEzrJetOqnIDRRGDiUOoYhAzffXYGHwXb8vbyB+j3ZnRBYyvXIoYStCmLsCWJc+S+GMgQpys7kLW4E9Rhoyhkj/nPqR59nx1zLIMp2dMS2FvVkjt9dn66WyvBAZSU5oLCYOeGokkDnbCaNSpY3bCDSVJhaewFvz2U7/eWrSsdcqJPXC6+irvMvv2tTEB+CWnsBtIDrNe0Gb3ffZ01v7CniMUXF2ZoBPyLJ7DXYO9836rC8o9gXlr5++r7RBBzsNYyKs2K/zInUpDXf9Yxkmit5YaSlqBoGLYSHtzZV8pURBngJ+RcCju3rEtZ+OXRzUkysk8jrOkMTx8ggTK1seP8EPkVFFMB/YtWO4x
 Ns3hmgSG
 YZWF1fI6txnCLWj21H6or+gk1qmckp+ek1mr/7CDdkjtuS3uxDAdoEox0ykbazu8F/WEykqtwDIShNUc6wyWzESVACn3pR5lgsjVa+9VDTgdKEkml26ivl8iS3mXMUAP/I1zGtAALpRPxLYlFBnsQysXp7+yoPloZSFpcBkIV5L+CEKFBXJGXX7pfqbUnZaJrXZUMNUksyZzOGAjyCS57zKNU72NF8mjnvj2iv5IQx7AyEj9vWF0Lor5iyfZ+mUtEE046
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jinjie Ruan <ruanjinjie@huawei.com>

DAMON_RECLAIM runs its scheme only while the free memory rate is
between `wmarks_low` and `wmarks_mid`.

But some users want to reclaim cold pages even while the system has
plenty of free memory, and it is not obvious that the existing
watermarks parameters can already do that. So Document the setup.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261028023628.795637-1-ruanjinjie@huawei.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 Documentation/admin-guide/mm/damon/reclaim.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index ec7e3e32b4ac6..14f9b82b38ed9 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -193,6 +193,10 @@ DAMON_RECLAIM becomes inactive, so it does nothing but periodically checks the
 watermarks.  In the case, the system falls back to the LRU-list based page
 granularity reclamation logic.
 
+To keep DAMON_RECLAIM always active regardless of the free memory rate, set
+``wmarks_high``, ``wmarks_mid`` and ``wmarks_low`` to ``1000``, ``1000`` and
+``0``, respectively.
+
 sample_interval
 ---------------
 
-- 
2.47.3

