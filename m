Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 091A8C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5E46B0119; Mon,  6 Jul 2026 04:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACF86B011B; Mon,  6 Jul 2026 04:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD90E6B011C; Mon,  6 Jul 2026 04:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89B3F6B0119
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 104E18D36B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:43 +0000 (UTC)
X-FDA: 84957726126.01.03A510E
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf15.hostedemail.com (Postfix) with ESMTP id 12D3EA000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="C FTPLHN";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Z5i3cRcf;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0TBzVX60PifTt9I8UrLuBn1sZJMvXI1H66i8JITaIs=;
	b=atHI1KOgHgOWzCeNN2lBHroEyspOKFu0T+I7+mdpfLANE3O/EtoyTISOQOXqMyxF1W7/nq
	xfX3gfAKgn7EmM1/H/2BqSIBfVHIUeXgBAQQyV+M0EWBcwUAWRycvMcLrGIF32rWy56ZTr
	aaud+B+ccr6TVnW00BrpPEe59jS02HI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="C FTPLHN";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Z5i3cRcf;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327721;
	b=mvcbCwKMz6pMiwr5KNo/i6xVl2oglJbxiPxttp5Tebyjag8LrxvIdcDbeS5ZiM6zmKXAvo
	5IobDKJEc3vz3U/tsZxfucp/1gF5UE+U2SHZ/Hdv+i564fEqvPpbC4IMP733KmGP/gE/y9
	PXlEJr+QXt1xhalpBsqIdSUa2xTvREo=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id DCBB91D00109;
	Mon,  6 Jul 2026 04:48:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 06 Jul 2026 04:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783327719; x=
	1783414119; bh=s0TBzVX60PifTt9I8UrLuBn1sZJMvXI1H66i8JITaIs=; b=C
	FTPLHNiXflMbIbihoYhzzg0EVnllfnCGop3KVcxxotARtDkSFZ1heWP69tPGAPlG
	bQh5JD6sVlu4tODoA38IIPFNtxblT0dpiDiNhhmDh6rJHB0MfmxYMOUt0rATz1fK
	aYl2ycx3xTnkEPyMYVxfE+ey0YoH2303QCfCZHRg8qQq7YqKOkaZ5vXqxvqHfgkr
	zdnJz+pCKw0TaPYImEgoH91iycSsgAxXUbRlpGFmBxEpuWzsuksHS0h6+QWU73Kh
	ldgU2GY2cEcFNsiHAvGe/afTK54ZyD7+gLlAuPausVWq0bEK/Da9taK0fBJZ+1ZU
	wCnCONn6EDDckmFVTppqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783327719; x=1783414119; bh=s
	0TBzVX60PifTt9I8UrLuBn1sZJMvXI1H66i8JITaIs=; b=Z5i3cRcfOtpwiXL6S
	5AHFVeWC9dkGCKve3mNu+EWKCGOrDTPHu7n1uUzsmZ1l9IhW2Hzz51odkI8JbMyt
	dXCo4HrNr35insbhoCDvXn+vUrijNI2XPSfc7717/+yJaPz54+YphprlsSFy4edt
	DdGDVS9xSZ6vnGkTaZZ4bIRb/rQdUVJLU82MvEW+emhfX32Xw6vRGYrtGHLrjTOC
	IK2rNe41A9ZPImmrI60WEEtt7QFubO1ybHqSazygYw73d7fw+Qws0V3w+IYpgwf6
	Hrgl9MVQw8H8xJa181SMlKjuCSCgVIhLVbXy4VPlpGxAq71mCu31awjc8LZmZ2Jk
	OP75w==
X-ME-Sender: <xms:52tLai2OBeytNSp63DnDDHVk4X323-r9dg11iBTFmkX6IuEZLLbVxw>
    <xme:52tLapA-wGGT-nmNhX_N4olk-xcvOkV6OAw43Afs8RolLwsI2z3DXPOMe70K-xG3J
    NHUPf8xxImZAC_SfnHrX2_g507l5pBT-KYsWnwz2yt7YOqJk2X4z3s>
