Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC17ACCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 09:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7116B0096; Fri, 16 Oct 2026 05:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AD36B0098; Fri, 16 Oct 2026 05:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67346B0099; Fri, 16 Oct 2026 05:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7A06B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:13:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7C39AC032E
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:13:02 +0000 (UTC)
X-FDA: 85327925004.11.A01A23D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id BEE8F160007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:13:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LYZgl/L4";
	spf=pass (imf08.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792141980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQH+kXpKSTymGia/uumXbgT78aV2agpPTvM0izIRqhE=;
	b=GRMhm2Kz4RAmJ4JKnIqMUVDR/LncSE4IKDkvLQk26VvZvafLw6P/1qeYA+E1o4j++w1O2L
	7zhlTgMSjc+2FAlIO/7M7vZ93bVdQpqfj2bIclyNJUBnFL8FRrz05NHIL6T3haN1Fz2y4D
	zkNdXw30mRxN3rA351/gk69+DlE/6uU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LYZgl/L4";
	spf=pass (imf08.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792141980;
	b=qKzzDlir41PJ2rmCWw4/GcdRT7B2btZCVvFz0dq/FvyMokX49qeXPnXjT+yaffeyvpy8Ok
	KXGgHe8vH7cGwCLXfJVvwzDdGxMckgQjsQtRAnXU2bJIjZ41cCsOO72OAtYJHAAMprkB8u
	ZGJgF9jE3QWUCKp+8XBJKB+GEV4Y4lI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C74B439AD;
	Fri, 16 Oct 2026 09:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521BE1F000C4;
	Fri, 16 Oct 2026 09:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792141979;
	bh=mQH+kXpKSTymGia/uumXbgT78aV2agpPTvM0izIRqhE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LYZgl/L47fPO8Aq+OVvp5UAIfE6hgsH5zIh9oJrQPyGOyzlbTMZ+sEC6Ba2iivygG
	 TkPuULqc5Ixpat8F42Z/hB853dD7BfPLHituatCT9QtBtX37bYoB2UITBUScGPZJTv
	 /usSd5kkvMwdNHq8GlE8NVjVR68AUrk8rBGTbLTczFneKEc+Vlra2BuBzIxoldvSJD
	 5k/PrxNtsyWoMGyB7jwmq/3ALOfJ2jyscwflYFHeck2tVFD/wKAmWKx5Sd0GuFkzRm
	 5Nais/Vmmp4nMWPIYN3Q5NTbSyK91tqJb4EB8JS7BrO04489Jub9pYLLW9dhx6IUPi
	 ELIJk5iqbinsA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Fred Griffoul <griffoul@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
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
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/11] mm: Memory providers for guest_memfd and
 iommufd
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
Date: Fri, 16 Oct 2026 14:42:40 +0530
Message-ID: <yq5a4iem57qv.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BEE8F160007
X-Rspam-User: 
X-Stat-Signature: qr4szteqeouu43pfj3pwwcpb5yi3p1u9
X-HE-Tag: 1792141980-218736
X-HE-Meta: U2FsdGVkX19e8xC1fZCmB+JLfY9DhACBHCLpSIOsiBRfqg60oZ8ZrjZHSlbF3ZXMyBJ3QmldOyBPSFoLryIJFKl7xgb2QVwBitceArF6y49RQ1GjMr9aiNojhvNmv8K1R1ngvoMlqG9/CUGtxVNNEwvSAPx2RwNj+mCQXObtuaCMGuN0jZKDDPIGC/oHZDfJJxYSO3wXKHt9rZMoQnrdlDJ+5p09aHmIzETsZjcGSwJ60WVqPcqJN16vRAU1hFUMYWC5+NWibKULQ2/6G3PsLtY5vo2xY0Fx57ege4jtKwcE3tZtGbmworWg+L08MPbUB6Et8nspr/0WurQEJ5/w9ePI47ZRz+TFSissfdOhsIAnOS/pxBz0twhVJETZWDKt3GY6v5oEmfw4HgnLpcY1mRVsJeAIY9dqvUJmXPGn33BSH0LKioI/xC1uNkmqG5tPcUHPwhob9+M1H5gNUxQWGVuSgTPZ54W6QagAvR6KA5lIwRKpFwNwajD06M4LANqIBRNmUZxC9vkstw4PDuZVjkGI8UnjaR3D9e3VRHDcCaPJHgupZuNpnbyl1lCbz+AHhoE3TCarq52rbSkVcBes7lAjw5uAZ7tc1KOJO+pTBnQiOJMu01qcXkyXXk26OFTC8TFunECl0EFqvb26AP+EgTG/J306hNDaKG5RjdToFyrUBTE17Bnv/PhyZ+bOJ/lvxi8rqslSeel0tBq20H+7VfobgFSt0XcDPzEjt5a0kgYtN0LNcfb3g3S95sC3mp6V/1oImzddPgaqmEDO0ScUcS7Y59wwhnNqZ+vUY6JG4TnduauhuR5Gre2eHI/sSMObBbTZCBNMeXOmxCcatWZrp/Ty1XO9RviyHa4birQFQnV1/O7Ba/vWXmMcBr3jZ9MgLVQPSs2fNdYq4N+fWwOlHd0rQvzuo7+GJCSi7XQQ8n6Gf3RS0L17+esIotQJY+NwhWsC6YhmAAq3/chnOu0
 vNkmW0ix
 BSv+lvlVcvJ/DG+LYpXzxhyxLoRZOFs98JIkKixzWl876XW3pvWpPosrILWlL8W6YDOZ/Fk0z1bQJbL1Pg8nAZw1j+gi7JatQfMwGdJyl9/xVQoVXw8a2Gu3JCDEnjxgAyMr9p2kQ5spxC3a39izfEtv1sTSQ7CySvSZPPX1ihlY0X7jKnTjbMUxEI+vHg7ke2CR+pslGQJn387e6RLTmrUPeTf7YeM5wFGTR6qm6HorpHKEWOAOiIPjfWUgcCrgKPNVNZQdx4GoufVphf1HzcIvIUFop+Mv2E7XFTfSanTNYi+IGIPzvuhw3gA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fred Griffoul <griffoul@gmail.com> writes:

> From: Fred Griffoul <fgriffo@amazon.co.uk>
>

 [ ... 24 lines skipped ... ] 

>
> Why a new interface
> ===================
>
> kvm_gmem_ops gives KVM a way in. For devices, the only option today is
> a dma-buf plus a private call that iommufd looks up with symbol_get(),
> which is how vfio-pci works. Each new owner would need another such
> lookup, and iommufd would end up knowing each owner by name. With a
> common interface, a provider module only calls into mm, and nothing
> needs symbol_get().
>
> It also means the provider revokes a range once. The VMM hands the
> same file to KVM and to iommufd; on a revoke the core forwards it to
> every consumer, so KVM clears the range from stage-2, iommufd from the
> IOMMU page tables, and guest_memfd from the VMM's own mapping, all
> before the revoke returns.
>

What confused me was the introduction of memory providers as a subsystem
in their own. What we really need is the ability to map PFNs from
other subsystems into KVM stage-2 and into subsystems such as iommufd?.

Restricting the scope to the above, at least initially, would make this
much easier to reason about.

For my use case, the VFIO fd becomes the backing provider (referred to
as backend below). We can create a guest_memfd using that
resource_fd, allowing MMIO BAR ranges to be mapped into KVM stage-2.

Another feature provided by this series is the ability to map the same
range into iommufd. We probably want to restrict this to shared ranges.
It may be simpler for guest_memfd to drive this. The resulting
relationship would be:

+-----------------------+
| VFIO PCI BAR backing  |
+-----------------------+
            |
            | guest_memfd_backing_ops
            | Supplies BAR PFNs
            v
+------------------------------------------+
| guest_memfd                              |
|                                          |
| Controls shared/private state            |
| Exports shared, accessible PFNs          |
| Revokes consumer mappings when needed    |
+------------------------------------------+
            |
            | mem_provider_ops
            | IOAS_MAP_FILE(fd = guest_memfd)
            v
+-----------------------+
| IOMMUFD               |
|                       |
| Creates and refreshes |
| IOMMU DMA mappings    |
+-----------------------+
            |
            v
      Device DMA access


Another capability the memory-provider interface could provide is
kernel-initiated IOAS mapping, for example by allowing a guest_memfd fd
to be used with IOAS_MAP_FILE.

Currently, a private-to-shared conversion causes a VM exit, followed by
an IOAS_MAP for the newly shared range. Could using guest_memfd with
IOAS_MAP_FILE avoid this?

Perhaps the series could be rearranged as follows:

- Allow a guest_memfd fd to be used with IOAS_MAP_FILE.
- Add a VFIO or other backend for guest_memfd, without calling it a provider.
- Add support for guest_memfd to provide guest PFNs to other subsystems
  through its file descriptor.

Would this work?

-aneesh

