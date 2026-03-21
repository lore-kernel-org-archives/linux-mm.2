Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3DA71094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A926B00C4; Sat, 21 Mar 2026 11:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA1E6B00C6; Sat, 21 Mar 2026 11:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85036B00C7; Sat, 21 Mar 2026 11:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C400A6B00C4
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86E608BFED
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:13 +0000 (UTC)
X-FDA: 84570390786.27.EDDB122
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFD6840009
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lYL0eVv1;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xO5G1TTTEFUzwGvqajKTysfZ/iiFkVbZDpQBQ6HidU=;
	b=u8ot78zKiEKi2BnO4SLgC2Na/ETXSEWTRv8/qJ2hhaqaRtIODTXBSb6b9P8wMDyi/bh2MQ
	w5GV6N3OPZjuqiNZwdE2Mzw72q0h6Q4KQudvjSLjqoIAQRylN4XCY5FDxD3tOMaPAcizVd
	igKOdGajwtU+5n2f2svpQ6m4d7t+2lw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lYL0eVv1;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105451; a=rsa-sha256;
	cv=none;
	b=kHO0N/+1mO4sC3uMrweZdZmFCDjIcpjhUeQ27WAV/cMQqcq1gY90fnX9A6pu0aaie5kxwU
	1k99xbMDFBxqh/R3xUFmJJqX87NeYUkjSX8Xx9WWmSgbA/MgBU7dxiDexnAxH6QFhpgnRO
	yhG59Nut3LhXjd1wLg4VGDAxI4ZnZ9Y=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-94ace5d0e39so811165241.2
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105450; x=1774710250; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xO5G1TTTEFUzwGvqajKTysfZ/iiFkVbZDpQBQ6HidU=;
        b=lYL0eVv11VLJ7Qul9M0V/oXf2AKjlpGHWkQbtK+1BSrMuvdQZskLl0Xy0aC3s+ZFPH
         2c2gR5xnHWKXBo1xtoiWUMAIqtk6T4NkYR7rtFc5jsxkVEq7njM6RW966IZbPI/VbmKS
         7wuKcln4wNZpq+JSyrPzIkQ/UVDl/YaIbcNCSs6XQrMSEKZ8iMPTJ+TEqB2/WkQYUgik
         4IgRdeeWA+nYdbOABAV+VTrBL6H6LlXC/SK0sxl9nUSzX4E1ORWdlJgGCqVIwDjbSGyn
         3mRw6blsRCb2lEzm/kdr0IcbK8MpMvhN8bTbfZnwwWrwwxYSvsdJQUxSE2FgkZ+GINlm
         OHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105450; x=1774710250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7xO5G1TTTEFUzwGvqajKTysfZ/iiFkVbZDpQBQ6HidU=;
        b=aBwWES1pm2g8tLiauUTeIgs9x4pelsvgy2DPZrULZ8Fv8s7gkBv3XMNss/MgDYcqr4
         +TQ0aOaYwnpm4jC/dI8nt1OeB6ndbu9i0A2+2CJdH5LFLqsra1cd1tGNcKSJHQHexntI
         MRVw3pUGgSEdvufsMu2nCdwlzioGit6fOXbHia6S0amYgYti3qUe/GJGDRpjy62mk0NZ
         EF18Io3zfJQRSpv3ah3DzGbKZ7gcSy7GDu0mc2vbski0XcdYqU/2mHPtql1DWi0G+Zv3
         T0DHZCmDm/pWX5I6Vs7MPKgljc5RtebUaT+nT+3f48Dchq5oLrGNOmw/GaMWD+G30NNo
         qdSA==
X-Gm-Message-State: AOJu0YyFHRsDlThO5Y3MMhuTFE99Nz/7Srf8QMP7xSwO+PAgfoxxYSLH
	DJ9coRhIAzMRBXzsXR3Pj5ANOzCVcBGGyuMOlDWz7bND9PqE72NFv1Li+viV4IQL1dD14IggdsJ
	yYE+e
