Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BE8606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jK0tcEmI
Received: by kanga.kvack.org (Postfix)
	id 933EE6B05B4; Tue, 10 Nov 2026 04:03:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B566B05B5; Tue, 10 Nov 2026 04:03:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8492D6B05B6; Tue, 10 Nov 2026 04:03:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658796B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:03:18 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 003DBA834A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:03:17 +0000 (UTC)
X-FDA: 85418620434.06.A041119
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 56FEEC0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:03:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jK0tcEmI;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794301396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UN7p19OyMGXLbamSH+wFhIULRO0LLyPQSfmopQ5zmR8=;
	b=RwK0RLrI51ohVENQ0x842p/OiTBHP2PGiJF6FknpQgjW+1pTu2oaGwIUKzhvwClAgW5dnC
	X4FsBjlFtz1HgttsyaZ51OLaPy+tKOW6GcfHX0tg2dYZZQ1xHcXZjuKPEgJx6aW4zCLSAJ
	o0GA47ylVSBZSe2vrrBmqlIpNV95z6w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794301396;
	b=IcOAZ99mlRFu2fdT0N1hdavgt9+6TdIH/OqDTbKxNhDfnsvBpydHQYV9bv0Wp4acGqi3Ol
	BYUGIr9cn4TjMQnh//3IJZcfkT62n/YD7Byzk0W1TWNCAWkesm2ShNm8LoveJGYSPOeRYC
	n9fYG0pXcEukMM5MLWbkoGclRs2UCvs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jK0tcEmI;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DC26455E9;
	Tue, 10 Nov 2026 09:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311FF1F0089F;
	Tue, 10 Nov 2026 09:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794301395;
	bh=UN7p19OyMGXLbamSH+wFhIULRO0LLyPQSfmopQ5zmR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jK0tcEmI6igUednx4vQE+N+S9Pt1y2MTZIPDnTORJ1w7u0Jp4RlT7h3iB2fs4pAm2
	 MDv82EhQ6mUJCZZEiCrSxh/5x44BchElAtu9KGvEOBGXZQf62MmVVdDztXpJUdVktd
	 W2txIj8pH43MoyVH0iKT4SoZ4memPQJteZyPXtd8p367EgCYI1Wd7NIW6M8KcNAJhz
	 pNOYo8iYoJUNQiDOdrK5Y3NO5xPK/juuel1NYPZV1E0xl/ACXjzmpxXtkRBhqP9NT4
	 vfGC+rakO6TDbUwCIKxqx7O1WhdxZOILv2zXGj18EQ0gpoF8b8sxo+3UomaKszNdtW
	 SBfRKIosVA6Tw==
Date: Tue, 10 Nov 2026 11:03:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: n3rd <18670333770@163.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
	ljs@kernel.org, akpm@linux-foundation.org, security@kernel.org
