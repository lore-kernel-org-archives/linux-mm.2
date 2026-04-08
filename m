Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0734810F9972
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 19:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46AAD6B0005; Wed,  8 Apr 2026 15:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B826B0088; Wed,  8 Apr 2026 15:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A3A6B0089; Wed,  8 Apr 2026 15:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F7A76B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:48:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71131139F40
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:48:18 +0000 (UTC)
X-FDA: 84636425076.25.E6C3152
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9746BC0008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:48:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BJ0sMsFj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3_rDWaQYKCBE9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3_rDWaQYKCBE9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775677696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSE638E7Oo0EzKCt6KnXRAv3sjqReWn6aOHcZy7PyI8=;
	b=maalzxcijX3e8DCLwr+yztjKNa8m3EyO8sYnN1JR0Oa1KpXtunZeNSQ22TZ8Oh9JnDY3L2
	l6f506wt7no1pU8j1bmhmDJaQCQW1BdqH3on56nQm5tc0Tyblj7s988BlFellnVISIoX/U
	BUyjYdDfaEMvUGomAGAHnj15/6zwYYI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775677696; a=rsa-sha256;
	cv=none;
	b=2wA4nIgUFAvu2QMVLzWCDhbHcMxSJk3VtQcve0YnNsAVWtAXqJ4QmK55k9UtAg7IJ/m2bL
	W5PdScQhRow0tsDjOnWF8SPx4dGBe2DIr1NjP87hD7Imh/GT5D2t1g8LPiGcdk+0PSmmzo
	w6eM8nxhZJzilxWq1muK0589cyMoRZA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BJ0sMsFj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3_rDWaQYKCBE9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3_rDWaQYKCBE9vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82cec239147so85064b3a.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 12:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775677695; x=1776282495; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aSE638E7Oo0EzKCt6KnXRAv3sjqReWn6aOHcZy7PyI8=;
        b=BJ0sMsFjGt+o+ubWvMgeGAeu8RNsQjLXyMN38POiSIdf4aAkIfpgg+tddhbHHlYhiB
         /ZCqf9hg7TOAbA9+khfR7OzslMLi7voEUY9GGcgnQPLcBjJa57LLackYs64iyyKw9ixE
         gMutdeIcr+wfcwBsdqBiqMAcY61yNAvekxWGKGJh5Our0h5HkoYGQmtUhVmrbCRhqqFM
         FP2jENY7S8cr337NLCz79zpCZM9T5TBkkodkrPCCVutwkPnXfFL70H6suvxdegPrHd1v
         qoq0YIuGXpqLP9iiDEHmYhDRHbiJSRgYngmbdhox5a7Se6nAMktddO16jCqqCAc3tcBB
         XfoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775677695; x=1776282495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aSE638E7Oo0EzKCt6KnXRAv3sjqReWn6aOHcZy7PyI8=;
        b=ODJ4Wr7wAyNKO03zi3xLeUZiv5bcrV/ozMxkH/Vwrqxu81La/Q0zQ2hlwOSTqdzAI7
         me8JFStTn9/tbOEn4YfDwXQzT2xfLueJLmL8i8nfyUSgp6Wmpo46OI2i/DMbrqok1plR
         2VOk/qYUHsvys5mRVyp1d/0253EcSLHYAtA3zp/rjfDvVjy88ysAZfjKPIT8NS/1mOAd
         fTogROuWWjH3rnDNKW/p3aOnSkECL5CYq6cIPbpFMh2oB+s1evjFJyWwPdM8yOHUoNJe
         iry9CVb+OKu/s1P2BekzSxb2a8yHyszAFejSY4nCQc5Q+Qs1pjOABTQ+6Foa+UokjNWN
         HMVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCn8FbsY36Df9OPaBFPDBStaveHf5E9a3KusVBXlfsVgrjzAd6SJaKh88eZpHMLb5yt3/FlAW3oQ==@kvack.org
X-Gm-Message-State: AOJu0YzEWosnbQSIgIHgnPOYyJHjykgKXSEOIJFRWCW+cyX+pLQYlSLF
	0SNmT4mVSj7U7whSfsiUx/ZLtueEHhpl9gTuLjAAQ7j8yApRXPCotIgkGQC6uptmFdrI/V27GER
	4cKDUYA==
X-Received: from pfbea13.prod.google.com ([2002:a05:6a00:4c0d:b0:823:b9a:9230])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a01:b0:827:2ee7:baaf
 with SMTP id d2e1a72fcca58-82dd8aba4afmr575225b3a.12.1775677694713; Wed, 08
 Apr 2026 12:48:14 -0700 (PDT)
