Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC56C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5CC36B0109; Mon, 17 Aug 2026 15:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34BD6B010B; Mon, 17 Aug 2026 15:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4AC36B010D; Mon, 17 Aug 2026 15:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD046B0109
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:47:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 313B8A349A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:47:53 +0000 (UTC)
X-FDA: 85111796826.18.3D262FF
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7191180007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:47:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cF9GgWpr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3ZWWDagYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3ZWWDagYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786996071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSPjnzAw394pFm0pKxy4emVVRo23Qn3Hi8qinnpBAHg=;
	b=kARKkA94PyRUMEtuDXrOtQpZI5ZtJJlThQJ3vaQUi7T90ux5ePLKEAbwmQ2yN3cnbDXm8k
	bo/I1uE0dwddNhPbldP8iZ3oqC8D5GuAzqVhVW7wLaPN8JYxc3V9cmW0tBqCbFQSQnkisx
	TXk5eWjAZ0/aQetPW8GNFdP2luEosKs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cF9GgWpr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3ZWWDagYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3ZWWDagYKCJgK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786996071;
	b=3aOQ37A5EOmua/ga3NduW2G/MC5xQn/K/zaZpfQxWvvFHgNzL9PUvvklXsg9TKb5I6OWA2
	ManTTGQkgVmpA8p6rfWHl8/1g3II8TpD4t/iwwCoCz01rMx8eaxNWSkSvCgJ80RWevLJN/
	zHYl9byw9g13k3dHvF/IfXDTj6DGQcM=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cf7dd9fd91so43120335ad.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786996070; x=1787600870; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dSPjnzAw394pFm0pKxy4emVVRo23Qn3Hi8qinnpBAHg=;
        b=cF9GgWprKx9mGc+XceAV423fFe8kQbnP07SfrDfbHgjjmU4R0mvUbE0WbNu1vqUuGD
         pK/aREjiUjy5pIgwwxbfbStz7r4wmaP1BCdzhkZT2/DlQGdPT81NdR/btV32b2wZKbrF
         ZDv1RP2SeBJf3tkIBbNm6ty/7snPeEYl9IoD7L1jwntCWKQvRaZJd/7tvUpJr429iY9o
         P6/KSXbuVej3OsO7xZd/9klu6xv1GJjNemNg9GVwsH9ABVOsWIEJYn+XYDeDrX0cSKqS
         D2IDEhFuA0f1BRv75W87lGNPO8z0ndkUgUmxtPtT0ze103Iz/2qvnFbBWuwvBVmh3mKQ
         YYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786996070; x=1787600870;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dSPjnzAw394pFm0pKxy4emVVRo23Qn3Hi8qinnpBAHg=;
        b=ERWTy56LA+5yBKFgJOR/m3iJUHrxHKpUkaP+uIVnjdDu2ZI1KRkklY9igSwlj0VeTe
         npHImlAIEk9bt5qsSVlHCQJ+cU0bGHpiA7lBUCjhQ1YoFb5bVw5G+s0PAAkeAkOOAoGx
         XRETZlXw3MTA4HbLXBZG2BpSdGM4CbxnEKb1l3Mo9ZQn/8PdICGPo/cWr0Ab9XaLX288
         JJiRUQebOyWj/DpQ2NjWuR0b3pn36cJDu98caeF81AZZ8zv2E1F55MAEqXUAwYiNej69
         WOh3VfOHOz9HOwwbCZJAeXoPXRbD7Pxd7JtbSX79J/Yf/IFOzkuaVTUb3kvVW6AhXAZI
         ksqg==
X-Forwarded-Encrypted: i=1; AHgh+Rpwl+iGbSERaPl+X6HplTW2XkzwJ/vxTiBzJ2hWuHczYwhNRKK7Xs1RxLwuGzDPWPslhOHHhwoBmw==@kvack.org
X-Gm-Message-State: AOJu0YzPXJ8ax/ig4lvSZ5l6Sd0Sw+4fFDvDTq/k2V1RHuGDMfQDMOJv
	426q4tOlFuunXlUsrbL+1hBquOgyVrUELkTV+XcewVJlVEghhHxg6xytL2EIfrdfRwTvJ5odZGo
	i3R6P8w==
