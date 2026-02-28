Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D58FEE4F7
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 19:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BA56B0005; Sat, 28 Feb 2026 14:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9896B0089; Sat, 28 Feb 2026 14:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8046B008A; Sat, 28 Feb 2026 14:48:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1793B6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:48:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6242C119C
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:48:17 +0000 (UTC)
X-FDA: 84494901834.21.D6D0CBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2335640005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:48:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C0iDGAR7;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772308096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Jyi7kGSHLSyk5ifLeqQxljB4+bEytiYd2X7NTGXFnZI=;
	b=A1bRPGpQEMUQ8Z3uhMQaDoUmD8SnHjzmEqTkIIG+c/DcYddd/HTsWl4AOHg4m5CLqEuTGd
	Lwuqc4oZ/BU0SVLyFk/pPBlO7pd8jwr0VODvf295foVg7sEgDePNnrhqtz/lsISa0/fuVN
	1ModIperRsAC7e+3UjhL9S+d8RNtUGk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C0iDGAR7;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772308096; a=rsa-sha256;
	cv=none;
	b=Ow48Ehftffjt2FujwFInF4YWUXxDEI1YyoH0BZ4ZRVSuZvKku32suLGoC9F/8oYEvf2Jqf
	T2rxH/AaWDzKZjUFUOlitS5amHbg2q+P8DDjcdcebwpUPdmQ+6Gs+REHv+WutOldFXD3Aw
	fP0c4FYfgx+8lWTPWcFjHLK5WNygZsM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AAD460008
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8C8C116D0;
	Sat, 28 Feb 2026 19:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772308095;
	bh=kKwP5TvGMLK3hpwL7ErLXfmb6F8FsTV5dCMX7DdiB3k=;
	h=From:To:Cc:Subject:Date:From;
	b=C0iDGAR7eWLKvPNsFwWexDEonJQJRh50W3bmQlHxuv7o8K39lmVIGVmGYfHhq7RtS
	 15+rhhhiSqhRYA61EtHHH/No3yajwW32LGZdpj22uDDGukQarqXGrQLxOJ+f4cSn80
	 6irunRMynuFhzOqrncqemcLMk+o73IkSTU5jF5cHRCf1O2LZbNQwScdjU/HkI+7wYd
	 AKwuSmyUJZRUKAhg7ll6tnjnE+EwVZjtzwdHYYiaQnwtZzlb87NE51m6MhQna3UEtI
	 JFn1hcrfzfuaeRVPDod1u1bzIeP+U8nZ/L0bsgyY7VPhZUkpPGZ1nWlh5N1NHaARdW
	 Yxvna/LV1UA5A==
