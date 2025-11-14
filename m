Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B48CE8D79
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5468E001D; Fri, 14 Nov 2025 14:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5555D8E001B; Fri, 14 Nov 2025 14:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1778E001D; Fri, 14 Nov 2025 14:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27F708E001B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E61D5160395
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:20 +0000 (UTC)
X-FDA: 84110128200.04.A97EEB5
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id DF813C0014
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IgAAvP+Z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7N5yt00Qno1MwWJjfGBPy1ItOdOrLJaGZ6crOfgTrsk=;
	b=CQVi4gYAkKfNUkwuVDHjka+q4IVg9+w+PKIYJjxcms6PLMXbxEmAmDNXiE26jHNwE5jJJ6
	NMGb0d1pz8Jm2e8PlpMK2vlbYbvBxtKVa9TbkNy1/eLM84kW5eGsln70gkl6AyNftPAh8I
	QnjNk0ZCITn9x+9ndjQi0fzx4dq52cM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146818; a=rsa-sha256;
	cv=none;
	b=cjOap01EUQcx28qTLmNaLcZDKKsPi8G+VQTtsAJuOFlrWcCHHJ6ogkhUW2kTh3hLIR+hWw
	SzWqkqQ1+KwWn/OydxS3IZC58qfUplCP5hsKYfiyyyc/GNBxzJlRtwmc81eqiqiB10xEN8
	7AaEAbuvV4jXCLKVj6f1HKK3jfr6ixY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IgAAvP+Z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-780fe76f457so22216637b3.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146818; x=1763751618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7N5yt00Qno1MwWJjfGBPy1ItOdOrLJaGZ6crOfgTrsk=;
        b=IgAAvP+Znm8IZAFYfynh268t/U2VtppmkmcieXmvYYqLmncz9bKDft5dHqpdSN8MDv
         /YxBDT0LpDE5uUmCJGUJHpG6c9aMdinJv5IfATJdGR7tDk1n9WA3x9Rx2eD5FB4s8dWe
         z41VxAbpsNDCoUmdJI9STlx7JOu0v8mJ29DENyQqQqODumERAcFo8G6CVy8pJnCUbjaA
         Ik40Gd29406jcRk3e1mJUwCjDhZ4HzF6IbTBPM8p7ddysXGYpCcOC/rAkpIztt37TVC0
         2I8wUdpavVUYUBfmPNL2wyqdR9tY7DdhlO0+qq9tqyCmkyjFt167iFLH0QbXnJFaMpOK
         bjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146818; x=1763751618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7N5yt00Qno1MwWJjfGBPy1ItOdOrLJaGZ6crOfgTrsk=;
        b=usRgRL70yFXBf1l2i62zHpEjrzfJUoPLg1NZJ0Q8nZVzREkLsxdKUg3OLzvTH73Ikw
         iuSOokqLRCVcV2mwjhRlf79RL5WpbIkbONAWS9iGMD3BQ+47nmEjx0jccj+Pbzabi6dP
         cnPxV5a4suWNmfUs0h2yzIL95OtaZNLbmt/RlIf0sBOJUbf5biqHHA0mJX1lj0RyEHE+
         QgGA+/WPe0J8eL4oUTStmOKrRLFu1pK3GUKY68FiarbIIyha7u4li6ZmyaXxjoSCv0XB
         s8qOrZi+MzBBI322Jc9qPqYehFRMDwFa+/NuV06iKSmBWTODdW7IOvY8fToExOJNeyl/
         NVPw==
X-Forwarded-Encrypted: i=1; AJvYcCWTKh331bBYUB34tWiBXuwpjr3rfQNOu1NjiQPGctphdhAmKw9VSncnR+6SoqrXo6CZwIiwynT4Fg==@kvack.org
X-Gm-Message-State: AOJu0YznZWAf587YtWsWL6Y0TEfnRKVYCw9RcWK9FMuGB7sxM8oWqDqX
	DE8PYQCG3Pg4OKYw1GPRFkVkIMDZw2W2As/yJSJvQXFWS/SZW3bm0GxEndrG3hs62jI=
