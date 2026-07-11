Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3217C44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 04:41:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78216B0096; Sat, 11 Jul 2026 00:41:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F946B0098; Sat, 11 Jul 2026 00:41:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9AA6B009B; Sat, 11 Jul 2026 00:41:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 747496B0096
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:41:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07A05120660
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:39 +0000 (UTC)
X-FDA: 84975247518.01.76D9F64
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5088A1C0003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 04:41:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=YKPgpTkN;
	spf=pass (imf21.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783744897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2tAcnncj6o0PHFFxyod2DNFn1o5vZ+4t+GMElLi3co=;
	b=kgEWNII77oWfd1f7g01p/9a37q4PghX20cVpVy5unN6iYU+1R3mkcZVLPCg21LFYrInxoD
	y/6APNVPhVGoQ9ejOK7cx24s4yI7/K5ENAw2Ndz7abkF33EVeeM8Tay/n4sXbLbLhIvkIF
	weQnnjEdYeND58jaulBjf97qveOmF5o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=YKPgpTkN;
	spf=pass (imf21.hostedemail.com: domain of m@mavick.dev designates 80.241.56.151 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783744897;
	b=aPKqf9qX++qJ3JoKiyUK/DnLg/MuXcTK/sRbZgaxVeKXCshHKiw7DFqRNljGhnTySL271F
	gEMpa25Kq+g2j4wR3khsr6IZFKF82M7oOSKTg60uLXGY+w3d49NG40rWktbiAV3gGaiJER
	i+SCX4+38d982BD3+S2DcycY5xa7zeU=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4gxwyR0NHYz8tyn;
	Sat, 11 Jul 2026 06:41:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1783744895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X2tAcnncj6o0PHFFxyod2DNFn1o5vZ+4t+GMElLi3co=;
	b=YKPgpTkNGHTkTmCpFJvuS4tmvjFHHnLcQnpxSY0fG3To+T2mWazjnSrVml1aTmPMLJatDv
	+KYB5awsHiUUOoOPgSNKwCAB8HgkMZCPiyvP6ZszW+J2BDYF6GEMjdoOaSI1QclRAtaU+b
	VnDUyd9idDjkuYGleHKVxXWpxjN53O00xtUOVNjBq8+pLFUayKd9xOC0iz6lCONcQMbxuY
	CZMp/DRgOiqSFrWexUbOLasDOnIi6I16CqFxBiqrGoPbPkabvJpHD9t6FcCC5QS3LCb4+M
	81c5XFlGW61FpcPANvkVzhuBZ6Z9sJm46WCVC//IyLYqk/3eNs+hSHB4dbfqgA==
From: Eugene Mavick <m@mavick.dev>
Date: Sat, 11 Jul 2026 12:40:23 +0800
Subject: [PATCH v3 5/5] MAINTAINERS: add entries for ref_trace_final_put
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-refcount-final-put-trace-v3-5-674c8f03d9f9@mavick.dev>
References: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
In-Reply-To: <20260711-refcount-final-put-trace-v3-0-674c8f03d9f9@mavick.dev>
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
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFmBJ21v2yzi+zRlaZGezLG5JizShe9a81LsYvQ/nV1kc
 muu64IvHaUsDGJcDLJiiiw1WQnuGStnJRofndQDM4eVCWQIAxenAEwk5zgjw6YdTc9mn0rWMTs2
 x5ljwrekf347GjOX7hLiMXs1WVH1WjIjw5pCnp3mIY8Wzpjy/JSF97mX+otcX1xIZtBkFpYJqpv
 UyAUA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5088A1C0003
X-Stat-Signature: 594pr7whnutkidocgqrgngsjaxwth9fs
X-HE-Tag: 1783744897-378329
X-HE-Meta: U2FsdGVkX18+EUSGwF2FGfHRaefQyPAi7OB8acmQSN+zDja1uIeMM6kJ4hwP1F2VDD9c4Opg4MjkW8nunui48y+t3QU9bb+rpuEjD/0KAthP1fcgwD9fwGWZYUleP2xFhSO1MDxIiE8IwNNvv9bchYdkM3EYpHe4GrauyuwsjGKwQzUjKJSi2XfWQLBdIxdo/pWctt4fk+Mv493n7Z07A1D7FXK0jR0QNClXMICxB2KNtAuePaiXLFsy0xRlpwSXVBDPt2vKrd7MZEF70ejd/F320mgx2IFwwBK7xET1yrx/wjMM6quBnsvGY40wHx4wLMn3ouMeP7e7374xtbh/XGAxnpQpNHguYatfkaLUxEcihGW4ephgdzVJDZ7lPaK38/U3UXA0yUh8I6udI2icn5PbI3KlQ05NUr4x0+LrWBAsMczHu9YZvMeCPphknhsm00mqG7MzQ3xR258M967m9hKGbXvtDBSeWPq7NS8YMyzqPplGa93X2G9NhdG4LuGkC4aHrBvWF87xViPfe9LBE0bVpszhvIYTfwTYtQ1P6PHpB2xOrR8nzsk8+cReX3QHi9FSRQ1EyeStnjrnuvCui+u3WEEKiSllXgB9TK/E0qpkEWJ2g0nyh2+tNG81Lzz0JqIfUrgl9V3rqoHIsAGejjoAlguLpWr1CeYzcQYRImu2b/QfOvuMCsWslBrOAb4cwqi7qGtwKCsk3wtdw9O1uuQ/JdmfckrOh711mvA33kGvl1Lvne1dd9HvWRbDEFAoDF4/N9mWAsUNYVaktoAx/Wsi3m7dK950+NRYVTbz11OEAVigljfWLt7p7bkVPFpwoOU2jGHFzUSgrP9b0lAsI8rxN5d8jIZW9HsdSONzqMAv9vTgoQYM/Df6AOoPUHTSEFcPR8ZkJp1ZNlLmbAUGugRqaAqGejjctSC4uE/CQS+ipg/7PNifdRmoNSb7linUKjBydYC+8fHKqzmtGVe
 2NN85012
 SO4ccsIxyB/MZP/tiX4WIL3I49HtYhy884bxvsmLNeDku57K2QwnXXQ8gz3DvikLL0eI+TgdtITh6MFc8kSHk6s6cP9V+sG8BkMwDQ7n5m/inUOp23Qxzp79myPGU2Z3j1wOpay50WpJbUrYU4qF7ZFIZiamLEagJP0dH951vAC1y6mqGPmJ+KbVHrXzfMM4vmzs45pNU30+6gf4pWhJ0efj2R22szT3JGZpxA0xdFk0w6Qjnw0R7wXb8d3CG82ObIaJZvBdSHgZJgTJSCYvN2ZuLyIUa7upFiNFUwCyO53l0h0c=
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


