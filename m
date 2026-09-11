Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D3CC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5696B00B2; Fri, 11 Sep 2026 04:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80FA6B00B3; Fri, 11 Sep 2026 04:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70526B00B4; Fri, 11 Sep 2026 04:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87B516B00B2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:02:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27A4D160135
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:02:32 +0000 (UTC)
X-FDA: 85200739344.28.A3D8FC4
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A5271C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:02:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SgMrp5Wz;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQ/W+AlnM+r2htCI+NGVITVGIqmtCB9z++mzFhfCZKk=;
	b=3iHyJUralD8ikROfUst5FlgiR0+psDoVgVAprUF+SpHpKWl2x6zF7Pm+2N/YFhh2F97Of0
	T1oSrR1zmxrHZN1pCWj6nN6EWQil6MpB8Ulipw+n/Pl0VYWBhtFsMOIZBpVRp8sayIPOxZ
	fjWk5gUzLQsQfzewlIjw5IIbWPZqvYU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113750;
	b=DiADkJkTzbpDmzAtHGd0aXiflarUxgZgI01V33WBp7fcaoPiq+0MbP0QgZY4hCvtRChF+f
	lxH8yMdpp1jZDdxiGsTr1br8q8Yd9fuuomhfDhsvl+FgE/BFNpT82xoF/ea5t6Y3w76nll
	BMFAHS8qCvuT78OFadFf3wtX6CQCWB0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SgMrp5Wz;
	spf=pass (imf18.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.140 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DT3XFpe3pacIAc5YAypwgMYEhUAkDdTmk92G+6zy28I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113748; v=1; x=1789718548;
 b=SgMrp5WztCwHb1fG1N8Vhc5ctMl0J3oIm2SdYjqGE+ScoLRW244MZpkqKztQdlfYbTpysTIr
 Nn9IUigpgHljHXNIjnQt6Rl8KxGjd+prBbZfZS/9SnAzMBEAsUH0E9ZY6sozMuHFOTA6Dc7hTmw
 b9lYRoLdA5VB0Rbhhwqns+z4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7ddc78a39b3151cc;
	Fri, 11 Sep 2026 08:02:28 +0000
X-Mizu-Trace-ID: 7ddc78a39b3151cc
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	SJ Park <sj@kernel.org>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 14/15] lib: convert process iterator to for_each_process_rculock
Date: Fri, 11 Sep 2026 15:57:59 +0800
Message-Id: <20260911075800.491472-15-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ac7jw34b1zpcc65q7cgtj8t7wkyc9fee
X-Rspamd-Queue-Id: 3A5271C0003
X-HE-Tag: 1789113749-801954
X-HE-Meta: U2FsdGVkX18DgId+UI+stjkiAurIEWPaZhnhhZlJ6NBwYKPtZDUAl49b2meTZnwWM8GMyRplOYhaHkOXTN5/OHy7jKdgzA1gUSq80ZhUW7SOV/c/L5F4ynMUWPQPja+GeC/XsdKDAt37oSQaf6Ya70w3F/7ZU1WRQm1HoAhHbuXUGB/ebAuJ3fiIMFdwGotxvzMb80U5r46NQtjiIVbYy0EyNLpB0mDU9bcYPmdZtx51wKqo8VJ6S5M6fG3xLAtKIfRFTTS5A1q8pkR6TUOT8uAwJm9NGRobNWIT2JRg/umsb9jzjaIfcKTn9oTW0RmdGqsKYgYo/ueOrJlZ6OFathifT8E0rHKGBc0ezQI1IVzWyBsteifCX+oQTGSnK/oINHikihdEZYX7sKJKxex0SkIZSRcuwvTVfHO72unC30hhg83ej+nOytAqK+kMPsCmGhBu8Vbyfo3hGamff2tixodjC491OIF4TCZCEI5cUytMObZkai56PpVp6/8UoadLLxLzFuIeR2b9D5c3JvfRlaInUhw35HHh2tWf9YvsOJ/R1kEypTbX23yE+ecmJsHyD9VFIne4ATy706Qiy1ovwbsqzUv2edTGK4Cee8SOiC229HDMPwyDPEzWwHvQFZOCXGMlY1xLo7S/95OqyBmOMkiONll6jgq8+eOWLYL1f5l3lHNwE/iPLtEN2WvmRdJg14hKpp6CHp62EH4+SORYPRzHeFOQGzulTVPQQni2elOV4o1W8vaUXJMY3DBOgnFr6OHoRxs8HEXmM/WaVfTn1l8cuWeyRnjzMfFE35DnJI5TE3eq6UBQhhys6VCkwzt4yJNnn3ekACZuky/4W6e4DAX3vctveVVNYuuD2EOVlfngpPR2lAE1jA9r70PaRx1Orl5LVwL+ro2pQQY6y4O3HzPUl0HU0E/WWaoudKaYNY+pM0iOZnP291x5fnld3jq9Z4IFKd+n3acNP13otkE
 I/ZD8D/Q
 wZpSi7xGtW+IFZxdVzILLLrBmyUByny45qfmgthe0rwpNUyD/5EX8pdph3e3/drpQ8Xqa1EHDXW2mMijIvz5DfmLcudCR5AeTnFEw0Fim1o/DNjRiP1LtOlSX+Fm4vmAo/YZ8X/EZpT+ipkocQQkY0hQkh3K1UawKGaDUem18t5GIv2B6V56LL03oHrMe0EtvUl5HrhjixNUfJSR141XgsXyrnXI2JImo6oeEh2c1CSa2jebDyhzvG8WZkJSnBHcacDjMQottrqx21LiDSrAW3Bww+o7MxztlTqLubv0KDmjJZBNUW9V9Iihe/XUizUaUYhRWtagrPPmJLIhHAz+9bCZS8OLAJ1ldWIpKMmuKdoux2bXXPysanfym2Hcszyw97HyhS4CfSrrG7ZHvuNgliILuFmE9sIi4zOpXqWbTbOMKYexFhEhbkKWIgqANgqzlbYEA0dSlaiIB61tg1I5UXFd0GJUk5Q035V0YMN8lVZXp7g0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process() loop in lib/ with for_each_process_rculock(),
which scopes the RCU read lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: SJ Park <sj@kernel.org>
---
Changes in v2:
  - Rename *_rcu to *_rculock
 lib/is_single_threaded.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/is_single_threaded.c b/lib/is_single_threaded.c
index 8c98b20bfc41..4e7fe85454ab 100644
--- a/lib/is_single_threaded.c
+++ b/lib/is_single_threaded.c
@@ -26,8 +26,7 @@ bool current_is_single_threaded(void)
 		return true;
 
 	ret = false;
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rculock(p) {
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
 		if (unlikely(p == task->group_leader))
@@ -48,7 +47,5 @@ bool current_is_single_threaded(void)
 	}
 	ret = true;
 found:
-	rcu_read_unlock();
-
 	return ret;
 }
-- 
2.25.1


