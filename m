Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FEECA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B486B0006; Fri,  5 Sep 2025 14:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50C4D6B000C; Fri,  5 Sep 2025 14:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448C56B000E; Fri,  5 Sep 2025 14:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 341EA6B0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:30:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD3C71399C0
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:30:47 +0000 (UTC)
X-FDA: 83856037734.13.3CC6B14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0B975140008
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:30:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D1sDtMRb;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757097046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7b9VYIuJgYL48EsZg4/AlFkv1e+sL+Ne6nv1xp06k1E=;
	b=4ij+pwwpXETV9ilVcDAg9omAkQvj/yUZmhaoFw8IeotnyR996HqvVGmiPTZyVZ30Re4m0c
	D21hQVG0/MfTMCmI01HcvwrfiBBP+NFi/Khfyk1Bu9zbBbp/bVpcBVT25LXQhOjD/O2GMw
	m8HeGwxp2L1TCEyJtaNzoPaN/8ehDbA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D1sDtMRb;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757097046; a=rsa-sha256;
	cv=none;
	b=Wu9qMUnnSW311whjZKwmdE8RIrBTchv9XxvfQW96rP/vxzRBJmK7ucjX46upbZ+JluM/Za
	A1YlQknhemkcpz9/IdnIb9u4NYaIKChesS0WdT1D411PLiuUfolXKXCgvq++9vTJ0bcrov
	q/EWvpD6G4dNrDik1liWJVIewisX7zU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B7142401E2;
	Fri,  5 Sep 2025 18:30:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C4EC4CEF1;
	Fri,  5 Sep 2025 18:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757097044;
	bh=Ths2r9Q0+7GYMIMkvaTHPVsbLrlk/9SHbCDdMKgVc/w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=D1sDtMRbYZnBAQIplNxKWcfibeIAp+uefUh0m5gm0mR4BMlRu5hBMNKHkIJb0gg8G
	 gSH0beERjv09OM/B2vMQpARlW93eq2nT7MXyLVEckxDLwKTU0xtyTGj00ReZHR3FfP
	 qKFjBrul6T8rlYkHWJIzyvm6I+ATvvmXynYmIcnM=
Date: Fri, 5 Sep 2025 11:30:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: hannes@cmpxchg.org, linux-kernel@vger.kernel.org, Vlastimil Babka
 <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-Id: <20250905113043.3fb70f94c86445617266c958@linux-foundation.org>
In-Reply-To: <f0869789-ee30-4eb9-840a-502d031df1f5@konsulko.se>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
	<20250904093325.2768507-1-vitaly.wool@konsulko.se>
	<20250904164710.210731847fe25d9419203886@linux-foundation.org>
	<f0869789-ee30-4eb9-840a-502d031df1f5@konsulko.se>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0B975140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: okn936e8m9z6b7h6rcdme1qz66npia97
X-HE-Tag: 1757097045-951801
X-HE-Meta: U2FsdGVkX1+y4OJxQCBq+yIjc4fjPDMuzhdZAUKIvuE1SXmHHjAIet8jTypYQX43JNJ5w+k9g+039J9mn/p0x7WPXNbFFiKUW/EPfNKq8KHRDdxIEmF0FqnQ4kXRrBE6GtGVcciWDBKLpzNoOy36G/v57fOuFRdJtiGKg99QJGnJs3lryJWUs21IimGrsRK/+o7eiDvjrputWTPXDxYPr0dd8PK6yO3oQufuA36uPwYr8srFMdHvl3qV35eh/tpNat5yTSlfFHw9VN5MuHXOMdI/OV+CnVZkLTnzAb40nGEeU5qfNlfFb43Bhi1pC1B+2z4URKsjgM+HLCkpgVKqKk/uB4lZMX3FN99+fZ5CwPVU6R671E3OBZGszwaZvgnM8p6c1x7CKop+5auyCLMZHHpZjzgNpICEI/1WlLi0IvjC2L1R1P/QYD1f1MfPvA/g1s3LMZFQT6DGgrOqxqxdIwbbXnLrXgNXBbpfQsqTkrE86nesfnlwN7xShsYBqoWOmgJEX0cP939mQ01ch74LlxS64FdQjA3P1FaJ5E5E+dDr19pY74dnAlAOXua3+7hFHw2e42NypiDLz4F/ZKxK8Fy5eRkyPN1BmIhhZlW5VW3d00SFG4kI9ByCVHVCtRkUoua9AG3uf/VHhA+ZuYYVd+jDLnBEdCs6ZucM5WgMAbtG0o5W47veu9+Mq8GgRQaMGbSmK+cSc1Q+n3r5lM4mI4BP0/YhOoHtun6VYyUsVvIpcbYY/oklid/3E1caOVaVCwnYajdMvf4NsxS3tu9xiAFtbc/wAvKn3Kudk5YEJkCXH9vsavf/S3papLqiC1XZMbCOB+47SxL02TZgVfsdJHJk/9As3//lntbIgnKujDNTGm2rIowjpA+UU4LNivqpbuYW2zNtHH3AnoDblPKOsJwC5Bo4QVabDfpWu4os9HiBsdKVr9wtPFewucw7upSqrqLtpAyfa5U1zDeshri
 2QsfOdhX
 Fru1x3EFbHucB4S0zvvuMoqJy3Jd9HXaWbTTqQBaCYqUG/xcPQ2374+HnEw9/E0DYaDugQlFZFafi4Ua+UZeVNzU91uzPljAgKBNZfqX7d86G77+PO4FBFz+TG85L7i7/F95XK8YddT163xIJrp4dnIvgMHb+0/MBC8Lf8EDLXfw6OV3iJQqiwNUdQfn7teiUnHdOou50wDMtMzaQQrU34oxINnbwgBM8Nj2l1WBC8DDe1hs0qrbuGjeR1s0pOE+li/+0i5sTL04UFU4gTrY0JimZji+Swbfa6oInQ8G3D8Lm2XWnNFghyUHmh7KDop2rkZUjBXuK2pa0sU8+YlCSrQTL6Av5bulHqJX4CFc6xXFbbvEdXHk6x49owSU0l8SWlmn3KMMAXkMhJww=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Sep 2025 07:42:34 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:

> 
> 
> On 9/5/25 01:47, Andrew Morton wrote:
> > On Thu,  4 Sep 2025 11:33:24 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:
> > 
> >>> With zswap using zsmalloc directly, there are no more in-tree users of
> >>> this code. Remove it.
> >>>
> >>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> >>
> >> Per the previous discussions, this gets a *NACK* from my side. There is
> >> hardly anything _technical_ preventing new in-tree users of zpool API.
> >> zpool API is neutral and well-defined, I don’t see *any* good reason for
> >> it to be phased out.
> > 
> > Well, we have the zpool code and we know it works.  If a later need for
> > the zpool layer is demonstrated then we can unremove the code at that
> > time.
> 
> The whole patchset [1] depends on zpool, with the whole intention to use 
> it on the Rust side.
> 
> [1] https://lkml.org/lkml/2025/8/23/232

Well, that puts a Rust wrapper around zpool.  But what user-visible
benefit does it (or shall it) enable?

