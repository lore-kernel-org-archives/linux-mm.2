Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61946CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 16:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B07F6B0088; Sun, 18 Oct 2026 12:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BD86B008C; Sun, 18 Oct 2026 12:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4033C6B0092; Sun, 18 Oct 2026 12:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F027C6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:53:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49C8AC0531
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:53:09 +0000 (UTC)
X-FDA: 85336342098.05.4E9C45C
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8DD3D1C0005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:53:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=JVessS2R;
	spf=pass (imf20.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792342387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04K1XWtuV3X33sgYJ/vH8S9+3XQC8lVkjSB9505KyUg=;
	b=wNQVewOI0JROypRjsqfWXWnNpwmYNaWL4uifxDhhOVAy8ysbCf3/1UEX60GMgQp+PoJFQP
	S9V9LstVCNeBwjtmqFLQa3c9oFHJ4mSj2y1w/BLkZjNu10Q1PffelmA+Ohjmi7+1h2+1up
	k4RlNbeSoqwDzNf8Esp+K7TW9Vds/Vs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792342387;
	b=n2hzf5GnZq0brye2GhMwAXW6FjVnFu6QxrzBd3aIVTdEvn8r4ncd7QvivgQJk0Kydoa9fa
	Rdn3ZXEdQoyU2r/yWBI0jCdncgPJchKfW8kF24nWHCNKISbe+2F1l7dmWlA9raXZ9Jurq3
	jvhlL6Y2wypYK8zY8fOT64YdXDsCsG0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=JVessS2R;
	spf=pass (imf20.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 69IGqanD1091127
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 18 Oct 2026 18:52:36 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 69IGqanD1091127
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1792342357;
	bh=04K1XWtuV3X33sgYJ/vH8S9+3XQC8lVkjSB9505KyUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JVessS2RxHUeJkGFl8SPVnWHq5IUr3hSCd38JkUfDYfgapnzTdu57hmkRCJk1DpSW
	 CThaGmZEjrXdXHTbV2K3MAyJcFLXW2+TMmjAlXnm/Bspn4GgP8Kjt6jD5E7zVp+ZTi
	 RnvbEeQQmcVdLdlDcGVt6ncxHjhBvGGl/JbDlmZQ=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 69IGqZiZ004275
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 18 Oct 2026 18:52:35 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 69IGqTuU3136419
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 18 Oct 2026 18:52:31 +0200
Date: Sun, 18 Oct 2026 18:52:29 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        David Laight <david.laight.linux@gmail.com>,
        Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, david@kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
References: <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
 <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
 <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
 <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
 <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
 <atI_yuCc4BiweBQP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <atI_yuCc4BiweBQP@google.com>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Stat-Signature: nj6taigaddnai5auoyrajn3x3z9j7jd9
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DD3D1C0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792342386-839047
X-HE-Meta: U2FsdGVkX19pyjR5/QP/udGz4H3/1oil3iJy19RSg5q9yKz6qTp4S936BqtGLz1IxSOSPdrEnPRX4jehW1cWWEFyFPDdABLOjK9+cLQD9PWtWSGYpbtbPCf804y7nxOS8idQlYHk6RuzTFVw1sA6EyyG7XbEM4sZSqKPd318qbINo9KilVOZeq2GOEDZPNd6yd79MSNTOq8ijFhr+K3MM79OFoHXB8fHneiURUlRUif66DyfFQ6rKnjHE9GVQLYlPNpczAPXRphphxtt3lfOGoY80Q7HPgo8hOE5VRuizhT7Yoc5GDOp5ZVLspxYXs2i7jbEvXr3iwo6sIcpzgnRZ6Bd8MzsAIGrNgo0WGm+QVFJPBtzll3qXNExpEEamfPQFvvVF8nPK7siIgyZuYn/RWKjyeISKKEjR5ikKaag7ZSynDms2u1mBzrnA+Bu43Z4IDXY+JezkcnX+csy/WvsqjJZlEKCu8nD7ehtilyVvoBUYYP0H16UTccQvZu/Sfrg+GfUMsKHSHpF/D1DPwcLJVQB/cGDfkfnXq8fx6SsC8NKxwew2PNL9/q2+bIa7obZOHiKEiHCS2378kB/KD73PF4L6UhgeVDp32c7IVAD3PaSzHbN6lEeiv2x9aUVVFdY3e/m6LTLXCFsCF9Rtcn03WwXcO8/Yg3qcnpDVdPWTfdpi4dnob+QfsRlhCelQWqoil1PTxAA1TiegSYF8cnfELLRx2NkWvAu6bIgoozQcvN0fCUuu914oVi+uiiHHUIqGnX0+fcjms876Dh0At88Keiuo7f4RWtQs6cXrXzEtlRbl710YvuqVwGndRJcrZNfZxYC3K/xPTZb8128gvOWOEyeU8MnZijwSgSayybO0nTJGeDc8BNOOM9rKS/duzgyBGLAaQ80KeAAC31WdXB20Vsa+ghHk917DTWXGMgmGBwRGs3/k5oj31Ku/GkhaG7oZqArhtWtIfdIHVLMKph
 s/a8uOrF
 1TcGCJHsPoGgeYvzagO+iQVgI7Ke2ua1wHJ9Z8osjkUbmw0Q8OMrkH/4CpSnyd6mIimH6xYulztoowaAZ5VEpuUlYXSLAal+Wu+wioVg9hc+HnTa2ccq2N0MGWurdFS1JjUiFws1IVKpGrrzS8kq/aZKpaPmzDLzLTtCLSprVhDEtJ2ipyuU66WHmfU6pFxcvnpHCzm1DQqGAwDWxM1GTxq+saUz/qZZ8NJPBz7wM1/UL7A/MSkmtd8IAUmTAxR0tDnuXNoDl2g4Ic41DZ6aFa7qvV+8v1GNxITvRicx2lyeHRi8ydeL9b3/BoZMTFKCqBKsdyjaQbLN8MB1Lis9Q6CSR+Ln1KqzrFH2mwn5CZCqB4ajNR0Zm7skLNExzRVSa+RJgGcxlHqJaJspz/Pjsw0AOLMJibmYsIeHVMOMWSKsrKYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Sean (and others),

I think I've finally found the (at least) one missing piece needed to reproduce
this. At first I wasn't paying much attention to nested virtualization, because
 we don't use it much (or so I thought), but I was still wondering why
 why all of this seems to be tied to Windows guests. So I dug into advanced
Windows security features and found out that newer Windows versions use
something called Virtualization-Based Security (VBS), which relies on
exactly that: SVM/VMX, i.e. nested virtualization. (I'm not a Windows guy,
so excuse my ignorance here.)

So I enabled Secure Boot as well as VBS on my lab test guests, checked
msinfo32 and tried migrating them and voilà, the guest crashed almost
immediately.

After a few more attempts, it looks pretty easy to reproduce: it usually
doesn't survive more than 3-5 migrations (often 1-2 are enough).

So far I've retested 7.3-rc7, and it seems to be rock solid (60 migrations
and no issues).

I'll give your patch a try, and if it doesn't help, I can try bisecting.
Now that I have a reliable reproducer, that should be doable.

I'll report back soon.

thanks,

nik

PS: of course this can still be something different that memory corruption
bug I'm hunting, but still it'll be worh backporting to LTS 6.18.


On Fri, Oct 16, 2026 at 08:16:26AM -0700, Sean Christopherson wrote:
> On Thu, Oct 15, 2026, Borislav Petkov wrote:
> > On Thu, Oct 15, 2026 at 09:18:32PM -0700, Andrew Morton wrote:
> > > The corruption patterns strongly resemble AMD VMCB state, particularly
> > > FS/GS segment data appearing at the expected VMCB offsets in unrelated
> > > host memory.
> > 
> > Aha, ok.
> > 
> > > This suggests that a VMSAVE operation may have written to
> > > an incorrect physical address.  Ordinary KVM performs VMLOAD/VMSAVE
> > > without nested virtualization, so Boris's objection doesn't eliminate
> > > this possibility.  However, the relevant assembly is essentially
> > > unchanged between 6.18.55 and 7.3-rc6, and I haven't identified a newer
> > > commit that convincingly explains why the corruption apparently stopped
> > > reproducing.  The earlier candidate 55780d8a1dcc remains poorly
> > > motivated without evidence of nested virtualization.
> > > 
> > > Two investigations look worthwhile.  First, test 6.18.55 with both the
> > > KVM TLB-flush fix (26505e1b5b54)
> > 
> > Pff, we've been looking at that one recently too, trying to figure out whether
> > it was really necessary.
> > 
> > > and tlbi=ipi;
> > 
> > Yeah, we checked that, it ain't that.
> > 
> > > the existing results don't conclusively establish whether that combination
> > > was tested.  Second, examine the vmcore to determine whether the corrupted
> > > host pages contain complete FS/GS state matching a legitimate VMCB, rather
> > > than merely a few matching values.  If they do, inspect the VMCB's
> > > VMLOAD/VMSAVE interception and virtualization-enable bits.  That could
> > > establish whether a hardware VMSAVE was allowed to write to an unintended
> > > physical page.  The successful 7.3-rc6/rc7 testing is encouraging, but it
> > > doesn't yet prove that all the reported corruption symptoms share one cause
> > > or have been fixed.
> > 
> > Hmm. I guess looking at and around VMSAVE handling wouldn't hurt...
> 
> @Nikola, as very long long-shot, can you try running with the below?  I don't
> expect it to help or flag anything, but this is eerily similar to a known bug[*]
> where KVM writes to user memory in the wrong address space (wrong process) when
> tearing down a VM after migrating the VM.  But that bug (well, bugs) only affects
> Intel, and I don't see any similar patterns on the AMD side.
> 
> [*] https://lore.kernel.org/all/20261001202234.3794060-1-seanjc@google.com
> 
> diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> index df1d0cf769475..fc0ae4727793b 100644
> --- a/arch/x86/kvm/vmx/sgx.c
> +++ b/arch/x86/kvm/vmx/sgx.c
> @@ -63,7 +63,7 @@ static void sgx_handle_emulation_failure(struct kvm_vcpu *vcpu, u64 addr,
>  static int sgx_read_hva(struct kvm_vcpu *vcpu, unsigned long hva, void *data,
>  			unsigned int size)
>  {
> -	if (__copy_from_user(data, (void __user *)hva, size)) {
> +	if (kvm_copy_from_user(vcpu->kvm, data, (void __user *)hva, size)) {
>  		sgx_handle_emulation_failure(vcpu, hva, size);
>  		return -EFAULT;
>  	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f65081330c8a4..2dec1463b596c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3902,16 +3902,16 @@ static int init_rmode_tss(struct kvm *kvm, void __user *ua)
>  	int i;
>  
>  	for (i = 0; i < 3; i++) {
> -		if (__copy_to_user(ua + PAGE_SIZE * i, zero_page, PAGE_SIZE))
> +		if (kvm_copy_to_user(kvm, ua + PAGE_SIZE * i, zero_page, PAGE_SIZE))
>  			return -EFAULT;
>  	}
>  
>  	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
> -	if (__copy_to_user(ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16)))
> +	if (kvm_copy_to_user(kvm, ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16)))
>  		return -EFAULT;
>  
>  	data = ~0;
> -	if (__copy_to_user(ua + RMODE_TSS_SIZE - 1, &data, sizeof(u8)))
> +	if (kvm_copy_to_user(kvm, ua + RMODE_TSS_SIZE - 1, &data, sizeof(u8)))
>  		return -EFAULT;
>  
>  	return 0;
> @@ -3946,7 +3946,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  	for (i = 0; i < (PAGE_SIZE / sizeof(tmp)); i++) {
>  		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
>  			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
> -		if (__copy_to_user(uaddr + i * sizeof(tmp), &tmp, sizeof(tmp))) {
> +		if (kvm_copy_to_user(kvm, uaddr + i * sizeof(tmp), &tmp, sizeof(tmp))) {
>  			r = -EFAULT;
>  			goto out;
>  		}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3c4e2401de072..13f44961e6e7d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1341,13 +1341,35 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  			      gpa_t gpa, unsigned long len);
>  
> +static __always_inline __must_check bool kvm_can_do_uaccess(struct kvm *kvm)
> +{
> +	return !WARN_ON_ONCE(current->mm != kvm->mm ||
> +			     !refcount_read(&kvm->users_count));
> +}
> +
> +#define BUILD_KVM_COPY_USER_WRAPPER(fn, to_user, from_user)				\
> +static __always_inline __must_check unsigned long kvm_##fn(struct kvm *kvm,		\
> +							   void to_user *to,		\
> +							   const void from_user *from,	\
> +							   unsigned long n)		\
> +{											\
> +	if (!kvm_can_do_uaccess(kvm))							\
> +		return n;								\
> +											\
> +	return __##fn(to, from, n);							\
> +}
> +BUILD_KVM_COPY_USER_WRAPPER(copy_from_user, , __user)
> +BUILD_KVM_COPY_USER_WRAPPER(copy_from_user_inatomic, , __user)
> +BUILD_KVM_COPY_USER_WRAPPER(copy_to_user, __user, )
> +BUILD_KVM_COPY_USER_WRAPPER(copy_to_user_inatomic, __user, )
> +
>  #define __kvm_get_guest(kvm, gfn, offset, v)				\
>  ({									\
>  	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
>  	typeof(v) __user *__uaddr = (typeof(__uaddr))(__addr + offset);	\
>  	int __ret = -EFAULT;						\
>  									\
> -	if (!kvm_is_error_hva(__addr))					\
> +	if (!kvm_is_error_hva(__addr) && kvm_can_do_uaccess(kvm))	\
>  		__ret = get_user(v, __uaddr);				\
>  	__ret;								\
>  })
> @@ -1367,7 +1389,7 @@ int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  	typeof(v) __user *__uaddr = (typeof(__uaddr))(__addr + offset);	\
>  	int __ret = -EFAULT;						\
>  									\
> -	if (!kvm_is_error_hva(__addr))					\
> +	if (!kvm_is_error_hva(__addr) && kvm_can_do_uaccess(kvm))	\
>  		__ret = put_user(v, __uaddr);				\
>  	if (!__ret)							\
>  		mark_page_dirty(kvm, gfn);				\
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ba09b1dabc4b7..aa1564d41e7ff 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3207,8 +3207,8 @@ static int next_segment(unsigned long len, int offset)
>  }
>  
>  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
> -static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 void *data, int offset, int len)
> +static int __kvm_read_guest_page(struct kvm *kvm, struct kvm_memory_slot *slot,
> +				 gfn_t gfn, void *data, int offset, int len)
>  {
>  	int r;
>  	unsigned long addr;
> @@ -3219,7 +3219,7 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
> -	r = __copy_from_user(data, (void __user *)addr + offset, len);
> +	r = kvm_copy_from_user(kvm, data, (void __user *)addr + offset, len);
>  	if (r)
>  		return -EFAULT;
>  	return 0;
> @@ -3230,7 +3230,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(kvm, slot, gfn, data, offset, len);
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_read_guest_page);
>  
> @@ -3239,7 +3239,7 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest_page);
>  
> @@ -3283,8 +3283,8 @@ int kvm_vcpu_read_guest(struct kvm_vcpu *vcpu, gpa_t gpa, void *data, unsigned l
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest);
>  
> -static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
> -			           void *data, int offset, unsigned long len)
> +static int __kvm_read_guest_atomic(struct kvm *kvm, struct kvm_memory_slot *slot,
> +				   gfn_t gfn, void *data, int offset, unsigned long len)
>  {
>  	int r;
>  	unsigned long addr;
> @@ -3296,7 +3296,7 @@ static int __kvm_read_guest_atomic(struct kvm_memory_slot *slot, gfn_t gfn,
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
>  	pagefault_disable();
> -	r = __copy_from_user_inatomic(data, (void __user *)addr + offset, len);
> +	r = kvm_copy_from_user_inatomic(kvm, data, (void __user *)addr + offset, len);
>  	pagefault_enable();
>  	if (r)
>  		return -EFAULT;
> @@ -3310,7 +3310,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  	int offset = offset_in_page(gpa);
>  
> -	return __kvm_read_guest_atomic(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_atomic(vcpu->kvm, slot, gfn, data, offset, len);
>  }
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_read_guest_atomic);
>  
> @@ -3328,7 +3328,7 @@ static int __kvm_write_guest_page(struct kvm *kvm,
>  	addr = gfn_to_hva_memslot(memslot, gfn);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
> -	r = __copy_to_user((void __user *)addr + offset, data, len);
> +	r = kvm_copy_to_user(kvm, (void __user *)addr + offset, data, len);
>  	if (r)
>  		return -EFAULT;
>  	mark_page_dirty_in_slot(kvm, memslot, gfn);
> @@ -3466,7 +3466,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  	if (unlikely(!ghc->memslot))
>  		return kvm_write_guest(kvm, gpa, data, len);
>  
> -	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
> +	r = kvm_copy_to_user(kvm, (void __user *)ghc->hva + offset, data, len);
>  	if (r)
>  		return -EFAULT;
>  	mark_page_dirty_in_slot(kvm, ghc->memslot, gpa >> PAGE_SHIFT);
> @@ -3504,7 +3504,7 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  	if (unlikely(!ghc->memslot))
>  		return kvm_read_guest(kvm, gpa, data, len);
>  
> -	r = __copy_from_user(data, (void __user *)ghc->hva + offset, len);
> +	r = kvm_copy_from_user(kvm, data, (void __user *)ghc->hva + offset, len);
>  	if (r)
>  		return -EFAULT;
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

