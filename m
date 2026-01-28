Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0863FD25926
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 10:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37B846B0088; Wed, 28 Jan 2026 05:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328BD6B0089; Wed, 28 Jan 2026 05:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F226B008A; Wed, 28 Jan 2026 05:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 135BF6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 05:53:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A19D4C2104
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 10:53:20 +0000 (UTC)
X-FDA: 84381060960.29.115843B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D35161C000B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 10:53:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RNCd+Ar6;
	spf=pass (imf18.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769597599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1Q1gjTAMSr78kq1GD3EYQaxBf+IpZa3xRAbO/84QXM=;
	b=U6VNSGQC6HSw0zTKvuUAuQ7JFGgc1+bKliW7pVG+veYHlnht8IUSh0qXyzUoPIuTL7X6zY
	NXuO8PD7Cya7swxsQdJMckjD9HBLCP6q2b5vy9BJKNIEUuB4Lt2VdcJqijHwTp1C2B6s8B
	Pa16drGw1tpnuXC+KCDbW5ETOXEJn6E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RNCd+Ar6;
	spf=pass (imf18.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769597599; a=rsa-sha256;
	cv=none;
	b=sU5tT7K4Mw8/go+DWuykdxz71up2iMfXn77zHuZptPSceh4UxfJUWBfoCl5fcCtZpjqbKo
	alGwFN+pQk2obytqlzOq3mZdncwY2v+exQL1D3d98B2sEA0LhFWCgdDfj/6PTfcZs7FDR5
	LB//IzeBPg3qYgQpi81CbMuZu76GTEk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91D8C43825;
	Wed, 28 Jan 2026 10:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A198DC4CEF1;
	Wed, 28 Jan 2026 10:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769597597;
	bh=9cvvWqn6RvV89j9ZIztNLp7qBP4F2Cc+7vQe8RcHs3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RNCd+Ar6dXNAG4OWk9/O36amq/5do9ACEt2HKAM8BdQsetHdQUMcHZTj84CcYuFDC
	 ZFkj+XEuAKJrR3ZbJYnqFxiEcRwCI67JFzdzq+cUufot/LY8Kc3C78ckOi9IZeoo7O
	 ppHEI7ql9YjS3NNi8TzDyoIy9ZOiGwY4aroCR7ZLIQXgFdvLsRFJaaUBj1d9zTW6cZ
	 QYaimaWr6ouxjXB/LDaP0e7wWr++04Unsl2LSbtiizwdp1oSUUSmiG7v1xIvYtMOtU
	 t6R3WX00NcRjYdnOw2UFu46VNP6MnlQ3S57g8W1aJGzV36fVlM0UMa/IIQuywn0EBh
	 8piOB8gBjj5SA==
Date: Wed, 28 Jan 2026 10:53:11 +0000
From: Mark Brown <broonie@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2 22/29] maple_tree: Use maple copy node for
 mas_wr_rebalance() operation
Message-ID: <ce123a4f-c35b-465e-bef1-30a86274316c@sirena.org.uk>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
 <20260121164526.2093265-23-Liam.Howlett@oracle.com>
 <bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vdXwsf6dfN4/jY48"
Content-Disposition: inline
In-Reply-To: <bd1c3356-11a1-4d0b-bf58-47eb21bfd24d@sirena.org.uk>
X-Cookie: I brake for chezlogs!
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D35161C000B
X-Stat-Signature: iheht4neukjrhamo31ombzaf6jmj4ez9
X-Rspam-User: 
X-HE-Tag: 1769597598-530240
X-HE-Meta: U2FsdGVkX1/9nJpFSXUBbsqmK2cod6H/6R/AU2WO0jShlPFGhuBfvt1ZaWiSbcpWFIuyGOEvddlcTxeO7f7ny73nGCM8Scu2Sd5IRwHxJXqpnbUv4LDDqmfdIggQz+L1hQTcLoenXmZ8AXcjx/+iW+pkjNGjfhbTA4ls2PWBnjiSmgcRHZaxjvPLG3O+P7D1H4kB02SRGY4dpVguzw8Ia6SYZnjlbXcODcIgHBeKFqGvnP/HeXZii5yVl7BQv0IzGhSKo9worUULUFiX2Sky32fBVbNJ//oIkjgCQXyEVp4qJ8kDXKuYgoncKuIt6c2eMheAL3cl5LFMm6pI26FwmP+fKZMSu3LY5VKXAi2X4A/5lkuGc7BVXnAKniKt/47y3HLPc8xQssJ1EPQfjJWKbvkOzTtKwWvznMKXewQ0KjMKisT4dYAQI6RkLtIFQIH8i1+Jd1Qvin0E6hLV/NhI9tdxwbCTSCeVkFxvcmkPRfwZVi/zdTsDjjPPw8uc5C5i8cMxSfdD4m7CHo8W65yBPA0O4lyMEc4RWDRKCoMYl3VrEstHWzMwFfkp0/hM3Y8Y3bPERfTP1RMmm7ZODrWT0hB2UkNuC69Q0nO5QwwPVBZGiHAoO2tI/3a1ishb494mRir4ocy0piyQfaGNdHcV6hO9COn75uWnMMiErIrMGYfq2E6dVBEC10pRKAXWz1jRk+8VSBWBR75GwVkR50k5C1b9P8Mc3mjpQpdyiotDLZBhUAnNdF2oGqWzyVUjwCzDvw7fHrza+jCH6/oQfD7VnPX2ox4xo9u2OgOhvYCJ90LZ8zJHiA90nDFS+oJQMYPhhuEeCT7RVUV+xrHfKf0pWvWygHYO5pUcwJAoIUOGv2yoLg4Htqvdztos7d/UMWUTbT3tuC9WrGMN+WTzu6XLbNAe0kwocFeoHN7auZfXMXHMUnxYOa/gD7VMAUHDP2aSRHJ/hCvm92r/Xi333dz
 K4SwHPrf
 CSepZdJwqQu2WdvXk6mpndzFKq31V/NbkEBvn6va1Ik+WRoLr20tO5j8HvtPRj1o24HVjjKFbqoh1lV6HVAQiKQLuZqQ7PrC+JEM6zXITSslgbwPHUvwUBFJ4Li68dl08HOOXLPolBlTXN1Q+IEzOOQaTQX1/wG2netEzKhE6fI8DhUxJy81NGYI7s53lDjXkaZ9ebp/M9jzG0cBXCobykgPl/KIyXtu7yFVqW2RVFACq0m4jpAQ6RGgSqMukNZpCzA5/W9b8KlmHZflEw6wp8ZF/tWlqZkoSrXf7pVSTNnDQyeep2HsmIoI2qMPyEhK6NrOLO8pFzb0RF1j/rqmyXhImB1jJdH3U5k/uqJqWjZOyRPLIBEfx4AIjN7IWs6VMdNhzfzHLxcKewrt0X/JQeAMQd+MXDw9i3/K85rXmX6/VwhB+kChD4i2ca6YaD/A5FSmzwCcjvZOJY6+mu3gdzzicMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--vdXwsf6dfN4/jY48
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 27, 2026 at 11:05:54PM +0000, Mark Brown wrote:
> On Wed, Jan 21, 2026 at 11:45:19AM -0500, Liam R. Howlett wrote:

> > Stop using the maple big node for rebalance operations by changing to
> > more align with spanning store.  The rebalance operation needs its own
> > data calculation in rebalance_data().

> > In the event of too much data, the rebalance tries to push the data
> > using push_data_sib().  If there is insufficient data, the rebalance
> > operation will rebalance against a sibling (found with rebalance_sib()).

> These appear to bisect to this commit, there were some issues with the
> setup of the bisect which fortunately don't seem to have confused things
> and some timeouts stopped the last couple of jobs completing but we've
> got adjacent commits showing passes and fails and of the two candidates
> the other is a refactoring that doesn't look at all plausible.  I'm
> rerunning a clean bisect but expect it to confirm this result.

Confirmed:

git bisect start
# status: waiting for both good and bad commits
# bad: [615aad0f61e0c7a898184a394dc895c610100d4f] Add linux-next specific files for 20260126
git bisect bad 615aad0f61e0c7a898184a394dc895c610100d4f
# status: waiting for good commit(s), bad commit known
# good: [50814c5ce8d8f6751fd49c818abeb8853f8be2df] Merge branch 'for-linux-next-fixes' of https://gitlab.freedesktop.org/drm/misc/kernel.git
git bisect good 50814c5ce8d8f6751fd49c818abeb8853f8be2df
# bad: [b047f48069330e050431e9ad762bd838af43337f] Merge branch 'mtd/next' of https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git
git bisect bad b047f48069330e050431e9ad762bd838af43337f
# bad: [75fe66db9e85a2fd9743f7598a2aaea9eb5fbfd7] Merge branch 'xtensa-for-next' of https://github.com/jcmvbkbc/linux-xtensa.git
git bisect bad 75fe66db9e85a2fd9743f7598a2aaea9eb5fbfd7
# bad: [0578997f52fb9a1b9adfc5fe5a95ceab4bb331d2] Merge branch 'soc_fsl' of https://git.kernel.org/pub/scm/linux/kernel/git/chleroy/linux.git
git bisect bad 0578997f52fb9a1b9adfc5fe5a95ceab4bb331d2
# bad: [a85886367078a64dcffefe0ccd9054f6237b791a] Merge branch 'mm-unstable' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect bad a85886367078a64dcffefe0ccd9054f6237b791a
# good: [3b545d6116fcf6d257bf2d50e7607351fdc81b76] mm/memory: add tree limit to free_pgtables()
git bisect good 3b545d6116fcf6d257bf2d50e7607351fdc81b76
# good: [8d2b3ef6f7d7b0a531c4c733224583af946a424b] maple_tree: inline mas_wr_spanning_rebalance()
git bisect good 8d2b3ef6f7d7b0a531c4c733224583af946a424b
# good: [b75bed193d677f6ae26df8851f4d5546fb7d3599] tsacct: skip all kernel threads
git bisect good b75bed193d677f6ae26df8851f4d5546fb7d3599
# good: [4aededd81f86a8090ea8c294071425aa12116ef8] Merge branch 'pin-init-next' of https://github.com/Rust-for-Linux/linux.git
git bisect good 4aededd81f86a8090ea8c294071425aa12116ef8
# good: [201b27d852d1aecf3abce28721c6004ec2690b8d] Merge branch 'mm-nonmm-stable' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
git bisect good 201b27d852d1aecf3abce28721c6004ec2690b8d
# bad: [7bc25a7aa0443b3beb3610e505d3147eece02766] maple_tree: add cp_converged() helper
git bisect bad 7bc25a7aa0443b3beb3610e505d3147eece02766
# good: [a2c17a4f4db66772701547fc30f66d1df2fceafb] maple_tree: add cp_is_new_root() helper
git bisect good a2c17a4f4db66772701547fc30f66d1df2fceafb
# bad: [525e5511c009c0d6725e534134ec31eeba148da0] maple_tree: add copy_tree_location() helper
git bisect bad 525e5511c009c0d6725e534134ec31eeba148da0
# bad: [6ad069085c621d39fad4d1835af7e563975dcf7e] maple_tree: use maple copy node for mas_wr_rebalance() operation
git bisect bad 6ad069085c621d39fad4d1835af7e563975dcf7e
# first bad commit: [6ad069085c621d39fad4d1835af7e563975dcf7e] maple_tree: use maple copy node for mas_wr_rebalance() operation

--vdXwsf6dfN4/jY48
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAml56pcACgkQJNaLcl1U
h9DuTQf9ErubPOWlV6UekuK5rhs3JhBsjYLmHSo3ApHKa/FxXpRfe/7+/87Wk6J6
Fj1u1dRvMCcybazn+BMBdR9vZ4BHRMPyqS8oJUtvib+faslkI3AbgdnXChdMIOWw
BpqOvUPXr3AucjTspqD/LSwZ0T+mBemV5njosFnofGo1Hy4R6SyDCu0/nZkL6zm4
o0K7v7LNDFzazZoGszVP3NuXAFQ7Wv49Y5bol369STWoMvrNVLm1mdp4TiQMNsXy
ot5vKT7YEJnj7V6jA/N3I7j2Nz9R6FcAJ9l/FyXu6pygwWmLPVu3DaoyQFUqKyal
jpjMFArS04to7thfIiBGEJGU8NRZ8g==
=qm9z
-----END PGP SIGNATURE-----

--vdXwsf6dfN4/jY48--

