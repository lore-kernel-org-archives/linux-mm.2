Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6BDC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EAB6B0096; Wed,  2 Sep 2026 13:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E4D6B0099; Wed,  2 Sep 2026 13:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34D06B009B; Wed,  2 Sep 2026 13:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 927656B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:23:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2199280306
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:23:35 +0000 (UTC)
X-FDA: 85169493990.16.688C5E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68BBB18000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:23:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SQ/e64IL";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788369813;
	b=F1G4mT63fnumnec2TRWUVMgaXoIEO8Iaq8NIi17OrphP5er+a9ezdqjvisvCM4aDRGO18h
	EppPb1kwpGs5bbhUUzigdVStgX3+XLScGVZSt62MhpqCCfdYbvtha01TSvrgVXKVqTaXmw
	ZlA9lOwqYmS//WpHK1Cm6c1cPxbCeK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788369813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XmNQ6WKBMzr8oIBSZDnJlW7h+ZrhoZOuFj83Jzmbsfo=;
	b=2IHveD0KR+MkcaRjRR8M/0kD7zigL5ZNX3tAovtq/1h2WIXwPK7KqJteVMD3NwrIK31END
	0cFC9EXa2UEe6yrgCXWDZdH8n7hd2S5mCYyDO8RnEqqxYaBxZzru9z0Tz5yfNZuaa1dwyt
	JHDhbTwlPIHfiqdvlxzR9km7yEfk638=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SQ/e64IL";
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86113433B7;
	Wed,  2 Sep 2026 17:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B05C1F00A3A;
	Wed,  2 Sep 2026 17:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369812;
	bh=XmNQ6WKBMzr8oIBSZDnJlW7h+ZrhoZOuFj83Jzmbsfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SQ/e64ILDN1pnMgED8ssh6q9/0rLdHgxDHqnOBlzw92WYCiWJaT5cTvF+TPGYNpsX
	 MX3S60psaFTPn+grPZ3LvrWhFEpGNfvppk5aC/ydk2gk7hv3FHidWSHch5Tghbqtnt
	 BLiitH1a1HWIYSaP7P14oDJzjpjM2XT6PYZw4KxZrFOErwOxMcfQxwIQk56lhejnjk
	 qv0z3nBoKeZH/L4lNhlM/6jirLe1WCUqP2JogwSOPRgGzo3aYZq8Nas0eyO455mxcs
	 jJv1M6Zjvwe/9CiiQzd8B8PuXrz3OsZgV0HQNShSz7a8MGhj6HQElRLPKoLifUjQH1
	 rGVz9fCVKnzcQ==
Date: Wed, 2 Sep 2026 20:23:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] arm64: Allocate .text and .init.text together
Message-ID: <aphbiuSzIrM6vhJt@kernel.org>
References: <20260822135323.795946-11-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 68BBB18000C
X-Stat-Signature: njwn5xgnngt4b1otuiewwfnd55beksx9
X-HE-Tag: 1788369813-172624
X-HE-Meta: U2FsdGVkX1+7PjOi+aGEPoy9KoVy7xik0Ru6abp0fnDJzDO45GSWlHln4Mv1WODmSH1n7QPr33ZHUJMb84ZA1Dd+rY2BK/w1PPM3FNc+2djhEqE+PqjqC8QUAd0R1G9oO6NThNaix4jSzXPoKlna4DvPTdPnyUWiQlzHVoeh6d39QEqu2ijrjCGxudmJAHIIKfxs77DtjjPN/XCZPVEZF92QWCDk2qXeIWo7B8l9RJgxnkD2MGJE5vr2XPqZDId27zFD12Mu20rT4PtZ/sHJODA9/bqtC/Tt5wVe72nj6UnRQCK/b3mSz38ejATGaUrkcSsR/IwePjFwlQZ2XSgbUua7Su6qRheMqr5PDg6jRN2nbiHgo75FF/R+5EJjBEfXwDCpZ4u5wPQgCbTF4UtZrYsacXuj6QXzVTUj1yY9QBjmCmlya5Hiyq+aZMfLDr/EkH9ZfH95hxS9XSiXYOVcX8zIMSA0Dkbz0pdd4KbSBbptdv7/eKp8GwvIe4g3vv2g27ys8QvdGSu/luPYu8d4Yg3vpaCWE5LTMNoLZOwo9YV/UBhtEeqmN/qh37gE/Y/nA7LjggM009qowTN8rV+gNzit/dmh7oml1dLCGV7c2R156hhaVIZCnwzDZuHUwD4m/uLt5e2tTsyfIKSDIQJS2NEjb8NC4LKCOC6f0Gj9J8FhKt3Bm23OUqq8n6W2q03QfQO85UgeBTUFqakMz5z/ZGFe71TyP/+4h+/LRPQSEwu7NUVI2AsLQx2bCCrzwXmOSre5P5FxUBvmsjzaXxUC6YzrlSTnpAiYKLx6JmMz7ny1otTcDBljPcDNHoWpRg/P60hQwj5B5wxkVuoOFqsja+vhMOupn0zxg/gEtKesviDapLsR3Ys7p8tRUmEx7qgbnN+ZCjHWSdi8zIdywDmlNsmacONhtXocT8MO+As4Cq8oPbe53s7m6PQ/9x0pWlrr0XfLK1S4PhjLx0NCD8N
 6LsA625W
 F3/3C9wV+nLc4Z795Y0JCJP+i5jVIxKqS7e0WZ76XPqtxevDr5RLfqP3pAQ4qm5zPL4MUFRg1gpa8DFXjSS6WufnMr7/zPqWSJ8cJNyJnxRx/Osj1lXPd5uG9Z8ZSgNErY2iUMcefW18vAaC1Uuo9vW/0Pu6x849gv+sex0NCdBkzZnYGmECo/sagyUkhiTqpoUy+DQC4kN118pcXBMtUCKBhFGz6t06fiS66pORJWj5ScN1n0dbEE+hj+8gm6SnMuE8MI3NfwvTlo+v/ZZolBwWoupAcMqNlwbmgSIdzwK34ct/qtM5RtWzfebpdXEyZTiLuPoa5n0saRaHgBzpv8KvY3rRXcAaQDIG5PL/yfz5EihOyLe5uWGwoIdg4ouMZ6huAeDkmp7uJwv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ard,

