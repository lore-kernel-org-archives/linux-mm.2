Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6103EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B536B0088; Mon, 13 Jul 2026 03:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDBBD6B008A; Mon, 13 Jul 2026 03:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF1506B008C; Mon, 13 Jul 2026 03:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A62546B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:51:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E3AA140984
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:51:23 +0000 (UTC)
X-FDA: 84982983246.09.BBF1140
Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	by imf12.hostedemail.com (Postfix) with SMTP id 357F040004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:51:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=gvknQOu+;
	spf=pass (imf12.hostedemail.com: domain of "prvs=md164857AA33=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md164857AA33=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783929081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qcEJ54+AUEewVbFtDXCKNzdvv1NVqWy7FgqDnJtEHK8=;
	b=me2+bsqOpTQgHe2uCbaiBKQBfu11UibuAttrdpDico764kRNYlxVE5W9Y3Q3CDLhhKteJQ
	15dOPp6AL7X4531wP5GMNXLR5PULrKSn1l73jlxkYk8FLzQ/8ofYjE3UW2JuBIcGnt7rDH
	Ix8Tm54sUG/15ZXpOcz4qnVE89Q+2Do=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=gvknQOu+;
	spf=pass (imf12.hostedemail.com: domain of "prvs=md164857AA33=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md164857AA33=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783929081;
	b=wiRqy+5eBV/U8OZiS0P5cXb3nc1+F0rqR+20/Tr7uNVKPp+aAx5p4qeBxnOVJ+5+6lI7GT
	TEGI/WPWqagwjc47BcPxA33aEZzuqP2CfvFArbN3D0rNkI7BtjBckj5MOxC4qihSzhMDOJ
	6NEEQBo3F/evrOMI86jVddFPnk9FAZA=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
Subject: [PATCH v2] nodemask: reduce bitmap width to nr_node_ids in __nodemask_pr_numnodes()
Date: Mon, 13 Jul 2026 15:51:04 +0800
Message-ID: <20260713075104.2196-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjhj-exc3.internal.baidu.com (172.31.3.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1783929073;
	bh=qcEJ54+AUEewVbFtDXCKNzdvv1NVqWy7FgqDnJtEHK8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=gvknQOu+ZPGI8aQnj0l6DuqwaRvcwP+VWGOq+p7ve4BpSWK1zirtStHbKhc4vIgQr
	 yR1aQ7riPFJhL5xZb1cq6qB+yD01z0tAXESyrwHgzMEWbklz22F2mPle9p1o1ZbFPH
	 6id+yLDO2BkFv58MTNBPMxjfeUUOzuuh0z/Q+kUZSPkd7yqc+GdsYbxAtPGRunQt4L
	 UbuR8StN7diA0ZdOsuYTuxLWeuwQmK9+dJZBqydksEZlGcjkJDrznlz8/9prPZfTBq
	 DByWLnqq7FrEiU/Im4cOlaqAR+Zcs2492v7hRmozlI8wsSix8VpT8+6W9kBBy0OVV0
	 +g+lWkJH0Q3Nw==
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 357F040004
X-Stat-Signature: udwmq4hgofgs9si3m7hkinq9oe9ig931
X-HE-Tag: 1783929076-56149
X-HE-Meta: U2FsdGVkX18Zkx4AyNu7wcjSR5kB+apEBRrlSoVeMMPBYB0gaeoff8aLO0k0zCjbxn+JhJru8I7xKlcDTFdLkAbXd+Gef4G3I/WUXkVWGUW7N5Yd/ifKST5gOSQf6KrzHssnvg7y1RR/c3gHbSHk7a5o3yRX0BtMKV049EhjyqLy8oFIzlK+M/2V63kis3ZJsNnp0Th4OgPWKvnptuajQk1/rWkMmnlT+hEtygMt7XOrEnAj0vfO+mrTRmOWUDUiWEy1N4/z8SH8c9J1UZ924s9ZEE6xKXKbGzsard83eewMjBrfJePc7p312UGpnv5TLbpusS+3uDMSwN57yhCx4Vlj4l/Q4rmJ51OHReB5P9Oy4CifrYVX8janJ0wqcrf3YbZilv5MFTvZ4b9aQPN1jHukd5kmGgnueZaiOHuLO+MtFGzmHlsPKwWW0Ndh2Ws35U/1x4/2ZV6orRnmMYAWKMJQS3GBnaeSuv4Z00DftGsDcoP4cMWVoAwXqKvQ65Q4dn4JAwmelbqaZ07/RoXUEusE/9dJyGP+R6L+bPRTbe0kzf8qUethZNfGwNd88SCPcLNfhUfAh+nqjSjKpNg+G25KDsK/dkftaXamYHTtTj+6uuxI7I6nOlqfoAI/5AuquqpsH9VK9QpxVn68Kx6wRHSeG73Dl2hQ+5afMLyahbEKrz1JXYnlZhWmSewiIG4ebhJOER/RnSmJct0eel7J3IDKAabLm7ON+aQyyn0WUf0Wr7fuznboxXusQmJm/X0LVUQYAjJw8yddBljcZp+FJw1hfETwlfiq9ZNZfDt+GSmMhtJE02Ymp4D71eMTIXJ8Lq1rqX5sWGfj9GHC3psXdaJV7g0gBkt+cna9Ak6r2D4P+0RX7cdRiI6CPX+gDh715tlvgC5/nklmhAFHZ0AscNOBnl7G8jwPr3ths64oi+af1NBK7Ojv0pWQW1q8E/5bo9mdMAkUWX3PY326W5s
 BYx4ec0s
 t08/JxLw7fTLbXPXQrEtnQGRBITa90EEzToef4sXkMTJ0Wextw25uWjv6r6iQ+9Lu4cBnSg15zpDXX3Srx3fAvqFixHWC41RiqjiUn93brlfYONrSvFWpyXE84lro0jQni3zRLArOf4BnyAdk+LDZGZRzWhT0ZRQ6erNbDRvP75OP6KArjDaBj9VG5IOCwQcoCYwyEPmBN8nbTzO1+/XCRx2WLkdmUFRfDWdbvpsyqKxCJUBFEimSpMkMc0D5SjqUdWNB6EgHyv+pyw1GGbxZ4SsvE2OqNTY2mCUCpud14ZmWB6zjrxIWrPqLXS1joaqQCVXDtumZf6VnKUfO2nrGq3AnQSk8wfqAMVqN0Uif48FHmPUI4k1WTbfWRnLw1fa8JfztgL+qEDJBWXuiDz706mnGVllFGSZH6EZ6CIUMDYeGNoiVYhz46HEA82rek4U1yEckpqKhoKw1HbBoC2LV+uSfP99IB+8B8rfgOjqbVuyybbcEjd9oTMuqhq6/vgkIcF+M60tq/jWpe7y1jEmkH8qaz2yy+uGcHSlOe1UCTaqEOhux/0N3EXRgcvI6Bcs8fHrSk9VfOgSuwZg1PQyMiB3PxYcsu2MBsMBi3alnZczY7ZinQCIroaR+Ul90kQik8v178/7sUTPK/Vo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

__nodemask_pr_numnodes() currently returns MAX_NUMNODES as the field
width for '%*pb[l]' nodemask printing. MAX_NUMNODES is a compile-time
upper bound and can be much larger than the runtime node id range,
resulting in excessive zero padding in bitmap-form output.

For example, /proc/<pid>/status prints Mems_allowed with '%*pb' using
the nodemask_pr_args() helper. On systems built with MAX_NUMNODES=1024
but booted with a much smaller possible-node range, this produces:

  Mems_allowed: 00000000,00000000,...,00000003

Switch to nr_node_ids, matching the behavior of cpumask_pr_args() which
uses nr_cpu_ids. This reduces the output width from MAX_NUMNODES bits
to the runtime node id range:

  Mems_allowed: 3

Visible impact on in-tree users:
- Bitmap format ('%*pb') users:
  * /proc/<pid>/status Mems_allowed (format changes as shown above)

- List format ('%*pbl') users, output is unchanged, as list formatter
  only prints set bit ranges:
  * /sys/devices/system/node/{possible,online,has_normal_memory, ...}
  * NVMe multipath sysfs numa_nodes
  * memory tier sysfs nodelist
  * cpuset cgroup mems and effective_mems files
  * /proc/<pid>/status Mems_allowed_list
  * mempolicy strings in /proc/<pid>/numa_maps
  * SLUB debugfs output
  * Kernel log messages printing nodemasks

Move nr_node_ids and nr_online_nodes declarations earlier in the file
to allow __nodemask_pr_numnodes() to use nr_node_ids.

Cc: Yury Norov <yury.norov@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Changes from v1:
- List the unaffected '%*pbl' users explicitly, noting that their
  visible output is unchanged since the list formatter only prints
  set bit ranges regardless of field width.
- Move the nr_node_ids and nr_online_nodes declarations earlier 

include/linux/nodemask.h | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index b842aa5..607373b 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -95,6 +95,14 @@
 
 extern nodemask_t _unused_nodemask_arg_;
 
+#if MAX_NUMNODES > 1
+extern unsigned int nr_node_ids;
+extern unsigned int nr_online_nodes;
+#else
+#define nr_node_ids		1U
+#define nr_online_nodes		1U
+#endif
+
 /**
  * nodemask_pr_args - printf args to output a nodemask
  * @maskp: nodemask to be printed
@@ -105,7 +113,7 @@ extern nodemask_t _unused_nodemask_arg_;
 				__nodemask_pr_bits(maskp)
 static __always_inline unsigned int __nodemask_pr_numnodes(const nodemask_t *m)
 {
-	return m ? MAX_NUMNODES : 0;
+	return m ? nr_node_ids : 0;
 }
 static __always_inline const unsigned long *__nodemask_pr_bits(const nodemask_t *m)
 {
@@ -438,9 +446,6 @@ static __always_inline unsigned int next_memory_node(int nid)
 	return next_node(nid, node_states[N_MEMORY]);
 }
 
-extern unsigned int nr_node_ids;
-extern unsigned int nr_online_nodes;
-
 static __always_inline void node_set_online(int nid)
 {
 	node_set_state(nid, N_ONLINE);
@@ -480,8 +485,6 @@ static __always_inline int num_node_state(enum node_states state)
 #define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define next_memory_node(nid)	(MAX_NUMNODES)
-#define nr_node_ids		1U
-#define nr_online_nodes		1U
 
 #define node_set_online(node)	   node_set_state((node), N_ONLINE)
 #define node_set_offline(node)	   node_clear_state((node), N_ONLINE)
-- 
2.9.4


