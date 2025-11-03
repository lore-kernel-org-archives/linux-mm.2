Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C8FCCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 03:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB358E001D; Sun,  2 Nov 2025 22:35:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582A98E0015; Sun,  2 Nov 2025 22:35:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4992A8E001D; Sun,  2 Nov 2025 22:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39E1F8E0015
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 22:35:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE5901A0A91
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:35:54 +0000 (UTC)
X-FDA: 84067881828.06.5F96D6E
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf27.hostedemail.com (Postfix) with ESMTP id 93CA540009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:35:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cAsCMg1B;
	spf=pass (imf27.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762140953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5iAlRuAIsi2GE5ItcdrGuYTZod15rl8M0hhAckNHMcs=;
	b=fh4pZl99UG/jgI7hTan6LqGzNymnANrV7HMebWk2ov+xmd3TMufqMq0N+T5LsAgOokCw4q
	wbR2Lfh/WNa+3z9wAPtmVSkv8NCRfZw6+aP+lGHbZevLn2qNlAigQqr6XD3UoTWFpSYm0N
	i3e7gpH2KQeZU1cS3VQtsNCkVRedsSI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cAsCMg1B;
	spf=pass (imf27.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762140953; a=rsa-sha256;
	cv=none;
	b=aHrPo0MmELTHktrapaX6+BGeopIQwjxyCIFhjIcnPG17pjdwX7YoNyoQL2s3V97hL1D5qg
	dJ2Kb4j+cMBXE5KaW+w62YcRSXnxJgz2eFlVLwd++/DgqUB8UsOwbsG3jRJGb1u3+xrJlO
	5pJmGRn+d5Be/uC3mSHwEkragZFZ4i4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5iAlRuAIsi2GE5ItcdrGuYTZod15rl8M0hhAckNHMcs=;
	b=cAsCMg1BrDm96i8ognht4vAKSaZKt8SVQAMotpszTJBJw3IMv69XAQmpy1g5RnlhCc2rIjwzt
	gXbsfEiX7W4ucdEJCpVZk59tAx3Xu8OTPFH61xGh3ZdGoquc2Z3PrYVIwpxPVPxTNV+VtESZRrv
	ODY/L0Sak3nX9dqGFpx0wgg=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4d0HJ63dr3zmV8P;
	Mon,  3 Nov 2025 11:34:14 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 7950E140277;
	Mon,  3 Nov 2025 11:35:48 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Nov 2025 11:35:47 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <will@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH 2/2] mm/memory-failure: remove the selection of RAS
Date: Mon, 3 Nov 2025 11:35:36 +0800
Message-ID: <20251103033536.52234-2-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103033536.52234-1-xieyuanbin1@huawei.com>
References: <20251103033536.52234-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: 93CA540009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tk7y9zo5jpu1kh675eognoxjmirfrh65
X-HE-Tag: 1762140952-550859
X-HE-Meta: U2FsdGVkX18hcomkG1R9dvGYeTB3yjYcnYMQWEeO9lJwpsv5dYWntULGIhNrNZlgakunWpEAa5Q+qa3xagwXuxvkyVt13WDOfOfFzjKNMtiC6WUA3v2jMJMNnIQAUOXWbzzP4yDFg55pngSFcrLh8dDcq7pwuq3A/k/q9Cyue8+LYQ+LXgTORbDg1+rTXrtDnjlXy3TkoKTFZRIZNpCEPvSdsrkuiK5sRKinQCnhiSXtcx120hk9TYQjIzP+bvawPxgaqcu30SEDNCz5+LvK7Db9TO9SW1MLwGNiKeq/uZyFScNhJRdeGTP0woqWDnLKRatLV9KflbeV/A53fELDWU8GJ8CVAYILeKzCEnSpb58adKVlJ31FwhIhX5L3U5oMYLuWavLbG0JZere5rzxdpy6g3dJ3S/dnz1ZvMT9PC9nglXWkhvY2VDnJXBz7lZifh0o5axrY2dehdFhyD0AcrQB/zAeOzC63pxAOreQwZMnkVkoP/OPTfJ0hfLkVd3k15VX8FjeOrG7WsB8uq7VJhB9CmYlN20hgtx1pu44lMZCAMXrwZtG6nH2z7RkiP5dJLh3N1ByL0vf0gjXzN8kMwThmSzTw9PR8PCAztgpiZvHsgAri4SuRDjdVwRQS49gGlhz4UN0GyQpk7wJwOr21e0aLnE7hT9A0mH9CS1c4mFs16FMkSJVzh9ZV+eWqE4WEoSGJacMnRrdD+eZ87bI+U1NslOm22+Q5JmYQ2jE8N6fj41Ckib9SnCsC/FEGhlmhgNJwKrnzNWSYDduZVRLiBPvNPeWHNlsvu8Jpe4TLsl2Qy9LL39ssRdFgsIbyt7+BV1AeMImp8K1RBcpGxL4Krz0b4zUVpc94g1KZgLe8RgwXagb2KJ0LOj8Bdppb9fZNE7dKG/79w+pViG+7FfU+/iEso+ImCr6Ekdfr0G5DFhj160WBzSC3aBnXN2HiQdPcIcsI0mNz6E3wOgijZ6o
 H2sNSnkq
 QGX4wTnhKx4tans/vuktJZR3Zx/R+7vFsIZHPVJOTYc8uPmK2jmm+6Ve05rLcxNwNxO/Co9nGVXC/8wKZIw3bP+hS40vAwhXIxOmP5UZBySy4vBnWwczuYxtJqYR7xZcfZAFsfmdyWsLKIL9Q0ZZ2U4tkPy67ddY8tDuhK95Xu/z2AgL8tB++tr0ce9nkBLmImGvbyx3XnfjOyWnQPiPp7461zp2bUIxFZ4OU4MhN2MZm5SepFH6JMavLAlZWUPLYfZZO6xb6yiCuEQSlEvAMhXBCbHuRtJzXmDA/HZkEQHk+EbMZe6bToqdYvy63E2tbB7fFnVbbjffjeiABpS4QIv+56bFs7dHcO85v/zUFjQIwtas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The commit 97f0b13452198290799f ("tracing: add trace event for
memory-failure") introduces the selection of RAS in memory-failure.
This commit is just a tracing feature; in reality, there is no dependency
between memory-failure and RAS. RAS increases the size of the bzImage
image by 8k, which is very valuable for embedded devices.

Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
 mm/Kconfig          | 1 -
 mm/memory-failure.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index a5a90b169435..c3a8e0ba1ac1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -738,11 +738,10 @@ config ARCH_SUPPORTS_MEMORY_FAILURE
 
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
 	  even when some of its memory has uncorrected errors. This requires
 	  special hardware support and typically ECC memory.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f698df156bf8..baf2bd79b2fb 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1276,11 +1276,13 @@ static void update_per_node_mf_stats(unsigned long pfn,
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
 static int action_result(unsigned long pfn, enum mf_action_page_type type,
 			 enum mf_result result)
 {
+#ifdef CONFIG_RAS
 	trace_memory_failure_event(pfn, type, result);
+#endif
 
 	if (type != MF_MSG_ALREADY_POISONED) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
 	}
-- 
2.51.0


