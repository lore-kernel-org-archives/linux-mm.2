Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBD0CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 673FC6B008C; Tue, 23 Jun 2026 02:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6245B6B0092; Tue, 23 Jun 2026 02:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5132A6B0096; Tue, 23 Jun 2026 02:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6956B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:28:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 998AC166CE7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:28:53 +0000 (UTC)
X-FDA: 84910199346.30.5627DE6
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8F72160003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:28:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XnAJbpIJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782196132;
	b=ZOf0fTSKRufhLQorji5dVpBZnzKGT2lmjAgvo20GGF2WNXcNrQ1sO2rt0YUkv8YWlqcLOe
	3hWN1cq9FOWsU//AZ0U+n11bDldVFlkPE3OJVQqD1q8pugIOe01fFN9jjMXjfeCaEYNyaT
	KU3Xo4Pqy1neGgJ23Lx+TeILEP/zH/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782196132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fulPYBKv0+qQhpOwEZvPxrLqZb68dG2SMZzTJMFOD6c=;
	b=uAKvcTfaUUPua2tYgTYsxUNaYZzoV5ti5mTCfYFSmGr6MVGcqb6sQo+eCvRjwu7W79mqFD
	cHxpTOE3h8BFNMg4uC8lrcTXVi28u9bd+CH92JZsfTY4gvVCzPBCCCaWAC2e3/sx6samy3
	fuKJdf0f95yLHkpB5n1ZmS6jlj5ZLIw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XnAJbpIJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782196130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fulPYBKv0+qQhpOwEZvPxrLqZb68dG2SMZzTJMFOD6c=;
	b=XnAJbpIJbAuC34LqLXy68b1Vw4byyaTksocBJcQm1Bbv4HRQfGPY2mEU1QQYDMt7ZD8fi3
	Pq5Pw+E3Ve87u+B4MFfetnx5/3vbwBe1MM06eUaKiGDk5nC6U6/U7nzpv9I0r2ko2DPhpn
	qfMdrvqc0OSKUCeeWpdmA9G0s9zFI0s=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: yingfu.zhou@shopee.com,
	jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] memcg: bail out memory.high when memcg is dying
Date: Tue, 23 Jun 2026 14:27:54 +0800
Message-ID: <20260623062800.298514-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260623062800.298514-1-jiayuan.chen@linux.dev>
References: <20260623062800.298514-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8F72160003
X-Rspam-User: 
X-Stat-Signature: qwcizxg9gnbnswciwk5uz71eeqrxor5x
X-HE-Tag: 1782196131-978762
X-HE-Meta: U2FsdGVkX1+mEodPdMVnMd9opmQodrcjMTao37k1lXXMrbEQ3tLsYsns+G0IiamgFgC11MWQr0h8/ZSGq8lgKq0J/1oS1DnoSEZ0jbHkSr9GQZKM1DHAz8BsFMKrRMFYDbR/xpnxYnSZaPDbR/Lmm9rxffQIKySA1Mt3P/YPxzl0BEbMC/FCjywcHZ6QXukxWOgVhI+CJ+0oqfPDHnEtQJYu8muX2PyXM/Ygu+s8O1JG8C4tOSkqt6Brvu8uC8rVQstZ6JsgYUXu8k10gyIACczNmd2udgrhGnZ+IifDJOK8Me9GFPsZHYz/N3VC7ECLp4hBpUEbcWe03KNzMrNTyhVQ9IQeez54UpiIBA+myRnq+iO2QJBn2wKYgMVjZc764fyOzXsfZ6/MOPGrBvvI3XHNlvr0g8uzjsdd4VAVcuuriSgE2mm1CTD35/o+x85aIKCPb/Ct3XMGxCyhYPZRJKgtSoiFuUl+lQbFR9m3xvkFn7hbha/8RxXWZPU2TtcN7270TEeSpp2UfDXb6W7MQTJxNf7XA/j5KjPjB2tFSDp/ImTLjBhlwIaGfnmAJV1OBZ8FlQ58MnUbuvGMULQqdy09AWq8tCW+Nt9UhJnqw/1xqPkzrm+5i6Pnj/bWgKPjsdkgvKbLEdvMPtfFqC7c2On0jL01KucyzoCCR5MLm6vs8q5sDYiPX4rU1GflMbeY3oxmtHSRXMsSwg3VDycUB5Vrw2jYUdF+b7f+LWwY8Vrnpdfm587nLf5TachmbAlJDnyRqa7YMTDL9DRE9J16QPo5XOrAWybaHSgVpnKiyBah/6UmsprclHt5yAnba1j29ARiZz7MUEI/4kuNRJkZPCS7KUY7fN3/wv3p38k8ygWB8v62hOmv+T5OEZ0Slt+Ye2L6SFDSaNOJSJumHP0SOYQDHaIDrKN4QrH6AsjBeEP0Ipf3fZkYFRR8oaM+x+E0LDizBgx+MgkJ40L+a47
 cMCYRkNY
 7pqZLYohhFbnnRuALJ8tDGEOnzSusvBeIZNpvnM5YyxbzPEb/dogQzRumnSNwgN4XMXHN+aLgvkANOUJufmOILpEt/ydsbNUJLKtb5VfKly6/emvy9GPj2szV97zQmgc8f0C26BNqCwvABHPUCnlzfc5mNGhkGZ0+OXbxOthhh8RmuEO714AFk+AIMIRbXAhXOmuJdVga8qgBxlIGKw/1lU+9YUCEBtelmpqO7OPMXK+AK17u7+bmhkn/H1pLYGJ9eite6TFTPL3VMHK57r5yrMCUNxHlLuZMVe4SGZc51gBv1a8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

memory.high reclaims synchronously in the writer's context, and the
latency can be very high - especially when reclaim performs swap I/O, or
under thrashing where the loop may not converge for a long time.

While this runs the kernfs active reference on the file is held, so a
concurrent removal of the same cgroup blocks in kernfs_drain() under
cgroup_mutex until it finishes. Reclaiming a dying cgroup is pointless,
as its pages are reparented to the parent anyway.

Mitigate this by bailing out of the reclaim loop once memcg_is_dying().

Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 56cd4af08232..2d5cd056a25e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4793,6 +4793,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		if (signal_pending(current))
 			break;
 
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
-- 
2.43.0


