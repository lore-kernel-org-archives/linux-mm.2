Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCBF5CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4675B8E0002; Thu, 13 Nov 2025 14:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EBE8E0008; Thu, 13 Nov 2025 14:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381BE8E0002; Thu, 13 Nov 2025 14:14:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 253538E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:14:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8392160B44
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:14:03 +0000 (UTC)
X-FDA: 84106533966.01.E3BC76D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 071554001A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:14:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cfBzblaG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763061242; a=rsa-sha256;
	cv=none;
	b=MX73nlOhOujE7rlrmxbMFWVchdfTv+ZgMUKDkUzUk19awoolH+dUzLWkn+22vH/sNGoBaA
	f/aFKFPYT4XvqBhlA7XFa6YnY3KLc3vzofhYc2P7YSfbaib+pV1vfsSaGRXB7HwUMY8gxr
	jR1Bu25aOLC0Py0zo6+6xSpcDQJ+KGE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cfBzblaG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763061242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaTEp5BQ9pTidqO67nAhCgBofDJQ3nltfXA82PxDSB0=;
	b=j6HRH5IgrUjq0hLdc7Rftx8hEqbTbWvxT3EGgzST8H0Y4F/jbc9yXTUfuL/DGbI487qEhv
	gKy9KoKxu0/+YScnjKIKimQLZggWLx0oTqlGrjv6jIhg/LDdHk7kq0vhRzY/1hDph+U6bb
	WD7c6Dp88tVJ+KZhSu8s5u6YXVjrR1M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB1D844591;
	Thu, 13 Nov 2025 19:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FAFC113D0;
	Thu, 13 Nov 2025 19:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763061240;
	bh=jTWDk+BqohV3m4pXD2Ea/Pvbdh3J2t6AMrMnl8XqWNM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cfBzblaGV5hhZbOf+DAbxa0lXzHi4wNDeV83e/hMffLKgQ9aQzRt5eagWi2nPqVig
	 +OgYRY0az8+Cx1dALXALokHuXG9h4Ac0KocHu2f2aOFrh5JfP5kb5N2PGQ+jWRkgFZ
	 sQO5P/6ZVQGgc0tbu/wiJi2+KByxtaQcvyCHWokq7luXvunk4iaagmEBd7E/dILMJ7
	 O0OEDG02xpXqVoTVHxOJWhrQ1iUwv/awNcNmXnToyD9TD2PPENLItvCkEQZon2ybcL
	 cBey4qKmDoPGH+bX/4ZC4EIlu/PFZnOgoYOFnwFZ672IwX+pcaSSfkBElCf46zNrZt
	 56xqzpPXgEojg==
Message-ID: <7cfd85f6-54e9-42df-8330-d81fbe441ca5@kernel.org>
Date: Thu, 13 Nov 2025 20:13:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/22] riscv: Memory type control for platforms with
 physical memory aliases
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Andy Whitcroft <apw@canonical.com>,
 Dwaipayan Ray <dwaipayanray1@gmail.com>, Joe Perches <joe@perches.com>,
 Julia Lawall <Julia.Lawall@inria.fr>, Lukas Bulwahn
 <lukas.bulwahn@gmail.com>, Nicolas Palix <nicolas.palix@imag.fr>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 071554001A
X-Stat-Signature: 35ufsg7boass1jg1zgn3y7xw9e6fyrn1
X-Rspam-User: 
X-HE-Tag: 1763061241-182754
X-HE-Meta: U2FsdGVkX19GnQaSxBZQiyyp5VjQekmem2D+GvYlS7Ew3epCQyOVrvCBclCZ1jsjnxnrFBsuxmRN3KJFF5eULyUyGx5ru84lKR4jaaqkx8a1jyIR6gMl431n6CML/hx1w0tbHwcL+Z8zKBLSyQ61p/hAzUlh7VB/y/GoqBRyOi8xb91MotIZVavOxZZ3FVrk2FXCMIEeXE6wYQfOk+HxmozW49XKYzpGuDKVpqr1j0VG+LL2uoBVJlqxt2kNVqa0selGezXJXCcoekB7thagOQ4USx6JzdR3yhqFtE1ciWxjpGjep/2CRAD+7MzKb94Cjym/IxNK3jE/wN0vaq/8AZ6eZPLfxSIW9CNfUVsTd2ECReOCS8kUN+tEKZCY0ES1Efki9a0G3fB0Csn0uuSC9JvueJVbrzu0dQN7Ki3o17I2XYG+LX4CiDwLFqPRZRtfiwE5uaB8qJDAMu8of94Yg+t+s9pH74fkYnt2U5ngTqe0naUX0wzBH4N0zPMqmRa4/iSKq9gpjlW8VFAyl8Owtxf2N24jv+iT+jbIYkyMj6CEom7/iZk/aX3uWHvK0lrWjG6L/eTTaMJFelmXKnIz1mRonF0yROcXchW9YfKk8xCKpBdO/KWF8osmHyzFYxFmSAJL5JRf2aOGWs9RJTLpEeQzONrAxbir0UV+cOT0PzNDQIUKX2MbrOOct18YoGIarigpU3Da4VeIuscDR0PlVTqppa9aM86Kn98RABqm6+cklQtxIzwSx/hXPtirmnJNamRWRA3KuKA81svN54tc3zVA2OFh7EP4qqYAEi9xovesP5SeFrI8upOg8YkRmxT8igc7q0D1sm0d/2lrbA1SglHO5Llr7wOsmm9utZr+dL9WpmoZJEup4kKMfirjpFiqFmkIJcPGc7Ww+G05jUJ/dEva7HAUGPI2PDkng6nvzjmjvQtm+Db992AjUs97L3QD918Z/zmZTrYoC/37f3a
 tuAZlKlj
 gv5xvQ+QDZf6TDuK4KMtG6mrQ8Jk08IAuJDD5e/M6n/1onKJiaCxZXGtVQyM5rWGRrYHfJ0EXN60uT9QwaxZk9Vsfx9PqEVK9Xu7NjHeAC+Ji9zLEvdUhqTON2bfBd32xynrWzrISluvYsDFw9ZTGxQQ9QmPeknpFSKXzc+koMAUisyDMOU6gQPPuQ5ePtQKXeNArKZLqTfsrhc/1XEvcY0rQ999WkuUbMvHPNVrzZF1JXKe8tmkRKs5PY/tseDbpbnw8ZCvLyDOkKSBcmdUh0fcOTv3tsLQpx92GfXGi5YPsI2CqUe8YAEHktxVlVIw8RdtXbUoUi65aW8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 02:45, Samuel Holland wrote:
> 
> On some RISC-V platforms, including StarFive JH7100 and ESWIN EIC7700,
> DRAM is mapped to multiple physical address ranges, with each alias
> having a different set of statically-determined Physical Memory
> Attributes (PMAs), such as cacheability. Software can alter the PMAs for
> a page by selecting a PFN from the corresponding physical address range.
> On these platforms, this is the only way to allocate noncached memory
> for use with noncoherent DMA.
> 
> These physical memory aliases are only visible to architecture code.
> Generic MM code only ever sees the primary (cacheable) alias. The major
> change from v1 of this series is that I was asked to move the hooks from
> pfn_pXX()/pXX_pfn() to set_pXX()/pXXp_get().
> 
>   - Patches 1-10 ensure that architecture-specific code that hooks page
>     table reads and writes is always called, and the calls are balanced.

It is not immediately clear to me from the description why that is 
required. Can you summarize the core problem here, and why we have to 
route everything through these accessors?

-- 
Cheers

David

