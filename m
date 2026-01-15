Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDD0D3CCA3
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 02:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AE566B0088; Wed, 14 Jan 2026 21:39:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BDA6B0089; Wed, 14 Jan 2026 21:39:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D646B008A; Wed, 14 Jan 2026 21:39:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1275D6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:39:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FA718862E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:39:36 +0000 (UTC)
X-FDA: 84332642352.19.3924EC2
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E7CE1C0007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:39:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Vh/Ap+qh";
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768444774; a=rsa-sha256;
	cv=none;
	b=gHbTTxqeFpmVooCiWkdy0DkgfSY7/ugtcEN6TUTtQX0N69gQaffclMl4CMgQ1lUdrVuvUS
	EoSFRvzby3F++r7HYw/t2+dbaurlgs4514U6XMjSRoR7KdBxHVe1kXdxqXo2lqyzbNhQae
	N9OKIWiftjqWS61d8s8Fh7g75yLpvzE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Vh/Ap+qh";
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768444774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcW/hY6JWQg4aPWEmrNXUmJDtQucQInwfAPavQZW27U=;
	b=04+TlzewaMeJVYSicdNJSAekbtEzljRyiZlzQdzcOQET5IiD2U9utXf5MedHGRgbBugY2Z
	IvCJUQzb1iXwJYSz6pQGC1UDGFVNF8FSSMn8jt4Yh7DIRgbpN1yGW5IAgby435kx62Ujax
	BuG0VYvpuWmM/eiUGBDTnwj1oCMhmpw=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso5260491cf.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768444773; x=1769049573; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcW/hY6JWQg4aPWEmrNXUmJDtQucQInwfAPavQZW27U=;
        b=Vh/Ap+qhvP/xs5XMZLFfj0Fn+EUbdthe1RUDhWTe5DM1NUm/BFP8Dkh+QNwwiKE1in
         ozPJ8Zpd3SWWvCFJ05ni6t3jKqus3RYUcqUZW0s38VShHO+WageQ0IlkUgBKeUIcLZDV
         rLfQz+W4OdJNe4DYUDg+0zH3BPdsi3qqZq5JbTilVupPNcBY3dMOm1Eh81t+mGBHi914
         xcce0KkjkJmsfXDA1qP0oXKSvBIy340R+wcGlBx/uG564PhmRkaKWqz46Oo0SAjb8t5f
         DMx3uKCaaARWuua+7GVH/rKIBZTnYBozZRz/D8BE1M0XmeAzWgszZWiR83YSfHmGxhKU
         upCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768444773; x=1769049573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qcW/hY6JWQg4aPWEmrNXUmJDtQucQInwfAPavQZW27U=;
        b=iF4Wqszn5YM8FUAsxuSsjtmd1pRKFfTmG3ngkrFP8yI3/4tmNr8jLe04qgdH8Ligw8
         Zy2RA1frgxZmjpRwuzpxWVZLOzwMdlFe2I4T+G3fLGeVYyKwNCTi0PHZI/LvWNDruAI8
         91EKShpDP1nbuDyQAEXl1KrgrOVqicmXimL6errdwTD+HdE/7ZIAYMvIw6yPc655bXI2
         ev/RejKnnBTX3JRz6L+1pVPgAErxyCOndzp30tY2Q+fy2P7Bei3rkYz2ph+ANGmsZeYu
         bdT6eXplxzdKOtUolVULNlGgC1DjdCncTHVH7QscCcIHl6bSYIFyVeNoNtwh8x3Y5U0L
         9Skg==
X-Gm-Message-State: AOJu0YxcI6q+wvTklQwBJ+w3GWEHgbG/nw2GjCswdLHB2eowPjR7zK1O
	Vv3easPxXhHxrWXImPZe7J2A1hfAmWj5BvbUISLZiC2L+YMGr/3NaXAc9DirUHvgC+2LoRJIEO3
	rhbycjKY=
