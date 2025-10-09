Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD1CCAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 03:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2253C8E0062; Wed,  8 Oct 2025 23:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4C38E0002; Wed,  8 Oct 2025 23:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5258E0062; Wed,  8 Oct 2025 23:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE7358E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:26:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AA1313BF35
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:26:26 +0000 (UTC)
X-FDA: 83977137972.13.67FC8BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 06DB1C000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:26:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uLZ0r32s;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759980385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sztrkZ0dvGu1LNVu72SHZo2kRGyJZdC4I/52Rn5pnlc=;
	b=Q88yAiSiNNVs1vSe3uclDaB5KnhW5LWB41T4VXVsAN3ybWEHcexRCCGLyPuhqz+oRkmlZC
	X0hEdZagkY/47pqT9JF4YuucGCkeswWaXFGUZqWpkaLvfHLaxFBpRUBGnbt//Q7EgcptMn
	VtMnXNlygP0AnucFhgFGuef9e69UGBc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uLZ0r32s;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759980385; a=rsa-sha256;
	cv=none;
	b=T0jecb3PPU1TMsFIbL5LnkQV5p20qqsN9sTd/YMkocP0xZEO2btS45SKkvCCxx7yVTSaNy
	7MEllIle38VxAWQKv8azybLQzxF7BzAjWvprHDLBDxOpEGvYNiuKfwVNR3WrIOD2/oOS3c
	iYpByS7kxNjd71W9uJHIiKpYzJi80w8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 65000611E9;
	Thu,  9 Oct 2025 03:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF450C4CEE7;
	Thu,  9 Oct 2025 03:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759980384;
	bh=UG6j0xKfRK4Twe0WeMBR88qjTv/yVujqo3MVZkkPibY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uLZ0r32sy4OW9OvQb48l8SGwkY8hr08t1jTufxml0fZgQtITqW1nGE8v6PyqrTa6W
	 Mm37iLuw//Le53zz8Pc0oISQa5sqZiFOVM7+7K0o7HQ5oqy6Zwrw0MX/I0fXs8NhRO
	 uSMui1DtCXiPW0Pa67Nx1c4Z2PUwJlEtT2k/sNxk=
Date: Wed, 8 Oct 2025 20:26:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, chrisl@kernel.org, kasong@tencent.com,
 baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
Message-Id: <20251008202623.1ef2ac29af9b9c3d53aca4b2@linux-foundation.org>
In-Reply-To: <20251001043436.41338-4-bhe@redhat.com>
References: <20251001043436.41338-1-bhe@redhat.com>
	<20251001043436.41338-4-bhe@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 06DB1C000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9jyzcb9rhwjhx7nymndawjze4dogz9cs
X-HE-Tag: 1759980384-928327
X-HE-Meta: U2FsdGVkX1/nqlNon7XE6mNSR7HQrZMGYFMdTQ6UZG8Nvio8ICvMdlBBp7bhx7OJAUUnwq8VlFVG25mWDkGN3ZK/mT/GSGn694+5tNYEhu/gn1qx8b1J+R6vHycd+/XdKkieFNv/YXXD6BEm767RzTEq4sh4gdwJCgpNUqdmeJ78jV4v0CmiEIAPlaqAB9jw1NnjqPhX+1R1B+f49DTOQB+DqF7n0LiG9+5vlCUi95Rd8ey0HtFaFvO+aT2iiu0XVa4XGxf1HQs/dtJyNIG743lS190b3CDLLmu/1lzrGIZ8eQLM+q06BqRIQNqt7wuTGth8yNsFyeIUJs4zDgWjn9AO3Q8W2uLUM2C6cG6K0kI3JA0sxPu94Et4rapVhVeF1PKnl8GnfOS1EZXmvT/Jb63mDcMmAB86BYs/AV0OFy0rm94FU8iqwX/l1W7qF3fyfrwndph0dAi6ei+d20URCkrWbFUMgrbuHYqWKJcqZRlBHi9omhxJlPQBjRhndiW01fuVft4bE6f/wMCN6jRfDr8e0QBcpibzSASR/hv5nN9ee3zLwn+Y66h7V20SU/SMu2oXaLA+14NDxPJOzUUYiwb9encsNq6Jl3/I3EeArWagWXv0g11LeP8b5cmmXs88xifHaVtXuOnsqM5P3HzB8Rut0pHpF1j76of8+v9EQdavsp4nqEWVXRRIc8CNwVO4i0p5fkcfEyPInJLSlu/hzsDBQSMEp3j/5H6u/z06AmP8zH+3lwbId6Dr/hyxGhGdAyHmGhoCAVM4sSbLKAxFrTStF2jSoJt9X+MlLPtRDkF04vOrVugj409BJW9FkQWVCnik0UYXxxweiMP1rq9O5YnMh18T/sHSyjhpQou1ALTu4V7uwmoTJHUCA9jU3UGo4i8TUK4uyrOtahEIyPNhrwI066Bu6j022XO3gBusAzgJkH040/Adp58CMCQjNPvg2CqiBebeZa29dNYnEv7
 yPVmvi3p
 s7aOp6EDatRC47oh7Q0f1T7WJJRvAoXVbf7ntI5DynqIeXjnQANC4zMyDfaCuPaEfkKJHsuIFY7K879dwHuu5di1ZBcWiDkvMBNEKy/HSZ2bTXnuUDo0EsYlFT8pksMXFwHZhfPbAKMpxUdBwPDvJzMmpdEvf1Xe+8zi64QwKUcGxHkB6kxSHhOmZK56dIl0CV5G9HbHdcoq7eVlFngVlw205n6eU54vrOIc5BcR6nXSnYRCgvUxHgkeA5URNQpLcSZmDb1qGKgmz/iR6fRRlw3UtDGWUDVbYIQXFPqn5xoAWYQHPG20w19Ps0GDZn1TyD4ut
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Oct 2025 12:34:36 +0800 Baoquan He <bhe@redhat.com> wrote:

> There's no user of swap_active_head, remove it now.
> 
> ...
>
> @@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_info_struct *si)
>  
>  	assert_spin_locked(&swap_lock);
>  
> -	plist_add(&si->list, &swap_active_head);
> -

There's a large comment in _enable_swap_info() which needs to be
removed or updated?

>  	/* Add back to available list */
>  	add_to_avail_list(si, true);
>  }

I fixed the rejects and my swapfile.c still has a couple of references
to swap_active_head.  Can we please have a redo&resend against mm-new?

