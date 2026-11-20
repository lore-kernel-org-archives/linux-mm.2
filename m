Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6D3606B98C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMSu1vPg
Received: by kanga.kvack.org (Postfix)
	id 716076B05D4; Fri, 20 Nov 2026 13:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C74C6B05D5; Fri, 20 Nov 2026 13:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F726B05D6; Fri, 20 Nov 2026 13:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA536B05D4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD6A616013C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:30 +0000 (UTC)
X-FDA: 85456287420.29.6663F2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9211240006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMSu1vPg;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198228;
	b=kL7OAvilT7re846H+z39aErvNl+cw8FihS1SskLIi5uaAZV3A5XMggAKLYSOHqi81jZu8J
	Yl11tS4XAm2bF/yB5h4mXgClw1drxitVt8j+wbOHOUpgxED2/RrBsZ/jRG9jXkB+lqqjqR
	5NkPKoV+c0YMHF5AIK058zE5SLJW3rU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198228;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5CrkAO7T3P4r+Yv8Uixoo1Sg+wKyzQuc9jCr1lsfYI=;
	b=Qnxk2FvArgmgE2XnSWnpaVA6RywBPba1W19zgcdjC8Ynw1nR1pVsngBquVJIsLfKso9guq
	SrqBVqnIxqGPo+etSXfsbqbKQjxXuffe/r7Cb7voA5BCiM8DESi9Q7zlIMOuOzgVEeGRMD
	lo0yhYWCe68V0rfruWSNuYF7IRG+mqU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMSu1vPg;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DC45633FE;
	Fri, 20 Nov 2026 18:10:28 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198227;
	b=A+lgT5k2ySTSQta83y2telt6WLHJPTpHlVa8MFz2zHOwkPE2YYcJPueXqna7uL6SoPyO
	 wd6FWtztrKPtnIfqnG3zM0w4gkqwJXe4Pe9uVloUBJvtP8OOv3FARWDrj6T0I8JKo6QZT
	 lM/YQ2b8YMvMZnrXCmqSbrEMPMK/3u4b9cUWYyJgR6JnugctLYEoRA2fE3Gg6gM/Mrj/E
	 Uc2z4S8QHvw8rN7aEd8h8tpE8IX5vfAjWObOiWHQhcJBjie4DyRc7m0AjzsJZ+cj32uyd
	 A40NJ2M5Q7kDTR3WheeXYJ4HVMjwE2ZqsE42rSRt0+LDnMTbm4ni0aEzb0Sp8IfqXYg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198227;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=h5CrkAO7T3P4r+Yv8Uixoo1Sg+wKyzQuc9jCr1lsfYI=;
	b=MoTYbCSE24J2eUwIjFP0lRnOJdE4zWb0zRiNzydPQIYrtjDqPRsiVg4xf/4Fi6G9REXG
	 kmL6/6C1T4/YgE6Jz9WM4qgk5ZJzcKuTP+NNAFgjLyvs3Yt9Xje/1zumU1HYsMwbp9ofR
	 LIU0Wwi/fiGVa2k3OVJZ0r1Im2GyPm+Mcblf127nVWdMtpz2AQcHf+WIoif4nMoojLqZC
	 sL1Gig8j9sF1q/Mr3pUY6/QitJ/S4nauo8Yrk31oATlbWtDikWwVwSlrwH7nyktoUFUV8
	 h9qFY9w+MIbskiZnZvt7fKcZjy9c/0haHUiVEdvRZYotyY/rQA/PR9bdsK7ed5q2tzw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CAD401F000D0;
	Fri, 20 Nov 2026 18:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198227;
	bh=h5CrkAO7T3P4r+Yv8Uixoo1Sg+wKyzQuc9jCr1lsfYI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NMSu1vPgyulr7JEU4QAo/EeQbZOGIf1/aWFuGu6E2WLef7L/mo5PrtAr/A+H89f93
	 BOcGgKIdaY+XLFwmQ3Vp+0BcpbJNP4nqbIrICtseprM6dl/MBOMLQ+P0J0hoNpaODG
	 9w909FzueH16cwv0Jts4DXBYUU7vWKjRh9NGaCUSv6K5VrxuZlp5ynIcXl/QfcCJS/
	 JA3WabXuSKMuUeIUqXO1YSbdaD0B16iwzSmnPWGL9JrOmYV3AywU/5V8kz2po7CZpQ
	 ZWu/B/ivxAHcDIF2AHfobE7234Y4Y/+uYYtD2J4tdftYkFuggytUzO2TFOW4h1/q0A
	 3MKDc/alBl/yg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6165E4B931;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:19 -0500
