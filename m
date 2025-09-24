Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D857DCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFF18E0013; Wed, 24 Sep 2025 06:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36FDB8E0001; Wed, 24 Sep 2025 06:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2860B8E0013; Wed, 24 Sep 2025 06:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 172768E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:02:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 853E31407C4
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:02:27 +0000 (UTC)
X-FDA: 83923703934.20.8668DC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 273E810000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:02:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sN4TFCft2/wZSXIELr5RHWTzLUBfhTJlV5b+crUf6Vc=;
	b=zy0pyJTw5umrTBjqyozLiXp1AfISrSl2tWi+52vhP9ZMixUUz3Fl3DAymw7WniMpr8ADTB
	fnJItgOji+ifU9qbiKZdzVjoNR929id1d77m3CxltWbzuhpySmP9p8EPpKyUoOhoGkdtVw
	51gjUEVgURyfPJrL+8zxFzIHmO4hXgo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708146; a=rsa-sha256;
	cv=none;
	b=MUkqy0viu12fX9nd/kmWQakdhnPa2AfIO4tI0y7uvZWXiu023hJT9SDtA+DC54ROUiwWVW
	PoXjhqDyHv5qe91RMrQSumW1paqtc2RSVnF3kT0jwbvfoQ2I2s8JA/YBhGqZiL65p46sNP
	ZVUEJxM6/JcxYZnDGNKF0nlclfqkk1Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 717B6600AA;
	Wed, 24 Sep 2025 10:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36D5C4CEE7;
	Wed, 24 Sep 2025 09:59:49 +0000 (UTC)
Date: Wed, 24 Sep 2025 10:59:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, usamaarif642@gmail.com,
	yuzhao@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
	cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
	kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
	surenb@google.com, hughd@google.com, willy@infradead.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, qun-wei.lin@mediatek.com,
	Andrew.Yang@mediatek.com, casper.li@mediatek.com,
	chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Message-ID: <aNPA--5AcqeFd6nl@arm.com>
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com>
 <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com>
 <aNLHexcNI53HQ46A@arm.com>
 <f2fe9c01-2a8d-4de9-abd5-dbb86d15a37b@linux.dev>
 <aNOwuKmbAaMaEMb7@arm.com>
 <17dabd83-0849-44c9-b4a2-196af60d9676@redhat.com>
 <aNO7MrQt9oPT8Hic@arm.com>
 <791e0d59-0eb2-481f-bf8b-ba4b413d5ebd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <791e0d59-0eb2-481f-bf8b-ba4b413d5ebd@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 273E810000F
X-Stat-Signature: beb9dmatxgjgsk7sf4aq7xfdyd79y7or
X-Rspam-User: 
X-HE-Tag: 1758708146-684865
X-HE-Meta: U2FsdGVkX18eUVMPRkkz2tEb4BhjE5pfLHPU/LxLJkSEFkGUIeFQQ01+OEL4q9Iu2NZpDH40755ybVGxuCAXTDXKvRSaWT2SY/EnmGiLQn9MvpR+WHsB668SsWq34NZui0m5RkCR2LuwkVAtUv5A57Xqt5mg0KNtQsNI+c7kRtUqYvHcpB1QfTtiigLkUxkVDuOmiBKgxVBx6ga/YPD6ZC2cna2EWOfwqilxZzPxneGa4TMjHsd/bul2+btZvnRqtDy+b0k4peyKpMJT9drR9Xrz5xY+CKcIyuE8YWArye+aBW653D2uKS9zjxYFpsJbvD0f7L499D7gSRekiZYAxGl+OGsAu3TDIgoBWji8c2d50ObHKJTB0GdBjQXArlDaQnjhpBAahpp5wru+GvxRvgRIp50597i/x2KGM6ezTj9n/AqY16+kQuB7hnVC3wr/OvjPcAZVjUYVIA2GMpNbXXXjNGHY9cQUL8e+CBaDggk/XGOYUwQD0MngOOTQqRxcrO1X1sN+UizcoQhEyQmxhXV0hrbzc7VJXLTN/Ajd1XBUPIp6H34VsOQoqCX7ekILD/SigF8c/+WD0ws6OruvMrko5Vre/ZXCCWIwwPRkhItgQxzVh92GrkER8Jt3ntOEfNXFo2opBbResIdMk8nrs2cCUguCQDRbrO8Q0l4EXL6PyhCc+GiE/sSEUM+WBbrf/QwTMdFMSnT9Nt9M9N7vzJOKTGwmCRvnPua2roNpff7jt6O/gfsLafO+FLlEWW2F3BLH6tI9kq3m4krMoDbfsyzoLcFuy19i0LpbnMMlDW1IXn3MXVCdyFnG8Gic2wClqlLv+Nh31S8SDEgMXAisfHTtmpHyUxNf1HZmUJYMfaGYmkGjGEJRVcR2IUQ85+S17lmeDg2cFHnHiLV0CvCtOlmlAteWO0CrZ5KUm4oNe43oNd2SlMMIM+2yBtsRnvNWGFvCQzzi3NvcS4v0zUR
 taJPiN1F
 1RJji1WdFNpYwa4JqG6WxrTy5LB9inr6VpFL+l5TyNmUIXwwF74uZCp+Ru7zk6GKX+uBJ/GE4al4fSMnOTRd2R55ktB3kaJ17nu9U9WApqhjINjfKbrR1JbqEEJY2BHc7drkGzEyKxWjE8x0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 11:44:19AM +0200, David Hildenbrand wrote:
> On 24.09.25 11:34, Catalin Marinas wrote:
> > On Wed, Sep 24, 2025 at 11:13:18AM +0200, David Hildenbrand wrote:
> > > On 24.09.25 10:50, Catalin Marinas wrote:
> > > > On Wed, Sep 24, 2025 at 10:49:27AM +0800, Lance Yang wrote:
> > > > > On 2025/9/24 00:14, Catalin Marinas wrote:
> > > > > > So alternative patch that also fixes the deferred struct page init (on
> > > > > > the assumptions that the zero page is always mapped as pte_special():
> > > > > 
> > > > > I can confirm that this alternative patch also works correctly; my tests
> > > > > for MTE all pass ;)
> > > > 
> > > > Thanks Lance for testing. I'll post one of the variants today.
> > > > 
> > > > > This looks like a better fix since it solves the boot hang issue too.
> > > > 
> > > > In principle, yes, until I tracked down why I changed it in the first
> > > > place - 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to
> > > > the zero page"). ptrace() can read tags from PROT_MTE mappings and we
> > > > want to allow reading zeroes as well if the page points to the zero
> > > > page. Not flagging the page as PG_mte_tagged caused issues.
> > > > 
> > > > I can change the logic in the ptrace() code, I just need to figure out
> > > > what happens to the huge zero page. Ideally we should treat both in the
> > > > same way but, AFAICT, we don't use pmd_mkspecial() on the huge zero
> > > > page, so it gets flagged with PG_mte_tagged.
> > > 
> > > I changed that recently :) The huge zero folio will now always have
> > > pmd_special() set.
> > 
> > Oh, which commit was this? It means that we can end up with
> > uninitialised tags if we have a PROT_MTE huge zero page since
> > set_pmd_at/set_pte_at() skips mte_sync_tags().
> 
> This one:
> 
> commit d82d09e482199e6bbc204df10b2082f764cbe1f4
> Author: David Hildenbrand <david@redhat.com>
> Date:   Mon Aug 11 13:26:25 2025 +0200
> 
>     mm/huge_memory: mark PMD mappings of the huge zero folio special
> 
>     The huge zero folio is refcounted (+mapcounted -- is that a word?)
>     differently than "normal" folios, similarly (but different) to the
>     ordinary shared zeropage.
> 
> 
> It should be in mm-stable, to go upstream in the upcoming merge window. It's
> been lurking in -next for a while now.

Thanks. At least it's something to address in the next kernel version. I
need to improve the MTE kselftests to catch the zero page scenarios.

> As it behaves just like the ordinary shared zeropage now, would we have to
> zero/initialize the tags after allocating it?

Yes. Before pmd_special(), it was be done lazily via set_pmd_at(). I
think it just needs a __GFP_ZEROTAGS. The only other place we use this
flag is in vma_alloc_zeroed_movable_folio(), as an optimisation to avoid
a separate loop for zeroing the tags after data.

-- 
Catalin