X-ME-Received: <xmr:52tLajZDjSyrdS1qs8VNRuy47W_h-ZNAdN7oIT2EEDIrkwfdv_uzM2BDjsmNRA>
X-ME-Proxy-Cause: dmFkZTEaPZdviD2XbalDAKS8tszO4Hte+xIg0jgPrUan8C55y4EV/KJ/Eom7XifH61NPsj
    FpHJNCv922yiJ1/uYMxxnyO7ohj4FdG9jlt3xAQ9ulNn8sNn16Di9FfOZz57KTymaDzX0X
    Oa0xwtmkNizaUUH2ahz49zlPrt4p4TivjhaMFb9MByS5fcrdsopAtNxM42z/KLfZEzontY
    dL7oYKud5vnDF47FBpMkQLkbBVAcKZwKKE3gao9aGmCcABxV7K5XPoDt0NUeM7mdB6UBaE
    xlUOaRlAzH3c/cAXi9JZvKpCWHAqobGBBf/9tSV3q5HJYXgQVn2KMNtd8oDpj8yLDeA9R4
    EKZ/edA9j92Bxk5WNAoS1XUU8CQG1m0TYEwiUp5R5GxtRf40elyUPtmLExDAHvZrNllxNz
    qHPH+wPZOQaJH1kKwc8MmLz2A9q9IVL6+UteEJXQ1120JrJKj5qj7VDnZpBBR+V/DXOs8i
    pQ8CKJJ2VtK8qYwCIjt0Vr4eiubnrxTvxVgg0tYcxzgEOlacO40lWWAK7NmUAnFwot7EHg
    9E/NQzAWdEVJus1MG96X2B0nrOcm0n7/HLM/3YL/yzznO4TISEtNAE9yVScuLyUghsUGGy
    RwMscidi3ksXQXudlNc4vH26NAlafwC1H/E0xk2yppTrB9hVXaayQFbSHRVg
