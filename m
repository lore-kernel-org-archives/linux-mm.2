Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A316F43841
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168E66B0005; Thu, 16 Apr 2026 02:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118086B0089; Thu, 16 Apr 2026 02:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F346B008A; Thu, 16 Apr 2026 02:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E23646B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:40:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7662C1B88D2
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:40:38 +0000 (UTC)
X-FDA: 84663470556.23.75D7123
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id CE9328000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:40:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iegfJ5aG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776321636; a=rsa-sha256;
	cv=none;
	b=49NJ2olwEyv+oIwPkQrK/DE4B5feplaSF4+uORpRmCJikLz/l4ywjL7x/kgrsARo8z6NIs
	CVO+3qfXj6lTeWY8UhnQFVyxoPWs2tjXlAQRzYdYpR6C1x1xbBB3hZiWNxXvLH8tEtm7qo
	KvGbZ1lZDlilEfdDPX1KGbMCIm2NsrI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iegfJ5aG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776321636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHYoHYGWd+bA0nq49V6BrSuyv+SGvDCWMOMewUstuZ0=;
	b=o3w/hRORkXZ2xTWcogybpGhHr9xDYEVnE8ShFOBqnyABnKpnsY5Llhk+6KKWXawKV/d9SR
	3d94QStX6fJjHIlXIYoWKjHzcLzjtpuBKEJUptmA1V9ZxTWLWGhPnjHiROd83hDZIsPG/0
	GxokfdXpjmGZjLDOQFVDz5UQTotA7Ic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E64B60123;
	Thu, 16 Apr 2026 06:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625EEC2BCAF;
	Thu, 16 Apr 2026 06:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776321635;
	bh=4xrnjs18TLU/6XdHFCakNAwcFkL+DwG3F38fzRZBs1Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iegfJ5aG7HSQmPONi+TeR6GS5a555N4fH1KsIgTzLdPU/ZX4jCQ0q0lNgeY1aBS6B
	 StflxZ2bjxC0tgvI5ixJwHVqcKu/FoOUg9a823OdFkVhcPstLqHUc4WfAdZ1jPb79V
	 joClK+3U8UJ5WG+uuKnPhVii9SFbVDMe61O0CocBiHsEsvE/3FXdRyYEvrvj6y0jYr
	 dA9MrDOk7MsWDEJuhO/kNXaL4K3qiww/SLwenGSRxw7j98txiXBso57WuRP4Wmqk+r
	 BRl1m/Lz5jclAgM8Ki5mFM5PItA0rMKDN2ZPnd4BrG+iZR8FtYVWwXTln0E10e3Bul
	 Xvw26YSGHyLtQ==
