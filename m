Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3D410FCAEA
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 21:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE536B0088; Wed,  1 Apr 2026 17:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F296B0089; Wed,  1 Apr 2026 17:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7DBA6B008A; Wed,  1 Apr 2026 17:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5E5B6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:43:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63C4D1B70CB
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:43:50 +0000 (UTC)
X-FDA: 84611314620.02.44A431F
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4EF1540017
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:43:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AcdV4d3j;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775079828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YVI0hayK/pE2zwI/10lFSwnfbjn36xvcFyuXZ+58V8=;
	b=eYcA2ziAZ5CV4jBz3DqerqKtTOoztCIVTlXscB84go1i+P4+FqJh6YrklVhix4BIkk+EkT
	2xJAY7kL1eIx6yCoFt1n+jVujOWOKSWpj8YA5hTkGAFu+WGKPeP0sUVQn3BXKhWZcuB7VG
	pN4bYun7BkdG42sCOIUAiH03sb5IRuE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775079828; a=rsa-sha256;
	cv=pass;
	b=uALqipBCjFKOmJ2qlwU08E6UO7fAShZDJsnb3arIQNzmHoiAVYMN9wIW5/E9b5lvuA2ZGI
	IIuk4FXMiAnwHLH3KqTDvBhKlcMe+naY1PzxzPcQf4Vogx3Y7rA6UWOBFJgw06nAzCwTmf
	vtyV3JoLFfyRXNlI9HiaSLJ5L8eGWVE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AcdV4d3j;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-953b7d2c820so78563241.3
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 14:43:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775079827; cv=none;
        d=google.com; s=arc-20240605;
        b=AxRcdwq8VWj76ubPHSgl55UMQwXeQ/NyIquMjQwRzqJFk5gwCkMENFkas3+fIA8wOi
         9gViVNAsKB9MEOvr9PjEm1iXVy8R5rOS2P8/SjqthZyAcA5MuU5QGDNN/4jRQa4mhyM7
         W/mY8mdaHmyx/4TsNlm/ChaeetIhp/rNySZDt99GzvEpHEwSi84q3fabqI6aLU1ZfSVM
         vEuez3KaU/9n/I+j9nJ6G3zp87APksRT9Up2ka8JdVJ2wA58zX48A0POnWtUGR4UFXBi
         WV9zZf3fa0/tkSTcEHDZF+iK1JNhDLktSUhE5+HgtkySaNdmHIVPKTa/eeXh/LoI8TFl
         pjhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=1YVI0hayK/pE2zwI/10lFSwnfbjn36xvcFyuXZ+58V8=;
        fh=pYecjgC/DXNXsUX9w2k0A1WyGOuBv8s9DZGTT7qA22o=;
        b=dg2gI0gMB6hLCOdkmEMORMdVDvcxMG9VS6wIF4E3FFiDOnTpJ8KC5HVTgueegnDGEQ
         CPXghMQhYNqyQ74/uu+Fyr6HqiCNhTVGxwNuu+Wb77KZI7mNLJ6o/JgNeasgisjcZjEx
         OsMvtmrtE0xd0/MYfxpBdx0x/SU2WBomtqjrsFJAp6c2Y8Aa+A/I+3jiH+SNcR8XSpog
         2GTub+d7boPoXz04RtBs66YYFJs8PBGBPW/k6/jSU/cq5zDAQWT4VPKsu/DaOZh9sIXX
         7irhNdpfXoO/yOHhLFnkSO3aBf3uYTg0vtKhPSXdzpt5aYF84XmBz1iYPuQ7Ph/OZ0MH
         DS+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775079827; x=1775684627; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1YVI0hayK/pE2zwI/10lFSwnfbjn36xvcFyuXZ+58V8=;
        b=AcdV4d3jGF/Oj47YLzCpb31TUMvTGf6bN4VB+FFjho+u2cwRcSKWV6QRZ89lTMXXQK
         KtkArkF2ZdDRLZK743eXBaYbhIHCaOmxLaBg4LZa3IFnXr2PZFjb40bxD8ZrN0jBqd1d
         K/zURlSQAEV2+tHngc+k4OQayN6d+RKOWyMx+mliyojtQYNyyTVic1WIRupGO/2F6gME
         997JNBLp3I1M35WjEJdBsGESkVlHjRKydBl/OMPyye8D6EkIV/3c6w+bAbKFxAZXA9tk
         jhqTrLz2dEoyxmuR6LoSHKNYR7+nKio7hXmiHTSSrzXjNdQlfY1/qJpE8Af9Mv5FPUH5
         1qsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775079827; x=1775684627;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1YVI0hayK/pE2zwI/10lFSwnfbjn36xvcFyuXZ+58V8=;
        b=AVU+Qs0lWYLIs4URyIN/UKUO79xi0JjfycArR738MYen272hKM9JvxjrsrQYxuadpv
         sZ+EYoMzK2gnnZ8/Wx77DaU4he04xwRbIw7OtA9loWadtpW1tJl24K3qevhwhYpZV8do
         5nfHG7njIcaDTlunWSnrtxayf4XSeRj1toddC05cUfvGnKTRQ/iKKK35EQ9yvd87iujr
         sIAysAKRJwYTNYJ4TX/9+CbKtpuKz3TkOJmTEO8GNHtekNnXX8MSklxRM7oAfiQXx9pl
         dfMUeXpwWE/jM83WAHPlsy5vazOHF+CJSu+j/whMipFMvjcMNH4PUw2XZxqID9UKBCR+
         Hbhw==
