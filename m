Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D36AC10BA421
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30BFC6B00A0; Thu, 26 Mar 2026 23:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295AB6B00A1; Thu, 26 Mar 2026 23:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135C46B00A2; Thu, 26 Mar 2026 23:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2D6D6B00A0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96642160C34
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:40 +0000 (UTC)
X-FDA: 84590423400.25.0F6858C
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id C991C8000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VQTcUIFe;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582418; a=rsa-sha256;
	cv=none;
	b=JoRaSVdOY36m2BL+LDY9h3ipDZgQwBfCbHO9AtKjXtSI2RAvcq3V8M9rC6fT3N9wdc+44Z
	Ca/BHU0jZVUSeD58JSouax+6bmwum9Imd7RyKOKmtFOVgf5gN70sDDXuNCQK0nZ48vLtXN
	qZqNSe9wBbnMkjhopx3xKEs+cAfKey8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VQTcUIFe;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLvspK1gu6gX+80jQiUMF5aw95bvgPpDygvOrl90xlM=;
	b=QzUSqopbaN7cArhmReRrImKleP6s57lWfyI1VGmxsRxv64M1g4bwZiLM1O8xWuRyc/0kv+
	S1XesSCuv9N0B9YTSX6dbAg0UTSKcuMPesIjC93HkyPqi8aD6s1t1xpiELIKlq8L89g+37
	jxhcsW3Zoq+K3nMXw/TszR318ln48Fw=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89cab686a9bso12275626d6.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582418; x=1775187218; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uLvspK1gu6gX+80jQiUMF5aw95bvgPpDygvOrl90xlM=;
        b=VQTcUIFe/tTZheisDVReifVndr5BnVHSQDFRt9i+hm2Q/VKUqckddbVc2mL+xk3TbW
         yY7vqnEJ97ETrdtAGbW8AkAJEJlqggus9niezy4K32kTWj5cs8c6kJbqvzsJrREpSTht
         ZVExr/l88Wz/icSpB/AQlKJJ5tqTUJqOqWVsw6bsED9fJWiOfbc89Hq+ioVGaDqPwAj+
         2gTnqAlzO2IYAkbudGYs9W5257lI2yagqRZo6DLwhBwoXIixcyeyqroIv9pqIsDpZMdL
         1PD/fI8+3SkFZovJTpeLDhs4sulmDaCBz8ZiRX6f3z3j5ajQ8Kp7J925gChoJqX3V95/
         1wbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582418; x=1775187218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uLvspK1gu6gX+80jQiUMF5aw95bvgPpDygvOrl90xlM=;
        b=MNNcpTqmOtnsMn94UlTlH95UL9dPd/xP9957Q/Njsv5v/LL2EKUqKuhM7l+ETieEpN
         +HbbbUIgzZdeLpcNQ84s/O5n9WGerRSGYAhKA9HYFvbZ1+6MGuxMvtVDIiq2LH9BxIaj
         xGdRXrinQvhb/IWASUXbA/B8hU6nCoslr7IWNsgVN4owlch+bEQ44rIuV5YFdsiohskN
         p6XBsxAjeeDHjqLi82cahoPEccgcB2PqG7jerChlfkDmf+x+dM4tiIJTMlAqErkuo7hT
         HP7ORjEpAJQ3EYW3HOt3KATl3YDyqJOVCQHZHzjcPJWAAo2tdXtlUjk0NkT9U7wBA/z6
         MUow==
X-Forwarded-Encrypted: i=1; AJvYcCW4Kn+YsOtEpm2jI4DKWXotSoqU2ScGmu4CDeTgXMkkSQCGV7jsBViranp4JuBbjfgQe4QzcJT45A==@kvack.org
X-Gm-Message-State: AOJu0Yyj3/pUpyYSN/8L1lQGs8cNAvshd5AOWOep5sr52IqeV6UxdjYR
	W+H9ZkeWDSH6c/GoIlkUmyikRqDYcQne/4BW6IsCuXkE6pvpaBv6ti1viPIIBfPDNOaPUbKvw6d
	xK5Sc
X-Gm-Gg: ATEYQzw+N2ZH5W+/+EfyXQEYbMhYeBtC4TtfylB0CWsT9H7Nxz6Da2WdzcCDYhKv5Fb
	D6Oxm/fh0T+SwVBnUpCDXI4AVs6/tBTAR/FglxyJiuHS2A/N4EFEXHHpJDroiaNa/kSXjV9EO9S
	i8u+/1O+zTXOHX5f+kgPDmpKXt6uCEkukI9mZg5zQ0foIFrz9vovC9QrHtV297tOeoRPCZgdBsQ
	YxgAj/IbiXWkin1CJ2a/yMBO5OQLjnqXJ/dyBMPxrlQGjUoBubkBuXofTa0SXibD3UxJg5F6IfF
	lRopIG1AwcAqz83xSK8ADG2K5WB+sV9L2ux+fwMiW/2noM748PkZ4C2vZk+N8jlcldWEP1C0jsz
	T5RREOXNYRN6zYC6Y2D5NIhxZtyAvcbw5V0hAQs0JIXCQM3cI6F9p64LcdCGr0DIWKYX9p1FtRI
	8d2su+SxLXnu9Pphn0dcHjonxVmiy0xqXZb9JESTyrV+0PEBWZkgRfA3lzmPcptxlGhg==
