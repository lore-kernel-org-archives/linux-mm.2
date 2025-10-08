Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C45CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAA98E004D; Wed,  8 Oct 2025 15:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B218E0002; Wed,  8 Oct 2025 15:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A638E004D; Wed,  8 Oct 2025 15:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A13AE8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:42:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3634D87EF2
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:42:58 +0000 (UTC)
X-FDA: 83975970036.05.5413C7E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id D9A984000C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:42:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ksp6nGE8;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759952576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP9vQFCnCtX028EOcypXG8atRMfj5pZjeUcNA7Kghe4=;
	b=ytMA435TY5gKUsGj1JriccWhKuJTGQD4pk6R+ZjoPz4UYiIxjPRG395L+ed7lD2GkaMBEk
	87y/IPAOPH1wjz9pABeWBN5AxMXQzqbCGRGHHIozby53nL0vXUw/aHpUx5c2ZOtnJtMor4
	lKNF1O/1+g4rGDfB9HwDUGimr1wuZMM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ksp6nGE8;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759952576; a=rsa-sha256;
	cv=none;
	b=61Kcw9sY/JK9nma4LsGipHCa3kC9u3oH81J1UCjqIfK0BwI2CsEZOSYQAPSzxuY/Ylr/5D
	4XaOlUT8JY/IXKRpKF5Z2W68+vSeVuhJfQ5l0hc9eUvilApqzMY5cbxdXgdh8Gi3dTanaq
	JQUblzg7IglX/5T231CXrQcYUyVpQZQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759952575; x=1791488575;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=N3wUMr4zilqdOSdwWk6l78xey8r2OSlsB3dkEbi6Xv0=;
  b=Ksp6nGE8pjCgu+O8jOiEDtP3Ek3TAc6UZW5mG1tS6a7iqKd3yQpSzT4V
   qsrX+QkAOKyAd4hWe2xJn6arrh6m9T4gYQloGmCGmSK+8QWTohahYaSz6
   9n9Mx+96KbyiqoZeXR0gZqKQSaeGcq1Yr4tkuKArnNdPguf6FafAkP4W2
   eSFZZ3ZUWceXkl+397jhJiKmo9QjTan7vCDI08E71AkavDoxLEaj0gum9
   hDV57nB8YVQ8ueQsF7an480oUKct0YHi6+5/lFcwuhmdKKjCjS5sXU2HD
   myywTk8i5e1PsRtYSJN8w/jnN57X9aSk4bKbtYBNbHz7OmY7AzYEv5fjS
   w==;
X-CSE-ConnectionGUID: 9QkUH1M+Sc+Sl5pMN/JnVA==
X-CSE-MsgGUID: 9QEMzmW/Q3C5S6/afjNJvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="79597296"
X-IronPort-AV: E=Sophos;i="6.19,214,1754982000"; 
   d="scan'208";a="79597296"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 12:42:53 -0700
X-CSE-ConnectionGUID: FOAw+Ys+ToyoW+RRavHDSQ==
X-CSE-MsgGUID: vp3HlePQT0CuBfXNohA7mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,214,1754982000"; 
   d="scan'208";a="181283817"
Received: from rchatre-mobl4.amr.corp.intel.com (HELO [10.125.110.204]) ([10.125.110.204])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 12:42:51 -0700
Message-ID: <d3cf3716-98ec-419b-90b7-b91b83599498@intel.com>
Date: Wed, 8 Oct 2025 12:42:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] Fix stale IOTLB entries for kernel address space
From: Dave Hansen <dave.hansen@intel.com>
To: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Alistair Popple <apopple@nvidia.com>,
 Peter Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <c04d4c9d-e868-4883-af92-26f142bc84be@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <c04d4c9d-e868-4883-af92-26f142bc84be@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D9A984000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: n47wkdixnxhp64k79euszfcpu7buq75b
