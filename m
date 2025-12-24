Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A7CE7545D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A4C6B00C4; Wed, 24 Dec 2025 08:49:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131836B00C5; Wed, 24 Dec 2025 08:49:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0347F6B00C6; Wed, 24 Dec 2025 08:49:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E59736B00C4
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:49:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BAD17137339
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:33 +0000 (UTC)
X-FDA: 84254497026.03.5D81ADD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3339D180002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ug4foumU;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6O6rmYJG+Tl4L6LWgIlJj4N9PKLZ9AXfFtLpQTmd/fo=;
	b=BmqzuFmakdE8KoNgimKO8uNUUOrFFbPWcxLPl4eEKBjzb/09MC3dKpv815eCsCSVSr/EbN
	TxfTtQRBAjLLoYg/P7js5AkAT5KXuZ4iFa01SptQR60kTyPWyEa9Pv9SvEQQf1ce64P3Zx
	WbYeuLbhwn5rfJoC9midI6YQ/fgVfJY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ug4foumU;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584172; a=rsa-sha256;
	cv=none;
	b=ZfSfYJrZxn5iSUqnI1crf1Z5C/LkeUYJOR4fbh/jjFcdXQemXE8kAX1f7hQ7OWs/ebBruD
	EIlbf8FmvhO+VmukxjTaovQDG0FmvkJwCMAle2nCcCdaSSdW0AC6Rl5WvN56k59L9yDTrz
	++mL89CmnNJ2TQIBIKh2p+gwJhclJFo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD79B600AD;
	Wed, 24 Dec 2025 13:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7775BC4CEFB;
	Wed, 24 Dec 2025 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584171;
	bh=j8MGHYhCs1J4x6C+On5nxQzbEbcFY8oG1AQUgHvIMQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ug4foumUQK9xRmYsoDji03kHgYZzKPVPSgWqmGK3NJ+Z7jjoOn8Vl3zo1uGnRUXGG
	 t6pgfWJPN83UUgWKg2TyarSyKH7GVLWJ7DnO6XlRJCW1HvygjPb5Odk4vZOFcuFaxF
	 ejKKSs4ytrwCFSO3OsW1nuuiExbDBVHHm1MbHVHPYuucbzxQNkzgDNPRB8SOBm8mD4
	 NYpyM32QqQIAes3ebGOpL0dm8GBsBikiUEcOMzBiAv9d1Ndn85XsDYQGLAzJbmA9X+
	 c1SijNhPjuzP3mjTbN/GBf9j5oqsoAQJcgWW0zk1XA3Fyda5ziOczDh16D87/Hw80f
	 OKeLK+2485YKQ==
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
Subject: [PATCH 28/33] sched: Switch the fallback task allowed cpumask to HK_TYPE_DOMAIN
Date: Wed, 24 Dec 2025 14:45:15 +0100
Message-ID: <20251224134520.33231-29-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3339D180002
X-Stat-Signature: yiiyrjs9cz4w6xbt8a1rncsht78eyo77
X-HE-Tag: 1766584172-761858
X-HE-Meta: U2FsdGVkX19awzoF3UYUYnZ7uN7ZBgNPZoPMBx6VdwjQmkaETj2GSoRZ3vUkFpvv/BmAK88OTi2uQXRynhPt1VUgKWapQjG0DDviMqS/hXo5eNd7wD5dloHPnWe5QRU582YC5+KYAzHoPOk70muOWmuLGslFp0RfoVNzRh8W1YzqoSnSbD5Scs/8l7FtLZ+1ApKmPoCGMOm5wvTyt8K83qPUuTGigvoQ97jPrtr1IwqkVWQ5Z8mRiek42owW90z4pqbsRdkA37sE/rDAsJT6evZf07TJ4Nn/r2SrH9IlemqAk6ltJJHCLkjjfCIxC5v5hOAAFSose6ZL++pwdZM4PuOIVbUy9gZ0+3Fr4jGRttqn5G/Jj/z/zwQTliU4CdtOIpFsGmRCyaqNbQianm9+UisP+xkQTS4xiLGZYCG4+RMQhrE6Eoc0kom696CNH3rGWZKHEePu1yTTmcEUf+hmk5VKmhgoRxgKpxqe0nS4Uo9GV6dx6bZNviKTmWMmJv6dyjOfKRjfgf5aP/2lSxKk1Ifr3bCVt2b6YfayxJBQdzo1C2VgT5tGcNsk5J4JOUVt4aZvC4SDMueUDfwT28dMqmAHvomB3dJyOK3H6822QGn+J16Czs6CrBIWWZr5xzsfqLkG9fz3sr8BAieWv7IS08AdAUQyix7gM42mjyl+Q5ZKkAPBmc8sDQOnA2/SFG6xaLZ3kvv3Ny7h5Iw9+GPuXo57pRKiePEEvhfLNTun+vqZ/0rlnORVbX3Pduj3m/6Y4SJXkMwMDZDZlXXLR38kLn8hN/HI8Des7vePrZy/IJTi3es20Ie+YmiL2i7+az4UQtuoCRH9QGYpj8BPDJukMpn8KOMWv/drEXuEWJwkcCdHlp4KKB4uEaM9F0G/IhtWSjs843uRsdpsJ1TJAD0Z3vvLihBpozac+++OEXkE+3m6ceWXyn9AD0xcxc1YUuC/x5U41XzEEMVW+cytiMY
 Kd6eUEhP
 8f+8TlreF2ZG6z4xplMJfLh3QT2XZkmic5Gew2T9FaqibMd+IDPSa56LzU32AEj7J88KXAvsv5Xbc/iq0FkocT2sAmISd93XRQ8Jj2lhCjknpGlXS9jMJkVaOFqt5nZY+hwSDZKcevWEHdMk6xXQaM0l9RiuJq13Pxicxr8Pp1WnD/QOF6YBX5hte/GD2TJ4qukvih0LANK0dAzsWc70HTwDbrWjuAz9t6Hii6fUu+rIarColMpUT7+yaYhgu5bFV/apSv7qvLeiruCyk3pLiLcGrFRIwWA74O6s+Mb7TGQbXrKizRVHL236xDhKH0w43AMm5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tasks that have all their allowed CPUs offline don't want their affinity
to fallback on either nohz_full CPUs or on domain isolated CPUs. And
since nohz_full implies domain isolation, checking the latter is enough
to verify both.

Therefore exclude domain isolation from fallback task affinity.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/mmu_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
index ac01dc4eb2ce..ed3dd0f3fe19 100644
--- a/include/linux/mmu_context.h
+++ b/include/linux/mmu_context.h
@@ -24,7 +24,7 @@ static inline void leave_mm(void) { }
 #ifndef task_cpu_possible_mask
 # define task_cpu_possible_mask(p)	cpu_possible_mask
 # define task_cpu_possible(cpu, p)	true
-# define task_cpu_fallback_mask(p)	housekeeping_cpumask(HK_TYPE_TICK)
+# define task_cpu_fallback_mask(p)	housekeeping_cpumask(HK_TYPE_DOMAIN)
 #else
 # define task_cpu_possible(cpu, p)	cpumask_test_cpu((cpu), task_cpu_possible_mask(p))
 #endif
-- 
2.51.1


