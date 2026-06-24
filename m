Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C0FCDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9DE86B0092; Wed, 24 Jun 2026 09:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E3C6B0093; Wed, 24 Jun 2026 09:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16516B0095; Wed, 24 Jun 2026 09:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86FB86B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:12:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0346A1C59E8
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:19 +0000 (UTC)
X-FDA: 84914844840.30.9E43226
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6160D1C0009
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X8wi8DxC;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782306738;
	b=QWY6g+WCtbj6waHx+etzkmlZmId3ldnzO8WQ37L9IZ6Xe98HVzH6GwTb/OGo1qjCKFSpfH
	oSmAXsDBQn6BYWYjOo8HriVWcrUJq77Il4H+H4w+FjO9c8Lza4Wauzn1OP0Bj4O9kyXw/9
	GqUkuOYlXWOa940GSqsDv86kME4ERRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782306738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pH+P1A8V8KYcn2HoUYmytNSMd9QH6OkhOZdd7wOXtm4=;
	b=wDqgLF3hU7QUSQT/EVzck5I4NDOAJTop11FS3vUv/OkJ1zoF32dEm2ro/jVLvKly9Xvv1p
	XoY55tt4Q9+Fi6GDW6vFG/QvVEVOLGNJh7ge8EBGIpL26QvxrQZ2EPlEY5nolMdKCZbwHf
	8Izr/p4iElr7b2Vn6iACx7y/ihBeP/g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X8wi8DxC;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E70F360211;
	Wed, 24 Jun 2026 13:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CF51F00A3D;
	Wed, 24 Jun 2026 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782306737;
	bh=pH+P1A8V8KYcn2HoUYmytNSMd9QH6OkhOZdd7wOXtm4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=X8wi8DxCVvf2fDIieTQiC+2oqznJvQ5h71UPWbCLrs/szy1LUvFqkrAEP3kHkFRZM
	 kBVGfc8bu4d7UukFgsr+RWKod2Pg+VHMheIRWy/oePtVLghKNk2v05qIDXCS3vQWhg
	 uZx8Wfyj2sTCDZN3bwOe+O0XS4LWocVPPLz3u7iVk1cg6jR9sN7zaHPJt/7Ce2e6ME
	 7gHFXLDGnxmPbsKddrT8XNq7s5mnmgaGjEoG85wx+4SLrmBTknDqjxdPV5BoCj19Ti
	 KZfyjRMzOQ046/xXjrpkRTtsaP+q5U03TtatiLgQHIfNWwXuQj1b1QME0ArQHH55P6
	 gE4kalO0HRzcA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 24 Jun 2026 22:11:40 +0900
Subject: [PATCH RFC 3/4] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260624-kmalloc-nolock-fixes-v1-3-fdf4d17351dd@kernel.org>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Stat-Signature: 5opg54zqbayd8wqyo78w474uxqfgp8k8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6160D1C0009
X-HE-Tag: 1782306738-122460
X-HE-Meta: U2FsdGVkX1++CNFMu51wD1nWvxs/j7elm5dibVLQ7ngqGY7/Q5SKGEu4ikM5eBsezx7m0+mooJfqkIGKFE3BOKGTkOWLhL6/C5pmDCxpBKDYI8IISe1kEA3uRZHmnvPrM6fC8BDrWeyoi8pfhN7diXC4q5yyFnOZlqny/hWJgTNvwdywsWywigPxhga20yt/QujpvqjRSLBhh8i3RW871OAHWu9r+ba5k2zwrz73I2DZzM14GdsOgGdrQiqXj7T3znIi3rPpdzvDgniBJi1+1RWTrpoF5BYNRgFFXFDRTQpJuF8h1ot8EZdpjEm3+Vha3FwcayjKkUxUd7oiCOfP5qBj0WuZKAw2V/WGyZFvUFyHBWx6LZbeKHNmULX0A9J1nE1PSughztWd20sAOIrqQE9Qrl1kTdR1w/LAAVO65wJNWwkG5BD97CJrZWxnorEymQJMlA6Us0/yC9mQunLcaMV4QpGGnQNFPvgCqwwe6zfDxyBb/pnGmxViv3lCwRXrZ1a5xM+nca8B4hlGXHwxv6uuUIs4lbcCgf84oqqGP0bwCTCkqJXC7BmjrXt237YLkSUaG+peeNDczHDaxLsbhMW3V5xnalBXa71mCcP0+gpLDSu/zJEsoTSugWN7cUYQ8+RctdFtXj7Pa2wyUMN5+W3IrZgkOvC3GECe/0GO2Z48XM96R8XGBw1HWcwZOiavYfXFbXeujCE5SsP/093XYMHHsZi/IbyO6PbmWT270NbLJkwG9oV+1LsROZ4x7qCYBKaFN2ZHdABK+aYzB03cJRCZtbXOkMYJmIN3HBef6qEAPTYglf9eFEamZAMoRoVxqDisBuBz01lwIvOAMRAmT2XBskUDH/06MJohWvnEhdRdv/00IElOwlQnwdJQPUmYA6a9cGUhQR5LrnewSqh48sRl97PPUpiaNIEVL/tIsu4mPhoBd0txDLfX7yYOM5TSpVhoE2Qjv7pHl1Lz36H
 vLXd9Aaz
 bw+l5pTtcyJGMDP+pp368g0pv3uga+U3Siq2rvYiQQbfycYpB+NvO4si3DVjeTa29KDfofgmR1EwzAC/+sf65E8DX9NzAVlWsEUrDG/qk7GR/5lEAwML18Cv3P9ZJnK6buy8r1kDW5pd74XBboOX0p9ZEZTRvoAabfnGYqAAb7+QJe+R5FWfb14gUldxp4oy+3qQT3VKqBLMwsGgJND5jtqT7AZsnBATnR4bOgXttcUwUIxiNYc2Sys88kLfnizew9yMNNUI/nlCPZBwv1M64kpWeEX8xm+PqKiuM9nhBJJ/TrMxCbZA1omOKYnqkjxzuTJC/qcfbKKM26779Zwz4WVBCxZvQdX3wtfzA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kmalloc_nolock() successfully grabs a slab object but memcg aborts
the allocation, the object is freed via __slab_free(). Calling
__slab_free() in unknown context is not allowed and can lead to a
deadlock.

Free the object via defer_free() when spinning is not allowed.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 85760c8ff2e2..4a3618e3967e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2459,7 +2459,8 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 
 #ifdef CONFIG_MEMCG
 
-static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
+static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
+				     bool allow_spin);
 
 static __fastpath_inline
 bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
@@ -2477,7 +2478,9 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
+
+		memcg_alloc_abort_single(s, *p, allow_spin);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
@@ -6436,16 +6439,20 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 #ifdef CONFIG_MEMCG
 /* Do not inline the rare memcg charging failed path into the allocation path */
 static noinline
-void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
+void memcg_alloc_abort_single(struct kmem_cache *s, void *object, bool allow_spin)
 {
 	struct slab *slab = virt_to_slab(object);
 	bool init = slab_want_init_on_free(s);
-	bool allow_spin = true;
 
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, init, false, allow_spin)))
+	if (unlikely(!slab_free_hook(s, object, init, false, allow_spin)))
+		return;
+
+	if (likely(allow_spin))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
+	else
+		defer_free(s, object);
 }
 #endif
 

-- 
2.53.0


