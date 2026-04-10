Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 275D9F459F7
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 17:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225CD6B0089; Fri, 10 Apr 2026 13:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D70F6B008A; Fri, 10 Apr 2026 13:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED1B6B0092; Fri, 10 Apr 2026 13:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 016336B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:44:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 958B61B7070
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:44:25 +0000 (UTC)
X-FDA: 84643370490.22.DFC6703
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id D9D38140003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:44:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oIwDJ6Wl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 39jbZaQsKCB8EJJIRJIF5IBBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=39jbZaQsKCB8EJJIRJIF5IBBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--joonwonkang.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775843064; a=rsa-sha256;
	cv=none;
	b=fJy2Uy47Rbi3hSEZoN1tFeu/DfQMArJtW7Ejup7ASZC5i14y05zPRQdzehUTXFEvryttcP
	f4ztCOh48+ji43STU508nikRT1zOlyH9ECV+UfjtgD2l/U5yBVORdbOnZF9ScjlefX3yB1
	qjUZZZuBdEPVsfqmoZR7/I2+uEdHm/s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oIwDJ6Wl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 39jbZaQsKCB8EJJIRJIF5IBBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=39jbZaQsKCB8EJJIRJIF5IBBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--joonwonkang.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775843064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8k26hBFuVAQf1qhFtUuhQJ98YbLIG0NafY0jtRJ99xg=;
	b=axuYkRdIQ3yfMpIr6sxoXxjpjzqBxUPs9Bn52hLxDNkDuksmfDpl8MNdGpT3tZi4TghR8B
	QnmYSwn0v2hMZH509P3WWzJ+lfiVbci7uuneQ+2b8UixKBmHszeBCNF81dqRTJCU8YAFt2
	5BlnF4SZME7iTR+nE22B77QRgj1ss40=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b24af7ca99so36061415ad.1
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775843063; x=1776447863; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8k26hBFuVAQf1qhFtUuhQJ98YbLIG0NafY0jtRJ99xg=;
        b=oIwDJ6WlrMSabURkBEx/xfieQb3RldAoyWryNbYY9MdqPDiSKYJR+YW5cN6DUncD5i
         d9WYdhw80JBT+WYwb+9aEu93071/MRb1W8Cd13GUrJWqeOkWfwx7wFyXt8zlXyaE+bs3
         7h7fBLnhfUcx4aL8veARFN/LHYJS73XQS75DXT7DBHctS84B/bYOOsd7gA1AUjg+rkFb
         fk8fbqfMRcAk5Q3ES2G7FQDfCtXhwdYUT+uCE0LNrlSP61UBhUBpOxPwO8MUoAp3mSWd
         o9FgA8uYSuDUHiB5n0+I+jBpTVPYMMvL5S74S7oSmy2ZL+qHoryh09OC5sFUAR1KCLBO
         bA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775843063; x=1776447863;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8k26hBFuVAQf1qhFtUuhQJ98YbLIG0NafY0jtRJ99xg=;
        b=nJ45yWWCI5HPuiV5BrmtHqmqOMT5TRhUIGE5sjTze6JTxo+r9lv0JZOoM2IAYnICK4
         3Uyw0SeDf2HDPbg58jcIXJ53IAZtAIM/T24kWDAgZWwDJsLunbxeib9otXRAVI4Y/nmI
         fi3AEPcDoUGG+TpnSH6s2mte4h1+icg7wGqcz9TxBuxgkXt/J9XG101mThzQSCnQjOto
         sYG5dsxAaSgdMcDm9Cc1pKlr+X4fjjEk7dluQ3vTJJJFSfEYXEvEdzkoI1MHbilLzub2
         VcCEM713pw/WarJIUaKnfg8w/vNO+JTBx5qU/oRzv4/9XO9fnEQ3orW05VQdoC9zzDXT
         FMgw==
X-Forwarded-Encrypted: i=1; AJvYcCUJfk+9PVjmWnEDZ2vkyhEHWsaw3lSVAwnAiQd8CMKIzVRw5ypnhWZa6+UuqMpeehtQ0VLh+cKXxw==@kvack.org
X-Gm-Message-State: AOJu0Yw8He0ClMkJAGjWzq4AuApUW62tEP9/ncqdyeHYtFC6DE4H16W+
	+l9RAB79s88aBlTMFwNyNl3xKUmwjGwK0iy+ibBInUpemVam/9VQo1MeufmUVLxbXWybHDpCJSW
	2Xpt4Y0LQQWI/9KYoPA3S9eHFdQ==
X-Received: from pgar16.prod.google.com ([2002:a05:6a02:2e90:b0:c74:1130:c2e5])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a2b:b0:39f:c602:2149 with SMTP id adf61e73a8af0-39fe40d8aa4mr4413706637.60.1775843062495;
 Fri, 10 Apr 2026 10:44:22 -0700 (PDT)
