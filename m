Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21DE0CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDCB6B002B; Thu, 27 Nov 2025 00:12:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E236B002D; Thu, 27 Nov 2025 00:12:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646956B002C; Thu, 27 Nov 2025 00:12:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5602D6B002A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:12:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EF2BBBA95
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:12:01 +0000 (UTC)
X-FDA: 84155215242.15.72525EB
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 36EF540003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:11:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LXCMxvJH;
	spf=pass (imf27.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764220319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgeMOXdIAsZBvoC0V9rIO6y/IvHsbJRKjSiXtyCVm64=;
	b=QTp2OxImFOM33tzZ7KUsXfAS5/TdDlNE23i1lA8YAJPoyTtM7JbhXo4YaTvhudNKenF9Xw
	Q+9lF2GRO37Wn0ZRVQgS116/tetaDG6SJ9d2IyIOjN/wDF8a7tlkbUg0s0pPFJtypr5sXW
	pTH6BhhugbosgeqiUs44QF7aCOem+MM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764220319; a=rsa-sha256;
	cv=none;
	b=sjRCYIaPcKjn4QrTs2Fv46VSM9AblpvFcQskF6iuZyzL8s1UN9S8zo3znxDKu5d4dADzd8
	FqHqxuzblnF4Ju1MhiWvvxOuwgmhV5mP7R58U7cVw1moc9TohRdfQ6AvnxDSlmfqboWOt+
	jvlxWBADMibxrOqvN9YQ7xy81RuUGfo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LXCMxvJH;
	spf=pass (imf27.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29568d93e87so4647735ad.2
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:11:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764220318; x=1764825118; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WgeMOXdIAsZBvoC0V9rIO6y/IvHsbJRKjSiXtyCVm64=;
        b=LXCMxvJHE5tTGvUITa20SsLgtRb9JMcJuP/aCLiR7VKZ20VzBmvw0oua5C6QFGq42m
         2P87omY03/T/7VdJbVjY2pWJ9xzsvenzIBbmy3RCnuq2eXsaA5Pm6UH8MkACtD2avtqR
         3wXxr5zLF9QWEnArh7HFkGo6e1qxDTl+8mnUm1yDPB7NIPMaebXbOGFToHrW0lefQIba
         F1vBlVfE/uXdv9UcqpWo3UbrIW3DwaICZANSup0L4zORJabyBDY54Gqh205FOqVdSkhj
         mDaDBj9ThW74mp80RcJ/oRAFXzuMdytsPvbE55Xp5gI0Hlw4Nt0ivLPcuMqr+QmASmaq
         G6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764220318; x=1764825118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WgeMOXdIAsZBvoC0V9rIO6y/IvHsbJRKjSiXtyCVm64=;
        b=UFaB6lcn2jbOOrR2HJ9Oy6ncFdohhiojkUkYmuyX7NQ7Iyc/1a1XJnpR3qtE3Hh6KP
         4EQxYcAcnI9ATONiNVhWUIMIqcsYoTfZpsVOnK6t6IN/WFdcE2acsdtQWwfZWVk3IE3X
         hwEnlTPeu8AIZym/WGzCdoYQM6fCMSKhjVxEeF1472ZOM08V4KLOzXE/vrTJeVC4p4dI
         CxFYWxveGAisgm6pcRIH2LrIXYhFBzi20lz8edi1W4RaOtlW1BryH5GdcJ1ePomAfUmz
         z1/S8cnS2jTNVl0JF4QlLse9c1n+BXIqhjp7ymZ0XqF0nEWHDU017Vy+GOuLUbRMmav2
         M1Lg==
X-Forwarded-Encrypted: i=1; AJvYcCWcttEX0VNEbtauya2eOHVvBPzVvwDLC5sRh0liykZ//TNqhzADFAxOmOi2716nldJ+kvZiEoQOeg==@kvack.org
X-Gm-Message-State: AOJu0YwDajCIHJQKzFMC1zTjfImR/XyjMAcrdbmGW5vzSu1x35r/SdKW
	9BygcX+ucobRFGqvce2fETvEpI3ZBrTmYHSBNmFTiltREgEcdselT6k/
X-Gm-Gg: ASbGncvX+vkM5SfsncR1NckXVtp3Zxs4esHMHWR3ks54JYWapdEhAAhx+yr2MryHQFJ
	CZFiyCjhowLuWmgOwpzyb+f3U8MF2saXUPj7N8hMyVTlJ3gjU9S4ZHwrXvuld+dJ//dg3kuZ7Fb
	R2KWTtZ5JQEPFLr+yTdd/bnH9NZd8UG6NWFpbVtlY4km2M9nMAoktYSyS94KjUGt9DlVxMNKbEJ
	7HmaIlpT6cb2HAtqWEt9UUOyNiDhIktgf4lVxVn+QnGwLvSDZRu/imkBdDqG81RuI8AZBpin2oc
	v+OOr5Ut4TL4JxZsDzU7HLKhlCEZUJvP3nbxKMItdPzLkl2vGRJD80AuZ7lP7uz/kk27oAKjyvd
	YfwgSPSGlxC3PH3MlECZdE/5DaVImI+Ns8JWK8KNTBUrTLI5sbdSNb531fP59oSYPX7bokTtnqn
	rp3sfCQ4EWYyAre3pfL1CWgvvJHg==
X-Google-Smtp-Source: AGHT+IG2SqD5u08Uif7mY1Y40qA6yPwphWnMF6xNA4b9F7VhpfG4Wnoa2CTGFQnvJ+iSE2LP0H/zHg==
X-Received: by 2002:a17:903:3d0e:b0:295:460b:5619 with SMTP id d9443c01a7336-29baae4ee1amr81598835ad.8.1764220318098;
        Wed, 26 Nov 2025 21:11:58 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce442744sm3590715ad.23.2025.11.26.21.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 21:11:57 -0800 (PST)
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
Cc: david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v3 2/3] mm/vmscan: use %pe to print error pointers
Date: Thu, 27 Nov 2025 10:41:29 +0530
Message-ID: <db049e564cafcb0913bee930d6a577ea43044f5b.1764177933.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1764177933.git.chandna.sahil@gmail.com>
References: <cover.1764177933.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 36EF540003
X-Stat-Signature: adjyi5xdbrqqsfbph47m9syz3hijt6tt
X-HE-Tag: 1764220319-459183
X-HE-Meta: U2FsdGVkX18epb6qnErY24WWwGA4LC3eJO5J7Ca6Wg6n58y2MdbGj7z8KT6k6Q7d3elrojDfOfuGZAOJSkt0lmhFmr8kEMk8WzZ9G7ZhJEnRTZ7tUzusZTf4nrrwfg1OQIGtVz4FGLiVb4fn8MD5LuG8HiTrXoV9og8k9U+mL8KBqJKnYxSxuEm0cy8SLwV8nQ2EOPOvmBNwjjGveRPp2BE8PdCCAiWVjWvXyvSPBD25Cn2SwoJNieK2pvkHwNtE186aLaopLps87WlLuqhfJh1pO7gmMFRVkSYJXEuf408th+r0fjbVf6C/JOInGquZ0rQ0NkSEEqCPAeRa6uRu9D9BiS4dBBtM93szEAvRKN47xNfrpre6j1nCCWRNfRBJeo2FxyazLnX9oN2RSy2vPah3A8FoPh0Mqy1aexkLJqZaBDP2PkSyCc03q9cWuk29rSto4IaFYnnpU4mdiBcihGpHRJHlSuxW+gPivha7fAmBwubBX/Z1HuRDa39pw1p811XJrKlFiwZ+DZmJ2pzLpQnNboIPBhY4j3wIeQl7WEDhEIfJu+A88Z8VpVhpt7Q80zGK53Gjx9gLbvwDJgFaEcNCx7aSsoQBdhPOaMuIdTrVDlKaZeeDIjv3MMKyowUjkhZ0ALWmqxSenPuu5oferCZb9tF/D7u74vJ/JEz+VM6H+DwbX2jZwEK651Z24VVE70J3l/n238nFiEsOv0f9W6c0go/srR4/R1+5paIZBgN1bPd17mftRwEP5ebBa1Jl6No6e8UZzCSgCdWRIoEK/6U4fUWfalum54+x+XOBeD+DOMRBvT0aTYX5kL3FAhHoJZpF/aX0hQSFHzuWeXH8OBvWFAMmAzkC/v6rl6M2sCBSZrSWKSdPRpZkNB4Oa8nLensAZWcMfXRRLjdBUrz/U0Qrcs4AaYd5tpf9rDyC0SIXUIJX7m2U1uPEa3r/yzuLc7vLGsTwhU16lY1ElI4
 YKh1E5Wk
 3Wvv3CKxdfWps7BLmf6yaFHbs2b5Ttkh10BhIc6yfyjSBlABzg4r/+YzQD1b+1i+Rls6foJYDDWcsm8zoKro7DcP7uoj81VrQq2VUGy4aQCusSR42ntXT6XmttEotlIgqf92EVd/4+HuKwgXG+4IbbihOZhLYZ8a2ZS6hWs2hCeW/K3anMk6xEfnjQlggukPU/pboEC5/4j6RGHRT2DCuPVS+X3MYujwHbcv18mtBPeGlLJslbfOcHyXgckLsEMZpDH0xOpf5oRNRL/g8FL8oWujRiIM6caqHpbI3KEwe03fSsAS4BSVxBwNmBQn7iplQ7LhJtnB7g/8cELs7chNWWcBesGyjTPy5hrVrQ3+xIsltrOV8Bk20+Ic28lMbXqYbk3QrF0bMbrlspZP5lUOzyfSvaGViil6WU/LCJNnlvJB09cQTqQ9xBJjiVFRCtXipmn1rgZyV9HgxmFh72TfJBkW60OBLh556nBf2HM46fXwSu20Bot0p7QqFQnsD08Aseu0I
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

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
changes since v2:
- Add Acked-by tag
link to v2: https://lore.kernel.org/all/64e15c6b2ce86d7824f54e9e001b6f5b44af48b8.1763796152.git.chandna.sahil@gmail.com/
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..29ed0b304b5c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7500,8 +7500,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d,ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d, ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
-- 
2.50.1


