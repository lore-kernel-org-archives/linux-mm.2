Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D8C606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zcdh2eIB
Received: by kanga.kvack.org (Postfix)
	id 6D93C6B05C3; Wed, 28 Oct 2026 10:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689DE6B05C5; Wed, 28 Oct 2026 10:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578A96B05C6; Wed, 28 Oct 2026 10:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 274B36B05C3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:17:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3FAB80CA2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:17:11 +0000 (UTC)
X-FDA: 85372237062.09.1DCE5C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5233C0014
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:17:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zcdh2eIB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793197029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjE+Uii9HdIaARV62zaMQ61CIuncPf7bH8UJ3pdaQYA=;
	b=eEHXHweRUadisjI3DWOC29ohIG7Ln0S3xTIe72IvUx9Urxglu1py4kGvs9X6wotgqxXB2a
	3i3sr8BGYVXO/jdB6KLfzCabQZgcoMkb6tIZpqSjMoaJdllrMUmgQFgkWbF0rADBQyqC3u
	8gU1J/R6a9IW8QTzZhMweSv8LnQBWRM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zcdh2eIB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793197029;
	b=haz55IC7vZejNvyAtmx3AjhSba0EKiAneMRmcelZB8mWl1yNziLcO2tIhn0yT+IRFppPVl
	2VSprDdXA46D0IACEyFLLpnTQY0TBNnFRkECCsnqVZnwAWfMsT2JDGe5/sZ9v23/OG1hdW
	jJZeZ81+MOWsSRMLYQPoXuc6vKoJNMs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D10F342DCB;
	Wed, 28 Oct 2026 14:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A281F01828;
	Wed, 28 Oct 2026 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793197028;
	bh=KjE+Uii9HdIaARV62zaMQ61CIuncPf7bH8UJ3pdaQYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zcdh2eIBUKC4hwGul8m2X99COtLyRxU9I1tM3K8HNMrbYYnTTWhdHlgLZ8oc9hQ0E
	 hkij64PMlw2B35u30Io3tH3HsD0bNhhXsgX59QJdkIQoqrmwecSDeQzG4blmv9KCKs
	 zpbyI7gIirKXkwF2M7UlINaw/GRVFmWIbS7pSH3TIHgpDG7aJwpWbBcAaNwEJGxUg/
	 UUvr1CGfqhw8l0QXJXNBe42SvHDAw91meYdE2y4qqF/osXsIl4NB3bv5lDIrCwlYfD
	 WJwEisb3g4Fv+JB51XtPrQYsW8TA6hHI6AdqdFh3MOkHtw1CHYKUBb2HdzBgS8AyGI
	 CnOSlmOc8ymzQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id D36591980047;
	Wed, 28 Oct 2026 10:17:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 28 Oct 2026 10:17:05 -0400
X-ME-Sender: <xms:3APiarzKAOrcCYp85okUrZ2ipEC1s0_1ePxXIfY-lxyVQMiegoW3RA>
    <xme:3APialnQLfKLFrYVeEEVADA0jAmf6HH1ltvAfNtwvNPkBuO2C5Cpsma4S1o5FTtj9
    VyCwbXtl-zUXNXPceKZODaNKjyKNXXbQUbQBhiWJHMUBUfJzNv-7Mn_>
X-ME-Received: <xmr:3APiakHTaLOPvpay-J_NhtjKgcQ_ww__mVDZ3LIB3wD_2Z2fanEzh75cX_w>
X-ME-Proxy-Cause: dmFkZTFBUCDrd/5ordvcAtkU6JjR9vrPimb+UYxK8G9IVcsl+hsz6Ui5my93/MGWrjS87u
    fXqSgPXckr17WjUL+tJxx9X6tIeCr9bfJMhwSdRRpKBvQHhzUHHeuF90VW3GvmiAwMBcQx
    Rf2Yec/qkpxdmRN0gn81nfMEtgtzr9xle+Sqvm4msx4Gu47eXQusCRI+UTCHDaQLpM88Zw
    rA2KSpwrrNtwy3hNsymytz/3zQf5zrQhLIfZgGCnRsgT13HdYXLGRb5Hfufh9/xN00Sw7j
    VoUYeEMtfP62ZRJRgpiIZ1sb8H4pSmNadcRIVzTJpNxYLEIHjCh6+OIkfWTl5h6WIw54gA
    KE6JNmsl7DeQ0Kg8mW/mO/uEfAd5ourm2uLsVrQyqhxYxZW46VXJE/JyALAdTsn4tHLHQR
    9J3XB/OTW36iz9yadG/flUPik6iZcWFmEGKzsegO1g5puDzneN2xiaetmpoWF0UM5wnKqK
    MFQ06f2mDmplk9n8JKhi5ClQ5Fqm71Y2Jgt/24wpthhs2MF+1PFVTNqTJDk2AJWHnLl5y8
    ++hBW9M77S9dYUxy+BMYF15QXjLxOsg3nNoK+b02p8kN9M/KDQpW6b5xHKMmV9hna2Qdc4
    F2kZ6V+Uw0HniFG7WD/kBET6ZxUz0YZm4Xr7zmI/BK6THBFe4X3S7pitIvXA
