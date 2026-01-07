Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59B0CCF6C1C
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C016F6B00A9; Wed,  7 Jan 2026 04:26:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECBB6B00AA; Wed,  7 Jan 2026 04:26:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DE16B00AB; Wed,  7 Jan 2026 04:26:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A20336B00A9
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:26:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38398140225
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:26:24 +0000 (UTC)
X-FDA: 84304637088.19.3E8499B
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf06.hostedemail.com (Postfix) with ESMTP id F0CCF180002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:26:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CCMOprFU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767777982; a=rsa-sha256;
	cv=none;
	b=XSwwskfcm5Dua6lML++ZbMz5WB1RPKZV7JYIMZajO5545WdIEnw5QdW51INE3a32eB5a2U
	NwooR3L7cI4WymiTgKzVGHL5kd5TTQQlrjdj3Imfs7vPBM0UbOVSScjA88DIkBZsARVDym
	nSdRPoNk6SdwTzYdqB/FcQhydKr4xns=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CCMOprFU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767777982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SbepdL8fPHry+zhsuV968bg0EkRiLpLMT1qSDyYCvVA=;
	b=jSJAZID2m70GQhw2/sH/cJsEWfxqNxMdew+2VxEiwQLhwyvWbTBHblv7pNPKWq1r6tyja5
	WRVEh979AR9fhu3OFcD4/0BwojIS0rtBPRxOGgEcmebSrUgn3NezN/MewuB9FM3meR9mR/
	4qt9Vyr3qoK/DaSzo+ylgMJNJeX2LH0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SbepdL8fPHry+zhsuV968bg0EkRiLpLMT1qSDyYCvVA=;
	b=CCMOprFU8FCITCQZe4mbIl7plgbAUUxisTeoYgN4Cl7CoYSrUIeyk+PeKwsUGL07MFH411gAq
	2qKPjBeWos4rcIyUZEKb2k0c7vJjs3xagg2HSvL3vClI0SpGR9cQTi4feFK+Geb0coWMKmwpi++
	h6lCPx2oiw+E7T7lGHwQ7Lg=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dmMyG2pN8zpStD;
	Wed,  7 Jan 2026 17:22:46 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 9578B40363;
	Wed,  7 Jan 2026 17:26:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 7 Jan 2026 17:26:07 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 7 Jan
 2026 17:26:06 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<linmiaohe@huawei.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
Subject: [PATCH 0/3] selftests/mm: add memory failure selftests
Date: Wed, 7 Jan 2026 17:37:07 +0800
Message-ID: <20260107093710.3928374-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: F0CCF180002
X-Rspamd-Server: rspam03
X-Stat-Signature: okqpedobz9y1giwh7xbttj8kmq3pa3wy
X-Rspam-User: 
X-HE-Tag: 1767777981-245359
X-HE-Meta: U2FsdGVkX18Qo+i9NwQTMuCgcUgvDpg+YbySlfU3Z75WDQt2ACYpAWkc63Esi/FOj8alS7hVXE0yBGLAhW/htA8Cp2bNKKJYc0Wu1NcPEFACrV8TXhLW1XiG95eZbBvqiDjck6gi0Y40Cz5EJziQZH4RI1hgLOke/+1JwewwTxgX8L+l+e48kRRvDQvdm3eopJnv1hfe5RM04SInpZZ4Oio1dTyFvBmSdOI7FH0w7f1zivythRimqFi0mr84YpkOHAvGVPG/+PYBLRImgcEoKMKa8ByZEmb2GXeqI6qBhm8SUTkgyUd4tizZE/xAKCugbAxYs0RabPvEVT9vUF0RYm2w29kiMq7cgdobWF7kH4LSP3u1mnKKSBxXQsgqKBvMmoACOPGUr5Uh3qeCJvDz+2ZnXhUNP1/eyiRF/oqwZywZYSPtMcFKDurIkFqQjdpN4Ci5G880iinT7fgYw2NRJfiJ6gF8lZh/DoPnDFt28VRP25t317qWWij2Uc7GMtb8h44yMp452dJmZc5Ry1i9C+Eow/bhlyg9DhCeK+sbHyGyxWjSpmB1NmobzfCOx54MfSZHbNFxwJplvAw1mQky6cgoPOK7vmOcJhWNhhWHED+KM0OlPJPzUGqw3HZjk0oQHhFYdjmPVswv0g4laUNjbOhgVHWcaekm4bjmBGRpXwX+7V13IcAHcshoMuvUHHRhP2lqm3ygIouDRlVyGAin0ouVvaZkljZ78MWPMVA4L/r2+Jhk61gAMTtCMLSv8jJk4TOIxkRhJ9gyQat9pxaMNlpVAf8N24NIfb9uNth++q7mEikhIq/dR4iz3X6d92HyXuXQZok3Xxh4FAWHsS7XMJQ9hQ6aH6KJbeGewZclRveDxZ4kNvX2WamXTXmZVY4ZDv8IOopbe1lhg79DQWjo7l9Qe1Ihyr1OIwAxlZuA4h4ePi5itkN21SSg5BBZHeLtFNgmEYE+GVdlcEvSGjm
 SoLSWWoy
 OSS17DUwE29JYtGvsZiKYSux0FEZ1y5cje7t41gIDD2bcF18qP6mfYMzS8X0KcdUpXQ9Mzk/A5CZ/raYTJFYoqhvdoQXzVdi+YKB2+hmK2S7VfbPDr4JTHgNESN5Mf28d22AlK6/3Dcbh3f/P2tcbSl4wNXrVY0Z3Oa9tsYKUZ3YVCO3WCyGCfdyGu0V/q03oc+va5jsPMr6/7TQgEfRWVyH2jpEpPlYqLRpGBD0Q+avttFuxPkyMS6RsubbR0Eoh8zqA4ox9NpiyHwAVTcHmXgz5CdBrp7PQlXDzPR02qECxU28+Lk6QobVzfNeOM1Xc7rapDvo2kMlPGi0GFRFyOprdGQ==
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

Thanks!

Miaohe Lin (3):
  selftests/mm: add memory failure anonymous page test
  selftests/mm: add memory failure clean pagecache test
  selftests/mm: add memory failure dirty pagecache test

 MAINTAINERS                                 |   1 +
 tools/testing/selftests/mm/.gitignore       |   1 +
 tools/testing/selftests/mm/Makefile         |   1 +
 tools/testing/selftests/mm/memory-failure.c | 335 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh   |  21 ++
 tools/testing/selftests/mm/vm_util.c        |  41 +++
 tools/testing/selftests/mm/vm_util.h        |   3 +
 7 files changed, 403 insertions(+)
 create mode 100644 tools/testing/selftests/mm/memory-failure.c

-- 
2.33.0