X-Forwarded-Encrypted: i=1; AJvYcCUbMJYaI/yVrUP67Jg5y0RTMRMSJbDE+q+xlp4q/DxHM8DKYpwkdpXcrAImQ/eg4Nvxcq2VQBKrpQ==@kvack.org
X-Gm-Message-State: AOJu0YxilVSdY7yNcWgt7klD5uVOdNoLMnvugLpw7kyh7puBQTjnxQXt
	uB76SYgVG8w2DND8ZBRtfXscjhb05KsOJHKpnXhubsiSUDhdcNniXqfWDOdklCMjMwFiIfkQaFi
	LAydhbzdIfR7b0TwkcaTnbgFT6wZDL9Bhv06ypzRf
X-Gm-Gg: ATEYQzyMZLyZQ0Z1NziHPZfviTCKOqPqkBxoPySoPI3Ll2DbKq+BQyH8KUnBo4eujyD
	heMJxC4k6GPDkkkO1+d3ICOAbpRTGIPVGp+sfVT4V/5EF5LipLQaZK8wr1kOfZSd0n/yMq3Iv51
	nFW2BucdvOwiB4AdmnS4NUG7dyp1gJx/pUzJg0AkKus4qVLoNdfRg0GPZaTcu6ptHqG+0vo1xa0
	TTeQKIeos/5ouy+aWNOMOhdvQVx9zbl8q6qqV6oMPgWUT/okZng2fdqEBiVycHqvn1GjUa8ywyM
	/rxeHsxsyktMdmj0nFpA1Yp8LxW2im29s8zzsrmwvMaGT3mOPa8Q5v0EoBBJZPakfci8TzzNBnz
	35rM8
X-Received: by 2002:a05:6102:14aa:b0:5f5:4055:4556 with SMTP id
 ada2fe7eead31-60583dd2d96mr513571137.4.1775079826765; Wed, 01 Apr 2026
 14:43:46 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Apr 2026 14:43:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Apr 2026 14:43:45 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <s4dbqrv2c6yzt4nsflfarnggtl25xlz6mzg74tfeg3eskceno6@6l5hpfmcbju3>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-7-e202fe950ffd@google.com>
 <CAEvNRgF+FjJ1EWSR_rzD1=N040ZitiRrM2O3N0Kj5yN5rT3h+Q@mail.gmail.com> <s4dbqrv2c6yzt4nsflfarnggtl25xlz6mzg74tfeg3eskceno6@6l5hpfmcbju3>
