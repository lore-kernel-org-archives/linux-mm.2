Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DF5EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA796B00B7; Thu,  1 Jan 2026 17:17:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5816B00B9; Thu,  1 Jan 2026 17:17:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4506B00BA; Thu,  1 Jan 2026 17:17:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6976B00B7
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:17:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CA289106E
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:00 +0000 (UTC)
X-FDA: 84284806200.04.F3AE283
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D78D6C0004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C2srymam;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305818; a=rsa-sha256;
	cv=none;
	b=LZrP4mtOiPHYP84WYdyb1Wil/5R8jLJPt7Tb1TLP1YAsw8Vmf8FGPbhctb0L3/EdKG8tyD
	rUS00ikkxKE70WpARkGEJ6tSmkbNx55Elkk4XoLtW6Th4k4+kgiIrdBDx5er2T9k2c5Qr0
	8AXc/+OEMe7WNUAmOmR0bkYnzvVABL4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C2srymam;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deF+JrfXKJMQQONv/Z/SCp87iSCloLUAUVLjyUPPk0E=;
	b=jkpoQqufs15SC8zMfErHYHmS8phWUd4XTJ/sMUCo7sEFIdFWqYDOwAfHRucx1tUVWm2LbR
	OohKxpUqblI/yRw2f7Kz/2+pHifuT9+qiwsuny7POYjhz9hFdw1FzUtCyjjiypT1PpmBCw
	ZQJPe2bADExg16CHQp4eO64qGuW17mw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 703EB600B0;
	Thu,  1 Jan 2026 22:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B19C4CEF7;
	Thu,  1 Jan 2026 22:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305818;
	bh=xcMcLXp9lSxfZhVrsREHiMXj3hvNw6ylCQ2N03wRKM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2srymamUA0MXxivD0ZeKbuJECZYnpJecM0twnYUVIw4QXxFyrb6VkzOgcYkmHia7
	 +DnWEgfnwas3kVZuLf9KnTKlIMAuWVsPt4pwS9udwPhgI+qL1DxK7Sod9D8m263NIa
	 W7qFbUW/tCcxsOubXiycdmSVDZ9lABvy+cWUVjffImRmPd4OCVaeJltguOh1R2iLNZ
	 JtcehsjD6GO3wNqGufbqTqFGlp6vOWIx4t10NRQc+URkLgOMwMUo+VgTIAgOoZRK6F
	 RExsJ3KheHEyeLBvwtNieJ9/RZAvnTRNxtfaiadl5mYG2GYxsztP4x+qItJkx55huk
	 8+pERh53gsTmQ==
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
Date: Thu,  1 Jan 2026 23:13:45 +0100
Message-ID: <20260101221359.22298-21-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D78D6C0004
X-Rspamd-Server: rspam10
X-Stat-Signature: b7uhgtac6w6r9wsxr7rmb17riseu3zgm
X-HE-Tag: 1767305818-199428
X-HE-Meta: U2FsdGVkX1/By9nXl0gIDTv30SqKX1CB7Oq+6tct3qd5Ir04dAu/1aKHXnDJCDa3qwW1CqWv2f/oxjgmcvNxqdsC8OmN6fDuH/Yd5YvOic4axl6DnTiWC+0MxJMtMVJnZkzRZ3SI5NOPVtiiPdjMxGY2ZzbGbymSyf42UKlESySMTck03zAgbB294Y7nZesHZ+f620tjVoX1B1KF7kJgJeHgH8hLVcbWSFiOGhgfaW/5Nc8P+9lFnTp2YRnI2t5ixLx4Spu+Xrs8Rom/0vF4JjvWpLxrn11haEOV7Fa0XkACB6JwC5ey0c/rMzEUMFIn4u117BCIj4+Xw7BqlR3KSNNVrkKSkgCV/WWWafzicr2Ta8nYafRCE/VYBklp4PgXIQufmlVY7Zx3PoLNP4OBZob43H0AvBUhMpv2dsf+ulnhThhJLNOvONMYwneWs02kmaMH2DD71X99ycGmtGxyMGizq3YBJWepADIEujPHNqL/VGwvEPVrKfYAT4d5hi7W0fYaQsrvH/bCzi6V6dy6ZBv3tx8ayKCkh12zmjGEKAaDGFncL6CUxeaZjlj6uU6GFUAv2IUG1C8Pgasx9AMkHc4cGQZNFDQeeIqedbwlolp9jsPQiG8W609VCAF2qPoQE4PqPpJ6khPt9RNC1RceEcOXviIwpuYBLMeKJsP3EgdDXQFSLBoZKD0HVBdvH8cnwW1kY9F50IF5HrYvUMcj0R4N1JlaniuwS+Ma6LK2chfGzcDbQ6COsWGPAYsMX3PYy5CGimaki8h8qnT/xY2xSKRgoP0oa34PFLQGz2nKNVnP3qCEyjpttnQBNhvlzRyqqoUgWCQ4u7YnG0sfeO1qpI3+DTzGv899JyERXQLvHtoRWNFB+79hggjxGGzOD+DZrIzJmxXrAPlbfX0WjVROZQ==
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


