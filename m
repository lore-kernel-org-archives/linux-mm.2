Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94681FC72CB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA026B00A7; Sun, 22 Mar 2026 12:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AA46B00A8; Sun, 22 Mar 2026 12:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70A56B00AB; Sun, 22 Mar 2026 12:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 921496B00A7
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:30:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A6F38C66F
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:30:42 +0000 (UTC)
X-FDA: 84574237524.15.8007174
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4A6B140011
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:30:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LeTkX1Br;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774197040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D+ZF+otkFviPY98XYLdHdK9Xx3/CvrB4tIX1lMKECaA=;
	b=nFWOPzt65kY2N7PL68S3ifptI7T/zOqg6ilkJySERa5uXkJXUO1/dQnYsw+ozm4nY4Vwan
	wYJXuFIUgvWb4TrEtXKwx7tM+7EPG2ERxlrVT+ZemvZyW97rJJbER2WGiiv7sj9v7mtjgu
	7Pl9cqD3VLCvp4eQbUtdFxaDdMNqsy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774197040; a=rsa-sha256;
	cv=none;
	b=ci06CLueDjqFg1GgtFv3YnoeZ/nbked01zZNmaX6mx2ap//dLgopK/E6kcgA9sYINlnYPE
	bKOOHC5QYenx8RQh25o1UltpEVFssYH49AwPSXLcxWA5YElZ9ORrR9mnegv3AgYYXonBEd
	Nx7fAUqrOtJlxKRkBFH7yGdZY2BUAfQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LeTkX1Br;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3507A418D2;
	Sun, 22 Mar 2026 16:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A872DC19424;
	Sun, 22 Mar 2026 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774197039;
	bh=x1lYQ+SKQla8gR4ZqJZh/SOIDQqj99rU27YfBxGWgUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LeTkX1BrqPg1yDyhaeOy+mhb4CF/doeGewbsiYhfQTm8829HchiWbyuw2uwJXrgP+
	 KrjM+yUz/3IU2zJfB2Fx4gWXiLyvHXKgYPsAlyTO+dBJfgdglst32y9XYR1k1zXjSL
	 EF5RXyoan0yKQWHKlt307EFH7u47lkJ4R63HjziA=
Date: Sun, 22 Mar 2026 09:30:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
 linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 0/2] mm/swap, PM: hibernate: fix swapoff race and
 optimize swap
Message-Id: <20260322093038.25a7fd51f5d564b85815db7a@linux-foundation.org>
In-Reply-To: <ab/E5SaSAlAKLCwD@yjaykim-PowerEdge-T330>
References: <20260321103309.439265-1-youngjun.park@lge.com>
	<20260321105921.19388b7acbc0f8d6036e29a7@linux-foundation.org>
	<ab/E5SaSAlAKLCwD@yjaykim-PowerEdge-T330>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 381sry9ogxsj1qp1g7gtc1rky17cfxju
