Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02649606EE95
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QObvdsVt
Received: by kanga.kvack.org (Postfix)
	id 273BC6B05B4; Fri,  6 Nov 2026 09:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24B6F6B05BB; Fri,  6 Nov 2026 09:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160EA6B05BC; Fri,  6 Nov 2026 09:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA6FB6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:00:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 009A2120D50
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:00:17 +0000 (UTC)
X-FDA: 85404853716.03.AAB9BBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 48DF98000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:00:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QObvdsVt;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973616;
	b=xQ6Fwjj+iHB3+EEM5jgeoj83lg4SfHbNaJwiefydadoMhoqgs80YCLRRL13h4Bi33h/Umm
	EzYW0GCK3uE3WeKmZTDw5dhzSxrLuNVX9n/c4V+u4SzCa1nzlewv6hiL/PpSaBQiYI3IG2
	iy6P6VhLEf3rV6L7VypaE78jNpFn+YE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QObvdsVt;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fOGWC1IPehrdOpwQpZifjsY9NFnCljgxd1K1pEMnZg=;
	b=YdrRLVxj88T3Yp5rMxbBIRhoTHLIa/wxvDlMhYmPcm6dKKJO5XXhhlIzNdQsCgz5iubASV
	61C1U+IQZbH8i40BCAQBWrZCL/IBATRCy0PfH/Wmh+AZhjHkhZxRxGpkaMu3OrKstKHi+Z
	x6yCCfmhBCyAQ71SpNjyVsL8gQHuz7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC91060D10;
	Fri,  6 Nov 2026 14:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ACC1F0092B;
	Fri,  6 Nov 2026 14:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793973615;
	bh=1fOGWC1IPehrdOpwQpZifjsY9NFnCljgxd1K1pEMnZg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QObvdsVt4xv2Z2LNG6wWV9G6lIhzCjq7z+tSbzgeeVD40bRud7E+LlP7hmhsuuQdo
	 7ZMsPtp01uPj2zRWLrYMb0RF59k854JniltM9xrwDGEY6A/w2twm5x/HTnEZpAHcSx
	 bzxKlfvWLRXMh//Ro5f1OW73m8Xu6SW0sSzCKAErLfrOx5XL69bcL+snwbZVIHQNJw
	 pUhfItMWGGgrnzcnk+JxzxtetRHIsaaVEhWr/86nYQjkvnVDzTnptnH2B5+YpeN6uV
	 4rmdXz3lHU95VdYQQsBUxl3jygP8bjqQXM3bNGTyKRa/LLoVSKA64VZ+0R2egbZCDX
	 F1Hl2jGKuedZA==
From: David Hildenbrand <david@kernel.org>
To: hughd@google.com, Hungyu Lin <dennylin0707@gmail.com>
Cc: david@kernel.org, baolin.wang@linux.alibaba.com, 
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261105055619.58289-1-dennylin0707@gmail.com>
References: <20261105055619.58289-1-dennylin0707@gmail.com>
Subject: Re: [PATCH v2] shmem: skip empty unmap ranges when punching holes
Message-Id: <179397361279.3706.12765582085126746884.b4-ty@b4>
Date: Fri, 06 Nov 2026 15:00:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48DF98000A
X-Stat-Signature: 7xx5pm7yr3i99zqc7anxd54u7cgeqq57
X-Rspam-User: 
X-HE-Tag: 1793973616-760359
X-HE-Meta: U2FsdGVkX1+KtYVQysEh4F6QVoUphpPbm/p8SjG0DSNKmfmegp+MsMJSwNRXqAXAKSIP/zN2kjgDiitYAKSU4eju7FqXrSduRY/HrFrY1ksK2HxOKt9Y7pzDTocCcgYrYrmtjVc9b9wdmMHkc2mfr61MaAPuhZdiBYnFrFr27paGffpkHYX5s1EdbswiYxp0dWAYZTPoDRZ1cB90OyEQDSp/x4p5Mt7pJ57rBK0Xzk7dnf5xakiP6WQKy7CGDvgny/UcQ8lFY3JQm4WlaIUeeg47V+Ox2G+oOVDq6FC3InWABKdDg0EqtkgFTWINk0Iv3W1Sq+1KQUgXRlgopU8KmyeXm7qrgrs2kkPJM7zkgfl2xChXXmRDumNKN9mMiJ/YEcLqg6ZHfUEOITgEzzFmqoCBtV8/W6PaUREEpgqX/yxPw49UMfLAITm/4tkjSFJSsqrLs7qQpX2PBI/KCxn/YHw2Qzk5vHYLLY/DcaCtT2ZcQPoQKBiiYyDvZ75Lekj6JuTRtRXhq2PawaSWUjuyy0DmlYC/ddnEnjWtZEQl/gfKFk8owiWcgLi38rk5yjtMqLTcIkHSaQNN0jm4QRbtv0sxTXteK1OxKa3BsA6xt814lygmxdO6ZIknsUMBDpsf0Yk7Cp1ciL/VqnidflCuCmqk7NqzilxvwttLCbwKpN5OQLMXp22wVseuGEz/S6r2kZjxzYhh6nihnsexxjKKnpVEiMKHLWV77aGlLSmjc5/Umij0RPQlRmnL28ZP2IawnSenNj/CCV1qO5kGXGBwx5YN410X0oWBWy8HA5VPefmdw6fR6l8wf16x8N4FEZL+3Z0+b77SmQN/rONxHYEL2fJuQVRz3NXwEfXmDzpeXKa0ESL1j0aFxLwT1wQ/p9MnVksI1ZIIvYN2DBMuyoFk9xgEhdg1VHBMHRbAuJGYbsGoVepiupOJz1li52sxPUjkszXfKDhNqH4bDTOCIt0
 avdb40TI
 T3RmW+quUZ0mVhzxOBgzqVVmZv0YtF8vCcVaZYT1cF6U4bZUwrJutJeCwOFuNw6lShJL4Xqq5kC2dQymlTW2vFw/QEUYLcSXPOhW9M6oKRtzcR8RypvTdsk+I+yC6mEZ5yfx5y9msfalk4HQ+H+Rjj3dCrCoziUIQWFpZ0OS4DRuQhEwie05nqD779JqygD8wUDa07m93aO9RGS7+VKpjXcoGSax0nQHySkZrZCPVkpYo8UE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 05:56:19 +0000, Hungyu Lin wrote:
> When a hole ends before the first page boundary, shmem_fallocate()
> calculates unmap_end as -1. Casting it to u64 makes the range check
> succeed even though the hole contains no complete pages.
> 
> For example, punching one byte at offset zero calls unmap_mapping_range()
> with a zero length, which means unmap to the end of the file. The file
> contents are preserved outside the hole, but unrelated mappings are
> removed and must fault back in. This can be reproduced with fallocate -p
> -o 0 -l 1 on a mapped tmpfs file.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: shmem-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] shmem: skip empty unmap ranges when punching holes
      https://git.kernel.org/mm/core/c/bf87d3fe

-- 
Cheers,

David


