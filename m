Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1054CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9CF8E0018; Wed,  5 Nov 2025 16:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D17C8E0002; Wed,  5 Nov 2025 16:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0C88E0018; Wed,  5 Nov 2025 16:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29DED8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:05:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EACEE1A04D1
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:07 +0000 (UTC)
X-FDA: 84077783454.07.910E4B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 512DB14000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:05:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JjCYtsp3;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoVNNJWFcsz+37Hp69s5AIX1N8gKdXmTdzj10XYNSkE=;
	b=R4hBEbPj+jjAW4v559osG4JKjcTLfA8CRWenDOm1hGeYfapFfQC0mRmCDXGai5cbmtCCNX
	Q8o8ZdNYtGx/6I6mFmVFTt35egiYnawDpNrsez8ynkUikmhKGYFHfbYAiDLxuxIpENMHEi
	CMBNCp506FdfeBbhpJiDrdIRZlxAr8Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JjCYtsp3;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376706; a=rsa-sha256;
	cv=none;
	b=Acp2biHgBeEvQFLSbtn6UG6oMWd75n1RFqNn1QL5EhbqNP5cy46g++9FbdCYop0S+PHkPY
	hygRpHHOLEJnDA+VM6L+bY1T90V0gxZTPsGSLFOVPv2m7DIyNGWNy2lGVsxyj31l8LfBIv
	QExK54rvp1Dns8g1UkE45BdbN4L36KI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6958A409E3;
	Wed,  5 Nov 2025 21:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FF4C4CEF5;
	Wed,  5 Nov 2025 21:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376705;
	bh=27i30BHoqn/BGY6ARghdzM2ne1ZlXRlOL17r9Y9xQIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjCYtsp3arDlgdSCfdYrEjKJJfAZqUk+QbEPyc2euy9ldASDGzJtMX8bz/0nOmNgj
	 zsZ+vpJgn3AxZvB3v7wgjYYdLkl/efj/scWiKiLXsx7hEPwP+jUEEox9tNkyI+T8LR
	 lRCed7eIknTR5DbF0lhv3ITbCqLMbkvyjAk9puPccy0ayechj8tB8UtvPdguu3Yw0Y
	 BCKDGsuZwbOlB4jsmIR08Lzzhb+iELcBSQO7SkLi+GCXK5mmbiJ9L1dTXuMryEm/UZ
	 XtSns050xBjEYfez0HKsI7LLuRlY0s7cEVB1GqOcLsUXQcxaSKFvbdXSgs2bx+2oc6
	 SNhAbL25yT/1A==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 08/31] net: Keep ignoring isolated cpuset change
Date: Wed,  5 Nov 2025 22:03:24 +0100
Message-ID: <20251105210348.35256-9-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 512DB14000C
X-Stat-Signature: gqimkyii9swnou971r6bgy4g934nr4iz
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762376706-768664
X-HE-Meta: U2FsdGVkX19F51ofBVii1eiAi1YvxT4ixbY24YpLxBibFkuf2hX/OSTKIdHs+d72u7cUJ73xqk+UPdHrPiKzT6xLfZgVz/r4vV3DbhwwyJPBABtpGyVrmGqrOkGcdWyfUNx5P2I4Jx6CHrhnEQKCKelCclXE6ykzmScgqWWPtPt+mI6bB+4fy1Dv0ouR++MKgiozbYmcUf+IzzLmDL4RazQbLtmPXgq+05wmOM8L6BW3Bjj/FS8UfDK4KFbqJkc18dtHlgmjAGo8Ycf3RfJNq9sfADndd3u0iidk1Hu+gZi8WahHHk99FsBwWboVG5RM/ZLAKtqdbxFX5X4slhLlu4Mf1u+3xHE/ZsDInoBAjVnMJbJKesLNIxeYqingfwoxAofzMGpH0m/z0P+xJpKlzWr7y/ipWa3E7yYdV3X0psPLi9q7okT70wsEHBk/+WJcvrjEhv/u415TOlJGa9mDw1RxHlqIjzbWcwMKmXMNwvseUv0+l5A29+3UkgLQ37W4anS6k27g0TtOCU+IhboH8k+5Dv7GH71PbQf8rPVDN31p2TX9DcjobiCdLwbfC017pa/xw5QYmgH0+IIXVWnliev4eGhbE1XfEXYbQfqrC6uQ3MV3UYLfEV9XN0Z/HGwt4VV8tnpXdsKodVwKCaFrDrUfm987HvY/p0uv4uG6fITVTUIcpTKdN0UGWh2SUX3C224J1mWEx4O9+5exy5khTKdGv29eKvwgafKoKWvWrV5KJDA25uT3IcKptM1MugCmD5SFe+CjxIOVO/Nw7lhbRQRUhJV3XcUcMp8eVjINXA7Rd4DxCAkVHoZ7iuzNHrx8AmF2arPSz4AJzjGtR9g6sFBXXcUSsUqqCZuKtqeB6QhETLkWg/9oPG2wkaSsql8BYBXNQjvIuuIbmmHcevKXMjYizWaFdA/R3CSvUSpzWgIdk9U1+aVjGA/rUJDhDw3xu/p9OCBv3PeUgSV+8p/
 cy0IiyEZ
 37wIRBaTO57SoFmUSLQ0AjzWNEhqxXl647AnJZnoW46Qi6tgi6fgJjYeHtwjanyxlr/M8109uUsAbMhsMlrXtpq36yxlIghK5FpEQwcIe/nQOgMrjO5JzvraPmMMH3neqJPjN6+VnT7XGrCUZn//hIjwEyPh5deF8Hr4DLWD2Psl68r+R7LJO6P/UtDt9BdGjvy6avXCXZq8bNITJdRQ5eQYPDdLgPqHW9RKQklS5aVi75XU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RPS cpumask can be overriden through sysfs/syctl. The boot defined
isolated CPUs are then excluded from that cpumask.

However HK_TYPE_DOMAIN will soon integrate cpuset isolated
CPUs updates and the RPS infrastructure needs more thoughts to be able
to propagate such changes and synchronize against them.

Keep handling only what was passed through "isolcpus=" for now.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ca878525ad7c..07624b682b08 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1022,7 +1022,7 @@ static int netdev_rx_queue_set_rps_mask(struct netdev_rx_queue *queue,
 int rps_cpumask_housekeeping(struct cpumask *mask)
 {
 	if (!cpumask_empty(mask)) {
-		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
+		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
 		if (cpumask_empty(mask))
 			return -EINVAL;
-- 
2.51.0


