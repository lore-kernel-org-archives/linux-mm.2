Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78C03CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 15:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDC36B0088; Tue, 23 Jun 2026 11:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596786B008A; Tue, 23 Jun 2026 11:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DBB76B008C; Tue, 23 Jun 2026 11:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07F246B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:33:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6FBC4402E2
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:33:38 +0000 (UTC)
X-FDA: 84911572116.25.9716908
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id E0CE920002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:33:28 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782228809;
	b=M4zf76/bOEdZ6/octbcxKhU4LF8c93/dwNDT9W2mInkgNMzzio14XuPc3AdTAw2qMS283Q
	pDOAs9WVLgvMhDxn6YBzi44Cr+Y/Ltvcvi++tw9QbdBPOPCmOKu1hd5v5+oUer5X7JnNUu
	k/rW+WhZQNKtSug+mB7e6mHJJ2S6+kw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782228809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1Bny3807BZgTs2uePjipxUsmHzpP562txJFNUNSguI=;
	b=IJ3SxZ+Q9T9UlR1RZeOzsDCosVza7TRkXsfTr+JNxZ13+fX8eom87ThXFRELYAwfL1xK5B
	cYYxFb+R7kXf0aCyBybb51eWCBxK/Ivs4e/IxX2HrtX96xdL33bKuwpl8ztOgRPMDN+4w+
	4dgVfAtD1ZRSUlSOAbmz8fRQ1/iGGYk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MMPL5iwu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3Rqc6agkKCNcM3KNGL3AN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3Rqc6agkKCNcM3KNGL3AN9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-69790cf5e04so3805278a12.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782228807; x=1782833607; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i1Bny3807BZgTs2uePjipxUsmHzpP562txJFNUNSguI=;
        b=MMPL5iwuBuvyzhceHgYdM6OSIslJChgEayAsJhT9IQHpvTxSpocMxNexwFavC+I/Ad
         nj8qxrAmzZ71Zo19m0YkDD86gfA9cuvPo9B7wfij/g36JQNTyPWVzXnLVkisN91pt427
         RFec88UbpEVo8ChsXpeq+WG6iW4WGpdABCi7xQXuiNY3L6trx84iD8uJDBHO7Q4brBX4
         yobxq5OnCgJVnmr+I+LU7I46oNaALMhg07fIRoGyh+V/deDZvIX56ygxuPdQFaHozchv
         6RcYnhLt6XC5oR8Bxw+r7Z2yfwdbQrV2mXDyA1vo0+HKo1zxsMfC7jux2iqp2dQjutxI
         FujA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782228807; x=1782833607;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i1Bny3807BZgTs2uePjipxUsmHzpP562txJFNUNSguI=;
        b=N/3XKGiCGg8Iz4EPGuYrIsH56FLt10j008I4lzfKcMtgFl+DwjfB71zvBaQ6KYEQyp
         LzCENnucPhRdZxUmvYey4tgV60yOeYDM+B3G6JuI2GwC0vBLOfqe/S+oetPYzFMKtE/A
         o/7dQK64KJpE+ybamdFeiD22v8UTMPEqIWKwlRG9gC5GCkSh7Kc+7yT98mnfCtkaE+T/
         WW+XMx2PvrgndrQP5TnZG1hkdzTOYsy1+bzHmlOdgoAenvG9S8SGHh+6O7FZ+rvBvS7N
         dGLy0kDBFSrCwGPWihqMP5JYnNhrklvljcODDqxyTHdGxrWpE9YL+teJG+0H5vEbWINi
         VXoQ==
X-Forwarded-Encrypted: i=1; AFNElJ+lpfgNdURIviXDC3RPh6+CqrAlqjCHbM3SbIjjoj+LsQnVQwMbNB3Sk7Vaq8j2Wz99iWakYkCeKw==@kvack.org
X-Gm-Message-State: AOJu0YywtxlvQmk/67Ci0mTsROSxz0WAcOe06h8eTCjkcM9i/q5lz2bS
	QovbQ7DgEHu0y+gkH/GXMkCJwWxXcGRqcRQrpHCSmMFCfn8OV7j4D9v3XQh+zCEW1Ddr1xiU9/y
	U7DMbKIvyuW39SnlnnQ==
X-Received: from edgd28-n1.prod.google.com ([2002:a05:6402:a51c:10b0:695:d3d9:5811])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5253:b0:697:96c2:b591 with SMTP id 4fb4d7f45d1cf-69796c2c000mr5685499a12.11.1782228806744;
 Tue, 23 Jun 2026 08:33:26 -0700 (PDT)
Date: Tue, 23 Jun 2026 15:33:26 +0000
In-Reply-To: <CAEvNRgGharGxs9s_ow0Z4iiQ9PCzdghch-4Fk6UMjiPP9tX-5g@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com>
 <CAEvNRgGharGxs9s_ow0Z4iiQ9PCzdghch-4Fk6UMjiPP9tX-5g@mail.gmail.com>
