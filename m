Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA15C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 21:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165388E0002; Thu,  7 Aug 2025 17:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1172C8E0001; Thu,  7 Aug 2025 17:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004C08E0002; Thu,  7 Aug 2025 17:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E54618E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:34:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9833F1DD87F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 21:34:27 +0000 (UTC)
X-FDA: 83751265374.12.B5C52E9
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id D42454000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 21:34:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oZ8bnNhM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 34BuVaAsKCLcXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=34BuVaAsKCLcXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754602465; a=rsa-sha256;
	cv=none;
	b=7ScI+f/gEOF5RFBvUiWJjFvQQopKJwjbeO8vROAAWUvrAHeUSrDibLg4DmmC0UVX8OSP1r
	QItVTMBdLXpPLfD6mMwR+OkZeabIriIaC6Y9SDdAh1R1We1I8JufHIBW/OAmOkzIoRMI1z
	ZljoK44O3mzEczjwQ534Ry66LHrYvzs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oZ8bnNhM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 34BuVaAsKCLcXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=34BuVaAsKCLcXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754602465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euT/8AA//Jz5ZAvA5q9RKbxUinHczFI9QPq5RPbWgzY=;
	b=0sM7St+6DkO3C5e//gIUvvEcPbiqYjNiL6vh3R6wcymUdj66/l6POoRKXPpd7OZzMvYP2p
	yU8h3+TPsga07OvmLBN4f5VdcSq5Is0GM8sjlY2xePpsmgTB+42Jpsc6A9wGR3z/yv9K+D
	ayMqiew21ok3bfJ//pMoOE9lpLs67FA=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2405fdb7c15so20453385ad.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 14:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754602464; x=1755207264; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=euT/8AA//Jz5ZAvA5q9RKbxUinHczFI9QPq5RPbWgzY=;
        b=oZ8bnNhMOW1tu9s20bKnqNij9uiUTJioAHc9PDKElXdu1QLdyHeDMQ+4Pol8RtLYdM
         3t8Uo2j0l6dFGu9XkLJqMWQJX3LnMbj052QHsIapqfrZMqLYZw2T5iWBRji8WvxkmDNz
         cbFYm19bCw9qKOBeRODMKbW7p+N2LSnGv6Y/c1jG2fzjM3typE+3Uz0qAPxfbZHfA+7t
         5hI6KixfyODmgRYz8+RryYr9QAsJPQWthCnzI6lOvu1JZpnMc6gA296jgtUnqliXS319
         Ih2ycDZ/9xSfFqphrLLKTVOdh7GeKNUaLjjZizpK1jyo4W2tcZOeBv9Eh50UPHTxWtrK
         P4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754602464; x=1755207264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=euT/8AA//Jz5ZAvA5q9RKbxUinHczFI9QPq5RPbWgzY=;
        b=HLrTKJGeuPMcjJVyyOdZ8dhrsYqiqfDW7KHleG9Pj6OZb1AMvAxRB8v7ca+F7DeAvx
         ijYmBvp+VP1gZHLzvW7bNi7AgFxaXkO7RaEfiNv6d1M23+4y9aCrmjKcqtb+wqw7xa8n
         NtFQDgFP+rMzoHpY/G/H71wp3f+elbgSksOGwd+pAcsHcK5XTD7EfkKnKThmxfcCAtgO
         wML+tAOVFfEVdsRE40yyt5ZdYBImMCEq7kzFM5MhxfscdgP+eHVZf1SkK0/HnYNoimpm
         vZ7iz3tx3UVv4XiDwitPFNxda99e+wes1MuqZ+R7Lbn8EGclPikleSnmlaVNRVZrkOrX
         zD5A==
X-Forwarded-Encrypted: i=1; AJvYcCUWb9FYnVRyzzrNPl3Xl3YusJ5ctUdvecWpVHXptsAmE5mHHyfyrlz37Eb5gdT9u4w+gj9lKA3i4g==@kvack.org
X-Gm-Message-State: AOJu0YwMxsMvvkXZaRFr4/luW0CiMQtPXC4/RUglPjYEPTwaJ1qzRass
	WUjzu/NFQgXNJEbEFJf5Chya7KkdCHfpB2l+gFxn4/B7oW8wliq8PoaEr8XDA29GGjdsHEaRsXn
	/5uARRuSLShIXyCvXKbpNie/H6g==
