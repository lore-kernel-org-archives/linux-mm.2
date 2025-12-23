Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB37E6B274
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 11:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AA16B0005; Tue, 23 Dec 2025 06:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E8E6B0089; Tue, 23 Dec 2025 06:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67FD26B008A; Tue, 23 Dec 2025 06:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57BB26B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:43:50 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDAA21DFCC9
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:43:49 +0000 (UTC)
X-FDA: 84250551378.07.9BDCDD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 55E8640005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:43:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bp7+0Uj5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766490228; a=rsa-sha256;
	cv=none;
	b=Pf6a6k2GHoJ6ecweVH6Q3n89rNw89Zf4Bvak+aJQeaj/zymNnmKc0XYCSNeTiBsL5lAtEx
	sy95AyuVH3M2VgUN/nNwfzLu9mq0c9oMKhIUfhNISyskQfYCwMJlEQXBl2+ODFEpUkfx+i
	ISnoR5lYP8hPhPEmyNtVZelO7fKBs/Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bp7+0Uj5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766490228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZtWW4W+8FJ12YJUN/1bUcA87IwN8c1HAjU2JtJpGy7I=;
	b=uNI68MnRyACNh1QuwdS63NLynbdiprl/SMPE3EGxBolUe7U8ohs4MuklwEmz3JDNOgSX3U
	NuGegrOQ9Ag1ByTtAgq0xaYWxez0p4ud7nDgojq0iNZRyYQOIsOfMVBl+Bemm0+LNWUiN9
	pkqm89SjkDwdPxIumXkqzGz+K3NGZIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACDD8600CB;
	Tue, 23 Dec 2025 11:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37179C113D0;
	Tue, 23 Dec 2025 11:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766490227;
	bh=Y356nykrWSoOLSfh5YSTuQ7KEeAa3+p4YJplI7gtpt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bp7+0Uj5Z6VN2PwEXcmIQc2WbkxYG8kryhsefYIJmIYPnYY8o90w6UX2JAubtYhjj
	 fBSUj5KqEJpYw8kJ81qOZlCpQls5B1SHKmUG+cp9QRjlRtPS/GxilpnVO0oeJsFhh0
	 zpt35Rfs7wEpcjroz4hRRUAfPWdl4TmZ8biix0Eni2qLTjfyXRIbVKoacsc20ADOyt
	 KtOUj3Lc0LkCMZcWCBPQjQWIkBMyhkyl0Q2SI8TqIeWkTTBxIxFgeEXzoQqUMzJ0C7
	 lSF3JsFbuzMqS9nWP3rV8QXPHDJtLQFnf0UWcxlqVQ2wqbWDUNFSH78aHXUtTl1QZZ
	 KKfmU+sjJ/a9Q==
Date: Tue, 23 Dec 2025 06:43:45 -0500
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	x86@kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
Message-ID: <aUqAcf2405H0pRW1@laps>
References: <20251221104907.032abf56c67f3e50c9c94e31@linux-foundation.org>
 <20251223013045.4579-1-sj@kernel.org>
 <20251222183055.88c3cc1f0705c1dc29c7f011@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251222183055.88c3cc1f0705c1dc29c7f011@linux-foundation.org>
X-Rspamd-Queue-Id: 55E8640005
X-Stat-Signature: 3c7m46yij98kn36qkpz49w8yfbrzk6ff
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766490228-605383
X-HE-Meta: U2FsdGVkX1+X5l5MjzNx74LXlVjfLXMgfNDVbrOpRL+96YrpRV6gEau1/ESRTAcPLkPeMvmJBBr/DptVB27PvyJZuEgePE241TEG9Q0vt5cKDrlbVQuzXiOTtI1Q+GDBSokcLwYSqEV+jHSM3SkrYQ2Ie1LzyEVxGpaFmtBiiw2JBA6BhZm6EWHAEJVwcYFSokUXJzywFkelMEhO+wNzoi5aCopPG6Fepru03TnqGdzZA6Z1ebnAyWzGzW4wOUQB4Nrk4lH7zndMZOM9n72H/na+gygJXrgEFjaP1YQ/an7E//BNcj300Xgmc1jaJ2XDsdl8ZsYHliLHgu3R4AMUpSZZduuFrisuQidXyj34emOuRwkWoPdAMsiWsCsz8gMs2PI8D6L+oEeCzoFn4IwySbIdNJt946xHJ4HmzfuQjKhcdaDusdMiwdvqb+FSYnv3R8yHapZECkCxhaKwckDm7V36y4o8hctTebrI6/UUsNxiQr9GE071SbbX42idS88Ry6vZz4bSwrVI7DwDC6ndJtFDc+FWcYbnOHOcCsXP6/cF1p/6hkCwFJXvcEXK1nBNnxaXYvr41G0+2L3gAqPStUy/ov040rh4voWah1ZQn8+eS5pKm1LqlapT6fwKDr8k/JjA79MIWItpDbn27a5tsh5HZfalfyOLYvIsOKfwMmg/eW+FX+AKEXNQyS4OamObD1qq1El3cUxCiODKcNaNYlYaC0Sc+azheOvitsIWkSBeP20ZybqeHRZdAPoVZNTtBJkmWQxMlgjKLPiZl3LzKjzUHTw+/jmQrb8JEtr0UC+3aV/AvYAN5PXYgWHnXtPdmUHIDA03MzwzPCmcRzuAbvN9gnSt14pFtD3DSfdHu6SnYu5taIYbtmlfe+ygY9zA+Tk8MwXF3v7nY18rEswQ6hxomjHhCB/RnrmROb9WLXPQT0EWXrmouAqvaM1a9T/GtnQwzTdh+zJ86AGcglG
 Y/WHgjGz
 b2E0SRo9fEFwIBKYGjpHLZogVyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 06:30:55PM -0800, Andrew Morton wrote:
>On Mon, 22 Dec 2025 17:30:44 -0800 SeongJae Park <sj@kernel.org> wrote:
>
>> On Sun, 21 Dec 2025 10:49:07 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> > On Sun, 21 Dec 2025 10:22:44 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
>> >
>> > > >
>> > > > My main concern was -
>> > > > A fixes tag means it might get auto backported to stable kernels too,
>> > >
>> > > Not in the MM world -- IIRC. I think there is the agreement, that we
>> > > decide what should go into stable and what not.
>> > >
>> > > Andrew can correct me if my memory is wrong.
>> >
>> > Yes, -stable maintainers have been asked to only backport patches where
>> > the MM developers asked for that, with cc:stable.  There may be
>> > slipups, but as far as I know this is working.
>> >
>> > I don't actually know how they determine which patches need this
>> > special treatment.  Pathname?  Signed-off-by:akpm?
>>
>> I guess it is pathname, based on ignore_list file [1] of stable-queue repo.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list#n16
>>
>
>Oh, that's a bit sad.
>
>- other trees sometimes mess with mm/ and they probably aren't aware
>  that they need an explicit cc:stable.
>
>- misses drivers/block/zram and probably various other things that
>  the MM team maintains.
>
>Oh well, I guess simple mm/* coverage is good enough.  But I do worry a
>little that useful fixes coming into mm/ via other trees without
>cc:stable will get missed.

How should we improve the filter? mm/ AND signed off by akpm?

-- 
Thanks,
Sasha