X-Gm-Gg: ASbGnct2LRuCs8b8ZGXYcAOVzED8nOpWHveKHJpW/j7K/wpdHMSCVKvGyYw7B9VlSRq
	WeexAmU0kaJyyXTyQIRX0eDUrl5Ax1QQSwgQYhlzvLJ6HRAG+nANKIy4t2ixF9MlhXrWsdKWXs4
	flpPb63y+LEG1TPV6qVdQQAQjmwDHzUYDpx2J1PnbqYsz3Pi5KylpiECIC5LF/t3lOFKoKPVUhM
	qUyDmohzQCBf0g7k+ye8phQY6RLc1QHLVrGGbU9Gks4ox2N7LSaWg0Fck1WoO3sUFhG2S+bVX6g
	JsXxGjq8hkPa9RpNxXZ1IXcPm2+oRQNXWM+iOGV+gPp1EkFJHtNhIKoEJ/qzd6ypHHfOQxt6NRo
	R1QUlqyWhPbIXf9/+MTVCb1a/i11gVIkLScuZpG44XcvqXiMdZ3wQe3UwPsko+gzulztuRLQ2Dv
	Rvdmr46krGQGxI1g/pSr51vWsV/14dwoZvAWxFNMmOAMntXK7pHH5cOd3B0c/K1X+Rd38Y
X-Google-Smtp-Source: AGHT+IEgGDASb7ywJuNlU8tH7U5fvJZheQWqPab57YBnjKIGG/4PXsbTcQgkrxJdQmu9tDmb9/dD3A==
X-Received: by 2002:a05:690c:338b:b0:783:6f8d:e7a6 with SMTP id 00721157ae682-78929ef6a1bmr60582517b3.51.1763146817769;
        Fri, 14 Nov 2025 11:00:17 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:17 -0800 (PST)
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
Subject: [PATCH v2 10/13] kho: Update FDT dynamically for subtree addition/removal
Date: Fri, 14 Nov 2025 13:59:59 -0500
Message-ID: <20251114190002.3311679-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3feuwd51b7sdgsjhe6z1ggmrp1sdrzxd
X-Rspam-User: 
X-Rspamd-Queue-Id: DF813C0014
X-Rspamd-Server: rspam10
X-HE-Tag: 1763146818-206582
X-HE-Meta: U2FsdGVkX1/GdjO8tZzApCmo3RuMSTBzEAdd3TU2WYBhpTbQ0Wb0R3NWrF5DGpb5S0OnarQVkIAe5P6NctnJ5U69vQp8mzXqKXrNlrJ+35JsSYr0TX6bCX8fnasb1fZHWDZTUK3mvTQ7UWLPkFyQOcOoNszlX0g84KfVGVkWJiBjjBjs86YBrWJ+LiRE247zFivqjjXw7VeC+CPRvaHFTPCtPp2DXjSlWcKD9Z1vGa3k+uvJOeZm86VUVmCI4MKc/ku35OIlaF43N1oeAwXuxmGkNoMHosyjmgk4rfSga/RShnU9HyAFaJfP8sTOMCYDPgE7Ws2kZTIFU5RGvYsoYSIvuXOzw/5eyzj3k5ldItXfioLgLMf5iFh+UGMAlCRvOcXWxc2swpFFp8p4NbM5FWrkAGDT1ONcx60l2+g5Clil084bzqnUovD/3D0kwG2tkuCRNyn+k9R/LYC1SlQ1BnzpQRVY4hne+jEP696sQJgVAiy5R+csyA6hwQ4y85bu7vGF2P3mvWhIndiN2+lZ6H94Bjf45QS4wBHzFzCkSvSIqd6tQ2IURX2xuuvE9deCWbb6eJWY4CSWY6lxrWiWPM1O08NtZn/QE6EHFT8QatQOY1Yna6xXtX8/JmpUVICJJNz1UxdzdtKiV2KvO7pcDHpEAarNUGOkI79UVODqVCYR7DOd/Nj5G5gKXpOyOLCrIhIpmG/2goKxyG0UVP7bgoWXJozAf+yMdY1zkAY4B2pVdSOOzAMDJfuYK78eByYMG4Dvuo0DBwbb5zOteSWzFbT9Fr2tVxjNXpWSlqke9+wzc0jYxXIAEycGvb6YNlTzlnG0/WjoX/P3a+3dJVGpuPMKag0lvbh/h6s4fQS9UZvHEXVWxjt+mLZDPuhrVmGeM8Czcyj/yHre/w4FB6cGoY4MBVhxyBZxv28kapI06vJC7m1mj+qIZRZpdP6y3F90qBxinjVmoPp/bmLmB6g
 C7QEpZfL
 Ima1wR38AI2yaQllGkZQ8kTTyngWgPJNEDrZQJdaBxRWGjg2sRGWAZ8IrsFBdNAGjr7ea5vO/GRSyRqpS8d/wjSLRdrZ/d/mj26TNdbj8cxWQ2A2aEKSkYTiEcrOlVxG2tsTGOtThSNzzU7BBNFWAsuOjYvyKwqHAYz86JUFwPV2mqArTKLJPRHdM707QCUQc3fiQdkZupEX9WBL1DsTsZM5RLmdmd0ndqCD8hZxo36Uq/Z2btA+LIeolFKWthEOLRC4OoqT69E6UZD+Q6H4ld2R9p91QSxyK2E8zEkcvoXayKdPg2U2eTgwVcaHU6rWONMAftLyehqkTHZWCFsAsAjUyuL+3HIqspXe6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, sub-FDTs were tracked in a list (kho_out.sub_fdts) and the
