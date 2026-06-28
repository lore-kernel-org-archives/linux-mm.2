Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C853C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 13:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACF16B0093; Sun, 28 Jun 2026 09:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85DB16B0095; Sun, 28 Jun 2026 09:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726B86B0096; Sun, 28 Jun 2026 09:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4016B0093
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 09:59:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE88FC1B3F
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:59:06 +0000 (UTC)
X-FDA: 84929477892.18.9D4D552
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 065C040002
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 13:59:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cBlKq9Eg;
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782655145;
	b=8Sz5Ea1xuxVrLU9scb5cXVRn5pWcuLjcftDmwNpGLrvtuXhuqwKKX8S4qdgajFAwZ5XeMT
	iYLSgnfTWt93PBeoPbvde4skGykLeuXj2SBxoqg5XB5rI3tpQoshTDQXVmc/jCZKshD02u
	JdOlA+2olgO8WClJtizXDL+lOm5Wojg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782655145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNHfZ/y+guhJuHrRJq8K5dg8CFW33Z7HYPgfPFrilgI=;
	b=qUiJXpNTnzLZ0asJkpOP0tgy2siUd1Oq0ToPvrrhVPRHFde0BMY6XsdLZvliEakktHcxz7
	vjWTbu1bttaHkl+POjpZv3Gg4mdFBLJFCAfDSeYVFatXpazhQt3GG5ViGvhDE9UPa1ES+o
	PYVNBVWfTF1ib/A1CfLUnRL94ucr9JU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cBlKq9Eg;
	spf=pass (imf27.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-845b733e82cso1502450b3a.2
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782655144; x=1783259944; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNHfZ/y+guhJuHrRJq8K5dg8CFW33Z7HYPgfPFrilgI=;
        b=cBlKq9EguPiBYQ3TsEC7NSa1+aH3wVQO4r0+3D3V2NtzdvPRaBtdlpHnUPWn9xxbuW
         zTqOoGaohOIIesoqPgXLIKuB0bcl2A8/x9Nbiqr7ekGqDR07/ss1vEcYpOBDZI86AwRY
         XIC6SJsZw7GsmSScGl5kxFmI68/EWy0IJCvBYVm7a9nwuJfzmr+fuW0HOzlh2eT+L+C4
         +pfZFa8rZOKmXadKc9D15S5lHcFvcHsVBNCPHV8D0CJea0s2d9slAkxd8wGWE+XTNIdA
         PsyBx08IKRY4DHiWCMSTO6ec+GCw8hEAjVTNtxAei1PA9YpPWRenoSGJ6+LrIPVPvdgK
         XX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782655144; x=1783259944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eNHfZ/y+guhJuHrRJq8K5dg8CFW33Z7HYPgfPFrilgI=;
        b=iCVBgbYZpIdod+vkLYoJ/rQsE1OqIRqWIUSO2DNQmclC1UiDvKVAtKw09XFoAwEdYQ
         ImVSb5hzvxtij2e1OjuN3m4R0mjRGzUKIfmtzz4nM5dNGMqMlbV3QGHXL86a6YBpBh9a
         nllQgU0SAOaZw0jo8aAee6zc4Y3/tOi3LZnhtdvylcRnyuB3tFu3skhzlxBf5s8Z80qz
         P5547AZJuy+4sHdICMdt1f+pLe6q4hwAIFjgOn/gYN3QvsRiW+MTg3pJIsgv3O+T4eI3
         Sc9bbl5uiYwBvXvIvAtvoVk9zmwkGQdOX20rCDMNEUbT9UVNNMYy1vap3tlQ4wD79LaO
         ihQg==
X-Forwarded-Encrypted: i=1; AHgh+Ronp4vZ7x01OhJtJqfGJyjMFxrU2hpwvkKByaUH7ioLWbetrxVLkFJhCD3WSzfa1ViiZoOADdh4YQ==@kvack.org
X-Gm-Message-State: AOJu0YwsR9xb8MAyVTKCx/e7rddTs1yNKVHXYaCMYe4WbDhzP/nI3jyp
	Ho+bjfW1NW8NuSv6qtf175XCvMip9YMq6FnoOXCe8Gdp6KB37/JnL+Eg
X-Gm-Gg: AfdE7clQfGIV3hb1KKJa5b2sPLE1c8aCiv1K47plFdur1oULMZod7jzz6nxaxpkyVI0
	t/hAq4JvKAwM8QyUdwPAZF8daQO9b6UC7fmhYousnwloD/a11ihY0KAa+0O7J4KcV10cD0MdgD1
	VsFnwFtP8CMB/Bt73yC488dhaxfdC5H7jCh8KoJwrrNhRCYiTcj4iq5smE4+d1y6buj5j3wNVKP
	BLZn34/8bVauSZAmBycONFewYPvxDNyXbsjsLoL/acwXx7EEPSOTr5+UAZuu/znvpUOAZD2g+Yo
	47zpdkD7MeY59GUtp9RKkb9yqQwcuwHDgZMtOEcwdRriiRBB8CkQgZilIp8tzl89XncHbzn7akv
	46AMiJt4020K2hQt0Nxl/GucWoZqTeF5BqdbJ75y0auNkOC+4ogkfgBTFLYP/OK8iJ9H/eKJKt/
	xtVZwB/f0=
X-Received: by 2002:a05:6a00:91e9:b0:845:e41f:9696 with SMTP id d2e1a72fcca58-845e41f9b07mr2826646b3a.25.1782655143970;
        Sun, 28 Jun 2026 06:59:03 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40d23d7sm10041108b3a.30.2026.06.28.06.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2026 06:59:02 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 7/9] mm: numa_memblks: remove redundant numa_nodemask_from_meminfo()
