Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1146EF44847
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2DD6B0092; Fri, 10 Apr 2026 08:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3633D6B0093; Fri, 10 Apr 2026 08:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2787A6B0095; Fri, 10 Apr 2026 08:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1356B6B0092
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:13:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD6BFE3104
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:13:53 +0000 (UTC)
X-FDA: 84642537546.16.08D7B59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1C0E6140002
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:13:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tLzPZ7sl;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775823232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0BvSXReYSRRwgUShrYlU35UKMeEmkue4ENtTgSs2TQ=;
	b=DiX5V5/sTrWff3Nt1Vq1o+yuCP2sZqZRFT3VkM7vzHvyZShbwqvg9f/kv5i/LJfDYF4ZuL
	bnHt0PFXAHRWxj9Bm5LYscTxnDFwMygABiVhyERAlj1UxpihrtRDN/Y2KOSFSsvEq4uw8t
	dRQ1LczDepqvJ66KS5w3/3T2oP4HNxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775823232; a=rsa-sha256;
	cv=none;
	b=QwKp5xdoM4t0LGwlRJnySCbTBJ047yIBaUBzLJV4gitRXhZhCNgzwpQJGZrZgVwV9lwmAq
	d6ndruPZbaXSAFBklPnEISaBD0C3pNtTf1l36trCon1SeyYjYwtPCrTPbcrivBj/Tw1PmX
	XAs6uDOl/Gvsxeci8EZTnWJZNgerOI0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tLzPZ7sl;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72AB96024D;
	Fri, 10 Apr 2026 12:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945D6C19421;
	Fri, 10 Apr 2026 12:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823231;
	bh=Mr9yxOrAKcnkKOYz0gBol4ytGWhmvk0ZGMLSGWC88UA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tLzPZ7sleIRkgRUbRXWJDZwu1lql5NkDTsfvi2l3sWZDBGqnMUC2nUk1cHxoBxMms
	 ULDJrUVTDHlAlvO4n4FTXnygk1oB0t7mC27YH2+j4No4IUzJiDsOhxw/ZGMhp3hMiR
	 Rb8doK3idFBNSpQ4O2TMorkL/hJ4kVEGTS+3/iyOkqsJsKSL9TLtn8ihSbHVjAIBWN
	 lL7SOh7tk79CxmERhjRi2vxcjvOUErXbhEh2C8uiy9umOXz1xoR4jYSL2+psJkS5fo
	 G+pL7nyUzc4fZfkE9V5r6FA45of6iVKUaFTxQRjFjWRxSQ9GinlVMdY0TNMf1f81VN
	 RCSjyXxfG69wA==
Date: Fri, 10 Apr 2026 13:13:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	ajd@linux.ibm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mhocko@suse.com, npache@redhat.com, 
	pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, 
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev, leitao@debian.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/4] mm: improve large folio readahead and alignment
 for exec memory
Message-ID: <adjotZ6nXqDk0GKS@lucifer>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
 <803a0c15-0a6a-4c00-b6b3-eaae56d5fc15@linux.dev>
 <adjkCOiLgZ_-zovg@lucifer>
 <262a41db-a425-4362-bb67-df61119625d5@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <262a41db-a425-4362-bb67-df61119625d5@linux.dev>
