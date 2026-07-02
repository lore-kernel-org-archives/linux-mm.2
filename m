Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14053C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD68E6B018D; Thu,  2 Jul 2026 21:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC276B0199; Thu,  2 Jul 2026 21:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CCA6B019A; Thu,  2 Jul 2026 21:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 858A26B018D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:14:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58F5C140174
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:47:34 +0000 (UTC)
X-FDA: 84944266428.29.7AB248E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 76C8F80005
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:47:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JG+gPzUH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783007252;
	b=bAGeLrsYjSxvaPxRobJmdZHp2di+O23VPuaPWexY8Igf5kXxSoEdOnpfdzrGAvh2RI2FjL
	J0z8DyaivCm2ARYqG2z2A8d9j6ftmRPJuH9Bf8iYC25SK5y2gjsZx3pmhjFaf1IS5uocTv
	9brX/TLJs9Dxw7qLLQHLjOn73rItn40=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783007252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HcBwq2b8wbb+HlpbEMWa8xWUd7UzW+LJArnIvi3VBc=;
	b=eXOYKjOuPhvc8BAUsa5Dv9sraxo7uZ9xTkaEFzPld8GBlUNJ+lTfMo0TY5GJD51T8kyFvM
	iyxKO3zm75LsgIgLRyeG20bjibkDa/tPMLIWNr/tzUyuMjBmRoLnZaLjp3xIDZkwVlXE2J
	ate0A9G9VYTDVsysKJO2doFSZlBRjws=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JG+gPzUH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97B4940DE0;
	Thu,  2 Jul 2026 15:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1341F000E9;
	Thu,  2 Jul 2026 15:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007251;
	bh=7HcBwq2b8wbb+HlpbEMWa8xWUd7UzW+LJArnIvi3VBc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JG+gPzUHCApSyS7KTNybCh1RpLBktz6oIyaZDWmOi0SQTnhEjoEI6jCdpVpLGBcYJ
	 YlzbQgJK8V9CUmLTiCUoKNVE/vnqM4spBQrykU7mgr5rgO6FgT6zixT+YFzhKYd2nz
	 4HgP7gFqa4WQQ3EuAbsbFr7vbbiAE0NkXRYU7mOhrK0vljIyofpvoBDSAbjka24F/v
	 +qCIj+3bl4hbrsXbjzgl3RXAMnPR+nglLhWpRPApW4zmOTRweXuUn32TnAuoNatI5+
	 TKt06gOrLyoGLh246TWxskSpPmyRboN3kf2+iVja9ngB8CpBKzTuKocPOoPzhwn8bZ
	 YGh572WwZ8u6A==
