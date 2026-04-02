Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A1B7CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46326B008A; Thu,  2 Apr 2026 02:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5C46B008C; Thu,  2 Apr 2026 02:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4C26B0092; Thu,  2 Apr 2026 02:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8FBE6B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:37:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5603A1604A7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:37:45 +0000 (UTC)
X-FDA: 84612660090.12.C27F62F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7EDA210000C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:37:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UsnOcBPx;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111863; a=rsa-sha256;
	cv=none;
	b=GBCdX2mlOy43bJdZE/xf2XryKGKbexO6l7JWzjA12ezEJdV8HrfYFheeIUFWaIIGm6Vnf7
	vf1vaYvauVIaVgVIxgtKLb9w8Pw7VhoDopBwCsKnxOoBJBxg4cHgxJvDxWfnC8gTtOgVOf
	EaWzKxyU6LI1pNrdjxdHqoBFulACpEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dW2A0MrwEuJvXNSWOJou7ZrIoh0fBOElxwXftetMLVw=;
	b=x69SJtcbbzMBi4K6kA5K0GNeJl4Y/I5WAo8r8WBKDdObsND725wadm3R7avLYhTSzO+leP
	ck/vBaf2siWAx4BZRX9KblZdSPg/TwDgD8QVt9dBlHX3t/e7lCCFtZp1PxI9fmMBQuzsnQ
	hKozzBwTi/RDSy+LexgUx2JhuA5V69w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UsnOcBPx;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dW2A0MrwEuJvXNSWOJou7ZrIoh0fBOElxwXftetMLVw=;
	b=UsnOcBPxGhGPPz/FsfVWtJZhBW0vsRQoR5gfb5iK1L2soTnC7VOUaXemUPwKZnZz4YEw5C
	5kYZ1cnLX5EzY14zRjvXMumh9PNPNbWbcvczsdFAxTUJlLLk2nYYQDiCCMjzhmBzoQk4GB
	su1LxbtQaqZQIIoLXPtwmS2KqHkw3+s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-607-Pb50ZLBTOwqFvnA_DynilQ-1; Thu,
 02 Apr 2026 02:37:39 -0400
X-MC-Unique: Pb50ZLBTOwqFvnA_DynilQ-1
X-Mimecast-MFC-AGG-ID: Pb50ZLBTOwqFvnA_DynilQ_1775111856
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3A36319560A7;
	Thu,  2 Apr 2026 06:37:36 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0E091800351;
	Thu,  2 Apr 2026 06:37:26 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v6 1/8] selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Thu,  2 Apr 2026 14:37:07 +0800
Message-ID: <20260402063714.55124-2-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-1-liwang@redhat.com>
References: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: kRIneCg8ycGZQTG7MNV1NisS4ijTQ8-ggnK684RXpbA_1775111856
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7EDA210000C
X-Stat-Signature: efkbf7tm3uzf799b8r717pptkuhpqg93
X-HE-Tag: 1775111863-792784
X-HE-Meta: U2FsdGVkX1/8isQgDUmtkw9I8XJQSX59msTySHpyN+1zKDgS46LcjNiA2H4/y1ALJztYfi+HkTE5xMFtYIyO5euREjmtyEi8Px0WFqIn4Xp9udeOIPhlLIBPIh5C8iHQbYELEO/x/t4xOUuCS/fnH8YnIa7KoHcPu579gQ+GshbrY4iT64vjaBmWxMjtolI8WOT6+Hi3gobvPSRfHly7A92Oe5Cejpdb87O7LYtYSAjMlhGCZIdwkv44ctXXiCLCx3JlGhfc/Nn7Vpp+4IRs+OF7LOMeG6KWarfFt71SQzacr4qbZDEL6Rq+Oo9J6ctUlDvMxwYxYZuoeOZeZchl5IgkFkx2P7kC0avAeUdPszuwzsKGEBWgw2LkQykSh+ZX7EG5PcIJA5ZfObTHdNHp0s61rfBa2ErDcQhh7LjEybWBAkowbSPm24EDvBOeg6vR2AAQxJ2k6edPJxqDnDk1sNmbiZDanXNZIwjmYr8L/g994zKQI/lHDUWnMoG35WWhPriLp5nFhhx9eahMjRnaEBnfQKOqr8c4SfHXJ5pODxllUPEJY5OgKa/iSciXrb9V5Ti9H1t52C1hxk2oO7vBaar7WNbYE4l5OLqL60uRl6X3k1RLnpZVpQBLtNOcrBKhfZrqnGQITe7jQO1dujhmtQX6RHkmxgTGBX0BD7MbVS8Vn/zrdM9jHziTRDtmN6RcaHlm7xS4UKajeiMYPUmQpieHf/sxiGohUOKfYSSxMkW0LMwUtU3efQHJrND+jJkdI8Uu0+NgTaAyTV1N0nz3WSEwW2UrGcbS/LVa1SKVccee5ttEF6JzHFG1N1GlZFBmJND7451jzi8gfwiIwS8r3Ss97lCHz6No7yygSCLBHdl8CHGFCYG21DtXO3fLkTwq9nrqjuzAOhHRdyvqeRzRHN+lr4ZrIDRsPYeatEHYBbgmGuXsAEg4Qo5oFDug4z0id49cJD382T/WYlsqpAo
 0AbhgDUc
 tu6mF2mGHgsJW2fiq6XGV/KiWGYga7hyxbHF6VNJjwsM0Q2E6ZcrjnccoVFzLCjXRQc2FL23BioLdsFafUCa4xor2bmffpFuLrkK/+jnw3k5g2Xk+ebj1H4+NLWYSHFKG+g5WyCjlzj1ZMa6cSadvl3C2Ua52rgxp7O+iiuvhpioNkNoBFsJx3d48tO0XQvmjwHmjrzTAh3Z2+gPdK5JNj6mDpGGGXBWrpqOyA96wStXzCPmvBbaEczUjKh1keiwmHYKWvK23T2DTZPH0KzkMnKAh8ZACfHI3Eq3qGU8EMjDWjW9jFXJsLqEz0QYZEh6RyWCT7t+BsIbuB18z8DqpSjJJIbmaZaviGOvRWqYBmuaGUxTpl/z2piI12EWrCHMqQZ+tp6FN5qcELvqzkKVDm/wXKrBLxZYSujjbqwWlOy7NxRjltgsPbDRvOnoeBL0GrKKApoh6zq24KIR5C7JxVV3DmplzKq35k3hjofWeRooT6KrDA3d8pAtu32ZxzMom4GUpQH+sHjdaklW7a2y8B0aHPCpyjgRpeTabYPkgcuBlbgswQ9eCwwzHQ1lgbACgzJFj/t4YRRvAa+UFv9K9PFnALHtlx9FejWQx
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
Acked-by: Nhat Pham <nphamcs@gmail.com>
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


