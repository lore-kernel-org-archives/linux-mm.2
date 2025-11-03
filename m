Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB94CCFA05
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 10:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5938E0052; Mon,  3 Nov 2025 05:51:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D598E002A; Mon,  3 Nov 2025 05:51:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3258E0052; Mon,  3 Nov 2025 05:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A89028E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:51:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 760D5140AE3
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:51:05 +0000 (UTC)
X-FDA: 84068978490.17.8EC073B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C7EBCC0004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:51:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dMmdPgR/";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762167064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfdCds3go4L82ixxfplFFZDBtryr5cvEYFOpWlGHJRw=;
	b=0H90fKmyPDQ8X6NbYpCe4j6cm36Thu3roNYbmQoh3AzyulCFy0DE0Koz7dJa6cGGNYm/DU
	23lAKUETRYatPatplDMY6u2fzlZdej9jVx/cudsQb+RFGmtr6+HZYIqUsUG2XhsRwfkTAI
	In4LHAkQXK1BZWI8ktmZT7wSCz6F2NE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762167064; a=rsa-sha256;
	cv=none;
	b=LPDJ86klMTARBGYpPb1e3ChvQv/MQHPWSWlV7bWSgqqxerKUG7/ZH4F7HMiIGPCbCW100f
	INc34eADzlLwJmpSeRkFSIE1QhXqW6bGyoBTbbx4v1rSEiE04fqQiSpjSFpqDFigdCboMx
	bblYA0hD/yvEITHEvsa2U4ge94DHTcE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dMmdPgR/";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 941E040A86;
	Mon,  3 Nov 2025 10:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3098C4CEE7;
	Mon,  3 Nov 2025 10:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762167062;
	bh=VQ4hXNs7+ujjrEuM6okI3GtAUk8U1jbFJcLICEJAusg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dMmdPgR/Ennl/LxZY9JqJ+rdcdE5xbtl2DS6YCfkT8tjg2C4Ok941GA3a0aGjjcbh
	 N+VphgG9Mxrc/rwY9hDkjQyGMzokqLs2VkZpM811GklFiDmbuNyU/kx4IyYR4eQ6J4
	 LYYuHJzAEuB/b9dp2zy3oLn35WeqIp2x8dQv1mg9ylraTpLP1Ncd6KNEOugD2aZg6d
	 J7IOaVx49e5JS8rzKGoQ+bfFg7G0KZ5tWzMM2lCcQC4hMefqksB4zyYyXewfMGG/sH
	 sf8iVfIkNndfACRLGLkcklSZ9SSPDp5SoTikAG2yQ/gnB6LeuVhTDfy3sIEh3BNm3K
	 i5hySTuH4tUXA==
Date: Mon, 3 Nov 2025 12:50:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"song@kernel.org" <song@kernel.org>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
	"tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from
 direct map
Message-ID: <aQiJAfO8wiVPko_N@kernel.org>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-2-roypat@amazon.co.uk>
 <DDWOP8GKHESP.2EOY2HGM9RXHU@google.com>
 <aQXVNuBwEIRBtOc0@kernel.org>
 <DDYZRG8A99D1.2MYZVGBKJNHJW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDYZRG8A99D1.2MYZVGBKJNHJW@google.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: p5idm1486uxdp8q58678swi6yf6bbnu6
