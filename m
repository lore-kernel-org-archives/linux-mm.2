Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B3AC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E8E8E0006; Tue, 22 Jul 2025 11:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57988E0001; Tue, 22 Jul 2025 11:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45BA8E0006; Tue, 22 Jul 2025 11:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF9188E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:18:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F0A1B9791
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:18:55 +0000 (UTC)
X-FDA: 83692258230.23.8992840
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id F2F321C0011
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:18:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LZ0MV35p;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753197533; a=rsa-sha256;
	cv=none;
	b=Rdqp4MmZFMCtximZ/cfrf5ZXKQmEpPJs4tHsKqXGIbKnoZLE8e0CLpDdkiCQ/BLbQvd/Rz
	Lok1/wJ1xTnQxTAEa0twUPGNKwqsUbLRyuPpnn+feX0gC4+2siGKtc98sC8STuXg7KJzyT
	XYPfO7GBKWaCNQp16IK0kD24/tDinJM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LZ0MV35p;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753197533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPWTF5ngQjwKpl0CL91lanYqN0TafLkJwtT/q59+/yM=;
	b=sjPsGDY2SZtXbedxTkIoR2ceeF4uNZeQiI+DVzgR4m99uRXy6LPOmdwRET3IAMj8HSO+et
	pa1Dg4IfCNkKafONPthr6uvbMcF3zZllOOSOGd+aHE7AytS3t9e5q7ezQFkTRvjySTNJkb
	XkniT6un7DHHZ1XpE21bx/yBH8YryYY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753197532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vPWTF5ngQjwKpl0CL91lanYqN0TafLkJwtT/q59+/yM=;
	b=LZ0MV35pEwAvDUXkaL/RMUm+nioeyMMtSl6m4h7eBLykbvACNtAamA3m0ljs/4GszG3iI+
	JtEJ1Sudw0nEAojcSP2BzLyy1VzZAxK6h7ZXzmaMqYBT0e0HM9vgll7YDkyz9wiIltAv77
	gkCLfkDUMqbFJLIrnlzYny0loQZbsa0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-393-Tkws3bvMOda_q06WXeaD_A-1; Tue, 22 Jul 2025 11:18:50 -0400
X-MC-Unique: Tkws3bvMOda_q06WXeaD_A-1
X-Mimecast-MFC-AGG-ID: Tkws3bvMOda_q06WXeaD_A_1753197530
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4eb6fcd88so3572667f8f.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753197530; x=1753802330;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vPWTF5ngQjwKpl0CL91lanYqN0TafLkJwtT/q59+/yM=;
        b=C7je9l7Fskk5XiTLANOzBvxBF/A3pY7wbA4fetrGTfMmF8VuD+Ow+9p/3Od7ZxGw5Y
         Jb3KcXsgSMmSc/Nh/E8ChF1A0OYFhjddpFJEUY9ZG1GJMUTLn8Aa68tevd7Igp0k7oP3
         gD/IFLZWrBghLDkEc6wV1tcATme9FggT7nONK1b9MkUyPq/CF8QVTRLye0LjuDBHvgHO
         w8vZcejMZVbpbzBaFfTBtvLfF8ROxywz54iG1BcKFT57fnA2VnVRPUer7S4TtcOBHouX
         Gv0Hk4Fw/ey+3wjAd1aUkuF7UMBWYXDLLbKBnTe4JM21UC2GRtbjuL87G7xTDcpBc8CH
         RDpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgdjrKigcVtCJRSdEV6M+uxQOa0Tx0XE9i+jSHrEAJiHuRhfvKB0PCXTaLm7B0KLsJCygl7Yimtw==@kvack.org
X-Gm-Message-State: AOJu0Yx7p4sR7MYMvtnV8K/VwRRj/SiXrPdPq6NEnksiecyTksVengp/
	84mBfxkFX6GlNIqMSEMD1v+kOs9s0sMOtBmYZZRs5bxTGvS9KqDoBtQI9srZ+B0BqwMzXKE3MTn
	ykVup70uSF3dKfuAur7Gtb3ODmO9rYBbj0mtAO1FeDMeejDC+j5oC