Message-ID: <9huzo6h1mfuh.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 03/10] kvm: Prepare core VM structs and helpers for
 LUO support
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	fvdl@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, aneesh.kumar@kernel.org, 
	skhawaja@google.com, vipinsh@google.com, Pratyush Yadav <pratyush@kernel.org>, 
	david@redhat.com, dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1782228808-709492
X-HE-Meta: U2FsdGVkX1+QJDWXOZp4yiLkj90mqeGaWs7oq3AD094rPWTN2btTMeyc7cXuZ1uZmr8CKpE3zYRgQlFw5LtRjXFHJsUudSb1I4Lew8XA//mW/FIZb4todCjnqAW7EBeRfHHgD9AZ7G76t32WQKG+8pUwedOTY7Yw1kL9J42AEZFtk8QpEs4NYR8IKxsLEROcE5wE6r8ZsOX/5XrDK7MyWuZLBqODMTp/y0Yg6MCgjnevDHbfo3A63p7nyZfyJJi3wDGW4ZHYnYhS36lqAHxqEzQGhsB8kCJAgCMR2+JdAZai4OLm2jE89ZKl71EaHvM1RyG7BbamVe+v69SoVP5L24jUECZo7KDM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Introduce core infrastructure to support VM preservation with LUO.
>>
>> First two changes are just refactoring, no functional change, third
>> change introduces a new member in struct kvm.
>> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
>> - Add a public kvm_create_vm_file() helper wrapping kvm_create_vm()
>>   and anon_inode_getfile() to provide a unified VM file creation API.
>> - Track a weak reference to the backing file in struct kvm under
>>   CONFIG_LIVEUPDATE_GUEST_MEMFD to enable reverse file resolution
>>   without circular lifetime dependencies.
>>
>
> Given the above, I think this should be separate patches.
>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  include/linux/kvm_host.h | 14 +++++++
>>  virt/kvm/kvm_main.c      | 79 +++++++++++++++++++++++++++++-----------
>>  virt/kvm/kvm_mm.h        |  3 ++
>>  3 files changed, 75 insertions(+), 21 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 4c14aee1fb06..9111a28637af 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -874,6 +874,18 @@ struct kvm {
>>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>>  	/* Protected by slots_lock (for writes) and RCU (for reads) */
>>  	struct xarray mem_attr_array;
>> +#endif
>> +#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
>> +	/*
>> +	 * Weak reference to the VFS file backing this KVM instance. Stored
>> +	 * without incrementing the file refcount to prevent a circular lifetime
>> +	 * dependency (since file->private_data already pins this struct kvm).
>> +	 * Used exclusively to resolve the file pointer back from struct kvm.
>> +	 *
>> +	 * Written/cleared via rcu_assign_pointer() and read locklessly under
>> +	 * RCU (e.g. via get_file_active() to prevent ABA races).
>> +	 */
>> +	struct file *vm_file;
>>  #endif
>
> We didn't really talk about this during the calls, but it seems weird to
> preserve a vm_file with pretty much nothing other than the vm type. The
> entire VM is re-created, which means it could potentially be a
> completely different VM?
>
> In some sense it's more flexible since the guest_memfd can be restored
> with some completely different VM, but it seems like it could introduce
> other issues.
>
> I think other KVM folks would probably have more thoughts here.
>
>>  	char stats_id[KVM_STATS_NAME_SIZE];
>>  };
>> @@ -1074,7 +1086,9 @@ void kvm_get_kvm(struct kvm *kvm);
>>  bool kvm_get_kvm_safe(struct kvm *kvm);
>>  void kvm_put_kvm(struct kvm *kvm);
>>  bool file_is_kvm(struct file *file);
>> +struct file *kvm_create_vm_file(unsigned long type, const char *fdname);
>>  void kvm_put_kvm_no_destroy(struct kvm *kvm);
>> +void kvm_uevent_notify_vm_create(struct kvm *kvm);
>>
>>  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
>>  {
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 89489996fbc1..65f0c5fb353e 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -67,9 +67,6 @@
>>  #include <linux/kvm_dirty_ring.h>
>>
>>
>> -/* Worst case buffer size needed for holding an integer. */
>> -#define ITOA_MAX_LEN 12
>> -
>>  MODULE_AUTHOR("Qumranet");
>>  MODULE_DESCRIPTION("Kernel-based Virtual Machine (KVM) Hypervisor");
>>  MODULE_LICENSE("GPL");
>> @@ -1349,6 +1346,19 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>>  {
>>  	struct kvm *kvm = filp->private_data;
>>
>> +#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
>> +	/*
>> +	 * Clear the weak reference of the vm file.
>> +	 * In case vm file is closed by userspace, but kvm still has
>> +	 * other users like vCPUs, clearing this pointer ensures
>> +	 * that we don't have a dangling pointer to a closed file.
>> +	 *
>> +	 * Cleared via rcu_assign_pointer() to ensure proper memory visibility
>> +	 * for concurrent lockless readers under RCU.
>> +	 */
>> +	rcu_assign_pointer(kvm->vm_file, NULL);
>> +#endif
>> +
>>  	kvm_irqfd_release(kvm);
>>
>>  	kvm_put_kvm(kvm);
>> @@ -5476,11 +5486,47 @@ bool file_is_kvm(struct file *file)
>>  }
>>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm);
>>
>> +struct file *kvm_create_vm_file(unsigned long type, const char *fdname)
>> +{
>> +	struct kvm *kvm = kvm_create_vm(type, fdname);
>> +	struct file *file;
>> +
>> +	if (IS_ERR(kvm))
>> +		return ERR_CAST(kvm);
>> +
>> +	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
>> +	if (IS_ERR(file)) {
>> +		kvm_put_kvm(kvm);
>> +		return file;
>> +	}
>> +
>> +#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
>> +	/*
>> +	 * Weak reference to the file (without get_file()) to prevent a circular
>> +	 * dependency. Safe because the file's release path clears this pointer
>> +	 * and drops its reference to the VM.
>> +	 *
>> +	 * Written via rcu_assign_pointer() because the pointer can be read
>> +	 * locklessly under RCU (e.g., in kvm_gmem_luo_preserve() via
>> +	 * get_file_active() to prevent lockless ABA races).
>> +	 */
>> +	rcu_assign_pointer(kvm->vm_file, file);
>> +#endif
>> +
>> +	/*
>> +	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
>> +	 * already set, with ->release() being kvm_vm_release().  In error
>> +	 * cases it will be called by the final fput(file) and will take
>> +	 * care of doing kvm_put_kvm(kvm).
>> +	 */
>> +
>> +	return file;
>> +}
>> +
>>  static int kvm_dev_ioctl_create_vm(unsigned long type)
>>  {
>>  	char fdname[ITOA_MAX_LEN + 1];
>>  	int r, fd;
>> -	struct kvm *kvm;
>>  	struct file *file;
>>
>>  	fd = get_unused_fd_flags(O_CLOEXEC);
>> @@ -5489,31 +5535,17 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>>
>>  	snprintf(fdname, sizeof(fdname), "%d", fd);
>>
>> -	kvm = kvm_create_vm(type, fdname);
>> -	if (IS_ERR(kvm)) {
>> -		r = PTR_ERR(kvm);
>> -		goto put_fd;
>> -	}
>> -
>> -	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
>> +	file = kvm_create_vm_file(type, fdname);
>>  	if (IS_ERR(file)) {
>>  		r = PTR_ERR(file);
>> -		goto put_kvm;
>> +		goto put_fd;
>>  	}
>>
>> -	/*
>> -	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
>> -	 * already set, with ->release() being kvm_vm_release().  In error
>> -	 * cases it will be called by the final fput(file) and will take
>> -	 * care of doing kvm_put_kvm(kvm).
>> -	 */
>> -	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
>> +	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, file->private_data);
>
> Notifying with file->private_data threw me off... I would rather inline
> the rcu_assign_pointer() in this function and have this line read
> notify(..., kvm) like before.

