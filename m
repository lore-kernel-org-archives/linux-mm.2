Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29246606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V8N8ippB
Received: by kanga.kvack.org (Postfix)
	id 44CCB6B05B2; Mon, 26 Oct 2026 16:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDAB6B05B3; Mon, 26 Oct 2026 16:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314D16B05B4; Mon, 26 Oct 2026 16:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 102ED6B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:54:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFA381A0833
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:54:07 +0000 (UTC)
X-FDA: 85365979734.23.1B81C86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 16FED4000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:54:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8N8ippB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793048046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y+asd5FcmQ3i2iF1cd+nZYxacxJNYDOSQpqYG634Y2c=;
	b=LT239btps5ea6Ma3EofcbMU/OfaGP2IfC68cI3BnAOFle11r9jo50XTp2GZm6zrrTCvVQy
	ZWn0uomgzL5P/A0jCihXv6s1zRhvTcDwusjHZpZalqDVQ4BVVhxeGhDfJAUlsmrueJ6lFc
	KyANfQfPKb8vp8Y+vyc5KdjiQEUJT8c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V8N8ippB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793048046;
	b=e0rm8WHBt57fWT2h+7SBaD8gCzDZrRaOn6q8n/AFd5D5lJWp81b5FMY+lq6XSzYQDFZbRZ
	fRf7DCKHBR43dUyjBwOM0I7xjl3TTAfbxu8dE2AnGml5h6M+y9O4oVnCqnoi8l8Rnj8+Kb
	51gWwGJN1LeNJVyosOpCabUAxJIhm90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21D88601EF;
	Mon, 26 Oct 2026 20:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276721F01825;
	Mon, 26 Oct 2026 20:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793048044;
	bh=Y+asd5FcmQ3i2iF1cd+nZYxacxJNYDOSQpqYG634Y2c=;
	h=From:Subject:Date:To:Cc;
	b=V8N8ippBjZTWjNgvaG+rtSMn0Ugh5vnzsVMSrhfrv/o4IyClHiF5RDGfEWdl05RDS
	 r0anx58IJMeF1VqfmqbhPjY4ET/u3q1Pct2Ir8q3rIZXWsZb74FtTkHsKkq08h7Leg
	 SONRcbgmD10dv1Xw90+GUlUQWH5R96qbp4kk565Ehq0tlAbPwgLOlso9Fg2AXV65/0
	 NsY2ztkve0xA75edvwb/8H4D8Uzzwqjn8tPWVcM51YS5Ea82ZSL5wyOIy86BKD6YIA
	 9reMhiKJ2o8eq2WYNSZw6Y7BF8hVgyB5VtMm3HzEkbTZhZ8BdGbk9sWNtl0vQRO6Bh
	 JPNyqWU592fcQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] userns: keep the exec securebits
Date: Mon, 26 Oct 2026 21:53:28 +0100
Message-Id: <20261026-work-securebits-userns-v1-0-b35473fa1a34@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/0XMMQ7CMAwF0KtUnnGUdGiBqyCGJHWpQUqR3QBS1
 buT0IHBw7f+fysoCZPCuVlB6MXKcyrBHRqIk083Qh5Khta2nSuH71keqBSzUOBFMRcgKXa2t8E
 d/SkOHsr4KTTy5wdfrnvWHO4Ul6rVRvBKGMSnONVXdc3fNbtragu27Qtum2LcqAAAAA==
X-Change-ID: 20261026-work-securebits-userns-6070b18a9cda
To: linux-fsdevel@vger.kernel.org
Cc: =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
 Serge Hallyn <serge@hallyn.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Jann Horn <jannh@google.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1917; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iujI9aAJYOrnMNbrp/gBJRYkBHmRYoPzBhbDlZk61JU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTd3/u4PCjlu9GzqZffpKffDVyt+GEhg0D2ggT+SunZz
 QILv8/P6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIwWKGfyqdxvddnLp4zgWk
 x+i43T1SUawhI9v7YobcfqPCfa3M7gz//bvOlohpXH557OWrEjt7Le4zDnc0UpcqybN2Zciu7V3
 MCQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 16FED4000A
