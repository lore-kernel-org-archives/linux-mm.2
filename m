Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E1AF8D753
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089A76B008C; Thu, 16 Apr 2026 11:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2ECE6B0095; Thu, 16 Apr 2026 11:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D81476B008C; Thu, 16 Apr 2026 11:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDDA66B008C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:05:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7ED07BB35E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:38 +0000 (UTC)
X-FDA: 84664743156.07.9850BAC
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id C698E40013
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=g25MmI66;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxdOxmJ+WRA4zY3tyFP5+GgWLQ1rokSaYX9143EcXHM=;
	b=LcWQqQRSZhEJJ7AAzLdTQpdXwnY68f6gy3ZvBupj/QIt9lntPUDeRchu9B2Pz19nBIWvkN
	BDzuiB5JhoWc+Snqvj4V0OlFA3T9tebWXbMeDBmJuFzrSw4saiPgnp0oJS2tuaP0w6k36l
	ebRLKg32bRNSHS7pkHs1/nwPTbPEv7Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=g25MmI66;
	spf=pass (imf11.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351937; a=rsa-sha256;
	cv=none;
	b=N+5AJQnsvum6NFjz/7/NBhi4SpqGBqxg+IaspORwiPuh7NeLOLk4IwGhPYpf8HNssmx0Cl
	7aSSsgng/ofLIOGzTpzc09cBL6j7GVoOMaF7WNUgFEXjpCD3egCW+G/XiLIWt4moUKhfBl
	QhgdipegGRzC948fxRJF7fjmBuApuHg=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id CA14CC7436;
	Thu, 16 Apr 2026 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1776351935;
	bh=SxdOxmJ+WRA4zY3tyFP5+GgWLQ1rokSaYX9143EcXHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g25MmI66vUBAW4KYs4/9CBFni808tUOXGwO5XKl2afvEorbnC+VVk8HYxNqgK9xhe
	 PKqKaXoNJRC1TvUHf0+2HQfNbZcthJqfO6rAfZXgZsDigXRPcMWZ39kQZP817V29n6
	 cJgbX7tlPPqpCmTn1idFL9z8k/+jOfDtQZql/crM=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 1/7] tracing/lock: Remove unnecessary linux/sched.h include
Date: Thu, 16 Apr 2026 15:05:07 +0000
Message-ID: <a26a197ceafe0b80422f7daee7424457ab5632c6.1776350944.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776350944.git.d@ilvokhin.com>
References: <cover.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pzhunmhk3b5g5zowme4xck4khqc89u5b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C698E40013
X-HE-Tag: 1776351936-804548
X-HE-Meta: U2FsdGVkX1+4RMIjAuWZD+hNWv/2cEg35OeMTMy6a9+HEKoysbw5ff1qEzub2YV5e4wCWF/WxRH9imCbMJFx+q4BKKgU+TPTklvamESU1SBu/iFCItC1yooHwkoZ9hjVIFzebviKdJwi71W0AEVGpVoYbnCZErFW8enyi/D0zoX0naL4joC/kEFKxE9rkHSRtYc3+YZLiUB/GxQZmQom9OoA92ZhisYulLr4tLtTI4+PnDKpz+m3VulxuLgM+Q+KDU/FguZlXHNrrCJ+h7rb4NRKd3ztRb9nG99Ei5L9v43R75B9TAKfRtR0eksn+UdLVBfxUv+uhZL3R5JAGS1LAI7cDrVIVJ2M3tGT5J/oLaCnUuGwfPoC/Z7k9LZxQCJUORhMlPRSYoV1hNBAmRsPlWU/w7btFXj+jzEl644FEmWC2I4rdzIr81BrABTYqWIZC9q7+RyV+ZTBchmvOEHfffbkB9YI+qO0pE7B+of8GiU6h8nsCCwAjCXcfQitxBQOzOc79sD3TAhiTFD2P0L85lUCb+eVGVQ/AlaAkR6NVaXm0F8KXlvWfiG2oRgx/Ei5MSnBYbH9oVoAZeyLBOn3BgZvKaTXhjE5lTeItCrEeCty+snWJdnLrdJrtF7MGBRwlmcLl8CjePqGWehumHEgGY59ch5R/Ta0eXrhu7Z3hleGFc4BQS4EjDRu/yfwFCgImpMKS04BANTZ3dh+Hpkx+3bNZOFN8fCQKSkpl0MKcbEWq7F5ERj8iApou8szPLnc1UHtLnhGeabYJT/QgLtHndt5C92Qrlfw3ma7F7ARgXfPa28LLByyjfKPOds2GifdgaKivc01VtTkn4kUiVNtJclgv8TNMEeiZ8DiAwx5W/s04fek+DU1zyFu/an7qRP2MtkoyNJUhdD2ZtqOVhBqdUT2uazbkLZ5wXkA2pm9nvLdzWsCIFGsBpLlvsJ4+NrG4m9dxt3UHVQDtBfUvSQ
 6K6zLdFL
 ZgNdFwZiGAfP07OH4nryaNAy9acPWPaJugl55u/N+AQUmdH4lKB9F01xgmLFGYMtfT1RXXwfaeZBvVZ513FKok/mTIki8YcdL1DQ6F1ueoNcfftuZ9gpKslYakjO7bwIzJMy6Xu0DE+uELNq4egGYGGRyGOZxPNk8L3pJnHyHUJofm6BvgwRmpHKvdv0Rn6I4az+dfz3HH5mlFkVeygFECJGh/YQbygsNFCubVkHCVyLlvV64gHka+pyVokbEEZjRjja9/BZxDedb1U5qJe7d0W7I1YN3LuyXe3qiwB6siu0e/z+CigqD6EfpED1JzX9bNE9Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

None of the trace events in lock.h reference anything from
linux/sched.h. Remove the unnecessary include.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
---
 include/trace/events/lock.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 8e89baa3775f..da978f2afb45 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -5,7 +5,6 @@
 #if !defined(_TRACE_LOCK_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_LOCK_H
 
-#include <linux/sched.h>
 #include <linux/tracepoint.h>
 
 /* flags for lock:contention_begin */
-- 
2.52.0


