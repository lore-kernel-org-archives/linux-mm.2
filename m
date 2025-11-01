Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705C2CCFA03
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 14:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986B68E00B0; Sat,  1 Nov 2025 10:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9101F8E008A; Sat,  1 Nov 2025 10:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825E88E00B0; Sat,  1 Nov 2025 10:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 694318E008A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 10:23:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A978BB0A0
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:44 +0000 (UTC)
X-FDA: 84062256768.21.CF49123
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4584020010
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:23:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=d+XOuVKt;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762007022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57rygU5OjDWbT5PCPIwncZxw1NBlZuRuRnZzBsppy54=;
	b=3MBmcKIX7f7qJiHluJ3xfpO295GUDWIBjUI8hGrs2GUP7YdCiGjG4BVowrJe++mQYiy8Gv
	DdsCJqCAm8qaSAK8lNKgMTZ2XxI3+NEourw4UxRFebUy8/bhhUlYAqn6AU/SkFm+Bf7Yhw
	PHkDH2L3M0/0t8QX2q7t6GrIn2jx7IM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=d+XOuVKt;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762007022; a=rsa-sha256;
	cv=none;
	b=JMK52xIDA7cTmMbKu94nSC3WLvlApkEtDkgVZf6B4czEMA+FsvLJ3qGzFvYUKjFes4fFUb
	1RSGkdZUm5q07FHC+vWUc5sNTKBG+taElxiQQTFPvp/4GJvTcUAanpPya+8TF/NFACPRZL
	y81meyHbSAY6tI/Ar7Tawzxehs+dVl4=
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-93515cb8c2bso1362285241.1
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 07:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762007021; x=1762611821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=57rygU5OjDWbT5PCPIwncZxw1NBlZuRuRnZzBsppy54=;
        b=d+XOuVKtpTNOXoryDmJfWZjW2cUXnmReTsfztrk7z56aZOgSZa3CdVyIkr5V1XY2AK
         B5mWgkuv28fuPIf9aQT9J8LCSrpn7s0V6HlFdCdFe+u4Dc29Dck0UC7QJ4GQFF+2ebpP
         BD0qXJQjXbHcfj3xhJeLK2rHq2xrF/I0oW8L0uOh+qqqXrUmLY3+AQYlWJuCaWX6n/hn
         oMTbUWAxXBwmldIyuAUJYvvnogQHz1ITOn2/nBYf1/NWuV3o1qBbrKHwC7Ql2QeYhgP4
         7vY1RjxBPO5mcfWdVjvLAD8Pja2N+1WlC5/q7uedCShaGPc9Zjs6gMltngxe1120gKEo
         Sppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762007021; x=1762611821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=57rygU5OjDWbT5PCPIwncZxw1NBlZuRuRnZzBsppy54=;
        b=WrGKDm2F2vz996y3uAVYMfXb6301P4Ru7bBXe0PChgwYQS8xERWdY8zhy7NSxuCL8b
         3VxHRjqfwhrraOIC/MdDZk28cGBxcxEE762HXy0dPFbYg07JmfHzQ5/78/fbJA1cO5zB
         yeNzS+l167EBTIbbntWi7XSWfgnYJJO+4v4WSDQD6agE94Ws5DjZiVSroCzrpYNzjtdZ
         rZ1tgy01lCfjVZJ70Ph5+jh+r1gBpX3Noj2xuv3RygWPikLAbJHIYZToEZSGMegqRvSQ
         kmVcfAcYevOtOgbRl450TA2mb1eaMqYrKLu2CfRS9vUScc3xxmWG27qAQ5Bs214zMqqo
         uSCA==
X-Forwarded-Encrypted: i=1; AJvYcCUzyL4TgrYkQ+eMwFEn4PdMAtVMiLMFjP3QzYyGiWEcBlxunbZhfMNxDv0xloCVgAa+CYZsYPMPDQ==@kvack.org
X-Gm-Message-State: AOJu0YxPN5XdSVcoDZIKnfNWELCKotVqlntyZAhGFJeEnE7CDQcv3l9m
	P+W0c543GrjIo8x4tZQ/8AgSkaX7LeGmHRC8mossYzxwY+tnXYBir6ZSLc+pyu3Cnb8=
X-Gm-Gg: ASbGncsaQ2P4nDTWmx27r7TlVhqM+tcag8BaOjxpvjZo2OZzbj9ibXJ327TaJIieCsn
	6iCyFX57BNNiu6EHGulY2OIRl5DrwwbihaeNboTtBcqXTZ3dtbdAJ8HKTIidm8xkDgdGV9y7Gw7
	87PUFPJX6uPvdrIoe5IBRnu7UkeUf8N6Mcwvnofou3cNS1cS3pHs0WymyWemrClUk+pSvpjTTLY
	lpr9pSE/wj2DHrqoyW1F6PSiewxj6pOZYjhtgRozkhO8Anp0IGxE7tPaaxClmgq5Suzsppowv9w
	ToTV0D4dJMxHykAyEHbPPPRSBGkCoMC3ziveNFtPzQohh+ydhHaRhCRj+go3zHsSZ6AxPD0RpfZ
	ma3L+LII0h0XckmKEkEnu+Ss6IM7aTYZ1ziZVg0AOzJXfIBfGRpTF6TPYFmzFUnAHzz1kP/hH6u
	1gTUDsjXKG8BS+wwThE9Tbi8kLH9vtg3liYfIQsBJ3rQcVcfqUDNlPOfxm7Vv7
