Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DABF7CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91BC6B008A; Tue, 23 Jun 2026 08:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42FB6B008C; Tue, 23 Jun 2026 08:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930D66B0092; Tue, 23 Jun 2026 08:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 689716B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:48:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDC3B1C5923
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:48:09 +0000 (UTC)
X-FDA: 84911155098.06.4885737
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B35B140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:48:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sdohXMlP;
	spf=pass (imf23.hostedemail.com: domain of 3hYA6agkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3hYA6agkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782218888;
	b=2AhNwiUP1VWUc3rJpcS4rinpVqxnK9C77Eme50i1Lp/PnvvFPNjrJHdch1H+VwHIJ8a49L
	3/ga5+lOrzk3NXybHOVBuOXOZ8E12q1WjfTwpPIsGmCTsuHF6qR9JKHKbSVO7ueSTudUcg
	NOtv5QmT6WH2JbPNki3cyaEyVg+M8v0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782218888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0THPKzcpbI+KoIcav1Em77/NkteBjAW5LeD9D18IyY=;
	b=IvGWiGJq3V2+yMkLzlz67uLiSzwtHolO3nCD2YCPKMflwYEIAiAi2ttYIreS5A4bVABxTk
	BMLLAT5n6qq9+DjX+p/guxp+KOTU39HyXv76C2kXHHyggof/Jz7bjGDAGQciVeDJ2RPRxb
	j8t5lwzEB7bTZ80n/WoRz0zZLkTowTg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sdohXMlP;
	spf=pass (imf23.hostedemail.com: domain of 3hYA6agkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3hYA6agkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-69564e5c7b2so4682281a12.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782218886; x=1782823686; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C0THPKzcpbI+KoIcav1Em77/NkteBjAW5LeD9D18IyY=;
        b=sdohXMlPB4IujY5jD/BLubmNTYEFE9Q1CYZrMkJcy19Fyecqbl7p7GfEmOTFBJLXH9
         4CpKVoVMJD1JtSvyp9dzgLGN6rsOLqlI+o+L5yKxVKDkccaNdXX7Wy0kvI+WC9KtvI+K
         Octa7XJCZ5jNN/WqYijHM5gqn0BIoRvBK3Js24cwJ7Yntpr6xrdDUmNO/BzMHBmG16tg
         wI+1Zqqq9hYEnL+3WxIRypyFp6CoNe3nTKYjUF18DlGKkSCfL/CTWP7t8p+HnEQVmxwv
         d3PQ8pxU/hmYKq2lGkER6UTlm/Nf73+rWFqyXg7uonOLwHaP49Cy129ly46b9Ng/wr2C
         QWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782218886; x=1782823686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C0THPKzcpbI+KoIcav1Em77/NkteBjAW5LeD9D18IyY=;
        b=qysXM0WqxX3gLS0RS2coXqAXtwq5syhiwfja1OBurlmJSpGVYpvAgrwzsMiweky/aq
         Ed2y1XThH44scTPyeGH5upd8+qygQfHtBiqMq84ZCjbOr90yZ0417UGYHexF3dPLhfWr
         PiyAuBy6EuuTq2BNmlywwI/rjLCTF0OgFUsrADDDU7Uh0COQdB+P56OB84p21azUmXbO
         sMZGZGgjZXJKWbtsqbMVffuVgFFMgiB+6cA/0frIAObJkq1W7FTh44vkbMSCHH7B8pf2
         fM7eMeWWUwiCAJWRBqNFFLi4S9ksBZT2eraDEW14Ie2RiQLGRoiDPD9faN0dwN3Sg17f
         mc6g==
X-Forwarded-Encrypted: i=1; AFNElJ/S2uAebCH5GdTq0A/Xf5S4yCYaON6Is+xrlDpF8BBwgAbXe1CueOOdZ71B/9AirQSkcvWDrCYMAg==@kvack.org
X-Gm-Message-State: AOJu0YydQ4zL8uR92pAJHoxKDjcBDL6ebGk0PVlXN3rFKl7UbuMoCln9
	D2gPQUpgNlGP3GXRJI7T/eWu9eK1OpVuD7Z/53XEHfSTu9jq6KVgSk1N3LDbdY8C2+WJRY8EX+G
	vCZntKZYqnWh1KjG0vw==
X-Received: from edqg18.prod.google.com ([2002:aa7:c592:0:b0:697:def8:bbbf])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4022:b0:676:9c6d:7448 with SMTP id 4fb4d7f45d1cf-697dbae3105mr1388022a12.22.1782218885755;
 Tue, 23 Jun 2026 05:48:05 -0700 (PDT)
Date: Tue, 23 Jun 2026 12:48:05 +0000
In-Reply-To: <CAEvNRgGharGxs9s_ow0Z4iiQ9PCzdghch-4Fk6UMjiPP9tX-5g@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com>
 <CAEvNRgGharGxs9s_ow0Z4iiQ9PCzdghch-4Fk6UMjiPP9tX-5g@mail.gmail.com>
Message-ID: <9huz4iito22i.fsf@tarunix.c.googlers.com>
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
X-Stat-Signature: ubr7t57p79fdatop4wksguj78ch9nubq
X-Rspamd-Queue-Id: 1B35B140002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782218887-540374
X-HE-Meta: U2FsdGVkX1+IEpjWLRUS3rn5YSlEhH8SNhD7OJlVaQdx8cArjoDWH4rPjBQROJcnZwp86CyEuUI68DX3GnxgRDx8x3hsAa2A3xo45+fZclWy3ZvaFe1RPrjmqPv4rceVPlRHQ6uJSO8hwopPbdWDUax7T+Dwao7oEfFfovhRjFBQxwR8CHmVIpO75/atQvrddoDuGmrco1O8wxfxMLittcOJ3+ykWo1yxJi+wiK9qrays10/wa/I5FdYc0qxj5ZzHeSmNBie8Re5uC0N2Ec/duQ21dukgdUHpNOSJfEx+eTjCAs5rHeJIrUt4Pn2IYOxKq2YeS773d5gzciMfxa/agqlZtb9Oucvtwvpr24T0lusxePTyFofX0lMW6IC829JAummfLv7zxl9wi0SETZ2y4n4wmPjBaT66FwXBL2GaJ1XT4LZ3pkjhzMnTe5slZnttJurpK6+/fe6BE7QAO3wU/o0TTZplfOzO/df9RygiU+93mEiC8/35BHJOVpheCpU1FzP+VKd8PPLc6kYjBKoW1UFymIiGeFx+4GlHMLCXHN5twLLvbqFZbjm44rR9UFXl2Fugo0aZEAVgj8jk2kMlm6TAsSfW8BjFESVdK1ks62DgF9h5fcGAS5wg3wi3LV/vhKtbNqtOZ/2j0nr8Y/17dx40XFN1tGNCRs7qyQBn37FhDs+XWQh74f6pZkecZ/477kppUKNwPBUpYfByXUjgMVuNTD9cqDi0ea3E8d+LqBdMjbRL/6LF/9eLdV12HQL0B7PnmNa44kQ3xzo7Duch+V/sYUuJFbfsDukXUHkJdyjTsT/W9xQZqb2ZwuRJGjERbqdBKiUNnjDbLBL8uYS69K3kgU/t8e5RCc5UyvT4HSwUysD9D6gLrNQw1I1IjxEv82VriNq74ikNCguR90Rw24ulQh8eIDqM+fiZikoUcAn62ORXTgAaKgGys5XgHz0kF9xVUc0PTg/H/1xoBS
 kiB5gSHr
 Cb4x7LyULIuKoOymulTaLF3VNNqpMgWnqzdXc40NabI7ASlYWQesvkT4x+aWPzCDjHYzBmNjyCFUp3dN9WFZT1I4gNoQo4tFegSwAEYptZBWMAczfC5ny0usbLabQb3DHPU9LKTtLLCwOfJjqrrFr9zzaTs/txSDt8oUHuFU+BjMjXeWaO4+1iZhosdZpy7fP+9rLgpWyb3g9MQXRas0iCvprteMSj1HWWWrac5DBNRlMKP+1Cv5BGYHCYfdVvOtelqYiUF/gVnJNUmPGrB+UqIDzpxEBkSggzsyEEO4O02KEf1UcII8aR7C3KcEv/IVHoyTSZAR0OSnkqINXLfEQOHwJa3uFbCubKo9IFzwB/XhuqgFhu9g1kFzrCxz660YIdtXpLSSW17SXQX4wIVhSNMk9OAjT7FV3LV2/mNLxScP6Qe5c/3GNX8dqog7RNxpupSgVlB7J08dtgM6cyn6J/e1g5HCMD9Z60bAgv+tNGNX6kX/chkXVYBgro0e6oOuVEz+3jjH418eTQ8WSeLLaLFEQGed0qFB/pMb69sQwwERcg4ej7VihpXItNrCQvoU0FV4ligPoG5ezSUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi,

Thanks for reviewing the patch.


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

Okay.

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

IIUC,
you are asking "Why preserve vm_fd with guest_memfd when we only
preserve vm_type?"

We discussed about this. Also explained here: (also copying it down)
[RFC PATCH v2 04/10] kvm: kvm_luo: Allow kvm preservation with LUO
https://lore.kernel.org/all/8730c0e11acbd0d645a8b7187cd5cd7de373380e.1780676742.git.tarunsahu@google.com/

and
https://lore.kernel.org/all/cover.1780667929.git.tarunsahu@google.com/
(This cover letter was sent separately from the patches due to a problem
in my automated script)

vm_fd is needed for guest_memfd retrieval, because guest_memfd can
not be retrieved without struct kvm and there is no other way to pass
that. (We talked about alternative like LINK IOCTL or break the
CREATE_GUEST_MEMFD IOCTL in two IOCTL: one just create GUEST_MEMFD
and another attach it to the vm_file (struct kvm)). We discarded the
alternative approach because it changes the guest_memfd design.

This patch also set the infrastucture to preserve the vm_fd which
will be extended later in future when we will introduce private support.
where TDX related data (sPTE) might be preserved via struct kvm. Also,
vCPUs state, IRQ routing table etc if needed can also be preserved.


>> +	struct file *vm_file;

If You are asking about, the diff above (why vm_file is there)
There is no way to get vm_file from struct kvm which is needed
in guest_memfd preservation during freeze call to preserve the token of
vm_fd. This is used on retrieval time.


I have sent V3 as well here:
https://lore.kernel.org/all/20260622184851.2309827-1-tarunsahu@google.com/

V3 includes the few minor fixes suggested by sashiko.
we can continue reviewing on V2/V3. I will include all of the
suggestions in V4.

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