X-Gm-Gg: AY/fxX6G4Y3gMhGav2y1eEdj37ebCmP4CkTF/im6zGAGrbEUHeOXn6t9IteWaOczgAt
	X2+6eCWfZZJRn6JWUbuIzS4BfX8rGQrcVrjZQ/IBeUfoDWQCkVxWTmLbFIiO9xZV6z8HmbotTAC
	DfKgmvXIybLWf1SPiiO/SjBGGmxZkAfKCIwDLfuBy5OkB+lLR7sdJBpG2O/yeM4id9/kilgy06x
	PIZ5kPfqlms4QV4JDtCzNBPoDuLqslbEZ++Wb5aGobZztwf3ttosK8ZxrxA+juWrbAumKJSxmRK
	+FbugpSEVTyIiOHv2awWzUB1W8dNnnBSnflvc5cRDcBVoxbsaiN3pdeJJa6qREIayYzwF455aw9
	G9jDOWKlroLelwFNm/5dTISA7U2InrNNeppcwQqwDnRvOaN7gJMas7p6HkDR6Eg0aqrXjo/zcrJ
	iHwJ/fvCccmS8fbQyn89IP5lMroKlM/RczYB1U5E50YOpay4Y0ya9NfV+CuyIURJO73POyVyl83
	SM=
X-Received: by 2002:a05:622a:400b:b0:4ee:1f22:3613 with SMTP id d75a77b69052e-5014a96778amr49477661cf.62.1768444773152;
        Wed, 14 Jan 2026 18:39:33 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148ee050esm26777371cf.30.2026.01.14.18.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 18:39:32 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] dax/kmem: add build config for protected dax memory blocks
Date: Wed, 14 Jan 2026 21:38:54 -0500
Message-ID: <20260115023854.3484175-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251113145815.2926823-1-gourry@gourry.net>
References: <20251113145815.2926823-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bkguriait1hjufw9nunne7y6wtbxuaqx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7E7CE1C0007
X-Rspam-User: 
X-HE-Tag: 1768444774-53794
X-HE-Meta: U2FsdGVkX1/EAywGb+qPXDXEW/1elzHN/signCas1Hn4vqowlYhEw4QYkU3q26UW8N+KpdFSK+tPj1CUoKK8EaeZzF11X3p+iuNXSiClufyQVNVQqbLs0NQNki09u/8H3FPtNjs5XymeanaJBDeWCATJMQuUsYRYKzOjqwYNSrpaWaLA9Jrd//OvHUHvWgRXdZg0VazcLFniRaAXSwXjAUt1LnCVqNgxmZkh3MLABIFyXXhUdq4uwSRWj6JbNWFaKL46KRqNfdkCUeEc75Eipr3u43OKmZeI3ERmAz3mT/xM0uob33BL4Cn77hz/4wveILzc6H8FGWaCwPdbegMWY4NKpiRdVakEwkEeO87+/u7N9198xjMg1zCNGkr/Y77pLXIJOT31MKSL+YuJSoOMw4dM/ws9cCfvCpgCmLYsJyNEcORiYWGfTgn21ivsJKxcxsseJye6DoTXNq+JZLNKYt0YdbXfJ6QT7ONE696YN3U6L7XkBlkPGgvR+uk83pg7LJBjZ8rPIGOAkOJmtO+4SenjgLAwXgyEPz3fpS2ay5wR+3xuucSGwKzLB1MxmHsB75Z9vs3JW4Hq1VlIpQr3qhEYjvHO7fuhoNGnZ1Mg3QapsBJYAA1c37KgPrrX3kT0W1HYF2tDZh8XC7kvpYo/ozUvzzQw8xldZfTM/iESeKtkmdkiswrVFntbzQbw/d9qBN90XCgfPr+lZa486oLvcpolB9X/sFlCDPN/arF2gGrkBH/2h7xBMya0FfoyVUiVl4546cY9Y1wZw5u85yjKnK0nHZDWv65xz7qHFZRU8aPq+vQlFkAXU65BPHssTWtKhdmYDM79sHE9ZMQzT3X0m8T3MjU01RVTlBEM/d6EU5WCA9KwMj4CkQHzOkB+/R12fW+Q4C2hzqaG5lcTndGTi3ATvNAFwIBenGzcK2FNGI/kpQWY42VCQ0GeDVmBAIESxKshRKuDh/fQtwZcWbA
 JYP1xEXp
 j3+pTjrSBFGYkwiNAU/XqzbE0EYJFlgslD81LWjHrZS4nJ4GKvSJlHHl0T97Fsp6R5l1fC9mQBbXAGlfaptm/Lx97cms3nbxQvU9HpPb8lxcsxn8KQqp1qqz8CgCFBHgZLkgvnyRjYPfqVLpXskttyKnbzkxaIt2R05XQrXaU/uCKI/JOadN2lCFxxcXUX3peNJRBH0LRTK3TLEMLFyHvjyrxswgMbdTUsVq5JP1cpw6j4JfXNSeG2flzgC6/5YXSJFSmlQ5hrXsvF/6wemDsfT6kwMt8h2TRq0vYvGoqwXWMoV6wx3F2ZgygXcSu3NOhOW8o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since this protection may break userspace tools, it should
