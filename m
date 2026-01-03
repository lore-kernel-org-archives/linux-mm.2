Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CC7FFC6160
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 17:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6B16B008A; Sat,  3 Jan 2026 12:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4286B008C; Sat,  3 Jan 2026 12:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8426B0092; Sat,  3 Jan 2026 12:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C83956B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 12:58:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81AD31A0558
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 17:58:49 +0000 (UTC)
X-FDA: 84291413178.27.5C4E36C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CD7F020003
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 17:58:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bEETuQ7W;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767463127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcCGvArRjYPC61wMhERRJZjQsEEdIuEVvMzrcmXw0EI=;
	b=7LiyYPBahRnB8p0sUvmVAyEBeVP0YO8algipPwgXGH1r3aj8lbpavsTl4P0louoCRljBam
	xBiiOO6K6Qm+5nnEzE6lq2t15KdrgxH3xiAvh53Zzyeq+0cr91KovDYq5WnDU6dspMUkRD
	f13vwE3XIg81FXh8m/w1XTaa3d0vDbU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bEETuQ7W;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767463127; a=rsa-sha256;
	cv=none;
	b=hk8hjrSt0EQrdcHaC4UIaM4UL0A8qq02jbq91oQtdMTufLn/wY0m3DBor8QaeCgbAscjJu
	M7MgzX37Cls+EDDn6niir3SjCgjsoVEKYoMz0+hQXcc6JkMol4nahucFdTdbXJ8njacSHF
	kwwz/XW90kReotpPoMbNUc593xjqiS8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0F8743C76;
	Sat,  3 Jan 2026 17:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21176C113D0;
	Sat,  3 Jan 2026 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767463126;
	bh=QuvPFMLdxqo8N9+t2kswBoVuQB3eyvBqkp9dBt09pK8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bEETuQ7WcflAt5fJMYhPkfOZvZ/Ce8ULWcUYmfSEZ19XTpdC3NsncWN7vIk1758Fd
	 YJHdc15C4KJGM/D2iVfMnj/xZpqrYNbV5HicFMD6la8+SqvWiCVy4w/KzImlU3Y2SV
	 e8E91DrEgV6Iyk4oLWhBORv+8oybe9r6ivFFL0J8=
Date: Sat, 3 Jan 2026 09:58:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, David Hildenbrand <david@redhat.com>,
 amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-Id: <20260103095845.152449636aaa60afb11f6c05@linux-foundation.org>
In-Reply-To: <b6a2a040-288e-4114-b85b-51740c608bb2@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
	<0826eb09-216c-4d00-b4eb-ed1a2ba204bf@lucifer.local>
	<b6a2a040-288e-4114-b85b-51740c608bb2@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD7F020003
X-Stat-Signature: q3fnab6sco6ubjkx4c33t4i1dt6tbpym
X-Rspam-User: 
X-HE-Tag: 1767463127-155014
X-HE-Meta: U2FsdGVkX19U/mkpOK98ZUUdJctwn78uiFht6HhYnVktLjhjAWdxd054k0KvEq2ek2p5BLoGM0lMQHQI2rQ1YEtCkrImQgN+pyELgh7U4oQouUyIAt2LVyf8sPWdF2UAkW6op4PfnqXM1721avx1/QgXzzUq8yJ4+EtjAn9Ko63gCr0E6A70yWLFSpZwNNj28/3yIxxlZEc+fTUSi93rdsHgAvdtJh1CqOWMw8DZ6HWrTkEjahQKqM7H3q4f8pWvCZoB26FM/1DD2ZWddhp6nk0cWkdD5tjcS77jsYxxd2DUlcrZ2vCnx2McXk8dU18HqCTRX01Soan+nAa8RBJgI7y2dLSjUjIv769RyjQk4lOS817Bc6VYUDQlBfkmLeS0/Zg+XjzDBq2xfAADrNTL2QG8ObykzKFG4V/f9SVd2CWDtwWaUHkqZZpqqr9LCg1VUWqL50oxBYeOzZk8RLiadIa9TAjqPfI5FoIDNt6SlLuG1wnkCS0vbwOSz7hITpsJLL36oxLbMZskmZ1jaEdBAu3CweyEQ2Qupji4Gi14oK8nIcPY397eRQBL+4UD8IKqy/21+mwkUcwb5i2W4jKgjCaYWiPTOs+/MOaEG3EptXrmecvKrXLm9l3mefOS1f8ySG+2h7fUH4LRIoStfyrJnUgoTJ/HzRMipquo/xnu8Zk7tj+fYoozaeZiSg514MbEI/0/f7DRVMYTrwJcwq30T09cDt1GsCSy49U92L5Fqe354GwocFS9lJuV51ZV9DugsdzAsvqw42TbbheD8+4hBbyOg1CaR4pCROi5lKsGVY/J+eQLLaaZQ64sWmRoCzv82ak7BNYeYHK3Y0pH767AMBxff85hG27nSsEu4zUMURHMqWIdL2vop6qgGd38LNk020Qp/Jg6lbm21D9DqTimS/DUP4YEYmHkyoOnjtFYg8h/pgILKTpE9uZ7p70jz/Yrt+8+/pGy2dpsx1SMqQ6
 iwZd1XW+
 KRgjpqFEhrexCJNwzlXGL3HZwLxlYFXCPzt2PjQDIfY3Tn/ZGKuedRPOTe7qxR1mzYE40q5brMzhJS03YDdiv9iox/4mFN2UR8DuWOPRmj51yKux9SGx2J7W3NYCcgPX3s3+VKF7FRix+XhbT+imIdsDU/ryoAgXYTRxxsXbZrFomarGhYMPcLv88OVN+ZWQac1dTNo81p1abBTqsCBec2ZbjcwJ5LM2DEnkhL3rx+maUwuULHoBhku79FaGYRhZxG0AlqAKNHBkDpQlYRit8/9WrpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2 Jan 2026 19:08:37 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Fri, Jan 02, 2026 at 07:02:40PM +0000, Lorenzo Stoakes wrote:
> > +cc literally everyone you should have cc'd in mm :/
> >
> > Hi Mikulas,
> >
> > You really need to check MAINTAINERS, you've sent a patch that changes mm/vma.c
> > without cc'ing a single maintainer or reviewer of that file. I just happened to
> > notice this by chance, even lei seemed to mess up the file query for some
> > reason.
> 
> Ah yes, it's because this patch breaks the VMA userland tests.
> 
> You need to modify tools/testing/vma/vma_internal.h and rename signal_pending() to
> fatal_signal_pending().
> 
> You can check it by going to the tools/testing/vma directory running make and
> executing the vma executable.
> 
> This one I don't blame you for, there were meant to be CI tests for this in mm
> but for some reason that's just not been done.
> 
> But this needs fixing. If this is being backported to all human history you
> probably don't want to do that, but that leaves commits with broken tests in so
> an alternative would be to add a patch that gets added before this one that adds
> fatal_signal_pending() to vma_internal.h.
> 
> But not sure how feasible that is? Andrew?

Not understanding why it requires a separate patch.  Can we modify this
patch so it makes the necessary alterations to selftests?

