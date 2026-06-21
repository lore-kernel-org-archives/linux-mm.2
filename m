Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD4F7CD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E63D6B009F; Sun, 21 Jun 2026 11:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497036B00A0; Sun, 21 Jun 2026 11:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384E76B00A1; Sun, 21 Jun 2026 11:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5B26B009F
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 745E1A02E7
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:41 +0000 (UTC)
X-FDA: 84904375122.16.47A4C50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DFE2180007
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BmmKZVr/";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBlT7kxUiLnizW5xmXI1w/7C7n4H7InmdeB786HKy9s=;
	b=kEyPu1V/Dd28juAL0RmX3kouXtsN8v4uxjZgUGLpO8DTS8F2IarUKuUIDwtDp+zArw3NND
	tVcLbiKyEPqAp23ZbSHT0QRqgPceCrjwcnZHupPmrDLIUiAnRiQ4CZx753oS57+vQxiY5e
	Gjx8aNBe2daZnkcCPRHM/SvXvVwtQM8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BmmKZVr/";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057459;
	b=tXIKfS8qqAA3VgH3p3jq5dQNlOrXZC1lLgr+vdvoMyJS/gWeK5xMNRQh5c7ESwJUFxZuFb
	BUkq+vn5V0gDkbigVT8gB5j2d1VUvmpaBLskkFhCCh60WUK/RyJC36n9Yj827iYOrWVk4c
	b9E05aqQHL9nkkxAolj7cDxB5gya58o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9165960051
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FB41F00A3A;
	Sun, 21 Jun 2026 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057459;
	bh=XBlT7kxUiLnizW5xmXI1w/7C7n4H7InmdeB786HKy9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmmKZVr/AJUUiclVg4XsRJbSssuEq0AzdJ4cju6mfaSjL3kTPLac6pYFcTU4t9yqb
	 FEn6NGlDwOXcsjgpRcZcbzdlCiekDwXnnaTc6GeP9NnTMwQbgcu1JCVS3UoIEBbDoC
	 QVMTznDjaBX8N0xXoV1lgv0n9Hp+LPU7VyMNJt/WHGN/g6CKbuY49XP4f776Xpth/9
	 AqLxmU8YIuhanr9tDeMGpvpy4JTus3vQOG5Ee+aAnwI6L9vCE7O10rox0C4acTWNpx
	 8EusLQaR2HBLLmXljwWS/JRXUjeTxpSEJBYGUu1VliZoyhh604dGbdUUC9+S7h6vxK
	 yiertDqaOzDUA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 11/17] selftests/damon/drgn_dump_damon_status: do not dump nr_accesses_bp
Date: Sun, 21 Jun 2026 08:57:07 -0700
Message-ID: <20260621155715.87932-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFE2180007
X-Rspam-User: 
X-Stat-Signature: ddpzryquo8s7dte8n8e5xni316n76zpp
X-HE-Tag: 1782057459-95995
X-HE-Meta: U2FsdGVkX19y4nEnAc3hFqNnfii8ljzuiHD4wThzCvc65Ij6zdDOAtax8h0RCfRidZyWNrvIBEjdQKnHoeC/nQyUlRv4SLbHYvvNfpzZeWq8IlazXv2rJZ9qTrjMzNsJfQUllkxFLV3y2mOzL6gTy4KWzrAGwxBu0HAeCmGBSGruISJF/cz/TxbWfAm5+1FFgYrAvQ4abvqKqfdjRZe/JSEs+FGH/l1jRrIVUsDZ9ACTjv4mG9i2l8sJfNSDGAOBL1sd5KEKNgkfGZuTTtw6lVmHyml0dRr8jnnOyJcE+zFUSdZpDFzaR17cWtqCtdjctIQ3gfs1Sl6Q5DO+0O7DAWUXaabtU0zUUJ5/qn84rMrQYrrONKJIPa+zRuq8boG/tYmFuYzTCObVjDQnA742ES3O6+/C622PD2y/5Qj5V+oHLl/PEp5JbczpLR07etn7Chw9kyJS4bafpPksIXBgVxXHKazGNo8dklL5AQem5VBDo5SXSN9JUWrA1cc9PDBCpqAhppj4amDOnp6EXn8P6aBsy2ZKgYRLf4XXyFeMGTWeKW6iolB+kZjriOKoETAmhx1YDy7uOZ8Rp+0N80NReCGYCgGNVQJrAx/ikcRMAcARVqvzqDYV49gkKJpkrnLX9Cid6GIUCaQiXRLH7kDQQT9XZCIlMYiSCKFoHpJ/Xry200gwJYPPwQdgjt4WUWKkbfiwahKLPDgS00J56Q2GdOFfhgEIG2P8yZFgvoa8PNabdzOJBP8Zxkb4UC2rIcLKbx1BrIGwRgj7GiJCD6CSRegifamytBqjy0h5d0Cpz6kiwNsYh5ZKx62urYIBz3FtpHtThu58ABDI0MFuGKz6A3wy8dt72X7O9xMKt9pkzEi1tDNNZ21BGG5g5EHgEOOFGCvKuYhNwiN1h9NKVapN1ipZw/QY7zqCnOTm25vUxRi9/ATCbh/n72Iy1xGtJITaUB1WxpeLsPOcW9hpLBb
 Cpd0cMTQ
 /kJ4KWo7xSNcP7zqK2HkI4MtApM2L2SyR7v/qJGBTwiXRAYuBAviZz1RkN3f1xu/JXprVylzCB5PTkqt/pqIfGkPboD892UOaJjxTpkmapnsMFx1P1Vt0Rv9kLtccLIT0vb4dyQWpw/qDzbZPtWbIsAFnDokXjN2ou0dNoQxWULFVEyncRzPeoqMe82n10GufFZ1VlMaknTExwsjBxnryW8mupqkVs4U8LVabgo4+3R+b4NwW1q76t7jFr/b6ge7UfZs2LbAO+rgrI5wp6L47rBzFViY6ezFqr75lfgBNkhgw5zmSmgBODlpj/DbiiQqJvQ1wySLsYplzKMVqE1ydCZDB9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drgn_dump_damon_status is dumping nr_accesses_bp field for future use
case.  nr_accesses_bp is not being used for a real purpose, though.
Hence there will be no future test for it.  Do not dump it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/drgn_dump_damon_status.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 26b207e44268d..09552e91bc782 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -59,7 +59,6 @@ def region_to_dict(region):
         ['ar', addr_range_to_dict],
         ['sampling_addr', int],
         ['nr_accesses', int],
-        ['nr_accesses_bp', int],
         ['age', int],
         ])
 
-- 
2.47.3

