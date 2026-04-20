Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA21F36C51
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6EA6B0005; Mon, 20 Apr 2026 04:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CFAB6B0088; Mon, 20 Apr 2026 04:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C836B0089; Mon, 20 Apr 2026 04:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5836B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:02:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD96D140992
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:02:02 +0000 (UTC)
X-FDA: 84678190884.22.0456762
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB985180006
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:02:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf16.hostedemail.com: domain of gorbunov.ivan@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gorbunov.ivan@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776672121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=TFRQe2bNCdtZWlf9yGozBQq9Aml3oLMMWcZ33DmMFB4=;
	b=ZWPD5huzzfm/g2BuWye8yRG7nuasnL/aRwDyJiDFmX46iX/jwW3x/LWD56X0ljfO2OxYKB
	5XDN/mnWjGoqEIMDyPphCRdQOAtFSiTu3yXVfNEpMxoAxFUSPhrxpy3heg9OJlMY2KiTYZ
	yIyM5O0YmLu/SbsQn3Vc6ud+T0ebYNU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf16.hostedemail.com: domain of gorbunov.ivan@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gorbunov.ivan@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776672121; a=rsa-sha256;
	cv=none;
	b=tONXK3z0nqlsixjl9LZo2RhOLrv5/DFjDF05m4zb8XIcQUNbtOBzwcScxKVpa6QBW/7/st
	6TJ/grFkaPVpaChlTYsr0Zh5Bvjh9In5Z3Nrc8oBZRqwPdUijziTyqAoTGihtRHHHfQSLs
	GhAPH3F8MjptPfOSuJ66nKLFWwI5KOQ=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fzdGy3qsvzHnGjD;
	Mon, 20 Apr 2026 16:01:30 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B28440569;
	Mon, 20 Apr 2026 16:01:55 +0800 (CST)
Received: from mscphis04371.huawei.com (10.123.69.39) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Apr 2026 11:01:54 +0300
From: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
To: <gorbunov.ivan@h-partners.com>
CC: <david@kernel.org>, <Liam.Howlett@oracle.com>,
	<akpm@linux-foundation.org>, <apopple@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <gladyshev.ilya1@h-partners.com>,
	<harry.yoo@oracle.com>, <kirill@shutemov.name>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <muchun.song@linux.dev>,
	<rppt@kernel.org>, <surenb@google.com>, <torvalds@linuxfoundation.org>,
	<vbabka@suse.cz>, <willy@infradead.org>, <yuzhao@google.com>,
	<ziy@nvidia.com>, <artem.kuzin@huawei.com>
Subject: [PATCH v2 0/2] mm: improve folio refcount scalability
Date: Mon, 20 Apr 2026 08:01:17 +0000
Message-ID: <cover.1776350895.git.gorbunov.ivan@h-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.69.39]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB985180006
X-Stat-Signature: pgi8d85gtkd56m5uwqdqrerkqmffmemi
X-Rspam-User: 
X-HE-Tag: 1776672120-701955
X-HE-Meta: U2FsdGVkX1+sWAy2wbG1ww/LkBzkVG0aNqlW/xX7Ejdn0gLR7qB0gxUhLCMkLyFUsokNacn0TfY/8POY0yX2SsjqJuPvhXOdGAbvlPLetyXIxwrfTJZ1w6xWgRhhK/4j53GSRzmA/oLQH/gq+J5f6nUWdqKY+c3wBIBP98nUKQ6mKWVzydLXU8ahnPxxo+hXxga8jWLch9H6nOdFlrMN5XV/qurIvfMZhNJao2+0oTWDDdOpg4xMKYoef3qH7w9wotaC0h50A6LlpA0bpCWBI9q4MevvnSIZQaqR2Xcu0jTZffOmRaKF4Mx2SPzoCXSYAJzdDjqccMLTxl78hI66tqb/umYZbKzjilc5DDbx4Mb3ypeW8PIbWih5rNvrY0fXITK0G839HeTMU2QvU7S6gaOa6c/81jAlM9aFb4sYJh67B3MqrD/KYHnuk4xDlEtVdP8sebeYcvBWCBIAhe/EP0UEkEcSSPFxfQxBsC4CUnZKp4G05CoCojT7IAm0NgBug4Sz9/jgLayekAc243zbJLXa0umxVieQ1tcTtuccHfdoEV8IBVBO65kG1w7EKJi5rqMZWvQ5QZE0R1QvlFNGUOarG4TEe8RZ+RBDxncZOL1Mbxg44f+4mUNncuEwb9PjIvkGVD907nqBxw71js/xpCgT+q53epRXARI6afwuwJKgxfq+gDAScF0Po1+INKIpe4Gly0bI4mTJcitXaX7cDVEObLqcHTOUcf7xwngHDp4lVDNS6ihLMYv8UYagAOQoPpRTMowbPfWlIoR2aEdIHu9PmJ+G1LJg6ifbYDUlROh6OE1YsHQkBOHPhuCMCocAuzvMZDnITO7Cx8GDHxA6XPq5UBP9URRrUPFXQrXLtdY6IRDugNAJE4U9bk1kQT0eIxue5cq3fvSudo5XrfljjPu80u6MgzlmObeb6FVcifWZrN620wpAQ3crmj/x4GkoX6OQqTDvjOp+1fJAwSJ
 NMptfHli
 hylr8eNz8VZfQBHvwu/UqkxQdqqIc0PGKTsrWQRAZqxpctxxiqs+VikMaH/fEz612tGRQ4ZhJr9aD82s6A/OqbZcJm3CbeLG+ERRH4/jwyuOJivcJNkbzhJlS+gyTeIqWYGV/RFcsVna0EB8q+T5KPuQZXFmEgqgekeFI+cOqUiCJF5xDUqo6hDV/sumO0nb3Jkhzl4YKIjArrSXWx/uGJM/CoTCdOXgImw2EczY199VZT0iyDNZFvqQtjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a v2 of the series that aims to improve refcount scalability via
dedicated bit. [1]

Changes since v1:
  - Fixed frozen pages initialization
  - Fixed page_ref_count behavior on frozen pages 
  - Added debug checks to ensure that some modification methods are
    not called on frozen pages

[1] https://lore.kernel.org/all/20260228141941.f6fec687aae9d80a161387f4@linux-foundation.org/
Gladyshev Ilya (1):
  mm: implement page refcount locking via dedicated bit

Gorbunov Ivan (1):
  mm: drop page refcount zero state semantics

 drivers/pci/p2pdma.c               |  2 +-
 include/linux/page-flags.h         | 13 +++++++++
 include/linux/page_ref.h           | 43 +++++++++++++++++++++++++++---
 kernel/liveupdate/kexec_handover.c |  2 +-
 mm/hugetlb.c                       |  2 +-
 mm/mm_init.c                       |  6 ++---
 mm/page_alloc.c                    |  4 +--
 7 files changed, 61 insertions(+), 11 deletions(-)

-- 
2.43.0


