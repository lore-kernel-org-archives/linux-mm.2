Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 383CACDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BFF6B0088; Mon, 22 Jun 2026 19:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D3E6B008A; Mon, 22 Jun 2026 19:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB1C6B008C; Mon, 22 Jun 2026 19:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9453B6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:59:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C9731C546C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:59:58 +0000 (UTC)
X-FDA: 84909219276.17.FCDF730
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id F1FF318000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:59:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Zi/YlbLR";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782172796;
	b=4chDZIM4RruRGyP9cx5jWl8iIHd4TKpqN2K/2kKj164RwKxIMm5O1LKIMabLda8bEOKq4+
	/dQsyWFPDPN3DZoPoRjK1qP+39wK5Qj7wCtaP4geZtVkuDzGIHQrFSe30RACwZ1Pq4EcW9
	Ykk/C0PZ8fs7YGW3p8rKmqXlqjzOgFA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782172796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izUkSbDfmlQNOHn67gDt4QYFdqixnFjivdkPID2enxk=;
	b=odgStFZuac2G2VCsEb2UHkMk/MmhHxpQGqi6WMuqwaaPNLEP34Na0B2jQFRGoZc8gfgZrv
	yPggGEwsGtsTouKZbj9kglbIhm52v1vxA/qwvaUOdK44Qo/mvgDvEe9TilE1pe+uk4OAIG
	//vsHawxJn3Vg75FUTqcgc0YuorebrI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Zi/YlbLR";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=ackerleytng@google.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1384ebe7a10so4399030c88.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:59:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782172795; cv=none;
        d=google.com; s=arc-20240605;
        b=lFEKWJ6SsuLV34i/merSrpPLwVYw4xiH2ezf5GI7Hk4swHq55akHFky4ZtjcE68LVd
         VlBWodW6LQ2UGRMMhQ+WbjBq80VBTwDpDbGCxpCV6knjnYne2dFRCFhm+FRGFkRVZUD4
         7IJDqWoTNr5Nh+LVMRPUENVDZrNlbKvxtHMGjXPwVGmjH0DJ4u6ssY+fHyucnlaLuGMH
         /a11+6hzLL3igI0yCl7POjvMz1lkB3tgUMJSuMTb4DvBmOMeIptgF1hlEPd8yThVHCqk
         cPbRVlJr0VM2m9fy2SNzwlLlDdhLIhyJfpXpVGzgAwwm8vNwuNZYUVS/9V/AVP9NK1bq
         Iiow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=izUkSbDfmlQNOHn67gDt4QYFdqixnFjivdkPID2enxk=;
        fh=7XNdXosNcYH5XOb8SOeFDfK2Zg3ybb7d3yq1RyctTfI=;
        b=A0m34hjIAwoaa89jIKakXb2fLmWvt5cynywX7hase/pCPmmM8VVdI0j7fFvog7NZcH
         E/NGgzvUDRE2cg0fxdCxOhBcBX4YXEbEHLvfrw/SHL8dJuxZojujJAdQvjVa5srymEvZ
         GsDQAlEyd5CwkYpmlXyJRn9qbYHMjbCfMmZXRSvHt0EYRohKaUgdcKUNERzqLMqzOUPW
         BGJCVIOfZFAv6Awt/DN0mlto6Pmo56yIXMdlqbL52Tn0xhJb+X5yRvG+IujSRPWqVtJo
         81r+TdHsJu6Q2mmtohNZQ7J0SA0pzj4TrQfzYzp7lKBjn45le5K8MWSEUHE2C0cJ/PdG
         ijnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782172795; x=1782777595; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=izUkSbDfmlQNOHn67gDt4QYFdqixnFjivdkPID2enxk=;
        b=Zi/YlbLRe8XfSjg3wPrWtxqSq5JrhLDMEBBTc2fF1Sq/zcvt01xALYUQjvk2ofTjoO
         1f7l9ihBmVdf5rvy5YpHw0WjcfyhWrXIMg2AJRLNV39/iPsBJUL64nfa/OeDMtUge4K0
         M12WKsowWA3I4qKEOAIbl/jB3hyvio85YhoEfOzfVlbH5e8wq1X2x9I6nv6A8l+8gpNS
         BgUrKesKRacYuh1KzIa+7lgFIPD08kKi4LEVvvj7Ovsf19ZnVe0/D0xC8IqeDp2k2Cwn
         r3pxTfX0TZloarRsYNmKAPQ620kg9xpQgu3lt6jWLGeEApoWhsC/oQNRsxQLptVY/7SB
         tEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782172795; x=1782777595;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izUkSbDfmlQNOHn67gDt4QYFdqixnFjivdkPID2enxk=;
        b=TIe3mU1T7wJu1j6qM1tTd6FmatJ1NCIoxWlXIJcwdQmK37O3Ld4NPn/bTWgpnVeC8D
         Ew+UYyFB/Grlgw7io5nazbbzNauwqhHJLZ5OO7c4Q5tffNuJraE9xAHndu3on2mxARHH
         PFzvmG1Z6Sry1tskNWP+WPskfnDK2X/Wx4UVcO6J3orUeBgG+ijiA7yCwKp/35PGiv0B
         nFPY+NHUUUQqfg2d0/PFMw16CuyjvjYzpE4F7DMqmsmmsbBiyunbSwYiu4ctQ777O11E
         5C0f+ODgwMQ847wriMXDJ3rsKHwQVBS/bnvtn5e2Rbn/BKGK6kZyYEm+bIt/pTONy0Uh
         HYbA==
