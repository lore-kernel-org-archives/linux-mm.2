Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030CB606A335
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 02:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=1TqRhmzC
Received: by kanga.kvack.org (Postfix)
	id 138616B094D; Tue, 27 Oct 2026 22:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9766B094F; Tue, 27 Oct 2026 22:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19DE6B0950; Tue, 27 Oct 2026 22:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3D376B094D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:37:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E98C4A8914
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:37:02 +0000 (UTC)
X-FDA: 85370472684.14.1182725
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0BD9A140003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:36:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1TqRhmzC;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793155021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D3jriHWWTJBoIKf4eSRYhB262kHqi+/i8ZptpC+x1wo=;
	b=0f/unAdtMOmH0+83hw9zTM0Urwtd9TCsHD3TvLW5aBUUCbKxeKPzBDWD2QWYrk5FqR57pf
	8L6MJ8Y3FNhaT3rrA99mi2Zf3Epzvu5nw+Bzc2ASVJuNHVPvRYdInRIEVxBdGR82R8ZrMG
	+hpkEjeSYDJP0npbnJEvmNQrqulmRDk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1TqRhmzC;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793155021;
	b=IOkdMYbJnQtOMEhOZfupEFQg7BGEQZdLASLc1pd4PQLgtyVNght+w+bK7KhUTuXrBOI+28
	LQXx0IGJh+UgxdZ8l7HCoHoeXS9RXAGBCKLnMdihLe5lqcmqUYtG7MWOFvhnplWe+0e0v0
	kgX1fa73XHwbGEvOGdgPCGqHw4VM900=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=D3jriHWWTJBoIKf4eSRYhB262kHqi+/i8ZptpC+x1wo=;
	b=1TqRhmzCLRMWQJRBcT0arpnkxWoLiE1ZEMrxdfGvEL4o8+7xFtf//Lbqqsl0t0BwcGOholHuK
	CD27pe6zL3M+uJw78If21G68tCgNmo9XT47Jzsoc9jH5X+3iEDS3+idkG5wmydcWVEsCcoriN6z
	OCtacQJf5lbKL3oGytcO8d0=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jDs2M1H0fz12LCy;
	Wed, 28 Oct 2026 10:36:59 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 2572F40579;
	Wed, 28 Oct 2026 10:36:54 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 28 Oct
 2026 10:36:53 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <sj@kernel.org>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<rdunlap@infradead.org>, <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH] Docs/admin-guide/mm/damon/reclaim: document how to disable watermarks
Date: Wed, 28 Oct 2026 10:36:28 +0800
Message-ID: <20261028023628.795637-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Queue-Id: 0BD9A140003
X-Stat-Signature: fy1nxsxmikd37a657op3r9ztxeu9fsm8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793155018-917154
X-HE-Meta: U2FsdGVkX18JFaU3oDLtGlDv+2cWkeniLo+6AjQM/C+qKWfj8Rc61u2U+60pbFxadGZm5kjzwFoXX7yLU+TsscJYl34hLYGKbFLjSWO0+LYUsFNhmW+mQMFdgdf+5G5E4EL9yz6wDk85BjcxIJ8Yxn/1U5kx9RZLir+No2T0rMukGgzLEO0oDd12k5z21ODeNYV7IY8TVCMBK5FNIsyy2BHmXJx5/L8UTkV9Io3uPA6/2sJ1AqN8ocN/SHsbqjKEfCqjpuYKXGMJOOtfmLGUSVLroUpocmIcol6OuugekTBYZ3KVRiXW/jGRdcJaZq8fmUcr3jFKV+SILTFoHhx9gTYeEOEkUANV2xBjmcNa7UnObRmMNAOlI78Wlt64AaHI7GK6ndJHde3swfx7C5AWN9b4ZUhpdCSkpvUin9w5aajGzHPFt07oC5zsHz2US18VaDV9o4k8uLbaMN/2LRH/XW9pwoBdGC9Gx/hZ1f3CGhdnUv4CsIPASfkHhKDKvt+wAkPFPwF99jUunOAfD62Ekp7ltmJzxh46zSyKag1mJtiVueHZoyzbgy9Mqh8rrYnUjROETIIGoNcVdSGwXXJq5vxmMU9akk/JZfCWx3kOjhiEqo/0usrrqKvBCiv2PrOdFwNPAOJp9ed10qBAMRnlDfwafVTzeq1vRmDy3eiX81ws3cND/uIQoHlFj33TpT5vI2g4uS47ZUL0OCMZMJCgskXLijMpOZwsrDvyjjiZrOOKJt3iiqO0Nrxc2wKuYx5XL4qOsKcT6YIML6FD4hX6j/AV+/CotcL1z0KfwcmVA93/ak5fmVPAanZenRdVJcFF/LSlXGl6YR7suncMhjtjC1Yq8zS0MqUZvDXjvWreZ+pJg0QwKUZkYmYT0HYvUgDqLUtnLkiOHZBwSzjxzqNIyycNb81T49qRlB+0zCEZ4LLaFWdYf6kPIckCmPSyc/YKHZDOUpJYnIp+cx7/NzM
 y6WWrhRx
 yAJYPQRk0Bs8CjVqYquA3aDunKgNobVUTWKRsErHNww7Jr68p5WR2zOHV9jNhC9RsrnpU8XoO/n5VVOBXEcJRscImBbDahfjSaANB4D6Pcgmde2gt7SeElTcYggrK3tzIu+B92JLyIqIksZc67ihjFVQ5L7GbHJP3ihSGufvwfbWX9Ad14CXc8/YPD3Bb2ULEJoYPoxbue12O6HH7qTkqN4TtypUh8ftffdJtx8IW5MjvBrx0wlc4tggLUzEaSeoAa+BO2F6wnjF+yg7cUqxiryLHQ68mx6z3wjr4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON_RECLAIM runs its scheme only while the free memory rate is
between `wmarks_low` and `wmarks_mid`.

But some users want to reclaim cold pages even while the system has
plenty of free memory, and it is not obvious that the existing
watermarks parameters can already do that. So Document the setup.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index ec7e3e32b4ac..23fede7d1cdb 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -193,6 +193,13 @@ DAMON_RECLAIM becomes inactive, so it does nothing but periodically checks the
 watermarks.  In the case, the system falls back to the LRU-list based page
 granularity reclamation logic.
 
+To keep DAMON_RECLAIM always active regardless of the free memory rate, set
+``wmarks_high``, ``wmarks_mid`` and ``wmarks_low`` to ``1000``, ``1000`` and
+``0``, respectively.  Then the reclamation is limited only by ``min_age`` and
+the quotas.  This is useful for reclaiming cold pages even while the system
+has plenty of free memory, e.g., right after an idle virtual machine is
+paused.
+
 sample_interval
 ---------------
 
-- 
2.53.0


