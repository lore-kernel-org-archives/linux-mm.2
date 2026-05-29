Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0941BCD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3289A6B00C0; Fri, 29 May 2026 14:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA206B00C4; Fri, 29 May 2026 14:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF316B00C8; Fri, 29 May 2026 14:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1072A6B00C0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:44:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACAC2160D32
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:44:09 +0000 (UTC)
X-FDA: 84821332218.26.09F9382
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10718100003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:44:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BO85kgeP;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780080248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwpO+pOOZTWBchQdW/Dv7jGhsKusDPQYZ/nVee/aPKo=;
	b=MGgCkHfwXMreqMg4avQClC5lBD4MiY87wBCqtCRKAz+6DF+3x5s4h0UfDOgkPMa+vdb1Mn
	pXjApWfziw6pER1uFSi0WNoRboW7GitDNl45QvbZXagsH6ZhYroyn9RmcT+GPA6t727u1q
	6ORU9q7Z8eMe1D94WE0MIIgdzX6uVTw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BO85kgeP;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780080248; a=rsa-sha256;
	cv=none;
	b=xKYYaCDR7XrZ81BamPVuLNqo+deFJFOfL7Jkcn7aW+N/kww39ZX6qKeaPk7oLEFYxD2i8h
	8R4wygsg+IUDpQ82cGbF53bd4AiUxIEOgzIfGBRbRdrtzAjxWgvnlirnxWGATUZgtpRiZ/
	3qeBygfyNcZxBwvIaTh0hLzQ/cI9btc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C810942A85;
	Fri, 29 May 2026 18:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842341F00893;
	Fri, 29 May 2026 18:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780080246;
	bh=ZwpO+pOOZTWBchQdW/Dv7jGhsKusDPQYZ/nVee/aPKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BO85kgePRyguLqXdsSmYSPPbc2M9M1R9D7u7yNKftG8vO83z5DOcpC1hVIDZvumcT
	 QWxKTrqcHbY4mwtZyZS6Ri4wQ8M2wE5vozWmFRthBrdQTSjixI1eNMVZe401kMXp9x
	 VKQXxqMh1mY8BQveioCajwIz3qEgPD3Wz7WFV799FuuXrDcApB+DKzZxCKjOMBtPc8
	 xHIQ50diUzeyAWDTfME/K/4V9hozcFX8TbJXdud7+hlk9p/n3YoI3H2L1udoyJNVo2
	 5aUAa1AzYtzcKeTBeKIaIbwzo5WR4sOI3s9svJydmcCnk5t2Y6uhwHfkazwN33Ed9k
	 vzcg2+4l1sZBA==
Date: Fri, 29 May 2026 08:44:05 -1000
From: Tejun Heo <tj@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
	bpf <bpf@vger.kernel.org>, X86 ML <x86@kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
Message-ID: <ahnedQ33ZH8ogjbC@slm.duckdns.org>
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-3-tj@kernel.org>
 <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org>
 <DIUMP21RASZI.2VNQV45RIL209@gmail.com>
 <3901fe0537edee9d7acdfd91695ead28@kernel.org>
 <CAADnVQJ+CqAszS2sSVu7gSfA_g4oaTR+SWmLNMX3_8c=OdR7NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJ+CqAszS2sSVu7gSfA_g4oaTR+SWmLNMX3_8c=OdR7NQ@mail.gmail.com>
