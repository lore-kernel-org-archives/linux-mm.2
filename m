Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC98ACA9EC7
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 22:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B121C6B008A; Sun, 11 Oct 2026 18:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1A76B0092; Sun, 11 Oct 2026 18:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ADA06B008A; Sun, 11 Oct 2026 18:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFF96B008A
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 18:34:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0AC4C072D
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 22:34:22 +0000 (UTC)
X-FDA: 85311800364.23.034D25D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 21FA520005
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 22:34:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfwRQ5EK;
	spf=pass (imf03.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791758061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f7AQDySFLtUgs27lY0yLdMRGLjRcMyst2lqiD9WLTvk=;
	b=HsdPGS4anZy2GfaMFYUwNbqLGAZy0Bmi2yEL3VjkpyMb2tSX5Chhc4RQ+A2wosy89gaVbB
	LVDVtSBMS5I20JOJoUfPz1wH0JwyOBqpkOFkWkvrBV0Xu6/BeVR+18q8ETksbDD0K+kepE
	d041qtJLO17LRyUnMKWyXM0YuTYHUrI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791758061;
	b=h9ZxBVA35F854JzYmxy1lgd2FATWRRCnJHSHK2Coe9Oif+ZzmJPG6rELo1DIe+eGaqTNng
	/nkndIBE/CELtohqlHQEgXkOqp9gWaQGBgcv0DrAvJy+RK9wlMxpFrJyaPg5XI5GMo9/9q
	nvUWI1O9awy4QG9lQ06hs26dNjJZak0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfwRQ5EK;
	spf=pass (imf03.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71BFD435EC;
	Sun, 11 Oct 2026 22:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74831F0089B;
	Sun, 11 Oct 2026 22:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791758060;
	bh=f7AQDySFLtUgs27lY0yLdMRGLjRcMyst2lqiD9WLTvk=;
	h=From:To:Cc:Subject:Date;
	b=bfwRQ5EKiy+BsKqVol4YNekR1lb8bmZRSyWcXRM+ykDAm8obV7Kkbtx0LWy0ZlxFp
	 +ACJ5dsaAMoKcwxX6fg9fuhep3GXxTxXJuqeVZ0wm1+xAf7FEv6HOtWtHfCim5aIsg
	 moDgm6EY17vwuRBOkCdE5It9NSVy5IKa7nf2WrjhtS6GmbjDXJEAxaUlaPx3Br3ZgE
	 6vd/6wbViCXA7WnSMbcnqmneBPOTtAgKY7nYcrg3NtKBWiVbM1syFAMthdHqMAfFrO
	 5FL9iW5G2+BeydrWsFNUNNqXqmvfuH/nAU6YjBdp9xkxYOgit8Q2sppNn6+n75kytX
	 a2RaoKbXNvfLg==
From: Sasha Levin <sashal@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Amir Goldstein <amir73il@gmail.com>,
	"T.J. Mercier" <tjmercier@google.com>
Cc: Sasha Levin <sashal@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] selftests/cgroup: free the paths returned by cg_control()
Date: Sun, 11 Oct 2026 18:33:38 -0400
Message-ID: <20261011223358.2327625-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21FA520005
X-Rspam-User: 
X-Stat-Signature: b7phu7jucbrgrfab9ixq715hht1inuhh
X-HE-Tag: 1791758060-534910
X-HE-Meta: U2FsdGVkX1/i8g7T0cM8G4sx2CK04ZdJIHm/p4w3d7TvAOvl/vMO4DnTe1+RUbICJj4QS1Htciux5N1tOgYWPNofWv2CbqdgSbBbgT5dzzlIgQlC2Qzze5hxxqmu8z29dIKWxGbF5Dk5fd24t7gfRkSGoJgpr1XzmikAthW8Utp29Fqi8hfPLBGySUlUosLq4GSIdQNBj7jhSFvZ2MUbJQqCIBwstbKg0yJeoHAJR8cGH8ILJNzIW2pDFYRlCIUuRAtxG26iXE70fYzYnfVK//vEJ/OQb3mk0mVDfMbgKqDuBnm6uqocwrXVT/Vw0f1qrbXGTzR/ksi2j3cYKKg4ARWxxfFSGNlmd0ox4rhtx7ExH49usDCYGDiBEcR2KVe7Fo3MiYjiaGPZ7ml9gYcoRvsjGTx/siH2aa/tmVAxHCV953X5p9yr3C7cYkl2Wuf78XTK52Vi/dyDTVls4+N7V+gPG8M6Kdmtbuv6mJZEoCvB4eVsc0NG2X75mczgcr8Z7l33xH+p7KCFTkNTWlK7NUweZsilXbDCbE1leQAj1sm8KKs6ZF6L0r6CkxSKqhSuB43AC1/n9455GXda9g6KqXBoxPN6iMx683VPQXXSaFNXUJCisD143aE1Snm7U8PPM4dbt9SmI/1JbXS68KjJY4UG7XOLNbeVm5t+Wl2CwpUKNKaJ/XiircoLkS+h8wQWPYiy6T3mK7gAL3o4Fs7707jOIY4GvKWL1bUSLg7xSXyCumdRQkMrduan0sSL+LJ5VfzKhjsQYYL6XKKV9MaCQ3GXoKHWUKvOO9LKNRhdPbU0MKFeNku2I+X22roWm7Mt71zpVwokM9otC0VWlMS6u5rx54OURExG1XC/hlnJBcmFeGoQPQKDyMIu7hyJrmiXWl7a+01KX70pxq3nSKcvhsjFMVTOgJKqIldJKL5c+9n5ddvOXHDB9b56yJYMz3U2Qg7a0HqQa2/fFWduLDj
 WpmoLw7z
 WBPdOSAbUFmgFuuHiKjY/QRM6ZENI8Cae0UCW4jR2hCAmoe4zScE3bxHddSNjMOw1xnUZ3fLDOPvhC3tDVJtSlycNG/Q30pS6gRTVfars+xAVX0UgAzN557Uu29XbHCtiKXW5nXIKC6St5YKJ5fpwP18h6IbcjBOIUZHM1EDNXXWlwqGgiLmYXjR1q/aYufVliLnlhuNr2AYN/6BDjqPKkRM9OKHhDy4/+J3YmZRLY+DR0jAxBkYeUzR1cKqTAkH04AgmaFkU0ipUe7VUdu7H3diE6nwKrS1PifpP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cg_control() returns a path allocated with malloc(). The two callers
that pass it straight to inotify_add_watch() never free it, and pass
NULL to it if the allocation fails.

Keep the path in a local variable, check it, and free it when done.

Fixes: 5313bfe425c8a ("kselftests: cgroup: add freezer controller self-tests")
Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and IN_IGNORED")
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/lib/cgroup_util.c | 13 ++++++++++---
 tools/testing/selftests/cgroup/test_memcontrol.c |  9 +++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testing/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd8645..ed99a235e76e1 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -626,18 +626,25 @@ int clone_into_cgroup_run_wait(const char *cgroup)
 
 static int __prepare_for_wait(const char *cgroup, const char *filename)
 {
-	int fd, ret = -1;
+	char *path;
+	int fd, ret;
+
+	path = cg_control(cgroup, filename);
+	if (!path)
+		return -1;
 
 	fd = inotify_init1(0);
 	if (fd == -1)
-		return fd;
+		goto out;
 
-	ret = inotify_add_watch(fd, cg_control(cgroup, filename), IN_MODIFY);
+	ret = inotify_add_watch(fd, path, IN_MODIFY);
 	if (ret == -1) {
 		close(fd);
 		fd = -1;
 	}
 
+out:
+	free(path);
 	return fd;
 }
 
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 047d487f6dd57..7bcf772bcea2d 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1677,7 +1677,7 @@ static int read_event(int inotify_fd, int expected_event, int expected_wd)
 static int test_memcg_inotify_delete_file(const char *root)
 {
 	int ret = KSFT_FAIL;
-	char *memcg = NULL;
+	char *memcg = NULL, *events = NULL;
 	int fd = -1, wd;
 
 	memcg = cg_name(root, "memcg_test_0");
@@ -1692,7 +1692,11 @@ static int test_memcg_inotify_delete_file(const char *root)
 	if (fd == -1)
 		goto cleanup;
 
-	wd = inotify_add_watch(fd, cg_control(memcg, "memory.events"), IN_DELETE_SELF);
+	events = cg_control(memcg, "memory.events");
+	if (!events)
+		goto cleanup;
+
+	wd = inotify_add_watch(fd, events, IN_DELETE_SELF);
 	if (wd == -1)
 		goto cleanup;
 
@@ -1714,6 +1718,7 @@ static int test_memcg_inotify_delete_file(const char *root)
 		close(fd);
 	if (memcg)
 		cg_destroy(memcg);
+	free(events);
 	free(memcg);
 
 	return ret;
-- 
2.53.0


