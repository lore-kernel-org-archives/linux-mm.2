Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20DA1CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 10:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33ACA6B0088; Fri,  1 May 2026 06:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBC66B008A; Fri,  1 May 2026 06:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DAF16B008C; Fri,  1 May 2026 06:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D74C6B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 06:49:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 435A81C0002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:49:50 +0000 (UTC)
X-FDA: 84718530540.18.6994837
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56155100002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:49:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nldl3APj;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777632588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNK5Oy/gODNtM98WgeQsVLIyKABEgLqQVVFpTb9CLvY=;
	b=k+li3Vjas2sZ40gSoNhSAM2VWO6u4Fq2lRxYVaGEd7k5xr1unL0aco6ocgJ4eWt+P+ayWb
	zX/7Xj733I2ALCw5NZjrf2fHR3G7H7NSrk7vj7MPpO+FUH9PWiz2AMBc6MdXSNM666noHK
	VlTqsVUzF00Olhikn1jM0+70dOJYNBg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777632588; a=rsa-sha256;
	cv=none;
	b=6HNrIiq4hn36SAg1nyKj9nWUwKdA7w240ja1ouj9ftXP+Gxr0c3s/GfFGOCVCo/5q4W3aC
	3gX+zwVbhq514rhrk+bTLGsizYu56asKeXLB9SQc3chCxK7+I2zz0Z3NTKnhU/mtIEaxY6
	LnxvVGHfPx89Sow37+LvBULy95enLa8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nldl3APj;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A48BB6011F;
	Fri,  1 May 2026 10:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2DDC2BCB4;
	Fri,  1 May 2026 10:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777632587;
	bh=HD0Tqz4C9rhRfdYYiP0rPWaWDc2g50e36CrYQM3nGxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nldl3APj4k5NmkwML5JQj613GISjS/YZoyiK+IuESCz8ABmPVGDtNq3wuNUYj02KJ
	 IcJbzrvrsx6qxhZrPFxlR4FWQuzxmsGdEPefDRL/XSvA+UcZRv2gQLen0spFkcVxnd
	 8N2zfkpiMz6pgRjPSgb08yQrAnRYyREBFGS/rOTVqxdRRcYUPWyQTtRRLz4PO+RaYZ
	 XqgOcnlcWFUcTghQP/m8hQMWTfoJvgKBq9zKvpgfijDhBdn3GF0tD7UiIetarf+hcZ
	 C6aruaZvFg8kcryazmZ1gekMVU0QVLLQjJa918n9QzNbQVPytOiu3BqfI7XL57UcIr
	 16FOkfcrHNAiQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 056D4F40074;
	Fri,  1 May 2026 06:49:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 01 May 2026 06:49:46 -0400
X-ME-Sender: <xms:SYX0aUN2D2see6JsS40UGsYzV-TdLmJIoE_g9iPSwiIE3WyqYRr9bA>
    <xme:SYX0aYkXT7bYzRnP9wS09HSapObfGL_RGLY6QOzBLfW05HJEdNDudYlQLyUcGAQz1
    AjY8_1BSXK6i507qIIh2nqPjNgcROTRh7iMAvsI0_3KDpTjNIqhdJY>
X-ME-Received: <xmr:SYX0aQ3hlIZPTTT8WiOajqFwDvjDTdhDdwMnTdI7Tk9pgZO7LBEizDalMACTSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeltddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggujgesthdtredttd
    dtvdenucfhrhhomhepmfhirhihlhcuufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgv
    lhdrohhrgheqnecuggftrfgrthhtvghrnhepgeetuedtjefhkeeuiefgudduvdfgvdeiue
    eigeehheehudetuedtkeelhfeihedunecuffhomhgrihhnpehsrghshhhikhhordguvghv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpth
    htoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthho
    peiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:SYX0aQWUboTYJuenHlupRY5oXKxRFad0qCjOCqd2ipDOtnmc5LIeHw>
    <xmx:SYX0abjT-apuXfagsXlOx9iXJqsmYwZ40ES9M2rQVqCMkZpmWyNU_w>
    <xmx:SYX0aZiR_b-wOnqrSjoNscfFb0XJO1evInU80jKd-8PWJOZh6VlaKA>
    <xmx:SYX0aTsc_kzHhUuCTmvCfgop52vsjeFj8_2IqgueZQPHX08DrfQ7sQ>
    <xmx:SoX0aaQZTIsbv1sxChP51_hbWPQXxUuIv6vZ6urubn5rOiN5aUhVNIPR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 May 2026 06:49:44 -0400 (EDT)
Date: Fri, 1 May 2026 11:49:38 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 11/14] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async
 fault resolution
Message-ID: <afSErJo82o1qUMqe@thinkstation>
References: <20260427114607.4068647-1-kas@kernel.org>
 <20260427114607.4068647-12-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427114607.4068647-12-kas@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56155100002
