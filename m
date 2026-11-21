Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6567F606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dhE2skl8
Received: by kanga.kvack.org (Postfix)
	id E12196B00EF; Sat, 21 Nov 2026 13:40:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3C16B05B0; Sat, 21 Nov 2026 13:40:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8F76B05B1; Sat, 21 Nov 2026 13:40:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1476B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:40:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E83CCA057D
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 18:40:14 +0000 (UTC)
X-FDA: 85459991148.12.0AFEB9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4AAF11A0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 18:40:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhE2skl8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795286413;
	b=VhvcfLKw/1Ro1SMgP8KIqTn9kvAxWQ0EQUcnKb2CRQca1hASxTsGi6tK546N5Y76lRGRRR
	LHs3ZGHT8Sz3AJ/pXK2EB/3FlVSZmKUkyayEsFL1+QI1Tyo6jT5AMLrOmf21YQ5SJOFaAx
	AteKd2Lp6IcfhH9zKGFlrIor910wri0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795286413;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yODxFoCJLk8oVC8VZOQVwmO8zUsVH8boKtD79A/3Fso=;
	b=faWybsCGmuBBYBAvB9M0wbmxbD+sHIAMVvCb9CSidXqNxKRw6oOm25VbpzGb2fUMCJ5EM8
	qjPm3AVzsbVVeZK5X9m/2Qk1Q9yMpDGDMmHHr1UOKrD7Wd5OUr4Ta8tQ18FEc8ObUon7xg
	WyYpbn7Ml8J5sD3p5BlKfLlEfwTB90M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhE2skl8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 38F65439A7;
	Sat, 21 Nov 2026 18:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989991F000C0;
	Sat, 21 Nov 2026 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795286412;
	bh=yODxFoCJLk8oVC8VZOQVwmO8zUsVH8boKtD79A/3Fso=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dhE2skl8IQDBPGtT3vL9s3Z1jh+m4swnp+T125amVYjf9oCbSiNx/FttscviAg/Hw
	 Yykm2uAaCSNK+9ZhScGYGcFmVrGoEp8W6fUZEX+OxqMAzkCJfEAP50i6WOi7a0sjYF
	 xzac9CEwpvmiUFBWRb9ldqvJ9uZs2vnzjtUUBKAbI37GAvwCX93lsywV5P3pERL9hT
	 x0xHaq0Yg16h/7JzRD3mMYloEsfgA7VlkLYIlaeDrMtWiZGyvnWu3V8y8yB1OvhqlU
	 iykACtzC700bCJGhPdeXjzRNHr+h5KnQ27nRiKfBUPvQdYeeQLSJ8GlDcTapvIOHxz
	 Ka6Zyn4KUhcIQ==
Message-ID: <sashiko-outbox-227266@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/3] NOT_FOR_INCLUSION: selftests/resctrl: Tasks
 keep using removed RMID after fork() reproducer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Reinette Chatre" <reinette.chatre@intel.com>, kees@kernel.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, bp@alien8.de, tglx@linutronix.de, dave.hansen@linux.intel.com, tony.luck@intel.com, ben.horgan@arm.com, Dave.Martin@arm.com, james.morse@arm.com, babu.moger@amd.com, fustini@kernel.org, jedrzej.wasiukiewicz@intel.com
Cc: fenghuay@nvidia.com, peternewman@google.com, yu.c.chen@intel.com, x86@kernel.org, linux-mm@kvack.org
In-Reply-To: <2f95c069a2646af7d5745b14d2c53d0d9d450bc7.1795197419.git.reinette.chatre@intel.com>
References: <cover.1795197419.git.reinette.chatre@intel.com>
 <2f95c069a2646af7d5745b14d2c53d0d9d450bc7.1795197419.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 18:40:10 +0000
