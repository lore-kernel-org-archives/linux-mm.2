Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9730CD4F25
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 07:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2C86B0005; Sun, 17 May 2026 03:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E640E6B0088; Sun, 17 May 2026 03:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D795B6B008C; Sun, 17 May 2026 03:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C28566B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 03:59:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3418DA04DF
	for <linux-mm@kvack.org>; Sun, 17 May 2026 07:59:47 +0000 (UTC)
X-FDA: 84776162814.22.3AC12DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 81AFA180003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 07:59:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6eKltdV;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779004785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RJR3cLtBQBrz95yrmm73uMgmKYQ2zm1HMvHfO/79A4Y=;
	b=ynvtjoKUE9G5RLxh0wXgbBfQ6zC9q382PO3xus9h1MF2TZOSHD7mAmNgpmgnPV++U0AP0B
	qy/3X1VmTBUGHzo4gf7R2i2qJWG6mTcnX7C9Yn8Dcsv5mDNnWWnf6mZyxs71f2rOuGO8Jm
	2yu4J4mhxpWXXV1PG3X08rBxGR3MGjQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6eKltdV;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779004785; a=rsa-sha256;
	cv=none;
	b=q7WaPkON6ZkukUeTxU7oevHHtSBruald3i4oDn+vWrrF+TjES87vquXi8pTgCTglr3uthq
	qcQmlO8XX6S5REPJvCQmiDkCgbRwpJ7jZTZIJbptNg0l0UYU4Vnbh99B6yutG2sRNEJxD8
	IpY7zx63G6ILGzOrNRTv2ZgRxU5nDLg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66BBC40B7A;
	Sun, 17 May 2026 07:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC854C2BCB0;
	Sun, 17 May 2026 07:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779004784;
	bh=+tpOB4cCHIhZwEMPfsD8khe4UWH8UaIc/EI0bo2TbNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q6eKltdVAcaWb/ZioFDq5zVOhh5NZttHzOTVH9LIOmv9vOHxdg2rqFovnn/aV6NYY
	 1oS6E/uvIb1ggIjoJMaWgatL37vQo1V80ZXXfxzXbbZa5FOZQ0fIIhzMOF7598wXoC
	 9rztgRcunOrRTRxFDoQqHXWjRDNU9pAmF4/Ta1kyP/QRLc7EYW3kW3K+LS4A/VOT2A
	 tCjlIwjZx4BlQxpd34TrI3z1nMEj1dRjyp6ogs7seKwEs5vxf5nQJ+Cet+CxujjMEk
	 ezJou4Q/8ga5hfwLqwBBfUpp829kG9jJpQtiTMlk+jrtvSU4YNtt7zOlKetwmP1uTA
	 XG6NtEqIkjA/w==
