Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD40C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3386B0092; Thu,  9 Jul 2026 08:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E642B6B0093; Thu,  9 Jul 2026 08:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55176B0095; Thu,  9 Jul 2026 08:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A37C6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:16:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CD341C0A56
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:16:30 +0000 (UTC)
X-FDA: 84969136140.02.5D8A803
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf06.hostedemail.com (Postfix) with ESMTP id 378BB180002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:16:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d xwmt6Q";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=lNwFyr6C;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783599388;
	b=lTCI4dtp2RN2ULp9/S7+TXEaDI4LjbRPY+sXL4WnxJE0+5IG/TDCIgiLdD7Qh7H5BrCiHC
	k/flhSWB9mGn1RokU7t18BGJX0JnClVUTP6JuQiz5TsWB5raLzclWhIZpVLxkj0TBJGGWe
	9p7fzivdwbCpM5uaybY+snGkddKkekU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="d xwmt6Q";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=lNwFyr6C;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.136 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783599388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIwaKTOmqJ5ZVBRg39BGgQYKwRe26TKiebrofOqIHLE=;
	b=vweqXR27NOU8ljfyG+6DQAu/OJ2R6sLrk7DhZlySqR9AAh8rnP5/lHoAVoGw8oSTUKYstk
	aPaBXF1uCH1zVV/xOBKzX/EF8v0MHTItStQgieZO9XM10aNIFEz85IIhdZMaQNmGP0isAN
	gsBKh/zfSiaeTbcK9Nbb15aLBSS3RuE=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 231C0130055D;
	Thu,  9 Jul 2026 08:16:26 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 09 Jul 2026 08:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783599385; x=
	1783606585; bh=HIwaKTOmqJ5ZVBRg39BGgQYKwRe26TKiebrofOqIHLE=; b=d
	xwmt6QhiWu8SktKIZKxPVQccvw3oshk6O22+g/ikdXjOiKMxzS2oXLZWVtbyLU2+
	JJlTQnLZOMpyqSsq0zNSVSqMnyCbPT50YOkPGdWI7uvjxVEGDd1s7ibTQ3CTfzhV
	UC1idf187udWuWvcqWDxSnbFvJhKS0i14Wstvow3bEFDnBeOu1juZBUXFJM2t1oX
	LD+NF4jq08yfh/Y6BjTofEpTogeZKEk8afxpfPCgUrWaMEyZ7Ii2dTOB2T0sD4vE
	DY+E7kWU9lEaoOiIneV7MXR9YOXsNq4yVVa2ybgON+wiNLQdv6UAdulFtkAbelOc
	uh7GIqaoKqQTBKQOU7Igg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783599385; x=1783606585; bh=HIwaKTOmqJ5ZVBRg39BGgQYKwRe26TKiebr
	ofOqIHLE=; b=lNwFyr6CP7+3EaZiJ/fnW/gcypFWXXYRV7q3MSJdW+wysLXXKUx
	uuMNnRejQ8nnQwADrDLk8dVEkjrHcP9HX1Uem4V6cXBjiunN0xRlW3aHe+fKNZ28
	WLhd3iO4PcP8p08POenPhiYu2BcOZnlXlUaFG5K80Xz6kQRNTUYDkazt9Zg/NUOH
	EIED9iGIUM2rdnVmawqMXE7ehhCDcdhc6bNEzlEX2JWXEoQlO07dRi51b0vysdez
	UrtJstnlieH2evhqpOpr//cW/pghFYH1Om4l1VibJ4ypQ1TqBxke63n3Wj25Q1fM
	oYXM1vvLyuqxZlGhb8LAwKNAiL7+KI2X3UA==
X-ME-Sender: <xms:GJFPainhc_rHji32bHQtr0iLzXhREvXF3CTZSc1Jrw3KpDRANvRCrA>
    <xme:GJFPatKi_9WMIncuE5w2it7vfuehzouU3xM4GsXc1xgFar8RwVt7Jnm5pfvCh-_K7
    Plu8oYn7Ut7lUnbRCmqMlyp9mOl0yUnBDLY-kPSf5CTG16vRIXVe-M>
