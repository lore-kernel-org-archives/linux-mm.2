Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D81FEE4EF
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 14:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02096B0005; Sat, 28 Feb 2026 09:20:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB92E6B0088; Sat, 28 Feb 2026 09:20:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE24B6B0089; Sat, 28 Feb 2026 09:20:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE8326B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:20:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DFDC5787D
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:20:41 +0000 (UTC)
X-FDA: 84494076282.10.BDEFF4B
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id 977B7100002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:20:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f5tGin5i;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772288440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ploXD4qKyGErpi2h+6GFoldO2iGJIFZ6IgaMbXbP9Uw=;
	b=ZO4fwnrduc/NB5an5MEAgJO1P/OiDjWFwQ7C8K8wSHsvOHyE1ONQ++1RVDy6K4UK9NTkBV
	9s8aPJklsCyPkN5uHZ18SS6DOLKGrvmbvvJAwNFJBulaX5PJ3jfGKSETz+6kxgilKrbfo4
	9/bzFtV2RRAC14UOYA1CO9YjbBhxDug=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f5tGin5i;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772288440; a=rsa-sha256;
	cv=none;
	b=S3OfdYJ0IxNPZS8mjjKScsuXKhque5svDpFzuHlhANP/eioB6obkJ8XVZ6FcDZ69KNJnXT
	WoBYwVU5Clfgv4XbE9StCDC4hLh7all4ieH2RnBL9+ZLarn5aZadEX2H6BA6ucddMuTSja
	sMI/K+XIU3s/x6tlS7Uk9vHjfPeU3ak=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772288437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ploXD4qKyGErpi2h+6GFoldO2iGJIFZ6IgaMbXbP9Uw=;
	b=f5tGin5iSOmhU2iID2/zFOti5Z8DzbJC7ulhLGGryEYrVJ++a2+qy9DKv3a8kQy4Q2iYVs
	KtKhbGs8LIa3HSygX7IhUZK2Cva97yzJo4GguhIbLbtG/zA5s3+Vt5Q+IN+FrwN2ljAvBS
	CbREK2Lrc78F+xacxiniKL0yMMXXEfQ=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Daniel Sedlak <daniel.sedlak@cdn77.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cgroup: improve cgroup_file_notify() scalability
Date: Sat, 28 Feb 2026 06:20:15 -0800
Message-ID: <20260228142018.3178529-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 977B7100002
X-Stat-Signature: bzg4kirkdf3t4hh65iqo8dfje3qbxifz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772288439-209016
X-HE-Meta: U2FsdGVkX1+SlcjG9QYLDzM8V7ep3B5g4SCQptQOLOyo/+cdfTJCsIpbR7fmfsUx9ytADeW3dREUNO89jsZ/LeNlsMzJ1cQ6Bfhqicbu/T21NmWyADgAF8WWdr/iN6BvbNaVSbqbmShDNeWW17/YDfhRTdpjpZ27KZmnJuVfMd0oWibxtpo1CHEgQuOgurqQImI6C4vXc0I5C3Ffj2fcaWsEQ/xnEMU9QkxPwTmqOrTDyiDkO8dNyzK1ZeTmuz2ckKYW4zYytYOqT/u3O2G6u3A28j2qGgYGA8dT+lWXYCCkNBP4FyA3z7GvU8d2ROj2RjhF5Dok7MZtxI0isMuOwSCfZfQ8Qcfv5APts9uyk72WQIfUEtii443CtQ2uFxoKVC1cymeioauN31s/Wu5VAzhQKP3f2QqdQAuu2hAjxW8ciKa6DkFsEpYug+VS5hLOtY3Ty3ZbTohqu+utkyoSIdIXMxBPSkAaB2PT3WxzSb2M99QCrWGuhMJQDds+1SyLCFI/GScHbKMOX4lXO1Kd4Od1ayfjn/gLJ6vNPGE0TcbIAWNs7W0lmkt5E45MVnEdaApd231qErqcrHhJFQsukwfJfNYQgZ0t9wX6HPiwIgOXDCuhbxAOZ5ktTGLSBT3NoXVZc9YMT4sEQe8IbtXUb33DspS7kJwSe4841QNcU5YEIYkaFi8jR0X1BleMxsG8xHduL59ooNHKznKF/5RMbtiO/aXqAs/ND1VGp30tKmWBuCbqMIEJcS1WoAxLif+UQZueuHy3D/iVIvLH3JkYNAGqcxDeli307G8ekowY5K+NzrJH5WQ6NF8guz8Ut4zbZZexn0KFmrDfx3Xl1hb+UAo4kAw3rEfUCIe1dTJmkJRS0Utt3yoTKPaLGiZcQ9t/Gy99DeQnAdaspRrCNxw5/p8Gak9scbWUInBroUtESKGcK5jlpaOcJPykQ2y8Km8b2ALh1aOExgPMDDggVRV
 H0zZ+WRc
 dO3s2DZDPw2pBrzP3lWPalBf9/5WLTmHmJhWjq8ozMT7BLp6OYvY54SN/ZN9KlRwykymrXL8//1HsJJRCdtBOI/Wz7AImrJMI2bRkgQi13BNpBsM9UEBbtI+o5qDN23yALngCf44lIgkFaH+GAAKxVkwml1PrBYCrNeeXb76BDf2p7Bnm4pci8vThGfpI05QgGj+Qd1R79YxKhPIZU89gR8Xwgm4gxd2WQTX/rRx23lqACZ/Y6zJtp8GbkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jakub Kicinski reported that after the commit d929525c2e30 ("memcg:
net: track network throttling due to memcg memory pressure"), in
Meta fleet, the network intensive workloads started seeing extensive
spinlock contention in the rx path in the function
cgroup_file_notify().

cgroup_file_notify() uses a single global spinlock to protect the
cfile->kn pointer across all cgroups.  On systems with many cgroups
under memory pressure, this becomes a bottleneck as multiple CPUs in
reclaim call __memcg_memory_event(), which walks the cgroup hierarchy
calling cgroup_file_notify() at each level -- all serialized on the
same lock.

This series reduces the lock hold time by moving kernfs_notify()
outside the critical section, adds lockless fast-path checks to avoid
the lock entirely in common cases (torn-down files and rate-limited
bursts), and replaces the global lock with a per-cgroup_file lock to
eliminate cross-cgroup contention.

Shakeel Butt (3):
  cgroup: reduce cgroup_file_kn_lock hold time in cgroup_file_notify()
  cgroup: add lockless fast-path checks to cgroup_file_notify()
  cgroup: replace global cgroup_file_kn_lock with per-cgroup_file lock

 include/linux/cgroup-defs.h |  1 +
 kernel/cgroup/cgroup.c      | 50 +++++++++++++++++++++----------------
 2 files changed, 29 insertions(+), 22 deletions(-)

-- 
2.47.3


