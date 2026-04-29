Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47C3FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3CB6B00A2; Wed, 29 Apr 2026 10:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AB9E6B00A5; Wed, 29 Apr 2026 10:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8CD6B00A6; Wed, 29 Apr 2026 10:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 118D26B00A2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:43:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 642B1A02EE
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:43:38 +0000 (UTC)
X-FDA: 84711862116.22.B801DCA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 992F81C0010
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:43:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AgsKn4Dx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZI25D0gvRFrBzdqm7tzw74sBczNJ9OIvKtUOfI4xRU=;
	b=RANc96InDU1DnGqEAkvnfgLNwMRf8dkcUc3umyL/8EP62gwTZ2vmz5B7I9bjOjgtgO6Auv
	Yzd6zACMQ55Nbabvg5Jm+PEV3hioKA5p2PZzYmtMXOS87/pdBcYjJRFWOClmdBqjI13DDB
	My/+mYTw14tEIp3DrRsOHfT8FdfVUEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473816; a=rsa-sha256;
	cv=none;
	b=gxKQ5BUvK55DBXvT/oJWGxQzABx7mycz5FmgyeNfSOXviKk6RmpdIA/e1jo2tqnonZqWJH
	jPPa5crbJSwcX2PNAeDoAUviy9IIq8hIGRTPycxxcqFwVoTau/d13ujC21rZxqefZgLrNF
	YZzN5eifd1S7N48UKctDP4+AEgHM45c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AgsKn4Dx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 261911596;
	Wed, 29 Apr 2026 07:43:30 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7AB373F62B;
	Wed, 29 Apr 2026 07:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777473815; bh=0QB+Qvxjjp0fPU4pPP754f+dTc32bLiJD+Cyf8FT9Y8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AgsKn4Dxtc+zw54Fg3JARa6pKd6EWx9WJ4N4tIieLoiO0Yh9LcDjFwHvK/lNO6zbk
	 1NbhPkF0DRY2QP4bp1+HDQmSK21srsJJdMhaaHcvYnXNPCQ2C+uYwSBue7h1A8ZO1c
	 HR4bYnQBmkZ5GexDoMfV0gabeltW9XYjiNMbL2/g=
Date: Wed, 29 Apr 2026 15:43:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com,
	kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org, arnd@arndb.de,
	Muhammad Usama Anjum <usama.anjum@arm.com>, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, tglx@kernel.org,
	mathieu.desnoyers@efficios.com, linux-arch@vger.kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v4 2/3] kasan: skip HW tagging for all kernel thread
 stacks
Message-ID: <afIY9zevao9S3zKy@arm.com>
References: <20260429102704.680174-1-dev.jain@arm.com>
 <20260429102704.680174-3-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429102704.680174-3-dev.jain@arm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 992F81C0010
X-Stat-Signature: hb3aanep61gsmecchd77zbc5jcdz1gdc
X-Rspam-User: 
X-HE-Tag: 1777473816-53800
X-HE-Meta: U2FsdGVkX18BWzAtvj4v6eOvZzGt43NaIFr8T5WjLOuvQylSH9zIAccuT58kJYPd30SAswF7zvRN1CQC0xaSHzrhj7T+7vXN7RuHz8sMpPVhIqXCbQVVCrydlPTY6HsukuMugh53C147GjcDjywicf4PiqtnJusBoPdoQR1ew3/Ov3d1OzhOI0EwImTnmdrZLVzz0tuv6fzrlWfSL61Z1QWqaj8tUysOmsB+pO4bVdC6bwQgBZp46NYM3eytxDkeWQ1bNdsACJncV0jrhAB/B4bHiqlG/NmK3byDAvl+8bO2ZwuR9vCZfHWYXkJmOHUZQeMyt7OJrYInUIruNhKY2esCdTCvBuXpr554ZRfM0qGN6FFE32rLnQ4dfFzLZ7bmIikpsGKlvZZ1QiDuBuneqJ4ORt9x1A1zutHHQWEXLbKlWrkq+gbhmI+/TC7ZzMIB4a0IG0p6rZD2NyXKIW6FgUG9AoCdhQ+55wa42F2dyqOqb9dzku5JBTFZWgnzComXey4WHEV/lA0mRkGV92jGwNj+7hzyk27/ANBubMjbCsQBXtp8euRVuiv1DiXMKdhTP85Dcp8iwN6T3sx0iSaJCXXfjnDTPEs9BibCcOWawx+5sxje7XaHFrQDi8bOyGp59ZL4v+jVYvvt6eXmrIryc4+2o/s+8U2x/3HofACUT/sKOIqZMaR/2nR3Vxu3M8JNmDzJbjVmn5hfFqQ2jIQSPISp9kUnI0lhHFLTpJz/6jJrCSV2vYP04QKG0lmnDGAXvBNL8KrjS3jACJOh9w/cvnCgm4dN3Bb7f7G6MNUH1HTmtAZVHzKsz6zd9D0tqU/oi9qmWbLsCy95bhE4TDFsWYBTq7/5FFuW1m6zXpHzhQGycHzjV27A5lLXL9ynGnbgY1rMDvl2KS34N709ZgXhUgPgvE5zKfHK6uCSWaEXY/VI5zjRZKZQDFDCpgOKz7X29uQSPrkOVn1DhlGukPd
 v+uHWUDl
 qLapkGG6HamWOLFjZhRoDDt5VJjzNn2ABfMTdyzSB+f63fPCl154IFLQBIKbpTlJKYQhNE2WsHvcPLsMTSiKq+BprGMbzfbg4taVuiVmdiTVEif9b1p1FRaMObRUF95byksP2xoChPO9IQxO1EkMkPFl/YTT1OFmSaSMjfyqbY5IUljfcJve9hX5OHOwPupW4YNjM8bB2uhfDtZrKCac4OJGEVZSUINVrHWi8X0vpxaR4l7+IOoPjnCFwQYeYRSCT6WPFTLuwCrW1Q42S92jvdJwuWjaVfk7bl0G/dzIW/YR3LkN4vo8PsjvUl2+kyVKnkw8mtbMABNtHpd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:57:03PM +0530, Dev Jain wrote:
> From: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> HW-tag KASAN never checks kernel stacks because stack pointers carry the
> match-all tag, so setting/poisoning tags is pure overhead.
> 
> - Add __GFP_SKIP_KASAN to THREADINFO_GFP so every stack allocator that
>   uses it skips tagging (fork path plus arch users)
> - Add __GFP_SKIP_KASAN to GFP_VMAP_STACK for the fork-specific vmap
>   stacks.
> - When reusing cached vmap stacks, skip kasan_unpoison_range() if HW tags
>   are enabled.
> 
> Software KASAN is unchanged; this only affects tag-based KASAN.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

