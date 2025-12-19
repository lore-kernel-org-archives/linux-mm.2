Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F0A9D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23BD6B0088; Thu, 18 Dec 2025 19:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4206B0089; Thu, 18 Dec 2025 19:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DFA6B008A; Thu, 18 Dec 2025 19:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD20A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:08:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DA49136232
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:08:35 +0000 (UTC)
X-FDA: 84234284190.11.7BA77CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E17F920015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:08:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uPNsSIZ3;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766102914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGRqgNSVS+UDlUcqHaGXkyRi6BhU8rC2UKVCE9VNPvo=;
	b=matD2I/3uAPo8LCs6pGbPzpAD122aWWI+AGIIcbbRbQzIskZe/WDmInE9Kxv5dxg1eCUHz
	/5THd07pFqC5Cs766kvTPtqp38teJcQNNolpToDQo6Thsf4hOqxEmRgyiiYruT9uQOshvK
	oNoSi0IQvAnUHV1I3fHzxkhESq6eZZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766102914; a=rsa-sha256;
	cv=none;
	b=Q1g7d9C6KpQtm2GspQyhd8DMpBKu9LruZHb/ILquRIuEVbujiI7BDRNcKu8ICLaKgamuQ0
	uag00KW3TeH7J+3pyEV4oktPBUHg/dhhcZGg6HX6uMQ2B2RkGPjei5CL/secH639ACOPr6
	jxVR7G4IuTCybj9q2G7zwAR3Rx4kDF4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uPNsSIZ3;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A114143A72;
	Fri, 19 Dec 2025 00:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F70BC116C6;
	Fri, 19 Dec 2025 00:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766102912;
	bh=Om4RAVVJQdKfwzKaJj92V+UB8EodP6GhuAZCtWgLCCs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uPNsSIZ35o4md4V6dNrHSmME7WdL0qZV7StG1dvRRrfv70KLhICGld/Z6aS9TUBi0
	 bwNgeQsJrc/znWiM5RFkc3d830x+g7jPUkxG9wM5yboGvnNQjEjVZf/JqvVeW9eT3y
	 PoMtQcFGXmwls+EbpnsoAgI0mkZ7il26mCQ/ZDfA=
Date: Thu, 18 Dec 2025 16:08:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Elver <elver@google.com>
Cc: yuan linyu <yuanlinyu@honor.com>, Alexander Potapenko
 <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kfence: allow change number of object by early
 parameter
Message-Id: <20251218160831.566ae0c0e349e4d563c96c16@linux-foundation.org>
In-Reply-To: <CANpmjNP1tMwdOUTNEqqTmWR2Ki8yDQ+H13iSHxzLkomj-WComQ@mail.gmail.com>
References: <20251218015849.1414609-1-yuanlinyu@honor.com>
	<20251218015849.1414609-4-yuanlinyu@honor.com>
	<20251218155821.92454cbb7117c27c1b914ce0@linux-foundation.org>
	<CANpmjNP1tMwdOUTNEqqTmWR2Ki8yDQ+H13iSHxzLkomj-WComQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z6nch6umfo6gxiyjf7wsxcir5orbcjsg
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E17F920015
X-Rspam-User: 
X-HE-Tag: 1766102913-609126
X-HE-Meta: U2FsdGVkX1+mOg9sPCydsUBGaUkWTdBlksUyrMFCg7BCW7LA1IZT2UVn9lwLT0PnEDcGEgaC4liFS/9ZsENrI+7e/8qmpQ96nQSwM/PELMnar4eheCsC6larqfLpb4Kyt0MvZYcE655WCTrB/TNOInSLVQZu9I+JsbS4N6EOZuoJ84j6/pNP0B3uH3KYNCfwBilBFIf099kUe/7U85q9/UqjlRyEwYG2ewX2nUjIgskMlCc0aGKeMhTZGw6bYH1ck1iblOzU1hTl2tYvb1nmLmjvN0Ae4+R24X/ISDpMvA844zrHnFtzp1bjZiQNC77BtMevyXkXN1bBokuj2VLdtSABocKTfbk5//xfe30uBJdt/MkHIqAg6CDDzvUDWw0NHWtWbSKwkr5C9gjwNJWATbpqHJaWlFhFjYk+etZ4d0QEoSMZhN2s89CPjncyG9n/Wb0Mse1DFnNDt4M6xTSvX+zLuE51jjoV0T9RSLJAeSZFvCMCtB+Trwx6s2LVlRmn/KJ5zKku5/DYKgaMT15V9XKP3gyjyUDHLAjxpOe2HaOiuN8XKqTLvuWqdc8CThDkiOTct1y/2La+s5Gng95fZ5BiCH7RPKRpGF2Qxgpwo3iWKcZtZX61hN1k/ZmzPB7ROVBtdsj8APrfqkwi3t6KgNrXfnZN17EZXCi9F1k1o3s28H7zsxtJ7SQjvD5n4vG1dR/b084pbotZ4xhxA1cYCyNIVaO1TjCRrWyf7n1c/+6KvgBFtvC4kh1vLnUQpl7O0no55xybusiXWMQ+t149pjrSjIrbzDl/+uItIxuwkiUQqZ1cTNtU3WdlZgojiG3Tw+5p34fUzLf3dp4cf7Sduhn77QCnHQq4XvXiWKSZPpl85WSelx0lcnGG5+WeTLcEa0m8YTVw47MyUa4xtXy48NLjVhvxjs675xuOd4oEsV7c42KIS4FdpzBvSc3tq3fhQzesjse7D8pD5vdMf3N
 1Hgl3DEs
 Xw35BNYISafbGoXVsZBigfCPP0uGDB3SxXsg2jY9N1LFrbtVd0BmMQzq2y6zcQVEge+nzA69RrsBOidDd3dhTe5d+nFGL9O9C33HF5BUvSzW9+FULsoNTM/mXgkYy+aDAErOUpTTrZuCfs1GiSRkAo7uIdETQY1QGd8137MiPiP1Nv35nbXX2P6RS01HqWyyQNY5DX0yv0V+8b0hRhJHbZsgOvDba33QpDc/vx74lP8wFY/tWNJLJlmTD7bQkzQrwP1r7h5tzQrmqC6bBvm1vynevBRQckjchFdOPwLlL/Wpn8L8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 01:03:11 +0100 Marco Elver <elver@google.com> wrote:

> > >  include/linux/kfence.h  |   5 +-
> > >  mm/kfence/core.c        | 122 +++++++++++++++++++++++++++++-----------
> > >  mm/kfence/kfence.h      |   4 +-
> > >  mm/kfence/kfence_test.c |   2 +-
> >
> > Can you please add some documentation in Documentation/dev-tools/kfence.rst?
> >
> > Also, this should be described in
> > Documentation/admin-guide/kernel-parameters.txt.  That file doesn't
> > mention kfence at all, which might be an oversight.
> >
> > Meanwhile, I'll queue these patches in mm.git's mm-nonmm-unstable
> > branch for some testing.  I'll await reviewer input before proceeding
> > further.  Thanks.
> 
> Note, there was an v2 sent 5 hours after this v1, which I had
> commented on here:
> https://lore.kernel.org/all/aUPB18Xeh1BhF9GS@elver.google.com/

Ah, OK, thanks, I confused myself.  I'll drop the v1 series and shall
await a v3!

