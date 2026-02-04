Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE94E83EE5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 07:23:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1006C6B0089; Wed,  4 Feb 2026 02:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069816B0092; Wed,  4 Feb 2026 02:23:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C536B008C; Wed,  4 Feb 2026 02:23:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8E976B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:23:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60E861406CE
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:23:12 +0000 (UTC)
X-FDA: 84405933024.28.407FD23
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE6AA1C0006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:23:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Qj24zykY;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770189790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZF8/xn+jqN+qmIXuk9muaTSHcrBqfxCYpLITvIgWeYw=;
	b=REfHLoe0qxnvXmEElR38qnGq+HuCLdfsR24psJG2i7hhTCGUk58jNpGUojBAuOHU9I3MX+
	mnOiH4rEJSjCYfaA22qaXoD/T2Z+JeyThmN9hPChcjMzGvfslKEsRiQeUBHhJLJbmuhnHg
	qazUb9WJkEM3jwLO1NyEZ3XGTcS8OB0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Qj24zykY;
	spf=pass (imf18.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770189790; a=rsa-sha256;
	cv=none;
	b=hyvdJkWIEbHuVGmb2Ilsd74o7CSOJD9HJ1y1ci2La2s5xRTnjwchahARusf4ztJRpwPDQR
	pEUTDVtOqvf742uo5xSjPNgaRsAJVs1EzjOJXxGKNOhQGGbacuBcsi/3ssoPGMSK/Qpjke
	qeKFiguZj46BcSVVUp2U2daL3j/w0zs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZF8/xn+jqN+qmIXuk9muaTSHcrBqfxCYpLITvIgWeYw=;
	b=Qj24zykY/YBO13eN+Q9suzpq4NMy0nyM1aFe3l6+nBSDMfT3IbbuikQHxos4fwJvhLoernJUa
	y14zZ8aF5qHmOmnbrQC5u6zdn7rm8kZJyu5VzbZIp4Z8TpfUWc49vp+5myeBTA3OfdCBzszBOSY
	VHI+PtOCvWbJKKDDEf08gYg=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4f5Wsx40yTzmVCj;
	Wed,  4 Feb 2026 15:18:29 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D33040565;
	Wed,  4 Feb 2026 15:23:04 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Feb 2026 15:23:04 +0800
Received: from huawei.com (10.173.125.37) by kwepemq500010.china.huawei.com
 (7.202.194.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 4 Feb
 2026 15:23:03 +0800
From: Miaohe Lin <linmiaohe@huawei.com>
To: <akpm@linux-foundation.org>, <shuah@kernel.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<broonie@kernel.org>, <linmiaohe@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH v3 0/3] selftests/mm: add memory failure selftests
Date: Wed, 4 Feb 2026 15:33:28 +0800
Message-ID: <20260204073331.899406-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: 73gjpsjweoejzzwjwtes4fd4s8p7uhap
X-Rspamd-Queue-Id: BE6AA1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770189789-507138
X-HE-Meta: U2FsdGVkX19gJBEJKD92mFO508SjMfeajCR+UUBCA6gTJkm4X8XclDvWAjJn7KXlCKB63yDfSb7tLQGQUcFXg7uwetdOj8Whw/Ub+wFDxo94E6f88Y8zLSv5+/4Nuw39Bf2vw2UmXTdB4IJg6RTXxjvck0JicZ89IN9VrZNRsiVe22J0GZU+r+BJu+BDJNZWxeGkZLcn33j4AtXoxNUj2KyfQwdvBnryG4vKkkuq0G0BQqc3a5PqoyJsuapAa4/naALnTaUGOk4q4b0ie7NCOLhS6uilt+WJTbZx54dbAPBn9F0J+SdH2xj2SBQKQ3R3TmK6Tp4GXV8gOraVDkkq4vM4+0puGpUu/k6WdR5leG9GDOaVvPitOmoWCTmN2SRVCXnTS6bXFvkLmJIlvci4WjHZIvqAGH7MbTybsQFu0w7SMXvLsTaXxD/F4kH222esSadl7jgGuv+qt/NEWWmgkPYUtP7PhCFYHVn4+ShBtnCpXtjeqvv5shilZrWge02tCedIi8oV/MwZrHS1cGYitX7tLDqcLIktTfp56qc4fNJ1jOYDaOX4Zg5JnxZsnb96Ng0epvz0W88fodHxhalM55QV6svPZr0hsYCt+oXGjdHYOhQ1WZFK7L8RZ11a4v1Xx5+zRtxo2hSbM24nDglKu+ZDycjyvb/lfwjazbyrCJs2er9LhiIon/8h1TLPRBY8192XkvqjdnBO4C2Akseb8MVOvDVxDaw0BoC7xJr5AKqkfndkGjV8aU4zMF58F61YDy0VVyBAyASBKonrajMtl1OeOGCwiiQcdBV1iWZdpbMq7lLqGHZM9xL3H3g87t4MPKnO+7T0bOxjsyYmOIpl9r3IWL4pDV5UZ64osGt/oclXK+FdgJMQgQCfFRP6EK9e7Vb+/Q0XeRiwt+ZGphcEYALC8Gvff5GIpc/TmQRulZfwW8ylkNGBFbjJFEWzY+fP0EcP1Htqiu9huWFGLW5
 HQpPbklJ
 FKqaEVQnTiZpk9Efgxm6Mqx7rD8McrM1baiY45i8Obf6ls38OGTNpt0YOPnKBLtKPxwCCjEhQ0kZ7JrGtMXMZAxKGnR+qXr7iKDPpwfQ5bcrDoXxnhmzfe55WD9jHNoiNqE80kyjQsVRC3c5O1zBKVIWXvvZaejFmRquu+JV7s+fuDGgPWopb78QbtE8piQG/75jUCjzahh+0dN6j0+AbN9OghSyIZfMevz8BU8Wvxg/z79FQNfj9r5JFg6kWj/tB3Q7shG7HyhpTmUHR9+5N0MmAlYsz4YBiUjx69pIoGvgN+TNUqUk96VKMk9dVR4pOOr/oyoxtA/Sdw17niMRGsqBIrQ==
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

 MAINTAINERS                                 |   1 +
 tools/testing/selftests/mm/.gitignore       |   1 +
 tools/testing/selftests/mm/Makefile         |   1 +
 tools/testing/selftests/mm/config           |   2 +
 tools/testing/selftests/mm/memory-failure.c | 359 ++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh   |  21 ++
 tools/testing/selftests/mm/vm_util.c        |  41 +++
 tools/testing/selftests/mm/vm_util.h        |   3 +
 8 files changed, 429 insertions(+)
 create mode 100644 tools/testing/selftests/mm/memory-failure.c

-- 
2.33.0


