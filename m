Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E782AC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56526B0095; Thu, 30 Jul 2026 09:09:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2CDB6B0096; Thu, 30 Jul 2026 09:09:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D441D6B0098; Thu, 30 Jul 2026 09:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B24FC6B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:09:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4BC5F4014A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:09:40 +0000 (UTC)
X-FDA: 85045474920.02.54D0213
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B2EC5A0003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:09:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oh0phniM;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785416978;
	b=xflfumcmxeK9LwVQvxpRsed20UblkI3QCSHAHnCUJgv4vgJK8K6AbETKlddqtf7H2f1E4g
	cvZBPQ50GioLzEjexjqIWA3r2HRVpfg2c+Jvli0XBHhYaqg7DLulr53JHw0uMUnGGqg7xD
	fE8PMVgcVcj4AGn7zYNwkGebSyaGkr4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oh0phniM;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785416978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nF8RaaPGsgkbmp6APmxdP1QSXAEwh87b+GWYpDNFqnM=;
	b=Z/c41MAcX5Y5bAPoLNgKMk4zBR39x4cNGnn1O7DjbtXJFczwrldflVtu5EoUmAEjubrLq3
	Xk+CgdT1ywIvVh02go2i8i2Oy6rQRV76NIPnn1y09B7OZESCpL9C1ObU1L4kVcx8nHEX0C
	sfderaxJn26KGmvYxTxFGECcB1FtwFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2995A41E98;
	Thu, 30 Jul 2026 13:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CE51F000E9;
	Thu, 30 Jul 2026 13:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785416977;
	bh=nF8RaaPGsgkbmp6APmxdP1QSXAEwh87b+GWYpDNFqnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Oh0phniM4GRIkO92rMLKIQV1xWYsmqUahZgchMwwcb/ldPd6MZS/1k97f2ASMmxTb
	 /LwUKYLiyUUHVvKVnG1/64XLKGupTWEjFSwTISVuwbCUcb2GNCBpiZVne+EbCuXxmB
	 j3+yYBlN8pOiWhJxQugomvrW8vgVsOLvr4PwaNgxF5u1zqBTY6Dgk1yKl7SuJGugwH
	 lrKbBhuVkDzm42D1TltwGG4qIZD1SARTylrZ4jHdBbusRKZ44Ks5Q59M1KZAjwOBrn
	 47I5x7vmRA9mgfoCheIeQqAt/habxABQ5CV/zp7VILBnP4ZTRIR6ySLQ4pX41Fx6AL
	 3IklTXP/oKsxg==
Date: Thu, 30 Jul 2026 14:09:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
	Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hengbin Zhang <uqbarz@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes 2/2] mm/huge_memory: fix huge_zero_pfn race
Message-ID: <amtHMG4owrzXeLx0@lucifer>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
 <20260728-fix-refcounted-huge-zero-v1-2-3f261f5447b4@kernel.org>
 <25d560df-6d7e-462a-a987-60a8695793ba@kernel.org>
 <amsch6HvEH5IJjfM@lucifer>
 <39b527d7-9c6e-4798-be9d-b834c8a3d2a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b527d7-9c6e-4798-be9d-b834c8a3d2a0@kernel.org>