X-Gm-Gg: ASbGncsZqegTDlbdrfTeEGuSDl8H0C2lCUshEXoWmer1qY3ki0+cTQCoV7UPSIlIpku
	DV73wYV/FGl61Nq01xwXH7Wawo+Cz5GpldshxYkCE4l+1gKmlaa/RtBR4L/FnyUfjLfsqheGlTw
	awwotRuNc+VtXP+1XJCgdt09GKCxhz7nUsSDKR2R475g2ZFGELzs57RmQW2t+/13OTMNsSk68b0
	7R5t5K7ltq/TIxlHNFX8iFWBsniaY/pt+X0vRAN+bEpdC3pCouiRZQ2viBSx0x6DEfkJjZGSHeH
	kPgXN5jhV5MM11Fhc3GJEcGI9UB4PLUH2WKiUmyFAkf1ajmBXHzdcNdpTW00+aC5d7kQcwePV4p
	Q+4qNGHd595dJIlRVr9FFbniz/p7tQ1mKUVYWr5BaPkx49FJgNFNrsUragrX4Bw0LGZY=
X-Received: by 2002:a05:6000:40d9:b0:3b4:4876:9088 with SMTP id ffacd0b85a97d-3b60e510003mr19315519f8f.46.1753197529373;
        Tue, 22 Jul 2025 08:18:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRxjtA5vVT+h5NsfGd2wOVYh5rvJSzktGMXJjPKH1XZUXenLSFb1S6kEQiO5Y9viU/4gAJBg==
X-Received: by 2002:a05:6000:40d9:b0:3b4:4876:9088 with SMTP id ffacd0b85a97d-3b60e510003mr19315421f8f.46.1753197528555;
        Tue, 22 Jul 2025 08:18:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:de00:1efe:3ea4:63ba:1713? (p200300d82f28de001efe3ea463ba1713.dip0.t-ipconnect.de. [2003:d8:2f28:de00:1efe:3ea4:63ba:1713])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2bf82sm13809742f8f.26.2025.07.22.08.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jul 2025 08:18:48 -0700 (PDT)
Message-ID: <1e37e4e7-aa7b-4a2a-b1aa-1243f8094dcb@redhat.com>
Date: Tue, 22 Jul 2025 17:18:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 1/7] KVM: guest_memfd: Use guest mem inodes instead of
 anonymous inodes
To: Shivank Garg <shivankg@amd.com>, seanjc@google.com, vbabka@suse.cz,
 willy@infradead.org, akpm@linux-foundation.org, shuah@kernel.org,
 pbonzini@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk
Cc: ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org,
 serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com, tabba@google.com,
 vannapurve@google.com, chao.gao@intel.com, bharata@amd.com, nikunj@amd.com,
 michael.day@amd.com, shdhiman@amd.com, yan.y.zhao@intel.com,
 Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, michael.roth@amd.com,
 aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
 jack@suse.cz, rppt@kernel.org, hch@infradead.org, cgzones@googlemail.com,
 ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 kent.overstreet@linux.dev, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com,
 dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com,
 jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com,
 yuzhao@google.com, suzuki.poulose@arm.com, quic_eberman@quicinc.com,
 aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
