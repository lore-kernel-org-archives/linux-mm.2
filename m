Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E184CC55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B6A6B0096; Fri, 31 Jul 2026 14:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24906B0099; Fri, 31 Jul 2026 14:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B626B009D; Fri, 31 Jul 2026 14:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCFF16B0099
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:37:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4587D12048F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:11:51 +0000 (UTC)
X-FDA: 85049562822.02.D1E8920
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id 95E5014000D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:11:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WW6iSqtG;
	spf=pass (imf09.hostedemail.com: domain of 3RMlsagYKCOMXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3RMlsagYKCOMXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785514309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bm06E1ea+m3fCfij6trKrrVxSCnF5pTP6S2pONTnQSo=;
	b=i/fzyHopr2jMSN5W17ewlyNGzcL/xN5n9mDl4WuALqedHX7MK6KyaEBu5KMnKGRQJvqcXD
	uAxOWxl0GZzOk0CCGCTmCdCR9nekgVDdqllGgu7ykbBrhdC1k0U1kp+2wbuXrY+FHhBOGB
	ZtUdH0Dp4czAwcc/1ilszjvTZIdm5yE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785514309;
	b=MmpzXaROyhr7bEifuukKnmRSrVdx1b9GchUqJWqIo0pw/oRpBg75RRXd5/7pFAnwEGEUO6
	TpFKnsia3RL/3CaNN5WrnXJyf4c2Mv6IsErZ6VzekBoYfo3NBGF/dzwnQ+2lgI8Tu03+qt
	qcd94hAfRTQEGwotepluZZKMOWmiAHQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WW6iSqtG;
	spf=pass (imf09.hostedemail.com: domain of 3RMlsagYKCOMXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3RMlsagYKCOMXJFSOHLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84885a4fcabso1475889b3a.3
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785514308; x=1786119108; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bm06E1ea+m3fCfij6trKrrVxSCnF5pTP6S2pONTnQSo=;
        b=WW6iSqtGUHiESql6xdlwQM+KJV5b/ft3YbH+wWDy5ByQtjWdfuKPmP1R0BeX2Ld3Zi
         j0ainPS//Ye3AAIAK/RUZ7WhEybc6zkdUoJOL5i7c8aVkrwrjdoJarB0cFP3VbHEQ5D9
         koN7ShKoi9LUW0+wkV7xVpf7X0cvcUt5B2hR8tvKPYbJ94qzB3oxlRbSsfJ6nQSLmckr
         JkrJSXRuMF6mpRVL8icDYlx1HcMuTvKwX4Gklcn7qcD8spPLr2p2vq8PpdmkGFVIXhlp
         OC0E6rIxJW+pZlwmkj1eG+Q+nuzLB+kT8wltLsMYO/mvyUggFjDfZO1Wbuj6CoLha77Z
         lQ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514308; x=1786119108;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bm06E1ea+m3fCfij6trKrrVxSCnF5pTP6S2pONTnQSo=;
        b=dCzFfrsFdpPblUjx7uA3zjPvaSh8pPafuR+z4T0hIo7x+GYmRGV5GS8eeftopeW+qO
         UQOG3VNYHW31+HDkfiGZtmAF1uUhGu7MJRxZ+F/Td2u9qN11l4bL/iant3IswxVGVGvz
         S6pcxG1i3On9kyGzRa6Jr8tK0FEwd4h8cREGIIcjQb7SLpBPCa+lJmQGUY/1kn7OhjuG
         E/W3CwZstB64mflObXEHOxjG7K8aYZVThXt8dNk+OsZNX86RF47idORjfWTBbrVrhKFj
         xrfC/Dj5oQJxBoW/Byv0rALRGvAuHFzboRJ6o4HBoA+LjuPKkaiKB8yH4PI9AsnW9Ge4
         fRtA==
X-Forwarded-Encrypted: i=1; AHgh+RpM+4mg5R+AdhSDM8ZgjDjo9tP72fQ0U88UMRkin8YDDGx0RTs66JfmpW6o7J2whSJJ+v70R3B/GA==@kvack.org
X-Gm-Message-State: AOJu0YxamzRp3sElGA0V7EFB0S8JfXR2Nh5hG6AN23o5hpwtDIpOVtXF
	vC6b7lVXjDxJUt8TUPa6fjLiMUlWt3VbPKxodJqIkucvUELbbO+KnpmgNmwXjWRSTmFUBgfdEfX
	1fFdHUA==
X-Received: from pgl1.prod.google.com ([2002:a63:b01:0:b0:c99:7baf:125f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4091:b0:84e:4d6:78fe
 with SMTP id d2e1a72fcca58-84ee47dc3aemr250368b3a.3.1785514308039; Fri, 31
 Jul 2026 09:11:48 -0700 (PDT)
Date: Fri, 31 Jul 2026 09:11:47 -0700
In-Reply-To: <d3fef015-0546-4993-b354-a8464d79e48c@intel.com>
Mime-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-18-35f9aec2aed2@google.com> <d3fef015-0546-4993-b354-a8464d79e48c@intel.com>
Message-ID: <amzJQ8u8I18B4Gdm@google.com>
Subject: Re: [PATCH v9 18/41] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 95E5014000D
X-Stat-Signature: d5ihcx1ywufdh4wxtynfi3ebqswoqk6j
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785514309-801621
X-HE-Meta: U2FsdGVkX18GBn0mZLTzBONYldysH2I5pzD7xsjDyeQFfdgqbyqCExGiWP6oiYKeWbVdPvAMZS/cyC8LkuCHj66wls1PCjeijct/Y3DLcvSi81gkQWSi6w5ypUTnyfH8Wcpj6R/Ek98c8hfy2reAzYjd28G/nK/NB7e5uDOiDNSi7ThYAV84pH/WXZsEWIFzJ38i2sF5lAR6ebdKXJu2i3y4/uhLSxoGET/3Gfocfq6E4Hkk1EJ1TILn5LIH2YE82d5Yz4/gFI11Ofu3d8QFhervv7+o7Tap6bhXPNbniMjNPsnsvuwU1B8DTDras72IgI6rNYWD24wnYFl0v+iWDDDhiXt1418FRXTd02GSba17FppAKETIyqNDYpDLwIt8Inn1LdzCnTnQ/1A8vaB9BnsH2J+mEHhAVk7V8xUM3k4MU62J7CJ74BmHQeqblSgBxoTB4strPXghqfccfLbBw0P55b8wvHJaGzGW19vt+6kQlCfbRqvI0DbpsY71Tqc5hHeqLLWaD1HjtSEhhTjV3s/GCS9MPDG7SNalfCD9v1yJZM5wohY5G0dpg8UByJhKdZ1p+dP7ePuC9YMBwzqFOqFpjCn4cmYqPFRURk+6Z6x0zvFXiBCSvPlo2rteeTiR4HQShhXmSgaXXOiXf+TRdryK7k+ww92Pa/riQV93xvXVMfyTuBF48NDOpVx3366+q4SZ7D3GLfgL67IBN/xONjHYg5xrdrpfvaHQQFDnYdhdyt7qgKspJ45xuPHLMxlvODi3nmjPWfJ8rGA3jvtmg+DZhS8WUAfwWzOkiRU9VpUakf1KQopWqFc6IPQIxnVHhN8Ymxhwjck3ZQDSttH5kKRw4jNVFSUbBKjgGzy7we+Tg6ScDfKOznVyo/wrVfjP3BR/YN1+rKywMWiLux6f8l9NYH0+KIEC+CB17Io/BUmbtn2AW6NYWpGkt9Vzs+oXXQc5RRBVBY5J+LH//sS
 DKbU3O/f
 e08UNXjgKQUMRHJ4WM1TKxF3wUzk2RCNlpqgvyYX82um+VkFAouWm8eWgxidQnR7QqJ/woe8uG4ROWobGGoLjQ9gQmXaPDiF4o4kdd7tKbXzAzefSf4r6U+PgQB6Lcb3+mNFapMipWk29aAcyd7zHSXKkxheitg4vvtlHZYQYl6uzzMfWdEQEyAXGsHDpwwCdWyUvFhnSpn2DEKwhlmrVd5aJz1V79sSjyt6vsrUHiXrGfK6p57onflwTjbOt08qcPX0g/JSCiUwKE3YlzeqKdZrHJznWIAJQuhHq5IfYZNPxljDcUz2el1Gz6UQ+6AVU69KAnDtjfdUtAvfz5bBjdWT8srbnzDpsLtT/4sF9iF/HehV5YmbjdU4hWJfmp6hT1IHXog4y4rZqvDJ/voM6w6sJ44Jgg7EvV6l4vE+qmAq7mpGX5xH6uqLRqFl0H9x7AJYmB1U+NOjRttR0V6siG7sRQLv0at3EL1ukSWSmLZMl6DRTzqRCj3jyzAozpaucvyZne8xLb30vvWC+rqXGokhf+ejC2xDsW2O1CvcsW0hGP81M/K6zbk5gpna9Qptjykmo6TaRHDpbXsLLWCuvPZmNVcZc5ougNc7n+g2hBKvK5OamQFptPXa0X3k6pD7b2UDA/lA9dblCXltfUVWg7QLpNt0Yh087BZ0RRIvF9AKdldPC3IGrhoLmlLTN+SY+ECb1aeO5nYwq1+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026, Xiaoyao Li wrote:
> On 7/29/2026 8:35 AM, Ackerley Tng via B4 Relay wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > Update tdx_gmem_post_populate() to handle cases where userspace requests
> > "no source page". To handle "no source page", populate (perform
> > TDH.MEM.PAGE.ADD) using memory in-place at the target PFN.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Tested-by: Shivank Garg <shivankg@amd.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > ---
> >   Documentation/virt/kvm/x86/intel-tdx.rst | 4 ++++
> >   arch/x86/kvm/vmx/tdx.c                   | 8 +++++---
> >   2 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
> > index 6a222e9d09541..d8d9409120e61 100644
> > --- a/Documentation/virt/kvm/x86/intel-tdx.rst
> > +++ b/Documentation/virt/kvm/x86/intel-tdx.rst
> > @@ -158,6 +158,10 @@ KVM_TDX_INIT_MEM_REGION
> >   Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
> >   provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
> > +If guest_memfd in-place conversion is enabled, pass 0 for @source_addr
> > +to represent "no source page". A source page is required if in-place
> > +conversion is not enabled or not supported.
> > +
> >   Note, before calling this sub command, memory attribute of the range
> >   [gpa, gpa + nr_pages] needs to be private.  Userspace can use
> >   KVM_SET_MEMORY_ATTRIBUTES to set the attribute.
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index d1af0a752e97e..e890da5f18aed 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -3192,7 +3192,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >   	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> >   		return -EIO;
> > -	kvm_tdx->page_add_src = src_page;
> > +	kvm_tdx->page_add_src = src_page ?: pfn_to_page(pfn);
> >   	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> >   	kvm_tdx->page_add_src = NULL;
> > @@ -3238,7 +3238,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
> >   	if (copy_from_user(&region, u64_to_user_ptr(cmd->data), sizeof(region)))
> >   		return -EFAULT;
> > -	if (!PAGE_ALIGNED(region.source_addr) || !region.source_addr ||
> > +	if (!PAGE_ALIGNED(region.source_addr) ||
> > +	    (!gmem_in_place_conversion && !region.source_addr) ||
> 
> Sorry, I still want to discuss why we only allow in-place PAGE.ADD for
> gmem_in_place_conversion only. Though Yan raised this opinion[1] in previous
> v8, I'm not quite following her argument. So let me try again.
> 
> I think in-place PAGE.ADD of TDX doesn't need to depend on
> gmem_in_place_conversion. There are two use cases actually.
> 
> 1). Userspace sets the gmem page as private, and invokes the in-place
> PAGE.ADD by passing a 0 source_addr. Due to patch 16, the target PFN will be
> ADD'ed to TD as a all-0 page.
> 
> 2). Userspace sets the gmem page as shared, and writes the desired content
> to it. Then converts the page to private, and invokes the in-place PAGE.ADD
> by passing a 0 source_addr. The target PFN will be ADD'ed to TD with desired
> content.
> 
> For gmem_in_place_conversion == false, only case 1) is possible.
> For gmem_in_place_conversion == true, both case 1) and 2) are possible.
> 
> Basically, this patch is changing the behavior of KVM_TDX_INIT_MEM_REGION.
> Before, it returns -EINVAL when region.source_addr == 0. Now it wants to
> allow the "region.source_addr == 0" case. If we can allow it
> unconditionally, why bother adding the restriction to allow it only when
> gmem_in_place_conversion == true?

As I said[*] in that thread:

 : Because retroactively adding support for out-of-place conversion is pointless
 : (requires a userspace update for a feature that's being deprecated), KVM can't
 : generally support using the source for out-of-place conversion (it's effectively
 : an obscure zero-page optimization), and IMO rejecting the out-of-place conversion
 : scenario is valuable for KVM developers, e.g. to help newcomers understand what
 : exactly is and isn't possible.

[*] https://lore.kernel.org/all/akMPZePBdwQlD74H@google.com

