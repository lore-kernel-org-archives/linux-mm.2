Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFA8CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6C96B007B; Mon, 18 Aug 2025 08:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C882C6B0098; Mon, 18 Aug 2025 08:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F8D6B009B; Mon, 18 Aug 2025 08:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0A56B007B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:28:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D18983F47
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:59 +0000 (UTC)
X-FDA: 83789807598.16.A207BB3
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8FBC61C000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:28:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ImOgq83x;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nxh86RQjx8x9Y8+TdxwdmIa/RJOrFh+0RUsbopHZ3sQ=;
	b=0g5qvuH/e1Tcj0eTy5PwU+218WBh1fSlVP9xU/fnmpG6NN2JBQNQWwzI3aPZH/oJayBOBh
	yMqqZGgQ6LcCeO9sAdedx+tH5+QFcc9ncDYzhLak78hzWYuLbZ3M7Kzpr4UNQ2X3ud43J/
	MWtx7WnZP2twz8nFN0MB2+sFa/6UebA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ImOgq83x;
	spf=pass (imf21.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520137; a=rsa-sha256;
	cv=none;
	b=Fpqx7kFcG9Q0f5zZc5Pqau9iuxOXml9nql/QZXkRpeQLL+yXya5zgIguvNEphFB3Jjeae4
	HosGIvI9feBo/B5glT5eQHpBnvAR8VYy9AplvJ4sndID3i4S7dxgcSvfyCACL4cmTOKPIP
	0F38uZV4i4uJ9x/8rc3m/eRNzo7rKYM=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24457f47492so26238815ad.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520136; x=1756124936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nxh86RQjx8x9Y8+TdxwdmIa/RJOrFh+0RUsbopHZ3sQ=;
        b=ImOgq83x7l9ZjOyjG3mNZvkcADTjlwDsb2spkMHvXA4pBDcCFK8Ib7u7o7NLSQF4t3
         R2RgxI5P3480mwslcqu5Lj9TKx2g5PModl4QZ9HK9do3E8S5UyjwsJqpGIYsZNYMc8mf
         fdv//Uq7uPIdaDblnkAPsytHkhX93hrxNE9Vfqd55w24MUmqFlxGiIBknz1Qilh5l7jD
         1nfOGKT2QF96Mibbs0y2Sjmx+tawr4MWxFulznC0Y+Tt2PdWkPQeXeyQY5M8SlXJNBS3
         iTIryEdViuCfuB+QFHPPbHBYy1fSOHonzhQokk8v1Kc3BsAvft180IygvT9LAf8P+DOm
         Zfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520136; x=1756124936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nxh86RQjx8x9Y8+TdxwdmIa/RJOrFh+0RUsbopHZ3sQ=;
        b=gM/ohEUdcnzldbn0+xLq+VzqEqDSnMGT51R9CU2eXPtYHwGeYrCAcyNK5QivYOWCOm
         Q/ESSszCR7TiJdqEEG5X7/paRTJKYrdygbLw/yCOZ/D3eRdW+V0adq9aWAWz9dCtlJvk
         ECf9D1kbD8zQ2AeBWGVuQiwj+mOp/58UbRLHI+yvXSHrC9dUPiuWzDbydw+OdP61r9nt
         CPjOcj4bBf74jEyq8VjEf3q4t1yFmNqpOKOXxq94EhpdQYdEb4kWFzM21Ci2/XUmNMgW
         m0W6QjIYzri+/vQxkzreVqfXwMpX9xwVJAWsI+80ye+Zhpo+P3eI+IMF3G7BtiKktafl
         2Haw==
X-Forwarded-Encrypted: i=1; AJvYcCVx4eN5qImOroOoPxpab9kYG53SELJ+VJbClFYPnLm5XiCB3kami1Ri1Saug1Oey+8I4Jrf0HqOuA==@kvack.org
X-Gm-Message-State: AOJu0YxdG3JczVHsfmME40OtRDlioREMyEfy2uii1O0wgUqdkFmNIr2N
	4oVvhbSbNv/U4AmFOfXBZwwmoc0Ffgrn63L8ZKasbVo2HuJ/N7dWXkk5RXVANj9me9xxEQ==
X-Gm-Gg: ASbGncs2Fg8u2XSHN1nizfJKu5MPGgajOXALjZnECTXp5T3kYgzOMxR5XvDJjsgDhaa
	wn+QywQiS8uq31Dtp6IEUYaDtSqkHbPQk8FgtWGwbrXw+LW/bf2X4g6BRdGJU1NI9aULiBWa+2N
	r79YKjllgeYebjRWnmuY+67Yz7YytR3Qdh4qPBNU3w8VZhRZ/j9zl2oOPzczE5jrcEo5tXXWSW7
	XzPGN7SwzoweC55IYs6+Qe8Friueunms2CLvaArfDdyEfm0QKcI2eMbuAoauxOd4fybeO6Q91EA
	ke4FQFjLTSpN4sP4jnV5/2Q4d5yKN7Uaw98m9Cp9YbtQBIAhbk9TLuJO+wNSlO+ClzPQcHBws9K
	+dNzJSiAlhSrGxt78i1MgzscNdPxi
X-Google-Smtp-Source: AGHT+IGaSWeKYBv3gFakrVGYfHWtsjon//FUbcLW3c3fM5l7j3n889K+m8tBE3IoQkxw8ZsbZ6mXEw==
X-Received: by 2002:a17:903:3c67:b0:240:6fd0:25b7 with SMTP id d9443c01a7336-2446d8f9568mr203579095ad.38.1755520136340;
        Mon, 18 Aug 2025 05:28:56 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:28:55 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 12/13] mm/kstackwatch: Add debug and test functions
