Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34949C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B82D6B009F; Tue,  8 Sep 2026 09:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4689A6B00A0; Tue,  8 Sep 2026 09:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331206B00A1; Tue,  8 Sep 2026 09:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C8396B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:14:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 99904406CF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:03 +0000 (UTC)
X-FDA: 85190637966.30.18B3FF3
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id D37BA14000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:14:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IdCUQYB2;
	spf=pass (imf23.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788873241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZmngaVsUToRipCvkV5xzkVfvhYV30Q+0QWGu1nqLPY=;
	b=AwEUSNeTF4OYZMXeOrPLIoNYktRPrwEUR0c23aaKkIqsq7d1VGRgG61qakIbI8QSB5F0i4
	o+5KF19bzpO2TXXPegRf6qZ+F8EdNBtsH0MzqilXiHqtQ/oBruizDwJtZWNj9W3EHsuqyL
	dOQhPWnRngm3+a4sIQIhhd49ZK8I7Ng=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IdCUQYB2;
	spf=pass (imf23.hostedemail.com: domain of calebkan1106@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=calebkan1106@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788873241;
	b=YbA29gvciUi4AhIva/pOmTPVKfVCYE/ShVQzsdYnSk/0BJXeN57i3dtwPPlZ16vc37FAqk
	ggNEEgqUfZARUJGLzbOb5GKESiNcdN4StbE8z6vbAF/wLfuhpjLhxboR5DPVtrHLBmHAFM
	e1I1lm9FCd80yTpAjtgImxPLg/WGX8k=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c250c6a6a6eso618545066b.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788873240; x=1789478040; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pZmngaVsUToRipCvkV5xzkVfvhYV30Q+0QWGu1nqLPY=;
        b=IdCUQYB2sEqFK/wAtEIDl5ar2wx+Fo/9OWw2WLRPMfDzIvisr7WBjvF517+fWpgbCK
         jGSN4icz8NcHg+XcCiDmgL/RQFob514DyFaLyOPHTO4pwoAVF++liG2zOV1/oofyWS2y
         CzT/aB24i5zs6oHEoP6AThIw/auKkYqQC3gnNqJJJRJsrZk0mblrDRRbp2ikImy+IE7Q
         xLmqLtwxPSFDnh8yzVHyhwfapzQyYUWWj8oaEjiWmgKrync9mxquKOx+o4B6KitRSEr0
         MDLSG2AI64ZtOH/hFEnunOrsG/9OHBylzDI5u8lVa5eOY+Ac0cynz8sQDqj1i1fxFgOS
         5/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788873240; x=1789478040;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pZmngaVsUToRipCvkV5xzkVfvhYV30Q+0QWGu1nqLPY=;
        b=EV8gb6+K5khk0VeqVqJWH8F3SV7C6zj3PN3v7R1SucgZyAi68eHvaQN9ewG1kvjjIz
         43LtH8D7j/ZRSaLneNlYISFRsa1i7Vgp1HlONzz8TMaInYnhF6rZLeoNByPVjR5QDRBJ
         0H5Enrx3BBFdzGe/HwuFMyeI5BihRQdM40bCL/f597kDldh3JDqWkV1nPEdgmHclFsNE
         90Gf5nhFQpzGGpWAGM+XlLIpIvB8vXH+qVRLnm/0ZB/gvB2LkTXrJmYn5O1ftVozeiBR
         dzo2pGT1pirEts5UyTUvnQznKA0PfTmWPjh1QMRENg3sNcyd09HvFKX6As8FJ2313XOU
         nW/w==
X-Gm-Message-State: AFuF++k9CMF7Nrrl5IgzmQq24piQbBCZjpKjjrEPRPOdm+f1NHfPMSjG
	jDsJG7JO8PJPLF3KN48XU4e8KkWny0ZEp6gn1lSKZyIMcRY2RybgCn7x
X-Gm-Gg: AYBFou2ToymUM1XTuiQqaaVVyB834UR1kZ4i4ysxvlLvi1TniEcz6LC4AzBwEXNiz1D
	zIRLTzaPK7GSjUtVqViuZr6i4WDMl2TdzkdX9hWQxgbkH/cx/r/5jVmBVMVCgDHlctkEuqR+pgw
	zYACK+wMZO9CPB+HWh7emZgKa5C08JqKkZIu11ffYqn8W1d3FPYukZlTNI3JRlV7CnQpI02d5bC
	yyEWHuyl5MOn+rksEHbC9MthY+gkUzvBqe4TXllWmV/gjyqVMZ12ILacBN6Dqsq7wuNOTeYfM6B
	f6Q7xwbOTVrAH/qyXo+qA3f+tCOoW4LTiYuQmpxgIsg3wYjaFP3owxs1SLk3FRu3w8+QAN7D/em
	ZjO3A27nRWlEhYIbvfvOSgdmPUSz1EpZD+JNDqVpNJhaIM98M4/nobJE9NbWrnIXnS0VH1ZkLPV
	Q+N/lnGptQzo8MwUKY8z9TQ+gQ/gL3X7Us+KinO2G40OFCj28JRg==
X-Received: by 2002:a17:906:2082:b0:c29:18da:43e with SMTP id a640c23a62f3a-c2918da084fmr93675766b.12.1788873240393;
        Tue, 08 Sep 2026 06:14:00 -0700 (PDT)
Received: from [127.0.0.1] ([2a09:bac6:37a9:1e5a::306:1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d6e1c93sm625170866b.63.2026.09.08.06.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:14:00 -0700 (PDT)
From: Caleb Kan <calebkan1106@gmail.com>
Date: Tue, 08 Sep 2026 14:13:41 +0100
Subject: [PATCH RFC v2 08/11] scripts/gdb: reject trie-backed stack depot
 handles
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-stackdepot-trie-v2-8-1996d5cef732@cloudflare.com>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
In-Reply-To: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, 
 kernel-team@cloudflare.com
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: ja5uqcsb3pqx19aa6yz3xhqsde5k7h7o
X-Rspamd-Queue-Id: D37BA14000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1788873241-769846
X-HE-Meta: U2FsdGVkX1+JvgqA+BhqpJIYjdePbyWFyn0aZW1H+ZiW55/v+0d3Sd9daj5FS9vJURgsc4X84Wi+Dr8H81YJ+kR39qHwLnc0cEQ3TE9pNHxqO5tDYUDmV21xHOZRQFZ3Ny8cD5Kea2tu2fdHZQq668dn/MSdJr07FV1xFiWxFa1HSgLlcUuudX38sNuEyyw9+UC1TPL6Ns6MxrlQBgCz3rfupWIJnYTIDdBrMqsSW8u/97Ddu4bYt9UDZyEInaVMwQ494HtWDy0/mLSl1HSPLWv1MeDMwTLn2iCpkPPBeyRU8dr9faTmQATzcmLBkkY0xPA2w7j+cZfQw+4An/edrpzNPXtwXCPP5zKWbdNfl6i1DYE57yvjKOLpbdq8wCj0cDO8yxeFvgWGBfZpdvEHIGj2WZtVmvZPkqwG0Z52JZf1LwbSLb4U56laNCEoN6554Zr1MlAXxme0KVeiEpZmomX8SRyICOVFfvHWjL2FryRChq2iOvUBGT2jttgjbbS1cAawUEn1yC9naiyXECjDNGXpxAR0SV13UTfap42yAeQmWkElE8MiP0N5JiHIRwo3+gEEbLMLjkcPAGDes6MDCik1uU5AaGQHlPi1HaKPD4E5mj9mI+LL5zLoJvuhn+PxlM/FVV+rgCKi4tVk8oS4OP5T5ieOXEyVvBMm+ua1nGiV1oHH6qyzFItdbo24ZMH0tGR7eVt1vM3Bq9t3de36OmZ8FuOQtUU/9h+PgvUHPZfj0EpEchqaJdD4UDIIedXClqGqxwSQ3pIluKbY4EaL+A6OGPcUrOe6CqRWYHk8vwt+6fHPn+lyCmfuvHov2j1cm7JrKK9YBfuTsJ3eIfpmWfmemf1ILTWSDsymu2oVeATjlRaaonNsmRkoNEP7Pw8+GF1gtkZr9K4j3cBm09GwiAbLITSfTMByZDu5VBtixyQ+9iBzD+cYltz1ZpioquuFOgT946ssTgX1D5R0Bun
 UspDECG/
 NLxoS8NQH6Zj7bgXni7J0YSV3VvzGivP476ii6XK/xYn1Tlj/fmH2frlho6gkpQET5rYWvXy7/znYeq8+doHQygQN6wieoMjYWDFnkmHjLg5zqc5fWL+CP9rT1gwHgtiVeEI4Jd2rEsC83HPFqEwafGqrubBSgIcn/N53s/7HRQdpw7CPXiRHxzzqowI+NaxxSrA91o3NelniFNcX/OJ4UQmutvOi2r9ka0HwTm0qPzzRQeV5/euw8lR+HBhY22VnnKWbhdQl5zVGyzgY3+QqNVUne0RJru/P3QWPXpAt1IXrZYt2Md9YhUMH7UYZzN6te8A9robiToYNmHvrqvbj5gOChmmpT57HwQW02tMgZlFex7m2cICBasaEoSQudO9LN/1g5juXxylnLKwo6oM8Ir3a6A1rwF231Vh3Ud6fw+9Dok5tU1eDXGfLRpGVBo7YOGbva3TxCjUDx2BOjrqf6RtfOpwb/bIbhYt5+d+FjmI3khn6TxALrSpauw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Caleb Kan <ckan@cloudflare.com>

The lx-stack_depot_lookup command can reconstruct stacks only from
contiguous hash-backed records. A later patch will encode trie-backed
handles as dense stack IDs in pool_index_plus_1 and offset. Without an
explicit check, a trie handle enters the hash-only out-of-bounds path.

Reject pool_index_plus_1 values above stack_max_pools before looking up a
hash pool, and report that trie-backed handles are unsupported. Supporting
them would require the helper to walk the side table and parent links,
which is left for future work.

Signed-off-by: Caleb Kan <ckan@cloudflare.com>
---
 scripts/gdb/linux/stackdepot.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/gdb/linux/stackdepot.py b/scripts/gdb/linux/stackdepot.py
index 37313a5a51a0..82aeb9f532c3 100644
--- a/scripts/gdb/linux/stackdepot.py
+++ b/scripts/gdb/linux/stackdepot.py
@@ -37,6 +37,10 @@ def stack_depot_fetch(handle):
     if handle == 0:
         raise gdb.GdbError("handle is 0\n")
 
+    stack_max_pools = gdb.parse_and_eval('stack_max_pools')
+    if parts['pool_index_plus_1'] > stack_max_pools:
+        raise gdb.GdbError("trie-backed stack depot handles are not supported\n")
+
     pool_index = parts['pool_index_plus_1'] - 1
     if pool_index >= pools_num:
         gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))

-- 
Git-155)