Yes, I will update it to:

     struct kvm *kvm;
     ...
     kvm = file->private_data;
     notify (..., kvm);

About rcu_assign_pointer, I am not sure, IIUC. that only set the
kvm->vm_file pointer, which does not have any relation with
file->private_data. And keeping the rcu_assign_pointer(kvm->vm_file,
file) at the current place (inside kvm_create_vm_file) logically makes
sense. because, kvm_create_vm_file creates the struct kvm and vm_file,
So, all the relation variables should get updated there.

>
>>
>>  	fd_install(fd, file);
>>  	return fd;
>>
>> -put_kvm:
>> -	kvm_put_kvm(kvm);
>>  put_fd:
>>  	put_unused_fd(fd);
>>  	return r;
>> @@ -6341,6 +6373,11 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
>>  	kfree(env);
>>  }
>>
>> +void kvm_uevent_notify_vm_create(struct kvm *kvm)
>> +{
>> +	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
>> +}
>> +
>>  static void kvm_init_debug(void)
>>  {
>>  	const struct file_operations *fops;
>> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
>> index 9fcc5d5b7f8d..7aa1d65c3d46 100644
>> --- a/virt/kvm/kvm_mm.h
>> +++ b/virt/kvm/kvm_mm.h
>> @@ -3,6 +3,9 @@
>>  #ifndef __KVM_MM_H__
>>  #define __KVM_MM_H__ 1
>>
>> +/* Worst case buffer size needed for holding an integer as a string. */
>> +#define ITOA_MAX_LEN 12
>> +
>>  /*
>>   * Architectures can choose whether to use an rwlock or spinlock
>>   * for the mmu_lock.  These macros, for use in common code
>> --
>> 2.54.0.1032.g2f8565e1d1-goog

