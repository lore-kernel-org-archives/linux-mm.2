Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63223CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4DBA6B0088; Sat, 16 May 2026 18:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8016B008C; Sat, 16 May 2026 18:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78AC6B0092; Sat, 16 May 2026 18:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92E396B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:34:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A51CA044B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:48 +0000 (UTC)
X-FDA: 84774739056.23.E06B576
Received: from mail-yx1-f67.google.com (mail-yx1-f67.google.com [74.125.224.67])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6E4EEA0009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVpQGJzA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778970886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=14OZdlsCd/minckeoEg/l7pBnGdlCv1AuWKncPE3uPM=;
	b=D2O66ozWvDmUGzpwyvsWW11IrV8/l8roGy63XyF1kFieEg7mdjjBJU1hAE16k0MBN1xLcA
	72ojUDFDTHFdBSXPS6GQMWLIMDx9sVGt0g53ldGomyJLof/C/tseL/cGmASeO20CO14Kee
	NfdqlWaNHlzKuDWACt7CbcMrqwO1llE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778970886; a=rsa-sha256;
	cv=none;
	b=d0SH6LiJWMQYYmuhVU7i3zzuWykzSjtkURsI7F/VkNb6pRp5UR/7tCCHhQngKBIrq2v78N
	YyeADeR8ompu1AK9X1kvhXEEszDdNw3UaFclt0OiNs2oJAr7fRjhxkMWKRS2xNRD1GS1/O
	vHC4sWNjrNgYYCd0q7kGZNST1hfv9xE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVpQGJzA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
Received: by mail-yx1-f67.google.com with SMTP id 956f58d0204a3-65e39d1dd38so545311d50.3
        for <linux-mm@kvack.org>; Sat, 16 May 2026 15:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970885; x=1779575685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14OZdlsCd/minckeoEg/l7pBnGdlCv1AuWKncPE3uPM=;
        b=OVpQGJzAmhZqs0tYZjfsKIaqby6WQgM3yc3AljZ1WF9FxZGvwwQ4tNpabiwYNjnh/6
         U1Dn6h31eVAS1n/kctt3au2UmOIqmMNBo77gAoYXK8GQiGhHE4TFDmJWayS3UQlcy+zT
         IN5pK4aa3Ke+nDNdBdGM9QHjB8Ym3id2Xkd2vG/QmxzCHkGAm6Y308xYrramxf5nbatz
         7VYfMGU5eGIceY4RRk2D3iGIaITXfSCT5/cfc3ZLOXZqexEjVDGdYpKJoj/F2EwQKyo7
         +fxdD+y3nSQBA7qGz2SZyPc8OgOvFOKv3ZIYZu8IjfEnzzOgke+c+mtQBx6oWx7IlWZ5
         T60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970885; x=1779575685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=14OZdlsCd/minckeoEg/l7pBnGdlCv1AuWKncPE3uPM=;
        b=al+6DmCKp1eqbCYF2UaetNjFqxva85oa0SAg/PoKSRbs9aD2ttdNV49hr+V1coZ0lU
         HDknDhX+/GcOQ5SBLcUiG+dY6FVAV8d0K43OsNa7ckgQl3htCUraaUa5y+dRH6nBte3t
         tSRWV2cx1tEkkMsa+fC3v3YFQuUVP6ijLZLTHY+M/KWM/APkR5RJufe3pALI/+/YjJvD
         DTkpCpnwhZCw1po8cCCroVRih5uSteM3BUW1ls4MgUMZ+Iaa0dzbHfja3PmSEVUT5D0d
         sRA0xgR9UTdDUwyrgXTDoo3lzv9TywG33NrACLmnp9pkCc8YsbpXvhy0ab4GvmKpUl7H
         JpPQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ZsrgVwVZVdcn1/IsSE2JSf9Q9xng9AHbKTQ0Ja8RP+vB76cA3dYqC22INbvIdwK9sTwqA8tCDVw==@kvack.org
