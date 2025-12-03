Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2ECD1BDE0
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 20:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216846B0024; Wed,  3 Dec 2025 15:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE7A6B0026; Wed,  3 Dec 2025 15:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104BA6B0027; Wed,  3 Dec 2025 15:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECF6D6B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:59:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42736C02CB
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:59:15 +0000 (UTC)
X-FDA: 84179375070.13.98FB98E
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6204F10000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:59:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qnAp8GJa;
	spf=pass (imf14.hostedemail.com: domain of 3oKQwaQoKCPsydqqdsxuyhjrrjoh.frpolqx0-ppnydfn.ruj@flex--vannapurve.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3oKQwaQoKCPsydqqdsxuyhjrrjoh.frpolqx0-ppnydfn.ruj@flex--vannapurve.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764795553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CuKlIZ5iIgOGG+KuOjRyhdKbJzg1JAHIwuvpJYHoyE=;
	b=qgApfwXM49ygNzo8yzkir4UUxRxXjVve54g5AdCOI/KRclxf4yyRq4YUnZSk0VaoPtmbnV
	oj45Y8Jgzz3JHd+BZEz0GzTzhEhcmFBf2ln0MQc8+E3WTcinHihbL0KG7OQyY3USytX+MT
	0DJGBMYg2+34j6haK0OYsmy3fRnfOuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764795553; a=rsa-sha256;
	cv=none;
	b=Q3EfkUg/6qe3OaWpQXl1R9JklrwsQN/S5cjcXrYf+i8OLUVRmriTZYF1FANGu9nveczzBJ
	CYiOey1RyhCykiot4mCVdP/szg490ownEkk967qTKKJDsV1vqCeX5Q/VX88BxETtpRWe8I
	3fHYkhc7U7iCHoS+o4ErIhvNIixx+nI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qnAp8GJa;
	spf=pass (imf14.hostedemail.com: domain of 3oKQwaQoKCPsydqqdsxuyhjrrjoh.frpolqx0-ppnydfn.ruj@flex--vannapurve.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3oKQwaQoKCPsydqqdsxuyhjrrjoh.frpolqx0-ppnydfn.ruj@flex--vannapurve.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7be94e1a073so265552b3a.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 12:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764795552; x=1765400352; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8CuKlIZ5iIgOGG+KuOjRyhdKbJzg1JAHIwuvpJYHoyE=;
        b=qnAp8GJacssZEV3uyT3N0dElnvAgXIWrpSHAVsPPxLL/0G5ITvw6JyEL6flejCo8Dy
         08Qw+R6o2tRBnr/UfcsURIplK1hpyG+dJzCxlaeT8Bsx0buCHALr3KRJ8JLvC4QxOmxg
         mpkkIEQgBQCg4z9x6Y8d4n5Wu+WgS6oHInB1WmCrvRwQ2jHWjdms4xD0rfq6d/ohVn7z
         VKv8WAuW1V1z/aqqblRWcV3o/2wXnew5HOJMH5rC10KpZDeGTPP/sjhM+m3AEqdbWrey
         tGxqz4gvOVeKYqlf+CdtzdzJnJQerL8yNRs3MBRAfWt6Wfv76rGvwCnGqZX48uKVO8c+
         xkHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764795552; x=1765400352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8CuKlIZ5iIgOGG+KuOjRyhdKbJzg1JAHIwuvpJYHoyE=;
        b=MOgfH1ypRAmRaRr4QLY+JoR0MuBBlKaJHMOoxRYxixdeD27IWJRgNE7Fw1X7JsXcXN
         tG9WLr+Ht3DQfQmjxbc0Y5Nwdbty9eLniodx8gvurnrpfl2Jj4zM+Xxrtd9PuZcPY/M7
         uJxrW5TRzHxKqhtrYM5TY8fCl0iAfn6JlqQNVCr0rkzy9GJGBlXoBLAmC/MoApr07yRA
         lEaIujdoAUCHpBJkokniCpukz3ISuYGz/NzrDx8m84MSZal4lukvd3p8LGc06H67sYUo
         lXFy0dkpWql6c4u4ypXuZKE5B9Bl1SNNb8DTrqSte32nM51okHOVznEo5Aqw8MGrYMfR
         zikg==
X-Forwarded-Encrypted: i=1; AJvYcCX4F6gVXMvkr7YasMs7jJL2Y/kdIphSvo8LkCFSOBAlaUwJnSPiB7AmNF+jXIG6k9jfjaABqG0aYQ==@kvack.org
X-Gm-Message-State: AOJu0YzEvjzbwVUv50yZB5cZyTm05xWl87NsDd36j5d362twyYGDpnCo
	sFQpDdcZXjOSYkxxiSvndG+Ye5+bIy2Klf1rMKH/fMh8rDsYZgEanLzma9ztu7ell06m8oaRWbw
	evZ16WSfUB16uiSVU7VKUVA==
X-Google-Smtp-Source: AGHT+IH1iQ2PjW83GYpO/CxiZCWCCZIgWQJ2kgkTIgk+amH2HIHZrxGLOOQcwZH2Zp013X1ysYLDrxgEDjNA/62e
X-Received: from pgfw6.prod.google.com ([2002:a63:c106:0:b0:bd9:a349:94bd])
 (user=vannapurve job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:999c:b0:34f:ec81:bc3d with SMTP id adf61e73a8af0-363f5e95a0bmr5155444637.44.1764795552080;
 Wed, 03 Dec 2025 12:59:12 -0800 (PST)
Date: Wed,  3 Dec 2025 20:59:10 +0000
In-Reply-To: <20251203142648.trx6sslxvxr26yzd@amd.com>
Mime-Version: 1.0
References: <20251203142648.trx6sslxvxr26yzd@amd.com>
X-Mailer: git-send-email 2.52.0.177.g9f829587af-goog
Message-ID: <20251203205910.1137445-1-vannapurve@google.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
From: FirstName LastName <vannapurve@google.com>
To: michael.roth@amd.com
Cc: ackerleytng@google.com, aik@amd.com, ashish.kalra@amd.com, 
	david@redhat.com, ira.weiny@intel.com, kvm@vger.kernel.org, 
	liam.merwick@oracle.com, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	seanjc@google.com, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6204F10000D
X-Stat-Signature: 6dyrg5yqn9o3pqmu1qebbuknqu3kepfe
X-Rspam-User: 
X-HE-Tag: 1764795553-632411
X-HE-Meta: U2FsdGVkX1+CDNkAuDgnFsqCo7yxsa9TjQCyutWJKKxinGlzlsm0phx8L8aIVktxjZCtEudOWzo+xteVHhy5eUDtzItaxEcn6irI3dzGjJkJz6MxM64dqxbYDjUFbXaywmzrHfH60ntxq8U7TY5Wx3oyP+nZFG86FoLSxxQnxenM3f9Vg0Ohx2jB3/0R213h9ApJ9gTqWx54GDUJZhsws43V2vEcFgJ3bpcbyCyBXBPJfncryWk9fGmqepSJHN6Kc0Jkz/YCMH0AmauJhaFuqHArWMaUYGxRBJHPRaWrJKiTs6GLR7vYwpqvIjv/q7qPJ19WwkcvIp5tlR9t2mbIbVN4fAVQKcbDKd743s6YvUXEOpVjoQK6iujTb32E0C083HFg0P3QVAROsCtDc11ow+AdlHEZ2eHXCdrpZFyPfq4paKFs5/IJCfPigxfAbnD2KmwPQuHOyYTmhsCT/iWPzyy05H5OOV7LWcNreMaC6k7BJc2TUgwMiMpWi8jo1IiuuROxxXDJQrW+d3OI5uqrK+/cEq3kFscCnuSulVfzsACB1U3yo9OT3oDR9UCH5e0xBYmqU1FNfNVQtOhpq0T9kXokzlGy9tV4VhTEvKnJxund9BFt1ebfYikg6sGCY8Sqs+U9LeUousPj9+FWNx7euP2WUc8+KdIdvMQksneH0w8499IEo8R1Hf6/jtalGLoEOkH+wMGLFt+wm66XLq7A786BmMI1X+cOryK80ZTAIjEIhd8HAdvzbkWapONnutAu1jjNKvyQB1/seGAFP281ckdSe31qQ80371gBt9PhetBw+WrrC3F8cv++A31ybN1qw3tHLnYq9t8JT6Dk50yP09K3f3myM3FQ7aaxLjb9mb8B17y6R0yeIG0+XtRRtOWolLcC1skmY4TMAZc0dwkPrC2kq0vW8obYLVLA1eePYtEhfzCTnmpLtVJIqlhjRNSPeQzl5nAf9MlMaG9JG6R
 MeQc5igB
 dwxElKgM4tTpNYZ6UeRmaqnme9yODT8QhvXXFyL6/cR3Ah4fZbTcRBM+bdyRLp/a+/9VN2UYqgV16Y5/+d7smPmwSWXxWSkcGCdB5y3SB9GRApIm7sASogm8aTpjlnrPd93LqJ8HUpc9ad+q4iH8yq8GxtwxWp1K+iFd3Y24/yNVhs5xl7HsShHuq+wdrf+S4/JVBQUY0PoMXCAvrsaQKPL5CbCo0w2/ZbYLy0V0uhH4HcBu+L6MCEAJATmHX3p03RwiBxqrjATuiGjDBgIG0Ad+jJOeDN+vi83T55os7LFamx29IiE3HsXjayl/Y5EW9gpU6wCxb1H3gCSyoW+67LPiB/J7KgSigUyGSH9we0dCwYRfy5wKYYF1n7Vv50nBVAhysyC/Pm4edNfOZnFvaS1bsEbJOCzAm8ySqo9g3iueiiWui8NL1H45lgKrs/qe9tuE58xfmpULYiNlTfFXSG/xeT3LqoGfr4poWu2Zk2AwTBrD+G3Uy0CE3XMVo7W4RuyQwbJGj8pTaXW5qQpUpK65xdifMYNzlTtrJ2lY70Tok6ThKrnsS7sTiVmJ28MMmM7xXotEgAho65Rh1jHN8eNS4Ubf43qwbONm1jRX+UEVeh8lvEIFaPNKjcbqxqOQDkoUC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > > but it makes a lot more sense to make those restrictions and changes in
> > > the context of hugepage support, rather than this series which is trying
> > > very hard to not do hugepage enablement, but simply keep what's partially
> > > there intact while reworking other things that have proven to be
> > > continued impediments to both in-place conversion and hugepage
> > > enablement.
> > Not sure how fixing the warning in this series could impede hugepage enabling :)
> >
> > But if you prefer, I don't mind keeping it locally for longer.
>
> It's the whole burden of needing to anticipate hugepage design, while it
> is in a state of potentially massive flux just before LPC, in order to
> make tiny incremental progress toward enabling in-place conversion,
> which is something I think we can get upstream much sooner. Look at your
> changelog for the change above, for instance: it has no relevance in the
> context of this series. What do I put in its place? Bug reports about
> my experimental tree? It's just not the right place to try to justify
> these changes.
>
> And most of this weirdness stems from the fact that we prematurely added
> partial hugepage enablement to begin with. Let's not repeat these mistakes,
> and address changes in the proper context where we know they make sense.
>
> I considered stripping out the existing hugepage support as a pre-patch
> to avoid leaving these uncertainties in place while we are reworking
> things, but it felt like needless churn. But that's where I'm coming

I think simplifying this implementation to handle populate at 4K pages is worth
considering at this stage and we could optimize for huge page granularity
population in future based on the need.

e.g. 4K page based population logic will keep things simple and can be
further simplified if we can add PAGE_ALIGNED(params.uaddr) restriction.
Extending Sean's suggestion earlier, compile tested only.

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..224e79ab8f86 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2267,66 +2267,56 @@ struct sev_gmem_populate_args {
 	int fw_error;
 };
 
-static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
-				  void __user *src, int order, void *opaque)
+static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				  struct page *src_page, void *opaque)
 {
 	struct sev_gmem_populate_args *sev_populate_args = opaque;
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
-	int n_private = 0, ret, i;
-	int npages = (1 << order);
-	gfn_t gfn;
+	int ret;
 
-	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
+	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
 		return -EINVAL;
 
-	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
-		struct sev_data_snp_launch_update fw_args = {0};
-		bool assigned = false;
-		int level;
-
-		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
-		if (ret || assigned) {
-			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
-				 __func__, gfn, ret, assigned);
-			ret = ret ? -EINVAL : -EEXIST;
-			goto err;
-		}
+	struct sev_data_snp_launch_update fw_args = {0};
+	bool assigned = false;
+	int level;
 
