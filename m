Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F39E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 03:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59DFA6B0088; Sun, 21 Dec 2025 22:19:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57EA26B0089; Sun, 21 Dec 2025 22:19:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49E2A6B008A; Sun, 21 Dec 2025 22:19:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3471C6B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 22:19:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE9B81609E5
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:19:44 +0000 (UTC)
X-FDA: 84245652288.10.04E8E2E
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id EA879180002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 03:19:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gV6/4V5n";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766373583; a=rsa-sha256;
	cv=none;
	b=s2yyhy1yH3FdDOHSf4nhsOmU2+BXGj8XdA9rJ9yRzwMlpp7/x0aUPhJUvYtipPI6odTMI1
	QAHD+3LS80zTrmstlRSCjflBhIOXhOOzd7BgzB+OCIZKs1vl9fl8A6mpIaNECodnH1zSUh
	n0rBrSEiZVkHj6oHav5F75av5RE2JME=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gV6/4V5n";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766373583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GmlPOC1P0AM0GDfDwLCyARMYoCDX/JlrqGabW/rzIU=;
	b=fPdkL+oBOX7if3qOvarCWkNQJIX+cqejypXzK8/B75qFZqlvGggaBGdgBD5hMvFwPVwvHO
	zx2YKuVAz/Ps0YpCtOGsDcmPAVoQ0MJapPn+sssSUHyh1+Vqdgh7OZnAxGCAiZMWaly+d7
	Fsm+KvE1M9aLsXViH7jp3nRQFrG13W0=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7ba55660769so2753548b3a.1
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766373582; x=1766978382; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9GmlPOC1P0AM0GDfDwLCyARMYoCDX/JlrqGabW/rzIU=;
        b=gV6/4V5nJPBpxjqvKdAi6Y2Kv2WwV5Y1rTGPZ304a6h9F1k6SDwo60gZ/FtNQv9AJT
         HghQ5hK4i1xRIw9ZY6l+ET5eA3glEblQl1QvgP8exFuY+tMYWZG9c3WBEt5dNVz/uTzH
         yifQbyoI5lSZcO1Jj8ob8oJsBogDuk7BeU6aRa9JCtgvC7mVNDwbBLPEpj08b6N7mTEx
         bTE+NLFduTcOmN+xNI+svkXMe4h0cvPgKTvALavxywCKzbOw+e2EuY3tGF/3YJRIr4Is
         NBwsHijNQk/0/uNr8IAC6dQ0ZljtRtvwSG9Sa3Sz2MuB3VEDb/rqPLuz0Biz/nP2yTk6
         LQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766373582; x=1766978382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9GmlPOC1P0AM0GDfDwLCyARMYoCDX/JlrqGabW/rzIU=;
        b=NVybhjc+07Hofjcu+PA688oLu78bYdg1wvs7YZFD6Ma4GKW8NP38vRnADfKCnA4GXS
         lVB0jQWaUsorliCWuRq4MlD+pdO5JvyJusPWhAg3FngCjHgBtmEJ9jc8N391yNBJy/vE
         XtYVnLXQY8weSEkMg86LXKTFaAqZ4kayaea/NtfqyEPcvVaS3w+4ysJUGpdxspMpX9xb
         dhN0rkZMdy6zY43v1CCdWJ1SuyOx6ZfzQHgz7DeMlSGxIMMf7w+wDIm+nK3YY7ywlU8V
         ZVb9vSneiz76Vo98j8O/zrZ+3mMqP9f/DCARugBZO0l0/foRuOHFoGWK3wlksOm1JDx+
         U8/w==
X-Forwarded-Encrypted: i=1; AJvYcCXvvH6w5qSjn/et2v28VBopgFuf5ihKVTCDWQ6SQRDpHCNuNfmn5U2ZHkKcHIbVF5TX2wiMqZPoKA==@kvack.org
X-Gm-Message-State: AOJu0Yxxs9kr/EKFmwKz7MFI87u3VSpB1V99V/3XTJUQGGlol6M2qNxD
	d49okImMXitaZq2+UbwyU/vT/cnwRNyQ9zviVRtUTxf9GqQ8Eqsdovbv