Date: Wed, 8 Apr 2026 12:48:13 -0700
In-Reply-To: <CAEvNRgEcKnHkgC2iK8hRMybruY5LrxWH+RK94M7MddUqgGChHQ@mail.gmail.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <CAEvNRgGm9icDK8sK5ZfqHEOEqSbvjwtihE4p9d3vpBq-NfVjmw@mail.gmail.com>
 <CAEvNRgEtigp7+PVDkyu_DH947CUqDt312d+P+hWjjd2fHONiag@mail.gmail.com>
 <yvfwexsub7nrogh67hzcsupbrkzer6a7kbeao5tlq4elrzc2iz@xrwdjd7p32pp>
 <CAGtprH-kgRByFvvCYeWMXtsvpb6qpaWAo8k-3PEnioyPg-LEvA@mail.gmail.com>
 <nmy5polcxfnn3hoircsiqarxmzlulwwq7w34okanccntp32v56@h2eac44agovv>
 <adWidf8UgZeYctr1@google.com> <CAEvNRgEcKnHkgC2iK8hRMybruY5LrxWH+RK94M7MddUqgGChHQ@mail.gmail.com>
Message-ID: <adaw_aEJYTLgJcEw@google.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, ira.weiny@intel.com, 
	jmattson@google.com, jthoughton@google.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 9746BC0008
X-Stat-Signature: e33pzp514ts9tknkdjgiztzu38raf5z3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775677696-446839
X-HE-Meta: U2FsdGVkX187x0csfrXdYk9GgEJLQU2WdMyenu2u9z1YZY6av5vhVM5+bNajQO2tMsbpOp0Tc4gjuxdxQUsp81f3TPonxTkOnpMZpuBCO+kJMaaIm+P3WSRCSW3IK7W54fjR5RhMCA1DA+R0U1vONJMGuPOxcxofO3tFeL4KReLueWC5JoxSoYguk3wV2rPANVjyu5JPTh3g53kv0zCBfOnPJaTXfvKDGDLp8NlRLZ3UoOdEAc+FKJHTlZpCyVyJf9WRIkg9byKRGyjgvuJh7flywFkPPND0TsAhpERl1DXYv5s09f27v0q9HFJiyOn55SyuB0bltPMiR+u5A1NQ+BQeg1OKMOc48DbD9Ut7shAwCAOsWQrT1WRBfyT1Aek49noYcTMHQIjwo0t2577Cw6BezkBXTYps1HnG/rKF4+BUPkKYAv+/qzba2yaV0W37y7+Tyu7hyi++dkJDCMoGbtLhSUgf9qwO+8c6ZwI9fqDUceySS3KM1el9ydADsHuDLS6oVzGq9tHZ9mCCi1Xi474l68azlB2mT0Orrk0u6akKsDknyc4IBGX5BSNb9ANP8nS6u4O1XTt8kf+39j4QoUBIOJqmmoJ0ZmWNqE7AhoaEJHaIH2g5iS8lTUgcVm7muD75mc359rTdeTA7UTejiJ/wORH14azumUt1VKUMb3JQFiHYT3rmbTxpMMqYOG6Xl5YvMXDbZMviAtHB3Xwf+bw82DtOKAkf+KY00EujKMcbZq3HS+OrTy0bA7m5j9faKGmINHAPVJ1WKELI/rbPUwoSq26ypUtKF5DBvvVkd6A9wvb47xIncKHibmZIWrnTSMHZf4z6LCgj2nl/EryoMUHJatxGWGWtdioXP28rfVEmmQHj4naZAUjoW4iEvmGcjxl47miC26IRzfngRYnYQ57i0c3kQuNSCAKbaGKG54Mj77avFct3ieN+YMFNDtM14mWLg+56qkZq4IWBD0k
 pov3lE4f
 A1JxuAgJzj1rQJjIVioGHmOiMLzJTa+3hfQ6tF5pleKEXt2S/1/0szJEc0iIcRz2HT+pIQFIKOeQj1oeSpi89E7+IHiN2WufTyhPstHLMZgqOW4qkn93bc7E9ZmnhkcJB6etW6OAiudCggZuKs2gr2KbD4i6iWUxT8y7XMawC8KmDYwWcl8jUGbnzcECNvAPw/kyHgOd/sQzT/KCZoV+0a1RuZkAf0t1uxYi3MfUOaaSyi72xhC9LQj6cVRKVo4r1AFnBERjTqifZLsDI0DTHywdxmNbwUoeXLoVKLg72r1C4yRnxUyfJT+njKe9iHv3pe6BbGJ9PoIETePktNyDwbVGYWyjupwlO1mIGAK0ogytlmFMmdjiMip92uMf+gIqdgAoIGNU+Llg2AU0T+nQayuSWwNJ+Ftv9J4PUhDF33URchlRPUotL3vyYMoAx0Ftc3ECWPX5uWr5e2KCI8tfHl6neF3QumrC0hLIjqobsJPPjWFGAZef4YgCwJryG6Rmvw6p0A+Mo2mQF6KTHcix6L0PCNPTfR0HeG9J4mXrShYsZTh/F82KtVnuUF3zWVe05GqE3dF+d438oaRD1FH9ZqUb1FG8WHKQ9IdOq833uVP1x35FrHRjHzFFmtZlXk5L4U1wiS40bsMrmFQVCWzqsWndb0RBUtm39yfeyJ/fQtnZ4gQEFApbAFVsotMdJSECp3G0+of95lf/ZFbTLLlgCeUZ9tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > On Tue, Apr 07, 2026, Michael Roth wrote:
> >> On Tue, Apr 07, 2026 at 02:50:58PM -0700, Vishal Annapurve wrote:
> >> > > So I agree with Ackerley's proposal (which I guess is the same as what's
> >> > > in this series).
> >> > >
> >> > > However, 1 other alternative would be to do what was suggested on the
> >> > > call, but require userspace to subsequently handle the shared->private
> >> > > conversion. I think that would be workable too.
> >> >
> >> > IIUC, Converting memory ranges to private after it essentially is
> >> > treated as private by the KVM CC backend will expose the
> >> > implementation to the same risk of userspace being able to access
> >> > private memory and compromise host safety which guest_memfd was
> >> > invented to address.
> >>
> >> Doh, fair point. Doing conversion as part of the populate call would allow
> >> us to use the filemap write-lock to avoid userspace being able to fault
> >> in private (as tracked by trusted entity) pages before they are
> >> transitioned to private (as tracked by KVM), so it's safer than having
> >> userspace drive it.
> >>
> >> But obviously I still think Ackerley's original proposal has more
> >> upsides than the alternatives mentioned so far.
> >
> > I'm a bit lost.  What exactly is/was Ackerley's original proposal?  If the answer
> > is "convert pages from shared=>private when populating via in-place conversion",
> > then I agree, because AFAICT, that's the only sane option.
> 
> Discussed this at PUCK today 2026-04-08.
> 
> The update is that the KVM_SET_MEMORY_ATTRIBUTES2 guest_memfd ioctl will
> now support the PRESERVE flag for TDX and SNP only if the setup for the
> VM in question hasn't yet been completed (KVM_TDX_FINALIZE_VM or
> KVM_SEV_SNP_LAUNCH_FINISH hasn't completed yet).
> 
> The populate flow will be
> 
> 1a. Get contents to be loaded in guest_memfd (src_addr: NULL) as shared
> OR
> 1b. Provide contents from some other userspace address (src_addr:
>     userspace address)
> 
> 2.  KVM_SET_MEMORY_ATTRIBUTES2(attribute: PRIVATE and flags: PRESERVE)
> 3.  KVM_SEV_SNP_LAUNCH_UPDATE() or KVM_TDX_INIT_MEM_REGION()
> ...
> 4.  KVM_SEV_SNP_LAUNCH_FINISH() or KVM_TDX_FINALIZE_VM()
> 
> This applies whether src_addr is some userspace address that is shared
> or NULL, so the non-in-place loading flow is not considered legacy. ARM
> CCA can still use that flow :)
> 
> Other than supporting PRESERVE only if the setup for the VM in question
> hasn't yet been completed, KVM's fault path will also not permit faults
> if the setup hasn't been completed. (Some exception setup will be used
> for TDX to be able to perform the required fault.)

Nit: as Mike (or Rick?) called out in PUCK, TDX's flow is now a separate path
thanks to commit 3ab3283dbb2c ("KVM: x86/mmu: Add dedicated API to map guest_memfd
pfn into TDP MMU").  I.e. it is NOT a fault in any way, shape, or form.

tdx_mem_page_add() already asserts pre_fault_allowed=false:

	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm) ||
	    KVM_BUG_ON(!kvm_tdx->page_add_src, kvm))
		return -EIO;

so I think we just to add similar checks in SEV and the MMU.  This can even be
done today as a hardening measure, as the rules aren't changing, we're just
doubling down on disallowing (pre-)faulting during pre-boot.

E.g.

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 73cdcbccc89e..99f070cf2480 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -363,6 +363,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
        };
        int r;
 
+       if (KVM_BUG_ON(!vcpu->kvm->arch.pre_fault_allowed, vcpu->kvm))
+               return -EIO;
+
        if (vcpu->arch.mmu->root_role.direct) {
                /*
                 * Things like memslots don't understand the concept of a shared
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2010b157e288..f0bbbda6e9c4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2419,6 +2419,9 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
        if (!sev_snp_guest(kvm) || !sev->snp_context)
                return -EINVAL;
 
+       if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm)
+               return -EIO;
+
        if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
                return -EFAULT;

