Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0546C44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:37:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5576B0137; Thu, 16 Jul 2026 11:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E996B013A; Thu, 16 Jul 2026 11:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E01B6B013B; Thu, 16 Jul 2026 11:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5656B0137
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:37:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E72D4010C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:57:48 +0000 (UTC)
X-FDA: 84994490616.19.916CE89
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6FCFE1C0009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:57:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HchRbsDx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784203066;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7BZuoI307tBezRmKGV6QjCvxEl1tGf+05F5S3uKZHA=;
	b=I6YXKGT8wVhKvT+R/HVdYxht9QP+/znkcwHyNcQOb3QuydUw8OJu7cYVSUiJn+ctHxlaOA
	+iZmWKYeoX5z084Tl4jxZ5rpCOxGKoO/YmrDNNCOwlV0mAOkhr/07RGPK4sFSx5M3nmerU
	+AbX7OFt5RJUWVCD2vosqj7HKOVuqHw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HchRbsDx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of gaikwad.dcg@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=gaikwad.dcg@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784203066;
	b=rIVjf6tvKA4JxBk1Xd+0qkrXUW9951I9jLTwr+zl/ETJUssW/m7KwP2JDmm2knIM6U40Yz
	UUmIJxjuWiWRGWxTxigskTF/1+5I1XEHF7uLQLRsovK4k6L/Vwj7YvtCDDIow2OQxUS8qI
	F+iwbAF5CsCc3q0G1UDMvi3izwg3vjA=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38de840f2f0so3353826a91.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 04:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784203065; x=1784807865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T7BZuoI307tBezRmKGV6QjCvxEl1tGf+05F5S3uKZHA=;
        b=HchRbsDx+0abYFhA+oFGDD0+zQYSsp9V9KapoUVAYdMKUI1gWf9aVL6FArtd95bGzE
         DvzBG2QVj8Y5uCnjCeFkw3PdIF25ZLg444T0uowRCyR5E/1Loggd06E4GfktU/gyKQkU
         ttSSuQ1wJX/+YnQy5uI+05jh43ji++yXew7+qvFv37tKKycOsaKfzeA9RbLiCw9Mxknj
         4Ie+sniE+PnDYjnok7yF97IsBwk3hEQQiPyAjJYS9tYk9kTQAj/O4XQxXJTkj9g+m0+p
         inQ59oEkaBQ4idrhZxdhfAnOGn18hE/QdF4+v85xbc3/AFnMwGQ+FlUAd6zxCHAEKLEm
         wNYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784203065; x=1784807865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:sender:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T7BZuoI307tBezRmKGV6QjCvxEl1tGf+05F5S3uKZHA=;
        b=QpIdrDk/Rb+qxcOMYB5T8Hg9WUK7Jk/pH/noo0kArMBQB+LcyWm++UvRE9CyWvP++G
         3AnlJH/1CkakMUT1aOEmGqWcFYHNT+ZH6LlaWmz1jLrq0j02DB8jKfi1lXWPIQzwlug7
         P+SYqBUf7NHNxgoR+M1j8KO2pSKTM6C2SneB+fh9XTYta044HUFQxCQbH49VvpfwaWno
         x8u0sPU4gM+YdwP/2tmIvJK8r3e5VgvrPOt9Cx6iIjnE+GD7fV1yMxE5hpnbaF5+0gZB
         ozAj6SOnLiPR1jSImdq9WZwbQoZ9Ltkga0kfhnad7xRgvZ+2MBxXtTNuovy4D1DS0yvP
         XS/w==
X-Forwarded-Encrypted: i=1; AHgh+RoxGDuZ8QcBewkkrCAizQUWJdp0BrJ7BiV43F1+MELKbRNYPtfKZW9yplAllsQISYJT98btlidBAQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4pGxVZDe0Jaoo0oSFVrU7lWZxBxCdYiHZQeWwVVrfoRChVOM3
	MA+5bDmxhLwq2h2TcufrauI4wk6by8uaXrbtQGnpISICCkZzqo0vLExM
X-Gm-Gg: AfdE7cnA7yXzrtrvvr6uA2vjvggxDk4cU5R5+b4WL61/CLIJ3WL5ZjsfCqyfRuLPuBK
	nsl3TnfeAPvJJ11sX8POTdy1BL7rXH2oMgDxnPmaTh4DB63x2TGdv0X8n7HICVo5NkDCg+TrqBN
	igayZxRwIyhKkC+CI0HY1+ZGSm7hxvB/45x3y9uCxMo+/1mYpEppN0J3Im/gXU6TNUu66HR1KCl
	Gnq1FCA7X8xgy5NXRO+cI4XP+tuIxk+JFghILazx1EDcna82W2/pQS1B6ZtGfvWy0TdL07GfyHg
	P0csK4q5Sbvr6BWDQDMoK+o/t4fDjlFy1a3bFs+AlrEuElZW27EDIPYa553jG/dbGq1WOqmHuWm
	Z4ahQLkzSP1bKS4jf3uQlI+X6GlAdbI00ocW4I2zjjkkGQKa4xX3o58wpoZzIxyRP4p/RVBHZrs
	X2Ajr21K+LMLX1obNSW31LOYKl/Ac/lh6J6TmmRGCl