X-Rspamd-Queue-Id: 1C0E6140002
X-Stat-Signature: hu1eanxd9bqgwoopnebds6cw4rrnx9se
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775823231-505993
X-HE-Meta: U2FsdGVkX18VGK+fx/3JKZwQr/JZccFsIhh4MoSpMXmabFVK8xI12BA5nwQW3V48J8bw0Z00DLUy6lFZe0pVIHbtSa1OcrH5WX/AAtAHaVujDTlGBDLQTuWt5uwCgzfpSBeD2ofsvgJdd3OginS019NWLBtw1Eng9QgJGGBqmDSKM/EVyFxkE4/nvVUzZrNRq45uO2DklUrVGZ75w2NDqO547roYXx4/MW/gtpLgLRmQ5xJB0AZn+qPi5KF9p3O0My/Y30c5BWKn5+Gk2Quc4v+EhWgb/KHzaNPViUmZcShTj+XSu4qnnNxtnKyFfyrlAqpZx20lkJ23zWmPhvc1kOeRjoMcy2cnxKr1FKEPil9hu5E8TZXHrbybJIiSmiPWv+ME8YNpIFHtyVsMM6VZpqh2Lw7e4oAP0PSlGgidCQkr+iF0CuNWaHDR2YbBVH0PsaE+Ae7yz+EJxq1YTxsjJihvkFiw+Iq30mssLeifrmWnyLaemzjcTpsNtMz0hiu2EDuHRbRxVR+imAOmUet9egV3K1C2YIL+s6YBuDhqEYwoWDBNCUeaWIHoBuQ8qqQY3BzgLmbrulZuh41mwC79FdQJO8/7C0IPfuZVmXseOfTbqIvCicMFsfj6iN9FCbj7BSOT3fuc7YKP4R+PwXYnDoA5Ny4GzxluqsLl90SZcOIp0a60qegI58pZVekm65xunw3m8Sl1jV0Hu8MCQK1i/xYBM9oJT9jjE4jdol9+ypKfXUfXgNA5PTSdg23DETPETDvce+uMCg+SdrIq6gJub9k/NSI2h83k7zVsOe5g1s5OIadnudK/fJk3dMG4JFMVHE/G6MTxEiCZg3Bbx/RSwiVrg8Xwd2CWFG3njlKXNnWZryOekH4zvAiswi44VPsp/AyPO165uqZQ6tNLZnsfM/wW2759mDiOwXTZVx9e0cvv+cnNlphJJ7RwTpisu/pabavsONpNYv+8u/Cpu+z
 wuL1DxTZ
 lyhDtg9g4t4iZRbSF2tO9xyth957ETiYcpWCMXoNcfG6pue92Sea8ObhDqO9ZkGndRBQDg1ewZHUN2V+GIzpZ8eh5O4w4G2rgGTL++yaCEaXMTGbU0WJ4AKwA0A7QYlI90DucE4/R+M66yMS5Zx7sYQV6pz/DLdCXVzrvUW4su3QIbnvPxPl+0guP0VoD2Gr9MsurXGs4D9Od+TpA41aWhL39VD1slCcoAlPKRMFqksdrJgJom5StL1XPlZLtld+DF/lv8pXZnCHpyK0jTI1Jrsl9JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 01:05:40PM +0100, Usama Arif wrote:
>
>
> On 10/04/2026 12:55, Lorenzo Stoakes wrote:
> > On Fri, Apr 10, 2026 at 12:03:03PM +0100, Usama Arif wrote:
> >>
> >>
> >> On 02/04/2026 19:08, Usama Arif wrote:
> >>> v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
> >>> - Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
> >>>   to HPAGE_PMD_SIZE limited to 2M (Rui)
> >>> - Reviewed-by tags for patch 1 from Kiryl and Jan
> >>> - Remove preferred_exec_order() (Jan)
> >>> - Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
> >>>   otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
> >>>   do_sync_mmap_readahead().
> >>> - Change exec_folio_order() to return 2M (cont-pte size) for 64K base
> >>>   page size for arm64.
> >>> - remove bprm->file NULL check (Matthew)
> >>> - Change filp to file (Matthew)
> >>> - Improve checking of p_vaddr and p_vaddr (Rui and Matthew)
> >>>
> >>
> >> Hello!
> >>
> >> Just wanted to check if there was any feedback/review on the latest
> >> revision?
> >
> > It's -rc7, this is definitely something for next cycle :)
> >
>
> Yeah no worries! Just wanted to check what people thought about it!

We'll come back to it! With LSF coming too I think people are fairly distracted
as well.

>
> > On my part, my upstream bandwidth has drastically reduced, and review is
> > probably going to have to be a hobbyist thing at least for now.
> >
> > Also, not to be mean but:
> >
> > $ git log -E -i --grep "(Reviewed|Acked)-by: Usama Arif" --oneline | wc -l
> > 21
> >
> > So... :)
> >
> > Review in mm is very lop-sided, let's try to balance it out a bit!
> >
>
> Ah yeah actually I have been reviewing a lot over the last few months.

Good :)

> I dont ack patches that have already been acked-by/reviewed-by maintainers.

You should do that, it is meaningful. If you think a patch is OK, it's how you
say so!

Maintainers get things wrong too by the way, assume we are wrong and try to find
issues, this is how a healthy technical community operates (as long as everybody
is civil about it :)

> as I am not sure if it adds anything. I never really cared about Reviewed/Acked
> by/patch count but I can start adding tags if it helps in stats.

It's the only metric I can quickly bring up, so sorry that in this case I got it
wrong, but the overall point remains the same - we want to see a balance of
review and contributions, right now the two are really very lopsided!

>
> The reviews I have done over the last week alone:
> https://lore.kernel.org/all/20260408122307.1360475-1-usama.arif@linux.dev/
> https://lore.kernel.org/all/20260408123700.1596800-1-usama.arif@linux.dev/
> https://lore.kernel.org/all/20260409142256.131676-1-usama.arif@linux.dev/
> https://lore.kernel.org/all/20260410114809.3592720-1-usama.arif@linux.dev/
> https://lore.kernel.org/all/20260410112433.3248586-1-usama.arif@linux.dev/
> https://lore.kernel.org/all/20260331103451.1070175-1-usama.arif@linux.dev/T/#t
> https://lore.kernel.org/all/20260401152343.3294686-1-usama.arif@linux.dev/
>
>
>
>
>

Cheers, Lorenzo

