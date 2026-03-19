Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C846107526D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00EDB6B02E0; Thu, 19 Mar 2026 03:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02146B0422; Thu, 19 Mar 2026 03:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17D56B0423; Thu, 19 Mar 2026 03:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0F496B0421
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:43:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B7BF58C88
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:43:26 +0000 (UTC)
X-FDA: 84562022412.03.B5BE945
Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	by imf30.hostedemail.com (Postfix) with SMTP id 1D6898000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:43:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=aN+ebKE8;
	spf=pass (imf30.hostedemail.com: domain of "prvs=md1532F6E9FC=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md1532F6E9FC=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773906204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZYaovtd9STTHHi4P6uKPiHfVgDEzzqsGQYk6Ozrb4I8=;
	b=cz4LzeoIvLpKAJSCuGXOFqRbC+Rh91eCizIfNuW1flveffUYjelrACdneR7+HvOUufWZsQ
	k4hHQlAeNBJChrBDHDzIxNHGFF4/r9koWU+e5i2HikeG7nqr2rdufB70m4bcgI6KuFWdhM
	lBdomISCC8dtQFWSH9gMy6ayv6ZYJI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773906204; a=rsa-sha256;
	cv=none;
	b=213a0Mgr/JCnOmTr/HCFo9AwRRG0sIO2JIixzV4OJV+ax8YvmKDpsHDUZE1MYCeafVGR76
	CeJIA/sb8MfS7q1ggivW7ocQGyIUqrS45FCH0dyF2EaBiN+iJCDkE+JuNXHKEIWAcguPsy
	eoJ++5+wzhWtp2B+kJZhKZ49OEpMTLs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=aN+ebKE8;
	spf=pass (imf30.hostedemail.com: domain of "prvs=md1532F6E9FC=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md1532F6E9FC=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki
	<urezki@gmail.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH v2] mm/vmalloc: use dedicated unbound workqueue for vmap area draining
Date: Thu, 19 Mar 2026 03:43:07 -0400
Message-ID: <20260319074307.2325-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjhj-exc9.internal.baidu.com (172.31.3.19) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1773906197;
	bh=ZYaovtd9STTHHi4P6uKPiHfVgDEzzqsGQYk6Ozrb4I8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=aN+ebKE82vdqMrxigLnItga9lvCFA1/Kz7EzVZfUPuYgw50xOyMEWR1SD0cmZB1u5
	 QIDM29FnsrJU+p/Zz3PO4pv5NrsC5ZJfzhVMs2Da9vYgiHJnURIRucrF93X229fihi
	 3tWlUjiauWZ+9aGmmVLaQhBruvopuKLUsvwCe0sM8noi+fmTETJ3+WwYIj0c/VyZ2l
	 KNZUzy8yJZnK9LNggOcsCMMNp7YKDPr2hM5DPIJ8BTjm6n2t9xwZss7Tq/CmKSeMVJ
	 mRN1BchIqahlEcDuKJvFn23Dp6YKZnyVTFZPAporjjay2GOVRv5n750OHY7JO82brO
	 W5bjxlyG7XTBw==
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1D6898000B
X-Stat-Signature: a9mgr9fh4ok41n1r1z58r6xke4zqffep
X-Rspam-User: 
X-HE-Tag: 1773906201-419796
X-HE-Meta: U2FsdGVkX1899s16MwtC7j47NcODH++CBm3b4B3s9kVfVo3rloj8WxyX9O6K8lLmUJuGZxI+2ApENV6pRIEWETPFvmkembtEhnfM/6DYP8whP9beKstlKwk2ZofiVO6FSbYbW9d/ki5/b0S9UERJJ/gwse/iZleO3EajQC0JDl10Pd0uonvqrBIHQ8X98WsdFFycCtpdAQkYGIMxHsJWWSLl5K4jMY6LOYBgJ3lf+rMoeYcVR+H/CWNiWp29B/8LyDTXIVMwa42ltM86XlxiR3W46UbcGSkqWoA9szdwkKuClhJY/eYQGzcSEFkKYEr4V5oR8oRhi83R2GMFstC12th0kqP/TcYXUPkOSMNT4hOmjk58o6RoZYtII5zYD/uLXKzg4wXlOFcAd8CcWHjwGfT479ZeMaYNK9IcseRYKaCsF2OUlpZHHvJc7k9Wwh5yZiCMpOArVlC+cC9nb6Dzu0pPoZTU4J//1MHaTelrKTnmjpTCbJVYsapQjevEggyKERnI7kx8JaMc72UqyX64TjQrk/7pmYN2twe5iPa3bMzGr5IadKGnE+fZMf4RZuhNBugoV4t2uDJ3WWMaYMScf4gKAeP4/4aKbjDATudK9aA88F9X/otqpKocFDfq29AhUqDbjRHAG9LT12j5YVQyeTvf+hNf/hYmjtLfRQ/0v8l4M6TavOeSThupXvco8qTBiXKUyNja423/nqvqkU0c4/ncd74YYofcUQe3Ak6kD0PHq3s2Nkv0iBi4/uR0y+hUcsz823MjM1bV9GOkmySSyXAcT4I8seaaWT4B7nbjD5CcTWB5cPKKwy4/mpNUF+rWBLQC+sxBH9pnmlJoubSTd6yRgdJ1uaixrgaFxbuJjrJnYVkOvnqziljq2bUGxKfBivj7c3iyhPM7Rp2nl6osTTONDyrS88L9MNGsZLOB8TafLPXBG0g/8vysIplc3zAzvO8YAidcGcSZUp9oX7h
 VRRqcOKi
 VWSfB7vY2LHps3RodSMbRdQM5svupRtdoIbdaEuU8ywpQHj4i+keIXJFY9Tdwz78qblttBtc8GPu47amVwrOcZ/o+7FfiW/3SWdUqAOm0Py4Id9rAR5HsEhv2hidI+axIlE/ymtrcZvzmzn3KbnL3jSVEm5Kg3Pvzb6mdcTNB2q+PwKXTmP53iKpB3rM/QbyCtTLutv74RGUhIGSwNBZ2B94ew6Rj7HRjZbgVT6ESlqDc2qXC8wReIy9I2MRPwZpF/QjG7bQJ7arV1JOZoVhz0nm0CEwvBcyvzZrzWwTKn+wRC6kPNcWYdgl+KcL3LPyf4SSflooSDdcYT6im7XtFqa3UIhMiUceKTNmIyaeIB0fN7JPcEvlc5SOJy9Jtp0lnBktFAange6DsmnthN6uRToh1+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

The drain_vmap_area_work() function can take >10ms to complete when
there are many accumulated vmap areas in a system with a high CPU
count, causing workqueue watchdog warnings when run via
schedule_work():

[ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND

Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
run this background task on any available CPU, improving responsiveness.
Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.

Create vmap_drain_wq in vmalloc_init_late() which is called after
workqueue_init_early() in start_kernel() to avoid boot-time crashes.

Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
Diff with v1: create dedicated unbound workqueue

 include/linux/vmalloc.h |  2 ++
 init/main.c             |  1 +
 mm/vmalloc.c            | 14 +++++++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index e8e94f9..c028603 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -301,11 +301,13 @@ static inline void set_vm_flush_reset_perms(void *addr)
 	if (vm)
 		vm->flags |= VM_FLUSH_RESET_PERMS;
 }
+void __init vmalloc_init_late(void);
 #else  /* !CONFIG_MMU */
 #define VMALLOC_TOTAL 0UL
 
 static inline unsigned long vmalloc_nr_pages(void) { return 0; }
 static inline void set_vm_flush_reset_perms(void *addr) {}
+static inline void __init vmalloc_init_late(void) {}
 #endif /* CONFIG_MMU */
 
 #if defined(CONFIG_MMU) && defined(CONFIG_SMP)
diff --git a/init/main.c b/init/main.c
index 1cb395d..50b497f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1099,6 +1099,7 @@ void start_kernel(void)
 	 * workqueue_init().
 	 */
 	workqueue_init_early();
+	vmalloc_init_late();
 
 	rcu_init();
 	kvfree_rcu_init();
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55..a52ccd4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1067,6 +1067,7 @@ static void reclaim_and_purge_vmap_areas(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
+static struct workqueue_struct *vmap_drain_wq;
 
 static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
@@ -2471,7 +2472,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		queue_work(vmap_drain_wq, &drain_vmap_work);
 }
 
 /*
@@ -5422,6 +5423,17 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	return SHRINK_STOP;
 }
 
+void __init vmalloc_init_late(void)
+{
+	vmap_drain_wq = alloc_workqueue("vmap_drain",
+						WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!vmap_drain_wq) {
+		pr_warn("vmap_drain_wq creation failed, using system_unbound_wq\n");
+		vmap_drain_wq = system_unbound_wq;
+	}
+
+}
+
 void __init vmalloc_init(void)
 {
 	struct shrinker *vmap_node_shrinker;
-- 
2.9.4


