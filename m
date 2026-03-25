Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7855109C032
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC446B0099; Wed, 25 Mar 2026 11:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3CF6B009D; Wed, 25 Mar 2026 11:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311536B00A0; Wed, 25 Mar 2026 11:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9816B0099
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:06:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0B0B5B902
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:06:36 +0000 (UTC)
X-FDA: 84584911992.13.E6AA4C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 02EED1C000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:06:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BnD9gwi0;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BnD9gwi0;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774451195; a=rsa-sha256;
	cv=none;
	b=IjtdWP0WERMPZGvgmep1oVDJBOyNFigthg6OW4ZMiEb0XEXIHkNs6m5w7bATvblMqg3AFF
	zzy9f2CW5D4koObVOPqsexvItdR9BdhZ9bw8jBDQEt4u4jUyC0eO9mu1jAeQM/pmhlMHnF
	rtEB0eOKFNRLYcS5LwEMM0rFxnlRXAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lnnlSk5FC62h+SQFH8Nxu8sIUC1RcsZVRgl9S0CLkWY=;
	b=y/G8a7Tv3ZlwUttGHhmjv9mGBmvCF700jHJWpC1wbkmOajlsfAsajHd+90FSj8Lq7uDF1l
	kenc1Vinvu9hsuIqetHpDARaIG5Gt9y1nk/E6Fj9skQ40DKCmAZ8xE7hRnFaIEknkM9t+i
	as3TtvgHE6JS1HUhp7ZgY98rg5gDWbY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C20A9442D9;
	Wed, 25 Mar 2026 15:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD1FC4CEF7;
	Wed, 25 Mar 2026 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774451193;
	bh=lnnlSk5FC62h+SQFH8Nxu8sIUC1RcsZVRgl9S0CLkWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BnD9gwi0VQwGVJZwxlZQSOLmSOral2e3j++2mIQTX80noalI4x2J+rOnTVVsPd5ua
	 bijGBS4S+PN15GS2dwJyCXUcUl1+I4PSqcUyBG4KMCANZt9ucF/XE1bBdhJZFUXPrB
	 pmR3QfTDBIoNgVHkDUSxRCCuwFFvYbo0ARFItqVTCM999NZ04o69nLKszndiNSCW/o
	 TGVS2SyH8n2FSXZNGDFHnW9gJal76Pf4kPiku88kYtICDUCIpfRbQJnZ1nNG+WqI7L
	 2xKtn/qdYmPNFLV6GbRerLsyg16lm2w2zUDlrMOn94GiYGx3bPLRGnrwyMZZpk5ata
	 jBo6ZVd/Hp3iw==