X-Gm-Message-State: AOJu0YxmUii7+BS0sOks8DrBoZ0oiTv3njwNhJnM0YMYBMQBaeNRUHnl
	P3jTILX5fkyA8VjucScclRCL8vmnb3WxY9o7pNhAA3PLq/yodF7cuWE=
X-Gm-Gg: Acq92OEJlI5MsabPF/QTZgRNsb9R98xcjFXt9Yzcoo4grSONNpHdyrQkHq3OjMXfdLM
	3a9KVL4UsqyAzhhISujMNMHpqLtyBnlrT6asTRz355NL12YRk1dULnmwOlPQDUqEpJdLe2VldfO
	nSyjeI4eqcwkhadQpj3DP63ig+/LAYDs/Nl7tF+LMvWhXU3rs/maCZ0NNYxqS5jZrjUotn9//V5
	l5qSazuDG7kv2ii605MLRn6tCu9EBdOgrRoWc0NLJMhykNFFPpJWSSk0nj+kbzKp6FbkYa8CXO4
	5A8SqVOi+Pc0+6MQOt+khR7n26g0eBY5acf8yUvchB2CLUD2pKTPcTd1dBd4pWN5PBftV5sII/Y
	92znn84ZrcARaoLUCoVOMyz9G3ZWCbtFYXPBggpbMpzYMgDjSx87CNQSovTBEb4bE2KncFJiLu5
	2sVwCYY2kJ4aM6UrVB6RG+KVSirmTQDuBJkK4Wr5msqj/45Vlq3qq9A3MKvWvpgmysyi4zuuZ0f
	g==
X-Received: by 2002:a05:690c:6b12:b0:7bd:d4f4:261b with SMTP id 00721157ae682-7c95b33d4b2mr103710917b3.29.1778970885288;
        Sat, 16 May 2026 15:34:45 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9c2e49e9sm668787b3.33.2026.05.16.15.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 15:34:44 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	bharata@amd.com
