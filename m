Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D50BCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D66B6B00EE; Fri, 26 Jun 2026 06:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE066B00EF; Fri, 26 Jun 2026 06:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E6E6B00F0; Fri, 26 Jun 2026 06:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0538C6B00EE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:14:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 922E88D479
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:02 +0000 (UTC)
X-FDA: 84921653124.15.5C79CFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id F13BFA0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QeqtOWrw;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782468841;
	b=A+A3zOjSV8QBZMz/Xrgq7cuKITfMZ5xvBiWeciU76a7A5rO6/htlESMs57DrHozAgnHKgW
	6CbhssClnIOiYVIrEMoLG4kXSu0N2/ks4nr+e7sXPqNab9/5GJe8ezRVuLS0XwyjvJfo8S
	uS+i8IS1ydbK1cDq1+auWcEPZem+uBo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782468841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npGKdarXf5gccltScbGUlMqW+/k/IwUKWJXo0mdK4HA=;
	b=a9m9aSVS4bgrDjyahTxvOUuut0RvElLT4aS/qd8VrHGL8yISoW23ps+tix2WhOmcqKJFjm
	ygUmrad5sBz/FDLF5qjBrWW8wMcm2Ka7lpv3KDsY28pQEidlvUwPaO4cVZbeJBdTxuWmuj
	VJKp7vvcWoeAaXqYgp4zwwlE3yhM7TM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QeqtOWrw;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0E6C4333A;
	Fri, 26 Jun 2026 10:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295501F000E9;
	Fri, 26 Jun 2026 10:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782468839;
	bh=npGKdarXf5gccltScbGUlMqW+/k/IwUKWJXo0mdK4HA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QeqtOWrw/nvPfytCrj64spgdjebDv9dxdI/7ffl0uNJJvUiah4WzurpwKx80iW6xF
	 joEFraG+d0aXcp+VscaSEPyLNm0YilTzfApeVBGNwhOUJIAIsaQX104gpWwe1eElrw
	 zLVbBDiHL+Yz+EpE/KOko5HJWN8Gg1791euUt229lmlhvkLyvqCj4OvA0/k9fLefWJ
	 DHnlP1wFRq3uWshwZeQv5X90qpydKMjP6mcjEDWE3RgrHW4rRuUEehOZLiUF6BA8WP
	 LpROwQLuvECotyYP8/UlvXVgmnKydhqOdyQFUz6drRtafw8eBITvxf7lZ5IHIA/2nM
	 JarTtKU5/LgXg==
Date: Fri, 26 Jun 2026 11:13:51 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, hao.ge@linux.dev, 
	jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] MAINTAINERS: move inactive maintainer to CREDITS
Message-ID: <aj5Qyp-D1BHdqIwJ@lucifer>
References: <20260625184857.2193482-1-surenb@google.com>
 <20260625184857.2193482-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625184857.2193482-2-surenb@google.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F13BFA0003
