Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2CE5FEFB77
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 18:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A1F6B00A4; Fri, 27 Feb 2026 13:59:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47A46B00A7; Fri, 27 Feb 2026 13:59:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53AA6B00A9; Fri, 27 Feb 2026 13:59:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A04886B00A4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:59:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 536405B484
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:59:26 +0000 (UTC)
X-FDA: 84491149932.09.358119A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8BF16140009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 18:59:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GG+y5SXM;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772218764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=EIrWJXecUwOSNUVa05Ca1QM7AfDr0Z0Aqu74XvxDSck=;
	b=0N+XAVNHqQfAetqbGSqnDdcxLOwlM3wmbA/zvXfiTdqcvyNyBQzo/tBzFeVhFSN048XNKG
	x+bOap61OivTgLo1iqtX4FuEWR0mx+T/Reha1pylUBAJGfuf3VO6LntQVfK7rj5x2Y3tTb
	vL6EzPHkph1VVtoKmGDc4LvELQNGf9o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772218764; a=rsa-sha256;
	cv=none;
	b=q9EJ3f7P9ImhWhFi+5Fd345ck0OKAPcT6L8iCHSIUR5Fn0a+siApP3Qcu2CoR0kGfDebq9
	LgDwUGoBYc7x+iNVONOKZ6nM2CPjFp2xXxSZdc3Q6IpRLXdDwE/CefHB9BiOjxaaP461tW
	FpkO57glCOnlX5aVWVY/MHZKjiBscKQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GG+y5SXM;
	spf=pass (imf26.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D72AD60130;
	Fri, 27 Feb 2026 18:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841EFC19423;
	Fri, 27 Feb 2026 18:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772218763;
	bh=cWON9DsQcCJd5Y+TrzQf0qsVkr+GZR3c0vp9R/fzMFQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=GG+y5SXMjmQVPX80GQKCEhHz/N8XFU54w2abIjYQX+kDPUjb3ZGTrSrkGITPLlA5u
	 Lsu37pxtXOnh3jJZGzlnUUEjv7ZohFwMsMo0g+lmkP5NwwbyHZQh/AuaacV8riTieY
	 aenhdPqlceCU2wmQEtAA8nhEczbh8YEZlJlwVYl/CtPfcLTLO31nix4bbTiDVLc6F5
	 VWL6Nraq5cgKbGG4SGVXKk6V4NAFP8dT1qsxM3vPqzBrKYPowPW8ryGsLORfy0f24+
	 KiMoegc7Vm9nrK4wXvwmtiVcAZwjdYuiIonnj28koNcmp7B75FQ40pK3VIIe5c4afH
	 +G6OKUpXbJF4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D07F39E9614;
	Fri, 27 Feb 2026 18:59:28 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <682fcb79-bf65-4af7-87fe-bb28274e96a6@kernel.org>
References: <682fcb79-bf65-4af7-87fe-bb28274e96a6@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <682fcb79-bf65-4af7-87fe-bb28274e96a6@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc1
X-PR-Tracked-Commit-Id: e9217ca77dc35b4978db0fe901685ddb3f1e223a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3feb464fb7784d09008dce6c95f895e815ee97d0
Message-Id: <177221876720.2713791.1907630502557817504.pr-tracker-bot@kernel.org>
Date: Fri, 27 Feb 2026 18:59:27 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8BF16140009
X-Stat-Signature: 37kztdzjt8rxsxxowqwjrw8mei4krr8m
X-Rspam-User: 
X-HE-Tag: 1772218764-984850
X-HE-Meta: U2FsdGVkX1+/R1uBE8SdcRJIiiYMI6pUOkiBIMl+pIaOdXx/CiemmF00sUouFFf/FBPY928coYkpk8WvRH2azPD8rYZKQzoZT8fcaKwEMG/PP7PVGRTFZiGOquOWBWoKN48ZjGrQ0VWq7YQFeavfxqJeob/Wmxfk+1a+XYHDxGAHuvrDBVFV13j29Uh6IPAQqa7JZIrGYHVZzZkfqOc1UGl8A1kpfxjIGfMb17Semf/kaAKlc10haQKIqjgZ2Rne3h0X5Wkx9/rzbVVx4G9f9zKqxlXDyPqCt5agkhhyWm6up+Ex5QwR3I1lU9iY5ObBrT3PHVxxTTyKffQx9xAor7wE9keg9r84RX2SXXxVruKEJ+GTuU4Sbqaa0L97BDlLzp6/r5Rc/6pQjMjvz8vwa4Hn+vqg2PHyO7rIyNxie1Yf0RpcNaqwo8zL/xfjj+tDCbFtGUQEYXj7xer63VkX8KxJ9NFToaUBs4uwPIecf2N9aiYVcNjVQwhR1MFtc0VuPp6aoH77+7MfhB+v8B5d7AcCYZS8f6S7JgzI3th/F2qbvG46PENoie7vLdENHYzFSIx+zvDmOM0yV4cmcga0P+V1FLA3OkH+aTqXEIUBHywgKNZ359VE7giRPt6m9gdw/UNSN71Aug6Xug/TqYXkwzLJSSXy3ZtjYw9U3g8qdlNXFBjN3aEwAw/TlDIpo5zL+lzM3irXFlccv4oT1zAjp9vogABd/6yBhDgetWAa/QnhxUDxJll6+chOoe+VRsDQXIA/39uheKqC05J7Nun6IJ6B0J9NM8Dq5cSzTGrv+P9i0h42OFzxL1s98jnNe/M+nrg4ALNyHnO0CqZKp5fIw0gkb2Nh9uVmKL6i7unriob2be2zsoIQ50Fa2lLQTk/R+OQSYSqYFCiOy/7GNWj3KCZb5LxSrCe6AqyQcW+ctvA+1jbAnhLJz5RpsfSU+tWfQ+Cldh9Whw/HevhaZMa
 T4dEFlUk
 fR8jWYUm7l8dqKb07azQ6DbsWcUNzSgCWdEbPlpCt446CvZlU4hoRvF1Ty+6SYZw8IwOtc4HOHDayZUVqZJniGc5ljDHR2jQMauHUKwGm4xCfndKE5LZAEWimqaVcwoy8TAgdHk8TQsJxxJWKDii3TLhHyYHLQk5DajsHz7ctlvNtM9huw1T2flBzaw3L+q+8W9Arca+Ek5z5Lpg8QPVssd6TKyb48VIzrfBNkhYAy3PDVZZOz1AjZNi630FaXOB/nuhqUnkmF/8iFCR9FMyxRHOS/eav6DNC1ndff8texbzIxOOsUShFPJ+GjAfowMkF8er3S83lU1Ss3tDHDbu77LlnmjQdPGs38E4rNV6fW88Fcm6n7UI/9+e9nQP9kp0EM0IsNN6GcYcvKOsDtNCHEb2yG9u7MdTDP/2ChCZrN89wNEYFNjvgDUD55g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 27 Feb 2026 16:54:51 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3feb464fb7784d09008dce6c95f895e815ee97d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

