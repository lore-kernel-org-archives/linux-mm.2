Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F340DCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 15:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41CB48005B; Mon, 27 Oct 2025 11:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F48A8000A; Mon, 27 Oct 2025 11:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331BD8005B; Mon, 27 Oct 2025 11:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 229238000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:00:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3DDE160186
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:00:45 +0000 (UTC)
X-FDA: 84044206050.04.5A5E3D5
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id C57C414001E
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:00:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0OA03ObG;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761577244; a=rsa-sha256;
	cv=none;
	b=it7r7S6kbFM0lgWHyay5qOA+3dQIR+W7rYb6a8az9JI0u4T8Suzi0RKCwpuGIR+CdwVJ2Y
	WSRl59JYgGLK+QagsGE04zt5QIGcw7RVRiZ6KylHzboZPRmJ63pLOtrRcR7htA9ZmigY9L
	dbpXyJ3cpnjIoraN8P0UZlmJZL/b7Yo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=0OA03ObG;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761577244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CN7U7He+kRo4ITOtEJtKAVIRmgMIfl0h1hsDAJ7PytY=;
	b=M+p9vnIBDvynAvYuYo5UWxHa7UAIEb+54ipjHOEV6wzDELT+Cnib5+Tn33F+be8zA4h2B7
	OFT6cRIv0dHL+J4YxasWH7T0hDqo4EcVc3mFtXmQolVpcNsUAmeX8NZQdIayWNdvr7VzpW
	HDkFV1PnMNT5G2wmfOtgrlYETuQ/baE=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 313B39AFCD;
	Mon, 27 Oct 2025 15:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1761577242;
	bh=CN7U7He+kRo4ITOtEJtKAVIRmgMIfl0h1hsDAJ7PytY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0OA03ObG2z0vmHiOHSt7uFjNLbluACjBfJof0coJZCaG0d1E/N7GCIB4ruTan95J3
	 z8XmIo1uk+5nMlNK2Mnc58vapMPFO8tqjJi847snLlw0gzXM8iCI0RoClPgjE2q31x
	 GOtbNu37pGeJMnukJRCaWHflXNmQ3+9+wUF+VvBA=
Date: Mon, 27 Oct 2025 15:00:38 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aP-JFqlCE6ee5_Ln@shell.ilvokhin.com>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
 <5dt6roxyx3h4zojls7cvr4nyjtahi33ti2sir2ijr3w4wjliyz@fl32rra6phll>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dt6roxyx3h4zojls7cvr4nyjtahi33ti2sir2ijr3w4wjliyz@fl32rra6phll>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C57C414001E
X-Stat-Signature: gj7scbjyzd617abpkfmj4uq89kx4dq5r
X-HE-Tag: 1761577243-708478
X-HE-Meta: U2FsdGVkX1+ZtFhkiNdzZ2vWEIJ2loCvI/5qwTGs+o88fi8ZJMRa3XxIFnBgUcHix2OjTVhe5EP7TM+T994tsjLd4ganvTiQxLkTuzQnNZWOpkdz9aXg8kBtX2IlxxmgB0axhU5eu2NmcSbFToPYfTAHRRnZw8qXLUzocxO6Ily/ITrKdyglKLuJ3CDW6ybyeeXZ8zcp9vCGXQB6/eh5oLqXaV3LSPbdVEtiiJ/stSr+1ervQBfkp5609ipPzBGVf0LOeK4kg71pPJKJZnXqkXIn8DLj2lyG9bArmJMEdx+AclwMk26GnN9cdNh1QMmwO7KFr59u39WrbXNSRfrGw5cf7Jtbw5UAUbIlufnk+ZcGrKvQHZfEVubAB30S7OA6V3f5hi26DcHZLQjaCKlI/yFU7w12MbxdknUaauJQWVvwNZIhCIQ78w7oVQK9SJMdvmbAbCiTj84VhuhlbHq9jjH0GRp1Twwa56RogSaFA/CUnSpbBXiTw0zm1T3UeoInfJvOkwNVCW7yqFrizuBW/1hTWsyzioOwvtDeRc/2+RPNZkan4Ba9k6Fm8ZKGFfRd2LalPyXMkJk/RgE2jcZf5GXTLKV1mx2yhk5+F7/V1DqWD2BwD3dEAImKGiO8z1rBYcBVtlfogC5ZKeJHG4xAMb36X/J5jYTqN49+dosZD3BQtTbVDGlEiMjRhMZSQvGpQnRz1/SkRFozcX7pifiwPk2AG9py78zfhdcxeFlaVAw+YUsTyGruxR8uy1q0qbhE6u8D8ADBCHLl04fbFLEuCy8aJBwMb11T5zgb+bJyeyifOVzV4zgseN4AlFewjmss96KahzghOeixKltZkDROwiLUe8tpmHLYDV/kRG1xYCBvSjqUe4I9lgN7Bmuk9u3CInphHwNilSktR08BkV/RCZd3IJQlCzo+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:27:39PM +0100, Pedro Falcato wrote:
> On Thu, Oct 23, 2025 at 06:12:02PM +0000, Dmitry Ilvokhin wrote:
> > Allow to override defaults for shemem and tmpfs at config time. This is
> > consistent with how transparent hugepages can be configured.
> > 
> > Same results can be achieved with the existing
> > 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> > in the kernel command line, but it is more convenient to define basic
> > settings at config time instead of changing kernel command line later.
> 
> Why do you need these options instead of using CONFIG_CMDLINE?
> They should pull off exactly what you want, but without changing the kernel?

Thanks for the suggestion, Pedro. I think CONFIG_CMDLINE could work, but
for this purpose it doesn't seem ideal. Relying on CONFIG_CMDLINE isn't
a very scalable solution, since over time it tends to accumulate into a
long, unstructured string that isn't validated at build time. It also
mixes configuration layers: build-time policy and boot-time setup, which
makes the resulting behavior a bit harder to maintain in the long run.
So this approach is mainly about improving long-term maintainability and
operational clarity. I hope that makes sense.

> 
> -- 
> Pedro

