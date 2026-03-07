Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06BA2F55104
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 21:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886476B0088; Sat,  7 Mar 2026 16:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 834626B0089; Sat,  7 Mar 2026 16:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76AD86B008A; Sat,  7 Mar 2026 16:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63B126B0088
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 16:02:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1999139A35
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 21:02:56 +0000 (UTC)
X-FDA: 84520491552.19.1616097
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 57FF41C000A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 21:02:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G346BLJB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772917375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ADZnWRLJX41HbimiAWc46WsaMJOcnmyZ3Uu/7VibJtQ=;
	b=vfNN2mf7EGlLzxISdTN5FrEXYHy93snXgbjzY9kLo+U6UBBxXbWgiXTU8h0X9tJsmZyYcs
	h5Y3oFU0+d8pUNpzGiBg+Bz4+4VN6DLITxYxMpTeD0aX4T4Lvw8iuHlwjV3Rq4N9SUCMpI
	0O/ppMNdWI+W+nrG5TyMx6QSZJ8zFqI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G346BLJB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772917375; a=rsa-sha256;
	cv=none;
	b=vYJ4Zx0KdmGxkA0J4ebQYxd16aX9D13yxEbCYLWNYYk+vU/OEcQUAi8/PaaUVK5szDa5kt
	HdSxho9u0cmbI6+nS6VfZOl9zOd89HsWu3hfTrolJhUB/zJDeW2PiXJMMsXsoGu0dPR+fH
	qPhWP7oRDOm+4CPFiYShiqWTYEkEyjo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B944A60051;
	Sat,  7 Mar 2026 21:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B188C19422;
	Sat,  7 Mar 2026 21:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772917374;
	bh=U9kK/VbZNvIYMl23ToOaVPKCak2t7IyWptoDNzgEeDU=;
	h=From:To:Cc:Subject:Date:From;
	b=G346BLJBP6m8uwFhjscFYwSKaSVOU/EWK/dMAADEQ+jCKjY8xm9RaxOLyIjh78noL
	 JR25BgKuE5VnpxSTT4/ubb0psd0RB+1Xgl2Yos8AfIePNoZr8SvbSNP6RvixAsG0tL
	 JFJNjiu1E94u5Dve9RfGz4taCwOnnasXXTDPj/LOTSv8cEILyBEYafKHk7+dCmNxSj
	 tZJiBJdAvVWbjCnD5O5VvVypN6hIzlaY1uqw1BdGvfm34pVRmlxBwQKXIuI/PVLyc9
	 uHiZlFAamtzeJyjpne4U0sBrOZSEcfrKM92ZU5F8qkNmUTMhE/Q53roMViId3I6z0U
	 1A/IKnSnYkB/g==
From: SeongJae Park <sj@kernel.org>
To: lsf-pc@lists.linux-foundation.org
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [LSF/MM/BPF TOPIC] DAMON Updates: Tiering, Pagel Level Monitoring and DAMON-X
Date: Sat,  7 Mar 2026 13:02:48 -0800
Message-ID: <20260307210250.204245-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 57FF41C000A
X-Stat-Signature: warrbguyfj4fs1f9ne3ynrbk36uhr4xx
X-Rspam-User: 
X-HE-Tag: 1772917375-94629
X-HE-Meta: U2FsdGVkX1+OJW5tpbPDKNda2j4qMaP0K8LV9cE11C/raQ23T3uq6WRH39yLnVKGAb/aRelvN/IBeOptGJo/Z7g8c0HcWXd7RRrdmoZ5oDf+zqbngE8fuDk3wPXQBlZ4fW5punZIjJDilFTadDtNgE7WXOQwKgchEqIkrLWj6BEOhEkKp9ekveYYVdT5mzhDUjLMrLFxHuUXiR9Hl+Kkve+AXpPB0o46jgA+1+sKgsNVUdYKnpq2PY/jrIxaODyFzThjJzHQ7fYHqWKWaCtPYLGDzoZ2TZws6DiNKIyFpWCFj/Y2e3WqJwn7gbLK++QgBOjQfujP/AVcmJ33jOW+Owy7pOfkjnd/ra+/FQBi3FmY/rFVZl6uK7ESeINupmruLPDIERM+0UWbcZKYgisjYvFEZmltsv4OSYeVWFIUOW9cdxgQnmfv5M54dPa4KVMnD09wFCyRCSs7sweudsQjSWIp0ytzJHnZAkfn1qh9uSQjM28tRk615UmRFlPv+a2aZ/GBl+JZ3NjDmWSSEJHPV7jsgqBkA8UnPaSZ0VCjp+shGceg4gVghyqz6SYfCpCAshDYwnJYnQeek5nzt3/QaHrXl9XCib1MliQNTX6AnP30nYKOH9SLcIazgxPExukpLeeTBnjSboJwqzkDg+nDirAc+2MGqv6lvPDhEDUT/qeVUYISvilyU8fo9xLA4RqZ/ms62tkZA8BeB9TojINwJRh6tG/RXMiloENN48TZcyUMj4NefTsfSu1fA/+bmaLCV4PvS4HASnmTDv8H55ZjKHSLrzbqkE3+Kstzm3b8qRteGgo8IOEvBpYT7TEb/dRlMGBIKqaCLb0I51k6vf4oEGlJvkQIllLyQsWKRQrUfEFWdpEXgmk9hzKtKt1DG126WFz6HySGUSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,


