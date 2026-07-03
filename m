Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17060C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72EC76B00DE; Fri,  3 Jul 2026 09:36:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6935B6B00E2; Fri,  3 Jul 2026 09:36:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508AE6B00DE; Fri,  3 Jul 2026 09:36:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 024F16B00DE
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8865E12014E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:52 +0000 (UTC)
X-FDA: 84947565864.24.E207B40
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf04.hostedemail.com (Postfix) with ESMTP id 97DF340007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="h CcVtTu";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="RQUVtja/";
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085810;
	b=UC9dNSlsCgK9ZRaJSDFe6HVPWYusCG/kA7REgSHG9UtfQmKd7K9ATpA8tiUcc0HZMxqYGG
	PCX/e/MxEhQYaA+ncnhC7qiUL8JAMUOze3gdTkTVBKtTpfXE/f/z2cdJnAPbTcMOA0Tvac
	vDDgqhP7pBP7UUTV8G5KQpERhS6w4sU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdxUu2oye/uPbhzvJowyuT/K3tsRfsLqm46GQayd71E=;
	b=R/s8Cj0FLRrIhEKhW29r1QyFqrQ8pgCO6Tbrdq1C2UvaO+KOF5/4j9DCsxq8mNO7RZscdL
	8UAO1UUIka+wLKzGyOi8BzOM4Lf6GJi+j72t/GnlvoCDQCcc5+Fh5QtBekxcx5QKvjqy6W
	073r6fJMuyBd0qTwaL/tsNKShYZZsY4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="h CcVtTu";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="RQUVtja/";
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 6D3A61D00089;
	Fri,  3 Jul 2026 09:36:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 03 Jul 2026 09:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783085809; x=
	1783172209; bh=mdxUu2oye/uPbhzvJowyuT/K3tsRfsLqm46GQayd71E=; b=h
	CcVtTuIzxqwhTaVW+4L8IzrGG6vnpvLU0Kxj48ZHigo+oVNCWNV02R5tLDbv+2n1
	2ZiUsAN8RJKMQmVlO191DTE0VLuKHlDVpazT5dkr0Z3wKNqgfw0Nc8toTB0MOUye
	OBYm4OuIv8NdVbP71CwDou7bOfaXcDKSSFE7HfpPW4V+lizJd70Twtk8HBDhgu+t
	IRqLckkZhd4FJLAChtX7sVpySaPs0zPw38vIDzF3snJfJvyIe+6gM/+xkCQ4vWnG
	iOW6IGSKgogB0/IJKPMUMFyo1WSWP0PhkpjpL7D0SDkcXRffmR8por5d3MZwD6nL
	wkY5EsuuBOP/ZSaj/UJzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783085809; x=1783172209; bh=m
	dxUu2oye/uPbhzvJowyuT/K3tsRfsLqm46GQayd71E=; b=RQUVtja/XwVi/Nj8H
	xCBRZhpTCzdBa5tEO/c1XpvCftakpcSY9zLcQVeZXJwI25ODWvw2uDhK1Y/ng+pQ
	Df4dugQq8qkJMSFdBF3tIDj6geYAhj1TN8sokkgRn3aFK3I8Iw6h/q3xX1liyShE
	T+b98JKOC9cA8SALDYsaPYvjlbdsgf0B0BggwR3YzEnXRcOoZlUukZjxVBvWJIO/
	xGwXeXww+sedk40IsmRjUkAi9XRNA50L4mU2HfMlhWRZ6reDIyIeUgWw9PKkMv0N
	8VGR85+dtmHZNb3PXVzUhBd8vZvlXRhXckYsYYw0msDO3y521lMJb+/NEIBiupm6
	63NaQ==
X-ME-Sender: <xms:8bpHahhD2OODVbAC7gQC4Atbt4SYHHsoEbqCOxkO0IvEpAOOE3VAIA>
    <xme:8bpHap9opsfXmtD97K-lpxq6dxsqCZEW8V0U-JjYLT18j90h3w48JcgdqVA0dRoT_
    pMVaBDDT5_sfw_51PcIvfYXU4rSWiTp5jTAty1rjHTsZxfTqQMlFiQ>
