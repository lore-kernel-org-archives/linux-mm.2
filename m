Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D0DCE8D79
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186D58E0006; Fri, 14 Nov 2025 14:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157BA8E001B; Fri, 14 Nov 2025 14:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE99F8E0006; Fri, 14 Nov 2025 14:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D638F8E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D52A13B239
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:18 +0000 (UTC)
X-FDA: 84110128116.05.B325C20
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id B5B324001B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ata0NbDu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146816; a=rsa-sha256;
	cv=none;
	b=pcp/H926HG1RmrCN5wTCeuEtbzDanuTjqjDFanpoVP4wihUAGh8pdLNobMaGe7YgYTLRuq
	XaOvM3CXMwsMqgw9wbZP/cy785hmJ01gFPbzb3A9ZuCiEV9Cy8EUxCu+hK4swzjWyW9ISy
	jBw8P5U5j42vltY/tkCW5AUAwLB6GyU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ata0NbDu;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhwkZEBEr5WhXa61Cp+OEzgGPmuzFUzbgIvGt1K8dx0=;
	b=8pzM+zGnrZNpyQ0JwzdeMX120Nky+0fsu9D0IusbnNZwnO3HZHxyjkKf/mSvuan9DlB3Vl
	cZJqU58VEgjHXBOZYeCbMEOxO78l8uTukWx6gF8jRwB9rkjJwyngiy7sMsq7HkXpFUb7A+
	QETYqFzim43kSaAgWXvDDYfPYDlVcME=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63f97c4eccaso2329312d50.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146816; x=1763751616; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vhwkZEBEr5WhXa61Cp+OEzgGPmuzFUzbgIvGt1K8dx0=;
        b=Ata0NbDu5QGh1hM9dC4fdoFgJOYP7EAQ5hFLMrJwM8PSMp8xYolXw7a5NY8GizMFrq
         wiQVegd+ehHdgyB3JwrqpjN+SgW2WenGoYJazOPemYSaJB1uO33tpP4WaEBL/wkpJ1yo
         CmlNmt0kkfu+/Y9E/G67p4Oi827qDVZezVgkTwPg5SyAkPPnP6IMRD8vdwQ+ovlqdkcI
         7YJevs8bS85kgu5kHqQrgDTPlXrVBFJg7VoQ4QPLlwqiT5ld5kmG0AQ8NlZXyK3xTg9v
         af7DuBGR8b0Z/USRCjuQq+ZZ5YEJBpKKP9Jebg2Bn49A0NXyRqeAm9anCBJeLzv9zrUA
         /6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146816; x=1763751616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vhwkZEBEr5WhXa61Cp+OEzgGPmuzFUzbgIvGt1K8dx0=;
        b=Fv3eAknQXnp+gqE2l/RMtOBZTgrySpmzG8d4xsIZrO28WsZ0UIe/tjS1nHtFqweZy4
         3rZNxO1D0pXP279GcTBleF2td+AYlI/muNCgWSaUNIau2Zr1/wCImXK+cVrpFOWmVyi2
         u8mcBis2FJ9N13+9FjE7DSRxVbOVRlBjONA+qtOZEMTw1r7JgH2H/Lt52gDcet16XXQn
         rg0PtFtISDafqttPSmkkq2CMZPnGsU0yYN2c3DPb3Gzm7NEWAGOhLjhXREaK7XS71pCI
         cSZQ3hdNA4WRq0BCPLG0nOmKwz+li/iOgh/VqBsbznyn6MjawaRwbTg7FXnbzhR6LPTc
         HsJg==
X-Forwarded-Encrypted: i=1; AJvYcCUsVU69M6r2B4FRkjbCq4v0C3SJcSgbNWeps/VjcEyL23rfnM/uAxDDswDmgCOaFsZf7QkClpZKJA==@kvack.org
X-Gm-Message-State: AOJu0YyZgDGP6Nrnwf3gB6NNz+xI7H+dlh/uk5aygs/YnG2mkAE0l69B
	KK46gD4t1ebbk7snjINW7iBQTqOkF3Wwn0Kp8f48rmieWDKvtsFh1tmfKKjVTd+EoYM=
