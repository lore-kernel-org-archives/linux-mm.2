Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD6DCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB176B00B1; Mon, 11 May 2026 09:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B25C6B00B2; Mon, 11 May 2026 09:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F303A6B00B3; Mon, 11 May 2026 09:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E17956B00B1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:10:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80F4A120115
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:10:58 +0000 (UTC)
X-FDA: 84755174196.25.DDF98C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C2EA21A000C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:10:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FMnpmT/V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778505056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjIRvJYPLtQEXJKHxCPBPnD9BEti9+8I2/iOzoTaUmI=;
	b=JMawsgdTZ21a6fdten/bO0DhQxN0a29TQaPAiz14LNs5nLEAkKd6VHtV5cZnsV6fgXoz54
	zRZMs0McMGcvZj5wraV+lM247+BjEZtrgqmTDbTFWUFeg6EhuR5Xssmvn73eMYrhHAMgCW
	547ohvLnz10EfUtE4sUPYmCWRSKaFIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778505056; a=rsa-sha256;
	cv=none;
	b=aJLniz5PB0RDfSmT+1DgX6O4uamocHx970WmUGKC5n9kkkZrGOD2ZBJUqE9LVfEY/cLeje
	tGFbX7S4VBxYGQXrIewssaaYJFKvU+JWcn0LskA0FDoCNfjrWVqIXrJiAcPd0DPbl8FdCB
	Yu89jdpYIxHGGI4mrWcZeaN/hzIUpnM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FMnpmT/V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C848242BA8;
	Mon, 11 May 2026 13:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C94C2BCB0;
	Mon, 11 May 2026 13:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778505055;
	bh=4IYVrNKfE39U89Ai1am7hQrNp3oZrSkOKSpVaaJ9FHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FMnpmT/V2PuDt0NDeDkforyAcO0RMZPjHSRKnOws709em/Jb/gowlrPf93S7rRuX3
	 f7yaT3abzvoNxzcKAll65O+Ef+pqonipYp5MT2DuTOJ1cuBhPx9eZs6fQTq6KWD1Ch
	 qgeilxQb1Yy2/AZzjHtP2j1v0Azgs6bFqIMag3mqJp2FG8mT5sQry+Bx/HJHhLo9be
	 Crc3MLAxSWIab99jPnKD1FYEzXlJl7/VWIXNjt4iqOLqnTuQbOGZO4/7oURsSCSM6A
	 vmpHG1yN49ZletrxibcP/RcjqVl8gwawBPH4AZayBFHBnHJV/qodQCVkB9cZq3GlTB
	 8sqgrszeg9sCA==
Date: Mon, 11 May 2026 15:10:48 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jeff Layton <jlayton@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Chuck Lever <chuck.lever@oracle.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v7 2/3] mm: track DONTCACHE dirty pages per bdi_writeback
Message-ID: <20260511-begonnen-zuwege-b4272b78eb00@brauner>
References: <20260511-dontcache-v7-0-2848ddce8090@kernel.org>
 <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260511-dontcache-v7-2-2848ddce8090@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C2EA21A000C
