Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62835CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 17:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9B48E00AF; Mon,  3 Nov 2025 12:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999D68E0057; Mon,  3 Nov 2025 12:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889238E00AF; Mon,  3 Nov 2025 12:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 772E48E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:06:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0776AB661A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:06:33 +0000 (UTC)
X-FDA: 84069924666.28.BCE83A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4F3574000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:06:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XPU4gW+C;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762189591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdEYhTnkOlSxmruFIoCGFoeLm2yNHucmd4v1WK9r8us=;
	b=5fnaPcToyYLEKOwnz8LVT6ZXIpzflpXRN1ShHK95w3Jvxa6+tFe32pLlNHTt8RjyGqEKOR
	FLSz4MtAOkE3yiB/uyT10aUVlcPDvzqHaK6xKwaKBN2gljEZ306brKAIRE7+psm0xs0FT7
	4YOT2Kw3JjXffDjXOQExTN5txYxdV4I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XPU4gW+C;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762189591; a=rsa-sha256;
	cv=none;
	b=ji2+j9CpzMYyYOaV0Nkhz/60jBZdAVpzZkPhpo7ymS1dxBHhNiuaVpGe471s8L5OCHRj4c
	AKpC1DG4udu718WbUjUFjZPr3ms5ayJf/Fs3p3XpuD/rC+ozJlryDuz0i0TuB1to2gAjBF
	jrd3RarEHqr2LB9FwVmFhpP2oxyadAA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF84B600AC;
	Mon,  3 Nov 2025 17:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88136C4CEE7;
	Mon,  3 Nov 2025 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762189590;
	bh=WJ9VTR8wJ5hOe9IOw1nh+y69/i/y4QP6U0LeOmdyc58=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XPU4gW+CjJomESHqNiS0EytGoIlIVKCyxyaIL6vriBsPRF8legOOUC57UtdV/gfzp
	 cCBMzjKpQZK7054Jj+W5irC8ZRqCU+lCoYdBXNgkS1KBXFPwFfor2I2feltLLBAfR0
	 zTZ/Zx6VQK/luOVgoTze2JMjjk9XGD3TtDvfeePb6TT6DPj7FTnrTBBSiclQDvm7Rf
	 HSVJbz0NYh8OXPhTKA2ypLCpgiSImuzMLoorvauKisM0UbLfIpwJRpYlUQjqLTjHo9
	 OAaGOV4WPk6VNeBP4k5wjRf85k7mFgFI6+80FSMu4rqxkzJPLfHNgEsN/REv6BAlXQ
	 OUdf6hPfo7tYw==
Message-ID: <cd632ad0-c73e-4e6d-872b-2f4dad285e9d@kernel.org>
Date: Mon, 3 Nov 2025 18:06:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] ksm: perform a range-walk in break_ksm
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
 <20251031174625.127417-3-pedrodemargomes@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251031174625.127417-3-pedrodemargomes@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F3574000A
