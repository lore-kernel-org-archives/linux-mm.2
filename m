Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E0C1CA9ECF
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 22:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126216B0088; Sun, 11 Oct 2026 18:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D69B6B008A; Sun, 11 Oct 2026 18:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F096B008C; Sun, 11 Oct 2026 18:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9B996B0088
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 18:34:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 599354092C
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 22:34:20 +0000 (UTC)
X-FDA: 85311800280.09.295542E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CC9A540003
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 22:34:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KoMFCYlY;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791758058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9MrFerv6Jpm1jokOVRLuq0IMQxsqJAGOQf/Q+BYiBtc=;
	b=buR7qZ7aqZ4SQI2FTgqq3KW4eBXaAQ7XzKGc02fuk2oZ0K4JLVR5ORWkENINHwzrYyBq2+
	tkCB+WGA76JYhNXY2ZdhAfU3Ae5WYDADJFALwZBECWCA0a2crwJpb+QbGRfzQx1Lk8x3Eo
	M5klIBZBtUURyQE4kE37VuzDDHEBebw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791758058;
	b=z4LnIyQUsQ01JRDAkm7o7zUfVn7HqNF1x+VTTe5pF6t/2+WVTtnIWH50PzzFenMgf3akQJ
	OSXicJeinIH2VlpkTTYHkZErGAKAd3+ZFrAZj9uX/g5VSKKHy5JKehTgaq0rJYt9wnsTDr
	arCh6NIpHhrPdixGFtLLgJc4DBZiCaw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KoMFCYlY;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FC1044095;
	Sun, 11 Oct 2026 22:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80A21F0089C;
	Sun, 11 Oct 2026 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791758057;
	bh=9MrFerv6Jpm1jokOVRLuq0IMQxsqJAGOQf/Q+BYiBtc=;
	h=From:To:Cc:Subject:Date;
	b=KoMFCYlYq7yX0NexNVslRP2Q9jdRQkju78eMkJLUKn7l2uJ5FnFzwSwQ5Rxvj98A2
	 7CgYxhsprVNiSpMYq7XsFGHw5k1IJE4dh+EcGTtgjiNpj0l8UYSigqG+C697yBuKBz
	 SDmj19j8c04V8qee2RoSjF00Sv7rLm7TYD5AXf4ZU6bwxEN7Ek6MqTp3famAKyWkpZ
	 HmlqM9tqOH3IsMj1by1iPmWTqf+rDxa33ZYFWN74QIEgkziTfg8fSJF5L+QYL69moA
	 sQPyifw1RjeXmxkSO+L3sELLw32vPOWA1JD009MILJwn2Ne/8s4bk/wZ3rkKyeADeg
	 UWqRXTJdxRERg==
From: Sasha Levin <sashal@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"T.J. Mercier" <tjmercier@google.com>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: memcg: don't close an uninitialized fd
Date: Sun, 11 Oct 2026 18:33:37 -0400
Message-ID: <20261011223358.2327625-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC9A540003
X-Rspam-User: 
X-Stat-Signature: 371ae3khfbfu3b5sebocfanwjo17ums3
X-HE-Tag: 1791758058-880499
X-HE-Meta: U2FsdGVkX18H/+83xInoJu7PXLDJ3D3bQqtByzKC6dmm41UMiHXOLi9IUU2W/fZeWZ+UN3boia7HVquJ+AOSueFSGvl+1HZj7dOlBjZaOAFFqHWpMJmclB5PaJzSbzvXtZv85AQx3PDc7OqhLf0UOuRLocXZZdFtFxnmDiXDEXhKcKYKxAlrZxxIKS34le6Xf2UmmrovnZ77Owct2Matza3zv+UVcwdYpsbc5kwq6PS5rwrfXbowTtoKCEZXiaXAnUp3XF7pgE+kGjlY1rYyY1k5MSgcL3tKCD18vJJS67Z5x3ODhcZvPg6dgEpZ8W9u76bx9aH4IMBXqans9zxBl66wQlu6A+w6cLYsOvIoXP7lqLJ0+ZyDsQKXCMad42R2THyLQGQmbyFNZ/XljOewWP+o9+10GcQT31oWlHmFiRVFG9eZcJyp6Iu/7NVw4YjWM7HwVGssV2GwhVmVTVxFSp3+uUhAnodfH1gFBSpqWpc4734Ilb22e0xNXCv5K5JWFooVjt6rS+T/6bjfto10L29ktixq/evl9GerpsWUfHxcBlH/IL8GDL0oBacstkJ3jH7f+bsPINDGpgV6mn5pqdBbR5zR1gEgpnCW7l06gJaeyEuHgCwDeqaXUygRdX8z04DEe1J+dgKdeRgGmfu3aP+ee5zu2nwLmqDK6GtDf3UKoe1C/dL2wKWItQdLGQuujyu//cMNPeKZaDvm4eEprfoPXH86aKsJF9nlG/LI2KarnCoVdVMYX8z3pUJ7XK27cHAkqEbl3sWLguBhY7HJ4iI0ASofWxgiE1cIe0u6ByQK5W87nOWaDdn0AZf1M9OkRXZA/3rq6rN/E2EBMFTj7caQTWVcKjZ4m7Nsvzg8ZhgRzADOcwhy9lM3TTz+uLLN6fztvYqh01Yyh43nw3Ig/W+puEtt6ExXueLCGj4Tgl1dsueqtFzW30W4MmXpGXO4ZjD89pJaPzTVHKdRmL0
 JkKX7hyV
 N8+uncTu8SeK6JgOb/w4c9/dGpSaqVjvY4XJBa4cTLTrDBAaUYab0ZS6difQg0f/MGsAX4tdCqDdL2nQzgvhio7fqOuraD5EyW//sm3OUkL5hhaQG5QgGex2A5imWnGXg/FKG7JnOj2jhCsbReOleJ3kl0EMvo0dmXIqaq/b82+ytFK2xJ7Tw9YIZ17q6UExqftDHcJCnCf5zdmWgTlsE1Tq5Hg00n4K1/5RwqcT9nz13KHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
jump to cleanup before the inotify fd is created when cg_name() or
cg_create() fails, and cleanup then closes whatever fd holds:

  test_memcontrol.c:1685:6: warning: variable 'fd' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]

Initialize fd to -1.

Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and IN_IGNORED")
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044ed..047d487f6dd57 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1678,7 +1678,7 @@ static int test_memcg_inotify_delete_file(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *memcg = NULL;
-	int fd, wd;
+	int fd = -1, wd;
 
 	memcg = cg_name(root, "memcg_test_0");
 
@@ -1723,7 +1723,7 @@ static int test_memcg_inotify_delete_dir(const char *root)
 {
 	int ret = KSFT_FAIL;
 	char *memcg = NULL;
-	int fd, wd;
+	int fd = -1, wd;
 
 	memcg = cg_name(root, "memcg_test_0");
 
-- 
2.53.0


