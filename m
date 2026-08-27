Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF72C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B376B009D; Thu, 27 Aug 2026 11:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41596B009E; Thu, 27 Aug 2026 11:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57B66B009F; Thu, 27 Aug 2026 11:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71DAE6B009D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:06:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED0C4A3B65
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:06:44 +0000 (UTC)
X-FDA: 85147376328.01.2BE60E3
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf29.hostedemail.com (Postfix) with ESMTP id F24CB120010
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:06:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e wJL9hJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gCDpB0no;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787843203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyVgXPC7XqGZWzz9wNdixBWf9MizjLo93ogBCNARLD0=;
	b=L3Ii1Ke8NtV/6VU+6lozQqXbYvnjoPYYi9RYr8io6zX/mdAdl+rFJUyi9I39gKY9nM5GW+
	xoSCoPeZs56SHWFhIkdEeEq3yB0Y/IPsFmro+6CRkajQRZzKmg9oqZkfHfpbU9likM9mUZ
	WZAhz5jvrqYJ5ej+Yf5Favxn6QTPWOY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="e wJL9hJ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=gCDpB0no;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787843203;
	b=MxUg0asEu8CzJvNSJmstGHgCIP+/dDW93q22YE0+OE3mex0Hl900yi6Q5Q2laDRz4jBThN
	QMbT4p/K1kLMveyWoG+ZDsCwkEx3CdJX+QrjhfcQ/49ktcKlQtLG3celi2gdb2V49BOAhD
	K+fKrcdkXyevkE/Uj9e87GbT+MchgxU=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 6FDF713800BE;
	Thu, 27 Aug 2026 11:06:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 27 Aug 2026 11:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787843202; x=
	1787850402; bh=vyVgXPC7XqGZWzz9wNdixBWf9MizjLo93ogBCNARLD0=; b=e
	wJL9hJL68P74mIyj/2wIZ2DkbFhNV08+Ks+6er8Z5FEqevPdPnxAxWV2nG++1qrM
	2xKnV3NiO0bIOSri5WfvXMdm0yne/7P1bsRd2NvTdAaCLvKZHjwlT3dUnKqxqhfu
	mKwgvn4zPF+oAP7hMAjU2e4IzKFz4FGDt1E8NaDGM9wdQyEk9iRoya9+WsgMMtDY
	WRakX9Dfn6tmKyPlBVXxnZA6zfO0nrQvENabIdpcrvNvvcetNnBMs6+fFIyTesMk
	cVblarbQ2ffUmCJyNFDS5pA7EJs45OMjzM4kol6uingknOqVU/JcPG2zW+PcdA98
	ceOs7C2JCFLd/Z7cxjSRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787843202; x=1787850402; bh=vyVgXPC7XqGZWzz9wNdixBWf9MizjLo93og
	BCNARLD0=; b=gCDpB0noOCKmpvQ0tgbD9uUfpK/rd1Yk3BVSabI2nqhKZdArI4+
	IOncXscrh1DmFVKfWtiwNYvVoeMIRzxsZMG9sHjjiuGcAabTkVnW4v26Hc+GAjBJ
	GRFvCnF4I9+EMEzwL4XdUhyg+YgVaEP7WmA22EbZdEGGBIoTKAuz5DRmizbJruCz
	635a9K9EhZLaGq6Ou8JVxvNk1KSOGE++5lKdgVO8bzoYdO3FL/qLHkxRiHthBntV
	sHXNuVqKeXq1D76rsPJuAxydKcOVkVEnZverKIrK6oyzklxEaXgDxq7tPXK/yUhG
	/vkTD1PZ1a0cFnXIQzq8imS3thSeyfSQzMw==
X-ME-Sender: <xms:gVKQavMtxw8k3KjWdBbXWHRyLBVD3k50KTjpDv2UR5QbyJN_SszZZA>
    <xme:gVKQaobzixOI7pXDdmyzxNY3n-cOV7UaBgYtqyxz4jgAYrmTmIJ_1rCtv7Dkipg2X
    paHhjUCunThCAfMlH-4Ww4IrsS2yjHx7FT--XqFqjl8-OQlI_HZxlo>
