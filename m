Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87FCDCAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD1C8E0005; Fri, 26 Sep 2025 15:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4808E0001; Fri, 26 Sep 2025 15:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A34E8E0005; Fri, 26 Sep 2025 15:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 898198E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:36:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C0921407C5
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:36:32 +0000 (UTC)
X-FDA: 83932408224.11.345EEFC
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 653C21C000C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:36:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Uh+KfwQ/";
	spf=pass (imf21.hostedemail.com: domain of 3POvWaAYKCLstfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3POvWaAYKCLstfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758915390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ob/iOTJHVtIxulD10+qfYKaLq05XmILMIQZZtCe3LNU=;
	b=q8PbSDGXbBEJ3sTVt5gn75iLvcuK0WHmqnNKJ5eE3FUEgxpTarcl9bJSuEDryd+Tv/ouMn
	zGfu3NIJoFXjvYupjaS+R5piOeoup5ln0uMgcyo/+E4bViAmJN5TnZmVlT+VHp6rWi2A6B
	l2u3Yaau7j+nVd7yWdQ7yFjbAkAvYr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758915390; a=rsa-sha256;
	cv=none;
	b=GpvQssMKWw8prVF9yl/NrQ4+I8PHsBAAY+FGpcfWIC0AdKZyBZcKQCSfTVjC0kQPZihjTc
	i8mNj+SCooYUU1xKBEZuG4Z5tvCMpg3N64YN8LAvtxCVZyMRnNoB/7P44nEXQMvniFZm2u
	rlT/MMcIIZTfGxeepn58bmMwY6xM3Cs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Uh+KfwQ/";
	spf=pass (imf21.hostedemail.com: domain of 3POvWaAYKCLstfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3POvWaAYKCLstfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc3aso2809334a91.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758915389; x=1759520189; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ob/iOTJHVtIxulD10+qfYKaLq05XmILMIQZZtCe3LNU=;
        b=Uh+KfwQ/7F7awxaUzJB3UCCFl3LDKjshriyt7/sGgLgviGIBaa9Bs4Qrx903WI2v9W
         vvRJreXvTRINsUwoo6KdP4XHqAE1N/6ixRkQCPO38HLbzsCMjqn8KlAi9zcy2hoAWppD
         UJnlZm5ujZXds64WJ8IEUG74mXi6+vTr8nJ1JZX/H3ZxDqw+kqXM0TVgyYaFDvzUkg0a
         fjT4eIipVgbGYKX2IYESI335FNpNeQrG69BrJuFgyY3bT9TJhVcVCKGLeAdefiWDqjbZ
         KokpKVGg05OpTbFAlqpnVs4kc0evn2PVPDGne6DjfYoAVGHqzWva+FxzbUSG8yPrH0V8
         iCjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758915389; x=1759520189;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ob/iOTJHVtIxulD10+qfYKaLq05XmILMIQZZtCe3LNU=;
        b=TXjHEm+if44yT7sve2w7IFTwJ5VCDcNfUJPyfKwa+6UVc3uoCugPcmkkcCadHcYxkG
         qk/STufkVSH7wDI7QZgm66QJdDss4zS/+BLjwCPi2VjBNRBMbiwyEVoXyNjcPzKyujqe
         t/Tp4oONR7KXGT42MTNEaIrgGfhjf70p1E00Y2khsZdHFsSLKzYzv3KZKGBzkcGrU0U+
         iQV9QnCaT/NcUQt5ZINQ+ZXCIH8g/ttWV87vBz8MAak5p3i57eeKUoNDEIdGwbwRPqFe
         Bjuys02KJMfxObmiqLTszYR6QxNVSbKtLBOrW8KDwluu5sOmLOWUHrsBbIRjb3UgkPDc
         Eb0g==
X-Forwarded-Encrypted: i=1; AJvYcCVaxcr3ua374huku7mTBxNQ1+LjvWhPDd7xidd+MMFGcUXNAMFNjPueCQx0HZxaj/6+TzFhJWCOlg==@kvack.org
X-Gm-Message-State: AOJu0Yzu9mn8JGVxpvqI1LZG9oF8GZsIBGEsSNdjyK4Y71JAY9guTJbl
	EsT6uI+Awa9cJzmSjvHKZQHdjbhGlSOXl6GhkwUeVDpfo+JIMEggNSptLQbP9lomm4cbFXX5JNv
	Loo4NAw==
X-Google-Smtp-Source: AGHT+IFDksLZfiXKr/BILK4eWMYTpySqi06A6DOxX2zeNKzHO6pmJyAGRZ48y/vvPgWC6WRjoIw3qUZ+1+0=
X-Received: from pjbaz14.prod.google.com ([2002:a17:90b:28e:b0:32d:e264:a78e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1808:b0:32b:d8bf:c785
 with SMTP id 98e67ed59e1d1-3342a2c3979mr8949944a91.20.1758915388771; Fri, 26
 Sep 2025 12:36:28 -0700 (PDT)
Date: Fri, 26 Sep 2025 12:36:27 -0700
In-Reply-To: <aNVQJqYLX17v-fsf@google.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-9-shivankg@amd.com>
 <aNVQJqYLX17v-fsf@google.com>
Message-ID: <aNbrO7A7fSjb4W84@google.com>
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
X-Stat-Signature: t8n8fm4gwusd7cur89w6sz5egi9x35w4
X-Rspam-User: 
X-Rspamd-Queue-Id: 653C21C000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758915390-257988
X-HE-Meta: U2FsdGVkX1/0DNcwU3+G46NoqErVRl27QLtHaEVW9f7IBLkkLEf3eBjJunTIbL5rXPe54WZ/N//JZ/WHx7QqZ0DarcVUE11hBC4lkpXu+HyhvS7Shor7kbHJNA9RBsrq4SMptcnA4iAIwvn5bRueFkZkHHwgH7StGUcNx6oaezkWNEwbzeD474qp+gJTt/+XE5L8crUAEOt8Dbfrv1yglbwtOUTt9eL0ix0bzCAkf2C+gEgr4+SMJB8gQ4Wa8rNGcHfffftgZw+qJLDnbKYQnzjuf5F95rj6WEgu2H1S1tRZtx6cKhUm7wn0dn8JFa6pqve0RiUXM0wV6mqY/Bk0riFq3F4kimzfI3Tu1euWj831tT9Hd+5koeeTwo1kpOa3aBx+HXfK9EjwVsqac5CAqKl3ySIebKcSS4dXOLs3wHCYb7Sy9phjWqRte1rn5hxMMKgyOMYkE8tqXDr8Ki5j3wOqx+HeJVsk5tAivaXwLb8VMvKYk+WvPby+IpkJktNM30fvTQYeOgAOzUIjYz11JS+ig+9RU/ljyZ4/PFyChtnqNeP0f1TPoC3Fxh93durSsZWgbvOexEtDz39oRan9x5DTsaDjps4De5TH+MfubFv9K7OBfhCDz0Eo7m9Jj4u2EtYZKE1Z43CxFtHN1HxfMLs5sdfj9gGHyWKqzj/l8DIbNybedNM6ne8GC37IOnWsN/Oczea6O13y4Bao96M0iRRsgwApBTXfRG+xMkmI7PdEW44408r9wqdomQY7qC8XSNlbgPilQEqSETYZipy3yrr0j2Z7oV/KoDO1MRwMKTpBYbpvMjvy0VOSBZ23L/yw454WwHGU6Au33eCyWDOObsvc/qy1aJwg70tKSxySHp0HdOWWaXUAamB9pWOBIaChzhWrC3y6J4RIrfnhJ5kLDuT7xZ4D6qBm/Q5fgrsYpM0EASV0Ru/96CE5bpHWA9ZN0NZZUz1QxeselLP8/GR
 rQGbs5Vw
 75Ircr2yAFOJ/jkeTZRS3uu7TCb9XfmvomonAJu56c5uSzwoBthKa6XKWDaQLrtDaulzK100wIxlOZse357THO1NSAZ9ZAIG2YBQwgs0YPRnE6O5LjNzcPLEcClxlUWjdx99Pk7I0RdHnwC2UquTcmcE7a5rxazvUEIYECPmJYaL5UwGiqRjwA02ZhJ0I8ywsEOV0ToYGSeF13otswzur3iBDaBx9aODnvaQpVeUGx0Cd9t5qmx7ZVSgmYelQUeV6s8P4HEwTO+ABnemmYEiPv/LN9FkJimLgncttJbgYSde3gLmAiYqIOO6loeK9x3SaHPPJW7JZXxh5tHEuFcdNDKA92z0rTPQuBjwQjFNVGhfK0h/fDyuP++CDBonh27VPCAdRYUQ2AGbBDNIs6nYWuazP2XjYgJWjnUIEF7N9uFsTceYzcI+olfcQKLaCxw7N/5qFd3kUiqLDfR/Cq4q4WvwzlmVD9T0yqKtH8t7Lc6KJXw0GC/0s13ArA4aHQNuxDdRNBty+iUmqtUlIwqvFNnNqQOklHQgDA+Q/YrOVOZ343RnvXNulK/1PBSoqW6ajTNZDCGQw3e63b8PMMLaaYQ96pM/8sk5GdClCe+wWcaV92OLAPoc3BYPlleEy20fKG+ff0VZLS25lOUWbOykjwu0pFkoof+KlzlyuzkC8H3tRVgnUN8F4iyjxyJWipSurVBS0bLM630AH/yA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025, Sean Christopherson wrote:
> On Wed, Aug 27, 2025, Shivank Garg wrote:
> > @@ -26,6 +28,9 @@ static inline struct kvm_gmem_inode_info *KVM_GMEM_I(struct inode *inode)
> >  	return container_of(inode, struct kvm_gmem_inode_info, vfs_inode);
> >  }
> >  
> > +static struct mempolicy *kvm_gmem_get_pgoff_policy(struct kvm_gmem_inode_info *info,
> > +						   pgoff_t index);
> > +
> >  /**
> >   * folio_file_pfn - like folio_file_page, but return a pfn.
> >   * @folio: The folio which contains this index.
> > @@ -112,7 +117,25 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> >  {
> >  	/* TODO: Support huge pages. */
> > -	return filemap_grab_folio(inode->i_mapping, index);
> > +	struct mempolicy *policy;
> > +	struct folio *folio;
> > +
> > +	/*
> > +	 * Fast-path: See if folio is already present in mapping to avoid
> > +	 * policy_lookup.
> > +	 */
> > +	folio = __filemap_get_folio(inode->i_mapping, index,
> > +				    FGP_LOCK | FGP_ACCESSED, 0);
> > +	if (!IS_ERR(folio))
> > +		return folio;
> > +
> > +	policy = kvm_gmem_get_pgoff_policy(KVM_GMEM_I(inode), index);
> > +	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
> > +					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
> > +					 mapping_gfp_mask(inode->i_mapping), policy);
> > +	mpol_cond_put(policy);
> > +
> > +	return folio;
> >  }
> >  
> >  static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> > @@ -372,8 +395,45 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> >  	return ret;
> >  }
> >  
> > +#ifdef CONFIG_NUMA
> > +static int kvm_gmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
> > +{
> > +	struct inode *inode = file_inode(vma->vm_file);
> > +
> > +	return mpol_set_shared_policy(&KVM_GMEM_I(inode)->policy, vma, mpol);
> > +}
> > +
> > +static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
> > +					     unsigned long addr, pgoff_t *pgoff)
> > +{
> > +	struct inode *inode = file_inode(vma->vm_file);
> > +
> > +	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> > +	return mpol_shared_policy_lookup(&KVM_GMEM_I(inode)->policy, *pgoff);
> > +}
> > +
> > +static struct mempolicy *kvm_gmem_get_pgoff_policy(struct kvm_gmem_inode_info *info,
> > +						   pgoff_t index)
> 
> I keep reading this is "page offset policy", as opposed to "policy given a page
> offset".  Another oddity that is confusing is that this helper explicitly does
> get_task_policy(current), while kvm_gmem_get_policy() lets the caller do that.
> The end result is the same, but I think it would be helpful for gmem to be
> internally consistent.
> 
> If we have kvm_gmem_get_policy() use this helper, then we can kill two birds with
> one stone:
> 
> static struct mempolicy *__kvm_gmem_get_policy(struct gmem_inode *gi,
> 					       pgoff_t index)
> {
> 	struct mempolicy *mpol;
> 
> 	mpol = mpol_shared_policy_lookup(&gi->policy, index);
> 	return mpol ? mpol : get_task_policy(current);
> }
> 
> static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
> 					     unsigned long addr, pgoff_t *pgoff)
> {
> 	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> 
> 	return __kvm_gmem_get_policy(GMEM_I(file_inode(vma->vm_file)), *pgoff);

Argh!!!!!  This breaks the selftest because do_get_mempolicy() very specifically
falls back to the default_policy, NOT to the current task's policy.  That is
*exactly* the type of subtle detail that needs to be commented, because there's
no way some random KVM developer is going to know that returning NULL here is
important with respect to get_mempolicy() ABI.

On a happier note, I'm very glad you wrote a testcase :-)

I've got this as fixup-to-the-fixup:

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e796cc552a96..61130a52553f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -114,8 +114,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
        return r;
 }
 
