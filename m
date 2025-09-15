Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121C0CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 19:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11198E001C; Mon, 15 Sep 2025 15:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98AF8E0010; Mon, 15 Sep 2025 15:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC328E001C; Mon, 15 Sep 2025 15:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7D588E0010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:52:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B64F160729
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:40 +0000 (UTC)
X-FDA: 83892532080.30.3F0C602
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 967C4140008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:52:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="niJ6/E9m";
	spf=pass (imf26.hostedemail.com: domain of 3hW7IaAQKCNA1Hz72AA270.yA8749GJ-886Hwy6.AD2@flex--fvdl.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3hW7IaAQKCNA1Hz72AA270.yA8749GJ-886Hwy6.AD2@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757965958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=II5IQOV7eE0UCj316osBsFAD6qW3Vm1Z7tYAX1f0u8c=;
	b=x5wGesaEL4+MNBHJUKO07/PTAV4Yv6WdinfH6yJM5Ynabbk8eLjH8RwU+C2ucavqZZN9Y0
	EZGfFCbFklSB80kQw83rLixEmVwd1192I9idMYyKZBjWCox1TExYB48ElNWKI6shP1ReOX
	GZalzR2WG5Wq/gqK4plzoiI+WS+Qscs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757965958; a=rsa-sha256;
	cv=none;
	b=TRvf4UyKZwLc+Q1QVa1g3ZONdDDcwB0Av6ljSQZyLeAdk8SBr4llOT0PKCuYB303GaqhUS
	0VOzJHh1LLHYze7p9XdXpFqFt/AbFUraNbmz4Hp349iQYoTRrUkR6xSilG8t+3Fony9lr4
	YlnvEV6CmtnSHnVLsyKxTrJp5sii9os=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="niJ6/E9m";
	spf=pass (imf26.hostedemail.com: domain of 3hW7IaAQKCNA1Hz72AA270.yA8749GJ-886Hwy6.AD2@flex--fvdl.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3hW7IaAQKCNA1Hz72AA270.yA8749GJ-886Hwy6.AD2@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32d4e8fe166so6792171a91.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757965957; x=1758570757; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=II5IQOV7eE0UCj316osBsFAD6qW3Vm1Z7tYAX1f0u8c=;
        b=niJ6/E9mo/K/LxsrYN5jcw1nnjO7wkUCn6Gm6fy/jp3a54I1SQZlF1M0KwtJler4sE
         VmkTOhQnGnffbt/KzsFf/EWIuhEkPfgusKDZPLBQGzVbXNMWTnh4WQeZRS7fCEmflZ5X
         2wcX+BL4y5l87qD9CCS/Y9H7qz8yi1Pfo2r8SCG3NQisdKjXL4GeNUqQKRHD7pCp8oFB
         edoKs63Zld9Avp8+jA2vdksx55GjSbeGL+Av3So/s7UzR29WTvqjWiHa8JIe/hdj/IcC
         y8rh38thMoHF4K73rL6kvDKkbHkx5pS3Iu/74MNsSTT0oiHX5BDV6+N6c2C4/vM2ajRp
         e57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757965957; x=1758570757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=II5IQOV7eE0UCj316osBsFAD6qW3Vm1Z7tYAX1f0u8c=;
        b=t+xeODr4TRjSaIicQjB9P9LuBh3/HsMbBhfAFKB3/mqtLadfcnHNKLjTeKcouqi3bR
         w4QoFh3lIi9VoDRMmqaMwepg+fZtUukzDRbvijYVn/qe+53UpMMfnhJ8HQY5aMVVsGRk
         ZN/tdDgs3qJiiIQHXKZxHIhiXkFnM3rNDCbb6E6sy2Ps1grMEe01qGBcAIIxXeOyxTUt
         /NbPDdxVGxAdkppioj2MIlBH8MYmmJ5acD/AI/DmMk6/Sao8XboOn7LprLtXeEOBBPAO
         8MiApcZ6vhNVMfaDfCAQzZANn9fckWCaqcKmRqjEix2BUVNNeuFqC3SoDRqH/aLJaKpW
         GhFw==
X-Forwarded-Encrypted: i=1; AJvYcCU7wj4/uCUVHZuqy1+5SrUT6wenYmgLEN7ufR7+u8DO4RyFCoM/u8alEegRFFq84LkbjkueGWwSVQ==@kvack.org
X-Gm-Message-State: AOJu0YxoYu8WXzv5GcjZhgyJLO40V+b8UZGGSyyLEGwVjgUHrtHGLFc8
	fCI5rF9orUrXw5yiik4cGYNmSmHDklZHRJ2w03gGgmVtQsrcckP98mYi9sU2HbLIDBbLLp5UPA=
	=
X-Google-Smtp-Source: AGHT+IFMJxaxylkV9OFVgqxO/4qqXvhUjwfCwnpPmGFdHD+wNdYJe1GQz83T1fH2gji69vii59G7U8uJ
X-Received: from pjah8.prod.google.com ([2002:a17:90b:5908:b0:32d:e4c6:7410])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4acf:b0:32e:685f:cce9
 with SMTP id 98e67ed59e1d1-32e685fce45mr5253405a91.18.1757965957450; Mon, 15
 Sep 2025 12:52:37 -0700 (PDT)
Date: Mon, 15 Sep 2025 19:51:53 +0000
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
Mime-Version: 1.0
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915195153.462039-13-fvdl@google.com>
Subject: [RFC PATCH 12/12] mm/cma: add CMA balance VM event counter
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev, 
	Frank van der Linden <fvdl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 967C4140008
X-Stat-Signature: ywrbu6nssyq7kqf6az9wr8t9wmytx17h
X-Rspam-User: 
X-HE-Tag: 1757965958-746913
X-HE-Meta: U2FsdGVkX19IXy/GkRX5ZHU3x8/uvX4x5A5b8WSWoD1kd4fqGSpPherRh+VGTGpCGufv9MME2a7A60P1P5bZ4anCPaC9cLCUDazYjfSYbjcOx5Y0K+yYfbdJWpjoW+FzP2nCMXpSDYNOoSP4ycC94GylI+iiF2/nSzmpWIWmrfjcsB0IxhrKJzsQgbXUHdVXN2T6ZBc2FrXuQH2GXD50Ivwj3mTFrfvpb9KyAnz/AhTy6NvRCYdUcjWWxO8gpitbT3UjP/Q7zQihcHkkyI5CcKzgdEbeS11uEOSx5u9nNWgp4RsvotVPpSQ01Yzxvi4iOnHyyCPypfxqXF6QrB0OdGvx2R3dEXU608BgS5Pucjm3nMBk4PaNlaH45UpnqKpCnp4aMDkA7U+ukMlNLlFpBLTBijikFXPs42pVrglSzbogCve7Z3A0dUZj8ttXnYuYTdUtEmzg8DdWEbKQdwZMcNn/rnr4glpNcTRLbtsuaR0b7IivrEdi+7BUHNCM/pDis5ymcKWryGcDs/YVdTUwjBMO/Q59EuzFt8Stn/2mTph60ey6tapOVF9tkU3EnkOcminqgiiEX5MkkPQci6N+pt4E6Ru+jQbWGPDAtQyOGMr9m32FrEurXBiRFPsU2fXzFzvrNSScNbwWt+W/OUPwHwFwaU8k5fIGmpet7zTaaIKhOZooggdVoFGMCgdLl9MsNEegW4s56EkisRslWuMtdltBuD1TQkXnajy4owBB0Gl8dleI+GcxBtB9j51bgXzFUc3VHjZ1+E0VioRHNa/6UfHKQlqkeQ1rXfWtbp+9H1lCz9KSEIIssluOvkDNMmRUUDvQudLgpnIAEZ3cEnj+Md8TaLrk0e1N6Vkq8tlRwaL+g59snhoRrqGufJnWh3ffEihd/kbKuNzBlk8Sm/l9W2oFTcUK1+h4C+ZyAVK7IoCC2ttkhCTnnKOEwaErJ7bAKtkkof+BB9YrNs5o30M
 2hU8H9b1
 TE7Nddw1E1z1PguWvz+Tv/YL7xYJ6mqHjORyuzvq1d1EKdc/c4rmlMK0/M3N2UD3KS0hvggTSU5GMOXpukrQoHGxgJsX2axUHmwffygr7jeiMvkWIQ7bg9cYUFb+Z51C+/3pdFHIQ491UtoC6O78pAnj8iwhd81G0n6W0PXA49Lkas+ctp42p38z9MF41JI+AGH08YqKSZ5I2SR5DGaNkyDmuZyq7d10fZvb9saebJMiLaHiHbf+L1QV8kX56Q2W/UlsU/uBpUPCOtF+dWpkFnStSn1wHUA7EeCYShaqEqxS3rIRx123FW7NpC8XXZreGRt+ZdLVdAqiC8+w/SovKixHsFQuilc37Wux6hxnq1TjUvwV+zLOhQ3xp3BQfTVt4J+4UYWFTblkKzvFBUp9xMmgVM0YHq4l0/mXtAHHmnUYv+xTojJbTSNzpf+WBYfvzHteo2WftOqqmbcsaFN8vLQG7Keela/Y/CahA54QrRP6ney7uH06Mir37QsnkAkZXHbdTPRXE4WQ+Qt5dgu/YhVB6YS+xcoCCIGUf3GP/28gPL11Wf1Fgzgs9YA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add VM counters that record the number of migration
success / failures during CMA rebalancing. This is
similar to other migrate counters.

Signed-off-by: Frank van der Linden <fvdl@google.com>
---
 include/linux/vm_event_item.h | 3 +++
 mm/migrate.c                  | 8 ++++++++
 mm/vmstat.c                   | 2 ++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 9e15a088ba38..1711ff85a02f 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -87,6 +87,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		CMA_ALLOC_SUCCESS,
 		CMA_ALLOC_FAIL,
 #endif
+		CMA_BALANCE_MIGRATE_SUCCESS,
+		CMA_BALANCE_MIGRATE_FAIL,
+
 		UNEVICTABLE_PGCULLED,	/* culled to noreclaim list */
 		UNEVICTABLE_PGSCANNED,	/* scanned for reclaimability */
 		UNEVICTABLE_PGRESCUED,	/* rescued from noreclaim list */
diff --git a/mm/migrate.c b/mm/migrate.c
index 9e5ef39ce73a..63d771daa3bc 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2144,6 +2144,14 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 	count_vm_events(THP_MIGRATION_SUCCESS, stats.nr_thp_succeeded);
 	count_vm_events(THP_MIGRATION_FAIL, stats.nr_thp_failed);
 	count_vm_events(THP_MIGRATION_SPLIT, stats.nr_thp_split);
+
+	if (reason == MR_CMA_BALANCE) {
+		count_vm_events(CMA_BALANCE_MIGRATE_SUCCESS,
+				stats.nr_succeeded);
+		count_vm_events(CMA_BALANCE_MIGRATE_FAIL,
+				stats.nr_failed_pages);
+	}
+
 	trace_mm_migrate_pages(stats.nr_succeeded, stats.nr_failed_pages,
 			       stats.nr_thp_succeeded, stats.nr_thp_failed,
 			       stats.nr_thp_split, stats.nr_split, mode,
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 71cd1ceba191..af811328db09 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1392,6 +1392,8 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_CMA
 	[I(CMA_ALLOC_SUCCESS)]			= "cma_alloc_success",
 	[I(CMA_ALLOC_FAIL)]			= "cma_alloc_fail",
+	[I(CMA_BALANCE_MIGRATE_SUCCESS)]	= "cma_balance_migrate_success",
+	[I(CMA_BALANCE_MIGRATE_FAIL)]		= "cma_balance_migrate_fail",
 #endif
 	[I(UNEVICTABLE_PGCULLED)]		= "unevictable_pgs_culled",
 	[I(UNEVICTABLE_PGSCANNED)]		= "unevictable_pgs_scanned",
-- 
2.51.0.384.g4c02a37b29-goog


