Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E84CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 13:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92BCE6B0095; Mon, 12 Oct 2026 09:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC316B0096; Mon, 12 Oct 2026 09:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1F46B0098; Mon, 12 Oct 2026 09:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6071F6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 09:22:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8A2040DD1
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:22:44 +0000 (UTC)
X-FDA: 85314039048.18.B70C855
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 54E7520002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:22:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=btTTHYYF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791811363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SA1zA/aAvAwyDwvxG0nvSn2x6K8KbSluBej6fUI3IPI=;
	b=RdKUc9D/K8KXhNMaBfHtXngCWVSz8cr4FNcIBr+kgXEvuefuygukQ1n2Yv/Mb0Tuy0Le+U
	T2Ek+MQ9pH8G8buByJBXJ5xQvzxsA658X9EEqakYajFka5/ANMpemm5TcGJiokBHHdAhon
	pxwfTVEpI+o0PI5YtE6IUPjcQMWNSks=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=btTTHYYF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791811363;
	b=1k4mSqJ6F/77sza9bKDFMfvcTrjPwdb8oRO5/SxKcBX23LZJC8nqRnG9iRZl/ap9vWNbX1
	WlJslkwivRZ+eAfVY2nFtlkmawI43mfujP92EhjupxcEi2oAZTuOTl3DYa2a6pFTzrX2qF
	+9KDWWFLjgXruwjw3ar6hPFWMffJNSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF34960AA2;
	Mon, 12 Oct 2026 13:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0730A1F0089B;
	Mon, 12 Oct 2026 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811362;
	bh=SA1zA/aAvAwyDwvxG0nvSn2x6K8KbSluBej6fUI3IPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=btTTHYYFNly5SSsCMvsGH+d2DrUwpVRzNThCqYYA7da83/hK0I4xv54N7bhfBlcC+
	 9wHdVxn7bjee/ausHuG0D9lonsegBCHePgk3udpGdMhjvHv6RYs/3PSGu4lXzCFD05
	 0eYpIMrru2GleSTWPxb6OigdQ+OGtu6uFFt1Z5oBs2pAH3i6MRlDLBsou9BN3qmKMr
	 Y85nU1bkSAhdJB5VP7l+Z6HFp6Aq+Wst4jlfv2fgY+l03w0BWK6wP5Pz/eMsI+qF5C
	 zBdReAzEVgi6xoo5eqDXJ1qShfTCbWayz2+RjZ8thRf2SS1C2YPyR8xNdzc4+89TTb
	 i02u5pPh1E7Dw==
Date: Mon, 12 Oct 2026 14:22:40 +0100
From: Harry Yoo <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 1/5] memcg: move memory.high enforcement out of
 try_charge_memcg()
Message-ID: <aszdXDpqLUX1S4Qq@thinkstation>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-2-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-2-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: 54E7520002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: pm6jubmnhn9a4p5nsw59oad8tbj3p3ip
X-HE-Tag: 1791811363-748630
X-HE-Meta: U2FsdGVkX19EUhB2O3VFi6xeESDzN6CENsWtqKP/D34iaylfpukiBavC/1SwQn8vYdbg8sCQty6/jnCR9/M37PR4InvDpFW+IEm/xmuSvWucACiHS2RiAWMpYPcmwAYteUCiR7rdR+4lMm9O9IGDCiaTPio4DyhoyYXmEwgHvgl1ipcAdU3cx4tglgeyG3gcy+voljPybNBgqOGEWGV+sgGHpri8t1syjoKYlXmcmEWX715OtX+lvAvSAMqIwB8f/R8W6PHYteV7ajqvSFiuattPB1U4h6FjqB2YjnbO3IHeNVrUX7n3/Z6BZkcNTlLXRS7gCnT4VNq9oNiApa5uJdjNrM5OesVUnfc/w1M7gqyXHkEeVMWy93IIBJByN8Vr0sw4hri0+o9guYPiYQ7V/19oVvVgvT0XwQsmyotZ3zm5X6yoQnVQUKzIn5j6w6t7a7s8XsO6bNKX4Iv0DKyrhN8sry2KlcuFSz/xVT5xXywtDk2uqywokSAmkknuOUGFtbyOOTy5dMmArqq4T6TkW12+gNDhuOWd+hLXypsyGVM5XTh1O2zkXY3y93Og21vXvEEXhygzSO7zvETAc9oXHal3Taf/dy8ZfwNikOT7zA4h2L+mwqrbrwtfrLDmQQ+sDI+YVFUShBZHJy210HdyBwuFL15N0QMbSF/Sx8jNNyt+wwFTDY4SLFZMuHNfRHPhVyBh12+Iwy+8oBGAXj7e5er+6kBd+yQtA/OCkH/UJ7CIXNj1ZHXmpY3pZZLJhVDohF2K2oFUSpH+eRImSr1Zd/58yt2yHdcqHyRFjIKBFG1/eEzB+376vvWargzUtQc1raMriNt5XZRYJl+vdrhWvg3/QG6sr06ajZU3biZy52Xd+9M0sSM904N2FdICkWda4oeByqjksxL+bVuCMBNACp5Dm3vLhsO1K2hhg9kJ9VFpOYLxwuSs1MWGKCZk+yN4L5JUbPBwWfGdvbeKGXX
 D1BsXIRp
 vm37exrb0ZB9oneYaYizjjW5B45RWqzDuN3NmaocrXwnpPoCwzBgW6TapOvLf8anwbzTIz99RShkRd33rsG5fxxSTSHOGosQPjq/lrOtJq3AufFVZza5d4z4Bxen6RZP1sTV3n7VQjxfWdlOHA80TAuYW8r9Vuu4TQegLoOJUXBx/T2ZN97pId33i1t7SRkrS4uBPlHYfcWtTSsxFiMxJfq/N25u9Htnty8ticH7BP731+TZPlDbovwaFQ5NnnI7Yx/y7qE/4z/Ko/cWLfXHXCSpfu6AG+72qXgu9s8EeHSG4lGMuojz9WdxIsmWNl3jZGUBK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 02:09:53PM -0700, Shakeel Butt wrote:
> try_charge_memcg() does a lot. It charges the page counters, reclaims
> when a limit is hit, may call the OOM killer, and at the end it checks
> and enforces memory.high. Move the memory.high part into a new function,
> memcg_enforce_high(), so that try_charge_memcg() is shorter and the
> memory.high code is easier to read and change.
> 
> The code and its comments move as they are. The only difference is that
> the new function gets allow_spinning from gfp_mask itself.
> 
> No functional change.
> ---

Missing Signed-off-by: ?

Otherwise LGTM.
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