Date: Sun, 28 Jun 2026 22:58:21 +0900
Message-ID: <20260628135828.1393120-8-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260628135828.1393120-1-ekffu200098@gmail.com>
References: <20260628135828.1393120-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eiwx65mpxin7amz7pdaqwxpmsk5tyrh4
X-Rspamd-Queue-Id: 065C040002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782655144-224921
X-HE-Meta: U2FsdGVkX1+3NmMP/fOSpp8G8lFpZhpuAfdnnUHTWpWgb4dBQpYI927BswYM2c38V+VhS88TRvl4h2eEzmnFgMaB62Vpww8+yY+99Pj2sCcxvqudwa0IGW973QdW/UjWiIjfHJ1Su+unWwwOkpQUj+y6y8IVD9ZB92G3hqnQ5Faqga3bSHbLxHnNGGotNScVm5YQz3+mrTN2OTkOX3DWp64rxHUBDr96sOGX7t6wmys+Rt3kwrhzOnc+7zD7rg7sviNBX+EPMmdnmYaFXc3am8omz6nMtUR/3KTz0BGlzC4P6S7czrLbNTEVd27yh9xL9rOvqkVQqhhSbIVqZ0fQNd6840ryGyq0CAknB5qTs1scXB2wJFZGpYkublmWiD28XtxqKjNbzSG+Y0C8DK4TOtbtTPTRx3BzGcRwT3/DjIRWGN5Qtmc3Shv49DmnY1S6e2TXRg+Ufw10wCsTNf3EbjZyllHdpH6E0wMGSIFhCkcRtHdYfaHVn6aUEM0+mrsqWVIe79Pn0HxSU7ptEEwkjiXWFgJ6C+oVZt8Uk1fXb0UClWMGIc1u/VHPuIDVxC2CqOf3eM0TKaEqUbuRRKtMqksXbIUo157KrRD/QRaC67dygMxv4ReQtoB1VToSSu58qr0u/5SFZ5gkHpey3cvVV4tUnCRqidKrFsSYyymUZvkLqbab7ggOzIwDdF79+/AuxLz8ncIOYSDBPPyiiPhpLHdvjDFA66nTXPv0G0/3G/u7dcowEUTQY+xB1vAsUarMdM0WEkL7w0ieulYGObUThWsHESvQJRRDNgOwIyCBsbUkeZuhJ7TXAv1IeRVIt5/SD0XrOq37rQrr3+danJR/OWWyFdTWw5UV1570cSt/fE2YZ1+DMyEK4aRnA/wS2qs07fr7KU+EXYBubN/vl6diUmfeIzIZCdyBzdVdmTiaV8KkV6wFoJjz6P8+9MqfNf393pQZh64Xfb2HAPtOMbt
 qQ/ebqcs
 w8lyJkRrT+4sDFUNAjSyaihxlEDxU+lLP+5ng+IhNsbsmGzHj7aMqjExJEsn86XtuZLOQRB9JWEEW8To2f9oSqffIVN55s1MqRxXqawPXhzm5nEE6J2tuyxecSG2D6PuO+Qby4C/a1TWIavbU2X9Uo7df8RwWXyEIKPsfM4brK/3gEk6jc3tlSHwuQ4ymAThAvg1deNIgQZSZbjIHVZu+Qhq5U+jhMY3JMbpaAXTJAZmvYevCLBVjmfoapPRCb6XCMXcmSYNeP28O8GwqcOxx+WOp1Hrjg948G6XngvSBXGQckEViuQa7XWa2aHt496TwnAeUUrFTBa4l0+zi4L/M+jFGDc6XOY81Doee8ZXDMT0y4gSO7IZX8HRJKsnlXWS6vZZnKF0WwUVVoilVI+yXsa/Pw3cMFcPk01ColkhRUE8BAM6hu5qcnXKQVE+XS5CVbhWjlNOuxO0MVAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_add_memblk() now sets each added node in numa_nodes_parsed, so
numa_nodes_parsed already contains every node that owns memory. The nodes
numa_nodemask_from_meminfo() adds from numa_meminfo are already set, so the
calls in numa_alloc_distance() and numa_register_meminfo() are redundant.

So remove both call sites and the unused function itself.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/numa_memblks.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 2d92ca38c02a..edc231538954 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -17,20 +17,6 @@ nodemask_t numa_nodes_parsed __initdata;
 static struct numa_meminfo numa_meminfo __initdata_or_meminfo;
 static struct numa_meminfo numa_reserved_meminfo __initdata_or_meminfo;
 
-/*
- * Set nodes, which have memory in @mi, in *@nodemask.
- */
-static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
-					      const struct numa_meminfo *mi)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
-		if (mi->blk[i].start != mi->blk[i].end &&
-		    mi->blk[i].nid != NUMA_NO_NODE)
-			node_set(mi->blk[i].nid, *nodemask);
-}
-
 /**
  * numa_reset_distance - Reset NUMA distance table
  *
@@ -56,7 +42,6 @@ static int __init numa_alloc_distance(void)
 
 	/* size the new table and allocate it */
 	nodes_parsed = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
 
 	for_each_node_mask(i, nodes_parsed)
 		cnt = i;
@@ -411,7 +396,6 @@ static int __init numa_register_meminfo(struct numa_meminfo *mi)
 
 	/* Account for nodes with cpus and no memory */
 	node_possible_map = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&node_possible_map, mi);
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
-- 
2.43.0


