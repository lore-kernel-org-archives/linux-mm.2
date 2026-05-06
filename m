Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 167C6CD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4028E6B0088; Wed,  6 May 2026 08:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3176B008A; Wed,  6 May 2026 08:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27AE86B008C; Wed,  6 May 2026 08:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 147AC6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:00:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C01C4C09BC
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:00:20 +0000 (UTC)
X-FDA: 84736852200.30.9E0F116
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id B6042140010
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:00:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="XW/qXrnb";
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf26.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778068819; a=rsa-sha256;
	cv=none;
	b=jHhJ7kP/7ZLJwUPgpdoL59GQHCsMVJqEf19qtHT4puv2eA+l3nQRZVV5Gnp2+1sSLQ/Ymt
	li7CiJg+SQuhxOglvlz9C8saiW6lYvDrNhJ4yaAkbw8sjOpss0gdrH7NwYf2tw/pcAKnjE
	QnZiME7YbxemLA16ZAeftZQrIT2hsjg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="XW/qXrnb";
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf26.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778068819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+geGgtC29tPii/y0xORPdzxzZcUtJ2/stRBH9k/cNK8=;
	b=V7QN/eFuVLd+vlXGMEJ5U/e9CQpb2YtSYemax32Hdl9n2WvFRtkRufBYzEyAoH+7zinIU0
	y0pVfX0pWf77BmNJhRm4MrSg82LibkQBGEa5i7z+5aHzyRZTvydqTP40zB2kDJ73EZaehf
	HTDpCVXUa8n9LvyMfQDNXBnliNcotvo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+geGgtC29tPii/y0xORPdzxzZcUtJ2/stRBH9k/cNK8=; b=XW/qXrnb4pX3o9W+wGI0W1ifJ0
	NfQ+n+ZFMHfs6VA1ESmzMbKmE1LhTwYO6E5ioKclh1JV02ZMIgaDzq0GWDQGBY0gzF5M76ylnTxrC
	7E83xUP/BpozMsICavLB6ZnfU1OU6LKx0Wj5aunbLpYvtUEeeieIU3m/Gz6cMFp6EOwENrODXCbf3
	qOAhjJFrqtO3TTo1KdntZRMNWjDxPaXQbODeZrPCu7vO2kJTzJ2xG5HwK+Qr7Tfm/0zWjMzI9lyRr
	zfNSZ+lTmJAiOm3aESaWQv9TqyHj0lqJt/pwBZdfMkgX0LhFpjXGu24OPdJYs3yC349aEQjU01NgC
	TXGtBmgw==;
