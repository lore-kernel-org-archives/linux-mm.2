Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9164660A261A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kccoFDHm
Received: by kanga.kvack.org (Postfix)
	id EA2496B05BB; Fri, 20 Nov 2026 13:39:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E52B26B05BC; Fri, 20 Nov 2026 13:39:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42026B05BD; Fri, 20 Nov 2026 13:39:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A26A86B05BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:39:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24B7412015F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:39:47 +0000 (UTC)
X-FDA: 85456361214.06.8E3B6A3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0069A160011
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:39:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kccoFDHm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of reinette.chatre@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795199985;
	b=yV0QzzoX6m+Ahnz1qLjRuh9DmCctbmjk9tsOZOtmAtZwHWqZbTi4EEcKL9wgqTvnMkZzac
	XuGtCrFtEl/CHGx8pAJeunpjHbxtNsCdpMCqWbTDFyZBHkzmaSJwFCDJVc7aEsrJslnla4
	pzeac5ISENgOVdPAh27PQTd8gHbpktw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795199985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vS3paOgEZLv1A1g8OmyxuKuZIhXIN3I0FA00VP71j9E=;
	b=HV7usdvezFg2jiUt37EDn7RIpwhbJl4WaXAbG7RwkT9R14HXSTGdR6ir7ln1rrSAILNBLP
	AKRYosyNpZYVlIRq0F78i4jJYUEDsyHYQMXGfmnIqN4O7PPyKifVznQytRuaVaXBqN8dAY
	fIGm8Ykabbj9lisYEsQ4YsKBEL6QBSA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kccoFDHm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of reinette.chatre@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=reinette.chatre@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795199985; x=1826735985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=artrgIEQtld+2V6JfYqBRD0b9Ldu3nOeD2Sv3wtSRlc=;
  b=kccoFDHmQ+FSOWGIBMAWq4y8rzeeUXyqj65F+3R3j46FHleKXdHegFfH
   Tz9Owkx9+WKALDYucANC/jGWkvAeqNglmK3Bn+klE74sZvswL8iZF7PJ4
   fYhHcEASbUmMQPU2qgzXFMz01ofVAgDS4uuEwuvhiQqooyxJjitb+bTij
   d4yEvOYN1GIa2AR86B828zVKeP3NorWxS31ieMUUP2GZsaMIZJBmzJJEJ
   yOaEAcp6k5iMG1FLFPRzJgDiX1sIxYexoylh2enbjsTbwJMjf/Yr/2H5I
   ZAupEXOiTL/PBNOXlpEMdb2UAbCLlCNdFMyY2OO5KXrN4+CMv7sUduIb1
   Q==;
X-CSE-ConnectionGUID: bSy5s4k3TNSt1wbiV4+SBg==
X-CSE-MsgGUID: UzVfyKDHRUWoxg9zfGo+XQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="3931869"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="3931869"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:41 -0800
X-CSE-ConnectionGUID: 1AYaa7RqTi6A0NpsPcW6MA==
X-CSE-MsgGUID: vgafOxPTSLq/IEr0tRm6dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="12590722"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 10:39:41 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	tony.luck@intel.com,
	ben.horgan@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	fustini@kernel.org,
	jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [RFC PATCH 3/3] NOT_FOR_INCLUSION: selftests/resctrl: Tasks keep using removed RMID after fork() reproducer