Date: Sun, 17 May 2026 08:59:37 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Sakurai Shun <ssh1326@icloud.com>
Cc: SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] design: fix typos in design.rst
Message-ID: <agl1WwiSVH0Nynb0@lucifer>
References: <20260517073433.3015-1-ssh1326@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517073433.3015-1-ssh1326@icloud.com>
X-Stat-Signature: dsx13s7k8zdokgp7xjsxx9r1uejmq45p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81AFA180003
X-Rspam-User: 
X-HE-Tag: 1779004785-551513
X-HE-Meta: U2FsdGVkX18OR3EYoMJ4xkXUdX5JPdltf46dVsljeN4iWpHhOcEDkaaJyJ2Dj/3jeL3kfsod23EucBMMg19skflY8IetcryHPLukFfMqmt2eaU6I0Tx3FqDyIKSNE0jQBDGa23u7bUKU3oJoHQ6T5VcbME2qmd7sX1fXOQNV0GAU04mLvHKG0eip6pIAIV/+4LILGTS1Af6HkCTaOajVVH658PBxiOBjA0PGKWqPNFwZAoGzf1BY0YhpvD80+dHCzZ1f5yAzxI1LYqTVisTe8f4vQbqQTYfhWTXCGffwfPFYCmWZoPTl78VlI3vhS04yvRCEwYH2BXIYU6QnesiNaF+5fC4B1IswBxlFsAHaDps+yQxvKFZR8ljwQ63PTJ9AUPSfYhSWfeG8VOIx7CjpH8MakqAVpBciN00qdqd0Mj1dhO/31zC/7MrY3jqb+utsXupnCDnIvGZtmnxLq3eJ6QXC6VFTi5nnT6/amHRpzuk0adOzDPILkYZ/pmBggMmIX65NGiISiX6GTdUn0hJzX0K6MzPZjfa3m2Fe9rIpLxVxdajmvrbzutW7jZAb0qDUVu7VjdobC5qGwo1A/U4tDBmzrN1nkHGN23NUUOcyY/XWMDueLR6qDTCh62bK8wwQcbjY7IWyfzDOM3DfIFS2BbXexG0PUg2HjYy+x44GFFn97BD//LQcHhL14/Pi/K8lyKvDDv2wlLxMI0O7ulpUA52hYfpLpUe+Sz6Mvc2DpPrxVY4BdXoPvspzlX7VDshgIogr0JEYmNuVxvo54npYtzm+G3/Y2FvTC6YntIu/qLuJL3LKYWfLvh/lRCWVXv+yRVQBzEAkaOLuS2xsQcnk2zll7qpSGSdBkOnq/APLjyxAPr7PtLVtqjHjQ9oCT5IV44HIMzUnIRcwAclT1trtlx9Y+OgYfqBHD6jRcpKk2oaoHBY4O7EGx5Mk0PkK8BqTZxqIV7GZijBTNeMztba
 SmRZ02i5
 rT/FNqStXx2PM53ZWY/9LL1n9zHRNuO8OOZyvfnaf8kh0vi/yuP0A07UA/jpYkULlqTPUS7syIHxzpBkcyBoKj3NssR5ZlPkBvJnDhqX2t3ckFDzlTvYOC1hT023E3+edt5rXNJebPRDC2dLZLVCyYvb7adRzYrddksvpBff8j/VBEKSqqceKHR61vrBFsF3AbOb03ozaxYtBKT4vQqLTA7I2pRW+ViDnX+rDT0So6JY8aJX4OdxfD4oy7sibBUkwLECr+nBUzP3l92RQ1HW2icMsEcdv5fAeVxSeLyVof9mcLjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 04:34:26PM +0900, Sakurai Shun wrote:
> L140: "unsinged" -> "unsigned"
> L371: "sampleing" -> "sampling"
> L387: "multipled" -> "multiplied"
>
> Signed-off-by: Sakurai Shun <ssh1326@icloud.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  Documentation/mm/damon/design.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index afc7d52bd..9cc70a296 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -140,7 +140,7 @@ as Idle page tracking does.
>  Address Unit
>  ------------
>
> -DAMON core layer uses ``unsinged long`` type for monitoring target address
> +DAMON core layer uses ``unsigned long`` type for monitoring target address
>  ranges.  In some cases, the address space for a given operations set could be
>  too large to be handled with the type.  ARM (32-bit) with large physical
>  address extension is an example.  For such cases, a per-operations set
> @@ -371,7 +371,7 @@ with theoretical maximum ``nr_accesses``, which can be calculated as
>  ``aggregation interval / sampling interval``.
>
>  The mechanism calculates the ratio of access events for ``aggrs`` aggregations,
> -and increases or decrease the ``sampleing interval`` and ``aggregation
> +and increases or decrease the ``sampling interval`` and ``aggregation
>  interval`` in same ratio, if the observed access ratio is lower or higher than
>  the target, respectively.  The ratio of the intervals change is decided in
>  proportion to the distance between current samples ratio and the target ratio.
> @@ -387,7 +387,7 @@ The tuning is turned off by default, and need to be set explicitly by the user.
>  As a rule of thumbs and the Parreto principle, 4% access samples ratio target
>  is recommended.  Note that Parreto principle (80/20 rule) has applied twice.
>  That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
> -to capture 64% (80% multipled by 80%) real access events (outcomes).
> +to capture 64% (80% multiplied by 80%) real access events (outcomes).
>
>  To know how user-space can use this feature via :ref:`DAMON sysfs interface
>  <sysfs_interface>`, refer to :ref:`intervals_goal
> --
> 2.54.0
>

