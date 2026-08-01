Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D689AC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BD8E6B00AB; Sat,  1 Aug 2026 04:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646FE6B00AD; Sat,  1 Aug 2026 04:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F6A6B00AE; Sat,  1 Aug 2026 04:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 351BC6B00AB
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B21C116027F
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:42 +0000 (UTC)
X-FDA: 85052077404.02.24CAC44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 27CED20005
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kt4e7q6D;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/vB3WD/7Dj176UGptU16rqTkNJk3eC17XvdFm9X+ws=;
	b=VtTtiQ3uwlqu0pG95KPr+0mo8nVId0qZihL0ohXoeFnbU5n/XQWcs1l2PbHUhw4bsLbfdq
	BDhWWZljIBTNirAqxkwd5bjKuQ8cs0uNh8j2XY8xqBVbjY9PapbN51A/6N6aJLNV9E4W5o
	Vv0vxQ6JlqlrcBFyX/47WBhkgwLMFl4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kt4e7q6D;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574181;
	b=6dp7nr3s7uZ4znaYUD8oGjMuvBAmrgFQpKd44XkPitzoIFRfrGbMr1+TlASoW56QYuvFrF
	Okn6601pvM1OgiVnkiM26Yug4k1uLtNxrPXeB8TAWYd+IG8IBAqYfPmXqS21vHEu2Oh9vM
	er6uubvRAKE1r61jV3/S+03MWLo1PEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8B9760AAC;
	Sat,  1 Aug 2026 08:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5867C1F00ACF;
	Sat,  1 Aug 2026 08:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574180;
	bh=c/vB3WD/7Dj176UGptU16rqTkNJk3eC17XvdFm9X+ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kt4e7q6DHaIsNzhM8Hw4l1ztlRsErtKU4viX9Gl/BNomAKQpvGAAA9c1FE0iHWYQj
	 nrVNtyiE5aY63+cESIDyPXCrFy7e2q74mPOoylQJMu4gGxMWF2kr5NzUI1BDn65pn8
	 jbJOTl9xHM5zcJvjqZIvC21TOnnJt1G/0IO99ACEjJ+VrShTKRZM/9QzwPoCWcTdtE
	 r3qs7ag92TaD5qxD6N3WLvhQAz0SVdJ9h/4nHr6Gsk5rhGUP/XMf8/RRA1RpcYXbNI
	 7rWXFthAp+VPTyzkn1FdzeneJP4Id5dqbZvQqvFml7AyqYtfzeZLWVcG4OH0AfBGby
	 rgUfQXBanMW9w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 19/22] memblock: always include KHO headers
Date: Sat,  1 Aug 2026 10:48:28 +0200
Message-ID: <20260801084833.1897543-20-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 27CED20005
X-Stat-Signature: c48mdx3tggqcr6puq84k8qyxn744kz5b
X-HE-Tag: 1785574181-896680
X-HE-Meta: U2FsdGVkX18z7MuJik5H32HhRkhi++899tOe+kjb2z4ic9Klcw7W/djhrQ2jjAqaruARxiDI44UGo1iRpjW1zrxHXP5ogXTGc2x0Lk9V/IkSVo8+lIXIZyN/camKQFvMy9PCNuob4qoe9Wf3Zog3Cfi5Tca900tpeDwQU3ry9Bi+v9BPWE9rxRHOPEz+d60ZqftiQpGC1HefgMtrTjEobQ1km2MFKFZHWUo0LMXJf08gXw1DoQtsJvZHrA/Z5QggOILZkZFLMBaOgG2fhT+hoP4cErmV8egNHMHB2xzkSVTKNUFL2o8gO1vVGHT3mqkgo7eZTbjAQy97E6K/o9Nz8m07lfgytIbYRHzp1y7cG8psVxU9FvbiU6Xa3XRAy2nw4pFaBDXsj8srbWm8ffKfUBZkYNC5FuG9z7O5lylvgcn3quiNXAa9LIBPGiFrWphql/WK/5tSwXC9ujjaJBH/4Oj6010kZYHkJQJa5+6PA/7g7maDZQvdzXhk8LAwPOlD/etmKjR8/r3Q0c8kjetPZOIItdiT53slpXO5P41/ndA54rhdwaBTmGkqeicjr7fafErWIiFkqJjZslG/WnpcqZu3a0IimfMBqzI3pg2m68H0AjIwNkBQEIV+Ni6OS1YpBWXS1HAk7NKXmACnA/Z4pZeG1uwBfn2n6NSF5+lvjCcq06XsV+7VTaekF6xHYrJrdOLcU8UjX43J/xut6kUcEDMzaABfEPSW24iVaYnQB2BRbO3P65QFoBfEAaB7zJG2m5rsSXd859pIo17b18IxLlCRRsOaa8OwjkWtmHBPhYzyN2azlsI+bvIA+eed1LA39/gYkEicLn+v0AqpZ5y1CqW4PAmpMzU0iTIVu53oS3UqEsOQ0ptdDbmgxIqHi1A4QjkYn10casM4EiQeeEAIZGrgW+I+wKZxjhAvO+3VCFF0BxCw3fTXUaXv0i/2uRgXbCJN4GtIYtBt5V5/Wqt
 8V53/Op0
 Bus3QSxvOFE9M0ACXmvNHWfZpKYOti30qX8nt2QOIG8BaL8MbLI08OmuaFZijbbWrD+UblLAnxu9TmCDu3MjmMp/5imbddhJlOVdQMS7fvrIOVfwmddsY/XYVzhts7CrpWjIeyO33E/DQQTiiznosbBbL4mnYqPBSh5pGcwj30MsyMTNWzQQ0arjUo4KRnPvI2PFMWyywfYTAfm0loynuY1ovky6n7G54xfvIWyCjRXyB845Fx3TbdI17RxkzqCIE0WcqfLI+2vV9AJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

