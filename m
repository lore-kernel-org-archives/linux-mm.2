Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 671C4C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2F76B00E7; Mon, 21 Sep 2026 05:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA956B00E8; Mon, 21 Sep 2026 05:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9656B00E9; Mon, 21 Sep 2026 05:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3EB6B00E7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:22:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD4251205A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:43 +0000 (UTC)
X-FDA: 85237229406.03.DC607C3
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf04.hostedemail.com (Postfix) with ESMTP id EAC674000A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cbeFATl/";
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982562;
	b=3tWXjpWVS8Zn0baN+HrkLUkRTeFGC4s8FedDjsHuZ0+iv3kF5jk/MyUnLErLscz8hHP1lM
	Hf2PlxrgfvC0uNKGMR7d6/eYbx9Z/2zCmUoNMhkowWmqT+dbu3MId8j2sK2kVi8Cci5Pdi
	blftwRm0svRTFu827DQ109Ba+zZcP/k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cbeFATl/";
	spf=pass (imf04.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqdnqocgFzJQEttyRMh6NnJ4v4W63sJl8JyNhvP8qU0=;
	b=1nRXtrmF+bU21ErG/M+5iJ0tW8wozNxUrYCGay+ARyE3x+M1r5ISnnu5ktQIwheMZE8AsH
	/utT9/dXRFXaLKImvz3KMNr2M5y5Ciy5dekQk725eFjdeWVXh0eaMuK9fSXH5l+a7zypLm
	RrP52HmD3PwJapjMEIaqI+gfqxP4I8Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FGT5bYNhb7F30R7KVhWzfpI91BeKfJqsry/WZ5Za0+s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982560; v=1; x=1790587360;
 b=cbeFATl/S/mO56iCGH+rcO9I9RDaMqRXPfnxr9OtC/n7BpWdSxMIb7F73keo7iHEgeIWKLj7
 w5IkbclUpZdkLKPGFHVcCkayQUatur6sUPPjGy1YUvMqirnPoAQwi1F5AWevXbPOkyrxWXxMsgL
 0NnzqRhYOJVlNlh/TecAs9B4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 311c3a7172cefc8c;
	Mon, 21 Sep 2026 09:22:40 +0000
X-Mizu-Trace-ID: 311c3a7172cefc8c
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	akpm@linux-foundation.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
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
	babu.moger@amd.com
Subject: [PATCH v4 05/15] cpu/hotplug: convert process iterator to for_each_process_rculock
Date: Mon, 21 Sep 2026 17:20:51 +0800
Message-Id: <20260921092101.89285-6-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EAC674000A
X-Stat-Signature: hispedw93ey9xmmu7oi6excutp5szmmi
X-Rspam-User: 
X-HE-Tag: 1789982561-535278
X-HE-Meta: U2FsdGVkX1/wDSvm56Wz95alMB5rIJ/Zhu5rZHdffHYGYMFGVa5pOQx53DCnPGj++qpRdzj4ZcQ+pQznYbd5CPjYLe/ZqMAJbFtWJLiFVv/C2FcWYgCcb05ryH+2AhD1HDh73lCfyZ+SqsjqYCigunGtFpHIjsdLNv/cuP3p45r7JpDfwGzprj9gzqB6SkE1/WTHwIw1y7wfDrDmLvgYlaBjZKS0TcVGv9XIjYu5Ra3VzKtaodg0IF7hdayfbIpY9PcRf+TL6eXYJnt5xE4zdFUHLS1uDt7ZaoQz5bs1I2TN38PYfd0j/YCZ6wLnb3YV82BFiTQGkLYlEBfF0jN8GNVcbO0MzHCg3XYFbekxgETn6gwBequppFB1Ym2nD9T8BcpG95Kjx7VFe0ndSZ2KUaQkGpftbXovMvjSnxjpmGYmNXbQbIJA7FEr6d2uUiC1mRfUqZ7/YR/dWrWep7tM7M0Iymsc+FXZhRI+3nrDfzCqNsHl8eSln5fdyZEATVKu7BVBOojbfM3HRxrLO6Q/aWGantScx71G1ha44NaMrtcfXn3jncd1v+Xn6ktTVclz7LNRRE7ki48xCGjOTBGorJM7+PMZl5gXyKazBPh2RReldaDSBIxQfeKMm1+oQzNe4FOsQ86rbUVxUxQC+MIqoUy/Ts1rG1vtzRsoMjxkuwVhAExI42uz5pD0GlnxFf/fdL1tPHdTIu3TBeIPzDc2yPuU773Uu5YBhRzOMdfEvnEc3dnirY5234l86ByhxkD2X+0NUQFTODf3MMRCgFcBGL9mfDQzktNN+2w11xIkWjoehzBB0jKSiRmz/1wpZkm2KSBQcCst9wtae6+qCJE+vsplCg2w83tel6wQzvMgbFDC5lVEfUus+Gw73DM2FSCE3oPuQEk22M/HaewRfT3iy6ksXjT23OjGS2UKQv4X334im+lemOL72OPg7YRipLo5jyKNkA/wcm11xE9cVCt
 QtqD6pde
 81B++zzPnkBYSLovZiBYiez/9HS7ioi6Uq2hGLtHe3YR4YhCS9swZxSmpprSQ4156oSZbZvabfuiyw4jUpW3mGaV93wVC+bT2mfcqO4RBrIG/dXrM9lljiM9qzjXsvtj9AeSw4q1aFRariq63m8jAcNoLVYZ2yGUqPxgVI8YorAYRGWlyQUiHfJTQmEJHHIcCCfVTz7urMNYHVOgOwNLUHxwbCZ78hSEPNz/rpd2PgWW2rmuzkkPUO1TKduu0+Lg8p6/vtMS4CznGZSF4rE4yq41gZhb366jwL6a7VEQHJox02Z1zhCX40kFNnyvpVSnSfF3Fya/9oNeFgTxSIRhs1sUdQpClyZHRDv5XGNgv9lMhY38fp7qbNSvUXpnGwC34yOn04Ds+SJOo29xZe7bhuPrjTlp6qbuW3jNN4jVTa5dAbQDZ+vwqjP6ZH/OlEkDN2xgqcb2TaIt2bHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process() loop in kernel/cpu.c with for_each_process_rculock(),
which scopes the RCU read lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/cpu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b3c8553d7bd6..00638d2abc0f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1254,8 +1254,7 @@ void clear_tasks_mm_cpumask(int cpu)
 	 * full-fledged tasklist_lock.
 	 */
 	WARN_ON(cpu_online(cpu));
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rculock(p) {
 		struct task_struct *t;
 
 		/*
@@ -1268,7 +1267,6 @@ void clear_tasks_mm_cpumask(int cpu)
 		arch_clear_mm_cpumask_cpu(cpu, t->mm);
 		task_unlock(t);
 	}
-	rcu_read_unlock();
 }
 
 /* Take this CPU down. */
-- 
2.25.1


