Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB58F606A327
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 07:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=SQJC7cRS
Received: by kanga.kvack.org (Postfix)
	id A31A26B05B0; Sat, 28 Nov 2026 02:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1C96B05B1; Sat, 28 Nov 2026 02:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FA76B05B2; Sat, 28 Nov 2026 02:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 709386B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:27:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06C86A818C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:27:30 +0000 (UTC)
X-FDA: 85483697460.23.E674F1E
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf02.hostedemail.com (Postfix) with ESMTP id 662D380009
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:27:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SQJC7cRS;
	spf=pass (imf02.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795850847;
	b=vu9hq+5x45YD3q3yzA3vtQFRU5pWmeAnarV/jw14FOBUjA12FRa/uSRgO84K5fGPsQpK/T
	3d6zpvlolIkFafQzqIWyH+8B0ebI0LuDomJmUZYh+Sy+fK/cWtQsT3Mxp532/4WIsjM3DK
	NnEED9Q5oP+xgzP+pbk+U/IQv+PPJIg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795850847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uXPgXvBJT57DR1S+V3IBkpL9Dt6mi6Z/uuu7CuFzrb8=;
	b=RuvPN5Hy/ZtJHeoC4lQ1ov8HaG79C93yeRgXmxZP2fNWCeSItrKE4DxbtEMG1u5FDNoXrj
	/slDCXuX1MMgH7mZXr+m237PWwcIcKEB07ez0vMNlXhig5KKe1kO89vzmnarBqkwUabI+o
	9uqvqhuAr9GCeeaew+BzxiZJY9pKqVw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=SQJC7cRS;
	spf=pass (imf02.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uXPgXvBJT57DR1S+V3IBkpL9Dt6mi6Z/uuu7CuFzrb8=;
	b=SQJC7cRSWEjLbpHqVRB+BqMMel7rrly3hil4T6/9JLroEsRPJ7J9axzhBt/AYqMCverJa6To+
	QQ51V35MLf4A36Vab01XTQM1VnVkLvh4PzsAyivPZ0/YlnEt0SJ2jsw8YAngiu3b+uGKW7Ew8JY
	jZJzF/KYZUPKeMGBczEfZCo=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4jc20Y6V9FzmV6J;
	Sat, 28 Nov 2026 15:26:53 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C12D40586;
	Sat, 28 Nov 2026 15:27:19 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 28 Nov 2026 15:27:18 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>
CC: <shuah@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <hewenliang4@huawei.com>, Long Wei
	<longwei27@huawei.com>
Subject: [PATCH 0/2] mm: memfd_luo: pick up seals added after preserve at freeze
Date: Sat, 28 Nov 2026 15:24:42 +0800
Message-ID: <20261128072444.1114964-1-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 662D380009
X-Rspam-User:
X-Stat-Signature: skc1icthckaphabta7esjkw4aosa6bbf
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795850845-58554
X-HE-Meta: U2FsdGVkX1/NxPNnI4rRro+pUi9rE4ky3mErgC7V+dK625ow88dcPAD7H4k2W3tTi2x6LdVL3YtmN6ydW3smR3tYnDXOogZ61FEORR8sm6fl91b7erTeayRng7r8BIxGOa8RTB3SwhHyQBlPE6iuDKMyPETptaUHza+Yvi8CyiMmBtJroOoQfkZ7vgeV9nD378+Lo74N26aF2KsOHvC45LLmjTPBhg69IJeZq602CdY9x8cbr9EtJ3wXEVH7vDbx0CuIpKVgZ0L2loHbVxbUk8qjM3WhMbmTSbJvwUR7dEs9vUB7qMu3ccc8YA5XeckNJjJqKOmuXDthQFpk8HpocpzynWbZe3VclrAmQZDQSZSWVfpbEmvv+2ueNzgRBe9kkBXPj0ZG+oBS6RIbqxp7UQzjeWe3lVaGj1ccir4ybjzBHdnTb3tW77SmigiDfI4CcahAy+eQwmpovFSCbEB+apf8uWJDx69gNwfgXF14S7GUFPmAXZV37orkWIrDmvdLLx1dyD/TkHRWdUHpOSrCSITzrs+spFuPWTw1Pf73APkPArIszZSP8SftGkqyMyU9IRGUpxYLdK0Sbmhca0dXsrXYPs1LprJBxwAfhTdMvtFP049NIkZ/XWXMhQEbLiRVz8Ap3fhV90R/0spPxZJBQLcpLdKwwnsoWEdslalioEkZvzi0yI7mDmSky+WwjPEcDTE8DPoYaBoF2EwPljsASfOfcSVRDHjaBGTvaPDfBvUdykHJRkbX1c2Q8LFjvb5CSZwfXf88FPf69WLG5zP01zBlWdMraH858mSvNW5uAbrCeOs9C4EdUKqXLxli8ZCYasm/8nhV0UAByjAchODpHfwusabnaz2ctSDg5Fmh+U1bP5br2A1PuHA95FzMaXFejgqXGhZJjeJpfp0XC7jl1RbcEzoEj5Ffwq0lP9wE5tWYRJgdjJEypHIKbnb9DA8VCrnSogzWMyeI8g5aKzK
 vDj7dqwb
 IzWwPT7FZ3Tc7ibu8wZ2fuiaLkw5/yMgxru0m3pMH58GEKrauJacmIliVxrASkOUPUkX3Rhg4jp4o2V+iRzmztXzj1SZ5yqDhdKsjRApBXxXB/3lQDeVDdt7SaRtWc05uD0Zj6yWEpZ3L7+HSANvZEIpBiAQaeH0r5oTOqGhE6P053RZI2qPForPIEOf6xdEGcEz+Mtnbt/LCt6e7a+PG188v2bKMWCQXz9Tqsjwbddnm/Yb1j3XTdiRqEkkVvCD6KfSPO341AkF32sipVyFi7uRY1G6E9da1IEIz6yOb2AwCFpEV/jp17hfB91KifwCWR6OulCS7UjPbI0bnZfPTKJKt22kdqssr94/vY9t6FwXs6cAfT0Knw5fXjUM+1srZhUUcf9t93dD6MbVfBwluzRh/dYdpJitvczk5OEy9VCKKt5uTpl5925lvIAl3eiqT1g2wzrLRpmeKNDyCdZwqzjpVXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A seal added to a memfd after the memfd was preserved with a liveupdate
session is accepted without any error, but the seal is silently gone once
the kexec handover is over: the retrieved memfd no longer has it.

memfd_luo_preserve() snapshots the file seals, but userspace may keep
operating on the memfd until the handover, so the preserve-time snapshot
is naturally incomplete.  memfd_luo_freeze() never re-read the seals and
memfd_luo_retrieve() replays the stale snapshot, so seals added in the
window between preserve() and kexec were dropped without any notice.

Patch 1 re-reads the seals at freeze time, mirroring the file position
handling: freeze is the last snapshot point before kexec and the only
place where the final value can still be sampled and, when it diverged
from the preserve-time snapshot, validated while the live update can
still be aborted.

Patch 2 adds a kexec round-trip selftest that adds F_SEAL_GROW after
preserve and asserts that the seal survives the handover.

Tested on arm64 and x86_64 with two consecutive kexec handovers each:
with the fix the seal survives and dmesg stays free of new warnings.

This series applies on the current next branch of liveupdate.git,
where the file is still named memfd_luo.c. I am aware of the
pending "mm: Rename memfd_luo to shmem_luo" series. If that series
lands first, a trivial s/memfd_luo/shmem_luo/ rebase will be needed,
which I am happy to provide.


Long Wei (2):
  mm: memfd_luo: pick up seals added after preserve at freeze
  selftests/liveupdate: add seal-after-preserve kexec test

 mm/memfd_luo.c                                |  27 ++-
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 .../liveupdate/luo_seal_after_preserve.c      | 170 ++++++++++++++++++
 .../selftests/liveupdate/run-vmtests.sh       |   1 +
 4 files changed, 197 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/luo_seal_after_preserve.c

-- 
2.43.0


