Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A2E5C5CFDB
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 18:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 454BD6B00A9; Tue, 11 Aug 2026 14:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405706B00AD; Tue, 11 Aug 2026 14:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3426F6B00AE; Tue, 11 Aug 2026 14:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 142B86B00A9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:24:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8F181401A2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:24:03 +0000 (UTC)
X-FDA: 85089812766.04.42C67CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 29E4A18000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:24:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHJzkVFD;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786472642;
	b=aV2uqVzjbXtkoIoDjz5FlY/2ZgEmPx+eIZE1WYKzRCsbwARCtJStLdfFv322fz1G+sj7Uy
	FT6icBgVrv6AC1ADrtYBk/FBJzlUipUd0FN4ct1idZrl3OIwQjcRED2e6Yl+gRfEJlHfjp
	BkE1SayQuzBJPJ5dIGw640DfCQmdX90=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hHJzkVFD;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786472642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUoGMLlqY3rbOTaypjUIdMJxKDPsbeVgkgJ1rrI5sHs=;
	b=DJG8AVnSdI7vwBjCPCHJfXU6+ErOb5wIQ4HPkRmx9ocvpQHax/h5PzdPe9Of8GbUF8ff5C
	7vAH0bZB5VIZHfOHZlFERE/qwilfGJdWy7pYWkNtAD1qEtdvjN5UimTv8jx6vbUMtstIYI
	mflv4a49ZKGEdfO3cvdgjj9Negh8zps=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08CF7600AF;
	Tue, 11 Aug 2026 18:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0208E1F000E9;
	Tue, 11 Aug 2026 18:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472640;
	bh=hUoGMLlqY3rbOTaypjUIdMJxKDPsbeVgkgJ1rrI5sHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hHJzkVFDWfCmuKYkR4XjxMzJFNmZB8HJ8Yi/bHngYG5rI8EnhdBozTj0pJjg+/NTK
	 dEuO/r+i3iaO7H07Ox6c5UBt7g15P4cBk56SEZde712lGrZ2lcjzqCm37SDb6+pyQG
	 NkYVwncPEihrqR5OAdUo26cCzwxNLepmoQKxj9NV6RGpa6QG9cRhbxrsbc8S5hVRDY
	 dUkQfr3VBmx0BunzdnNEO9aknrDezSHysn5UWKmaNnu5C0/VKBZu9pMECBWu+W4B/3
	 fR1N7uwElivk4KyINF9kYCpuE3SxJ6/u/dSGOT6Vb8BSue4DkQnAel2BxX3Q4gDlhB
	 Lm42X/R/AEMJg==
Date: Tue, 11 Aug 2026 19:23:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: add stale walk->action race test
Message-ID: <antoRbvwXVxoQ7Dw@gremlin>
References: <20260811161949.3879321-1-imv4bel@gmail.com>
 <20260811161949.3879321-3-imv4bel@gmail.com>
 <b27f03ea-414a-4ae5-9649-2a05398fe082@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b27f03ea-414a-4ae5-9649-2a05398fe082@kernel.org>
