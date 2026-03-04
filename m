Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545FEEDEC09
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C8C26B0089; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9C76B0098; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBD36B0089; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A9846B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C53C4B7E01
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:31 +0000 (UTC)
X-FDA: 84507131982.01.DFA4DE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4AAB7140005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mnx/ae8y";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtMbNh3H86JFY8kZ/Eo+JjcntGif4NW9YtzRYc8lQGU=;
	b=vRmv8fAqwge+Las6FTAEDsHnnS2CCfYVrn6LWRnUtqodlRgYWnKXGaIKxUECxDstohakEw
	c4flw5BIpOxwDdlQ3wEcGZ6JAJOwFzMxyB9upGoaRgwW6iWWbkCnbN+fqi7p/0C+wwz14i
	o+dG4CERgjtqTFEaiCvHDQSlgpyhRBc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mnx/ae8y";
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599290; a=rsa-sha256;
	cv=none;
	b=fjdm7gjDUk3Tsk/t51itmmZCqVS828vmYf88Uk1N8+a6CXvdeJLrkjSCUeTMxY+22RslHp
	wvSErFZ5u7yAYa8XaBdyriP9egxQ5eS5DcoNC6vZLOmi/63Zolmow2dg/tIs7xp+s1tA9A
	zieyqfCkgDpyoE2kspGhJhgXDQx0F4I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C49EE6132B;
	Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D87DC2BCB0;
	Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599289;
	bh=8g5RM84PzzTOH9XhkrAPhPyfvWGkJhpn6rsV5ukGTjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mnx/ae8y7orLmFJZHFXSsQfrn7bza4w09l7fsKmvHiaNUshtMFj6Os3q0otSdDFX+
	 U/bZQpkt7velykvuZOTLKV40p0S/b6/t99O/nfrcU72o2G6oWQpK09W1PIy0xjLULc
	 8SIQKD+x5zKXo3samKrGB0lb1e3mhx6ylYRL7kQnK9iezNXgtT2OKntGmdM1Dh7+cd
	 +n39fBAnoT+Q8Oe/htB5t+MF9o2dRomk6xNk01gQk4LcZ8JZ5ZfaQdZcIDz38dN/yH
	 Qzra+z04nJcXBz/yAfG6J8dFxGFK/YIolLjiDRyB7zhv7mDo7TijM1AQoROTuRLsP6
	 X5l3cYn7g+xPg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 06/10] Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file
Date: Tue,  3 Mar 2026 20:41:15 -0800
Message-ID: <20260304044122.79394-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4AAB7140005
X-Rspamd-Server: rspam07
X-Stat-Signature: btjk538475gw9qhk4suijwyxon5phfru
X-Rspam-User: 
X-HE-Tag: 1772599290-242180
X-HE-Meta: U2FsdGVkX19EvRizKhIYpGIP0dfOjHrfUkPqHHGyrkbaDePbkWP6p8KQEd84AaHoGWMgBX1GX1IzOx3ot3uY7ftaVlYC4jlKei0ey3luUs6w08rT0RxqE/XHtTfngplIHx8JgibM3z1SX1lhaMBrqE6g3RX1dWr3yXWz3ghrRwXsGQ6kWMIfJ/p+htCFlCTl6PDaPCdJsGb68+KRGllI2mBfyIEZC8bzYAFXSvZi9PEXvJFEqzLATdz+bZibeEKe1E0oJFJZah052EEY6PiyOHE7Zi5a20Wbi6zTZWK2BP66eE4ol2jbuRrq+KUA7FwO+Jkt2qVmyEGhIsnVflM8lyVgKWT4rGL6RRDfE+z73dkipL4Injsrc1d1vOFm6uUBcSjTbjEbrQuLw73DDvgUiFVYkfZTsX+ICyFoENIbXHs3gM7HP0rGL2FDh4+K1ndIMe1UMiJHoq+APF6QfYjiPRLH9DgldmmfZZweX3vvv/ehA1U2byrsvmUWNBUTWBsDgEYLuj4PDZyxh0bbZ5qBWGwH1JeBXzcKhK0g1Aq1T5O8f+tvS7lYOJwGOXrx6ahgNvoptoIou7sfI6znk8IiG1cLtTOeI2db+sxjT/uYBsxzsWGepb+DL+UqJK525W7CE4fftvKUmhMCPcrwTIKJnpGFmiwHn3LNVQ4OMkEBoWoezjtrQuit5O8xokl80xxE27cuKFgGg2H7sS1c6WaN64tuG36gUE3/yMWjHdtLh9/yY+IUQfo6eDGLllXB7T7Q/ZkDuGx9xm7lGLsoPcSO4DmDKpsO7MHSRC/c+cn+Gf/2jw5F5yTtavFhddwvUNKdUdplqKdfb0GR5cjuF9SDjZurUbl9viC35WDMw8lGMzEtdtTjrUyLG7X7z704ovoBsD19CRLAcs/SQPhbF7/JuJ/oj6KCh4WW7XpiJeUybhfIyM39wvjPjKR58Grj5ajE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the DAMON usage document for the new sysfs file for the goal
based quota auto-tuning algorithm selection.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index b0f3969b6b3b1..534e1199cf091 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -377,9 +377,9 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, four files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes``) and two directories (``weights`` and
-``goals``) exist.
+Under ``quotas`` directory, five files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
+directories (``weights`` and ``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -390,6 +390,14 @@ apply the action to only up to ``bytes`` bytes of memory regions within the
 quota limits unless at least one :ref:`goal <sysfs_schemes_quota_goals>` is
 set.
 
+You can set the goal-based effective quota auto-tuning algorithm to use, by
+writing the algorithm name to ``goal_tuner`` file.  Reading the file returns
+the currently selected tuner algorithm.  Refer to the design documentation of
+:ref:`automatic quota tuning goals <damon_design_damos_quotas_auto_tuning>` for
+the background design of the feature and the name of the selectable algorithms.
+Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
+setup.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
-- 
2.47.3

