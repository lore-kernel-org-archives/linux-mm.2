Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4801606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n4vkk2Zd
Received: by kanga.kvack.org (Postfix)
	id D49696B05B5; Mon, 23 Nov 2026 08:24:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1C16B05B6; Mon, 23 Nov 2026 08:24:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06E76B05B7; Mon, 23 Nov 2026 08:24:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5EF6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:24:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E0D5C08C7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:24:25 +0000 (UTC)
X-FDA: 85466452890.07.BA2C416
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id F1424C000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:24:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n4vkk2Zd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795440264;
	b=O4z6uwJXNFRGwAD119P95myqkkj9VPoBXcUblyR3NOG2dc3BkbJYSftcujwBvhi2OTZiSO
	nNDGVe1s7OvOTBJazq0UAJ1d8KEX5/OlWC3MfNaF903MdhPt4K3Yi2ZiatVJCMcZNhPkg5
	Fxbm16NXGpA5XLRUgjR5dIQXhFcN+zA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795440264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6BslsgsPqSWIJMgEULA7wCu8NLMlP7oHM2O2iiUPEg=;
	b=toUmIwnf14AG/Tk/cGhMEg11a8v1c/M78xOFbfdRQwtW9xmDqKq2CwrkYa89Yr56+r8BEm
	v6JXvbNJYcSaMddp9+/7qwRpzmOZfIroyG1Yh0JiD1MEvca3nfKNSKX2E088uzx1VhcWws
	0/KlrcA6418PjyyhwfYi2HrY5TI/RYE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n4vkk2Zd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2694340D5B;
	Mon, 23 Nov 2026 13:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5C91F000C4;
	Mon, 23 Nov 2026 13:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795440262;
	bh=e6BslsgsPqSWIJMgEULA7wCu8NLMlP7oHM2O2iiUPEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n4vkk2ZdbLxRr+qFwmGGl1tUmdzFPOCqfjqV527Khs98rUNvAbury3Pu6tX9S0aIh
	 wwDeFoeRdYZ5Gf0mzFczTWp46CP6nJmEmsIS8jOcsvCpNb+ceLccvdtJPsFdx64Apv
	 9IyplPVmPHiUCNGgaw9F7tgKqNqmtclOtnJITScivtN6uHZxCMOR8hl5CKcWorbyNj
	 wLtSJYEsTkVsPY0ebBUi7zS/Y/FXp5tZuTss95pDlm8PBqByLDPZbY4BIsY5ivSakv
	 cYS1RznMsIKzb6FsqYydGr3MqyfnOA9XZGm/Ihyc5ijephLr4GGrKiJsYa8VSTLUKH
	 gyjA6LFsUMMqg==
Date: Mon, 23 Nov 2026 13:24:20 +0000
From: Harry Yoo <harry@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Usama Arif <usama.arif@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory: don't map hardware-poisoned pages in
 finish_fault()
