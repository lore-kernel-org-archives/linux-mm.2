Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABEF606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eNmCjWZI
Received: by kanga.kvack.org (Postfix)
	id B10106B05C0; Sun, 22 Nov 2026 10:54:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A4A6B05C3; Sun, 22 Nov 2026 10:54:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962F56B05C4; Sun, 22 Nov 2026 10:54:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF136B05C0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:54:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05118A074B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:54:41 +0000 (UTC)
X-FDA: 85463202762.29.13AFE73
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3FA1420002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:54:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNmCjWZI;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362879;
	b=aBI4IklMyUjUFw3r3KxyO3ijTE+oCcEgqmh0fpIQxFE2fzOpDKfHqh//GRUXjB9D3iSTBp
	iEviJg6cOkMWCSZZwncS+rGESAx21KiSgTP4NEEAqJWgQBbiAvR25/+HxcQDcPvnVQP7iP
	CDyZwgSAdxUC89ZsWWfniKLiwiQqxZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdaYsrBV//l90A8xrl2sVTadKpolcP7rxT8hA/4z5oM=;
	b=AureR2V2cnuDcRxc85zjOknC0ofT5+1+H+n27c4IYDiYXoz/uFart+rg8QdGNwa7Xsiam5
	kNYID1N9LJ9rk1mMvFteA2Mxc4Cg2hx4r15YFS9CXkc+dS/+OwbCzmbIKfa32HkxfDGH9s
	KSFmp68hXswyxLnpyQVOjQ0vqb47fF0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eNmCjWZI;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D64AF60D3B;
	Sun, 22 Nov 2026 15:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE61E1F000C0;
	Sun, 22 Nov 2026 15:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362877;
	bh=LdaYsrBV//l90A8xrl2sVTadKpolcP7rxT8hA/4z5oM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eNmCjWZIsyfkrSTYKobRjGHedyTU5Z9bTCVcyhze465Y5N7+8Wg/9rpFRgsH9Oh19
	 V2EJgQsnodqvhMRObp81DS16vI/ns9pnkk4kVeRBcnCoEqXmX+9HvSuCfGTIANDeS+
	 rTrsNo2Cf4SuVMFD1u8utbp3PPUrpKbSrXYdvPx9+8rJb3oR2njHTIM8rRHS3IzVAF
	 ScdijMJUILXpGgsUcRoigmUcW4SJ8lDb+QgI7VFpEoCHUOoVb+c+MOAzmOAKIIIRcI
	 AV3dydypkslxe8pM4UGYFS0dsvT2D+HktC+ifhTb3Z7cPkOhKQgdu9/D0jVJKotuJE
	 di1FOQYwqlYqw==
Message-ID: <fd2ba9f1-db7e-4d15-9860-4d3930898266@kernel.org>
Date: Sun, 22 Nov 2026 16:54:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/ksm: only interrupt unmerging on a fatal signal
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Kees Cook
 <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-3-236e925d9b64@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261121-some-more-ai-fixes-v1-3-236e925d9b64@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 3FA1420002
