Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA94CCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C8F8E0019; Fri, 29 Aug 2025 11:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4438E0017; Fri, 29 Aug 2025 11:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB448E0019; Fri, 29 Aug 2025 11:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0BE8E0017
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:48:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9127B8572D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:48:36 +0000 (UTC)
X-FDA: 83830227432.15.F5CAE4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 32B93100011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:48:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JBCCVwqS;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMN4+YgtYYVEuLl1JGo81YdTgJd4kIckWhP67T9mJRo=;
	b=FISHSLm1oB8rvJZD7uJY4LIyNzNPdI5JFMffbe0F+vW5BUNWJIGWmE5xvG0ffUsyV+O+Qn
	77BMLb1FmZi4Rc/UEIkRFon9ZjyoMJm1p3ocZGApYg+51WnUMEmFxBnT6VVGWCNnKBFs5U
	lSEQx1u9dFQqDXiHXF4iNyDHJf6MkKc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JBCCVwqS;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482515; a=rsa-sha256;
	cv=none;
	b=05c5FtCbaX2hpD+4XeDxUSjwd9YZPTG5w9yXUQlyKnr1ZoGx0EyP2RepR7L8cq+w9AcalX
	kgTaaP196CHFQpje+RKyAiJQ02Toz7BXwSwSjDcrn8J2Frys0QRaran2DrG14XSUYS5AaT
	aj17X0WtsnSgZHGYnbrmVVwtwpc884w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 65FC9601D6;
	Fri, 29 Aug 2025 15:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C938AC4CEF5;
	Fri, 29 Aug 2025 15:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756482514;
	bh=tKKwBK9xX0xg3Dm/NJEdQ7r5p4nUDr3fqs7FMV7Y/xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBCCVwqSjumn7XT4pVDMZEQLI5ogqSOLLqGspHQDWXhvD0P1ULdzN5pTeo2YYyls9
	 R1X0QNhPHFsw7zRULaD26WedF9faUpfaOdmDue3V+AlLjmpiuVjqW6ACLSQh0SNmbr
	 dsb63Wt0czGmui5C6jv6RImZDkq7MhoITNU7+llg+qFQy+uOOTL0n6jNdOXsVzugv5
	 onzVLJ0B+qvls4RBWOQ5FmzyvIUvBjo6pcO4XanBU+cvUhEGyDwWroQcN/+opq93XB
	 hNCXxaTRCVJ94BZun8eg+Rl+qFXPj1mkU88P5VcLTsoRIioeEpdrZpQDgXZhpkmvMe
	 vvWARYaBRDQGQ==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org
Subject: [PATCH 05/33] mm: vmstat: Prepare to protect against concurrent isolated cpuset change
Date: Fri, 29 Aug 2025 17:47:46 +0200
Message-ID: <20250829154814.47015-6-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829154814.47015-1-frederic@kernel.org>
References: <20250829154814.47015-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 32B93100011
X-Stat-Signature: w3ifu1fhh9nbhbkgp5gyuxo5daj9rjtk
X-Rspam-User: 
X-HE-Tag: 1756482515-4988
X-HE-Meta: U2FsdGVkX1/e0uD3pX8ot6aDrry1eOc7tiEN6RBQSw3XNZVpF5R/XiObeSoJGlBh4572pRjbh7cr90F+SfIKlziPmI2QG+P5nQu9OXlMluN7A/Cpn7mNj70u8nqQ3hW3Q+7wkopoDMIblbsmljYhee+guH17I0k0TQ8j3mrV9NnEB8vQISq1/p4vfyzsjMMhzE64jZkUVZea8XlQf/BvgKyQXhDmUKkcHZARPemhEH3GifNrRqiphxA8CfKANs7XANOVJ45z1K/J/j8XAFwignbVxU1RpUvHOmCYe7LqrcAgcvxxDq1+kTHRul1lTKPa+kHCG3rTd6A/+oxTsIVq3LR+wJmZwjBY7J9/eN0h8YW0mKZnUkG1Y44JOuCkCsAnPYbtwFdLYIGvz/fMjeWVbdAUwEd4YmAekT0+p7TQ7htInbZaTFle1i3h7yPiBGP46m1pJ6uNVQpUbHhrXpJNe79w2Y8SlT2LAAltQzciGF/7H6WzDimAzyeokWuBiwAXFWyCUCWKPJ5XtZ/GAV58kL6VOmLwnOMYeTSJoq/kNsg/Mzu719ivlp9sPG7CaHL3+774v3QeAIALFy604Rw6rTlgE5AdTGCdVLN1j2RtlICEx/IOQWJxDKke/XeSB15hLM3iPIcLkhnZ8KJRdHLrTaYEYDV6N5mI9K3iN8ErZT2tsPcfd2JAP7GYe7b/GFZPTL8IqzdWbFXpT/MQb4YIbjReatsD8zEu/egc0lyu+MwdMveKxFcCk3frIA9LqsT/DhaLGlAy+3DKMp7oa0X7ImJ64H81tr4bWJUe69CGJj5HxDdi2DAijCzYmYjaUrwBwttTgvlymrXP3XwXeujAywYGySdnNz/5sjq6N3bFJB6QI9+775SFGGNmkcCU6r1x58Inm4VAk+pLoCRuqYCjk7t9le8Isd6KQ2ln+EB03WtRmxaMz+nb8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifyable at
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
index 71cd1ceba191..b90325ee49d3 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2133,11 +2133,13 @@ static void vmstat_shepherd(struct work_struct *w)
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
2.51.0