X-Google-Smtp-Source: AGHT+IHT05ItRE3IEgvLcZ+lHAyFN+6DaRgxPxErhggbmCLRvoYXLPmLesz+SqrwGnv72L7qbCLUCgFDzQ08eW50HQ==
X-Received: from plbko5.prod.google.com ([2002:a17:903:7c5:b0:23f:e9a5:d20a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef0a:b0:235:f459:69c7 with SMTP id d9443c01a7336-242c225dbfemr7374775ad.52.1754602464480;
 Thu, 07 Aug 2025 14:34:24 -0700 (PDT)
Date: Thu, 07 Aug 2025 14:34:23 -0700
In-Reply-To: <1e37e4e7-aa7b-4a2a-b1aa-1243f8094dcb@redhat.com>
Mime-Version: 1.0
References: <20250713174339.13981-2-shivankg@amd.com> <20250713174339.13981-4-shivankg@amd.com>
 <1e37e4e7-aa7b-4a2a-b1aa-1243f8094dcb@redhat.com>
Message-ID: <diqz4iui4y00.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH V9 1/7] KVM: guest_memfd: Use guest mem inodes instead of
 anonymous inodes
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>, Shivank Garg <shivankg@amd.com>, seanjc@google.com, 
	vbabka@suse.cz, willy@infradead.org, akpm@linux-foundation.org, 
	shuah@kernel.org, pbonzini@redhat.com, brauner@kernel.org, 
	viro@zeniv.linux.org.uk
Cc: paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, 
	bfoster@redhat.com, tabba@google.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D42454000E
X-Stat-Signature: otwzxx5u5dpqqm3xqejhba5b6ruw6hwp
X-HE-Tag: 1754602465-241828
X-HE-Meta: U2FsdGVkX18NhTKbT3Xv6YERmLKAEHoPl3o6K2dsOEoXU1F5iFu7sdWciwHqID3KMhaQQNACqcAQz8MEkjGh2dgdk7Rv1muzJf9wu83mEQG6EgAOBJlF0oBzzuBT2dUi9iXAlb+Wc/4qUBEGwIeupqslwXWmNnJ+1TfXOX7yW+SOlxyL0d0Mw42CHtdc/S2WOEIK+5JqQpIl+royZBcEXGktYeAKZvF4oEqXYWg4MH6OZujv7PJFlpnF9J0zHQ7amSt384lm6KEJfze9r/Jgsb5/I36rFWmSbOO8qultrvsZJbedwGTgn0M6Vl113E1Yreh5CCghqy74zpH8uY3SJkaCD2W7xexp8raENVc6j3+HS5DU/vYwV5eAXsD8ndG0jwuHy3wt6VV1XOoP1+ewaNcdlvtRNZsSxtcG0SE5Uc1ZXe3I/EyInib5kWDu9FpP3RDVLxMbZcswAEh9k11SzHoYcFkYRuaPmflz6qrUCP8Vnp/W96XHKaV2SzljNlW9gzBssOk4bol0UrqvVlLD/4CktwCITj5RGAnYabVPsoXPPlWey07MUIPiqOj9NSIBLmSGvhsrFQmWQ897ZmaROulCGtLcdIw4z2CHNBJQIlgGBIUwXo6794QLKTyj01Q1X7qspUP7uO1QKx9mBe1snMjPU/JY9fRTQ7APIXJBafInGsO0ZKYmJARgPHlWkrzL0G9XtDezCl/fs4+f/kPIQt5CCXTpoX9F0YSgAdr0ckA8riQIkJrgUWBBoOYFYNphgXLQykzwFo/bbFNWDHJDrAIvO82aojz0amTfE7gAhEBS8Dlwo6hkTNx+0ABN9/gTgd43Oob+h68gonhNf3cBkZK1OTFzjE6j1M4MGuUjHSL2iJozWvXiDGQJbj6hdCGYtgcxR2bzcBfLzftqL7REjDWzlFxwYIG35DMPP2gSv96hVex2ApbNrQv0UXWPMzAxSowCIHlD3CiQWCzfMRB
 eIqM84AT
 2ObmQYhUmmc0mlWSIeQTDiipJg+nWPEL/TIrwwJ8wJUJCi2J7qGfjqr+g/u96vqPhI/Hl6MDxxT5RG0AAghln8gX/xXnl9alCE2GamPi7gIDNcaQcymtgtj9hU4z5/gE7mOD3fxzhf+zyCASoSKh7zw6QD45mrWqwWoEHT+G9juMnxt2MMKRBRhenujYPAP4sH3j5l4A7+OyQw6nECO7ej5oa7HDBnz9mQZnwCaGRhGPYkB/R/xJJ692J5VGWo4k21wjS39S6ddUv4Ncczdin1zWPy30fRsildIAQ+i1S8ED3+5+ULXoHQzha8y7Gz58ZCELIQ3meRNYAfYga6QPhCGr1h6xM5jOFqtSp0mxS3r2ksJPWa1Tds+6ie3mOZ84eEg8UYz+Dvg8J8KL/rHzlH3Sq6FaarAWz6zB9Zo4GlEZwsfgRi23nQk7L1DXerwPSENOfkOGMsNG+pi4h7iLwuWOOQicl2NssXvlSwd2squJXW7iFWf2nUnMfycAINf7PmpF0D5vkRqOP0GZxuBugqSUGONzaWqbZ1DykV4MbBFIy99ykUfmvVw/6DOM62t+4V7li50Q2g2YhSatzHVRXnSD+s7e+egBEMqVJQaql9Z14r0ECZY1zacgIZKu4YiUhPwQM40CI4y3YoAKQCcbjOV8YkZgStnBJg+JPHu7qPwSD8YGEgFMKkdJP65PCR+KXzw+NTueVB05ZMLoubWzPrunSw34gomb+eQQt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand <david@redhat.com> writes:

> On 13.07.25 19:43, Shivank Garg wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>> 
>> guest_memfd's inode represents memory the guest_memfd is
>> providing. guest_memfd's file represents a struct kvm's view of that
>> memory.
>> 
>> Using a custom inode allows customization of the inode teardown
>> process via callbacks. For example, ->evict_inode() allows
>> customization of the truncation process on file close, and
>> ->destroy_inode() and ->free_inode() allow customization of the inode
>> freeing process.
>> 
>> Customizing the truncation process allows flexibility in management of
>> guest_memfd memory and customization of the inode freeing process
>> allows proper cleanup of memory metadata stored on the inode.
>> 
>> Memory metadata is more appropriately stored on the inode (as opposed
>> to the file), since the metadata is for the memory and is not unique
>> to a specific binding and struct kvm.
>> 
>> Co-developed-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>
> [...]
>
>>   
>>   #include "kvm_mm.h"
>>   
>> +static struct vfsmount *kvm_gmem_mnt;
>> +
>>   struct kvm_gmem {
>>   	struct kvm *kvm;
>>   	struct xarray bindings;
>> @@ -388,9 +392,51 @@ static struct file_operations kvm_gmem_fops = {
>>   	.fallocate	= kvm_gmem_fallocate,
>>   };
>>   
>> -void kvm_gmem_init(struct module *module)
>> +static const struct super_operations kvm_gmem_super_operations = {
>> +	.statfs		= simple_statfs,
>> +};
>> +
>> +static int kvm_gmem_init_fs_context(struct fs_context *fc)
>> +{
>> +	struct pseudo_fs_context *ctx;
>> +
>> +	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
>> +		return -ENOMEM;
>> +
>> +	ctx = fc->fs_private;
>> +	ctx->ops = &kvm_gmem_super_operations;
>
> Curious, why is that required? (secretmem doesn't have it, so I wonder)
>

Good point! pseudo_fs_fill_super() fills in a struct super_operations
which already does simple_statfs, so guest_memfd doesn't need this.

>> +
>> +	return 0;
>> +}
>> +
>> +static struct file_system_type kvm_gmem_fs = {
>> +	.name		 = "kvm_guest_memory",
>
> It's GUEST_MEMFD_MAGIC but here "kvm_guest_memory".
>
> For secretmem it's SECRETMEM_MAGIC vs. "secretmem".
>
> So naturally, I wonder if that is to be made consistent :)
>

I'll update this to "guest_memfd" to be consistent. 

>> +	.init_fs_context = kvm_gmem_init_fs_context,
>> +	.kill_sb	 = kill_anon_super,
>> +};
>> +
>> +static int kvm_gmem_init_mount(void)
>> +{
>> +	kvm_gmem_mnt = kern_mount(&kvm_gmem_fs);
>> +
>> +	if (IS_ERR(kvm_gmem_mnt))
>> +		return PTR_ERR(kvm_gmem_mnt);
>> +
>> +	kvm_gmem_mnt->mnt_flags |= MNT_NOEXEC;
>> +	return 0;
>> +}
>> +
>> +int kvm_gmem_init(struct module *module)
>>   {
>>   	kvm_gmem_fops.owner = module;
>> +
>> +	return kvm_gmem_init_mount();
>> +}
>> +
>> +void kvm_gmem_exit(void)
>> +{
>> +	kern_unmount(kvm_gmem_mnt);
>> +	kvm_gmem_mnt = NULL;
>>   }
>>   
>>   static int kvm_gmem_migrate_folio(struct address_space *mapping,
>> @@ -472,11 +518,71 @@ static const struct inode_operations kvm_gmem_iops = {
>>   	.setattr	= kvm_gmem_setattr,
>>   };
>>   
>> +static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>> +						      loff_t size, u64 flags)
>> +{
>> +	struct inode *inode;
>> +
>> +	inode = anon_inode_make_secure_inode(kvm_gmem_mnt->mnt_sb, name, NULL);
>> +	if (IS_ERR(inode))
>> +		return inode;
>> +
>> +	inode->i_private = (void *)(unsigned long)flags;
>> +	inode->i_op = &kvm_gmem_iops;
>> +	inode->i_mapping->a_ops = &kvm_gmem_aops;
>> +	inode->i_mode |= S_IFREG;
>> +	inode->i_size = size;
>> +	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>> +	mapping_set_inaccessible(inode->i_mapping);
>> +	/* Unmovable mappings are supposed to be marked unevictable as well. */
>> +	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>> +
>> +	return inode;
>> +}
>> +
>> +static struct file *kvm_gmem_inode_create_getfile(void *priv, loff_t size,
>> +						  u64 flags)
>> +{
>> +	static const char *name = "[kvm-gmem]";
>> +	struct inode *inode;
>> +	struct file *file;
>> +	int err;
>> +
>> +	err = -ENOENT;
>> +	if (!try_module_get(kvm_gmem_fops.owner))
>> +		goto err;
>
> Curious, shouldn't there be a module_put() somewhere after this function 
> returned a file?
>

This was interesting indeed, but IIUC this is correct.

I think this flow was basically copied from __anon_inode_getfile(),
which does this try_module_get().

The corresponding module_put() is in __fput(), which calls fops_put()
and calls module_put() on the owner.

>> +
>> +	inode = kvm_gmem_inode_make_secure_inode(name, size, flags);
>> +	if (IS_ERR(inode)) {
>> +		err = PTR_ERR(inode);
>> +		goto err_put_module;
>> +	}
>> +
>> +	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR,
>> +				 &kvm_gmem_fops);
>> +	if (IS_ERR(file)) {
>> +		err = PTR_ERR(file);
>> +		goto err_put_inode;
>> +	}
>> +
>> +	file->f_flags |= O_LARGEFILE;
>> +	file->private_data = priv;
>> +
>>
>
> Nothing else jumped at me.
>

Thanks for the review!

Since we're going to submit this patch through Shivank's mempolicy
support series, I'll follow up soon by sending a replacement patch in
reply to this series so Shivank could build on top of that?

> -- 
> Cheers,
>
> David / dhildenb

