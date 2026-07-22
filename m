Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BE6C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C7A6B009D; Wed, 22 Jul 2026 09:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443AC6B009E; Wed, 22 Jul 2026 09:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E7B86B009F; Wed, 22 Jul 2026 09:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECEC36B009D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:50:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5875E140194
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:50:24 +0000 (UTC)
X-FDA: 85016547168.02.C426BBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 59F674000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:50:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T/r8Fyat";
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784728222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeoRfimiiY9Q3irn9keuGCYbXE0eQn79Xjd7POvlsJo=;
	b=d7U0RIeqLqof2g6TLR/4XVHsDvUjCZGvi6VicICjnzOtWPvgLJ6myzyRJqSFVFWFc2E3J6
	hwEgqox5PEzigJIGVRTooLR5JQEbghsg9CUL/uWi0pOpQ4pQ4XZXmCeCotRHnrXqyBIbuh
	X1HSxQM+8/TuyLwaIPqvgKJnAO+LLjA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T/r8Fyat";
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784728222;
	b=PRfkS6NLEIVP4Tlm2xsaYiO3UUpQg9sJrum10nPsGiK/bsWfqdqGE0OI3EO1MPGeKFXiu0
	jZKoQeGlWscbAYiAW/XyxMFK9AeYjeMrUQJWPmTEMICh7gRYMjA8ispte2HBzq6gps2ZeP
	ZTLSgZDGZXEvXNbaqO7zePWWsTYdRCU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0885600AF;
	Wed, 22 Jul 2026 13:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E746D1F000E9;
	Wed, 22 Jul 2026 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784728221;
	bh=EeoRfimiiY9Q3irn9keuGCYbXE0eQn79Xjd7POvlsJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T/r8FyatYSzoUoPZRC74rXA7bBAIRxpONYRHXdf5Mi9dhy8o8M3tl3WV99KKPwGMM
	 IH9UFgzJb9bIEhpaVALb7TbbknHaBSdPxIOD3d19VqZpowS4XZAyxgCrlw7siDmfVQ
	 FNZ/sAhxfRwrZczlvoQSBwaXyQmgyRMiJCYM61R0X/ZS3G8Th1dLH+ptYJSP1K2Jp5
	 roZK41OtTIwZGPW5WSJytAcGaD187QNdEOWl38XZ87MrCAkQlmqQhzZQJlMrRiJwFo
	 c6zBuLhlrT7TpaZrYl11bPxgbR9tuYnO524xJFLJyz+6bdjCxSanzCRDHzClATsZYg
	 M4A4Il8iCaJ9g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2C847F4006F;
	Wed, 22 Jul 2026 09:50:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 22 Jul 2026 09:50:20 -0400
X-ME-Sender: <xms:nMpgaiPexXFulMtpWAyLEaEws_-rBvDj0PQ7nmNGPHCBgS-KBKDNBQ>
    <xme:nMpgajSrEPao7G6bTDU0XWoDvVCmO7WBXv3GdxFWtvv8dfUK4lvbHOf-uIWKE4G0-
    svdqhEJJHWxEfQ0MpHekm9lNeDeTIgySWQ32Rc-vCU2JDiA_bKRUI8>
X-ME-Received: <xmr:nMpgan_6rMcwyWKWVzJq8xp5IEMCamoJNxGsOhK9UYawu_-PKD2zTaLOKfnwuA>
X-ME-Proxy-Cause: dmFkZTEcLBRCwuXySOYV7H6x7DkJIvrYO9Ery/tQi+sq7I57KFQUF1qdJr6zrlSqcvF9Ph
    deAkADIfMnJyfKCJ80SNnkezEOqscALfqlkpBZTUnQSZZojV5gyx0oOKDQ0eri80MNuuIr
    9gObeR+HUgmEj6Cla+MYcNTg61VpyDq7ILZJ/gN3wdt4zxWIg555StQsNfcRCIc+pu1iVB
    t3awqXZ6ybgYd/ROnC7Vy91+fg1Jo2IRoZUm9rhFFIGANGcUB02mSARfiA+BSLCJLBi1AW
    nlHlvxx/+fNSry5BX93yUaiaCtAggG4UtjCXDlcJLSNCvDXHqZhnM/P/q2SuH0l+gyjUtm
    BzaKLVGOEjqwfH6K6BnJRff/8fHaDSj0YoXDewKOs2KDXip6nXwim7proZPQ9XFv2/NSAI
    IEQptmkwx9KLubsenYj8MUM5ucfDyR5ctDxbCXlcEbr/zfX9uljpbFZonG3zlcAgEFtgVf
    nVw6w977M5lPgjrBjAwkT2YRp5l3WFRrvREt87A0++ayBq5h4EtGfKR4nNTB30NSTHwxoY
    YeC/aMQACKWpu6iOqk5bjUvsgv9CvZRZFaZFvKqM1BHmmMU8E1l3IP1x6QhejwkHRwBM4b
    tp/ous0bXtJIqShDCMBjz8XITbuGcABDhJXHj8K8DwVkydmOEytoWiAQYCpg