On Sat, Aug 22, 2026 at 03:53:22PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The arm64 module loader has to deal with a couple of corner cases that
> may occur when .init.text is placed out of direct branch range of .text:
> 
> - ordinary direct branches from .init.text into .text may require the
>   use of a PLT entry (i.e., a trampoline aka veneer), which means not
>   only that additional PLT entries need to be allocated for
>   cross-section calls, but also that .init.text needs its own PLT
>   reservation, as the one in .text will be out of range as well;
> 
> - dynamic patching of the ftrace handler into .init.text code needs its
>   own dedicated trampoline as the one in .text may be too far away.
> 
> - recent compilers may omit BTI veneers for static functions that never
>   have their address taken, and so additional veneers will need to be
>   added to .text in case cross-section direct branches from .init.text 
>   require a PLT entry (and therefore a landing pad at the target end).
> 
> This is unfortunate, because it is actually somewhat unusual for .text
> and .init.text to be so far away from each other: only when allocating
> either of them (but not both) exhausts the 'near' (PLT-less) module
> region, the other will be allocated from the spillover region, which is
> not in direct branching range, and therefore requires PLT entries for
> cross-section calls.
> 
> This series addresses this wart by allocating both of them as a single
> chunk, and freeing the .init.text part along with the other init
> sections at the appropriate time. This ensures that the two regions will
> never require veneers for cross-section calls, allowing the arm64 module
> loader to be simplified.
> 
> Ard Biesheuvel (9):
>   mm: execmem: Add API to split an existing execmem cache allocation
>   mm: execmem: Allow huge vmappings to be avoided for execmem caches
>   module: Place MOD_TEXT before MOD_INIT_TEXT in enumeration
>   module: Allocate MOD_INIT_TEXT from the MOD_TEXT ROX allocation
>   arm64: mm: Permit permissions changes on huge vmappings
>   arm64: Enable the execmem ROX cache for module text
>   arm64: ftrace: Revert "fix unreachable PLT for ftrace_caller ..."
>   arm64: module: Combine init and core PLT entries again
>   arm64: ftrace: Simplify PLT handling

I can't say I like the idea of tying the single chunk allocation of
modules .text and .init.text to the ROX cache.

The goal of the cache is to have executable code mapped at higher page
table levels. Letting it use base-page mappings completely dismisses it.

I'm not against having execmem_split() or something along these lines, but
it should work without the ROX cache as well.

Another question I had is did you consider splitting the area on free
rather than on alloc?

In this case it could be execmem_shrink() that immediately frees the
.init.text part.
 
>  arch/arm64/Kconfig                  |  1 +
>  arch/arm64/include/asm/module.h     |  2 -
>  arch/arm64/include/asm/module.lds.h |  3 -
>  arch/arm64/kernel/ftrace.c          | 13 +---
>  arch/arm64/kernel/module-plts.c     | 63 +++++---------------
>  arch/arm64/kernel/module.c          | 20 +------
>  arch/arm64/mm/init.c                | 19 +++++-
>  arch/arm64/mm/pageattr.c            | 13 +++-
>  include/linux/execmem.h             | 11 ++++
>  include/linux/module.h              |  4 +-
>  kernel/module/main.c                | 22 +++++--
>  mm/execmem.c                        | 47 ++++++++++++++-
>  12 files changed, 124 insertions(+), 94 deletions(-)
> 
> -- 
> 2.55.0.860.g4b6b3295ed-goog
> 

-- 
Sincerely yours,
Mike.

