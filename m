Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A69CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 02:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D3E8E0005; Wed, 24 Sep 2025 22:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54B08E0001; Wed, 24 Sep 2025 22:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A768E0005; Wed, 24 Sep 2025 22:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B08128E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:50:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40AF61601E6
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:50:34 +0000 (UTC)
X-FDA: 83926244388.11.5E674AB
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 716401C0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:50:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kNRHiCZj;
	spf=pass (imf18.hostedemail.com: domain of 3963UaAYKCPImYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3963UaAYKCPImYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758768632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtyEMQPJo4fqytrWkgTZ3RdyfRt093nOgUIpQGdycFA=;
	b=dw0xeVpVeHCtQB/AkMEAeCAsKR8x0lHhy8CIP2IYcLlHfvvIBWO/rWEs2Key1LefKoMzTi
	c5Hok+CSfieoVI+ChoTAXUuuR9zW0hGkhCI02hBJDjvBsuNVs7lM9oWj8E25ncx09AcqJq
	IHMB64mm1x7nHT8QIbEJwDYuj3PuZYc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758768632; a=rsa-sha256;
	cv=none;
	b=bvzurkuktMPgeL8vCEAyF5pTSvtmsLwTY+g1O8utj6uqpuwGTEeCTeZ4tiu8YachcJyOy9
	sViNj/eaRZSGBQLhP+JAutHhNF2nul5Q3rYzLjYVlMhtAs/DX2GG4wEtnNXa72t8xlv07C
	gfHd/gbY7ihA+K+T7puKKjOCuVJH618=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kNRHiCZj;
	spf=pass (imf18.hostedemail.com: domain of 3963UaAYKCPImYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3963UaAYKCPImYUhdWaiiafY.Wigfchor-ggepUWe.ila@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24458345f5dso6105085ad.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758768631; x=1759373431; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WtyEMQPJo4fqytrWkgTZ3RdyfRt093nOgUIpQGdycFA=;
        b=kNRHiCZjj97fSvyc86+nNdoxupIggMyv/5gpjovyXI+QDkf0v5S7jbWEhBmdzmcHmF
         2ykQyk9UOMXvYMg3vOg7WkQXEsUXtFYUV0DMAxJa3VH99wj8U5wsGCOblTnzXdE0SwHG
         wg04PSUtDdHz67ZloKq/2FyMhguIDFQjPRK+KGjuW2NjVZePfDSDLctMsuI76YwKQy8V
         23vhSpRFbhe2RHQkDTTjumF2/LBoMmzHtWJJTraHfRF2OwpykCVTjb4WtbeZSEQEMfwZ
         WICKkuVfCeId8DvycFiPJC+CTXqhZtydDdtWSbeKXyh0LtljIy3PNp/ZkPR14x1KkDa1
         m7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758768631; x=1759373431;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WtyEMQPJo4fqytrWkgTZ3RdyfRt093nOgUIpQGdycFA=;
        b=RSDYpB2x71iDDdv18g6ChX16GjYHvyzin+673+CIUn1QltnG3gO+prthDUb+POOQKQ
         FfOVJay9sDKYe8wBf1CF02zbjbG3dhTY0vGoCmamyGh0Uzus082ynHq04drqzeLz45ot
         hLuTjqE2XMyJ3dhIky6Zj8UEqoMCN5FIzLuhp5DXSU3GI+zhfoZv2soRzvWLDWp2YG0J
         Vh1kfgwsZ1HxPjCoKvmXcV07l9sk4NVTpC8/UJ8gDz6C6HWpQu+OH0vuz6WOTKWxRMPC
         MOm6xfZvR285YUAu3vvQQWHu3xf4VdQ7DwiIRMm4qQ5xs5R0Ffwkg01kPPOVajRHbh7R
         79nw==
X-Forwarded-Encrypted: i=1; AJvYcCU8KUYM3DzDaaXucbcCfMGElTNznu5I9+Trm9UvwYH0/6owUlYA3vPTuvN6TVxL8a4Q46Zjgq1Sxg==@kvack.org
X-Gm-Message-State: AOJu0Yy6eITXlhq76EpBagZ6OYUypXGyHyME8OcFhroKkrcrPwkZDaMs
	Pjea5To7hyLW67fauZ49Hggo/378Zqw66E2BDh9drDG67kZa+YRYUjGyXEhvh8Z2fN/LBsqUXDG
	y8cffSg==
X-Google-Smtp-Source: AGHT+IFUzTzL+1uqRK/gqbR3SSwstvzUfWk/CsgKEnRDPuVsxH9OFn3e2zcGuFZY0INSLtUo/3MF8Uc68Iw=
X-Received: from pjbnn3.prod.google.com ([2002:a17:90b:38c3:b0:32d:e264:a78e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b0b:b0:266:f01a:98d5
 with SMTP id d9443c01a7336-27ed4ab37a2mr23319415ad.57.1758768631155; Wed, 24
 Sep 2025 19:50:31 -0700 (PDT)
Date: Wed, 24 Sep 2025 19:50:29 -0700
In-Reply-To: <diqztt1sbd2v.fsf@google.com>
Mime-Version: 1.0
References: <20250827175247.83322-2-shivankg@amd.com> <20250827175247.83322-7-shivankg@amd.com>
 <diqztt1sbd2v.fsf@google.com>
Message-ID: <aNSt9QT8dmpDK1eE@google.com>
Subject: Re: [PATCH kvm-next V11 4/7] KVM: guest_memfd: Use guest mem inodes
 instead of anonymous inodes
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Shivank Garg <shivankg@amd.com>, willy@infradead.org, akpm@linux-foundation.org, 
	david@redhat.com, pbonzini@redhat.com, shuah@kernel.org, vbabka@suse.cz, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com, 
	xiang@kernel.org, chao@kernel.org, jaegeuk@kernel.org, clm@fb.com, 
	josef@toxicpanda.com, kent.overstreet@linux.dev, zbestahu@gmail.com, 
	jefflexu@linux.alibaba.com, dhavale@google.com, lihongbo22@huawei.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	tabba@google.com, paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, 
	pvorel@suse.cz, bfoster@redhat.com, vannapurve@google.com, chao.gao@intel.com, 
	bharata@amd.com, nikunj@amd.com, michael.day@amd.com, shdhiman@amd.com, 
	yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, thomas.lendacky@amd.com, 
	michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, kalyazin@amazon.com, 
	peterx@redhat.com, jack@suse.cz, hch@infradead.org, cgzones@googlemail.com, 
	ira.weiny@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	chao.p.peng@intel.com, amit@infradead.org, ddutile@redhat.com, 
	dan.j.williams@intel.com, ashish.kalra@amd.com, gshan@redhat.com, 
	jgowans@amazon.com, pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 716401C0006
X-Stat-Signature: go8hf8giza448ck7zgkz3q64yf3tph9x
X-Rspam-User: 
X-HE-Tag: 1758768632-334766
X-HE-Meta: U2FsdGVkX1+NCvAsXPfvFYaC28lbSriRsHMlfRNHZur5AiZmqpnyy+bxcV7ODpWlMbzptxPNksBESxl4k8fk3kBf7pUM2kvkzpjWoTVMcXZwC5hdaDeS22iFu2TpOs/TzfB6/me58+FGfsEdYGTIS6L/7NqQRzYE93Njv4+vVnGHMbM+XSBW1W0ofcAAR19wR8Jit9y3faOJJGV6KzKXnKLrNvuQ5IreR47/8V9RJ9SqgZH/69ClzMIjwCoMK4h9+d0SVyMoVxR3yFXx7y0f8XCts7dDplYoi5NR5ZMancMvf9XdH/1RGqZRQ1U8MnBA1lt4cT3Uo+ZB7/Hh1wSL4XruoxD8vwEGTG1bVx2LUfW5d3xP/TZ+nAtyOHqyqPSOgj9wXUDPKTsadmfsBLh7WMYQIqKLwIUkeOttNAqxfPVnxQpEwL6o7Kg+UjvBpalHlxC0mLy2dqCKMXLq0adoaTqRmBb/FHoUMNquagP9bn6bq22h5N7uIJhmzvARKOHxWyVZ/8oBimYmoc8LYVqLpFy63gyu2lMZhhgUO4A//7kVTLKz11H1dfoDfMrFq268lvFcsC3bsIMSI9REuEfWxgjfoEPD1vHPGo4Vti/mouI921MvTH/wUdisDsk4e70JiktnMcGpShSC0KT8LAGgUYlYzL1CvSPankwlwbt1EPDyF2RNBVuIu8urEgrqENq7u75S/SjTOOg7zrL+PZLbWux5NGWDZbCDa3xGzrrvqGSieWN4bilG9bf/kkagjQpAXZd4ZHGwrK32aUHMTlzl2jnzERnUVfty2jFIYP1etDYpCvbw0NEqhlygnfPIrFofvIq+iXabZSH6SyZpzZsEc5xbr3HZ3/x95dRqOuXOtTHMc2TqJG02o2OgVOF7SlwL0hG2cyhOzV9ARBuSCW6pVYbgwlohsUB+dzAmm/mOzye79qmUlOpdTg6ExeLwszaZqRoOuW4jExFR7Y+d94j
 ijnMxEtn
 vPVUxtBdhf+AZyXU5sn1sxPWQGOjyUOT2SNUzDsUoFsYtm6g6pwPzj96Yp+BZHkEkRFDV7h+6CXjylwSs6oAKQhztlEMemJnKbcVAHwWgtWv9FeFhaUeza7gIfNqEQR+w9h9fM9xTJ2doYoKBf5p+ExssOybA3+4duEsppScidgAckkzR8HhyyORRBER/WO0fiXij5/8+i1v2tfkorsEykZ26pi4X1fxvMHklrUHBhNDi+lAquO+wikMaZpMdCdvpBs8W3RhTZyftzHk0g+9bqFoTOkP0AY4fyvFEXH9GEPYmv8gTcui6TtaAxoBpuwNdRsVI4rw+3YrErDwXySL1zWNHMyrh2bbnpdeLiNW7fZTuzGiwPaeHBftbAxK7Bwg4d7c4gcgMP2fbpV7BN/mhXdu1HgKKYd9IcOGUGyFK8baSxd0q2zJZF/jC0FrgI/f8b9bax3ky1YSUvN81Mm2Zmnrr/PWP8Y4Xwh4ugKddupOZorRvRrwWnI1uGXRsjM5hHkvvgFWWpKC3dOLkggEoNbjWasVYhSozMCr3fZhjt0WASAYZOxp5UE8PA82tsGTyQLixDMt2+T3r4ocR6PimQGMOrN0DFTi4hFeug/JzIDUaLBCEZusoCp1dJhtMzKUoYsJh9GaqGcfAXK4nuS2VPWoqxNeVrirI9Oi6LGXulE1GbIBYt+C+hjKZ+LOdmwCa64o+ixQHvpwHPVyqcP0y15cJWZVoQgsbQPhttbYoGNZXf57pKmiPH+KOM/ky93iY10JV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

My apologies for the super late feedback.  None of this is critical (mechanical
things that can be cleaned up after the fact), so if there's any urgency to
getting this series into 6.18, just ignore it.

On Wed, Aug 27, 2025, Ackerley Tng wrote:
> Shivank Garg <shivankg@amd.com> writes:
> @@ -463,11 +502,70 @@ bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
>  	return true;
>  }
> 
> +static struct inode *kvm_gmem_inode_create(const char *name, loff_t size,
> +					   u64 flags)
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
> +	/* __fput() will take care of fops_put(). */
> +	if (!fops_get(&kvm_gmem_fops))
> +		goto err;
> +
> +	inode = kvm_gmem_inode_create(name, size, flags);
> +	if (IS_ERR(inode)) {
> +		err = PTR_ERR(inode);
> +		goto err_fops_put;
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
> +	return file;
> +
> +err_put_inode:
> +	iput(inode);
> +err_fops_put:
> +	fops_put(&kvm_gmem_fops);
> +err:
> +	return ERR_PTR(err);
> +}

I don't see any reason to add two helpers.  It requires quite a bit more lines
of code due to adding more error paths and local variables, and IMO doesn't make
the code any easier to read.

Passing in "gmem" as @priv is especially ridiculous, as it adds code and
obfuscates what file->private_data is set to.

I get the sense that the code was written to be a "replacement" for common APIs,
but that is nonsensical (no pun intended).

>  static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  {
> -	const char *anon_name = "[kvm-gmem]";
>  	struct kvm_gmem *gmem;
> -	struct inode *inode;
>  	struct file *file;
>  	int fd, err;
> 
> @@ -481,32 +579,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  		goto err_fd;
>  	}
> 
> -	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
> -					 O_RDWR, NULL);
> +	file = kvm_gmem_inode_create_getfile(gmem, size, flags);
>  	if (IS_ERR(file)) {
>  		err = PTR_ERR(file);
>  		goto err_gmem;
>  	}
> 
> -	file->f_flags |= O_LARGEFILE;
> -
> -	inode = file->f_inode;
> -	WARN_ON(file->f_mapping != inode->i_mapping);
> -
> -	inode->i_private = (void *)(unsigned long)flags;
> -	inode->i_op = &kvm_gmem_iops;
> -	inode->i_mapping->a_ops = &kvm_gmem_aops;
> -	inode->i_mode |= S_IFREG;
> -	inode->i_size = size;
> -	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
> -	mapping_set_inaccessible(inode->i_mapping);
> -	/* Unmovable mappings are supposed to be marked unevictable as well. */
> -	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> -
>  	kvm_get_kvm(kvm);
>  	gmem->kvm = kvm;
>  	xa_init(&gmem->bindings);
> -	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
> +	list_add(&gmem->entry, &file_inode(file)->i_mapping->i_private_list);

I don't understand this change?  Isn't file_inode(file) == inode?

Compile tested only, and again not critical, but it's -40 LoC...


---
 include/uapi/linux/magic.h |  1 +
 virt/kvm/guest_memfd.c     | 75 ++++++++++++++++++++++++++++++++------
 virt/kvm/kvm_main.c        |  7 +++-
 virt/kvm/kvm_mm.h          |  9 +++--
 4 files changed, 76 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index bb575f3ab45e..638ca21b7a90 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -103,5 +103,6 @@
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
+#define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 08a6bc7d25b6..73c9791879d5 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,12 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/anon_inodes.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
+#include <linux/fs.h>
 #include <linux/kvm_host.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
-#include <linux/anon_inodes.h>
 
 #include "kvm_mm.h"
 
+static struct vfsmount *kvm_gmem_mnt;
+
 struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
@@ -385,9 +389,45 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };
 
-void kvm_gmem_init(struct module *module)
+static int kvm_gmem_init_fs_context(struct fs_context *fc)
+{
+	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
+		return -ENOMEM;
+
+	fc->s_iflags |= SB_I_NOEXEC;
+	fc->s_iflags |= SB_I_NODEV;
+
+	return 0;
+}
+
+static struct file_system_type kvm_gmem_fs = {
+	.name		 = "guest_memfd",
+	.init_fs_context = kvm_gmem_init_fs_context,
+	.kill_sb	 = kill_anon_super,
+};
+
+static int kvm_gmem_init_mount(void)
+{
+	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
+
+	if (IS_ERR(kvm_gmem_mnt))
+		return PTR_ERR(kvm_gmem_mnt);
+
+	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
+	return 0;
+}
+
+int kvm_gmem_init(struct module *module)
 {
 	kvm_gmem_fops.owner = module;
+
+	return kvm_gmem_init_mount();
+}
+
+void kvm_gmem_exit(void)
+{
+	kern_unmount(kvm_gmem_mnt);
+	kvm_gmem_mnt = NULL;
 }
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
@@ -465,7 +505,7 @@ bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
 
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
-	const char *anon_name = "[kvm-gmem]";
+	static const char *name = "[kvm-gmem]";
 	struct kvm_gmem *gmem;
 	struct inode *inode;
 	struct file *file;
@@ -481,17 +521,17 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 		goto err_fd;
 	}
 