X-Gm-Gg: ASbGnctn57KYsmQ+cauvSqrgJy+A1Twr+/3zKBV0GaaSmlcAEYPL4/LBix5W0bVoqxx
	r/H0ANuA3hlLJLUr++M/X5yC0Rcodk4Dp5W+NQRKIZGB+FQ7hR0UzMw7DUfYQmV4V9n45xwTzR3
	NbFPutekv4EM1Ny2qP0kayHfznCBehNfbcf5wXf9QV/s2YlPehMH37tMDkoWW6j0OPtICLqMbkj
	wco56Ol/c+VgxPySlkpUToFmuvmJsJuD3D4MlHN1sM8n3NX9T1PK2sywG8OvMZAyzliluSbtLdp
	rZeOTkifW08GzBO5rsD/wzlYY8ZsoKpNGZ/GqWjQmkcEj0+whN6lK3Jlm57cvpb6tdHKHBT6EtS
	gABzw1W8IJJ/A11T7NPqPPONwak3VpIEGRlcaumPNoW0wd+UqZLx8lnG0PnaipVlyiF3fNKtSSC
	Tdrqz320xVWtpd6LFIdxnVIC5mvVWgVEnymthOAHx1D7S6H8oyVBmqjuvmCkzRdkL+qedtfblnr
	hfxh0A=
X-Google-Smtp-Source: AGHT+IHftz04artgctWkQtgZIqMhYzNUfbd5DWlI95J4Cany7ZO/gJCBBXAhqFr39ej1tMVzPCYDjg==
X-Received: by 2002:a53:acc3:0:10b0:63f:ba88:e905 with SMTP id 956f58d0204a3-641e757cfa3mr2955979d50.30.1763146815780;
        Fri, 14 Nov 2025 11:00:15 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:15 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 08/13] kho: Remove global preserved_mem_map and store state in FDT
Date: Fri, 14 Nov 2025 13:59:57 -0500
Message-ID: <20251114190002.3311679-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B5B324001B
X-Stat-Signature: kdrni1fxdn98bumj6x86psz8sh4xtd9n
X-HE-Tag: 1763146816-275381
X-HE-Meta: U2FsdGVkX18l/H27CvRFGiKgpYTHpXAvCwx6Prd5KDSS7JFNwYJGKa7wKxnmaKqje2YAlhpWgl6b8tn/FVmx9ZEBtTP19z0IkBK4DVWYPsn2X48XsEBQYMh6OCKXDbO/gPMEP0mKHg22AwuF98nMIpsRups2SaAEA+fyOkYPfq7BuwHAYUVLbfFL/CcaoyNJ9T8qjwEwhRek/WtMHkc9aigwI84+aq4FwuCJU1TAriY36RQFT8QAWwBuYL02QftahlP+Xz4IFqGqQ7LLdX2tC1dhuPIH8DhkVOjSiVAmce52a3wVswRcWlW7Ve72xNmMhMgBmnN2BTGslhmOK1FkEDd1oIGxlmCAxPmiIzMsxgFGvNDIGFDzCML73HiuZ5XJ9jtrpqk92YBkSQ4SENS0Ki1ChxZRIrn6+sIdWOOebZgc9YrzZ3bJ47kc9GEgiR88D/foPY8Z4KPXGpkAuROcKSLE6sy2Z1e9VJ5zB7GHvXzfPWE+jgTYhAHSSS759RqgQoS8gaCkQNlKxGBsS5Taq6bHwzcmdW74PsJBYYGrOnvWh10xREkNDRWd3+93B+Yks0K9jSn1AG37bq4CLaREX3VadKqoJsGjWPeG08vII6rXBEqKiBCTmI0dEWb1faDszgjplsbKN88winKaANGdfjmZo9rtKZSX4dRB9wU9uddw2ZlncUViCGJPHWfz0O144kYm6C9D8AHXALG0WezJQSsBfqK+ehKJmyPLAb5rBCmh0no13dIQwUeFJWWH1wWu+q+kIjZLe/8Bh0S6o011eIaIpLhkBcNxTP9wCqdPWpk1z67maNo64qpT9Kr7x3cTe0nPaF71CkfGtGfP8wpcDep9sPYNne43aNKx6c0O098rZUhbuK6DvJWKiNxI+5ABxkVo2q8ytbLJMASWZB+vkeN1HjEzs7FViy6iiJgXtB7TViHS+3g3ElKVKPlp6NOYgb/75flOGOgPQ4i6sTP
 E4OSakFk
 xFGdZQeBh2AXz6Vx8v9x38Nymc0q9yJGjvvHmXyFhGkzXeDsXGfnzcZIqAtPXg65iSW9aT2OAw2uDbpP68xPhFvSP0bNp02ZDV4ePObl+zFFRlTbaLkpcPiAibKlHUzvQKFD5dFVNm3OjL3UdCTtGU27PgYAuhVzS7q3SmElO+Ieg4uq1VAax+HHKaBZdupfwNMZKTn7BhtmY9Q9yBnBbZ9e3fLw3ljJnuBlFdj19wnhx72vfF00RoB9MssNfbHM6A6Y5Zea5LzMNs5U6Tx3tiLewXtPUxc9DMRPQtA8StYBMzOOBwZIJGjY80NKbO7fJnr5qyF8IpembrFFLwVts76EACtzjDla/5AyMH32oJ6P+72A78WP/xJF+mduzZ+JR0RRVKp5UcI4CX/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the serialized memory map is tracked via