X-Stat-Signature: majb4cx7995uqb1s36n9c6f1z4h7jd81
X-Rspam-User: 
X-HE-Tag: 1762189591-632841
X-HE-Meta: U2FsdGVkX18hFCOAqQ+I/xlZtZfd8CdbNARIQHJuiyRE1GsA9bqSgZKhYhQXVO7XJq0KXcXdRonMC8t6cNQW7ms8ZepxTdYMHNldKKD6ym8PKCgZ2Tgg0Y2sbZHg4XhUyEW7KI3S2Qe832y5PLMcC33V8Bl8ZVc70mpOOZiTaoDwiaEVai+sLq3QD+8whxtZT9PR4sAbgfIvGV4837p1L80eCK3W+Ri73H7S1s7GfYBk3mt1j6BQYTqfH6bLx6dTS1MI0ZF3SI/fccQMeV2EFwR2ZJsnpYY2FmBZ0ikxD91nRxjKwmwGoNQ3tfl6Qhm1kPdYss/xyHlSZp48dju4NWMpHf2EgUBxnh3TYo8w1DVsAyEzX1lqqOSVxv8orMakoOTFtHRrkTKx++H2w6h+pE6vGWlF0Dv71Jwsllm9wrt40PT6Lsy7a8BzNxJv0XTWLUfhR+dJZvRLjMR0x6ULmJRXZBPvnE6i0V5i/8FB8gD54MItg/Vv4MGCmZ/nz0kShOPGAKuJmD6svbn5JkQESj37BruarW4UQRP+kV3ROwPD4ALakFuqpQdUs9YaoUCeVP3Ikd5mEiElWAJZFpK2HFwr6SxyxTumKBvnnwPKbC4nVoYB7lJR/n/onwWaGPFweftFeU4EjN1Ulf5PKo982O+weiFB+q4Wsrwyn6GmUbQdbCeXqAR14hJ4t5yR0KVbSh9JbaoF4sjAby7hQqxVimsI45kB20XW6I17YPipuGEzZnCQzRdkikuPxh5s6tIVpJH1eWlbvSoT5uWkqI/Q9KiaWy7ncDStw+gbjgscyqOtc5XClSrRpR4NOGlLKshjHx6+CYPScqK8C6bTDZ3bfDG1aI/c32EYly/gjmsu7qIYMEskXlqsviD6PeAEiDp3nLH6qjekSqGFM+zA6JLBii5fWs8qChaV+g/VaFID1Lz1NZ/aFaYuCwyxjuZ4WICgrKMWtLpRshIiJmbJtNq
 3+eHpomk
 46SJvNIjUJWqkJ3i/NXXxs34ZZZXBwBYTghOZ4SVdAYj3nShAqGJFysTxDp+fVQb6vL6lo7QN63TjNqSRGHBP+1En8SyzZxbmVHYQfiF2FGLZCo9lSkdv0LyK8QEOwBQ8GOcvhGXDlk1Jub1HaVu8HI5QGBhfWKB2b10wXHRPtXFwjPg0Yz3ZsVlh8qOZMmxCO1HGmTOKTtjp1tk9BJMNtT7l8tBlowkJ40ROoEDzdofuQtuejnBI1r5VULQsgm6LzcQWKve/Mx5DmiMO2wSoLMtCg9Qa36G2Elt9HVuOEEesXyEWb6zDYI4XFijokz7KB7fBJAjMeLGJKLL67ESwH5AUA6c6bYzZAbjbvBeiSoUmqZ2ne1eniZNcJFCqlFFH6IAJkOOqprnsTDUXIh6rlnI4lA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.10.25 18:46, Pedro Demarchi Gomes wrote:
> Make break_ksm() receive an address range and change
> break_ksm_pmd_entry() to perform a range-walk and return the address of
> the first ksm page found.
> 
> This change allows break_ksm() to skip unmapped regions instead of
> iterating every page address. When unmerging large sparse VMAs, this
> significantly reduces runtime.
> 
> In a benchmark unmerging a 32 TiB sparse virtual address space where
> only one page was populated, the runtime dropped from 9 minutes to less
> then 5 seconds.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---
>   mm/ksm.c | 88 ++++++++++++++++++++++++++++++--------------------------
>   1 file changed, 48 insertions(+), 40 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 922d2936e206..64d66699133d 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -607,35 +607,55 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
>   	return atomic_read(&mm->mm_users) == 0;
>   }
>   
> -static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
> +struct break_ksm_arg {
> +	unsigned long addr;
> +};

Leftover? :)

> +
> +static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
>   			struct mm_walk *walk)
>   {
> -	struct folio *folio = NULL;
> +	unsigned long *found_addr = (unsigned long *) walk->private;
> +	struct mm_struct *mm = walk->mm;
> +	pte_t *start_ptep, *ptep;
>   	spinlock_t *ptl;
> -	pte_t *pte;
> -	pte_t ptent;
> -	int ret;
> +	int found = 0;

Best to perform the ret -> found rename already in patch #1.


With both things

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

