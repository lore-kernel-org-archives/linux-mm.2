Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1534FC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B296B008C; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ACA26B0093; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 074C16B0095; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D679D6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:31:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63091140345
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:19 +0000 (UTC)
X-FDA: 84971743878.09.135E59E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7D22BC0007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cT1WPQZb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783661477;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xih7WUm5VfZrby5tp90UpHvQlQOY1Js2jC+5EQ5RYNQ=;
	b=LZc7BMZyctCAVJ71LuAdvuPnHn5aYIHjBFFx6AzYrmQdqw4edfPd7V8Zzg1ELJV0z4rEgF
	8XVM7SmtYEmrNuQnQBy9KiLHzy+Zh7FPGiSECfObmsQyGMRGrqVEWRT4eQY5CDhd6t4CiZ
	FtGQf/ggxW2hBHzlV9Uokf8z/Rlw1YM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cT1WPQZb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783661477;
	b=FrFF2JJObof6upqpnfb/aQv9ML5nl8RSAE8hQvkqAgIKWs1CeWmhqkdklqIzhOjGYcjZq3
	UMwWB3GTvPgCHyTcFUYF024sJjHznSJiLemOgGyCWtn8aIbcFcpfIhN2PPcoN2YKiQQ4Bv
	RJ0PxJeaq3iskF9kZxE4fmDSriT5JEc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6466C44EEB;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29D40C2BCFA;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783661476;
	bh=hkSle40hvPkgCxPiifxmuclyWzd9fTgjPZ/t/hWhm/o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cT1WPQZbIDi51GeFAFmnTygt0OzLeYXfiVqTqYJchNaPOJxXGkf3HjjBindXmxYsd
	 d7Fo6YU2owLSlVWqN0N55deUIUEqDRG6+wUf0cKAw6puKZLsnF6mAuglfc0+Rg+y5B
	 0edJGffecRTrLn5hQIHaMa6cMP+08VDzIWNuBtyd9tlDp6Wctk7oc9kSYmcFCD1doR
	 mT9Zh8vaCW52vzvkVBg9nOqbThSQY1dqXR0UBIn6gLgtzr6T6Q+GoSopHvPfmbnKrg
	 d6RmgPlTauhMnhnJSy3vV/qznQq+fekFQ6qT8MV41lLj/+shq899rqQVYlnd0cj8Lu
	 xFluisbdbMAcA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F500C44506;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Date: Fri, 10 Jul 2026 13:30:41 +0800
Subject: [PATCH v2 3/5] percpu-refcount: add ref_trace_final_put trace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-refcount-final-put-trace-v2-3-557cfce860a2@mavick.dev>
References: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
In-Reply-To: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=vVWsfTjSGw6e33WP2d/uyqteLjy9dxiqe2AmCt04NhY=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFkBzT23Y8+p1rz80Pf3zukIvlrR8BPlk+R2vosu3mV2d
 LV6zJ2GjlIWBjEuBlkxRZaarAT3jJWzEo2PTuqBmcPKBDKEgYtTACaikcnw33GWVshuP6V7871q
 F876Xb3cRlpp61dTl08/Ttf0FjyYVcjI0DhBdLP4GyN3Hak/N6we3ausMRAOW5Uovu/0vzVGEf3
 9nAA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Stat-Signature: 5pjd5njzc98bzrwj5y8kqfqdj455etn3
