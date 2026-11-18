Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B602606A33E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oVVoCg/Y
Received: by kanga.kvack.org (Postfix)
	id 78D956B05BF; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E816B05BC; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541DD6B05BF; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 143076B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F9021C3B56
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
X-FDA: 85446641070.24.7CCF880
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 08A8F40004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oVVoCg/Y";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968554;
	b=YSiYcYmhTNOMz8JFxkdSNxxSi2U4ZcZsUKfS4LcocZCWxR6mkYiZICyWXdapGeA2nBtlqI
	5nP9Ei1j97JqUhp8x3gHqxZEP4/T1V8oo1cLgUgabm70tY3ERc6tdb6SjOrzuey/6qioqp
	qL58LXYl1nX5v808O1UNHyl5TGnHvO4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oVVoCg/Y";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF+qXeshGtN/Mdrgpk6OIMKsGHFFBSP3QQN4BVwWXEc=;
	b=Rc0MFIwB2UYOGUxj5iQrLCBwCvHMrKIz1GlpgYjMxZJZdLBe9dik0fsjxaptMrlNBe3nW8
	MOiz3Azce/ZXtdV4M0c21L7NrHg9BIrBYzC8YrGvDNnGhpuWp85WxqxYdrV/lymbwiGSzG
	cg8YPEW7imsjMKro0LPWiNk28mMixVk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E0B261EE0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FA41F000C8;
	Wed, 18 Nov 2026 02:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968553;
	bh=JF+qXeshGtN/Mdrgpk6OIMKsGHFFBSP3QQN4BVwWXEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVVoCg/Yep0OK6Ox8yTsCXbXsxmiGxMt75A2Qzf2sA7AD89T3fIY7nbr9zH6VKdjk
	 bEVLdKIMY1oqOxutGTN3kcDWq/2VYf4qskGEh7bDymlyoMx1Xz+YZWrCdq0sJst1f9
	 IO7Gp6pyCHVgUPAJvagaMuwHL4IbvynL7LEBcXGCQuISLQa905IpvQ0V9CKU0KT5u9
	 jCoihM21AvkEnf2GCYf2v0psBPOIUQfyK8GiZa+B7IcoGukWAU9+b79bsgPcqA8oks
	 GGxPidLyy4+p4H7D+MBqRDt7rj7M8R1PGY6o3stxmgOfo8WSXfcSskWMc+nHortkZt
	 HogBPESgMKLIQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 01/27] mm/damon/api: introduce struct damon_report
Date: Tue, 17 Nov 2026 18:21:56 -0800
Message-ID: <20261118022225.100659-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 08A8F40004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zfeq5i1t3w6x4jr36hodj4s7w5nz6o1x
X-Rspam-User: 
X-HE-Tag: 1794968553-954866
X-HE-Meta: U2FsdGVkX1+LdGywQbrxUH7U0fw/oPh7NBveFVj4BTF2nE//mwLCfsK+3vpbZctGFCc5vEjYHbq1fYJ/Jfcj/EjFMTdsIj04SHZ6UOJ6jkneh0BNnQUmfDFHV1A4ll2ZOn/Mgd/wro0aSmW5hRjLIGMwcDc/eQRsvfAJZoarcv+Bnpx46q3VQUiQ+r4cplXVUKk/PRq8U0Dd62eND7SeIWPv/9n8zGrLcbaDHi86d6qnpRGTlKcXkuykzfaHxJssUnBfBvgORT2aphfKJtiQHsyGzDmIz1w4a8wBfGoXgF4utPfpUlM4QtXeHM7WQYNf3pjOy74RMtByYpydHXAL8qsj/HfV46v38vmDYcXSgf+FZEWTeb4aAFTTyhjTR/xfiETHWqjwnomId4DVj+ye+kwPpjlPiSdwPAJ0tqyCErHZ977woO5iA6D0WtLjTYErdmtk1dmePlcrTgrnSwfDNZhuAnVkhoJNi9/P5U3c5rwsDCPlINWvXJRaa3JTb3feaZJRtM6ajR6/sjviELXuNQBNjUqhLiT+VdQsnEfO5eCyhcp7ilN51MoYRuB63NwiWMCy4opxaevFIuIM8JnwztHYXtxkrNrQD9K276xbvoPJXuXrZ7CCViDmBxr2tGEWkvh3THUnPxCLmaQP2QJcjW7XVumy2G8Hhz4zSlk95j/sKua3NQBrqf+AgSJGemkt3auYkSDYdvIx7iGG1qwvgpqYmCc0sWlSzVSBGd8rQ1Qx/ApKMnOA/EIiJsDszX3hQwhVg/IlkCfebC9/53/dQHYxNPVq7dEQCJe9SzCbNAdOS5RLPA0yKYCKn3GpwFvIlLrwGKhL9fkr5DfIt9jcS24pZWr6LQLT73Ev5shwJeXDl8Q3nBMm85Skjs69o5ln8xCs7VC7VPM+sa/5XD3iYmsPQr+ms2Gd4i3fFbpDROHXKiBHfpXxZIFcyRtNjHhLYnalVFUkIopObDX3H/m
 0/UpyZlZ
 nQedScmc5JBZrM7BdLf2/H8E5TFv632KEmTWQVWcZ8RqMle2Nip9S8an/ZRwlknx3EIJ6x13f8kGUwkOxkR/siuLgFHhNuySE06taBsrLnu8ZWRcxx36akZO3R3GrOGcyzgW6nef9/W1rF3hAaXl0DgbvB+IO0caYzqdFObARSuP3pUamQsjX7xtOqzQNslhOaK1Gt8AwIxiBSfzItoFuBpdYATd58yx3csyIpXbnKG2e6lQVLJ66/7gMzbmK0YUCfRl9bP2j5GxvlaYrB1HX1UA5AZE8LhElheslihekx+0CdS9Er7Ejuq24ReT2szdrLa3P8eV1yw77VNYUKxdvGcUTrikn9foWr0CK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Define a struct for data attribute report.  The struct provides public
fields for the type and the memory address range.  The type field
represents the type of the report itself.  The address range is for the
memory of the reporting data.  Data attribute producers can format their
report using those fields.

It also has a private field representing when the report is submitted.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 06bd92981af21..cac1329397a4f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -751,6 +751,27 @@ struct damon_intervals_goal {
 	unsigned long max_sample_us;
 };
 
+/**
+ * enum damon_report_type - Type of &struct damon_report.
+ */
+enum damon_report_type {
+	NR_DAMON_REPORT_TYPES,
+};
+
+/**
+ * struct damon_report - Data attribute report information.
+ *
+ * @type:	Type of the report.
+ * @addr_range:	The address range of the memory to report for.
+ */
+struct damon_report {
+	enum damon_report_type type;
+	struct damon_addr_range addr_range;
+/* private: */
+	/* when this report is generated */
+	unsigned long jiffies;
+};
+
 /**
  * enum damon_prep_action - DAMON probing preparation action.
  *
-- 
2.47.3