Message-ID: <0a578026-3bc8-480d-8992-c27c3496e15b@kernel.org>
Date: Thu, 16 Apr 2026 08:40:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix spaces used for indentation instead of
 tabs
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Xiang Gao <gaoxiang17@xiaomi.com>
References: <20260416021945.682234-1-gxxa03070307@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260416021945.682234-1-gxxa03070307@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CE9328000C
X-Rspamd-Server: rspam12
X-Stat-Signature: y15nub98ehabe9dxax1xdm3w4ra53bbo
X-Rspam-User: 
X-HE-Tag: 1776321636-67940
X-HE-Meta: U2FsdGVkX1+jZm/uac/FBz54Nzu1WS+JVxZYSHtHZFOEtcj9p7Qeh5vCFSQXR82jVMWLSH8VL1BydKA34Qbx2F0mfrro5w3cRKuoohGaawgalyoynwLm79qs3fr7FGqfXWr1/VEszopW16zIGaXeaHBRFDab77jx+HH+OhY46mQhSrMwZ7pS4hcbCOF6mVOYVVZkbE5eqVz1DOQNKdllNwfxFmWakUXCOVhDC9asDCeK68IlU+wa+/Pus85+wt0ZsMcltQvkSLcv6kkUmI1DhsPEgKr6C4ktB4109iSv3+2tMR+aj6sN42Z5HkR0IXVeHhC2zQmNUK3qWX1VoSkSnIcugjLyuA6C/Z/QTgIz0UUARIfH98Am0PFPrKMkCppXry6zQH0zJk8e9lmqeFvZRLJaG7LxqMfDqBHjmvRIpo8DY7xxnl2pOsh0G2bG5aJzBnK4lUQCvv1q2t0u0/E5KHeqCamdT8jaakgcfyYbbfNwwtUJjKz+cWus8X43ro8hvCc4RU+X2Mp9PYOcXpza8NwBvW9GXHDjR0WrW4pp92Kl7poqo1hdObGte8mqUQvyALSSXeVJCgP8u00/uZlJgN9oWpFpTkp3PKYH19tTPaU1dG6gdgoiVbXT70OnkrceYE6Sh6Vi9b3t617SUwpczYSK29aB1TTHPF9qOM41c0lRaPPYFZZeTcA1prbIMArSEAan/uoJ1zobr09pFCJ4BIfRLzERhIjZTcRZo2/WwN3RtnFufh4EyM3GHZz4tvB0eWYi17w8wZVHaFoBhHQcvvNvc71AzfUd4E/5TG1Ua9wvQeDDhrTg7E7I4NaeWg8uY1uuPoB+6SQ4735mLxstxqkWY6kGSqpY9nM5D0N2c9jxwN3KcMxqRTNj/5pmLDeum1LYuX12b5fUbBsgPykjZVRlrr76Q8p5XplzokKkvjcVYEU1vaI1i3kQRV3NbxH57y6pDzN+qBB/pR9P/Rf
 wQICQtXP
 ye08tcRDmX/eN+GbhkCRKhLQbLrea/zjgui557BJOqVemg160Htwqq1bbeNZcUDwSqdW3ZXOyuBSXwH6aoYahQIzvz14iDImV2ShY7XFa0zXs4bdFkL1fG3+/s87jR1k9JlDpS+CrjRXYjqiVjJJU3s1CjXE6r/G0gzb0oCthglzfvaceFxJrgnctbl+A11J395jNcDNuUVbq2JgKi2vTFzbeuW8OTNVkKKwWA5/UxfHakdpccIFjdKbvbSPgMaOqIhy4D/Usj2897G731Gf2SuojhFiOH+/Ll7H26M7xsH0cd2BNorGVVltmrLwWFN0GAiZL4kL7PAB1V0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 04:19, Xiang Gao wrote:
> From: Xiang Gao <gaoxiang17@xiaomi.com>
> 
> checkpatch.pl reports two indentation errors in page_alloc.c where
> spaces are used instead of tabs:

checkpatch should not be used on existing source files, only on patches
changing them for another reason. There are many pre-existing things that
would be flagged and we don't want the churn. So we only use checkpatch to
avoid introducing new mistakes, and only fix the pre-existing ones when
changing the code for another reason.

>   ERROR: code indent should use tabs where possible
>   #887: FILE: mm/page_alloc.c:887:
>   +        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,$
> 
>   ERROR: code indent should use tabs where possible
>   #6626: FILE: mm/page_alloc.c:6626:
>   +						         sysctl_min_unmapped_ratio) / 100;$
> 
> In __del_page_from_free_list(), the VM_WARN_ONCE at line 887 uses 8
> spaces for indentation instead of a tab. The identical VM_WARN_ONCE
> calls in __add_to_free_list() and move_to_free_list() both correctly
> use a tab.
> 
> In setup_min_unmapped_ratio(), the continuation line at 6626 uses 6
> tabs + 9 spaces for alignment. Replace the excess spaces with 6 tabs
> + 1 space to correctly align with the opening parenthesis on the
> previous line.
> 
> Signed-off-by: gaoxiang17 <gaoxiang17@xiaomi.com>
> ---
>  mm/page_alloc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..752673a9b43c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -884,7 +884,7 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
>  {
>  	int nr_pages = 1 << order;
>  
> -        VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
> +	VM_WARN_ONCE(get_pageblock_migratetype(page) != migratetype,
>  		     "page type is %d, passed migratetype is %d (nr=%d)\n",
>  		     get_pageblock_migratetype(page), migratetype, nr_pages);
>  
> @@ -6623,7 +6623,7 @@ static void setup_min_unmapped_ratio(void)
>  
>  	for_each_zone(zone)
>  		zone->zone_pgdat->min_unmapped_pages += (zone_managed_pages(zone) *
> -						         sysctl_min_unmapped_ratio) / 100;
> +						 sysctl_min_unmapped_ratio) / 100;
>  }
>  
>  


