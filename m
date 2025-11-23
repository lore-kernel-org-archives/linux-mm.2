Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33793CFD312
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 03:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBB06B00A2; Sat, 22 Nov 2025 22:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B30F6B00A3; Sat, 22 Nov 2025 22:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9896B00B1; Sat, 22 Nov 2025 22:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE5786B00A2
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:05:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D236140A99
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:05:03 +0000 (UTC)
X-FDA: 84140380086.05.5B7D77B
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9A3C6120005
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:05:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dZvW/LcU";
	spf=pass (imf29.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763867101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bNgBXVliADaREJ6nkSovsbUQBYpNGNtzg4nO0JMTz5A=;
	b=rARgXRLTtVrKczIXhh69Xk0tEboQicfpFDgBtCOvk207kSvknQ8fMjZ3eAgr1R4sOAdx7F
	xlxR7SZQBIG0QcHvnUwAgzIq3fTs5hnEYaNmnJJF0gyf1W+VMlfKRQH6hAgEw3FdNwZ+nP
	P5Le1nMMbU2SuhWK+tFaLcR/oQ68Dg4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dZvW/LcU";
	spf=pass (imf29.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763867101; a=rsa-sha256;
	cv=none;
	b=4pfD4MjHMDhu7TmNmt6qSnRn3RZYS9AZxyWjU1csvn9w/1cNN6ve7vQjMkuagr3YBvn5Yk
	nkaJTmoJqrVpSV0b/2uYWCW+AH87KTK1C/tVf2E9DWGPiyv6449dp7dYqtuk0gsatO5i/q
	tH7j3rmJ/oPE1e5HoJJ4fkS5G7ztUwg=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3438231df5fso4203450a91.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763867100; x=1764471900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNgBXVliADaREJ6nkSovsbUQBYpNGNtzg4nO0JMTz5A=;
        b=dZvW/LcUcm1HR4gYO/dFdo0KxczlwhV7D6JALKgvaLA0ZKZdzyEeI/zlU9nolrh4Np
         US+GW3tEe7Tllik5AOi0a3WhsTvI7XX3NhP2Vd5GuueOiTRqwoS9evDCNuHTGq8ClT8I
         D28jCeZYIpKWe9uw8a9U8p9FGoiCqknTRP7s1r73lgvWQ3pcybsI/SW9A0bUVNcutrwC
         GsfTAryRc92LqgpqVQTOAA7TExSPBD+bIH7AA4xm6NC1DxltiuF5GqTTOPZK/tb7d+Ga
         4kJXw6h8xTZcTnRSRIKemFAPyiawcr6K0lyt9HCHskx2++o6zmZd8T620P630DdFLRv2
         WakQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763867100; x=1764471900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bNgBXVliADaREJ6nkSovsbUQBYpNGNtzg4nO0JMTz5A=;
        b=U9thJNhOVezCphahuAokApphb4x1b7xa/Rf2elfWWooXLMecGa9ElT0DK0bTJml/1A
         cHQG9cTjWADK3t3ovtE/qc8Op99WAR0dL5vfRON4tm7jUoBHs+Uin7gICILrX55cMZ1E
         JV00OtSYA9KfaB70DlRunHm7S2qbdP3rx/aP0d+3k3JYClLJMKy0lJd1aLwzWUcFOhDV
         TocCtitlVnULQOj8X+O432SRk0HSmBGtQFvetgwkoDCErQsmMkwUsAi+PgN69aiWrUWN
         h8szrbU1iXLQj6qZtc5AGjk5VJGmyevULz74+74kE8XKYtqRrQxd+kMuvdG7b+OrZ7qg
         6xUA==
X-Forwarded-Encrypted: i=1; AJvYcCVANl0pQTgtFvZUhVjRFw4f2DJWh+Fld0brepUL/lvaLSZJYv6XznwBZq50TAXuIGaAO+4Y1LxdYw==@kvack.org
X-Gm-Message-State: AOJu0YypLgm9mZeu0IPuqxWgDhzsC30ZqZPD8h6K5GPGJFBp+0gCXWZ/
	/ul17+X562JOrnygz9YQnTH91DxMnD56ptLtlEdEPo2k0PabjAYZimmb
X-Gm-Gg: ASbGncsd4ZAn/jXTwpJwEisWgtLFA+/15kfi/MV8fQZo1a+5mx7vB3Q9GsHi+bwLpTP
	Zs1XIYiI/8iPQ1FHMFY+RaQW9RY4WlpCpP0nGC+rlDlBRK/uNufG7DnAVXtqOm/ML7wvMFTNNTe
	lpCDYTZtDxQWEMMXTC1XZkWOam0VGgcyNYTMzHfs6UW+jL3HzhVpHLRv6/b9yja5D0wg+dNGkdE
	QKzPoQzFuf61bJhYQFUDLCW3G6D33ztcP+mwYxcY1IvviZYejO4XxAGXVCUmGfIscuyLCZzhmP9
	XgNuRX/VsqG9IUvhMt/XXmqrb7/buLTTUYbmeRegaoKAW7JE7oI9CR1nsZPobBpnHXoU8fhwilH
	uiRt52G1yL68rCAHUFCxzZStfpjtiWk9fheFQ7lxF2QAUGj2VJT7Aa/6vgJrC7pCMhO/wCkiV0P
	YcoP+4A5ufM/iSQJNzJqz+jJBw3m64wIaB15b9
X-Google-Smtp-Source: AGHT+IHkIt5IF6kEl8boBJ4UTx4CK84Qp7kBat9UgYyfU8OeT0QKX8SHcmGNaB60bDxys3XwPHAOTQ==
X-Received: by 2002:a17:90b:4c4e:b0:32b:c9c0:2a11 with SMTP id 98e67ed59e1d1-34733e563ffmr7489087a91.4.1763867100420;
        Sat, 22 Nov 2025 19:05:00 -0800 (PST)
Received: from chandna.localdomain ([106.222.235.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f024adcfsm10386095b3a.31.2025.11.22.19.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 19:05:00 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v2 2/3] mm/vmscan: use %pe to print error pointers
Date: Sun, 23 Nov 2025 08:34:17 +0530
Message-ID: <64e15c6b2ce86d7824f54e9e001b6f5b44af48b8.1763796152.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1763796152.git.chandna.sahil@gmail.com>
References: <cover.1763796152.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9A3C6120005
X-Stat-Signature: j7twx7fkrfwu557hprjq815spzzejms6
X-Rspam-User: 
X-HE-Tag: 1763867101-477884
X-HE-Meta: U2FsdGVkX1/t47EPqyl7O6En22Q6l0QHg+BMk/jp6IUgg0uNUij515Wr6Cbj3+scMnvOvHasEbSbz5O7kQmD31y/yTP0j8eMJpEPXOb7jKrzJHtmSeNTW+GmTGNJ6U3JCjr9FEX0kN3/icZmCpnP1hpVZEo/3pA+2hgXg+I+sYykcyNQBLhgq/WewpxrDNhTbIqBmWr4Yakp3tD/vghdXcpslYAVarOitRjZQZlebYz+l1l8ISXrTm+YSwYa838b8JsMjEzP3pfzhlgXnkWfi9MEbPj1Vq2SjKAU549aoPj5a/uLVL6SnzrdN3yhCQhLTd0osMDUEpqOYlscJr0AntBHUrb6mXQGI9LXrJ+WuCQvEetbLaWf1fZjwVzCOdnfdrxo1AY2gLJYsX6DL9U0HX0P4gG/EmwGHb3M2ohFNR52cmub8IVQGLsxgBq5PZCdXDRv3sDW3sdX/XkLb+sQFv3hf2LfP71KXGtWhe6LBSrRABY/hJmevELlsdgb2cBkI6v2zxtWjq3TUkNyKzKfK3WCD2UHiS9IlBH601VMD4+kPjYk16FN8fAtoET0xPjKhumv3X2FyPWVKF19Stg3zj+MABw/pBSYEWpm69AsoEDfRvZN6S7jH1+Y81D0k5ozfQiPIL2788uqQQcZRRWB1nkwI9j3R2AG6af7MhY6ZJWMztTBHdckmBvrOv2o9xhOKneVh/wDuS14nHde95+7+w8EtAcqxyWDm9IGKqF1LGSEm98b9+15g9ilsCSCEizv6ACNbYuvvnDqY59/s9cJEprzigT/kDzKLFErFdpnbVovUm4H8uJbsnpMTYtAS455VVmzMjEo0SASmuN8vFY4WjyXLbV4++F5O1r8QT/1BDr1I5HSy5UvThHgZR3mnypHasEomHQeMpJ9nZd11JpFK8rvICLAuMKWhHiN5vO2UJ0xBSNjR1wiheq/5W2g+DN7+P+lotUVwiB77xqs58I
 TDc+5wEF
 jyNvQ7fVCRHjgAd6dD9Z8XJd9Xp9CYfaYPCfjFOFQTsuhIpheHkldL3Uy7Lv+DYnEDJql7DdQSkPosubwHg7A28hjMNk4tRNuT3dvll7BkxG6fsxQsneZAnDnXteks7reF4+StEgYwIN435xXUNR5sFZ7bPGzXCj79mF45xwyKmZv1SMH5iVFGl9YkwoCJM0YjLm+EmZYEB0PmqcS2MWOxLo0EvB/5GAmyUImilBgqnPRUziS/C3z/iMYrB/IHvCwboDjG96RZEzBHQn0zLFzbsn7VLGZ2p6GlqQqVF0Xi3eNlAo7/GsofR4zNueGMiOD8jaW1/odMSmGW0NrZX8jq8t+x5HhU9heEGMHZGWD1swtsjbIUYyosUAQG/UaDjcczhYxaaAU29TKakFpJT05bvFdsHfbi2YxAMMrOLVa32r3AdtiAKJjLrCi1EhJs6MbimeqjDBJYzWgdLYXsLgU6Ch1PSR5jooLqUjv7qgkvozFDL/Wjp0tn+Hj5OQ1eynni6dz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended

Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..7d5b41696cc3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7500,8 +7500,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d,ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d,ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
-- 
2.50.1


