Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E32CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F046B00A6; Fri, 22 May 2026 09:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5C36B00A7; Fri, 22 May 2026 09:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F8E6B00A8; Fri, 22 May 2026 09:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7B26B00A6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:39:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E88C4090B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:44 +0000 (UTC)
X-FDA: 84795163488.13.48206D1
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf14.hostedemail.com (Postfix) with ESMTP id 32B7A100009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:39:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=rnwBrPQl;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="r XJfRNL";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779457182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apb55LlMDEBM2szOAEFKpKJCzTbXU9G5gULUrddwYm8=;
	b=JT35IzAFVZyjF7qGrqw/Q/u2oVYgDVirGPqixGRNXCmjaoJ+az1npQfH6VWWo/lpYi81fV
	Nnxc5G5t6ljK4QcgVCdtyr/invsOXDz9BIWetCzUzgjB7e2HYwD9d4w4tRB4dUe+MxIMYZ
	LFqnwDwvOBLN2Q/qyG/cKLh1bVjuTd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779457182; a=rsa-sha256;
	cv=none;
	b=yJnCK22YkbC1cSz9g3a6vqDBPXVrXYksPHz5Gl2WsP5QfyNFe2XBmznizIYwYa6uWo9m9U
	QB7tvFi+3m4l9k++MheZ+Lbc0Vy8RcoGVxJ9/ErhjLFH5/EVZvxIas/t5pbOXxRXOXEmg4
	o73LzAsbqLBsSqMYfiOhr40dhjIJEEQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=rnwBrPQl;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="r XJfRNL";
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id D9FE11D00126;
	Fri, 22 May 2026 09:39:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Fri, 22 May 2026 09:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779457180; x=1779543580; bh=apb55LlMDEBM2szOAEFKpKJCzTbXU9G5
	gULUrddwYm8=; b=rnwBrPQlRTmnXYUYbPLj1AeZcPThyJBEYmqSMB+P/KHVqrD8
	3qZZPFhINhZ0QJGQj4fDkqB7AWmMMlad9yZ6mxkpcxuYydR5P3TIwBBSdBV5JiNp
	Z6o7sIw8haZGLEDoP2RNnkZH78voKVoDX1DPfTNPH2OaRXd/gtQ0vOBdF98sSA05
	5QJNYNgXnx40bS5eKV3QtdrMNx2hJnXeshOhCb46Zw6Nc4tvhEaIXojYrVVwIjo5
	D6WvUXNI6nDLdMIb3cekp5CQZbJzcfze0i503C7qEvcZ4C0Su4ibAevZg+gpXAMv
	tm/lc8/Ds3RzCqpbYhJYZFlOPCdYd+uGDBxrGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779457180; x=
	1779543580; bh=apb55LlMDEBM2szOAEFKpKJCzTbXU9G5gULUrddwYm8=; b=r
	XJfRNLq86D7SHLL/fE1ClibStuFy934sS/rA2jO3i16OuVINFZ9sS9FWMDyaFFN6
	SNUhRCDi8NxwqHWERtGNh7rIvb0Tm3whVOCdbSv4ruCK4yf2WULMa61KmG4vuID3
	uohFOAOSv7aVIIoHlSRIvfT4LuhYF/CBSKfdhmZyQpOIF/1Kdk10VaDbO+l8uS+O
	g+t67B2Lr/iQyaM+Tw67rdcx7KPxPwPSlkdqWpxXdILUxyI7uKkyl24RBXho4H87
	H27NRs4xlX9XrZnZsJkU6H+gGy/6oWFtv2zpZQyW3TLgFVqkLPwHZrZZS4sPP9v6
	s72FMCTTkLECtmv4uw3RA==
X-ME-Sender: <xms:nFwQap2tsyvTeOg3eh3Ob8G2eW3Vz8VPIUWQ4ICeSndBndoD2acB_w>
    <xme:nFwQahKx6COcwiugmQnbI4QZ2TSFg2X8fpKcbPwgy7XnDg2da6lqTDDx_6ohhq2nK
    vn8KIozGcr_1Y9ByUjgJmyetxa01palyfMbWg9LmNVBDwVeHDdyEHQ>
