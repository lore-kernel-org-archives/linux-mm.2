Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DE6606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kWzwXqD3
Received: by kanga.kvack.org (Postfix)
	id 95E796B05B4; Tue, 17 Nov 2026 16:28:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935A76B05B6; Tue, 17 Nov 2026 16:28:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BFF6B05B7; Tue, 17 Nov 2026 16:28:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56F396B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:28:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE95F1C3801
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:28:28 +0000 (UTC)
X-FDA: 85445899896.09.5B4AB45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3DFB0C0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:28:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kWzwXqD3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NaS7S2i9wbUWkDygLxultNfv//P9X5dElhkF+EFEXrU=;
	b=lany+57eQB72KdggA0SEO41V4wlbf1DDncVRIpBQZGWqxwvqb2FbOmVUKqIDFCbsub+SdY
	8TK8m9xMJXrNPMRpDYaLHY8SijbRF12xeExw8E0ivMgP2hj2L9GUlDbrB6FFOwxiHyoa2d
	zPG69qDPiyF4Gs2JTCT8u/VqJAoRsa8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kWzwXqD3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950907;
	b=WcRBfZF9Y6AXuUC26WER2DJW66FuRUqZIjUddCUl+vhU1jpSFNCiqKV9Y7k8KjV+7+eMA1
	X+C5CLC0a6z6qrZeslO0/ktyhO7XbMYEKTOgTSFNudzWAKH3in6jPsLaD8Y8JPpJ+S9nYQ
	iJH5D7frAACgPGEx1FDIUyPA9iwNpuA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5647F6123D;
	Tue, 17 Nov 2026 21:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00231F000C4;
	Tue, 17 Nov 2026 21:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950906;
	bh=NaS7S2i9wbUWkDygLxultNfv//P9X5dElhkF+EFEXrU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kWzwXqD3Eo62UyU5LJneyqs/4BiqrMP5vyVJIJ90uwA8QOaivNCxESFkelLVHu0BI
	 KD/cKPSJs4oMOOa10DbX0THHD6BDDsKCxCk3O95Av7J7C0bwuNWYjtWXorIJUP7Fhu
	 geVlCztMmGiU3VGO1EpxEeST59BuABXizwbyvIH1LzmhbnPNKVEjMCKOKMajv6s2uQ
	 i6C24B0fSZFEhVyhqSf9kcnISPCdNNnzusGVxEWPTujoN7kwxz3hyc57ztbSUi4Q0E
	 tAO/i2ZgcahbiX38cARQsUy4S72jjIFnwxDQbjXIqHZkNiIeX2ifT1qO6cvKzUXabP
	 QcwE8bcZ4sMlA==
Message-ID: <87a81131-5d3f-45e3-8c7a-ecb46d271ed1@kernel.org>
Date: Tue, 17 Nov 2026 22:28:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm/memory: do not report OOM if insert_pfn() races
 a huge fault
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
 <20261117-huge-pfnmap-fault-races-v2-3-276007e73bcb@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-3-276007e73bcb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3DFB0C0003
