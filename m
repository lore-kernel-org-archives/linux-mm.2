Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C38FC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73B386B00DA; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677F36B00D8; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5656E6B00D9; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31D096B00D6
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:01:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3548C1C0A94
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:01:12 +0000 (UTC)
X-FDA: 85048477584.30.F2A2D7B
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf03.hostedemail.com (Postfix) with ESMTP id 08E6720004
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:01:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NR7XLSqq;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785488470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VFyXsSHstxBFgLyWsqQtLrkX7vC2PRGmGRynzo628c8=;
	b=yGbrqTv1PicF7WB2K1kHTwMKHMbujrq7vWOD94kWBQ2ZYmGA8G2prLNlKEHsZf7UXPGeCg
	O8v6lqG44onpqnY92yj0Zimggoszva3wmcEISTB/F7ca/2tFRZmnS9MGZu4zNkjJ+2imU7
	iks+ltGdrDnruZc64I17nQpwrPVJrIM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785488470;
	b=OvMMW0RgmEeclh0Dn7zovBFzzX/kUfJ82Ki6iyRfPt0p7dJqw+Jow72h6DidEiu4zrdzuP
	StCOPH/0dqg9D2EEVT1KLh8ANu6bh8orO1bHoqpGcr2u+5ggk2OAKAzo/pbn4htIAEHEws
	rlM+NM8tFluAZn3aEtMAG7naO6SDIDA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NR7XLSqq;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VFyXsSHstxBFgLyWsqQtLrkX7vC2PRGmGRynzo628c8=;
	b=NR7XLSqqXjHovnSsi91bpQ05//uD9sh6Mlz2930eXsND/bAArDYszP5iHpIOozjH8RUHRZeN2
	PSrNFHeqRwC6YLullss5DMHxbBS/+EioVOFOUC7RW3D/aclMYMeTnnX3VTZhzx4XFVfWZEx8Is6
	3J0syixG1Gh9BFHpY7uDBXI=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hBKYg0DwgzKm9T;
	Fri, 31 Jul 2026 16:51:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id BE6B040572;
	Fri, 31 Jul 2026 17:01:05 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Jul
 2026 17:01:05 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<shr@devkernel.io>, <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH 0/2] docs/ksm: fix advisor documentation and comment
Date: Fri, 31 Jul 2026 16:35:24 +0800
Message-ID: <20260731083526.3953421-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 08E6720004
X-Stat-Signature: ncwusrc7qfa7itte63983s7jfbns9k7b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785488468-50882
X-HE-Meta: U2FsdGVkX1+PXRo1cM8IoLAx5RNG+PPYxlshLXhAcewqOyL6igOo8NwL/nWzboAepjcy5hjCQVbHg+feNQUtL+WLSBZO6VqavbmPJYqqTLNkfc3kwR9KCcCbWz8PK1O7a5NjeOzcNAePH+L3a8SzIYqO1Dh2BXqLnH53h6hzOhNkJ+Jy8ZbEJabImthptuS46opo85pOpclTq7asVpPyCnYVdvDi0IyKxcMsUMd/lVyzTg7lCXyBWjMmMsAUSl2l+cREI0eJUlWI8YKnZ1bXveaReHCw5T+u0xCwiMsG3Q0jwkkMUmZM4XwxIeEmoBV/GszT+S2CdnIXVSdftCk8ogAwQukukmyKI4Ul/hTMcY3sqVxwKeZKAKPuBPjEbF2nDJnyYv+l1WLDyl7mzbjYpgkVaqw0jf/KqG4oH1cQDp22uXIUyYbImDkEkWF3t8zKpqMfkskkiCAL8SfYdyLuxCt0Mlnfnkcz5hpMmAPoPi3+J7rsmTdnTzfvdLniSNMncRWoN+qHnmAwkqjRta3E1dOaPYC7bHgoRbhLyi+4NCaai4XW6X+YIsVSqOdFYXAX6NOfojEt5Co2+GTym1JIuGoKrH+xaMOKcSXLVAtXn3qxCcf6kWEuzCxC0DHRfnMVZpZOvLBCBCdPVYOmofHS74adk3HYrEEq5/w1+kgx/csaodcF4nDfYLbzR7mqvy95IejkABam5L8p3mR9clgxKnFeLfdI0/9/yBjxGk4M3idLZkx2A5IIzOSW7Z34cHTqwF9PqWPADn8LacM2Vypu5BwS82tSDWwkEM5eenaa+tRYQXBoySj4Hh8+IIsj1lNOOU42unAib0QrzlxQhUJApiutpgbI5ZSZQQvBQtU7EFmMaJHvQ7MSFSdkYPg8TRABYf5yvVfONNAkGr5aQrzBbWzoaeqZ2SpB/KpwSPBwfPbqmRYTd2o4bbdDzvbHUVosaKYqbWPxbUvMR21eEhm
 ec8IeboF
 x4I9ueBpN8TtwAjDv3kbsWrcCvQcnRNKeeMHwtlJ1wx+uZ21jnrvz80UexnMsnpLpcH/O4REX/iXmD7liLZMYEonG6osH0liSsQy/0LMzFpBzxjYNx8vHoiNcHwHMywcY+boOWUOg6ldkDWGCqpGXUgnEqZOLYMx7ZIEI240Dw/h0UiGbo/CnTjQA9EnXzK06eD/shZuPKDNQlbR9N1ZVjVBJmj3v8dbBniEAd1ThRcBOYMftlmDCMtE/CFFyBn8HkiH5NmX47q7vnSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix typos and misleading description of advisor_min_pages_to_scan.

Jinjiang Tu (2):
  docs: ksm: fix typos in sysfs knob names
  mm/ksm: fix advisor_min_pages_to_scan description

 Documentation/admin-guide/mm/ksm.rst | 8 ++++----
 mm/ksm.c                             | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--
2.54.0


