Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDF9606A332
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K0l4rjC6
Received: by kanga.kvack.org (Postfix)
	id A86906B05B1; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E1E6B05B2; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974676B05B4; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 639406B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E76261405DD
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:23 +0000 (UTC)
X-FDA: 85460344326.02.E4F1BDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64B2C100007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K0l4rjC6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294822;
	b=yo9dzhdCa9N1a5QNQes7XyLzRHxDxDvM/TuxlxJFIl2w+HaZOS2bAI/JafxUCaHuxEEDGv
	w+KYlmP3eLjpltGeazAx1pOYQfiUhD8rIHMFZ6u2XG34I4yJakkLQrhbWrJZWZCVycdjFz
	/oSrOugUuosnCa0PMI1RKtEdjTXqhEo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JF+qXeshGtN/Mdrgpk6OIMKsGHFFBSP3QQN4BVwWXEc=;
	b=hIVk8InSitvH0quKqA3KFobAZeLfznShnirAB93b9YnVZTeFoX9SNNJ/9kjNC3BdpRXFxj
	GLKYOtqtipbZNvoADAgdFBQS5qI1RkQ7n6KCv6gvoA0+tPdsWNFZT/uiEINVaP6PzMokkG
	bsTKx6QfZQQWGTHQGx98P3s7kUxrZBQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K0l4rjC6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 014D261B73;
	Sat, 21 Nov 2026 21:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7381F000C4;
	Sat, 21 Nov 2026 21:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294821;
	bh=JF+qXeshGtN/Mdrgpk6OIMKsGHFFBSP3QQN4BVwWXEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0l4rjC6/GxEYCDBQbgMmaqfldNP6aP3N4uPieQP0OctuOnfigSOpTSMB+Ha2jSkh
	 r+MPDNR+jSP2KwaH+WKhxu9+OTfOlMpN5P6WjPx/dPVazW3h6XAIFrkMneWR6To2GQ
	 T0e5FM4jCQUrEDsxMtIEGAFqgMswiPOpO6JVGv8tijKwERrEFoZWzA0VY4A/bU6lI3
	 AXWpI7O2aYlXGIUFt4l3Ebc55PC9EklJcsUIMN9A9DosWcOIeIBsMgdVP2H/s06R10
	 /nP/yy7SxHNTq80bJzttr3NUkskJiA7bTBPAL+Dk9xrfG9qtyPtIj55b8yAcTAmchX
	 Fe95THvqUTXQA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 01/27] mm/damon/api: introduce struct damon_report
Date: Sat, 21 Nov 2026 12:59:45 -0800
Message-ID: <20261121210013.130397-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64B2C100007
X-Stat-Signature: 4pfxztd3btefje6kyuc83hdfx7bxp5mg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795294822-514769
X-HE-Meta: U2FsdGVkX19+kZexby0iEoCXyix+RHgOGU+mcQE9yebKuH0l8Kf/E8Eaaczre2rB2hxEWNJxx2a33uQaHbZtvg9GOYmZTgmluOyoo9gHk5Y/aCtotBJZ1R8OA7V8Ot/suj0ERQlRTuBHCFFLhDMtD5feUSuZrA1HFDTq1xvJzB8bihTimh/EeM02DLHYVJ3yBJISAT4gjic9T/FF/3zlPyoLqzqM+oKVhjZAh8jRrvp+qkskE20L8Za20CiYDjo848oK3QejrsRBVTGxAK9+w7DH5zYFNLSlnAPQTAc+XmcDepChU0rpqZkfr31A35PA6UxdcUIMwKwKynUReFskIXNEdl+8/POEBx7loflV83znnVtHnRVuwXAFb9hRseYCGJluBQTm7ubAl5UvKx36RzZdRDVFdNHIvCDbcx+BzqC8xgnHqTg1lOlz/s2qHxqJ1cnEgFt00qd2C1VR+OrUMKweiCavIRuzbOnbr9iidGve/r6PhrA+KmmC1qa+6nCBjieWg1KTKS7A9IgHnbiE2WPLMLeDooPjMGX4vk62+TrcnKYD3ncJcpWEPKkyBUpIJZofRUSeRk9AJWnBPi/jgDKZM4xQkkoaQfE96iHAjZbZgsYBJj6MHxdvFeNBE0W3P+PPdh6OWSzumLBvmZpV496a1gkBrmuxHA9w4A5DxdKt2S5jVsku1YwKPj5hwYx4X+INEbbHwezRdmEbqxYV1qkwly39YGjrLWfJSR0hk/Mr6BpwkfbIzi61QR5UjUfMhtjHBH8MdbP4TgasxHr0f7bqPd+Ed9Z2+tKCb1wX7e76RPOiuaOwTSbe5q2DIhJjzZxJCuP5ieCiQ3ozvjubzdGORmEZc8a5oBvRcQd3NcktSmRWk5Al7AeaiBWLSGHn0KmqdAKAe3UuF0Ib5/ViTiyyY5abhnLVx2TTxoy/oK19rGnxwUQtfAdblTpYs3eyldwuAWvXgD1eWnNQphC
 IeDVjwZs
 5wcx8FoWCdDmO/rmFwe3cbgMrnW3O6tUwCfKsA9IuhPutxiqmk811gjQsQBUm+t2i5EbOnQxxpOaFa+RQlZe0V/vgV3Tuv5jjiiol4u9wwM8fsjtIJpzvCC1N2mV9jTz2DOQ3gxp1vnj7Thyh6B5o8v0mGrPkeNY8If4xJx6KGJSLybsIcmap6cdvpvXHpUT7GMIdNAoeVl7tIATu5DoyFzuoon2tHPJEsuc3kHruY7/Sgjlx8WUcKRzkDmJQFLMTQKD16ohfogGYYCJYad7DFTt7K7iSXJFGe6ef1Bapnml6J2NQZbDYcr9GHeAkvkqaHJxeBm2HyYRMklMOQEaUFPSTW4DHwUUoD6G6/tkk6Utdr6ehXoS0WIZkJnUn1qmKvkg/lZpXgxRO7pH4n0dilqo48vPuncDouplGCBJeZGcp0FmQTek5fp16sR8hJiJ9ufqsJRfydXP/2WOK3ULv3kLdgLvEVche1iq+tdS1BBKxtxMmtWGRRKiOGQepggi73vDR
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