From: SeongJae Park <sj@kernel.org>
To: damon@lists.linux.dev
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: DAMON Release News (v6.19-rc1..v7.0-rc1)
Date: Sat, 28 Feb 2026 11:48:04 -0800
Message-ID: <20260228194805.97228-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2335640005
X-Rspamd-Server: rspam08
X-Stat-Signature: x7dwgfjzujs897d3dnef7eqww51k1d5t
X-HE-Tag: 1772308095-778342
X-HE-Meta: U2FsdGVkX1/XZOvrEyFK1AWoe3wYBQd3dXnGetmg5XuqX4J4aSzpEiT8v2urnClJ4WGzrmDwYovn0esbzlvLQNn0ziFSUc5W2hEtxerMGQIFTjGvInWGOZctK7n81nS+XPvrW8B81PH8kbhPMItxQrt4sFGG1kOSt9bAJN8fWL662nlJUstJ3fFgz8NkimvKsjlEMTe0+o+zmr7Xno0jv0L8YaJjdfyu9tgZ3/IvR4zQ/Uv+63agqVLpl+FMtdW36CHLeUheyjpx4gCas25TvCbMuVUM5MqLZ7RopBhzHNapp2lfdNC1WfiaJozmbngb6HbKME1YF6Uyaox/m4kau1jgquNyOXTVX2TLVBy99P5Q/2iXms6jwr78CCSNDRY6iqgcSP9um3IHzx7vbf6s9ymMNHE/no4tHSib+v3j6w9Vvtb//ZG5T3OSajeX4dAX5+ziHnkDMH3pikQxrlO5VC0i3m48B+WGe1Dlq7AikWTpQh3IBkUARfrTp1le2XXsLXajMnBcGO4RK+ob1Ss3FG0OqfIe6BEwD2oNoQZRJICl/L0XrhN/Dd1NkI+6nPGuFm3NQfX2bAjvLqaybyclfRwh0BALBGRvgSWwvu701PcxR6DK8tUdFq/XPai5JdEwh/Rk4b/nQljYIr/JRYp71LGmK0E0q21gH2a7IkQAdGCfw3fYYSCfnrWK3TYQx+7PIm29TlZYQahCBF45IedhtRyBWqwpcxewUjgIW+Sv4ODx3KcjxTlRXP4Z48h++wePZjn5EnyWukEO9QLoq1APUZE+MXDCV6EBBXdM8s++njXKU8twezKwxUKfx9YLC+QRu0Uj1RoESBirUQAVLc/AaLNehOBX9HSh0JLcEioaKCLjF52/xQYuOyXogTbY/9RSBVSG4p4iheGlq2/1ynDp3YE0VRc5XLYPBApRIfoTT9LHLwH4JUVL+owd8vhlp4kieIbAEssM44ye888yMrb
 WtHFAcl9
 eUmomsmD3m0IY//R4MdaM46jb/4nubMSQiIEjNDyQVO3yMnKPAeJrUViReK8heuRUcYZPeBEdXwXWG01DEJLiHqKiAsPUPxOBZRCkUV3tMe6kOvrkNakRxcbMLi0trwY7hRb+IRQX8JB/cSgegsjY2eFA4J0F1zyqNiDIId6vzTPzklGhMbdnsndUdw/rrf9U3ZkAYqnXZ7jqXdSy1mSQX78yPwsSo6N9HkGdnUD/8NhVncbT5hcTb8J/Dl/OiyNu5HXD0IaXqUnAl4wqVaZN6R3v78EsOQSKhFZ4WYLA26g3mVF0tU2EJGMENwvvdK69IpxLfJP8oVDPPFt4+RReBAlH61HOFNGAXCPnIBKtLligWaG79bdgjfPZkgt7h44Z/TZYiaVtTkbJv8mQ4peiSzX95ggEkVdmfwIBGr04kGZx+38nlhyWOF4kdXQMr9GZQWZNZnn01Ov7MeHyi6gf4hfAR6UtsqdSX9qklWXmle8bw41Xyvx8hj0Z+thZsNJktyEDv2Cp9DWx/TDAtSj2/URd9ibcvWtwYlEbgIITRO1E8wofrIcUBKomWm2Z2hTl2PaU83OwonqFCZZPzz/Xwz48aqK+DLaFL2awiPrJfbzMSlws9nqfV6nXuWCRAPB0WOPwL88YvS+BF9/eUlZVXeXNrSyBDcMDYxfnPFW3TTVh3uZX0ueGFy0n07gC+yIhCaNrLZAGoFgVHAYf8Z2K7Ds4+I0g42bqzhX0vjbkgSCoj7goeueyPKo+5vGdaAHMDlDCZzWWuyf5+A5H5CDIjF2VCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello community,


I shared DAMON quarterly news [1, 2, 3, 4] in 2024.  I was further planning to
write that for 2025 Q1.  But I dropped the ball and never finished it.  I'm
starting a new series of DAMON news, that aims to cover each -rc1 release.

This news letter covers DAMON features that landed on the mainline, and misc
events that were interesting to me that happened in v6.19-rc1..v7.0-rc1 time
period (2025-12-14..2026-02-22).

TL; DR
======

Interesting DAMON development ideas including PMU-based extension, automated
THP application, and new DAMOS quota auto-tune metrics for CXL-based tiered
memory systems have been proposed.

Two DAMON topics for LSF/MM/BPF are proposed.

In the time period, 12 grateful contributors landed 75 commits on the linux
mainline.

Notable Events
==============

In the time period, many events happened.  Among those, I think below events
are worthy to be noted here.

Release
-------

Seven DAMON hotfixes have landed on 6.19.

    $ git log v6.19-rc1..v6.19 --oneline -- mm/damon include/linux/damon.h \
            Documentation/mm/damon/ Documentation/admin-guide/mm/damon/ \
    	include/trace/events/damon.h samples/damon/ \
    	tools/testing/selftests/damon | wc -l
    7

Sixty six DAMON changes have landed on 7.0-rc1 during the merge window.

    $ git log v6.19..v7.0-rc1 --oneline -- mm/damon include/linux/damon.h \
            Documentation/mm/damon/ Documentation/admin-guide/mm/damon/ \
    	include/trace/events/damon.h samples/damon/ \
    	tools/testing/selftests/damon | wc -l
    66

Read below 'Changes Landed On ...' sections for more details of the changes
including user-visible ones (mostly new features).

New and Ongoing Developments
----------------------------

