Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D395D4662F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02AE6B00A9; Thu, 15 Jan 2026 18:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0C46B00AB; Thu, 15 Jan 2026 18:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6CC6B00AC; Thu, 15 Jan 2026 18:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89F8F6B00A9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:13:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22D2B1AE64E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:13:32 +0000 (UTC)
X-FDA: 84335751864.03.8F95C37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7ABEF180009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:13:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oclmTG1s;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768518810; a=rsa-sha256;
	cv=none;
	b=rLjjuD70qWBpKn33S9gR8IbDDh0lkZD2knGzr8nblxoypAYZCSbJYnPOB3K+Ux+FHMtgDq
	wixlYJI3OPs/vaVHZFsb0K78ql3J629ckvggNVM3Rl/WUA5r42YJ9k2QSb3xg/aKQ9spTa
	9P9KKeiH33AnC1sr3Q4COm7b21eq+MQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oclmTG1s;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768518810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUMgd/TaVXotv3Z3mMSLbumRxXEEpavpAPkcafPDxvc=;
	b=fwiMXMwDmSITaL2u4PQmdtMwfb4ksCwK8WM0JGgaWJEuSG5pOm6uS6HAbpAVWWY4mCutN5
	ayg/H3Kfi333JlaofYqvCsQ29D53hG6/68DeSB61Os6wVFqe4zSvOkyjRl8DafFB/s9oKX
	lE7JI5hrQ6k3qqEHuZSOdJt/RWYKGxk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A288460130;
	Thu, 15 Jan 2026 23:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16472C116D0;
	Thu, 15 Jan 2026 23:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768518809;
	bh=BP+gqIGsJl3UZ8x7v9WfP/7xksK/zyzL1fiY4gW7DRU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oclmTG1smnQOpC48pDesd0V2WfcSCWsEfg7LjXlthG0o/N0XZE4Ti1TU6qlPht6Ko
	 F8ywhJEV2w9zd2e8ghxMzXRCfgN5cgcHjOZJ7WoQulxQYIklUtKRod841gFSpUurz7
	 5mW5xO8rLazBEO9xdSZhCuulWwtGAMfkHcdB2ohs=
Date: Thu, 15 Jan 2026 15:13:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <clm@meta.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@linux.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>
Subject: Re: [PATCH] percpu: add basic double free check
Message-Id: <20260115151328.38cc7cf0d0b8bf97ee5b3791@linux-foundation.org>
In-Reply-To: <20260114122209.1075584-1-clm@meta.com>
References: <20251220002737.84100-1-dennis@kernel.org>
	<20260114122209.1075584-1-clm@meta.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ywm583h35pw7616txmh4mgzdgk938edu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7ABEF180009
X-HE-Tag: 1768518810-873141
X-HE-Meta: U2FsdGVkX18LcczhPpHa3v6zBtVvQnSucIcuTy8MLuKfBp4nl5RqafUPKf8+VAoD2vQMGLDNwy9zOxDkIILlCyK+9lIyJG6I6X6ppREE62mFv7YQsb7wPwFSjoJgBmLjWAhFAJsH268tjMo3jcgSNVJMzxhgshQ1ZqWywrLe2vnnlWQS7RsxAWooqCX3pmbyTK94nDxy9v3slLOr8oSm1OxkIPIiM1q+i3KubGEQssNI2xN6Muwc/4E8/gekmV0qCw/XaUjvgskSgFMrkCPep75gdmQ0cKQN1wT2zD/20oBjrdcaQsdrg3pwUs3a+ES4+SH8scoFUK3oqWpmYXgKc315Ppu+H6+HYZCek/4QXoPCgmBJrWoxSc3UNg0w/HkSPJFjU+SkOONEgm0v78Zm7fS8x7+GIlzaJekgd9/PHc/p93ePiWoCb7IU70G2sYBRYB5qv4g6G49nj6UO31hAlOIZLok9M3o/2FiZXKM2l5zMm4RH0Ax9GKUyDQPBL9BhhhliBj6lzZZBibsBghfiJA4ezmcM0y5VsmXxdr1lizkIilbaUbNrEuMSzS222HeCMTOHYMZBlLl46i2Fgk8K7dakCborKj/fdGCC584MYTbK87SuTRz2nbltdGRogWeaL8ejj4wZdrXKEusy3+fqugoFu9zNg3wz99hnDTTl5mlQBin9XrJ8M0zYugQiPXMNu8ppoJkm8L3vfYCUIJmZmtjFIekeOkKneUUV2Mn5Fa+Z+Ei3uYiQ/zOxPK8utE+THgf/6lahM2TJugW976I0/2odPLeSpYB4jQJ4JiFDO0qCn4H4fDClZWarR9nFBWOILN4yzjEcS/wIYJCYvVdYQOFPdvtPLPctYoL0JX5GbLb0YOa7SB2F3zr4oxdpzU4BvBKJJ5VYkR+3KmZ8UfAHvW4wo1ZBAirpgnCxKAuxrD9sYHNP4rPs8OipKi/4LI09dGFZp35vFXbwfQmQs5r
 6A4nFNsu
 /llIVQNexd/mvgpdyD01MUCwV8wi71OsmiquxwALcuix6rH1EBpb7HQ5GBx0CSLBVDplp3LQBL359E/ClvUNf6p2HGp8wPNxWl8dO3sytX8QMBh1pZ3wTE/E6VUT0vVjbhDLGh4UPxVUJOxLLyAkTawwRxyLHa6d/ZPDt2nEPVcHomoeUsuwHJFcYkyryTC/nBaLIBV42APtmMt+O1/BZbym0EaPAXfF91P6kn7UuATYRcfrzlxlVxCuXTBMaEnaT+uvYjjZ0B6NJlJC3phHK/QVCm2YHadfU7lqyP1pcWi6uDCvLx4e8aZR4dQGKK/ZXrYn3wGdsx9Q3HAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 04:22:00 -0800 Chris Mason <clm@meta.com> wrote:

> On Fri, 19 Dec 2025 16:27:37 -0800 Dennis Zhou <dennis@kernel.org> wrote:
> 
> > This adds a basic double free check by validating the first bit of the
> > allocation in alloc_map and bound_map are set. If the alloc_map bit is
> > not set, then this means the area is currently unallocated. If the
> > bound_map bit is not set, then we are not freeing from the beginning of
> > the allocation.
> 
> Hi Dennis,
> 
> I ran mm-new through the AI review prompts, and this one was flagged:

So good.

> If nr_alloc is underreported due to this bug, the buffer may be undersized
> for the actual number of allocations tracked in alloc_map, which
> chunk_map_stats() iterates based on the actual bitmap contents.

That's pretty serious, although unlikely to occur.  I'll drop this
version of the patch, thanks.


