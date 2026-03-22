Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57E5EFC72AC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 06:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD26F6B009B; Sun, 22 Mar 2026 02:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA166B009E; Sun, 22 Mar 2026 02:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7206B009F; Sun, 22 Mar 2026 02:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A04836B009B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:11:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CD608C3EA
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:08 +0000 (UTC)
X-FDA: 84572676216.23.5DF0AB4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4923014000A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A4ZHk6z6;
	spf=pass (imf23.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774159866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNGT0NUnZrlZkAGbpAJMOumDHRLMeHSt0H7KNvOLnUM=;
	b=JIS2nW9w3DWFIHQi+CWRsoRDw9Ix2b6QqHEJfHmFC6oPz2fmNveyrGaEWemfsG1X1MFJTG
	nVVoHL4t5zqGEy5U5QIfzdvwGpGYHcR/tl/0SUe8OaWdrlBC4sgsMCmkrNiv9IR+KrXYGs
	5XbDy+Oe58i8e/hm5u/B8rx7Vn436JE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A4ZHk6z6;
	spf=pass (imf23.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774159866; a=rsa-sha256;
	cv=none;
	b=qf7OGE0/hS/7hTX96zWLW9dyZjb/K5rj59HF7Fut5ioYIB1Pk3amnPM6APBlsjaXKRPDH8
	tN6zPdghi6gkkzELPmhHYjQRtJOI1h0Al2mPb8Sq0MGh/Ei50n6ZIRY4XN65vOh+P6o59Y
	wtCPLKxc7kOgZHxKbdJyKzavs2p0NVY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774159865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vNGT0NUnZrlZkAGbpAJMOumDHRLMeHSt0H7KNvOLnUM=;
	b=A4ZHk6z6Lm09w8sFDMZoPBGoNvpmw81UZBCehPh1QkLFTzWdQ2Y059K2uxjs0z88IR3akV
	wokxhskV4v/IwQqQgWDBdvsdO2OhDQJycb9PmuoB1hE57oskrIg8BLDxdqKxylyoKCCaIr
	SJXh+PzGC524GrTUrOZYxdiJEN93ew0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-FE9ADUPzNtOwM6-JUgdTbg-1; Sun,
 22 Mar 2026 02:11:01 -0400
X-MC-Unique: FE9ADUPzNtOwM6-JUgdTbg-1
X-Mimecast-MFC-AGG-ID: FE9ADUPzNtOwM6-JUgdTbg_1774159859
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BAD61800365;
	Sun, 22 Mar 2026 06:10:58 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 223171955F2E;
	Sun, 22 Mar 2026 06:10:50 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	yosryahmed@google.com,
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
	linux-mm@kvack.org
Subject: [PATCH v4 1/7] selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Sun, 22 Mar 2026 14:10:32 +0800
Message-ID: <20260322061038.156146-2-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-1-liwang@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 7CypDRZMKxbU8AcI7NmHHoTERm8aVdOaXiCL1jHe0D4_1774159859
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4923014000A
X-Stat-Signature: wjhwontc6o81qow5jj1xjtu5ksasrre9
X-Rspam-User: 
X-HE-Tag: 1774159866-485047
X-HE-Meta: U2FsdGVkX1+D9wK6I5u6yqLI7mV+k0MqSuqhiJvc6VYULUmONInUdpvKn2itLr1Zc9g7KxmxRA0R/CmmiybkpMtoL5rdOq5X926/Wjq1OAB472RluWGxa7VlosDbv3BQi1soJdzTWV7qAw4rBCTZELgCtxuhGy0aOo+g/Kt2M9zZ+GqTQFJdb0+Rs0E0CG6x3p7PZDfipE5b6Jqn53BjPLs1Hqd+Y3EZgjnEGHH0kFan2+COeaT9z4UYkXQnF8fUOUWnkBTfVSg6f3g0SkRz1c7qJMqMNRi+/tW4w7jfqDFQgXbJB4IrTI1bIahCalD7EaTBHJOujy95Lh8E+8irQsUjX81qmLBiVPNFt9hKO+fi2GBVx2QrlTLMGwCDmtW0izZHDQEjlLYjBJmJX6CKA0PcTYi2Cc9LLQSdtinRb+UONewHWkW2NtGvhERPdjPyDPbNRD0CGujcClYP1ERhluN+qkYNoE3c222QttejC/eszzFWF+VvwK6D69W+9woE1865sdKbAQiY70auOTL58LSo49xawe/GEcV1YTESNaPH4hhLf4ZrId/UevJgr3Fq9l700n86QkCQMhaDXYVWYc1ZkcTQpOuuoByd8vv3A1Or5RD2sNS5WCU1/oYRR7oq99neadHRiTzvurpEiu79SNfJSYGlUh7iPQXnNTeHQnoayTiCj7WKUu+LD7wVCMPuZ3XnGIEgnPJ7PUqSGYAxAKj6U4hXiE8EU4D6iq56NPUVnLDg61NDwTT8Qd11VeuW01s9MvEI3uxotrS53xkfqV8+YlMMHI/LVj11TI0E9id0PqtyZFPqFv0ArzLczyrXZpVRb/UdoMuarENi8KDZXx12pjSfBDOgrsGXKugsGD4lO3gb3cMZlL/VhTk9tfuuKDwJ5+fIUWPbmH9Scrb9jh0LFx3UpunXh86DQi+l8HNCnJ0HDYW3KYtJjzQ4paHMrRd4qghA7fV5wEapnLv
 AAfS5yJu
 9UcqtXCAazFwe9/L/CBMF8+xjZzQyWRFtK84PtBLfH4qFaiESzBWEYvCVZ3mgADfI2UxDHQLM4ov4UPk5vRAuhPPU13iXOI3LF9FQRYuOla7huTTUIVmnaHwO3fsPPDIMZjlNz37RiXjDKXcGpi6rerhpYoBXKqfEpGEM70lZ6sfJ9+WULt9+Mu31j+ZDzaGmPe4zHUe1LuimL6nwZh6AQo2sJ/wCKpq9EULtHX7/8UrwaBKG3wGx7IJyXSeyLog9TjEls5fTO4GtE/DeN6ltvJARpuLDwuQN0tWqQ0XhLY44tAp3xnDOo5qqNX3K6psq+MUTn4svlZ2jfmE6rUsax5GepA3Rhka0p68iH+dnsnT0Yb2Ff87uTz3NEiSHyf6kWitN3ryx584VWhZg+QkUOALEHkz2ASk7Y3f7qHDwF4JUEAzJ+cUowU8f0fE+T8KQ7ZTyzBYEGUdTHzWvhZ2QbqZCxJpgXDu3GtTilseGNtMQIwKnO6nESlwA/YAn5F363XmtC7soX7IASsg++NdUSFF7lJv09iIKIiTVY9sxhu7uR5adLDXYe9VkrwalRubYuVWYNMmesL3DpOokD0aTPAZfN/HAhf1E3KYi
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
index 64ebc3f3f203..e69d845d3592 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -589,9 +589,21 @@ struct zswap_test {
 };
 #undef T
 
-static bool zswap_configured(void)
+static void check_zswap_enabled(void)
 {
-	return access("/sys/module/zswap", F_OK) == 0;
+	char value[2];
+
+	if (access("/sys/module/zswap", F_OK))
+		ksft_exit_skip("zswap isn't configured\n");
+
+	if (read_text("/sys/module/zswap/parameters/enabled", value,
+						sizeof(value)) <= 0)
+		ksft_exit_fail_msg("Failed to read "
+				"/sys/module/zswap/parameters/enabled\n");
+
+	if (value[0] == 'N')
+		ksft_exit_skip("zswap is disabled (hint: echo 1 > "
+				"/sys/module/zswap/parameters/enabled)\n");
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


