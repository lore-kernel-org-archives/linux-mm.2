Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E963C98321
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 12:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1E36B0005; Sat, 17 Jan 2026 07:16:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C86F6B0088; Sat, 17 Jan 2026 07:16:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0C96B0089; Sat, 17 Jan 2026 07:16:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCD86B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 07:16:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 838D91603CC
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:16:08 +0000 (UTC)
X-FDA: 84341352816.10.6C9C0E5
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9600420007
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:16:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SQ9orqae;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768652166; a=rsa-sha256;
	cv=none;
	b=Y9tywd68UhiCOsDN7KYBAxZls6iTZTtQMBov9Ri+ul2jABC/zRvj+Tur2cQCtC4sMEl5XQ
	EVKbH2uo53vCs2uP8o7nq8uRwzp8te0zn+n87axuYKrVu3dZ7WBUTHpV5pu152wbMJzzlU
	/4yxYDwWuU/bNOHs8Y4O2viVjHzJCps=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SQ9orqae;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768652166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mU2PqUONtS2cYJIIAW4ddZ/GiHW3hFgj6gtmQkheM4Q=;
	b=w/7AEk2g+pMJjtn+ojju1dqsnh8gHdXFUEsDRUV5aUa/DZPXL7NbxPrELtiQ1HK08J9iZ8
	WLK/bjJLHWIUHI0etiJp8guBzxh7I4aJz9dzmREvOkhYF6t/g+r0mX9ifhlU8VZIZxiLY5
	C1jTIH1EV5t+bSFUJa8neVXClEOTYXY=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0a33d0585so18118095ad.1
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768652165; x=1769256965; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mU2PqUONtS2cYJIIAW4ddZ/GiHW3hFgj6gtmQkheM4Q=;
        b=SQ9orqae1E3Zj+VAIBckcHuxIIbz2NVPfnIJOQdwGQkFNbrKwaBb8ZC3KtrJqbJuVW
         2kilXMMqgVBsQppjVf+bNotJa9XrTGcL3SIVgf/Tm89yxTb2IP0iRhEzTPb8qaN8A8aE
         ltjRC8cDL4bh5no8GGEfnw9IxgoN1tnj5Jyx2d7Xmu3YAwi9Lkf/Sn1ZWEKI3mIyboRo
         IgQzKAbYewaTJIUK/2LY/66Zarp/sQw2vRJBkb+pzEShxo1RIz+CtWqlMf3FWVRFzXn0
         8XsQaA3DB5deDKS2dEoD28p0gOa64YRNDjMRHrIzqGF5MlbjJFcI7+JnsHUIIDVz4Vw3
         sFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768652165; x=1769256965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mU2PqUONtS2cYJIIAW4ddZ/GiHW3hFgj6gtmQkheM4Q=;
        b=O1QZyIT8ZcDzk68DSXpJMQGKXNRvgOU0Y81PupL0hFUIKSs0JkKt0yVrDUzLFRxcpl
         gisJ6jep1puUB9eWGoYTXNBarmdFyGmqylLVCdtiBKiaIa4V8AWLxIjO+UEQZ4HBNYGL
         ZCPjH88LdX0iGuOnFdQqx6blOKsN9VK3/Qp9COQFeZqEEk1MbOxpys6xPbjqd4X6pv6G
         w45Gw5La6Cwvo9QeElr8tM5ZJ9ik8lJYSBV071PyrKdze3gorF0/b7QbquVAHKV1wf6u
         xBBhknskcPEXgAviwkUh+vTV8G+55fk0mutJQ1da6IOX5Lmc/lxIZqyGyzCHn2qprnLI
         CtTA==
X-Forwarded-Encrypted: i=1; AJvYcCXstBIVQktyxSrvMQyrcUHlE/a08uJwqocFx71SCB6/TaMBhlp0/5IKcgyUx6sA2znCQ2KySrwKig==@kvack.org
X-Gm-Message-State: AOJu0Yw219d2B/xwACxXnZLobD4FocRz+41HcgdEcq3iRuL9Jb+fPzlI
	/osQ0jFsT3EU/toYm8IbB4HUFytsqeQfmnsv6/5vt0UI5KOKS3toneec
X-Gm-Gg: AY/fxX4cFORnHjMoyrkyPGugHiaWMOHE3qyZtYQQZCkHXjbUBMRu8lXCRXT/X8X1cD8
	F4jedCUB1OdESyQlufDGCSHnXJDSsJYG/CT/u2+EPehchp1iDg/v0+Zh89AHsRE0oBlaI+6H9Dv
	S6WnylGdNq0avmmBMADP9bltNsMXwEjW5U+Fkjr4OGePWTS26UpFp5kTgWIP2C6F8QK8CIaRmBf
	vHccGfPh0hgwojmJ8J2TTSwHHP96IrcEQ54w8YxcGMefMzwf2u/d4whirc4yhNTjcpU5JH4SNIx
	1l19qTT/bLVKjReHovjW907dlzSibdWyR0PikrVWvYxdSPZnK0fWvMW4jRBvHFbhQZU5O6rkfCH
	Z6P6UqCfBHFFI+X7Ebb8LnpaV778PRyMEtLTnIH6YIwojC1bY18yjJjEB5trrRhZ7PcxytjCAXC
	S34MAB3joAvCg+zEGLbftjUS1b
