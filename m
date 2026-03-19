Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B0B1075264
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7BC66B0404; Thu, 19 Mar 2026 03:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53776B0406; Thu, 19 Mar 2026 03:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969B06B0407; Thu, 19 Mar 2026 03:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 858CE6B0404
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:00:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 388E21D37C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:00:30 +0000 (UTC)
X-FDA: 84561914220.18.CD194D4
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf02.hostedemail.com (Postfix) with ESMTP id C97FF80018
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:00:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MWv1JOHy;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773903627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Tf/vnCCMR7csoiq+BQVcLU+w/pmlReZtybYZJ5pONw=;
	b=YV6LdvQNla5SNl809+I6TWURT4cinNmB+NI1vjsjlnf8gOpvz6F1NZEcITavwKrXRTgamE
	kjnmaNJ51sjcXuoWyNdInlHbVrnWldAeAaDZSe8rL4ioJBAaWa3zsARuISImOsNP1z68C9
	wCpCZ8dlA7Z8fLKtLu7dk6jitl28JFE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MWv1JOHy;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773903627; a=rsa-sha256;
	cv=none;
	b=36/tIK7TxEj6Nst39H93lDO5CjLpmx4judyFCFaboXAYIqlc99++1hAvMC/x4NcWcBbYhY
	xFB4vyWhG2Gps335R2FAcXOh5OHSm2VJ4qrtxjyQZH58ygsJlFGMZT9pL5AIop7NPUeESW
	7D0IXufx7MkFD8vUy0GrHyykekyd4Pw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773903621; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/Tf/vnCCMR7csoiq+BQVcLU+w/pmlReZtybYZJ5pONw=;
	b=MWv1JOHykstAwSjNKpMk7xi8s9J/eKltQb+8fvBrcKP6/1GMOz4FD7cuUrVZtFVAxuYreD8bT8frU5cI0Qks2HEr60doelpQ61nk7KOE0lJdN2nDOzrdC35TSedtYGlD/SjyTW0TXYcqwp+GNVTxaOBHVDM3VY0RFtb0GAsBrow=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.HWASq_1773903618;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.HWASq_1773903618 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 15:00:18 +0800
Message-ID: <b4ad83ac-abc5-4389-bc74-70468bb77572@linux.alibaba.com>
Date: Thu, 19 Mar 2026 15:00:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm/huge_memory: handle buggy PMD entry in
 zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773865827.git.ljs@kernel.org>
 <8ffa393ad86b9b0ecd9b001ca88706ce2f9fe003.1773865827.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <8ffa393ad86b9b0ecd9b001ca88706ce2f9fe003.1773865827.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C97FF80018
X-Stat-Signature: d6cmtif8pmcty5th6e3hso1jmpghfz9m
X-Rspam-User: 
X-HE-Tag: 1773903626-176016
X-HE-Meta: U2FsdGVkX19YS3Zq/ydJ2x0/xQhce78jmr/uBxy3qTIewarUGRjcVhyD83Gr1YmzSpQkWWswRWxUkn5hh7uMMjdVkAKhUUpFezK/ojUmgI7MWF6psfC1sGnLCk9I8GbW8OGpMIkl5jX05g7FBmPKq1wbFTvuz9M2StFVVUJd/AxrebVgDtIVQ8tKY1rx6rLkIg9L65aogYokzJJOKjFkNmxsX2K0fktTDRA7TrkHjsTgeMSYzg8QEuTQx6fvAM9m5Rbhq/Hgy5jLNVA4iAel/NkYfSA6/hLBIxmaAAcqqL5unKqa8DgFyjYLiRrNLJ+bgQBiR9zGT1G5bhdkFiMytor+96+Lh/y3otnGf9Ha1zngndIDzmkBPyHjfig5LsXGIBW8+mrhe/UIZ1SveRFoCIaB/waoTFc+TGdjKqTtaR3dBdq+JvmCLkH8uWNA84eJDeKLr1B4nWUdv1562+wyuqQ8Uz946UXVbyliEA+MZ5OAxnfRT3gkI32PaFiIBBnPqN+BLIN3DpN4ot4jHHDgc94IrBKTI12CacEz8EUMYS2/NVT1ksUGlcAez+kIDNNtFfVy4D7HvzlUaaW+DPP3DveWzjjSKTkRR/O9He2+tAh4mflu48I/ZEVMxbKep6Kcv0hmV1uSGVKjfabR/JKxybEwo2nuQCAdAvbY7ehfCgf0omiU5+Dnq7lQbr8JyWPACZuhfVuurJpGlY3oZX5OoiST+wKoxrgJGFuy+/VHArQxTWwrLU8iRQvlCb/9Xts4wq6D1CKA9DGIT1nGfcCN7wfvyazjDVGoqD3yWADGgJrw6g9cOl/1UU5UJdKqy3/kUWn02fOC2jmDjbQBKeT8sKqSd58/zp1e/ujMk64a4ts2Iz7GP7iLO0fG83TPirRWFuEF1rMtDzWnCEk2+epnxcT9z66IpF9UYD9OQzRgyx5WKfDh5HPWwa1lXJEEogejYhesVuemKP3LnViaxW2
 OAp+fb0C
 Cb3hxRSASocR84wzWx3EBWFfBJ8O4jbC3l9yeOKyGN/f0YxmPFwEJDvypVpMbMncfDQh3HWHds539nTx/qasvAG0VhFAEQtHCUiAKtV/CollcG1e6dkSM5lSxwvkq4V++EvKU0zt9asGLjc9ygStBLSATTTIIRAdEmnWmPTa4UmWApWaFO6/LyDgn+ZgzoWFaKUfliMLgweZjxApmt03D58pp/KeKK6rd0nFb3zwO3EjWeF1iQbn08QKl5ShpvAZG9KSnHK6enDYgtGuAOtx88E5q6co1O9lqkluDNVLdOSu6rMYhN8/rY73jzxMhPFivOww8xBxle5GY/0/aop6mbTTE+DRgglBRGMeWER8US4gYYVDq7evxERTC3WDFyzmVLKTl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 4:39 AM, Lorenzo Stoakes (Oracle) wrote:
> A recent bug I analysed [0] managed to, through a bug in the userfaultfd
> implementation, reach an invalid point in the zap_huge_pmd() code where the
> PMD was none of:
> 
> - A non-DAX, PFN or mixed map.
> - The huge zero folio
> - A present PMD entry
> - A softleaf entry
> 
> The code at this point calls folio_test_anon() on a known-NULL
> folio. Having logic like this explicitly NULL dereference in the code is
> hard to understand, and makes debugging potentially more difficult.
> 
> Add an else branch to handle this case and WARN() and exit indicating
> failure.
> 
> [0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>   mm/huge_memory.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bba1ba1f6b67..8e6b7ba11448 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2478,6 +2478,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   
>   		if (!thp_migration_supported())
>   			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> +	} else {
> +		WARN_ON_ONCE(true);
> +		spin_unlock(ptl);

The warning looks reasonable to me, but ...

> +		return false;

IIUC, if we return false here, the caller zap_pmd_range() will fall back 
to call zap_pte_range(). Since pmd_trans_huge(pmd) returns true, 
zap_pte_range() will simply return 'addr', causing an infinite loop in 
zap_pmd_range(), right?