X-Google-Smtp-Source: AGHT+IFHTA9MFhIfCaO4quOEqPC9MjBBViuMWnhpeFtjZfr2lHvftLMFFMHCzKtyyjM8DjV8X9i0hw==
X-Received: by 2002:a05:6122:90c:b0:554:e4ba:4408 with SMTP id 71dfb90a1353d-5593e006778mr2627356e0c.0.1762007021390;
        Sat, 01 Nov 2025 07:23:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-559449647e0sm1776242e0c.3.2025.11.01.07.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 07:23:40 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	yanjun.zhu@linux.dev
Subject: [PATCH v9 5/9] test_kho: Unpreserve memory in case of error
Date: Sat,  1 Nov 2025 10:23:21 -0400
Message-ID: <20251101142325.1326536-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4584020010
X-Stat-Signature: kxmgae6takdpyjqt9kybfrjhqnbtuzwm
X-Rspam-User: 
X-HE-Tag: 1762007022-861030
X-HE-Meta: U2FsdGVkX19Z9KwHeYLLsQ+1tM38qTY43IVpYYO6j77/R3hqyLoj/gtzN+r3BpUJHuOPDqRs/G38jUDCZevaVtXyLVneCzdP7xD+2EMNrooRuwp2YwWImf/dpUeaXfSXFRu1UksMScz7sgHi1fDV0+UfQwYQgjZ+gZTX6OmrSfI2Pjazc7Ec3uChQTb0KtKHVt5VUfz3lo/NEMyxMTnnCR9iC0zFSqyVRbvdWlFbuOMtNyBaHATIp6LCHA1OHdwVd2LLATtH4XqcL43t2hNrMsl2q23pPKAYMuMaMvSrrBxVaW4EcQT81GIU5/C8cMX2dvjjf+TusIBf0v+KF5m81+eDkV6wGJx5+5mNwURgb7IGES/XzanJRUcu4GMDmvxoMheccb5r1N8LTIc+erZqjYWr1RIP2mwvaj98hEUAbYq9kmUGIFiKlMhFHsNinTqeaqgx0JvObt/oDRligKVFyY4dwuNtmlJBaiee+jHPjLXdjQONOcX4SeG/CgDC2jHOwweuLbGcBESYSEplgS148rP3PUS2WGZYki2FPgPXkRFFWe1Y+mTMoTSnPatso0kR1+7vr4VrQ+qXxN7Jw0npGa2zUCHulyVLEFnDi+cd43p4VDz4xAo4zXY5mFns+gkP9pC0T+w+ziXjmuidcd4ZAKf4lkwrP3AGYq9xiZdMR2OsnsinGcHVn+72IAp7yc8ATvk0nVjT7MrsXRSur8dpdCqIHLwAF9CbnrKR2q35hc5SkUjaA3po6SS1/8ZQBVjNy7N1sa/jckNQx9GHrHVKoWHB0Z+0bvtnqWJQmICC7eBL60cuiP/oP1hm+f/zbkth7ulv1fgjfngoGHgXxIccgbeImepo/tElT6E3ggxMlzzed+3Ghz75d7S0Tjz36adC3MEHtXlXl9p4Jh0huwaFFPp54WpHj91x/zt/iXcCKxeVuJgWsaI9BhUE/l/Xd+koP/KcvqnXQiVuuD/vsgP
 tf30E4UJ
 mIIofJM7WZkm6aCi5gPM3qbzfW3GNIGy1B0Mf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If there is an error half way through KHO memory preservation, we should
rollback and unpreserve everything that is partially preserved.

Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 lib/test_kho.c | 103 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 30 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index 9f7cfa6ac855..025ea251a186 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -33,17 +33,28 @@ struct kho_test_state {
 	unsigned int nr_folios;
 	struct folio **folios;
 	phys_addr_t *folios_info;
+	struct kho_vmalloc folios_info_phys;
+	int nr_folios_preserved;
 	struct folio *fdt;
 	__wsum csum;
 };
 
 static struct kho_test_state kho_test_state;
 
