Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C6BFF5131
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 17:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192976B0088; Tue,  7 Apr 2026 13:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16A346B0089; Tue,  7 Apr 2026 13:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7256B008A; Tue,  7 Apr 2026 13:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF36F6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:52:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A032FC2579
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:52:55 +0000 (UTC)
X-FDA: 84632505510.05.B40E885
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD696140002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:52:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ssQpUW7x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3dETVaQYKCKcZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3dETVaQYKCKcZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775584373; a=rsa-sha256;
	cv=none;
	b=XWsEk/LnvbJjCz1+AZPpXp4U+Jw8Eow0Hu6vHFeMCj5VZqFcNi81R77J2/BIlyPNOst+Vw
	/8Qyj66/tJC2bH9VPBItBjva86Nj5Ku/X1NKdGvIAWAVkYh/lUh4woE5wUj25NKkV3NwJr
	iaof7ILmJfSTIx+9SOsJfi77FTRUFh8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ssQpUW7x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3dETVaQYKCKcZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3dETVaQYKCKcZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775584373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/MSOJp/AJlf7hUTMD/NXnVkTNNfR/Z7vvW8KkUYbLI=;
	b=4cdE9sM7beE/ViG7NGnMxwP6Xj+19WIwi05nxjNVQahF4R3XvWBwBcNq0GIfWBLKUc6dzg
	VPLiENg/odcNMLHwvl7ev+eVNAoBR7FQrrJgqxBsRQ9Zxd7V35HhbL1WOb4sQx2pz3Gbe8
	33q8Jy5lOoI+kir3dtqa/EEOE/Shg+s=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3594620fe97so12613549a91.1
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 10:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775584373; x=1776189173; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X/MSOJp/AJlf7hUTMD/NXnVkTNNfR/Z7vvW8KkUYbLI=;
        b=ssQpUW7xtP7F9y4zT/VdqBzLbU0LK1A3ifh6BOG56wkxFVwJIugvjI3jyXhnRxCH6z
         CJ2fPSadeRHKnWEdIHSz/eeNN9DKfqzkm8mg6DxQsAkiF0rHSyf/xzk+ShwVTNTdHS6y
         nYUIF3xe5pdKGAVIbuUjng4nBB+8pP+PRW+E4DRux7U7oXV75KnTHY2DWn/+ISbc2n69
         zICuXjxaYvaAOpBzXE6+lZtwTDGGZ1R36MSEwcEyH4bZ/rNG+YxppoS8H+2uW3L7QjU4
         GxnMKoMndasPllPe7wtyypFa913PoMszOMJZhqUXFDP88G01jY/aF76q9Sqw3oa0Ok5X
         wO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775584373; x=1776189173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/MSOJp/AJlf7hUTMD/NXnVkTNNfR/Z7vvW8KkUYbLI=;
        b=dae664NrWbHyi13/xK1/bHAqIyD8pFx8Nrfs187uupOn86Hsq+GpS/jgnVxJPnRO6b
         qCils2iMZMGDr+pAXviPXAnq3lLhZH08/l2tcFVJdpqhSfFZaGaqONNN0nfFgAgURoYh
         iMG5sN2YXIBWq3GQQgLpFPPPpsyH3w9VfYzUYzJy6MaXpcaZTcZv4Xykfhy+5wGxGLkB
         wBXGraiGJut/hVFkNlTWBrGi9LVB3JmbP95IsEIELGcYly77ABiF0Wt4a3PhH8LpQ7RI
         BuhRNTUUpFM+9rgTOT66jMbjwFEnQQR0Ed7LfV9nXNIfJn4Jbagv+eLmrJYVCttT42dT
         l0HA==
X-Forwarded-Encrypted: i=1; AJvYcCXS+dGkhsNF4EHDasFUNH2rGOpnErhOzZNn8iT2rErQiGWsh8wRdL/4iHF8Q1t5TS54dQSbcs1p3g==@kvack.org
X-Gm-Message-State: AOJu0YxrGF+DE1+TP+nRQOH1G8dvPnfSOx8wvplE2QZy46z4rZ076hBU
	1g0qhhAzynbvPN/TRy1TrLpf+4xDieoLHMu44t2XW3I/ewQxfPGCwduhmmymgvwM8AJ3KU+x3Hf
	f72LF1g==
