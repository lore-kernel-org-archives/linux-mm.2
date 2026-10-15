Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D75ECC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36D266B0092; Thu, 15 Oct 2026 04:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31DE16B009E; Thu, 15 Oct 2026 04:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234956B00A0; Thu, 15 Oct 2026 04:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA0C66B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:47:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53AFC160500
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:47:06 +0000 (UTC)
X-FDA: 85324230852.30.1E3C991
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AFE25140002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:47:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BXCBlFad;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792054024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elvLOcXxsxZQm3B+49mhsU5uRRi4AnsUZlTgJPkyVjI=;
	b=wliKGxMHwOdi6BwynmWkHheiylqu9HJUowIqvU+7BkTZcXpI0+tZvUHgIV/pv0mHas8Okr
	IbILzEI69h4AJmEt7dYpIWMGnwQNhh51TLtsPul+NYKRfdtYT2Jp1SS3YbiezRLAgTwuD/
	kXwrn3LxI7HEMz6qXVlzf20qj3s9RKA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792054024;
	b=eSdUso1ba6pRtWGgZUP7VJP8wsToFTigqeLUEETIttIUXCjbzG348zUipzqjrZbM+BQjOy
	Lkr7AP+lEPMBM/9DQn8CxW73UYtNMLTURxKcKsvsJvPHDtdP8TzoL9DRaFdKu6awrUgNLL
	IJxk32jaGwBAWGlkKgfqgHv6no48Z8A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BXCBlFad;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D84FB4099D;
	Thu, 15 Oct 2026 08:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651291F000C4;
	Thu, 15 Oct 2026 08:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792054023;
	bh=elvLOcXxsxZQm3B+49mhsU5uRRi4AnsUZlTgJPkyVjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BXCBlFadEq+BdhGNZE2UmC3WNfmGRwkHtvrfNKO/If9E+yZYWyS4OiKSNe2A7IBRh
	 3g3/O0MUBDdp9lI1z9H7LrkfRQClqBdq6+LYruC4jQtTgocdm11beL/I9r70U4282x
	 4matRiDIeTf9hY0rwuBEcWxDL1WQDknwDZAjAazcPVNlYU37S+q2x6FI1t0rv6S+WC
	 xbHks1rDiG59lFEypzYSgbMarg5xIzpjpUvbn+6Fy9RrVvKUhe7rhxmtGxMRGxP5Uq
	 R5xxT81RE1o+KFKzFvm5DmuSTEEmjiTfgpuN37dwAVyPyBrh2vaITKn+tdVpse2Lh/
	 cqN4lsut7adlw==
Date: Thu, 15 Oct 2026 09:46:56 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, ackerleytng@google.com, akpm@linux-foundation.org, 
	chriscli@google.com, hannes@cmpxchg.org, harry@kernel.org, jack@suse.cz, 
	liam@infradead.org, muchun.song@linux.dev, shakeelb@meta.com, sj@kernel.org, 
	ziy@nvidia.com, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: Sashiko change proposal