X-Stat-Signature: m559znaqjycnfzp44f91nzkm11a9zquh
X-Rspam-User:
X-Rspamd-Queue-Id: 4AAF11A0003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795286413-245352
X-HE-Meta: U2FsdGVkX1/Manu1vp1RSwWfROlkgOUhOAEYNMAko7dduynFDodY4pgOkStAhxVf6ZcTaXFlbBcBJEMgg7jfPGl4mIrsh1hrC3wO4SLHVuf1tKyKMuo8YDNfI52DITIyv3JoTVe9P+5l5Z3Ewi6dw9iFcGkcJz4nIiPHR0spZcsB62lnHY9otpesVMGXjlpF/kn7ihij2qzPJMc3MghirFuIwbWBQWUH30i3S/x+04ONnUXxtsiVduLYO8vaHT/tzpcDJKhwty9ma4QqVqZ8nBxIVPzTEPObfdZLj6mhKzYfwd0pgF6BtJfc0WBf/y1d5wBkYNys4/QZ6Ryz7rjL4r+HTduNxDwU4rmIbLlCFVoFpF2ggX/Po1MTGxvuNd2vjU9BRxKyudF+X84spFY3oIpquYnAr/mDW1q9H1kwa+m59OPB0aptyummuQSl5IY2Ui1+VV/mY/cbVCevqfpEJD17P/oSzy4WLY0XhTgWpOGf5LWR/hj9Vnhop+ST3dbkzaVuPNjXW47O5o89ngacewMEDZ9sSEAIbm2Ir41S2yS3Vl8NiUKvTZqfEILgo3wCjACRomRz8hwJMWqCoKRWsm7Bud8Mha0M8T+8/88dG5GTNutH200qBgqzXJTwwSGFTYWPDYcFCOHPVM2t2b0dlUxPc/eiUuMT5L9NYi4dbh7HiQe5f7OKcnF4q+ikkv/HcwcRctprN0KL4J9L7kzKgL8GO7sz3acgF3qVjJ6fOo2HXK5LFkLEdWXWB9Ja/HxHHqMXx6XfFm/T0sUXKd6tvzoL3VSxoVzfb46BeVk6uyoLhj1GceYlo9kKMWtKZzEn11k/cHX5HXG78sXWsVs2ly/OHUDmfeUZ+23ixmic9Aib60A+GhxGaXM535inBMJI5LuTXx0tw4MTwNV+iv6AoUY/vUd0rG2Oh4pDUjT7lX0QQ1lkhRqiUHIKH8WBGUqUxXZncb4hRjAdm+ZGgn1
 1xOcEhl8
 Co7Jn3oN4aga1ziH6nUGM4K7XbPOjaBmV6GSVcbe59pBiIRre8NShNjcUfMeg5bgt4syjb0NCqV6CqMJvpfq88lx/YN6qC8TtIyLZEHQ+520jxXIoZkQo7zlyzyd7+MwzoEyMgDHVLV9Z31R/Ykdqop121wXOBVIFoExhuAkUN0xXB3L7kMehNbiYnoSj7I3nC/d3Hk9lko+ANCJui2QYdZFGvGptzfsm56cqiRKgdRkjIYYoO1mN0z3yzs1wwUe+sebTRMUHT7+x10RKCtGNUICrpGzBA+6wPXQB+kShi017eeQL6OSNwNVmg9bLvsZVY7t3YqQ+CnmBo9NndJGrXHZtdoOqHsre4PGt85SKgoZxE5d6Z4bf5kkZsnJLz1Ba0oTbAdoauHV8olnAXaV2zll1nTbgB3UHXRb/oMaIwps8k70TOU4a6y1dE9FGe3xVQVdx8XekYzznjV6pHngZVNe/iXZiMSVyKWWeeme6AFs2SXVDIJN/Wma12lqxUzFRlyVHK7bMLa+4F97yQQi7jB18acnNMvu3EseVAWUvW37VDL99zPpOcBlhUgOK1mbbeOe5ev8ciZddDHPO/4irGV+oFxVRqJo8Y7FRjBl8rfvQSClc1YRYMMsWp2XoJjU+CDEF8dzw2zlvl+MNQE7Yd46pYae+cG2aA7sxbFlt0WP0M94mHFakeiuS58xPTcYJONNb4Eizx76/deercgDSY/PGlNhdFQJgIrXWGFq6EdBT+/lmgHqd65oHSCHTrwRwuMVliiK583XOygljyBN+UsHnBqRbzMBWOn3ICqiLLjMLLQPtDpCIuqfjZjRI6WNiXKw9ihwrBsV6RaBrD+Wpcr8iFTghli4na7KJRmSXS5q37v4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Medium] selftests/resctrl: wrong exit status on fail and skip in
  stray_tasks_repro
- [Low] selftests/resctrl: stray_tasks_repro.sh not integrated into
  resctrl_tests
- [Low] selftests/resctrl: leaked child sleep processes in
  stray_tasks_repro.sh
- [Low] selftests/resctrl: locale-dependent ENOSPC match in
  stray_tasks_repro.sh
--

commit 607e215a0575d792a89253ec24f065f27a1b6a67
Author: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>

NOT_FOR_INCLUSION: selftests/resctrl: Tasks keep using removed RMID after f=
ork() reproducer

This commit adds a script to reproduce a race where tasks forked while a
resctrl monitor group is being removed continue using the removed group's
RMID.

> diff --git a/tools/testing/selftests/resctrl/stray_tasks_repro.sh b/tools=
/testing/selftests/resctrl/stray_tasks_repro.sh
> new file mode 100755
> index 0000000000000..42f65d7d7bb4d
> --- /dev/null
> +++ b/tools/testing/selftests/resctrl/stray_tasks_repro.sh

