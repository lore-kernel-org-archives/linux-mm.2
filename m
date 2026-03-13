Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6B9106FD79
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C78B6B0005; Fri, 13 Mar 2026 00:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3756E6B0088; Fri, 13 Mar 2026 00:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281916B0089; Fri, 13 Mar 2026 00:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 160306B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:35:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 835E61B8977
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:35:50 +0000 (UTC)
X-FDA: 84539776860.03.31A03E7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 356D840003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:35:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HU2CeA3z;
	spf=pass (imf04.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773376548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KO24SViWbBFyUmZPm0oquBx38uo8Cx9eC3hA3EZRPlo=;
	b=Nb/3AdEXOx/GYImOIOluGzWvLikokUNJHlusqBAgIM0gydndYA9d1axNdoNL5BMVgsv4+S
	30p8O9cJyb2L9sSd1hWb1MIgBeN/fvMmKdord2W42cLitH6Wd3s/a3EEHrIyg3VD2cikMC
	cjG2AN/CcRmxsf4wigI3quW8lNk0Ds4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773376548; a=rsa-sha256;
	cv=none;
	b=dP/Evx2jMZoitlzOpaKKzo9hHTsCVhkhTFejVL6t2ZLlqw3LSvudmEDpTkzqHrk7LSJeZk
	g9Kr5XkyrlttP7CNy14ZKvX+VQe9as+3sSEmAkqyX/Ov8VzaFC0hdmaMWsEPCb0PAna7wh
	NefUF+LAuVJxuAnw+J8g3enLKRbjUno=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HU2CeA3z;
	spf=pass (imf04.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773376547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KO24SViWbBFyUmZPm0oquBx38uo8Cx9eC3hA3EZRPlo=;
	b=HU2CeA3znOLr2VyUAwbKg/QIxaZGTvmy/i2OqVR92b4xmoigIXjodjplJs73gl5Ms/xY0/
	Q3FqsKj5ElKlMRxrRgTb4fJa2jPy603t9Z2LhwsW5VOAMlvQhKOqbiZuIdZVQE/1Qv9vCH
	EaPtT3ldr4xC4k8PgWNHu2BPp7tGvt0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-bIao7Us7PF6lRlBFhAW2aQ-1; Fri,
 13 Mar 2026 00:35:45 -0400
X-MC-Unique: bIao7Us7PF6lRlBFhAW2aQ-1
X-Mimecast-MFC-AGG-ID: bIao7Us7PF6lRlBFhAW2aQ_1773376543
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13ED61800365;
	Fri, 13 Mar 2026 04:35:43 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1ED3119540C2;
	Fri, 13 Mar 2026 04:35:36 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: yosryahmed@google.com,
	nphamcs@gmail.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v3 1/7] selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Fri, 13 Mar 2026 12:35:26 +0800
Message-ID: <20260313043532.103987-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: qUxC9I_cYtA6cKTlnUbIbZdsfoA6RyustvxbjPfUpE0_1773376543
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r4e4xwcfj6t34wzhunpduixgodu3y6nh
X-Rspam-User: 
X-Rspamd-Queue-Id: 356D840003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773376548-930318
X-HE-Meta: U2FsdGVkX19REBYs9SHlx+9zOABWHMsyfCVKn3UmpLo9RmNtDF9dgyY83d9FZvjd8QBuPQkvWNmQnDfexbQstN6s3LHNtwwZE3kpdcT2AVltdfveJd9juo/XxwnX3MAcpDWomWLu5PZGvHbTptRFNTtoNfyWR3o1kGzUaL6pS6E9pWOkJt8YUyVqp8vSz2tfY2Rjrm9kjtbzzXktBYxemm6vca35ycPwjxRFo9KtZsrHE9akDr5taXY/BAWRE7krCCySuqzuV8+gzUut1pbuJhZOR2j9+3OPJ58DZQl/11I5u5P7JDxvV2q5Fb5x209vMLbZgYUOZ3iUu+CvoxDMf/QqQ66mqAxt3V6jcmbYHAfh+KqSDP8n011TtcAqcnR2j7Mdg+53L8ZTm+xXbPjyDBnpS8gOUvsaesEEdMhvNjd9+ft/j/AFw/p5W7tBrtLWLkFncE1zE+CK4vGnRrb+7XHD6oDV5u+LCvG8L7SBQ9eR4a8IzwEaxr87g7RAsiI4TGR73TFhSyo7Ra9txQjMP5lh2vasazchbrX/ssihALL8exVBUp22eHTeLFdE2EvLwnnWx4RxqgN6BbC1l0NRbkkS8SRi40o6UmpUsp/E2RDoJjeWFUeCmmtZ7ZjxU3CQGjyK+t1LhMKXyw5uizqMGDqJAnZej2q9l+FaiOaxDxPdC9BLdUIAUIwGDXINddgxzK8X/2ADonQ8709NgjbyscugTHgJ1/5yPdpl5lBJxItpk0Z4aMhtk1y/626S4UeiLHdti+NWxvKx2Qb9q8g2mv2iifMX/OjzWdNnoGgiGh6oezp3g08k5067WFLEJbgmKmQDxDdLGPiCZd6XnylxeK9tssKkniL/yNsXlX6Hhj/I1rkCb3Q2hVoCb9zlKSPC2BeqdVjUy61ljOQb1I7X6cFAKvOwKYxh1N6I0070ml1izQ4A87Bp8cIieWPSN9dypB5yobOWoiOpGZ906F7
 +5SAPvdo
 LsqszCz2DLrOHs9GZzhl8+mY8eBa5+KyZ/KztWIxvDBVhwCk/tgDDfQYnjnbCeiZkTHe3YLbf1ymMtQvIY7LE1fcM7j95OTSabJJkHkwWdajFzMsNgA3QywSjphiajH9i7xRBkXoQmZxBXa9g+epFIja23duJxlZRy1kGa6ioEiHnJr+qd8dyOXvoXJZwY8t+nHhNXF6ATgNcBg2veorEqw8DwMMPF3OcubuaIH99sAwTrBcsTR6BVfmD68CVolze4SKa1Ykgufck6hByV1YUWHv8AZ9pnYAV904ZI7WHCvcLLvtA89aL4r2Q7YS1cHJ5+QwWQ2DTOW9VaSxzT6mIXaYzNrlKMO7rMRZPSEj1Qe5bMrhKzPmaPwjwgkc7Sz/itPHQ31vypRb5a2RXAiTDrPzjyj+Q3liijvTMMT/5CR7Y8HHPoZY53QgxLFjjpydJVyQucUlG55qUn1HM3DfWyIPqsvIpPQAf5BB3yh93cqJDtU3FD2YCK5biGSrZ69Sm/dKUECZJlLKmiYRTeMbeVXuD5N6qTCVylUG4519o7x/v7L8KxV54DbyLWMpTO80I8svfNAZqwOiAEcaqoKRzQi2VLfNz9+t17LSl
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
---

Notes:
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


