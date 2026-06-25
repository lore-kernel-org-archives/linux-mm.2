Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11240CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9BB6B0088; Thu, 25 Jun 2026 00:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33556B0092; Thu, 25 Jun 2026 00:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49636B009B; Thu, 25 Jun 2026 00:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC3DC6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:42:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62D60120578
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:42:34 +0000 (UTC)
X-FDA: 84917189028.29.56099AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 63D5840002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:42:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="i0hVhT/R";
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782362552;
	b=bioHtzeanPtDHpVLUYW8WkoZX5dkeOw7MKj7xPFfYnJn3JHz1FDugADhBJE0E9+yrWrFVV
	NV+dMaN3hmev20hBimvFhQbVN8k6ngwFO+ZYkzXeyRy/oqoutWbN4pVJO3q0mKkElNIdmV
	yWTKBAHuenkrl69JyszwBCsJLh3apEE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782362552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CA0sktO++Ow6VRpzdYwlIlbQ5DKIdcDWBy7MYZV0Fsk=;
	b=ehLpa8W79vQgc4ZKlCKJBha3okcFMzaQ0boIGXpjPs4umdnuAEG45Qwnz/bnzLuDT6nVq1
	99SfoqiQPOyOrO9GjklTpses3rbgHxzaoBn2Hb+CQG3s6Zcp6gecovdOnH0h6MA7H2LBpQ
	4orjjBHJqv5j63XMSSeSegchsvrkgoY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="i0hVhT/R";
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE1B160018;
	Thu, 25 Jun 2026 04:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E311F000E9;
	Thu, 25 Jun 2026 04:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782362551;
	bh=CA0sktO++Ow6VRpzdYwlIlbQ5DKIdcDWBy7MYZV0Fsk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=i0hVhT/RTreO4fATKMJB2/9g3pPL6K6+1aKqy1vkjPFkSiV2rIS4DOxlirhKwBBDI
	 EnLEEivh6FnqU/wcSGx29p0ih0BtsRKhw53f2g67FoZwvCS8Sh9/yti+VoLV52WXLe
	 niklqSXkacwoAn7Tj6t/L7UF9AlLT5MOqGxGCle4=
Date: Wed, 24 Jun 2026 21:42:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: david@kernel.org, ljs@kernel.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: use huge_ptep_get() in try_to_unmap_one()
Message-Id: <20260624214230.4aff522ec8fa4a8f1607c942@linux-foundation.org>
In-Reply-To: <20260625042853.2752898-1-dev.jain@arm.com>
References: <20260625042853.2752898-1-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sanzrjr89hr95ygpzsb36xqbqbserzyb
X-Rspam-User: 
X-Rspamd-Queue-Id: 63D5840002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782362552-236300
X-HE-Meta: U2FsdGVkX1/85JOvqC0LLGmglp8Jrmf5Z3d+5ZaiNduejIAYX/5HyrFa2erRVf7oNFf8Gt8BvIEoNOQK8qY6vtkjF7lFbdavpTW+ONFU04cGxh4Y+Xn5n81OT2kZ0VR2Ae+Ka3CrVwWDUbFDq5aCItygvzhs0zzUuWsYu9pTFV1DctuNXKWBQrFTe4oUO+qsJ+5QzRGcW8looGgmA1l2r0GmhbQwUU3pwiTK+QX0AcwGCwh6nYLYcENDhVzGia6X57hhb2eRLPtpAs0pWwnaWBSmrmzJiZ2GyBD+kzhXEel6VjEXaz5Xb/oTxDPCZN3iPof0UiBC3l9XzPpuSYQGkhkKIRjm/al2EYQFayB277aHhY/+i5PHcm+A5cQdjIC8G7hEq1NUdszn2y5M0tPbJJE78ct2FSH01CLHqHGLavY8ufx12mYK8CdRzLEJ/3vbgO8MRbyIdlGgbRySwkfmJGbqEIUIhgC/+bS6ZTDVpo1n7nsaPOoYOxM+WwlwkTWV/xjZqg4c4u7aRXNLFAgHcgoM6TWfT902orwJYhY6a8tPePLKo6Zw5tPG3SuBbN3h1IHmD//2MYruv6Zq3KyRGQ+LnMKpysaz79M7RkfUWFjePesnQ3nIFdu8Kp+OKd/ChBFsoDdfqQPJJV/eZ1K9xdUSF1b/xrZYRTQcucJ++nhp8TkjyfWkdjRcaC0aARtuQ0XTo0WKHYN2MDg3cHG5xegyQS5QQed9jNrHGUPLSl0NDsjvbt4WmzmDNiJIMeYHni87MIspZs/QEsLF/GHJzEFabfJpr3vr+YTLKOjCfLPK+ho+hUA1LK7iQP14OvWT7giYydy7OyW7/FdAutn4RW52hDWM2zBZjb7ZmN+krqElmgbipMx5CP4wA4VHUGsn7phwGlc/Ojy9Py0eLY6aBKD4qTalR/i86dHTbHbgS71QAD09T2E0OdFK3J0KksFMGKzQvACLQjksHEJ71mi
 z9saBNAv
 2OpaTSw/50BLEzhJb7Lp487ftt2FxJoSbbC66qWsRYpbcHOr4Aq4XEqgIePgnmyF3TQq6QNbdxPYcJiXmL1cPcvXxgtQpUBYh8DwY4JI3PIPGbmBGO2hoi2dG+3tUWWlVDXK6G7cP1Ezjn1eDAY/wD/JAVzF3f16b5xIXgUsmazMPef2NlZG3KXCuQqmwQ6ZsdyhrdSJ/YIysGVTdcrI2x5LBbY8zpiyYO8TAtiZAzQ8UOosfPeQpY3zi3sVXxrWACsPgZVyU8Elz2GNf54gn/tbOeBVXOXhjOaPxq26XqXUAF3Wv+l7F6JoIdD3mhmTclODZcl+1B/fWuOZX8V4Ji+oCD2OjBDxnBRRw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 04:28:51 +0000 Dev Jain <dev.jain@arm.com> wrote:

> try_to_unmap_one() handles hugetlb folios when memory failure needs
> to replace a poisoned hugetlb mapping with a hwpoison entry. In that
> case page_vma_mapped_walk() returns the hugetlb entry in pvmw.pte, but
> the code reads it with ptep_get() before decoding the PFN.
> 
> That is wrong on architectures where hugetlb entries are not encoded as
> regular PTEs. On s390, for example, a raw huge RSTE must be converted
> by huge_ptep_get() before helpers such as pte_pfn() can inspect it. A
> raw decode can select the wrong subpage, so try_to_unmap_one() can
> install a hwpoison entry for the wrong PFN.
> 
> The userspace-visible result is that a later access to the poisoned
> hugetlb subpage can miss the expected SIGBUS. With DEBUG_VM, the wrong
> subpage can also trip the PageHWPoison check.
> 
> Use huge_ptep_get() for hugetlb mappings before decoding the PFN.
> 
> Before c7ab0d2fdc84, the bug existed in the form of a plain dereference:
> we would check the head page pfn of the hugetlb with pte_pfn(*pte), and
> bail out on mismatch. This would mean that the hwpoisoned entry will not
> get installed.
> 
> I am not sure what is the procedure on such kinds of very old bugs - how
> back should I really go?

I think 9 years is enough ;)

> There are similar old bugs present, in try_to_migrate_one(), check_pte(),
> remove_migration_pte(), prot_none_hugetlb_entry().

Why now?  Was there some more recent (s390?) change which exposed this?


