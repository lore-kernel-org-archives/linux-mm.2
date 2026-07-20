Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43919C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0F46B00C0; Mon, 20 Jul 2026 15:35:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA8D6B00C2; Mon, 20 Jul 2026 15:35:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989376B00C3; Mon, 20 Jul 2026 15:35:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68B766B00C0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D912E1C02FC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:40 +0000 (UTC)
X-FDA: 85010159640.04.BBDF4D4
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id 24AED20002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=krUrxIvX;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyXKxKoPetSKUj/EMCvw6yCRblDu/3mrIttJowkuK3Y=;
	b=bPrwvraRDHT2F/s6peSsjvV/pAoMViPwCHrgnuGgON7+J9KlIoqOwIGhYPf50RVZUuTM6R
	AlwZlmQY82dHGbd3ynbDzRaAuV8zZ4/Xjbo3BnUNz5883P8ZEdo1dThs5OxHiCI4tOtuu6
	gbSwb7XcTn1eMUC/dkNwRzaesMlKg4c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=krUrxIvX;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576139;
	b=vkQNBUgGVmre/ez21Efrq2lXr60A0WP+pHrg/kYIi1r7KpXtCCh/utSjgwFFqv0fIAbQrt
	ijYbptq/SGB/wIeoUQeqme4v6oNEDXgKLrUUEVbRsiny51+r6KbkNIJCCerFnzvGDHGJS+
	SjcsB2NMNZnziyi8/T9h5V+q9545TNg=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e85499ffbso577763285a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576138; x=1785180938; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KyXKxKoPetSKUj/EMCvw6yCRblDu/3mrIttJowkuK3Y=;
        b=krUrxIvXIa63X8pWE0ZJxWRyyBQFWUJpmWljGnVwHQCuerWB8P0eDLgQ7lXuAlpaQB
         ZIK6aUrj/bSRHu9+JDdWeC3KnfVFg7yR+vchUoiEAwcfjGUMe5L31RcuEG3xWvZOuRKJ
         ApzpmhGDmgEQhAUKuZLV5yFQ2CFkh8aMqwl4wWBfNAEbyaDHGpaUY9dQ1H/49NIhWOju
         N80JLSrzrfKEv4u+frAn17znzK4Xoc3eQjlBmWhQ48V3pmelnHbUsX/ZFejg+LY0zl0P
         KZzBzQpmMln4DF/k79PLuqv8nPoGVmUUOLTU+GNrQ2Jt41mR8m2JIubEIM4JBktZwRfN
         0Pxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576138; x=1785180938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KyXKxKoPetSKUj/EMCvw6yCRblDu/3mrIttJowkuK3Y=;
        b=ElQED82vVJkozgnfKHyKb7nzfu2Ty2xnDi5lu2zdT/POiOivmlvaDCW9SVs2SkQp1i
         hoxcnmRLmtzuGIN919xSfbUB/8cpF6UgAG3tzi+PHnpaYoZOATp+6iThk+SPrMt6Ytb2
         cwoIXBS14k1ArACi9ehEadtV111tDrwp05H9iMmXuF2RjMeEpW6XNKMESr9Y6iHBtuBN
         2oEh5QOpuWfuZY6FeI0JsUIiuCLe2vKDl3EJb7HU9dxfDeYqqeEuQOS3r+ITVB96eFWM
         1/Ekoz9NgKLnVIApdcYcHMtAEnCy3mqq5jrEzk5vc0cVCp1Vqv2t411VWpjWoMW1Ionv
         yS6A==
X-Gm-Message-State: AOJu0YyXL1Jgx20YLSHvcW5mIxy6OMg4SR7ezqm7KW/Vse2t+B04hTlA
	Pf26BWyCJorLsGzfORFYxjMq6EnvLDWwWdW5PpQOrL/UfSUVzJGjSv2/X+zoWhjFFhQePYUsabU
	7beLp
