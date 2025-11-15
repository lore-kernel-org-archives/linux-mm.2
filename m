Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5737CEBF86
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8F18E0021; Sat, 15 Nov 2025 18:34:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79338E0007; Sat, 15 Nov 2025 18:34:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2E28E0021; Sat, 15 Nov 2025 18:34:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4BA8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:49 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46554160362
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:49 +0000 (UTC)
X-FDA: 84114448698.07.69FAA16
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7BFA940008
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ahOlqux4;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249687; a=rsa-sha256;
	cv=none;
	b=AZ54fWZjvNc4BsexmCPGQLO1bNzvCuml6c/ONH3UQ6bgAJol6oWpo/PQE3Gz/2S6cRJtFO
	LgZPEmaKg4cAla4Alua3IOdu+8cUpOZ7v6keInwLGRbN8iv3N6k/7znTWvsw1H60JtfY2e
	lfToCaaB/oLb4ST+mG38E62YuFZ8qqo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ahOlqux4;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eLZ78bp0n4p6Wf1XgYT9EXfbUSCOwy9XSJd2QadY6Y=;
	b=YK/XGKp1p7BD+ci04If/QP0WJqU1SU8WCsNZjreBmOjXEGwRalloWxL1i73hlT2tMwNBXT
	5JcNtg4TtZE7iddrI8kL/rMVvEhWEtiOlFNFVCH7jb2elVQVpP3JDRWjEKVZg4h0VogNR+
	nXyrG26tHHNIPdCby23lcU+zc4el2Y0=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-71d71bcab69so27331907b3.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249686; x=1763854486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/eLZ78bp0n4p6Wf1XgYT9EXfbUSCOwy9XSJd2QadY6Y=;
        b=ahOlqux4Pu07wDOUe2k986VDWUSeNiNIwGboE4ll/hOu8pYP06dXVGj3NYRqKq5K3h
         sNP/TwnigyUa+9Dlu8aXR1Av4L63csy21YZsNtecmiyfLya5y/+3cixDzDMOFn6iaadx
         fcEbApFRAcQ4Icutu1N2qQXUtMsIw1eqmjlU2IVbIRJJMpwK5c6DlWoomyn61ArR8PUn
         Y/G1UWYJuWlMkBlpe+dGUEG2ZXi3wQBdGSGBZM+QuVyaeUcedC1QKEPdRhkZ/vDKVgEO
         Baak7yo3R8T4vdwxsUXyeSGGa6dw0OKQ+dDFxqlzilYJYKKttBbyk/yOOjccGj2TWjgG
         e3UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249686; x=1763854486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/eLZ78bp0n4p6Wf1XgYT9EXfbUSCOwy9XSJd2QadY6Y=;
        b=hEX1GQyLayXY78UutFK5ZIb45bdD5Ct4xJXgBQtdW0MBxm1PYPs/0qVjTzFO+uasAd
         OXeiaj3lFVJO6u887J7AA7kRPKlvay3bQQkKlDXtuyxI+5XRCaCLnZ5cifxr+2RzAF87
         kJ/WQUjWv6rClIDCTEEgMqZF7tyBp0bMJuDlfEdbc2rXPsU+zk/hXqajUYDX6ITaR89z
         viS79ahgIVvGjaqtcNKW6z6QSpGJl8QkFV7c+EhpA0GH6NjHZ8pdoAC6moGQ9xsEtxbg
         r3VyZ4+4dcTIhz3TPKsQ+ZKqgBtrPHTRLbUw/3ytwpih2z62fyLeCn6yCpTr8SBBeSUT
         LLSw==
X-Forwarded-Encrypted: i=1; AJvYcCW6+b3Tw8AFMf47KQmlQWfAzr615F9swNoWmi/5OQw3RS2W44duHPNJRidKDwZwvXC1f+tsOESfeA==@kvack.org
X-Gm-Message-State: AOJu0YxXGrVZzuifktXBvd6Da3afVweeTTpPhxlhW903n9J3rdJIKm9p
	Yk1JxVBUPflc3cTJ7Jig8992G3btblSkMevI3G2gQGMvHzJSpE0s8cL4ZYpSp1GW/2w=