X-Rspam-User: 
X-Stat-Signature: hunqma6shrch4r3p5zrqongde5kqmpja
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794950907-181138
X-HE-Meta: U2FsdGVkX1+CkcvXz5fdweS3OXxUcsWIz2GqqVqkz0MJ0hJGLTJmbb5bxhGPwm3SxOsT6BYk5u0uS9WMJomLd1TXDJ/c7r+UEmQg32I6TMGa8w+uQvOEjAQZvHACJwux424b4O/2s+nIBKoPVmeDwKARLMjZ6ww/QPQJ6cVVuRsw8/QUuEPq6XJfzKnmR+A09lkfzT5YjZMxT/IDLCGokHtauggLqQ4LoACZHEFHq3FeN8QLIRbJjKWc8KCITr8TGMRYal2IcVIy9fPMQBff3JbmaqaCaQANclM/bv/0Avs9JjfgjdoIjpHisAvyeZKUkycBux1DuQLftqweeRxxDt1qpgTPFyNbEnBLXUHvNXsiyAsE00AzATn0eIlC7RZK0yLOAa9LBrNJ9fwFzeEkyHawtduAYmXynZ3Pplc6LhqZx2oj3sBT+7dr/IF30AS3XckQrBIS1zp1SVnAGYT5V3NwAtOuSL39DGOvtc3OzFBt2Y+eZayLE8bsZ9q3TMN0iePYVQiPvJNq5ZBGXjQgycQYjYC8A6YB61jVYkIpXMWAMGeJ+qHKUsM9c65XBnX0ozwEP5PazPYRhevPYytXAeSewkUtNbc8MPyAtU6PgTvg6O5LeCaVt//OT0sHAZwhZyeDgoot5dWZRUbvNBcwHamGmQi3/hq6QX5y4RkcdaqRBAGUqzYdvF4bHruz0E1jeqc9C3SRJa94EeGTFjGFjoytLZfcHFT4QTXDj0/5fDIS2T/x20YY3RoCUyKjmzjDVSF4WkTamkNu+3uadEvzORthM/lXg+vb3Hm1wxRmc7lVyMa3Y8VAqhM87QwxulztvnhMzyx3C5STkDr7NnvvzjA0tgQGoAp+LoDS7/C1b87aG8Q7F7p9EU5WR2TUqALBPIqDXa6dIkEY/KBwRK4jG7Xi5RiYKHuEKUmtdvwDFXLc2dqpMrl69QuGqW+YrK0Vb17DFw5rFgD1eaxYxzA
 s/EZ5fPD
 Zs3J/pZ4jd9r5F2UO7dOjWnrATAKbO+3g3mWsJlSWFw8dI77VRH8BCjog24mufgvz9kB57AX+x5JwzBpGPM4s5LK6NJsmwWqReOycHL6TRStS4GH0hD+5uIvi/I7Ern7P2o7sp3N6UizBH5iF/UvBne3yorQJHs6Yb5d4uQPZ2nZiIGOeeXpKgUN3hjuFLnBoWU7I4bj7sZ+7Ox27mf256CBASoRZrI3quIf5nnIIxzer7UvazxFAE4XKX23JFz/fR2N9TCirWTQAbv3Gyx4bP+2TyxmuhvzFML1t0yd5NZwYUiK2pVkRSngGyrH4fZqIa50fItNGlPMqgrmRgrKUfZt6FfAfWXzeS0ZYsBz5S0158ZEo4wxaAc8tfQZhcvt/3MtS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 19:31, Lorenzo Stoakes (ARM) wrote:
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> This is not currently safely handled by insert_pfn(), however, which
> obtains its PTE entry via get_locked_pte(), and treats a NULL return value
> as an allocation failure, returning VM_FAULT_OOM.
> 
> The issue is that get_locked_pte() also returns NULL if the PMD entry is
> not a page table which can happen if a concurrent huge fault installs a
> huge PMD entry between __handle_mm_fault() observing the PMD entry to be
> empty and insert_pfn() being invoked.
> 
> This can result in VM_FAULT_OOM being reported incorrectly.
> 
> Fix this by introducing and using __get_locked_pte() which returns -ENOMEM
> if a page table allocation fails or -EFAULT if raced.
> 
> This allows insert_pfn() to return VM_FAULT_OOM only when an allocation
> fails and VM_FAULT_NOPAGE otherwise so the fault is retried.
> 
> The same change is applied to insert_page(), which only impacts DAX (which
> has its own locking).
> 
> This means that insert_page() now propagates the returned error, so -EFAULT
> in the case of a race. It's not possible currently, but guards against that
> changing in future.
> 
> Similarly, update walk_to_pmd() to return -EFAULT if it encounters a huge
> PUD leaf.
> 
> Target the commit introducing the first driver able to do this.
> 
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/memory.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 40 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 20b818bcdfbc..04a518d6059f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2383,19 +2383,48 @@ static int walk_to_pmd(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
>  	pmd = pmd_alloc(mm, pud, addr);
>  	if (!pmd)
>  		return -ENOMEM;
> +	/* We may have raced a huge PUD fault. */
> +	if (pud_trans_unstable(pud))
> +		return -EFAULT;
>  
>  	*pmdp = pmd;
>  	return 0;
>  }

[...]

> + */
> +static int __get_locked_pte(struct mm_struct *mm, unsigned long addr,
> +			    pte_t **ptep, spinlock_t **ptl)

I'd fix that up when applying :)

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