X-Gm-Gg: AfdE7cm06gitvrh7Ddj47ziihI8d8+//2oXQ2ReSPO17aoEFiCXz6etgKo2q/iaR9I9
	Hw/mjXWk+mcC983QNzRVyr+eP1clle88BdjDtG4gKD2h2raZ0wD4k+BQuuHGPvmooOfoUp876Fa
	W8aJO9ZWB1tnwcA6lOtd1B1QVb5ZIrXB5cYllFMIm1eXjN1lWj4E3aFLEWZimoYET4nznuvvGEh
	c6abXTBBB2BBINGPa9OpK2xyh1N17TJ9UWhSnOSex2+oxTzZIq6AB7fD6swOBcexRrf6s3A6z93
	ndUUpVdT7UHF1gA7xJx25RDckUfPSOEh1GBTOPY1OrZu5tdFhz5ngmGym0shi5sM4Tt3Q8EHA8F
	IkSij2jhAwS2MTDmfPp+fkSIpWEjkjOcqHD3DnGVmzUsBJ9R1uNH66BW8Ca3RZlMhqQSdOJEfJZ
	q/fWB1EC1J2cIzlz3IcMqLENhNxmnvLhs6aG8W5/wGMzlW9Evzhpz7a4s2dLgelh1SCshXtck+B
	w==
X-Received: by 2002:a05:620a:44c2:b0:930:a963:da73 with SMTP id af79cd13be357-930b419edc2mr1559559685a.50.1784576138219;
        Mon, 20 Jul 2026 12:35:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:37 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 23/36] mm/mempolicy: apply policy at the kernel zone for private-node binds
Date: Mon, 20 Jul 2026 15:34:17 -0400
Message-ID: <20260720193431.3841992-24-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 24AED20002
X-Stat-Signature: 3wm4y11ehpuu7r9hbntgohrrc8jw1njb
X-HE-Tag: 1784576138-201696
X-HE-Meta: U2FsdGVkX1+h2zyskEwanXAX12o20fHMaHBaenxrqojxebcX2KPv5eIDmZeLuNhG538JTyWKg1sjH6nP/odlWdPA0AeNbVpB2wy5BXc7Bfb4Di21F+KkpzgKe9EUQxhK9+LTWZhUgMLt0hw94YIzzRKpWB0UShH4hNzxiEaEM5pj36vveB3kaBuaT9ltAbkOeuwIbIvHH53AQR6tsbNG0OZf22okM3JeSQbZ1mSpBQsK2tzV/cXeVwngx909/m4G6tuGiKQfWgWt5mMByRtT+76SDTJIm8q/zY4Pv20OBEfL0E1RP0gebHxXL8d0ddFiZp6x66fR3IZUPKWwur3/ZCx8Zup19kXYiC5UOKfihyUKA2GtJAaxLc76/5RoEttsA7y5OiDRJ6XfO/fI7oiVcZvK0k6GlERppfHRxAXUdoXSOiJkqMRomMQHjZAFnWMYogT2lLw4C3WoQFpPgEMLUwark8Wj6tPs8tEVpHAoWcY8sy/SquQRbUXPeSgmrByiJsgCTTPTiN6vQof9qXd22nTlrKVrjzKSUFJOnw89TH2Q8RawsQTqtBZEMTS1eW5YKkw9xEuNT86q7bPdCWm2VXzZ13SscKIcyCpCDdmSEhm4qQDOHdJeHjhIupKhcdXT2yOdwPEK/TBijE7gpnBS3Vi5ZvwbRtqfdQKoHb1TAj89xfffLkA5lc9tB5GqGH8JJtDee+3byOQre684ar4JjpPMxvrLwstWtJfWe/eR4uTKRsefbBk2Zc8p/DQ1bN9Ai3V/GqdR+mOFCzhS2BX04OryTwDlfC1iFAlquC3u8zPeFFgEkQhU8uEwTUsTNzgjPYiYuTma3iKJjnj9S8sZH8OrHUY6XVThcde4FEc7mb85bpSEIiPG/XY4DZ/pIcusxkj/9AuM3vf/crNai6DQ45Tzgc6RFKidqeHX0MFsBc4239fFHL/XFh++mnwVeMF9voJ59Dulvw2twzocDcG
 KiBGFTMG
 WvDtya9HYQJEGk3NXB6baFzCv3AeDCT9EZMKYEG+qayWd5lfY0LX5H0dBZ4Cj4mxHkdudAi5e3JXIY6+yPk7Wn8E6ShF2nF2O7iEF6YdFpMBBgib/lvkjVC10TrLHrEVIv28dEdmOnkBMHb1nj3r/3MHHZ+Cj6MbE2r7Elglnll9NvtNGM8Y7G2lH6u2NwIGXnms+nmL6u0GbLcj674/Wg8suUjl2D7z8xZI1WuwlMjrFaRzOdfyEu0JhzG9VUyW4pJl3PqBbllk8FUFFNINMJT/qy3tp+1S4mfaRQmdlT3tbiafsIRBUnPtnXjGBwRcDset8+rWo295oav7dvv+6IG53+yHngOiEByjwtUBWncQcbYXH0MrXTGKOKduDmvIS8msT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_policy_zone() raises dynamic_policy_zone to ZONE_MOVABLE when none