X-ME-Received: <xmr:8bpHapmlKiFrcDlURv_D_53wgjQOf6M5av9dry_hl23w9spRKXyDT09V4sApiA>
X-ME-Proxy-Cause: dmFkZTGmmVcSqc1ifmQn6XT5ZUiwwX9N2nBOVuQVUkn8E1VmhORLccagOf8n2iB9wYOimT
    VzJiyUcgIqy/F0CFPKO3A/DQyvjGeTlZjtILSrkvsXFDgtW2/LwSNqnX5y3lfCjPv8KT3y
    pv/7yUocU0F79ppz7Ja4LBUNuFPFOlR+UkSCRCi85W7w3PiYdJWamj0Yvnexj1ymZQshib
    QPJ8v6Uvr3wPfhejR1DMCrATOEIEqdDaqDi/+pTxD6COhr4t8Y6r8u3UoT9065hT5et/xu
    b2Mj9gqnBcApBMrR+ydSZ96PlRnTO/2cg0/pxM9weE3L0EHx9ppj7MXSHbWsD/J+EG70az
    O4dkHtCW5xfi0bUGa1wCxKB4GsHUe6PhmugEvIPP5uheEGBCx7g6qVZQP3HBs6nbUigsmt
    QlineLJs71igRXieLpxssuBZ2Npp/oMQxgh8sUdII58jdTuALXzRui2PnGVZN0dcBhOZCj
    SRnKeuv+RiMESDhbBNnIHId2nUAunxspvGTsbvsWaOY6txd99R7xjjUvD5hhMWS7tKHI3k
    GLXt2dhY9k2EczoBB4OjMcuXZHJ+SVlrIw3NwQUXFhpsoG+K8mAOEPaXYdwZjiXPdXBDWi
    zuNoqeLu9gvsgc4nlgMlIyu5d2XR3qw7hYahzLwo6nJvltFYO/8ZIkbhAz4A
X-ME-Proxy: <xmx:8bpHav0I2DgKtTCXWxxpkLrd2KROPOXMGjQLBkJYy2J3YWMIuKev0g>
    <xmx:8bpHamR0E8rt6GV-RBxIQHGkqzJEseCUNUaS3bMT_66k6wTomh8eNA>
    <xmx:8bpHanN4U4h80oNQPZO8CERky5mDYZ8G_MgBBdog2YwEpeoTjh2Ksg>
    <xmx:8bpHaijBth0pPAAv_a0z10jc0crkBgOhox5vzdFpcOGmoaLiDpTY-Q>
    <xmx:8bpHanj8mOLqe1U63eKNpouPXnyBlkTagP2nJUHif4GgC2J3pTJwuQvd>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:48 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v8 13/15] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Fri,  3 Jul 2026 14:36:12 +0100
