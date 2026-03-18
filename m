Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBEA1077603
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AECD6B02D9; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E5B6B02D7; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A636B02DC; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA33F6B02D7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46DC1C02F1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:57 +0000 (UTC)
X-FDA: 84560063154.07.84FA1A1
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E16B1C0010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="tP/K8ULe";
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773859555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0ftc4L2bIqiqI9mtmvfrlvg+trY+mrARU5jBWKEO6Y=;
	b=FslGFWOYf4CUXRYqdzbsYS5wy5sKdBbRu73bfIJvsIdtIQ7dMfSQxZ4aTtWrr3pEtV1HSM
	pImnYKggunRMxlnOevA7cIoCb4lX+ZWXDlpG6OtYP6uyjliJK2FkriUU/iytIzx7e+jl5O
	tMQmS5UZbt/N4CCzZDiCRFRIhYHSUrE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773859555; a=rsa-sha256;
	cv=none;
	b=KtrEDfO1oIVOdZeF8OR2Uxk/X0sTxknEPoj1X4t+rqotaaDQaHkioR4B7OLK9S22uyXnCS
	c7RmLTBgSxyJKhDycPv31M86/p6VeOJHvaEuiSTYRjCDkDbb0karrCR8nqLQhpMOqjbz6M
	GdOTaQy3Ygjgnthde+NmQmD0qxT93mQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="tP/K8ULe";
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf20.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D1540B3E3D;
	Wed, 18 Mar 2026 18:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773859554;
	bh=q0ftc4L2bIqiqI9mtmvfrlvg+trY+mrARU5jBWKEO6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tP/K8ULeWlpgrQpV39MOViXMD5nLVW460t3I5KRLFEqAhRWVVCAuGp4YY/aqEpUC7
	 dKvz0pefP8DocunWuIRyD/rMLAe0E0/+BNabkUp12kh0Qr2tMe73xuRb3n58garjMO
	 TheqUqO1JEYnam+MmyzgC56LpY5G4Fs6KN3ugRuo=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v3 1/4] tracing/lock: Remove unnecessary linux/sched.h include
Date: Wed, 18 Mar 2026 18:45:18 +0000
Message-ID: <20c992338fcd0986b7d32b1c080fb835b42172be.1773858853.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773858853.git.d@ilvokhin.com>
References: <cover.1773858853.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E16B1C0010
X-Stat-Signature: db73h81gbaz5ry8jk1fuy7y7znj474sa
X-Rspam-User: 
X-HE-Tag: 1773859555-946622
X-HE-Meta: U2FsdGVkX19pOlCbbAsA1hsVht0zvkGNZZb2BUGUxYHLBiISmRsHChP3nL/PLlE9nGFtkLHg90VlxiTkKRcaZhOOi8IgXVYL+BXU/kFyksV+r2HpTYx5XI20sWW+Pj7z1ddC9VVhoDq23zjrpUvcIWqlr27xHcQRRP18kBKXDhNeyh4JnYJOlobOIS+JXONX6nDnayi2NhaKYahnqOKvZLtaRP1D8XstgvptoSodJUbo4l55cZPySZao7lCcFUCsFx/Gi62Vrg+kdzo3JMBlDYSBMylhgtMW9TMVAYnKoqW26eZddRpwyfRshkRCho7tW9lGn+AP6dUq7aS2XB2YbFG9FyOma6OgGs/ZDR/Xt/QUL1YTfC1/VU9CJp4LYKB6/7S/LAsq7DWKvOOCi8mKF6yegfa//pwS9U6YVqVNq8hG6+mMikRRfaM9uCJvXlnohgePC7zqhbWOXaz73tlceHx1Dpn5HUMKMUAuMpdg6PLsmDCYok70Hkz1ksJbbZ1hM996OAvjcbf8T2lbMHy/gsv44zmP06NB8tsOk6psAtcpekmWd067Iabn16y/2CjioY6WI87Pak7aRQPCQQ+MqKg6BJ9u13MrYdq+N6DYQbrkpHgHdbZGMH0Swuk5z1DLutXxhKgzd516HtMphKTsfQQoCNFe9s7yWIcoh0deDJ/lsiYAt7eyuBNAPjeaOvIlX3EPX7eeCs0Faly0DajFFgJLn7WaAlxjSN6ROqHVEgmKYGEYKYf2Bj084gcmMuBiD0Y9RMbzvRQ+gKhbI1hXpw/zFV4KAdSvfStFmWqm5V1k2fomj+/hDjN+BDv8NrPjuKsAe+ngQHgPzuefLweZj0f6Kwv/Qy8P1PyfkA+iFXI0VothB4LIfsgjIWuMIrdK3JvygGyL3QoXWCL57XSebyikLrTHJnHRjTKtDAsrJ+TyH55Af7nnZNS1MEQbCOEPICzo9HWsfqOvQlwejTS
 ianCvAUT
 Usl6DThREJBh9WHn5JhxsHnmiXfd/5G/gwAdFQSZlSS0dH5qbegE25PvY+WFaBGdEeRjd2t+hFEmBkdkoBrNBx+i5aeIL3vPsDUf8yK14XaFA1PrNA3qksi1noeTa5+O3PILiIJ/SvIZJAOjfSjFPg0vNfxkqevZnZRYbselfvUNFcd6iHKof8eu0ceznq88yfsabWwr9PzxQccX2GYAu5NLjLowB6ymBkG2G4ajmwiT9Sd5Wka/xJoPMwUnDVVQG6/bfl9aL/iFuU9vmpkL/qqDrcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

None of the trace events in lock.h reference anything from
linux/sched.h. Remove the unnecessary include.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
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