X-HE-Tag: 1759952574-942939
X-HE-Meta: U2FsdGVkX18XpanwhttPH3X/+sIl77UI0rSWH+9kjVWpVKo/FyVRUx1ZBqckKL0Q3N4I5k2r4W5Af0++l/ejYDrksgq80HdgINCtXVr9ekotpCV7os2SAQyQcvIFmUpobWyk5rfJT4tJt+jjvkrTBEGP8DW7GK9jKgfO2+dPN4O8lcJn8AUw6yL5P3b/r3rvIhgbDpoBrNQdJn0Az29DrYcfnD+t1pkqt9gvG2PCWCz6gKtgQDlsbcGNPEANmZDwDU3WUsXScOpHEoECXYf+ngtIUwheBopBGD3OVYeOi7xxto94HLaSY/ycfDKxD17QgNkDtmBMbvy5TH6uu152i4uNc5ifRr1R4DPDEDAATI/z8eIfY9Vx/zOgtUDH/no8jcy8FC+YrYbPSCkEAmQgmxyb1NyxC8AMTysY6ejCVhz6dvS/mtcqGyZ3bRnp5LiANjel+I/tDdyxlTum2bRh+dCbsRJDxriOEjgD+apNVvSVPacVQ80dnd3lfsBwQ4n0UMJ/Dr09y4sCCn2GaMpz0kQr0PqmGnyl9K+OcQB31rYVvfcpWnoW7Ko+bZH2gwfV3OQUTC58x9EVrlJSnYSF83ktjSut9vdpN58Umwv+kJt+X8O/Rk/rv02GsLf46lG5vYTmbg+XOu1ZPGVb8ilZFa29hKQ0sWK5zRxqiLyDneJfRcmRpiP5IKjEK1+3qr9uGXAkXvVixYh64RjGAIowwKvdjzmxGNaP4eMDCHcXNRxyy3pfLQAMDD/kYLhMM9fCe7jnqEqj/DuBvQqWetYqnYc9AHzH45huKRQlJRj7wCAKCTVmvkjS0VWhQ3S0XE2odSIGMe0mwrLfWzwdI4ftmNO5N1c3tMCH+L96O4oDDcnXZVmxnQyyBN+zega3SPjC4ZbE06vHzoQuIS5rc4eb7vE2tG5b3GB+tlDODO3hq/UJXpRNgpDTbCMEg1//vjByVBZUbgP225q4QFUToDA
 eDozTFkh
 +iqhpChr+xKS/jBEtMp1c02Prt3ybofjzom4itXSZAENNNSG3aisFrB7ey//4VeN0SqXdH+AujyAlCVU7oH/jX4iEOLnXoo9fMisln01IFqS9jAbeGSwPIpchKy1ohrkyGQUIGrmyTUYABhj5zFFmcGp8+XdKB+4BY8Ev4G0XxQhx1BrxvOZyOx/AG0NbZWds/x+I0fj6+BhXH0g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I wondered why no mm folks were commenting on this. linux-mm@ was cc'd,
but the _people_ on cc seem to have been almost all IOMMU and x86 folks.
so I added a few mm folks...

On 9/25/25 13:24, Dave Hansen wrote:
> On 9/18/25 22:39, Lu Baolu wrote:
>> This solution introduces a deferred freeing mechanism for kernel page
>> table pages, which provides a safe window to notify the IOMMU to
>> invalidate its caches before the page is reused.
> 
> I think all the activity has died down and I everyone seems happy enough
> with how this looks. Right?
> 
> So is this something we should prod Andrew to take through the mm tree,
> or is it x86-specific enough it should go through tip?

Hi Folks! We've got a bug fix here that has impact on x86, mm, and IOMMU
code. I know I've talked with a few of you about this along the way, but
it's really thin on mm reviews, probably because mm folks haven't been
cc'd. Any eyeballs on it would be appreciated!

It seems like it should _probably_ go through the mm tree, although I'm
happy to send it through tip if folks disagree.

Diffstat for reference:

 arch/x86/Kconfig              |  1 +
 arch/x86/mm/init_64.c         |  2 +-
 arch/x86/mm/pat/set_memory.c  |  2 +-
 arch/x86/mm/pgtable.c         | 12 ++++-----
 drivers/iommu/iommu-sva.c     | 29 +++++++++++++++++++++-
 include/asm-generic/pgalloc.h | 18 ++++++++++++++
 include/linux/iommu.h         |  4 +++
 include/linux/mm.h            | 24 +++++++++++++++---
 include/linux/page-flags.h    | 46 +++++++++++++++++++++++++++++++++++
 mm/Kconfig                    |  3 +++
 mm/pgtable-generic.c          | 39 +++++++++++++++++++++++++++++
 11 files changed, 168 insertions(+), 12 deletions(-)