Subject: Re: [SECURITY] mm: mremap() merge silently disarms a userfaultfd VMA
Message-ID: <avLdzhUz2uUIEGkR@kernel.org>
References: <10acf436.5b2b.1a1c45e0bb8.Coremail.18670333770@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10acf436.5b2b.1a1c45e0bb8.Coremail.18670333770@163.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 6keudfgc9btna3w5nhdcso7zwfnodeta
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 56FEEC0009
X-Rspam-User: 
X-HE-Tag: 1794301396-632163
X-HE-Meta: U2FsdGVkX1+lMu+eCCjLrw0+UnzkrFqPvFV6VOtbOvfaZNSVuw30lgReLIC6hScDhzGn1qvetx5v2zdk6HkSkT7L3vA+4BEGXTj8YfPeYGdwkHi4YqW45cfHtRw5OpAFAfH1Nf46BM/AdGX717V0Mvk5hIjIC44GzwHgqTyxeE2aoVpgUxC+5XX+LffF0BbNifG4L6CXqpA2PnRTaiEd/Ry2Ek/3kaDMV3MGlhr0cD+Z8p/Y1C9Jovr5HwYUHvTGpTjuGctjGuwKQvGc32bx8M++8mq3vIVP4cyu7LZ/TiUDKnBK2mI2uL6RTVpszAUqQs8ELcbqoCBLgwHvzDmxYhxHs/dJPgQTp/hPulCQxa9CCV1fB6zCk7rTCMZ+YNpt/SurQGonoZy2qIF2oWmWEmLSFJjLlZYGbE6VI+TLH3CxTZ2wakmBAUtZ1NuUIVsscUuk6J/96ngB1ZxXpp34XNZswWiWYKpuk+dF2DhggXFZZG2DQPkSfNVSJGjQJYBZjIWZ84JrlZaywAF8mPCT1NC2NVQj2ZGu03C/XKL0Eo4T7Qu+AwqyiBomam6On39uesDMORFvQ/AhWlp9Z5/FnYTLdu6fPKWlRvEFWXPZM7GcJHoeAwLSDkxMPGIKvDAPkaDilN+SJQI08mU6Gfmi4eEcoPp56Z2XovC013rH2ogiNSTejhaNoCkwrrsov9sv7IJZglAgzcqKlIvcMqfYzVmSjP5ej+jFAHnrO+MDDw7HY/3wrGGxbzM1kyf3aytd4TNj1lUQUNygVoUqvxOuH0meZ+it8xnWPK4BZD46m4f/LjbqABo1wicuBktVJFINbB5xWXi4DVGzhPoWigMlM4ygnEd10SS4eZbz7B+E+5kr1vxcx4IwRE7ZOu7jNaaWleFeUe8vk3BYpczpfaGB5jqDoEA2Y8mhf7tVsifiQ6rFk8VpvdDkx5V3PLXXAQSsEZ98/XJ9CxlJ2oHOGwV
 3wfu7s1m
 JxY5S4qURwOUkiBBeAXz1vx01aBRpQcBo5flEV+zeA3r3mB1Y11xt+pZ5GAktfrN/kPi1J43mjtJRhENDfTlHZoyuWacuELCsfA4PJF/lbTTPPSquQUgtjUzpstYdheZqFlHn+ekB1/4qinAc4ZfT4rmo3ED1C0QtDi4Y/cIVMJ/1hKWHhZqwpveS+HaANmqoI7oVmvFLz2A19iqNSci1twJMANnsN8y1F5WnnCQPzQ4zgeH8UBkqIegEY+bk+7tVyVc8MfCT5j8awBQsNN6qAJEyouqcmlM6L7Jm844PP2ZLiEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Tue, Nov 10, 2026 at 03:31:00PM +0800, n3rd wrote:
> Hello,
> I am reporting a security bug in the Linux kernel.
> 1. Affected kernel versions
> Linux v7.3-rc7 (mainline, built and tested as 7.3.0-rc7 with KASAN) is
> affected and the issue was reproduced in two fresh QEMU boots plus a
> control boot on it.

...

> 6. Suggested fix
> mremap_userfaultfd_prep() must only drop the context of the range that
> was actually copied, not of a pre-existing VMA that absorbed it. Either
> have copy_vma() report whether it merged into a neighbour and, in that
> case, restrict or skip the reset, or refuse the merge in
> vma_merge_copied_range() when the neighbour is uffd-armed and the
> caller does not have UFFD_FEATURE_EVENT_REMAP. No upstream patch exists
> as of v7.3-rc7 and no patch is included in this report; one can be
> provided on request.

This was already reported [1] and fixed by commit 68cb098eadda ("mm/vma:
avoid broken uffd merge on mremap") that is in v7.4-rc1 and is tagged
for stable.

[1] https://lore.kernel.org/all/20261020110748.959870-1-shawnq1@163.com/

Please check the latest upstream before sending reports.

--
Sincerely yours,
Mike.

