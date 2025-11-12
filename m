Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3768ECCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 08:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913D08E0008; Wed, 12 Nov 2025 03:58:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAC08E0002; Wed, 12 Nov 2025 03:58:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8272B8E0008; Wed, 12 Nov 2025 03:58:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2378E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:58:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 174B312DA1C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:58:38 +0000 (UTC)
X-FDA: 84101354316.07.E2A1F27
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 49CB020007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:58:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n05MXCnw;
	spf=pass (imf13.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762937916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8kOFNMQqc6DwZYKiExs1FsLT7JfiAiiPFiPODZcAIg=;
	b=hfmc7mJb4L9pa5pYhmpPlRDcc7KkW+RXPKQQr+V13qGEXn/2FTf1hiZsZbeJ0Uujr5Bb8b
	m5GHA75DHly0wQX3zo2eC50E89SFycNoUc3pUFqOJ6Rm7CvgXcXnIPgBeNg8Qojn+dCSm6
	zhWk/1SJ7EONlXY4pNADBglC4ukp/ec=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=n05MXCnw;
	spf=pass (imf13.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762937916; a=rsa-sha256;
	cv=none;
	b=fH6vyUq7y4x6GlxZHPwPfa5NUNOgG9r7WavDM4aIwwXB3sbVNqw+C3XfxdL3IQXcAE0JO3
	8vUtNT0xzu8ZJUqB3hQ3dQ1z/sQ7L9zdvZQsJ3ZWYDRBNwizBovxWP35AVl5A+ddFf7AJW
	H9nSq1AFzjFA2aSIrFlp1pIeou1qQJc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762937915; x=1794473915;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zRDQF4ySYQusOHzc2T1tZsRtG0bPI5An+rv/0D9ldPA=;
  b=n05MXCnwoF3FDYv3miQrqUY/syKVpHg561KFlQRaJfHD0mvgOQwmEDx3
   uDTk+hD9pCTsCpfbGV/KX63xlUjQAQkeSHAWa54xUlUvthEU7YE4XlJqD
   hmXwdPlRfKkTZ785dPturti7hAhdBC1MGU+aTQU29/7IzUWTh+6gK16TY
   //rxvqTMs6KwNex5XFBMXG1aEhDowAZWdusbHmm3BRJRYCdT7sl2+K3wP
   NZW6vrQPgmVEo9dQoXt7YgzYn48R3bz2c8IOfUD9INWHKh5tX+u09uygY
   E4erDzqbw3BmDGtKSnfmnYxATluz3K9qTLgK3/NLZ73LKvBce5p+xhfZM
   Q==;
X-CSE-ConnectionGUID: LGH+txuFSQO0AP1q3VhIng==
X-CSE-MsgGUID: MRbyI/WNQ8ugegH1zoZ5Ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="52556530"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="52556530"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 00:58:33 -0800
X-CSE-ConnectionGUID: pRO6tdWeROitpi6xfJxcsA==
X-CSE-MsgGUID: jwxmFvxbSl+/qGbeC5NoOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="189343307"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 00:58:13 -0800
Message-ID: <ab3f297e-44d5-4f42-aa17-f2e7c135580e@linux.intel.com>
Date: Wed, 12 Nov 2025 16:58:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 01/37] KVM: guest_memfd: Introduce per-gmem
 attributes, use to guard user mappings
To: Ackerley Tng <ackerleytng@google.com>
Cc: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, brauner@kernel.org,
 chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net,
 dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com,
 dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com,
 fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org,
 hpa@zytor.com, hughd@google.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com,
 jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com,
 jroedel@suse.de, jthoughton@google.com, jun.miao@intel.com,
 kai.huang@intel.com, keirf@google.com, kent.overstreet@linux.dev,
 liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
 mail@maciej.szmigiero.name, maobibo@loongson.cn,
 mathieu.desnoyers@efficios.com, maz@kernel.org, mhiramat@kernel.org,
 mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, mingo@redhat.com,
 mlevitsk@redhat.com, mpe@ellerman.id.au, muchun.song@linux.dev,
 nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev,
 palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com,
 pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, prsampat@amd.com,
 pvorel@suse.cz, qperret@google.com, richard.weiyang@gmail.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org,
 roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com,
 shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com,
 steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com,
 tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com,
 vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com,
 wei.w.wang@intel.com, will@kernel.org, willy@infradead.org,
 wyihan@google.com, xiaoyao.li@intel.com, yan.y.zhao@intel.com,
 yilun.xu@intel.com, yuzenghui@huawei.com, zhiquan1.li@intel.com
References: <cover.1760731772.git.ackerleytng@google.com>
 <638600e19c6e23959bad60cf61582f387dff6445.1760731772.git.ackerleytng@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <638600e19c6e23959bad60cf61582f387dff6445.1760731772.git.ackerleytng@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49CB020007
X-Stat-Signature: d5mztaf5he1qj693zba9trutkn9uy4cq
X-Rspam-User: 
X-HE-Tag: 1762937915-859836
X-HE-Meta: U2FsdGVkX18vTdTs+kUvydbW3gZbB74btMVrl+GjJKrpr6ok8hJEt7ZFDzLTE2zYdMlBlQNri1IviUscJBeMhNiincyo7J5HaflARS8h+Fd3tyKnzySV5NTO8L+yKa1PqF1FKKm2i6Pwr6MEDh/V6DlQqfZRaugieV3SWL1+ObuEtx5pHioRNgtWPxz1qUFTCArXAn9NgNd8+wdOByGtJyM56rWqkeUdYffDVyDUF0v44b7er9TSGuGWzQo7g7Bvi62MGeS+bB+owrpkGOcpJk1wvv3/2hqbP1zIn4O6w1p64HanevtxyM1fBe+mtU8Uoydev63g+b9zpW0kY2qFbskVZxGGrPl+FNYd19IcfOdgWYE1j701tl/Uw8Go/lfmMe6PbfgJyyRiqiA4JjOyD12SME8EQ9YFHgAmoiodHLi8S7uFmcNWWe93rbpI+gVGQdXTs1Rp8KDwza+IRLRkL+gAssGOojrCjoaU77z/ghzZ+3OAca+Socn6BKLEC1y5JZ3cPMZ+iucKxTrHUtFOY1ybuAER1JtpOTb1wa5A4aApaF9Wb/qHId1mIUS6CasFtX/p54wrjYrhgFeUtO3f5XNS/yaL6BsnTx10dOXetcHNGDj9YZfNdnRVeAsHTSrG2G1kQNpPZXuTG5nUPewcf9KlBipJKkTWNiS3628Cn/q+z76FFo5Pd5oiXs1nZ0aJTkQz1r9oMd8f+9LVHpTDnq8leko6TwzDp03/PnHZ48ekP0sZ/AAWM7pGSctUC8PW618a9E5uIoEOhCiKkYzHUWVyk4AvFSmrYh2Grb/ZLBQT2BZE3cCH51/5k34zWzLbLTZ3qxKDp6dhbsCIJK/WPF16QrpMtrZiEImSD0S2tN0sZdbACf6YfQ59SUQUrEby6EsR3eUb6yB03HG1MhXPR0XaA3YgcwdNIGRNFz9gyEbCJJW7mZJmCPFICsZPAOhyM3buTpU8pXbkiMd10Rc
 PmV029LI
 Wze+/mv9HocPW97h8z0qu+b1GsLS332fqD+Bsao1PL+kR1/uh0CHqmLCLFXu58jo2z66/u/FcrEkT3OXzu0hisZbvO89XBmPAB/JhCs9TZsp8XtJXcE8qQkFSemifBdScsBZvwp1gbz3564OvrqzwHtoyH3Ww/SDWhKAoGZXZTg2+QzKfh1GPEnNkMGXJWcGDcZanPnDy8bWZ+olAznoqfFWtgfg10loI/wd2BsEKI90CQOg0KdFOIiQwSwsYb4MSL5w8Wu4FrIZY7xj3ByNIqvwIg4Nt95o1RuVkQ1dVbXI7KLagACSfAbZmKHiJRhzm/w7P+Phj4TBKovhLyk1q+RMPUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/18/2025 4:11 AM, Ackerley Tng wrote:
[...]
>
> +static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
> +{
> +	struct gmem_inode *gi = GMEM_I(inode);
> +	MA_STATE(mas, &gi->attributes, 0, (size >> PAGE_SHIFT) - 1);
> +	u64 attrs;
> +	int r;
> +
> +	inode->i_op = &kvm_gmem_iops;
> +	inode->i_mapping->a_ops = &kvm_gmem_aops;
> +	inode->i_mode |= S_IFREG;
> +	inode->i_size = size;
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +	mapping_set_inaccessible(inode->i_mapping);
> +	/* Unmovable mappings are supposed to be marked unevictable as well. */
AS_UNMOVABLE has been removed and got merged into AS_INACCESSIBLE, not sure if
it's better to use "Inaccessible" instead of "Unmovable"

> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> +
> +	gi->flags = flags;
> +
> +	mt_set_external_lock(&gi->attributes,
> +			     &inode->i_mapping->invalidate_lock);
> +
> +	/*
> +	 * Store default attributes for the entire gmem instance. Ensuring every
> +	 * index is represented in the maple tree at all times simplifies the
> +	 * conversion and merging logic.
> +	 */
> +	attrs = gi->flags & GUEST_MEMFD_FLAG_INIT_SHARED ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +
> +	/*
> +	 * Acquire the invalidation lock purely to make lockdep happy. There
> +	 * should be no races at this time since the inode hasn't yet been fully
> +	 * created.
> +	 */
> +	filemap_invalidate_lock(inode->i_mapping);
> +	r = mas_store_gfp(&mas, xa_mk_value(attrs), GFP_KERNEL);
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}
> +
[...]
> @@ -925,13 +986,39 @@ static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
>
>   	mpol_shared_policy_init(&gi->policy, NULL);
>
> +	/*
> +	 * Memory attributes are protected the filemap invalidation lock, but
                                      ^
                                 protected by
> +	 * the lock structure isn't available at this time.  Immediately mark
> +	 * maple tree as using external locking so that accessing the tree
> +	 * before its fully initialized results in NULL pointer dereferences
> +	 * and not more subtle bugs.
> +	 */
> +	mt_init_flags(&gi->attributes, MT_FLAGS_LOCK_EXTERN);
> +
>   	gi->flags = 0;
>   	return &gi->vfs_inode;
>   }
>
>   static void kvm_gmem_destroy_inode(struct inode *inode)
>   {
> -	mpol_free_shared_policy(&GMEM_I(inode)->policy);
> +	struct gmem_inode *gi = GMEM_I(inode);
> +
> +	mpol_free_shared_policy(&gi->policy);
> +
> +	/*
> +	 * Note!  Checking for an empty tree is functionally necessary to avoid
> +	 * explosions if the tree hasn't been initialized, i.e. if the inode is

It makes sense to skip __mt_destroy() when mtree is empty.
But what explosions it could trigger if mtree is empty?
It seems __mt_destroy() can handle the case if the external lock is not set.


> +	 * being destroyed before guest_memfd can set the external lock.
> +	 */
> +	if (!mtree_empty(&gi->attributes)) {
> +		/*
> +		 * Acquire the invalidation lock purely to make lockdep happy,
> +		 * the inode is unreachable at this point.
> +		 */
> +		filemap_invalidate_lock(inode->i_mapping);
> +		__mt_destroy(&gi->attributes);
> +		filemap_invalidate_unlock(inode->i_mapping);
> +	}
>   }
>
>   static void kvm_gmem_free_inode(struct inode *inode)
> --
> 2.51.0.858.gf9c4a03a3a-goog


