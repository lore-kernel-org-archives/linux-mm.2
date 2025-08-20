Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF14BCA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 05:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6521A6B0029; Wed, 20 Aug 2025 01:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602456B002A; Wed, 20 Aug 2025 01:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA436B002C; Wed, 20 Aug 2025 01:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38C2D6B0029
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:35:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBCFF14033F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:56 +0000 (UTC)
X-FDA: 83796024312.06.4F3BB66
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37426C0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:35:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=isoIv17x;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755668155; a=rsa-sha256;
	cv=none;
	b=oAQE727nU61fWvo4XXiVUMvnxbKwOdR4exTKzODXxsr6+Xjxd2pMxEEyV1zeg0Bo9jrfvQ
	7W+Fn+WKAVwLE/Gq6mMT1tP9373kscDhnEgqAunddhipfnIsHrieHi7Ws95j+ZYddwxevm
	YXOYxeLDFQINsKOL1xE1DBKyZpNRMbA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=isoIv17x;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755668155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1F98A6khDpxH5CCRtSbMqyknw7kFB7aw/3wgsldUGho=;
	b=8q3MLOmuQkCtZ23XXyuP10yqh0DoCcGiE+vY8FOWWY/6c8zWUUcKjFzRtP+5moBsXiWi/z
	I0GncTK2WomCA80dnWEMAxkLfafsECLZoo+8yJLwv6dozmuXpHLiNpXBqFs4GkF/LUdsRk
	0x0pdsfpbYVLF9I6rAsV9LwxnHAkCYE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755668154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1F98A6khDpxH5CCRtSbMqyknw7kFB7aw/3wgsldUGho=;
	b=isoIv17xBrqPe+YSqST2wTcyWWWcSP+un5a24FoBgk+BlcyEzIChik135ubmZVGRGYHKOr
	dullsN+2CgJZP3ZTY33G8xMDDmToVd/MTGY4tgtfCaJebL0jZnD+p2c63CmyhwA3B8TTn/
	joA2bY5Kzm2u/Ztuiupymz2Mz6pmPx8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-xEr3pfhWP_q7Ci4sKv6iNA-1; Wed,
 20 Aug 2025 01:35:51 -0400
X-MC-Unique: xEr3pfhWP_q7Ci4sKv6iNA-1
X-Mimecast-MFC-AGG-ID: xEr3pfhWP_q7Ci4sKv6iNA_1755668149
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AFD7918004A7;
	Wed, 20 Aug 2025 05:35:48 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.99])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 178F519560B0;
	Wed, 20 Aug 2025 05:35:39 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	andreyknvl@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	elver@google.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 04/12] arch/arm: don't initialize kasan if it's disabled
