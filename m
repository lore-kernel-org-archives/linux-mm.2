Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30163C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 22:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DCE8E0002; Fri,  8 Aug 2025 18:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35B48E0001; Fri,  8 Aug 2025 18:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B726F8E0002; Fri,  8 Aug 2025 18:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5488E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 18:08:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17547160505
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 22:08:21 +0000 (UTC)
X-FDA: 83754979602.24.2B5279C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5CACE18000E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 22:08:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CHXAfBn+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754690899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTcFsdJnIZy+6CXzsbjM3uYWewPtELIcyQ102gJdot4=;
	b=lh+8+ZShDiLnCBtsbBI6rXp3aJviJ5Bn3Z5iCLtp8l03Ni0ZXPXlC36mfmUloFt/hB+3wE
	0nLjwN69P0CYUKyD/3n8b5vnEX1KFRRtKltK00bV1A/fxdFui2lQJLlkjbLkKRHMOFq0U8
	3wVA67Aol7ceuVwZZ8d3Sr6/IcFcy4M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754690899; a=rsa-sha256;
	cv=none;
	b=fddqGphTnm8aySM0wDoIhbEyZ4Wvm3PCYKb1qfdTojO5nVZx8iMty9wW3m4UGHyTC0JK5D
	Ef7RYQDOMQSJXA7bzPSftBvl5k1UJaID1KH37eGd+OnPfHLhXO8t2jrD4NpiJeniDhcq+P
	e3oxL9m6SdzIsfuWE0C8DU5c/oggpmc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CHXAfBn+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FEDA43DF9;
	Fri,  8 Aug 2025 22:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F30C4CEED;
	Fri,  8 Aug 2025 22:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754690897;
	bh=6Gi9ECCH0DmeSLy+hgk+Ey5g/XPhWoX3r/eqv+fWQ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHXAfBn+SBvPXsJDqFR6y7+g4HvU88NcOCxfzlmwqAvEqR1EofJnwqy61IfbY/9k5
	 c/+7CGF2JJHAsFben8vMdoXxvy52yjtbtwaHzNdxajD8Pwu9EUX7QQ5K7jWo6hXK9v
	 7WOpGziY1OGNO2VPLhbis0RuCocmkpLSah7JUiIrJgcd+I9SPjIxAkoUwLU9vF+iFv
	 USZYg2YxDrxffttm7rZ7CQ+x1ExsGvt1Vcnmzt4gpNJL5El/mkSQL4/+a8kgJUQBFs
	 AptKprNhuKaFfG5ACY6FBjiwhVh7klHSRMG1FAlkwzVSKmukeMACvwTVqENLSLmcVI
	 8PapuQ0dnnipw==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/core : fix commit_ops_filters by using correct nth function
Date: Fri,  8 Aug 2025 15:08:15 -0700
Message-Id: <20250808220815.49644-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808195518.563053-3-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 97irqqwcdwdrjswj84tp6sce1ru463f9
X-Rspamd-Queue-Id: 5CACE18000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754690899-69421
X-HE-Meta: U2FsdGVkX1/K4ThldATmMusbspsJBCgvfel1lbkrK+eaFOdkLrgMhhCMn71yTVtQQupLeOGH0ogdkq95lYfOdusvIC/rFiILeIQsTyK9G+n5nEJXR6Flo32Qkur9odpk43lOYj97ErhP5dDVHzNUKah/dhb9BJHNaZYrLK7h1v2QxHvzopIpSR5plzpIlYOilS2SsTTgXksd5Yw41tl/93DEHvndW0dOMU1TuSdRAfCeqoFoB9GN/KI5FGqd04LqaiRNb2Ze9E79gdUHjV5rNOqy0s9n/ljNBdDEoebJZJ7YK0E50zGLSKCNLvgx+f8PzatWqojmB/2kK53p39+JROgd0uo9GnCCkNClteHCGW7oWFZrGNpvEfcc5rSv5izW92xP/w1Pwd+g4P3HR8O2f7cXPWi3zaHz0t4rno4St6gjuGq96AV+993ofqhOBcvZ7CoYhhjgi4FBPbC43dIbhujnDn8Y+bH/gQD/nx74vfpEOUFXGNv3shERpla/gTB8wB6UIatFtPXh3on8jCKVESEUyOfKHbjz4KYNW7pqW66Blq73MC90qS1Fs156WJm6Gq2+lHVT9UKL/dq5qcB9zQlVhgZLIG5QwU9rM1paTkZBNFUY1xomp/hy/TWoIO8flKh2/ZZFFfTnjtNqV1mtFXjwCw5UAsrBNPC9j0+M98iEpv8Ru6OTUpw9bNhIAvpwphvrGLOR1FyKX4Ubi1/UEVhoZzzix1u12LMBpeQe9Vb9wxPqL0HoHeHDUmMezjhmMiza09k3TslQWj5sqH2cgUFMlxK+7wSSfoiN+4nfvUEKDvONdexyZu54RZ1uVxlnOmWR5nDDuqDvHiA78WFkZRADhlqM2PE59Ky9u/Z9HQYlI+smg6n3BhXETLyny6K+3F3OCIdnbG+aSBrsPolucDzC3wPjS0zd23/AbfJ+clr2SamC3PagZrqitb9Q+JIgJbBf+NKBgIO/d5b9hGt
 IwOitBCQ
 TtxholJ2ayj0piSQguJ/38dgJwSvkEABEEODp5j+0OOcTs316D5/MP5X81wpjqBkDN1vW0eXlRAbinhAJ2978tMREE7NGFqUMI/0ogIKz2JhXCqH3r9aj4RQNa+w8mqWc7KWPL2bSJczKhwRSNUWaOVWV+8/f3UFpi6iKFYua8152dAQunqCrWzmSjJPkpRSVkIP53lkleW2KZ4GoFgHQkyM6heK2KbDpSB1dpdxOHNNP42chN/ekhrQzfWS4h77Dz6KVZARNmDEX/BdCN6x8vHtne6uVouZ5D1PY8f11UBQxzItf7yvF0JzkMnOl5vErwmD+ZNs55JPh72I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  9 Aug 2025 04:55:18 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
> iterates core_filters. As a result, performing a commit unintentionally
> corrupts ops_filters.
> 
> Add damos_nth_ops_filter() which iterates ops_filters. Use this function
> to fix issues caused by wrong iteration.

Thank you for finding and fixing this bug!  Since this bug is better to be
fixed as soon as possible, could you please send the next version of this patch
as an individual one, rather than as a part of this patchset?

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Let's add below for stable kernel maintainers[1].

Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6.15.x
Cc: stable@vger.kernel.org

And the fix looks good to me, so

Reviewed-by: SeongJae Park <sj@kernel.org>

[...]

[1] https://docs.kernel.org/process/stable-kernel-rules.html


Thanks,
SJ

