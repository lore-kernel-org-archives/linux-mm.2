Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F071BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B622B6B0095; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12346B0099; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00BE6B0095; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF6A6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F1DDC09C4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
X-FDA: 84969412416.23.13A1F80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5FB64A0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nUz3sC9V;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jsk2BdFiGUHsrTa06Z4d2++A0lkUUpW19Iv6q2KjyUE=;
	b=tQfNSdf1LwJZbGME016VNg8s9kulitA8zJjXo76a4exUrtBIWLDF+lvri2rH/xi9c4LzdT
	Q+WU6ijK3cBaV7jkpqUDWPwy8oZn/Cjcy+4+JY4uOepPacppoxq36287GU4r0bH+HbkKZ5
	TpkKXOtgMljQqfVpf0KzDeyKayvTZQY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nUz3sC9V;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605966;
	b=dk+3DcWCBcjTAFq4x4FF3FCIcsksR1HS583Qs/H1dQNdt7PzSUjRv3SR6L/T4jn7b1XUda
	rcm9c8hFvP+nSoc0O03GvVemS63nsENYa1ZJMeqXR3/VWp2NYesdgeEL+RoiU2rtWJlVqZ
	WwVGJTcRtWkHGqwCshGPRaDLGGF1nM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B254842DBD;
	Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711D71F00A3D;
	Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605965;
	bh=Jsk2BdFiGUHsrTa06Z4d2++A0lkUUpW19Iv6q2KjyUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUz3sC9VogqnlEvDBz6j8GRzhpUezqHRCGtum/c7bvZGwCk6XNOD6+2h5Qm9YgPlr
	 TVsnDPKThnYjQ1HrJgw4weB53Z7F44YWf4LYJmXef/N96Z7udtgMl4BA0ucxyRwHtU
	 SbcjrDuBpwkCyCNbLPZU6OdmxUfItPEfhI/9F8IHkeZHYNFwfsitIpfY/X6ZM8TP0c
	 Ttx6HjHtPKFpEI58LQLgjdW7FQxItyAwLFcvYEDiAJh82d2YM2wXlu4nCuDl3epuDf
	 R78rwDqNSiw8q+JSbtFk/qHcv7F6avCsUUae8cRm5tm+jW/Tf/orTqETit8rj24y+B
	 qopUIlxBhdyFQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 05/19] mm/damon/core: implement damon_probe_hits_wsum()
Date: Thu,  9 Jul 2026 07:05:43 -0700
Message-ID: <20260709140600.90950-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5FB64A0005
X-Stat-Signature: gumjneyxxt583ywpu5uxhssy8rtst5g5
X-HE-Tag: 1783605966-182551
X-HE-Meta: U2FsdGVkX19xi+hu9yUbVO4bHab8nUouFMbc1DixCXXN7Ug2hM24yqV0Yqou3RvmhQEVwpnot1MaYj7BHGXkyRXfdOq2CISfeTFcOaqvWAy1X1/lipvqBfOqObzFIVkiPuQPJL68UVb6xOXhknV54nIYRCqZINiVrQSeGllbh3Ov/3eNNVvhLdW/IHOITiazpfgmPdngJVITMWHZNPqfONkDsB1n+aqjAioCmz/eCSCBpTQ9B8ZotdSP5osi2xx0t7Wv7HYTAZnr0T2KpgDix4Xl5TrKCSbiBzAHK0055QsC3ub+5fg8BQErAl22XEGc/zgnRn0uKbr/RhgyclzbLMKCO11j97KSrBl5H38GGSzJ28YKOy0bFeM3SZ4Ub0gJdpvnO5dp64dbbnTQoizR4lTtCwkjfqrVRJxZ3QwPbi5XSuU/2M1b+4J/jaWeJLzGzjw2zHhxq7RDbICRn1FFjxcifrFOYCvnvdbI19Tm2W33fZFPvPGsKczA3IDfW5XZHWb6t759eksZO74VQfc2TfiykLdbafFIC5C/QF6I2TnPz0/1lvWeWifltd2IgdYPxFhEnAV/jmzhi9ss1JcNZJB+/PraCamty+t02zdVJecPYb7tmLJMFU6uA9uUQkAGTWBmKZI5bPwayZ5bddWRkUeQydMysp6HXGXukYltVzd5sek2pw0OtLw86OtwCg9S/rz073750zVZS680XbbTumIONRt9ZQtoMMx3AEnOVeSMnzk722/8QKaWdanQHq6f3ZI3k10vIKxj718wpNC8YxyNW45ApjNpG8hLMGG8QuW3CkXlnzu+x2+ckeg0+Ntx08OyCWiNOOVyduij+yiadfuqc/sx+BAR81U/zfxFQmC+e04ux3u6iXDAdR/tcGiE0ObtZBIq+Q67/ORBszScROKL8DWRU6ZYYP084hf/EzT0Yr0kyJh4SMsI4OLmevnTQcvxVzzxRDKi7VYRUFR
 ZJd+NJMa
 5sEcxcxmH3dVT9sJkgYnJqlnaNFF/Wq297BreQjnlQRcT+JNOoSeuFh++ceSey5J6sj5OpBAAz/1muh/yxncGQoQp/K8O9oPyF2LxCYnIlPCdX6E9yNzIYRKfE8lv0O3vuqzKHKe1gB5BkkPAhkabTbVPwXH/KmthJPG2uOmTT/6Z2XxTgk35XSHhPPk7JPJCqDu6A8sPu/If9uHdkcLB2iXAH4yUC/zIGfpGy6sdT7QmYT4ffXxQSbAZB6Js4jKWKt6WAaMJFow8FAP+WrE9/EqRZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When damon_probe->weight is set, the weighted sum of probe hits will be
useful.  It will be useful for not only the users but also DAMON
internal logics like regions merging.  Implement a function for
calculating it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4e1845ce83870..516fefaf54dcc 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1012,6 +1012,8 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9f6cdd810bd8a..fea97399b5754 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -393,6 +393,30 @@ static bool damon_is_last_region(struct damon_region *r,
 	return list_is_last(&r->list, &t->regions_list);
 }
 
+/**
+ * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
+ * @r:		region to get the weighted sum of.
+ * @last:	if the request is for last-window aggregated probe hits.
+ * @ctx:	context of &r.
+ *
+ * Return: the weighted sum of probe hits of the region.
+ */
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+		struct damon_ctx *ctx)
+{
+	struct damon_probe *probe;
+	unsigned int sum = 0;
+	int i = 0;
+
+	damon_for_each_probe(probe, ctx) {
+		if (last)
+			sum += r->last_probe_hits[i++] * probe->weight;
+		else
+			sum += r->probe_hits[i++] * probe->weight;
+	}
+	return sum;
+}
+
 /*
  * Check whether a region is intersecting an address range
  *
-- 
2.47.3