Date: Wed, 20 Aug 2025 13:34:51 +0800
Message-ID: <20250820053459.164825-5-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
References: <20250820053459.164825-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 37426C0006
X-Stat-Signature: xtyqz9xbj8kmpat47nnschi5m1fjuwb6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755668155-862214
X-HE-Meta: U2FsdGVkX19zQuN6nPE2GfDM+4381kRc9m28jxaHOraZ6plj/2CM6c3AEccyNemKyz8fC7NqdYSLPaKuU+sIPfDbLAC8CWlqzHwVEuan70TIZazZAkeeEmGYv6YNaswgQwGaW1MW9w59gpCBGdXBzgeqtcg/e94waMncmyHgm6JrMxadmaobSOmc2v1iPMhyJGqplJt4gIaoxOpKx01XNaEQmpxzzT3okw5VUsAw5KLWDIc6nZkd2fViQKuoGjg7eeBFwicMWHPz35SNKfGRV+Y0yDARSQ2LqB4lTcclQBqroakXbdF7RlOyJqr4Hfb+BUC7dGn7kRORtBhVEottsdHb/UgMVCQUhncUMMqNcS3aZ6Se5Z402YwLcMKutGk5bRh/ujw+05JFff3hEisfeDzjVCe2yUk6pEE+LSAq5TwAR82tKPiuFgklfK3opxAdh/+rAuznwzyYMocFlmE4JjafCpSzylIYGaKzjf6pP3umIY6Lb7fnLSdfYS9gn1bc6e2/r2wTqxh7F+Cn+Nae+xf1g/poSWV/XxM6DOZdV75yZdXvrZIKqtjrZvOsaoKw/BEAetMnsToywAk+RnX5eKNYuluGRM/sF0VNuzyoIaJanxJUISqID/s5D8y59kmD+lNtDy0TaxbyxMeyM7fg864r1fi9/oPDqHv+7TvODMybbd71p/LeIccTfesbqxshX1EmxMlsWbP7Sq3QpIL5/+2yVy2jvt73jD4OCaVZjYd/+GDZj8oY0oZUDlogZDtvBdXBeb9L6+DPqim3I/YHQtQ+O9+LaM7tIV82nBGfNEVGuGP/XAV0r153WGrbztj39PHOaNiml0IXkvscBjIqFUD7nknvpGZKEur/1wGH3BS7LbSzwYWX6bQMBnuZ5wk+uFtwd5zZogzgqvz+9S+WxAQyJM6CWeZmxoAn7K3YbLSCZCU/CZckoVgzbMrEkKyO0cTmdS+B08tods2J4+P
 Cs8i4wl4
 J5qmrZOLp3TTICcEkZO6CWZJu26a/Bec9FStd+W+2991gQeJzRqnYz6e8IgPA8sPOKVnab4FMDBVuIBjjdFoUT4ICBySXf8qllIOzEFXF+yl01FyE9nketEgxSrx5a/3QbbvJJNYHx5eiuv180VpC5wHmza2zWh8cCkQ3qN+5qYGBRTSbQ5T9n6M9F6QuyUsUMrNY7Moap+4lard23gPhdSVDNjMBVW05JejjMJq3Tv7q8qdI39ndR2AWcs/ObecUhDgJK3HrP71avPuc1GJeBqzA0mOEhM311WZE09ZkOfePsFDcsKFpDVMCV4SEK4yXet9jGNIMqoDZPWogM2o5y21VinEp8xrbryUJZzrf3aqNtdukIecBNjrsYzDtieShjkLfEgnkl1+7GzpHulwcaxnxHWC0cMhP3sqnJxszVL/nDhvd4I63RCH1uKBspxpu+sjJqrOZwnGTAyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

And also add code to enable kasan_flag_enabled, this is for later
usage.

Here call jump_label_init() early in setup_arch() so that later
kasan_init() can enable static key kasan_flag_enabled. Put
jump_label_init() beofre parse_early_param() as other architectures
do.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/setup.c  | 6 ++++++
 arch/arm/mm/kasan_init.c | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 0bfd66c7ada0..453a47a4c715 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -1135,6 +1135,12 @@ void __init setup_arch(char **cmdline_p)
 	early_fixmap_init();
 	early_ioremap_init();
 
+	/*
+	 * Initialise the static keys early as they may be enabled by the
+	 * kasan_init() or early parameters.
+	 */
+	jump_label_init();
+
 	parse_early_param();
 
 #ifdef CONFIG_MMU
diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 111d4f703136..c764e1b9c9c5 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -212,6 +212,8 @@ void __init kasan_init(void)
 	phys_addr_t pa_start, pa_end;
 	u64 i;
 
+	if (kasan_arg_disabled)
+		return;
 	/*
 	 * We are going to perform proper setup of shadow memory.
 	 *
@@ -300,6 +302,10 @@ void __init kasan_init(void)
 	local_flush_tlb_all();
 
 	memset(kasan_early_shadow_page, 0, PAGE_SIZE);
+
+	/* KASAN is now initialized, enable it. */
+	static_branch_enable(&kasan_flag_enabled);
+
 	pr_info("Kernel address sanitizer initialized\n");
 	init_task.kasan_depth = 0;
 }
-- 
2.41.0