X-Gm-Gg: ATEYQzwiBcCaB6Y/J/8xNmf9jfMUgo9EspqjENADZI0GuwpTOS8jEgIVXfbehgG4fK0
	W8TD5h5OpfGdYau9WMFG79iLsBOPgvMijqrzIOEy2yQTTDNlVcX0kp0J9w681olUQC1sNEyMxzK
	2P2942GYYufIUo9Y21Jj+EZD9f0bXP7RMBEPn92XbpX50zC1OQsMuc2md2Pz9Itsb1waWwhzAdk
	s2e2NYFANoF8gcfrMRYaVR7IPYbu1O9VejTCRh7pbjM/8Vm9rd7npFDlhyxkx5vdO3jaeUjsaKC
	sNrKKBogNpWRexFnpwmyFk5JlrnEDaV6D70wknkHewLdBhEqVExJ+ciItklCMRUxVig9o9Y3KHM
	QtD40QLSqf/93VbICaYhIqCcb78BCYiy1AStKCNXHp+aQ5akvIIjiN8aoKP2xuYKr4zGpdab5PK
	H/PSIDKLSPwKsBZQxdva7/9ld+JOMzdYaS24/ouIoj1Le9XkRxdEIBVjNZ18tBR3NGXI3AH4onR
	CuhzkqSsEXVES8=
X-Received: by 2002:a05:6102:dd0:b0:601:f386:9ed2 with SMTP id ada2fe7eead31-602aea8d861mr2785184137.7.1774105450228;
        Sat, 21 Mar 2026 08:04:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:09 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 1/8] mm/memory-tiers: consolidate memory type dedup into mt_get_memory_type()
Date: Sat, 21 Mar 2026 11:03:57 -0400
Message-ID: <20260321150404.3288786-2-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BFD6840009
X-Stat-Signature: h4wdsjoig84hmrcm8gdgykkfg5ao965m
X-Rspam-User: 
X-HE-Tag: 1774105451-295227
X-HE-Meta: U2FsdGVkX18h6O5aXT3t8Q9oc4cLIOcKxTsbYRo4EyjEmTxAONauv922Du7fo3njI6lwKc5iqLHvpUFsOH+Myt17CnfQoNzveMOo8JNghe46jphhk9qM0KTqJz6JRQZsBahPiY/G7lnw93mUnmpA0P0GAiJI4orloe6b41tI9EMu1jDjj/skG+0FaXtqn1xX1WLYQBNktzth/owEhYHDmPrc/xueGpq0lvT4sPy8JEFhnQy7Ag8evrmTmTn9mcXwPZkddFA3Njpf9f+eSDIFTjF6rg90VZHsb30DV6dQr4Y+LMcGBSCkqPeKX48Qz2gfCIgE53sxVITZcSnF7ZEXVTMmSr+I4hN6m7/TIY/YQpNalGCKWXrdMHJamMJo6n1Fj+Ba6oK7o8qZjZQbTX12W4eWcoWsMKR13LkvU0Q0hypO5oLCXoqh7+UfUhF6Wc/Ilhbj3UtajeHNdMXODysPwuu4H+06PQPmXbM3HK9F4nzgCAHyfefpGNM7OSSL+ncbfrotkRMc9l7qk/4BawWYqQN+veaWh4IMrRFxRHCR2KXu8gB5RxrT5vuX1k2t0PQGzbpu94R61lTtPxyp4yyzMDwi+zuukzJYpgfqgHe51hQjQr1kkOqNyZ3LI50Vw5SY/TW4+VTsjo9x3a0mbUXdm9keYk4YuEpz/mcMCq4cKZPp9naOtKAK2Chnxbl9Lu94IZtzC7QYIdW2e+fVIo/Eq/0Pu3LioFc2x6TnxQBZzYqZdfqZ8h+263kQpxN6kK5+P/sxNP2n5EH2MUoKRiqWaiNa5wF5z+Nio+c5IGMSSds4pd9Ug/b8qqy1Pjym1h61UvxiGK17AiVsCy+R4ryTXP34ZB721l/DW2ZIO0Z2H1X7nZvIDgBHCPkvwn9qDw/5POEk4nNRyIIdYElqGYSqM7aOw3f/rnyAne/YNjkAJIM14JOIat9Wn0ESuhLHTRTMta8TtqwE34yjOOKNeIy
 ljUXJU3Z
 fvk0NMLG+0YncJ7LGc0O0+sJLIi/Kv9Q5k78O695mzfU6MS8z+QTE4kXAmfI7b7pLWFRFw51A4JlhcTKAetFTM08EQJ8XcfkYSdhFMU6XRObsH8QZAJFxI9ZpE3Tdyraal2g04PP96simHbLtdXWqhSAXuzs5Ztj0KApqOseHrN41TPqvq5YMR6GeTngwFxxzlvGkTX7sEeAItNGoUgkx07EYzArQYRraHbvR3x9O+iJ5KeggzErlmawkHxu8wh43egMNNZAsns2r/9NXaL3IXRX/WXe0azg9UdrvEizT44eMjBQfyWpuwiiEFz/QE9Qv5o0gKJcNVFA034+HhEfkJd9yyRcjMlOoB5ou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace per-driver memory type list infrastructure with a single
