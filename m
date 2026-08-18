Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0919C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10316B018E; Tue, 18 Aug 2026 13:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8786B018F; Tue, 18 Aug 2026 13:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFEEC6B02A7; Tue, 18 Aug 2026 13:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6B016B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:19:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A23711C0030
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:19:37 +0000 (UTC)
X-FDA: 85115051994.07.F988B50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CFE7C120002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:19:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixEfGvLA;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787073575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=codh8Et1wTA8GwH2SxVdXCDGWvWVotpR40DaZsbuOm8=;
	b=EWAxL6PBlcw1LH8MbQbEqJTeNDGuDuEbA7HsX21w3MHw836ULBCXhonDEsw7Q9ct5sQF2H
	5eklYE8m7s5lOkMaPozU55XNI5DhOZZZaGeZcj/BsFI/ggCbiGJWxFG/ZW+Oirhmp2JxFA
	tXcMGVhRdLCWYSdGVwZI6Hch9WLWeZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787073575;
	b=inMH/54trj+DVxyE07Um5LacjMjYl0jVJxc2zigskZ/sNkqtJIW8cJneatZqnGaQc5mjYC
	l+LIr+tU7ssQVH+yO3gxSi3xjMaukxf0O65IHtZclsC1F81ge5VKuvGJUOHY8RjevgBthz
	svJqK0b6D+Lz28YtiOOJ81e5uwlG9jM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ixEfGvLA;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 001F340F3A;
	Tue, 18 Aug 2026 17:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A005B1F000E9;
	Tue, 18 Aug 2026 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787073574;
	bh=codh8Et1wTA8GwH2SxVdXCDGWvWVotpR40DaZsbuOm8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ixEfGvLA08oUut+wZO9gqjF363gehhEiquE+kroGE9Qtisc+xbewQP5ZBEb7gFAOA
	 KbNI7AqSIDYDy9cun29i8iwrhyKyLmIgC0CQ73atPQ//U2VoxL56zmbzmwRKr3L6AL
	 gc/I9cMk5JQdLA5TGLPGXAJcG2ak/cFBKAFKOrfD+etXsYCRI0VMoq4XDZi/AR4nG6
	 nwrnwZHNE8CA10F+kKtRYjjeNXsIrVMykJ8A5y6wdrNY0xTXpyUHnAzV4835+X9p6I
	 DRU9OMCFfLp5BM18S39jAexljLZ4SNVtabdKrHShQSCRkmYaIcnY96qooYC++7XdNQ
	 jJkS7Qp59oRpA==
Message-ID: <712c2aeb-c0fa-40ef-a086-3898ac44fd25@kernel.org>
Date: Tue, 18 Aug 2026 19:19:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/mempolicy: skip zone device folios when
 queueing folios
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, balbirs@nvidia.com, stable@vger.kernel.org
References: <20260817220810.1175596-1-gourry@gourry.net>
 <20260817220810.1175596-4-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260817220810.1175596-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: d5ph81hb188iprtqyrgkifsitimfqd64
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CFE7C120002
X-HE-Tag: 1787073575-848127
X-HE-Meta: U2FsdGVkX18dyCgAmoCTefI0RVrnkW3YVOepXtoJjTJ3G5ftPyGH8qIgzTgNx05gHYxta2AqbuAhthpj96/6G62H7BSjNb46KfKre2xWvnBpGWdNGNzSm+JSVesRUw7/UnRdFCXbytykHTNq3yML7A9EsceyaoGf6FedixGb3UaWOT3m7d7YzoioPgbPjKVIHznvtO5Kqe7WFg4UVo6e3Qm58hbchuB+mkJxMLgOviblaOHQWYYEb/AJDkX5wY5/4MhZos5x27WEHcXTdESxZY21G9/vopUb9Zp0x5ysO2UtBiaHdOlEq96w6KMxuD//DZxNYvQXxwYQkPiEX7gPSdn94uOckg6W9Ch064xWnCPtrTDDGLN3sIlKP7nOd3OIDoezJgbO73W6T2nxK4NIObffq9+CXLzjJ23SVbd9o32iG/fXic1HG86EGfC7hzgdM0+VVzddQv3F48LN5iDvKk7RZyawNwiW/ydn5evkZK4Td5Rb30ZQI3k/An/B2vGfhtqD5fDA9Omuu1CgI5vw4gy8BpmBlizmeqPQvCszeShizyh+RFGFfyqpec+16P4X16Pvto3uZDOiNvjdbq2P72KxMh4to+CdSuCXwPrCyQ7Cf/lnAAux7DQloWcIa+WMg8uUfTtCY8cO2H6nhYrw8H1HBUzsozCHKyh+RyeB2kKWB93niaijvmw9GQPnjJ8Ot3m6ZWPCotskuJu2JtxLis//Wax6rsTbXA5pgYRhK/bkEGQPFfZ2SmRq/0gIg+Wx9uwgiAjFkYQOjkXTZjHbQsar3/SwksADZn8tZTo4vnNOEDaHsgu+wKBK5jx/xdi7RW2a61bua2+WK9bFf0OOtrdJouLbgmkOc2hFMGTB2jApObsiHu3f1JX539Wga3NzAVaQbxuH/uUDBR20mPzAM8jz840/rXyI8w4Q8vA8LKs+TXw8iZOzmiETH/hv348hiWaACJbntTgzfwKAfuw
 BBTi5zQC
 Gy+mvrt/0up4ji7wzP77+2hLWa70jW0xEmXIBEmAV2SxCScsjAzXCsTDQ7tMYxaNr6dqTu9e+/WspwHvpeggark3DikD1eNyykP1ywVpcxl5bOcPuBQgi9fR59aNqUd0Q8YWoipHnNBy3uZXmNr8CgUa8bPQmsUD70p6bf9g9EtJlBmCrbqjKbL2Hi8VbqSeiTBpy0lowcwYq80wnVPskaUeDor+/8ewxPKXunJn5DeF2SSP0avGrBMDoMyycIWpTzXSdla2EuJwawWy4eCF78jNSXxOoHFbHT04iJmdDMf7dSgRdqFnI9GNzKXie59Yuan6JnJTDylKwbdKKLxO5QDVrSAhRLhwDmkuKlkpNS9b5Jn24cenJ91zB2gAM7ZqSwJg/EcR8+EenCgQNDzmLlez0QsVCPMsZx8ot
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 00:08, Gregory Price wrote:
> queue_folios_pte_range() already pairs vm_normal_folio() with an
> explicit folio_is_zone_device() check before adding folios to the
> migration pagelist.
> 
> vm_normal_folio() alone does not reject zone device memory (a present
> device-coherent page in a normal VMA is returned as "normal").
> 
> Mirror the explicit check in queue_folios_pmd() as well.
> 
> queue_folios_pmd() uses pmd_folio() directly and can encounter a present
> zone device PMD - e.g. a device-coherent THP.
> 
> This is not filtered by existing checks:
>   !pmd_present()   - only rejects non-present device-private and
>                      migration entries
> 
>   vma_migratable() - excludes DAX and VM_PFNMAP.
> 
> The early return also means such a folio is no longer counted in
> qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used
> by queue_folios_pte_range() (skipping zone device without failing).
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