X-Rspamd-Queue-Id: 29E4A18000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ua9ajopu4unhnsycantxbs3f7cxsajmd
X-HE-Tag: 1786472642-888658
X-HE-Meta: U2FsdGVkX1+29rEn4szfeB3KEu2k+kqrsFibSm3UwbRI+076T2hhbtbrEamunTODLscveqR8CfNUvKjruaxn28jMtrf0CencCSnVlcX+9cF5Nb+NElRjgRV0JPRxAquVyLH6e06uEAzqCFg2KYpgV9YsmGu9SKhBDyhwRNEq3YvPohvskxnEWPHogXtOB4fdU8jyeuYAPiNZ9hym35RJjTqfB5N2b/Z3kKsYBxJqjy5+fCfXnNLI0pgY+QiG/JBEM4e0fQxw78dZ389r63ScNf/5R0B4n+2JsEpfK9PCKas7ZyJf1MeoEcAThSVOGk5NuL/OkFWNMRpvtbo7i8cVex06w7u/l1d5SSKZKFw0Z/RI6KxXcSI3GqQ1IuJMw062T+mc9Z+kUXlhdopcGxFmq6wVEeNP8mlcBvOMLiRYIowUNQQM8QfO3co8OpbW84mxF/2Fl0Lcv750R5uLycicmUP8Ri/xVsrrI18Fhn3F2P1mfrG4w3V4TVF8fYpIiUWOCMSOYY/mVbCZrJinkzCWden9jW5Us9Wialn6hkojMUVpDbSEbC/Qig4itdhQ+HMf3Lxk1gUqaSvrW5LZNHUJs11qyYJZgWb7ASInIahydDFRnnKLQVnIuyA8dsOV7djnkrdQYJZugOeTq2MttsmFKX8H2KzLpeymyP10RRvzf+ajE1OCp3lT98bOsYosk4hoHkFFZpZH/HCUgmRZIOSyJPa7kcO1Jzba2De5bSpf4DKF5UnNQh+S2zDLkny+ETVpXVPu1MOyTyRZgb8Migs4g9BSnOSfaiZah3W6mk4ouFH+5b3+lDrqtfwNxEgbVqr9wVb9bGYVEz8iIV5m4+807rpGm+R+FGj40jLYYqKYATLt7g1B/HYD1Wn0+ctTF1ATLv3jCKz1qjc2XRdB1nOLtatFY7RpULycxYcWdJfZn439RZYTyEqY7aQmAdl4OsScsqlfeRMaFYPq3CcTLoK
 vCm0AhWA
 O5KzEAr4pLWEVrpjAfMiu8OeSs9uwjUme2d3hoh4MJPgmGLs+QEgdKR58yCs0ePFqNnaXObDjM7jTFi3plaOVONrCImoj+MS81ECla2PyRHIlIvtYVgHkzoiQKD0LqyxhtXypGtGuV39G9X2CPpuzeaEEpUUxVbWNleN9MClGRHKGvLK2ZHEiuURzt7TMs0GBV6eVwNHnk0XCUrgx40xxpydpw6oSPPmJknWx65IFLGh4+yPCXnmZaoEF8g6KzC3yz46dqab6kzgViaBrnJYqgd6Npw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 07:11:59PM +0200, David Hildenbrand (Arm) wrote:
> On 8/11/26 18:18, Hyunwoo Kim wrote:
> > The added pagewalk_race_test maps two PMDs and faults in 2MB of the first
> > one.  A second thread then faults in the second PMD and drops it again with
> > MADV_DONTNEED in a loop, while the main thread reads Rss for the mapping
> > from /proc/self/smaps.
> >
> > Clearing the second PMD while smaps_pte_range() runs leaves walk->action
> > erroneously set to ACTION_AGAIN, which causes the PUD walk to be retried,
> > so the first PMD is counted twice and Rss comes out twice as large as what
> > was faulted in.
> >
> > mincore() is the caller named in the fix, but the second walk writes past
> > the length mincore() copies back, so it cannot be seen from userspace
> > there.  smaps reports what the callbacks counted, so the duplicate shows up
> > in Rss.
> >
> > A failure can only come from the kernel counting the same page twice, so
> > missing the race is harmless.  On an unfixed kernel the test fails after a
> > few hundred reads at most and takes about half a second.
> >
> > Assisted-by: Claude:claude-opus-5
> > Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> > ---
>
> I'm sorry, but I don't consider such a specialized reproducer for a problem we
> hit once a good fit for a selftest.
>
> Or am I missing something, that this here is more generic?

To be fair I did ask him for this. :)

I thought it would be useful to have a regression test because there's certainly
no harm in it? The code is very sensitive and catching a similar mistake in
future could be useful.

If you're sure this isn't valuable then he could just drop it, but it's my fault
sorry Hyunwoo for giving you extra work in this case! My bad.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