mt_get_memory_type(adist) that deduplicates against the global
default_memory_types list under memory_tier_lock.

The per-driver lists (mutex + list_head + find/put wrappers) provided
dedup within a single driver, but not across drivers or with the core.
Since the number of distinct adist values is bounded and types on
default_memory_types are never freed anyway, the per-driver cleanup
on module unload was not useful.

Add MEMTIER_DEFAULT_LOWTIER_ADISTANCE to replace the default DAX
adistance, since it was really used as a standin for all kmem hotplugged
memory.  This at least makes the default tier relationship clearer to
other drivers and they can see where to put their memory in relation to
the default lower tier.

Core changes:
 - Add mt_get_memory_type() as the single exported entry point
 - Drop most other interfaces - clear_node_memory_type() is now the
   appropriate put function.
 - export MEMTIER_DEFAULT_LOWTIER_ADISTANCE

dax/kmem changes:
 - Remove MEMTIER_DEFAULT_DAX_ADISTANCE, use MEMTIER_DEFAULT_LOWTIER_ADISTANCE
 - Remove per-driver kmem_memory_type_lock/kmem_memory_types/wrappers
 - Store mtype per-device in dax_kmem_data
 - Pass data->mtype to clear_node_memory_type() instead of NULL

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c           | 32 +++++---------------------------
 include/linux/memory-tiers.h | 34 ++++++++++------------------------
 mm/memory-tiers.c            | 29 +++++++++++++----------------
 3 files changed, 28 insertions(+), 67 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 2cc8749bc871..eb693a581961 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -16,13 +16,6 @@
 #include "dax-private.h"
 #include "bus.h"
 
-/*
- * Default abstract distance assigned to the NUMA node onlined
- * by DAX/kmem if the low level platform driver didn't initialize
- * one for this NUMA node.
- */
-#define MEMTIER_DEFAULT_DAX_ADISTANCE	(MEMTIER_ADISTANCE_DRAM * 5)
-
 /* Memory resource name used for add_memory_driver_managed(). */
 static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
@@ -47,24 +40,10 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
+	struct memory_dev_type *mtype;
 	struct resource *res[];
 };
 
-static DEFINE_MUTEX(kmem_memory_type_lock);
-static LIST_HEAD(kmem_memory_types);
-
-static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
-{
-	guard(mutex)(&kmem_memory_type_lock);
-	return mt_find_alloc_memory_type(adist, &kmem_memory_types);
-}
-
-static void kmem_put_memory_types(void)
-{
-	guard(mutex)(&kmem_memory_type_lock);
-	mt_put_memory_types(&kmem_memory_types);
-}
-
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -74,7 +53,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	int i, rc, mapped = 0;
 	mhp_t mhp_flags;
 	int numa_node;
-	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
+	int adist = MEMTIER_DEFAULT_LOWTIER_ADISTANCE;
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -90,7 +69,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	}
 
 	mt_calc_adistance(numa_node, &adist);
-	mtype = kmem_find_alloc_memory_type(adist);
+	mtype = mt_get_memory_type(adist);
 	if (IS_ERR(mtype))
 		return PTR_ERR(mtype);
 
@@ -189,6 +168,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		}
 		mapped++;
 	}
+	data->mtype = mtype;
 
 	dev_set_drvdata(dev, data);
 
@@ -253,7 +233,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 		 * for that. This implies this reference will be around
 		 * till next reboot.
 		 */
-		clear_node_memory_type(node, NULL);
+		clear_node_memory_type(node, data->mtype);
 	}
 }
 #else
@@ -292,7 +272,6 @@ static int __init dax_kmem_init(void)
 	return rc;
 
 error_dax_driver:
-	kmem_put_memory_types();
 	kfree_const(kmem_name);
 	return rc;
 }
@@ -302,7 +281,6 @@ static void __exit dax_kmem_exit(void)
 	dax_driver_unregister(&device_dax_kmem_driver);
 	if (!any_hotremove_failed)
 		kfree_const(kmem_name);
-	kmem_put_memory_types();
 }
 
 MODULE_AUTHOR("Intel Corporation");
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 96987d9d95a8..70fbd3ad577f 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -20,11 +20,17 @@
  */
 #define MEMTIER_ADISTANCE_DRAM	((4L * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
 