Enze Li proposed [5] to make DAMON supports loadable modules.  Because of the
lack of the real use case, it is on hold for now.

Asier proposed [6] a new DAMON module that finds hot processes and applies THP
to hot pages of the processes.  We are aligned on the high level approach,
though details might need some changes.  Asier is further working on tests.

Akinobu Mita proposed [7] PMU-based access check.  It could allow sub-page
level access monitoring and more interesting expansions of DAMON, such as
per-CPUs/processes/reads/writes monitoring.  It may be restrictive for virtual
machines, though.  Akinobu is looking at rebasing it on my page faults-based
similar extension RFC code.

Ravi Jonnalagadda proposed [8] new DAMOS quota goal metrics for weights-based
pages promotion and demotion on CXL-based tiered memory systems.  After a few
revisioning, I think we are now quite aligned on the direction of the change.
Ravi continues working on it, with tests.

LSF/MM/BPF
----------

DAMON is picked [9] as one of Linux kernel machine learning library
demonstration use cases.  DAMON community promised any collaborations for that
on demand.

Two DAMON-related LSF/MM/BPF topics are suggested.  The first one [10] aims to
discuss possible DAMON usage for THP, on production level.  It will share past
DAMON-based THP improvement works and why it was inappropriate on product
environments.  Further, it will brainstorm better approaches.  Asier's work may
also be discussed.

The second one [11] aims to make alignment on required DAMON-external changes
for page faults based per-CPUs/threads/reads/writes DAMON monitoring extension.
The very initial extension attempt was started from nearly the very beginning
of DAMON, and I continued it from last summer.  Hopefully it will make more
progress or happily fail early.

Misc
----

DAMON user-space tool (damo) started supporting trace-cmd [12], making use of
it on Android much easier.  It also started supporting command line
auto-completion [13].

DAMON development yearly retrospects for 2024 [14] and 2025 [15] are also
finally posted.

Statistics
==========

In the time period, 12 people made 75 grateful DAMON commits on the Linux
mainline.  The script is availabe at my GitHub toolbox repo [16].

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --since 2025-12-14 --until 2026-02-22
    1. SeongJae Park <sj@kernel.org>: 54 commits
    2. Shu Anzai <shu17az@gmail.com>: 5 commits
    3. Enze Li <lienze@kylinos.cn>: 3 commits
    4. Shakeel Butt <shakeel.butt@linux.dev>: 3 commits
    5. Kees Cook <kees@kernel.org>: 2 commits
    6. Linus Torvalds <torvalds@linux-foundation.org>: 2 commits
    7. Li RongQing <lirongqing@baidu.com>: 1 commits
    8. Aaron Yang <yangqixiao@inspur.com>: 1 commits
    9. Kevin Lourenco <klourencodev@gmail.com>: 1 commits
    10. JaeJoon Jung <rgbi3307@gmail.com>: 1 commits
    11. Swaraj Gaikwad <swarajgaikwad1925@gmail.com>: 1 commits
    12. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    # 12 authors, 75 commits in total

DAMON user-space tool also got grateful changes.

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2025-12-14 --until 2026-02-22
    1. SeongJae Park <sj@kernel.org>: 335 commits
    2. Andrew Paniakin <apanyaki@amazon.com>: 2 commits
    # 2 authors, 337 commits in total

According to 'hkml' [20], DAMON mailing list received 440 mails of 111 threads.
77 threads were newly initiated.  Among the mails, 223 mails were for patches.
It included 43 series.

    $ hkml list damon --alias tmp --since v6.19-rc1 --until v7.0-rc1 --collapse --stdout --stat_only
    # (cached output)
    # 440 mails, 111 threads, 72 new threads
    # 223 patches, 43 series
    # oldest: 2025-12-11 04:56:14-08:00
    # newest: 2026-02-22 13:01:01-08:00

Huge appreciation to all the great contributors!

Changes landed on v6.19
=======================

All DAMON changes that landed on v6.19-rc1 via MM pull requests [17, 18] are
successfully landed on v6.19.

User-visible Changes
--------------------

Among the changes, below two new features are notable.

    commit adf7d6cdd716e: Patch series "mm/damon: support pin-point targets removal".
    commit d3946c5f4c1c5: Patch series "mm/damon: allow DAMOS auto-tuned for per-memcg per-node memory usage."

The first feature allows more efficient and flexible use of DAMON and DAMOS for
dynamic list of virtual address spaces.  It was motivated by Bijan's dynamic
access-aware memory interleaving on CXL-based memory tiering work.

The second feature is for general per-memcg per-node memory utilization based
automatic access-aware system operations.  The motivation was per-cgroup
fairness on memory tiering use case.