X-ME-Received: <xmr:nFwQas1lSWho2yaZTMopIEH10f1a9fNwHZfr-u0qGfZlvUKuZpJNkXGkz7MUmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduhedtfeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfgggtgfesthekre
    dtredtjeenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkihhrihhllhes
    shhhuhhtvghmohhvrdhnrghmvgeqnecuggftrfgrthhtvghrnhepteefveejgeffleefff
    egiedtieegiedugeekudehtedvjeetvdegieeikefffeevnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopedviedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvggu
    hhgrthdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehljhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghho
    ohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthht
    ohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:nFwQakjMjEq_iuCsIY_T3gixbSB0Ui32cHPPa6Qyu6dO9WpIzxPKXA>
    <xmx:nFwQak1mLB7jdbbEgKigFhJHZjRsYGjxyO4CGK6-esTKdYW_Ws_tdQ>
    <xmx:nFwQandVETyaDA-R6dOJ4YDjIoxse_56pMOg3Bj54mWOKRWVUmv0Zg>
    <xmx:nFwQavGlokwwhrVcohzZiFoR96cixz4gfIIQPPZr-YLgc7LCg7r9pw>
    <xmx:nFwQapodcyO4HmAb89xWGC284uBSf1-_ZMwi4jMLMJhUglqeddEFyaKa>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 May 2026 09:39:39 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	linux-man@vger.kernel.org,
	alx@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v3 11/16] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
Date: Fri, 22 May 2026 14:38:52 +0100
Message-ID: <20260522133857.552279-12-kirill@shutemov.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522133857.552279-1-kirill@shutemov.name>
References: <20260522133857.552279-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32B7A100009
X-Stat-Signature: xbqmbbwzmowxtt6tkwwx6qrre33gpahg
X-Rspam-User: 
X-HE-Tag: 1779457182-591825
X-HE-Meta: U2FsdGVkX19JnuE9acf5azU1IrqNJPE7zOkTqfRs+4SKkwM9F9ptuDwUhkTgOgvubgMkV11IAMjykEdLKdxx2tJzUO+HSkOC7XoxYjDztfFK2WY0ZeD8maGSw3tfj03drupB8HkOSP2GNiGb6ZpNcHrBsbC9BQ6ywIjRl4SF5CkvKHXeEIao7wNQcWqP37+iWiNUpCcOEu8bgX/JS2oJkyE7bvllqZ0YAuAUWM/gy/7HhqqWzydVxKYcR0DSJE5dnha4Ry7EMoFZW/e7ElCyLRWi3iHgUovZ8YcC/VqM1dQrdSYaSHOk30nXwlQwy1ZraBHvVsClLUJJVjftdSSNBdOmU9fC2ZX7QBjLkrRMtrxGw5n1FxtFbBp+AHIAKaIv/xTvlrPJSkmguEPhkEO4yUY0LGXjiUgpHCdyggXkUvDyXZIAdG2Df+LMSTLtNv+XEvGAS0GBTh8EqIY57k2BSRgnin+1CGd5GMY/kELXZShnZ1Cv3k5oTL6dCmmBJcidcjXveWFTEIMKrUO+mBJ6JpzLikp9KBXb+LlAlITCXHz+xFcGw0Q/JBj2vejY2fcXU5CTpcLY1+cW15BRA6IjO26NTI5D1shZmUkfNOtSShsI5RP2or7IbsxbuO14WpLADEUSVOH8IaFtYMFQ8SUJPpO0pi+nUmITBY5yYQUpIfvtU2V6PQllBq4iPZcX4fYWXQiqAQuEfYO9NqiTOxbqA0UbnJeN5HHN6QuVtii2zjKkB7KPsmBDnu+5YDpDeInmd5YGaLbGVttbWlrbgwc9FBVeo/336mYQpK2x0J4XN6HYhemsiW9TZiNTqmhDdSTN1QtfnlJBElGz+17MPk70eps/bt0BN+8O/UnRvr7Uc+GGAbpxUm1/19QSuv1G1eupKoRO908tLfW1ubrcYj/60JQS1WB6Bkn00VSqEFSoI1k0qC4u75ndDGcHJ+dubNjGCvbIWHYS00Ee73MN1VH
 tUtRv6Yx
 6IwqA1rAL+l0F5KOStYb5bk0MlUCatP2drHXC2GNfrKcK0bvmaUAep19k+JFdHaroPJSCfPYs0/8Lo8tqcMNJZy+E3pMHxW+VkIKEeWeUZ7/I391WuCifKit4JCqVZvZAYODFT1jj779++CWy44iq6iPGLgBFkUrzAKyNMoKQUIHymW+7GYgnbVKCuWtj+SmAQUMLYKYu+X6N58Xk+xCGvxeEhLUJoW1WfLkqyTM7QBTgiW0E/GzuhcZCxlrMbAm7250FLDRW1qtVJ/3A2fWjYATzDwFmFMu3FTVuf+STeQ3DGnZSr85sBrt7zNlapA+xWg+n/fZ5MN4y5f7Ku2uPVhC98Q/AhZKp5ni+fi8fOUsL4svOVKVhVxayzBl+U+mqNEeeLvyjkK6J5JeiFGAS7omIIzy7pTo5wQ4Rda9g4UJBRVraIhGJJhyFR6Tft79Bus3bF39tsGIGb7H8o9BUjqSfbTB+fNUX+qfr21QOnply13xUnQq8bnWLTIFhO9HCBFLxNeuWibnPOXMgE70PM6oeWbKVMQIAW4IqFKX7YA51g50lQQb/EIE4Lp7sdV3GO8El
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Sync RWP delivers a message and blocks the faulting thread until the
handler resolves the fault. For working-set tracking the VMM does not
need the message: it just needs to know, at scan time, which pages
were touched. Async RWP serves that use case — the kernel restores
access in-place and the faulting thread continues without blocking.