X-Rspam-User: 
X-Rspamd-Queue-Id: C7EBCC0004
X-HE-Tag: 1762167063-749443
X-HE-Meta: U2FsdGVkX1/hABUBDdB2bq9waOX6aTB79wqEXHf/bmMferkQ7q7UVHQBmJrRydCuF46MGS7qSuMI57a45TnLdcH5JJUnvQfmPGRPsGK1YnCcFK5KXJjiC4B4H+IxyUC7ms++qh3CMfD0VKH6VjcaA4fjEny8X7uP48+B6fjzQ6nxPvWBDpMVw3POrOVs4vGkz0eRtygKTuw1xtHvJtRtZQtqL39TW3UYgMOz0wvDjmc9gWM/KsQajbiOtmJXNgTeddw8grVX0KSUbrzwiDHP7sDeit6oXrmd8WmCR6s5yjBLYDLrBMG826KFlPJfniK/WWWfLKsJeRDtUsuzxFlJiEYDuiER7eig/0Zps2E+tKxFVBQcLT6LdxHlN9o99gAAINFhcrWmRiEmhltxHz6D2+bKrsRO+Y0N8LJDzY9qwI1dhJmFSFZxQpoosHQw/R/hNsuCoS0idHrwSomXm55/KWSPJkDMz2XqLyDEUcPQfqTCUwkCBhQIFeDDrbSkhMadh9N2EOVdaa3QblMAPqNd6c/arz6bZNcXF9K535u1EoPvatCCxdNzDaPQPCCM6W7uHvZ+016WStI9JLCc6KUS3eeSP7oeUnZYSSgJiIsw0e2bKHsaugVhZKO6wME025JI0VAZyBYpEgzU/RY14q6/9QCdsBEj6rY7UTEVzy1GuF5vdWzZaYhCTWoEeQgRM0S7spNwu/JrMpURtwjXmNCZCsdkUnm/Uv2vYugSlHaDhGrVX+GjyghWQOQsqWNgmWNf/+3PdQTl4jxx/rCi+88GexhvXAfCsNkDDlIqTtEozWyMTTnpWvG+aJDqUdMvlo6Iw3hZGzdPxUPXSuq+f688onCsjW8Jq6DoL419/bjtRdD813E00wQi4RkaJcgDvGrzNTBD5i2fvzcNHIbXkrmU5F2lBqE+kQuThvuBLjy89o4c9PeI7IEsYPD0a0nBiN+oRrLyMByrk2yBmEajAfO
 UcNLfZad
 6/hNGK72SQt1KvKMAvAtozdvYQNXrYiVsUc8mJaio1vs0o4jK8pL6kt4tpq8ZCJANmTlpTyHTr6mfJHaWO8400IyoPYDLUWJbkTl/GJHCMr1Lz2crn+pIT9julZYnIqFNcCvPeya5Fbtd7FQaC6olBOYVTN0UBOTR61I03Y0rvrrWjmLFlRrYhrY0RqJ0g07+FH0Pl0M54vyUiUxPF9OcZKygH3DUfy7Miz7xCIj7ODzTqNE/bHM6oREoIgK/3FdjKzz5cFYgSg+QgV495z1in8RdPsJ/bEfXizI7UFc0QKJLMvbcUOsKta39FyYgUW8sw1r74UaSQS5ZLaLhqjhJo3CszIP+aP/eDjm1O68Aamuc2unGygANFrZvGVpytb2aYtaaEH/Q3kvteZatdh2ZunHVhykVQze/RVfy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 10:35:38AM +0000, Brendan Jackman wrote:
> On Sat Nov 1, 2025 at 9:39 AM UTC, Mike Rapoport wrote:
> > On Fri, Oct 31, 2025 at 05:30:12PM +0000, Brendan Jackman wrote:
> >> On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
> >> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >> > index 1d0585616aa3..73a15cade54a 100644
> >> > --- a/include/linux/kvm_host.h
> >> > +++ b/include/linux/kvm_host.h
> >> > @@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> >> >  bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
> >> >  #endif
> >> >  
> >> > +#ifdef CONFIG_KVM_GUEST_MEMFD
> >> > +#ifndef kvm_arch_gmem_supports_no_direct_map
> >> > +#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map
> >> > +#endif
> >> > +#endif /* CONFIG_KVM_GUEST_MEMFD */
> >> 
> >> The test robot seems happy so I think I'm probably mistaken here, but
> >> AFAICS can_set_direct_map only exists when ARCH_HAS_SET_DIRECT_MAP,
> >> which powerpc doesn't set.
> >
> > We have stubs returning 0 for architectures that don't have
> > ARCH_HAS_SET_DIRECT_MAP.
> 
> I can't see any such stub for can_set_direct_map() specifically?

include/linux/set_memory.h:

#ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP
static inline int set_direct_map_invalid_noflush(struct page *page)
{
	return 0;
}
static inline int set_direct_map_default_noflush(struct page *page)
{
	return 0;
}

static inline int set_direct_map_valid_noflush(struct page *page,
					       unsigned nr, bool valid)
{
	return 0;
}

static inline bool kernel_page_present(struct page *page)
{
	return true;
}
#else /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
/*
 * Some architectures, e.g. ARM64 can disable direct map modifications at
 * boot time. Let them overrive this query.
 */
#ifndef can_set_direct_map
static inline bool can_set_direct_map(void)
{
	return true;
}
#define can_set_direct_map can_set_direct_map
#endif
#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */

 
> (But again, the bot seems happy, so I still suspect I'm wrong somehow or
> other).

-- 
Sincerely yours,
Mike.