X-Rspamd-Queue-Id: 4A6B140011
X-Rspamd-Server: rspam03
X-HE-Tag: 1774197040-189986
X-HE-Meta: U2FsdGVkX189vGiDEatpQ7unRIidnEYgrusP3mxTa3OO8IXLuKtySDLiKTjU1eUcPbRBPMsLyfAN7zE40ZaqKUYd8/w70Nl0RMOPddgMMz68mXrL64xHareXWXtlUX+s1TxG7LOaKNwoBk5K73cIdhldH8/gAcGfq0m2a9Hi/VaUlIsxE1rAQLaCMB1mAl07bEs4vlwkS4wHzGzh/po6LWVuXujZG8cfZE6FkEuslVV5z3z/Zj2pMBXnLvmnvudcmL22nd45h/yE6GMvaXtoB+IH58YgEvXdG/Jktug2zq3xV4UoswrsUeyWFmXQOjY12labHEgsxFN/fvA7pImqImukS4zgO0gnupkVan6mZAOOVvaswbwal8jUnbWgJM+R0So61iV1UTPuANB53K0hAt9y6cR3Q/nvWbwqqPDMkM8+huT0ULfFsAFimZAh1wWMk2j6sSRkKP6gs6PfVGEGgyzKq3Lpofp6pW9dpmKgdgIlbhaKgoJCnBeIbJKlVOXSuQuHwkmonRJoUECaKRV+w2XeX1CIZWRofiwb2xzP4G9bXVINymbxApfhcNXRjWCJpJsY5ud7IA03d44p2BmzrqA1J8l2FkCVjpJdXybTMNb48/coqUPyeSU+Td/5rKabPq4EW5TJDpMQb+HhyJOxhrpnizjP5XCMizqWj+L1WbU9azUW/H/DO97POxYCRABe8JSHyqqjqyZbvEvy9zQrIkkkc3Wy09W6UpytE24+p3/Cqdxt2XSFQ/e3cwt94hr0UWHCj5c/Vl6cxgmnblQzlmK9v0vBiDpDnAACaAWDt2tv8q0xu50qgyRBPqN/RPxbgoxpm84pqTNtIn4NwfEOFuBMxDJStSqMDlLhPgmZV6zYwiQ4QLQ5FtB7Gs+ZT/XqLivleaR88f1SIlGz2NsG2WmQQtd/gOoGL2bWi2lK+yHpYScGYDKPO2lG3YuftT+nAosna5doqAsYF+BqF2a
 xOtbDCBy
 vyi/c4Vm+NK9+oWEt4+pgCbd+iv522ECACOnbZK1NHaqaDuzuQV6nR+QLCef4SalvhEJrshw/xpqWt/c2zfiSCRivaeki6TGUwLmCgN2WHsCPwQKTTAw/vrwp8nz2+KXKlZfGM03DN+7hdakNBvSBLrgowj3WzEXPCCIbfncza6KqwvojuaoCuN9JZnIZXB6Cv0Dp9MLZpvkMNAv2E5i/fkiQ6KdT0YNB7CBWyMVt+D7ZahR88fpc8tNZ3MwoBJgN4M4XyFI6cIGyhDQqH0lbKsFEcrwniv/BW18IlYW5uOJ/S6eQLCZTudHIVu2wh1IFXCio
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 19:31:01 +0900 YoungJun Park <youngjun.park@lge.com> wrote:

> 1. Grab cont_lock on the SWP_HIBERNATION set path, or grab
>    swap_lock in add_swap_count_continuation(). This would
>    serialize the race, but adds lock contention on a path
>    that doesn't really need it.
> 
> 2. Convert si->flags to atomic ops. This would be the correct
>    fix, but is quite extensive and better suited as a separate
>    effort.
> 
> However, on mm-new, Kairui's series [1] has removed
> add_swap_count_continuation() and SWP_CONTINUED entirely, so
> this race path no longer exists (verified by code inspection
> and AI review on mm-new).
> 
> [1] https://lore.kernel.org/linux-mm/20260128-swap-table-p3-v2-9-fe0b67ef0215@tencent.com/
> 
> I based this series on v7.0-rc4 per Rafael's request since it
> depends on PM-side changes. I'm not very familiar with how
> cross-subsystem dependencies are typically coordinated -- if
> rebasing onto mm-new is an option, the race goes away and the
> PM-side changes could be picked up separately. Would that be
> a reasonable approach? I'd appreciate any guidance on this.

The kernel/power/ changes are small.  How about we prepare all this
against mm-new and ask Rafael for an ack?

> On a side note -- the AI review is becoming genuinely useful.
> It might be worth having it gate-check patches before they hit
> the mailing list, rather than reviewing after the fact.

Totally agree.  Problem is, these review are expensive and permitting
people to check their work before publishing could be terribly abused -
anyone in the world gets free patch review.  I don't think Google wants
to pay for that!

Hopefully over time, as engineers see the value in this tool they will
persuade their employers to purchase the tokens they need for such
screening work.