X-Gm-Gg: ASbGncuctKILtqCxGy9mMqfKYFIj2j91B0WtV1q4zZOwj57Oog6yqT48LaghGEE2znB
	zI5J7i7mVtbHPJQk98U69/4nb1Eh4qP4Jt529qsUU3XNETmMnHQkrFO6tkQHDgY1UdbvAH8DV1u
	zdNnEHwkrYUGUuWb6xbCiOJPa035lHkEPJdE5CSeTdHbxNhJcSrCc+yFxSxtN4OgKSTFbgOnDph
	+NEhSjDjGW6q0KlRvGV+wW9yZuZlUmK6nN57QXpkV7mz4VnueOWu23rU5dXB7B7fXjCrKfHcpn3
	s40lQrwCgVs35atNDBqgdgrshaS9Gz+uT8GKOQttInnioLpIdjz3+UEwvwARrQDbdlMjKfoZsWP
	7Q39a75JDL0lGdiN6SnXnxm+GqOIiaaE2ub/FrzzRas9HDOxVQT/U9MVQsCL9Mxvfl/Ys+4WEhL
	rYd+kZ3jEFZPhG+zy4ncDCECViCti7ywDMNEPjnFEye6hcFeu/M9ZT2CslkaJMP5qPp6Zi
X-Google-Smtp-Source: AGHT+IHk0jQUizdAzkiK9Xpe2uUL2VAa8k1RUUTK2HykUPyp4K26BcN3/UXlJAExurxnthMVN+vR9Q==
X-Received: by 2002:a05:690c:2603:b0:786:5be2:d460 with SMTP id 00721157ae682-78929e29f77mr74299087b3.1.1763249686563;
        Sat, 15 Nov 2025 15:34:46 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:45 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v6 13/20] mm: shmem: export some functions to internal.h
Date: Sat, 15 Nov 2025 18:33:59 -0500
Message-ID: <20251115233409.768044-14-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7BFA940008
X-Stat-Signature: o1qh6husj461bjh37s156e8qy3ikjkh3
X-HE-Tag: 1763249687-59111
X-HE-Meta: U2FsdGVkX18jzQcOKWGpr3l0djqv/BHYXmolbKkWknJWkzgssWcLvclqFLxhaKhljXiqc68dlnsd1es35RL0jVaiK66uP+5WT9Jv/zyDjww0VwwzR1XD1y6Npp0KgIYExgpq00XEpLJVKExCWIAJ9qqH/vZXRMrFhxu/7QC4Qr/kvpGpgi3QvFabON5FaqjE4fYJtuiznV/6A8L7c7dhX9WYA2GdKPM+ioEMNueW6E9M+8vVU9an5uIx8Ibfkw2y9RLKWrIAvl3DUpBoWe0BUnCLgig7MlaPgLmjEAjCJOJy0ETi7a5DlQzP0elVrojhU+evcNBG0mD1l+AWfG1nNtjFaAgFSOwdZT1etCG4bP7KRJe7WSoDB4lUfkmu2ePBVPtQKyGuS1a7SkMogDA7yv2u/RR5igNLf9r0OaJsyzGHv0KQg6Gb5kWsf/n1UVdSq036cAER2kr/RAqUsaJvXaQr9kjBE+WpVBej8mQFAQ7Cdh3TfO230gsHn4VzsBt8KRfypyN5AUzhQW3/UiXM/bt1T2BQBAid9QJ1h49oiioMbJ6gUevlclraSnScBGLG/AIA/JbFSI9qdw+LtFSf0lDfeolHP1S5g0at+rEe2HojbTKuz/h1MG5ElAkqZQz/Zg1d0QtBFzC6d9GPP6jsbWEzGhIOwxEUhbFuXoD5wmZLGYKAymP8F+//Pezg03232TBNw6u9D5bkatVaUj7GvPuWiA+vY/kNhpqEpn5ULxJU399TorUN6Tme7y9FmJbNmjXPLODriHk2op4J/AmlX3Qk43KdTN1GiOm+H7oyOVMqgk+Ba8pV8DjapCM3L6cy9dL72Pd7PO+EtDqpa9SBHgbyw2YTX66698F0zUHByrabP65trF4ShrxDpNOqrYSnrK/UQlv8mcJT3E2LqB8H/q+UtWsorTfTiCZPwsAUvTT2mmIOMRHHhgqPiUVoMLPgxErjXhXKyXxMI7vH/XV
 V6OFIYqU
 okX0ZrQvHOQ7cmZ+7ovOfEH+tHq0xTm2jnV4l7VY/PIR6W8Ck1hkyoB7qP2QiWBRef4uuaH0zupHkIhPCyfkMnCy1ZnPNUmeZwcYPKrrWSwuiiZHPIQjfi3xlnB6ye/qL7kNCafLm4xnxDd1XViRS/P46pBbs79FcjsKRkSl5l5FIAHkqWyRKewvoTdiZi/WUeKro/DH71nJ8j8YU+GWYa76r0xMcvhqpQy8qhT3UO+Pfsq52APnGxat1rMTs/DSLAbsGRz9sm9lnWiGxyBk0AFUlW2eknh8KpznVJiC3gdDS7tWU4Gee8DFkkqTatFPUFW/BJE2qR8fxOLHarEAM1L/GpWeEvC1/E71K/JZ7vWp6sWsxJCJJCk9aBgSBG0hmnwKQV4qyoejL4liyj/2j6XntYmQHZQas9syxqfpt9zqOfM/NVMRuXdwLyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