[ ... ]

> +R=3D/sys/fs/resctrl
> +C=3D$R/c                      # control group used for the test
> +M=3D$C/mon_groups/m           # monitor group that gets removed
> +MF=3D$R/info/L3_MON/mon_features

[Severity: Low]
Could this test be integrated into the resctrl_tests harness or wired into
tools/testing/selftests/resctrl/Makefile?  Right now it is not listed in
TEST_PROGS, so standard kselftest runs will not execute it, and it requires
/sys/fs/resctrl to be pre-mounted instead of reusing the mount_resctrlfs()
and feature-check helpers in resctrlfs.c.

> +
> +[ "$(id -u)" =3D 0 ] || { echo "run as root"; exit 1; }
> +[ -f $MF ] || { echo "resctrl with monitoring is not mounted at $R"; exi=
t 1; }
> +if grep -q llc_occupancy $MF; then
> +	echo "llc_occupancy is enabled: freed RMIDs can sit in limbo."
> +	echo "Boot with the kernel parameter rdt=3D!cmt."
> +	exit 1
> +fi
> +[ ! -e $C ] || { echo "$C already exists, remove it first"; exit 1; }
> +
> +FORKERS=3D()                  # PIDs of the forker processes
> +KIDS=3D""                     # PIDs of their children
> +
> +# Runs on every exit, including Ctrl-C: stop all test processes and remo=
ve the
> +# test groups.
> +cleanup() {
> +	trap - EXIT INT TERM
> +	[ -n "$KIDS" ] || [ ${#FORKERS[@]} -eq 0 ] ||
> +		KIDS=3D$(pgrep -P "$(IFS=3D,; echo "${FORKERS[*]}")")
> +	[ ${#FORKERS[@]} -eq 0 ] || kill "${FORKERS[@]}" 2>/dev/null
> +	[ -z "$KIDS" ] || kill $KIDS 2>/dev/null

[ ... ]

> +# Remember the children for cleanup, then stop the forkers. The children=
 stay.
> +KIDS=3D$(pgrep -P "$(IFS=3D,; echo "${FORKERS[*]}")")
> +kill "${FORKERS[@]}" 2>/dev/null
> +sleep 2                     # let forks that are still in flight finish

[Severity: Low]
Does capturing KIDS with pgrep before killing FORKERS leak sleep 20 child
processes?

Because the 8 forker subshells are still forking in a tight loop while
pgrep scans /proc (and both here and in cleanup() pgrep runs before sending
SIGTERM to FORKERS), any child spawned after pgrep checks its parent or
whose fork() is still in flight is missed in KIDS, reparented when FORKERS
exit, and left running after the script terminates.

> +
> +# Take every free RMID. Stop on the first error, normally ENOSPC (pool f=
ull).
> +n=3D0
> +while err=3D$(mkdir $C/mon_groups/n$n 2>&1); do n=3D$((n+1)); done
> +echo "monitor groups created: $n, stopped on: ${err##*: }"
> +
> +# Nothing was ever put into n*, so any task listed here is a stray.
> +strays=3D$(cat $C/mon_groups/n*/tasks 2>/dev/null | wc -l)
> +echo "tasks in new monitor groups (expect none): $strays"
> +if [ "$strays" -gt 0 ]; then
> +	grep -l . $C/mon_groups/n*/tasks        # which group holds them
> +	echo "RESULT: $strays stray task(s) kept the removed group's RMID"
> +	exit 0
> +fi
> +
> +case $err in
> +*"No space left"*)
> +	echo "RESULT: no stray this run, run again"
> +	exit 0 ;;
> +esac

[Severity: Low]
Does matching $err against "No space left" fail under non-English locales?
Without LC_ALL=3DC, mkdir prints a localized strerror(ENOSPC) message and t=
he
script falls through to the inconclusive result even when the RMID pool was
exhausted.

> +
> +# Not ENOSPC: the pool was never full, so the freed RMID was not reused =
and a
> +# stray cannot be seen in this run.
> +echo "RESULT: INCONCLUSIVE, the freed RMID was never reused (${err##*: }=
)"

[Severity: Medium]
Should the exit codes follow kselftest conventions?

When stray tasks are found ($strays -gt 0) or the run is inconclusive at
the end of the script, exiting with 0 makes automated runners treat a
reproduced bug or an inconclusive run as a pass.  Conversely, the
prerequisite checks at the top (root, resctrl mounted, and llc_occupancy
disabled) exit with 1 instead of the kselftest skip code 4 (ksft_skip=3D4).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795197419.gi=
t.reinette.chatre@intel.com?part=3D3