-		if (src) {
-			void *vaddr = kmap_local_pfn(pfn + i);
+	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
+	if (ret || assigned) {
+		pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
+			 __func__, gfn, ret, assigned);
+		ret = ret ? -EINVAL : -EEXIST;
+		goto err;
+	}
 
-			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
-				ret = -EFAULT;
-				goto err;
-			}
-			kunmap_local(vaddr);
-		}
+	if (src_page) {
+		void *vaddr = kmap_local_pfn(pfn);
 
-		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
-				       sev_get_asid(kvm), true);
-		if (ret)
-			goto err;
+		memcpy(vaddr, page_address(src_page), PAGE_SIZE);
+		kunmap_local(vaddr);
+	}
 
-		n_private++;
+	ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+			       sev_get_asid(kvm), true);
+	if (ret)
+		goto err;
 
-		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
-		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
-		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
-		fw_args.page_type = sev_populate_args->type;
+	fw_args.gctx_paddr = __psp_pa(sev->snp_context);
+	fw_args.address = __sme_set(pfn_to_hpa(pfn));
+	fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+	fw_args.page_type = sev_populate_args->type;
 
-		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
-				      &fw_args, &sev_populate_args->fw_error);
-		if (ret)
-			goto fw_err;
-	}
+	ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+			      &fw_args, &sev_populate_args->fw_error);
+	if (ret)
+		goto fw_err;
 
 	return 0;
 
 fw_err:
 	/*
 	 * If the firmware command failed handle the reclaim and cleanup of that
-	 * PFN specially vs. prior pages which can be cleaned up below without
-	 * needing to reclaim in advance.
+	 * PFN specially.
 	 *
 	 * Additionally, when invalid CPUID function entries are detected,
 	 * firmware writes the expected values into the page and leaves it
@@ -2336,25 +2326,18 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 	 * information to provide information on which CPUID leaves/fields
 	 * failed CPUID validation.
 	 */
