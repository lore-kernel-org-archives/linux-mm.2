Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F522FC72A9
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4250A6B008C; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338EC6B008A; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3686B0098; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFC5D6B0099
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAC0C1A051E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:41 +0000 (UTC)
X-FDA: 84574154322.18.64764A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34B4E1C0003
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4ip5v5f;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbxQY3lvzqhT/iqaqHhhtJ4GZyPdebweaPj+BWQtC58=;
	b=AO6RM7/wHjQcRGYBe0bFU9lkTtC1VWSKTxkG9mx9zENwLGGUn+G6rBntNoEj5uwOY4Uo+s
	QfcPcAyxwVk2nZdXcjCbDMXKRKawUTg7ooXIeCMVkfSyvbZKm8Kkub9QoEILy9feYUWEVV
	HQqDiYK2izPKMEi3TG/btlrl2UzZhRs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n4ip5v5f;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195060; a=rsa-sha256;
	cv=none;
	b=GHF+8k8FxqkOL3rSUJAjaSBwEv84WLwrgeZ4QfRVqxHDbDTA13uc/dldOsbrgmOo/Amo5W
	cw9L7zt2uAntrrLE+CJGsH8iPaZjZAIAvze7KDfnIVvMzzgYTkesKZhHg/pVE+0seBkSf5
	oW3GMadq/sCB4F4HwCPw2mDEmR8+PbU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6ED86015B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C845C4AF0B;
	Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195059;
	bh=acrZio7SwTIWWe0wc5YY1SpE9hMTqgCgT01pPcG9A6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n4ip5v5fJA3sWZJH3LAiEQvd95/Sr8atcd0zE1wUrvqBIJvlfFkZHFMPUjwJR8mWo
	 MnhDjMZ9158HqxUssR3dY5SQKl/BOizkDhD/nbtsrspS4dEn1LRunxghRws/GSz3Ua
	 vuz2bp/j70lLwEfBLsXPv9v7nh0h+1LQAhzPfOa+QxwdbiLYvXCCdKrHJOa0rIsIT2
	 PMc/7ntfk5vmZhgs+2ILmvSuHp3Q/TDDv4bxLIrj58LYA5wbdRJdR+6MtZyZOTF0Xt
	 +6BJwjtUv1dMCgzP02NcBIfiIzhvo4RC6gAU9OX9RdVNnAiANJ4VtPEeG5UzJFb9Yk
	 t/i+u6ZZcI0hw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 05/10] Docs/ABI/damon: update for pause sysfs file
Date: Sun, 22 Mar 2026 08:57:19 -0700
Message-ID: <20260322155728.81434-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34B4E1C0003
X-Stat-Signature: wkax5isojysonnekq8bezat3ktregya6
X-Rspam-User: 
X-HE-Tag: 1774195060-776073
X-HE-Meta: U2FsdGVkX1+Eac+wjpDKm+szl+SU1dISAsO0vGL9sjhNeCiCwcxb3NMlYEQbzLLfzHgH+zrLOuC8zBkGw37kJJ4ZrH9RowA/fscsZrLoLac6IkHmhMk49TM8Ki5BiSihwmT4MoNKfXL2GFcjpzD2jm8236ZTck+slg5uvLzzQCez7kQlvrT0K8fUsgEJ3D0YJD70RAqasHpdntTcRfN+Nr1Gm+Yf04S/84mvE2Ga56csuytjYMC1xqmiXj0Fvcka+gv/JyqLkwQiGij6paDNIiQUWWekorCOceKchcx+FFW5dI80BV11SY+yuPrD7DkAb2n5qbx6+9ZWmsu85DVI60afA+EPUQbbp6ZQeawKwrPGulxG9iLpltAC7Ws/W8lDdQ9DGqGLj0sWK6K8SkqDkii7OuwiLbQ4I0LVCBovC+TfcmsMXi6PAwLQufIctN9a7BRg3cPMX7v/SBCBC06uDbpuAxpwOqmzPsD4CbGrbWk2UMBpoXpaRkeoGkZgAghKjZA+gJ1o5f0wXxTEvYXoRsO6Hnc3gGv04cHM2QYiKfiOulp6Kl5e8Uew7Sxi/G6WgVNOORY1Hs3xcNuv9lI/bnLa69PkwST2s+YkNIruJsASQFxywNyyS5oz1ygwY6WLjj2i3obt+twuR1M4jnztwndn0pEVcifLdeDCnQvQi3bHzZtQ69K7I8S74RSnUDNBbWemVTGbehctaQgs1C4d2w4ufWbA3nxbxXxXyKo6lbeLC8NB6j5pIs+gitDIulcKn+akp8MevF65twnm7UjEsmry55UQczM61fqAMyy8QV9wFVhIn2FmaN4VgF5e/wWCegS1FnI4WtLqxJUV7pc07xIsgPDgGZqD7cT6MKSI9Bg+GW48wHOC68qfC5eym71X832V9F8Zqr41T6DyW+DlIaga99bpKTMUHEwgqcJhbJSs5dq93J92qKK8G3eLoCD2x22rm5b/G66/GJrA08v
 MI59HOTj
 95vDQTGnwrBr3xn8t5v1COTNVs1M3s1f5T/yXxYGbhQGW293E5WrEOUGAjCjD7ViZMUabt/HvM7ix4yq7gY+BJtXoqsQ4PKq9z3Hb4rQ2ZiIvUUximGCR5q1rk/CNGsMSfc5s3wuC3hYI8ztBqMJSR5Kk1Lqav0XHrzcb6SIrRuZa54RdvMvxjlLBRJS2WO+r/0qIkaW843XVHbMW2Z6pNRXHJaD4bcoSqD9u5Lk1P5KK3XDirM5QlWsp0NQOSk28d7ePERSJ+/siTUdQG++Wcmmz0D7xH9IhfL8JJOi8uyDRVCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 2424237ebb105..7059f540940f0 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -84,6 +84,13 @@ Description:	Writing an integer to this file sets the 'address unit'
 		parameter of the given operations set of the context.  Reading
 		the file returns the last-written 'address unit' value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/pause
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a boolean keyword to this file sets the 'pause' request
+		parameter for the context.  Reading the file returns the
+		last-written 'pause' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

