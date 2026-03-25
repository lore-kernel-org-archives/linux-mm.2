Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 792F3109C028
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12E56B008C; Wed, 25 Mar 2026 11:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3F86B00A0; Wed, 25 Mar 2026 11:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD96D6B00A1; Wed, 25 Mar 2026 11:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB9BF6B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:09:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D3EA1A09CA
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:09:34 +0000 (UTC)
X-FDA: 84584919468.22.7B325D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F091EC0007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:09:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VoPTODcg;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774451373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoH1h5znVoWkoA18fvEtLwe9bsSeVKbeCHjR7P+2V0M=;
	b=cac/Jmy3aFbBWJD8rjMyUSUF6NcWFkq9SarzKshSKVHDzTSCntdPff7wWkZP6FNkr5GjpT
	eK7NlEJUvwOLAAtTp5rvxUbUw8VVy70UkcOU2wlWfeqsGEuteqEEKZut2gfp/r1KYk4UJF
	ktM49JphUTV1q6DbJ6dnhrVeRXn6fMw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VoPTODcg;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774451373; a=rsa-sha256;
	cv=none;
	b=UDRbwD+6TjxzeGNsojNeIkPxLH5Yi12ls4/FghH49ZOysP6qGbYYtySdK/x5oUmeMuI9mY
	hNJmuwQ06nhVSTY5a010Hw4rNr7+B70KmLCYj6nXWyHhhWM6VkvYKOom/14dwGi42qeY/l
	BBWTXlFvn0/PNpR4+JWpte+QyubytJQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 57C06600C4;
	Wed, 25 Mar 2026 15:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE18AC4CEF7;
	Wed, 25 Mar 2026 15:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774451372;
	bh=vk0ipjWHUhSNlIqD6a4UgVk0+BRVGEiJ5SvoUSaszPw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VoPTODcg56NIL0NjPLeYHnNo6sz5XPpvH/X9UWLOo9zV1CvL/R5m9MfmuxvpCpZt7
	 wKh01AcwFxd+zonrjg1JYyrTCXWJoyx8ESu5s5M1OlYMASSZlGl7YpK1gf5vUpfOyd
	 D6AnTeyq2iJO0bO5U2OpLiLoW63E8/D/QXdtvJdw=
Date: Wed, 25 Mar 2026 08:09:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress
 number
Message-Id: <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
In-Reply-To: <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
	<20260221093918.1456187-3-vernon2gm@gmail.com>
	<20260224035247.r6mxsfcpiev4wnce@master>
	<zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
	<1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
	<hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
	<8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
	<CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
	<22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F091EC0007
X-Stat-Signature: eku4gxj9em6sxf85pr5mr1gu45f34iui
X-Rspam-User: 
X-HE-Tag: 1774451372-442082
X-HE-Meta: U2FsdGVkX18k8HZjJCGHRyi45Wl5To8j8E04guQ2iZk2tYMfU2vRhNtiqkSxkg8z2R3cQikoOz0aicDeVj/hHLiJSzwGEjl/58DYPl2Uwuurma7DXyCjer7YvJDtaljPS8mJPmQXFJQdWGKeOyEJ0Jv/+OKvJYlVUrYP+jdxmkJMl7wJ3bWJtMSyObwJA6rmyhFcDgCeS74gOjw6YS8dS3n+EooXqSGJQacLXquK8E8nBO4zpX3cO/tFYuioiqbgREzuKxGnWxggsaXQagI9ehMiOm5dz8KFJyzheqLWrvyRVXeJPC38JxQTZXeYSbcpoprgPaRMzDvdHf6/EVEqSW9O9YEiJSHkzGHZcRmfh07SjtwFtIui9SzrV5c/0ofTW2oLtScCpAaA5nqBFkhqrbeONaBdc6bsKySoBh+lt0ClyZQNwyq/n1vE7FpAYYcVc3On92u0tkkDYfp/DkiuXC56euVrI5zL3HUvGNWRLgYnbnpqHl7Klwogeabzk5SufqaRB8DwKhwBXSCOr7a3kSF96eldiiqxIDCdY1w7ap3Dpm6nEs4bjN/h8IKHCBSsN9fZ8P5J+ZjWTC1PQlsQXWaHjYPIkjYi6MtMWZpTg9QhU7yEyARtCsb1KenMY+ZQ0W2grMNhz0ur5GIzB8tffkoSvLOAP0hSr4omVvARRH4FH0aUAhG9RMpNep1gtC8N4S9AEL1tiYJsfX2LVJ1owEol7ebbQ6UYx2c3UEocvPgL/XxoXtyo/FSGqUrcIeRNtbto/+gwGIQxeMV2WM8aOkph0Dcd8Ay40tclF8yVFv49lAS7WlZaY9D4uBuGbHc62pxZGxygo6sTThvyfAWOui1WSPTTuyy1o601OQU8u91Wp5W00ucR1sRqnJeHUZ0u89iraLXqjlPHuNweOfeGV69Mvypsams9iWDPOKI4cUnnho0raLpmVeSVcdORh6HDlGHQekFUx6r7KsUJ/ri
 EWMyhZ7D
 k3zw93+l/yDB/jR9FOhAFadAr0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 14:10:23 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> > No need to update the patch description.
> 
> I will take a look at this (sorry for delay) but general point - while
> fix-patches are convenient, they're incredibly anti-reviewer.
> 
> I hope at some point in the future we can move away from that so you can look at
> a series on list and know that what's shown there is the actual patch.

Oh.  I've never really received that message, at least not at all
clearly.

I've been hoping that the -fix patches are actually pro-reviewer, for
those reviewers who have looked at the previous version.  A full resend
of something you've already looked at is quite annoying!

I try to mitigate that by sending the
heres-what-you-changed-since-last-time replies.  It's a little more
work at this end, but that's not at all a problem.

I see a couple of options here

a) I can fold the -fix into the base patch then send out the
   resulting diff as a reply-to-all.

b) We can just deprecate the -fix things and ask people for full
   resends.

It depends on what people prefer.  How do we determine that?

