Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77392C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B415D6B0092; Fri, 31 Jul 2026 11:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBB46B0093; Fri, 31 Jul 2026 11:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9935C6B0095; Fri, 31 Jul 2026 11:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53DE66B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:46:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1E14160475
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:32 +0000 (UTC)
X-FDA: 85049499024.05.D5EAB18
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf27.hostedemail.com (Postfix) with ESMTP id 639304000D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=A4zNhdYe;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="R W/bChF";
	spf=pass (imf27.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785512790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuhD3aoT0AyBzEwnNlnOqTcbkLD3kV+I1Y8Pd5N2o2I=;
	b=6eshSyXBti4HkTc4cPBb1MTvreHGEnXde5QyH5pT6IxTBhTAAC4oxDhgQIZchBZNlbguk9
	qOzcHDOt7uDSdvhdLCcmtwIuN6ZFWiV6dlUqM8WDijYzZIkz95Gu7jAKOd3m8byLnFYgg1
	quJbNWU4Pcg+QjPZfg7ufYxVdS9bPQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785512790;
	b=pjSF9BieGYHZI8WsufD5ZzejAHWY9jvknzOSnl9P62T3YFv4WN0rx1fJ7OKPsYOs8x6Yfa
	N4FZudFIqceQBmOZ89snNe/NwTjN/tqTqMykHNX5GF+OKGl+EtyI/5P5vDwRv+IzMr4vyj
	tW5LOvF1nmSjcH3Fx/b2Oiu0COLySyg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=A4zNhdYe;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="R W/bChF";
	spf=pass (imf27.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 2D9A31300112;
	Fri, 31 Jul 2026 11:46:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 31 Jul 2026 11:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785512789;
	 x=1785519989; bh=vuhD3aoT0AyBzEwnNlnOqTcbkLD3kV+I1Y8Pd5N2o2I=; b=
	A4zNhdYe2c0zkpkQugS9piOLTtW79A0mDI9E/F0V+cg5pC4Wix08Dj/5yQ2oHMfK
	PyutuVFxUUTXjYRRZxvScVTgap3l0e8CDVOs+sixHhqvBWFGvqhMqsTamu047vcA
	t9y0ReJAPS9POEVQRuIoArVuLkFmKg+XGzSmzjVpZz1IfGHA3VCb84yNdj162uRo
	MfEI1M6NIuNdkn1NpOwoqy/W2haUW9cRRGo+tFV/YGUuWsoLe9VwCyCAwNwvT+Vz
	/qXrwi3vTWXpGoo+oiLS5bIgSSCzMlvjLtEn1jfdBTEfiClFD40g3In7WsZXIpN6
	lVJk11VqRqtL4ChvdiNj5w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785512789; x=
	1785519989; bh=vuhD3aoT0AyBzEwnNlnOqTcbkLD3kV+I1Y8Pd5N2o2I=; b=R
	W/bChFPnActNSpvOcmbnjUOMD2Z7aDaZiMdwapf3zUf4zqk7KfVoS/ZbRO7lQsGu
	/RsK7cS6A7uax3NuW4EYT4rEWI1nPkam2Jxh/LOiAFeNrT4YC6ELfTPB52F+1my7
	30L/nOgvSoODJ8jlAQbC6Os7C3mEI5Q4GIxqfpk9EVKDLMDqliB1D78zXfvKVMY6
	MgD+GNDTph9sH6LQKkwwM1RLgncUhpupuuczYvfFb8bXibyBseSqrI84DhbbXw4n
	gCGP1yHchIt96mFD0+Zb9hfsfWyxXxm+pipeml7VPaX60AtHJOVpHtxYp+306FAw
	do8v4B5tOEZw65c0TYHkw==
X-ME-Sender: <xms:VMNsakSi6CTbm4kpM1dMtq-I2WEsssafLCa7HnEXpyK1ajNIbg4QWA>
    <xme:VMNsat5dKKDDXiDQVbeoxmKkFsMn4pHc85tsUMsW41oY6MxBe5qfNUYbXlRBsdimh
    T_Rf0_8ggEeXlXi6g-Y8LM4LaElHqPCvnE39qRV1YDr-fPzNq73fA>
X-ME-Received: <xmr:VMNsatq3d6rxXKCZh8CuG2RTFNCAKSg8oWlkFxWgiI01-GM1KBEywGEohzwkzRCihmzBqQC4M8gQ33Ze-Q>
X-ME-Proxy-Cause: dmFkZTEDtV/RfR0lo0HHB8XdeLePstULQCU8lD8vSj/fzai7Kt3qGLzmV2Zh7eabPaGFb0
    2JllrHJpDbmKgLep87ndKLD8srM1OHP+B2aK7Yo9bQqUBCftK1jaCjofENQpbYCPj35N1B
    D51JM4wkbVzLK/VhvB5rAZpxM4uJ15CvWyziZqB0Yl5deZXwzgTYTbzKrvOpxGFqqPQUVr
    i4kpPelxVCZV5wCGN3geRNU8HWmSzPdeRSyBpI4EPivmCljrA+60QSoB0UUC9t5AFMHYog
    wby+Nk4njR178weQert2KSbb1tn2SD6ZTK7DDLV1yic4Z+7nokuhhALqi8KJyuVHzaD9KM
    tjVGZT+3Ps3E4JjqAnbqRwtE6mPw7lRYlPF7Ix8/0DPfvB6Tzqgm+6lWoBqWNjQ6DAvKfg
    phcitCKTOc1ccLwf6KnR5jwmNCIfyBFz9d0ZF/+3TX2w869/ojiJQ9dmc69a54Cm8/0Wve
    VwB1xhQreCtebsdJOP9e4KcfWYcxsovWqgxfvfoeraT5OjnjeM59Po1W3IfwDsxEQuGfFR
    CsU7eCj+UFsIn5zeueiTGkVUK3f3k4n/5WIdWw28l1YOrth23VgKsfWhuI88myee0Uc6C/
    mn9Dj0AXvpG8cMiZu4qjnQNapvRy67fiak2oK46P68DTzhavrCKITstCEwvg
X-ME-Proxy: <xmx:VMNsahW_e0ArDh-km8mqS5I978go4sDRVRoYFZ_X9K-WG05_tyVb8A>
    <xmx:VMNsatrqt_wixGrfDvdt1FMRG_sDvPQVwgh28R1xJ_U_tGIMuioWgg>
    <xmx:VMNsaovQtb2NPmvyePvR_fXM2FBgLgUr9k1Uhde3FY-pUdvOiQ2dhQ>
    <xmx:VMNsajQKV-7xAq7LQIwXPuZhLGB_ySPiADwOfngU0rMNUBP2dVn15A>
    <xmx:VcNsapI5MtQmJgJJF3cOoU9fHccCIyGSbPUQsAQnLu--fnV2F4CEnoj8>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 11:46:26 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	"devicetree@vger.kernel.org"@kvack.org,
	"linux-kernel@vger.kernel.org"@kvack.org,
	"kexec@lists.infradead.org"@kvack.org,
	"keyrings@vger.kernel.org"@kvack.org, "linux-mm@kvack.org"@kvack.org,
	"linux-security-module@vger.kernel.org"@kvack.org,
	"linux-integrity@vger.kernel.org"@kvack.org
Subject: [PATCH 3/4] mm/secretmem: zeroize secret pages before kdump
Date: Fri, 31 Jul 2026 17:46:07 +0200
Message-ID: <20260731154608.153258-4-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154608.153258-1-linux@jaseg.de>
References: <20260731154608.153258-1-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 639304000D
X-Stat-Signature: 1i836i1g9wnz7qazj3owyriuptxsyd1j
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785512790-536245
X-HE-Meta: U2FsdGVkX1+SOv/FKPOzSnbCjCO5jw6AzZhKy3bKbnQrgvqbgBl3W7AudpVLUU/FPVFtRSVABWzkvWbFqcmJwzOA0kBsrHeAC2n4jojUSZ8Qiy2/Zo3iKu+NkCIWtW/WK4kdQt4Slz3GisKH6OrfOXF6Ica6D1AajRt2oLbSoXk/DIY2vJcxoniFyJQ086rFQXpzGVaYhIKuYPdCpxqzrvbGGPj+BITn6FPcKBL9gAecERs4AtzKtZWPdt9aX7ZGxZ46VJu91xOmNt0pIreJTTVkZVnJYUYPKHV78p5m+hbBPDZBVNv9XST8TCoKTWpQ/wFKic89adIv4Mbr65cEHbWgxmYc85mnM75b1Um32ErQ5Kmb8xz0qy7O4gnaRo/KSQnIY8Q8W6yBz254wIBkcdvQBRM9/TkcaYP54gzLJFt648mXMgozMAf404KFLCUNcSTEsSJzzL3ioymDCFcLiozXYdOyikk8EhlRFLYoyCo/phUS4HXcfft2MBVf5lqaJ7fwF3+KSodXHf0Edtp45DgAuCQqcKpmn1DRXS/JfaVZdOVNnF7/Wtkq+4y6MydWMp9Q1NM4RNYDLZUQKL+cuGKlEwFgIHck3BWrwVQFPmHNCLXrVRNsl/BALNEQJN1ZPh93HLUry8bm1IXTOAbD/S9Pn34TJlVZCo9u6CNfXRsSWgt0S9qLTMOETDZ4BW3bH6lczT1hXcY7Xuylo3A2Wre4feFLtRN9Yi1M7LEqZak18a2BqDBN0ndtety5aQbGqIkal/7JnFJMjCqPgntpwSuABSpa5u7ihrVITqfaAFVu20NFNGIUA0loE7MAUggxQY+cGa05q3p81Loxr7lCfBJ7hUonMWdPvza5TKqDZ5BmvLkb5g4JyJ3PYSvi+ZJuU4w0Nz0OTeMiXvLQr5wOjCFtF1l/qWHXeoT+Ln+8tLpEAftoYQcxboJVL/vFeSKETv9oMXvp/NzzGdw3/W9
 peZBVMlW
 /p9ySFfH1p3eyPkOt9OsoeQAIK0XbPVQit2QsjvnYn8T+zIfmwhAMm3hRx6csmeCsavhDK4CeGgcofdkpskfu4yw+qLZiOktFSrxFftIzjKBcnt/c2iUS0xfkTj8IMFc4wUBQmy4Xbbrq8ZNPCLzC2SZfkGPiqbVzlDQWUixB0d/agvA6OLZ+2yheeurgNeSFaNvTIJ+lrKyAAkTLD/3EIxdfnL3cK1j4GBklX8mqb4wO8yjod5l7CY0/yzTTGoPNuQEoxBqcQQ9Goct3zOAtlMAQhAXfwoxrz2Gosi5s5YSDdlGAdfbPht+78ZPyjHX55dpTz54BLUTlFab0rfipbQeDsIFSMrMk9/b3OiZlOxg0JxE9DUehRZHZMmoCYe627f/osso37JU1D61lnAIAoq/kpsMZPDnwW/4EH7pb3+Cr1dnAuQnxWDQPWv4DFXISUFINrNknUXozSPXGNfu4+4g9pdrNPNsUP9CwQyQKupiOnBOg8zcCWGGDkdKBxj7h4hYHzyjyN7lZhTlJnqHXBcYjDNAMsh/WfBpOiIIGoOtqYCnb9eRaRX62RIVQnj3v4UOC4wlnQTdycybQAa8HE19A5shlrapMmx2V0BWyGrB9Oyy9pTu73ktbwXER2eBKnOqAk+dcAdjHoYGNZp2hXWlEOsJgAZf4crTlf/w4sgQjWIk5Ajl+Vl8Y8kZByz4So/YJ5cEYEDQdBlT4tPTatECFUlBCY/WPKHcY2cmahR0gEnsZaE8rEtWB9heUuD1rkPRPkkPrsDHokRAvYasm/+l7w5eLkbC4/4lgHruc7zq3XUIU4fAfx5V6ljHXlu9bT8hXj3oXb5eVnwTBAl3hSmJC0OJL/rcEmQxFJv5gOsKe+FeHxEtvL1bjZkwyAN0yTVhDxtTE/NH7af1ycO/l3n8DIR4lD5ml+cOcR3tqaExPlGg5p21isaLIx1JwJUVHgrzACe2Bdk0fSHn+5atyR65pBdFd
 24e+lvwN
 VF5Mxngn7JmpIy9N9pr6qzaOitVt8FNmnAjh4ghWP2I=
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


