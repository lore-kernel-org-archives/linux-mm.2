Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27BEECA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 07:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6E46B0095; Sat, 10 Oct 2026 03:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EBE6B0096; Sat, 10 Oct 2026 03:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7EA86B0098; Sat, 10 Oct 2026 03:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 925966B0095
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:36:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C542A05D5
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:36:30 +0000 (UTC)
X-FDA: 85305908940.18.13B8A69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D1941180005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 07:36:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1scjIDh;
	spf=pass (imf06.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791617789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvHacGZHOil6n8X8TWo3a/lv5iJ2YDY90NDrBy/yA4U=;
	b=B1idKE/zxf3oMf6APoJmAevZMCtzZy4UxqWwCrTT5asrqE2zoIZxnXiLh1mWHeiM9QLOHF
	+sh7oRKcFxwblheDmQSeE6vGL5lp/KLbEpW622WrQ9IPzPK47EavKrewIFVKJ8QILBRtLQ
	1paUkulxonbdAUpTNl9Nk5w3NsRE+OY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O1scjIDh;
	spf=pass (imf06.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791617789;
	b=rzfnYNWJnS9jqMnexaZgbY7yURg77QcyQBPlxzlsC2OKy+fw5dwl2pBuRY1yWOmaSTNSMR
	H0q6/0NcpAJEKO3Fv7Qhovt4/ZPjDmCbsZMD0uDbzdBjKSDLc2idKwOe6jChQPqfuq2zii
	nQzEhX+YPKmHs6fSvYjS3KefOM4bibU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3E6944018;
	Sat, 10 Oct 2026 07:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F321F000FF;
	Sat, 10 Oct 2026 07:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791617786;
	bh=lvHacGZHOil6n8X8TWo3a/lv5iJ2YDY90NDrBy/yA4U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O1scjIDh9Idq26MCPYxo0nalUPgIQV8jPHjj9EAukOJzrIDI+14xcWHlQyw+RQW+z
	 c7bfG0uCWt+vPb6LQbz83ilcKuAN5wvPqekwmSW/kUbYPHVXoZV+KlJYXQjZTB81Cd
	 VxJqf2JFBOtbzVjZ6kkqAF7Dde+UtRdu4nMX+IrjnQrHWWwBN0ZbwR7o5StsVqvnKd
	 ReygXOyiuezuAqNAnHRGyM99QlGFGSNZttQJtO1GHCBElzQxgme2m+vwsQ9rz5XRWx
	 5hiOXKqAE2c85h3nDndjJe1iif63W9teMNiLmh+O8rOw6WU6umu3Kx2kzmp/rr7N7n
	 V56r/87rFYK1A==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Fred Griffoul <griffoul@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
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
	Shuah Khan <shuah@kernel.org>
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
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] mm: Memory providers for guest_memfd and iommufd
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
Date: Sat, 10 Oct 2026 13:06:09 +0530
Message-ID: <yq5ald8680t2.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D1941180005
X-Rspam-User: 
X-Stat-Signature: tpdrdc1rs6og3nuz1ijb9bmae9ztpoig
X-HE-Tag: 1791617788-927106
X-HE-Meta: U2FsdGVkX1+0n2C8jJsqSeFRmQx1GwPBVaQRq4EjvKlfdGYx10cGrjHGWkzR5Xw5Ua2StTIr2xCbg0cRU7UFmaUH51coQDwyR+eKWDbftkLRv58XQmJY9Gj+OReZi8ie02Gybs0yBrIi8VBuHZq2eYnovHCi1HBcIoS98IVm0VbHfO2YA3V9BcJIO1oPHnlYYTTDqPE37b6Pd+PzdVMdV2Xl/iOJQzOM/6Ye4hIhLyZPJJk3FXMj/FeVwEgPCIImi9hDeKJvvnJN0pIj65K5QsPk7WvZ1Y6hRs/XDq6Z0Pq/o9eegHHWSfXPWpo7bKqQCPN4CQ0YXnEV+ds6++XRbYT7TU9rPQKyYGw4di/xC6J+W79X6J+83lEOpWjBlGtc0IXkIMVDjfOgUDC7hY90a8LKfPZKxO+EnzB3koCz8EEU2HzBW8GniG8LJX9i1KYYHuAAHcZZLoJYYtmMCGuyxUgBoRLoSzvOmEpwGlCrAbgGxMAYamSW/yvgGmH3OPfh0x010C7kzYM4fAjcqR7u07O/o6FQwZDky3ALlVTbpX69m/LM6+6iwJXzjsaJZC6ZHjR9vLmA3inqUqW06n1xgsCBsJ2u7QJSlLdKAKvS8VxBLYTISWC06NqmbsH89Ed/GIVGLNwHudUayDbnZTSJpu7L0AG2ZqYpkIcKFVilMEpt1MZh2XE0joBTJKxF/jaxUuR1C/9aHWod3dXLTLHEvsojtbp7k5J5Rw+ciR45fO1foLiLhbk4/MOUxWxhSPK8D2UWfTP6U7bkMjhi8ohP738eNwyEPwLCrLFWQgRWAjb/nCaPCdUoNqPYbGqHD6Pdh4ivnoWrVumxCaWJzxJgv6aGHm25mLizvr3jrSjp4wKRPGt5VrcVcpIyA1ZK27sQBifbGZ8Rq37G0riraWv9GJgnYioMXlLixaRYOp53YyoPhU6k5NkwThGoULRsukezvCyIR56eOYPTVOW10Zt
 L6EyqQaM
 zlT8hyZQebu3aFE4aCWFEZUaKP08aST5JGK8c5HYsz6RBjjwY0FgYhSsztq0lx0+6uJ1Y4tm5AjkKroCwNJZDvgKY//PLcjljp2zjt3qquBiLv267+z4Z6FeZ9diUPrDStQMwmEgmJVXAVS99LWBeAV1LUPEVT4guLShmc/zVAMyi9YuZFtdL9s4n5pP9oI9USeQ694W90QTAg6IGo6vLbL3atCRCDZENfQWJjs3I89PZResAJgQfkt67a4IFVCmf/enUmMHLZ+YljX2D4DSZvEGe+M1qdYLhetb3H9uOt6PKxgCa8FW7jwmxZc8mpBxTSokUJ4/YI6xoHVtUvcHYTu3xsAVAX7WoxAJiU4eINh3yC8lR00526XQ8Xvq3UIenCP0k1UfsPMhr5Qk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fred Griffoul <griffoul@gmail.com> writes:

> From: Fred Griffoul <fgriffo@amazon.co.uk>
>
> Some drivers manage RAM outside the page allocator: a carve-out, device
> memory, or memory that a host component moves between VMs while they
> run. This memory often has no struct page. The driver wants to lend
> pages to a VM and to its devices, and to take any of them back later.
>
> David Woodhouse's series "KVM: Allow alternative providers of
> guest_memfd backed by PFNMAP memory" lets such a driver back a
> guest_memfd through struct kvm_gmem_ops:
>
>   https://lore.kernel.org/kvm/20260720111259.122911-1-dwmw2@infradead.org/
>
> That covers the guest, but not the VM's devices, which his cover
> letter left as an open question. This series adds a small interface in
> mm: the driver that owns the memory becomes a provider, and the code
> that maps it attaches as a consumer. There are two consumers, a
> guest_memfd backend and IOMMU_IOAS_MAP_FILE in iommufd.
>
> The series is on top of David's v2 (base 0e35b9b6ec0f). Patch 1 was
> part of the earlier dma-buf RFC. The provider backend depends on it, so
> this series carries it.
>


I have been working on something similar for confidential computing use
cases. There is likely some overlap between this series and what I posted
at [1].

I have not reviewed this series in detail yet, but I will compare the two
approaches and identify what can be shared between the use cases. Please
let me know how you would like to proceed.

[1] https://lore.kernel.org/all/20261010072504.536230-1-aneesh.kumar@kernel.org/

-aneesh

