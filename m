Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF3CBFED3CD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09AB86B0099; Fri, 24 Apr 2026 09:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B906B009E; Fri, 24 Apr 2026 09:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C8D6B009F; Fri, 24 Apr 2026 09:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D07B56B0099
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:50:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60EE3888FB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:50:13 +0000 (UTC)
X-FDA: 84693583506.08.2933665
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3DFAC100006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:50:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=foOAimJC;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777038611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJIUxE0EMd9xDkjHBF8cRMOtvBKxTEOb+UCxFAxIG5k=;
	b=JtddwMLNclyvT78UF+lK0nBMtiFJHjTGwHC6UoDKvS/swmWdOA5RtaLcikit1hBbeScYon
	PqJZwcfyePiTZ7jspmc4MLdKUboEjotTjQUa/5IBI/qkMsALmPoMRwfn8d4NFiYNNM3pT4
	Yqb+XjRBdVG4G0Agd6L0Wt4e90dfWLM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=foOAimJC;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777038611; a=rsa-sha256;
	cv=none;
	b=XDRQWp1q4P7ejMWizJ3tcmU0EIzr3PB3rdmq87ztv3hACYfb9qds92q2rr1ICy2rNsSdy0
	boXjLHDLac1F/DrucbqjOeb8cmOmAjByxtd1EfIxzJXcLqnpfhvUMIsz+RkXPygfMBK1k9
	CeU66CDOK+6cDe6aJBfCLtulDLMZxRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 391CF4038A;
	Fri, 24 Apr 2026 13:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773ABC19425;
	Fri, 24 Apr 2026 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777038610;
	bh=MGl0j903w+i9Y389Y47daupOrHc4r/683a0T3qETTzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=foOAimJCsCw6yktvneSSk02PdxdoSF2WhhGvPLNs2HPUVBNxJBdoSL0QPUXTJ0yT4
	 kcHqG9Qt7AsNhAGcZJtAbAYvWtZbJL6iCQAoOr/5udi86INe1cQJphWTsENK6TRg6i
	 1niOCdLjbHNaYim/DUOHJjPIJvd8jzEOQaa08t5QohfL9IWiwMfHH7cev0XGxCl5Oe
	 f1J+cmLCCpdDOIbEGt8zzAlnQBiMawXx4cwgMAPVlFUb4GZikcZnka0Wc9WBRzcJ6h
	 yE7xB8jkyglV/08h8g40aNo58acSjYbjKtljAhcMFOmF1yJkLo8jDXwNBYNzwQsOAv
	 sTi/WxnWlBLng==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8C6DDF4006B;
	Fri, 24 Apr 2026 09:50:08 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 24 Apr 2026 09:50:08 -0400
X-ME-Sender: <xms:EHXraZs8TgQrJtfi-987OWK12sajj_WZnOy8R_kk2xA2EL6VPJcqlg>
    <xme:EHXraRuxo8cWln6LFnBcUEZMKr-ZTx7J9ADiSJTnmQrNk3Oxvmq2KK-_ZkTnz7Ltn
    e3iLT65h7a0XtFd-Ef2hSRBLhTaVxXqJGN_dnbi6Ui7BYCpbzmxcA4>
X-ME-Received: <xmr:EHXraY8_Ff9Dmtnl3SBFgcWwa6lz55F5_UBfMroQz3cZN5Gbonh_KO8__RKOBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejtddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeuieejieffkeehfeffffdtkeelfeelhefhfefhudehjeehvdffleeuvddufefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegurghvihgusehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhi
    ohhnrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohep
    iihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:EHXraa_C6-haqQfuooMi1XlfCBdjyfDJGPkVq4GOpwBH7vUK1yXe0Q>
    <xmx:EHXrac_K4zVVesosgupPDLE4JIA03wzpLeZ_yAyifSWUfvTH-C7tcw>
    <xmx:EHXraQFzRjFddaU1h0I0T7lon9E4JFPTR3ZO9v7Obw6XLAWvraCj3w>
    <xmx:EHXrabbj7lVFRLyqHi0rX3eVRBZwOyyplv-J3rk4ERJ6HCKWPyEWEA>
    <xmx:EHXraUPAf2pM9KxV2CpTCLIW4ooX5YE0eqGCX5hEidonSlsWBkZMUv_2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 24 Apr 2026 09:50:05 -0400 (EDT)
