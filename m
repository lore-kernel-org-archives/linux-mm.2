Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E96D74965
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F71C6B0088; Fri, 19 Dec 2025 03:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A51B6B0089; Fri, 19 Dec 2025 03:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1026B008A; Fri, 19 Dec 2025 03:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 479116B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:47:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D620958F72
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:47:26 +0000 (UTC)
X-FDA: 84235591692.25.379F47C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 31F42180002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:47:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sdb8bgc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766134045; a=rsa-sha256;
	cv=none;
	b=SBx17etTUFFcbZQHTyPhrPaODgNASInITJa/pRn2sTSwm4lr/PtjSJZKBYFK+fww7shuFR
	+YBut8bdGJd5n56MNXpbs8p0A+hUPLXm54/lkuy2hYUyce+xx/M9jU4L/maSw1coS+6/pC
	j/kuCkSUnUmW02v6WtbcYqnk7JLTiXw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sdb8bgc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766134045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OliIfUY2eT5KSiCiF63QVrnR/IvcInrMZ9L1dMRjVDc=;
	b=4GujkHjZekYw2MkeAAtPofyz0IF/PFESVqQ7BMTIsrtSYJhGGwd43VWQ8pQoLGhGFL2lr5
	xTfhj0zzxmSq5EqA+Gh9LTeJdvOUbTzahwYOvo9PW9PBCo/iWezLWKwVzQSfRe0TpLbmPY
	mYVdBguuW7ZHqKYvQXrYp45jvln+MGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB7B16001D;
	Fri, 19 Dec 2025 08:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EADCC4CEF1;
	Fri, 19 Dec 2025 08:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766134044;
	bh=TGs5B+GMZUdb5OMX5/di7bdBSNlBgR8ieYIBhM34LpU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Sdb8bgc0r+gRok+GaEPKKkfkD2nx5RJeivKTW3N5XzX4VHnCwB48u98bWG720dTGs
	 2yrotDf6UVBVC6WxvH+agX8qXAU5d3bS+Ya6C+Tlr0C6oIen2mEgLfCBl4UvQAbNiZ
	 QYbPWhc9MYKRZa4yAbrg488watiZq2oOyky2YEc9b40QnhfhIZDrbsy/7Axry6Sipk
	 4r71ztnv0Wf+Ytf+5khWuBDf5EnuDsqYGkzQriRsHFACvk25OwWJWYt9lJIlOyB+Oh
	 IaxdwJaeiQm8/roE93h3BlAHkiQFBkBG87R47tDq3hDJgS65Ke+RnoyQBeVoFtUL6V
	 pz33/e6xh2vbg==
Message-ID: <de04d804-d27b-4029-9b0b-30e863440aac@kernel.org>
Date: Fri, 19 Dec 2025 09:47:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: avoid unnecessary PTE table lock during initial
 swap folio scan
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, hanchuanhua@oppo.com, v-songbaohua@oppo.com
References: <20251216075943.29593-1-richard.weiyang@gmail.com>
 <20251216075943.29593-3-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251216075943.29593-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 31F42180002