X-Rspamd-Server: rspam04
X-Stat-Signature: w7rkxpjydwdkwcc964r8we8timhuzqo7
X-HE-Tag: 1778505056-398677
X-HE-Meta: U2FsdGVkX18+7jroRipAEJGJ4ztgyQkCy9YAsHPxgkivvvzUhIu3w+kMh9NzXqrWRbLqP2SO3+6aiKXecUI9QSQnZ22urUgSfO6sDfRyG11wXsPq1dS9thEZarYvXr0klOSIYqIYIbrJnJR7ODerkg31mg86ntubBZhDzXqk+rlmZVeWeC9KbjL9Zh0n+HULZZ68u6MVMd2DV0pjF6UC7pTuauCgLiA1BmEN5cwc3lQZFa4MMOvaLduHqWzX/MkZZ00ztTWkPqyh2rcLyN6VB+zlilxbMitleaTBGY7X2XZdBaZVlBmcgyj+92dND+v93pZjZsGQ6hlilrR9/32S8db9LPkmJcFBvi9K0w9Ws48eeaDIw/S9LMynO86J5DvEeZYvs2Lnw/AC8ix8+zVablR0xMGxpssEk6l6qZd0N2+upvKwDFmssBk3VOrluW8cZawkAPQv9+Mk4ZYC7vEXwlF0vJ7LQCrAA3OY4yxbmadSf1htRYtLxBs7zI7MR/RonV5DnwAJEj1HcBteRyMN+TafZ3yKF2q2+8VcUyBZuC762p4LiFsJeSVbm9OPxRZksZJHgljMPRTlAYydKP/8wgJO26cN8Ie10iWrBfQucuhQtxJLeMrvxqOM3Fq1OGi0xTJ+5HXEtkQIAMbnPOE6uw9Bftv4tLsPE0z3g8kFnzLQCICs6d2WD0Ub2tX7e1QKn/DIY2R6q8TtxkI0j7R8kCFx+keJkAeUQkGI1A/QE9E/nuD+CDq1Z3uxNAjeXHIBSNmVqQKQxUQqVms/kwzsoquEARm3NwOIXkzwTAmbehVjo8dwFdRWHx8UatP3dcCzSe7QNdvk7E9vLsfEIzbmcwNbrxZJ4CGQTvKhipiMfQ3mqqYXKYRYfQRHwJY+3VifVtVK9q2wxqjd4o798yosU+dRlDgJSFDdddumDWvzB3SV/2fuVmKVMcJtRAQFEiSUIGVwksRzZpFYP3kUaRX
 3sx6onnz
 yNUSZ5yzTWObciSQmYJ2EkHeGWn/YxLzo1o9FlHQZzhV2gkZgHDAYcVXVffV6j7n34WHLVVIAYDI4i4jseuL/KzFGfzK7UPzpVcwvfBK/UCZi3GGGDyYSHJ9HvPaaHC+f/1pPXcT5F+YM/hiTsNN+SBMqm/500jkWJ+Ycy+sSPPn1Xrc0CzqUWyRyvmxf9DKyviM7CRfbAynA1m/7I1knUrqrBkJgfvN9s0ttWPACU5dd2wX1WgTb8HdkBUieI2iYn3/T+Ym0uIyhbSaCAIolFjggGFbo6dFx31J37LXojlrv9KApFoPRUpfvvS7+J7x6ghTIaF5uvhiekKFo//gJCyA7WUo0M1rwEqr43BdwZJgaljbhJkBGrjB0YJ36268OZe41fgplpOUwBysXUhlNXuRZkuS/FFiz35eWt+2njQJ115c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 07:58:28AM -0400, Jeff Layton wrote:
> Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
> pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
> writes).
> 
> Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
> when the folio has the dropbehind flag set, and decrement it in
> folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
> when a non-DONTCACHE lookup atomically clears the dropbehind flag on a
> dirty folio in __filemap_get_folio_mpol(), using folio_test_clear_dropbehind()
> to prevent concurrent lookups from double-decrementing the counter, and
> guarding the decrement with mapping_can_writeback() to match the increment
> path.
> 
> Transfer the counter alongside WB_RECLAIMABLE in inode_do_switch_wbs() so
> that the stat is properly migrated when an inode switches cgroup writeback
> domains.
> 
> The counter will be used by the writeback flusher to determine how many
> pages to write back when expediting writeback for IOCB_DONTCACHE writes,
> without flushing the entire BDI's dirty pages.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Assisted-by: Claude:claude-opus-4-6

Picking up on something we discussed at LSFMM in one of the sessions as
an aside rant: I find these AI Assisted-by tags so useless tbh and just
pure noise in the git log _especially_ for a core developer like Jeff
that I really don't see the point of them and I'm always tempted to just
remove the tags when I apply. I have dropped them before because I found
them so pointless.

Crediting Jan here is the right thing to do and it provides actual value
and also just makes sure that a real person who spent time helping out
gets visibility in the git history. Why we should extend the same
courtesy to automated tooling is really beyond me. Somehow we've become
all convinced that these tools require a special status but have spent
months arguing about the usefulness of other tags.