-static int kho_test_save_data(struct kho_test_state *state, void *fdt)
+static void kho_test_unpreserve_data(struct kho_test_state *state)
+{
+	for (int i = 0; i < state->nr_folios_preserved; i++)
+		kho_unpreserve_folio(state->folios[i]);
+
+	kho_unpreserve_vmalloc(&state->folios_info_phys);
+	vfree(state->folios_info);
+}
+
+static int kho_test_preserve_data(struct kho_test_state *state)
 {
-	phys_addr_t *folios_info __free(kvfree) = NULL;
 	struct kho_vmalloc folios_info_phys;
-	int err = 0;
+	phys_addr_t *folios_info;
+	int err;
 
 	folios_info = vmalloc_array(state->nr_folios, sizeof(*folios_info));
 	if (!folios_info)
@@ -51,64 +62,98 @@ static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 
 	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
 	if (err)
-		return err;
+		goto err_free_info;
+
+	state->folios_info_phys = folios_info_phys;
+	state->folios_info = folios_info;
 
 	for (int i = 0; i < state->nr_folios; i++) {
 		struct folio *folio = state->folios[i];
 		unsigned int order = folio_order(folio);
 
 		folios_info[i] = virt_to_phys(folio_address(folio)) | order;
-
 		err = kho_preserve_folio(folio);
 		if (err)
-			break;
+			goto err_unpreserve;
+		state->nr_folios_preserved++;
 	}
 
+	return 0;
+
+err_unpreserve:
+	/*
+	 * kho_test_unpreserve_data frees folio_info, bail out immediately to
+	 * avoid double free
+	 */
+	kho_test_unpreserve_data(state);
+	return err;
+
+err_free_info:
+	vfree(folios_info);
+	return err;
+}
+
+static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
+{
+	const char compatible[] = KHO_TEST_COMPAT;
+	unsigned int magic = KHO_TEST_MAGIC;
+	void *fdt = folio_address(state->fdt);
+	int err;
+
+	err = fdt_create(fdt, fdt_size);
+	err |= fdt_finish_reservemap(fdt);
+	err |= fdt_begin_node(fdt, "");
+	err |= fdt_property(fdt, "compatible", compatible, sizeof(compatible));
+	err |= fdt_property(fdt, "magic", &magic, sizeof(magic));
+
 	err |= fdt_begin_node(fdt, "data");
 	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
 			    sizeof(state->nr_folios));
-	err |= fdt_property(fdt, "folios_info", &folios_info_phys,
-			    sizeof(folios_info_phys));
+	err |= fdt_property(fdt, "folios_info", &state->folios_info_phys,
+			    sizeof(state->folios_info_phys));
 	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
 	err |= fdt_end_node(fdt);
 
-	if (!err)
-		state->folios_info = no_free_ptr(folios_info);
+	err |= fdt_end_node(fdt);
+	err |= fdt_finish(fdt);
 
 	return err;
 }
 
-static int kho_test_prepare_fdt(struct kho_test_state *state)
+static int kho_test_preserve(struct kho_test_state *state)
 {
-	const char compatible[] = KHO_TEST_COMPAT;
-	unsigned int magic = KHO_TEST_MAGIC;
 	ssize_t fdt_size;
-	int err = 0;
-	void *fdt;
+	int err;
 
 	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
 	state->fdt = folio_alloc(GFP_KERNEL, get_order(fdt_size));
 	if (!state->fdt)
 		return -ENOMEM;
 
-	fdt = folio_address(state->fdt);
-
-	err |= kho_preserve_folio(state->fdt);
-	err |= fdt_create(fdt, fdt_size);
-	err |= fdt_finish_reservemap(fdt);
+	err = kho_preserve_folio(state->fdt);
+	if (err)
+		goto err_free_fdt;
 
-	err |= fdt_begin_node(fdt, "");
-	err |= fdt_property(fdt, "compatible", compatible, sizeof(compatible));
-	err |= fdt_property(fdt, "magic", &magic, sizeof(magic));
-	err |= kho_test_save_data(state, fdt);
-	err |= fdt_end_node(fdt);
+	err = kho_test_preserve_data(state);
+	if (err)
+		goto err_unpreserve_fdt;
 
-	err |= fdt_finish(fdt);
+	err = kho_test_prepare_fdt(state, fdt_size);
+	if (err)
+		goto err_unpreserve_data;
 
 	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));
 	if (err)
-		folio_put(state->fdt);
+		goto err_unpreserve_data;
 
+	return 0;
+
+err_unpreserve_data:
+	kho_test_unpreserve_data(state);
+err_unpreserve_fdt:
+	kho_unpreserve_folio(state->fdt);
+err_free_fdt:
+	folio_put(state->fdt);
 	return err;
 }
 
@@ -174,14 +219,12 @@ static int kho_test_save(void)
 	if (err)
 		goto err_free_folios;
 
-	err = kho_test_prepare_fdt(state);
+	err = kho_test_preserve(state);
 	if (err)
 		goto err_free_folios;
 
 	return 0;
 
-err_free_fdt:
-	folio_put(state->fdt);
 err_free_folios:
 	kvfree(folios);
 	return err;
-- 
2.51.1.930.gacf6e81ea2-goog


