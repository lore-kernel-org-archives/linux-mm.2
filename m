Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 794C0C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 13:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FFDF6B0095; Fri, 21 Aug 2026 09:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A8A6B009B; Fri, 21 Aug 2026 09:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C266B009D; Fri, 21 Aug 2026 09:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C833D6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:39:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64B941A0132
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:39:23 +0000 (UTC)
X-FDA: 85125383406.28.C4764C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B03C610000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:39:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oWL/xvv0";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787319561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5qvxSsmX93GMZIq4o2S4vCyfn1hgCx4th+U3zJS7iQ=;
	b=xwjIHxopOvLNk7fEbfef2+EBAWCHs3AtYLnI9XXMnjia4ZZxhPeO3dYCDU2t473dm9TQ5s
	QdH3b5nOJROBhRkKY174NWXtXVxo0VMwwJzlKMqtFfd7lV6lN/+G9Y/GoPdLmLwbjPulGI
	7NpRuqGTONdMEPDDw5VW+wiLAHSuMJs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oWL/xvv0";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787319561;
	b=blpXdnTr4fQaHzN4gCCaTev/jMpuL3IkwrkR2TnXFxeXvO6ehbVTSI+7mZ24/kY1DhWyRU
	LUaggu4S15t4k1/GasmlEYHx1MYT00WM/uGYPXhgY3QRz5M/RG2cWdTMdWVTdZvR2A0aHC
	sZPC/ZUq4RdBrshCs5aLldMSv1geIMA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2060760A69;
	Fri, 21 Aug 2026 13:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D851F000E9;
	Fri, 21 Aug 2026 13:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787319560;
	bh=z5qvxSsmX93GMZIq4o2S4vCyfn1hgCx4th+U3zJS7iQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oWL/xvv0Ecw0+byyi+FYm+YqgpJUQd7rkxhyEU+OqTnezJNJmQTYOXllz0ZfQXurP
	 HSOb6vFsiHAP6Z2O2N6gcii1eZrWM9e3R7/NPlp2GA752q542z8kFJoOvG/YPzqlqD
	 iKYKdMfNv8Qk+Z1H+OZTtbTtg4gm5CTl6xxybmYolLtW5+KHj1snAKwa846Rt4HPlT
	 fWhuMQ78kHGtTKaYABYWhRNt8+R7IUYV92RMOdn/oqFED4BHhaNkczEQGw1fMw7X2E
	 SYsJoIFjsEZuOmdPYwA/r5KYajK4hPeksolQMdgY83/MMf9mHkcMmqnLgvwtoA6Vy4
	 icWl+pRjNvuXA==
Message-ID: <3cdf9ac0-b77c-4624-ad8e-68c10af648ac@kernel.org>
Date: Fri, 21 Aug 2026 15:39:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/9] KVM: guest_memfd: folio migration for
 non-confidential VMs
To: "Garg, Shivank" <shivankg@amd.com>, "Gupta, Pankaj"
 <Pankaj.Gupta@amd.com>, "Sampat, Pratik Rajesh"
 <PratikRajesh.Sampat@amd.com>,
 "nikita.kalyazin@linux.dev" <nikita.kalyazin@linux.dev>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "jack@suse.cz" <jack@suse.cz>,
 "tglx@kernel.org" <tglx@kernel.org>,
 "Dadhania, Nikunj" <nikunj.dadhania@amd.com>,
 "Roth, Michael" <Michael.Roth@amd.com>, "corbet@lwn.net" <corbet@lwn.net>,
 "mhocko@suse.com" <mhocko@suse.com>, "gourry@gourry.net"
 <gourry@gourry.net>, "iweiny@kernel.org" <iweiny@kernel.org>,
 "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
 "byungchul@sk.com" <byungchul@sk.com>, "x86@kernel.org" <x86@kernel.org>,
 "bp@alien8.de" <bp@alien8.de>, "ricarkol@google.com" <ricarkol@google.com>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
 "Kalra, Ashish" <Ashish.Kalra@amd.com>,
 "willy@infradead.org" <willy@infradead.org>,
 "surenb@google.com" <surenb@google.com>,
 "pshier@google.com" <pshier@google.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "fuad.tabba@linux.dev" <fuad.tabba@linux.dev>,
 "skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>, "ziy@nvidia.com"
 <ziy@nvidia.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "sashiko-bot@kernel.org" <sashiko-bot@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
 <0a02a6c4f0ee50ca596c4a2673b2ae6c80d4569b.camel@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0a02a6c4f0ee50ca596c4a2673b2ae6c80d4569b.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iw41cdfabhqojmzff5yaei8w56efmrpj
