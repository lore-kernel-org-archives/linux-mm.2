Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33BF9C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E246B008A; Thu, 10 Sep 2026 19:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F786B008C; Thu, 10 Sep 2026 19:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44A66B0092; Thu, 10 Sep 2026 19:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77EB16B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:24:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D3A5A063A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:24:15 +0000 (UTC)
X-FDA: 85199433270.13.04E6F69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B786FA0005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:24:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZKVlkcho;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789082653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28p549CSsOmgPJIFzIZAmk2dWOo7LjPPNJpI2Q0OCPU=;
	b=04736PS1KvlLzifAN6ox4x+LHxLLnmlG3tivLTxpNUz5/XfRtcPzqxz6sgDmpvHadTGZKE
	SEK9Q4MeuJMTTrO8GneziunoKeyodwT3m+VvR1oMcmj6BJyOv5XELcn70UWVaLWuCUaf3/
	zhYYs6/SPmEhui6FjY3s1AIs7adFosg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789082653;
	b=FxIGL6hATYhKGPsde+Nafm1BFluydMl5b8S9MZVV+xVMtE9KroC5XCrzVsM4HtayqWjBLV
	ErD4KmKruLXBj4YIwJQxE3/k/ef+TNSTzR+E2PdBU8Ai8n8Rf4ETFnXSylqyjiU7S0JSy4
	Dn6xhX34Fp4w89iWUTfG9ohi7nmAy5M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZKVlkcho;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0808A601F0;
	Thu, 10 Sep 2026 23:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1111F000FF;
	Thu, 10 Sep 2026 23:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789082652;
	bh=28p549CSsOmgPJIFzIZAmk2dWOo7LjPPNJpI2Q0OCPU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZKVlkcho0tV1KE1J0zSWwoIRXEVkCT7QdQFEPdd3bQmJJgFLSscp1f0wnihKx3Yjx
	 DuLouAg5JFHdkRyPThEwMxNAoYI5aDCdBTHwWBSft6ydFat/H4WV/KYH6aDZx95I85
	 a0DOVqkrCodo9TycG66iw+z58DPwj5AZPKqxEgKQ=
Date: Thu, 10 Sep 2026 16:24:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Houghton <jthoughton@google.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 liam@infradead.org, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com,
 hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
