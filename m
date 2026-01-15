Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC9B0D3CCA3
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 02:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313856B0088; Wed, 14 Jan 2026 21:43:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF3A6B0089; Wed, 14 Jan 2026 21:43:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAAA6B008A; Wed, 14 Jan 2026 21:43:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6626B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:43:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEFBF1395DD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:43:02 +0000 (UTC)
X-FDA: 84332651004.01.3A13EC0
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id E4B4A180005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:43:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gY0wRMUQ;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768444980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcW/hY6JWQg4aPWEmrNXUmJDtQucQInwfAPavQZW27U=;
	b=hW0CbolmERk43J6F+r+8ojC+aFrUSLgpZhjqZJXPjJQzBM2r1fc3FxhkM65OECUsXK3Bqs
	o5eviXI7/F9TrbMJlHVRpbWEP/FoNeZp++r2nF4txKzkUkfBQCtqvNol4zogZHbizJeJYq
	UMCXhDWuNloT+tQlND4Gv7hrzA7P2NM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gY0wRMUQ;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768444980; a=rsa-sha256;
	cv=none;
	b=nmULrFju4Qm3kSvY57p0GiUbV5Bl/3WgTUw+CGbHeXv3m2LFUTuQV1t629lssR9NkSHZxF
	X1m4DZrpqrnFhwQ3YtmYjFoPQ5AHOEKAdxfE1oPINIlBuaJY9F4aEkVAPmBIAGObcumEkQ
	4OsMQv4N7+zapLQmqGiTw9qFY7+yM30=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5014e8a42aeso4548131cf.2
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768444980; x=1769049780; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcW/hY6JWQg4aPWEmrNXUmJDtQucQInwfAPavQZW27U=;
        b=gY0wRMUQDbieaydk+A0tVYqofEl+4GAEwf5Nxq1f/ZGvSBdYXXKm+U5Sozf2yGb8B/
         oW673brlXzzVYvqFHrzs5/fC0GgBkJ7zrySapIoP1lRwdW8X3Pv6EJrEN7CXRyRNrn65
         5zIkdbjZdGT30eZBbIMUOOHtzpH0J/8liWtA44ftu84bV+xqtlI0ryMhcRzfrojVwvDm
         BSjWnq7r1hJnrCpkQbzaiox6nbMgWEzCRCQcPS2N7zlH8ed/oXumqB7amJLyDEmL0nh5
         JVzo0DWP61H+9oauceR6JWPOM8fzUnpTRFw9HeuWs33m6ycrOvXxW4J+dn6XFoY+cTD0
         i3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768444980; x=1769049780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qcW/hY6JWQg4aPWEmrNXUmJDtQucQInwfAPavQZW27U=;
        b=Wf8jUrhiYfHQcy8T/bQh+y1ip/ht/emozcU4e/f7hEdRW2SzMeSVRItfSrbiieanyR
         S8aI/LLOeD+mJ/czRkpXMDKR3uoqA0Cz68Be1OuJCIX3pemYdX7rHt9CEGP6A/Nv+v8f
         ZJ1+LzBsGGfDD3f078VVlhJASdmZsEEhhtaL/Mh4KcOqsh3c41HkOk8avFEN1yinCF+O
         sIRQz2jTP82TN+eC8ncM5mEtFGTntvDVnyEJFDUIQbAkWUw5cv1YK8O2xF1cQ4cAnU4s
         S8s2vJLlwSTKKwujKJrBRAZa2WasrtTSUs4HpnDVGVFtRCRNCfujZUrIQ2f7GJ7X+FJK
         RZSw==
X-Gm-Message-State: AOJu0Yzzl5y5InaEVgc1uQr7CmYTmMhqtm676yDlzFD1Ri4kFNK/DsYJ
	bpio3XEFWJ6uyXOwyjVlAXa0UG0VPoSUc+dxH3G5djL3ZqhszCbkF6SaYZ1E+yiQi6G2VqjOIe0
	H6w4pwFo=
