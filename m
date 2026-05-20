Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5A92CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0926B0092; Wed, 20 May 2026 08:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578436B0095; Wed, 20 May 2026 08:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48DCD6B0096; Wed, 20 May 2026 08:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7166B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:09:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C8D21402FD
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:09:01 +0000 (UTC)
X-FDA: 84787677282.30.21B55A2
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id BCE8340005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:08:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AOOd9yLW;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of tabba@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779278939; a=rsa-sha256;
	cv=pass;
	b=6MotH4no3hQGJ06kBarBSyIf8vL+l/gcAj6Qq+SFZiBBuY6BjfXVdLdY7IwxL3KoiCt9t1
	GaWAWFI6uhWK5iU5umZ4jwt03bl2RUBnldEkWpcI6CN0SSWR8OjUvsfrWaPxHLClsulE/5
	sNCgA2h7W4I3n64+a1WcergT9UjZPXw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AOOd9yLW;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of tabba@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Px9FMSWQfRWBgPBzexC/j5D1iZQd5J23JXma/NqqOY=;
	b=lXkkYlUYdg6rjS/iCc1F3jDuWosK9uBB4Z/qUClvPVz38JrGOY1/TlHErRkAeKxKR/pcCX
	3nmPfMqqCmCYohhVqiD19OEI/PTJ4HIqN7T5SfxHRG14mZJZxNpUjLkI7QzfxFE+towiuE
	Qv6quXQY0HAeOoAKwADNpnG0hoDa3nQ=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50e61648f10so561cf.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 05:08:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779278939; cv=none;
        d=google.com; s=arc-20240605;
        b=i9HJK+48dNNfKqu6fD+x7HKmYChlMF1y/WCRmAI1zBwkbm+7mszvcJTgS5RAjiSTNg
         c7zGpMdzKgAoIkbo3R246bf3osJFCHStgb+XF42icEfcrOY8vkkuZnpRUNf+su1D0Le1
         ODEIvcQiAj4D/+eFBjd8FI52ekaWyxfSweJqOoC2P+6H+jO88W4+5mFbxgxvtUqkttYm
         vbvljTPuKAlyZpYQZYpO2U1M06YGcCCmxq0VCDWiJKgyHoOCBK6UlJH21f+g5g0NIIzp
         N/6XEEgRTU25/+5IwRlR+ekt3L9baYRKRlSleH5JXE3eDTKsylJvQoU2sCG1k0eRQ+6i
         L7Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+Px9FMSWQfRWBgPBzexC/j5D1iZQd5J23JXma/NqqOY=;
        fh=sp4HCNdKspq68u2uilwFE+XBlrynp8w9njlv+EW/lvM=;
        b=XepGrw4zDgqzFn+/jCh6URdGaqSQu+BiLWCHG0z0yMlSV51of7ZrdqgRG1eSbUN4PL
         ohU47kdSxdsZYcCNMaFlr3pMsrMvLhraJJ5Qe1s/i/CsusQ/VlIlNlT30lii0rnvwf1I
         2P1pjUcIq+/1OUV8omsusRBj0BydB/dH4K72xy+aXx00bbTaXk+CjJhUsNWdhl4SE7bu
         XEniXPmhq0jbXeCq1SUPsdPLlBZeBXtP8iQ60Jes+fh3X1YqvLMVxcBdJBOxhhfe6Tx+
         Q6d60ShCBSbnBJEfcyJKxn2YtU97W7ae6Af1Kc8YmCl36fNY7Ae7zyEmsPsLxitLRRjN
         0s2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779278939; x=1779883739; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+Px9FMSWQfRWBgPBzexC/j5D1iZQd5J23JXma/NqqOY=;
        b=AOOd9yLWcR+8KHMGdBR1JrnfOVqdRCs/DgWETM2Lnk11svusb2CrmdztStKZyeQ9a8
         uzQSaZBfkHPivLxtm4u8Wq1ThPrYO5jGcbSTTzGKQCYXps+SwTL6GrcbefE2cPyDvdob
         TKCzWGHWzbctzi4KHa2zqJ2bwpMkhOKmb80oEIm5k4sxEim2ySliJo+yWY/udRvtRs6j
         V2xr7wsXyVFnG1kBymVWa3WH9piteojsfm0KoulbAsKYMuIbLbhsZbTuMJD3egBOa206
         X/8amvXqiMM+pmPyLVkd0sZPznzYnoFgFCb/COuzcFGjcRRMraxeKFxSVvXeqxfc1lKk
         oaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779278939; x=1779883739;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Px9FMSWQfRWBgPBzexC/j5D1iZQd5J23JXma/NqqOY=;
        b=p+xtSxaq78W6ZPA/KiyWU5MiP64YTyn4Mh/C5OvkrDDT3XhsUC5cS6Vk/zxMXkNBWK
         FYvhGEKHMOpGBHc7/Jl8m3EkgxPnBUsj9VpeeLdcMWchdd3Hk7l3WzM3Iw60brctfAKu
         Dgtj3uRHgZ1l3h2XTkxzWGz2CSH4CndR4EwihI24jNqKaXif0TgzNaZ7KHrMDYQt8A98
         1Pv2X9kpLyQB1N7TOJhvlPiKFCMVy26Ki8bxX5u2gHfHztdqiDGcNCCswK84FJfMybN+
         bPaUntjau0nv9QoaPptf5wezZKz9GNcK0ocs/V/+rMmBzXG5x+nivpcXisgztZ8Msgyv
         yCqw==
