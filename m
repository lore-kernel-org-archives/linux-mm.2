Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CA1E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5728F6B00B6; Sun, 25 Jan 2026 17:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D386B00B8; Sun, 25 Jan 2026 17:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432216B00B9; Sun, 25 Jan 2026 17:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBFD6B00B6
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:48:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECE1513B21C
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:36 +0000 (UTC)
X-FDA: 84371977032.11.91DED1D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 57C33100003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QmeExAOs;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deF+JrfXKJMQQONv/Z/SCp87iSCloLUAUVLjyUPPk0E=;
	b=wgXx6X3qWZcsXAeEaGEpu4AIyYylaTHrh35W/LlJ8XWCnPOEmEB8CrVvo/BMfEC1e13fZz
	JHjSzF69mNg/VrqXFFCrtofbSEXX16NHYtA9xFNxpjmThAP20Dofl7UCAcw/NRBUXcuQy4
	s9vX2KUcgwLpT+A2NzCqF9WWhfkdhDY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QmeExAOs;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381315; a=rsa-sha256;
	cv=none;
	b=uKkpq/AoO3nSHa6IGkNvkzhOsxltaj6gfY2AQQIfJcORVvA8wSR70/k5Gyj8sohtUazg8u
	mkcttYJGkY5+VFlZ1ZDZ0Ldxlq6xDhPONuGzGUp9y9X65lMJJht+bbBBQ6e1+aW1mNhymD
	QSC0L82MHQhic1JiA3gnxeU8Lct2jjQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0F84600C3;
	Sun, 25 Jan 2026 22:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC069C2BC87;
	Sun, 25 Jan 2026 22:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381314;
	bh=xcMcLXp9lSxfZhVrsREHiMXj3hvNw6ylCQ2N03wRKM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmeExAOsPNVoad+FjY6nF+vUq/CT43QF/yEuMh6eHWpIhuE6ZhsTyd5DgYVaFdhRA
	 KSrOxbUrqW5spLkd02FS+St8WkGKBIm+v3PMxvJLp1CI21bHFT5B83sW9aoEvZd7EZ
	 wLGM69jCyrsM0H58qDzzf0R8iRbdcsrDdiowQ99KVna6CUb5V2fJVSJxg5AUF6Qw9u
	 FAWcSRhFRJXdqspv5nZhIU/oCRP5Wf0+b2FMOnlohs0YeAWa9QzyeMxmiuo5sfIrrr
	 3ETdzmebs0OLqjVcHCp0rHJFMPuaSujPyR7DCLDzl/Lv+WMKVs8eZVXX99M8M05ujn
	 feLcLjAzWadHg==
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
Subject: [PATCH 20/33] timers/migration: Remove superfluous cpuset isolation test
Date: Sun, 25 Jan 2026 23:45:27 +0100
Message-ID: <20260125224541.50226-21-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57C33100003
X-Stat-Signature: 5iij14jhxwbzxqo9fyh3k4iyakbywewi
X-Rspam-User: 
X-HE-Tag: 1769381315-821563
X-HE-Meta: U2FsdGVkX1/aHuUxKkaCSs+PZAV4kN+JzmoG8VeddLyMtMvSffVKxfVhPKtCT6Lh2WofNtH+kZNjtgS/HPkqNHNvQEJ4CsRWLORfWoG0xtWWSxFztfiqSmQZyUs1+r8lHhMpsqTmIFV0yISl1YOIW8th8GSH4FdQGG2E2LVPqL4ZiwusK27n6RS+vq5PmQ1kJs7UFf2BFelwI+jkA9/AkzfbdSvT0lFnCAonEQ2Zjj0oG82wTRtqwTtYWWLWhxTuP1tMX0Mh7ihrXC/wdW2meUZlEXSy12QN6NbgHZYiQobsAq0LjsdaB01WCWNeqmvgecICdw2XyZdRmklKgRduIgnfYiDAE1T5IPuElodjlFxc2epezSr9/vPvu1PXYJpXyqZyI1g1dd9ZkJQjLUmD9m+M7yTw6JjIMb3J4K17peuOHRJHn8dqfn4lFMJ2V7s4Bp2RXM6dNOB5ooXNIzJVEzzrbJ2byz55L3vPRIVGmA5Or9i4N37rFBI120MFXjh685gIBcajuuV1d9jZ0LSpffk2O50nGQVG/aQTG9NG2JEP7+Hh0hHJo+rtaYibDJnpIGKQKxyK6IrdsbsOD6IKdWhE/o+WQ0LgYyBnDtmAeqKHqAcKtwsQr/72zCPGzbBMj4KiyhjCbYHXO7aTwZ2HAJ7R2KznJJGIzvsTtqEFwAWRFcRH03dVIyOji4Jv26ci1keWq6Qfhn1yeH271SRvm4P+14s6gG0T9m7itnME3iq2aaJkN38IhKoe8zxT4a2UcJpiaHxooRBi2gHj7sEF/SaEuTx88ARQy0kQi49F2C4YBP1XPhiepnR7xHs6F3h3PYLYFYh/vddYeYXI4mlE9zw4aObgd6GAqqjIuuZu59xOKc0frX+ispr6YHtp9zJVD1mllFvZUnnkzYfqH3BvY3D7D+PAwQb5t+0Mn5kq7R83Sv8oqe7zkzYVZR8HSjYPTpCMoaq2KLDTNe231K2
 RIHm/RwA
 NG7tbY3LehE7lYVG5n7Z5WME9eictSxwejSWkv3nJwp8xQ+C9q6rKgqW7RuZdnLq67KRFZ5xnzNX0CMQ8f7j9nqJkTaPEajB3qnIoq4ZXhzt3ahwQ5eKhfRFlHVecvqTxwd/EAt3kgZZW8OfmORdAY98OIrYMW+G474cDbqE4dyVmBinehxs6wAFb6nqPqNH9qU724ICgBAsZClAowqGFVUFIy5QaezEbJpBU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cpuset isolated partitions are now included in HK_TYPE_DOMAIN. Testing
if a CPU is part of an isolated partition alone is now useless.

Remove the superflous test.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 kernel/time/timer_migration.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 3879575a4975..6da9cd562b20 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -466,9 +466,8 @@ static inline bool tmigr_is_isolated(int cpu)
 {
 	if (!static_branch_unlikely(&tmigr_exclude_isolated))
 		return false;
-	return (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) ||
-		cpuset_cpu_is_isolated(cpu)) &&
-	       housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE);
+	return (!housekeeping_cpu(cpu, HK_TYPE_DOMAIN) &&
+		housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE));
 }
 
 /*
-- 
2.51.1


