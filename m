Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9617CCC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F303D6B0093; Thu,  2 Apr 2026 03:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F079B6B0095; Thu,  2 Apr 2026 03:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E448D6B0096; Thu,  2 Apr 2026 03:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1F9D6B0093
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:18:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A38E5B9B4E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:18:17 +0000 (UTC)
X-FDA: 84612762234.19.97502B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 12618C0008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:18:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5ZOSZxh;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775114296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3J29eyN6EnM5cw8jqpmdLY+onohMKuW8yDrAKoiwFwE=;
	b=GE3CuXPHbXyj1n70ozg+178lc+OJiEkkKZK23u0qn+hzQABw3HRkfs3VUyRS4N7IyAwm7R
	ur9EdGCXz7U5nR8OXzKdNBQQIgEcW/0Aj0lvGbfWECgBxxPGicEAco2+2TtG0gtcdnLaqD
	CY5bY1KKzcuMIHXqrB3qDQGreIZneZU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5ZOSZxh;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775114296; a=rsa-sha256;
	cv=none;
	b=2Phxajhgyntr8nQi2EuxDw/GKoE3RMV/Wa+St1xSk+Yhu89Hw4AHPJaqFdM1nnqjwRFW7M
	JMeZ6ODfv6c2DaxwYRUkmutzzTAhlWOpDzsWh3UQCaE58ly5NxJrCI7u1Bb2Lxw8SD7/g3
	M32ndJqu8zJZfdmaaGJRe4js1epIbco=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F14161855;
	Thu,  2 Apr 2026 07:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6A1C19423;
	Thu,  2 Apr 2026 07:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775114294;
	bh=fy7UMXiTtfEMvHGT15AdWnHodjKCat8W/RCBGjMJU0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5ZOSZxhqKvdMeH3P6ArEwlNL7hRDgNzvHh7o5NVZ7IRUdm/vwo20hy3ZY1xelnl/
	 VUBvmgMcHAk/0d8zlgdVYX0fIDpXf4OQK1f/wzSxp8mIp+KiiO2a5shfPAr6EaaS99
	 lYnO3+0gv4cVCQyElxFqB1unoRFrj9GLMtjCIqexnXDR9D83xFWqHG4InuPE4EBMls
	 SBNcFBavPPLfpcZIZmPdXgheiXjwDofF6JZk01Xj4F+rfF3lDU6Kr6taSN7cO/CYZs
	 lnkoL0I1jUuxycEsBIvO8h6pUzx+xf/Yg5gIK057LK+LCv4rFWt3vqQiPKZZUnHXbS
	 xyNwuCoh92pwQ==
From: Barry Song <baohua@kernel.org>
To: zhanghongru06@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	weixugc@google.com,
	yuanchu@google.com,
	zhanghongru@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator and optimize pagetypeinfo access
Date: Thu,  2 Apr 2026 15:18:08 +0800
Message-Id: <20260402071808.41828-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <cover.1764297987.git.zhanghongru@xiaomi.com>
References: <cover.1764297987.git.zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 12618C0008
X-Stat-Signature: y55bjftk6nkauxkepa9efqd5mz6bs7r8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775114295-112447
X-HE-Meta: U2FsdGVkX18ky1s2e0/+TcdGlUu6lDO0yI17ZwC0KpXi9QIwtZS5f6jSp9cJq4UQTRvwyYZtUYr/XablF6enBoyROwuMoU0YJId3sxjXevZwZhJJg6ZEYZu1RlX7huDOW4br7t7QlE83rXJi0xkpgJ1qnosrA0gwa0eUN1uwzLbpsgIZUld6etw54yIUkWvve4i5asOIJrCMlPys5T1QZxN57ePExLIiujQ+7n7PxUsqUFHMNwvkBFEIRUBMT7M6kmCLZsF1e4cS9i/bRk9ZOPygWJVEyThEL8If6jn5owqlU68k0xfB6U+iJu1qbLRxSNxrZ9AJoZ8IOeKdYwL8b76OF/U0cmfsT3I4gihJrbOj/CIsOHXdopmPBas8U8K6vw0gPwRT2VQHQg2pb+akbGGOoTPfUFgRgOX6jAJPsq7JZSHYELhhTDkmJfHgdXthrkPpM2X6H8d91x788yV7xJmcUpGygmVAVKRJxoSGJ7HxHGb5sTmP+bXoHrbhJnXmbKMmpOrm06FRzPtMWQlbrb91KrCEaguTXUfJD1iaFyQP4Iyg7U1qVoBgYstNNLHVnwtkX4k3gzDXlVU8+SKiP4znKFaQWD2oQbwEshrrq6NHBJ9Lzsy+IkWDkSpGE/dbAO9aJoOHm6H3/UVabYL2VE8Ao6SAJJUk3Sc5bBGb7h7k/f7nDnKBeOqBHO72HvxpF026gw/lZSQonreNb3rXJV5OKIt70JWqbTNQy99QP88ZbA8loARQ+o5uqpdmYRULVkk4EWgg1jxQ25csNw5sTVTn9OsoSkkR+ZLGOo/l9c315+IT8/9K0jgm108JTr+hPYlZDW8EsIVr6jtcH7B0wkPSmtenH50FeoBF09m3ec9KJyBSIzgIo7iwXw+TIBr8Jo3EjmE4g01GSQOOJN1naTkjB6P/xBDVOP+nxfOtPdCtH4i0pNUFb9Efktp/f6FXXnjfZ4VZyQMaXr3Oc78
 zo42Fdlh
 XZXJTFisEVZEsO0pOltZKBqj4JNXWbAtaTQxaXrmEL4s3sBvCf8/fMvgh8bSUFbVwqXRldiLdF7w/m0PuPqFl8+9W/XD9odkUml8dqTLfkSOOFCCYRb/qAELv48YFTsmQdPj2jwQZF+mFsu6pV+SgNx/9pBgYvPxVA7gtOLR+dYpo2wPxvW1p0qI81Dpw3KL5ZNKtTynfNGItcJKeiMh+OlyH4eukIKdyxndX07oWIAqFNsOtOhMtoq+9mPlHLb33fGIxKyW3T0JavNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 11:11 AM Hongru Zhang <zhanghongru06@gmail.com> wrote:
