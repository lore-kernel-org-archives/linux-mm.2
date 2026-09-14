Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 502FDC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 22:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07376B0095; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4296B0099; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E416B0096; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62D3F6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:32:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A73A80285
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:32:22 +0000 (UTC)
X-FDA: 85213817724.25.F14C88D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C888120003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:32:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nRlV+Ypv;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789425140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ps1Pf9HY55XJc6hUxZI1FWG+aZ4DlvyxQbmpujBPK50=;
	b=aVDUOAxvmCblphvuV7BDHBSQwlJdWka3x34FyFYI/Znoo9SLKEqInbpeZN6JYGE1kReShS
	sShYPxZO3gBIzeCT+SyTNt1H525bXWCo6CCbRhRcY/zq3rYgPCEKJF/Lf0uCCseTjUynN2
	7ZVHhy1rq6ISgAE+8WakxLMHg/Zgk/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789425140;
	b=Hk1boH5JzoAAsbvEFtJVHq17ag3rAXzVmAFObycWlojDzMxqYj5dnpLeG+TV3JRphHSuGb
	geN3vVPHO3/1yJoH7s2DDVPk6vFsYAeIeLGET+JZV9ItWeCxMxkntoC1O7m1ChqfBCFbBm
	ZTE+OJqrlSjWfhFyJ44uvG+zQoRtWZU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nRlV+Ypv;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3E9C43F76;
	Mon, 14 Sep 2026 22:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726D81F00898;
	Mon, 14 Sep 2026 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789425139;
	bh=Ps1Pf9HY55XJc6hUxZI1FWG+aZ4DlvyxQbmpujBPK50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRlV+YpvxHQVtVRWHIbygpj+OZVvjJfHQQnKrKTOJhBpvRhGTy4ZjBujWyve0WKGA
	 w435enXlS2HHNW1DJmrDvB02MD6uRMC6FSFxadfIWa4zRR51XZvQaQIMcvWDnDANdK
	 t6MJ+Lyt4Agr05qu9eBxp3Rnm5l6crb30IfsRXAQZzW6+6Lkipmre5C0QlWeXisZfk
	 8GjeaR5kxEVJ3pl+ciP2lL9/G5ZTVB3ItA5KJXcFFls+TjRVi0i9raU19+EJQaJ8va
	 4j2eI+QyO/ZBjqiE7S4f+jixrGcNW+DqjWKSXbZULTLTyuTiEciTjWbik/faUHtNBt
	 juvas0SA0gB0g==