Date: Fri, 20 Nov 2026 10:39:32 -0800
Message-ID: <2f95c069a2646af7d5745b14d2c53d0d9d450bc7.1795197419.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795197419.git.reinette.chatre@intel.com>
References: <cover.1795197419.git.reinette.chatre@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0069A160011
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: eiesf8c793r1m1p4smj7ha1tsgssbzrn
X-Rspam-User:
X-HE-Tag: 1795199984-54009
X-HE-Meta: U2FsdGVkX1/Rm6MLWJauHYsXEzDxsRV1lGphm/QfrtXHsO2femXGvP6DcaLZi/KQGqcmhyBMk60GS8OGRmBQ7lt24il/MQ0o5hZGSCWlX6AW459R51JZU1aZ5e6/Rmd6La9DcGi+IlZzmac3w7JbGpCQ9xyzt26MPRLf+ErQXXOUPMzxj6vKpG0QyxxFWob1st/QBTdbluc8ZfLvk+uKEQFu+OZpZs6UUxxrr4MsJfQO6QTuR2IfvsVKFECvYMsVSEfbn3mzXjtJMu8xXQlzsCvcY/fO0jxdQgchkTXjqvSUrr9TXhRYRsesFtj717m6MioFCcGbKzBD4grHsx0y4LnTribX/xR/2tB6popTZcVglFU+kot2dlUnRmJmaua/XK9hF/dIJi9ahuYEwYBgGADjUvsVd0bwbg0VYBua7J/LNgZ7Mobyuf3zJsCYNExxG4kShVHEOxn5tAq8xat9AXpJ67FKcqjhEB8QV08KgUjOwmE3sFt2JU42gXc12QTUsnXOZ4deAvdlOVDv4+Shu1Hy1ggbbqOn/7qYqfNuZmlZULME1rT5gEmDQQBaUCqkG/iXFJVMZsTx6kKOEBhAJSfMqSphF8r4k+b3nS/PtbhP/dgCeLEcZFRzOjVcw9OOCw+SOMBbbB2U0KwqxHDCFe8c+HyKGLYMPBZA0y3HIURYNW/nyZJDcff26ImrckvClHWWLEl647YROl328QJW6McCdPHyfUlQv1DaXj5m2M2vkqlZAVSSVNVZ08tkeIyoWqRQT69m5OFpAALm1I0vhdnk0aWDLOuEZBWN71mIIXhSweZNiSwtt/vwsvM65nRxAyjhaB80eKJTkkcbyvTfTdnmHbExo91yytiCLqizQeF7dI4O1rR8Zmd7c/FwzFV2omo8GvLj9SldZ3kZWm709JfClFJkPzMuNb7omRJNtSUlBoDrayLenQzuvuFKQM/GmL/oCIWV1+w5sbIyYn9
 vCLvmhuK
 uUs3UZ9aV5L5EucfE8K/JmRxr5ckzoQhP0nf4UsD25qiDa+8pegOB7d2W5kLmQBBvvo/D2jbGfAgqToBNQcI0MTEjIUkUvUijIh/a46+p+y9ehcOmF1gTvJ+ONN+zHbz8InyooSYHyLQN4ltqoW5wSfpQOpRJhbnbXaO2fDaZ2uNgjV/tnQuoFxK9YU8A55IzSwcEfuSkiGcs7H3Jp5g4gsM1WJNw5VlWzEA/UmbmRU9B4PG3+9otEttp4HuLuHYqr34R4r3AZ53/aKYugt3Zm8GFw0hbyhwTsamsjYZM/Cz0dccK8kUw0vJheYLrhcEQEViqnNQBZwa+i1l4R2ta/eTSliGFsbRSbVSnbQAEpoBmlsQgXq7Z5I7FJ9DM3rB6fotDhjCVHgTTau/ZnpQSydmmwH5ajDTcrFWbVTd5rDXTdL9D49QBD7Uj4xqovYoGXOBc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>

Introduce stray_tasks_repro.sh that demonstrates how a task forked while
its monitor group is being removed may continue to use the removed RMID.

What this script does:
  1. Starts 8 processes inside a new monitor group "m" that fork sleeping
     children as fast as they can.
  2. Removes "m" while they are forking.
  3. Creates new monitor groups until no RMID is free, so the RMID freed in
     step 2 gets a new owner. Nothing is ever moved into these groups.
  4. Reports every task found in them. Each one carries the removed group's
     RMID and is a stray. The expected result is none.

To avoid the freed RMID landing in limbo, the script requires that LLC
occupancy monitoring is disabled (on x86, boot with "rdt=!cmt").

Example of issue encountered:

  monitor groups created: 566, stopped on: No space left on device
  tasks in new monitor groups (expect none): 1
  /sys/fs/resctrl/c/mon_groups/n565/tasks
  RESULT: 1 stray task(s) kept the removed group's RMID

See script header for more detail.

Signed-off-by: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 .../selftests/resctrl/stray_tasks_repro.sh    | 122 ++++++++++++++++++
 1 file changed, 122 insertions(+)
 create mode 100755 tools/testing/selftests/resctrl/stray_tasks_repro.sh

