Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2605BCA0FFE
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 06:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B156B0025; Fri, 29 Aug 2025 02:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1671D6B0022; Fri, 29 Aug 2025 02:56:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83D16B0026; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BEF0D6B0025
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F32A13A19E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:56:03 +0000 (UTC)
X-FDA: 83828885406.13.F2BC51E
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1497F1C0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:56:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756450561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=XW9PFPzWChMOL+5q0zRePNZhWLhwsTyzit2otTsPSRc=;
	b=AoHA/CQugD4R+XgpRnn1p/T4bMULu0WQFBlIS+zAIC7uhQkJhknkN93a9DKu0khRtCnQYn
	KCTys39dOafYgZ2kfFeX0rNxqBgUrzfqhYN/fs5Cwt6u1ricrplO/uXeL4SHJTEDSnETvB
	U6KqIAHySuY+M7mQy6ylP/4VIU0KToE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756450561; a=rsa-sha256;
	cv=none;
	b=B2iN8aOKwkiLlBqdg79C5wMUHgVdGc3LwKGKXxmXkSmInqyN846o7T83z0yzPLZibJxS1W
	sPYAiUDiP5TC/6b/H3fOkUvXB93nD/Qg1JpqN6q9SaRGnfMGnVB1CCRIxSwCplf00wshjV
	9AA6YTcEVzorhJ2wh0U0W31RJ947LMc=
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cCptx4dPpzYlK91;
	Fri, 29 Aug 2025 14:55:37 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 29 Aug
 2025 14:55:55 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 29 Aug
 2025 14:55:54 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>, <surenb@google.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <tianxiaobin@honor.com>,
	<fengbaopeng@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v6 0/2] Do not delay OOM reaper when the victim is frozen
Date: Fri, 29 Aug 2025 14:55:48 +0800
Message-ID: <20250829065550.29571-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 1497F1C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: k568fc6jxa9559wibth939dxg36pjptw
X-HE-Tag: 1756450560-82201
X-HE-Meta: U2FsdGVkX1/8R49YQ01cgg1Mfiq2g0d8rLpsjOLpRK1l+XtWaUn9qhpfZx8gYZgZnf925/+jo6s2ltJDliyQgHdQyxSCuXFu8k2nqxPA1PpUyl+1EwkS9Q4BQ/b805Uld9QvlblAMu82nJyib3L2LkwyewMT2DiO41vSazDgVYVsW21U8o982kGl0NI0OLe3ZXacaZ/duqXJyIQ3a7CnSG7iXib/3QSpGrSOYdIWEcPPE16zM2CyfTMN6L+WlXJFT3HMauQT36tUlPQoiA4Nqkn9PXO5oDCzlmNlXBocBF5e16f71bQXqX251OA1Y7hjV4Kgdv8nx2L7wNmg1FBSRpLDn/7oroLVdnj28ZM6IVLoREnv+mc60yoiRR0sSXeA9uIpotPICBBrKIe26JD5qxugnyj46JN5ddTXew+Q0znbSEOIMmeTy8RzFOwAq22BKvxpBi5lqIFvWjiO0cBPQdN9fpIS+55TfAgnCxTk5oRFdWLELlSTQmf5Alr6QjPNw97i1zui9tPy3YI+rHUMTMrKoSuuzWIbzArj5uECdxRktFFBoNR3kdGnuS7EWaRcyqYwX795G37RsdRbcLHf4SmOWav1kHqBBVg3B9vXHZRQuHTRJFk9XpmuLqLvpzBmo66mRJaJ6YBmXKSN9RA+tAq7IK3jpNTcS2Tguu3oQu/rgmEoMAhiMKgMZx87+Rfa+ITkL57D4ZAlbkCf+HeHacJoGMemjdeBQ23iEbURl/ijcDjmWj2p4BhZEqCoXXOC3adQw6drWiRuRF3Nv1Uc+8BLFjeKWxe+32OJIqy6VTB2KFPZTy/VImkLaRx8byo1KYrEJMxpCv0KQU+M8Ps0ISNf6PqagCkLOayfY3nldFAXYl8X3BubuD7F8IaYF5ZnVDsmBiVXCXvdLCIQI4nQbHl6Jf55C8SZOz+ikSfdYmZJZ6Ur6b+zpsVa1+jvAhaXFeh76e1A1CBvVskz8hf
 v24bIi2b
 cga9YaJ0lbfQ9kIC4+4VsZCxeuxKMcgVYVAt+/aDKTIaXiBeSZiKgK5vNif8JyDe7B5ES92ZICeNkxL3EEFdVssRiFqoqXnVR9/o+qKQQqpwMBAp0R6FOr5zKAgZmpb2zfdgW9XXuyQoxLmGP+xWQJ5aNI6NC6xVSj8HwIMi0RUZMpPJZ3tjwenwCKF7GWS5JwYod37M68rxo/GVSPzCJmxH5nu+g9h4/gXlp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An overview of the relationship between patch 1 and patch 2:
With patch 1 applied, the OOM reaper is no longer delayed when the victim
process is frozen. If the victim process is thawed in time, the OOM reaper
and the exit_mmap() thread may run concurrently, which can lead to
significant spinlock contention. Patch 2 mitigates this issue by traversing
the maple tree in reverse order, reducing the likelihood of such lock
contention.

The attached test data was collected on Android. It shows that when the OOM
reaper and exit_mmap are executed at the same time, pte spinlock contention
becomes more intense. This results in increased running time for both
processes, which in turn means higher system load. It also shows that
reverse-order traversal of the VMA maple tree by the OOM reaper can
significantly reduce pte spinlock contention.

The test data indicate that it can significantly reduce spinlock contention
and decrease the load (measured by process running time) of both oom_reaper
and exit_mmap by 30%.

The perf data applying patch 1 but not patch 2:
|--99.74%-- oom_reaper
|  |--76.67%-- unmap_page_range
|  |  |--33.70%-- __pte_offset_map_lock
|  |  |  |--98.46%-- _raw_spin_lock
|  |  |--27.61%-- free_swap_and_cache_nr
|  |  |--16.40%-- folio_remove_rmap_ptes
|  |  |--12.25%-- tlb_flush_mmu
|  |--12.61%-- tlb_finish_mmu

The perf data applying patch 1 and patch 2:
|--98.84%-- oom_reaper
|  |--53.45%-- unmap_page_range
|  |  |--24.29%-- [hit in function]
|  |  |--48.06%-- folio_remove_rmap_ptes
|  |  |--17.99%-- tlb_flush_mmu
|  |  |--1.72%-- __pte_offset_map_lock
|  |  
|  |--30.43%-- tlb_finish_mmu

This is test data regarding the process running time.

With oom reaper (reverse traverse):
  Thread            TID     State     Wall duration (ms)
  RxComputationT   13708    Running   60.69
  oom_reaper        81      Running   46.49
  Total (ms): 107.18

With oom reaper:
  Thread            TID     State     Wall duration (ms)
  vdp:vidtask:m    14040    Running   81.85
  oom_reaper        81      Running   69.32
  Total (ms): 151.17

Without oom reaper:
  Thread            TID     State     Wall duration (ms)
  tp-background     12424   Running   106.02
  Total (ms): 106.02

Note: RxComputationT, vdp:vidtask:m, and tp-background are threads of the
same process, and they are the last threads to exit.

---
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

The earlier post:
v5: https://lore.kernel.org/linux-mm/20250825133855.30229-1-zhongjinji@honor.com/
v4: https://lore.kernel.org/linux-mm/20250814135555.17493-1-zhongjinji@honor.com/
v3: https://lore.kernel.org/linux-mm/20250804030341.18619-1-zhongjinji@honor.com/
v2: https://lore.kernel.org/linux-mm/20250801153649.23244-1-zhongjinji@honor.com/
v1: https://lore.kernel.org/linux-mm/20250731102904.8615-1-zhongjinji@honor.com/

zhongjinji (2):
  mm/oom_kill: Do not delay oom reaper when the victim is frozen
  mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse
    order

 mm/oom_kill.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

-- 
2.17.1