Date: Wed, 25 Mar 2026 15:06:26 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
References: <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02EED1C000C
X-Stat-Signature: zijhgjocohrfsjxf4aaghmex81rt1nx5
X-Rspam-User: 
X-HE-Tag: 1774451194-375532
X-HE-Meta: U2FsdGVkX19lOuqsjBWPvvf01OW1KF6glGbl43bJqZowfv0pZ5yXHBZzzrljyIBgWv+w9Ywtm8hZOv3ydYaBkOnwGcOmb/325zS+2uvwzfsoUe/G+Q1SqwLnwfobF43tp2x3ZWbNDGwRiNlBP2tjA50d8y0pfOVDOqgi2OLUV1wawdA9fyswMZqyzQrtHYeOfnnFLKXzZl7bk7oe0u0wNqCnXgHNySpxtOnjjtmtUx0lO6+qkK/hsg6AyRMQkAI91Qgiv2jcWvOVC/pIQOwMgR7hoafqJAo2VpEckVMURJMhVUKf7S3qOIpIpOsG8oCHtbPMRnu6tV6EPDgS681qh+uDMk01I91+Ul/C/5WGxZgawt1+y6H2IZcmZu434/rthAP4GnW3Et7GsZqh4DUC3oSZmTh0brX/hIsOGF+4v+qphKRamgTjYIwHl09S5TkL3M7M/ubw7SB6bH80nNPV1ezw6TjkaDlEAZ5srL7ogDlVsxybj5Iyw+sR6/ow7cbWxiGS+kT/GII3xhN26Iz17EabnvmM+xz3kV1PcGkL8v25NaTWiv5o2wWNN6rpCgi9conNBI+bEWCk3ElKB9IaPgq4ESoWKMEGsXFi2ZcqpBS9d5MPXlWQiQ+w4Dgj+H5MkGK8PY4MCMw48X31FN1G90HxuBt0Jjtze2PUqe8RmCNWqBX2heNlsPMuTEDWBpSja2P+/hEwXiWiCDfCiFWjF7EXD62XTlDZPjf8zteCFhn5ezUjUFfMWRFTJ13a9F/0WrLHfFspQq+3ND+pAT7dVYpRKOZzOD10kmFKkJqALjxw5AFgQESOG0wgIWJx7zSHDW/CxRbXnjMcBiZLPxw/unPAlJFsnPxP/R63h/85AMGDSoKKw191hidA9JNQ1kJh2HOjcvgNIwoqYG24nsqgxs/Q4SQxLCPTP7ZT57JFdVVMgdiLxhnDeY0gEiYyiEL00WzArNTDQjl+f3qSXiP
 SEWPEcBq
 WMEemUW9RkNcz3882c4PD7SFe3SFv+UPk2/lGEo+Xffu3JG8RR9015APOxokz6nAQ/K0DM4MXrsCtOZidH6nxFEEwOiwZt3U8ifh9VEge112KSBPOCnnKC6px+rf+rMp96o0o94lTmdccaYswbh+hdQDsHxgOaMSQmqtk5Yr04MDtslOd2h4l8UcRjXuimD58M7H4bS52qP7AY9aqrHTXAc8Yr4gjP9I87SxBmegx3RgEL2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 03:58:36PM +0100, David Hildenbrand (Arm) wrote:
> On 3/25/26 15:36, Lorenzo Stoakes (Oracle) wrote:
> > On Mon, Mar 16, 2026 at 03:15:18PM +0100, David Hildenbrand (Arm) wrote:
> >> On 3/16/26 07:25, Baolin Wang wrote:
> >>>
> >>>
> >>>
> >>> Sure. However, after investigating RISC‑V and x86, I found that
> >>> ptep_clear_flush_young() does not flush the TLB on these architectures:
> >>>
> >>> int ptep_clear_flush_young(struct vm_area_struct *vma,
> >>>                unsigned long address, pte_t *ptep)
> >>> {
> >>>     /*
> >>>      * On x86 CPUs, clearing the accessed bit without a TLB flush
> >>>      * doesn't cause data corruption. [ It could cause incorrect
> >>>      * page aging and the (mistaken) reclaim of hot pages, but the
> >>>      * chance of that should be relatively low. ]
> >>>      *
> >>>      * So as a performance optimization don't flush the TLB when
> >>>      * clearing the accessed bit, it will eventually be flushed by
> >>>      * a context switch or a VM operation anyway. [ In the rare
> >>>      * event of it not getting flushed for a long time the delay
> >>>      * shouldn't really matter because there's no real memory
> >>>      * pressure for swapout to react to. ]
> >>>      */
> >>>     return ptep_test_and_clear_young(vma, address, ptep);
> >>> }
> >>
> >> You'd probably want an arch helper then, that tells you whether
> >> a flush_tlb_range() after ptep_test_and_clear_young() is required.
> >>
> >> Or some special flush_tlb_range() helper.
> >>
> >> I agree that it requires more work.
> >
> > Sorry unclear here - does the series need more work or does a follow up patch
> > need more work?
>
> Follow up!

Ok good as in mm-stable now. Sadly means I don't get to review it but there we
go.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