X-ME-Proxy: <xmx:52tLatYyLB4KH-lAYWHs24uIZzcgzoS3Lke9MW1rMD4krYJW_7c1gg>
    <xmx:52tLask7js4-mwYda_7V74tZvYQ5nOFTpHzk49ago65vUStuGJDkwA>
    <xmx:52tLanQc2yZuVfpVop_2Wwk2fwHo3iMVNTRMX2x-0rlOdp0Yo8mI3g>
    <xmx:52tLapV7vImM6wnHGjnmL3wTDx7LDkcHYQ_Tm8u7baVvCoI-etfh8Q>
    <xmx:52tLauXVqw3G4lJX56raEuggf8ucISRRW8EjN6YEuN1Z_H1ui2LWcmM3>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:38 -0400 (EDT)
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
Subject: [PATCH v9 13/15] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Mon,  6 Jul 2026 09:48:02 +0100
Message-ID: <20260706084805.8400-14-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12D3EA000B
X-Stat-Signature: gtdqexxd8dz9gcjd3d53jcmseqb5mk7g
X-HE-Tag: 1783327720-522490
X-HE-Meta: U2FsdGVkX1/baJ4EOwy8BsuElFO4Ov+R7i+r90JdXUtBlQFZqC2gl2qUWW4A87J/gMS2ONAxSuBVWIE2LC1+NiqwaH3vSWkNIIj/AAh1VuGCAWYhCDodKBULdIDvNU+9IepSwS7IJ3FGEuw2hwt/8W7ntpiw7nkF/07RXnVSQ3O1OjbRGUaJwkI5di+QrJWcPGGQau2e4YVbAWqn8VDnCv3HK5Wh4d8NizPXcrk9sKciUjKGvp8v460P49qjT4BcszvxwEDj9Uug6JHrklhWdbaVlIh8RR2novqYtiaibh372XGt5B+yMQGjXLycAPE3H6x0SmehJqvi7AkKvd4EiU8UWRvLkUgvnTWaedINrpYuvbyKrJRdkKrZ4czmj9EiDt5m8cH8vtFkUc+mU4AvseAuEIj6zqzjCfPXKeh37UzTmLCYJjKlyOD7lTW+zTgZ664pVKftaYX+qCfC01ZlnXnsJ5ek+A8eALeb/xeBIsgk0iyWgb4NcG/8i/8CeJIAt4nVcztwPi9Z2Tlc1jNhtQCja7YT7rkb9XxYf2GLWkk8l2/H7xYxKAZcznZlHxGFF5/128Ryw6kkkhmY2T3pbFfkqCnxrBDppupw1xJveLROmCWSOWpYPJdVrxcY4TD0wjpHARmDK8ibeSMX4BTiY5UZaZcGJwzLxRLkejXLdtH5ZHCwCL89HmNjfLm4Ekfb8Eb/wKV3uiGWQCaRnBmYn9cmJ4kBo9484/HKNiPeXqE+/0anaAFjMcddBMicfPiiVqaeN+WWWAxjGrFtqsp6vE+K5tiMnDbXsqmuCKsEoyM0aTfDIja6jIUy7Q+x7iI738f8LI2TogRQ9KdLzfmkf1nQ85Cwu4f41EqUeQ8jTo0Qh9yBtzd8FOTZzqvasxysnCFnOmVYAnjUtjVg+pncyL3dpAsGttOI2KfKi+TTDuxIBIiarwfEQNazRkfqB+cR7YxQu9iWAbLIspzf6R9
 RD8r/J/v
 FdcNy6oVhwyEUkcMsM7jQ0V8nW+1buG4akNE0Z6U9EWtYl4wZ6zuORrdMHwDQfseFWwcEjAQzFyl8kGprb9xcvHXZUC/Mm12T6pG0GIcmTSpdlOTcK6ggWHG/fuVGd+LHijAfoAM0zBfPg3mrTd3hFBA8zvKYPwU8j4jo8XuRNgfFEOhcsMcG2l/oTYFpH2+NzPNYgljUaEarfPEJtpCYyLFLfHdK4OpMr41LLya32zrn6O6+og5VuPppa/5KtBwnObsHRwnI+MKojAyPAJMQAFSfJbzi1LR53yUK0eJJKdL1ushB5lpSFMzA15iga7/iYqtrZsWT/QgqHU7Ms5Kj6VX0VbIXUDYEnU0H9GED3OrmfV2zQAPdYEdP7t6u3+BY0k6pinTj6jwqPCg4RZaw8tdNU80yAVoPAkwQH1LBPq/xb86ZZBUytKvfgV2JBT8tJt5WA57uGXa6acBYCIBttRaocs0/Px6vpE2tCgI/S+fDL7gD+vNfpLnirvfEV/+xnZnUG9bVvWrESjFRQYm9tmkdbebLgTzaUi62Rj+xen0eSNckE6auZGWIgnocy1xtNY4j+JytaH8kunYAb+00kiAgNw==
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
 mm/userfaultfd.c                 | 152 +++++++++++++++++++++++++------
 2 files changed, 137 insertions(+), 29 deletions(-)

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
index 763897f59678..c96cfe0871dd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2475,19 +2475,29 @@ struct userfaultfd_wake_range {
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
@@ -2502,7 +2512,7 @@ bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	if (!ctx)
 		return false;
 
-	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
@@ -3739,7 +3749,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP) {
 		if (!pgtable_supports_uffd() || VM_UFFD_RWP == VM_NONE)
 			goto out;
-		if (!(ctx->features & UFFD_FEATURE_RWP))
+		if (!(userfaultfd_features(ctx) & UFFD_FEATURE_RWP))
 			goto out;
 		vm_flags |= VM_UFFD_RWP;
 	}
@@ -4299,6 +4309,109 @@ static int userfaultfd_rwprotect(struct userfaultfd_ctx *ctx,
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
@@ -4537,29 +4650,7 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
@@ -4629,6 +4720,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_RWPROTECT:
 		ret = userfaultfd_rwprotect(ctx, arg);
 		break;
+	case UFFDIO_SET_MODE:
+		ret = userfaultfd_set_mode(ctx, arg);
+		break;
 	}
 	return ret;
 }
@@ -4656,7 +4750,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
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


