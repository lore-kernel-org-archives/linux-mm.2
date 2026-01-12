Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D193AC9EC77
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 12:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E466B0088; Mon, 12 Jan 2026 07:25:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1A36B0089; Mon, 12 Jan 2026 07:25:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDB26B008A; Mon, 12 Jan 2026 07:25:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1766B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:25:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC262BD03A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:25:06 +0000 (UTC)
X-FDA: 84323231412.29.281DB2F
Received: from out28-221.mail.aliyun.com (out28-221.mail.aliyun.com [115.124.28.221])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16F20140010
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:25:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=D9J0ZIyl;
	spf=pass (imf09.hostedemail.com: domain of houwenlong.hwl@antgroup.com designates 115.124.28.221 as permitted sender) smtp.mailfrom=houwenlong.hwl@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768220705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W6q6jrVZBcY3e5Gy+REWr2FSrmxj9FY94K4NJK1jOcE=;
	b=UMnJhQWTs7XZsOV0PCppUUjGMP/pGTUOauDTRkazH6tf03zRdqwta/xycQuAkSJtrO5SBU
	XAFZzSHTC9iocmNiC3FGf3tPR/15olpArzcbiXeu36oAWnTgzXFc50G9XQn17gVfL66opZ
	N2JJPjhAc/5UKsdfl+FMDjKYJ6My8cI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=D9J0ZIyl;
	spf=pass (imf09.hostedemail.com: domain of houwenlong.hwl@antgroup.com designates 115.124.28.221 as permitted sender) smtp.mailfrom=houwenlong.hwl@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768220705; a=rsa-sha256;
	cv=none;
	b=zDHOzgUmNtfxVMJAjVBZWON2TaMBm/k6bBujf+yJ30BjSfsB7W8d34A+2Kf3cJjKUQXlml
	LO4+MfNG9mLKTYO3B2VKjR9pI4iD1JW6d/4xA63d4/M7qY9ltZnJ749A93Zj/Yzhv9RbpF
	gYS4W8bON3Ghgu3PJdqvqxT9U7COj0w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1768220696; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=W6q6jrVZBcY3e5Gy+REWr2FSrmxj9FY94K4NJK1jOcE=;
	b=D9J0ZIylqQwpePRrfKq9dpahycL7DEVwgQX2OfWSH1o4cm0KotRyq1NilNdJLHY6n6BljVTHX02rq04QcLO4bPmDmOLbc9M7w4mzypx6qf1u8qnWj5vMUINF1m8grt3OPSIk/CgoUGmAa/SbFX7SrtKDWAgT+PIyMIAPXgFG1cM=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.g4ekSz3_1768220693 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Jan 2026 20:24:54 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org
Subject: [PATCH mm-new] mm/early_ioremap: Clean up the use of WARN() for debugging
Date: Mon, 12 Jan 2026 20:24:29 +0800
Message-Id: <d4470531ce0c03fd80f9a1be7e8d8ae1bc60fcd1.1768220636.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16F20140010
X-Stat-Signature: 4q81nbftzdijeuky6ff5x4q6orhmt558
X-HE-Tag: 1768220703-374052
X-HE-Meta: U2FsdGVkX18lYcmh8NpFsO5viSJ9NFB6Av4MtaYoR0K/K/lfy0J9Bf+eQklkRqYTVEsLD+4CjN/6YwVtvy2ZXBwIwyQo7htd0w7AjyUGYcCsgCC/b02g8kg0tG0qxmn2uPYA8ljOMejORMXah3U2xGjCeeSXPAKeFXhxYv7D+nD4IEtpn390fKFOuiR3WQr+3t+eoj5KSaxhh8TC5koWNQqpfDWM5tfAWwZxESHYE6hpDYCQCYGjv8paWTcQmAsE8lxzY2kZuxj44K71WYavNf9nGnooYaHQa7Fa131FlerhNVK66h99XUg5aKVkdFNOJcbQ7S5rMWprfGEhjvqKIpYZ22tFAMQZSwYdP3vxxMDZ/1x8o/QyvjwhvNUwiAnX/tSbNMr0n1vEVJDsa5y0vyLDI2tAwUfXv3DXAnjP2pYqqwv/mfcLNH5Uz9ck9AaxvONCLDhvuer97dwgSbcb1VMzWlpiDWM0VSic/5iRPCsyKluuAyLL1sDIneU9g3+V9v7LihdAvjAfdI1z7c5uqiOF/iNPDpyggBXmukTn/vMIIyxS/sF7V0jYawphYxFyRUUx5ZSt2wR0EQ+bSfmM0Hz2sCNk5SU3QYOrk7cwST9DAWcBevESY2Lusn7Y9ZjLo8WMjGX0BeE6Fjyh8EhkxF8YzmCDfcSdr8TVea4QspGMUOvj0ly+ElZV0AUXM4a5yywThif1hPmbk7LAN24wEPbgZnJtHu3Feg+3aSAoVHr11zf0r0MS0aPqo8t+DRL73/Nnmn1Nctkky+bEQGAfkb4pt0inkBl+pKJwG3i6EzHPjJwAx795MZ//piNPqn3Cbn8TbURLsurN1mBkMMr0pL7K6G6JjHO4yxg/TI5WugVLiQEy3gT5aJMIw8KsgR6RgLk4Ho6A9Vi+qjePzw+4xfvoOfEb/KEUqRnUNzTj3h37waO4+zZFZjbHR9uNj83H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using WARN() for debugging is strange when nothing is wrong, so replace
WARN(early_ioremap_debug) with pr_warn() + dump_stack().

Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 mm/early_ioremap.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/early_ioremap.c b/mm/early_ioremap.c
index 3fdde074c9da..96c29b9dc85d 100644
--- a/mm/early_ioremap.c
+++ b/mm/early_ioremap.c
@@ -30,6 +30,14 @@ static int __init early_ioremap_debug_setup(char *str)
 }
 early_param("early_ioremap_debug", early_ioremap_debug_setup);
 
+#define early_ioremap_dbg(fmt, args...)			\
+	do {						\
+		if (unlikely(early_ioremap_debug)) {	\
+			pr_warn(fmt, ##args);		\
+			dump_stack();			\
+		}					\
+	} while (0)
+
 static int after_paging_init __initdata;
 
 pgprot_t __init __weak early_memremap_pgprot_adjust(resource_size_t phys_addr,
@@ -139,8 +147,8 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
 	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
 		return NULL;
 
-	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
-	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
+	early_ioremap_dbg("%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
+			  __func__, &phys_addr, size, slot, slot_virt[slot], offset);
 
 	/*
 	 * Ok, go for it..
@@ -185,8 +193,7 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 		  __func__, addr, size, slot, prev_size[slot]))
 		return;
 
-	WARN(early_ioremap_debug, "%s(%p, %08lx) [%d]\n",
-	      __func__, addr, size, slot);
+	early_ioremap_dbg("%s(%p, %08lx) [%d]\n", __func__, addr, size, slot);
 
 	virt_addr = (unsigned long)addr;
 	if (WARN_ON(virt_addr < fix_to_virt(FIX_BTMAP_BEGIN)))

base-commit: ab3d40bdac831c67e130fda12f3011505556500f
-- 
2.31.1