Date: Mon, 18 Aug 2025 20:26:17 +0800
Message-ID: <20250818122720.434981-13-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-12-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
 <20250818122720.434981-3-wangjinchao600@gmail.com>
 <20250818122720.434981-4-wangjinchao600@gmail.com>
 <20250818122720.434981-5-wangjinchao600@gmail.com>
 <20250818122720.434981-6-wangjinchao600@gmail.com>
 <20250818122720.434981-7-wangjinchao600@gmail.com>
 <20250818122720.434981-8-wangjinchao600@gmail.com>
 <20250818122720.434981-9-wangjinchao600@gmail.com>
 <20250818122720.434981-10-wangjinchao600@gmail.com>
 <20250818122720.434981-11-wangjinchao600@gmail.com>
 <20250818122720.434981-12-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8FBC61C000D
X-Rspam-User: 
X-Stat-Signature: 6mnmcxnfipn8s3nfgypgdc4tb8ookpgw
X-Rspamd-Server: rspam09
X-HE-Tag: 1755520137-640518
X-HE-Meta: U2FsdGVkX18y7ZysjqXEeu8282mtdZzbugX0+qq1CdcAL4AQuWRCfMAS/0sVZVmeAnhLVVuhImff/V5RgQ3akqqS7yF2nOmuITcYTQX8HqXbpKSGgwSN4+hDRXO8YzUwFsCKEM4BgHhY4709mq+CKYBpnpu2EHDxNUCOkYKhd87Cu6Vbyv1LQe8tS1xiwm49dw6mtFvZAus8326bE3ROT6tk0JtqAgvU2jdQUQoWCjGReyJPTEzxpaIjSxPXSnMdULaqSkkfzh/1jnChuIKNPYkr0CrbdEVPSa9qIrxyjrLxG7fxdg5LXpzDHOfkPlh7RtrKZZ2M6x5f9J5HvPGqilVQZmA2TSJXqzZwSdZdVHzqok4b4hzTJerSutxnBW1Z273fM7SVCf67BvMOhQDkKHj57ogeoHk7lun6YyWmEYytzrGkV4mkN61MfRLHujsbYGaLniaeSr0vM4f9sZmxvhsalyrOl3Q0VXMJgD5U8D1qBkFNjeapaqPa2usuRsdPzKjjB9Qx/7EgNMdhyffzfT5JH+XpH3W7R98+LdYISUEfwlbV7JaT0kWHf5I1O7Sl8Q3fOiXs37n9HG8FhGKmx3sXT3LtKUjuagjtEFvAgj5pYNPCp6jFWMQp2KTFOreX2kxRnZ3buIeeAnnZVQ8/08YJEXGCaMwV1qbRHl1Py0OfHRgmgQzaqg+WZivLPRrWZbFKmKl8OUdUEPVTORmHVntn9hoqJ1H+mIlvAi07LrcGxJdKP5wiA6xELY7ZU+rfT9yTBySTFHJTm3mvR/EHJ03Obxs/ngJL9RpfCnySi5nCNSenin2sj69foFXuAw1w9EuJUzOaIZSj30J0jg2ANzPe25yC3qAlDpwJKu2A1Nb4Ha5x6wWONvkBtQA/0+/Ywr5o9AMdQ7ussWeQIuQm9H2Jc88AgxClPCrAgCHjwsuVnaYpLDmgA0jvyJS/kPxaTo7Pr2VlT69lxaFudI+
 vD+9/Vk5
 DouWxO/fTxt+ML5EKznkth/HfsLls2UFBHySDg1+uqqh9PCBVPrRzW7CGRriFGevadxyNinJaLkEJ3FRljyWTMXBBPAzu8ThBC3+w/Ks3O//dORe8wEdVxtyEZ/RPTwBGSj9Q30HOAQhX8qmE8XKHtFu0c04hsMEM9LUfCv57mhyN45MsVKS/zISLne1MsGhBO9JaDnBOHrakkG69Qv/sTjsXrQz6t++wCBh+G9gF4WBDhYD/C4hC7D7wWt0Q8TDXpspvKNnRLN4yLXWWlJHvGMi+9EU5s28TI/1HZupwloTHtYqh2ZDBvt4e2LnmntRcoWMhBdSxhze8BbSQ2MTS6ur/IYZPbpwJKHEFu+vmFp8G4D70yM4a7jwHDNX+siqbWj6mPFMa1FvtL9WECybFYmlgdooMT1NPrPd27Ob6Pf9o3k01p8eG/fJbB02Mf1NA+KePrOzJDRXpaVw7CDqrsjg206DSGeG9EO0Vmysr+msDeJOyBS+AK1bnzWzpCqBcmzMC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch adds new helper functions to the kstackwatch module to aid in