of a policy's nodes have non-movable memory, so a bind to movable-only
node does not force kernel-zone allocations onto a zone that cannot
satisfy them - resulting retries forever (livelock).

The current code uses N_HIGH_MEMORY to denote eligibility, but private
nodes are deliberately not in N_HIGH_MEMORY nor N_NORMAL_MEMORY. This
means a private node onlined into ZONE_NORMAL is judged as movable-only.

This means a policy set with set_mempolicy() binding a private node with
ZONE_NORMAL memory will shunt otherwise eligible allocations (like the
task's page tables) back to N_MEMORY nodes.

This also becomes relevant for in-kernel users that want non-movable
memory (such as KVM placing pinned VM memory solely on a private node).

Add policy_private_has_kernel_zone() to consult the actual zones of
the policy's private nodes and keep the policy applied at lower zones
when a kernel-zoned private node can satisfy the allocation.

Only a mempolicy binding a private node pays the zone scan, all other
mempolicies preserve fast-path performance.

Additionally: update the comments in apply_policy_zone for clarity,
because this particular policy mechanism is very confusing.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 90110e9761122..e83c2c7a94c1d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2091,6 +2091,34 @@ bool vma_policy_mof(struct vm_area_struct *vma)
 	return mof;
 }
 
+/*
+ * true if any policy *private* node can satisfy a !__GFP_MOVABLE allocation.
+ * Policies without private nodes (~MPOL_F_PRIVATE) always return false.
+ *
+ * This provides a way for otherwise-bound kernel allocations to make their
+ * way onto private nodes with ZONE_NORMAL memory without having to audit
+ * every caller.  The cost is a zone scan for private nodes in the mask.
+ */
+static bool policy_private_has_kernel_zone(const struct mempolicy *pol)
+{
+	int nid;
+
+	if (!(pol->flags & MPOL_F_PRIVATE))
+		return false;
+
+	for_each_node_mask(nid, pol->nodes) {
+		pg_data_t *pgdat = NODE_DATA(nid);
+		enum zone_type zt;
+
+		if (!node_is_private(nid))
+			continue;
+		for (zt = ZONE_NORMAL; zt < ZONE_MOVABLE; zt++)
+			if (managed_zone(&pgdat->node_zones[zt]))
+				return true;
+	}
+	return false;
+}
+
 bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 {
 	enum zone_type dynamic_policy_zone = policy_zone;
@@ -2098,14 +2126,22 @@ bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 	BUG_ON(dynamic_policy_zone == ZONE_MOVABLE);
 
 	/*
-	 * if policy->nodes has movable memory only,
-	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
+	 * dynamic_policy_zone is the lowest zone this policy is enforced for,
+	 * allocations below it ignore the nodemask and fall back freely.
+	 *
+	 * If all policy-nodes are movable-only (all ZONE_MOVABLE), raise the
+	 * dynamic_policy_zone to ZONE_MOVABLE so that only movable allocations
+	 * stay bound - otherwise this would force kernel-zone allocations
+	 * (e.g. page tables) onto a zone that cannot satisfy them.  This
+	 * results in allocation failure and retry loop (livelock).
 	 *
-	 * policy->nodes is intersect with node_states[N_MEMORY].
-	 * so if the following test fails, it implies
-	 * policy->nodes has movable memory only.
+	 * N_HIGH_MEMORY tells us "has a non-movable zone" for ordinary nodes.
+	 * Private nodes are deliberately excluded from N_HIGH_MEMORY, so we
+	 * need to check their actual zones - a kernel-zoned private node can
+	 * hold the allocation and must keep the policy applied.
 	 */
-	if (!nodes_intersects(policy->nodes, node_states[N_HIGH_MEMORY]))
+	if (!nodes_intersects(policy->nodes, node_states[N_HIGH_MEMORY]) &&
+	    !policy_private_has_kernel_zone(policy))
 		dynamic_policy_zone = ZONE_MOVABLE;
 
 	return zone >= dynamic_policy_zone;
-- 
2.53.0-Meta


