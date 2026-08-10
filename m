Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A35B4C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BFB6B008A; Mon, 10 Aug 2026 12:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D8F6B0093; Mon, 10 Aug 2026 12:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 542746B00A1; Mon, 10 Aug 2026 12:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3836B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:32:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B2E6A1C95
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:32:55 +0000 (UTC)
X-FDA: 85085903910.28.D51369C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8D01140009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:32:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhuyDLlY;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786379573;
	b=j32XpflmyTa+IcYsQlAsaKmx5TZyHKelt9f8zq04zZMZOCOD8bDZamZAq3keGrVm/hQXh+
	yYOuHNfl1Q1qWJqbLjLv3NVWrd4TJIWoZGUAgf5hfwiBArAYm4YjDsrBP0emQF+aPMHd9N
	2hN2PihbPgN4twm3Ya/ITB4vCn2QNQo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AhuyDLlY;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rk9UOpZ43Bg6UIPw6bOq+CDpdVOO/s9lEMnFfYVyJoA=;
	b=pwuWlVy7cqCx51oqqfwtF+9ufcKilHFg9hgco2BN9+WIIRVE2e3aJc31IJAuovqOgiV5C1
	jytqeDaXJ240HU+6jjeiq8Ta4REhD47tBPGhqmPKfBGdjAX9BhcFnx9rJjqPLaFt/5JGrc
	BXPsMWOuSk/sxWvF75JE0CRiDm66WKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 488DC60052;
	Mon, 10 Aug 2026 16:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991251F000E9;
	Mon, 10 Aug 2026 16:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786379572;
	bh=Rk9UOpZ43Bg6UIPw6bOq+CDpdVOO/s9lEMnFfYVyJoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AhuyDLlYFJT9hF3iINS6yz/+oWRveYHiCtkc4o/LaMcyij/2v5EDHCKGrJc6xN0Du
	 Cvz/6AcB0JJWVbIWJLX3OkLynEUIoy7bPRy34dGl68az1bKkOsB/sdVJ/qOC9EfP89
	 qeXgERuQj3dD22+1DnCRqrnxP5Tjfvr0HDGKBJzb8ABUsxVt9BvASxV9EN8IOsSFuJ
	 S4aTqDUne214774iXtfFp18qzbjRP5f26WfPYwbM9VJMTtPk1K7dE7cSi5k7aPAWA9
	 aOeo3pn/eGyr9s90N0kawTXpJ2Cp6dO+oCkCrrzMjcnd8iVCUrjyf/enoSYO6ztuAf
	 IfKvDMvY2tL7A==
Date: Mon, 10 Aug 2026 19:32:41 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <ann9Kcesyb4T9Z8b@kernel.org>
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D01140009
X-Stat-Signature: 56creija7jn1xrj4xn8oj7rpd1wp9dg6
X-Rspam-User: 
X-HE-Tag: 1786379573-643895
X-HE-Meta: U2FsdGVkX180iwLP2kTn+TmFtstdYI49a8ARFcRol1f23jj8qWBCHmdW4Rz5/RQEA/Avf3U42Jid1ewF9cZPI4esGOVRZxcNenvYm8k3oWqmZDWZLF+bsixA1+mPmwVEvs73kSjaV//D4tJK917eocqeEufITChQv7O79G/hXy4BsbYJL/t+S9C5BlBg4HpUm6Jz33OeHp+1jdF6Ej85353/3Qa8E34SFBRSnH/69yh+c5NInQUaw+Wrw4ghw0m+dQ45sCM3XkhRaiHEhmpp0Ep0v6z/k9ygOUc8nBhuGQbgsmXQVs33DAYfYe49WSvKJACzPySixfU9uyLC1K0DKUtT1k7dRaPNadxGcoJ1OsPGO7AXQFz89C0E+xb/ia0jFqxx4jGWUap8hvR9wkH1VAPHSc9xPfqzAHwGkpjj/4ZBzgNHyhQZmCTE0S7HpqeAfKMcDYMO+nuL3HGieepySlXCmHzgoMUxXNM+nbS/nCeFkeuN5SoDml+UMKcPaVJeA3wJDXtGdAfoJEiDzkL6L/Dqa8IBbpz5vz5nzsMZqcpkAmgoSdQ0HFyd9ckbNkALPbIMJg6gwygKlxxIiNbsBTQXioKVjNR45LtYA9X7WV3BfgP/10l1ksyHsV9wLKeap0NAu9dIq5ViBEQxSct2ZklhrdDcLBEkSqONvmLJVS/UZYKW0o5gGlg0AameiIX17D3P6OAB5QQ3HX1Ta9YnWKeKFEZaz5mh2XpIFHfqujG0/C5uTD/WzbK4nr7RfR6M95VpmevYQr5Ztg0Sn3b7xur2XLs+KcYkwDaIaNcIAzZrh0/m9UdScKa6AiuEumudkP4kEuz3ICkDQDitpDBgjSx2p/UWpZ5vd2i0Kd5HLOCeH3zYLMK8vAEs6RRCqOihCzh+uryrg2xDX426XsdP5X4C7urUsmMfVxBA2fiA4J7RosraMy+NaMC7P416iVI/oo39gBE2AyT4f3bf0vW
 c9Con/Gl
 dcn20j8wK6/zjxHJrvo390xzrL83sBjOG036W3RPSHFXEBn2clb/z/LRxh5Bt7hN5AjPenxLKJ272O1PWlVeZet5nTGbZdClSMOQFRZD2/msNnT7bL0TWvBeTxMwFUHBN0dGBuZ0IXPFZNpWM1ZqO7F+4HV3mmkDr+ZMMM88uMnL6en5B4tv+Zvq6CQcxKdoi7rdnUOOS6pDigTHlho1raovZ6SJax6gKTqYAftHeoTFwPIHGhuFri9FbpXARjVowM/PJVpgKhAfRMdsmEuQLDFBKSTxGYyBMoTWaD1oUWGJOP5UYkIgNwtl/RLTClRYCGNi5KRF3JxoSfCLtCYim0TwY18Uq+ntxyKlFCpXI923frh2Yzc4GHeN5Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Mon, Aug 10, 2026 at 06:32:04AM -0700, Breno Leitao wrote:
