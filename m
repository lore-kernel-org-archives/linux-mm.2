Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FBCF531DE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4179C6B008A; Tue, 14 Apr 2026 07:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDB16B0095; Tue, 14 Apr 2026 07:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219106B0092; Tue, 14 Apr 2026 07:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD2E6B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:06:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE7EBC1E43
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:06:00 +0000 (UTC)
X-FDA: 84656881680.19.3CEF633
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A0C5160008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:05:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bx0+lO4e;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776164759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Suxd8W/enAVPZbmnsORtZjfIS+87GmyYpLzs7e2B95M=;
	b=PRy1b12KLYyV0N+7iARbdCovsQLkojfzYXGmQ6RX7qVdPHVWko8mWIaU+GI1j4vZE7fUGC
	fLdiGB7mqJoFzKXTZ5efFyO+9leg2Ean3alvQX/YEdqOZDIn5ZgiK1uVVAoUJd1eGsDdgU
	rBuGNwfj238idfOyYgpMsHdsNZdsWHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776164759; a=rsa-sha256;
	cv=none;
	b=T1PkOD46BTh1dUdal/NCR7jGcgmYXEqWYU0yvNxd7+o/XStXzUigdpGS39s42o7taYyApB
	YlyrcFfm0PpNbg2Um7rrFvHYMKGd+k5mVdh4E08nUdpLZCwRyF7i+IX/Ij9G5tDFy02BRb
	ZR0+YuMfMB/orlLGjbXD2APzX31TO3s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=bx0+lO4e;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf08.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Su
	xd8W/enAVPZbmnsORtZjfIS+87GmyYpLzs7e2B95M=; b=bx0+lO4eyFbzp6awnD
	yhrErhvDNKDeg4ebQx5borCoIug08hdFF43r5RQCTk1rBo7Tsf1hTI++S5wdrVlu
	ReAoRSxR++C0WFI7msr8FC11BNR6E4IAJp0zjXDx+6xQ51MuByRUPQae1xt8Ilbl
	ErpqFYqbabtZ05BVHrSgoY/b0=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wBnrLh2H95pqLbvEg--.46126S3;
	Tue, 14 Apr 2026 19:05:30 +0800 (CST)
From: ranxiaokai627@163.com
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	kuba@kernel.org,
	hughd@google.com,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH 1/2] kselftests: cgroup: update kmem test tolerance for multi-memcg stock
Date: Tue, 14 Apr 2026 11:05:23 +0000
Message-ID: <20260414110524.2414-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414110524.2414-1-ranxiaokai627@163.com>
References: <20260414110524.2414-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnrLh2H95pqLbvEg--.46126S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFWxWry7Xw1UGw15urWxWFg_yoW8uF43pa
	s3AFyjywnagFsxAa1Yv3s2gFWfua97XF4UAw1Sqw1fCw13tw1IqF1akFW3Jr95AFZayr4f
	Z3Z3t3yrW3WjvaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziwiSJUUUUU=