X-ME-Received: <xmr:GJFPakup8A0aNPbur0tmyadtFvKMyb22nx95-MzOdxjuP2yF_G6Mn8tmPSJHtg>
X-ME-Proxy-Cause: dmFkZTEhah7gSrK85ugcDpjusH538xKH/tNlc59fvxnWezgS8nIMC5SP/YgvwWsii132jX
    mxiqe7ot+Oim0K+hjQZFlvESyWD2V7koG9FjxZtTR5r4JYjIFHXmmzVspwniH0lU8glUQL
    qcCjYbTnKl45F4V7n1kyCydwzyZ/Ix5PetK42ZSXJhRf4CFuKf/gLR8rDiVlfz5GB3t1wU
    vgLJ/EshFga1wxvyXnhMwSetqLj6bljasKNRtyA92fRRtI+VcFSxTRy/ix4mmmmaeGU70a
    G6wiIcsMpe7QxOeK4qDPB3ZTPS9T3RhUpRy3Cqpju3lEG726/L7V4qik92mIBoVzjONQcV
    grfQNMgJWwOEPbZvmE5jEqjfmLhQClCwuoyYJPKxh3GHD5gRMaCf0mmo9ee6BxB4vsr/ri
    w+XYHqEEsB+KLQPyxltyFvQI/ZxS70HRoBijqHA0v1OAhbic6Dt4qgP6u4DPRsrdaKFRiS
    rUZl0VlAGbHZ6ZnYKQ9xSjP8+RTix/EcgN+QhCuo3PRN2rXaDA+MSfnfblP/4QGk48m30O
    xtevthAh3uC5ov755sq+VRyrlUNyLn0dG3+n1H/qoW2z4MiMttp5VRdJNb+TbBF5Q8XLPm
    nlWs7Rc0w8LPn+YETkbRUde5Knnx93GDi3ffJXajtruzCeWe3F48y6dGrQMQ
X-ME-Proxy: <xmx:GJFPas_AhHetiFEfH-onbOO622kOWGAkKUKP-5Y5R4vHvqfr1p0g7w>
    <xmx:GJFPamxVaLnQL5dh0UDk6REidP2yBMKhNW-ntAjTwGnI46M21VmdDg>
    <xmx:GJFPagJtkI7eTyL5Wt5sEcPyM41jz2rdlAET3iil52bH8IoFyZUC4Q>
    <xmx:GJFPahaqG1t5wY2KSaLtWmmQfCFSa1Jx5DCG-d0UcSb5Ke7UVkRzcg>
    <xmx:GZFPasoY_72obgE-19kUQIGESo3HlFiN09xjl54nhO1u9T4qsy_6JjtG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 08:16:24 -0400 (EDT)
Date: Thu, 9 Jul 2026 13:16:22 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: usama.anjum@collabora.com, peterx@redhat.com, liam@infradead.org, 
	ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	david@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2] fs/proc/task_mmu: fix PAGEMAP_SCAN written state for
 PMD holes
Message-ID: <ak9pxTMPA4BrlUKl@thinkstation>
References: <20260708103429.150655-1-kirill@shutemov.name>
 <20260708200844.09b42937d19bf733849d2886@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708200844.09b42937d19bf733849d2886@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 378BB180002
X-Stat-Signature: xy9ffttp6u7wxmsgm55akw1qp8m7huoj
X-HE-Tag: 1783599388-833793
X-HE-Meta: U2FsdGVkX18Le1mtXWQ0YjFkm56j3ePPcdjMGNAJzLVPk1kCPuHtho9CCCh1OAl/uWeJ/9FkSoYDeDMmsjTau3XGmCwjQS1Nfvb0/YH29WB+5v5Mmyt3qc7aVvYisK+7Q57vzku4gT4sL6bIhIs0NlLfmIDG8oCGOtSE/qfseCmMkHgrbMwoTzkqPA35zosA6+TfTAq4DqeN9gDGnYZiP4H/DCB+SmPF6TLvyntDIcMrOtRCKrfQuuNzIx6jlBgWNZ54pb+s/zIxJf6h6zBbg0zj/lYjsMYuR9W7EYmMA+fB3ETT+SlXj/8OW8Gwaf/vnkix5E44lAozia9KZ0WMt1vEUVvA/vCnHVlMKcYQjL/T/+AGqDpLBURjdmopvAyu8rV3ZkxKEisC4gYC8mWAd2ic5jIogSPP5CVpNCNzsAUjJ+9tDSqyh2vbbxrdZlPy2Etzrqon66BQMfS6fgoqFyBmVWMy7L8/G1066oRGXVe9ABWfNxoOjEVsGf0oa5cU2tnWuO50zVkA0klV9oRQ6gjEPQ8XuNkjlSMQFIoByWZghzYh+2Jv41wEWDMY/CWiaJTaT2bYtaUO24vYT0vkfcIB5DPiWzFsIDSlvrvTal+0Kyr7OozPU4TEdlDl2ja43gIWBUAL5OVvr8vR7idFeZlzwDlHD159xt/OLJEQ/Q26z7dzLA+BnIdEwppPVK2mJpUGaUrba5P3n1BHfkquU7YCQ+rdWoX3Ylxp1oAWaBXERPNbUA2JixHAphodFlmYWDNiLM8PXFTzdnmx2DyE88+leqc/843EnJd5a26Y82hze2QIlnt7Dm1e8757vj7wUok5+EEMZSIswf9fpH204OAnSkVhPtW34z9cCDhTGTKJF3W+663ak7o8wukKtd9kOCLUfU3Wm/te8QQMPK/iosOEtUPWMd9sp/n2qCqMqH8dZilHqC0D0tzwN7vnYfdbaxkSkKzaqGIY7TAGKVW
 HmHPdQhK
 G3880dAMhYRTikYKbb1xuRlI2VWHwypLlsY/7R3BOthoB01T6obf0pD9nmkBTNSjvyrRTpfSY5E/rD8CnxG9LFrSs/dFa780bOM3hkk82ib/bd43lQ3H8mQZQM46wMkqEkZhS7HydI+CkfTejTHIeVDYVYqCk+nabbU4WAwycXbi66KdTcFjJJlk3DaUgXfl+2ltkJO+pSQ5Rs2WOSiDzc3CwHYQ3ydODm30KgpfGtuuTc2bd1jVTtvxmZ5NXkMTxI8GGtIxDWwck/p+nKqmQ5qhX8Dcx738D0UWmOWtJo4rUEoQMf47tA6D5TeRUWB1VgLEwLsLPoATV+C1xUXEkVFvwXnBzggQSIBM1pW4KYJ9vgZ6ngWbQ3QJvOnBBxFWUZ/lEDKowjxwQI7MeEZA1qNtKLGAo+5WO/XGUCAmlu374PYVRPWiTta95WJVwF9ptXDimUUWBTVS9+oqUE5cPbMjJFc08bk+BXzk39uMWFUunAEnVJq+WiSsnNs4AFZsKET6hitFMmQfNsOFAPEcNu97Quxo8Ctd6Vo3Ky7DRfeJzk92VbunHuMQ3iaZ25XRVIFP3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 08:08:44PM -0700, Andrew Morton wrote:
