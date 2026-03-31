Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F6C01061B29
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 00:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381A06B0092; Mon, 30 Mar 2026 20:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359916B0095; Mon, 30 Mar 2026 20:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296556B0096; Mon, 30 Mar 2026 20:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1834A6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:02:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4536BBA00
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:02:06 +0000 (UTC)
X-FDA: 84604405452.19.E280C2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E701F120014
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:02:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tLyY51Zj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774915325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5v5q/Yfbr5sXpjXxSwInv9QdBWfMg6KlS6V0QEB1RjQ=;
	b=YdjWg4tNVVhD1yT0DkCCuvUs00qS5za383YmY+Hc+gUynK3M+gtfAnxbKkoAFvDEG/vryR
	BfwYHxEn870rtL8qJP3kffJrgjvWddj4R371HxnMcWNULbp/OAbaSGiEOF2Db0rG6sj2kK
	UNtZNgLjmkidWzEWYrgA3ghDHXgtikg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774915325; a=rsa-sha256;
	cv=none;
	b=fn4B+Y9w2Wp0TfefaCHTeqtQKoatkO9e0A1yc9YsbJg9kTo7pFnmD10d/vLCiO6UAcN8ZB
	IGd0+tu+2KYTfZwpBcaH5PH4laa9InV/iVa3evw+XRe/xUYbqDH4kCQqsdRHuu3oY850EX
	/aTDxc0hg4CSIVJflwSBuWtILUV5ivk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tLyY51Zj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9A3F42A8B;
	Tue, 31 Mar 2026 00:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F017CC4CEF7;
	Tue, 31 Mar 2026 00:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774915323;
	bh=XVAKfu7eLmfU1HifJAIhaEimRjzexU0fRODDV7Mv2Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLyY51ZjAd+HGv4Qeywe9qZLh2eUWwzqfw9wMkpienVW+me74TVlD8nDEVcazHsRm
	 bmh0cDrpGBkLkSDzswF6+AkftWZT18277IBzBFbPdiEOfSkccUFufjFH58Zui+RDnE
	 aGKQccLDaeFyV7t9oP5YM9HWq+wRsprckZgSV67oe8GEvgUllBe6kbCZdV16+lq+m+
	 DsBvkxbOBV69l3ONaFRqlqi5HXGUvf6JioyfoGbe6fziSoyPaGWzD6tif2xKZ4FGJM
	 vF3KOpBSW7aImNoL0bIvPjBQO4WT8UQVHslvEj/ZTI0u4kWJJJ0xHbyjWBkhYAe0nC
	 w0y5di0OJOIuw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: gutierrez.asier@huawei-partners.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: (sashiko review) [PATCH v1 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Mon, 30 Mar 2026 17:01:59 -0700
Message-ID: <20260331000200.4897-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330234337.4456-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E701F120014
X-Stat-Signature: sx5xuwmf74edsfndn95jhag5455zxqye
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774915324-128397
X-HE-Meta: U2FsdGVkX18r2KS5upiQAkpN8zP/vGnM06Tz0d9oHNL8IRVwNkFi+ODFjM+Glny+fkCx22zsW/vW0uwVZ8ob2mO4G6YfsXWOTelsxeRnqT5SmfQzYvaDyfQXqa94r3RcF67cYSvIbNueqIlAyjJQO1Ku2OpXVRwF4V15spHzpyaVnAGz4yg6T4gD29kwptInh3WfYRQMSBhI9pwjtof/Iji91ZTYYIXOHtRswnAzArmJql3t97AHKmMNBFtwndfIXxgciitWf+viKeUfM+ZY0cZno4j8yYPID/4udtIjDzZIexGAXywLJ5sl2nD0Q/pHYaZN51tDQkvxh2Xeym6TJLXfFU/UDVEap5LrQySHGYETsvBuGVP12xHd5cd87fctI47f81p0bO7dGVvdLW1nHbGMaZktJNsvGP0zn7dCeOAR7jeS/aFxPvrYLi2ZmgyUyaLQj46p88n3IKVxYuKb+xy26hLoTxGLHrMAB9uwL+7kkkbPlNTMF81uBJ04AmOPo67loGdHoy+raJutooKObTxovlOhggAFDEMRckr24pXv6biqt0Ah9zwipnl+tq1Hq2UIYM0wV/ddG1UovWbO5ly/PDfHhNAAamROJerb6Cw2XtgqFkGhF7w/qMwDjqoV71+pHsrLxUwXY+GWZXGrAVZevFRVW+glp13Mnit+5CiIVd9esV28pG8w4BiyfqDGQB2AXtv3TXP+6e82HF7XnVYlxdJTWp65WsPz3eaJUYgu15RehNLuz9Y2cUFzXMKSgOQkesFB9Uh5apaln1A3fe0m40+XIKXGzDR5HxM3lfkbbW4Tv7P7WmIrS+1TtA85ehzT1b0vg3ZFEgAcidLDgJriFiOq9eSJQU50c49dISxg+vDcVOKWOwVyjnv3DaneKMVOkDYXimbFnm9ctpIXARQ/ILaqcajIiWNoGfCyKZrsNNrl8L7UVrSISAMFCe/f3RneVCZNKOBZgioef9c
 zgxDPKTL
 3seKk6t5nJ7LJotoVdb0O9WbaYbZUQUN8y31xWXFbQ/yKemmqu3ckUeBruBrd9wtV7BdxQZMUdplLHrTVXhxptQ173F87VjUNtd3unTRbtXCNHieF+645sZruoaAZo35UNDm0B8Zp8D0iS01FNECpFhWgQKZ36QbI1sLTtbIYRMTp3RPsSzvLwk0Hjf/UGrJHccEzlSk0kSe44zJNG3TEb3/an3ViuTqAeeyIJRxtspfVnMHlb136pO/+307IcxeSm5sruA35s7gv1P95oYm8JzvUNmhqBBuvs5uD6wodAuCsmwTEHBlAt9lwy47T+F8gNMdopSBxvMe5ABbI7EoOm+qsiSVAZNE/gv9U9l/oZogQdik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc madvise developers (maintainers and reviewers).

On Mon, 30 Mar 2026 16:43:37 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260330145758.2115502-1-gutierrez.asier@huawei-partners.com
> # start of sashiko.dev inline review
> commit cd78854e55ee90102333f0331c58417c16e8d798
> Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
> 
> This commit introduces the DAMOS_COLLAPSE action to DAMON. It allows DAMON
> to synchronously collapse memory regions into huge pages by leveraging the
> existing MADV_COLLAPSE mechanism.
> 
> Link: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
> 
> [ ... ]
> 
> > diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> > index b069dbc7e3d2..dd5f2d7027ac 100644
> > --- a/mm/damon/vaddr.c
> > +++ b/mm/damon/vaddr.c
> > @@ -903,6 +903,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
> >  	case DAMOS_NOHUGEPAGE:
> >  		madv_action = MADV_NOHUGEPAGE;
> >  		break;
> > +	case DAMOS_COLLAPSE:
> > +		madv_action = MADV_COLLAPSE;
> 
> Could exposing MADV_COLLAPSE to automated continuous execution via DAMOS
> trigger a pre-existing use-after-free in the core madvise logic?
> 
> In madvise_collapse(), the lock_dropped boolean tracks whether the lock is
> currently dropped and tells madvise_walk_vmas() if the lock was ever dropped.
> 
> If collapse_single_pmd() drops the mmap lock, *lock_dropped is set to true.
> On the next loop iteration, madvise_collapse() re-acquires the lock,
> validates the VMA, and resets *lock_dropped = false to avoid double-locking.
> If a subsequent iteration does not drop the lock, the function returns to
> madvise_walk_vmas() with lock_dropped set to false.
> 
> Because madvise_walk_vmas() sees false, it assumes the lock was continuously
> held and the original VMA pointer is still safe. However, another thread
> could have freed the original VMA while the lock was temporarily dropped,
> leading to a use-after-free when madvise_walk_vmas() dereferences
> vma->vm_end.
> 
> While this flaw pre-dates this patch,

It sounds like sashiko is saying the bug still exists and not yet fixed.
madivse() deveopers, could you please confirm if it is true?

> does introducing DAMOS_COLLAPSE expose
> it to continuous background execution by kdamond, making the race condition
> much more likely to occur in practice?

DAMOS_COLLAPSE simply calls do_madvise(), so I think it shouldn't be different
from user space programs calling madvise(MADV_COLLAPSE).  Hence I don't think
this patch is making something worse.

Nonetheless, (if my undertanding of sashiko's argument is not a hallucination
but a real), I agree this change could help the bug triggered more frequently
if DAMOS_COLLAPSE is adopted by more people faster than the bugfix is merged.
If that's the canse and it concerns madvise() developers, I think we can hold
this patch or adjust the scheudles to ensure this patch is merged only after
the MADV_COLLAPSE bug fix.  madvise() developers, please let us know if you
think such hold or schedule adjustment is needed.


Thanks,
SJ

[...]