X-Forwarded-Encrypted: i=1; AFNElJ8EUKBzugODQ/qWuJatgCzfFYCzcN1XvSTHHlmBfTdddB8eCDEUcfgAI/0keNRjq6pHghyowRH/pQ==@kvack.org
X-Gm-Message-State: AOJu0YwHHhZr9GR0ZxzC5yHsq1ciF3lYDwhaMI837bWAv3IfzBsNd5Du
	Ghi2a4b2KP5YmYe1kbrw3vwCUIFG2tEgkr7bnzRvLrBpYQ6ds916RtbTU+90lvZr6rjLM1aONkY
	U84Dl4d6F+hUfz3+UuNiZt5jjf8iz80CczzQDO17C
X-Gm-Gg: Acq92OEeixtMtqn4Z8xKeZ9aXny9hhNSaD9EEGRt6P9Oir/nBYqMe5RHRICBsjSTWJC
	VkakQooFw5OF1wYjJYvqLgnJZLncKllsbWeJo0LcNW4GJudS3CXqaOo0hsEBQ/R0n6D5YPd8lDM
	wds67hO7DQ64hTRMYgOHAkP0pNnPtLADMlagqBTh+295AhVoaPOhhcqB+IiDQbcMcsxfs32o+ry
	zVk2HcrJZV4XAaUEcCRi2/kuAeheWfVXccfiGwGAaK40AAWxlHrpdSXFM3BtVemcjUZL4DNjemn
	coAmkB4kWCXXh3hwrhw=
X-Received: by 2002:ac8:7d11:0:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-5167b58811dmr18170691cf.3.1779278937787; Wed, 20 May 2026
 05:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-3-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-3-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 13:08:19 +0100