Received: from 179-125-92-238-dinamico.pombonet.net.br ([179.125.92.238] helo=[127.0.0.1])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wKav4-006sxt-Ta; Wed, 06 May 2026 14:00:02 +0200
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Date: Wed, 06 May 2026 08:58:24 -0300
Subject: [PATCH 1/2] mm/page_counter: decouple peak_reset from peak_write
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260506-dmem_peak-v1-1-8d803eb3449c@igalia.com>
References: <20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com>
In-Reply-To: <20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, 
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>, kernel-dev@igalia.com
X-Mailer: b4 0.16-dev-62088
X-Stat-Signature: im6cb9mn6g1yzerijin878qujcznqsqp
X-Rspam-User: 
X-Rspamd-Queue-Id: B6042140010
X-Rspamd-Server: rspam07
X-HE-Tag: 1778068817-608593
X-HE-Meta: U2FsdGVkX18OEBEmB1J2k6v+kQO6/ChCQYJ7ZPAyxGrC1oslrS//HivtugGA3uAuOdwxHcWcCqic55l8wgu+DlCzQ9k6O60IQr/EZNttrix1DsLVpQ+mIfWssHVPms//vAgBCewVWLRrQZzy1QzkpwjscHIoQtPKs/sb2kTtrKwFJ8YyjRxx6AVgIoDu5mVxPQdMV2D0+i+TqkoJrLDixYSZV4UKbanFckjiwffUGG51PQXp/HU21F374ppBSfcuiiV4oW5LiLG8sivc7AiZNSgjoIGVBB4VOOpPbX28fTtq37U6hHiZGE3dMnU2EstdJa2BWu0Wc6rAX7rfUeuSUKDLaLUNoe15v9glcNWpH+XQABDQqvCsJut29wHwULr35vLfvxlCuKDiTY8nA+JThgEzHGhsfKzHCUvDNoIpdodmJVWH+97rdEyBqEtXmr/i4/ploiQ1JVxUVFSWaOfmJYsEP9LkuCIp6ZG2R+hvithUKoDt3D0xUS3gXjY0+ZypiTnPGt6ng5O+JdYbhih27U6G4hjk4Di7/gsjGyofRXx9HiLjSZfRDswaNUGkmdQzNfQWeaKhgDg9PXHsKp6u+PpV3Mp1HgDUh7mv/6HaqRNdDmGsBL2lxDOuElgv38RGYE3gFWzPYV6yxLYraYrS4GHCiYTvdpuosYRV8ac6tYtjUmXbKP1Hbr3E6DUDdFbudL5zZu0TDuWdj5/zi9vpHSU9ouBoaD+LBGVA3NeS235YhqecGnQ6hZxAuuh8UiqjjctnnuATV1o4B7cktsUzTRs9utX+7pOrNPoQLheia5K4lwBXxShCicu/4qYKXnlC1BiXLAPZRna95ByBnEcRLxVwRk0DPoIAOHLrR7C7XDk1LdZjoYc4OkwgMFSmia6zo0Gs1EXoqJpdqlqadvTUa/amN+uMmK2tztGp8F6YSIw8HV6zI4IOHF+pJ332nWkmA+ZfRUwVq/Ei0bvrdrd
 XiVCh6At
 /3/R+l1E1FxZf7v1HczdNr57lhvQ5Nz3cVYteLm+GEf2+FgUU6QQg3VvKPRN7NvEtCsWY0epoTmi/Yse5PbJeLUtnL/jp0QeVQISEILIRJtSuTf5RdrfdkKag0BdZY8CNTltrUT3LDwcZ9Hq8L2zp9m3WzWQo8eqTeFBORNZy82xVUxw8mAONxTpJaga70JeHfGzLc6L9KVGxySNlnWgPMabIgh146qcjlyaFxbEy6sGWUjLm8BwsN0rVaHeQgbTozErlSnwi7RGXMPzpMJhKMK+C051nWrI7QVdKaE2yC6zpt6kjYawQV5RtXClJZJYDiUFqoFxlpdj3cqd8e51A4q0C9neVRxD/iER3XaDnnKPJmbk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create a new function of_peak_reset that resets the page_counter peak for a
given writer. This should allow it to be reused by other cgroups.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
 include/linux/cgroup-defs.h |  6 ++++++
 kernel/cgroup/cgroup.c      | 32 ++++++++++++++++++++++++++++++++
 mm/memcontrol.c             | 42 ++++++++----------------------------------
 3 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index f42563739d2e..a85044cb0553 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -22,6 +22,7 @@
 #include <linux/workqueue.h>
 #include <linux/bpf-cgroup-defs.h>
 #include <linux/psi_types.h>
+#include <linux/page_counter.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -868,11 +869,16 @@ struct cgroup_subsys {
 extern struct percpu_rw_semaphore cgroup_threadgroup_rwsem;
 extern bool cgroup_enable_per_threadgroup_rwsem;
 
+#define OFP_PEAK_UNSET (((-1UL)))
+
 struct cgroup_of_peak {
 	unsigned long		value;
 	struct list_head	list;
 };
 
