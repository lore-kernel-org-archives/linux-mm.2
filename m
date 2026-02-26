Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE687FD8FD4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB246B0130; Thu, 26 Feb 2026 11:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37E2E6B015A; Thu, 26 Feb 2026 11:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232676B015D; Thu, 26 Feb 2026 11:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 095846B0130
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:28:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFB921A02D2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:28:06 +0000 (UTC)
X-FDA: 84487139772.13.62AC6B3
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6A04140006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:28:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf27.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772123284; a=rsa-sha256;
	cv=none;
	b=J/phE6CUaBQr6UwGuBR8CAqGs+BlJvfcljzFexw6lfIbkslNffGPQXOT295F5UMlr0t8mh
	kOx68ym76h9PEAXvCXFKOwjMWt0s7yNATmQ7A6teeCnnS6Ss/bAaa7Ix5fNevv5/OvHAOM
	Xw3XnWFwPT/jk0WTg/xOuySnTAK6F80=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf27.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772123284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=YwBcdQwUm/F8pLL5pdBTTW2WasGrtqPn+U7g8kxOV6U=;
	b=cMOWYmkDTotyYQZxOY54sv8VhU8vRA8oBgju0d7hCrZRxn4VvzMbkMAIygFHAejJtrqUK4
	ZHnj7m40jyjslqL+8QAcMZgKp/FVVX1UMgNfAeDQsU4cE1bmyamy9F6wKxC5UtaGsoryB3
	IwCc5hYQSxrmyguAKspDhtE9/gKESso=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fMH1M3lhVzJ467t;
	Fri, 27 Feb 2026 00:27:35 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 9AC1140585;
	Fri, 27 Feb 2026 00:28:00 +0800 (CST)
Received: from mscphis00972.huawei.com (10.123.68.107) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Feb 2026 19:27:59 +0300
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
To: Ilya Gladyshev <gladyshev.ilya1@h-partners.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R .
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Harry Yoo
	<harry.yoo@oracle.com>, Matthew Wilcox <willy@infradead.org>, Yu Zhao
	<yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Gorbunov Ivan <gorbunov.ivan@h-partners.com>,
	Muchun Song <muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Kiryl Shutsemau <kirill@shutemov.name>
Subject: [PATCH 0/1] mm: improve folio refcount scalability
Date: Thu, 26 Feb 2026 16:27:22 +0000
Message-ID: <cover.1772120327.git.gladyshev.ilya1@h-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.68.107]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A04140006
X-Rspamd-Server: rspam06
X-Stat-Signature: ngwap5bzn8y3tumyzkc1xt1n86f3yrwu
X-HE-Tag: 1772123284-644980
X-HE-Meta: U2FsdGVkX18edMVJZlWy1f1pXsIQUvWpSswiesjOvTlvnDtUkVd6xDHIqI0g3xC5CoxmJ7Ae6g62FhT4+kY9NwmvV/WNFLe4IIrAtNuPHsRYXQylW8PhMI3JJ0xGN7U223MRB4zyRiv/q0XBKQaaty7Nu8ZLVx2M8uWUuIF6bXwujhcvkgBQAnn9oYB7M5ttlP7J/1hJFWpN9NFFsx0tQVIaOhhQFpOUCUIJTvZA8ywGimb/aOoRwI51aNT+/iNrXnmcHeu7m+3TE+uctbtF3PhCT+RN+/JQUHYYHLCq9fud5xjVR7kwB/IQ85FXdXUY9IVJHTzH9HqHbFxnIGlncOW6Fm6LGKFFHoBPDRdsDh0otB5EBkHNn9MJWLogp0jZFJbSTB57GvsYYDM+GQrntVJo5apO7MMDfeb0M9Yk8c3OyZnZXEseXXSAkT/Hq0aXgTpvYbfz7aGQaQGFunkCtHAh6+FYvGlX5ebNKTHB1oivQJQY4sBD0wXltxGjTkKb72ogbjRkpTie04zaFDcSI1jzck6kijuY6dluDOdYm+4eN6KbSIx6S/tRwfCGL28aObEmyniNmprLwPnuZ3FPmSzxwNKlOu453/a6l7qM8jGrVgCePtgaUbF4/Scp+kHvymBVqNtwwx5nD7r/4WzNDOw8pJ85Aq7U5q84aLijgag9pilPjvs7iSHRrFq34eHebUr0nNHre6VaM84QZeM7iOFUHGCTVuLBbTLdazzbfx4G3yfpA4+45qknQiZSC3G1TUo+RhRQSdPTz1HBOqK22rxPHjyFBSWCSvBTlfOaaRQ1vBmwfByNo0k1fS68ERx2fUqqHLXNH3J8jZBo4q9J7bAqa4ZBn8QR9aaD3JAN0WbgMIdcGDKEJ5LuMT2jZkQDo9hoML21P/TpeIpVR0SZN5hNTxfTi3thJEIDoQhOyiknmpT2KTIhTqNxQ5oT+dgbg14r/VAs4AygHV+7roD
 ZP5RePtf
 aHN0O/EkJntf2YZMIPm1dlOaY/I4S7sOxIOSzhhyaelN8F9paJThYpOhYFnSp53ioSY91tfCe+toLlTkBoh4L6t3CmetNOz+pYm04v8faIoiDNsD3DBCM92MtC705J3FXcq+SJ2jPQmfXBGxuzsGQ+CeXjYX87vy5UcND8YYAAKfJzc8F5A8SH3ZTzMUpQ3fkFziPnegJ7YU7sqUpn84g14j5526A2LZpOYlfwqmxS+b2qJ6wuBLqypmNlX7Csh9OX1GivWcGpP2b/JshXW1aLlHdhuli9eSIDuWeRCovH5f0YPGPOpNQ3zl9fLqPinbZKzRriIUOzFWy+EU2qSwClkMqG/vXLYioobOb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch was previously posted as an RFC and received positive, but