-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
-					 O_RDWR, NULL);
-	if (IS_ERR(file)) {
-		err = PTR_ERR(file);
+	/* __fput() will take care of fops_put(). */
+	if (!fops_get(&kvm_gmem_fops)) {
+		err = -ENOENT;
 		goto err_gmem;
 	}
 
-	file->f_flags |= O_LARGEFILE;
-
-	inode = file->f_inode;
-	WARN_ON(file->f_mapping != inode->i_mapping);
+	inode = anon_inode_make_secure_inode(kvm_gmem_mnt->mnt_sb, name, NULL);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto err_fops;
+	}
 
 	inode->i_private = (void *)(unsigned long)flags;
 	inode->i_op = &kvm_gmem_iops;
@@ -503,6 +543,15 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
+	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_inode;
+	}
+
+	file->f_flags |= O_LARGEFILE;
+	file->private_data = gmem;
+
 	kvm_get_kvm(kvm);
 	gmem->kvm = kvm;
 	xa_init(&gmem->bindings);
@@ -511,6 +560,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	fd_install(fd, file);
 	return fd;
 
+err_inode:
+	iput(inode);
+err_fops:
+	fops_put(&kvm_gmem_fops);
 err_gmem:
 	kfree(gmem);
 err_fd:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 18f29ef93543..301d48d6e00d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6489,7 +6489,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (WARN_ON_ONCE(r))
 		goto err_vfio;
 
