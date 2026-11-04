Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8346606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 00:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hMeETv55;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RAzpJdiv;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=hMeETv55;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=RAzpJdiv
Received: by kanga.kvack.org (Postfix)
	id C52F16B00EF; Tue,  3 Nov 2026 19:38:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE0B6B05B1; Tue,  3 Nov 2026 19:38:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D546B05B2; Tue,  3 Nov 2026 19:38:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73B986B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:38:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E35251405C4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:38:29 +0000 (UTC)
X-FDA: 85395575538.27.808BFED
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id A288B140007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:38:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hMeETv55;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RAzpJdiv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hMeETv55;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RAzpJdiv;
	spf=pass (imf09.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793752707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/JbHR9SIBAy4VraxiGZbUfiitTfcvjB9kaCB6rQcVIE=;
	b=bFHRbd2zUrF2RFJ8uf0iY0nceNA3k1yL1aOkcoKZ2kUNJB6BT08bWf52gYNOUM2fWSTPWD
	6NRZsxS72FVaX+FIUXytIx7EL6bwJKafpDFiXYVpDa4Z0gEGLjCezSjert6D+qNe5HqkVh
	HGkkF1bj9fxEGdFYKyI0qBrTBwyrp8s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hMeETv55;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RAzpJdiv;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hMeETv55;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RAzpJdiv;
	spf=pass (imf09.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793752707;
	b=RtNyYi87kesSEVRsdOf5l5VF0Ugi8HOu0wV3WgmxBXHcVghwQeRFSp1mjiOL/htma477sc
	CYXtCBY8GoIylFHeNyvjaoQLZiu03qKKshev9pTYqaZz/lKYc2g566hlty338yz8FbDHWF
	rLR6jDfLvDzRc61+SaMje4SzMBOYXQc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 48D231FBFA;
	Wed,  4 Nov 2026 00:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793752706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/JbHR9SIBAy4VraxiGZbUfiitTfcvjB9kaCB6rQcVIE=;
	b=hMeETv5530ymyrmx6uaNyir9LG6FBv0uQEl0WwmKicpUSBvRCnBi/EFlzkwrOdHSffoszn
	IZeJVADnNtfHp7lImgCYnmoFu3/kY74RyqE2giHL+KMLqzZp89a8feFt9brP76376iYif5
	eEHqenwPS4xADyWP82Xcpyjnps0ZiOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793752706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/JbHR9SIBAy4VraxiGZbUfiitTfcvjB9kaCB6rQcVIE=;
	b=RAzpJdivgGshNrHzYe/w5E5DSJibua0ozUzsjj6q8zz3RRQDhKh2fMv5EBNSmaCY83ixH4
	3wCgewfKfRUSHvCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793752706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/JbHR9SIBAy4VraxiGZbUfiitTfcvjB9kaCB6rQcVIE=;
	b=hMeETv5530ymyrmx6uaNyir9LG6FBv0uQEl0WwmKicpUSBvRCnBi/EFlzkwrOdHSffoszn
	IZeJVADnNtfHp7lImgCYnmoFu3/kY74RyqE2giHL+KMLqzZp89a8feFt9brP76376iYif5
	eEHqenwPS4xADyWP82Xcpyjnps0ZiOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793752706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/JbHR9SIBAy4VraxiGZbUfiitTfcvjB9kaCB6rQcVIE=;
	b=RAzpJdivgGshNrHzYe/w5E5DSJibua0ozUzsjj6q8zz3RRQDhKh2fMv5EBNSmaCY83ixH4
	3wCgewfKfRUSHvCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C07B9134A0;
	Wed,  4 Nov 2026 00:38:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4fW7I4F+6mqncAAAD6G6ig
	(envelope-from <clopez@suse.de>); Wed, 04 Nov 2026 00:38:25 +0000
Message-ID: <7ba2ca65-1eab-40fd-ae4c-f7cd9e156d8c@suse.de>
Date: Wed, 4 Nov 2026 01:38:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: don't zap secondary MMU on
 permission upgrade
To: Sean Christopherson <seanjc@google.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
 linux-mm@kvack.org, pbonzini@redhat.com, linux-s390@vger.kernel.org
References: <20261029143336.390231-3-clopez@suse.de>
 <20261029175203.5bdd51d7@p-imbrenda>
 <df9dc526-4275-4784-8a0c-2e4fa8e96402@suse.de>
 <20261030133939.630e29af@p-imbrenda> <auis0SaMkRB6odsK@google.com>
 <b9ed9dd4-a1d0-466b-a6cd-89a4e70abed0@suse.de> <aun3w8gxwlmRy-GW@google.com>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <aun3w8gxwlmRy-GW@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -13.29
X-Spam-Level: 
X-Stat-Signature: n75yfdc38smt8tt1uyhyo5fqk5zdzyhi
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A288B140007
X-HE-Tag: 1793752707-393643
X-HE-Meta: U2FsdGVkX1+yDZC7XHlVg4MgT8bSUUPIGDKkmANPnyasU86LNfrgDWs4NTmT1hmIHgvpmh7YC1x9eYMXKzEqth+TeLHs1ONJ3hOuVAGr+CTx5yVSyEGf7660Ns6UgNvPIuOWVe+Ff2ZfiVCV1lr0fNXq8Wyv/1vYFVun2tOAuFeHgOg+EoN2Ws5vnBKnLkP3lZebgTHltupYwvE6do/cGcsi8MkA6Nr9Y6T3xknAj+Nrz6+CkSk9rJUa8NGs0KvYjWIFux5ZdKvVPRsuViBa3YsgG3N7mPljHyZShKHs+ML04lLVVf9uKswMSvDXvy6upVGSAAVQAgfr8oMkE1uy/Ztkr5AafaaPTDd9s+VmY2qJDtql9DhI4bNUi4sQJPZ+NvSeyoiG9gVFKYWMT1qsk6FyCcFHJhzUHAqRtKFu228Wa/+WyBKXLa4fgYpLBXoo7cUXQrf1gtFeyp2DSGbNXeUqLm1XKcsd0meeiarwLt8Yv3TT8yO1McG/ihC5TT97yLR3G6kw9CY1gfmG3I6pvSPtq6TwmeS4T3FZgfKgS3o6xb7v1WcGkQ/H9i/c8oOqBCrUJWH6Khs9gp9nMDct8r7jMbuI6BFeMgN3nID0MVxVod5sOKoyhKyvUcKJULMSWQGjr2avI4DsxuIm5XOCZLxzTt6AbzVXolmBiP/pirYmc+zAj6bzAfk/cN4TFDTVH/+Zsd+RMdtqrY7z2f88M1ogA+miSH6f1C+0eUVa9GsDrszZctcmYSauKbtTPH9pbzjAf/8Es2gQOJtzii1mSB82fbmU5AIbYX2xhyuRmJmrUKCe4L8n2d2agvjx6AZ1Cr0VX5MjJdKDC6brIOv8FB6oe64pQVwr2kgskRZnTgBqzTC5fOZYTu6qF3K9mrfIDgiC1BjdocFBFth6nSBJBE0Cub2oloquG2F4/3707HEFWWmlHZaQNkIfOh/hU+8kk4EsDBPT7uCstalBSs/
 7qsOK0fg
 XNHMPqf+NKKUDYOKiTJgGFrGED8OcbDX9fQY3XYa6mEJ9ehe+PU0VTkGq4Wq4snn0bNXLexISreMpYoWm0jyRQwTEnaMGY6BebfHxSlDsqa5tPIS4I9qhiOnrcxeuF1bEwU5+oN+2lyLvHJA47gqXgL9JzEqaMU9y00GsvroF/cZjfpDP4BxDwYnzpuiA5lFBgjja9FqzwbznXkhpPn1ET8q4utNJyV2u2pKIzu4J6S9fPkRR/0JBak9+n/mv/3nUx1iNbk6joNnxKsh3ndZLgWu0ABMU9l2QIFspa0FwHnB3jSEItFrr6Q7aqt344BsSULA6p4U+lu5b14cnTHfikAkhY2By/lSQ0Ocy4QDpPubIqks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/3/26 4:03 PM, Sean Christopherson wrote:
> On Tue, Nov 03, 2026, Carlos López wrote:
>> On 11/2/26 4:31 PM, Sean Christopherson wrote:
>>> On Fri, Oct 30, 2026, Claudio Imbrenda wrote:
>>>> On Fri, 30 Oct 2026 12:11:07 +0100
>>>> Carlos López <clopez@suse.de> wrote:
>>>>
>>>> [...]
>>>>
>>>>>> regarding this series:
>>>>>>
>>>>>> on x86 you don't care what the new permissions are, because you're
>>>>>> updating when re-faulting (if I understood correctly).  
>>>>>
>>>>> Correct.
>>>>>
>>>>>> for s390 it might be beneficial to know what the new permissions are;
>>>>>> of course we could look up the vma and find out, but since you are
>>>>>> already checking the permissions, maybe you can find a way to also
>>>>>> convey the new permission bits?
>>>>>>
>>>>>> that would make our life on s390 easier :)  
>>>>>
>>>>> Right, getting the new bits from vma->flags should be trivially done
>>>>> from the MMU_NOTIFY_PROTECTION_VMA callsites. There'd be no users in
>>>>> this series though.  The rest of architectures still need the notifier to
>>>>> tell them if the change is an upgrade, since they don't have an easy way
>>>>> to grab the old RWX bits. Passing the old RWX bits from the MMU notifier
>>>>> does not seem trivial to me either.
>>>
>>> But why is core MM even doing mmu_notifier_invalidate_range_{start,end}() in the
>>> first place?  I.e. why add MMU_NOTIFIER_RANGE_PERM_UPGRADE?  Just skip the
>>> "invalidation".
>>
>> I briefly mention this in the cover letter, but in short, denying other
>> users the notification seems like an overly intrusive change for KVM's
>> benefit. 
> 
> There are all of two other users:
> 
>   $ git grep -w "\.invalidate_range_start"
>   drivers/gpu/drm/nouveau/nouveau_svm.c:  .invalidate_range_start = nouveau_svmm_invalidate_range_start,
>   drivers/infiniband/hw/hfi1/mmu_rb.c:    .invalidate_range_start = mmu_notifier_range_start,
>   virt/kvm/kvm_main.c:    .invalidate_range_start = kvm_mmu_notifier_invalidate_range_start,
> 
> and AFAICT neither of them wants an invalidation even for protection upgrades
> either.

There are more users that register for notifications via
mmu_interval_notifier_insert():

  $ git grep -l -e "mmu_interval_notifier_insert(" \
          -e "mmu_interval_notifier_insert_locked(" -- drivers/ | wc -l
  12

I haven't audited all of them, but I'd say that at least amdkfd relies
on the invalidation for upgrades. Without XNACK, GPU page faults are not
retried, so the driver maps ranges up front with the VMA permissions
(svm_range_validate_and_map()) and relies on an invalidation to remap
them when those change. So mprotect(PROT_READ) followed by
mprotect(PROT_READ|PROT_WRITE) would cause the GPU mapping to stay
read-only and the next GPU write to fault. Unlike the APIC access page,
this is the application's own memory, mprotect() should be perfectly valid.

This is the kind of subtle reliance that I mentioned before, and why I'd
rather not open that can of worms.

>> A flag allows users to opt in instead.
>>
>> It is also not clear to me that secondary MMUs are not relying on the
>> notification in some subtle way. In fact, Sashiko points out in reply to
>> patch 4 that the notification lets KVM retry the APIC access page reload
>> in case userspace shoots itself in the foot by calling
>> mprotect(PROT_READ) on it. This would require a really weird VMM,
> 
> s/weird/misbehaving
> 
>> as it would need to go looking for the page's address, but breaking this
>> would be a "regression" nonetheless. I will address this in v2.
> 
> Nah, there's zero chance any real VMM is doing mprotect() on the APIC access page.
> 
> More importantly, doing nothing if updating the mapping fails and APICv is enabled
> is wrong.  KVM needs to ensure vmcs.APIC_ACCESS_ADDR is fresh when running a vCPU
> with APICv enabled, even if that means putting the vCPU into an infinite loop.
> VMX doesn't support "inhibiting" the APIC access page, i.e. the memslot can't
> disappear while the VM is alive, and if userspace mucks with the VMA, then KVM
> needs to prevent running the vCPU until the mapping is restored, irrespective of
> mmu_notifiers.

Fair point. Should I just carry the diff below in v2 with your
Signed-off-by?

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 464d6ed862d5..11b24a42e482 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6928,8 +6928,10 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>  	 * APICv is enabled, but paranoia won't hurt in this case.
>  	 */
>  	slot = id_to_memslot(slots, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT);
> -	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
> +	if (WARN_ON_ONCE(!slot || slot->flags & KVM_MEMSLOT_INVALID)) {
> +		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>  		return;
> +	}
>  
>  	/*
>  	 * Ensure that the mmu_notifier sequence count is read before KVM
> @@ -6946,8 +6948,10 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
>  	 * if APICv is permanently inhibited, i.e. the memslot won't reappear.
>  	 */
>  	pfn = __kvm_faultin_pfn(slot, gfn, FOLL_WRITE, &writable, &refcounted_page);
> -	if (is_error_noslot_pfn(pfn))
> +	if (is_error_noslot_pfn(pfn)) {
> +		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>  		return;
> +	}
>  
>  	read_lock(&vcpu->kvm->mmu_lock);
>  	if (mmu_invalidate_retry_gfn(kvm, mmu_seq, gfn))


