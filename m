Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8AB606A88A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=znQ1nDnI
Received: by kanga.kvack.org (Postfix)
	id 69BE36B05B6; Tue, 17 Nov 2026 04:32:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673146B05B9; Tue, 17 Nov 2026 04:32:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AB46B05BA; Tue, 17 Nov 2026 04:32:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 341476B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:32:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9F8A160399
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:32:38 +0000 (UTC)
X-FDA: 85444095996.11.FF26282
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51DA0C0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:32:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=znQ1nDnI;
	spf=pass (imf10.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794907957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5C4RujqYa7rNsHZWdwamxL4wXW4pZCK+kg2c9d4mPM=;
	b=DcIyAdtxXop6Kz/UAmEeO+hH6v8p3USsqc9+gvMDUC3EvXU5HVVXgoD7c1RR099mREbuBr
	qkrQ1klMdXdot1BR4GEzGbJM2lFP6m41leaKpvIInzFMrTHSVTxIlJjjjuhMWnD9ESsoK4
	0vXlaXcla8F1RyigX617Mgy0wjF3Xs0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794907957;
	b=3JKJ5vNjcvl40l0y/n+2ISSnwhL9vwj0s1oaNBKSTSsL9ZOqeThIZp99UjP6nJ7RDQ4Og/
	8IcSAj3w/KTo7la57oBS9JDSkH8ldL8Z9w850ZtSL3hncsQuzp4mes5TbF7BQiSbAzQ9yf
	UT+iDFyL8S77726A0VqmOqFSge2QqZ0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=znQ1nDnI;
	spf=pass (imf10.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=longwei27@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Z5C4RujqYa7rNsHZWdwamxL4wXW4pZCK+kg2c9d4mPM=;
	b=znQ1nDnIdWf9SGMir8UIlbfd1jTstZak29Z+HUh5ZxqFySQz6O3w3Y7VekesEJPsZMNdlghDe
	m1KpNMMAyhtae1KajqunOWgzPIUE0wWxVYiqiLrWJsGOR6MIv3edgRAo4y282N0y/YW9cIDyZ67
	yfhV+AfzdiC5S+12IgP7kAg=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jTKJM1X4Nz1K9Xr;
	Tue, 17 Nov 2026 17:32:19 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D4A24055B;
	Tue, 17 Nov 2026 17:32:32 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 17:32:31 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<akpm@linux-foundation.org>
CC: <graf@amazon.com>, <leitao@debian.org>, <corbet@lwn.net>,
	<rdunlap@infradead.org>, <linux-mm@kvack.org>, <kexec@lists.infradead.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<hewenliang4@huawei.com>, Long Wei <longwei27@huawei.com>
Subject: [PATCH 2/2] docs: kho: describe the in/blobs debugfs file
Date: Tue, 17 Nov 2026 17:29:51 +0800
Message-ID: <20261117092951.4017931-3-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117092951.4017931-1-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51DA0C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zhw6u9yi8we7xajjr6xqa4em4hognzoc
X-HE-Tag: 1794907956-322771
X-HE-Meta: U2FsdGVkX1+AWPTq1HzRBn79PtpOXHCzl/fJALxvQRW0z0Ob4MuydmXBgtl+45gGKk52sX24Y/x3V+hE3rNI7X3wOd39217giA3njArQBw3ld7gVTIwC5rVc/wqMsiZreflwZlSUXLdbmsJS2HZecAaQKvZQsWnx4rj5jprD1dCEBl7tiYobBnbvr12MgpHEw4cN1+NLcQ/piNLaA09oRho4eDpEBX/M7vJXeIv6iDv45z84cuIBVpxzPJX1z1UDl6UMRMLhTM+hGwKQvyvxvT8bfzeHtoMVo0ykntgLwnasstSLr5+6P7z/qoRxpy1a8bdQZWTKtLPEoUOvUw7o4j+Lc4cj1hbZ/FZxrJh3wkmaSs5X8yFieb2hTl0LEcwkXUu+mPKXrjtEwzNPgy0tN97H5F2TZ5CxB2ik/DntKg/kz/sd6drAo17bplJnLMBWcnLwRa1DOfOoA5jNDgxUQzS+V1ZFyzVpYHhx2aNqgVCJd/gZlSWgeFP2X9l+CgRh6VILtNbym/TkSm09pVuIZ56Hhwt0+XepFzR/IrvtgIWQd0OP69CX8mTeS3xjayjMTnbH1ube/3MPuwppka0ZFDBASQkNPSzrLMX2G6IR0gxeDHjd6MSCMa5A8RDLnx5heIryEE4tKDWTvXxQ2x1bqOvA9R1bXA7i2ity+xoRUv+QZJ2DeR3p+WeqTwj/Mz6cNL42rbUPDFlY0mXFSfZV8cR21DuVt5rZMiey1t+QJJ/ErkvU0fxGygtE0YlNyF+fr8OJJuifDtPx5HaubyMVjgnlCKYMwnA2ocm3ufIdD4je622b4CogkcmUwLTbvwrAKpqU2BYD0ZBSY7HgFApgusCooQO4hDkKd2W7SLBj419WW1QAldd7F8p6eoNvBE7us+elxx07BXGeBXDjMV8aoFU/PK9RwuTrys8mqU8PkU1p3fY7OHoMIxlujO8XuQVMJj/vHzzb7uv+GLuSmPz
 vT6Gxz9Z
 /hwkt9QWc7ZfuI8P18PbkKzs9kGU7xI7zDCUFS0ABDDiTejBSy3FZe5gMUgN1pII52/znyWqk78pgevHEnpdTdFMYjUvnXgN/JpU72e/lTO3lILrRi9W/qLDwJ5hlx//k2X+A2+ZjACJL/adZcfnnfH4eILZpf5bRArIaxEB7t+1p6bVTREX2dwuhEW+AGGjrcK6Gm8gcjKSDEjRX3ZVWP/eDoY9LHNj4aFSXNBd9cwrhJhAmh9GD8C84YDNsD3V5hNcOaeQzCwr8xPuYB61Y4msFuzMjApUUcJFb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The incoming sub-blob raw nodes under kho/in/sub_fdts no longer exist:
the sub-blob pages are owned by their consumers and may already be freed
by the time the debugfs view is created, so exposing them was unsafe.
Document the in/blobs metadata file that replaces them.

Signed-off-by: Long Wei <longwei27@huawei.com>
---
 Documentation/admin-guide/mm/kho.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 902d171a780a..602c8ce90e9a 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -118,6 +118,6 @@ stabilized.
     device tree. This file may disappear when all consumers of
     it finished to interpret their metadata.

-``/sys/kernel/debug/kho/in/sub_fdts/``
-    Similar to ``kho/out/sub_fdts/``, but contains sub blobs
-    of KHO producers passed from the old kernel.
+``/sys/kernel/debug/kho/in/blobs``
+    Metadata for the sub-blobs referenced by the incoming FDT. Each line
+    contains the name, physical address and size of a sub-blob.
--
2.43.0

