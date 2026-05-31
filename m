Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD34CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 17:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBDB6B015F; Sun, 31 May 2026 13:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0937F6B0161; Sun, 31 May 2026 13:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F127C6B0162; Sun, 31 May 2026 13:10:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF4CE6B015F
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:10:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81BD7120209
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:10:28 +0000 (UTC)
X-FDA: 84828353736.11.35F076C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3424120008
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:10:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cd5xFtLc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780247426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLye1OeGSvGfRb8KDc6cQsEQJDuu8/tX64BsRlEPQ/8=;
	b=paNHc6CxxSl1+RMzip8MaQrKhD1qO5jKu9FVxcxh1o/d6vFz6rEMow/Lz8D2iULucTot6i
	ccFcw3moCPo5gGEuEYzvU7M4jd03+xuNm3cYiI+c3opLtoWeernK7hBclROawErxPEIUbE
	QFVs4LC9jtjCscy6ktYCcC4Kt26m938=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cd5xFtLc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780247426; a=rsa-sha256;
	cv=none;
	b=Ijx05kfJmfVn+n0gXtjUczPpmNJZwrE8bC1eTn6bi0xdciXpBL7Ev4Hxo5a0J/AVnwNGsN
	W/E5K89tvDw3JOu5nTqn2LZYsAPq7Tsy4voWfEEL/Kpx5pBvYsSwRAxY6TD+3K8jneMm1j
	Tc7Gule1pq6VSHCw9mwdyt+0993zJqc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67806601DE;
	Sun, 31 May 2026 17:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B131F00893;
	Sun, 31 May 2026 17:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780247426;
	bh=WLye1OeGSvGfRb8KDc6cQsEQJDuu8/tX64BsRlEPQ/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cd5xFtLc8CgSUAo5VbGm+pKIlSN5dodN7UW+f0GhB53myIoxNH6p+dDCuSowwLt1M
	 tn6pbkJrs6TvruipRFHl17aKPzkzwwClUW3OCw2kaVqtuO8SCeKbwrz+glC8UeZEHr
	 GtexD/nJZv5cqchIGk9LPD0u7HqxLjrc8lVMZ8tUA9w35qyh8ltsFucDy0MxNZ9tZU
	 d2U6RyTtMK1CdN+Cj8hhy00WNDZZe6O2rSmmW7KgtJNLz+pYi9BC6RF5u4rlYqXqdK
	 OLXNC8wRdf5z8eAJSKbI+sKv+ylMD/5luOBySRgN6a7aVGyuVCVVx7szWKIZv4EWX4
	 cUVPlWHqBfd5Q==
Date: Sun, 31 May 2026 20:10:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jork Loeser <jloeser@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, linux-mm@kvack.org,
	kexec@lists.infradead.org, "K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Baoquan He <bhe@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Justinien Bouron <jbouron@amazon.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Michael Kelley <mhklinux@outlook.com>
Subject: Re: [RFC PATCH 00/20] mshv: enable kexec with Hyper-V donated pages
 and partitions
Message-ID: <ahxrc4pTvVU20RTX@kernel.org>
References: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528004204.1484584-1-jloeser@linux.microsoft.com>
X-Stat-Signature: 7rkzz9usx4fdm8qrjm5mg4npdiky6gmx
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3424120008
X-Rspam-User: 
X-HE-Tag: 1780247426-431003
X-HE-Meta: U2FsdGVkX19vzm0t0JJ7riKUgh2RWxCTrn8lOjWXtvikHzfOR0gH3vrN/QGYpS0kxMHpQll8htVGTKEtdVjZyp+0iasgGsuD7VIkUxenvFSP/eyiv6XxHRM38K4l0Dso2VlCyDt0YVo1oC91i+9U14/xSsSfuFOUnyuHNZLMfCQhzDdfZ+VPkKcbDLHJhqF5k4kMFApdbSSuYpK/3tcn2NjA7iGIqlURtIqqVlLY/Yh8gk13PQch1lXX9M/iArjjwRdyKFVC0unIl+tdFTDWGv637WfcENVhgfjxk5zj5l3RFxNIqXJZR9+W3odjCAnRaFam08D2U/3Ep+su5AHSBbgsJyJH6u5bMhN3HuEZ09D2lhu2H/5dF2wSqz45hRk6zgkFNOPmAh9JZlOFjlGVxgoJ7/J3vyUBn2urdvbxu9R5Hre6Iw29A/WNCYwZUWHh2ijRRZzSakT/bdCtPsP41U7F6hioBhZswLbgQUHy6kpsjF3hkvyIGwz82GLl11UYtFbkZ5M6kCp4DcliiPpGv6aCF92Y9rfkGpWsE4QIU0cWlPW6uP10cr5cQfwYmbToFVrfSYKEUgNxrsjdwmkJFqQVdy7NOXmM0Mqcs+fguT2C6HcmYprmQ5jSMrLZzjOIYi7pRqldXYyIW0LAvrwfhm3D+aiQ9nKpCkdKOZP8rohF1wFignVAOzGjQGj9KHXTaEM1JVlmXRBQtLxS7A4bCLh53Fy0lfhmztV6kVeGowJjgL3582kUcZ5MQW1TPh2WZFwz9Mlt8HJFbSdlwPgTLohpTj4OyeGclHBI2SUWtV53F4Dn1tNMcqqlxhxsZeempfx5pesunJzy091mJzO8DtMHPO4qdxAp85ou7LSGvZraPx5nD7t+eh6vi2dbfJ/4ZJmhJJCJLP1kQINhmKeMRReoirZq0GAFFpXilg8XVUXaNIosvlaB/9d9IEFl6zNSpYeaPOOaAHFOnUzxl9v
 QSFU6sEm
 7KVoCDBxe6BtdqwYcaglOqVJiY28MIvVYzqtMTNiAR5IFjbjPBHqF28EsfhVvXbk6uQ8ZhZOA59UsYip7PZ3dGwz8xowJ9S4zeH1hEN0zTQYs43lNq+Yhsrj8pqwJlSa9MbvlSJtRAm4uBCsSTq+njJks/DQnr9mArqwSBAMJI6vigf2b01qM2OqsSnnq0EstvPFvLPz44PEROV6QEGRhSRMenXuQbNaXgSkhXnPc/XlhHRNI5z/J1wO2IUUjhv75o9XnoStiVTpqrDoZSCSt3YxKjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jork,