From: Kees Cook <kees@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	driver-core@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for devm_kmalloc
Date: Mon, 14 Sep 2026 15:32:17 -0700
Message-Id: <20260914223219.901347-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260914223212.i.829-kees@kernel.org>
References: <20260914223212.i.829-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5602; i=kees@kernel.org; h=from:subject; bh=bLnfQpX9WteOicTADYo7gVjLmdCzHpRn4PMQO2GTuCM=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkrSj8WbJVbIJ/P8uXHLbbr6tu0z805uPEx7//mnV9eT GtRNGZ72FHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjCRpTMZGZ7Vnl9ktbGh5Md7 u7/cSyXbtJLZ7+UYRtnb/53SLrJg6QSG/8XWj8wN7068lWp5hqnkg7LBmYTp7plVikKWzI0Vkz/ asgMA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C888120003
X-Stat-Signature: w65eebzuwc6gxmnx8e6hxc7jjffmogym
X-Rspam-User: 
X-HE-Tag: 1789425140-670569
X-HE-Meta: U2FsdGVkX19tkMkgjXZeRShQDM2eAIPjIpxiH4n+JRVatiQOYkW7iE3kqNzaRm4vzvt82U3jpdAPHKczpduq7D0YjAWRnzaIY17LXmsPP2S9s3/ZvPB4RFUYo/AXaSp2668ABH+B7i52i0UzfyLdrProoJEUmAJ+mfzprnENKrtU5PzYdeHHqjSdcHumgxl9tIIpHSiOZMpz4JayW/8mWLrALoQu/BwWGwckYRePy55SXjnPlHfTV/2jFHhyHTwOGRKyDaDaZq/HeNinYnGj+abHimWNdJCvPNOXmGtwUoWnJ/+oAZy2zEhtjs1OaqwizL69e6lmdbgm8imkB5wO+sYwchRmCSFHTlGORys2PEFMMCZjk9t8IclQymo3hwHmQad/zaPHrDm2U8v24t06un+koDXeX7NXRbeRVuHHGIj8AGSQSTto6kNp99eP5dc/F0dDxUDWs19b32OaeKwWmToe1P/DszcQ3opZ3aKkDhgsGRZ7PfJjT1s/DanZ4AknJl4ogUtpylBrvk/MPJgs8XYkfpVMJprPwp9cY/XOwlccw2v3+Sym7HNiD8rmz8Hi8f6Rd+vRRQ69ZPiDgD0sNYaEt+DDFeqzV1H9pnOzGLjfallYUxjQJQlSbGgJRD/MUoVNlGylDvlnY+l2m6Eo457LmE9bKJQf10vXwbxkyv/PhrQn9LdYA2Ij2pal4ctGEdDRvoToeZny0MwxQMfy9EkOTMI0zbVWLHQB879y2NNLRtidCHQj5GBXZkL3mV7ACEaFvLbX1arjSYkY9WnTE3N7jB/+4JWLwONMdcX0tn1MTapZXKWoGTPvnDgpqK/xPjIKgvcDm8Fm9zL0kN5osOLsEUB6kUbnXGOCRPWtlttJXZZVsO2fuANDuK3OBWrMlD5Xa4LsHw2plMlWTf4ouvXmhVxkXdeMOnkTHMqLM0Cgw6aSTmAPwlKOvky3+DGLGxRjInYTky0tn8BNlCY
 q0V+Hr9f
 7zzh2UpU6Wiy1XyJQBOHjzLlhGYztes5xa/+i0LfKueTzsHhWc9LKo2erMBO8OXYWTsurHuD6m4RaJWJ8GyLAXb81z7+JJEaUkx29onzHTHf0pybC1dLUSnVdYsPxULHmzTHHKFVxjS2mx3A3ZC7bFkLbZuGGmIRndxr+L86LF9lAqxCX6o0mns0p5QkXkN7iJS3J7+qBHzU16u+pnfNssMjQP9B8uVAw0ijTO5QHlj3/kFX+Nt5qtbYa4LSqVaQ4AJgYawZCeoJ+1qBqFq9k4g4UvRptvmRS+H48ORxH9WEDWKZdV6nch7ELzv/CVEtHW1MmZXmECirR9pUxKEkoGTcHNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mirroring the type-based allocation now in use for the kmalloc family of
APIs, provide the same for the devm_kmalloc family of APIs. This will
allow for future plumbing of type information (e.g. alignment) into the
underlying allocations. This immediately gains type check on return
values (instead of the prior "void *" return type).

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: <driver-core@lists.linux.dev>
Cc: <linux-hardening@vger.kernel.org>
---
 include/linux/device/devres.h | 102 ++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/include/linux/device/devres.h b/include/linux/device/devres.h