X-Rspamd-Server: rspam03
X-Stat-Signature: g9b8ypngyhh3u68xnadk6mfnagdxsb1z
X-Rspam-User: 
X-HE-Tag: 1766134045-680774
X-HE-Meta: U2FsdGVkX1+T2ZPF3xmVro8f0qs2q3ThlVcjISJiJpfqLBM/cUdYUxWChQiMPYVjSPqMPla/z6IgxL4VwYSu0Zbk3dzz3oggi5+Qvbqeq8snR1p5BRqO/YZcVxwicY8Tle0Fr35On0ccZ9gebwvzA2s0Kd9XKSSOirtvB041gWuvbtIOKamLXAn56kOuZj6E/iEa010RXbnC2Esq/Fav26RZy+P+cNc44caiQ3ZM7R0BGSg2ObldSynAFIwDWFWWX8Fsdyzc2rIw0S14K3/4B3jflUBPTRFPHOET+rBIp5GYVJNjT8mk4gsCzS8QMGp053BsWvkUH7+z4AKm55rQ9U99X+Vp71fSA6T6iGF0/UYA3KOLGMOQdnL7L8urOnu9q+knA8gfZ7XDOs1CI0VL4v2UMehQovBs5gYbGybSKdKDfjEspcSpXTXexlZH3ROZtsyklB1kXkaYQmGlPYsiG2DoexqydTENgFsstuFrZWARwoKKL/K0nuU9fW1SPNaDJIJrVHYn+H3+dFVp9BnE5s/2IydMUjEqYu/AfRkolwXvnYNqI4WGrg56BrOREoy3sx8LFaaIuG/7rwKgrgHp6PeySAGYDAc6QJgzNNH9DuWOLj6lxGDbqrIf5aDJVBaiIw/3ULoC6AIqrjcOFG0/lZwz4Rw8dWpMU0SigDKuEjGhcU4cPD/11DPaN0pHeYNh8tadFVzz3jtUaSAqeUhm4LzxijoF22O9IPNtd259XXuAk/MqOP8n5TlB/wJHFZ0p0jITTcN1zSiRLUlOlTF1PGph7MDS3msBUg97QtHW/R5bfiCGZefXBksE8WUdgc9S42ZEMD7FvbQuhp8k+lQqOnVh+jPhZBlBG4s0EKOxPHOjmXBhXs2TvUb5MswDclVQWsC4CjEnnxkq7mYemGDAdKD9m1E8Kb+CUQWG/VxlNzmo+zFRQpCpYFUJ7Lge/i2EEyDHn05NdROn8FZe7mO
 scPqtvh2
 RtV50yfOtkdm/v4maXPnIJDVAzeopPaiybyPUufNu58BfrxqScZOQzYoYqQKE2SKKoMb8OQs500bLyU9ZQU551/TnUTk0iwotdmxNkxen6Dj0WzcU3gzXvUCQbOUUS+4pAJO2V0zrzshM6BlNZ+FIDc0Pa0hDXLPP6xdz5fPp5RqnM/WQ/5fe7ffhMStmzq8O7nDs3UI/7v8kFubC5cfha+gmzjVPa4s38+7Wt8HeXEWLvo2t0QwSl1CMeGS8w1NHoK9CgwG4rX5MN+BvXZSj1nHGtQ8v5wZBABjnMPfjPDlvxlTOKUx3lXklYSpvgzaLJ1ay+fBuMBQ9X7zjAb76H1ZZbEvsjjJoaTHJqlDD0gXbHGRgzCBAn2ZtJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 08:59, Wei Yang wrote:
> The alloc_swap_folio() function performs an initial scan of the PTE
> table solely to determine the potential size (order) of the folio
> content that needs to be swapped in.
> 
> Locking the PTE table during this initial read is unnecessary for two
> reasons:
> 
>    * We are not writing to the PTE table at this stage.
> 
>    * The code will re-check and lock the table again immediately before
>      any actual modification is attempted.
> 
> This commit refactors the initial scan to map the PTE table without
> acquiring the lock. This reduces contention and overhead, improving
> performance of the swap-in path.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Chuanhua Han <hanchuanhua@oppo.com>
> Cc: Barry Song <v-songbaohua@oppo.com>
> ---
>   mm/memory.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 1b8ef4f0ea60..f8d6adfa83d7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4529,7 +4529,6 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>   	struct folio *folio;
>   	unsigned long addr;
>   	softleaf_t entry;
> -	spinlock_t *ptl;
>   	pte_t *pte;
>   	gfp_t gfp;
>   	int order;
> @@ -4563,8 +4562,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>   	if (!orders)
>   		goto fallback;
>   
> -	pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
> -				  vmf->address & PMD_MASK, &ptl);
> +	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
>   	if (unlikely(!pte))

Can can_swapin_thp() deal with concurrent unmap and possible freeing of 
pages+swap?

We have some code that depends on swap entries stabilizing the swap 
device etc; the moment you allow for that concurrently to go away you 
open a can of worns.

-- 
Cheers

David

