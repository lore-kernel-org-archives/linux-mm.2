Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ED6FFEA800
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14DAF6B0088; Wed, 25 Mar 2026 23:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125986B0089; Wed, 25 Mar 2026 23:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062296B008C; Wed, 25 Mar 2026 23:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB24D6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:27:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89D398CC19
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:23 +0000 (UTC)
X-FDA: 84586778766.14.B00AD03
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2E8940009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K+wSfh5U;
	spf=pass (imf11.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rm08wFIpEzqugJakKtYzJk4JxE4UZWy40rHnN9fIsUk=;
	b=papit++YKH7MkBI5AgZFApNNSbizstlgvAxw8Hv36n14+zbhDRmyQsjri/zNV1Fma/JpIw
	52YmwWQgOqkoNp3RQ7LPEFnxhf2x1ruJCa+0R2x3gjifEoixo5RVkFoZgw5a1hvDvqooAn
	PwUqbcP5YBXhaimRQbioEKLVq0twX3o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=K+wSfh5U;
	spf=pass (imf11.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495641; a=rsa-sha256;
	cv=none;
	b=37YeG9Pr+cMR0dMxCtwXpp/QlLbIHp5VtFTs3Qg9Kcw2NVKNzSvx9gPAAxRmoTmmBTOqlk
	9cz7Nra/cwQHTy3PxR5GynfU+54fdbI2r2hPTngqUerP2i3sbdm2r2LezQYgsfIPzaTFdu
	yynFuO0L2CnJGP4QjHHs5Xm1D8NnZyk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rm08wFIpEzqugJakKtYzJk4JxE4UZWy40rHnN9fIsUk=;
	b=K+wSfh5UcBkyob1XEBRjprUuh1PYkfLkRYvI+1Q1PAniSo6YCpDGCgcI0ncwTj5Rxa4hBK
	PenKVeM7qpJQoU2U1K1FJfaz9gi3x4Yoy3WABiwxuSCZ776dok691oMCndD5UVomBm8Bdq
	isRQ56xjBl0/qwR2EUqa8VJ6fJKRoz4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-Uxu5qyjuPKa0dTexp-HmkA-1; Wed,
 25 Mar 2026 23:27:19 -0400
X-MC-Unique: Uxu5qyjuPKa0dTexp-HmkA-1
X-Mimecast-MFC-AGG-ID: Uxu5qyjuPKa0dTexp-HmkA_1774495637
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 708B71800365;
	Thu, 26 Mar 2026 03:27:17 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B45021955D84;
	Thu, 26 Mar 2026 03:27:10 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v5 1/8] selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Thu, 26 Mar 2026 11:26:51 +0800
Message-ID: <20260326032658.96819-2-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: NqfDcu8V81nQtBJDDMTZ54CheTV9GaZQqsphXcfdn-c_1774495637
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2E8940009
X-Stat-Signature: p3mcw5fmy473n4gf489hpiz3p9jbiiay
X-Rspam-User: 
X-HE-Tag: 1774495641-177861
X-HE-Meta: U2FsdGVkX1+R8gcKiscUztVW5UyEWwmOdTrlbLSg2lBmt7DY8hCQgsNz1GJx6a1VowRGoUjXtOvHGvjE8Y7jlXKirqJ3OXP9r62DsmWE8tCYGHxdaqlpiGu4qI5GIZ/5xKwVkToLIv2V7ixFHl2Mix0xgBH+On6LwrMnHS7iLxclF1axQVn+mQlSauCqLmclcLnpJRCiYvE8auc31Lh4dkfP7wrCgmdD0nK/BajsmnobdLoAo5pKKycoZDAnuhquHECAz5r0d/9+5768TUxed2WQpjTzfJs9pjgLDEWt10wQ90hesH3zS+yhze+5rjEva2LtBx5VXK91B5bHJd/SUuD8rtI0jKg4AQYGTyD007PqV4XqhyjETSgc0W+/ArlEU3ZxAtMsnyG4wk4iy1Lx0/K2IKQZGgrLdwmynpMIjGd2A4p96bdIFRHedRkGvZ7IPSHFv6ipGHkbVA8Lw2CCOBzzrxSvNsVO1UFEzGrKFANCai6Zbw5vhE2+oBc90znun7IdPUaW09swIebxciDN2b4pj4b5aU4qpOknTFDq7QU/lvZDWerHEaQnnx254FNiZ/XNm50HnqIvofqD4iEKD5D+S+DoKA2bUcxl/mObdIFFHy5Se2wWeZ1D/2GzLPCa4HyidUXZXps8s3p+rajdD4QPnKoGouZqWbnYGuteXkJwdJIAAPXdzpNUs/0I4d9KUE+PiHDjNVutSXD9ZVVaQq3M2Zht8CSzb93EHhoK4FCTaxHQ75gLXj874QGuKOJfwROsvr6G9PaW/T4svWa43lq4QA6yVaZGlLECwu4cM4r6TKzrDrRD6ZUV6OCDncoh9dTFS5sI0gSZsUiMyio5zhSI0ZaLJ1Z85WwejEoFWtsxNNVJUXXeF5fo4DXMFLIe9MM5XhwfRvy0ZaxqKWAceVSMp6aE01ShesB9fw9m3IDyKEDZ+Qz6c3TGgEKdZqcHRUpTIBoaJfQI1RVvr+d
 CwhTdH+k
 13FJKhyyFaT4SKlwnQ95pHR4ye/6dsE0/Awjfcy9kySQHcOF6FqEAhoKYLhEZePZetPaq22tMNdD/y/0ZEPB1USP3djnMjhArK7D58/FgcUkiMH2RTJkp7NexJStTSvGzmofqKuKYcKoIajmieX6psMscNUerH/VNmckUyfC1fYB7SaKuvHVATaV9GR21h6cqy7NBG2uMyTwWSTL7zyyUVH1tgQXZd+jR6TLtehBxs9wum/9lx0RwRP9DTIMtmmWv9LElS6qi4InQR9FgmiQpoxAIn5DabpTUHqFJo1kYCOBFAYFZix6fq1KvGaqFWZ7SET6418SjTChK5zsuCT0D/Zpd6xsq2CJLrxQubOEy/43cHUvdF/kD4dixILNSQPTkZh554BLd469ZvdQVjmBNIi6ENddAr06WdEpNwXAIaX3M5DhUx9bE/xVUfNfE/Kxld1DWUUSPXiTRqrPyM0jPyrbzVX3dt4CHCU/2GmHZgxnKKhBZM0A92/Mfnf63Fp1cvoIAuBaJOdLM59OwJ7zleIbc/x3su+scj/9+tqnNcifYpP2oLow7Z/MOp7wyG6BhpQjawOxfESN5wZnp+OccwtcplIhq+JQF3Z6X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_zswap currently only checks whether zswap is present by testing
/sys/module/zswap. This misses the runtime global state exposed in
/sys/module/zswap/parameters/enabled.

When zswap is built/loaded but globally disabled, the zswap cgroup
selftests run in an invalid environment and may fail spuriously.

Check the runtime enabled state before running the tests:
  - skip if zswap is not configured,
  - fail if the enabled knob cannot be read,
  - skip if zswap is globally disabled.

Also print a hint in the skip message on how to enable zswap.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---

Notes:
    v5:
         - Defined PATH_ZSWAP and PATH_ZSWAP_ENABLED macros to avoid line breaks
    v4:
         - No changes.
    
    v3:
         - Replace tri-state zswap_enabled() with check_zswap_enabled() for clearer flow.
         - Move skip/fail decisions into the helper instead of branching in main().
         - Make read failure reporting more explicit by naming
           `/sys/module/zswap/parameters/enabled`.
         - Keep skip hint for enabling zswap:
           `echo 1 > /sys/module/zswap/parameters/enabled`.
    
     v2:
         - remove enable/disable_zswap functions
         - skip the test if zswap is not enabled
         - reporting fail when zswap_enabled return -1

 tools/testing/selftests/cgroup/test_zswap.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 64ebc3f3f203..44fa81ef6157 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -13,6 +13,9 @@
 #include "kselftest.h"
 #include "cgroup_util.h"
 
+#define PATH_ZSWAP "/sys/module/zswap"
+#define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+
 static int read_int(const char *path, size_t *value)
 {
 	FILE *file;
@@ -589,9 +592,18 @@ struct zswap_test {
 };
 #undef T
 
-static bool zswap_configured(void)
+static void check_zswap_enabled(void)
 {
-	return access("/sys/module/zswap", F_OK) == 0;
+	char value[2];
+
+	if (access(PATH_ZSWAP, F_OK))
+		ksft_exit_skip("zswap isn't configured\n");
+
+	if (read_text(PATH_ZSWAP_ENABLED, value, sizeof(value)) <= 0)
+		ksft_exit_fail_msg("Failed to read " PATH_ZSWAP_ENABLED "\n");
+
+	if (value[0] == 'N')
+		ksft_exit_skip("zswap is disabled (hint: echo 1 > " PATH_ZSWAP_ENABLED ")\n");
 }
 
 int main(int argc, char **argv)
@@ -604,8 +616,7 @@ int main(int argc, char **argv)
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
-	if (!zswap_configured())
-		ksft_exit_skip("zswap isn't configured\n");
+	check_zswap_enabled();
 
 	/*
 	 * Check that memory controller is available:
-- 
2.53.0