MIME-Version: 1.0
Date: Wed, 1 Apr 2026 14:43:45 -0700
X-Gm-Features: AQROBzB6Nm5vUeDCJFrJRBVH_sKZ67O9qJoiuhUvd8m5ueyFjs7DkYFcGmC74e4
Message-ID: <CAEvNRgFQU6daGzYY1nTm=9omJ7ca3Eam3DuWRZPeRpYRiYM2fg@mail.gmail.com>
Subject: Re: [PATCH RFC v4 07/44] KVM: guest_memfd: Only prepare folios for
 private pages
To: Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4EF1540017
X-Stat-Signature: gmja9bdwrpgdnmzp7yzg8fph9agcnuf8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775079828-636122
X-HE-Meta: U2FsdGVkX1+/x31RCbqSa+e9PWId7swWhGOFUi86G0Z5Aa+6FLblD5YumUR0L/KE3Vo+wEsqXjUOz2T5voYzukToFc1f2bPU8JW1RR+fuYwLenKv+NWuErvJTHW71gMhp/zo3KXe61EM5PUT/xM0A1e0lYkQii696NoBFJXKif8RNv1SgLhFO/JdpaWeGD22///9xocK88+GF+xlSv23piya+kI0a58Zs87LfmlRRrm9kKikwuQbNZbKhVNOw+bN8Xo+w0lMiN5gid2SnqU4Mq72J/Vm1cT+B73A5GAA8/dgGcP8sxzi4MTzlgwhxeg9dct9wtGYS4170wnP0Wnxf9asSWTKe6FYqOXHUMl47K3tSAT+FuGuTE1AbbopspK/DpioF5Po3sETHe5PUTyskwivCowpJ15OOtMKEmuWSHHncRahTu1iOLGhwBxmZZJAP9Xna59eHE1LZHBlgxVgOLlOM0ol/D7DzowgAOTIwPaNQ+sNFntclhcH8qNlvuRirjDqAYgzcWRjhA6qnfIsciMrICdOhyY6MWcaP5YrcU3RYvaTtqEu1eg7Y1RqistqKqcveNK/Tr0MRIomryXKVAEXyyQj0lUgGkow/ISPTB+l0YvS725VhArs4pIU3jQ+wN2mWB8JeBWGzgJFj+B0ecKe+a8cRvm6yXgty89VVI9dWyEbmwpXE1HemdX4wMyQ5FF+iADiolJO10R7cUWpjTtPXNuM/qYsizWNFZ+0Nk+DLLGf9FfCuIyTP/LH+87JP8VEsbSb8bH4rwux+A4Udanm4bXz/GQmF70QmB+ccpYxWzAd8cxDMBhNUxdmPO8E5yXSigBISVuJ7Qb7EXGkilDugIcBeBRfWjUGQuDQeA/7bZejhFsaj7Hepiz5TWe+nH19j/MQQMSLYpY+5fJyeFBzQQ9EnF5TGlfGrsJyAOIIFDXWwo9WJF289h5LCltf/xZzcDlHkenbIrXH/l5
 uOUzhNeW
 jsH5YxlPQZ2FEz3VGs4x8gmjloPMRO6MtiYqqL7CfDNk0W/rISjblrCKYCDAePTeJLeyfZDlp61IsYxxkZfdvopbR56FMbKy+ny3oFoyi0FC/cK0XUpAgcAWrMd5+SyC0WrsjAI6ZLJp3G9hx3GPyEgDmCOVhDKksflps3U/IUx96cbSjq2tNJrLEqTxtGoCIC50cJdYUB1s8lBeKb2NzA1HIjzaBD44BqAbGrbdaZAlq9VcQPAn9G1NgFB6bVCeixWzkO/fePMq6tl6pt8varDpnQat8NgjN7OPAVT4IAV7Y2/aOSWDiqyU0DpY4fHvb0LJhMtQh60StmEHvIGLw9MiXkFH4shN9zmcPNw0kWSidETp5xFit8liqbkEuWRp47lrJqtyMuUVou4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

