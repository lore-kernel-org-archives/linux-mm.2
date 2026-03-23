Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B56F4613F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 22:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FD8D6B0088; Mon, 23 Mar 2026 18:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE286B0089; Mon, 23 Mar 2026 18:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB0F6B008A; Mon, 23 Mar 2026 18:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 61AC76B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:54:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC2565CEDC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:54:26 +0000 (UTC)
X-FDA: 84578833332.21.DC7566A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 359F080003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:54:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="BL/pgBii";
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774306465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Queees48qfVx22QiO8WyMR41UY/pXAGFL67DA9ZGTkQ=;
	b=P59dRTR5gj1044EA7fHmM9HYh4QX3zfqVECt2grrvIPkujWPLS7Qbj81qdiznnhKY3oUfO
	XlsAzQIsrzXYzypu6RPOb7prgj5kqBcq9wvGJyKkUQtuqshtll4Sf3Wm/1qvxJ2vXaIY2A
	F1q9fEgq2YRZGclBxxyiXKO8H9OuBbM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="BL/pgBii";
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774306465; a=rsa-sha256;
	cv=none;
	b=kB0c6tiHf6mNj5uLbvL5cyUhz0NMWPNNUp3mF0SjCbiIdLSe8L+avBstq492GHzAXh2UAn
	J6fFRswkyMtpB10NOptx5aRUuMz1IgR4OIuZCqEgCqcaISFJpF2YgL4qrwighyUe/xZgqP
	nIWcCC5htR7vUOYld/pWg1UvoXJVj9A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AC4143868;
	Mon, 23 Mar 2026 22:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD94C4CEF7;
	Mon, 23 Mar 2026 22:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774306464;
	bh=6sYC/yo7DfVbRHL80Iy6/ZcO8HPr1iw+Es0aJa0HpmA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BL/pgBiio4QCSJxafqetQhBu1gmwqxZc/EmX2cTqJVAYs4zCG10R2c/qKn9IL2iFq
	 Jq2H/tG3mPxxaeS3UC2F0sUiJ9ryXylGHsKUCcoKnA0wG436pCZ6GYF79tHrQNC8lU
	 EJ0ZiwCCwxpqac7zifFtKsPcuKbG3EAK/BqYNnQ0=
Date: Mon, 23 Mar 2026 15:54:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, Kemeng
 Shi <shikemeng@huaweicloud.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/page_io: use folios in sio_write_complete()
Message-Id: <20260323155423.96bf426cfe9b3b8e080a2106@linux-foundation.org>
In-Reply-To: <20260323170449.26333-1-devnexen@gmail.com>
References: <20260323170449.26333-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 359F080003
X-Stat-Signature: shbsbfeop5rk3murim3rum198qjxbkka
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774306464-262439
X-HE-Meta: U2FsdGVkX1+m4RBqc2ZEdZbC1gee4iEruJerRkKwHJ+HUa7vsQMAFjw+6AbtBbguDDulx9NwBJl8BZLQImBOpCqDmRzJaz+ldoXDHGHI0qqyyt0Dwj8ifjQFbIA/USgihooLjeIq2Yc74cvzBxyzQK6BDCRWq+L6929PZDDCieZotaANo2OWJTGhLqW5JaTr9ExNtnVcfPYrqmUjD/d0SRb1sBPQJxgV3gEYJtK/xfAYDS8M+Fa2gEtq1gl/Ysf9Y9EpWAXiCbUtVys7jb9JAIiyURXY3prrpDYwdk2cYW8BF6WqxhjErFr+eg54UOkx7mHLPpzWjWiI282Fj9tRaaEGSH2X/enbimlc/SkLHs9jggX0OvaEmEq8NeYm3eW/ABt0Tu5dAlGKd+Cb9GLnmSYuyuzQC4qe4K6KafrEQmPDftoh5U9Ycn6XsU7yOMRod4o3vGQHuIP+nl/QhMdoZ7yyPS3XoTncuyVO7ej/YddBjE6QlDbaIP3kpnHqkJY6FOc51u8od5FNIm9gXrR+8qxTvd5SvPB0mpzZgnMSrzs5BFotrQPxhN+PLuZ9nqEqdt2NWhNjcJDjKeFYy7wLZWkNC21vDftL7nDKrvQ6UG3yDYnblXhJcaclO2W5W5Qb9UEUDSqq1aG/HJQwN/A/Myx9MtP6UaO+Ep0J+fl3syTJeUc5dcJAd9n0NgIn5/d0W7f8WPNiMVo/LETEKrUZwNDK+bbDX7mzofE+se8LbvDHKM6VZ/rSjbYliTTvT3LwkAda0Kkp/X5ALV1VO29QxynqXLW0PIrPV7vprsPIQrXvh8Go6/EWjVevg38CjQGdl0LnQQrcqnlIrBt4Nq24EAzzsAj6ASKRYgboOc/sNVgsFBx0lob9sJH3c0Y5tLWF3GuBtpn2bX6G/G5NH/ol1V2cWLS1K+cbIwR55tnbjA9avzLRDCELLfC8l46cmpAItKRjbZikI0fRBVZ8/R/
 +OBT3raY
 WS6vjxbKV1TphtPgfwXzZ72Ihl67C/YqKXU/DUHa0lt0j1Ixv0x9DnUNubHbvHKOyryMekQ+1q5Jnolf134qNlTPqixK/bf+tdCzdviwDs70kb/phaIP605UoT3p2qW4+uhU16swK42t1n6g2tevP6+2S6Ee3zIoSYTMPR0Lbur1Bum5SYkM93PccYWeJJFhYqTDkuniO+7ASWQa0STsaJcoMlV/DuSym81WGV0PXfzpOsF3TohnoaBTvnuarXxIZYAScFxUAQO9Bbt3c62FbCCSSy5WlecGG81tUGvi40uWyq8REv/d0p1gE7cdeMZEVwJ3kSbSdi33T5zU7nw8/OQzdf9ahI3/zzwa90rda3I5+KzriF1SR2PE+c/tUphkRqqcFMKEmeJWtvpO8BSvMimGIIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 17:04:49 +0000 David Carlier <devnexen@gmail.com> wrote:

> Convert sio_write_complete() from legacy page APIs to folio equivalents,
> matching the conversion already done for sio_read_complete() in commit
> 6a8c068774ad ("mm/page_io: use a folio in sio_read_complete()").
> 
> Replace set_page_dirty(), ClearPageReclaim() and end_page_writeback()
> with folio_mark_dirty(), folio_clear_reclaim() and folio_end_writeback()
> respectively, saving implicit calls to compound_head().
> 
> Also replace page_swap_entry() with a direct folio->swap access since
> bvec entries are always set via bvec_set_folio(), meaning bv_page is
> always the head page.
> 

This prompted AI review to look at sio_read_complete() and it didn't
like what it saw.  Can you please check
https://sashiko.dev/#/patchset/20260323170449.26333-1-devnexen@gmail.com?

Also, mm.git is (over)full.  Can we please park the nice-to-have
cleanups until after next -rc1?