Message-ID: <f1bef34f-987a-4a47-99fb-acdeda1c072d@kernel.org>
Date: Thu, 2 Jul 2026 17:47:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] mm/mprotect: use huge_ptep_get() for hugetlb
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-7-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260702051341.126509-7-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ygkbdw14exp5rqwugdmm49k1qetc5pyx
X-Rspamd-Queue-Id: 76C8F80005
X-HE-Tag: 1783007252-630555
X-HE-Meta: U2FsdGVkX1/aTHEUphsFcX+OwFJSGoKGhIpKMdlzbS6Evc2FtzVmDJOBADU/PM8GQNGWY3IAm02v4RBn+DqX1AfEnBG91Jovc+i2c5HIzyV2/hRT3MRP+Wo1BadCWfZCJPOVWF4QrW37zTR71UYTGnsqIGn3pdK5uPR0Ul4BTLFP3F1Uy7Vvw7amhFd0hUmqtonhL7GA4Hazrr84anaSReZ95ZdZ14cawr6BsPBQZolKHC/Bq5oBUmuyJVf70RYd3ol89ubWMhYuprQPs5OVrmuGCSITllZuT4qkwyV46OZEWEeN3mGuCrIlygMVpeF8PqrQmO0jQJk15azVyY1TDwSLi3tsdibbc6XiNNlTcA7qv+RNWtKijv2+1n3qU76pvnPEEKLAOL757MEufu0PFsEi5wU9iFXlnaIuFLMmmRdyCU8EGTvR9SioQ/GfADz5C/bxz3s5Ee5YZVNNZY+CpyuuP0nkkzhW+prWMYFieBjFO3BmxVJGE6JEoHbaZWQsktwMyZqJP1nU13EV8iQ5LeIPhRumednACAjjEgsyJDyo8T3tHmYlsolceQdisyrH0uIHg8+jyVS4vLlQAhor8AYe1Ya97325BywAFUwm1V90VefcDxy/QnwMwFUTI5DVfgB1T8c/ikYgGIwGJNqJ2iyH38Kd7OBwSXD89zFfWxK1Xr9rlm4BpinJo/93KKyxiIasbw/fqTCrIIMcULiWRRTabWT3Xl/kaz1yfXKBTB6/Ib9tj/sNdg+CUUEzoFVvPFeNHNW2+I8QAFb5DPYRZYjuyF9WkR/hGDY+E47W9GfCj177W+cgt5dGDrafQITAq9l6yUIT9T+h6vDK5tGkMwq0NenODYRePylWhMfhw3pQCd5lSS4JtGEZBUFY8LDiCQglPi/xLvB0F0JgvqFS8qcbySM9QPVRAmDsRQOEzlM6WFsN3sB9LM/74ucVZbj7d8xH/gv4RIDdv2tD4R/
 T87IZ97P
 huGFCx1inlXpnMqnXu9M8Fy2z82yM2kvK9gsABBfcQ6mvRSdqfKeu7QDmfrkXITDYjdBndEK8/BTMB6pE8Y+3FtCT665ge09lFwOHUkRjJCKDNGRu9YaslPvxfWPCJYyvsztVyws04ueAuUGKyYr658X1vSSfQrTUAQLxizVye+cTw0rFPYRuzyIWwS27JTkzfUc7KmyKliFzQa6VRirV4xP8BiWkhRFaMkpnmlByjUifEzSs9LCAG+aVmNmHkPPVN+k51p/wzIzwc9XYdmB/utSJwFBluxitpkoasqE/sju35LBfue6MK+5YOTt9WdGom2ldqSjSHU//ueAwAAbCA2D+EE7tYqTbzljQsvSLkL17ISt4PnkrFwkE07MzMfwiISfgF9QlZXKWf+axfhwGPGasTpBSvroeSut+cVozSlI+C+bF9IE3VIfEkFDQRfDB+cWo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 07:13, Dev Jain wrote:
> prot_none_hugetlb_entry() is the hugetlb callback for the early
> mprotect(PROT_NONE) PFN permission walk on x86.
> 
> The callback passes the decoded PFN to pfn_modify_allowed(). For a
> hugetlb callback, the pte pointer refers to a hugetlb entry. On
> architectures where hugetlb entries need huge_ptep_get(), reading that
> entry with ptep_get() can make the permission check use the wrong PFN.
> 
> Use huge_ptep_get() before decoding the hugetlb PFN.
> 
> Currently there is no path which can trigger a bug: huge_ptep_get() is a
> simple ptep_get() for x86, and the prot_none walk occurs only for x86.
> 
> So no need to backport - use the correct helper anyways.
> 
> Fixes: 42e4089c7890 ("x86/speculation/l1tf: Disallow non privileged high MMIO PROT_NONE mappings")
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/mprotect.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9cbf932b028cf..23779632d18bf 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -699,14 +699,20 @@ static int prot_none_pte_entry(pte_t *pte, unsigned long addr,
>  		0 : -EACCES;
>  }
>  
> +#ifdef CONFIG_HUGETLB_PAGE
>  static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
>  				   unsigned long addr, unsigned long next,
>  				   struct mm_walk *walk)
>  {
> -	return pfn_modify_allowed(pte_pfn(ptep_get(pte)),
> +	pte_t entry = huge_ptep_get(walk->mm, addr, pte);

Nit: can be const :)

> +
> +	return pfn_modify_allowed(pte_pfn(entry),
>  				  *(pgprot_t *)(walk->private)) ?
>  		0 : -EACCES;

Indentation is odd.

Can we just make this readable?

if (pfn_modify_allowed ...)
	return 0
return -EACCESS;


-- 
Cheers,

David

