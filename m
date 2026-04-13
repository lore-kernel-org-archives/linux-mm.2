Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC01F34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1516B008A; Mon, 13 Apr 2026 09:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C9A6B0095; Mon, 13 Apr 2026 09:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306FD6B0096; Mon, 13 Apr 2026 09:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2036B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:27:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACABF56241
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:27:05 +0000 (UTC)
X-FDA: 84653608410.16.1FFF39C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id D77551C0007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:27:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=SegWXM+3
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776086824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ts5NH0xUvZdmVlkgq9z2yi5cSaxNAbH4JcbwnyOwfPI=;
	b=qjtlQWzhHXM+3iZRqCEG0/ARZfkkgih8WZU0Yfntc2UuIK1p09XJAyVe54ea8Zh7hBes6y
	Lr6vztYY0gsiE7/X0+WFdLJ8KpzhdR6GKm29Wy4p1IC8/FfppjxB1NeHJAI5YKbAg+i2Xl
	g9x1QGse55eXUO3sT3/Y44fubE1qNxo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=SegWXM+3;
	spf=none (imf18.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776086824; a=rsa-sha256;
	cv=none;
	b=JuzvETOWYEpGjjpQjkTrwMo4S5G9DYO2uinK5C/XM7VLNB5OKJ8vsm+HPMRoQY7jTotPwt
	JKmT2Sne5xcaS//sISSNMGJxK8ccs46RZfnQh8+Aw3OWxw8atfikZMkxSTXFCdLHcbyG7o
	NRb1lkfLPeYZCJRTJV3iP7vbLXPGETg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Ts5NH0xUvZdmVlkgq9z2yi5cSaxNAbH4JcbwnyOwfPI=; b=SegWXM+33+iQB4lzbciiQtJfqE
	y9zWi3WdYV5DpEeTro/sk84OUYQNQVXiNyWsbRLqt2/N/CcK9paVcPJMRqKbsthaKoz/3+sb9beNI
	32BB5VuwvDNg5IYdhiB8D4GkP6b0PVIVf9kgcd6j2pdv3fhtNe2llJUC/6GN7RNCqkimqw2o/+OeO
	NKNCv7SIBZFbG4myyCZ+8dlwRID4SOHvnyI/s6P5IIpZ5dIjaQ6vtfYmLu3p/zCz8QvhgJkLoeZ26
	KAkWfydAemXmFix9QXWrfWTCDPRnQZPYlEXq2vOUFVXsCPo8VrviOsUf/V66pCLP6SgF1rjhYamtx
	Gh5qEKDQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCHJQ-00CKEQ-2C;
	Mon, 13 Apr 2026 13:26:48 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Apr 2026 06:26:33 -0700
Subject: [PATCH v3 1/3] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-ecc_panic-v3-1-1dcbb2f12bc4@debian.org>
References: <20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org>
In-Reply-To: <20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3839; i=leitao@debian.org;
 h=from:subject:message-id; bh=5kticVozScC6u8qmLk9+hhZd71yiocm3BKCHqXfpTvc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp3O8OGjMhJ00sPwi1tkdTGacpr0NdoWmXFCwqB
 fETGcica/uJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadzvDgAKCRA1o5Of/Hh3
 bTMOEACDVZS/51etxbpUL7Fkz6ajXdmMgOGgxmuNv7buSOZbViDuCi1ds2F/1rXwxwpxHG83XA3
 KYdFSDzqS9bqK17+lFSC4W7hfOXqLUID2NYoVCuvKScI1sk6JL9UHn8Q8mQFh7ohtfQgnYRJd/p
 VSDvW4wpIgX8+UavBQCvtRr5QIaH2zAhJD6DD6OUBQyn8/l4LSFOfVZHtEiCkOJO2xB8HrHDtM1
 UHQMlsndcKtDtErSj1OJlbqmy19xM/jD2HOf9zWN4RsGGOgz97uhbFYRHzb1ZgKdPagi+4Wm3v1
 R4SYPz6OHHtb+orElndz4KXEwwozJA5N8Msh+7efgPPho7Jpxxl789+XZVNVEiXfpOzqMSRVZD3
 DdnbIlV4hNrspnEz4iBuzVy9p5xJxn4yPSi4fmudxWGxon8iLyvzYdwGDhXi8kW5xzRvAh03Gry
 pttT2Vl7BcM81su4p1IOFRkj/WrBpcdWJOXhy4yzxkbHIEwYIHNldDBO5QRiRvm7zcGmY0R024/
 70ETzBG98+7b2FHdnFxlg7HzcOw9SRPCfF+ODwTOYVoEn0twZKFTT1GOqqLlvVKEcPVAlloxV/G
 OJfI0egBuyqFiBQIx8+pdyhjLqBKL/oY3hldDPmapM2IONXLZpO1kjwarMk4T8KCFQKbhTf58Sv
 ET1F4s/x9fIsJGg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: qhh9urkunao1bd61beiaj5h1r48fogts
X-Rspamd-Queue-Id: D77551C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1776086823-351862
X-HE-Meta: U2FsdGVkX19BiPTQJc3DEPFyHl5UuOc9SaUjgp4NIlIR+yuprmo6BrDyjesrp5Eks/je6ZU06lao2xcrcEqcJktGqjzDl/3c0ynQkj+zoHAlihh8SO4PoXB7FbpogZ2smhF7EbIwv/0M/Io7gCmSjZ+1O6Ln6YvkLJZqoS3jgXo2oNi8sqo1XnMhX4vGhtNg72It8/ubHbyN+WoUJNIIjyor+DIE36+9Jfiq9OPA9xqmQgdV4chRHFvMiOpG66gcRnJwbTJPYg9gk9DKDu79ayCe6qNpZ5bGeqR/18rK/aXwmGYOLa/QJhu6WYEZzBlddItO3+ztqe0RtrhKTkDDvnJYjmWmgiWkinc5zuWVAO45GNS/58EB/m8vjA0/kpJ6jIxoRtQ0xJLC5PlpmVhRBbxiQFc8pqEbcQ9/PsxJvoYQ/Y/pabIQQeL1LyzMD85vvpCzKTR7Awb90Tx8Nlov4f33CGHIWT/rOaKhnWSc4yOulqlnt1jRTL05hvIHuip1kTZ6ozosY36X1gYgvE+pGkCZg1HaAB9YugpqGeLDSslQkjcUxVZDeXEBs1WFqN/DlvZsrPgnRpctFltypRJ27x/8PLGEGr7Ag6lyb1sgbjyjoBlgBGNJRuN0oZDx48crkot+1+yvNKU8Xl8zcR0bJ+cU/74NucIo5T0r7fxwSM4YnvjyonOFV2ttHp//FUeD9YJdgTNGm083AF1LxEL0sGqWc95KDpcB/YxtcBaPbIc+Jh+aw++WpW6+8aSBrsBNZlbkFXeergZPlczSxsbeqrTB75VT1gwqv3HLg8jOyLrjMJDdgER+6+hpNUW7TanVZSaXZH7KEbz4ETRZT2/mdsHDFwsqWxBqUwWFkgA6mprYLXrM+uI0mqb6o89pwPhMCPHveiCbvbmqSWNFVplFTLN4aTEhOk2HJL8AhYLr3Z95ll5we8VqbtZdny2uaD64NeG3M2sT2FKT1PXUzz0
 Zan6xhiO
 cEybyu7EWUF0BP8aJXAOczA4MP2UNN5n2a6L2mXxOsnYVbNt5wmqSDBADoijtSTlEKiuBeSc6mqZhz5YP7+K32ogKXgwTNmqQSgn/GUSWgHDKlbTJKTun0vY6yiJbC5bJvRgQsisPaHqHkdu6pC46uyEeTCqvVJBzRlmVS72ZSSadyIYBdfDeDtCs+MYrjkC0VqbAPvVS0Usq1SVDtCm3Mxh9+yyr6nxbhn6a+ZSg8/20VoA73Gyztd89dVUQMMh7krVOLd0hqud0uUpDvjDRdTBVGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When get_hwpoison_page() returns a negative value, distinguish
reserved pages from other failure cases by reporting MF_MSG_KERNEL
instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
and should be classified accordingly for proper handling by the
panic_on_unrecoverable_memory_failure mechanism.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d43613097..852c595aff108 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };
 
