Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92172606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U/fZ8ndz
Received: by kanga.kvack.org (Postfix)
	id 1A6066B05B6; Sun, 15 Nov 2026 17:34:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183766B05B7; Sun, 15 Nov 2026 17:34:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C5D6B05B8; Sun, 15 Nov 2026 17:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B845D6B05B6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:34:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35BE21C415C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:50 +0000 (UTC)
X-FDA: 85438809540.28.165DDCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 157C820008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:34:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/fZ8ndz";
	spf=pass (imf31.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794782088;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5RPz7a6FwiInslaW4fTkNxp7BEIp07/Zx2pVKJeOao=;
	b=p47rHbDPK50yCMZitSk5D4+3oGu+P+xFsjxaNBxLUTS/yVQQivoOpu5E7cQziPzWuAY3H8
	Cfw0uu7bYiiQJX3EdevfkEe2JJv6Yk9Qy6v46WG04zFBeJFQ7omMv+hp0SxiwtAcByaJBd
	sllqd45Of23ZVYTl+qJl8uPOltrlbYs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794782088;
	b=ZsgbK/Zgch6fvemi1yLxUoxDr6kQAEurY9oNLyW5gxzoHGntlhRlQ4G0AfyJlr6nfFzVP/
	3cJieTU8Ql/RjQXCnn7VB2HRHy4BGQgdXIeX0zZYlWmnFatqC4I71zfB3u8lFZdiZ5F9aO
	av0yMbFtrjl6cI5MksO5rcVsPX3PXRE=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/fZ8ndz";
	spf=pass (imf31.hostedemail.com: domain of devnull+alireza.asgari.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+alireza.asgari.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66C4C43F07;
	Sun, 15 Nov 2026 22:34:47 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794782087;
	b=tKNdeqPWKmxq3C7r31p+dk23tCI7P44MJM8iUpPKzy0oXJQ4z5dbPLaYOjvhiPxjKMLy
	 grcqcy7srEJbSuOMVW4N+n0xyW9b+ayIOXlpta7T0s1nv3dPknEN95pCGDmZTSriE6iW2
	 GN/yLCeamA6diwNq5lUsnYOHKpqZ3xavpABs7gwP54lg+8uWvhprlrclgGHXgqkr1uZVj
	 D75zZOVxxPy1PD2cKg4X5yQcNHOqTXamsh4bFhCJbxfJCQGjCoCxcyYOyiZmfGOXiNa0N
	 H69Yz3L6bh3wRxbVHDeY/eif77lxVfx9MdwygBJqxeJxxB17iHOoOJk/IVq7iBwf0RA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794782087;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=m5RPz7a6FwiInslaW4fTkNxp7BEIp07/Zx2pVKJeOao=;
	b=iXAa3B6+P8sIqlR8TpjiLpOWYyqS0wpDckxWqJOJlUpLjQBvcdTsTX4cSbDBAPHuihvw
	 JpuSG+Ng+Hrk9sE4XUOsltVDqw4hzKO3a96SGx+YG4PXR7evQO+fL2JzkY7/nJQuadMju
	 tIsT51jjnCn218oAaHLG5KGIJkZpcDJUmeuaqHFFiS+E8woDqqm9AjQfi8jxBUrPxTCJI
	 Eb1EW4DYzQ1Fcc4/5CQrg53EtOQkVXy1tYd0x1jLhuFi79ksc5oZuqnMkQVQFfZHPNhZt
	 16fTHSFxT/Q9rVCmBQFyFuQGkkeZqKzVHKW7+E3NdoxNj0lM1rX5svaTkjkXwbVX+rA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B65811F000D0;
	Sun, 15 Nov 2026 22:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794782087;
	bh=m5RPz7a6FwiInslaW4fTkNxp7BEIp07/Zx2pVKJeOao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=U/fZ8ndzsJyKr8voAQdNeWnUi86ocWMcYtostnRIPP7KeFELFekkluJl+qmRdJfDm
	 ytBc0+9wLuBHzDkxOGb9aq2C/FQlChLLPOdsWrei45/cJ6yto8kwxOAoHp0a3IjUAS
	 kJ1iPP7su72dVbuoeShmjVKZwvO/+Izje89JBXrV8S9O1E3IRDyuHA5ZUxfPI2B3TP
	 EGI8fEv1juc0vnHoyx/Jv2mAOTvWu042QIKaFBNUE1IKHi9WMT+tHWPbUbWXFXpmjF
	 kK08YHCZAoiFbSm6k5aGa+jrMJfiVxFCD1Hh8zvyAdagMmosNC9lCcCySrQtran6oK
	 VXiBq+X/9r52w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F073E4A25D;
	Sun, 15 Nov 2026 22:34:43 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Sun, 15 Nov 2026 22:34:48 +0000
Subject: [PATCH RFC nf-next 8/9] netfilter: nfqueue: add KUnit memory
 accounting coverage
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261115-b4-nfqueue-memory-accounting-v1-8-b9cc30819997@asgari.net>
References: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
In-Reply-To: <20261115-b4-nfqueue-memory-accounting-v1-0-b9cc30819997@asgari.net>
To: netfilter-devel@vger.kernel.org, linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
 Chris Down <chris@chrisdown.name>, 
 Zhang Jiao <zhangjiao2@cmss.chinamobile.com>, Song Hu <husong@kylinos.cn>, 
 cgroups@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794782082; l=14296;
 i=alireza@asgari.net; s=alireza-kernel; h=from:subject:message-id;
 bh=yVuu+o+DPEI25W4yS93kGUP6LvZX/GhqtDFPsoYHgAs=;
 b=YPoI4Nk50+1ctKI89mKDWt40MD/LMYTFi1OpHNVEFXgtIhaESx1oP+VTbjzERsu9UrHxzjP3n
 pM5pQVERUNICNXnwtadyFf0HBGt85Za8BEkwyQkbkSSOdos9yyhA/qu
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=wuQ0/M69FqoVnrCMUJ13EQCwrCwVjCrtz75k15vW8tw=
X-Endpoint-Received: by B4 Relay for alireza@asgari.net/alireza-kernel with
 auth_id=1055
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fiwxgef97fgy3nowmjgfms4ykny988rw
X-Rspamd-Queue-Id: 157C820008
X-Rspam-User: 
X-HE-Tag: 1794782087-471902
X-HE-Meta: U2FsdGVkX1/9OI+ivAuKnHchacA9c4fnS5qgq+l6oiaVrzlmgY2ItY/I0AzzxbFhG1u1Lm/2wis2SZKJMSpScVW+MeQFBR6DDVMqEQPOPKkqnp0HPuaMUMWEl6gJOVotTRfXPpTvKMY0ZdN7h1irO92gqEGjRyNZF+zfnPuObueVfvWOkVOa18nK20HIKg2vB/mdOJyPSWLGUKgqUuXw4Or2PyjYEx7Q0UMXr8uNMVIX2WY4yWhkcqggK9aW0bf7IHfcePEXDgoEu1k/RRl9CWTdVzVUc+rE1OoZu3g+CVfSgrjjI0LWeJYBLp95QLRpVk+16xChE5cugArkQkM9ig1pHezq/RaChxNsUjfQoO0EgbkFE7llZDMJf365gAVdj4saM0xy45EuRatMuFocrJuj5MNobx4CpVjo/5/bY5Rviz+DYt9Y7sYPTTqheqzS1Q4BDWy+d7FeiYQJrA4huVG+7m38ZJxQANCOT45zytXBEtwfH0vnw1xPtVO0EA7J7PeK25i4z4l2/wpurkLbMOVY6gNAnKDNMzykk4fHfH5Mp6a+XGfL86gljs81mnCpKBsC8gtYqzjK/LZZExOP5h5lYZDlMkU4qfBQVMUuvsdM3TxBSqSmjk0irBJ6ZELUXgMnJF+cUFO38ZyigyGUl/qlzE1v/Bo2s9fqdxek+8+I3x8nCtCt5OEcydzfO7J06Pk9IPUWT3HY24rk0TRrf+ELOGBkNA3ajvfQbaDFB4xzTeNxKB5iwwZT84dFySMZRPnmUC4RcA2/4WBPuC9eh/DCAeSkfHcJkG8PX47/YqGyV8Uvoy/suCwBrRHJj6jM31KRSLWa0mSe0CvQ+VjHy6XMohegBgyGODS1ehlxHHjOvhTbqqogRVtOGpi8aDlPGkn+ePtkQ6y85tsLuqr4ivzeUSEw8s6YCIPRUaOwJSOWXzVgtW0roxwlQAdeUF7/LTLnLf2Xq+NB/2ryDBW
 J31d/T42
 t/82iYVItxoAIUOnoqmoeLrX4hSq7LETZDEqFwU/Oagj9P4At6q1x3aQwyxh1ITehKSAoPQ3UxK+fvQkA1DW0/muIt3AGWOI6jK4bGjMmcbNEcDCBb1Vf9DAZ5BZ06/2FryFbiagUm0pUu1BdHkifPGn+Taqa7Ke65n61O4wV2Nh0idbcjJWba4ii3QOLqBvKyGDiFZj7cfEH5969Zuv8lfnNAY0A5J3U/5NFUbDyUqaFYHCr/DJ7zriSXy+hJ2kn/evvkAE1Nv6s09RjfXveIBQWzrZ9eZYKhyezDTMJHB+lEOh+42dJM6sVwqRlktuDuE6ifLo//YRUFqkxY9aVsWR5GMdfsYuIVDE877gmJ0RRV3zyWtxn2ja9g07HviNeklm6hJCdGHrbic6h7viDvNOwMO3pHw/AXaSRGi7bIPpmhYD/EsJXJ7VvuHWXqwiCjMwol/zHDeI7vFFPoGSbok4FWbxKBbNa/eB4fdbCf9tcUwZQahq4vgVR/txVamd67hxeBfTJe+19yzPFJf4ZiECPTOpKVM4ZMB6ioxAatVYtXW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alireza Asgari <alireza@asgari.net>

Test local byte boundaries, a small nominal-head skb, a page-backed head,
saved accounting across detachment, and live limit changes.

Also test active, inactive, and failed instance creation against a private
queue table. A KUnit static stub checks that a new instance remains absent
from lookup until configuration succeeds. These tests exercise publication
ordering directly; they do not claim a concurrent queue-bypass reproducer.

Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 net/netfilter/Kconfig                |  10 ++
 net/netfilter/nfnetlink_queue.c      |  13 ++
 net/netfilter/nfnetlink_queue_test.c | 338 +++++++++++++++++++++++++++++++++++
 3 files changed, 361 insertions(+)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 09874c26fd13..02818552ac8b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -71,6 +71,16 @@ config NETFILTER_NETLINK_LOG
 	  and is also scheduled to replace the old syslog-based ipt_LOG
 	  and ip6t_LOG modules.
 
+config NETFILTER_NETLINK_QUEUE_KUNIT_TEST
+	bool "NFQUEUE memory accounting tests" if !KUNIT_ALL_TESTS
+	depends on NETFILTER_NETLINK_QUEUE=y && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Test NFQUEUE byte admission, saved charges across detachment, and
+	  live queue limit updates without sending network traffic.
+	  The tests run with KUnit and do not need a userspace queue listener.
+	  Say N unless you are testing changes to NFQUEUE accounting.
+
 config NETFILTER_NETLINK_OSF
 	tristate "Netfilter OSF over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b37fb6f21482..ad14c74f35a8 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -51,6 +51,10 @@
 
 #include <linux/atomic.h>
 
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_QUEUE_KUNIT_TEST)
+#include <kunit/static_stub.h>
+#endif
+
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 #include "../bridge/br_private.h"
 #endif
@@ -210,6 +214,11 @@ static int nfqnl_set_config(struct nfqnl_instance *queue, unsigned int maxlen,
 	bool activated;
 	int err = 0;
 
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_QUEUE_KUNIT_TEST)
+	KUNIT_STATIC_STUB_REDIRECT(nfqnl_set_config, queue, maxlen, params,
+				   flags, mask);
+#endif
+
 	if (params && params->copy_mode == NFQNL_COPY_PACKET) {
 		range = ntohl(params->copy_range);
 		if (!range || range > NFQNL_MAX_COPY_RANGE)
@@ -2390,3 +2399,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_QUEUE);
 
 module_init(nfnetlink_queue_init);
 module_exit(nfnetlink_queue_fini);
+
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_QUEUE_KUNIT_TEST)
+#include "nfnetlink_queue_test.c"
+#endif
diff --git a/net/netfilter/nfnetlink_queue_test.c b/net/netfilter/nfnetlink_queue_test.c
new file mode 100644
index 000000000000..e8b89ca83dff
--- /dev/null
+++ b/net/netfilter/nfnetlink_queue_test.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <kunit/test.h>
+#include <linux/mm.h>
+
+static void nfqnl_test_destroy_map(void *data)
+{
+	struct nfqnl_instance *queue = data;
+
+	rhashtable_destroy(&queue->nfqnl_packet_map);
+}
+
+static void nfqnl_test_free_skb(void *data)
+{
+	kfree_skb(data);
+}
+
+static int nfqnl_test_init(struct kunit *test)
+{
+	struct nfqnl_instance *queue;
+	int err;
+
+	queue = kunit_kzalloc(test, sizeof(*queue), GFP_KERNEL);
+	if (!queue)
+		return -ENOMEM;
+	spin_lock_init(&queue->lock);
+	mutex_init(&queue->mem_mutex);
+	INIT_WORK(&queue->mem_work, nfqnl_mem_work);
+	INIT_LIST_HEAD(&queue->queue_list);
+	err = rhashtable_init(&queue->nfqnl_packet_map,
+			      &nfqnl_rhashtable_params);
+	if (err)
+		return err;
+	test->priv = queue;
+	return kunit_add_action_or_reset(test, nfqnl_test_destroy_map, queue);
+}
+
+static void nfqnl_test_boundaries(struct kunit *test)
+{
+	struct nfqnl_instance *queue = test->priv;
+
+	queue->mem_limit = 8192;
+	queue->mem_used = 4096;
+	KUNIT_EXPECT_FALSE(test, nfqnl_mem_full(queue, 4096));
+	KUNIT_EXPECT_TRUE(test, nfqnl_mem_full(queue, 4097));
+	queue->mem_used = 8193;
+	KUNIT_EXPECT_TRUE(test, nfqnl_mem_full(queue, 1));
+	queue->mem_used = 0;
+	queue->mem_limit = 0;
+	KUNIT_EXPECT_TRUE(test, nfqnl_mem_full(queue, 1));
+	queue->mem_limit = U64_MAX;
+	queue->mem_used = U64_MAX - 10;
+	KUNIT_EXPECT_FALSE(test, nfqnl_mem_full(queue, 10));
+	KUNIT_EXPECT_TRUE(test, nfqnl_mem_full(queue, 11));
+
+	KUNIT_EXPECT_GT(test, nfqnl_mem_limit(U32_MAX), (u64)U32_MAX);
+	KUNIT_EXPECT_EQ(test, nfqnl_mem_pages(0), 0ULL);
+	KUNIT_EXPECT_EQ(test, nfqnl_mem_pages(PAGE_SIZE), 1ULL);
+	KUNIT_EXPECT_EQ(test, nfqnl_mem_pages(PAGE_SIZE + 1), 2ULL);
+	KUNIT_EXPECT_EQ(test, nfqnl_mem_pages(U64_MAX),
+			(U64_MAX >> PAGE_SHIFT) + 1);
+}
+
+static void nfqnl_test_small_queue(struct kunit *test)
+{
+	struct nfqnl_instance *queue = test->priv;
+	struct sk_buff *skb;
+
+	skb = alloc_skb(SKB_WITH_OVERHEAD(2048), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	KUNIT_ASSERT_EQ(
+		test, kunit_add_action_or_reset(test, nfqnl_test_free_skb, skb),
+		0);
+	KUNIT_ASSERT_EQ(test, nfqnl_set_config(queue, 1, NULL, 0, 0), 0);
+	/* A standard 2 KiB head must fit in an empty length-one queue. */
+	KUNIT_EXPECT_FALSE(test, nfqnl_mem_full(queue, skb->truesize));
+}
+
+static void nfqnl_test_page_head(struct kunit *test)
+{
+	struct nfqnl_instance *queue = test->priv;
+	struct sk_buff *skb;
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	skb = build_skb(page_address(page), PAGE_SIZE);
+	if (!skb)
+		__free_page(page);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	KUNIT_ASSERT_EQ(
+		test, kunit_add_action_or_reset(test, nfqnl_test_free_skb, skb),
+		0);
+	skb_put_zero(skb, 64);
+
+	/* A small payload still accounts for the complete receive allocation. */
+	KUNIT_ASSERT_EQ(test, nfqnl_set_config(queue, 1, NULL, 0, 0), 0);
+	if (PAGE_SIZE > 2048)
+		KUNIT_EXPECT_TRUE(test, nfqnl_mem_full(queue, skb->truesize));
+	else
+		KUNIT_EXPECT_FALSE(test, nfqnl_mem_full(queue, skb->truesize));
+	KUNIT_ASSERT_EQ(test,
+			nfqnl_set_config(queue, DIV_ROUND_UP(PAGE_SIZE, 2048),
+					 NULL, 0, 0),
+			0);
+	KUNIT_EXPECT_FALSE(test, nfqnl_mem_full(queue, skb->truesize));
+
+	queue->mem_limit = skb->truesize - 1;
+	KUNIT_EXPECT_TRUE(test, nfqnl_mem_full(queue, skb->truesize));
+	queue->mem_limit = skb->truesize;
+	KUNIT_EXPECT_FALSE(test, nfqnl_mem_full(queue, skb->truesize));
+}
+
+static void nfqnl_test_detached_charge(struct kunit *test)
+{
+	struct nfqnl_instance *queue = test->priv;
+	struct nf_queue_entry entry = {};
+	u64 detached, released;
+	unsigned int saved;
+	int err;
+
+	entry.skb = alloc_skb(512, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, entry.skb);
+	KUNIT_ASSERT_EQ(test,
+			kunit_add_action_or_reset(test, nfqnl_test_free_skb,
+						  entry.skb),
+			0);
+	saved = entry.skb->truesize;
+	queue->mem_limit = saved;
+
+	spin_lock_bh(&queue->lock);
+	err = __enqueue_entry(queue, &entry);
+	if (!err) {
+		__dequeue_entry(queue, &entry);
+		detached = queue->mem_used;
+		/* Verdict payload replacement must not change the saved refund. */
+		entry.skb->truesize += 128;
+		nfqnl_mem_uncharge(queue, &entry);
+		released = queue->mem_used;
+		entry.skb->truesize = saved;
+	}
+	spin_unlock_bh(&queue->lock);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	KUNIT_EXPECT_EQ(test, detached, (u64)saved);
+	KUNIT_EXPECT_EQ(test, released, 0ULL);
+	KUNIT_EXPECT_EQ(test, entry.truesize, 0U);
+	KUNIT_EXPECT_EQ(test, queue->queue_total, 0U);
+	KUNIT_EXPECT_TRUE(test, list_empty(&queue->queue_list));
+	KUNIT_EXPECT_FALSE(test, nfqnl_mem_full(queue, saved));
+
+	/* FAIL_OPEN and notification rollback can reach reinjection uncharged. */
+	spin_lock_bh(&queue->lock);
+	nfqnl_mem_uncharge(queue, &entry);
+	spin_unlock_bh(&queue->lock);
+	KUNIT_EXPECT_EQ(test, queue->mem_used, 0ULL);
+}
+
+static void nfqnl_test_limit_update(struct kunit *test)
+{
+	struct nfqnl_instance *queue = test->priv;
+	u64 used = nfqnl_mem_limit(8);
+
+	queue->mem_used = used;
+	queue->queue_total = 2;
+	KUNIT_ASSERT_EQ(test, nfqnl_set_config(queue, 1, NULL, 0, 0), 0);
+	KUNIT_EXPECT_EQ(test, queue->queue_maxlen, 1U);
+	KUNIT_EXPECT_EQ(test, queue->mem_limit, nfqnl_mem_limit(1));
+	KUNIT_EXPECT_EQ(test, queue->mem_used, used);
+	KUNIT_EXPECT_EQ(test, queue->queue_total, 2U);
+	KUNIT_EXPECT_TRUE(test, nfqnl_mem_full(queue, 1));
+	KUNIT_ASSERT_EQ(test, nfqnl_set_config(queue, 16, NULL, 0, 0), 0);
+	KUNIT_EXPECT_FALSE(test, nfqnl_mem_full(queue, 1));
+	KUNIT_EXPECT_EQ(test, queue->mem_used, used);
+	KUNIT_EXPECT_EQ(test, queue->mem_reserved, 0ULL);
+}
+
+struct nfqnl_test_creation {
+	struct nfnl_queue_net queues;
+	struct nfqnl_instance *instance;
+	unsigned int config_calls;
+	int config_error;
+};
+
+static struct nfqnl_instance *nfqnl_test_lookup(struct nfqnl_test_creation *ctx,
+						u16 queue_num)
+{
+	struct nfqnl_instance *queue;
+
+	rcu_read_lock();
+	queue = instance_lookup(&ctx->queues, queue_num);
+	rcu_read_unlock();
+	return queue;
+}
+
+static int
+nfqnl_test_config_private(struct nfqnl_instance *queue, unsigned int maxlen,
+			  const struct nfqnl_msg_config_params *params,
+			  u32 flags, u32 mask)
+{
+	struct kunit *test = kunit_get_current_test();
+	struct nfqnl_test_creation *ctx = test->priv;
+	int err;
+
+	ctx->config_calls++;
+	KUNIT_EXPECT_PTR_EQ(test, nfqnl_test_lookup(ctx, queue->queue_num),
+			    NULL);
+	if (ctx->config_error)
+		return ctx->config_error;
+
+	/* Exercise the real configuration while checking its visibility. */
+	kunit_deactivate_static_stub(test, nfqnl_set_config);
+	err = nfqnl_set_config(queue, maxlen, params, flags, mask);
+	KUNIT_EXPECT_PTR_EQ(test, nfqnl_test_lookup(ctx, queue->queue_num),
+			    NULL);
+	return err;
+}
+
+static void nfqnl_test_destroy_instance(void *data)
+{
+	struct nfqnl_test_creation *ctx = data;
+
+	if (!IS_ERR_OR_NULL(ctx->instance)) {
+		instance_destroy(&ctx->queues, ctx->instance);
+		rcu_barrier();
+		flush_workqueue(nfq_cleanup_wq);
+	}
+}
+
+static struct nfqnl_test_creation *nfqnl_test_creation_init(struct kunit *test)
+{
+	struct nfqnl_test_creation *ctx;
+	unsigned int i;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+	spin_lock_init(&ctx->queues.instances_lock);
+	for (i = 0; i < INSTANCE_BUCKETS; i++)
+		INIT_HLIST_HEAD(&ctx->queues.instance_table[i]);
+	if (kunit_add_action_or_reset(test, nfqnl_test_destroy_instance, ctx))
+		return NULL;
+	test->priv = ctx;
+	kunit_activate_static_stub(test, nfqnl_set_config,
+				   nfqnl_test_config_private);
+	return ctx;
+}
+
+static void nfqnl_test_create_active(struct kunit *test)
+{
+	const struct nfqnl_msg_config_params params = {
+		.copy_range = htonl(512),
+		.copy_mode = NFQNL_COPY_PACKET,
+	};
+	struct nfqnl_test_creation *ctx = nfqnl_test_creation_init(test);
+	struct nfqnl_instance *queue, *duplicate;
+
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	queue = instance_create(&init_net, &ctx->queues, 7, 1, 32, &params,
+				NFQA_CFG_F_FAIL_OPEN, NFQA_CFG_F_FAIL_OPEN);
+	ctx->instance = queue;
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, queue);
+	KUNIT_EXPECT_EQ(test, ctx->config_calls, 1U);
+	KUNIT_EXPECT_PTR_EQ(test, nfqnl_test_lookup(ctx, 7), queue);
+	KUNIT_EXPECT_TRUE(test, queue->mem_activated);
+	KUNIT_EXPECT_EQ(test, queue->queue_maxlen, 32U);
+	KUNIT_EXPECT_EQ(test, queue->mem_limit, nfqnl_mem_limit(32));
+	KUNIT_EXPECT_EQ(test, queue->copy_mode, (u8)NFQNL_COPY_PACKET);
+	KUNIT_EXPECT_EQ(test, queue->copy_range, 512U);
+	KUNIT_EXPECT_EQ(test, queue->flags, (u32)NFQA_CFG_F_FAIL_OPEN);
+
+	duplicate =
+		instance_create(&init_net, &ctx->queues, 7, 1, 1, NULL, 0, 0);
+	KUNIT_EXPECT_TRUE(test, IS_ERR(duplicate));
+	if (IS_ERR(duplicate)) {
+		KUNIT_EXPECT_EQ(test, PTR_ERR(duplicate), (long)-EEXIST);
+	} else {
+		instance_destroy(&ctx->queues, duplicate);
+		rcu_barrier();
+		flush_workqueue(nfq_cleanup_wq);
+	}
+	KUNIT_EXPECT_PTR_EQ(test, nfqnl_test_lookup(ctx, 7), queue);
+	KUNIT_EXPECT_EQ(test, queue->queue_maxlen, 32U);
+}
+
+static void nfqnl_test_create_inactive(struct kunit *test)
+{
+	struct nfqnl_test_creation *ctx = nfqnl_test_creation_init(test);
+	struct nfqnl_instance *queue;
+
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	queue = instance_create(&init_net, &ctx->queues, 7, 1,
+				NFQNL_QMAX_DEFAULT, NULL, 0, 0);
+	ctx->instance = queue;
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, queue);
+	KUNIT_EXPECT_EQ(test, ctx->config_calls, 1U);
+	KUNIT_EXPECT_PTR_EQ(test, nfqnl_test_lookup(ctx, 7), queue);
+	KUNIT_EXPECT_FALSE(test, queue->mem_activated);
+	KUNIT_EXPECT_EQ(test, queue->copy_mode, (u8)NFQNL_COPY_NONE);
+	KUNIT_EXPECT_EQ(test, queue->queue_maxlen, NFQNL_QMAX_DEFAULT);
+	KUNIT_EXPECT_EQ(test, queue->memcg.pages, 0ULL);
+}
+
+static void nfqnl_test_create_failure(struct kunit *test)
+{
+	const struct nfqnl_msg_config_params params = {
+		.copy_mode = NFQNL_COPY_PACKET,
+	};
+	struct nfqnl_test_creation *ctx = nfqnl_test_creation_init(test);
+
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	ctx->config_error = -ENOMEM;
+	ctx->instance = instance_create(&init_net, &ctx->queues, 7, 1, 32,
+					&params, 0, 0);
+	KUNIT_ASSERT_TRUE(test, IS_ERR(ctx->instance));
+	KUNIT_EXPECT_EQ(test, PTR_ERR(ctx->instance), (long)-ENOMEM);
+	KUNIT_EXPECT_EQ(test, ctx->config_calls, 1U);
+	KUNIT_EXPECT_PTR_EQ(test, nfqnl_test_lookup(ctx, 7), NULL);
+}
+
+static struct kunit_case nfqnl_mem_test_cases[] = {
+	KUNIT_CASE(nfqnl_test_boundaries),
+	KUNIT_CASE(nfqnl_test_small_queue),
+	KUNIT_CASE(nfqnl_test_page_head),
+	KUNIT_CASE(nfqnl_test_detached_charge),
+	KUNIT_CASE(nfqnl_test_limit_update),
+	KUNIT_CASE(nfqnl_test_create_active),
+	KUNIT_CASE(nfqnl_test_create_inactive),
+	KUNIT_CASE(nfqnl_test_create_failure),
+	{}
+};
+
+static struct kunit_suite nfqnl_mem_test_suite = {
+	.name = "nfnetlink_queue_memory",
+	.init = nfqnl_test_init,
+	.test_cases = nfqnl_mem_test_cases,
+};
+
+kunit_test_suite(nfqnl_mem_test_suite);

-- 
2.34.1



