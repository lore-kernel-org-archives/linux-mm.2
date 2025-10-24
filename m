Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A692CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2048E00DD; Fri, 24 Oct 2025 13:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372758E00C9; Fri, 24 Oct 2025 13:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6108E00DD; Fri, 24 Oct 2025 13:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0632B8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:07:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8710B88EC3
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:07:09 +0000 (UTC)
X-FDA: 84033638178.15.C72F774
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id A038C2000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:07:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DjIhyLmx;
	spf=pass (imf13.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761325627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ym8aETYBXAJKvWbueelLx1UUH7YGGFArm90KzvTaVUw=;
	b=k98UmTP57s+S6fVQj27L0vu0w47+tWdwawr4+izcZM28ANQEhWoW/oiH7UNYOxRFn8rE9t
	KqS6gQpGrmdtXcVQdflgUBUlvUzudfz++CXi5XjQ8XjOVddHCGLktILCE4m6Gx+tl4JJ7c
	fblf9aiSszm6FgH/zVRgJ2r0tLvPiLQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=DjIhyLmx;
	spf=pass (imf13.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761325627; a=rsa-sha256;
	cv=none;
	b=Fr9tt+G0/CXvN8jjCQX91exG+4/IyyV9WivLvwf/vOrqhzcNRipx3VijbQ6gh8jwmeAkla
	dry2kMVLQJkmIfNMjnbcZq4tNmZBrrvgdGhW6fn3BSv/uCsXSu+GSPhPz9Z7xjfKtwbXD5
	4dUSCnbEZzeuhDM7YX5dnnkEcUsxfK0=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47105eb92d8so1803745e9.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761325626; x=1761930426; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ym8aETYBXAJKvWbueelLx1UUH7YGGFArm90KzvTaVUw=;
        b=DjIhyLmxClLLv0F83fJzo/QqvK7kJcE2vRK449K7xk24TL+y2aOiAqWgTHVKObEC7h
         bdXJcmDaCtsGoyvoTiP+Cron5+6v4Z6o8ZdOGlj09fycU8VpySA9tLlU5h/5Lgn9OvXZ
         MB3CK01ZPPWQAJ/eT1AOBfqkRbsCmJEcLrOn4B3HfLb2ENExFIPfd4BFsZTNA5YuIfQO
         Hi48A0a6HGtiu93OWO9fe4rP9sMXBnAW1x1h9a11NbECXqPX52AvpoNx3Q5+kLrBXs2M
         LWgFWw5s5SWNwdX0NldZKa1W4qubLE3dy6N9JzQixxIwlLkf+ptjvn5p8pqGzGuKz+1F
         plGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761325626; x=1761930426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ym8aETYBXAJKvWbueelLx1UUH7YGGFArm90KzvTaVUw=;
        b=K83qEP156aGdauGK4H+II4qSEj96k4Qp6oNU3ntsKrDba4P24GrUUtkNRgTAuNCzPq
         A29zX0hfdTVMFcDV7tsUsFPUmpyek+c3dWelGzBISns3KqVBf26nNga8Czz6E123ZDv8
         oypam+r3f5LTPF3erXhn3npkqgitdbf0JeExn0itupGtwaY3ulV3spSlj6eUtYaZUcAl
         vF91ovVki2zV8ahvRBsT9p4tYX3PM8WuWDPo7UnrqzCrDUblDdCxM3rs1GFjNQ2yye97
         5CblPmFVJFod8N6qYRE1H5Xk2dzXXBT9mQ2GGS5N4Ec7rTzjLh2OZed9PDJtOme8fQkV
         jDIA==
X-Gm-Message-State: AOJu0YzESS1jyjCrjLWP2oZKJxLkDZI2ipnw3hVocWH08kkH9tKZkC3+
	cwCmG98aLpycuTS+V8GsOvwLVwQCPPM3fP5jwwe7eYTWyrvclb08mMLuxYo+PwhfBd4=
X-Gm-Gg: ASbGnctQ1Dv7A6UOWyePJYfZKxJCK1lEhn0odflrQBvxX1ML5AfIzhy8TTUbpWgdsEs
	A5g7h9rhjd3tiwA0B8xbtEOoj4SnOqkXUFUc+c/LAkxGuToV/CH6Ff8UEfczibCA0mf2U9eJzgv
	JnfNwkOTt1tUahMWDI+RH1VqPf3FACUuAUvS1Z/5TO6A7an4T/AzQUwDCtRyKkPCrBOLxfDFrah
	ey7zgHzlPhZ0GylWsjCIXQTOxzclq7bkdkpr+zjnF5R+puQNBl+9vPUsVkkD7xvnCWcLrAJ+Qx1
	sCINx5TkLiCjODIKn+IAELqFrendiKkK3t0XzccDeaDWL8BUBosQHGZc/FyCUXyfcdr+3hd88jK
	rNfOO5f2dXFx8wXGzLO9ckOWR63pUeWibyMZnrsyk2CfQchQqwMyCy0T+wD7OetWHk8rHIm0b5i
	p94IX19m4+8Sh2RykYPIAbrmqWMAVXs7OGUtSO5fAAaS0zdgnBeMj7Z8+YtHGS6zL7JOuoP2gAW
	q78oA==
X-Google-Smtp-Source: AGHT+IFJ/xF8oNJztRWfc273+XYd3dJHzM8CNxqHRb8nUro5n4D1a8pHx6sozSot99S9MPoKnjvpNQ==
X-Received: by 2002:a05:600c:c4a7:b0:475:d7fe:87a5 with SMTP id 5b1f17b1804b1-475d7fe88b4mr11897735e9.6.1761325626248;
        Fri, 24 Oct 2025 10:07:06 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47494a91c47sm91921345e9.1.2025.10.24.10.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:07:05 -0700 (PDT)
From: Petr Tesarik <ptesarik@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH 3/3] slab: use new API for remaining command line parameters
Date: Fri, 24 Oct 2025 19:06:54 +0200
Message-ID: <6ae7e0ddc72b7619203c07dd5103a598e12f713b.1761324765.git.ptesarik@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1761324765.git.ptesarik@suse.com>
References: <cover.1761324765.git.ptesarik@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: njj5hsh4xqpm1dre7bkt67zaff9q3nw3
X-Rspamd-Queue-Id: A038C2000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761325627-33852
X-HE-Meta: U2FsdGVkX1+ZoBRj90jdJu0rn4nVTHT5vRR0UQJXptuXTZRcDSGfSP2+UPy1JfuOlVyV3sA5o+0VkzJRqvosliy7as8eDC0OtZiFJfZuO+0C5+bMk73e8CX1mQ6H79UvURPum7f9dzM5m4GbiHjnOKhBZ2RgLKeRGO3yH8mwxztHcfKayFZ5pPJaFl/0xc74egpFBEoJQtaN4tda33oZIK5wKCEdTH3wYmbHUwXnsMyRI+6BpXEoUpU785OawSHIipCPuNVVhwC4+Wu1BKudx+1ZiEfGP+tNOT2Ru+x7S2qOsa3ce/jogK/1/0kyRhFZ04u/SsAoLKun0x5nHGE3L+rTXLqb1Wi64augAhM4rRHExDewlGK0tCbHCajjVsCR9qkb/TPxbI2QJa43uZMMpMV8d5nRNgUNeNNBQtWQxieZna//1xmGxESQVmih01gEf9ANGKTig4Kl+OCZb3warDPs27nBvYrLugSWpAfmmSuEQ0++PHJ7kK51Ft+CaPk/XyHKJf5uT0R+vol5klKgKB0YCkTDiTYDpmy9I9DBuVBBVZywnv1tepLZos/f8j1OBhgInhHnb+tqI5bRRW+tr97uIOirW36Wm/J/pOYOycItzBRgZZz8H7yOYHHHdwa2wCo3HqOsi6s9TFuhihvxYIqic6dETDUkbAy38NzuTy+1cQUW1NIXwnYDbYKbyRN69qPdlhdgAk1T9c0E+XirJ85UTl92C5QabHeqjuNcn0/l8+bcvKlm93OxaUcBCYZ+fD76OFvVZiDpJZoNfc8CUuUJTd7+PE0T0fEG1mOvwJww03VQ1JifMker45+7B7O+3usKqqr3nz6DVkAIbjQOuUsG0+iGwhP7ngGWiCvtRqRtLcigyNtpPYo3jcpHPj12M/iFEjWqeSq6p8+vBasORVoTCk5myHx/1PPqzREl8b9bf36pvr6JY0PinqiWw9dn/P639VovIKG4DT+6LLE
 SaT1YYf7
 clKox9/1SUd+jwJX33pnHiJpmUMGc9jUG63ep0u89qOdkR0376swGy+cFYEeD3FDQY7iX4tqpEeZzaQ90oislGFYM1FTavuB7F7HKNHt4QWThP52tgNx6iXQ5d3jc1glDd1qirJ+lVdVT6WKlwQhe7l4RG6mjgJkm2Q7Ts0eRwerd0/fIgmAWVRBtA9qM9RbNSQYdOllMRDXrxmhPk4fcTioTgd7jt/5/gSFBCwvBimMjKnSqYQ3jsXYWjw53zJV/Ws0pTUG4p4KhwnYpFzNFIKmAmOB5QVc5OWGVn5fMR4MZoOuELaoo/s/Ba71mi4uPv0oi71Z4vfNjTLqIY/s3Qywn8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use core_param() and __core_param_cb() instead of __setup() or
__setup_param() to improve syntax checking and error messages.

Replace get_option() with kstrtouint(), because:
* the latter accepts a pointer to const char,
* these parameters should not accept ranges,
* error value can be passed directly to parser.

There is one more change apart from the parsing of numeric parameters:
slub_strict_numa parameter name must match exactly. Before this patch the
kernel would silently accept any option that starts with the name as an
undocumented alias.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>
---
 mm/slub.c | 57 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b124087b95f32..482460ff3abca 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8119,46 +8119,53 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
  *		Kmalloc subsystem
  *******************************************************************/
 
-static int __init setup_slub_min_order(char *str)
+static int __init setup_slub_min_order(const char *str, const struct kernel_param *kp)
 {
-	get_option(&str, (int *)&slub_min_order);
+	int ret;
+
+	ret = kstrtouint(str, 0, &slub_min_order);
+	if (ret)
+		return ret;
 
 	if (slub_min_order > slub_max_order)
 		slub_max_order = slub_min_order;
 
-	return 1;
+	return 0;
 }
 
-__setup("slab_min_order=", setup_slub_min_order);
-__setup_param("slub_min_order=", slub_min_order, setup_slub_min_order, 0);
-
+static const struct kernel_param_ops param_ops_slab_min_order __initconst = {
+	.set = setup_slub_min_order,
+};
+__core_param_cb(slab_min_order, &param_ops_slab_min_order, &slub_min_order, 0);
+__core_param_cb(slub_min_order, &param_ops_slab_min_order, &slub_min_order, 0);
 
-static int __init setup_slub_max_order(char *str)
+static int __init setup_slub_max_order(const char *str, const struct kernel_param *kp)
 {
-	get_option(&str, (int *)&slub_max_order);
+	int ret;
+
+	ret = kstrtouint(str, 0, &slub_max_order);
+	if (ret)
+		return ret;
+
 	slub_max_order = min_t(unsigned int, slub_max_order, MAX_PAGE_ORDER);
 
 	if (slub_min_order > slub_max_order)
 		slub_min_order = slub_max_order;
 
-	return 1;
+	return 0;
 }
 
-__setup("slab_max_order=", setup_slub_max_order);
-__setup_param("slub_max_order=", slub_max_order, setup_slub_max_order, 0);
-
-static int __init setup_slub_min_objects(char *str)
-{
-	get_option(&str, (int *)&slub_min_objects);
-
-	return 1;
-}
+static const struct kernel_param_ops param_ops_slab_max_order __initconst = {
+	.set = setup_slub_max_order,
+};
+__core_param_cb(slab_max_order, &param_ops_slab_max_order, &slub_max_order, 0);
+__core_param_cb(slub_max_order, &param_ops_slab_max_order, &slub_max_order, 0);
 
-__setup("slab_min_objects=", setup_slub_min_objects);
-__setup_param("slub_min_objects=", slub_min_objects, setup_slub_min_objects, 0);
+core_param(slab_min_objects, slub_min_objects, uint, 0);
+core_param(slub_min_objects, slub_min_objects, uint, 0);
 
 #ifdef CONFIG_NUMA
-static int __init setup_slab_strict_numa(char *str)
+static int __init setup_slab_strict_numa(const char *str, const struct kernel_param *kp)
 {
 	if (nr_node_ids > 1) {
 		static_branch_enable(&strict_numa);
@@ -8167,10 +8174,14 @@ static int __init setup_slab_strict_numa(char *str)
 		pr_warn("slab_strict_numa parameter set on non NUMA system.\n");
 	}
 
-	return 1;
+	return 0;
 }
 
-__setup("slab_strict_numa", setup_slab_strict_numa);
+static const struct kernel_param_ops param_ops_slab_strict_numa __initconst = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = setup_slab_strict_numa,
+};
+__core_param_cb(slab_strict_numa, &param_ops_slab_strict_numa, NULL, 0);
 #endif
 
 
-- 
2.51.0