X-Received: from plpo1.prod.google.com ([2002:a17:903:3e01:b0:2d3:c2e:bf01])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b0b:b0:2cf:9347:f445
 with SMTP id d9443c01a7336-2d3b0c7ae46mr300300005ad.10.1786996069910; Mon, 17
 Aug 2026 12:47:49 -0700 (PDT)
Date: Mon, 17 Aug 2026 12:47:49 -0700
In-Reply-To: <CAEvNRgFNCDDSeuvbwj7pD_d18o1TBXo4TNR2dXHxpm18KPfR5A@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
 <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com> <an3o4h-E8mj6CUaM@google.com>
 <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com>
 <an5AcEG9mqDgnBYk@google.com> <CAEvNRgE+05c9U8C=Zkm1S9hLw3Lw6YMmijZhEe7J4rYQAuNyEw@mail.gmail.com>
 <an8umm0qisEidt4n@google.com> <CAEvNRgFNCDDSeuvbwj7pD_d18o1TBXo4TNR2dXHxpm18KPfR5A@mail.gmail.com>
Message-ID: <aoNlZRb5SV7hyNuk@google.com>
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7191180007
X-Rspamd-Server: rspam07
X-Stat-Signature: h95pbi7pkankp7wngfph7onaf1kymigq
X-HE-Tag: 1786996071-811260
X-HE-Meta: U2FsdGVkX1/nJ9KaBW6mjS6G+wQ/gJe535Lw0EBMjAS+q4JRku1U9ISu6+VbyW/Oz/u2I50XPCVSnfWmlgv6BFbYscG1OOKckQhpQvE7SJ7xultfMl3OuamZ/ek9Z9so1TNhHkhJ509+KzlDiWqkNxO3HFpQmiaubM8Uw8jeGXus7kNQ7pLeJ6V9rU5fwa4IEhBtEfE6jn25Zx73xsCj3l05HMlp9zoqww5DfvqR0p+7JiVBDm/uFSLZfcgrnoTzivGsaw4gQuDwDfxbXGoFioIHA+2s5uEfUZ4bNHP62Uq+1iySjrzAZwtA4YwS+PaaOjEpX/11A68YivB6Tuc1pF7DF/EeM6tY0RIR9b65Dqce17BJ1464bZZ5PEMYkyp/EKeQstP8MiL+rx5scM4wDaMjipc9dFNDSZj5s3fCAJZ2pJ7gKPkWN/sc7oBcLwQ8j1YlTvTlCezkpkLlNHZxCMvewLepVK4KxPmTtdlD3SN+USdVOC+jLv9KstQIPo9SVWDd7ywfWwrfk27s5J0hq2P5rjN+FT0GyhP0e8Ye6NHTxzKtIsCNuGiRqRETYx7dyXDUeg6hu231wsxppR6AKu8aOmYCPodgrAlc+aX66LPddi8Jc6k5DXywph5imd86bJeC7dyeCvCGIR3dJauOCt+HkxRuaUvqwYo45OtqRt1Lp1e4Bt3uKcZa+fuU6FAxHBGx+RodMAfnJwvx/cJzINTaH2VM8Jx0f2ylCqQo8VjIA1/60ah655nPEzHEplmWwH/ijtlnSOGqbgwLM0EEIRDIxaIsDGFC16U3ztq28u9Nrhzn9Dkp0v2OOOAACOTP1tysMX6D7qItqmoP0gTSfFbneMDgEX+LNT8qgnRN84YW5la5bTgYWqJjHLMgnPJ/FpjuHAiLckqfNqNkeUW+Lzt3ypOvSMNgoB1ptd9+u86no1c6ue0FTykuq/LB5lV5WeHqweq4fAyXoIzln5G
 kuJZRZyq
 xd89OZHNtyL3ybJiqjLurlvPi5LB4EaZ0AJFVIB+4/qHLcoQingFTLXewQV8l1AgooGu1So7Lb9fig3vSvJg20FkeMGpUJ/HdcsjqxD6ZQduc70/DNI3tYQF0bXR8NSVrxiThAg3oka6KlUB24BrMVR7ddFgr4vP65TFrlVq3EmCFj5+d/ZpPBDRDPQiIsGdrmlYsNbYWc8e6tGc6Sk6syPUGpa7zRtkluTvOBnrWX5uSpUj7QHJZbYLWL4mrI1KvsWt7oe3f4ut3WMC7Xul4066zeYUikvTZxFaJkSA13oUFu8g9D0MyXCVjBXqZMaM68KyjAPcJtdSVoLhFBkfJ8SpKF/ScB9H9XnFoWdemaEmenebuuQzYaqz8PKWgml4tdBGb1NLWYe2tvZgZ/27KfsCPd5epakJH71u59ywMYGp4z+VfvMwoIbCL7s/GLKhLCz8rSeGlU0cfXLq1n2Qg6wl6kLuAxxhQP7T7VVrgSqE9dm9v+k0pVLdAUL9PHlMWKfzbLk5SG3y2AlpC+oxLUkimqxgBIKnxOoIGIHmQDep6AKTEXSae0lD9jEdeOA8vPXHFLL28/BH0Dj8odH2xgShcU3222/1Bu7Ji9obD7U4n5nSgoQI8HwUr6zSrh2ySZ5wBFx7WhWBQBej9s9Kzn4wDLdVtGZQkkjU4LkL0ZAt65mgz5hTKjdlotD2Pbhwy0t+C0QT1IOC7f6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Aug 13, 2026, Ackerley Tng wrote:
> >> Sean Christopherson <seanjc@google.com> writes:
> >> > That's why I think it's worth analyzing the cost: if it's in the
> >> > noise, leave it alone.  If it's meaningful, figure out a not-too-gross way to skip
> >> > the entire thing if kvm_arch_gmem_make_shared() is a glorified nop in the end.
> >>
> >> Is noise defined relative to the entire conversion process? Would this
> >> benchmark look like
> >>
> >> 1. Convert 4G to shared on TDX with CONFIG_AMD_SEV defined
> >> 2. Convert 4G to shared on TDX without CONFIG_AMD_SEV defined
> >>
> >> and then compare the difference in time taken?
> >
> > That'd work, though I was envisioning something even simpler: use rdtsc() to
> > count the cycles it takes to iterate over various ranges of memory.  Do whatever
> > is easiest for you though.
> 
> I made some changes to add rdtsc() for the conversion process as Sean
> suggested [1], and exercised conversion like this [2]:
> 
> 1. Initialize some memory as private
> 2. Get the guest to fault them into Secure EPTs
> 3. Converts the memory to shared <<== this is being benchmarked
> 4. Converts memory back to private
> 
> I made it build the VM once and convert 5 times:
> 
> ./gmem_benchmark_tdx_convert --iterations=5 --size=1g

...

> And here's the above, tabulated:
> 
>   nr_pages      make_shared            total    percentage
> ----------  ---------------  ---------------  ------------
>          1              930            39278       2.3677%
>          1              252            28060       0.8981%
>          1              176            26952       0.6530%
>          1              176            27038       0.6509%
>          1              176            26980       0.6523%
>          1             1072            37236       2.8789%
>          1              316            28338       1.1151%
>          1              176            27182       0.6475%
>          1              176            26972       0.6525%
>          1              176            26886       0.6546%
>     262144         15041018       6616067680       0.2273%
>     262144         14937462       6608542680       0.2260%
>     262144         15138858       6599494898       0.2294%
>     262144         15721972       6610219850       0.2378%
>     262144         15000406       6615114540       0.2268%
>    1048576         61902982      26400884028       0.2345%
>    1048576         61746114      26401170984       0.2339%
>    1048576         61096794      26404409058       0.2314%
>    1048576         61446290      26447461896       0.2323%
>    1048576         61774646      26444608360       0.2336%
> 
> Looks to me it is within noise.
> 
> I also actually tried measuring the conversion time from userspace with
> CONFIG_AMD_SEV enabled and disabled. Converting a 1G-sized TD was faster
> by 0.2%, which is in line with the above table. Interestingly, when
> converting a 4G-sized TD, skipping kvm_gmem_make_shared() was _slower_
> over 2 runs. I don't have an explanation for that.

