Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C84606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 07:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YcTvULNQ
Received: by kanga.kvack.org (Postfix)
	id 16B676B00EF; Fri, 30 Oct 2026 03:30:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123F86B05B1; Fri, 30 Oct 2026 03:30:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0329A6B05B2; Fri, 30 Oct 2026 03:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D3F746B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:30:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6A0FA0647
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:30:03 +0000 (UTC)
X-FDA: 85378468686.18.1552FE2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD94A1C0005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:30:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YcTvULNQ;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793345402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyfKDjJKfboeY0ufdBsjhuOQtM906D+prVVlHL4BJww=;
	b=G+dvH7fu4Go+N071Bt9huRidycfMayHvPSzpCzZoDHA1iAPTop58vzZtDsFMcEdJlGa8v7
	3mE0seSWCIj1nXreZ9kUvzZoiMBh/LwkUGq+ORxBJzBQMsS8cpuhCSmSeqmHxtkVblQUSn
	j2enWiOeKO5uXCgpsh4oxeF6Xfua6fE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YcTvULNQ;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793345402;
	b=xAt/pFDIegGM9l17piGXMhGwwGjLQ5pbhvfAnqaMQPzMt+VEFcNHk77NVbN08A/Up1seU0
	45DCJ3Ec/BRSi8d4ynI7EyFKbWiGfIeSmi+uxXCbplg5vGq0g+cZUSyQEDtDLDEP/72d8H
	sBN+tgkTvUX04XHa7DC5t7xD1GjslIA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E19F1682;
	Fri, 30 Oct 2026 00:29:57 -0700 (PDT)
Received: from [10.163.152.232] (unknown [10.163.152.232])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA59D3F7B4;
	Fri, 30 Oct 2026 00:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793345400; bh=C0mcHAl4LVJ8G9Pi84zcG+F9QdADyGft2/o2o+f0aCs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YcTvULNQBDbtCwZfjjgbZnJd9x9ynp64awrXns5yOXqR8Z+sGJVfTapd6gvVsFgUJ
	 57bMm++PQke8e3TIZX02+sOLDz+2oCiQuvUscLQCxTQAkheHl0XTz1g21phraKC/Qz
	 /l8zfyfjg1A8PATkbHb82RqGtQKE9AHDFttxKiWo=
Message-ID: <e1cfd568-8fdf-4aa1-a8c5-961bb8d7efba@arm.com>
Date: Fri, 30 Oct 2026 12:59:50 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] mm/vmalloc: propagate errors in
 vmap_pages_p*d_range()
To: Hao Ge <hao.ge@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261026080329.140244-1-hao.ge@linux.dev>
 <20261026080329.140244-5-hao.ge@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261026080329.140244-5-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD94A1C0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: j1wd7wdsjqijdhiro9umksaty399p4me
