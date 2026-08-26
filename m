Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196E2C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF39B6B0088; Tue, 25 Aug 2026 22:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7D336B008A; Tue, 25 Aug 2026 22:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44E56B008C; Tue, 25 Aug 2026 22:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFC96B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:18:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E1B61201FC
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:24 +0000 (UTC)
X-FDA: 85141811328.27.FE8E1AB
Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59960180003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fe38BSaU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787710702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zhuvu/VLx0Tiw5QzgGUdxl5yD8KaJ15jhPtsGDvmbKc=;
	b=1oCUy/l+ylc5snk599laqsX56Kbokof92Ipz95qhcd+qGpiaXObLIfB/m8EBhxwU8KMj5B
	QlVi/K6WfCVH8vTiwFBN1E4tJQz0ksxS5sZ9GGqLe3mbGk5R0PDz8X/vukWuelg8qoA+lK
	6iS5EOI8yz5ULVxe2SyiMlkjhbfBW7Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fe38BSaU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787710702;
	b=OU/udyj30tRpqrbjIZzmb/RK2f8xM0MCXrRYm8jADqgpYFKKTucOViAMd+3ZkncAm+8kRp
	U4X7DSdS2MresnD4cFnIjq4qIgSv3vWc6tPwwvdV/bTFx56qMSsPww+Hw9fDeMfqIXRrFe
	AtrfVJ0M55VI8SSiZdIQAG6LolLQI2g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=t/05Fp8KvIdQ3wJax8e4wYX6B2lpmgVrEQ6lnlSI1GY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787710700; v=1; x=1788315500;
 b=fe38BSaUQDBavAjpQIFCgpdHyzLYDhM0INhYqF3yOODfNB9x/Cjk7eOEyjzpl7068Xr9Gx0e
 6P1vm6mdzF6qvze919ms5gMoPIsl10JWwGJmatxfiIGHTUKCW15OkyXwa66+QRORLEM0AqFcm7b
 r6bvXtPBePFcCDiKhkvlTYI8=
X-Envelope-To: linux-mm@kvack.org
Received: from ctao-book.. (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 376f8c39feeeb18b;
	Wed, 26 Aug 2026 02:18:10 +0000
X-Mizu-Trace-ID: 376f8c39feeeb18b
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	akpm@linux-foundation.org,
	shakeel.butt@linux.dev,
	mhocko@suse.com
Cc: mhocko@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v2] docs: cgroup: document empty-write behavior of memory limit knobs
Date: Wed, 26 Aug 2026 10:17:53 +0800
Message-ID: <20260826021753.197871-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1ss3nmfuy91wqubcz8ta558iog9nhx6a
X-Rspamd-Queue-Id: 59960180003
X-HE-Tag: 1787710702-101663
X-HE-Meta: U2FsdGVkX19IuL7e7+hMGoW4blamAQ1A9ue76sdTZgyVkHoZmgh301ItHpRNbfjKwqX1c/1D9Kr0rlQ7tXYH8baVlHVSGb3K1M70Y3Hgl7Y1Su5DhIg+tGpMFDa6FS+ekR4W7LGH2Rg1izNXi+UDbSbkX9+eXXJfip0W/Wi+ho4ynPbYnnwGNz6drKcIe9Ksaoo98f92BI5IJ6/HtHJXjLR6mBmd0y6EZZvTpaNoKySieIVV34xjnkLN7dGEQZjPLL1iMY/TOmXFLCLDGr5oVMYdBpcSffUi/4ZQuekEBTRDE6tC66bxrDhUEAEa/oLHC3w38+BJI5UqFLeB4EmsNN/dJH60qjBexcryuOAIEVtWjqZ2uF4II69niWVjs3swU4la56Lo4anaZC0QFYa0vshIKABnPjjMifkV8fASNwqK9vn3PB25lvJ1z9FWQ6cGlBEQfvLoMhmi+MyzFcwFJMmJtL0V2KD0OuPxdGUItNAV8L6PpjS9U4dOOAoM3wumcKq2pYF7jCJLwSkWlnXUZjwUBpe4cQkxt6NAbmcJZm2LRke//96gHPJQlum7BEOSf0HOwyXfu/aDwiwixdoFTx82cjPCIxUFddfG0i8HO7Fu1qs0kPrOcuMgqLsSekuPVD6TkTtPAAR2a53BgEXHFVlSusoZW4U+XfPp36SIxviul4xCMJVIalpwA7vKsUzdQS6hRNArBKd7xR3DihygBQaiHdqM3XXBHA9kTvhLpfoFiw4E7s5z2jW9KXgW4rb2OXVSuJvjSic2/2UfAkLQ7JFRt4Syj1o83OdrpgdHOEJgxOp+EDr0u5XuWVt/q35RVydViQfTr6NBNv41lX7/l7euP3Xvy/QZdg2sYO7mwi8sbhNKNXQnuItK1mXupx3pzL6Du6P0sEmBdCU/5E/ZOAUPDx5Feh5FC0kmi/yfiKede1kRdiOzfFgBhUZxvmC73pHw0fFhlfaoV7Y1iov
 zS9QzdNv
 xBcaCrv0gfaZna8ySHHvTJ4ka6pb9CXyKfl2KlBruL7aBRMBNEJEexQuI4AUO337xbddd3Us0p5x9kqh/T+n8tGXm/78koHc4IoYCvQnoiXy5r8HJtEUuO415HVKqctLZ0zqyENzFTPcVDIeYgMPZct4ICkmWKQE10FdZpgrEo+Ku5lL7c37LH5UFH1VYPf8msR1xgOKu/3V31Ca9sEADmyuGCY0HCwgUrZUSpUHrA8pU1WpFwK2c/8TLElzpbuhWzn6N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tao Cui <cuitao@kylinos.cn>

A maintenance script on a cluster wrote an unset variable into
memory.max of a workload cgroup; the variable expanded to an empty
string, the write succeeded, and the workload in the cgroup was
OOM-killed.  Nothing pointed back at the write, so it took quite
some time to trace the OOM kills to that script.

The memory controller documentation does not say what an empty
write does; the cpuset controller documents its empty-value
semantics.  The actual behavior is that the empty string is
accepted as 0.  Reproduced on a k8s cluster (v1.29, cgroup v2,
two-container pod, 384M limit):

  # LIMIT=
  # echo "$LIMIT" > $CG/memory.max
  # echo $?
  0

  m6demo   0/2     OOMKilled   0

  Memory cgroup out of memory: Killed process 339529 (sleep) ... anon-rss:32kB

State it where the interface files are introduced, alongside the
existing notes on units and page rounding.

Link: https://lore.kernel.org/all/aoVUlFdZYLFn_gvJ@tiehlicka/
Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---

Changes since v1: document the empty-write behavior instead of
rejecting it, the outcome of the review discussion at the Link:
below.

---
 Documentation/admin-guide/cgroup-v2.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 86a2a0099178..8d2603751c51 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1321,6 +1321,10 @@ All memory amounts are in bytes.  If a value which is not aligned to
 PAGE_SIZE is written, the value may be rounded up to the closest
 PAGE_SIZE multiple when read back.
 
+For the limit files described below, an empty or all-whitespace
+write is accepted and sets the limit to 0.  To disable a limit,
+write "max"; to set it to zero explicitly, write "0".
+
   memory.current
 	A read-only single value file which exists on non-root
 	cgroups.
-- 
2.43.0


