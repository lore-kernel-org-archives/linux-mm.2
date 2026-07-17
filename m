Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A65C4450F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 06:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955736B009D; Fri, 17 Jul 2026 02:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906636B009E; Fri, 17 Jul 2026 02:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F646B009F; Fri, 17 Jul 2026 02:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA616B009D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:46:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38AB112048E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:46:49 +0000 (UTC)
X-FDA: 84997335738.27.4059F85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98BC5C0002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:46:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBafwYvE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784270807;
	b=q4woRYPzCsS2Jm0fk76iFRCvdgNumRs3g48apC/jiXaAjveaY6lUnPwMyNHiK+KKpArmT3
	7gfKONMVMRv6abOfuEsKXB+K6JsIBkviSqyGMJFnCms9JytgMl37HEswM2UPziEUIQgCq+
	19GO0LsNhCKf1ehbGyh83lOYlrrNmTc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BBafwYvE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784270807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKXbEP5sSqxrG6do/l3oqh6oY1qmcTSdJKyv4PfqhKc=;
	b=zvP8pg43MLWpNpzc6kkptsTWfQzz61u0x7P7m/HcQS6ewOaoh5HKSmuzr80YbdOMzPNfxt
	zG9zPhe2YBx1014fPonDmEE/+hwYGh/KBPqarmWvpB4AzNQd0Ecqg/ozr9D7JihZEEH1eS
	sWWyhl4TAnixaMuFFht97zOdUNKaYbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D6A040B24;
	Fri, 17 Jul 2026 06:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4AA1F000E9;
	Fri, 17 Jul 2026 06:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784270806;
	bh=JKXbEP5sSqxrG6do/l3oqh6oY1qmcTSdJKyv4PfqhKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BBafwYvEfSE6hpwsOqF2/uaWrqE+TQsBipAX8MMY3Sxwh4bSvGC3p4Eu8kg4ZvNCE
	 lKJFaFU06pnCW3itM/r9962FcWJwYEbfhK1Yvg6e7tkc6b6o68VMUrw3s35hBNSA+W
	 45UhoMH21d5wNPwebHBLMel3uHZ7WSmgBxquf3nlKK8NSbnIIHF7Dju5RDgExyemws
	 3D0AALeeX6qoxwQv1xWSmkf6Tx+xkjLB8hFcih7BkCG5wF8xmIV4//8CKTi7Zdcqcl
	 mxtYENbDaBMFbPdVLnwDw93Xc7NLAu8DapgwQ5e7afjD8//sKH3mp7+6C0it7XLCOF
	 lWxLc5t/rimCw==
Date: Fri, 17 Jul 2026 09:46:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: david@kernel.org, osalvador@suse.de, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm: add missing alloc_percpu() NULL check in hotplug init
Message-ID: <alnPz-r76FU6t5Uc@kernel.org>
References: <20260717052938.58447-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717052938.58447-1-hongfu.li@linux.dev>
X-Rspamd-Queue-Id: 98BC5C0002
X-Rspam-User: 
X-Stat-Signature: hnq1e7brihteosudcu5gjmxknfep73bc
X-Rspamd-Server: rspam03
X-HE-Tag: 1784270807-472499
X-HE-Meta: U2FsdGVkX18OivWvCnBKxjIoFDavrwnerAH2GD0Oftnb+kzzK5VgloA2aqFQHXfu/fdZ21qgwV2xfYIkpnv/RHhiRUn+JzzZbricQ2OFW0QIZG68zIv40FogvBNDcAKwpGltFUzczUkPX7EAbb3ZTac/sHAEvdCpPN6dsw4iXY48t6J0cff6rKn+gTDzWKs/c0JC9ORlJMFV/MTT8L5pnxm0J+aiQ7CNl7qKYDfCDGWkfM0fBsRCNLoTVKx602jKBuHHcuHEMVLA/ZkXqKq2fYErQEdS92J0DFpUbcJsZm9RiK1jyNMkE3FherBmFGfkUBRl/+HZrpforcmVpDKk0R+zYVOAx7CgEbljqcxdVzfe9ustjxmGIOJJCieWxHGO9VWoN1Kp1E31+sBJxR1NBzv4xFQnFJRm+sz9G79V5/y4MtkSc7SyMbLZxwNT1nEnbN6OSDnyyBGVnCkcgRYmE+M8peoQLKZL9jcAInO+y9CdFmDEkjxwYn3o0SLLAh5p0ERr/DdDqrskiCN+P5ZsRw0qh5QVs52mcdA6BYykO7fLH65wVu5mRn8dgRBZ2i4irV49nJWGB7HtUzqd/1QJRHK8KAaknGhc9HqEgryDHP6uXvjohQ2PpmI+Fg+dQ09upM6cM+OQHOAU+gzvCjeFGxTq0NMujs/UH9sXCZ5XDSxp2Afeui9yB06UOu/o7nGPN6SZE2/ibMxSfx/bskV+ZlbvOHGVkXvkpagnkbq0UahrSHbhGPtgRTlp1q1B9UD2V42ShtYMEv1+LC0D4SDMi3gojvOPBVBT3JJsouoqGr5xFg1TUwaFI+sCMn0P+qAp+FK/936VYNmBzAjSj5RUr2soTOW3uomtPL37KwJZ2HP6ZhX8AvkScKxD3iawG0WFFjM4PHIBqGf5sMdLHzMRRzDETkBwsaariB0Ts/o9DFL8YBY/x4SYEmIZWNplwW1f/AG4AQY62BFKQ18N1Ba
 HpOWi4qx
 8hSG+dav+fXrJRJyP9t2p3ADEuscmoTAAbeooiJwvqmBJFf/eJFy3ZUsR31dXkydGbVgEdrDS4+7QaQrzZrlI74pAwmsmd/Tyz27zS7THrnOr3/b1qZCWpYmWYeWeRHCZpyV1SsMSw6sIjZ/uHmt3izE9DU55spGyTKvtTft/mV0kdpRdXpQjZ1PQVbsYAvsFThygw5/U4PAbDIeq/WeUVoWTMto4fpMdzbADuL8/P92EXVaXrUKTHMMD00bBbPfgmVsZ0F+41EAFk+WW1Bk8N8ReaMaYlv9YDcpAQfF9eJx53NaSqNwOycwrSrEBtkWqq1YP/uFIJ22PGyQn7XWJnlLZ7za4el+sOHIvZY5gnA78Nc0ilzRr/Smz4BeucF33WxqNET2sMGxIs0L1Q4Qya8eA/lhbmNAR7kNECJZBdh0jOynPvPo/v3zlMYRMzyV/D8TW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 01:29:38PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> No NULL check is done for alloc_percpu() when initializing per-CPU
> nodestats. Allocation failure leads to NULL pointer dereference
> during later memset.
> 
> Make function return int, check alloc_percpu() result and return
> -ENOMEM on error. The caller chain already propagates this error
> correctly.

I already applied a fix from Gregory:

https://patch.msgid.link/20260701221613.2818148-1-gourry@gourry.net

It'll be unstreamed soon.
 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  include/linux/memory_hotplug.h |  2 +-
>  mm/memory_hotplug.c            |  3 ++-
>  mm/mm_init.c                   | 14 +++++++++++---
>  3 files changed, 14 insertions(+), 5 deletions(-)

-- 
Sincerely yours,
Mike.

