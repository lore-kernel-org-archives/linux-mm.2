Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75BEAC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A076B00A4; Fri, 31 Jul 2026 13:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4356B00A5; Fri, 31 Jul 2026 13:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9FB6B00A6; Fri, 31 Jul 2026 13:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBE776B00A4
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:44:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3A93140476
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:55 +0000 (UTC)
X-FDA: 85049603310.18.C84EC9B
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf15.hostedemail.com (Postfix) with ESMTP id E88BFA0006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=k0Fn2v0h;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="d sZHhPg";
	spf=pass (imf15.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785515274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuhD3aoT0AyBzEwnNlnOqTcbkLD3kV+I1Y8Pd5N2o2I=;
	b=JLjHDsVfMBo+i7jgw+Hk1GjB0ICIZLQWLS1qb/RWZPl5oHWKzYkZNCu7L4TOZrtG/gniHo
	80hutF03bqAbj6LETd6XebXjrLQYUp6pFlvVHtPNYYHmQ314Zav5zTt39E6yhmaXX7kmYO
	p5UNxoG3fWvqfR2Yyiik+pEKUV9VA30=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785515274;
	b=0+mwyqYE+mGU+2KhCHw/LeHAwmQfgOvhFkmAHPmY7X7KpVL/GfBnPrgpLr0u8F4F1xCE1f
	vZVvtQrk3s8yx2RkgOGhRXiP0d4Ur3fyc9hI9smC66RK644FjLitmR3FVrKX0vfdJCXKm+
	wZ92ZdDIlLmrCeHCu4E3hccKn6YHbDc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=k0Fn2v0h;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="d sZHhPg";
	spf=pass (imf15.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3A9757A011A;
	Fri, 31 Jul 2026 12:27:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Fri, 31 Jul 2026 12:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785515273;
	 x=1785601673; bh=vuhD3aoT0AyBzEwnNlnOqTcbkLD3kV+I1Y8Pd5N2o2I=; b=
	k0Fn2v0hBAvs16EZ/yLw7TLmuFAcOyD/YVjC8Ouq96comN5aDewzZCfL0asIk2DM
	c7VaqQfnLFOz3ABgiGWXaGftTmHIkQV30TQUqsMkko6p8fVn/eX1C7HZKlwCwSZ/
	2q5TdpN7JGDxH/IaZPK8mBG2PdPABArXvqZxVV0f1jdA44KVF1NtJaTuAFfaSGbL
	1WbTOlIVJrCpI1KDUJ3L5Cp6TI8dLucgg5JT/pkj3NQxdJHUdAdjESSRuZ6G6LkT
	7zRhJxK8optUcn1MCi5sFsYsVZA/q/8vf9K0Fr4Yg6lynEgKjmq4NGh58slVn9tg
	v5mBwTY08HlUzvXNCUe6rQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785515273; x=
	1785601673; bh=vuhD3aoT0AyBzEwnNlnOqTcbkLD3kV+I1Y8Pd5N2o2I=; b=d
	sZHhPgulOxyRAtF1Xbe6k93rj3Mywvhma1m4kxcnHqoNqiBzekcoalPjzyO1gyy+
	Y4jC5rQKNvHv9ZYWpvZ+aDztsnCABebXs2Izww02hHxEj5V1Rp4vh6Xd7wyVDujc
	8xB5SdcKqwRsoFyI2w/FVwJBzuiln+aLCY4ODovodqBgvz+bou6uK56JmAAQfn4T
	wVX7XWb7r/BoMEjViUVmIqxm2mE1gRlklds09mmeDQMN78mjMinH0wJjCMz+ih4M
	06Aeu0npEkJowZhGqcRJLLl2c+ATj2EFJClO+H2uctY06MJF15RsbvGuFqtoRkDR
	VCNNIPnCa5cPuhlsXu4XA==
X-ME-Sender: <xms:CM1sarSPK8tl8pnWv2uH6g4wZr--5nqlC45vsxulbQzNbHOofZVLHw>
    <xme:CM1sauXjnv8yAG4obCa4UHqnYqll6lL21IBldfRSSJjGlhd1M-PeWtOdoG3mDdHkC
    KPCkk7kYosfPWaqnf-ltu-4kOsTShdKFa01UhdEy33jIt2BUlWiKw>
X-ME-Received: <xmr:CM1sanKtTrwfzroiDfSPnoQJTvuMplv57G2bzQv57sfayU2k8PSiyCTH6_QAI_f5FRJnBK2e35r6RP8iaQ>
X-ME-Proxy-Cause: dmFkZTELfHAaFlN+kIG6IssmIq8q0/JRtHYiEDamnKwtHAGTm/rIkphiM7dmck7n/tEVID
    Jll9XZRXegS5DA66U1m8pj9kUlkWW6jbmxkpZ2Vy+f9sbLWY4LPn/k9o06nVK28CzSnHlD
    lWYRxoJf+HWhSZ1zy9/rODG5OphaTJnkZfxiinHtBeukYGRaEV6rsOpAthbf9Rnwd5neaW
    b5ga7UTCgjqgAq9wYXuIHu4RL0lK64k1SgzKLwhWoz9uN8eIJVTlSs/QiafsKJeCqGBPP+
    mXVeoA/rZsAKFBE67k4yvTZ9NpiBwhCbzC9zQWp6wR2HnNM114K5oGLjvHnZO8zy7kGoM+
    43ztEq9yvmk5FIo339uS7eTYuFuzoPGBEBAV56zSFneeUyT1x+W8YuJDcNHflL5vlg94Nc
    tRE/z0/TBF6FknKyzSzFwXEGXce61rnIpBKiwhKAJPH1q9EgnFkJH/sYGfFrxEcKBzyjWF
    wJSyyb0894hIenNcHuohbTXDuBYnFqA9f9SKfwB/j1Fia7HM5hm118pFRPbsHhewSXfAqg
    1BMqPWBdv1JpB+6v6hYDG3BaNrKft+MpEMXFdE7J5adB6kIQFZDjk4ycPJK4tw3VG5E28x
    OVWMXqMrDck/XjQJJw4OWKtP4nkq1iPW22fpkHdEnpj5tXx568GTn10k6v1Q
X-ME-Proxy: <xmx:CM1sam1-EhJe4KMpBnYfP287RagS5IVRGdDFw-FSVRSSkYnuRsT8SQ>
    <xmx:CM1sasLDZpJ9gTmtx-jggzOhLZLPe6cIwPwFATB9WHkHTylD2ogjxA>
    <xmx:CM1saph9l7hk7_tiaqg8q_GRfrIvBxTU89PD8u2yo_CSHvCDkGLl4g>
    <xmx:CM1sakCBeSTaUWwDhnPN8X2QadLMaCSI-aNkkXTbqmwo5fpFcNsS2g>
    <xmx:Cc1sai_2vETs0lM7UmIQEF6NbdBMahVqO-7pdz6By6aE8MWAFYpavdUk>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 12:27:51 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	keyrings@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org
Subject: [PATCH 3/4] mm/secretmem: zeroize secret pages before kdump
Date: Fri, 31 Jul 2026 18:27:38 +0200
Message-ID: <20260731162739.158320-4-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731162739.158320-1-linux@jaseg.de>
References: <20260731162739.158320-1-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E88BFA0006
X-Stat-Signature: zu6gourijzssipep8iebyuoxkrd3ooyk
X-Rspam-User: 
X-HE-Tag: 1785515273-173949
X-HE-Meta: U2FsdGVkX1/dOBO3fPXcYLcRIpbfrXbv/hqRoRGJIdWb0v4q8k867BM3Yqxw7NozW0RIgIb/Ad5doVWSgrRQ3oLCYXjoXgq2i1kdv/V/vRSW2UPbAm5m4Z526Loo7j6ejtMHLCmAamtDEn13kCZEIg/WXfbgKHn+fS/ik0OOJDpw2b74MafTAJtA3vKOhqekh0ZQSzKixea+7QJoqh8oHt7J/qmANg037PEKf96err/gnwQ2KUvEZ/HvNA0r+WYMG5+A6iUtESprGeZYFA1WQXUikZRRjayrg6fbXHcP1FWAIk3urUyo+wzQREdh6g6YtqnzpeCm0JB/bTh8WycgQt9cQ/pKWqjrigg4CWz3p5F2djixFAdhfDto6RXRANqmFMoYFOFxP/KWYwkJfFcsowloXZ3waig3a4NUunnJJXeIa4EwrhHBnFg4HOl4zl3k3B4F3U9areJN1HZCw+AL1Si6AKAoM66mwqb1AqpQ3JKTN620B7zmHzjI5B6y/za6W97PRkQbSmqmtojy5ygT8O0KoUiPUoeYKT8ItTcWDQFBfa5G9yeP6+wyLsCVeB1ntcUsB4GtddWyl8uaRou4WSukq7SuSMTeYM2n2BuQtbTAa2ZyTcl3WOaf7TUY80dkwwo1OwJYWn0C2/wAapIKYapW7cM88OQBO3O1C1hXFfwZDiY57QxyVhuxsnK+UNVNB107X5PzIWKcJKA8F31EMwdP1XCI6thgPK8O8htjFH8F7EqH1+kn+8s1DjwMVz8L0SZRgzRoR699WfThqO927q/78tDX3gs7DsXL60CswPmFEzVcbEDcHClmH5eio/HEvo6rGaR45HEtD1oLLPw26GxkTaa3slTfp3rc6spaAmc2dbQ89WjovM7YoGNsTSM2zFEFR4Shzl2P/K5xL3Zta2PvHdA5ASiJ3ToIsvv5lKT5rA6UJfa/Bzt2QI4JbgNzxNMmIMjYDs9s7GHXqW0
 tASAlph0
 Tc6zITdOtpleQqih17svXVflDY3Thjxy9RpuqE91dvLNFt4vXEcC7o7zGCxwEmtTGo9xkqkDmdiDFkZXjw0gFSFevWuzDToSnnG+MROGqDenkhsMkBZqiLZnMDZ6XXSa3AVCBJWAFNv4l+vGIaSxBIotERZqW6rhNd0thFvu/5L2uWpDrMIPWtAHkakqXhtZNUcFysdGG51jG9vBkFgs4zUSQNgY0trJbwwLn1zwlxlW92FnvH+mjQjYVz6jeZDy9Xp9GOR6AhS1hgevUtRgxyMNAj3cknb5V2U4BQoL5PeOFv8kum1QvnQVKfNw8k0GXo5zp9OfUayzRUFPByEB4fukh7Xht63R95ZYn8AWewSF/0Ck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register a CRASH_ZEROIZE notifier that wipes secretmem folios. As a
result, when CONFIG_CRASH_ZEROIZE is set, secretmem areas will be
cleared before the kdump kernel is kexec'ed.

Zeroization runs after the other CPUs have been stopped, so the page
cache cannot be mutated concurrently and the xarray may be walked
without taking the i_pages lock. This is a best effort, defense in depth
measure. s_inode_list_lock is taken with trylock only. If a CPU was
stopped mid-modification the list may be inconsistent, and this late
into the panic path, there's nothing we can do about it.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 mm/secretmem.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index d29865075b6e..53f629d6633c 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -13,9 +13,11 @@
 #include <linux/bitops.h>
 #include <linux/printk.h>
 #include <linux/pagemap.h>
+#include <linux/notifier.h>
 #include <linux/syscalls.h>
 #include <linux/pseudo_fs.h>
 #include <linux/secretmem.h>
+#include <linux/crash_core.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
 
@@ -187,6 +189,50 @@ static const struct inode_operations secretmem_iops = {
 
 static struct vfsmount *secretmem_mnt;
 
+#ifdef CONFIG_CRASH_ZEROIZE
+/* Called far into vpanic from crash_core.c with other CPUs stopped and
+ * preemption disabled
+ */
+static int secretmem_crash_zeroize(struct notifier_block *nb, unsigned long
+		action, void *data)
+{
+	struct super_block *sb;
+	struct inode *inode;
+
+	if (!secretmem_mnt)
+		return NOTIFY_DONE;
+	sb = secretmem_mnt->mnt_sb;
+
+	/* If the list was modified in the exact moment we panic'ed, it might be
+	 * in an inconsistent state that would be unsafe to iterate. If we can't
+	 * get the lock, too bad, that's all we can do here.
+	 */
+	if (!spin_trylock(&sb->s_inode_list_lock)) {
+		pr_crit("crash_zeroize: can't acquire secretmem superblock lock.\n"
+			 "crash_zeroize: skipping zeroizing secretmem.\n");
+		return NOTIFY_DONE;
+	}
+
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		XA_STATE(xas, &inode->i_mapping->i_pages, 0);
+		struct folio *folio;
+
+		/* no need for locks if we're burning down the house :) */
+		xas_for_each(&xas, folio, ULONG_MAX) {
+			if (xas_retry(&xas, folio) || xa_is_value(folio))
+				continue;
+			inode->i_mapping->a_ops->free_folio(folio);
+		}
+	}
+	/* off to kexec()! */
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block secretmem_zeroize_nb = {
+	.notifier_call = secretmem_crash_zeroize
+};
+#endif /* CONFIG_CRASH_ZEROIZE */
+
 static struct file *secretmem_file_create(unsigned long flags)
 {
 	struct file *file;
@@ -263,6 +309,10 @@ static int __init secretmem_init(void)
 	if (IS_ERR(secretmem_mnt))
 		return PTR_ERR(secretmem_mnt);
 
+#ifdef CONFIG_CRASH_ZEROIZE
+	atomic_notifier_chain_register(&crash_zeroize_notifier_list, &secretmem_zeroize_nb);
+#endif
+
 	return 0;
 }
 fs_initcall(secretmem_init);
-- 
2.53.0