X-Rspam-User: 
X-Stat-Signature: 95u83fnwe8jk8etxpko6n4c8rana3ooo
X-HE-Tag: 1777632588-198862
X-HE-Meta: U2FsdGVkX1+32m0JnQg26jDgTvlg+7Dtsc+ZL3P1gap3/FDL6jG+GmDq5MHexNRRTINRE+pG/APfO2gYjvZTbZgSHKi97ykzzR0gmO2BlxQi8gBXvS7yb4s/j3VmYl5tt+KV91ZxRb8jg+TE19hoSZtsAN7zDg70IZwOTcaw5Q5RXCR9Zx6qAk1MRI6+1a5fuQGt6J9hWCFbFKJJNEpf6q46In5kH+smjaPc8R8OJfAfKVK1KMiDrWV8D7HI9oAgSYAdTt15GsLi2mBYNYNNBqnWzv4qRbV0fuKoL8n5WwQj+36plkwCpgPevm5yjHShnDMuPec/QB20Gi4wZXEONxKylKHWAGVYTvTBau6NB5auipjskuJx6ykiZOhVqJVb/e2E1Pa+q9F+SKbziFEpaDHCoAexX59QzSwzjAv9DkWVvJxdAfQQDZ3IaZ2/2GWqdQSsqAT91YtL2AnPE2RMPRZSKhO2h+Pr49cAacDXO6ogCVo+lFIg9RnfBASy5+1U0bnusmv0GauHjcwxTGDmIDeJX5rNVJYpJq0ckRorWbptS/iLoadNBWQcm52BL7t/BLMNBM9kamWMwRftjl8jj28HVA0ZAe7AEgO05FwbwxWj2s7bRM0uYR/N1uU+TGu1IJGkstyzY9RH2Q0bs/Cz8n9Xeu/JU4npkgGeuTuAFh5E++k9Qq1N4CIPkGy24kp4gruu+qXBfp6dcEuosrBqmgjfQ+bmgmgWC57fFO9nJJi3AvZRtux7DJeVkdol1vSloPL4BG81ZafZNYjpcVSc1ghBKhXJ3lI1PCVVoVW47tzKGCIuUmPCTeXVo6FOyiAImc2b1h7ZwwNbHurn+bASFQr3BKln9rn6fvSWCKtjmHT6Iy0p/XDB+eRza6yLiz2cuECmczFwkJiAVFFBx7ZhbpGUj9c/X6gx25VROlGg+PoSACYu/yhKmFNOWqKPbLiJxFBZCo4OSSy41kia9nV
 lVetu13Y
 2RyUHA/sUFrrDw0wgAVjtIIUes1fxnUCMytv3l+O0iVYSBfd+t4X9EtHEgaJjI015tiK0VV4bueCqRFLVDLHRHAARBMF9JzfhrR0W55A9Lr5bsuq10G13344X83JKzXq51hxsMKQvsO9M96VPTMf+IGjlHbBKRoRqGvCzgAMQ/62FergiSyP+Wle53qLQj9MbxP5DrYZRdCaboJcwUG3Z1k8pRS+eFGkeeupNvLPLA9MXs182lnVPqFhQ9JdjlhWxvAFZn8j7lzMzgc84oodZgpZSg79Ns3sx/kUK9gC3fBJk10N69kOy9cNrq9NtVbJ2BW1GK7JJxFq5Uatr+nYA4O8LGamYc3GFpAe/6l2e1b8Hzz18y8HIwbmr3cyiXqlGqfNdFheGupR96lOm3nfoUBy4AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko.dev -- https://sashiko.dev/#/patchset/20260427114607.4068647-1-kas@kernel.org -- wrote:
> commit 069c98442d3532bbf015817229b8db505210e97d
> Author: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Subject: userfaultfd: add UFFD_FEATURE_RWP_ASYNC for async fault resolution
[ ... ]
> Does this sequence create a clean but writable PMD?
> [ ... ] Could this result in modified data being silently discarded
> instead of written back during page reclaim?
> Usually, code paths establishing writable entries set the dirty bit
> together with the write bit, for instance by using
> pmd_mkwrite(pmd_mkdirty(pmd)).

The pattern intentionally mirrors do_numa_page() / numa_rebuild_single_mapping()
which has been in the kernel for years using the same sequence:

  pte = pte_modify(old_pte, vma->vm_page_prot);
  pte = pte_mkyoung(pte);
  if (writable)
          pte = pte_mkwrite(pte, vma);

with no pte_mkdirty(). The "writable" decision is fenced by
can_change_pte_writable(), which keeps the result safe in both the
shared and private cases:

  - Private (can_change_private_pte_writable): only allows the upgrade
    for PageAnonExclusive pages.

  - Shared (can_change_shared_pte_writable): returns true only when
    pte_dirty(pte). The dirty bit lives in _PAGE_CHG_MASK, so the
    earlier pte_modify(pte, vma->vm_page_prot) preserves it; the final
    PTE is writable + dirty.

The same applies to the PMD path through can_change_pmd_writable().
There is no "clean + writable" PTE/PMD escaping either branch.

> Similarly, does this create a clean but writable PTE?
> If the PTE is made writable without calling pte_mkdirty(), it might
> violate the invariant that writable PTEs must be dirty, [ ... ]

The "writable PTEs must be dirty" invariant is not a kernel-wide rule;
it depends on the architecture and the code path. Where the kernel
relies on pte_mkdirty() being called explicitly, can_change_pte_writable()
returns false and this path is not taken. do_uffd_rwp() is the same
shape as do_numa_page() and inherits its correctness arguments.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

