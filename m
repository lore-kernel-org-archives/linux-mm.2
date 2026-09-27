Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6169C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 05:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1FD66B008C; Sun, 27 Sep 2026 01:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED15D6B0092; Sun, 27 Sep 2026 01:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6976B0093; Sun, 27 Sep 2026 01:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B18196B008C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:57:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DF4C1609D5
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:57:40 +0000 (UTC)
X-FDA: 85258485480.01.A0096EB
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2B60B140003
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 05:57:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=geFepAwk;
	spf=pass (imf23.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.228.12 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790488658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwbihVEjfWPjDllUx590oDOljnrUQew6G9j2AJ1GUQM=;
	b=OVcZsm9auD10VLS+AMV2W9TXctpv2fujkrEOIWoeqYaI3jAdG0ccxzLLCkeaaFA9Vp6aeC
	dt2Ro0A1UJbXALhwOYCpGhrzfZe06t/eRkB/l09+uPMJF+Q3MCur2JQTzysBIDFG/ov5hE
	2y//0y5ruO/RbhbxA4+QGLiK4ylmb6U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=snu.ac.kr header.s=google header.b=geFepAwk;
	spf=pass (imf23.hostedemail.com: domain of hsj0512@snu.ac.kr designates 74.125.228.12 as permitted sender) smtp.mailfrom=hsj0512@snu.ac.kr;
	dmarc=pass (policy=none) header.from=snu.ac.kr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790488658;
	b=gRVuBuJT2lN7hkxyCCjm6pQ0UQ91bB4c1ToDsI5vjSJf/VSY3f984VJKATTfRU/+KQs19g
	NpoSxwnL7SZ/I9bYGB9+bdCipyjiiGTMRJrnuHs84Jz6/Vf3PQY3LpVBoxdcxrKyH0c0Kc
	BsjsT3lxhjuAThdbEAbuxpkx2wMfGXA=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4aeso564902a12.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1790488657; x=1791093457; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rwbihVEjfWPjDllUx590oDOljnrUQew6G9j2AJ1GUQM=;
        b=geFepAwkbtJ4nzhIToBsLeVBdWpCpnwmLdgfSe8ELuixp+Qw9EtPw5uh3I3eCRfCOV
         owBRp6GzjI/ym8q3R5cSkVfSql7PSCTBRNDG4VHXHHuuVpM5WrTlBO/7uctd/nSavjqb
         rBmEwEKu6Eqs35zPXNNnhCsIVHbKCDrmCvsGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790488657; x=1791093457;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rwbihVEjfWPjDllUx590oDOljnrUQew6G9j2AJ1GUQM=;
        b=fc++Qrv1rtsN+WsOIy4G/a4oE29jgfRsoiu2l96IE+YNJo6JnO7ixz0AKy69R7owyA
         ZwzV430iERv030uD4dq8sMM1GsjO05jx4lFCqaoFq4OvckNzzwvGqIPhJWcJnJywCrmv
         ewDc0xcEmc8IQ6C73cflGohdzxNVtqMQFh5SL2YPQvSLWHYupBKgLzukCme0Su6yv6u0
         anyA79R6ES+gH8gOJWUW6p8jHdhFsmmGSiRiiIhmBdrh0FhV6ntGAPNCx7JmtwhyQWVk
         h7iNru+t/NDfrDcjeROcJzqOJoMQLu9n9Cn0TpwhUMLjA7m4Z5dUjur1eNDdYxK+sMzK
         H8oA==
X-Gm-Message-State: AFuF++kY5/qC2nPQHoqJustLQAvghSZMvkyh1OzxY8T+MLMgUUJy0SRI
	MDr/GWdQkw3j8aBl9XC1u/o0dF1W18g1ZsKnHJkd0iCJZSDFdIDkEHD1Gjc+yAvMgJo=
X-Gm-Gg: AYBFou2iY7FAN5MNLfP3ZWI6v8QdaI4m3INJxNEQUd2TIdeWmbzesP0tFWrVvvd/Neg
	EWx4UIKhGEEQok38jdBtdmrzSZlvSCpLlc+FDIs3Y+pOe/OjMU/6c+wLyRUU+CPqxIwmHIQKRpe
	JRXGKQiOTWiGv+jzoCkh/JFqaNkKqR9ugD0o3cbtzq+vzjDp9EBW4qcU+SLhXFsn4FZccLgInpb
	RvCqRDXRu1tPNrLPk3kx758xkPR+GUYL09Y11C+2CSCVlRGfcz0Ed1Ox9PDzK11jblJylxa8dJQ
	WaVjQZEMDZMfkXrC1qizSYb52g20PY4o9Q6QMOvzkTjLKA7uD102GZyM8ziNQce4hEGTxDVV/lK
	0rB3CKmcDlz+ntbB4fvWhTjO1JP1DE27Z61L/hge62KnfQlJLgOeCT0GVX7JRuTmABhn3C/ngXv
	bfE3KFimPqdjKJxK26Lr7tQQtgAhLHqkP18mw02nDo3rvrDxcc0rsKOtarhQKnLAgS
X-Received: by 2002:a05:6a20:430b:b0:3d0:cc29:ff64 with SMTP id adf61e73a8af0-3de0e6fdd47mr9773670637.15.1790488656909;
        Sat, 26 Sep 2026 22:57:36 -0700 (PDT)
Received: from [172.19.0.2] ([49.142.45.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8808182fd7fsm2328266b3a.39.2026.09.26.22.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 22:57:36 -0700 (PDT)
From: Seongjun Hong <hsj0512@snu.ac.kr>
Date: Sun, 27 Sep 2026 05:57:27 +0000
Subject: [PATCH 1/2] tools/mm/slabinfo: refactor slab attribute reading
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260927-tools-mm-update-slabinfo-v1-1-a4ea0d4dc136@snu.ac.kr>
References: <20260927-tools-mm-update-slabinfo-v1-0-a4ea0d4dc136@snu.ac.kr>
In-Reply-To: <20260927-tools-mm-update-slabinfo-v1-0-a4ea0d4dc136@snu.ac.kr>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Seongjun Hong <hsj0512@snu.ac.kr>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B60B140003
X-Rspam-User: 
X-Stat-Signature: ujkwxssgchuqthefkfo5b793kar44x3a
X-HE-Tag: 1790488658-181059
X-HE-Meta: U2FsdGVkX1/oxsqomym6/pY9r4U7DxNihwob39oyAiSjYPiC3ZCTMVwA8E9+qXRNI+KbtnUThpK1zKpX8KjcYJNDQ3kvx9YPrKW2kDK8o6fKEU59OIcoHuObjw3uF1AXor3Q327/3nI1xgMjl+Jtw9HCTqK2LEu/ODoKR4Mx/HYcf5AFb6S3wRxlOmuBBMVCt779PMnFg7reIVvKxUMd43q60Q50lvIj4M9Lf4w8rquvivmzngBMc17n/GPR0yLIoZAXd+LQiUbeecG6LtsSqUYYaxrIz301TfvFYWNSXn6o4ru5L7dO8BTWXoaoMlJUjKQM68XFRd4hGVdQR7YnDuqeJXyIS7K/kN5M3PMYF+Ew3no8sY65YKMO21+6RY+o4jwN0yBrPXfP061hWxqHEmGrZo+oPrSQ/LL89eoNssXD6hGXbMR+6UyHMa3c7JJpTnu2p+5cuJhuGwE/LG+CT3pjYtL/EJAzfEWyM/V+hjZoH4ZfRDYiD4uwQ0ts5p75pSfyInWtmXy5DSOT9mAJCGUjnJfen8y1uqefQLe8otzt93hmncRipbfpjuTTjFMe5EPMuG4kSNZtGHxUfTk3fRlC+LHog812Jd+3QrZYT31agMjDvZaXtu+a9luiNJ2V+YAnv+qZWeumyp0AISWXCedh7jomUQiEMPfbR1A4loI/dvXbcRbN/6UPph5Nx+I6leyMY1f/kFTIFK8Y1j85aKcH+f5QCRh1ShbMmdFtajJGOrcA7Me1bZUzdOjKBWciSI7lfACF4Gm5lRBWnVoF7rTrwp2O1bWrd++0PirGhiJNBk9q0qh/0KhoV1wY1facJ3IucwHQ/tJtAu8ayCauOsRxRaC30rbgs8pNcepeOzm72tWEAw/lSdElccOE/rDOHtC4wVtTb6Msysdk13IxsmHypc3hkTomLMLzIKKLIJOIHMOObeiTADBa9R4tW0qLqCJAJwER+rXyt/1q/no
 HQeSJgC+
 qnBJTHBE0WnMt4wnc3Nc4ToCG0U/1bQ3Kw8OJgW81wKfAELF39XTqFk/sYg8wpSQpzvfoj/+HyOFX/bXyk9Gn7ZGf11iNQ5t3Yhb6IIJX1uEoDja7lsaOImemJ/1Q/S/fyQQdi+oTUZxV+2mDsuCY4GkhDWUaTTqPAJs2RW9btx/Q/g4MYyR+6T+fPh/nw8mxANSvKgphSp6MqhVmxX8kTxV78P/btzHQDOY5DUvIf9GxH0sTG3sII0NXVNZk0Bku05TV9Lqq3rmLWMapH1rALxmr6AoIrZ5t9qv76jTSdwpvzSmE14dyQKkuPotHl+hYGBoM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The fields of struct slabinfo were mixed with deprecated sysfs files,
which looks complicated. Organize every field of struct slabinfo by
config option and the attribute order in mm/slub.c's slab_attrs[]. Because
slabinfo should be able to run on previous kernel releases, leave the
deprecated members for this time.

read_slab_dir() had ~50 lines of attribute reads inlined. Move them to a
new fill_slabinfo() helper so that directory walk and per-cache
attribute reading are separated.

Fold get_obj_and_str() and decode_numa_list() into get_obj_and_decode()
to avoid unnecessary strdup() and leave only one member assignment in
fill_slabinfo() for each sysfs file.

Make broken statements into a single line for better readibility.

Remove alias field from struct slabinfo because it is initialized to 0
and never updated. The only usage of this field "if (slab->alias)" is dead.

No functional change intended.

Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
---
 tools/mm/slabinfo.c | 245 ++++++++++++++++++++++++++++------------------------
 1 file changed, 131 insertions(+), 114 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 48d1ee8b0e81..84359d628f2e 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -27,25 +27,49 @@
 
 struct slabinfo {
 	char *name;
-	int alias;
 	int refs;
-	int aliases, align, cache_dma, cpu_slabs, destroy_by_rcu;
-	unsigned int hwcache_align, object_size, objs_per_slab;
-	unsigned int sanity_checks, slab_size, store_user, trace;
-	int order, poison, reclaim_account, red_zone;
-	unsigned long partial, objects, slabs, objects_partial, total_objects;
+	int numa_slabs[MAX_NODES];
+	int numa_partial[MAX_NODES];
+
+	unsigned int slab_size, object_size;
+	unsigned int objs_per_slab, order;
+	unsigned long objects_partial, partial;
+	int aliases;
+	unsigned int align;
+	int hwcache_align;
+	int reclaim_account;
+	int destroy_by_rcu;
+
+	/* CONFIG_SLUB_DEBUG */
+	unsigned long total_objects, objects, slabs;
+	int sanity_checks, trace, red_zone, poison, store_user;
+
+	/* CONFIG_ZONE_DMA */
+	int cache_dma;
+
+	/* CONFIG_SLUB_STATS */
 	unsigned long alloc_fastpath, alloc_slowpath;
 	unsigned long free_fastpath, free_slowpath;
-	unsigned long free_frozen, free_add_partial, free_remove_partial;
-	unsigned long alloc_from_partial, alloc_slab, free_slab, alloc_refill;
-	unsigned long cpuslab_flush, deactivate_full, deactivate_empty;
+	unsigned long free_add_partial, free_remove_partial;
+	unsigned long alloc_slab, alloc_node_mismatch, free_slab;
+	unsigned long order_fallback;
+	unsigned long cmpxchg_double_fail;
+
+	/*
+	 * Deprecated files:
+	 * No STAT_ATTR()/SLAB_ATTR() for these exists in mm/slub.c's
+	 * slab_attrs[] anymore. Although cpu_slabs remains as a file,
+	 * it is also outdated and always prints 0. Keep these for backward
+	 * compatibility, but they should be removed later.
+	 */
+	int cpu_slabs;
+	unsigned long free_frozen;
 	unsigned long deactivate_to_head, deactivate_to_tail;
-	unsigned long deactivate_remote_frees, order_fallback;
-	unsigned long cmpxchg_double_cpu_fail, cmpxchg_double_fail;
-	unsigned long alloc_node_mismatch, deactivate_bypass;
+	unsigned long alloc_from_partial, alloc_refill;
+	unsigned long cpuslab_flush, deactivate_full, deactivate_empty;
+	unsigned long deactivate_remote_frees, deactivate_bypass;
+	unsigned long cmpxchg_double_cpu_fail;
 	unsigned long cpu_partial_alloc, cpu_partial_free;
-	int numa[MAX_NODES];
-	int numa_partial[MAX_NODES];
 } slabinfo[MAX_SLABS];
 
 struct aliasinfo {
@@ -174,6 +198,30 @@ static unsigned long read_obj(const char *name)
 	return strlen(buffer);
 }
 
+static void decode_numa_list(int *numa, char *t)
+{
+	int node;
+	int nr;
+
+	memset(numa, 0, MAX_NODES * sizeof(int));
+
+	if (!t)
+		return;
+
+	while (*t == 'N') {
+		t++;
+		node = strtoul(t, &t, 10);
+		if (*t == '=') {
+			t++;
+			nr = strtoul(t, &t, 10);
+			numa[node] = nr;
+			if (node > highest_node)
+				highest_node = node;
+		}
+		while (*t == ' ')
+			t++;
+	}
+}
 
 /*
  * Get the contents of an attribute
@@ -186,21 +234,19 @@ static unsigned long get_obj(const char *name)
 	return atol(buffer);
 }
 
-static unsigned long get_obj_and_str(const char *name, char **x)
+static unsigned long get_obj_and_decode(int *numa, const char *name)
 {
 	unsigned long result = 0;
 	char *p;
 
-	*x = NULL;
-
 	if (!read_obj(name))
 		return 0;
 
 	result = strtoul(buffer, &p, 10);
 	while (*p == ' ')
 		p++;
-	if (*p)
-		*x = strdup(p);
+
+	decode_numa_list(numa, p);
 	return result;
 }
 
@@ -293,31 +339,6 @@ static int store_size(char *buffer, unsigned long value)
 	return n;
 }
 
-static void decode_numa_list(int *numa, char *t)
-{
-	int node;
-	int nr;
-
-	memset(numa, 0, MAX_NODES * sizeof(int));
-
-	if (!t)
-		return;
-
-	while (*t == 'N') {
-		t++;
-		node = strtoul(t, &t, 10);
-		if (*t == '=') {
-			t++;
-			nr = strtoul(t, &t, 10);
-			numa[node] = nr;
-			if (node > highest_node)
-				highest_node = node;
-		}
-		while (*t == ' ')
-			t++;
-	}
-}
-
 static void slab_validate(struct slabinfo *s)
 {
 	if (strcmp(s->name, "*") == 0)
@@ -410,7 +431,7 @@ static void slab_numa(struct slabinfo *s, int mode)
 	for(node = 0; node <= highest_node; node++) {
 		char b[20];
 
-		store_size(b, s->numa[node]);
+		store_size(b, s->numa_slabs[node]);
 		printf(" %4s", b);
 	}
 	printf("\n");
@@ -1210,6 +1231,57 @@ static int slab_mismatch(char *slab)
 	return regexec(&pattern, slab, 0, NULL, 0);
 }
 
+static void fill_slabinfo(struct slabinfo *slab, const char *name)
+{
+	slab->name = strdup(name);
+	slab->refs = 0;
+	slab->aliases = get_obj("aliases");
+	slab->align = get_obj("align");
+	slab->cache_dma = get_obj("cache_dma");
+	slab->cpu_slabs = get_obj("cpu_slabs");
+	slab->destroy_by_rcu = get_obj("destroy_by_rcu");
+	slab->hwcache_align = get_obj("hwcache_align");
+	slab->object_size = get_obj("object_size");
+	slab->objects = get_obj("objects");
+	slab->objects_partial = get_obj("objects_partial");
+	slab->total_objects = get_obj("total_objects");
+	slab->objs_per_slab = get_obj("objs_per_slab");
+	slab->order = get_obj("order");
+	slab->partial = get_obj_and_decode(slab->numa_partial, "partial");
+	slab->poison = get_obj("poison");
+	slab->reclaim_account = get_obj("reclaim_account");
+	slab->red_zone = get_obj("red_zone");
+	slab->sanity_checks = get_obj("sanity_checks");
+	slab->slab_size = get_obj("slab_size");
+	slab->slabs = get_obj_and_decode(slab->numa_slabs, "slabs");
+	slab->store_user = get_obj("store_user");
+	slab->trace = get_obj("trace");
+	slab->alloc_fastpath = get_obj("alloc_fastpath");
+	slab->alloc_slowpath = get_obj("alloc_slowpath");
+	slab->free_fastpath = get_obj("free_fastpath");
+	slab->free_slowpath = get_obj("free_slowpath");
+	slab->free_frozen = get_obj("free_frozen");
+	slab->free_add_partial = get_obj("free_add_partial");
+	slab->free_remove_partial = get_obj("free_remove_partial");
+	slab->alloc_from_partial = get_obj("alloc_from_partial");
+	slab->alloc_slab = get_obj("alloc_slab");
+	slab->alloc_refill = get_obj("alloc_refill");
+	slab->free_slab = get_obj("free_slab");
+	slab->cpuslab_flush = get_obj("cpuslab_flush");
+	slab->deactivate_full = get_obj("deactivate_full");
+	slab->deactivate_empty = get_obj("deactivate_empty");
+	slab->deactivate_to_head = get_obj("deactivate_to_head");
+	slab->deactivate_to_tail = get_obj("deactivate_to_tail");
+	slab->deactivate_remote_frees = get_obj("deactivate_remote_frees");
+	slab->order_fallback = get_obj("order_fallback");
+	slab->cmpxchg_double_cpu_fail = get_obj("cmpxchg_double_cpu_fail");
+	slab->cmpxchg_double_fail = get_obj("cmpxchg_double_fail");
+	slab->cpu_partial_alloc = get_obj("cpu_partial_alloc");
+	slab->cpu_partial_free = get_obj("cpu_partial_free");
+	slab->alloc_node_mismatch = get_obj("alloc_node_mismatch");
+	slab->deactivate_bypass = get_obj("deactivate_bypass");
+}
+
 static void read_slab_dir(void)
 {
 	DIR *dir;
@@ -1217,7 +1289,6 @@ static void read_slab_dir(void)
 	struct slabinfo *slab = slabinfo;
 	struct aliasinfo *alias = aliasinfo;
 	char *p;
-	char *t;
 	int count;
 
 	if (chdir("/sys/kernel/slab") && chdir("/sys/slab"))
@@ -1226,14 +1297,14 @@ static void read_slab_dir(void)
 	dir = opendir(".");
 	while ((de = readdir(dir))) {
 		if (de->d_name[0] == '.' ||
-			(de->d_name[0] != ':' && slab_mismatch(de->d_name)))
-				continue;
+		    (de->d_name[0] != ':' && slab_mismatch(de->d_name)))
+			continue;
 		switch (de->d_type) {
-		   case DT_LNK:
+		case DT_LNK:
 			if (alias - aliasinfo == MAX_ALIASES)
 				fatal("Too many aliases\n");
 			alias->name = strdup(de->d_name);
-			count = readlink(de->d_name, buffer, sizeof(buffer)-1);
+			count = readlink(de->d_name, buffer, sizeof(buffer) - 1);
 
 			if (count < 0)
 				fatal("Cannot read symlink %s\n", de->d_name);
@@ -1245,71 +1316,21 @@ static void read_slab_dir(void)
 			alias->ref = strdup(p);
 			alias++;
 			break;
-		   case DT_DIR:
+		case DT_DIR:
 			if (slab - slabinfo == MAX_SLABS)
 				fatal("Too many slabs\n");
 			if (chdir(de->d_name))
 				fatal("Unable to access slab %s\n", slab->name);
-			slab->name = strdup(de->d_name);
-			slab->alias = 0;
-			slab->refs = 0;
-			slab->aliases = get_obj("aliases");
-			slab->align = get_obj("align");
-			slab->cache_dma = get_obj("cache_dma");
-			slab->cpu_slabs = get_obj("cpu_slabs");
-			slab->destroy_by_rcu = get_obj("destroy_by_rcu");
-			slab->hwcache_align = get_obj("hwcache_align");
-			slab->object_size = get_obj("object_size");
-			slab->objects = get_obj("objects");
-			slab->objects_partial = get_obj("objects_partial");
-			slab->total_objects = get_obj("total_objects");
-			slab->objs_per_slab = get_obj("objs_per_slab");
-			slab->order = get_obj("order");
-			slab->partial = get_obj_and_str("partial", &t);
-			decode_numa_list(slab->numa_partial, t);
-			free(t);
-			slab->poison = get_obj("poison");
-			slab->reclaim_account = get_obj("reclaim_account");
-			slab->red_zone = get_obj("red_zone");
-			slab->sanity_checks = get_obj("sanity_checks");
-			slab->slab_size = get_obj("slab_size");
-			slab->slabs = get_obj_and_str("slabs", &t);
-			decode_numa_list(slab->numa, t);
-			free(t);
-			slab->store_user = get_obj("store_user");
-			slab->trace = get_obj("trace");
-			slab->alloc_fastpath = get_obj("alloc_fastpath");
-			slab->alloc_slowpath = get_obj("alloc_slowpath");
-			slab->free_fastpath = get_obj("free_fastpath");
-			slab->free_slowpath = get_obj("free_slowpath");
-			slab->free_frozen= get_obj("free_frozen");
-			slab->free_add_partial = get_obj("free_add_partial");
-			slab->free_remove_partial = get_obj("free_remove_partial");
-			slab->alloc_from_partial = get_obj("alloc_from_partial");
-			slab->alloc_slab = get_obj("alloc_slab");
-			slab->alloc_refill = get_obj("alloc_refill");
-			slab->free_slab = get_obj("free_slab");
-			slab->cpuslab_flush = get_obj("cpuslab_flush");
-			slab->deactivate_full = get_obj("deactivate_full");
-			slab->deactivate_empty = get_obj("deactivate_empty");
-			slab->deactivate_to_head = get_obj("deactivate_to_head");
-			slab->deactivate_to_tail = get_obj("deactivate_to_tail");
-			slab->deactivate_remote_frees = get_obj("deactivate_remote_frees");
-			slab->order_fallback = get_obj("order_fallback");
-			slab->cmpxchg_double_cpu_fail = get_obj("cmpxchg_double_cpu_fail");
-			slab->cmpxchg_double_fail = get_obj("cmpxchg_double_fail");
-			slab->cpu_partial_alloc = get_obj("cpu_partial_alloc");
-			slab->cpu_partial_free = get_obj("cpu_partial_free");
-			slab->alloc_node_mismatch = get_obj("alloc_node_mismatch");
-			slab->deactivate_bypass = get_obj("deactivate_bypass");
+
+			fill_slabinfo(slab, de->d_name);
+
 			if (chdir(".."))
-				fatal("Unable to chdir from slab ../%s\n",
-				      slab->name);
+				fatal("Unable to chdir from slab ../%s\n", slab->name);
 			if (slab->name[0] == ':')
 				alias_targets++;
 			slab++;
 			break;
-		   default :
+		default:
 			fatal("Unknown file type %lx\n", de->d_type);
 		}
 	}
@@ -1324,12 +1345,7 @@ static void output_slabs(void)
 	struct slabinfo *slab;
 	int lines = output_lines;
 
-	for (slab = slabinfo; (slab < slabinfo + slabs) &&
-			lines != 0; slab++) {
-
-		if (slab->alias)
-			continue;
-
+	for (slab = slabinfo; (slab < slabinfo + slabs) && lines != 0; slab++) {
 		if (lines != -1)
 			lines--;
 
@@ -1528,9 +1544,10 @@ int main(int argc, char *argv[])
 
 	err = regcomp(&pattern, pattern_source, REG_ICASE|REG_NOSUB);
 	if (err)
-		fatal("%s: Invalid pattern '%s' code %d\n",
-			argv[0], pattern_source, err);
+		fatal("%s: Invalid pattern '%s' code %d\n", argv[0], pattern_source, err);
+
 	read_slab_dir();
+
 	if (show_alias) {
 		alias();
 	} else if (extended_totals) {

-- 
2.43.0


