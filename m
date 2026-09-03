Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC414C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C416B0092; Thu,  3 Sep 2026 11:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434686B0095; Thu,  3 Sep 2026 11:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2872C6B0096; Thu,  3 Sep 2026 11:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2BB46B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:50:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45F19A46C5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:17 +0000 (UTC)
X-FDA: 85172887674.30.345BA37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8C6BF40012
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyoLOKJl;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788450615;
	b=7MPB+NZ/8H6H+fsn1Rm9zdrskNl4R6PkWlRHPx676WakI9TjPePyBOHUJLTJvZ4ilRhD7B
	weiHdDJvhu8uvDdoEMF/woKtY1a2oV++Sq7Kr/CPWmV/8WoIoV+yDLjjWciMyelBCzvMus
	zfNxnzYdVs39EfdgPdR7PLaEcsbthbU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788450615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpQ+G6UtTo2w3vyGJPJeznHQWpBOtRAhjixM5nGiCoI=;
	b=RXbk//Nsw7c05r6y/tKUvxnB4zXj+g3QCPZ5JekYdBLHwS8j7cccZhGQXWhTJRMCB5sice
	tFi/1ve2vU0EaqSTfi7kHFuoOs5V+fo8I3Viat9OjZYHQw05uO+PP7mGRclUdd9tqFILYI
	XtrXNQQCwlUlI8fY/yX6gvVwGr5uvns=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyoLOKJl;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4FE9404D1;
	Thu,  3 Sep 2026 15:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8AB1F00A3D;
	Thu,  3 Sep 2026 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450614;
	bh=xpQ+G6UtTo2w3vyGJPJeznHQWpBOtRAhjixM5nGiCoI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HyoLOKJlU9flwF2tT95Ezp08U5AhXSIDW6og1SM/XSDUw+ZQVccfNY8oQaha0E0Kv
	 /rU0Pr4QbVxBgR8Xy+3VEwTVZhF36XqveFhT3x79iLceMUMQg1hb2ZY4ZyMYy/qz03
	 62r8CxxYR9CU1ryqkbjIG4TFhmGcFIWz5fcP/Nhd7i2GGIVre1vHE4RFycDA3QxQwG
	 kvywX37z7XHhtxCdfK6XJD7DslU/in2CwWvyvs5Mxmq9EjR79fNlCfHnEfTAhPXd3K
	 9Ntn063U9QxDcrODPy77wGWla25VW1v9uZsR2acs2+VMWoO5qb7GoGxjhFFzouPdn4
	 E1HS8YABSiUXA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 03 Sep 2026 18:49:59 +0300
Subject: [PATCH 2/5] mm/execmem: handle potential allocation errors in the
 maple tree
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-execmem-rox-cache-pmd-v1-v1-2-11beb2a3d249@kernel.org>
References: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
In-Reply-To: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C6BF40012
X-Stat-Signature: s6i6t4dkejjnictrarhb8hf5heeo4cyr
X-HE-Tag: 1788450615-515409
X-HE-Meta: U2FsdGVkX1/6lTZGA/yqx7vi1ja5RcsbKxk3TY9VZRD+1dPxxYe9V1yKVxBcaZykokd9+lYMFnxBRp3UXByMhzcUcqdzWsa6+qVaAVTP4gUGBOhl6j1dzTmi/nyIIuqkBpp3DiFTTtYbcf+5FQTSZO0OQfpDEBNK74vgJncRxyFPS6Jv+ibq4zYD4q10r23+CWdOXZnq3nx09ZSUT28NusDTSgeRtzBwIEbwy+6BKILXEn1Ne3cfaLLPT47Qva4IGvNdl/KumUwtVYPgI6tPwG3BJrYB0pIVn9jr8kEVD80LfZXzQzZEeWVrNxNDMpIxgQqT4gMWJ/U22hRykVKAl6lGb97fFA2oTf3Tavrktg00wZQB76xnnR9iAhChblbxOxBjA/u32RNAHyQW8xJc1NuCDt791QAWX44WBHizs/FLhm1sIwbIr+xzhFNuzNUZIgHtaV/kN3cbNwvMFKQxgNXzK/a7VCrAKKjuM3oRIMn7PX4LP4h5nrcwepXq8uQah/oyadwC7sX/XwiNltgskAVo46vA3A7hBdC8NH8v2OkQbXO/zI1zEKhPXL40fHAakWMAKOeSrQ5j+qMtsEwQ2KLwfgH+qzncWAphcm83GoGiQx/CrEZ9ijGWR93DTzkLRvWTCaUOoOl9q0RObfpDJkw/L7rbpIOnS8XsQveARfbBdtfgz9yPpXfVhiqAkp9i3gRngu6Fsf7JBndhQyq2E2bivSLYNlmV0rDZnC2zOu7oedf/LamVwfx6TGg933+XP9avkbUObl/2QX5RULkf91EZGmocCyIoWqJP+sFOMP3cvCnQ9xakZTMbe+Cz574YKVCL2FhDeiIXTQD39uNvoz7HOoYASCK3yGSyXPRERulVINTLgAiMlPfLERuDFeoMPXL7O0qJolLeKW0zdqYH8VKrj1Hmb+22TsDHyD63HEGeuaPXf2fbTMHSiMzEKd2DJKBlVdLYIgAqazTZ1CK
 uK6Ay2AQ
 L/5RDYprC7FLOkCunA4qeOTrK9jFREwIZgQXzD0XQXDhMFRVOKSGavhNwh2tAkva46V5YRcV8A//NqCyYQsfvWdpMzHfKMlZWBsaP7wWiO5oRt6aM9Kvrp28VDBv9HidQtiNPAZKW2yAvYMi5u8XEx2vhqGu2oGKmk8xFhwMMedXpsoEpzPz0GKfWvxKk31jFI/WK1/NO+Zu9FepV/xEdqkOyLEyyO3hZhs2CefojXnHpfJSvSiKNTMLEcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