X-ME-Received: <xmr:gVKQalabVcIrMl-2XNx6Z4y0acPO7pbxJG1jHCiUOTe1Z3rFL_oSPep6FPE>
X-ME-Proxy-Cause: dmFkZTF7rqhqgfgNccL2sR2hyItVdmKcKUadzZgok63Pcy2lXH7+X0fqLqVk/pB6WyGIcu
    9MKe0/eXeV6rQomO1IDumtZ+ROQyHaLQNO7F7ESHBVIiKgzH7eB36INx8ifcAzbkCcSdkB
    YXe8izaqA9Tu9pLIGfNoVjSfZ7NYAM16xvUNys0rpUr7BNMNv5LWriUueN07q9PkXbN1PY
    z/jN03V+4Y7LxsDv9S1aleZ98TWWU6Q/jICVYj5QwMPZibdeIs8AJwzmOI4UTadWt4XDoN
    Hjrf9ky6tKoR3muqanBE99vi72fMYN6yuXLmY2h11OWHxrAczFjbbAcpGNkWE6y4rw3vrJ
    0O5w6kI6akqRYcAZbkqFXHJydzE09h14qyHoB7jYHLvPHE69ubfyHCqxyGD2960LEPm6CK
    YtGRCjPD47qD80CBT5p12LcwsskywfRwkX5q0SD8lsIBBFy+r27ubi747GPv6VeeKgdLkt
    rzKFECsqKX3K4ZzpJ5kTpOPIJhVj9laABHGVdmPIRHo77elfFGr53m8w6/qdOrYpMjERI7
    2EOrckafIsqTmJ6+pQ8GGTT7+4w33pYjSChh7RO2PCVH3aY9wsQ3dKgBMggRK8ipVry7lE
    eVOb7fh6V5TxGyP7iGYYVTUrCn8aiQN0CKYyg05yT/6hlbcfbLQG72JsgWRw
X-ME-Proxy: <xmx:gVKQanQchSGT3stTABorYgGNj7W6EUWDfqxL8AGWp65CpbGpDTPs_A>
    <xmx:gVKQaq1xEdIuxeXo3rYRCF4Lgfv-e24WDVrkKpjhiBI4PFoIigYLhw>
    <xmx:gVKQatWJrLl0-g20grYx8-G2znDUaPUjXvsTg_3U2aenTIStxCyLwA>
    <xmx:gVKQarzA1lJ_hn3De-IGB-6SlAl9WsBzMGgFh9hUjDsXgzsAn0e8uQ>
    <xmx:glKQailPGULPrI2iArVtdv2LLjyCLa7JAkpNMxDpl_vIDIbxvVp08R0g>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Aug 2026 11:06:40 -0400 (EDT)
Date: Thu, 27 Aug 2026 16:06:40 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 05/18] mm/huge_memory: rename __split_unmapped_folio()
 to __split_frozen_folio()
