Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD3C606A331
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S+G49136
Received: by kanga.kvack.org (Postfix)
	id DB4EE6B05C0; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BD16B05C2; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0176B05C1; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 944256B05C2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:08 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38EF3A07FC
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:08 +0000 (UTC)
X-FDA: 85438492776.06.3ECD7C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A28711A000D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+G49136;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3VuRAkKYe8EHkp2JgLASOtjfe+EnSMbvCKOCwj6jzs=;
	b=nlLS7bPslyOa4wOfPjfFMEmaUf16NBSidzIEfeQ2J3F4uBYzjb1IUq6q8iDYmNlXP0rq3i
	RDZDRCywcHo2XgIJxaHYA6/jUj2pVoB6GPhEArLnLVF4QkAlGdClsKqRlE3wxUZFd40TPY
	zLzteys+Yc66SkzuB8IVwwe04AElCzk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+G49136;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774546;
	b=kaO1LEv3YwK4YOGPd/6HtS5Hfgp5DRaoCI4uO1D7NGDRhuzo3lGT5UsWWZL8wbYpB+aTfu
	AaUCJGO3qop2SUdldB0yhY1Ns5m2OhQL4Ng451jrdAsvWg5el4PLl+zF2ukB097UDmUv/r
	5+wO284IBKEkj46EbACZTpO0iGnUNoc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 043DB45A20;
	Sun, 15 Nov 2026 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E401F000CC;
	Sun, 15 Nov 2026 20:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774545;
	bh=+3VuRAkKYe8EHkp2JgLASOtjfe+EnSMbvCKOCwj6jzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+G49136wwxaZ7daOM8i0MeEDwl7M6F8kfu4MtvhaBwW2lBnmR429BM3aSPFCp/+F
	 v/3BkyKllUAelxzCZO9uOMxmPEGyh7pCru+tcJOFHZk8az63JFQMhPuSlo9f44JI02
	 VJrIn6yxwzdffNiYQI72C66ZSneNYFdU1AFv9xYylKyaDSg38x0LCYrrjySS8x/b+N
	 MRyyECxGJyObWYhnQTm500G3u6AShzMRdZBTBIydLC7/Dex4gNTMYiQB7frNDiO5rf
	 TrB8NawOXjnRiQPbSw+vb0hQQO0xsCF8aIn8cdCjq1Ll57RovCIED31PUPbHDfbWZJ
	 vGqUJTZy9N/9Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/27] Docs/admin-guide/mm/damon/usage: update for report producer sysfs