X-ME-Proxy: <xmx:nMpgavrX9fWw6b6Zb5y_znY8GnfRFScZx4f7Uw4ayNe5cQ3hQH7amQ>
    <xmx:nMpgaoGuwB2bl2huD-XpJ3TFcPX9GomeQDNDaHojGSovRPu-l4v5Wg>
    <xmx:nMpgau3ijbR3EzLaS4uCt5blXvK8FClevkg5H-p0CteeeXjFLc0Wxw>
    <xmx:nMpgauOiOx20T1ZNOfSc24IAUGCBRPEUjXmBnYDAwaro0bOwMzOdKQ>
    <xmx:nMpganU0caj9CT79AvPOSmVsSSJs4n3N9fjnBeSXi_ossJ05Ij7IRKWr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Jul 2026 09:50:19 -0400 (EDT)
Date: Wed, 22 Jul 2026 14:50:18 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	rneu@meta.com, riel@surriel.com, caggio@meta.com, anilagrawal@meta.com, 
	rmikey@meta.com, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 0/3] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Message-ID: <amDHmNWfQ8eid9jH@thinkstation>
References: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59F674000D
X-Stat-Signature: yzost4ra7nf33fquqcyqz3pw11tjiu4g
X-HE-Tag: 1784728222-424867
X-HE-Meta: U2FsdGVkX187ode3jdBA2JaXBuESqZEjZ3pt0CY9ngcYJLaMqE8jdrZB+oa62i6cUbRSoDRSVMCimL6Dy/02uEQx/YRGEQBuZF5MkDv2G7lvU23HhZXJOA0juFeLSpsumqXRUbe090cC3Udjbx9Tx7+ijOJXVqMLCG7xJIMdUXsAUS3pg4uP100xy2IZJIjvOfhFPzakOLB1kp4SBU8iceShWi5o+RF5JlNbIU7afRbrXvNdraYey345aiI7PuSBr2uQW44TeTjHPk0/mvIWPv6J3WSBcQbANVomW3PV6w5pHoj/HcvOXqmjRzfQ90h/+4+yMEDJ2u2Dw2Zh9tEL83xvDHE29z+KBWGAqTXM7a62TrtCy4TZBCCZpSNvEPshxFF2BdAPxSC8wm0T2LLU5eCS4KSzVI2y9M6Hd+8eB5llHp56A6Vg34UxjolPL64sI3QqPgXkPQe0rV6J/PFDdwcH22meGjhpJMHBrbzvxDmlnBsavLP8xyE3i04kwIyK6SygCYF3Kwepn09TqOQrX97TbnHddFCRk2a7/GTGhprbZQCfjXxm40GhLRTDq42wUPGkKwH0xRvPKo4eY/Oe2dZp6jM8iMH9G+4QRjvqBtgOiHIvNXgjwjMRCJyRfF6oJqFHKlznb5Wh6ZLMgnarGSa2EQnqMXlkfTBi1VWk8t7dJYYsYGF7BdCzHvSsTS+TLAi/H915n7ako7/67QhBWkNOsHZRrn/eUQvDY71eCS9EZqq5N9li2rTyN+GMC8saa6iP0EG4exxkZ20Fy24hN0EWXjqd7jePKbMpiE5UjakAnUgougM/TPXz2o1rMWuPsX4XCPRWTVxtqP7FKXLswMsFHZ+XeRr5miTH1uTjZE+FG+us0COnG9R3QmSu1PDOZnwdN9VmgzBsP3+HlMbgMWNBgF/7/sXaqgr87fZkcj5q55DLsVKYYQe+8FIurCyv+fPRWf//11Or67s7UTD
 mxqtrTNp
 Ng+6hS/myKetSDWO2tHLkarI6ReOaJyqKpJ4MfIJqeD8GDGDAowQ35JD3EQ7z84vo5lXoytjRgn8p4Fnc0ng2dYKdFpF7/L8qlJteuVq/kpyPY+cR1uuGSjx6vJq/fOHhaTqCudeR5MlkIn/ogWZV2QiKMyGO4HwiFFTNGl3zbzTf/8h1hHI+pqbuEHAvCMzb5F0KX0+n0FU/sY/S+/txzuRMOeBHZi7GMQwRBoKkCz5QHZspsU5ejVgy1nNiFaBDg49g5fWnukQvVqqhKqNqNs6vengN6n6BC6H4oI2Y+diN1MSu4LjE438TPuPx9PQ7P0IhZ40o0M78BUh0clQj/SsyzSdMaXt+YkLqlSap673VhWX17+JzYZO1iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:03:02AM -0700, Breno Leitao wrote:
> Problem:
> ========
> 
> When a page is hard-offlined due to an uncorrectable memory error (multi
> bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
> the buddy allocator. This information is not carried to the next kernel
> that is kexeced. The new kernel kexecs and trip over that bad memory
> bank _again_.
> 
> Why now:
> ========
> 
> Several industry trends make this increasingly important:
> 
>     1) DRAM is getting more expensive
>     2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
>        failing part can no longer simply be swapped;
>     3) memory is kept in service far longer (at Meta, DRAM lifetime is being
>        drastically extended).
>     4) It is more and more common to kexec instead of full reboot
>     5) Increase of memory per system with CXL
> 
> Proposed Solution:
> ==================
> 
> Carry the poisoned frames to the next kernel in a new EFI configuration
> table, LINUX_EFI_POISONED_MEMORY, modeled on the existing
> LINUX_EFI_MEMRESERVE table.
> 
> EFI configuration tables already survive kexec: firmware hands the EFI
> system table to every kernel in the chain, so a table installed once is
> seen by all successors without a new handover channel.
> 
> The mechanism is architecture independent, so x86 and arm64 use the same
> code.
> 
> The EFI stub installs an empty table while EFI boot service is up. A
> configuration table can only be created there; the running kernel can only
> append to it.
> 
> Each hard-offlined frame is appended; an unpoison "removes" its entry
> so a frame that is good again is not carried forward.
> 
> The next kernel walks the inherited table early in
> efi_config_parse_tables(), before memblock and the buddy allocator are
> up, and memblock_reserve()s every recorded frame. The bad RAM is never
> handed out.

The allocator is only half of the problem. kexec segment placement
doesn't know about any of this: kexec_file picks destinations from
System RAM resources (memblock on arm64), and poisoned frames are only
ever removed from buddy. So the next kernel image, initrd or purgatory
can be placed on top of a poisoned frame -- the relocation memcpy then
consumes the poison and the machine checks during the very kexec this
series is supposed to protect. Same for the table's own list pages:
overwrite one at placement time and the next kernel parses garbage.

Hooking num_poisoned_pages_inc() also means soft-offlined pages are
recorded. Those are functional pages, offlined predictively. Turning
them into permanent losses for every kernel down the kexec chain does
not seem right. I would record hard failures only.

On the data structure: I am not an expert on DRAM failure modes, so I
went reading. The field studies [1] say roughly a quarter of DRAM
faults are multi-bit structures (row/column/bank), and the address
interleaving means one such fault shows up to the OS as many separate
4K pages. A row fault lands in a window of tens of KB to about a MB; a
column fault is one bad line per row, strided across the bank's entire
footprint -- potentially thousands of pages scattered over gigabytes,
reported one MCE at a time as they get touched. DDR5 on-die ECC hides
most single-bit faults from the host, so the visible mix shifts toward
these multi-bit modes over time.

If that is accurate, per-4K entries have no natural bound, and every
entry becomes a separate scattered memblock_reserve() in every future
boot.

I would consider a bitmap with one bit per 2M instead, modeled on
struct efi_unaccepted_memory: the stub sizes it from the EFI memory map
at cold boot, the running kernel sets a bit on hard offline, clears it
on unpoison, and the next kernel reserves set units. It is one
fixed-size allocation, so the whole grow-and-link machinery and the
chain-parsing trust problem go away, and a row fault collapses into one
or two bits.

[1] https://arxiv.org/abs/2408.15302

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

