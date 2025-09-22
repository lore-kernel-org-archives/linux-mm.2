Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 258C5CAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 02:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4F28E0005; Sun, 21 Sep 2025 22:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59BF68E0001; Sun, 21 Sep 2025 22:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8D08E0005; Sun, 21 Sep 2025 22:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39DDC8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:15:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB38C86E7A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:15:07 +0000 (UTC)
X-FDA: 83915268654.30.561C255
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf02.hostedemail.com (Postfix) with ESMTP id CB32E80003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:15:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758507306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1/UDRl9BMLfs0CKENJ0GOFGKfYZDsP8slcWL7SSEwds=;
	b=G7xCeztq5q7v+bRRmjXt0BE/e9ruNGpZMHC6zrYtu98+znsgqXh2YKl5q0aSFubguWViOu
	cunob1o7n5wkJX81IESloojwJ+VgMrNXxa129Y4xxb+zHrzLxUEhXP5+utvpXRo6dtfQ89
	CCuI4QEy+EsgOnk9tvKHUeSXtXrnhho=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758507306; a=rsa-sha256;
	cv=none;
	b=sqkXkKPoXNG83U90OtmVTE4JtiPfzXrh+wwypBClDRN4yGGaRGGA6pAC/6Wo9idIpRjJpx
	w1lV4EZoZ0dCVsBCXPFnFkgrl0f2TEx57I3Mm3FcIstd0eqT9dcfDBIulPOh82pMlGZys7
	miu8tp+oAsMrIFRXHuAupXWjmor6a/M=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cVRQk377Jz2CgD2;
	Mon, 22 Sep 2025 10:10:22 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id E560118001B;
	Mon, 22 Sep 2025 10:14:59 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.108.232) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Sep 2025 10:14:59 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<rmk+kernel@armlinux.org.uk>, <ardb@kernel.org>, <nathan@kernel.org>,
	<ebiggers@kernel.org>, <arnd@arndb.de>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <dave@vasilevsky.ca>, <peterz@infradead.org>
CC: <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <xieyuanbin1@huawei.com>
Subject: [RFC PATCH 2/2] ARM: memory-failure: not select RAS and MEMORY_ISOLATION
Date: Mon, 22 Sep 2025 10:14:53 +0800
Message-ID: <20250922021453.3939-2-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250922021453.3939-1-xieyuanbin1@huawei.com>
References: <20250922021453.3939-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.108.232]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: CB32E80003
X-Stat-Signature: 7fb1x455w6gu8xhmd3mffjjhy14urafp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758507304-938214
X-HE-Meta: U2FsdGVkX1/70S6EP/VtG9M/jJrGX824juMplHUSwGL5M2hWZhTvsvij4dn3j79E/WsaY4Dqk1O0CT6zI80sgdnnCeT6HZ0At3OoZkMA046Rg9d0RoggKhBXGcVb6cJgcMd7p+BHMLPAvi9ut7ifqU7AOQ5BTbnGEzAVSnZ1N94ZEs4AthfnKkLtUW77Y8YYZgag7Pifk3xZ6diNTmWVgjVUX3LjpTp05m2TIbml6ttMU0zE02PPzM6wib9JMxqOJdF28JBI0lOAgCni6jPi7CS57YgshVTwFiwiKnVzmD2MurxYcwLgCqRoPWo5CQ5iEGBB9dbHiq8WNo/4ksvKVy3rhZ1ksuv7clrs0JYvJe+OIrZAKq79qJai1gp8f+K9qsvsGsDdCKjBAXCwr0+Vw0azVv8oMyt4eQd0TBI6ji6PKjhQn7w822UlhwMxkjbuT/FKvwYHKDRdcMqbTS2nirNHD2Emv4LS0Qf3IVe11Bo1yL0eBSxP5o6WaySy/vSaVjHA4+85f1UUWAr/k1ScgKinmc1ka9DDuFA1k7txBg/JCwKEw+iCduYBXd+3mc2OtwueZDtJQnKzr80k9zFOu9kdfSK42V1PLv8RPZXIEbhvb5lAMV6iZoiVkwVwCgCf1Al/9kmU65ru3Ul6SoMY1QA6LgaQmPRVWK0b4KxPfc5XjbwZB/r6Rwcp0l1u2vrVcb5sj2COyIJi6XgvNXY7Hh97M+4u3xZlg0iarDCxAsV0vS7pJ3d2VjdRkG8IPqStgOUS1KCR4erKvBlmkCHdMmHOSdYwuOGXvcSyMk60WlV8uPgBv1/U3gkMQctF0BEInvA/pQrTThjgpR61HrRpPrVQiMODrJSGQIti1Q/TdrVvzoDWFQ+N7RqOQ2HRjynIvCxBio5SIOvxTgmwKBwBEGc2gounueYexmOGuPWrgth/LXGjuRMxieq40n4QjpPnCOjbP21FXcioIJWJVCg
 Le1umC4q
 udanm+QGtygcxD0jJM7m74J1ZBhRv/pcE9JfDlZ7QhNH969rcniBk+KZfeWNfg2nodTcX1OfG/i8AFs38DrI0D2se/+ugL8o91LlG9GBVZkbBXoxH6L35znwHOEOAFA6gq3fBcriDjP4DgXy8Beu8TaBYigsjkV5veF158Zt4F/wGXGskrK4rbFxouv+Ag699Jf2mOT+d42osjBaLQl+yw6Pz2ddJIjMS07gNHAz1a6Xy6hfCkQ3ExiFahmn4GrkVYPWocyCWEFzO4WL7LeUW72GJ9pwzY721VUOUzlkpR7ABAPATL+8pdYXZS0rFn21aSp7cn9Pt+L84PdU7okhDvUL7GCsopKE3Ns0B241ZNcPGsIk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For memory-failure on ARM, these features do not seem necessary.

Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
 mm/Kconfig          | 4 ++--
 mm/memory-failure.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 034a1662d8c1..22eefc4747d5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -742,22 +742,22 @@ config DEFAULT_MMAP_MIN_ADDR
 	  This value can be changed after boot using the
 	  /proc/sys/vm/mmap_min_addr tunable.
 
 config ARCH_SUPPORTS_MEMORY_FAILURE
 	bool
 
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
-	select MEMORY_ISOLATION
-	select RAS
+	select MEMORY_ISOLATION if !ARM
+	select RAS if !ARM
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
 	  even when some of its memory has uncorrected errors. This requires
 	  special hardware support and typically ECC memory.
 
 config HWPOISON_INJECT
 	tristate "HWPoison pages injector"
 	depends on MEMORY_FAILURE && DEBUG_KERNEL && PROC_FS
 	select PROC_PAGE_MONITOR
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a24806bb8e82..83b77caf41a1 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1271,21 +1271,23 @@ static void update_per_node_mf_stats(unsigned long pfn,
 	++mf_stats->total;
 }
 
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
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
 
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
-- 
2.48.1