X-Received: by 2002:a17:902:da90:b0:297:d6c2:d06 with SMTP id d9443c01a7336-2a7188898a9mr51734285ad.20.1768652165193;
        Sat, 17 Jan 2026 04:16:05 -0800 (PST)
Received: from localhost.localdomain ([221.227.246.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7190aa312sm47050725ad.10.2026.01.17.04.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 04:16:04 -0800 (PST)
Date: Sat, 17 Jan 2026 20:15:56 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v4 2/6] mm: khugepaged: refine scan progress number
Message-ID: <mho4j3v6qcbdkgkgu5bju7p46gdux2mfrijsuiwr72cnvr246l@dgars4a25nui>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-3-yanglincheng@kylinos.cn>
 <da715a5d-e187-436d-b5ff-153b1f7c8106@kernel.org>
 <jbqygu4u22fd65pe5m4ilm6pz2cabgim7bi4vaasjp2jrqqepw@ozylhwth3atv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jbqygu4u22fd65pe5m4ilm6pz2cabgim7bi4vaasjp2jrqqepw@ozylhwth3atv>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9600420007
X-Stat-Signature: pnxnxbxkkyxyid9kwc86ypy53hd63cbo
X-Rspam-User: 
X-HE-Tag: 1768652166-499352
X-HE-Meta: U2FsdGVkX19TTzAnZ2hzQNeoOkCuAm+73jVYcWbkQKrxHtGMXd5hOFrFnVeSHukEDioPS5PctOzGWNvNyXfZk2o07PIAswILVa6bKzXaoqvrv/LcU2YAy82aXoB2xa5IjxeHfR2ZZYR+r0k7vk5I/BUC+OnrIdw0/NRZRPEgUNpxc5s7459piAPlK0++6m6FHK8Rs6NGRdFLJ111E3woGg4dNUmPxsSBOUGxxDVNemvbRyWbxMc3XT1Zn9yzOto3HglaKveavK5ZucqytwTmR+alYNuZz8jQTGhg3O0k2aeSwkQduW7A9T2TJy5yKJ/PjXouxPYABUOk5Vwk3U2IzAoIYMBnndnqrjcDkzw/Ap4GgDPTJz5J0cROpl6lmrCkky5X7zWX2eZw6UGQsWOZKNOiAy7o7NiKUDi//iXHsPYLIiCGzv8YIYP79aXkl6s3sP9/yrCdeEdJHuPwwGCHAEat/dU/vrlHle1S17+PTgdEZxgNMjayEOgdnyh/vmHli+SRy9Zi9v96B/2EVAgiyqJXvW/OaY51n7/lB4qnzGPY/pZLDFcPHgChgi8dvV9Qn0dSSuwym44o/Wuj2uqXhBdG+FuTYwb+/Rgs/fx1aL3MgU6IqAG6cwetGugfWgMhWDkHrDpJnX9xq1HslGMnAyZsSCgYiU21ap+EmbOr5OVkK6qqZrdNFh2OtJsniH37zUAnWVL5c8rSqFCSQjbrO1bkqxlLeHhmL9cL5M8CEvz0U6KZ048MtaGvs/FJ2KtzQbkK8TSBCXsRW+33LRH0qYFQtr/RIYIPyjwKftEjlFpohMyzmYug4pF+xvK1mhtT014BYfihQgLzA+ceXuOfxSGnsuUkmCCaZ5VmZAR3fUrYNFObxDdNGlm/kbc6NNQayc7i4bNb9sz2bsSAdHIbMvoaEXBO+KpjLsWDZvY9X9cIq2MECIfzw8kI8TCk0eA39pirXR9ef/hpLvJfmH4
 CszFGDaL
 VzG+D/YD7mc3E0tdUUkQrHsepU1Q++k2qRcr/azon56kQve70KuzKPvfkpMOTqYn5lR+cpR9kY2bsRez1/Mgeoh4l3AhflaoFVm/Owa4lTKlqT/3VPa8c+Nk5ZF3Q6+8NaGmLuKeLuJ8+a4BA/68Jronx0xCXZUukOCWqg8ThcAyIzMBkuv8jqiQEorVXVuEai40k36y2+dPtspJCO56+xBDtsc543YcyMSiCBL/94ob5I/VhzVHWNJxzzy78pvURGOY1/QRMI+n2H5LpYvQ9pmZL11XXHKhv13cRnb3OtmDNhhdBGbK9F+MI/GdRsLVNHUz0NWDKF+NEpyGAoVTVstUUZo/SVRMEhLJ2qu9rRdKJfgbfnjnF8UGxqvtckb2T2KMvx/RXbkvwF5CgKsUmJTO7Ny/RjholZnsbx4xv8KU4XM5mjuG7p/ucP56Sqxf6EEF+sxr3Ui7BRUA2stvWcCHPRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 12:18:20PM +0800, Vernon Yang wrote:
> On Wed, Jan 14, 2026 at 12:38:46PM +0100, David Hildenbrand (Red Hat) wrote:
> > On 1/11/26 13:19, Vernon Yang wrote:
> > > Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> > > even if only scanning a single pte.
> > >
> > > This patch does not change the original semantics of "progress", it
> > > simply uses the exact number of PTEs counted to replace HPAGE_PMD_NR.
> > >
> > > Let me provide a detailed example:
> > >
> > > static int hpage_collapse_scan_pmd()
> > > {
> > > 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > > 	     _pte++, addr += PAGE_SIZE) {
> > > 		pte_t pteval = ptep_get(_pte);
> > > 		...
> > > 		if (pte_uffd_wp(pteval)) { <-- first scan hit
> > > 			result = SCAN_PTE_UFFD_WP;
> > > 			goto out_unmap;
> > > 		}
> > > 	}
> > > }
> > >
> > > During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> > > directly. In practice, only one PTE is scanned before termination.
> > > Here, "progress += 1" reflects the actual number of PTEs scanned, but
> > > previously "progress += HPAGE_PMD_NR" always.
> > >
> > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > ---
> > >   mm/khugepaged.c | 28 ++++++++++++++++++++++------
> > >   1 file changed, 22 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 2e570f83778c..5c6015ac7b5e 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -1249,6 +1249,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> > >   static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> > >   						struct vm_area_struct *vma,
> > >   						unsigned long start_addr, bool *mmap_locked,
> > > +						int *cur_progress,
> > >   						struct collapse_control *cc)
> > >   {
> > >   	pmd_t *pmd;
> > > @@ -1264,19 +1265,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> > >   	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> > >   	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> > > -	if (result != SCAN_SUCCEED)
> > > +	if (result != SCAN_SUCCEED) {
> > > +		if (cur_progress)
> > > +			*cur_progress = HPAGE_PMD_NR;
> > >   		goto out;
> > > +	}
> > >   	memset(cc->node_load, 0, sizeof(cc->node_load));
> > >   	nodes_clear(cc->alloc_nmask);
> > >   	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> > >   	if (!pte) {
> > > +		if (cur_progress)
> > > +			*cur_progress = HPAGE_PMD_NR;
> > >   		result = SCAN_NO_PTE_TABLE;
> > >   		goto out;
> > >   	}
> > >   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> > >   	     _pte++, addr += PAGE_SIZE) {
> > > +		if (cur_progress)
> > > +			*cur_progress += 1;
> > > +
> > >   		pte_t pteval = ptep_get(_pte);
> > >   		if (pte_none_or_zero(pteval)) {
> > >   			++none_or_zero;
> > > @@ -2297,6 +2306,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> > >   static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> > >   						 struct file *file, pgoff_t start,
> > > +						 int *cur_progress,
> > >   						 struct collapse_control *cc)
> > >   {
> > >   	struct folio *folio = NULL;
> > > @@ -2337,6 +2347,9 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
> > >   			continue;
> > >   		}
> > > +		if (cur_progress)
> > > +			*cur_progress += folio_nr_pages(folio);
> > > +
> >
> > Okay, I had another look and I think the file path is confusing. We're
> > scanning xarray entries. But then, we only count some entries and not
> > others.
>
> Thank you for the review.
>
> Move PATCH #3 comments here
>
> 	> Assume we found a single 4k folio in the xarray, but then collapse a 2M THP.
> 	> Is the progress really "1" ?
>
> 	This example is indeed a issue, I will use "xas->xa_index" to fix
> 	these issues.
>
> 	> What about shmem swap entries (xa_is_value)?
>
> 	Sorry, I missed it. I will add "1 << xas_get_order(&xas)" to
> 	"cur_progreess".
>
> > Can we just keep that alone in this patch? That is, always indicate a
> > progress of HPAGE_PMD_NR right at the start of the function?
>
> Studying the implementation source code of xarray, I discovered that
> these issues can be fixed by utilizing "xas->xa_index".
>
> I send the code as follow (patch #2 and #3 are squashed). Let's see if
> it works? If not, please let me know, Thanks!
>
> --
> Thanks,
> Vernon
>
>
> diff --git a/include/linux/xarray.h b/include/linux/xarray.h
> index be850174e802..f77d97d7b957 100644
> --- a/include/linux/xarray.h
> +++ b/include/linux/xarray.h
> @@ -1646,6 +1646,15 @@ static inline void xas_set(struct xa_state *xas, unsigned long index)
>  	xas->xa_node = XAS_RESTART;
>  }
>
> +/**
> + * xas_get_index() - Get XArray operation state for a different index.
> + * @xas: XArray operation state.
> + */
> +static inline unsigned long xas_get_index(struct xa_state *xas)
> +{
> +	return xas->xa_index;
> +}
> +
>  /**
>   * xas_advance() - Skip over sibling entries.
>   * @xas: XArray operation state.
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2e570f83778c..7d42035ece5b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -68,7 +68,10 @@ enum scan_result {
>  static struct task_struct *khugepaged_thread __read_mostly;
>  static DEFINE_MUTEX(khugepaged_mutex);
>
> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> +/*
> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> + * every 10 second.
> + */
>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>  static unsigned int khugepaged_pages_collapsed;
>  static unsigned int khugepaged_full_scans;
> @@ -1249,6 +1252,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  						struct vm_area_struct *vma,
>  						unsigned long start_addr, bool *mmap_locked,
> +						unsigned int *cur_progress,
>  						struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
> @@ -1263,6 +1267,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>
> +	if (cur_progress)
> +		*cur_progress += 1;
> +
>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
>  	if (result != SCAN_SUCCEED)
>  		goto out;
> @@ -1403,6 +1410,8 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	} else {
>  		result = SCAN_SUCCEED;
>  	}
> +	if (cur_progress)
> +		*cur_progress += _pte - pte;
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);

