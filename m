Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2547CC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2496B008A; Fri, 25 Jul 2025 13:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA746B0093; Fri, 25 Jul 2025 13:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906716B0095; Fri, 25 Jul 2025 13:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80FD36B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:24:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BA061A0893
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:24:39 +0000 (UTC)
X-FDA: 83703461478.05.AFF5838
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 45E71A0002
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:24:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=L46Sl8Zz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 31L2DaAYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=31L2DaAYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753464277; a=rsa-sha256;
	cv=none;
	b=4u4ExuclMjzjJyhFOLj+1wnSEF1XsZmn9sMeyuE2zr4i8yp2nBNXbK063B77C3pFX0gqaA
	OOMSP3aO3qc/dQmvRCv3xnYdYcwuLyxBkOwkBJ0b7dD+0qWMLFR9TmPQ0mlhzKio6k05Ec
	AXKiMNzEjEa+5TfecIL1tHgOKe2jDaw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=L46Sl8Zz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 31L2DaAYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=31L2DaAYKCKkbNJWSLPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753464277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouGvu65qiGg+JqadVNKAxhqDIWS7jmV1hkTAAApCoHU=;
	b=cBncOe0wzsUauK/X/kXyvsV4ThHcRhF+gu7ufHm4JIBnxdLLe3JLQmncyXqSTFIoLHBFgB
	IekoQNPy2Rp7W6DK6ExK5SSiipponbbueV1fP6Id4ajV6HygfsbLaFF+O5yAJzeoTquRFX
	L8A9VtU4RWSBl0UneOOYrSmGO4MhjAs=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31e3fdf1906so2239825a91.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753464276; x=1754069076; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ouGvu65qiGg+JqadVNKAxhqDIWS7jmV1hkTAAApCoHU=;
        b=L46Sl8ZzFGpfcai/NXI7GmJAIIeOdTQiB2RyqYzvM2Tq89R4WCcej+HHrjHy/Hcil0
         ycLxxsWdGcJkF816R7KCa5xp8xH9YYF7x+iZWRXiISY1HthXR3f9S93FoZb5XwzK9Weg
         Jt4g+t0peFnPoIhaXkLOiD5qtpPaxS0dHeM1HiHoVLew+9dL+W8j+s5RW82eHY1RY7ez
         dXBU7qZ1DD2t94PtygzachF5YoqgHmKmHyxqLa0Kllk9JqhxjlY/q9PwQuyZpCTUH03R
         hcMecvWyWZ1ptEzYg9hIc1LO6+J0R4WZrBr73J6Bt/83T5reUEizImz3In9kaIxNXZdP
         a2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753464276; x=1754069076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ouGvu65qiGg+JqadVNKAxhqDIWS7jmV1hkTAAApCoHU=;
        b=XekCQt4S12OS9L2ZKJNc6cT2EhhGty/Ptbf8L0jXCV2d4mXKXpZquce6c6+Z13g9sb
         5hX/xPCDRr7SnrpsEtWYzUK+dQzE98W698i8kyZ48+TqrHcfszmbeBrx7wfew4wcdcGP
         FSgaqgglIjxn+0i5soOsACi2Gw6mKqxMUyqe140F6A8PrO/pUQ0Tf76t1f9YeHr8swzh
         k1yLTHf0HfV8s6ukcAckLJKuv8tWToc9sKAq+/txg1DXY6kYTRje3A2C0jUiumL6E6ch
         rKaMweaqhWEsWe/wJ7EW5gv3PZ+Cmx/vbCyvE8jedRRLcdl8RgQlKpZ70qF9JI+cDS6Y
         IAKw==
X-Forwarded-Encrypted: i=1; AJvYcCXX3XSWeOz9LuUcaIGu8cBNKXbYPpeB+QAH77rLkMWaMn8oJg7MJc6HwM5a3briLJwWoSIm4Lxagg==@kvack.org
X-Gm-Message-State: AOJu0Yxyj+Vc6Z6LG7JMITapkdleOaGK/anSCF0uKk8SAZ/yoRf8o+l+
	PxvYC3vRnRE4eSCBexIO3xyN8+ZrSIOhzOqedQ7q2GDyDe2mitieyxuOKg6JpQinAaA3anf4G7A
	GqFe/Sw==
