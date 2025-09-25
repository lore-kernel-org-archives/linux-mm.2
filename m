Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFA6CAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D05368E000B; Thu, 25 Sep 2025 10:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD758E0006; Thu, 25 Sep 2025 10:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF32C8E000B; Thu, 25 Sep 2025 10:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC8518E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:22:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74D8E1402CD
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:22:35 +0000 (UTC)
X-FDA: 83927988270.19.8B0BB5E
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id B8AFB160003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:22:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QCr9rrq+;
	spf=pass (imf08.hostedemail.com: domain of 3KFDVaAYKCGsbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3KFDVaAYKCGsbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758810153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SblUb3K9vKSfuIkumtnWvH3DVTbw+wxBSl+ZySJr9Gg=;
	b=nsUra+zIy3EBk3Hxz6erGk8jRnEdROCRWUqPfEjGHRAyXWDAgeHuMfkiyCwDc59frK3n6z
	Fu7+U8yB+YDQ08NJmyIVaVBNXEq6VJtsXEBBKd1prx9KeXFSsI77Z4hWciy6doTfi1DDgk
	VTO1KUUs7EsU7w8JZuDqu2dehdk3rLA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758810153; a=rsa-sha256;
	cv=none;
	b=aq2gPT6czhTLPZ07L3K53+iXUa26yXQYzH6g79ByfhFrG6Jd8XW18nrZB6KNV9jdnJzeoi
	mbWr5pDDQhk/LZbllZkoSiAIB1o5ZNSk+yKUnegHEVSkZ4MD3k6LPvv0cXMj2UQpEE1ZYQ
	dQD3fuTK4dqCtD8DvffG128Ki2OfXaI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QCr9rrq+;
	spf=pass (imf08.hostedemail.com: domain of 3KFDVaAYKCGsbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3KFDVaAYKCGsbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc49so1085623a91.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758810152; x=1759414952; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SblUb3K9vKSfuIkumtnWvH3DVTbw+wxBSl+ZySJr9Gg=;
        b=QCr9rrq+fkc2S+o3RpoKfVYPuF+o96iY4f9FuYGqxtG27fp/sO96xFA5v5G/INjDxR
         1KCqCbcY9MEgqfArr7Ov4J+gwtChfYNSpEi6cZbHvdDmy8gBEy5woXq00PE7YzOUKWmq
         u8U/8TNJeo1wbBP4yM+3DLIU3xttyrG90jNt/X8l5XRYnqeg2DmubQEjUJRbAGxYGDP/
         Yatveq2lPzVNolzJWOVWV1jknqPnX2luB+KdaC2rUjIQjnjbaOqDKwwmAI5ADyTmrRUv
         rd9JcVoD2U5WQTXmy+ju19bqM2QEIjQyp3Kmmb4tR7djzLGFJRQcWfKGZZ2MhlTL5J5/
         N9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758810152; x=1759414952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SblUb3K9vKSfuIkumtnWvH3DVTbw+wxBSl+ZySJr9Gg=;
        b=YXxVDrpJdw8jO4KX8RdcoWob62FXxKgdH0gOtLWYEVYpQWxPEi6z8I2Dv6LWpl5mOX
         RcDl2Xb0H1gkBFmwoDyri+y2x+laWABbLL2ZiXJ0Cvv3wa6uEfnkBftFjzZ+kiqJCs0I
         nox8x3Pf9EOBuUdm3DyZmoBP+ncnzPYyT+il0eqMAEdZxX4X2SHLEPTS5dswD1sgBUn5
         OdGssIk1ab7cUfZVJ96nEZN3rzgIcxkmgaOHYCTwLFtApH0IiTQWM9hqvypU98bQFIv2
         /Bktichf/OzK4EE+FGGiPuE1kDWABZpXZ09SOfRGzixoP67Ma8cR83QFuiLunValcqx+
         W9pA==
X-Forwarded-Encrypted: i=1; AJvYcCUYQeqVoCex9Jn07IyK+ds8HwgPvF/veHfSkfIYY7YrVDU93YK583xJyrVmBvmWP6fHXnW+rZwGfQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1iCWU6T0wvi5bJ3tSi0cgw5C6sXOx7a08KeWUtkPW5J8qpV2A
	wAfMAzgjTN64jF5T9k6Zs9UDZgMpWnASvNO2OBSeoyUQ51Toaxx7m4XwVUBImSOOO8LwGuzzccY
	0ati9bQ==
X-Google-Smtp-Source: AGHT+IH/f88NvvxTkAVG4DhhjQkTxFzTBsV5SbcgowW0+JrB9EElqsyS6+jWyWSmkD83IUsL47BQyHKSocQ=
X-Received: from pjbmj16.prod.google.com ([2002:a17:90b:3690:b0:32e:c154:c2f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5107:b0:32b:a311:d1ae
 with SMTP id 98e67ed59e1d1-334567a1c56mr2743555a91.10.1758810152121; Thu, 25
 Sep 2025 07:22:32 -0700 (PDT)
Date: Thu, 25 Sep 2025 07:22:30 -0700
In-Reply-To: <20250827175247.83322-9-shivankg@amd.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-9-shivankg@amd.com>
Message-ID: <aNVQJqYLX17v-fsf@google.com>
Subject: Re: [PATCH kvm-next V11 6/7] KVM: guest_memfd: Enforce NUMA mempolicy
 using shared policy
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@redhat.com, 
	pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, dsterba@suse.com, xiang@kernel.org, chao@kernel.org, 
	jaegeuk@kernel.org, clm@fb.com, josef@toxicpanda.com, 
	kent.overstreet@linux.dev, zbestahu@gmail.com, jefflexu@linux.alibaba.com, 
	dhavale@google.com, lihongbo22@huawei.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, tabba@google.com, 
	ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org, 
	serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, hch@infradead.org, 
	cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com, 
	roypat@amazon.co.uk, chao.p.peng@intel.com, amit@infradead.org, 
	ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com, 
	gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, 
	yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: 9z5kk8s5b3f9y4brcaxsbpdei6squo8o
X-Rspam-User: 
X-Rspamd-Queue-Id: B8AFB160003
X-Rspamd-Server: rspam10
X-HE-Tag: 1758810153-305370
X-HE-Meta: U2FsdGVkX1+82/donqgrQqCT1b2bbkGwOKYhIvmjdxnnvP6PDA3Unsc77o2XwihIm4Jc/TSKVTCxBkLEAimSVfR5AbJcAR11uP0tIZEB3CbiZ9Jc3N34FKzy9ioKn2gWgBhykUIgGQvpULIPCOjIJ1I0FPbiFt9LqzfogoN4qXIx6HQbckN4kF6ph8nhfGfbFikHVbP+qAydZdKivk9/cuqD+hXu+gNGrhYci5mZKo53Mp8mkgA0oKXSLnfWz6qB+QMelMAso6vHpSZfNO7D4y+2FmZU5ghxVj9FXggxk89yCZCkON8XajT7x+XjZimSsfdi03kO+tcZJI2PQF7BPXX5P4Jq7HVzeGf/oI6UOzfPlKPFVY/DsGR20ICcR71hs/2N+YBzJqeXobzECMCCsgJgkxB3evh6V1bVglbBJT7on6fTMBPx6KXtpZuydUnSUay4hkciIEUZJXqH91TyMSHzqgLVsD9VWmhjidsiwAJhclnW2WxuAvUhiWtuBT2my7H5PeBsGGtufnsP4cg1WXUxRITtEOVrObORpvqbJr1s2Mon4IBR7vZ77tqGieulTnaboBP28Lmk+KSzZ23wyrYuhItaqthz6czF1plB6SjSjxxQaptP7pnAxE6ur4pnHb48cDZRRmryzE9T8SHFYnv0p96glGG33YvzahypxaadO95mC/WXLhkpPapIReUyYnv4XgVTfpIUE6ECFT01XQQqG03CadvgdoIbC2LSRBXA7I73BhdaxQabQVr/n36mAwrEUnYPuyVjZdIcDdpjRbTUzyvAYJQZDPK7bfAc4LA0Z3IOzjxqm8BwdCgIzlxl2K0CV49J15vphz4zFrssYClMyT3eT/Qph4UFU56T+5M2yIywxyzCjV2radEx9m/+buSl93w7kXBv7OIhCIt4V++bBfgcArSdwWqJ+w6KLUlR9VBmxvjTYtj36BsuIBGb19hasnEI5x0Qj7N1EGC
 oXv2V3Lw
 94Zk/kaBDmeqaJxBI0hwRWPAH1lWOjt+xAYgjeqR6rrJLuSGU8TtAXaXHg+YFTL0Qwv+O+z+BGdN1MdZCytj42c1vO0zEfZc6FMW2FTMKnvTjbEZYeSKmTCmXiZ790cUlCkMMrBDH31GCvVgxHal6hJCw75JSiP3FgQ7pO8FAGqpK2Mt0aI9uScO0Teu3B+lB1EAOe+57NXxLTUPieuoc0EzTBVoFgWJeT5ym32AquSbWTI8HizsjecHFXwh7deAtgylExXoMHhG+0wdP/vYNUIXay7V8VZi5H9X01syg1jSMws9QN8tq1u0rXlOUW4tw+j2bOH8hrDbBVTMW0YhB0oapgmCZh0o1H47RntdnaKqbYdLWzzN9+y2301GOY5tkkaKdifUvLgF8tgkTbpIJDhbULoJH5Sam2tan25RFwaG6GQY9cQztmyZlZkum8oi946kF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025, Shivank Garg wrote:
> @@ -26,6 +28,9 @@ static inline struct kvm_gmem_inode_info *KVM_GMEM_I(struct inode *inode)
>  	return container_of(inode, struct kvm_gmem_inode_info, vfs_inode);
>  }
>  
> +static struct mempolicy *kvm_gmem_get_pgoff_policy(struct kvm_gmem_inode_info *info,
> +						   pgoff_t index);
> +
>  /**
>   * folio_file_pfn - like folio_file_page, but return a pfn.
>   * @folio: The folio which contains this index.
> @@ -112,7 +117,25 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  {
>  	/* TODO: Support huge pages. */
> -	return filemap_grab_folio(inode->i_mapping, index);
> +	struct mempolicy *policy;
> +	struct folio *folio;
> +
> +	/*
> +	 * Fast-path: See if folio is already present in mapping to avoid
> +	 * policy_lookup.
> +	 */
> +	folio = __filemap_get_folio(inode->i_mapping, index,
> +				    FGP_LOCK | FGP_ACCESSED, 0);
> +	if (!IS_ERR(folio))
> +		return folio;
> +
> +	policy = kvm_gmem_get_pgoff_policy(KVM_GMEM_I(inode), index);
> +	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
> +					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> +					 mapping_gfp_mask(inode->i_mapping), policy);
> +	mpol_cond_put(policy);
> +
> +	return folio;
>  }
>  
>  static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> @@ -372,8 +395,45 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_NUMA
> +static int kvm_gmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +
> +	return mpol_set_shared_policy(&KVM_GMEM_I(inode)->policy, vma, mpol);
> +}
> +
> +static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
> +					     unsigned long addr, pgoff_t *pgoff)
> +{
> +	struct inode *inode = file_inode(vma->vm_file);
> +
> +	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> +	return mpol_shared_policy_lookup(&KVM_GMEM_I(inode)->policy, *pgoff);
> +}
> +
> +static struct mempolicy *kvm_gmem_get_pgoff_policy(struct kvm_gmem_inode_info *info,
> +						   pgoff_t index)

I keep reading this is "page offset policy", as opposed to "policy given a page
offset".  Another oddity that is confusing is that this helper explicitly does
get_task_policy(current), while kvm_gmem_get_policy() lets the caller do that.
The end result is the same, but I think it would be helpful for gmem to be
internally consistent.

If we have kvm_gmem_get_policy() use this helper, then we can kill two birds with
one stone:

static struct mempolicy *__kvm_gmem_get_policy(struct gmem_inode *gi,
					       pgoff_t index)
{
	struct mempolicy *mpol;

	mpol = mpol_shared_policy_lookup(&gi->policy, index);
	return mpol ? mpol : get_task_policy(current);
}

static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
					     unsigned long addr, pgoff_t *pgoff)
{
	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);

	return __kvm_gmem_get_policy(GMEM_I(file_inode(vma->vm_file)), *pgoff);
}