> On Wed,  8 Jul 2026 11:34:29 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > PAGEMAP_SCAN reports an unpopulated PTE in a uffd-wp VMA as written
> > (pagemap_page_category() and the PAGE_IS_WRITTEN fast path), but a range
> > with no page table at all -- a PMD hole -- is skipped.
> > pagemap_scan_pte_hole() evaluates the hole against p->cur_vma_category,
> > which pagemap_scan_test_walk() builds from only PAGE_IS_WPALLOWED and
> > PAGE_IS_SOFT_DIRTY, so PAGE_IS_WRITTEN is never set: the hole is neither
> > reported nor, under PM_SCAN_WP_MATCHING, armed.
> > 
> > This is reachable. An anonymous THP is write-protected in place as a huge
> > PMD (change_huge_pmd(), anon is not split), and a full-PMD MADV_DONTNEED
> > clears it to pmd_none. A WP-async consumer such as CRIU then misses the
> > 2MB drop -- the range is not reported written and the next incremental
> > dump keeps stale data. (A file/shmem THP is split on write-protect, so a
> > later DONTNEED leaves a populated page table of pte_none entries, which
> > are already reported; only anon THP reaches the hole path.)
> > 
> > Add PAGE_IS_WRITTEN to the categories evaluated for a hole in a
> > non-hugetlb uffd-wp VMA, matching the pte_none handling in
> > pagemap_page_category(). The existing PM_SCAN_WP_MATCHING path then also
> > arms the range: uffd_wp_range() allocates the page table and installs
> > markers under WP_UNPOPULATED, so the next scan sees it clean until
> > re-written.
> > 
> > hugetlb is excluded on purpose: an allocated-but-empty huge entry reads
> > as not-written via pagemap_hugetlb_category(), so reporting an
> > unallocated hugetlb hole (which also reaches this path) as written would
> > be inconsistent within the same VMA. hugetlb hole handling is left as-is.
> > 
> > Add a pagemap_ioctl selftest that forms an anon THP, drops it with
> > MADV_DONTNEED and checks the resulting PMD hole is reported written.
> 
> hoo boy, that was heavy going.

Will make it brief in v3.

> > Assisted-by: Claude:claude-fable-5
> 
> OK ;)
> 
> But what do our users see?  afaict the result of the bug is "the next
> incremental CRIU dump keeps stale data".  Why is this a problem?  How
> would operators look at a user bug report and figure out that this
> patch will address it?

The core point is that MADV_DONTNEED has fill-with-zeros semantics and
should be treated as write for write-tracking purposes.

Ideally, we want to have PMD marker here, but we don't have enough infra
to handle non-present PMD entries. Usama works on this.

> Is there some Reported-by/Closes?

Closes: https://sashiko.dev/#/patchset/20260707151349.92143-1-kirill@shutemov.name

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

