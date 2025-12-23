Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F932E6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8546B0088; Mon, 22 Dec 2025 20:30:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95466B0089; Mon, 22 Dec 2025 20:30:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77146B008A; Mon, 22 Dec 2025 20:30:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B79A06B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:30:55 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63DBF16041B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:30:55 +0000 (UTC)
X-FDA: 84249006870.14.91DE567
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E512940002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:30:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dO5p1eAe;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766453454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKmOTCnahQz8ZADEqQpJwAvY9dVZYhmtgKDELnz+lCs=;
	b=1uH2yo9NhzPp7Pge4UjOU+WNh+fNJf/lbnzxg9hUD75uYYhyt0ruQE2m5XiaXgzTC2Ub1p
	n3FNyIf2C/mqSebhYq7otmUVIjNgFrS0mbGik0Tqg1l4zvr4MrsSd4rcG3ZhbzPv8oPWkj
	tm7gCamnbWmfuDfQnr8ThTdSeWoYyP0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dO5p1eAe;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766453454; a=rsa-sha256;
	cv=none;
	b=mTzBqxkdMSbVmVnif53h5nAsiMBtM7dvJ5AfryNrLqGVQeLWKq4qt+Qry0/HyxmjfbM3cB
	HTZTo5QRKHE8z2pB6zGv9SmMHPvsf1tXZhgec/idS12GAI5X75W0IV4uNQury9sgExZlJf
	WcooTYBLJTuLqx6tgrkzhF1NCksm75Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E74CF40DD1;
	Tue, 23 Dec 2025 01:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613A2C4CEF1;
	Tue, 23 Dec 2025 01:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766453452;
	bh=j7q2987NriSlS+UGsGEBmtZisdMET3w6wHahvWlFCXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dO5p1eAeCiTmrLjfR2upqrJjMfmN+fqYqX5pLP/UpyRrXF2AUHgEYFwEMyD3r1obi
	 pEDjXWgKmiqndnrwphcQ1xmocdXiVenBgaQpH8OhamNZ4Iq/5MM1cZj8puJ14LI3RY
	 LIv+2+3bD4SBxu39wqhdoZkP8nz/qNyqFeQe02gX9CRGPAcZc59Hrq2vgSPjMPIkYw
	 UaOU0CNfN/e1qXIcM9EXSCPrhHOvAC89afJ/neG7VaxyRjcLSVrHRanYLjzuXOsJWy
	 l8K/ZNSDlGs6d4U/rrmNlDoBWYqa9kWYB4qLSlkOXTaf4oEIb8M8vGOL0VKP76nvWM
	 AiNxz4lmAEbWw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
Date: Mon, 22 Dec 2025 17:30:44 -0800
Message-ID: <20251223013045.4579-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251221104907.032abf56c67f3e50c9c94e31@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E512940002
X-Stat-Signature: r5bpeurqiujzzybpouc8c7tiewsgas64
X-Rspam-User: 
X-HE-Tag: 1766453453-893981
X-HE-Meta: U2FsdGVkX1/iAKaZEEO6x9HJfdQUdA6nJGNb9H2SIZaUXAGlQYw4fxs6S7XXF48KxSh2zp/FynFtMUzliHWFToxirSoWjudwUuw3NC89RPVsSLsYZDIUV5w4Mq2+CqFyYMl2EhyZl4dtVITCx9Cui2oBMdKjaZ9UfNgfEBVtOVXg+p4cQ05mQu4oUGW+ynWtK9f/cw5MazNGjaOSu4akAQMIoY0x79Gav8CC1+x1Syhkvhi+6CiUP9hZumtUOaDu9TzYk4Fcc69On4MbH06KjB3NR8VG4GGdHBSwQIf2KaAqjcI6BA7twvfY5cSneaH+xgHkZhF7lCqt2EB2ttcM6RAAeXegRWtGvFZAGBcx4exTpc6ONi9hI5MY2sLKl7Du8nFjO+D8rSVl04i044hq3D8EvpK6eyWGi8/9gkCM6jw2D9RW98bEbJ+E7SBt5rdI2FdJgG+tWKWEjWJAsWv2bC7GyKovAUdQK35ViVaN3KJqejVdRuT42FFZamZnSS5Ee02Nf+UB2k2vvDVzz7GXnuHi4EBEIutQnw6EO1/DyPtnlSrKfOcHkYC8V1HMKfXWoRnZZWOSMPJc+S+ti2li6D0qvvvlXs/LLbB/S2AOEfuOjSmNNp0mP2CxhaEy3tAO7l3iYQpHHmOBGc8iBaN8kNTy3EC4VzGGZ6ao9pPoG3Ylt/5pBgOXYgTmhyJGaWMzD46cNTeV+IZ28shGaQC0s0+R7wsDwe6+r9SDZDF8kC3bkagj8bEt8kK3sL2wbDjd8QDce46/iOPFm/DHFcXJUATfI7tVQfsTRLYLZNXzsc2758f2Nmsk5pRlvWdwBR+ZGJTB8TKbdlPGJLh0Nx+WzDO/qnd1YbM5blnAOpBJfsli+SLUzRSieZj8K7KCprD6cq369FN0EO6h0TjOIA0RbgMXSPjBBLK7UUoBCOrtbYbS+JfWrboK7Dh3EEjaBhTmUeG1b25p9F+Uo1xKyeO
 1Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 10:49:07 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 21 Dec 2025 10:22:44 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> 
> > > 
> > > My main concern was -
> > > A fixes tag means it might get auto backported to stable kernels too,
> > 
> > Not in the MM world -- IIRC. I think there is the agreement, that we 
> > decide what should go into stable and what not.
> > 
> > Andrew can correct me if my memory is wrong.
> 
> Yes, -stable maintainers have been asked to only backport patches where
> the MM developers asked for that, with cc:stable.  There may be
> slipups, but as far as I know this is working.
> 
> I don't actually know how they determine which patches need this
> special treatment.  Pathname?  Signed-off-by:akpm?

I guess it is pathname, based on ignore_list file [1] of stable-queue repo.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list#n16


Thanks,
SJ

[...]

