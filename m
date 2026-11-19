Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FB8606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Njcd2P5B
Received: by kanga.kvack.org (Postfix)
	id 8E10D6B05CD; Thu, 19 Nov 2026 08:40:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8920F6B05F4; Thu, 19 Nov 2026 08:40:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780456B0620; Thu, 19 Nov 2026 08:40:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52E136B05CD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:40:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C71AA40AB8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:40:08 +0000 (UTC)
X-FDA: 85451977296.17.6411605
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD89A1A0008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:40:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Njcd2P5B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ft8kw/T3FbU9csBAnLRF8fiHKqYVhsCsB1Odlhvpgkg=;
	b=YYWyGGJS8LddajjoLPu2JLaqB7TxUvAExyE/aALjRfy2X/2Sfa2L2Z9vufG5P+hcRuUS2Q
	XVKSdeXPm9VpIPcJs80UhwnPKyZiULojysIMjzaqeTcb9MFkJRo0vCF3j6f0fvRkFgwqvk
	pmMa1K5QQnlaCDT2ptl0kTu2xu26RbQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Njcd2P5B;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095607;
	b=HFL/c16sqzPT5ZQKMe3/eBdZoU3RwKvpgYdTFYDhgM/I1N4qpH+rYRdBWTqzoEJCPaQwCo
	i01o6VetWYhQAbHDb5kpQaV4eDJMVTKfUqB8epyOXpkDnkWawmQVfOSAT8tusgOBT8fw9E
	KsxmxN4j50bp4U92lVtB5NuzL5GMQYU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tHVuUYd90bw0WfS/2lQ6ia+1s1e4DZcUqw+F4Jzb1gY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795095605; v=1; x=1795700405;
 b=Njcd2P5Bw/eBDnw4WanDlOBsv+8NZyYVd9uuRGwuc4lFkHCMUbEdNFW3P3BzMyepmeKrA/8p
 f5VMMmlfea7ai+LpvpbHO/zN91pMyq88ySMpLfI5hhY/ADmuS+0ag1K5zVRdJcg3l7hMjZuU+5t
 SoeLBW5vQB0Y7GXKJ3kL6y6Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f5d7c9a57ee26dba;
	Thu, 19 Nov 2026 13:40:05 +0000
X-Mizu-Trace-ID: f5d7c9a57ee26dba
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: hmm: give migrate_remap_fault a longer timeout
Date: Thu, 19 Nov 2026 21:39:55 +0800
Message-ID: <20261119133955.54001-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DD89A1A0008
X-Stat-Signature: zug4xybhai1psbx6qfznpg5tx6c7xhpx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795095606-630002
X-HE-Meta: U2FsdGVkX1/D4trya788C+LzKFF5zgR4q1fGPd5zF6vNB05OeCP/I+883vB/VJyDEwIe1WyDmsXJNQfqPxPhMFbP40xDBy/WacOv473G+FrLZrJY8w7Tbo7WwOBC2QAEnFozXzz9NvK0DlBkNl7ELxFmJFC9ko06F5/ANfYpnxdx9BgeM6KPHBaRdin2VBXxebK026ZeZXJxX4dW0PIZULbW1i78V7SAHf9KpezTznG8dlQUcvtU6QE3c+T/bb5d5OOdnH7TGIvYCrdpOUtz3OPoNzhzyL6fr+hdzH+H3gduySEBhwzl/qieFl/vh4h/Iioeqc/yNoBUZvF6+cWwo60idPLvIFNjiTxe6CP3dlvbrKGIVm4ouOeuB6xaYgXgxdKGaN6oFYxcxmdO6OKSeFYkYbOh70LQQ9j3js0/nL0myqosm9AQeW5XsxatxMZTqvucZxyryulZS6gbgVBBJrbJ5kHTJQduTtu8fVcDdjfrhRFXool2/U+F/06SjoBoRAiZiwYO7i9UYJRPGotYKNnkdyk9PmpxB5G1vMQhn6Forrdey5GHNm+CYwHn2qkcYhBPbGL6PM7dK/rb89t9qM19g9MXXSY0uqnuJsM+0SXk6Xx2PrasH++Xqj3exVnvsJwX4QJ/izDnJZ9Mzy/WX7jvEN5endEcg4KL+YQ0im46y8MiitDYcPWgiK8dB+8Mx4CCJmA1Hj3ThUC3fPx2Kv67iEDUtQYe5rtrEQS5Lpf9/isb+HtcuMwwLTcaaobkQY4X0rzgGZjeScAWoXnzUp2qwVZM5nialpkp58abILChrg8LlPxNkUlfeJqny1XhwvGydICn6pv+B7YQX+bLcJr/c39NvgfyJLXZ8CNURHlD7J5laxijTlgBogjP2nOqCvtRvDIxHLr8bHI3dLcR4GcoBc/iLhzoyH/4apJ6Hs5lxSM1mVj4eIm4B1p/Al1DhgxpN9zCpuUGP/ekrhx
 fSyJjken
 4tsr4oiha+2QqbOuPdJRCeC7Ic/lPlzaHsIdwF+Sh2DTTfhGXY0wwoMhcweUpRVRKDm3SRabONqUOdvqk4MAQe5gNYxVpk306kboiJDxIMxkJhiT0CiaCP+Eo81pv/9ivlwXNni6DBxxUKx1UfvkcfOnRRTDDSpf1hwIQ79AEiPnRogVu8tK4p6zJKX9Fj/uIbWzQPrwQlkJbAuatL2Obgkh2G3bRduVGKEDt3qNOGpf5/h2gJBb2wkoVnZ32DPHSJwdK7Ma7lZLFgJJ7ThLG9hpTFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

migrate_remap_fault sizes its working set from the PMD page size and runs
24 combinations of migration/mremap parameters.  On arm64 with 64K base
pages the PMD size is 512MB, so the test churns through tens of gigabytes
of memory and takes ~32 seconds on my test machine.  This just exceeds the
kselftest harness's 30s default per-test timeout (TEST_TIMEOUT_DEFAULT),
and the test gets killed with "Test terminated by timeout" even though it
is making steady progress.

Raise the timeout to 120 seconds via TEST_F_TIMEOUT, so that the test can
run to completion on configurations with large PMD sizes.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/hmm-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e5f273ca84c1..840015cdd209 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2221,7 +2221,7 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 	}
 }
 
-TEST_F(hmm, migrate_remap_fault)
+TEST_F_TIMEOUT(hmm, migrate_remap_fault, 120)
 {
 	struct hmm_buffer *buffer;
 	unsigned long npages;
-- 
2.56.0


