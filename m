Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB23E6FE23
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 16:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EFE56B0005; Tue, 23 Dec 2025 11:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D5B6B0089; Tue, 23 Dec 2025 11:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9D66B008A; Tue, 23 Dec 2025 11:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4496B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:54:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAAA8C101B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:54:38 +0000 (UTC)
X-FDA: 84251334636.11.84510B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B2D920004
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:54:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y2uhOtTy;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766508877; a=rsa-sha256;
	cv=none;
	b=KYrrkLtnRw7t/KujkR9bQfKpE1FoMHgZswbqgVve/ztE5XVS5MoOpBH7RQH15Vo50txM3F
	A7xIJfiMoyoc/HahFU5hiW26j/kxPuAq2y9DDTfo257hi38UWsl4G5huDgIFy9Xdoxtp/x
	B0QjGd7kx09pljFPV4x4c8ls+HSQ74U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y2uhOtTy;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766508877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vonf8LqeLJwp9G0Ckr7Of+LnsMCBeDul1vYZDPZ2LVQ=;
	b=D8hnik70jJh+RdJgxz7aU2gPlNWyIbAkhDDgluvclFdMbP6BJW56C+iRdQHwbqVe0OE8R5
	t3NCUxE18wdTfFfmTE/NZDFIGGjuRmOVD0EEQ4WZRwGSmJFArNG1/t3glGJxhlnT3+ojYH
	Jsw5fXg8rs/CQzGFmTLckkEhMZrC/kU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D345840A3D;
	Tue, 23 Dec 2025 16:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1558EC113D0;
	Tue, 23 Dec 2025 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766508875;
	bh=YSvTCQaekcYuL9cT3nyDik7utEEmbDcrz5nvozNxXXU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=y2uhOtTyCjTw1tPpgTeL42HMR7NDR8YOrZMmVeoReXhmp5EKVThfwCgm9ZMq2H10F
	 oIzbBqYLLx4dJjMprtUcezIIPaEprCv7+Ivvq8DySDY/SkRr8lJUxxnEjv0nTy3DK7
	 vdoFrPcKrSwzR1BtpDgv8TYXz/1pAkkyi1dpscy0=
Date: Tue, 23 Dec 2025 08:54:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, "David Hildenbrand (Red Hat)"
 <david@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Sourabh
 Jain <sourabhjain@linux.ibm.com>, Borislav Petkov <bp@alien8.de>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Heiko Carstens
 <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Thomas
 Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
Message-Id: <20251223085434.a6d6ae08c3aedf420908f404@linux-foundation.org>
In-Reply-To: <aUqAcf2405H0pRW1@laps>
References: <20251221104907.032abf56c67f3e50c9c94e31@linux-foundation.org>
	<20251223013045.4579-1-sj@kernel.org>
	<20251222183055.88c3cc1f0705c1dc29c7f011@linux-foundation.org>
	<aUqAcf2405H0pRW1@laps>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0B2D920004
X-Stat-Signature: uoiks5fb735c49q484bqd15tfa3t9giq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766508876-876801
X-HE-Meta: U2FsdGVkX181LsVTA9Tx79mxeCTv0NiZMCMeb/dQFQUWeMj668rIKgKv7YBhgz8/i3Q5jkariv4Q4cWMLAPJT2iYfLWX+mLMA8NNbe2otBO47FGSdy7qH7eGzaGcujEIRl8Bf6NE6Hq0/+iBHiLofhoAB677hKfLvkHwCYnppL8nfLSZNCGwkcm9n6oeaYVZ6HonrOF7YURUXEGnvk3tceJ5k5Y78FUWdHXWIZSJIdW2aD7ulogpHK3XN6JEaxvyzL1PtpCnuxOWJbhCijTmgMKniIc3Ro5BhmPL3gvt2qgyTRNpbNoLExJ9sAhMU1vyO/f2Q/lWXmjhH3qb74O5Sd/yzUtjgM1spNZhyW+xYlaWmseJ5FrsghhxUJ9DiqLajLwgMHx9TFvcC7ZIlXvpBRknbLqJU7Wjmy6m0dwR27tFW5ZKy4+id/wBCkpBIDUp+wqLeIEpgpAe8TV6l/6P1auLxGPWgbwWTj93Be1hYGwBBGYWyu87ls54drZH1LVOLvT7C7ThhZ6UkFOIojQ96jSk8uTJV9qsUBzOuRBGveWSZDzzos2Ni5mCMcQ8ocZ7zD/+hMM3u6lSxi1VmRhQ5P8Sx/nHcEeRbhHQe1AnmI30FGi3qnPwyg3oTM68Ct/oPk3qHOTB9aBAYY9LtB7sUxQEYj1Q4fzJ1xn77CwckFkKD5K50oK7sAIuWqw3ZAbk4oYw+U+yA4FVnheK1hHTrVKF8ARwFGDi1rBYzJ7llNHcWoqf6ecGAx4z1nNTaF2JADonavrf0869De6QJ5ilJBhTOEOKhCMQlowHUIRwjTcUVO6VFLpIEw+M8FLboaDkj7fZx1bQVtvh83C8Po5juw5DQxaX5mr8VYJ+5xacf3Kebpo9MAsOGNebngmFd+cPQWjIDJb7l3E9jBmzMdn9aUEWTjlv3itY6PDjNnmMLAyMTnz612UJtV2mNnV2aG3oQAJHMaBeEzN30TcAwOh
 Y7g0ygmX
 leHaexMNn9XUftJ2B7tSMsQhFP7pm39Uzo9FubSa2n3EoEHLS+1Q003adXzpVqw25BffGHMXoCneGHSP49O2kRgSDgthTF1dwDqMvXebXQmp1rg9dmG3IOPMjbqIDYO6ZyBeDAPJ8tZp1FlQIEaq0yqXShYcf5LQwDhDPEIelC+WvMgp2YYyQ441AiXYeTFIlav6rNvuZWrs4J3vUDK7jPidu2eRw1d5V3xjm7bKAPLQ0Iwdp5e9IjSfodSrNPf9p8CxP+EytpwFUUCy9dy8Bl2QZuVQmd/dQ1Zmw5O3xliHsiwBEmDfG8wPMnph3K7bTd0auveBTrHIy/QXayehJWCKcCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Dec 2025 06:43:45 -0500 Sasha Levin <sashal@kernel.org> wrote:

> >> > Yes, -stable maintainers have been asked to only backport patches where
> >> > the MM developers asked for that, with cc:stable.  There may be
> >> > slipups, but as far as I know this is working.
> >> >
> >> > I don't actually know how they determine which patches need this
> >> > special treatment.  Pathname?  Signed-off-by:akpm?
> >>
> >> I guess it is pathname, based on ignore_list file [1] of stable-queue repo.
> >>
> >> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list#n16
> >>
> >
> >Oh, that's a bit sad.
> >
> >- other trees sometimes mess with mm/ and they probably aren't aware
> >  that they need an explicit cc:stable.
> >
> >- misses drivers/block/zram and probably various other things that
> >  the MM team maintains.
> >
> >Oh well, I guess simple mm/* coverage is good enough.  But I do worry a
> >little that useful fixes coming into mm/ via other trees without
> >cc:stable will get missed.
> 
> How should we improve the filter? mm/ AND signed off by akpm?

I think just signed-off-by:akpm please.  That way, mm fixes which come
in via other trees without cc:stable get backported.

Obviously we'd prefer that such patches get appropriate consideration
by the MM developers but sometimes other-tree people aren't that
cooperative.  In this case it's better to backport the thing rather
than missing a fix?