References: <20250713174339.13981-2-shivankg@amd.com>
 <20250713174339.13981-4-shivankg@amd.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250713174339.13981-4-shivankg@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eThfHs34jl8DbRmdvI5n-PEvk-u4SHH6OpS9Y7NnF_E_1753197530
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F2F321C0011
X-Stat-Signature: 1uh3qgum6yrqnrg6og8gajszn7gmxmae
X-HE-Tag: 1753197532-708494
X-HE-Meta: U2FsdGVkX1+EgPoM6iygbcyqSso2uANPsotEoz55Pqyo6TDKDAHPCv5UAPCPdsEA5LUpjG2lokQSKdkSxLCSkpE/UENnsLxbqdV7WO/CAU/XoXdPFTjKoU2ht5s4iFYGztsia8T6yxfAaNpI1q30dFr/XYHmozpbF9Eb2WCzdU1EfRYHktS4YHpC85d95/Ja5lJgQWF8nU/DnOH5GgIN7bVCqlwvZdQPvLU4rHmhvczkWBcUNFT2c+33pz2yGsXQPg2pWjoshnXRv4jDAyYeQtUUUIk9sTwbq0T4H4+EZB3Gy0uNLQlFbbikFUfoMTeGMujpb8dsmH/djSpaK8ygY+CiqhlXDLSBYMgu7hpbTOQvRc6Uuj8A3lcUZIXL1SplA2NkbSWBYFnIwRhJgtzb9xG2T6UHFEEfnqfhd8n3ZkmjNmSHk4VskdIaoBPPxWGzmVS8ua3AMCTc6sd5jAE2MiDC0Ikhra1IfIZ7aps1Juzwom8b+R4jgUefzDRl5bsqEjq3vA+33/ch/5CqcuLOidxpYinOvkwTcWI84YW5rvXjcAch1hOhin8sGxeoRzGx1qQ7Hq1JWy2nXfMeGXeGcSkzpKM7xJoKT6pe5O7g3fOHpuwS8GazuzbfKXuai/KDIRL0LM9377EBAunAu6x0fhSfdbFRQJCiHsAeNUdc/RKL3yG83tXNW2E5giWykbjHPlSS8uWK2yri3Jawa7pUKi5qglEXl/HUPdrWeg/K6JEx8z76NT7R7fqwDFY+NM209yo6GeR5GHTecRcyhrdXivZQ5Kkef1rSIoBzokKWSnOAPQBGLMuK6eqvlTJvyI6/1MkEwnWSfjklS3whaL0v89XhOX/6zdALFiZafrtrZ60h5P+QlKnd2HpAHbnjqsAU7oHeuarZi1pkdGTbT98kLqy/J8jMObo0oWgFR0zh4E+FstUo8qfam5HwiGA1jPPinYuP4Ved2mYDXUg/hGU
 UyVxU3AB
 PVSpSE3fkUSN+NAQN3SwnpV/wbIUgvvS3xYMtKOdIgQTxWzq8NE6T2nnekqH44Zw8SoVnGlK/3G+9M7n8PsmHir+iCquhvHk96CAt3JBrH1XEuVmFmnbJ3RaFWXpxz5hGR8pIdtrbezHtI9P+r6aTKNODVsEe02VyQ3zioi0biFROKDFVPTRTc7ptAgzY2KwYoTQCdJKPkkJpGP2Kmni85urOzHMjbLaYgpUn87pmuvCu956zfMWt0xzgzpzuOl8QIFj1O5Sr5NRsy/vto1kufcBmCnflWLbmSWOojnTmUPVczjTCa3P4RK33u0N6RddBoiZKjxLYRjq5sHuWfezEJlo1gA0Nn1vasiVzki3GUm/av+anSKskgzoX9GeFzctEMIjgrE46f7UprKFNKMuU33Om4GcbysvpaLFrwZYBJCf+PfHXW0VinYowiPhVW6YEyPylOSEfgk8/htMPE66PrJwtb16ajJqKKVRbTqNzqYjBo+0I7R3XRmX1LdRqjmPPGVvNBhceJDNxKGY+ske5egBX0NVDbnbH3qBZ+yAe4EmLw1/6/pjXI8Q5Ikh0b+gcuKuxNlcGd7DZdusKVk2+OJL6rrNBiKS4/qMFeXT7QXFwszHnkOwh5iaPbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.07.25 19:43, Shivank Garg wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> guest_memfd's inode represents memory the guest_memfd is
> providing. guest_memfd's file represents a struct kvm's view of that
> memory.
> 
> Using a custom inode allows customization of the inode teardown
> process via callbacks. For example, ->evict_inode() allows
> customization of the truncation process on file close, and
> ->destroy_inode() and ->free_inode() allow customization of the inode
> freeing process.
> 
> Customizing the truncation process allows flexibility in management of
> guest_memfd memory and customization of the inode freeing process
> allows proper cleanup of memory metadata stored on the inode.
> 
> Memory metadata is more appropriately stored on the inode (as opposed
> to the file), since the metadata is for the memory and is not unique
> to a specific binding and struct kvm.
> 
> Co-developed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