X-Received: by 2002:a17:90b:2f8b:b0:382:3dcc:1487 with SMTP id 98e67ed59e1d1-38dc7b3f5demr19684631a91.25.1784203065127;
        Thu, 16 Jul 2026 04:57:45 -0700 (PDT)
Received: from localhost.localdomain ([2406:7400:90:2db1:9c31:f107:8086:4204])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6ebe98sm10920690eec.26.2026.07.16.04.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 04:57:44 -0700 (PDT)
From: deepakroag <gaikwad.dcg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] feat: scale vmpressure window with machine size
Date: Thu, 16 Jul 2026 17:27:30 +0530
Message-ID: <20260716115734.80909-2-gaikwad.dcg@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716115734.80909-1-gaikwad.dcg@gmail.com>
References: <20260716115734.80909-1-gaikwad.dcg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ejdtu6r4xnsq1seoicz6fbrd7jsqydpp
X-Rspamd-Queue-Id: 6FCFE1C0009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784203066-728921
X-HE-Meta: U2FsdGVkX18ITgrcGgXz78/7VzVVt4rSuBxErF2qDxYeKCjneQ9fWvXQQmJmHSCf3O5StSVL23WOAkxBGedteaQQEgGkmCmJnJRnQAdKexrZZJgIi2QuwqjtXzvrYTxQ7iWk0rIbUQaYDPlwrdMk16QHAFFfUqZsXN5C1q6pu7/PH3vSIR5h+2RBR+vOpSVocY48gWuXedsKGnYGXcFaLFWHGuDl6vRs09lNQc2MZHzHCHKMh37Sr1LnwtJAagdXIql5B1tDLnBEqeE8XH5QRi/inbUerEbtHmhkQ6JVyKULO6xlftRcvcFqEQpfx2BNcho3hk37ELTbgKzapySPAsI3+/wNzgYGPqHE/TSgVZ3v/LWWuwpKwPl1YaJbklWKa0+ooJBFr2LCc0wQTaq0BKFL4C1fQ3ovB9nrxVuPQkZDPxpUT3i46AtbXepc4aWPhskJ4S3zdH/ynKyuG/xkjN714fTlwBtH74D8aJQNztJ1CpnWOY4W9cQQMJXw9XClWL0Ovo/C5y/7f6ffwKIFBUntpEyXJskQPXft/EJOMyivVm2MeaNQlCeHPhcG9yQyNToOUKJM5K7y982JY8kALo4kN8t+ef6UBBCp7A9DRsdRXmy7i38+x3pGKcVLXv78iKJCveUykx1rNVUP4PMZ4/FJvv3h9dLO7Sxb0yBPXfzh+HrIDGG8IGPKDL3ok5QKeVr6zH67It1DY8T3B2GP0e8k6eFY7pPJ4++Ab+3HrwhtowjLJAIqHRvfu4fAMsWLdyVjV0vh0LivyF3kdz3x3zQXGjCroi1aVXf6ZmQz1UNkq8EgUsANrrtlGzKZP/eIzdRReqt6F1QDqwm6LBlrTTA5PqaJC655C3q0dJ2KqrgguADonvoZnhT7BfQvkD1Dp3LOPclB5jh6gkw+taueVljpghLcCTqAT+zvDXqkR+J43DIEPPlgKq0Zu2gcbEBGj1B61MvqLQEZ8yD0keq
 wKvtrnxP
 FaYJPror1OJem4IWxVosv0EMUzBXVlsSMCk6+joTrtwUbZwX5cpvMKFHsNP2PE3cso693nKYlrFq00zkUnlyPrP35Ee7kPC9Nqp48O54VV/kYcjDW+7tLZItINetTjry0vTjMPhoGQ+5be/fAADYc5/Vr+TydY934O72Ax/IGTddTIHaeUG2vsrypUVZvz4pgOPWv8G2TC7HpbDbDW9DGESZsW4HHJSvNCz25M+GTYesFiU/Ey3exlfQMG0HojzoyeflH3Xxlmm990aE+TBIHd4mEbvr95tdpaGKY5iqFiwgELP1mcU65aZv4j8NEUmdDUjy0QJIv4joGuLtwE5I6d/WlGdTXlCSelJva36GnVXzMuUCP797xHjTQ0RJyZxVvDADo1vlM/aDCgJEU5JxLjlTMIN1KOgv+p7SbG4bhj+4c64c5DHp1Vy0UMF0xTWlXz1fw1Rvlu5GbH40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the fixed 512-page vmpressure window with a boot-time value
derived from total memory and CPU count, clamped between 128 and 2048 pages.

Signed-off-by: deepakroag <gaikwad.dcg@gmail.com>
---
 mm/vmpressure.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index f053554e5..8925d4ad3 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -33,9 +33,29 @@
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
  * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * thresholds. Scales with CPU count and total memory at boot.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
+
+static unsigned long __init vmpressure_window_size(void)
+{
+	unsigned long win;
+	int mem;
+
+	mem = totalram_pages() >> (27 - PAGE_SHIFT);
+	win = SWAP_CLUSTER_MAX * (unsigned long)fls(num_online_cpus()) *
+	      (1 + fls(mem));
+	win = max(win, SWAP_CLUSTER_MAX * 4UL);
+	win = min(win, SWAP_CLUSTER_MAX * 64UL);
+	return win;
+}
+
+static int __init vmpressure_win_init(void)
+{
+	vmpressure_win = vmpressure_window_size();
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
Deepak Rao Gaikwad


