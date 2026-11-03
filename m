Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C7BF606B27C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O77gfe8k
Received: by kanga.kvack.org (Postfix)
	id 8059D6B05B6; Tue,  3 Nov 2026 09:48:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741796B05B8; Tue,  3 Nov 2026 09:48:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C046B05B6; Tue,  3 Nov 2026 09:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31B386B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B41A74046E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:22 +0000 (UTC)
X-FDA: 85394088444.28.0712F07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0451840005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O77gfe8k;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717301;
	b=DszSpz37VdoJnVfZWM582p0ZPmOQtIXtscHF6hk3VeKuIcXYP/aeByr9QzYHMGA3QJxdpJ
	qus8xsIea+CWERz0xGJyMQ+hFyeAkslxpOMcX3mcXm8zlo+IkogSg0B+ZBVg+UUb2MXxDZ
	2zDoyvLuoA0QYko/TODinHU3cOm6XgI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O77gfe8k;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gD+JfyFsFqSMM5CGTKNOp21IwpvoIZuhMHjwjkhQ9Y4=;
	b=RXlAlV1kW2EgoSb+Xk4gsydkXxyq2IxqW3c+majwFX7mlAvAjf96hj5QtgE5GeTuLBzo4h
	8lTqeb6gJGkAJ3seGAZqCJqmwU1peG/lmiP/ZEhXSpkFEhcIbXslaJrgnZWl8Io9rkDtGQ
	n9at/oTIuAmGkIxyVs3p3XZKY3+w9fM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AC0B609ED;
	Tue,  3 Nov 2026 14:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0324C1F00A02;
	Tue,  3 Nov 2026 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717300;
	bh=gD+JfyFsFqSMM5CGTKNOp21IwpvoIZuhMHjwjkhQ9Y4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O77gfe8kp25hNoBGGIpC6DtRiBGmJPBhWTL/hDCA5+40SPpjiLXP+1QdEzJtXYuk8
	 PGqiTX3BM5EwlBxY4d77MPivJkSwbOK9K8gWZKUCbRLj268RO5hcZWX2HEN/rpCv8m
	 IQZe8dH2k2nvGSXI6U7HnXrlw3KVT5+4UuwqNblGOLfjAktu2xrAejReS/e+4O76ml
	 uLIr3xHA+hTy6w/ig2jAXuCk0KXSr1iSqFdXByf+ozWqigWRvLaIggx4fsyICZvUXv
	 /Rpc9v4Kn8Kw3JD2ei8tFnzdFKhVulxHaMnj5Z23rw21Ynd4QIva2GCVTVPgiY2LVG
	 jaEOxNCbwa13Q==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:53 +0000
Subject: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: chkzmre551yjpw87fyrszscjgyhw66fk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0451840005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793717300-133105
X-HE-Meta: U2FsdGVkX1/6MkGAbvDYg7Z7JIYFM1oqKorvUYjPNMASDNAKqmXh5XtXD2TCsF9rFDc9m5YUglDg4+JO+nhJ6aUTF2QRT0tNNSybVLODSdg7xQL+03eEuJvSMJGAsf0nEkzUAHhhAXFdcc0xZGyXIOJywn1oO7ftdmnUULnt5iXPxk1/FzIqsSO1rUGSGPlPOpqac7va3c2E6f5tKWlgOUfjhCExwhOhJILJhhWUrzEzbrzl1q6Vp9NYFdWqJJlDSLaQsbVfACmdE8LxDJjY85qXhkCJt8RTpFjLhw9Z8DY3kq8jSbHPd+jyAdr9uWepv/McWrvihGZrzZI/Hk51kH2iV58ieZtvjlQICWc4xHbaIFBH4no5QjOm0PNXy+Q0Hsxsp6L9TbXpaHs7AvyVYlXWwAptOYvQhODtqIThcrsEadRXop7DUjU9jWsvyVuvcX72XkwQ5TzsZ0pE9bUZeXB0UypoBepM5ei7xs2bAZa+CTcj+PYIeq8hnC9cK7kqxc2h2mlhp9B7AHyGqwZnVCVMsgY4G00dLMejrYaFITRoe3UxLBT4rOoJn7h+KlR7VZTL1hBqT1w7aG3WuiVdWC+NXAy71Pm4OhTt6DDZfSWd0HeqKoSZAJut9O1CntJYpT6Sxh9IUVnXZ9uG1yUdBkn1KJ0P8pBywZhggal+amgIxFjMKeaqPEMN6nouL9S+uIRe8CVNOklgz5OMQPx98L7DyRzIDk5qnjbB2AzLnZ9ZogOGO7EGE3ClW8m20la/kYwxrvjCuZmP6wSlShmjdHarsCsNzV1HzlXfEaN5T90WIMqc1ayLa5VdRNaSrcMRFpOf/lm09q7tnIEtvuL4xnWcgSgkMg8G56USuHfQswdMO0fJyQ/4o/NC7uoMq/Xp1TUQrOFnfN1poMCGwCbVT6rsoyAaqDCcLy7JftOUIqfuzK5GVurL9hwUBZmLsACtbZh+YSShh7yumpudhrI
 qRhT1Ps2
 r6yqL6pODu6UUeD5aQo30AKwqHqA3YfgXNTialNt69gnhdzeA2nO+cLTorqtqkXX6i5MCC6UdXOb72Y/uxTRvxNRVJvSh2ir/Dtr0YGJ+y0Y0ITA1Qn/4joUhp6FGqj4T5WfJbZpsZmV1Y4bLPfeEuMCOmw1r6A9L2HCfuxuGLIsEhC3uk/Q4AAQYWNyh918VEW3kSrbyjrknnINTx0qiIn57k2LWO+DKBGubKnytVvsTZstY+rjiHabvC21qIaham6CYSYed0i4DqTYmyImR9P/X9+qOiqCyYY7m71cGJ4rjpbZkBs0xhF1MwaZnDxQD9k5ZOc2oFYAHlg3r6AZvyVfqgrMo66fg1TR3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When kmalloc_nolock() successfully grabs a slab object but memcg aborts
the allocation, the object is freed via __slab_free(). Calling
__slab_free() in unknown context is not allowed and can lead to a
deadlock.

Free the object via defer_free() when spinning is not allowed.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 48415f24e115..6dfa8ca3c937 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2533,7 +2533,8 @@ static inline void slab_obj_ext_has_codetag_init(void)
 
 #ifdef CONFIG_MEMCG
 
-static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
+static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
+				     bool allow_spin);
 
 static __fastpath_inline
 bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
@@ -2551,7 +2552,9 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
+
+		memcg_alloc_abort_single(s, *p, allow_spin);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
@@ -6663,16 +6666,20 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
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
2.54.0