The VMM reconstructs the access pattern after the fact via
PAGEMAP_SCAN: pages whose uffd bit is still set (inverted
PAGE_IS_ACCESSED) were not re-accessed since the last RWP cycle.

Worth calling out: async resolution upgrades writable private anon
PTEs via pte_mkwrite() when can_change_pte_writable() allows, mirroring
do_numa_page(). Without it, every re-access of an RWP'd writable page
would COW-fault a second time.

UFFD_FEATURE_RWP_ASYNC requires UFFD_FEATURE_RWP.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/userfaultfd.c                 | 19 ++++++++++++++++++-
 include/linux/userfaultfd_k.h    |  6 ++++++
 include/uapi/linux/userfaultfd.h | 11 ++++++++++-
 mm/huge_memory.c                 | 25 ++++++++++++++++++++++++-
 mm/hugetlb.c                     | 32 +++++++++++++++++++++++++++++++-
 mm/memory.c                      | 27 +++++++++++++++++++++++++--
 6 files changed, 114 insertions(+), 6 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index f8f1619f5183..bb0ea60dc3e6 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -89,6 +89,11 @@ static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
 	return ctx && (ctx->features & UFFD_FEATURE_WP_ASYNC);
 }
 
+static bool userfaultfd_rwp_async_ctx(struct userfaultfd_ctx *ctx)
+{
+	return ctx && (ctx->features & UFFD_FEATURE_RWP_ASYNC);
+}
+
 /*
  * Whether WP_UNPOPULATED is enabled on the uffd context.  It is only
  * meaningful when userfaultfd_wp()==true on the vma and when it's
@@ -1988,6 +1993,11 @@ bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return userfaultfd_wp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
 }
 
+bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return userfaultfd_rwp_async_ctx(vma->vm_userfaultfd_ctx.ctx);
+}
+
 static inline unsigned int uffd_ctx_features(__u64 user_features)
 {
 	/*
@@ -2091,6 +2101,12 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	if (features & UFFD_FEATURE_WP_ASYNC)
 		features |= UFFD_FEATURE_WP_UNPOPULATED;
 
+	ret = -EINVAL;
+	/* RWP_ASYNC requires RWP */
+	if ((features & UFFD_FEATURE_RWP_ASYNC) &&
+	    !(features & UFFD_FEATURE_RWP))
+		goto err_out;
+
 	/* report all available features and ioctls to userland */
 	uffdio_api.features = UFFD_API_FEATURES;
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
@@ -2113,7 +2129,8 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 	 * but not actually usable.
 	 */
 	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
-		uffdio_api.features &= ~UFFD_FEATURE_RWP;
+		uffdio_api.features &=
+			~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 1beae4f2f479..4fd2a5ff3064 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -295,6 +295,7 @@ extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
+extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
 
 void userfaultfd_reset_ctx(struct vm_area_struct *vma);
 