X-Gm-Gg: AY/fxX5RGMckd5HCJyX2gLg8EEC8YeCFqkrjXJrGdQXKb11/lP5QQp6Sb2n2jIDxwJr
	MS+ehNk8w8LonPnFvckbOusOyuuY4PNaCHSjAUwKykjnDH/Wfw+KizchvojI69kWSKcSsGYrq5w
	lKAgGRL6mSyQHJztRBVaLJqVD0cIQH3doux9vrYgjxaW7PkTU8YsVW++YIYtcbmoMS5X77IjQ8E
	HpQrJqcnvcF4hsFogy7wi64g17zQTRWv3+zC31vERrtxw3/88nRGnetWW/oVNu6cTm/Vn81nej5
	ZWVnZ8lD2/HLexTlNseH1dxk8+OJf5CaAUIGg5m7WMM/Nnb4hnk4OpcXNbf0wDAIz7Plq7cEb/I
	BYCQSZOpLa+pzhjVkNE3ZaRxUGG/jUoZvbLzPBpDRuSI+S5Wp0wMhoaZSryLOynN1HxAGZf/cRd
	x7XxrYu8eVMaEeTSGRRhM=
X-Google-Smtp-Source: AGHT+IGhp8ZTBsTDENWrru9arl6O4MqGzyl9sqpGRfkDR76L/XfuVadL6vRq18Zl3e3t0t/ZUDjAYg==
X-Received: by 2002:a05:6300:2109:b0:366:14b0:4b0e with SMTP id adf61e73a8af0-376aabf93ddmr9390466637.74.1766373581676;
        Sun, 21 Dec 2025 19:19:41 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.113])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d4d2bbsm82226215ad.55.2025.12.21.19.19.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 21 Dec 2025 19:19:41 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: david@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	arnd@arndb.de,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	dev.jain@arm.com,
	hpa@zytor.com,
	ioworker0@gmail.com,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	npache@redhat.com,
	npiggin@gmail.com,
	peterz@infradead.org,
	riel@surriel.com,
	ryan.roberts@arm.com,
	shy828301@gmail.com,
	tglx@linutronix.de,
	will@kernel.org,
	x86@kernel.org,
	ziy@nvidia.com
