Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1153DD2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 12:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A18C6B03D7; Tue, 20 Jan 2026 07:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246D16B03DA; Tue, 20 Jan 2026 07:22:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4876B03D7; Tue, 20 Jan 2026 07:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D647B6B03D8
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:22:00 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BA30140517
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:22:00 +0000 (UTC)
X-FDA: 84352254000.29.277D60C
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4F65A0003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:21:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3XmvqWeA;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768911718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ud/gUMa9CdKda8/RelC40VBUu1L/MVr4lL+WkTDpNn8=;
	b=gutyOrb+BQItZ85OZCXnyfNun1UBKGCM8VI5gEASX3WBuzNKhDIP7OU+d+/TMJrqiXM/fJ
	2SrqGxV4Jtt/26QsRr1ANqcZYRMw0ysumIZ5rzvk9RH9G3NNVQqvYdg3si/IwNIIc7ChH/
	8j8jkYDyhzS1tnCHZdT7cVze9JernYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768911718; a=rsa-sha256;
	cv=none;
	b=pKvJFi+9v5MdpkPD4zLVYHwRLDY9EhcZXARjgjyTqMVyYuQ0yzzhS4C1tBOGi8xHdB0hy3
	2mTVwzoyoxjk7gnhuPvYyYsXmjmIPiSYPCYWpAYFVJKs/aRhliMcPBeVFKu8Wo3xk6MATG
	5ihDjoqqgG4n1j1dwceQBCKQju1GPQY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=3XmvqWeA;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ud/gUMa9CdKda8/RelC40VBUu1L/MVr4lL+WkTDpNn8=;
	b=3XmvqWeAh76YYsqyWMBN2CcHhk//lpm6fHNmIsWeexX8SCXu60R/YOG3ytCfjZYxccwswI4WK
	BhYhTCFJ4RM5rQiMeo7/Qa6vXnu7Bi5VluGM3HC/H/91iXZHLylSUFJbLHfEYuADehu4MYgRVSa
	pWZcLGjZ4s80a3jbPbn7g9U=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dwRDK5Hgpz12LGH;
	Tue, 20 Jan 2026 20:17:53 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 995F340569;
	Tue, 20 Jan 2026 20:21:52 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 20:21:52 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Jan
 2026 20:21:51 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<linmiaohe@huawei.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH v2 0/3] selftests/mm: add memory failure selftests
Date: Tue, 20 Jan 2026 20:32:36 +0800
Message-ID: <20260120123239.909882-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4F65A0003
X-Rspam-User: 
X-Stat-Signature: 5n466z65detw1tgw9sgbuysgg4e641w5
X-HE-Tag: 1768911717-545243
X-HE-Meta: U2FsdGVkX18l2kDvRfd08ai4twcuJ1DlJR6vybYhEBBMllbPIuTHYzEH/qqGknEzHwydjZ++4iCCPN0eYMNjB1uD7Sdl0WcNy0WjM80uk5j6FwUBFVWadb0+skWeKkoskhltVaDfhH5DEG/ZDs82QoYsEbvbcOIg+bTTrW15FuD12yyccou2GC94hXP5kuJTR1JNeo89QSOdh37FIzSNqQ3RO66ChsTaKV3C63Uf3c1ogF9FdeEw9SuXLWN7wNgWdHJk5QjU1CIWbNoT/w79nAYZkdK46+AWxWv8NHlMZWxaoQYpUDMwxjU+IZZ1O3NyIHQ5tZJNHNWY0C9+yfqCfBzK3zgHz/WfB2piviRdvAtDAdW8R7r5C2T47GX6OQVpPdZ2zKx9oOjB5EpZFKcn8Ik67XIZnoKr5gf/0TIb739wkj/muLbOiCPY0b22ZGqIHguqdtX6EuMl6lJLG0wdPxd58l8yujJbVsuKJzoPhG8koaUq/xtYQvWcNY7zAaRL+WRcN00gu7Z7d8dWFvJ/+qDH5M73UTZLgS2ofVBxNjFblRz9+e4GYvbNo66wxwUbANjc0am1NgoQuYTT5CPLoGhiBuqFeABWP8Zn/7uZFiIkPiHoY7hjghUgzUT3erGWYZZcSMD5oGKdVNfApGqlPYBwygF6yCBQQzMGHrz1hTfPboVPDk3T534y5qORjmn++VJoQ3EvVh1KVVKV72S8yJem84d9xuyi1GvnZb5oH4qFoqh4CLEmgAvro+iUfz15OFa52h3sVZSyTls6jrJXSvBr4YBCirr3BxD5qCrM5Lcks71bTBdkVo4GpRR5rTxBHx9OgvneI/dGytFbTrmkZHTj/Xk+s7E2uq07JtLqhKUSbAP+ctU7J1bOzQgE0u1IW8XslnaevJdQDYyzMPFrqZnHWnf8nlC3u4KqKDNk266Nvs3r4rPSWXd3h8bR1NkYaVsl22G45kDSgDwK0dQ
 /iUUcjLL
 jUYYUW5vnLnJUR0hWd3EE5/cEcHoegUS6Dju/HHe+nqvQEZ4e5tz+bsZB/Zidcfe914TKPTVnedpXHY0lWWCNJcfpchZO/y+uSa2yqgORbC+soLyVDP+QlITsl2NIX2QDT9qH79yguExh/yEpglpo5RnC35kg2Gab/SJt5UsnYiwYgrkHPPaRBDFzMH02n4Zo4eEMbHsKP7CbWctKs150qTN2xpRR6oJaaRMbyQOFOUpfzvacbofnju8JQXyKNEZs9AR30PPIz9N4UtLnySbUgrIMYNdElFH/RvYmGzpJX7fFDWs/pd/bvAfzN6u9ccOMRjbfzE7c7KDZOxl78yxtcj8d4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce selftests to validate the functionality of memory failure.
These tests help ensure that memory failure handling for anonymous
pages, pagecaches pages works correctly, including proper SIGBUS
delivery to user processes, page isolation, and recovery paths.

Currently madvise syscall is used to inject memory failures. And only
anonymous pages and pagecaches are tested. More test scenarios, e.g.
hugetlb, shmem, thp, will be added. Also more memory failure injecting
methods will be supported, e.g. APEI Error INJection, if required.

---
Changes in v2:
  Add some codes to guard pagecache testcases against tmpfs. Testcases
for tmpfs will be added soon.
  Thanks!
---
Miaohe Lin (3):
  selftests/mm: add memory failure anonymous page test
  selftests/mm: add memory failure clean pagecache test
  selftests/mm: add memory failure dirty pagecache test

 MAINTAINERS                                 |   1 +
 tools/testing/selftests/mm/.gitignore       |   1 +
 tools/testing/selftests/mm/Makefile         |   1 +
 tools/testing/selftests/mm/memory-failure.c | 359 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh   |  21 ++
 tools/testing/selftests/mm/vm_util.c        |  41 +++
 tools/testing/selftests/mm/vm_util.h        |   3 +
 7 files changed, 427 insertions(+)
 create mode 100644 tools/testing/selftests/mm/memory-failure.c

-- 
2.33.0


