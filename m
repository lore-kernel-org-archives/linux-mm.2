Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A548DFCC9A4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54626B009F; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD8F6B0095; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6645D6B009B; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 309706B009B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E341958C02
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:43 +0000 (UTC)
X-FDA: 84528360966.28.528E1C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 489C0160004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H3rTn648;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrqFhSNeRFwqG6RCU3wUlZ8s21n/U63opKYa/dBCS7w=;
	b=HX/+WGMXxWUxS+2ss5Z9x7TUpNpVsd7i7qM6ijFrZ1rqojX4zjeCcivW4xZPjAkNxJ4gfG
	MJwNx+1PYt3wLFgoMBCMOzKRdW76medFS+q0ggw9lK0+756vswi6+w8wCgEIHrOLTjcFG7
	KzSwRmlPzY2dW+9r3+KTlBCPL2VUbKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104742; a=rsa-sha256;
	cv=none;
	b=TftPvj5kYOmX86X/+9soEuUsGJXRFkj39rXp8iNhtUbeJb2pTEsAN02r1qSnvupv5Ka16w
	CPRML7sMttfyxNO1FeT9AMJzeCrQO5GcQHb8QOBp9/MFRRJVyeVRQRVa+rDJV3yyXVxDM6
	6TLAAXqKgFjaimBs3wBUkni6vkpPDbU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H3rTn648;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B339741570;
	Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F6CC2BCB1;
	Tue, 10 Mar 2026 01:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104740;
	bh=X4gj60NUP5Gx9WKLfYMZxZSkKyfsCySS7inf5fgIm6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3rTn648M6dajZCpxKbTycwPJf6G272kVzHHeHbK/Y/CBXrojLvFwyEzlurwCstOg
	 aXpBz5UMcg0Uaw7XOW8Sbl4LHV8DM11G2a3bSoXvU5UBC7bjihk5Ms9kf+ONsrz8L8
	 7HbBRkP7Z84yYcD0yP53BTh0q3R+BfnDwJIhd50V9V10+0sL4HNsjChdKHTIU8sYE0
	 gzUzZboj9P/712G/ilDUCc/8KLis1Q/x1VYUko72qfVX8mKTMjOz4W2BGWwNUW0q8j
	 55CXtl5njcr5pn2P3jRrqB470qWXExSHWqwgBiOfzmUWDa0IYHgvYJcYZZ7K9wFK2y
	 +sLnW0JkmiV3A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/11] Docs/ABI/damon: update for goal_tuner
Date: Mon,  9 Mar 2026 18:05:23 -0700
Message-ID: <20260310010529.91162-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ysc4ifwq1374iwaimhsr6ndt8g7hmq3
X-Rspam-User: 
X-Rspamd-Queue-Id: 489C0160004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773104742-882266
X-HE-Meta: U2FsdGVkX18eaQuX83pnuFMQrMTqht+luYprl+xgYj5i7/+tvPj/l1RezDHKBnjgLng35FNqj612f+xkW6Bi1zDavPYwNKSSYJmaBYe60Exq66fFpZmhm2LAw4GZpifcHQwMckjhNByoin9/x1wD/+IoaJIZri4LQiE6RrpbFjJPOU5mA2T69NYeP+enCeMU3kBJhXsjWwaVzir46d8p+F/PHwDSOynxPV3/+Q3oIvHi/XnHACdOqx1OD0Pp3aDa6l6g1SOZ9HyavgxZzpdE0xVDtiCqymn5HA6eXBTygxNRd/N99JBZOXpSTVZy/M293DLvH7oVJKevQsWNS57WildH2xLRqx+nU5AYf+I0k5nM84BleZ+xWT8v/7JrVm1rKb3XkpMOjuh4MJnojTYc6ugWgqGqxsJ/pO0MRhVSgdp9KNMi/cvILZNHpWHxEZyT3tMYgqF3NbitK+iSVHdqt6fQZUcxLdOJms6zx5tEzIuhWvP99e5NojBnUVBADQDOcfsTsQ4vy+I7ctkmAOi4G6IZc4j1HKm0kP2hHWS23o9ajSZLlsaS7nG95MUwE0M+O2v6RS5tIPrrFYE3OsHm2Yw9Kd7EgKSG3Y8VcudAApHeQyGkgNW2fDbgJDFDLKTxke9RguFKcMXCbDCjKrzce7L7Rbx+f8NOyBTIz8zcWe7G5CVDYUDNuIJxaS4T7LTo6RSF665swxLvlbEzWQvmSNk4e1i5HLaZK44iIXAU9SUUgyTTQ8nutnUmGqHqMcVoQfctPMtZP3pZtz1hZDz+6SqrAf0Dx4o+HCHBmg7/Wja74IKMUL9Y2g2EkzqpKn6YcKAcdlbcQ9OyNk4OIv7znSgWtV9tCRa1KmWe/wKf5pxqB9Rmwne3aJFpy/gb90KKwdzhGpoBsANm4wV2t8Y42jX/GsWbpv1IEQdO9No67nLutbmy3JypfPXlALM3n/gtBQxz0+bwQ7+8Q953j5V
 dF38cUG/
 dWnja9rV8QtsGLgauZYJC+sSQDCM8TRDDUpouHxUxUcMp9ZDbxJGcBkOU7NuL4Hgx1eTgLysX1vzrf6YGi15Xpja0aawoVzg2w8RGiJ0943G2JlpcBGPHlomowOkGV2xpCdjCLyuChYPdo3FAik+m87L5c7iFHrVaaV4O7UaA+vuReDMz2AoRG1cEcoWJ2QMSsEWo8GFQOL1nuqdwmcb1S7Hd6mYBAe8SjCJsjihD9aZrP8BNQmN8mKQ3S8hCT2PpjSuOZc97xPUJGvQOdROuh1+aHYlHbFy6vH3HKuL3QIXY+tv2V8aVPVPthg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the ABI document for the newly added goal_tuner sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index f2af2ddedd323..2424237ebb105 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -316,6 +316,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the path
 		parameter of the goal.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goal_tuner
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		goal-based effective quota auto-tuning algorithm to use.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