+void of_peak_reset(struct cgroup_of_peak *ofp, struct page_counter *pc,
+		   struct list_head *watchers);
+
 /**
  * cgroup_threadgroup_change_begin - threadgroup exclusion for cgroups
  * @tsk: target task
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 45c0b1ed687a..9b98a5cccf0e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1981,6 +1981,38 @@ struct cgroup_of_peak *of_peak(struct kernfs_open_file *of)
 	return &ctx->peak;
 }
 
+/**
+ * of_peak_reset - reset peak
+ * @ofp: open file context
+ * @pc: counter
+ * @watchers: list of other open file contexts
+ *
+ * This function updates all contexts in @watchers to the new usage of @pc.
+ * If @ofp is not in the list yet, that is, if its value is
+ * %OFP_PEAK_UNSET, it is added to @watchers list.
+ *
+ * A lock must be used to protect @watchers.
+ */
+void of_peak_reset(struct cgroup_of_peak *ofp, struct page_counter *pc,
+		   struct list_head *watchers)
+{
+	unsigned long usage;
+	struct cgroup_of_peak *peer_ctx;
+
+	usage = page_counter_read(pc);
+	WRITE_ONCE(pc->local_watermark, usage);
+
+	list_for_each_entry(peer_ctx, watchers, list)
+		if (usage > peer_ctx->value)
+			WRITE_ONCE(peer_ctx->value, usage);
+
+	/* initial write, register watcher */
+	if (ofp->value == OFP_PEAK_UNSET)
+		list_add(&ofp->list, watchers);
+
+	WRITE_ONCE(ofp->value, usage);
+}
+
 static void apply_cgroup_root_flags(unsigned int root_flags)
 {
 	if (current->nsproxy->cgroup_ns == &init_cgroup_ns) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c03d4787d466..8754927070d3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4517,8 +4517,6 @@ static u64 memory_current_read(struct cgroup_subsys_state *css,
 	return (u64)page_counter_read(&memcg->memory) * PAGE_SIZE;
 }
 
-#define OFP_PEAK_UNSET (((-1UL)))
-
 static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
 {
 	struct cgroup_of_peak *ofp = of_peak(sf->private);
@@ -4563,45 +4561,18 @@ static void peak_release(struct kernfs_open_file *of)
 	spin_unlock(&memcg->peaks_lock);
 }
 
-static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
-			  loff_t off, struct page_counter *pc,
-			  struct list_head *watchers)
+static ssize_t memory_peak_write(struct kernfs_open_file *of, char *buf,
+				 size_t nbytes, loff_t off)
 {
-	unsigned long usage;
-	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
 
 	spin_lock(&memcg->peaks_lock);
-
-	usage = page_counter_read(pc);
-	WRITE_ONCE(pc->local_watermark, usage);
-
-	list_for_each_entry(peer_ctx, watchers, list)
-		if (usage > peer_ctx->value)
-			WRITE_ONCE(peer_ctx->value, usage);
-
-	/* initial write, register watcher */
-	if (ofp->value == OFP_PEAK_UNSET)
-		list_add(&ofp->list, watchers);
-
-	WRITE_ONCE(ofp->value, usage);
+	of_peak_reset(ofp, &memcg->memory, &memcg->memory_peaks);
 	spin_unlock(&memcg->peaks_lock);
-
 	return nbytes;
 }
 
-static ssize_t memory_peak_write(struct kernfs_open_file *of, char *buf,
-				 size_t nbytes, loff_t off)
-{
-	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
-
-	return peak_write(of, buf, nbytes, off, &memcg->memory,
-			  &memcg->memory_peaks);
-}
-
-#undef OFP_PEAK_UNSET
-
 static int memory_min_show(struct seq_file *m, void *v)
 {
 	return seq_puts_memcg_tunable(m,
@@ -5611,9 +5582,12 @@ static ssize_t swap_peak_write(struct kernfs_open_file *of, char *buf,
 			       size_t nbytes, loff_t off)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	struct cgroup_of_peak *ofp = of_peak(of);
 
-	return peak_write(of, buf, nbytes, off, &memcg->swap,
-			  &memcg->swap_peaks);
+	spin_lock(&memcg->peaks_lock);
+	of_peak_reset(ofp, &memcg->swap, &memcg->swap_peaks);
+	spin_unlock(&memcg->peaks_lock);
+	return nbytes;
 }
 
 static int swap_high_show(struct seq_file *m, void *v)

-- 
2.47.3


