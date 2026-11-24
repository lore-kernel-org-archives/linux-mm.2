Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49926606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RUt25NHq
Received: by kanga.kvack.org (Postfix)
	id 29D616B077B; Tue, 24 Nov 2026 10:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275136B077D; Tue, 24 Nov 2026 10:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B21C6B077E; Tue, 24 Nov 2026 10:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE2236B077B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEFFFA8831
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:01 +0000 (UTC)
X-FDA: 85470415842.05.258E9E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3CB56160010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUt25NHq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534620;
	b=zykad3weCCE4/eRHPvB0WHbqkoc9ezDi694ZFPAaGlocJLcKFWKqOfraRKXcPwNK/+JAKG
	CNnwcpUaDDyX+26VfLE+KPw3BpBhP8dp60TdBAS7ZqEUUIaFYKrz1kNuAkCp/ZBlDyA4G2
	bnCRPr9AWNI/dxASLHOgbicZ0dxX2dQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bV7wk5atgqZx3K8k8thuwxM/GcO61onakPYDAERNzzc=;
	b=aWJA5hoSYTrSdo3gF59Hi2MPf2attPeltTPwrzi8Hl+S6PB0YxomV3AEfFn5v92XtZ11t/
	yhA11Zx57/kfngzjQfQi1a7AVI/nX2OtHWz8K7c51VpAWOdCXnyb5wVczNRYn2JiB5i2gs
	bhUNv/IEOlGrK5mcwlfh1sfm770uu6c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUt25NHq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D374B624AB;
	Tue, 24 Nov 2026 15:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4447E1F000D1;
	Tue, 24 Nov 2026 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534619;
	bh=bV7wk5atgqZx3K8k8thuwxM/GcO61onakPYDAERNzzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUt25NHqsWpO+D3tSnNCsehd7GAOO5VIeFCOff/Fw/iRUJn+MwrwrPF5GGmMJY42o
	 6MKq+8WUD1exqec9knCN1yC9l4U7r+cf1JhLm954XUOlxPAP6c34/KQY6ceCdeNQTW
	 sRmc02IDOCSXkGBitklVyQYg4heTnnIVzLbH7dmjXkSaF4QkTJF1+belh+tAwfqxpt
	 Hl4xnHZpXkNVGA4XdKF9T5ZV+RNyiTz+R7BkPewou4aZfzWG2U9Tkk7//WYHnxIbQK
	 v2lU7gAtkCQPmqcDiSeIVYrfk7oqXESZgdrSVuaJxqx8zAhrpGgeLfxf5vUscjVGrX
	 MQoV+60evlxxA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 20/27] mm/damon/api: introduce user_report report type
Date: Tue, 24 Nov 2026 07:36:26 -0800
Message-ID: <20261124153636.91854-21-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3CB56160010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: juays16uwjgrtafemruyd6iii9nktms6
X-HE-Tag: 1795534620-810222
X-HE-Meta: U2FsdGVkX18VbTlCoQ//WtCC4tKTQO0b271GBIKGLv7MkOMMqk25+2FMpqPQGZt5VXkwGQS1QBjODlrWuYtU4ovWzBXCA31zSiDak9fmbb25R1IEhtgRrv9kvoaoSaIj++g8G/iQhQZK1UDQOxHpB5gt9daRLvGm9lZIADAobt+9KyuWdUoAyVySktI35+KYQHn4TxDuNCGPVoR97f6nJ7I3s5mYOG1R2RkB+cPLNxTCkp6npnhrVAIFDydQcLLIcQXStzawzEL9GZwY5RFjkIudzhQiSyeT16d6qfsLRd6Oc+H7n6ELnpbY2ce/hxKWdqrjHlGZM4yCcqNCGOzQyvXCckeoXOn3Fr1NRNbA3su8gOiLhTdTCm0RQXvHIbjHgz8DvDoRre6FI3fzOFIkalMC3Z3Ekm/040do+YjmTkaBSYZRQjpxQj3YtWPtaov1770CEj9+8zQON6Ww2MnbqH2xpf3xhyNDA2DH0Y5Fvb7TPIBn69o1hccALIEuTgZ2mXndn66KYYjSOwOdsQJb9adIUa0tMnFARzTOv2i8MDJ6qI5ELPTDrXUvFkHyroQa8YRFU6vYpbPsk+3AaC3QdOJLr7Peg4055oY4ZJbiSmrHNc/SWY3VzaOujEnQY9dv6w2eMzM2IdNZmf4kVppDACnv7DdxP1fxeWWTSfdYjd9LzgIBn2zPOL3ndn8DkIr3ymLYmCtlCPdfAtkD2YRLi+70c9/ZBg3DDBJlxezVfR2yGdy2FZ1OVz4tHsBYYLw2JZDDfm9reg5gBKo/yq5HxNiqpzknwpLvLLnB+HDYHw2lsCCApptgnqX0As7CAEynlNAh5j8x5AHp2aXHbvIl6kDq5ifa2+tJbgECjIiDKuLIZ0EM+0RFIXu5zFADSG/NROCOQkJnVF9uTQLQRVCIv0eaL+wBFbEuBaRFh2PFS4TIWV3NcZ8/Oz0bxritc7Ljjzo14mDdJCD0ASssJ34
 8jKJghKs
 TEWaNv1hE7uR95sUVG2begpvXDJAQKvCUaGfoladro/OlfILzQN0O4AjrtqOqFN1VlCFpuNkMsxleNsiuFLirUAknOlgcbpPn/HVpLzfoPG+8wMblMNxXQFQ3N6TdFP56kuLMciWYKLxhV3KGXIOjwvPNJErdkSUwyo+F8y7Eu2EvWjH6RvW4tGtIooW/SmkH9X0NM6u7cWaIFwDvolyhSabU8PxevF9jEQ2a1m+jpIOtrGeOr8evYe7LuupDqpseXnL3MuQYBF286KsrQbR61Yihq5OkBF4mw3aSwd/jSps8snuBr2KvzDD5WfQaEJMpl34iEJSnmr0DQavL34sncczjO6GOEj2prCi7EwlPHmczG0B//hFJ2XUUGsUAJdSmYoW29SeI6K1ypbwe6dX2wS6wW6hAzgtGVJH57RZDKdIU6Kryp+sxKWk80yPwHMCeubElNs/M8dLKFXmoxR/9749PwDW9riZvTRF2dT/g8CgFnN9Jqca7TjD+n2LiPbb+4JEbfOLTnJpRuewmgGzA+oWk5xXi5TqEJS9aShRCxtdiIywkQ6XxXuH8AAs9AgZ5u2PL8jFhk2Axxo1gfB2Rz+KiwQ2geOnAXBtZ
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

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 38efa41b3d1ab..45c82f536da59 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -759,9 +759,11 @@ struct damon_intervals_goal {
 
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