little, feedback. So I decided to fix remaining drawbacks and repost it
as non-RFC patch. Overall logic, as well as performance, remained the
same.

Intro
=====
This patch optimizes small file read performance and overall folio refcount
scalability by refactoring page_ref_add_unless [core of folio_try_get].
This is alternative approach to previous attempts to fix small read
performance by avoiding refcount bumps [1][2].

Overview
========
Current refcount implementation is using zero counter as locked (dead/frozen)
state, which required CAS loop for increments to avoid temporary unlocks in
try_get functions. These CAS loops became a serialization point for otherwise
scalable and fast read side.

Proposed implementation separates "locked" logic from the counting, allowing
the use of optimistic fetch_add() instead of CAS. For more details, please
refer to the commit message of the patch itself.

Proposed logic maintains the same public API as before, including all existing
memory barrier guarantees.

Performance
===========
Performance was measured using a simple custom benchmark based on
will-it-scale[3]. This benchmark spawns N pinned threads/processes that
execute the following loop:
``
char buf[]
fd = open(/* same file in tmpfs */);

while (true) {
    pread(fd, buf, /* read size = */ 64, /* offset = */0)
}
``
While this is a synthetic load, it does highlight existing issue and
doesn't differ a lot from benchmarking in [2] patch.

This benchmark measures operations per second in the inner loop and the
results across all workers. Performance was tested on top of v6.15 kernel[4]
on two platforms. Since threads and processes showed similar performance on
both systems, only the thread results are provided below. The performance
improvement scales linearly between the CPU counts shown.

Platform 1: 2 x E5-2690 v3, 12C/12T each [disabled SMT]

#threads | vanilla | patched | boost (%)
       1 | 1343381 | 1344401 |  +0.1
       2 | 2186160 | 2455837 | +12.3
       5 | 5277092 | 6108030 | +15.7
      10 | 5858123 | 7506328 | +28.1
      12 | 6484445 | 8137706 | +25.5
         /* Cross socket NUMA */
      14 | 3145860 | 4247391 | +35.0
      16 | 2350840 | 4262707 | +81.3
      18 | 2378825 | 4121415 | +73.2
      20 | 2438475 | 4683548 | +92.1
      24 | 2325998 | 4529737 | +94.7

Platform 2: 2 x AMD EPYC 9654, 96C/192T each [enabled SMT]

#threads | vanilla | patched | boost (%)
       1 | 1077276 | 1081653 |  +0.4
       5 | 4286838 | 4682513 |  +9.2
      10 | 1698095 | 1902753 | +12.1
      20 | 1662266 | 1921603 | +15.6
      49 | 1486745 | 1828926 | +23.0
      97 | 1617365 | 2052635 | +26.9
         /* Cross socket NUMA */
     105 | 1368319 | 1798862 | +31.5
     136 | 1008071 | 1393055 | +38.2
     168 |  879332 | 1245210 | +41.6
               /* SMT */
     193 |  905432 | 1294833 | +43.0
     289 |  851988 | 1313110 | +54.1
     353 |  771288 | 1347165 | +74.7

[1] https://lore.kernel.org/linux-mm/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shutemov.name/
[3] https://github.com/antonblanchard/will-it-scale
[4] There were no changes to page_ref.h between v6.15 and v6.18 or any
    significant performance changes on the read side in mm/filemap.c

---
Changes since RFC:
- Drop refactoring patch (sent separately)
- Replace single CAS with CAS loop in failure path to improve
  robustness

Based on quick re-evaluation, this didn't affect performance because only cold
code was changed, so I kept RFC results.

Link to RFC: https://lore.foxido.dev/linux-mm/cover.1766145604.git.gladyshev.ilya1@h-partners.com

---
Gladyshev Ilya (1):
  mm: implement page refcount locking via dedicated bit

 include/linux/page-flags.h |  5 ++++-
 include/linux/page_ref.h   | 28 ++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 5 deletions(-)

-- 
2.43.0