X-Rspam-User: 
X-Stat-Signature: d47t91349389fdhtp3xrsp5nsfz9b5qb
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793048045-543844
X-HE-Meta: U2FsdGVkX1/mkY6AJK/gki+X7C/0OtQvI7Tsd9hL6vfi2e+34XFU3gsxXbcxLGDRE1U4/7JemDSuvbSkdDSuxm+86JCkNIz2PDce99hjXZ/iBO38xGVZ9vuKDDrPrQeaY7nA8VWeNADRS/TWyGJH60Rcgv4jhMnx3HGKbUnWkS4T1HK3NdPboNpdAGeotdLg2L0nsm5j2QasK4Qhf6mmdtU4eF9zNR/43oJt2ellZClPvHc8Dw7FiHDi+zsuvw9XeGkC+ZaXmPbzXyI/f6GWJIRodoRB5fGzWHBkwGHdwoiqaznGryKnD/SvJenhCaiQlNUefqows5BoKQKqEKH38d+mm29y/6GCgPjEwFY1rrd/rvG00CJezwUxRl+1DDGtWExOSYRfdRRLG+3kCXYNZzZq5ABZvnGTP1NUi4a1rtmDJz/SMtsShLJI+Wdl0fv1WdK39ltdSa8FrJs5dI1jF1ISLu0o92LBHPDTEaj3P+wocGPyNWSl09Rgt7HBjOzrnO3SdFY/dJS+RV+scMSOdLR7nGazlpzxqDJeaSI8JJu54wtFgdLvwAr/uo32hYHfJ1yIzwqRFG+++6Br+b8ymzqx4LRUk5oWbtXn2LxG84r/thEzw3q3bDm4fogV/VfC6e9lYu5hu/fN+uXfHeJsUoGY+fTCFHSoTk1Q2Ytq9Q1b+LfWr+Li+2+GtLtHV0tag3PV292txrz3jhwfkILkvEV5Xgx9faXAGwMf9ou7gWdsRcYBVFWBC+iMLVhRJEZ7n5brJsvI1lP9CKuTjVLgAT6VcAcv+NHGCI4xLIgAeqzDcFdnPPYrddwSIFxfYNSBxHeKeJh88D8oUXwFzRYW/Q+maLatoVwpMUA676tXv8GIBuQ31War5YTw2cYCeasGWAyn1pkStXlBoMLNq8ttN4fsqu3EdRJ/LwLn2ttehhqrf0JHHiOE6DsAt27EnU8IPLp5qFL3EvPLQYCPyDN
 em8mKp+6
 nPd0W2z1/Q91VH74el3dJTuoq4EKCf8OVHydgRF/MVHw9u9VjEkMwF+PkTGduxIykMvWbeXrrJkQFtGpu1pZ9x+9GixaOjHIlDo3EZMs897RyN44A1uhrwciVLkkwy2Qp8f5LFim+vuP1VwSKjiVzMm1TKrND9HwZdX+U1+8g2uDkdffawdktbvn2ieqEeDKNSwTvDhAtZl8EBHn7Pb12z4WkUYcgcc2lezuapI2NAynjuHT+5MTFFv7MZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The exec securebits are meant to be set and locked by a service manager
so that nothing below it can turn them off again. But creating a user
namespace resets all securebits, locks included. So anyone who may
create a user namespace can shed them with a single
unshare(CLONE_NEWUSER), and joining one with setns() does the same.
That's pretty much everyone.

systemd gains a SecureBits= setting for the service manager itself. It
sets and locks the exec bits for everything it starts, so interpreters
that support AT_EXECVE_CHECK enforce the system's execution policy for
their scripts. With the reset "unshare -U python3 /tmp/x.py" gets
around all of that.

The other securebits are about how capabilities are computed and
resetting them in a new user namespace is fine. The exec bits grant
nothing. They're restrictions a task placed on itself, like
no_new_privs, which a user namespace doesn't drop either. So keep them
and their locks and keep resetting the rest.

I also keep the exec bits that aren't locked. fork() and execve()
preserve them and the task can clear them itself anyway, so dropping
them on unshare() would just be inconsistent.

The new selftests fail on mainline and pass with the fix. I think this
wants to go to stable, otherwise the locks don't mean much on any kernel
that has these bits.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (2):
      userns: don't drop the exec securebits
      selftests/exec: check that user namespaces keep the exec securebits

 Documentation/userspace-api/check_exec.rst |  4 ++
 kernel/user_namespace.c                    |  5 +-
 tools/testing/selftests/exec/check-exec.c  | 83 ++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)
---
base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
change-id: 20261026-work-securebits-userns-6070b18a9cda


