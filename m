Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E6CBD7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897BA6B0005; Sun, 25 Jan 2026 17:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8389E6B0099; Sun, 25 Jan 2026 17:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E856B009B; Sun, 25 Jan 2026 17:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 673D76B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:46:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02BE113B21C
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:59 +0000 (UTC)
X-FDA: 84371972958.01.236B323
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70EE240003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NeWRcvHf;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNHhksth0DMgZoLPWd0R5GoOcr9klYZtYuCtgdTRwi0=;
	b=YYPQXEI7t0EoGEwirrjEpOuDik9CAx1N1zijso7ZC0gOSJ6pb/zTsKGYQZEEjPz5P4cfhT
	8hOGTp7SBsILZJB85/aXzZo3vttqkdhM8Xq/35Ms+IeXLsKzVFopDhuOgyDi99pbnX2qef
	NRQJHkp7bKEkT+HoqEf26yTX7Js2R+w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NeWRcvHf;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381217; a=rsa-sha256;
	cv=none;
	b=C4scKHvMDfbJHUN5CJUwL8hRsU+I0A89lOFMy4eDq1B/zQM7g/3qFg90NW8J6IzwVTR1K3
	R4AEfW1ULjGhk2ULUACAYo8qLYPXk82fPOSF3TjhdAyOrrf9A6Jp+BFHuCqvb8p+A4g+lC
	s90xcQqC5i0yvNET8YOj9/fc8ssGdQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BFF940ACB;
	Sun, 25 Jan 2026 22:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F61C4CEF1;
	Sun, 25 Jan 2026 22:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381216;
	bh=gHL1k3Ce/0Yqnu3RKEhMFCTtXjaAjQ9JVob0E5Uoa3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeWRcvHfyNkP41Y23+BOqfICl2kcKZg/8wKK47gGHMusAHbGA2Wo7fFtJRW7vJrCX
	 yzl5Q2dYHHh5Nj+MLKzPGz5ditBgiu1Kh6txj3s/1tsBYFB5jUDpfDzgKJQ78xA9i+
	 vzkzY62pMpw+HbiFUi5N7D8TXWBRLwsIO0Tqs7qfREjVLgSIKCbdetc5JvC/vbLtFM
	 sGym7Mn6+sf/Pr7KMZUdgSqsox+/Y5NuRSqcvqjRsqx4KegjDVKO/x50YepFOOMc8H
	 RLpX2Ta4FLD8OVTkqUJ7OsFBHGf137O0zSliVHv7zlt4cT0w7Y8qThUAZgqeYQBe+k
	 qk4tadz39hsKw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
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
Date: Sun, 25 Jan 2026 23:45:15 +0100
Message-ID: <20260125224541.50226-9-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: jbucncbmgr96zmiefgpggytmgdfamkk9
X-Rspam-User: 
X-Rspamd-Queue-Id: 70EE240003
X-HE-Tag: 1769381217-383342
X-HE-Meta: U2FsdGVkX18WyHV4/wTol9Sg4q782x7h/ZZICFs4n2bAdnUwU1i2a9siQEYP/olZaRKxMBgCKflQqYWEHnCDr99s+mMHPF4Y7qhl2SVLbAPyrVo+ejxTdsP6QCPxIHcCzp1JsvJMNCgiG++ZUG3pfbxLTOPj5G/3H0RUZ7IBKQyyZSwfzPFeY3JiWPNQwQMIZvU4tOizgi9I4m0c5QUUnUtQmHsuGTJJcFGBG+6a7oH+NanYqQSAG0MoCJfzcOI8JJTN1pSYvev83L4LdFbfsY/gfgzw7lMWX+wJdLalwSi618g85w/KneL70sTftVWcWSSVdNHCgdn3eQZb0mFtErkGClSuvoGo5wCuM5Lm3vtrEH7mpWq/7h3z6bj9Ekjil8ZJJfby8RZoqzUpUqNYf0ExA9msgVgZDKU85TXPjIIWmnI2winI198Al3hkGLfImC5LthUAt5ct3yyDsbZ1H12GhqZLgr5pPAqbeXyuLv0FbQ0wZ/o/kKLIGy+aoOLJE3XspBBkBsj7Mb8vY2b5z2IrGp2RkEFbWAv2cG+6EdPnH1YOu3CnZcCDPQ6By3Wuuuqxq9waq8e8EdYUcxpHAoE+HkDy5emdsFXMp00O+piL85SO1LSCACFSit3j7kzY6TIby4gdmBETnGaLacX38GROu5zb7zZNqFn4VTv1REnHJzYlBdtGxyTWGMTvsADt5dFsfDVhdHixrSFDaiS3Kv8/2ASM27NqKfQgsZ9zcgiLqZ/VWB+SAnGTregx4tOzROa+eE/TOYwqfb/YLHYvOCkgkoSbkvjuC9iwgV7oIL6LD+DofiP3MIeFS6cDr64rmtHGOW0EUm1jvdCpBPuiDSyMq+hp31+knrMen8ivV0GFFZfacOKhV5S9GqnLAgHYCHG0R1Dnf5pYdIRpc3EJktvWW48Jasthr/Q54tCdmc+4nvofdPIhpQSXxK2MWSiMV9tqqygaMGVu9gOlDmq
 MRaidQL2
 qYcfIStBNsDGWLy1RYrxmbJ+RdiOYu0GCkt/TTb3Heid4jPRVkAqBQzHRrWvwtPmmG/xvGDHZ6U+xDWTKN0/2H30KJJGq08/3BSvfIYaHyFSnIZG2NzG860KZFXjZM/1C271tLg9mcNFwgYMKySCE2CikE77lqV2cNVYC9O/ncHuPLxPz90ibYqwipuCpBqhdc9SLP9XkO3Ly20/2ET2K9JGc59r2K4Usx/YJA8vtF24+QCE=
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
2.51.1


