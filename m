Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4DCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E593A6B00A5; Tue, 30 Jun 2026 09:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30966B00B1; Tue, 30 Jun 2026 09:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9296B00B4; Tue, 30 Jun 2026 09:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1886B00A5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:06:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 15A531204DF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:06:49 +0000 (UTC)
X-FDA: 84936603738.25.D71F2F5
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5F0771C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:06:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vmsu547p;
	spf=pass (imf20.hostedemail.com: domain of 3Zb9DagYKCEw6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Zb9DagYKCEw6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782824807;
	b=GjmSs63iW2I6i3fQDjDgMbo8AjwwniHaaFm/flZuPu59kWCQNu17052NaVtQMbGXm4vqkF
	0qTpFSj6R+xoSRhtcWL/s/ssnItMk/JjETRmJn/81nO5GFucJa7XESoCHE7BwFqtXXo4CG
	wlZ8aqPkzPPriOinLXFgJBB2mnA/jWY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782824807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKmnhEmEL5Q9+VdT5YV6KYZqx0ZeftgvFW7GNXKQRJU=;
	b=g6VnanoJfwFQUdjouFgZbgJDDRA/2m7BL1wEmIUneQblcpofOLZuluQdHNAQAAizzG1GZQ
	/rEyVVoEvcB+Zp3KFVuboaKpVJ4E7H20ZBLMswIu0K/hhK5XtVOoxHhZxO5P9402RlbSmS
	cv9cRSEB8BVFyx6X6Wdv/U9r7OLd900=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vmsu547p;
	spf=pass (imf20.hostedemail.com: domain of 3Zb9DagYKCEw6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Zb9DagYKCEw6so1xqu22uzs.q20zw18B-00y9oqy.25u@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-37fee8a7813so1769744a91.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782824806; x=1783429606; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GKmnhEmEL5Q9+VdT5YV6KYZqx0ZeftgvFW7GNXKQRJU=;
        b=Vmsu547pYqZ4zgGXD4Je3YdPKFQLVygr5n/dRwLrsrdkJqmnOudfmRcj+1pkkpUFtX
         QcA13y8ehRx3V0mSGnxvWii3OpYuL0LswFyZOwlLtvhPXmGFsHZ5m30aVioRGjOuuOuL
         c00/o4cTUqMeUpD2AJnapy+0F4VBZXyO/YKK4vMODQemSPFGFY0mNcMupcYkbK/16O5W
         Z68zCW4Fmf+enXG0vTB6BvTMFEM6iVLir8FV3oY/5krW2fNgtwSi2kzj7G33f6Utq+B1
         Ys9LqYk2ivWATTdXhuXcaH8NB2sKjB1tECzHFS7D2NCN3WmJlOWo7BZJQ2TELPi8b2ip
         VoeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782824806; x=1783429606;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GKmnhEmEL5Q9+VdT5YV6KYZqx0ZeftgvFW7GNXKQRJU=;
        b=agx4P3kO/oqshccNB2Jy4K9RS3VskQblKvn08DDfWI3SwGTkLp3rYM44dS21FOsA/4
         heBRWD/GWo+64sRxUPqboUHxxXTy8Fq7eWCCMLO7f/prHzktOpLBUOvRJ5L8Tvg61amg
         AmnJljHAJaXoYVcterD/qtHsTMyjFOdewg65PCoPNAY39UMpgSlA/XfpgX/1auDouq3I
         wyk+eXbBqZ4QWN3r9G/Xb8JMqMRtiVq4P3t2b9uJlbHzD+eRu6E/4A6ZBens6+DBfyEq
         +XYqvMib5kBCqSL+CrC9Qa7H8PeBKeKMB6K1tcVU/YMafRP0uUPjVXdfSNMSY4u/xZGL
         i14w==
X-Forwarded-Encrypted: i=1; AHgh+Rpjb/PqrtPCptRGvHXTcSKD+KupVpG9PkkKySejVM6yk9F+zNEaAPnXQdWZYplduR8IH7qFw/ydZQ==@kvack.org
X-Gm-Message-State: AOJu0Yx31APi2ncBuapqkwgBXGPD3IUwN7Eq/ApuE/tmbwHh2Rnhc+iS
	xAK+8Vc3BJkWkKF+KCPS8OY1e4xzjzdXpFvUN+OpGFWRu96PY8rrE7dy37CuwbyKbWfoar7kFBv
	ePSjboA==
X-Received: from pjboo8.prod.google.com ([2002:a17:90b:1c88:b0:37d:8595:7a08])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:390b:b0:380:540:d49a
 with SMTP id 98e67ed59e1d1-3808bd2ffe9mr347677a91.7.1782824805381; Tue, 30
 Jun 2026 06:06:45 -0700 (PDT)
Date: Tue, 30 Jun 2026 06:06:43 -0700
In-Reply-To: <6b1f0c77-f059-4f8d-8f46-443b944c59a0@intel.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-4-9d2959357853@google.com> <6b1f0c77-f059-4f8d-8f46-443b944c59a0@intel.com>
Message-ID: <akO_Y0-ERgBoCqoQ@google.com>
Subject: Re: [PATCH v8 04/46] KVM: Decouple kvm_has_arch_private_mem from CONFIG_KVM_VM_MEMORY_ATTRIBUTES
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: qy1u1azb86xdaji6eii4g1enxzyhfeqz
X-Rspamd-Queue-Id: 5F0771C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782824807-673506
X-HE-Meta: U2FsdGVkX1/Lai076YLE3Rzk2Q95MYoSiEMp/K9amothW151184Tpn7w9rUklvkr1+S3OgUiOTHQjURRUvquFnrf0uoFiOW70l4Zt76l7BpaSG8Bi1G/5iWiEHNiQvZ9BsrkrDVgf9U75bZFxVOwsoTiwDx4/c0+xeg9cZqp9JoQbmZxo0SKxXYPbMffbAVXdHzkPOR6FcziCXCDlgQBUJxYWwRIU8vuiKXj7vVeXbWUci39cdWJW7Rtm9H2cdVlc+npVuxpbwaVclLJqEtekOrr52xd5QBulRoem4cnHJ7pn2WBuiJENKJ1VYSMQlFAKOrwFX8e8jDVBOm9mJT1N5fhJyICdPz69CZPTnjt1UHbDqeuyg7pnrG4IorDE5Jo4JCDyar5dpM5sUhPaBTuLreuTKAHw71F4oFEYAEeKPUkZPD1CJYzpZ0MHvKSGqFhZI+ee+4ev50rEnKEPj0Y+aU6Rb2CmUdqEahlxjQY4vFZuBSCn8kCIaZ4tLSl59+kxHhkCNTaOemgAk4G9gb0v63w880irHKCBS5vpl8UKeULy+uS6bHjrzBosCksZFidpTbg1LpSVmgMMItM86n3txlD1x4ufbos6HbLIZyJCK+ldjPjRZD3gs19QN5d3vOzxIMxxsW90HXHHskC9G4l/TalXNU7NAyJdFG0L/oM15x+6PLQGx0gm7Z3O/EE0DRge1AF1gCYpGUvxPJ5f2Z/MMC0EY2HSIQ0VkBw1PupiOQfhVyhwh6Wfdkzfuq0o9jFattr0/R8Nd8NBmxczHd8+CV0kij0AZsFKUsjWOpuVYvbFiqAUHGkkGjqIzNkuNCcg3lisfgMzA/qafitzoeYy98o2q88ghgwPTv90laudzXt9A6I9n6B4Ga6ZvUyibZM/5PNgoxls8u8/ogHnDBrLcWrGT46BWLmhsiSRjFXaDVrUkpSjFGbNavpZzowiQObisyZ/5lEAOEggN0+xv/
 PnBYexDi
 U6HcySiU5MSg3XjSv6Lke72Tg1+z+Qb9urFUjjnst+2uYarH9p09AB8KU3wDKpigVt8nfkvtSGD7FUDL8+qdlYSnp/VTG3BCCE/hyp7sCOAq7lzFPYKzyKERApRMkuQTRX+NetG/f1buNMXrpXGj9+Dhp/IMaaJ3fBjVH2ii1tCeP/AbF6tGhVkfo0xulN2FQVltIL9ZLnnGLaudhAZFa5KGaPKhnvivV/PPK2vgu23cAPSnWa54sVZ8CgTDPrKi8F36umnizjQXJ1RNiBV094CJKqtqxV4IUTdpSLUBuRvtY+4YKCp4js/Rsv555d5+HtJV5bvEAQtJbznduVsUH7UWobXJIV3yrLj2AvD+8++tDUVnXibWqL2tLokKtKnr7zjCA0O8kciFxDXTXKutlEvzBJkyo/1U58/8jlxsxwoqfS2/TcBo/cGMnNcq+849TLvQf3BBfgAzpYFXp0gbHytb5rYkAlX12IV47EDbiB/VHcORBnaqlkVQ7LsqgkpI+2cKwE/ZRvS+KvSeyV2iONTRfEKSGJfwQi3S14tWdJxjjNn30aPd9kN/C3qi9EJoQKoHxH6BTvfgaa/T3WBMaOH/5wgCqrIhQ/31eKTYKofO4QohLlCS2d32dpetWt2qdYt7tn92UwPmf2Sc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026, Xiaoyao Li wrote:
> On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> >   arch/x86/include/asm/kvm_host.h | 4 +++-
> >   include/linux/kvm_host.h        | 2 +-
> >   2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 8e8eb8a5e8a6b..1bde67cf6eb0e 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2394,7 +2394,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >   		       int tdp_max_root_level, int tdp_huge_page_level);
> > -#ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
> > +#if defined(CONFIG_KVM_SW_PROTECTED_VM) ||	\
> > +	defined(CONFIG_KVM_INTEL_TDX) ||	\
> > +	defined(CONFIG_KVM_AMD_SEV)
> 
> Maybe we can just remove the #ifdef and make it always avaiable?

No, because common KVM keys off the macro to determine whether or not PRIVATE is
a supported attribute:

  #ifdef kvm_arch_has_private_mem
  static u64 kvm_supports_private_mem(struct kvm *kvm)
  {
	return !kvm || kvm_arch_has_private_mem(kvm);
  }
  #else
  #define kvm_supports_private_mem(kvm) false
  #endif

And also whether or not to provide the in-place conversion param (without PRIVATE,
conversions aren't supported in general):

  #ifdef kvm_arch_has_private_mem
  bool __ro_after_init gmem_in_place_conversion = !IS_ENABLED(CONFIG_KVM_VM_MEMORY_ATTRIBUTES);
  module_param(gmem_in_place_conversion, bool, 0444);
  EXPORT_SYMBOL_FOR_KVM_INTERNAL(gmem_in_place_conversion);
  #endif

I agree the #ifdeffery is ugly, but kvm_supports_private_mem() in particular
needs to evaluate to false if PRIVATE memory isn't supported.

