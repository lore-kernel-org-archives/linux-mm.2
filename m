Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43F2AC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50FE96B00A0; Sat, 29 Aug 2026 03:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7796B00A1; Sat, 29 Aug 2026 03:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE1B6B00A2; Sat, 29 Aug 2026 03:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C07F6B00A0
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:47:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6FBA16062A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:46 +0000 (UTC)
X-FDA: 85153527732.11.4F9F6D5
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id DDF1A40004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:47:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ShKWndHV;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989664;
	b=XSJsMhh48SsfQBrpkxf5HsskGZ7zCwHUBQWo1OEChVSMX6CUkcHPdjUjp7IbS8rp/3/5fJ
	oq+TCCmtxqxS8TvvmYuaF+4mWYcoE7VgjmECLFRFxGjnd6dBHPVQnb3Oi/MsbgE4UNbC1h
	9kInB3GTDY02mAmnoUCGCRttc7407rI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWn6EGMddmTMon7V+5jiUnHk1hdkEvtDIqVtgSXnKtY=;
	b=od90I5Wow1B0XGg8wbTRmyQw0bE+rpY1yju2uDlHHGb/gF4Kn6iaLaJGtpYctoBSmzw0OX
	Q58kOw5AyEIbdq6tiCULQqxDrxvKeQxSPn2MSHZEfVyvEsHiITr02EJFYhz4EXeetRGPAN
	xqGcQuAlLWzDEiyKlQr7aeCwKCwBCq4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ShKWndHV;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2d6f55a7089so17093915ad.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989664; x=1788594464; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iWn6EGMddmTMon7V+5jiUnHk1hdkEvtDIqVtgSXnKtY=;
        b=ShKWndHVv4ZRjxhIS83heTpsbkawUC98xkasIUfoUuH5vohZEQxKB2QLKBWCND96ns
         yP6hCINNbVKr1jdB1u2gPaam5xG1spVYY/u1sraReICYv8AZiqnXpv/mzGB9kF/kZedl
         IgyVRBUBDkdOUaO56MZ6Mw2/SuIGxEADGO7HUyjsikbn8SAdX6XyxpItjV9uXYUGCb76
         xXN3l7t0CctYl/7ZKix2W1SWzvHkWiuq7J7Hl/8oi0ML4JumXRw16iI5HZu6XSqKxkX6
         uZvZSj/m/GQdavDePGTn/r2ltJLRHWfb4yz204zJA7MDazlR7+U2gX7oUiilFZzVBt2z
         ZB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989664; x=1788594464;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iWn6EGMddmTMon7V+5jiUnHk1hdkEvtDIqVtgSXnKtY=;
        b=sPvT2+pLLmm8QwEAMKmKUtxxl+lc8700DaWYaj4VxH6KldsDWidbuMMqMh7VV0F1En
         XTIZfiWuWJKw86CfTUL2W6Z75GuWJal0XvgK+BvVBKxoFsBlFXc5iRQcdpXt8wYfafju
         xWqwp8XKZG/bVyw+JM/9zIFa/nwR9D87gpuz3FgdUCPX3eQZ1AUfHUHUdB9c95S2mBt8
         FvR/I5Z2a2IHx/Q/mbUHnxcpVIbaVksW4z9jC2zLlN6G1ZgCUpjZBSW2jTlGeAJWq8Y4
         KJeCl3/nH6LctDqSZXHtaSSfjQzNbttI5/PShub9PXuwV9Lc0OqGBUCq3wPYXC1OG+As
         2fFQ==
X-Gm-Message-State: AFuF++nVS1EgHTjERaJ+CumcP/KpAJkRgf4/zgi3qRiRVKeYg+osX+zU
	TUF6Qc0boxM7BE40QAMyB14PiWNSjeEDMxAIqATmVGHJihEEtk8v75zIaDKWQg==
