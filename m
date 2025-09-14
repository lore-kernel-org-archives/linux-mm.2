Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6BFCAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 10:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45A58E0005; Sun, 14 Sep 2025 06:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CE28E0001; Sun, 14 Sep 2025 06:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32638E0005; Sun, 14 Sep 2025 06:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF47D8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 06:00:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06BA7583E1
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:00:46 +0000 (UTC)
X-FDA: 83887411692.06.3C2C5B9
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6C19180010
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:00:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757844044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=tAW0TLDh99b9//Vk1JEJswDJq7gaibIGtG/lQEhiSO8=;
	b=AJcV+8dcHhWJ30TjFDnxGW53RUljvbElzgQMtDqcapRaFMYIJ0EeLnnTzMUEW12cSIBYS6
	1PWVclU5sQ2EYgmf4wH9qUd4U9yJx4FZdPW+YgA6NEftest7vQa574J9ch0C+JjBn+U96y
	KYVmrHA+7ThMmmZfBJuDS8uq+64Apsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757844044; a=rsa-sha256;
	cv=none;
	b=gSa20ohECVnhSharZAMUuKGKfHUks2in3rsPHpCwZ0nWk+ngBNRSyyRQDBegOEGyvctBqE
	UUY2i0/H8Kb+/IwBY2KdAiufEeF6uR0MAwhq4jV2bz0asxLIfiAkqMKlP+xlUmY+2XNP/z
	64rv+KotAckwKRL6kOoTVpXhTMr2Ofs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cPkF26HF1z8Xs70;
	Sun, 14 Sep 2025 18:00:38 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 58EA0U06091794;
	Sun, 14 Sep 2025 18:00:30 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 14 Sep 2025 18:00:31 +0800 (CST)
Date: Sun, 14 Sep 2025 18:00:31 +0800 (CST)
X-Zmail-TransId: 2afb68c6923ff12-45441
X-Mailer: Zmail v1.0
Message-ID: <20250914180031197jk6ngo5pQjpXkNtNsjzSo@zte.com.cn>
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <shakeel.butt@linux.dev>,
        <hannes@cmpxchg.org>, <mhocko@kernel.org>, <roman.gushchin@linux.dev>
Cc: <david@redhat.com>, <chengming.zhou@linux.dev>, <xu.xin16@zte.com.cn>,
        <muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDAvNV0gbWVtY2c6IFN1cHBvcnQgcGVyLW1lbWNnIEtTTSBtZXRyaWNzwqDCoA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 58EA0U06091794
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 14 Sep 2025 18:00:38 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68C69246.000/4cPkF26HF1z8Xs70
X-Stat-Signature: j985gbogqnq7gr3xeegqzqckdcsnun8b
X-Rspamd-Queue-Id: D6C19180010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757844042-745700
X-HE-Meta: U2FsdGVkX1+zeZn/Pi1lWENMrhFvXYIHrhPMAd4opOQ9kjDTTjAEGl/1emEJGaAa2hMo6JkpOcfFfWygKLiipn7CHQSHEEy6bOZsfgqEhMm4cM2jsuvxTno2Oqacadse3rVsOOSFKDWIkgW9JQ0plnznMEwDZ0UIRr3JsUESCuPkiVok2tiIjcZUqmQgfl95T9kP7MEgA70p5Bk3/hXIvWZsmNRrMD9xTCdVMf0iNQWBJXVkH3olS4t7SiOpJTNAtDOjh2wM+aSpi2V5+TVrGZLs9l4wl0zvTjrfr4KDyqzogOlA5q1XxroaiWweuUXOLu7ZoEDO9u4lEpFlGhy21crsQ60LpXlRrWumdsVmzDxe9/CBoOgkMp5bfxOQ7mXLCk2ZR0lUSsSoznEpq27jg2l8eeZPfDD+H5eR8G0KnvurNmW2AKIz1PO8e2iqwuasydv/AuJaWT3RUzHow1ZQ6jD1DVmih5tz+vbeIadNUJp9CI/10wDZJ5NOPrILkBOYlAwpC1AT4sKOlMt3bP0dTr8Df8jbpZ3gPaE/GZKZMTYpSyM4QBTd/GQUhrwoWPWA+KXGcimHGrShp32XK+jXdOBWnMy7vz0AdNfO44D1fuAJ7mjCZSV9Qh4OD5z3NrWAqG/1ZKkewmkQ+N2l7P+ofXsIqOSdijFBj8/O9VOhhXMgUSnNDGuZZ9VNpCWs7lU4MdBpKbnzWz8Mi5QXNUDiQvhyIPDbTh5CVN85M8ief5yDofw0dAKB+AJsBEh0CZFDpdfciQyRaDWwESthGBqUiGEfU0xB/lXneWyZejHdVPLHhfHgigjei2UglH06srRGUJs5wv9zw/muP980aw45WvmYh2zUVas1x/WXuM18aQXTUBZ4Auqbi3S4NgrVUeLJFQYmAgTu1CLP27gQKdMROgVQExhRWCJeUJqV8Uj9yfRP9/nSBYEWTqaQNc8aTmUlL4w6YsXZkd0zoI6UFDZ
 Rog8x8Z2
 KwNeWHhZOBMANqiMLh7MXIWZKhRatdZ7FhqnnxX0T8X18Qsa6PiOnz24NV1Fg37D6trNha20zi48e95gonOyUKqWpJWuwXPHpE7IbdFriZMqoG3filXfHiD5gBBeCn/ofI3iMNsRszXXk7zrMxkAqtAN+5U+VqIGY/UihJOscCQ/cxgbTfKghcqJRgekp82ZtGpnB59bTJDxY5Sw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Dear all,