X-Received: from pjps16.prod.google.com ([2002:a17:90a:a110:b0:35d:94b3:bd6b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2885:b0:35d:974d:8f7
 with SMTP id 98e67ed59e1d1-35de679c8ecmr16179304a91.1.1775584372473; Tue, 07
 Apr 2026 10:52:52 -0700 (PDT)
Date: Tue, 7 Apr 2026 10:52:51 -0700
In-Reply-To: <2a216ee2-aebb-42ba-b2aa-826488448bbe@linux.alibaba.com>
Mime-Version: 1.0
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <545847c132da5d957cfc74ab19e849b16127aa8f.1773890510.git.baolin.wang@linux.alibaba.com>
 <67c670e2-c98f-490b-bbb9-2960f8175b5a@lucifer.local> <66e78b59-f96c-4277-b7d7-473b68ed413f@linux.alibaba.com>
 <adBJTXeE6G2vQNKX@google.com> <2a216ee2-aebb-42ba-b2aa-826488448bbe@linux.alibaba.com>
Message-ID: <adVEc4zUVVxRiEJG@google.com>
Subject: Re: [PATCH 6/6] mm: change to return bool for the MMU notifier's
 young flag check
From: Sean Christopherson <seanjc@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, akpm@linux-foundation.org, david@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: 75cbhbpw6tz9nqiy6qjuuqo8dty341ga
X-Rspamd-Queue-Id: DD696140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775584373-96299
X-HE-Meta: U2FsdGVkX1+CWBNrD7DzZTX1FRQ0MOAlAIFU1qaqmLm9P39b8/3d5O3Zbp82humkhv/bcVmr1v7RIB167gO3xcGwe36IEF8awm68mTMnVakDG4Rijui+spZrtPZAPoBYHSIu6G+lvRdrwyaqdbe3aU86+C1zoy3wVcOC5r+xw2tDwlbokzIsGoRqcsJa0iAs7wFyR9cS4UcoNjoEZh1hSHN328wuzBxh0nppklZ0caHZYw+zoklGIXYDUZkLO+kpZUIfvMlV2JY342sWg91rqL0Yml4fz4Tc3WjQ8rLMlTAdc0bvYALdzG0rCR/cTWZKHAd2t5b8NggjQmK33LfwcDTNXH3o54Iwqtm59DB5qYUj0k99KNAlxFw4cA/JvlFoG6aL4ZuCH0qBm+U48HCZlzdhJamxeTjBkCKzUOzbwQKfQYoaK1A6Q66b8yNriCVlnBx/nl3VD3PA3nht9Z5B8xyQbf9r0/meq9CjmCKGQgSMaJXQ6mAle5M4HNVePgZ55jmNDb0NfuSt3IP86RAzoFDbchvkwMzQWkY3eJ3aEAC/qFibzrPhdAKYOyZROynLnQfR9TdVd2zq4JmF8aB/iU4Ta3kW2I0kpcuwD+/uM9PFBN0LdrfO2qwrjETXTu/8CAgJlJHaAkmEtPJnYSUJ5FglMin8lv2q/d+5LKue7Byd+JhjBiXqCY01yyp/uJRqenY0Jb96grGeJ9HzQ7OoMEfeMNgUdvcvRD+o7Kg1GL9m5DZXpEJxHrpKvT0o99M4H9nZnu5IGojsAuaqFWcNVUe6vk8P27twx+HcVr+goyfiPGKj2Rwxl5ySd4etsL2Ocw/COu+57E1cLn+4q9z7/YnHqsvJ0U0rUP6MSx9qToTRpcJRXETJ7DPn45HM7a0MLH+2XtgAeRkceiPwpSdlKSh6HSXKJtW/0BT1HUW0UGSCGhVMeXHQknC/k7kt+MdXvP8OAwpPCu8wDRC5bPA
 9Qg2UbRn
 dWlVdwCCC8wYwKsBbRATn/y61ShqPtbZIu9WKJFPkVD84TWTCcst2Ht2a4F/HppqrJCa5CuJ590OLtRmVjNMEZMemYAX7U5BoDv7OoMutIqZ/n9vHyTxH6V6+HaaR2IOb7QKApbRlQqHyFlb8f6FmpAjxYUHVgOBErytxT4dJI8R1mLnz1HDj0OD5rZ44u1q8f1DXm6kMRJejs1QUv7GUe1CRBKfTE+Ryc7edP4ldUh88v7Oq2ItEdOAfTA0MILfhDXcMZ0PFL+2RNrz9BIzvzNiK/vvMGGqIZ+US6uKFbFjV5n6gieqqSjE3gaIQJyhvBbGOSmF2QfUuh1M1stIlc8cH/mdZGWRVRcM45Zes9yFAeg+tDBWadS4ZnwTo9ORr+ppQvLqCxavAfBFfVMBFP2WNVsEKFXSfgrVCBEYeD73DkTqe7yxC8HJEAQlgtmw73s6z+vmFBzatd3g4NF7wCI+bkJCxbW8WR+h5UPAqPpuFkC3O+s0d5uTy1vSNa+ZxKtsSNkgbiJGCDn5fFv89Fz0hWmCRRmnOENXbEVTlu0mpyFsH+CVnCGRzPE0tn8YppZhCVbfa4IhXqE5QJGxKQ2oaO+x+tTdslQbXDhYfWSEDadE17c0J5j7dMmFvJ4WdzHLP3nxj5nGB+DlVjz1+YCmnXAsE9id7ln+FJIZE83VS+kQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026, Baolin Wang wrote:
> On 4/4/26 7:12 AM, Sean Christopherson wrote:
> > On Fri, Mar 20, 2026, Baolin Wang wrote:
> > > > > -static __always_inline int kvm_age_hva_range(struct mmu_notifier *mn,
> > > > > -						unsigned long start,
> > > > > -						unsigned long end,
> > > > > -						gfn_handler_t handler,
> > > > > -						bool flush_on_ret)
> > > > > +static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
> > > > > +					      unsigned long start,
> > > > > +					      unsigned long end,
> > > > > +					      gfn_handler_t handler,
> > > > > +					      bool flush_on_ret)
> > > > 
> > > > Can we please fix this terrrible indentation while we're here :)?
> > > > 
> > > > static __always_inline bool kvm_age_hva_range(struct mmu_notifier *mn,
> > > > 		unsigned long start, unsigned long end, gfn_handler_t handler,
> > > > 		bool flush_on_ret)
> > > > 
> > > > Would be nicer, thanks!
> > 
> > No, please keep this as-is.  KVM's preferred style is exactly this (and I personally
> > find mm's style much harder to parse).
> 
> Um, Andrew has already queued v2[1] into the mm-stable branch. Do you want
> me to send a follow-up patch to restore the original KVM coding style?

Nah, not worth the churn.  Thanks though!