-	if (!snp_page_reclaim(kvm, pfn + i) &&
+	if (!snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
 	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
-		void *vaddr = kmap_local_pfn(pfn + i);
-
-		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
-			pr_debug("Failed to write CPUID page back to userspace\n");
+		void *vaddr = kmap_local_pfn(pfn);
 
+		memcpy(page_address(src_page), vaddr, PAGE_SIZE);
 		kunmap_local(vaddr);
 	}
 
-	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
-	n_private--;
-
 err:
-	pr_debug("%s: exiting with error ret %d (fw_error %d), restoring %d gmem PFNs to shared.\n",
-		 __func__, ret, sev_populate_args->fw_error, n_private);
-	for (i = 0; i < n_private; i++)
-		kvm_rmp_make_shared(kvm, pfn + i, PG_LEVEL_4K);
+	pr_debug("%s: exiting with error ret %d (fw_error %d)\n",
+		 __func__, ret, sev_populate_args->fw_error);
 
 	return ret;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..acdcb802d9f2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3118,34 +3118,21 @@ struct tdx_gmem_post_populate_arg {
 };
 
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, int order, void *_arg)
+				  struct page *src_page, void *_arg)
 {
 	struct tdx_gmem_post_populate_arg *arg = _arg;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err, entry, level_state;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	struct page *src_page;
-	int ret, i;
+	int ret;
 
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	/*
-	 * Get the source page if it has been faulted in. Return failure if the
-	 * source page has been swapped out or unmapped in primary memory.
-	 */
-	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
-	if (ret < 0)
-		return ret;
-	if (ret != 1)
-		return -ENOMEM;
-
 	kvm_tdx->page_add_src = src_page;
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	kvm_tdx->page_add_src = NULL;
 
-	put_page(src_page);
-
 	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
 		return ret;
 
@@ -3156,11 +3143,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 * mmu_notifier events can't reach S-EPT entries, and KVM's internal
 	 * zapping flows are mutually exclusive with S-EPT mappings.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
-		if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
-			return -EIO;
-	}
+	err = tdh_mr_extend(&kvm_tdx->td, gpa, &entry, &level_state);
+	if (TDX_BUG_ON_2(err, TDH_MR_EXTEND, entry, level_state, kvm))
+		return -EIO;
 
 	return 0;
 }
