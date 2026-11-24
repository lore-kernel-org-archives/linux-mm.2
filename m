Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A838606A335
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W8FJArd0
Received: by kanga.kvack.org (Postfix)
	id 6E3776B0754; Tue, 24 Nov 2026 10:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693206B0755; Tue, 24 Nov 2026 10:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9886B0756; Tue, 24 Nov 2026 10:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7746B0754
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3B3D40C1F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:47 +0000 (UTC)
X-FDA: 85470415254.27.CB657A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4ACC014000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8FJArd0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534606;
	b=0zsSax5v/50q01RbfO/NaF2MJ5uLoOQzul0Ym2cc+icbP4cXggCCIAigPENYxK6aoWPcRt
	WwskngP9+H5yG31T2v5CrVm46ug8OejCh1kpt0rRyBQ1QfT9LhM2CZp6mBKzJ05332ODrg
	+wKqd5Z8iKZ5UPos207RiVsc06yoQK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4WULBvjRFLiiJiFHBxE8QngaPERSKMf2wY3GVjljHk=;
	b=FN9trndegjq7X300VIUgvIwS2UJkU0vR99C0ZMEJNSb6f9sI0xVFuxGTYZmsOKJXKLVpjL
	OTwZKhV/83us8V3asZAvXgP7umdbO8ml8dQZEy6w78CLrwi69btT7AJqPqG4eHmMezgu5e
	wxtbxcldxfgqxzRw5MHygVPj48UZM7Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W8FJArd0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77489443F0;
	Tue, 24 Nov 2026 15:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F15C1F000C4;
	Tue, 24 Nov 2026 15:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534605;
	bh=s4WULBvjRFLiiJiFHBxE8QngaPERSKMf2wY3GVjljHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8FJArd02TjjV267Axt6tnCzEbxh0b1lW8/BK+9BgzBpnnE570ian47fnlAsLTDpX
	 i7oSZGWwPHsUZGtZoexTSnfwYVKENPVEiYKDVg6LDu+stI7CbGpVUfkEurKanNZgcc
	 IR/BmwetXIC/3m4YDhMJW522/nmB9DVV3fm84n8HusMj5ykRt12EKizZASralzAlfA
	 PzcuPGEqbUUbjTZf9u6eFPOp781Lqwteg+6NomNY1Q/7C2slRMCWmgbtoarzamLWPM
	 i6y7k72gKdZqJjHamUgKLxaD4S8TgQlCvOvrtEoeKmlWimkQH0lLUf6VXXQAmpJCWb
	 uu784NNzfpwBQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 01/27] mm/damon/api: introduce struct damon_report
Date: Tue, 24 Nov 2026 07:36:07 -0800
Message-ID: <20261124153636.91854-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: f3wxcqmau3e3zu36j9ks9k5y6tjesekd
X-Rspamd-Queue-Id: 4ACC014000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534606-840873
X-HE-Meta: U2FsdGVkX18wpWGXo2YI8nByJnAm81QChMkYoJ5b8ZkZeCUBUIQdIdrCahoM7WhSP9xLkLdvNhhyM5kqp7e+xvmu6lOnTRmDiiOL9Xip/AianjRnYncTibMZ6u0SLOOgy6vZMlD9jpJwOAH/+/2Py7Lu1um/hI9lqEmMrFapJBwAWUusXdkaHT+ErDzOg5aWK9kR1SghmXzyukM5CTXbxjt7vL9aY+DlLZhCZgyjX+aEDJIwrvbRi35DQV1aAdI5h/DOLhm5dh01cKOSU4yP7a9mPcF6DE4A0QXzRARuLS6lCN001OwoY77KjCla64pkylWX62Cxkfva1exj/GKFP9ve4zoVsyslJZvoZ6NxRJAzjJQX0ZRXsp66W5tnj4VYnqeSOXqBS/DfQ+FpZV07mT6NVh0jmQvBe7ma33L5+yz1jTiSQrZxcesrgCQDmlK+TXu4lYLVajkZMpX1fI6LAI1vGUSsicYHkRm7/ptEozP98H24+Aodz0Kt4TePoNoNtuFvS3D1IlMjDHMp2/nfuStVpt0sKgvxYZ0/LHN/JEgJafN0IWm89ogb9Dwiy4ypDf/f8Xl2KJ/BDD8O4PxEMnfaOQ9bm4GKuipuGmV9KKLDY87bpgK8xJCF410rClplFGMsBjrgYGCGuuXeLilNu07AwLkRcA0vEB4fHeiI0qpSMb3tEi1OkRhtYqOf0tAvupiOyIQo+AXbCP2FtJJ+SQN6Q/7VJgqi+7mNySVmxrb6lfMf2N+x7zkqJfnAHvRTmIfC6/cm4zZfyTgA++i1nEfxGprV5nel45QZJLFlppCdk18P/iUkdslUtuf5Wr1/0QdBIcL6af22FRCfjCjmf61Q1i7TPBfOiFcSjtWRdndi7TQ1pNox8TlpTPJMVbKEH6bBOU9ueMnIPqKWabKwqwK1+8jOEA4UwwdE9A1F4TPlfCReWQjtCPTS0IL1voY+Wgn3X89wz1ODdXL1nIX
 c6hRNvKI
 WcNPCKVHnq1JJZ1JcLW3kCqPcsK9+7Hftu0F4dy5n87d+zele0HtK4C9ZNrpBO3dZhqI6duVbfNVuIxdNeEW12FVJLzib9vbEJJ2f5OpMo8MCgaEL+/89u7yfLRmUJG2r0uqlevI3EFgbXZIvmlkxXZTTa8/BFo/Q4mbjPanR0j3M9JGs5bsKwNW9mdh1G5onQBz/Lree7VpthfeLYLO+Xm6NwkzuxL0ac7I4fqLWf4R1ZCauCajzhTH+ErZ/+rUArApjvg661um6RbHIvLQNI2vRWr8J2fIHVmSFgWHoF/aVJbGQGVxVvon7xB/nDiW4nyNK4/scTStelMeDwT7X/0ec8/F7yjLyu/Nrin8JhuE0KAaLwTXFMl9G1EPfXJS7kgj2ttMh+oT49VsdRN8ngbCeKCpTShYJVxkfTbSmomcL2ezAw7/euyN36k9SXjlMcEsw9O2Y+02Fy5USc51LHH6c6PuyNNZ/NnBVYIxniZ55ODIIqPc9bCccZ6Hx19shflH12m0g8/Q7uiRrgDF5jFBXJL03hirjp4BGWREPBJJY36zDNs8yn5xb85hbJl756vqn6BU8Dd+KfVX/XBpgJXmwgo/LwyKk52XG
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

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3aff5c525132b..2520c036306f3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -757,6 +757,27 @@ struct damon_intervals_goal {
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

