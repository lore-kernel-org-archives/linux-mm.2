Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169D3EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EC816B0093; Thu,  1 Jan 2026 17:14:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C46A6B0095; Thu,  1 Jan 2026 17:14:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA626B0096; Thu,  1 Jan 2026 17:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 605406B0093
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:14:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26D8814157E
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:48 +0000 (UTC)
X-FDA: 84284800656.24.66C9FAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7593220003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUUVJ4Ql;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NxPIB+sKOAQabBh8M/jSikEflAZ+lcyW9sJi6TniPc=;
	b=P5VgMHTta0vzCqpswp92ysd1U0Z3AewA+Z8xxtfZRfS48tvk5nVgxY1CuvlgJ3Cloh5OeS
	mTBXYYiQGGY9lrfzlT1Rr4wfXpe4mR2gpdCziopWHxFVwza4gu/Hg83jzbPMsvMrnL0oZd
	lybPg2/9wNEPtiWH8HID34UiezVQgUs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUUVJ4Ql;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305686; a=rsa-sha256;
	cv=none;
	b=GQgENznypPk5od3rl3/8R6nX0r3PonSJZHZqwxRJ4sJ1+njLafwXM4YLbUUhlY0i0ZGnUx
	+t+35ktCaNg4kDK0EhRRx8+PuNgtv3s8elmCovwxePi/xlMEJZcqppDRLV2aDfXpw6g+5+
	l/1C4qSS+u3/E1EPzjBdH15vPFbdnYQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 912AE44032;
	Thu,  1 Jan 2026 22:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E32CC4CEF7;
	Thu,  1 Jan 2026 22:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305685;
	bh=gBHkj0y4jQxeMV2qzbEciSScfrXq1yZennkNx/2Itiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUUVJ4QlV2Ud1CrS6GjbiF6v46hq34xCiNh0ZJVjVwX1TXlPBFeyAEgU8UViw5n7D
	 i59CAEMxlUC3VxC9iEwmbmBwuKfcfVzPUUaZD6pH8UiyBaJnaMjvHjrcuuVjuwPRY/
	 88byT+kZctItQI+QgXaYFZ8RmSFVhJsjKDttq+hwL8Wx0ETwMm6W1gzDxv7AULKKam
	 YJnAGrRKYx/MpQRZJU91JeeCHIxHJewdUxbzC9D5Z/RjPXLAk6MIhhlLqAIn3gDP0V
	 HcXzQ3FppfamhiEne7w0DLSThz/ucPmLuVjZrVFub7h2zTJg0+6DD93qqzEmXwyKQN
	 Z4zpqik3l7rJg==
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
Subject: [PATCH 04/33] mm: vmstat: Prepare to protect against concurrent isolated cpuset change
Date: Thu,  1 Jan 2026 23:13:29 +0100
Message-ID: <20260101221359.22298-5-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7593220003
X-Stat-Signature: j8jebk865hitauuujajtbmtj5wryqm7h
X-HE-Tag: 1767305686-177878
X-HE-Meta: U2FsdGVkX19PBQT1QvyagycGqWJ4aKPHrXLO+pS1hYSCdEmyPW+PTNTveGTH3F+oQhCW64gS8yTprJt0Y804S8Lt6aguGm31OXNrzDWBAdb0qIpd7Chc9sa6SKatRLV+Ri/oB1S6W3iD2Un/obBYPwmCujuAqQ0YI/gD80RA8wKXTK79uwzxNDmx7MGccB4SlNEZHpKO6QxeBkPHdqzLNDVZzzVvZrNTyDV7pcNZMrFFUDy4j2zXKy6dbBY+280DzD/D4tg6uTj/JQw9nRXuqkLVZRPnwJX9N11T3FY4s8OkdJLAtwBQjOTuS9VzK4d4nrp4kN/8iVunvua0zsKfCCtHHDHzBVR2zQqQpq19txKIu5FA00zT4E9PEXLIEdNLlMwiBd6l89zGQFK631KDlsBK2X7NONBkL9qgrTHrpJFbozm6MwT63SOVG85/EP1TXbB87fb34TCO6IDiPMKqF4aaydOQhICDFqwgo59gXkcNeyUhWYQzLfUiFAC7+w/Unc/vE7JYPvf+b7HE/Kf++ZRH6TRYj3aaCKgpG/0NkoLMqCD5sJeRhityFZDr5jlPhxdMB9ZwczFa7tiisJta7b7yeF5R6YGkfwHUKbjMRgn4XjNR11t1KNo8u/ZbjCmiRtnoi06YXZgvC8bLooljyrkMHdHbKG13zbReEs96IVsz0UYvwL4H+envy0pJhXpBByUq/gIFESS/QCOajWBdLNz3YL0AXJVtnB3T0eeY5xQtqof+w6LAZCRinluKsTuJvWoMJnGGcURSCIn/DQxxbSQnvKfDtgyZ77N0OyoVPNdg3h96SHbtXCBSU68nm7nT2nvoRv1jMV+LGeUrfiLo6wzkGNKynsGVrS3VnVlitRp/jqSUiXog04aEEJbvzOEbOSTKP1/eM9oXhdoXsbGGfk+Q+AW6NG6vU8Bvl6AqpMzt9yfsPKTIIomjRaDKzLofvDxG9IltowArvmTxzlb
 p/lph/Fo
 mwy7w/0MCINgD6ejB6eAUB5jGQkoGYc2hXNo5Tefs0UtDZ2ItCrwhR8tcQWi5zAm6vaFqU93QLedd/mbllxns6+yBzuwhyHjcqfP9C+cilC98a3kQIpu/kshNx5OLlmLCfK9IsNexqoMzfpkQRQ+S6XwlJTAb+Gpj5f2mLOIlYu0FEfaUIiqgFSdcTtGuKUe2+pgy9HfNdaBjNdQdxzPgdutMtn3LgYb5NUGvHy5EfUerkj31rrAYkP0cdjBEYzfoBapY9eTCBlJrTys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
runtime. In order to synchronize against vmstat workqueue to make sure
that no asynchronous vmstat work is pending or executing on a newly made
isolated CPU, target and queue a vmstat work under the same RCU read
side critical section.

Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a vmstat
workqueue flush will also be issued in a further change to make sure
that no work remains pending after a CPU has been made isolated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 mm/vmstat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..ed19c0d42de6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2144,11 +2144,13 @@ static void vmstat_shepherd(struct work_struct *w)
 		 * infrastructure ever noticing. Skip regular flushing from vmstat_shepherd
 		 * for all isolated CPUs to avoid interference with the isolated workload.
 		 */
-		if (cpu_is_isolated(cpu))
-			continue;
+		scoped_guard(rcu) {
+			if (cpu_is_isolated(cpu))
+				continue;
 
-		if (!delayed_work_pending(dw) && need_update(cpu))
-			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+			if (!delayed_work_pending(dw) && need_update(cpu))
+				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+		}
 
 		cond_resched();
 	}
-- 
2.51.1