@@ -3196,38 +3181,26 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 		return -EINVAL;
 
 	ret = 0;
-	while (region.nr_pages) {
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-
-		arg = (struct tdx_gmem_post_populate_arg) {
-			.vcpu = vcpu,
-			.flags = cmd->flags,
-		};
-		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
-					     u64_to_user_ptr(region.source_addr),
-					     1, tdx_gmem_post_populate, &arg);
-		if (gmem_ret < 0) {
-			ret = gmem_ret;
-			break;
-		}
+	arg = (struct tdx_gmem_post_populate_arg) {
+		.vcpu = vcpu,
+		.flags = cmd->flags,
+	};
+	gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
+				     u64_to_user_ptr(region.source_addr),
+				     region.nr_pages, tdx_gmem_post_populate, &arg);
+	if (gmem_ret < 0)
+		ret = gmem_ret;
 
-		if (gmem_ret != 1) {
-			ret = -EIO;
-			break;
-		}
+	if (gmem_ret != region.nr_pages)
+		ret = -EIO;
 
-		region.source_addr += PAGE_SIZE;
-		region.gpa += PAGE_SIZE;
-		region.nr_pages--;
+	if (gmem_ret >= 0) {
+		region.source_addr += gmem_ret * PAGE_SIZE;
+		region.gpa += gmem_ret * PAGE_SIZE;
 
-		cond_resched();
+		if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
+			ret = -EFAULT;
 	}
