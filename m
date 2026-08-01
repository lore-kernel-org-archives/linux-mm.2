Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACA6C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 11:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127BA6B0099; Sat,  1 Aug 2026 07:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8F26B009B; Sat,  1 Aug 2026 07:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A106B009D; Sat,  1 Aug 2026 07:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFEFD6B0099
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 07:01:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AAC31A02BD
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:01:18 +0000 (UTC)
X-FDA: 85052409036.30.ABF5CAC
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99982100002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 11:01:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=AorQS7Si;
	spf=pass (imf05.hostedemail.com: domain of m@mavick.dev designates 80.241.56.171 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785582076;
	b=Bg99hsbB6BUy30ACmU5gA+MxINT6cwR8EXYtyPQ1yBdmK5i/ATTuA9QDsTQ2L2KXrPis4M
	jcFL/dWm2gclZ/qlOs7iv1Xv7zVAjiCNx1sQEVD3AxmJ7J9OzeAp3cGj9i10xgrlWVTNCD
	stYkB+eZw+bUmX26Q2D2gbp1zgodeUE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=AorQS7Si;
	spf=pass (imf05.hostedemail.com: domain of m@mavick.dev designates 80.241.56.171 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785582076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2tAcnncj6o0PHFFxyod2DNFn1o5vZ+4t+GMElLi3co=;
	b=lJ0ntjSfYYjtidFcWiEjQG8C107tw4qwXznHdwhXS7fFfDrXjwgWe/RoysEr26HbBuO53X
	0Pap98vkG0SLADMsIuEQ+/kwP6mI4Sm6nJKn/LEtJUja7LJ2SFfobmOHeqpsljx0LcT7tV
	7UVTwcmOw0KaPyDMXFZeBhPoOJHwiRo=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hC0Np31s8zMlGF;
	Sat, 01 Aug 2026 13:01:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1785582074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X2tAcnncj6o0PHFFxyod2DNFn1o5vZ+4t+GMElLi3co=;
	b=AorQS7Si71jqPNImikVnoCdY3qQL7ZkJwLQy0kMLeWprNO4dp1Mi/DQu7E90vUsqDkQ3M7
	CIKww38MOhb6LFa2MtMfYVwU7Di045mM5wTIJUV31WiQUcBbsKa8vGfAt26mSLvoFvIX/c
	KEBrtvolW72taHH1DAIO4Jz+ewR5dquLLIOX1JvTkOCDSmlljLqkONjT9CJnZjGjBuWwd2
	9lHznKBGJELfD1PYQ3fBtrmax/gvFcFP6qV6+SKHJ06Hr0WvVusixGCMRIzuIMlZTAaaYE
	t2O7JBGq/t+FMsuzJmYrSQBzj1aDaJfxqfZyMSVK0cegXQyUcxC8eNko6YpjFQ==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 01 Aug 2026 18:59:45 +0800
Subject: [PATCH v4 5/5] MAINTAINERS: add entries for ref_trace_final_put
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260801-refcount-final-put-trace-v4-5-2e58678f0ffd@mavick.dev>
References: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
In-Reply-To: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Developer-Signature: v=1; a=openpgp-sha256; l=627; i=m@mavick.dev;
 h=from:subject:message-id; bh=h+1tyznbFEOyuRy4iHAT3B3e7gGvTqt1Z3Rotq3NoN4=;
 b=kA0DAAoWnR/Kftt9NE8ByyZiAGpt0bGgjb/NhgHvR4Tr44j/3KJicMhoZci7EHLmotrvEr3vp
 Ih1BAAWCgAdFiEEfGpgR2ipmmEzxZKMnR/Kftt9NE8FAmpt0bEACgkQnR/Kftt9NE+eYwD+LJwi
 Q+XJqOR3j9bhKBUOvGMA3SsNpH1gfTfMSJdnq7MBANwbO5fyJD8wpKF8RYRyJmx5jOJLld3w9EH
 8Mwz7jVQJ
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Stat-Signature: mhhwa9ifwxxsq76kq7mj9yzh6bqcy8jn
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 99982100002
X-Rspam-User: 
X-HE-Tag: 1785582076-680515
X-HE-Meta: U2FsdGVkX1/d8annPUy/zlkr2b7AIelO8JBT6baCKUhuv+f8r2hkgk2BiESSxmIywl+Lvi0Vfo3CBDr/oe1xvzJwDfd0XzUKFKvnHH2GzMnqdAn2Z2beelQLlD7DsCPfsGrJlahba/x74FlPpT2eSJwtlNmSzHE8+iW0b8UIK01RaEgLVAUmSPja7SMcrEFeJdIrw/WGiOl0lnYEub3SzuxJTOtMLGEsVaROnNic1MSUX+9xuTsK+QtfznulwAVAXfXfal63U7pzTFeKVuc+k5MZHt63eQ0zgAfoIR1/MfBE4h3f+J/E8Vk0kKRYQE4RlrC2UZDfp/7ERjCPxJmj/2Vg58kq/fcsm2O/in14CLIQbmmiSv0d7+nORTsm0aPJiotboCKh2NcatbWLY+6RfyKC4zdA08Bb064Jt7/5DbEaP1N0ke/ZrqFHfHog7yuRCpkMZV2phVYlaccjTfoz/RMVZgVuB2p1tnwfbnYWP03bNRbv9BUDt18SRA2cz5aJ3v0zyxINIXDeCpC4Ug3Cs3fKN2mLp5xpJ52YBY+E4Rkzm4HbuvS+7P9BA0DE81jwRMjokFbqFQrNJF+/bVBbfoKFS+qU4Erby60/f2zigRb3az1cDO7RQ+JT7hdCU37ip75AVmsfJ+1XOMHilbEb8tdz/NQq7uv/92a4t0JN66yjzecDf2aJoacpfQnukGKsrU6h6z359DcFkxUwXMNbAqZep/hITKjYZ0zIkLear7sVAeX62kSJdX0/lxtM97jnEh0EGhS5OfJLPmHFdISqZXzQaGTrQ/v1c6tlmhad6YGfopamqjKlAsy1i4HdCoWdyv+bG6yIDAN67e98r0mbCJ2aaEE32/wwdmDMlRWzhb5O72YXllCADkSfRcZEmPneGOTbvNxj80jFiHmzkkRjR36wPHJkpfSGXWlf+6Y3kphlA+qiA+wfIWjayQuIdp6IKjTJGQiHT+zdIOArBtg
 bzopnasf
 Cn0Irankb9rD/7COX5S7hcHaT166deY+RK9+4N7ORloZi1v3hVC2c7cS23HWbCH34MZONe/C7AGdnQyJVTP88NTRh2btqhTKGhsDbmts+ArrCi6rjDl1TpIaaJgZ5n8I/yLLU6Ry7MAuEqayNIHRLGleSEn4qB/t9nQrexlG+as8wKUIjgsWJunjFJMlNkKdZ0YEaYdxmMK7RkXFptB2FmsVQ7X6W4nBzw5CCB5N7aTqlKSCnk+uXKn48fChTq5Lz5me2wnhcfT/T0l1suqeDwbClPEAnITIICOu/c9NqQzp8xuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new files added in the patch series to MAINTAINERS

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10e8253181d3..2dbb7441906e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4210,7 +4210,10 @@ S:	Maintained
 F:	Documentation/atomic_*.txt
 F:	arch/*/include/asm/atomic*.h
 F:	include/*/atomic*.h
+F:	include/linux/ref_trace.h
 F:	include/linux/refcount.h
+F:	lib/ref_trace.c
+F:	lib/tests/ref_trace_kunit.c
 F:	scripts/atomic/
 F:	rust/kernel/sync/atomic.rs
 F:	rust/kernel/sync/atomic/

-- 
2.51.2