X-Forwarded-Encrypted: i=1; AFNElJ/dIhYELZ5nZ+RQFgFhM40GlUh7uLkTGERsdHqFc/Dc0hqpLYSgoWhjUg7I+DrsLzyu+NSWb/mppQ==@kvack.org
X-Gm-Message-State: AOJu0YxOfsQ3muXCIbswDYKee4rcfNbj6OOkzKJ4WYUWyFzk5G5kGfRy
	7QVgBzPHoDv0C/Zg4eZkRqiqpLgUVwONX8AL32THJwbaKKkhHtzLwAxNsmLVeYnDtbYAKhrTelR
	LOkfbJXZlPR74nGuvSxrOsXail6EaVi3tjKRoD3bo
X-Gm-Gg: AfdE7cnKWHBPrpxb0GQ62wpozxwGyiaskyJupx/GNFoY1Cd10FCfu908AcduCiK4GCo
	cBcGeEXnNcIIkEMcAcpqzoZcgT+WAhhH1CKumUNhpHsr8dE0/BU/aEetLaWQd8x3H4gRfFg/hpm
	+ZB5tNp4nym4xl7Ta8PgMVoEjyWfVCTsaxYHSjcoFIC66aMmpYTX6ZviGDIGy81oBEQGGAPU1I3
	B0+ljrmbfwRGhsw2pGCsmX8Jmx5MgMlBCZDuTeNlkcGv2KrICnn+DY320A/VGlmt7D07pkIvPGE
	Q1J7jODNlMuj50+Rvh/iwGoq+aBUnaQr0LqPjw5xiKO3TKCaSpGo3cG1f4o=
X-Received: by 2002:a05:7022:239f:b0:12d:de3e:52c1 with SMTP id
 a92af1059eb24-139c5e2d27fmr426595c88.37.1782172793679; Mon, 22 Jun 2026
 16:59:53 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Jun 2026 16:59:52 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Jun 2026 16:59:52 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com>
References: <cover.1780676742.git.tarunsahu@google.com> <20ae20f9d1a198b289444ebb4c824314cbba1bcf.1780676742.git.tarunsahu@google.com>
MIME-Version: 1.0
Date: Mon, 22 Jun 2026 16:59:52 -0700
X-Gm-Features: AVVi8CfrDtA5h9OoS52m-5SKtGCl3rj7KRQFOYRYPcz5rppoei0C-yt2tsDCGII
Message-ID: <CAEvNRgGharGxs9s_ow0Z4iiQ9PCzdghch-4Fk6UMjiPP9tX-5g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/10] kvm: Prepare core VM structs and helpers for
 LUO support
