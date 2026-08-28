Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36379C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C346B008A; Fri, 28 Aug 2026 13:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D846B008C; Fri, 28 Aug 2026 13:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EE36B0092; Fri, 28 Aug 2026 13:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1D3D6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:33:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B8551C1FAF
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:33:45 +0000 (UTC)
X-FDA: 85151375610.20.9579C59
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 84F7120005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:33:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u9ixxADc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787938423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58TB90gDtoT2gCyKPtI+Xjejo2Or6qNX4AWmOIe3p68=;
	b=YTI5ZWxZqO3t5TLOTBytIBm83lF+z76LjAhGisUKTcYggxiPG8e5oM7OsaqPyKfj/Zcmd/
	22KALmj/hv2zbRdsh7hVlwhi5qjX+GoCTSLGaJsx7ZUxUvJLhIVfzAW7MUkIoFmWdb6d/n
	txDFd5c1mjxj66hQJNdZa3cnjSO1sNg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u9ixxADc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787938423;
	b=5CTduhHtH2U7jN5+j/sG+/L5ot2+zc9Y+zf2XY2QJyni4i25B5uxPq2c2JOUy7IbGyLu0R
	RqzhnvG62LM1q+Tg1rQhGaF9TPz3QXWnlQUX2xbKILSkowx4O1YPMbksFasvSybAP25fAL
	luC/rPvQJNDEm1q3k8DUHpEMbgW0HNY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=58TB90gDtoT2gCyKPtI+Xjejo2Or6qNX4AWmOIe3p68=; b=u9ixxADcNWpqoL4CR2/w+LNb+R
	+cvHoDegJXc6lRPO3kBcHeSxLnxVkLHrFS7bLL/OmweNL+9uEt/FGYcgsDVnL1e+44wf8F2tx41FO
	n0YVV0X1LVTVTVs7UqmhWUw85xGqcttKdCtAwRk2d/in2UBfQTr0fDhxqeZjsUVJS+MvG9MtTFYHR
	QgOJcczEgZz2N1GEQkbWst9H0wkKQQTwkhD0pN/GO7u2pANMUFqY3tM0rTquSjNjc64GQfWIfUpS2
	6nxaZaCeJorCE+J1zK1HMGkX2IoqSt0RCP76pFtluaMTndWJvJUALrBCL1XrV6jAyOLTNi+nFU8Oa
	GC2UFNQQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x00ST-0000000FB16-28m8;
	Fri, 28 Aug 2026 17:33:41 +0000
Date: Fri, 28 Aug 2026 18:33:41 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [GIT PULL] Remove dependencies on pagemap.h
Message-ID: <apHGdfwY67YZ4sEr@casper.infradead.org>
References: <apG8g-5krNRUFUuD@casper.infradead.org>
 <CAHk-=wiY22BnQkAMMc8-h6xaRksvVAbASpg=pj+=kVaXXQYo6w@mail.gmail.com>
 <apHC_mHJ3wsJPEgy@casper.infradead.org>
 <CAHk-=wimz+APb9hGEry+vHDLB5D7WZvNGWU89HjGw7wH15KGHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wimz+APb9hGEry+vHDLB5D7WZvNGWU89HjGw7wH15KGHg@mail.gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84F7120005
X-Stat-Signature: 5gzocpstkgbipedzxe839codixaag43h
X-Rspam-User: 
X-HE-Tag: 1787938423-972986
X-HE-Meta: U2FsdGVkX19H1rqxy0k9rktxS5VnUZ/634HkJHv+TiFouSnfavpomA4SlRua2+yMh1uMEbo80hmBdo6PgdgQCMYVhuOY2xoPaz+ftqWp08BzjbTCDRORgcKBAsHPEkN3/4+KO6fNjZRtkSB5oFWaFpysfy5Y08Oed+UAwSY+JLqKKy/q8uqYBGkWtR7Pu2YJjTO53aCTPZ2sJWgROxE9l3lebtOmSpIk8qAVbot6tRnI0c6HAPt0FjnL3EqqSweQvYoXx5j1HzATyoEjujuw/i77NRC30KIfjqKeC9kzWq/UVwYssmF67lzjJfhNjLY4il4T97w64MCry7jjX0VDctdjd9gikQWuaPn3eXcGQWh69K4xYjlwX3QmBM1CQ8Dmaiq0QiFeKRs2D9pzEuQQYBZyDUyRyknM5UHhlHxtLFFtFeBWr/TSrObSqhvWNVea7mHWu5WU98zobNTn00i8ZVODBrZQfdTmavQa6vMhNc7/HanStklhlCCfIW0oriEDgPidYF5vQwb8pWK5V1DV1tZImY5KeOo8Uq/B0n2SmhyAe94zcw3oteEE9LnfDNIXD2mV+WNqJyq8g1VJohRkfxqlIzMquWl91boh9tEeJG+Z66ECu3SuIDmO6UIsQtzdcCNeSVcj0xQCVHS7M9pykC4wb/l/C/KUiSGiQeogpr34E6Tq8+nd4oFWWL4I2HQeAWflotqgyya7BEF7nKs3w2w/Ta2R8Ku5MGpq2uxr0jQF+zgp3OcE3YKtgxvYH6s7cvV36aex2whqhYWkV9llx5oewF1neH75FIMKwW9GUbXrEt8HUqdS3q0yEzBq6zzhe1jl8eUzn5i49qj+ErhsbvnBkLh0Y59TyaGqQT2PRUxwBIM3w6CM8B4yWq6YFQAWuIfxlCYm9Kj41cy+AhVCuTEuEmFAX7fU6hZ2aa8IA9Eai0bO4VApoTZF5AhH13VkJt62g6COFBLJZQ47jYr
 +XaHJfGz
 1TBJQynq+8e5xUOXhNdcVs+dioSuV9kPEFMflDD95FcccQx2oTZIEvmv4K1N6TwwqdcWj9AUQcFX7DVqkEShRpp2oLOPLL29nctWBpycwZoV6lU/7MQmnqUNnNuuxd1Aq2ukAwjiosSc3o+EN+hh4XDHuRJvgHsPpQC3/F8/HQYvdvU5n/9QW0CPmkhYX3dkwGH7IGB58GO001c45mHFUOV5/8p7Y+j5yZDvs7K78+zSB1Li5ztaCEqZ0VIO7hegTKtv6UxHd5fV4y/Ub8ktq6DfLLemxcNBU+5F2+18ZCC6ub3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 10:26:22AM -0700, Linus Torvalds wrote:
> On Fri, 28 Aug 2026 at 10:18, Matthew Wilcox <willy@infradead.org> wrote:
> >
> > OK.  I thought you liked this kind of churn stuff at the end of the window,
> > rather than having it create random unnecesary conflicts throughout the
> > development cycle.  Have you changed your mind on that?
> 
> I like things like automated churn at the end - IF I HAVE BEEN TOLD
> ABOUT AHEAD OF TIME and know to expect it, and people have said "this
> is scripted stuff that can cause conflicts, so I'd suggest we do it
> just after rc1 when all the big stuff is merged".
> 
> But I absolutely do *NOT* want to see a random pull that is broken in
> other ways popping up on the Friday before the merge window closes
> that has never been in linux-next and has never been explicitly talked
> about with me beforehand.

How far in advance do you want to know about it?  Because I did send you
email about it a few days ago; must've got lost.  It has been in
linux-next for a few days (would have been longer, but the Intel test
robot kept finding random drivers and configs that had build problems).
It's already generating conflicts with other header file changes, and
that's just going to be amplified throughout a whole development cycle.

I'd love to script this, but I just don't think that's possible.