In a coming commit, memblock will start using kho_scratch_overlap()
without a compile guard. The compile guard for the function is in
kexec_handover.h and provides a stub when CONFIG_KEXEC_HANDOVER is
disabled.

Since in memblock the call will exist unconditionally, always include
the KHO headers.

Including these headers unconditionally breaks memblock test
compilation. Add stubs to fix that.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 mm/memblock.c                                   |  2 --
 tools/testing/memblock/linux/kexec_handover.h   |  9 +++++++++
 tools/testing/memblock/linux/kho/abi/memblock.h | 10 ++++++++++
 tools/testing/memblock/linux/libfdt.h           |  9 +++++++++
 4 files changed, 28 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/memblock/linux/kexec_handover.h
 create mode 100644 tools/testing/memblock/linux/kho/abi/memblock.h
 create mode 100644 tools/testing/memblock/linux/libfdt.h

diff --git a/mm/memblock.c b/mm/memblock.c
index 8b2e551435ae..ea735bcd4dd1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -19,11 +19,9 @@
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 
-#ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/memblock.h>
-#endif /* CONFIG_KEXEC_HANDOVER */
 
 #include <asm/sections.h>
 #include <linux/io.h>
diff --git a/tools/testing/memblock/linux/kexec_handover.h b/tools/testing/memblock/linux/kexec_handover.h
new file mode 100644
index 000000000000..bdfd9445b1fd
--- /dev/null
+++ b/tools/testing/memblock/linux/kexec_handover.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LINUX_KEXEC_HANDOVER_H
+#define LINUX_KEXEC_HANDOVER_H
+
+/*
+ * Header stub to avoid test build breakage; we don't need to actually implement
+ * any KHO functions as they are not used in the tests.
+ */
+#endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/tools/testing/memblock/linux/kho/abi/memblock.h b/tools/testing/memblock/linux/kho/abi/memblock.h
new file mode 100644
index 000000000000..71cf6982a2b9
--- /dev/null
+++ b/tools/testing/memblock/linux/kho/abi/memblock.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_KHO_ABI_MEMBLOCK_H
+#define _LINUX_KHO_ABI_MEMBLOCK_H
+
+/*
+ * Header stub to avoid test build breakage; we don't need to actually define
+ * any ABI as they are not used in the tests.
+ */
+#endif /* _LINUX_KHO_ABI_MEMBLOCK_H */
diff --git a/tools/testing/memblock/linux/libfdt.h b/tools/testing/memblock/linux/libfdt.h
new file mode 100644
index 000000000000..6137b788fe8d
--- /dev/null
+++ b/tools/testing/memblock/linux/libfdt.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _INCLUDE_LIBFDT_H_
+#define _INCLUDE_LIBFDT_H_
+
+/*
+ * Header stub to avoid test build breakage; we don't need to actually implement
+ * any FDT functions as they are not used in the tests.
+ */
+#endif /* _INCLUDE_LIBFDT_H_ */
-- 
2.55.0.571.g244d577d93-goog