To: Tarun Sahu <tarunsahu@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1FF318000B
X-Stat-Signature: zaib8tmcet1x7a6ip6rokwx4kzq8m6jp
X-HE-Tag: 1782172795-679630
X-HE-Meta: U2FsdGVkX19OzhdRDD7+Xz0HKoUoPZ+8w5F+EU6DnhtYgft9RjG1olTNT39QWfyxuTqngjz3dbtarrijckr1Ld+p+98d4hltpiV1zNuWJ7zXFWx/Aj6PSXMdlaH6nvy23bIwjVXoNdzWO3INMmIhh38Z0a6Qs0ViM6c7Rk1cvAF+I/fzhQ582+/n/YYB7TGr3I+/ZylwytCj91vRFIl64G1OhnLpCIcadEBqzUi2AVgM+nQOO90lHjtIqkL7VW4Fw4nnprFm3FlC31SdFvmq7s8BuQd9/K1VwDeKrgaPr4MmgQwe9ofmhkNL31bdLFiGHnET4WKVyFP1HHuLCGBs61KT/FqW9WKga2hoYsdtAj0RpVAUHBLJw0k2k3hlGc/5Cos0oDOx7b0bmHl8Vq30xe4igCy1o8DDS0BsSZ/QgeLd7VI2Lq3jiPu7jj5CdlA+qEKqdj3BnJS6eBh4ohy4CeskHmUpFA08ExXq7q/Qc+Q9C1+xHrLAI33RcoMaTOEUHsO4P01oGowBJdJHv/4y2vq9bepD8RwgmUKT+HCGkptghgocVDqj36ALCz8bdX8HYKWzUn8kgLUHMvLT0gVuOuN/mLLzzgDMfUswEqylkTsXuA2eDdcz3S6vzupvWLcMwLFBsYGT5TYq3Vy6NtyTb+Ve0sUMGu1WrzHKawvxWIqkqiDyhlwSxic0gZcsXocm34rPNEUikBv7YxSQOiZmMf9McMEfA9mKGVGaQa8Xsh2IBOoOy97acZFodOKk6t/HqXdqCl/UpPO+lufrXSx2Bt5/IB6uq4rUaB/sroEEn669yzaZUtE0RhZNP61q1wYaSvpdbiSiEWhvvjC5qMRNdOm4GYYnuZ6Oz1TGb16zAIcQIUORWpzzVGSt1YdDs0w/if41itKkxE4dgebBJy2twn0ligSZ/YVJ2x0F/LtWWW7ENKRPyVEkLUd2naonblYHR5nJEloUjbilRZ1HNoX
 tDnuicr3
 GTLiP1vnPIlLA8eFSS9DKAOvYn3vz4zxDKu/tDGPsrszgjfhjhbT7/DgB3n5SB7FKwg9b1okxFnvQK80QJ8mcUTjMO5mTJzLzDZmI2hOAZU1GhiMUNenV7CnBbJckwz9o0rb6NqJXCi8/XYap2Zj6fNacbTFnE5NsI61VxKTB1Cmcv14hSbU05KMip2OV4R0BDbqI3ytzDTn4f3DZW7AfZzlJ6XeFyEfAYAFv3Kz05YkZhROeddafc5AiGq8c44u8/nJGmxrMUqNYSJbj1hfKUuhuC7hrtTLaGFobeyt8+0zXHme1wYEaaJscY563ANIQqEdf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> Introduce core infrastructure to support VM preservation with LUO.
>
> First two changes are just refactoring, no functional change, third
> change introduces a new member in struct kvm.
> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
> - Add a public kvm_create_vm_file() helper wrapping kvm_create_vm()
>   and anon_inode_getfile() to provide a unified VM file creation API.
> - Track a weak reference to the backing file in struct kvm under
>   CONFIG_LIVEUPDATE_GUEST_MEMFD to enable reverse file resolution
>   without circular lifetime dependencies.
>

Given the above, I think this should be separate patches.

> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  include/linux/kvm_host.h | 14 +++++++
>  virt/kvm/kvm_main.c      | 79 +++++++++++++++++++++++++++++-----------
>  virt/kvm/kvm_mm.h        |  3 ++
>  3 files changed, 75 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4c14aee1fb06..9111a28637af 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -874,6 +874,18 @@ struct kvm {
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  	/* Protected by slots_lock (for writes) and RCU (for reads) */
>  	struct xarray mem_attr_array;
> +#endif
> +#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
> +	/*
> +	 * Weak reference to the VFS file backing this KVM instance. Stored
> +	 * without incrementing the file refcount to prevent a circular lifetime
> +	 * dependency (since file->private_data already pins this struct kvm).
> +	 * Used exclusively to resolve the file pointer back from struct kvm.
> +	 *
> +	 * Written/cleared via rcu_assign_pointer() and read locklessly under
> +	 * RCU (e.g. via get_file_active() to prevent ABA races).
> +	 */
> +	struct file *vm_file;
>  #endif

We didn't really talk about this during the calls, but it seems weird to
preserve a vm_file with pretty much nothing other than the vm type. The
entire VM is re-created, which means it could potentially be a
completely different VM?

In some sense it's more flexible since the guest_memfd can be restored
with some completely different VM, but it seems like it could introduce
other issues.

I think other KVM folks would probably have more thoughts here.

>  	char stats_id[KVM_STATS_NAME_SIZE];
>  };
> @@ -1074,7 +1086,9 @@ void kvm_get_kvm(struct kvm *kvm);
>  bool kvm_get_kvm_safe(struct kvm *kvm);
>  void kvm_put_kvm(struct kvm *kvm);
>  bool file_is_kvm(struct file *file);
> +struct file *kvm_create_vm_file(unsigned long type, const char *fdname);
>  void kvm_put_kvm_no_destroy(struct kvm *kvm);
> +void kvm_uevent_notify_vm_create(struct kvm *kvm);
>
>  static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 89489996fbc1..65f0c5fb353e 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -67,9 +67,6 @@
>  #include <linux/kvm_dirty_ring.h>
>
>
> -/* Worst case buffer size needed for holding an integer. */
> -#define ITOA_MAX_LEN 12
> -
>  MODULE_AUTHOR("Qumranet");
>  MODULE_DESCRIPTION("Kernel-based Virtual Machine (KVM) Hypervisor");
>  MODULE_LICENSE("GPL");
> @@ -1349,6 +1346,19 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
>  {
>  	struct kvm *kvm = filp->private_data;
>
> +#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
> +	/*
> +	 * Clear the weak reference of the vm file.
> +	 * In case vm file is closed by userspace, but kvm still has
> +	 * other users like vCPUs, clearing this pointer ensures
> +	 * that we don't have a dangling pointer to a closed file.
> +	 *
> +	 * Cleared via rcu_assign_pointer() to ensure proper memory visibility
> +	 * for concurrent lockless readers under RCU.
> +	 */
> +	rcu_assign_pointer(kvm->vm_file, NULL);
> +#endif
> +
>  	kvm_irqfd_release(kvm);
>
>  	kvm_put_kvm(kvm);
> @@ -5476,11 +5486,47 @@ bool file_is_kvm(struct file *file)
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(file_is_kvm);
>
> +struct file *kvm_create_vm_file(unsigned long type, const char *fdname)
> +{
> +	struct kvm *kvm = kvm_create_vm(type, fdname);
> +	struct file *file;
> +
> +	if (IS_ERR(kvm))
> +		return ERR_CAST(kvm);
> +
> +	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
> +	if (IS_ERR(file)) {
> +		kvm_put_kvm(kvm);
> +		return file;
> +	}
> +
> +#ifdef CONFIG_LIVEUPDATE_GUEST_MEMFD
> +	/*
> +	 * Weak reference to the file (without get_file()) to prevent a circular
> +	 * dependency. Safe because the file's release path clears this pointer
> +	 * and drops its reference to the VM.
> +	 *
> +	 * Written via rcu_assign_pointer() because the pointer can be read
> +	 * locklessly under RCU (e.g., in kvm_gmem_luo_preserve() via
> +	 * get_file_active() to prevent lockless ABA races).
> +	 */
> +	rcu_assign_pointer(kvm->vm_file, file);
> +#endif
> +
> +	/*
> +	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
> +	 * already set, with ->release() being kvm_vm_release().  In error
> +	 * cases it will be called by the final fput(file) and will take
> +	 * care of doing kvm_put_kvm(kvm).
> +	 */
> +
> +	return file;
> +}
> +
>  static int kvm_dev_ioctl_create_vm(unsigned long type)
>  {
>  	char fdname[ITOA_MAX_LEN + 1];
>  	int r, fd;
> -	struct kvm *kvm;
>  	struct file *file;
>
>  	fd = get_unused_fd_flags(O_CLOEXEC);
> @@ -5489,31 +5535,17 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>
>  	snprintf(fdname, sizeof(fdname), "%d", fd);
>
> -	kvm = kvm_create_vm(type, fdname);
> -	if (IS_ERR(kvm)) {
> -		r = PTR_ERR(kvm);
> -		goto put_fd;
> -	}
> -
> -	file = anon_inode_getfile("kvm-vm", &kvm_vm_fops, kvm, O_RDWR);
> +	file = kvm_create_vm_file(type, fdname);
>  	if (IS_ERR(file)) {
>  		r = PTR_ERR(file);
> -		goto put_kvm;
> +		goto put_fd;
>  	}
>
> -	/*
> -	 * Don't call kvm_put_kvm anymore at this point; file->f_op is
> -	 * already set, with ->release() being kvm_vm_release().  In error
> -	 * cases it will be called by the final fput(file) and will take
> -	 * care of doing kvm_put_kvm(kvm).
> -	 */
> -	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
> +	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, file->private_data);

Notifying with file->private_data threw me off... I would rather inline
the rcu_assign_pointer() in this function and have this line read
notify(..., kvm) like before.

>
>  	fd_install(fd, file);
>  	return fd;
>
> -put_kvm:
> -	kvm_put_kvm(kvm);
>  put_fd:
>  	put_unused_fd(fd);
>  	return r;
> @@ -6341,6 +6373,11 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
>  	kfree(env);
>  }
>
> +void kvm_uevent_notify_vm_create(struct kvm *kvm)
> +{
> +	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
> +}
> +
>  static void kvm_init_debug(void)
>  {
>  	const struct file_operations *fops;
> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
> index 9fcc5d5b7f8d..7aa1d65c3d46 100644
> --- a/virt/kvm/kvm_mm.h
> +++ b/virt/kvm/kvm_mm.h
> @@ -3,6 +3,9 @@
>  #ifndef __KVM_MM_H__
>  #define __KVM_MM_H__ 1
>
> +/* Worst case buffer size needed for holding an integer as a string. */
> +#define ITOA_MAX_LEN 12
> +
>  /*
>   * Architectures can choose whether to use an rwlock or spinlock
>   * for the mmu_lock.  These macros, for use in common code
> --
> 2.54.0.1032.g2f8565e1d1-goog