X-Received: by 2002:a05:6214:3d9c:b0:89c:5d56:bcac with SMTP id 6a1803df08f44-89ce8b87d89mr11941016d6.0.1774582417846;
        Thu, 26 Mar 2026 20:33:37 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:37 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 01/10] liveupdate: Safely print untrusted strings
Date: Fri, 27 Mar 2026 03:33:25 +0000
Message-ID: <20260327033335.696621-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4uo8ex5c5y94k9qunbtd8kbr1zckd1s6
X-Rspamd-Queue-Id: C991C8000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774582418-158669
X-HE-Meta: U2FsdGVkX1+X2//TzPRZ0a2IS/EUzgPu7jWUEZ6NeXnsjnfOA9lb/ok2QDsJn/ZUIsr29q/8GJAFbABWcQ28yQpNTbzoScn+A9Ml6oI+T4fwmzMW97gJNmyW3XHnRlXmEJ2tF6GjEMaZribBTMdEs2JpmT+//kuQO04wVk6uhDG8LVeCU7cex+peRrwnyuJeAW+oQXe1UysC3OPNR9BFTqiMlYzWLxhH0k6h5TGCHVLzmJNAW4ALGLZYce0N/TbQXrM4NbDGk/PMceF5b6+/itW6P0sVkt1eKVqW8WyEQP6SYzacGGfY1NX5F57ZhCW/bwEuDlIqKvFz1HfzF+dFq27lgmXEzQfdpFbz0g/3Hdbk7dHyKmRhEsN4FWf8v5j8NhaXQ9RgCWD7mPORCAa0MzEslAdhZU4GWISu3drS81nDO3d0UnyHnt4TBTgvHtnVXRhGPd+nT7ZdB/Og3DOXdwNn5SeJTqScUlaFO9GLYPHXAWw0nMgKTLRZ+NbHCYx6BlgfCvtbzNzj3m185HlY/lOIQ74Zglu0H4C2fUXK+2FfsOI2nJO0AQBxizbSv0ZkndzPdjlP9yjj7JrM6UIYcWwwCpbyXYig3rb/u55oT/mOAsGkmXUtWK9cu7qFWpeAzWz71g8olMMCBiXqqVaJqbsTIxsFP3+aPi1dwHPdZJubc6Gek7suRxNUWoT7RHuj0qcrzyceLpTlBN4xE5r+fpzKxpvAifxs9KagD0UMrQbP6JYZSO0eZ4zyQNj/RLNDoXtKiNyncHTSjTpkViJRygpNNKCJP0p7ltgKgKXKmyOGQgGV54COqHJEy+YbpRQ095MhzaO0eQZ9ULynBlh/VeyVWXBqU4AAO8Dl5kPo15h4v9loxnTMRjGvT700xHfcF8JLk9prhN+ASOSRhv3K5VESPayMBmexDndwHlykVCOPozSjOGcBV9RiHSap6Oz9UfzMWHkldNvBeFke8vT
 xi4txa0X
 e8TgoUmCiymtRTQOvnlku+WNDfhG/wcWL4yNjommji5ekvjfiQLuHn2L5uocny+uF6cDlb0uyGDlq8i9Ndz7jj7mEqUzuO0SXYyqGIFHz6kfm5LO/UHUjhglDzperXwSks/oihEarnX/LdE9R/hm9Xyt3BPR3gIPHSEH56YWhQxJRBXfoeer5riDXZGHF5qgFkiqeJLB64/30S4wXyRcDaacym9TJSO7yIJ5QxSEcDQWj9Azh6tzuGTlwmJczD5Vdzo3Cq5Xne3NuKvS2tnRmlVIo0kVC+lgLWmGvA9AHeInsSXIJ0FHlZ+MxhuPp6v8Bj17pGEtL5C44PCg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deserialized strings from KHO data (such as file handler compatible
strings and session names) are provided by the previous kernel and
might not be null-terminated if the data is corrupted or maliciously
crafted.

When printing these strings in error messages, use the %.*s format
specifier with the maximum buffer size to prevent out-of-bounds reads
into adjacent kernel memory.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c    | 3 ++-
 kernel/liveupdate/luo_session.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 5acee4174bf0..a6d98fc75d25 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -785,7 +785,8 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		}
 
 		if (!handler_found) {
-			pr_warn("No registered handler for compatible '%s'\n",
+			pr_warn("No registered handler for compatible '%.*s'\n",
+				(int)sizeof(file_ser[i].compatible),
 				file_ser[i].compatible);
 			return -ENOENT;
 		}
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 25ae704d7787..8c76dece679b 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -544,7 +544,8 @@ int luo_session_deserialize(void)
 
 		session = luo_session_alloc(sh->ser[i].name);
 		if (IS_ERR(session)) {
-			pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
+			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
+				(int)sizeof(sh->ser[i].name),
 				sh->ser[i].name, session);
 			return PTR_ERR(session);
 		}
-- 
2.43.0


