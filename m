Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 094F8CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8748E0073; Mon, 13 Oct 2025 16:33:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0018E0036; Mon, 13 Oct 2025 16:33:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6128E0073; Mon, 13 Oct 2025 16:33:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BEC08E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:33:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDEDD13B66D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:03 +0000 (UTC)
X-FDA: 83994240246.06.34A5F33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6621E180008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vj29vz4R;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yoVNNJWFcsz+37Hp69s5AIX1N8gKdXmTdzj10XYNSkE=;
	b=JYHCak4d5pVA8dpago3Z0qVd5yZweYWkaPfN1pMedjrpSzT4ce/t7+DCLFgGedXNTWBWeL
	5VumzOqIIAjWTkWA1nMiMQtm19d85NZMzrWUKnh2e2gyqeN/7fE3XEErFwFls4iOlaRJsY
	Prx0GU3EgYwQ7E+OCYWzyV139lo/oqM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vj29vz4R;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387582; a=rsa-sha256;
	cv=none;
	b=zdCaXSMVorK9a3qmmMppYolNuvBZkxNbKh2Exw21urNco7jLWhIstWMG5gmKeFYYP3y5E4
	Arqz561aE/r6qg6PkbptuJki2yAN3BErBHN/9exNOyx88WEBqFFcKU65BmfiWh8iuTOkSI
	OE1SZuzeLkOA8VP4Tq+kP57jWsI9Lhg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB1CC604A5;
	Mon, 13 Oct 2025 20:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1133AC4CEE7;
	Mon, 13 Oct 2025 20:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387581;
	bh=27i30BHoqn/BGY6ARghdzM2ne1ZlXRlOL17r9Y9xQIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vj29vz4RtllKnPy0syNL8X4XKS9GnmMDyBglO6Mvs6AEqCeZ4A+cRIUSI0tGlwCnt
	 PwUyOwph9MHmEq6tkTfGZGSvXXFyEsGFisJCfaVfwvBHZVnXfIfMaXWlKxWZjTE+Mu
	 rSl4X5CTj0dVqyEdrRXnHJ/jjLtpcY6M4DNR+jUkcuNxlbRGf3uy7rprC9AdoCyGub
	 79TKLcYUo5gwQtgWbpOo1+XqMdIVKz9H2zaKpX8ZL8CyntIp0I8zGsNiORh4ym2ER1
	 c6fod11QySs2FyOLX+I23bb9hrrBYQ9+A8Gg/eaBRyzxa3nxAr2gXIWWjKdt36l3SW
	 g9YRWWVX733VQ==
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
Subject: [PATCH 08/33] net: Keep ignoring isolated cpuset change
Date: Mon, 13 Oct 2025 22:31:21 +0200
Message-ID: <20251013203146.10162-9-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ppb6rodnc335sjs7ny5i69zyy89k5e9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6621E180008
X-HE-Tag: 1760387582-233805
X-HE-Meta: U2FsdGVkX19fX27WPjgqm9bIWCotMzIDs1oOe7NVURMwnK1EqyUfJFa0ijM7CQU13A5IhnTqisv4K+864jTTTkPWz+IBKZDQLgcA13KskQBuenpdjbGlI7/yWf8fg25NgBItpKMITMNxeTX+oQ3wDuPa9uH76KR5RJ68r5OxUYGYqR2+sbNaGTxWIePeP2hEs3lNmcJoodDk1SGwl20nX225sxsWkiVvvQdcv0jHdHk3AgRWf/ao11QrI2HuPEqpRjDWARBJu1YXT11Pwrojn+E0ieXqKDi+rHWfLXili2RTX2++j4EvPQOF2XyZ7/Bdb22dB+UDuCSAsD95qtZCDJ9DA/Z8PY7ku16Wj7P4oS+YGm1b4jT5yU4I3qhvzKN7DPTcpxMaV6JkIinD0YLrUjO81Xk4/jwGDWviq+O0CkRMXViDnKRe6zB98wGw8t/xk+IRSfT3OuxucA35QMcibxdT2pydCy/n0V3SIg2dczeNPU+rVDDiJ6I3dnp+DgXGASio9SoQFbBDfefRtnqM02Ryj5kEC7A7wWciR5lCZyra03jBRvnr291Xy/VTT8pM1DWOotWhP8/qJJnSeBvco3AgInM7hjxDueAiWHHKpr4ucEhYNzP/JhiYThF7zdYqvAYKtqZBDQtQz4PUwR+UVJDoKjZKgB+9I/NzTv+cCyJJWjcQJp/ha3DQVZ2kzrkc6868XmRdLg9dfV1Y0QQWZ145mQAPFeeHdIgPmY/BzItAxwFfTW670M2fYk8SIuQkj8XJTZhBRmCZ/bkIWcxY/bPRtnc+8jGSZdzgEtcUq7NeNt8fNp2YCIb/KJdULwvqlMSCKS6KVVpSJhfYT9FadXxeHjGvPdCRtHapdz32eNoAGtncXm9xquheITnY0j6E5AdB55SlCqmApF4dRSODKwMH4iTvFiez2ogUB6XLVFLqzzIngr1z63k20CsCwH2/6GT7/ZZK7mp5V8ImGrC
 oJ4pN8wD
 hqtnomb8F1DxNtR/+jjwMzF4lXo/EDWKTOAcKXQ5Fyqiwhd0n07EepWsqocYKf5MN3i2d7YD9zXeM/vVjYY7uFftBucUbEAMkySVAStjej8KQuT+ZpSBwMBTznJ4WiuUy4BdIcqaFp3C+4wAX35aWHggOVS5qzQyG2zLcHNPCnOQ+h/4DNBYSnR/te50xGC53Yq4Rz/z/I/tvodFMeDLJ0Tw8O7kxIaRLkCj4yj8/p39R320=
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