final FDT is constructed entirely from scratch during kho_finalize().

We can maintain the FDT dynamically:
1. Initialize a valid, empty FDT in kho_init().
2. Use fdt_add_subnode and fdt_setprop in kho_add_subtree to
   update the FDT immediately when a subsystem registers.
3. Use fdt_del_node in kho_remove_subtree to remove entries.

This removes the need for the intermediate sub_fdts list and the
reconstruction logic in kho_finalize(). kho_finalize() now
only needs to trigger memory map serialization.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 144 ++++++++++++++---------------
 1 file changed, 69 insertions(+), 75 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 624fd648d21f..461d96084c12 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -104,20 +104,11 @@ struct kho_mem_track {
 
 struct khoser_mem_chunk;
 
-struct kho_sub_fdt {
-	struct list_head l;
-	const char *name;
-	void *fdt;
-};
-
 struct kho_out {
 	void *fdt;
 	bool finalized;
 	struct mutex lock; /* protects KHO FDT finalization */
 
-	struct list_head sub_fdts;
-	struct mutex fdts_lock;
-
 	struct kho_mem_track track;
 	struct kho_debugfs dbg;
 };
@@ -127,8 +118,6 @@ static struct kho_out kho_out = {
 	.track = {
 		.orders = XARRAY_INIT(kho_out.track.orders, 0),
 	},
-	.sub_fdts = LIST_HEAD_INIT(kho_out.sub_fdts),
-	.fdts_lock = __MUTEX_INITIALIZER(kho_out.fdts_lock),
 	.finalized = false,
 };
 
@@ -725,37 +714,67 @@ static void __init kho_reserve_scratch(void)
  */
 int kho_add_subtree(const char *name, void *fdt)
 {
-	struct kho_sub_fdt *sub_fdt;
+	phys_addr_t phys = virt_to_phys(fdt);
+	void *root_fdt = kho_out.fdt;
+	int err = -ENOMEM;
+	int off, fdt_err;
 
-	sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
-	if (!sub_fdt)
-		return -ENOMEM;
+	guard(mutex)(&kho_out.lock);
+
+	fdt_err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
+	if (fdt_err < 0)
+		return err;
 
-	INIT_LIST_HEAD(&sub_fdt->l);
-	sub_fdt->name = name;
-	sub_fdt->fdt = fdt;
+	off = fdt_add_subnode(root_fdt, 0, name);
+	if (off < 0) {
+		if (off == -FDT_ERR_EXISTS)
+			err = -EEXIST;
+		goto out_pack;
+	}
+
+	err = fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(phys));
+	if (err < 0)
+		goto out_pack;
 
-	guard(mutex)(&kho_out.fdts_lock);
-	list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
 
-	return 0;
+out_pack:
+	fdt_pack(root_fdt);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
 void kho_remove_subtree(void *fdt)
 {
-	struct kho_sub_fdt *sub_fdt;
+	phys_addr_t target_phys = virt_to_phys(fdt);
+	void *root_fdt = kho_out.fdt;
+	int off;
+	int err;
+
+	guard(mutex)(&kho_out.lock);
+
+	err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
+	if (err < 0)
+		return;
+
+	for (off = fdt_first_subnode(root_fdt, 0); off >= 0;
+	     off = fdt_next_subnode(root_fdt, off)) {
+		const u64 *val;
+		int len;
+
+		val = fdt_getprop(root_fdt, off, PROP_SUB_FDT, &len);
+		if (!val || len != sizeof(phys_addr_t))
+			continue;
 
-	guard(mutex)(&kho_out.fdts_lock);
-	list_for_each_entry(sub_fdt, &kho_out.sub_fdts, l) {
-		if (sub_fdt->fdt == fdt) {
-			list_del(&sub_fdt->l);
-			kfree(sub_fdt);
+		if ((phys_addr_t)*val == target_phys) {
+			fdt_del_node(root_fdt, off);
 			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
 			break;
 		}
 	}
+
+	fdt_pack(root_fdt);
 }
 EXPORT_SYMBOL_GPL(kho_remove_subtree);
 
@@ -1232,48 +1251,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-static int __kho_finalize(void)
-{
-	void *root = kho_out.fdt;
-	struct kho_sub_fdt *fdt;
-	u64 empty_mem_map = 0;
-	int err;
-
-	err = fdt_create(root, PAGE_SIZE);
-	err |= fdt_finish_reservemap(root);
-	err |= fdt_begin_node(root, "");
-	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
-			    sizeof(empty_mem_map));
-	if (err)
-		goto err_exit;
-
-	mutex_lock(&kho_out.fdts_lock);
-	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
-		phys_addr_t phys = virt_to_phys(fdt->fdt);
-
-		err |= fdt_begin_node(root, fdt->name);
-		err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
-		err |= fdt_end_node(root);
-	}
-	mutex_unlock(&kho_out.fdts_lock);
-
-	err |= fdt_end_node(root);
-	err |= fdt_finish(root);
-	if (err)
-		goto err_exit;
-
-	err = kho_mem_serialize(&kho_out);
-	if (err)
-		goto err_exit;
-
-	return 0;
-
-err_exit:
-	pr_err("Failed to convert KHO state tree: %d\n", err);
-	return err;
-}
-
 int kho_finalize(void)
 {
 	int ret;
@@ -1282,12 +1259,7 @@ int kho_finalize(void)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&kho_out.lock);
-	if (kho_out.finalized) {
-		kho_update_memory_map(NULL);
-		kho_out.finalized = false;
-	}
-
-	ret = __kho_finalize();
+	ret = kho_mem_serialize(&kho_out);
 	if (ret)
 		return ret;
 
@@ -1372,6 +1344,24 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+static __init int kho_out_fdt_setup(void)
+{
+	void *root = kho_out.fdt;
+	u64 empty_mem_map = 0;
+	int err;
+
+	err = fdt_create(root, PAGE_SIZE);
+	err |= fdt_finish_reservemap(root);
+	err |= fdt_begin_node(root, "");
+	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
+	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
+			    sizeof(empty_mem_map));
+	err |= fdt_end_node(root);
+	err |= fdt_finish(root);
+
+	return err;
+}
+
 static __init int kho_init(void)
 {
 	const void *fdt = kho_get_fdt();
@@ -1394,6 +1384,10 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_out_fdt_setup();
+	if (err)
+		goto err_free_fdt;
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
-- 
2.52.0.rc1.455.g30608eb744-goog