Date: Fri, 24 Apr 2026 14:49:58 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aetyhki-UD70dyRL@thinkstation>
References: <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <aes7b17nG0cXrtEd@thinkstation>
 <aetZUOINzfTXChLL@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aetZUOINzfTXChLL@x1.local>
X-Stat-Signature: 6ny1p9fcmdr13t85dcttsbd5cqgos3fz
X-Rspamd-Queue-Id: 3DFAC100006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777038611-428313
X-HE-Meta: U2FsdGVkX1/NVgRbEeYyuVnDYXUqiENPVCGzG7tkNAcEKpZGHn6fMSCC6DWJLrB3X9WZHg0eki7cpNHQYh8oEocnLVLAM+ahMVMnApt75VkJ9UXTDMx9JZdyTqWhMwFucwGbflnSjtrqkPU2hN7NrxvLAelUpZXUx8L/0mmJSrsky2ef12FV6POaxUVsNVRrEIT8UCUwp9H8O40ja/P9vBw4Rm4+PvCCJJfAMiuRPvODhVsBs0MOgsHbckZx6B0nZ/HjKsnVyg3KNu0vSJh/rEGJUHoenv4JypfZlHeNpOOTV7+mQOq6ZaC6uUCeG0sGjZUkqJf04Eijsx8awxzcl5hXRpdTdduueRhlw7Z5zj3AUamF9zuZgHEanM/LXZn60J4liX+NZPL1YO7wuMi70xSYjQO3JYpKXT5Uylcsnz2l4/aKJQwhcQAb4YoV1kTJJTGP3PyuegwgrO777rAPGGqFD4dUhMprUiSmNad8+mzuqAf+aSmDPN8XVV77Ae9xlGRMVDdW//5ihQbco7Y8v6/16zYhxyhhGk+rORYaC8ev6JPd6c1WRJ6ITR1xFLUKdlBss+JdZd2xEq9zDaqDBRxZkaXfXaCF3OrHilMjh1rK373vVh1BjcnesfQPQsh5QM1kwnu0E9nQYHVrzJJVGaotGlGMli44kK18Ovmq3gg9MkYp4MmswrTNatycPB2I50sYH0j2D/GtXLdUj+WXb32veNeYiQ2qyWfKesw4mT9cGSx2VHg85ILgpQUN65URG8IjG0LB+hwRhjxQM3MLgn6pnwAvNbiuzq07Mvb21pZv1M+ENyWLu8dSeSvIWokZOkKYMBt2CEBEY9QWlZFRmngeY2/GWTqZv4UcjTPUBSraSk+A9ioLvnhvptKa3K39aWcoy5ZtP4kdBwvWNlooNEq2BXog6Ukfvz7E/+NwuN6K2fEaXfaiGBaeZuWZhErNqQNHD0gtZl8k2R45qv6
 lhfa/qAb
 ZqsBBzV6SarKj/rVOECPD2QD2mAgQVFB1b571LC0+WREgnXe53FcW0VdlY5E6KtC4/SdHMM1vrls/MFKiCq9JWrhtx9oOnewIFbAO6jx/LreOM3y/WaPqJndpUTd1W7WZZA9a8KgO9IS5lz8ByVO/W1IcXSrqacnEfbuew2dLqLFCnGXfRW3PKkZ76vuJpjssN+R03sN0q3wmLibAzW+xjaBC+Ia6FhOdz7M5Ew/ozZinpY3JZupHB3n8b7SrjpshHGEi81j43YjK5y6AlbuMkXczAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 07:51:44AM -0400, Peter Xu wrote:
> On Fri, Apr 24, 2026 at 11:34:48AM +0100, Kiryl Shutsemau wrote:
> > Both page_idle and the LRUs (legacy or MGLRU) track accesses on physical
> > memory. We need visibility in the virtual address space domain.
> 
> Yes they are, but ACCESS bit isn't.

A-bit is not a reliable signal for userspace working-set tracking
because the kernel itself is a concurrent consumer. It is exactly why
page_idle needs PG_young on top of the A-bit: PG_young is the "kernel
ate the A-bit but the page was actually touched" escape hatch. And
bringing PG_young into the picture puts us right back into physical-side
tracking.

> For migration, see e.g. remove_migration_pte() has:
> 
> 		if (!softleaf_is_migration_young(entry))
> 			pte = pte_mkold(pte);

remove_migration_pte() only propagates young-at-unmap. It does not
cover the common case: A-bit cleared by reclaim before migration
started. The concurrent-consumer problem is what breaks the signal,
not the migration boundary.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

