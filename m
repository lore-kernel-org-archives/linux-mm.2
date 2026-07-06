Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F41E2C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 23:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B210E6B009D; Mon,  6 Jul 2026 19:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2896B009E; Mon,  6 Jul 2026 19:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0A46B009F; Mon,  6 Jul 2026 19:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6931F6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:09:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4FEF1C7C43
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:09:13 +0000 (UTC)
X-FDA: 84959894586.29.3C40B34
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 262EA180007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:09:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oKVowKEK;
	spf=pass (imf16.hostedemail.com: domain of 3ljVMagYKCIs7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ljVMagYKCIs7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783379352;
	b=UCEF8bYPX9Wm7T9rvGVbY4tEGg7t0wR7QBDGPNMNT+7zF5hQ6y/W1H1ecPJ7TzYymQQqQD
	OL0WhDRbIQGG0aOCnFohmJwu5xRFRkVv/YwlTBt8DFKGh/EQKlIss4UhHbgsj6ma0RJ70e
	427bJ6AS0Ou/K5LAL+ZKduCAt96WP7g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oKVowKEK;
	spf=pass (imf16.hostedemail.com: domain of 3ljVMagYKCIs7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ljVMagYKCIs7tp2yrv33v0t.r310x29C-11zAprz.36v@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783379352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4K4FuEjxEWaUa515sAfxAFrCDsQIRfbKKlPSDfWtK1Q=;
	b=RY3b02XgROfu3k77MiRH8FSUB4Erp507A7EHSFwA1vwDJ9Lce1PKVCi/AIkF2UTx2G75q5
	6NNpCxd2zBD3MKMVWSDAHLF2VC4/DkL+mNw4PkVAae05EecHkpAxK28CiBPIFyfBUSv3iy
	QBFNUNEACphq6JYGV9UoyPpTS1MLj0U=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2caa9a3cf7aso951875ad.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 16:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783379351; x=1783984151; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4K4FuEjxEWaUa515sAfxAFrCDsQIRfbKKlPSDfWtK1Q=;
        b=oKVowKEKh8qhg4Y+nIgPDlEtbGw2mzevuf9iGorcc7fUn1KDIGDbKOqFba3juZhiyz
         /8fc0cMM83JaT3Am+9M7ZM/7gSYgAyLGA4/6gAw889KKHiQuMEna7kPSoKLE3iJ/hyu8
         rmUvFzH+klcWEZq+8+k+KDVH/SjNGNzHGn3WB24HbmzFbOOFxiDXvDWF/UyyjpD6W8Q9
         qfIFtIr4r52ueL0LBk26O3QMsYBrzCcczEr7PD6k/RWcCbbvtn+KZQPvl/4MqOonXvt5
         4v25xRpipJG06uH5NiXkm59vrcQK/Q1lX5Jjw3dV47YjMEGWzpBF+mhxSUhC1gE08TBx
         rPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783379351; x=1783984151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4K4FuEjxEWaUa515sAfxAFrCDsQIRfbKKlPSDfWtK1Q=;
        b=kyDb/7THFg4jSo8wAoAR1q1fykMqqd96v56jcAkZwnfidYGCxik1dozkSNPFIlXtMP
         5O5hIPUB1xMhF5yhNEu58pPSCq7i0K9RNtwg4SJEGzYOMW7x0jF8dVyh5FJktzFsiNSy
         rOwECJc/uvoObv8y9GFVlkglf/6Nbhq5Br6i8nUFPMnPjuJzcXzfXosOy4kwdRmzhStB
         vzd429Jo2vgXupLWb+AmPZkboewJ7cK18HOLX4cKe7bWUB91lACLUrOUZ6acHhelVHGw
         WbaCbXSudCnqyT3jE5JYYy2MQalNJJC7nj01kCq8TUaqwjt5Syfk7URxgUFBRYu07Ro7
         EFPw==
X-Forwarded-Encrypted: i=1; AHgh+RocaEZYVNEyPW1ziBwm+bwR3GU0f2Ce3a6KKpa5xgWRgFKI62V5dbXpHSTV+UAYTrDZco0FFFhyoQ==@kvack.org
X-Gm-Message-State: AOJu0YwdiSV4PDJ3gtv5fFsbytg3T3iONAvtlRpfLbtt9TVeH36YwGBO
	ef8K2AFkGxPFZVDP1cepKUtlfiu0CLOoqDpNr7VSYDR5w+IvSroihg8qIEONtOuIbAKn6gqB9I3
	pjOVJ2w==
X-Received: from plbma12.prod.google.com ([2002:a17:903:94c:b0:2cc:9503:aa95])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0d:b0:2c9:97a7:3283
 with SMTP id d9443c01a7336-2cccadc7713mr2988045ad.23.1783379350495; Mon, 06
 Jul 2026 16:09:10 -0700 (PDT)
Date: Mon, 6 Jul 2026 16:09:09 -0700
In-Reply-To: <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev>
Mime-Version: 1.0
References: <CAPTztWb67XZvfcMVnbegDNNW0LJa9UsaTGx3M898xJUJrekk0w@mail.gmail.com>
 <20260508081812.12345-1-itazur@amazon.com> <CAEvNRgG07EMrx-SpMaO3gHmdGVwOb75XNy7_RARBo0chidn7Yg@mail.gmail.com>
 <DJP40SEE38XA.3BXJN4U0VDIOS@linux.dev>
Message-ID: <akw1lZDEv8_Ub1zQ@google.com>
Subject: Re: [PATCH v12 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
From: Sean Christopherson <seanjc@google.com>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Ackerley Tng <ackerleytng@google.com>, Takahiro Itazuri <itazur@amazon.com>, fvdl@google.com, 
	ljs@kernel.org, Liam.Howlett@oracle.com, agordeev@linux.ibm.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, alex@ghiti.fr, 
	andrii@kernel.org, aou@eecs.berkeley.edu, ast@kernel.org, 
	baolu.lu@linux.intel.com, bp@alien8.de, chenhuacai@kernel.org, corbet@lwn.net, 
	coxu@redhat.com, daniel@iogearbox.net, dave.hansen@linux.intel.com, 
	david@kernel.org, derekmn@amazon.com, dev.jain@arm.com, eddyz87@gmail.com, 
	gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, haoluo@google.com, 
	hca@linux.ibm.com, hpa@zytor.com, itazur@amazon.co.uk, jackabt@amazon.co.uk, 
	jackmanb@google.com, jannh@google.com, jgg@ziepe.ca, jgross@suse.com, 
	jhubbard@nvidia.com, jiayuan.chen@shopee.com, jmattson@google.com, 
	joey.gouly@arm.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	jthoughton@google.com, kpsingh@kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, lenb@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, luto@kernel.org, 
	maobibo@loongson.cn, martin.lau@linux.dev, maz@kernel.org, mhocko@suse.com, 
	mingo@redhat.com, mlevitsk@redhat.com, nikita.kalyazin@linux.dev, 
	oupton@kernel.org, palmer@dabbelt.com, patrick.roy@linux.dev, 
	pavel@kernel.org, pbonzini@redhat.com, peterx@redhat.com, 
	peterz@infradead.org, pfalcato@suse.de, pjw@kernel.org, prsampat@amd.com, 
	rafael@kernel.org, riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com, 
	sdf@fomichev.me, shijie@os.amperecomputing.com, skhan@linuxfoundation.org, 
	song@kernel.org, surenb@google.com, suzuki.poulose@arm.com, 
	svens@linux.ibm.com, tabba@google.com, tglx@kernel.org, thuth@redhat.com, 
	urezki@gmail.com, vannapurve@google.com, vbabka@kernel.org, will@kernel.org, 
	willy@infradead.org, wu.fei9@sanechips.com.cn, x86@kernel.org, 
	yang@os.amperecomputing.com, yangyicong@hisilicon.com, 
	yonghong.song@linux.dev, yosry@kernel.org, yu-cheng.yu@intel.com, 
	yuzenghui@huawei.com, zhengqi.arch@bytedance.com, zulinx86@gmai.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 262EA180007
X-Stat-Signature: 7zmncjesqb3iqsgzistoszpjhoh1bx1u
X-HE-Tag: 1783379351-468449
X-HE-Meta: U2FsdGVkX19qVux08roqDcmm9UEi9gcFfX20dvtwd+WjQQq7HwWGV9qxEXZnLCStDSJQ9z4Z0IK0GhyO6xzabA9fDWlEYSE9tQc3nlYyDOOQTxxeAcQHXwgW9wNJMjHjLLPTqNrWS2fZ0mhJkFYgiLBtRkn7qAURMbpgri1CqfFpXZ2lkFaQ5/eUBREpAHoHVuA5ng3e25Sr8DXZKMuHrzf5xI1faatnQDSa4ih2iFqKAx49bw3cZoBqJVMKDz1ZHXkfj3+c7D57fSdhFKbmIN738CdaiJU/WV+KHJpq3FK68tU+I5qjUkPVoBmA0IJhvEFQU0FbqJmOUxkwjeedjrMYWqYycNngnm4hrdKn5mEhRqxD4c+7MWfDtKZ22VgcNykx1oQ+7rKiMIjx382FFpYS0FAA1OCtm2xANuiELoSbloO61a1lMcflJok3hB9JkiwTs+xX6hQ1S+2/6hjyNMBa1HlK7J8sEoN3qSseavzPoK0hx5obWUotH9Lv9KD5Fgsl+iHfaHWUEg5fCHcmERMdsIU1Dx7UdMwz5BuC/MDHXAWljz2/RvwEIBBMoqNLxoozpDj5wyhjPhy/DHeNNTFY9upQULd5XGZlesBtdIeXumRhKZoPyuDW6WA3GqP3tiRbRjuSJSJnJcBMO1rPHxkMjdxRVRAybQJrHX/nuU9Tofh5sdHKOxLg2p2PfR9hKc0hcrnKMsDJmDU1IFC6fwXSBPNFFn2QpLNVxPb+doVob4j8S8Ta7zHG0Fo80jyrLbTUPSx63gIweysW8VU/8WlGygH18Ij0VUEZ82R30C2Xt6UW05CnvwG+2TbIfns5TJrXCc+8BLaMPIbzgQ25bJfRE+dY6P/8NOPIs236pc6E3mveESolBdk+dFKYPFUhfm/hZMaOZUjhNgaMWeb8/WuLoA0MOQijm7onuG3qO+VHWpGvC3mmA/vekYAbaCtiFyWUvnt92abter4W0a8
 1j0PGfqt
 l5FDDBTdtjEsdc51MbiLiomaETT1o02wKWFojK9tLJTk5RL42wasyn4Rt0tT9JqtCYsvrRz25ZvDNpXAgsgn172IFK7kgO/MqkaCCUiVJva0Ls7wQEYjXor/63TXNF3YjmFU2AO9uJDMZCcLveBhyzkqAHmtFy84PWQMY1fY867JRvSLliWXpAvj0hUIkdjaCmuWRU1yH+0W+xrKY7Pc4trttwdZAaGtd16K8wW7o+Rb93TXNJOk7OfgBvwVg8GSMpqyhHsZFvdtjA2DUhA34A9Vp5KTVseeooYN5rQhk79ugC/VG7KDGEt5p4ioiyFEYD2LDKimRuruRXQ/g+ODgnMKVSBESGuoY0MKuFiERCl4dEZ+1dJLLZLccM+3xT4lUwZdjDYJAtOwzWePVKsKryOp/aF4vYS1AngVfkzyG7qAEcdn+PahYBaQkd+yMTeGOeYVhB2Vo387jEBSbLPq+zJFSMo+Cll0CBioHRoKFxGD4ASSZVITlYhuSwPs4jv5R9QSVXAWQqCUfgqXBcJiQhwE2poEycJTBTkRBNN5Flx964Bk1AJjxZg9aKbQTdQ8Z2/4jBdw7E7iBLmLE7V67X+WwvMc7bfaHbALePQz3kBslSsr5JHqKHtXFLOTatEHeK2mmvbATF52W8aOyHqtQRM3hHFEVz/zGJpRp1711gVL1IY8GvQBVniIAvA5j4rrNS91PXs991+aD0OYLKf+biC9VBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026, Brendan Jackman wrote:
> There are also the fault paths though; if the pages are nonpresent in
> the direct map for the duration of their life in the page cache (and I
> think they should be) then by the time we get to
> kvm_mmu_faultin_pfn_gmem() or kvm_gmem_fault_user_mapping() we lost the
> ability to zero them.
> 
> My original answer for this was "that's fine, we'll use __GFP_ZERO
> (which will probably use the mermap under the hood)", but now I've
> realised there's a good reason we don't set __GFP_ZERO at the moment,
> namely that it's wasted if we end up doing kvm_gmem_populate()

Eh, don't worry about the wasted cycles for populate().  The overhead of zeroing
a page is dwarfed by the overhead of adding (and in most cases, measuring) the
page.

We (KVM folks) discussed this in the context of in-place conversions, and long
story short, the consensus is that shaving cycles by eliding the zeroing in the
host isn't worth the complexity.

> (Continued below...)
> 
> > I'm a little bit uncomfortable this statement since it seems to say TDX
> > and SNP aren't taken care of. Would just like to discuss (for
> > a line of sight to SNP and TDX support):
> 
> Are you saying we need NO_DIRECT_MAP support for TDX/SNP? I think that
> would be doable but what's the value?

Hardening against consumption of shared memory?  Yes, the guest has explicitly
shared the memory so there are (very) reduced expectations around confidentiality
and integrity, but defense in depth and all that.

For me, the main thing is that I don't want to completely punt on the interaction
of the two things, and end up with an unworkable mess if there's ever a strong
reason for CoCo VMs to support NO_DIRECT_MAP.

> So that we can get a #PF instead of #MCE if we screw up?

Note, SNP gets a #PF either way.

> NOW, the thing I'm stuck on (again lol) is the patchset-fu. Here's all
> the parts we need, with dependencies indented:
> 
> 0. efficient GUEST_MEMFD_FLAG_NO_DIRECT_MAP
>   1. AS_NO_DIRECT_MAP
>     2. ALLOC_UNMAPPED (formerly known as __GFP_UNMAPPED)
>       3. alloc_flags arg to the page allocator (I'm sneakily introducing this
>          in [1])
>       4. freetype_t 
>   5. The mermap
>     6. The mm-local region
> 
> I originally posted all of those in [0], except part 3. Doing all of
> that together in one series would be a bit too much though. Approaches I
> can see to avoid that:
> 
> Approach X:
> - Do parts 1, 2 and 4 as a standalone series. The only beneficiary of
>   AS_NO_DIRECT_MAP would be secretmem. 
> - Then another series that fills in 0, 5 and 6.
> 
> Approach Y:
> - One series that does parts 0, 1, 5, and 6. AS_NO_DIRECT_MAP is
>   implemented by having filemap.c itself call folio_zap_direct_map(),
>   then guest_memfd.c zeroes it via the mermap. It works but it's really
>   slow.
> - Then another series that fills in parts 2 and 4, switches filemap.c
>   over from manual folio_zap_direct_map() to ALLOC_UNMAPPED, making
>   things fast.
> 
> Approach X seems natural from a code progression perspective but leaves
> us with an interim phase where we have a bunch of complexity just to
> "optimise secretmem" which nobody cares about.
> 
> Approach Y seems natural from a feature progression perspective but
> leaves us with an interim phase where we expensively zap a page, only to
> then immediately do this complex mermap dance to access it right
> afterwards.
> 
> Any thoughts / other ideas? Personally I think I prefer X.

I don't have preference between those options, mostly because I don't appreciate
the difference.  My overarching preference is to separate the mm/ work from the
guest_memfd as much as possible.  Beyond that, I probably don't care all that much?