Message-ID: <20260703133615.1039465-14-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 97DF340007
X-Stat-Signature: 7tirf61kppaou4oagkrafdr3ddgdb6wt
X-Rspam-User: 
X-HE-Tag: 1783085810-807218
X-HE-Meta: U2FsdGVkX19rSAjCuWjmk04q3L+wYGyOv4syez4Wu1TNGkl0ZwUyHuMBIAqY1LgxVssDORJGVAqRfxR4xlLJ8heeUfW5bSWXVrInwvsZ/lfspBUJI0S7DigZIOtl3VZTan4jSA+jHaSclWKedzmb0gD4wX2y0iY6V5z4UukvyXGcYvVfHR4rD643LkhaSGUpcpwgAcGSIzzHVOnppKqkEj86+gSVpBHguTIigiSLZFH6hJ28Bfkf76Hr3ro/Js9aqiSG5FfaKfkD0OqQ0oy/tyCdDvNzoHRes4xZiNbJeJIsikxz00tnofD3rPL7I/M72W2dHREVbqFXJBwtmvx+CNiwbDSvGN0J6S0N8ldyATrCEOKdQtXDX9Dn+4KbLJ3FHvH0dU42j6CPRUGUCyN0gArSevlO9rnKqdraWXxeGNt79tc7ynlEwxWD1HKmx6kmB1NChi4pAPZGNLRC6e/0QHbmoNasC8HD1Y6L1vrgiSy/lRVMI7gjhG6ztRZimL2fw6nevMTvbxO0zL7DhQf3MxhMc/WNtkF5S5y5RqBoqXk2MUiWTMV1hB8bHrqg7SNrIXeYJzg7Y0rSniVu2oWpxmEY85bwBuBcZU4aepg4iJQ0OTQAQUhnZNMrhzwTlA8ltTligmPAKPCscdghhh2JaIj56fCvraSnHNaJ/9uG5y+E3TWSpU2pU++0vIbD2kaPPiDzRyOzFEbRYnoY6YYJoA3KhWI0LotkReox5vF2boIMFDTX5Wfq9TeH3YYYlIa1yKX0JsDaaHpW2ULrYq1eaKcrrstGDkkBHOAVmfDdlKHjEiAjF8dLAxHjSJ4aG+elwOevYnoznChSwsqbr+0yL6rZhUozmU8HaG3f62hViYzY20GQ6ozjuVa5mDo8RwWBSOfTnAtmm0vxB3jS5pKBrULaKN3pPoAqhrlHMgQ/ejFDqabEm0tZ53qlNKHZHPl3i14yvMHzD+04IBaraVG
 I/bEVQCm
 ji0b7yjHY/pUhM46zl9vPfFUIKk3tatTkB8fhFNt+vrswdJNWRvMBah80WlIbtXHVp62SB9K77PryNoqLvzMgFO4xCB/nhOcnGdc/xy9Kx/3aEYAX4yV/0UrUt/LK2A9hVYq6Y3UtdQ0xtp+TUmdWzeVPsOBZdY4hHtO9FWjiwvj6zFF1tNeD4DHEftyIqIVQ4/H6bdaEtDLUsMLB7htEqNvrNvqibfjlkgmDx87l6oKLR2QgILQ4a871k7GnBL4XxQm1Ti0kw/HjNlkR5Aaj6esxeK53wI664ccqpq8o1Dcipx/MWXnDxFbKUMojYq2wnDxD0b7tdJUVf9YFRzQY5haPsv6ZCUeQ6Wg0hunv9P362CVlsznG3H63SxDGv+VWW1XDFOk3lurxzGkI1FmEy6JK75IQv6XadROqn9S+qm0ZE8hfuIZEKzfv77EilTOmT269Bo4mjoL+nQ/ewVDvAA2C6ApzQI+DZ9zeQy5YDolpnj+zoORYU6fwWMIgvjWG192Zg8k3DDP8QXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Add an ioctl to toggle async mode at runtime without re-registering
the userfaultfd. This allows a VMM to switch between sync and async
RWP modes on-the-fly -- for example, starting in async mode for
working set scanning, then switching to sync mode to intercept faults
during page eviction.

UFFDIO_SET_MODE takes an enable/disable bitmask of UFFD_FEATURE_*
flags. Only UFFD_FEATURE_RWP_ASYNC is toggleable today; the ioctl
rejects any other bit with -EINVAL. Enabling RWP_ASYNC also requires
RWP to have been negotiated at UFFDIO_API time, mirroring the
UFFDIO_API invariant.

Fault-path readers of ctx->features run under mmap_read_lock or a
per-VMA lock; the RMW takes mmap_write_lock and calls
vma_start_write() on every UFFD-armed VMA, so those readers are fully
excluded. userfaultfd_show_fdinfo(), however, reads ctx->features
without any lock, so the RMW is written as a single WRITE_ONCE and
fdinfo reads it with READ_ONCE. That keeps the lockless observer from
seeing a mid-RMW intermediate and removes the audit burden when new
toggleable bits are added later.

When switching to async, pending sync waiters are woken so they retry
and auto-resolve under the new mode.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/uapi/linux/userfaultfd.h |  14 +++
 mm/userfaultfd.c                 | 150 +++++++++++++++++++++++++------
 2 files changed, 136 insertions(+), 28 deletions(-)

diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index c10f08f8a618..cea11aad6b54 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -49,6 +49,7 @@
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
+	 (__u64)1 << _UFFDIO_SET_MODE |		\
 	 (__u64)1 << _UFFDIO_API)
 #define UFFD_API_RANGE_IOCTLS			\
 	((__u64)1 << _UFFDIO_WAKE |		\
@@ -85,6 +86,7 @@
 #define _UFFDIO_CONTINUE		(0x07)
 #define _UFFDIO_POISON			(0x08)
 #define _UFFDIO_RWPROTECT		(0x09)
+#define _UFFDIO_SET_MODE		(0x0A)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -111,6 +113,8 @@
 				      struct uffdio_poison)
 #define UFFDIO_RWPROTECT	_IOWR(UFFDIO, _UFFDIO_RWPROTECT,	\
 				      struct uffdio_rwprotect)