Date: Sun, 15 Nov 2026 12:28:28 -0800
Message-ID: <20261115202849.99134-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A28711A000D
X-Stat-Signature: aedm9j4y9ikmsq4cjbxi1kpkhpg9n61i
X-Rspam-User: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774546-931337
X-HE-Meta: U2FsdGVkX1+rV0KZs1ULdkfaZCxz4g6kX7JEjtmo5E+9mq8YpLRzvQOiCRNDm/6rcUY8SijDaHkXxnGVseSFcB4bcr7jZuoYMiUYz598wzB70brN359tXFGXz1auXBsdeh8eQczI+ShZhPzSiQGKNUbeizd+cI46Oik3DZv3LsX/RfTV0RZrTmJA8JvaDnRiPgiK5/A7TqGgsJNKPsD8kxjEyV8bIWlSqUSwEUYxVmfxOIbaTAooPd+2vaKKF/WHlRxlT5gubrjRmxaI2n16qLMy90BGQ7XolF9aPrfGxcUr1dK1JpiqJX3ozR1p11zB8LKXdG1HmHcB7AKqtmIoGgB5tpIhi/G+Hur35E51gi+RhmE/DsQwdzqYWYu55RCIWHJ2J3dLhbxBq2R68daPj7IHJT+A7QfUchTCjoJzHMNvO9C0OlKvQkrH2oIp8By0ZQ3B8eeWgUexJNE817cJWXRRwA/8pwyiwJlmDJ6n1kvKnN2o+JW19wkF1OK3itldCicDprQxs08nv0nVnEH2gtWV8e44S+TgTtIjrLjLO90K2czHlp5WgwqL/w+rimZVeSNxfccjJYt7W2+Z/wtZXgMLjMYqUIS6YptCUSmWnzsKkoajO/JDO3kErLagfpsaXBT08h1QXZdCRSrBp3lXu1vNPL8N36XA4Tk+MhmSy7jFDPLN7DQeOIg7mllmV2HAfSpBDcaLyH9ks+q4s5rJmbR9HAahtGJ1FriFwJJeoB8VakDMHWanWvCi3fAtyMZ1doOhrBMqa39iQbraDd7ytbf9ZDHXpXwDTw6vJ4hU9OAi+YoSSmN7SUTle8Z4fToZweEnQMfNtqJ0YyY7+XqVm1Wq9pg1AXtISrVeOD2w4WiUc3496dTNIiSxymsAQGE7J53diVIxVplI1pVpMGgg1fSuOPozLLS45hFADT0uQ1Y1N8DnBHpqXWB4u4E0IfbUZN71NyToZMvHtZ9SgNd
 2Y5ERQ+D
 h7OLzLR3RVXyTPypysJdyO4lLysc3/uraEs9c8+sCXFXQlRU81ALGCiwHtLAUWb985wyOHMD3gc0YH4rL4DKhWb6n7oPHEtiWGl6TV6azDlZ1kD8V7FyFTu42j9VAJ1P2wLO1YgxnIAsF1GT8IlgNmBdgkDgh5GDDsV8izzSnZIaQz5hb5QeaUZprZiwpNSvjqUPk6a39qqapPfOtgo3OS6yMgrd9Aav/Q/omiSiiR/GRN5NWcKMof9tENeF8HSoqu07LnuJ1NbSvLKhparZiJZd8cMB5qTqUmoNF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added report producer control
sysfs files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 35 ++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 6093b1c8fbfd9..644250c7bd681 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -115,6 +115,10 @@ comma (",").
     │ │ │ │ │ │ ...
     │ │ │ │ ...
     │ │ ...
+    │ reports/
+    │ │ producers/nr_producers
+    │ │ │ 0/report_type,producer_state
+    │ │ │ ...
 
 .. _sysfs_root:
 
@@ -729,6 +733,37 @@ Please note that it's highly recommended to use user space tools like `damo
 <https://github.com/damonitor/damo>`_ rather than manually reading and writing
 the files as above.  Above is only for an example.
 
+.. _damon_usage_sysfs_reports_producers:
+
+reports/producers/
+------------------
+
+Under the `admin/` directory, ``reports/producers/`` directory exists.  This
+directory is for configuring :ref:`DAMON report producers
+<damon_design_attr_reporting>`.  The file below exists in the directory.
+
+``nr_producers`` file is for generating report producers setup files.  Writing
+an integer ``N`` to the file creates the number of directories named ``0`` to
+``N-1``.  Each number-named directory is for configuring each report producer
+and called "producer directory".
+
+reports/producers/<N>/
+----------------------
+
+Files below exist in each producer directory.
+
+``report_type`` file is for setting the type of the report to produce.  Users
+can set the type by writing the type name to the file.  Reading the file shows
+the last successfully written input.  Refer to the :ref:`design document
+<damon_design_attr_reporting>` for the list of supported report types.
+
+``producer_state`` file is for reading and updating the state.  Reading it
+shows ``on`` or ``off`` if the producer is enabled or disabled, respectively.
+Users can write below keywords for the producer to the file.
+
+- ``on``: Enable the producer.
+- ``off``: Disable the producer.
+
 .. _tracepoint:
 
 Tracepoints for Monitoring Results
-- 
2.47.3

