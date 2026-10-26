Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55AD2606A338
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVSKUpok
Received: by kanga.kvack.org (Postfix)
	id 4A62A6B05E0; Mon, 26 Oct 2026 19:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D986B05E1; Mon, 26 Oct 2026 19:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D066B05E2; Mon, 26 Oct 2026 19:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0CE6B05E0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:26:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62316160900
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:00 +0000 (UTC)
X-FDA: 85366362480.22.7B79F08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5F2F280002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:25:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVSKUpok;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0pu8Ss8TrSLj8FO7fPlBZkaV3M1b2y5HjOs69Tagg4=;
	b=17vNrDwoNqoI05gSEUDQvjnxhGJVT3wU5YH6VO7UhTWhLImDjx6XBrFCzjX5LQ6O4wNv60
	98sSH3T4wwoSYRYiRJ0Gg0B7Dz+a1JXXeZlDXXgqA0NDjRyabMdkWPL72gX1yId68H6ess
	3Px8tn3jA2pvtB0X8K4gRk7RMTgaWR8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVSKUpok;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057158;
	b=C4LBw4cYNklgvMx+sQ3f7G02MWYUcSoZEzn6La8tPtF4WWRufXKwTMknRx23+RsNQfZGmN
	WQGIdI3KT4YZCkBoIsCx2ypDdEHKkWuHg4AE2mMZc6mm0ekmxaF/VLhAqI59SqjkhPFt3T
	S7lAE+yw7Ahqlzf0TftjiobOJ0ZwOdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3B1640F0B;
	Mon, 26 Oct 2026 23:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418561F031E6;
	Mon, 26 Oct 2026 23:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057157;
	bh=Q0pu8Ss8TrSLj8FO7fPlBZkaV3M1b2y5HjOs69Tagg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dVSKUpokpjZ2lKz5sgu2+jgvyzGaSAX6vRYnlBpqKjvv2mqyYXaKpBuR9ymf5d4t8
	 tq9iBj4ML9mzo4NKpDlpawTt+NR7UDyy+Nryj6tREZ7yArc/rpBOpz/A4/5br4zG0+
	 x0iZdj2f5Sb5mwmph2bcuRITXMEesZE9h+BBFF/4Ov3fZwvoF7ayNIbuWmfsW/EaFa
	 uCYZV36D8wg+9VF8I0AsLF+HgmaGBIG64Mybgex/7/uAKQwJJFOb3g+Ha1dY3JZJU3
	 cv+TTihPxIhbLZRaqQuPTWl+/FxkHdQBqxm5KMmqpUXuBfJWoDm+8MDdv9iWk9VtNB
	 vWJGYSqa3KOOw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 777D9198003A;
	Mon, 26 Oct 2026 19:25:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 26 Oct 2026 19:25:54 -0400
X-ME-Sender: <xms:feHfanZpZUzt37xIKFMuhKYUFAtgK8yWR3GHHYBN4crIzFUmPStkLg>
    <xme:feHfaqGlVMcnpDgJwDaPOrhkpPz-l7KLsejCHugjrfQNWs-YOMd1UNJGC3J8HMdhb
    XxwLAGBAeAYEZz9m5T6y4uz95UExrZAV9TlK9SXo7Sfx6kNBTl0qwJ0rw>
X-ME-Received: <xmr:feHfalA5lzAkAy0z_s4afQXpTiAjCdmMnVzhaz0p1_wzq0YiYLTZcm-gG40>
X-ME-Proxy-Cause: dmFkZTFRlyYFTVCU8gz2uLLoT2C5lHvwgmu12wMMEQ6YxiRDppxkDVz3lGvq6FPF9nVzQk
    SFaEBrDBm1p0HD3mb1az3KLUorngiBeBcGFQN9J0rx7wJvoCKxUijbnqaYFl15corEhTQ3
    PtbN5UIO7QLz7cypEQ8KcC2DzjGrV9Kt9rYgVrf9N4HJAQWkm8mmBm9ly2gH8NcVzKWb12
    dY2VvASWoZK+uTeLH2UyJQt1P3Hsxk6Rmsloqw7ul0jaPTfpquQD0WRZHE9UeHHD+0psFm
    YzE1oihGTq+GRZjvnCp6GuUBvQ9PVGybvVXIYcMJEViW6EseE1H2NDWp8egeDxaoUcaxLZ
    SSSoIStv9q2nnST4FJGE2BV02RK9Mhkpe7p+aVCmZvN7WfopAV9qpW/cKGTYxBR3CwdGWI
    TNjIcQbidM4621IEdTS3q111CDkxnz60VIpI3FChrbNu3d9zbDhf0LIE2iY2ejz8kQnCDC
    QL9Q3UBqwbVUOn/4huG7cF/Z/XCSZgWxN3N7B+TmGSgnLVdpuMehA9FZzTPavrZCspYWvl
    vPboJw8C0/8RbgeUatl8cUmLEQTyYeHySn5wVJjJP5PUs2i0Jnf2FmFHiajzSQ/3Xdf+06
    CRN3+1TBQULPtrqMtYKPJ/rmbhFwk5F7bDLJcFimdhxy1Ti7vqxpOKPm/5Qw
