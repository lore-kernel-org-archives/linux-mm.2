Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3538CAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415178E0012; Mon, 15 Sep 2025 12:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9CE8E000E; Mon, 15 Sep 2025 12:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9AB8E0012; Mon, 15 Sep 2025 12:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC2928E000E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:30:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B985E1DF358
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:30:01 +0000 (UTC)
X-FDA: 83892021402.24.78DDE68
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6DFF8C000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:29:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=QyiWEnFU;
	spf=pass (imf28.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757953800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=r4ridvdVFjNgW7hlKtSiyRIVq3lyiXCccE9PXxhmbvk=;
	b=4zyv4/aCYo0i539zJYyRZCpLBXs5sEfiXNklxsPnBz0by+F/dmyntk9+PsSvxtk905vIwF
	a1IF8wIRkc1rvDLD+qnhqbz7yQyUpOnm3jYyR6KR1/EQPDXZOlC51mO4W+CxvqZYckHlUv
	mWveU9ut4+xJ58isjPdHoBRHqYw8PmU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=QyiWEnFU;
	spf=pass (imf28.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757953800; a=rsa-sha256;
	cv=none;
	b=kq7F5UjqlrnsDkw1nmZivvY5GYyoqvvDNVOCdjqfolU4yzc9rWLjFPaU9Kz7cqTAlLucDX
	M2mNImGdNl1C+to2pa+lx2TNJFp6K0ZcvRTG7or2/i4j+yYYFMbknyUiPLSH/z/XISfcy7
	/PKiR18Q6H35d73wu5nrzhfpxlHqUP8=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=r4ridvdVFjNgW7hlKtSiyRIVq3lyiXCccE9PXxhmbvk=;
	b=QyiWEnFUV/ExnSYALnvXb1M/jH8oiPiNC1VRhLS2ogMGSlqwovaMjMYk3mO8z5goVoYM9XXVn
	MIlc4NWH4ivtQtXXb1kuxR6C2sP5BMFuxIsdrQ0nYTQQV5niNokdDW9EWHscyE620HzP1rNAjDK
	bMSjjX4CJii+REUiuBkMhV8=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cQVqH4r1rzYlBF4;
	Tue, 16 Sep 2025 00:29:31 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 16 Sep
 2025 00:29:51 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 16 Sep
 2025 00:29:50 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v10 0/2] Improvements to Victim Process Thawing and OOM Reaper Traversal Order
Date: Tue, 16 Sep 2025 00:29:44 +0800
Message-ID: <20250915162946.5515-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 6DFF8C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: 6abch4efurnunb6sx4wkd9jg184h3nzf
X-Rspam-User: 
X-HE-Tag: 1757953797-273819
X-HE-Meta: U2FsdGVkX1+2FZVgY95m1NLwWBMUMHgP1/xqHpidQD6JhkvPddfZJt0E7ht1aIWxOExJq2MOL+ryh9otYi1e1aob3PV+U6WIlevRwNfpwTJDuKrFnZAw0sshjw4O1pXmDXFcXbYggVfYLCg6R+22w27vdV+T+98vpxuECK50C7Fh51DTzIce7TzG7+ZnfMvWh677dwiYOYUQi2EZQ34OVMW3AE9WvqIZpx2rKrkDsXltX5xgShgTuuzx34fesD0YnyAdCaxNljNAdCcNEc5V3WJbEnKj1zzZif0i9+P2IxDNp8lK3RJggCu3BtNB1NcZrdRs6lVUPcljohUHkRLeSZc4fcfb/uVmhziZleCwNowhdjmcRqFoWufLnKUPSHVHtj22tfDrgZ67EQbPjRs7Lyz2ZZokQvg/Wv3hhDjvY6iHQs2b9XRqS1F7ty6Lw7JQdGZnmX5BhNogyWK96Mlr4OIbTqk7YttSMi+ezmBn1hHB3gXKn/uNApsnV4E/sNDRT3zln7sXkLh7tasOkwzOAWk6r2VF9eexXIqGTfAu/suT9xCnybnCJI38GbqilWWb9wU5HMBkZGnJoue9dtq53oPBAkZ6o6kfcoMCJCWLzGNAtTfPlp4YjU41c09eGVRS/cD4ngQP6lfHbXbHqhZNVwC0wOM1aRt3zhOu8S4YTFRqo7l3hpMSwmFpkb5sansFZ7Sa9QYPNqNezPl+2hfu8kHprEvB8JDNtGaRPUAu8soG2quibsRa4HHN6av1pO3LI0OOk8ghjzUIzUmXTUeuDSWI4SwNTaxlfHvXLMd4+ARCfs1vF1r92uabS7VDLhCk9L+3csvwcFulLjXWskHRy1uhF5me/U2H4b5uZz7h+RCMD0Nao78Pv+zgq0WVZzJGhJPe/5HR2Iz+N8IqkBHqJIvixNE3qoID58mgOp2YH4YchrkQwkD8MExMNroQvJysAy81na6cuHe3Ga8YbP3
 BYMR8ymP
 q2hODE6cUG5Yz7NNV83fVk0Qw+MtyImn7hhvypD683lUQnjnsZASzZHj8Dh3x3L2fdzsfsWtd1ahsXnz9oZyxRcXfpZuuJ8rLSo6cCaGvo04q1yjn4Ayo5JaCZ0rwGupNM3dDm87urALiqjMhFpKCBjFFgeSuBkGmrshZix+ccAxRCDur/qzFWccDOPdz3zhFULjBq8KFQdPO4ZB44wY1YB4nRDhw3Fk+GkY62OwYLf2iLOPjNKB8U4fAaSwdgy7STycWQhpccDB0fWcT863rANKkbbCsBPPYPvql
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
Even if the oom_reaper is delayed, patch 2 is still beneficial for reaping
processes with a large address space footprint, and it also greatly improves
process_mrelease.

---
v9 -> v10:
- Just update the changelog. [15] [16]

v8 -> v9:
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
[15] https://lore.kernel.org/linux-mm/aMJ619kjFm00c4OP@tiehlicka/
[16] https://lore.kernel.org/linux-mm/aMGWAg5jIitYCXdZ@tiehlicka/

The earlier post:
v9: https://lore.kernel.org/linux-mm/20250910143726.19905-1-zhongjinji@honor.com/
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