@@ -492,6 +493,11 @@ static inline bool userfaultfd_wp_async(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_rwp_async(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index d803e76d47ad..c10f08f8a618 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -44,7 +44,8 @@
 			   UFFD_FEATURE_POISON |		\
 			   UFFD_FEATURE_WP_ASYNC |		\
 			   UFFD_FEATURE_MOVE |			\
-			   UFFD_FEATURE_RWP)
+			   UFFD_FEATURE_RWP |			\
+			   UFFD_FEATURE_RWP_ASYNC)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -243,6 +244,13 @@ struct uffdio_api {
 	 * UFFDIO_REGISTER_MODE_RWP for read-write protection tracking.
 	 * Pages are made inaccessible via UFFDIO_RWPROTECT and faults
 	 * are delivered when the pages are re-accessed.
+	 *
+	 * UFFD_FEATURE_RWP_ASYNC indicates asynchronous mode for
+	 * UFFDIO_REGISTER_MODE_RWP.  When set, faults on read-write
+	 * protected pages are auto-resolved by the kernel (PTE
+	 * permissions restored immediately) without delivering a message
+	 * to the userfaultfd handler.  Use PAGEMAP_SCAN with inverted
+	 * PAGE_IS_ACCESSED to find pages that were not re-accessed.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -262,6 +270,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
 #define UFFD_FEATURE_MOVE			(1<<16)
 #define UFFD_FEATURE_RWP			(1<<17)
+#define UFFD_FEATURE_RWP_ASYNC			(1<<18)
 	__u64 features;
 
 	__u64 ioctls;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 76ca0fbaa802..985eb4e2b5c0 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2266,7 +2266,30 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 
 vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
 {
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	struct vm_area_struct *vma = vmf->vma;
+	pmd_t pmd;
+
+	if (!userfaultfd_rwp_async(vma))
+		return handle_userfault(vmf, VM_UFFD_RWP);
+
+	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
+		spin_unlock(vmf->ptl);
+		return 0;
+	}
+	pmd = pmd_modify(vmf->orig_pmd, vma->vm_page_prot);
+	/* pmd_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pmd = pmd_clear_uffd(pmd);
+	pmd = pmd_mkyoung(pmd);
+	if (!pmd_write(pmd) &&
+	    vma_wants_manual_pte_write_upgrade(vma) &&
+	    can_change_pmd_writable(vma, vmf->address, pmd))
+		pmd = pmd_mkwrite(pmd, vma);
+	set_pmd_at(vma->vm_mm, vmf->address & HPAGE_PMD_MASK,
+		   vmf->pmd, pmd);
+	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
+	spin_unlock(vmf->ptl);
+	return 0;
 }
 
 /* NUMA hinting page fault entry point for trans huge pmds */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9fc31cbcba4b..84ed3784e3a0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6075,7 +6075,37 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 */
 	if (pte_protnone(vmf.orig_pte) && vma_is_accessible(vma) &&
 	    userfaultfd_rwp(vma) && huge_pte_uffd(vmf.orig_pte)) {
-		return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+		spinlock_t *ptl;
+		pte_t pte;
+
+		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
+		if (!userfaultfd_rwp_async(vma))
+			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
+
+		ptl = huge_pte_lock(h, mm, vmf.pte);
+		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
+		if (pte_protnone(pte) && huge_pte_uffd(pte)) {
+			unsigned int shift = huge_page_shift(h);
+
+			pte = huge_pte_modify(pte, vma->vm_page_prot);
+			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+			/* huge_pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+			pte = huge_pte_clear_uffd(pte);
+			pte = pte_mkyoung(pte);
+			/*
+			 * Unlike do_uffd_rwp(), do not upgrade to writable
+			 * here. Hugetlb lacks a can_change_huge_pte_writable()
+			 * equivalent, so a write access will take a separate
+			 * COW fault — acceptable for the rare private hugetlb
+			 * case.
+			 */
+			set_huge_pte_at(mm, vmf.address, vmf.pte, pte,
+					huge_page_size(h));
+			update_mmu_cache(vma, vmf.address, vmf.pte);
+		}
+		spin_unlock(ptl);
+		ret = 0;
+		goto out_mutex;
 	}
 
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index e0dcf2c28d9d..bfe6f218fb16 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6174,8 +6174,31 @@ static void numa_rebuild_large_mapping(struct vm_fault *vmf, struct vm_area_stru
 
 static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
 {
-	pte_unmap(vmf->pte);
-	return handle_userfault(vmf, VM_UFFD_RWP);
+	pte_t pte;
+
+	if (!userfaultfd_rwp_async(vmf->vma)) {
+		/* Sync mode: unmap PTE and deliver to userfaultfd handler */
+		pte_unmap(vmf->pte);
+		return handle_userfault(vmf, VM_UFFD_RWP);
+	}
+
+	spin_lock(vmf->ptl);
+	if (unlikely(!pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return 0;
+	}
+	pte = pte_modify(vmf->orig_pte, vmf->vma->vm_page_prot);
+	/* pte_modify() preserves _PAGE_UFFD; drop it on resolution */
+	pte = pte_clear_uffd(pte);
+	pte = pte_mkyoung(pte);
+	if (!pte_write(pte) &&
+	    vma_wants_manual_pte_write_upgrade(vmf->vma) &&
+	    can_change_pte_writable(vmf->vma, vmf->address, pte))
+		pte = pte_mkwrite(pte, vmf->vma);
+	set_pte_at(vmf->vma->vm_mm, vmf->address, vmf->pte, pte);
+	update_mmu_cache(vmf->vma, vmf->address, vmf->pte);
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	return 0;
 }
 
 static vm_fault_t do_numa_page(struct vm_fault *vmf)
-- 
2.51.2