X-Gm-Gg: AYBFou1qzuPdYxxM0YCZm+P0L/vdIoOayn6HtjWkZtd6W6trVnoKEwca9yIHXpOFkbz
	ykTsEWRIz1jM+SJxRbRN32elaU9dXfFhWMKqoFmmlInkJv/dA7iEYHJc05mGF+bdM0ja0I4dpkt
	X8wrr1C9m3LnAu6gxwaEflB7ufY3+B7i4O4nIgIdTDr41cxG8vmT5pv7GOcpz0YPThrL9tJNBr9
	/11IVHnNeXVR5E0r/KfejE4LjnW8QL2E3DrMnrfo4sAKriTwyFZq+3kFTAecEiRjo8jIVdkiJ/C
	UbitSyED0hHl7gHznt+i4qp5gcII4yK0LVazDeSbtgbZXb45tBsfrLqQIj9XwDaUh54a/BD/jeJ
	V2jVSzCEfVhjGLvYY8g+E9TqWLoH/VB+Cbrn6ZVwivvFc+ZJpCkRvU/T9SzqMCRl4GMvx+s3NsU
	Fg92+1H/IM2X2JTUpxthvFGK03IFyvdMO7cwf+Le8T/99R5j6Gtm5BpExMAX20xpia1Rht25/0y
	rbmK++HaqGtvcC9qkXJuQnL2BKn
X-Received: by 2002:a17:902:e804:b0:2ce:9c48:22d3 with SMTP id d9443c01a7336-2d74df05f9cmr199834015ad.11.1787989663724;
        Sat, 29 Aug 2026 00:47:43 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75986aea3sm12686395ad.52.2026.08.29.00.47.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:47:43 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 06/13] mm/swap: remove swapon mutex and update proc reader
Date: Sat, 29 Aug 2026 15:47:35 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-6-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DDF1A40004
X-Stat-Signature: u4bq76auofx8pnimyq366i4kch9h38xy
X-HE-Tag: 1787989664-485770
X-HE-Meta: U2FsdGVkX19y6xUZdyUqe8AXUIkPQNDat7mdaeW3H2ZKRE75B7owx5Kbll6+eqkqG4pI64Pj7vbhXYifrFrVAYgN0pT6eiI0F9E9GJO102lPqG6zGJZ+wbPBbqPcLu2R7oKlS1SB6/XHU6wGTTbwtMDthHtLG/lMyS1LK6Okf/WjYHAnVEYsWxbs+xpbXB2qBiyEwPFBefvrvAvVMxi0CVTpUUld5ratBa1lDRBN/GOMohYmx36LTBi/udJVgzbb/ZgSxKx781BuRpKp+Q63RsOHOjwLpoGVw4VZq8CCI8n+vIoLq6z+rfsgAXLRdp9YIBnCPgAQMcBgpGphvhLVL4iMvUsjaOdXnyn3ZhrjhRaT+YH9o8ZbJT1j/ekJVFpKl6tAG2jtcFJoUfEZAwOMBl0QMNF/Y4Mhm9SgtD+KyzGrqM/SNKUpdG96cCOQ0HrGiQNYzhpheds7QdfoQuiodktKY162vNossJ7IhfUw6rNt3uZckwzx6yJytZpsmKkZMPorMl9/PbqXGiQ/ZmEB6e5XSrL4H9geac4lGb5MoHzmEzF7gGIicmVXnZYCRWAauiSU7ir2Y8DPN/qI3HbO4Z3e3IU59mJzkVEriFyEiUz7ZtVilHc9SaVOYjph9efAu3rGNW7gSTTkzHsKygHr7JAQf2ZMq9HokWCR8WaX7AyaJCjYKUcX8KI6sRwl0wLUaIBxKTOfpPqM7bVCRDpKd1Jqw+n17IHooylD0MO5XceSWB9Rn+ZfXPhzH7HDNYD59Co3RPTW1gabRmORKfzFeQ/tXLLk/QbO6y1oyK99k2OONJOETtXb46VzUlDt8O/5mMFQp4ObOX9K75RtsHBEgCzBAsPeMkNzTWK3Iza2GYOaJa5mfcffnVAVSKv+PwHu6uNVG7C2Hv5JfuuiqyxIm7eRdK8BfIjmapJX+nQXW/tdikjDsa8eEdNrBykG9aGtgxGyx8DcqzEGhyl8cBa
 M6OPGw32
 i93M5hFS4tKbRSYXWq8n3X9pineH8vaca7341bNjskdgKndmGScs8H8gJaOeanUtiCG8+I3QUQXI/A7OIM5d8XK2eG0jiRoSemrM41m3Inmofai96wIiCw/pw4zc4/nK4haIKkQg1ZJiFKnH9C5zqzcsUnrWR8aHIa+XiBywannCpbSPWUXduMFGpJIw13N2zIRhfA2CK7Zroyjw1tBZZrl/V99o2GFqkm5u3C+yykFODF5XXG0ASDwXxxru8KJCY5S4qCb/psF2fw/xU49XgPYuzmv0Ek4evITgISh9igIYv77ycve6hfkeIFm79XCpw54oAB1WZjlkBj2PMiCt2ujQxBzs1XP85EVvci5fFZj8ltCM3rEBIUITpNK6/ypCA4Ie0socqGoVCZtdgk3cPFWbqVjl+W62nFgsnlQvLDR5SfE7iQi1HcmHnidNnOQ22ff/31at5sKgMWzYM9SiRDnP/rV+e0n+uibba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now that swapon_rwsem protects all swapon/swapoff-sensitive data,