execmem_cache_clean() and execmem_cache_alloc_locked() ignore potential
allocation failures in mas_store_gfp().

While in practice they are unlikely to happen, it's better to handle
those errors and ensure the integrity of the ROX cache.

Preallocate the maple tree nodes for the stores that must not fail and
order the maple tree updates so that there won't be any failures once a
tree has been modified.

Assisted-by: copilot:claude-opus-5
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/execmem.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index ba277790e3132..00dd6324cae01 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -149,7 +149,15 @@ static void execmem_cache_clean(struct work_struct *work)
 		if (vm && get_vm_area_size(vm) == size &&
 		    IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
-			mas_store_gfp(&mas, NULL, GFP_KERNEL);
+			/*
+			 * Preallocate to ensure mas_store does not fail
+			 * If there is no memory for the tree update, bail out,
+			 * next execmem_free() might be more lucky
+			 */
+			if (mas_preallocate(&mas, NULL, GFP_KERNEL))
+				break;
+
+			mas_store_prealloc(&mas, NULL);
 			vfree(area);
 		}
 	}
@@ -219,30 +227,34 @@ static void *execmem_cache_alloc_locked(struct execmem_range *range, size_t size
 	addr = mas_free.index;
 	last = mas_free.last;
 
+	mas_set_range(&mas_free, addr, addr + size - 1);
+	if (mas_preallocate(&mas_free, NULL, GFP_KERNEL))
+		return NULL;
+
 	/* insert allocated size to busy_areas at range [addr, addr + size) */
 	mas_set_range(&mas_busy, addr, addr + size - 1);
 	err = mas_store_gfp(&mas_busy, (void *)addr, GFP_KERNEL);
 	if (err)
-		return NULL;
+		goto err_destroy_mas_free;
 
-	mas_store_gfp(&mas_free, NULL, GFP_KERNEL);
+	mas_store_prealloc(&mas_free, NULL);
 	if (area_size > size) {
-		void *ptr = (void *)(addr + size);
-
 		/*
 		 * re-insert remaining free size to free_areas at range
 		 * [addr + size, last]
+		 * the range matches an existing entry, so this cannot allocate
 		 */
+		ptr = (void *)(addr + size);
 		mas_set_range(&mas_free, addr + size, last);
-		err = mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
-		if (err) {
-			mas_store_gfp(&mas_busy, NULL, GFP_KERNEL);
-			return NULL;
-		}
+		mas_store_gfp(&mas_free, ptr, GFP_KERNEL);
 	}
 	ptr = (void *)addr;
 
 	return ptr;
+
+err_destroy_mas_free:
+	mas_destroy(&mas_free);
+	return NULL;
 }
 
 static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)

-- 
2.53.0