Subject: [RFC PATCH 1/7] mm/damon/core: refcount ops owner module to prevent rmmod UAF
Date: Sat, 16 May 2026 15:34:26 -0700
Message-ID: <20260516223439.4033-2-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516223439.4033-1-ravis.opensrc@gmail.com>
References: <20260516223439.4033-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E4EEA0009
X-Rspamd-Server: rspam04
X-Stat-Signature: r4ox85w43xzxex4abp83i3g1q9myojep
X-HE-Tag: 1778970886-312077
X-HE-Meta: U2FsdGVkX19dKlkF6wucfWXSQ0+FM/BWuiVkqCUxjYbEn42uxRcYhtgtszpnjXjmZj74mAG/czk6EvzrukfW5seMnrc9tgDACaYpIpw21o+uaKb3zfdcHWQ0fUQIOzdbaIrXSvCprHn35OaRmLIvMfq1XzGDHVuYiiEbEz0tI7vVN/VnJQc+gN1anA7GwA4s8ubDoGuIeq7txmUc7q4uWwOT2Cxq1OIuz4/eKgyp1GX3HZYUmr2w0IP+S1tt8MvemWOH2FK/coMo4alKGftTXFFef/5ac+rrfosLdV4nn6ONOQHIvCGcyw2Wo+fhKPIprBKKInkLEaDdnqXqHsosBVrn+azrObgqRRO2PQoKEF9Tqtx/nFMQUapywTPuO4tYD3ZMftpP9IRiTSvgKosRnP+PTbQ883wh3rPBBuBIeGEiIIh5bwP8poaI06xaxDfPqvws6lrgQ7/Av0PC3mVmWbJRucWnJqqm3s+4Pv9uE3QF/GADU2EwbinwOen++o7IOY3fa1ISlGbZjIDybuhBY4uPMhyHhJ+zb583v6nep87dI2CpsFgfkkNwuL98Ryy1oJ8t+b7tsFUFAG810WgF0bBaM3Em7WCdn6gg4OywZJ+01vDo2t5gvtJrQWVsYOlGFThakSK5fhDyOo9JTNzykK9K4C02+bC3XEH9YqORfjW37wlUJtq5oCgf1j4/rfTlqH1FeibSJYDD2PAWCEYWL6bLe5GDgaeiUOSkTG4DfqlcemphGHH6Ms/jmIp+N4kahht/8N6tmF6porALpyr2w3709bPH9xWGYi+pGnSmwSDEv7PAlAKSbMfx81bo8EpNVvetXkb8AtGsP22rLwrbUZ++P9S0tG/bBapGwVxL1SELiVuTJo0I1VV7TL7lMM0UNvk39Ofx5qx77Y3MtTVrAU4jmUTeJjHO/cbPDljStTA3eFy0yX3T/Nt1mFqxdhP1a2my1ueHnQoNkUY7yO3
 evJ3MKta
 p+QHYqyE/L4DXhBdzczp0lQf/o+Q2lE4LoJRvP6j1kqQQb9vNkV7dBsD827s/9v+5eIvgMrCa15H0QyEOOCAh6x2fLIWFmjLi4Cm0VHA/qIq1WGCmRrnjKyWDNNL+yaCZ/15I3pTO3nGUFqp3m0+BG8d7thucAfzW7hlus541nCFoC0iYFR/d8i0LwHaUOqtei3It3rrO/5zf+6fRhxeNV14xy1ZmBz/xJigc0kxZgiVJT/Sydg9Vw/iLC0c6bAW1gDhYl7pwNRW3ASyMgSZutzrtVmcrhlGuRUNp/0hBoydjDDwCY9TIiu9uSP0kEykCNidXdqEvAIf7fUh+rRRtF7S5h0WXU1xbEHfW72B0jEUjJdiLR4rSuyoOc9h27JZbtRSCnwmLsoBb7ekUGmjLmWog7Quh/eqhtM1f27A80m4uF0D7hrk7yvGJe6VVR/GIUXqLE93hid8V8Pci/JJSUvhPTylxgVbW80vDlIOtW/4rD5dingCTtorLmrAZNBWEykn3VaXn0sSySCwtGSTsfh4QnxH0wm1592K6f8OmaSdrQ1PNJ0F9peQ4wQVIVv81oxycagN1Ew1Mw7zXQ2ouZ6sEh19Xwzof6nLwl94R5PNRySUwpLp3pAwUFwHXx3oWSUarj1xNPQo0sRbVK/zrcb5QZEGL1EnCJfAIheaLGZidh/kBiMRPVxpPjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_select_ops() copies the registered damon_operations struct into
ctx->ops by value.  After damon_unregister_ops() is called from a
backend module's exit path, the registry slot is cleared but any
surviving ctx still holds function pointers that resolve into the
unloaded module's text.  Restarting kdamond on such a ctx, or invoking
any ops callback, jumps into freed code.

Add a struct module *owner field to damon_operations.  In
damon_select_ops(), take a reference to ops->owner via try_module_get()
after locating the registry entry; on failure return -EBUSY without
binding the ctx.  If the ctx already had an ops bound (re-select
case), drop the previous owner's reference before installing the new
one to keep the refcount balanced.  In damon_destroy_ctx(), release
the reference via module_put(ctx->ops.owner).

In damon_commit_ctx(), the live ops field is overwritten by a value
copy from src.  Balance the refcount when the owner changes: take a
ref on the new owner (return -EBUSY on failure) and put the ref on the
old owner before the assignment.

Built-in ops sets (vaddr, paddr) leave owner = NULL; try_module_get(NULL)
returns true and module_put(NULL) is a no-op.  Loadable backends set
owner = THIS_MODULE in their registration.