In the last year LSF/MM/BPF, I shared [1] updates of the status and future
plans on DAMON development.  Feedbacks were very helpful.  I'd like to share
new updates and gather more feedback on LSF/MM/BPF 2026.

Major topics to discuss in the session include but not limited to below three
topics.  Of course, some changes could be made.

Followups on work items that we discussed on last LSF/MM/BPF
------------------------------------------------------------

DAMOS auto-tuning based memory tiering.  I worked on a more flexible evaluation
setup for it.  I also upstreamed another DAMON extension that makes memory
cgroup-aware memory tiering available.  An unnamed user confirmed positive test
results of the auto-tuning based tiering.  Meanwhile other users including
people from SK hynix and Micron are continuing development of their own memory
tiering approaches and showing good achievements.  Because basic evaluation of
my approach is done, I'm not actively working on this now, but working in a
support mode for this.  I will share more details about this and discuss if
something need to be revisited or if there are anything that DAMON can help for
memory tiering.

Page level monitoring.  The feature, which accounts the number of pages in each
DAMON region of user-interested type (e.g., hugepage, LRU list-position,
belonging cgroup) has successfully upstreamed after the LSF/MM/BPF 2025.
Because it imposes high overhead on large systems, a lightweight version of it
was shared as a future work.  Unfortunately not much visible progress for it
has been made so far.  Some progress on the design is made, though.  Briefly
speaking, the idea is sampling the types of pages in each DAMON region.
Implementation wise, users will be able to set the types of their interests,
and DAMON will provide the counts of the samples of the interested types, in
addition to the access frequency counter (nr_accesses). I'd like to share the
design and get feedback.  Hopefully RFC ideas or patch series will be shared
before the conference to help discussions.

FYI, in future, the counters of interests could be extended to do the DAMON
region merge/split based on not only access frequency but one of the
user-defined interests.  Then DAMON might pivot from Data Access MONitor to
Data Associativity MONitor.  It’s just somewhat possible and sounds funny for
now.  I find no real use case of that.

New Project
-----------

DAMON-X.  In Crusoe, which is a neocloud company that I’m now working for, we
want to utilize DAMON for both memory efficiency and observability.  More
specifically, we want to show the memory idle time percentiles, and run memory
PSI-driven proactive memory reclamation.  The straightforward way would be
doing that via DAMON sysfs interface, or DAMON user-space tool.  It requires
some user-space programming, though.  I want the kernel to just work.  A way
for that would be running DAMON modules that were developed for the purposes,
namely DAMON_STAT and DASMON_RECLAIM.  But DAMON modules run in an exclusive
manner, so we cannot run those in parallel.  The exclusiveness is required to
avoid interference between DAMON worker threads (kdamond) for different
modules.

I plan to let DAMON modules share kdamonds to let them run in parallel without
interference.  The shared kdamond would be able to run on the system from the
beginning or on demand, and directly attach/detach DAMON applications like
DAMON_STAT, DAMON_RECLAIM, and future ones for NUMA-aware page migrations etc.
It will work with a very minimum number of knobs in nearly automated way, but I
plan to also extend the DAMON sysfs interface for more flexible and manual
control of it for experiments and investigations.  With my humble naming sense,
I’m currently calling it "DAMON Enabled Computer System", or DAMON-X in short.
Actually this is a followup of what I shared in LPC 2024 kernel mm
micro-conference, as a long-term DAMON project for the kernel that just works.
I want to share Crusoe's desired use case, problems, and design of the
currently planned solution during the session and get feedback.  Hopefully RFC
ideas or patch series will be shared before the conference to help discussions.

More Topics Out of This Session
-------------------------------

There are two more DAMON-related development works that are ongoing, that I
want to discuss in LSF/MM/BPF.  Because I think those cannot be discussed in
single session with the above three topics due to the limit of the time, I
proposed separate sessions for them.  The two topics are "production level
access-aware THP [3]" and "per-CPUs/threads/reads/writes data access monitoring
[4]".



[1] https://lore.kernel.org/all/20250102222317.48760-1-sj@kernel.org/
[2] https://lpc.events/event/18/contributions/1768/
[3] https://lore.kernel.org/20260211050729.69719-1-sj@kernel.org
[4] https://lore.kernel.org/20260218054320.4570-1-sj@kernel.org


Thanks,
SJ

