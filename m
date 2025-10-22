Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76ADFCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 15:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE25E8E0008; Wed, 22 Oct 2025 11:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA368E0003; Wed, 22 Oct 2025 11:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CFF98E0008; Wed, 22 Oct 2025 11:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87E158E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:22:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 22317140887
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:22:01 +0000 (UTC)
X-FDA: 84026115642.01.521503D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id D87E21C000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:21:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of steven.price@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=steven.price@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761146519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xOvP6p8fDxJZxRn6mak24yEgOLkEOy92ZYrjUeNyxV0=;
	b=pBlU0kgLRzpKyAKInmAGcNSGwSj2EPTUKdJT/DGOq0FObDEqpJy023EY+Ny6mYqPSbMP4g
	8yTDoSPF1m0Xrq8fwp7UcZvs7axt+SYTjh7eUlddT2F4ol9G2ROLcZy5CWST5ufTf88r54
	fbo0GbVJ5u/wxmW7eBCpruLIFs/OE38=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761146519; a=rsa-sha256;
	cv=none;
	b=uhqEbQLj1hpg4zwjtXyRrX52gDD1jTXTvE23hCc0E1gW46upJs4c7tWE66hBXQoJs2N9N4
	eA3Lp1tW0wXrFoBHQzoK09CJcbUhQPY0eOrn5feRqJk6HyvdVB0v+dKSN+U6ApxXXmiC/+
	oy19ZSyEnkevsd+mcwyQXfDDrwIw8Og=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of steven.price@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=steven.price@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE29E1063;
	Wed, 22 Oct 2025 08:21:49 -0700 (PDT)