> Memory failures (such as unrecoverable ECCs errors) are getting more and
> more common. The kernel knows how to handle it while running, marking it
> as poisoned (and SIGBUS user tasks).
> 
> Poisoned memory is removed from the buddy allocator, but, not from
> other places. A current problem is that kexec will load new kernel
> on top of a bad/poisoned memory, which is undesirable.
> 
> If the next kernel's image, initrd or purgatory lands on poisoned frame,
> the relocation copy writes to the bad memory and the machine checks

What does the machine check here? ;-)

> during the kexec.
> 
> Skip hardware-poisoned frames when placing segments: check them in the
> kexec_file hole finder so it lays the next kernel down on good memory,
> and reject a poisoned destination in sanity_check_segment_list() for
> the kexec_load path, which cannot relocate.
> 
> The two hole finders walk in opposite directions, so each asks for the
> end of the poison it has to clear: the top-down walk for the first
> poisoned page in the window, the bottom-up walk for the last. A poisoned
> hugetlb folio counts in full, as hugetlb keeps the flag on the folio and
> the poisoned subpages on its raw hwpoison list.

I had hard time parsing these two paragraphs. Can you please add more human
touch to them?
 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
>
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index dc770b9a6d053..7ee8c9f078f6b 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -212,6 +212,16 @@ int sanity_check_segment_list(struct kimage *image)
>  	}
>  #endif
>  
> +	/*
> +	 * Reject destinations that land on hardware-poisoned memory: the
> +	 * relocation copy would machine-check on the bad frame.

Would cause machine-check exception?

> +	 */
> +	for (i = 0; i < nr_segments; i++) {
> +		if (range_first_hwpoison(image->segment[i].mem,
> +					 image->segment[i].memsz) != PHYS_ADDR_MAX)
> +			return -EHWPOISON;
> +	}
> +
>  	/*
>  	 * The destination addresses are searched from system RAM rather than
>  	 * being allocated from the buddy allocator, so they are not guaranteed
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index 59fb9d71e9d86..9ba6cc01af929 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -475,6 +475,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  {
>  	struct kimage *image = kbuf->image;
>  	unsigned long temp_start, temp_end;
> +	phys_addr_t poison;
>  
>  	temp_end = min(end, kbuf->buf_max);
>  	temp_start = temp_end - kbuf->memsz + 1;
> @@ -504,6 +505,15 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  			continue;
>  		}
>  
> +		poison = range_first_hwpoison(temp_start, kbuf->memsz);
> +		if (poison != PHYS_ADDR_MAX) {
> +			/* we hit a poisoned page */
> +			if (poison < kbuf->memsz)
> +				return 0;

Won't we break out on the next iteration boundaries check? I.e.

		if (temp_start < start || temp_start < kbuf->buf_min)
			return 0;

> +			temp_start = poison - kbuf->memsz;
> +			continue;
> +		}
> +
>  		/* We found a suitable memory range */
>  		break;
>  	} while (1);
> @@ -520,6 +530,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
>  {
>  	struct kimage *image = kbuf->image;
>  	unsigned long temp_start, temp_end;
> +	phys_addr_t poison;
>  
>  	temp_start = max(start, kbuf->buf_min);
>  
> @@ -546,6 +557,13 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
>  			continue;
>  		}
>  
> +		poison = range_last_hwpoison(temp_start, kbuf->memsz);
> +		if (poison != PHYS_ADDR_MAX) {
> +			/* we hit a poisoned page */
> +			temp_start = poison + PAGE_SIZE;
> +			continue;
> +		}
> +
>  		/* We found a suitable memory range */
>  		break;
>  	} while (1);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba8..f3875680e7955 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -96,6 +96,47 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
>  		memblk_nr_poison_sub(pfn, i);
>  }
>  
> +/*
> + * Return the first or the last hardware-poisoned online page in [start,
> + * start + size), or PHYS_ADDR_MAX if the range is clean.
> + */
> +static phys_addr_t range_hwpoison(phys_addr_t start, unsigned long size,
> +				  bool first)
> +{
> +	phys_addr_t poison = PHYS_ADDR_MAX;
> +	unsigned long pfn, end_pfn;
> +
> +	if (!size || !atomic_long_read(&num_poisoned_pages))
> +		return poison;
> +
> +	end_pfn = PHYS_PFN(start + size - 1);
> +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> +		struct page *page = pfn_to_online_page(pfn);
> +
> +		cond_resched();

cond_resched() for every pfn is too much, isn't it?

> +
> +		if (!page || !is_page_hwpoison(page))
> +			continue;
> +
> +		if (first)
> +			return PFN_PHYS(pfn);
> +
> +		poison = PFN_PHYS(pfn);
> +	}
> +
> +	return poison;
> +}
> +
> +phys_addr_t range_first_hwpoison(phys_addr_t start, unsigned long size)
> +{
> +	return range_hwpoison(start, size, true);
> +}
> +
> +phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)
> +{
> +	return range_hwpoison(start, size, false);
> +}
> +
>  /**
>   * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
>   * @_name: name of the file in the per NUMA sysfs directory.
> 
> ---
> base-commit: c5e32e86ca02b003f86e095d379b38148999293d
> change-id: 20260727-kexec_posioned-72bb0a4143a0
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 

-- 
Sincerely yours,
Mike.