>
> On mobile devices, some user-space memory management components check
> memory pressure and fragmentation status periodically or via PSI, and
> take actions such as killing processes or performing memory compaction
> based on this information.
>
> Under high load scenarios, reading /proc/pagetypeinfo causes memory
> management components or memory allocation/free paths to be blocked
> for extended periods waiting for the zone lock, leading to the following
> issues:
> 1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on Qcom
>    8750 platforms, reducing system real-time performance
> 2. Memory management components being blocked for extended periods,
>    preventing rapid acquisition of memory fragmentation information for
>    critical memory management decisions and actions
> 3. Increased latency in memory allocation and free paths due to prolonged
>    zone lock contention

Do you have an idea how long each seq_printf call takes?

Assuming seq_printf is costly, printing while holding
zone->lock may be suboptimal. A further optimization might be:

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2370c6fb1fcd..f501ca2840a6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1570,6 +1570,7 @@ static int frag_show(struct seq_file *m, void *arg)
 	return 0;
 }
 
+#if 0
 static void pagetypeinfo_showfree_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone)
 {
@@ -1611,6 +1612,63 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
 		seq_putc(m, '\n');
 	}
 }
+#endif
+
+static void pagetypeinfo_showfree_print(struct seq_file *m,
+					pg_data_t *pgdat,
+					struct zone *zone)
+{
+	unsigned long freecounts[MIGRATE_TYPES][NR_PAGE_ORDERS] = { 0 };
+	bool overflow[MIGRATE_TYPES][NR_PAGE_ORDERS] = { 0 };
+	int order, mtype;
+
+	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
+		for (order = 0; order < NR_PAGE_ORDERS; ++order) {
+			struct free_area *area;
+			struct list_head *curr;
+			unsigned long freecount = 0;
+
+			area = &zone->free_area[order];
+
+			list_for_each(curr, &area->free_list[mtype]) {
+				/*
+				 * Cap the free_list iteration because it might
+				 * be really large and we are under a spinlock
+				 * so a long time spent here could trigger a
+				 * hard lockup detector. Anyway this is a
+				 * debugging tool so knowing there is a handful
+				 * of pages of this order should be more than
+				 * sufficient.
+				 */
+				if (++freecount >= 100000) {
+					overflow[mtype][order] = true;
+					break;
+				}
+			}
+			freecounts[mtype][order] = freecount;
+			spin_unlock_irq(&zone->lock);
+			cond_resched();
+			spin_lock_irq(&zone->lock);
+		}
+	}
+
+	/* printing completely outside the lock */
+	spin_unlock_irq(&zone->lock);
+	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
+		seq_printf(m, "Node %4d, zone %8s, type %12s ",
+			   pgdat->node_id,
+			   zone->name,
+			   migratetype_names[mtype]);
+
+		for (order = 0; order < NR_PAGE_ORDERS; ++order) {
+			seq_printf(m, "%s%6lu ",
+				   overflow[mtype][order] ? ">" : "",
+				   freecounts[mtype][order]);
+		}
+		seq_putc(m, '\n');
+	}
+	spin_lock_irq(&zone->lock);
+}
 
 /* Print out the free pages at each order for each migratetype */
 static void pagetypeinfo_showfree(struct seq_file *m, void *arg)

Thanks
Barry