X-ME-Proxy: <xmx:feHfarEmGn9mslsPWrk22jv1auijKERY1VJIkEeWMKixgN4FxGkirw>
    <xmx:feHfaoKcSWozlOVaBIiqZZ61MY9JFby0V3o3Tv8W-V45yKwYpmKbEw>
    <xmx:feHfavv2_vQ0rVxLyS2FbZtDsbmCX5kQvzWIKr8U5kzHZtLaIKhSSw>
    <xmx:feHfaloD4SLm4alh9hDWWN68BxlT5hOWB_-adeAqEbrckPhYCyPUdw>
    <xmx:fuHfajUgFsFx_vLn6zIxQC_SLrFj7GMClday7_qablEEOnO_uCuY1ALk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 19:25:47 -0400 (EDT)
Date: Mon, 26 Oct 2026 23:25:46 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <at_f43oDv73y-t7O@thinkstation>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F2F280002
X-Stat-Signature: 76t7e7wg1seqz9y34rk8asboqz5uaoq1
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793057158-879343
X-HE-Meta: U2FsdGVkX18iiLoZyg/r2P5LaQKUlfIQ6KDk5thBXn+4V5UEtUHrmvHAEUF6afZtIR8pCUrnssWu9Vd1/miebT4lEEu+EdyL7rsCBa6LL+Myw3J1p50kGaaxZyeTQ5OdoQcTSVbr3iBo4w0yCX+NjNUZZuOGxaRcqz5OOWi64qnza8fstVQeyys4nbw8rs7dGRDSQaH2326w3ygRAdAtO76A/KCP6YfhZbHdhRKd0JPjkmDZD2osN4ckdQGUtcJgYTauye+gUaV90dg5Qmki2plfXJNDZAgZyNwhiN3qQ+yztas4FWGse2C7/OQPUdPZVnqEHkDQVbsaHY83z9Yz61qS71coK31jgb73hWBePTFPmmenNy82xKzorC8AuJW9nSDHipgR32m4ArlZmI+cBapM2afymWCFOkGrE4Hu+TULgrp4hdy3NYqTiep4Z5ct8Ta+kSu4dPY4q7SLPANOjRWxhEu4o6slBlHqhTuf2MSv01DHxR585gMM+UCdqSBPGMGrZsQCvyW+smh4OaCmTEIYqTyIOOfntCPv0PL7o7cT4Bor9Kb6dkBviJcVCB9v7OzE5c3wfp/cr3fgbXAv9RaTeNNY0hB2E3dbc2M/Y1Ah24Jc67Tlq97eGqgcsvGMOEywfhYvMg/Ci691d1dfk5aark1B6IfrHn6uZJmrpUk2QbKyrXyTUCwUSBilFF8MBa0Vr359nV3XFZLjHvlCCMxzENS//EQpBfYdZBlyCXjumJrolxfREnsQGsCxLimo8Bhe8GrnHNjfGXxSONn41cSeErNmnlB32GcRMZKhrx8YrbADJPntZIUu5w1D/qhXTkpDzbRlTbcxNtmpoU0AxIdA+75JnOtKbKptaZeq00ZEcXwFU/IYbAwTKFhcJX1w/uR44QEGF+PThwtxDMQXtjuJX3KtDkQjQqWeo1UWGRVG1wdEQlEgS4yviBM7izko+MuYUHdPalwD6ed2rnI
 JU4LTlsV
 95Bp9iKFyQe1NypnBv9HRXCGsgEDL3Uf/n7fhuQM6sgsJ1c6rOoKmru0IGP1S23GuzYDdNnOSco8PXFoyRL1HdMw7MatcadoSpV8XpfltAoLCXXjPV1zhDS8Yzgdk786h7us3CVDsk5eFKDxNc2ItyNVGzvyK9Gnr5AoJH8HLix7iefz4DLo2dtG+wBZLEhggmhBRD/Cg0stol2e78KY2Vc/fOeDQMzHlGtiBeQazX0d40YckenttFyPPqbw7TxF1IYBn/GX24u4YgwjJ2+l9Y6RmWMz7etmWIYONHgX+FqaHSpXAuxU15Y08WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 06:45:48PM +0100, David Hildenbrand (Arm) wrote:
> On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > With fake head pages eliminated in the previous commit, remove the
> > supporting infrastructure:
> > 
> >   - page_fixed_fake_head(): no longer needed to detect fake heads;
> >   - page_is_fake_head(): no longer needed;
> >   - page_count_writable(): no longer needed for RCU protection;
> >   - RCU read_lock in page_ref_add_unless(): no longer needed;
> 
> I have an AI report that removing RCU read-lock was wrong.

Ughh. Yes, it is a real bug.

My reasoning in the commit message was wrong. Nothing stops a
speculative get from writing to one after the remap. On x86 even a
failing cmpxchg faults there.