Only had time to skim through the patches.
I have a couple of high level questions for now.

On Wed, May 27, 2026 at 05:41:42PM -0700, Jork Loeser wrote:
> When Linux runs as an L1 Virtual Host (L1VH) under Hyper-V, the MSHV
> root partition driver deposits pages to the hypervisor and creates
> partitions for guest VMs. Prior patches enabled kexec for L1VH, but
> only when no partitions had been created and no memory had been donated.
> 
> This series lifts that limitation. It uses KHO (Kexec Handover) to:
> 
>  - Track all pages deposited to the hypervisor in a KHO radix tree
>    and preserve them across kexec so the new kernel knows which pages
>    are owned by the hypervisor.
> 
>  - Freeze running partitions before kexec, record their IDs in the
>    KHO FDT, and vacuum (tear down + reclaim memory) stale partitions
>    after kexec.
> 
>  - In case of a crash, exclude hypervisor-owned pages from crash
>    dump collection by passing the radix tree root PA via Hyper-V
>    crash MSR P2 to the crash kernel.
> 
> Dependency on Pratyush's KHO series
> ===================================
> 
> Patches 1-12 are cherry-picked from Pratyush Yadav's v1 series
> "kho: make boot time huge page allocation work nicely with KHO" [1],
> which is still under discussion. This series uses functionality from
> those patches -- specifically the meta-data page enumeration via table
> callbacks and the restructured radix tree API. It also extends the
> KHO radix tree with:
> 
>  - A freeze mechanism to lock the tree before serializing for kexec
>    (patch 13).

There were a lot of effort to make KHO stateless and drop the requirement
for finalization/freeze.

Why is this necessary to add a freeze mechanism to kho_radix_tree?
If it's a hard requirement of mshv maybe the freeze part should be handled
there?
 
>  - A crash-kernel-safe variant that memremaps radix nodes for use
>    outside the direct map (patch 14).
> 
> Patch overview
> ==============
> 
> Patches 1-12:  KHO radix tree and memblock changes (from [1])
> Patch 13:      Radix tree freeze and del_key() error reporting

del_key() error reporting sounds like something we'd want to avoid.
del_key() is called on "freeing" path and during error handling, it would
be hard if at all possible to deal with errors from del_key().

> Patch 14:      Crash-kernel-safe radix tree presence check
> Patch 15:      Page tracker using KHO radix tree for deposited pages
> Patch 16:      Debugfs interface for page tracker
> Patches 17-18: Crash MSR reshuffling + crash dump page exclusion
> Patch 19:      Export kexec_in_progress for modules

Isn't there another way to differentiate kexec reboot?

> Patch 20:      Freeze and vacuum partitions across kexec
> 
> Feedback
> ========
> 
> This is an RFC. I am looking for feedback on the overall approach as
> well as the KHO changes (patches 13-14).
> 
> [1] https://lore.kernel.org/linux-mm/20260429133928.850721-1-pratyush@kernel.org/
> 
> Based-on: linux-next/master (next-20260527)

-- 
Sincerely yours,
Mike.

