Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BA5CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 17:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6914E6B00AD; Tue,  5 May 2026 13:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662116B00AF; Tue,  5 May 2026 13:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E906B00B0; Tue,  5 May 2026 13:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5FA6B00AD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 13:09:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E2B71C112E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:57 +0000 (UTC)
X-FDA: 84734003634.11.D03EA3F
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A865160009
	for <linux-mm@kvack.org>; Tue,  5 May 2026 17:09:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ssEo3Kfr;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778000995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxdOxmJ+WRA4zY3tyFP5+GgWLQ1rokSaYX9143EcXHM=;
	b=6M+SViLjGHcfATch1ad/EhQ3v6aB0i8/Q+d4QwfXIUl4sS9Uysm3Ye9WOFsIwrAwIeicD6
	eLIy1ZFUhXJCNLirnWrYc1kcoUwJcSI9q3BjSHvm9Ji/S8g/61YWqVi34v9Q5hmcFv+sOL
	+yalU5v+q+kwQkpfXt6kQMU7farsLP4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778000995; a=rsa-sha256;
	cv=none;
	b=ieroiOdLcqCN+bSKYHemMSqFo3LjNmOpvOhzYFkSNCedA7l+CfO6RJwD43ym+63sQUzpfs
	KvdrWG8ygbAbdMh222vKTNBnlg+3UFHmlwG62HX0y2CutHt220C6Q+pfSwGIYB89XBuKnO
	6Kb+j6J1T4ewJmdgsIvWoDIBJvq9Um8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=ssEo3Kfr;
	spf=pass (imf08.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 1BC05CFFEF;
	Tue, 05 May 2026 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1778000993;
	bh=SxdOxmJ+WRA4zY3tyFP5+GgWLQ1rokSaYX9143EcXHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssEo3KfrvTzaYppTeR/9SbdtJSPaIVu1WuRcuxgZD6c7mHL+wbdWTgbH50oMX9Rx4
	 jbiTDSsFgKtyohDLtiVfkwSixAPFGoCqLsroBDbbi8FZyVseJMQXFy3LQGSrAai9Nw
	 1x1vAXnXREgWmxSZd9lkIwqxSPbEE82eVuY97/ms=
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
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 1/7] tracing/lock: Remove unnecessary linux/sched.h include
Date: Tue,  5 May 2026 17:09:30 +0000
Message-ID: <16c1eccc88e1a1e67028086151c7fbffddf980e5.1777999826.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777999826.git.d@ilvokhin.com>
References: <cover.1777999826.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A865160009
X-Rspam-User: 
X-Stat-Signature: yhkt49hx4q349k9jztjoz9rgtfak1q6p
X-HE-Tag: 1778000994-390576
X-HE-Meta: U2FsdGVkX190YBAM2V+sLjRVx+y+Jguq7iTDTJPfYZy/SrpYz8KCANJz/m/VGzH0bzAWIxphG2ZVKrNJAQ2WVBV/0TlEjL0/5zKlChyagi/ba1Go0MyV0NKjRS22SgeZk4+ZcjgIZurz42xI07hDXr4gKsHV/Vk3b8D3a/JteWVvWLuzb16oLOsqChmekfLGkEwXwSu6/ySlqHsiO2T+TJcAMFlDO+7Ea7PXc4aSpR2NTtdzHXobsVAUzavAiGAWBcSls6OSXnkYM2fRTGryLJgBfa9vtdPInMU5lDCREuNcc1SqzdyQAokP5Pe2cIcNgFjK2w5uJyHy/WfmY40B34xZm5g4MQpiO5zzHCiJmC04GTp2L3m9k0EIfD4QcI6ZFx7Ierz79FSSyxxvVjLSugzc2+tKJLyK9RnqEURipWfBiHITL4htaKmt9eXZLwOxJPXo6H/w4qhHzNgcqYSMshnpftpEwTrPi1rIP2G4hUVwID15a+m9hgd06ORpUmNATnHxXk5hyjJbvGaqrkk1FuP2HEaJSfksfgTNuJ8BeiOUs6AvUHFnI/FMfixoCNSz/aIBTGnPndNw74j7U6S1qUfmvW9NhaDBal+YqpZMOLHqjMl9pF14O9Cew/6HXMqGMi5i0IB9ubfDoNYMaKW1M0jW5cS3l4dU5SShW8FZLiul5WX5vzrRQOC2ZY0bb0UJX56/OTkCs0lvvWHIPZrWGCDdQeFF0umKouWCORazL9w+qK3rGYJHm8DZnhV0m448jmI4Pd81pnpAqLtLNEknb1hKIOjJbdW6xKewZgec4OpC5EUDbdHALKYURdd4R7GZTSCuqmfZgenRvyzR8VKSqkVhvFsXKXSSB23sqWD8dfWUNIejPVEOYyxZQOXS9aSn/0HzjwZWyQSbL65ydPMR+Q6Y2mD0SEQP8tNI4bkFnaIs+DasxWNHfg7zdMp73HioWlfaCAnH2FkeRb6/X+O
 /byDm0Qz
 PMEFHcXk13+r8H48TQ9b6cQaOs3VngYmNv2tLC6clWJLwcslPU7LEMfXR/54frfZdinO7busjDXBVFszU7wqO9+y2dHWlRmkv+C4AQZ5rzAEKDFmWYieitoBxrOAqhqiV1coEqCKjMeFCy8phQNzKU0RbC4K3edmlr3rkUqrNTIUQBCdBFqnpY+vIQwKbzdD+mJ8UbJ1i2Nyim1khfdV0XdpivUtbx48IwrqAKrNDVCBuEVmqjtlLMesh6lwpG/MFwtKq1q6vmBiJPi/ts8uUVU2iBz4QvfQ+CRsuacDI4bRBt7VGgxc0jR8d14tdFBXcKhGa
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