Message-Id: <20260910162411.d3bd211927c10e049c6652b8@linux-foundation.org>
In-Reply-To: <20260910023411.514987-1-jthoughton@google.com>
References: <20260910023411.514987-1-jthoughton@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: esrnezfk87ptqha48gziybscjf4e6szy
X-Rspamd-Queue-Id: B786FA0005
X-HE-Tag: 1789082653-933089
X-HE-Meta: U2FsdGVkX19HA6U0ZaEMGkhO5JuU96h2nX735BHvpsaB3KN7HuikPaC7wci6IWrcecguoeTFR1rZWoPcGoSAgi94iACQJsm4hSvFZ2Emnx4mWhI1bYhK4uO8ix7rFGoYTFHeeInLu5WyxoAee+nELX7xX9zvN3ZN9FGwJkcTO59iZ28gyfLNdLQADYK4r03Vp3AWTR95L8AHaEmzm1imEAHdaWbLWEfyFf84p2taq9tqoG2gtJR2vzCbNTlY4D4lMrnwwfCISnJ4qT0GK/Nmf4dR8Z9xSL44FUI2walDCU4WXGUqwBAZyRMG0Nk2vNlALtxVvqk+tLZu0+EuKV9hy6HnZGnFxaN1+Q2kG3bL6n5XGka87AGtijxLNCZRFFi7aiNd7k3G2iqrbyyyX3GR+jFHemVxTYa2vfMeYrRWFt5mk82hQ86oa3W0p7n62h+xh27uZX7Shv9qRIaunc/F6fJ3DuxkKGHpuwulqkTzGN+WG5qp+1BiSAVeWL0uZ0nRyoiOX53bGKJmxxrnjxnYR/WZOGgPF6C8ip+X9lkKJbKEbiBqg9wpTqlO0qvdW73ow36dhMnvYnWoRsGiwZZu7KyStkswhAU1XsNbff1vXWQW5dzwcnCZ+jTQm8v/jSHpLhnmnTBvp5WzuhC+AjBubc1tlNJ8Fml0SzwOuOXCb4Mw+c7iL0MKDLiy4ngrwSQ2f4jn8bT9nR34sDZoyGKNhN2k7KSQSNpdRiZNOmZUwuoStFx7CgUKj5E9HUCD54JI+TXnVaNBjIRHip0ftX5GxzkZ5RL9nLXL3CEh80EdsCj2sxtbsa4CiJu3ZQpkBAVk1jKPIhO8IKGicgwbSzoeB7RXuPUcaFEM+pNUDOJeDCdySFRz6vetcZZtORFNY6dBQCmFUVfKonyM2LF7dT2TzIjwyggcPqPLrgobfz9vcytmD2Fyl+IFDT21tN8uOjGMfUy6q0lNJP63GpyxA8R
 sZiX/amn
 +BKjMqPS4Ck++33q4p4U5TVYuLKZnxZ+IdWA123A2W7u0au+lV4igWJlTXOLz5SHe4jIqdX8O9dkFyUp7+yhts1+fj99IByiS/5fzhE51I5GQmB1mm3gyKhuNzaRRiu7EJZp/oj+KNcrFUUWONatTNDN81nqJt9eKUywD8twz5jrdvyCAKuqeE+9F09vAz5Ajvg6k4HiXbZlSAJE2z5ZoF3pg4Yv23RkA5F4CZRgqR7Qv3Jg42S/VLA2vDOW3mS/LNk44siUk1XRZbRIBZ4HHbdmiuxHeV5z+yrFZfboVD14sHy74rrjpPfj1LNiUdrz3U1W8CUhZttbJtNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 02:34:10 +0000 James Houghton <jthoughton@google.com> wrote:

> Userfaultfd minor faults provides userspace with the ability to manually
> install PTEs with UFFDIO_CONTINUE. Right now, MADV_COLLAPSE can map
> holes in the VMA when a naturally-aligned THP is present. This is not
> true for khugepaged collapse: the PTEs will be retracted, but a PMD will
> not be installed.
> 
> When MADV_COLLAPSE installs a PMD that mapped holes in the VMA,
> userspace is likely to expect UFFDIO_CONTINUE to succeed on the
> should-be holes. UFFDIO_CONTINUE will fail and return EEXIST.
> 
> This is not inherently a problem, as MADV_COLLAPSE is an explicit
> userspace action. But, especially because MADV_COLLAPSE can be invoked
> by an external process via process_madvise(), a rogue caller could break
> a userfaultfd-minor resolver thread. If khugepaged is later updated to
> install PMDs for khugepaged collapsing, that would be a genuine problem.
> 
> Userspace cannot generally use MADV_COLLAPSE to resolve userfault minor
> faults, as MADV_COLLAPSE will only resolve such faults if a
> naturally-aligned THP is present.
> 
> The naturally-aligned THP case is the only case where this quirk exists.
> Collapsing otherwise requires all PTEs to be present for
> userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
> correct. This check is essentially bypassed for naturally-aligned THPs.
> 
> ...
>
>  - Drop cc:stable and update the changelog for the main patch.
>    khugepaged doesn't actually install PMDs, so it is impossible for the
>    kernel to silently install mappings that userspace didn't ask for.
>    Therefore this patch does not need to be backported.

Thanks for explaining that.  It helps.  My life :(

Sashiko had a stupid niggle about the selftest change and made quite
disturbing claims about the existing try_collapse_pte_mapped_thp() code:

	https://sashiko.dev/#/patchset/20260910023411.514987-1-jthoughton@google.com

I'll queue the series for test-n-review.