Subject: Re: [PATCH RFC 2/3] x86/mm: implement redundant IPI elimination for
Date: Mon, 22 Dec 2025 11:19:19 +0800
Message-ID: <20251222031919.41964-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <c36501bc-2690-4ed2-b85e-13e64c41baaf@kernel.org>
References: <c36501bc-2690-4ed2-b85e-13e64c41baaf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA879180002
X-Rspamd-Server: rspam03
X-Stat-Signature: qwd5o79cycs89w1csaogh6quaemi91pd
X-Rspam-User: 
X-HE-Tag: 1766373582-877478
X-HE-Meta: U2FsdGVkX18JyEhcwOuZgRq+Ui6PFdwfyh1w3GiMoauyZyzbFOPkTInec0sLGIvDmKHMkwMx5svk6Bgl137nAtah+uWMgTfQfXrt9udYkFyAp53yFRHsAdtQftJmtmNz/ZNFM49rH2PcN+DzcIfwmjoy8L1F9xgapja0eUrFrd8d71O+1TBeArFv28zO1n7M0j0trcasiN6yPGFhLM88VONyvXcuamSVOCZJLyKE775RsH/HAZngcgLfmx1m7dfDNpwo/sYtLv5xD+RYV9g2rZ7ONcP5cGfVYTpjw82V2LV7JcMlCthOgEhJjqJW+lEFhfiQ81NgHNJVlZO9i1kF5caV73SmjgBnBr3sBVS0sqITO+9P6eAhojTXW21oGGhTwsbSIAuwfZkn6RddbQGvYru9yb6QZl/0VLwhY84h/2w8ok0sNrg2Mmew/MyYj1e1PROA1zc7FG25NL2p0lTV/XpR+eLCahDeBCa9ETPqdVHq/F7vCGhw01jZvtDORDOni++XhwtYWS2hvD84V2RKZMyv3d+jIbeZTvQL/JZLJ+0qPrv3E3ePRuT/95v4yFvxet0WP50OvVFvgLl8koImrTmGFA7SM34BU4Ii6qCf7oN5fKKr3jDkfO2QlYg+s+Kpjp9dTjeF0Au6FpifHteJsmJQVmfZnpIBObPyudto1TxTfuNZy5tjt9Untn1oBbEDf18LA5/TMBdfu5XNebAtnW2JQch30FFrgho0PRVCJbthmgVVszKfRd1IbClqdqJeOLyPR9srt7Z/UcLYQnMSYL9PdeSlvOK9gGDcB+S3amJ+izlsunr3MHZKyfpqiazMCqpsLasLFdpWyfnlmBhD9wuRvJHCEaZcRzZc5yItepu9SdZiPHIMgPedwf0cT4NXFNP6qapA3aZRIK/b9vG86QC88RovJlF4DUkwUJbESoMZ1h5JRVqKVq2Mp7/KIzB3YKA6/iQkwuL9vFIqhP/
 HWFBM6NC
 pu78MQd7C7GMzpVR3OXQe7Oc0z1fTKTCeU3Yw+CdiQpplPaLrBQmnfNY7wEjO2HcoU+r/AupFuUEP/2zG4512aBvo4CDXnLNcklojckImkYXd7oVNzRSfJVHXxrCPmA5tMHhXlPwhThZ4wv8RgAeaMMMHG8M8Dm2GRNrIvRHPzuTdVWRZPYkdSwW4luLs2oB4coqHGYmAvAAM3tw6czVUQuatoPGFJf/1Uz7pzERCaJDFWhSPOzg58QOGaMdpEwX9svxiw9ZV6Z/mDIDHVJj6OBRahOJw9QfBdwRIT4I+oiQtPFUycWsxliX/Z8EOAYMEu4BCrSSgs5B0xX9Cvd2sHY5C2HzUN+LY6uC9OaAundg4m5uN2TIuZPdSg6cv3fTEmxNg7GoIwfVbOMc6g8C34Pxz7nP09bPayozO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Thu, 18 Dec 2025 14:08:07 +0100, David Hildenbrand (Red Hat) wrote:
> On 12/13/25 09:00, Lance Yang wrote:
> > From: Lance Yang <lance.yang@linux.dev>
> > 
> > Pass both freed_tables and unshared_tables to flush_tlb_mm_range() to
> > ensure lazy-TLB CPUs receive IPIs and flush their paging-structure caches:
> > 
> > 	flush_tlb_mm_range(..., freed_tables || unshared_tables);
> > 
> > Implement tlb_table_flush_implies_ipi_broadcast() for x86: on native x86
> > without paravirt or INVLPGB, the TLB flush IPI already provides necessary
> > synchronization, allowing the second IPI to be skipped. For paravirt with
> > non-native flush_tlb_multi and for INVLPGB, conservatively keep both IPIs.
> > 
> > Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > ---
> >   arch/x86/include/asm/tlb.h | 17 ++++++++++++++++-
> >   1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
> > index 866ea78ba156..96602b7b7210 100644
> > --- a/arch/x86/include/asm/tlb.h
> > +++ b/arch/x86/include/asm/tlb.h
> > @@ -5,10 +5,24 @@
> >   #define tlb_flush tlb_flush
> >   static inline void tlb_flush(struct mmu_gather *tlb);
> >   
> > +#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
> > +static inline bool tlb_table_flush_implies_ipi_broadcast(void);
> > +
> >   #include <asm-generic/tlb.h>
> >   #include <linux/kernel.h>
> >   #include <vdso/bits.h>
> >   #include <vdso/page.h>
> > +#include <asm/paravirt.h>
> > +
> > +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
> > +{
> > +#ifdef CONFIG_PARAVIRT
> > +	/* Paravirt may use hypercalls that don't send real IPIs. */
> > +	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
> > +		return false;
> > +#endif
> > +	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
> 
> Right, here I was wondering whether we should have a new pv_ops callback 
> to indicate that instead.
> 
> pv_ops.mmu.tlb_table_flush_implies_ipi_broadcast()
> 
> Or a simple boolean property that pv init code properly sets.

Cool!

> 
> Something for x86 folks to give suggestions for. :)

