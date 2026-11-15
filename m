Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66637606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o14Y6b2Q
Received: by kanga.kvack.org (Postfix)
	id 2293A6B05B3; Sun, 15 Nov 2026 11:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3D66B05B5; Sun, 15 Nov 2026 11:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07AC96B05B6; Sun, 15 Nov 2026 11:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7FBC6B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:47:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3ED98160378
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:28 +0000 (UTC)
X-FDA: 85437934176.12.AE476F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A12FC180004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o14Y6b2Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794761246;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaQ+3+gjg+yVetwd9gdp35L3ayYUWY+kWeFCChOhk68=;
	b=oDLbmgZR3sLzF6sVt/MotMP5ebyKoIxiTjvmBRRYwT4N5R39Iq/mbScPkQ2op4WgnxTCjn
	PalpxL4z6VQIgpCcFfU9R4XZRUaG4yPHhuUL5cnclQIUp64JfMBvVXZ1j4RI479osG+nc4
	4qCLUfQibhgWlLkaWjVW7QIDPVFBNJI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o14Y6b2Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794761246;
	b=evrdRY+VmxRvIZOMjY5o+IPwqJA5UXnBobqy8k87YEYKIDRLgfhpcUUPoMdhje1ibeTyDi
	bYTBDl278Ryz0tHiVE92oXY1BTS4MJasd9h8rcLiR5sPJZvDrVlx9e+dLZg7xBxnLvi8r1
	/es4DMO3FYKJKR0sQQl070pWqnRy+r8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 466076185A;
	Sun, 15 Nov 2026 16:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969821F000C4;
	Sun, 15 Nov 2026 16:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794761246;
	bh=EaQ+3+gjg+yVetwd9gdp35L3ayYUWY+kWeFCChOhk68=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=o14Y6b2QnsUMOjBd6MxDHkI/imqVyElHaHUr/jydjoNtfYTOXHN0W2PTZ/R54YAJI
	 lbVm1AWUzbi9QKzJB5Rs0Ohb7/D35Ge7Ai1ILban28QqVHWvxYAmkGKA+MdCxn+N8g
	 d0cfI3eUNejh6EMRcP8EscFAaxV+KuvLlZNeyFr/5jTo7pCIS9GONzWQzfh/07e9Pc
	 WGIN+LXqsChYuo2Gh4PDGAjmr2OES09dddG2hy359lk6Ldy2g3+nELZ9ozTzno0GoH
	 zZCWcWrg02R6dgN3lP2cgsTJl9t/ys8rEdDW8H7gfQk5g28HBU+Dl2AdXQta4HCYST
	 jgwv5vear3qdg==
