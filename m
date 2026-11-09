Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2C9606A32A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SFz3Dfvs
Received: by kanga.kvack.org (Postfix)
	id 409576B05B1; Mon,  9 Nov 2026 00:37:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA0C6B05B2; Mon,  9 Nov 2026 00:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC506B05B3; Mon,  9 Nov 2026 00:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09B346B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:37:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F3281C3E92
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:37:19 +0000 (UTC)
X-FDA: 85414472598.12.F81539D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id ECE544000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:37:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SFz3Dfvs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794202638;
	b=b95iI+LUKaC8q04FvVh6HFkxden3c1bwKlvUgrVxALgoZvxOYjpHDaht396MNOVbtO0lwg
	ZiacAakLfMDwhKIg3em9/teDS83WNMSN9Pg35SrWmgc8nU7jNfJPEekikQ/nc79LYu5O2o
	6Z3rmHoQ74r8myqskw5llVN4HTbdiMc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794202638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozxqwrYfOeA2JdEt8v+EBV8WXqLYW6Q2JhJClZ3mZzM=;
	b=OAQTFsCHJXt1/XAJodMbRVvGMy4enbaN+onmR0JM/8F4QATEC6KvULS+Dw0WJiaycFqvua
	uFeha/aJM9ltwKqOU3wQ2FHsjAMbfIZCvbd+k5CgPNwWH8SyPNMQnKNnJjFB3oFxOEroFK
	zijQGWZGhlOFMIC4zykVzjUwx14Shc8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SFz3Dfvs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 631E36060D;
	Mon,  9 Nov 2026 05:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7101F0089F;
	Mon,  9 Nov 2026 05:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794202637;
	bh=ozxqwrYfOeA2JdEt8v+EBV8WXqLYW6Q2JhJClZ3mZzM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=SFz3Dfvsu49EC0/Dd5enhpMYmWj8WG1Qz9hgpIvpuXDuZX0vSXk4pAuw0K0wF1YuL
	 WwDUfolgUFI2Z95Mj+vypcIBuavxOvqY7PYosR/ytl0T7qH7MNA9Y+7qQ/j1RJ9wZk
	 4SiSD9XqUaDXctIFZTXendxhy90DdI3Bm1WydU9rMuQt9BOTWQ4IR3EsvkyBM8265K
	 3hD7Ly6bu0ZlWsuggqeZ63OE7ec2LVGeSVpc6r9rFJUN87s8qYbt/Ura/kk+s3gp3j
	 6CZzzWR+ksauY3XEPxzy8vViaLj4R4yfzyse28VDdlpdNmS/qXoV5AnmfzBBJgs3GU
	 2jXPec4kDyPCg==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Fred Griffoul <fgriffo@amazon.co.uk>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jianxiong Gao <jxgao@google.com>,
	John Starks <John.Starks@microsoft.com>,
	Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH RFC v3 87/88] QUESTION: KVM: guest_memfd: Disallow
 private mappings of shared-only PFNs
