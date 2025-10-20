Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F784CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9628E000E; Mon, 20 Oct 2025 11:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6912C8E0002; Mon, 20 Oct 2025 11:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE328E000E; Mon, 20 Oct 2025 11:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AACD8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:12:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDF67140119
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:12:53 +0000 (UTC)
X-FDA: 84018835026.20.41B36BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 538CB2000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:12:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=mXt7VJL7;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760973172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xvKAWwjZc4rZ5ZTpePNy0vQY4XiImmDZkphbJHYlDc=;
	b=cvoqw77WWWGOZBTKL++nECOR7Kq+VRbwxEZaMELfFGsGmQwc1CCPKRHFZbnP7eSIB+Tbv7
	yD1ocliMS14cMdqkL9ay0beSoR01ZvPB7GXJrBb6rCPv03jzzHISv+C1MSpqHUO0qhSvV4
	Ehu6tNnmuyyK82DZ8hxfMkII/sM9oIA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=mXt7VJL7;
	spf=pass (imf03.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760973172; a=rsa-sha256;
	cv=none;
	b=bU/D7+lq2agEdeNuu7lMbUTT0KUbB9Mj8EMIy85pHIRDWc6ZUFGDj5oUJNDv4/6/RO1sg3
	SaEhyMOWM1iFAGqP64OQ+REgEJ+vn9X9g0f/M8d5dRlsW05XFbFJ7/TKJtxsnBw4CCwEmd
	sQqm/OXPTIYesYztRuT7nzIRYIIcfZg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADF2561FD6;
	Mon, 20 Oct 2025 15:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E2CC4CEF9;
	Mon, 20 Oct 2025 15:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760973171;
	bh=xL2aZT3dND/IgpLCEUeVhydDyi+sqU+McY8Wwq4tBeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mXt7VJL78UfUaR/x42reuxZo8R8etuEGJARMSiHnI4KAduwEJu8QZgDv6IQUxL3+6
	 aA7UxGmNC+XKp5aHW5pI4gf5JW1gV2EIOttqSVdBNetKBRWI+XRMbFi4t3tDOlZqvH
	 uRgF1QcnCLnL1hlM7/C2KfNSGX49lEXO8xYQWAM0=
Date: Mon, 20 Oct 2025 17:12:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm, vc_screen: move __free() handler that frees a page
 to a common header
Message-ID: <2025102026-unopened-equal-764c@gregkh>
References: <20251020143055.407696-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020143055.407696-1-rppt@kernel.org>
X-Stat-Signature: 7u4ng4pd3ar74t4ka97eeu5gypx6mfje
X-Rspamd-Queue-Id: 538CB2000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760973172-962728
X-HE-Meta: U2FsdGVkX1+tTtXNdut9dXI24EEsycr3Pit9qDWf1xeW06b5kNBNSN2NIpNBuPBSnzvYZ4mKOG3H+H97PX6SPyb8wSzvPqDlRG5Hc1id73bLZG5QS+XEUsN4Df0Oos8GWPDgDC3cAFYGFfGxKtb1X0HGXLLb9qun2+kJ4Xrc8R8p2ahwa4ErnK9A6vycfZ6wZepn8vjHaa8NG335KjfpjaouzD8h5n8XHkWlWWbEYeMVJLbJpCg0WhlYQy1DfKKXs4oMjwg8/gzeQraciUlOPt5vXM5fQgxyfzav6e6RJktzEYdGjsavmuIaLHSozTyLxQpGsljZOZDlsJBIhbp3dtsNTfrXuShM67Uj+uRAqqb23DH5qNF27Wu7ExN3SQcc8Orun1Ybp5KdawoaQBXi4Uxp9C2IOtWu7jqhUujNvL/9Bt1nmJuqNpVFm3WEwoNjahBYRT8IDbwXPeD6/A27Yl7IS41oC2RSFpgxU0G/iWExvmviYmdsdrjts5wT+UfeysJ1FGuc78sxkUdDZ64kPzQwB9LYV8PHijBJ2oVTOA4zc8b99DoCO3jfTNJ0Tx1ckDjXdwY8ktdfAbnDNaVotb3Cg/CswXOB70NolwCx9+yB6Tc3GYri+ulvF2yMyki+CJ2FHThnVLcYx9/x+OEXdLFrlibrsHutOavyByfm+UQIaEsfJJrqN33T0rItLVvQQ5zqfy+ajrJ9c9hxHRyjreISZH837I/0YaNWv0OYjwWzMLHcYQ4aDCbSr0MuC6Hl4euE7AocRGmoef/tTeHMRJ2mZ/o0SFnqU5uyz1fkapCRVg57CfEeue56JbbJDN6kmQfpVCLpfZyDD0mAZVipzJidlD8ln9OIUI3ED3Wi+hLVxBAGLYyK0nTenLKE9p6IRUvuleO5k9pFRp82x3eHxc5fv1/Pgwws/Z2dVRGwSJkCN+60f2FdqMytc5YHF0Wtxm5oC5GE5HVtFMrJGfx
 kznNw9L0
 mru36Zo/qH9+vTNGeV+0T8PHg1LnjKptgsmvirryPA1owTdOLrAe7F1mWmC/keaDHw9Uysq9OQy4+KMiCTx8+EqZmWplIYZrJI4iCRPhygEuiSvFFnwMp6NHvP3yZfbmKzXHIw1GBJQjdedqvbUROl8vc/JC6vkYEKSi2VMQt6AK5oeHXhpurO/S6NfjSI9xHn2XHtE1MChwMNeooUKzNxDjx44EtJfMct9jUfUH88xmGtiuGK/kUYI3W0aiC7h16W0/k0Q3xPf/iNHbDyYVjISglQQqT0Smqmv/3IHh3wipkkOYzcz5H9JO67D7iusrSfWWYH1ms/UHk2UltxLv/4ebadnvbwJn6oPrABtMbKPhjISvg29DAGyiVuFwKwIFCDD0MrDK/pFZixW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 05:30:55PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> vc_screen defines __free() handler that frees a page using free_page().
> Move that definition to include/linux/gfp.h next to free_page() and
> rename it from free_page_ptr to free_page.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  drivers/tty/vt/vc_screen.c | 6 ++----
>  include/linux/gfp.h        | 2 ++
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
> index c814644ef4ee..d2029f029de6 100644
> --- a/drivers/tty/vt/vc_screen.c
> +++ b/drivers/tty/vt/vc_screen.c
> @@ -53,8 +53,6 @@
>  #define HEADER_SIZE	4u
>  #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
>  
> -DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
> -
>  /*
>   * Our minor space:
>   *
> @@ -371,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  	loff_t pos;
>  	bool viewed, attr, uni_mode;
>  
> -	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
> +	char *con_buf __free(free_page) = (char *)__get_free_page(GFP_KERNEL);

As per the other thread recently, why can't we just use kmalloc() here
instead?

thanks,

greg k-h

