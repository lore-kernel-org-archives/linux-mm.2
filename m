Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3FCACAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71FD8E0003; Wed, 10 Sep 2025 10:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16228E0020; Wed, 10 Sep 2025 10:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A418E0003; Wed, 10 Sep 2025 10:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 895518E0015
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:37:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29E0B160934
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:37:40 +0000 (UTC)
X-FDA: 83873594280.02.A9ED6F2
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9FD8F20006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:37:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf13.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=5y/0YWN4KzzPHKzf/rAq8liH1Mww5nTuxAdlkBlD8VE=;
	b=h7/whdFS0S0nQfC1u9Al9DHtkh/BLGvjXnprwQDGx1ct23W4zhyCtlGwY5a0ABwCMQJFMD
	MrbmZ7rvxAZeO9FnG7mzwII+9I1ErWbAWTUQDKOM+i5TitlS/APAg8s5VH1UJ38Q5QaZpG
	apaEtH/3NZHylzxDX60pJFnooQ8loME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757515058; a=rsa-sha256;
	cv=none;
	b=ImcO85OV8QH00vbw3s91PRywCvblkhZZrg8uR/LkP8NmpNNnI1UI07gegW3ihJ/Gf9l/F3
	BxDk7d1J1VjrZAU1ZtbS/OteUaqx7cPV5ndqOugZtS3N/RVjaA5GzXrr9CZVaV7GSU//XX
	6vQ/DkCxLZZPuYkBG6+LMhiHw/amSM8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf13.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cMNYr2tgWzYlHXW;
	Wed, 10 Sep 2025 22:37:04 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 22:37:31 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 10 Sep
 2025 22:37:31 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v9 0/2] Improvements to Victim Process Thawing and OOM Reaper Traversal Order
Date: Wed, 10 Sep 2025 22:37:24 +0800
Message-ID: <20250910143726.19905-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: 3pqiwmkswnr51fx44afqigwedq8m1di7
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FD8F20006
X-Rspamd-Server: rspam10
X-HE-Tag: 1757515057-887849
X-HE-Meta: U2FsdGVkX19YHV2W/le5QAjWS523Dss9tLqxe5fH+n6bEZRmLXgtkJAi+JofOSXQRX0GxHYAXXKEvGvuZRvImv+vyv8iuaQRlSK8EN3RdgJic/Y588gNtkGn1mO2JyiCNBoz6DZjtAFEhHbUD9ZZHxZOdtzJvm++Y4iTFIKrNRfqCjMgQiaaNWmRv62+xwBivNnpre+76UmgVrETRm99yl4S7dQZ4IyD0UNDttvHJjECoTiCSpJ4IlKLRDGNBPygrtYO3gTbzVNe9jBMbK0zk+BeJIM6oJ2sFxmPASLYhidqLPTRvcOswjoOj7BdFP/k0uvP3T8Jl0e+6PC1jZjvyV4KjHEQnbDGCTlzOitvSzoaL6RSfK2v7nH1yYIRNDWeYHZykZvbsLrhjCHol0pwfVMW0rHfZGXm/Lc0kGKceurM/MTNqCzuwU4V+BbNUuKH4nyWTyeCxLHpx37fdtT1iY5nMx3XMSweBMs7C3VXJ2M1qi4bZsL2hcDPWD6vEy8vKlmElmvy4q3YQdZ5zqJRgUuFe6eojzAQSbUwBgP8gvxbifa+7k5OToaM3POtpKyDkYlF5KvbFJLQd0EySW0re1BEDbtP+kz3U37vLRgG/0vSagZFAP7RXp/At79v+IE5ilcy4HEKsIHO5E6HNXRf8ALszgq0+dg3fTXvWbnzBnNb8F2wx1YMlY+KZN9DaLnqLhQ4lxZfRZgaICsHqJau+ZvmHSEHq8izPu9m55YOCVNhXtv+7AuZJoewOFCBG9rU8d/gSlFJoYUfFS/k005kRgugRHhsw2VsgwdxrJR5aibgZElswAS1+oVhf5b3NFPu8RkdJbhWtPSu+XE8E0ciIY3whSbV5AuG9+9/430ZV3tVOMSWw9rVZOo78rJuqF88L+DvL1Vzx7rAql4sRT+OG+tcGWU5f1d8MxAsBTej097LAvoLNbSXVuqK5Erbyy5w8J/pCI+EJa6Afrkshg2
 ar4bznoL
 BPuRYGLXXzCYBK8gdpAVIhOkomf94MAGwlMBkG9Bd1nCXhR8KdGTLcrakTwUMR7CBG1dv1PrfUE33ZQDjj6DSPZkgRqPV9QVPXVTnWL1YJP4VJqfrMBiOSkJlRLpmK7dTpMR5ARvfcd0OrrjkXfCs6bxshB2FvolO9lmVMpCEqLHqtR71XBi3HK/o1miuniiOSckU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series focuses on optimizing victim process thawing and refining