X-Rspamd-Queue-Id: B03C610000A
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787319561-505573
X-HE-Meta: U2FsdGVkX18KCM1xNnuAyfyUJ8wPz48WGgA/j0S4DC5d+qzr7J5uh6aRGjOZMKepvpKDqcuO74CesuED619IjLFRaqy0/IxpQfqr28ctU4vIgisenn0I0dLw/caKNjd7NYUGz2Gel6swECfGp54av11Xi4awdkxsacibnfn9dAWnczUl8vSA3CcqlaOmBdwTWYXw4Lo4XEZAUlcLXftKh21JglcMGVMLJG4R4HiaK7sO9O9g33cw7PwWyXvqtEAIoe4jIC7boaBa9Fi8WxCrZW0mUr6kfZOqb8xWnQunLRG7OyKiS9oKg4qLLN4c7U84BIEKWk8PsfjDRKW4FULXVsUyj6c5bDuSUcK6DkHI7AwFGS6SrSiBP/pBW8sH6J+gZ1BpewCPf13iBXVD4LQc0B36RLVA2auxMiLZtEEERbPMRSk3Tf+zMmEs1kfHn4hIE/RshaBKPfhm2mu97jims6r61AgcJ9Xih5lyK+/x4KcnxqgSPa+JTKya50Tcebvj+UhCEetK0WrUU6QDcAcU6Mun2/Wh9JnfqbjiRd0WlqLCQ5vEqdhVNGrYMC9N8CCI0LdQwFz/DQI5qffmmg6Y318LlSw1uwmz23pzROApkgHno5VrrWoKMfgkXwy+DXxQRphJb2ndTe8mWBcWwQR3+QUSwlx77k4eF8tu8ILyoGtP27aWJTen8NShCuAeh0+jIZ3XbZ0Wvd/riyKS15bixQh00oOQYturrR/i9Nt9QvI5jQYNUILH1QDj2MDKfHLZ7zOm5JrAMBmgGq4HlHF7jNfYeUEq1+1/72c08a4BxE6lURCCXW1LmVHpnjMv9OrAQjr2sxXOGsOMSvXXJks5FnaG4+jEx7lYpKwBn0d5Xsjxf93WCtzUIRoW7eATrUnttizbgeyRO1DzZ0TWFOEZLWu3EH6teK7pPn18WogbGetHucVfmpx5gzVC6cK6DEXWIWcMCkngy4lHY4BdeIx
 rjQVsUWP
 wLgrkg+OWGTt/8UZnxvVgplDUyQtbHNPNrFzMibmYiQM5G5XecTgcTGV1eiz8uUP6N6zGazrU9C7uZki2A/Kq7ilwVWaC2ba1g7rpTvFAhkSNouXTWxWRDXbbnuqlj2sOK9xIdVb6CRHGcwhxbRluTO+qEHZZRtXNnJGO2UqdiRluoJMGdUnK7v143V+eAXsDHI7Ksj6izC9kJy8KkgxkuplMceNcdQ66hplKKNQwwY0ZspC7ra3EZcCnIkIXwiOw2C6QW6PCX9ZLojmLG4/z0CwQqWzFXBfDqz/lnNjRr8/M7JR6KEdEgjIaMXKCIWF3RqJwfYWkvk4KZ/6gu4o3pvv5qU5wv2NdsGzY4O12w7rMCd9K0JXyZwrO4XTKW+KfNlYU2Z5kCtVpWkiHKatdj4+jXC+l58m/ff2tGEd5gHrzdcyPC25Fl3yDKLiYoGgpjPTMwY43bDk+3eKwkPFd0+gd6J4ahllD19Uyk3+dcQp7bNojh/JXiDB6ZNctNdtHzRrQr4C/7AzN/ds8v5pyCZXaBXFN/38lJLaybTYcBJeEJP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 14:34, Garg, Shivank wrote:
> On Wed, 2026-08-05 at 06:40 +0000, Shivank Garg wrote:
>> guest_memfd folios are currently always marked unmovable, so the kernel cannot
>> perform memory compaction, offlining, etc. This is unavoidable for
>> confidential VMs (SEV-SNP, TDX), since memory is encrypted and copying it
>> needs firmware assistance. However, for non-confidential VMs (like
>> Firecracker), we can migrate the folios.
>>
>> This series enables folio migration for non-confidential guest_memfd and
>> also lays the groundwork for migrating confidential guest_memfd later.
>> Once firmware-assisted copying support is available, those VMs can be
>> made movable, the confidential folio content can be copied separately,
>> and the destination folio marked with FOLIO_CONTENT_COPIED[4] so
>> __migrate_folio() skips the host-side folio_mc_copy().
>>
>> Testing
>> -------
>> Host: 7.2-rc6+(c21bb419386) + this, AMD EPYC ZEN 3, 2 NUMA nodes
>>
>> - KVM selftest: allocate folios on node 0, migrate them to node 1 and
>>   back and verify resulting NUMA node and the folio contents at each
>>   step.
>>
>> - Firecracker [1]: booted a microVM backed by guest_memfd. While the
>>   guest was running, forced host-side migration of its folios via
>>   migratepages(8) and explicit move_pages(2) of guest_memfd
>>   pages. Verify with /proc/firecracker_pid/numa_maps.
>>
>> Notes
>> -----
>> - Sashiko pointed out a pre-existing ABBA deadlock between
>>   kvm_gmem_error_folio() and truncation. It's being addressed separately
>>   by Hao Zhang. [2][3]
>>
>> [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
>>     In builder.rs, add GUEST_MEMFD_FLAG_MIGRATABLE to bit-2 and pass it instead
>>     of GUEST_MEMFD_FLAG_NO_DIRECT_MAP to vm.create_guest_memfd().
>> [2] https://lore.kernel.org/all/ambEdSPjerZIVN0b@192.168.1.215/
>> [3] https://sashiko.dev/#/patchset/20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95%40amd.com
>> [4] https://lore.kernel.org/all/20260630-shivank-batch-migrate-offload-v6-1-da95d7e8b8a2@amd.com
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>> Changes in v3:
>> - Fix unbalanced mmu_invalidate_in_progress count unbinding dying guest_memfd. (Sashiko)
>> - Fix maxnode handling in xapic_ipi_test selftest.
>> - Add GUEST_MEMFD_FLAG_MIGRATABLE documentation
>> - Replace open-coded sizeof() * 8 calculation with BITS_PER_TYPE()
>> - Add get_numa_mem_nodes() and use  MPOL_F_MEMS_ALLOWED for allowed NUMA ndoes
>>   instead of hardcoded NUMA node IDs. (Sashiko)
>> - Extend migration selftest to verify rejection without MIGRATABLE flag and
>>   move repeated checks into common helpers.
>> - Drop RFC tag.
>> - Link to v2: https://lore.kernel.org/r/20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com
>>
>> Changes in v2:
>> - Make folio migration opt-in through GUEST_MEMFD_FLAG_MIGRATABLE,
>>   preserving unmovable behavior if userspace don't explictly ask. (Alexandru, David, Sean)
>> - Add kvm_arch_supports_gmem_migration() so arch can control whether
>>   GUEST_MEMFD_FLAG_MIGRATABLE is advertised.
>> - Allocate movable folios with GFP_HIGHUSER_MOVABLE. (David)
>> - Keep guest_memfd unevictable. (David, Sashiko, Sean)
>> - Split migrate_folio() implementation and enablement as separate patches.
>> - Update selftest with new flag.
>> - Link to v1: https://lore.kernel.org/r/20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com
>>
>> ---
>> Shivank Garg (9):
>>       KVM: guest_memfd: take the invalidate lock when unbinding a dying file
>>       mm: split AS_UNMOVABLE back out of AS_INACCESSIBLE
>>       KVM: guest_memfd: implement folio migration for non-confidential VMs
>>       KVM: guest_memfd: add GUEST_MEMFD_FLAG_MIGRATABLE
>>       KVM: selftests: fix maxnode arguments in xapic_ipi_test
>>       KVM: selftests: use BITS_PER_TYPE() for NUMA masks
>>       KVM: selftests: add get_numa_mem_nodes()
>>       KVM: selftests: use allowed NUMA nodes in guest_memfd_test
>>       KVM: selftests: exercise guest_memfd folio migration
>>
>>
> 
> Should I spin the independent patches out of this series for next cycle?

I'd say, yes :)

-- 
Cheers,

David

