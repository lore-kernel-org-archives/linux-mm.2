Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90696C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7ED6B00A0; Tue,  7 Jul 2026 09:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8984F6B00A3; Tue,  7 Jul 2026 09:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786B26B00AD; Tue,  7 Jul 2026 09:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CEDF6B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:56:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C72CB168D8F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:56:13 +0000 (UTC)
X-FDA: 84962129826.20.573C83F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 320291C0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:56:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jHSztCqN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsulHPPV7cKKpq1pg5kBYTKSehBdOYqpjZso8VAZf8w=;
	b=g7/1Lfaol8FileblK5lJ0jySAAMt7n+DP3BZCSzzdlXH/whLIZG6htYIVP3x/pvDbqHd0c
	HsGHwSiPHt7OC3iQULCsz47oPFOgCIvSJ3n/mLHAQk0QH2lHm5UmQt3Azm2hgKW3PuAyLK
	aoEV+2oRFENtx6zsGTEbS02bG8nn0ks=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jHSztCqN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432572;
	b=8Mzg+4UUAShX3Og4TQm+EFAVneaHB1nyX9o4b92svnqFZaFGhlygZrpjYo75g+wzWsZNjS
	Uce06Pny2M04llp5yz74hTZ5JRuEdo16wBf4Dm12HbC20yXJdNyO1k4yViFQ5oQ9usX+Mr
	Vwxs0RY/ZG2q+7SO3cAm1XyJY+PPnyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F0F041FE2;
	Tue,  7 Jul 2026 13:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D671F000E9;
	Tue,  7 Jul 2026 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432570;
	bh=YsulHPPV7cKKpq1pg5kBYTKSehBdOYqpjZso8VAZf8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jHSztCqNcZj5l1XY/Li9FJ51I+dsx9ENmMATmd3nYd+0ajUD5ZifB1uUJ9q4KamlW
	 cPnXiBcj/QaYeQJXAeJMjWEBAj3fzm9z8t6C0wam9zU1sJGY+MPP0DqWFqX+3iPUmx
	 4SBO109ZVTumz4UAuIGT5Q1ivLHFzXak6Wdi3+6BJfMH3NsEj4yUozA97CkdeaMeeX
	 fxJvwm9EOzQMajTkgSmlJomKTKjsjIUgNueiY/6T4FTtV752sp1oTetoK34IwHwcUs
	 J6FFP+JXPFkxkc9YSQwWMqfcioCsuSe+9bWB16ILqHP1dCwKo0DfjMz++b/AZWNhtf
	 vVwzU6cfNo94Q==
Date: Tue, 7 Jul 2026 14:55:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com, fvdl@google.com, 
	bigeasy@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	pfalcato@suse.de
Subject: Re: [PATCH v2 1/4] mm/migrate: do not migrate folios mapped into
 VM_LOCKED VMAs under compaction
Message-ID: <ak0EsCeucJarlI7G@lucifer>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-2-chenwandun1@gmail.com>
 <akz7ythMxfIZeT0d@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akz7ythMxfIZeT0d@lucifer>
X-Stat-Signature: 37rfdgyqxqm7abiyqx6n5s7ppcwtoy8k
X-Rspamd-Queue-Id: 320291C0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783432572-727616
X-HE-Meta: U2FsdGVkX18jL0T0meGbCqIEfaQLVvnYFb0kEVZlVQpiP9sCKdXyYQejW/TJ/fXRcKbX80wrxZDjwN7naABtJ5xwZIVS1yTT/d+53I50gXFxgvWpkxZgnOlF9tuIVSFYxWLtR1OJfMXGZ0zpe2NIqktvue+Xt1NQRZgBK3C3QewTrR3CxLKYiP7F87VySiZcQL6ArTraCxo2mthOYNL8NQ/IxnsqyYXH8mfRiDf9GYeMmEi++kSXnHHylClxgOghAajHThaJziMUbo5LsHnWRlfOD/bFwrkJ0/L2w3vn5/jxoDbDm40LQaKA2aWTQaFGACuyLeT0Dx1SsFH4BcLG/k/v67S5K2A8QFnPQZSj3NHP1JXPmtgmM2dBQ4MukYyCc90p+8K46QgkZfCtrkoWLyViLbWKfPhgPwWH/1eW0/C8TdBHElDmy+PI2GvLDAaOGjITbAqwBqSchHyRkOETcmlXJftv7zjztHq14EV/mYP1euiTnj4J6jKZg/zdCCyjA89QLldez6Moe1aiYfGeofJuE4I/MPyKA7zQdV6y1BwDqcXDvJmkkTYqlh3wWXY+ZcBWFranwil/IeSABAEOpsD9NISMslwZIDIs/y4Y+rGTsIXylort5Vy3Rf54pnW/+sPV4hjqLpHN3F+n4ZtO+lzcCKV0B9QZFysqwQx6sRjIHtOYjgjO63t1wctskMA0dbE6i0mWqOE7PZ03O8NMVmZpOGK71lmHY98ZK/83ME8k4GSm13iIusIehpenRblujS3/1Ssq3Zmvik5r+cr9SynlTTfybnR1d0TxeZtQsblyCUM6W7X6zVuK0JgSaIoGPG9UVoL72y9lu3hHrrTiqYaji/N2WxGn8FXbIpfvrhPjAgtOS7sZFaP7hP3hjw5q2w/9d8O+ow6x4xQLjRse4ceAoyMj3LyeqJ0XWhdc4YVHi8kWYaLq8FGpZ7Qnqfixg10/8anEmawBi7y/tJC
 bvESkkcN
 vGKcLo311Y0eDri8NQNWk2Mf1QYdergTZeDQVE3f5ODWnzkU7JFqxT7m3JwoWY/sS7U0HgcgEcbXDQvI/GDTN+B9ZIqb+8HiPs6t1qZC1NfQKDU6uT1CaqcltMyCEF/38Rrr4hB28StlAL8YaEOvVPzYJfTdPb2rm4owPwkb5aR3Ny64SwEYUcj/qioYqG/Jk1VlMJBKvIaCvtH+A9B2gomYfGKvy/Vp/kW5nAPOt8CS/vsmxxHZI+TaoCRviv65AZdqS9fuLGA0HwgKwqRJFfC7SpE+FjN2+If8h2ZrgPMyA/9PO7JvYi/CboDY1VYEW6/gFlC0t22tvMc3Gz2ZKy+4iIVadC8RjtvQLm7knCppVhPFsNCqrf7lfKF+xuqqbG+pL2Ce1oJpGBObU7kKedKbs7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 02:44:50PM +0100, Lorenzo Stoakes wrote:
> See above about deduplicating.
>
> > +			ttu |= TTU_RESPECT_MLOCK;
>
> Hmm. I don't love 'respect mlock'. I guess we only know about the reason
> being compaction here.
>
> But I'm confused anyway. We have the folio, why aren't we just checking for
> PG_mlocked() here instead of getting the rmap to see if it's mapped
> anywhere with VMA_LOCKED_BIT?

Also, since compaction_allow_unevictable() is a function that is accessible
elsewhere, you could literally just have a TTU_MIGRATION here instead and have
the rmap logic call compaction_allow_unevictable() instead rather than this.

And then you could adapt the function I suggested before not to take a reason
parameter but rather a 'is_migration' one instead possibly and then pass (ttu &
TTU_MIGRATION) in.

BUT. I still question whether this is at all needed since you have the folio you
can check for PG_mlocked...

Cheers, Lorenzo

