Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC55CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 14:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41728E0005; Tue, 16 Sep 2025 10:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18F18E0003; Tue, 16 Sep 2025 10:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55888E0005; Tue, 16 Sep 2025 10:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D58038E0003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:20:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88B10118732
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:20:19 +0000 (UTC)
X-FDA: 83895323358.02.3703B2D
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf27.hostedemail.com (Postfix) with ESMTP id C5C8240016
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:20:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=ZmjL6RjW;
	spf=pass (imf27.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758032418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYbUqQqq5gBAL5NIx7a64DWZNoB49w8Fp0Gj3T0pxnM=;
	b=6dwkYw2zIBI4ujX4zec3lf1sIk0fDzNxb+2ALjaEK+vWvqQev7lkJGrkzKIDRyRtXJP28h
	GI3aGdIyiH/rFQ3KotK4fUMz4nu1LE6gnqiU09mqHe5wQvwzQ6sAPN1wRzcRFy4YsRehrU
	Xmt28by3x8+A6O9n7vbiqym6aQeKqK8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=ZmjL6RjW;
	spf=pass (imf27.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758032418; a=rsa-sha256;
	cv=none;
	b=57X3W8bGrk3BE2TcC5aBIkh8O/kjHAXm7mvp54pOmkd9D9935Lzzvv/E6+TEUEWS2qBHFU
	Pu+hZv+gEKGU456Rm/nSVzKCbaMDxLlrmjI+X3rd3rJJcoLgcOLy6CYz0g4XPnUeL8JGHT
	Z9ViPg8Yj4DDWO9BebiuUyJ77j6NiW4=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 6F8B140506
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1758032415; bh=zYbUqQqq5gBAL5NIx7a64DWZNoB49w8Fp0Gj3T0pxnM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZmjL6RjWsOZ3eAjNFWsOuzjJ0Ru9j9OUpBRNBMRLLKNfG48ZXDy7L1DBpuUggW6Sb
	 Kchk7t0p0giMOvQ+nErBhBHHuOMLmgD2X0Os32s4ZIHYuaOxRxO95RmmZmombPAI6x
	 VnU5WL1lASRpwAuGmchNSyDbfhNSbjgWo95ypTGez30DhV5nm91BcgQrda0Fc34U/0
	 X14t+pZGhwYrqfWabPVAD1U+rr8gEiYrdFwLfCtkOMSSbfMIOyv5m5HgVyts62/am/
	 E1zv0QBP7UDkqON3AtqWjJI0Wa2A6d5d4VTIaaxZMvOTJYdeTACO+Jawj+JyfdW1fg
	 eH5UgPsER07pA==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 6F8B140506;
	Tue, 16 Sep 2025 14:20:15 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Morton <akpm@linux-foundation.org>, Kalesh Singh
 <kaleshsingh@google.com>
Cc: minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de,
 kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook
 <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar
 <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn
 <jannh@google.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mm: fix off-by-one error in VMA count limit checks
In-Reply-To: <20250915153642.7f46974a536a3af635f49a89@linux-foundation.org>
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-2-kaleshsingh@google.com>
 <20250915153642.7f46974a536a3af635f49a89@linux-foundation.org>
Date: Tue, 16 Sep 2025 08:20:14 -0600
Message-ID: <87v7lifpi9.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: C5C8240016
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: hyppqzdcbs4kkigm5yf8h6hwbghyjx8e
X-HE-Tag: 1758032417-161425
X-HE-Meta: U2FsdGVkX1+wMxcBb96Jj9FIz9yIZdNnU1OZ5mdsp/LbSI1IImyl+8VUKNffF+ENJuzxolgenr7aYObglFYQRA+qayy2RHPR0mFAomBygPqHhJiDnXuhqd0OpMyUtAuzKX+LSvAzCtNMbUldTTKKSMFcLs2zA2dTMJ7jnwD/xjfwSCVhXqAYl30tYG5jb6D8K3b7NK6YGQRR3q0gc3vKIdktUgiHfc4H4AGSrNnCCgvwuMY2dScupYbemQst4RzzktmFeaaCJjmpUf8WGFc+sJigLtT3oKU2lKqgxS9JuZoZi8Ixdd5qwtghpwKejneTSM/n2WULjVZc2kASpT0SuRGqEkh3LFisQ29MFo5h7LUElnoucGSTNxrXn7eNuFgeHduYzhnT2+VeRXMZFBzauFHNaxeFJrC2EZ9UlvsipbQ0cE6sI5GiXUw4WvlGgCcsvDsEWkqh0mfYYyCocG0OTaS0ZR4HNT8CUyDIdfMiqJthy6ArK4IBYTPdfDkrPUlwafmgJXXveXoH7vHiOHerI7I0eoO7oshtlvoK46ln2Kw9FsJ9j5Iq4FvCgDg2ged7Aey79gLmfRLjtdTR5YIlhyhnT73l/u/euT6ITz51508JyUf2DNDuJ8WlvEsosHds+A1rrrRkpffMIM3KRXMt68qgtp0VNlpLM5z+6NPIXxGnFbyJP7NxMbsPByhO31OCkO1NInlwXlU7B358M8yed6MKsvCiJP/vI2AnbSMx5DCsxNOO9HaJhNDP2nZTJfYFcoM25pPdsfzYSkX1UYoN1aX8SnjfjjXEB8aXaX2ZuYZRH90snLOrqYDSshmDkvKoiMHnb1Ypli4XTVxRHb8wFcl903TATEgLR1RcW+JFViKyGu0afteqCTYXzbUCiHEVqrUQxA9Fm9xogqHr8T/Birn1Stj/7YyrdEYyfDsBmgC4mXc4QMbKoIZlO/3QPd7V962k+M7aPVuItdvz5y7
 HbA6ybW5
 SbjgjVR8S3oy3iCFp0+399A0EhxSHiadevDIBCYM/sR/YnhfaD/4AHEkAWOmmzwSdfEcnfpmZvMhbZid2huNgBF84jI44hMLzLy3ESFqPIfzxWx99vZ9fKqAphTNkSlUGL5TagI/huO/YWBcHvaPkzANV9wkGWfwGx3QKBFd2BZgBAdfiMN6kwA9nFlKirQvstzImb7jUayG2WgNEMKayuTTcTELZAzxrzSJri7G/mDw37SR5s0vLPJR5rNoDuLRdpdGYe0BowozxC0OX+PAv/zdPHxLV5jKVdCVr9m1Ld1EE+cOeuAEzmLwIqn0kpC9ZDT10bHNKlHwRgypUiNz/vEuKE4houZ5LxzcytV88xFGJWfUlcVIRH3NV0hnebeobRJ8OctxvBHKBPvFYDFiOmFUmrv4Ltjrc9+AOhTBqt4aiRMqRkCBIb1029g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 15 Sep 2025 09:36:32 -0700 Kalesh Singh <kaleshsingh@google.com> wrote:
>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>
> lol.
>
> x1:/usr/src/25> grep "Fixes.*1da177e4c3f4" ../gitlog|wc -l
> 661
>
> we really blew it that time!

A few years back I made a list of the most-fixed commits in the kernel
history; unsurprisingly that one (I call it the "original sin") came out
on top:

  https://lwn.net/Articles/914632/

Perhaps the time has come to update that analysis.

jon