-	kvm_gmem_init(module);
+	r = kvm_gmem_init(module);
+	if (r)
+		goto err_gmem;
 
 	r = kvm_init_virtualization();
 	if (r)
@@ -6510,6 +6512,8 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_register:
 	kvm_uninit_virtualization();
 err_virt:
+	kvm_gmem_exit();
+err_gmem:
 	kvm_vfio_ops_exit();
 err_vfio:
 	kvm_async_pf_deinit();
@@ -6541,6 +6545,7 @@ void kvm_exit(void)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
+	kvm_gmem_exit();
 	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
 	kvm_irqfd_exit();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 31defb08ccba..9fcc5d5b7f8d 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -68,17 +68,18 @@ static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 #endif /* HAVE_KVM_PFNCACHE */
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-void kvm_gmem_init(struct module *module);
+int kvm_gmem_init(struct module *module);
+void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
-static inline void kvm_gmem_init(struct module *module)
+static inline int kvm_gmem_init(struct module *module)
 {
-
+	return 0;
 }
-
+static inline void kvm_gmem_exit(void) {};
 static inline int kvm_gmem_bind(struct kvm *kvm,
 					 struct kvm_memory_slot *slot,
 					 unsigned int fd, loff_t offset)

base-commit: d133892dddd6607de651b7e32510359a6af97c4c
--