This is the v2 of patchset, as Shakeel suggested:
https://lore.kernel.org/all/ir2s6sqi6hrbz7ghmfngbif6fbgmswhqdljlntesurfl2xvmmv@yp3w2lqyipb5/

With the enablement of container-level KSM (e.g., via prctl [1]), there is
a growing demand for container-level observability of KSM behavior. However,
current cgroup implementations lack support for exposing KSM-related metrics.

So add the counter in the existing memory.stat without adding a new interface.
To diaplay per-memcg KSM statistic counters,  we traverse all processes of a
memcg and summing the processes' ksm_rmap_items counters instead of adding enum
item in memcg_stat_item or node_stat_item and updating the corresponding enum
counter when ksmd manipulate pages.

Now Linux users can look up all per-memcg KSM counters by:

# cat /sys/fs/cgroup/xuxin/memory.stat | grep ksm
ksm_rmap_items 0
ksm_zero_pages 0
ksm_merging_pages 0
ksm_profit 0

Q&A
====
why don't I add enum item in memcg_stat_item or node_stat_item like
other items in memory.stat ?

I tried the way of adding enum item in memcg_stat_item and updating them when
ksmd manipulate pages, but it failed with error statistic ksm counters of
memcg. This is because of the following reasons:

1) The KSM counter of memcgroup can be correctly incremented, but cannot be
properly decremented. E,g,, when ksmd scans pages of a process, it can use
the mm_struct of the struct ksm_rmap_item to reverse-lookup the memcg
and then increase the value via mod_memcg_state(memcg, MEMCG_KSM_COUNT, 1).
However, when the process exits abruptly, since ksmd asynchronously scans
the mmslot list in the background, it is no longer able to correctly locate
the original memcg through mm_struct by get_mem_cgroup_from_mm(), as the
task_struct has already been freed.

2) The first issue could potentially be addressed by adding a memcg
pointer directly into the ksm_rmap_item structure. However, this
increases memory overhead, especially when there are a large
number of ksm_rmap_items in the system (due to a high volume of
pages being scanned by ksmd). Moreover, this approach does not
resolve the same problem for ksm_zero_pages, because updates to
ksm_zero_pages are not performed through ksm_rmap_item, but
rather directly during unmap or page table entry (pte) faults
based on the mm_struct. At that point, if the process has
already exited, the corresponding memcg can no longer be
accurately identified.

xu xin (5):
  memcg: add per-memcg ksm_rmap_items stat
  memcg: show ksm_zero_pages count in memory.stat
  memcg: show ksm_merging_pages in memory.stat
  memcg: add per-memcg ksm_profit
  Documentation: add KSM statistic counters description in cgroup-v2.rst

 Documentation/admin-guide/cgroup-v2.rst | 17 +++++++
 include/linux/ksm.h                     |  1 +
 mm/ksm.c                                | 67 ++++++++++++++++++++++---
 mm/memcontrol.c                         |  5 ++
 4 files changed, 84 insertions(+), 6 deletions(-)

-- 
2.25.1