X-Gm-Features: AVHnY4LfQbiWdiGwXSEhGQDtGx7oiVEOShaBU1_EGdecpQaasdwwwCwSujlZjbQ
Message-ID: <CA+EHjTzvkF93kznZ6e5SBu-w9Gc_Z4ryDwg7qnjzWSPt4KfNCQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/43] KVM: Enumerate support for PRIVATE memory iff
 kvm_arch_has_private_mem is defined
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sdwwkf8u3r7cfoio3ch1akohmmd87pqk
X-Rspam-User: 
X-Rspamd-Queue-Id: BCE8340005
X-Rspamd-Server: rspam07
X-HE-Tag: 1779278939-858717
X-HE-Meta: U2FsdGVkX1+iUio33tie/7oe5aMhFcAh5s2hp5WUkKm7/0EFga0LDE3FXvPeV+XoY5o4YLA3N+GQawwV58uIBC3qVg//vBW4Z4cVksj+EuYArNBTu/+2fVW/hji9R3iJr9RnmJofRQ435USOJdUNmuACn8lKBqIRPnANuftpZ3/5kyUmW0v9XHK7E4jZrZhC3hZQeW7L+WFU/i8QU4Y3Y4K9COBtP1XwR2H2jbzaa3FmuqnlUqpW/MgeCuJhU0M9cyieRsi1fafG1l5ULaDrYAdSr1YoRQfHFzIwNwWT9elo8K2GRr91fd2SZyIgwMqJ8kRgYI0wYh1npAlSaDeHc6tDfKH3Jp+gPxBas/sznz4IWc5UtAoCG5hgIToNjyf3iVY+J0GswelY0kwSDOsN0IpX6Ogga/Ip+1lq5WdcEFo1S9decX8msflIo5omEQHEt4C3bw2oNnn+r270tdwy6aHF5OuctRbqct/ES8TJOhaQ9Xs8sBphtBVXQUak+xNEsl6NnyvERNVztrjC7jhf99HgPfYicz5TskvvWd05UNqJTvomNeiQKd6xEIYoxj2H9wfnLxId+cFGElSecHhMBXpUC05DjZW74MxnDjy5B99dyJzthbHy3O3GpzHQD9Qudz2o00Hr+zti1MSHgXfiL6xgi2KHjnH4cgzOhT6wJv1WFg4XDsUVi+FofcNt7SRt2qM0F4TRCXeGKnjTOml71LGY2QC6v/+Uc+S0ddWpfVO82toKsWgkPx3fpJvcAg10P59wkVo1TTbVFGZTrvAI173VkAKy6dTud5KAhtDtnEQMBlz9X5rmzLc/XDbtGhEZe3lUe86drbuVs0DOc1cDkF8OYJdSTsOidt/qRwR2hmlKkKEQvxlyu7IbTvyJY9ZiJiOt/fq5JU6+gpE0e3+kTDn1mo7IuOlmo9mQpyEH1th2rJmIyxn1T9+zcEFBapgx0NpWclLCKdtJ4m+j7Yg
 4jpNkz1d
 tp4WO17tPB7TZVT9sZux8RoVqTm5x+/JfVS+83arp9gFMZ3Ydf4GgCnDq1LcBBm2bQdvRLmnds7ZiEKTvN/L5QNgt7Fxsi+Y6mj95OwdM6x2w4b55nghJept9ZbJzIMIPaYZk4ALTHKUzAvVcm1wX0mBon+8bVX28ycwppzsJ4DnOziEMWX1fMVqGoRj4BPbzgUYMX7Lkn4+S0jM3EyIcSWy/sIMZ6yPrWm8/Yw9jVlrcxwJGWI0jL3DJxOZfoxBgeYzafX4a6XmrDSweAXzNvC+dkuoSsHsAtEwQIiRXbV+BAtRahGqzswEuxXtIpWp9UZSUsakw4G2Pcz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Explicitly guard reporting support for KVM_MEMORY_ATTRIBUTE_PRIVATE based
> on kvm_arch_has_private_mem being #defined in anticipation of decoupling
> kvm_supported_mem_attributes() from CONFIG_KVM_VM_MEMORY_ATTRIBUTES.
> guest_memfd support for memory attributes will be unconditional to avoid
> yet more macros (all architectures that support guest_memfd are expected to
> use per-gmem attributes at some point), at which point enumerating support
> KVM_MEMORY_ATTRIBUTE_PRIVATE based solely on memory attributes being
> supported _somewhere_ would result in KVM over-reporting support on arm64.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  include/linux/kvm_host.h | 2 +-
>  virt/kvm/kvm_main.c      | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7b9faa3545300..7d079f9701346 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -722,7 +722,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  }
>  #endif
>
> -#ifndef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> +#ifndef kvm_arch_has_private_mem
>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  {
>         return false;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 306153abbafa5..abb9cfa3eb04d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2421,8 +2421,10 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
>  static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>  {
> +#ifdef kvm_arch_has_private_mem
>         if (!kvm || kvm_arch_has_private_mem(kvm))
>                 return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> +#endif
>
>         return 0;
>  }
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