> On Wed, Apr 01, 2026 at 07:05:16AM -0700, Ackerley Tng wrote:
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>> > All-shared guest_memfd used to be only supported for non-CoCo VMs where
>> > preparation doesn't apply. INIT_SHARED is about to be supported for
>> > non-CoCo VMs in a later patch in this series.
>> >
>> > In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
>> > guest_memfd in a later patch in this series.
>> >
>> > This means that the kvm fault handler may now call kvm_gmem_get_pfn() on a
>> > shared folio for a CoCo VM where preparation applies.
>> >
>> > Add a check to make sure that preparation is only performed for private
>> > folios.
>> >
>> > Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
>> > conversion to shared.
>> >
>> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> > ---
>> >  virt/kvm/guest_memfd.c | 9 ++++++---
>> >  1 file changed, 6 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> > index b6ffa8734175d..d414ebfcb4c19 100644
>> > --- a/virt/kvm/guest_memfd.c
>> > +++ b/virt/kvm/guest_memfd.c
>> > @@ -900,6 +900,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  		     int *max_order)
>> >  {
>> >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>> > +	struct inode *inode;
>> >  	struct folio *folio;
>> >  	int r = 0;
>> >
>> > @@ -907,7 +908,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  	if (!file)
>> >  		return -EFAULT;
>> >
>> > -	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
>> > +	inode = file_inode(file);
>> > +	filemap_invalidate_lock_shared(inode->i_mapping);
>> >
>> >  	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>> >  	if (IS_ERR(folio)) {
>> > @@ -920,7 +922,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  		folio_mark_uptodate(folio);
>> >  	}
>> >
>> > -	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>> > +	if (kvm_gmem_is_private_mem(inode, index))
>> > +		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>>
>> Michael, I might have misunderstood you at the last guest_memfd call:
>> sev_gmem_prepare() doesn't prepare a page for being a shared page,
>> right? Does this work? That prepare is only called to "make private"?
>
> Hmm, I guess your guest_memfd-inplace-conversion-v4 branch is out of sync with
> these patches?
>

My bad, it was. I just force-pushed to github to synchronize them with
this patch series.

> I have the below local patch based on top of that for SNP-specific enablement,
> which is basically identically, so suffice to say: yes, this should work
> for SNP :) If any architecture pops up that needs to do some prep in
> advance of mapping shared pages, then we could potentially plumb the
> shared/private flag through to the arch-specific prep hook, as was also
> suggested on the call, but it doesn't seem like that's needed by any
> users for now.
>

Thanks for checking :)

> -Mike
>
>   Author: Michael Roth <michael.roth@amd.com>
>   Date:   Mon Oct 27 07:58:32 2025 -0500
>
>       KVM: guest_memfd: Don't prepare shared folios
>
>       In the current guest_memfd logic, "preparation" is only used currently
>       to describe the additional work of putting a guest_memfd page into an
>       architecturally-defined "private" state, such as updating RMP table
>       entries for SEV-SNP guests. As such, there's no input to the
>       corresponding kvm_arch_gmem_prepare() hooks as to whether a page is
>       being prepared/accessed as shared or as private, so "preparation" will
>       end up being erroneously done on pages that were supposed to remain in a
>       shared state. Rather than plumb through the additional information
>       needed to distinguish between shared vs. private preparation, just
>       continue to only do preparation on private pages, as was the case prior
>       to support for GUEST_MEMFD_FLAG_MMAP being introduced.
>
>       Signed-off-by: Michael Roth <michael.roth@amd.com>
>
>   diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>   index 3acc6d983449..4869e59e4fc5 100644
>   --- a/virt/kvm/guest_memfd.c
>   +++ b/virt/kvm/guest_memfd.c
>   @@ -1249,7 +1249,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>                   folio_mark_uptodate(folio);
>           }
>
>   -       r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>   +       if (!kvm_gmem_is_shared_mem(file_inode(file), index))
>   +               r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>
>           folio_unlock(folio);
>
>>
>> >
>> >  	folio_unlock(folio);
>> >
>> > @@ -930,7 +933,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>> >  		folio_put(folio);
>> >
>> >  out:
>> > -	filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
>> > +	filemap_invalidate_unlock_shared(inode->i_mapping);
>> >  	return r;
>> >  }
>> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>> >
>> > --
>> > 2.53.0.1018.g2bb0e51243-goog

