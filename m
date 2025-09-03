Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A376ACA100C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5A56B0005; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7448E000B; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB618E000D; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5650D6B0005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:27:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F22EC1DE0DD
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:27:40 +0000 (UTC)
X-FDA: 83847411480.06.E26B3F9
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6875D100005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:27:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf05.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=FCc7vpUMpqgvyHAAPU1XNcL3mIAEmXCb2QqNaqLvmj4=;
	b=Ir5x2uWdXBtSw1ghkxZU8/NJ+PdqF+mc5Hk2LaqvgUJXkkcKEEJB2WGctDuQLR45THo9yC
	sBRdprhiK3EOiJgzv5BoFvjyD1hjZki1T/6vfz8JPzUQbj6WMXEQ6DXSNqoFmbBzgB610k
	f2IFYES9b6cjXqvMH9V08Fz0q7qNC6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891659; a=rsa-sha256;
	cv=none;
	b=BA0aKLBmVoHXkZXNHY3ejO1gK8W1lB27vQYyLZuQffqxEzbxxrN3yyOOW2sgwENk2VDHCU
	qASJ4UvABg0RYpERRcZ6eJ1BgbygmqpmaNhgNLZYMKiOimzXgaSmwEJZo1OY1qto7TUxET
	DE9fWb0fWtuLuCMEz/RgpuGpoqhDZok=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf05.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cGy1X3nKbzYl7mp;
	Wed,  3 Sep 2025 17:27:12 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 17:27:33 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 3 Sep
 2025 17:27:33 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>, <surenb@google.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v7 0/2] Improvements for victim thawing and reaper VMA traversal
Date: Wed, 3 Sep 2025 17:27:27 +0800
Message-ID: <20250903092729.10611-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6875D100005
X-Stat-Signature: s95gr5gufhxm8emrcitgt9obtnxtix7e
X-HE-Tag: 1756891658-795308
X-HE-Meta: U2FsdGVkX18BbNqWB77yeDQvzWxCsw6RONszZn5BxWApZPRQOebDxyZOmgGRdtdjlt3iYnNSEil3ZSy7QgDFN4jUlc26vLI1GiQEJ3MpYjeld/3M9lW+y6q/SD3BnXBmHoMfG9xkgeVLOMOsaegZq22o5pxnV5JhsavqHymbDagCVAdbyh3iFPdnrgU1knZ1vvE7SPscK4TI39SRwG6kui9BkRt6ClS+s6+PSNVFEk9Yp7t+MBK077F+kGy6coeb8n83HJRpfHs8WOKdeplsQkMLV/9u1IXTuHTTswfJIxvxE7QExvGRj0MT8bmT1FMH8lEEhdORXF18w7QWJBprzTeTJD4/VM08IDJqod1gPc7p3IQkLDLhhtC6qVki0OHgG/0NaGaVaWHFvC/c+W1ft3prMF5sWvjifI6fV22g79NwoGYygf9/enZcRMcN0nLb/tjAH85PRpZw7uJYfBiMXn0jgxaJbz6w1iNUTnlxadSzmbxVnBcwOyhc3ED0GidD1MIhkLIBd8X+T7mKo2sDEWBa/s3AdgM9ER4kBtViScg22uujLceYyZPsC6rT5AhE/i5lTmgHVW9vTHVosaSrkR/IrZWHvkpfZMljy0svxt4jN8UHRlLM5oc2A4mbG72hXAhtR1XQWFiL0TnRDQRqrVqiE15jbm5njznJOdUfNsBeaZiNNSx9PAjKJq+jgTUcqMstZU1fgXJcMI90O2v3Q/UJFbooePk2mVbP0GGp5jemlTTBQ79XAExO/YL2GFRMmjmBf7STANGua0PuJ8xVhNMZI0YgRrRbqdauaasqVKkWwxy9Aue+4/KbAFjXSRi9zelR4HE4YTz6pbZBimZCiLteuife9qbO2ZwX8Zge94Y3jORTnnJFDLz92ZQ9BkOXDTjxN8CL5NItxd1/RqGZr1FOAMlTtR2Ps73l0x3ooBCbdCZa78XV4OvcFbaHNp2SZkHMjAwJTkeQkJTI0HD
 0zzuqV3s
 Bk2biExEeLM9FZhzNndg2drnYcxrvdhNt6u7DOyum7PnojoGpQOW/Ma7hIoPKnB4fzTT2VxIcvFdrID7/J+277fjVk0Om8iNiOdyRciIE4l4eM03Ev010nhxpjAwB+RPeuKozijq5MzWY7blCIK5EQ+QKc1ziEOJfeBAGn+FjGFfoJDwayxSeNTqYnIo3/h4kEakM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is about improvements to victim process thawing and
reaper VMA traversal. Even if the oom_reaper is delayed, patch 2 is 
still beneficial for reaping processes with a large address space
footprint, and it also greatly improves process_mrelease.

---

v6 -> v7:
- Thawing the victim process prevents the OOM killer from being blocked. [10]
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

The earlier post:
v6: https://lore.kernel.org/linux-mm/20250829065550.29571-1-zhongjinji@honor.com/
v5: https://lore.kernel.org/linux-mm/20250825133855.30229-1-zhongjinji@honor.com/
v4: https://lore.kernel.org/linux-mm/20250814135555.17493-1-zhongjinji@honor.com/
v3: https://lore.kernel.org/linux-mm/20250804030341.18619-1-zhongjinji@honor.com/
v2: https://lore.kernel.org/linux-mm/20250801153649.23244-1-zhongjinji@honor.com/
v1: https://lore.kernel.org/linux-mm/20250731102904.8615-1-zhongjinji@honor.com/

zhongjinji (2):
  mm/oom_kill: Thaw victim on a per-process basis instead of per-thread
  mm/oom_kill: The OOM reaper traverses the VMA maple tree in reverse
    order

 mm/oom_kill.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

-- 
2.17.1


