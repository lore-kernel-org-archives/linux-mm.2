Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FF94F506D7
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED736B02AA; Mon, 16 Mar 2026 10:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F476B02AC; Mon, 16 Mar 2026 10:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB0186B02AD; Mon, 16 Mar 2026 10:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6D996B02AA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:09:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74AEC13A110
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:09:51 +0000 (UTC)
X-FDA: 84552109782.18.03B2A19
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B4521C000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:09:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf20.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773670189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=zw/3IeyCwhg/SIeplEBGUgR9ryUmhmKOd84WJXPD4wY=;
	b=KQaTU9WO0AQ+7x7wJ2ENwpCtgFuL4Rp7ZHW1PJj6lb4LGnXJ109cqFpjZTsV5jll/sCxIg
	H/Oh/rcSigo+5NtIvDYF3J5WGwCtP0HDSE8diDEVk6/oPbf+DMJ0DLnbjlNX6tupXEtTV8
	/YJl9Z/nwXk5unqHhwm6z7x1aNk6x6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773670189; a=rsa-sha256;
	cv=none;
	b=w4upjpKmdyFDq4rnl80crjCS4kN0kMD9URLHUE/o9UJd0zMCsjHzEQdZcg1WctuSSPEl4C
	N6xdP4gjegAAE8ea+uE5XrLIUfsIpPQy+cbGdAf0C6ae/8qprnKkoD2F+mG55J5ESNxwMz
	CKjF+b2I+rW3mJUygadffpZDDF9jPSs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf20.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZH4t4vNVzJ46DS;
	Mon, 16 Mar 2026 22:08:46 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 3722540584;
	Mon, 16 Mar 2026 22:09:41 +0800 (CST)
Received: from mscphis01197.huawei.com (10.123.65.218) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 17:09:40 +0300
From: <gutierrez.asier@huawei-partners.com>
To: <gutierrez.asier@huawei-partners.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<sj@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/1] Docs/mm/damon: Document DAMON actions when TRANSPARENT_HUGEPAGE is off
Date: Mon, 16 Mar 2026 14:08:21 +0000
Message-ID: <20260316140822.2033181-1-gutierrez.asier@huawei-partners.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.65.218]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B4521C000E
X-Stat-Signature: kjk6e6fhze6q4pw1u5qbwngjkjjeptgr
X-Rspam-User: 
X-HE-Tag: 1773670188-327396
X-HE-Meta: U2FsdGVkX1+IGEOjYfTkEbWImBUwx1aiNVasUOpzBJyJabJ0WZRwYQTBYBPigMBLh9LFxgfmbTg5ys/btnXFOs8RWj+DUhhjedUuuV5/8bAwRk5CerThDXEkjxdE67GKf3BirySJ9LT6S3lyZ/ySIYxhGt52tzOzO/6/MeBo+buKuqalF5jYHdwHgCu4Ngow8zysSerAdJZydR9riRa1Qtn6eOxY7AZBfI8/NLZ1liXS3t5Hy6A55e5GncEByJh0FSa9+hlYhbVgTum1qVSZ+2L3271xNWHF/+G/RrzRGdQ92AShYYQcD8kZwx3cN9FxYs17dWRRYzgZiFXko28hb1g1pcCX/js/On2MGx7ZzbwZ5hbEX1O2trSza7M4YP+4PkqGQ1XJJI/rqNme8Q30ay+C3BVUwj97JEDxGwzRcz1uJ9uQfHuF2PdxQB+yZBIIMcpSTz63PchO0cWtfOWnLhIsoNeiWmokQZbxmVYZFdAXeoB8+sXg5o5nYWq5SJzqAbWkU2ajkPomrAARWRQzoGIZV/FE2I75a+ZVT9B40v90sYAQbIcDE0KhM966O/8mYo/65SgwwD2gJr6P3iVHsHPz7G6/Y/6AcW8tLldhC/sS3VmmiItBKVd1g84VMNVbqFbo8ROtdmU4WgFk6tH/qoB6b2++VPQsGtnGIr6mLd1njZAp6JrMA9VkXdEUslfDrRm6OEzNxSMFOLNLUCX5vKL5ANtRpdY2FLXthaU4WHEXY74cvJk659HAezILtMAiMJubOaKbQRvXP2Su8T6Hc5alVhs+YY59SbUWEHnjRS/nQ4Blc1lnTpQEN7ilJsaTA2FfqtDXfx0cKg86W9ApAI395It4EAWDjpKSkA+RT2e4PLePcPzV8dLuSezpVUfAMAVxwOrDwF2HgpOhY2u3dk+QCz0yiI8fuxsecW+aDrZoaD2+0+kvj4pTao73Oxw2qeAvPbQZV9zpmugNKLo
 jrlsbR8d
 gWU3Gm6sh8UT+ru+lBpXjS/QIrXDhHZlPK3a77zRhWfUSTgBJqxZTS4VyCbUeRcv5XIXR/GcH/Oe/Wwhx+W454IAQ8/y5llkogVGOOlfTuUyxYBloPQQq53AFltXCgh/tBUHv97TJhj5MEtZ7PZ+cNWqSUtdWJI6P6+azjh8BlCfd9e7OYtPRhtSUZXe2Y8KvPZ2fy6+iSUf2DBuV6QswBu918zULzRc48mDWoba/CoiTgKsesCCDiLNWK0Veyv04o+Z9WOu+lY6cvwElZawTVG35H8ijPbAEAIIYuRo3v5n+PJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they
are not available when compiling the kernel without TRANSPARENT_HUGEPAGE
option. The DAMON behaviour is to silently fail[1] in when DAMOS_HUGEPAGE or
DAMOS_NOHUGEPAGE are used, but TRANSPARENT_HUGEPAGE is disabled. Update the
DAMON documentation to reflect this behaviour.

[1]: https://lore.kernel.org/damon/66131775-180b-4b9f-b7ce-61a3e077b6e6@huawei-partners.com/T/#m278d3c9bbedcceaf2efa51e3dc7b40a40654e51c

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
---
 Documentation/mm/damon/design.rst | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 29fff20b3c2a..478eab4a186a 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -460,9 +460,13 @@ that supports each action are as below.
  - ``pageout``: Reclaim the region.
    Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
  - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
+   Supported by ``vaddr`` and ``fvaddr`` operations set. When
+   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
+   fail.
  - ``lru_prio``: Prioritize the region on its LRU lists.
    Supported by ``paddr`` operations set.
  - ``lru_deprio``: Deprioritize the region on its LRU lists.
-- 
2.43.0


