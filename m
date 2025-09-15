Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0107DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 21:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F5F8E0008; Mon, 15 Sep 2025 17:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F728E0001; Mon, 15 Sep 2025 17:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36EFD8E0008; Mon, 15 Sep 2025 17:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC798E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:28:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0C0AC0717
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:28:06 +0000 (UTC)
X-FDA: 83892772572.17.4792853
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27BDF180002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:28:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H3LlSXLw;
	spf=pass (imf06.hostedemail.com: domain of 344TIaAYKCFwMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=344TIaAYKCFwMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757971685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3medVd2qOWPEhfNfxl2kAO69G86t9hZitkKMHzJnpo=;
	b=kwGrhzkvGNy6jjcQPYNaucellao/4i8jPQXouKBw3XXwcXE+mk4V7+PMPdwoNeKu1ruqiW
	9yN9B00tZwffPFM9HZ8IDEO0H96H82HonSGlvhYwKtRW82S1vaflpKfyMCbcVVnJifjCG+
	HfkWJDNWV3QCXQKAUAg/ZE4SvW2ffOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757971685; a=rsa-sha256;
	cv=none;
	b=lG/r994OCOGBp3JvtpDtk+S/6xU1gWoY7djA0gJGFZa6FOXOOxMoXrCEhpFTRU1LqgayXj
	I5oTWoGladT55s3HSnYzLdOysq7ErvIW9sXITzQt5L0x2s8uH+ofiPT2TDR66Mh+8A/JXT
	FwgmGBFpIqsUTy+sqrd1TLM2Anx+Q/Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=H3LlSXLw;
	spf=pass (imf06.hostedemail.com: domain of 344TIaAYKCFwMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=344TIaAYKCFwMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32df881dce2so3244829a91.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757971684; x=1758576484; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=T3medVd2qOWPEhfNfxl2kAO69G86t9hZitkKMHzJnpo=;
        b=H3LlSXLwY26NUll+ZStY1KIxuwaxxHww/7ekdXPM6bmHU+4tTRJhdw3GTTBUpLAdF9
         uJIy7KmYd7owNKOrE28iWVtCuGTrzYOp2kaWo2hmMLJ2P1hmdzXHXIKGXo9Ugw4ZA/Fb
         yQwS6byENVy8vF4lBTrry/dTq5E2LuZ6XueKQQZPePou/8OXOS18cC79/OMTbZFtt0QB
         0A1w9jSDRj4m/wCIbw8s2lg2AwEyGdIe8gH3BgZOgRaTyVB7ZD0+ZZnDnnLCQa5i8ll5
         +7Ky/WE1c1JiIjYExKLnmHVOe43M+sffW0An2U5wC5fmsfJCEXhTdRm4A4BSC/xqJFM1
         VitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757971684; x=1758576484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T3medVd2qOWPEhfNfxl2kAO69G86t9hZitkKMHzJnpo=;
        b=juZxAE0u/cvZ4KujR+sMacLw0Dd7IKkmt/f5KWpSwQfV8mBWUjFws3LZH+bhHdxci2
         VkrEu9VOX7WON7HefNGNisKs954fUF1YTf6EC3jRY1RggAD2+P2Oqt9qfhG7aLNKmljI
         Bk5xAc6mCvksrjYLYSpbDchgB5o9LgjLTuxu5PZqfe2OQV7XJQ4acyIiav1ouzTRZqOn
         t1FrrvtWZHQJJG1oLfFU48mZwfTA3zd1qd8LYn/phj47WsxsVaXB2+zBbIo43c/h1OZy
         JzdjWr4I9ik9AYBC9fPXVjROf67MrdMeZoRtigTK95DSqDjJ4gQPJLe4hcROo9vRsTUL
         KDnA==
X-Forwarded-Encrypted: i=1; AJvYcCUxTErbIFfqRYPVO/bcZ7GJpJ4CC6FTFdw/YBO/G/JZbUZP8FDqSPNJnzt3J5Mb35S43pvjBhfitQ==@kvack.org
X-Gm-Message-State: AOJu0YxtOCLondcM5lyH6bIufDZEvmh2XqloAaE5V6rWLVaVtLjAd3Yy
	i2yxDfUEG7l+5vcC2FrfsQqR/ihqZnwrDye5x9Rjh/mo3zosCvC8QpQx6WQKvhqlIcX+cagdmAl
	bw0aZzw==
X-Google-Smtp-Source: AGHT+IG0byYP3KTrWemnIN9/oKJgT5zEjyVGWK/0nxIQCBnj0mlAmsfNkBFjneyG7fIPiFxNWh348vRy8yI=
X-Received: from pleb12.prod.google.com ([2002:a17:902:d40c:b0:264:6a57:a799])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3b88:b0:246:eb4d:80c8
 with SMTP id d9443c01a7336-25d2675de07mr140073345ad.34.1757971683955; Mon, 15
 Sep 2025 14:28:03 -0700 (PDT)
Date: Mon, 15 Sep 2025 14:27:55 -0700
In-Reply-To: <20250915212756.3998938-1-surenb@google.com>
Mime-Version: 1.0
References: <20250915212756.3998938-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915212756.3998938-3-surenb@google.com>
Subject: [PATCH v2 2/3] alloc_tag: prevent enabling memory profiling if it was
 shut down
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 27BDF180002
X-Stat-Signature: z18cocqqk6h5gg7q9e6xzjsmxorzzyku
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757971684-184369
X-HE-Meta: U2FsdGVkX19+vkvda0fM4cTKLxbEI8aBk5vvb/FmRRKcH+Nchime2gG9RtvGQV7afouU0bhds0B+35CpKCjz/TyuPflk8Hi3G4LZ7ehxy0ZC/xPrhjVnw5axc+29rJGkXsQJR+Xl/pgLyodwrwy/y/Bx3QZmMjLS5fhOhjrlhGwJzlvTfcAGeBmNMXf2FxqJ2ObZPJTUVxTX20cLhEzo2AZFsmVOH8Vp49SsjfklPHbBssvKEBidsTeD5noaZ3RsHTNVX24D8fZ4hAfsBX20YFxp3c8xDYVm6uYkU6Cnq74Pf8He/NFFw+VxbbrghTfTSKeZ8b2ORW06RMWt7pQ996S+TkIUu0O6tF7GzLXPTTmGQckUq7oCP802/875mg2aZZ6qrDaL7TBTxdgq3AqhvNwvwVIgVvFQoMA0M61kTgaRjGG8Xv0d7DxzUC353fFfCbZ5gqzmTWQToSTHhiTtZUrGn8FEwRFsP/dBDAWaqsBmbRl/aNpIN4vZTwRo9iZpXuEHEhl9tcJYkGFscjj0eww6stywyVc7CnbxOtur2CayM92Ypr6mBr4rWDgeUcX06TsxKrR9dG03aMWmxYhDcsyXkEv83IxbUW2rXONJo6wjl4AkABVZpAXglkfAYwMkQrJjgaK37/QPJbdf0gcvwwnN6LAMGy9WNyMiuJZueaORlirKnVTWMNsZNB1YkOHfZQrwwYA8sTeEhi/zg19Izd8jLEmDtFEldGVYrthhLniG6I7XG7svRmTBXpUNikAXIKbFJQeZbaiNkrAZCa5yKJgTC36xDfdnmdgjh44nT5pL1ge4FmvnOCe2ANbYJwOQtYSDsGw4RJ+gkpOXpbpP9z2VZ1eqC2SkdsHHCKXGhYDFpPk/bosFg24Z5oazFGY24N9ArlMwRSECEokcHbcejU+HHuPdxi35g7gZTt2+Sha3VH34tTHeq1JfRP4j1lrf4lBZIkn33HsuxGEej9n
 S9hlmrFw
 syXcq6Vhyl05eo/Hl1mteBed1rpMa4cQtM7p85NciptqzcuriKrgJ2kfLWlzAo8bzhz7YfuC2Rswqnry3ZZlawbAh4g55QDICUrhF96a92hDinnddY4nr/98rszDrLlp036x/B+7UwyMU/4yuS5A5akG0EAgtjaUaMHmywfy8VLk7d7sp24JLN2eDcHfx8uezqnL186n2ECTSqO1HDYdHXc3qqHcIEVfx3sQYqM0R0N7PTseYdUzOt8lEu7gtZZcefEX7NtZSAp4Yr3xciG7Fw2pT0GJ/txeCPiH0uWjhriwKuOc2CaCbb4bTcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory profiling can be shut down due to reasons like a failure during
initialization. When this happens, the user should not be able to
re-enable it. Current sysctrl interface does not handle this properly
and will allow re-enabling memory profiling. Fix this by checking for
this condition during sysctrl write operation.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Usama Arif <usamaarif642@gmail.com>
---
 lib/alloc_tag.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 715315f5d9ba..f79217427d81 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -766,6 +766,20 @@ struct page_ext_operations page_alloc_tagging_ops = {
 EXPORT_SYMBOL(page_alloc_tagging_ops);
 
 #ifdef CONFIG_SYSCTL
+/*
+ * Not using proc_do_static_key() directly to prevent enabling profiling
+ * after it was shut down.
+ */
+static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
+				      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (!mem_profiling_support && write)
+		return -EINVAL;
+
+	return proc_do_static_key(table, write, buffer, lenp, ppos);
+}
+
+
 static struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
@@ -775,7 +789,7 @@ static struct ctl_table memory_allocation_profiling_sysctls[] = {
 #else
 		.mode		= 0644,
 #endif
-		.proc_handler	= proc_do_static_key,
+		.proc_handler	= proc_mem_profiling_handler,
 	},
 };
 
-- 
2.51.0.384.g4c02a37b29-goog


