Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8B9606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cm4zYYJk
Received: by kanga.kvack.org (Postfix)
	id D1A436B05B5; Sat, 21 Nov 2026 08:02:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF23C6B05B6; Sat, 21 Nov 2026 08:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F9A6B05B7; Sat, 21 Nov 2026 08:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A41766B05B5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:02:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4365D140486
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:02:02 +0000 (UTC)
X-FDA: 85459138884.14.8624102
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A2E0B160015
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:02:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cm4zYYJk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795266120;
	b=GfJhcmyi1HdPvjFiaDJx46dhUNB1ToMF30vHCRpvpxXXam3bo2TVdnrPNPqrtbFvRDYpWx
	S1tlYDxmaNe1vdlvafAL87qjv/ro0cl/ur8wSxfph9CUe2wXVumGOvdyQJqV4b6cEmacOG
	B3c+H/IlMpnpH5Dq/5wGbDxYwqbqZ7k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795266120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gN74NZ4s008fGO70Y8YMhr74zbTWwZSYt3Tm98apf2Q=;
	b=jJd4XYOT2ql64I0VEgi0or0ajrdUdeHj5dYH+L1yqrv/zi2/1ZzYozwljr9yrlKx56vzNY
	5MEkVfy2Fx0lRBnef3o4zwgq0rcJlpY4fCykjFefZaX5miD39nkr1HKLffT3iMahuP18yD
	wxbEjQXmtqwN+hh+3/K0e52tZjTvbag=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cm4zYYJk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2918F618DE;
	Sat, 21 Nov 2026 13:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94961F000C6;
	Sat, 21 Nov 2026 13:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795266119;
	bh=gN74NZ4s008fGO70Y8YMhr74zbTWwZSYt3Tm98apf2Q=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=cm4zYYJkzEQNCsleAc4lr+XCjAKeMbJstFIDTJ65hV9aXuauSZu6TvxNCkzgsEuLk
	 FNbRbXCBkc1lTg5lcm0nW/9gyEzMKQPhrn9I1SIlVONLqZ20HG4qQFPjOTk0sQfqs2
	 B0Ds7eSnVtftKrFgRj1GLHZNgE7l9SxlmBKvkN8bcz7J8H95S3ouAl7lfgraZVOzNH
	 wmqEB8E5u3KYbp0kd51Qe5D6BepMYkq2mOXM2UQmCcTomNqKWTvlxybL+evoVLnfbz
	 vd7GXOkU1lPjSVNCsDodSX+W6A51LlAhWu2c8JbJgO5xLR/Jnrmo4aMQOkWbVuieoE
	 bwDS5+Hm7tSrw==
From: David Hildenbrand <david@kernel.org>
To: hughd@google.com, david@kernel.org, baolin.wang@linux.alibaba.com, 
 akpm@linux-foundation.org, qi.zheng@linux.dev, qinyuntan@linux.alibaba.com, 
 shakeel.butt@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
In-Reply-To: <20261120195057.50031-1-mason@kernel.org>
References: <20261120195057.50031-1-mason@kernel.org>
Subject: Re: [PATCH v2 0/1] mm/shmem: don't use the memcg of an uncharged
 folio
Message-Id: <179526611747.5902.12576936678713287811.b4-ty@b4>
Date: Sat, 21 Nov 2026 14:01:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2E0B160015
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: x66mjzwb971usizoqxad4mz9itnqbhh3
X-HE-Tag: 1795266120-532460
X-HE-Meta: U2FsdGVkX19gQFgBGtxjmRiCaTRLych1v3LapgCXVSoBlD6srlTnB18n997Mf2CIaFWX3HUoYTCCQ6HjfLrhVIQGxCT4fir3PdGX9JSvX7h3jPXZUJJ7R8sURPqcfa6pmv6LxAm5rdEi3jwaDWsrdAYJrl1LU0S+1gfMdIxH0/wTg+Xbqw+N1dEOBVDb7v7uq9vKHPd2FgW8+r0HD3nOVZmU1cvaT/nppsCLww4QVGJ2aaYxnQeZOqBAZn168BmFdLF2K/jaKByQwS1tffNTeWu9qWNU1TilXXvUJMXr2YsEKqFzLN69P313z/czbwzNoxKWbOQtpinK/l1p2wMBW6H6+swrEvIDqGwZf5CdCgIbNxrjaib4eWIIhWo3ZAbpFIocg3qzOLLUPhIeYZk++IeGjNAt5nLk6xY9Oo+Rje5EsXOY2LbBCXogo2tp9YvllS50gJM2FJDVZQ6BIfwaOn+pkNmOKIFXH8Ta255DOCJ2HM/hH/GxHJBB6AcX8r1hN4VQwu+gJlmyJ9kc+BDsNH4qKRQL1cRVNqhawzKLgzDHYOBd9T9bcIF6CEJjXISdaRxOQ4LRasUflRVW/MPxokx6ddjfXIQ+rwyxDu3a7JpXvl/Gs55jHRgRvSpprHjsFvEoLi+kjmygdjqEvRBT7s+p6TR9EzAUL4RQ9iANTiodq8OK70xlYkrvehf90WextA9TjyKtjps5xiDSqC+3WGKgYbfsVDc3I8Cq0vjLSpLzBFt2RPhx9ahd3WP7PM+yIlis8tXsb213ERu/99VOhosFBdXSHYhuDJDnN1QDT3+YTrybo7T5ocfOFHXaWJWAUiSu+7yojGFJtdJHOzPlo4Ds4SiJvNsZyotfqW0ycdZ0BJxeqUzsqWSi3ZS7+zQ5TR7QqbHCOaUiQotaP0lKoVA0iUSID1vZuxifiDRFD3Q3eDe24/KiBy5XOxUj+kD9QUxEs4uJuFyJOkf7ebN
 gdA7JMZh
 sfIhRa76C3+qmcHz1/WoL8h0y47hhFhOtDZkyA7UY8smE3daGt/BHaBxPkX34h1jqr/T8w3tVYGbTXbFwYtykEVcvrrwvy8YbKoVa4mC8Mu9P4IfkqkOknsp0BY0vpDUs4F9z+gdkQnSAYtvvw6kU2+QF6L78BjDHKJS133ghbMWqyu3qkqJ2C39j36m+780OdR4e4z3VrhjxOidePc14eRVmLmmIphykFJjostcRhW4ka1BzYv8au/F8VEuE0cwKclXczLMSUCFyXit5DrhmZ3SfcfkX9u8Rpl8TXGC5vRe8oSTBt9eESjBqy3KSBotdmQzC1FHdnXbUpRPiG7A3MMuKj7UUcqIl8QWvMpqQfnxg5vGk5s4WM5mzHYUQVWEoOUXHxqe8nagfD1UmHBjmd07wSUsOjZRe+TZj/lvaZK9UxkLME+Ehj2NY3dJvve4tKpk9rRx/DiaWhoWyUbqkSrpIrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 14:50:57 -0500, Chris Mason wrote:
> This is relatively niche, but actually new with 7.4-rc1, and I would
> expect it to trigger under heavy load with huge=always on tmpfs. We'd
> need to run out of room in the tmpfs or reclaim memory while huge folios
> are migrated.
> 
> Qinyun Tan's pending series fixes the oops:
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/shmem: don't use the memcg of an uncharged folio
      https://git.kernel.org/mm/core/c/eb01811c

-- 
Cheers,

David


