Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E97FA1FFA
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 20:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628A06B0088; Wed, 22 Apr 2026 16:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDAE6B008A; Wed, 22 Apr 2026 16:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515166B008C; Wed, 22 Apr 2026 16:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 411C66B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:38:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4E958B344
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:38:55 +0000 (UTC)
X-FDA: 84687355830.30.7065465
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4DEBCA000E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:38:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=fJsdlNRs;
	spf=pass (imf25.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776890334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Myx3FIa8bS0xSb7wLpCaSLLaNA9VWrPM3xCq96BkvKc=;
	b=cLmuyn7uE5qnoN0LeatYksvpmAbbmUDs3jbYRyboYXDIGzTAAscaxjHuoLCt9RHwzAyDhq
	rgT4NmBurHRoS6fPQWxDyxx0Gg/kArKyv45tYSMoGa5fUVeog8pkPkvY+OWwcCtvAIo3zp
	IP+wMaEbek6vwhk4E2X38npnOKyuwQU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=fJsdlNRs;
	spf=pass (imf25.hostedemail.com: domain of konstantin@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=konstantin@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776890334; a=rsa-sha256;
	cv=none;
	b=nPdJwd37lZcB8yP0Prjbg1/lGL6tbLvsJgFLbeMRUC6g+gytnyFhGEhliX77YrP8JGDw/H
	dYi59AOm9yKwNxRetca/lIbQAQawQs2rZEr/bZKfzDGq2RNYQEIFLYhwfygQWISyJvt3p8
	3uwt1cOkHOkBLPD/bckmG5sa/nnsXV8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B2DD06186C;
	Wed, 22 Apr 2026 20:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4296CC19425;
	Wed, 22 Apr 2026 20:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776890333;
	bh=ypjIFJoMGkV05wpDN6/610qk87sp/CSBB17c69vu04w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fJsdlNRsGxjvffWG+b5UNCN7OGX4bUL8gzUCiGvAe1XbSiKiJP1n4ou95lZ3uTUMk
	 UO2rLBgcMzZFHTyFaVyP0RneV1h0tEQzSbBjI42EZnfCYynLJdZw6Pq/nhFzF38sRf
	 NRhjxOTvrJaHu4zZJXfejx3s81ZGvlw3OQt4UfpQ=
Date: Wed, 22 Apr 2026 16:38:52 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
Message-ID: <20260422-aquatic-chital-of-wealth-8b7fa3@meerkat>
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
 <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
 <20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260416011820.18f5a11bbed7fff54be761e2@linux-foundation.org>
X-Stat-Signature: pzw3wmhixjg1csrucsd46zicxma54r8a
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4DEBCA000E
X-HE-Tag: 1776890334-405108
X-HE-Meta: U2FsdGVkX1/rOMxZfKGga5dHAaQSpbJA5V6oTS/2UYVZZPM4V6OR+iHSOqCcEW7hf6qQGGpmAb4x+OG/7hFh+44GJrPeMAmHZfLTOSewbW36hv94UHc/y3mRnQNuWerIaiAUmfz9LFdUAMfml8A7zHgnVBQ5qfRVS8EjM5faAj9OYjqptbo2LUqdlXJaLY/LRXUOIJ4lJKMEx7fFzVKKbLs3sIZo+8jDtE+Aq3iHRN9sEXJRXKLMt8dKDzY2F661J+sj6D5BiqAGTmdgqkyq+XFuTXoDik9G40vctUfYdhrsr0n+Rr86sNYRf6vxicOjBReAyYF0ViuG5DqHhpCreJbQMzQuMKcDwlQQeRtMzVAzC90xk40qGRQgeeXZUyqqNXdHdR3FlTfDPaVyJaHbN26rfY+pwN3EiY1LV0aea0mWkl1reSvx3VazJksOE/sr026epM/NPABjstavCUfXRUj1AmXm/Q5SM/ApJDgxuzYBcnF6jja8pp9NcESif2+Lhs451/LOFHz1JcC506chnhDbKOnI/XekugN0tTqj17+5tnqUBk3rw0yBYfLBcm1qnLiGHPoiiaMBy5kxwfYlCMcHEgR+5/K4JAVpTaGtgh2pLi73kmAJlQviH5tqWsbRvwrGPj1YjmPXzXrKY/G6ZBKI0Ag9nakvqyv2molrsfOlw9KKJULR1I3+y67wkuTlQeECCr/OaWWPm0IQ/+W1Lk1r+zPr7Sjcy2I9JXSui8Cw42tOqjzypdWehJXRDKnSQUpMexpM5tV1yXhAgJzC8YNnXSg0byHo46aDVYAxUrv0V2QPwDmpmZQw46byKpMbH5e9a7G/ppriN3JDY5pjjoKkAgWUmdnR3AMecNVALdbXBMjs7rGC9TqsQxJ+MoUdNHSd2QSBB5mxnNZeae2rEBk4+FGx3p2c6Rib20s2f9L4e2cxzhBFtP6d2h6KsWTX4Ro6jU9lXMYTVQ6F8Bn
 qkQyZqjF
 s4YWYbCmk/ZnYZyzk6PI436uhskL5bo0L5FdjoJ5Nyr2VxkGmAIkt287jj1kVYW2KaMQo+nkgEnQQKpuh/mSYfKQGOGL9sZYZxhl+lS7kMgz94F520QmdxOEH2rCooGN1i/ALC6YWIFtgiynMG/y0z9zW4ha43U8MyrYGH29qyS/638ns5v7oPBUVsyDNPrSyvCA5MCCAoyaBBjO8BH685kqrxtQsvR7jCRyFz0JRq39ia0Ncu1naCceM0pn05oHKcYK0rBJobpVeqm+08e0CXYFMtAIprdfGOuX7sRgqVW0Kx6vG9MXEXrtXhu4GV6i9R7gnf1GWp99H3kSsaEGI6Jk3iRDrd6XEjl39
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 01:18:20AM -0700, Andrew Morton wrote:
> > The proper format would seem to be
> > 
> >     https://lore.kernel.org/all/aaGiDINfnUexT9Px@sirena.org.uk/
> > 
> > (or "lkml" instead of "all" if you want to be more specific).
> > 
> > Maybe something changed recently, or maybe your scripting for this is
> > just broken?
> > 
> 
> Something changed recently.  Maybe Konstantin knows.

It's a temporary blocking measure against aggressive crawlers. We'll restore
this functionality shortly.

> I've always used https://lkml.kernel.org/r/MSGID.  So at present there
> are many thousands of broken links in the kernel tree.

Well, the upside of this scheme is that they are only broken for clicking, but
they can all still be found using the MSGID. However, as I said, this will
soon be restored once we migrate the system serving lkml.kernel.org hits.

-K