X-ME-Proxy: <xmx:3APiavvE6bgdYAFNatLpfiwUmYDHEf2Vhcf47WwzCbXrTusVjOa3qQ>
    <xmx:3APiavmbcczH63JKhRwHD1r6QjyCYmIrLFH_oanCxvKE4F4WEB5DrA>
    <xmx:3APianwxi9Dw8YGSVfLzE8GTkVg27tEhM9sqm9dz5SzZi_IXUNaZCA>
    <xmx:3APiatyMDZq22FQv9KsG6a4USfJlj0dx88WiiH47AEK5QjqspxFgHA>
    <xmx:3APiaoAX3LCP0OQaKpTMG_-mBpGkeN7sa6qxLJajKmYN5axko5dE0bEh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 10:16:59 -0400 (EDT)
Date: Wed, 28 Oct 2026 14:16:58 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <auIDteFAFYTihu4_@thinkstation>
References: <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
 <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
 <4A32F5E6-977D-4720-8723-B19AFBC08FCF@linux.dev>
 <auDkbDlgSZxqlk2G@thinkstation>
 <7cb3dd91-f518-49b6-b311-9ec807b3c63b@linux.dev>
 <20261028080635.GD2668804@noisy.programming.kicks-ass.net>
 <auHxIORufMbldrBr@thinkstation>
 <20261028133439.GK2668804@noisy.programming.kicks-ass.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028133439.GK2668804@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: A5233C0014
X-Stat-Signature: uzb1nqoj6qn8mt9g8fn8wytpkmctbe16
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793197029-92117
X-HE-Meta: U2FsdGVkX18EbwBdnqUBBV4TCp52fhELwunqmGAHWjjEGCQtY+f0oPY/CIc+yJOwSyxSPI37pUdpW0fsxzogHzEF9mQGw8lwLlNVOzStffm2K7CdFJJsyK86ZWhCAOH19MJlD/MA0tpu1b9WysqYrRa/4JHl39Ih6oykjpKQrdqzAo6IZkykohl8o1rH9Ju4VoOlbt//tKEW2+7gK6pdEEVjmVoPiTCGOl9Zj+Tk72pEiAAlzwCRzSztlDxb7d31HaDJNuod1Wiun8jONH2FYhk7ZCBvH36lfvgfNTljwaU6x6WDDJ/K+72FnTZLluvQxNjxmJH5thdszvqfDzH33gGmC3CrXhggSQGbC5a2wyNFfRf+5rRtzblt2aegK42NOS8GZ2mJSzU6t0EJAl/lEekR7L5BXCNSmH5v9jJCYowxXOkq/rv6MuP05fsPCxYVkxZFFztwRB3V5Gu6mvUiAEwwFBoPOm5QfYqApslNAdJUHKFtAlhsvdMAR0LiPc9xhpc4t8fFSqGkPIOVsKbBQVD6GIqYhowBKAQdX/3gt3vTDckHra2HH/hZ64JxkTp8KAME5KfNLL+EskmShtO/6jx0GWHzyK1319SUyru+Bg50ysk1ot6500r+EIji3wHSVAJspSWHASw7YppcxVKJHBM3GHr3/tGGHyfwBtfJ5cQwDP1zVUwPlZsQj6iUx5LHdu5vI7XlXBZTGak1WDMStUtuOpKmtzxNHVX6XXYxvjPxg2LdvG+oXGHkdYL6bJl69m5+sZH8LkSqrabdgRgbLOK6oigZYBqQ/S511N46Bwa8O8Lk5KeZB7AkjToukdpYfG2+cpVvHVSP4L6oNV7RwvBW0/O26K5GdjL5467bS6B+OyrsVYTSHA0EjQ00otvXY7kil3TdTWPPNduVxzrnzyRNE4YY0hadfFFy8Zs3KEhGqNwYeOeMKp7m0lPCOw5uc93XHA1QKe0RZ5lii+N
 FUass5/h
 npmlhJjVMmNXCtp2U9LRC/uCg9kfTGHgd+U452dCUQaCLXRQx/K0agsm0aqtpTxmORbveYwD4kx3kk4uRulOP5wI3HvfL3t5YUGXmdiWf1Otx0GcPqQSH/jVSXi5cp6GStodYZlgd+keRBI45eazxFesCYFscPU2o3K8FFZbliz1JVcIWsyhjA5Q6lUj+gsw4SBTTMk7va6DFvtf7J4yk/w7baFvWK/36+68wbgkVneRQ2rgV8yOLFCadfR36XBcrHbGzw4p6eqCRarYxQZj5h/CwUer9OCEPC4+4qSkT542aXHLducQuDeBnQ8RxsUinP8WSbhHuNJAjhu0Xddn26OlAPoCF7IyMwTkh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 02:34:39PM +0100, Peter Zijlstra wrote:
> > Only architectures with HVO matter here: x86-64, riscv and loongarch.
> > arm64 has had it disabled since 060a2c92d1b6.
> 
> Per that commit, could it be re-enabled now that its no longer marked RO?

No. The problem there is the PFN change on a live vmemmap PTE, which
needs break-before-make on arm64. Dropping RO only removes the
permission change.

James Houghton is working on it with an Access Flag trick:

https://lore.kernel.org/r/20261003002123.505555-1-jthoughton@google.com

arm64 will need the writable tail too: its atomic_fetch_add_unless() is
a CAS loop.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

