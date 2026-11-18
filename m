Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E5FF606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JZudxf4I
Received: by kanga.kvack.org (Postfix)
	id 3BCDF6B05D2; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D376B05D3; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AABC6B05D4; Tue, 17 Nov 2026 21:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E06B46B05D2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 873B940623
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
X-FDA: 85446641322.21.74B7D78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0436620002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZudxf4I;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968560;
	b=4XU8SAeM4fxSUFtIJM5uDSmx1re9MOUefB+Hv3v90NgQxD2Vjno82S5DEqTbYhDtAtTU4M
	TbZKQ5oBet+vFnCL00pSgYlQ3Pg6no7FN21Y0hkRiVcCxar8HWZRT6dTetqCRZBv6GXrcD
	EyBr+1xS5RSWTCdv8Bfaj5RLmfyfOLs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JZudxf4I;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTjjk1bjDwpUg3WWMwzBwOs56rHK1uC/DHx/Q7GkWVo=;
	b=Ry9A9FfCLeXaIRqncjuoYTjl23BdtE8bkjAiW9ePwagpmOW4CAOxS6xCyjFYsMdYDe25J5
	my5R08FuqFaVvzd3rsRk8YVlhMq3GrDhgphn98bNtfn1B3gv30Zp8vIYE0uv49nw55e5PQ
	6m6OBe/Ix49OisZMN7FunvOZAAHdIPA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA57A61F41;
	Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7671F00930;
	Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968559;
	bh=FTjjk1bjDwpUg3WWMwzBwOs56rHK1uC/DHx/Q7GkWVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZudxf4I+nlm4L5dLPI68T1QC1WdJc7DTvR1ULXK15rzL3e2ggKDs62o4guOnPcLG
	 CBcx82J0Jby9BZBw8RFcfDhwb4DEiCZScDCqVr48sPvGCOh7dGeK5uVz7sUU/9ugxK
	 uN23rNlYyRkLRU2N6OVv5UhNviO05EI3kxBjB82+J14mokBjtHLY1qqc7bhSOMk0lX
	 Z1rBySGatoo/XE40tQNxPuxfyK8/bglbgTRBYGHyQyZNFcud1+1eR6VDYprF11T8UR
	 VcXrEdQ+6zMMMGxXiVVh7SX0UTvEz/7hUygg4JGRpO7tp0DB9Yg2efF7ErDhquzRIw
	 +19TLT7Xlh6ag==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 21/27] mm/damon/sysfs: add user_report support for report type input
Date: Tue, 17 Nov 2026 18:22:16 -0800
Message-ID: <20261118022225.100659-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0436620002
X-Stat-Signature: hxo3hc5ggjmc7tpcw9e6os9izbpsrxpp
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794968559-203896
X-HE-Meta: U2FsdGVkX18DuO/10anF7sN4grRxOX2gZe2k+dFnl4Jc03o5ZnlkRahy24xa7hhNcxfBjs+9ztHXW4tyxYbvHGAGx54n+b2kVJbxoIU9pdTjsGuYoXp7xLYOFRVuTrykyVUaqZXb5eIuTkUIZ+zDM2xcU5fi6nLbom+vaTZeXJdy5oUMkqh6B1/Twjncb+mXnU2hwf8N6M3YA8oHSiD0sSpajlCaQY26C0CKZXJqD9sEPsanr+rNZzAhHVKy4KEWljv5lXbbiCH5YpTHkrlN49tL2lA/ubMEEcTPKoXQO9VPm3H79goYJ4i5AEEzcicjeWx3yLoQGiBaIn7TArRLAUGnEp+94uD31Z/pEKJFojcCANs6KDwiXRvhD6ljiWtRFtQ1lworeBCiRoKaNc27TxgeVUi5MZ/f7772uT7VIaaF5eHGDAAufw/VwqxBMyVK5SCMUMeAosvvnPZ9fqJHXm9pGrOdAyy0Xze5V1Mj3kXXmikLJMeHnm9t7yQUocv7hvmIa6v43aLsp7/SiRW9I6p7nKdpNG70eNz9VTm14+ZZIQ8SvCTKOvB2H2GTgyosLG7YKHP59/EUtgJSvlxmAucqvSutoKr0J0cpH6pbnPOO4S82K8zTvGYEfDrwsc6Ev0ktbIp3M8CzoJlS56mGdqufMbB9qqrLsl1BipUfhiXnY1iGLc6dAgPcPnzYqI4KDGsk/+gu6GRSKTpvHKVxamgM5wQ5tZTohx8tC2DIvq7t7qdi8w5SDgAJis9Avu7Cyu8J2CcCiF0C2K+SdeHoDYgBMx2OLbHVgg2TJpuKWMTvZiBY/tpVuFr2j+Au/LPWiOgXPGZc/JeDIo0ciBK/4CAdPp5rcuDvCMMC8Haur0YxwlDufJgTw2qDZCGdefpC0mmsHn2nXBrboL44PcZVVBQaKqYKjooutjNZ75nTN99qxURKGGgCyMeA3VfV+vgn29FLL3YZMxJ8FxWsbqD
 ejQkc6+u
 5QY6n5f+73EsG4n9BVK7k/zBLybtG4/6rjx5Nt4vOEXlxEl7yKGDQjVyiEy78SAuheHJZ6Qc3/bCPGhejVXKd+hcDVtOPQSc31pl+i6JZ/FNWBLMDHX7h/gudupcdoASjsl6qPBI/YjrUgjIbZFoz6cmGQYokgJObZ7P3eCTrZ1MjkvuoKl/tKyZOJ4nrsBkAadBG8J3KyY0I2khLd5UKRmn9EwkVE59YBsQjQPe77NlFm6NLL3RMmyCl9ZTEhrgSd+lUth09KkKQxQnFGenQ1UiGYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the mapping list for data attribute report types and user
keywords, for the USER_REPORT report type.  Use "user_report" as the
matching user keyword.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 1c171af4590a8..b4d898ec0c9f7 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1187,6 +1187,10 @@ struct damon_sysfs_report_type_name {
 
 static const struct damon_sysfs_report_type_name
 damon_sysfs_report_type_names[] = {
+	{
+		.type = DAMON_REPORT_TYPE_USER_REPORT,
+		.name = "user_report",
+	},
 };
 
 static ssize_t filter_report_type_show(struct kobject *kobj,
-- 
2.47.3

