Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5068CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 09:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A2F6B0005; Sat, 30 May 2026 05:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DAE86B0088; Sat, 30 May 2026 05:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA376B0092; Sat, 30 May 2026 05:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08B176B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:06:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C11BA140326
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:06:34 +0000 (UTC)
X-FDA: 84823505508.05.AF49902
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 64C461A0003
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:06:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780131992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YpzE0tdiXj4w88ryDWGBuBai6wJ7Ty4ZeXonfnpxkh4=;
	b=ejuagjDk6g4kAFOCj00n+WLjKIScDvwOtBBojz5tigMgpZnhDsQunO8+f+WMX9K+72ZdZU
	lVOiK7VUwjO1qnDU+S3iHyXlxxYhh2SswBPiGj7wIDbKcfkjjnwChQ41fAGv3Ta5GR5vgi
	yfaOokWa2OFsIvLod0MqGkd1lGZmul4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780131992; a=rsa-sha256;
	cv=none;
	b=bFmN/GcicHA1Ki5xAKS+ttSao9irv8HH1h88E6SlObszaN3rTMte0SG/BVmPuMM21gJeDf
	HG6A1oRctI181ccKsdkdr2zKgHR4wvwGy0ME1j8o+IB3MD9yuWIJUNVIVni20eujk0RFuO
	H2XxRwB43KZVN3iuc/2BWmRTPNxLP3k=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gSDqT52tsz5BNS0;
	Sat, 30 May 2026 17:06:29 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 64U96MFO051181;
	Sat, 30 May 2026 17:06:22 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 30 May 2026 17:06:24 +0800 (CST)
X-Zmail-TransId: 2afb6a1aa89046c-19b79
X-Mailer: Zmail v1.0
Message-ID: <20260530170624912AfpqJafVKV2Xmz1EPfHH2@zte.com.cn>
In-Reply-To: <20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn>
References: 20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn
Date: Sat, 30 May 2026 17:06:24 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>, <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY3IDMvNl0gTUFJTlRBSU5FUlM6IGFkZCBteXNlbGYgYXMgcmV2aWV3ZXIgZm9yIHJtYXAgc2VjdGlvbg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64U96MFO051181
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sat, 30 May 2026 17:06:29 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A1AA895.000/4gSDqT52tsz5BNS0
X-Stat-Signature: 9efd35d3nagmuyjt6khfgsp8ako6oxfo
X-Rspamd-Queue-Id: 64C461A0003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780131992-363470
X-HE-Meta: U2FsdGVkX18Y5fmhKbCDPrm0ZZyJZmyBEQuJB9t+xzSr/+YgIUrDtSjPZH6tcv1RKT5yh5JAN46TS/EVqx//dFON7Im/78QEUYp4TfRzjAVO4JmekMghJqqHMo6FH3/j59HVPtNN6qVW5vSRv3EXMcWWX5QwK9zlKMynhDEVKq7U5ZgDBiLoFjoR/5xsABrWzmGhyHwBed1sXbMBx2fccdOlxAX4DLbe3JwV6vD0v3yuvrYNg9vDxxp2luO2J9ikhf3F0Swtuf8GjVME4qJKgn98oFJ7RaSYFUNuqwAucZRUq7JyBq7EomQ2hj3kfdOWniMzZdWFzZHM4FR4L0vgk+Tr0Nmyd7CJygAkPAaO9HBUSufnNRRM28j3g2fOLj4/TWbre0MfhnVILKiy25Uipm61ZbZMrZyunVrG6O72SNGntM1APxIUjJjJf9YpS6DODKMyZL7JAnSMJT9VgGzeOWs1Cjinc8XECAK+M2gwJ+fmTVH9mZFtvnmvVQMw+Fg6OIHAJCkJC8X5kIte1uRrgQfVqx3vMfZkJM/tQJZHUBvT2TFEOIUjXfjscR9cXW2SEf4wxW8bCCratIySLMyarWptxeP5hneXzikCPH4/fQVviVKIWUO8Kn3fJDdkl+ys8Ctnanzi8fpVLo5FMRbSrslDzBNdC3ICRvCvJZ5yTh4UVIwEf7W7DkWW7oRc8zO+kQzU8jNzcvrmBc8yv8CqOlija1l33UNx39vmU3yHq2SaSVmXBbOiWNV7R0c4lb518U8GQKBjk92n/EjXYTW+9rE9vNjAoChshfBHlMOpqit//1JZP1eW9stLf3qZX6EEVLkidyLg01I9T+SShk1Qm0AkOqVcrhYr4uueUAvjld/4K375+2P/XZg2nFqIi6eKnjlBWcxmvPZAZd+I+nnSjbIfx4Msf4+evyDkvf7Yg2G2CvYPsYua4DNB0Vu0G8TSobqWbZcWA2EuL5ZMrxi
 y7J47UZJ
 6GrDO0wFvlt3RVZj1IBZkaOXNx7oG4LYTjyhmaAN5O90F+eQmiP+LijAIZ9OKXpRrOSbmL0AaYEJIH13p44Nho1Q37Ga1lYS2aDJGPyNZY2Nyz5BJMm8B7se5Er/rKqeD9QrehGw4bK2Ru9X+RfDsP9A6FljrmWFF8WzEGpehpj2fhsCiPQ9VHclT+ksXwZDZVK/HWljUCYYR6cMcY2pFaetXTCpI4UD7fkT2Y8Kew4U3TlKM6Y99gsdWQ9FWwBk4Rye7x8qZlm0Y020CaUzGCGicge8HFnL+rwWCiz96Z07+afFWrGmfJ3uvU1k+lktCNPEHchkDDKJjnRYmQ6qv0yucoteiu4iBhUO/GSwW97X59ghOFU25tIoEnaJxDk8ZjMDV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

To help review future changes related to rmap tracing and testing,
add myself as a reviewer (R:) for the rmap entry, and also update
the file patterns to include:

 - include/trace/events/rmap.h
 - tools/testing/rmap/rmap_benchmark.c

Signed-off-by: Xu Xin <xu.xin16@zte.com.cn>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e7268d2f6ec..01cc34cc83a2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17006,11 +17006,14 @@ R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
+R:	Xu Xin <xu.xin16@zte.com.cn>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
+F:	include/trace/events/rmap.h
 F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
+F:	tools/testing/rmap/rmap_benchmark.c
 F:	tools/testing/selftests/mm/rmap.c

 MEMORY MANAGEMENT - SECRETMEM
-- 
2.25.1