Subject: [PATCH 28/60] mm: select memory features per node
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-28-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=5275;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=9jUUwkC009YYM3M0mBtUlaNrodM1BEI0oddfspLz38Q=;
 b=5b31/KbUha2vmTFlmfGTvBU6RaiMU83nXseyWRCHS71c1Cr/i7oXIqQHzSTf3Q6kBHMj+p+V+
 CK3q0HN/ldxA/gpmxCF2drBz2uSDsxWLaQZ+5aY3hV5E9HSjJvI/Gfl
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9211240006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: imwgh5nrjorwzeihknpa1fiojjfwhqqq
X-Rspam-User:
X-HE-Tag: 1795198228-58514
X-HE-Meta: U2FsdGVkX19Gx83ehWeThSzFn7v3e+4GJIee4BsZpEQ2/adEOTnu+25ZU7iwQxtxunz8F8XP7lrD+aHYXfzIBFGbxDHNS1Ze4yAH7uVvcUZonucowxk53F72DvOB9W0MsJnvIwXbiWC/x/bipzchdYvBO/4F5PsTQG+rjhL1eRlHtmO4MuZhcRRHV6JSaKOMfO3eMJsrghdyxuHj25mwgc3JDZxs9r0+IwmdUgZJeG47Y1vf9/aDiNHDpY7SzfjgZP2y/Prsj3GRq+5vfho637fHmPY374j1+dWnWQZlIUaEy5Nl3VsOZQIoR0CQ2f7zVvj3wQAj2VYQir2w2uI8Y9nbRO/nCFR/ydkzUIIA1BzdBng1fPPpldQtv1xAPMNRlQ5jq+7syXdUUJlNzU7iwrxKjxCPz8JvTRgyGrsEjGEHus1Rt/bQ5wjp7aoMHK86gx/zbwCQ9R+0suzLA9QFzmUsM4hXDULpbi0je0SCbrindU+SahQD8/y2O5UHfnnaBppeEfr7e5rMQdwFuDzMUiBud0xe3NT4lLDcfitOIqJ4KvWyXG1JKvtSoGknbmeJ2N9ODPwwp6qUUINwd/J2XeONGU0NAqvnVqSacmG8x1mc5j+qkN2w21nKwVuZg0JH5FnMEWWGoE0i5hOuveoNe9Gu9xEgkNT2yPvuAXwvxh8cFNiTAxflO9U41kYnrKc4l4YzTW0pDTya2Kp6QcMnmejvIYapZZbg7oqnf8XYgBC2WDqh4iZvlLfVALeZ+prWC0jp8LGWNUz1OIaxOQ3CLkoXOYWMRmtbV2pN100zt5JNhuLCN7oBGKKR64wUxadJqn0cYjrDIznGMpAndpu4aDD9qj8akxt2q88p6L/M7Wvv7kH1J9mhn/9SADWCjg0ayTCGzI2UwksanuZlNRxOQPscnVCZcnkd1BF64DD8E2oZ+SoUhgbiwgUx4o8HD9/aY1U3Qds34aGi7EzwMJ3
 U/PUerpG
 wluZDut4ietirW8gNiI6Ia4tc7SfeivtqxB3J0t6ukR07b3cwdX2K7Ysxzm9bZSMorYzxlAphpDbo62U9YtX44appHu1mlK4eHo1J9fOH5Qm3mKiSO9hswutR2hPD6efrw17Ke2x/tDOevmTtKDsRX/ICMTH5qNVku64ofaC/2hZRbfq24QrV1a1bOwIoeV/lc+ilAoYlAyaPOQy58jcQb7ScMZ8Yg2u3CQ0FXlENm8kmzXerN1RK0JmWcTr4xNvy6iiiwCHMsuRWNXVmd7O2USwm/eiBnaNrhP8DpG8/QR9J0qyf9ooUazVeQEQnpt3cyb0FtrBHRnXh2UXWsG6LQQzgFXa6ZcLUG06u7ww+HX9KzfJaw0sUq9SsbP87osxJRulQ00n92TUATJPwI52iNZ3Cg+8IgOQ2W+BxZMluAK8sheTyD/qnG4odWVnteoVrv5k+kA3Ahw9El1L4lpSKdKOFQ3/3U1TRIYVf3TLQj1eNpEGbo4qjGt+c+mjv9CRobgI9n2twi/5ZGOQPi4ferteY3VKyruZrNzSYS6atfyQbCpG4H71DqXF3/2kihx6acFWx6zuPXTl9hLnzFS22hEnORCy8HuZdGt97UrFjcpv3qXmb/iVEdPWTLVDfGKWDj7O6H8rXhYfNJqyYHmoh1XXvP0OY7VOVKsqz7S/VnrmhND2vv4pd+MJFl/Xs/vc0BaKvWCiPej2/7ESaqoOOv8uzEXZrwWT4wgd4n6tod7+x7S2RZhWUKf69Yv0Gj5W9xoX7yUz892iTDEkAiH2SiKGeZvvt1P/EognG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Whether a node's memory is common or private is a property of the