X-Rspam-User: 
X-Stat-Signature: fp4k7aah3fxkgabxkk5j67zcqco8ecid
X-HE-Tag: 1782468840-290582
X-HE-Meta: U2FsdGVkX1+gbqb7XWdQYY7cg8anv31YnBzNv5biT2t9UT3Pd001S5+6FJQNYUV+NaBp/s0sj/iKFwN6R357AkKjyaisxok+qhEA8quvwM20YC8pJd8RYWKaMkjheOJ+ZMCqCtnYNSezaqo6ime+f8Z28/K1G3yH1ZT7OVdXNEht7Hhijux3zRczi0TRxdQ2bQLelsos1iiz8TT0yh7KTsvll0ab4OmypeFrRhQffjgD36TPQeyaYLqCHWnEJG7IUt0BKpSLAS6bCGYbhfO0nWrvrQe7dmK9CS+7gVCW4lPrWOaQhDFRixZWkjX1qJT6DtikMrxPM6f9T/XHUc6jew5fBdK06gh4aHGaNp6wdl2rsh3nqYA7u1l+o3oPAhCJQRZJzET/YJgIWuX5qAWZHa8z2JyN9vhoncG7Bfk/bQ9dNdgKYuawPdefoYX8vwnjTJtGykSfeY/BAmUR2vjEem0gG81ofN9SaN5bsipY8F939uVC6+pW6UNu8NTOpc5AIH+RIAXpGYISnq2DCAYG/xTt3RIyUJHlkKqAod6EEpfbkm5jX3BRd6FoIuBaOloUBuP68XO3kE/2FZFYwOXeNKEzXVhbEBkJnAEKjtncZPqrN77qXMEsK39lqg4hMOLUn/26TwnC6K7DFe073eGCm0oshndG4BeKbCKw/9+k1DxMgCE55M2Lf/yvy7jop6Tii0wTChYtnoI8epPhNLPW7tE7kJVO1SyGwlisSFU0yD2STnQrsvuq6JJ1HhPUbXyuqfGmNm1VZKELk5/GujEehfFh4CLtX8l8gkw0Kw2o3ixCI3yn/qLU2ZfgYQ8/DZee8nEFol3hIB+49nouDMfoD4cyr1imzQxZOmkZk/p2JmVGMgJPS+eyybauoweAWgyf5sw+6qYw5d3eAOVHZF/B/NMHAYbxM5vO1exUTS+mvCouR0zf6gndswjv650Q4rHQ6QZuDBxIu1bChnZW0pW
 0BwNmnyC
 Q/5gX9e4tF9fxU8yM9J8Oaiq8X3LVWhcK6kKGWioWgQlexJ4gCtxhGdXx7HMYTeWwUX4ph/PlANppa8A26/z0cYIMtL0X4xvHyvDQ5gzP1SOGIu+kSA4iRd7jcV45v/GnR5F2Hb8dZ3r1aduCP4Pu5PjH/QEBJPfPWRHOiespi1v5oowq6aBbSBv9xNUE37qKDRXY4fR//gqcdd8jlt65yc1Ca8ikkQvU1+f9YYCD8IHxS/6IlSf5bxt9tgq031klMdf7XBSjsRe4XZuc5+gGNabgBCKa8ZqupHW9WLe7hG960c0O73xRdmkoVQWkV82wI0WXIe0bW1wuAgxLckCEk4XWbaAId2qjVtN3rvOvw51+ChrGiA2g6dWZx3nG8S/dCdTy1jjhxYDl5JbvJEiBPz475X27/ZS3JTIjlYWb2uCHVPIgWsBrsKNK5ljrYPa0bJrJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:48:56AM -0700, Suren Baghdasaryan wrote:
> Move Kent Overstreet from maintainers for Memory Allocation Profiling to
> CREDITS in recognition of his co-authorship and contributions to this
> feature.
>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  CREDITS     | 4 ++++
>  MAINTAINERS | 1 -
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/CREDITS b/CREDITS
> index 17962bdd6dbd..9a3e4b639505 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -3091,6 +3091,10 @@ N: Jens Osterkamp
>  E: jens@de.ibm.com
>  D: Maintainer of Spidernet network driver for Cell
>
> +N: Kent Overstreet
> +E: kent.overstreet@linux.dev
> +D: Co-authored and contributed to Memory Allocation Profiling
> +
>  N: Gadi Oxman
>  E: gadio@netvision.net.il
>  D: Original author and maintainer of IDE/ATAPI floppy/tape drivers
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dd963b72c614..0948dc573744 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16706,7 +16706,6 @@ F:	tools/testing/memblock/
>
>  MEMORY ALLOCATION PROFILING
>  M:	Suren Baghdasaryan <surenb@google.com>
> -M:	Kent Overstreet <kent.overstreet@linux.dev>
>  R:	Hao Ge <hao.ge@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> --
> 2.55.0.rc0.799.gd6f94ed593-goog
>

Cheers, Lorenzo

