Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC78FC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9836B051C; Thu, 13 Aug 2026 11:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80E86B051E; Thu, 13 Aug 2026 11:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96C96B051F; Thu, 13 Aug 2026 11:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAE756B051C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:04:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26536801B5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:04:10 +0000 (UTC)
X-FDA: 85096566660.24.CE1F9D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C9791C000E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:04:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+aUHZOz;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786633448;
	b=rTKRuRSzBgyZ+TXfSPelmgqgAGmaminZi+H/wrInH2d8c3utIOQ78LgL31npLgc7GVZTgP
	FQZyJKGRLeFSKss/DWnX2yGf81dReQ5tQ5poTZQxnOoIjCGifNAWWRETPlun5hNHLzxkOl
	MmFs4GcvwtLcCO0peBkFOkJ5NCCohzU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+aUHZOz;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786633448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+IcpL4FUK+slbgv+e2vr2PmdccWWDUBCgZJ5jExmbo=;
	b=bEee+xtR7qGTnChVXFT9csuNCAjPMi2bOxUk+9K8yEtJXcdLAS9FrzX9TLGmm8me6mDgGa
	E7fAqZQFiveyD/XtHg9x31BvMTgQByKkGHWoVXK0EYky6PxyBzZJNCBIPXMwm69AeCPy8p
	F3XdTF/uYVA4t/YECKoq5kQN+8fB3d4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC8B140D8E;
	Thu, 13 Aug 2026 15:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB621F000E9;
	Thu, 13 Aug 2026 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786633447;
	bh=P+IcpL4FUK+slbgv+e2vr2PmdccWWDUBCgZJ5jExmbo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=i+aUHZOz005VYfYTHNALqNr/DML/dBtDhHeQjUmy3WC1EMYA6Ksjn7p24+hutdig3
	 j3gmjbNZqncq6TxIt0b+sDlWVsCwFHjQBmGB7EKQ7tzYLz/VhAgejZDFoWP5tk3rbc
	 PcgcfetZwWpKpPosRnPQBhREE31MTZa5Dzoa57w7/GXYs+oPEkeQv43h9RiByUW5Zc
	 w688xdLD6hRTl7uSABowBp1rteG6FnvAXS+RzozSOPI8jq+EPp+UdRW7DE8640OBlC
	 2/9WF2HGQ3ZGlR3V9fTfWMb+RTshdLVM94b52RqEgGwKBydTbfMU2r21GZwHtrdEAm
	 stqnjYghWpHuw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 05/18] selftests/mm: keep khugepaged out of the
 swapout the swap cases set up
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260812132304.199287-6-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
 <20260812132304.199287-6-kirill@shutemov.name>
Date: Thu, 13 Aug 2026 18:03:34 +0300
Message-Id: <178663341429.2230969.913958776768961527.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 7C9791C000E
X-Rspam-User: 
X-Stat-Signature: uogfdkgmm5ujpw99jfzdftdyo8jm5zy3
X-Rspamd-Server: rspam06
X-HE-Tag: 1786633448-440548
X-HE-Meta: U2FsdGVkX19lsjQauaBFoUdbQsqCPFM7kctwnX6pvPbuj9KcjFNjbru6HFYueCtT7yR+IGE+CGDOD4ZQ5QifbenVjkwtMehQGSpe3bncgdgsPS1CZCaA5y5JMQKIqqX6Z1j3BNJvZLSIIFfv16ce7exu6hfhkAtVZVjyYkOYa6wIRmPc7B1bCGUHrIv/Ws25Z34e6WKNDi4ri8kpx8/A+HB4dxyplyv0C9Ewy0ld+S00oF3ji1pZH7I7Nf4jG7hla64AL+uigPJie5/tCdw77eBMbATayCdNbV0EIcuy59xfuDALr6P6G7CPcKTRWc4xnLBjOlzo7Ymvl27a8KI5E8vYbgCf1Lrjbq1/D+8aeHVFr58SvwgTUL+DZUTqdSI2uUlM9f83OwPgp/N3KIImvncQSvkJQa4fNrNrR9Ee6xTH1qMIiSxIuAroAUyt+p1P5063wn4myjiYVGiMkAMohZmaZnSvV/eCKZ9QEbvAcVUXAQetQP6mR2oXa8H57y3dIHegjbND1Q2WVdzDnaoGkYFyN/MNFXyKlkgGsPtUlIrmqFxXgpzSnXmanDeAsqivAyc7iXBXFhua/y1mHq2iNuxHsEfZkiXsiYGlz5r4Kyv8KxJokg6EPIGrY7fLwvFHWmCP+azy7Ox8d6Y4aUaY5pJUseKC486Ufuv5rrOwJw8WQMkU9zYc4HTKmNIBxwUGx29iKCY9kAGdNSIO5EZDvWkyCC5WWLgrWe6Q74zY450+QqrFG4McV3JpMDbPnxziyb+YnqeH2WCodj/BEa4tkxsyQYBxzjRuRelpDtz9FBNRRU1OyhN3nJdMbRuoXAuCe9L7Oc17YvrstfIIPplSHnU77SzlHV1rEZBTSRPJzgkr+vdtgJQhKFeXhztE8u8Z3HuwtqYlFJkaTCphQ536ormWYX9Vqon/lg5xMpx4rxg4WbQkDt+T0kRPx4Dk8uWbuI7zX613YhW/h/IwZUM
 uGUoKDjN
 kuWKW9joc3ifh7fM0oXnfG2gQCEPSldi01k1jgI/WdYpNVlZooJPm3tEqHho/Mm3LJ/cDi9fw1CdndXgRwjZcXJKzsJbE3osbD9AoAUX/0oLyH/370tYjh95mDYGM2FmRm7WJJvg+2KiCZvArfhIrT0xHKxBZaCoOlOcgo7hzfDXgVO+pOfVOWPcVwm/rf8HrzVUWWkc+SsBCyj3jaRVvVLRJW/L31Oqwmqyo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> selftests/mm: keep khugepaged out of the swapout the swap cases set up                                                                                           

Huh?

> collapse_swapin_single_pte() and collapse_max_ptes_swap() page a range out

Maybe "page out a range"? or even swap out?

> and then require smaps to report exactly the count they asked for.  Two
> things keep it from arriving.  MADV_PAGEOUT is best effort, so the count
> often turns up a moment late.  And wait_for_scan() leaves MADV_HUGEPAGE
> behind, so khugepaged is still working on the range: collapsing one with up
> to max_ptes_swap pages swapped out means reading them back in, and the
> daemon empties the swap as fast as the case fills it.  On arm64 with 64K
> pages, where max_ptes_swap is 1024 pages, that is 64M a step and the case
> loses:

Splitting to paragraphs would help I think. And maybe rewriting by hand
rather then instructing claude.

>   # Swapout 1024 of 8192 pages... Fail
>   not ok 10 collapse_max_ptes_swap
> 
> Ask again for up to two seconds, with the range held out of the daemon's
> reach while asking.  The collapse each case runs next puts MADV_HUGEPAGE
> back, so only the setup is affected.
> 
> If the pages still will not go, skip.  is_swap_enabled() covers a machine
> with no swap; what is left -- swap too small, full, capped by a memcg, busy
> with writeback -- is not the kernel under test refusing.  An error from
> madvise() itself still ends the run.

This commit message broke me, I'm going to skip the remaining patches
for now.

-- 
Sincerely yours,
Mike.