@@ -1281,6 +1292,35 @@ static void update_per_node_mf_stats(unsigned long pfn,
 	++mf_stats->total;
 }
 
+/*
+ * Determine whether to panic on an unrecoverable memory failure.
+ *
+ * Design rationale: This design opts for immediate panic on kernel memory
+ * failures, capturing clean crashes other than random crashes on MF_IGNORED pages
+ *
+ * This panics on three categories of failures:
+ * - MF_MSG_KERNEL: Reserved pages that cannot be recovered
+ * - MF_MSG_KERNEL_HIGH_ORDER: High-order kernel pages that cannot be recovered
+ * - MF_MSG_UNKNOWN: Pages with unknown state that cannot be classified as recoverable
+ * - and the page is not being recovered (result = MF_IGNORED)
+ *
+ * Note: Transient races are mitigated by memory_failure()'s retry mechanism.
+ * When a buddy allocator race is detected (take_page_off_buddy() fails), the
+ * code clears PageHWPoison and retries the entire memory_failure() flow,
+ * allowing pages to be properly reclassified with updated flags. This ensures
+ * that false posiotives are not misclassified as unrecoverable.
+ *
+ */
+static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
+				       enum mf_result result)
+{
+	return sysctl_panic_on_unrecoverable_mf &&
+	       result == MF_IGNORED &&
+	       (type == MF_MSG_KERNEL ||
+		type == MF_MSG_KERNEL_HIGH_ORDER ||
+		type == MF_MSG_UNKNOWN);
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1298,6 +1338,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (panic_on_unrecoverable_mf(type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 
@@ -2432,7 +2475,11 @@ int memory_failure(unsigned long pfn, int flags)
 		}
 		goto unlock_mutex;
 	} else if (res < 0) {
-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		if (PageReserved(p))
+			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		else
+			res = action_result(pfn, MF_MSG_GET_HWPOISON,
+					    MF_IGNORED);
 		goto unlock_mutex;
 	}
 

-- 
2.52.0


