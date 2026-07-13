Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABECEC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F334D6B0169; Mon, 13 Jul 2026 12:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3DC6B016B; Mon, 13 Jul 2026 12:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21106B016C; Mon, 13 Jul 2026 12:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B68026B0169
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:58:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7378FC0E36
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:29:17 +0000 (UTC)
X-FDA: 84983985954.20.9B88E31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C424D1A0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:29:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEQmqES1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1wi/OOk6iyYw3fd8OIurB+6r9k/Y8S3vhngrBwnEdq4=;
	b=lV35CVJ9Opd4eYKGS41VcABb/hT2yanyaaovEpk7C7t34DdClz60fyPqVBZMBp53AV1xWM
	EOV1zj4tviDd4JKc6ShhN4V8EZ4uo+B7VmC4O7nuYKp3OWaohadXkuZabY4tbm32ryCKnD
	gwo+GyQrkqI4sDLUB1w5xItIUXrgVj4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEQmqES1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952955;
	b=CroCOSWvyMaHi/x3Q0B81vWI2r5UOAKZ8QUqjA6MvZBA2gffjkq2BiOtnyhA9VF69Mkk+P
	jXDuxU+6NgPO0M/MmNBUmNY2Cd8tLG1w4We1ghvpiXG0v07v+TEsSUObQ7dKxyIKD6l15B
	S3vbo3NREkGujaS4raslB/3YLTJ8gt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15F72407DA;
	Mon, 13 Jul 2026 14:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768411F00A3A;
	Mon, 13 Jul 2026 14:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783952955;
	bh=1wi/OOk6iyYw3fd8OIurB+6r9k/Y8S3vhngrBwnEdq4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LEQmqES12IM7BZYGacYv5CkjZGspMkqnLIom6M+NjntyYlJdl+QmrQSBCnIMDwraJ
	 HIkc/SfwOyoxNJY3jNzXF2rIJPxUqe5gzty/+ey68UhtmgvthyIRA8PhjTWWvIMk+5
	 DHaVAiTwOGrDO57KH3f62eALuJeGz6lIICfiuxD6gKWFHIsBt0QYs0Rh9bYPVrY3Xj
	 XWBcsfYxfAGSm2a03xVW9WGQg5c+rp7XJUVbdfUETtHhg8DKhF3q+IYLYTOj1QMJhh
	 /3/gUfgw/r76Vh+cVLREKvrG+Dx6C7FYdaeBz4deKREOInQgxxcV4QOnfrBOcE6I6r
	 DGfbRxALVxyDw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 13 Jul 2026 23:28:51 +0900
Subject: [PATCH slab/for-next-fixes v3 3/4] lib/alloc_tag: introduce
 mem_alloc_profiling_permanently_disabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org>
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
In-Reply-To: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Danielle Constantino <dcostantino@meta.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C424D1A0009
X-Stat-Signature: 5mfqajxahmzejycw6utoqymdjseuwne7
X-HE-Tag: 1783952955-705165
X-HE-Meta: U2FsdGVkX186etZyaIKx2UWpHwWWjHztN/gASF8xVx8lVF/zltWRWy+uCXngMnfhWR8Yq+bxcI841XGWntz7OcQUA0PCORKTfhZh6bQUA33koautHQ44gaw0e9D/Zqn74/03oTR0gmIRW781c52xqCqy0ncAr/ZKWIINkf3StTUgIysP79jj2ZqErxKfRfY6/0H1lKjYga+mm0aadRDe98FeQ+q0+O0fPhQiIa8UwfqcPPVzKhhD46ueGkRY7dUp0YuE3ZPEZ9KHPEl5Jjt9lei+O/o+zN3FT7WbUEUXrKjsW11z33kwyxOpAId5cem6Oi6Q8MaSDxUTMU282fAMoRtuco9u8kIHciQHUyF31xfKaExzKEYUlVJR9AZXMuJLH2/OOntnAx6eVo2d+eWQH9f2h0s6HQhYxUaYB6POwlgJWoZkqC2QiLZiQa4KTaKVwTP6NaEMpgjYQrfy9HNHwKAMI933Pp+Cm3ptq9tC62gSp3zm2W1hvfc2mezU9+OihGSfvLEdFsUTMslHDDf5HPvSMo1RwJxl10xtxrvus7gmxru31SvI7muZoMLv359XfwaQdOfXnXa+rPqN2GVf1Aqydo4FdN3mBi9srh3RiIiROpOolLLOhtuEqX2L97EEPZ/s0NAJSKxksx+IJG7D5ypKxildsLrhh3O7TX3GfXulrvYeWdqZ8kZ+LKiwq94QUvaafnSzCvqtpDS7dxmd88ga1r49cWX5DOL3JhYQYf1jhuH49VZF76JgyYQeoftuqgh/Hna5F6889K+FCzbTZxrHdxR/1vo3u3mCFv9hL1xQ9lM31OVxcBA+GGQWqsBTlcfviO84KxjynQmTPxJ7aBEV2mEiMaYrjmyOjh3ROXAaZsF6gvpTDKMWDCyoPQkzZTtZjJYXC8yl2WK032BTkb7DaetOnuMsm/vATG4EfWJBnNg0Y/2wKqOpNzXiI2lUaBjmJ0CCshSOvaGySeB
 fWRGDw6z
 GILufr+D/7VN3qzQt3pPNBf1VsSdWK+n2e7VNK20b4RGPUhrtVOhk8rruu/oTum3bvs7XnNHBl2INfpLielzXP4DSXnFSx6trS6Bs1cmZANDoqyXvMja+yBfmK1hOf+ZcwcvcuoIBVm3UBY5D7hUfzuMOPCkN6Jcn55A6q2vlIW7Rxecf4fi+G8o03+HZMzR6pnJQCAbXQgd+EPb3jkwdKgwy/Ahclmu8apSGCaK/vNLY/lUHzElaNIfNvoY/eQYCR2s/we2QsGB+pMWcqLHxIe7t8DdfDYjLT18O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_alloc_profiling_enabled() tells whether memalloc profiling is
currently enabled. However, even when this function returns false,
it can be enabled later.

However, this is not enough. Some optimizations can be applied only when
memalloc profiling is permanently disabled. For example, to skip the
creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling must
be set to "never", "0" w/ debugging on, or have been shutdown so that
it can no longer be enabled.

Introduce mem_alloc_profiling_permanently_disabled() for this purpose.

Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/alloc_tag.h | 3 +++
 lib/alloc_tag.c           | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 068ba2e77c5d..6ed9f82e639f 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -134,6 +134,8 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
+bool mem_alloc_profiling_permanently_disabled(void);
+
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 {
 	struct alloc_tag_counters v = { 0, 0 };
@@ -239,6 +241,7 @@ static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
+static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index d9be1cf5187d..e5b218176c5a 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -26,6 +26,15 @@ static bool mem_profiling_support = true;
 static bool mem_profiling_support;
 #endif
 
+/*
+ * Memory allocation profiling is permanently disabled and cannot be enabled.
+ * Must be called after setup_early_mem_profiling().
+ */
+bool mem_alloc_profiling_permanently_disabled(void)
+{
+	return !mem_profiling_support;
+}
+
 static struct codetag_type *alloc_tag_cttype;
 
 #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU

-- 
2.53.0