the traversal order of the OOM reaper. Since __thaw_task() is used to thaw a
single thread of the victim, thawing only one thread cannot guarantee the
exit of the OOM victim when it is frozen. Patch 1 thaw the entire process
of the OOM victim to ensure that OOM victims are able to terminate themselves.
Even if the oom_reaper is delayed, patch 3 is still beneficial for reaping
processes with a large address space footprint, and it also greatly improves
process_mrelease.

---

-8 -> v9:
- Replace thaw_oom_process with thaw_process. [13]
- Use tsk_is_oom_victim() to check whether a task is an OOM victim in
  freezing_slow_path(). [14]

v7 -> v8:
- Introduce thaw_oom_process() for thawing OOM victims. [12]
- Use RCU protection for thread traversal in thaw_oom_process.

v6 -> v7:
- Thawing the victim process to ensure that it can terminate on its own. [10]
- Since the delay reaper is no longer skipped, I'm not sure whether patch 2
  will still be accepted. Revise the Changelog for patch 2. [11]
- Remove report tags

v5 -> v6:
- Use mas_for_each_rev() for VMA traversal [6]
- Simplify the judgment of whether to delay in queue_oom_reaper() [7]
- Refine changelog to better capture the essence of the changes [8]
- Use READ_ONCE(tsk->frozen) instead of checking mm and additional
  checks inside for_each_process(), as it is sufficient [9]
- Add report tags because fengbaopeng and tianxiaobin reported the
  high load issue of the reaper

v4 -> v5:
- Detect frozen state directly, avoid special futex handling. [3]
- Use mas_find_rev() for VMA traversal to avoid skipping entries. [4]
- Only check should_delay_oom_reap() in queue_oom_reaper(). [5]

v3 -> v4:
- Renamed functions and parameters for clarity. [2]
- Added should_delay_oom_reap() for OOM reap decisions.
- Traverse maple tree in reverse for improved behavior.

v2 -> v3:
- Fixed Subject prefix error.

v1 -> v2:
- Check robust_list for all threads, not just one. [1]

Reference:
[1] https://lore.kernel.org/linux-mm/u3mepw3oxj7cywezna4v72y2hvyc7bafkmsbirsbfuf34zpa7c@b23sc3rvp2gp/
[2] https://lore.kernel.org/linux-mm/87cy99g3k6.ffs@tglx/
[3] https://lore.kernel.org/linux-mm/aKRWtjRhE_HgFlp2@tiehlicka/
[4] https://lore.kernel.org/linux-mm/26larxehoe3a627s4fxsqghriwctays4opm4hhme3uk7ybjc5r@pmwh4s4yv7lm/
[5] https://lore.kernel.org/linux-mm/d5013a33-c08a-44c5-a67f-9dc8fd73c969@lucifer.local/
[6] https://lore.kernel.org/linux-mm/nwh7gegmvoisbxlsfwslobpbqku376uxdj2z32owkbftvozt3x@4dfet73fh2yy/
[7] https://lore.kernel.org/linux-mm/af4edeaf-d3c9-46a9-a300-dbaf5936e7d6@lucifer.local/
[8] https://lore.kernel.org/linux-mm/aK71W1ITmC_4I_RY@tiehlicka/
[9] https://lore.kernel.org/linux-mm/jzzdeczuyraup2zrspl6b74muf3bly2a3acejfftcldfmz4ekk@s5mcbeim34my/
[10] https://lore.kernel.org/linux-mm/aLWmf6qZHTA0hMpU@tiehlicka/
[11] https://lore.kernel.org/linux-mm/aLVOICSkyvVRKD94@tiehlicka/
[12] https://lore.kernel.org/linux-mm/aLg0QZQ5kXNJgDMF@tiehlicka/
[13] https://lore.kernel.org/linux-mm/aL_wLqsy7nzP_bRF@tiehlicka/
[14] https://lore.kernel.org/linux-mm/aMAzkQQ4XAFh9xlm@tiehlicka/

The earlier post:
v8: https://lore.kernel.org/linux-mm/20250909090659.26400-1-zhongjinji@honor.com/
v7: https://lore.kernel.org/linux-mm/20250903092729.10611-1-zhongjinji@honor.com/
v6: https://lore.kernel.org/linux-mm/20250829065550.29571-1-zhongjinji@honor.com/
v5: https://lore.kernel.org/linux-mm/20250825133855.30229-1-zhongjinji@honor.com/
v4: https://lore.kernel.org/linux-mm/20250814135555.17493-1-zhongjinji@honor.com/
v3: https://lore.kernel.org/linux-mm/20250804030341.18619-1-zhongjinji@honor.com/
v2: https://lore.kernel.org/linux-mm/20250801153649.23244-1-zhongjinji@honor.com/
v1: https://lore.kernel.org/linux-mm/20250731102904.8615-1-zhongjinji@honor.com/


zhongjinji (2):
  mm/oom_kill: Thaw the entire OOM victim process
  mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse
    order

 include/linux/freezer.h |  2 ++
 kernel/freezer.c        | 13 ++++++++++++-
 mm/oom_kill.c           | 20 +++++++++++++-------
 3 files changed, 27 insertions(+), 8 deletions(-)

-- 
2.17.1