X-HE-Tag: 1793345401-292506
X-HE-Meta: U2FsdGVkX19XwfdmVynFQtEPLvPyJuOg8/JgXM0GcSxxKpItDU5btybKDjdZgviH+jD9E31wn1RzPnzd71JOnP9anImFKIqyqpsT0A9fqSETsvzUQTQHOnbXlhYKx6SoBpHInz6kZYkHaQ3HIg45fR+b1dC+aSfIUWATuDD5dDwv2ZIPYERkQcIHFl5hHcWwCMsTjsh8BFIu1mxAXniCs56MlKrdKNAYoAEvLjVSZJhGn5uROZwq4fdWbhlu2Y6x/u4mcYz0+LXROT6YBlqV99brvPxy2OHD1lR+oD/ubjOXSnozDvoh/RpWyqbWWEKkLzkHCdXAG7i7mKMm+JMuahURPYjimLM0jsWJxiiT06f31sFGYkGn8Pd6X4pAzyhzGQOthDuJP8nXzvH+WFWs9+Vu0bQ54eExaRxxqt45vJsVVmjEAd73J7RmNskNTSDFhkzIVSXs5aynd85wvgioN08EQC+aTElbSXBelmZJID9aGynC3NLB0BvcJWsQsbsLqkQNRiwTDvd8VumgCT2Zk0V+7FQOdvtNGsjf+pHFzh8DoqWy79c5w2k7VivBFGj1no+UZWdaPSF2BHGNLQFm1912EOFhxBdKC3Wwh3KKkNpOjO/9snJmLw895m1oYY0tu8PjnifoOD4u7ip569foKgZC5Uh80DKkdBQyyIFgs1jMz6R1rIGMdfcCtuUQSyLTshEn/PQjGXy+7RPXmTiE/QmcI7FTdfnrvpheHBFU632WL4vfug4e9cS3GFUyzQ6b8aib6gqnWyxeLf8//4ms1c16yC3b3sHQ1hhYdwcyG1HlRrmgemwr+wTNXH6qUswAd2vCAAvxbDVV4flWZof3cVPfQm+PkxmaTl83JcI5ZeeEd+gu9EI2u+9mm78QL7T7MivHY0aDudzN1u8FhJnXD39FF/AUT2QnSbM2CHJJDPRVkCuU/xWEDX/a4SLOUi1XJUXlofg6ujHOwbuVyVI
 4KLhaUb/
 LbBM3T/Ea34H8WBMwj8tNwbrA6UjfBu9k2U7rvdrGVMuMdwDpuU74LiTPuMb8Kd6qs80F+U9C4BikndtERd8kDyk3NOhutISbT79T3/ijt8v+0x10BM7mTTOnHsnh0Mmflg+K8Ma/5xHFCziZMec06pz+cT1c6iZ31V653oGVN3zf2nwYO4R0zHhzj8rUGFzwJwSCk5U48ZhH8i1UXp563Y9a4DSb98F/BN5cv2PsEXdd4Ea0csWRWzjouY+WKle7mjKignOAhASjZKpoE7p8FQ1Sd5/pD8DpBM1gOADTP+IHAaF8vbRDP8H9lCN3BUoiyOTGSSiSXTKnLpgd+JwVIHYqytybqwP2q/WImH5aQUiUoQQatO+KNMQjAaxvAFypfYiR+dnFP6jKDjCslov2KQM+5sm0kU+ZXpQz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 26/10/26 1:33 pm, Hao Ge wrote:
> vmap_pages_pmd_range(), vmap_pages_pud_range() and
> vmap_pages_p4d_range() return -ENOMEM whenever the level below them
> fails.  But vmap_pages_pte_range() can also return -EINVAL for a
> page without a valid pfn and -EBUSY for a pte that is already
> mapped.  Pass the error up as-is instead, like the vmap_p*d_range()
> helpers for vmap_page_range() do.
> 
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---

Fixes?

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmalloc.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 7131f60d1a8e..d60b99b81ec9 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -600,16 +600,18 @@ static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
>  {
>  	pmd_t *pmd;
>  	unsigned long next;
> +	int err = 0;
>  
>  	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
>  	if (!pmd)
>  		return -ENOMEM;
>  	do {
>  		next = pmd_addr_end(addr, end);
> -		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
> -			return -ENOMEM;
> +		err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask);
> +		if (err)
> +			break;
>  	} while (pmd++, addr = next, addr != end);
> -	return 0;
> +	return err;
>  }
>  
>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> @@ -618,16 +620,18 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
>  {
>  	pud_t *pud;
>  	unsigned long next;
> +	int err = 0;
>  
>  	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
>  	if (!pud)
>  		return -ENOMEM;
>  	do {
>  		next = pud_addr_end(addr, end);
> -		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
> -			return -ENOMEM;
> +		err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask);
> +		if (err)
> +			break;
>  	} while (pud++, addr = next, addr != end);
> -	return 0;
> +	return err;
>  }
>  
>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
> @@ -636,16 +640,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>  {
>  	p4d_t *p4d;
>  	unsigned long next;
> +	int err = 0;
>  
>  	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
>  	if (!p4d)
>  		return -ENOMEM;
>  	do {
>  		next = p4d_addr_end(addr, end);
> -		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
> -			return -ENOMEM;
> +		err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask);
> +		if (err)
> +			break;
>  	} while (p4d++, addr = next, addr != end);
> -	return 0;
> +	return err;
>  }
>  
>  static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,