Check it over once more carefully, the operation for counting
"cur_progress" should be placed under "out_unmap", not above it.
As shown below:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c92c7e34ef6f..a1b4fdbee8e1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1421,9 +1421,9 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	} else {
 		result = SCAN_SUCCEED;
 	}
+out_unmap:
 	if (cur_progress)
 		*cur_progress += _pte - pte;
-out_unmap:
 	pte_unmap_unlock(pte, ptl);

>  	if (result == SCAN_SUCCEED) {
> @@ -2297,6 +2306,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>
>  static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  						 struct file *file, pgoff_t start,
> +						 unsigned int *cur_progress,
>  						 struct collapse_control *cc)
>  {
>  	struct folio *folio = NULL;
> @@ -2386,6 +2396,18 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>  			cond_resched_rcu();
>  		}
>  	}
> +	if (cur_progress) {
> +		unsigned long idx = xas_get_index(&xas) - start;
> +
> +		if (folio == NULL)
> +			*cur_progress += HPAGE_PMD_NR;
> +		else if (xa_is_value(folio))
> +			*cur_progress += idx + (1 << xas_get_order(&xas));
> +		else if (folio_order(folio) == HPAGE_PMD_ORDER)
> +			*cur_progress += idx + 1;
> +		else
> +			*cur_progress += idx + folio_nr_pages(folio);
> +	}
>  	rcu_read_unlock();
>
>  	if (result == SCAN_SUCCEED) {
> @@ -2466,6 +2488,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>
>  		while (khugepaged_scan.address < hend) {
>  			bool mmap_locked = true;
> +			unsigned int cur_progress = 0;
>
>  			cond_resched();
>  			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> @@ -2482,7 +2505,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  				mmap_read_unlock(mm);
>  				mmap_locked = false;
>  				*result = hpage_collapse_scan_file(mm,
> -					khugepaged_scan.address, file, pgoff, cc);
> +					khugepaged_scan.address, file, pgoff,
> +					&cur_progress, cc);
>  				fput(file);
>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>  					mmap_read_lock(mm);
> @@ -2496,7 +2520,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  				}
>  			} else {
>  				*result = hpage_collapse_scan_pmd(mm, vma,
> -					khugepaged_scan.address, &mmap_locked, cc);
> +					khugepaged_scan.address, &mmap_locked,
> +					&cur_progress, cc);
>  			}
>
>  			if (*result == SCAN_SUCCEED)
> @@ -2504,7 +2529,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>
>  			/* move to next address */
>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
> -			progress += HPAGE_PMD_NR;
> +			progress += cur_progress;
>  			if (!mmap_locked)
>  				/*
>  				 * We released mmap_lock so break loop.  Note
> @@ -2826,11 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			mmap_read_unlock(mm);
>  			mmap_locked = false;
>  			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> -							  cc);
> +							  NULL, cc);
>  			fput(file);
>  		} else {
>  			result = hpage_collapse_scan_pmd(mm, vma, addr,
> -							 &mmap_locked, cc);
> +							 &mmap_locked, NULL, cc);
>  		}
>  		if (!mmap_locked)
>  			*lock_dropped = true;
>

