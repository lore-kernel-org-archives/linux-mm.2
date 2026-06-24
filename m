Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414DDCDE003
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329736B0088; Wed, 24 Jun 2026 06:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9A16B008A; Wed, 24 Jun 2026 06:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EFBE6B008C; Wed, 24 Jun 2026 06:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E815E6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:40:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 738B81A02A9
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:40:09 +0000 (UTC)
X-FDA: 84914461338.14.9D38870
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id D4C6A40006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:40:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XlcuTTL1;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782297607;
	b=UO/NMpER3ta74wqyVQw5Xp3ZvtK/avgJrEpCH+9otIm4VkGp4zM2XXwVkQjvC0y8BPhqAK
	iX5EnGH6F90a2OLniYZAxZXmrbvljaG9qeHtdGI2EYeKqjG08q78epxLMmd9M61/6kCDIe
	sHOcyy4wGch0qHNdt68SK/IiO2BBwx0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782297607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=67dLv1ARffmQNc6drLJbLB9TAVgbqaZwOnvrBi9FNR4=;
	b=AFvi+doWbArwLbEqDagD+W6rUVvu89rZNrJK+nVvEnzWI+iIG6WmFy219naPeyBWPtcwF0
	yQZfmWOCUUGT+CjvUp/5wkohMRdz+LPpqPJl6v4PLGZTESKvjUYY/Rol5fWvAxYCJhNvn9
	9Fx38rRXqP//hrgbN38zvIq0ekrGi4A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=XlcuTTL1;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=67dLv1ARffmQNc6drLJbLB9TAVgbqaZwOnvrBi9FNR4=; b=XlcuTTL1Av9lAVIkaKrdeA2nhx
	B2YDzxqHpmfT6WVITgcX4+PMlKRf/KNGWaSmn4nMdsr4J10VYjuIJs5mStnsPgitvTu3h14MrzsCn
	OgVYVvwWm5jl8Wr+/MwYXAe4sYzJBB2W51V6ICKSx0D0h/6pDdQWvHuhrFp55xuGW/3HlDn0MuzFw
	nMUsU+YSccJkPsawAMe+2s7MYHhhaA7k0VSA5TXJ5wOIf/bF3EEkswH80N0IqfSToLqY5zvdx9q0H
	gyxlg+halBsfr1+oO9mjexIkJBd5BThK8CkunM5eR3BXMT3HKGASMhy9lstNpzYL50SHS70E8NDl8
	gBwCqSnw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wcL1E-002MpD-1q;
	Wed, 24 Jun 2026 10:39:44 +0000
Date: Wed, 24 Jun 2026 03:39:38 -0700
From: Breno Leitao <leitao@debian.org>
To: nao.horiguchi@gmail.com, linmiaohe@huawei.com, david@kernel.org, 
	lance.yang@linux.dev, akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, 
	pratyush@kernel.org
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, rneu@meta.com, 
	riel@surriel.com, caggio@meta.com, kas@kernel.org
Subject: mm/hwpoison: persist poisoned PFN list across kexec via KHO [RFC]
Message-ID: <ajut_LDQGYCShApx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Debian-User: leitao
X-Stat-Signature: 35wwat87trm91k69ddqukkxy563ww4dz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D4C6A40006
X-HE-Tag: 1782297607-52295
X-HE-Meta: U2FsdGVkX186KjAJl2cF8oGFZF7b4z9s8YsI4Mp2VCA9QJ67J10Lufpq3lVbnk0I8uohmVQNzCdfP9K8vZ8o8xlKRB7k2r3PhlBEUXYfd3eh/q0kiWAMAvNm40yAauRpsZxTFGOlTVT25b/2AjMGicB7zHSAuzuo0LvfCBSCPxkx17CdSna+hZFkqaBAx32/P4t+k6CKdVqOe5Pj+ql0jBn4OPjpCOwpbQPzl7UkDUDmW965B7ElwEFZp5Za2xN4r+BRiAualQHlBDQXcaRhZhHikBOtILK6jxO+J1vQUkrHH4bRBm28HOxvrPohegEnAMw0jAb8gGWB01VkGEnULCLP3sqLvWIj5fcOweiZ771EbJiWspeGAPSSzwL4qbYJbP2cfv4IqnvOKDU89IHHMWqPeiLbV9CI3l00dUJj2XHuBzNeMUzWNzV5nhGhxD/oP2coR9MiwApgNtTackm2WlwLKIWlxxdj7u1n2sfV+EywwOtnxlZzf9xRISJE/PgB7zFoLotJnBSRcPdge3ZaNxYReKtNG0xnUY8gjnsciuy0qb+Mk4GqlgJJD0WoZ5PgNobXTEpOL3YUVlYNyY3VYeXifmHZyYdiqWVqviRZjMS2nmAv4w5PNYtEfNSoDVGrQPMWeGXnw8/J8m417Z56IebgBgadNr+zSkDl8+0ItHaqL1UwwNpiwnpfuwOmwM16n4yii5Z17iH9widwhl2BawooB/f3bYQqNfHMY9WwnRPiKX6WOZDMgkJGSxz4MGMzV9NOC3Reuf/+Yo90ViOYdbaU7K/mbQx6DqshmXJXjLiapyAfiQ/+mRvfR+cqK9D5y/mrsCxJ5V1u4tUo5m57FAqZoBVuSNk54VIIFzypmq8OCELu+25PAfHPANqysq1MhYu/f+Cy5klaLEMNfsI/zjprTtCwNfsWcEWATuPBC2SU1Inf6VhvTamQQdZgjpR3iSaqHOqsv3ckS0MwOPv
 HOXos957
 7PneM1Y6cg7kPH/NK/StFF5/aGeoEPaj8JONfBmoXDBwCdqXr5vtoI2mk5xay3+NdLQ5OQE4B0/dCZNyxfbueTzr9z/GOIgWlKpIshgIiZ+i4ShvDLEPF8/E3bZnh5DMEJm0HxtIUC7C0MNK2ZKEqnXVAV9tRVxbhnpwp+EkZNONBWuIcsLzjUJuOzyeMadHFGCtlLG7IKA1oeUjx0eCOOwmPbOyh+/QwT+FKRRKBlxL3ItqiHBDWTL587yqRetgOZAxXTzl+OogQbH4EFVl813PDs+AzsLO0ER250Jg1apBilmWeVzpRKlJ8pxsDaWi652aaG5+8etH8O7GV0fNgsWP574feqty21E3eG0uOvx/NwloL0+fkVnSamVZleljAcgptgVS8J20xLao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR: carry the hardware-poisoned page list across kexec using KHO, so the