User-invisible Changes
----------------------

Below non-feature changes that made for more reliable and complete DAMON tests
are also notable.  The kunit tests memory bugs fix is now on all relevant
stable kernels.

    commit b5ab490d85b77: Patch series "mm/damon/tests: fix memory bugs in kunit tests".
    commit e859a224fad65: Patch series "mm/damon: fixes for address alignment issues in DAMON_LRU_SORT and DAMON_RECLAIM".
    commit 37104286f9390: Patch series "mm/damon/tests: add more tests for online parameters commit".

Changes landed on v7.0-rc1
==========================

During the 7.0-rc1 merge window, 66 DAMON patches have landed via the MM pull
request [19].

User-visible Changes
--------------------

In the merge window, below user-visible new features are added.

    commit 4835e2871321f: Patch series "mm/damon: advance DAMOS-based LRU sorting".
    commit 4a6ceb7c9744c: Patch series "mm/damon: introduce {,max_}nr_snapshots and tracepoint for damos stats".

The first series advances DAMON_LRU_SORT module, which protects hot LRU pages,
to be easier to control.  Support of active:inactive list size based automation
and DAMON monitoring intervals automation are especially notable.

The second series allows more deterministic control and internal behavior
observabilities for DAMOS.  The development was motivated by Ravi's dynamic
page interleaving latency/capacity improvement-aimed CXL memory tiering
approach.

User-invisible Changes
----------------------

Also important changes for DAMON tests improvement, API/code code refactoring,
and documentation cleanup were landed, including below series.

    commit 94a62284ede02: Patch series "selftests/damon: improve leak detection and wss estimation reliability."
    commit 6c59085fc0942: Patch series "mm/damon/tests/core-kunit: extend existing test scenarios",
    commit 4262c53236977: Patch series "mm/damon: hide kdamond and kdamond_lock from API callers".
    commit 50962b16c0d63: Patch series "mm/damon: cleanup kdamond, damon_call(), damos filter and DAMON_MIN_REGION."
    commit 32d11b3208971: Patch series "Docs/mm/damon: update intro, modules, maintainer profile, and misc."

References
==========

[1] 2024 Q1 news: https://lore.kernel.org//20240402191224.92305-1-sj@kernel.org/
[2] 2024 Q2 news: https://lore.kernel.org/20241001002449.515043-1-sj@kernel.org/
[3] 2024 Q3 news: https://lore.kernel.org/20241001191425.588219-1-sj@kernel.org/
[4] 2024 Q4 news: https://lore.kernel.org/20250102211811.48322-1-sj@kernel.org/
[5] loadable module support: https://lore.kernel.org/20251215142057.588500-1-lienze@kylinos.cn
[6] THP-ing hot processes: https://lore.kernel.org/20260202145650.1795854-1-gutierrez.asier@huawei-partners.com
[7] perf event based access check: https://lore.kernel.org/20260123021014.26915-1-akinobu.mita@gmail.com
[8] node_target_[in]eligible_mem_bp: https://lore.kernel.org/20260123045733.6954-1-ravis.opensrc@gmail.com
[9] ML library: https://lore.kernel.org/all/c24a209d5a4af0c4cc08f30098998ce16c668b58.camel@ibm.com/
[10] DAMON for THP, LSFMMBPF: https://lore.kernel.org/all/20260211022845.68865-1-sj@kernel.org/
[11] DAMON for faults, LSFMMBPF: https://lore.kernel.org/all/20260218054320.4570-1-sj@kernel.org/
[12] damo trace-cmd support: https://damonitor.github.io/posts/damo_support_trace_cmd/
[13] damo cli auto-completion: https://github.com/damonitor/damo/blob/next/USAGE.md#command-line-auto-completion
[14] DAMON yearly restrospects, 2024: https://lore.kernel.org/all/20260216210625.68098-1-sj@kernel.org/
[15] DAMON yearly retrospects, 2025: https://lore.kernel.org/all/20260222210102.153347-1-sj@kernel.org/
[16] https://github.com/sjp38/lazybox/blob/master/version_control/authors.py
[17] 6.19-rc1 mm pr 1/2: https://lore.kernel.org/20251203212918.82f1c9d3947940aeae263878@linux-foundation.org/
[18] 6.19-rc1 mm pr 2/2: https://lore.kernel.org/20251211131127.defed99e5b82e49af605108a@linux-foundation.org/
[19] 7.0-rc1 mm pr: https://lore.kernel.org/20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org/
[20] https://docs.kernel.org/process/email-clients.html#hackermail-tui


Thanks,
SJ

