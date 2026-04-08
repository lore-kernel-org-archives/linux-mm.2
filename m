Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C5B10FC442
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 21:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0441D6B0005; Wed,  8 Apr 2026 17:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36C86B0088; Wed,  8 Apr 2026 17:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52776B0089; Wed,  8 Apr 2026 17:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D797C6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:02:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 378528A9C2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:02:55 +0000 (UTC)
X-FDA: 84636613110.21.4294B5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 817ED40006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:02:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q4siIfZi;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775682173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTqdlzSVCsCj8eIGPpTEsfoA5yVi96ze+i3bzGUEx1s=;
	b=AMlMG7zfivCA2N/ftfYxJQSitGMeJgS5PIprwQ5vda10rzWgHWLzQUPxvJVH50brnIsj14
	YTJFXWT2ZZEGqs3SIB7MQfD7p+LNkGd27P99uN+3ud1H2GxtBpD3f13fCZ3I7iCD47Pelw
	zSqTWsv81IJhNRAaG05j0h20r0miSJI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Q4siIfZi;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775682173; a=rsa-sha256;
	cv=none;
	b=vqOXqeXSCd0GgNZ4EI9uLKPcHv037FdhENRWhPWIrzi66D6xna7tDsNFce+HfAWc2NCePY
	vrjX60tWmYqSYcZK/iyfh0LZbpJY0d3wAyqEUbBzn+lehzE//1zetrCfKW4bsmehxqTRDE
	tSy86yOG1t5mmHPOACBx4RooS/LgqpI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B192D600CB;
	Wed,  8 Apr 2026 21:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9852C19421;
	Wed,  8 Apr 2026 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775682172;
	bh=psYo50zJHSL5yH9z50ceo7cT2eNtm2mYQFhEmsP0pgA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q4siIfZi15u7OMB0K85RsJ4IaTyccT4bNEwUt1oswHTJurxvR+tZApmiPxM/qlj1W
	 /gVjwNZfgZHoWlQ20sUq+t4Qu4y6/EyL9yMtFy6gvrNLabvAuK6yGBzHXfmup4XCHN
	 t6jT7CNk1R3j06zwZ+LpFKhIhy9OCd5uf2a28pLA=
Date: Wed, 8 Apr 2026 14:02:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: anthony.yznaga@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, david@kernel.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
 Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot
 be locked
Message-Id: <20260408140251.6158aa7a56f71128471f327e@linux-foundation.org>
In-Reply-To: <83b56ffb-6e2e-4c9b-b0cf-9f04b61ebe7f@oracle.com>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
	<20260402235933.10588-3-anthony.yznaga@oracle.com>
	<20260403123120.82cb5becb19e1b572d474394@linux-foundation.org>
	<83b56ffb-6e2e-4c9b-b0cf-9f04b61ebe7f@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 817ED40006
X-Stat-Signature: yekrc1h6fir6rdwefst97dy541nzwas6
X-Rspam-User: 
X-HE-Tag: 1775682173-434902
X-HE-Meta: U2FsdGVkX18ku2kVhIL9bUJzkE6Fuq16xp4lrqfUiiva7uaC4wKZWgvymdX3Ygv0AvRpV7uCqzVSnQ9gTYY3IhKbZholzHrL/Npkpjlj6ZumEbEXq6jNEIvH7012LtMBzGFLOOIpxjdx/CD3y8XjIpHK9bSXUOTcEKUtuvHfuMeu54cxlSxzyudWkkE3lbrWCcW/ggwQaiCeGTRpw8kArbn1ZUS5sd/Ntq1zbaUa5lrA7Ul1qj74nG6p/3b4ZxXh4+v4zaLW2rUkj4WKhVCbDCokByZtryXFD7SwuFb7Jwc2BlgZfneOKBoeSErU7p7MxV/5yv+XhLChWNSnIR7I6qnKSXqXIiUvgOqXFyovfFbFy1rQt3TkivGRv9TtWYM7pDxxW9tfghmFAVa6LjyrgJssFzpM5unrt5U8M7IixdCgVgdKLRAiG9SguJGmUOJhhTmsR0w8HJN0pef/vg5SMk6LFN1Es7wrxUv+w6OAzB6svB9Ll2wMR9NAxHzw+ywhSNH3VlHTeAPfriW8xdrXcjw1dOIksfNY23nCxailKd2kseCx5QgWSpuZ0A+sY+mlVxnYytQUN6VzcAh9McqEwLGYWihCGxkAQ9527jP1ZX2yquOXyZJKWFQl/Ah6v615e3CErFs4c5h9/Pg9fW4Pq1ED+uaHObYHmXXSy813x4saQi3+QdyTcb4uWZV3nenxJ68pOo6M5cTdcb+OjEmg5cg7FobhV2QOuU9ty2P7UICDkEeDdNCYRNepNXUZjWRDzouqtu+vKfSxOxs8psc0820ULx/GcQbcpKBD0gdLn/WbMB6ckGfZymGtVnl3ymyQOc0DdEQL4kKrNfkej9fJZ13cRLjNnT/epKmNZXrkQZUchxF3epkEoFYw3T9StnT6iy6SNhNlyDi81LSGnORF6fyVuisjXbTwcz6YSAR99HK3MIAIXsk/OL9/i3ENXF9b8U23Cw+cSSnp669gU9k
 fSoQ4dpP
 ozU39O8WiKg3jGs5qnOLRPZrHzvWpr+o6ZZBZA55d8R7xhw0ZeZUj6CV3MaO04q+MX0IsB6YUbzW2sJ6sLecOU5B2uEbqPJvdHNmJ7v1AWUdWs2u1RU3tVQFTG/c5DuV5TKMAEdn50JjgtZWZje+t/syddafVCPEHvT4+vRwSXyfOOyHTYwBCWIc402IKQd42Lm2lA3STYmyA/TSxrZr8idTBopL8xRM4l61jcGovaDG1ZkTk06oK8WQNwcVlBSzbqJn4BLL73l+N06qyh5FVLCBXhTD6aKBn4RHx6xiP92FsdcZBtsunEjLf6cuuTddjDNbgPnfH2CDqNpc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Apr 2026 13:35:42 -0700 anthony.yznaga@oracle.com wrote:

> 
> On 4/3/26 12:31 PM, Andrew Morton wrote:
> > On Thu,  2 Apr 2026 16:59:33 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
> >
> >> For configs that support MAP_DROPPABLE verify that a mapping created
> >> with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
> >> be locked if it's created after mlockall(MCL_FUTURE).
> > There are a few queries from the AI reviewbot;
> > 	https://sashiko.dev/#/patchset/20260402235933.10588-1-anthony.yznaga@oracle.com
> 
> Interesting. Of the two issues, one is certainly legit. I need to add an 
> munlockall() on early return from test_mlockall_future_droppable().

Cool.

> For the other, the question posed was whether the tests should handle 
> possibly being run on an older kernel that doesn't implement 
> MAP_DROPPABLE. It seems to me to that a selftest should not be expected 
> to work (or even necessarily compile) on kernels older than when the 
> selftest was introduced, but I don't want to assume.

I don't know that there's any policy on that.  My attitude is that
selftests are not intended to be forward- or backward-compatible. 
That's why we ship them with the kernel source!

If we get a selftests fixup then I do like to backport that into
earlier kernels if appropriate, to keep those in good shape.  And that
has the effect of reducing people's motivation to run a later kernel's
selftests on their current kernel.