debugging and testing.

- `ksw_watch_show()`: Displays information about the currently active hardware
  breakpoint, such as its address and length. This is useful for verifying
  that a breakpoint has been correctly installed.
- `ksw_watch_fire()`: Manually triggers the active hardware breakpoint. This
  function is for testing the breakpoint handler to ensure it correctly
  identifies and reports the stack corruption.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  4 ++++
 mm/kstackwatch/watch.c       | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index c24a651977c0..27c71a9391ac 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -2,6 +2,8 @@
 #ifndef _KSTACKWATCH_H
 #define _KSTACKWATCH_H
 
+#include <linux/kprobes.h>
+#include <linux/perf_event.h>
 #include <linux/types.h>
 
 #define MAX_FUNC_NAME_LEN 64
@@ -48,5 +50,7 @@ int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
 int ksw_watch_on(u64 watch_addr, u64 watch_len);
 void ksw_watch_off(void);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 1b4cf5d42db9..28ea24e4ae3a 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -218,3 +218,23 @@ void ksw_watch_off(void)
 	ksw_watch_on((unsigned long)&marker, sizeof(marker));
 	pr_info("KSW: All HWBPs disarmed\n");
 }
+
+/* Debug functions */
+void ksw_watch_show(void)
+{
+	struct perf_event *bp;
+
+	bp = *this_cpu_ptr(watch_events);
+	pr_info("KSW: HWBP info test - bp_addr: 0x%px len:%llu\n",
+		(void *)bp->attr.bp_addr, bp->attr.bp_len);
+}
+
+void ksw_watch_fire(void)
+{
+	struct perf_event *bp;
+	char *ptr;
+
+	bp = *this_cpu_ptr(watch_events);
+	ptr = (char *)READ_ONCE(bp->attr.bp_addr);
+	*ptr = 0x42; // This should trigger immediately
+}
-- 
2.43.0