kho_out.preserved_mem_map and copied to the FDT during finalization.
This double tracking is redundant.

Remove preserved_mem_map from kho_out. Instead, maintain the physical
address of the head chunk directly in the preserved-memory-map FDT
property.

Introduce kho_update_memory_map() to manage this property. This function
handles:
1. Retrieving and freeing any existing serialized map (handling the
   abort/retry case).
2. Updating the FDT property with the new chunk address.

This establishes the FDT as the single source of truth for the handover
state.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 43 ++++++++++++++++++------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 297136054f75..63800f63551f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -119,9 +119,6 @@ struct kho_out {
 	struct mutex fdts_lock;
 
 	struct kho_mem_track track;
-	/* First chunk of serialized preserved memory map */
-	struct khoser_mem_chunk *preserved_mem_map;
-
 	struct kho_debugfs dbg;
 };
 
@@ -382,6 +379,27 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
 	}
 }
 
+/*
+ *  Update memory map property, if old one is found discard it via
+ *  kho_mem_ser_free().
+ */
+static void kho_update_memory_map(struct khoser_mem_chunk *first_chunk)
+{
+	void *ptr;
+	u64 phys;
+
+	ptr = fdt_getprop_w(kho_out.fdt, 0, PROP_PRESERVED_MEMORY_MAP, NULL);
+
+	/* Check and discard previous memory map */
+	phys = get_unaligned((u64 *)ptr);
+	if (phys)
+		kho_mem_ser_free((struct khoser_mem_chunk *)phys_to_virt(phys));
+
+	/* Update with the new value */
+	phys = first_chunk ? (u64)virt_to_phys(first_chunk) : 0;
+	put_unaligned(phys, (u64 *)ptr);
+}
+
 static int kho_mem_serialize(struct kho_out *kho_out)
 {
 	struct khoser_mem_chunk *first_chunk = NULL;
@@ -422,7 +440,7 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 		}
 	}
 
-	kho_out->preserved_mem_map = first_chunk;
+	kho_update_memory_map(first_chunk);
 
 	return 0;
 
@@ -1223,8 +1241,7 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	kho_mem_ser_free(kho_out.preserved_mem_map);
-	kho_out.preserved_mem_map = NULL;
+	kho_update_memory_map(NULL);
 	kho_out.finalized = false;
 
 	return 0;
@@ -1234,21 +1251,15 @@ static int __kho_finalize(void)
 {
 	void *root = kho_out.fdt;
 	struct kho_sub_fdt *fdt;
-	u64 *preserved_mem_map;
+	u64 empty_mem_map = 0;
 	int err;
 
 	err = fdt_create(root, PAGE_SIZE);
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	/**
-	 * Reserve the preserved-memory-map property in the root FDT, so
-	 * that all property definitions will precede subnodes created by
-	 * KHO callers.
-	 */
-	err |= fdt_property_placeholder(root, PROP_PRESERVED_MEMORY_MAP,
-					sizeof(*preserved_mem_map),
-					(void **)&preserved_mem_map);
+	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
+			    sizeof(empty_mem_map));
 	if (err)
 		goto err_exit;
 
@@ -1271,8 +1282,6 @@ static int __kho_finalize(void)
 	if (err)
 		goto err_exit;
 
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
-
 	return 0;
 
 err_exit:
-- 
2.52.0.rc1.455.g30608eb744-goog