X-Stat-Signature: eo5chhwcadmasuk3e3g1wyaanby9fqej
X-Rspam-User:
X-HE-Tag: 1795362879-100089
X-HE-Meta: U2FsdGVkX19dtWZfY4ygbWF5LnY9yGkL5sluaOLy98LRIyeW7cSptj56yRzv9ypJkjMn4XIv43EJdqatvh55yzuZ18Y7xCck31bmviD8RiV3deIwMYH2dtbg4PSFvMFPKv9ec2GT39fbZMpecHC8Xbrwz4zlV/fIhEYVPXLTcivfaSNcneCp10mNsmRIJtv+ePxHBGM57oLT7y9TMb1DINEPNQ6acr+yT002Rs8OZoER/RS/CHw0gsed+AoJEz6AvBv2UScYc9KyiEhcxunIQcYAbHai4SU+um+6g/NH3UW5VhamDnmtqP5z5WHWCzUB3tKpVG1KCW7SGhQaHAenARt2Qv0751HRxgM0xBlOpk8CueJxKzAS/6lg+GHoebN9Ea+a7Pj7wC0vvlrw6F/YvbZTecNCvj9ZcDE9/eevGp6l9CEUL27SWbLvDCJnP/9j0xRzN+cPjxYZ5E6fqSVVOoSPxAvnzZk9ZAUaPlttDNvUEcFmrjZijqIl08GGdjHCjSymS28z6vMM5RSP1lnTGDVsSkzMMPCPw+5Em0AmngVVeRVC1QA8yoabicrtmuoWFV7GDXgNqC5oJYSHRXtJww12UdsWleYxVA3zWcPmpfmd7K0vKiA+u1YNBl9M36fXgZHjl0BBRYp3WHDQt9yFCzKcvFxzfldrDxa8nN5lpNMZH5xCEFAQbAGnjhQaNzKr7S8Nqm1OWpJhVDQDVAIGd1nAm6plfw1w4lB7m56u4QWfn/RbdZx4uCqe9BG9qjpCneH/A747Yv1gPs8Yp5diiTkY1UPiEFM8Fu5TjWS8VgWAwJGpfv+C+ON2MKZjZQMVejUuPC3iEAPf035gHE9uh1k+ynSJRR0CHA/Xfb54ZdnJPW2XzvqdMHg9BpmmQbGGR5NsFyeGYdI6CxEBRMJGPPILMIFi5GHV9/yyQqWCUX+jDB0OBFe3Q3ZlCqGFtOu5j5wwIWPmDzXY/UV2wpN
 1ItY8fmv
 m0unKRsal3OqK0SlLppOsTRumbznRft03IeEUKlpY+kR3CzeOibj/YcXlZW2hGFNPa35G6vSl3lA99Eb+k+bNrO2t0IP9vv80BPKBmvX6I8OcCzUBXExlJ8c/Xv32L12EBJ7FBwxVnhuG/Z8vD+QjrsuSi6sigMD4T8MX/wAr+UDQGlQIiuM0kXvt9D+uZRh/qJIcCMS4MfotEM6zZZ16Q88PswneilPviEoXWT7+dUfE3RUfji35EoKQ54XWWut3+yTYBd8ZGPcWN48keNbvBmbHlVHOLxDonhT97KBWAsn2eOEMNKkYexmoSeps3wIuLgvNl3hhNFs0tZmX/gDZb+5jw3m68oNPMM4Q96Oe5jUsNoNBS+9eDbagpMvamBf7fBPaadS0+k98F4DfMel193BDzl3Pn2NFYdgI/XXiprDi+ag18O8xa4dh6s4wf4Hbjc1ihAyOrcunUf9tKMR9wyL8X3W/owxrqcDUBGw6pXnhGj6XqIZtnEE8vmjF3scB1wfEd71KKdHYICtUEZGhZSILMbv0hzckpzPj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 17:02, Lorenzo Stoakes (ARM) wrote:
> Commit d952b79136a6 ("ksm: fix endless loop on oom") added a check for
> pending signals on KSM break, so that a lengthy unmerge could be
> interrupted, with the system call then restarted via -ERESTARTSYS.
> 
> However, it assumes that the callers can always restart whatever system
> call started it in the first place (the commit message questions whether
> this was wise).
> 
> Well, it turns out that it was not wise, as this baked in an implicit
> assumption about system call restartability, and it was and is not safe for
> mremap().
> 
> mremap() holds an mmap write lock over the operation, which an -ERESTARTSYS
> drops, meaning that the restart is not in a consistent state.
> 
> This was made considerably worse with commit d23cb648e365 ("mm/mremap:
> permit mremap() move of multiple VMAs"), which can result in data loss if
> you encounter this issue.
> 
> Consider an mremap() specifying MREMAP_FIXED | MREMAP_DONTUNMAP of two
> KSM-mergeable VMAs, where a signal becomes pending part way through:
> 
>     first pass                          restart
>     ==========                          =======
>     unmap tgt1 range
>     copy src1 to tgt1, move page tables
>     unmap tgt2 range
>     break_ksm(src2) = -ERESTARTSYS
>                                         unmap tgt1 range, which now
>                                           holds the data from src1
>                                         copy the now-empty src1 to tgt1
> 
> This results in the user observing a successful mremap() but with src1's
> data missing.
> 
> Without MREMAP_DONTUNMAP, remap_move() would find a gap at the start of the
> range on restart and fail with -EFAULT there instead.
> 
> Fix the issue by only breaking out of an unmerge if a fatal signal is
> pending, returning -EINTR when we do. This makes KSM unmerging consistent
> with many other signal checks in mm.
> 
> Target commit d23cb648e365 ("mm/mremap: permit mremap() move of multiple
> VMAs") for the fix as this made the issue significantly more impactful.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/ksm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 623a2cdb3924..5d320a200951 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -627,8 +627,8 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
>  
>  	if (ksm_test_exit(walk->mm))
>  		return 0;
> -	if (signal_pending(current))
> -		return -ERESTARTSYS;
> +	if (fatal_signal_pending(current))
> +		return -EINTR;
>  
>  	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>  	if (!start_ptep)
> 

Thanks, I'll queue this in mm-core for the next merge window.

Everything else can be merged by Andrew.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