Received: from [10.57.33.187] (unknown [10.57.33.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C94A13F63F;
	Wed, 22 Oct 2025 08:21:37 -0700 (PDT)
Message-ID: <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com>
Date: Wed, 22 Oct 2025 16:21:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
To: Ackerley Tng <ackerleytng@google.com>, cgroups@vger.kernel.org,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de,
 brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org,
 corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 david@redhat.com, dmatlack@google.com, erdemaktas@google.com,
 fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org,
 hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com,
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
 shakeel.butt@linux.dev, shuah@kernel.org, steven.sistare@oracle.com,
 suzuki.poulose@arm.com, tabba@google.com, tglx@linutronix.de,
 thomas.lendacky@amd.com, vannapurve@google.com, vbabka@suse.cz,
 viro@zeniv.linux.org.uk, vkuznets@redhat.com, wei.w.wang@intel.com,
 will@kernel.org, willy@infradead.org, wyihan@google.com,
 xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com,
 yuzenghui@huawei.com, zhiquan1.li@intel.com
References: <cover.1760731772.git.ackerleytng@google.com>
 <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: cxi4jbp5zrou8omrwfrow3x1n7qpj6ra
X-Rspam-User: 
X-Rspamd-Queue-Id: D87E21C000F
X-HE-Tag: 1761146518-907444
X-HE-Meta: U2FsdGVkX1/4HKJdipFeKsmqxJaPze0pxzBtM7JqGG3Ys7LD+Pnyds2J0gDw2hJ5wZqDCc/7896Vf1AVTCZR6yrJQLa8CTJYmoou+2+sKUAwF9ppTfFGhMP4Zpj5inuK07bVwH+qJcAA9+2zSHfyHKOiEencHbBmh4cHHnryTaM9wmOke0vt6Dgm8YAVsn40BFqMAGovOi4sTTKJ2IXmT2PZPsYbGgKFyCcJ0NFFJVXps7Iy4bW+IywjtZcIBK1Ax+KUyABZ+3aWtaoqqFgJwtQQBeE15PI9V/rN5GwCDwWNlRw0ogPsG3LpzF/xWu4nMoHGz46dXwKgjrDdtucD8OCMmuU5eBscF17R3Jlw+GgYazJYZ5yPGAEbyAqhwYOHdhz4Ik5Td+GfnnEeBzaJ9esPsy//tUS/4bpCjfeIrK2Jenjp9/rTIvKRMnm+Fo0SHu6Nk7hXrSS4ZcNj2oOjmyYuc9H05dS0wRNLflOjSvZYAxCCzVg3kz/Bw5kMi1dbLy8hc2Xm+kIWK1ms3lrSlkbhxWldVmaw3JEYl+pPzr2TzdS31wlhj02esanOT3pWb8dKuN1bZePkdOWnzLxx8Fx4RlAmgJs28fo7plcx/ut7otwy39X64BD9diyp4N0mceQoUrci9JieKjFqgtQSW10Fldm7INEaiyw2CV6C6DjFD3nVwHCsQG0EtKB//AYg+hw+IGWYSJRjfha0dESXqy4NGeoq/NiISBBxfwqpoZRvW0GOM/h0FUGQ/kE3uv1F8r5z8S6mrboNIaYzCQO4trojG33pO3aGfraoYYhI98phffb7HZfYUZsO6aFJPX1+DJrsfZbyLaQzzFTWhh5fnty2HFg/6Pf4STVYCBvFttMoKvtJbT6xUve60LwtkvLo5yJg11yYe4MkowdgYUmj/1jAuR0kUBRoWK0+eDuzbzHAR1QC38plieuIZs2anyXXKAFqOWp47NakXlcMIrI
 cll4Qgq1
 MGlA0CmTI5RUx5wkP2rLqpEjvu86oNpYgT8+jXdIHzD4p9j1zjuFvZdv/na+d06ZBU5JTEwIpKKdqIeG/jK0hilNl5ETO6JY/N0Gkm+si6qvQiM01FPe2Y7yajwdJ0e0qiBSEiKYMlNP5pVTe+QebDQIaDFLX8plFgfsiC2tAq3iMEx5iSmeXpa6fuPIvwjlCcgwErLQUcW9M/iqVcLEuksc10KMPFH4Mmy18L1Du/0f+UQbjn5Pvd21pV/yc7F8BZ91Z+hWys98XLaZJMt5w8rejtJUfBEgxMql3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/10/2025 21:11, Ackerley Tng wrote:
> Introduce a "version 2" of KVM_SET_MEMORY_ATTRIBUTES to support returning
> information back to userspace.
> 
> This new ioctl and structure will, in a later patch, be shared as a
> guest_memfd ioctl, where the padding in the new kvm_memory_attributes2
> structure will be for writing the response from the guest_memfd ioctl to
> userspace.
> 
> A new ioctl is necessary for these reasons:
> 
> 1. KVM_SET_MEMORY_ATTRIBUTES is currently a write-only ioctl and does not
>    allow userspace to read fields. There's nothing in code (yet?) that
>    validates this, but using _IOWR for consistency would be prudent.
> 
> 2. KVM_SET_MEMORY_ATTRIBUTES, when used as a guest_memfd ioctl, will need
>    an additional field to provide userspace with more error details.
> 
> Alternatively, a completely new ioctl could be defined, unrelated to
> KVM_SET_MEMORY_ATTRIBUTES, but using the same ioctl number and struct for
> the vm and guest_memfd ioctls streamlines the interface for userspace. In
> addition, any memory attributes, implemented on the vm or guest_memfd
> ioctl, can be easily shared with the other.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  Documentation/virt/kvm/api.rst | 32 +++++++++++++++++++++++++++++++
>  include/uapi/linux/kvm.h       | 12 ++++++++++++
>  virt/kvm/kvm_main.c            | 35 +++++++++++++++++++++++++++++++---
>  3 files changed, 76 insertions(+), 3 deletions(-)
> 
[...]
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 52f6000ab0208..c300e38c7c9cd 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
[...]
> @@ -5366,15 +5375,35 @@ static long kvm_vm_ioctl(struct file *filp,
>  	}
>  #endif /* CONFIG_HAVE_KVM_IRQ_ROUTING */
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +	case KVM_SET_MEMORY_ATTRIBUTES2:
>  	case KVM_SET_MEMORY_ATTRIBUTES: {
> -		struct kvm_memory_attributes attrs;
> +		struct kvm_memory_attributes2 attrs;
> +		unsigned long size;
> +
> +		if (ioctl == KVM_SET_MEMORY_ATTRIBUTES) {
> +			/*
> +			 * Fields beyond struct kvm_userspace_memory_region shouldn't be
> +			 * accessed, but avoid leaking kernel memory in case of a bug.
> +			 */
> +			memset(&mem, 0, sizeof(mem));

s/mem/attrs/g

> +			size = sizeof(struct kvm_set_memory_attributes);
> +		} else {
> +			size = sizeof(struct kvm_set_memory_attributes2);

s/kvm_set_memory_attributes/kvm_memory_attributes/ (on both sizeof lines
above and in the SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD macro).

> +		}
> +
> +		/* Ensure the common parts of the two structs are identical. */
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(slot);
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(flags);
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(guest_phys_addr);
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(memory_size);
> +		SANITY_CHECK_MEMORY_ATTRIBUTES_FIELD(userspace_addr);

The fields are:
  * address
  * size
  * attributes
  * flags

The list you've got appears to match struct kvm_userspace_memory_region
- copy/paste error?

Thanks,
Steve

>  
>  		r = -ENOTTY;
>  		if (!vm_memory_attributes)
>  			goto out;
>  
>  		r = -EFAULT;
> -		if (copy_from_user(&attrs, argp, sizeof(attrs)))
> +		if (copy_from_user(&attrs, argp, size))
>  			goto out;
>  
>  		r = kvm_vm_ioctl_set_mem_attributes(kvm, &attrs);