Date: Fri, 10 Apr 2026 17:44:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410174417.1450834-1-joonwonkang@google.com>
Subject: [PATCH v3 1/3] percpu: Fix wrong chunk hints update
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, 
	Joonwon Kang <joonwonkang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 7qah3ctppi4qapugck8k8chnf5zwdmip
X-Rspamd-Queue-Id: D9D38140003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775843063-568790
X-HE-Meta: U2FsdGVkX1/XPoCP1grWVOL+V7/GXXSAIj8I/tXBvYY7l5/JTEbSlEysE41zSjMBfEry+XGJ4CAWGfIWl5d0paUto6iva8okvPhcdowZQEMDZsgsKZp6L/h+UplqYsMCH3K/RRUocUVgFLQnE5s6mAE9K/hcDpgOgtpafw10zIQ9873/Z7SlrI6nrczOrkR7xZvrv8tfBdpIxKFvACsSjtF0lwqGO4vJgSqq4ExpfHRsipB4SZP6MBL9UcJksjbXzRaTBV6Rd+txo1+uDms6uC+liqF6WxfTWLb+o6oUQVWxjaY1tAu2wEq1wkm5SfyX9nw60mLiHDtzR9n6qJGFaW2nOvvQ4pwngPRtvgMTjNUHb49zvf2JSJz9XOYT/0i/X5EDixCjgRaWYEjdrsS4BCNTQBMJALHzj8tWu1yaq24evZh4RRpGpS9o/afoqL8wlmz5ZJq2kMFtSw9B4Ig71PlGFxPUxbDxH0+en+yhwSjeFCI0ovW6V/hRPpV52P4LACWAC48KSdcr6LXVx9U/NqBU2tT/8A65FCdRZbJ8/6vbBomL4T8VxyJyVh6SenhRP4CNauLAb66oDN2aQ2X718dV3Cd0T5R1emj4uyqGN5BPYMwdUA5Y0sb6feFQBAeYNHUCd9Gyv/XhydYDh2xEhYclfoNe8KGT319FEgF8xvaDC+/za/ch/XnYsbb6muPBCDsOO+6BkMMqReIqqn24YMbZzWspkpAxDp0NW42kQVKDHn7HbK3FZ2ql+9Hy44EhZoJpROfnCOcTNJ+Iv0yitmRby8aFUuujeAk56/150os5at88rJoCzacmngVjrR2s0W5qCaRoqEovMHGbrbKt+C9SkWhvL7GwY1XOHeW/itcU7sAnubAc3K4L841D3fHeAuZyKlNpTc/28PDjTwG9egGQ2HjfirMcoeZXG9WXaRHFRHbtcaHt42yDSqtZJzyZsFQu09VEzXIOksgdIYN
 75GBYYdR
 XzzLG95Y+YNb+OQMrklbJKmmdyxRv9MMv3AH0yk2pJkeJo23v4eJnbu1ZXk0I9WfSKGnXdss5VDA6MPPAOkAJMNwHg0WRiaDdsW2knAkO/oJJkmopHwRYaibWue6j9e1RePg8aKw2+VPDDHX3BnUQe9owelhI+lQYOGcx9+kk+2c0SVAlH8iNKnFPQ0APQcihaznNRXwh26oNV4UjffntDMrOjMVSY+zPDqfgAo/wFmh/Fgiou5v4mGgLY8N5J4Vj4eSIvw7ufSiWMfzDJmvrXrGfLAOMeQ4VikygpjK4xRsYGsQPD9fUtOT5jXz1om0xDqLtg0z8xoS2yGaXVAsdYMJQYgxc33VDu54JbR71X9ioDwgM6+9eSrqsGb69yGuAPj/JmymH2SwZjGNwWWM8yX9nD9pf5xYx3dNkh/4ZQgMpApdgptcJ34WalsXogUr9mxPcIwm6G3EGIrZjtvKGjhvQKepI4IzhUKLxgEWK4eHcFebMmmtz1vePA6MzpN0mPkgwDskRhHtjgEGu1kdWxXvfcpR1ClSmKVlu9gy6VWeasKzmKDK83XU7lLOrW9Tg1rOnV808hT4QdY8PtoNPUSU2JKT28HpD0hO6HU5UoDQQzKv8dibZrP4uY7Ph9ZYMZmAGTeLZ0H2Ky5jdKmyzeoF5kLHWvCFvtkS4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chunk end offset was set to a block end offset, which could prevent
chunk hints from being updated correctly. It was observed that the chunk
free size gets minus or shorter than the actual free size due to this.
This commit fixes it.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
---
v3: Initial version.

 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..3ecd86096641 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1054,7 +1054,7 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 	else
 		pcpu_block_update(&chunk->chunk_md,
 				  pcpu_block_off_to_off(s_index, start),
-				  end);
+				  pcpu_block_off_to_off(e_index, end));
 }
 
 /**
-- 
2.53.0.1213.gd9a14994de-goog


