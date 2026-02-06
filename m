Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E696ECD9BE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 03:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C513D6B008A; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F216B0092; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00EE6B0096; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3556B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:06:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D958C26EF
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:06:34 +0000 (UTC)
X-FDA: 84412543908.25.8C9394D
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf30.hostedemail.com (Postfix) with ESMTP id B00358000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:06:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0lRWbwgH;
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770347192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5aans9xtPXcHB4+FARFiU0HO5Ds9Y+W0WJVItIfQaoc=;
	b=melbuJRoSrWjEIBnbD1Wag97V96mSPJ+fbq1ovkzUMzkcXUdL+ZBBL5RhnIm5xSNst8bNJ
	o5jvQ3VMJPy2k8thDc0Vkdf8/M2UBfSVNY6D0g75IpmEzmxo/YHvoXrlskD2PgXtrdFAvj
	ongq8G8DDJIuC4tRuESUiln1HEkvdZc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0lRWbwgH;
	spf=pass (imf30.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770347192; a=rsa-sha256;
	cv=none;
	b=oA0GqjSThzEW1wsFhK8srWCxHDyrLGoj/jyfRnQYPqEXAVw2O/EHSOvGL1bWp22PSx55cq
	fFqnL4ibc3piPuGCyaP3f7TAUNGEBuspEqAxTXTI+4HBKAsHZXLNxAjVwV2YCtzPBbq1Mg
	L8samXElv0a/YPJkiO1MXcV4Q/UnPic=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5aans9xtPXcHB4+FARFiU0HO5Ds9Y+W0WJVItIfQaoc=;
	b=0lRWbwgHsACO1GzWRxaWJ8wtj3zoekSkWRxh+S9G2RTCeZ5l4VrHuXoEvQWnGb/jyKdGab+Io
	306DNK/6NrQjH3Q0FQIhzexiwNM8rbX+RR6c6yosM5tTdFFHTAWhwXGSxjZQ1yKopbpxco1UYNY
	nQ18hj3ih1BTXAzmmHZo8vo=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4f6f4v5b5cz1cyPT;
	Fri,  6 Feb 2026 11:01:51 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id AFF9440565;
	Fri,  6 Feb 2026 11:06:26 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Feb 2026 11:06:26 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Feb
 2026 11:06:25 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<broonie@kernel.org>, <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v4 0/3] selftests/mm: add memory failure selftests
Date: Fri, 6 Feb 2026 11:16:36 +0800
Message-ID: <20260206031639.2707102-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: b49nuxa7d6biz96yiftmephr3azdw3w8
X-Rspamd-Queue-Id: B00358000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770347191-854479
X-HE-Meta: U2FsdGVkX1/EqIc6k8Uzq9DTbGqsUubHuI/xvAtnHqSfYX0mDHAJQ9GDdC6MosFgdgIV51zlMjlqN5xwbjjoSz42yv2aIpZjcvR+MkUhHMmwDjJ+AD7vBeWJNGFcpe8yxcawaALFPiKgoQWhoqyIt920uRcS41J5Lt8r7HHwjb/A9qbAkN0k6fnWvqA/viLVlyFwc3eRfpKTtFSw5C0NAb2KstedaCs5boanrou0vrdUdHXp289hn42iAIXh6/1sUIRRlNa3qWAmmFdFa2DDSwQjymW9VP3wICC8DcXjZJPMovc58t7/0YbtNtSfC1gppYuSC0BXSjp1JxwpN+5DQ4XjWGgPb3qGk7ITf+eBWylCseLePoMB1RgZtsZpFXL8P2m9kZB8Frcxkby+udkzuUrRbPzo+lWodTD6CzY+ISEt/ydHeiq2H/YHg8sFwRnIBY2m9u3YoxoPthaC0/uv1aLpMNEIBi34cYbmXQ4KIJsllWILyvNIhZkLATeWlkVnx00L7RO9LdH+dV0vOiZV73mhHboMOdtnG1PhOdIAIzz8fIpxNdOSNq1sEtU8QTUBX3z/4RHcdnOHTtLszumuPPp+I5Hp1nSbxq55eOkLNhbFQ6CZhogeCvp8NeQdkJFg61WHoE6nAjHUFUyi6s1eCx75XodITDcDnTdzLPfDs9//QkTEGrXDWtfeBfAz/dxXfooASqQCO+1QENw/hMtsFjMhVAjdg+aCCz0YvuZQGY1kjX2mTbxDMOLb6g+5CDoTn25QCy8uQbsMLJOPEXcoOYvZd7n3FpQImioEssTHGwOXRAeATb2T3o7llVBXqe8NbPIC88QPqRTFTxK0VUW1rQQGZECgU4SvoDzZInPfPV28DlSqWV6kz8WwvFCnV7o9+IZF4fyOZTVPkc1z4XUgbHeTgaU6QU5K5sIgzWfm/ytoYJfD0rLas7Yt6SoMvrrbDREElxljWw5s3cTgGS+
 VcSXSAqu
 8c1GMxCgdTQXBmCBYeacWlxJC8To3PTI4SfvEKS9cVUdCt4IssG8OLvWDjka7x8kFdH0Mr49lgxtKOZEWSErfcOz8sUJqVmR/l6XtCcgVfq2tJ17souPhkCmKY1Um43V49CmLOttUrl4/aYl2iAXsDVaygVk1g73DR31L8BdVKUxDhgY1HSgto1qzEwALO5OdnZhpZOcYcAjoiNlW+cbsMUd7EXw2kOFnzzb5NpticuhYH63fHLPcFCAcc8o1dai8beBna34uDT73M7CzINYXZEPiCPDrW8FWeX77ZeEJkfiJh/HuPUxThs8mecsEbC5wHLJFv7qfocgOlekBsBkt9J2i8g==
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
Changes in v4:
  Support running memory-failure test separately per Mark.

Changes in v3:
  Add HWPOISON_INJECT and MEMORY_FAILURE to config per Mark.
  Fix kernel test robot warning.

Changes in v2:
  Add some codes to guard pagecache testcases against tmpfs. Testcases
for tmpfs will be added soon.

  Thanks!
---
Miaohe Lin (3):
  selftests/mm: add memory failure anonymous page test
  selftests/mm: add memory failure clean pagecache test
  selftests/mm: add memory failure dirty pagecache test

 MAINTAINERS                                   |   1 +
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   2 +
 tools/testing/selftests/mm/config             |   2 +
 .../selftests/mm/ksft_memory_failure.sh       |   4 +
 tools/testing/selftests/mm/memory-failure.c   | 359 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |  21 +
 tools/testing/selftests/mm/vm_util.c          |  41 ++
 tools/testing/selftests/mm/vm_util.h          |   3 +
 9 files changed, 434 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_memory_failure.sh
 create mode 100644 tools/testing/selftests/mm/memory-failure.c

-- 
2.33.0