[...]

>   
>   #include "kvm_mm.h"
>   
> +static struct vfsmount *kvm_gmem_mnt;
> +
>   struct kvm_gmem {
>   	struct kvm *kvm;
>   	struct xarray bindings;
> @@ -388,9 +392,51 @@ static struct file_operations kvm_gmem_fops = {
>   	.fallocate	= kvm_gmem_fallocate,
>   };
>   
> -void kvm_gmem_init(struct module *module)
> +static const struct super_operations kvm_gmem_super_operations = {
> +	.statfs		= simple_statfs,
> +};
> +
> +static int kvm_gmem_init_fs_context(struct fs_context *fc)
> +{
> +	struct pseudo_fs_context *ctx;
> +
> +	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
> +		return -ENOMEM;
> +
> +	ctx = fc->fs_private;
> +	ctx->ops = &kvm_gmem_super_operations;

Curious, why is that required? (secretmem doesn't have it, so I wonder)

> +
> +	return 0;
> +}
> +
> +static struct file_system_type kvm_gmem_fs = {
> +	.name		 = "kvm_guest_memory",

It's GUEST_MEMFD_MAGIC but here "kvm_guest_memory".

For secretmem it's SECRETMEM_MAGIC vs. "secretmem".

So naturally, I wonder if that is to be made consistent :)

> +	.init_fs_context = kvm_gmem_init_fs_context,
> +	.kill_sb	 = kill_anon_super,
> +};
> +
> +static int kvm_gmem_init_mount(void)
> +{
> +	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
> +
> +	if (IS_ERR(kvm_gmem_mnt))
> +		return PTR_ERR(kvm_gmem_mnt);
> +
> +	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
> +	return 0;
> +}
> +
> +int kvm_gmem_init(struct module *module)
>   {
>   	kvm_gmem_fops.owner = module;
> +
> +	return kvm_gmem_init_mount();
> +}
> +
> +void kvm_gmem_exit(void)
> +{
> +	kern_unmount(kvm_gmem_mnt);
> +	kvm_gmem_mnt = NULL;
>   }
>   
>   static int kvm_gmem_migrate_folio(struct address_space *mapping,
> @@ -472,11 +518,71 @@ static const struct inode_operations kvm_gmem_iops = {
>   	.setattr	= kvm_gmem_setattr,
>   };
>   
> +static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
> +						      loff_t size, u64 flags)
> +{
> +	struct inode *inode;
> +
> +	inode = anon_inode_make_secure_inode(kvm_gmem_mnt->mnt_sb, name, NULL);
> +	if (IS_ERR(inode))
> +		return inode;
> +
> +	inode->i_private = (void *)(unsigned long)flags;
> +	inode->i_op = &kvm_gmem_iops;
> +	inode->i_mapping->a_ops = &kvm_gmem_aops;
> +	inode->i_mode |= S_IFREG;
> +	inode->i_size = size;
> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> +	mapping_set_inaccessible(inode->i_mapping);
> +	/* Unmovable mappings are supposed to be marked unevictable as well. */
> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> +
> +	return inode;
> +}
> +
> +static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
> +						  u64 flags)
> +{
> +	static const char *name = "[kvm-gmem]";
> +	struct inode *inode;
> +	struct file *file;
> +	int err;
> +
> +	err = -ENOENT;
> +	if (!try_module_get(kvm_gmem_fops.owner))
> +		goto err;

Curious, shouldn't there be a module_put() somewhere after this function 
returned a file?

> +
> +	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
> +	if (IS_ERR(inode)) {
> +		err = PTR_ERR(inode);
> +		goto err_put_module;
> +	}
> +
> +	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
> +				 &kvm_gmem_fops);
> +	if (IS_ERR(file)) {
> +		err = PTR_ERR(file);
> +		goto err_put_inode;
> +	}
> +
> +	file->f_flags |= O_LARGEFILE;
> +	file->private_data = priv;
> +
>

Nothing else jumped at me.

-- 
Cheers,

David / dhildenb


