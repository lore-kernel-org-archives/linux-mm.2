Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58BFC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 19:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40AFD6B008A; Fri, 25 Jul 2025 15:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC1A6B008C; Fri, 25 Jul 2025 15:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1C56B0092; Fri, 25 Jul 2025 15:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D87A6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:16:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D574C80903
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:16:35 +0000 (UTC)
X-FDA: 83703743550.06.445A3E2
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf13.hostedemail.com (Postfix) with ESMTP id 104BB2000B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:16:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="EI92n3/7";
	spf=pass (imf13.hostedemail.com: domain of 3ENiDaAsKCBs13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3ENiDaAsKCBs13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753470994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WlSKTdQJz4BcWRlFGcWGmeAyhSggOtqFKeQJDFCZ8k=;
	b=7URy/5b03R9asYCUB/Gvt4eOJqP8R3dgHNhwEdrPDBTfXWmAU9yVpUA0JA3pew3A2QN1Sj
	0tFw5ma0FFNsTKkxUoF+u2+kXT7D019AaLBbY4eksKbax7lot0ohAE0g3/eRLIKW+9DjNR
	jN3+4Gwsii0n1ywPiUSmw2SBHhkWPJs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="EI92n3/7";
	spf=pass (imf13.hostedemail.com: domain of 3ENiDaAsKCBs13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3ENiDaAsKCBs13B5IC5PKE77FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753470994; a=rsa-sha256;
	cv=none;
	b=QESCKD1M4MgfbBR30iuYYLW739io/9e1a/b1iqXP/HIKin6L4fV5rHUOZRaLIOlJRTcRBc
	8kri4FO8C+1y8cazAnDs7N8UKdVUwYgvfVlxJSPurIf2irpwncHZB1QhDQ52WYCT4kfjlA
	rdtsLHE2dEyBw+VznUs78Fbdt0VcSfA=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b38fc4d8dbaso2943619a12.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753470993; x=1754075793; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5WlSKTdQJz4BcWRlFGcWGmeAyhSggOtqFKeQJDFCZ8k=;
        b=EI92n3/7gouKj5W+l6LCJUp7caJ2VvJI4+fbgxVbbVjXep3zqBSMZrPbikQzxzYIbF
         tDM0biMlj13fmrVQmBG9bRuy/H0NuJetBihSvyFuMx0kAIbuJ1pH9QaUBtQFYP3dQcn+
         wLp7TuJ5asiuY7DqSn6LPzVMrdinsjzZIYxPHjV5rb8KOaGQv2XjVWl2qbxXAx3yEcus
         cM5Gj8CVq7fc5oISm3/NTWJ8rlgSfCX4c+igksz9OvhYMnZCgW7i7WBUKRItKg+Vw5od
         4oFAgoKoIOt3TL5BPTx1JpoZR6ZaLOqAZNwaa3XIFLHQ8ln94QOgnv651rPqLEIpGzJh
         eorw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753470993; x=1754075793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WlSKTdQJz4BcWRlFGcWGmeAyhSggOtqFKeQJDFCZ8k=;
        b=qnhWArfxOqbnCO5xX7UqqI2WlQfjdmw6l+dA8efe3XE8Jo0a6YyZZ2BpL8bRVOHN70
         q3AfzAf8fB+vVcX38SrGU/WXfqu2pcJeAoAiwXn4h7vjg+CTNleGPLAvX6NOLnkYPTHQ
         tq9JGO7r/FFWuZcK4q71sa0wTGX4tel+YkCqcEU5aGxqoXaQYhD+M1RNE6k2B8HSILr5
         oFsCggiHmue0S1RuuuKoLRZZ5a4FDqzxhaod3sb1enPGY8WSRL7klQTWUBNL6iYudkuv
         aGZ+Axr9W7YDzHEcUbH/J5EMyqfvX5Qgq0xiLspeK4vPwPMSyzx1MKrgDzLdXOxjUW+b
         pq6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXDl8oqN7GZI+WwhL7BEHxWbJMdl55HLaWx72j1u4kEs4d9CUNvaQQk3Uje4ENmNGFlq3BbI9XmWA==@kvack.org
X-Gm-Message-State: AOJu0Yz+k4o+2yhRPhWgtKkCF02GCUNR8b/3WlGT8Ok6GJxOXIlgT2eU
	ZWpdRu4Fns3yiPcvy8xi0JzQZcgkcjctM4hLKEi8XHiArh4fK4MSWQ6pd7oO7NAxa66abJUDGUl
	MpPl94UMCq85WdVAM79S/6E95yQ==
X-Google-Smtp-Source: AGHT+IG5yikix3DRNgEwYyvsz70LuAraxRVgFySsHgY92IzME9+2iJeI2z0Py1tuIkdALoYNsqefn1ymxFcNG6k/Uw==
X-Received: from pfbmd15.prod.google.com ([2002:a05:6a00:770f:b0:746:279c:7298])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:70c8:b0:21e:f2b5:30de with SMTP id adf61e73a8af0-23d700afbc9mr4649670637.12.1753470992563;
 Fri, 25 Jul 2025 12:16:32 -0700 (PDT)
Date: Fri, 25 Jul 2025 12:16:31 -0700
In-Reply-To: <aIO90h_oJsvyxR45@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com> <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
 <aIOVNcp7p2hU-YHM@google.com> <aIO90h_oJsvyxR45@google.com>
Message-ID: <diqzv7ngcc8g.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rsq9wnfqza3edfbhbipeqi5ktucpo9me
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 104BB2000B
X-Rspam-User: 
X-HE-Tag: 1753470993-891083
X-HE-Meta: U2FsdGVkX19C3hR8sDrAo5ABiYfuPxI1WEKt99TjUx03GXfzgrCy1mfAzQLuXOc5xqOYcx2JSMpjhvPq+u8+7JsOU85gqTystnJqbBwio/JdUU0Z7mvjrYszB53+ny2zLMSn+dwC/Vg+kCJ+TdPf5XXUlLt80N6LshbnleSE7JmPQDFY94cWL+Dd5bA6BoLrFZgGHPxVthL/JJlAsD2CvBDqvp4R6aTY0SZuOzKVGlMi5fHYrLb+4BSWO2dWzzlN634zBiBZqwxBjUmLjqp+Lzdw0Ah5Qt19pzJ+ht/qqYQfxQFNXNozlI/Fi1wGKYIXSfuLCGyCAWQgqFL5so7vpeyUp+2k+G4NMx0Y+FbFVIuiqfqVOZfKG9/FhzBGivX/bcJjr0ip2VCMuwDY57VHVF5EEQoyVk7LdIApDhJrawEVzEVqSdLc/c1+chmUSso5NgyRSYbJ80KhHik8aySjDrt222oJPewRiVAfnqNvlsfpQkFtd5DQ7unKjETieS7qWd/uLQKvoz63OW5KnfyXGtvL+xIzi/YX7OPQmhGPx3REmhLpS3m6HGtEgJD14sCGYSuTGuvnbpYZP6fTnqAJp+88tk+OdeoyXN9p0OgdEbHzfHQtUSSHLSdQVCHUhTa3Ysg1kBNVPsGdZauReoegOaadPH90mN56nV9oZos+RG8Bi1Z1L0NRja224BbZazpm3G+MHziEBIk9IYgXqpeQuNQRXuFRqPg1AzxnyWBfArWiOxRaDLZmZT5DZlxUuBooK5woXIaExqYRUPOIs7iqAWz7aht2KCbanrTxFqcwz0gXeZYi5uhR32gO4bmX+6bs9EbQPSYNLZhJ0BgnLrSIFc1gGXDeg/5jET2t7Y1VPY22lCq1Y3BaXsy+NbyZ7E9DGpcNEgskt2yQbq89JUOpQR9vdiWXvfILbBKMGzEExil4mBzXt+sPu0HgKzgjzw1S74Fz0HhIDind4ajM7YS
 7Qi+Yhcy
 n1fZMRUaZdGP7/KqS/nRuPv1V9A/D7Nw3FDTat89rqDRDYS/xrPVdn2s9izMTuYDsXwzCcOzrB8+BiapCEAvblJiq4Jjilp/Oe68Hu7rfuNTGm6S5xEF7ZTvM6YmpFr9yUadBdLYxUFvwQvpXPW8UqZwfwnlDZTXrZvki6RaaQLsUHx5hbpCSWN8265I4fh68oUc63mvUAvtdNoWHn3E2prtIT0Vd2JV+SClqDfueiOynRzxKJy90+6JgEwHZiPY97hvGgt/gij+bIjKmmDUl1w1T3oS3VFcI4IHaVTmjavKxqM/wg6ubygfa39UClOJWCEbrGkmvNcQxFnXh10qBi0pu6dpBwxWprjoTRU04xpp8QVVGTZbJT6HTtxmfGPdePHphxMfVbIhlcNfjwTIb25pBWpEbAPVhnSFfr66ZUgC8AybBSQN53K0OZv0dGfQ292d8eGLlebYC+6YdjE4pffIXZMf+LLyIZ5B8qQpzihd6WaNzsvXMe1VNBpIMoj4Yoro08TvzfksUmRzhYIsysGSiDDCkXFeL7GugO+0yUNVlREYmjraMUtl/62iXp3MbKiiFHo0IMRTogKhhb4Cgt9rQe4KbyGyk20e1UKtdNsWlQbSs5uFbHyrRbK47dkJAEFY2TkhGhMmH5b/OB29pqQl8HNDCsSHovh10Yb+5RLogcXlm9rpgFkpv8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 25, 2025, Sean Christopherson wrote:
>> On Thu, Jul 24, 2025, Ackerley Tng wrote:
>> I also don't want to effectively speculatively add kvm_gmem_mapping_order() or
>> expand kvm_gmem_get_pfn(), e.g. to say "no create", so what if we just do this?
>> 
>> 	/* For faults, use the gmem information that was resolved earlier. */
>> 	if (fault) {
>> 		pfn = fault->pfn;
>> 		max_level = fault->max_level;
>> 	} else {
>> 		/* TODO: Call into guest_memfd once hugepages are supported. */
>
> Aha!  Even better, we can full on WARN:
>
> 		WARN_ONCE(1, "Get pfn+order from guest_memfd");
>
> Because guest_memfd doesn't yet support dirty logging:
>
> 	/* Dirty logging private memory is not currently supported. */
> 	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> 		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
>
> which kills off the kvm_mmu_recover_huge_pages() call from kvm_mmu_slot_apply_flags().
> And if KVM ever supports in-place recover for kvm_recover_nx_huge_pages() (which
> is doubtful given that mitigation shouldn't be required going forward), lack of
> hugepage support means any guest_memfd-based shadow page can't be a possible NX
> hugepage.

Thanks, this sounds good!