next kernel doesn't hand out known-bad RAM.

The problem
===========

When a page is hard-offlined due to an uncorrectable memory error (multi bit
ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from the buddy
allocator and accounts it in num_poisoned_pages / HardwareCorrupted. All of
that lives in the running kernel's data structures, not in the hardware.

A kexec replaces the kernel image but not the physical DRAM. The next kernel
rebuilds mem_map[] from the firmware-provided memory map, sees the bad frame as
ordinary system RAM, and the buddy allocator hands it back out on the next
kernel. The known-bad cell is silently back in circulation, and the next
access faults again - potentially in a context that is harder to recover than
the original (e.g. a kernel allocation rather than a killable user page).

This matters most where kexec is frequent and machines are long-lived: live
kernel update on large fleets. Poison knowledge accumulates over uptime and is
thrown away on every update.

This is the case at Meta and in many hyperscalers.


Possible solutions
==================

1. Do nothing (status quo). The next kernel hands out known-bad
   RAM, and hope for the best. 

2. e820 / EFI memory map (E820_TYPE_UNUSABLE). Tempting because the
   frame would simply never become RAM (no allocator race at all).
   But: it is x86-only (no arm64 equivalent in the same mechanism;
   this series is tested on arm64);

3. Firmware / platform page retirement (PPR, BMC page-offline, CXL
   device poison lists). This is the correct layer for *cross power
   cycle* persistence and is complementary to this work. But it is
   per-platform, out of OS control, not universally available, and
   cannot carry OS-discovered or software-simulated poison
   (MADV_HWPOISON, the injector). kexec can also happen long before
   firmware retirement takes effect.

4. reserve_mem= / memmap= on the command line. Automatically sent reserved_mem=
   for the next kexec kernel cmdline.

5. A bespoke kexec segment / setup_data blob. This reinvents what
   KHO already provides - preserved memory plus an FDT handoff to
   the next kernel - which is the upstream-blessed generic mechanism
   for exactly this kind of state.

This PoC
========

  * Makes hardware-poisoned pages survive a kexec, using KHO (Kexec
    HandOver) to carry the poison list between kernels.

  * Producer: hooks num_poisoned_pages_inc()/_sub() - the single
    chokepoint for every poison/unpoison event - and records each
    poisoned PFN into a vmalloc array that KHO preserves across the
    kexec, described by a small versioned "hwpoison" subtree.

  * Consumer: early in the next boot (fs_initcall_sync, before the
    buddy allocator has handed anything out) it restores that array
    and re-runs memory_failure() on each PFN, re-offlining the frame
    and rebuilding the full hwpoison state (PG_hwpoison, counters,
    HardwareCorrupted).

  * The replay feeds back through the producer, so the list
    re-publishes itself and survives an arbitrary chain of kexecs.


Open questions
==============

  * Is there any alternative I am not seeing?

  * Is a dedicated "hwpoison" subtree the right granularity, or
    should this live under a broader RAS/KHO umbrella?

  * Trusting the inherited list: should the next kernel bound the count /
    validate PFNs against its own memory map before replaying?

Limitations
===========

  * Poison events before KHO init (fs_initcall) cannot be published;
    academic in practice as MCEs do not fire that early.

  * Per-page only. Cross-power-cycle retirement of a whole DIMM
    is not covered.

I've got a PoC working, and it is available in here, in case you are interested
in the details I am playing with

  https://github.com/leitao/linux/tree/b4/hwpoison