X-Originating-IP: [2409:8a62:14:edb0:5054:ff:fe85:ffcf]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxRr3RGneH3p3ugAA3z
X-Rspamd-Queue-Id: 5A0C5160008
X-Stat-Signature: z39ksbpoxc5ip5ag8k7c1eb5aa8wmp7f
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776164757-517277
X-HE-Meta: U2FsdGVkX1+fv2AtSl63/UFyjaNeUPNxZ9jtksPKnJDCXNJfS2fSRZoWEMU6qcwnaJluUBViRW7b9smX8k0bMKL4FlErPMZNMBYbktrBRaYLlBY7+CMb6obizxTpZAnLE08QvzObBM0UjnynEBz5gLbvcPfAZ6ko7r0Q0MqyAOI1KZ+5k7HN1DbB50FCTuOzZZsrAsBe1dksEiNCfTZfww9aSZDCTlmxE13MC7imaHkFMS8n6UBM+FWeMf6m85BSaqrwS3yu75D+30O+2OPASAIBhiOMHVKtVsKBGX/b1sxqWJA/rQdB7CSueeyXiv/bWLcw6ZrUIeBCLHKeA0IXkC/G3lNqu0RrclnV2+39MtYtTmbhuvH4+eQpqGM5/+N5BN+e3WpyZHpYC2hfVQw6mKQXaud2H5HxTE3FIDcAUl0Q0vFploQeOZyz2gcKeWMk0EXEcgnkolwrOm6YfLzzLaFfvMNC50PWSk6da14CBQBlP+5wgTlbe7dPG6CY7pIezLKPb93vnCqe86cNarXyGCTCUf2PGLdNBIAKC1n0ylskjzPPT9utzMAWUOs9Zy9/mizGTZqKb75thtE7m1inT6Sm9EuyNfrGruMdic2DUuUhvz9ryuTCKKusEq8fbN5LzSxSPUeBFl+EGH3MJ6QTF9AEGaibq54oZmvfwNUVtwa0DcAgK7bpCXGpNjExv2T8B+nRZAZAXDYSeeh7aE4lFOwF8SNCre7IV0iZcXWGUNvrEbIMF+I3ZF1aDl7P2//4DPYltKzEoV52TcewLZwWQiB8pR8R+lbVMcmG1YsWdAkA1WqlkbmltQyxzj8r8//ljSRH3BbxvS0gvIcxrmDC0feVk5hq5HxkTDpXlGDZaUUAbAnB7NSUAdtpGssp5MiJxLsbj6SD9H/1saI7mFg/XjudcvGhagcWWcvmk807kEZ83qCnVMWF3kQtwX1XAcNG00OlIKHaKrpTiiz7vas
 YFeL3Bz8
 4y9CDfeDQAjNhYipkZ2Q7ySQsTIIBZ3XI7LtCVTXKgQR9CtYrKsu4BtgK/EDY0tVjfRC7xZ/aHy+vKz9d0JCa67hp3ONTqjsKikjIOys7r00DFXLG6uHUwDMUd5dNwKBG1YWkG937+8irFk4wwD4VTAlm/qlXOSn6LFch8AaEf4WK+1zRRRJrZ7Gxpu+F0i273dZpyweG7R7x3QsU3o/hSNlThAUR9XHV4DSPuC8F4RBWr7ihHvBvAOq8nswymUI3Nvs6nPfkbopuI8YXxsIXU38oG7Nn7agN1OgD6O+m7ryaCefbhn5bCi6WLmPG3v0lrIkxHcFJysQvNynz1Pl3OgzSGmC7SfFBcbGiyMge7JnTad5QLQmD2TMOJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Commit f735eebe55f8 ("memcg: multi-memcg percpu charge cache") changed
the percpu charge cache to support multiple memory cgroups
(NR_MEMCG_STOCK) instead of a single memcg per CPU.

Prior to the multi-memcg stock change, the tolerance was calculated as:
  PAGE_SIZE * MEMCG_CHARGE_BATCH * num_cpus

With NR_MEMCG_STOCK slots per CPU, the worst-case discrepancy is now:
  PAGE_SIZE * MEMCG_CHARGE_BATCH * NR_MEMCG_STOCK * num_cpus

Update the test tolerance to include the NR_MEMCG_STOCK factor to
prevent false positive test failures.

Fixes: f735eebe55f8 ("memcg: multi-memcg percpu charge cache")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 tools/testing/selftests/cgroup/test_kmem.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index eeabd34bf083..15b8bb424cb5 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -19,12 +19,19 @@
 
 
 /*
- * Memory cgroup charging is performed using percpu batches 64 pages
- * big (look at MEMCG_CHARGE_BATCH), whereas memory.stat is exact. So
- * the maximum discrepancy between charge and vmstat entries is number
- * of cpus multiplied by 64 pages.
+ * Memory cgroup charging is performed using per-CPU batches to reduce
+ * accounting overhead. Each cache slot can hold up to MEMCG_CHARGE_BATCH
+ * pages for a specific memcg. The per-CPU charge cache supports multiple
+ * memcgs simultaneously (NR_MEMCG_STOCK slots).
+ *
+ * While memory.stat reports exact usage, per-CPU charges are pending
+ * until flushed. Therefore, the maximum discrepancy between charge and
+ * vmstat entries is:
+ *
+ *   PAGE_SIZE * MEMCG_CHARGE_BATCH * NR_MEMCG_STOCK * num_cpus
  */
-#define MAX_VMSTAT_ERROR (4096 * 64 * get_nprocs())
+#define NR_MEMCG_STOCK 7
+#define MAX_VMSTAT_ERROR (4096 * 64 * NR_MEMCG_STOCK * get_nprocs())
 
 #define KMEM_DEAD_WAIT_RETRIES        80
 
-- 
2.25.1



