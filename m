Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4B52FD88D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 01:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4F36B0089; Tue, 10 Mar 2026 21:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DEC6B008A; Tue, 10 Mar 2026 21:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9556B008C; Tue, 10 Mar 2026 21:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19F6E6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 21:01:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAD7C14049A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:01:13 +0000 (UTC)
X-FDA: 84531978426.06.B355DF7
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id D6C55A0014
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:01:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LgHUGpls;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773190872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1zI0HjdpVIeLf9hsutuK6PY4JFf5qAhFtdlVI8aS1sw=;
	b=M3MoHmDMN2Bbbopj+4tL7G6uK3u1cpl43KC7JhqTxJLgMcrmd5Pj0ZPEal7L02wkugRN83
	RGwjtshfORrRq9F/pgrrn6I5lg+YLxzpJyIWrg7o5+4AvFq0QgWuGOJoB42fSYuyUtuXwM
	ZYWgw739GYUlSuD9PP8CDRjN4OUsLns=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LgHUGpls;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773190872; a=rsa-sha256;
	cv=none;
	b=mOadFSBsGrawYZruJA76zo1MTDNxhmvudwy4/DFEdZUBa+lsTrXLLfPq4/mrrB+UkBnI8D
	EfKseGgQt0PROOFfd8rzc8jUg9YABC/TAGwdgUz+4G2hJ6pP/d19W2fNAtmp1jG2Dfx43J
	EvBU/5eLPlgVTEQnw6GBtGYBvFdpinM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773190869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1zI0HjdpVIeLf9hsutuK6PY4JFf5qAhFtdlVI8aS1sw=;
	b=LgHUGplsk2p9syAn/wJWFocufn0GBEBbF/HLE+Hy6ni8L7uAVzEcVw7Zi4W98y97igwNd3
	ct3hRgGLQHsuKtE95Av+ETz/CnvanrSyODESwHGyblTNbf6APrdMKTbSSTKZRvOn7KUPk/
	Ju7/rXEFjmtKd1lL3Ymwc6MgnShnvxA=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] cgroup: improve cgroup_file_notify() scalability
Date: Tue, 10 Mar 2026 18:00:58 -0700
Message-ID: <20260311010101.3306366-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6C55A0014
X-Stat-Signature: jdjp5phpa4udsch3it8ts3bg56q9yqmr
X-Rspam-User: 
X-HE-Tag: 1773190871-985747
X-HE-Meta: U2FsdGVkX1+oHxFKwCh2pA9qMBdAivFwhAloprJKG7+8JhkV6u4pyHLjyYZ9xhV2XT48xuMIQxN8hlHkud9IyfdHevp7OaPmhD+I7nH/FMcGOprPfQ1WwTYmDE0DQHWDZWTxqarmcV8b3kfkz32b6BOJqZeEZCxWzER/L0XRfMbhCZYBHL9K6jPZCUNdOvbqHqmm1gMT/nEL+GRuClpWnBXHtfpILelxMIMthshOdV8pylT0e3skWVDtUumEp+PsF1Xm1P7Jl5zXd8YraNGM9xHijj/Zy4nEn+TIKQQ557mGdAutQ3fDXqhrThwvQsyXijBmkNKYcSrqDLacP+DR4MLqb5a14w6UbfRIaTPn+pL51dZ3lNrc6NYSSknoHY8vHTx4S4aEh6YMdBQxLxxVdSKSipOQHtFygscTDXRWgwDnUE+HAGN3m+zRONuHgdBFipelkbQoVQ6FOupE9oFShNSB7lROJtnuI8OuIFFRqre0IPmtORKsBP0ZdJHjN59o8cA+SqaPEn5uGhSAp1MthENIGeaF0F7NMXa919U2b6H2K+5kKZf0YDqATVhx2OiiHugtIa2g1b3rk74a5ig5httTVmPjOs6Pe7y2Mu7q6pTA8mbZmRyQbUrED+kOLgn/Xl8kYPd8tevChnUKZuGMlO8izJrW9WY/U8+g5JCd9Ci24t/pi+ERLbsxdUogCPcmT9cauqXAkCVTk+YcTZ974d6N3rH1CsAxZeLy7ymJ2oU4CkrN/QPjwJYJyvbF9L+/iiJqMjpBjygolMBl2kBNLFp8iD0h1n+zl/RB2+tn/dbQuCJn0vGwUVo+iLJlWG2HqdECjAEU9lvcYD6J4TYYofRNTq1Mv+dpat570aVMvB58saUu92vWCgawu3HwK7bJNroaXWpLhDAjlR2/VZy2KXBf0Xh4gneHp+h4hS/3Kba60aZgLFCZg/vr/csazECth5/TzOvBljyHBBGD4Ml
 WI7LrJfF
 LhXTNg1xoihRtqjygmii40p2TOp3KU4/arpbUNleF6flJrOwVfzpfbcEo5Dla3+pblOevtwo3NZFpeDRpBGXq+nAD5FcUKFDVY/gQnpuNFLOi7GIR5bjLjyU0k+Hwq9g2DuXWihwAXKMdst8Lvqm9nmJ6tZ222QM60ePzsaRC4KbLvuVGp2IV696GIkMh4wpk7Mc05SIfi8toXUDz8JqLyVMCulkIoxIczNyZLke3f/AJ4vHhWSjfoeWynA==
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

Changes since v1:
- Second patch moves rate-limiting code out of lock 

Shakeel Butt (3):
  cgroup: reduce cgroup_file_kn_lock hold time in cgroup_file_notify()
  cgroup: add lockless fast-path checks to cgroup_file_notify()
  cgroup: replace global cgroup_file_kn_lock with per-cgroup_file lock

 include/linux/cgroup-defs.h |  1 +
 kernel/cgroup/cgroup.c      | 53 ++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 25 deletions(-)

-- 
2.52.0