In-Reply-To: <20261106-gmem-alternative-providers-v3-87-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-87-8484dde66a7e@google.com>
Date: Mon, 09 Nov 2026 11:07:05 +0530
Message-ID: <yq5ase1atvjy.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: ECE544000E
X-Rspamd-Server: rspam12
X-Stat-Signature: zkowwnonuwt51johh58qj5efmzxntyk6
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794202637-8283
X-HE-Meta: U2FsdGVkX18DjiAJkgA2Jnv7bqUMWtIte63NPs5t+dQFKXftakyfx5/10ee4/rHITrVK1uY8RJ8sOduidl6O9y6wJZtGdgytc4ct4ub9MlF/sFD1O5nDW90QDgH1AqGAqnWEl7UO0+BtqklYZXDLqHYuM+OK7qCfQ1PaqJ8sjdV0Lokrtj8u9cFG3TDO+adibPbYO4CAZQ51V9gMqn7rdpREypvASAi4gT5d4wyOIXqtyXtXXPXhQFwzvTrUuwA+0CjMavgIaMNPgbBX9wTvr4Bow0Zk3Zz+qnB6Zlgxv8GYdQeyo0XT88vAjy0rCpXgOD74gebNzHXa8ejH+zKLMQnqua2jr8cq3PKKVQ43jQGbgkC5+UBS5tfCGSv5hbFwBeXZjOkoNGFASZ2SvamwGq2TGtUppP9k75nDBGSRxyiXg9QIXomy3UWQ1RrdJD4FB2LXvkTgoVwzJRuUQS2ynTquKUPDJVle7kMb/78YnorwLf6DRkwOSU22kAJUtr/JP8PN1UIaT2Jw8nKQZC4PhsySJi0YO1lSPOv55/wEC3REsbMQBpOp6huBP3vIes4FsRXwwhOeHdhn4N9YzXTQ5SPdaxptCm4/YK2HbP6mgiluWlCw7ekveGJ6jgI4Rkqw745N3j8GjIwoBVqQK5Nbwlh6ke7LDess7q7LE8rZJD9S+32Dclw0Y9TGjb957Ydoz3pLo20nEDEAQGpTWqoup3PpRAiYYxF3B0LAkT6LA5SZf+U2Gfks2i6qum1LWfiyMB3gKGbi8tpLbOw1vj89d6/kX+ByPDC2SFQi0letVomg4Ke76u2EbNdZJ0E9+z2mxaus8CtmYyKG73C1aG2EBW/XTL0xrk5OpG+UsaXYhCoKzp7OFlrsnoW/CTaKkGU+IZtKnL8xGkN6g6ltPcjvFX6nOVSn4CTUy/CGfPhDuvyK9HOO4aqlyrIdieOH29O1n3w3GrgS2wIezW9AoRg
 RyGTAfuB
 dxNNeFWnMqAX+t5h2nDNjrIaDJIJEHgzDaA6pekTOG9V9X8HOxfOzwztTFgO18SF6nBo4xPvfUeR8uGZcmE0DNHQxjIVq+2DKTIQVMF1sQ3T/KAfgiEb1W+fbBjmSNqcEsYcUSNxf58AFGgo7iUUQG9RMJ4nkhk0/7RN9nGbTvxGZY11arz2B5bKE6jAPhhpMqs4zvp4EL52Dv+0KxUbVwiWA9SicRbsxzPHx+Kxb/sFXzD3PiXJsyjxm2Ogp71oUNU8QflfFgRRaXrMbiIFXNa2SqOFuiLaW+M70eHuzpDLzBi83nGW5D1dyfOG579lD4htf+nMD2BuJ7z0Cuigl2IIoX3fpeKdKji7WS4vQue+PiAn3wqDSmwmO+41CkRYZZSr6dmdWGdyEx39E88wkZ9RgqT3JwGeaqFjW+MIFG2t+pgqXGQ1D4UTBQelJXIjpISF5Y9Gd4ZqSCGsl5uQQ7ojBh8wznsTG4b35B89EKiPeFHQqb5u/yslZJbCq5A4qXsBZ6Sfc1PfgV83DV3IKz5oQvcjmLY84h5RWfuSPtK3+n2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
writes:

> From: Ackerley Tng <ackerleytng@google.com>
>
> Host kernel drivers directly write to the PCI MSI-X vector table to
> program and mask interrupts. On confidential computing platforms, allowing
> hardware protection tables (such as RMP, Secure-EPT, or GPT) to mark MSI-X
> pages private causes subsequent host kernel interrupt updates to trigger
> fatal hardware protection faults.
>
> I see 2 options here:
>
> 1. Prevent it at conversion time, and require INIT_SHARED
> 2. Let guest_memfd track all conversions to private as per normal, but
>    block setting the MSI-X range as private at the platform level by
>    blocking platform config for SNP, ARM CCA at fault time, and by blocking
>    faults for TDX.
>
> Implement (2) partially by introducing a PFN attribute bit indicating that
> a physical frame cannot be mapped or populated as private, reporting that
> attribute from VFIO PCI whenever a BAR page overlaps the MSI-X vector
> table.
>

For the TDISP flow, we could initially treat all MMIO BARs as shared.
The guest could then request that a specific BAR range be trusted
through an mmio_validate request. The validation operation could call
set_memory_attribute() to convert only the guest-requested range. This
would allow the guest to control whether the MSI-X table and PBA ranges
are trusted.

Before reporting that the mmio_validate request succeeded, we would also
need to ensure that the BAR range had been marked private and mapped
into the guest VM.This is required for the device to transition to the
RUN state. This also means we should not get a gmem fault on private
device PFN. In my series, I enforce this in the architecture fault
handler.

The host must also be prevented from modifying the BAR attributes
afterward, as that would cause an attested device to transition from
TDISP RUN to the error state. An earlier discussion also considered
whether the guest driver should be allowed to manage BME/MSE. VFIO
currently emulates these, and the conclusion was that the VMM must not
pass it through. Once the device is in the TDISP RUN state, the guest
TSM manages the power state and BME/MSE changes.

-aneesh

