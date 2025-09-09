Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26BE2CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8608A8E0018; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811B78E0003; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74EF98E0018; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE4A8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 390AA140420
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:10 +0000 (UTC)
X-FDA: 83869132620.28.35816CB
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf26.hostedemail.com (Postfix) with ESMTP id B3EF2140008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=EXv88COtDaAhz40DpOLvYvNrw8zgCGqnXrvpci+wSw8=;
	b=RDQY0zZmwXe3dFap5mpB59x8z+xl4lBrfOiJhaa6OsQ5ReRAoGyzpKA3pNVmHzoksGHcsa
	PA8f+35z52nHjmZbzxAYfudKjntHni9C95KKBZYf/Zml96NVkzkZeQCAy4xeJoCqJifq75
	v21SJP7nMItCT7gPy7nHF3P1x3zwWIs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408828; a=rsa-sha256;
	cv=none;
	b=KwMgPYj1+rTdY2jgPMvabfUlWBoKLlDWhTg+/TJdTO0jiSTffJVITS2CT6oxCLa1l1LdLS
	Nv1eAaybH9UqQVuc5vjK0g9M+1hM7lBfAB2Vmju/91Ly3OfdUzrM5HZjYuP31IGYDmr27i
	1GcB8exQ2WjHLBTGefxPOB9m4NSjdSM=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cLdH210r7zYl3P3;
	Tue,  9 Sep 2025 17:06:38 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 17:07:03 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 17:07:03 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v8 0/3] Improvements to Victim Process Thawing and OOM Reaper Traversal Order
Date: Tue, 9 Sep 2025 17:06:56 +0800
Message-ID: <20250909090659.26400-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3EF2140008
X-Stat-Signature: 6686e1ktkrih5bfhjcoz7e6opqp6dsz4
X-HE-Tag: 1757408827-571370
X-HE-Meta: U2FsdGVkX19QVbqlNo51Bmy6TL11YhQ70Igx3r/O1r6YRn8/qly7lun+u6hjzxeQdexSWI99lje71N3x07Ki5PgiW+Mj72orvZ/kxkw9lQXqxgoA5Gl6hdAWrlm4G/Wv3w5RMnATUnxc+cgiTIm1L3u27GljviKgbyCiU6qojaMj1/cGPyqKda462+7huo64iRdtW2reHk1eV3rfbOxUIBaaEGIQ8S6q4fPIMtd7Az5vmO+vKVuizboLpv6wiQvn/K1xPtgCNmFTOffp+E47mfnrkilKfjcPy8GRoLvrVDZJXXfNSxHIpl0mv7WhcqGHzqxOyJ/jsrskZimwX0TRhkh1ZaSQETVLjEZfmSmERY7dWwF5Fb0wo4hRaBE3Zvh3mz6GG9/s0F/MlwQTEixMHfqDwWJ6QxpB4Y6JbiuAwKxF361n4VpU9300BLQzjMPYfofk7/onMzRffRoX6kgvXESOsMNeYSeX1IRDnfTZIJq78qa54dwXMHB43DTDrCcD9cVWD1yK6UgWSYNS0wbZvYOJT9mVcE+ZC+CJpL6ASo1eqFhfk38dLc2UFHQB/8q/socW+kCMtgcIvFCwCOm1NuAaM7pUZaMAZfrs1bqQupDDdC5Lmouf5IY9tmFzQ7Irmytw/lCLto2e8+bI1Bq67nqXCs5HLZy8TYDcUuGkU0fKTQjZnmTkrDKomiubbJJ3HHAz+vZylkvRxv6DTkUN0XoDBsq9h92ZcAt6L8EsxB5ZkT/wp3n38sjg2gAM1uh9NOkpSRCmFlPWHJTVZKPPZQ6qEFozijBWdSXJLGdedKj00MbWwGv+o//cW3YWK8RmzloROaVfIZuDrRYYpMHt1XxiXiq4t3HvVPx7W+RPOzu7XdAh+rbpKJ2WI2XQ/t2G58RvOD4YwmY8ANj7dsfQc+CEAImuvgaa13DLG0QU/j+T+UEHz6sK+uuISsK+6mzzIOl9gzC3GK2CxTo+0xc
 4re8MVDD
 wAbOgv+B7Gub7w2uDZW/OaRlw14SgKQygn+uUwvzATJNXvBoMcKaumTd9rj/HSz63pguqQ419vloadszRNnFytqKsKtGgop6deIJywMFCqNsPxsPGlYkYZ4E1G3qr0FDqD9KusdiK7bGvVqPhEdrlKas4L32KDFtJ1jpnzh02Ork6dM+8yBZeeMtDtc8daF5SADXD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series focuses on optimizing victim process thawing and refining
the traversal order of the OOM reaper. Since __thaw_task is used to thaw a
single thread of the victim, thawing only one thread cannot guarantee the
exit of the OOM victim when it is frozen. Patch 1 and patch 2 thaw the entire
process of the OOM victim to ensure that OOM victims are able to terminate
themselves. Even if the oom_reaper is delayed, patch 3 is still beneficial
for reaping processes with a large address space footprint, and it also
greatly improves process_mrelease.

---
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

The earlier post:
v7: https://lore.kernel.org/linux-mm/20250903092729.10611-1-zhongjinji@honor.com/
v6: https://lore.kernel.org/linux-mm/20250829065550.29571-1-zhongjinji@honor.com/
v5: https://lore.kernel.org/linux-mm/20250825133855.30229-1-zhongjinji@honor.com/
v4: https://lore.kernel.org/linux-mm/20250814135555.17493-1-zhongjinji@honor.com/
v3: https://lore.kernel.org/linux-mm/20250804030341.18619-1-zhongjinji@honor.com/
v2: https://lore.kernel.org/linux-mm/20250801153649.23244-1-zhongjinji@honor.com/
v1: https://lore.kernel.org/linux-mm/20250731102904.8615-1-zhongjinji@honor.com/

zhongjinji (3):
  mm/oom_kill: Introduce thaw_oom_process() for thawing OOM victims
  mm/oom_kill: Thaw the entire OOM victim process
  mm/oom_kill: OOM reaper walks VMA maple tree in reverse order

 include/linux/freezer.h |  2 ++
 kernel/freezer.c        | 19 +++++++++++++++++++
 mm/oom_kill.c           | 16 +++++++++++-----
 3 files changed, 32 insertions(+), 5 deletions(-)

-- 
2.17.1