Message-ID: <apBQqJZ89MHZi2RJ@thinkstation>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-5-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-swap-thp-cleanup-v3-5-9b43f5163238@tencent.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6bu5w96k45fqeadxw4ti5mpscaobnkpj
X-Rspamd-Queue-Id: F24CB120010
X-HE-Tag: 1787843202-551701
X-HE-Meta: U2FsdGVkX18SMT/2y8r9+KphEg2+7iluXNXogV4gMZdj7yXpmNqAqQLVtIXKGKroaKFjI24vj/RQUj8EtEBtd52gyyhxU3rgrTf+1ngna42eLFyA3M4UKD2Q8lJV3+qmEddkLYkSWTYm2Dw7rSSyWqEkLw66ChrVxViR7kR4jk3RNro1rKeeypK6a3FB6E84UJBhICiTrPjuKxswK3IQ48Ke7fg1LgGHXdBu14ONblrSnj0cLj2O5lPTK68eXrS+N21wpP+XsZSI8Pugg5ZEpnwfTr8sQJfDJILOooLIuLQbf8PvJfj6BjSWrfot+xfpivBXEKRq34gVCA5B46AzrVv8nvpgq2opC5p5I67n3+/SAdp6iulvPwZASVHqvRxzfQLYVyOPDdbBm5REeYGFhlSK2txfw2+gYAmypdXP/kotTSlMV88VqBeNVtIfwaV55Oy7frHgiD4wbojDx1dxFFQF2CxiFTKNJMYUOy++jUiedb6/8D/DohDg2e6S9nF54OoDNsP7uHPEM6eCfRSCqF/o820O71/c/hkTcehosCP3yvA/kC87RRYdRn/LLe2oUTLJhyqYL+Lt3sZDfhEEpNbVPRE8ENUbiAYNChGdfMbs+Zr7r5dlAP3O4Juwhn0hXUKe33wn2Wo2TbADV5yTIJDTjLA2yB5Fq8tXzkBjCFhWUw4mJQOxpf09BkFpc2VHFJ4ONv+kNScdWOqJoRdcMCAnPCe0zOb6gUKR3kM5gjGsEdclHTgtgmtdwtMf7CBtPODhCyOWQrTmJMYIFw8N4Gi7vQx21d7Egd1oT3Q4YAAVeSlmOosVhk1xg5ZLfDR5tVMRukrPENa5ptd7gXyqTIyuhTZ9upajPd2G55CTftDan1qGIkNwGIKr6DYVHmLbXZElS2n1P4K79v00LgRLgunrZJgI/YhlFG4xe19eZOigZIxFGsLIyeY0z9+LFiYDIXNWZBaMk46nCtjVq/z
 Jdao6m0C
 xkUzIVhsqpBIOmFy6aazphwaqdTccHx07zU/JpyKrUPHnO7eMux4onE4sqjxhU8AC2qIZXmr+mwMJwBafkA+6J6J/BSpF2PtG4XzVaZ5tftBQsEXFM3Wwi4KfrPPPLI3xfEYGLQ5n7rtWCXrDlFHEPPWDCVnhWbe0snYkscDJFp0uoaSkok381MjcqtRzIXttZ+t9Z9eNazyz3ueP3HuZNZD75BYTMR3TQuhIokCRGbT8Ytstw8fAQAoBOJ+qp7SnMwdEokrjU4bLStWQL2HxZAx7sPGpClt/qGGIybWLZ5RrJNJZdxZ54udNF6gYuyDnKVWW+RUvQHZ+DmEY9rl/tqqf9iI42zqzYRc240v61sRezoDQKO2E3BWlZCOeuXtKuTXRLOfFoK9675lab5dg/d0Ia5iAB280qZ1SufKS6nznHIJQlGrmBFmSo4nOQ+mx/NPyJoWUV6CW9mHPw7GAw4xG2wHYs/G/CW19Q3dJrPRZgHUUXdgpaKm1JL1izHVKB5fj2cAZ39rPkmfPoRxSKcf9vhoezivaYNGjYIG7LqlKaXrSvikpodgTJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 02:55:18AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The helper splits a folio whose refcount is frozen: the frozen refcount
> is the state it relies on, while unmapping is arranged by the caller
> beforehand. The old name caused confusion and people may try to call the
> helper on non-frozen folios.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

This patch is fine:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

> @@ -3989,8 +3989,8 @@ static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int
>  	if (do_lru)
>  		lruvec = folio_lruvec_lock(folio);
>  
> -	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
> -				     NULL, split_type);
> +	ret = __split_frozen_folio(folio, new_order, split_at, NULL,
> +				   NULL, split_type);
>  
>  	/*
>  	 * Unfreeze the post-split folios and put them back to the right
> @@ -4053,8 +4053,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
>  	if (do_lru)
>  		lruvec = folio_lruvec_lock(folio);
>  
> -	ret = __split_unmapped_folio(folio, new_order, split_at, xas,
> -				     mapping, split_type);
> +	ret = __split_frozen_folio(folio, new_order, split_at, xas,
> +				   mapping, split_type);
>  
>  	/*
>  	 * Unfreeze after-split folios and put them back to the right

But now you have *unmapped_anon/file() call *frozen_folio().

Given that you introduced *unmapped_anon/file() in the previous patch,
why not give them the right names from the start?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