memory, so record it per node.

Add a per-node memory feature mask (pgdat->memory_features) with a
single bit for common memory. Node states are published from the node's
features at boot and when memory is onlined. A node without the common
bit joins N_MEMORY_PRIVATE.

Ordinary System RAM carries every feature. Without NUMA, node 0 holds
all memory, so a mask without common memory is invalid.

Every node keeps the default mask, so all memory remains common.

Suggested-by: Dan J Williams <djbw@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mmzone.h   |  1 +
 include/linux/nodemask.h | 12 ++++++++++++
 mm/internal.h            |  2 +-
 mm/memory_hotplug.c      |  2 +-
 mm/mm_init.c             |  7 ++++++-
 mm/page_alloc.c          |  9 +++++++--
 6 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a2ad0cff795..d6c1a43c0bc8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1612,6 +1612,7 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+	unsigned long memory_features;	/* NODE_MEMORY_FEAT_* mask */
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 5a9722d57701..02908ef23a62 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -542,6 +542,18 @@ static __always_inline int node_random(const nodemask_t *maskp)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 #define for_each_node_with_cpus(node)	for_each_node_state(node, N_CPU)
 
+/* Private nodes omit NODE_MEMORY_FEAT_COMMON. */
+#define NODE_MEMORY_FEAT_COMMON		BIT(0) /* add to fallback zonelist */
+#define NODE_MEMORY_FEAT_ALL		NODE_MEMORY_FEAT_COMMON
+
+/* Private memory needs NUMA: node 0 holds all memory without it. */
+static inline bool node_memory_features_valid(unsigned long features)
+{
+	if (features & ~NODE_MEMORY_FEAT_ALL)
+		return false;
+	return IS_ENABLED(CONFIG_NUMA) || (features & NODE_MEMORY_FEAT_COMMON);
+}
+
 /*
  * For nodemask scratch area.
  * NODEMASK_ALLOC(type, name) allocates an object with a specified type and
diff --git a/mm/internal.h b/mm/internal.h
index cd0562f0b68f..e89dd1153662 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -62,7 +62,7 @@ void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
 void folio_mark_lazyfree(struct folio *folio);
 
-void node_set_memory_state(int nid);
+void node_set_memory_state(int nid, unsigned long features);
 void node_clear_memory_state(int nid);
 
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6b6873cfbc5a..b4d94021d46e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1197,7 +1197,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
 	if (node_arg.nid >= 0)
-		node_set_memory_state(nid);
+		node_set_memory_state(nid, NODE_DATA(nid)->memory_features);
 	/*
 	 * Check whether we are adding normal memory to the node for the first
 	 * time.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f21b3dbcc92a..99a45fd04ac5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1585,6 +1585,9 @@ int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
 	pgdat->node_start_pfn = 0;
 	pgdat->node_present_pages = 0;
 
+	/* memory is common unless marked private */
+	pgdat->memory_features = NODE_MEMORY_FEAT_ALL;
+
 	/*
 	 * Hot-unplug can leave per-cpu vmstat deltas unfolded (folders skip
 	 * offline nodes) - reconcile this at online. Foreign access to counters
@@ -1743,6 +1746,8 @@ static void __init free_area_init_node(int nid)
 
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = start_pfn;
+	/* memory is common unless marked private */
+	pgdat->memory_features = NODE_MEMORY_FEAT_ALL;
 
 	if (start_pfn != end_pfn) {
 		pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
@@ -1768,7 +1773,7 @@ static void __init check_for_memory(pg_data_t *pgdat)
 {
 	enum zone_type zone_type;
 
-	node_set_memory_state(pgdat->node_id);
+	node_set_memory_state(pgdat->node_id, pgdat->memory_features);
 
 	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 50336eb58edf..3a7c12fec906 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -209,10 +209,15 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 };
 EXPORT_SYMBOL(node_states);
 
-void __meminit node_set_memory_state(int nid)
+void __meminit node_set_memory_state(int nid, unsigned long features)
 {
+	WARN_ON_ONCE(!node_memory_features_valid(features));
+
 	node_set_state(nid, N_MEMORY);
-	node_set_state(nid, N_MEMORY_COMMON);
+	if (features & NODE_MEMORY_FEAT_COMMON)
+		node_set_state(nid, N_MEMORY_COMMON);
+	else
+		node_set_state(nid, N_MEMORY_PRIVATE);
 }
 
 void __meminit node_clear_memory_state(int nid)

-- 
2.56.1



