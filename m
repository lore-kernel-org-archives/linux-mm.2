Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E62C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 21:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 344B78E0084; Mon, 25 Aug 2025 17:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3FE8E0038; Mon, 25 Aug 2025 17:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC438E0084; Mon, 25 Aug 2025 17:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034888E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:37:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6607C0541
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:37:26 +0000 (UTC)
X-FDA: 83816591292.30.76A47BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16CDC140004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:37:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cHK0J2XK;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756157845; a=rsa-sha256;
	cv=none;
	b=4gU13StwJbtJ2z08DpaLSeilBv1wjV007aVzYwD4Aeu2SwGFX8tONyBVrQ0q6nRFTeKlEH
	Mcn3vweWsQmxnC+thj1/tHLgXZnYMGHtMbDoQPifZ4m9SRwvAfeqaeu0de2+eTsKrbQR0q
	WOCJn5h8tBTa+92Psw2T/9VJ9P3uCBo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cHK0J2XK;
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756157845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SodRd8/l8bZXSul9LRhyWd7CWue1H3vk6/6DPpbt56E=;
	b=Led8SHVQ59KHdMD4YaKAPH3bO7ryd1ks90Kqfi8Uux15zxwjT+HP3ofHMAJW8boCKLF6tt
	ZBjpwMW2Gf6cZhouRPsCyF1JsJFgNQmX92RN+dm0bJbR1uiluVtmAG6BMTyUWU1NDseRqu
	bmuXEmXPyR9hlirAL8t3lPC469AKcx4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6D49406ED;
	Mon, 25 Aug 2025 21:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 567C9C113D0;
	Mon, 25 Aug 2025 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756157832;
	bh=R44bcAauESCYgLUnJio9oy6n01PzJ9gIprVhrTrJHrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cHK0J2XKD7O53HrO4WZ8mbIIVXn1J5qjjnP+8NSiRBKE3qlSqot7fO4LiyDmh3qgE
	 994EaQi3GxaYUTiVcTdNq2CGuy4qPwf/BZ6vvOP7yQ30A6KQwyOxLpJ4d9L/7pKqbH
	 63qLEryMSPxlPH2YhbRhXt0pRoKURT7ELLjHiKpyDkSL4+J1AcoW5Sk8qXCImM2+ak
	 p+lYv9xx85LoSuSqFv4ayEsXAVqjvuHqIqMi44uUedVEGuxxRKPPODQHHSRnAgIdh6
	 6clMMLqdhTofD9UT8HCFqf2Jy7NMLg5RmykPuzN+FoKKgILHRb4q6/nyDxdavQQRRP
	 2Gu14gyBVu0BQ==
Date: Mon, 25 Aug 2025 14:37:11 -0700
From: Kees Cook <kees@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: update core kernel code to use vm_flags_t
 consistently
Message-ID: <202508251436.762035B@keescook>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <d1588e7bb96d1ea3fe7b9df2c699d5b4592d901d.1750274467.git.lorenzo.stoakes@oracle.com>
 <aIgSpAnU8EaIcqd9@hyeyoo>
 <73764aaa-2186-4c8e-8523-55705018d842@lucifer.local>
 <aIkVRTouPqhcxOes@pc636>
 <69860c97-8a76-4ce5-b1d6-9d7c8370d9cd@lucifer.local>
 <aJCRXVP-ZFEPtl1Y@pc636>
 <aJHQ9XCLtibFjt93@kernel.org>
 <aJItxJNfn8B2JBbn@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJItxJNfn8B2JBbn@pc636>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16CDC140004
X-Stat-Signature: isgzkzanqkzt3hjrkmqpmfqqxcka1r7h
X-Rspam-User: 
X-HE-Tag: 1756157844-221114
X-HE-Meta: U2FsdGVkX1/y6dyzAezs4Y+Q7jmWJI+E14UmMeVXo5+K4f4DNzs56627TlMo4UJjckLpv6T1HxOY68Vt/J8J5MYgm5YRoGEoGmuRfJ48QqGGgAs48DesGZQCXRPsatsHEG7ByHRKECNXyc6VELHT6DQlsgyMidatjjvJw35LZ80QuwRBKaic8+NOYNIgrX7bn6hN2pqOHYUt9hjQ83toqWJcOKOVVDkuj3M8peGUY9eXs6kJgfsqE0fgXlqd7Yk13ysw3+Nl242mnBrN5WQnYQ+/vWP71Co2r0Crw3MZq/K9JXksflx4NvHvDDW4gjkQkzyR5mg4Z8mJJucB5/C1wJByHSevNcQYFQ/CCJqYB4I2oUcUScyxCRMKQuPp8SYn+5G9G7KSFJQEEkNvwrkzuwXYorZTETZ0kuwrtPJP0sd6UVXuC/U/pM2IOR/lVW9hTG0xFIu3Dx2UQ3zf4zxcJiZepMkLYAcam0MSJu82Z+DmUPCyOrNpuaaWmVvUUGoooDrtOQbOKh9uI0MyUo5kuEzkSpRaCegKFM8lj3M1xBwzewABBiBuYT2OErGJWWUO6RuYrIrOMWY2M4seN5ODdU5gWavNKk547dsCC/H/GYiaY/hkXze8mRHDup5M/oRv52zdgQppo/FqL1x0ul7xgMp7VYIhPxTrtdV6st1qgnnM0KPkm+NH6ZhB6qrny0UwHCzJ9Y6Qoh9V4uIlrx/PYo1r6Lu3/5QLGz/32sTRwZTH0E2MgAksA1e6FQPUgW8yqBwyqsy6TW8J8iaFhRwvZ1guTDf+tS3DRcWyYdy3aKddHoJ+1awtFY/yp7Mribdq5b3KeGMW7EgmsDrLjEHgoHYnY8Duf4HoI7tiezHTx3Zm5nerDO4v330eWMNOpLp5bJyauBVcZJw5JxMEc6UDBbCJVjBJpyqmAN+eRT2ziffhbGAmG+xEPdVD/B3nX4Nl1Ivi6xNyTDPE+w0Dxy9
 TJ9AfYx6
 02gcG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 06:13:56PM +0200, Uladzislau Rezki wrote:
> I agree. Also it can be even moved under vmalloc.c. There is only one
> user which needs it globally, it is usercopy.c. It uses find_vmap_area()
> which is wrong. See:
> 
> <snip>
> 	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
> 		struct vmap_area *area = find_vmap_area(addr);
> 
> 		if (!area)
> 			usercopy_abort("vmalloc", "no area", to_user, 0, n);
> 
> 		if (n > area->va_end - addr) {
> 			offset = addr - area->va_start;
> 			usercopy_abort("vmalloc", NULL, to_user, offset, n);
> 		}
> 		return;
> 	}
> <snip>
> 
> we can add a function which just assign va_start, va_end as input
> parameters and use them in the usercopy.c. 

Yes please! I'd must rather use some exported validation routine than
having it hand-coded in usercopy.c. :)

-- 
Kees Cook