be an opt-in until those tools have time to update to the
new daxN.M/hotplug interface instead of memory blocks.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/Kconfig | 18 ++++++++++++++++++
 drivers/dax/kmem.c  | 29 ++++++++++++++++++++---------
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index d656e4c0eb84..cc13c22eb8f8 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -78,4 +78,22 @@ config DEV_DAX_KMEM
 
 	  Say N if unsure.
 
+config DEV_DAX_KMEM_PROTECTED
+	bool "Protect DAX_KMEM memory blocks being changed"
+	depends on DEV_DAX_KMEM
+	default n
+	help
+	  Prevents actions from outside the KMEM DAX driver from changing
+	  DAX KMEM memory block states. For example, the memory block
+	  sysfs functions (online, state) will return -EBUSY, and normal
+	  calls to memory_hotplug functions from other drivers and kernel
+	  sources will fail.
+
+	  This may break existing memory block management patterns that
+	  depend on offlining DAX KMEM blocks from userland before unbinding
+	  the driver.  Use this only if your tools have been updated to use
+	  the daxN.M/hotplug interface.
+
+	  Say N if unsure.
+
 endif
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index f3562f65376c..094b8a51099e 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -184,6 +184,21 @@ static int dax_kmem_memory_notifier_cb(struct notifier_block *nb,
 	return NOTIFY_BAD;
 }
 
+static int dax_kmem_register_notifier(struct dax_kmem_data *data)
+{
+	if (!IS_ENABLED(DEV_DAX_KMEM_PROTECTED))
+		return 0;
+	data->mem_nb.notifier_call = dax_kmem_memory_notifier_cb;
+	return register_memory_notifier(&data->mem_nb);
+}
+
+static void dax_kmem_unregister_notifier(struct dax_kmem_data *data)
+{
+	if (!IS_ENABLED(DEV_DAX_KMEM_PROTECTED))
+		return;
+	unregister_memory_notifier(&data->mem_nb);
+}
+
 /**
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
@@ -563,13 +578,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_resources;
 
-	/* Register memory notifier to block external operations */
-	data->mem_nb.notifier_call = dax_kmem_memory_notifier_cb;
-	rc = register_memory_notifier(&data->mem_nb);
-	if (rc) {
-		dev_warn(dev, "failed to register memory notifier\n");
+	rc = dax_kmem_register_notifier(data);
+	if (rc)
 		goto err_notifier;
-	}
 
 	/*
 	 * Hotplug using the system default policy - this preserves backwards
@@ -595,7 +606,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	return 0;
 
 err_hotplug:
-	unregister_memory_notifier(&data->mem_nb);
+	dax_kmem_unregister_notifier(data);
 err_notifier:
 	dax_kmem_cleanup_resources(dev_dax, data);
 err_resources:
@@ -619,7 +630,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 
 	device_remove_file(dev, &dev_attr_hotplug);
 	dax_kmem_cleanup_resources(dev_dax, data);
-	unregister_memory_notifier(&data->mem_nb);
+	dax_kmem_unregister_notifier(data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
 	kfree(data);
@@ -640,7 +651,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
 	device_remove_file(dev, &dev_attr_hotplug);
-	unregister_memory_notifier(&data->mem_nb);
+	dax_kmem_unregister_notifier(data);
 
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
-- 
2.52.0