Message-ID: <sashiko-outbox-215657@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/vma: restore VMA iterator on full-range merge
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org
Cc: linux-mm@kvack.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de
In-Reply-To: <20261115004655564ix3vefI54RZ3HhYOmxuKX@zte.com.cn>
References: <20261115004655564ix3vefI54RZ3HhYOmxuKX@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 16:47:25 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A12FC180004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mijwjm6jtmhz1ir8fcxydfq3smfi8uk7
X-HE-Tag: 1794761246-77029
X-HE-Meta: U2FsdGVkX19+9TMaGNfGlstT9bmqJuY/VF/ATlSdWcqHd3PkNYcBtkmS65Mry28X+uBdb5pIYTtNrRWLLssnylk6QtKdVh6EI1zi7JI5yDoQVF6BuydkB8pIQajgc2ci0DRpvnXM8gdablFUOEReH6xmzpYo5Vh+iJOnIFYgHW+Hbyyy/FskPs8NP+8LAA+1s/NFnwD5AWH+L9savlEkuyDP882JdaZA9F4Gb3Ay87l5JBs3ITH63jTvEhbiKjfxyLIEMIvGBXMK5+uWVAV0q2v6wFpfaS8RMT7mY5cChvakKRkbgq0N6AB6gas2CdUeUlGLhlCyf1iedPHcKr3xfFQtSYpTVx6p3xhpd/dQtYvjwH+Erpjt94okIquJ7HR895RtbsQIkl1AEMKEeizjDiFJwdYDCTGlXj8lWI2RrbwFqPzGt0d93IoDUGSHDfkGydOLSBtY1BndDZE/qQciDWjZwxqb1BBj7BrelQFjG2STmfzOj/cagMa0Yiz7RXLaFFd2Rk0zO5SAiBALBb+rLyNkbJNsZ4SCCidted3M9VO1SQrjhjmRCaEPaj70n/mttTWDE5K1ItDZ075O8DHJ8JAK8U9g6uehR8FtDLmLFsM+tkiFYLdPeDNlqOXVvgv6YwWrjXuHEhZkB1rLIQGbvlXtBNj42y4l8Ak+zk1nzZ19mAlWPbZVrK7Z1wDLQh9+SrCDXOqmPGNnjW+LsmqnfL2uXYJTVzP8BWytDJSidhoiI2f953AYRacuuNJBxMZki9T9Kr5/6Z1u2YHDFD3+IuQqh9YDvOc1EI8iv9nTTJYeUfC7+QRjxOQYrfl8HFhg0HubRsmJsBzOvXxJcvRB6iQ7jkispFYWyszEavTY+UagKxy/WWsCnaOvaK8qhs7CaJodWEl4Q3e+K0TOt6MtpPlWHQyU6n5XLhANWPcLnOu5COhpto3+pshf+LpD4cZvoXGfyO2lUgPnrC4lzKU
 d7Jdm80f
 X2cjgAfoinhZRcR87WEzlPs/ht5fk8YoZw3c6r8z8p6zs0YLIbD+YYY2qu3bvqPaJK33E0x+RfxK+hbjtaqrzEcIi1qEOs/HdAnmFn0ljWYsSFCx681aciGhZJdY5pjOuHOIDhHmALHDb0vR2BxcfnWuext7MjBt301T6K1hyrPgMK9xPowMcPgAOLe0Y44xRLpyxUPBXytwEEnVUTTJVha4L0x7LENZxqhUE+RZyHv7MCvCIvqtajq5ZGK/YJvSvMTmYHCxPCMf1KVm7ZESG6MvBlppOmizJPkY0+j8cs1y0aNB488NQAU8Sjx758aUknJGO7f48RL7j0IBo4i1QGd1W+MAM7liIjfib0G4XrQCZl1hjWoYMaaLh7YUmNoMnuTFPpdABYolJyz7Hiipa183wYhOiPsFVf9EdLRWibZApVUqWxwQgWm/oLgVEaFVtm0NIp7E6LK2TlhorbMxJIZ41AqYNIt3EhdDmuux2PuoU26Ht4IIvgPmvRW/jyXPgvRgv0Hq1U0XZ0EPipr3XLzn0ZxbUO2vcGwH2nVW+gIBgC46gDt7wpcklSaRp28mRxU6xaYgz2AcLR0mOz6ZiJjqua5Aoa0Vi10u2/3FkMndAKN3KxbsuAqHrSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/vma: duplicated subject line in commit message body
--

commit 53321f02a2e2d093a67d34a87521909e373ff074
Author: Shao Mingyin <shao.mingyin@zte.com.cn>

> mm/vma: restore VMA iterator on full-range merge failure
>
> mm/vma: restore VMA iterator on full-range merge failure
>
> vma_merge_existing_range() moves the iterator to the previous VMA when
> merging to the left. If the range spans the whole middle VMA and a
> vm_ops->close() hook prevents removing it, the function returns without
> restoring the iterator.
>
> An mprotect() walk can then visit the middle VMA again. Restore the
> iterator to the range start, as the abort path already does. Extend the
> existing close-hook merge test to check the iterator after this failure.
> No crash or data corruption has been observed in this case.
>
> Fixes: 01c373e9a5ce2 ("mm: rework vm_ops->close() handling on VMA merge")
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

[Severity: Low]
This isn't a bug, but the commit subject line is repeated at the start of
the commit message body.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115004655564ix=
3vefI54RZ3HhYOmxuKX@zte.com.cn?part=3D1