X-Stat-Signature: jhmg5s11fw194gaz4d119nnkghrqhf6i
X-Rspamd-Queue-Id: 10718100003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780080247-13872
X-HE-Meta: U2FsdGVkX185grNWh46LPBNShOa4vnHcf2ppUmPf5uNh8BT7eRoc7ZgpebOX/oJ5sGNBhGh5TAnNhveofUxccO9K0RWC+G1gPtI318vO4cFU6Uy5WFtlH4xCXIZAqQ/0OMd1k5kAp4wM1Ud73pE+jYRRzQ9nPwealto7i7l7eKeRfZD2e7SgQSlC6NpXh13LrbS8oPuS7dAjiR4cWripybgqi9Z6tazUTATmYFY6mVOs1dY5SJyCdM47agsxZWKXHPSary8fw/2SEMfoOZLdiV98jIlnig4bKF3Cb+k8WkztUxyCOJKcuj9HHv7Z66roPQ1ot9PPS3SHDytw1hnc75lGpo4e+9bVG7oEc8h6yx57ZQlJKLbRgZXmSCTvsVC/VAWGkcRaWuWUlFxBXYZhfSpBcax2c4h39Xl403B7PfN0Mam3RhPsZnWrdK8ll+Sq0RQBQsCAyTxyUyn1L7myrtLyR+mLYQnqKaHQud4zh/qU5d6g4k0zbzjbCK2Wvh5aNGanz9G1/ZmUrJPpNN6o4zEOsoh/iPjs6HKMm3IxKqNDNyGYBupW2+O40ACCRQH0CQjIAtj+hgW8/sMX+Raj5y9NOkVPPGg3C5LPIlQin9PsRaqcS/gJZrNQGppD69tf8AEJbcltvfs8BtfmtfuS2CgjHkiNDch3eDLt4YPWv64D4qZEW567ohQcGBSnyQdZ/UFqs+3fu0/9Ii1taqglGTJF0xRXBryaN1IKamcu5BVC05qLKqqarzRBLRAPMK5VuzS2zmYCU4y/1U9PbquV8HsxCoBKHFh1UW/E5Ev9DjsCOa96ei+zpoC/q+e3+a1Q5p0cLT8uU6GVA7CUPPipXquqew/I6ZA8mlZAg6bzdSL2pMe3pmuuKXsbCC+VofNvhxzzgRjwR/CBZoPDxWJ4xcmWGN7x1BqeSDc70/ThDdTJwsL3RXn+SEbC4/6+eukkDsCKljNXAMCmJT1MQU3
 c0sjl0Vm
 eu/rgHpkrsA2JgtBlnVX1n1sBEEON3a6hnYLNRBmSEayhLGQSJs8fnfAyHg7t6HYspXKWvWcLE1OMDPNaQtsml47MzlbciUnzA6amtEBaJ4D5Lbrq3ydjlXmsO/haQxDlP71ownC4tvsDmvNP7AGe8HbBSASeYHGafmxDeVLZIwgkx+tumn4HAtXy4cocgvjJi/gnxhyDvqEZA+3fnpnvKSNpTLjP4sReoS9Ap9ZV4KIrcuGzJkbEStUPQIjw5CgVHc0dpqthUvFjceKewyRkBvijFsTcqG/+ry4M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, May 29, 2026 at 11:38:21AM -0700, Alexei Starovoitov wrote:
...
> > 1. The racing write. set_pte_at() and the scratch installer's
> > ptep_try_set() hit the same PTE with no common lock. On x86-64 and arm64
> > set_pte_at() is a single atomic store, so it can't tear against the
> > cmpxchg, but a plain store racing a cmpxchg isn't atomic in general.
> > David, is that the worry - an arch where set_pte_at() is split and could
> > tear - or something else?
> >
> > 2. The SEGV. It's a BPF program failure propagating out as a SEGV. Maybe
> > not ideal, but as long as we surface the BPF error properly, it doesn't
> > necessarily seem broken to me.
> 
> returning EBUSY because apply_range_set_cb() hit scratch page
> is SEGV out of arena_vm_fault() and arguably ok-ish,
> but bpf_arena_alloc_pages() returning NULL because scratch page
> was in the range just sucks.
> Earlier bpf prog passed the wrong arena addr to kfunc and triggered
> that scratch page. It broke the contract and kept the pieces,
> so ok-ish too, but overwriting scratch page with proper page
> during bpf_arena_alloc_pages() is imo much better behavior.
> That scratch page will cause all future bpf_arena_alloc_pages() fail as well.
> Hence I prefer that check removed.

Yeah, let's do that. David, would that be enough? Or are you still concerned
about set_pte_at() competing with ptep_try_set()?

Thanks.

-- 
tejun