Message-ID: <awQ-c38H1Eh1iFoy@thinkstation>
References: <20261119134236.3745231-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119134236.3745231-1-kas@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1424C000E
X-Stat-Signature: rfz518z61kphmnh8933b8xzsowohmuo7
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795440263-736187
X-HE-Meta: U2FsdGVkX19ObDkrGLRR/Tif+nsEVI1jv2xyTbqR1u7EtKhe3Fx0p7M3MkBgbzf3FzQgBStoxTDsSBvBBsFpfuh7y0vhXphjktgGJxFscrG5yjjQsW8XPTj5V7WmXatO58BwVQOlcnCeUA/AaOhcGsnR8MEMqveFDC6ravfu3wB8dRN+RZ9pB+4kJajuWaQYHxemC+uF+/syUNI9J2NHWS9vqEayB6OVa0UHFeavwgyt8Vd3YuUVIYkTeHyJQIVJidLCTsUY6/kDrmQ+HhaOWLOhq6vl8JlWLmN9SoiBqRboCkoXoFKNPL1nwP1RLLaRmBKT04HPpVPRmf3wVZCceMzkJW+Uoz/BXeyi9PlTU7QAVrIdPlkkSWVxD+v8pozJ5tysNH/Nc4/dX2JrjJkULoXiBdlFdNf4na8o1torvtvF9k5XqWe2nCn45jQ6ocmN2E37QIyA101U5ofKghS7/3zb3aZixptFL/U3D8b6mfy7rBpQuJPxfSEC12PqBg8gWWh2KN/VkI5BASAZ6p103QYs105OeAdLAwzH/8LlyAQR6HICYASTpNAkaPdXJw80ThQFbjMS8O/Kz+bDmkbcCGfWBJzbW1kLJKGx7eTPz80L+fkwGfKLHdRN4XQ8J3wTg73tif9FWEC0wRxucZcMeHVdrcSg/0kantWXqxD799wITviJpO5LHrz7s6Sd95KcMMc2sGofhpLeRe6UUf2SRFN/3CZ2L3J/rXRowAvyblZeLYhRi/F10CZJx/CfCqREDa/bgigjQHwXIZmdyZGrO398C9Iz+gKXx3kgEwUB3tqA7G40BxuO6aupBqvgAfjiCORn4q/09A+MM5SQ05SoIK5Cm3/w2v7EgvifYw3Du6OEtLa1Ar7s+tK9tyFY6gFSu3abciWz6OwyUJEyn+oWXfvq2MOEazkN71WlobhI3Netsy/ZunZgspvnh3CpZ8H9gHT1cXcczuUr18VAKwN
 TBL3jtBG
 d7wkrV7J7Q1kWjoq8ys7byMnIlLnviUcZXR9vitr956w2HmpOY2fRIFSceVwZj1avK3TfVgZLY3I3kpgORmDqHjb5bWXrHQzoU3bmjRbjAHJtQuGiKAt+CFZaJHM2yzpEtA5i7zVJjEFD6CTkSoK1CzrKBq1ru8IIVuR7lQ9+LsL5WtiWeb6EtGwKYqM61QDeYW95WxGA8+YIl5+E0+v8qbozkcy9wkgsgqZFJ7WnNh1p+PLIGx6mIlQaUw7Fg5zRP2I6y1XLPXQj+r3ueDaQU5JI3WAczYtkd1qVNeKrJ08QatThsr0q2kTd0hDDHgcWwxu9uTtcmrPG/LtH4+m5lQj71C51cnOKo2ldtyY9mQFgn8xBfPyJCtEGySoc51teBRqEVbis++6wh10n6l2Meqn9y45/ksw/8elvKXy/RF/sxX9DuechKImbEU28eUj/nMxHbVlLpZqTijv/TFQQrT6xnBAb1RRCykFRGttNzeHknHl94HtuCSBgV9uFDlBSGnlmoVgtPKkXXEIttMdFGnDasTG9lRtskLe53BFDsLQYk5QuAHcN8CAIUSu3dWobB6D1f4BmfxaEiapf31XOu6AjGyAwGaW4JeJSj8rF+yOxYAcshkfuk4Z/Jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 01:42:31PM +0000, Kiryl Shutsemau (Meta) wrote:
> When memory_failure() cannot split a large file folio, the folio stays in
> the page cache with the poisoned page in it. do_set_pmd() refuses to map
> such a folio with a PMD, so that the poisoned page gets its own fault and
> SIGBUS. finish_fault() then falls back to PTEs, but maps the whole folio:
> 
>     do_shared_fault()
>       __do_fault()
>         PageHWPoison(vmf->page)
>           // the faulting page only
>       finish_fault()
>         do_set_pmd()
>           // backs off on has_hwpoisoned
>         set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), ...)
>           // maps the poisoned page as well
> 
> A process that touches the poisoned page takes a machine check instead
> of SIGBUS from the fault.
> 
> Map a folio with a poisoned page one page at a time. The poisoned page
> then takes its own fault, which __do_fault() turns into SIGBUS.
> 
> Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

Looks good to me,
Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

