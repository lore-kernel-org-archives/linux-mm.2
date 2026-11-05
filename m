Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5743606EE85
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=E8PRhFRF
Received: by kanga.kvack.org (Postfix)
	id 0C31D6B05B8; Thu,  5 Nov 2026 04:53:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09AB86B05B9; Thu,  5 Nov 2026 04:53:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA226B05BA; Thu,  5 Nov 2026 04:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF8E76B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:53:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5D3FA09B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:53:09 +0000 (UTC)
X-FDA: 85400602098.22.9DC1757
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf09.hostedemail.com (Postfix) with ESMTP id 56A4314000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:53:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=E8PRhFRF;
	spf=pass (imf09.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aFffXURD64Y45svN0+A+/kAHMGgDt4bDmohfFFHf6vQ=;
	b=adpXwCqA/FmJdpraG5NVDmzfakLrEcv+9zW3mqo+Yb/WyuuT4ncfbM/uKb7k9CljGHVZPD
	OVUpjX0231sGz8BxY7l23rUP/iigoschY2bbSLBL+Ae6ytBkeIq/4IBHCnO8P1KWVkPN+8
	GQQgnTO+QdHwwh+HuvuxWQPYM0Shmp4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872388;
	b=Uoy3HLt61j/NZ31cX/WmT+syX6Y5itKBaob+xNSOuEWSf4Gb+OdESl40VUrkC64XE6qjEa
	KDytbEjGJvawlXUyDhRkN0uzrjzwmF4G6rZ3IPCgkimH1cfJfwk3/SPTC/PSfqNyzr+DeO
	BMlg8z15zcjjVa3tEwoMyhITGfh9odk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=E8PRhFRF;
	spf=pass (imf09.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793872384; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=aFffXURD64Y45svN0+A+/kAHMGgDt4bDmohfFFHf6vQ=;
	b=E8PRhFRF5CfhT37+GXGLMWy/5jJMjPyirI0g9+3WQ5xxbQ27gO3boNtGGXQTrqR9TTJY6lf0pAmNWi2P+nAKQBdfi+QGV45SFbiN/3cWfJKzrBSOqgZid3MOLMKVfMG7bWWhFCHFlpwifG+e/0jg+fr2IgNJ20U/nfNG3dL2iDQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0XE8JNoa_1793872372;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XE8JNoa_1793872372 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:53:03 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: catalin.marinas@arm.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm: kmemleak: avoid long RCU read-side sections in reports
Date: Thu,  5 Nov 2026 17:52:48 +0800
Message-ID: <cover.1793871596.git.tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i9jfsjwee83x1rejx8idywotwmceimum
X-Rspamd-Queue-Id: 56A4314000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793872386-462855
X-HE-Meta: U2FsdGVkX1/CyDbssXGY8ZDaU001m/CtREj6ZQ8EEbA+bjFD0UdN/VXNWOeHEsK4PPeEbGFsK0Kd+PJlNQ5fsNUNQ0fUudIHlpqYT3lTrGfy52yZfQCQl/vF+oDKVuYo4UuIvAte8pVWMkfKOz5/LpmqIu4egyQrT4O00E8G8IC8pkIrFqpKOR8ltzLZ0gxFFj3rKm7MqZXyhNsHCOcfTWhOzVPtHEzUsXEPe3P+aN7vETgAUqFRZAO7s6BjFDaR/Z8EeqDmFIsmu1WIucuwL/VTek7D6mG4pxdMzkzrDIijTgG2rMQ0t/BvmiaECYdUa3GvuzEGfQOAaNuy5AEqyP3A78RBPj4GSbr4vDgFan290SDQjouBbQsIJrqTjTuqmimRwEocHN3a23EcXs67hVTTAWeACbeom9Bgv7ic28sHL601LXWKxUmSHj98yKDxwME0kJBSU+8aa5T4C8MgjVn+cZmj9S2bxVZt/LWcAJLPt0c311V9pBE3tXwniyV9CVeOYhri9OeSkGOiY3NnvDLVjMmab3w+OVANgy1J7+4KzmIB0J7y1PZJ/S5cC+OXgbcfBH4THbPEdClX1mgzZDEvB8XW7+qiAn1fYLKTd4RLPZzf875Vt76OHa4zeB6XHqOhgtWrwr6tY7wZdKzO1qHRBU3ZHUQIkVZBfa2Ac/64uUtrpkhVoXFeKY+J0gLR0or6k0OYWJeI78tj48RcX7ie9S7pN3w0QJ5lay63cNyB7nZxAibIfJcjq6Lq5r5Bgjc+tJilJp5FD7qrCZJOGvhfVbkVnXn2IMOb0NoIwT57nnaSvB6btk9WsyCVbhSDpNeiZ24dDC7wHOhAMArAGPlJYzJ7g4nMiDpg29SPScx1vJApT3lTJsR8IXoZpBVAiukq+Lg27tJaWYl2pv5sdgt4ozHjOovXcluhZOXVWXGqxsUlPq7sfjDQISZY/WLgowtVoP4BLl7n2jh+TnP
 aze34FoO
 qJOZriqOvDeqAoV8ICuFpJi36C1WD46Y3W0sObJlZkg3TawQRcR/O6XQ9VdpSyYayh4XAlKRSatiXmCRufdRFs6PWmGqCgDQHdRlnPpj11g4YfeKarR4kYxxsJfXjuhG3M7UCehOzX+LPkmb8qGfHj9rYlhlRLZ9XukchkB7mjOSC4Oh7A89H7TV+mf3puyUm5p9wJ8WCwmQDuy1SSc/PhCVSy3a3KN0ksZCvBlzj43ahP5jeJtKO6ovYcvWRNLoZ/sVn4mxISCbqU7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reading a kmemleak report can traverse all tracked objects in one
RCU read-side section and cause a stall.

Serialize disable-time cleanup with clear operations and report readers,
then use kmemleak_cond_resched() in both report traversal loops to let RCU
progress safely during long reads.

QEMU/KVM tests on mm-stable 6628e7d4c6b25:
* With 134 million real allocations and no injected delay, continuous
  RCU sections fell from 23.11-23.38 s to 126-972 us. Total reading took
  23.11-23.38 s before and 23.67-24.09 s after. Neither kernel stalled.
* With identical 300 us per-node delays, only kernels without patch 2
  stalled. Patch 1 eliminated overlapping cleanup entry.
* Under lazy/full preemption, 560 concurrent-removal cases, 20 deleted-chain
  cases and debugfs read checks passed with KASAN, lockdep and DEBUG_LIST.

Weilin Tong (2):
  mm: kmemleak: serialize disable-time cleanup
  mm: kmemleak: reschedule while reading reports

 mm/kmemleak.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4

