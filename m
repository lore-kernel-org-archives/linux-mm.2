Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13C8EFCE20
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6B76B0005; Wed,  4 Mar 2026 12:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1640D6B0088; Wed,  4 Mar 2026 12:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A296B0089; Wed,  4 Mar 2026 12:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F12A96B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:37:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 867155790E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:37:43 +0000 (UTC)
X-FDA: 84509088006.05.A2963A1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id B8ED31A0014
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:37:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=caze7pYF
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772645861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuyCsr5o+JidLSWRw/91AGUcrNTLFhdmWYvBwfnlct0=;
	b=CjW7+oH8AKbpl+nC9ooW5LlS2ILJrEHml3SRMmgwi4sOu+yVmBFqRYfLqgmp/RW1Iy4OWp
	tY6eIVInfEm85A4GHmoKm70vfBqpFCMJNntk42b2W3RzNUOybpI6edU28SXzghmjnPiE/b
	b4RFJ3JHy2iePXvipvZhMUke5mrnAOc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=caze7pYF;
	spf=none (imf19.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772645861; a=rsa-sha256;
	cv=none;
	b=FKKyBujpxzloDcnnQC3pFKV/qupNfj4I306iRFYKNmGYkQiet35u/3DFoTP5v3/NRLOUWW
	QISaOgYv9XX2BiGFugOb1wPV/ZnX/gzeiyqOnKMHh8QHDEzLrAE8n8VF7GovAV7mKm2Fh/
	653caC5pxyuOmr0JSCKJ2w/u+Ie+5c0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uuyCsr5o+JidLSWRw/91AGUcrNTLFhdmWYvBwfnlct0=; b=caze7pYFvcyVMiEYXzYpXuTAXQ
	tdP41ORKTes8QS0ud/mQoCbt/xBsvN79xXVvRHWv7XyfbPUVrV9zRVSNIZCJzkbnKdWbsgC/oyxK7
	RSZ73r181y7XF1WFFjBfNnWtVli1OZ0Rkg8Lh6HH8IG3spYaENh+j2UCmHzm5iXRddOKKXLAR7bY2
	0lDo3psav2Ty0zNVYaDnfjSgZdeQWxLjWDClJobF0JueVolpH48n2l1f460wqCYYK+riGdDVqlK2y
	Axv2+7D3yHkzAMQ31ly7/393EV5Bnsh1tR4GolA0TsX6PFuWptCebIbnLuvG/3/PQKhR6OaWzPRLj
	Cp7X3V2Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vxqA6-00G7Tn-Ka; Wed, 04 Mar 2026 17:37:30 +0000
Date: Wed, 4 Mar 2026 09:37:25 -0800
From: Breno Leitao <leitao@debian.org>
To: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <aahtwTffVysT9IXP@gmail.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: B8ED31A0014
X-Rspamd-Server: rspam08
X-Stat-Signature: 5uduj4s94g9np35dqniarqq8zjan7s8h
X-HE-Tag: 1772645861-997949
X-HE-Meta: U2FsdGVkX1871SBsNjKyYy0R45Ge9cMnLi1f+szXqr1jxL0V7s4EU1gtcccNL7uF6HNvRjd9fnoE4cmNToR9TeCNZJD4o9SjI6Ak0l7dx2wCV+d7jX8DFsRHALhWdJ7/37lqKMbXBQGdFeEGPqpI6qbSZ7OkvwKecXkawryDMPXUqxiYL8yUMBu08lUxHPY9ZbKOSgTsfm9RMQPaYtTG8u/8AQ6P3YOk1KhIdoe8WrwXvmGkNS9sTKQCc3TW4Ey5nHxeUWc0ho4gsp6dvG5fHjVInRJSnUBmkNCI6mZSTLXkmsM6r6NeHfp7oyB37EauLP2XyHiLVo7wgyck2eh7hdiKCqn5Mj8lJ2YDpbJKAc2GWFzwQyJYt7AcLGJGbc94iuQHN/f/Gf/dDbo8HN6vt261t1buMRC1f8YXMmVcxHQHzJRwB50sU8LvPCgUws0KMOTarEBKKcPi52QG4K0o60hSP7GhgOnx8pvgbWiB2GRZDqxnXaVckBEUVz3xQpAnNGm479utyEXwMNEV9AkEW6yylzT54rbggDMRugiXV+SqBm4GMYM+e15GAFcbULuPbsCko8vyFBJbshdHTLjxXgKja+/7ZCOUeX3nY3Go1CGH48NddQvzBA7duSBQhYz6wH4so0yF9Yu/wWvRHYFyY2LM49eg3KgoqjtpVO2FAiWsKWsatT4Hv1u78Q6EHvUg179B6KWkPuPYAuvGn7qZnSgDnW8fthJPXCArabe6zDURa5Nmw+Yz/FagUic2fz+tFmSbhbIgasGSsq/tiYaMOMfUpTnhqVUwG72rmDG0CLwyOydbOnQZTVrWitObj91xSLnIhBn+1cXnFjOiCI64k4C9yLAdCXwvcAqOXCaatboi0MEmvI4QAZhJH+761taNSxBFAWmP21NeVFOgcLJLaiwcBpyo+eifJ0m3mNVNwLDAtB+6QCGy7CbLg65yWxWgEiUX7fif/d1bqYPZNjV
 XqQSukgH
 08ogh2DjD+WR8lKFbxjFi7/76twdeHhWogaT0lq7XojKqaBDxEHDl/seaS5qxV0FhTqUBK0og+MRM38JarWyS+2s1vltMPjcA423pZTJJHjQYb+I/3ZlteoxzTNEcjgt77s9PiQLoNJOAmDgI2p+Cw3e/M1r7ve4/uucgjWjHaw5HOtx8MIbPTpnl2vDwA6LskzFvSIwDz8vdFfQK9yAUgYzzalOIIK/aKadLHZyA9spvxZZKVL3hNP4Q7QzCgoCCpCz5lncgZ73AHojnD5hgmCNyOWP5ZIXC6AZqP1hqImbClb6yGqcw+a2q5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:37:51PM -0800, Piotr Jaroszynski wrote:
> contpte_ptep_set_access_flags() compared the gathered ptep_get() value
> against the requested entry to detect no-ops. ptep_get() ORs AF/dirty
> from all sub-PTEs in the CONT block, so a dirty sibling can make the
> target appear already-dirty. When the gathered value matches entry, the
> function returns 0 even though the target sub-PTE still has PTE_RDONLY
> set in hardware.
> 
> For CPU page-table walks this is benign: with FEAT_HAFDBS the hardware
> may set AF/dirty on any sub-PTE and the CPU TLB treats the gathered
> result as authoritative for the entire range. But an SMMU without HTTU
> (or with HA/HD disabled in CD.TCR) evaluates each descriptor
> individually and will keep raising F_PERMISSION on the unchanged target
> sub-PTE, causing an infinite fault loop.
> 
> Gathering can therefore cause false no-ops when only a sibling has been
> updated:
>  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
>  - read faults:  target still lacks PTE_AF
> 
> Fix by checking all sub-PTEs' access flags individually (not via the
> gathered view) before returning no-op, and use the raw target PTE for
> the write-bit unfold decision. The access-flag mask matches the one
> used by __ptep_set_access_flags().
> 
> Per Arm ARM (DDI 0487) D8.7.1 ("The Contiguous bit"), any sub-PTE in a CONT
> range may become the effective cached translation and software must
> maintain consistent attributes across the range.
> 
> Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
> 
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Breno Leitao <leitao@debian.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>

Tested-by: Breno Leitao <leitao@debian.org>