X-Rspamd-Queue-Id: 7D22BC0007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783661477-96611
X-HE-Meta: U2FsdGVkX199wnMm3fnnlxe+1O0weRzuk1WeYjimZhrrHEZRcyPq8wcMkKvSwkup4O9MPBhLZ9vcXq99UxQM21m05oh7/uffEh1MFlyiJG/UZAzCkGEhsLdQQpIMyKJL/uUAnfD1IAczON7d3yq99CL2V7l4JRn7X1NL6APocT/Wl2w36wz5oCx0Tkxsm2xMuQFDO6kKqkVvqxDVd3ZYTh+oRLn3RzTPbYe+aOaJRxRzqgoZVTWZws0SPXYJ6QrFcgRULvuuTh8/pXIpLzPBGfClEr5oDSka/rkpQjPGMh/3ZFA+35rq5i0FhBsUq4zGjGUPhE0r+l6Oaa8c7uHM17ixrAC2Iqsjqw8ITXju7ERkz+yleJsKfuJJMRzNg4LbfSW6TJTinXd1mYAzaR1q/hNcY+wQFq1SyWNwnOrKEC9wxV67wRohZDJX/FB1Es/HWmzHfrNtrZE0e+r0l5cftvKtV45/nnQTU5ZzoX1VZO7MNHrKZIxwUyYovKYLBIJPDeMj38JQEEc8Vyd+6V1hEkxIDKxLLLUAxES/cg1i6NKZClTDRxGhQzbC4baOOnSy/IbN3NTpYsVP5YLLr7lJrb5yE6ttK61T2pKPwaSzLSWZBtbgFEwHCfV+O0wrsj8S1z1thvK8x27SFLqtliu/55TYUNaut+lwyMJSiHRB85fGjkpmu90h2ldUsE5LXozULwZbRbIwJRZProAwNXzz6xbgc/EQS1AG+ajVBPxfyiAcR/+PVOVI75/aXVit3/K4Cm3LjN6uKr31UoB8a0+RsmgYSRhpsHqWJMidyzZPNuALLtqdEt17eGgyxnshbAuFob0DvSV+/5jC7WxbVBkIQ6KUw9Kf1zF2xTm2n/gDoEOCJoJsW0t/wqfvVRZvpW0NrQWH7qwgFXRLR/E1RW/LAvvqReoCw33TcN8vLUWrg3tJrE+ePbWycY138iUcRPqFwP3QA30xwHYIP38r1F0
 MnXFEUzf
 xqQE9jHwEWAQDDRDz6WpxakB82pKN1WA2IGTJMAWZc3HW8e3KeGYhqhCRgHEepc/MEPVKoTaoc/NbfvYkrXNijP8ynuF8LoUuszxOmodv9AUXaPDU1gtm7z6it8MSC4L8WGXd7NIYBw3dF5uRstdGUmGvtlWObey35gOdgiD9mxv+Vh/91RGML1UzFqe/6zZFe1nLDnFEdnDr6FBNXOjpM6P3cjv1tb7/+LtTgHTI0rI+Z96VO3oZZgWBPEbmzb/Xi0j7/Yfjp5n67Pqe7QzhfdPRpdec+hUv6qSsxJ4yRM4jF3NtWkqLqZHMDS2kHvZXiA0XF2GNvFmtd6ABVb0QXk5iEYwdhzUT1NzYeNZwVvQlY7feb17yVji1M8USOkafhGNEbAl9k2iZhcFXp7bH928BVOa18gQbVg/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugene Mavick <m@mavick.dev>

Add the ref_trace_final_put tracepoint to percpu_ref_put_many().
The tracepoint fires when the atomic counter reaches zero in the
atomic fallback path (after percpu_ref_kill() has been called).

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 include/linux/percpu-refcount.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index d73a1c08c3e3..f870ac0e8c06 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -55,6 +55,7 @@
 #include <linux/rcupdate.h>
 #include <linux/types.h>
 #include <linux/gfp.h>
+#include <linux/ref_trace.h>
 
 struct percpu_ref;
 typedef void (percpu_ref_func_t)(struct percpu_ref *);
@@ -331,8 +332,10 @@ static inline void percpu_ref_put_many(struct percpu_ref *ref, unsigned long nr)
 
 	if (__ref_is_percpu(ref, &percpu_count))
 		this_cpu_sub(*percpu_count, nr);
-	else if (unlikely(atomic_long_sub_and_test(nr, &ref->data->count)))
+	else if (unlikely(atomic_long_sub_and_test(nr, &ref->data->count))) {
+		do_trace_ref_final_put(ref);
 		ref->data->release(ref);
+	}
 
 	rcu_read_unlock();
 }

-- 
2.51.2



