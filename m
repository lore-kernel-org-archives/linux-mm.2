Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E27C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C7C6B0153; Thu, 16 Jul 2026 11:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613A86B0154; Thu, 16 Jul 2026 11:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551136B0155; Thu, 16 Jul 2026 11:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 339866B0153
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:34:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9F1F160113
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:46:36 +0000 (UTC)
X-FDA: 84994311192.21.4D0EDD9
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id CFC40120007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:46:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="HdT/UraE";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784198795;
	b=szQTG8oAAaXXkRgwHrV3jzOi18FzFpYg9lxGyQ90i3BkcWpg2BmOPa/ae40zP8MXTPnOgs
	qWf3AhAOKLDE5rHLIyAiOva5GsGgqeH4QYTi2q5Qn0yoZ8zo3H8EOCNTDuPg6gSvEcd8CS
	i1/vcJjpXfVDO9is08KNdR9t1EgXoKw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="HdT/UraE";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784198795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lS+8PcrmibxtgubJdgtpEr1BolM0XkzQscvdMqvtB5k=;
	b=uT0lA6K/UEVl/ZHLYzYiNjXWiGsj2Rh0w98CumHLwEZT0kOpgjiU25kQfY7pwMRB884E0i
	EGVmz/V5OsMgIpDClovdfkjBGA0fdnv7YEISxJkKnMj0LhgYSJjNfD66AcxHtqB1SukcbP
	mvxVf6CJwwW6W/KYaUZwOaFuqSDakms=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784198790; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=lS+8PcrmibxtgubJdgtpEr1BolM0XkzQscvdMqvtB5k=;
	b=HdT/UraEGktqBjfhkgW38h/csTyl8Ph6kCTJS7zWgSf9326jrOJyLdm4IFtaS7o6VJ0l/kv/1Oe8aQhD4evPM+h3bP+Dn8Ecvkf/T4wT6aGpJIShGtXIqUYP9w4dIv1KkgjTMOiOrHYat5itDJhNzYeCi6IThYVXq7ncHM2Tl44=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X7EAGcn_1784198788;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X7EAGcn_1784198788 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Jul 2026 18:46:29 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] promote mapped executable folios after first usage for MGLRU
Date: Thu, 16 Jul 2026 18:46:17 +0800
Message-ID: <cover.1784197559.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFC40120007
X-Stat-Signature: m77xe7nota1h8q6bsnmkp3to4f84q7ie
X-HE-Tag: 1784198793-727498
X-HE-Meta: U2FsdGVkX1/IGBCXKnbrD71AUZXGOmvqlO6GPB+LgATMv30IQT4IOkaQCsoZOjKRGnKuSdVj+RO6+GGY7bdiOtPvi0pXGmSBmQCObjQA9VUpPARW8XEl5bx43vAaEhbsq3M+hVm132qqTvJH6wVO3QEcP7dnV6MMIABSGMXhrFdRRVle6AQklJLOSf6sTJi0uA13rPk/TA5P4Paz+HTP2YP3lT5dy0uoHU7w3NTqzuLnTP1jVjg/6PKaxMD2iZWEcp/yqE1UE8iCD8rLvfEqGnWt5xuAEQriYwoHOlIhidam2WgUN7OPJ+Yj0fCRGD45Nvdt73YKcseUEiMKNBVMwLkLXK2GDbNZHcW1RVlzH0Uom+qKFXQNX5g1u9boDoQpVWm7lHQ6BwJko549XQ73faYkrj7kmvVdaxeZ+zumWbC0vEBJbLWthLp41hupieBslcM653ecJbigeMew2FGGQSUWNcp5XJRO9poM3QequjSnoDUnSj2o8QpPfSKTTib5qmsQQBJlOZDKA+wmt20Dzy9sGBgBPO0iFIrJ629sR49dy5iREX9ie309Idga8fVPEKSwSTvxgrA1bM/gw8wwVFrBpVz2MdLAST7XNDMn5fPnfam8kTYlOJlsjg8Hjy4zQY+rS26SCvBzVr/eaQEzR/AKKsCEa1pidxuETbpgKA1RrU5Wm/oOTSTXRjxJaNhPh9A/8nct0ldAPsBxTl2ZHKdAtdMh1XmTLnBPRTLdLEzpHYKpNvlsQp3DCK9tFSXUoOsg1N3Z5Bx7egSnD7hbcOpxTVc/kyvDvP2vWqXSxQN3wZhqahXpAh/KyTVmAzN0W67IkT1wDcT/A6LPqbLY7C6/VDjqLN5jBzIFUEGJFwTDNEWjxsKKsd7fzE/rtKK7FYO+HV7dfXz+0nk0736fp0WlLTBeSTs0bb9aXQ8G97sWX6Z+WruV75aru9vBmadzZ5kBUDQ78AhS5VGbs3/
 CwLh8DZT
 kTszcV7vl5OAnV+LS2Y88xBgYgdgKMUNYy6cCJ4FRr4OEEZwAWZTvzPXbM2ZlK2nlcoCEUaR4Pp1KR3hPHyJJqd+VtMMzX220j0i0YSLSWF7bdL/LhKv1mWJF7MrUAjF704FkzecigEKiRjDSvZd1ilIdHb8VyLKg4Pw5d1Pl0y/9pX7WdRqKpdfqeYbW5fjng0H53pVjCgb2+PgU+9HZQ6+rPgV7hdUapoId53XM6XOmXk2iXMNkEvzov7b3jt5YIBili2oSWg5oUEQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now MGLRU's protection of mapped executable file folios is less reliable.
Follow the classical LRU's logic, promoting mapped executable file folios
after their first usage to give executable code a better chance to stay in
memory and improve workload performance (See patch 2 for more details).

Changes from v1:
 - Add a new patch to clean up vma flags as preparation.
 - Add a new helper to check exec file folios (per Kaisui).
 - Promote exec file folios in lru_gen_set_refs (Per Sashiko). 

Baolin Wang (2):
  mm: vmscan: convert folio_referenced() to use vma_flags_t
  mm: mglru: promote mapped executable folios after first usage

 include/linux/mm_inline.h |  6 +++++
 include/linux/rmap.h      |  7 +++---
 mm/rmap.c                 | 19 +++++++++------
 mm/vmscan.c               | 51 +++++++++++++++++++++++----------------
 4 files changed, 50 insertions(+), 33 deletions(-)

-- 
2.47.3