diff --git a/tools/testing/selftests/resctrl/stray_tasks_repro.sh b/tools/testing/selftests/resctrl/stray_tasks_repro.sh
new file mode 100755
index 000000000000..42f65d7d7bb4
--- /dev/null
+++ b/tools/testing/selftests/resctrl/stray_tasks_repro.sh
@@ -0,0 +1,122 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# resctrl: a task forked while its monitor group is being removed keeps the
+# removed group's RMID.
+#
+# rdt_move_group_tasks() moves a removed group's tasks to the parent group
+# under read_lock(&tasklist_lock). That lock only delays a new child from
+# joining the task list. The child copies its parent's closid/rmid earlier,
+# in dup_task_struct(), without the lock. A child whose fork() is in flight
+# when the walk starts therefore joins the list afterwards with the removed
+# group's RMID, and is never moved.
+#
+# What this script does:
+#   1. Starts 8 processes inside a new monitor group "m" that fork sleeping
+#      children as fast as they can.
+#   2. Removes "m" while they are forking.
+#   3. Creates new monitor groups until no RMID is free, so the RMID freed in
+#      step 2 gets a new owner. Nothing is ever moved into these groups.
+#   4. Reports every task found in them. Each one carries the removed group's
+#      RMID and is a stray. The expected result is none.
+#
+# Requirements: bash, root, resctrl mounted with monitoring, and the L3
+# occupancy event (llc_occupancy) off. Memory bandwidth events (mbm_*) are
+# enough.
+#   mount -t resctrl resctrl /sys/fs/resctrl
+# With llc_occupancy a freed RMID waits in "limbo" until the cache lines tagged
+# with it are gone, so it may not be reused and the race cannot be seen. Without
+# that event a freed RMID is reusable at once. To turn the event off, boot with
+# the kernel parameter rdt=!cmt. The script refuses to run when llc_occupancy is
+# listed in info/L3_MON/mon_features.
+#
+# Output (example of a hit):
+#   monitor groups created: 566, stopped on: No space left on device
+#   tasks in new monitor groups (expect none): 1
+#   /sys/fs/resctrl/c/mon_groups/n565/tasks
+#   RESULT: 1 stray task(s) kept the removed group's RMID
+#
+# The race is probabilistic: run it several times. "no stray this run" is not
+# a pass. If the run stops on anything but "No space left on device", the
+# freed RMID was never reused, so strays cannot be seen. The script then
+# reports RESULT: INCONCLUSIVE and the run counts as no data.
+#
+# Side effects: creates and removes the control group "c" and its monitor
+# groups (it refuses to run if "c" exists) and starts thousands of short-lived
+# sleeping processes. Other resctrl groups are not touched, but while the RMID
+# pool is full anyone else creating a monitor group gets ENOSPC.
+
+R=/sys/fs/resctrl
+C=$R/c                      # control group used for the test
+M=$C/mon_groups/m           # monitor group that gets removed
+MF=$R/info/L3_MON/mon_features
+
+[ "$(id -u)" = 0 ] || { echo "run as root"; exit 1; }
+[ -f $MF ] || { echo "resctrl with monitoring is not mounted at $R"; exit 1; }
+if grep -q llc_occupancy $MF; then
+	echo "llc_occupancy is enabled: freed RMIDs can sit in limbo."
+	echo "Boot with the kernel parameter rdt=!cmt."
+	exit 1
+fi
+[ ! -e $C ] || { echo "$C already exists, remove it first"; exit 1; }
+
+FORKERS=()                  # PIDs of the forker processes
+KIDS=""                     # PIDs of their children
+
+# Runs on every exit, including Ctrl-C: stop all test processes and remove the
+# test groups.
+cleanup() {
+	trap - EXIT INT TERM
+	[ -n "$KIDS" ] || [ ${#FORKERS[@]} -eq 0 ] ||
+		KIDS=$(pgrep -P "$(IFS=,; echo "${FORKERS[*]}")")
+	[ ${#FORKERS[@]} -eq 0 ] || kill "${FORKERS[@]}" 2>/dev/null
+	[ -z "$KIDS" ] || kill $KIDS 2>/dev/null
+	sleep 1
+	rmdir $C/mon_groups/* 2>/dev/null
+	rmdir $C 2>/dev/null
+}
+trap cleanup EXIT
+trap 'exit 130' INT TERM
+
+mkdir $C $M || { echo "cannot create $C and $M"; exit 1; }
+
+# 8 forkers. Each joins c, then m, and then forks in a loop: a sleeping child
+# that lives 20 s, plus a very short one that keeps the fork rate high.
+for i in 1 2 3 4 5 6 7 8; do
+	( echo $BASHPID > $C/tasks; echo $BASHPID > $M/tasks
+	  while :; do sleep 20 & sleep 0.0003; done ) &
+	FORKERS+=($!)
+done
+sleep 0.3                   # let them start forking
+
+# The race window is while this walks the task list.
+rmdir $M
+
+# Remember the children for cleanup, then stop the forkers. The children stay.
+KIDS=$(pgrep -P "$(IFS=,; echo "${FORKERS[*]}")")
+kill "${FORKERS[@]}" 2>/dev/null
+sleep 2                     # let forks that are still in flight finish
+
+# Take every free RMID. Stop on the first error, normally ENOSPC (pool full).
+n=0
+while err=$(mkdir $C/mon_groups/n$n 2>&1); do n=$((n+1)); done
+echo "monitor groups created: $n, stopped on: ${err##*: }"
+
+# Nothing was ever put into n*, so any task listed here is a stray.
+strays=$(cat $C/mon_groups/n*/tasks 2>/dev/null | wc -l)
+echo "tasks in new monitor groups (expect none): $strays"
+if [ "$strays" -gt 0 ]; then
+	grep -l . $C/mon_groups/n*/tasks        # which group holds them
+	echo "RESULT: $strays stray task(s) kept the removed group's RMID"
+	exit 0
+fi
+
+case $err in
+*"No space left"*)
+	echo "RESULT: no stray this run, run again"
+	exit 0 ;;
+esac
+
+# Not ENOSPC: the pool was never full, so the freed RMID was not reused and a
+# stray cannot be seen in this run.
+echo "RESULT: INCONCLUSIVE, the freed RMID was never reused (${err##*: })"
-- 
2.56.0


