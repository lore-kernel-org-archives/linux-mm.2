Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39B4FCB601
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35F066B0089; Fri,  6 Mar 2026 09:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F3E6B008A; Fri,  6 Mar 2026 09:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232B06B008C; Fri,  6 Mar 2026 09:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 109446B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:47:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB12659304
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:47:47 +0000 (UTC)
X-FDA: 84515917374.03.D2542AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3170BA000C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:47:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rt2zzKKv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772808466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ta3MggE09YbEyF7g4RimfGEhB0rCQXIJBNih2ThEo30=;
	b=yc3nwKJZVKxA13s0ra/f+hks6jlGd+i+CF25RQuGfu1mf8ohspG+uGfqMnSilf2pWeKzEm
	u9U8MeEsj1BaEeDNJOfAaNBO3Kxpc3KXW7e35Bog0hSBAMHuTx8sqPyWDxdLeinsZ9OjYG
	FWQWw7jlmF0qnjDXswVLVACal8v8IWI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772808466; a=rsa-sha256;
	cv=none;
	b=ydaiz2cM2ljBTM3nMxO3wgOwQy5ZpWFMgXZ4js1DbNZpSgPjTak2mBJ4swpXIkgsuadDvf
	VzK066X//50w6omb9vKMT6/DiPMcprMqiY1aK4wpOdXn9+gKMrNrIoqbrp5gu5cX0iXmDQ
	OWLKZaltU+mNPmCxzlm9IRJ5ZOI0su0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rt2zzKKv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59E1060018;
	Fri,  6 Mar 2026 14:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD48EC4CEF7;
	Fri,  6 Mar 2026 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772808465;
	bh=nEGfcHcUpVbkDCHnZEP98qdqW1VIi3Dz6vL20ShVqGA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rt2zzKKvlaFqYA8JPV2xqXEsBr54Bo4++L/xVH19cYqGVTItFEE0aVaSlbw3b21dR
	 r2sGxgCFxYNvIm746EXbwl5pcLSAPRmYyMWSu9SsnNfA7jqZHZeHH4NxJZ0BIJrCoL
	 qxbifJzo1/tXP4EdwwPmlhM1sdC990sSw0/asXJfqW5GlAYfYMNqmv3cBaW1d5a0LG
	 RsLtHeS+snKmusuPnjjpAOEM6R1u18m5jDuYt3tH3ldjHY8G098wY1jCW8YhBtuwSH
	 PgsueJiOD1d0k/TtS17AWBrta5G3iGwoPq5ObY9xIvaD/zOyO5nZlfpyrG/LAzh2eD
	 tpwVYVgp928cw==
Message-ID: <6305e05e-2911-42b0-b6f5-7fdde787b778@kernel.org>
Date: Fri, 6 Mar 2026 15:47:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] arm64: mm: implement the architecture-specific
 test_and_clear_young_ptes()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
 <7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7f891d42a720cc2e57862f3b79e4f774404f313c.1772778858.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3170BA000C
