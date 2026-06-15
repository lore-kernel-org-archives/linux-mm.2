Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD2DBCD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 10:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5CF76B0005; Mon, 15 Jun 2026 06:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DB56B008A; Mon, 15 Jun 2026 06:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24916B008C; Mon, 15 Jun 2026 06:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C29656B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:43:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5359E140991
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:43:33 +0000 (UTC)
X-FDA: 84881810706.12.C5571D4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D12DA0003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 10:43:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YilFCdw7;
	spf=pass (imf15.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781520211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QxZfZzm8KbWsn7EcMwfMhpI2Zi+BCO1Qsj0jBDfZ5Q=;
	b=v06wJF3OOm27Kt7JS0olSy8vi5FIpxztoLUf4V8iiWKsQy6JvhegqMs4gqLBSItSFz77tB
	uiKWoUakKqnbAKIlayo1jWnuUttJymUyx1lm9EYR2Cna3lVT7jPjViijG2hYxjq0/T6cyO
	VWpJRt2eWSK6PDaLpncIkw32nVccaj0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YilFCdw7;
	spf=pass (imf15.hostedemail.com: domain of alexandru.elisei@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=alexandru.elisei@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781520211;
	b=2iawi7g3A7PH8Tc2Khe/qOlw5fhx84v899tUVBLJJaMh26EXVTb9olsFZydmIkhX1yBppZ
	1pB0mfz1DneoXJ5A9A5qB+hFP0jpcnhc6JdjfLWTN0JVHwPeRgIgRAEqSx1bnaKsbJLc3x
	BubAn9FRhTLTToeNtZOF00uPsK4TSTE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CAEB1328D;
	Mon, 15 Jun 2026 03:43:24 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75FD73F905;
	Mon, 15 Jun 2026 03:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781520209; bh=3yAHPoiKaxpCvGRtA07MNdia4xyAMd/XClNlGDs+yTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YilFCdw7wnbi02p8Ri37XQ9LOpP+gWIbj1xLxh6VFzlKpkicKF+zKdXigOj42eUFe
	 ECB8oiTRkLs1UEvL96SQTRLUaBxPXfMXbysW2WvyNOHsHoIAo9UCdTxpZcD/tf4F/m
	 bGpKZ3AP3paUcX/S/ZEhVk3Sy2CPal6yF/LtIlWA=
Date: Mon, 15 Jun 2026 11:43:14 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Shivank Garg <shivankg@amd.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Nikunj A Dadhania <nikunj@amd.com>, Ira Weiny <ira.weiny@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Nikita Kalyazin <nikita.kalyazin@linux.dev>,
	Patrick Roy <patrick.roy@linux.dev>,
	Pratik Sampat <prsampat@amd.com>,
	Ashish Kalra <Ashish.Kalra@amd.com>, linux-fsdevel@vger.kernel.org,
	linux-coco@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] KVM: guest_memfd: folio migration for
 non-confidential VMs
Message-ID: <ai_XK__RTXMCEcCG@raptor>
References: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
X-Rspamd-Queue-Id: 2D12DA0003
X-Stat-Signature: rzk9bs97ngunmes51wozbx3ocnao5sfu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781520210-909619
X-HE-Meta: U2FsdGVkX1+dIdDTNNqDqrWkbE/qwS5oVnp7/SFA89j1ChN+YPScL3+soCWgrfWIHmhm/StRv8FRZGCubm3wrRNKfdy2VfkAcGghUtyM+GQXQrBbf693NYPrKFquO2EZ8kfPJULjOOLXMtaLLP9NTFJu3GQyI41zy70O0qXSmjHXEkbe7agflHqHji65gbusiimo+Cgxw9kzBZmunFzVqbTjkIBECJl2qMRA3ckUiI6xfx0DOq5ehPPC3qWI96ecb0Bp/3uV21gyR/i8Mb+Eo30tuHJpHOC06w4ZIsdsjjo0XfigJyTmJ4t+CqyrypfFKe9R5CAALig5McIol7RjD7/O3NIll/GvLi1uJzq7TVUERCVRCXXEMa13veFEbuX6E89F0NeI+j0SXCE8HF60RnGdxfIHVPm90zYEQVzyCZcogSE5tnlRMO4sApJ+hMcDqpN9C2Od5/J+0fY+KGkTZT4RPw4cb4uArnCwQYXz0JxDgyRLPiRixqfJFZV/fq6pBZ0N3m9asgIqbmHxpG4H5uSpDBvE8fkjKKp3P3887EEnMtSdo0O29y57GnQxip5cPNMysRWvmMJ5wcPJYB0eKrYPnb4rxhcX3wh3aemKqGXHx6kgEEYH9QK7ASMKFs8DYK/czdosQT6aNxjvOLeAu1Sf3o5t7TQN8S71Q4CARTSOCC3Siqvjg/KAw3ZfPuLptQUbIegfBbtDnxGxBRUb02dMTpRxCJUuNGOZqxzXAYYZC1W9fBERONtY2njhHn5E6s4awTlEphxCBezdwWyQX+RajxgmxtfCJHfPrRDSRHY+GUWhavubnz39fwRtEUSQ/6i5eMRJKQrdyhsXrNmVT4turXJn3B/x/PkeOVYGYfwaiZ95zevvxl5EzV2jMHSOUEVxL+60g0sq3CQ2nidXWTt/8ID41Z7nmgwa/x4G3vUoA48EzEe7s0JCsnGfYdli8QIWUJJPGVryyFPvQBd
 BEdDIqoP
 NDeiYy3LaF18sU8WEwrtEJVsk4BZUxTdNZUfRhoUdNMAtYrfq5dbEeAzI8+mJflEdk3ChxPcdQdROJ/M5jGmXwfxKyRRBshT1EKfL3r89aG1OyWqqPPaJfFoMPMDL2AtatLtE+KVv+XL3/64YBhyBRvYSwn5OEV9kb2pjfpY3cW0ZqkJlHssWh/GtHSKaLUp/ITY9bbTcuCnd15mGFMl5bXHOrp87XJaNo7Bzg8qNIrpeKLLwyAVpzyK1WlRE0P7Xr59yZGMsDFG2qbV+V/BOw7gUpYrYUVho9Y/esyxP4aGTVY+4M+shJadyO+hP9nTSbLWLpynKRKHrwz2341aAuGLRaeghsyrlykYgKtsIqWQEsvGT7jXBIHg40h97zBREluvp0r7bxxbRZ20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Jun 11, 2026 at 01:05:07PM +0000, Shivank Garg wrote:
> guest_memfd folios are currently marked unmovable, so the kernel cannot
> perform NUMA-balancing, memory compaction, etc. This is unavoidable for
> confidential VMs (SEV-SNP, TDX), since memory is encrypted and copying it
> needs firmware assistance. However, for non-confidential VMs (like
> Firecracker), we can migrate the folios.
> 
> This series enables folio migration for non-confidential guest_memfd and
> also lays the groundwork for migrating confidential guest_memfd later.
> Once firmware-assisted copying support is available, those VMs can be
> made movable, the confidential folio content can be copied separately,
> and the destination folio marked with FOLIO_CONTENT_COPIED so
> __migrate_folio() skips the host-side folio_mc_copy().

I always thought that one of the nice things about using guest_memfd as a
memory backend, as opposed to host userspace mappings, is that the host
cannot unmap VM memory because of KSM, automatic NUMA balancing, hugepage
collapse, compaction, etc, acting on the host userspace mapping of the
VM memory, and outside of the VMM's or KVM's control.

I think it would be useful to preserve this behaviour, even in the absence
of confidential VMs (i.e, guest_memfd file descriptor created with
GUEST_MEMFD_FLAG_MMAP).

Thanks,
Alex

> 
> Testing
> -------
> Host: 7.1-rc7 + this, 2 NUMA nodes
> 
> - KVM selftest: allocate folios on node 0, migrate them to node 1 and
>   back and verify resulting NUMA node and the folio contents at each
>   step.
> 
> - Firecracker [1]: booted a microVM backed by guest_memfd. While the
>   guest was running, forced host-side migration of its folios via
>   migratepages(8) and explicit move_pages(2) of guest_memfd
>   pages. Verify with /proc/firecracker_pid/numa_maps.
> 
> [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
>     and change builder.rs to remove GUEST_MEMFD_FLAG_NO_DIRECT_MAP from
>     vm.create_guest_memfd()
> 
> Best regards,
> Shivank
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> Shivank Garg (3):
>       mm: split AS_UNMOVABLE back out of AS_INACCESSIBLE
>       KVM: guest_memfd: support folio migration for non-confidential VMs
>       KVM: selftests: exercise guest_memfd folio migration
> 
>  include/linux/pagemap.h                        | 24 ++++++--
>  mm/compaction.c                                | 12 ++--
>  mm/migrate.c                                   |  2 +-
>  tools/testing/selftests/kvm/guest_memfd_test.c | 77 ++++++++++++++++++++++++++
>  virt/kvm/guest_memfd.c                         | 49 ++++++++++++++--
>  5 files changed, 149 insertions(+), 15 deletions(-)
> ---
> base-commit: 4549871118cf616eecdd2d939f78e3b9e1dddc48
> change-id: 20260611-shivank-gmem-migrate-8c1c519b30a6
> 
> Best regards,
> -- 
> Shivank Garg <shivankg@amd.com>
> 
> 