Might be some cache/memory locality benefits?  Though with a conversion that big,
it could also be nothing more than bad luck.

> I think the code was correct. (If it makes a difference, I skipped
> kvm_gmem_make_shared() using a custom guest_memfd creation time flag and
> skipped make_shared if the flag was set on the inode.)
> 
> I thought adding a kvm_arch_has_gmem_make_shared(), defaulting it to

I would do kvm_arch_has_gmem_convert() for consistency with the Kconfigs, and
because the cost of the reclaim invocation is a non-issue.

> false for all archs and having x86 override with
> !!kvm_x86_ops.gmem_make_shared is not too bad either:
> + doesn't leak anything, since the function being called is
>   kvm_arch_gmem_make_shared and the accompanying function is
>   kvm_arch_has_gmem_make_shared. Or maybe just a little, since all the
>   other ops don't have the accompanying _has_ function
> + it's a kernel-internal thing
> + not too many lines of code, not too complex

It also provides a good excuse to kill off the #idfefs in guest_memfd.c.
Compile tested only, but I'm thinking this?

From: Sean Christopherson <seanjc@google.com>
Date: Mon, 17 Aug 2026 12:31:50 -0700
Subject: [PATCH] KVM: guest_memfd: Optimize away conversion overheads via
 dead-code elimination

Add and use kvm_arch_has_gmem_convert() to guard guest_memfd's invocation
of arch hooks related to converting memory between private and shared, as
only one half of the x86 CoCo duo needs the runtime hooks (any pre-work is
pure overhead for TDX).  At this exact moment, the overhead is negligible,
but that will change when in-place conversion comes along, at which point
to-shared conversions will "need" to find all affected folios prior to
calling into arch code.  In quotes because very technically that work could
be pushed to arch code, but that would bleed guest_memfd details into arch
code and would be far worse than adding yet another kvm_arch_has... hook.

Opportunistically provide the kvm_arch_gmem_make_private() declaration, and
rely on dead-code elimination to eliminate the call to non-existent code
when CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT=n.

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Closes: https://lore.kernel.org/all/1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com
Suggested-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 include/linux/kvm_host.h        | 3 ++-
 virt/kvm/guest_memfd.c          | 5 ++---
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 283847619ff8..5d5a7723abb6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1854,6 +1854,9 @@ enum kvm_intr_type {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #endif
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#define kvm_arch_has_gmem_convert() (!!kvm_x86_ops.gmem_make_private)
+#endif
 
 #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 03bfc92864b6..e824ba59c60c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2599,9 +2599,10 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_GUEST_MEMFD */
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
 int kvm_arch_gmem_make_private(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 			       kvm_pfn_t nr_pages);
+#ifndef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+#define kvm_arch_has_gmem_convert() false
 #endif
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b596486d184c..39d94938b5f6 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -773,11 +773,10 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		folio_mark_uptodate(folio);
 	}
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
-	if (kvm_gmem_is_private_mem(file_inode(file), index))
+	if (kvm_arch_has_gmem_convert() &&
+	    kvm_gmem_is_private_mem(file_inode(file), index))
 		r = kvm_arch_gmem_make_private(kvm, gfn, *pfn,
 					       (kvm_pfn_t)1 << *max_order);
-#endif
 
 	folio_unlock(folio);
 

base-commit: 1b731e5ded480bd1e5546aed35584238661ce72e
-- 