The fix I have in mind is to let the atomic fault.

If the update faults, the struct page is a read-only HVO tail with a
zero refcount, so the get just fails. An exception table entry on the
cmpxchg handles it. No RCU on either side, and the fast path stays the
same lock cmpxchg loop.

Only x86, riscv and loongarch have HVO. Below is x86 only, to show the
idea; riscv and loongarch need the same primitive in their LL/SC
fetch_add_unless().

Lightly tested on x86 by hitting a real HVO tail page.

Does it look sane?

I can prepare a proper patchset if looks reasonable.

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 75743f1dfd4e..5252b1382ed0 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -108,6 +108,25 @@ static __always_inline bool arch_atomic_try_cmpxchg(atomic_t *v, int *old, int n
 }
 #define arch_atomic_try_cmpxchg arch_atomic_try_cmpxchg
 
+/*
+ * arch_atomic_fetch_add_unless_nofault() is arch_atomic_fetch_add_unless(),
+ * except that a fault on the access jumps to @label instead of oopsing.  It
+ * works in any context, including with IRQs disabled.
+ */
+#define arch_atomic_fetch_add_unless_nofault(_v, _a, _u, label)	\
+({									\
+	atomic_t *__v = (_v);						\
+	int __a = (_a), __u = (_u);					\
+	int __c = arch_atomic_read(__v);				\
+									\
+	do {								\
+		if (unlikely(__c == __u))				\
+			break;						\
+	} while (!__try_cmpxchg_nofault(&__v->counter, &__c,		\
+					__c + __a, label));		\
+	__c;								\
+})
+
 static __always_inline int arch_atomic_xchg(atomic_t *v, int new)
 {
 	return arch_xchg(&v->counter, new);
diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index a88b06f1c35e..685aab3edd3f 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -232,6 +232,63 @@ extern void __add_wrong_size(void)
 #define arch_try_cmpxchg_local(ptr, pold, new)				\
 	__try_cmpxchg_local((ptr), (pold), (new), sizeof(*(ptr)))
 
+/*
+ * __try_cmpxchg_nofault() is arch_try_cmpxchg() on a 4-byte kernel variable,
+ * except that a fault on the access jumps to @label instead of oopsing.
+ */
+#ifdef CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_nofault(_ptr, _pold, _new, label)		\
+({									\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+									\
+	if (sizeof(*(_ptr)) != 4)					\
+		__cmpxchg_wrong_size();					\
+	asm_goto_output("\n"						\
+			"1: " LOCK_PREFIX "cmpxchgl %[new], %[ptr]\n"	\
+			_ASM_EXTABLE(1b, %l[label])			\
+			: "=@ccz" (success),				\
+			  [ptr] "+m" (*(_ptr)),				\
+			  [old] "+a" (__old)				\
+			: [new] "r" (__new)				\
+			: "memory"					\
+			: label);					\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);						\
+})
+#else
+#define __try_cmpxchg_nofault(_ptr, _pold, _new, label)		\
+({									\
+	int __err = 0;							\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+									\
+	if (sizeof(*(_ptr)) != 4)					\
+		__cmpxchg_wrong_size();					\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchgl %[new], %[ptr]\n"	\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG,	\
+					   %[errout])			\
+		     : "=@ccz" (success),				\
+		       [errout] "+r" (__err),				\
+		       [ptr] "+m" (*(_ptr)),				\
+		       [old] "+a" (__old)				\
+		     : [new] "r" (__new)				\
+		     : "memory");					\
+	if (unlikely(__err))						\
+		goto label;						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);						\
+})
+#endif
+
 /*
  * xadd() adds "inc" to "*ptr" and atomically returns the previous
  * value of "*ptr".
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 9f5c75d06f76..82a2fc445ce6 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -246,9 +246,31 @@ static inline int folio_ref_dec_return(struct folio *folio)
 	return page_ref_dec_return(&folio->page);
 }
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+/*
+ * HVO maps the tail struct pages of a hugetlb folio read-only.  A speculative
+ * caller can read a non-zero refcount, then the page gets freed, becomes a
+ * tail page of a hugetlb folio and is remapped before the update.  The
+ * atomic then faults.  A read-only struct page is a hugetlb tail page with a
+ * zero refcount, so the fault means no reference can be taken.
+ */
+static __always_inline bool __page_ref_add_unless_zero(atomic_t *v, int nr)
+{
+	instrument_atomic_read_write(v, sizeof(*v));
+	return arch_atomic_fetch_add_unless_nofault(v, nr, 0, fault) != 0;
+fault:
+	return false;
+}
+#else
+static __always_inline bool __page_ref_add_unless_zero(atomic_t *v, int nr)
+{
+	return atomic_add_unless(v, nr, 0);
+}
+#endif
+
 static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
-	bool ret = atomic_add_unless(&page->_refcount, nr, 0);
+	bool ret = __page_ref_add_unless_zero(&page->_refcount, nr);
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
 		__page_ref_mod_unless(page, nr, ret);
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