+#define UFFDIO_SET_MODE		_IOW(UFFDIO, _UFFDIO_SET_MODE,	\
+				     struct uffdio_set_mode)
 
 /* read() structure */
 struct uffd_msg {
@@ -406,6 +410,16 @@ struct uffdio_move {
 	__s64 move;
 };
 
+struct uffdio_set_mode {
+	/*
+	 * Toggle async mode for features at runtime.
+	 * Supported: UFFD_FEATURE_RWP_ASYNC.
+	 * Setting a bit in both enable and disable is invalid.
+	 */
+	__u64 enable;
+	__u64 disable;
+};
+
 /*
  * Flags for the userfaultfd(2) system call itself.
  */
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 1a3504c63597..a7659b0a1147 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2484,19 +2484,29 @@ struct userfaultfd_wake_range {
 /* internal indication that UFFD_API ioctl was successfully executed */
 #define UFFD_FEATURE_INITIALIZED		(1u << 31)
 
+/*
+ * UFFDIO_SET_MODE updates ctx->features under mmap_write_lock with
+ * WRITE_ONCE; readers that run outside mmap_read_lock or the per-VMA
+ * lock (poll/read_iter/ioctl, fdinfo) must pair with READ_ONCE.
+ */
+static unsigned int userfaultfd_features(struct userfaultfd_ctx *ctx)
+{
+	return READ_ONCE(ctx->features);
+}
+
 static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
 {
-	return ctx->features & UFFD_FEATURE_INITIALIZED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_INITIALIZED;
 }
 
 static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
 {
-	return ctx && (ctx->features & UFFD_FEATURE_WP_ASYNC);
+	return ctx && (userfaultfd_features(ctx) & UFFD_FEATURE_WP_ASYNC);
 }
 
 static bool userfaultfd_rwp_async_ctx(struct userfaultfd_ctx *ctx)
 {
-	return ctx && (ctx->features & UFFD_FEATURE_RWP_ASYNC);
+	return ctx && (userfaultfd_features(ctx) & UFFD_FEATURE_RWP_ASYNC);
 }
 
 /*
@@ -2511,7 +2521,7 @@ bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	if (!ctx)
 		return false;
 
-	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
@@ -4297,6 +4307,109 @@ static int userfaultfd_rwprotect(struct userfaultfd_ctx *ctx,
 	return ret;
 }
 
+/* Subset of UFFD_API_FEATURES actually supported by this kernel/arch */
+static __u64 uffd_api_available_features(void)
+{
+	__u64 f = UFFD_API_FEATURES;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_MINOR))
+		f &= ~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
+	if (!pgtable_supports_uffd())
+		f &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+	if (!uffd_supports_wp_marker())
+		f &= ~(UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
+		       UFFD_FEATURE_WP_UNPOPULATED |
+		       UFFD_FEATURE_WP_ASYNC);
+	/*
+	 * RWP needs both PROT_NONE support and the uffd PTE bit. The
+	 * VM_UFFD_RWP check covers compile-time unavailability; the
+	 * pgtable_supports_uffd() check covers runtime (e.g. riscv
+	 * without the SVRSW60T59B extension) where the PTE bit is declared
+	 * but not actually usable.
+	 */
+	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
+		f &= ~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
+	return f;
+}
+
+/* Async features that can be toggled at runtime via UFFDIO_SET_MODE */
+#define UFFD_FEATURE_TOGGLEABLE	UFFD_FEATURE_RWP_ASYNC
+
+static int userfaultfd_set_mode(struct userfaultfd_ctx *ctx,
+				unsigned long arg)
+{
+	struct uffdio_set_mode mode;
+	struct mm_struct *mm = ctx->mm;
+
+	if (copy_from_user(&mode, (void __user *)arg, sizeof(mode)))
+		return -EFAULT;
+
+	/* enable and disable must not overlap */
+	if (mode.enable & mode.disable)
+		return -EINVAL;
+
+	/* only toggleable features that this kernel/arch actually supports */
+	if ((mode.enable | mode.disable) &
+	    ~(uffd_api_available_features() & UFFD_FEATURE_TOGGLEABLE))
+		return -EINVAL;
+
+	/* RWP_ASYNC can only be enabled on contexts that negotiated RWP */
+	if ((mode.enable & UFFD_FEATURE_RWP_ASYNC) &&
+	    !(userfaultfd_features(ctx) & UFFD_FEATURE_RWP))
+		return -EINVAL;
+
+	if (!mmget_not_zero(mm))
+		return -ESRCH;
+
+	/*
+	 * Drain in-flight faults before flipping features. mmap_write_lock()
+	 * blocks new mmap_read_lock() callers, but per-VMA locked faults
+	 * (lock_vma_under_rcu() + FAULT_FLAG_VMA_LOCK) that acquired before
+	 * this point keep running. Calling vma_start_write() on each UFFD-
+	 * armed VMA waits for those readers to drop, so no in-flight fault
+	 * can observe the old features after mmap_write_unlock().
+	 */
+	mmap_write_lock(mm);
+	{
+		struct vm_area_struct *vma;
+		VMA_ITERATOR(vmi, mm, 0);
+
+		for_each_vma(vmi, vma) {
+			if (vma->vm_userfaultfd_ctx.ctx == ctx)
+				vma_start_write(vma);
+		}
+	}
+	/*
+	 * Single WRITE_ONCE so lockless readers (fdinfo, poll/read_iter
+	 * via userfaultfd_is_initialized(), and the userfaultfd_features()
+	 * helper used elsewhere) can't observe a mid-RMW intermediate
+	 * value. Hot-path readers already serialise through the mmap lock
+	 * + vma_start_write() drain above, so their load doesn't need an
+	 * annotation.
+	 */
+	WRITE_ONCE(ctx->features,
+		   (ctx->features | mode.enable) & ~mode.disable);
+	mmap_write_unlock(mm);
+
+	/*
+	 * If switching to async, wake threads blocked in handle_userfault().
+	 * They will retry the fault and auto-resolve under the new mode.
+	 * len=0 means wake all pending faults on this context.
+	 */
+	if (mode.enable & UFFD_FEATURE_RWP_ASYNC) {
+		struct userfaultfd_wake_range range = { .len = 0 };
+
+		spin_lock_irq(&ctx->fault_pending_wqh.lock);
+		__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL,
+				     &range);
+		__wake_up(&ctx->fault_wqh, TASK_NORMAL, 1, &range);
+		spin_unlock_irq(&ctx->fault_pending_wqh.lock);
+	}
+
+	mmput(mm);
+	return 0;
+}
+
 static int userfaultfd_continue(struct userfaultfd_ctx *ctx, unsigned long arg)
 {
 	__s64 ret;
@@ -4535,29 +4648,7 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 		goto err_out;
 
 	/* report all available features and ioctls to userland */
-	uffdio_api.features = UFFD_API_FEATURES;
-#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-	uffdio_api.features &=
-		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
-#endif
-	if (!pgtable_supports_uffd())
-		uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
-
-	if (!uffd_supports_wp_marker()) {
-		uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
-		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
-		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
-	}
-	/*
-	 * RWP needs both PROT_NONE support and the uffd-wp PTE bit. The
-	 * VM_UFFD_RWP check covers compile-time unavailability; the
-	 * pgtable_supports_uffd() check covers runtime (e.g. riscv
-	 * without the SVRSW60T59B extension) where the PTE bit is declared
-	 * but not actually usable.
-	 */
-	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
-		uffdio_api.features &=
-			~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
+	uffdio_api.features = uffd_api_available_features();
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
@@ -4627,6 +4718,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_RWPROTECT:
 		ret = userfaultfd_rwprotect(ctx, arg);
 		break;
+	case UFFDIO_SET_MODE:
+		ret = userfaultfd_set_mode(ctx, arg);
+		break;
 	}
 	return ret;
 }
@@ -4654,7 +4748,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
 	 *	protocols: aa:... bb:...
 	 */
 	seq_printf(m, "pending:\t%lu\ntotal:\t%lu\nAPI:\t%Lx:%x:%Lx\n",
-		   pending, total, UFFD_API, ctx->features,
+		   pending, total, UFFD_API, userfaultfd_features(ctx),
 		   UFFD_API_IOCTLS|UFFD_API_RANGE_IOCTLS);
 }
 #endif
-- 
2.54.0