-static struct mempolicy *__kvm_gmem_get_policy(struct gmem_inode *gi,
-                                              pgoff_t index)
+static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
+                                                  pgoff_t index)
 {
 #ifdef CONFIG_NUMA
        struct mempolicy *mpol;
@@ -151,7 +151,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
        if (!IS_ERR(folio))
                return folio;
 
-       policy = __kvm_gmem_get_policy(GMEM_I(inode), index);
+       policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);
        folio = __filemap_get_folio_mpol(inode->i_mapping, index,
                                         FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
                                         mapping_gfp_mask(inode->i_mapping), policy);
@@ -431,9 +431,18 @@ static int kvm_gmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpo
 static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
                                              unsigned long addr, pgoff_t *pgoff)
 {
+       struct inode *inode = file_inode(vma->vm_file);
+
         *pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
 
-        return __kvm_gmem_get_policy(GMEM_I(file_inode(vma->vm_file)), *pgoff);
+       /*
+        * Note!  Directly return whatever the lookup returns, do NOT return
+        * the current task's policy as is done when looking up the policy for
+        * a specific folio.  Kernel ABI for get_mempolicy() is to return
+        * MPOL_DEFAULT when there is no defined policy, not whatever the
+        * default policy resolves to.
+        */
+        return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, *pgoff);
 }
 #endif /* CONFIG_NUMA */
 