index 14ab9159bdda..7656c9ecd4da 100644
--- a/include/linux/device/devres.h
+++ b/include/linux/device/devres.h
@@ -62,6 +62,108 @@ static inline void *devm_kcalloc(struct device *dev, size_t n, size_t size, gfp_
 {
 	return devm_kmalloc_array(dev, n, size, flags | __GFP_ZERO);
 }
+
+/**
+ * __devm_alloc_objs - Device-managed allocation of objects of a given type
+ * @DEVM_ALLOC: which device-managed size-based allocator to use.
+ * @DEV: device to scope the allocation lifetime to.
+ * @GFP: GFP flags for the allocation.
+ * @TYPE: type to allocate space for.
+ * @COUNT: how many @TYPE objects to allocate.
+ *
+ * Device-managed counterpart of __alloc_objs().
+ * @DEVM_ALLOC takes (@DEV, size, gfp).
+ *
+ * Returns: Newly allocated pointer to (first) @TYPE of @COUNT-many allocated
+ * @TYPE objects, or NULL on failure.
+ */
+#define __devm_alloc_objs(DEVM_ALLOC, DEV, GFP, TYPE, COUNT)		\
+({									\
+	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
+	(TYPE *)DEVM_ALLOC(DEV, __obj_size, GFP);			\
+})
+
+/**
+ * devm_kmalloc_obj - Device-managed allocation of a single typed object
+ * @DEV: Device to scope the allocation lifetime to.
+ * @VAR_OR_TYPE: Variable or type to allocate.
+ * @GFP: Optional GFP flags (defaults to %GFP_KERNEL).
+ *
+ * Device-managed counterpart of kmalloc_obj(): the allocation is sized from
+ * @VAR_OR_TYPE and returned as a pointer to that type, not void *.
+ *
+ * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL on
+ * failure.
+ */
+#define devm_kmalloc_obj(DEV, VAR_OR_TYPE, ...)				\
+	__devm_alloc_objs(devm_kmalloc, DEV, default_gfp(__VA_ARGS__),	\
+			  typeof(VAR_OR_TYPE), 1)
+
+/**
+ * devm_kmalloc_objs - Device-managed allocation of an array of a typed object
+ * @DEV: Device to scope the allocation lifetime to.
+ * @VAR_OR_TYPE: Variable or type to allocate an array of.
+ * @COUNT: How many elements in the array.
+ * @GFP: Optional GFP flags (defaults to %GFP_KERNEL).
+ *
+ * Returns: newly allocated pointer to an array of @VAR_OR_TYPE on success, or
+ * NULL on failure (including when the total size overflows).
+ */
+#define devm_kmalloc_objs(DEV, VAR_OR_TYPE, COUNT, ...) \
+	__devm_alloc_objs(devm_kmalloc, DEV, default_gfp(__VA_ARGS__), \
+			  typeof(VAR_OR_TYPE), COUNT)
+
+/**
+ * __devm_alloc_flex - Device-managed allocation of a trailing-flex-array object
+ * @DEVM_ALLOC: which device-managed allocator to use.
+ * @DEV: device to scope the allocation lifetime to.
+ * @GFP: GFP flags for the allocation.
+ * @TYPE: type of structure to allocate space for.
+ * @FAM: name of the flexible array member of @TYPE.
+ * @COUNT: how many @FAM elements to allocate space for.
+ *
+ * Device-managed counterpart of __alloc_flex().
+ * @DEVM_ALLOC takes (@DEV, size, gfp).
+ *
+ * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing @FAM
+ * elements, or NULL on failure.
+ */
+#define __devm_alloc_flex(DEVM_ALLOC, DEV, GFP, TYPE, FAM, COUNT)	\
+({									\
+	const size_t __count = (COUNT);					\
+	const size_t __obj_size = struct_size_t(TYPE, FAM, __count);	\
+	TYPE *__obj_ptr = DEVM_ALLOC(DEV, __obj_size, GFP);		\
+	if (__obj_ptr)							\
+		__set_flex_counter(__obj_ptr->FAM, __count);		\
+	__obj_ptr;							\
+})
+
+/**
+ * devm_kmalloc_flex - Device-managed allocation of a flexible-array structure
+ * @DEV: Device to scope the allocation lifetime to.
+ * @VAR_OR_TYPE: Variable or type to allocate (with its flexible array).
+ * @FAM: The name of the flexible array member of the structure.
+ * @COUNT: How many flexible array member elements to allocate.
+ * @GFP: Optional GFP flags (defaults to %GFP_KERNEL).
+ *
+ * Returns: newly allocated pointer to @VAR_OR_TYPE on success, or NULL on
+ * failure. If @FAM has been annotated with __counted_by(), its counter is set
+ * to @COUNT.
+ */
+#define devm_kmalloc_flex(DEV, VAR_OR_TYPE, FAM, COUNT, ...) \
+	__devm_alloc_flex(devm_kmalloc, DEV, default_gfp(__VA_ARGS__), \
+			  typeof(VAR_OR_TYPE), FAM, COUNT)
+
+/* All devm_kzalloc aliases for devm_kmalloc_(obj|objs|flex). */
+#define devm_kzalloc_obj(DEV, P, ...) \
+	__devm_alloc_objs(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), typeof(P), 1)
+#define devm_kzalloc_objs(DEV, P, COUNT, ...) \
+	__devm_alloc_objs(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), \
+			  typeof(P), COUNT)
+#define devm_kzalloc_flex(DEV, P, FAM, COUNT, ...) \
+	__devm_alloc_flex(devm_kzalloc, DEV, default_gfp(__VA_ARGS__), \
+			  typeof(P), FAM, COUNT)
+
 static inline __realloc_size(3, 4) void * __must_check
 devm_krealloc_array(struct device *dev, void *p, size_t new_n, size_t new_size, gfp_t flags)
 {
-- 
2.34.1


