Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DD9D25920
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1B36B009D; Mon, 26 Jan 2026 21:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC316B009E; Mon, 26 Jan 2026 21:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5F46B009F; Mon, 26 Jan 2026 21:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4906B009D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:45:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41C4DD3C6D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:06 +0000 (UTC)
X-FDA: 84376201812.08.09FFFA5
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 87AE640005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:45:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QbI4wHPQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1BqMEOY9X0l6L8QNWTbBYeaa++beJxlVBc9vvQg0ZY=;
	b=2NywX+MySbLGwBdgsvaAZ8fdfBOYyzKOaHEI9ZfWUFfRwIeyXP6BGApjZ3OUMSFa+A8YlR
	10YtGPM5wCcrrGENS95NCqmsraseeXelp8D7aDe8U5jFmUzeo/O4ypitXDviZd0+s0+1EM
	doPBvfzH7Csq5VW8tBfaaqFvjz2FVFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481904; a=rsa-sha256;
	cv=none;
	b=2f3j/j1m7dURV710xXlLoUZd84ktolwKrX16g9uF7WVk5iJjc7nBtyHLKjkJ4CLrZp1pEs
	NMnuFHi+WnZhzmtAj5S6DNF/s667nfWoWlKSdnVkpwZOcla5OPlE70eV+00ieTIK910DVL
	wZTyg0ahWbwQkK67azkhQglUzeTUfHo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QbI4wHPQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c1BqMEOY9X0l6L8QNWTbBYeaa++beJxlVBc9vvQg0ZY=;
	b=QbI4wHPQfRxt8LfCF+viV3xkrlBU6NP5bBWY35N/NkqWng0zJlvecrQMEa1z3u7pww2PWr
	Tv5enAhdzVLQfRrxGb4aYKamVhrbRnhLb2bC3PaWMu7jqL3WSp44XVhQf5aLobBHS07fRT
	yO6H6ZRa3Mi6o/210cWpFLKHLzbagDY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 10/17] mm: introduce bpf_task_is_oom_victim() kfunc
Date: Mon, 26 Jan 2026 18:44:13 -0800
Message-ID: <20260127024421.494929-11-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 87AE640005
X-Stat-Signature: 1ywmc8p8dugjx7p3t4n1qki4ppwykj75
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769481904-415258
X-HE-Meta: U2FsdGVkX1+KT9FSvfsk5tTufNziyW8R1kiGihCIAohMFFS1UWhsch0lebGuhQYp99sfAlp+ub7tzXX0Vr4tkyzjdVQ5xqsysHs/n+hhzdMOuUZUrRUhMAuRm7vRJ29vHtFVgohrHbWh19YXiKdt6cV0bRlATwcSe66KcJ8yk+GDIg3jBIj5+Hh76KqtgD0orky7hRJg/A3b5ek9Jng6f3nIZRpvbMiKph/UAz6msN5n7uWQwGWFtp8wkhwBzpGajSOLEFiaEIbfvQo2yw6WpSyNprmn07vo7/NZJNe2iDWpHrEl9qq/DPbBkU9XKrO9DnC5aANGTQgc5F29oskoxtV+M8C9+azYF0VTxVejJEt5exzHPSCSa9uB2C3dlM8dEY1sDYmTP4N8D4FkrCN1HpUjwDAXAemH4foVmzPvcIDwPQSN5UTATrCUd5J86C6a/oiBxBvHg2b6jjD59NzrLFDhYkU2FOv6cU7I5J3dRcXFkN5Vvcy+aQOTBim+kKT3y/h3HMZS6Zkw/9wtuW0GPJ86fsvD4s49WVaXGrGiNM8JHUHutGbu3zmclTNYIZUz6PGfI6vP0TSIXBStyS92uRA2p5jYBVjFQjeL0kNBG53YAXo9Pyj2tCRDH/MqUOO43ezeqfni13hnuZ+40hoFj5BjL4juGfdngO6tS5h7IgGsb5NIXpMer6xRKcLM3ULmiDi0TCCSuzibaLz3f7OI9lsSu9Qga26YB9NfGeJETH4jLFh3jJO9QfNidzWPNbdkvwqNC8yWuj84k6TWvx8LCl6dqodMxY2kFTb6e+3NP6MSWVEWnkM8DHCOzkw2TYjJ9Q63FGOB0AXWKp298b5s4cv3HlZQMpWhkXXG7Id2njhZt4pIYdPBDr+vy7Av/82SA3FGW7hzC/Y35bwYt/INshSgj/S2+rqjUooWh7OFJJKwVLTjAfdWbIKkoZZp+EDWDvhhucYBBsMkDpDMkju
 S+TFoWtW
 VZUL0JV0ZJ4SwqSKJiweRQvCUnaG2KOSz+hWU708OJ3BZs83Od0ICtnIQWJBtlAs6JB02Ad9SbzNXrbCd28db4eBBdR7cNAfijULv7zKhOjDfePRYNivzlnFj94tOzMMca3bcruO13XfPHQMuisQHMNL/lEd1WqkSgATriNnakSRZbGxkfC68E877ob3bRbFaVnZ6w0e93iUdaZ+H1sjZZgDEUqAn+CZJs2N6xaAqiGEzT2pgP3y1UNWzAr8cTsIB6Xr2m/+uvEj+CWfEPDWj8hp6IjGJJWAbYaOe1lXeMFmEctAGA8TFVqvAQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Export tsk_is_oom_victim() helper as a BPF kfunc.
It's very useful to avoid redundant oom kills.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Suggested-by: Michal Hocko <mhocko@suse.com>
---
 mm/oom_kill.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 8f63a370b8f5..53f9f9674658 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1381,10 +1381,24 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
 	return ret;
 }
 
+/**
+ * bpf_task_is_oom_victim - Check if the task has been marked as an OOM victim
+ * @task: task to check
+ *
+ * Returns true if the task has been previously selected by the OOM killer
+ * to be killed. It's expected that the task will be destroyed soon and some
+ * memory will be freed, so maybe no additional actions required.
+ */
+__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
+{
+	return tsk_is_oom_victim(task);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_oom_kfuncs)
 BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_task_is_oom_victim)
 BTF_KFUNCS_END(bpf_oom_kfuncs)
 
 BTF_ID_LIST_SINGLE(bpf_oom_ops_ids, struct, bpf_oom_ops)
-- 
2.52.0