X-Google-Smtp-Source: AGHT+IHbAz/eKQpxYLnv3UzRDiNfzFQyWZ03GI8G+wp5sD4kBBYyUq+g8Y0WEpcjXQKRT5uv4bipYXGp6JQ=
X-Received: from pjbsf1.prod.google.com ([2002:a17:90b:51c1:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:514e:b0:312:25dd:1c86
 with SMTP id 98e67ed59e1d1-31e778f7879mr4767541a91.18.1753464276017; Fri, 25
 Jul 2025 10:24:36 -0700 (PDT)
Date: Fri, 25 Jul 2025 10:24:34 -0700
In-Reply-To: <aIOVNcp7p2hU-YHM@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com> <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
 <aIOVNcp7p2hU-YHM@google.com>
Message-ID: <aIO90h_oJsvyxR45@google.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
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
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 45E71A0002
X-Stat-Signature: 8bb1ksqaq4ugdo8p6umf9x9jq5qrwngh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753464277-557580
X-HE-Meta: U2FsdGVkX18SpbrKv2s/ruzayW2//jchaO+NJgDzN4bsxgqkwN0hKIqQz+8SBrRc7VjZb5TyvuzSBBiX3n8RBQoJT+U3hX6N2A7GREBvWQYLm1X7xzU1YbfE72+fhmBb1MacoFD0QxKh0B7Mo7mfOTczZVGkrdxOTvri5scQ88DeQsS9iLX8JP12erSb75SWD9Z/eQGR2YXjKc4JBQePGC5jj6DnchxL3oSBV5kzRW0csj5Hfc2UOBQCq1Yo8KetvfxjXRddDXwNR7woIdCAYEEoL4fra/xwIhYk9LwUKMltHh3ok0GI86mYynHf+ETON1eWmTrZB3jirBdMqS9oXGZqINdpQKVSKWF64/oaw0OOxECB1E+HQ5piaqUYdL6SDzER2MoBGQr0skDO/WUEhZeWRX2R+kwSk0enFHiBlepsk58Zk7wRbh+huQv0vPUh94P0ldxQpoFZONmXRif96AVR4GPcY03Jh8X9SeRQcMKou1VQgaR5Xev258mTJhzZ1Zy5gBFCynRyxEeaa2ziQTz1rRXpoM7fNZ7JOXiSyCcBKG4K0tBFYhGULbQa+xMl8xSRz4RQ6C/6LuWwpL8BzEUJtG6sTwYwagKNDabzl8AnhEzXo17RZcg6ZfqH0Uv2VrDUSoHShHChaoQ3cytosBssW8phn86mpS25JvxP+iFmp/Uyd+yMPwo0XmS+PHTQZqaijhPJBrtXdPY9CrKUXXvgFgOgkM8xcWVojOmH2/i/zWLgHdAXKkY4gf9aNGISf65ytoW/NptJW4HHYqj/UKU292l/q9Mqgz/aTiRX94n7R9Xd6CJ+z1DoPcIxuYvHhQXc5C1oWiOufylAdkCTCF/dK3dtzuGDeyChJKjYRP7Rm1A+aD7ouUHriNq++lySn8qU5Ie7XowsbDm1DA3yTGv3kP3vgRgQvbc4GXgydZEEBk/rVGwdnESRNJtxAkQTFBAGLAQIcUDhyvZJiYb
 6PN9D2MP
 GsQqoiZCSJrbui8PW8V7pfQ6+ysIndcw9RsmzMSXFPhK/pTMyWO9tyv1psOsT+7dbx8uTkoXdM6Mcc9kcGIscnQ0EWoCN1WmlE3KsoxxKpiRnuPy1fyawzOxOfrAmLlgi+/yMJhyk5EvYyC1iFAQ6AYJljVx2f/LruTAxiownK0J3LuS9G1H2UKhaJ9y5f+oJRyegPJQcEO9hqXmhrjfmhwsOSWiFaBvUXoHHYiLEXUwcMuxGPRxisNP/5EQS0/xoKPzgELmaOAjrIO2z7ZdSeKVyz9l9KrgqQ59Bgo+c59lvgXeMn0dseziPiglz1RnttvVb+j2qY7NI+SEyk6yMavV8P5TVEOke8+TVeL+YI7y64L11AfDv/bf710zB3i+c+woAwAQo0zTgsoE2R0fC2snor9WdyZ2DdL2htGtuqMALI2KDSVbvLdBd+8KzO+rC903JgpCNJfJDz4qFVvhZPM5By6aVJukwOH8LAjp9MfisyHqt70iqTD4esMwgohIB9SV98cJrKtTCJsRQ6R7vn4amxwYQuJXlsa6MB5pR8D5p0fyjYTB0j0NS1T5vl2BFUXp9T7tFwVXgOp19+FW1VaCQBnpJDjaEitpK6lyTlazpFK0h9MtXR6ydtn5SXGwpuci3NlFJNKCaPI8fHVJQRHZ8YpmeESNXJg0ADhuxRGoZfH7e1uYMcWErQSMvHSAnsS/km6fVHLB4ISU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025, Sean Christopherson wrote:
> On Thu, Jul 24, 2025, Ackerley Tng wrote:
> I also don't want to effectively speculatively add kvm_gmem_mapping_order() or
> expand kvm_gmem_get_pfn(), e.g. to say "no create", so what if we just do this?
> 
> 	/* For faults, use the gmem information that was resolved earlier. */
> 	if (fault) {
> 		pfn = fault->pfn;
> 		max_level = fault->max_level;
> 	} else {
> 		/* TODO: Call into guest_memfd once hugepages are supported. */

Aha!  Even better, we can full on WARN:

		WARN_ONCE(1, "Get pfn+order from guest_memfd");

Because guest_memfd doesn't yet support dirty logging:

	/* Dirty logging private memory is not currently supported. */
	if (mem->flags & KVM_MEM_GUEST_MEMFD)
		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;

which kills off the kvm_mmu_recover_huge_pages() call from kvm_mmu_slot_apply_flags().
And if KVM ever supports in-place recover for kvm_recover_nx_huge_pages() (which
is doubtful given that mitigation shouldn't be required going forward), lack of
hugepage support means any guest_memfd-based shadow page can't be a possible NX
hugepage.