X-Stat-Signature: peaijntuzaauk5ckgy9a6xqnmr1zrg6q
X-Rspam-User: 
X-HE-Tag: 1772808465-747160
X-HE-Meta: U2FsdGVkX18aKCTcwpR3DiFAbYpg8FN6PIxZ72/NKHPngMkfGrDmeak64Xfu9C9WnQ1EH1kK8t2om1TWJO+vY9wjg3pyXu50q8AZlOu856jj82RsTJ/tT1Z65GlQrteNwbr3+dxsvbCYkJZPKoyK+hYX34UQJ3mBTGBPyKK5efdUpk1wGAmVkXDLM+aLG27fcjHKp+nCiGmSOeyh8erVV5yaxgIfMvIwwFt80/L8CnYRfbHtvebzFzCrs0NyFLbYiFFLvNao/T7OdViabPnw50/AgXGzPY2hk/cWhSOr7YzdJLHN+AWdqQNUCBNkHxCmntVViZKLgdwkUfdi7w7UJwtDTAu3XoprIWmUXI+E7IoXGwjZ25OLicBWZsOtOshYs8VtK0+RhFH2OegFIIeUO87dJ3DxFVVVLaLehM4/3zCUMeJLZD1nW58CgNNHAY/JJzGEmW7hHrGZ7qTYIGTc+xA/b26qBO7RC8StTJscYN+doHGUejc7hlNOgo0Hk63T21LwKw5Z+3PT9NcGICe+peoSUB+rbCLoox/lFSMrENHe/1+JnbGVQTBi3tT7nxGO2roHjjokn8E0hP2fMMpsRE+78Zxi0C0gdQ4/10PejoBv+TNLqyFrD+8M8Rq8Xrxh1wrh5gl0AKy9Scs01MQrL0o3ucFBIPBwV5qeMJ0XYoMJhLKBbRTJGzKbczRJafO/thf5Ij3vWYd+NDkMtwODUTEXwqOftTcmzuUiEwC89xcZR/eqsUZHWWm4d9kJe5w7mQna5Z7Ve32DQgtWuLefIRAWjWlX05y3nHNrgKi7Ogqi3w0c0MLjDY/l7GlX6Qwenn7q/WmrcG7Bukss/L+I7mi6Xu45+ZmMLiidp5r7In7duEJVdsXrJ08+86hkpyh6KxpSpv0r+j8jQnemQRfEgp26W/eNMNgs0v3q5R+DFMJDO4y1puCDhx9OmpD9gX0CHjJXmADPitUf+6WyFc+
 gO++tWI/
 u6Jel8hWLeGFu4Oo2uYRSMW/bDC0e91y5EhVVtdJSnrJtdNbDsjJ4wu7ksm8C4tRfipy+82fWTIjgn3vYYbcUlfdddEEif7NkIaVtnYVYWDtnWvUkU4HkwdCrnWkHNwC7/7PV/hlSEmLIONGBnJbz7Tar4SIkILRaNgVMUkv70AUkZRrlE4owMbxeGyhKcjKk1xbBJt/B1qU/OIrfMUHgImNE0VcrY1+xGjEbnEM+NnpbF+7A5ZCctc47Uhxiq6s7btIjSyfu+D7Zlk6hy0/xIIrsmx0mNRbc3KM8DJfmosnIRSBnLEAm23Kv0Hf6pcv/tY0Ig8FPB5vTGoKUadVAxhsqgTY3Ty8kEN3Zmcr+MG6nVp+o2InQ+ECCfFFr3jRK3f7SJHODMj0vayU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 07:43, Baolin Wang wrote:
> Implement the Arm64 architecture-specific test_and_clear_young_ptes() to enable
> batched checking of young flags, improving performance during large folio
> reclamation when MGLRU is enabled.
> 
> While we're at it, simplify ptep_test_and_clear_young() by calling
> test_and_clear_young_ptes(). Since callers guarantee that PTEs are present
> before calling these functions, we can use pte_cont() to check the CONT_PTE
> flag instead of pte_valid_cont().
> 
> Performance testing:
> Enable MGLRU, then allocate 10G clean file-backed folios by mmap() in a memory
> cgroup, and try to reclaim 8G file-backed folios via the memory.reclaim interface.
> I can observe 60%+ performance improvement on my Arm64 32-core server (and about
> 15% improvement on my X86 machine).
> 
> W/o patchset:
> real	0m0.470s
> user	0m0.000s
> sys	0m0.470s
> 
> W/ patchset:
> real	0m0.180s
> user	0m0.001s
> sys	0m0.179s
> 
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index aa4b13da6371..ab451d20e4c5 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1812,16 +1812,22 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
>  	return __ptep_get_and_clear(mm, addr, ptep);
>  }
>  
> +#define test_and_clear_young_ptes test_and_clear_young_ptes
> +static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
> +					    unsigned long addr, pte_t *ptep,
> +					    unsigned int nr)
> +{
> +	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
> +		return __ptep_test_and_clear_young(vma, addr, ptep);
> +
> +	return contpte_test_and_clear_young_ptes(vma, addr, ptep, nr);
> +}

Thinking out loud, what would happen if

(a) The range spans multiple possible cont ranges (like, 64 ptes).

(b) The first pte is !pte_cont(), but some others in there are?

-- 
Cheers,

David

