Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C36AD3B99E
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 21:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8815E6B0005; Tue,  9 Dec 2025 16:45:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8316D6B0007; Tue,  9 Dec 2025 16:45:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747C96B0008; Tue,  9 Dec 2025 16:45:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 638326B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 16:45:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E246E5845A
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:45:27 +0000 (UTC)
X-FDA: 84201264294.11.B40A5E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 422B74000F
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:45:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3BhzQa3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765316726; a=rsa-sha256;
	cv=none;
	b=Z3CNgZE9wIiTAJB5vSrEdSUH0fzLT4S+NzdSmYOfp2PbbRqK2PYdITRfzAaVrlmsIAW0U0
	UyqeUx1AXTYVuMIuCY8fjbCCX5ocHNjcpJ0R5PhF/yuY8IWhX6+U6La80S0UXkDG0c2H/t
	jYCa5Kop1mfIFwtB0KZfWMeWNV9IbZY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3BhzQa3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765316726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dPdZxILlGnU3zmV7vogddyBVAYcY66KFQpmsqhCKoY=;
	b=vAD1y+3NjryG6259Mgl4uR2rVYWZVP/PBVn4J2s42KsERV4Vm8tHQOmwprIKX2Wno9cNVr
	MYT/vZfBUxTPsf/0tyjaQOnl3haydGeehmGxuCxsad7rxXbd//n+t81BrIhx3Tgm5l4ZAp
	JClSJGBh4eP6Dg6+mft0sBCof2PVpEk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2056343E77;
	Tue,  9 Dec 2025 21:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F07C4CEF5;
	Tue,  9 Dec 2025 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765316725;
	bh=LrNSQsAm0Ll4Mgbo9bwCi4S7DLkJhEknRL4HpF/7Abc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3BhzQa3MebFQX+rVVMpmbWhnLYk+G+FkbiDiSZxuEHWixq6RDAGV0xSYDEPSy07b
	 EqgYu5FZLQQzPUtEEnbfaWxhVDm/zid2z1RBHRbJu6drYFrqeDhgDT1696fAeUDQqM
	 bpqPq/eO1PUTun+NUz0KrwjVkDCV+iYdoDuWn3wzPILKsLK7CX/wvbPC+Essaocyov
	 RgacqpGAc98eGPFQ1f3XFsO+WJN5Mcn/aQwYZm1A/2BrmJQGvyIfQOzFlkMln+5DxR
	 hnmBonTgS9CABTsmeErftpyVX6v47/iSuRxOIJLqFa2xMlQz8swB9guPxCIamf4c/j
	 mgI8OXOYwAB7w==
From: SeongJae Park <sj@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/damon/vaddr: fix missing pte_unmap_unlock in damos_va_migrate_pmd_entry()
Date: Tue,  9 Dec 2025 13:45:20 -0800
Message-ID: <20251209214521.44487-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251209151034.77221-1-akinobu.mita@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 422B74000F
X-Rspamd-Server: rspam10
X-Stat-Signature: jfj9y5pdkhf7711c7p5sstsuthwhug7n
X-HE-Tag: 1765316726-327579
X-HE-Meta: U2FsdGVkX1/ZN4Ih2Qp42+0//+PzWokHjlu7HfWrFwnhAlUQSf0FeCqj+4MQ0u/o+/CK5MaD/SobX/7LuMnAc36650pyqeFSOaQ87IDQeOBgywXt4b0mfAm3vAOCxmgPAeVMHyBPM60sWKEUmsbX7Jg8B0bJDSy0TBYKeqaLSHolmtl2xpDC3v+2kdoqBzyY9Hiibq3yV6MVkqkWd19VWbV46TuqnJ0VHvYZ/nKA1TMO7JDP76BvNcuUTZIN/FLF2/fuup7MYTuG0LJu+7TSggZDvewaAYoISO7fD+er6n+Irk/RNPxqGlSXapn6IaSipG0ydsPn3TIG0NzXOUsi9lfhu/WREI5Pq29uvN/Z25Bl5ShduHwzueH1JyKJbXmIY3SKtNIdw3/RGzkubwPSe4k535WPUUrZgodbINyuZV24SD4dFx1vb9S5aPn+XZ6cgSmwIxgl4VOs6sD6S4OPxAg20qtsibiEtJSjhU482G9OhEP5/s/XesWlRDja25/xVKO3dexxF8kYZaOCRQHaZsdNjf0P2Yme33117/t39XgJa6LOV4cr6uTdyrI2dLu79PvN4UIUzQFHkK+d5M84nA4WUqw8pS/Z2XSM0r+MuvTJw7a09ueg7Ag0wYn88zGJMspmmv1TAUfatOWWgS76tNN3kEx2sgS/0A4i4j1M107Vj5ARYQZ7vGkcRvjN2Y0fNXck2sJdAe8yBkhtpGm6sIGJL2yk4tTJHgn/eZ84uvXM3gtp3yCFUB9GaTyLGfr0qEd2g54BM7YGJ5K75x4b5IRddyXCYp5qUXC9l/QyfciGhbKBseJpzuGtR5CrFMOFWmcjE2AefjKH97ub4MX3Fzvc7M7clWsHu+3kH1zHhwTIapNSgH2jS4hhnyLal3J9nzqNLa6l0sRW0FUzSSwyLyJZw3/fluIIIbUu1Z0+OjCO/sivtN70SM1vBpEDE9KLgdaxBeuw4junbrZuv64
 QUnEpeY2
 o64kW8nW2pRHpwxiUTZRRX/4qggHzjf2T6u+c7NSiK+CsuVcL9hhNS6nlxjMRKdlznRIOZdXy04lxC2nCLZSEBnP8Vv2j8+V82N5sZmpr4OWvGxjvHGoMAnvnCRYNaHAxrBw8lukBAuOPu07jEvD6DbTyO98THlFFyW47DX2zi4uSgBdVpER7ZRTN+vsI2pjvtcn9JbufNWuqaWPI9ATB1CbinuEYgTpogCY4QT50L7nZK3Qfu4Uw5ue9FsW0zFbJAtvUIsr7CSg9bCohqV1uHpkS3MMmg3z+UvwjvcgmAG43yhpVIzdFov30v/LHhbjV6uF/2z4Lz22JC1OxtKl/gqeayMtJLRQZAHZMpQjSs9LccSxe9unZGXrhtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Dec 2025 00:10:34 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> If the PTE page table lock is acquired by pte_offset_map_lock(), the lock
> must be released via pte_unmap_unlock().
> 
> However, in damos_va_migrate_pmd_entry(), if damos_va_filter_out() returns
> true, it immediately returns without releasing the lock.
> 
> This fixes the issue by not stopping page table traversal when
> damos_va_filter_out() returns true and ensuring that the lock is released.

Thank you for finding and fixing this!

> 
> Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

