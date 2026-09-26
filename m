Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7FEC9831E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 05:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E456B0088; Sat, 26 Sep 2026 01:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF1B6B008A; Sat, 26 Sep 2026 01:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AEE76B008C; Sat, 26 Sep 2026 01:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B24B6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 01:42:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7075E120835
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:42:12 +0000 (UTC)
X-FDA: 85254817704.15.B01463D
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf03.hostedemail.com (Postfix) with ESMTP id 926CB20003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:42:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SaxZPMZY;
	spf=pass (imf03.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790401330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=poMR+QoD4H3NHZQTFS1CZaPTIlu9qbIcYvmcDeHr1ig=;
	b=WFHZsStOK4984ju6ct16F+3GqL3eQHwJKO/d9td0dVAv2ruIQ5e1k9E6rizjBsJ3uW17tP
	ysxz8Y5WFCv1LIU4PfmDlfDX4icqi0LaeHYvbqhO8CqxVTFiEnmnEoAWxHZ1RrW7KDrh67
	7mFJsWEk4z+/0MxxLTd4P7V7PUW9EZc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790401330;
	b=upLffU93PXlLuCqnOJn8rVcs/yP5pnT2XK8EdGfZXdFepgFRK9jdYADyN5HtFov+hckmmw
	3LmTu+gQDa6VnlRpAr+YlrC84MXlKJJnEm4GeihbEWhHQz0a+PB+e7eg6xWm5vMI+Tmp+6
	jfyW8Q2kvVOoscVsAaXzsUbfiEQWy70=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SaxZPMZY;
	spf=pass (imf03.hostedemail.com: domain of sebastianchlad@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=sebastianchlad@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887840c529so530302f8f.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790401329; x=1791006129; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=poMR+QoD4H3NHZQTFS1CZaPTIlu9qbIcYvmcDeHr1ig=;
        b=SaxZPMZYmDHFNvNhJYZlcr5JsedBamZZ3Lg+qdRYMWVjt3r96K1oLb4yT933F1Ti13
         aRxzjm5WROGgkdiKDKYKpK6XCBRiKFxPQSN/QXmINCIKI42SGcSGfF/9opuRJtfJxc/r
         i388H6fxbzzDbtKIV/sNiVSM6sD5SnQIIKTz1IiWxvDI2rz1owxgPW+eu3fsTI707UPg
         dr3tUf5FUpr9y1EihI+JC80Y7VmhBAXBp/5QSCJtIWoluSnqCW20GNIQxc6gthX5pXku
         RM3yED8Whc1qKO2tsjx8LrqTMWhMHKEVIyY6Ca+0kyh3QBOWQ+EOW/UlA34ZGgQtmB2c
         2pbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790401329; x=1791006129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=poMR+QoD4H3NHZQTFS1CZaPTIlu9qbIcYvmcDeHr1ig=;
        b=2B62m+ff+lc2WRKVheRv+nhVMFC8yEWVQ+2KV9wvMt1NLjrMyf+BZMrNncM72ZMUx4
         8uiFXIa2jz5upC8Xm5umFHaop6R8uvuCcmNz325P3xrKWuD59mHB0EUZSPxKvOP2tK7a
         TJjQCqNgk1poC20jrzpPAAYzOKv79paA6R1T2wxGJJ8bKTHb7RjfKi8B7+LrUZ+z44Qo
         Xhl1oukV0BVXpo9yq+6nWY6EO6i7Q4WjMAg17+x8xMDPsJwj9PZyqRVc4fzI8H4z+4Fh
         sZoul2VRT7KGo+O0oVRqjN+5vsucBlAH6hrcARJBgQzg8yGBnwjGEoEYaWvCk0Tqw5Kz
         +DTQ==
X-Forwarded-Encrypted: i=1; AKwUvByEL01C62muTMJJDWNwSN8g1TJr2upKxQccAogZAu9cK71T6HXB0zvzqhU3dmQDQhy5FZaWedvxow==@kvack.org
X-Gm-Message-State: AFuF++nvwgsI4HbZykcSGgXSgD8tH5zg+cv2qqojCseSRN3T1wSXdIkl
	wTNYeAjQEdDhLbzNmOffrt0fVXVQ18a3+3IJoyDRhWB0lG/hkAu6SoLJ
X-Gm-Gg: AYBFou10pTHDDAftgzXl0u1JXaKWTQEnhunYTJoC5r1AGxbwxZdFF7ZehwwvakOq7yM
	jG7b03VSNDIWIJ+n75IXUjA13AzryxWTZf/08jahefHmZvgw8PIa6v5RjzJJRc5a3BBildPzbg/
	zApx6pnudePBgcV24g5h6waKFehg08buwVryw7SzqdjbCEp1S6odU6u5YxlErzBHvwriswZlIuR
	gtInl4Di4uGiwKkWKFMNsDwga+mQd3go8uiDL8ESgE6w73RGnCDtyz3CoV5kQfnIq5QOSx7jJWh
	Agz8aUz/ll2nmyNgEIW+zOhj88jqHxPcKr/StwqQpThjB9XMKLKUdg+OSUorQDCAeLMJ0xZHnYn
	jrcfZeil3V0mHlKbdSjpeodPOx/Y7W10do86MqgrwRAoPQhDUW+yoreHvbinHw5vB3BYjhiepDP
	wGkM/MWxymSuuxF20jxbBHAOeT8AqodqYY3QalhOeZN2DTTY+qDuRowhNJyecYydiWpnGOX7FRw
	qvzcyX85FyxGNyyozbNsnXvK+2kyZpl6nIWwygK197I
X-Received: by 2002:a05:600c:6986:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-49fe66d05d7mr126116765e9.8.1790401328777;
        Fri, 25 Sep 2026 22:42:08 -0700 (PDT)
Received: from localhost.suse.org ([37.109.167.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ff065873csm104782365e9.2.2026.09.25.22.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 22:42:08 -0700 (PDT)
From: Sebastian Chlad <sebastianchlad@gmail.com>
X-Google-Original-From: Sebastian Chlad <sebastian.chlad@suse.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Sebastian Chlad <sebastian.chlad@suse.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: memcg: Don't hang in the inotify tests without IN_DELETE_SELF
Date: Sat, 26 Sep 2026 07:42:03 +0200
Message-ID: <20260926054205.28933-1-sebastian.chlad@suse.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 926CB20003
X-Stat-Signature: 3rj1iqsum9qhh9qh1rprj4rd9br5793k
X-HE-Tag: 1790401330-583594
X-HE-Meta: U2FsdGVkX18zYSvTl6n8fc4+XpSKMq8YoTEEVSaflVc89ypo3Q+jgIifZZZwv84Pvbp2N0RmDCaOCXcToRxrRHcpiTe0xj9Gj9anEuO4tjVKhK6ghFtVVDwZXg55S+0P+nyAawVeus/Nma87J6c4WilngAk9BObnSLSd/vq8mhvxOkn8LWTVzRxHJdJrxrulJBprBJr3rzBL3BDB9VBn6SbDLQ2fYgyJelJeBufHbx4hI7qGOg0Y4c9rCw7PRRVgzCcyXywoahs66uBJHHQirhqSsEEkTZzlyRGSqPkVs87xFgQ5iDHWD46przvq6d6J4IoRPNUlxmftmv5UqS4m4gH+g7LPUCjQekNAZwGonqdY4G5F1YRVg40kDZcC1M7sx2kBrpwvAsC7HvArT9+/vCrqDEkak40oR3OlapyRNzoreSrG7cKpf6VRZ8CF2P6fxtXowqUGiduesIwtDMW7dYBNb4+Fv7V1CkrGF2dVLzJE04Rf7sZZdWMZ3Lq6H4YFZbocYcIZ57fOuJdSabwCgTpsQ7cCEhCKCxRiasw9q+xDt4xPXL41iqR8DBzugVCWhaW3GRv9R5lo/HaOpNvodgHgtQd0HA6rvPxpKT6DRnrLVLmSSQfAslMZKseHQ3lLogE9MNJbf6Crz57wgAq0trj+PsXLr+Y5C/eq4rD583OGpREC+AheXkdFeR00wX0tm6c9wsqxycB89J3p4A00lPbDlvwDw6T4SZlIG3KKkKq66YN5qTJZbQ0Jeuyk1wfvmoZ4K+aJiVSXofgyY5mkmZ+7ZXzT/ufzGz3nnS0sSrFLrEspSAnSWZlu3a4u9Lp8xgvEPrZF46riP+lzIlVloXJMJ0KP3KhyGGFq0hudNyFmcsAQ3zQ7vJxw3Cz2WrXAs1yJhRuGmxO4vH4h1WDc2+BCySp0UwavYRkN1YIt/3RZOAt1BGwtrMO9wrNTgXlSJKmc8UbV6sct1tWPNT5
 JWOa3hX2
 pRH6EUkVqvmqHPSnzIS4cW0v8lA6YaQTjedD/rzHhBIo/qYxYr/b9ZSQjEWSTh+z1kKa+g5H5tdn/qJgGTrqgb3adM1wgQOTQ3uVMaSJ5Rz96fXEa5hKa03AffTm5FpseG84JN+TKlNJxR1t3WVtfX6/9XLZn7X4CxsRtsvdXkuXgHnaoTzfTc1WLbS36kWvJ6ocqFyS7oeXXj56i4I3ftnd86SVA5svQW/VHb+QrCa/oSLUDu2/6PwV1FaKlF+5RAKnl4cdzcOtOBtBo1iIbz0dbodd0vkyz8Psqy1axTn/x6WXdBn5IKSHMOfBq4H8dJfpq+oW7SWEP9Rbaa0xjRrqZef5EN7emPVYXLNTW3Ie1dPX9yCA7QK8owiO3+wB9qH9HRERTTcJZvL3PcC2lBzzGJZjPY65kzrTmsgAGWyfsBYtExOMCYUfGZ6SrguutnWeLJN60zIeeLqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
wait for IN_DELETE_SELF with a blocking read() on the inotify fd. On a
kernel that does not send IN_DELETE_SELF for kernfs files and
directories, the read() never returns and test_memcontrol hangs until
it is killed by the kselftest timeout. The remaining tests do not run
and no result is reported for the inotify tests.

Wait for the first event with poll() and a timeout. If IN_DELETE_SELF
does not arrive in time, report it and fail the test instead of
blocking, so that test_memcontrol completes and the remaining results
are reported.

Assisted-by: claude-opus-5-5
Signed-off-by: Sebastian Chlad <sebastian.chlad@suse.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 27 ++++++++++++++++---
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044e..c00420acc9a1 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -11,6 +11,7 @@
 #include <sys/types.h>
 #include <unistd.h>
 #include <sys/inotify.h>
+#include <poll.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <arpa/inet.h>
@@ -1655,10 +1656,20 @@ static int test_memcg_oom_group_score_events(const char *root)
 	return ret;
 }
 
+#define INOTIFY_TIMEOUT_MS 5000
+
 static int read_event(int inotify_fd, int expected_event, int expected_wd)
 {
+	struct pollfd pfd = { .fd = inotify_fd, .events = POLLIN };
 	struct inotify_event event;
 	ssize_t len = 0;
+	int ret;
+
+	ret = poll(&pfd, 1, INOTIFY_TIMEOUT_MS);
+	if (ret == 0)
+		return -ETIMEDOUT;
+	if (ret < 0)
+		return -1;
 
 	len = read(inotify_fd, &event, sizeof(event));
 	if (len < (ssize_t)sizeof(event))
@@ -1678,7 +1689,7 @@ static int test_memcg_inotify_delete_file(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *memcg = NULL;
-	int fd, wd;
+	int fd, wd, err;
 
 	memcg = cg_name(root, "memcg_test_0");
 
@@ -1701,7 +1712,11 @@ static int test_memcg_inotify_delete_file(const char *root)
 	free(memcg);
 	memcg = NULL;
 
-	if (read_event(fd, IN_DELETE_SELF, wd))
+	err = read_event(fd, IN_DELETE_SELF, wd);
+	if (err == -ETIMEDOUT)
+		fprintf(stderr, "no IN_DELETE_SELF event within %d ms\n",
+			INOTIFY_TIMEOUT_MS);
+	if (err)
 		goto cleanup;
 
 	if (read_event(fd, IN_IGNORED, wd))
@@ -1723,7 +1738,7 @@ static int test_memcg_inotify_delete_dir(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *memcg = NULL;
-	int fd, wd;
+	int fd, wd, err;
 
 	memcg = cg_name(root, "memcg_test_0");
 
@@ -1746,7 +1761,11 @@ static int test_memcg_inotify_delete_dir(const char *root)
 	free(memcg);
 	memcg = NULL;
 
-	if (read_event(fd, IN_DELETE_SELF, wd))
+	err = read_event(fd, IN_DELETE_SELF, wd);
+	if (err == -ETIMEDOUT)
+		fprintf(stderr, "no IN_DELETE_SELF event within %d ms\n",
+			INOTIFY_TIMEOUT_MS);
+	if (err)
 		goto cleanup;
 
 	if (read_event(fd, IN_IGNORED, wd))
-- 
2.51.0