X-Stat-Signature: tws1jgkt1rhpcy7sq968x75q5ak3jwtu
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B2EC5A0003
X-Rspam-User: 
X-HE-Tag: 1785416978-28059
X-HE-Meta: U2FsdGVkX180ebCCpZvB3AzTeizBu2rPga6Pc/79ppf7tm9A4uF4yh8ua+k7B+28N0Wp8YsKNWLEUptoxoxUGt1D9BrdaYe4CWT31d5Z+JWON+WaSefEDLLEZGJhBVdbV75Bp2kviPj51N76gQS7qvr21xR7sOQ7UL0Js8QqNBIEpQ+rhoi2BqEGtR17SVGEGinHYPdVxTvWcQnaDqhKxNh97zI071uCoBT0qhQTau0rHbC08Zb13YBBA7btW96KpPHmHnM8K7qhWr6GNWvAXdpPsmRF5vvpJK7hY062h2vnrPPJcaoBSDeNjRmAbDZAeL4i/hZMhhA8/OJFvJo9WU9Q8f2RR9qyfm5chJz7kqvLBBNwed6qtgEqB6jEraRNcJhr8GkWggyWcvyxYTxnRxq9C8wioIDi1UaxSpNHzwOLn9bW8fWS6SaqFyMiaK2qb/JBcb/iGOCW9vqKcdinTUiJ0IZ994Tnkrr6WzyGk3CzgMlGzqsQU22Wn4Rsb3DewMFmi4M3GYkNjAKQRFwSfvP11T6A3Vy9xk2Jh3xgBCBi9zzEiJ1Lvz1f1eHPIvOSk2UTpGo4nEyncQtFOC9FEh5U2LN8Ha1a1C1odFULC4rurQyytJwZHwfuHuko8LwGgK6nnZsntOSCk8lEvRS3gNEq/WMt1G+Nn5XR3eqTQmoA0CO4UmW8F5IDHynS7w35s4B/0NH5AuZuGYA4CEF0FIMGhvp8TMUJlxy08QN6nEQfrS7rCocJES7Vvyxvuw63JjKlwWOKjpsoV7YvWnyp8OTtUMU/jv416xO8vKTzOkLlZUtyonmRaEte7ng6HWf4akq3ZvzkzI9u397bofOBOTjEyFYGr4M78t7iCxU9kgiK+fhI87sDQZh8uCZPJpMR1V5KOGQunoS4tfiM15yIZkmS4OHmpRc940inKIbJ1tYw0IifpSxBdIQoI7TDPHSsb+ZPhrIS2v1G0RbDAK7
 kpvNASAi
 YvcDNn/029gnLQuQeCSis0CJ68P9WKSvpVoQIXDJcdf1L4/z4qjS4GASJzi/W6tGrv9XGjzZXf+92Sl8xS224OgNF0FmYx/WnBgvDrXxj4qLo4KMKtgApgtd7yEHADY+sO1U6cJlO3mN++a4vxdw7uYpVJUIKvH2e9IISG+NZJb4Y+JrvnzvJSENjE8ObJHO2yiYEmzTq93S1sGCTPKkgVMWqcwB7AVOyi6dimiJzuxwIxg6Rxe1Yc+x3D7wc2dueyIrz/y619tKLP4RKeOpzuTmIWB5frV0zHU0SU6S3d3FCiL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 02:10:23PM +0200, David Hildenbrand (Arm) wrote:
> On 7/30/26 11:55, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Jul 30, 2026 at 11:22:09AM +0200, David Hildenbrand (Arm) wrote:
> >> [...]
> >>
> >>> So invariants are required - huge_zero_refcount MUST:
> >>>
> >>> * Only be set in the huge_zero_lock critical section to ensure
> >>>   serialisation of huge_zero_pfn, huge_zero_folio and huge_zero_refcount
> >>>   writes.
> >>>
> >>> * Be set non-zero only AFTER huge_zero_[pfn, folio] are set to valid values
> >>>   so installation of the huge zero folio on read page fault ensures
> >>>   concurrent is_huge_zero_*() calls correctly identify the huge zero folio.
> >>>
> >>> * Be set zero only BEFORE huge_zero_[pfn, folio] are set to NULL and ~0UL
> >>>   respectively, and atomically.
> >>>
> >>> Establish these by:
> >>>
> >>> * Only updating huge_zero_refcount in the huge_zero_lock critical section
> >>>   in get_huge_zero_folio() and shrink_huge_zero_folio_scan().
> >>
> >> That is imprecise. huge_zero_refcount is updated (incremented) outside of
> >> huge_zero_lock in get_huge_zero_folio().
> >
> > You're right.
> >
> > ->
> >
> > * Only setting huge_zero_refcount to zero or an absolute value in the
> >   huge_zero_lock critical section in get_huge_zero_folio() and
> >   shrink_huge_zero_folio_scan() and updating atomically elsewhere.
> >
> > Seems better?
>
> Yes, I guess the transition from/to 0 are the problematic bits. Everything else
> can just be lockless.

Yeah exactly. Also setting an absolute value in general is potentially
problematic.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

