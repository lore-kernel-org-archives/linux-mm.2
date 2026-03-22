Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F49BFC72CB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4608C6B0089; Sun, 22 Mar 2026 12:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438956B0096; Sun, 22 Mar 2026 12:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3759E6B00A1; Sun, 22 Mar 2026 12:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24C2D6B0089
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:38:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8F7C16031B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:38:03 +0000 (UTC)
X-FDA: 84574256046.21.89AAACC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 27E7C40006
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:38:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dOhov4a1;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774197482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=St9DqCkoA+edwrBdnQxOerTL/vW/X5LFsUvFOc6gHvM=;
	b=Sr/2ebiqVEiCxMO2eg0Nk67zSOi4qGuqcJV/SM1oj9+QwdhcUdK+XIF5k7tXxcydPunvuX
	XKI7fAY2rT0hjTvNjUrwcll3C5yukMz9uv17r/Eq7R41z2BhsWqM5KvecmZURLRJFcM/20
	kfI9Xph+/WAwtcqkHrl1o8mOU8CtvDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774197482; a=rsa-sha256;
	cv=none;
	b=ESHUTU2FKdRwTMgE4p9Q4cMHAboaloKkHBB+TvPghlzfPKJpPuilsJnmopg2dIL0EDxdeG
	fQhSbzww6h0/SeFQQnv9+165sY9e28Y8VEbW3HIhL0EY7c5GE2i9oi4wHlYQnv8jfA7xDh
	eKfWOCwubPag3TCXZFrthDE2Vs5zA8M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dOhov4a1;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84A9D600CB;
	Sun, 22 Mar 2026 16:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59FCC19424;
	Sun, 22 Mar 2026 16:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774197481;
	bh=Sdszyg23QUequRorJfJ8eCM3MpMl3LmBaD9hHrjRhUM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dOhov4a1sDuQj5+1MN212N1TAo/J3qkxJjmYWZEUVkZdlG3PDOPmns7doRb+wDXyt
	 aaqomisAHnfyYTgwx2obNU7EXOTh2fY7t613Nb5wV7KirPf4XsrPtZUJaR0OZwV8Q/
	 Zk10b5lxAWO1geVx8TzUzfX3qIG6zOHDE/ENZzZA=
Date: Sun, 22 Mar 2026 09:38:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] memblock: move reserve_bootmem_range() to memblock.c
 and make it static
Message-Id: <20260322093800.27f8b2d249817270bcc6a437@linux-foundation.org>
In-Reply-To: <20260322143144.3540679-1-rppt@kernel.org>
References: <20260322143144.3540679-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 27E7C40006
X-Stat-Signature: 1xrijrcustskb9amg6gxrtg9xrsqisue
X-Rspam-User: 
X-HE-Tag: 1774197482-602918
X-HE-Meta: U2FsdGVkX1+P/u3fcLDNhrPWZbEufF75vuu7gQdOOenmQKv1jWl9tsnN/J5CLMaiBc6pC2ybLQcptKin9uzAizkKPk4d3Vl4ZubAAQt4rVLuDLKQUKMi1gUy6L3i3t0X5A4mLjYUw2h/5lk2aSg++KnEVJnMp4QbGZxaioq1De1KKNlYF95il9nZZbjH3eB4RdzILRxBGVu9KBLktsEyZeD4Pc32cKDUwfYNo6MxvZZwCIysSsdACZPUMnM8Zm5r4vkIowlqgYpcAfC138txD0M7Z3bmdgnkrSp0DAn5MHiO0Xg3aWhlORBXhI2qWeOZNnFHbAqq1LSVmn08GX3XleiSzinQQMPQNaMVy/XXIL5PvenkRg1mfbVRbMln0VAaeUZ1pPPPVGiPffQS1fro64kl/rdMpj69SpGwgOKL56nIxp2NX23UNqgcrNjOkl1oftsCDMflqpLE4EOs8521QTA654u3NnNJJsgsZUb7QBcJEtnE6ar96TmQyP8K8okczq0z3qSIcjwYIlmS00TPE19Sa7kog/gvjFcKBXnSwKU+fwVdC/0dNAdLzoQYirfaHMtfY1fOV284pzRbfBuS7uZBs4HeHMcLQ2eJSWYW14W6fTmwJ0DQ5SVetJf3WRcz4xSDZ/7gSMtxJme7Lei1el4r62ZL3efYVSZsTJYc2xR3zN6pNEPbW+ymH1SsccR54RyRarwFptLw5JRz8IUxajMk1iwIjk4IAG+UB+3EAwLT9S4gMRi8mE5bOzN6cKDp/Feyw484glkwIQUdFIfUhr6NqBBUmisf9z245N86Xu1pVj7Gvu2NHTJTcD/Xie53gKOXEXCMgu9u7ANE3qM3HkPwhGmMhSqzy+IqNmlRzpdjtcGfb/OHE1pzcZoWma5S8594kzMeNyBqaPOnQ7PlFu+7sg1OqtFFoHJKUpVxkyLQPPgcw824Slfrg2HED9L08UVJoUx3camBmoTAkqG
 aAe1nV7+
 R6WWAj4yJy140Gn23G+NArh6NfKcKRrinVq0UUhKehM+l/Aa4BS8I5L7+aR8q/B4B2FkC3tlK5jTdhXYupjlFwSIrIlWas1W4L1CSY00ISTr7gr+P5IfPDrZl58Cw9BAPcnPJq/yEoKGZicgS1pDt1qQ0X4vnkFyoI4aWR0DHhcofoqpeYG8WNxMjax0YnMg/oprhhy+Ijkw8dHM0G9O1SN2AM27FhzJkLXr6aEpAIbWaFBfV767i/iXtCFVgK2LUZcVIELU3idJn+9YBBCi9IHUQ/78xS9flI4BC57tWzt2gm6AisIXXniW/BobAsK/1ho0rSNU4m1zvi16RoCUaGmG92cftpgUVEmWotH3z722ctzj+OaOGqM6cWyGARNZ86jso
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 16:31:44 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> reserve_bootmem_range() is only called from memmap_init_reserved_pages()
> and it was in mm/mm_init.c because of its dependecies on static
> init_deferred_pages().
> 
> Since init_deferred_pages() is not static anymore, move
> reserve_bootmem_range(), rename it to memmap_init_reserved_range() and
> make it static.
> 
> Update the comment describing it to better reflect what the function
> does and drop bogus comment about reserved pages in free_bootmem_page().
> 
> Update memblock test stubs to reflect the core changes.

Some minor observations from Sashiko:
	https://sashiko.dev/#/patchset/20260322143144.3540679-1-rppt@kernel.org