Also add damon_unregister_ops() so loadable backends have a clean exit
path.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h       |  4 ++++
 mm/damon/core.c             | 46 ++++++++++++++++++++++++++++++++++---
 mm/damon/tests/core-kunit.h |  2 +-
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index df7910a39b407..8e6e1cd89e551 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -682,6 +682,8 @@ enum damon_ops_id {
  * struct damon_operations - Monitoring operations for given use cases.
  *
  * @id:				Identifier of this operations set.
+ * @owner:			Module that provides this operations set, or NULL
+ *				for built-in ops.
  * @init:			Initialize operations-related data structures.
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
@@ -728,6 +730,7 @@ enum damon_ops_id {
  */
 struct damon_operations {
 	enum damon_ops_id id;
+	struct module *owner;
 	void (*init)(struct damon_ctx *context);
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
@@ -1206,6 +1209,7 @@ int damon_commit_ctx(struct damon_ctx *old_ctx, struct damon_ctx *new_ctx);
 int damon_nr_running_ctxs(void);
 bool damon_is_registered_ops(enum damon_ops_id id);
 int damon_register_ops(struct damon_operations *ops);
+int damon_unregister_ops(enum damon_ops_id id);
 int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id);
 
 static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e4b9adc0a64dd..b605d36b29b1a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -12,6 +12,7 @@
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/psi.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -93,6 +94,31 @@ int damon_register_ops(struct damon_operations *ops)
 	mutex_unlock(&damon_ops_lock);
 	return err;
 }
+EXPORT_SYMBOL_GPL(damon_register_ops);
+
+/**
+ * damon_unregister_ops() - Unregister a monitoring operations set.
+ * @id:	ID of the operations set to unregister.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_unregister_ops(enum damon_ops_id id)
+{
+	if (id >= NR_DAMON_OPS)
+		return -EINVAL;
+
+	/*
+	 * Callers (typically the owning module exit path) hold a
+	 * module ref via try_module_get() in damon_select_ops(); the
+	 * unregister cannot race with active ctxs because module_exit
+	 * runs only at owner refcount 0.
+	 */
+	mutex_lock(&damon_ops_lock);
+	memset(&damon_registered_ops[id], 0, sizeof(damon_registered_ops[id]));
+	mutex_unlock(&damon_ops_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(damon_unregister_ops);
 
 /**
  * damon_select_ops() - Select a monitoring operations to use with the context.
@@ -112,10 +138,18 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 		return -EINVAL;
 
 	mutex_lock(&damon_ops_lock);
-	if (!__damon_is_registered_ops(id))
+	if (!__damon_is_registered_ops(id)) {
 		err = -EINVAL;
-	else
-		ctx->ops = damon_registered_ops[id];
+		goto out;
+	}
+	if (!try_module_get(damon_registered_ops[id].owner)) {
+		err = -EBUSY;
+		goto out;
+	}
+	/* Drop previous owner ref if this ctx had ops selected before. */
+	module_put(ctx->ops.owner);
+	ctx->ops = damon_registered_ops[id];
+out:
 	mutex_unlock(&damon_ops_lock);
 	return err;
 }
@@ -835,6 +869,7 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 	damon_for_each_sample_filter_safe(f, next_f, &ctx->sample_control)
 		damon_destroy_sample_filter(f, &ctx->sample_control);
 
+	module_put(ctx->ops.owner);
 	kfree(ctx);
 }
 
@@ -1749,6 +1784,11 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 			return err;
 	}
 	dst->pause = src->pause;
+	if (src->ops.owner != dst->ops.owner) {
+		if (!try_module_get(src->ops.owner))
+			return -EBUSY;
+		module_put(dst->ops.owner);
+	}
 	dst->ops = src->ops;
 	err = damon_commit_probes(dst, src);
 	if (err)
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0369c717b93db..300659b115602 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -342,7 +342,7 @@ static void damon_test_split_regions_of(struct kunit *test)
 static void damon_test_ops_registration(struct kunit *test)
 {
 	struct damon_ctx *c = damon_new_ctx();
-	struct damon_operations ops = {.id = DAMON_OPS_VADDR}, bak;
+	struct damon_operations ops = {.id = DAMON_OPS_VADDR}, bak = {};
 	bool need_cleanup = false;
 
 	if (!c)
-- 
2.43.0