+/*
+ * Default abstract distance assigned to non-DRAM memory if the platform
+ * driver didn't initialize one for this NUMA node.
+ */
+#define MEMTIER_DEFAULT_LOWTIER_ADISTANCE	(MEMTIER_ADISTANCE_DRAM * 5)
+
 struct memory_tier;
 struct memory_dev_type {
 	/* list of memory types that are part of same tier as this type */
 	struct list_head tier_sibling;
-	/* list of memory types that are managed by one driver */
+	/* memory types on global list */
 	struct list_head list;
 	/* abstract distance for this specific memory type */
 	int adistance;
@@ -39,8 +45,6 @@ struct access_coordinate;
 extern bool numa_demotion_enabled;
 extern struct memory_dev_type *default_dram_type;
 extern nodemask_t default_dram_nodes;
-struct memory_dev_type *alloc_memory_type(int adistance);
-void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
 void clear_node_memory_type(int node, struct memory_dev_type *memtype);
 int register_mt_adistance_algorithm(struct notifier_block *nb);
@@ -49,9 +53,7 @@ int mt_calc_adistance(int node, int *adist);
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
-struct memory_dev_type *mt_find_alloc_memory_type(int adist,
-						  struct list_head *memory_types);
-void mt_put_memory_types(struct list_head *memory_types);
+struct memory_dev_type *mt_get_memory_type(int adist);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -78,18 +80,6 @@ static inline bool node_is_toptier(int node)
 #define numa_demotion_enabled	false
 #define default_dram_type	NULL
 #define default_dram_nodes	NODE_MASK_NONE
-/*
- * CONFIG_NUMA implementation returns non NULL error.
- */
-static inline struct memory_dev_type *alloc_memory_type(int adistance)
-{
-	return NULL;
-}
-
-static inline void put_memory_type(struct memory_dev_type *memtype)
-{
-
-}
 
 static inline void init_node_memory_type(int node, struct memory_dev_type *default_type)
 {
@@ -142,14 +132,10 @@ static inline int mt_perf_to_adistance(struct access_coordinate *perf, int *adis
 	return -EIO;
 }
 
-static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
-								struct list_head *memory_types)
+static inline struct memory_dev_type *mt_get_memory_type(int adist)
 {
 	return NULL;
 }
-
-static inline void mt_put_memory_types(struct list_head *memory_types)
-{
-}
 #endif	/* CONFIG_NUMA */
+
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 986f809376eb..c8f032a75249 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -38,14 +38,17 @@ struct node_memory_type_map {
 static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
 /*
- * The list is used to store all memory types that are not created
- * by a device driver.
+ * The list is used to store all memory types, both auto-initialized
+ * and driver-requested.  Drivers obtain types via mt_get_memory_type().
  */
 static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
 nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
 
+static struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+							 struct list_head *memory_types);
+
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
 	.dev_name = "memory_tier",
@@ -621,7 +624,7 @@ static void release_memtype(struct kref *kref)
 	kfree(memtype);
 }
 
-struct memory_dev_type *alloc_memory_type(int adistance)
+static struct memory_dev_type *alloc_memory_type(int adistance)
 {
 	struct memory_dev_type *memtype;
 
@@ -635,13 +638,11 @@ struct memory_dev_type *alloc_memory_type(int adistance)
 	kref_init(&memtype->kref);
 	return memtype;
 }
-EXPORT_SYMBOL_GPL(alloc_memory_type);
 
-void put_memory_type(struct memory_dev_type *memtype)
+static void put_memory_type(struct memory_dev_type *memtype)
 {
 	kref_put(&memtype->kref, release_memtype);
 }
-EXPORT_SYMBOL_GPL(put_memory_type);
 
 void init_node_memory_type(int node, struct memory_dev_type *memtype)
 {
@@ -670,7 +671,8 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
-struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+static struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+							 struct list_head *memory_types)
 {
 	struct memory_dev_type *mtype;
 
@@ -686,18 +688,13 @@ struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *m
 
 	return mtype;
 }
-EXPORT_SYMBOL_GPL(mt_find_alloc_memory_type);
 
-void mt_put_memory_types(struct list_head *memory_types)
+struct memory_dev_type *mt_get_memory_type(int adist)
 {
-	struct memory_dev_type *mtype, *mtn;
-
-	list_for_each_entry_safe(mtype, mtn, memory_types, list) {
-		list_del(&mtype->list);
-		put_memory_type(mtype);
-	}
+	guard(mutex)(&memory_tier_lock);
+	return mt_find_alloc_memory_type(adist, &default_memory_types);
 }
-EXPORT_SYMBOL_GPL(mt_put_memory_types);
+EXPORT_SYMBOL_GPL(mt_get_memory_type);
 
 /*
  * This is invoked via `late_initcall()` to initialize memory tiers for
-- 
2.53.0