Message-ID: <atCS1g0PdE_6NErl@gremlin>
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AFE25140002
X-Stat-Signature: c6makf1gu7m7dh1mfb1z3gtxc7a98uj1
X-HE-Tag: 1792054024-179711
X-HE-Meta: U2FsdGVkX1+bOaFgRNCs3uKu+1Tj8H3kn0EGDRXRiaou0rWNBPZ1z1oO7U9lHxrjJgT/Tls2YJujodSheFpQZKqFEhV4GHThaZvVi4RW45bpn0zrYRkqkgnqSOMEtV0TO08eH+Qy3lCR4Td9qIhglqKlCwR2+XX5sampB9wWgEH9PNW8fECbaU98X5S+h9YpmJroO9i+TSHwXCIzN+HuAksWjEfMikvAHTFmVTUGrChmOYZhCFcWjhXzslXT/P2h4n/duqndRSh1SKbUdbc0zcZn8rjfuGZ+wlRbIOQexQrhTQfIuX/OsnkNEVEY4NR2R8AoLNDJ5LOZmUZIa9UgkbAmW/A3pD+fwpEhxGBTsswG7WO1MkHyg199NLUBE+SNT1aRHJiFjKFCuRWc5Nkh83Xisl7NCBxkyBNuQc+Y3djhIZESG9dQBns6Ahv2I9CRwHXBv4paCPU+FX/cDhXFLLBjRszQWBkbCMRrY1YPNbo/tRGY6pFba+D3ptTeI8V5FuHLrsNGiW//g0qIal1CY1uoBteuZ6xyvq6NhseYbQpMJ93fIkmfESCEUHvXxgI+BnTxyvk4GfYnumx8ILcyp8/PmeGiSFa391gJzuaSuc+UjHuVHTHnBlWHZH6ueTVMuH3pYz/K7xe1ShPhFImKlagJkCc9kz0SMbbAMqlOikI5QxT3Q32l6W679uu/V86ee7ELrZpSELAyQMoYIfkZSFX1apslu3Ujg4mru1samcEEKYo+aV8ZK75EsfLRyh5qX4oCvj0UW7QD8hkdDVC1sdifU7tO+E15lWhhlLp7yYcqhdqwCPh3SBWMaRWHGX/hNPQUYEqf5hhR91NLObpfdHj9QscmwALPQ31QPY+avunSL8oKVoL6FVqPm0VjJ5U1z9yCJxMBX8qRB294ohC2wlJKMMWMKOGJLZjT8zvRqmK/QkxMOQIIIz8EoonrP4pnaNdC1RQF5oyA/fEpCex
 wXz5m2cc
 0k1Njsj0h8RgkAW39b0cQ1912Y0xXZeD/CsYuNbK21Gk0iQ1Qgz3UyadZHXcYVSsbfSSQr8EIgoV1vQ29NuEsbP+VRWSqPTwglYgmDMFdyOpfOcS86xF01Xi+W9E6x4UjyDRS1wX/L6VMgZXmJqcSYmYT61qR+4lSpXSClinokVxskZPOwdy3kFozYN23mmLx4xlBwYzOYtCACJCXylrZIRZy+ykcnTYfdj6/TQfb12t4rMFsueuG1KVNkCZ3cEXC91KQNCzZkHv8hw0QOaGZvkjNlKHb06cXNRSEfmsUoNW5d1V0L0ab/nQNC/Xr/V5a23cLrBJ/+6f9G6v8KdEtjtnAZeFITJopEwzAhJ2X79eDUBHCAXVjNNZ+FzP4ENAkacFQQsU0H9jFUCi95RWN0N7KlVcX2x6jbnywImeMv47nMo9q8kLZpcXx2VDV/+3p13n3pmGI3jWnDQIkRayrQz+Y9HmZguSZqaKGqjhjFTsAajXlMEZLTnNydQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 10:38:14AM +0200, David Hildenbrand (Arm) wrote:
> (CCing all people attending the mm-next call)
>
> Hi,
>
> After talking to Roman at MS, he just informed me that sashiko now has a new
> feature combination:
> - "embargo_hours": hours before review is public + emails sent
> - Mechanism for signed-in maintainers to lift embargo immediately
>
> That solves the key issue I had with sashiko: people/agents re-spinning stuff
> too fast before a human at least had the chance to jump in first.
>
> I suggest the following sashiko change for linux-mm:
>
> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
> index a9198de..ba123da 100644
> --- a/projects/linux/mailing_lists.toml
> +++ b/projects/linux/mailing_lists.toml
> @@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
>  ["linux-integrity@vger.kernel.org"]
>  ["linux-kernel@vger.kernel.org"]
>  ["linux-kselftest@vger.kernel.org"]
> -["linux-mm@kvack.org"]
>  ["linux-nvme@lists.infradead.org"]
>  ["linux-omap@vger.kernel.org"]
>  ["linux-pm@vger.kernel.org"]
> @@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]
>
>  ["fsverity@lists.linux.dev"]
>  reply_to = ["author", "list", "recipients"]
> +
> +["linux-mm@kvack.org"]
> +reply_to = ["author", "list", "recipients"]
> +embargo_hours = 24
>
>
> Which means:
> - Embargo 24h
> - Mails sent to everybody (author, list, CC list)
> - No positive-review ("looks great") mails (default)
> - No other static email addresses that receive a copy (default)
> - No additional ignored author email addresses (default)
>
> I'd say we start with 24h and see how it goes.
>
> Thoughts?

Yes, no notes :)

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

