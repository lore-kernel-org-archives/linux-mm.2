Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF3D0D10F20
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F796B0031; Wed, 26 Nov 2025 05:21:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FDA6B0032; Wed, 26 Nov 2025 05:21:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF7C6B0062; Wed, 26 Nov 2025 05:21:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D8DF6B0031
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:21:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F9504FFD0
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:21:36 +0000 (UTC)
X-FDA: 84152366592.22.1037A0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B23564000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:21:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=axZ+8RER;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764152494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e93oI2y5ZGWKoBIg0MsaHwMs0o9inlz2F6nG6Nm4DII=;
	b=EiqP5xh88II67K3VeXRgTOedSuJ7CAt4m2vst6oGT05pteQc4serCauPU9HVCaoIy0EdOI
	B3GDmCSCBWDePLC5lTm2Zc+wEYl2xkIIbSEkGC3haQ1JrsXJUiRMk/AnFjqXSyEyHyzTWW
	kREYELsE1fuIfY7DquRciZe2niM7glA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764152494; a=rsa-sha256;
	cv=none;
	b=r3biBMtEY1xAaYPUydAQPoqJTZxXlgbLW9NehUXbWU5qjPIONaxOPlf3ARpVRc4/QDTH5o
	rg4iUjZ87tnQnn71rUz/lm8yUuWhkVbdbI2m67uQH9eK9mdHvuZOhhkPpfKIMbGRMzx6sv
	9cRmqNWPpPIAGQ6ij4q/iYYv7yr/WoM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=axZ+8RER;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D150D43248;
	Wed, 26 Nov 2025 10:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C92C113D0;
	Wed, 26 Nov 2025 10:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764152493;
	bh=BcAJVj6qcG98+h3lf093r2ZIpIwJSDn8eL4opofTeJU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=axZ+8RERz4f1+HlUZSmBzSNN+DZ5wmCTdjZPn+Sn67DidzcPbG/trkh2LUzqBiNtF
	 0sFGfznqxNBm7RWh6g+IVpJmKoHoafpH8Yt7dbwq7doRbnBSKsf7N4K7+bBhL7qlOI
	 5aprOxQI8T39czEKCl0l1bC44w/FvReoiJi63qEA8zrUs1iSVcJIq01THJwLkwOHUj
	 qsTRe6tkhu39lUVNgjh1wtKAn0la7WVupbaLryeHQVLDH7dLm8ptKOkmnv2h7q2zFf
	 19T/KELXMc/RHK6snLqr+wIIhe+an8YnI+2fVfJUVgS+S9sxhF5DCjtHL7SLpE/S2K
	 CjxAmheibuLzw==
Message-ID: <ab2044e8-5d9e-4ccb-b430-dcfdd5e32e3a@kernel.org>
Date: Wed, 26 Nov 2025 11:21:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] userfaultfd, shmem: use a VMA callback to handle
 UFFDIO_CONTINUE
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251125183840.2368510-1-rppt@kernel.org>
 <20251125183840.2368510-3-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251125183840.2368510-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B23564000D
X-Stat-Signature: op1t1t4og7ka8tny9y17z3y14d4ktzey
X-HE-Tag: 1764152494-352651
X-HE-Meta: U2FsdGVkX19RxEnXkCkP3RQL78pn+n0LG6Ah8tlkDffjWf0q6LMBVbxz3g0XUHOlk3TysHW3c0tzHsWGdDfk9cvpZB1CGqLpmPXRcpD4cHBoxEOnxfmeqZfSNe4LT5WP0TByXPE25bXISGRtnGYZ338mu8WNLZQcWvPiTVAnQGqPlqJkK1FdnTLzhRnDZm1niCN910Iyf6A5uFg5olsW+PpjJpujlMmRotu9nR32L1wY5bipZCIKJKfuK7rwSxNxYNkDYUCVIhUaNiNFmQL63bua+vvsPjQtw34NqH0pe7XtBPlm8VbqeN57ALujTCmLf/eUQyC+wW2V3bCKOt3D+TyvIcT5cZq9BVN4/F5ggHZh4g28WWF6QCpT1Dab9wZeTmJPutcdFpj0IfAR+ExsBMWxg33fl8OFEwfcfnLiTQjUzIwbYSJ6vRSFDcorBVyx8jn5uePXhQ97HXdDSPP4JDwOY02+CQ7Fei2ncJkvcLbkZrfcBKBbNjdthtmHukpCU3OhoPDvQ9FftcObyQs9eX3YqrTsauCQlLUFHCyW0ZCvwQzoqiyJ39xdp7eVWVdcCfzP/3Tcp5o5CA/Rcdy8sEp1Cfr1WeOemR0dGwIw4vyMFZtVw6UQksJHLrAQGdunDT60uoiGY8WK2V6evoVKAC3eJ3rRNzfoQKiAZJ4R5kgE6kY7bXEYPAINrBM4iGYRb/2es/lA+t+OMv5XA47ZStlgYjyXIRPBvW2uVUuXpDyMJqAbDgyPl6g9yIFzTDH2cQDQWt/EIftgbu65cDnJbkJcRxxbLC0wPoo8q754p5ANaVg9WrqK0jkVyteZjHKhuA7kPtWx68pUzxnGWVSigricqumXk7o6f+08hewd3Aw7wr7A+1mF+59KkGsVg93tMkLPG37s5MQRYGrzobMTFBQHzxF18E6kenXRvAG1OFBf6POVOqtMqJWT4uQ+qtXk3qBwzxcP0a7LYHgjchS
 J8F24r5L
 /dzxh/phtJxDkSGKs8fcAmPgYUO5xX6yBkTtsE7DdcSSALSTa54SvaTLMRZPIJQH07q3QD7GQ5jy5W8d/rMYLyiZTMETJRa2CEkNhA1vh09k0snuLdx6fZZdhXtF8wX5NHqoBVJt3Wpd5dmAC3WLHRB9iDBdvjFateRF13mPKBG3QibjZmBL1L8AQx6E3+wZ5whCCZ4fnMgrELOxjq2WteMuEYnFDW6sa/NNGkABzab/AXb1pHIBVSn9m/ULighIDzwHMJTkeu3TQuT/OzxFhnS5Q7DN5bae7+MpB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 19:38, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
> it needs to get a folio that already exists in the pagecache backing
> that VMA.
> 
> Instead of using shmem_get_folio() for that, add a get_folio() method to
> 'struct vm_operations_struct' that will return a folio if it exists in
> the VMA's pagecache at given pgoff.
> 
> Implement get_folio() method for shmem and slightly refactor
> userfaultfd's mfill_atomic() and mfill_atomic_pte_continue() to support
> this new API.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