-
-	if (copy_to_user(u64_to_user_ptr(cmd->data), &region, sizeof(region)))
-		ret = -EFAULT;
 	return ret;
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..263e75f90e91 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2581,7 +2581,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * Returns the number of pages that were populated.
  */
 typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				    void __user *src, int order, void *opaque);
+				    struct page *src_page, void *opaque);
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2e62bf882aa8..550dc818748b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -85,7 +85,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
 static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
-	unsigned long nr_pages, i;
 	pgoff_t index;
 
 	/*
@@ -794,7 +793,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return PTR_ERR(folio);
 
 	if (!folio_test_uptodate(folio)) {
-		clear_huge_page(&folio->page, 0, folio_nr_pages(folio));
+		clear_highpage(folio_page(folio, 0));
 		folio_mark_uptodate(folio);
 	}
 
@@ -812,13 +811,54 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
+				struct file *file, gfn_t gfn, struct page *src_page,
+				kvm_gmem_populate_cb post_populate, void *opaque)
+{
+	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct gmem_inode *gi;
+	struct folio *folio;
+	int ret, max_order;
+	kvm_pfn_t pfn;
+
+	gi = GMEM_I(file_inode(file));
+
+	filemap_invalidate_lock(file->f_mapping);
+
+	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
+		goto out_unlock;
+	}
+
+	folio_unlock(folio);
+
+	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
+				KVM_MEMORY_ATTRIBUTE_PRIVATE,
+				KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		ret = -EINVAL;
+		goto out_put_folio;
+	}
+
+	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
+	if (!ret)
+		folio_mark_uptodate(folio);
+
+out_put_folio:
+	folio_put(folio);
+out_unlock:
+	filemap_invalidate_unlock(file->f_mapping);
+	return ret;
+}
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
+	struct page *src_aligned_page = NULL;
 	struct kvm_memory_slot *slot;
+	struct page *src_page = NULL;
 	void __user *p;
-
-	int ret = 0, max_order;
+	int ret = 0;
 	long i;
 
 	lockdep_assert_held(&kvm->slots_lock);
@@ -834,52 +874,50 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock(file->f_mapping);
+	if (src && !PAGE_ALIGNED(src)) {
+		src_page = alloc_page(GFP_KERNEL_ACCOUNT);
+		if (!src_page)
+			return -ENOMEM;
+	}
 
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
-	for (i = 0; i < npages; i += (1 << max_order)) {
-		struct folio *folio;
-		gfn_t gfn = start_gfn + i;
-		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		kvm_pfn_t pfn;
-
+	for (i = 0; i < npages; i++) {
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
-		if (IS_ERR(folio)) {
-			ret = PTR_ERR(folio);
-			break;
-		}
-
-		folio_unlock(folio);
-		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
-			(npages - i) < (1 << max_order));
+		p = src ? src + i * PAGE_SIZE : NULL;
 
-		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
-							KVM_MEMORY_ATTRIBUTE_PRIVATE,
-							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
-			if (!max_order)
-				goto put_folio_and_exit;
-			max_order--;
+		if (p) {
+			if (src_page) {
+				if (copy_from_user(page_address(src_page), p, PAGE_SIZE)) {
+					ret = -EFAULT;
+					break;
+				}
+				src_aligned_page = src_page;
+			} else {
+				ret = get_user_pages((unsigned long)p, 1, 0, &src_aligned_page);
+				if (ret < 0)
+					break;
+				if (ret != 1) {
+					ret = -ENOMEM;
+					break;
+				}
+			}
 		}
 
-		p = src ? src + i * PAGE_SIZE : NULL;
-		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
-		if (!ret)
-			folio_mark_uptodate(folio);
+		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, src_aligned_page,
+					  post_populate, opaque);
+		if (p && !src_page)
+			put_page(src_aligned_page);
 
-put_folio_and_exit:
-		folio_put(folio);
 		if (ret)
 			break;
 	}
 
-	filemap_invalidate_unlock(file->f_mapping);
-
+	if (src_page)
+		__free_page(src_page);
 	return ret && !i ? ret : i;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
-- 
2.52.0.177.g9f829587af-goog