shmem_inode_acct_blocks(), shmem_recalc_inode(), and
shmem_add_to_page_cache() are used by shmem_alloc_and_add_folio(). This
functionality will also be used in the future by Live Update
Orchestrator (LUO) to recreate memfd files after a live update.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/internal.h |  6 ++++++
 mm/shmem.c    | 10 +++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..4ba155524f80 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1562,6 +1562,12 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
 
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp);
+int shmem_inode_acct_blocks(struct inode *inode, long pages);
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped);
+
 #ifdef CONFIG_SHRINKER_DEBUG
 static inline __printf(2, 0) int shrinker_debugfs_name_alloc(
 			struct shrinker *shrinker, const char *fmt, va_list ap)
diff --git a/mm/shmem.c b/mm/shmem.c
index 05c3db840257..c3dc4af59c14 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -219,7 +219,7 @@ static inline void shmem_unacct_blocks(unsigned long flags, long pages)
 		vm_unacct_memory(pages * VM_ACCT(PAGE_SIZE));
 }
 
-static int shmem_inode_acct_blocks(struct inode *inode, long pages)
+int shmem_inode_acct_blocks(struct inode *inode, long pages)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -435,7 +435,7 @@ static void shmem_free_inode(struct super_block *sb, size_t freed_ispace)
  *
  * Return: true if swapped was incremented from 0, for shmem_writeout().
  */
-static bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
+bool shmem_recalc_inode(struct inode *inode, long alloced, long swapped)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	bool first_swapped = false;
@@ -861,9 +861,9 @@ static void shmem_update_stats(struct folio *folio, int nr_pages)
 /*
  * Somewhat like filemap_add_folio, but error if expected item has gone.
  */
-static int shmem_add_to_page_cache(struct folio *folio,
-				   struct address_space *mapping,
-				   pgoff_t index, void *expected, gfp_t gfp)
+int shmem_add_to_page_cache(struct folio *folio,
+			    struct address_space *mapping,
+			    pgoff_t index, void *expected, gfp_t gfp)
 {
 	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
 	unsigned long nr = folio_nr_pages(folio);
-- 
2.52.0.rc1.455.g30608eb744-goog