I prefer to use a boolean property instead of comparing function pointers.
Something like this:

----8<----
diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
index cfcb60468b01..90e9da33f2c7 100644
--- a/arch/x86/hyperv/mmu.c
+++ b/arch/x86/hyperv/mmu.c
@@ -243,4 +243,5 @@ void hyperv_setup_mmu_ops(void)

 	pr_info("Using hypercall for remote TLB flush\n");
 	pv_ops.mmu.flush_tlb_multi = hyperv_flush_tlb_multi;
+	pv_ops.mmu.tlb_flush_implies_ipi_broadcast = false;
 }
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 3502939415ad..f9756df6f3f6 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -133,6 +133,19 @@ struct pv_mmu_ops {
 	void (*flush_tlb_multi)(const struct cpumask *cpus,
 				const struct flush_tlb_info *info);

+	/*
+	 * Indicates whether TLB flush IPIs provide sufficient synchronization
+	 * for GUP-fast when freeing or unsharing page tables.
+	 *
+	 * Set to true only when the TLB flush guarantees:
+	 * - IPIs reach all CPUs with potentially stale paging-structure caches
+	 * - Synchronization with IRQ-disabled code like GUP-fast
+	 *
+	 * Paravirt implementations that use hypercalls (which may not send
+	 * real IPIs) should set this to false.
+	 */
+	bool tlb_flush_implies_ipi_broadcast;
+
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
 	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, bool enc);
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 96602b7b7210..9d20ad4786cc 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -18,7 +18,7 @@ static inline bool tlb_table_flush_implies_ipi_broadcast(void)
 {
 #ifdef CONFIG_PARAVIRT
 	/* Paravirt may use hypercalls that don't send real IPIs. */
-	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
+	if (!pv_ops.mmu.tlb_flush_implies_ipi_broadcast)
 		return false;
 #endif
 	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index df78ddee0abb..aaea83100105 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -843,6 +843,7 @@ static void __init kvm_guest_init(void)
 #ifdef CONFIG_SMP
 	if (pv_tlb_flush_supported()) {
 		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
+		pv_ops.mmu.tlb_flush_implies_ipi_broadcast = false;
 		pr_info("KVM setup pv remote TLB flush\n");
 	}

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..625fe93e138a 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -173,6 +173,7 @@ struct paravirt_patch_template pv_ops = {
 	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
 	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
 	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
+	.mmu.tlb_flush_implies_ipi_broadcast = true,

 	.mmu.exit_mmap		= paravirt_nop,
 	.mmu.notify_page_enc_status_changed	= paravirt_nop,
diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
index 7a35c3393df4..06eb80cfb4da 100644
--- a/arch/x86/xen/mmu_pv.c
+++ b/arch/x86/xen/mmu_pv.c
@@ -2185,6 +2185,7 @@ static const typeof(pv_ops) xen_mmu_ops __initconst = {
 		.flush_tlb_kernel = xen_flush_tlb,
 		.flush_tlb_one_user = xen_flush_tlb_one_user,
 		.flush_tlb_multi = xen_flush_tlb_multi,
+		.tlb_flush_implies_ipi_broadcast = false,

 		.pgd_alloc = xen_pgd_alloc,
 		.pgd_free = xen_pgd_free,
---

Native x86 sets it to true, paravirt guests (Xen/KVM/Hyper-V) set it to
false. Making the intent explicit :)

Hopefully x86 folks can give me some suggestions!
 
Thanks,
Lance

