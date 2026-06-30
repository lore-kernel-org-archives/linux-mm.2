Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346A0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07816B00C7; Mon, 29 Jun 2026 21:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C913B6B00C8; Mon, 29 Jun 2026 21:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7EC16B00C9; Mon, 29 Jun 2026 21:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CF736B00C7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:29:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10A8BA0339
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:38 +0000 (UTC)
X-FDA: 84934846836.09.CF2064A
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 490F9180011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gY43CsnF;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782782976;
	b=ZvAxhI8hQ8QAebKcZ6voo3Zu0iqjQv1HeHTul2x6QvPuLyPRSRT/iOai/mO5ty9j+Hx/WF
	dCj4OTj4E5cXzsgs8Aw5v5CxTb4lStJnEntpGqa4iL62OQv18e9ZElobEaF1bqXb1+kh6a
	cY8Ldq3oAwooOgjNBDTkvdlgd7uRbp4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782782976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlkZCyTFI5I2PN93QEvND063eK33cy90zjCC7GApUko=;
	b=NvMaMNgvYl1lQhti/TCXDArcneIV7fw05Bi59ol1paIKS35GY8/lnAIcxLiwG0XD2Osfue
	t2mRqdS0pzQIdT8fLz8gDuq1l9G99XolpP8K/R0dKu0ib9ArE7rjcurTB2jwKbBSDvGZr6
	og8YHBHcpyAphDeSmitXvbmQMqU6nPE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gY43CsnF;
	spf=pass (imf24.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782782974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AlkZCyTFI5I2PN93QEvND063eK33cy90zjCC7GApUko=;
	b=gY43CsnFlyku18PH/raJSWs+nfA9Q0KeTReLcS8iacsNFDifGqIuAou6YDWC8kzHB3f7Xi
	FD1U0Q58WGGUMsN0aWt/RQyM6KCRVTW76I9zTHMmnMX2kZtGuep/rp0O0a53uBRHx4cZX2
	6pRijX+zQ4fr/isFEO+yEIjgLKBEFnY=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	yingfu.zhou@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
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
Subject: [PATCH v2 1/4] memcg: bail out memory.high when memcg is dying
Date: Tue, 30 Jun 2026 09:29:01 +0800
Message-ID: <20260630012909.144372-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260630012909.144372-1-jiayuan.chen@linux.dev>
References: <20260630012909.144372-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 490F9180011
X-Stat-Signature: c9p9at5ax5fgpd6wrsap3rju447pjwdy
X-HE-Tag: 1782782976-955979
X-HE-Meta: U2FsdGVkX18uQ6Wtmaf3bR2OZSfvn3V30kEwDR9o+rS2XNdTGVb8QbbfJgUvuguhBeLgUiECE9qTgsV/0J9HQEumd0xCHjd2IB8I1S8cD60yabAul9lXwFMjnVtolzfaWlAPh/e9v2z53apJvNgmWD0B45YyT4vLCVKC0Ef/eBKeTJ8Nx0A9o5hs5Gmj8ipYEpEOuRwmn2I+1go34h1JeUu32yJgYjoukbPo67dvUM6rwk+VdT/uEESUECQ74DlQTXU2QDn6fkGW674MFzZR/HYBxChCme3FA+WZ47emfPiXTTBuVSvzyTB0S8yKvE4QuH5Vt6CqSDTi7iws3vW9InAtwLVAKQkKwnKmoWAU2sByQFWBQSlhJ5Zl7YXRpyz8+zo58hskvG4dCnHsWd0eBUpHr1o/m6MCOobOIE+buAnO249is8kgMMzrcPvwjkC01QgaWxMMIjcJvbCIw/TwVKBDhDppwMR76F27jhUoqjj5UcUfrKbm4VoqCPHciBzobpcbGP2NH++jEbn4WnVQ+3NcsuXfrf/CQBrLA7Hpyhz+PqsGtpO6hWF6Bwo0113ul0NIPvmqSZU6SKBwsgi0Sa5SECpcxs2uSm4PJeId0dh23yo4Rc7Ef1L+RSo9mnMTnO5Af62QBbK0E3e5sSNEA3AIVVd5IJ9zXcbLY8dPmAWen6kLkw1ZrxHVN/ZQmJvzg0IYgFjwipnkVaIsCDCU3+TW9U+TO5mOLID7VGX2nD+YGYtupSA4/saDFopsGy/vMfkJxtbZeu6kjYD89CDyveL8qsOiEI4vY87lZ9z/OE7vVgsiA46m4bUiXA5bFdSDRhpzaRt2aPnB1/+weU0E46lqWBVbeDgKY/07JQvDSC8T1WmDFNlwZt/UHU5dBw4NRGZ74UrvMCKew/icLhRzzT8RFUpkRcVyEXkUy4rIH2sfXyFBhCLVaXYMAT5SP7EwVa4E3/JXzxg4WBA+DOR
 4AcYPrp6
 ssteqp1kD9BNescflgnT9yEcVcf9CXJ8Sj1tZNjPcSXjSfCaqVqZb2JCq/k2xWHburveWv6BiNvKhEz5jdBPM8NyPK61DoiupJRfASFEGH0RBs+BNtohgU0glM1Bjm3Uh+v+u+kgTXhr3bwyLGLeRBHCoivX1ckaBd+tSJDYDanidtSMIoErXS07rNF3HmdTp3KjbVF1W8Pzlc9YOKJUIfgo9JT5Qp1b9+DyRjoG+qQgOSQ9Of61FsSi7ZitA08g+PzNJY3WmqdGH8/p1EoHUhPZEqEVhqgfw2ThunRvDz9DLdxg=
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
index d20ffc827306..eca9f6091980 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4794,6 +4794,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
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