X-Gm-Gg: AY/fxX4StsyFXiFTqsT1RA+hhSMDwTkNPHnI6E0aQEfyPOpca4kCcqVpDlFA5zrasyL
	rGzKN9WOgJa2dwrTTrQjIfpYq8xWowTukedgCFqDch9yNVBnkknaGibJz+P/Xd4xQUgHGIsd45x
	2tUGEQG9B6ZPn5xeNXNcHBjrwiM1b3x+XlzSd+JqR833WKEHNcfcKlnpjMhazuX/gOZpgKYLiOs
	0FhnEZntu5OPubrJVWoVYuNKD27/5ja83PzLQ41WO/Pn1BMBCg5tWirpI0yOs6zh8DadUe0v0NG
	TZ0B8JKgkEuEuWM3ErbG+NVc/eSTvpCBiE9FEW5HNp6eKElBXuDPpfnrodwCF7yA3Lyv8FOLV0l
	7N95Sl0Ttrc1wBco5u2dEotYMju0nmu98Uxiq7GEafdhlYfdWW4M056HQI4CY+eIW/mWu82zCMd
	rVLdyzC1lDeXh9UdroTHX7RJN38H1V1Hog6hINkBmEEAxUumxiBVROhw2uuS9dBWtw2e3nNJAu+
	RM=
X-Received: by 2002:a05:622a:1f11:b0:4ee:4a3a:bd05 with SMTP id d75a77b69052e-5014849d291mr69984841cf.74.1768444979611;
        Wed, 14 Jan 2026 18:42:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148ee050esm26853761cf.30.2026.01.14.18.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 18:42:59 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH] dax/kmem: add build config for protected dax memory blocks
Date: Wed, 14 Jan 2026 21:42:22 -0500
Message-ID: <20260115024222.3486455-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-6-gourry@gourry.net>
References: <20260114235022.3437787-6-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E4B4A180005
X-Stat-Signature: bkguriait1hjufw9nunne7y6wtbxuaqx
X-HE-Tag: 1768444980-33750
X-HE-Meta: U2FsdGVkX1+JdeMJhmG47N+ewJYDp9KSxTc+7g5g0vXaVRKXJF9ABLYg/kA1jzG7BVUEjZ/xSFGVQXeMWKpptuR+mxYnhGIPKiCDjTinibKGAr1MG3iXF1nrJezuKz6rdrbTxB0jeOqqYOAaTYKJODI3mwqazA9Tw5m4Ifc5xdYz86iwpCiSoN8f0AKNmN0i3Czbc977KMmzjumeGn7vt/1t/tP9xZA2PUzOG7p5w9WcJBDIeMhgT47ns8sWUJrYrQF+zI9IA0d1aYkEi8pwnWiARLMIpJ5lvzQByaBcD28bVjMBWUbeBazhUXtzwsAouj+6/VQRzUufrm5jt1ZnUdknxV+J4c0lvVOge4o5g+w2AP5p5/NR+8gwmxSbsXwRzj5FdqRgO29tHbJZsG0mtGDiS1A2MuEl7ZYMb4xKa9rkQxJAdzLNIOSHVrbizwbVPcfLwFXmdr80sSF1Xc8gekYUtyu9mUacANLIGUu4l6co+Zk4pZVfKq5QxQfwAZK9y+DUA6zySg+q2nWTaS6zww5IySNfL/wehAkMc3cANv8S38LpCkMlIy8CSTifpFhvX2Kvkpqeyw6rppzBr3M46GcgaUj/lyU9XdmfsgY3QrNJ4Azlvh269KbvWtu7LOjf1VzbmbFA1N3Mv7Pv4TAQiiszRUDjkwBtYgXuLdlq0aC1NJfy4niH+pBCGlgejgKyyQkv8vlDJKJafonjt8NJJE2AKW2K7K65TzCukZ5lts50HfguMYg+R/O+L28nidzO8VeMJct++vGL3DApRFU/U3Hjh3XX9DOmIsyfGwj2RFADmsB/zVUp9gBeu7IUaPF/IpoRYQZBUcMmmGVNgaiNICZDObx4p+t8cR/B+XLsIg6bQ13kMHZ4DBqnSMWcIa2evBt1CwZ9eFvDgV4oNaWxh9ZF5GEJVmbBAOROpXgUzMrOW+cWn3Ml74JASNmYRUU1wOmXDSBB/25nKzE7Qr3
 E4c/pbUl
 sLmN8yWGn8G4wkXlrUUFywJEafLyPHJCcxSAGBjDXmnCxF+8tNrh2f53bG3ya474Z+jbup0KSrSslRy3C1zMTtSzc4vfSXln1ots2OGHlfmfkHs3o3BXVcPgpKgV3SlTs/HiIImnktHCDWoMJYHVJJnmx8+T3W7uVtugSzkJOwY6fTqlx9R60ESbBDQGgIV6oxuce7tqAJ8cJcHlbPF2qBq/ucw/kChfOnKDzWSFdKdwktd+4lJTYVUdpiajcvPnLI8JyE0NlmgHzxeFoLP6HfE2NgPWJeAaksl6jZ5X/qgRXYiRnB6U4t5cxPAMmdRqiG9KELh3cVO9TzEQ=
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


