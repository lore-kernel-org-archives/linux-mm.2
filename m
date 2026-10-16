Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE443CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D5B6B0088; Fri, 16 Oct 2026 06:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DEA76B008A; Fri, 16 Oct 2026 06:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A65B6B008C; Fri, 16 Oct 2026 06:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8EA6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:57:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E208120381
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:57:58 +0000 (UTC)
X-FDA: 85328189436.26.CF07A55
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id C4C3620003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:57:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iHVdrgvc;
	spf=pass (imf31.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792148276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JjoY/Y//bNqM95eGJvwXGt/YGARtJeL2jF1lkb5NGWs=;
	b=YUNX58gzc8UoKRi0f/7i7AxFNd8XaIDNyjd4bflZDKsdRffhXHNOpNMhCZnEIFvxqhOcwA
	FIcVRJOw8OL3UNpB7C+DFiuSrcYW2MQahGw7maf+dfCv7I+Fcbm+lR3cX8DRjFKp4pmWjT
	Cl4demoCsQcu9S1qS9g7i116kWqYYmU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792148276;
	b=NQMY4GL+w3gMhkJZJmRekfoDEEQnWutynlFlESHR6BNHBiYyNwAeRDQu4/47oFaZUHDrsE
	ceM415irkWh2ZrJHsp3sSs/XtCXC0YCE5xxi86N6j/mNGfOCyvSEMRfyV8j3jIkzxREDkp
	8wggnnEPD0dHqgMEKgkVM8ZRIOqTthU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iHVdrgvc;
	spf=pass (imf31.hostedemail.com: domain of griffoul@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a17baef589so27224185e9.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792148275; x=1792753075; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JjoY/Y//bNqM95eGJvwXGt/YGARtJeL2jF1lkb5NGWs=;
        b=iHVdrgvc5bwinEggjxvX7+JSQjMiBPSwOtWmF2BwZeihoW0Y4ltf+Wu0y8HvYvc3uX
         PN8wHi03HWofRwo3LoI4d/rjPXZ8/V2fVH+PewxhVsnJEV714+4277iJ8Y5iQh6sCqv7
         iywWvAhk4D1fHYjBxIbR7bu8UeqCquQjqXy4OKPvkx9IKVsQ3zmrZC2fLqYsAz1+/WKc
         xAt484UeVKQ4dz0L7k8P8ozdTEomgz27crj0iRz+N7/oXwjkZL3TnzEN//unvC8/RBma
         cq1Xa/2XUdAKlW+/4cvmoIBwIFP4D/enQga0/Kly6y9XbShDr5j+Dr4ylqKd+eCegW/V
         arzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792148275; x=1792753075;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JjoY/Y//bNqM95eGJvwXGt/YGARtJeL2jF1lkb5NGWs=;
        b=YVx9l6wQaHfR71YFWbvbqfnZb9fPSrWBJHAoCJbSK4zYQQeal+7m8k5MT300RBiWf9
         ngNgOfKL9iVLGQ/oZqfbaVe+kAhbyzSAqM6Yr60v183C25KXGekHn7MpHw6Zv83fDGFN
         R1cGQ+a1Ow8L16ZiFk4KU96JDccv2bxqpXH1nQhMokqWSf4vOVUPOs+OEMytt7QG874O
         FTDtf7qmhXUmTsIYKEVJt7B8A69uducQXIWjzOQwgic55n0UyqAGME2aRonLgsf/EsVs
         d0dkJjAb9lfA9laDP1LDxu+fOqCz8JIap4JlaoKdVrlZZwM/IQ2kxuY9Pho6t2wRvRaf
         WHbg==
X-Forwarded-Encrypted: i=1; AKwUvByo/7XMHpD3TpgRZrjt643HfziDeq3qhbtqT6uC7nI5G2Udq+RrEonT5tl7S1u7/QYvDbxFf+s88w==@kvack.org
X-Gm-Message-State: AFq9FYJVU6LrmMV+an9nOZt2xdao9byN4OegxuXWY5wGNHT64+a9p3Gq
	vHj73Pudp1kyX6vyAd3GCF1LHOPYbkKNy0RdimPFfVS4f7nS8NBKfsGY
X-Gm-Gg: AYBFou0ZHy6BZ/egk7hy4Q0SM+d2ikPgXn9uBoXKom2CZsRxA9MyQfvxGv2jOEcw2oH
	fQzrjcQDM66VMQZAwAaKJZLbvVm7GrR6IB/O1jgFE6TlbbwgOcQYkTm+p/JJ2ep4HmPqQYCjBxa
	1E4oTYVH1u2nhRW1aqv0vxlCSjfMt8OJU0Ty2NCsvRw4A1aj9C62Jset9EfUaXwztti9pZGNLdf
	QQggZUlr9dF/+YVbRp1nndVkUEbrzIRsoxTCTOiIToGgE1hRB+hGoi+zDKUTTBXqUEoceKalIbv
	9goslR0tKKnz2ezXyRMOrzLEKHltR1DY20sGsA38TO8ziWUB27MkAOQbwU0VzieupPd6YogqBfk
	lqSw6p5J2LFONCqle+z1W6MzpXqknZe6yUNj6BSbTd1tBZx61eranKvfREEe1CDVw98tNQF3PHs
	J0A0vA+DHkx1tXnb+t8N/5L6nBkUi2De+pnSNNO44ER+C1e8QhtTXqmGrFxz2T+76V6NBBX/0PH
	aUSmCvZWt0mQNEnA+ljrbISIy19HVbZ36Y5LizJ1fuVCPiziPwXOjxhmSMnxX7UenXUQLYh0pQK
	B77mrFiKHOdetZbU+kZ7ZBpADDgNte5tOX0=
X-Received: by 2002:a05:600d:82c8:b0:4a1:cedc:ab51 with SMTP id 5b1f17b1804b1-4a1cedcac09mr30065765e9.35.1792148274917;
        Fri, 16 Oct 2026 03:57:54 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8ae6d2esm50003685e9.6.2026.10.16.03.57.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Oct 2026 03:57:54 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/11] mm: Memory providers for guest_memfd and iommufd
Date: Fri, 16 Oct 2026 10:57:52 +0000
Message-ID: <20261016105752.68015-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <yq5a4iem57qv.fsf@kernel.org>
References: <20261014093733.90312-1-griffoul@gmail.com> <yq5a4iem57qv.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C4C3620003
X-Stat-Signature: ntxq7jf6a8tsnopuoc9yksptz6bc5rog
X-HE-Tag: 1792148276-287312
X-HE-Meta: U2FsdGVkX18MR6MRW3nrujI5mSPAw82zYoU1JbnmIlBbp6b+9b9oMIiDn1kC/QpgX2oeYnJtSAPleRdb27P1UN9wsbO3QyILtJkkkHZZ0RQqBCUXs9ZUv9BOxVYGWauztQoSkcxsEbyzq4p4YWhVSn2/GtZR9J6VbMuFMQ/zukoZR5RQIs4E0mFW+avhbbN7EnK8s4tm9iJnrEAlIBEOuW32DRJE15bP/+CNpJsQxekzgbwM4E+kYWL5kt/mHVk25L/JMWoIeC51O8FF5qKt40PR8Wkn0/0nwLtd5L3x66DaWoRL/4YkGx7RKsNApM//7p+JzE7eLXNQkIcaKj48mHWQwl0dPt3sPIDJc7VxD2XVWZg8fwCCbA10ixI0C4tyfmzB0z3wpn84EjnNkhlHZwOqoRJfjiErH/GwM9HPqCxVBpQVv8T4RJ+q6JCT7UmP26Vp+pw2NPiliyKab1bYqUJODAokJ4V9cDW2qvfCR4EBITlkFSBU9HgWD++LwtAdEqHPe8sLZLevMfl1K5bRaFgZBhL3K7lkU2oNAbzOk4Va77i6tROmPIJpu3pKK4uL1NZOG9BmuufHdKz0/xu+nM71ilYNalh8qNaBnW2kNbt3PhIfW2+nyRYF8O/uYejfDWqLEItZcHra345xi5J3njgBaXlmpYpH5ziXuDEG3wldV+VRfQDENXwDEsdMoMYqWORh4902uflya3GtzC7twFCoqk1sD4R9cfZtL9kj/BTOZBV0D+wrvkpBKv7NRs2Ghp5X8u7Wg2MJ4uzQ5/qTQAgF9l012d4QJ48/rIdAWHwS5l9IEj7hTpoqf17f/BguvMp5eiv9DMzvFO2CYRzC34J73cdsfTnrOFgywDa30vVCIjWWf7uZ6uYV9YfaHGj4LFOyyoigV0nPSj+cvbWhZEf4MUYVsYTXjLTDuwZdWwxVyQ3EfEKebdwiDstQdxIU+uVLQgE1H8kOTTYMPcA
 HcC1wXdJ
 HneAna/BOJUBj1i5KcBE1AnbZZhu1rJKJ+R+EafHCGzwl9xffZ4qPay8sdoN1HhSiSW7bV1KBHIquEFx2wsOuxmOCliCKxU2rPiNQTvSCCfzqhbwdCo7uePyb4W86uE5H1LVE6f2+zuU9nNl2o66tNHGc10RTkbt9ApLzsoqKRhvdTz5i4gVLOl0Ppyt+0ne3pdPDdzODWdr9AcI7V3Q99uTKXqeOim4rxC9czmXRBWUf+XQjDhiDlFbMcNP6MmTUQLhPNld/dhUiefZe+uG7XrdaHEunS16qPPFU2iVZJ+BKf6Aty4LEwb8Jv5KewUt1REqDBHkBun06ecR9M0GDDMyTK7qdm7nLgPH5fSNH7Wn9W5uCYHDPrAwnseTVYr78pk3oiooCYAw7NZJ7W9RDJ8XyJRGBS9Wx8YANFOAyNh2HxtQdRZIlLuldgZzK+V7lh0Bix583rPggrU8mAlQ6fSkJP5EZzTW/+8mZUvDXJ4IL7SroGoVv+JVFziWdH8yHuLMyAEdwWAf6FdYf3+Gv2428NsdZMYVA3nAn5JKfMP79oliF3+ulGEBrL8HHlTa3SCpctbOF+zqLAbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Aneesh Kumar K.V <aneesh.kumar@kernel.org> writes:

> What confused me was the introduction of memory providers as a subsystem
> in their own. What we really need is the ability to map PFNs from
> other subsystems into KVM stage-2 and into subsystems such as iommufd?.
>
> Restricting the scope to the above, at least initially, would make this
> much easier to reason about.

Thanks for looking at it. I should have explained this better in the
cover letter.

A memory provider is the driver that owns some memory, like a carve-out
or a device BAR. It lends pages to whoever maps them, and it can take
any of them back later. guest_memfd is one user of that memory, and
iommufd is another, but neither depends on the other.

With this series, iommufd can map a provider file without any VM. Today
it cannot map such memory, because memory without struct page cannot be
pinned. For example, a host service that recycles provider memory
between VMs could clear it with a DMA engine driven through VFIO and
iommufd, instead of the CPU. And since such memory can outlive the
process, or a kexec of the host, a network or storage dataplane could
restart or be updated without losing its DMA buffers.

> For my use case, the VFIO fd becomes the backing provider (referred to
> as backend below). We can create a guest_memfd using that
> resource_fd, allowing MMIO BAR ranges to be mapped into KVM stage-2.

That fits well. VFIO could be a provider for its BARs: get_page()
reports the BAR frames with the MMIO type. guest_memfd takes the VFIO fd
as resource_fd, and iommufd can map the same fd. That could also replace
the dma-buf plus symbol_get() path that iommufd uses for vfio-pci today.

> Another feature provided by this series is the ability to map the same
> range into iommufd. We probably want to restrict this to shared ranges.
> It may be simpler for guest_memfd to drive this.

Agreed that guest_memfd must drive shared and private. I replied to
Ackerley on how that could work with the provider interface:

  https://lore.kernel.org/all/20261015171746.51538-1-griffoul@gmail.com/

In short, on a conversion to private, guest_memfd claims the range on
the provider file. The provider code in mm then revokes it for every
other consumer, iommufd included, and hands them holes until guest_memfd
unclaims it. So guest_memfd stays in charge of conversions, and
iommufd only ever maps shared pages, without going through guest_memfd.

> Currently, a private-to-shared conversion causes a VM exit, followed by
> an IOAS_MAP for the newly shared range. Could using guest_memfd with
> IOAS_MAP_FILE avoid this?

Yes, the IOAS_MAP goes away. The conversion itself still comes through
the VMM, but once guest_memfd unclaims the range, iommufd maps the
pages again on its own.

> Perhaps the series could be rearranged as follows:
>
> - Allow a guest_memfd fd to be used with IOAS_MAP_FILE.
> - Add a VFIO or other backend for guest_memfd, without calling it a provider.
> - Add support for guest_memfd to provide guest PFNs to other subsystems
>   through its file descriptor.

I'd rather not make guest_memfd the only way in. With kvm_gmem_ops,
each backend implements a guest_memfd: it binds memslots, invalidates
KVM's mappings, handles the host mapping, and for confidential VMs
prepares the frames and gives them back to the host. That puts KVM
internals in every driver. With a provider, the driver only reports its
frames and revokes them, and guest_memfd does the KVM side once, for
every provider.

Your diagram already uses mem_provider_ops between guest_memfd and
iommufd. It is the same interface: get the frame behind a page, and
revoke a range. So I'd define it once and let drivers use it too. That
also covers the cases above, where there is no VM and no guest_memfd to
go through.

guest_memfd can still provide its own file to iommufd where there is no
provider behind it, for a guest_memfd that allocates folios. That would
use the same interface, and the same iommufd code.

Would that work for your VFIO case?

Thanks,
Fred