the old swapon_mutex is redundant.  Remove it and convert the
/proc/swaps seq_file reader to use the rwsem instead.  Also convert
the swap_start iterator to use for_each_swap() for consistency.

Also adapt swap_next, it needs an explicit SWP_USED check. swap_file is
not reliably protected by swapon_rwsem, so checking SWP_USED is more
accurate and stable for filtering in-use devices.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 mm/swapfile.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 173375a7a215..6809c099eecc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -140,9 +140,6 @@ static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 
 static struct kmem_cache *swap_table_cachep;
 
-/* Protects si->swap_file for /proc/swaps usage */
-static DEFINE_MUTEX(swapon_mutex);
-
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
 /* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event = ATOMIC_INIT(0);
@@ -3174,7 +3171,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (!(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
-	mutex_lock(&swapon_mutex);
 	percpu_down_write(&swapon_rwsem);
 	spin_lock(&p->lock);
 	drain_mmlist();
@@ -3189,7 +3185,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
-	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(cluster_info, maxpages);
@@ -3235,20 +3230,18 @@ static __poll_t swaps_poll(struct file *file, poll_table *wait)
 	return EPOLLIN | EPOLLRDNORM;
 }
 
-/* iterator */
 static void *swap_start(struct seq_file *swap, loff_t *pos)
 {
 	struct swap_info_struct *si;
-	int type;
 	loff_t l = *pos;
 
-	mutex_lock(&swapon_mutex);
+	percpu_down_read(&swapon_rwsem);
 
 	if (!l)
 		return SEQ_START_TOKEN;
 
-	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+	for_each_swap(si) {
+		if (!si->swap_file)
 			continue;
 		if (!--l)
 			return si;
@@ -3269,7 +3262,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->flags & SWP_USED) || !(si->swap_file))
 			continue;
 		return si;
 	}
@@ -3279,7 +3272,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 static void swap_stop(struct seq_file *swap, void *v)
 {
-	mutex_unlock(&swapon_mutex);
+	percpu_up_read(&swapon_rwsem);
 }
 
 static int swap_show(struct seq_file *swap, void *v)
@@ -3789,7 +3782,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto free_swap_zswap;
 	}
 
-	mutex_lock(&swapon_mutex);
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
@@ -3815,7 +3807,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		(si->flags & SWP_AREA_DISCARD) ? "s" : "",
 		(si->flags & SWP_PAGE_DISCARD) ? "c" : "");
 
-	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 
-- 
2.55.0


